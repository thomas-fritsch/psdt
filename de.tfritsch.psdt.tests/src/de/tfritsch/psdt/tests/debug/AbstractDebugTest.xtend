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
package de.tfritsch.psdt.tests.debug

import de.tfritsch.psdt.tests.AbstractWorkbenchTestExtension
import org.eclipse.core.resources.IFile
import org.eclipse.core.resources.IProject
import org.eclipse.core.runtime.CoreException
import org.eclipse.debug.core.DebugException
import org.eclipse.debug.core.DebugPlugin
import org.eclipse.debug.core.ILaunchConfigurationWorkingCopy
import org.eclipse.debug.core.ILaunchManager
import org.eclipse.debug.core.model.IStackFrame
import org.eclipse.debug.core.model.ISuspendResume
import org.eclipse.debug.core.model.IThread
import org.eclipse.debug.ui.IDebugUIConstants
import org.eclipse.debug.ui.actions.IRunToLineTarget
import org.eclipse.debug.ui.actions.IToggleBreakpointsTarget
import org.eclipse.jface.text.BadLocationException
import org.eclipse.jface.text.TextSelection
import org.eclipse.ui.WorkbenchException
import org.eclipse.xtext.ui.editor.XtextEditor

import static org.eclipse.debug.ui.DebugUITools.getDebugContext
import static org.eclipse.xtext.junit4.ui.util.IResourcesSetupUtil.createProject

import static extension de.tfritsch.psdt.debug.LaunchExtensions.setProcessFactoryId
import static extension de.tfritsch.psdt.debug.PSLaunchExtensions.setGhostscriptArguments
import static extension de.tfritsch.psdt.debug.PSLaunchExtensions.setProgram

/**
 * @author Thomas Fritsch - initial API and implementation
 */
abstract class AbstractDebugTest extends AbstractWorkbenchTestExtension {

	protected extension ILaunchManager = DebugPlugin.^default.launchManager

	protected IProject project

	override setUp() throws Exception {
		project = createProject("test")
	}

	override tearDown() throws Exception {
		terminateAllLaunches
		deleteAllLaunchConfigurations
		super.tearDown
	}

	protected def void terminateAllLaunches() {
		for (launch : launches) {
			if (!launch.terminated) {
				try {
					launch.terminate
				} catch (DebugException e) {
				}
			}
		}
	}

	protected def void deleteAllLaunchConfigurations() {
		for (launchConfiguration : launchConfigurations) {
			try {
				launchConfiguration.delete
			} catch (CoreException e) {
			}
		}
	}

	protected def void showDebugPerspective() throws WorkbenchException {
		showPerspective(IDebugUIConstants.ID_DEBUG_PERSPECTIVE)
	}

	protected def ILaunchConfigurationWorkingCopy createLaunchConfiguration(IFile file) throws CoreException {
		val type = "de.tfritsch.psdt.debug.launchConfigurationType".launchConfigurationType
		type.newInstance(file.project, "Test") => [
			processFactoryId = "de.tfritsch.psdt.debug.processFactory"
			program = file.location.toOSString
			ghostscriptArguments = "-dBATCH"
		]
	}

	private def <T> T getCurrent(Class<T> adapterType) {
		debugContext?.getAdapter(adapterType)
	}

	protected def IStackFrame getCurrentStackFrame() {
		getCurrent(IStackFrame)
	}

	protected def IThread getCurrentThread() {
		getCurrent(IThread)
	}

	protected def void toogleBreakpoint(XtextEditor editor, int line) throws BadLocationException, CoreException {
		val document = editor.document
		val selection = new TextSelection(document, document.getLineOffset(line - 1), 0)
		val toggleBreakpointsTarget = editor.getAdapter(IToggleBreakpointsTarget) as IToggleBreakpointsTarget
		toggleBreakpointsTarget.toggleLineBreakpoints(editor, selection)
	}

	protected def void runToLine(XtextEditor editor, int line, ISuspendResume target) throws BadLocationException, CoreException {
		val document = editor.document
		val selection = new TextSelection(document, document.getLineOffset(line - 1), 0)
		val runToLineTarget = editor.getAdapter(IRunToLineTarget) as IRunToLineTarget
		runToLineTarget.runToLine(editor, selection, target)
	}
}
