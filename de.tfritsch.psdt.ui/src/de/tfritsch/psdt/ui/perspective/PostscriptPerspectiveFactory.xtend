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
package de.tfritsch.psdt.ui.perspective

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
