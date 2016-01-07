package de.tfritsch.psdt.debug.model

import org.eclipse.debug.core.DebugException
import org.eclipse.debug.core.model.IValue
import org.eclipse.debug.core.model.IVariable

/**
 * A variable in a PostScript stack frame
 */
class PSVariable extends PSDebugElement implements IVariable, Comparable<PSVariable> {

	String name

	PSValue value

	/**
	 * @param target
	 *            debug target containing this variable
	 * @param name
	 *            the name of this variable
	 * @param value
	 *            the value of this variable
	 */
	new(PSDebugTarget target, String name, PSValue value) {
		super(target)
		this.name = name
		this.value = value
	}

	override int compareTo(PSVariable o) {
		return name.compareToIgnoreCase(o.name)
	}

	override IValue getValue() {
		return value
	}

	override String getName() {
		return name
	}

	// convenience for Java debugging
	override String toString() {
		return name + "=" + value
	}

	override String getReferenceTypeName() throws DebugException {
		return value.referenceTypeName
	}

	override boolean hasValueChanged() {
		return false
	}

	override void setValue(String expression) throws DebugException {
		notSupported("setValue", null) //$NON-NLS-1$
	}

	override void setValue(IValue value) throws DebugException {
		notSupported("setValue", null) //$NON-NLS-1$
	}

	override boolean supportsValueModification() {
		return false
	}

	override boolean verifyValue(String expression) throws DebugException {
		notSupported("verifyValue", null) //$NON-NLS-1$
		return false
	}

	override boolean verifyValue(IValue value) throws DebugException {
		notSupported("verifyValue", null) //$NON-NLS-1$
		return false
	}
}
