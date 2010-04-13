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

import org.talend.core.language.ECodeLanguage;
import org.talend.core.model.routines.IRoutineProviderCreator;
import org.talend.core.model.routines.IRoutinesProvider;

/**
 * class global comment. Detailled comment
 */
public class SdiRoutinesProviderCreator implements IRoutineProviderCreator {

    IRoutinesProvider perlProvider = null;

    IRoutinesProvider javaProvider = null;

    public SdiRoutinesProviderCreator() {
        perlProvider = new SdiPerlRoutinesProvider();
        javaProvider = new SdiJavaRoutinesProvider();
    }

    /*
     * (non-Javadoc)
     * 
     * @see
     * org.talend.core.model.routines.IRoutineProviderCreator#createIRoutinesProviderByLanguage(org.talend.core.language
     * .ECodeLanguage)
     */
    public IRoutinesProvider createIRoutinesProviderByLanguage(ECodeLanguage lan) {
        if (lan == ECodeLanguage.PERL) {
            return perlProvider;
        } else {
            return javaProvider;
        }

    }

}
