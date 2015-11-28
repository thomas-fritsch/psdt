package de.tfritsch.psdt.debug.model

import de.tfritsch.psdt.debug.IPSConstants
import de.tfritsch.psdt.debug.PSPlugin
import java.io.File
import java.io.FileInputStream
import java.io.FileWriter
import java.io.IOException
import java.text.DateFormat
import java.util.Date
import org.eclipse.core.runtime.CoreException
import org.eclipse.core.runtime.IPath
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.core.runtime.NullProgressMonitor
import org.eclipse.core.runtime.Path
import org.eclipse.core.variables.IStringVariableManager
import org.eclipse.core.variables.VariablesPlugin
import org.eclipse.debug.core.DebugPlugin
import org.eclipse.debug.core.ILaunch
import org.eclipse.debug.core.ILaunchConfiguration
import org.eclipse.debug.core.ILaunchManager
import org.eclipse.debug.core.model.IProcess
import org.eclipse.debug.core.model.LaunchConfigurationDelegate
import org.eclipse.osgi.util.NLS

/**
 * Launches PostScript program on Ghostscript interpreter
 * 
 * Matches plugin.xml
 * extension[@point="org.eclipse.debug.core.launchConfigurationTypes"]/launchConfigurationType/@delegate
 */
public class PSLaunchConfigurationDelegate extends LaunchConfigurationDelegate {

	/**
     * Unique identifier for the PostScript launch configuration type (value 
     * <code>{@value}</code>).
     * Matches plugin.xml
     * extension[@point="org.eclipse.debug.core.launchConfigurationTypes"]/launchConfigurationType/@id
     */
	public static val ID = PSPlugin.ID + ".launchConfigurationType" //$NON-NLS-1$

	ILaunchManager launchManager = DebugPlugin.^default.launchManager

	IStringVariableManager stringVariableManager = VariablesPlugin.^default.stringVariableManager

	override void launch(ILaunchConfiguration cfg, String mode, ILaunch launch, IProgressMonitor monitor) throws CoreException {
		val psFile = cfg.verifyPSFile
		var PSSourceMapping sourceMapping = null
		var File instrumentedFile = null
		val cmdLineList = <String>newArrayList(verifyInterpreter)
		cmdLineList += DebugPlugin.parseArguments(cfg.getAttribute(IPSConstants.ATTR_GS_ARGUMENTS, "")) //$NON-NLS-1$
		if (mode == ILaunchManager.RUN_MODE) {
			cmdLineList += psFile
		} else if (mode == ILaunchManager.DEBUG_MODE) {
			cmdLineList += PSPlugin.getFile("psdebug.ps").toOSString //$NON-NLS-1$
			sourceMapping = createSourceMapping(psFile)
			instrumentedFile = createInstrumentedFile(sourceMapping)
			cmdLineList += instrumentedFile.absolutePath
		} else {
			PSPlugin.abort(NLS.bind("invalid launch mode \"{0}\"", mode), null)
		}
		val cmdLine = cmdLineList as String[]
		val workingDir = cfg.verifyWorkingDirectory
		val env = launchManager.getEnvironment(cfg)
		val p = DebugPlugin.exec(cmdLine, workingDir, env)
		val process = DebugPlugin.newProcess(launch, p, renderProcessLabel(cmdLine)) => [
			setAttribute(DebugPlugin.ATTR_PATH, cmdLine.get(0))
			setAttribute(DebugPlugin.ATTR_LAUNCH_TIMESTAMP, launch.getAttribute(DebugPlugin.ATTR_LAUNCH_TIMESTAMP))
			setAttribute(IProcess.ATTR_CMDLINE, DebugPlugin.renderArguments(cmdLine, null))
			setAttribute(DebugPlugin.ATTR_WORKING_DIRECTORY, workingDir?.absolutePath)
			setAttribute(DebugPlugin.ATTR_ENVIRONMENT, renderEnvironment(env))
			setAttribute(IProcess.ATTR_PROCESS_TYPE, "PostScript") //$NON-NLS-1$
		]
		if (mode == ILaunchManager.DEBUG_MODE) {
			val operation = new DeleteFileOperation(instrumentedFile, process)
			operation.run(new NullProgressMonitor)
			val target = new PSDebugTarget(process, psFile, sourceMapping)
			launch.addDebugTarget(target)
		}
	}

	// copied from org.eclipse.jdt.internal.launching.StandardVMRunner
	def private static String renderProcessLabel(String[] commandLine) {
		val timeStamp = DateFormat.getDateTimeInstance(DateFormat.MEDIUM, DateFormat.MEDIUM).format(new Date)
		return NLS.bind("{0} ({1})", commandLine.get(0), timeStamp) //$NON-NLS-1$
	}

	def private static String renderEnvironment(String[] env) {
		if (env == null)
			return null
		return env.join("\n") //$NON-NLS-1$
	}

	def private PSSourceMapping createSourceMapping(String psFile) throws CoreException {
		val sourceMapping = new PSSourceMapping
		try {
			val input = new PSInputStream(new FileInputStream(psFile))
			var token = input.readToken
			while (token != null) {
				sourceMapping.add(token)
				token = input.readToken
			}
			input.close
		} catch (IOException e) {
			PSPlugin.abort(e.toString, e)
		}
		return sourceMapping
	}

	def private File createInstrumentedFile(PSSourceMapping sourceMapping) throws CoreException {
		try {
			val file = File.createTempFile("tmp", ".ps");
			val writer = new FileWriter(file)
			writer.write("@@breakpoints 0 null put\n")
			writer.write("true false false @@stathide\n")
			for (i : 0 ..< sourceMapping.size) {
				val string = sourceMapping.getString(i)
				writer.write(i + " @@$ " + string + "\n")
			}
			writer.close
			return file
		} catch (IOException e) {
			PSPlugin.abort(e.message, e)
			return null
		}
	}

	def protected String verifyPSFile(ILaunchConfiguration configuration) throws CoreException {
		val String psFile = configuration.getAttribute(IPSConstants.ATTR_PROGRAM, null as String)
		if (psFile == null) {
			PSPlugin.abort("PostScript program not specified.", null)
		}
		if (!(new File(psFile)).exists) {
			PSPlugin.abort(NLS.bind("PostScript program \"{0}\" not existing.", psFile), null)
		}
		return psFile
	}

	def protected String verifyInterpreter() throws CoreException {
		val exe = PSPlugin.^default.preferenceStore.getString(IPSConstants.PREF_INTERPRETER)
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
		var path = config.getAttribute(DebugPlugin.ATTR_WORKING_DIRECTORY, null as String)
		if (path == null)
			return null
		path = stringVariableManager.performStringSubstitution(path)
		return new Path(path)
	}
}
