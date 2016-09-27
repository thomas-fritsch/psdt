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

import java.util.List
import org.eclipse.debug.core.model.IVariable
import org.eclipse.xtend.lib.annotations.FinalFieldsConstructor
import org.eclipse.xtend.lib.annotations.ToString

/**
 * @author Thomas Fritsch - initial API and implementation
 */
@FinalFieldsConstructor
class StatusParser {

	final IPSDebugElementFactory factory

	def IVariable[] toVariables(Iterable<String> lines) {
		val root = factory.createValue("") //$NON-NLS-1$
		val List<PSValue> treePath = newArrayList(root)
		lines.map[parseStatusLine].fold(treePath)[it, statusLine|append(statusLine)]
		return root.variables
	}

	def protected StatusLine parseStatusLine(String it) {
		var depth = 0
		val char plus = '+'
		while (charAt(depth) == plus)
			depth++
		val pColon = indexOf(':')
		val name = substring(depth + 1, pColon)
		val value = substring(pColon + 2)
		return new StatusLine(depth, name, value)
	}

	@FinalFieldsConstructor
	@ToString
	protected static class StatusLine {
		final int depth
		final String name
		final String value
	}

	def protected List<PSValue> append(List<PSValue> it, StatusLine statusLine) {
		val value = factory.createIndexedValue(statusLine.value)
		val variable = factory.createVariable(statusLine.name, value)
		shrinkToSize(statusLine.depth)
		last.addVariable(variable)
		add(value)
		return it
	}

	def protected void shrinkToSize(List<?> it, int newSize) {
		while (size > newSize)
			remove(size - 1)
	}
}
