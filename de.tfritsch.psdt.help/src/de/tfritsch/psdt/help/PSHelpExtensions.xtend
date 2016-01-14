package de.tfritsch.psdt.help

import java.net.URL

import static extension java.util.regex.Pattern.*
import static extension org.eclipse.core.runtime.FileLocator.*
import static extension org.eclipse.help.HelpSystem.*
import static extension org.eclipse.xtext.util.Files.*

class PSHelpExtensions {

	def static String getDocumentationContent(String name) {
		val href = name.href
		val content = href?.helpContent?.readStreamIntoString
		if (content === null)
			return null
		val posHash = href.indexOf('#')
		if (posHash >= 0) {
			val fragment = href.substring(posHash + 1)
			val matcher = (".*(<tr>\\s*<th.*/th>\\s*</tr>).*(<tr>.*?<th id=\"" + fragment + "\">.*?</th>.*?</tr>).*").
				compile(CASE_INSENSITIVE.bitwiseOr(DOTALL)).matcher(content)
			if (!matcher.matches)
				return null
			return '''
				<table border="1">
				«matcher.group(1)»
				«matcher.group(2)»
				</table>
				<br><br><br>
			'''
		} else {
			val matcher = (".*<body>(.*)</body>.*").compile(CASE_INSENSITIVE.bitwiseOr(DOTALL)).matcher(content)
			if (!matcher.matches)
				return null
			return matcher.group(1)
		}
	}

	def static URL getDocumentationURL(String name) {
		val href = name.href
		return if(href !== null) new URL("platform:/plugin" + href).toFileURL else null
	}

	def private static String getHref(String name) {
		val context = ("de.tfritsch.psdt.help." + name).context
		return context?.relatedTopics?.head?.href
	}

}
