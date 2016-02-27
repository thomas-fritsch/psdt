package de.tfritsch.psdt.debug.ui.launch

import com.google.inject.Inject
import org.eclipse.core.resources.IProject
import org.eclipse.core.runtime.CoreException
import org.eclipse.debug.core.DebugPlugin
import org.eclipse.debug.core.ILaunchConfiguration
import org.eclipse.debug.core.ILaunchConfigurationWorkingCopy
import org.eclipse.debug.ui.AbstractLaunchConfigurationTab
import org.eclipse.debug.ui.ILaunchConfigurationDialog
import org.eclipse.debug.ui.ILaunchConfigurationTab
import org.eclipse.debug.ui.WorkingDirectoryBlock
import org.eclipse.swt.SWT
import org.eclipse.swt.graphics.Image
import org.eclipse.swt.layout.GridLayout
import org.eclipse.swt.widgets.Composite
import org.eclipse.xtext.ui.IImageHelper

class GhostscriptTab extends AbstractLaunchConfigurationTab {

	@Inject	GhostscriptInterpreterBlock ghostscriptInterpreterBlock
	@Inject	GhostscriptArgumentsBlock ghostscriptArgumentsBlock
	ILaunchConfigurationTab[] fBlocks

	@Inject IImageHelper fImageHelper

	override String getName() {
		return "Ghostscript" //$NON-NLS-1$
	}

	def private ILaunchConfigurationTab[] getBlocks() {
		if (fBlocks === null) {
			fBlocks = #[
				ghostscriptInterpreterBlock,
				ghostscriptArgumentsBlock,
				new WorkingDirectoryBlock(DebugPlugin.ATTR_WORKING_DIRECTORY) {
					override protected IProject getProject(ILaunchConfiguration configuration) throws CoreException {
						return null
					}
				}
			]
		}
		return fBlocks
	}

	override Image getImage() {
		return fImageHelper.getImage("ghostscript.png") //$NON-NLS-1$
	}

	override void createControl(Composite parent) {
		val comp = new Composite(parent, SWT.NONE) => [
			layout = new GridLayout(1, true)
		]
		for (block : blocks) {
			block.createControl(comp)
		}
		control = comp
	}

	override void setLaunchConfigurationDialog(ILaunchConfigurationDialog dialog) {
		super.setLaunchConfigurationDialog(dialog)
		for (block : blocks) {
			block.setLaunchConfigurationDialog(dialog)
		}
	}

	override void setDefaults(ILaunchConfigurationWorkingCopy configuration) {
		for (block : fBlocks) {
			block.setDefaults(configuration)
		}
	}

	override void initializeFrom(ILaunchConfiguration configuration) {
		for (block : blocks) {
			block.initializeFrom(configuration)
		}
	}

	override void performApply(ILaunchConfigurationWorkingCopy configuration) {
		for (block : blocks) {
			block.performApply(configuration)
		}
	}

	override boolean isValid(ILaunchConfiguration launchConfig) {
		for (block : blocks) {
			if (!block.isValid(launchConfig)) {
				errorMessage = block.errorMessage
				return false
			}
		}
		errorMessage = null
		return true
	}
}
