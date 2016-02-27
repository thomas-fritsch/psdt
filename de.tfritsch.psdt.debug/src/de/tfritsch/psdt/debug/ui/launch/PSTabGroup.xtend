package de.tfritsch.psdt.debug.ui.launch

import de.tfritsch.psdt.debug.PSPlugin
import org.eclipse.debug.ui.AbstractLaunchConfigurationTabGroup
import org.eclipse.debug.ui.CommonTab
import org.eclipse.debug.ui.EnvironmentTab
import org.eclipse.debug.ui.ILaunchConfigurationDialog
import javax.inject.Inject

/**
 * Tab group for launching a PostScript program.
 * 
 * Matches plugin.xml
 * extension[@point="org.eclipse.debug.ui.launchConfigurationTabGroups"]/launchConfigurationTabGroup/@class
 */
class PSTabGroup extends AbstractLaunchConfigurationTabGroup {

	@Inject
	PSMainTab mainTab

	@Inject
	GhostscriptTab ghostscriptTab
	
	new() {
		PSPlugin.injector.injectMembers(this) // TODO remove this hack
	}

	override void createTabs(ILaunchConfigurationDialog dialog, String mode) {
		tabs = #[
			mainTab,
			ghostscriptTab,
			//new SourceLookupTab,
			new EnvironmentTab,
			new CommonTab
		]
	}
}
