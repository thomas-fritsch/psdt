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
import de.tfritsch.psdt.debug.Debug
import de.tfritsch.psdt.debug.PSPlugin
import de.tfritsch.psdt.debug.core.launch.PSLaunchConfigurationDelegate
import de.tfritsch.psdt.debug.core.process.PSProcessFactory
import org.eclipse.core.filesystem.EFS
import org.eclipse.core.filesystem.IFileStore
import org.eclipse.core.resources.IFile
import org.eclipse.core.runtime.CoreException
import org.eclipse.core.variables.IStringVariableManager
import org.eclipse.debug.core.ILaunchConfiguration
import org.eclipse.debug.core.ILaunchManager
import org.eclipse.debug.ui.ILaunchShortcut
import org.eclipse.jface.preference.IPreferenceStore
import org.eclipse.jface.viewers.ISelection
import org.eclipse.jface.viewers.IStructuredSelection
import org.eclipse.ui.IEditorPart
import org.eclipse.ui.IWorkbench
import org.eclipse.ui.dialogs.ElementListSelectionDialog
import org.eclipse.ui.ide.FileStoreEditorInput

import static extension de.tfritsch.psdt.debug.LaunchExtensions.*
import static extension de.tfritsch.psdt.debug.PSLaunchExtensions.*
import static extension org.eclipse.debug.ui.DebugUITools.*

/**
 * Matches plugin.xml
 * extension[@point="org.eclipse.debug.ui.launchShortcuts"]/shortcut/@class
 * 
 * @author Thomas Fritsch - initial API and implementation
 */
class PSLaunchShortcut implements ILaunchShortcut {

	@Inject extension ILaunchManager
	@Inject extension IStringVariableManager
	@Inject IWorkbench workbench
	@Inject @Debug IPreferenceStore preferenceStore

	override void launch(ISelection selection, String mode) {
		if (selection instanceof IStructuredSelection) {
			val element = selection.firstElement
			if (element instanceof IFile)
				element.launch(mode)
		}
	}

	override void launch(IEditorPart editor, String mode) {
		val file = editor.editorInput.getAdapter(IFile) as IFile
		if (file !== null) {
			file.launch(mode)
			return
		}
		val editorInput = editor.editorInput
		if (editorInput instanceof FileStoreEditorInput) {
			val fileStore = EFS.getStore(editorInput.URI)
			fileStore.launch(mode)
			return
		}
	}

	def private void launch(IFile file, String mode) {
		val program = file.location.toOSString
		program.launch(mode)
	}

	def private void launch(IFileStore fileStore, String mode) {
		val program = fileStore.toLocalFile(EFS.NONE, null).absolutePath
		program.launch(mode)
	}

	def private void launch(String program, String mode) {
		val configurations = program.configurations
		val configuration = switch (configurations.length) {
			case 0:
				program.createConfiguration
			case 1:
				configurations.get(0)
			default:
				configurations.chooseConfiguration
		}
		configuration?.launch(mode)
	}

	def private ILaunchConfiguration[] getConfigurations(String program) {
		val type = PSLaunchConfigurationDelegate.ID.launchConfigurationType
		try {
			type.launchConfigurations.filter [ c |
				try {
					!c.private && program == c.program?.performStringSubstitution
				} catch (CoreException e) {
					false
				}
			]
		} catch (CoreException e) {
			PSPlugin.log(e)
			#[]
		}
	}

	def private ILaunchConfiguration createConfiguration(String program_) {
		val type = PSLaunchConfigurationDelegate.ID.launchConfigurationType
		val name = type.name.generateLaunchConfigurationName
		try {
			val workingCopy = type.newInstance(null, name) => [
				program = program_
				processFactoryId = PSProcessFactory.ID
				ghostscriptArguments = preferenceStore.defaultGhostscriptArguments
			]
			return workingCopy.doSave
		} catch (CoreException e) {
			PSPlugin.log(e)
			return null
		}
	}

	def private ILaunchConfiguration chooseConfiguration(ILaunchConfiguration[] configs) {
		val shell = workbench.activeWorkbenchWindow.shell
		val dialog = new ElementListSelectionDialog(shell, newDebugModelPresentation) => [
			elements = configs
			title = "Select PostScript Application"
			message = "Select existing configuration:"
			multipleSelection = false
		]
		dialog.open
		return dialog.firstResult as ILaunchConfiguration
	}
}
