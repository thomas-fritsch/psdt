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
import de.tfritsch.psdt.postscript.PSArray
import de.tfritsch.psdt.postscript.PSDictionary
import de.tfritsch.psdt.postscript.PSInt
import de.tfritsch.psdt.postscript.PSFile
import de.tfritsch.psdt.postscript.PSFloat
import de.tfritsch.psdt.postscript.PSProcedure
import de.tfritsch.psdt.postscript.PSString
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.junit.Test
import org.junit.runner.RunWith

import static org.junit.Assert.*
import de.tfritsch.psdt.postscript.PSUnparsedData

/**
 * @author Thomas Fritsch - initial API and implementation
 */
@RunWith(XtextRunner)
@InjectWith(PostscriptInjectorProvider)
class ParserTest {

	@Inject extension ParseHelper<PSFile>

	@Test
	def testEmptyFile() {
		val file = ''''''.parse
		assertNotNull(file)
		assertEquals(0, file.objects.size)
	}

	@Test
	def testInt() {
		val file = '''42'''.parse
		val obj = file.objects.get(0)
		assertTrue(obj instanceof PSInt)
	}

	@Test
	def testFloat() {
		val file = '''42.0'''.parse
		val obj = file.objects.get(0)
		assertTrue(obj instanceof PSFloat)
	}

	@Test
	def testString() {
		val file = '''()'''.parse
		val obj = file.objects.get(0)
		assertTrue(obj instanceof PSString)
	}

	@Test
	def testAsciiHexString() {
		val file = '''<>'''.parse
		val obj = file.objects.get(0)
		assertTrue(obj instanceof PSString)
	}

	@Test
	def testAscii85String() {
		val file = '''
			<~~>
		'''.parse
		val obj = file.objects.get(0)
		assertTrue(obj instanceof PSString)
	}

	@Test
	def testProcedure() {
		val file = '''
			{}
		'''.parse
		val obj = file.objects.get(0)
		assertTrue(obj instanceof PSProcedure)
	}

	@Test
	def testArray() {
		val file = '''
			[]
		'''.parse
		val obj = file.objects.get(0)
		assertTrue(obj instanceof PSArray)
	}

	@Test
	def testDictionary() {
		val file = '''
			<< >>
		'''.parse
		val obj = file.objects.get(0)
		assertTrue(obj instanceof PSDictionary)
	}

	@Test
	def testUnparsedData() {
		val file = '''
			%%BeginData:
			ygbyydy<fgGADGA{YDBYDB[VDAV
			%%EndData
		'''.parse
		val obj = file.objects.get(0)
		assertTrue(obj instanceof PSUnparsedData)
	}
}
