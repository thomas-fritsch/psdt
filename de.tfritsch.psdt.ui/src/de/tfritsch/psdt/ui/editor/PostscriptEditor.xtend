package de.tfritsch.psdt.ui.editor

import org.eclipse.xtext.ui.editor.XtextEditor

import de.tfritsch.psdt.ui.internal.PostscriptActivator

// Work-around for https://bugs.eclipse.org/bugs/show_bug.cgi?id=422633
class PostscriptEditor extends XtextEditor {

    /**
     * Unique identifier for the PostScript editor.
     * Matches plugin.xml
     * extension[@point="org.eclipse.debug.ui.editors"]/editor/@id
     */
	public static val ID = PostscriptActivator.DE_TFRITSCH_PSDT_POSTSCRIPT
}
