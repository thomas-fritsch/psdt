package de.tfritsch.psdt.debug.core.model

import java.util.List

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
