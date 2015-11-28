package de.tfritsch.psdt.debug.model

import java.io.IOException
import java.io.OutputStreamWriter
import java.io.UnsupportedEncodingException
import java.io.Writer
import org.eclipse.core.runtime.IStatus
import org.eclipse.core.runtime.Status
import org.eclipse.debug.core.DebugException
import org.eclipse.debug.core.DebugPlugin
import org.eclipse.debug.core.model.IStreamMonitor
import org.eclipse.debug.core.model.IStreamsProxy2

class PSStreamsProxy implements IStreamsProxy2, IPSDebugCommander {

	/**
	 * The monitor for the output stream (connected to standard out of the process)
	 */
	PSOutputStreamMonitor fOutputMonitor

	/**
	 * The monitor for the error stream (connected to standard error of the process)
	 */
	PSErrorStreamMonitor fErrorMonitor

	/**
	 * The writer for the input stream (connected to standard in of the process)
	 */
	Writer fInputWriter

	new(Process process, String encoding) {
		if (process == null) {
			return
		}
		fOutputMonitor = new PSOutputStreamMonitor(process.inputStream, encoding)
		fErrorMonitor = new PSErrorStreamMonitor(process.errorStream, encoding)
		fInputWriter = creatInputWriter(process, encoding)
		fOutputMonitor.startMonitoring
		fErrorMonitor.startMonitoring
	}

	def protected Writer creatInputWriter(Process process, String encoding) {
		if (encoding == null) {
			return new OutputStreamWriter(process.outputStream)
		} else {
			try {
				return new OutputStreamWriter(process.outputStream, encoding)
			} catch (UnsupportedEncodingException e) {
				DebugPlugin.log(e)
				return new OutputStreamWriter(process.outputStream)
			}
		}
	}

	override IStreamMonitor getErrorStreamMonitor() {
		return fErrorMonitor
	}

	override IStreamMonitor getOutputStreamMonitor() {
		return fOutputMonitor
	}

	override void write(String input) throws IOException {
		fInputWriter.write(input)
		fInputWriter.flush
	}

	override void closeInputStream() throws IOException {
		fInputWriter.close
	}

	override void setDebugStreamListener(IPSDebugStreamListener listener) {
		fErrorMonitor.listener = listener
	}

	override void sendCommand(String command) throws DebugException {
		try {
			write(command + "\n") //$NON-NLS-1$
		} catch (IOException e) {
			throw new DebugException(
				new Status(IStatus.ERROR, DebugPlugin.uniqueIdentifier, DebugException.TARGET_REQUEST_FAILED,
					"debug communication error", e))
		}
	}

	override void setSingleStep(boolean singleStep) throws DebugException {
		sendCommand(singleStep + " @@singlestep") //$NON-NLS-1$
	}

	override void resume() throws DebugException {
		sendCommand("@@resume") //$NON-NLS-1$
	}

	override void addBreakpoint(int ref) throws DebugException {
		sendCommand("@@breakpoints " + ref + " null put") //$NON-NLS-1$ //$NON-NLS-2$
	}

	override void removeBreakpoint(int ref) throws DebugException {
		sendCommand("@@breakpoints " + ref + " undef") //$NON-NLS-1$ //$NON-NLS-2$
	}

	override void hideDicts(boolean hideSystemDict, boolean hideGlobalDict, boolean hideUserDict) throws DebugException {
		sendCommand(
			hideSystemDict + " " //$NON-NLS-1$
			+ hideGlobalDict + " " //$NON-NLS-1$
			+ hideUserDict + " @@stathide") //$NON-NLS-1$
	}

	override void requestStatus() throws DebugException {
		sendCommand("@@status") //$NON-NLS-1$
	}

}
