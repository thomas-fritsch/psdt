package de.tfritsch.psdt.debug.model

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
 */
class PSSourceLocator implements IPersistableSourceLocator {
	override Object getSourceElement(IStackFrame stackFrame) {
		if (stackFrame instanceof PSStackFrame) {
			val path = new Path(stackFrame.sourceName)
			return path.getWorkspaceFileAtLocation ?: path.getFileStoreAtLocation
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
