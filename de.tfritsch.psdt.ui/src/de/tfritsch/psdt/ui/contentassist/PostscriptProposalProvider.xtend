/*
 * generated by Xtext
 */
package de.tfritsch.psdt.ui.contentassist

import com.google.inject.Inject
import de.tfritsch.psdt.postscript.PostscriptFactory
import java.util.List
import java.util.Scanner
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.RuleCall
import org.eclipse.xtext.ui.editor.contentassist.ContentAssistContext
import org.eclipse.xtext.ui.editor.contentassist.ICompletionProposalAcceptor

/**
 * see http://www.eclipse.org/Xtext/documentation.html#contentAssist on how to customize content assistant
 */
class PostscriptProposalProvider extends AbstractPostscriptProposalProvider {

	static val EXECUTABLE_NAMES = readNames("executable-names.txt")

	static val LITERAL_NAMES = readNames("literal-names.txt")

	def static List<String> readNames(String fileName) {
		val stream = PostscriptProposalProvider.getResourceAsStream(fileName)
		val scanner = new Scanner(stream)
		val names = scanner.toList
		scanner.close
		return names
	}

	@Inject extension PostscriptFactory

	override complete_PSExecutableName(EObject model, RuleCall ruleCall, ContentAssistContext context,
		extension ICompletionProposalAcceptor acceptor) {
		super.complete_PSExecutableName(model, ruleCall, context, acceptor)
		val image = createPSExecutableName.image
		EXECUTABLE_NAMES.forEach[createCompletionProposal(it, image, context).accept]
	}

	override complete_PSLiteralName(EObject model, RuleCall ruleCall, ContentAssistContext context,
		extension ICompletionProposalAcceptor acceptor) {
		super.complete_PSLiteralName(model, ruleCall, context, acceptor)
		if (context.prefix.empty)
			// Don't propose literal names (e.g. /FontType), if '/' is not yet entered,
			// in order not to overload the proposal list.
			return;
		val image = createPSLiteralName.image
		LITERAL_NAMES.forEach[createCompletionProposal(it, image, context).accept]
	}

	override complete_PSString(EObject model, RuleCall ruleCall, ContentAssistContext context,
		extension ICompletionProposalAcceptor acceptor) {
		super.complete_PSString(model, ruleCall, context, acceptor)
		val image = createPSString.image
		"(abc)".createCompletionProposal("(abc) - ASCII String", image, context).accept
		"<616263>".createCompletionProposal("<616263> - ASCIIHex String", image, context).accept
		"<~@:E^~>".createCompletionProposal("<~@:E^~> - ASCII85 String", image, context).accept
	}

}
