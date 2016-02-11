package de.tfritsch.psdt.debug;

import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.IStatus;
import org.eclipse.core.runtime.Status;
import org.eclipse.ui.plugin.AbstractUIPlugin;
import org.osgi.framework.BundleContext;

import com.google.inject.Injector;

import de.tfritsch.psdt.ui.internal.PostscriptActivator;

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

        // TODO use an ExecutableExtensionFactory in plugin.xml instead of this hack
	public static Injector getInjector() {
	    return PostscriptActivator.getInstance().getInjector(PostscriptActivator.DE_TFRITSCH_PSDT_POSTSCRIPT);
	}

	/**
	 * Throws an exception with the given message and underlying exception.
	 *
	 * @param message error message
	 * @param e underlying exception, or <code>null</code>
	 * @throws CoreException always
	 */
	public static void abort(String message, Exception e) throws CoreException {
		IStatus status = new Status(IStatus.ERROR, ID, message, e);
		throw new CoreException(status);
	}

	/**
	 * Logs the specified throwable with this plug-in's log.
	 *
	 * @param t throwable to log
	 */
	public static void log(Throwable t) {
		IStatus status = new Status(IStatus.ERROR, ID, "Error", t);
		INSTANCE.getLog().log(status);
	}
}
