package de.tfritsch.psdt.debug.model;

import org.eclipse.debug.core.model.IIndexedValue;
import org.eclipse.debug.core.model.IVariable;

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
    PSIndexedValue(PSDebugTarget target, String valueString) {
        super(target, valueString);
    }

    //@Override
	public int getInitialOffset() {
        return 0;
    }

    @Override
	public int getSize() {
        return super.getSize();
    }

    //@Override
	public IVariable getVariable(int offset) {
        return getVariables()[offset];
    }

    //@Override
	public IVariable[] getVariables(int offset, int length) {
        IVariable[] vars = new IVariable[length];
        System.arraycopy(getVariables(), offset, vars, 0, length);
        return vars;
    }
}
