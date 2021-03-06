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
import org.eclipse.jface.text.BadLocationException
import org.eclipse.xtext.ui.editor.XtextEditor
import org.junit.Test

import static org.eclipse.xtext.junit4.ui.util.IResourcesSetupUtil.createFile

import static extension de.tfritsch.psdt.debug.PSLaunchExtensions.setBreakOnFirstToken
import static extension org.eclipse.debug.ui.DebugUITools.launch

/**
 * @author Thomas Fritsch - initial API and implementation
 */
class DebugTest extends AbstractDebugTest {

	IFile file

	override setUp() throws Exception {
		super.setUp
		file = createFile(project.name + "/hello.ps",
			'''
				%!PS-Adobe-2.0
				/A {(Hello world) print} def
				A
				A 1 pop
				showpage
			''')
		showDebugPerspective // avoid dialog "Want to switch to Debug perspective?"
	}

	protected override createLaunchConfiguration(IFile file) throws CoreException {
		super.createLaunchConfiguration(file) => [
			breakOnFirstToken = true
		]
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
		assertCurrentToken(4, "1")
	}

	@Test
	def void testBreakpoint() throws Exception {
		file.createLaunchConfiguration.launch(ILaunchManager.DEBUG_MODE)
		waitFor[launches.length > 0]
		waitFor[currentStackFrame != null]
		waitFor[activeEditor instanceof XtextEditor]
		assertTrue(currentStackFrame.suspended)
		(activeEditor as XtextEditor).toogleBreakpoint(5)
		assertEquals(1, currentThread.breakpoints.length)
		waitFor[true]
		currentStackFrame.resume
		waitFor[currentStackFrame != null]
		assertTrue(currentStackFrame.suspended)
		assertCurrentToken(5, "showpage")
	}

	@Test
	def void testBreakpointMultiple() throws Exception {
		file.createLaunchConfiguration.launch(ILaunchManager.DEBUG_MODE)
		waitFor[launches.length > 0]
		waitFor[currentStackFrame != null]
		waitFor[activeEditor instanceof XtextEditor]
		assertTrue(currentStackFrame.suspended)
		(activeEditor as XtextEditor).toogleBreakpoint(4) // line 4 has 3 tokens
		assertEquals(1, currentThread.breakpoints.length)
		waitFor[true]
		currentStackFrame.resume
		waitFor[currentStackFrame != null]
		assertTrue(currentStackFrame.suspended)
		assertCurrentToken(4, "A")
		currentStackFrame.resume
		waitFor[currentStackFrame != null]
		assertTrue(currentStackFrame.suspended)
		assertCurrentToken(4, "1")
		currentStackFrame.resume
		waitFor[currentStackFrame != null]
		assertTrue(currentStackFrame.suspended)
		assertCurrentToken(4, "pop")
	}

	@Test
	def void testRunToLine() throws Exception {
		file.createLaunchConfiguration.launch(ILaunchManager.DEBUG_MODE)
		waitFor[launches.length > 0]
		waitFor[currentStackFrame != null]
		waitFor[activeEditor instanceof XtextEditor]
		assertTrue(currentStackFrame.suspended)
		(activeEditor as XtextEditor).runToLine(5, currentStackFrame)
		waitFor[true]
		waitFor[currentStackFrame != null]
		assertTrue(currentStackFrame.suspended)
		assertEquals(0, currentThread.breakpoints.length)
		assertCurrentToken(5, "showpage")
	}
}
