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
import de.tfritsch.psdt.PostscriptInjectorProvider
import de.tfritsch.psdt.postscript.PostscriptFactory
import org.eclipse.xtext.IGrammarAccess
import org.eclipse.xtext.documentation.IEObjectDocumentationProvider
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.junit.Test
import org.junit.runner.RunWith

import static org.junit.Assert.assertNotNull
import static org.junit.Assert.assertNull

/**
 * Run this as "JUnit Plugin Test",
 * because our DocumentationProvider needs the started org.eclipse.help plugin.
 * 
 * @author Thomas Fritsch - initial API and implementation
 */
@RunWith(XtextRunner)
@InjectWith(PostscriptInjectorProvider)
class DocumentationProviderTest {

	@Inject extension IEObjectDocumentationProvider

	@Inject IGrammarAccess grammarAccess

	@Inject extension PostscriptFactory

	@Test
	def testExecutableName() {
		val obj = createPSExecutableName => [name = "def"]
		assertNotNull(obj.documentation)
	}

	@Test
	def testExecutableName_notFound() {
		val obj = createPSExecutableName => [name = "Wrdlbrmpfd"]
		assertNull(obj.documentation)
	}

	@Test
	def testLiteralName() {
		val obj = createPSLiteralName => [name = "BuildGlyph"]
		assertNotNull(obj.documentation)
	}

	@Test
	def testLiteralName_notFound() {
		val obj = createPSLiteralName => [name = "Wrdlbrmpfd"]
		assertNull(obj.documentation)
	}

	@Test
	def testImmediatelyEvaluatedNameName() {
		val obj = createPSImmediatelyEvaluatedName => [name = "show"]
		assertNotNull(obj.documentation)
	}

	@Test
	def testKeyword() {
		val obj = grammarAccess.findKeywords("[").head
		assertNull(obj.documentation)
	}

}
