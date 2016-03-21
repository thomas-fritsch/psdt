/*******************************************************************************
 * Copyright (c) 2016 Thomas Fritsch.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
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

	@Test
	def testStringWithBalancedParentheses() {
		val file = '''(This is a (rather long) string)'''.parse
		file.assertNoErrors
	}

	@Test
	def testASCIIHexInvalid() {
		val file = '''<12345x78>'''.parse
		file.assertError(PS_STRING, SYNTAX_DIAGNOSTIC, "Illegal character 'x'")
	}

	@Test
	def testASCII85Invalid_1() {
		val file = '''<~12345x78~>'''.parse
		file.assertError(PS_STRING, SYNTAX_DIAGNOSTIC, "Illegal character 'x'")
	}

	@Test
	def testASCII85Invalid_2() {
		val file = '''<~123456~>'''.parse
		file.assertError(PS_STRING, SYNTAX_DIAGNOSTIC, "Final tuple '6' too short")
	}
}
