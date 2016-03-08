/*******************************************************************************
 * Copyright (c) 2016 Thomas Fritsch.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 ******************************************************************************/
package de.tfritsch.psdt.debug.core.process

import de.tfritsch.psdt.debug.PSPlugin
import java.util.Map
import org.eclipse.debug.core.ILaunch
import org.eclipse.debug.core.IProcessFactory
import org.eclipse.debug.core.model.IProcess
import org.eclipse.debug.core.model.IStreamsProxy
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

	override IProcess newProcess(ILaunch launch, Process process, String label, Map<String, String> attributes) {
		return new RuntimeProcess(launch, process, label, attributes) {

			override protected IStreamsProxy createStreamsProxy() {
				return new PSStreamsProxy(systemProcess, launch.consoleEncoding)
			}
		}
	}
}
