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
package org.talend.sdi.designer.components;

import java.io.File;
import java.net.URL;

import org.eclipse.core.runtime.FileLocator;
import org.eclipse.core.runtime.Path;
import org.talend.commons.exception.ExceptionHandler;
import org.talend.core.model.components.AbstractComponentsProvider;

/**
 * Components provider for SDI components.
 */
public class ComponentsProvider extends AbstractComponentsProvider {

    /**
     * ComponentsProvider constructor defining components location.
     */
    public ComponentsProvider() {
    }

    
    @Override
	protected File getExternalComponentsLocation() {
        URL url = FileLocator
                .find(Plugin.getDefault().getBundle(), 
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
