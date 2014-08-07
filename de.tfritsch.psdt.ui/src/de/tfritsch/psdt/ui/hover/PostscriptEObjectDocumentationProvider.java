package de.tfritsch.psdt.ui.hover;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import org.eclipse.emf.ecore.EObject;
import org.eclipse.help.HelpSystem;
import org.eclipse.help.IContext;
import org.eclipse.help.IHelpResource;
import org.eclipse.xtext.documentation.IEObjectDocumentationProvider;

import de.tfritsch.psdt.postscript.PSExecutableName;

public class PostscriptEObjectDocumentationProvider implements
		IEObjectDocumentationProvider {

	public String getDocumentation(EObject o) {
		if (o instanceof PSExecutableName) {
			IContext context = HelpSystem
					.getContext("de.tfritsch.psdt.help.Reference");
			if (context == null)
				return null;
			String href = getHref(context, ((PSExecutableName) o).getName());
			if (href == null)
				return null;
			InputStream input = HelpSystem.getHelpContent(href);
			if (input == null)
				return null;
			int posHash = href.indexOf('#');
			String fragment = (posHash >= 0) ? href.substring(posHash + 1) : "";
			String full = "";
			try {
				full = toString(input);
				input.close();
			} catch (IOException e) {
			}
			return getBetween(full, "<A NAME=\"" + fragment + "\"></A>", "<HR>");
		}
		return null;
	}

	private String getHref(IContext context, String label) {
		IHelpResource[] topics = context.getRelatedTopics();
		for (IHelpResource topic : topics) {
			if (topic.getLabel().equals(label)) {
				return topic.getHref();
			}
		}
		return null;
	}

	private String toString(InputStream input) throws IOException {
		ByteArrayOutputStream buffer = new ByteArrayOutputStream();
		int nRead;
		byte[] data = new byte[16384];
		while ((nRead = input.read(data)) != -1) {
			buffer.write(data, 0, nRead);
		}
		return buffer.toString();
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
