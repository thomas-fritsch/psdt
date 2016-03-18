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
 * An abstract decoding input stream.
 * @author Thomas Fritsch
 */
public abstract class AbstractDecodeStream extends InputStream {

    /**
     * The source stream
     */
    protected InputStream in;

    /**
     * The bytes to be returned by {@link #read}. The bytes at position 0 to
     * outPos (exclusive) are already consumed. The bytes at position outPos to
     * outCount (exclusive) are not yet consumed.
     */
    protected byte outBuf[];

    /**
     * Next position in outBuf[]. This field is incremented by {@link #read} and
     * reset by {@link #fillBuff}.
     */
    protected int outPos;

    /**
     * Number of bytes in outBuf[]
     */
    protected int outCount;

    /**
     * End-of-Data flag
     */
    protected boolean eod;

    protected AbstractDecodeStream(InputStream in) {
        this.in = in;
    }

    /**
     * We need to override because {@link InputStream#read(byte[],int,int)}
     * would ignore any IOException after the first read().
     */
    @Override
    public int read(byte[] b, int off, int len) throws IOException {
        int i;
        for (i = 0; i < len; i++) {
            int c = read();
            if (c == -1) {
                if (i == 0)
                    return -1;
                break;
            }
            b[i] = (byte) c;
        }
        return i;
    }

    /**
     * Reads a byte through the filter. The value byte is returned as an
     * <code>int</code> in the range <code>0</code> to <code>255</code>. The
     * default implementation calls {@link #fillBuff} when needed and returns
     * the next byte from the buffer.
     * @return the next byte of data , or <code>-1</code> if EOD is reached.
     * @throws IOException
     *             if an I/O error occurs.
     */
    @Override
    public int read() throws IOException {
        int c = -1;
        // If buffer is empty and EOD is not reached, refill the buffer
        if (outPos >= outCount && !eod)
            fillBuff();
        // If buffer is not empty, get the next byte from it
        if (outPos < outCount)
            c = outBuf[outPos++] & 0xFF;
        // If buffer is empty now and EOD is not reached, try to refill it
        // again. We might get EOD now and must consume it, because our caller
        // might not call read() again.
        if (outPos >= outCount && !eod)
            fillBuff();
        return c;
    }

    /**
     * Attempts to read some input, converts it, and puts the result into output
     * buffer. The following contract is to be met:
     * <UL>
     * <LI>Reset {@link #outPos} to 0
     * <LI>Put converted bytes into {@link #outBuf}[...]
     * <LI>Set {@link #outCount} to the number of bytes in {@link #outBuf}
     * <LI>Set the {@link #eod} flag, if logical EOD is reached
     * </UL>
     */
    protected abstract void fillBuff() throws IOException;

    @Override
    public void close() throws IOException {
        eod = true;
        in.close();
    }

    /**
     * Reads the next byte from the source stream, while skipping white space.
     * @return a byte in the range 0..255 (except whitespace), or -1 for EOF
     */
    protected int readNonWhiteSpace() throws IOException {
        int c;
        do
            c = in.read();
        while (isWhiteSpace(c));
        return c;
    }

    protected boolean isWhiteSpace(int c) {
        return " \t\r\n\f\0".indexOf(c) >= 0;
    }

}
