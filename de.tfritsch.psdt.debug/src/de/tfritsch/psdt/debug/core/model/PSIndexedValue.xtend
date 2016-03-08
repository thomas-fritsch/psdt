/*******************************************************************************
 * Copyright (c) 2016 Thomas Fritsch.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
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
