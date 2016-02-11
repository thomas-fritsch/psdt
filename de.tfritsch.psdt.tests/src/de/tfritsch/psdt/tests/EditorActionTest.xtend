package de.tfritsch.psdt.tests

import de.tfritsch.psdt.PostscriptUiInjectorProvider
import de.tfritsch.psdt.ui.editor.PostscriptEditor
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.ui.AbstractAutoEditTest
import org.junit.Test
import org.junit.runner.RunWith
import org.eclipse.xtext.ui.editor.XtextEditor

@SuppressWarnings("restriction")
@RunWith(XtextRunner)
@InjectWith(PostscriptUiInjectorProvider)
class EditorActionTest extends AbstractAutoEditTest {

	val static TOGGLE_COMMENT = "ToggleComment"

	override protected getFileExtension() {
		return "ps"
	}

	override protected getEditorId() {
		return PostscriptEditor.ID
	}

	def protected void toggleComment(XtextEditor editor) {
		val action = editor.getAction(TOGGLE_COMMENT)
		action.run
	}

	@Test
	def void testToggleComment() {
		val editor = openEditor(
			'''
				aa bb
				|cc dd
				ee ff
				gg hh
			''')
		editor.selectText(0, 5)
		editor.toggleComment
		'''
			aa bb
			|%cc dd
			ee ff
			gg hh
		'''.toString.assertState(editor)
		editor.toggleComment
		'''
			aa bb
			|cc dd
			ee ff
			gg hh
		'''.toString.assertState(editor)

	}
}
