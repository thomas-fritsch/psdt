/*******************************************************************************
 * Copyright (c) 2016 Thomas Fritsch.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 ******************************************************************************/
package de.tfritsch.psdt.ui.contentassist

import com.google.inject.Inject
import de.tfritsch.psdt.postscript.PostscriptFactory
import org.eclipse.emf.ecore.EObject
import org.eclipse.jface.viewers.StyledString
import org.eclipse.swt.graphics.Image
import org.eclipse.xtext.RuleCall
import org.eclipse.xtext.ui.editor.contentassist.ContentAssistContext
import org.eclipse.xtext.ui.editor.contentassist.ICompletionProposalAcceptor

/**
 * see http://www.eclipse.org/Xtext/documentation.html#contentAssist on how to customize content assistant
 * 
 * @author Thomas Fritsch - initial API and implementation
 */
class PostscriptProposalProvider extends AbstractPostscriptProposalProvider {

	@Inject extension NameRepository
	@Inject extension PostscriptFactory

	override complete_PSExecutableName(EObject model, RuleCall ruleCall, ContentAssistContext context,
		extension ICompletionProposalAcceptor acceptor) {
		super.complete_PSExecutableName(model, ruleCall, context, acceptor)
		val image = createPSExecutableName.image
		executableNames.forEach[createCompletionProposal(it, image, context).accept]
	}

	override complete_PSLiteralName(EObject model, RuleCall ruleCall, ContentAssistContext context,
		extension ICompletionProposalAcceptor acceptor) {
		super.complete_PSLiteralName(model, ruleCall, context, acceptor)
		if (context.prefix.empty)
			// Don't propose literal names (e.g. /FontType), if '/' is not yet entered,
			// in order not to overload the proposal list.
			return;
		val image = createPSLiteralName.image
		literalNames.forEach[createCompletionProposal(it, image, context).accept]
	}

	override complete_PSString(EObject model, RuleCall ruleCall, ContentAssistContext context,
		extension ICompletionProposalAcceptor acceptor) {
		super.complete_PSString(model, ruleCall, context, acceptor)
		val image = createPSString.image
		"(abc)".createCompletionProposal("(abc) - ASCII String", image, context).accept
		"<616263>".createCompletionProposal("<616263> - ASCIIHex String", image, context).accept
		"<~@:E^~>".createCompletionProposal("<~@:E^~> - ASCII85 String", image, context).accept
	}

	// adjust priority so that best matching proposals appear on top
	override protected createCompletionProposal(String proposal, StyledString displayString, Image image,
		int priority, String prefix, ContentAssistContext context) {
		val adjustedPriority = if(prefix.length > 0) priority * 2 else priority
		super.createCompletionProposal(proposal, displayString, image, adjustedPriority, prefix, context)
	}
}
