/*******************************************************************************
 * Copyright (c) 2016 Thomas Fritsch.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 ******************************************************************************/
package de.tfritsch.psdt.debug.ui.breakpoints

import com.google.inject.Inject
import de.tfritsch.psdt.debug.PSPlugin
import org.eclipse.core.runtime.IAdapterFactory
import org.eclipse.debug.ui.actions.IRunToLineTarget
import org.eclipse.debug.ui.actions.IToggleBreakpointsTarget
import org.eclipse.ui.texteditor.ITextEditor

/**
 * @author Thomas Fritsch - initial API and implementation
 */
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
