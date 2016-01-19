package de.tfritsch.psdt.debug.ui.preferences

import de.tfritsch.psdt.debug.IPSConstants
import de.tfritsch.psdt.debug.PSPlugin
import java.io.File
import org.eclipse.core.runtime.Platform
import org.eclipse.jface.preference.FieldEditorPreferencePage
import org.eclipse.jface.preference.FileFieldEditor
import org.eclipse.jface.preference.IPreferenceStore
import org.eclipse.ui.IWorkbench
import org.eclipse.ui.IWorkbenchPreferencePage

/**
 * Matches plugin.xml
 * extension[@point="org.eclipse.ui.preferencePages"]/page/@class
 */
class GhostscriptPreferencePage extends FieldEditorPreferencePage implements IWorkbenchPreferencePage {

	/**
     * Unique identifier for the Ghostscript preference page (value 
     * <code>{@value}</code>).
     * Matches plugin.xml
     * extension[@point="org.eclipse.ui.preferencePages"]/page/@id
     */
	val public static ID = PSPlugin.ID + ".ghostscriptPreferencePage" //$NON-NLS-1$

	/**
     * Public constructor needed for instantiation from plugin.xml
     */
	new() {
		super(GRID)
	}

	override protected void createFieldEditors() {
		val editor = new FileFieldEditor(IPSConstants.PREF_INTERPRETER, "&Interpreter:", true, fieldEditorParent) => [
			switch (Platform.getOS) {
				case Platform.OS_WIN32: {
					fileExtensions = #["*.exe", "*.*"] //$NON-NLS-1$ //$NON-NLS-2$
					filterPath = new File("C:") //$NON-NLS-1$
				}
				case Platform.OS_LINUX: {
					filterPath = new File("/usr/bin") //$NON-NLS-1$
				}
			}
		]
		addField(editor)
	}

	override void init(IWorkbench workbench) {
	}

	override protected IPreferenceStore doGetPreferenceStore() {
		return PSPlugin.^default.preferenceStore
	}

}
