package de.tfritsch.psdt.ui.hyperlinking

import com.google.inject.Inject
import java.net.URL
import org.eclipse.ui.PartInitException
import org.eclipse.ui.browser.IWorkbenchBrowserSupport
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtext.ui.editor.hyperlinking.AbstractHyperlink

class DocHyperlink extends AbstractHyperlink {

	@Inject
	IWorkbenchBrowserSupport browserSupport

	@Accessors
	URL url

	override open() {
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
