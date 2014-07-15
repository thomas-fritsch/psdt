package de.tfritsch.psdt.debug.ui;

import java.io.File;

import org.eclipse.core.runtime.CoreException;
import org.eclipse.debug.core.DebugPlugin;
import org.eclipse.debug.core.ILaunchConfiguration;
import org.eclipse.debug.core.ILaunchConfigurationWorkingCopy;
import org.eclipse.debug.ui.AbstractLaunchConfigurationTab;
import org.eclipse.swt.SWT;
import org.eclipse.swt.events.ModifyEvent;
import org.eclipse.swt.events.ModifyListener;
import org.eclipse.swt.events.SelectionAdapter;
import org.eclipse.swt.events.SelectionEvent;
import org.eclipse.swt.graphics.Image;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.FileDialog;
import org.eclipse.swt.widgets.Group;
import org.eclipse.swt.widgets.Text;

import de.tfritsch.psdt.debug.IPSConstants;
import de.tfritsch.psdt.debug.PSPlugin;
import de.tfritsch.psdt.debug.model.PSProcessFactory;

/**
 * Tab to specify the PostScript program to run/debug.
 */
public class PSMainTab extends AbstractLaunchConfigurationTab {

    private Text fProgramText;
    private Button fProgramButton;
    private Button fBreakOnFirstTokenButton;

    //@Override
	public String getName() {
        return "Main";
    }

    @Override
	public Image getImage() {
    	return PSPlugin.getImage("icons/postscript.png"); //$NON-NLS-1$
    }
    
    //@Override
	public void createControl(Composite parent) {
        Composite comp = new Composite(parent, SWT.NONE);
        setControl(comp);
		comp.setLayout(new GridLayout(1, true));
        
        Group group = new Group(comp, SWT.NONE);
        group.setLayout(new GridLayout(2, false));
    	group.setLayoutData(new GridData(GridData.FILL_HORIZONTAL));
    	group.setText("Program:");
        fProgramText = new Text(group, SWT.SINGLE | SWT.BORDER);
        fProgramText.setLayoutData(new GridData(GridData.FILL_HORIZONTAL));
        fProgramText.addModifyListener(new ModifyListener() {
            //@Override
			public void modifyText(ModifyEvent e) {
                updateLaunchConfigurationDialog();
            }
        });
        fProgramButton = createPushButton(group, "&Browse...", null);
        fProgramButton.addSelectionListener(new SelectionAdapter() {
            @Override
			public void widgetSelected(SelectionEvent e) {
                browsePSFiles();
            }
        });
		fBreakOnFirstTokenButton = createCheckButton(comp, "Break on first token");
		fBreakOnFirstTokenButton.addSelectionListener(new SelectionAdapter() {
            @Override
			public void widgetSelected(SelectionEvent e) {
                updateLaunchConfigurationDialog();
            }
        });
    }

    /**
     * Open a file dialog to select a PostScript program 
     */
    protected void browsePSFiles() {
        FileDialog dialog = new FileDialog(getShell(), SWT.OPEN);
        dialog.setFileName(fProgramText.getText());
        dialog.setFilterExtensions(new String[] { "*.ps;*.eps", "*" }); //$NON-NLS-1$ //$NON-NLS-2$
        String s = dialog.open();
        if (s != null) {
            fProgramText.setText(s);
        }
    }
    
	//@Override
	public void setDefaults(ILaunchConfigurationWorkingCopy configuration) {
        configuration.setAttribute(DebugPlugin.ATTR_PROCESS_FACTORY_ID, PSProcessFactory.ID);
    	configuration.setAttribute(IPSConstants.ATTR_BREAK_ON_FIRST_TOKEN, false);
    }

    //@Override
	public void initializeFrom(ILaunchConfiguration configuration) {
        try {
            String program = configuration.getAttribute(IPSConstants.ATTR_PROGRAM, (String)null);
            if (program != null) {
                fProgramText.setText(program);
            }
        } catch (CoreException e) {
            setErrorMessage(e.getMessage());
        }
        try {
            fBreakOnFirstTokenButton.setSelection(configuration.getAttribute(
            		IPSConstants.ATTR_BREAK_ON_FIRST_TOKEN, false));
        } catch (CoreException e) {
            setErrorMessage(e.getMessage());
        }
    }

    //@Override
	public void performApply(ILaunchConfigurationWorkingCopy configuration) {
        String program = fProgramText.getText();
        if (program.length() == 0) {
            program = null;
        }
        configuration.setAttribute(IPSConstants.ATTR_PROGRAM, program);
        configuration.setAttribute(IPSConstants.ATTR_BREAK_ON_FIRST_TOKEN,
        		fBreakOnFirstTokenButton.getSelection());
    }

    @Override
	public boolean isValid(ILaunchConfiguration launchConfig) {
        String program = fProgramText.getText();
        if (program.length() == 0) {
            setErrorMessage("Specify a program");
            return false;
        }
        if (!(new File(program)).exists()) {
            setErrorMessage("Specified program does not exist");
            return false;
        }
        setErrorMessage(null);
        return true;
    }
}
