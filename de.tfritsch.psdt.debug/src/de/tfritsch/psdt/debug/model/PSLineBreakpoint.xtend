package de.tfritsch.psdt.debug.model

import org.eclipse.core.resources.IMarker
import org.eclipse.core.resources.IResource
import org.eclipse.debug.core.DebugException
import org.eclipse.debug.core.model.LineBreakpoint

/**
 * Postscript line breakpoint.
 * 
 * Matches plugin.xml
 * extension[@point="org.eclipse.debug.core.breakpoints"]/breakpoint/@class
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
