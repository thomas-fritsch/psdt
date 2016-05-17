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

import org.eclipse.ui.IPageLayout
import org.eclipse.ui.console.IConsoleConstants
import org.junit.Test

/**
 * @author Thomas Fritsch - initial API and implementation
 */
class PerspectiveTest extends AbstractWorkbenchTestExtension {
	
	@Test
	def void testPostscriptPerspective() throws Exception {
		showPerspective("de.tfritsch.psdt.ui.perspective")
		assertEquals("PostScript", activePage.perspective.label)
		assertNotNull(activePage.findViewReference(IPageLayout.ID_PROJECT_EXPLORER))
		assertNotNull(activePage.findViewReference(IPageLayout.ID_PROBLEM_VIEW))
		assertNotNull(activePage.findViewReference(IConsoleConstants.ID_CONSOLE_VIEW))
		assertNotNull(activePage.findViewReference(IPageLayout.ID_OUTLINE))
	}
}
