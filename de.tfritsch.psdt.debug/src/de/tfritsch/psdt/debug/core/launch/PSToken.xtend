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
package de.tfritsch.psdt.debug.core.launch

import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.FinalFieldsConstructor
import org.eclipse.xtend.lib.annotations.ToString

/**
 * @author Thomas Fritsch - initial API and implementation
 */
@FinalFieldsConstructor
@Accessors
@ToString(singleLine = true)
class PSToken {

	val String string

	/**
	 * The line number of this token in the associated source file.
	 */
	val int lineNumber

	/**
	 * The index of the first character in the associated source file.
	 */
	val int charStart

	/**
	 * The index of the last character in the associated source file.
	 */
	val int charEnd
}
