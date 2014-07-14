package de.tfritsch.psdt.debug.model;

import org.eclipse.core.resources.IMarker;
import org.eclipse.core.resources.IResource;
import org.eclipse.core.resources.IWorkspaceRunnable;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.IProgressMonitor;
import org.eclipse.debug.core.model.IBreakpoint;
import org.eclipse.debug.core.model.LineBreakpoint;
import org.eclipse.osgi.util.NLS;

import de.tfritsch.psdt.debug.PSPlugin;
import de.tfritsch.psdt.debug.ui.PSDebugModelPresentation;

/**
 * Matches plugin.xml
 * extension[@point="org.eclipse.debug.core.breakpoints"]/breakpoint/@class
 */
public class PSLineBreakpoint extends LineBreakpoint implements IPSLineBreakpoint {
    
    /**
     * Unique identifier for the PostScript line breakpoint marker (value 
     * <code>{@value}</code>).
     * Matches plugin.xml
     * extension[@point="org.eclipse.debug.core.breakpoints"]/breakpoint/@markerType
     */
    public final static String MARKER_TYPE =  PSPlugin.ID + ".lineBreakpointMarker"; //$NON-NLS-1$
	
	/**
	 */
	public PSLineBreakpoint() {	
	}
	
	/**
	 * Constructs a line breakpoint on the given resource at the given line
	 * number. The line number is 1-based (i.e. the first line of a file is line
	 * number 1).
	 * 
	 * @param resource
	 *            file on which to set the breakpoint
	 * @param lineNumber
	 *            1-based line number of the breakpoint
	 * @throws CoreException
	 *             if unable to create the breakpoint
	 */
	public PSLineBreakpoint(final IResource resource, final int lineNumber)
			throws CoreException {
		IWorkspaceRunnable runnable = new IWorkspaceRunnable() {
			//@Override
			public void run(IProgressMonitor monitor) throws CoreException {
				IMarker marker = resource.createMarker(MARKER_TYPE);
				setMarker(marker);
				marker.setAttribute(IBreakpoint.ENABLED, Boolean.TRUE);
				marker.setAttribute(IMarker.LINE_NUMBER, lineNumber);
				marker.setAttribute(IBreakpoint.ID, getModelIdentifier());
				marker.setAttribute(IMarker.MESSAGE, NLS.bind(
						"Line Breakpoint: {0} [line {1}]",
						resource.getName(),	new Integer(lineNumber)));
			}
		};
		run(getMarkerRule(resource), runnable);
	}

	/**
	 * Constructs a line breakpoint on the given resource at the given token.
	 * 
	 * @param resource
	 *            file on which to set the breakpoint
	 * @param token
	 *            token on which to set breakpoint
	 * @throws CoreException
	 *             if unable to create the breakpoint
	 */
	public PSLineBreakpoint(final IResource resource, final PSToken token)
			throws CoreException {
		IWorkspaceRunnable runnable = new IWorkspaceRunnable() {
			//@Override
			public void run(IProgressMonitor monitor) throws CoreException {
				IMarker marker = resource.createMarker(MARKER_TYPE);
				setMarker(marker);
				marker.setAttribute(IBreakpoint.ENABLED, Boolean.TRUE);
				marker.setAttribute(IMarker.LINE_NUMBER, token.getLineNumber());
				marker.setAttribute(IMarker.CHAR_START, token.getCharStart());
				marker.setAttribute(IMarker.CHAR_END, token.getCharEnd());
				marker.setAttribute(IBreakpoint.ID, getModelIdentifier());
				marker.setAttribute(IMarker.MESSAGE, NLS.bind(
						"Line Breakpoint: {0} [line {1}]",
						resource.getName(), token.toString()));
			}
		};
		run(getMarkerRule(resource), runnable);
	}

    //@Override
	public String getModelIdentifier() {
        return PSDebugModelPresentation.ID;
    }

	//@Override
	public String getString() throws CoreException {
		IMarker m = getMarker();
		if (m != null)
			return m.getAttribute(STRING, null);
		return null;
	}
}
