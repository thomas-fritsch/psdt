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
import java.util.List
import org.eclipse.debug.core.ILaunchConfiguration
import org.eclipse.debug.core.ILaunchConfigurationWorkingCopy
import org.eclipse.debug.ui.AbstractLaunchConfigurationTab
import org.eclipse.debug.ui.ILaunchConfigurationDialog
import org.eclipse.debug.ui.ILaunchConfigurationTab
import org.eclipse.swt.SWT
import org.eclipse.swt.graphics.Image
import org.eclipse.swt.layout.GridLayout
import org.eclipse.swt.widgets.Composite
import org.eclipse.xtext.ui.IImageHelper

/**
 * @author Thomas Fritsch - initial API and implementation
 */
class GhostscriptTab extends AbstractLaunchConfigurationTab {

	List<ILaunchConfigurationTab> fBlocks

	@Inject IImageHelper fImageHelper

	@Inject
	new(GhostscriptInterpreterBlock block1, GhostscriptArgumentsBlock block2, GhostscriptWorkingDirectoryBlock block3) {
		fBlocks = newArrayList(block1, block2, block3)
	}

	override String getName() {
		return "Ghostscript" //$NON-NLS-1$
	}

	override Image getImage() {
		return fImageHelper.getImage("ghostscript.png") //$NON-NLS-1$
	}

	override void createControl(Composite parent) {
		val comp = new Composite(parent, SWT.NONE)
		comp.layout = new GridLayout(1, true)
		fBlocks.forEach[createControl(comp)]
		control = comp
	}

	override void setLaunchConfigurationDialog(ILaunchConfigurationDialog dialog) {
		super.setLaunchConfigurationDialog(dialog)
		fBlocks.forEach[setLaunchConfigurationDialog(dialog)]
	}

	override void setDefaults(ILaunchConfigurationWorkingCopy configuration) {
		fBlocks.forEach[setDefaults(configuration)]
	}

	override void initializeFrom(ILaunchConfiguration configuration) {
		fBlocks.forEach[initializeFrom(configuration)]
	}

	override void performApply(ILaunchConfigurationWorkingCopy configuration) {
		fBlocks.forEach[performApply(configuration)]
	}

	override boolean isValid(ILaunchConfiguration launchConfig) {
		val block = fBlocks.findFirst[!isValid(launchConfig)]
		errorMessage = block?.errorMessage
		return block !== null
	}
}
