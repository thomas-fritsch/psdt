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

import javax.swing.tree.TreePath
import org.eclipse.debug.core.model.IVariable
import org.eclipse.xtend.lib.annotations.FinalFieldsConstructor
import org.eclipse.xtend.lib.annotations.ToString

/**
 * @author Thomas Fritsch - initial API and implementation
 */
@FinalFieldsConstructor
class StatusParser {

	val IPSDebugElementFactory factory

	def IVariable[] toVariables(Iterable<String> lines) {
		val root = factory.createValue("<root>") //$NON-NLS-1$
		val treePath = new TreePath(root)
		lines.map[parseStatusLine].fold(treePath)[it, statusLine|append(statusLine)]
		root.variables
	}

	def protected StatusLine parseStatusLine(String it) {
		var depth = 0
		val char plus = '+'
		while (charAt(depth) == plus)
			depth++
		val pColon = indexOf(':')
		val name = substring(depth + 1, pColon)
		val value = substring(pColon + 2)
		new StatusLine(depth, name, value)
	}

	@FinalFieldsConstructor
	@ToString
	protected static class StatusLine {
		val int depth
		val String name
		val String value
	}

	def protected TreePath append(TreePath it, StatusLine statusLine) {
		val value = factory.createIndexedValue(statusLine.value)
		val variable = factory.createVariable(statusLine.name, value)
		val treePath = partialPathOfSize(statusLine.depth)
		(treePath.lastPathComponent as PSValue).addVariable(variable)
		treePath.pathByAddingChild(value)
	}

	def protected TreePath partialPathOfSize(TreePath it, int newSize) {
		var treePath = it
		while (treePath.pathCount > newSize)
			treePath = treePath.parentPath
		treePath
	}
}
