package de.tfritsch.psdt.debug.ui;

import java.util.ArrayList;
import java.util.List;

import org.eclipse.core.resources.IFile;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.debug.core.DebugPlugin;
import org.eclipse.debug.core.ILaunchConfiguration;
import org.eclipse.debug.core.ILaunchConfigurationType;
import org.eclipse.debug.core.ILaunchConfigurationWorkingCopy;
import org.eclipse.debug.core.ILaunchManager;
import org.eclipse.debug.ui.DebugUITools;
import org.eclipse.debug.ui.IDebugModelPresentation;
import org.eclipse.debug.ui.ILaunchShortcut;
import org.eclipse.jface.viewers.ISelection;
import org.eclipse.jface.viewers.IStructuredSelection;
import org.eclipse.jface.window.Window;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.ui.IEditorInput;
import org.eclipse.ui.IEditorPart;
import org.eclipse.ui.PlatformUI;
import org.eclipse.ui.dialogs.ElementListSelectionDialog;

import de.tfritsch.psdt.debug.IPSConstants;
import de.tfritsch.psdt.debug.model.PSLaunchConfigurationDelegate;
import de.tfritsch.psdt.debug.model.PSProcessFactory;
import de.tfritsch.psdt.debug.ui.Messages;

/**
 * Matches plugin.xml
 * extension[@point="org.eclipse.debug.ui.launchShortcuts"]/shortcut/@class
 */
public class PSLaunchShortcut implements ILaunchShortcut {

	public PSLaunchShortcut() {
	}

	//@Override
	public void launch(ISelection selection, String mode) {
		if (!(selection instanceof IStructuredSelection))
			return;
		Object element = ((IStructuredSelection) selection).getFirstElement();
		if (element instanceof IFile)
			launch((IFile) element, mode);
	}

	//@Override
	public void launch(IEditorPart editor, String mode) {
		IEditorInput editorInput = editor.getEditorInput();
		IFile file = (IFile) editorInput.getAdapter(IFile.class);
		if (file != null)
			launch(file, mode);
	}

	private void launch(IFile file, String mode) {
		String program = file.getLocation().toFile().toString();
		ILaunchConfiguration[] configurations = getConfigurations(program);
		ILaunchConfiguration configuration;
		switch (configurations.length) {
		case 0:
			configuration = createConfiguration(program);
			break;
		case 1:
			configuration = configurations[0];
			break;
		default:
			configuration = chooseConfiguration(configurations);
		}
		if (configuration != null)
			DebugUITools.launch(configuration, mode);
	}

	private ILaunchConfiguration[] getConfigurations(String program) {
		List<ILaunchConfiguration> result = new ArrayList<ILaunchConfiguration>();
		ILaunchManager manager = DebugPlugin.getDefault().getLaunchManager();
		ILaunchConfigurationType type = manager
				.getLaunchConfigurationType(PSLaunchConfigurationDelegate.ID);
		try {
			ILaunchConfiguration[] configurations = manager
					.getLaunchConfigurations(type);
			for (ILaunchConfiguration configuration : configurations) {
				if (!DebugUITools.isPrivate(configuration)
						&& program.equals(configuration.getAttribute(
								IPSConstants.ATTR_PROGRAM, (String) null))) {
					result.add(configuration);
				}
			}
		} catch (CoreException e) {
		}
		return result.toArray(new ILaunchConfiguration[result.size()]);
	}

	private ILaunchConfiguration createConfiguration(String program) {
		ILaunchManager manager = DebugPlugin.getDefault().getLaunchManager();
		ILaunchConfigurationType type = manager
				.getLaunchConfigurationType(PSLaunchConfigurationDelegate.ID);
		String name = manager.generateLaunchConfigurationName(type.getName());
		try {
			ILaunchConfigurationWorkingCopy wc = type.newInstance(null, name);
			wc.setAttribute(IPSConstants.ATTR_PROGRAM, program);
			wc.setAttribute(DebugPlugin.ATTR_PROCESS_FACTORY_ID,
					PSProcessFactory.ID);
			wc.setAttribute(IPSConstants.ATTR_GS_ARGUMENTS, "-dBATCH"); //$NON-NLS-1$
			return wc.doSave();
		} catch (CoreException e) {
			return null;
		}
	}

	private ILaunchConfiguration chooseConfiguration(
			ILaunchConfiguration[] configs) {
		IDebugModelPresentation labelProvider = DebugUITools
				.newDebugModelPresentation();
		ElementListSelectionDialog dialog = new ElementListSelectionDialog(
				getShell(), labelProvider);
		dialog.setElements(configs);
		dialog.setTitle(Messages.PSLaunchShortcut_dialogTitle);
		dialog.setMessage(Messages.PSLaunchShortcut_dialogMessage);
		dialog.setMultipleSelection(false);
		int result = dialog.open();
		labelProvider.dispose();
		if (result == Window.OK)
			return (ILaunchConfiguration) dialog.getFirstResult();
		return null;
	}

	private Shell getShell() {
		return PlatformUI.getWorkbench().getActiveWorkbenchWindow().getShell();
	}
}
