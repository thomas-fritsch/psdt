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
package de.tfritsch.psdt.tests.debug

import de.tfritsch.psdt.debug.IPSConstants
import de.tfritsch.psdt.debug.PSPlugin
import java.io.File
import org.eclipse.core.runtime.Platform
import org.junit.Test

import static org.junit.Assert.*

/**
 * @author Thomas Fritsch - initial API and implementation
 */
class PreferenceInitializerTest {

	val store = PSPlugin.^default.preferenceStore

	@Test
	def void testDebugDefaults() {
		assertFalse(store.getDefaultBoolean(IPSConstants.PREF_SHOW_SYSTEMDICT))
		assertTrue(store.getDefaultBoolean(IPSConstants.PREF_SHOW_GLOBALDICT))
		assertTrue(store.getDefaultBoolean(IPSConstants.PREF_SHOW_USERDICT))
	}

	@Test
	def void testGhostscriptDefaults() {
		val interpreter = store.getDefaultString(IPSConstants.PREF_INTERPRETER)
		assertNotNull(interpreter)
		val interpreterFile = new File(interpreter)
		assertTrue(interpreterFile.absolute)
		assertTrue(interpreterFile.exists)
		switch (Platform.getOS) {
			case Platform.OS_WIN32:
				assertTrue(#["gswin64c.exe", "gswin32c.exe"].contains(interpreterFile.name.toLowerCase))
			default:
				assertEquals("gs", interpreterFile.name)
		}
		val defaultGhostscriptArguments = store.getDefaultString(IPSConstants.PREF_DEFAULT_GS_ARGUMENTS)
		assertEquals("-dBATCH", defaultGhostscriptArguments)
	}
}
