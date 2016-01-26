package de.tfritsch.psdt.debug.core.launch

import com.google.inject.Provider
import de.tfritsch.psdt.debug.PSPlugin
import java.io.File
import java.io.FileWriter
import java.io.IOException
import javax.inject.Inject
import org.antlr.runtime.ANTLRFileStream
import org.antlr.runtime.CommonToken
import org.eclipse.core.runtime.CoreException
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.xtext.parser.antlr.Lexer

import static de.tfritsch.psdt.parser.antlr.internal.InternalPostscriptLexer.*

import static extension de.tfritsch.psdt.debug.PSLaunchExtensions.*

class DebugExtensions {

	@Inject
	Provider<Lexer> lexerProvider

	def PSSourceMapping createSourceMapping(String psFile, IProgressMonitor monitor) throws CoreException {
		val sourceMapping = new PSSourceMapping
		try {
			val lexer = lexerProvider.get
			lexer.charStream = new ANTLRFileStream(psFile)
			var token = lexer.nextToken
			while (token.type !== EOF) {
				if (monitor.canceled) {
					return null
				}
				switch (token.type) {
					case RULE_LITERAL_ID,
					case RULE_ID,
					case RULE_INT,
					case RULE_FLOAT,
					case RULE_STRING,
					case RULE_ASCII_HEX_STRING,
					case RULE_ASCII_85_STRING,
					case T__21, // {
					case T__22, // }
					case T__23, // [
					case T__24, // ]
					case T__25, // <<
					case T__26, // >>
					case RULE_UNPARSED_DATA: {
						if (token instanceof CommonToken)
							sourceMapping.add(new PSToken(token.text, token.line, token.startIndex, token.stopIndex + 1))
						else
							sourceMapping.add(new PSToken(token.text, token.line, -1, -1))
					}
				}
				token = lexer.nextToken
			}
		} catch (IOException e) {
			PSPlugin.abort(e.toString, e)
		}
		return sourceMapping
	}

	def File createInstrumentedFile(PSSourceMapping sourceMapping, IProgressMonitor monitor) throws CoreException {
		try {
			val file = File.createTempFile("psdt", ".ps")
			val writer = new FileWriter(file)
			writer.write("%!PS\n")
			writer.write("@@breakpoints 0 null put\n")
			val store = PSPlugin.^default.preferenceStore
			writer.write(
				!store.showSystemdict + " " + !store.showGlobaldict + " " + !store.showUserdict + " @@stathide\n")
			for (i : 0 ..< sourceMapping.size) {
				if (monitor.canceled) {
					writer.close
					file.delete
					return null
				}
				val string = sourceMapping.getString(i)
				if (string != "}") // no stepping point just before }
					writer.write(i + " @@$ ")
				writer.write(string + "\n")
			}
			writer.close
			return file
		} catch (IOException e) {
			PSPlugin.abort(e.message, e)
			return null
		}
	}

}
