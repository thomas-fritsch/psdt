package de.tfritsch.psdt.ui.hover;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.help.HelpSystem;
import org.eclipse.help.IContext;
import org.eclipse.help.IHelpResource;
import org.eclipse.jface.internal.text.html.HTMLPrinter;
import org.eclipse.xtext.documentation.IEObjectDocumentationProvider;

import de.tfritsch.psdt.postscript.PSExecutableName;

@SuppressWarnings("restriction")
public class PostscriptEObjectDocumentationProvider implements
		IEObjectDocumentationProvider {

	public String getDocumentation(EObject o) {
		if (o instanceof PSExecutableName) {
			return doGetDocumentation((PSExecutableName) o);
		}
		return null;
	}

	protected String doGetDocumentation(PSExecutableName o) {
		String href = getHref("de.tfritsch.psdt.help.Reference", o.getName());
		if (href == null)
			return null;
		String content = getContent(href);
		if (content == null)
			return null;
		int posHash = href.indexOf('#');
		String fragment = (posHash >= 0) ? href.substring(posHash + 1) : "";
		return getBetween(content, "<A NAME=\"" + fragment + "\"></A>", "<HR>");
	}

	private String getHref(String contextId, String label) {
		IContext context = HelpSystem.getContext(contextId);
		if (context == null)
			return null;
		IHelpResource[] topics = context.getRelatedTopics();
		for (IHelpResource topic : topics) {
			if (topic.getLabel().equals(label)) {
				return topic.getHref();
			}
		}
		return null;
	}

	private String getContent(String href) {
		InputStream input = HelpSystem.getHelpContent(href);
		if (input == null)
			return null;
		String content = HTMLPrinter.read(new InputStreamReader(input));
		try {
			input.close();
		} catch (IOException e) {
		}
		return content;
	}

	private String getBetween(String full, String begin, String end) {
		int pos1 = full.indexOf(begin);
		if (pos1 < 0)
			return null;
		pos1 += begin.length();
		int pos2 = full.indexOf(end, pos1);
		if (pos2 < 0)
			pos2 = full.length();
		return full.substring(pos1, pos2);
	}
}
