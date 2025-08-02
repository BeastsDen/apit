<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:lcl="http://www.markitserv.com/local/csv2exercise.xsl"
xmlns:gx="http://www.markitserv.com/generic_xml_tools.xsl"
xmlns=""
exclude-result-prefixes="lcl gx xsl">
<xsl:import href="generic_xml_tools.xsl"/>
<xsl:output method="xml" encoding="iso-8859-1" indent="yes"/>
<xsl:variable name="xsl" select="document('')/xsl:stylesheet"/>
<xsl:namespace-alias stylesheet-prefix="gx" result-prefix="#default"/>
<xsl:namespace-alias stylesheet-prefix="lcl" result-prefix="#default"/>
<gx:template>
<Exercise>
<Swaption>
<swaptionExerciseType>
<cashExercise>
<settlementRate         gx:data="settlementrate"/>
<settlementPayment      gx:requires="addpayamount">
<amount             gx:data="addpayamount"/>
<amountCurrency     gx:data="addpaycurrency"/>
<date               gx:data="addpaydate"
gx:format="date"/>
<businessConvention gx:data="addpayconvention"/>
<businessCenters>
<businessCenter gx:data="addpayholidays"
gx:split=";"/>
</businessCenters>
</settlementPayment>
</cashExercise>
<physicalExercise>
<createAffirmReleaseSwap
gx:data="createaffirmreleaseswap"
gx:format="boolean"/>
<book            gx:data="swapbook"/>
<firstFixingRate gx:data="firstfixingrate"/>
</physicalExercise>
</swaptionExerciseType>
<straddleType            gx:data="straddle"/>
</Swaption>
</Exercise>
</gx:template>
<xsl:template match="swaptionExerciseType">
<xsl:param name="row"/>
<xsl:element name="{local-name()}" namespace="{namespace-uri()}">
<xsl:variable
name="optionSettlement"
select="$row/data[@name = 'optionsettlement']"/>
<xsl:if test="not($optionSettlement[. = 'Cash' or . = 'Physical'])">
<xsl:message terminate="yes">
OptionSettlement type "<xsl:value-of select="$optionSettlement"/>" unknown. Valid values are "Cash" or "Physical".
</xsl:message>
</xsl:if>
<xsl:apply-templates
select="cashExercise[$optionSettlement = 'Cash'] |
physicalExercise[$optionSettlement = 'Physical']">
<xsl:with-param name="row" select="$row"/>
</xsl:apply-templates>
</xsl:element>
</xsl:template>
<xsl:template match="/">
<xsl:if test="count($rows) != 1">
<xsl:message terminate="yes">
There should be 1 and only 1 exercise record specified.
</xsl:message>
</xsl:if>
<xsl:call-template name="gx:start"/>
</xsl:template>
</xsl:stylesheet>
