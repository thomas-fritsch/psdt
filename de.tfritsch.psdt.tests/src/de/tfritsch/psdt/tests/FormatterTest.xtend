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
import de.tfritsch.psdt.postscript.PSFile
import org.eclipse.xtext.formatting.INodeModelFormatter
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.util.ParseHelper
import org.junit.Test
import org.junit.runner.RunWith

import static org.junit.Assert.assertEquals

import static extension org.eclipse.xtext.nodemodel.util.NodeModelUtils.getNode

/**
 * @author Thomas Fritsch - initial API and implementation
 */
@RunWith(XtextRunner)
@InjectWith(PostscriptInjectorProvider)
class FormatterTest {

	@Inject extension ParseHelper<PSFile>
	@Inject extension INodeModelFormatter

	def protected assertFormatted(CharSequence input, CharSequence expectedOutput) throws Exception {
		val output = input.parse.node.format(0, input.length).formattedText
		assertEquals(expectedOutput.toString, output)
	}

	@Test
	def void testMaxLineLength() throws Exception {
		'''
			123456789 123456789 123456789 123456789 123456789 123456789 123456789 1 3 56789
		'''.assertFormatted(
			'''
			123456789 123456789 123456789 123456789 123456789 123456789 123456789 1
			3 56789''')
	}

	@Test
	def void testProcedure() throws Exception {
		'''
			aa { A B } zz
		'''.assertFormatted(
			'''
			aa {
				A B
			} zz''')
	}

	@Test
	def void testDictionary() throws Exception {
		'''aa << A B >> zz'''.assertFormatted(
			'''
			aa <<
				A B
			>> zz''')
	}

	@Test
	def void testArray() throws Exception {
		'''aa [ A B ] zz'''.assertFormatted('''aa [A B] zz''')
	}
}
