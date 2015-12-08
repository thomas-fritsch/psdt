package de.tfritsch.psdt.ui.outline

import org.eclipse.xtext.ui.editor.outline.impl.OutlinePage

class PostscriptOutlinePage extends OutlinePage {

	override protected int getDefaultExpansionLevel() {
		return 2
	}
}
