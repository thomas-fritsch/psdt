package de.tfritsch.psdt.debug.model;

import java.util.Collections;
import java.util.List;

import org.eclipse.core.resources.IMarkerDelta;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.Path;
import org.eclipse.debug.core.DebugEvent;
import org.eclipse.debug.core.DebugException;
import org.eclipse.debug.core.DebugPlugin;
import org.eclipse.debug.core.ILaunch;
import org.eclipse.debug.core.model.IBreakpoint;
import org.eclipse.debug.core.model.IDebugTarget;
import org.eclipse.debug.core.model.ILineBreakpoint;
import org.eclipse.debug.core.model.IMemoryBlock;
import org.eclipse.debug.core.model.IProcess;
import org.eclipse.debug.core.model.IThread;
import org.eclipse.debug.core.model.IVariable;

import de.tfritsch.psdt.debug.IPSConstants;


/**
 * PostScript Debug Target
 */
class PSDebugTarget extends PSDebugElement implements IDebugTarget,
		IPSDebugStreamListener {

	private static enum State {
		CREATED, SUSPENDED, RESUMED, TERMINATED,
		STEPPING_INTO, STEPPING_OVER, STEPPING_RETURN
	}

	/**
	 * The ghostscript process
	 */
	private IProcess fProcess;

	private String fSourceName;

	private State fState = State.CREATED;

	/**
	 * The single ghostscript thread
	 */
	private PSThread fThread;

	private IBreakpoint[] fBreakpoints;

	/**
	 * Container for ghostscript's top-level variables (dictstack, execstack,
	 * operandstack, ...)
	 */
	private IVariable[] fVariables;

	private PSToken fCurrentToken;
	
	private List<PSToken> fTokens;
	
	private IPSDebugCommander fDebugCommander;

	/**
	 * 
	 * @param process
	 *            the system process associated with this target
	 * @throws CoreException 
	 */
	PSDebugTarget(IProcess process, String sourceName, List<PSToken> tokens) throws CoreException {
		super(null);
		fProcess = process;
		fSourceName = sourceName;
		fThread = new PSThread(this);
		fBreakpoints = new IBreakpoint[0];
		fTokens = tokens;
		DebugPlugin.getDefault().getBreakpointManager().addBreakpointListener(
				this);
		fDebugCommander = (IPSDebugCommander) process.getStreamsProxy();
		fDebugCommander.setDebugStreamListener(this);
		boolean breakOnFirstToken = getLaunch().getLaunchConfiguration()
				.getAttribute(IPSConstants.ATTR_BREAK_ON_FIRST_TOKEN, false);
		if (breakOnFirstToken)
			fDebugCommander.addBreakpoint(0);
		installDeferredBreakpoints();

		Thread inputThread = new Thread("PostScript %stdin feeder") { //$NON-NLS-1$
			@Override
			public void run() {
				try {
					fDebugCommander.hideDicts(true, false, false);
					fDebugCommander.sendInstrumentedCode(fTokens);
				} catch (DebugException e) {
					terminated();
				}
			}
		};
		inputThread.setDaemon(true);
		inputThread.start();
	}

	private void installDeferredBreakpoints() {
		IBreakpoint[] breakpoints = DebugPlugin.getDefault().getBreakpointManager()
				.getBreakpoints(getModelIdentifier());
		for (IBreakpoint breakpoint : breakpoints) {
			breakpointAdded(breakpoint);
		}
	}

	private IVariable[] convertStatus(List<StatusLine> lines) {
		PSValue[] values = new PSValue[20];
		values[0] = new PSValue(this, ""); //$NON-NLS-1$
		for (StatusLine line : lines) {
			PSValue value = new PSIndexedValue(this, line.getValue());
			PSVariable variable = new PSVariable(this, line.getName(), value);
			int depth = line.getDepth();
			values[depth - 1].addVariable(variable);
			values[depth] = value;			
		}
		return values[0].getVariables();
	}

    //@Override
	public void statusReceived(List<StatusLine> lines) {
		fVariables = convertStatus(lines);
		int detail = isStepping() ? DebugEvent.STEP_END : DebugEvent.BREAKPOINT;
		fState = State.SUSPENDED;
		fireSuspendEvent(detail);
		fThread.fireSuspendEvent(detail);
	}

	//@Override
	public void resumeReceived() {
		// do nothing
	}

	//@Override
	public void breakReceived(int depth, int ref, String value) {
		fCurrentToken = fTokens.get(ref);
		debug("       " + fCurrentToken); //$NON-NLS-1$
		fVariables = null;
		try {
			switch (fState) {
			case STEPPING_INTO:
				getPSDebugCommander().requestStatus();
				break;
			case STEPPING_OVER:
				getPSDebugCommander().sendCommand("countexecstack @@e le {@@status} {@@resume} ifelse"); //$NON-NLS-1$
				break;
			case STEPPING_RETURN:
				getPSDebugCommander().sendCommand("countexecstack @@e lt {@@status} {@@resume} ifelse"); //$NON-NLS-1$
				break;
			default:
				getPSDebugCommander().requestStatus();
				break;
			}
		} catch (DebugException e) {
			DebugPlugin.log(e);
			statusReceived(Collections.<StatusLine> emptyList());
		}
	}

	//@Override
	public void breakReceived(int depth) {
		// do nothing
	}
	
	@Override
	IPSDebugCommander getPSDebugCommander() {
		return fDebugCommander;
	}
	
	/**
	 * Called when this debug target terminates.
	 */
	private void terminated() {
		fState = State.TERMINATED;
		DebugPlugin.getDefault().getBreakpointManager()
				.removeBreakpointListener(this);
		fireTerminateEvent();
	}

    IBreakpoint[] getBreakpoints() {
		return fBreakpoints;
	}

	PSToken getCurrentToken() {
		return fCurrentToken;
	}
	
	String getSourceName() {
		return fSourceName;
	}
	
	IVariable[] getVariables() throws DebugException {
		if (fVariables == null) {
			return new IVariable[0];
		}
		return fVariables;
	}

	boolean isStepping() {
		switch (fState) {
		case STEPPING_INTO:
		case STEPPING_OVER:
		case STEPPING_RETURN:
			return true;
		default:
			return false;
		}
	}
	
	void stepInto() throws DebugException {
		debug("GUI -> stepInto"); //$NON-NLS-1$
		fState = State.STEPPING_INTO;
		step(DebugEvent.STEP_INTO);
	}
	
	void stepOver() throws DebugException {
		debug("GUI -> stepOver"); //$NON-NLS-1$
		fState = State.STEPPING_OVER;
		step(DebugEvent.STEP_OVER);
	}
	
	void stepReturn() throws DebugException {
		debug("GUI -> stepReturn"); //$NON-NLS-1$
		fState = State.STEPPING_RETURN;
		step(DebugEvent.STEP_RETURN);
	}

	private void step(int detail) throws DebugException {
		fCurrentToken = null;
		fireResumeEvent(detail);
		fThread.fireResumeEvent(detail);
		getPSDebugCommander().sendCommand("globaldict /@@e countexecstack put"); //$NON-NLS-1$
		getPSDebugCommander().setSingleStep(true);
		getPSDebugCommander().resume();
	}

	@Override
	public IDebugTarget getDebugTarget() {
		return this;
	}

	@Override
	public ILaunch getLaunch() {
		return getProcess().getLaunch();
	}

	//@Override
	public String getName() {
		return fSourceName;
	}

	//@Override
	public IProcess getProcess() {
		return fProcess;
	}

	//@Override
	public IThread[] getThreads() throws DebugException {
		return new IThread[] { fThread };
	}

	//@Override
	public boolean hasThreads() throws DebugException {
		return !isTerminated();
	}

	//@Override
	public boolean supportsBreakpoint(IBreakpoint breakpoint) {
		return breakpoint.getModelIdentifier().equals(getModelIdentifier()) &&
				breakpoint.getMarker().getResource().getLocation().equals(new Path(fSourceName));
	}

	//@Override
	public boolean canTerminate() {
		return getProcess().canTerminate();
	}

	//@Override
	public boolean isTerminated() {
		return getProcess().isTerminated();
	}

	//@Override
	public void terminate() throws DebugException {
		debug("GUI -> terminate"); //$NON-NLS-1$
		getProcess().terminate();
		fState = State.TERMINATED;
		terminated();
	}

	//@Override
	public boolean canResume() {
		return !isTerminated() && isSuspended();
	}

	//@Override
	public boolean canSuspend() {
		return false; // not supported
	}

	//@Override
	public boolean isSuspended() {
		return fState == State.SUSPENDED;
	}

	//@Override
	public void resume() throws DebugException {
		debug("GUI -> resume"); //$NON-NLS-1$
		fState = State.RESUMED;
		fCurrentToken = null;
		fireResumeEvent(DebugEvent.CLIENT_REQUEST);
		fThread.fireResumeEvent(DebugEvent.CLIENT_REQUEST);
		getPSDebugCommander().setSingleStep(false);
		getPSDebugCommander().resume();
	}

	//@Override
	public void suspend() throws DebugException {
		debug("GUI -> suspend"); //$NON-NLS-1$
		// TODO PSDebugTarget.suspend
		notSupported("suspend", null); //$NON-NLS-1$
	}

	//@Override
	public void breakpointAdded(IBreakpoint breakpoint) {
		debug("GUI -> breakpointAdded " + breakpoint); //$NON-NLS-1$
		if (supportsBreakpoint(breakpoint)) {
			try {
				int lineNumber = ((ILineBreakpoint)breakpoint).getLineNumber();
				boolean enabled = breakpoint.isEnabled();
				for (int i = 0; i < fTokens.size(); i++) {
					PSToken token = fTokens.get(i);
					if (enabled && token.getLineNumber() == lineNumber)
						fDebugCommander.addBreakpoint(i);
				}
			} catch (CoreException e) {
			}
		}
	}

	//@Override
	public void breakpointChanged(IBreakpoint breakpoint, IMarkerDelta delta) {
		debug("GUI -> breakpointChanged " + breakpoint); //$NON-NLS-1$
		if (supportsBreakpoint(breakpoint)) {
			try {
				if (breakpoint.isEnabled()) {
					breakpointAdded(breakpoint);
				} else {
					breakpointRemoved(breakpoint, null);
				}
			} catch (CoreException e) {
			}
		}
	}

	//@Override
	public void breakpointRemoved(IBreakpoint breakpoint, IMarkerDelta delta) {
		debug("GUI -> breakpointRemoved " + breakpoint); //$NON-NLS-1$
		if (supportsBreakpoint(breakpoint)) {
			try {
				int lineNumber = ((ILineBreakpoint)breakpoint).getLineNumber();
				for (int i = 0; i < fTokens.size(); i++) {
					PSToken token = fTokens.get(i);
					if (token.getLineNumber() == lineNumber)
						fDebugCommander.removeBreakpoint(i);
				}
			} catch (CoreException e) {
			}
		}
	}

	//@Override
	public boolean canDisconnect() {
		return false; // not supported
	}

	//@Override
	public void disconnect() throws DebugException {
		debug("GUI -> disconnect"); //$NON-NLS-1$
		notSupported("disconnect", null); //$NON-NLS-1$
	}

	//@Override
	public boolean isDisconnected() {
		return false;
	}

	//@Override
	public IMemoryBlock getMemoryBlock(long startAddress, long length)
			throws DebugException {
		notSupported("getMemoryBlock", null); //$NON-NLS-1$
		return null;
	}

	//@Override
	public boolean supportsStorageRetrieval() {
		return false;
	}
}
