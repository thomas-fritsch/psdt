package de.tfritsch.psdt.debug.ui.breakpoints

import org.eclipse.core.runtime.IAdapterFactory
import org.eclipse.debug.ui.actions.IRunToLineTarget
import org.eclipse.debug.ui.actions.IToggleBreakpointsTarget
import org.eclipse.ui.texteditor.ITextEditor

class PSAdapterFactory implements IAdapterFactory {

	val fToggleBreakpointsTarget = new PSToggleBreakpointsTarget

	val fRunToLineTarget = new PSRunToLineTarget

	@SuppressWarnings("rawtypes")
	override Object getAdapter(Object adaptableObject, Class adapterType) {
		switch (adapterType) {
			case IToggleBreakpointsTarget:
				if (adaptableObject instanceof ITextEditor)
					return fToggleBreakpointsTarget
			case IRunToLineTarget:
				if (adaptableObject instanceof ITextEditor)
					return fRunToLineTarget
		}
		return null
	}

	@SuppressWarnings("rawtypes")
	override Class[] getAdapterList() {
		return #[IToggleBreakpointsTarget, IRunToLineTarget]
	}

}
