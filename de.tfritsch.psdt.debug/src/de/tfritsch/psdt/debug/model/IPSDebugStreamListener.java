package de.tfritsch.psdt.debug.model;

import java.util.List;

interface IPSDebugStreamListener {

	/**
	 * A @@break has been received from Ghostscript.
	 */
	public void breakReceived(int level, int ref, String value);

	/**
	 * A @@break has been received from Ghostscript.
	 */
	public void breakReceived(int depth);

	/**
	 * A @@resume has been received from Ghostscript.
	 */
	public void resumeReceived();

	/**
	 * A @@status has been received from Ghostscript.
	 */
	public void statusReceived(List<String> lines);

}
