package de.tfritsch.psdt.debug.model;

import org.eclipse.core.resources.IMarker;
import org.eclipse.core.resources.IResource;
import org.eclipse.core.resources.IWorkspaceRunnable;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.debug.core.DebugException;
import org.eclipse.debug.core.model.LineBreakpoint;

/**
 * Postscript line breakpoint.
 * 
 * Matches plugin.xml
 * extension[@point="org.eclipse.debug.core.breakpoints"]/breakpoint/@class
 */
public class PSLineBreakpoint extends LineBreakpoint {

	public PSLineBreakpoint() {
	}

	public PSLineBreakpoint(final IResource resource, final int lineNumber)
			throws DebugException {
		run(getMarkerRule(resource), new IWorkspaceRunnable() {

			// @Override
			public void run(IProgressMonitor monitor) throws CoreException {
				IMarker marker = resource.createMarker(LINE_BREAKPOINT_MARKER);
				marker.setAttribute(ID, getModelIdentifier());
				marker.setAttribute(ENABLED, true);
				marker.setAttribute(IMarker.LINE_NUMBER, lineNumber);
				setMarker(marker);
			}
		});
	}

	// @Override
	public String getModelIdentifier() {
		return PSDebugElement.MODEL_ID;
	}

}
