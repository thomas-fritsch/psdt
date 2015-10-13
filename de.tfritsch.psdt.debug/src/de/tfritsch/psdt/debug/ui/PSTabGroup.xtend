package de.tfritsch.psdt.debug.ui

import org.eclipse.debug.ui.AbstractLaunchConfigurationTabGroup
import org.eclipse.debug.ui.CommonTab
import org.eclipse.debug.ui.EnvironmentTab
import org.eclipse.debug.ui.ILaunchConfigurationDialog

/**
 * Tab group for launching a PostScript program.
 * 
 * Matches plugin.xml
 * extension[@point="org.eclipse.debug.ui.launchConfigurationTabGroups"]/launchConfigurationTabGroup/@class
 */
public class PSTabGroup extends AbstractLaunchConfigurationTabGroup {

	override void createTabs(ILaunchConfigurationDialog dialog, String mode) {
		tabs = #[
			new PSMainTab,
			new GhostscriptTab,
			//new SourceLookupTab,
			new EnvironmentTab,
			new CommonTab
		]
	}
}
