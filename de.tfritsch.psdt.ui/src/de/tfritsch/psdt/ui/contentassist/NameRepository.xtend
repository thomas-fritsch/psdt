/*******************************************************************************
 * Copyright (c) 2016 Thomas Fritsch.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 ******************************************************************************/
package de.tfritsch.psdt.ui.contentassist

import com.google.inject.Singleton
import java.util.List
import java.util.Scanner

/**
 * @author Thomas Fritsch - initial API and implementation
 */
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
