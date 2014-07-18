package de.tfritsch.psdt.debug.ui;

import org.eclipse.core.resources.IFile;
import org.eclipse.core.resources.IStorage;
import org.eclipse.debug.core.model.IValue;
import org.eclipse.debug.ui.IDebugModelPresentation;
import org.eclipse.debug.ui.IValueDetailListener;
import org.eclipse.jface.viewers.LabelProvider;
import org.eclipse.swt.graphics.Image;
import org.eclipse.ui.IEditorInput;
import org.eclipse.ui.PartInitException;
import org.eclipse.ui.ide.IDE;
import org.eclipse.ui.part.FileEditorInput;

import de.tfritsch.psdt.debug.PSPlugin;

/**
 * Renders PostScript debug elements.
 * 
 * Matches plugin.xml
 * extension[@point="org.eclipse.debug.ui.debugModelPresentations"]/debugModelPresentation/@class
 */
public class PSDebugModelPresentation extends LabelProvider implements
		IDebugModelPresentation {

    /**
     * Unique identifier for the PostScript debug model (value 
     * <code>{@value}</code>).
     * Matches plugin.xml
     * extension[@point="org.eclipse.debug.ui.debugModelPresentations"]/debugModelPresentation/@id
     */
    public final static String ID = PSPlugin.ID + ".debugModel"; //$NON-NLS-1$

    //@Override
	public void setAttribute(String attribute, Object value) {
	}

	@Override
	public Image getImage(Object element) {
		return null; // The view will show a default icon
	}

	@Override
	public String getText(Object element) {
		return null; // The view will show a default label
	}

	//@Override
	public void computeDetail(IValue value, IValueDetailListener listener) {
		listener.detailComputed(value, null);
		// The view will show value.getValueString()
	}

	//@Override
	public IEditorInput getEditorInput(Object element) {
		if (element instanceof IFile) {
			return new FileEditorInput((IFile) element);
		}
		if (element instanceof IStorage) {
			return new StorageEditorInput((IStorage) element);
		}
		return null;
	}

	//@Override
	public String getEditorId(IEditorInput input, Object element) {
		try {
			return IDE.getEditorDescriptor(input.getName()).getId();
		} catch (PartInitException e) {
		    return null;
		}
	}
}
