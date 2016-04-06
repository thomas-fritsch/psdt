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
