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
import org.eclipse.debug.core.ILaunchManager
import org.eclipse.debug.core.model.IStackFrame
import org.eclipse.xtext.ui.editor.XtextEditor
import org.junit.Test

import static org.eclipse.xtext.junit4.ui.util.IResourcesSetupUtil.*

import static extension de.tfritsch.psdt.debug.PSLaunchExtensions.*
import static extension org.eclipse.debug.ui.DebugUITools.*

/**
 * @author Thomas Fritsch - initial API and implementation
 */
class LaunchTest extends AbstractDebugTest {

	IFile file

	override setUp() throws Exception {
		super.setUp
		val project = createProject("test")
		file = createFile(project.name + "/hello.ps",
			'''
				%!PS
				(Hello world\n) print
			''')
	}

	@Test
	def testRun() throws Exception {
		file.createLaunchConfiguration.launch(ILaunchManager.RUN_MODE)
		waitFor[launches.length > 0]
		val launch = launches.get(0)
		waitFor[launch.terminated]
	}

	@Test
	def testDebug() throws Exception {
		file.createLaunchConfiguration.launch(ILaunchManager.DEBUG_MODE)
		waitFor[launches.length > 0]
		val launch = launches.get(0)
		waitFor[launch.terminated]
	}

	@Test
	def testDebugWithBreakOnFirstToken() throws Exception {
		showDebugPerspective // avoid dialog "Want to switch to Debug perspective?"
		val cfg = file.createLaunchConfiguration => [
			breakOnFirstToken = true
		]
		cfg.launch(ILaunchManager.DEBUG_MODE)
		waitFor[launches.length > 0]
		val launch = launches.get(0)
		waitFor[launch.debugTarget.suspended]
		waitFor[activeEditor instanceof XtextEditor]
		val stackFrame = debugContext.getAdapter(IStackFrame) as IStackFrame
		stackFrame.resume
		waitFor[launch.terminated]
	}
}
