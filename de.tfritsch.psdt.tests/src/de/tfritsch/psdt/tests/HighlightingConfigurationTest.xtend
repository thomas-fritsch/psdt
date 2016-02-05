package de.tfritsch.psdt.tests

import com.google.inject.Inject
import de.tfritsch.psdt.PostscriptUiInjectorProvider
import org.eclipse.swt.SWT
import org.eclipse.swt.graphics.RGB
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.ui.editor.syntaxcoloring.ITextAttributeProvider
import org.junit.Test
import org.junit.runner.RunWith

import static de.tfritsch.psdt.ui.syntaxcoloring.PostscriptHighlightingConfiguration.*
import static org.junit.Assert.*

@RunWith(XtextRunner)
@InjectWith(PostscriptUiInjectorProvider)
class HighlightingConfigurationTest {

	@Inject ITextAttributeProvider textAttributeProvider;

	@Test
	def void testLiteralName() {
		textAttributeProvider.getAttribute(LITERAL_NAME_ID) => [
			assertEquals(new RGB(128, 0, 255), foreground.RGB)
			assertNull(background)
			assertEquals(SWT.BOLD, style)
			assertNull(font)
		]
	}

	@Test
	def void testDSCComment() {
		textAttributeProvider.getAttribute(DSC_COMMENT_ID) => [
			assertEquals(new RGB(63, 95, 191), foreground.RGB)
			assertNull(background)
			assertEquals(SWT.NORMAL, style)
			assertNull(font)
		]
	}

	@Test
	def void testUnparsedData() {
		textAttributeProvider.getAttribute(UNPARSED_DATA_ID) => [
			assertEquals(new RGB(42, 0, 255), foreground.RGB)
			assertEquals(new RGB(220, 220, 220), background.RGB)
			assertEquals(SWT.NORMAL, style)
			assertNull(font)
		]
	}
}
