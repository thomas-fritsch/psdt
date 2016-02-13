package de.tfritsch.psdt.tests.debug

import org.junit.Test

class ChangeMarkerTest extends AbstractChangeMarkerTest {

	@Test
	def void testUnchanged() throws Exception {
		new TestData [
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
		].assertVariablesChanged
	}

	@Test
	def testChanged() throws Exception {
		new TestData [
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
		].assertVariablesChanged
	}

	@Test
	def testAdded() throws Exception {
		new TestData [
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
		].assertVariablesChanged
	}

	@Test
	def testDeleted() throws Exception {
		new TestData [
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
		].assertVariablesChanged
	}
}
