package de.tfritsch.psdt.conversion;

import org.eclipse.xtext.conversion.IValueConverter;
import org.eclipse.xtext.conversion.ValueConverterException;
import org.eclipse.xtext.nodemodel.INode;

public class FLOATValueConverter implements IValueConverter<Float> {

	public Float toValue(String string, INode node)
			throws ValueConverterException {
		try {
			return Float.parseFloat(string);
		} catch (NumberFormatException e) {
			throw new ValueConverterException("parse error", node, e);
		}
	}

	public String toString(Float value) throws ValueConverterException {
		return value.toString();
	}

}
