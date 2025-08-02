<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fpml49="http://www.fpml.org/2010/FpML-4-9" exclude-result-prefixes="fpml49">
<xsl:output method="xml"/>
<xsl:variable name="CFTCIssuerIdScheme">http://www.fpml.org/coding-scheme/external/cftc/issuer-identifier</xsl:variable>
<xsl:variable name="LEIScheme">http://www.fpml.org/coding-scheme/external/iso17442</xsl:variable>
<xsl:variable name="supportedRegimes">
<xsl:text>DoddFrank, JFSA, ESMA, HKMA, ASIC, CAN, SEC, MIFID, MAS, FCA</xsl:text>
</xsl:variable>
<xsl:variable name="dfJurisdiction">
<xsl:text>DoddFrank</xsl:text>
</xsl:variable>
<xsl:variable name="jfsaJurisdiction">
<xsl:text>JFSA</xsl:text>
</xsl:variable>
<xsl:variable name="esmaJurisdiction">
<xsl:text>ESMA</xsl:text>
</xsl:variable>
<xsl:variable name="hkmaJurisdiction">
<xsl:text>HKMA</xsl:text>
</xsl:variable>
<xsl:variable name="caJurisdiction">
<xsl:text>CAN</xsl:text>
</xsl:variable>
<xsl:variable name="seJurisdiction">
<xsl:text>SEC</xsl:text>
</xsl:variable>
<xsl:variable name="miJurisdiction">
<xsl:text>MIFID</xsl:text>
</xsl:variable>
<xsl:variable name="masJurisdiction">
<xsl:text>MAS</xsl:text>
</xsl:variable>
<xsl:variable name="asicJurisdiction">
<xsl:text>ASIC</xsl:text>
</xsl:variable>
<xsl:variable name="fcaJurisdiction">
<xsl:text>FCA</xsl:text>
</xsl:variable>
<xsl:variable name="productType">
<xsl:value-of select="/fpml49:SWDML/fpml49:swLongFormTrade/fpml49:swStructuredTradeDetails/fpml49:swProductType"/>
</xsl:variable>
<xsl:template name="swTradeEventReportingDetails">
<xsl:param name="context"/>
<xsl:param name="reportingData"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/swTradeEventReportingDetails</xsl:variable>
<xsl:call-template name="reportingAssertion">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
<xsl:with-param name="reportingData" select="$reportingData"/>
</xsl:call-template>
<xsl:apply-templates select="$reportingData/swTradeEventReportingDetails/node()" mode="reportingFields">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
<xsl:with-param name="reportingData" select="$reportingData"/>
</xsl:apply-templates>
</xsl:template>
<xsl:template name="swAllocationReportingDetails">
<xsl:param name="context"/>
<xsl:param name="reportingData"/>
<xsl:param name="allocationNum"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:apply-templates select="$reportingData/swAllocation[position()=$allocationNum]/swAllocationReportingDetails" mode="reportingFields">
<xsl:with-param name="context">
<xsl:value-of select="$context"/>
</xsl:with-param>
<xsl:with-param name="reportingData" select="$reportingData"/>
</xsl:apply-templates>
</xsl:template>
<xsl:template name="swNovationExecutionUniqueTransactionId">
<xsl:param name="context"/>
<xsl:param name="reportingData"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:apply-templates select="$reportingData/swNovationExecutionUniqueTransactionId" mode="reportingFields">
<xsl:with-param name="context">
<xsl:value-of select="$context"/>
</xsl:with-param>
<xsl:with-param name="reportingData" select="$reportingData"/>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="swJurisdiction" mode="reportingFields">
<xsl:param name="context"/>
<xsl:param name="reportingData"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="contains(normalize-space($supportedRegimes), normalize-space(text()))"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid value submitted for <xsl:value-of select="local-name()"/>.Value = '<xsl:value-of select="text()"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template match="swSupervisoryBodyCategory" mode="reportingFields">
<xsl:param name="context"/>
<xsl:param name="reportingData"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="text()='BroadBased'"/>
<xsl:when test="text()='Mixed'"/>
<xsl:when test="text()='NarrowBased'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** Invalid value submitted for <xsl:value-of select="local-name()"/>.Value = '<xsl:value-of select="text()"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template match="swObligatoryReporting" mode="reportingFields">
<xsl:param name="context"/>
<xsl:param name="reportingData"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="text()='true'"/>
<xsl:when test="text()='false'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** Invalid value submitted for <xsl:value-of select="local-name()"/>. Value = '<xsl:value-of select="text()"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template match="swBilateralPartyTradeInformation">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:apply-templates select="swPartyExtension/swBusinessUnit/swCountry" mode="reportingFields"/>
<xsl:apply-templates select="swPartyExtension/swBusinessUnit/swName" mode="reportingFields"/>
<xsl:apply-templates select="swPartyExtension/swReferencedPerson/swCountry" mode="reportingFields"/>
<xsl:apply-templates select="swPartyExtension/swReferencedPerson/swName" mode="reportingFields"/>
</xsl:template>
<xsl:template match='swCountry' mode="reportingFields">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** swCountry cannot be set through SWDML, it must be set through PrivateData.</text>
</error>
</xsl:template>
<xsl:template match='swName' mode="reportingFields">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** swName cannot be set through SWDML, it must be set through PrivateData.</text>
</error>
</xsl:template>
<xsl:template match="swIssuer[../../swJurisdiction='DoddFrank']" mode="reportingFields">
<xsl:param name="context"/>
<xsl:param name="reportingData"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="$productType!='Offline Trade Credit'">
<xsl:call-template name="isValidUSI">
<xsl:with-param name="USI">
<xsl:value-of select="../swTradeId/text()"/>
</xsl:with-param>
<xsl:with-param name="USINamespace">
<xsl:value-of select="text()"/>
</xsl:with-param>
<xsl:with-param name="issuerIdScheme">
<xsl:value-of select="@issuerIdScheme"/>
</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
</xsl:template>
<xsl:template match="swNewNovatedTradeReportingDetails/swReportingRegimeInformation/swUniqueTransactionId/swIssuer[../../swJurisdiction='DoddFrank']" mode="reportingFields">
<xsl:param name="context"/>
<xsl:param name="reportingData"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="$productType='Offline Trade Credit'">
<xsl:call-template name="isValidUSI">
<xsl:with-param name="USI">
<xsl:value-of select="../swTradeId/text()"/>
</xsl:with-param>
<xsl:with-param name="USINamespace">
<xsl:value-of select="text()"/>
</xsl:with-param>
<xsl:with-param name="issuerIdScheme">
<xsl:value-of select="@issuerIdScheme"/>
</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
</xsl:template>
<xsl:template match="swReportingCounterpartyReference" mode="reportingFields">
<xsl:param name="context"/>
<xsl:param name="reportingData"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="../swJurisdiction/text()='CAN' and ../swObligatoryReporting/text()='false'">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** Canada RCP cannot be supplied when (Canada) swObligatoryReporting is false.</text>
</error>
</xsl:when>
<xsl:otherwise/>
</xsl:choose>
<xsl:choose>
<xsl:when test="../swJurisdiction/text()='SEC' and ../swObligatoryReporting/text()='false'">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** SEC RCP cannot be supplied when (SEC) swObligatoryReporting is false.</text>
</error>
</xsl:when>
<xsl:otherwise/>
</xsl:choose>
<xsl:choose>
<xsl:when test="../swJurisdiction/text()='MIFID' and ../swObligatoryReporting/text()='false'">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** MIFID RCP cannot be supplied when (MIFID) swObligatoryReporting is false.</text>
</error>
</xsl:when>
<xsl:otherwise/>
</xsl:choose>
</xsl:template>
<xsl:template match="swPriceNotation|swAdditionalPriceNotation" mode="reportingFields">
<xsl:param name="context"/>
<xsl:param name="reportingData"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="swUnit[not(@unitScheme)]"/>
<xsl:when test="swUnit/@unitScheme='http://www.markitwire.com/spec/2012/coding-scheme/price-quote-units'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** Invalid value submitted for <xsl:value-of select="local-name()"/>/swUnit/@unitScheme. Value = '<xsl:value-of select="swUnit/@unitScheme"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
<xsl:choose>
<xsl:when test="swUnit/text()='Price'"/>
<xsl:when test="swUnit/text()='BasisPoints'"/>
<xsl:when test="swUnit/text()='Percentage'"/>
<xsl:when test="swUnit/text()='Amount'"/>
<xsl:when test="swUnit/text()='UpfrontPoints'"/>
<xsl:when test="swUnit/text()='Premium Currency'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** Invalid value submitted for <xsl:value-of select="local-name()"/>/swUnit. Value = '<xsl:value-of select="swUnit/text()"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
<xsl:if test="string(number(swAmount/text())) ='NaN' or contains(swAmount/text(),' ') or contains(swAmount/text(),'e') or contains(swAmount/text(),'E')">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** Invalid value submitted for <xsl:value-of select="local-name()"/>/swAmount. Value = '<xsl:value-of select="swAmount/text()"/>'.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="swAdditionalPriceNotation" mode="reportingFields">
<xsl:param name="context"/>
<xsl:param name="reportingData"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
</xsl:template>
<xsl:template match="swSecondaryAssetClass" mode="reportingFields">
<xsl:param name="context"/>
<xsl:param name="reportingData"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="text()='Credit'"/>
<xsl:when test="text()='InterestRate'"/>
<xsl:when test="text()='ForeignExchange'"/>
<xsl:when test="text()='Equity'"/>
<xsl:when test="text()='Commodity'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** Invalid value submitted for <xsl:value-of select="local-name()"/>. Value = '<xsl:value-of select="text()"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template match="swReportTo" mode="reportingFields">
<xsl:param name="context"/>
<xsl:param name="reportingData"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:apply-templates select="swPartyReference" mode="checkIsRCP">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="count(swRoute) != 1">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** Invalid cardinality of <xsl:value-of select="local-name()"/> submission. Current implmentation supports only 1 occurence.</text>
</error>
</xsl:if>
<xsl:apply-templates select="swRoute" mode="reportingFields_validateValues">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="swRoute" mode="reportingFields">
<xsl:apply-templates select="swDestination" mode="reportingFields_validateValues">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="swIntermediary" mode="reportingFields_validateValues">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:choose>
<xsl:when test="swDestination='DTCCSDR' and swIntermediary='DTCCGTR'"/>
<xsl:when test="swDestination='CMESDR' and not(swIntermediary)"/>
<xsl:when test="swDestination='BBGSDR' and not(swIntermediary)"/>
<xsl:when test="swDestination='ICESDR' and not(swIntermediary)"/>
<xsl:when test="swDestination='Unspecified' and not(swIntermediary)"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** Invalid  combination of values submitted for <xsl:value-of select="local-name()"/> swDestination = '<xsl:value-of select="swDestination/text()"/>', swIntermediary = '<xsl:value-of select="swIntermediary/text()"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template match="swDestination" mode="reportingFields_validateValues">
<xsl:param name="context"/>
<xsl:choose>
<xsl:when test="text()='DTCCSDR'"/>
<xsl:when test="text()='CMESDR'"/>
<xsl:when test="text()='BBGSDR'"/>
<xsl:when test="text()='ICESDR'"/>
<xsl:when test="text()='Unspecified'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** Invalid value submitted for <xsl:value-of select="local-name()"/>. Value = '<xsl:value-of select="text()"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template match="swIntermediary" mode="reportingFields_validateValues">
<xsl:param name="context"/>
<xsl:choose>
<xsl:when test="text()='DTCCGTR'"/>
<xsl:when test="text()='None-Direct'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** Invalid value submitted for <xsl:value-of select="local-name()"/>. Value = '<xsl:value-of select="text()"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template match="swReportTo/swPartyReference" mode="checkIsRCP">
<xsl:param name="context"/>
<xsl:choose>
<xsl:when test="@href='broker'"/>
<xsl:when test="@href=../../swReportingCounterpartyReference/@href"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** Invalid value submitted for <xsl:value-of select="local-name()"/>. Value = '<xsl:value-of select="@href"/>'. Only submission of RCP details allowed</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template match="@*|node()" mode="reportingFields">
<xsl:param name="context"/>
<xsl:param name="reportingData"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:apply-templates select="node()" mode="reportingFields">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
<xsl:with-param name="reportingData" select="$reportingData"/>
</xsl:apply-templates>
</xsl:template>
</xsl:stylesheet>
