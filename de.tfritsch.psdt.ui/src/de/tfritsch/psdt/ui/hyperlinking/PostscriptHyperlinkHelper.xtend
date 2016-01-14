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

class PostscriptHyperlinkHelper extends HyperlinkHelper {

	@Inject
	Provider<DocHyperlink> docHyperlinkProvider;

	override void createHyperlinksByOffset(XtextResource resource, int offset, IHyperlinkAcceptor acceptor) {
		super.createHyperlinksByOffset(resource, offset, acceptor)
		val eObject = EObjectAtOffsetHelper.resolveContainedElementAt(resource, offset)
		val name = switch (eObject) {
			PSExecutableName:
				eObject.name
			PSLiteralName:
				eObject.name
			default:
				null
		}
		val helpURL = name?.documentationURL
		if (helpURL !== null) {
			val node = eObject.node
			val hyperlink = docHyperlinkProvider.get => [
				hyperlinkRegion = new Region(node.offset, node.length)
				hyperlinkText = "Open Documentation - " + name
				url = helpURL
			]
			acceptor.accept(hyperlink)
		}
	}

}
