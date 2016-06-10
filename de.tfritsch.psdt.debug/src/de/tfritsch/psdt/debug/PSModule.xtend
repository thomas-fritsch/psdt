package de.tfritsch.psdt.debug

import com.google.inject.Binder
import com.google.inject.name.Names
import org.eclipse.debug.core.DebugPlugin
import org.eclipse.debug.core.IBreakpointManager
import org.eclipse.debug.core.ILaunchManager
import org.eclipse.jface.preference.IPreferenceStore
import org.eclipse.ui.plugin.AbstractUIPlugin
import org.eclipse.xtext.service.AbstractGenericModule

class PSModule extends AbstractGenericModule {

	AbstractUIPlugin plugin

	new(AbstractUIPlugin plugin) {
		this.plugin = plugin
	}

	def IBreakpointManager bindIBreakpointManager() {
		return DebugPlugin.^default.breakpointManager
	}

	def ILaunchManager bindILaunchManager() {
		return DebugPlugin.^default.launchManager
	}

	def void configureIPreferenceStore(Binder binder) {
		binder.bind(IPreferenceStore).annotatedWith(Names.named("debug")).toInstance(plugin.preferenceStore)
	}
}
