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
import de.tfritsch.psdt.conversion.INTValueConverter
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
class INTValueConverterTest {

	@Inject
	INTValueConverter converter

	@Test(expected=ValueConverterException)
	def void testEmpty() {
		converter.toValue("", null)
	}

	@Test
	def void testSimple() {
		val value = converter.toValue("42", null)
		assertEquals(42, value)
		val string = converter.toString(value)
		assertEquals("42", string)
	}

	@Test
	def void testMinus() {
		val value = converter.toValue("-42", null)
		assertEquals(-42, value)
		val string = converter.toString(value)
		assertEquals("-42", string)
	}

	@Test
	def void testPlus() {
		val value = converter.toValue("+42", null)
		assertEquals(42, value)
	}

	@Test
	def void testRadix16() {
		val value = converter.toValue("16#ff", null)
		assertEquals(255, value)
	}

	@Test
	def void testRadix2() {
		val value = converter.toValue("2#10011", null)
		assertEquals(19, value)
	}
}
