package de.tfritsch.psdt.debug;

import org.eclipse.core.runtime.IAdapterFactory;
import org.eclipse.debug.ui.actions.IRunToLineTarget;
import org.eclipse.debug.ui.actions.IToggleBreakpointsTarget;

import de.tfritsch.psdt.debug.ui.PSRunToLineTarget;
import de.tfritsch.psdt.debug.ui.PSToggleBreakpointsTarget;

public class PSAdapterFactory implements IAdapterFactory {

	private IToggleBreakpointsTarget fToggleBreakpointsTarget = new PSToggleBreakpointsTarget();

	private IRunToLineTarget fRunToLineTarget = new PSRunToLineTarget();

	@Override
	@SuppressWarnings("rawtypes")
	public Object getAdapter(Object adaptableObject, Class adapterType) {
		if (IToggleBreakpointsTarget.class.equals(adapterType)) {
			return fToggleBreakpointsTarget;
		}
		if (IRunToLineTarget.class.equals(adapterType)) {
			return fRunToLineTarget;
		}
		return null;
	}

	@Override
	@SuppressWarnings("rawtypes")
	public Class[] getAdapterList() {
		return new Class[] { IToggleBreakpointsTarget.class,
				IRunToLineTarget.class };
	}

}
