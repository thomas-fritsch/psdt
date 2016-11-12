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
package de.tfritsch.psdt.ui.browser

import com.google.inject.Inject
import java.net.MalformedURLException
import java.net.URL
import org.eclipse.core.runtime.IStatus
import org.eclipse.core.runtime.Status
import org.eclipse.ui.PartInitException
import org.eclipse.ui.browser.IWorkbenchBrowserSupport
import org.eclipse.ui.plugin.AbstractUIPlugin

/**
 * @author Thomas Fritsch - initial API and implementation
 */
class BrowserOpener {

	@Inject IWorkbenchBrowserSupport browserSupport
	@Inject AbstractUIPlugin plugin

	int style = IWorkbenchBrowserSupport.NAVIGATION_BAR.bitwiseOr(IWorkbenchBrowserSupport.LOCATION_BAR)

	def void openDocumentation(URL url) {
		try {
			browserSupport.createBrowser(
				style,
				"doc", // browserId
				null, // name = HTMLtitle
				"Documentation" // tooltip
			).openURL(url)
		} catch (PartInitException e) {
			val status = new Status(IStatus.ERROR, plugin.bundle.symbolicName, "Error", e);
			plugin.log.log(status)
		}
	}

	def void openDocumentation(String url) {
		try {
			openDocumentation(new URL(url))
		} catch (MalformedURLException e) {
			val status = new Status(IStatus.ERROR, plugin.bundle.symbolicName, "Error", e);
			plugin.log.log(status)
		}

	}
}
