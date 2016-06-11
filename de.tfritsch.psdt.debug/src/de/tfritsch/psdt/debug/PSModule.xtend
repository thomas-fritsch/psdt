package de.tfritsch.psdt.debug

import com.google.inject.AbstractModule
import com.google.inject.name.Names
import org.eclipse.debug.core.DebugPlugin
import org.eclipse.debug.core.IBreakpointManager
import org.eclipse.debug.core.ILaunchManager
import org.eclipse.jface.preference.IPreferenceStore
import org.eclipse.ui.plugin.AbstractUIPlugin

class PSModule extends AbstractModule {

	AbstractUIPlugin plugin

	new(AbstractUIPlugin plugin) {
		this.plugin = plugin
	}

	override protected configure() {
		bind(IBreakpointManager).toInstance(DebugPlugin.^default.breakpointManager)
		bind(ILaunchManager).toInstance(DebugPlugin.^default.launchManager)
		bind(IPreferenceStore).annotatedWith(Names.named("debug")).toInstance(plugin.preferenceStore)
	}
}
