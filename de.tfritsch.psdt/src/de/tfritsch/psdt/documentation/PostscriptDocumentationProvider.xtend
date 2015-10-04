package de.tfritsch.psdt.documentation

import de.tfritsch.psdt.postscript.PSExecutableName
import de.tfritsch.psdt.postscript.PSLiteralName
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.documentation.IEObjectDocumentationProvider

import static extension java.util.regex.Pattern.*
import static extension org.eclipse.help.HelpSystem.*
import static extension org.eclipse.xtext.util.Files.*

class PostscriptDocumentationProvider implements IEObjectDocumentationProvider {

	def dispatch String getDocumentation(EObject o) {
		return null
	}

	def dispatch String getDocumentation(PSExecutableName o) {
		val content = o.name.href?.content
		if (content == null)
			return null
		val matcher = (".*<body>(.*)</body>.*")
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
		val matcher = (".*(<tr>\\s*<th.*/th>\\s*</tr>).*(<tr>.*?<th id=\"" + fragment + "\">.*?</th>.*?</tr>).*")
			.compile(CASE_INSENSITIVE.bitwiseOr(DOTALL)).matcher(content)
		if (!matcher.matches)
			return null
		return '''
			<table border="1">
			«matcher.group(1)»
			«matcher.group(2)»
			</table>
			<br><br><br>
		'''
	}

	def private String getHref(String name) {
		val context = ("de.tfritsch.psdt.help." + name).context
		if (context == null)
			return null
		return context.relatedTopics.head?.href
	}

	def private String getContent(String href) {
		return href.helpContent?.readStreamIntoString
	}
}