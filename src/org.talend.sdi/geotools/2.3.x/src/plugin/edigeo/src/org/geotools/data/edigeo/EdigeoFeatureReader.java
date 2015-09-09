/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.geotools.data.edigeo;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.Iterator;
import java.util.NoSuchElementException;
import org.geotools.data.FeatureReader;
import org.geotools.feature.Feature;
import org.geotools.feature.FeatureType;
import org.geotools.feature.IllegalAttributeException;

/**
 * <p>
 * Private FeatureReader inner class for reading Features from the MIF file
 * </p>
 */
public class EdigeoFeatureReader implements FeatureReader {

    EdigeoVEC vecParser = null;
    private FeatureType ft;
    private ArrayList<Feature> featureList;
    private Iterator<Feature> featureListIterator = null;

    protected class Visitor {
        public void visit(Object[] values, String fid)
                throws IllegalAttributeException {
            // create feature and add it to list
            Feature f = ft.create(values, fid);
            featureList.add(f);
        }
    }

    public EdigeoFeatureReader(File dir, String filename, String obj, FeatureType ft)
            throws IOException, IllegalAttributeException {
        this.ft = ft;
        featureList = new ArrayList<Feature>();
        vecParser = new EdigeoVEC(dir.getParentFile().getPath() + "/" + filename);
        vecParser.readVECFile(obj, new Visitor());
    }

    public FeatureType getFeatureType() {
        return ft;
    }

    public Feature next()
            throws IOException, IllegalAttributeException, NoSuchElementException {
        if (featureListIterator == null) {
            featureListIterator = featureList.iterator();
        }
        return featureListIterator.next();

    }

    public boolean hasNext() throws IOException {
        if (featureListIterator == null) {
            featureListIterator = featureList.iterator();
        }
        return featureListIterator.hasNext();
    }

    public void close() throws IOException {
    }
}
