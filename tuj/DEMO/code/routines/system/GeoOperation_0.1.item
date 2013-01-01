// ============================================================================
//
// Copyright (C) 2007-2008 Camptocamp - www.camptocamp.com
//               2006-2010 Talend Inc. - www.talend.com
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

import org.talend.sdi.geometry.Geometry;
import com.vividsolutions.jts.geom.Coordinate;
import com.vividsolutions.jts.geom.GeometryFactory;
import com.vividsolutions.jts.operation.distance.DistanceOp;

/**
 * 
 * @author mcoudert
 */
public class GeoOperation {

    /**
     * INTERSECTS( ) Returns true if this geometry intersects the specified
     * geometry.
     * 
     * {talendTypes} boolean | Boolean
     * 
     * {Category} GeoOperation
     * 
     * {param} Geometry(null)
     * 
     * {param} Geometry(null)
     * 
     * {example} INTERSECTS(null,null)
     * 
     */
    public static boolean INTERSECTS(Geometry geom1, Geometry geom2) {
	if (geom1.intersects(geom2) == true) {
	    return true;
	} else {
	    return false;
	}
    }

    /**
     * TOUCHES( ) Returns true if this geometry touches the specified geometry.
     * 
     * {talendTypes} boolean | Boolean
     * 
     * {Category} GeoOperation
     * 
     * {param} Geometry(null)
     * 
     * {param} Geometry(null)
     * 
     * {example} TOUCHES(null,null)
     * 
     */
    public static boolean TOUCHES(Geometry geom1, Geometry geom2) {
	if (geom1.touches(geom2) == true) {
	    return true;
	} else {
	    return false;
	}
    }

    /**
     * CROSSES( ) Returns true if this geometry crosses the specified geometry.
     * 
     * {talendTypes} boolean | Boolean
     * 
     * {Category} GeoOperation
     * 
     * {param} Geometry(null)
     * 
     * {param} Geometry(null)
     * 
     * {example} CROSSES(null,null)
     * 
     */
    public static boolean CROSSES(Geometry geom1, Geometry geom2) {
	if (geom1.crosses(geom2) == true) {
	    return true;
	} else {
	    return false;
	}
    }

    /**
     * CONTAINS( ) Returns true if this Geometry contains the specified
     * Geometry.
     * 
     * {talendTypes} boolean | Boolean
     * 
     * {Category} GeoOperation
     * 
     * {param} Geometry(null)
     * 
     * {param} Geometry(null)
     * 
     * {example} CONTAINS(null,null)
     * 
     */
    public static boolean CONTAINS(Geometry geom1, Geometry geom2) {
	if (geom1.contains(geom2) == true) {
	    return true;
	} else {
	    return false;
	}
    }

    /**
     * WITHIN( ) Returns true if this Geometry is within the specified Geometry.
     * 
     * {talendTypes} boolean | Boolean
     * 
     * {Category} GeoOperation
     * 
     * {param} Geometry(null)
     * 
     * {param} Geometry(null)
     * 
     * {example} WITHIN(null,null)
     * 
     */
    public static boolean WITHIN(Geometry geom1, Geometry geom2) {
	if (geom1.within(geom2) == true) {
	    return true;
	} else {
	    return false;
	}
    }

    /**
     * COVERS( ) Returns true if this Geometry covers the specified Geometry.
     * 
     * {talendTypes} boolean | Boolean
     * 
     * {Category} GeoOperation
     * 
     * {param} Geometry(null)
     * 
     * {param} Geometry(null)
     * 
     * {example} COVERS(null,null)
     * 
     */
    public static boolean COVERS(Geometry geom1, Geometry geom2) {
	if (geom1.covers(geom2) == true) {
	    return true;
	} else {
	    return false;
	}
    }

    /**
     * COVEREDBY( ) Returns true if this Geometry is covered by the specified
     * Geometry.
     * 
     * {talendTypes} boolean | Boolean
     * 
     * {Category} GeoOperation
     * 
     * {param} Geometry(null)
     * 
     * {param} Geometry(null)
     * 
     * {example} COVEREDBY(null,null)
     * 
     */
    public static boolean COVEREDBY(Geometry geom1, Geometry geom2) {
	if (geom1.coveredBy(geom2) == true) {
	    return true;
	} else {
	    return false;
	}
    }

    /**
     * DISJOINT( ) Returns true if this Geometry is disjoint to the specified
     * Geometry.
     * 
     * {talendTypes} boolean | Boolean
     * 
     * {Category} GeoOperation
     * 
     * {param} Geometry(null)
     * 
     * {param} Geometry(null)
     * 
     * {example} DISJOINT(null,null)
     * 
     */
    public static boolean DISJOINT(Geometry geom1, Geometry geom2) {
	if (geom1.disjoint(geom2) == true) {
	    return true;
	} else {
	    return false;
	}
    }

    /**
     * OVERLAPS( ) Returns true if this Geometry overlaps the specified
     * Geometry.
     * 
     * {talendTypes} boolean | Boolean
     * 
     * {Category} GeoOperation
     * 
     * {param} Geometry(null)
     * 
     * {param} Geometry(null)
     * 
     * {example} OVERLAPS(null,null)
     * 
     */
    public static boolean OVERLAPS(Geometry geom1, Geometry geom2) {
	if (geom1.overlaps(geom2) == true) {
	    return true;
	} else {
	    return false;
	}
    }

    /**
     * RELATE( ) Returns the DE-9IM IntersectionMatrix for the two Geometrys.
     * 
     * {talendTypes} string | String
     * 
     * {Category} GeoOperation
     * 
     * {param} Geometry(row1.the_geom)
     * 
     * {param} Geometry(row2.the_geom)
     * 
     * {example} RELATE(row1.the_geom, row2.the_geom)
     * 
     */
    public static String RELATE(Geometry geom1, Geometry geom2) {
    	return geom1.relate(geom2);
    }
    
    /**
     * RELATE( ) Returns true if this Geometry overlaps the specified
     * Geometry.
     * 
     * {talendTypes} boolean | Boolean
     * 
     * {Category} GeoOperation
     * 
     * {param} Geometry(row1.the_geom)
     * 
     * {param} Geometry(row2.the_geom)
     * 
     * {param} String("0FFFFFFF2")
     * 
     * {example} RELATE(row1.the_geom, row2.the_geom, "0FFFFFFF2")
     * 
     */
    public static boolean RELATE(Geometry geom1, Geometry geom2, String intersectionMatrix) {
    	return geom1.relate(geom2, intersectionMatrix);
    }
    
    /**
     * GETDISTANCE( ) Returns the distance of the closest point of two geometries.
     * 
     * {talendTypes} double | Double
     * 
     * {Category} GeoOperation
     * 
     * {param} Geometry(row1.the_geom)
     * 
     * {param} Geometry(row2.the_geom)
     * 
     * {example} GETDISTANCE(row1.the_geom, row2.the_geom)
     * 
     */
    public static double GETDISTANCE(Geometry geom1, Geometry geom2) {
	    return com.vividsolutions.jts.operation.distance.DistanceOp.distance(
			geom1._getInternalGeometry(), 
			geom2._getInternalGeometry()
		);
    }

    /**
     * ISWITHINDISTANCE( ) Returns true if the two geometries lie within a given distance of each other.
     * 
     * {talendTypes} boolean | Boolean
     * 
     * {Category} GeoOperation
     * 
     * {param} Geometry(row1.the_geom)
     * 
     * {param} Geometry(row2.the_geom)
     *
     * {param} double(0.2)
     * 
     * {example} ISWITHINDISTANCE(row1.the_geom, row2.the_geom, 0.2)
     * 
     */
    public static boolean ISWITHINDISTANCE(Geometry geom1, Geometry geom2, double distance) {
	    return com.vividsolutions.jts.operation.distance.DistanceOp.isWithinDistance(
			geom1._getInternalGeometry(), 
			geom2._getInternalGeometry(),
			distance
		);
    }

    /**
     * GETCLOSESTPOINT( ) Returns the closest point of first geometry.
     * 
     * {talendTypes} geometry | Geometry
     * 
     * {Category} GeoOperation
     * 
     * {param} Geometry(row1.the_geom)
     * 
     * {param} Geometry(row2.the_geom)
     * 
     * {example} GETCLOSESTPOINT(row1.the_geom, row2.the_geom)
     * 
     */
    public static Geometry GETCLOSESTPOINT(Geometry geom1, Geometry geom2) {
	Coordinate[] coords = DistanceOp.closestPoints(
			geom1._getInternalGeometry(), 
			geom2._getInternalGeometry()
		);
	
	// TODO handle precision model and SRID
	GeometryFactory gf = new GeometryFactory(); 
	com.vividsolutions.jts.geom.Geometry point = gf.createPoint(coords[0]);
	org.talend.sdi.geometry.Geometry geom = new org.talend.sdi.geometry.Geometry(point);

	return geom;
    }
}
