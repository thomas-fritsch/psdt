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

	def String getSourceName() {
		return PSDebugTarget.sourceName
	}

	override int getCharStart() {
		return PSDebugTarget.charStart
	}

	override int getCharEnd() {
		return PSDebugTarget.charEnd
	}

	override int getLineNumber() {
		return PSDebugTarget.lineNumber
	}

	override String getName() {
		val s = sourceName
		return s.substring(s.lastIndexOf(File.separatorChar) + 1)
	}

	override IRegisterGroup[] getRegisterGroups() throws DebugException {
		return #[]
	}

	override IThread getThread() {
		return thread
	}

	override IVariable[] getVariables() throws DebugException {
		debug("GUI -> getVariables") //$NON-NLS-1$
		return if(suspended) PSDebugTarget.variables else #[]
	}

	override boolean hasRegisterGroups() throws DebugException {
		return false
	}

	override boolean hasVariables() throws DebugException {
		debug("GUI -> PSStackFrame.hasVariables") //$NON-NLS-1$
		return suspended
	}

	override boolean canStepInto() {
		return thread.canStepInto
	}

	override boolean canStepOver() {
		return thread.canStepOver
	}

	override boolean canStepReturn() {
		return thread.canStepReturn
	}

	override boolean isStepping() {
		return thread.stepping
	}

	override void stepInto() throws DebugException {
		thread.stepInto
	}

	override void stepOver() throws DebugException {
		thread.stepOver
	}

	override void stepReturn() throws DebugException {
		thread.stepReturn
	}

	override boolean canResume() {
		return thread.canResume
	}

	override boolean canSuspend() {
		return thread.canSuspend
	}

	override boolean isSuspended() {
		return thread.suspended
	}

	override void resume() throws DebugException {
		thread.resume
	}

	override void suspend() throws DebugException {
		thread.suspend
	}

	override boolean canTerminate() {
		return thread.canTerminate
	}

	override boolean isTerminated() {
		return thread.terminated
	}

	override void terminate() throws DebugException {
		thread.terminate
	}
}
