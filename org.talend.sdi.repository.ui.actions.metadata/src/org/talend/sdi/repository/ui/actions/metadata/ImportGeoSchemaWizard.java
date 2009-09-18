// ============================================================================
//
// Copyright (C) 2006-2007 Talend Inc. - www.talend.com
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

import java.io.File;
import java.io.IOException;
import java.net.URISyntaxException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.xml.parsers.ParserConfigurationException;


import org.apache.log4j.Logger;
import org.eclipse.core.runtime.Path;
import org.eclipse.jface.viewers.ISelection;
import org.eclipse.jface.viewers.IStructuredSelection;
import org.eclipse.ui.INewWizard;
import org.eclipse.ui.IWorkbench;
import org.geotools.data.DataStore;
import org.geotools.data.mif.MIFDataStore;
import org.geotools.data.gpx.GpxDataStore;
import org.geotools.data.shapefile.ShapefileDataStore;
import org.opengis.feature.simple.SimpleFeatureType;
import org.opengis.feature.type.AttributeDescriptor;
import org.opengis.feature.type.GeometryDescriptor;
import org.talend.commons.exception.BusinessException;
import org.talend.commons.exception.PersistenceException;
import org.talend.commons.ui.image.ImageProvider;
import org.talend.commons.ui.swt.dialogs.ErrorDialogWidthDetailArea;
import org.talend.commons.utils.VersionUtils;
import org.talend.core.CorePlugin;
import org.talend.core.context.Context;
import org.talend.core.context.RepositoryContext;
import org.talend.core.model.metadata.MetadataColumnsAndDbmsId;
import org.talend.core.model.metadata.builder.connection.ConnectionFactory;
import org.talend.core.model.metadata.builder.connection.GenericSchemaConnection;
import org.talend.core.model.metadata.builder.connection.MetadataColumn;
import org.talend.core.model.metadata.builder.connection.MetadataTable;
import org.talend.core.model.metadata.types.JavaTypesManager;
import org.talend.core.model.properties.ConnectionItem;
import org.talend.core.model.properties.PropertiesFactory;
import org.talend.core.model.properties.Property;
import org.talend.core.ui.images.ECoreImage;
import org.talend.repository.i18n.Messages;
import org.talend.repository.model.IProxyRepositoryFactory;
import org.talend.repository.model.ProxyRepositoryFactory;
import org.talend.repository.model.RepositoryNode;
import org.talend.repository.model.RepositoryNodeUtilities;
import org.talend.repository.ui.wizards.RepositoryWizard;
import org.talend.repository.ui.wizards.metadata.connection.genericshema.GenericSchemaWizardPage;
import org.xml.sax.SAXException;

/**
 * DOC ggu class global comment. Detailled comment <br/>
 * 
 */
public class ImportGeoSchemaWizard extends RepositoryWizard implements INewWizard {

    private static Logger log = Logger.getLogger(ImportGeoSchemaWizard.class);

    private static String GPX_NS = "http://www.topografix.com/GPX/1/1";
    
    private MetadataColumnsAndDbmsId<MetadataColumn> metadataColumnsAndDbmsId;

    IProxyRepositoryFactory factory = ProxyRepositoryFactory.getInstance();

    private GenericSchemaWizardPage genericSchemaWizardPage;

    private GenericSchemaConnection connection;

    private Property connectionProperty;

    private ConnectionItem connectionItem;

    private File file;

    private boolean initOK = true;

    public ImportGeoSchemaWizard(IWorkbench workbench, ISelection selection, String[] existingNames, File file) {
        super(workbench, true);
        this.selection = selection;
        this.existingNames = existingNames;
        this.file = file;

        setNeedsProgressMonitor(true);
        setDefaultPageImageDescriptor(ImageProvider.getImageDesc(ECoreImage.METADATA_TABLE_WIZ));

        if (file == null) {
            return;
        }

        initWizard();

    }

    
    /*
     * (non-Javadoc)
     * 
     * @see org.talend.repository.ui.wizards.metadata.connection.genericshema.GenericSchemaWizard#addPages()
     */
    @Override
    public void addPages() {

        setWindowTitle(org.talend.sdi.repository.ui.actions.metadata.Messages.getString("CreateGeoMetadata.title"));//$NON-NLS-1$

        genericSchemaWizardPage = new GenericSchemaWizardPage(2, connectionItem, isRepositoryObjectEditable(), null);
        genericSchemaWizardPage.setTitle(Messages.getString("FileTableWizardPage.descriptionCreate")); //$NON-NLS-1$
        //$NON-NLS-2$
        genericSchemaWizardPage.setDescription(Messages.getString("FileWizardPage.descriptionUpdateStep0")); //$NON-NLS-1$
        addPage(genericSchemaWizardPage);
        genericSchemaWizardPage.setPageComplete(true);
    }

    /*
     * (non-Javadoc)
     * 
     * @see org.talend.repository.ui.wizards.metadata.connection.genericshema.GenericSchemaWizard#performFinish()
     */
    @Override
    public boolean performFinish() {
        if (genericSchemaWizardPage.isPageComplete()) {

            try {
                setPropNewName(connectionProperty);
                factory.create(connectionItem, pathToSave);

            } catch (PersistenceException e) {
                String detailError = e.toString();
                new ErrorDialogWidthDetailArea(getShell(), PID,
                        Messages.getString("CommonWizard.persistenceException"), //$NON-NLS-1$
                        detailError);
                log.error(Messages.getString("CommonWizard.persistenceException") + "\n" + detailError); //$NON-NLS-1$ //$NON-NLS-2$
                return false;
            } catch (BusinessException e) {
                String detailError = e.toString();
                new ErrorDialogWidthDetailArea(getShell(), PID,
                        Messages.getString("CommonWizard.persistenceException"), //$NON-NLS-1$
                        detailError);
                log.error(Messages.getString("CommonWizard.persistenceException") + "\n" + detailError); //$NON-NLS-1$ //$NON-NLS-2$
                return false;
            }
            return true;
        } else {
            return false;
        }
    }

    public void init(IWorkbench workbench, IStructuredSelection selection) {
        this.selection = selection;

    }

    public boolean isInitOK() {
        return initOK;
    }

    /**
     * Load feature type model for SHP, MIF, GPX Datastore.
     * 
     */
    private void initWizard() {
    	final List<org.talend.core.model.metadata.builder.connection.MetadataColumn> listColumns = new ArrayList<org.talend.core.model.metadata.builder.connection.MetadataColumn>();
        try {
        	DataStore ds = null;
        	SimpleFeatureType ft = null;
        	
        	if (file.getName().toLowerCase().endsWith(".shp")){
        		ds = new ShapefileDataStore(file.toURI().toURL());
        		ft = ((ShapefileDataStore)ds).getSchema(); 
        	} else if (file.getName().toLowerCase().endsWith(".mif")){
        		ds = new MIFDataStore(file.getPath(), null);
        		ft = ds.getSchema(ds.getTypeNames()[0]);
        	} else if (file.getName().toLowerCase().endsWith(".gpx")){
        		ds = new GpxDataStore(file.toURL(), null);
        		ft = ds.getSchema(ds.getTypeNames()[0]);
        	}
        	
        	
        	for (AttributeDescriptor att : ft.getAttributeDescriptors()) {
        		//.getAttributeTypes()
                final org.talend.core.model.metadata.builder.connection.MetadataColumn metadataColumn = ConnectionFactory.eINSTANCE
                .createMetadataColumn();
                metadataColumn.setLabel(att.getLocalName());
                
                if(att.getType().getBinding().isAssignableFrom(String.class)){
                	metadataColumn.setTalendType(JavaTypesManager.STRING.getId());
                }else if(att.getType().getBinding().isAssignableFrom(Double.class)){
                	metadataColumn.setTalendType(JavaTypesManager.DOUBLE.getId());
                }else if(att.getType().getBinding().isAssignableFrom(Integer.class)){
                	metadataColumn.setTalendType(JavaTypesManager.INTEGER.getId());
                }else if(att.getType().getBinding().isAssignableFrom(Float.class)){
                	metadataColumn.setTalendType(JavaTypesManager.FLOAT.getId());
                }else if(att.getType().getBinding().isAssignableFrom(Date.class)){
                	metadataColumn.setTalendType(JavaTypesManager.DATE.getId());
                }else if(att.getType().getBinding().isAssignableFrom(Long.class)){
                	metadataColumn.setTalendType(JavaTypesManager.LONG.getId());
                }else if(att.getType().getBinding().isAssignableFrom(Short.class)){
                	metadataColumn.setTalendType(JavaTypesManager.SHORT.getId());
                }else if(GeometryDescriptor.class.isAssignableFrom(att.getClass())){
                	metadataColumn.setTalendType("id_Geometry");
                }
                // TODO att.getRestriction()
                listColumns.add(metadataColumn);
			}
        	
        } catch (ParserConfigurationException e) {
            showErrorMessages(e.toString());
            return;
        } catch (SAXException e) {
            showErrorMessages(e.toString());
            return;
        } catch (URISyntaxException e) {
            showErrorMessages(e.toString());
            return;
        } catch (IOException e) {
            showErrorMessages(e.toString());
            return;
        }
        if (selection == null || existingNames == null) {
            initConnection();
            pathToSave = new Path("");
        } else {

            Object obj = ((IStructuredSelection) selection).getFirstElement();
            RepositoryNode node = (RepositoryNode) obj;
            switch (node.getType()) {
            case SIMPLE_FOLDER:
                pathToSave = RepositoryNodeUtilities.getPath(node);
                break;
            case SYSTEM_FOLDER:
            default:
                pathToSave = new Path(""); //$NON-NLS-1$
            }

            switch (node.getType()) {
            case SIMPLE_FOLDER:
            case SYSTEM_FOLDER:
                initConnection();
                break;
            default:
                return;
            }
        }

        connectionItem = PropertiesFactory.eINSTANCE.createGenericSchemaConnectionItem();
        connectionItem.setProperty(connectionProperty);
        connectionItem.setConnection(connection);

        String dbmsId = null;
        if (dbmsId != null && dbmsId.trim() != "") {
            GenericSchemaConnection gsConnection = (GenericSchemaConnection) connection;
            gsConnection.setMappingTypeUsed(true);
            gsConnection.setMappingTypeId(dbmsId);
        }
        MetadataTable metadataTable = ConnectionFactory.eINSTANCE.createMetadataTable();
        metadataTable.setId(factory.getNextId());
        metadataTable.setLabel("metadata");
        metadataTable.setConnection(connection);

        metadataTable.getColumns().addAll(listColumns);

        connection.getTables().add(metadataTable);

    }

    private void initConnection() {
        connectionProperty = PropertiesFactory.eINSTANCE.createProperty();
        connectionProperty.setAuthor(((RepositoryContext) CorePlugin.getContext().getProperty(
                Context.REPOSITORY_CONTEXT_KEY)).getUser());
        connectionProperty.setVersion(VersionUtils.DEFAULT_VERSION);
        connectionProperty.setStatusCode(""); //$NON-NLS-1$ 
        String name = file.getName();
        if (name.indexOf(".") > 0) {
            name = name.substring(0, name.indexOf("."));
        }
        connectionProperty.setLabel(name);
        connectionProperty.setId(factory.getNextId());
        connection = ConnectionFactory.eINSTANCE.createGenericSchemaConnection();

    }

    private void setPropNewName(Property theProperty) throws PersistenceException, BusinessException {
        String originalLabel = theProperty.getLabel();

        char j = 'a';
        while (!factory.isNameAvailable(theProperty.getItem(), null)) {
            String nextTry = originalLabel + "_" + (j++); //$NON-NLS-1$ //$NON-NLS-2$
            theProperty.setLabel(nextTry);
            if (j > 'z') {
                setPropNewName(theProperty);
                return;
            }
        }
    }

    private void showErrorMessages(String detailError) {
        initOK = false;
        new ErrorDialogWidthDetailArea(getShell(), PID, Messages.getString("CommonWizard.persistenceException"), //$NON-NLS-1$
                detailError);
        log.error(Messages.getString("CommonWizard.persistenceException") + "\n" + detailError); //$NON-NLS-1$ //$NON-NLS-2$

    }
}
