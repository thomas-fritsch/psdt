package de.tfritsch.psdt.ui.editor;

import org.eclipse.debug.ui.actions.IToggleBreakpointsTarget;
import org.eclipse.xtext.ui.editor.XtextEditor;

import com.google.inject.Inject;

public class PostscriptEditor extends XtextEditor {

	@Inject
	private IToggleBreakpointsTarget fToggleBreakpointsTarget;

	@SuppressWarnings("rawtypes")
	public Object getAdapter(Class adapter) {
		if (IToggleBreakpointsTarget.class.equals(adapter)) {
			return fToggleBreakpointsTarget;
		}
		return super.getAdapter(adapter);
	}

}
