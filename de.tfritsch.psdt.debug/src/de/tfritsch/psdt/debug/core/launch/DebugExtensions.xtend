package de.tfritsch.psdt.debug.core.launch

import com.google.inject.Provider
import java.io.File
import java.io.FileWriter
import java.io.IOException
import javax.inject.Inject
import org.antlr.runtime.ANTLRFileStream
import org.antlr.runtime.CommonToken
import org.antlr.runtime.Token
import org.eclipse.core.runtime.CoreException
import org.eclipse.xtext.parser.antlr.Lexer

import static de.tfritsch.psdt.parser.antlr.internal.InternalPostscriptLexer.*

import static extension de.tfritsch.psdt.debug.PSPlugin.*

class DebugExtensions {

	@Inject
	Provider<Lexer> lexerProvider

	def PSSourceMapping createSourceMapping(String psFile) throws CoreException {
		val sourceMapping = new PSSourceMapping
		try {
			val lexer = lexerProvider.get
			lexer.charStream = new ANTLRFileStream(psFile)
			for (var token = lexer.nextToken; token.type !== EOF; token = lexer.nextToken) {
				switch (token.type) {
					case Token.INVALID_TOKEN_TYPE:
						throw ("Invalid token in line " + token.line).toCoreException
					case RULE_WS,
					case RULE_SL_COMMENT,
					case RULE_DSC_COMMENT: {
						// do nothing
					}
					default: {
						if (token instanceof CommonToken)
							sourceMapping.add(new PSToken(token.text, token.line, token.startIndex, token.stopIndex + 1))
						else
							sourceMapping.add(new PSToken(token.text, token.line, -1, -1))
					}
				}
			}
		} catch (IOException e) {
			throw e.toCoreException
		}
		return sourceMapping
	}

	def File createInstrumentedFile(PSSourceMapping sourceMapping) throws CoreException {
		try {
			val file = File.createTempFile("psdt", ".ps")
			val writer = new FileWriter(file)
			writer.write("%!PS\n")
			writer.write("@@breakpoints 0 null put\n")
			for (i : 0 ..< sourceMapping.size) {
				val string = sourceMapping.getString(i)
				if (string != "}") // no stepping point just before }
					writer.write(i + " @@$ ")
				writer.write(string + "\n")
			}
			writer.close
			return file
		} catch (IOException e) {
			throw e.toCoreException
		}
	}

}
