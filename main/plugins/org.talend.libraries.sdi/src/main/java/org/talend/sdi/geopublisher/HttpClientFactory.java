package org.talend.sdi.geopublisher;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.UsernamePasswordCredentials;
import org.apache.commons.httpclient.auth.AuthScope;

/**
 * Instances of this class are factories for creating http clients.
 *
 * @author Éric Lemoine, Camptocamp France SAS
 */
public class HttpClientFactory {
    final String username;
    final String password;

    /**
     * Constructs an HTTP client factory.
     *
     * @param username          the username to set in the HTTP credentials
     * @param password          the password to set in the HTTP credentials
     */
    public HttpClientFactory(String username, String password) {
        this.username = username;
        this.password = password;
    }

    /**
     * Returns an HTTP client whose credentials include the username
     * and password passed to the factory constructor.
     *
     * @return                  the HTTP client.
     */
    public HttpClient newHttpClient() {
        final HttpClient c = new HttpClient();
        c.getState().setCredentials(
            new AuthScope(AuthScope.ANY_HOST, AuthScope.ANY_PORT),
            new UsernamePasswordCredentials(username, password)
        );
        return c;
    }
}
