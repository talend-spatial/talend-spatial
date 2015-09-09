// ============================================================================
//
// Copyright (C) 2011 Neogeo Technologies
//
// This source code is available under agreement available at
// %InstallDIR%\features\org.talend.rcp.branding.%PRODUCTNAME%\%PRODUCTNAME%license.txt
//
// You should have received a copy of the  agreement
// along with this program; if not, write to Talend SA
// 9 rue Pages 92150 Suresnes, France
//   
// ============================================================================
package routines;


/*
 * user specification: the function's comment should contain keys as follows: 1. write about the function's comment.but
 * it must be before the "{talendTypes}" key.
 * 
 * 2. {talendTypes} 's value must be talend Type, it is required . its value should be one of: String, char | Character,
 * long | Long, int | Integer, boolean | Boolean, byte | Byte, Date, double | Double, float | Float, Object, short |
 * Short
 * 
 * 3. {Category} define a category for the Function. it is required. its value is user-defined .
 * 
 * 4. {param} 's format is: {param} <type>[(<default value or closed list values>)] <name>[ : <comment>]
 * 
 * <type> 's value should be one of: string, int, list, double, object, boolean, long, char, date. <name>'s value is the
 * Function's parameter name. the {param} is optional. so if you the Function without the parameters. the {param} don't
 * added. you can have many parameters for the Function.
 * 
 * 5. {example} gives a example for the Function. it is optional.
 */
public class GeometryUtility {
	private static final org.geotools.xml.Parser gmlParser = new org.geotools.xml.Parser(new org.geotools.gml3.GMLConfiguration());
    /**
     * GMLToGeometry: Convert a GML string into a Geometry
     * 
     * 
     * {talendTypes} Geometry
     * 
     * {Category} GeometryUtility
     * 
     * {param} string("<gml:Point>...</gml:Point>") input: The GML to be parsed
     * 
     * {param} boolean(false) input: Validate the GML input document or not
     * 
     * {example} GMLToGeometry(row1.the_geom, false)
     */
    public static org.talend.sdi.geometry.Geometry GMLToGeometry(String gml, boolean validate) {
    	// Set GML parser properties.
    	gmlParser.setStrict(false);
    	gmlParser.setValidating(validate);
    	
        // TODO : Take care of coordinate system
    	
    	// Parse the geometry
		try {
			Object value = gmlParser.parse(new java.io.StringReader(gml));
			return new org.talend.sdi.geometry.Geometry((com.vividsolutions.jts.geom.Geometry) value);
		} catch (Exception e) {
			System.out.println("Error when parsing GML geometry: " + e.getMessage() + ".");
			e.printStackTrace();
		}
    	return null;	
    }
}