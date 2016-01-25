package de.tfritsch.psdt.debug.core.launch

import de.tfritsch.psdt.debug.PSPlugin
import java.io.File
import java.io.FileInputStream
import java.io.FileWriter
import java.io.IOException
import org.eclipse.core.runtime.CoreException
import org.eclipse.core.runtime.IProgressMonitor

import static extension de.tfritsch.psdt.debug.PSLaunchExtensions.*

class DebugExtensions {

	def static PSSourceMapping createSourceMapping(String psFile, IProgressMonitor monitor) throws CoreException {
		val sourceMapping = new PSSourceMapping
		try {
			val input = new PSInputStream(new FileInputStream(psFile))
			var token = input.readToken
			while (token != null) {
				if (monitor.canceled) {
					input.close
					return null
				}
				sourceMapping.add(token)
				token = input.readToken
			}
			input.close
		} catch (IOException e) {
			PSPlugin.abort(e.toString, e)
		}
		return sourceMapping
	}

	def static File createInstrumentedFile(PSSourceMapping sourceMapping, IProgressMonitor monitor) throws CoreException {
		try {
			val file = File.createTempFile("psdt", ".ps")
			val writer = new FileWriter(file)
			writer.write("%!PS\n")
			writer.write("@@breakpoints 0 null put\n")
			val store = PSPlugin.^default.preferenceStore
			writer.write(
				!store.showSystemdict + " " + !store.showGlobaldict + " " + !store.showUserdict + " @@stathide\n")
			for (i : 0 ..< sourceMapping.size) {
				if (monitor.canceled) {
					writer.close
					file.delete
					return null
				}
				val string = sourceMapping.getString(i)
				if (string != "}") // no stepping point just before }
					writer.write(i + " @@$ ")
				writer.write(string + "\n")
			}
			writer.close
			return file
		} catch (IOException e) {
			PSPlugin.abort(e.message, e)
			return null
		}
	}

}
