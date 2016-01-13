package de.tfritsch.psdt.debug.ui

import org.eclipse.debug.ui.console.IConsole
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
			// TODO add Hyperlink on errorName
		}
		matcher = "Current file position is (\\d+)".compile.matcher(text)
		if (matcher.matches) {
			// TODO add Hyperlink on filePosition
		}
	}

	override dispose() {
		console = null
	}

}
