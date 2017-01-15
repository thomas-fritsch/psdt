/*******************************************************************************
 * Copyright (C) 2017  Thomas Fritsch.
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

import java.util.List
import org.eclipse.xtend.lib.annotations.FinalFieldsConstructor
import org.junit.Test
import org.junit.runner.RunWith
import org.junit.runners.Parameterized

import static org.junit.Assert.assertEquals
import static org.junit.Assert.assertNotNull
import static org.junit.Assert.assertNull

import static extension de.tfritsch.psdt.help.PSHelpExtensions.getDocumentationContent
import static extension de.tfritsch.psdt.help.PSHelpExtensions.getDocumentationURL
import static extension de.tfritsch.psdt.help.PSHelpExtensions.getDocumentations

/**
 * @author Thomas Fritsch - initial API and implementation
 */
@RunWith(Parameterized)
@FinalFieldsConstructor
class PSHelpExtensionsTest {

	@Parameterized.Parameters(name="{0}")
	def static List<Object[]> getData() {
		#[
			#["abs", 1],
			#["add", 1],
			#["currentpoint", 1],
			#["moveto", 1],
			//
			#["Font", 1],
			#["FontType", 2],
			#["Helvetica", 1],
			//
			#["wrdlbrnft", 0]
		]
	}

	val String name
	val int numberOfDocumentations

	@Test
	def void testGetDocumentationContent() {
		val content = name.documentationContent
		if (numberOfDocumentations > 0)
			assertNotNull(content)
		else
			assertNull(content)
	}

	@Test
	def void testGetDocumentationURL() {
		val url = name.documentationURL
		if (numberOfDocumentations > 0)
			assertNotNull(url)
		else
			assertNull(url)
	}

	@Test
	def void testGetDocumentations() {
		val documentations = name.documentations
		assertEquals(numberOfDocumentations, documentations.size)
		for (documentation : documentations) {
			assertNotNull(documentation.label)
			assertNotNull(documentation.url)
		}
	}

}
