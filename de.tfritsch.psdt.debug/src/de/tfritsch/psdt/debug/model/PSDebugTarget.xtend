package de.tfritsch.psdt.debug.model

import de.tfritsch.psdt.debug.PSPlugin
import java.util.List
import org.eclipse.core.resources.IMarkerDelta
import org.eclipse.core.runtime.CoreException
import org.eclipse.core.runtime.Path
import org.eclipse.debug.core.DebugEvent
import org.eclipse.debug.core.DebugException
import org.eclipse.debug.core.DebugPlugin
import org.eclipse.debug.core.ILaunch
import org.eclipse.debug.core.model.IBreakpoint
import org.eclipse.debug.core.model.IDebugTarget
import org.eclipse.debug.core.model.ILineBreakpoint
import org.eclipse.debug.core.model.IMemoryBlock
import org.eclipse.debug.core.model.IProcess
import org.eclipse.debug.core.model.IThread
import org.eclipse.debug.core.model.IVariable

import static extension de.tfritsch.psdt.debug.LaunchExtensions.*
import static extension de.tfritsch.psdt.debug.PSLaunchExtensions.*

class PSDebugTarget extends PSDebugElement implements IDebugTarget, IPSDebugStreamListener {

	private static enum State {
		CREATED,
		SUSPENDED,
		RESUMED,
		TERMINATED,
		STEPPING_INTO,
		STEPPING_OVER,
		STEPPING_RETURN
	}

	/**
	 * The ghostscript process
	 */
	IProcess process

	String sourceName

	State state = State.CREATED

	/**
	 * The single ghostscript thread
	 */
	PSThread thread = new PSThread(this)

	boolean breakOnFirstToken

	IBreakpoint[] breakpoints = #[]

	/**
	 * Ghostscript's top-level variables (dictstack, execstack, operandstack, ...)
	 */
	IVariable[] variables

	int currentTokenIndex

	PSSourceMapping sourceMapping

	IPSDebugCommander debugCommander

	extension StatusParser = new StatusParser(this)

	/**
	 * 
	 * @param process
	 *            the system process associated with this target
	 * @throws CoreException 
	 */
	new(IProcess process, PSSourceMapping sourceMapping) throws CoreException {
		super(null)
		this.process = process
		sourceName = launch.launchConfiguration.program.performStringSubstitution
		breakOnFirstToken = launch.launchConfiguration.breakOnFirstToken
		this.sourceMapping = sourceMapping
		DebugPlugin.^default.breakpointManager.addBreakpointListener(this)
		debugCommander = process.streamsProxy as IPSDebugCommander
		debugCommander.debugStreamListener = this
	}

	def private void installDeferredBreakpoints() {
		val breakpoints = DebugPlugin.^default.breakpointManager.getBreakpoints(modelIdentifier)
		for (breakpoint : breakpoints) {
			breakpointAdded(breakpoint)
		}
	}

	override void statusReceived(List<String> lines) {
		variables = lines.toVariables
		val detail = if(stepping) DebugEvent.STEP_END else DebugEvent.BREAKPOINT
		state = State.SUSPENDED
		fireSuspendEvent(detail)
		thread.fireSuspendEvent(detail)
	}

	override void resumeReceived() {
		// do nothing
	}

	override void breakReceived(int depth, int ref, String value) {
		currentTokenIndex = ref
		debug("       " + currentTokenIndex) //$NON-NLS-1$
		variables = null
		try {
			switch (state) {
				case CREATED: {
					installDeferredBreakpoints
					if (breakOnFirstToken)
						PSDebugCommander.requestStatus
					else
						resume
				}
				case STEPPING_INTO:
					PSDebugCommander.requestStatus
				case STEPPING_OVER:
					PSDebugCommander.sendCommand("countexecstack @@e le {@@status} {@@resume} ifelse") //$NON-NLS-1$
				case STEPPING_RETURN:
					PSDebugCommander.sendCommand("countexecstack @@e lt {@@status} {@@resume} ifelse") //$NON-NLS-1$
				default:
					PSDebugCommander.requestStatus
			}
		} catch (DebugException e) {
			PSPlugin.log(e)
			statusReceived(emptyList)
		}
	}

	override void breakReceived(int depth) {
		// do nothing
	}

	override protected IPSDebugCommander getPSDebugCommander() {
		return debugCommander
	}

	/**
	 * Called when this debug target terminates.
	 */
	def private void onTerminated() {
		state = State.TERMINATED
		DebugPlugin.^default.breakpointManager.removeBreakpointListener(this)
		fireTerminateEvent
	}

	def IBreakpoint[] getBreakpoints() {
		return breakpoints
	}

	def int getLineNumber() {
		return sourceMapping.getLineNumber(currentTokenIndex)
	}

	def int getCharStart() {
		return sourceMapping.getCharStart(currentTokenIndex)
	}

	def int getCharEnd() {
		return sourceMapping.getCharEnd(currentTokenIndex)
	}

	def String getSourceName() {
		return sourceName
	}

	def IVariable[] getVariables() throws DebugException {
		return if(variables !== null) variables else #[]
	}

	def boolean isStepping() {
		switch (state) {
			case STEPPING_INTO,
			case STEPPING_OVER,
			case STEPPING_RETURN:
				return true
			default:
				return false
		}
	}

	def void stepInto() throws DebugException {
		debug("GUI -> stepInto") //$NON-NLS-1$
		state = State.STEPPING_INTO
		step(DebugEvent.STEP_INTO)
	}

	def void stepOver() throws DebugException {
		debug("GUI -> stepOver") //$NON-NLS-1$
		state = State.STEPPING_OVER
		step(DebugEvent.STEP_OVER)
	}

	def void stepReturn() throws DebugException {
		debug("GUI -> stepReturn") //$NON-NLS-1$
		state = State.STEPPING_RETURN
		step(DebugEvent.STEP_RETURN)
	}

	def private void step(int detail) throws DebugException {
		currentTokenIndex = -1
		fireResumeEvent(detail)
		thread.fireResumeEvent(detail)
		PSDebugCommander.sendCommand("globaldict /@@e countexecstack put") //$NON-NLS-1$
		PSDebugCommander.singleStep = true
		PSDebugCommander.resume
	}

	override IDebugTarget getDebugTarget() {
		return this
	}

	override ILaunch getLaunch() {
		return process.launch
	}

	override String getName() {
		return sourceName
	}

	override IProcess getProcess() {
		return process
	}

	override IThread[] getThreads() throws DebugException {
		return #[thread]
	}

	override boolean hasThreads() throws DebugException {
		return !terminated
	}

	override boolean supportsBreakpoint(IBreakpoint breakpoint) {
		return breakpoint.modelIdentifier == modelIdentifier &&
			breakpoint.marker.resource.location == new Path(sourceName)
	}

	override boolean canTerminate() {
		return process.canTerminate
	}

	override boolean isTerminated() {
		return process.terminated
	}

	override void terminate() throws DebugException {
		debug("GUI -> terminate") //$NON-NLS-1$
		process.terminate
		state = State.TERMINATED
		onTerminated
	}

	override boolean canResume() {
		return !terminated && suspended
	}

	override boolean canSuspend() {
		return false // not supported
	}

	override boolean isSuspended() {
		return state == State.SUSPENDED
	}

	override void resume() throws DebugException {
		debug("GUI -> resume") //$NON-NLS-1$
		state = State.RESUMED
		currentTokenIndex = -1
		fireResumeEvent(DebugEvent.CLIENT_REQUEST)
		thread.fireResumeEvent(DebugEvent.CLIENT_REQUEST)
		PSDebugCommander.singleStep = false
		PSDebugCommander.resume
	}

	override void suspend() throws DebugException {
		debug("GUI -> suspend") //$NON-NLS-1$

		// TODO PSDebugTarget.suspend
		notSupported("suspend", null) //$NON-NLS-1$
	}

	override void breakpointAdded(IBreakpoint breakpoint) {
		debug("GUI -> breakpointAdded " + breakpoint) //$NON-NLS-1$
		if (supportsBreakpoint(breakpoint)) {
			try {
				val lineNumber = (breakpoint as ILineBreakpoint).lineNumber
				val enabled = breakpoint.enabled
				var found = false
				for (var i = 0; i < sourceMapping.size && !found; i++) {
					if (enabled && sourceMapping.getLineNumber(i) == lineNumber) {
						debugCommander.addBreakpoint(i)
						found = true // 1 breakpoint per line is enough
					}
				}
			} catch (CoreException e) {
				PSPlugin.log(e)
			}
		}
	}

	override void breakpointChanged(IBreakpoint breakpoint, IMarkerDelta delta) {
		debug("GUI -> breakpointChanged " + breakpoint) //$NON-NLS-1$
		try {
			if (breakpoint.enabled)
				breakpointAdded(breakpoint)
			else
				breakpointRemoved(breakpoint, null)
		} catch (CoreException e) {
			PSPlugin.log(e)
		}
	}

	override void breakpointRemoved(IBreakpoint breakpoint, IMarkerDelta delta) {
		debug("GUI -> breakpointRemoved " + breakpoint) //$NON-NLS-1$
		if (supportsBreakpoint(breakpoint)) {
			try {
				val lineNumber = (breakpoint as ILineBreakpoint).lineNumber
				for (i : 0 ..< sourceMapping.size) {
					if (sourceMapping.getLineNumber(i) == lineNumber) {
						debugCommander.removeBreakpoint(i)
						breakpoint.delete
					}
				}
			} catch (CoreException e) {
				PSPlugin.log(e)
			}
		}
	}

	override boolean canDisconnect() {
		return false // not supported
	}

	override void disconnect() throws DebugException {
		debug("GUI -> disconnect") //$NON-NLS-1$
		notSupported("disconnect", null) //$NON-NLS-1$
	}

	override boolean isDisconnected() {
		return false
	}

	override IMemoryBlock getMemoryBlock(long startAddress, long length) throws DebugException {
		notSupported("getMemoryBlock", null) //$NON-NLS-1$
		return null
	}

	override public boolean supportsStorageRetrieval() {
		return false
	}
}
