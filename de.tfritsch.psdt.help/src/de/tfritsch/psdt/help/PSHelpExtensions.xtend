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
package de.tfritsch.psdt.help

import java.net.URL
import java.util.List
import org.eclipse.help.IHelpResource
import org.eclipse.xtend.lib.annotations.Accessors
import org.eclipse.xtend.lib.annotations.FinalFieldsConstructor
import org.eclipse.xtend.lib.annotations.ToString

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
		if (posHash >= 0)
			content.getTableRowById(href.substring(posHash + 1))
		else
			content.body
	}

	def private static String getTableRowById(String content, String trId) {
		val matcher = (".*(<tr>.*?</tr>).*(<tr id=\"" + trId + "\">.*?</tr>).*") //
		.compile(CASE_INSENSITIVE.bitwiseOr(DOTALL)) //
		.matcher(content)
		if (!matcher.matches)
			return null
		'''
			<table border="1">
			«matcher.group(1)»
			«matcher.group(2)»
			</table>
			<br><br><br>
		'''
	}

	def private static String getBody(String content) {
		val matcher = (".*<body>(.*)</body>.*") //
		.compile(CASE_INSENSITIVE.bitwiseOr(DOTALL)).matcher(content) //
		if (!matcher.matches)
			return null
		matcher.group(1)
	}

	@FinalFieldsConstructor
	@Accessors
	@ToString
	static class Documentation {
		val String label
		val URL url
	}

	def static URL getDocumentationURL(String name) {
		name.topics.head?.href?.toURL
	}

	def static List<Documentation> getDocumentations(String name) {
		name.topics.map[new Documentation(label, href?.toURL)]
	}

	def private static URL toURL(String href) {
		val url1 = new URL("platform:/plugin" + href)
		var url2 = url1.toFileURL
		if (url1.ref !== null && url2.ref === null)
			// work-around because FileLocator.toFileURL ignored URL.ref
			url2 = new URL(url2 + "#" + url1.ref)
		url2
	}

	def private static IHelpResource[] getTopics(String name) {
		("de.tfritsch.psdt.help." + name).context?.relatedTopics ?: newArrayOfSize(0)
	}
}
