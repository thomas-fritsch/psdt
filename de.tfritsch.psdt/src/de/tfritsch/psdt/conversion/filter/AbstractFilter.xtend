/*******************************************************************************
 * Copyright (c) 2016 Thomas Fritsch.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 ******************************************************************************/
package de.tfritsch.psdt.conversion.filter

import com.google.common.io.ByteStreams
import java.io.ByteArrayInputStream
import java.io.ByteArrayOutputStream
import java.io.IOException
import java.io.InputStream
import java.io.OutputStream

/**
 * @author Thomas Fritsch - initial API and implementation
 */
abstract class AbstractFilter {

	def byte[] decode(byte[] bytes)  throws IOException {
		val in = new ByteArrayInputStream(bytes)
		val out = new ByteArrayOutputStream
		in.decodeTo(out)
		return out.toByteArray
	}

	def byte[] encode(byte[] bytes) throws IOException {
		val in = new ByteArrayInputStream(bytes)
		val out = new ByteArrayOutputStream
		in.encodeTo(out)
		return out.toByteArray
	}

	def decodeTo(InputStream in, OutputStream out) throws IOException {
		val intermediate = in.toFiltered
		ByteStreams.copy(intermediate, out)
		intermediate.close
		out.flush
	}

	def encodeTo(InputStream in, OutputStream out) throws IOException {
		val intermediate = out.toFiltered
		ByteStreams.copy(in, intermediate)
		intermediate.close
		out.flush
	}

	def protected InputStream toFiltered(InputStream in)

	def protected OutputStream toFiltered(OutputStream out)
}
