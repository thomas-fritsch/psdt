package de.tfritsch.psdt.debug.model

import java.io.File
import org.eclipse.core.runtime.CoreException
import org.eclipse.core.runtime.Path
import org.eclipse.debug.core.ILaunchConfiguration
import org.eclipse.debug.core.model.IPersistableSourceLocator
import org.eclipse.debug.core.model.IStackFrame
import org.eclipse.debug.core.sourcelookup.containers.LocalFileStorage

import static extension org.eclipse.core.filebuffers.FileBuffers.*

/**
 * The PostScript source locator knows how to translate a PostScript stack
 * frame into a source file name. 
 * 
 * Matches plugin.xml
 * extension[@point="org.eclipse.debug.core.sourceLocators"]/sourceLocator/@class
 */
public class PSSourceLocator implements IPersistableSourceLocator {
	override Object getSourceElement(IStackFrame stackFrame) {
		if (stackFrame instanceof PSStackFrame) {
			val psFile = stackFrame.sourceName
			val file = new Path(psFile).getWorkspaceFileAtLocation
			return file ?: new LocalFileStorage(new File(psFile))
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
