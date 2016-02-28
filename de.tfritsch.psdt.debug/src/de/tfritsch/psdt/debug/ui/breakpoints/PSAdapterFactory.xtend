package de.tfritsch.psdt.debug.ui.breakpoints

import com.google.inject.Inject
import de.tfritsch.psdt.debug.PSPlugin
import org.eclipse.core.runtime.IAdapterFactory
import org.eclipse.debug.ui.actions.IRunToLineTarget
import org.eclipse.debug.ui.actions.IToggleBreakpointsTarget
import org.eclipse.ui.texteditor.ITextEditor

class PSAdapterFactory implements IAdapterFactory {

	@Inject PSToggleBreakpointsTarget fToggleBreakpointsTarget

	@Inject PSRunToLineTarget fRunToLineTarget

	new() {
		PSPlugin.injector.injectMembers(this) // TODO remove this hack
	}

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
