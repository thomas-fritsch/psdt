package de.tfritsch.psdt.debug.core.model

import org.eclipse.debug.core.model.IIndexedValue
import org.eclipse.debug.core.model.IVariable

/**
 * Indexed value of a PostScript variable.
 */
class PSIndexedValue extends PSValue implements IIndexedValue {

	/**
	 * @param target
	 *            debug target containing this value
	 * @param valueString
	 *            the string representation of this value
	 */
	new(PSDebugTarget target, String valueString) {
		super(target, valueString)
	}

	override int getInitialOffset() {
		return 0
	}

	override int getSize() {
		return super.size
	}

	override IVariable getVariable(int offset) {
		return variables.get(offset)
	}

	override IVariable[] getVariables(int offset, int length) {
		return variables.subList(offset, offset + length)
	}

}
