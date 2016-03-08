/*******************************************************************************
 * Copyright (c) 2016 Thomas Fritsch.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 ******************************************************************************/
package de.tfritsch.psdt.conversion

import org.eclipse.xtext.conversion.IValueConverter
import org.eclipse.xtext.conversion.ValueConverterException
import org.eclipse.xtext.nodemodel.INode

import static extension java.lang.Integer.*

/**
 * @author Thomas Fritsch - initial API and implementation
 */
class INTValueConverter implements IValueConverter<Integer> {

	override Integer toValue(String string, INode node) throws ValueConverterException {
		try {
			if (string.contains("#")) {
				val hashPos = string.indexOf('#')
				val radix = string.substring(0, hashPos).parseInt
				return string.substring(hashPos + 1).parseInt(radix)
			} else if (string.startsWith("+"))
				return string.substring(1).parseInt(10)
			else
				return string.parseInt(10)
		} catch (NumberFormatException e) {
			throw new ValueConverterException("parse error", node, e)
		}
	}

	override String toString(Integer value) throws ValueConverterException {
		return value.toString
	}

}