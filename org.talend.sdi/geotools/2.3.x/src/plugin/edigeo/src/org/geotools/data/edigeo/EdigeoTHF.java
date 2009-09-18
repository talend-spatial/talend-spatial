/*
 *    GeoTools - OpenSource mapping toolkit
 *    http://geotools.org
 *    (C) 2005-2006, GeoTools Project Managment Committee (PMC)
 * 
 *    thfParser library is free software; you can redistribute it and/or
 *    modify it under the terms of the GNU Lesser General Public
 *    License as published by the Free Software Foundation;
 *    version 2.1 of the License.
 *
 *    thfParser library is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *    Lesser General Public License for more details.
 */
package org.geotools.data.edigeo;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.HashMap;
import java.util.logging.Logger;

public class EdigeoTHF {

    private Logger logger = Logger.getLogger("org.geotools.data.edigeo");
    
    // Edigeo extension file
    private static final String THFExtension = "thf";
    
    public File thfFile = null;
    // private EdigeoParser thfParser = null;

    private static final String nbVol = "LOCSN";
    private static final String lotName = "LONSA";
    private static final String genName = "GNNSA";
    private static final String geoName = "GONSA";
    private static final String dicName = "DINSA";
    private static final String scdName = "SCNSA";
    private static final String nbVec = "GDCSN";
    private static final String vectName = "GDNSA";
    
    public static HashMap<String, HashMap<String, String>> thfDesc = new HashMap<String, HashMap<String, String>>();

    /**
     * Static bloc to define static THF Descripteur map content
     */
    static {
        /**
         * @param mandatory : O:Obligatoire, F:Facultatif, P:lie a la Presence d'un autre champ, V:lie a la valeur d'un autre champ
         */
        final HashMap<String, String> dBOM = new HashMap<String, String>();
        dBOM.put("nature", "T");
        dBOM.put("format", " ");
        dBOM.put("mandatory", "O");
        dBOM.put("value", "");
        dBOM.put("isparent", "true");
        dBOM.put("parent", "BOM");
        dBOM.put("order", "1");
        dBOM.put("multi", "false");

        final HashMap<String, String> dCSE = new HashMap<String, String>();
        dCSE.put("nature", "T");
        dCSE.put("format", " ");
        dCSE.put("mandatory", "O");
        dCSE.put("value", "");
        dCSE.put("isparent", "false");
        dCSE.put("parent", "BOM");
        dCSE.put("order", "2");
        dCSE.put("multi", "false");

        final HashMap<String, String> dRTY_GTS = new HashMap<String, String>();
        dRTY_GTS.put("nature", "S");
        dRTY_GTS.put("format", "A");
        dRTY_GTS.put("mandatory", "O");
        dRTY_GTS.put("value", "GTS");
        dRTY_GTS.put("isparent", "true");
        dRTY_GTS.put("parent", "GTS");
        dRTY_GTS.put("order", "1");
        dRTY_GTS.put("multi", "false");

        final HashMap<String, String> dRID_GTS = new HashMap<String, String>();
        dRID_GTS.put("nature", "S");
        dRID_GTS.put("format", "A");
        dRID_GTS.put("mandatory", "O");
        dRID_GTS.put("value", "");
        dRID_GTS.put("isparent", "false");
        dRID_GTS.put("parent", "GTS");
        dRID_GTS.put("order", "2");
        dRID_GTS.put("multi", "false");

        final HashMap<String, String> dAUT = new HashMap<String, String>();
        dAUT.put("nature", "S");
        dAUT.put("format", "T");
        dAUT.put("mandatory", "O");
        dAUT.put("value", "");
        dAUT.put("isparent", "false");
        dAUT.put("parent", "GTS");
        dAUT.put("order", "3");
        dAUT.put("multi", "false");

        final HashMap<String, String> dADR = new HashMap<String, String>();
        dADR.put("nature", "S");
        dADR.put("format", "T");
        dADR.put("mandatory", "O");
        dADR.put("value", "");
        dADR.put("isparent", "false");
        dADR.put("parent", "GTS");
        dADR.put("order", "4");
        dADR.put("multi", "false");

        final HashMap<String, String> dLOC = new HashMap<String, String>();
        dLOC.put("nature", "S");
        dLOC.put("format", "N");
        dLOC.put("mandatory", "O");
        dLOC.put("value", "");
        dLOC.put("isparent", "false");
        dLOC.put("parent", "GTS");
        dLOC.put("order", "5");
        dLOC.put("multi", "false");

        final HashMap<String, String> dVOC = new HashMap<String, String>();
        dVOC.put("nature", "S");
        dVOC.put("format", "N");
        dVOC.put("mandatory", "F");
        dVOC.put("value", "");
        dVOC.put("isparent", "false");
        dVOC.put("parent", "GTS");
        dVOC.put("order", "6");
        dVOC.put("multi", "false");

        final HashMap<String, String> dVOL = new HashMap<String, String>();
        dVOL.put("nature", "S");
        dVOL.put("format", "A");
        dVOL.put("mandatory", "V");
        dVOL.put("value", "");
        dVOL.put("isparent", "false");
        dVOL.put("parent", "GTS");
        dVOL.put("order", "7");
        dVOL.put("multi", "true");

        final HashMap<String, String> dSEC = new HashMap<String, String>();
        dSEC.put("nature", "S");
        dSEC.put("format", "N");
        dSEC.put("mandatory", "F");
        dSEC.put("value", "");
        dSEC.put("isparent", "false");
        dSEC.put("parent", "GTS");
        dSEC.put("order", "8");
        dSEC.put("multi", "false");

        final HashMap<String, String> dRDI = new HashMap<String, String>();
        dRDI.put("nature", "S");
        dRDI.put("format", "T");
        dRDI.put("mandatory", "F");
        dRDI.put("value", "");
        dRDI.put("isparent", "false");
        dRDI.put("parent", "GTS");
        dRDI.put("order", "9");
        dRDI.put("multi", "false");

        final HashMap<String, String> dVER = new HashMap<String, String>();
        dVER.put("nature", "S");
        dVER.put("format", "T");
        dVER.put("mandatory", "O");
        dVER.put("value", "1.0");
        dVER.put("isparent", "false");
        dVER.put("parent", "GTS");
        dVER.put("order", "10");
        dVER.put("multi", "false");

        final HashMap<String, String> dVDA = new HashMap<String, String>();
        dVDA.put("nature", "S");
        dVDA.put("format", "D");
        dVDA.put("mandatory", "F");
        dVDA.put("value", "");
        dVDA.put("isparent", "false");
        dVDA.put("parent", "GTS");
        dVDA.put("order", "11");
        dVDA.put("multi", "false");

        final HashMap<String, String> dTRL = new HashMap<String, String>();
        dTRL.put("nature", "S");
        dTRL.put("format", "T");
        dTRL.put("mandatory", "O");
        dTRL.put("value", "");
        dTRL.put("isparent", "false");
        dTRL.put("parent", "GTS");
        dTRL.put("order", "12");
        dTRL.put("multi", "false");

        final HashMap<String, String> dEDN = new HashMap<String, String>();
        dEDN.put("nature", "S");
        dEDN.put("format", "N");
        dEDN.put("mandatory", "O");
        dEDN.put("value", "");
        dEDN.put("isparent", "false");
        dEDN.put("parent", "GTS");
        dEDN.put("order", "13");
        dEDN.put("multi", "false");

        final HashMap<String, String> dTDA = new HashMap<String, String>();
        dTDA.put("nature", "S");
        dTDA.put("format", "D");
        dTDA.put("mandatory", "F");
        dTDA.put("value", "");
        dTDA.put("isparent", "false");
        dTDA.put("parent", "GTS");
        dTDA.put("order", "14");
        dTDA.put("multi", "false");

        final HashMap<String, String> dINF_GTS = new HashMap<String, String>();
        dINF_GTS.put("nature", "S");
        dINF_GTS.put("format", "T");
        dINF_GTS.put("mandatory", "F");
        dINF_GTS.put("value", "");
        dINF_GTS.put("isparent", "false");
        dINF_GTS.put("parent", "GTS");
        dINF_GTS.put("order", "15");
        dINF_GTS.put("multi", "false");

        // if isparent == true and multi == true >> n blocs possible 
        final HashMap<String, String> dRTY_GTL = new HashMap<String, String>();
        dRTY_GTL.put("nature", "S");
        dRTY_GTL.put("format", "A");
        dRTY_GTL.put("mandatory", "O");
        dRTY_GTL.put("value", "");
        dRTY_GTL.put("isparent", "true");
        dRTY_GTL.put("parent", "GTL");
        dRTY_GTL.put("order", "1");
        dRTY_GTL.put("multi", "true");

        final HashMap<String, String> dRID_GTL = new HashMap<String, String>();
        dRID_GTL.put("nature", "S");
        dRID_GTL.put("format", "A");
        dRID_GTL.put("mandatory", "O");
        dRID_GTL.put("value", "");
        dRID_GTL.put("isparent", "false");
        dRID_GTL.put("parent", "GTL");
        dRID_GTL.put("order", "2");
        dRID_GTL.put("multi", "false");

        final HashMap<String, String> dLON = new HashMap<String, String>();
        dLON.put("nature", "S");
        dLON.put("format", "A");
        dLON.put("mandatory", "O");
        dLON.put("value", "");
        dLON.put("isparent", "false");
        dLON.put("parent", "GTL");
        dLON.put("order", "3");
        dLON.put("multi", "false");

        final HashMap<String, String> dINF_GTL = new HashMap<String, String>();
        dINF_GTL.put("nature", "S");
        dINF_GTL.put("format", "T");
        dINF_GTL.put("mandatory", "O");
        dINF_GTL.put("value", "");
        dINF_GTL.put("isparent", "false");
        dINF_GTL.put("parent", "GTL");
        dINF_GTL.put("order", "4");
        dINF_GTL.put("multi", "false");

        final HashMap<String, String> dGNN = new HashMap<String, String>();
        dGNN.put("nature", "S");
        dGNN.put("format", "A");
        dGNN.put("mandatory", "O");
        dGNN.put("value", "");
        dGNN.put("isparent", "false");
        dGNN.put("parent", "GTL");
        dGNN.put("order", "5");
        dGNN.put("multi", "false");

        final HashMap<String, String> dGNI = new HashMap<String, String>();
        dGNI.put("nature", "S");
        dGNI.put("format", "A");
        dGNI.put("mandatory", "O");
        dGNI.put("value", "");
        dGNI.put("isparent", "false");
        dGNI.put("parent", "GTL");
        dGNI.put("order", "6");
        dGNI.put("multi", "false");

        final HashMap<String, String> dGON = new HashMap<String, String>();
        dGON.put("nature", "S");
        dGON.put("format", "A");
        dGON.put("mandatory", "O");
        dGON.put("value", "");
        dGON.put("isparent", "false");
        dGON.put("parent", "GTL");
        dGON.put("order", "7");
        dGON.put("multi", "false");

        final HashMap<String, String> dGOI = new HashMap<String, String>();
        dGOI.put("nature", "S");
        dGOI.put("format", "A");
        dGOI.put("mandatory", "O");
        dGOI.put("value", "");
        dGOI.put("isparent", "false");
        dGOI.put("parent", "GTL");
        dGOI.put("order", "8");
        dGOI.put("multi", "false");

        final HashMap<String, String> dQAN = new HashMap<String, String>();
        dQAN.put("nature", "S");
        dQAN.put("format", "A");
        dQAN.put("mandatory", "F");
        dQAN.put("value", "");
        dQAN.put("isparent", "false");
        dQAN.put("parent", "GTL");
        dQAN.put("order", "9");
        dQAN.put("multi", "false");

        final HashMap<String, String> dQAI = new HashMap<String, String>();
        dQAI.put("nature", "S");
        dQAI.put("format", "A");
        dQAI.put("mandatory", "P");
        dQAI.put("value", "");
        dQAI.put("isparent", "false");
        dQAI.put("parent", "GTL");
        dQAI.put("order", "10");
        dQAI.put("multi", "false");

        final HashMap<String, String> dDIN = new HashMap<String, String>();
        dDIN.put("nature", "S");
        dDIN.put("format", "A");
        dDIN.put("mandatory", "O");
        dDIN.put("value", "");
        dDIN.put("isparent", "false");
        dDIN.put("parent", "GTL");
        dDIN.put("order", "11");
        dDIN.put("multi", "false");

        final HashMap<String, String> dDII = new HashMap<String, String>();
        dDII.put("nature", "S");
        dDII.put("format", "A");
        dDII.put("mandatory", "O");
        dDII.put("value", "");
        dDII.put("isparent", "false");
        dDII.put("parent", "GTL");
        dDII.put("order", "12");
        dDII.put("multi", "false");

        final HashMap<String, String> dSCN = new HashMap<String, String>();
        dSCN.put("nature", "S");
        dSCN.put("format", "A");
        dSCN.put("mandatory", "O");
        dSCN.put("value", "");
        dSCN.put("isparent", "false");
        dSCN.put("parent", "GTL");
        dSCN.put("order", "13");
        dSCN.put("multi", "false");

        final HashMap<String, String> dSCI = new HashMap<String, String>();
        dSCI.put("nature", "S");
        dSCI.put("format", "A");
        dSCI.put("mandatory", "O");
        dSCI.put("value", "");
        dSCI.put("isparent", "false");
        dSCI.put("parent", "GTL");
        dSCI.put("order", "14");
        dSCI.put("multi", "false");

        final HashMap<String, String> dGDC = new HashMap<String, String>();
        dGDC.put("nature", "S");
        dGDC.put("format", "N");
        dGDC.put("mandatory", "O");
        dGDC.put("value", "");
        dGDC.put("isparent", "false");
        dGDC.put("parent", "GTL");
        dGDC.put("order", "15");
        dGDC.put("multi", "false");

        final HashMap<String, String> dGDN = new HashMap<String, String>();
        dGDN.put("nature", "S");
        dGDN.put("format", "A");
        dGDN.put("mandatory", "V");
        dGDN.put("value", "");
        dGDN.put("isparent", "false");
        dGDN.put("parent", "GDC");
        dGDN.put("order", "16");
        dGDN.put("multi", "true");

        final HashMap<String, String> dGDI = new HashMap<String, String>();
        dGDI.put("nature", "S");
        dGDI.put("format", "A");
        dGDI.put("mandatory", "V");
        dGDI.put("value", "");
        dGDI.put("isparent", "false");
        dGDI.put("parent", "GDC");
        dGDI.put("order", "17");
        dGDI.put("multi", "true");

        final HashMap<String, String> dEOM = new HashMap<String, String>();
        dEOM.put("nature", "T");
        dEOM.put("format", " ");
        dEOM.put("mandatory", "O");
        dEOM.put("value", "");
        dEOM.put("isparent", "true");
        dEOM.put("parent", "EOM");
        dEOM.put("order", "1");
        dEOM.put("multi", "false");


        thfDesc.put("BOM", dBOM);
        thfDesc.put("CSE", dCSE);

        thfDesc.put("RTY_GTS", dRTY_GTS);
        thfDesc.put("RID_GTS", dRID_GTS);
        thfDesc.put("AUT", dAUT);
        thfDesc.put("ADR", dADR);
        thfDesc.put("LOC", dLOC);
        thfDesc.put("VOC", dVOC);
        thfDesc.put("VOL", dVOL);
        thfDesc.put("SEC", dSEC);
        thfDesc.put("RDI", dRDI);
        thfDesc.put("VER", dVER);
        thfDesc.put("VDA", dVDA);
        thfDesc.put("TRL", dTRL);
        thfDesc.put("EDN", dEDN);
        thfDesc.put("TDA", dTDA);
        thfDesc.put("INF_GTS", dINF_GTS);

        thfDesc.put("RTY_GTL", dRTY_GTL);
        thfDesc.put("RID_GTL", dRID_GTL);
        thfDesc.put("LON", dLON);
        thfDesc.put("INF_GTL", dINF_GTL);
        thfDesc.put("GNN", dGNN);
        thfDesc.put("GNI", dGNI);
        thfDesc.put("GON", dGON);
        thfDesc.put("GOI", dGOI);
        thfDesc.put("QAN", dQAN);
        thfDesc.put("QAI", dQAI);
        thfDesc.put("DIN", dDIN);
        thfDesc.put("DII", dDII);
        thfDesc.put("SCN", dSCN);
        thfDesc.put("SCI", dSCI);
        thfDesc.put("GDC", dGDC);
        thfDesc.put("GDN", dGDN);
        thfDesc.put("GDI", dGDI);

        thfDesc.put("EOM", dEOM);

    }

    /**
     * <p>
     * thfParser constructor opens an existing THF file
     * </p>
     *
     * @param path Full pathName of the thf file, can be specified without the
     *        .thf extension
     *
     * @throws IOException If the specified thf file could not be opened
     */
    public EdigeoTHF(String path) throws FileNotFoundException {
        super();
        thfFile = EdigeoFileFactory.setFile(path, THFExtension, true);
    }

    /**
     * 
     * @return HashMap<String, String> 
     */
    public HashMap<String, String> readTHFile() throws FileNotFoundException {

        // TODO : create structure for saving infos
        // idea : list defined with initial capacity given nb value , ordered
        // or a Map String, Map<String, String> with a numeric key index
        // at time only one lot is read 
        EdigeoParser thfParser = new EdigeoParser(thfFile);

        HashMap<String, String> thfValue = new HashMap<String, String>();
        String value = null;
        String lname = null;

        while (thfParser.readLine()) {

//            if (thfParser.line.contains(nbVol)) {
//                value = getValue(nbVol);
//                System.out.println("nb volm : "+value);
//            }

            if (thfParser.line.contains(lotName)) {
                lname = thfParser.getValue(lotName);
                continue;
            }

            if (thfParser.line.contains(genName)) {
                value = thfParser.getValue(genName);
                thfValue.put("genfname", lname + value);
                continue;
            }

            if (thfParser.line.contains(geoName)) {
                value = thfParser.getValue(geoName);
                thfValue.put("geofname", lname + value);
                continue;
            }

            if (thfParser.line.contains(dicName)) {
                value = thfParser.getValue(dicName);
                thfValue.put("dicfname", lname + value);
                continue;
            }

            if (thfParser.line.contains(scdName)) {
                value = thfParser.getValue(scdName);
                thfValue.put("scdfname", lname + value);
                continue;
            }

            if (thfParser.line.contains(nbVec)) {
                value = thfParser.getValue(nbVec);
                thfValue.put("nbvec", value);
                continue;
            }

            if (thfParser.line.contains(vectName)) {
                value = thfParser.getValue(vectName);
                thfValue.put("vecfname_"+value, lname + value);
                continue;
            }
        }
        thfParser.close();
        return thfValue;
    }
    
}
