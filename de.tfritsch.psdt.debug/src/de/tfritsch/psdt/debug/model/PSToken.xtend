package de.tfritsch.psdt.debug.model

import org.eclipse.osgi.util.NLS

class PSToken {

	new(String string, int lineNumber, int charStart, int charEnd) {
		this.string = string
		this.lineNumber = lineNumber
		this.charStart = charStart
		this.charEnd = charEnd
	}

	val String string

	def getString() {
		return string
	}

	val int lineNumber

	/**
	 * The line number of this token in the associated source file.
	 */
	def int getLineNumber() {
		return lineNumber
	}

	val int charStart

	/**
	 * The index of the first character in the associated source file.
	 */
	def int getCharStart() {
		return charStart
	}

	val int charEnd

	/**
	 * The index of the last character in the associated source file.
	 */
	def int getCharEnd() {
		return charEnd
	}

	override String toString() {
		val Object[] inserts = #[string, lineNumber, charStart, charEnd]
		return NLS.bind("{0} [line {1}, char {2}..{3}]", inserts)
	}
}
