/*******************************************************************************
 * Copyright (c) 2016 Thomas Fritsch.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
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

	override String getModelIdentifier() {
		return PSDebugElement.MODEL_ID
	}

}
