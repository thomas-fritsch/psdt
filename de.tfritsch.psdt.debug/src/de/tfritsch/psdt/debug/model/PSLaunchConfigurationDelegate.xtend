package de.tfritsch.psdt.debug.model

import de.tfritsch.psdt.debug.PSPlugin
import java.io.File
import java.io.FileInputStream
import java.io.FileWriter
import java.io.IOException
import org.eclipse.core.runtime.CoreException
import org.eclipse.core.runtime.IPath
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.core.runtime.Path
import org.eclipse.debug.core.ILaunch
import org.eclipse.debug.core.ILaunchConfiguration
import org.eclipse.debug.core.ILaunchManager
import org.eclipse.debug.core.model.LaunchConfigurationDelegate
import org.eclipse.osgi.util.NLS

import static extension de.tfritsch.psdt.debug.LaunchExtensions.*
import static extension de.tfritsch.psdt.debug.PSLaunchExtensions.*
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
			cmdLineList += PSPlugin.getFile("psdebug.ps").toOSString //$NON-NLS-1$
			sourceMapping = psFile.createSourceMapping(monitor)
			if (sourceMapping === null) {
				return
			}
			instrumentedFile = sourceMapping.createInstrumentedFile(monitor)
			if (instrumentedFile === null) {
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
		val process = launch.newProcess(p, cmdLine.renderProcessLabel) => [
			// things for display in "Process Properties"
			path = cmdLine.get(0)
			launchTimestamp = launch.launchTimestamp
			commandLine = cmdLine.renderArguments(null)
			workingDirectory = workingDir.renderWorkingDirectory
			environment = env.renderEnvironment
			processType = "PostScript" //$NON-NLS-1$
		]
		if (mode == ILaunchManager.DEBUG_MODE) {
			instrumentedFile.deleteOnTerminate(process)
			val target = new PSDebugTarget(process, sourceMapping)
			launch.addDebugTarget(target)
		}
	}

	def private PSSourceMapping createSourceMapping(String psFile, IProgressMonitor monitor) throws CoreException {
		val sourceMapping = new PSSourceMapping
		try {
			val input = new PSInputStream(new FileInputStream(psFile))
			var token = input.readToken
			while (token != null) {
				if (monitor.canceled) {
					input.close
					return null
				}
				sourceMapping.add(token)
				token = input.readToken
			}
			input.close
		} catch (IOException e) {
			PSPlugin.abort(e.toString, e)
		}
		return sourceMapping
	}

	def private File createInstrumentedFile(PSSourceMapping sourceMapping, IProgressMonitor monitor) throws CoreException {
		try {
			val file = File.createTempFile("psdt", ".ps");
			val writer = new FileWriter(file)
			writer.write("%!PS\n")
			writer.write("@@breakpoints 0 null put\n")
			val store = PSPlugin.^default.preferenceStore
			writer.write(
				!store.showSystemdict + " " + !store.showGlobaldict + " " + !store.showUserdict + " @@stathide\n")
			for (i : 0 ..< sourceMapping.size) {
				if (monitor.canceled) {
					writer.close
					file.delete
					return null
				}
				val string = sourceMapping.getString(i)
				if (string != "}")  // no stepping point just before }
					writer.write(i + " @@$ ")
				writer.write(string + "\n")
			}
			writer.close
			return file
		} catch (IOException e) {
			PSPlugin.abort(e.message, e)
			return null
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
}
