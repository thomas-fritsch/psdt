package de.tfritsch.psdt.debug;

/**
 * Constants for the PostScript debugger.
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
}
