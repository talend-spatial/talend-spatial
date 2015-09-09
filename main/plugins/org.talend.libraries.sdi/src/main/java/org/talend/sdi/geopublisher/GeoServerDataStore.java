package org.talend.sdi.geopublisher;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.methods.PutMethod;
import org.apache.commons.httpclient.methods.DeleteMethod;
import org.apache.commons.httpclient.methods.GetMethod;
import org.apache.commons.httpclient.methods.InputStreamRequestEntity;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

/**
 * Instances of this class represent GeoServer data stores. This
 * class uses GeoServer's management HTTP APIs for creating, updating
 * and deleting a data store.
 *
 * @author Éric Lemoine, Camptocamp France SAS
 */
public class GeoServerDataStore {

    private final String url;
    private final HttpClientFactory httpClientFactory;

    /**
     * Constructs a representation of a data store.
     *
     * @param httpClientFactory         the HTTP client factory to use for
     *                                  constructing HTTP clients
     * @param baseURL                   the URL to the GeoServer management
     *                                  service
     * @param ds                        the name of the data store
     * @param ws                        the namespace
     */
    public GeoServerDataStore(final HttpClientFactory httpClientFactory,
                       final String baseURL,
                       final String ds,
                       final String ws) {
        this.httpClientFactory = httpClientFactory;
        this.url = baseURL +
             "/workspaces/" + ws + "/datastores/" + ds;
    }

    /**
     * Creates a data store in GeoServer from a Shapefile.
     *
     * @param f                         the Shapefile
     * @throws IOException              thrown if the status code of the GeoServer
     *                                  response is not 201
     */
    public void create(File f) throws IOException {
        final HttpClient c = httpClientFactory.newHttpClient();
        String uri = this.url + "/file.shp";
        final PutMethod m = new PutMethod(uri);
        m.setRequestEntity(new InputStreamRequestEntity(new FileInputStream(f)));
        m.setRequestHeader("Content-type", "application/zip");
        m.setDoAuthentication(true);
        int status = c.executeMethod(m);
        if (status != 201) {
            throw new IOException("got status code " + status);
        }
    }

    /**
     * Gets the XML representation of the data store from GeoServer.
     *
     * @return                          the XML representation
     * @throws IOException              thrown if the status code of the GeoServer
     *                                  response is not 200
     */
    public String read() throws IOException {
        final HttpClient c = httpClientFactory.newHttpClient();
        final GetMethod m = new GetMethod(this.url + ".xml");
        m.setDoAuthentication(true);
        int status = c.executeMethod(m);
        if (status != 200) {
            throw new IOException("got status code " + status);    
        }
        return m.getResponseBodyAsString();
    }

    /**
     * Updates a data store in GeoServer from a Shapefile.
     *
     * @param f                         the Shapefile
     * @throws IOException              thrown if the status code of the GeoServer
     *                                  response is not 201
     */
    public void update(File f) throws IOException {
        create(f);
    }

    /**
     * Deletes a data store from GeoServer, the method deletes the feature type
     * first and then the data store.
     *
     * @param ft                        the name of the data store to delete
     * @throws IOException              throws if the status code of the GeoServer
     *                                  response is not 200 when deleting the
     *                                  coverage or the coverage store
     */
    public void delete(String ft) throws IOException {
        int status;
        HttpClient c;
        DeleteMethod m;
        String info = "";
        
        // delete layers
        c = httpClientFactory.newHttpClient();
        m = new DeleteMethod(this.url + "/layers/" + ft);
        m.setDoAuthentication(true);
        status = c.executeMethod(m);
        if (status != 200) {
            info += "Layers|got status code " + status;
        }
        // delete feature type
        c = httpClientFactory.newHttpClient();
        m = new DeleteMethod(this.url + "/featuretypes/" + ft);
        m.setDoAuthentication(true);
        status = c.executeMethod(m);
        if (status != 200) {
            info += "\nFeatureType|got status code " + status;
        }
        // delete data store
        c = httpClientFactory.newHttpClient();
        m = new DeleteMethod(this.url);
        m.setDoAuthentication(true);
        status = c.executeMethod(m);
        if (status != 200) {
        	info += "\nDataStore|got status code " + status;
            throw new IOException(info);
        }
    }

    /**
     * Deletes a data store from GeoServer, the method deletes the feature type
     * first and then the data store.
     *
     * @param f                         the file representing the data store
     * @throws IOException              throws if the status code of the GeoServer
     *                                  response is not 200 when deleting the
     *                                  coverage or the coverage store
     */
    public void delete(File f) throws IOException {
        String ft = f.getName().substring(0, f.getName().lastIndexOf("."));
        delete(ft);
    }

    public static void main(String[] args) throws Exception {
        String shp      = "/tmp/tasmania_cities.zip";
        String ds       = "datastore_test";
        String ws       = "topp";
        String url      = "http://localhost:8080/geoserver/rest";
        String username = "admin";
        String password = "geoserver";

        HttpClientFactory httpClientFactory = new HttpClientFactory(username, password);

        File f = new File(shp);
        GeoServerDataStore p = new GeoServerDataStore(
            httpClientFactory, url, ds, ws
        );

        String xml;

        p.create(f);
        xml = p.read();
        System.out.println(xml);
        p.update(f);
        xml = p.read();
        System.out.println(xml);
        p.delete(f);
        try {
            xml = p.read();
        } catch(IOException e) {
        }
    }	
}