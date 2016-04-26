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

import com.google.common.io.CharStreams
import de.tfritsch.psdt.PostscriptUiInjectorProvider
import java.io.IOException
import java.io.InputStreamReader
import java.lang.reflect.InvocationTargetException
import org.eclipse.core.resources.IFile
import org.eclipse.core.resources.IProject
import org.eclipse.core.runtime.CoreException
import org.eclipse.core.runtime.NullProgressMonitor
import org.eclipse.jface.operation.IRunnableWithProgress
import org.eclipse.jface.viewers.StructuredSelection
import org.eclipse.jface.wizard.IWizard
import org.eclipse.jface.wizard.IWizardContainer
import org.eclipse.jface.wizard.IWizardPage
import org.eclipse.swt.widgets.Shell
import org.eclipse.ui.IWorkbenchWizard
import org.eclipse.xtext.junit4.InjectWith
import org.eclipse.xtext.junit4.XtextRunner
import org.eclipse.xtext.junit4.ui.AbstractWorkbenchTest
import org.junit.Test
import org.junit.runner.RunWith

import static org.eclipse.xtext.junit4.ui.util.JavaProjectSetupUtil.createSimpleProject

import static extension org.eclipse.jface.operation.ModalContext.run

/**
 * @author Thomas Fritsch - initial API and implementation
 */
@RunWith(XtextRunner)
@InjectWith(PostscriptUiInjectorProvider)
class WizardTest extends AbstractWorkbenchTest {

	IProject project

	override setUp() throws Exception {
		super.setUp
		project = createSimpleProject("foo")
	}

	private def IWorkbenchWizard createWizard(String id) throws CoreException  {
		val wizard = workbench.newWizardRegistry.findWizard(id).createWizard
		wizard.init(workbench, new StructuredSelection(project))
		wizard.addPages
		wizard.container = new WizardContainer(workbenchWindow.shell, wizard)
		wizard.createPageControls(workbenchWindow.shell)
		return wizard
	}

	private def void assertContents(IFile file, String expected) throws IOException  {
		val reader = new InputStreamReader(file.contents)
		val actual = CharStreams.toString(reader)
		reader.close
		assertEquals(expected, actual)
	}

	@Test
	def void testNewFile() throws Exception {
		val wizard = createWizard("de.tfritsch.psdt.ui.wizards.example")
		wizard.performFinish
		wizard.dispose
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

	private static class WizardContainer implements IWizardContainer {

		Shell shell
		IWizard wizard

		new(Shell shell, IWizard wizard) {
			this.shell = shell
			this.wizard = wizard
		}

		override getCurrentPage() {
			return wizard.startingPage
		}

		override getShell() {
			return shell
		}

		override showPage(IWizardPage page) {
		}

		override updateButtons() {
		}

		override updateMessage() {
		}

		override updateTitleBar() {
		}

		override updateWindowTitle() {
		}

		override run(boolean fork, boolean cancelable, IRunnableWithProgress runnable) throws InvocationTargetException, InterruptedException {
			runnable.run(fork, new NullProgressMonitor, shell.display)
		}

	}
}
