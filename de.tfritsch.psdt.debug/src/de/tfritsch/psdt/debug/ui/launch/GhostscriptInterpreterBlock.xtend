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
package de.tfritsch.psdt.debug.ui.launch

import com.google.inject.Inject
import com.google.inject.name.Named
import de.tfritsch.psdt.debug.ui.preferences.GhostscriptPreferencePage
import org.eclipse.debug.core.ILaunchConfiguration
import org.eclipse.debug.core.ILaunchConfigurationWorkingCopy
import org.eclipse.debug.ui.AbstractLaunchConfigurationTab
import org.eclipse.jface.preference.IPreferenceStore
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
	@Inject @Named("debug") IPreferenceStore preferenceStore

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
				shell.createPreferenceDialogOn(id, #[id], null).open
				fInterpreterText.text = preferenceStore.interpreter
				updateLaunchConfigurationDialog
			]
		]
	}

	override void setDefaults(ILaunchConfigurationWorkingCopy configuration) {
	}

	override void initializeFrom(ILaunchConfiguration configuration) {
		fInterpreterText.text = preferenceStore.interpreter
	}

	override boolean isValid(ILaunchConfiguration configuration) {
		if (preferenceStore.interpreter.nullOrEmpty) {
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

}
