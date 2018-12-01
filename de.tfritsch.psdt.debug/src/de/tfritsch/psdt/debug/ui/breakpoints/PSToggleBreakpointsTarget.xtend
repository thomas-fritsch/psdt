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
package de.tfritsch.psdt.debug.ui.breakpoints

import com.google.inject.Inject
import de.tfritsch.psdt.debug.PSPlugin
import de.tfritsch.psdt.debug.core.breakpoints.PSLineBreakpoint
import org.eclipse.core.resources.IResource
import org.eclipse.core.runtime.CoreException
import org.eclipse.debug.core.IBreakpointManager
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

	@Inject IBreakpointManager breakpointManager

	override toggleLineBreakpoints(IWorkbenchPart part, ISelection selection) throws CoreException {
		val textEditor = part.getAdapter(ITextEditor)
		val resource = textEditor.editorInput.getAdapter(IResource)
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

	override canToggleLineBreakpoints(IWorkbenchPart part, ISelection selection) {
		val textEditor = part.getAdapter(ITextEditor)
		val resource = textEditor.editorInput.getAdapter(IResource)
		resource != null
	}

	override toggleMethodBreakpoints(IWorkbenchPart part, ISelection selection) throws CoreException {
	}

	override canToggleMethodBreakpoints(IWorkbenchPart part, ISelection selection) {
		false
	}

	override toggleWatchpoints(IWorkbenchPart part, ISelection selection) throws CoreException {
	}

	override canToggleWatchpoints(IWorkbenchPart part, ISelection selection) {
		false
	}
}
