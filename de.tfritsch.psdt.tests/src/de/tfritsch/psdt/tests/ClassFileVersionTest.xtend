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

import de.tfritsch.psdt.debug.core.model.PSVariable
import de.tfritsch.psdt.help.PSHelpExtensions
import de.tfritsch.psdt.postscript.PSObject
import de.tfritsch.psdt.ui.editor.PostscriptEditor
import java.io.DataInputStream
import java.util.List
import org.eclipse.xtend.lib.annotations.FinalFieldsConstructor
import org.junit.Test
import org.junit.runner.RunWith
import org.junit.runners.Parameterized

import static org.junit.Assert.assertEquals

/**
 * Check that all plugins are Java-6 compatible.
 * @author Thomas Fritsch - initial API and implementation
 */
@RunWith(Parameterized)
@FinalFieldsConstructor
class ClassFileVersionTest {

    static val JAVA_8_VERSION = "52.0"

	@Parameterized.Parameters(name="{0}")
	def static List<Object[]> getData() {
		#[
			#["help plugin", PSHelpExtensions],
			#["core plugin", PSObject],
			#["UI plugin", PostscriptEditor],
			#["debug plugin", PSVariable]
		]
	}

	val String name
	val Class<?> clazz

	@Test
	def void testClassFileVersion() {
		assertEquals(name, JAVA_8_VERSION, clazz.classFileVersion)
	}

	def private String getClassFileVersion(Class<?> clazz) {
		val resourceName = "/" + clazz.canonicalName.replace(".", "/") + ".class"
		val stream = new DataInputStream(clazz.getResourceAsStream(resourceName))
		stream.skip(4) // magic number
		val minorVersion = stream.readShort
		val majorVersion = stream.readShort
		stream.close
		majorVersion + "." + minorVersion
	}
}
