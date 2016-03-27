/*******************************************************************************
 * Copyright (c) 2016 Thomas Fritsch.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 ******************************************************************************/
package de.tfritsch.psdt.debug.ui.console

import com.google.inject.Inject
import de.tfritsch.psdt.debug.PSPlugin
import java.net.URL
import org.eclipse.ui.PartInitException
import org.eclipse.ui.browser.IWorkbenchBrowserSupport
import org.eclipse.ui.console.IHyperlink
import org.eclipse.xtend.lib.annotations.Accessors

/**
 * @author Thomas Fritsch - initial API and implementation
 */
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
			PSPlugin.log(e)
		}
	}

}
