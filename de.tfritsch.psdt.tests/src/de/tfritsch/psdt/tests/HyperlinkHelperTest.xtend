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
package de.tfritsch.psdt.tests

import com.google.inject.Inject
import de.tfritsch.psdt.PostscriptUiInjectorProvider
import de.tfritsch.psdt.postscript.PSFile
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.eclipse.xtext.resource.XtextResource
import org.eclipse.xtext.ui.editor.hyperlinking.IHyperlinkHelper
import org.junit.Test
import org.junit.runner.RunWith

import static org.junit.Assert.*

/**
 * @author Thomas Fritsch - initial API and implementation
 */
@RunWith(XtextRunner)
@InjectWith(PostscriptUiInjectorProvider)
class HyperlinkHelperTest {

	@Inject extension ParseHelper<PSFile>
	@Inject extension IHyperlinkHelper

	@Test
	def void testUnknown() throws Exception {
		val resource = '''
			unknown
		'''.parse.eResource as XtextResource
		val hyperlinks = resource.createHyperlinksByOffset(0, true)
		assertNull(hyperlinks)
	}

	@Test
	def void testShow() throws Exception {
		val resource = '''
			(Hello) show
		'''.parse.eResource as XtextResource
		val hyperlinks = resource.createHyperlinksByOffset(10, true)
		assertEquals(#["Operator"], hyperlinks.map[hyperlinkText])
	}

	@Test
	def void testFontType() throws Exception {
		val resource = '''
			/FontType 3
		'''.parse.eResource as XtextResource
		val hyperlinks = resource.createHyperlinksByOffset(0, true)
		assertEquals(
			#["Entry in a font dictionary", "Resource category"],
			hyperlinks.map[hyperlinkText]
		)
	}
}
