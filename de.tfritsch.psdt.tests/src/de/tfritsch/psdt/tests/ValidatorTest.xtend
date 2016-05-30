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

/**
 * @author Thomas Fritsch - initial API and implementation
 */
@RunWith(XtextRunner)
@InjectWith(PostscriptInjectorProvider)
class ValidatorTest {

	@Inject extension ParseHelper<PSFile>

	@Inject extension ValidationTestHelper

	@Test
	def testMissingCloseProcedure() throws Exception {
		val file = '''{ a b'''.parse
		file.assertError(PS_EXECUTABLE_NAME, SYNTAX_DIAGNOSTIC, "expecting '}'")
	}

	@Test
	def testExtraneousCloseProcedure() throws Exception {
		val file = '''a b }'''.parse
		file.assertError(PS_FILE, SYNTAX_DIAGNOSTIC, "extraneous input '}'")
	}

	@Test
	def testMissingCloseArray() throws Exception {
		val file = '''[ a b'''.parse
		file.assertError(PS_EXECUTABLE_NAME, SYNTAX_DIAGNOSTIC, "expecting ']'")
	}

	@Test
	def testExtraneousCloseArray() throws Exception {
		val file = '''a b ]'''.parse
		file.assertError(PS_FILE, SYNTAX_DIAGNOSTIC, "extraneous input ']'")
	}

	@Test
	def testMissingCloseDictionary() throws Exception {
		val file = '''<< a b'''.parse
		file.assertError(PS_EXECUTABLE_NAME, SYNTAX_DIAGNOSTIC, "expecting '>>'")
	}

	@Test
	def testExtraneousCloseDictionary() throws Exception {
		val file = '''a b >>'''.parse
		file.assertError(PS_FILE, SYNTAX_DIAGNOSTIC, "extraneous input '>>'")
	}

	@Test
	def testDPS() throws Exception {
		val file = '''fork'''.parse
		file.assertWarning(PS_EXECUTABLE_NAME, IssueCodes.DPS, "Display PostScript")
	}

	@Test
	def testStringWithBalancedParentheses() throws Exception {
		val file = '''(This is a (rather long) string)'''.parse
		file.assertNoErrors
	}

	@Test
	def testStringWithEscapedNewline() throws Exception {
		val file = '''
		(line1\
		line2)'''.parse
		file.assertNoErrors
	}

	@Test
	def testStringWithInvalidEscapeSequence() throws Exception {
		val file = '''(This is \a string)'''.parse
		file.assertNoErrors
	}

	@Test
	def testASCIIHexInvalid() throws Exception {
		val file = '''<12345x78>'''.parse
		file.assertError(PS_STRING, SYNTAX_DIAGNOSTIC, "Illegal character 'x'")
	}

	@Test
	def testASCII85Invalid_1() throws Exception {
		val file = '''<~12345x78~>'''.parse
		file.assertError(PS_STRING, SYNTAX_DIAGNOSTIC, "Illegal character 'x'")
	}

	@Test
	def testASCII85Invalid_2() throws Exception {
		val file = '''<~123456~>'''.parse
		file.assertError(PS_STRING, SYNTAX_DIAGNOSTIC, "Final tuple '6' too short")
	}
}
