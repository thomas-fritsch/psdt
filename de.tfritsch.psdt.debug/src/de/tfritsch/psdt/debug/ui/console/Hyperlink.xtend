package de.tfritsch.psdt.debug.ui.console

import java.net.URL
import org.eclipse.ui.PartInitException
import org.eclipse.ui.PlatformUI
import org.eclipse.ui.browser.IWorkbenchBrowserSupport
import org.eclipse.ui.console.IHyperlink

class Hyperlink implements IHyperlink {

	static IWorkbenchBrowserSupport browserSupport = PlatformUI.workbench.browserSupport

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
				null, // name = HTMLtitle
				null // tooltip = url
			).openURL(url)
		} catch (PartInitException e) {
			e.printStackTrace
		}
	}

}
