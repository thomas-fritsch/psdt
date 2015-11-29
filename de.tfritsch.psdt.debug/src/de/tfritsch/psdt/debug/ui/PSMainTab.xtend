package de.tfritsch.psdt.debug.ui

import de.tfritsch.psdt.debug.PSPlugin
import de.tfritsch.psdt.debug.model.PSProcessFactory
import java.io.File
import org.eclipse.core.runtime.CoreException
import org.eclipse.debug.core.ILaunchConfiguration
import org.eclipse.debug.core.ILaunchConfigurationWorkingCopy
import org.eclipse.debug.ui.AbstractLaunchConfigurationTab
import org.eclipse.swt.SWT
import org.eclipse.swt.events.SelectionAdapter
import org.eclipse.swt.events.SelectionEvent
import org.eclipse.swt.graphics.Image
import org.eclipse.swt.layout.GridData
import org.eclipse.swt.layout.GridLayout
import org.eclipse.swt.widgets.Button
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.FileDialog
import org.eclipse.swt.widgets.Group
import org.eclipse.swt.widgets.Text

import static extension de.tfritsch.psdt.debug.LaunchExtensions.*
import static extension de.tfritsch.psdt.debug.PSLaunchExtensions.*

/**
 * Tab to specify the PostScript program to run/debug.
 */
public class PSMainTab extends AbstractLaunchConfigurationTab {

	Text fProgramText
	Button fProgramButton
	Button fBreakOnFirstTokenButton

	override String getName() {
		return "Main"
	}

	override Image getImage() {
		return PSPlugin.getImage("icons/postscript.png") //$NON-NLS-1$
	}

	override void createControl(Composite parent) {
		val comp = new Composite(parent, SWT.NONE) => [
			layout = new GridLayout(1, true)
		]
		control = comp

		val group = new Group(comp, SWT.NONE) => [
			layout = new GridLayout(2, false)
			layoutData = new GridData(GridData.FILL_HORIZONTAL)
			text = "Program:"
		]
		fProgramText = new Text(group, SWT.SINGLE.bitwiseOr(SWT.BORDER)) => [
			layoutData = new GridData(GridData.FILL_HORIZONTAL)
			addModifyListener [
				updateLaunchConfigurationDialog
			]
		]
		fProgramButton = createPushButton(group, "&Browse...", null) => [
			addSelectionListener(
				new SelectionAdapter {
					override void widgetSelected(SelectionEvent e) {
						browsePSFiles
					}
				})
		]
		fBreakOnFirstTokenButton = createCheckButton(comp, "Break on first token") => [
			addSelectionListener(
				new SelectionAdapter {
					override void widgetSelected(SelectionEvent e) {
						updateLaunchConfigurationDialog
					}
				})
		]
	}

	/**
     * Open a file dialog to select a PostScript program 
     */
	def protected void browsePSFiles() {
		val dialog = new FileDialog(shell, SWT.OPEN) => [
			fileName = fProgramText.text
			filterExtensions = #["*.ps;*.eps", "*"] //$NON-NLS-1$ //$NON-NLS-2$
		]
		val s = dialog.open
		if (s != null) {
			fProgramText.text = s
		}
	}

	override void setDefaults(ILaunchConfigurationWorkingCopy configuration) {
		configuration.processFactoryId = PSProcessFactory.ID
		configuration.breakOnFirstToken = false
	}

	override void initializeFrom(ILaunchConfiguration configuration) {
		try {
			val program = configuration.program
			if (program != null) {
				fProgramText.text = program
			}
		} catch (CoreException e) {
			errorMessage = e.message
		}
		try {
			fBreakOnFirstTokenButton.selection = configuration.breakOnFirstToken
		} catch (CoreException e) {
			errorMessage = e.message
		}
	}

	override void performApply(ILaunchConfigurationWorkingCopy configuration) {
		var program = fProgramText.text
		if (program.empty) {
			program = null
		}
		configuration.program = program
		configuration.breakOnFirstToken = fBreakOnFirstTokenButton.selection
	}

	override boolean isValid(ILaunchConfiguration launchConfig) {
		val program = fProgramText.text
		if (program.empty) {
			errorMessage = "Specify a program"
			return false
		}
		if (!(new File(program)).exists) {
			errorMessage = "Specified program does not exist"
			return false
		}
		errorMessage = null
		return true
	}
}
