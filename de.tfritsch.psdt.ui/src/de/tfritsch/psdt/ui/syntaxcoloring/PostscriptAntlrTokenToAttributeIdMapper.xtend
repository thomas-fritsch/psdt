package de.tfritsch.psdt.ui.syntaxcoloring

import com.google.inject.Singleton
import org.eclipse.xtext.ui.editor.syntaxcoloring.DefaultAntlrTokenToAttributeIdMapper

import static de.tfritsch.psdt.ui.syntaxcoloring.PostscriptHighlightingConfiguration.*

@Singleton
class PostscriptAntlrTokenToAttributeIdMapper extends DefaultAntlrTokenToAttributeIdMapper {

	override protected String calculateId(String tokenName, int tokenType) {
		return switch (tokenName) {
			case "RULE_ID": DEFAULT_ID
			case "RULE_LITERAL_ID": LITERAL_NAME_ID
			case "RULE_STRING": STRING_ID
			case "RULE_ASCII_HEX_STRING": STRING_ID
			case "RULE_ASCII_85_STRING": STRING_ID
			case "RULE_INT": NUMBER_ID
			case "RULE_FLOAT": NUMBER_ID
			case "RULE_DSC_COMMENT": DSC_COMMENT_ID
			case "RULE_UNPARSED_DATA": UNPARSED_DATA_ID
			default: super.calculateId(tokenName, tokenType)
		}
	}
}
