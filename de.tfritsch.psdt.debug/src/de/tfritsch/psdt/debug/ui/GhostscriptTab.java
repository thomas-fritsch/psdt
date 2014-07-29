package de.tfritsch.psdt.debug.ui;

import org.eclipse.core.resources.IProject;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.debug.core.DebugPlugin;
import org.eclipse.debug.core.ILaunchConfiguration;
import org.eclipse.debug.core.ILaunchConfigurationWorkingCopy;
import org.eclipse.debug.ui.AbstractLaunchConfigurationTab;
import org.eclipse.debug.ui.ILaunchConfigurationDialog;
import org.eclipse.debug.ui.ILaunchConfigurationTab;
import org.eclipse.debug.ui.WorkingDirectoryBlock;
import org.eclipse.swt.SWT;
import org.eclipse.swt.graphics.Image;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.widgets.Composite;

import de.tfritsch.psdt.debug.PSPlugin;

public class GhostscriptTab extends AbstractLaunchConfigurationTab {

    private ILaunchConfigurationTab[] fBlocks;

    //@Override
	public String getName() {
        return "Ghostscript"; //$NON-NLS-1$
    }

    public GhostscriptTab() {
    	fBlocks = new ILaunchConfigurationTab[] {
    	    	new GhostscriptInterpreterBlock(),
    	    	new GhostscriptArgumentsBlock(),
    	        new WorkingDirectoryBlock(DebugPlugin.ATTR_WORKING_DIRECTORY) {
					@Override
					protected IProject getProject(ILaunchConfiguration configuration)
							throws CoreException {
						return null;
					}
    	    	}
    	};
    }

    @Override
	public Image getImage() {
    	return PSPlugin.getImage("icons/ghostscript.png"); //$NON-NLS-1$
    }
    
    //@Override
	public void createControl(Composite parent) {
        Composite comp = new Composite(parent, SWT.NONE);
        setControl(comp);
		comp.setLayout(new GridLayout(1, true));
        for (ILaunchConfigurationTab block : fBlocks) {
        	block.createControl(comp);
        }
    }

	@Override
	public void setLaunchConfigurationDialog(ILaunchConfigurationDialog dialog) {
		super.setLaunchConfigurationDialog(dialog);
		for (ILaunchConfigurationTab block : fBlocks) {
			block.setLaunchConfigurationDialog(dialog);
		}
	}	

	//@Override
	public void setDefaults(ILaunchConfigurationWorkingCopy configuration) {
        for (ILaunchConfigurationTab block : fBlocks) {
        	block.setDefaults(configuration);
        }
    }

    //@Override
	public void initializeFrom(ILaunchConfiguration configuration) {
        for (ILaunchConfigurationTab block : fBlocks) {
        	block.initializeFrom(configuration);
        }
    }

    //@Override
	public void performApply(ILaunchConfigurationWorkingCopy configuration) {
        for (ILaunchConfigurationTab block : fBlocks) {
        	block.performApply(configuration);
        }
    }

    @Override
	public boolean isValid(ILaunchConfiguration launchConfig) {
        for (ILaunchConfigurationTab block : fBlocks) {
        	if (!block.isValid(launchConfig)) {
        		setErrorMessage(block.getErrorMessage());
        		return false;
        	}
        }
        setErrorMessage(null);
        return true;
    }
}
