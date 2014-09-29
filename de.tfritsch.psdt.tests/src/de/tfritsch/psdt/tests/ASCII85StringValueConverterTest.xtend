package de.tfritsch.psdt.tests

import de.tfritsch.psdt.PostscriptInjectorProvider
import de.tfritsch.psdt.conversion.ASCII85StringValueConverter
import org.eclipse.xtext.conversion.ValueConverterException
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith

import static org.junit.Assert.*

@RunWith(XtextRunner)
@InjectWith(PostscriptInjectorProvider)
class ASCII85StringValueConverterTest extends AbstractStringValueConverterTest {

	@Before
	def void init() {
		converter = new ASCII85StringValueConverter
	}

	@Test(expected=ValueConverterException)
	def void testBrokenStringLiteral() {
		converter.toValue("<~", null)
	}

	@Test
	def void testEmpty() {
		val value = converter.toValue("<~~>", null)
		assertArrayEquals(newByteArrayOfSize(0), value)
		val string = converter.toString(value)
		assertEquals("<~~>", string)
	}

	@Test
	def void test1Char() {
		val value = converter.toValue("<~@/~>", null)
		assertArrayEquals(#[0x61 as byte], value)
		val string = converter.toString(value)
		assertEquals("<~@/~>", string)
	}

	@Test
	def void test2Char() {
		val value = converter.toValue("<~@:B~>", null)
		assertArrayEquals(#[0x61 as byte, 0x62 as byte], value)
		val string = converter.toString(value)
		assertEquals("<~@:B~>", string)
	}

	@Test
	def void test3Char() {
		val value = converter.toValue("<~@:E^~>", null)
		assertArrayEquals(#[0x61 as byte, 0x62 as byte, 0x63 as byte], value)
		val string = converter.toString(value)
		assertEquals("<~@:E^~>", string)
	}

	@Test
	def void test4Char() {
		val value = converter.toValue("<~@:E_W~>", null)
		assertArrayEquals(#[0x61 as byte, 0x62 as byte, 0x63 as byte, 0x64 as byte], value)
		val string = converter.toString(value)
		assertEquals("<~@:E_W~>", string)
	}

	@Test
	def void testSpace() {
		val value = converter.toValue("<~ @ : B ~>", null)
		assertArrayEquals(#[0x61 as byte, 0x62 as byte], value)
	}

}
