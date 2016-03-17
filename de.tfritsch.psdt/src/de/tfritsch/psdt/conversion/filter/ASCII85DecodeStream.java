/*******************************************************************************
 * Copyright (c) 2016 Thomas Fritsch.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 ******************************************************************************/
package de.tfritsch.psdt.conversion.filter;

import java.io.IOException;
import java.io.InputStream;
import java.util.Arrays;

/**
 * @author Thomas Fritsch
 */
public class ASCII85DecodeStream extends AbstractDecodeStream {

    /**
     * Input chars (range 0 .. 84)
     */
    private byte[] inBuf = new byte[5];

    /**
     * Number of bytes in inBuf[]
     */
    private int inCount;

    public ASCII85DecodeStream(InputStream in) {
        super(in);
        outBuf = new byte[4];
    }

    @Override
    protected void fillBuff() throws IOException {
        outPos = outCount = 0;
        Arrays.fill(inBuf, (byte) 84);
        inCount = 0;
        while (inCount < 5 && !eod) {
            int c = readNonWhiteSpace();
            if (c >= '!' && c <= 'u')
                inBuf[inCount++] = (byte) (c - '!');
            else if (c == 'z') {
                if (inCount != 0)
                    throw new IOException("'z' in the middle of a 5-tuple");
                inCount = 5;
                Arrays.fill(inBuf, (byte) 0);
            } else if (c == '~') {
                c = in.read();
                if (c != '>')
                    throw new IOException("Wrong character " + c + " after '~'");
                eod = true;
            } else if (c == -1)
                throw new IOException("EOF before '~>'");
            else
                throw new IOException("Illegal character " + c);
        }
        long value = 0;
        for (int i = 0; i < 5; i++) {
            value = value * 85 + inBuf[i];
        }
        switch (inCount) {
        case 0:
            outCount = 0;
            break;
        case 1:
            throw new IOException("Final 5-tuple with only one character");
        default:
            outCount = inCount - 1;
            outBuf[0] = (byte) (value >> 24);
            outBuf[1] = (byte) (value >> 16);
            outBuf[2] = (byte) (value >> 8);
            outBuf[3] = (byte) value;
            if (value >> 32 != 0)
                throw new IOException("5-tupel represents a value > 0xFFFFFFFF");
            break;
        }
    }
}
