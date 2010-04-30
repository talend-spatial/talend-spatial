package org.talend.sdi.metadata;

import java.util.List;

import java.io.File;
import java.io.IOException;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpException;
import org.apache.commons.httpclient.params.HttpMethodParams;
import org.apache.commons.httpclient.methods.multipart.MultipartRequestEntity;
import org.apache.commons.httpclient.methods.multipart.FilePart;
import org.apache.commons.httpclient.methods.multipart.Part;
import org.apache.commons.httpclient.methods.PostMethod;
import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.DocumentException;
import org.dom4j.Element;


/**
 * GeoNetwork is used to interact with a GeoNetwork catalogue.
 * It allows login, logout and metadata insert action.
 * 
 * @author      Fxp
 */
public class GeoNetwork extends Catalogue {

    /**
     * Node name (ie. GeoNetwork servlet name) 
     */
    private String servlet;

    /**
     * GeoNetwork Service type 
     */
    public class Service {

        public static final String XML_LOGIN = "xml.user.login";

        public static final String XML_LOGOUT = "xml.user.logout";

        public static final String MEF_IMPORT = "mef.import";

        public static final String XML_PUT = "xml.metadata.insert";
    }

    /** 
     * Class constructor.
     * 
     * @param host         GeoNetwork host name or IP adresse
     * @param port         GeoNetwork port number.
     * @param servlet      Name of the GeoNetwork node.    
     * @param username     Username to log into the node. 
     *      This parameter is mandatory because generally xml metadata insert 
     *      is not allowed without authentification.
     * @param password     Password to log into the node.
     * 
     */
    public GeoNetwork(String host, int port, String servlet, String username, String password) {
        this.host = host;
        this.port = port;
        this.servlet = servlet;
        this.username = username;
        this.password = password;
    }

    /** 
     * Return Catalogue type
     *                  
     * @return          GeoNetwork 
     *                   
     */
    public String getType() {
        return "GeoNetwork";
    }

    /** 
     * Log in a GeoNetwork node
     *           
     * @param httpclient   HTTP client which store the session info
     * @param username     GeoNetwork Username  
     * @param password     GeoNetwork Password  
     *                   
     */
    private void authenticate(HttpClient httpclient, 
                                String username, 
                                String password) throws Exception {
        
        /* Login URL & parameters */
        PostMethod req = new PostMethod(
                this.host + ":" + this.port + "/" + 
                this.servlet + "/srv/en/" + Service.XML_LOGIN);
        
        req.addParameter("username", username);
        req.addParameter("password", password);
        
        /* Connect & Check ok */
        Document doc = httpConnect (httpclient, req);
        
        if (!doc.node(0).getName().equals("ok"))
            throw new Exception ("org.talend.sdi.metadata.GeoNetwork | Authentification failed for " + username);
        else
            System.out.println ("org.talend.sdi.metadata.GeoNetwork | Connected to GeoNetwork.");
       
    }

    /** 
     * Publish a metadata in a GeoNetwork node
     *           
     * @param xml           XML document representing the metadata
     * @param schema        Type of schema corresponding to the document     
     * @param groupId       Id of the group to be use in GeoNetwork. 
     *      Default is "2" = Usually GeoNetwork sample group. Check the value with the catalogue administrator.
     * @param categoryId    Id of the category to be use in GeoNetwork. 
     *      Default is "2" = Usually GeoNetwork datasets category. Check the value with the catalogue administrator.
     *                   
     */
    public boolean publish(String xml, String schema, String groupType, String groupId, String categoryId) {

        try {
            HttpClient httpclient = new HttpClient ();
            
            // --- do we need to authenticate?
            if (this.username != null)
                authenticate(httpclient, this.username, this.password);
            
            // --- Post xml metadata element
            PostMethod req = new PostMethod(
                    this.host + ":" + this.port + "/" + 
                    this.servlet + "/srv/en/" + Service.XML_PUT);
            
            
            req.addParameter("data", xml);
            req.addParameter("template", "n");
            req.addParameter("title", "");
            req.addParameter("styleSheet", "_none_");
            req.addParameter("schema", schema);
            req.addParameter("validate", "off");
            
            if (groupType.equals("0") || groupType.equals("1"))
            	req.addParameter("group", groupType); // GeoNetwork intranet and internet group
            else if (groupType.equals("99")) 
            	req.addParameter("group", groupId);
            else
                req.addParameter("group", "2"); // Usually GeoNetwork sample group
            
            
            if (categoryId == null)
                req.addParameter("category", "2"); // Usually GeoNetwork datasets category
            else
                req.addParameter("category", categoryId);


            /* Check if error on publication */
            Document doc = httpConnect (httpclient, req);
            List list = doc.selectNodes("response");

            if (list.size() == 0)
                System.out.println ("org.talend.sdi.metadata.GeoNetwork | Publication failed");
            else{
                Element root = (Element) list.get(0);    
                System.out.println ("org.talend.sdi.metadata.GeoNetwork | Publication ok (Metadata id = " + root.node(1).getText() + ")");
            }
                
        } catch (Exception e) {
            System.err.println(e.getMessage());
        }

        return true;
    }


    /** 
     * Publish a MEF document in a GeoNetwork node
     *           
     * @param mef           MEF document 
     *                   
     */
    public boolean publishMEF(String mef) {

        try {
            HttpClient httpclient = new HttpClient ();
           
            // --- do we need to authenticate?
            if (this.username != null)
                authenticate(httpclient, this.username, this.password);
            
            
            // --- Post xml metadata element
            PostMethod req = new PostMethod(
                    this.host + ":" + this.port + "/" + 
                    this.servlet + "/srv/en/" + Service.MEF_IMPORT);
            
            File mefFile = new File(mef);
            
            Part[] parts = {
            		new FilePart ("mefFile", mefFile)
            };
            
            
            req.getParams().setBooleanParameter(
            		HttpMethodParams.USE_EXPECT_CONTINUE, true);
            //req.addParameter("mefFile", mefFile.getName());
            
            req.setRequestEntity(
            		new MultipartRequestEntity (
            				parts, 
            				req.getParams()
            			)
            		);
            
            /* Check if error on publication */
            Document doc = httpConnect (httpclient, req);
            List list = doc.selectNodes("ok");

            if (list.size() == 0)
                System.out.println ("org.talend.sdi.metadata.GeoNetwork | MEF publication failed");
            else{
                Element root = (Element) list.get(0);    
                // mef.import response (<ok>id blabla</ok>) is slightly different from xml.insert in GeoNetwork (<response><id></id></response>)
                System.out.println ("org.talend.sdi.metadata.GeoNetwork | MEF publication ok (Metadata id = " + root.getText() + ")");
            }
                
        } catch (Exception e) {
            System.err.println(e.getMessage());
        }

        return true;
    }


}
