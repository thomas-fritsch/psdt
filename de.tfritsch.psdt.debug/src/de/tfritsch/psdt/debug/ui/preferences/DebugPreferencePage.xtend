/*******************************************************************************
 * Copyright (c) 2016 Thomas Fritsch.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 ******************************************************************************/
package de.tfritsch.psdt.debug.ui.preferences

import de.tfritsch.psdt.debug.IPSConstants
import de.tfritsch.psdt.debug.PSPlugin
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

	override protected createFieldEditors() {
		addField(
			new BooleanFieldEditor(IPSConstants.PREF_SHOW_SYSTEMDICT,
				"Show systemdict (may slow down stepping performance of debugger)", fieldEditorParent))
		addField(new BooleanFieldEditor(IPSConstants.PREF_SHOW_GLOBALDICT, "Show globaldict", fieldEditorParent))
		addField(new BooleanFieldEditor(IPSConstants.PREF_SHOW_USERDICT, "Show userdict", fieldEditorParent))
	}

	override init(IWorkbench workbench) {
	}

	override protected IPreferenceStore doGetPreferenceStore() {
		return PSPlugin.^default.preferenceStore
	}

}
