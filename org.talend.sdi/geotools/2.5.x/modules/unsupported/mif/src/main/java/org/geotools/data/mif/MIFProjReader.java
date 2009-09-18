/**
 * 
 */
package org.geotools.data.mif;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.logging.Logger;

import org.geotools.referencing.NamedIdentifier;
import org.geotools.referencing.crs.DefaultGeographicCRS;

import org.opengis.referencing.crs.CoordinateReferenceSystem;



/**
 * <p>
 * MIFProjReader class enables CoordSys clause parsing support for writing of Features in MapInfo
 * MIF/MID text file format.
 * </p>
 * 
 * <p>
 * Open issues:
 * </p>
 * 
 * <ul>
 * <li>
 * CoordSys clause parsing is still not supported for reading MapInfo MIF/MID files.
 * </li>
 * </ul>
 * 
 * @author mcoudert
 */
public class MIFProjReader {
    
    /** The logger for the mif module. */
    protected static final Logger LOGGER = Logger.getLogger(
            "org.geotools.data.mif");
    
    // Constants
    private static final String PRJ_NAME = "MAPINFOW.PRJ";
    private static final String SRID_PATTERN = "\\p";
    private static final String QUOTE = "\"";
    
    private static ConcurrentHashMap prjMap = null;
    
    // File Input Variable : MIF Projection
    private File prjFile = null;
    
    /**
     * Constructor
     */
    public MIFProjReader(String path) throws IOException {
        // TODO use url instead of String
        super();
        checkFileName(path);        
    }
    
    
    /**
     * Check the path name of the PRJ file
     *
     * @param path The full path of the .mif file, with or without extension
     *
     * @throws FileNotFoundException
     */
    private void checkFileName(String path)
        throws FileNotFoundException {
        File file = new File(path);

        if (file.isDirectory()) {
            throw new FileNotFoundException(path + " is a directory");
        }

        if (!file.getName().equals(PRJ_NAME)) {
            throw new FileNotFoundException(" Unexpected file " + path + " for MapInfo Projection.");
        }
        
        prjFile = file; 
    }

    
    /**
     * Reads PRJ file stream tokenizer
     *
     * @param prj
     *
     * @throws IOException
     */
    private void readPrjFile(MIFFileTokenizer prj)
        throws IOException {
        try {
            String line;
            String epsg;
            String mifProj;
           
            while (prj.readLine()) {
                line = prj.getLine();
                if (line.contains(SRID_PATTERN)) {
                    epsg = line.subSequence(line.indexOf(SRID_PATTERN)+2,line.lastIndexOf(QUOTE)).toString();
                    mifProj = line.substring(line.lastIndexOf(QUOTE)+2);
                    fillPrjMap(epsg,mifProj);
                }
            }
        } catch (Exception e) {
            throw new IOException("IOException reading PRJ file, line "
                + prj.getLineNumber() + ": " + e.getMessage());
        }
    }
    
    
    /**
     * This method fills prjMap 
     * 
     * @param SRID Epsg code added in HashMap
     * @param mifCrs MapInfo projection
     * 
     * @throws IOException
     */
    private void fillPrjMap(String SRID, String mifCrs) throws IOException {
        if (!getPrjMap().containsKey(SRID)) {
            getPrjMap().put(SRID, mifCrs);
        }
    }
    

    /**
     * This method initializes prjMap   
     * 
     * @throws IOException
     * 
     * @return java.util.concurrent.ConcurrentHashMap
     *  
     */
    private ConcurrentHashMap getPrjMap() throws IOException {
        if (prjMap == null) {
            
            LOGGER.info("Readding MAPINFO.PRJ file, mapping under construction");
            prjMap = new ConcurrentHashMap();
            
            MIFFileTokenizer prjTokenizer = new MIFFileTokenizer(new BufferedReader(
                    new FileReader(prjFile)));  
            try {
                readPrjFile(prjTokenizer);
            } catch (Exception e) {
                throw new IOException("Can't read PRJ file : " + e.toString());
            } finally {
                try {
                    prjTokenizer.close();
                } catch (Exception e) {
                    throw new IOException("Can't close PRJ file : " + e.toString());
                }
            }
        }
        return prjMap ; 
    }
    
    /**
     * This method checks whether SRID exists in MapInfo projection file.
     * 
     * @param crs Coordinate Reference System 
     * 
     * @throws IOException
     */
    public String checkSRID(CoordinateReferenceSystem crs) throws IOException {
        String coordsys = "";
        String code = "";
        
        if (crs != null) {
            try {
                Set ident = crs.getIdentifiers();
                if ((ident == null || ident.isEmpty()) && crs == DefaultGeographicCRS.WGS84) {
                    code = "4326";
                } else {
                    code = ((NamedIdentifier) ident.toArray()[0]).getCode();
                }
            } catch (Exception e) {
                LOGGER.warning("EPSG code could not be determined");
                code = "-1";
            }
        } else {
            code = "-1";
        }
        
        LOGGER.info("Looking for epsg code : " + code);
        
        if (getPrjMap().containsKey(code)){
            coordsys = (String) getPrjMap().get(code);
            LOGGER.info("MapInfo  equivalent projection is : "+ coordsys);
        } else {
            LOGGER.warning("No MapInfo projection related to your EPSG code : " + code);
        }
        
        return coordsys;    
    }
    
}
