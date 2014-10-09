package de.tfritsch.psdt.conversion

import org.eclipse.xtext.conversion.IValueConverter
import org.eclipse.xtext.conversion.ValueConverterException
import org.eclipse.xtext.nodemodel.INode

import static extension java.lang.Integer.*

class INTValueConverter implements IValueConverter<Integer> {

	override Integer toValue(String string, INode node) throws ValueConverterException {
		try {
			if (string.contains("#")) {
				val hashPos = string.indexOf('#')
				val radix = string.substring(0, hashPos).parseInt
				return string.substring(hashPos + 1).parseInt(radix)
			} else
				return string.parseInt(10)
		} catch (NumberFormatException e) {
			throw new ValueConverterException("parse error", node, e)
		}
	}

	override String toString(Integer value) throws ValueConverterException {
		return value.toString
	}

}