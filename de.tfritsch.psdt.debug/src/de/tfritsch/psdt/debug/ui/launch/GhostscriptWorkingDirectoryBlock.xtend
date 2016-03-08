/*******************************************************************************
 * Copyright (c) 2016 Thomas Fritsch.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 ******************************************************************************/
package de.tfritsch.psdt.debug.ui.launch

import org.eclipse.core.runtime.CoreException
import org.eclipse.debug.core.DebugPlugin
import org.eclipse.debug.core.ILaunchConfiguration
import org.eclipse.debug.ui.WorkingDirectoryBlock

/**
 * @author Thomas Fritsch - initial API and implementation
 */
class GhostscriptWorkingDirectoryBlock extends WorkingDirectoryBlock {

	new() {
		super(DebugPlugin.ATTR_WORKING_DIRECTORY)
	}

	override protected getProject(ILaunchConfiguration configuration) throws CoreException {
		return null
	}

}
