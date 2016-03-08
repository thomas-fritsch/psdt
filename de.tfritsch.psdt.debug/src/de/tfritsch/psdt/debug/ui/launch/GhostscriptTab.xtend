/*******************************************************************************
 * Copyright (c) 2016 Thomas Fritsch.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
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
