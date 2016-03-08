/*******************************************************************************
 * Copyright (c) 2016 Thomas Fritsch.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 ******************************************************************************/
package de.tfritsch.psdt.documentation

import de.tfritsch.psdt.postscript.PSExecutableName
import de.tfritsch.psdt.postscript.PSLiteralName
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.documentation.IEObjectDocumentationProvider

import static extension de.tfritsch.psdt.help.PSHelpExtensions.*

/**
 * @author Thomas Fritsch - initial API and implementation
 */
class PostscriptDocumentationProvider implements IEObjectDocumentationProvider {

	def dispatch String getDocumentation(EObject o) {
		return null
	}

	def dispatch String getDocumentation(PSExecutableName o) {
		return o.name.documentationContent
	}

	def dispatch String getDocumentation(PSLiteralName o) {
		return o.name.documentationContent
	}

}