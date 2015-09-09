// ============================================================================
//
// Copyright (C) 2006-2013 Talend Inc. - www.talend.com
//
// This source code is available under agreement available at
// %InstallDIR%\features\org.talend.rcp.branding.%PRODUCTNAME%\%PRODUCTNAME%license.txt
//
// You should have received a copy of the agreement
// along with this program; if not, write to Talend SA
// 9 rue Pages 92150 Suresnes, France
//
// ============================================================================
package org.talend.sdi.repository.ui.wizards.metadata.connection.file.ogr;

import org.eclipse.jface.wizard.WizardPage;
import org.eclipse.swt.widgets.Composite;
import org.talend.core.model.metadata.builder.connection.MetadataTable;
import org.talend.core.model.metadata.builder.connection.SpatialVectorFileConnection;
import org.talend.core.model.properties.ConnectionItem;
import org.talend.repository.ui.swt.utils.AbstractFileStepForm;

/**
 * 
 */
public abstract class AbstractSpatialVectorFileStepForm extends
		AbstractFileStepForm {

	private WizardPage page = null;

	/**
	 */
	public AbstractSpatialVectorFileStepForm(Composite parent,
			ConnectionItem connectionItem, String[] existingNames) {
		super(parent, connectionItem, existingNames);
	}

	/**
	 *
	 * @param parent
	 * @param connection2
	 */
	public AbstractSpatialVectorFileStepForm(Composite parent,
			ConnectionItem connectionItem) {
		this(parent, connectionItem, null);
	}

	/**
	 */
	public AbstractSpatialVectorFileStepForm(Composite parent,
			ConnectionItem connectionItem, MetadataTable metadataTable,
			String[] existingNames) {
		super(parent, connectionItem, existingNames);
	}

	protected SpatialVectorFileConnection getConnection() {
		return (SpatialVectorFileConnection) super.getConnection();
	}

	/**
	 * Getter for page.
	 * 
	 * @return the page
	 */
	public WizardPage getWizardPage() {
		return this.page;
	}

	/**
	 * Sets the page.
	 * 
	 * @param page
	 *            the page to set
	 */
	public void setWizardPage(WizardPage page) {
		this.page = page;
	}
}
