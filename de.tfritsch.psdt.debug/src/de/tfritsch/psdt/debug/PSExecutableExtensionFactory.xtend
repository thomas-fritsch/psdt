package de.tfritsch.psdt.debug

import org.eclipse.xtext.ui.guice.AbstractGuiceAwareExecutableExtensionFactory

class PSExecutableExtensionFactory extends AbstractGuiceAwareExecutableExtensionFactory {

	override protected getBundle() {
		return PSPlugin.^default.bundle
	}

	override protected getInjector() {
		return PSPlugin.injector
	}
}
