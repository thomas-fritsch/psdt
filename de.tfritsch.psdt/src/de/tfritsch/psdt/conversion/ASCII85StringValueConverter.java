/*******************************************************************************
 * Copyright (c) 2016 Thomas Fritsch.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 ******************************************************************************/
package de.tfritsch.psdt.conversion;

import java.io.ByteArrayOutputStream;
import java.util.Arrays;

import org.eclipse.xtext.conversion.IValueConverter;
import org.eclipse.xtext.conversion.ValueConverterException;
import org.eclipse.xtext.nodemodel.INode;

/**
 * @author Thomas Fritsch - initial API and implementation
 */
public class ASCII85StringValueConverter implements IValueConverter<byte[]> {

    private static final char[] NULL_5_TUPLE = {'!', '!', '!', '!', '!'};

    @Override
    public byte[] toValue(String string, INode node)
            throws ValueConverterException {
        if (!string.startsWith("<~"))
            throw new ValueConverterException("must begin with '<~'", node,
                    null);
        if (!string.endsWith("~>"))
            throw new ValueConverterException("must end with '~>'", node, null);
        char[] in5Tupel = new char[5];
        byte[] out4Tupel = new byte[4];
        int n = 0;
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        for (int i = 2; i < string.length() - 2; i++) {
            char c = string.charAt(i);
            if (!isWhiteSpace(c)) {
                if (c >= '!' && c <= 'u') {
                    in5Tupel[n++] = c;
                } else if (c == 'z') {
                    if (n != 0)
                        throw new ValueConverterException(
                                "Misplaced character 'z'", node, null);
                    n = 5;
                    Arrays.fill(in5Tupel, '!');
                } else if (c == '~') {
                    throw new ValueConverterException(
                            "Misplaced character '~'", node, null);
                } else
                    throw new ValueConverterException("Illegal character '" + c
                            + "' (valid are '!'..'u', 'z' and white space)",
                            node, null);
                if (n == 5) {
                    decodeTupel(in5Tupel, 5, out4Tupel);
                    out.write(out4Tupel, 0, 4);
                    n = 0;
                }
            }
        }
        if (n > 0) {
            if (n == 1)
                throw new ValueConverterException("Final tuple '" + in5Tupel[0]
                        + "' too short", node, null);
            for (int i = n; i < 5; i++)
                in5Tupel[i] = 'u';
            decodeTupel(in5Tupel, n, out4Tupel);
            out.write(out4Tupel, 0, n - 1);
        }
        return out.toByteArray();
    }

    @Override
    public String toString(byte[] value) throws ValueConverterException {
        StringBuilder out = new StringBuilder();
        out.append("<~");
        byte[] in4Tupel = new byte[4];
        char[] out5Tupel = new char[5];
        int n = 0;
        for (byte b : value) {
            in4Tupel[n++] = b;
            if (n == 4) {
                encodeTupel(in4Tupel, out5Tupel);
                if (Arrays.equals(out5Tupel, NULL_5_TUPLE))
                    out.append('z');
                else
                    out.append(out5Tupel);
                n = 0;
            }
        }
        if (n > 0) {
            for (int i = n; i < 4; i++)
                in4Tupel[i] = 0;
            encodeTupel(in4Tupel, out5Tupel);
            out.append(out5Tupel, 0, n + 1);
        }
        out.append("~>");
        return out.toString();
    }

    protected boolean isWhiteSpace(int c) {
        return " \t\r\n\f\0".indexOf(c) >= 0;
    }

    private void decodeTupel(char[] in5Tupel, int inCount, byte[] out4Tupel) {
        long value = 0;
        for (int i = 0; i < 5; i++) {
            value = value * 85 + (in5Tupel[i] - '!');
        }
        if (inCount == 5 && (value >> 32) != 0)
            throw new ValueConverterException("'" + new String(in5Tupel)
                    + "' represents a value > 0xFFFFFFFF", null, null);
        out4Tupel[0] = (byte) (value >> 24);
        out4Tupel[1] = (byte) (value >> 16);
        out4Tupel[2] = (byte) (value >> 8);
        out4Tupel[3] = (byte) value;
    }

    private void encodeTupel(byte[] in4Tupel, char[] out5Tupel) {
        long word = 0;
        for (int i = 0; i < 4; i++) {
            word = (word << 8) + (in4Tupel[i] & 0xFF);
        }
        for (int i = 4; i >= 0; i--) {
            long x = word % 85;
            out5Tupel[i] = (char) ('!' + x);
            word /= 85;
        }
    }

}
