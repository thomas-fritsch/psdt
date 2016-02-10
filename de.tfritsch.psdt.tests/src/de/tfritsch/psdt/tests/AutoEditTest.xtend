package de.tfritsch.psdt.tests;

import de.tfritsch.psdt.PostscriptUiInjectorProvider
import de.tfritsch.psdt.ui.editor.PostscriptEditor
import org.eclipse.swt.SWT
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.ui.AbstractAutoEditTest
import org.junit.Test
import org.junit.runner.RunWith

@SuppressWarnings("restriction")
@RunWith(XtextRunner)
@InjectWith(PostscriptUiInjectorProvider)
public class AutoEditTest extends AbstractAutoEditTest {

	override protected getFileExtension() {
		return "ps"
	}

	override protected getEditorId() {
		return PostscriptEditor.ID
	}

	@Test
	def void testCurlyBraces() throws Exception {
		val editor = openEditor("|")
		editor.pressKey('{')
		"{|}".assertState(editor)
		editor.pressKey(SWT.BS)
		"|".assertState(editor)
	}

	@Test
	def void testBrackets() throws Exception {
		val editor = openEditor("|")
		editor.pressKey('[')
		"[|]".assertState(editor)
		editor.pressKey(SWT.BS)
		"|".assertState(editor)
	}

	@Test
	def void testParenthesis() throws Exception {
		val editor = openEditor("|")
		editor.pressKey('(')
		"(|)".assertState(editor)
		editor.pressKey(SWT.BS)
		"|".assertState(editor)
	}

	@Test
	def void testAngleBrackets() throws Exception {
		val editor = openEditor("|")
		editor.pressKey('<')
		"<|>".assertState(editor)
		editor.pressKey(SWT.BS)
		"|".assertState(editor)
	}

}
