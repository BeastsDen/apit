<?xml version="1.0"?>
<xsl:stylesheet
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:fpml="http://www.fpml.org/2005/FpML-4-2"
xmlns:common="http://exslt.org/common"
exclude-result-prefixes="fpml common"
version="1.0">
<xsl:import href="swdml-validation-ird-4-2.xsl"/>
<xsl:param name="index" select="1"/>
<xsl:output method="xml"/>
<xsl:variable name="SWDML"                     select="/fpml:NettingInstruction"/>
<xsl:variable name="version"                   select="'4-2'"/>
<xsl:variable name="swLongFormTrade"           select="/fpml:NettingInstruction"/>
<xsl:variable name="swStructuredTradeDetails"  select="$SWDML/fpml:swNewPosition[$index]"/>
<xsl:variable name="nettingBatchId"            select="$SWDML/fpml:swHeader/fpml:swNettingBatchId"/>
<xsl:variable
name="privateClearingTradeID"
select="$trade/fpml:tradeHeader/fpml:partyTradeIdentifier[
fpml:partyReference/@href='partyA']/fpml:tradeId"/>
<xsl:template match="/fpml:NettingInstruction">
<xsl:param name="reportingData"/>
<xsl:variable name="newContext">In <xsl:value-of select="local-name()"/>
</xsl:variable>
<results version="1.0">
<xsl:if test="not($version='4-2')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid version attribute. Value = '<xsl:value-of select="$version"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not($swShortFormTrade or $swLongFormTrade)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swShortFormTrade or swLongFormTrade element. Required in this context.</text>
</error>
</xsl:if>
<xsl:apply-templates select="$swStructuredTradeDetails">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
<xsl:with-param name="reportingData" select="$reportingData"/>
</xsl:apply-templates>
</results>
</xsl:template>
<xsl:template match="fpml:swNewPosition">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:call-template name="isValidProductType">
<xsl:with-param name="elementName">swProductType</xsl:with-param>
<xsl:with-param name="elementValue" select="fpml:swProductType"/>
<xsl:with-param name="context" select="$newContext"/>
</xsl:call-template>
<xsl:apply-templates select="fpml:FpML">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:swOfflineTrade">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:swExtendedTradeDetails">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:swBusinessConductDetails">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
</xsl:stylesheet>
