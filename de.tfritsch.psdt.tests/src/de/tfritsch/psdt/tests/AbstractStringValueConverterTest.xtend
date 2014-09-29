package de.tfritsch.psdt.tests

import java.util.Random
import org.eclipse.xtext.conversion.IValueConverter
import org.junit.Test

import static org.junit.Assert.*

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
