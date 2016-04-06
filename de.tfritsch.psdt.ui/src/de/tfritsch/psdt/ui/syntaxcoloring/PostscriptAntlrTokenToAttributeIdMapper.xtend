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
package de.tfritsch.psdt.ui.syntaxcoloring

import com.google.inject.Singleton
import org.eclipse.xtext.ui.editor.syntaxcoloring.DefaultAntlrTokenToAttributeIdMapper

import static de.tfritsch.psdt.ui.syntaxcoloring.PostscriptHighlightingConfiguration.*

/**
 * @author Thomas Fritsch - initial API and implementation
 */
@Singleton
class PostscriptAntlrTokenToAttributeIdMapper extends DefaultAntlrTokenToAttributeIdMapper {

	override protected String calculateId(String tokenName, int tokenType) {
		return switch (tokenName) {
			case "RULE_ID": DEFAULT_ID
			case "RULE_LITERAL_ID": LITERAL_NAME_ID
			case "RULE_STRING": STRING_ID
			case "RULE_ASCII_HEX_STRING": STRING_ID
			case "RULE_ASCII_85_STRING": STRING_ID
			case "RULE_INT": NUMBER_ID
			case "RULE_FLOAT": NUMBER_ID
			case "RULE_DSC_COMMENT": DSC_COMMENT_ID
			case "RULE_UNPARSED_DATA": UNPARSED_DATA_ID
			default: super.calculateId(tokenName, tokenType)
		}
	}
}
