/*******************************************************************************
 * Copyright (C) 2016  Thomas Fritsch.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
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

	@Check
	def checkCurrentfile(PSExecutableName it) {
		if (name == "currentfile") {
			warning(
				"Reading data via 'currentfile' may give parsing problems" +
					" if not properly used with %%BeginData: and %%EndData",
				PostscriptPackage.Literals.PS_EXECUTABLE_NAME__NAME,
				IssueCodes.CURRENTFILE
			)
		}
	}
}
