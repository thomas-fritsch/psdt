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

import org.junit.Test

/**
 * @author Thomas Fritsch - initial API and implementation
 */
class StatusParserTest extends AbstractStatusParserTest {

	@Test
	def void testTypical() throws Exception {
		'''
			+ operandstack: --array--
			+ execstack: --array--
			++ 00000: --%interp_exit--
			++ 00024: --%stopped_push--
			++ 00025: --file--
			+ dictstack: --array--
			++ 00000: --systemdict--
			++ 00001: --globaldictict--
			++ 00002: --userdict--
			+ watches: --array--
			+ state: --array--
			++ currentglobal: false
			++ currentrgbcolor: --dict--
			+++ red: 1.0
			+++ green: 1.0
			+++ blue: 1.0
			++ currentpoint: --dict--
			+++ x: 50.0
			+++ y: 600.0
		'''.assertStatusParsed(
			'''
				+ dictstack: --array--
				++ 00000: --systemdict--
				++ 00001: --globaldictict--
				++ 00002: --userdict--
				+ execstack: --array--
				++ 00000: --%interp_exit--
				++ 00024: --%stopped_push--
				++ 00025: --file--
				+ operandstack: --array--
				+ state: --array--
				++ currentglobal: false
				++ currentpoint: --dict--
				+++ x: 50.0
				+++ y: 600.0
				++ currentrgbcolor: --dict--
				+++ blue: 1.0
				+++ green: 1.0
				+++ red: 1.0
				+ watches: --array--
			''')
	}
}
