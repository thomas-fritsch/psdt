/*******************************************************************************
 * Copyright (C) 2016  Thomas Fritsch.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 ******************************************************************************/
package de.tfritsch.psdt.debug.ui.launch

import com.google.inject.Inject
import com.google.inject.name.Named
import de.tfritsch.psdt.debug.PSPlugin
import java.net.MalformedURLException
import java.net.URL
import org.eclipse.core.runtime.CoreException
import org.eclipse.debug.core.ILaunchConfiguration
import org.eclipse.debug.core.ILaunchConfigurationWorkingCopy
import org.eclipse.debug.ui.AbstractLaunchConfigurationTab
import org.eclipse.jface.preference.IPreferenceStore
import org.eclipse.osgi.util.NLS
import org.eclipse.swt.SWT
import org.eclipse.swt.layout.GridData
import org.eclipse.swt.layout.GridLayout
import org.eclipse.swt.widgets.Composite
import org.eclipse.swt.widgets.Group
import org.eclipse.swt.widgets.Link
import org.eclipse.swt.widgets.Text
import org.eclipse.ui.PartInitException
import org.eclipse.ui.browser.IWorkbenchBrowserSupport

import static extension de.tfritsch.psdt.debug.PSLaunchExtensions.*
import static extension org.eclipse.debug.core.DebugPlugin.parseArguments

/**
 * 
 * @author Thomas Fritsch - initial API and implementation
 * @see <a href="http://www.ghostscript.com/doc/current/Use.htm#Invoking">Invoking Ghostscript</a>
 */
class GhostscriptArgumentsBlock extends AbstractLaunchConfigurationTab {

	@Inject IWorkbenchBrowserSupport browserSupport
	@Inject @Named("debug") IPreferenceStore preferenceStore

	Text fArgumentsText
	Link fLink

	override void createControl(Composite parent) {
		val group = new Group(parent, SWT.NONE) => [
			layout = new GridLayout
			layoutData = new GridData(GridData.FILL_BOTH)
			text = "Ghostscript arguments:"
		]
		control = group

		fArgumentsText = new Text(group, SWT.MULTI.bitwiseOr(SWT.WRAP).bitwiseOr(SWT.BORDER).bitwiseOr(SWT.V_SCROLL)) => [
			layoutData = new GridData(GridData.FILL_BOTH)
			addModifyListener [updateLaunchConfigurationDialog]
		]
		fLink = new Link(group, SWT.NONE) => [
			text = "Show <A>Ghostscript documentation</A> in web browser"
			addListener(SWT.Selection)[browseGhostscriptDoc]
		]
	}

	def protected void browseGhostscriptDoc() {
		try {
			browserSupport.createBrowser(
				IWorkbenchBrowserSupport.NAVIGATION_BAR.bitwiseOr(IWorkbenchBrowserSupport.LOCATION_BAR),
				"gs", // id
				null, // name = HTMLtitle
				"Documentation" // tooltip
			).openURL(new URL("http://www.ghostscript.com/doc/current/Use.htm#Invoking")) //$NON-NLS-1$ $NON-NLS-2$
		} catch (PartInitException e) {
			PSPlugin.log(e)
		} catch (MalformedURLException e) {
			PSPlugin.log(e)
		}
	}

	override void setDefaults(ILaunchConfigurationWorkingCopy configuration) {
		configuration.ghostscriptArguments = preferenceStore.defaultGhostscriptArguments
	}

	override void initializeFrom(ILaunchConfiguration configuration) {
		try {
			fArgumentsText.text = configuration.ghostscriptArguments ?: ""
		} catch (CoreException e) {
			PSPlugin.log(e)
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
