<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns:cmn="http://exslt.org/common"
xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"
xmlns:fpml="http://www.fpml.org/2010/FpML-4-9"
xmlns:mtc="OTC_Matching_11-0"
xmlns:rm="OTC_RM_11-0"
xmlns:lcl="tiw_position_report_order_parties"
exclude-result-prefixes="xsl xsi cmn lcl env fpml mtc rm lcl">
<xsl:output method="xml" indent="yes"/>
<xsl:template match="@*|node()">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>
<xsl:variable name="lcl:partyMapRSF">
<xsl:variable name="fpmlParties" select="/env:Envelope/env:Body/mtc:OTC_Matching/mtc:Inquiry/mtc:Position/fpml:FpML/fpml:party"/>
<xsl:variable name="positionParties" select="/env:Envelope/env:Body/mtc:OTC_Matching/mtc:Inquiry/mtc:Position/mtc:party"/>
<xsl:for-each select="$fpmlParties | $positionParties">
<xsl:sort select="fpml:partyId"/>
<party id="{@id}">party<xsl:number format="A" value="position()"/></party>
</xsl:for-each>
</xsl:variable>
<xsl:variable name="lcl:partyMap" select="cmn:node-set($lcl:partyMapRSF)/party"/>
<xsl:template name="mapId">
<xsl:variable name="origValue" select="."/>
<xsl:variable name="mappedValue" select="$lcl:partyMap[@id = $origValue]"/>
<xsl:value-of select="$mappedValue | $origValue[not($mappedValue)]"/>
</xsl:template>
<xsl:template match="@href | @id">
<xsl:attribute name="{name()}">
<xsl:call-template name="mapId"/>
</xsl:attribute>
</xsl:template>
<xsl:template match="fpml:partyId/text()">
<xsl:variable name="dtccid">
<xsl:choose>
<xsl:when test="starts-with(., 'DTCC')"><xsl:value-of select="substring(., 5)"/></xsl:when>
<xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:value-of select="$dtccid"/>
</xsl:template>
</xsl:stylesheet>
