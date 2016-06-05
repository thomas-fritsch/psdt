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
import org.eclipse.debug.core.DebugException
import org.eclipse.debug.core.ILaunchManager
import org.eclipse.debug.core.model.IStackFrame
import org.eclipse.jface.text.BadLocationException
import org.eclipse.xtext.ui.editor.XtextEditor
import org.junit.Test

import static org.eclipse.xtext.junit4.ui.util.IResourcesSetupUtil.*

import static extension de.tfritsch.psdt.debug.PSLaunchExtensions.*
import static extension org.eclipse.debug.ui.DebugUITools.*

/**
 * @author Thomas Fritsch - initial API and implementation
 */
class DebugTest extends AbstractDebugTest {

	IFile file

	override setUp() throws Exception {
		super.setUp
		val project = createProject("test")
		file = createFile(project.name + "/hello.ps",
			'''
				%!PS-Adobe-2.0
				/A {(Hello world) print} def
				A
				A
				showpage
			''')
		showDebugPerspective // avoid dialog "Want to switch to Debug perspective?"
	}

	protected override createLaunchConfiguration(IFile file) throws CoreException {
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

	private def void assertCurrentToken(int expectedLineNumber, String expectedToken) throws DebugException, BadLocationException {
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
		for (i : 1..3) {
			currentStackFrame.stepInto
			waitFor[currentStackFrame != null]
		}
		assertCurrentToken(3, "A")
		currentStackFrame.stepInto
		waitFor[currentStackFrame != null]
		assertCurrentToken(2, "(Hello world)")
		currentStackFrame.stepReturn
		waitFor[currentStackFrame != null]
		assertCurrentToken(4, "A")
		currentStackFrame.stepOver
		waitFor[currentStackFrame != null]
		assertCurrentToken(5, "showpage")
	}

	@Test
	def void testBreakpoint() throws Exception {
		file.createLaunchConfiguration.launch(ILaunchManager.DEBUG_MODE)
		waitFor[launches.length > 0]
		waitFor[currentStackFrame != null]
		waitFor[activeEditor instanceof XtextEditor]
		assertTrue(currentStackFrame.suspended)
		(activeEditor as XtextEditor).toogleBreakpoint(5)
		waitFor[true]
		currentStackFrame.resume
		waitFor[currentStackFrame != null]
		assertTrue(currentStackFrame.suspended)
		assertCurrentToken(5, "showpage")
	}
}
