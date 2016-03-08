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
import java.io.File
import org.eclipse.core.runtime.Platform
import org.eclipse.jface.preference.FieldEditorPreferencePage
import org.eclipse.jface.preference.FileFieldEditor
import org.eclipse.jface.preference.IPreferenceStore
import org.eclipse.ui.IWorkbench
import org.eclipse.ui.IWorkbenchPreferencePage
import org.eclipse.jface.preference.BooleanFieldEditor

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
			new BooleanFieldEditor(IPSConstants.PREF_MESSAGE_BOX_ON_PROMPT,
				"&Message box on 'press <return> to continue'", fieldEditorParent))
	}

	override void init(IWorkbench workbench) {
	}

	override protected IPreferenceStore doGetPreferenceStore() {
		return PSPlugin.^default.preferenceStore
	}

}
