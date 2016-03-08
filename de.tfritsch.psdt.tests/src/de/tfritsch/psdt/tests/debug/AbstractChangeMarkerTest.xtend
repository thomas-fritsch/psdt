/*******************************************************************************
 * Copyright (c) 2016 Thomas Fritsch.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 ******************************************************************************/
package de.tfritsch.psdt.tests.debug

import org.eclipse.debug.core.model.IVariable
import org.eclipse.xtend.lib.annotations.Accessors
import de.tfritsch.psdt.debug.core.model.ChangeMarker
import static org.junit.Assert.*

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
		val it = new TestData
		initializer.apply(it)
		val currentVariables = current.toVariables
		val previousVariables = previous.toVariables
		currentVariables.markChangesRelativeTo(previousVariables)
		assertEquals(expected.toString, currentVariables.toString)
	}

	override protected toLine(IVariable it, int depth) throws Exception {
		return if (hasValueChanged)
			super.toLine(it, depth).replaceFirstChar('*')
		else
			super.toLine(it, depth)
	}

	def private String replaceFirstChar(String s, char c) {
		return c + s.substring(1)
	}

}
