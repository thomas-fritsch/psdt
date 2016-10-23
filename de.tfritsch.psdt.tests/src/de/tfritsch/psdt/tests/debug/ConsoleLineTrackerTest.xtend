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
import org.eclipse.debug.core.ILaunchManager
import org.eclipse.debug.ui.console.IConsole
import org.eclipse.jface.text.IDocument
import org.eclipse.jface.text.Position
import org.eclipse.ui.internal.console.ConsoleHyperlinkPosition
import org.eclipse.xtext.ui.editor.XtextEditor
import org.junit.Test

import static org.eclipse.debug.ui.DebugUITools.getCurrentProcess
import static org.eclipse.xtext.junit4.ui.util.IResourcesSetupUtil.createFile

import static extension de.tfritsch.psdt.debug.PSLaunchExtensions.setBreakOnFirstToken
import static extension org.eclipse.debug.ui.DebugUITools.getConsole
import static extension org.eclipse.debug.ui.DebugUITools.launch

/**
 * @author Thomas Fritsch - initial API and implementation
 */
class ConsoleLineTrackerTest extends AbstractDebugTest {

	override setUp() throws Exception {
		super.setUp
		showDebugPerspective // avoid dialog "Want to switch to Debug perspective?"
	}

	protected override createLaunchConfiguration(IFile file) throws CoreException {
		super.createLaunchConfiguration(file) => [
			breakOnFirstToken = true
		]
	}

	private def Position[] getHyperlinkPositions(IDocument document) {
		document.getPositions(ConsoleHyperlinkPosition.HYPER_LINK_CATEGORY)
	}

	@Test
	def void testErrorHyperlink() throws Exception {
		createFile(project.name + "/hello.ps",
			'''
				%!PS-Adobe-2.0
				1 add  % causes stackunderflow error
			''').createLaunchConfiguration.launch(ILaunchManager.DEBUG_MODE)
		waitFor[launches.length > 0]
		waitFor[activeEditor instanceof XtextEditor]
		currentStackFrame.resume
		val document = (currentProcess.console as IConsole).document
		waitFor[document.hyperlinkPositions.length > 0]
		val hyperlinkPosition = document.hyperlinkPositions.get(0)
		val text = document.get(hyperlinkPosition.offset, hyperlinkPosition.length)
		assertEquals("/stackunderflow", text)
	}
}
