/*******************************************************************************
 * Copyright (c) 2016 Thomas Fritsch.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 ******************************************************************************/
package de.tfritsch.psdt.help

import java.net.URL
import java.util.List
import org.eclipse.help.IHelpResource
import org.eclipse.xtend.lib.annotations.Data

import static extension java.util.regex.Pattern.*
import static extension org.eclipse.core.runtime.FileLocator.*
import static extension org.eclipse.help.HelpSystem.*
import static extension org.eclipse.xtext.util.Files.*

/**
 * @author Thomas Fritsch - initial API and implementation
 */
class PSHelpExtensions {

	def static String getDocumentationContent(String name) {
		val href = name.topics.head?.href
		val content = href?.helpContent?.readStreamIntoString
		if (content === null)
			return null
		val posHash = href.indexOf('#')
		if (posHash >= 0) {
			val fragment = href.substring(posHash + 1)
			val matcher = (".*(<tr>.*?</tr>).*(<tr id=\"" + fragment + "\">.*?</tr>).*").
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

	@Data
	static class Documentation {
		String label
		URL url
	}

	def static List<Documentation> getDocumentations(String name) {
		return name.topics.map[new Documentation(label, href?.toURL)]
	}

	def private static URL toURL(String href) {
		val url1 = new URL("platform:/plugin" + href)
		var url2 = url1.toFileURL
		if (url1.ref !== null && url2.ref === null)
			// work-around because FileLocator.toFileURL ignored URL.ref
			url2 = new URL(url2.toString + "#" + url1.ref)
		return url2
	}

	def private static IHelpResource[] getTopics(String name) {
		val context = ("de.tfritsch.psdt.help." + name).context
		return if(context !== null) context.relatedTopics else #[]
	}
}
