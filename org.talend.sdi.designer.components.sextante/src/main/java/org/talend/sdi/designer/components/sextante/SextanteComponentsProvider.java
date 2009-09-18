// ============================================================================
//
// Copyright (C) 2008 Camptocamp. - www.camptocamp.com
//
// This source code is available under agreement available at
// %InstallDIR%\features\org.talend.rcp.branding.%PRODUCTNAME%\%PRODUCTNAME%license.txt
//
// You should have received a copy of the agreement
// along with this program; if not, write to Talend SA
// 9 rue Pages 92150 Suresnes, France
//
// ============================================================================
package org.talend.sdi.designer.components.sextante;

import java.io.File;

import org.talend.commons.exception.ExceptionHandler;
import org.talend.core.model.components.AbstractComponentsProvider;

import org.eclipse.core.runtime.FileLocator;
import org.eclipse.core.runtime.Path;

import java.net.URL;

/**
 * Components provider for sdi sextante components.
 * 
 * @author fxprunayre
 */
public class SextanteComponentsProvider extends AbstractComponentsProvider {

	/**
	 * SextanteComponentsProvider constructor.
	 */
	public SextanteComponentsProvider() {
	}

	@Override
	protected File getExternalComponentsLocation() {
		URL url = FileLocator.find(SextantePlugin.getDefault().getBundle(),
				new Path("components"), null);
		URL fileUrl;
		try {
			fileUrl = FileLocator.toFileURL(url);
			return new File(fileUrl.getPath());
		} catch (Exception e) {
			ExceptionHandler.process(e);
		}
		return null;
	}

}
