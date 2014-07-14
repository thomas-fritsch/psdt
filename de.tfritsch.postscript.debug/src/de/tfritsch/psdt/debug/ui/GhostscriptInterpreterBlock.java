package de.tfritsch.psdt.debug.ui;

import org.eclipse.debug.core.ILaunchConfiguration;
import org.eclipse.debug.core.ILaunchConfigurationWorkingCopy;
import org.eclipse.debug.ui.AbstractLaunchConfigurationTab;
import org.eclipse.swt.SWT;
import org.eclipse.swt.events.SelectionAdapter;
import org.eclipse.swt.events.SelectionEvent;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Group;
import org.eclipse.swt.widgets.Text;
import org.eclipse.ui.dialogs.PreferencesUtil;

import de.tfritsch.psdt.debug.IPSConstants;
import de.tfritsch.psdt.debug.PSPlugin;
import de.tfritsch.psdt.debug.ui.GhostscriptPreferencePage;

public class GhostscriptInterpreterBlock extends AbstractLaunchConfigurationTab {

	private Text fInterpreterText;
	private Button fInterpreterButton;

	//@Override
	public void createControl(Composite parent) {
		Group group = new Group(parent, SWT.NONE);
		setControl(group);
		group.setLayout(new GridLayout(2, false));
		group.setLayoutData(new GridData(GridData.FILL_HORIZONTAL));
		group.setText("Ghostscript interpreter:");

		fInterpreterText = new Text(group, SWT.SINGLE | SWT.BORDER | SWT.READ_ONLY);
        fInterpreterText.setLayoutData(new GridData(GridData.FILL_BOTH));
        fInterpreterButton = createPushButton(group, "Preference...", null);
        fInterpreterButton.addSelectionListener(new SelectionAdapter() {
        	@Override
			public void widgetSelected(SelectionEvent e) {
            	String id = GhostscriptPreferencePage.ID;
            	PreferencesUtil.createPreferenceDialogOn(fInterpreterButton.getShell(),
            			id, new String[]{id}, null).open();
           		fInterpreterText.setText(getInterpreter());
                updateLaunchConfigurationDialog();
            }
        });
	}

	//@Override
	public void setDefaults(ILaunchConfigurationWorkingCopy configuration) {
	}

	//@Override
	public void initializeFrom(ILaunchConfiguration configuration) {
		fInterpreterText.setText(getInterpreter());
	}

	@Override
	public boolean isValid(ILaunchConfiguration configuration) {
		String exe = getInterpreter();
		if (exe == null || exe.length() == 0) {
			setErrorMessage("Interpreter not specified");
			return false;			
		}
		return true;
	}

	//@Override
	public void performApply(ILaunchConfigurationWorkingCopy configuration) {
	}

	//@Override
	public String getName() {
		return "Ghostscript interpreter"; //$NON-NLS-1$
	}

	private String getInterpreter() {
		return PSPlugin.getDefault().getPreferenceStore().getString(IPSConstants.PREF_INTERPRETER);
	}

}
