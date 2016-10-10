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
package de.tfritsch.psdt.debug.core.launch

import com.google.inject.Provider
import de.tfritsch.psdt.debug.Debug
import de.tfritsch.psdt.debug.PSPlugin
import de.tfritsch.psdt.debug.core.model.PSDebugTarget
import java.io.File
import java.net.URL
import java.util.List
import javax.inject.Inject
import org.eclipse.core.runtime.CoreException
import org.eclipse.core.runtime.IPath
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.core.runtime.Path
import org.eclipse.core.variables.IStringVariableManager
import org.eclipse.debug.core.ILaunch
import org.eclipse.debug.core.ILaunchConfiguration
import org.eclipse.debug.core.ILaunchManager
import org.eclipse.debug.core.model.IProcess
import org.eclipse.debug.core.model.LaunchConfigurationDelegate
import org.eclipse.jface.preference.IPreferenceStore
import org.eclipse.osgi.util.NLS

import static extension de.tfritsch.psdt.debug.LaunchExtensions.*
import static extension de.tfritsch.psdt.debug.PSLaunchExtensions.*
import static extension de.tfritsch.psdt.debug.PSPlugin.*
import static extension org.eclipse.core.runtime.FileLocator.*
import static extension org.eclipse.debug.core.DebugPlugin.*

/**
 * Launches PostScript program on Ghostscript interpreter
 * 
 * Matches plugin.xml
 * extension[@point="org.eclipse.debug.core.launchConfigurationTypes"]/launchConfigurationType/@delegate
 * 
 * @author Thomas Fritsch - initial API and implementation
 */
class PSLaunchConfigurationDelegate extends LaunchConfigurationDelegate {

	/**
     * Unique identifier for the PostScript launch configuration type (value 
     * <code>{@value}</code>).
     * Matches plugin.xml
     * extension[@point="org.eclipse.debug.core.launchConfigurationTypes"]/launchConfigurationType/@id
     */
	public static val ID = PSPlugin.ID + ".launchConfigurationType" //$NON-NLS-1$

	@Inject extension DebugExtensions
	@Inject extension IStringVariableManager
	@Inject @Debug IPreferenceStore preferenceStore
	@Inject Provider<PSDebugTarget> debugTargetProvider

	override launch(ILaunchConfiguration cfg, String mode, ILaunch launch, IProgressMonitor monitor) throws CoreException {
		if (monitor.canceled) {
			return
		}
		val psFile = cfg.verifyPSFile
		var List<PSToken> sourceMapping = null
		var File instrumentedFile = null
		val cmdLineList = <String>newArrayList(verifyInterpreter)
		cmdLineList += cfg.ghostscriptArguments.parseArguments
		if (mode == ILaunchManager.RUN_MODE) {
			cmdLineList += psFile
		} else if (mode == ILaunchManager.DEBUG_MODE) {
			cmdLineList += PSDebug.absolutePath
			sourceMapping = psFile.createSourceMapping
			if (monitor.canceled) {
				return
			}
			instrumentedFile = sourceMapping.createInstrumentedFile
			if (monitor.canceled) {
				instrumentedFile.delete
				return
			}
			cmdLineList += instrumentedFile.absolutePath
		} else {
			throw NLS.bind("invalid launch mode \"{0}\"", mode).toCoreException
		}
		val cmdLine = cmdLineList as String[]
		val workingDir = cfg.verifyWorkingDirectory
		val env = cfg.environment
		val p = cmdLine.exec(workingDir, env)
		val process = launch.newProcess(p, cmdLine.renderProcessLabel,
			#{
				IProcess.ATTR_PROCESS_TYPE -> "PostScript",
				// things for display in "Process Properties"
				ATTR_PATH -> cmdLine.get(0),
				ATTR_LAUNCH_TIMESTAMP -> launch.launchTimestamp,
				IProcess.ATTR_CMDLINE -> cmdLine.renderArguments(null),
				ATTR_WORKING_DIRECTORY -> workingDir.renderWorkingDirectory,
				ATTR_ENVIRONMENT -> env.renderEnvironment
			})
		if (mode == ILaunchManager.DEBUG_MODE) {
			instrumentedFile.deleteOnTerminate(process)
			val target = debugTargetProvider.get
			target.init(process, sourceMapping)
			launch.addDebugTarget(target)
		}
	}

	def protected String verifyPSFile(ILaunchConfiguration configuration) throws CoreException {
		var String psFile = configuration.program
		if (psFile == null) {
			throw "PostScript program not specified.".toCoreException
		}
		psFile = psFile.performStringSubstitution
		if (!(new File(psFile)).exists) {
			throw NLS.bind("PostScript program \"{0}\" not existing.", psFile).toCoreException
		}
		psFile
	}

	def protected String verifyInterpreter() throws CoreException {
		val exe = preferenceStore.interpreter
		if (exe.nullOrEmpty) {
			throw "Interpreter not specified".toCoreException
		}
		exe
	}

	// copied from org.eclipse.jdt.launching.AbstractJavaLaunchConfigurationDelegate
	def protected File verifyWorkingDirectory(ILaunchConfiguration configuration) throws CoreException {
		val path = configuration.workingDirectoryPath
		if (path == null)
			return null
		new File(path.toOSString)
	}

	// copied from org.eclipse.jdt.launching.AbstractJavaLaunchConfigurationDelegate
	def protected IPath getWorkingDirectoryPath(ILaunchConfiguration config) throws CoreException {
		val path = config.workingDirectory
		if (path == null)
			return null
		new Path(path.performStringSubstitution)
	}

	def private File getPSDebug() throws CoreException {
		try {
			var url = new URL("platform:/plugin/" + PSPlugin.ID + "/psdebug.ps")
			new File(url.toFileURL.path).canonicalFile
		} catch (Exception e) {
			throw e.toCoreException
		}
	}
}
