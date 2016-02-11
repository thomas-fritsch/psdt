package de.tfritsch.psdt.debug.core.launch

import de.tfritsch.psdt.debug.PSPlugin
import de.tfritsch.psdt.debug.core.model.PSDebugTarget
import java.io.File
import java.net.URL
import javax.inject.Inject
import org.eclipse.core.runtime.CoreException
import org.eclipse.core.runtime.IPath
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.core.runtime.Path
import org.eclipse.debug.core.ILaunch
import org.eclipse.debug.core.ILaunchConfiguration
import org.eclipse.debug.core.ILaunchManager
import org.eclipse.debug.core.model.IProcess
import org.eclipse.debug.core.model.LaunchConfigurationDelegate
import org.eclipse.osgi.util.NLS

import static extension de.tfritsch.psdt.debug.LaunchExtensions.*
import static extension de.tfritsch.psdt.debug.PSLaunchExtensions.*
import static extension org.eclipse.core.runtime.FileLocator.*
import static extension org.eclipse.debug.core.DebugPlugin.*

/**
 * Launches PostScript program on Ghostscript interpreter
 * 
 * Matches plugin.xml
 * extension[@point="org.eclipse.debug.core.launchConfigurationTypes"]/launchConfigurationType/@delegate
 */
class PSLaunchConfigurationDelegate extends LaunchConfigurationDelegate {

	/**
     * Unique identifier for the PostScript launch configuration type (value 
     * <code>{@value}</code>).
     * Matches plugin.xml
     * extension[@point="org.eclipse.debug.core.launchConfigurationTypes"]/launchConfigurationType/@id
     */
	public static val ID = PSPlugin.ID + ".launchConfigurationType" //$NON-NLS-1$

	new() {
		PSPlugin.injector.injectMembers(this) // TODO remove this hack
	}

	@Inject
	extension DebugExtensions

	override void launch(ILaunchConfiguration cfg, String mode, ILaunch launch, IProgressMonitor monitor) throws CoreException {
		if (monitor.canceled) {
			return
		}
		val psFile = cfg.verifyPSFile
		var PSSourceMapping sourceMapping = null
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
			PSPlugin.abort(NLS.bind("invalid launch mode \"{0}\"", mode), null)
		}
		val cmdLine = cmdLineList as String[]
		val workingDir = cfg.verifyWorkingDirectory
		val env = cfg.environment
		val p = cmdLine.exec(workingDir, env)
		val process = launch.newProcess(p, cmdLine.renderProcessLabel, #{IProcess.ATTR_PROCESS_TYPE -> "PostScript"}) => [
			// things for display in "Process Properties"
			path = cmdLine.get(0)
			launchTimestamp = launch.launchTimestamp
			commandLine = cmdLine.renderArguments(null)
			workingDirectory = workingDir.renderWorkingDirectory
			environment = env.renderEnvironment
		]
		if (mode == ILaunchManager.DEBUG_MODE) {
			instrumentedFile.deleteOnTerminate(process)
			val target = new PSDebugTarget(process, sourceMapping)
			launch.addDebugTarget(target)
		}
	}

	def protected String verifyPSFile(ILaunchConfiguration configuration) throws CoreException {
		var String psFile = configuration.program
		if (psFile == null) {
			PSPlugin.abort("PostScript program not specified.", null)
		}
		psFile = psFile.performStringSubstitution
		if (!(new File(psFile)).exists) {
			PSPlugin.abort(NLS.bind("PostScript program \"{0}\" not existing.", psFile), null)
		}
		return psFile
	}

	def protected String verifyInterpreter() throws CoreException {
		val exe = PSPlugin.^default.preferenceStore.interpreter
		if (exe.nullOrEmpty) {
			PSPlugin.abort("Interpreter not specified", null)
		}
		return exe
	}

	// copied from org.eclipse.jdt.launching.AbstractJavaLaunchConfigurationDelegate
	def protected File verifyWorkingDirectory(ILaunchConfiguration configuration) throws CoreException {
		val path = configuration.workingDirectoryPath
		if (path == null)
			return null
		return new File(path.toOSString)
	}

	// copied from org.eclipse.jdt.launching.AbstractJavaLaunchConfigurationDelegate
	def protected IPath getWorkingDirectoryPath(ILaunchConfiguration config) throws CoreException {
		val path = config.workingDirectory
		if (path == null)
			return null
		return new Path(path.performStringSubstitution)
	}

	def private File getPSDebug() throws CoreException {
		try {
			var url = new URL("platform:/plugin/" + PSPlugin.ID + "/psdebug.ps")
			return new File(url.toFileURL.toURI).canonicalFile
		} catch (Exception e) {
			PSPlugin.abort(e.message, e)
			return null
		}
	}
}
