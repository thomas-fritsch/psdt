package de.tfritsch.psdt.debug.core.preferences

import com.google.inject.Inject
import de.tfritsch.psdt.debug.Debug
import de.tfritsch.psdt.debug.IPSConstants
import java.io.File
import org.eclipse.core.runtime.Platform
import org.eclipse.core.runtime.preferences.AbstractPreferenceInitializer
import org.eclipse.jface.preference.IPreferenceStore

/**
 * @author Thomas Fritsch - initial API and implementation
 */
class GhostscriptPreferenceInitializer extends AbstractPreferenceInitializer {

	@Inject @Debug IPreferenceStore store

	override initializeDefaultPreferences() {
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
		store.setDefault(IPSConstants.PREF_DEFAULT_GS_ARGUMENTS, "-dBATCH")
	}

	def private File findGhostscriptExeByPath() {
		for (dir : System.getenv("PATH").split(File.pathSeparator)) {
			val file = new File(dir, "gs")
			if (file.exists)
				return file
		}
		null
	}

	def private File findGhostscriptExeOnWindows() {
		for (gsDir : #[
			new File(System.getenv("ProgramFiles"), "gs"),
			new File(System.getenv("ProgramFiles(x86)"), "gs"),
			new File(System.getenv("ProgramW6432"), "gs")
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
		null
	}
}
