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

import org.eclipse.swt.SWT
import org.eclipse.swt.graphics.RGB
import org.eclipse.xtext.ui.editor.syntaxcoloring.DefaultHighlightingConfiguration
import org.eclipse.xtext.ui.editor.syntaxcoloring.IHighlightingConfigurationAcceptor
import org.eclipse.xtext.ui.editor.utils.TextStyle

/**
 * @author Thomas Fritsch - initial API and implementation
 */
class PostscriptHighlightingConfiguration extends DefaultHighlightingConfiguration {

	public static val LITERAL_NAME_ID = "literalName"

	public static val IMMEDIATELY_EVALUATED_NAME_ID = "immediatelyEvaluatedName"

	public static val DSC_COMMENT_ID = "dscComment"

	public static val UNPARSED_DATA_ID = "unparsedData"

	override configure(IHighlightingConfigurationAcceptor acceptor) {
		super.configure(acceptor)
		acceptor.acceptDefaultHighlighting(LITERAL_NAME_ID, "Literal Name", literalNameTextStyle)
		acceptor.acceptDefaultHighlighting(IMMEDIATELY_EVALUATED_NAME_ID, "Immediately Evaluated Name", immediatelyEvaluatedNameTextStyle)
		acceptor.acceptDefaultHighlighting(DSC_COMMENT_ID, "DSC Comment", dscCommentTextStyle)
		acceptor.acceptDefaultHighlighting(UNPARSED_DATA_ID, "Unparsed Data", unparsedDataTextStyle)
	}

	def TextStyle literalNameTextStyle() {
		return defaultTextStyle.copy => [
			color = new RGB(128, 0, 255) // violet
			style = SWT.BOLD
		]
	}

	def TextStyle immediatelyEvaluatedNameTextStyle() {
		return defaultTextStyle.copy => [
			color = new RGB(255, 0, 255) // magenta
			style = SWT.BOLD
		]
	}

	def TextStyle dscCommentTextStyle() {
		return defaultTextStyle.copy => [
			color = new RGB(63, 95, 191) // grey blue
		]
	}

	def TextStyle unparsedDataTextStyle() {
		return defaultTextStyle.copy => [
			color = new RGB(42, 0, 255) // blue
			backgroundColor = new RGB(220, 220, 220) // light grey
		]
	}

}
