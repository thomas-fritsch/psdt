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
import org.eclipse.core.resources.IProject
import org.eclipse.core.runtime.CoreException
import org.eclipse.core.runtime.Platform
import org.eclipse.debug.core.DebugPlugin
import org.eclipse.debug.core.ILaunchConfigurationWorkingCopy
import org.eclipse.debug.core.ILaunchManager
import org.eclipse.debug.core.model.IStackFrame
import org.eclipse.xtext.junit4.ui.AbstractWorkbenchTest
import org.junit.Test

import static org.eclipse.xtext.junit4.ui.util.IResourcesSetupUtil.*

import static extension de.tfritsch.psdt.debug.LaunchExtensions.*
import static extension de.tfritsch.psdt.debug.PSLaunchExtensions.*
import static extension org.eclipse.debug.ui.DebugUITools.*

/**
 * @author Thomas Fritsch - initial API and implementation
 */
class LaunchTest extends AbstractWorkbenchTest {

	extension ILaunchManager = DebugPlugin.^default.launchManager

	IProject project
	IFile file

	override setUp() throws Exception {
		super.setUp
		Platform.getPlugin("de.tfritsch.psdt.debug") // make sure our plugin is activated
		project = createProject("test")
		file = createFile(project.name + "/hello.ps",
			'''
				%!PS
				(Hello world\n) print
			''')
	}

	private def void showDebugPerspective() {
		val descriptor = workbench.perspectiveRegistry.findPerspectiveWithLabel("Debug")
		workbench.showPerspective(descriptor.id, workbenchWindow)
	}

	def private ILaunchConfigurationWorkingCopy createConfiguration(IFile file) throws CoreException {
		val type = "de.tfritsch.psdt.debug.launchConfigurationType".launchConfigurationType
		return type.newInstance(project, "hello") => [
			launchInBackground = false
			processFactoryId = "de.tfritsch.psdt.debug.processFactory"
			program = file.location.toOSString
			ghostscriptArguments = "-dBATCH"
		]
	}

	@Test
	def testRun() throws CoreException {
		file.createConfiguration.launch(ILaunchManager.RUN_MODE)
	}

	@Test
	def testDebug() throws CoreException {
		file.createConfiguration.launch(ILaunchManager.DEBUG_MODE)
	}

	@Test
	def testDebugWithBreakOnFirstToken() throws CoreException {
		showDebugPerspective // avoid dialog "Want to switch to Debug perspective?"
		val cfg = file.createConfiguration => [
			breakOnFirstToken = true
		]
		cfg.launch(ILaunchManager.DEBUG_MODE)
		sleep(5000)
		val stackFrame = debugContext?.getAdapter(IStackFrame) as IStackFrame
		assertNotNull(stackFrame)
		stackFrame.resume
		sleep(5000)
	}
}
