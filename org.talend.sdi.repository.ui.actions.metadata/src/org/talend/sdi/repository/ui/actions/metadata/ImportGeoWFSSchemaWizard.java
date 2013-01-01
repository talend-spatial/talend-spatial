// ============================================================================
//
// Copyright (C) 2008 Talend Inc. - www.talend.com
//					  Camptocamp  - www.camptocamp.com
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

import java.io.IOException;
import java.net.URL;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.eclipse.core.runtime.Path;
import org.eclipse.jface.layout.GridDataFactory;
import org.eclipse.jface.viewers.ISelection;
import org.eclipse.jface.viewers.IStructuredSelection;
import org.eclipse.jface.wizard.IWizardPage;
import org.eclipse.jface.wizard.WizardPage;
import org.eclipse.swt.SWT;
import org.eclipse.swt.graphics.Cursor;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.widgets.Combo;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Event;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.Listener;
import org.eclipse.swt.widgets.Text;
import org.eclipse.ui.INewWizard;
import org.eclipse.ui.IWorkbench;
import org.geotools.data.DataStore;
import org.geotools.data.wfs.WFSDataStore;
import org.geotools.data.wfs.WFSDataStoreFactory;
import org.geotools.data.wfs.protocol.wfs.Version;
import org.opengis.feature.simple.SimpleFeatureType;
import org.opengis.feature.type.AttributeDescriptor;
import org.talend.commons.exception.BusinessException;
import org.talend.commons.exception.PersistenceException;
import org.talend.commons.ui.runtime.image.ECoreImage;
import org.talend.commons.ui.runtime.image.ImageProvider;
import org.talend.commons.ui.swt.dialogs.ErrorDialogWidthDetailArea;
import org.talend.commons.utils.VersionUtils;
import org.talend.core.CorePlugin;
import org.talend.core.context.Context;
import org.talend.core.context.RepositoryContext;
import org.talend.core.model.metadata.MetadataColumnsAndDbmsId;
import org.talend.core.model.metadata.builder.connection.Connection;
import org.talend.core.model.metadata.builder.connection.ConnectionFactory;
import org.talend.core.model.metadata.builder.connection.GenericPackage;
import org.talend.core.model.metadata.builder.connection.GenericSchemaConnection;
import org.talend.core.model.metadata.builder.connection.MetadataColumn;
import org.talend.core.model.metadata.builder.connection.MetadataTable;
import org.talend.core.model.metadata.types.JavaTypesManager;
import org.talend.core.model.properties.ConnectionItem;
import org.talend.core.model.properties.PropertiesFactory;
import org.talend.core.model.properties.Property;
import org.talend.core.repository.model.ProxyRepositoryFactory;
import org.talend.cwm.helper.ConnectionHelper;
import org.talend.cwm.helper.PackageHelper;
import org.talend.repository.i18n.Messages;
import org.talend.repository.model.IProxyRepositoryFactory;
import org.talend.repository.model.RepositoryNode;
import org.talend.repository.model.RepositoryNodeUtilities;
import org.talend.repository.ui.wizards.RepositoryWizard;
import org.talend.repository.ui.wizards.metadata.connection.genericshema.GenericSchemaWizardPage;
import orgomg.cwm.objectmodel.core.Package;

/**
 * DOC fxprunayre / mcoudert Import WFS FeatureType model. Detailled comment
 * <br/>
 * 
 */
public class ImportGeoWFSSchemaWizard extends RepositoryWizard implements
		INewWizard {

	private static Logger log = Logger
			.getLogger(ImportGeoWFSSchemaWizard.class);

	private MetadataColumnsAndDbmsId<MetadataColumn> metadataColumnsAndDbmsId;

	IProxyRepositoryFactory factory = ProxyRepositoryFactory.getInstance();

	private GenericSchemaWizardPage genericSchemaWizardPage;

	private GenericSchemaConnection connection;

	private Property connectionProperty;

	private ConnectionItem connectionItem;

	private boolean initOK = true;

	private WFSDialog typeNamesPage;

	public ImportGeoWFSSchemaWizard(IWorkbench workbench, ISelection selection,
			String[] existingNames) {
		super(workbench, true);
		this.selection = selection;
		this.existingNames = existingNames;

		setNeedsProgressMonitor(true);
		setDefaultPageImageDescriptor(ImageProvider
				.getImageDesc(ECoreImage.METADATA_TABLE_WIZ));

	}

	/*
	 * (non-Javadoc)
	 * 
	 * @seeorg.talend.repository.ui.wizards.metadata.connection.genericshema.
	 * GenericSchemaWizard#addPages()
	 */
	@Override
	public void addPages() {

		setWindowTitle(org.talend.sdi.repository.ui.actions.metadata.Messages
				.getString("CreateGeoWFSMetadata.title"));//$NON-NLS-1$
		typeNamesPage = new WFSDialog();
		addPage(typeNamesPage);
		addPage(new WizardPage("dummy") {

			@Override
			public boolean isPageComplete() {
				return (genericSchemaWizardPage != null && genericSchemaWizardPage
						.isPageComplete());
			}

			public void createControl(Composite parent) {
				setControl(new Composite(parent, SWT.NONE));
			}

		});
	}

	@Override
	public IWizardPage getNextPage(IWizardPage page) {
		if (page == typeNamesPage) {
			initWizard();
			genericSchemaWizardPage = new GenericSchemaWizardPage(2,
					connectionItem, isRepositoryObjectEditable(), null);
			genericSchemaWizardPage.setWizard(this);
			genericSchemaWizardPage.setTitle(Messages
					.getString("FileTableWizardPage.descriptionCreate"));
			genericSchemaWizardPage.setDescription(Messages
					.getString("FileWizardPage.descriptionUpdateStep0"));

			genericSchemaWizardPage.setPageComplete(true);

			return genericSchemaWizardPage;
		}
		return null;
	}

	@Override
	public IWizardPage getPreviousPage(IWizardPage page) {
		if (page == genericSchemaWizardPage) {
			genericSchemaWizardPage.dispose();
			genericSchemaWizardPage = null;
			return typeNamesPage;
		}
		return null;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @seeorg.talend.repository.ui.wizards.metadata.connection.genericshema.
	 * GenericSchemaWizard#performFinish()
	 */
	@Override
	public boolean performFinish() {
		if (genericSchemaWizardPage.isPageComplete()) {

			try {
				setPropNewName(connectionProperty);
				factory.create(connectionItem, pathToSave);

			} catch (PersistenceException e) {
				String detailError = e.toString();
				new ErrorDialogWidthDetailArea(getShell(), PID, Messages
						.getString("CommonWizard.persistenceException"), //$NON-NLS-1$
						detailError);
				log
						.error(Messages
								.getString("CommonWizard.persistenceException") + "\n" + detailError); //$NON-NLS-1$ //$NON-NLS-2$
				return false;
			} catch (BusinessException e) {
				String detailError = e.toString();
				new ErrorDialogWidthDetailArea(getShell(), PID, Messages
						.getString("CommonWizard.persistenceException"), //$NON-NLS-1$
						detailError);
				log
						.error(Messages
								.getString("CommonWizard.persistenceException") + "\n" + detailError); //$NON-NLS-1$ //$NON-NLS-2$
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

	private void initWizard() {
		final List<org.talend.core.model.metadata.builder.connection.MetadataColumn> listColumns = new ArrayList<org.talend.core.model.metadata.builder.connection.MetadataColumn>();
		try {
			SimpleFeatureType ft = typeNamesPage.ds
					.getSchema(typeNamesPage.typeName);

			for (AttributeDescriptor att : ft.getAttributeDescriptors()) {
				final org.talend.core.model.metadata.builder.connection.MetadataColumn metadataColumn = ConnectionFactory.eINSTANCE
						.createMetadataColumn();
				metadataColumn.setLabel(att.getLocalName());

				if (att.getType().getBinding().isAssignableFrom(String.class)) {
					metadataColumn.setTalendType(JavaTypesManager.STRING
							.getId());
				} else if (att.getType().getBinding().isAssignableFrom(
						Double.class)) {
					metadataColumn.setTalendType(JavaTypesManager.DOUBLE
							.getId());
				} else if (att.getType().getBinding().isAssignableFrom(
						Integer.class)) {
					metadataColumn.setTalendType(JavaTypesManager.INTEGER
							.getId());
				} else if (att.getType().getBinding().isAssignableFrom(
						Float.class)) {
					metadataColumn
							.setTalendType(JavaTypesManager.FLOAT.getId());
				} else if (att.getType().getBinding().isAssignableFrom(
						Date.class)) {
					metadataColumn.setTalendType(JavaTypesManager.DATE.getId());
				} else if (att.getType().getBinding().isAssignableFrom(
						Long.class)) {
					metadataColumn.setTalendType(JavaTypesManager.LONG.getId());
				} else if (att.getType().getBinding().isAssignableFrom(
						Short.class)) {
					metadataColumn
							.setTalendType(JavaTypesManager.SHORT.getId());
				} else if (att.getType().getBinding().getSuperclass()
						.isAssignableFrom(
								com.vividsolutions.jts.geom.Geometry.class)
						|| att
								.getType()
								.getBinding()
								.getSuperclass()
								.isAssignableFrom(
										com.vividsolutions.jts.geom.GeometryCollection.class)
						|| att.getType().getBinding().isAssignableFrom(
								com.vividsolutions.jts.geom.Geometry.class)
						|| att
								.getType()
								.getBinding()
								.isAssignableFrom(
										com.vividsolutions.jts.geom.GeometryCollection.class)) {
					metadataColumn.setTalendType("id_Geometry");
				}
				// TODO att.getRestriction()
				listColumns.add(metadataColumn);
			}
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

		connectionItem = PropertiesFactory.eINSTANCE
				.createGenericSchemaConnectionItem();
		connectionItem.setProperty(connectionProperty);
		connectionItem.setConnection(connection);

		String dbmsId = null;
		if (dbmsId != null && dbmsId.trim() != "") {
			GenericSchemaConnection gsConnection = (GenericSchemaConnection) connection;
			gsConnection.setMappingTypeUsed(true);
			gsConnection.setMappingTypeId(dbmsId);
		}
		MetadataTable metadataTable = ConnectionFactory.eINSTANCE
				.createMetadataTable();
		metadataTable.setId(factory.getNextId());
		metadataTable.setLabel("metadata");

		if (metadataTable.getNamespace() instanceof Package) {
            Package pkg = (Package) metadataTable.getNamespace();
            pkg.getDataManager().add(connection);
        }
		
		metadataTable.getColumns().addAll(listColumns);

		GenericPackage g = (GenericPackage) ConnectionHelper.getPackage(connection.getName(), (Connection) connection,
                GenericPackage.class);
        if (g != null) { // hywang
            g.getOwnedElement().add(metadataTable);
        } else {
            GenericPackage gpkg = ConnectionFactory.eINSTANCE.createGenericPackage();
            PackageHelper.addMetadataTable(metadataTable, gpkg);
            ConnectionHelper.addPackage(gpkg, connection);
        }
	}

	private void initConnection() {
		connectionProperty = PropertiesFactory.eINSTANCE.createProperty();
		connectionProperty.setAuthor(((RepositoryContext) CorePlugin
				.getContext().getProperty(Context.REPOSITORY_CONTEXT_KEY))
				.getUser());
		connectionProperty.setVersion(VersionUtils.DEFAULT_VERSION);
		connectionProperty.setStatusCode(""); //$NON-NLS-1$ 

		String name = checkLabelMatchPattern(typeNamesPage.typeName);

		connectionProperty.setLabel(name);
		connectionProperty.setId(factory.getNextId());
		connection = ConnectionFactory.eINSTANCE
				.createGenericSchemaConnection();

	}

	private String checkLabelMatchPattern(String typeName) {
		if (typeName.contains(":"))
			return typeName.replaceAll(":", "_");
		return typeName;
	}

	private void setPropNewName(Property theProperty)
			throws PersistenceException, BusinessException {
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
		new ErrorDialogWidthDetailArea(getShell(), PID, Messages
				.getString("CommonWizard.persistenceException"), //$NON-NLS-1$
				detailError);
		log
				.error(Messages.getString("CommonWizard.persistenceException") + "\n" + detailError); //$NON-NLS-1$ //$NON-NLS-2$

	}

	public static class WFSDialog extends WizardPage {
		private String serverUrl;
		private String typeName;
		private DataStore ds = null;
		private Version version;

		protected WFSDialog() {
			super("", org.talend.sdi.repository.ui.actions.metadata.Messages
					.getString("CreateGeoWFSMetadata.title"), null);
			setDescription(org.talend.sdi.repository.ui.actions.metadata.Messages
					.getString("CreateGeoWFSMetadata.serverInfo"));
		}

		@Override
		public boolean isPageComplete() {
			return typeName != null;
		}

		@Override
		public boolean canFlipToNextPage() {
			return isPageComplete();
		}

		private DataStore getWFSDatastore() throws IOException {
			if (ds == null) {
				URL wfsUrl;
				wfsUrl = new URL(serverUrl);
				Map map = new HashMap();
				map.put(WFSDataStoreFactory.URL.key, WFSDataStoreFactory
						.createGetCapabilitiesRequest(wfsUrl, version));
				// map.put(WFSDataStoreFactory.USERNAME.key,null);
				// map.put(WFSDataStoreFactory.PASSWORD.key,null);
				// map.put(WFSDataStoreFactory.TRY_GZIP.key,false);
				ds = (WFSDataStore) (new WFSDataStoreFactory())
						.createDataStore(map);
			}
			return ds;
		}

		public String getTypeName() {
			return typeName;
		}

		public DataStore getDs() {
			return ds;
		}

		public void createControl(Composite parent) {
			final Composite composite = (Composite) new Composite(parent,
					SWT.NONE);
			composite.setLayout(new GridLayout(2, false));
			GridDataFactory labelGdf = GridDataFactory.swtDefaults();
			GridDataFactory biggerGdf = GridDataFactory.fillDefaults().grab(
					true, false);

			Label label = new Label(composite, SWT.WRAP);
			label
					.setText(org.talend.sdi.repository.ui.actions.metadata.Messages
							.getString("CreateGeoWFSMetadata.serverURL"));
			labelGdf.applyTo(label);
			final Text txt = new Text(composite, SWT.SINGLE | SWT.BORDER);
			txt.setText("http://");
			biggerGdf.applyTo(txt);

			final Label versionLbl = new Label(composite, SWT.WRAP);
			versionLbl
					.setText(org.talend.sdi.repository.ui.actions.metadata.Messages
							.getString("CreateGeoWFSMetadata.version"));
			labelGdf.applyTo(versionLbl);
			final Combo versionCb = new Combo(composite, SWT.DROP_DOWN | SWT.READ_ONLY);
			biggerGdf.applyTo(versionCb);
			versionCb.add(Version.v1_0_0.name(), 0);
			versionCb.add(Version.v1_1_0.name(), 1);

			Button bt = new Button(composite, SWT.PUSH);
			bt.setText(org.talend.sdi.repository.ui.actions.metadata.Messages
					.getString("CreateGeoWFSMetadata.getTypeNames"));
			GridDataFactory.swtDefaults().span(2, 1).applyTo(bt);

			final Label listLbl = new Label(composite, SWT.WRAP);
			listLbl
					.setText(org.talend.sdi.repository.ui.actions.metadata.Messages
							.getString("CreateGeoWFSMetadata.typeNameList"));
			listLbl.setVisible(false);
			labelGdf.applyTo(listLbl);
			final Combo cb = new Combo(composite, SWT.DROP_DOWN | SWT.READ_ONLY);
			cb.setVisible(false);
			biggerGdf.applyTo(cb);

			bt.addListener(SWT.Selection, new Listener() {
				public void handleEvent(Event event) {
					ds = null;
					typeName = null;
					setErrorMessage(null);
					serverUrl = txt.getText();
					version = versionCb.getSelectionIndex() == 0 ? Version.v1_0_0
							: Version.v1_1_0;
					String[] types;
					Cursor currentCursor = composite.getCursor();
					try {
						composite.setCursor(composite.getDisplay()
								.getSystemCursor(SWT.CURSOR_WAIT));
						types = getWFSDatastore().getTypeNames();
						cb.setItems(types);
						listLbl.setVisible(true);
						cb.setVisible(true);
						getWizard().getContainer().updateButtons();
					} catch (IOException e) {
						setErrorMessage("Failed creating new WFS Datastore.");
						log.error("Failed creating new WFS Datastore.", e);
					} finally {
						composite.setCursor(currentCursor);
					}
				}
			});

			cb.addListener(SWT.Selection, new Listener() {
				public void handleEvent(Event event) {
					int index = cb.getSelectionIndex();
					typeName = cb.getItem(index);
					getWizard().getContainer().updateButtons();
				}
			});

			setControl(composite);
		}

	}

}
