package de.tfritsch.psdt.debug.ui

import de.tfritsch.psdt.debug.IPSConstants
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
import org.eclipse.jface.window.Window
import org.eclipse.swt.widgets.Shell
import org.eclipse.ui.IEditorPart
import org.eclipse.ui.PlatformUI
import org.eclipse.ui.dialogs.ElementListSelectionDialog

import static extension org.eclipse.debug.ui.DebugUITools.*

/**
 * Matches plugin.xml
 * extension[@point="org.eclipse.debug.ui.launchShortcuts"]/shortcut/@class
 */
public class PSLaunchShortcut implements ILaunchShortcut {

	extension ILaunchManager = DebugPlugin.^default.launchManager

	public new() {
	}

	override void launch(ISelection selection, String mode) {
		if (selection instanceof IStructuredSelection) {
			val element = (selection as IStructuredSelection).firstElement
			if (element instanceof IFile)
				launch(element as IFile, mode)
		}
	}

	override void launch(IEditorPart editor, String mode) {
		val editorInput = editor.editorInput
		val file = editorInput.getAdapter(IFile) as IFile
		if (file != null)
			launch(file, mode)
	}

	def private void launch(IFile file, String mode) {
		val program = file.location.toFile.toString
		val configurations = getConfigurations(program)
		val configuration = switch (configurations.length) {
			case 0:
				createConfiguration(program)
			case 1:
				configurations.get(0)
			default:
				chooseConfiguration(configurations)
		}
		if (configuration != null)
			configuration.launch(mode)
	}

	def private ILaunchConfiguration[] getConfigurations(String program) {
		val result = <ILaunchConfiguration>newArrayList
		val type = PSLaunchConfigurationDelegate.ID.launchConfigurationType
		try {
			val configurations = type.launchConfigurations
			for (configuration : configurations) {
				if (!configuration.isPrivate && program ==
					configuration.getAttribute(IPSConstants.ATTR_PROGRAM, null as String)) {
					result += configuration
				}
			}
		} catch (CoreException e) {
			DebugPlugin.log(e)
		}
		return result
	}

	def private ILaunchConfiguration createConfiguration(String program) {
		val type = PSLaunchConfigurationDelegate.ID.launchConfigurationType
		val name = type.name.generateLaunchConfigurationName
		try {
			val workingCopy = type.newInstance(null, name) => [
				setAttribute(IPSConstants.ATTR_PROGRAM, program)
				setAttribute(DebugPlugin.ATTR_PROCESS_FACTORY_ID, PSProcessFactory.ID)
				setAttribute(IPSConstants.ATTR_GS_ARGUMENTS, "-dBATCH") //$NON-NLS-1$
			]
			return workingCopy.doSave
		} catch (CoreException e) {
			DebugPlugin.log(e)
			return null
		}
	}

	def private ILaunchConfiguration chooseConfiguration(ILaunchConfiguration[] configs) {
		val labelProvider = newDebugModelPresentation
		val dialog = new ElementListSelectionDialog(shell, labelProvider) => [
			elements = configs
			title = "Select PostScript Application"
			message = "Select existing configuration:"
			multipleSelection = false
		]
		val result = dialog.open
		labelProvider.dispose
		if (result == Window.OK)
			return dialog.firstResult as ILaunchConfiguration
		return null
	}

	def private Shell getShell() {
		return PlatformUI.workbench.activeWorkbenchWindow.shell
	}
}