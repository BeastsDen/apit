package com.swapswire.dealerexample;

import java.io.IOException;
import java.io.StringReader;

public class SWMLParser {

    private String m_SWML = null;
    private org.w3c.dom.Document m_Doc = null;

    public SWMLParser(String swml) {
        m_SWML = swml;
    }

    protected synchronized org.w3c.dom.Document getSwmlDomDocument() throws ErrorCode {
        if (m_Doc == null && m_SWML != null) {
            try {
                javax.xml.parsers.DocumentBuilderFactory factory = javax.xml.parsers.DocumentBuilderFactory.newInstance();
                factory.setValidating(false);

                // Create the builder and parse the file
                m_Doc = factory.newDocumentBuilder().parse(new org.xml.sax.InputSource(new StringReader(m_SWML)));
            } catch (org.xml.sax.SAXException e) {
                System.err.println(e + "");
            } catch (javax.xml.parsers.ParserConfigurationException e) {
                System.err.println(e + "");
            } catch (IOException e) {
                System.err.println(e + "");
            }
        }
        return m_Doc;
    }

    public String getElementText(String path) throws ErrorCode {
        org.w3c.dom.Document doc = getSwmlDomDocument();
        if (doc == null) {
            System.err.println("No doc!!!");
            return "";
        }

        try {
            javax.xml.xpath.XPathFactory factory = javax.xml.xpath.XPathFactory.newInstance();
            javax.xml.xpath.XPath xpath = factory.newXPath();
            return xpath.evaluate(path, doc);
        } catch (javax.xml.xpath.XPathExpressionException ex) {
            System.err.println(ex + "");
            return "";
        }
    }
}
