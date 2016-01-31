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

import static org.eclipse.xtext.diagnostics.Diagnostic.SYNTAX_DIAGNOSTIC

@RunWith(XtextRunner)
@InjectWith(PostscriptInjectorProvider)
class ValidatorTest {

	@Inject extension ParseHelper<PSFile>

	@Inject extension ValidationTestHelper

	extension PostscriptPackage = PostscriptPackage.eINSTANCE

	@Test
	def testMissingCloseProcedure() {
		val file = '''{ a b'''.parse
		file.assertError(PSExecutableName, SYNTAX_DIAGNOSTIC, "expecting '}'")
	}

	@Test
	def testExtraneousCloseProcedure() {
		val file = '''a b }'''.parse
		file.assertError(PSFile, SYNTAX_DIAGNOSTIC, "extraneous input '}'")
	}

	@Test
	def testMissingCloseArray() {
		val file = '''[ a b'''.parse
		file.assertError(PSExecutableName, SYNTAX_DIAGNOSTIC, "expecting ']'")
	}

	@Test
	def testExtraneousCloseArray() {
		val file = '''a b ]'''.parse
		file.assertError(PSFile, SYNTAX_DIAGNOSTIC, "extraneous input ']'")
	}

	@Test
	def testMissingCloseDictionary() {
		val file = '''<< a b'''.parse
		file.assertError(PSExecutableName, SYNTAX_DIAGNOSTIC, "expecting '>>'")
	}

	@Test
	def testExtraneousCloseDictionary() {
		val file = '''a b >>'''.parse
		file.assertError(PSFile, SYNTAX_DIAGNOSTIC, "extraneous input '>>'")
	}
}
