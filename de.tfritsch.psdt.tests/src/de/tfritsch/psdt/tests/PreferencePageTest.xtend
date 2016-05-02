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
package de.tfritsch.psdt.tests

import com.google.inject.Inject
import de.tfritsch.psdt.PostscriptUiInjectorProvider
import org.eclipse.jface.preference.IPreferencePageContainer
import org.eclipse.xtext.LanguageInfo
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.ui.AbstractWorkbenchTest
import org.junit.Test
import org.junit.runner.RunWith

/**
 * @author Thomas Fritsch - initial API and implementation
 */
@RunWith(XtextRunner)
@InjectWith(PostscriptUiInjectorProvider)
class PreferencePageTest extends AbstractWorkbenchTest {

	@Inject LanguageInfo languageInfo

	// Mimic things normally done by PreferenceDialog
	private def void openPreferencePageAndOk(String path) {
		val node = workbench.preferenceManager.find(path)
		node.createPage
		val page = node.page
		page.container = new PreferencePageContainer
		page.createControl(workbenchWindow.shell)
		page.performOk
		page.dispose
	}

	private def String getCategory() {
		return languageInfo.languageName
	}

	@Test
	def void testDebugPreferencePage() {
		openPreferencePageAndOk(category + "/de.tfritsch.psdt.debug.debugPreferencePage")
	}

	@Test
	def void testGhostscriptPreferencePage() {
		openPreferencePageAndOk(category + "/de.tfritsch.psdt.debug.ghostscriptPreferencePage")
	}

	private static class PreferencePageContainer implements IPreferencePageContainer {

		override getPreferenceStore() {
			return null
		}

		override updateButtons() {
		}

		override updateMessage() {
		}

		override updateTitle() {
		}

	}
}
