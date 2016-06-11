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
package de.tfritsch.psdt.debug.ui.preferences

import com.google.inject.Inject
import de.tfritsch.psdt.debug.Debug
import de.tfritsch.psdt.debug.IPSConstants
import org.eclipse.jface.preference.BooleanFieldEditor
import org.eclipse.jface.preference.FieldEditorPreferencePage
import org.eclipse.jface.preference.IPreferenceStore
import org.eclipse.ui.IWorkbench
import org.eclipse.ui.IWorkbenchPreferencePage

/**
 * Matches plugin.xml
 * extension[@point="org.eclipse.ui.preferencePages"]/page/@class
 * 
 * @author Thomas Fritsch - initial API and implementation
 */
class DebugPreferencePage extends FieldEditorPreferencePage implements IWorkbenchPreferencePage {

	/**
     * Public constructor needed for instantiation from plugin.xml
     */
	new() {
		super(GRID)
	}

	@Inject
	override setPreferenceStore(@Debug IPreferenceStore store) {
		super.setPreferenceStore(store)
	}

	override protected createFieldEditors() {
		addField(
			new BooleanFieldEditor(IPSConstants.PREF_SHOW_SYSTEMDICT,
				"Show systemdict (may slow down stepping performance of debugger)", fieldEditorParent))
		addField(new BooleanFieldEditor(IPSConstants.PREF_SHOW_GLOBALDICT, "Show globaldict", fieldEditorParent))
		addField(new BooleanFieldEditor(IPSConstants.PREF_SHOW_USERDICT, "Show userdict", fieldEditorParent))
	}

	override init(IWorkbench workbench) {
	}

}
