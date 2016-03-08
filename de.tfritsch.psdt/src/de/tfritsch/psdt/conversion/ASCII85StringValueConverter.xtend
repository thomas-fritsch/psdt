/*******************************************************************************
 * Copyright (c) 2016 Thomas Fritsch.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 ******************************************************************************/
package de.tfritsch.psdt.conversion

import com.google.inject.Inject
import java.io.ByteArrayInputStream
import java.io.ByteArrayOutputStream
import java.io.IOException
import org.apache.pdfbox.filter.ASCII85Filter
import org.eclipse.xtext.conversion.IValueConverter
import org.eclipse.xtext.conversion.ValueConverterException
import org.eclipse.xtext.nodemodel.INode

/**
 * @author Thomas Fritsch - initial API and implementation
 */
class ASCII85StringValueConverter implements IValueConverter<byte[]> {

	@Inject
	ASCII85Filter filter

	override byte[] toValue(String string, INode node) throws ValueConverterException {
		if (!string.startsWith("<~"))
			throw new ValueConverterException("must begin with '<~'", node, null)
		if (!string.endsWith("~>"))
			throw new ValueConverterException("must end with '~>'", node, null)
		try {
			val input = new ByteArrayInputStream(string.substring(2).getBytes("ISO-8859-1"))
			val output = new ByteArrayOutputStream
			filter.decode(input, output, null, 0)
			return output.toByteArray
		} catch (IOException e) {
			throw new ValueConverterException("decode error", node, e)
		}
	}

	override String toString(byte[] value) throws ValueConverterException {
		try {
			val input = new ByteArrayInputStream(value)
			val output = new ByteArrayOutputStream
			filter.encode(input, output, null, 0)
			return "<~" + output.toString("ISO-8859-1").replace("~\n", "") + "~>"
		} catch (IOException e) {
			throw new ValueConverterException("encode error", null, e)
		}
	}

}
