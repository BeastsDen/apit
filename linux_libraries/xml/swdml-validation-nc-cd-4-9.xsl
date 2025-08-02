<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fpml="http://www.fpml.org/2010/FpML-4-9" exclude-result-prefixes="fpml common" version="1.0" xmlns:common="http://exslt.org/common">
<xsl:import href="CrossAssetValidation.xsl"/>
<xsl:import href="swdml-validation-reporting.xsl"/>
<xsl:output method="xml"/>
<xsl:variable name="reportingData.rtf">
<xsl:apply-templates select="/fpml:SWDML/fpml:swTradeEventReportingDetails" mode="mapReportingData"/>
</xsl:variable>
<xsl:template match="fpml:swAllocation" mode="mapReportingData">
<swAllocation>
<xsl:apply-templates select="fpml:swAllocationReportingDetails" mode="mapReportingData"/>
</swAllocation>
</xsl:template>
<xsl:template match="/|comment()|processing-instruction()" mode="mapReportingData">
<xsl:copy>
<xsl:apply-templates mode="mapReportingData"/>
</xsl:copy>
</xsl:template>
<xsl:template match="*" mode="mapReportingData">
<xsl:element name="{local-name()}">
<xsl:apply-templates select="@*|node()" mode="mapReportingData"/>
</xsl:element>
</xsl:template>
<xsl:template match="@*" mode="mapReportingData">
<xsl:attribute name="{local-name()}">
<xsl:value-of select="."/>
</xsl:attribute>
</xsl:template>
<xsl:template match="/">
<xsl:apply-templates select="fpml:SWDML" mode="get-reporting-data"/>
</xsl:template>
<xsl:template match="/fpml:SWDML[function-available('common:node-set')]" mode="get-reporting-data">
<xsl:apply-templates select=".">
<xsl:with-param name="reportingData" select="common:node-set($reportingData.rtf)"/>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="/fpml:SWDML[not(function-available('common:node-set'))]" mode="get-reporting-data">
<xsl:apply-templates select=".">
<xsl:with-param name="reportingData" select="$reportingData.rtf"/>
</xsl:apply-templates>
</xsl:template>
<xsl:variable name="version">
<xsl:value-of select="/fpml:SWDML/@version"/>
</xsl:variable>
<xsl:template match="fpml:SWDML">
<xsl:param name="reportingData"/>
<xsl:variable name="newContext">In <xsl:value-of select="local-name()"/>
</xsl:variable>
<results version="1.0">
<xsl:if test="not($version='4-9')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid version attribute. Value = '<xsl:value-of select="$version"/>'.</text>
</error>
</xsl:if>
<xsl:call-template name="swTradeEventReportingDetails">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
<xsl:with-param name="reportingData" select="$reportingData"/>
</xsl:call-template>
</results>
</xsl:template>
</xsl:stylesheet>
