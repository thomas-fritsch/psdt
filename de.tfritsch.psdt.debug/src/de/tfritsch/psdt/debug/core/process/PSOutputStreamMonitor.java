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
package de.tfritsch.psdt.debug.core.process;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;

import org.eclipse.core.runtime.ISafeRunnable;
import org.eclipse.core.runtime.ListenerList;
import org.eclipse.core.runtime.SafeRunner;
import org.eclipse.debug.core.IStreamListener;
import org.eclipse.debug.core.model.IFlushableStreamMonitor;

import de.tfritsch.psdt.debug.PSPlugin;

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

	/**
	 * Whether content is being buffered
	 */
	private boolean fBuffered = true;

	/**
	 * The local copy of the stream contents
	 */
	private StringBuffer fContents;

	/**
	 * The thread which reads from the stream
	 */
	private Thread fThread;

	/**
	 * A collection of listeners
	 */
	private ListenerList fListeners = new ListenerList();

	private BufferedReader fReader;

	/**
	 * Creates an output stream monitor on the given stream (connected to system
	 * out or err).
	 * 
	 * @param stream
	 *            input stream to read from
	 * @param encoding
	 *            stream encoding or <code>null</code> for system default
	 */
	public PSOutputStreamMonitor(InputStream stream, String encoding) {
		if (encoding == null) {
			fReader = new BufferedReader(new InputStreamReader(stream));
		} else {
			try {
				fReader = new BufferedReader(new InputStreamReader(stream,
						encoding));
			} catch (UnsupportedEncodingException e) {
				PSPlugin.log(e);
				fReader = new BufferedReader(new InputStreamReader(stream));
			}
		}
		fContents = new StringBuffer();
	}

	protected void startMonitoring() {
		if (fThread == null) {
			fThread = new Thread(new Runnable() {
				@Override
				public void run() {
					read();
				}
			}, "Output Stream Monitor");
			fThread.setDaemon(true);
			fThread.setPriority(Thread.MIN_PRIORITY);
			fThread.start();
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
	private void read() {
		try {
			String line = readLine();
			while (line != null) {
				appendLine(line);
				line = readLine();
			}
		} catch (IOException e) {
			PSPlugin.log(e);
		}
		try {
			fReader.close();
		} catch (IOException e) {
			PSPlugin.log(e);
		}
	}

	/**
	 * Read next line from the stream.
	 * 
	 * @return one line of text (without trailing line terminator), or null in
	 *         case of EOF
	 */
	protected final String readLine() throws IOException {
		return fReader.readLine();
	}

	/**
	 * @param line
	 *            one line of text (without trailing line terminator)
	 */
	protected void appendLine(String line) {
		String text = line + '\n';
		if (isBuffered())
			fContents.append(text);
		getNotifier().notifyAppend(text);
	}

	@Override
	public synchronized void addListener(IStreamListener listener) {
		fListeners.add(listener);
	}

	@Override
	public void removeListener(IStreamListener listener) {
		fListeners.remove(listener);
	}

	@Override
	public String getContents() {
		return fContents.toString();
	}

	private ContentNotifier getNotifier() {
		return new ContentNotifier();
	}

	class ContentNotifier implements ISafeRunnable {

		private IStreamListener fListener;
		private String fText;

		@Override
		public void handleException(Throwable exception) {
			PSPlugin.log(exception);
		}

		@Override
		public void run() throws Exception {
			fListener.streamAppended(fText, PSOutputStreamMonitor.this);
		}

		public void notifyAppend(String text) {
			if (text == null)
				return;
			fText = text;
			Object[] copiedListeners = fListeners.getListeners();
			for (int i = 0; i < copiedListeners.length; i++) {
				fListener = (IStreamListener) copiedListeners[i];
				SafeRunner.run(this);
			}
			fListener = null;
			fText = null;
		}
	}

	@Override
	public void flushContents() {
		fContents.setLength(0);
	}

	@Override
	public void setBuffered(boolean buffered) {
		fBuffered = buffered;
	}

	@Override
	public boolean isBuffered() {
		return fBuffered;
	}
}
