package de.tfritsch.psdt.debug.model;

import org.eclipse.osgi.util.NLS;

class PSToken {
	private String fString;
	private int fLineNumber;
	private int fCharStart;
	private int fCharEnd;

	PSToken(String string, int lineNumber, int charStart, int charEnd) {
		fString = string;
		fLineNumber = lineNumber;
		fCharStart = charStart;
		fCharEnd = charEnd;
	}

	String getString() {
		return fString;
	}

	/**
	 * Returns the line number of this token in the associated source file.
	 */
	int getLineNumber() {
		return fLineNumber;
	}

	/**
	 * Returns the index of the first character in the associated source
	 * file.
	 */
	int getCharStart() {
		return fCharStart;
	}

	/**
	 * Returns the index of the last character in the associated source
	 * file.
	 */
	int getCharEnd() {
		return fCharEnd;
	}
	
	@Override
	public String toString() {
		Object[] inserts = {
				fString,
				new Integer(fLineNumber),
				new Integer(fCharStart),
				new Integer(fCharEnd)
		};
		return NLS.bind("{0} [line {1}, char {2}..{3}]", inserts);
	}
}