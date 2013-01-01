package org.talend.sdi.referencing.factory.gridshift;

import java.io.File;
import java.net.URL;

import org.geotools.factory.AbstractFactory;
import org.geotools.metadata.iso.citation.Citations;
import org.geotools.referencing.factory.gridshift.ClasspathGridShiftLocator;
import org.geotools.referencing.factory.gridshift.DataUtilities;
import org.geotools.referencing.factory.gridshift.GridShiftLocator;
import org.opengis.metadata.citation.Citation;

/**
 * Default grid shift file locator, looks up grids in the filesystem
 * 
 */
public class FilepathGridShiftLocator extends AbstractFactory implements
        GridShiftLocator {
    
    public FilepathGridShiftLocator() {
        super(ClasspathGridShiftLocator.MAXIMUM_PRIORITY);
    }
    
    @Override
    public Citation getVendor() {
        return Citations.GEOTOOLS;
    }
    
    @Override
    public URL locateGrid(String grid) {
        if (grid == null)
            return null;
        
        File gridfile = new File(grid);
        
        if (gridfile.exists()) {
            return DataUtilities.fileToURL(gridfile);
        } else {
            return null;
        }
    }
}
