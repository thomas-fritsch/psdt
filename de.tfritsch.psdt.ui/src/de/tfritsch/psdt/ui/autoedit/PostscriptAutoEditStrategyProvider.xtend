/*******************************************************************************
 * Copyright (c) 2016 Thomas Fritsch.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 ******************************************************************************/
package de.tfritsch.psdt.ui.autoedit

import org.eclipse.jface.text.IDocument
import org.eclipse.xtext.ui.editor.autoedit.DefaultAutoEditStrategyProvider

/**
 * @author Thomas Fritsch - initial API and implementation
 */
class PostscriptAutoEditStrategyProvider extends DefaultAutoEditStrategyProvider {

	override protected void configureMultilineComments(IEditStrategyAcceptor acceptor) {
		// do nothing
	}

	override protected void configureStringLiteral(IEditStrategyAcceptor acceptor) {
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
