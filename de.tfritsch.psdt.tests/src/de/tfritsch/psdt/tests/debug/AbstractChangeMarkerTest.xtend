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

import de.tfritsch.psdt.debug.core.model.ChangeMarker
import org.eclipse.debug.core.model.IVariable
import org.eclipse.xtend.lib.annotations.Accessors

import static org.junit.Assert.assertEquals

/**
 * @author Thomas Fritsch - initial API and implementation
 */
abstract class AbstractChangeMarkerTest extends AbstractStatusParserTest {

	@Accessors
	static protected class TestData {
		CharSequence current
		CharSequence previous
		CharSequence expected
	}

	extension ChangeMarker = new ChangeMarker

	def protected void assertVariablesChanged((TestData)=>void initializer) throws Exception {
		new TestData => initializer => [
			val currentVariables = current.toVariables
			val previousVariables = previous.toVariables
			currentVariables.markChangesRelativeTo(previousVariables)
			assertEquals(expected.toString, currentVariables.toString)
		]
	}

	override protected toLine(IVariable it, int depth) throws Exception {
		if (hasValueChanged)
			super.toLine(it, depth).replaceFirstChar('*')
		else
			super.toLine(it, depth)
	}

	def private String replaceFirstChar(String s, char c) {
		c + s.substring(1)
	}

}
