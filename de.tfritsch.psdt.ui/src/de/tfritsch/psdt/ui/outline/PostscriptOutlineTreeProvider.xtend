/*******************************************************************************
 * Copyright (c) 2016 Thomas Fritsch.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 ******************************************************************************/
package de.tfritsch.psdt.ui.outline

import de.tfritsch.psdt.postscript.PSFile
import org.eclipse.xtext.ui.editor.outline.impl.DefaultOutlineTreeProvider
import org.eclipse.xtext.ui.editor.outline.impl.DocumentRootNode

/**
 * Customization of the default outline structure.
 *
 * see http://www.eclipse.org/Xtext/documentation.html#outline
 * @author Thomas Fritsch - initial API and implementation
 */
class PostscriptOutlineTreeProvider extends DefaultOutlineTreeProvider {

	// skip the root model element of type PSFile
	def protected _createChildren(DocumentRootNode parentNode, PSFile file) {
		for (object : file.objects) {
			createNode(parentNode, object);
		}
	}
}
