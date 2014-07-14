package de.tfritsch.psdt.debug;

import java.io.File;
import java.io.IOException;
import java.net.URL;

import org.eclipse.core.runtime.FileLocator;
import org.eclipse.jface.resource.ImageDescriptor;
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
	
	/**
	 * The constructor
	 */
	public PSPlugin() {
	}

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
	 * Return a <code>java.io.File</code> object that corresponds to the specified
	 * path in the plugin directory, or <code>null</code> if none.
	 */
	public static File getFileInPlugin(String path) {
		URL url = INSTANCE.getBundle().getEntry(path);
        try {
            url = FileLocator.toFileURL(url);
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
        String s = url.getPath().replace('/', File.separatorChar);
        return new File(s);
	}

	public static Image getImage(String path) {
		ImageRegistry registry = INSTANCE.getImageRegistry();
		Image image = registry.get(path);
		if (image == null) {
			URL url = INSTANCE.getBundle().getEntry(path);
			image = ImageDescriptor.createFromURL(url).createImage();
			registry.put(path, image);
		}
		return image;
	}

}
