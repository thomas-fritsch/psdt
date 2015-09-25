package de.tfritsch.psdt.debug.model;

import java.io.File;

import org.eclipse.core.filebuffers.FileBuffers;
import org.eclipse.core.resources.IFile;
import org.eclipse.core.runtime.CoreException;
import org.eclipse.core.runtime.Path;
import org.eclipse.debug.core.ILaunchConfiguration;
import org.eclipse.debug.core.model.IPersistableSourceLocator;
import org.eclipse.debug.core.model.IStackFrame;
import org.eclipse.debug.core.sourcelookup.containers.LocalFileStorage;

/**
 * The PostScript source locator knows how to translate a PostScript stack
 * frame into a source file name. 
 * 
 * Matches plugin.xml
 * extension[@point="org.eclipse.debug.core.sourceLocators"]/sourceLocator/@class
 */
public class PSSourceLocator implements IPersistableSourceLocator {
	@Override
	public Object getSourceElement(IStackFrame stackFrame) {
		if (!(stackFrame instanceof PSStackFrame))
		   return null;
		String psFile;
		psFile = ((PSStackFrame)stackFrame).getSourceName();
		IFile file = FileBuffers.getWorkspaceFileAtLocation(new Path(psFile));
		if (file != null)
			return file;
		return new LocalFileStorage(new File(psFile));
	}

	@Override
	public String getMemento() throws CoreException {
		return null;
	}

	@Override
	public void initializeDefaults(ILaunchConfiguration configuration)
			throws CoreException {
	}

	@Override
	public void initializeFromMemento(String memento) throws CoreException {
	}
}

