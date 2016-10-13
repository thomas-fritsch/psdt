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
import de.tfritsch.psdt.debug.core.model.IPSDebugCommander
import de.tfritsch.psdt.debug.core.model.IPSDebugStreamListener
import java.io.IOException
import java.io.OutputStreamWriter
import java.io.UnsupportedEncodingException
import java.io.Writer
import org.eclipse.core.runtime.IStatus
import org.eclipse.core.runtime.Status
import org.eclipse.debug.core.DebugException
import org.eclipse.debug.core.model.IStreamsProxy2

/**
 * A streams proxy between the streams of a Ghostscript process and interested clients.
 * 
 * @see PSProcessFactory#newProcess
 * @author Thomas Fritsch - initial API and implementation
 */
class PSStreamsProxy implements IStreamsProxy2, IPSDebugCommander {

	/**
	 * The monitor for the output stream (connected to standard out of the process)
	 */
	PSOutputStreamMonitor outputMonitor

	/**
	 * The monitor for the error stream (connected to standard error of the process)
	 */
	PSErrorStreamMonitor errorMonitor

	/**
	 * The writer for the input stream (connected to standard in of the process)
	 */
	Writer inputWriter

	new(Process process, String encoding) {
		if (process == null) {
			return
		}
		outputMonitor = new PSOutputStreamMonitor(process.inputStream, encoding)
		errorMonitor = new PSErrorStreamMonitor(process.errorStream, encoding)
		inputWriter = creatInputWriter(process, encoding)
		outputMonitor.startMonitoring
		errorMonitor.startMonitoring
	}

	def protected Writer creatInputWriter(Process process, String encoding) {
		if (encoding == null) {
			new OutputStreamWriter(process.outputStream)
		} else {
			try {
				new OutputStreamWriter(process.outputStream, encoding)
			} catch (UnsupportedEncodingException e) {
				PSPlugin.log(e)
				new OutputStreamWriter(process.outputStream)
			}
		}
	}

	override getErrorStreamMonitor() {
		errorMonitor
	}

	override getOutputStreamMonitor() {
		outputMonitor
	}

	override write(String input) throws IOException {
		inputWriter.write(input)
		inputWriter.flush
	}

	override closeInputStream() throws IOException {
		inputWriter.close
	}

	override setDebugStreamListener(IPSDebugStreamListener listener) {
		errorMonitor.debugStreamListener = listener
	}

	override sendCommand(String command) throws DebugException {
		try {
			write(command + "\n") //$NON-NLS-1$
		} catch (IOException e) {
			throw new DebugException(
				new Status(IStatus.ERROR, PSPlugin.ID, DebugException.TARGET_REQUEST_FAILED,
					"debug communication error", e))
		}
	}

	override setSingleStep(boolean singleStep) throws DebugException {
		sendCommand('''«singleStep» @@singlestep''')
	}

	override resume() throws DebugException {
		sendCommand("@@resume")
	}

	override addBreakpoint(int ref) throws DebugException {
		sendCommand('''@@breakpoints «ref» null put''')
	}

	override removeBreakpoint(int ref) throws DebugException {
		sendCommand('''@@breakpoints «ref» undef''')
	}

	override hideDicts(boolean hideSystemDict, boolean hideGlobalDict, boolean hideUserDict) throws DebugException {
		sendCommand('''«hideSystemDict» «hideGlobalDict» «hideUserDict» @@stathide''')
	}

	override requestStatus() throws DebugException {
		sendCommand("@@status")
	}

	override setWatches(Iterable<String> watches) throws DebugException {
		sendCommand(watches.join("[", " ", "] @@watches", ["/" + it]))
	}
}
