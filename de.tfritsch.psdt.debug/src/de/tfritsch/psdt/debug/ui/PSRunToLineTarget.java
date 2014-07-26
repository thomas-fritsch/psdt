package de.tfritsch.psdt.debug.ui;

import org.eclipse.core.runtime.CoreException;
import org.eclipse.debug.core.model.ISuspendResume;
import org.eclipse.debug.ui.actions.IRunToLineTarget;
import org.eclipse.jface.viewers.ISelection;
import org.eclipse.ui.IWorkbenchPart;

public class PSRunToLineTarget implements IRunToLineTarget {

	public void runToLine(IWorkbenchPart part, ISelection selection,
			ISuspendResume target) throws CoreException {
		// TODO Auto-generated method stub
	}

	public boolean canRunToLine(IWorkbenchPart part, ISelection selection,
			ISuspendResume target) {
		// TODO Auto-generated method stub
		return false;
	}

}
