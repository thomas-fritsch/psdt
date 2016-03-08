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
import de.tfritsch.psdt.postscript.PSFile
import org.eclipse.xtext.formatting.INodeModelFormatter
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.junit.Test
import org.junit.runner.RunWith

import static org.junit.Assert.*

import static extension org.eclipse.xtext.nodemodel.util.NodeModelUtils.*

/**
 * @author Thomas Fritsch - initial API and implementation
 */
@RunWith(XtextRunner)
@InjectWith(PostscriptInjectorProvider)
class FormatterTest {

	@Inject extension ParseHelper<PSFile>
	@Inject extension INodeModelFormatter

	def protected assertFormatted(CharSequence input, CharSequence expectedOutput) {
		val output = input.parse.node.format(0, input.length).formattedText
		assertEquals(expectedOutput.toString, output)
	}

	@Test
	def void testMaxLineLength() {
		'''
			123456789 123456789 123456789 123456789 123456789 123456789 123456789 1 3 56789
		'''.assertFormatted(
			'''
			123456789 123456789 123456789 123456789 123456789 123456789 123456789 1
			3 56789''')
	}

	@Test
	def void testProcedure() {
		'''
			aa { A B } zz
		'''.assertFormatted(
			'''
			aa {
				A B
			} zz''')
	}

	@Test
	def void testDictionary() {
		'''aa << A B >> zz'''.assertFormatted(
			'''
			aa <<
				A B
			>> zz''')
	}

	@Test
	def void testArray() {
		'''aa [ A B ] zz'''.assertFormatted('''aa [A B] zz''')
	}
}
