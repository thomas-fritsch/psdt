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
import org.eclipse.debug.core.DebugException
import org.eclipse.debug.core.ILaunchManager
import org.eclipse.debug.core.model.IStackFrame
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.ui.editor.XtextEditor
import org.junit.Test
import org.junit.runner.RunWith

import static org.eclipse.xtext.junit4.ui.util.IResourcesSetupUtil.*

import static extension de.tfritsch.psdt.debug.PSLaunchExtensions.*
import static extension org.eclipse.debug.ui.DebugUITools.*

/**
 * @author Thomas Fritsch - initial API and implementation
 */
@RunWith(XtextRunner)
@InjectWith(PostscriptUiInjectorProvider)
class DebugTest extends AbstractDebugTest {

	IFile file

	override setUp() throws Exception {
		super.setUp
		val project = createProject("test")
		file = createFile(project.name + "/hello.ps",
			'''
				%!PS-Adobe-2.0
				/Times-Roman findfont 60 scalefont setfont
				50 600 moveto
				(Hello World) show
				showpage
			''')
		showDebugPerspective // avoid dialog "Want to switch to Debug perspective?"
	}

	protected override createLaunchConfiguration(IFile file) {
		super.createLaunchConfiguration(file) => [
			breakOnFirstToken = true
		]
	}

	private def <T> T getCurrent(Class<T> adapterType) {
		return debugContext?.getAdapter(adapterType) as T
	}

	private def IStackFrame getCurrentStackFrame() {
		return getCurrent(IStackFrame)
	}

	private def void assertCurrentToken(int expectedLineNumber, String expectedToken) throws DebugException {
		val stackFrame = currentStackFrame
		assertEquals(expectedLineNumber, stackFrame.lineNumber)
		val offset = stackFrame.charStart
		val length = stackFrame.charEnd - stackFrame.charStart
		val token = (activeEditor as XtextEditor).document.get(offset, length)
		assertEquals(expectedToken, token)
	}

	@Test
	def void testResume() throws Exception {
		file.createLaunchConfiguration.launch(ILaunchManager.DEBUG_MODE)
		waitFor[launches.length > 0]
		waitFor[currentStackFrame != null]
		waitFor[activeEditor instanceof XtextEditor]
		assertTrue(currentStackFrame.suspended)
		assertTrue(currentStackFrame.canResume)
		currentStackFrame.resume
		// will hang in showpage
	}

	@Test
	def void testStep() throws Exception {
		file.createLaunchConfiguration.launch(ILaunchManager.DEBUG_MODE)
		waitFor[launches.length > 0]
		waitFor[currentStackFrame != null]
		waitFor[activeEditor instanceof XtextEditor]
		assertTrue(currentStackFrame.suspended)
		assertTrue(currentStackFrame.canStepInto)
		assertTrue(currentStackFrame.canStepOver)
		assertTrue(currentStackFrame.canStepReturn)
		assertCurrentToken(2, "/Times-Roman")
		currentStackFrame.stepInto
		waitFor[currentStackFrame != null]
		assertCurrentToken(2, "findfont")
		currentStackFrame.stepInto
		waitFor[currentStackFrame != null]
		assertCurrentToken(2, "60")
	}
}
