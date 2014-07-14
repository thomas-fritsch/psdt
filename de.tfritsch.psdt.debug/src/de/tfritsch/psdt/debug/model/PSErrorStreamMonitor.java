package de.tfritsch.psdt.debug.model;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import org.eclipse.debug.core.DebugPlugin;

import de.tfritsch.psdt.debug.model.IPSDebugStreamListener.StatusLine;

class PSErrorStreamMonitor extends PSOutputStreamMonitor  {

	private IPSDebugStreamListener fListener;

	public PSErrorStreamMonitor(InputStream stream, String encoding) {
		super(stream, encoding);
	}

	synchronized void setListener(IPSDebugStreamListener listener) {
		fListener = listener;
	}

	@Override
	protected synchronized void appendLine(String line) {
		if (fListener != null && line.startsWith("@@")) //$NON-NLS-1$
			processDebugLine(line);
		else
			super.appendLine(line);
	}

	protected void processDebugLine(String line) {
		if (line.startsWith("@@break")) { //$NON-NLS-1$
			StringTokenizer tok = new StringTokenizer(line);
			tok.nextToken(); // "@@break"
			int depth = Integer.parseInt(tok.nextToken());
			if (tok.hasMoreTokens()) {
				int ref = Integer.parseInt(tok.nextToken());
				String value = tok.nextToken();
				fListener.breakReceived(depth, ref, value);
			} else {
				fListener.breakReceived(depth);
			}
		} else if (line.startsWith("@@resume")) { //$NON-NLS-1$
			fListener.resumeReceived();
		} else if (line.startsWith("@@status +")) { //$NON-NLS-1$
			List<StatusLine> lines = new ArrayList<StatusLine>();
			try {
				line = readLine();
				while (line != null && line.startsWith("+")) { //$NON-NLS-1$
					lines.add(new StatusLine(line));
					line = readLine();
				}
			} catch (IOException e) {
				DebugPlugin.log(e);
			}
			fListener.statusReceived(lines);
		}
	}

}
