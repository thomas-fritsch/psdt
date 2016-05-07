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

import org.eclipse.debug.ui.IDebugUIConstants
import org.eclipse.ui.IEditorPart
import org.eclipse.xtext.junit4.ui.AbstractWorkbenchTest

/**
 * @author Thomas Fritsch - initial API and implementation
 */
abstract class AbstractWorkbenchTestExtension extends AbstractWorkbenchTest {

	protected def void waitFor(()=>boolean predicate) throws InterruptedException {
		for (n : 1 .. 10) {
			sleep(1000)
			if (predicate.apply)
				return
		}
		fail("timeout")
	}

	def protected IEditorPart getActiveEditor() {
		return activePage.activeEditor
	}

	protected def void showPerspective(String id) {
		workbench.showPerspective(id, workbenchWindow)
	}

	protected def void showDebugPerspective() {
		showPerspective(IDebugUIConstants.ID_DEBUG_PERSPECTIVE)
	}

}
