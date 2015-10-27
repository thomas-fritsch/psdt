package de.tfritsch.psdt.debug.model

import de.tfritsch.psdt.debug.IPSConstants
import de.tfritsch.psdt.debug.PSPlugin
import java.io.File
import java.io.FileInputStream
import java.io.IOException
import java.text.DateFormat
import java.util.Date
import java.util.List
import org.eclipse.core.runtime.CoreException
import org.eclipse.core.runtime.IPath
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.core.runtime.IStatus
import org.eclipse.core.runtime.Path
import org.eclipse.core.runtime.Status
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
		val cmdLineList = <String>newArrayList(verifyInterpreter)
		cmdLineList += DebugPlugin.parseArguments(cfg.getAttribute(IPSConstants.ATTR_GS_ARGUMENTS, "")) //$NON-NLS-1$
		if (mode == ILaunchManager.RUN_MODE) {
			cmdLineList += psFile
		} else if (mode == ILaunchManager.DEBUG_MODE) {
			cmdLineList += PSPlugin.getFile("psdebug.ps").toOSString //$NON-NLS-1$
			cmdLineList += "-c" //$NON-NLS-1$
			cmdLineList += "(%stdin) (r) file cvx exec" //$NON-NLS-1$
		} else {
			abort(NLS.bind("invalid launch mode \"{0}\"", mode), null)
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
			val target = new PSDebugTarget(process, psFile, createTokens(psFile))
			launch.addDebugTarget(target)
		}
	}

	def private void abort(String message, Throwable e) throws CoreException {
		val status = new Status(IStatus.ERROR, PSPlugin.ID, message, e)
		throw new CoreException(status)
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

	def private List<PSToken> createTokens(String psFile) throws CoreException {
		val tokens = <PSToken>newArrayList
		try {
			val input = new PSInputStream(new FileInputStream(psFile))
			var token = input.readToken
			while (token != null) {
				tokens += token
				token = input.readToken
			}
			input.close
		} catch (IOException e) {
			abort(e.toString, e)
		}
		return tokens
	}

	def protected String verifyPSFile(ILaunchConfiguration configuration) throws CoreException {
		val String psFile = configuration.getAttribute(IPSConstants.ATTR_PROGRAM, null as String)
		if (psFile == null) {
			abort("PostScript program not specified.", null)
		}
		if (!(new File(psFile)).exists) {
			abort(NLS.bind("PostScript program \"{0}\" not existing.", psFile), null)
		}
		return psFile
	}

	def protected String verifyInterpreter() throws CoreException {
		val exe = PSPlugin.^default.preferenceStore.getString(IPSConstants.PREF_INTERPRETER)
		if (exe.nullOrEmpty) {
			abort("Interpreter not specified", null)
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