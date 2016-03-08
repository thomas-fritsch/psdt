/*******************************************************************************
 * Copyright (c) 2016 Thomas Fritsch.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 ******************************************************************************/
package de.tfritsch.psdt.tests.debug

import com.google.inject.Inject
import com.google.inject.Provider
import de.tfritsch.psdt.PostscriptUiInjectorProvider
import de.tfritsch.psdt.debug.ui.breakpoints.PSRunToLineTarget
import de.tfritsch.psdt.debug.ui.breakpoints.PSToggleBreakpointsTarget
import org.eclipse.core.runtime.Platform
import org.eclipse.debug.ui.actions.IRunToLineTarget
import org.eclipse.debug.ui.actions.IToggleBreakpointsTarget
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.ui.editor.XtextEditor
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith

import static org.junit.Assert.*

/**
 * @author Thomas Fritsch - initial API and implementation
 */
@RunWith(XtextRunner)
@InjectWith(PostscriptUiInjectorProvider)
class AdapterFactoryTest {

	@Inject Provider<XtextEditor> editorProvider

	@Before
	def void setUp() throws Exception {
		Platform.getPlugin("de.tfritsch.psdt.debug") // make sure our plugin is activated
	}

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
