/*******************************************************************************
 * Copyright (C) 2016  Thomas Fritsch.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 ******************************************************************************/
package de.tfritsch.psdt.debug

import com.google.inject.AbstractModule
import de.tfritsch.psdt.debug.ui.breakpoints.PSRunToLineTarget
import de.tfritsch.psdt.debug.ui.breakpoints.PSToggleBreakpointsTarget
import org.eclipse.core.variables.IStringVariableManager
import org.eclipse.core.variables.VariablesPlugin
import org.eclipse.debug.core.DebugPlugin
import org.eclipse.debug.core.IBreakpointManager
import org.eclipse.debug.core.IExpressionManager
import org.eclipse.debug.core.ILaunchManager
import org.eclipse.debug.ui.actions.IRunToLineTarget
import org.eclipse.debug.ui.actions.IToggleBreakpointsTarget
import org.eclipse.jface.preference.IPreferenceStore
import org.eclipse.ui.plugin.AbstractUIPlugin

/**
 * @author Thomas Fritsch - initial API and implementation
 */
class PSModule extends AbstractModule {

	AbstractUIPlugin plugin

	new(AbstractUIPlugin plugin) {
		this.plugin = plugin
	}

	override protected configure() {
		bind(DebugPlugin).toInstance(DebugPlugin.^default)
		bind(IBreakpointManager).toInstance(DebugPlugin.^default.breakpointManager)
		bind(IExpressionManager).toInstance(DebugPlugin.^default.expressionManager)
		bind(ILaunchManager).toInstance(DebugPlugin.^default.launchManager)
		bind(IStringVariableManager).toInstance(VariablesPlugin.^default.stringVariableManager)
		bind(IPreferenceStore).annotatedWith(Debug).toInstance(plugin.preferenceStore)
		bind(IToggleBreakpointsTarget).to(PSToggleBreakpointsTarget)
		bind(IRunToLineTarget).to(PSRunToLineTarget)
	}
}
