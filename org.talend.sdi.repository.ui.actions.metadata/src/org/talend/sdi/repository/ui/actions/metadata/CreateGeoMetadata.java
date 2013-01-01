package org.talend.sdi.repository.ui.actions.metadata;

import java.io.File;

import org.eclipse.jface.viewers.ISelection;
import org.eclipse.jface.wizard.WizardDialog;
import org.eclipse.swt.SWT;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.FileDialog;
import org.eclipse.ui.PlatformUI;
import org.talend.commons.ui.runtime.image.ECoreImage;
import org.talend.commons.ui.runtime.image.ImageProvider;
import org.talend.core.model.repository.ERepositoryObjectType;
import org.talend.core.model.repository.RepositoryManager;
import org.talend.core.repository.model.ProxyRepositoryFactory;
import org.talend.core.ui.images.OverlayImageProvider;
import org.talend.repository.ProjectManager;
import org.talend.repository.model.IProxyRepositoryFactory;
import org.talend.repository.model.IRepositoryNode.EProperties;
import org.talend.repository.model.RepositoryNode;


public class CreateGeoMetadata extends org.talend.repository.ui.actions.metadata.CreateGenericSchemaAction {

    private File file;

    private static final String LABEL = org.talend.sdi.repository.ui.actions.metadata.Messages.getString("CreateGeoMetadata.title"); //$NON-NLS-1$
    
	public CreateGeoMetadata() {
		// TODO Auto-generated constructor stub
		this.setText(LABEL);
        this.setToolTipText(LABEL);
        this.setImageDescriptor(OverlayImageProvider.getImageWithNew(ImageProvider.getImage(ECoreImage.METADATA_GENERIC_ICON)));

	}
	

    public Class getClassForDoubleClick() {
        return null;
    }
    
    
    /*
     * (non-Javadoc)
     * 
     * @see org.talend.repository.ui.actions.metadata.CreateGenericSchemaAction#init(org.talend.repository.model.RepositoryNode)
     */
    @Override
    protected void init(RepositoryNode node) {
    	IProxyRepositoryFactory factory = ProxyRepositoryFactory.getInstance();
        if (factory.isUserReadOnlyOnCurrentProject() || !ProjectManager.getInstance().isInCurrentMainProject(node)) {
            setEnabled(false);
            return;
        }
        
        ERepositoryObjectType nodeType = (ERepositoryObjectType) node.getProperties(EProperties.CONTENT_TYPE);
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
        file = openImportFileDialog();
        if (file == null) {
            return;
        }

        openImportWizard();
    }

    /**
     * Open dialog for GIS file selection
     * 
     * @return
     */
    private File openImportFileDialog() {
        FileDialog dial = new FileDialog(PlatformUI.getWorkbench().getDisplay().getActiveShell(), SWT.OPEN);
        dial.setFilterExtensions(new String[] { "*.shp", "*.SHP" }); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$ //$NON-NLS-4$ //$NON-NLS-5$
//        dial.setFilterExtensions(new String[] { "*.shp", "*.mif", "*.gpx", "*.SHP", "*.MIF", "*.GPX" }); //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$ //$NON-NLS-4$ //$NON-NLS-5$
        String fileName = dial.open();
        if ((fileName != null) && (!fileName.equals(""))) { //$NON-NLS-1$
            return new File(fileName);
        } else {
            return null;
        }
    }

    /**
     * Call generic GIS file wizard
     */
    private void openImportWizard() {
        ISelection selection = getSelection();
        ImportGeoSchemaWizard wizard = new ImportGeoSchemaWizard(PlatformUI.getWorkbench(), selection, getExistingNames(), file);
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
