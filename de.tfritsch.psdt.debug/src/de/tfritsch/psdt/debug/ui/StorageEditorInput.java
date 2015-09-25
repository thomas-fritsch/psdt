package de.tfritsch.psdt.debug.ui;

import org.eclipse.core.resources.IStorage;
import org.eclipse.core.runtime.PlatformObject;
import org.eclipse.jface.resource.ImageDescriptor;
import org.eclipse.ui.IPersistableElement;
import org.eclipse.ui.IStorageEditorInput;

/**
 * Adapter for making a storage resource a suitable input for an editor.
 * <p>
 * Why doesn't Eclipse provide this class (analogous to FileEditorInput)?
 * </p>
 */class StorageEditorInput extends PlatformObject
        implements IStorageEditorInput {
    private IStorage fStorage;
    
	/**
	 * Creates an editor input based of the given storage resource.
	 *
	 * @param storage  the storage resource
	 */
    public StorageEditorInput(IStorage storage) {
		if (storage == null)
			throw new IllegalArgumentException();
        fStorage = storage;
    }
    
    @Override
	public int hashCode() {
        return fStorage.hashCode();
    }
    
	/**
	 * The <code>StorageEditorInput</code> implementation of this <code>Object</code>
	 * method bases the equality of two <code>StorageEditorInput</code> objects on the
	 * equality of their underlying <code>IStorage</code> resources.
	 */
    @Override
	public boolean equals(Object obj) {
        if (!(obj instanceof StorageEditorInput))
            return false;
        return fStorage.equals(((StorageEditorInput)obj).fStorage);
    }
   
    @Override
	public boolean exists() {
        return true;
    }

	@Override
    @SuppressWarnings("rawtypes")
	public Object getAdapter(Class adapter) {
		if (adapter == IStorage.class) {
			return fStorage;
		}
		return fStorage.getAdapter(adapter);
	}

    @Override
	public IStorage getStorage() {
        return fStorage;
    }

    @Override
	public ImageDescriptor getImageDescriptor() {
        return null;
    }

    @Override
	public String getName() {
        return fStorage.getName();
    }

    @Override
	public IPersistableElement getPersistable() {
        return null;
    }

    @Override
	public String getToolTipText() {
        return fStorage.getFullPath().toString();
    }
}
