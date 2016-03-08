/*******************************************************************************
 * Copyright (c) 2016 Thomas Fritsch.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
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
			"setpagedevice - Template for a setpagedevice statement",
			"stopped - Template for a try/catch statement"
		)
	}

}
