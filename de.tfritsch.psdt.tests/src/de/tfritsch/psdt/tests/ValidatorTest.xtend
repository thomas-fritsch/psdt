package de.tfritsch.psdt.tests

import com.google.inject.Inject
import de.tfritsch.psdt.PostscriptInjectorProvider
import de.tfritsch.psdt.postscript.PSFile
import de.tfritsch.psdt.postscript.PostscriptPackage
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.junit.Test
import org.junit.runner.RunWith

import static org.eclipse.xtext.diagnostics.Diagnostic.*

@RunWith(XtextRunner)
@InjectWith(PostscriptInjectorProvider)
class ValidatorTest {

	@Inject extension ParseHelper<PSFile>

	@Inject extension ValidationTestHelper

	extension PostscriptPackage = PostscriptPackage.eINSTANCE

	@Test
	def testMissingCloseBrace() {
		val file = '''{ a b'''.parse
		file.assertError(
			PSExecutableName,
			SYNTAX_DIAGNOSTIC,
			"mismatched input '<EOF>' expecting '}'"
		)
	}

	@Test
	def testExtraneousCloseBrace() {
		val file = '''a b }'''.parse
		file.assertError(PSFile, SYNTAX_DIAGNOSTIC, "extraneous input '}' expecting EOF")
	}
}
