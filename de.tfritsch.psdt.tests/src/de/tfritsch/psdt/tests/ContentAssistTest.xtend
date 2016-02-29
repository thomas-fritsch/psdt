package de.tfritsch.psdt.tests

import de.tfritsch.psdt.PostscriptUiInjectorProvider
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.xbase.junit.ui.AbstractContentAssistTest
import org.junit.Test
import org.junit.runner.RunWith

/**
 * Run this as "JUnit Plugin Test".
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
			"String - ASCII String",
			"String - ASCII85 String",
			"String - ASCIIHex String",
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
			"String - ASCII String",
			"String - ASCII85 String",
			"String - ASCIIHex String",
			"def - Template for a definition",
			"imagemask - Template for an imagemask statement",
			"setpagedevice - Template for a setpagedevice statement",
			"stopped - Template for a try/catch statement"
		)
	}

}
