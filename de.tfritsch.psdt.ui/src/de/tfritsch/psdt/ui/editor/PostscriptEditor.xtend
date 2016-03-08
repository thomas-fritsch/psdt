/*******************************************************************************
 * Copyright (c) 2016 Thomas Fritsch.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 ******************************************************************************/
package de.tfritsch.psdt.ui.editor

import org.eclipse.xtext.ui.editor.XtextEditor

import de.tfritsch.psdt.ui.internal.PostscriptActivator

/**
 * Work-around for https://bugs.eclipse.org/bugs/show_bug.cgi?id=422633
 * 
 * @author Thomas Fritsch - initial API and implementation
 */
class PostscriptEditor extends XtextEditor {

	/**
     * Unique identifier for the PostScript editor.
     * Matches plugin.xml
     * extension[@point="org.eclipse.debug.ui.editors"]/editor/@id
     */
	public static val ID = PostscriptActivator.DE_TFRITSCH_PSDT_POSTSCRIPT
}
