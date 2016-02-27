package de.tfritsch.psdt.debug.ui.launch

import org.eclipse.core.runtime.CoreException
import org.eclipse.debug.core.DebugPlugin
import org.eclipse.debug.core.ILaunchConfiguration
import org.eclipse.debug.ui.WorkingDirectoryBlock

class GhostscriptWorkingDirectoryBlock extends WorkingDirectoryBlock {

	new() {
		super(DebugPlugin.ATTR_WORKING_DIRECTORY)
	}

	override protected getProject(ILaunchConfiguration configuration) throws CoreException {
		return null
	}

}
