/*******************************************************************************
 * Copyright (c) 2016 Thomas Fritsch.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
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
