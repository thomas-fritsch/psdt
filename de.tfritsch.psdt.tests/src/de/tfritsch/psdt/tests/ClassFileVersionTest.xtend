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
import org.junit.Test

import static org.junit.Assert.assertEquals

/**
 * Check that all plugins are Java-6 compatible.
 * @author Thomas Fritsch - initial API and implementation
 */
class ClassFileVersionTest {

	val JAVA_6_VERSION = "50.0"

	@Test
	def void testHelpPlugin() throws Exception {
		assertEquals(JAVA_6_VERSION, PSHelpExtensions.classFileVersion)
	}

	@Test
	def void testRuntimePlugin() throws Exception {
		assertEquals(JAVA_6_VERSION, PSObject.classFileVersion)
	}

	@Test
	def void testUIPlugin() throws Exception {
		assertEquals(JAVA_6_VERSION, PostscriptEditor.classFileVersion)
	}

	@Test
	def void testDebugPlugin() throws Exception {
		assertEquals(JAVA_6_VERSION, PSVariable.classFileVersion)
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
