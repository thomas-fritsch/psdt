package de.tfritsch.psdt.debug.core.preferences

import de.tfritsch.psdt.debug.IPSConstants
import de.tfritsch.psdt.debug.PSPlugin
import org.eclipse.core.runtime.preferences.AbstractPreferenceInitializer
import org.eclipse.core.runtime.Platform

class GhostscriptPreferenceInitializer extends AbstractPreferenceInitializer {

	override initializeDefaultPreferences() {
		val store = PSPlugin.^default.preferenceStore
		switch (Platform.getOS) {
			case Platform.OS_LINUX: {
				store.setDefault(IPSConstants.PREF_INTERPRETER, "/usr/bin/gs") //$NON-NLS-1$
			}
			case Platform.OS_MACOSX: {
				store.setDefault(IPSConstants.PREF_INTERPRETER, "/usr/local/bin/gs") //$NON-NLS-1$				
			}
		}
	}

}
