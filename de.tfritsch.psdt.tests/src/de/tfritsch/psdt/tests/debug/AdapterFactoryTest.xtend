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
