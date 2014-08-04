package de.tfritsch.psdt.debug.model;

import org.eclipse.debug.core.DebugException;
import org.eclipse.debug.core.model.IValue;
import org.eclipse.debug.core.model.IVariable;

/**
 * A variable in a PostScript stack frame
 */
class PSVariable extends PSDebugElement implements IVariable, Comparable<PSVariable> {

	private String fName;

	private PSValue fValue;

	/**
	 * @param target
	 *            debug target containing this variable
	 * @param name
	 *            the name of this variable
	 * @param value
	 *            the value of this variable
	 */
	PSVariable(PSDebugTarget target, String name, PSValue value) {
		super(target);
		fName = name;
		fValue = value;
	}

	//@Override
	public int compareTo(PSVariable o) {
		return fName.compareToIgnoreCase(o.fName);
	}

	//@Override
	public IValue getValue() {
		return fValue;
	}

	//@Override
	public String getName() {
		return fName;
	}

	// convenience for Java debugging
	@Override
	public String toString() {
		return getName() + "=" + getValue();
	}

	//@Override
	public String getReferenceTypeName() throws DebugException {
		return getValue().getReferenceTypeName();
	}

	//@Override
	public boolean hasValueChanged() {
		return false;
	}

	//@Override
	public void setValue(String expression) throws DebugException {
		notSupported("setValue", null); //$NON-NLS-1$
	}

	//@Override
	public void setValue(IValue value) throws DebugException {
		notSupported("setValue", null); //$NON-NLS-1$
	}

	//@Override
	public boolean supportsValueModification() {
		return false;
	}

	//@Override
	public boolean verifyValue(String expression) throws DebugException {
		notSupported("verifyValue", null); //$NON-NLS-1$
		return false;
	}

	//@Override
	public boolean verifyValue(IValue value) throws DebugException {
		notSupported("verifyValue", null); //$NON-NLS-1$
		return false;
	}
}
