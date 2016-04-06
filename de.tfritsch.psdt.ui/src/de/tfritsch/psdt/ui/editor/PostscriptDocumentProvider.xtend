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
