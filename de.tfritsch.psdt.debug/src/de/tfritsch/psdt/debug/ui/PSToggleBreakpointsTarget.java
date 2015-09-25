package de.tfritsch.psdt.debug.ui;

import org.eclipse.core.resources.IResource;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.debug.core.DebugPlugin;
import org.eclipse.debug.core.model.IBreakpoint;
import org.eclipse.debug.core.model.ILineBreakpoint;
import org.eclipse.debug.ui.actions.IToggleBreakpointsTarget;
import org.eclipse.jface.text.ITextSelection;
import org.eclipse.jface.viewers.ISelection;
import org.eclipse.ui.IWorkbenchPart;
import org.eclipse.ui.texteditor.ITextEditor;

import de.tfritsch.psdt.debug.PSPlugin;
import de.tfritsch.psdt.debug.model.PSLineBreakpoint;

public class PSToggleBreakpointsTarget implements IToggleBreakpointsTarget {

	@Override
	public void toggleLineBreakpoints(IWorkbenchPart part, ISelection selection)
			throws CoreException {
		ITextEditor textEditor = (ITextEditor) part.getAdapter(ITextEditor.class);
		IResource resource = (IResource) textEditor.getEditorInput().getAdapter(IResource.class);
		ITextSelection textSelection = (ITextSelection) selection;
		int lineNumber = textSelection.getStartLine();
		IBreakpoint[] breakpoints = DebugPlugin.getDefault().getBreakpointManager().getBreakpoints(PSPlugin.ID);
		for (IBreakpoint breakpoint : breakpoints) {
			if (resource.equals(breakpoint.getMarker().getResource())) {
				if (((ILineBreakpoint)breakpoint).getLineNumber() == (lineNumber + 1)) {
					// remove
					breakpoint.delete();
					return;
				}
			}
		}
		// create line breakpoint (doc line numbers start at 0)
		PSLineBreakpoint breakpoint = new PSLineBreakpoint(resource, lineNumber + 1);
		DebugPlugin.getDefault().getBreakpointManager().addBreakpoint(breakpoint);
	}

	@Override
	public boolean canToggleLineBreakpoints(IWorkbenchPart part,
			ISelection selection) {
		ITextEditor textEditor = (ITextEditor) part.getAdapter(ITextEditor.class);
		IResource resource = (IResource) textEditor.getEditorInput().getAdapter(IResource.class);
		return (resource != null);
	}

	@Override
	public void toggleMethodBreakpoints(IWorkbenchPart part,
			ISelection selection) throws CoreException {
	}

	@Override
	public boolean canToggleMethodBreakpoints(IWorkbenchPart part,
			ISelection selection) {
		return false;
	}

	@Override
	public void toggleWatchpoints(IWorkbenchPart part, ISelection selection)
			throws CoreException {
	}

	@Override
	public boolean canToggleWatchpoints(IWorkbenchPart part,
			ISelection selection) {
		return false;
	}
}
