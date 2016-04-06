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
class ChangeMarkerTest extends AbstractChangeMarkerTest {

	@Test
	def void testUnchanged() throws Exception {
		assertVariablesChanged [
			current = '''
				+ d: --dict--
				++ a: 1
				++ b: 2
			'''
			previous = '''
				+ d: --dict--
				++ a: 1
				++ b: 2
			'''
			expected = '''
				+ d: --dict--
				++ a: 1
				++ b: 2
			'''
		]
	}

	@Test
	def testChanged() throws Exception {
		assertVariablesChanged [
			current = '''
				+ d: --dict--
				++ a: 1
				++ b: 22
			'''
			previous = '''
				+ d: --dict--
				++ a: 1
				++ b: 2
			'''
			expected = '''
				* d: --dict--
				++ a: 1
				*+ b: 22
			'''
		]
	}

	@Test
	def testAdded() throws Exception {
		assertVariablesChanged [
			current = '''
				+ d: --dict--
				++ a: 1
				++ b: 2
				++ c: 3
			'''
			previous = '''
				+ d: --dict--
				++ a: 1
				++ b: 2
			'''
			expected = '''
				* d: --dict--
				++ a: 1
				++ b: 2
				*+ c: 3
			'''
		]
	}

	@Test
	def testAddedWithNested() throws Exception {
		assertVariablesChanged [
			current = '''
				+ d: --dict--
				++ a: 1
				++ b: 2
				++ c: 3
				+++ x: 4
				+++ y: 5
			'''
			previous = '''
				+ d: --dict--
				++ a: 1
				++ b: 2
			'''
			expected = '''
				* d: --dict--
				++ a: 1
				++ b: 2
				*+ c: 3
				*++ x: 4
				*++ y: 5
			'''
		]
	}

	@Test
	def testDeleted() throws Exception {
		assertVariablesChanged [
			current = '''
				+ d: --dict--
				++ a: 1
			'''
			previous = '''
				+ d: --dict--
				++ a: 1
				++ b: 2
			'''
			expected = '''
				* d: --dict--
				++ a: 1
			'''
		]
	}
}
