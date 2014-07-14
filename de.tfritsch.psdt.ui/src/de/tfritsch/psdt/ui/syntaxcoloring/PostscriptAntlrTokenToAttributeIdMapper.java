package de.tfritsch.psdt.ui.syntaxcoloring;

import org.eclipse.xtext.ui.editor.syntaxcoloring.DefaultAntlrTokenToAttributeIdMapper;
import org.eclipse.xtext.ui.editor.syntaxcoloring.DefaultHighlightingConfiguration;

import com.google.inject.Singleton;

@Singleton
public class PostscriptAntlrTokenToAttributeIdMapper extends
		DefaultAntlrTokenToAttributeIdMapper {

	@Override
	protected String calculateId(String tokenName, int tokenType) {
		if ("RULE_ID".equals(tokenName)) {
			return PostscriptHighlightingConfiguration.DEFAULT_ID;
		}
		if ("RULE_LITERAL_ID".equals(tokenName)) {
			return PostscriptHighlightingConfiguration.LITERAL_NAME_ID;
		}
		if ("RULE_STRING".equals(tokenName)
				|| "RULE_ASCII_HEX_STRING".equals(tokenName)
				|| "RULE_ASCII_85_STRING".equals(tokenName)) {
			return DefaultHighlightingConfiguration.STRING_ID;
		}
		if ("RULE_NUMBER".equals(tokenName)) {
			return PostscriptHighlightingConfiguration.NUMBER_ID;
		}
		return super.calculateId(tokenName, tokenType);
	}
}
