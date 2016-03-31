package de.tfritsch.psdt.debug.core.preferences

import de.tfritsch.psdt.debug.IPSConstants
import de.tfritsch.psdt.debug.PSPlugin
import java.io.File
import org.eclipse.core.runtime.Platform
import org.eclipse.core.runtime.preferences.AbstractPreferenceInitializer

/**
 * @author Thomas Fritsch - initial API and implementation
 */
class GhostscriptPreferenceInitializer extends AbstractPreferenceInitializer {

	override initializeDefaultPreferences() {
		val store = PSPlugin.^default.preferenceStore
		val file = switch (Platform.getOS) {
			case Platform.OS_WIN32: {
				findGhostscriptExeOnWindows
			}
			default: {
				findGhostscriptExeByPath
			}
		}
		if (file !== null)
			store.setDefault(IPSConstants.PREF_INTERPRETER, file.absolutePath)
	}

	def private File findGhostscriptExeByPath() {
		for (dir : System.getenv("PATH").split(File.pathSeparator)) {
			val file = new File(dir, "gs")
			if (file.exists)
				return file
		}
		return null
	}

	def private File findGhostscriptExeOnWindows() {
		for (gsDir : #[
			new File(System.getenv("ProgramFiles"), "gs"),
			new File(System.getenv("ProgramFiles(x86)"), "gs")
		]) {
			if (gsDir.exists) {
				for (subDir : gsDir.list) {
					var file = new File(gsDir, subDir + "/bin/gswin64c.exe".replace("/", File.separator))
					if (file.exists)
						return file
					file = new File(gsDir, subDir + "/bin/gswin32c.exe".replace("/", File.separator))
					if (file.exists)
						return file
				}
			}
		}
		return null
	}
}
