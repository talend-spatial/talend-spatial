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

import java.io.File;
import java.text.MessageFormat;
import java.util.List;

import org.apache.log4j.Logger;
import org.eclipse.core.runtime.IStatus;
import org.eclipse.jface.dialogs.MessageDialog;
import org.eclipse.swt.SWT;
import org.eclipse.swt.events.KeyAdapter;
import org.eclipse.swt.events.KeyEvent;
import org.eclipse.swt.events.ModifyEvent;
import org.eclipse.swt.events.ModifyListener;
import org.eclipse.swt.events.SelectionAdapter;
import org.eclipse.swt.events.SelectionEvent;
import org.eclipse.swt.layout.FillLayout;
import org.eclipse.swt.widgets.Composite;
import org.eclipse.swt.widgets.Group;
import org.eclipse.swt.widgets.Label;
import org.talend.commons.ui.swt.formtools.Form;
import org.talend.commons.ui.swt.formtools.LabelledText;
import org.talend.commons.ui.swt.formtools.UtilsButton;
import org.talend.commons.utils.data.list.IListenableListListener;
import org.talend.commons.utils.data.list.ListenableListEvent;
import org.talend.core.ITDQRepositoryService;
import org.talend.core.model.metadata.IMetadataContextModeManager;
import org.talend.core.model.metadata.MetadataToolHelper;
import org.talend.core.model.metadata.builder.connection.MetadataColumn;
import org.talend.core.model.metadata.builder.connection.MetadataTable;
import org.talend.core.model.metadata.builder.connection.SpatialVectorFileConnection;
import org.talend.core.model.metadata.editor.MetadataEmfTableEditor;
import org.talend.core.model.properties.ConnectionItem;
import org.talend.core.ui.metadata.editor.MetadataEmfTableEditorView;
import org.talend.repository.ui.utils.FileConnectionContextUtils;
import org.talend.sdi.repository.ui.actions.metadata.Messages;

/**
 * @author francois
 * 
 */
public class SpatialVectorStep2Form extends AbstractSpatialVectorFileStepForm {

	private static Logger log = Logger.getLogger(SpatialVectorStep2Form.class);

	private static final int WIDTH_GRIDDATA_PIXEL = 750;

	private UtilsButton cancelButton;

	private UtilsButton guessButton;

	private MetadataEmfTableEditor metadataEditor;

	private MetadataEmfTableEditorView tableEditorView;

	private Label informationLabel;

	private final MetadataTable metadataTable;

	private LabelledText metadataNameText;

	private LabelledText metadataCommentText;

	private boolean readOnly;

	/**
	 * Constructor to use by RCP Wizard.
	 * 
	 * @param Composite
	 */
	public SpatialVectorStep2Form(Composite parent,
			ConnectionItem connectionItem, MetadataTable metadataTable,
			String[] existingNames) {
		this(parent, connectionItem, metadataTable, existingNames, null);
	}

	public SpatialVectorStep2Form(Composite parent,
			ConnectionItem connectionItem, MetadataTable metadataTable,
			String[] existingNames,
			IMetadataContextModeManager contextModeManager) {
		super(parent, connectionItem, metadataTable, existingNames);
		this.metadataTable = metadataTable;
		setContextModeManager(contextModeManager);
		setupForm();
	}

	/**
	 * 
	 * Initialize value, forceFocus first field.
	 */
	@Override
	protected void initialize() {
		// init the metadata Table
		String label = MetadataToolHelper.validateValue(metadataTable
				.getLabel());
		metadataNameText.setText(label);
		metadataCommentText.setText(metadataTable.getComment());
		metadataEditor.setMetadataTable(metadataTable);
		tableEditorView.setMetadataEditor(metadataEditor);
		tableEditorView.getTableViewerCreator().layout();

		if (getConnection().isReadOnly()) {
			adaptFormToReadOnly();
		} else {
			updateStatus(IStatus.OK, null);
		}
	}

	/**
	 * DOC ocarbone Comment method "adaptFormToReadOnly".
	 * 
	 */
	@Override
	protected void adaptFormToReadOnly() {
		readOnly = isReadOnly();
		guessButton.setEnabled(!isReadOnly());
		metadataNameText.setReadOnly(isReadOnly());
		metadataCommentText.setReadOnly(isReadOnly());
		tableEditorView.setReadOnly(isReadOnly());
	}

	@Override
	protected void addFields() {

		// Header Fields
		Composite mainComposite = Form.startNewDimensionnedGridLayout(this, 2,
				WIDTH_GRIDDATA_PIXEL, 60);
		metadataNameText = new LabelledText(mainComposite,
				Messages.getString("FileStep3.metadataName")); //$NON-NLS-1$
		metadataCommentText = new LabelledText(mainComposite,
				Messages.getString("FileStep3.metadataComment")); //$NON-NLS-1$

		// Group MetaData
		Group groupMetaData = Form.createGroup(this, 1,
				Messages.getString("FileStep3.groupMetadata"), 280); //$NON-NLS-1$
		Composite compositeMetaData = Form.startNewGridLayout(groupMetaData, 1);

		// Composite Guess
		Composite compositeGuessButton = Form.startNewDimensionnedGridLayout(
				compositeMetaData, 2, WIDTH_GRIDDATA_PIXEL, 40);
		informationLabel = new Label(compositeGuessButton, SWT.NONE);
		informationLabel
				.setText(Messages.getString("FileStep3.informationLabel") + "                                                  "); //$NON-NLS-1$ //$NON-NLS-2$
		informationLabel.setSize(500, HEIGHT_BUTTON_PIXEL);

		guessButton = new UtilsButton(compositeGuessButton,
				Messages.getString("FileStep3.guess"), WIDTH_BUTTON_PIXEL, //$NON-NLS-1$
				HEIGHT_BUTTON_PIXEL);
		guessButton.setToolTipText(Messages.getString("FileStep3.guessTip")); //$NON-NLS-1$

		// Composite MetadataTableEditorView
		Composite compositeTable = Form.startNewDimensionnedGridLayout(
				compositeMetaData, 1, WIDTH_GRIDDATA_PIXEL, 200);
		compositeTable.setLayout(new FillLayout());
		metadataEditor = new MetadataEmfTableEditor(
				Messages.getString("FileStep3.metadataDescription")); //$NON-NLS-1$
		tableEditorView = new MetadataEmfTableEditorView(compositeTable,
				SWT.NONE);

		if (!isInWizard()) {
			// Bottom Button
			Composite compositeBottomButton = Form.startNewGridLayout(this, 2,
					false, SWT.CENTER, SWT.CENTER);
			// Button Cancel
			cancelButton = new UtilsButton(
					compositeBottomButton,
					Messages.getString("CommonWizard.cancel"), WIDTH_BUTTON_PIXEL, //$NON-NLS-1$
					HEIGHT_BUTTON_PIXEL);
		}
	}

	/**
	 * Main Fields addControls.
	 */
	@Override
	protected void addFieldsListeners() {
		// metadataNameText : Event modifyText
		metadataNameText.addModifyListener(new ModifyListener() {
			public void modifyText(final ModifyEvent e) {
				MetadataToolHelper.validateSchema(metadataNameText.getText());
				metadataTable.setLabel(metadataNameText.getText());
				checkFieldsValue();
			}
		});
		// metadataNameText : Event KeyListener
		metadataNameText.addKeyListener(new KeyAdapter() {
			@Override
			public void keyPressed(KeyEvent e) {
				MetadataToolHelper.checkSchema(getShell(), e);
			}
		});

		// metadataCommentText : Event modifyText
		metadataCommentText.addModifyListener(new ModifyListener() {
			public void modifyText(final ModifyEvent e) {
				metadataTable.setComment(metadataCommentText.getText());
			}
		});

		// add listener to tableMetadata (listen the event of the toolbars)
		tableEditorView.getMetadataEditor().addAfterOperationListListener(
				new IListenableListListener() {
					public void handleEvent(ListenableListEvent event) {
						checkFieldsValue();
					}
				});
	}

	/**
	 * addButtonControls.
	 * 
	 * @param cancelButton
	 */
	@Override
	protected void addUtilsButtonListeners() {

		// Event guessButton
		guessButton.addSelectionListener(new SelectionAdapter() {

			@Override
			public void widgetSelected(final SelectionEvent e) {
				// changed by hqzhang for TDI-13613, old code is strange, maybe
				// caused by duplicated
				// addUtilsButtonListeners() in addFields() method
				if (connectionItem.getConnection().isContextMode()) {
					connectionItem.getConnection().setContextName(null);
				}
				initGuessSchema();
				// if no file, the process don't be executed
				SpatialVectorFileConnection originalValueConnection = getOriginalValueConnection();
				if (originalValueConnection.getFilePath() == null
						|| originalValueConnection.getFilePath().equals("")) { //$NON-NLS-1$
					informationLabel
							.setText("   " + Messages.getString("FileStep3.filepathAlert") //$NON-NLS-1$ //$NON-NLS-2$
									+ "                                                                              "); //$NON-NLS-1$
					return;
				}
				if (!new File(originalValueConnection.getFilePath()).exists()) {
					String msg = Messages.getString("FileStep3.fileNotExist");//$NON-NLS-1$
					informationLabel.setText(MessageFormat.format(msg,
							originalValueConnection.getFilePath()));
					return;
				}
				if (tableEditorView.getMetadataEditor().getBeanCount() > 0) {
					// MOD qiongli 2012-4-18 TDQ-5130.give a message with DQ
					// update information if has DQ
					// dependences.The column uuid is changed after
					// guessing,should update related analyses.
					if (hasDQDependences()) {
						if (MessageDialog.openConfirm(
								getShell(),
								Messages.getString("FileStep3.guessConfirmation"), Messages //$NON-NLS-1$
										.getString("FileStep3.guessConfirmationMessageWithDQ"))) {//$NON-NLS-1$
							runShadowProcess();
							// in this case,tdqRepositoryService is not null.
							ITDQRepositoryService tdqRepositoryService = (ITDQRepositoryService) org.talend.core.GlobalServiceRegister
									.getDefault().getService(
											ITDQRepositoryService.class);
							tdqRepositoryService
									.updateImpactOnAnalysis(connectionItem);
						}
						return;
					}
					if (MessageDialog.openConfirm(
							getShell(),
							Messages.getString("FileStep3.guessConfirmation"), Messages //$NON-NLS-1$
									.getString("FileStep3.guessConfirmationMessage"))) { //$NON-NLS-1$
						runShadowProcess();
					}
					return;
				}

				runShadowProcess();
			}

		});
		if (cancelButton != null) {
			// Event CancelButton
			cancelButton.addSelectionListener(new SelectionAdapter() {
				@Override
				public void widgetSelected(final SelectionEvent e) {
					getShell().close();
				}
			});
		}

	}

	/**
	 * run a ShadowProcess to determined the Metadata.
	 */
	protected void runShadowProcess() {
		initGuessSchema();
		informationLabel
				.setText("   " + Messages.getString("FileStep3.guessProgress")); //$NON-NLS-1$ //$NON-NLS-2$
		refreshMetaDataTable();
		checkFieldsValue();
	}

	/**
	 * DOC ocarbone Comment method "refreshMetaData".
	 * 
	 * @param csvArray
	 */
	public void refreshMetaDataTable() {
		informationLabel
				.setText("   " + Messages.getString("FileStep3.guessIsDone")); //$NON-NLS-1$ //$NON-NLS-2$

		// clear all items
		tableEditorView.getMetadataEditor().removeAll();

		List<MetadataColumn> columns = GuessSchemaUtil
				.guessSchemaFromOGRDatasource(getConnection().getFilePath(),
						getConnection().getLayerName(), tableEditorView, 1);
		tableEditorView.getMetadataEditor().addAll(columns);
		checkFieldsValue();
		tableEditorView.getTableViewerCreator().layout();
		tableEditorView.getTableViewerCreator().getTable().deselectAll();
		informationLabel.setText(Messages.getString("FileStep3.guessTip")); //$NON-NLS-1$
	}

	/**
	 * Ensures that fields are set. Update checkEnable / use to
	 * checkConnection().
	 * 
	 * @return
	 */
	@Override
	protected boolean checkFieldsValue() {
		if (metadataNameText.getCharCount() == 0) {
			metadataNameText.forceFocus();
			updateStatus(IStatus.ERROR,
					Messages.getString("FileStep1.nameAlert")); //$NON-NLS-1$
			return false;
		} else if (!MetadataToolHelper.isValidSchemaName(metadataNameText
				.getText())) {
			metadataNameText.forceFocus();
			updateStatus(IStatus.ERROR,
					Messages.getString("FileStep1.nameAlertIllegalChar")); //$NON-NLS-1$
			return false;
		} else if (isNameAllowed(metadataNameText.getText())) {
			updateStatus(IStatus.ERROR,
					Messages.getString("CommonWizard.nameAlreadyExist")); //$NON-NLS-1$
			return false;
		}

		if (tableEditorView.getMetadataEditor().getBeanCount() > 0) {
			updateStatus(IStatus.OK, null);
			return true;
		}
		updateStatus(IStatus.ERROR, Messages.getString("FileStep3.itemAlert")); //$NON-NLS-1$
		return false;
	}

	public void saveMetaData() {
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see org.eclipse.swt.widgets.Control#setVisible(boolean)
	 */
	@Override
	public void setVisible(boolean visible) {
		super.setVisible(visible);
		if (super.isVisible()) {
			SpatialVectorFileConnection originalValueConnection = getOriginalValueConnection();
			if (originalValueConnection.getFilePath() != null
					&& (!originalValueConnection.getFilePath().equals("")) //$NON-NLS-1$
					&& new File(originalValueConnection.getFilePath()).exists()) {
				runShadowProcess();
			}

			if (isReadOnly() != readOnly) {
				adaptFormToReadOnly();
			}
		}
	}

	private SpatialVectorFileConnection getOriginalValueConnection() {
		if (isContextMode() && getContextModeManager() != null) {
			return (SpatialVectorFileConnection) FileConnectionContextUtils
					.cloneOriginalValueConnection(getConnection(),
							getContextModeManager().getSelectedContextType());
		}
		return getConnection();
	}
}
