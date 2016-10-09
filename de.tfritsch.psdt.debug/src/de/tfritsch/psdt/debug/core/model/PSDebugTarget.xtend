/*******************************************************************************
 * Copyright (C) 2016  Thomas Fritsch.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 ******************************************************************************/
package de.tfritsch.psdt.debug.core.model

import com.google.inject.Inject
import de.tfritsch.psdt.debug.Debug
import de.tfritsch.psdt.debug.PSPlugin
import de.tfritsch.psdt.debug.core.launch.PSSourceMapping
import java.util.List
import org.eclipse.core.resources.IMarkerDelta
import org.eclipse.core.runtime.CoreException
import org.eclipse.core.runtime.Path
import org.eclipse.core.variables.IStringVariableManager
import org.eclipse.debug.core.DebugEvent
import org.eclipse.debug.core.DebugException
import org.eclipse.debug.core.DebugPlugin
import org.eclipse.debug.core.IBreakpointManager
import org.eclipse.debug.core.IExpressionManager
import org.eclipse.debug.core.IExpressionsListener
import org.eclipse.debug.core.ILaunch
import org.eclipse.debug.core.model.IBreakpoint
import org.eclipse.debug.core.model.IDebugTarget
import org.eclipse.debug.core.model.IExpression
import org.eclipse.debug.core.model.ILineBreakpoint
import org.eclipse.debug.core.model.IProcess
import org.eclipse.debug.core.model.IVariable
import org.eclipse.debug.core.model.IWatchExpression
import org.eclipse.debug.core.model.IWatchExpressionListener
import org.eclipse.jface.preference.IPreferenceStore

import static extension de.tfritsch.psdt.debug.PSLaunchExtensions.*

/**
 * @author Thomas Fritsch - initial API and implementation
 */
class PSDebugTarget extends PSDebugElement implements IDebugTarget, IExpressionsListener, IPSDebugStreamListener, IPSDebugElementFactory {

	private static enum State {
		CREATED,
		SUSPENDED,
		RESUMED,
		TERMINATED,
		STEPPING_INTO,
		STEPPING_OVER,
		STEPPING_RETURN
	}

	@Inject @Debug IPreferenceStore preferenceStore
	@Inject IBreakpointManager breakpointManager
	@Inject IExpressionManager expressionManager
	@Inject DebugPlugin debugPlugin
	@Inject extension IStringVariableManager

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

	/**
	 * Ghostscript's top-level variables (dictstack, execstack, operandstack, ...)
	 */
	IVariable[] variables

	int currentTokenIndex

	PSSourceMapping sourceMapping

	IPSDebugCommander debugCommander

	extension StatusParser = new StatusParser(this)

	extension ChangeMarker = new ChangeMarker

	new() {
		super(null)
	}

	/**
	 * Initialize (needed before {@link ILaunch#addDebugTarget})
	 * @param process
	 *            the system process associated with this target
	 * @throws CoreException 
	 */
	def void init(IProcess process, PSSourceMapping sourceMapping) throws CoreException {
		this.process = process
		sourceName = launch.launchConfiguration.program.performStringSubstitution
		breakOnFirstToken = launch.launchConfiguration.breakOnFirstToken
		this.sourceMapping = sourceMapping
		breakpointManager.addBreakpointListener(this)
		expressionManager.addExpressionListener(this)
		debugPlugin.addDebugEventListener [ events |
			for (event : events) {
				if (event.source === process && event.kind === DebugEvent.TERMINATE) {
					onTerminated
					debugPlugin.removeDebugEventListener(self)
				}
			}
		]
		debugCommander = process.streamsProxy as IPSDebugCommander
		debugCommander.debugStreamListener = this
	}

	def private void installDeferredBreakpoints() {
		val breakpoints = breakpointManager.getBreakpoints(modelIdentifier)
		for (breakpoint : breakpoints) {
			breakpointAdded(breakpoint)
		}
	}

	def private void installWatches() {
		val watches = expressionManager.expressions //
		.filter(IWatchExpression).map[expressionText]
		debugCommander.watches = watches
	}

	override statusReceived(List<String> lines) {
		val newVariables = lines.toVariables
		if (variables !== null)
			newVariables.markChangesRelativeTo(variables)
		variables = newVariables
		val detail = if(stepping) DebugEvent.STEP_END else DebugEvent.BREAKPOINT
		state = State.SUSPENDED
		fireSuspendEvent(detail)
		thread.fireSuspendEvent(detail)
	}

	override resumeReceived() {
		// do nothing
	}

	override breakReceived(int depth, int ref, String value) {
		currentTokenIndex = ref
		debug("       " + currentTokenIndex) //$NON-NLS-1$
		PSDebugCommander.hideDicts(!preferenceStore.showSystemdict, !preferenceStore.showGlobaldict,
			!preferenceStore.showUserdict)
		try {
			switch (state) {
				case CREATED: {
					installDeferredBreakpoints
					installWatches
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

	override breakReceived(int depth) {
		// do nothing
	}

	override protected getPSDebugCommander() {
		debugCommander
	}

	/**
	 * Called when this debug target terminates.
	 */
	def private void onTerminated() {
		state = State.TERMINATED
		breakpointManager.removeBreakpointListener(this)
		expressionManager.removeExpressionListener(this)
		fireTerminateEvent
	}

	def IBreakpoint[] getBreakpoints() {
		breakpointManager.breakpoints.filter[supportsBreakpoint]
	}

	def int getLineNumber() {
		sourceMapping.getLineNumber(currentTokenIndex)
	}

	def int getCharStart() {
		sourceMapping.getCharStart(currentTokenIndex)
	}

	def int getCharEnd() {
		sourceMapping.getCharEnd(currentTokenIndex)
	}

	def String getSourceName() {
		sourceName
	}

	def IVariable[] getVariables() throws DebugException {
		variables?:newArrayOfSize(0)
	}

	def boolean isStepping() {
		switch (state) {
			case STEPPING_INTO,
			case STEPPING_OVER,
			case STEPPING_RETURN:
				true
			default:
				false
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

	override getDebugTarget() {
		this
	}

	override getLaunch() {
		process.launch
	}

	override getName() {
		sourceName
	}

	override getProcess() {
		process
	}

	override getThreads() throws DebugException {
		#[thread]
	}

	override hasThreads() throws DebugException {
		!terminated
	}

	override supportsBreakpoint(IBreakpoint breakpoint) {
		breakpoint.modelIdentifier == modelIdentifier &&
			breakpoint.marker.resource.location == new Path(sourceName)
	}

	override canTerminate() {
		process.canTerminate
	}

	override isTerminated() {
		process.terminated
	}

	override terminate() throws DebugException {
		debug("GUI -> terminate") //$NON-NLS-1$
		process.terminate
	}

	override canResume() {
		!terminated && suspended
	}

	override canSuspend() {
		false // not supported
	}

	override isSuspended() {
		state == State.SUSPENDED
	}

	override resume() throws DebugException {
		debug("GUI -> resume") //$NON-NLS-1$
		state = State.RESUMED
		currentTokenIndex = -1
		fireResumeEvent(DebugEvent.CLIENT_REQUEST)
		thread.fireResumeEvent(DebugEvent.CLIENT_REQUEST)
		PSDebugCommander.singleStep = false
		PSDebugCommander.resume
	}

	override suspend() throws DebugException {
		debug("GUI -> suspend") //$NON-NLS-1$

		// TODO PSDebugTarget.suspend
		notSupported("suspend", null) //$NON-NLS-1$
	}

	override breakpointAdded(IBreakpoint breakpoint) {
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

	override breakpointChanged(IBreakpoint breakpoint, IMarkerDelta delta) {
		debug("GUI -> breakpointChanged " + breakpoint) //$NON-NLS-1$
		try {
			if (breakpoint.enabled)
				breakpointAdded(breakpoint)
			else
				breakpointRemoved(breakpoint, delta)
		} catch (CoreException e) {
			PSPlugin.log(e)
		}
	}

	override breakpointRemoved(IBreakpoint breakpoint, IMarkerDelta delta) {
		debug("GUI -> breakpointRemoved " + breakpoint) //$NON-NLS-1$
		if (supportsBreakpoint(breakpoint)) {
			try {
				val lineNumber = (breakpoint as ILineBreakpoint).lineNumber
				for (i : 0 ..< sourceMapping.size) {
					if (sourceMapping.getLineNumber(i) == lineNumber) {
						debugCommander.removeBreakpoint(i)
						if (delta == null)
							breakpoint.delete
					}
				}
			} catch (CoreException e) {
				PSPlugin.log(e)
			}
		}
	}

	override canDisconnect() {
		false // not supported
	}

	override disconnect() throws DebugException {
		debug("GUI -> disconnect") //$NON-NLS-1$
		notSupported("disconnect", null) //$NON-NLS-1$
	}

	override isDisconnected() {
		false
	}

	override getMemoryBlock(long startAddress, long length) throws DebugException {
		notSupported("getMemoryBlock", null) //$NON-NLS-1$
		null
	}

	override supportsStorageRetrieval() {
		false
	}

	override createVariable(String name, PSValue value) {
		new PSVariable(this, name, value)
	}

	override createIndexedValue(String valueString) {
		new PSIndexedValue(this, valueString)
	}

	override createValue(String valueString) {
		new PSValue(this, valueString)
	}

	def void evaluateExpression(String expression, IWatchExpressionListener listener) {
		debugPlugin.asyncExec[
			val result = try {
				val watches = variables.findFirst[name == "watches"].value
				val value = watches.variables.findFirst[name == expression]?.value
				new PSWatchExpressionResult(expression, value, null)
			} catch(DebugException e) {
				new PSWatchExpressionResult(expression, null, e)
			}
			listener.watchEvaluationFinished(result)
		]
	}

	override expressionsAdded(IExpression[] expressions) {
		installWatches
		debugCommander.requestStatus
	}

	override expressionsChanged(IExpression[] expressions) {
		installWatches
		debugCommander.requestStatus
	}

	override expressionsRemoved(IExpression[] expressions) {
		installWatches
		debugCommander.requestStatus
	}

}
