package de.tfritsch.psdt.debug.ui

import org.eclipse.core.resources.IStorage
import org.eclipse.core.runtime.PlatformObject
import org.eclipse.jface.resource.ImageDescriptor
import org.eclipse.ui.IPersistableElement
import org.eclipse.ui.IStorageEditorInput

/**
 * Adapter for making a storage resource a suitable input for an editor.
 * <p>
 * Why doesn't Eclipse provide this class (analogous to FileEditorInput)?
 * </p>
 */
class StorageEditorInput extends PlatformObject implements IStorageEditorInput {

	IStorage fStorage

	/**
	 * Creates an editor input based of the given storage resource.
	 *
	 * @param storage  the storage resource
	 */
	new(IStorage storage) {
		if (storage == null)
			throw new IllegalArgumentException
		fStorage = storage
	}

	override int hashCode() {
		return fStorage.hashCode
	}

	/**
	 * The <code>StorageEditorInput</code> implementation of this <code>Object</code>
	 * method bases the equality of two <code>StorageEditorInput</code> objects on the
	 * equality of their underlying <code>IStorage</code> resources.
	 */
	override boolean equals(Object obj) {
		if (!(obj instanceof StorageEditorInput))
			return false;
		return fStorage == (obj as StorageEditorInput).fStorage
	}

	override boolean exists() {
		return true
	}

	@SuppressWarnings("rawtypes")
	override Object getAdapter(Class adapter) {
		if (adapter == IStorage) {
			return fStorage
		}
		return fStorage.getAdapter(adapter)
	}

	override IStorage getStorage() {
		return fStorage
	}

	override ImageDescriptor getImageDescriptor() {
		return null
	}

	override String getName() {
		return fStorage.name
	}

	override IPersistableElement getPersistable() {
		return null
	}

	override String getToolTipText() {
		return fStorage.fullPath.toString
	}
}
