package de.tfritsch.psdt.debug.model

import org.eclipse.debug.core.DebugException

interface IPSDebugCommander {

	def void setDebugStreamListener(IPSDebugStreamListener listener)

	def void setSingleStep(boolean singleStep) throws DebugException

	def void resume() throws DebugException

	def void addBreakpoint(int ref) throws DebugException

	def void removeBreakpoint(int ref) throws DebugException

	def void hideDicts(boolean hideSystemDict, boolean hideGlobalDict, boolean hideUserDict) throws DebugException

	def void requestStatus() throws DebugException

	def void sendCommand(String string) throws DebugException
}
