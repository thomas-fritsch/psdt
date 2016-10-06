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

import org.eclipse.emf.ecore.EObject
import org.eclipse.jface.action.ActionContributionItem
import org.eclipse.jface.action.ToolBarManager
import org.eclipse.jface.text.IInformationControlCreator
import org.eclipse.xtext.ui.editor.hover.html.DefaultEObjectHoverProvider
import org.eclipse.xtext.ui.editor.hover.html.IXtextBrowserInformationControl

/**
 * @author Thomas Fritsch - initial API and implementation
 */
public class PostscriptHoverProvider extends DefaultEObjectHoverProvider {

	IInformationControlCreator presenterControlCreator

	override protected hasHover(EObject o) {
		super.hasHover(o) && getDocumentation(o) !== null
	}

	override protected getFirstLine(EObject o) {
		""
	}

	override protected getStyleSheet() {
		var css = super.getStyleSheet
		if (css !== null)
			css += "th, td { vertical-align: top; }\n"
		css
	}

	override getInformationPresenterControlCreator() {
		if (presenterControlCreator === null) {
			presenterControlCreator = new PresenterControlCreator() {
				override protected configureControl(IXtextBrowserInformationControl control, ToolBarManager tbm,
					String font) {
					super.configureControl(control, tbm, font)

					// remove item "Open Declaration" (doesn't make sense for Postscript)
					for (item : tbm.items) {
						if (item instanceof ActionContributionItem) {
							if (item.action instanceof OpenDeclarationAction)
								tbm.remove(item)
						}
					}
					tbm.update(true)
				}
			}
		}
		presenterControlCreator
	}

}
