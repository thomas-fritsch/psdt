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
package de.tfritsch.psdt.documentation

import de.tfritsch.psdt.postscript.PSExecutableName
import de.tfritsch.psdt.postscript.PSImmediatelyEvaluatedName
import de.tfritsch.psdt.postscript.PSLiteralName
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.documentation.IEObjectDocumentationProvider

import static extension de.tfritsch.psdt.help.PSHelpExtensions.*

/**
 * @author Thomas Fritsch - initial API and implementation
 */
class PostscriptDocumentationProvider implements IEObjectDocumentationProvider {

	def dispatch String getDocumentation(EObject o) {
		null
	}

	def dispatch String getDocumentation(PSExecutableName o) {
		o.name.documentationContent
	}

	def dispatch String getDocumentation(PSLiteralName o) {
		o.name.documentationContent
	}

	def dispatch String getDocumentation(PSImmediatelyEvaluatedName o) {
		o.name.documentationContent
	}

}