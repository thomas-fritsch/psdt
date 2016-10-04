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
package de.tfritsch.psdt.debug

import org.eclipse.debug.core.ILaunchConfiguration
import org.eclipse.debug.core.ILaunchConfigurationWorkingCopy
import org.eclipse.jface.preference.IPreferenceStore

/**
 * @author Thomas Fritsch - initial API and implementation
 */
class PSLaunchExtensions {

	def static String getInterpreter(IPreferenceStore preferenceStore) {
		preferenceStore.getString(IPSConstants.PREF_INTERPRETER)
	}

	def static String getDefaultGhostscriptArguments(IPreferenceStore preferenceStore) {
		preferenceStore.getString(IPSConstants.PREF_DEFAULT_GS_ARGUMENTS)
	}

	def static boolean isMessageBoxOnPrompt(IPreferenceStore preferenceStore) {
		preferenceStore.getBoolean(IPSConstants.PREF_MESSAGE_BOX_ON_PROMPT)
	}

	def static boolean isShowSystemdict(IPreferenceStore preferenceStore) {
		preferenceStore.getBoolean(IPSConstants.PREF_SHOW_SYSTEMDICT)
	}

	def static boolean isShowGlobaldict(IPreferenceStore preferenceStore) {
		preferenceStore.getBoolean(IPSConstants.PREF_SHOW_GLOBALDICT)
	}

	def static boolean isShowUserdict(IPreferenceStore preferenceStore) {
		preferenceStore.getBoolean(IPSConstants.PREF_SHOW_USERDICT)
	}

	def static String getProgram(ILaunchConfiguration configuration) {
		configuration.getAttribute(IPSConstants.ATTR_PROGRAM, null as String)
	}

	def static void setProgram(ILaunchConfigurationWorkingCopy configuration, String program) {
		configuration.setAttribute(IPSConstants.ATTR_PROGRAM, program)
	}

	def static void setGhostscriptArguments(ILaunchConfigurationWorkingCopy configuration, String arguments) {
		configuration.setAttribute(IPSConstants.ATTR_GS_ARGUMENTS, arguments)
	}

	def static String getGhostscriptArguments(ILaunchConfiguration configuration) {
		configuration.getAttribute(IPSConstants.ATTR_GS_ARGUMENTS, null as String)
	}

	def static boolean isBreakOnFirstToken(ILaunchConfiguration configuration) {
		configuration.getAttribute(IPSConstants.ATTR_BREAK_ON_FIRST_TOKEN, false)
	}

	def static void setBreakOnFirstToken(ILaunchConfigurationWorkingCopy configuration, boolean breakOnFirstToken) {
		configuration.setAttribute(IPSConstants.ATTR_BREAK_ON_FIRST_TOKEN, breakOnFirstToken)
	}
}
