package de.tfritsch.psdt.ui.hyperlinking

import java.net.URL
import org.eclipse.ui.PartInitException
import org.eclipse.ui.PlatformUI
import org.eclipse.ui.browser.IWorkbenchBrowserSupport
import org.eclipse.xtext.ui.editor.hyperlinking.AbstractHyperlink

class DocHyperlink extends AbstractHyperlink {

	extension IWorkbenchBrowserSupport = PlatformUI.workbench.browserSupport

	URL url

	def getUrl() {
		return url
	}

	def void setUrl(URL url) {
		this.url = url
	}

	override open() {
		try {
			"doc".createBrowser.openURL(url)
		} catch (PartInitException e) {
			e.printStackTrace
		}
	}

}
