package de.tfritsch.psdt.debug.ui;

import org.eclipse.core.resources.IResource;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.debug.core.DebugPlugin;
import org.eclipse.debug.core.model.ISuspendResume;
import org.eclipse.debug.ui.actions.IRunToLineTarget;
import org.eclipse.jface.text.ITextSelection;
import org.eclipse.jface.viewers.ISelection;
import org.eclipse.ui.IWorkbenchPart;
import org.eclipse.ui.texteditor.ITextEditor;

import de.tfritsch.psdt.debug.model.PSLineBreakpoint;

public class PSRunToLineTarget implements IRunToLineTarget {

	public void runToLine(IWorkbenchPart part, ISelection selection,
			ISuspendResume target) throws CoreException {
		ITextEditor textEditor = (ITextEditor) part.getAdapter(ITextEditor.class);
		IResource resource = (IResource) textEditor.getEditorInput().getAdapter(IResource.class);
		ITextSelection textSelection = (ITextSelection) selection;
		int lineNumber = textSelection.getStartLine();
		PSLineBreakpoint breakpoint = new PSLineBreakpoint(resource, lineNumber + 1);
		breakpoint.setPersisted(false);
		DebugPlugin.getDefault().getBreakpointManager().addBreakpoint(breakpoint);
		target.resume();
	}

	public boolean canRunToLine(IWorkbenchPart part, ISelection selection,
			ISuspendResume target) {
		ITextEditor textEditor = (ITextEditor) part.getAdapter(ITextEditor.class);
		IResource resource = (IResource) textEditor.getEditorInput().getAdapter(IResource.class);
		return (resource != null);
	}

}
