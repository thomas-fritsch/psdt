/*******************************************************************************
 * Copyright (c) 2016 Thomas Fritsch.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
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

// @Inject
// AbstractIDValueConverter idValueConverter;
//
// @ValueConverter(rule = "ID")
// def IValueConverter<String> getIdValueConverter() {
//     idValueConverter
// }
}
