package de.tfritsch.psdt.debug.ui;

import org.eclipse.osgi.util.NLS;

public class Messages extends NLS {
	private static final String BUNDLE_NAME = "de.tfritsch.psdt.debug.ui.messages";//$NON-NLS-1$
	static {
		// load message values from bundle file
		NLS.initializeMessages(BUNDLE_NAME, Messages.class);
	}

	public static String GhostscriptArgumentsBlock_invalidOption;
	public static String GhostscriptArgumentsBlock_link;
	public static String GhostscriptArgumentsBlock_name;
	public static String GhostscriptInterpreterBlock_name;
	public static String GhostscriptPreferencePage_interpreter;
	public static String PSEditorPreferencePage_description;
	public static String PSEditorPreferencePage_link;
	public static String PSLaunchShortcut_dialogMessage;
	public static String PSLaunchShortcut_dialogTitle;
	public static String PSMainTab_name;

}
