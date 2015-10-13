package de.tfritsch.psdt.debug.ui

import de.tfritsch.psdt.debug.IPSConstants
import de.tfritsch.psdt.debug.PSPlugin
import org.eclipse.debug.core.ILaunchConfiguration
import org.eclipse.debug.core.ILaunchConfigurationWorkingCopy
import org.eclipse.debug.ui.AbstractLaunchConfigurationTab
import org.eclipse.swt.SWT
import org.eclipse.swt.events.SelectionAdapter
import org.eclipse.swt.events.SelectionEvent
import org.eclipse.swt.layout.GridData
import org.eclipse.swt.layout.GridLayout
import org.eclipse.swt.widgets.Button
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Group
import org.eclipse.swt.widgets.Text

import static extension org.eclipse.ui.dialogs.PreferencesUtil.*

public class GhostscriptInterpreterBlock extends AbstractLaunchConfigurationTab {

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
			addSelectionListener(
				new SelectionAdapter {
					override void widgetSelected(SelectionEvent e) {
						val id = GhostscriptPreferencePage.ID
						fInterpreterButton.shell.createPreferenceDialogOn(id, #[id], null).open()
						fInterpreterText.text = interpreter
						updateLaunchConfigurationDialog
					}
				})
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
		return PSPlugin.^default.preferenceStore.getString(IPSConstants.PREF_INTERPRETER)
	}

}
