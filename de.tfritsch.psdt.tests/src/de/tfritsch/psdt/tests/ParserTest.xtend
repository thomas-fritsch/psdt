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
import de.tfritsch.psdt.postscript.PSArray
import de.tfritsch.psdt.postscript.PSDictionary
import de.tfritsch.psdt.postscript.PSExecutableName
import de.tfritsch.psdt.postscript.PSFile
import de.tfritsch.psdt.postscript.PSFloat
import de.tfritsch.psdt.postscript.PSImmediatelyEvaluatedName
import de.tfritsch.psdt.postscript.PSInt
import de.tfritsch.psdt.postscript.PSLiteralName
import de.tfritsch.psdt.postscript.PSProcedure
import de.tfritsch.psdt.postscript.PSString
import de.tfritsch.psdt.postscript.PSUnparsedData
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.junit.Test
import org.junit.runner.RunWith

import static org.junit.Assert.assertEquals
import static org.junit.Assert.assertNotNull
import static org.junit.Assert.assertTrue

/**
 * @author Thomas Fritsch - initial API and implementation
 */
@RunWith(XtextRunner)
@InjectWith(PostscriptInjectorProvider)
class ParserTest {

	@Inject extension ParseHelper<PSFile>

	@Test
	def testEmptyFile() throws Exception {
		val file = ''''''.parse
		assertNotNull(file)
		assertEquals(0, file.objects.size)
	}

	@Test
	def testInt() throws Exception {
		val file = '''42'''.parse
		val obj = file.objects.get(0)
		assertTrue(obj instanceof PSInt)
	}

	@Test
	def testFloat() throws Exception {
		val file = '''42.0'''.parse
		val obj = file.objects.get(0)
		assertTrue(obj instanceof PSFloat)
	}

	@Test
	def testString() throws Exception {
		val file = '''()'''.parse
		val obj = file.objects.get(0)
		assertTrue(obj instanceof PSString)
	}

	@Test
	def testAsciiHexString() throws Exception {
		val file = '''<>'''.parse
		val obj = file.objects.get(0)
		assertTrue(obj instanceof PSString)
	}

	@Test
	def testExecutableName() throws Exception {
		val file = '''name'''.parse
		val obj = file.objects.get(0)
		assertTrue(obj instanceof PSExecutableName)
	}

	@Test
	def testLiteralNameName() throws Exception {
		val file = '''/name'''.parse
		val obj = file.objects.get(0)
		assertTrue(obj instanceof PSLiteralName)
	}

	@Test
	def testImmediatelyEvaluatedName() throws Exception {
		val file = '''//name'''.parse
		val obj = file.objects.get(0)
		assertTrue(obj instanceof PSImmediatelyEvaluatedName)
	}

	@Test
	def testAscii85String() throws Exception {
		val file = '''
			<~~>
		'''.parse
		val obj = file.objects.get(0)
		assertTrue(obj instanceof PSString)
	}

	@Test
	def testProcedure() throws Exception {
		val file = '''
			{}
		'''.parse
		val obj = file.objects.get(0)
		assertTrue(obj instanceof PSProcedure)
	}

	@Test
	def testArray() throws Exception {
		val file = '''
			[]
		'''.parse
		val obj = file.objects.get(0)
		assertTrue(obj instanceof PSArray)
	}

	@Test
	def testDictionary() throws Exception {
		val file = '''
			<< >>
		'''.parse
		val obj = file.objects.get(0)
		assertTrue(obj instanceof PSDictionary)
	}

	@Test
	def testUnparsedData() throws Exception {
		val file = '''
			%%BeginData:
			ygbyydy<fgGADGA{YDBYDB[VDAV
			%%EndData
		'''.parse
		val obj = file.objects.get(0)
		assertTrue(obj instanceof PSUnparsedData)
	}

	@Test
	def testASCII85StringContainingAngleChars() throws Exception {
		val file = '''
			<~<123>~>>
		'''.parse
		assertEquals(1, file.objects.length)
		val string = file.objects.get(0) as PSString
		assertEquals(4, string.bytes.length)
	}

	@Test
	def testDictionaryContainingASCIIHexString() throws Exception {
		val file = '''
			<<<>>>
		'''.parse
		assertEquals(1, file.objects.length)
		val dict = file.objects.get(0) as PSDictionary
		val innerObj = dict.objects.get(0)
		assertTrue(innerObj instanceof PSString)
	}

	@Test
	def testASCIIHexStringThenASCII85String() throws Exception {
		val file = '''
			<><~~>
		'''.parse
		assertEquals(2, file.objects.length)
		assertTrue(file.objects.get(0) instanceof PSString)
		assertTrue(file.objects.get(1) instanceof PSString)
	}

	@Test
	def testASCII85StringThenASCIIHexString() throws Exception {
		val file = '''
			<~~><>
		'''.parse
		assertEquals(2, file.objects.length)
		assertTrue(file.objects.get(0) instanceof PSString)
		assertTrue(file.objects.get(1) instanceof PSString)
	}

	@Test
	def testASCII85StringThenASCII85String() throws Exception {
		val file = '''
			<~~><~~>
		'''.parse
		assertEquals(2, file.objects.length)
		assertTrue(file.objects.get(0) instanceof PSString)
		assertTrue(file.objects.get(1) instanceof PSString)
	}

	@Test
	def testASCIIHexStringThenDictionary() throws Exception {
		val file = '''
			<><<>>
		'''.parse
		assertEquals(2, file.objects.length)
		assertTrue(file.objects.get(0) instanceof PSString)
		assertTrue(file.objects.get(1) instanceof PSDictionary)
	}

	@Test
	def testDictionaryThenASCIIHexString() throws Exception {
		val file = '''
			<<>><>
		'''.parse
		assertEquals(2, file.objects.length)
		assertTrue(file.objects.get(0) instanceof PSDictionary)
		assertTrue(file.objects.get(1) instanceof PSString)
	}

	@Test
	def testDictionaryContainingASCII85String() throws Exception {
		val file = '''
			<<<~~>>>
		'''.parse
		assertEquals(1, file.objects.length)
		val dict = file.objects.get(0) as PSDictionary
		val innerObj = dict.objects.get(0)
		assertTrue(innerObj instanceof PSString)
	}
}
