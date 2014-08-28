package de.tfritsch.psdt.documentation

import de.tfritsch.psdt.postscript.PSExecutableName
import de.tfritsch.psdt.postscript.PSLiteralName
import java.io.IOException
import java.io.InputStreamReader
import java.io.Reader
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.documentation.IEObjectDocumentationProvider

import static extension java.util.regex.Pattern.*
import static extension org.eclipse.help.HelpSystem.*

class PostscriptDocumentationProvider implements IEObjectDocumentationProvider {

	def dispatch String getDocumentation(EObject o) {
		return null
	}

	def dispatch String getDocumentation(PSExecutableName o) {
		val href = o.name.href
		val content = href?.content
		if (content == null)
			return null
		val posHash = href.indexOf('#')
		val fragment = if(posHash >= 0) href.substring(posHash + 1) else ""
		val matcher = (".*<a name=\"" + fragment + "\"></a>(.*?)<hr>.*")
			.compile(CASE_INSENSITIVE.bitwiseOr(DOTALL)).matcher(content)
		if (!matcher.matches)
			return null
		return matcher.group(1)
	}

	def dispatch String getDocumentation(PSLiteralName o) {
		val href = o.name.href
		val content = href?.content
		if (content == null)
			return null
		val posHash = href.indexOf('#')
		val fragment = if(posHash >= 0) href.substring(posHash + 1) else ""
		val matcher = (".*(<tr>\\s*<th.*/th>\\s*</tr>).*(<tr>.*?<a name=\"" + fragment + "\"></a>.*?</tr>).*")
			.compile(CASE_INSENSITIVE.bitwiseOr(DOTALL)).matcher(content)
		if (!matcher.matches)
			return null
		val headerRow = matcher.group(1)
		val dataRow = matcher.group(2)
		return "<table border=\"1\">" + headerRow + dataRow + "</table><br><br><br>"
	}

	def private String getHref(String label) {
		val context = "de.tfritsch.psdt.help.Reference".context
		if (context == null)
			return null
		return context.relatedTopics.findFirst[it|it.label == label]?.href
	}

	def private String getContent(String href) {
		val input = href.helpContent
		if (input == null)
			return null
		val content = read(new InputStreamReader(input))
		try {
			input.close
		} catch (IOException e) {
		}
		return content
	}

	// copied from org.eclipse.jface.internal.text.html.HtmlPrinter
	def private static String read(Reader rd) {
		val buffer = new StringBuffer
		val readBuffer = newCharArrayOfSize(2048)
		try {
			var n = rd.read(readBuffer)
			while (n > 0) {
				buffer.append(readBuffer, 0, n)
				n = rd.read(readBuffer)
			}
			return buffer.toString
		} catch (IOException x) {
		}
		return null
	}
}