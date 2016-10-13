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
package de.tfritsch.psdt.debug.core.process

import de.tfritsch.psdt.debug.PSPlugin
import java.util.Map
import org.eclipse.debug.core.ILaunch
import org.eclipse.debug.core.IProcessFactory
import org.eclipse.debug.core.model.RuntimeProcess

import static extension de.tfritsch.psdt.debug.LaunchExtensions.*

/**
 * Matches plugin.xml
 * extension[@point="org.eclipse.debug.core.processFactories"]/processFactory/@class
 * 
 * @author Thomas Fritsch - initial API and implementation
 */
class PSProcessFactory implements IProcessFactory {

    /**
     * Unique identifier for the PostScript process factory (value <code>{@value}</code>).
     * Matches plugin.xml
     * extension[@point="org.eclipse.debug.core.processFactories"]/processFactory/@id
     */
	val public static ID = PSPlugin.ID + ".processFactory" //$NON-NLS-1$

    /**
     * Creates and returns a new process representing the given
     * <code>java.lang.Process</code> equipped with a specialized streams proxy
     * for the I/O streams of the Ghostscript process.
     *
     * @see PSStreamsProxy
     */
	override newProcess(ILaunch launch, Process process, String label, Map<String, String> attributes) {
		new RuntimeProcess(launch, process, label, attributes) {

			override protected createStreamsProxy() {
				new PSStreamsProxy(systemProcess, launch.consoleEncoding)
			}
		}
	}
}
