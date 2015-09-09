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

import org.apache.log4j.Logger;
import org.eclipse.core.runtime.Path;
import org.eclipse.jface.viewers.ISelection;
import org.eclipse.jface.viewers.IStructuredSelection;
import org.eclipse.ui.INewWizard;
import org.eclipse.ui.IWorkbench;
import org.eclipse.ui.IWorkbenchWizard;
import org.talend.commons.ui.runtime.image.ECoreImage;
import org.talend.commons.ui.runtime.image.ImageProvider;
import org.talend.commons.ui.swt.dialogs.ErrorDialogWidthDetailArea;
import org.talend.commons.utils.VersionUtils;
import org.talend.core.GlobalServiceRegister;
import org.talend.core.ITDQRepositoryService;
import org.talend.core.context.Context;
import org.talend.core.context.RepositoryContext;
import org.talend.core.model.metadata.IMetadataContextModeManager;
import org.talend.core.model.metadata.builder.connection.ConnectionFactory;
import org.talend.core.model.metadata.builder.connection.FileConnection;
import org.talend.core.model.metadata.builder.connection.MetadataTable;
import org.talend.core.model.properties.ConnectionItem;
import org.talend.core.model.properties.PropertiesFactory;
import org.talend.core.model.properties.Property;
import org.talend.core.model.repository.ERepositoryObjectType;
import org.talend.core.model.update.RepositoryUpdateManager;
import org.talend.core.repository.model.ProxyRepositoryFactory;
import org.talend.core.runtime.CoreRuntimePlugin;
import org.talend.cwm.helper.ConnectionHelper;
import org.talend.cwm.helper.PackageHelper;
import org.talend.designer.core.model.utils.emf.talendfile.ContextType;
import org.talend.metadata.managment.ui.utils.ConnectionContextHelper;
import org.talend.metadata.managment.ui.utils.FileConnectionContextUtils;
import org.talend.metadata.managment.ui.wizard.CheckLastVersionRepositoryWizard;
import org.talend.metadata.managment.ui.wizard.PropertiesWizardPage;
import org.talend.metadata.managment.ui.wizard.metadata.MetadataContextModeManager;
import org.talend.metadata.managment.ui.wizard.metadata.connection.Step0WizardPage;
import org.talend.repository.ProjectManager;
import org.talend.repository.model.IProxyRepositoryFactory;
import org.talend.repository.model.RepositoryNode;
import org.talend.repository.model.RepositoryNodeUtilities;
import org.talend.sdi.repository.ui.actions.metadata.Messages;

import orgomg.cwm.resource.record.RecordFactory;
import orgomg.cwm.resource.record.RecordFile;

/**
 * SpatialVectorWizard present the FileForm. Use to create a new vector resource file
 */

public class SpatialVectorWizard extends CheckLastVersionRepositoryWizard implements INewWizard {

    private static Logger log = Logger.getLogger(SpatialVectorWizard.class);

    private PropertiesWizardPage spatialVectorFilePage0;

    private SpatialVectorWizardPage spatialVectorFilePage1;

    private SpatialVectorWizardPage spatialVectorFilePage2;

    private SpatialVectorWizardPage spatialVectorFilePage3;

    private SpatialVectorFileConnection connection;

    private Property connectionProperty;

    private IMetadataContextModeManager contextModeManager;

    private boolean isToolbar;

    private String originaleObjectLabel;

    private String originalVersion;

    private String originalPurpose;

    private String originalDescription;

    private String originalStatus;

    private FileConnection originalConn;

    /**
     * Sets the isToolbar.
     * 
     * @param isToolbar the isToolbar to set
     */
    public void setToolbar(boolean isToolbar) {
        this.isToolbar = isToolbar;
    }

    /**
     * @Deprecated does not seem to be used anymore. Confirm and delete this constructor
     * 
     * Constructor for FileWizard.
     * 
     * @param workbench
     * @param selection
     * @param strings
     */
    @SuppressWarnings("unchecked")
    public SpatialVectorWizard(IWorkbench workbench, boolean creation, ISelection selection, String[] existingNames) {
        super(workbench, creation);
        this.selection = selection;
        this.existingNames = existingNames;
        setNeedsProgressMonitor(true);
        setDefaultPageImageDescriptor(ImageProvider.getImageDesc(ECoreImage.METADATA_FILE_DELIMITED_WIZ));

        Object obj = ((IStructuredSelection) selection).getFirstElement();
        RepositoryNode node = (RepositoryNode) obj;
        switch (node.getType()) {
        case SIMPLE_FOLDER:
        case REPOSITORY_ELEMENT:
            pathToSave = RepositoryNodeUtilities.getPath(node);
            break;
        case SYSTEM_FOLDER:
            pathToSave = new Path(""); //$NON-NLS-1$
            break;
        }

        switch (node.getType()) {
        case SIMPLE_FOLDER:
        case SYSTEM_FOLDER:
            connection = ConnectionFactory.eINSTANCE.createSpatialVectorFileConnection();
            connection.setName(ERepositoryObjectType.METADATA_SPATIAL_FILE_VECTOR.getKey());
            MetadataTable metadataTable = ConnectionFactory.eINSTANCE.createMetadataTable();
            IProxyRepositoryFactory factory = ProxyRepositoryFactory.getInstance();
            metadataTable.setId(factory.getNextId());
            RecordFile record = (RecordFile) ConnectionHelper.getPackage(connection.getName(), connection, RecordFile.class);
            if (record != null) { // hywang
                PackageHelper.addMetadataTable(metadataTable, record);
            } else {
                RecordFile newrecord = RecordFactory.eINSTANCE.createRecordFile();
                newrecord.setName(connection.getName());
                ConnectionHelper.addPackage(newrecord, connection);
                PackageHelper.addMetadataTable(metadataTable, newrecord);
            }
            connectionProperty = PropertiesFactory.eINSTANCE.createProperty();
            connectionProperty.setAuthor(((RepositoryContext) CoreRuntimePlugin.getInstance().getContext()
                    .getProperty(Context.REPOSITORY_CONTEXT_KEY)).getUser());
            connectionProperty.setVersion(VersionUtils.DEFAULT_VERSION);
            connectionProperty.setStatusCode(""); //$NON-NLS-1$

            connectionItem = PropertiesFactory.eINSTANCE.createDelimitedFileConnectionItem();
            connectionItem.setProperty(connectionProperty);
            connectionItem.setConnection(connection);
            break;

        case REPOSITORY_ELEMENT:
            connection = (SpatialVectorFileConnection) ((ConnectionItem) node.getObject().getProperty().getItem()).getConnection();
            connectionProperty = node.getObject().getProperty();
            connectionItem = (ConnectionItem) node.getObject().getProperty().getItem();
            // set the repositoryObject, lock and set isRepositoryObjectEditable
            setRepositoryObject(node.getObject());
            isRepositoryObjectEditable();
            initLockStrategy();
            break;
        }
        if (!creation) {
            this.originaleObjectLabel = this.connectionItem.getProperty().getDisplayName();
            this.originalVersion = this.connectionItem.getProperty().getVersion();
            this.originalDescription = this.connectionItem.getProperty().getDescription();
            this.originalPurpose = this.connectionItem.getProperty().getPurpose();
            this.originalStatus = this.connectionItem.getProperty().getStatusCode();
            originalConn = FileConnectionContextUtils.cloneOriginalValueConnection(connection);
        }
        initConnection();
    }

    public SpatialVectorWizard(IWorkbench workbench, boolean creation, RepositoryNode node, String[] existingNames) {
        super(workbench, creation);
        this.existingNames = existingNames;
        setNeedsProgressMonitor(true);
        setDefaultPageImageDescriptor(ImageProvider.getImageDesc(ECoreImage.METADATA_FILE_DELIMITED_WIZ));
        switch (node.getType()) {
        case SIMPLE_FOLDER:
        case REPOSITORY_ELEMENT:
            pathToSave = RepositoryNodeUtilities.getPath(node);
            break;
        case SYSTEM_FOLDER:
            pathToSave = new Path(""); //$NON-NLS-1$
            break;
        }

        switch (node.getType()) {
        case SIMPLE_FOLDER:
        case SYSTEM_FOLDER:
            connection = ConnectionFactory.eINSTANCE.createSpatialVectorFileConnection();
            connection.setName(ERepositoryObjectType.METADATA_SPATIAL_FILE_VECTOR.getKey());
            MetadataTable metadataTable = ConnectionFactory.eINSTANCE.createMetadataTable();
            IProxyRepositoryFactory factory = ProxyRepositoryFactory.getInstance();
            metadataTable.setId(factory.getNextId());
            RecordFile record = (RecordFile) ConnectionHelper.getPackage(connection.getName(), connection, RecordFile.class);
            if (record != null) { // hywang
                PackageHelper.addMetadataTable(metadataTable, record);
            } else {
                RecordFile newrecord = RecordFactory.eINSTANCE.createRecordFile();
                newrecord.setName(connection.getName());
                ConnectionHelper.addPackage(newrecord, connection);
                PackageHelper.addMetadataTable(metadataTable, newrecord);
            }
            connectionProperty = PropertiesFactory.eINSTANCE.createProperty();
            connectionProperty.setAuthor(((RepositoryContext) CoreRuntimePlugin.getInstance().getContext()
                    .getProperty(Context.REPOSITORY_CONTEXT_KEY)).getUser());
            connectionProperty.setVersion(VersionUtils.DEFAULT_VERSION);
            connectionProperty.setStatusCode(""); //$NON-NLS-1$

            connectionItem = PropertiesFactory.eINSTANCE.createDelimitedFileConnectionItem();
            connectionItem.setProperty(connectionProperty);
            connectionItem.setConnection(connection);
            break;

        case REPOSITORY_ELEMENT:
            connection = (SpatialVectorFileConnection) ((ConnectionItem) node.getObject().getProperty().getItem()).getConnection();
            connectionProperty = node.getObject().getProperty();
            connectionItem = (ConnectionItem) node.getObject().getProperty().getItem();
            // set the repositoryObject, lock and set isRepositoryObjectEditable
            setRepositoryObject(node.getObject());
            isRepositoryObjectEditable();
            initLockStrategy();
            break;
        }
        if (!creation) {
            this.originaleObjectLabel = this.connectionItem.getProperty().getDisplayName();
            this.originalVersion = this.connectionItem.getProperty().getVersion();
            this.originalDescription = this.connectionItem.getProperty().getDescription();
            this.originalPurpose = this.connectionItem.getProperty().getPurpose();
            this.originalStatus = this.connectionItem.getProperty().getStatusCode();
            originalConn = FileConnectionContextUtils.cloneOriginalValueConnection(connection);
        }
        initConnection();
    }

    private void initConnection() {
        ConnectionContextHelper.checkContextMode(connectionItem);
        contextModeManager = new MetadataContextModeManager();
        if (connectionItem.getConnection().isContextMode()) {
            ContextType contextTypeForContextMode = ConnectionContextHelper.getContextTypeForContextMode(
                    connectionItem.getConnection(), connectionItem.getConnection().getContextName());
            contextModeManager.setSelectedContextType(contextTypeForContextMode);
        }
    }

    /**
     * Adding the page to the wizard.
     */
    @Override
    public void addPages() {
        if (isToolbar) {
            pathToSave = null;
        }
        spatialVectorFilePage0 = new Step0WizardPage(connectionProperty, pathToSave,
                ERepositoryObjectType.METADATA_SPATIAL_FILE_VECTOR, !isRepositoryObjectEditable(), creation);
        spatialVectorFilePage1 = new SpatialVectorWizardPage(1, connectionItem, isRepositoryObjectEditable(), existingNames,
                contextModeManager);
        spatialVectorFilePage2 = new SpatialVectorWizardPage(2, connectionItem, isRepositoryObjectEditable(), existingNames,
                contextModeManager);

        if (creation) {
            setWindowTitle(Messages.getString("CreateSpatialVectorWizard.windowTitleCreate")); //$NON-NLS-1$

            spatialVectorFilePage0.setTitle(Messages.getString("FileWizardPage.titleCreate") + " 1 " //$NON-NLS-1$ //$NON-NLS-2$
                    + Messages.getString("FileWizardPage.of") + " 3"); //$NON-NLS-1$ //$NON-NLS-2$
            spatialVectorFilePage0.setDescription(Messages.getString("FileWizardPage.descriptionCreateStep0")); //$NON-NLS-1$
            addPage(spatialVectorFilePage0);

            spatialVectorFilePage1.setTitle(Messages.getString("FileWizardPage.titleCreate") + " 2 " //$NON-NLS-1$ //$NON-NLS-2$
                    + Messages.getString("FileWizardPage.of") + " 3"); //$NON-NLS-1$ //$NON-NLS-2$
            spatialVectorFilePage1.setDescription(Messages.getString("FileWizardPage.descriptionCreateStep1")); //$NON-NLS-1$
            addPage(spatialVectorFilePage1);

            spatialVectorFilePage2.setTitle(Messages.getString("FileWizardPage.titleCreate") + " 3 " //$NON-NLS-1$ //$NON-NLS-2$
                    + Messages.getString("FileWizardPage.of") + " 3"); //$NON-NLS-1$ //$NON-NLS-2$
            spatialVectorFilePage2.setDescription(Messages.getString("FileWizardPage.descriptionCreateStep2")); //$NON-NLS-1$
            addPage(spatialVectorFilePage2);

//            spatialVectorFilePage3 = new SpatialVectorWizardPage(3, connectionItem, isRepositoryObjectEditable(), null,
//                    contextModeManager);
//            spatialVectorFilePage3.setTitle(Messages.getString("FileWizardPage.titleCreate") + " 4 " //$NON-NLS-1$ //$NON-NLS-2$
//                    + Messages.getString("FileWizardPage.of") + " 4"); //$NON-NLS-1$ //$NON-NLS-2$
//            spatialVectorFilePage3.setDescription(Messages.getString("FileWizardPage.descriptionCreateStep3")); //$NON-NLS-1$
//            addPage(spatialVectorFilePage3);

            // spatialVectorFilePage0.setPageComplete(false);
            spatialVectorFilePage1.setPageComplete(false);
            spatialVectorFilePage2.setPageComplete(false);
//            spatialVectorFilePage3.setPageComplete(false);

        } else {
            setWindowTitle(Messages.getString("SpatialVectorFileWizard.windowTitleUpdate")); //$NON-NLS-1$

            spatialVectorFilePage0.setTitle(Messages.getString("FileWizardPage.titleUpdate") + " 1 " //$NON-NLS-1$ //$NON-NLS-2$
                    + Messages.getString("FileWizardPage.of") + " 3"); //$NON-NLS-1$ //$NON-NLS-2$
            spatialVectorFilePage0.setDescription(Messages.getString("FileWizardPage.descriptionUpdateStep0")); //$NON-NLS-1$
            addPage(spatialVectorFilePage0);

            spatialVectorFilePage1.setTitle(Messages.getString("FileWizardPage.titleUpdate") + " 2 " //$NON-NLS-1$ //$NON-NLS-2$
                    + Messages.getString("FileWizardPage.of") + " 3"); //$NON-NLS-1$ //$NON-NLS-2$
            spatialVectorFilePage1.setDescription(Messages.getString("FileWizardPage.descriptionUpdateStep1")); //$NON-NLS-1$
            addPage(spatialVectorFilePage1);

            spatialVectorFilePage2.setTitle(Messages.getString("FileWizardPage.titleUpdate") + " 3 " //$NON-NLS-1$ //$NON-NLS-2$
                    + Messages.getString("FileWizardPage.of") + " 3"); //$NON-NLS-1$ //$NON-NLS-2$
            spatialVectorFilePage2.setDescription(Messages.getString("FileWizardPage.descriptionUpdateStep2")); //$NON-NLS-1$
            addPage(spatialVectorFilePage2);

            spatialVectorFilePage1.setPageComplete(true);
            spatialVectorFilePage2.setPageComplete(isRepositoryObjectEditable());
        }
    }

    /**
     * This method determine if the 'Finish' button is enable This method is called when 'Finish' button is pressed in
     * the wizard. We will create an operation and run it using wizard as execution context.
     */
    @Override
    public boolean performFinish() {

        boolean formIsPerformed;
        if (spatialVectorFilePage3 == null) {
            formIsPerformed = spatialVectorFilePage2.isPageComplete();
        } else {
            formIsPerformed = spatialVectorFilePage3.isPageComplete();
        }

        if (formIsPerformed) {
            IProxyRepositoryFactory factory = ProxyRepositoryFactory.getInstance();
            try {
                if (creation) {
                    String nextId = factory.getNextId();
                    connectionProperty.setId(nextId);
                    factory.create(connectionItem, spatialVectorFilePage0.getDestinationPath());
                } else {
                    // update
                    RepositoryUpdateManager.updateFileConnection(connectionItem);
                    boolean nameModifiedByUser = spatialVectorFilePage0.isNameModifiedByUser();
                    refreshInFinish(nameModifiedByUser);

                    ITDQRepositoryService tdqRepService = null;
                    if (GlobalServiceRegister.getDefault().isServiceRegistered(ITDQRepositoryService.class)) {
                        tdqRepService = (ITDQRepositoryService) GlobalServiceRegister.getDefault().getService(
                                ITDQRepositoryService.class);
                    }
                    if (nameModifiedByUser && tdqRepService != null) {
                        tdqRepService.saveConnectionWithDependency(connectionItem);
                        closeLockStrategy();
                        tdqRepService.refreshCurrentAnalysisEditor();
                    } else {
                        updateConnectionItem();
                    }
                }
                ProxyRepositoryFactory.getInstance().saveProject(ProjectManager.getInstance().getCurrentProject());
            } catch (Exception e) {
                String detailError = e.toString();
                new ErrorDialogWidthDetailArea(getShell(), PID, Messages.getString("CommonWizard.persistenceException"), //$NON-NLS-1$
                        detailError);
                log.error(Messages.getString("CommonWizard.persistenceException") + "\n" + detailError); //$NON-NLS-1$ //$NON-NLS-2$
                return false;
            }
            return true;
        } else {
            return false;
        }
    }

    @Override
    public boolean performCancel() {
        if (!creation) {
            connectionItem.getProperty().setVersion(this.originalVersion);
            connectionItem.getProperty().setDisplayName(this.originaleObjectLabel);
            connectionItem.getProperty().setDescription(this.originalDescription);
            connectionItem.getProperty().setPurpose(this.originalPurpose);
            connectionItem.getProperty().setStatusCode(this.originalStatus);
            FileConnectionContextUtils.retrieveFileConnection(originalConn, connection);
        }
        return super.performCancel();
    }

    /**
     * We will accept the selection in the workbench to see if we can initialize from it.
     * 
     * @see IWorkbenchWizard#init(IWorkbench, IStructuredSelection)
     */
    @Override
    public void init(final IWorkbench workbench, final IStructuredSelection selection2) {
        this.selection = selection2;
    }

    /*
     * (non-Javadoc)
     * 
     * @see org.talend.repository.ui.wizards.RepositoryWizard#getConnectionItem()
     */
    @Override
    public ConnectionItem getConnectionItem() {
        return this.connectionItem;
    }

}
