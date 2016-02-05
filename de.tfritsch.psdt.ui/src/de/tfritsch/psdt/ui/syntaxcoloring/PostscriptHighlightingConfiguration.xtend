package de.tfritsch.psdt.ui.syntaxcoloring

import org.eclipse.swt.SWT
import org.eclipse.swt.graphics.RGB
import org.eclipse.xtext.ui.editor.syntaxcoloring.DefaultHighlightingConfiguration
import org.eclipse.xtext.ui.editor.syntaxcoloring.IHighlightingConfigurationAcceptor
import org.eclipse.xtext.ui.editor.utils.TextStyle

class PostscriptHighlightingConfiguration extends DefaultHighlightingConfiguration {

	public static val LITERAL_NAME_ID = "literalName"

	public static val DSC_COMMENT_ID = "dscComment"

	public static val UNPARSED_DATA_ID = "unparsedData"

	override void configure(IHighlightingConfigurationAcceptor acceptor) {
		super.configure(acceptor)
		acceptor.acceptDefaultHighlighting(LITERAL_NAME_ID, "Literal Name", literalNameTextStyle)
		acceptor.acceptDefaultHighlighting(DSC_COMMENT_ID, "DSC Comment", dscCommentTextStyle)
		acceptor.acceptDefaultHighlighting(de.tfritsch.psdt.ui.syntaxcoloring.PostscriptHighlightingConfiguration.UNPARSED_DATA_ID, "Unparsed Data", unparsedDataTextStyle)
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

	def TextStyle unparsedDataTextStyle() {
		return defaultTextStyle.copy => [
			color = new RGB(42, 0, 255) // blue
			backgroundColor = new RGB(220, 220, 220) // light grey
		]
	}

}
