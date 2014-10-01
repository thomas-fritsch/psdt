package de.tfritsch.psdt.conversion;

import org.eclipse.xtext.conversion.IValueConverter;
import org.eclipse.xtext.conversion.ValueConverterException;
import org.eclipse.xtext.nodemodel.INode;

public class INTValueConverter implements IValueConverter<Integer> {

	public Integer toValue(String string, INode node)
			throws ValueConverterException {
		try {
			if (string.contains("#")) {
				int hashPos = string.indexOf('#');
				int radix = Integer.parseInt(string.substring(0, hashPos));
				String s = string.substring(hashPos + 1);
				return Integer.parseInt(s, radix);
			} else
				return Integer.parseInt(string, 10);
		} catch (NumberFormatException e) {
			throw new ValueConverterException("parse error", node, e);
		}
	}

	public String toString(Integer value) throws ValueConverterException {
		return value.toString();
	}

}