package de.tfritsch.psdt.ui.syntaxcoloring

import org.eclipse.swt.SWT
import org.eclipse.swt.graphics.RGB
import org.eclipse.xtext.ui.editor.syntaxcoloring.DefaultHighlightingConfiguration
import org.eclipse.xtext.ui.editor.syntaxcoloring.IHighlightingConfigurationAcceptor
import org.eclipse.xtext.ui.editor.utils.TextStyle

class PostscriptHighlightingConfiguration extends DefaultHighlightingConfiguration {

	public static val LITERAL_NAME_ID = "literalName"

	public static val DSC_COMMENT_ID = "dscComment"

	override void configure(IHighlightingConfigurationAcceptor acceptor) {
		super.configure(acceptor)
		acceptor.acceptDefaultHighlighting(LITERAL_NAME_ID, "Literal Name", literalNameTextStyle)
		acceptor.acceptDefaultHighlighting(DSC_COMMENT_ID, "DSC Comment", dscCommentTextStyle)
	}

	def TextStyle literalNameTextStyle() {
		return defaultTextStyle.copy => [
			color = new RGB(128, 0, 255) // violet
			style = SWT.BOLD
		]
	}

	def TextStyle dscCommentTextStyle() {
		return defaultTextStyle.copy => [
			color = new RGB(63, 95, 191) // grey blue
		]
	}

}