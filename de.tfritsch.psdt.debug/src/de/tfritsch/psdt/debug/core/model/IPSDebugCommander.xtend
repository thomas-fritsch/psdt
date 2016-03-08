/*******************************************************************************
 * Copyright (c) 2016 Thomas Fritsch.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 ******************************************************************************/
package de.tfritsch.psdt.debug.core.model

import org.eclipse.debug.core.DebugException

/**
 * @author Thomas Fritsch - initial API and implementation
 */
interface IPSDebugCommander {

	def void setDebugStreamListener(IPSDebugStreamListener listener)

	def void setSingleStep(boolean singleStep) throws DebugException

	def void resume() throws DebugException

	def void addBreakpoint(int ref) throws DebugException

	def void removeBreakpoint(int ref) throws DebugException

	def void hideDicts(boolean hideSystemDict, boolean hideGlobalDict, boolean hideUserDict) throws DebugException

	def void requestStatus() throws DebugException

	def void sendCommand(String string) throws DebugException
}
