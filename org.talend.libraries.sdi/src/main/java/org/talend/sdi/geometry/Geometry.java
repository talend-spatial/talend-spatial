package org.talend.sdi.geometry;

import java.io.Serializable;
import java.lang.String;

import com.vividsolutions.jts.io.ParseException;
import com.vividsolutions.jts.simplify.TopologyPreservingSimplifier;
import com.vividsolutions.jts.simplify.DouglasPeuckerSimplifier;

public class Geometry implements Serializable {

    /**
     * Determines if a de-serialized file is compatible with this class.
     */
    private static final long serialVersionUID = 6583527010170500724L;

    private final com.vividsolutions.jts.geom.Geometry internalGeometry;

    private String EPSG = "";

    private org.opengis.referencing.crs.CoordinateReferenceSystem CRS;

    public Geometry(com.vividsolutions.jts.geom.Geometry internalGeometry) {
        this.internalGeometry = internalGeometry;
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

    public Geometry buffer(double distance) {
        return new Geometry(internalGeometry.buffer(distance));
    }

    public Geometry buffer(double distance, int quadrantSegments) {
        return new Geometry(internalGeometry.buffer(distance, quadrantSegments));
    }

    public Geometry buffer(double distance, int quadrantSegments,
            int endCapStyle) {
        return new Geometry(internalGeometry.buffer(distance, quadrantSegments,
                endCapStyle));
    }

    public Geometry convexHull() {
        return new Geometry(internalGeometry.convexHull());
    }

    public Geometry simplify(String type, double distanceTolerance) {
        if (type != null && type.equals("DouglasPeuckerSimplifier"))
            return new Geometry(DouglasPeuckerSimplifier.simplify(
                    internalGeometry, distanceTolerance));
        else
            return new Geometry(TopologyPreservingSimplifier.simplify(
                    internalGeometry, distanceTolerance));
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
        return new Geometry(internalGeometry.getCentroid());
    }

    public Geometry getInteriorPoint() {
        return new Geometry(internalGeometry.getInteriorPoint());
    }

    public Geometry getEnvelope() {
        return new Geometry(internalGeometry.getEnvelope());
    }

    public Geometry getBoundary() {
        return new Geometry(internalGeometry.getBoundary());
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
        return new Geometry(internalGeometry.getGeometryN(n));
    }

    /* Projection information */
    public int getSRID() {
        return internalGeometry.getSRID();
    }

    public void setSRID(int SRID) {
        internalGeometry.setSRID(SRID);
    }

    public String getEPSG() {
        return EPSG;
    }

    public void setEPSG(String EPSG) {
        this.EPSG = EPSG;
    }

    public org.opengis.referencing.crs.CoordinateReferenceSystem getCRS() {
        return CRS;
    }

    public void setCRS(org.opengis.referencing.crs.CoordinateReferenceSystem CRS) {
        this.CRS = CRS;
    }

    public com.vividsolutions.jts.geom.Coordinate[] getCoordinates() {
        return internalGeometry.getCoordinates();
    }

    public com.vividsolutions.jts.geom.Geometry _getInternalGeometry() {
        return internalGeometry;
    }

    /* Geom intersection */
    public Geometry union(Geometry geom) {
        return new Geometry(internalGeometry.union(geom.internalGeometry));
    }

    public Geometry intersection(Geometry geom) {
        return new Geometry(internalGeometry
                .intersection(geom.internalGeometry));
    }

    public Geometry symDifference(Geometry geom) {
        return new Geometry(internalGeometry
                .symDifference(geom.internalGeometry));
    }

    public Geometry difference(Geometry geom) {
        return new Geometry(internalGeometry.difference(geom.internalGeometry));
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

    /* Geometry quality control */
    public String isValid() {
        return String.valueOf(internalGeometry.isValid());
    }

    public boolean isEmpty() {
        return internalGeometry.isEmpty();
    }
}
