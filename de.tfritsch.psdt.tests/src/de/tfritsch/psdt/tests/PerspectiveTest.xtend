/*******************************************************************************
 * Copyright (c) 2016 Thomas Fritsch.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
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
