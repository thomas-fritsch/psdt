package de.tfritsch.psdt.debug.model

import org.eclipse.debug.core.model.IVariable
import org.eclipse.xtend.lib.annotations.Data
import java.util.List

class StatusParser {

	PSDebugTarget debugTarget

	new(PSDebugTarget debugTarget) {
		this.debugTarget = debugTarget
	}

	def IVariable[] toVariables(Iterable<String> lines) {
		val root = new PSValue(debugTarget, "") //$NON-NLS-1$
		val treePath = newArrayList(root)
		for (line : lines) {
			treePath.append(line.parseStatusLine)
		}
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
		val value = new PSIndexedValue(debugTarget, statusLine.value)
		val variable = new PSVariable(debugTarget, statusLine.name, value)
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
