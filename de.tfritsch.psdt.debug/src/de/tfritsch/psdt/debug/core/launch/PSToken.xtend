package de.tfritsch.psdt.debug.core.launch

import org.eclipse.osgi.util.NLS
import org.eclipse.xtend.lib.annotations.Data

@Data
class PSToken {

	String string

	/**
	 * The line number of this token in the associated source file.
	 */
	int lineNumber

	/**
	 * The index of the first character in the associated source file.
	 */
	int charStart

	/**
	 * The index of the last character in the associated source file.
	 */
	int charEnd

	override String toString() {
		val Object[] inserts = #[string, lineNumber, charStart, charEnd]
		return NLS.bind("{0} [line {1}, char {2}..{3}]", inserts)
	}
}
