package de.tfritsch.psdt.debug

import org.eclipse.debug.core.DebugPlugin
import org.eclipse.debug.core.IBreakpointManager
import org.eclipse.debug.core.ILaunchManager
import org.eclipse.xtext.service.AbstractGenericModule

class PSModule extends AbstractGenericModule {

	def IBreakpointManager bindIBreakpointManager() {
		return DebugPlugin.^default.breakpointManager
	}
	
	def ILaunchManager bindILaunchManager() {
		return DebugPlugin.^default.launchManager
	}
}
