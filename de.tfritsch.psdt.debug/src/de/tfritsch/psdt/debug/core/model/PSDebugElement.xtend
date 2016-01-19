package de.tfritsch.psdt.debug.core.model

import de.tfritsch.psdt.debug.PSPlugin
import org.eclipse.debug.core.model.DebugElement

/**
 * Common function of PostScript debug model elements
 */
abstract class PSDebugElement extends DebugElement {

	/**
     * Unique identifier for the PostScript debug model (value 
     * <code>{@value}</code>).
     * Matches plugin.xml
     * extension[@point="org.eclipse.debug.ui.debugModelPresentations"]/debugModelPresentation/@id
     * and
     * extension[@point="org.eclipse.debug.core.watchExpressionDelegates"]/watchExpressionDelegate/@debugModel
     */
	public static val MODEL_ID = PSPlugin.ID

	/**
	 * Constructs a new debug element contained in the given debug target.
	 * 
	 * @param target
	 *            debug target containing this element
	 */
	new(PSDebugTarget target) {
		super(target)
	}

	override String getModelIdentifier() {
		return MODEL_ID
	}

	/**
	 * Gets the PSDebugTarget containing this element.
	 */
	def protected PSDebugTarget getPSDebugTarget() {
		return debugTarget as PSDebugTarget
	}

	/**
	 * Gets the IPSDebugDebugCommander for this element.
	 */
	def protected IPSDebugCommander getPSDebugCommander() {
		return getPSDebugTarget.getPSDebugCommander()
	}

	def protected void debug(String s) {
		if (PSPlugin.^default.debugging)
			println(s)
	}
}
