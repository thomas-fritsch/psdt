package de.tfritsch.psdt.debug.model;

import org.eclipse.debug.core.DebugException;

interface IPSDebugCommander {

	public void setDebugStreamListener(IPSDebugStreamListener listener);
	
	public void setSingleStep(boolean singleStep) throws DebugException;

	public void resume() throws DebugException;

	public void addBreakpoint(int ref) throws DebugException;

	public void removeBreakpoint(int ref) throws DebugException;

	public void hideDicts(boolean hideSystemDict, boolean hideGlobalDict,
			boolean hideUserDict) throws DebugException;
	
	public void requestStatus() throws DebugException;
	
	public void sendInstrumentedCode(PSSourceMapping sourceMapping) throws DebugException;

	public void sendCommand(String string) throws DebugException;
}
