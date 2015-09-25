package de.tfritsch.psdt.debug.model;

import java.util.SortedSet;
import java.util.TreeSet;

import org.eclipse.debug.core.model.IValue;
import org.eclipse.debug.core.model.IVariable;

/**
 * Value of a PostScript variable.
 */
class PSValue extends PSDebugElement implements IValue {

	private String fValueString;

	private SortedSet<IVariable> fVariables;

	/**
	 * @param target
	 *            debug target containing this value
	 * @param valueString
	 *            the string representation of this value
	 */
	PSValue(PSDebugTarget target, String valueString) {
		super(target);
		fValueString = valueString;
	}

	@Override
	public String getReferenceTypeName() {
		return ""; //$NON-NLS-1$
	}

	@Override
	public String getValueString() {
		return fValueString;
	}

	// convenience for Java debugging
	@Override
	public String toString() {
		return getValueString();
	}

	@Override
	public IVariable[] getVariables() {
		if (fVariables == null)
			return new IVariable[0];
		IVariable[] vars = new IVariable[fVariables.size()];
		fVariables.toArray(vars);
		return vars;
	}

	@Override
	public boolean hasVariables() {
		return fVariables != null && fVariables.size() > 0;
	}

	@Override
	public boolean isAllocated() {
		return true;
	}

	int getSize() {
		if (fVariables == null)
			return 0;
		return fVariables.size();
	}

	void addVariable(IVariable var) {
		if (fVariables == null)
			fVariables = new TreeSet<IVariable>();
		fVariables.add(var);
	}
}
