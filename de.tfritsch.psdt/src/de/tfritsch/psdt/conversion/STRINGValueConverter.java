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
package de.tfritsch.psdt.conversion;

import java.io.ByteArrayOutputStream;

import org.eclipse.xtext.conversion.IValueConverter;
import org.eclipse.xtext.conversion.ValueConverterException;
import org.eclipse.xtext.nodemodel.INode;

/**
 * @author Thomas Fritsch - initial API and implementation
 */
public class STRINGValueConverter implements IValueConverter<byte[]> {

	@Override
	public byte[] toValue(String string, INode node)
			throws ValueConverterException {
		if (!string.startsWith("("))
			throw new ValueConverterException("must begin with '('", node, null);
		if (!string.endsWith(")"))
			throw new ValueConverterException("must end with ')'", node, null);
		ByteArrayOutputStream out = new ByteArrayOutputStream();
		for (int i = 1; i < string.length() - 1; i++) {
			char c = string.charAt(i);
			if (c == '\\') {
				c = string.charAt(++i);
				if (c == 'b')
					out.write('\b');
				else if (c == 'f')
					out.write('\f');
				else if (c == 'r')
					out.write('\r');
				else if (c == 'n')
					out.write('\n');
				else if (c == 't')
					out.write('\t');
				else if (c == '(' || c == ')' || c == '\\')
					out.write(c);
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
					out.write(value);
				} else {
					out.write(c); // invalid escape char: just ignore the '\'
				}
			} else {
				out.write(c);
			}
		}
		return out.toByteArray();
	}

	@Override
	public String toString(byte[] value) throws ValueConverterException {
		StringBuilder out = new StringBuilder();
		out.append('(');
		for (int i = 0; i < value.length; i++) {
			char c = (char) (value[i] & 0xff);
			if (c == '\b')
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