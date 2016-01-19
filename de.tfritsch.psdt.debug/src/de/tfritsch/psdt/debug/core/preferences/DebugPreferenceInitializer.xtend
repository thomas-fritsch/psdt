package de.tfritsch.psdt.debug.core.preferences

import de.tfritsch.psdt.debug.IPSConstants
import de.tfritsch.psdt.debug.PSPlugin
import org.eclipse.core.runtime.preferences.AbstractPreferenceInitializer

class DebugPreferenceInitializer extends AbstractPreferenceInitializer {
	
	override initializeDefaultPreferences() {
		val store = PSPlugin.^default.preferenceStore
		store.setDefault(IPSConstants.PREF_SHOW_SYSTEMDICT, false)
		store.setDefault(IPSConstants.PREF_SHOW_GLOBALDICT, true)
		store.setDefault(IPSConstants.PREF_SHOW_USERDICT, true)
	}
	
}