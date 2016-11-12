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
package de.tfritsch.psdt.debug.ui.console

import com.google.inject.Inject
import de.tfritsch.psdt.ui.browser.BrowserOpener
import java.net.URL
import org.eclipse.ui.console.IHyperlink
import org.eclipse.xtend.lib.annotations.Accessors

/**
 * @author Thomas Fritsch - initial API and implementation
 */
class Hyperlink implements IHyperlink {

	@Inject BrowserOpener browserOpener

	@Accessors
	URL url

	override linkEntered() {
	}

	override linkExited() {
	}

	override linkActivated() {
		browserOpener.openDocumentation(url)
	}

}
