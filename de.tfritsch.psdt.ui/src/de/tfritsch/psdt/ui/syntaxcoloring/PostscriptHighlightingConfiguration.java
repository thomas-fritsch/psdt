package de.tfritsch.psdt.ui.syntaxcoloring;

import org.eclipse.swt.SWT;
import org.eclipse.swt.graphics.RGB;
import org.eclipse.xtext.ui.editor.syntaxcoloring.DefaultHighlightingConfiguration;
import org.eclipse.xtext.ui.editor.syntaxcoloring.IHighlightingConfigurationAcceptor;
import org.eclipse.xtext.ui.editor.utils.TextStyle;

public class PostscriptHighlightingConfiguration extends
		DefaultHighlightingConfiguration {

	public static final String LITERAL_NAME_ID = "literalName";

	@Override
	public void configure(IHighlightingConfigurationAcceptor acceptor) {
		acceptor.acceptDefaultHighlighting(LITERAL_NAME_ID, "Literal Name",
				literalNameTextStyle());
		acceptor.acceptDefaultHighlighting(PUNCTUATION_ID, "Bracket",
				punctuationTextStyle());
		acceptor.acceptDefaultHighlighting(COMMENT_ID, "Comment",
				commentTextStyle());
		acceptor.acceptDefaultHighlighting(STRING_ID, "String",
				stringTextStyle());
		acceptor.acceptDefaultHighlighting(NUMBER_ID, "Number",
				numberTextStyle());
		acceptor.acceptDefaultHighlighting(DEFAULT_ID, "Default",
				defaultTextStyle());
		acceptor.acceptDefaultHighlighting(INVALID_TOKEN_ID, "Invalid Symbol",
				errorTextStyle());
	}

	public TextStyle literalNameTextStyle() {
		TextStyle textStyle = defaultTextStyle().copy();
		textStyle.setColor(new RGB(128, 0, 255)); // violet
		textStyle.setStyle(SWT.BOLD);
		return textStyle;
	}

}
