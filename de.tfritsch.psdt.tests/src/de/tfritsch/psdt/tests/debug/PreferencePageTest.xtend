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
package de.tfritsch.psdt.tests.debug

import de.tfritsch.psdt.tests.AbstractWorkbenchTestExtension
import org.eclipse.jface.preference.PreferenceDialog
import org.junit.Test

/**
 * @author Thomas Fritsch - initial API and implementation
 */
class PreferencePageTest extends AbstractWorkbenchTestExtension {

	private def void openPreferencePageAndOk(String pageId) {
		val dialog = new PreferenceDialog(workbenchWindow.shell, workbench.preferenceManager) {
			override open() {
				workbench.display.asyncExec [
					waitFor[shell.isVisible]
					okPressed
				]
				return super.open
			}
		}
		dialog.selectedNode = pageId
		dialog.create
		dialog.open
	}

	@Test
	def void testDebugPreferencePage() {
		openPreferencePageAndOk("de.tfritsch.psdt.debug.debugPreferencePage")
	}

	@Test
	def void testGhostscriptPreferencePage() {
		openPreferencePageAndOk("de.tfritsch.psdt.debug.ghostscriptPreferencePage")
	}
}
