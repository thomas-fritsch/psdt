package de.tfritsch.psdt.debug.ui.console

import java.util.regex.Pattern
import org.eclipse.debug.ui.console.IConsole
import org.eclipse.debug.ui.console.IConsoleLineTracker
import org.eclipse.jface.text.IRegion
import org.eclipse.swt.widgets.Display
import org.eclipse.swt.widgets.MessageBox
import org.eclipse.ui.PlatformUI

import static extension de.tfritsch.psdt.help.PSHelpExtensions.*
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

	Pattern errorPattern = "Error: (/\\w+) in .+".compile
	Pattern pressReturnPattern = ">>.+, press <return> to continue<<".compile

	override lineAppended(IRegion line) {
		val text = console.document.get(line.offset, line.length)
		var matcher = errorPattern.matcher(text)
		if (matcher.matches) {
			val offset = line.offset + matcher.start(1)
			val length = matcher.end(1) - matcher.start(1)
			val url = matcher.group(1).substring(1).documentations.head?.url
			if (url !== null)
				console.addLink(new Hyperlink(url), offset, length)
		}
		matcher = pressReturnPattern.matcher(text)
		if (matcher.matches) {
			Display.^default.syncExec [
				val shell = PlatformUI.workbench.activeWorkbenchWindow.shell
				val box = new MessageBox(shell)
				box.message = text
				box.open
			]
			console.process.streamsProxy.write("\n")
		}
	}

	override dispose() {
		console = null
	}
}
