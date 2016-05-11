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
import org.eclipse.ui.IEditorPart
import org.eclipse.xtext.LanguageInfo
import org.eclipse.xtext.junit4.ui.AbstractEditorTest

/**
 * @author Thomas Fritsch - initial API and implementation
 */
 class AbstractWorkbenchTestExtension extends AbstractEditorTest {

	@Inject	LanguageInfo languageInfo

	protected override getEditorId() {
		return languageInfo.languageName
	}

	protected def void waitFor(()=>boolean predicate) throws InterruptedException {
		for (n : 1 .. 20) {
			sleep(1000)
			if (predicate.apply)
				return
		}
		fail("timeout")
	}

	protected def IEditorPart getActiveEditor() {
		return activePage.activeEditor
	}

	protected def void showPerspective(String id) {
		workbench.showPerspective(id, workbenchWindow)
	}

}
