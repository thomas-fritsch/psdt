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
package de.tfritsch.psdt.debug.core.launch

import java.util.List

/**
 * @author Thomas Fritsch - initial API and implementation
 */
class PSSourceMapping {

	List<PSToken> tokens = newArrayList

	def add(PSToken token) {
		tokens += token
	}

	def int getSize() {
		tokens.size
	}

	def getString(int tokenIndex) {
		if(tokenIndex.valid) tokens.get(tokenIndex).string else null
	}

	def getLineNumber(int tokenIndex) {
		if(tokenIndex.valid) tokens.get(tokenIndex).lineNumber else -1
	}

	def getCharStart(int tokenIndex) {
		if(tokenIndex.valid) tokens.get(tokenIndex).charStart else -1
	}

	def getCharEnd(int tokenIndex) {
		if(tokenIndex.valid) tokens.get(tokenIndex).charEnd else -1
	}

	def private isValid(int tokenIndex) {
		return tokenIndex >= 0 && tokenIndex < tokens.size
	}
}
