package de.tfritsch.psdt.tests

import com.google.inject.Inject
import de.tfritsch.psdt.PostscriptInjectorProvider
import de.tfritsch.psdt.postscript.PSArray
import de.tfritsch.psdt.postscript.PSDictionary
import de.tfritsch.psdt.postscript.PSFile
import de.tfritsch.psdt.postscript.PSProcedure
import de.tfritsch.psdt.postscript.PSString
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.junit.Test
import org.junit.runner.RunWith

import static org.junit.Assert.*

@RunWith(XtextRunner)
@InjectWith(PostscriptInjectorProvider)
class ParserTest {

	@Inject extension ParseHelper<PSFile>

	@Test
	def testEmptyFile() {
		val file = '''
		'''.parse
		assertNotNull(file)
		assertEquals(0, file.objects.size)
	}

	@Test
	def testString() {
		val file = '''
			()
		'''.parse
		val obj = file.objects.get(0)
		assertTrue(obj instanceof PSString)
	}

	@Test
	def testAsciiHexString() {
		val file = '''
			<>
		'''.parse
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

}