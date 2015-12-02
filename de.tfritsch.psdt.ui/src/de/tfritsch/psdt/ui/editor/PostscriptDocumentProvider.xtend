package de.tfritsch.psdt.ui.editor

import org.eclipse.core.runtime.CoreException
import org.eclipse.jface.text.source.AnnotationModel
import org.eclipse.jface.text.source.IAnnotationModel
import org.eclipse.xtext.ui.editor.model.XtextDocumentProvider

// Work-around to get instruction-highlighting when debugging PS files from outside workspace 
class PostscriptDocumentProvider extends XtextDocumentProvider {

	override IAnnotationModel createAnnotationModel(Object element) throws CoreException {
		val model = super.createAnnotationModel(element)
		return model ?: new AnnotationModel // return a minimal model instead of null
	}
}
