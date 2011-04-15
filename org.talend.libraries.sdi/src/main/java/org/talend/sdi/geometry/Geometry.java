package org.talend.sdi.geometry;

import java.io.Serializable;

import org.opengis.referencing.ReferenceIdentifier;

import com.vividsolutions.jts.geom.IntersectionMatrix;
import com.vividsolutions.jts.io.ParseException;
import com.vividsolutions.jts.simplify.DouglasPeuckerSimplifier;
import com.vividsolutions.jts.simplify.TopologyPreservingSimplifier;

public class Geometry implements Serializable {

    /**
     * Determines if a de-serialized file is compatible with this class.
     */
    private static final long serialVersionUID = 6583527010170500724L;

    private final com.vividsolutions.jts.geom.Geometry internalGeometry;

    private String EPSG = "";

    private org.opengis.referencing.crs.CoordinateReferenceSystem CRS;
    
    /**
     * Nullary constructor used during loading of java_type extension point. 
     */
    public Geometry() {
    	internalGeometry = null;
    }
    
    public Geometry(com.vividsolutions.jts.geom.Geometry internalGeometry) {
        this.internalGeometry = internalGeometry;
    }

    public Geometry(com.vividsolutions.jts.geom.Geometry internalGeometry,
    		org.opengis.referencing.crs.CoordinateReferenceSystem CRS) {
        this.internalGeometry = internalGeometry;
        setCRS(CRS);
    }

    public Geometry(com.vividsolutions.jts.geom.Geometry internalGeometry,
    		String EPSGCode) {
        this.internalGeometry = internalGeometry;
        setCRS(EPSGCode);
        
    }
    
    public Geometry(String wkt) {
        com.vividsolutions.jts.io.WKTReader reader = new com.vividsolutions.jts.io.WKTReader();
        com.vividsolutions.jts.geom.Geometry geom = null;

        try {
            geom = reader.read(wkt);
        } catch (ParseException e) {
            System.out.println("Can't parse WKT."); // FIXME : log elsewhere
        }

        this.internalGeometry = geom;
    }

    public boolean equals(Object o) {
        if (!(o instanceof Geometry))
            return false;
        Geometry geometry = (Geometry) o;
        return geometry.internalGeometry.toText().equals(
                internalGeometry.toText());
    }

    public int hashCode() {
        return internalGeometry.toText().hashCode();
    }

    public String toString() {
        return internalGeometry.toString();
    }

    // TODO : add CRS
    public static Geometry parseGeometry(String geometry) {
    	return new Geometry(geometry);
    }
    
    public Geometry buffer(double distance) {
        return new Geometry(internalGeometry.buffer(distance), this.CRS);
    }

    public Geometry buffer(double distance, int quadrantSegments) {
        return new Geometry(internalGeometry.buffer(distance, quadrantSegments), this.CRS);
    }

    public Geometry buffer(double distance, int quadrantSegments,
            int endCapStyle) {
        return new Geometry(internalGeometry.buffer(distance, quadrantSegments,
                endCapStyle), this.CRS);
    }

    public Geometry convexHull() {
        return new Geometry(internalGeometry.convexHull(), this.CRS);
    }

    public Geometry simplify(String type, double distanceTolerance) {
        if (type != null && type.equals("DouglasPeuckerSimplifier"))
            return new Geometry(DouglasPeuckerSimplifier.simplify(
                    internalGeometry, distanceTolerance), this.CRS);
        else
            return new Geometry(TopologyPreservingSimplifier.simplify(
                    internalGeometry, distanceTolerance), this.CRS);
    }

    public double getLength() {
        return internalGeometry.getLength();
    }

    public double getArea() {
        return internalGeometry.getArea();
    }

    public double distance(Geometry geometry) {
        return internalGeometry.distance(geometry.internalGeometry);
    }

    public Geometry getCentroid() {
        return new Geometry(internalGeometry.getCentroid(), this.CRS);
    }

    public Geometry getInteriorPoint() {
        return new Geometry(internalGeometry.getInteriorPoint(), this.CRS);
    }

    public Geometry getEnvelope() {
        return new Geometry(internalGeometry.getEnvelope(), this.CRS);
    }

    public Geometry getBoundary() {
        return new Geometry(internalGeometry.getBoundary(), this.CRS);
    }

    public int getNumPoints() {
        return internalGeometry.getNumPoints();
    }

    public int getNumGeometries() {
        return internalGeometry.getNumGeometries();
    }

    public String getGeometryType() {
        return internalGeometry.getGeometryType();
    }

    public Geometry getGeometryN(int n) {
        return new Geometry(internalGeometry.getGeometryN(n), this.CRS);
    }

    /* 
     * Get internal JTS geometry SRID.
     */
    public int getSRID() {
        return internalGeometry.getSRID();
    }

    /**
     * Set internal JTS geometry SRID. This method does not set
     * Talend geometry CRS property. Use {@link #setCRS(org.opengis.referencing.crs.CoordinateReferenceSystem)}.
     * 
     * @param SRID
     */
    public void setSRID(int SRID) {
        internalGeometry.setSRID(SRID);
    }

    public String getEPSG() {
        return EPSG;
    }

    public void setEPSG(String EPSG) {
        this.EPSG = EPSG;
        setCRS(EPSG);
    }

    public org.opengis.referencing.crs.CoordinateReferenceSystem getCRS() {
        return CRS;
    }

    /**
     * Set Talend geometry and JTS internal geometry CRS and SRID.
     * @param CRS
     */
    public void setCRS(org.opengis.referencing.crs.CoordinateReferenceSystem CRS) {
        this.CRS = CRS;
        int SRID = -1;
        
        try {
            java.util.Set<ReferenceIdentifier> ident = this.CRS.getIdentifiers();
            if ((ident == null || ident.isEmpty())
                && this.CRS == org.geotools.referencing.crs.DefaultGeographicCRS.WGS84) {
                SRID = 4326;
            } else {
                String code = ((org.geotools.referencing.NamedIdentifier) ident.toArray()[0]).getCode();
                SRID = Integer.parseInt(code);
            }

            // Set internal JTS geometry projection
            setSRID(SRID);
            this.EPSG = "EPSG:" + SRID;
        } catch (Exception e) {
            System.out.println("SRID could not be determined");
            SRID = -1;
        }
    }

    public void setCRS(String EPSGCode) {
    	try {
            setCRS(org.geotools.referencing.CRS.decode(EPSGCode));
        } catch (Exception e) {
            System.out.println ("Set CRS error: " + e.getMessage());
        }
    }
    
    public com.vividsolutions.jts.geom.Coordinate[] getCoordinates() {
        return internalGeometry.getCoordinates();
    }

    public com.vividsolutions.jts.geom.Geometry _getInternalGeometry() {
        return internalGeometry;
    }

    /* Geom intersection */
    public Geometry union(Geometry geom) {
        return new Geometry(internalGeometry.union(geom.internalGeometry), this.CRS);
    }

    public Geometry intersection(Geometry geom) {
        return new Geometry(internalGeometry
                .intersection(geom.internalGeometry), this.CRS);
    }

    public Geometry symDifference(Geometry geom) {
        return new Geometry(internalGeometry
                .symDifference(geom.internalGeometry), this.CRS);
    }

    public Geometry difference(Geometry geom) {
        return new Geometry(internalGeometry.difference(geom.internalGeometry), this.CRS);
    }

    /* 9IM operators */
    public boolean touches(Geometry geom) {
        return internalGeometry.touches(geom.internalGeometry);
    }

    public boolean intersects(Geometry geom) {
        return internalGeometry.intersects(geom.internalGeometry);
    }

    public boolean crosses(Geometry geom) {
        return internalGeometry.crosses(geom.internalGeometry);
    }

    public boolean contains(Geometry geom) {
        return internalGeometry.contains(geom.internalGeometry);
    }

    public boolean within(Geometry geom) {
        return internalGeometry.within(geom.internalGeometry);
    }

    public boolean covers(Geometry geom) {
        return internalGeometry.covers(geom.internalGeometry);
    }

    public boolean coveredBy(Geometry geom) {
        return internalGeometry.coveredBy(geom.internalGeometry);
    }

    public boolean disjoint(Geometry geom) {
        return internalGeometry.disjoint(geom.internalGeometry);
    }

    public boolean overlaps(Geometry geom) {
        return internalGeometry.overlaps(geom.internalGeometry);
    }
    
    public String relate(Geometry geom) {
        IntersectionMatrix im = internalGeometry.relate(geom.internalGeometry);
        return im.toString();
    }
    
    public boolean relate(Geometry geom, String im) {
        return internalGeometry.relate(geom.internalGeometry, im);
    }
    
    /* Geometry quality control */
    public String isValid() {
        return String.valueOf(internalGeometry.isValid());
    }

    public boolean isEmpty() {
        return internalGeometry.isEmpty();
    }
}
