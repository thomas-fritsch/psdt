package de.tfritsch.psdt.ui.hover;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.regex.Pattern;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.help.HelpSystem;
import org.eclipse.help.IContext;
import org.eclipse.help.IHelpResource;
import org.eclipse.jface.internal.text.html.HTMLPrinter;
import org.eclipse.xtext.documentation.IEObjectDocumentationProvider;
import org.eclipse.xtext.util.PolymorphicDispatcher;

import com.google.inject.Singleton;

import de.tfritsch.psdt.postscript.PSExecutableName;
import de.tfritsch.psdt.postscript.PSLiteralName;

@Singleton
@SuppressWarnings("restriction")
public class PostscriptDocumentationProvider implements
		IEObjectDocumentationProvider {

	private PolymorphicDispatcher<String> documentationDispatcher =
			PolymorphicDispatcher.createForSingleTarget("_documentation", this);

	public String getDocumentation(EObject o) {
		return documentationDispatcher.invoke(o);
	}

	protected String _documentation(EObject o) {
		return null;
	}

	protected String _documentation(PSExecutableName o) {
		String href = getHref("de.tfritsch.psdt.help.Reference", o.getName());
		if (href == null)
			return null;
		String content = getContent(href);
		if (content == null)
			return null;
		int posHash = href.indexOf('#');
		String fragment = (posHash >= 0) ? href.substring(posHash + 1) : "";
		content = getBetween(content, "<A NAME=\"" + fragment + "\"></A>", "<HR>");
		return content;
	}

	protected String _documentation(PSLiteralName o) {
		String href = getHref("de.tfritsch.psdt.help.LiteralNames", o.getName());
		if (href == null)
			return null;
		String content = getContent(href);
		if (content == null)
			return null;
		int posHash = href.indexOf('#');
		String fragment = (posHash >= 0) ? href.substring(posHash + 1) : "";
		content = Pattern.compile(".*<a name=\""+ fragment + "\"></a>\\s*(<tr>.*?</tr>).*", Pattern.DOTALL)
				.matcher(content)
				.replaceFirst("$1");
		content = "<table border=\"1\"><tr><th>Key</th><th>Type</th><th>Value</th></tr>"
				+ content  + "</table><br><br><br>";
		return content;
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
			return null;
		return full.substring(pos1, pos2);
	}
}
