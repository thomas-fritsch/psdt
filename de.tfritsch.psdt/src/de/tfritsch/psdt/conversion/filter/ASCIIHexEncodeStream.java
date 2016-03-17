/*******************************************************************************
 * Copyright (c) 2016 Thomas Fritsch.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 ******************************************************************************/
package de.tfritsch.psdt.conversion.filter;

import java.io.FilterOutputStream;
import java.io.IOException;
import java.io.OutputStream;

/**
 * @author Thomas Fritsch - initial API and implementation
 */
public class ASCIIHexEncodeStream extends FilterOutputStream {

    private static char[] digits = {'0', '1', '2', '3', '4', '5', '6', '7',
            '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'};

    public ASCIIHexEncodeStream(OutputStream out) {
        super(out);
    }

    @Override
    public void write(int b) throws IOException {
        int highNibble = (b >> 4) & 0x0F;
        int lowNibble = b & 0x0F;
        out.write(digits[highNibble]);
        out.write(digits[lowNibble]);
    }
}
