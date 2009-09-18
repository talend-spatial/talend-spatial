/*
 *    GeoTools - OpenSource mapping toolkit
 *    http://geotools.org
 *    (C) 2005-2006, GeoTools Project Managment Committee (PMC)
 * 
 *    This library is free software; you can redistribute it and/or
 *    modify it under the terms of the GNU Lesser General Public
 *    License as published by the Free Software Foundation;
 *    version 2.1 of the License.
 *
 *    This library is distributed in the hope that it will be useful,
 *    but WITHOUT ANY WARRANTY; without even the implied warranty of
 *    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *    Lesser General Public License for more details.
 */
package org.geotools.data.mif;

import com.vividsolutions.jts.io.ParseException;
import junit.framework.TestCase;
import junit.framework.TestSuite;


/**
 * DOCUMENT ME!
 *
 * @author Luca S. Percich, AMA-MI
 * @source $URL: http://svn.geotools.org/geotools/tags/2.3.5/plugin/mif/test/org/geotools/data/mif/MIFStringTokenizerTest.java $
 */
public class MIFStringTokenizerTest extends TestCase {
    private MIFStringTokenizer tok = null;

    /**
     * DOCUMENT ME!
     *
     * @param args DOCUMENT ME!
     *
     * @throws Exception DOCUMENT ME!
     */
    public static void main(java.lang.String[] args) throws Exception {
        junit.textui.TestRunner.run(new TestSuite(MIFStringTokenizerTest.class));
    }

    /**
     * DOCUMENT ME!
     *
     * @throws Exception DOCUMENT ME!
     */
    protected void setUp() throws Exception {
        super.setUp();
        tok = new MIFStringTokenizer();
    }

    /**
     * DOCUMENT ME!
     *
     * @throws Exception DOCUMENT ME!
     */
    protected void tearDown() throws Exception {
        tok = null;
        super.tearDown();
    }

    /*
     * Class under test for boolean readLine(String)
     */
    public void testReadLineString() {
        assertEquals(false, tok.readLine(""));
        assertEquals(true, tok.readLine("foo"));
    }

    /*
     * Class under test for boolean readLine()
     */
    public void testReadLine() {
        assertEquals(false, tok.readLine());
    }

    /*
     * Class under test for String getToken(char, boolean, boolean)
     */
    public void testGetTokencharbooleanboolean() {
        tok.readLine("\"foo bar\" next");

        try {
            assertEquals("foo bar", tok.getToken(' ', false, true));
        } catch (ParseException e) {
            fail(e.getMessage());
        }
    }

    /*
     * Class under test for String getToken(char, boolean, boolean)
     */
    public void testGetTokencharbooleanbooleanInQuote() {
    	tok.readLine("\"foo \"quote inside quoted string\" bar\",next");

        try {
    	    assertEquals("foo \"quote inside quoted string\" bar", tok.getToken(',', false, true));
        } catch (ParseException e) {
            fail(e.getMessage());
        }
    }
    
    /*
     * Class under test for String getToken(char, boolean, boolean)
     */
    public void testGetTokencharbooleanbooleanInQuoteEnd() {
    	tok.readLine("\"foo \"quote inside quoted string\"\"");

        try {
    	    assertEquals("foo \"quote inside quoted string\"", tok.getToken(',', false, true));
        } catch (ParseException e) {
            fail(e.getMessage());
        }
    }
    
    /*
     * Class under test for String getToken(char, boolean)
     */
    public void testGetTokencharboolean() {
        tok.readLine("foo bar");

        try {
            assertEquals("foo", tok.getToken(' ', true));
        } catch (ParseException e) {
            fail(e.getMessage());
        }
    }

    /*
     * Class under test for String getToken(char)
     */
    public void testGetTokenchar() {
        tok.readLine("foo bar");

        try {
            assertEquals("foo", tok.getToken(' '));
        } catch (ParseException e) {
            fail(e.getMessage());
        }
    }

    /*
     * Class under test for String getToken()
     */
    public void testGetToken() {
        tok.readLine("foo bar");

        try {
            assertEquals("foo", tok.getToken());
        } catch (ParseException e) {
            fail(e.getMessage());
        }
    }

    /**
     * DOCUMENT ME!
     */
    public void testStrQuote() {
        assertEquals("\"an \"\"unquoted\"\" string\"",
            MIFStringTokenizer.strQuote("an \"unquoted\" string"));
    }

    /**
     * DOCUMENT ME!
     */
    public void testStrUnquote() {
    	
        assertEquals("simple", MIFStringTokenizer.strUnquote("\"simple\""));
        assertEquals("a \"quoted\" string",
            MIFStringTokenizer.strUnquote("\"a \"\"quoted\"\" string\""));
    }

    /**
     * DOCUMENT ME!
     */
    public void testLtrim() {
        assertEquals("string", MIFStringTokenizer.ltrim("   string"));
    }

    /**
     * DOCUMENT ME!
     */
    public void testGetLine() {
        tok.readLine("foo");
        assertEquals("foo", tok.getLine());
    }

    /**
     * DOCUMENT ME!
     */
    public void testIsEmpty() {
        tok.readLine("foo");
        assertEquals(false, tok.isEmpty());

        tok.readLine();
        assertEquals(true, tok.isEmpty());
    }
}
