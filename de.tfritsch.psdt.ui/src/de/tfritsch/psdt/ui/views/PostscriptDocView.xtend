package de.tfritsch.psdt.ui.views

import org.eclipse.swt.SWT
import org.eclipse.swt.browser.Browser
import org.eclipse.swt.widgets.Composite
import org.eclipse.ui.part.ViewPart
import org.eclipse.xtext.ui.editor.hover.html.XtextBrowserInformationControlInput

/**
 * View for displaying Postscript doc.
 * 
 * Matches plugin.xml extension[@point="org.eclipse.debug.ui.views"]/view/@class
 */
class PostscriptDocView extends ViewPart {

	/**
	 * Unique identifier for the PostscriptDoc view (value <code>{@value}</code>).
	 * Matches plugin.xml extension[@point="org.eclipse.ui.views"]/view/@id
	 */
	public static val ID = "de.tfritsch.psdt.ui.docView"

	Browser fBrowser

	override void createPartControl(Composite parent) {
		fBrowser = new Browser(parent, SWT.NONE)
	}

	override void setFocus() {
		fBrowser.setFocus()
	}

	def void setInput(XtextBrowserInformationControlInput input) {
		fBrowser.text = input.html
	}
}