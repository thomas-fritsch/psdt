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
import com.google.inject.name.Named
import de.tfritsch.psdt.debug.IPSConstants
import de.tfritsch.psdt.debug.PSPlugin
import java.io.File
import org.eclipse.core.runtime.Platform
import org.eclipse.jface.preference.BooleanFieldEditor
import org.eclipse.jface.preference.FieldEditorPreferencePage
import org.eclipse.jface.preference.FileFieldEditor
import org.eclipse.jface.preference.IPreferenceStore
import org.eclipse.jface.preference.StringFieldEditor
import org.eclipse.ui.IWorkbench
import org.eclipse.ui.IWorkbenchPreferencePage

/**
 * Matches plugin.xml
 * extension[@point="org.eclipse.ui.preferencePages"]/page/@class
 * 
 * @author Thomas Fritsch - initial API and implementation
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

	@Inject
	override setPreferenceStore(@Named("debug") IPreferenceStore store) {
		super.setPreferenceStore(store)
	}

	override protected void createFieldEditors() {
		addField(
			new FileFieldEditor(IPSConstants.PREF_INTERPRETER, "&Interpreter:", true, fieldEditorParent) => [
				switch (Platform.getOS) {
					case Platform.OS_WIN32: {
						fileExtensions = #["*.exe", "*.*"] //$NON-NLS-1$ //$NON-NLS-2$
						filterPath = new File("C:") //$NON-NLS-1$
					}
					case Platform.OS_LINUX: {
						filterPath = new File("/usr/bin") //$NON-NLS-1$
					}
				}
			])
		addField(
			new StringFieldEditor(IPSConstants.PREF_DEFAULT_GS_ARGUMENTS, "&Default arguments", fieldEditorParent))
		addField(
			new BooleanFieldEditor(IPSConstants.PREF_MESSAGE_BOX_ON_PROMPT,
				"&Message box on 'press <return> to continue'", fieldEditorParent))
	}

	override void init(IWorkbench workbench) {
	}

}
