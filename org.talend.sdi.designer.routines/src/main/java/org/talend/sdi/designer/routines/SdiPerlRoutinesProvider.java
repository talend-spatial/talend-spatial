// ============================================================================
//
// Copyright (C) 2010      Neogeo Technologies - www.neogeo-online.net
//				 2006-2010 Talend Inc. - www.talend.com
//
// This source code is available under agreement available at
// %InstallDIR%\features\org.talend.rcp.branding.%PRODUCTNAME%\%PRODUCTNAME%license.txt
//
// You should have received a copy of the agreement
// along with this program; if not, write to Talend SA
// 9 rue Pages 92150 Suresnes, France
//
// ============================================================================
package org.talend.sdi.designer.routines;

import java.io.IOException;
import java.net.URL;
import java.util.List;

import org.eclipse.core.runtime.FileLocator;
import org.talend.commons.utils.io.FilesUtils;
import org.talend.core.model.routines.IRoutinesProvider;

/**
 * No spatial routines available in PERL Language.
 */
public class SdiPerlRoutinesProvider implements IRoutinesProvider {

    /**
     * SdiJavaRoutinesProvider constructor comment.
     */
    public SdiPerlRoutinesProvider() {
    }

    public List<URL> getSystemRoutines() {
        List<URL> toReturn = FilesUtils.getFilesFromFolder(Activator.getDefault().getBundle(), "resources/perl/routines/system/",
                ".pm", false, false);

        return toReturn;
    }

    /*
     * (non-Javadoc)
     * 
     * @see org.talend.core.model.routines.IRoutinesProvider#getTalendRoutinesFolder()
     */
    public URL getTalendRoutinesFolder() throws IOException {
        URL url = Activator.getDefault().getBundle().getEntry("resources/perl/talend"); //$NON-NLS-1$
        return FileLocator.resolve(url);
    }

    public List<URL> getTalendRoutines() {
        return FilesUtils.getFilesFromFolder(Activator.getDefault().getBundle(), "resources/perl/talend", "");
    }
}
