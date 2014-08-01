package de.tfritsch.psdt.debug;

import java.io.IOException;
import java.net.URL;

import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.FileLocator;
import org.eclipse.core.runtime.IPath;
import org.eclipse.core.runtime.IStatus;
import org.eclipse.core.runtime.Path;
import org.eclipse.core.runtime.Status;
import org.eclipse.jface.resource.ImageRegistry;
import org.eclipse.ui.plugin.AbstractUIPlugin;
import org.eclipse.swt.graphics.Image;
import org.osgi.framework.BundleContext;

/**
 * The activator class controls the plug-in life cycle
 */
public class PSPlugin extends AbstractUIPlugin {

	// The plug-in ID
	public static final String ID = "de.tfritsch.psdt.debug"; //$NON-NLS-1$

	// The shared instance
	private static PSPlugin INSTANCE;
	
	@Override
	public void start(BundleContext context) throws Exception {
		super.start(context);
		INSTANCE = this;
	}

	@Override
	public void stop(BundleContext context) throws Exception {
		INSTANCE = null;
		super.stop(context);
	}

	/**
	 * Returns the shared instance
	 *
	 * @return the shared instance
	 */
	public static PSPlugin getDefault() {
		return INSTANCE;
	}

	/**
	 * Return a file from within this plug-in.
	 */
	public static IPath getFile(String path) throws CoreException {
		URL url = INSTANCE.getBundle().getEntry(path);
        try {
            url = FileLocator.toFileURL(url);
        } catch (IOException e) {
            IStatus status = new Status(IStatus.ERROR, ID, e.getMessage(), e);
            throw new CoreException(status);
        }
        return new Path(url.getFile());
	}

	/**
	 * Return an <code>Image</code> object from within this plug-in.
	 */
	public static Image getImage(String path) {
		ImageRegistry registry = INSTANCE.getImageRegistry();
		Image image = registry.get(path);
		if (image == null) {
			image = imageDescriptorFromPlugin(ID, path).createImage();
			registry.put(path, image);
		}
		return image;
	}

}
