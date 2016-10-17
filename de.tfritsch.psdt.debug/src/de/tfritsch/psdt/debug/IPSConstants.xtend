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

/**
 * Constants for the PostScript debugger.
 * 
 * @author Thomas Fritsch - initial API and implementation
 */
interface IPSConstants {

	/**
	 * Attribute key of a launch configuration. The value of this attribute is
	 * a string giving the absolute path of a PostScript program. 
	 */
	val String ATTR_PROGRAM = PSPlugin.ID + ".ATTR_PROGRAM"

	/**
	 * Attribute key of a launch configuration. The value of this attribute is
	 * a string giving the command-line options for the Ghostscript interpreter. 
	 */
	val String ATTR_GS_ARGUMENTS = PSPlugin.ID + ".ATTR_GS_ARGUMENTS"

	/**
	 * Attribute key of a launch configuration. The value of this attribute is
	 * a boolean saying if the debugged PostScript application should break.
	 */
	val String ATTR_BREAK_ON_FIRST_TOKEN = PSPlugin.ID + ".ATTR_BREAK_ON_FIRST_TOKEN"

	/**
	 * Preference key in this plug-in's preference store. The value of this preference is
	 * a string giving the absolute path of a Ghostscript interpreter. 
	 */
	val String PREF_INTERPRETER = "interpreter"

	/**
	 * Preference key in this plug-in's preference store. The value of this preference is
	 * a string giving the default command-line options for the Ghostscript interpreter. 
	 */
	val String PREF_DEFAULT_GS_ARGUMENTS = "defaultGsArguments"

	/**
	 * Preference key in this plug-in's preference store. The value of this preference is
	 * a boolean saying if a message-box should pop up when Ghostscript prompts for pressing
	 * return at the end of a page. 
	 */
	val String PREF_MESSAGE_BOX_ON_PROMPT = "messageBoxOnPrompt"

	/**
	 * Preference key in this plug-in's preference store. The value of this preference is
	 * a boolean saying if the debugger should show the contents of <code>systemdict</code. 
	 */
	val String PREF_SHOW_SYSTEMDICT = "show.systemdict"

	/**
	 * Preference key in this plug-in's preference store. The value of this preference is
	 * a boolean saying if the debugger should show the contents of <code>globaldict</code>. 
	 */
	val String PREF_SHOW_GLOBALDICT = "show.globaldict"

	/**
	 * Preference key in this plug-in's preference store. The value of this preference is
	 * a boolean saying if the debugger should show the contents of <code>userdict</code>. 
	 */
	val String PREF_SHOW_USERDICT = "show.userdict"
}
