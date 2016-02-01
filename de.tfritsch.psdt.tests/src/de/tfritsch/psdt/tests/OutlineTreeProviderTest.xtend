package de.tfritsch.psdt.tests

import de.tfritsch.psdt.PostscriptUiInjectorProvider
import de.tfritsch.psdt.ui.editor.PostscriptEditor
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.ui.tests.editor.outline.AbstractOutlineWorkbenchTest
import org.junit.Test
import org.junit.runner.RunWith

/**
 * Run this as "JUnit Plugin Test".
 */
@RunWith(XtextRunner)
@InjectWith(PostscriptUiInjectorProvider)
class OutlineTreeProviderTest extends AbstractOutlineWorkbenchTest {

	override protected getEditorId() {
		return PostscriptEditor.ID
	}

	@Test
	def void testNested() throws Exception {
		'''
			%!PS
			<<
				/PageSize [595 841}
			>> setpagedevice
		'''.assertAllLabels('''
			<<...>>
			  /PageSize
			  [...]
			    595
			    841
			setpagedevice
		''')
	}

	@Test
	def void testUnparsedData() throws Exception {
		'''
			%!PS
			aa
			%%BeginData:
			asdf
			wrzlbrmft
			%%EndData
			zz
		'''.assertAllLabels('''
			aa
			Data
			zz
		''')
	}

}
