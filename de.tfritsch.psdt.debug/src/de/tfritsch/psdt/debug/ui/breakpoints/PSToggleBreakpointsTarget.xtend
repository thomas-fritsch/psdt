/*******************************************************************************
 * Copyright (c) 2016 Thomas Fritsch.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 ******************************************************************************/
package de.tfritsch.psdt.debug.ui.breakpoints

import de.tfritsch.psdt.debug.PSPlugin
import de.tfritsch.psdt.debug.core.breakpoints.PSLineBreakpoint
import org.eclipse.core.resources.IResource
import org.eclipse.core.runtime.CoreException
import org.eclipse.debug.core.DebugPlugin
import org.eclipse.debug.core.model.ILineBreakpoint
import org.eclipse.debug.ui.actions.IToggleBreakpointsTarget
import org.eclipse.jface.text.ITextSelection
import org.eclipse.jface.viewers.ISelection
import org.eclipse.ui.IWorkbenchPart
import org.eclipse.ui.texteditor.ITextEditor

/**
 * @author Thomas Fritsch - initial API and implementation
 */
class PSToggleBreakpointsTarget implements IToggleBreakpointsTarget {

	val breakpointManager = DebugPlugin.^default.breakpointManager

	override void toggleLineBreakpoints(IWorkbenchPart part, ISelection selection) throws CoreException {
		val textEditor = part.getAdapter(ITextEditor) as ITextEditor
		val resource = textEditor.editorInput.getAdapter(IResource) as IResource
		val lineNumber = (selection as ITextSelection).startLine
		val breakpoints = breakpointManager.getBreakpoints(PSPlugin.ID)
		for (breakpoint : breakpoints) {
			if (resource == breakpoint.marker.resource) {
				if ((breakpoint as ILineBreakpoint).lineNumber == (lineNumber + 1)) {

					// remove
					breakpoint.delete
					return
				}
			}
		}

		// create line breakpoint (doc line numbers start at 0)
		val breakpoint = new PSLineBreakpoint(resource, lineNumber + 1)
		breakpointManager.addBreakpoint(breakpoint)
	}

	override boolean canToggleLineBreakpoints(IWorkbenchPart part, ISelection selection) {
		val textEditor = part.getAdapter(ITextEditor) as ITextEditor
		val resource = textEditor.editorInput.getAdapter(IResource) as IResource
		return (resource != null)
	}

	override void toggleMethodBreakpoints(IWorkbenchPart part, ISelection selection) throws CoreException {
	}

	override boolean canToggleMethodBreakpoints(IWorkbenchPart part, ISelection selection) {
		return false
	}

	override void toggleWatchpoints(IWorkbenchPart part, ISelection selection) throws CoreException {
	}

	override boolean canToggleWatchpoints(IWorkbenchPart part, ISelection selection) {
		return false
	}
}
