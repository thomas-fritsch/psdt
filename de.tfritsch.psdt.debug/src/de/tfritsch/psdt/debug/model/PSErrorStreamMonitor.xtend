package de.tfritsch.psdt.debug.model

import com.google.common.collect.AbstractIterator
import de.tfritsch.psdt.debug.PSPlugin
import java.io.IOException
import java.io.InputStream
import java.util.StringTokenizer

import static extension java.lang.Integer.parseInt

class PSErrorStreamMonitor extends PSOutputStreamMonitor {

	IPSDebugStreamListener listener

	new(InputStream stream, String encoding) {
		super(stream, encoding)
	}

	def synchronized void setListener(IPSDebugStreamListener listener) {
		this.listener = listener
		notifyAll
	}

	override synchronized void appendLine(String line) {
		if (line.startsWith("@@")) //$NON-NLS-1$
			processDebugLine(line)
		else
			super.appendLine(line)
	}

	def protected void processDebugLine(String line) {
		while (listener == null) {
			try {
				wait
			} catch (InterruptedException e) {
				// ignore
			}
		}
		if (line.startsWith("@@break")) { //$NON-NLS-1$
			val tok = new StringTokenizer(line)
			tok.nextToken // "@@break"
			val depth = tok.nextToken.parseInt
			if (tok.hasMoreTokens()) {
				val ref = tok.nextToken.parseInt
				val value = tok.nextToken()
				listener.breakReceived(depth, ref, value)
			} else {
				listener.breakReceived(depth)
			}
		} else if (line.startsWith("@@resume")) { //$NON-NLS-1$
			listener.resumeReceived()
		} else if (line == "@@status +") { //$NON-NLS-1$
			try {
				val AbstractIterator<String> iterator = [readLine ?: self.endOfData]
				val lines = iterator.takeWhile[it != "@@status -"].toList //$NON-NLS-1$
				listener.statusReceived(lines)
			} catch (IOException e) {
				PSPlugin.log(e)
			}
		}
	}

}
