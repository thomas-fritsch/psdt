package de.tfritsch.psdt.debug.ui

import de.tfritsch.psdt.debug.model.PSLineBreakpoint
import org.eclipse.core.resources.IResource
import org.eclipse.core.runtime.CoreException
import org.eclipse.debug.core.DebugEvent
import org.eclipse.debug.core.DebugPlugin
import org.eclipse.debug.core.model.ISuspendResume
import org.eclipse.debug.ui.actions.IRunToLineTarget
import org.eclipse.jface.text.ITextSelection
import org.eclipse.jface.viewers.ISelection
import org.eclipse.ui.IWorkbenchPart
import org.eclipse.ui.texteditor.ITextEditor

public class PSRunToLineTarget implements IRunToLineTarget {

	val debugPlugin = DebugPlugin.^default

	val breakpointManager = DebugPlugin.^default.breakpointManager

	override void runToLine(IWorkbenchPart part, ISelection selection, ISuspendResume target) throws CoreException {
		val textEditor = part.getAdapter(ITextEditor) as ITextEditor
		val resource = textEditor.editorInput.getAdapter(IResource) as IResource
		val lineNumber = (selection as ITextSelection).startLine
		val breakpoint = new PSLineBreakpoint(resource, lineNumber + 1)
		breakpoint.persisted = false
		debugPlugin.addDebugEventListener [ events |
			for (DebugEvent event : events) {
				if (event.kind === DebugEvent.SUSPEND) {
					try {
						breakpoint.delete
					} catch (CoreException e) {
						DebugPlugin.log(e)
					}
					debugPlugin.removeDebugEventListener(self)
				}
			}
		]
		breakpointManager.addBreakpoint(breakpoint)
		target.resume
	}

	override boolean canRunToLine(IWorkbenchPart part, ISelection selection, ISuspendResume target) {
		val textEditor = part.getAdapter(ITextEditor) as ITextEditor
		val resource = textEditor.editorInput.getAdapter(IResource) as IResource
		return (resource != null)
	}

}
