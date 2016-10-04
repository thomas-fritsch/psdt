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
package de.tfritsch.psdt.debug.ui.presentation

import com.google.inject.Inject
import de.tfritsch.psdt.debug.core.model.PSVariable
import java.util.Map
import org.eclipse.core.filesystem.IFileStore
import org.eclipse.core.resources.IFile
import org.eclipse.debug.core.model.IBreakpoint
import org.eclipse.debug.core.model.IStackFrame
import org.eclipse.debug.core.model.IThread
import org.eclipse.debug.core.model.IValue
import org.eclipse.debug.ui.IDebugModelPresentation
import org.eclipse.debug.ui.IValueDetailListener
import org.eclipse.jface.viewers.LabelProvider
import org.eclipse.ui.IEditorInput
import org.eclipse.ui.ide.FileStoreEditorInput
import org.eclipse.ui.part.FileEditorInput
import org.eclipse.xtext.LanguageInfo
import org.eclipse.xtext.ui.IImageHelper

/**
 * Renders PostScript debug elements.
 * 
 * Matches plugin.xml
 * extension[@point="org.eclipse.debug.ui.debugModelPresentations"]/debugModelPresentation/@class
 * 
 * @author Thomas Fritsch - initial API and implementation
 */
class PSDebugModelPresentation extends LabelProvider implements IDebugModelPresentation {

	Map<String, Object> attributes = newHashMap

	@Inject
	IImageHelper imageHelper

	@Inject
	LanguageInfo languageInfo

	override setAttribute(String key, Object value) {
		attributes.put(key, value)
	}

	override getImage(Object element) {
		switch (element) {
			PSVariable:
				imageHelper.getImage("object.gif")
			default:
				null // The view will show a default icon
		}
	}

	override getText(Object element) {
		switch (element) {
			IThread: '''
				Thread [«element.name»] («IF element.suspended»Suspended«ELSEIF element.stepping»Stepping«ELSE»Running«ENDIF»)
			'''
			IStackFrame: '''
				«element.name» line: «element.lineNumber»
			'''
			default:
				null // The view will show a default icon
		}
	}

	override computeDetail(IValue value, IValueDetailListener listener) {
		listener.detailComputed(value, null) // The view will show value.getValueString()
	}

	override getEditorInput(Object element) {
		switch (element) {
			IFile:
				new FileEditorInput(element)
			IFileStore:
				new FileStoreEditorInput(element)
			IBreakpoint:
				getEditorInput(element.marker.resource) // recursion!
			default:
				null
		}
	}

	override getEditorId(IEditorInput input, Object element) {
		switch (element) {
			IFile,
			IFileStore,
			IBreakpoint:
				languageInfo.languageName
			default:
				null
		}
	}
}
