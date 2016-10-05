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
package de.tfritsch.psdt.debug.core.model

import de.tfritsch.psdt.debug.PSPlugin
import org.eclipse.debug.core.model.DebugElement

/**
 * Common function of PostScript debug model elements
 * 
 * @author Thomas Fritsch - initial API and implementation
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

	override getModelIdentifier() {
		MODEL_ID
	}

	/**
	 * Gets the PSDebugTarget containing this element.
	 */
	def protected PSDebugTarget getPSDebugTarget() {
		debugTarget as PSDebugTarget
	}

	/**
	 * Gets the IPSDebugDebugCommander for this element.
	 */
	def protected IPSDebugCommander getPSDebugCommander() {
		PSDebugTarget.PSDebugCommander
	}

	def protected void debug(String s) {
		if (PSPlugin.^default.debugging)
			println(s)
	}
}
