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
import de.tfritsch.psdt.debug.Debug
import java.io.IOException
import org.eclipse.debug.ui.DebugUITools
import org.eclipse.jface.preference.IPreferenceStore
import org.eclipse.jface.text.BadLocationException
import org.eclipse.jface.viewers.ILabelProvider
import org.eclipse.swt.SWT
import org.eclipse.swt.widgets.Display
import org.eclipse.swt.widgets.MessageBox
import org.eclipse.ui.IWorkbench
import org.eclipse.ui.console.IPatternMatchListenerDelegate
import org.eclipse.ui.console.PatternMatchEvent
import org.eclipse.ui.console.TextConsole

import static extension de.tfritsch.psdt.debug.LaunchExtensions.*
import static extension de.tfritsch.psdt.debug.PSLaunchExtensions.*

/**
 * Matches plugin.xml
 * extension[@point="org.eclipse.ui.console.consolePatternMatchListeners"]/consolePatternMatchListener/@class
 * 
 * @author Thomas Fritsch - initial API and implementation
 */
class PressReturnListenerDelegate implements IPatternMatchListenerDelegate {

	TextConsole console
	@Inject @Debug IPreferenceStore preferenceStore
	@Inject IWorkbench workbench
	ILabelProvider labelProvider

	override connect(TextConsole console) {
		this.console = console
		labelProvider = DebugUITools.newDebugModelPresentation
	}

	override matchFound(PatternMatchEvent event) {
		val process = console.consoleProcess
		if (preferenceStore.messageBoxOnPrompt && !process.terminated) {
			try {
				val matchedText = console.document.get(event.offset, event.length)
				Display.^default.syncExec [
					val shell = workbench.activeWorkbenchWindow.shell
					val box = new MessageBox(shell, SWT.OK.bitwiseOr(SWT.ICON_INFORMATION).bitwiseOr(SWT.PRIMARY_MODAL)) => [
						text = labelProvider.getText(process.launch) // title
						message = matchedText
					]
					box.open
				]
				process.streamsProxy.write("\n")
			} catch (BadLocationException e) {
			} catch (IOException e) {
			}
		}
	}

	override disconnect() {
		console = null
		labelProvider.dispose
		labelProvider = null
	}

}
