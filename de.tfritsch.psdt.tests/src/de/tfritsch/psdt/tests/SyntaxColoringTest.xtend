/*******************************************************************************
 * Copyright (c) 2016 Thomas Fritsch.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 ******************************************************************************/
package de.tfritsch.psdt.tests

import com.google.inject.Inject
import com.google.inject.Provider
import de.tfritsch.psdt.PostscriptUiInjectorProvider
import org.eclipse.jface.text.TextAttribute
import org.eclipse.jface.text.rules.IToken
import org.eclipse.jface.text.rules.ITokenScanner
import org.eclipse.swt.SWT
import org.eclipse.swt.graphics.RGB
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.ui.editor.model.XtextDocument
import org.junit.Test
import org.junit.runner.RunWith

import static org.junit.Assert.*

/**
 * @author Thomas Fritsch - initial API and implementation
 */
@RunWith(XtextRunner)
@InjectWith(PostscriptUiInjectorProvider)
class SyntaxColoringTest {

	@Inject Provider<XtextDocument> documentProvider
	@Inject ITokenScanner tokenScanner

	def protected IToken getFirstToken(CharSequence input) {
		val document = documentProvider.get
		document.set(input.toString)
		tokenScanner.setRange(document, 0, document.length)
		return tokenScanner.nextToken
	}

	def protected TextAttribute getTextAttribute(IToken token) {
		val data = token.data
		return if (data instanceof TextAttribute)
			data
		else
			new TextAttribute(null)
	}

	@Test
	def void testLiteralName() {
		'''
			/PageSize
		'''.firstToken.textAttribute => [
			assertEquals(new RGB(128, 0, 255), foreground.RGB)
			assertNull(background)
			assertEquals(SWT.BOLD, style)
			assertNull(font)
		]
	}

	@Test
	def void testDSCComment() {
		'''
			%%Pages: 50
		'''.firstToken.textAttribute => [
			assertEquals(new RGB(63, 95, 191), foreground.RGB)
			assertNull(background)
			assertEquals(SWT.NORMAL, style)
			assertNull(font)
		]
	}

	@Test
	def void testUnparsedData() {
		'''
			%%BeginData: 2 ASCII lines
			abcdefghijklm
			nopqrstuvwxyz
			%%EndData 
		'''.firstToken.textAttribute => [
			assertEquals(new RGB(42, 0, 255), foreground.RGB)
			assertEquals(new RGB(220, 220, 220), background.RGB)
			assertEquals(SWT.NORMAL, style)
			assertNull(font)
		]
	}
}
