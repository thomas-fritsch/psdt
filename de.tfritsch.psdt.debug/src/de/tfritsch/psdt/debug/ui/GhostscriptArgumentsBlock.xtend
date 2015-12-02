package de.tfritsch.psdt.debug.ui

import java.net.MalformedURLException
import java.net.URL
import org.eclipse.core.runtime.CoreException
import org.eclipse.debug.core.DebugPlugin
import org.eclipse.debug.core.ILaunchConfiguration
import org.eclipse.debug.core.ILaunchConfigurationWorkingCopy
import org.eclipse.debug.ui.AbstractLaunchConfigurationTab
import org.eclipse.osgi.util.NLS
import org.eclipse.swt.SWT
import org.eclipse.swt.layout.GridData
import org.eclipse.swt.layout.GridLayout
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Group
import org.eclipse.swt.widgets.Link
import org.eclipse.swt.widgets.Text
import org.eclipse.ui.PartInitException
import org.eclipse.ui.PlatformUI
import org.eclipse.ui.browser.IWorkbenchBrowserSupport

import static extension de.tfritsch.psdt.debug.PSLaunchExtensions.*
import static extension org.eclipse.debug.core.DebugPlugin.parseArguments

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
		control = group

		fArgumentsText = new Text(group, SWT.MULTI.bitwiseOr(SWT.WRAP).bitwiseOr(SWT.BORDER).bitwiseOr(SWT.V_SCROLL)) => [
			layoutData = new GridData(GridData.FILL_BOTH)
			addModifyListener [
				updateLaunchConfigurationDialog
			]
		]
		new Link(group, SWT.NONE) => [
			text = "Show <A>Ghostscript documentation</A> in web browser"
			addListener(SWT.Selection) [
				try {
					"gs".createBrowser.openURL(new URL("http://www.ghostscript.com/doc/current/Use.htm#Invoking")) //$NON-NLS-1$ $NON-NLS-2$
				} catch (PartInitException e) {
					DebugPlugin.log(e)
				} catch (MalformedURLException e) {
					DebugPlugin.log(e)
				}
			]
		]
	}

	override void setDefaults(ILaunchConfigurationWorkingCopy configuration) {
		configuration.ghostscriptArguments = "-dBATCH" //$NON-NLS-1$
	}

	override void initializeFrom(ILaunchConfiguration configuration) {
		try {
			fArgumentsText.text = configuration.ghostscriptArguments ?: ""
		} catch (CoreException e) {
			DebugPlugin.log(e)
		}
	}

	override boolean isValid(ILaunchConfiguration configuration) {
		for (s : fArgumentsText.text.parseArguments) {
			if (!s.startsWith("-") || s == "-") { //$NON-NLS-1$ //$NON-NLS-2$
				errorMessage = NLS.bind("{0} is not a valid option", s)
				return false
			}
		}
		return true
	}

	override void performApply(ILaunchConfigurationWorkingCopy configuration) {
		configuration.ghostscriptArguments = fArgumentsText.text
	}

	override String getName() {
		return "Ghostscript interpreter:"
	}

}
