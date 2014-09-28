package de.tfritsch.psdt.tests

import de.tfritsch.psdt.PostscriptInjectorProvider
import de.tfritsch.psdt.conversion.STRINGValueConverter
import org.eclipse.xtext.conversion.ValueConverterException
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith

import static org.junit.Assert.*

@RunWith(XtextRunner)
@InjectWith(PostscriptInjectorProvider)
class STRINGValueConverterTest extends AbstractStringValueConverterTest {

	@Before
	def void init() {
		converter = new STRINGValueConverter
	}

	@Test(expected=ValueConverterException)
	def void testBrokenStringLiteral() {
		converter.toValue("(", null)
	}

	@Test
	def void testEmpty() {
		val value = converter.toValue("()", null)
		assertEquals("", value)
		val string = converter.toString(value)
		assertEquals("()", string)
	}

	@Test
	def void testSimple() {
		val value = converter.toValue("(Hello world)", null)
		assertEquals("Hello world", value)
		val string = converter.toString(value)
		assertEquals("(Hello world)", string)
	}

	@Test
	def void testEscapeChars() {
		val value = converter.toValue("(\\b\\f\\n\\r\\t\\\\\\(\\))", null)
		assertEquals("\b\f\n\r\t\\()", value)
		val string = converter.toString(value)
		assertEquals("(\\b\\f\\n\\r\\t\\\\\\(\\))", string)
	}

	@Test
	def void testEscapeInvalid() {
		val value = converter.toValue("(\\k)", null)
		assertEquals("k", value)
	}

	@Test
	def void testEscapeNewline() {
		val value = converter.toValue("(line1\\\nline2)", null)
		assertEquals("line1line2", value)
	}

	@Test
	def void testEscapeReturn() {
		val value = converter.toValue("(line1\\\rline2)", null)
		assertEquals("line1line2", value)
	}

	@Test
	def void testEscapeReturnNewline() {
		val value = converter.toValue("(line1\\\r\nline2)", null)
		assertEquals("line1line2", value);
	}

	@Test
	def void testOctal_1() {
		val value = converter.toValue("(\\2)", null)
		assertEquals("\u0002", value)
		val string = converter.toString(value)
		assertEquals("(\\002)", string)
	}

	@Test
	def void testOctal_1A() {
		val value = converter.toValue("(\\2A)", null)
		assertEquals("\u0002A", value)
	}

	@Test
	def void testOctal_2() {
		val value = converter.toValue("(\\23)", null)
		assertEquals("\u0013", value)
		val string = converter.toString(value)
		assertEquals("(\\023)", string)
	}

	@Test
	def void testOctal_3() {
		val value = converter.toValue("(\\234)", null)
		assertEquals("\u009c", value)
		val string = converter.toString(value)
		assertEquals("(\\234)", string)
	}

	@Test
	def void testOctal_4() {
		val value = converter.toValue("(\\2345)", null)
		assertEquals("\u009c5", value)
	}

	@Test
	def void testOctal_Overflow() {
		val value = converter.toValue("(\\403)", null)
		assertEquals("\u0003", value)
	}
}
