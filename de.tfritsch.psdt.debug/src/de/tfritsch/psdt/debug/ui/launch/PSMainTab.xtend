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
import de.tfritsch.psdt.debug.core.process.PSProcessFactory
import de.tfritsch.psdt.help.PSHelpContexts
import java.io.File
import org.eclipse.core.resources.IFile
import org.eclipse.core.resources.ResourcesPlugin
import org.eclipse.core.runtime.CoreException
import org.eclipse.core.runtime.Path
import org.eclipse.core.variables.IStringVariableManager
import org.eclipse.debug.core.ILaunchConfiguration
import org.eclipse.debug.core.ILaunchConfigurationWorkingCopy
import org.eclipse.debug.ui.AbstractLaunchConfigurationTab
import org.eclipse.debug.ui.StringVariableSelectionDialog
import org.eclipse.swt.SWT
import org.eclipse.swt.layout.GridData
import org.eclipse.swt.layout.GridLayout
import org.eclipse.swt.widgets.Button
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.FileDialog
import org.eclipse.swt.widgets.Group
import org.eclipse.swt.widgets.Text
import org.eclipse.ui.dialogs.ElementTreeSelectionDialog
import org.eclipse.ui.help.IWorkbenchHelpSystem
import org.eclipse.ui.model.BaseWorkbenchContentProvider
import org.eclipse.ui.model.WorkbenchLabelProvider
import org.eclipse.xtext.resource.FileExtensionProvider
import org.eclipse.xtext.ui.IImageHelper

import static extension de.tfritsch.psdt.debug.LaunchExtensions.setProcessFactoryId
import static extension de.tfritsch.psdt.debug.PSLaunchExtensions.getProgram
import static extension de.tfritsch.psdt.debug.PSLaunchExtensions.isBreakOnFirstToken
import static extension de.tfritsch.psdt.debug.PSLaunchExtensions.setBreakOnFirstToken
import static extension de.tfritsch.psdt.debug.PSLaunchExtensions.setProgram
import static extension org.eclipse.core.filebuffers.FileBuffers.getWorkspaceFileAtLocation

/**
 * Tab to specify the PostScript program to run/debug.
 * 
 * @author Thomas Fritsch - initial API and implementation
 */
class PSMainTab extends AbstractLaunchConfigurationTab {

	Text fProgramText
	Button fWorkspaceButton
	Button fFileSystemButton
	Button fVariablesButton
	Button fBreakOnFirstTokenButton

	@Inject	IImageHelper fImageHelper
	@Inject FileExtensionProvider fileExtensionProvider
	@Inject extension IStringVariableManager
	@Inject extension IWorkbenchHelpSystem
    
	new() {
		helpContextId = PSHelpContexts.LAUNCH_CONFIGURATION_DIALOG_MAIN_TAB
	}

	override getName() {
		"Main"
	}

	override getImage() {
		fImageHelper.getImage("postscript.png") //$NON-NLS-1$
	}

	override createControl(Composite parent) {
		val comp = new Composite(parent, SWT.NONE) => [
			layout = new GridLayout(1, true)
			help = helpContextId
		]
		control = comp

		val group = new Group(comp, SWT.NONE) => [
			layout = new GridLayout(2, false)
			layoutData = new GridData(GridData.FILL_HORIZONTAL)
			text = "Program:"
		]
		fProgramText = new Text(group, SWT.SINGLE.bitwiseOr(SWT.BORDER)) => [
			layoutData = new GridData(GridData.FILL_HORIZONTAL)
			addModifyListener [updateLaunchConfigurationDialog]
		]
		val buttonComposite = new Composite(group, SWT.NONE) => [
			layout = new GridLayout(3, false)
			layoutData = new GridData(GridData.HORIZONTAL_ALIGN_END) => [horizontalSpan = 2]
		]
		fWorkspaceButton = createPushButton(buttonComposite, "&Workspace...", null) => [
			addListener(SWT.Selection)[browseWorkspace]
		]
		fFileSystemButton = createPushButton(buttonComposite, "&File System...", null) => [
			addListener(SWT.Selection)[browseFileSystem]
		]
		fVariablesButton = createPushButton(buttonComposite, "&Variables...", null) => [
			addListener(SWT.Selection)[browseVariables]
		]
		fBreakOnFirstTokenButton = createCheckButton(comp, "Break on first token") => [
			addListener(SWT.Selection)[updateLaunchConfigurationDialog]
		]
	}

	def protected void browseWorkspace() {
		val dialog = new ElementTreeSelectionDialog(shell, new WorkbenchLabelProvider, new BaseWorkbenchContentProvider) => [
			input = ResourcesPlugin.workspace.root
			title = "File selection"
			message = "Choose a PostScript file"
			allowMultiple = false
			addFilter[ viewer, parentElement, element |
				switch (element) {
					IFile:
						fileExtensionProvider.isValid(element.fileExtension)
					default: // IFolder, IProject
						true
				}
			]
			try {
				initialSelection = new Path(fProgramText.text.performStringSubstitution).workspaceFileAtLocation
			} catch (CoreException e) {
			}
		]
		dialog.open
		val file = dialog.firstResult as IFile
		if (file !== null) {
			fProgramText.text = '''${workspace_loc:«file.fullPath»}'''
		}
	}

	/**
     * Open a file dialog to select a PostScript program 
     */
	def protected void browseFileSystem() {
		val dialog = new FileDialog(shell, SWT.OPEN) => [
			fileName = fProgramText.text
			filterExtensions = #["*.ps;*.eps", "*"] //$NON-NLS-1$ //$NON-NLS-2$
		]
		val s = dialog.open
		if (s != null) {
			fProgramText.text = s
		}
	}

	def protected void browseVariables() {
		val dialog = new StringVariableSelectionDialog(shell)
		dialog.open
		val variableText = dialog.variableExpression
		if (variableText !== null)
			fProgramText.insert(variableText)
	}

	override setDefaults(ILaunchConfigurationWorkingCopy configuration) {
		configuration.processFactoryId = PSProcessFactory.ID
		configuration.breakOnFirstToken = false
	}

	override initializeFrom(ILaunchConfiguration configuration) {
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

	override performApply(ILaunchConfigurationWorkingCopy configuration) {
		var program = fProgramText.text
		if (program.empty) {
			program = null
		}
		configuration.program = program
		configuration.breakOnFirstToken = fBreakOnFirstTokenButton.selection
	}

	override isValid(ILaunchConfiguration launchConfig) {
		val program = fProgramText.text
		if (program.empty) {
			errorMessage = "Specify a program"
			return false
		}
		try {
			if (!(new File(program.performStringSubstitution)).exists) {
				errorMessage = "Specified program does not exist"
				return false
			}
		} catch (CoreException e) {
			errorMessage = e.message
			return false
		}
		errorMessage = null
		true
	}
}
