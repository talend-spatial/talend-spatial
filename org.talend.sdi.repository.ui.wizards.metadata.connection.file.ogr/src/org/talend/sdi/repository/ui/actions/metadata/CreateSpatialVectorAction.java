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
package org.talend.sdi.repository.ui.actions.metadata;

import org.eclipse.jface.resource.ImageDescriptor;
import org.eclipse.jface.wizard.WizardDialog;
import org.eclipse.swt.widgets.Display;
import org.eclipse.ui.PlatformUI;
import org.talend.commons.ui.runtime.image.ECoreImage;
import org.talend.commons.ui.runtime.image.ImageProvider;
import org.talend.core.model.properties.PositionalFileConnectionItem;
import org.talend.core.model.repository.ERepositoryObjectType;
import org.talend.core.model.repository.RepositoryManager;
import org.talend.core.repository.model.ProxyRepositoryFactory;
import org.talend.core.repository.ui.actions.metadata.AbstractCreateAction;
import org.talend.core.ui.images.OverlayImageProvider;
import org.talend.repository.ProjectManager;
import org.talend.repository.model.IProxyRepositoryFactory;
import org.talend.repository.model.IRepositoryNode.EProperties;
import org.talend.repository.model.RepositoryNode;
import org.talend.sdi.repository.ui.wizards.metadata.connection.file.ogr.SpatialVectorWizard;

/**
 */
public class CreateSpatialVectorAction extends AbstractCreateAction {

	private static final String EDIT_LABEL = Messages
			.getString("CreateSpatialVectorAction.action.editTitle"); //$NON-NLS-1$

	private static final String OPEN_LABEL = Messages
			.getString("CreateSpatialVectorAction.action.openTitle"); //$NON-NLS-1$

	private static final String CREATE_LABEL = Messages
			.getString("CreateSpatialVectorAction.action.createTitle"); //$NON-NLS-1$

	protected static final int WIZARD_WIDTH = 920;

	protected static final int WIZARD_HEIGHT = 540;

	private boolean creation = false;

	ImageDescriptor defaultImage = ImageProvider
			.getImageDesc(ECoreImage.METADATA_FILE_POSITIONAL_ICON);

	ImageDescriptor createImage = OverlayImageProvider
			.getImageWithNew(ImageProvider
					.getImage(ECoreImage.METADATA_FILE_POSITIONAL_ICON));

	/**
	 * DOC cantoine CreateOGRAction constructor comment.
	 * 
	 * @param viewer
	 */
	public CreateSpatialVectorAction() {
		super();

		this.setText(CREATE_LABEL);
		this.setToolTipText(CREATE_LABEL);
		this.setImageDescriptor(defaultImage);
	}

	public CreateSpatialVectorAction(boolean isToolbar) {
		super();
		setToolbar(isToolbar);
		this.setText(CREATE_LABEL);
		this.setToolTipText(CREATE_LABEL);
		this.setImageDescriptor(defaultImage);
	}

	@Override
	protected void doRun() {
		if (repositoryNode == null) {
			repositoryNode = getCurrentRepositoryNode();
		}

		if (isToolbar()) {
			if (repositoryNode != null
					&& repositoryNode.getContentType() != ERepositoryObjectType.METADATA_SPATIAL_FILE_VECTOR) {
				repositoryNode = null;
			}
			if (repositoryNode == null) {
				repositoryNode = getRepositoryNodeForDefault(ERepositoryObjectType.METADATA_SPATIAL_FILE_VECTOR);
			}
		}

		WizardDialog wizardDialog;
		if (isToolbar()) {
			init(repositoryNode);
			SpatialVectorWizard ogrWizard = new SpatialVectorWizard(
					PlatformUI.getWorkbench(), creation, repositoryNode,
					getExistingNames());
			ogrWizard.setToolbar(true);
			wizardDialog = new WizardDialog(Display.getCurrent()
					.getActiveShell(), ogrWizard);
		} else {
			wizardDialog = new WizardDialog(Display.getCurrent()
					.getActiveShell(), new SpatialVectorWizard(
					PlatformUI.getWorkbench(), creation, repositoryNode,
					getExistingNames()));
		}

		if (!creation) {
			RepositoryManager.refreshSavedNode(repositoryNode);
		}
		wizardDialog.setPageSize(WIZARD_WIDTH, WIZARD_HEIGHT);
		wizardDialog.create();
		wizardDialog.open();
	}

	@Override
	public Class getClassForDoubleClick() {
		return PositionalFileConnectionItem.class;
	}

	@Override
	protected void init(RepositoryNode node) {
		ERepositoryObjectType nodeType = (ERepositoryObjectType) node
				.getProperties(EProperties.CONTENT_TYPE);
		if (!ERepositoryObjectType.METADATA_SPATIAL_FILE_VECTOR
				.equals(nodeType)) {
			return;
		}

		IProxyRepositoryFactory factory = ProxyRepositoryFactory.getInstance();
		switch (node.getType()) {
		case SIMPLE_FOLDER:
			if (node.getObject() != null
					&& node.getObject().getProperty().getItem().getState()
							.isDeleted()) {
				setEnabled(false);
				return;
			}
		case SYSTEM_FOLDER:
			if (factory.isUserReadOnlyOnCurrentProject()
					|| !ProjectManager.getInstance().isInCurrentMainProject(
							node)) {
				setEnabled(false);
				return;
			}
			this.setText(CREATE_LABEL);
			collectChildNames(node);
			this.setImageDescriptor(createImage);
			creation = true;
			break;
		case REPOSITORY_ELEMENT:
			if (factory.isPotentiallyEditable(node.getObject())) {
				this.setText(EDIT_LABEL);
				this.setImageDescriptor(defaultImage);
				collectSiblingNames(node);
			} else {
				this.setText(OPEN_LABEL);
				this.setImageDescriptor(defaultImage);
			}
			collectSiblingNames(node);
			creation = false;
			break;
		}
		setEnabled(true);
	}
}
