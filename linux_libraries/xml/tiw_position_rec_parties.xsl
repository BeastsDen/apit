<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns:cmn="http://exslt.org/common"
xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"
xmlns:fpml="http://www.fpml.org/2010/FpML-4-9"
xmlns:mtc="OTC_Matching_11-0"
xmlns:rm="OTC_RM_11-0"
xmlns:lcl="tiw_position_rec_order_parties"
exclude-result-prefixes="xsl xsi cmn lcl env fpml mtc rm lcl">
<xsl:output method="xml" indent="yes"/>
<xsl:template match="@*|node()">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>
<xsl:template match="/TiwCsvMessage">
<xsl:copy>
<partyAId>
<xsl:call-template name="fix_ac_id">
<xsl:with-param name="id_in"><xsl:value-of select="$lcl:partyMap[text()='partyA']/@id"/></xsl:with-param>
</xsl:call-template>
</partyAId>
<partyBId>
<xsl:call-template name="fix_ac_id">
<xsl:with-param name="id_in"><xsl:value-of select="$lcl:partyMap[text()='partyB']/@id"/></xsl:with-param>
</xsl:call-template>
</partyBId>
<xsl:apply-templates/>
</xsl:copy>
</xsl:template>
<xsl:variable name="lcl:partyMapRSF">
<xsl:for-each select="/TiwCsvMessage/DTCC_ACCOUNT_NUMBER | /TiwCsvMessage/CTPY_ACCOUNT_NUMBER">
<xsl:sort select="text()"/>
<party id="{text()}">party<xsl:number format="A" value="position()"/></party>
</xsl:for-each>
</xsl:variable>
<xsl:variable name="lcl:partyMap" select="cmn:node-set($lcl:partyMapRSF)/party"/>
<xsl:template name="mapId">
<xsl:variable name="origValue" select="."/>
<xsl:variable name="mappedValue" select="$lcl:partyMap[@id = $origValue]"/>
<xsl:value-of select="$mappedValue | $origValue[not($mappedValue)]"/>
</xsl:template>
<xsl:template match="text()">
<xsl:call-template name="mapId"/>
</xsl:template>
<xsl:template name="fix_ac_id">
<xsl:param name="id_in"/>
<xsl:choose>
<xsl:when test="starts-with($id_in, 'DTCC')"><xsl:value-of select="substring($id_in, 5)"/></xsl:when>
<xsl:otherwise><xsl:value-of select="$id_in"/></xsl:otherwise>
</xsl:choose>
</xsl:template>
</xsl:stylesheet>
