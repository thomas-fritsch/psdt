/*******************************************************************************
 * Copyright (c) 2016 Thomas Fritsch.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 ******************************************************************************/
package de.tfritsch.psdt.ui.hover;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.jface.action.Action;
import org.eclipse.jface.action.ActionContributionItem;
import org.eclipse.jface.action.IContributionItem;
import org.eclipse.jface.action.ToolBarManager;
import org.eclipse.jface.text.IInformationControlCreator;
import org.eclipse.jface.text.IInputChangedListener;
import org.eclipse.ui.IWorkbench;
import org.eclipse.ui.IWorkbenchPage;
import org.eclipse.ui.PartInitException;
import org.eclipse.xtext.ui.IImageHelper.IImageDescriptorHelper;
import org.eclipse.xtext.ui.editor.hover.html.DefaultEObjectHoverProvider;
import org.eclipse.xtext.ui.editor.hover.html.IXtextBrowserInformationControl;
import org.eclipse.xtext.ui.editor.hover.html.XtextBrowserInformationControlInput;

import com.google.inject.Inject;

import de.tfritsch.psdt.ui.views.PostscriptDocView;

/**
 * @author Thomas Fritsch - initial API and implementation
 */
public class PostscriptHoverProvider extends DefaultEObjectHoverProvider {

	@Inject
	private IImageDescriptorHelper imageHelper;

        @Inject
        private IWorkbench workbench;

	private IInformationControlCreator presenterControlCreator;

	@Override
	protected boolean hasHover(EObject o) {
		return super.hasHover(o) && getDocumentation(o) != null;
	}

	@Override
	protected String getFirstLine(EObject o) {
		return "";
	}

	@Override
	protected String getStyleSheet() {
		String css = super.getStyleSheet();
		if (css != null)
			css += "th, td { vertical-align: top; }\n";
		return css;
	}

	@Override
	public IInformationControlCreator getInformationPresenterControlCreator() {
		if (presenterControlCreator == null)
			presenterControlCreator = new PostscriptPresenterControlCreator();
		return presenterControlCreator;
	}

	protected class ShowInDocViewAction extends Action {

		private final IXtextBrowserInformationControl fInfoControl;

		public ShowInDocViewAction(IXtextBrowserInformationControl infoControl) {
			fInfoControl = infoControl;
			setText("Show in PostscriptDoc view");
			setImageDescriptor(imageHelper.getImageDescriptor("doc.gif"));
		}

		@Override
		public void run() {
			XtextBrowserInformationControlInput infoInput = (XtextBrowserInformationControlInput) fInfoControl.getInput();
			fInfoControl.notifyDelayedInputChange(null);
			fInfoControl.dispose();
			IWorkbenchPage activePage = workbench.getActiveWorkbenchWindow().getActivePage();
			try {
				PostscriptDocView view = (PostscriptDocView) activePage.showView(PostscriptDocView.ID);
				view.setInput(infoInput);
			} catch (PartInitException e) {
				e.printStackTrace();
			}
		}
	}

	public class PostscriptPresenterControlCreator extends PresenterControlCreator {

		@Override
		protected void configureControl(final IXtextBrowserInformationControl control, ToolBarManager tbm, String font) {
			super.configureControl(control, tbm, font);
			// remove item "Open Declaration" (doesn't make sense for Postscript)
			for (IContributionItem item : tbm.getItems()) {
				if (item instanceof ActionContributionItem &&
					((ActionContributionItem) item).getAction() instanceof OpenDeclarationAction) {
					tbm.remove(item);
				}
			}
			// add item "Show in PostscriptDoc View"
			final Action showInDocViewAction = new ShowInDocViewAction(control);
			showInDocViewAction.setEnabled(false);
			tbm.add(showInDocViewAction);
			control.addInputChangeListener(new IInputChangedListener() {
				@Override
				public void inputChanged(Object newInput) {
					if (newInput instanceof XtextBrowserInformationControlInput &&
						((XtextBrowserInformationControlInput) newInput).getInputElement() != null) {
						showInDocViewAction.setEnabled(true);
					}
				}
			});
			tbm.update(true);
		}

	}
}
