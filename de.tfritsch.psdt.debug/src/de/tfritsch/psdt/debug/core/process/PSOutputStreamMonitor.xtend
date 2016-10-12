/*******************************************************************************
 * Copyright (C) 2016  Thomas Fritsch.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 ******************************************************************************/
package de.tfritsch.psdt.debug.core.process

import de.tfritsch.psdt.debug.PSPlugin
import java.io.BufferedReader
import java.io.IOException
import java.io.InputStream
import java.io.InputStreamReader
import java.io.UnsupportedEncodingException
import org.eclipse.core.runtime.ISafeRunnable
import org.eclipse.core.runtime.ListenerList
import org.eclipse.core.runtime.SafeRunner
import org.eclipse.debug.core.IStreamListener
import org.eclipse.debug.core.model.IFlushableStreamMonitor
import org.eclipse.xtend.lib.annotations.Accessors

/**
 * Monitors the output stream of a system process and notifies listeners of
 * additions to the stream.
 * 
 * The output stream monitor reads system out (or err) via an input stream.
 * 
 * @see "org.eclipse.debug.internal.core.OutputStreamMonitor"
 * @author Thomas Fritsch - initial API and implementation
 */
class PSOutputStreamMonitor implements IFlushableStreamMonitor {

	@Accessors boolean buffered = true
	StringBuffer contents
	Thread thread
	ListenerList listeners = new ListenerList
	BufferedReader reader

	/**
	 * Creates an output stream monitor on the given stream (connected to system
	 * out or err).
	 * 
	 * @param stream
	 *            input stream to read from
	 * @param encoding
	 *            stream encoding or <code>null</code> for system default
	 */
	new(InputStream stream, String encoding) {
		reader = if (encoding === null) {
			new BufferedReader(new InputStreamReader(stream))
		} else {
			try {
				new BufferedReader(new InputStreamReader(stream, encoding))
			} catch (UnsupportedEncodingException e) {
				PSPlugin.log(e)
				new BufferedReader(new InputStreamReader(stream))
			}
		}
		contents = new StringBuffer
	}

	protected def void startMonitoring() {
		if (thread == null) {
			thread = new Thread([read], "Output Stream Monitor") => [
				daemon = true
				priority = Thread.MIN_PRIORITY
			]
			thread.start
		}
	}

	/**
	 * Continually reads from the stream.
	 * <p>
	 * This method, along with the <code>startMonitoring</code> method is used
	 * to allow <code>OutputStreamMonitor</code> to implement
	 * <code>Runnable</code> without publicly exposing a <code>run</code>
	 * method.
	 */
	private def void read() {
		try {
			var String line = readLine
			while (line !== null) {
				appendLine(line)
				line = readLine
			}
		} catch (IOException e) {
			PSPlugin.log(e)
		}
		try {
			reader.close
		} catch (IOException e) {
			PSPlugin.log(e)
		}
	}

	/**
	 * Read next line from the stream.
	 * 
	 * @return one line of text (without trailing line terminator), or null in
	 *         case of EOF
	 */
	protected final def String readLine() throws IOException {
		reader.readLine
	}

	/**
	 * @param line
	 *            one line of text (without trailing line terminator)
	 */
	protected def void appendLine(String line) {
		val text = line + '\n'
		if (buffered)
			contents.append(text)
		for (l : listeners.listeners) {
			val SafeRunnable runnable = [
				(l as IStreamListener).streamAppended(text, this)
			]
			SafeRunner.run(runnable)
		}
	}

	static abstract class SafeRunnable implements ISafeRunnable {
		override handleException(Throwable e) {
			PSPlugin.log(e)
		}
	}

	override synchronized addListener(IStreamListener listener) {
		listeners.add(listener)
	}

	override removeListener(IStreamListener listener) {
		listeners.remove(listener)
	}

	override getContents() {
		contents.toString
	}

	override flushContents() {
		contents.length = 0
	}
}
