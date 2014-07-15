package de.tfritsch.psdt.debug.ui;

import java.net.MalformedURLException;
import java.net.URL;

import org.eclipse.core.runtime.CoreException;
import org.eclipse.debug.core.DebugPlugin;
import org.eclipse.debug.core.ILaunchConfiguration;
import org.eclipse.debug.core.ILaunchConfigurationWorkingCopy;
import org.eclipse.debug.ui.AbstractLaunchConfigurationTab;
import org.eclipse.osgi.util.NLS;
import org.eclipse.swt.SWT;
import org.eclipse.swt.events.ModifyEvent;
import org.eclipse.swt.events.ModifyListener;
import org.eclipse.swt.events.SelectionAdapter;
import org.eclipse.swt.events.SelectionEvent;
import org.eclipse.swt.layout.GridData;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Group;
import org.eclipse.swt.widgets.Link;
import org.eclipse.swt.widgets.Text;
import org.eclipse.ui.PartInitException;
import org.eclipse.ui.PlatformUI;
import org.eclipse.ui.browser.IWebBrowser;

import de.tfritsch.psdt.debug.IPSConstants;

/**
 * 
 * @author fritscht
 * @see <a href="http://www.ghostscript.com/doc/current/Use.htm#Invoking">Invoking Ghostscript</a>
 */
class GhostscriptArgumentsBlock extends AbstractLaunchConfigurationTab {

	private Text fArgumentsText;

	//@Override
	public void createControl(Composite parent) {
		Group group = new Group(parent, SWT.NONE);
		setControl(group);
		group.setLayout(new GridLayout());
		group.setLayoutData(new GridData(GridData.FILL_BOTH));
		group.setText("Ghostscript arguments:");
		
        fArgumentsText = new Text(group, SWT.MULTI | SWT.WRAP| SWT.BORDER | SWT.V_SCROLL);
        fArgumentsText.setLayoutData(new GridData(GridData.FILL_BOTH));
        fArgumentsText.addModifyListener(new ModifyListener() {
            //@Override
			public void modifyText(ModifyEvent e) {
                updateLaunchConfigurationDialog();
            }
        });
        Link link = new Link(group, SWT.NONE);
        link.setText("See <A>'Text Editors'</A> for the general text editor preferences.");
        link.addSelectionListener(new SelectionAdapter() {
			
			@Override
			public void widgetSelected(SelectionEvent event) {
				try {
					IWebBrowser browser= PlatformUI.getWorkbench().getBrowserSupport().createBrowser("gs"); //$NON-NLS-1$
					browser.openURL(new URL("http://www.ghostscript.com/doc/current/Use.htm#Invoking")); //$NON-NLS-1$
				} catch (PartInitException e) {
					DebugPlugin.log(e);
				} catch (MalformedURLException e) {
					DebugPlugin.log(e);
				}
			}
		});

	}

	//@Override
	public void setDefaults(ILaunchConfigurationWorkingCopy configuration) {
        configuration.setAttribute(IPSConstants.ATTR_GS_ARGUMENTS, "-dBATCH"); //$NON-NLS-1$
	}

	//@Override
	public void initializeFrom(ILaunchConfiguration configuration) {
        try {
			String arguments = configuration.getAttribute(IPSConstants.ATTR_GS_ARGUMENTS, ""); //$NON-NLS-1$
			fArgumentsText.setText(arguments);
		} catch (CoreException e) {
			DebugPlugin.log(e);
		}
	}

	@Override
	public boolean isValid(ILaunchConfiguration configuration) {
		String arguments = fArgumentsText.getText();
		for (String s : DebugPlugin.parseArguments(arguments)) {
			if (!s.startsWith("-") || s.equals("-")) { //$NON-NLS-1$ //$NON-NLS-2$
				setErrorMessage(NLS.bind("{0} is not a valid option", s));
				return false;
			}
		}
		return true;
	}

	//@Override
	public void performApply(ILaunchConfigurationWorkingCopy configuration) {
        String arguments = fArgumentsText.getText();
        configuration.setAttribute(IPSConstants.ATTR_GS_ARGUMENTS, arguments);
	}

	//@Override
	public String getName() {
		return "Ghostscript interpreter:";
	}

}
