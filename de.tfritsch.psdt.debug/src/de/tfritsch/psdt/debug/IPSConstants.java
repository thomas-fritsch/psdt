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
package de.tfritsch.psdt.debug;

/**
 * Constants for the PostScript debugger.
 * 
 * @author Thomas Fritsch - initial API and implementation
 */
public interface IPSConstants {
    
    /**
     * Attribute key of a launch configuration. The value of this attribute is
     * an absolute path of a PostScript program. 
     */
    public static final String ATTR_PROGRAM = PSPlugin.ID + ".ATTR_PROGRAM"; //$NON-NLS-1$

    /**
     * Attribute key of a launch configuration. The value of this attribute are
     * command-line options for Ghostscript. 
     */
    public static final String ATTR_GS_ARGUMENTS = PSPlugin.ID + ".ATTR_GS_ARGUMENTS"; //$NON-NLS-1$

    /**
     * Attribute key of a launch configuration. The value of this attribute is
     * a boolean saying if the debugged PostScript application should break. 
     */
    public static final String ATTR_BREAK_ON_FIRST_TOKEN = PSPlugin.ID + ".ATTR_BREAK_ON_FIRST_TOKEN"; //$NON-NLS-1$

    /**
     * Preference key in this plug-in's preference store. The value of this preference is
     * an absolute path of a PostScript interpreter. 
     */
    public static final String PREF_INTERPRETER = "interpreter"; //$NON-NLS-1$

    public static final String PREF_MESSAGE_BOX_ON_PROMPT = "messageBoxOnPrompt";
    
    public static final String PREF_SHOW_SYSTEMDICT = "show.systemdict"; //$NON-NLS-1$
    public static final String PREF_SHOW_GLOBALDICT = "show.globaldict"; //$NON-NLS-1$
    public static final String PREF_SHOW_USERDICT = "show.userdict"; //$NON-NLS-1$
}
