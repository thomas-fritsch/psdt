package de.tfritsch.psdt.debug.ui

import de.tfritsch.psdt.debug.IPSConstants
import java.net.MalformedURLException
import java.net.URL
import org.eclipse.core.runtime.CoreException
import org.eclipse.debug.core.DebugPlugin
import org.eclipse.debug.core.ILaunchConfiguration
import org.eclipse.debug.core.ILaunchConfigurationWorkingCopy
import org.eclipse.debug.ui.AbstractLaunchConfigurationTab
import org.eclipse.osgi.util.NLS
import org.eclipse.swt.SWT
import org.eclipse.swt.events.SelectionAdapter
import org.eclipse.swt.events.SelectionEvent
import org.eclipse.swt.layout.GridData
import org.eclipse.swt.layout.GridLayout
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Group
import org.eclipse.swt.widgets.Link
import org.eclipse.swt.widgets.Text
import org.eclipse.ui.PartInitException
import org.eclipse.ui.PlatformUI
import org.eclipse.ui.browser.IWorkbenchBrowserSupport

/**
 * 
 * @author fritscht
 * @see <a href="http://www.ghostscript.com/doc/current/Use.htm#Invoking">Invoking Ghostscript</a>
 */
class GhostscriptArgumentsBlock extends AbstractLaunchConfigurationTab {

	extension IWorkbenchBrowserSupport = PlatformUI.workbench.browserSupport

	Text fArgumentsText

	override void createControl(Composite parent) {
		val Group group = new Group(parent, SWT.NONE) => [
			layout = new GridLayout
			layoutData = new GridData(GridData.FILL_BOTH)
			text = "Ghostscript arguments:"
		]
		setControl(group)

		fArgumentsText = new Text(group, SWT.MULTI.bitwiseOr(SWT.WRAP).bitwiseOr(SWT.BORDER).bitwiseOr(SWT.V_SCROLL)) => [
			layoutData = new GridData(GridData.FILL_BOTH)
			addModifyListener [
				updateLaunchConfigurationDialog
			]
		]
		new Link(group, SWT.NONE) => [
			text = "Show <A>Ghostscript documentation</A> in web browser"
			addSelectionListener(
				new SelectionAdapter {
					override void widgetSelected(SelectionEvent event) {
						try {
							val browser = "gs".createBrowser //$NON-NLS-1$
							browser.openURL(new URL("http://www.ghostscript.com/doc/current/Use.htm#Invoking")) //$NON-NLS-1$
						} catch (PartInitException e) {
							DebugPlugin.log(e)
						} catch (MalformedURLException e) {
							DebugPlugin.log(e)
						}
					}
				})
		]
	}

	override void setDefaults(ILaunchConfigurationWorkingCopy configuration) {
		configuration.setAttribute(IPSConstants.ATTR_GS_ARGUMENTS, "-dBATCH") //$NON-NLS-1$
	}

	override void initializeFrom(ILaunchConfiguration configuration) {
		try {
			val arguments = configuration.getAttribute(IPSConstants.ATTR_GS_ARGUMENTS, "") //$NON-NLS-1$
			fArgumentsText.text = arguments
		} catch (CoreException e) {
			DebugPlugin.log(e)
		}
	}

	override boolean isValid(ILaunchConfiguration configuration) {
		val arguments = fArgumentsText.text
		for (s : DebugPlugin.parseArguments(arguments)) {
			if (!s.startsWith("-") || s == "-") { //$NON-NLS-1$ //$NON-NLS-2$
				errorMessage = NLS.bind("{0} is not a valid option", s)
				return false
			}
		}
		return true
	}

	override void performApply(ILaunchConfigurationWorkingCopy configuration) {
		val arguments = fArgumentsText.text
		configuration.setAttribute(IPSConstants.ATTR_GS_ARGUMENTS, arguments)
	}

	override String getName() {
		return "Ghostscript interpreter:"
	}

}