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
package de.tfritsch.psdt.ui;

import org.eclipse.jface.text.source.DefaultCharacterPairMatcher;
import org.eclipse.jface.text.source.ICharacterPairMatcher;
import org.eclipse.ui.PlatformUI;
import org.eclipse.ui.browser.IWorkbenchBrowserSupport;
import org.eclipse.ui.help.IWorkbenchHelpSystem;
import org.eclipse.ui.plugin.AbstractUIPlugin;
import org.eclipse.xtext.ui.editor.IXtextEditorCallback;
import org.eclipse.xtext.ui.editor.XtextEditor;
import org.eclipse.xtext.ui.editor.autoedit.AbstractEditStrategyProvider;
import org.eclipse.xtext.ui.editor.contentassist.XtextContentAssistProcessor;
import org.eclipse.xtext.ui.editor.hover.IEObjectHoverProvider;
import org.eclipse.xtext.ui.editor.hyperlinking.IHyperlinkHelper;
import org.eclipse.xtext.ui.editor.syntaxcoloring.AbstractAntlrTokenToAttributeIdMapper;
import org.eclipse.xtext.ui.editor.syntaxcoloring.IHighlightingConfiguration;
import org.eclipse.xtext.ui.editor.validation.ValidatingEditorCallback;

import com.google.inject.Binder;
import com.google.inject.name.Names;

import de.tfritsch.psdt.ui.autoedit.PostscriptAutoEditStrategyProvider;
import de.tfritsch.psdt.ui.editor.PostscriptEditor;
import de.tfritsch.psdt.ui.hover.PostscriptHoverProvider;
import de.tfritsch.psdt.ui.hyperlinking.PostscriptHyperlinkHelper;
import de.tfritsch.psdt.ui.syntaxcoloring.PostscriptAntlrTokenToAttributeIdMapper;
import de.tfritsch.psdt.ui.syntaxcoloring.PostscriptHighlightingConfiguration;

/**
 * Use this class to register components to be used within the IDE.
 * 
 * @author Thomas Fritsch - initial API and implementation
 */
public class PostscriptUiModule extends AbstractPostscriptUiModule {
	public PostscriptUiModule(AbstractUIPlugin plugin) {
		super(plugin);
	}

	@Override
	public void configure(Binder binder) {
		super.configure(binder);
		binder.bind(String.class)
		      .annotatedWith(Names.named(XtextContentAssistProcessor.COMPLETION_AUTO_ACTIVATION_CHARS))
			  .toInstance("/");
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

	public Class<? extends IHyperlinkHelper> bindIHyperlinkHelper() {
		return PostscriptHyperlinkHelper.class;
	}

	public IWorkbenchBrowserSupport bindIWorkbenchBrowserSupport() {
		return PlatformUI.getWorkbench().getBrowserSupport();
	}

	public IWorkbenchHelpSystem bindIWorkbenchHelpSystem() {
		return PlatformUI.getWorkbench().getHelpSystem();
	}

	/**
	 * @see <a href="https://www.eclipse.org/forums/index.php/t/292133/#msg_849499">
	 *      Re: syntax validation not active when opening document</a>
	 */
	public Class<? extends IXtextEditorCallback> bindIXtextEditorCallback() {
		return ValidatingEditorCallback.class;
	}
}
