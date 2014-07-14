package de.tfritsch.psdt.debug.model;

import org.eclipse.core.runtime.IStatus;
import org.eclipse.core.runtime.Status;
import org.eclipse.debug.core.DebugException;
import org.eclipse.debug.core.DebugPlugin;
import org.eclipse.debug.core.model.DebugElement;

import de.tfritsch.psdt.debug.PSPlugin;
import de.tfritsch.psdt.debug.ui.PSDebugModelPresentation;

/**
 * Common function of PostScript debug model elements
 */
abstract class PSDebugElement extends DebugElement {
	/**
	 * Constructs a new debug element contained in the given debug target.
	 * 
	 * @param target
	 *            debug target containing this element
	 */
	PSDebugElement(PSDebugTarget target) {
		super(target);
	}

	//@Override
	public String getModelIdentifier() {
		return PSDebugModelPresentation.ID;
	}
	
	/**
	 * Gets the PSDebugTarget containing this element.
	 */
	PSDebugTarget getPSDebugTarget() {
		return (PSDebugTarget) getDebugTarget();
	}
	
	/**
	 * Gets the IPSDebugDebugCommander for this element.
	 */
	IPSDebugCommander getPSDebugCommander() {
		return getPSDebugTarget().getPSDebugCommander();
	}

	void debug(String s) {
		if (PSPlugin.getDefault().isDebugging())
			System.out.println(s);
	}

	/**
	 * Throws a debug exception with a status code of <code>INTERNAL_ERROR</code>.
	 * 
	 * @param message exception message
	 * @param e underlying exception or <code>null</code>
	 * @throws DebugException
	 */
	protected void internalError(String message, Throwable e) throws DebugException {
		throw new DebugException(new Status(IStatus.ERROR, DebugPlugin.getUniqueIdentifier(), 
				DebugException.INTERNAL_ERROR, message, e));
	}

}
