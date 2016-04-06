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

import org.eclipse.debug.core.model.IIndexedValue
import org.eclipse.debug.core.model.IVariable

/**
 * Indexed value of a PostScript variable.
 * 
 * @author Thomas Fritsch - initial API and implementation
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
