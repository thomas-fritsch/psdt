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
package de.tfritsch.psdt.debug.core.sourcelookup

import de.tfritsch.psdt.debug.core.model.PSStackFrame
import org.eclipse.core.runtime.CoreException
import org.eclipse.core.runtime.Path
import org.eclipse.debug.core.ILaunchConfiguration
import org.eclipse.debug.core.model.IPersistableSourceLocator
import org.eclipse.debug.core.model.IStackFrame

import static extension org.eclipse.core.filebuffers.FileBuffers.*

/**
 * The PostScript source locator knows how to translate a PostScript stack
 * frame into a source file name. 
 * 
 * Matches plugin.xml
 * extension[@point="org.eclipse.debug.core.sourceLocators"]/sourceLocator/@class
 * 
 * @author Thomas Fritsch - initial API and implementation
 */
class PSSourceLocator implements IPersistableSourceLocator {
	override getSourceElement(IStackFrame stackFrame) {
		switch (stackFrame) {
			PSStackFrame: {
				val path = new Path(stackFrame.sourceName)
				path.workspaceFileAtLocation ?: path.fileStoreAtLocation
			}
			default:
				null
        }
	}

	override getMemento() throws CoreException {
		null
	}

	override initializeDefaults(ILaunchConfiguration configuration) throws CoreException {
	}

	override initializeFromMemento(String memento) throws CoreException {
	}
}
