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

import org.eclipse.debug.core.model.IDebugElement
import org.eclipse.debug.core.model.IStackFrame
import org.eclipse.debug.core.model.IWatchExpressionDelegate
import org.eclipse.debug.core.model.IWatchExpressionListener
import org.eclipse.debug.core.model.IWatchExpressionResult

/**
 * A delegate for evaluating Postscript watch expressions.
 * 
 * Matches plugin.xml
 * extension[@point="org.eclipse.debug.core.watchExpressionDelegates"
 * ]/watchExpressionDelegate/@delgateClass
 * 
 * @author Thomas Fritsch - initial API and implementation
 */
class PSWatchExpressionDelegate implements IWatchExpressionDelegate {

	override evaluateExpression(String expression, IDebugElement context, IWatchExpressionListener listener) {
		val stackFrame = context.getAdapter(IStackFrame) as IStackFrame

		// TODO evaluate expression
		val result = new IWatchExpressionResult {
			override getValue() {
				null
			}

			override hasErrors() {
				true
			}

			override getErrorMessages() {
				#["(Watch expressions not supported)"]
			}

			override getExpressionText() {
				""
			}

			override getException() {
				null
			}
		}
		listener.watchEvaluationFinished(result)
	}

}
