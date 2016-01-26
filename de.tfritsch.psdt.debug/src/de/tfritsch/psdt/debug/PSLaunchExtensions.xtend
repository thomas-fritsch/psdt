package de.tfritsch.psdt.debug

import org.eclipse.debug.core.ILaunchConfiguration
import org.eclipse.debug.core.ILaunchConfigurationWorkingCopy
import org.eclipse.jface.preference.IPreferenceStore

class PSLaunchExtensions {

	def static String getInterpreter(IPreferenceStore preferenceStore) {
		return preferenceStore.getString(IPSConstants.PREF_INTERPRETER)
	}

	def static boolean isMessageBoxOnPrompt(IPreferenceStore preferenceStore) {
		return preferenceStore.getBoolean(IPSConstants.PREF_MESSAGE_BOX_ON_PROMPT)
	}

	def static boolean isShowSystemdict(IPreferenceStore preferenceStore) {
		return preferenceStore.getBoolean(IPSConstants.PREF_SHOW_SYSTEMDICT)
	}

	def static boolean isShowGlobaldict(IPreferenceStore preferenceStore) {
		return preferenceStore.getBoolean(IPSConstants.PREF_SHOW_GLOBALDICT)
	}

	def static boolean isShowUserdict(IPreferenceStore preferenceStore) {
		return preferenceStore.getBoolean(IPSConstants.PREF_SHOW_USERDICT)
	}

	def static String getProgram(ILaunchConfiguration configuration) {
		return configuration.getAttribute(IPSConstants.ATTR_PROGRAM, null as String)
	}

	def static void setProgram(ILaunchConfigurationWorkingCopy configuration, String program) {
		configuration.setAttribute(IPSConstants.ATTR_PROGRAM, program)
	}

	def static void setGhostscriptArguments(ILaunchConfigurationWorkingCopy configuration, String arguments) {
		configuration.setAttribute(IPSConstants.ATTR_GS_ARGUMENTS, arguments)
	}

	def static String getGhostscriptArguments(ILaunchConfiguration configuration) {
		return configuration.getAttribute(IPSConstants.ATTR_GS_ARGUMENTS, null as String)
	}

	def static boolean isBreakOnFirstToken(ILaunchConfiguration configuration) {
		return configuration.getAttribute(IPSConstants.ATTR_BREAK_ON_FIRST_TOKEN, false)
	}

	def static void setBreakOnFirstToken(ILaunchConfigurationWorkingCopy configuration, boolean breakOnFirstToken) {
		configuration.setAttribute(IPSConstants.ATTR_BREAK_ON_FIRST_TOKEN, breakOnFirstToken)
	}
}
