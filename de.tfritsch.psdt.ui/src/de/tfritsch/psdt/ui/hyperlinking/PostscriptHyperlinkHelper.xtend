/*******************************************************************************
 * Copyright (c) 2016 Thomas Fritsch.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 ******************************************************************************/
package de.tfritsch.psdt.ui.hyperlinking

import com.google.inject.Inject
import com.google.inject.Provider
import de.tfritsch.psdt.postscript.PSExecutableName
import de.tfritsch.psdt.postscript.PSLiteralName
import org.eclipse.jface.text.Region
import org.eclipse.xtext.resource.XtextResource
import org.eclipse.xtext.ui.editor.hyperlinking.HyperlinkHelper
import org.eclipse.xtext.ui.editor.hyperlinking.IHyperlinkAcceptor

import static extension de.tfritsch.psdt.help.PSHelpExtensions.*
import static extension org.eclipse.xtext.nodemodel.util.NodeModelUtils.*

/**
 * @author Thomas Fritsch - initial API and implementation
 */
class PostscriptHyperlinkHelper extends HyperlinkHelper {

	@Inject
	Provider<DocHyperlink> docHyperlinkProvider;

	override void createHyperlinksByOffset(XtextResource resource, int offset, extension IHyperlinkAcceptor acceptor) {
		val eObject = EObjectAtOffsetHelper.resolveContainedElementAt(resource, offset)
		val name = switch (eObject) {
			PSExecutableName:
				eObject.name
			PSLiteralName:
				eObject.name
			default:
				null
		}
		if (name !== null) {
			for (documentation : name.documentations) {
				val node = eObject.node
				val hyperlink = docHyperlinkProvider.get => [
					hyperlinkRegion = new Region(node.offset, node.length)
					hyperlinkText = documentation.label
					url = documentation.url
				]
				hyperlink.accept
			}
		}
	}

}
