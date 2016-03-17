/*******************************************************************************
 * Copyright (c) 2016 Thomas Fritsch.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 ******************************************************************************/
package de.tfritsch.psdt.conversion.filter

import java.io.InputStream
import java.io.OutputStream

/**
 * @author Thomas Fritsch - initial API and implementation
 */
class ASCIIHexFilter extends AbstractFilter {

	override protected toFiltered(InputStream in) {
		return new ASCIIHexDecodeStream(in)
	}

	override protected toFiltered(OutputStream out) {
		return new ASCIIHexEncodeStream(out)
	}
}
