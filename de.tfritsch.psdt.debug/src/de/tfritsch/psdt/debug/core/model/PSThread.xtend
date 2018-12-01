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

import org.eclipse.debug.core.DebugException
import org.eclipse.debug.core.model.IStackFrame
import org.eclipse.debug.core.model.IThread

/**
 * A PostScript VM thread.  Since there is only one single
 * thread in the PostScript VM most methods of this
 * class simply delegate to {@link PSDebugTarget}.
 * 
 * @author Thomas Fritsch - initial API and implementation
 */
class PSThread extends PSDebugElement implements IThread {

	IStackFrame stackFrame

	/**
	 * Constructs a new thread for the given target.
	 * 
	 * @param target
	 *            debug target containing this thread
	 */
	new(PSDebugTarget target) {
		super(target)
		stackFrame = new PSStackFrame(this)
	}

	override <T> getAdapter(Class<T> adapter) {
		switch (adapter) {
			case IStackFrame:
				topStackFrame as T
			default:
				super.getAdapter(adapter)
		}
	}

	override getBreakpoints() {
		PSDebugTarget.breakpoints
	}

	override getName() {
		"main" //$NON-NLS-1$
	}

	override getPriority() {
		0
	}

	override getStackFrames() {
		if(suspended) #[stackFrame] else #[]
	}

	override getTopStackFrame() {
		if(suspended) stackFrame else null
	}

	override hasStackFrames() throws DebugException {
		suspended
	}

	override canStepInto() {
		suspended && !stepping
	}

	override canStepOver() {
		suspended && !stepping
	}

	override canStepReturn() {
		suspended && !stepping
	}

	override isStepping() {
		PSDebugTarget.stepping
	}

	override stepInto() throws DebugException {
		PSDebugTarget.stepInto
	}

	override stepOver() throws DebugException {
		PSDebugTarget.stepOver
	}

	override stepReturn() throws DebugException {
		PSDebugTarget.stepReturn
	}

	override canResume() {
		debugTarget.canResume
	}

	override canSuspend() {
		debugTarget.canSuspend
	}

	override isSuspended() {
		debugTarget.suspended
	}

	override resume() throws DebugException {
		debugTarget.resume
	}

	override suspend() throws DebugException {
		debugTarget.suspend
	}

	override canTerminate() {
		debugTarget.canTerminate
	}

	override isTerminated() {
		debugTarget.terminated
	}

	override terminate() throws DebugException {
		debugTarget.terminate
	}
}
