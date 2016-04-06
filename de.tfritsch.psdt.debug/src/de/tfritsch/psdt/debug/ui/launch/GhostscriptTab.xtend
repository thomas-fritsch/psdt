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

	ILaunchConfigurationTab[] fBlocks

	@Inject IImageHelper fImageHelper

	@Inject
	new(GhostscriptInterpreterBlock block1, GhostscriptArgumentsBlock block2, GhostscriptWorkingDirectoryBlock block3) {
		fBlocks = #[block1, block2, block3]
	}

	override String getName() {
		return "Ghostscript" //$NON-NLS-1$
	}

	override Image getImage() {
		return fImageHelper.getImage("ghostscript.png") //$NON-NLS-1$
	}

	override void createControl(Composite parent) {
		val comp = new Composite(parent, SWT.NONE) => [
			layout = new GridLayout(1, true)
		]
		for (block : fBlocks) {
			block.createControl(comp)
		}
		control = comp
	}

	override void setLaunchConfigurationDialog(ILaunchConfigurationDialog dialog) {
		super.setLaunchConfigurationDialog(dialog)
		for (block : fBlocks) {
			block.setLaunchConfigurationDialog(dialog)
		}
	}

	override void setDefaults(ILaunchConfigurationWorkingCopy configuration) {
		for (block : fBlocks) {
			block.setDefaults(configuration)
		}
	}

	override void initializeFrom(ILaunchConfiguration configuration) {
		for (block : fBlocks) {
			block.initializeFrom(configuration)
		}
	}

	override void performApply(ILaunchConfigurationWorkingCopy configuration) {
		for (block : fBlocks) {
			block.performApply(configuration)
		}
	}

	override boolean isValid(ILaunchConfiguration launchConfig) {
		for (block : fBlocks) {
			if (!block.isValid(launchConfig)) {
				errorMessage = block.errorMessage
				return false
			}
		}
		errorMessage = null
		return true
	}
}
