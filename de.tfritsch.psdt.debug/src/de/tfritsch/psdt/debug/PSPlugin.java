/*******************************************************************************
 * Copyright (c) 2016 Thomas Fritsch.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 ******************************************************************************/
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
 * 
 * @author Thomas Fritsch - initial API and implementation
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

	public static CoreException toCoreException(Exception e) {
		IStatus status = new Status(IStatus.ERROR, ID, e.getMessage(), e);
		return new CoreException(status);
	}

	public static CoreException toCoreException(String message) {
		IStatus status = new Status(IStatus.ERROR, ID, message, null);
		return new CoreException(status);
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
