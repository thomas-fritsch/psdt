package de.tfritsch.psdt.tests

import com.google.inject.Inject
import de.tfritsch.psdt.PostscriptInjectorProvider
import de.tfritsch.psdt.postscript.PostscriptFactory
import org.eclipse.xtext.documentation.IEObjectDocumentationProvider
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.junit.Test
import org.junit.runner.RunWith

import static org.junit.Assert.*

/**
 * Run this as "JUnit Plugin Test",
 * because our DocumentationProvider needs the started org.eclipse.help plugin.
 */
@RunWith(XtextRunner)
@InjectWith(PostscriptInjectorProvider)
class DocumentationProviderTest {

	@Inject extension IEObjectDocumentationProvider

	extension PostscriptFactory = PostscriptFactory.eINSTANCE

	@Test
	def testExecutableName() {
		val obj = createPSExecutableName => [
			name = "def"
		]
		assertNotNull(obj.documentation)
	}

	@Test
	def testLiteralName() {
		val obj = createPSLiteralName => [
			name = "/BuildGlyph"
		]
		assertNotNull(obj.documentation)
	}

}
