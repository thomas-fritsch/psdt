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
package de.tfritsch.psdt.debug.core.breakpoints

import de.tfritsch.psdt.debug.core.model.PSDebugElement
import org.eclipse.core.resources.IMarker
import org.eclipse.core.resources.IResource
import org.eclipse.debug.core.DebugException
import org.eclipse.debug.core.model.LineBreakpoint

/**
 * Postscript line breakpoint.
 * 
 * Matches plugin.xml
 * extension[@point="org.eclipse.debug.core.breakpoints"]/breakpoint/@class
 * 
 * @author Thomas Fritsch - initial API and implementation
 */
class PSLineBreakpoint extends LineBreakpoint {

	new() {
	}

	new(IResource resource, int lineNumber) throws DebugException {
		run(getMarkerRule(resource)) [ monitor |
			marker = resource.createMarker(LINE_BREAKPOINT_MARKER) => [
				setAttribute(ID, modelIdentifier)
				setAttribute(ENABLED, true)
				setAttribute(IMarker.LINE_NUMBER, lineNumber)
			]
		]
	}

	override getModelIdentifier() {
		PSDebugElement.MODEL_ID
	}

}
