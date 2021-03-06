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

import com.google.inject.Inject
import de.tfritsch.psdt.help.PSHelpContexts
import java.util.List
import org.eclipse.debug.core.ILaunchConfiguration
import org.eclipse.debug.core.ILaunchConfigurationWorkingCopy
import org.eclipse.debug.ui.AbstractLaunchConfigurationTab
import org.eclipse.debug.ui.ILaunchConfigurationDialog
import org.eclipse.debug.ui.ILaunchConfigurationTab
import org.eclipse.swt.SWT
import org.eclipse.swt.layout.GridLayout
import org.eclipse.swt.widgets.Composite
import org.eclipse.ui.help.IWorkbenchHelpSystem
import org.eclipse.xtext.ui.IImageHelper

/**
 * @author Thomas Fritsch - initial API and implementation
 */
class GhostscriptTab extends AbstractLaunchConfigurationTab {

	List<ILaunchConfigurationTab> fBlocks

	@Inject IImageHelper fImageHelper
    @Inject extension IWorkbenchHelpSystem

	@Inject
	new(GhostscriptInterpreterBlock block1, GhostscriptArgumentsBlock block2, GhostscriptWorkingDirectoryBlock block3) {
		fBlocks = newArrayList(block1, block2, block3)
		helpContextId = PSHelpContexts.LAUNCH_CONFIGURATION_DIALOG_GHOSTSCRIPT_TAB
	}

	override getName() {
		"Ghostscript" //$NON-NLS-1$
	}

	override getImage() {
		fImageHelper.getImage("ghostscript.png") //$NON-NLS-1$
	}

	override createControl(Composite parent) {
		val comp = new Composite(parent, SWT.NONE) => [
			layout = new GridLayout(1, true)
			help = helpContextId
		]
		fBlocks.forEach[createControl(comp)]
		control = comp
	}

	override setLaunchConfigurationDialog(ILaunchConfigurationDialog dialog) {
		super.setLaunchConfigurationDialog(dialog)
		fBlocks.forEach[setLaunchConfigurationDialog(dialog)]
	}

	override setDefaults(ILaunchConfigurationWorkingCopy configuration) {
		fBlocks.forEach[setDefaults(configuration)]
	}

	override initializeFrom(ILaunchConfiguration configuration) {
		fBlocks.forEach[initializeFrom(configuration)]
	}

	override performApply(ILaunchConfigurationWorkingCopy configuration) {
		fBlocks.forEach[performApply(configuration)]
	}

	override isValid(ILaunchConfiguration launchConfig) {
	    this.errorMessage = null
		fBlocks.forall [
			val valid = isValid(launchConfig)
			if (!valid)
				this.errorMessage = errorMessage
			valid
		]
	}
}
