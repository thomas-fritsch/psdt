package de.tfritsch.psdt.tests

import com.google.inject.Inject
import de.tfritsch.psdt.PostscriptUiInjectorProvider
import org.eclipse.jface.text.Region
import org.eclipse.xtext.LanguageInfo
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.ui.AbstractAutoEditTest
import org.eclipse.xtext.resource.EObjectAtOffsetHelper
import org.eclipse.xtext.resource.FileExtensionProvider
import org.eclipse.xtext.ui.editor.XtextEditor
import org.eclipse.xtext.ui.editor.hover.IEObjectHoverProvider
import org.junit.Test
import org.junit.runner.RunWith

@RunWith(XtextRunner)
@InjectWith(PostscriptUiInjectorProvider)
class HoverProviderTest extends AbstractAutoEditTest {

    @Inject FileExtensionProvider fileExtensionProvider
    @Inject LanguageInfo languageInfo
    @Inject extension EObjectAtOffsetHelper
    @Inject IEObjectHoverProvider hoverProvider

    override protected getFileExtension() {
        return fileExtensionProvider.primaryFileExtension
    }

    override protected getEditorId() {
        return languageInfo.languageName
    }

    def private assertHover(XtextEditor editor, int offset, String expectedText) {
        val eObject = editor.document.readOnly[resolveElementAt(offset)]
        val viewer = editor.internalSourceViewer
        val region = new Region(offset, 0)
        val hoverInfo = hoverProvider.getHoverInfo(eObject, viewer, region)
        assertNotNull(hoverInfo.hoverControlCreator)
        val text = hoverInfo.info?.toString
        if (expectedText === null) {
            assertNull(text)
        } else {
            assertTrue(text.contains(expectedText))
        }
    }

    @Test
    def void testOperator() throws Exception {
        openEditor(
            '''
                (Hello) show
            '''
        ).assertHover(10, "<h3>show</h3>")
    }

    @Test
    def void testFromTable() throws Exception {
        openEditor(
            '''
                /BuildGlyph
            '''
        ).assertHover(0, "<th>BuildGlyph</th>")
    }

    @Test
    def void testUnknown() throws Exception {
        openEditor(
            '''
                Wrdlbrnft
            '''
        ).assertHover(0, null)
    }
}
