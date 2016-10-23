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
package de.tfritsch.psdt.conversion

import org.eclipse.xtext.conversion.IValueConverter
import org.eclipse.xtext.conversion.ValueConverterException
import org.eclipse.xtext.nodemodel.INode

import static extension java.lang.Integer.parseInt

/**
 * @author Thomas Fritsch - initial API and implementation
 */
class INTValueConverter implements IValueConverter<Integer> {

	override toValue(String string, INode node) throws ValueConverterException {
		try {
			if (string.contains("#")) {
				val hashPos = string.indexOf('#')
				val radix = string.substring(0, hashPos).parseInt
				string.substring(hashPos + 1).parseInt(radix)
			} else if (string.startsWith("+"))
				string.substring(1).parseInt(10)
			else
				string.parseInt(10)
		} catch (NumberFormatException e) {
			throw new ValueConverterException("parse error", node, e)
		}
	}

	override toString(Integer value) throws ValueConverterException {
		value.toString
	}

}