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
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.log4j.Logger;
import org.eclipse.core.runtime.Path;
import org.eclipse.jface.layout.GridDataFactory;
import org.eclipse.jface.viewers.ISelection;
import org.eclipse.jface.viewers.IStructuredSelection;
import org.eclipse.jface.wizard.IWizardPage;
import org.eclipse.jface.wizard.WizardPage;
import org.eclipse.swt.SWT;
import org.eclipse.swt.graphics.Color;
import org.eclipse.swt.layout.GridLayout;
import org.eclipse.swt.widgets.Combo;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Event;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.Listener;
import org.eclipse.swt.widgets.Text;
import org.eclipse.ui.INewWizard;
import org.eclipse.ui.IWorkbench;
import org.geotools.data.DataStore;
import org.geotools.data.edigeo.EdigeoDataStore;
import org.opengis.feature.simple.SimpleFeatureType;
import org.opengis.feature.type.AttributeDescriptor;
import org.talend.commons.exception.BusinessException;
import org.talend.commons.exception.PersistenceException;
import org.talend.commons.ui.image.ImageProvider;
import org.talend.commons.ui.swt.dialogs.ErrorDialogWidthDetailArea;
import org.talend.commons.ui.swt.formtools.Form;
import org.talend.commons.ui.swt.formtools.LabelledFileField;
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
import org.talend.core.ui.images.ECoreImage;
import org.talend.cwm.helper.ConnectionHelper;
import org.talend.cwm.helper.PackageHelper;
import org.talend.repository.i18n.Messages;
import org.talend.repository.model.IProxyRepositoryFactory;
import org.talend.repository.model.ProxyRepositoryFactory;
import org.talend.repository.model.RepositoryNode;
import org.talend.repository.model.RepositoryNodeUtilities;
import org.talend.repository.ui.wizards.RepositoryWizard;
import org.talend.repository.ui.wizards.metadata.connection.genericshema.GenericSchemaWizardPage;
import orgomg.cwm.objectmodel.core.Package;

/**
 * DOC mcoudert Import EDIGEO FeatureType model. Detailled comment
 * <br/>
 * 
 */
public class ImportGeoEdigeoSchemaWizard extends RepositoryWizard implements
		INewWizard {

	private static Logger log = Logger
			.getLogger(ImportGeoEdigeoSchemaWizard.class);

	private MetadataColumnsAndDbmsId<MetadataColumn> metadataColumnsAndDbmsId;

	IProxyRepositoryFactory factory = ProxyRepositoryFactory.getInstance();

	private GenericSchemaWizardPage genericSchemaWizardPage;

	private GenericSchemaConnection connection;

	private Property connectionProperty;

	private ConnectionItem connectionItem;

	private boolean initOK = true;

	private EdigeoDialog typeNamesPage;

	public ImportGeoEdigeoSchemaWizard(IWorkbench workbench, ISelection selection,
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
				.getString("CreateGeoEdigeoMetadata.title"));//$NON-NLS-1$
		typeNamesPage = new EdigeoDialog();
		addPage(typeNamesPage);
		addPage(new WizardPage("dummy_Edigeo") {

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
			DataStore ds = new EdigeoDataStore(typeNamesPage.filePath, 
					typeNamesPage.edigeoObj);
			SimpleFeatureType ft = ds.getSchema(ds.getTypeNames()[0]);

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

		connectionProperty.setLabel(typeNamesPage.edigeoObj);
		connectionProperty.setId(factory.getNextId());
		connection = ConnectionFactory.eINSTANCE
				.createGenericSchemaConnection();

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

	public static class EdigeoDialog extends WizardPage {
		private String filePath;
		private String edigeoObj;
		private LabelledFileField fileField = null;
		
		private static final String[] objects = { "BATIMENT_id", "BORNE_id",
				"CHARGE_id", "COMMUNE_id", "LIEUDIT_id", "NUMVOIE_id",
				"PARCELLE_id", "POINTCST_id", "PTCANV_id", "SECTION_id", "SUBDFISC_id",
				"SUBDSECT_id", "SYMBLIM_id", "TLINE_id", "TPOINT_id", "TRONFLUV_id", 
				"TRONROUTE_id", "TSURF_id", "VOIEP_id", "ZONCOMMUNI_id"};

		protected EdigeoDialog() {
			super("", org.talend.sdi.repository.ui.actions.metadata.Messages
					.getString("CreateGeoEdigeoMetadata.title"), null);
			setDescription(org.talend.sdi.repository.ui.actions.metadata.Messages
					.getString("CreateGeoEdigeoMetadata.info"));
		}

		@Override
		public boolean isPageComplete() {
			return filePath != null && !filePath.equals("") && edigeoObj != null;
		}

		@Override
		public boolean canFlipToNextPage() {
			return isPageComplete();
		}

		public void createControl(Composite parent) {
			Composite compositeFileLocation = Form
					.startNewDimensionnedGridLayout(parent, 3, 300, 50);

			// EDIGEO file path
			String[] extensions = { "*.THF", "*.thf" };
			fileField = new LabelledFileField(compositeFileLocation,
					org.talend.sdi.repository.ui.actions.metadata.Messages
							.getString("CreateGeoEdigeoMetadata.filePath"),
					extensions);

			// Combo list for EDIGEO objects
			final Label objectLbl = new Label(compositeFileLocation, SWT.WRAP);
			objectLbl
					.setText(org.talend.sdi.repository.ui.actions.metadata.Messages
							.getString("CreateGeoEdigeoMetadata.object"));

			final Combo objectCb = new Combo(compositeFileLocation,
					SWT.DROP_DOWN | SWT.READ_ONLY);
			objectCb.setItems(objects);

			objectCb.addListener(SWT.Selection, new Listener() {
				public void handleEvent(Event event) {
					int index = objectCb.getSelectionIndex();
					edigeoObj = objectCb.getItem(index);
					filePath = fileField.getText();
					getWizard().getContainer().updateButtons();
				}
			});
			setControl(compositeFileLocation);
		}

	}

}
