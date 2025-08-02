<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:swml="http://www.markitserv.com/swml" xmlns:fpml="http://www.fpml.org/FpML-5/confirmation" exclude-result-prefixes="swml common" version="1.0" xmlns:common="http://exslt.org/common">
<xsl:import href="CrossAssetValidation.xsl"/>
<xsl:import href="swbml-validation-reporting.xsl"/>
<xsl:variable name="SWBML" select="swml:SWBML"/>
<xsl:variable name="swStructuredTradeDetails" select="$SWBML/swml:swStructuredTradeDetails"/>
<xsl:variable name="dataDocument" select="$swStructuredTradeDetails/fpml:dataDocument"/>
<xsl:variable name="trade" select="$dataDocument/fpml:trade"/>
<xsl:variable name="genericProduct" select="$trade/swml:swGenericProduct"/>
<xsl:variable name="reportingData.rtf">
<xsl:apply-templates select="/swml:SWBML/swml:swbTradeEventReportingDetails" mode="mapReportingData"/>
<xsl:apply-templates select="/swml:SWBML/swml:swbPrivatePartyTradeEventReportingDetails" mode="mapReportingData"/>
</xsl:variable>
<xsl:variable name="optionstrike" select="$genericProduct/swml:swOptionStrike"/>
<xsl:variable name="paymentfrequency" select="$genericProduct/swml:swPaymentFrequency"/>
<xsl:variable name="resetfrequency" select="$genericProduct/swml:swResetFrequency"/>
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
<xsl:apply-templates select="swml:SWBML" mode="get-reporting-data"/>
</xsl:template>
<xsl:template match="/swml:SWBML[function-available('common:node-set')]" mode="get-reporting-data">
<xsl:apply-templates select=".">
<xsl:with-param name="reportingData" select="common:node-set($reportingData.rtf)"/>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="/swml:SWBML[not(function-available('common:node-set'))]" mode="get-reporting-data">
<xsl:apply-templates select=".">
<xsl:with-param name="reportingData" select="$reportingData.rtf"/>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="swml:SWBML">
<xsl:param name="reportingData"/>
<xsl:variable name="newContext">
In <xsl:value-of select="local-name()"/>
</xsl:variable>
<results version="1.0">
<xsl:call-template name="swbTradeEventReportingDetails">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
<xsl:with-param name="reportingData" select="$reportingData"/>
</xsl:call-template>
<xsl:apply-templates select="swml:swStructuredTradeDetails">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</results>
</xsl:template>
<xsl:template match="swml:swStructuredTradeDetails">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/swStructuredTradeDetails
</xsl:variable>
<xsl:apply-templates select="fpml:dataDocument">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="swml:swExtendedTradeDetails">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="swml:swbBusinessConductDetails">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:dataDocument">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:apply-templates select="fpml:trade">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="swml:swGenericProduct">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="$optionstrike/swml:swStrikeUnits/text() != 'Price' and string-length($optionstrike/swml:swStrikeCurrency) != 0">
<xsl:variable name="error">
[ERR-VALID-GP-00510] Option Strike Currency not allowed for unit.
</xsl:variable>
<xsl:call-template name="buildErrorData">
<xsl:with-param name="context" select="$newContext"/>
<xsl:with-param name="error" select="$error"/>
</xsl:call-template>
</xsl:if>
<xsl:if test="$optionstrike/swml:swStrikeUnits/text() = 'Price' and string-length($optionstrike/swml:swStrikeCurrency) = 0">
<xsl:variable name="error">
[ERR-VALID-GP-00511] Option Strike Currency cannot be blank
</xsl:variable>
<xsl:call-template name="buildErrorData">
<xsl:with-param name="context" select="$newContext"/>
<xsl:with-param name="error" select="$error"/>
</xsl:call-template>
</xsl:if>
<xsl:for-each select="$genericProduct/swml:swDayCountFraction">
<xsl:if test="string-length(./swml:underlyerReference/@href) = 0">
<xsl:variable name="error">
[ERR-VALID-GP-00516] Underlyer Reference must be specified for the Day Count Convention  [<xsl:value-of select="position()"/>]
</xsl:variable>
<xsl:call-template name="buildErrorData">
<xsl:with-param name="context" select="$context"/>
<xsl:with-param name="error" select="$error"/>
</xsl:call-template>
</xsl:if>
</xsl:for-each>
<xsl:for-each select="$paymentfrequency">
<xsl:if test="string-length(./swml:underlyerReference/@href) = 0">
<xsl:variable name="error">
[ERR-VALID-GP-00512] Underlyer Reference must be specified for the Payment Frequency  [<xsl:value-of select="position()"/>]
</xsl:variable>
<xsl:call-template name="buildErrorData">
<xsl:with-param name="context" select="$context"/>
<xsl:with-param name="error" select="$error"/>
</xsl:call-template>
</xsl:if>
</xsl:for-each>
<xsl:for-each select="$resetfrequency">
<xsl:if test="string-length(./swml:underlyerReference/@href) = 0">
<xsl:variable name="error">
[ERR-VALID-GP-00513] Underlyer Reference must be specified for the Reset Frequency  [<xsl:value-of select="position()"/>]
</xsl:variable>
<xsl:call-template name="buildErrorData">
<xsl:with-param name="context" select="$context"/>
<xsl:with-param name="error" select="$error"/>
</xsl:call-template>
</xsl:if>
</xsl:for-each>
<xsl:variable name="paymentfrequencyperiod" select="$paymentfrequency/fpml:period"/>
<xsl:for-each select="$paymentfrequency/fpml:periodMultiplier">
<xsl:variable name="currentposition" select="position()" />
<xsl:variable name="currentperiod" select="$paymentfrequencyperiod[$currentposition]" />
<xsl:call-template name="isValidAmount">
<xsl:with-param name="elementName">periodMultiplier</xsl:with-param>
<xsl:with-param name="elementValue" select="."/>
<xsl:with-param name="minIncl">1</xsl:with-param>
<xsl:with-param name="maxIncl">999</xsl:with-param>
<xsl:with-param name="maxDecs">0</xsl:with-param>
<xsl:with-param name="context" select="$newContext"/>
</xsl:call-template>
<xsl:call-template name="isValidPeriod">
<xsl:with-param name="elementName">periodMultiplier</xsl:with-param>
<xsl:with-param name="elementValue" select="."/>
<xsl:with-param name="period" select="$currentperiod" />
<xsl:with-param name="context" select="$newContext"/>
</xsl:call-template>
</xsl:for-each>
<xsl:variable name="resetfrequencyperiod" select="$resetfrequency/fpml:period"/>
<xsl:for-each select="$resetfrequency/fpml:periodMultiplier">
<xsl:variable name="currentposition" select="position()" />
<xsl:variable name="currentperiod" select="$resetfrequencyperiod[$currentposition]" />
<xsl:call-template name="isValidAmount">
<xsl:with-param name="elementName">periodMultiplier</xsl:with-param>
<xsl:with-param name="elementValue" select="."/>
<xsl:with-param name="minIncl">1</xsl:with-param>
<xsl:with-param name="maxIncl">999</xsl:with-param>
<xsl:with-param name="maxDecs">0</xsl:with-param>
<xsl:with-param name="context" select="$newContext"/>
</xsl:call-template>
<xsl:call-template name="isValidPeriod">
<xsl:with-param name="elementName">periodMultiplier</xsl:with-param>
<xsl:with-param name="elementValue" select="."/>
<xsl:with-param name="period" select="$currentperiod" />
<xsl:with-param name="context" select="$newContext"/>
</xsl:call-template>
</xsl:for-each>
</xsl:template>
<xsl:template name="isValidPeriod">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="period"/>
<xsl:param name="context"/>
<xsl:if test="$period/text() = 'T' and $elementValue != '1' ">
<xsl:variable name="error">
[ERR-VALID-GP-00512] Period Multiplier must be 1 for Period 'Term' (T). Period Multiplier = [<xsl:value-of select="$elementValue"/>]
</xsl:variable>
<xsl:call-template name="buildErrorData">
<xsl:with-param name="context" select="$context"/>
<xsl:with-param name="error" select="$error"/>
</xsl:call-template>
</xsl:if>
</xsl:template>
<xsl:template match="swml:swExtendedTradeDetails">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:apply-templates select="node()/swml:swbMandatoryClearing">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="swml:swbMandatoryClearing">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="current()[swml:swbJurisdiction/text()!='DoddFrank'][swml:swbSupervisoryBodyCategory]">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** swbSupervisoryBodyCategory not supported for '<xsl:value-of select="swml:swbJurisdiction"/>' clearing</text>
</error>
</xsl:if>
<xsl:if test="current()[swml:swbJurisdiction/text()='MAS' or swml:swbJurisdiction/text()='JFSA' or swml:swbJurisdiction/text()='ASIC'][swml:swbPartyExemption]">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** swbPartyExemption cannot be provided for '<xsl:value-of select="swml:swbJurisdiction"/>'</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="swml:swbBusinessConductDetails">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:apply-templates select="swml:swbMidMarketPrice">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="swml:swbMidMarketPrice">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="swml:swbUnit">
<xsl:choose>
<xsl:when test="swml:swbUnit/text()='Price'"/>
<xsl:when test="swml:swbUnit/text()='BasisPoints'"/>
<xsl:when test="swml:swbUnit/text()='Percentage'"/>
<xsl:when test="swml:swbUnit/text()='Level'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>
*** Invalid value submitted for <xsl:value-of select="local-name()"/>/swml:swbUnit Value = '<xsl:value-of select="swml:swbUnit/text()"/>'.
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test=" swml:swbAmount and (string(number(swml:swbAmount/text())) ='NaN' or contains(swml:swbAmount/text(),'e') or 	contains(swml:swbAmount/text(),'E'))">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>
*** Invalid value submitted for <xsl:value-of select="local-name()"/>/swbAmount Value = '<xsl:value-of select="swml:swbAmount/text()"/>'.
</text>
</error>
</xsl:if>
<xsl:call-template name="isValidAmount">
<xsl:with-param name="elementName">swml:swbAmount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="swml:swbAmount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">-9999999999.99999999</xsl:with-param>
<xsl:with-param name="maxIncl">9999999999.99999999</xsl:with-param>
<xsl:with-param name="maxDecs">8</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:variable name="swbVenueIdScheme">
<xsl:value-of select="swml:swbVenueId/@swbVenueIdScheme"/>
</xsl:variable>
<xsl:if test="$swbVenueIdScheme != 'http://www.fpml.org/coding-scheme/external/cftc/interim-compliant-identifier' and
$swbVenueIdScheme != 'http://www.fpml.org/coding-scheme/external/iso17442' and
$swbVenueIdScheme != ''">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid swbVenueIdScheme.</text>
</error>
</xsl:if>
<xsl:if test="not(string-length(swml:swbUnit) &gt; 0) and (swml:swbCurrency or swml:swbAmount)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***Mid-Market Price Type is required.</text>
</error>
</xsl:if>
<xsl:if test="string-length(swml:swbUnit) &gt; 0 and not (swml:swbCurrency) and not (swml:swbAmount)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***Mid-Market Price Value is required.</text>
</error>
</xsl:if>
<xsl:if test="swml:swbUnit/text() = 'Price' and  swml:swbCurrency and not(swml:swbAmount)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***Mid-Market Price Value is required.</text>
</error>
</xsl:if>
<xsl:if test="not(swml:swbUnit/text() = 'Price') and string-length(swml:swbUnit) &gt; 0 and string-length(swml:swbCurrency) &gt; 0">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***Mid-Market Price Currency not allowed for type.</text>
</error>
</xsl:if>
<xsl:if test=" swml:swbUnit/text()= 'Price' and swml:swbAmount and not(string-length(swml:swbCurrency) &gt; 0)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***Mid-Market Price currency cannot be blank.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template name="isValidAmount">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="minIncl"/>
<xsl:param name="maxIncl"/>
<xsl:param name="maxDecs"/>
<xsl:param name="context"/>
<xsl:if test="string(number($elementValue)) and (string(number($elementValue)) !='NaN' and not(contains($elementValue,'e')) and    not(contains($elementValue,'E')))">
<xsl:if test="number($elementValue) &lt; $minIncl or number($elementValue) &gt; $maxIncl">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>
*** <xsl:value-of select="$elementName"/> is outside allowable range; minIncl=<xsl:value-of select="$minIncl"/>, maxIncl=<xsl:value-of select="$maxIncl"/>. Value = '<xsl:value-of select="$elementValue"/>'.
</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="string-length(substring-after($elementValue,'.')) &gt; $maxDecs">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>
*** <xsl:value-of select="$elementName"/> has too many decimal places; maxDecs=<xsl:value-of select="$maxDecs"/>. Value = '<xsl:value-of select="$elementValue"/>'.
</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template name="buildErrorData">
<xsl:param name="context"/>
<xsl:param name="error"/>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>
<xsl:value-of select="$error"/>
</text>
</error>
</xsl:template>
</xsl:stylesheet>
