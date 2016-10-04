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
package de.tfritsch.psdt.formatting

import com.google.inject.Inject
import de.tfritsch.psdt.services.PostscriptGrammarAccess
import org.eclipse.xtext.formatting.impl.AbstractDeclarativeFormatter
import org.eclipse.xtext.formatting.impl.FormattingConfig

/**
 * This class contains custom formatting description.
 * 
 * see : http://www.eclipse.org/Xtext/documentation.html#formatting
 * on how and when to use it 
 * 
 * Also see {@link org.eclipse.xtext.xtext.XtextFormattingTokenSerializer} as an example
 *
 * @author Thomas Fritsch - initial API and implementation
 */
class PostscriptFormatter extends AbstractDeclarativeFormatter {

	@Inject extension PostscriptGrammarAccess

	override protected configureFormatting(FormattingConfig c) {
		c.setAutoLinewrap(72)

		c.setLinewrap(0, 1, 2).before(SL_COMMENTRule)
		c.setLinewrap(1, 1, 2).before(DSC_COMMENTRule)
		c.setLinewrap(1, 1, 2).before(UNPARSED_DATARule)

		for (pair : findKeywordPairs("{", "}")) {
			c.setIndentation(pair.first, pair.second)
			c.setLinewrap.after(pair.first)
			c.setLinewrap.before(pair.second)
		}
		for (pair : findKeywordPairs("<<", ">>")) {
			c.setIndentation(pair.first, pair.second)
			c.setLinewrap.after(pair.first)
			c.setLinewrap.before(pair.second)
		}
		for (pair : findKeywordPairs("[", "]")) {
			c.setNoSpace.after(pair.first)
			c.setNoSpace.before(pair.second)
		}
	}
}
