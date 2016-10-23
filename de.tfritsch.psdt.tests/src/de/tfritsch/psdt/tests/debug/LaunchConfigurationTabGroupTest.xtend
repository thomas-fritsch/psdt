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

import org.eclipse.core.resources.IFile
import org.eclipse.core.runtime.CoreException
import org.eclipse.debug.ui.IDebugUIConstants
import org.eclipse.debug.ui.ILaunchConfigurationDialog
import org.junit.Test

import static org.eclipse.debug.ui.DebugUITools.openLaunchConfigurationPropertiesDialog
import static org.eclipse.xtext.junit4.ui.util.IResourcesSetupUtil.createFile

/**
 * @author Thomas Fritsch - initial API and implementation
 */
class LaunchConfigurationTabGroupTest extends AbstractDebugTest {

	IFile file

	override setUp() throws Exception {
		super.setUp
		file = createFile(project.name + "/hello.ps",
			'''
				%!PS
				(Hello world\n) print
			''')
	}

	private def openConfigurationDialogAndClose(IFile file, String groupId) throws CoreException {
		workbench.display.asyncExec [
			waitFor[workbench.display.activeShell.data instanceof ILaunchConfigurationDialog]
			workbench.display.activeShell.close
		]
		val config = file.createLaunchConfiguration
		openLaunchConfigurationPropertiesDialog(workbenchWindow.shell, config, groupId)
	}

	@Test
	def void testRunConfigurationDialog() throws Exception  {
		file.openConfigurationDialogAndClose(IDebugUIConstants.ID_RUN_LAUNCH_GROUP)
	}

	@Test
	def void testDebugConfigurationDialog() throws Exception {
		file.openConfigurationDialogAndClose(IDebugUIConstants.ID_DEBUG_LAUNCH_GROUP)
	}
}
