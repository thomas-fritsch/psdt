package de.tfritsch.psdt.tests

import de.tfritsch.psdt.PostscriptInjectorProvider
import de.tfritsch.psdt.conversion.ASCIIHexStringValueConverter
import org.eclipse.xtext.conversion.ValueConverterException
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith

import static org.junit.Assert.*

@RunWith(XtextRunner)
@InjectWith(PostscriptInjectorProvider)
class ASCIIHexStringValueConverterTest extends AbstractStringValueConverterTest {

	@Before
	def void init() {
		converter = new ASCIIHexStringValueConverter
	}

	@Test(expected=ValueConverterException)
	def void testBrokenStringLiteral() {
		converter.toValue("<", null)
	}

	@Test
	def void testEmpty() {
		val value = converter.toValue("<>", null)
		assertArrayEquals(newByteArrayOfSize(0), value)
		val string = converter.toString(value)
		assertEquals("<>", string)
	}

	@Test
	def void testSimple() {
		val value = converter.toValue("<48656C6C6F>", null)
		assertArrayEquals(#[0x48 as byte, 0x65 as byte, 0x6C as byte, 0x6C as byte, 0x6F as byte], value)
		val string = converter.toString(value)
		assertEquals("<48656C6C6F>", string)
	}

	@Test
	def void testLowerCase() {
		val value = converter.toValue("<48656c6c6f>", null)
		assertArrayEquals(#[0x48 as byte, 0x65 as byte, 0x6C as byte, 0x6C as byte, 0x6F as byte], value)
	}

	@Test
	def void testHalf() {
		val value = converter.toValue("<484>", null)
		assertArrayEquals(#[0x48 as byte, 0x40 as byte], value)
	}

	@Test
	def void testSpace() {
		val value = converter.toValue("< 41 42 >", null)
		assertArrayEquals(#[0x41 as byte, 0x42 as byte], value)
	}

}
