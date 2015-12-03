package de.tfritsch.psdt.ui.perspective

import de.tfritsch.psdt.ui.views.PostscriptDocView
import org.eclipse.ui.IPageLayout
import org.eclipse.ui.IPerspectiveFactory
import org.eclipse.ui.console.IConsoleConstants
import org.eclipse.ui.progress.IProgressConstants
import org.eclipse.debug.ui.IDebugUIConstants

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

		// ToolBar contributions
		layout.addActionSet(IDebugUIConstants.LAUNCH_ACTION_SET);
		layout.addActionSet(IPageLayout.ID_NAVIGATE_ACTION_SET);

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
