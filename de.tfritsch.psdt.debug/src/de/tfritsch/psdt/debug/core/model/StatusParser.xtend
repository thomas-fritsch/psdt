/*******************************************************************************
 * Copyright (c) 2016 Thomas Fritsch.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 ******************************************************************************/
package de.tfritsch.psdt.debug.core.model

import org.eclipse.debug.core.model.IVariable
import org.eclipse.xtend.lib.annotations.Data
import java.util.List

/**
 * @author Thomas Fritsch - initial API and implementation
 */
class StatusParser {

	IPSDebugElementFactory factory

	new(IPSDebugElementFactory factory) {
		this.factory = factory
	}

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

	@Data
	protected static class StatusLine {
		int depth
		String name
		String value
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
