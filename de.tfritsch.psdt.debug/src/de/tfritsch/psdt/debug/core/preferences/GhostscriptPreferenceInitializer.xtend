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
		val file = switch (Platform.OS) {
			case Platform.OS_WIN32:
				findGhostscriptExeOnWindows
			default:
				findGhostscriptExeByPath
		}
		if (file !== null)
			store.setDefault(IPSConstants.PREF_INTERPRETER, file.absolutePath)
		store.setDefault(IPSConstants.PREF_DEFAULT_GS_ARGUMENTS, "-dBATCH")
	}

	def private File findGhostscriptExeByPath() {
		System.getenv("PATH").split(File.pathSeparator) //
		.map[new File(it, "gs")] //
		.filter[exists] //
		.head
	}

	def private File findGhostscriptExeOnWindows() {
		#["ProgramFiles", "ProgramFiles(x86)", "ProgramW6432"] //
		.map[new File(System.getenv(it), "gs")] //
		.filter[exists] //
		.fold(newArrayList) [ files, gsDir |
			gsDir.listFiles.forEach [
				val exes = new File(it, "bin") //
				.listFiles[name == "gswin64c.exe" || name == "gswin32c.exe"]
				files.addAll(exes)
			]
			files
		].head
	}
}
