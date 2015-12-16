package de.tfritsch.psdt.debug

import de.tfritsch.psdt.debug.ui.PSRunToLineTarget
import de.tfritsch.psdt.debug.ui.PSToggleBreakpointsTarget
import org.eclipse.core.runtime.IAdapterFactory
import org.eclipse.debug.ui.actions.IRunToLineTarget
import org.eclipse.debug.ui.actions.IToggleBreakpointsTarget

class PSAdapterFactory implements IAdapterFactory {

	val fToggleBreakpointsTarget = new PSToggleBreakpointsTarget

	val fRunToLineTarget = new PSRunToLineTarget

	@SuppressWarnings("rawtypes")
	override Object getAdapter(Object adaptableObject, Class adapterType) {
		return switch (adapterType) {
			case IToggleBreakpointsTarget:
				fToggleBreakpointsTarget
			case IRunToLineTarget:
				fRunToLineTarget
			default:
				null
		}
	}

	@SuppressWarnings("rawtypes")
	override Class[] getAdapterList() {
		return #[IToggleBreakpointsTarget, IRunToLineTarget]
	}

}
