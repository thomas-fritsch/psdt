package de.tfritsch.psdt.conversion;

import org.eclipse.xtext.conversion.IValueConverter;
import org.eclipse.xtext.conversion.ValueConverterException;
import org.eclipse.xtext.nodemodel.INode;

public class STRINGValueConverter implements IValueConverter<String> {

	public String toValue(String string, INode node)
			throws ValueConverterException {
		if (!string.startsWith("("))
			throw new ValueConverterException("must begin with '('", node, null);
		if (!string.endsWith(")"))
			throw new ValueConverterException("must end with ')'", node, null);
		StringBuilder out = new StringBuilder();
		for (int i = 1; i < string.length() - 1; i++) {
			char c = string.charAt(i);
			if (c == '\\') {
				c = string.charAt(++i);
				if (c == 'b')
					out.append('\b');
				else if (c == 'f')
					out.append('\f');
				else if (c == 'r')
					out.append('\r');
				else if (c == 'n')
					out.append('\n');
				else if (c == 't')
					out.append('\t');
				else if (c == '(' || c == ')' || c == '\\')
					out.append(c);
				else if (c == '\n')
					; // ignore '\n'
				else if (c == '\r') {
					; // ignore '\r'
					if (string.charAt(i + 1) == '\n')
						i++; // ignore \r\n
				} else if (isOctal(c)) {
					int value = (c - '0');
					if (isOctal(string.charAt(i + 1))) {
						value = value * 8 + (string.charAt(++i) - '0');
						if (isOctal(string.charAt(i + 1))) {
							value = value * 8 + (string.charAt(++i) - '0');
						}
					}
					value &= 0xff; // high order overflow: ignore high bits
					out.append((char) value);
				} else {
					out.append(c); // invalid escape char: just ignore the '\'
				}
			} else {
				out.append(c);
			}
		}
		return out.toString();
	}

	public String toString(String value) throws ValueConverterException {
		StringBuilder out = new StringBuilder();
		out.append('(');
		for (int i = 0; i < value.length(); i++) {
			char c = value.charAt(i);
			if (c >= '\u0100')
				throw new ValueConverterException("illegal char", null, null);
			else if (c == '\b')
				out.append("\\b");
			else if (c == '\f')
				out.append("\\f");
			else if (c == '\n')
				out.append("\\n");
			else if (c == '\r')
				out.append("\\r");
			else if (c == '\t')
				out.append("\\t");
			else if (c == '(' || c == ')' || c == '\\') {
				out.append('\\');
				out.append(c);
			} else if (c >= '\u0020' && c <= '\u007e')
				out.append(c);
			else {
				out.append('\\');
				out.append(toOctal((c >> 6) & 3));
				out.append(toOctal((c >> 3) & 7));
				out.append(toOctal(c & 7));
			}
		}
		out.append(')');
		return out.toString();
	}

	protected char toOctal(int b) {
		return (char) ('0' + (b & 7));
	}

	protected boolean isOctal(char c) {
		return c >= '0' && c <= '7';
	}
}