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
package de.tfritsch.psdt.conversion

import com.google.inject.Inject
import com.google.inject.Singleton
import org.eclipse.xtext.conversion.IValueConverter
import org.eclipse.xtext.conversion.ValueConverter
import org.eclipse.xtext.conversion.impl.AbstractDeclarativeValueConverterService

/**
 * PostScript specific value converters.
 * Do not extend from DefaultTerminalConverters, because we don't want its ValueConverters
 * 
 * @author Thomas Fritsch - initial API and implementation
 */
@Singleton
class PostscriptTerminalConverters extends AbstractDeclarativeValueConverterService {
	@Inject
	STRINGValueConverter stringValueConverter

	@ValueConverter(rule="STRING")
	def IValueConverter<byte[]> getStringValueConverter() {
		stringValueConverter
	}

	@Inject
	ASCIIHexStringValueConverter asciiHexStringValueConverter

	@ValueConverter(rule="ASCII_HEX_STRING")
	def IValueConverter<byte[]> getAsciiHexStringValueConverter() {
		asciiHexStringValueConverter
	}

	@Inject
	ASCII85StringValueConverter ascii85StringValueConverter

	@ValueConverter(rule="ASCII_85_STRING")
	def IValueConverter<byte[]> getAscii85StringValueConverter() {
		ascii85StringValueConverter
	}

	@Inject
	INTValueConverter intValueConverter

	@ValueConverter(rule="INT")
	def IValueConverter<Integer> getIntValueConverter() {
		intValueConverter
	}

	@Inject
	LiteralIdValueConverter literalIdValueConverter

	@ValueConverter(rule="LITERAL_ID")
	def IValueConverter<String> getLiteralIdValueConverter() {
		literalIdValueConverter
	}

	@Inject
	ImmediatelyEvaluatedIdValueConverter immediatelyEvaluatedIdValueConverter

	@ValueConverter(rule="IMMEDIATELY_EVALUATED_ID")
	def IValueConverter<String> getImmediatelyEvaluatedIdValueConverter() {
		immediatelyEvaluatedIdValueConverter
	}

}
