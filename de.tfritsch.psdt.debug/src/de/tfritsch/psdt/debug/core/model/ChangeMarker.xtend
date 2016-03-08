/*******************************************************************************
 * Copyright (c) 2016 Thomas Fritsch.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 ******************************************************************************/
package de.tfritsch.psdt.debug.core.model

import java.util.List
import org.eclipse.debug.core.model.IValue
import org.eclipse.debug.core.model.IVariable

/**
 * @author Thomas Fritsch - initial API and implementation
 */
class ChangeMarker {

	def boolean markChangesRelativeTo(IValue it, IValue previous) throws Exception {
		var changed = false
		if (valueString != previous?.valueString)
			changed = true
		if (variables.markChangesRelativeTo(previous?.variables))
			changed = true
		return changed
	}

	def boolean markChangesRelativeTo(List<IVariable> it, List<IVariable> previous) throws Exception{
		var changed = false
		if (map[name] != previous?.map[name])
			changed = true
		for (currentVar : it) {
			val previousVar = previous?.findFirst[name == currentVar.name]
			if (currentVar.markChangesRelativeTo(previousVar)) {
				changed = true
			}
		}
		return changed
	}

	def boolean markChangesRelativeTo(IVariable it, IVariable previous) throws Exception {
		var changed = false
		if (value.markChangesRelativeTo(previous?.value)) {
			(it as PSVariable).valueChanged = true
			changed = true
		}
		return changed
	}
}
