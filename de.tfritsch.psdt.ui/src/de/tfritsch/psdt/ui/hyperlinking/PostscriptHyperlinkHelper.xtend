package de.tfritsch.psdt.ui.hyperlinking

import com.google.inject.Inject
import com.google.inject.Provider
import de.tfritsch.psdt.postscript.PSExecutableName
import de.tfritsch.psdt.postscript.PSLiteralName
import java.net.URL
import org.eclipse.jface.text.Region
import org.eclipse.xtext.resource.XtextResource
import org.eclipse.xtext.ui.editor.hyperlinking.HyperlinkHelper
import org.eclipse.xtext.ui.editor.hyperlinking.IHyperlinkAcceptor

import static extension org.eclipse.core.runtime.FileLocator.*
import static extension org.eclipse.help.HelpSystem.*
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
		val href_ = name?.href
		if (href_ !== null) {
			val node = eObject.node
			val hyperlink = docHyperlinkProvider.get => [
				hyperlinkRegion = new Region(node.offset, node.length)
				hyperlinkText = "Open Documentation - " + name
				url = new URL("platform:/plugin" + href_).toFileURL
			]
			acceptor.accept(hyperlink)
		}
	}

	def private String getHref(String name) {
		val context = ("de.tfritsch.psdt.help." + name).context
		return context?.relatedTopics?.head?.href
	}

}
