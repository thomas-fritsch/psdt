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
package de.tfritsch.psdt.ui.wizards

import org.eclipse.core.resources.IFile
import org.eclipse.core.resources.IResource
import org.eclipse.core.runtime.NullProgressMonitor
import org.eclipse.ui.dialogs.WizardNewFileCreationPage
import org.eclipse.ui.wizards.newresource.BasicNewFileResourceWizard
import org.eclipse.xtext.util.StringInputStream

/**
 * Wizard for creating a new PostScript file.
 * 
 * Matches plugin.xml extension[@point="org.eclipse.ui.newWizards"]/wizard/@class
 * 
 * @author Thomas Fritsch - initial API and implementation
 */
class NewPostscriptFileWizard extends BasicNewFileResourceWizard {

	override addPages() {
		super.addPages
		val page = pages.get(0) as WizardNewFileCreationPage
		page.fileName = "hello-world"
		page.fileExtension = "ps"
	}

	protected override selectAndReveal(IResource newResource) {
		(newResource as IFile).setContents(
			new StringInputStream(
				'''
					%!PS-Adobe-2.0
					% The indispensable Hello World program in PostScript
					<<
					  /PageSize [595 841]
					>> setpagedevice
					/Times-Roman findfont 60 scalefont setfont
					50 600 moveto
					(Hello World) show
					showpage
				'''), true, false, new NullProgressMonitor)
		super.selectAndReveal(newResource)
	}

}
