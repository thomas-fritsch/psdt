/*******************************************************************************
 * Copyright (c) 2016 Thomas Fritsch.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 ******************************************************************************/
package de.tfritsch.psdt.conversion;

import java.io.ByteArrayOutputStream;
import org.eclipse.xtext.conversion.IValueConverter;
import org.eclipse.xtext.conversion.ValueConverterException;
import org.eclipse.xtext.nodemodel.INode;

/**
 * @author Thomas Fritsch - initial API and implementation
 */
public class ASCIIHexStringValueConverter implements IValueConverter<byte[]> {

    private static char[] digits = {'0', '1', '2', '3', '4', '5', '6', '7',
            '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'};

    @Override
    public byte[] toValue(String string, INode node)
            throws ValueConverterException {
        if (!string.startsWith("<"))
            throw new ValueConverterException("must begin with '<'", node, null);
        if (!string.endsWith(">"))
            throw new ValueConverterException("must end with '>'", node, null);
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        boolean byteComplete = true;
        int b = 0;
        for (int i = 1; i < string.length() - 1; i++) {
            char c = string.charAt(i);
            if (!isWhiteSpace(c)) {
                int x = Character.digit(c, 16);
                if (x < 0)
                    throw new ValueConverterException(
                            "Illegal character '"
                                    + c
                                    + "' (valid are '0'..'9', 'A'..'F', 'a'..'f' and white space)",
                            node, null);
                if (byteComplete)
                    b = x * 16;
                else {
                    b += x;
                    out.write(b);
                }
                byteComplete = !byteComplete;
            }
        }
        if (!byteComplete)
            out.write(b);
        return out.toByteArray();
    }

    @Override
    public String toString(byte[] value) throws ValueConverterException {
        StringBuilder out = new StringBuilder();
        out.append('<');
        for (byte b : value) {
            int highNibble = (b >> 4) & 0x0F;
            int lowNibble = b & 0x0F;
            out.append(digits[highNibble]);
            out.append(digits[lowNibble]);
        }
        out.append('>');
        return out.toString();
    }

    protected boolean isWhiteSpace(int c) {
        return " \t\r\n\f\0".indexOf(c) >= 0;
    }

}
