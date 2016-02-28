package de.tfritsch.psdt.tests

import com.google.inject.Inject
import de.tfritsch.psdt.PostscriptInjectorProvider
import de.tfritsch.psdt.postscript.PSFile
import de.tfritsch.psdt.validation.IssueCodes
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.junit.Test
import org.junit.runner.RunWith

import static org.eclipse.xtext.diagnostics.Diagnostic.SYNTAX_DIAGNOSTIC
import static de.tfritsch.psdt.postscript.PostscriptPackage.Literals.*

@RunWith(XtextRunner)
@InjectWith(PostscriptInjectorProvider)
class ValidatorTest {

	@Inject extension ParseHelper<PSFile>

	@Inject extension ValidationTestHelper

	@Test
	def testMissingCloseProcedure() {
		val file = '''{ a b'''.parse
		file.assertError(PS_EXECUTABLE_NAME, SYNTAX_DIAGNOSTIC, "expecting '}'")
	}

	@Test
	def testExtraneousCloseProcedure() {
		val file = '''a b }'''.parse
		file.assertError(PS_FILE, SYNTAX_DIAGNOSTIC, "extraneous input '}'")
	}

	@Test
	def testMissingCloseArray() {
		val file = '''[ a b'''.parse
		file.assertError(PS_EXECUTABLE_NAME, SYNTAX_DIAGNOSTIC, "expecting ']'")
	}

	@Test
	def testExtraneousCloseArray() {
		val file = '''a b ]'''.parse
		file.assertError(PS_FILE, SYNTAX_DIAGNOSTIC, "extraneous input ']'")
	}

	@Test
	def testMissingCloseDictionary() {
		val file = '''<< a b'''.parse
		file.assertError(PS_EXECUTABLE_NAME, SYNTAX_DIAGNOSTIC, "expecting '>>'")
	}

	@Test
	def testExtraneousCloseDictionary() {
		val file = '''a b >>'''.parse
		file.assertError(PS_FILE, SYNTAX_DIAGNOSTIC, "extraneous input '>>'")
	}

	@Test
	def testDPS() {
		val file = '''fork'''.parse
		file.assertWarning(PS_EXECUTABLE_NAME, IssueCodes.DPS, "Display PostScript")
	}
}
