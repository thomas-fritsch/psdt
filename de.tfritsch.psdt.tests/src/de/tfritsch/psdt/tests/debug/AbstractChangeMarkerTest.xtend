package de.tfritsch.psdt.tests.debug

import org.eclipse.debug.core.model.IVariable
import org.eclipse.xtend.lib.annotations.Accessors
import de.tfritsch.psdt.debug.core.model.ChangeMarker
import static org.junit.Assert.*

abstract class AbstractChangeMarkerTest extends AbstractStatusParserTest {

	@Accessors
	static protected class TestData {
		CharSequence current
		CharSequence previous
		CharSequence expected
	}

	extension ChangeMarker = new ChangeMarker

	def protected void assertVariablesChanged((TestData)=>void initializer) throws Exception {
		val it = new TestData
		initializer.apply(it)
		val currentVariables = current.toVariables
		val previousVariables = previous.toVariables
		currentVariables.markChangesRelativeTo(previousVariables)
		assertEquals(expected.toString, currentVariables.toString)
	}

	override protected toLine(IVariable it, int depth) throws Exception {
		return if (hasValueChanged)
			super.toLine(it, depth).replaceFirstChar('*')
		else
			super.toLine(it, depth)
	}

	def private String replaceFirstChar(String s, char c) {
		return c + s.substring(1)
	}

}
