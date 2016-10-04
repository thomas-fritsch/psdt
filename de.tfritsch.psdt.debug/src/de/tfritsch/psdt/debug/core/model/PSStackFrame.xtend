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

import java.io.File
import org.eclipse.debug.core.DebugException
import org.eclipse.debug.core.model.IRegisterGroup
import org.eclipse.debug.core.model.IStackFrame
import org.eclipse.debug.core.model.IThread
import org.eclipse.debug.core.model.IVariable

/**
 * PostScript VM stack frame. Since there is only one single
 * stack frame in the PostScript VM most methods of this
 * class simply delegate to {@link PSThread}.
 * 
 * @author Thomas Fritsch - initial API and implementation
 */
class PSStackFrame extends PSDebugElement implements IStackFrame {

	PSThread thread

	/**
	 * Constructs a stack frame in the given thread.
	 * 
	 * @param thread
	 *            thread containing this stack frame
	 */
	new(PSThread thread) {
		super(thread.PSDebugTarget)
		this.thread = thread
	}

	@SuppressWarnings("rawtypes")
	override getAdapter(Class adapterType) {
		switch (adapterType) {
			case IThread:
				thread
			default:
				super.getAdapter(adapterType)
		}
	}

	def getSourceName() {
		PSDebugTarget.sourceName
	}

	override getCharStart() {
		PSDebugTarget.charStart
	}

	override getCharEnd() {
		PSDebugTarget.charEnd
	}

	override getLineNumber() {
		PSDebugTarget.lineNumber
	}

	override getName() {
		val s = sourceName
		s.substring(s.lastIndexOf(File.separatorChar) + 1)
	}

	override getRegisterGroups() throws DebugException {
		#[]
	}

	override getThread() {
		thread
	}

	override getVariables() throws DebugException {
		debug("GUI -> getVariables") //$NON-NLS-1$
		if(suspended) PSDebugTarget.variables else #[]
	}

	override hasRegisterGroups() throws DebugException {
		false
	}

	override hasVariables() throws DebugException {
		debug("GUI -> PSStackFrame.hasVariables") //$NON-NLS-1$
		suspended
	}

	override canStepInto() {
		thread.canStepInto
	}

	override canStepOver() {
		thread.canStepOver
	}

	override canStepReturn() {
		thread.canStepReturn
	}

	override isStepping() {
		thread.stepping
	}

	override stepInto() throws DebugException {
		thread.stepInto
	}

	override void stepOver() throws DebugException {
		thread.stepOver
	}

	override stepReturn() throws DebugException {
		thread.stepReturn
	}

	override canResume() {
		thread.canResume
	}

	override canSuspend() {
		thread.canSuspend
	}

	override isSuspended() {
		thread.suspended
	}

	override resume() throws DebugException {
		thread.resume
	}

	override suspend() throws DebugException {
		thread.suspend
	}

	override canTerminate() {
		thread.canTerminate
	}

	override isTerminated() {
		thread.terminated
	}

	override terminate() throws DebugException {
		thread.terminate
	}
}
