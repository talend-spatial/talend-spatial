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

import java.io.IOException;

import org.apache.log4j.Logger;
import org.eclipse.core.runtime.IStatus;
import org.eclipse.swt.SWT;
import org.eclipse.swt.events.ModifyEvent;
import org.eclipse.swt.events.ModifyListener;
import org.eclipse.swt.events.SelectionAdapter;
import org.eclipse.swt.events.SelectionEvent;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Group;
import org.talend.commons.ui.swt.formtools.Form;
import org.talend.commons.ui.swt.formtools.LabelledCombo;
import org.talend.commons.ui.swt.formtools.LabelledFileField;
import org.talend.commons.ui.swt.formtools.UtilsButton;
import org.talend.commons.ui.utils.PathUtils;
import org.talend.core.model.metadata.IMetadataContextModeManager;
import org.talend.core.model.properties.ConnectionItem;
import org.talend.core.utils.TalendQuoteUtils;
import org.talend.sdi.repository.ui.actions.metadata.Messages;

/**
 * @author francois
 * 
 */
public class SpatialVectorStep1Form extends AbstractSpatialVectorFileStepForm {

    private static Logger log = Logger.getLogger(SpatialVectorStep1Form.class);

    /**
     * Settings.
     */
    private static final int WIDTH_GRIDDATA_PIXEL = 300;

    /**
     * Main Fields.
     */
    private LabelledCombo serverCombo;

    private LabelledFileField fileField;

    private LabelledCombo layerNameCombo;

    /**
     * Another.
     */
    private boolean filePathIsDone;

//    private Text fileViewerText;

    private UtilsButton cancelButton;

    private boolean readOnly;

    /**
     * Constructor to use by RCP Wizard.
     * 
     * @param existingNames
     * 
     * @param Composite
     * @param Wizard
     * @param Style
     */
    public SpatialVectorStep1Form(Composite parent, ConnectionItem connectionItem, String[] existingNames,
            IMetadataContextModeManager contextModeManager) {
        super(parent, connectionItem, existingNames);
        setContextModeManager(contextModeManager);
        setupForm();
    }

    /**
     * 
     * Initialize value, forceFocus first field.
     */
    @Override
    protected void initialize() {
    	layerNameCombo.setText("");//getConnection().getFormat().getName());
    	layerNameCombo.clearSelection();

        if (getConnection().getServer() == null) {
            serverCombo.select(0);
            getConnection().setServer(serverCombo.getText());
        } else {
            serverCombo.setText(getConnection().getServer());
        }
        serverCombo.clearSelection();

        // Just mask it.
        serverCombo.setReadOnly(true);

        if (getConnection().getFilePath() != null) {
            if (isContextMode()) {
                fileField.setText(getConnection().getFilePath());
            } else {
                fileField.setText(getConnection().getFilePath().replace("\\\\", "\\")); //$NON-NLS-1$ //$NON-NLS-2$
            }
        }
        adaptFormToEditable();
        // init the fileViewer
        checkFilePathAndManageIt();

    }

    /**
     * DOC ocarbone Comment method "adaptFormToReadOnly".
     * 
     */
    protected void adaptFormToReadOnly() {
        readOnly = isReadOnly();
        // serverCombo.setReadOnly(isReadOnly());
        fileField.setReadOnly(isReadOnly());
        layerNameCombo.setReadOnly(isReadOnly());
        updateStatus(IStatus.OK, ""); //$NON-NLS-1$

    }

    protected void addFields() {
        // Group File Location
        Group group = Form.createGroup(this, 1, Messages.getString("FileStep2.groupDelimitedFileSettings"), 120); //$NON-NLS-1$
        Composite compositeFileLocation = Form.startNewDimensionnedGridLayout(group, 3, WIDTH_GRIDDATA_PIXEL, 120);

        // server Combo - FIXME - not sure is useful ?
        String[] serverLocation = { "Localhost 127.0.0.1" }; //$NON-NLS-1$
        serverCombo = new LabelledCombo(compositeFileLocation, Messages.getString("FileStep1.server"), Messages //$NON-NLS-1$
                .getString("FileStep1.serverTip"), serverLocation, 2, true, SWT.NONE); //$NON-NLS-1$

        // file Field
        String[] extensions = { "*.shp", "*.tab", "*.kml", "*.gml", "*.*", "*" }; //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$ //$NON-NLS-4$
        fileField = new LabelledFileField(compositeFileLocation, Messages.getString("FileStep1.filepath"), extensions); //$NON-NLS-1$

        // layer name Combo
        String[] layers = {  };
         layerNameCombo = new LabelledCombo(compositeFileLocation, Messages.getString("FileStep1.format"), Messages //$NON-NLS-1$
                .getString("FileStep1.formatTip"), layers, 2); //$NON-NLS-1$

        if (!isInWizard()) {
            // Composite BottomButton
            Composite compositeBottomButton = Form.startNewGridLayout(this, 2, false, SWT.CENTER, SWT.CENTER);

            // Button Cancel
            cancelButton = new UtilsButton(compositeBottomButton, Messages.getString("CommonWizard.cancel"), WIDTH_BUTTON_PIXEL, //$NON-NLS-1$
                    HEIGHT_BUTTON_PIXEL);
            // nextButton = new UtilsButton(compositeBottomButton, Messages.getString("CommonWizard.next"),
            // WIDTH_BUTTON_PIXEL, HEIGHT_BUTTON_PIXEL);
        }
        addUtilsButtonListeners();
    }

    protected void addUtilsButtonListeners() {

        if (!isInWizard()) {
            // Event cancelButton
            cancelButton.addSelectionListener(new SelectionAdapter() {

                public void widgetSelected(final SelectionEvent e) {
                    getShell().close();
                }
            });
        }

    }

    /**
     * Main Fields addControls.
     */
    protected void addFieldsListeners() {
        // Event serverCombo
        serverCombo.addModifyListener(new ModifyListener() {

            public void modifyText(final ModifyEvent e) {
                getConnection().setServer(serverCombo.getText());
                checkFieldsValue();
            }
        });

        // fileField : Event modifyText
        fileField.addModifyListener(new ModifyListener() {

            public void modifyText(final ModifyEvent e) {
                if (!isContextMode()) {
                    getConnection().setFilePath(PathUtils.getPortablePath(fileField.getText()));
                    checkFilePathAndManageIt();
                }
            }
        });
        layerNameCombo.addModifyListener(new ModifyListener() {
			@Override
			public void modifyText(ModifyEvent e) {
				if (!isContextMode()) {
					getConnection().setLayerName(layerNameCombo.getText());
					checkFieldsValue();
				}
			}
		});
    }

    /**
     * checkFileFieldsValue active fileViewer if file exist.
     * 
     * @throws IOException
     */
    private void checkFilePathAndManageIt() {
        updateStatus(IStatus.OK, null);
        filePathIsDone = false;
        String fileStr = fileField.getText();
        if (isContextMode() && getContextModeManager() != null) {
            fileStr = getContextModeManager().getOriginalValue(getConnection().getFilePath());
            fileStr = TalendQuoteUtils.removeQuotes(fileStr);
        }
        if ("".equals(fileStr)) { //$NON-NLS-1$
//            fileViewerText.setText(Messages.getString("FileStep1.fileViewerTip1") + " " + maximumRowsToPreview + " " //$NON-NLS-1$ //$NON-NLS-2$ //$NON-NLS-3$
//                    + Messages.getString("FileStep1.fileViewerTip2")); //$NON-NLS-1$
        } else {
            // Load data source layer names
            System.out.println("File: " + fileStr);
            try {
                org.gdal.ogr.ogr.RegisterAll();
            } catch (java.lang.UnsatisfiedLinkError e) {
                // TODO : add to panel info
                System.err.println("In order to use GDAL/OGR in Talend, the java.library.path variable should point to GDAL library.");
                System.err.println("To set this property, go to the Run view > Advanced settings > Use specific JVM Arguments");
                System.err.println("and add a new argument:");
                System.err.println("  -Djava.library.path=/path/to/gdal/swig/java");
                System.err.println("");
                e.printStackTrace();
            	updateStatus(IStatus.ERROR, "In order to use GDAL/OGR in Talend, the java.library.path variable should point to GDAL library using -Djava.library.path=/path/to/gdal/swig/java");
                // Aborting due to wrong GDAL driver configuration
//                throw e;
            }
            layerNameCombo.removeAll();
            org.gdal.ogr.DataSource dataset = org.gdal.ogr.ogr.Open(fileStr, true);
            if (dataset == null) {
            	String error = "FAILURE:" + "Unable to open datasource `"
                        + fileStr + "' with the OGR drivers.";
            	System.err.println(error);
            	updateStatus(IStatus.ERROR, error);
                for (int iDriver = 0; iDriver < org.gdal.ogr.ogr.GetDriverCount(); iDriver++) {
                    System.err.println("  -> " + org.gdal.ogr.ogr.GetDriver(iDriver).GetName());
                }
            } else {
                for (int iLayer = 0; iLayer < dataset.GetLayerCount(); iLayer++) {
                    org.gdal.ogr.Layer poLayer = dataset.GetLayer(iLayer);
                    String layerName = poLayer.GetName();
                    layerNameCombo.add(layerName);
                    
                    // One layer found
                    filePathIsDone = true;
                }
            }
            checkFieldsValue();
        }
    }

    /**
     * Ensures that fields are set.
     * 
     * @return
     */
    protected boolean checkFieldsValue() {


        if (!isContextMode()) {
            fileField.setEditable(true);
            layerNameCombo.setEnabled(true);
        }

        if (fileField.getText() == "") { //$NON-NLS-1$
            updateStatus(IStatus.ERROR, Messages.getString("FileStep1.filepathAlert")); //$NON-NLS-1$
            return false;
        }

        if (!filePathIsDone) {
            updateStatus(IStatus.ERROR, Messages.getString("FileStep1.fileIncomplete")); //$NON-NLS-1$
            return false;
        } else if (layerNameCombo.getSelectionIndex() < 0) {
            updateStatus(IStatus.ERROR, Messages.getString("FileStep1.layerNameAlert")); //$NON-NLS-1$
            return false;
        }

        updateStatus(IStatus.OK, null);
        return true;
    }

    /*
     * (non-Javadoc)
     * 
     * @see org.eclipse.swt.widgets.Control#setVisible(boolean)
     */
    public void setVisible(boolean visible) {
        super.setVisible(visible);
        if (isReadOnly() != readOnly) {
            adaptFormToReadOnly();
        }
        if (visible) {
            initialize();
        }
    }

    @Override
    protected void adaptFormToEditable() {
        super.adaptFormToEditable();
        fileField.setEditable(!isContextMode());
        layerNameCombo.setReadOnly(isContextMode());
    }

}
