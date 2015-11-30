package de.tfritsch.psdt.debug.model;

import org.eclipse.debug.core.DebugException;
import org.eclipse.debug.core.model.IBreakpoint;
import org.eclipse.debug.core.model.IStackFrame;
import org.eclipse.debug.core.model.IThread;

/**
 * A PostScript VM thread.  Since there is only one single
 * thread in the PostScript VM most methods of this
 * class simply delegate to {@link PSDebugTarget}.
 */
class PSThread extends PSDebugElement implements IThread {
	private IStackFrame fStackFrame;
	
	/**
	 * Constructs a new thread for the given target.
	 * 
	 * @param target
	 *            debug target containing this thread
	 */
	PSThread(PSDebugTarget target) {
		super(target);
		fStackFrame = new PSStackFrame(this);
	}

	@Override
    @SuppressWarnings("rawtypes")
	public Object getAdapter(Class adapter) {
		if (adapter == IStackFrame.class) {
			return getTopStackFrame();
		}
		return super.getAdapter(adapter);
	}

	@Override
	public IBreakpoint[] getBreakpoints() {
		return getPSDebugTarget().getBreakpoints();
	}

	@Override
	public String getName() {
		return "main"; //$NON-NLS-1$
	}

	@Override
	public int getPriority() {
		return 0;
	}

	@Override
	public IStackFrame[] getStackFrames() {
		if (isSuspended()) {
			return new IStackFrame[] { fStackFrame };
		} else {
			return new IStackFrame[0];
		}
	}

	@Override
	public IStackFrame getTopStackFrame() {
		IStackFrame[] frames = getStackFrames();
		if (frames.length > 0) {
			return frames[0];
		}
		return null;
	}

	@Override
	public boolean hasStackFrames() throws DebugException {
		return isSuspended();
	}

	@Override
	public boolean canStepInto() {
		return isSuspended() && !isStepping();
	}

	@Override
	public boolean canStepOver() {
		return isSuspended() && !isStepping();
	}

	@Override
	public boolean canStepReturn() {
		return isSuspended() && !isStepping();
	}

	@Override
	public boolean isStepping() {
		return getPSDebugTarget().isStepping();
	}

	@Override
	public void stepInto() throws DebugException {
		getPSDebugTarget().stepInto();
	}

	@Override
	public void stepOver() throws DebugException {
		getPSDebugTarget().stepOver();
	}

	@Override
	public void stepReturn() throws DebugException {
		getPSDebugTarget().stepReturn();
	}

	@Override
	public boolean canResume() {
		return getDebugTarget().canResume();
	}

	@Override
	public boolean canSuspend() {
		return getDebugTarget().canSuspend();
	}

	@Override
	public boolean isSuspended() {
		return getDebugTarget().isSuspended();
	}

	@Override
	public void resume() throws DebugException {
		getDebugTarget().resume();
	}

	@Override
	public void suspend() throws DebugException {
		getDebugTarget().suspend();
	}

	@Override
	public boolean canTerminate() {
		return getDebugTarget().canTerminate();
	}

	@Override
	public boolean isTerminated() {
		return getDebugTarget().isTerminated();
	}

	@Override
	public void terminate() throws DebugException {
		getDebugTarget().terminate();
	}
}
