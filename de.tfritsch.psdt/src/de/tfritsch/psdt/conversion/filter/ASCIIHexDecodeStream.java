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

/**
 * @author Thomas Fritsch
 */
public class ASCIIHexDecodeStream extends AbstractDecodeStream {

    public ASCIIHexDecodeStream(InputStream in) {
        super(in);
        outBuf = new byte[1];
    }

    @Override
    protected void fillBuff() throws IOException {
        outPos = outCount = 0;
        for (int i = 0; i < 2 && !eod; i++) {
            int c = readNonWhiteSpace();
            if (c < 0)
                throw new IOException("EOF before '>'");
            else if (c == '>')
                eod = true;
            else {
                int x = Character.digit((char) c, 16);
                if (x < 0)
                    throw new IOException("Illegal character " + c);
                // x is in range 0 .. 15
                if ((i & 1) == 0) // i even
                    outBuf[outCount++] = (byte) (x * 16);
                else
                    // i odd
                    outBuf[outCount - 1] += (byte) x;
            }
        }
    }

}
