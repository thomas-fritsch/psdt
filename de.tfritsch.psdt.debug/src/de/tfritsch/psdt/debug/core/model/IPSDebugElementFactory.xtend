package de.tfritsch.psdt.debug.core.model

interface IPSDebugElementFactory {

	def PSVariable createVariable(String name, PSValue value)

	def PSIndexedValue createIndexedValue(String valueString)

	def PSValue createValue(String valueString)

}
