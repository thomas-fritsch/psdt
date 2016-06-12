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
package de.tfritsch.psdt.debug

import com.google.inject.Injector
import de.tfritsch.psdt.ui.internal.PostscriptActivator
import org.eclipse.core.runtime.CoreException
import org.eclipse.core.runtime.IStatus
import org.eclipse.core.runtime.Status
import org.eclipse.ui.plugin.AbstractUIPlugin
import org.osgi.framework.BundleContext

/**
 * The activator class controls the plug-in life cycle
 * 
 * @author Thomas Fritsch - initial API and implementation
 */
class PSPlugin extends AbstractUIPlugin {

	// The plug-in ID
	public static val String ID = "de.tfritsch.psdt.debug" //$NON-NLS-1$

	// The shared instance
	private static PSPlugin INSTANCE

	override void start(BundleContext context) throws Exception {
		super.start(context)
		INSTANCE = this
	}

	override void stop(BundleContext context) throws Exception {
		INSTANCE = null
		super.stop(context)
	}

	/**
	 * Returns the shared instance
	 *
	 * @return the shared instance
	 */
	def static PSPlugin getDefault() {
		return INSTANCE
	}

	Injector injector

	def synchronized Injector getInjector() {
		if (injector == null) {
			injector = PostscriptActivator.instance.getInjector(PostscriptActivator.DE_TFRITSCH_PSDT_POSTSCRIPT).
				createChildInjector(new PSModule(this))
		}
		return injector
	}

	def static CoreException toCoreException(Exception e) {
		val status = new Status(IStatus.ERROR, ID, e.getMessage(), e)
		return new CoreException(status)
	}

	def static CoreException toCoreException(String message) {
		val status = new Status(IStatus.ERROR, ID, message, null)
		return new CoreException(status)
	}

	/**
	 * Logs the specified throwable with this plug-in's log.
	 *
	 * @param t throwable to log
	 */
	def static void log(Throwable t) {
		val status = new Status(IStatus.ERROR, ID, "Error", t)
		INSTANCE.log.log(status)
	}
}
