package org.talend.sdi.metadata;

import java.io.File;
import java.io.FileWriter;
import java.util.List;
import java.util.UUID;

import org.dom4j.Document;
import org.dom4j.Element;
import org.dom4j.io.OutputFormat;
import org.dom4j.io.SAXReader;
import org.dom4j.io.XMLWriter;

/**
 * Metadata is used to populate a metadata object from a Talend SDI Job.
 * Metadata element generated are basically the core element of the 
 * ISO19115 standard.
 *  
 * This class is producing ISO19139 xml output. 
 * 
 * @author      Fxp
 */
public class Metadata {

    /**
     * Metadata identifier.
     */
    private String uuid;

    /**
     * Metadata xml tree.
     */
    private Document xml;

    /**
     * Metadata title.
     */
    public String title;

    /**
     * Metadata purpose.
     */
    public String purpose;

    /**
     * Metadata abstract.
     */
    public String abs;

    /**
     * Metadata bbox.
     */
    public String bbox;
    
    /**
     * Date format for year, month and day.
     */
    public static final String DATE_FORMAT_YMD = "yyyy-MM-dd";

    /**
     * Date format for hour, minute, second.
     */
    public static final String DATE_FORMAT_TIME = "HH:mm:ss";

    /** 
     * Class for Metadata Standard
     */
    public class Standard {
        /**
         * ISO19139
         */
        public static final String ISO = "ISO19139";
        
        /**
         * Dublic Core Lightweigth for GeoInformatic
         */
        public static final String DC = "DCL4G";

    }

    /** 
     * Class for ISO xPath selection.
     */
    public class ISO {

        public static final String ROOT = "/gmd:MD_Metadata";

        public static final String IDENT = ROOT + "/gmd:identificationInfo/gmd:MD_DataIdentification";

        public static final String UUID = ROOT + "/gmd:fileIdentifier/gco:CharacterString";

        public static final String CONTACT = ROOT + "/gmd:contact/gmd:CI_ResponsibleParty/gmd:individualName/gco:CharacterString";
        
        public static final String TITLE = IDENT + "/gmd:citation/gmd:CI_Citation/gmd:title/gco:CharacterString";

        public static final String ABS = IDENT + "/gmd:abstract/gco:CharacterString";

        public static final String PURPOSE = IDENT + "/gmd:purpose/gco:CharacterString";
        
        public static final String TOPICCATEGORY = IDENT + "/gmd:topicCategory/gmd:MD_TopicCategoryCode";
        
        public static final String MDDATE = ROOT + "/gmd:dateStamp/gco:DateTime";

        public static final String MDCIDATE = IDENT + "/gmd:citation/gmd:CI_Citation/gmd:date/gmd:CI_Date/gmd:date/gco:DateTime";
        
        public static final String ED = IDENT + "/gmd:citation/gmd:CI_Citation/gmd:edition/gco:CharacterString";

        public static final String EXTENT = IDENT + "/gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox";
        
        public static final String KEYWORDS = IDENT + "/gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword/gco:CharacterString";
        
        public static final String W = EXTENT + "/gmd:westBoundLongitude/gco:Decimal";

        public static final String E = EXTENT + "/gmd:eastBoundLongitude/gco:Decimal";

        public static final String N = EXTENT + "/gmd:northBoundLatitude/gco:Decimal";

        public static final String S = EXTENT + "/gmd:southBoundLatitude/gco:Decimal";

        public static final String SPATIAL_REP = ROOT + "/gmd:spatialRepresentationInfo/gmd:MD_VectorSpatialRepresentation/gmd:geometricObjects/gmd:MD_GeometricObjects";
        
        public static final String OBJECTCOUNT = SPATIAL_REP + "/gmd:geometricObjectCount/gco:Integer";
        
        public static final String OBJECTTYPE = SPATIAL_REP + "/gmd:geometricObjectType";
        
        public static final String OBJECTTYPE_CODE = OBJECTTYPE + "/gmd:MD_GeometricObjectTypeCode";
        
        public static final String OBJECTTYPE_ATTR = "codeListValue";
        
        public static final String BROWSEGRAPHIC = ROOT + "/gmd:graphicOverview/gmd:MD_BrowseGraphic/gmd:fileName/gco:CharacterString";
        
        public static final String ONLINESRC = ROOT + "/gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine/gmd:CI_OnlineResource";
        
        public static final String ONLINESRC_URL = ONLINESRC + "/gmd:linkage/gmd:URL";
        
        public static final String ONLINESRC_PROTOCOL = ONLINESRC + "/gmd:protocol/gco:CharacterString";
        
        public static final String PROTOCOL = "WWW:DOWNLOAD-1.0-http--download";
        
        public static final String ONLINESRC_NAME = ONLINESRC + "/gmd:name/gco:CharacterString";
        
        public static final String ONLINESRC_DESC = ONLINESRC + "/gmd:description/gco:CharacterString";
    }
         
    /** 
     * Class constructor.
     * 
     * @param type         ISO or DCL4G standards
     * @param title        Metadata title
     * @param purpose      Metadata purpose
     * @param abs          Metadata abstract
     * @param topic        Metadata topic (using codelist values from ISO19115)
     * @param template     XML file to be use as template to produce XML output
     * 
     */
    public Metadata(String type, 
                    String title, 
                    String purpose, 
                    String abs, 
                    String topic,
                    String template) {

        /* Generate identifier */
        this.uuid = UUID.randomUUID().toString();
        
        /* Initialize metadata (ie. Load template and set main element) */
        SAXReader reader = new SAXReader();
        try {
            this.xml = reader.read(new java.io.FileInputStream(template));
            // TODO : if invalid template
            List list = this.xml.selectNodes(ISO.ROOT);

            this.setElement(ISO.UUID, this.uuid);
            this.setElement(ISO.TITLE, stringTag(title));
            this.setElement(ISO.ABS, stringTag(abs));
            this.setElement(ISO.PURPOSE, stringTag(purpose));
            this.setElement(ISO.TOPICCATEGORY, topic);

        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }
    
    /** 
     * Replace tags by the corresponding dynamic content.
     * Available tags are:
     * <ul>
     * <li>Date : {DATE} replace by current date (format yyyy-MM-dd)</li>
     * </ul>
     * 
     * @param s         The text to be parsed
     *                  
     * @return          Input text with tags replace by their 
     *                   
     */
    private String stringTag(String s) {
        // Replace {DATE} tag
        java.text.SimpleDateFormat sdfYmd = new java.text.SimpleDateFormat(
                        Metadata.DATE_FORMAT_YMD, 
                        java.util.Locale.US);
        java.util.SimpleTimeZone aZone = new java.util.SimpleTimeZone(8, "GMT");
        sdfYmd.setTimeZone(aZone);
        String t = sdfYmd.format(java.util.Calendar.getInstance().getTime());
        
        String r = s.replaceAll("\\{DATE\\}", t);
        return r;
    }
    

    
    /** 
     * Return metadata identifier
     *  
     * @return          Metadata identifier 
     *                   
     */    
    private String getUuid() {
        return this.uuid;
    }


    public boolean asISO19139() {
        return true;
    }

    public boolean asDCL4G() {
        return true;
    }

    /** 
     * Return xml output for the current metadata.
     *  
     * @return          Xml output 
     *                   
     */    
    public String toString() {
        return this.xml.asXML();
    }

    
    /** 
     * Define dates for the current metadata:
     * <ul>
     * <li>Date stamp: Date that the metadata was created (YYYY-MM-DDThh:mm:ss)</li>
     * <li>Date: Reference date for the cited resource (YYYY-MM-DDThh:mm:ss)</li>
     * </ul>
     *  
     * @return          <code>true</code> 
     *                   
     */    
    public boolean setDateStamp() {
        java.text.SimpleDateFormat sdfYmd = new java.text.SimpleDateFormat(Metadata.DATE_FORMAT_YMD, java.util.Locale.US);
        java.text.SimpleDateFormat sdfTime = new java.text.SimpleDateFormat(Metadata.DATE_FORMAT_TIME, java.util.Locale.US);
        java.util.SimpleTimeZone aZone = new java.util.SimpleTimeZone(8, "GMT");
        sdfYmd.setTimeZone(aZone);
        sdfTime.setTimeZone(aZone);
        String t = sdfYmd.format(java.util.Calendar.getInstance().getTime()) + "T" +
                   sdfTime.format(java.util.Calendar.getInstance().getTime());
        this.setElement(ISO.MDDATE, t);
        this.setElement(ISO.MDCIDATE, t);
        return true;
    }

    /** 
     * Define citation date (type of date is set in template. Default is "creation").
     *  
     * @param date      Date of creation
     *  
     * @return          <code>true</code> 
     *                   
     */    
    public boolean setCI_Date(String date) {
        this.setElement(ISO.MDCIDATE, date);
        
        return true;
    }

    /** 
     * Define CI_ResponsibleParty Individual name.
     *  
     * @param name      Individual name
     *  
     * @return          <code>true</code> 
     *                   
     */    
    public boolean setCI_Contact(String name) {
        this.setElement(ISO.CONTACT, name);
        
        return true;
    }

    /** 
     * Define keywords (type of date is set in template. Default is "").
     *  
     * @param date      keywords
     *  
     * @return          <code>true</code> 
     *                   
     */    
    public boolean setMD_Keywords(String keywords) {
        this.setElement(ISO.KEYWORDS, keywords);
        
        return true;
    }
    
    /** 
     * Define geographic extent in WGS84 of the dataset.
     *  
     * @param w         West
     * @param s         South
     * @param e         East
     * @param n         North
     *  
     * @return          <code>true</code> 
     *                   
     */    
    public boolean setEX_GeographicBoundingBox(Double w, Double s, Double e, Double n) {
        this.setElement(ISO.W, String.valueOf(w));
        this.setElement(ISO.S, String.valueOf(s));
        this.setElement(ISO.E, String.valueOf(e));
        this.setElement(ISO.N, String.valueOf(n));
        
        return true;
    }


    /** 
     * Set the number of object in the current dataset.
     *  
     * @param n         number of objects
     *  
     * @return          <code>true</code> 
     *                   
     */        
    public boolean setGeometricObjectCount(int n) {
        this.setElement(ISO.OBJECTCOUNT, String.valueOf(n));
        return true;
    }
    

    /** 
     * Set the type of geometry in the current dataset (point, curve, surface, ...).
     *  
     * @param type      Geometry type
     *  
     * @return          <code>true</code> 
     *                   
     */        
    public boolean setGeometricObjectType(String type) {
        this.setAttribute(ISO.OBJECTTYPE_CODE, ISO.OBJECTTYPE_ATTR, type);
        return true;
    }
    

    /** 
     * Set thumbnail. 
     *  
     * @param fileName  Thumbnail file name.
     *  
     * @return          <code>true</code> 
     *                   
     */        
    public boolean setBrowseGraphic(String thumbnailName) {
    	this.setElement(ISO.BROWSEGRAPHIC, thumbnailName);
        return true;
    }

    
    /** 
     * Set an online resource pointing to the file. 
     * Protocol is assumed to be Local or LAN file only.
     *  
     * @param file      Path to the file.
     *  
     * @return          <code>true</code> 
     *                   
     */        
    public boolean setOnlineResource(String file) {
    	this.setElement(ISO.ONLINESRC_URL, file);
        this.setElement(ISO.ONLINESRC_PROTOCOL, ISO.PROTOCOL);
        this.setElement(ISO.ONLINESRC_DESC, "File for download");
        this.setElement(ISO.ONLINESRC_NAME, "");
        return true;
    }
    
    /** 
     * Set projection info of the dataset. TODO
     *  
     * @param proj      epsg:XXXX code of the projection.
     *  
     * @return          <code>true</code> 
     *                   
     */        
    public boolean setProj(String proj) {
        /* TODO : proj */
        return true;
    }
    
    /** 
     * Define a value of an XML node in the template.
     *  
     * @param xPath     xPath location of the node.
     * @param value     Text value of the node.
     *  
     * @return          <code>true</code> 
     *                   
     */        
    private boolean setElement(String xPath, String value) {
    	try {
	        List list = this.xml.selectNodes(xPath);
	        Element element = (Element) list.get(0);
	        element.setText(value);
    	} catch (Exception e) {
    		System.err.println ("ERROR: Failed to set " + value + " for " + xPath + ". Check XML template. " + e.getMessage());
    	}
        return true; // TODO : if node not found in template create or alert
    }

    
    
    /** 
     * Define an attribute value of an XML element in the template.
     *  
     * @param xPath     xPath location of the element.
     * @param att       Name of the element's attribute.
     * @param value     Text value of the attribute.
     *  
     * @return          <code>true</code> 
     *                   
     */        
    private boolean setAttribute(String xPath, String att, String value) {
        List list = this.xml.selectNodes(xPath);
        Element element = (Element) list.get(0);
        element.addAttribute(att, value);
        return true; // TODO : if node not found in template create or alert
    }
    
    
    /** 
     * Write the metadata XML tree in an XML file.
     *  
     * @param fileName  Name of the output file.
     * @param encoding  Output Encoding. Default is UTF-8
     *  
     */        
    public void write(String fileName, String encoding) {

        if (encoding == null)
            encoding = "UTF-8";

        OutputFormat fmt = OutputFormat.createPrettyPrint();
        fmt.setEncoding(encoding);

        try {
        	if (!fileName.endsWith(".xml"))
        		fileName = fileName + ".xml";
        	
            XMLWriter xmlWriter = new XMLWriter(new FileWriter(new File(fileName)), fmt);
            xmlWriter.write(this.xml);
            xmlWriter.close();
        } catch (java.io.IOException ioe) {
            ioe.printStackTrace();
        }
    }

}
