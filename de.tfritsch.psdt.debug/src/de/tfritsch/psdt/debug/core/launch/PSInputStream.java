package de.tfritsch.psdt.debug.core.launch;

import java.io.IOException;
import java.io.InputStream;
import java.io.PushbackInputStream;

/**
 * 
 */
class PSInputStream extends PushbackInputStream {
	private int fLineNumber = 1;
	private int fCurrentPos;
	private int fStartPos;

	/**
	 * Constructs from an InputStream.
	 * 
	 * @param input
	 *            the input stream from which to read. For optimal performance
	 *            callers should pass in a suitably buffered stream.
	 */
	PSInputStream(InputStream input) {
		super(input);
	}

	PSToken readToken() throws IOException {
		String s = readTokenString();
		if (s == null)
			return null;
		return new PSToken(s, fLineNumber, fStartPos, fStartPos + s.length());
	}

	private String readTokenString() throws IOException {
		for (;;) {
			fStartPos = fCurrentPos;
			int c = read();
			switch (c) {
			case ' ':
			case '\0':
			case '\f':
			case '\n':
			case '\r':
			case '\t':
				break;
			case '%':
				skipComment();
				break;
			case -1: // EOF
				return null;
			case '[':
				return "["; //$NON-NLS-1$
			case ']':
				return "]"; //$NON-NLS-1$
			case '(':
				return readString();
			case ')':
				return ")";  //$NON-NLS-1$ // will be syntax error
			case '<':
				c = read();
				switch (c) {
				case '<':
					return "<<"; //$NON-NLS-1$
				default:
					unread(c);
					return readASCIIString();
				}
			case '>':
				c = read();
				switch (c) {
				case '>':
					return ">>"; //$NON-NLS-1$
				default:
					unread(c);
					return ">";  //$NON-NLS-1$ // will be syntax error
				}
			case '{':
				return "{"; //$NON-NLS-1$
			case '}':
				return "}"; //$NON-NLS-1$
			case '/':
				c = read();
				switch (c) {
				case '/':
					return "/" + readName(false); //$NON-NLS-1$
				default:
					unread(c);
					/* fall through */
				case -1: // EOF
					return readName(false);
				}
			default:
				unread(c);
				return readName(true);
			}
		}
	}

	@Override
	public int read() throws IOException {
		int c = super.read();
		if (c == '\n') {
			fLineNumber++;
		}
		if (c != -1)
			fCurrentPos++;
		return c;
	}
	
	@Override
	public void unread(int c) throws IOException {
		fCurrentPos--;
		if (c == '\n') {
			fLineNumber--;
		}
		super.unread(c);
	}
	
	/**
	 * Reads a name. The beginning '/' or '//' was already consumed.
	 */
	private String readName(boolean executable) throws IOException {
		StringBuffer buffer = new StringBuffer();
		for (;;) {
			int c = read();
			switch (c) {
			case '%':
			case '/':
			case '[':
			case ']':
			case '(':
			case ')':
			case '<':
			case '>':
			case '{':
			case '}':
				unread(c);
				if (executable)
					return buffer.toString();
				else
					return "/" + buffer.toString(); //$NON-NLS-1$
			case ' ':
			case '\0':
			case '\f':
			case '\n':
			case '\r':
			case '\t':
			case -1: // EOF
				if (executable)
					return buffer.toString();
				else
					return "/" + buffer.toString(); //$NON-NLS-1$
			default:
				buffer.append((char) c);
			}
		}
	}

	/**
	 * Reads a (....) string. The leading '(' has already been read.
	 */
	private String readString() throws IOException {
		StringBuffer buffer = new StringBuffer();
		buffer.append('(');
		for (int c = read(); c != -1; c = read()) {
			buffer.append((char) c);
			if (c == ')')
				break;
		}
		return buffer.toString();
	}

	/**
	 * Reads a <....> string. The leading '<' has already been read.
	 */
	private String readASCIIString() throws IOException {
		StringBuffer buffer = new StringBuffer();
		buffer.append('<');
		for (int c = read(); c != -1; c = read()) {
			buffer.append((char) c);
			if (c == '>')
				break;
		}
		return buffer.toString();
	}

	/**
	 * Skips a comment until and including the ending '\f', '\n' or '\r'. The
	 * beginning '%' was already consumed.
	 */
	private void skipComment() throws IOException {
		for (;;) {
			int c = read();
			switch (c) {
			case '\f':
			case '\n':
			case '\r':
			case -1: // EOF
				return;
			default:
				; /* do nothing */
			}
		}
	}
}