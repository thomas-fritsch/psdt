/*******************************************************************************
 * Copyright (c) 2016 Thomas Fritsch.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 ******************************************************************************/
package de.tfritsch.psdt.debug.core.model

import org.eclipse.debug.core.DebugException
import org.eclipse.debug.core.model.IDebugElement
import org.eclipse.debug.core.model.IStackFrame
import org.eclipse.debug.core.model.IValue
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

	override void evaluateExpression(String expression, IDebugElement context, IWatchExpressionListener listener) {
		val stackFrame = context.getAdapter(IStackFrame) as IStackFrame

		// TODO evaluate expression
		val result = new IWatchExpressionResult {
			override IValue getValue() {
				return null
			}

			override boolean hasErrors() {
				return true
			}

			override String[] getErrorMessages() {
				return #["(Watch expressions not supported)"]
			}

			override String getExpressionText() {
				return ""
			}

			override DebugException getException() {
				return null
			}
		}
		listener.watchEvaluationFinished(result)
	}

}
