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
package de.tfritsch.psdt.ui.labeling

import com.google.inject.Inject
import de.tfritsch.psdt.conversion.ImmediatelyEvaluatedIdValueConverter
import de.tfritsch.psdt.conversion.LiteralIdValueConverter
import de.tfritsch.psdt.conversion.STRINGValueConverter
import de.tfritsch.psdt.postscript.PSArray
import de.tfritsch.psdt.postscript.PSDictionary
import de.tfritsch.psdt.postscript.PSExecutableName
import de.tfritsch.psdt.postscript.PSFloat
import de.tfritsch.psdt.postscript.PSImmediatelyEvaluatedName
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
	LiteralIdValueConverter literalIdValueConverter

	@Inject
	ImmediatelyEvaluatedIdValueConverter immediatelyEvaluatedIdValueConverter

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
		stringValueConverter.toString(bytes ?: newByteArrayOfSize(0))
	}

	def text(PSLiteralName it) {
		literalIdValueConverter.toString(name)
	}

	def text(PSImmediatelyEvaluatedName it) {
		immediatelyEvaluatedIdValueConverter.toString(name)
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
