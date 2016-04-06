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
