/*******************************************************************************
 * Copyright (c) 2016 Thomas Fritsch.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 ******************************************************************************/
package de.tfritsch.psdt.tests

import com.google.inject.Inject
import de.tfritsch.psdt.PostscriptUiInjectorProvider
import de.tfritsch.psdt.ui.editor.PostscriptEditor
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

	override protected getFileExtension() {
		return fileExtensionProvider.primaryFileExtension
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
