/*******************************************************************************
 * Copyright (c) 2016 Thomas Fritsch.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 ******************************************************************************/
package de.tfritsch.psdt.tests;

import com.google.inject.Inject
import de.tfritsch.psdt.PostscriptUiInjectorProvider
import de.tfritsch.psdt.ui.editor.PostscriptEditor
import org.eclipse.swt.SWT
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.ui.AbstractAutoEditTest
import org.eclipse.xtext.resource.FileExtensionProvider
import org.junit.Test
import org.junit.runner.RunWith

/**
 * @author Thomas Fritsch - initial API and implementation
 */
@SuppressWarnings("restriction")
@RunWith(XtextRunner)
@InjectWith(PostscriptUiInjectorProvider)
public class AutoEditTest extends AbstractAutoEditTest {

	@Inject FileExtensionProvider fileExtensionProvider

	override protected getFileExtension() {
		return fileExtensionProvider.primaryFileExtension
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
