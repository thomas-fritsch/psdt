package de.tfritsch.psdt.debug.model

import org.eclipse.debug.core.DebugException
import org.eclipse.debug.core.model.IBreakpoint
import org.eclipse.debug.core.model.IStackFrame
import org.eclipse.debug.core.model.IThread

/**
 * A PostScript VM thread.  Since there is only one single
 * thread in the PostScript VM most methods of this
 * class simply delegate to {@link PSDebugTarget}.
 */
class PSThread extends PSDebugElement implements IThread {

	IStackFrame stackFrame

	/**
	 * Constructs a new thread for the given target.
	 * 
	 * @param target
	 *            debug target containing this thread
	 */
	new(PSDebugTarget target) {
		super(target)
		stackFrame = new PSStackFrame(this)
	}

	@SuppressWarnings("rawtypes")
	override Object getAdapter(Class adapter) {
		return switch (adapter) {
			case IStackFrame:
				topStackFrame
			default:
				super.getAdapter(adapter)
		}
	}

	override IBreakpoint[] getBreakpoints() {
		return PSDebugTarget.breakpoints
	}

	override String getName() {
		return "main" //$NON-NLS-1$
	}

	override int getPriority() {
		return 0
	}

	override IStackFrame[] getStackFrames() {
		return if(suspended) #[stackFrame] else #[]
	}

	override IStackFrame getTopStackFrame() {
		val frames = stackFrames
		return if(frames.length > 0) frames.get(0) else null
	}

	override boolean hasStackFrames() throws DebugException {
		return suspended
	}

	override boolean canStepInto() {
		return suspended && !stepping
	}

	override boolean canStepOver() {
		return suspended && !stepping
	}

	override boolean canStepReturn() {
		return suspended && !stepping
	}

	override boolean isStepping() {
		return PSDebugTarget.stepping
	}

	override void stepInto() throws DebugException {
		PSDebugTarget.stepInto
	}

	override void stepOver() throws DebugException {
		PSDebugTarget.stepOver
	}

	override void stepReturn() throws DebugException {
		PSDebugTarget.stepReturn
	}

	override boolean canResume() {
		return debugTarget.canResume
	}

	override boolean canSuspend() {
		return debugTarget.canSuspend
	}

	override boolean isSuspended() {
		return debugTarget.suspended
	}

	override void resume() throws DebugException {
		debugTarget.resume
	}

	override void suspend() throws DebugException {
		debugTarget.suspend
	}

	override boolean canTerminate() {
		return debugTarget.canTerminate
	}

	override boolean isTerminated() {
		return debugTarget.terminated
	}

	override void terminate() throws DebugException {
		debugTarget.terminate
	}
}