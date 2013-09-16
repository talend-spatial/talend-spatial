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
package org.talend.sdi.repository.ui.actions.metadata.ogr;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;
import org.eclipse.core.runtime.Path;
import org.eclipse.jface.layout.GridDataFactory;
import org.eclipse.jface.viewers.ISelection;
import org.eclipse.jface.viewers.IStructuredSelection;
import org.eclipse.jface.wizard.IWizardPage;
import org.eclipse.jface.wizard.WizardPage;
import org.eclipse.swt.SWT;
import org.eclipse.swt.graphics.Cursor;
import org.eclipse.swt.layout.FillLayout;
import org.eclipse.swt.widgets.Button;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Event;
import org.eclipse.swt.widgets.Group;
import org.eclipse.swt.widgets.Label;
import org.eclipse.swt.widgets.Listener;
import org.eclipse.swt.widgets.Text;
import org.eclipse.ui.INewWizard;
import org.eclipse.ui.IWorkbench;
import org.talend.commons.exception.BusinessException;
import org.talend.commons.exception.PersistenceException;
import org.talend.commons.ui.runtime.image.ECoreImage;
import org.talend.commons.ui.runtime.image.ImageProvider;
import org.talend.commons.ui.swt.dialogs.ErrorDialogWidthDetailArea;
import org.talend.commons.ui.swt.formtools.Form;
import org.talend.commons.ui.swt.formtools.LabelledCombo;
import org.talend.commons.ui.swt.formtools.LabelledFileField;
import org.talend.commons.utils.VersionUtils;
import org.talend.core.CorePlugin;
import org.talend.core.context.Context;
import org.talend.core.context.RepositoryContext;
import org.talend.core.model.metadata.builder.connection.Connection;
import org.talend.core.model.metadata.builder.connection.ConnectionFactory;
import org.talend.core.model.metadata.builder.connection.GenericPackage;
import org.talend.core.model.metadata.builder.connection.GenericSchemaConnection;
import org.talend.core.model.metadata.builder.connection.MetadataTable;
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
 * DOC fxprunayre Import OGR datasource model. Detailled comment <br/>
 * 
 */
public class ImportSpatialVectorSchemaWizard extends RepositoryWizard implements
		INewWizard {

	private static Logger log = Logger
			.getLogger(ImportSpatialVectorSchemaWizard.class);

	IProxyRepositoryFactory factory = ProxyRepositoryFactory.getInstance();

	private GenericSchemaWizardPage genericSchemaWizardPage;

	private GenericSchemaConnection connection;

	private Property connectionProperty;

	private ConnectionItem connectionItem;

	private boolean initOK = true;

	private OGRDialog layerNamesPage;

	public ImportSpatialVectorSchemaWizard(IWorkbench workbench,
			ISelection selection, String[] existingNames) {
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

		setWindowTitle(org.talend.sdi.repository.ui.actions.metadata.ogr.Messages
				.getString("CreateSpatialVectorMetadata.title"));//$NON-NLS-1$
		layerNamesPage = new OGRDialog();
		addPage(layerNamesPage);
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
		if (page == layerNamesPage) {
			initWizard();
			genericSchemaWizardPage = new GenericSchemaWizardPage(2,
					connectionItem, isRepositoryObjectEditable(), null);
			genericSchemaWizardPage.setWizard(this);
			genericSchemaWizardPage.setTitle("");
			genericSchemaWizardPage.setDescription("");

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
			return layerNamesPage;
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
				new ErrorDialogWidthDetailArea(
						getShell(),
						PID,
						Messages.getString("CommonWizard.persistenceException"), //$NON-NLS-1$
						detailError);
				log.error(Messages
						.getString("CommonWizard.persistenceException") + "\n" + detailError); //$NON-NLS-1$ //$NON-NLS-2$
				return false;
			} catch (BusinessException e) {
				String detailError = e.toString();
				new ErrorDialogWidthDetailArea(
						getShell(),
						PID,
						Messages.getString("CommonWizard.persistenceException"), //$NON-NLS-1$
						detailError);
				log.error(Messages
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
		final List<org.talend.core.model.metadata.builder.connection.MetadataColumn> listColumns = GuessSchemaUtil
				.guessSchemaFromOGRDatasource(layerNamesPage.datasourceUrl,
						layerNamesPage.layerName);
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

		MetadataTable metadataTable = ConnectionFactory.eINSTANCE
				.createMetadataTable();
		metadataTable.setId(factory.getNextId());
		metadataTable.setLabel("metadata");

		if (metadataTable.getNamespace() instanceof Package) {
			Package pkg = (Package) metadataTable.getNamespace();
			pkg.getDataManager().add(connection);
		}

		metadataTable.getColumns().addAll(listColumns);

		GenericPackage g = (GenericPackage) ConnectionHelper.getPackage(
				connection.getName(), (Connection) connection,
				GenericPackage.class);
		if (g != null) { // hywang
			g.getOwnedElement().add(metadataTable);
		} else {
			GenericPackage gpkg = ConnectionFactory.eINSTANCE
					.createGenericPackage();
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

		String name = checkLabelMatchPattern(layerNamesPage.layerName);

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
		new ErrorDialogWidthDetailArea(getShell(), PID,
				Messages.getString("CommonWizard.persistenceException"), //$NON-NLS-1$
				detailError);
		log.error(Messages.getString("CommonWizard.persistenceException") + "\n" + detailError); //$NON-NLS-1$ //$NON-NLS-2$

	}

	public static class OGRDialog extends WizardPage {
		private String datasourceUrl;
		private String layerName;

		protected OGRDialog() {
			super("",
					org.talend.sdi.repository.ui.actions.metadata.ogr.Messages
							.getString("CreateSpatialVectorMetadata.title"),
					null);
			setDescription(org.talend.sdi.repository.ui.actions.metadata.ogr.Messages
					.getString("CreateSpatialVectorMetadata.datasourceInfo"));
		}

		@Override
		public boolean isPageComplete() {
			return layerName != null;
		}

		@Override
		public boolean canFlipToNextPage() {
			return isPageComplete();
		}

		private List<String> getOGRDatasourceLayer(String source)
				throws IOException {
			try {
				org.gdal.ogr.ogr.RegisterAll();
			} catch (java.lang.UnsatisfiedLinkError e) {
				// TODO : add to panel info
				System.err
						.println("In order to use GDAL/OGR in Talend, the java.library.path variable should point to GDAL library.");
				System.err
						.println("To set this property, go to the Run view > Advanced settings > Use specific JVM Arguments");
				System.err.println("and add a new argument:");
				System.err
						.println("  -Djava.library.path=/path/to/gdal/swig/java");
				System.err.println("");
				e.printStackTrace();
				throw e;
			}
			List<String> layers = new ArrayList<String>();
			org.gdal.ogr.DataSource dataset = org.gdal.ogr.ogr.Open(source,
					false);
			if (dataset == null) {
				String error = "FAILURE:" + "Unable to open datasource `"
						+ source + "' with the OGR drivers.";
				System.err.println(error);
				for (int iDriver = 0; iDriver < org.gdal.ogr.ogr
						.GetDriverCount(); iDriver++) {
					System.err.println("  -> "
							+ org.gdal.ogr.ogr.GetDriver(iDriver).GetName());
				}
				IOException e = new IOException(error);
				throw e;
			} else {
				for (int iLayer = 0; iLayer < dataset.GetLayerCount(); iLayer++) {
					org.gdal.ogr.Layer poLayer = dataset.GetLayer(iLayer);
					String layerName = poLayer.GetName();
					layers.add(layerName);
				}
			}
			return layers;
		}

		public String getTypeName() {
			return layerName;
		}

		private static final int WIDTH_GRIDDATA_PIXEL = 500;

		public void createControl(Composite parent) {
			final Composite composite = (Composite) new Composite(parent,
					SWT.NONE);
			composite.setLayout(new FillLayout());
			GridDataFactory labelGdf = GridDataFactory.swtDefaults();

			Group group = Form
					.createGroup(
							composite,
							1,
							org.talend.sdi.repository.ui.actions.metadata.ogr.Messages
									.getString("CreateSpatialVectorMetadata.title"), 120); //$NON-NLS-1$
			final Composite compositeFileLocation = Form
					.startNewDimensionnedGridLayout(group, 3,
							WIDTH_GRIDDATA_PIXEL, 120);

			// Datasource name
			Label label = new Label(compositeFileLocation, SWT.WRAP);
			label.setText(org.talend.sdi.repository.ui.actions.metadata.ogr.Messages
					.getString("CreateSpatialVectorMetadata.datasourceName"));
			final Text datasourceNameField = new Text(compositeFileLocation,
					SWT.SINGLE | SWT.BORDER);
			datasourceNameField.setText("");

			// Empty label to end the grid line - could be improved
			Label labelEmpty = new Label(compositeFileLocation, SWT.WRAP);
			labelEmpty.setText("");

			// or file path
			String[] extensions = {
					"*.shp", "*.mif", "*.tab", "*.kml", "*.gml", "*.dxf", "*.gpx", "*.*", "*" }; //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$ //$NON-NLS-4$
			final LabelledFileField datasourceFilePathField = new LabelledFileField(
					compositeFileLocation,
					org.talend.sdi.repository.ui.actions.metadata.ogr.Messages
							.getString("CreateSpatialVectorMetadata.datasourceFilePath"), extensions); //$NON-NLS-1$

			// Actions to retrieve layer list from datasource
			Button getLayerButton = new Button(compositeFileLocation, SWT.PUSH);
			getLayerButton
					.setText(org.talend.sdi.repository.ui.actions.metadata.ogr.Messages
							.getString("CreateSpatialVectorMetadata.getLayers"));
			GridDataFactory.swtDefaults().span(2, 1).applyTo(getLayerButton);

			// Empty label to end the grid line - could be improved
			Label labelEmpty2 = new Label(compositeFileLocation, SWT.WRAP);
			labelEmpty2.setText("");

			String[] layers = {};
			final LabelledCombo cb = new LabelledCombo(
					compositeFileLocation,
					org.talend.sdi.repository.ui.actions.metadata.ogr.Messages
							.getString("CreateSpatialVectorMetadata.layers"),
					org.talend.sdi.repository.ui.actions.metadata.ogr.Messages
							.getString("CreateSpatialVectorMetadata.layersTip"),
					layers);
			cb.setVisible(false);

			labelGdf.applyTo(compositeFileLocation);

			getLayerButton.addListener(SWT.Selection, new Listener() {
				public void handleEvent(Event event) {
					layerName = null;
					setErrorMessage(null);

					// Get datasource name from field
					datasourceUrl = datasourceNameField.getText();
					if (datasourceUrl.equals("")) {
						// or from filepath
						datasourceUrl = datasourceFilePathField.getText();
					}

					if (datasourceUrl.equals("")) {
						setErrorMessage("Datasource name cannot be empty.");
						return;
					}
					cb.getCombo().removeAll();

					Cursor currentCursor = compositeFileLocation.getCursor();
					try {
						compositeFileLocation.setCursor(compositeFileLocation
								.getDisplay().getSystemCursor(SWT.CURSOR_WAIT));
						List<String> layers = getOGRDatasourceLayer(datasourceUrl);
						String[] types = layers.toArray(new String[layers
								.size()]);
						cb.getCombo().setItems(types);
						cb.setVisible(true);
						getWizard().getContainer().updateButtons();
					} catch (Exception e) {
						setErrorMessage("Unable to retrieve layer datasource. Error is: "
								+ e.getMessage());
						log.error("Unable to retrieve layer datasource.", e);
					} finally {
						compositeFileLocation.setCursor(currentCursor);
					}
				}
			});

			cb.getCombo().addListener(SWT.Selection, new Listener() {
				public void handleEvent(Event event) {
					int index = cb.getSelectionIndex();
					layerName = cb.getItem(index);
					getWizard().getContainer().updateButtons();
				}
			});

			setControl(composite);
		}

	}

}
