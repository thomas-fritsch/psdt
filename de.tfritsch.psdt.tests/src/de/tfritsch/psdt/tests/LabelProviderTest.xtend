package de.tfritsch.psdt.tests

import com.google.inject.Inject
import de.tfritsch.psdt.PostscriptUiInjectorProvider
import de.tfritsch.psdt.postscript.PostscriptFactory
import org.eclipse.jface.viewers.ILabelProvider
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.junit.Test
import org.junit.runner.RunWith

import static org.junit.Assert.*

/**
 * Run this as "JUnit Plugin Test".
 */
@RunWith(XtextRunner)
@InjectWith(PostscriptUiInjectorProvider)
class LabelProviderTest {

	@Inject extension ILabelProvider

	extension PostscriptFactory = PostscriptFactory.eINSTANCE

	@Test
	def void testProcedure() {
		val obj = createPSProcedure
		assertEquals("{...}", obj.text)
	}

	@Test
	def void testArray() {
		val obj = createPSArray
		assertEquals("[...]", obj.text)
	}

	@Test
	def void testDictionary() {
		val obj = createPSDictionary
		assertEquals("<<...>>", obj.text)
	}

	@Test
	def void testInt() {
		val obj = createPSInt => [i = 42]
		assertEquals("42", obj.text)
	}

	@Test
	def void testFloat() {
		val obj = createPSFloat => [f = 42.1F]
		assertEquals("42.1", obj.text)
	}

	@Test
	def void testString() {
		val obj = createPSString => [bytes = "Hello".bytes]
		assertEquals("(Hello)", obj.text)
	}

	@Test
	def void testExecutableName() {
		val obj = createPSExecutableName => [name = "showpage"]
		assertEquals("showpage", obj.text)
	}

	@Test
	def void testLiteralName() {
		val obj = createPSLiteralName => [name = "/showpage"]
		assertEquals("/showpage", obj.text)
	}

	@Test
	def void testUnparsedData() {
		val obj = createPSUnparsedData
		assertEquals("Data", obj.text)
	}
}
