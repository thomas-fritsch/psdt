/*******************************************************************************
 * Copyright (c) 2016 Thomas Fritsch.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 ******************************************************************************/
package de.tfritsch.psdt.validation

import de.tfritsch.psdt.postscript.PSExecutableName
import de.tfritsch.psdt.postscript.PostscriptPackage
import org.eclipse.xtext.validation.Check

/**
 * Custom validation rules. 
 *
 * see http://www.eclipse.org/Xtext/documentation.html#validation
 *
 * @author Thomas Fritsch - initial API and implementation
 */
class PostscriptValidator extends AbstractPostscriptValidator {

	val DPS_OPERATOR_NAMES = #["condition", "currentcontext", "currenthalftonephase", "defineusername", "detach",
		"deviceinfo", "fork", "initviewclip", "join", "lock", "monitor", "notify", "sethalftonephase", "viewclip",
		"viewclippath", "wait", "wtranslation", "yield"]

	@Check
	def checkDPS(PSExecutableName it) {
		if (DPS_OPERATOR_NAMES.contains(name)) {
			warning(
				"Operator '" + name + "' is supported only in Display PostScript",
				PostscriptPackage.Literals.PS_EXECUTABLE_NAME__NAME,
				IssueCodes.DPS
			)
		}
	}
}
