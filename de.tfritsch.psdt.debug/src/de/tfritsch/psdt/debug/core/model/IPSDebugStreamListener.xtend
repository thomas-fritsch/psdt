/*******************************************************************************
 * Copyright (c) 2016 Thomas Fritsch.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 ******************************************************************************/
package de.tfritsch.psdt.debug.core.model

import java.util.List

/**
 * @author Thomas Fritsch - initial API and implementation
 */
interface IPSDebugStreamListener {

	/**
	 * A @@break has been received from Ghostscript.
	 */
	def void breakReceived(int level, int ref, String value)

	/**
	 * A @@break has been received from Ghostscript.
	 */
	def void breakReceived(int depth)

	/**
	 * A @@resume has been received from Ghostscript.
	 */
	def void resumeReceived()

	/**
	 * A @@status has been received from Ghostscript.
	 */
	def void statusReceived(List<String> lines)

}
