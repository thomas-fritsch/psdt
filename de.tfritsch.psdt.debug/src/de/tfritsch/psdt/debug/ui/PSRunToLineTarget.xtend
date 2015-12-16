package de.tfritsch.psdt.debug.ui

import de.tfritsch.psdt.debug.model.PSLineBreakpoint
import org.eclipse.core.resources.IResource
import org.eclipse.core.runtime.IAdaptable
import org.eclipse.core.runtime.CoreException
import org.eclipse.core.runtime.NullProgressMonitor
import org.eclipse.debug.core.model.IDebugTarget
import org.eclipse.debug.core.model.ISuspendResume
import org.eclipse.debug.ui.actions.IRunToLineTarget
import org.eclipse.debug.ui.actions.RunToLineHandler
import org.eclipse.jface.text.ITextSelection
import org.eclipse.jface.viewers.ISelection
import org.eclipse.ui.IWorkbenchPart
import org.eclipse.ui.texteditor.ITextEditor

class PSRunToLineTarget implements IRunToLineTarget {

	override void runToLine(IWorkbenchPart part, ISelection selection, ISuspendResume target) throws CoreException {
		val textEditor = part.getAdapter(ITextEditor) as ITextEditor
		val resource = textEditor.editorInput.getAdapter(IResource) as IResource
		val lineNumber = (selection as ITextSelection).startLine
		val breakpoint = new PSLineBreakpoint(resource, lineNumber + 1)
		breakpoint.persisted = false
		val debugTarget = (target as IAdaptable).getAdapter(IDebugTarget) as IDebugTarget
		if (debugTarget !== null) {
			val handler = new RunToLineHandler(debugTarget, target, breakpoint)
			handler.run(new NullProgressMonitor)
		}
	}

	override boolean canRunToLine(IWorkbenchPart part, ISelection selection, ISuspendResume target) {
		val textEditor = part.getAdapter(ITextEditor) as ITextEditor
		val resource = textEditor.editorInput.getAdapter(IResource) as IResource
		return (resource != null)
	}

}
