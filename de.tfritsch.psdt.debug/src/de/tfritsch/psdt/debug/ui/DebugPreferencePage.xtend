package de.tfritsch.psdt.debug.ui

import de.tfritsch.psdt.debug.IPSConstants
import de.tfritsch.psdt.debug.PSPlugin
import org.eclipse.jface.preference.BooleanFieldEditor
import org.eclipse.jface.preference.FieldEditorPreferencePage
import org.eclipse.ui.IWorkbench
import org.eclipse.ui.IWorkbenchPreferencePage

class DebugPreferencePage extends FieldEditorPreferencePage implements IWorkbenchPreferencePage {

	/**
     * Public constructor needed for instantiation from plugin.xml
     */
	new() {
		super(GRID)
		preferenceStore = PSPlugin.^default.preferenceStore
	}
	
	override protected createFieldEditors() {
		addField(new BooleanFieldEditor(IPSConstants.PREF_SHOW_SYSTEMDICT, "Show systemdict", fieldEditorParent))
		addField(new BooleanFieldEditor(IPSConstants.PREF_SHOW_GLOBALDICT, "Show globaldict", fieldEditorParent))
		addField(new BooleanFieldEditor(IPSConstants.PREF_SHOW_USERDICT, "Show userdict", fieldEditorParent))
	}
	
	override init(IWorkbench workbench) {
	}
	
}