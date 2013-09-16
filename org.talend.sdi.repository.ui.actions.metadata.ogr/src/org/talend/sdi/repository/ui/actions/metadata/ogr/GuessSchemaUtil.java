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
package org.talend.sdi.repository.ui.actions.metadata.ogr;

import java.util.ArrayList;
import java.util.List;

import org.talend.core.model.metadata.builder.connection.ConnectionFactory;
import org.talend.core.model.metadata.builder.connection.MetadataColumn;
import org.talend.core.model.metadata.types.JavaType;
import org.talend.core.model.metadata.types.JavaTypesManager;

/**
 * Utility to build schema from spatial resources
 */
public class GuessSchemaUtil {
	/**
	 * Guess schema for an OGR resource
	 * 
	 * @param filePath
	 * @param layerName
	 * @return
	 */
	public static List<MetadataColumn> guessSchemaFromOGRDatasource(
			String filePath, String layerName) {
		org.gdal.ogr.ogr.RegisterAll();
		List<MetadataColumn> columns = new ArrayList<MetadataColumn>();
		org.gdal.ogr.DataSource dataset = org.gdal.ogr.ogr
				.Open(filePath, false);
		if (dataset == null) {
			String error = "FAILURE:" + "Unable to open datasource `"
					+ filePath + "' with the OGR drivers.";
			System.err.println(error);
			for (int iDriver = 0; iDriver < org.gdal.ogr.ogr.GetDriverCount(); iDriver++) {
				System.err.println("  -> "
						+ org.gdal.ogr.ogr.GetDriver(iDriver).GetName());
			}
		} else {
			String fidColumn = "";
			String geomColumn = "";
			for (int iLayer = 0; iLayer < dataset.GetLayerCount(); iLayer++) {
				org.gdal.ogr.Layer poLayer = dataset.GetLayer(iLayer);
				String currentLayer = poLayer.GetName();
				if (layerName.equals(currentLayer)) {
					org.gdal.ogr.FeatureDefn poDefn = poLayer.GetLayerDefn();

					if (poLayer.GetFIDColumn().length() > 0) {
						fidColumn = poLayer.GetFIDColumn();
					}
					int colIdx = 0;
					if (poLayer.GetGeometryColumn().length() > 0) {
						geomColumn = poLayer.GetGeometryColumn();
						MetadataColumn metadataColumn = ConnectionFactory.eINSTANCE
								.createMetadataColumn();
						metadataColumn.setName(geomColumn);
						metadataColumn.setTalendType("id_Geometry");
						metadataColumn.setLabel(geomColumn);
						columns.add(colIdx++, metadataColumn);
					} else if (poLayer.GetGeomType() != org.gdal.ogr.ogrConstants.wkbNone) {
						MetadataColumn metadataColumn = ConnectionFactory.eINSTANCE
								.createMetadataColumn();
						metadataColumn.setName("the_geom");
						metadataColumn.setTalendType("id_Geometry");
						metadataColumn.setLabel("the_geom");
						columns.add(colIdx++, metadataColumn);
					}

					for (int iAttr = 0; iAttr < poDefn.GetFieldCount(); iAttr++) {
						org.gdal.ogr.FieldDefn poField = poDefn
								.GetFieldDefn(iAttr);

//						String columnsDef = poField.GetNameRef()
//								+ "#"
//								+ poField.GetFieldTypeName(poField
//										.GetFieldType()) + "#"
//								+ poField.GetWidth() + "."
//								+ poField.GetPrecision();
//						System.out.println(columnsDef);
						MetadataColumn metadataColumn = ConnectionFactory.eINSTANCE
								.createMetadataColumn();
						metadataColumn.setName(poField.GetNameRef());
						JavaType type = JavaTypesManager.STRING;
						switch (poField.GetFieldType()) {
						case org.gdal.ogr.ogrConstants.OFTString:
							type = JavaTypesManager.STRING;
							break;
						case org.gdal.ogr.ogrConstants.OFTInteger:
							type = JavaTypesManager.INTEGER;
							break;
						case org.gdal.ogr.ogrConstants.OFTReal:
							type = JavaTypesManager.DOUBLE;
							break;
						case org.gdal.ogr.ogrConstants.OFTDate:
							type = JavaTypesManager.DATE;
							break;
						case org.gdal.ogr.ogrConstants.OFTDateTime:
							type = JavaTypesManager.DATE;
							// TODO : add date pattern
							break;
						case org.gdal.ogr.ogrConstants.OFTTime:
							type = JavaTypesManager.DATE;
							break;
						case org.gdal.ogr.ogrConstants.OFTBinary:
							type = JavaTypesManager.OBJECT;
							break;
						default:
							type = JavaTypesManager.STRING;
							break;
						}
						metadataColumn.setTalendType(type.getId());
						metadataColumn.setLength(poField.GetWidth());
						metadataColumn.setPrecision(poField.GetPrecision());
						metadataColumn.setLabel(poField.GetNameRef());
						if (poField.GetName().equals(fidColumn)) {
							metadataColumn.setKey(true);
						}
						columns.add(colIdx++, metadataColumn);
					}
				}
			}
		}
		return columns;
	}
}
