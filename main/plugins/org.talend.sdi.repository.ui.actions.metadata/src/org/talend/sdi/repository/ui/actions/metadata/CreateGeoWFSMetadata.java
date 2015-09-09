package org.talend.sdi.repository.ui.actions.metadata;

import org.eclipse.jface.viewers.ISelection;
import org.eclipse.jface.wizard.WizardDialog;
import org.eclipse.swt.widgets.Display;
import org.eclipse.ui.PlatformUI;
import org.talend.commons.ui.runtime.image.ECoreImage;
import org.talend.commons.ui.runtime.image.ImageProvider;
import org.talend.commons.ui.runtime.image.OverlayImageProvider;
import org.talend.core.model.repository.ERepositoryObjectType;
import org.talend.core.model.repository.RepositoryManager;
import org.talend.core.repository.model.ProxyRepositoryFactory;
import org.talend.repository.ProjectManager;
import org.talend.repository.model.IProxyRepositoryFactory;
import org.talend.repository.model.IRepositoryNode.EProperties;
import org.talend.repository.model.RepositoryNode;

public class CreateGeoWFSMetadata extends
	org.talend.repository.metadata.ui.actions.metadata.CreateGenericSchemaAction {

	private static final String LABEL = org.talend.sdi.repository.ui.actions.metadata.Messages
			.getString("CreateGeoWFSMetadata.title"); //$NON-NLS-1$

	public CreateGeoWFSMetadata() {
		// TODO Auto-generated constructor stub
		this.setText(LABEL);
		this.setToolTipText(LABEL);
		this.setImageDescriptor(OverlayImageProvider
				.getImageWithNew(ImageProvider
						.getImage(ECoreImage.METADATA_GENERIC_ICON)));

	}

	public Class getClassForDoubleClick() {
		return null;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * org.talend.repository.ui.actions.metadata.CreateGenericSchemaAction#init
	 * (org.talend.repository.model.RepositoryNode)
	 */
	@Override
	protected void init(RepositoryNode node) {
		IProxyRepositoryFactory factory = ProxyRepositoryFactory.getInstance();
        if (factory.isUserReadOnlyOnCurrentProject() || !ProjectManager.getInstance().isInCurrentMainProject(node)) {
            setEnabled(false);
            return;
        }
        
		ERepositoryObjectType nodeType = (ERepositoryObjectType) node
				.getProperties(EProperties.CONTENT_TYPE);
		if (nodeType == null) {
			return;
		}
		if (nodeType != ERepositoryObjectType.METADATA_GENERIC_SCHEMA) {
			return;
		}

		switch (node.getType()) {
		case SIMPLE_FOLDER:
		case SYSTEM_FOLDER:
			collectChildNames(node);
			setEnabled(true);
			break;
		default:
			return;
		}

	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.eclipse.jface.action.Action#run()
	 */
	@Override
	protected void doRun() {
		openWfsWizard();
	}

	private void openWfsWizard() {
		ISelection selection = getSelection();
		ImportGeoWFSSchemaWizard wizard = new ImportGeoWFSSchemaWizard(
				PlatformUI.getWorkbench(), selection, getExistingNames());
		if (!wizard.isInitOK()) {
			wizard.dispose();
			return;
		}
		WizardDialog wizardDialog = new WizardDialog(Display.getCurrent().getActiveShell(), wizard);
		wizardDialog.setPageSize(WIZARD_WIDTH, WIZARD_HEIGHT);
		wizardDialog.create();
		wizardDialog.open();
        RepositoryManager.refreshCreatedNode(ERepositoryObjectType.METADATA_GENERIC_SCHEMA);
		//refresh(((IStructuredSelection) selection).getFirstElement());
	}

}
