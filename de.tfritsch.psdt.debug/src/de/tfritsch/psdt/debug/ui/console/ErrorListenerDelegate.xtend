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
import com.google.inject.Provider
import org.eclipse.jface.text.BadLocationException
import org.eclipse.ui.console.IPatternMatchListenerDelegate
import org.eclipse.ui.console.PatternMatchEvent
import org.eclipse.ui.console.TextConsole

import static extension de.tfritsch.psdt.help.PSHelpExtensions.getDocumentations

/**
 * Matches plugin.xml
 * extension[@point="org.eclipse.ui.console.consolePatternMatchListeners"]/consolePatternMatchListener/@class
 * 
 * @author Thomas Fritsch - initial API and implementation
 */
class ErrorListenerDelegate implements IPatternMatchListenerDelegate {

	TextConsole console
	@Inject Provider<Hyperlink> hyperlinkProvider

	override connect(TextConsole console) {
		this.console = console
	}

	override matchFound(PatternMatchEvent event) {
		try {
			val matchedText = console.document.get(event.offset, event.length)
			val errorName = matchedText.split(" ").get(1)
			val url = errorName.substring(1).documentations.head?.url
			if (url !== null) {
				val hyperlink = hyperlinkProvider.get
				hyperlink.url = url
				console.addHyperlink(hyperlink, event.offset + matchedText.indexOf(errorName), errorName.length)
			}
		} catch (BadLocationException e) {
		}
	}

	override disconnect() {
		console = null
	}

}
