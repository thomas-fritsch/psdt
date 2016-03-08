/*******************************************************************************
 * Copyright (c) 2016 Thomas Fritsch.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
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
	override Object getSourceElement(IStackFrame stackFrame) {
		if (stackFrame instanceof PSStackFrame) {
			val path = new Path(stackFrame.sourceName)
			return path.workspaceFileAtLocation ?: path.fileStoreAtLocation
		}
		return null
	}

	override String getMemento() throws CoreException {
		return null
	}

	override void initializeDefaults(ILaunchConfiguration configuration) throws CoreException {
	}

	override void initializeFromMemento(String memento) throws CoreException {
	}
}
