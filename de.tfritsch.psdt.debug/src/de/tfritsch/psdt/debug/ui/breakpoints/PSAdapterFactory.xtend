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
import org.eclipse.core.runtime.IAdapterFactory
import org.eclipse.debug.ui.actions.IRunToLineTarget
import org.eclipse.debug.ui.actions.IToggleBreakpointsTarget
import org.eclipse.ui.texteditor.ITextEditor

/**
 * @author Thomas Fritsch - initial API and implementation
 */
class PSAdapterFactory implements IAdapterFactory {

	@Inject IToggleBreakpointsTarget fToggleBreakpointsTarget

	@Inject IRunToLineTarget fRunToLineTarget

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
