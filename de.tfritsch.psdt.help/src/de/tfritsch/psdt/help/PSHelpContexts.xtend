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
package de.tfritsch.psdt.help

/**
 * @author Thomas Fritsch - initial API and implementation
 */
interface PSHelpContexts {

	String PLUGIN_ID = "de.tfritsch.psdt.help"

	String EDITOR = PLUGIN_ID + ".editor"
	String LAUNCH_CONFIGURATION_DIALOG_MAIN_TAB = PLUGIN_ID + ".launch_configuration_dialog_main_tab"
	String LAUNCH_CONFIGURATION_DIALOG_GHOSTSCRIPT_TAB = PLUGIN_ID + ".launch_configuration_dialog_ghostscript_tab"
}