package de.tfritsch.psdt.tests

import com.google.inject.Inject
import de.tfritsch.psdt.PostscriptUiInjectorProvider
import de.tfritsch.psdt.postscript.PSFile
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.resource.XtextResource
import org.eclipse.xtext.ui.editor.hyperlinking.IHyperlinkHelper
import org.junit.Test
import org.junit.runner.RunWith

import static org.junit.Assert.*

@RunWith(XtextRunner)
@InjectWith(PostscriptUiInjectorProvider)
class HyperlinkHelperTest {

	@Inject extension ParseHelper<PSFile>
	@Inject extension IHyperlinkHelper

	@Test
	def void testUnknown() throws Exception {
		val resource = '''
			unknown
		'''.parse.eResource as XtextResource
		val hyperlinks = resource.createHyperlinksByOffset(0, true)
		assertNull(hyperlinks)
	}

	@Test
	def void testShow() throws Exception {
		val resource = '''
			(Hello) show
		'''.parse.eResource as XtextResource
		val hyperlinks = resource.createHyperlinksByOffset(10, true)
		assertEquals(#["Operator"], hyperlinks.map[hyperlinkText])
	}

	@Test
	def void testFontType() throws Exception {
		val resource = '''
			/FontType 3
		'''.parse.eResource as XtextResource
		val hyperlinks = resource.createHyperlinksByOffset(0, true)
		assertEquals(
			#["Entry in a font dictionary", "Resource category"],
			hyperlinks.map[hyperlinkText]
		)
	}
}
