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

import com.google.inject.Inject
import com.google.inject.Provider
import de.tfritsch.psdt.PostscriptUiInjectorProvider
import de.tfritsch.psdt.debug.ui.breakpoints.PSRunToLineTarget
import de.tfritsch.psdt.debug.ui.breakpoints.PSToggleBreakpointsTarget
import org.eclipse.debug.ui.actions.IRunToLineTarget
import org.eclipse.debug.ui.actions.IToggleBreakpointsTarget
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.ui.editor.XtextEditor
import org.junit.Test
import org.junit.runner.RunWith

import static org.junit.Assert.assertNotNull
import static org.junit.Assert.assertTrue

/**
 * @author Thomas Fritsch - initial API and implementation
 */
@RunWith(XtextRunner)
@InjectWith(PostscriptUiInjectorProvider)
class AdapterFactoryTest {

	@Inject Provider<XtextEditor> editorProvider

	@Test
	def void testToggleBreakpointsTarget() {
		val editor = editorProvider.get
		val adapter = editor.getAdapter(IToggleBreakpointsTarget)
		assertNotNull(adapter)
		assertTrue(adapter instanceof PSToggleBreakpointsTarget)
	}

	@Test
	def void testRunToLineTarget() {
		val editor = editorProvider.get
		val adapter = editor.getAdapter(IRunToLineTarget)
		assertNotNull(adapter)
		assertTrue(adapter instanceof PSRunToLineTarget)
	}
}
