package de.tfritsch.psdt.debug.model

import java.io.File
import org.eclipse.core.resources.IWorkspaceRunnable
import org.eclipse.core.runtime.CoreException
import org.eclipse.core.runtime.IProgressMonitor
import org.eclipse.debug.core.DebugEvent
import org.eclipse.debug.core.DebugPlugin
import org.eclipse.debug.core.model.ITerminate

/**
 * Handles a delayed file deletion. 
 */
class DeleteFileOperation implements IWorkspaceRunnable {

	File file
	ITerminate terminate

    /**
     * Constructs a delayed file deletion.
     * 
     * @param file the file to be deleted
     * @param terminate the element whose termination will trigger the deletion
     */
	new(File file, ITerminate terminate) {
		this.file = file
		this.terminate = terminate
	}

	override run(IProgressMonitor monitor) throws CoreException {
		DebugPlugin.^default.addDebugEventListener [ events |
			for (event : events) {
				if (event.source === terminate && event.kind === DebugEvent.TERMINATE) {
					file.delete
					DebugPlugin.^default.removeDebugEventListener(self)
				}
			}
		]
	}
}
