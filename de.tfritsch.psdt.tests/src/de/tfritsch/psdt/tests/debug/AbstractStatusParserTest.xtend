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

/**
 * @author Thomas Fritsch - initial API and implementation
 */
abstract class AbstractStatusParserTest {

	val static LINE_SEP = System.getProperty("line.separator")

	extension StatusParser = new StatusParser(new PSDebugElementFactory)

	def protected void assertStatusParsed(CharSequence input, CharSequence expectedOutput) throws Exception {
		val variables = input.toVariables
		val output = variables.toString
		assertEquals(expectedOutput.toString, output)
	}

	def protected IVariable[] toVariables(CharSequence input) {
		val lines = new Scanner(input.toString).useDelimiter(LINE_SEP).toList
		lines.toVariables		
	}

	def protected String toString(IVariable[] variables) throws Exception {
		val appendable = new StringBuilder
		for (variable : variables) {
			appendable.append(variable, 1)
		}
		appendable.toString
	}

	def private void append(Appendable it, IVariable variable, int depth) throws Exception {
		append(variable.toLine(depth))
		for (subVariable : variable.value.variables) {
			append(subVariable, depth + 1) // recursion!
		}
	}

	def protected String toLine(IVariable it, int depth) throws Exception {
		'''
			«FOR i : 1 .. depth»+«ENDFOR» «name»: «value.valueString»
		'''
	}

	static private class PSDebugElementFactory implements IPSDebugElementFactory {

		PSDebugTarget debugTarget

		override createVariable(String name, PSValue value) {
			new PSVariable(debugTarget, name, value)
		}

		override createIndexedValue(String valueString) {
			new PSIndexedValue(debugTarget, valueString)
		}

		override createValue(String valueString) {
			new PSValue(debugTarget, valueString)
		}
	}

}
