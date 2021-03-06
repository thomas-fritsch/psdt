/*******************************************************************************
 * Copyright (C) 2016  Thomas Fritsch.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 ******************************************************************************/
package de.tfritsch.psdt.debug.core.model

import java.util.Comparator
import java.util.SortedSet
import org.eclipse.debug.core.model.IValue
import org.eclipse.debug.core.model.IVariable

/**
 * Value of a PostScript variable.
 * 
 * @author Thomas Fritsch - initial API and implementation
 */
class PSValue extends PSDebugElement implements IValue {

	static val Comparator<IVariable> VARIABLE_COMPARATOR
	    = Comparator.comparing[name.toLowerCase]

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

	override getReferenceTypeName() {
		"object" //$NON-NLS-1$
	}

	override getValueString() {
		valueString
	}

	// convenience for Java debugging
	override toString() {
		valueString
	}

	override getVariables() {
		variables?:emptySet
	}

	override hasVariables() {
		size > 0
	}

	override isAllocated() {
		true
	}

	def protected int getSize() {
		(variables?:emptySet).size
	}

	def void addVariable(IVariable variable) {
		if (variables === null)
			variables = newTreeSet(VARIABLE_COMPARATOR)
		variables += variable
	}
}
