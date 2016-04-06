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
