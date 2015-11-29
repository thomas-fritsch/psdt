package de.tfritsch.psdt.debug.model;

import java.util.Map;

import org.eclipse.debug.core.ILaunch;
import org.eclipse.debug.core.IProcessFactory;
import org.eclipse.debug.core.model.IProcess;
import org.eclipse.debug.core.model.IStreamsProxy;
import org.eclipse.debug.core.model.RuntimeProcess;

import de.tfritsch.psdt.debug.LaunchExtensions;
import de.tfritsch.psdt.debug.PSPlugin;

/**
 * Matches plugin.xml
 * extension[@point="org.eclipse.debug.core.processFactories"]/processFactory/@class
 */
public class PSProcessFactory implements IProcessFactory {

    /**
     * Unique identifier for the PostScript process factory (value 
     * <code>{@value}</code>).
     * Matches plugin.xml
     *extension[@point="org.eclipse.debug.core.processFactories"]/processFactory/@id
     */
	public static final String ID = PSPlugin.ID + ".processFactory"; //$NON-NLS-1$

	public PSProcessFactory() {
	}

	@Override
	@SuppressWarnings("rawtypes")
	public IProcess newProcess(ILaunch launch, Process process, String label,
			Map attributes) {
		return new RuntimeProcess(launch, process, label, attributes) {
			
			@Override
			protected IStreamsProxy createStreamsProxy() {
				String encoding = LaunchExtensions.getConsoleEncoding(getLaunch());
				return new PSStreamsProxy(getSystemProcess(), encoding);
			}
		};
	}

}
