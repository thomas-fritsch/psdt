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
import de.tfritsch.psdt.conversion.ASCII85StringValueConverter
import org.eclipse.xtext.conversion.ValueConverterException
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.junit.Test
import org.junit.runner.RunWith

import static org.junit.Assert.*

/**
 * @author Thomas Fritsch - initial API and implementation
 */
@RunWith(XtextRunner)
@InjectWith(PostscriptInjectorProvider)
class ASCII85StringValueConverterTest extends AbstractStringValueConverterTest {

	@Inject
	def void setConverter(ASCII85StringValueConverter converter) {
		this.converter = converter
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
	def void test1Char_min() {
		val byte[] value = #[0 as byte]
		val string = converter.toString(value)
		assertEquals("<~!!~>", string)
		assertArrayEquals(value, converter.toValue(string, null))
	}

	@Test
	def void test1Char() {
		val value = converter.toValue("<~@/~>", null)
		assertArrayEquals(#[0x61 as byte], value)
		val string = converter.toString(value)
		assertEquals("<~@/~>", string)
	}

	@Test
	def void test1Char_max() {
		val byte[] value = #[0xFF as byte]
		val string = converter.toString(value)
		assertEquals("<~rr~>", string)
		assertArrayEquals(value, converter.toValue(string, null))
	}

	@Test
	def void test2Char_min() {
		val byte[] value = #[0 as byte, 0 as byte]
		val string = converter.toString(value)
		assertEquals("<~!!!~>", string)
		assertArrayEquals(value, converter.toValue(string, null))
	}

	@Test
	def void test2Char() {
		val value = converter.toValue("<~@:B~>", null)
		assertArrayEquals(#[0x61 as byte, 0x62 as byte], value)
		val string = converter.toString(value)
		assertEquals("<~@:B~>", string)
	}

	@Test
	def void test2Char_max() {
		val byte[] value = #[0xFF as byte, 0xFF as byte]
		val string = converter.toString(value)
		assertEquals("<~s8N~>", string)
		assertArrayEquals(value, converter.toValue(string, null))
	}

	@Test
	def void test3Char_min() {
		val byte[] value = #[0 as byte, 0 as byte, 0 as byte]
		val string = converter.toString(value)
		assertEquals("<~!!!!~>", string)
		assertArrayEquals(value, converter.toValue(string, null))
	}

	@Test
	def void test3Char() {
		val value = converter.toValue("<~@:E^~>", null)
		assertArrayEquals(#[0x61 as byte, 0x62 as byte, 0x63 as byte], value)
		val string = converter.toString(value)
		assertEquals("<~@:E^~>", string)
	}

	@Test
	def void test3Char_max() {
		val byte[] value = #[0xFF as byte, 0xFF as byte, 0xFF as byte]
		val string = converter.toString(value)
		assertEquals("<~s8W*~>", string)
		assertArrayEquals(value, converter.toValue(string, null))
	}

	@Test
	def void test4Char_min() {
		val byte[] value = #[0 as byte, 0 as byte, 0 as byte, 0 as byte]
		val string = converter.toString(value)
		assertEquals("<~z~>", string)
		assertArrayEquals(value, converter.toValue(string, null))
	}

	@Test
	def void test4Char() {
		val value = converter.toValue("<~@:E_W~>", null)
		assertArrayEquals(#[0x61 as byte, 0x62 as byte, 0x63 as byte, 0x64 as byte], value)
		val string = converter.toString(value)
		assertEquals("<~@:E_W~>", string)
	}

	@Test
	def void test4Char_max() {
		val byte[] value = #[0xFF as byte, 0xFF as byte, 0xFF as byte, 0xFF as byte]
		val string = converter.toString(value)
		assertEquals("<~s8W-!~>", string)
		assertArrayEquals(value, converter.toValue(string, null))
	}

	@Test
	def void testSpace() {
		val value = converter.toValue("<~ @ : B ~>", null)
		assertArrayEquals(#[0x61 as byte, 0x62 as byte], value)
	}

}
