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
import org.eclipse.debug.core.ILaunchManager
import org.eclipse.debug.internal.ui.DebugUIPlugin
import org.eclipse.debug.internal.ui.launchConfigurations.LaunchShortcutExtension
import org.eclipse.jface.viewers.IStructuredSelection
import org.eclipse.jface.viewers.StructuredSelection
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.junit.Test
import org.junit.runner.RunWith

import static org.eclipse.xtext.junit4.ui.util.IResourcesSetupUtil.*

/**
 * @author Thomas Fritsch - initial API and implementation
 */
@RunWith(XtextRunner)
@InjectWith(PostscriptUiInjectorProvider)
class LaunchShortcutTest extends AbstractDebugTest {

	LaunchShortcutExtension launchShortcut
	IFile file

	override setUp() throws Exception {
		super.setUp
		launchShortcut = DebugUIPlugin.^default.launchConfigurationManager.launchShortcuts.findFirst[
			label == "PostScript Application"]
		val project = createProject("test")
		file = createFile(project.name + "/hello.ps",
			'''
				%!PS
				(Hello world\n) print
			''')
	}

	private def void assertEnabledFor(LaunchShortcutExtension it, Object object) throws CoreException {
		val list = switch (object) {
			IStructuredSelection:
				object.toList
			default:
				newArrayList(object)
		}
		val context = DebugUIPlugin.createEvaluationContext(list)
		context.addVariable("selection", list)
		val enabled = evalEnablementExpression(context, contextualLaunchEnablementExpression)
		assertTrue(enabled)
	}

	@Test
	def void testRunFile() throws Exception {
		val selection = new StructuredSelection(file)
		launchShortcut.assertEnabledFor(selection)
		launchShortcut.launch(selection, ILaunchManager.RUN_MODE)
		waitFor[launches.length > 0]
	}

	@Test
	def void testRunEditor() throws Exception {
		val editor = openEditor(file)
		launchShortcut.assertEnabledFor(editor.editorInput)
		launchShortcut.launch(editor, ILaunchManager.RUN_MODE)
		waitFor[launches.length > 0]
	}

}
