<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:lcl="http://www.markitserv.com/local/csv2privateData.xsl"
xmlns:gx="http://www.markitserv.com/generic_xml_tools.xsl"
exclude-result-prefixes="xsl gx">
<xsl:import href="generic_xml_tools.xsl"/>
<xsl:output method="xml" encoding="iso-8859-1" indent="yes"/>
<xsl:variable name="xsl" select="document('')/xsl:stylesheet"/>
<gx:template>
<PrivateData>
<swPrivateTradeId gx:data="internaltradeid"/>
<swTradingBookId gx:data="book"/>
</PrivateData>
</gx:template>
<xsl:template match="/">
<xsl:if test="count($rows) != 1">
<xsl:message terminate="yes">
There should be 1 and only 1 trade record specified
</xsl:message>
</xsl:if>
<xsl:call-template name="gx:start"/>
</xsl:template>
</xsl:stylesheet>
