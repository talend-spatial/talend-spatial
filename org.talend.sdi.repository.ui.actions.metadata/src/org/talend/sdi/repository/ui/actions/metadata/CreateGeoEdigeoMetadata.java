package org.talend.sdi.repository.ui.actions.metadata;

import org.eclipse.jface.viewers.ISelection;
import org.eclipse.jface.viewers.IStructuredSelection;
import org.eclipse.jface.wizard.WizardDialog;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.ui.PlatformUI;
import org.talend.commons.ui.image.ImageProvider;
import org.talend.core.model.repository.ERepositoryObjectType;
import org.talend.core.ui.images.ECoreImage;
import org.talend.core.ui.images.OverlayImageProvider;
import org.talend.repository.model.RepositoryNode;
import org.talend.repository.model.RepositoryNode.EProperties;

public class CreateGeoEdigeoMetadata extends
		org.talend.repository.ui.actions.metadata.CreateGenericSchemaAction {

	private static final String LABEL = org.talend.sdi.repository.ui.actions.metadata.Messages
			.getString("CreateGeoEdigeoMetadata.title"); //$NON-NLS-1$

	public CreateGeoEdigeoMetadata() {
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
		openEdigeoWizard();
	}

	private void openEdigeoWizard() {
		ISelection selection = getSelection();
		ImportGeoEdigeoSchemaWizard wizard = new ImportGeoEdigeoSchemaWizard(
				PlatformUI.getWorkbench(), selection, getExistingNames());
		if (!wizard.isInitOK()) {
			wizard.dispose();
			return;
		}
		WizardDialog wizardDialog = new WizardDialog(new Shell(), wizard);
		wizardDialog.setPageSize(WIZARD_WIDTH, WIZARD_HEIGHT);
		wizardDialog.create();
		wizardDialog.open();
		refresh(((IStructuredSelection) selection).getFirstElement());
	}

}
