package de.tfritsch.psdt.ui.hover;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.ui.editor.hover.html.DefaultEObjectHoverProvider;
import de.tfritsch.psdt.postscript.PSExecutableName;

public class PostscriptEObjectHoverProvider extends DefaultEObjectHoverProvider {

	/**
	 * Documentation hover only for executable names.
	 */
	@Override
	protected boolean hasHover(EObject o) {
		return (o instanceof PSExecutableName);
	}

}
