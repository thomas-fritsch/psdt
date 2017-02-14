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

import com.google.common.collect.AbstractIterator
import com.google.inject.Provider
import java.io.File
import java.io.FileOutputStream
import java.io.IOException
import java.io.OutputStreamWriter
import java.util.Iterator
import java.util.List
import javax.inject.Inject
import org.antlr.runtime.ANTLRFileStream
import org.antlr.runtime.CommonToken
import org.antlr.runtime.Token
import org.eclipse.core.runtime.CoreException
import org.eclipse.xtext.parser.antlr.Lexer

import static de.tfritsch.psdt.parser.antlr.internal.InternalPostscriptLexer.EOF
import static de.tfritsch.psdt.parser.antlr.internal.InternalPostscriptLexer.RULE_DSC_COMMENT
import static de.tfritsch.psdt.parser.antlr.internal.InternalPostscriptLexer.RULE_SL_COMMENT
import static de.tfritsch.psdt.parser.antlr.internal.InternalPostscriptLexer.RULE_WS

import static extension de.tfritsch.psdt.debug.PSPlugin.toCoreException

/**
 * @author Thomas Fritsch - initial API and implementation
 */
class DebugExtensions {

	@Inject
	Provider<Lexer> lexerProvider

	def List<PSToken> createSourceMapping(String psFile, String encoding) throws CoreException {
		try {
			(lexerProvider.get => [charStream = new ANTLRFileStream(psFile, encoding)]) //
			.iterator.filter [
				switch (type) {
					case Token.INVALID_TOKEN_TYPE:
						throw ("Invalid token in line " + line).toCoreException
					case RULE_WS,
					case RULE_SL_COMMENT,
					case RULE_DSC_COMMENT:
						false
					default:
						true
				}
			].map [
				if (it instanceof CommonToken)
					new PSToken(text, line, startIndex, stopIndex + 1)
				else
					new PSToken(text, line, -1, -1)
			].toList.unmodifiableView
		} catch (IOException e) {
			throw e.toCoreException
		}
	}

	private def Iterator<Token> iterator(Lexer lexer) {
		val AbstractIterator<Token> iterator = [
			val t = lexer.nextToken
			if (t.type == EOF) self.endOfData else t
		]
		iterator
    }

	def File createInstrumentedFile(List<PSToken> sourceMapping, String encoding) throws CoreException {
		try {
			val file = File.createTempFile("psdt", ".ps")
			val writer = new OutputStreamWriter(new FileOutputStream(file), encoding)
			writer.write("%!PS\n")
			writer.write("@@breakpoints 0 null put\n")
			sourceMapping.forEach[token, i|
				if (token.string != "}") // no stepping point just before }
					writer.write(i + " @@$ ")
				writer.write(token.string + "\n")
			]
			writer.close
			file
		} catch (IOException e) {
			throw e.toCoreException
		}
	}

}
