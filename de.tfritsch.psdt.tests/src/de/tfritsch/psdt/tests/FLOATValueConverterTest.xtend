package de.tfritsch.psdt.tests

import com.google.inject.Inject
import de.tfritsch.psdt.PostscriptInjectorProvider
import de.tfritsch.psdt.conversion.FLOATValueConverter
import org.eclipse.xtext.conversion.ValueConverterException
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.junit.Test
import org.junit.runner.RunWith

import static org.junit.Assert.*

@RunWith(XtextRunner)
@InjectWith(PostscriptInjectorProvider)
class FLOATValueConverterTest {

	@Inject
	FLOATValueConverter converter

	@Test(expected=ValueConverterException)
	def void testEmpty() {
		converter.toValue("", null)
	}

	@Test
	def void testSimple() {
		val value = converter.toValue("42", null)
		assertEquals(42.0, value, 0.00001)
		val string = converter.toString(value)
		assertEquals("42.0", string)
	}

	@Test
	def void testExp() {
		val value = converter.toValue("6.023e23", null)
		assertEquals(6.023E23, value, 1E16)
		val string = converter.toString(value)
		assertEquals("6.023E23", string)
	}

	@Test
	def void testExpMinus() {
		val value = converter.toValue("8.854e-12", null)
		assertEquals(8.854E-12, value, 1E-20)
		val string = converter.toString(value)
		assertEquals("8.854E-12", string)
	}

}
