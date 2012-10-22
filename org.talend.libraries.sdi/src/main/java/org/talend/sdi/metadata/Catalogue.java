package org.talend.sdi.metadata;

import java.io.IOException;

import org.apache.commons.httpclient.Credentials;
import org.apache.commons.httpclient.Header;
import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpException;
import org.apache.commons.httpclient.HttpStatus;
import org.apache.commons.httpclient.UsernamePasswordCredentials;
import org.apache.commons.httpclient.auth.AuthScope;
import org.apache.commons.httpclient.methods.PostMethod;
import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.DocumentHelper;

/**
 * Catalogue is the abstract base class for all catalogue.
 * 
 * @author      Fxp
 * @version     
 */
public abstract class Catalogue {

    /**
     * Host name or IP adresse of the catalogue 
     */
    public String host;

    /**
     * Port number 
     */
    public int port;

    /**
     * Username to log into the catalogue 
     */
    public String username;

    /**
     * Password to log into the catalogue 
     */
    public String password;

    /**
     * Username to be used if Basic Authentication is required 
     */
    public String baUsername;

    /**
     * Password to be used if Basic Authentication is required 
     */
    public String baPassword;

    /**
     * Proxy url 
     */
    public String proxyURL;
    
    /**
     * Proxy port 
     */
    public int proxyPort;
    
    /**
     * Proxy username
     */
    public String proxyUsername;

    /**
     * Proxy password
     */
    public String proxyPassword;

    /** 
     * Class constructor.
     */
    public Catalogue() {
    }


    /** 
     * Return Catalogue type
     *                  
     * @return          Abstract 
     *                   
     */
    public String getType() {
        return "Abstract";
    }

    /** 
     * Create an http connection in order to execute a request.
     * If needed, Basic Authentication and Proxy configuration are defined here.
     * 
     * @param httpclient   HTTP client which store the session info
     * @param req          Request  
     *                  
     * @return          Document returned by request (eg. xml document, html page, ...) 
     *                   
     */
    public Document httpConnect (HttpClient httpclient, PostMethod req) {
        Document doc = null;
        Credentials creds = null;
        
        // Basic Authentification initialisation
        if (this.baUsername != null && this.baPassword != null) {
            creds = new UsernamePasswordCredentials(this.baUsername, this.baPassword);
            httpclient.getState().setCredentials(AuthScope.ANY, creds);
        }

        // Proxy initialisation
        if (this.proxyURL != null) {
            // TODO 
        }
        
        try {
            // Connect
            int result = httpclient.executeMethod(req);
            String redirectLocation;
            Header locationHeader = req.getResponseHeader("location");
            if (locationHeader != null) {
                redirectLocation = locationHeader.getValue();
                req.setPath(redirectLocation);
                result = httpclient.executeMethod(req);
            }
            if (result == HttpStatus.SC_OK) {
            	// Convert response to xml
            	doc = DocumentHelper.parseText(req.getResponseBodyAsString ());
            } else
            	System.err.println ("org.talend.sdi.metadata.Catalogue | Bad status : " + result);
            
            
        } catch (DocumentException e){
            System.err.println("org.talend.sdi.metadata.Catalogue | Invalid XML Document '" + e.getMessage() + "'");
        } catch (HttpException he) {
            System.err.println("org.talend.sdi.metadata.Catalogue | Http error connecting to '" + this.host+":"+this.port + "'");
            System.err.println(he.getMessage());
            System.exit(-4);
        } catch (IOException ioe){
            System.err.println("org.talend.sdi.metadata.Catalogue | Unable to connect to '" + this.host+":"+this.port + "'");
            System.exit(-3);
        } finally {
            // Release current connection to the connection pool once you are done
            req.releaseConnection();
        }
        return doc;
    }

}
