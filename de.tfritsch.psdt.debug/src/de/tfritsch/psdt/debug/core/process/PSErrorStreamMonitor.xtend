package de.tfritsch.psdt.debug.core.process

import com.google.common.collect.AbstractIterator
import de.tfritsch.psdt.debug.PSPlugin
import de.tfritsch.psdt.debug.core.model.IPSDebugStreamListener
import java.io.IOException
import java.io.InputStream

import static extension java.lang.Integer.parseInt

class PSErrorStreamMonitor extends PSOutputStreamMonitor {

	IPSDebugStreamListener listener

	new(InputStream stream, String encoding) {
		super(stream, encoding)
	}

	def synchronized void setDebugStreamListener(IPSDebugStreamListener listener) {
		this.listener = listener
		notifyAll
	}

	override void appendLine(String line) {
		if (line.startsWith("@@")) //$NON-NLS-1$
			processDebugLine(line)
		else
			super.appendLine(line)
	}

	def synchronized protected void waitWhileNoDebugStreamListener() {
		while (listener == null) {
			try {
				wait
			} catch (InterruptedException e) {
				// ignore
			}
		}
	}

	def protected void processDebugLine(String line) {
		waitWhileNoDebugStreamListener
		val tokens = line.split(" ")
		switch (tokens.get(0)) {
			case "@@break": { //$NON-NLS-1$
				val depth = tokens.get(1).parseInt
				if (tokens.size > 2) {
					val ref = tokens.get(2).parseInt
					val value = tokens.get(3)
					listener.breakReceived(depth, ref, value)
				} else {
					listener.breakReceived(depth)
				}
			}
			case "@@resume": { //$NON-NLS-1$
				listener.resumeReceived
			}
			case "@@status": { //$NON-NLS-1$
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

}
