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
package de.tfritsch.psdt.tests

import de.tfritsch.psdt.PostscriptUiInjectorProvider
import java.io.IOException
import org.eclipse.core.resources.IFile
import org.eclipse.core.resources.IProject
import org.eclipse.core.runtime.CoreException
import org.eclipse.jface.viewers.StructuredSelection
import org.eclipse.jface.wizard.WizardDialog
import org.eclipse.swt.widgets.Display
import org.eclipse.ui.IWorkbenchWizard
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.ui.AbstractWorkbenchTest
import org.junit.Test
import org.junit.runner.RunWith

import static org.eclipse.xtext.junit4.ui.util.IResourcesSetupUtil.createProject

import static extension org.eclipse.xtext.junit4.ui.util.IResourcesSetupUtil.fileToString

/**
 * @author Thomas Fritsch - initial API and implementation
 */
@RunWith(XtextRunner)
@InjectWith(PostscriptUiInjectorProvider)
class WizardTest extends AbstractWorkbenchTest {

	IProject project

	override setUp() throws Exception {
		super.setUp
		project = createProject("foo")
	}

	private def IWorkbenchWizard createWizard(String id) throws CoreException  {
		val wizard = workbench.newWizardRegistry.findWizard(id).createWizard
		wizard.init(workbench, new StructuredSelection(project))
		return wizard
	}

	private def void openAndFinish(IWorkbenchWizard wizard) {
		val dialog = new WizardDialog(workbenchWindow.shell, wizard) {
			override open() {
				Display.current.asyncExec [
					sleep(5000)
					finishPressed
				]
				return super.open
			}
		}
		dialog.create
		dialog.open
	}

	private def void assertContents(IFile file, String expected) throws CoreException, IOException {
		val actual = file.fileToString
		assertEquals(expected, actual)
	}

	@Test
	def void testNewFile() throws Exception {
		createWizard("de.tfritsch.psdt.ui.wizards.example").openAndFinish
		val file = project.getFile("hello-world.ps")
		assertTrue(file.exists)
		file.assertContents(
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
			''')
	}
}
