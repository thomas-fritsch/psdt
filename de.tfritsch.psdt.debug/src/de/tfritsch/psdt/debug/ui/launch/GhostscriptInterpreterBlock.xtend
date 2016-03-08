/*******************************************************************************
 * Copyright (c) 2016 Thomas Fritsch.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 ******************************************************************************/
package de.tfritsch.psdt.debug.ui.launch

import de.tfritsch.psdt.debug.PSPlugin
import de.tfritsch.psdt.debug.ui.preferences.GhostscriptPreferencePage
import org.eclipse.debug.core.ILaunchConfiguration
import org.eclipse.debug.core.ILaunchConfigurationWorkingCopy
import org.eclipse.debug.ui.AbstractLaunchConfigurationTab
import org.eclipse.swt.SWT
import org.eclipse.swt.layout.GridData
import org.eclipse.swt.layout.GridLayout
import org.eclipse.swt.widgets.Button
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Group
import org.eclipse.swt.widgets.Text

import static extension de.tfritsch.psdt.debug.PSLaunchExtensions.*
import static extension org.eclipse.ui.dialogs.PreferencesUtil.*

/**
 * @author Thomas Fritsch - initial API and implementation
 */
class GhostscriptInterpreterBlock extends AbstractLaunchConfigurationTab {

	Text fInterpreterText
	Button fInterpreterButton

	override void createControl(Composite parent) {
		val group = new Group(parent, SWT.NONE) => [
			layout = new GridLayout(2, false)
			layoutData = new GridData(GridData.FILL_HORIZONTAL)
			text = "Ghostscript interpreter:"
		]
		control = group

		fInterpreterText = new Text(group, SWT.SINGLE.bitwiseOr(SWT.BORDER).bitwiseOr(SWT.READ_ONLY)) => [
			layoutData = new GridData(GridData.FILL_BOTH)
		]
		fInterpreterButton = createPushButton(group, "Preference...", null) => [
			addListener(SWT.Selection) [
				val id = GhostscriptPreferencePage.ID
				fInterpreterButton.shell.createPreferenceDialogOn(id, #[id], null).open
				fInterpreterText.text = interpreter
				updateLaunchConfigurationDialog
			]
		]
	}

	override void setDefaults(ILaunchConfigurationWorkingCopy configuration) {
	}

	override void initializeFrom(ILaunchConfiguration configuration) {
		fInterpreterText.text = interpreter
	}

	override boolean isValid(ILaunchConfiguration configuration) {
		if (interpreter.nullOrEmpty) {
			errorMessage = "Interpreter not specified"
			return false
		}
		return true
	}

	override void performApply(ILaunchConfigurationWorkingCopy configuration) {
	}

	override String getName() {
		return "Ghostscript interpreter" //$NON-NLS-1$
	}

	def private String getInterpreter() {
		return PSPlugin.^default.preferenceStore.interpreter
	}

}
