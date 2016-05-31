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
 * 
 * @author Thomas Fritsch - initial API and implementation
 */
@RunWith(XtextRunner)
@InjectWith(PostscriptUiInjectorProvider)
class LabelProviderTest {

	@Inject extension ILabelProvider

	@Inject extension PostscriptFactory

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
	def void testString_invalid() {
		val obj = createPSString => [bytes = null]
		assertEquals("()", obj.text)
	}

	@Test
	def void testExecutableName() {
		val obj = createPSExecutableName => [name = "showpage"]
		assertEquals("showpage", obj.text)
	}

	@Test
	def void testLiteralName() {
		val obj = createPSLiteralName => [name = "showpage"]
		assertEquals("/showpage", obj.text)
	}

	@Test
	def void testImmediatelyEvaluatedName() {
		val obj = createPSImmediatelyEvaluatedName => [name = "showpage"]
		assertEquals("//showpage", obj.text)
	}

	@Test
	def void testUnparsedData() {
		val obj = createPSUnparsedData
		assertEquals("Data", obj.text)
	}
}
