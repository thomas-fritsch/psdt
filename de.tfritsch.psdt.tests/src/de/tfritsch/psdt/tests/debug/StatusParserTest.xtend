package de.tfritsch.psdt.tests.debug

import org.junit.Test

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
