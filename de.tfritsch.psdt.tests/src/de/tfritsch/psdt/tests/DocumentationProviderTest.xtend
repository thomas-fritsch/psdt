/*******************************************************************************
 * Copyright (c) 2016 Thomas Fritsch.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
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

import static org.junit.Assert.*

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
		val obj = createPSLiteralName => [name = "/BuildGlyph"]
		assertNotNull(obj.documentation)
	}

	@Test
	def testLiteralName_notFound() {
		val obj = createPSLiteralName => [name = "/Wrdlbrmpfd"]
		assertNull(obj.documentation)
	}

	@Test
	def testKeyword() {
		val obj = grammarAccess.findKeywords("[").head
		assertNull(obj.documentation)
	}

}
