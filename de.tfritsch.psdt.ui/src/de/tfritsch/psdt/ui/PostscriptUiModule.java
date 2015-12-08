/*
 * generated by Xtext
 */
package de.tfritsch.psdt.ui;

import org.eclipse.jface.text.source.DefaultCharacterPairMatcher;
import org.eclipse.jface.text.source.ICharacterPairMatcher;
import org.eclipse.ui.plugin.AbstractUIPlugin;
import org.eclipse.xtext.ui.editor.XtextEditor;
import org.eclipse.xtext.ui.editor.autoedit.AbstractEditStrategyProvider;
import org.eclipse.xtext.ui.editor.hover.IEObjectHoverProvider;
import org.eclipse.xtext.ui.editor.model.XtextDocumentProvider;
import org.eclipse.xtext.ui.editor.outline.impl.OutlinePage;
import org.eclipse.xtext.ui.editor.syntaxcoloring.AbstractAntlrTokenToAttributeIdMapper;
import org.eclipse.xtext.ui.editor.syntaxcoloring.IHighlightingConfiguration;

import de.tfritsch.psdt.ui.autoedit.PostscriptAutoEditStrategyProvider;
import de.tfritsch.psdt.ui.editor.PostscriptDocumentProvider;
import de.tfritsch.psdt.ui.editor.PostscriptEditor;
import de.tfritsch.psdt.ui.hover.PostscriptHoverProvider;
import de.tfritsch.psdt.ui.outline.PostscriptOutlinePage;
import de.tfritsch.psdt.ui.syntaxcoloring.PostscriptAntlrTokenToAttributeIdMapper;
import de.tfritsch.psdt.ui.syntaxcoloring.PostscriptHighlightingConfiguration;

/**
 * Use this class to register components to be used within the IDE.
 */
public class PostscriptUiModule extends AbstractPostscriptUiModule {
	public PostscriptUiModule(AbstractUIPlugin plugin) {
		super(plugin);
	}

	public Class<? extends AbstractAntlrTokenToAttributeIdMapper> bindAbstractAntlrTokenToAttributeIdMapper() {
		return PostscriptAntlrTokenToAttributeIdMapper.class;
	}

	public Class<? extends IHighlightingConfiguration> bindIHighlightingConfiguration() {
		return PostscriptHighlightingConfiguration.class;
	}

	@Override
	public ICharacterPairMatcher bindICharacterPairMatcher() {
		return new DefaultCharacterPairMatcher(new char[] { '(', ')', '{', '}',
				'[', ']', '<', '>' });
	}

	@Override
	public Class<? extends AbstractEditStrategyProvider> bindAbstractEditStrategyProvider() {
		return PostscriptAutoEditStrategyProvider.class;
	}

	public Class<? extends XtextEditor> bindXtextEditor() {
		return PostscriptEditor.class;
	}

	public Class<? extends IEObjectHoverProvider> bindIEObjectHoverProvider() {
		return PostscriptHoverProvider.class;
	}

	public Class<? extends XtextDocumentProvider> bindXtextDocumentProvider() {
		return PostscriptDocumentProvider.class;
	}

	public Class<? extends OutlinePage> bindOutlinePage() {
		return PostscriptOutlinePage.class;
	}
}
