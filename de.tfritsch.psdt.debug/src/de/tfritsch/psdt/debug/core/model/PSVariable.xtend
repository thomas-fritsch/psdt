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

import org.eclipse.debug.core.DebugException
import org.eclipse.debug.core.model.IValue
import org.eclipse.debug.core.model.IVariable

/**
 * A variable in a PostScript stack frame
 * 
 * @author Thomas Fritsch - initial API and implementation
 */
class PSVariable extends PSDebugElement implements IVariable {

	String name

	PSValue value

	boolean valueChanged

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

	override getValue() {
		value
	}

	override getName() {
		name
	}

	// convenience for Java debugging
	override toString() {
		name + "=" + value
	}

	override getReferenceTypeName() throws DebugException {
		value.referenceTypeName
	}

	override hasValueChanged() {
		valueChanged
	}

	def void setValueChanged(boolean valueChanged) {
		this.valueChanged = valueChanged
	}

	override setValue(String expression) throws DebugException {
		notSupported("setValue", null) //$NON-NLS-1$
	}

	override setValue(IValue value) throws DebugException {
		notSupported("setValue", null) //$NON-NLS-1$
	}

	override supportsValueModification() {
		false
	}

	override verifyValue(String expression) throws DebugException {
		notSupported("verifyValue", null) //$NON-NLS-1$
		false
	}

	override verifyValue(IValue value) throws DebugException {
		notSupported("verifyValue", null) //$NON-NLS-1$
		false
	}
}
