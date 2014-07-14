package de.tfritsch.psdt.debug.model;

import org.eclipse.core.runtime.CoreException;
import org.eclipse.debug.core.model.ILineBreakpoint;

public interface IPSLineBreakpoint extends ILineBreakpoint {

	/** 
	 * String marker attribute.  A string value indicating the token text.
	 */
	public static final String STRING = "de.tfritsch.psdt.debug.model.string"; //$NON-NLS-1$

	/**
	 * Returns the token string in the original source that corresponds
	 * to the location of this breakpoint, or null if the attribute is not present.
	 *
	 * @return this breakpoint's token string, or null if unknown
	 * @exception CoreException if a <code>CoreException</code> is thrown
	 * 	while accessing the underlying <code>IMarker.CHAR_END</code> marker attribute
	 */
	public String getString() throws CoreException;
}
