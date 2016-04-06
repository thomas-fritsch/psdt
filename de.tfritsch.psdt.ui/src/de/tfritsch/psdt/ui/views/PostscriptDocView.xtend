/*******************************************************************************
 * Copyright (C) 2016  Thomas Fritsch.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 ******************************************************************************/
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
 * 
 * @author Thomas Fritsch - initial API and implementation
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