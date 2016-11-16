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
package de.tfritsch.psdt.ui.hover

import com.google.inject.Inject
import de.tfritsch.psdt.postscript.PSExecutableName
import de.tfritsch.psdt.postscript.PSImmediatelyEvaluatedName
import de.tfritsch.psdt.postscript.PSLiteralName
import de.tfritsch.psdt.ui.browser.BrowserOpener
import java.net.URL
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.EObject
import org.eclipse.jface.action.Action
import org.eclipse.jface.action.ActionContributionItem
import org.eclipse.jface.action.ToolBarManager
import org.eclipse.jface.text.IInformationControlCreator
import org.eclipse.jface.text.IRegion
import org.eclipse.swt.widgets.Display
import org.eclipse.xtext.ui.IImageHelper.IImageDescriptorHelper
import org.eclipse.xtext.ui.editor.hover.html.DefaultEObjectHoverProvider
import org.eclipse.xtext.ui.editor.hover.html.DefaultEObjectHoverProvider.OpenDeclarationAction
import org.eclipse.xtext.ui.editor.hover.html.DefaultEObjectHoverProvider.PresenterControlCreator
import org.eclipse.xtext.ui.editor.hover.html.IXtextBrowserInformationControl
import org.eclipse.xtext.ui.editor.hover.html.XtextBrowserInformationControlInput
import org.eclipse.xtext.ui.editor.hover.html.XtextElementLinks

import static extension de.tfritsch.psdt.help.PSHelpExtensions.getDocumentations
import static extension org.eclipse.jface.internal.text.html.HTMLPrinter.addPageEpilog
import static extension org.eclipse.jface.internal.text.html.HTMLPrinter.insertPageProlog

/**
 * @author Thomas Fritsch - initial API and implementation
 */
public class PostscriptHoverProvider extends DefaultEObjectHoverProvider {

	@Inject IImageDescriptorHelper imageHelper
	@Inject BrowserOpener browserOpener

	IInformationControlCreator presenterControlCreator

	override protected hasHover(EObject o) {
		super.hasHover(o) && getDocumentation(o) !== null
	}

	override protected getFirstLine(EObject o) {
		""
	}

	override protected getStyleSheet() '''
		«super.styleSheet ?: ""»
		th, td {
			vertical-align: top;
		}
		table {
			border-collapse: collapse;
		}
	'''

	override getInformationPresenterControlCreator() {
		if (presenterControlCreator === null) {
			presenterControlCreator = new PresenterControlCreator() {
				override protected configureControl(IXtextBrowserInformationControl control, ToolBarManager tbm,
					String font) {
					super.configureControl(control, tbm, font)

					// remove item "Open Declaration" (doesn't make sense for Postscript)
					tbm.items.filter(ActionContributionItem) //
					.filter[action instanceof OpenDeclarationAction] //
					.forEach[tbm.remove(it)]

					val openInBrowserAction = new Action("Open Doc in a Browser",
						imageHelper.getImageDescriptor("browser.png")) {
						override run() {
							val input = control.input
							if (input instanceof XtextBrowserInformationControlInput) {
								control.dispose
								val url = input.element.createURL
								browserOpener.openDocumentation(url)
							}
						}
					}
					tbm.add(openInBrowserAction)
					tbm.update(true)
				}
			}
		}
		presenterControlCreator
	}

	def protected createURL(EObject object) {
		val name = switch (object) {
			PSExecutableName:
				object.name
			PSLiteralName:
				object.name
			PSImmediatelyEvaluatedName:
				object.name
		}
		name.documentations.head.url
	}

	override protected getHoverInfo(EObject element, IRegion hoverRegion, XtextBrowserInformationControlInput previous) {
		var html = element.hoverInfoAsHtml
		if (html !== null) {
			val buffer = new StringBuffer(html)
			buffer.insertPageProlog(0, styleSheet)
			buffer.insertBase(element.createURL) // needed for relative HTML links to work
			buffer.addPageEpilog
			html = buffer.toString
			new XtextBrowserInformationControlInput(previous, element, html, labelProvider)
		} else
			null
	}

	def private void insertBase(StringBuffer it, URL base) {
		insert(indexOf("</head>"), '''<base href="«base»">''')
	}

	override protected addLinkListener(IXtextBrowserInformationControl control) {
		control.addLocationListener(
			elementLinks.createLocationListener(
				new XtextElementLinks.ILinkHandler {
					override handleXtextdocViewLink(URI linkTarget) {
					}

					override handleInlineXtextdocLink(URI linkTarget) {
					}

					override handleDeclarationLink(URI linkTarget) {
					}

					override handleExternalLink(URL url, Display display) {
						control.dispose
						browserOpener.openDocumentation(url)
						true
					}

					override handleTextSet() {
					}
				}))
	}
}
