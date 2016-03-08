/*******************************************************************************
 * Copyright (c) 2016 Thomas Fritsch.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 ******************************************************************************/
package de.tfritsch.psdt.debug.core.preferences

import de.tfritsch.psdt.debug.IPSConstants
import de.tfritsch.psdt.debug.PSPlugin
import org.eclipse.core.runtime.preferences.AbstractPreferenceInitializer

/**
 * @author Thomas Fritsch - initial API and implementation
 */
class DebugPreferenceInitializer extends AbstractPreferenceInitializer {
	
	override initializeDefaultPreferences() {
		val store = PSPlugin.^default.preferenceStore
		store.setDefault(IPSConstants.PREF_SHOW_SYSTEMDICT, false)
		store.setDefault(IPSConstants.PREF_SHOW_GLOBALDICT, true)
		store.setDefault(IPSConstants.PREF_SHOW_USERDICT, true)
	}
	
}