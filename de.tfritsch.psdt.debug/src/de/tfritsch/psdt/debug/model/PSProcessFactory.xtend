package de.tfritsch.psdt.debug.model

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
 */
class PSProcessFactory implements IProcessFactory {

    /**
     * Unique identifier for the PostScript process factory (value <code>{@value}</code>).
     * Matches plugin.xml
     * extension[@point="org.eclipse.debug.core.processFactories"]/processFactory/@id
     */
	val public static ID = PSPlugin.ID + ".processFactory"; //$NON-NLS-1$

	@SuppressWarnings("rawtypes")
	override IProcess newProcess(ILaunch launch, Process process, String label, Map attributes) {
		return new RuntimeProcess(launch, process, label, attributes) {

			override protected IStreamsProxy createStreamsProxy() {
				return new PSStreamsProxy(systemProcess, launch.consoleEncoding)
			}
		}
	}
}
