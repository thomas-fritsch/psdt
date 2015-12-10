package de.tfritsch.psdt.ui.hyperlinking

import com.google.inject.Inject
import java.net.URL
import org.eclipse.ui.PartInitException
import org.eclipse.ui.browser.IWorkbenchBrowserSupport
import org.eclipse.xtext.ui.editor.hyperlinking.AbstractHyperlink

class DocHyperlink extends AbstractHyperlink {

	@Inject
	IWorkbenchBrowserSupport browserSupport

	URL url

	def getUrl() {
		return url
	}

	def void setUrl(URL url) {
		this.url = url
	}

	override open() {
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
