/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package org.geotools.data.edigeo;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.HashMap;
import java.util.Iterator;

/**
 *
 * @author mcoudert
 */
public class EdigeoDIC {
    
    private File dicFile = null;
    
    private static final String DICExtension = "dic";
    
    private static final String DS = ":";
    private static final String VS = ";";
    
    /**
     * <p>
     * This constructor opens an existing DIC file
     * </p>
     *
     * @param path Full pathName of the thf file, can be specified without the
     *        .thf extension
     *
     * @throws IOException If the specified thf file could not be opened
     */
    public EdigeoDIC(String path) throws IOException {
        super();
        dicFile = EdigeoFileFactory.setFile(path, DICExtension, true);
    }
    
     /**
     * 
     * @param obj
     */
    public HashMap<String,HashMap<String,String>> readDICFile(HashMap<String,String> atts) 
            throws IOException {
        HashMap<String, HashMap<String,String>> attribut = 
                new HashMap<String, HashMap<String,String>>();
        
        Iterator<String> it = atts.keySet().iterator();
        while (it.hasNext()) {
            String key = it.next();
            EdigeoParser dicParser = new EdigeoParser(dicFile);
            HashMap<String, String> attParams = new HashMap<String, String>();
            while (dicParser.readLine()){
                if (dicParser.line.contains(atts.get(key))) {
                    while (dicParser.readLine()){
                        if (dicParser.line.contains("TYPSA")) {
                            attParams.put("type", dicParser.getValue("TYPSA"));
                        }
                        if (dicParser.line.contains("AVCSN")) {
                            int nbPrecoded = Integer.parseInt(dicParser.getValue("AVCSN"));
                            if (nbPrecoded > 0 ) {
                                attParams.put("precoded", "true");
                                String preKey = null;

                                for (int i = 0; i < nbPrecoded; i++) {
                                    while (dicParser.readLine()) {
                                        if (dicParser.line.contains("AVLSA")){
                                            preKey = dicParser.getValue("AVLSA");                              
                                            while (dicParser.readLine()) {
                                                if (dicParser.line.contains("AVDST")) {
                                                    attParams.put(preKey, dicParser.getValue("AVDST"));
                                                    break;
                                                }
                                            }
                                            break;
                                        }
                                    }
                                }
                            } else {
                                attParams.put("precoded", "false");
                            }
                            break;
                        }
                    }                    
                    attribut.put(key, attParams);
                    break;
                }
            }
            dicParser.close();
        }
        return attribut;
    }
    
    /**
     * 
     * @param att
     * @return
     */
    protected String getDicAtt(String att) throws FileNotFoundException {
        EdigeoParser parser = new EdigeoParser(dicFile);
        String dicAtt = null; 
        
        while (parser.readLine()) {
            if (parser.line.contains(DS+att)) {
                parser.readLine();
                dicAtt = parser.getValue("DIPCP")
                        .substring(parser.getValue("DIPCP").lastIndexOf(VS)+1);
                break;
            }
        }
        parser.close();
        
        return dicAtt;
    }

}
