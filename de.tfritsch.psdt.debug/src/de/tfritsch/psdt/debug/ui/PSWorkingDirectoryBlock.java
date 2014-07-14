package de.tfritsch.psdt.debug.ui;

import org.eclipse.core.resources.IProject;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.debug.core.DebugPlugin;
import org.eclipse.debug.core.ILaunchConfiguration;
import org.eclipse.debug.ui.WorkingDirectoryBlock;

// copied from org.eclipse.jdt.internal.debug.ui.launcher.JavaWorkingDirectoryBlock
class PSWorkingDirectoryBlock extends WorkingDirectoryBlock {

	PSWorkingDirectoryBlock() {
		super(DebugPlugin.ATTR_WORKING_DIRECTORY);
	}

	@Override
	protected IProject getProject(ILaunchConfiguration configuration)
			throws CoreException {
		// TODO Auto-generated method stub
		return null;
	}

}
