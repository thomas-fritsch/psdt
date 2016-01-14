package de.tfritsch.psdt.debug.ui

import java.net.URL
import org.eclipse.debug.ui.console.IConsole
import org.eclipse.debug.ui.console.IConsoleHyperlink
import org.eclipse.debug.ui.console.IConsoleLineTracker
import org.eclipse.jface.text.IRegion
import org.eclipse.ui.PartInitException
import org.eclipse.ui.PlatformUI
import org.eclipse.ui.browser.IWorkbenchBrowserSupport

import static extension de.tfritsch.psdt.help.PSHelpExtensions.*
import static extension java.util.regex.Pattern.*

/**
 * Matches plugin.xml
 * extension[@point="org.eclipse.debug.ui.consoleLineTrackers"]/consoleLineTracker/@class
 */
class PSConsoleLineTracker implements IConsoleLineTracker {

	IConsole console

	static IWorkbenchBrowserSupport browserSupport = PlatformUI.workbench.browserSupport

	override init(IConsole console) {
		this.console = console
	}

	override lineAppended(IRegion line) {
		val text = console.document.get(line.offset, line.length)
		var matcher = "Error: (/\\w+) in .+".compile.matcher(text)
		if (matcher.matches) {
			val offset = line.offset + matcher.start(1)
			val length = matcher.end(1) - matcher.start(1)
			val url = matcher.group(1).substring(1).documentationURL
			console.addLink(new Hyperlink(url), offset, length)
		}
	}

	override dispose() {
		console = null
	}

	static class Hyperlink implements IConsoleHyperlink {

		URL url

		new(URL url) {
			this.url = url
		}

		override linkEntered() {
		}

		override linkExited() {
		}

		override linkActivated() {
			try {
				browserSupport.createBrowser(
					IWorkbenchBrowserSupport.NAVIGATION_BAR,
					"doc",
					null,
					null
				).openURL(url)
			} catch (PartInitException e) {
				e.printStackTrace
			}
		}

	}
}
