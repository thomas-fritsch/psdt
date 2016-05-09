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
package de.tfritsch.psdt.tests.debug

import de.tfritsch.psdt.tests.AbstractWorkbenchTestExtension
import org.eclipse.core.resources.IFile
import org.eclipse.core.resources.IProject
import org.eclipse.core.runtime.CoreException
import org.eclipse.debug.core.DebugPlugin
import org.eclipse.debug.core.ILaunchConfigurationWorkingCopy
import org.eclipse.debug.core.ILaunchManager
import org.eclipse.debug.ui.DebugUITools
import org.eclipse.debug.ui.IDebugUIConstants
import org.junit.Test

import static org.eclipse.xtext.junit4.ui.util.IResourcesSetupUtil.*

import static extension de.tfritsch.psdt.debug.LaunchExtensions.*
import static extension de.tfritsch.psdt.debug.PSLaunchExtensions.*
import org.eclipse.debug.ui.ILaunchConfigurationDialog

/**
 * @author Thomas Fritsch - initial API and implementation
 */
class LaunchConfigurationTabGroupTest extends AbstractWorkbenchTestExtension {

	extension ILaunchManager = DebugPlugin.^default.launchManager

	IProject project
	IFile file

	def private ILaunchConfigurationWorkingCopy createConfiguration(IFile file) throws CoreException {
		val type = "de.tfritsch.psdt.debug.launchConfigurationType".launchConfigurationType
		return type.newInstance(project, "hello") => [
			launchInBackground = false
			processFactoryId = "de.tfritsch.psdt.debug.processFactory"
			program = file.location.toOSString
			ghostscriptArguments = "-dBATCH"
		]
	}

	override setUp() {
		super.setUp
		project = createProject("test")
		file = createFile(project.name + "/hello.ps",
			'''
				%!PS
				(Hello world\n) print
			''')
	}

	private def openConfigurationDialogAndClose(IFile file, String groupId) {
		workbench.display.asyncExec [
			waitFor[workbench.display.activeShell.data instanceof ILaunchConfigurationDialog]
			workbench.display.activeShell.close
		]
		val config = file.createConfiguration
		DebugUITools.openLaunchConfigurationPropertiesDialog(workbenchWindow.shell, config, groupId)
	}

	@Test
	def void testRunConfigurationDialog() {
		file.openConfigurationDialogAndClose(IDebugUIConstants.ID_RUN_LAUNCH_GROUP)
	}

	@Test
	def void testDebugConfigurationDialog() {
		file.openConfigurationDialogAndClose(IDebugUIConstants.ID_DEBUG_LAUNCH_GROUP)
	}
}
