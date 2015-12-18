package de.tfritsch.psdt.debug.ui

import de.tfritsch.psdt.debug.model.PSLaunchConfigurationDelegate
import de.tfritsch.psdt.debug.model.PSProcessFactory
import org.eclipse.core.resources.IFile
import org.eclipse.core.runtime.CoreException
import org.eclipse.debug.core.DebugPlugin
import org.eclipse.debug.core.ILaunchConfiguration
import org.eclipse.debug.core.ILaunchManager
import org.eclipse.debug.ui.ILaunchShortcut
import org.eclipse.jface.viewers.ISelection
import org.eclipse.jface.viewers.IStructuredSelection
import org.eclipse.swt.widgets.Shell
import org.eclipse.ui.IEditorPart
import org.eclipse.ui.PlatformUI
import org.eclipse.ui.dialogs.ElementListSelectionDialog

import static extension de.tfritsch.psdt.debug.LaunchExtensions.*
import static extension de.tfritsch.psdt.debug.PSLaunchExtensions.*
import static extension org.eclipse.debug.ui.DebugUITools.*

/**
 * Matches plugin.xml
 * extension[@point="org.eclipse.debug.ui.launchShortcuts"]/shortcut/@class
 */
class PSLaunchShortcut implements ILaunchShortcut {

	extension ILaunchManager = DebugPlugin.^default.launchManager

	override void launch(ISelection selection, String mode) {
		if (selection instanceof IStructuredSelection) {
			val element = selection.firstElement
			if (element instanceof IFile)
				element.launch(mode)
		}
	}

	override void launch(IEditorPart editor, String mode) {
		val file = editor.editorInput.getAdapter(IFile) as IFile
		file?.launch(mode)
	}

	def private void launch(IFile file, String mode) {
		val program = file.location.toOSString
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
			type.launchConfigurations.filter[c|!c.private && program == c.program.performStringSubstitution]
		} catch (CoreException e) {
			DebugPlugin.log(e)
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
				ghostscriptArguments = "-dBATCH" //$NON-NLS-1$
			]
			return workingCopy.doSave
		} catch (CoreException e) {
			DebugPlugin.log(e)
			return null
		}
	}

	def private ILaunchConfiguration chooseConfiguration(ILaunchConfiguration[] configs) {
		val dialog = new ElementListSelectionDialog(shell, newDebugModelPresentation) => [
			elements = configs
			title = "Select PostScript Application"
			message = "Select existing configuration:"
			multipleSelection = false
		]
		dialog.open
		return dialog.firstResult as ILaunchConfiguration
	}

	def private Shell getShell() {
		return PlatformUI.workbench.activeWorkbenchWindow.shell
	}
}
