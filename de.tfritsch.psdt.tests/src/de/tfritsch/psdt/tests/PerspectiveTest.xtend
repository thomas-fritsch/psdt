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
import org.eclipse.ui.IPageLayout
import org.eclipse.ui.IWorkbench
import org.eclipse.ui.console.IConsoleConstants
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.junit.Test
import org.junit.runner.RunWith

import static org.junit.Assert.*

/**
 * @author Thomas Fritsch - initial API and implementation
 */
@RunWith(XtextRunner)
@InjectWith(PostscriptUiInjectorProvider)
class PerspectiveTest {

	@Inject
	IWorkbench workbench
	
	@Test
	def void testPostscriptPerspective() throws Exception {
		val descriptor = workbench.perspectiveRegistry.findPerspectiveWithLabel("PostScript")
		workbench.showPerspective(descriptor.id, workbench.activeWorkbenchWindow)
		val page = workbench.activeWorkbenchWindow.pages.get(0)
		assertNotNull(page.findViewReference(IPageLayout.ID_PROJECT_EXPLORER))
		assertNotNull(page.findViewReference(IPageLayout.ID_PROBLEM_VIEW))
		assertNotNull(page.findViewReference(IConsoleConstants.ID_CONSOLE_VIEW))
		assertNotNull(page.findViewReference(IPageLayout.ID_OUTLINE))
	}
}
