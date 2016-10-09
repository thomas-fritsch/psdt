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
import org.eclipse.debug.core.model.IWatchExpressionResult
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.FinalFieldsConstructor

/**
 * @author Thomas Fritsch - initial API and implementation
 */
@FinalFieldsConstructor
@Accessors
class PSWatchExpressionResult implements IWatchExpressionResult {
	val String expressionText
	val IValue value
	val DebugException exception

	override hasErrors() {
		exception !== null
	}

	override getErrorMessages() {
		if(exception !== null) #[exception.message] else #[]
	}
}
