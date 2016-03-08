/*******************************************************************************
 * Copyright (c) 2016 Thomas Fritsch.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 ******************************************************************************/
package de.tfritsch.psdt.tests

import java.util.Random
import org.eclipse.xtext.conversion.IValueConverter
import org.junit.Test

import static org.junit.Assert.*

/**
 * @author Thomas Fritsch - initial API and implementation
 */
abstract class AbstractStringValueConverterTest {

	protected IValueConverter<byte[]> converter

	val random = new Random

	def protected randomValue() {
		val bytes = newByteArrayOfSize(random.nextInt(10))
		random.nextBytes(bytes)
		return bytes
	}

	@Test
	def void testRoundTrip() {
		for (var i = 0; i < 1000; i++) {
			val value = randomValue
			val string = converter.toString(value)
			val value2 = converter.toValue(string, null)
			assertArrayEquals(value, value2)
		}
	}
}
