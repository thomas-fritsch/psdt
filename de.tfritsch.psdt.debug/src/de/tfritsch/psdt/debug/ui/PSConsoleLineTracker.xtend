package de.tfritsch.psdt.debug.ui

import org.eclipse.debug.ui.console.IConsole
import org.eclipse.debug.ui.console.IConsoleHyperlink
import org.eclipse.debug.ui.console.IConsoleLineTracker
import org.eclipse.jface.text.IRegion

import static extension java.util.regex.Pattern.*

/**
 * Matches plugin.xml
 * extension[@point="org.eclipse.debug.ui.consoleLineTrackers"]/consoleLineTracker/@class
 */
class PSConsoleLineTracker implements IConsoleLineTracker {

	IConsole console

	override init(IConsole console) {
		this.console = console
	}

	override lineAppended(IRegion line) {
		val text = console.document.get(line.offset, line.length)
		var matcher = "Error: (/\\w+) in .+".compile.matcher(text)
		if (matcher.matches) {
			val offset = line.offset + matcher.start(1)
			val length = matcher.end(1) - matcher.start(1)
			console.addLink(new Hyperlink(), offset, length)
		}
		matcher = "Current file position is (\\d+)".compile.matcher(text)
		if (matcher.matches) {
			val offset = line.offset + matcher.start(1)
			val length = matcher.end(1) - matcher.start(1)
			console.addLink(new Hyperlink, offset, length)
		}
	}

	override dispose() {
		console = null
	}

	static class Hyperlink implements IConsoleHyperlink {

		override linkEntered() {
		}

		override linkExited() {
		}

		override linkActivated() {
			// TODO open link
		}

	}
}
