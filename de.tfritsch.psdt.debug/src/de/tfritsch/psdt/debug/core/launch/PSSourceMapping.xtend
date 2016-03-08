/*******************************************************************************
 * Copyright (c) 2016 Thomas Fritsch.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
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
