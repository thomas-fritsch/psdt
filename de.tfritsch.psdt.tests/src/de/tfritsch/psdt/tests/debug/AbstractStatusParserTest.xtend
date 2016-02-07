package de.tfritsch.psdt.tests.debug

import de.tfritsch.psdt.debug.core.model.IPSDebugElementFactory
import de.tfritsch.psdt.debug.core.model.PSDebugTarget
import de.tfritsch.psdt.debug.core.model.PSIndexedValue
import de.tfritsch.psdt.debug.core.model.PSValue
import de.tfritsch.psdt.debug.core.model.PSVariable
import de.tfritsch.psdt.debug.core.model.StatusParser
import java.util.Scanner
import org.eclipse.debug.core.model.IVariable

import static org.junit.Assert.*

abstract class AbstractStatusParserTest {

	val static LINE_SEP = System.getProperty("line.separator")

	extension StatusParser = new StatusParser(new PSDebugElementFactory)

	def protected void assertStatusParsed(CharSequence input, CharSequence expectedOutput) throws Exception {
		val lines = new Scanner(input.toString).useDelimiter(LINE_SEP).toList
		val variables = lines.toVariables
		val output = variables.toString
		assertEquals(expectedOutput.toString, output)
	}

	def private String toString(IVariable[] variables) throws Exception {
		val appendable = new StringBuilder
		for (variable : variables) {
			appendable.append(variable, 1)
		}
		return appendable.toString
	}

	def private void append(Appendable it, IVariable variable, int depth) throws Exception {
		append(variable.toLine(depth))
		for (subVariable : variable.value.variables) {
			append(subVariable, depth + 1) // recursion!
		}
	}

	def private String toLine(IVariable it, int depth) throws Exception {
		'''
			«FOR i : 1 .. depth»+«ENDFOR» «name»: «value.valueString»
		'''
	}

	static private class PSDebugElementFactory implements IPSDebugElementFactory {

		PSDebugTarget debugTarget

		override createVariable(String name, PSValue value) {
			return new PSVariable(debugTarget, name, value)
		}

		override createIndexedValue(String valueString) {
			return new PSIndexedValue(debugTarget, valueString)
		}

		override createValue(String valueString) {
			return new PSValue(debugTarget, valueString)
		}
	}

}
