/*
* generated by Xtext
*/
package de.tfritsch.psdt.ui.labeling

import com.google.inject.Inject
import de.tfritsch.psdt.postscript.PSFile
import de.tfritsch.psdt.postscript.PSObject
import de.tfritsch.psdt.postscript.PSProcedure
import org.eclipse.emf.edit.ui.provider.AdapterFactoryLabelProvider
import org.eclipse.xtext.ui.label.DefaultEObjectLabelProvider

/**
 * Provides labels for a EObjects.
 * 
 * see http://www.eclipse.org/Xtext/documentation.html#labelProvider
 */
class PostscriptLabelProvider extends DefaultEObjectLabelProvider {

	@Inject
	new(AdapterFactoryLabelProvider delegate) {
		super(delegate);
	}

	def text(PSFile it) {
		it.eResource.URI.lastSegment // file name with extension
	}

	def image(PSFile it) {
		"postscript.png"
	}

	def text(PSProcedure it) {
		"{...}" // better than "<unnamed>"
	}

	def image(PSObject it) {
		"defaultoutlinenode.gif"
	}

}
