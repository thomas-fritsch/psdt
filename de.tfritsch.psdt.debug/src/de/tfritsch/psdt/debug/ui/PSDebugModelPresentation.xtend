package de.tfritsch.psdt.debug.ui

import de.tfritsch.psdt.ui.editor.PostscriptEditor
import org.eclipse.core.resources.IFile
import org.eclipse.core.resources.IStorage
import org.eclipse.debug.core.model.IBreakpoint
import org.eclipse.debug.core.model.IValue
import org.eclipse.debug.ui.IDebugModelPresentation
import org.eclipse.debug.ui.IValueDetailListener
import org.eclipse.jface.viewers.LabelProvider
import org.eclipse.swt.graphics.Image
import org.eclipse.ui.IEditorInput
import org.eclipse.ui.part.FileEditorInput

/**
 * Renders PostScript debug elements.
 * 
 * Matches plugin.xml
 * extension[@point="org.eclipse.debug.ui.debugModelPresentations"]/debugModelPresentation/@class
 */
public class PSDebugModelPresentation extends LabelProvider implements IDebugModelPresentation {

	override void setAttribute(String attribute, Object value) {
	}

	override Image getImage(Object element) {
		return null // The view will show a default icon
	}

	override String getText(Object element) {
		return null // The view will show a default label
	}

	override void computeDetail(IValue value, IValueDetailListener listener) {
		listener.detailComputed(value, null) // The view will show value.getValueString()
	}

	override IEditorInput getEditorInput(Object element) {
		return switch (element) {
			IFile:
				new FileEditorInput(element)
			IStorage:
				new StorageEditorInput(element)
			IBreakpoint:
				getEditorInput(element.marker.resource) // recursion!
			default:
				null
		}
	}

	override String getEditorId(IEditorInput input, Object element) {
		return switch (element) {
			IFile,
			IStorage,
			IBreakpoint:
				PostscriptEditor.ID
			default:
				null
		}
	}
}
