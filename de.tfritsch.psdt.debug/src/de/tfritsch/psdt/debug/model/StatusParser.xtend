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

	def protected StatusLine parseStatusLine(String line) {
		var depth = 0
		val char plus = '+'
		while (line.charAt(depth) == plus)
			depth++
		val pColon = line.indexOf(':')
		val name = line.substring(depth + 1, pColon)
		val value = line.substring(pColon + 2)
		return new StatusLine(depth, name, value)
	}

	@Data
	protected static class StatusLine {
		int depth
		String name
		String value
	}

	def protected List<PSValue> append(List<PSValue> treePath, StatusLine statusLine) {
		val value = new PSIndexedValue(debugTarget, statusLine.value)
		val variable = new PSVariable(debugTarget, statusLine.name, value)
		treePath.shrinkToSize(statusLine.depth)
		treePath.last.addVariable(variable)
		treePath.add(value)
		return treePath
	}

	def protected void shrinkToSize(List<?> list, int newSize) {
		while (list.size > newSize)
			list.remove(list.size - 1)
	}
}
