/*******************************************************************************
 * Copyright (c) 2016 Thomas Fritsch.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 ******************************************************************************/
package de.tfritsch.psdt.debug.core.launch

import org.eclipse.xtend.lib.annotations.Data

/**
 * @author Thomas Fritsch - initial API and implementation
 */
@Data
class PSToken {

	String string

	/**
	 * The line number of this token in the associated source file.
	 */
	int lineNumber

	/**
	 * The index of the first character in the associated source file.
	 */
	int charStart

	/**
	 * The index of the last character in the associated source file.
	 */
	int charEnd
}
