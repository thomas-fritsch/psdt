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
import de.tfritsch.psdt.debug.Debug
import java.util.regex.Pattern
import org.eclipse.debug.ui.DebugUITools
import org.eclipse.debug.ui.IDebugModelPresentation
import org.eclipse.debug.ui.console.IConsole
import org.eclipse.debug.ui.console.IConsoleLineTracker
import org.eclipse.jface.preference.IPreferenceStore
import org.eclipse.jface.text.IRegion
import org.eclipse.swt.SWT
import org.eclipse.swt.widgets.Display
import org.eclipse.swt.widgets.MessageBox
import org.eclipse.ui.IWorkbench

import static extension de.tfritsch.psdt.debug.PSLaunchExtensions.*
import static extension de.tfritsch.psdt.help.PSHelpExtensions.*
import static extension java.util.regex.Pattern.*

/**
 * Matches plugin.xml
 * extension[@point="org.eclipse.debug.ui.consoleLineTrackers"]/consoleLineTracker/@class
 * 
 * @author Thomas Fritsch - initial API and implementation
 */
class PSConsoleLineTracker implements IConsoleLineTracker {

	IConsole console
	@Inject @Debug IPreferenceStore preferenceStore
	@Inject IWorkbench workbench
	@Inject Provider<Hyperlink> hyperlinkProvider
	IDebugModelPresentation debugModelPresentation

	override init(IConsole console) {
		this.console = console
		debugModelPresentation = DebugUITools.newDebugModelPresentation
	}

	Pattern errorPattern = "Error: (/\\w+) in .+".compile
	Pattern pressReturnPattern = ".*press <return> to continue.*".compile

	override lineAppended(IRegion line) {
		val text = console.document.get(line.offset, line.length)
		var matcher = errorPattern.matcher(text)
		if (matcher.matches) {
			val offset = line.offset + matcher.start(1)
			val length = matcher.end(1) - matcher.start(1)
			val url = matcher.group(1).substring(1).documentations.head?.url
			if (url !== null) {
				val hyperlink = hyperlinkProvider.get
				hyperlink.url = url
				console.addLink(hyperlink, offset, length)
			}
		}
		matcher = pressReturnPattern.matcher(text)
		if (matcher.matches && preferenceStore.messageBoxOnPrompt) {
			Display.^default.syncExec [
				val shell = workbench.activeWorkbenchWindow.shell
				val box = new MessageBox(shell, SWT.OK.bitwiseOr(SWT.ICON_INFORMATION).bitwiseOr(SWT.PRIMARY_MODAL))
				box.text = debugModelPresentation.getText(console.process.launch)
				box.message = text
				box.open
			]
			console.process.streamsProxy.write("\n")
		}
	}

	override dispose() {
		console = null
		debugModelPresentation.dispose
		debugModelPresentation = null
	}
}
