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
	public void statusReceived(List<StatusLine> lines);
	
	public static class StatusLine {
		private int depth;
		private String name;
		private String value;

		// line has the form "++++ name: value"
		public StatusLine(String line) {
			depth = 0;
			while (line.charAt(depth) == '+')
				depth++;
			int pColon = line.indexOf(':');
			name = line.substring(depth + 1, pColon);
			value = line.substring(pColon + 2);
		}
		
		public int getDepth() {
			return depth;
		}

		public String getName() {
			return name;
		}

		public String getValue() {
			return value;
		}
	}

}
