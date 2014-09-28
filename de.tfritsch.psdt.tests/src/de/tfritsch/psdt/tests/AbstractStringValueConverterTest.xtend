package de.tfritsch.psdt.tests

import java.util.Random
import org.eclipse.xtext.conversion.IValueConverter
import org.junit.Test

import static org.junit.Assert.*

abstract class AbstractStringValueConverterTest {

	protected IValueConverter<String> converter

	val random = new Random

	def protected randomValue() {
		val bytes = newByteArrayOfSize(random.nextInt(10))
		random.nextBytes(bytes)
		return new String(bytes, "ISO-8859-1")
	}

	@Test
	def void testRoundTrip() {
		for (var i = 0; i < 1000; i++) {
			val value = randomValue
			val string = converter.toString(value)
			val value2 = converter.toValue(string, null)
			assertEquals(value, value2)
		}
	}
}
