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

import de.tfritsch.psdt.PostscriptUiInjectorProvider
import org.eclipse.core.resources.IFile
import org.eclipse.core.runtime.CoreException
import org.eclipse.core.runtime.Platform
import org.eclipse.debug.core.ILaunchManager
import org.eclipse.debug.ui.ILaunchShortcut
import org.eclipse.jface.viewers.StructuredSelection
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.junit.BeforeClass
import org.junit.Test
import org.junit.runner.RunWith

import static org.eclipse.xtext.junit4.ui.util.IResourcesSetupUtil.*

/**
 * @author Thomas Fritsch - initial API and implementation
 */
@RunWith(XtextRunner)
@InjectWith(PostscriptUiInjectorProvider)
class LaunchShortcutTest extends AbstractDebugTest {

	static ILaunchShortcut launchShortcut

	IFile file

	@BeforeClass
	def static void setUpClass() throws Exception {
		launchShortcut = createLaunchShortcut
	}

	private static def ILaunchShortcut createLaunchShortcut() throws CoreException {
		return Platform.extensionRegistry.getExtensionPoint("org.eclipse.debug.ui", "launchShortcuts").
			configurationElements.findFirst[getAttribute("label") == "PostScript Application"].
			createExecutableExtension("class") as ILaunchShortcut
	}

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
	def void testRunFile() throws Exception {
		val selection = new StructuredSelection(file)
		launchShortcut.launch(selection, ILaunchManager.RUN_MODE)
		waitFor[launches.length > 0]
	}

	@Test
	def void testRunEditor() throws Exception {
		val editor = openEditor(file)
		launchShortcut.launch(editor, ILaunchManager.RUN_MODE)
		waitFor[launches.length > 0]
	}

}
