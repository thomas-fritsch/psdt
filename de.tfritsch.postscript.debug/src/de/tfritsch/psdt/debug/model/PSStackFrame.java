package de.tfritsch.psdt.debug.model;

import java.io.File;

import org.eclipse.debug.core.DebugException;
import org.eclipse.debug.core.model.IRegisterGroup;
import org.eclipse.debug.core.model.IStackFrame;
import org.eclipse.debug.core.model.IThread;
import org.eclipse.debug.core.model.IVariable;
import org.eclipse.osgi.util.NLS;


/**
 * PostScript VM stack frame. Since there is only one single
 * stack frame in the PostScript VM most methods of this
 * class simply delegate to {@link PSThread}.
 * to 
 */
class PSStackFrame extends PSDebugElement implements IStackFrame {
	private PSThread fThread;

	/**
	 * Constructs a stack frame in the given thread.
	 * 
	 * @param thread
	 *            thread containing this stack frame
	 */
	PSStackFrame(PSThread thread) {
		super(thread.getPSDebugTarget());
		fThread = thread;
	}

	String getSourceName() {
		return getPSDebugTarget().getSourceName();
	}
	
	PSToken getCurrentToken() {
		return getPSDebugTarget().getCurrentToken();
	}

	//@Override
	public int getCharStart() {
		PSToken token = getCurrentToken();
		return (token != null) ? token.getCharStart(): -1;
	}

	//@Override
	public int getCharEnd() {
		PSToken token = getCurrentToken();
		return (token != null) ? token.getCharEnd() : -1;
	}

	//@Override
	public int getLineNumber() {
		PSToken token = getCurrentToken();
		return (token != null) ? token.getLineNumber() : -1;
	}

	//@Override
	public String getName() {
		String s = getSourceName();
		s = s.substring(s.lastIndexOf(File.separatorChar) + 1);
		int line = getLineNumber();
		return NLS.bind("{0}: line {1}", s, new Integer(line));
	}

	//@Override
	public IRegisterGroup[] getRegisterGroups() throws DebugException {
		return new IRegisterGroup[0];
	}

	//@Override
	public IThread getThread() {
		return fThread;
	}

	//@Override
	public IVariable[] getVariables() throws DebugException {
		debug("GUI -> getVariables"); //$NON-NLS-1$
		if (isSuspended())
			return getPSDebugTarget().getVariables();
		else
			return new IVariable[0];
	}

	//@Override
	public boolean hasRegisterGroups() throws DebugException {
		return false;
	}

	//@Override
	public boolean hasVariables() throws DebugException {
		debug("GUI -> PSStackFrame.hasVariables"); //$NON-NLS-1$
		return isSuspended();
	}

	//@Override
	public boolean canStepInto() {
		return getThread().canStepInto();
	}

	//@Override
	public boolean canStepOver() {
		return getThread().canStepOver();
	}

	//@Override
	public boolean canStepReturn() {
		return getThread().canStepReturn();
	}

	//@Override
	public boolean isStepping() {
		return getThread().isStepping();
	}

	//@Override
	public void stepInto() throws DebugException {
		getThread().stepInto();
	}

	//@Override
	public void stepOver() throws DebugException {
		getThread().stepOver();
	}

	//@Override
	public void stepReturn() throws DebugException {
		getThread().stepReturn();
	}

	//@Override
	public boolean canResume() {
		return getThread().canResume();
	}

	//@Override
	public boolean canSuspend() {
		return getThread().canSuspend();
	}

	//@Override
	public boolean isSuspended() {
		return getThread().isSuspended();
	}

	//@Override
	public void resume() throws DebugException {
		getThread().resume();
	}

	//@Override
	public void suspend() throws DebugException {
		getThread().suspend();
	}

	//@Override
	public boolean canTerminate() {
		return getThread().canTerminate();
	}

	//@Override
	public boolean isTerminated() {
		return getThread().isTerminated();
	}

	//@Override
	public void terminate() throws DebugException {
		getThread().terminate();
	}
}
