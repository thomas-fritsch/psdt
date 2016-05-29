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
	def void testImmediatelyEvaluatedName() {
		'''
			//add
		'''.firstToken.textAttribute => [
			assertEquals(new RGB(255, 0, 255), foreground.RGB)
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
