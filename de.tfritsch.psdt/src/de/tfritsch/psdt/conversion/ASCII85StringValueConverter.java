package de.tfritsch.psdt.conversion;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;

import org.apache.pdfbox.filter.ASCII85Filter;
import org.apache.pdfbox.filter.Filter;
import org.eclipse.xtext.conversion.IValueConverter;
import org.eclipse.xtext.conversion.ValueConverterException;
import org.eclipse.xtext.nodemodel.INode;

public class ASCII85StringValueConverter implements IValueConverter<String> {

	private Filter filter = new ASCII85Filter();

	public String toValue(String string, INode node)
			throws ValueConverterException {
		if (!string.startsWith("<~"))
			throw new ValueConverterException("must begin with '<~'", node,
					null);
		if (!string.endsWith("~>"))
			throw new ValueConverterException("must end with '~>'", node, null);
		try {
			InputStream input = new ByteArrayInputStream(string.substring(2)
					.getBytes("ISO-8859-1"));
			ByteArrayOutputStream output = new ByteArrayOutputStream();
			filter.decode(input, output, null, 0);
			return output.toString("ISO-8859-1");
		} catch (IOException e) {
			throw new ValueConverterException("decode error", node, e);
		}
	}

	public String toString(String value) throws ValueConverterException {
		try {
			InputStream input = new ByteArrayInputStream(
					value.getBytes("ISO-8859-1"));
			ByteArrayOutputStream output = new ByteArrayOutputStream();
			filter.encode(input, output, null, 0);
			return "<~" + output.toString("ISO-8859-1").replace("~\n", "") + "~>";
		} catch (IOException e) {
			throw new ValueConverterException("encode error", null, e);
		}
	}

}
