package de.tfritsch.psdt.tests;

import org.eclipse.swt.SWT;
import org.eclipse.xtext.junit4.InjectWith;
import org.eclipse.xtext.junit4.XtextRunner;
import org.eclipse.xtext.junit4.ui.AbstractAutoEditTest;
import org.eclipse.xtext.ui.editor.XtextEditor;
import org.junit.Test;
import org.junit.runner.RunWith;

import de.tfritsch.psdt.PostscriptInjectorProvider;
import de.tfritsch.psdt.ui.editor.PostscriptEditor;

@SuppressWarnings("restriction")
@RunWith(XtextRunner.class)
@InjectWith(PostscriptInjectorProvider.class)
public class AutoEditTest extends AbstractAutoEditTest {

	@Override
	protected String getFileExtension() {
		return "ps";
	}

	@Override
	protected String getEditorId() {
		return PostscriptEditor.ID;
	}

	@Test
	public void testCurlyBraces() throws Exception {
		XtextEditor editor = openEditor("|");
		pressKey(editor, '{');
		assertState("{|}", editor);
		pressKey(editor, SWT.BS);
		assertState("|", editor);
	}

	@Test
	public void testBrackets() throws Exception {
		XtextEditor editor = openEditor("|");
		pressKey(editor, '[');
		assertState("[|]", editor);
		pressKey(editor, SWT.BS);
		assertState("|", editor);
	}

	@Test
	public void testParenthesis() throws Exception {
		XtextEditor editor = openEditor("|");
		pressKey(editor, '(');
		assertState("(|)", editor);
		pressKey(editor, SWT.BS);
		assertState("|", editor);
	}

	@Test
	public void testAngleBrackets() throws Exception {
		XtextEditor editor = openEditor("|");
		pressKey(editor, '<');
		assertState("<|>", editor);
		pressKey(editor, SWT.BS);
		assertState("|", editor);
	}

}
