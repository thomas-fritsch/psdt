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
