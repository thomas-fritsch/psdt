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
package de.tfritsch.psdt.debug.ui.launch

import javax.inject.Inject
import org.eclipse.debug.ui.AbstractLaunchConfigurationTabGroup
import org.eclipse.debug.ui.CommonTab
import org.eclipse.debug.ui.EnvironmentTab
import org.eclipse.debug.ui.ILaunchConfigurationDialog

/**
 * Tab group for launching a PostScript program.
 * 
 * Matches plugin.xml
 * extension[@point="org.eclipse.debug.ui.launchConfigurationTabGroups"]/launchConfigurationTabGroup/@class
 * 
 * @author Thomas Fritsch - initial API and implementation
 */
class PSTabGroup extends AbstractLaunchConfigurationTabGroup {

	@Inject
	PSMainTab mainTab

	@Inject
	GhostscriptTab ghostscriptTab

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
