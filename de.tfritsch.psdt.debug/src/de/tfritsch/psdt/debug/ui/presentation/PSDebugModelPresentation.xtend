/*******************************************************************************
 * Copyright (c) 2016 Thomas Fritsch.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 ******************************************************************************/
package de.tfritsch.psdt.debug.ui.presentation

import com.google.inject.Inject
import de.tfritsch.psdt.debug.PSPlugin
import de.tfritsch.psdt.debug.core.model.PSVariable
import de.tfritsch.psdt.ui.editor.PostscriptEditor
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
import org.eclipse.swt.graphics.Image
import org.eclipse.ui.IEditorInput
import org.eclipse.ui.ide.FileStoreEditorInput
import org.eclipse.ui.part.FileEditorInput
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

	new() {
		PSPlugin.injector.injectMembers(this) // TODO remove this hack
	}

	override void setAttribute(String key, Object value) {
		attributes.put(key, value)
	}

	override Image getImage(Object element) {
		return switch (element) {
			PSVariable:
				imageHelper.getImage("object.gif")
			default:
				null // The view will show a default icon
		}
	}

	override String getText(Object element) {
		return switch (element) {
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

	override void computeDetail(IValue value, IValueDetailListener listener) {
		listener.detailComputed(value, null) // The view will show value.getValueString()
	}

	override IEditorInput getEditorInput(Object element) {
		return switch (element) {
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

	override String getEditorId(IEditorInput input, Object element) {
		return switch (element) {
			IFile,
			IFileStore,
			IBreakpoint:
				PostscriptEditor.ID
			default:
				null
		}
	}
}
