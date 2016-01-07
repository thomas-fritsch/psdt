package de.tfritsch.psdt.debug.model

import java.util.SortedSet
import java.util.TreeSet
import org.eclipse.debug.core.model.IValue
import org.eclipse.debug.core.model.IVariable

/**
 * Value of a PostScript variable.
 */
class PSValue extends PSDebugElement implements IValue {

	String valueString

	SortedSet<IVariable> variables

	/**
	 * @param target
	 *            debug target containing this value
	 * @param valueString
	 *            the string representation of this value
	 */
	new(PSDebugTarget target, String valueString) {
		super(target)
		this.valueString = valueString
	}

	override String getReferenceTypeName() {
		return "" //$NON-NLS-1$
	}

	override String getValueString() {
		return valueString
	}

	// convenience for Java debugging
	override String toString() {
		return valueString
	}

	override IVariable[] getVariables() {
		return if (variables !== null) variables else #[]
	}

	override boolean hasVariables() {
		return size > 0
	}

	override boolean isAllocated() {
		return true
	}

	def protected int getSize() {
		return variables?.size
	}

	def void addVariable(IVariable variable) {
		if (variables === null)
			variables = new TreeSet<IVariable>
		variables += variable
	}
}
