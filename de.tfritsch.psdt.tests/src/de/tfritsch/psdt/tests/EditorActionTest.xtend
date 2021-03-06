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
import org.eclipse.xtext.LanguageInfo
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.ui.AbstractAutoEditTest
import org.eclipse.xtext.resource.FileExtensionProvider
import org.eclipse.xtext.ui.editor.XtextEditor
import org.junit.Test
import org.junit.runner.RunWith

/**
 * @author Thomas Fritsch - initial API and implementation
 */
@SuppressWarnings("restriction")
@RunWith(XtextRunner)
@InjectWith(PostscriptUiInjectorProvider)
class EditorActionTest extends AbstractAutoEditTest {

	val static TOGGLE_COMMENT = "ToggleComment"

	@Inject FileExtensionProvider fileExtensionProvider
	@Inject LanguageInfo languageInfo

	override protected getFileExtension() {
		fileExtensionProvider.primaryFileExtension
	}

	override protected getEditorId() {
		languageInfo.languageName
	}

	def protected void toggleComment(XtextEditor editor) {
		val action = editor.getAction(TOGGLE_COMMENT)
		action.run
	}

	@Test
	def void testToggleComment() throws Exception {
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
