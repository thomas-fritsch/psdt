package de.tfritsch.psdt.documentation

import de.tfritsch.psdt.postscript.PSExecutableName
import de.tfritsch.psdt.postscript.PSLiteralName
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.documentation.IEObjectDocumentationProvider

import static extension de.tfritsch.psdt.help.PSHelpExtensions.*

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