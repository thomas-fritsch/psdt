/*******************************************************************************
 * Copyright (c) 2016 Thomas Fritsch.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 ******************************************************************************/
package de.tfritsch.psdt.ui.labeling

import com.google.inject.Inject
import de.tfritsch.psdt.conversion.STRINGValueConverter
import de.tfritsch.psdt.postscript.PSArray
import de.tfritsch.psdt.postscript.PSDictionary
import de.tfritsch.psdt.postscript.PSExecutableName
import de.tfritsch.psdt.postscript.PSFloat
import de.tfritsch.psdt.postscript.PSInt
import de.tfritsch.psdt.postscript.PSLiteralName
import de.tfritsch.psdt.postscript.PSObject
import de.tfritsch.psdt.postscript.PSProcedure
import de.tfritsch.psdt.postscript.PSString
import de.tfritsch.psdt.postscript.PSUnparsedData
import org.eclipse.emf.edit.ui.provider.AdapterFactoryLabelProvider
import org.eclipse.xtext.Keyword
import org.eclipse.xtext.ui.label.DefaultEObjectLabelProvider

/**
 * Provides labels for a EObjects.
 * 
 * see http://www.eclipse.org/Xtext/documentation.html#labelProvider
 * @author Thomas Fritsch - initial API and implementation
 */
class PostscriptLabelProvider extends DefaultEObjectLabelProvider {

	@Inject
	STRINGValueConverter stringValueConverter

	@Inject
	new(AdapterFactoryLabelProvider delegate) {
		super(delegate);
	}

	def text(PSProcedure it) {
		"{...}" // better than "<unnamed>"
	}

	def text(PSArray it) {
		"[...]" // better than "<unnamed>"
	}

	def text(PSDictionary it) {
		"<<...>>" // better than "<unnamed>"
	}

	def text(PSString it) {
		stringValueConverter.toString(bytes)
	}

	def text(PSInt it) {
		String.valueOf(i)
	}

	def text(PSFloat it) {
		String.valueOf(f)
	}

	def text(PSUnparsedData it) {
		"Data"
	}

	def image(PSUnparsedData it) {
		"data.png"
	}

	def image(PSObject it) {
		"object.gif"
	}

	def image(PSInt it) {
		"number.gif"
	}

	def image(PSFloat it) {
		"number.gif"
	}

	def image(PSString it) {
		"text.gif"
	}

	def image(PSLiteralName it) {
		"text.gif"
	}

	def image(PSExecutableName it) {
		"text.gif"
	}

	def image(Keyword it) {
		"keyword.gif"
	}

}
