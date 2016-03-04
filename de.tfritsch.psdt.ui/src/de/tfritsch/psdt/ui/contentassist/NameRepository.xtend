package de.tfritsch.psdt.ui.contentassist

import com.google.inject.Singleton
import java.util.List
import java.util.Scanner

@Singleton
class NameRepository {

	List<String> executableNames = "executable-names.txt".readNames
	List<String> literalNames = "literal-names.txt".readNames

	def private readNames(String fileName) {
		val stream = ^class.getResourceAsStream(fileName)
		val scanner = new Scanner(stream)
		val names = scanner.toList
		scanner.close
		names
	}
	
	def getExecutableNames() {
		executableNames
	}

	def getLiteralNames() {
		literalNames
	}
}
