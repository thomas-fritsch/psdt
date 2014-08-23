package de.tfritsch.psdt.ui.hover;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.regex.Matcher;
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
		String href = getHref(o.getName());
		if (href == null)
			return null;
		String content = getContent(href);
		if (content == null)
			return null;
		int posHash = href.indexOf('#');
		String fragment = (posHash >= 0) ? href.substring(posHash + 1) : "";
		Matcher matcher = Pattern.compile(".*<a name=\""+ fragment + "\"></a>(.*?)<hr>.*",
				Pattern.CASE_INSENSITIVE | Pattern.DOTALL).matcher(content);
		if (!matcher.matches())
			return null;
		content = matcher.group(1);
		return content;
	}

	protected String _documentation(PSLiteralName o) {
		String href = getHref(o.getName());
		if (href == null)
			return null;
		String content = getContent(href);
		if (content == null)
			return null;
		int posHash = href.indexOf('#');
		String fragment = (posHash >= 0) ? href.substring(posHash + 1) : "";
		Matcher matcher = Pattern.compile(".*(<tr>\\s*<th.*/th>\\s*</tr>).*(<tr>.*?<a name=\""+ fragment + "\"></a>.*?</tr>).*",
				Pattern.CASE_INSENSITIVE | Pattern.DOTALL).matcher(content);
		if (!matcher.matches())
			return null;
		String headerRow = matcher.group(1);
		String dataRow = matcher.group(2);
		return "<table border=\"1\">" + headerRow + dataRow  + "</table><br><br><br>";
	}

	private String getHref(String label) {
		IContext context = HelpSystem.getContext("de.tfritsch.psdt.help.Reference");
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
}
