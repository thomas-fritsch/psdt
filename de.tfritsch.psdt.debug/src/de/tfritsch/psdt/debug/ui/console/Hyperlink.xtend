package de.tfritsch.psdt.debug.ui.console

import com.google.inject.Inject
import java.net.URL
import org.eclipse.ui.PartInitException
import org.eclipse.ui.browser.IWorkbenchBrowserSupport
import org.eclipse.ui.console.IHyperlink
import org.eclipse.xtend.lib.annotations.Accessors

class Hyperlink implements IHyperlink {

	@Inject IWorkbenchBrowserSupport browserSupport

	@Accessors
	URL url

	override linkEntered() {
	}

	override linkExited() {
	}

	override linkActivated() {
		try {
			browserSupport.createBrowser(
				IWorkbenchBrowserSupport.NAVIGATION_BAR.bitwiseOr(IWorkbenchBrowserSupport.LOCATION_BAR),
				"doc", // id
				null, // name = HTMLtitle
				"Documentation" // tooltip
			).openURL(url)
		} catch (PartInitException e) {
			e.printStackTrace
		}
	}

}
