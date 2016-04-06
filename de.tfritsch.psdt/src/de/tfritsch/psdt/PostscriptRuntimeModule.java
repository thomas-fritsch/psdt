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
package de.tfritsch.psdt;

import org.eclipse.xtext.conversion.IValueConverterService;
import org.eclipse.xtext.documentation.IEObjectDocumentationProvider;

import de.tfritsch.psdt.conversion.PostscriptTerminalConverters;
import de.tfritsch.psdt.documentation.PostscriptDocumentationProvider;
import de.tfritsch.psdt.postscript.PostscriptFactory;

/**
 * Use this class to register components to be used at runtime / without the
 * Equinox extension registry.
 * 
 * @author Thomas Fritsch - initial API and implementation
 */
public class PostscriptRuntimeModule extends AbstractPostscriptRuntimeModule {

    @Override
    public Class<? extends IValueConverterService> bindIValueConverterService() {
        return PostscriptTerminalConverters.class;
    }

    public Class<? extends IEObjectDocumentationProvider> bindIEObjectDocumentationProviderr() {
        return PostscriptDocumentationProvider.class;
    }

    public PostscriptFactory bindPostscriptFactory() {
        return PostscriptFactory.eINSTANCE;
    }
}
