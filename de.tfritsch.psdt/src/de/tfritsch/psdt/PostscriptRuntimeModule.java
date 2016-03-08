/*******************************************************************************
 * Copyright (c) 2016 Thomas Fritsch.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
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
