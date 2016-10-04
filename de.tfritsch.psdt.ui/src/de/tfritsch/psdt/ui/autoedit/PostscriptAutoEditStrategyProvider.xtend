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
package de.tfritsch.psdt.ui.autoedit

import org.eclipse.jface.text.IDocument
import org.eclipse.xtext.ui.editor.autoedit.DefaultAutoEditStrategyProvider

/**
 * @author Thomas Fritsch - initial API and implementation
 */
class PostscriptAutoEditStrategyProvider extends DefaultAutoEditStrategyProvider {

	override protected configureMultilineComments(IEditStrategyAcceptor acceptor) {
		// do nothing
	}

	override protected configureStringLiteral(IEditStrategyAcceptor acceptor) {
		acceptor.accept(partitionInsert.newInstance("(", ")"), IDocument.DEFAULT_CONTENT_TYPE)
		acceptor.accept(partitionInsert.newInstance("<", ">"), IDocument.DEFAULT_CONTENT_TYPE)

		// The following two are registered for the default content type, because on deletion 
		// the command.offset is cursor-1, which is outside the partition of terminals.length = 1.
		// How crude is that?
		// Note that in case you have two string literals following each other directly, the deletion strategy wouldn't apply.
		// One could add the same strategy for the STRING partition in addition to solve this
		acceptor.accept(partitionDeletion.newInstance("(", ")"), IDocument.DEFAULT_CONTENT_TYPE)
		acceptor.accept(partitionDeletion.newInstance("<", ">"), IDocument.DEFAULT_CONTENT_TYPE)
	}
}
