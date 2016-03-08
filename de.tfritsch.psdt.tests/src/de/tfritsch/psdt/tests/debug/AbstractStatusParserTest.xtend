/*******************************************************************************
 * Copyright (c) 2016 Thomas Fritsch.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
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
		return lines.toVariables		
	}

	def protected String toString(IVariable[] variables) throws Exception {
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

	def protected String toLine(IVariable it, int depth) throws Exception {
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
