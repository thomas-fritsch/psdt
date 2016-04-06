/*******************************************************************************
 * Copyright (C) 2016  Thomas Fritsch.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 ******************************************************************************/
package de.tfritsch.psdt.tests

import com.google.inject.Inject
import de.tfritsch.psdt.PostscriptUiInjectorProvider
import org.eclipse.xtext.LanguageInfo
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

	@Inject LanguageInfo languageInfo

	override protected getEditorId() {
		return languageInfo.languageName
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
