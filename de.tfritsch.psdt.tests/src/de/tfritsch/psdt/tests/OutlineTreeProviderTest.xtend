/*******************************************************************************
 * Copyright (c) 2016 Thomas Fritsch.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 ******************************************************************************/
package de.tfritsch.psdt.tests

import de.tfritsch.psdt.PostscriptUiInjectorProvider
import de.tfritsch.psdt.ui.editor.PostscriptEditor
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.ui.AbstractOutlineTest
import org.junit.Test
import org.junit.runner.RunWith

/**
 * Run this as "JUnit Plugin Test".
 * 
 * @author Thomas Fritsch - initial API and implementation
 */
@RunWith(XtextRunner)
@InjectWith(PostscriptUiInjectorProvider)
class OutlineTreeProviderTest extends AbstractOutlineTest {

	override protected getEditorId() {
		return PostscriptEditor.ID
	}

	@Test
	def void testNested() throws Exception {
		'''
			%!PS
			<<
				/PageSize [595 841]
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
