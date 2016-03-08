/*******************************************************************************
 * Copyright (c) 2016 Thomas Fritsch.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
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

	override protected void configureFormatting(FormattingConfig c) {
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
