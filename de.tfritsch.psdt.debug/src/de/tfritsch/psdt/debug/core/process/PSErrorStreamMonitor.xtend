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

import com.google.common.collect.AbstractIterator
import de.tfritsch.psdt.debug.PSPlugin
import de.tfritsch.psdt.debug.core.model.IPSDebugStreamListener
import java.io.IOException
import java.io.InputStream

import static extension java.lang.Integer.parseInt

/**
 * @author Thomas Fritsch - initial API and implementation
 */
class PSErrorStreamMonitor extends PSOutputStreamMonitor {

	IPSDebugStreamListener listener

	new(InputStream stream, String encoding) {
		super(stream, encoding)
	}

	def synchronized void setDebugStreamListener(IPSDebugStreamListener listener) {
		this.listener = listener
		notifyAll
	}

	override appendLine(String line) {
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
