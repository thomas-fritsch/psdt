/*******************************************************************************
 * Copyright (c) 2016 Thomas Fritsch.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 ******************************************************************************/
package de.tfritsch.psdt.ui.hyperlinking

import com.google.inject.Inject
import java.net.URL
import org.eclipse.core.runtime.IStatus
import org.eclipse.core.runtime.Status
import org.eclipse.ui.PartInitException
import org.eclipse.ui.browser.IWorkbenchBrowserSupport
import org.eclipse.ui.plugin.AbstractUIPlugin
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtext.ui.editor.hyperlinking.AbstractHyperlink

/**
 * @author Thomas Fritsch - initial API and implementation
 */
class DocHyperlink extends AbstractHyperlink {

	@Inject
	IWorkbenchBrowserSupport browserSupport

	@Inject
	AbstractUIPlugin plugin

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
			val status = new Status(IStatus.ERROR, plugin.bundle.symbolicName, "Error", e);
			plugin.log.log(status)
		}
	}

}
