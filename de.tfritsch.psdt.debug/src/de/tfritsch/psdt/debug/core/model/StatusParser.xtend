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
package de.tfritsch.psdt.debug.core.model

import com.google.common.collect.PeekingIterator
import java.util.regex.Pattern
import org.eclipse.debug.core.model.IVariable
import org.eclipse.xtend.lib.annotations.FinalFieldsConstructor
import org.eclipse.xtend.lib.annotations.ToString

import static extension com.google.common.collect.Iterators.peekingIterator

/**
 * @author Thomas Fritsch - initial API and implementation
 */
@FinalFieldsConstructor
class StatusParser {

	val IPSDebugElementFactory factory

	def IVariable[] toVariables(Iterable<String> lines) {
		val root = factory.createValue("<root>") //$NON-NLS-1$
		lines.map[parseStatusLine] //
		.iterator.peekingIterator.addVariablesTo(root, 0)
		root.variables
	}

	val Pattern statusLinePattern = Pattern.compile("(\\+*) (.*): (.*)")

	def protected StatusLine parseStatusLine(String it) {
		val matcher = statusLinePattern.matcher(it)
		if (!matcher.matches)
			throw new IllegalArgumentException(it)
		var depth = matcher.group(1).length
		val name = matcher.group(2)
		val value = matcher.group(3)
		new StatusLine(depth, name, value)
	}

	@FinalFieldsConstructor
	@ToString
	protected static class StatusLine {
		val int depth
		val String name
		val String value
	}

	def protected void addVariablesTo(PeekingIterator<StatusLine> it, PSValue parentValue,  int parentDepth) {
		while (hasNext && peek.depth > parentDepth) {
			val statusLine = next
			if (statusLine.depth != parentDepth + 1)
				throw new IllegalStateException(statusLine.toString)
			val value = factory.createIndexedValue(statusLine.value)
			val variable = factory.createVariable(statusLine.name, value)
			parentValue.addVariable(variable)
			addVariablesTo(value, statusLine.depth) // recursion!
		}
	}
}
