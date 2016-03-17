/*******************************************************************************
 * Copyright (c) 2016 Thomas Fritsch.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 ******************************************************************************/
package de.tfritsch.psdt.conversion.filter;

import java.io.FilterOutputStream;
import java.io.OutputStream;
import java.io.IOException;
import java.util.Arrays;

/**
 * @author Thomas Fritsch - initial API and implementation
 */
public class ASCII85EncodeStream extends FilterOutputStream {

    private static final byte[] NULL_5_TUPLE = {'!', '!', '!', '!', '!'};

    private byte[] inData = new byte[4];
    private int inCount = 0;
    private byte[] outData = new byte[5];

    public ASCII85EncodeStream(OutputStream out) {
        super(out);
    }

    @Override
    public void write(int b) throws IOException {
        inData[inCount++] = (byte) b;
        if (inCount == 4) {
            transformASCII85();
            if (Arrays.equals(outData, NULL_5_TUPLE))
                out.write('z');
            else
                out.write(outData);
            inCount = 0;
        }
    }

    @Override
    public void flush() throws IOException {
        if (inCount > 0) {
            for (int i = inCount; i < 4; i++)
                inData[i] = 0;
            transformASCII85();
            out.write(outData, 0, inCount + 1);
        }
        inCount = 0;
        super.flush();
    }

    @Override
    public void close() throws IOException {
        try {
            flush();
            super.close();
        } finally {
            inData = null;
            outData = null;
        }
    }

    private void transformASCII85() {
        long word = 0;
        for (int i = 0; i < 4; i++) {
            word = (word << 8) + (inData[i] & 0xFF);
        }
        for (int i = 4; i >= 0; i--) {
            long x = word % 85;
            outData[i] = (byte) ('!' + x);
            word /= 85;
        }
    }
}
