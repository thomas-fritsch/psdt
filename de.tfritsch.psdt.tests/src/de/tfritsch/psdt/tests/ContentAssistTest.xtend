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

import de.tfritsch.psdt.PostscriptUiInjectorProvider
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.xbase.junit.ui.AbstractContentAssistTest
import org.junit.Test
import org.junit.runner.RunWith

/**
 * Run this as "JUnit Plugin Test".
 * 
 * @author Thomas Fritsch - initial API and implementation
 */
@RunWith(XtextRunner)
@InjectWith(PostscriptUiInjectorProvider)
class ContentAssistTest extends AbstractContentAssistTest {

	@Test
	def void testLiteralName() throws Exception {
		newBuilder.append("/Time").assertText(
		    "/timeout",
			"/Times-Roman",
			"/Times-Bold",
			"/Times-Italic",
			"/Times-BoldItalic",
			"{",
			"[",
			"<<",
			"(abc)",
			"<616263>",
			"<~@:E^~>",
			"def - Template for a definition",
			"imagemask - Template for an imagemask statement",
			"loop - Template for a loop statement",
			"setpagedevice - Template for a setpagedevice statement",
			"stopped - Template for a try/catch statement"
		)
	}

    @Test
    def void testLiteralName_2() throws Exception {
        newBuilder.append("/sho").assertText(
            "/show",
            "/showpage",
            "{",
            "[",
            "<<",
            "(abc)",
            "<616263>",
            "<~@:E^~>",
            "def - Template for a definition",
            "imagemask - Template for an imagemask statement",
            "loop - Template for a loop statement",
            "setpagedevice - Template for a setpagedevice statement",
            "stopped - Template for a try/catch statement"
        )
    }

	@Test
	def void testExecutableName() throws Exception {
		newBuilder.append("sho").assertText(
			"show",
			"showpage",
			"{",
			"[",
			"<<",
			"(abc)",
			"<616263>",
			"<~@:E^~>",
			"def - Template for a definition",
			"imagemask - Template for an imagemask statement",
			"loop - Template for a loop statement",
			"setpagedevice - Template for a setpagedevice statement",
			"stopped - Template for a try/catch statement"
		)
	}

    @Test
    def void testExecutableName_2() throws Exception {
        newBuilder.append("Time").assertText(
            "timeout",
            "Times-Roman",
            "Times-Bold",
            "Times-Italic",
            "Times-BoldItalic",
            "{",
            "[",
            "<<",
            "(abc)",
            "<616263>",
            "<~@:E^~>",
            "def - Template for a definition",
            "imagemask - Template for an imagemask statement",
            "loop - Template for a loop statement",
            "setpagedevice - Template for a setpagedevice statement",
            "stopped - Template for a try/catch statement"
        )
    }

    @Test
	def void testImmediatelyEvaluatedName() throws Exception {
		newBuilder.append("//sh").assertText(
			"//ShadingType",
			"//shareddict",
			"//SharedFontDirectory",
			"//show",
			"//showpage",
			"{",
			"[",
			"<<",
			"(abc)",
			"<616263>",
			"<~@:E^~>",
			"def - Template for a definition",
			"imagemask - Template for an imagemask statement",
			"loop - Template for a loop statement",
			"setpagedevice - Template for a setpagedevice statement",
			"stopped - Template for a try/catch statement"
        )
    }

}
