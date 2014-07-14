package de.tfritsch.psdt.debug.model;

import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.UnsupportedEncodingException;
import java.io.Writer;
import java.util.List;

import org.eclipse.core.runtime.IStatus;
import org.eclipse.core.runtime.Status;
import org.eclipse.debug.core.DebugException;
import org.eclipse.debug.core.DebugPlugin;
import org.eclipse.debug.core.model.IStreamMonitor;
import org.eclipse.debug.core.model.IStreamsProxy2;

class PSStreamsProxy implements IStreamsProxy2, IPSDebugCommander {
	/**
	 * The monitor for the output stream (connected to standard out of the
	 * process)
	 */
	private PSOutputStreamMonitor fOutputMonitor;
	/**
	 * The monitor for the error stream (connected to standard error of the
	 * process)
	 */
	private PSErrorStreamMonitor fErrorMonitor;
	/**
	 * The writer for the input stream (connected to standard in of the
	 * process)
	 */
	private Writer fInputWriter;

	public PSStreamsProxy(Process process, String encoding) {
		if (process == null) {
			return;
		}
		fOutputMonitor = new PSOutputStreamMonitor(process.getInputStream(),
				encoding);
		fErrorMonitor = new PSErrorStreamMonitor(process.getErrorStream(),
				encoding);
		fInputWriter = creatInputWriter(process, encoding);
		fOutputMonitor.startMonitoring();
		fErrorMonitor.startMonitoring();
	}

	protected Writer creatInputWriter(Process process, String encoding) {
		if (encoding == null)
			return new OutputStreamWriter(process.getOutputStream());
		else {
			try {
				return new OutputStreamWriter(process.getOutputStream(),
						encoding);
			} catch (UnsupportedEncodingException e) {
				DebugPlugin.log(e);
				return new OutputStreamWriter(process.getOutputStream());
			}
		}
	}

	//@Override
	public IStreamMonitor getErrorStreamMonitor() {
		return fErrorMonitor;
	}

	//@Override
	public IStreamMonitor getOutputStreamMonitor() {
		return fOutputMonitor;
	}

	//@Override
	public void write(String input) throws IOException {
		fInputWriter.write(input);
		fInputWriter.flush();
	}

	//@Override
	public void closeInputStream() throws IOException {
		fInputWriter.close();
	}

	//@Override
	public void setDebugStreamListener(IPSDebugStreamListener listener) {
		fErrorMonitor.setListener(listener);
	}

	//@Override
	public void sendCommand(String command) throws DebugException {
		try {
			write(command + "\n"); //$NON-NLS-1$
		} catch (IOException e) {
			throw new DebugException(new Status(IStatus.ERROR,
					DebugPlugin.getUniqueIdentifier(),
					DebugException.TARGET_REQUEST_FAILED,
					"debug communication error", e));
		}
	}

	//@Override
	public void setSingleStep(boolean singleStep) throws DebugException {
		sendCommand(singleStep + " @@singlestep"); //$NON-NLS-1$
	}

	//@Override
	public void resume() throws DebugException {
		sendCommand("@@resume"); //$NON-NLS-1$
	}

	//@Override
	public void addBreakpoint(int ref) throws DebugException {
		sendCommand("@@breakpoints " + ref + " null put"); //$NON-NLS-1$ //$NON-NLS-2$
	}

	//@Override
	public void removeBreakpoint(int ref) throws DebugException {
		sendCommand("@@breakpoints " + ref + " undef"); //$NON-NLS-1$ //$NON-NLS-2$
	}

	//@Override
	public void hideDicts(boolean hideSystemDict, boolean hideGlobalDict,
			boolean hideUserDict) throws DebugException {
		sendCommand(hideSystemDict + " " //$NON-NLS-1$
				+ hideGlobalDict + " " //$NON-NLS-1$
				+ hideUserDict + " @@stathide"); //$NON-NLS-1$
	}

	//@Override
	public void requestStatus() throws DebugException {
		sendCommand("@@status"); //$NON-NLS-1$
	}

	//@Override
	public void sendInstrumentedCode(List<PSToken> tokens)
			throws DebugException {
		sendCommand("{"); //$NON-NLS-1$
		for (int i = 0; i < tokens.size(); i++) {
			PSToken token = tokens.get(i);
			sendCommand(i + " @@$ " + token.getString()); //$NON-NLS-1$
		}
		sendCommand("quit"); //$NON-NLS-1$
		sendCommand("} exec"); //$NON-NLS-1$
	}

}
