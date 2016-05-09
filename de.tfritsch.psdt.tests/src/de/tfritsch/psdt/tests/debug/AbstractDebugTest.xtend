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
import org.eclipse.core.runtime.CoreException
import org.eclipse.core.runtime.Platform
import org.eclipse.debug.core.DebugException
import org.eclipse.debug.core.DebugPlugin
import org.eclipse.debug.core.ILaunchConfigurationWorkingCopy
import org.eclipse.debug.core.ILaunchManager

import static extension de.tfritsch.psdt.debug.LaunchExtensions.*
import static extension de.tfritsch.psdt.debug.PSLaunchExtensions.*
import org.eclipse.debug.ui.IDebugUIConstants

/**
 * @author Thomas Fritsch - initial API and implementation
 */
abstract class AbstractDebugTest extends AbstractWorkbenchTestExtension {

	extension ILaunchManager = DebugPlugin.^default.launchManager

	override setUp() throws Exception {
		super.setUp
		Platform.getPlugin("de.tfritsch.psdt.debug") // make sure our plugin is activated
	}

	override tearDown() throws Exception {
		terminateAllLaunches
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

	protected def void showDebugPerspective() {
		showPerspective(IDebugUIConstants.ID_DEBUG_PERSPECTIVE)
	}

	protected def ILaunchConfigurationWorkingCopy createLaunchConfiguration(IFile file) throws CoreException {
		val type = "de.tfritsch.psdt.debug.launchConfigurationType".launchConfigurationType
		return type.newInstance(file.project, "Test") => [
			launchInBackground = false
			processFactoryId = "de.tfritsch.psdt.debug.processFactory"
			program = file.location.toOSString
			ghostscriptArguments = "-dBATCH"
		]
	}

}
