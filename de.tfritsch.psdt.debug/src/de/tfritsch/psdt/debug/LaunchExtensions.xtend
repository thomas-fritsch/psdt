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
import org.eclipse.debug.core.model.ITerminate

class LaunchExtensions {

	def static String getConsoleEncoding(ILaunch launch) {
		return launch.getAttribute(DebugPlugin.ATTR_CONSOLE_ENCODING)
	}

	def static void setProcessFactoryId(ILaunchConfigurationWorkingCopy configuration, String processFactoryId) {
		configuration.setAttribute(DebugPlugin.ATTR_PROCESS_FACTORY_ID, processFactoryId)
	}

	def static String getLaunchTimestamp(ILaunch launch) {
		return launch.getAttribute(DebugPlugin.ATTR_LAUNCH_TIMESTAMP)
	}

	def static String getWorkingDirectory(ILaunchConfiguration configuration) {
		configuration.getAttribute(DebugPlugin.ATTR_WORKING_DIRECTORY, null as String)
	}

	def static String[] getEnvironment(ILaunchConfiguration configuration) throws CoreException {
		val launchManager = DebugPlugin.^default.launchManager
		return launchManager.getEnvironment(configuration)
	}

	// equivalent to org.eclipse.jdt.internal.launching.StandardVMRunner
	def static String renderProcessLabel(String[] commandLine) {
		val timeStamp = DateFormat.dateTimeInstance.format(new Date)
		return commandLine.get(0) + " (" + timeStamp + ")"
	}

	def static String renderWorkingDirectory(File workingDir) {
		return if (workingDir !== null)
			workingDir.absolutePath
		else
			System.getProperty("user.dir")
	}

	def static String renderEnvironment(String[] env) {
		return if (env !== null)
			env.join("\n") //$NON-NLS-1$
		else {
			System.getenv.entrySet.map[key + "=" + value].sort.join("\n")
		}
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
