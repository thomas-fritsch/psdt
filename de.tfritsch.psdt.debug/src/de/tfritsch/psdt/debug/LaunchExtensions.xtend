package de.tfritsch.psdt.debug

import java.io.File
import java.text.DateFormat
import java.util.Date
import org.eclipse.core.runtime.CoreException
import org.eclipse.core.variables.VariablesPlugin
import org.eclipse.debug.core.DebugEvent
import org.eclipse.debug.core.DebugPlugin
import org.eclipse.debug.core.ILaunch
import org.eclipse.debug.core.ILaunchConfiguration
import org.eclipse.debug.core.ILaunchConfigurationWorkingCopy
import org.eclipse.debug.core.model.IProcess
import org.eclipse.debug.core.model.ITerminate
import org.eclipse.osgi.util.NLS

class LaunchExtensions {

	def static String getConsoleEncoding(ILaunch launch) {
		return launch.getAttribute(DebugPlugin.ATTR_CONSOLE_ENCODING)
	}

	def static void setProcessFactoryId(ILaunchConfigurationWorkingCopy configuration, String processFactoryId) {
		configuration.setAttribute(DebugPlugin.ATTR_PROCESS_FACTORY_ID, processFactoryId)
	}

	def static void setPath(IProcess process, String path) {
		process.setAttribute(DebugPlugin.ATTR_PATH, path)
	}

	def static String getLaunchTimestamp(ILaunch launch) {
		return launch.getAttribute(DebugPlugin.ATTR_LAUNCH_TIMESTAMP)
	}

	def static void setLaunchTimestamp(IProcess process, String timestamp) {
		process.setAttribute(DebugPlugin.ATTR_LAUNCH_TIMESTAMP, timestamp)
	}

	def static void setCommandLine(IProcess process, String cmdline) {
		process.setAttribute(IProcess.ATTR_CMDLINE, cmdline)
	}

	def static String getWorkingDirectory(ILaunchConfiguration configuration) {
		configuration.getAttribute(DebugPlugin.ATTR_WORKING_DIRECTORY, null as String)
	}

	def static void setWorkingDirectory(IProcess process, String workingDirectory) {
		process.setAttribute(DebugPlugin.ATTR_WORKING_DIRECTORY, workingDirectory)
	}

	def static String[] getEnvironment(ILaunchConfiguration configuration) throws CoreException {
		val launchManager = DebugPlugin.^default.launchManager
		return launchManager.getEnvironment(configuration)
	}

	def static void setEnvironment(IProcess process, String environment) {
		process.setAttribute(DebugPlugin.ATTR_ENVIRONMENT, environment)
	}

	def static void setProcessType(IProcess process, String processType) {
		process.setAttribute(IProcess.ATTR_PROCESS_TYPE, "PostScript")
	}

	// copied from org.eclipse.jdt.internal.launching.StandardVMRunner
	def static String renderProcessLabel(String[] commandLine) {
		val timeStamp = DateFormat.getDateTimeInstance(DateFormat.MEDIUM, DateFormat.MEDIUM).format(new Date)
		return NLS.bind("{0} ({1})", commandLine.get(0), timeStamp) //$NON-NLS-1$
	}

	def static String renderEnvironment(String[] env) {
		if (env == null)
			return null
		return env.join("\n") //$NON-NLS-1$
	}

	def static String performStringSubstitution(String expression) throws CoreException {
		val stringVariableManager = VariablesPlugin.^default.stringVariableManager
		return stringVariableManager.performStringSubstitution(expression)
	}

	def static void deleteOnTerminate(File file, ITerminate terminate) {
		DebugPlugin.^default.addDebugEventListener [ events |
			for (event : events) {
				if (event.source === terminate && event.kind === DebugEvent.TERMINATE) {
					file.delete
					DebugPlugin.^default.removeDebugEventListener(self)
				}
			}
		]
	}
}
