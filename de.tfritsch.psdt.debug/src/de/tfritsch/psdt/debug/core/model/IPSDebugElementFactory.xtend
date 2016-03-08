/*******************************************************************************
 * Copyright (c) 2016 Thomas Fritsch.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * which accompanies this distribution, and is available at
 * http://www.eclipse.org/legal/epl-v10.html
 ******************************************************************************/
package de.tfritsch.psdt.debug.core.model

/**
 * @author Thomas Fritsch - initial API and implementation
 */
interface IPSDebugElementFactory {

	def PSVariable createVariable(String name, PSValue value)

	def PSIndexedValue createIndexedValue(String valueString)

	def PSValue createValue(String valueString)

}
