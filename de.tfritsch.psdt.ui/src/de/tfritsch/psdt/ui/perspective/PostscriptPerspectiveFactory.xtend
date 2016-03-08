/*******************************************************************************
 * Copyright (c) 2016 Thomas Fritsch.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 ******************************************************************************/
package de.tfritsch.psdt.ui.perspective

import de.tfritsch.psdt.ui.views.PostscriptDocView
import org.eclipse.debug.ui.IDebugUIConstants
import org.eclipse.ui.IPageLayout
import org.eclipse.ui.IPerspectiveFactory
import org.eclipse.ui.console.IConsoleConstants
import org.eclipse.ui.progress.IProgressConstants
import org.eclipse.ui.wizards.newresource.BasicNewFileResourceWizard
import org.eclipse.ui.wizards.newresource.BasicNewFolderResourceWizard

/**
 * @author Thomas Fritsch - initial API and implementation
 */
class PostscriptPerspectiveFactory implements IPerspectiveFactory {

	override createInitialLayout(IPageLayout layout) {
		val editorArea = layout.editorArea
		layout.createFolder("left", IPageLayout.LEFT, 0.25F, editorArea) => [
			addView(IPageLayout.ID_PROJECT_EXPLORER)
		]
		layout.createFolder("bottom", IPageLayout.BOTTOM, 0.75F, editorArea) => [
			addView(IPageLayout.ID_PROBLEM_VIEW)
			addView(IConsoleConstants.ID_CONSOLE_VIEW)
			addPlaceholder(PostscriptDocView.ID)
			addPlaceholder(IPageLayout.ID_PROP_SHEET)
		]
		layout.createFolder("right", IPageLayout.RIGHT, 0.75F, editorArea) => [
			addView(IPageLayout.ID_OUTLINE)
		]

		// Menu/ToolBar contributions
		layout.addActionSet(IDebugUIConstants.LAUNCH_ACTION_SET);
		layout.addActionSet(IPageLayout.ID_NAVIGATE_ACTION_SET);

		// 'File' > 'New' contributions
		layout.addNewWizardShortcut(BasicNewFileResourceWizard.WIZARD_ID)
		layout.addNewWizardShortcut(BasicNewFolderResourceWizard.WIZARD_ID);

		// 'Window' > 'Show View' contributions
		layout.addShowViewShortcut(IPageLayout.ID_OUTLINE);
		layout.addShowViewShortcut(IPageLayout.ID_PROBLEM_VIEW);
		layout.addShowViewShortcut(IPageLayout.ID_TASK_LIST);
		layout.addShowViewShortcut(IProgressConstants.PROGRESS_VIEW_ID);
		layout.addShowViewShortcut(IPageLayout.ID_PROJECT_EXPLORER);
		layout.addShowViewShortcut("org.eclipse.pde.runtime.LogView");

		// 'Window' > 'Open Perspective' contributions
		layout.addPerspectiveShortcut(IDebugUIConstants.ID_DEBUG_PERSPECTIVE)
	}

}
