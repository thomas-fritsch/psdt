package de.tfritsch.psdt.debug.model;

import org.eclipse.debug.core.DebugException;
import org.eclipse.debug.core.model.IDebugElement;
import org.eclipse.debug.core.model.IStackFrame;
import org.eclipse.debug.core.model.IValue;
import org.eclipse.debug.core.model.IWatchExpressionDelegate;
import org.eclipse.debug.core.model.IWatchExpressionListener;
import org.eclipse.debug.core.model.IWatchExpressionResult;

/**
 * A delegate for evaluating Postscript watch expressions.
 * 
 * Matches plugin.xml
 * extension[@point="org.eclipse.debug.core.watchExpressionDelegates"
 * ]/watchExpressionDelegate/@delgateClass
 */
public class PSWatchExpressionDelegate implements IWatchExpressionDelegate {

	public void evaluateExpression(String expression, IDebugElement context,
			IWatchExpressionListener listener) {
		IStackFrame stackFrame = (IStackFrame) context.getAdapter(IStackFrame.class);
		// TODO evaluate expression
		IWatchExpressionResult result = new IWatchExpressionResult() {
			public IValue getValue() {
				return null;
			}

			public boolean hasErrors() {
				return true;
			}

			public String[] getErrorMessages() {
				return new String[] { "(Watch expressions not supported)" };
			}

			public String getExpressionText() {
				return "";
			}

			public DebugException getException() {
				return null;
			}
		};
		listener.watchEvaluationFinished(result);
	}

}