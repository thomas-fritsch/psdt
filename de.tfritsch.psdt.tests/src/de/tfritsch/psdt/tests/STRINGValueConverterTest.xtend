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
import de.tfritsch.psdt.conversion.STRINGValueConverter
import org.eclipse.xtext.conversion.ValueConverterException
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.junit.Test
import org.junit.runner.RunWith

import static org.junit.Assert.assertArrayEquals
import static org.junit.Assert.assertEquals

/**
 * @author Thomas Fritsch - initial API and implementation
 */
@RunWith(XtextRunner)
@InjectWith(PostscriptInjectorProvider)
class STRINGValueConverterTest extends AbstractStringValueConverterTest {

	static val ISO_LATIN_1 = "ISO-8859-1"

	@Inject
	def void setConverter(STRINGValueConverter converter) {
		this.converter = converter
	}

	@Test(expected=ValueConverterException)
	def void testBrokenStringLiteral() {
		converter.toValue("(", null)
	}

	@Test
	def void testEmpty() {
		val value = converter.toValue("()", null)
		assertArrayEquals(newByteArrayOfSize(0), value)
		val string = converter.toString(value)
		assertEquals("()", string)
	}

	@Test
	def void testSimple() {
		val value = converter.toValue("(Hello world)", null)
		assertArrayEquals("Hello world".getBytes(ISO_LATIN_1), value)
		val string = converter.toString(value)
		assertEquals("(Hello world)", string)
	}

	@Test
	def void testBackSpace() {
		val value = converter.toValue("(\\b)", null)
		assertArrayEquals("\b".getBytes(ISO_LATIN_1), value)
		val string = converter.toString(value)
		assertEquals("(\\b)", string)
	}

	@Test
	def void testFormFeed() {
		val value = converter.toValue("(\\f)", null)
		assertArrayEquals("\f".getBytes(ISO_LATIN_1), value)
		val string = converter.toString(value)
		assertEquals("(\\f)", string)
	}

	@Test
	def void testLineFeed() {
		val value = converter.toValue("(\\n)", null)
		assertArrayEquals("\n".getBytes(ISO_LATIN_1), value)
		val string = converter.toString(value)
		assertEquals("(\\n)", string)
	}

	@Test
	def void testReturn() {
		val value = converter.toValue("(\\r)", null)
		assertArrayEquals("\r".getBytes(ISO_LATIN_1), value)
		val string = converter.toString(value)
		assertEquals("(\\r)", string)
	}

	@Test
	def void testTab() {
		val value = converter.toValue("(\\t)", null)
		assertArrayEquals("\t".getBytes(ISO_LATIN_1), value)
		val string = converter.toString(value)
		assertEquals("(\\t)", string)
	}

	@Test
	def void testBackSlash() {
		val value = converter.toValue("(\\\\)", null)
		assertArrayEquals("\\".getBytes(ISO_LATIN_1), value)
		val string = converter.toString(value)
		assertEquals("(\\\\)", string)
	}

	@Test
	def void testOpenParen() {
		val value = converter.toValue("(\\()", null)
		assertArrayEquals("(".getBytes(ISO_LATIN_1), value)
		val string = converter.toString(value)
		assertEquals("(\\()", string)
	}

	@Test
	def void testCloseParen() {
		val value = converter.toValue("(\\))", null)
		assertArrayEquals(")".getBytes(ISO_LATIN_1), value)
		val string = converter.toString(value)
		assertEquals("(\\))", string)
	}

	@Test
	def void testEscapeInvalid() {
		val value = converter.toValue("(\\k)", null)
		assertArrayEquals("k".getBytes(ISO_LATIN_1), value)
	}

	@Test
	def void testEscapeNewline() {
		val value = converter.toValue("(line1\\\nline2)", null)
		assertArrayEquals("line1line2".getBytes(ISO_LATIN_1), value)
	}

	@Test
	def void testEscapeReturn() {
		val value = converter.toValue("(line1\\\rline2)", null)
		assertArrayEquals("line1line2".getBytes(ISO_LATIN_1), value)
	}

	@Test
	def void testEscapeReturnNewline() {
		val value = converter.toValue("(line1\\\r\nline2)", null)
		assertArrayEquals("line1line2".getBytes(ISO_LATIN_1), value)
	}

	@Test
	def void testOctal_1() {
		val value = converter.toValue("(\\2)", null)
		assertArrayEquals(#[2 as byte], value)
		val string = converter.toString(value)
		assertEquals("(\\002)", string)
	}

	@Test
	def void testOctal_1A() {
		val value = converter.toValue("(\\2A)", null)
		assertArrayEquals(#[2 as byte, 0x41 as byte], value)
	}

	@Test
	def void testOctal_2() {
		val value = converter.toValue("(\\23)", null)
		assertArrayEquals(#[023 as byte], value)
		val string = converter.toString(value)
		assertEquals("(\\023)", string)
	}

	@Test
	def void testOctal_3() {
		val value = converter.toValue("(\\234)", null)
		assertArrayEquals(#[0234 as byte], value)
		val string = converter.toString(value)
		assertEquals("(\\234)", string)
	}

	@Test
	def void testOctal_4() {
		val value = converter.toValue("(\\2345)", null)
		assertArrayEquals(#[0x9c as byte, 0x35 as byte], value)
	}

	@Test
	def void testOctal_Overflow() {
		val value = converter.toValue("(\\403)", null)
		assertArrayEquals(#[3 as byte], value)
	}
}
