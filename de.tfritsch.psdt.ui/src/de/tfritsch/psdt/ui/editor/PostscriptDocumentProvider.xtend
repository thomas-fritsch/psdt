/*******************************************************************************
 * Copyright (c) 2016 Thomas Fritsch.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 ******************************************************************************/
package de.tfritsch.psdt.ui.editor

import org.eclipse.core.runtime.CoreException
import org.eclipse.jface.text.source.AnnotationModel
import org.eclipse.jface.text.source.IAnnotationModel
import org.eclipse.xtext.ui.editor.model.XtextDocumentProvider

/**
 * Work-around to get instruction-highlighting when debugging PS files from outside workspace 
 *
 * @author Thomas Fritsch - initial API and implementation
 */
class PostscriptDocumentProvider extends XtextDocumentProvider {

	override IAnnotationModel createAnnotationModel(Object element) throws CoreException {
		val model = super.createAnnotationModel(element)
		return model ?: new AnnotationModel // return a minimal model instead of null
	}
}
