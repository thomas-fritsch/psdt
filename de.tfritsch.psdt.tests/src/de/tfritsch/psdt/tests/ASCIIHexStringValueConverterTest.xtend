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
import de.tfritsch.psdt.conversion.ASCIIHexStringValueConverter
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
class ASCIIHexStringValueConverterTest extends AbstractStringValueConverterTest {

	@Inject
	def void setConverter(ASCIIHexStringValueConverter converter) {
		this.converter = converter
	}

	@Test
	def void testBrokenStringLiteral() {
		try {
			converter.toValue("<aaaa", null)
			fail("exception expected")
		} catch (ValueConverterException e) {
			assertEquals("must end with '>'", e.message)
		}
	}

	@Test
	def void testIllegalChar() {
		try {
			converter.toValue("<abcg>", null)
			fail("exception expected")
		} catch (ValueConverterException e) {
			assertEquals(
				"Illegal character 'g' (valid are '0'..'9', 'A'..'F', 'a'..'f' and white space)",
				e.message
			)
		}
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
