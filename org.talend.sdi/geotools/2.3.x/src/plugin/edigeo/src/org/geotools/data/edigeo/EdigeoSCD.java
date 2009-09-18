/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package org.geotools.data.edigeo;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;

/**
 *
 * @author mcoudert
 */
public class EdigeoSCD {
    
    private File scdFile = null;
    
    private static final String SCDExtension = "scd";
    
    private static final String DS = ":";
    private static final String VS = ";";
    
    /**
     * <p>
     * This constructor opens an existing THF file
     * </p>
     *
     * @param path Full pathName of the thf file, can be specified without the
     *        .thf extension
     *
     * @throws IOException If the specified thf file could not be opened
     */
    public EdigeoSCD(String path) throws IOException {
        super();
        scdFile = EdigeoFileFactory.setFile(path, SCDExtension, true);
    }
    
     /**
     * 
     * @param obj
     */
    public HashMap<String,String> readSCDFile(String obj) throws IOException {
        EdigeoParser scdParser = new EdigeoParser(scdFile);
        String idAtt = null;
        String idDic = null;
        int nbAtt;
        HashMap<String,String> attIds = new HashMap<String, String>();

        while (scdParser.readLine()) {
            if (scdParser.line.contains(DS + obj)) {
                while(scdParser.readLine()) {
                    if (scdParser.line.contains("AACSN")) {
                        nbAtt = Integer.parseInt(scdParser.getValue("AACSN"));
                        for (int i = 0; i < nbAtt; i++) {
                            scdParser.readLine();
                            idAtt = scdParser.getValue("AAPCP");
                            idAtt = idAtt.substring(idAtt.lastIndexOf(VS)+1);
                            idDic = getDicAtt(idAtt);
                            attIds.put(idAtt, idDic);
                        }
                        break;
                    }                    
                }
                break;
            }
        }
        scdParser.close();
        return attIds;
    }
    
    /**
     * 
     * @param att
     * @return
     */
    protected String getDicAtt(String att) throws FileNotFoundException {
        EdigeoParser parser = new EdigeoParser(scdFile);
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
