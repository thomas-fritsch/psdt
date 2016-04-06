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
