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

import org.eclipse.jface.dialogs.IDialogPage;
import org.eclipse.jface.wizard.WizardPage;
import org.eclipse.swt.widgets.Composite;
import org.talend.core.model.metadata.IMetadataContextModeManager;
import org.talend.core.model.metadata.builder.connection.MetadataTable;
import org.talend.core.model.properties.ConnectionItem;
import org.talend.cwm.helper.ConnectionHelper;
import org.talend.cwm.helper.TableHelper;
import org.talend.metadata.managment.ui.wizard.AbstractForm;

/**
 * Use to create a new connection to a File. Page allows setting a file.
 */
public class SpatialVectorWizardPage extends WizardPage {

	private ConnectionItem connectionItem;

	private int step;

	private AbstractSpatialVectorFileStepForm currentComposite;

	private final String[] existingNames;

	private boolean isRepositoryObjectEditable;

	private IMetadataContextModeManager contextModeManager;

	/**
	 * DOC ocarbone DelimitedFileWizardPage constructor comment.
	 * 
	 * @param step
	 * @param connection
	 * @param isRepositoryObjectEditable
	 * @param existingNames
	 */
	public SpatialVectorWizardPage(int step, ConnectionItem connectionItem,
			boolean isRepositoryObjectEditable, String[] existingNames,
			IMetadataContextModeManager contextModeManager) {
		super("wizardPage"); //$NON-NLS-1$
		this.step = step;
		this.connectionItem = connectionItem;
		this.existingNames = existingNames;
		this.isRepositoryObjectEditable = isRepositoryObjectEditable;
		this.contextModeManager = contextModeManager;
	}

	/**
	 * 
	 * @see IDialogPage#createControl(Composite)
	 */
	public void createControl(final Composite parent) {
		currentComposite = null;

		if (step == 1) {
			currentComposite = new SpatialVectorStep1Form(parent,
					connectionItem, existingNames, contextModeManager);
		} else if (step == 2) {
			MetadataTable metadataTable = ConnectionHelper.getTables(connectionItem
							.getConnection()).toArray(new MetadataTable[0])[0];
			currentComposite = new SpatialVectorStep2Form(
					parent,
					connectionItem,
					metadataTable,
					TableHelper.getTableNames(connectionItem
									.getConnection(), metadataTable.getLabel()),
					contextModeManager);
		}
//		currentComposite.setReadOnly(!isRepositoryObjectEditable);

		AbstractForm.ICheckListener listener = new AbstractForm.ICheckListener() {

			public void checkPerformed(final AbstractForm source) {

				if (source.isStatusOnError()) {
					SpatialVectorWizardPage.this.setPageComplete(false);
					setErrorMessage(source.getStatus());
				} else {
					SpatialVectorWizardPage.this
							.setPageComplete(isRepositoryObjectEditable);
					setErrorMessage(null);
					setMessage(source.getStatus());
				}
			}
		};
//		currentComposite.setListener(listener);
//		setControl((Composite) currentComposite);
	}
}
