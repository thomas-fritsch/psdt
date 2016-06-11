/*******************************************************************************
 * Copyright (C) 2016  Thomas Fritsch.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 ******************************************************************************/
package de.tfritsch.psdt.debug.core.preferences

import com.google.inject.Inject
import de.tfritsch.psdt.debug.Debug
import de.tfritsch.psdt.debug.IPSConstants
import org.eclipse.core.runtime.preferences.AbstractPreferenceInitializer
import org.eclipse.jface.preference.IPreferenceStore

/**
 * @author Thomas Fritsch - initial API and implementation
 */
class DebugPreferenceInitializer extends AbstractPreferenceInitializer {

	@Inject @Debug IPreferenceStore store

	override initializeDefaultPreferences() {
		store.setDefault(IPSConstants.PREF_SHOW_SYSTEMDICT, false)
		store.setDefault(IPSConstants.PREF_SHOW_GLOBALDICT, true)
		store.setDefault(IPSConstants.PREF_SHOW_USERDICT, true)
	}

}
