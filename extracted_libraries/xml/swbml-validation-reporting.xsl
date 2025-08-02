<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml"/>
<xsl:variable name="CFTCIssuerIdScheme">http://www.fpml.org/coding-scheme/external/cftc/issuer-identifier</xsl:variable>
<xsl:variable name="LEIScheme">http://www.fpml.org/coding-scheme/external/iso17442</xsl:variable>
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
<xsl:template name="swbTradeEventReportingDetails">
<xsl:param name="context"/>
<xsl:param name="reportingData" select="node()"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/swbTradeEventReportingDetails</xsl:variable>
<xsl:apply-templates select="$reportingData/node()" mode="reportingFields">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
<xsl:with-param name="reportingData" select="$reportingData"/>
</xsl:apply-templates>
</xsl:template>
<xsl:template name="swbPrivatePartyTradeEventReportingDetails">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:apply-templates select="swbPrivatePartyTradeEventReportingDetails">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template name="swbAllocationReportingDetails">
<xsl:param name="context"/>
<xsl:param name="reportingAllocationData"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="$reportingAllocationData/swbReportingRegimeInformation/swbSupervisoryBodyCategory">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Can't submit swbSupervisoryBodyCategory for allocations.</text></error>
</xsl:if>
<xsl:if test="$reportingAllocationData/swbReportingRegimeInformation/swbReportTo">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Can't submit swbReportTo for allocations.</text></error>
</xsl:if>
<xsl:if test="$reportingAllocationData/swbReportingRegimeInformation/swbMandatoryClearingIndicator">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Can't submit swbMandatoryClearingIndicator for allocations.</text></error>
</xsl:if>
<xsl:if test="$reportingAllocationData/swbReportingRegimeInformation/swbLargeSizeTrade">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Can't submit swbLargeSizeTrade for allocations.</text></error>
</xsl:if>
<xsl:if test="$reportingAllocationData/swbPartyTradeInformation/swbTimestamps">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Can't submit swbTimestamps for allocations.</text></error>
</xsl:if>
<xsl:if test="$reportingAllocationData/swbPartyTradeInformation/swbExecutionDateTime">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Can't submit swbExecutionDateTime for allocations.</text></error>
</xsl:if>
<xsl:if test="$reportingAllocationData/swbPartyTradeInformation/swbNonStandardTerms">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Can't submit swbNonStandardTerms for allocations.</text></error>
</xsl:if>
<xsl:if test="$reportingAllocationData/swbPartyTradeInformation/swbExecutionVenueType">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Can't submit swbExecutionVenueType for allocations.</text></error>
</xsl:if>
<xsl:if test="$reportingAllocationData/swbPartyTradeInformation/swbVerificationMethod">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Can't submit swbVerificationMethod for allocations.</text></error>
</xsl:if>
<xsl:if test="$reportingAllocationData/swbPartyTradeInformation/swbConfirmationMethod">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Can't submit swbConfirmationMethod for allocations.</text></error>
</xsl:if>
<xsl:apply-templates select="$reportingAllocationData/swbReportingRegimeInformation/swbJurisdiction" mode="reportingFields">
<xsl:with-param name="context"><xsl:value-of select="$context"/></xsl:with-param><xsl:with-param name="reportingData" select="$reportingAllocationData"/>
</xsl:apply-templates>
<xsl:apply-templates select="$reportingAllocationData/swbReportingRegimeInformation/swbObligatoryReporting" mode="reportingFields">
<xsl:with-param name="context"><xsl:value-of select="$context"/></xsl:with-param><xsl:with-param name="reportingData" select="$reportingAllocationData"/>
</xsl:apply-templates>
<xsl:apply-templates select="$reportingAllocationData/swbReportingRegimeInformation/swbReportingCounterpartyReference" mode="reportingFields">
<xsl:with-param name="context"><xsl:value-of select="$context"/></xsl:with-param><xsl:with-param name="reportingData" select="$reportingAllocationData"/>
</xsl:apply-templates>
</xsl:template>
<xsl:template name="swbNovationExecutionUniqueTransactionId">
<xsl:param name="context"/>
<xsl:param name="reportingData"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:apply-templates select="$reportingData/swbNovationExecutionUniqueTransactionId" mode="reportingFields">
<xsl:with-param name="context">
<xsl:value-of select="$context"/>
</xsl:with-param>
<xsl:with-param name="reportingData" select="$reportingData"/>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="swbJurisdiction" mode="reportingFields">
<xsl:param name="context"/>
<xsl:param name="reportingData"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="not(contains(';ASIC;CAN;ESMA;FCA;HKMA;DoddFrank;MIFID;MAS;JFSA;SEC;', concat(';', text(),';')))">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid value submitted for <xsl:value-of select="local-name()"/>. Value = '<xsl:value-of select="text()"/>'.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="swbReportingRegimeInformation/swbSupervisoryBodyCategory" mode="reportingFields">
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
<xsl:template match="swbObligatoryReporting" mode="reportingFields">
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
<xsl:template match="swbMandatoryClearingIndicator" mode="reportingFields">
<xsl:param name="context"/>
<xsl:param name="reportingData"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="text()='true'">
<xsl:if test="../swbObligatoryReporting='false'">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** Invalid value submitted for <xsl:value-of select="local-name()"/>. Value = '<xsl:value-of select="text()"/>'. Value cannot be provided where swbObligatoryReporting = 'false'</text>
</error>
</xsl:if>
</xsl:when>
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
<xsl:template match="swbIssuer" mode="reportingFields">
<xsl:param name="context"/>
<xsl:param name="reportingData"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:call-template name="isValidUSI">
<xsl:with-param name="USI">
<xsl:value-of select="preceding-sibling::node()/swTradeId/text()"/>
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
</xsl:template>
<xsl:template match="swbReportingCounterpartyReference" mode="reportingFields">
<xsl:param name="context"/>
<xsl:param name="reportingData"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="../swbJurisdiction/text()='CAN' and ../swbObligatoryReporting/text()='false'">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** Canada RCP cannot be supplied when (Canada) swbObligatoryReporting is false.</text>
</error>
</xsl:when>
<xsl:otherwise/>
</xsl:choose>
</xsl:template>
<xsl:template match="swbPriceNotation|swAdditionalPriceNotation" mode="reportingFields">
<xsl:param name="context"/>
<xsl:param name="reportingData"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="swbUnit[not(@unitScheme)]"/>
<xsl:when test="swbUnit/@unitScheme='http://www.markitwire.com/spec/2012/coding-scheme/price-quote-units'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** Invalid value submitted for <xsl:value-of select="local-name()"/>/swbUnit/@unitScheme. Value = '<xsl:value-of select="swbUnit/@unitScheme"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
<xsl:choose>
<xsl:when test="swbUnit/text()='Price'"/>
<xsl:when test="swbUnit/text()='BasisPoints'"/>
<xsl:when test="swbUnit/text()='Percentage'"/>
<xsl:when test="swbUnit/text()='UpfrontPoints'"/>
<xsl:when test="swbUnit/text()='Amount'"/>
<xsl:when test="swbUnit/text()='Level'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** Invalid value submitted for <xsl:value-of select="local-name()"/>/swbUnit. Value = '<xsl:value-of select="swbUnit/text()"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
<xsl:if test="string(number(swbAmount/text())) ='NaN' or contains(swbAmount/text(),' ') or contains(swbAmount/text(),'e') or contains(swbAmount/text(),'E')">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** Invalid value submitted for <xsl:value-of select="local-name()"/>/swAmount. Value = '<xsl:value-of select="swbAmount/text()"/>'.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="swbAdditionalPriceNotation" mode="reportingFields">
<xsl:param name="context"/>
<xsl:param name="reportingData"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
</xsl:template>
<xsl:template match="swbSecondaryAssetClass" mode="reportingFields">
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
<xsl:template match="swbReportTo" mode="reportingFields">
<xsl:param name="context"/>
<xsl:param name="reportingData"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="../swbJurisdiction/text()='MIFID'">
<xsl:if test="count(swbRoute) &gt; 2">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** Invalid cardinality of <xsl:value-of select="local-name()"/> submission. Current implmentation supports at most 2 occurences for MIFID jurisdiction.</text>
</error>
</xsl:if>
</xsl:when>
<xsl:otherwise>
<xsl:if test="count(swbRoute) != 1">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** Invalid cardinality of <xsl:value-of select="local-name()"/> submission. Current implmentation supports only 1 occurence.</text>
</error>
</xsl:if>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="swbRoute" mode="reportingFields_validateValues">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="swbRoute" mode="reportingFields">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:apply-templates select="swbDestination" mode="reportingFields_validateValues">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="swbIntermediary" mode="reportingFields_validateValues">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:choose>
<xsl:when test="swbDestination='DTCCSDR' and swbIntermediary='DTCCGTR'"/>
<xsl:when test="swbDestination='CMESDR' and not(swbIntermediary)"/>
<xsl:when test="swbDestination='BBGSDR' and not(swbIntermediary)"/>
<xsl:when test="swbDestination='ICESDR' and not(swbIntermediary)"/>
<xsl:when test="swbDestination='Unspecified' and not(swbIntermediary)"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** Invalid  combination of values submitted for <xsl:value-of select="local-name()"/> swbDestination = '<xsl:value-of select="swbDestination/text()"/>', swbIntermediary = '<xsl:value-of select="swbIntermediary/text()"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template match="swbDestination" mode="reportingFields_validateValues">
<xsl:param name="context"/>
<xsl:choose>
<xsl:when test="../../../swbJurisdiction/text()='MIFID' and ../swbMIFIDReportingPreference/text()='TransparencyReporting'">
<xsl:choose>
<xsl:when test="text()='Tradeweb'"/>
<xsl:when test="text()='TRAX'"/>
<xsl:when test="text()='NEX'"/>
<xsl:when test="text()='Deutsche Borse'"/>
<xsl:when test="text()='Tradecho'"/>
<xsl:when test="text()='Boat'"/>
<xsl:when test="text()='Bloomberg'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** Invalid value submitted for MIFID TransparencyReporting <xsl:value-of select="local-name()"/>. Value = '<xsl:value-of select="text()"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="../../../swbJurisdiction/text()='MIFID' and ../swbMIFIDReportingPreference/text()='TransactionReporting'">
<xsl:choose>
<xsl:when test="text()='UnaVista'"/>
<xsl:when test="text()='Crest'"/>
<xsl:when test="text()='TRAX'"/>
<xsl:when test="text()='GETCO'"/>
<xsl:when test="text()='TransacPort'"/>
<xsl:when test="text()='Bloomberg TOMS'"/>
<xsl:when test="text()='NEX'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** Invalid value submitted for MIFID TransactionReporting <xsl:value-of select="local-name()"/>. Value = '<xsl:value-of select="text()"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:otherwise>
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
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template match="swbIntermediary" mode="reportingFields_validateValues">
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
<xsl:template match="swbReportTo/swbPartyReference" mode="checkIsRCP">
<xsl:param name="context"/>
<xsl:variable name="rcpHRef" select="../../swbReportingCounterpartyReference/@href"/>
<xsl:variable name="tradePartyRef" select="@href='partyA' or @href='#partyA' or @href='partyB' or @href='#partyB'"/>
<xsl:variable name="executionVenue" select="../../../../swbPrivatePartyTradeEventReportingDetails/swbPartyTradeInformation/swbExecutionVenueType"/>
<xsl:choose>
<xsl:when test="$executionVenue='SEF' or $executionVenue='QMTF' or $executionVenue='DCM'">
<xsl:if test="$tradePartyRef or @href=$rcpHRef">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** Invalid value submitted for <xsl:value-of select="local-name()"/>. Value = '<xsl:value-of select="@href"/>'. Only submission of SEF broker allowed</text>
</error>
</xsl:if>
</xsl:when>
<xsl:when test="$executionVenue">
<xsl:if test="($rcpHRef and @href!=$rcpHRef) or (not($rcpHRef) and not($tradePartyRef))">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** Invalid value submitted for <xsl:value-of select="local-name()"/>. Value = '<xsl:value-of select="@href"/>'. Only submission of RCP allowed</text>
</error>
</xsl:if>
</xsl:when>
<xsl:otherwise>
<xsl:if test="$tradePartyRef and $rcpHRef and @href!=$rcpHRef">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** Invalid value submitted for <xsl:value-of select="local-name()"/>. Value = '<xsl:value-of select="@href"/>'. Only submission of SEF broker or RCP allowed</text>
</error>
</xsl:if>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template match="swbPrivatePartyTradeEventReportingDetails" mode="reportingFields">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="swbEventId/swbBulkProcessingEventId/text() != swbPartyReportingRegimeInformation/swbEventId/swbBulkProcessingEventId/text()">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** Bulk Event Ids must be equal ***</text>
</error>
</xsl:if>
<xsl:variable name="partyRef">
<xsl:value-of select="swbPartyReference/@href"/>
</xsl:variable>
<xsl:if test="$partyRef = 'broker' and swbPartyTradeInformation/swbComplexTradeDetails">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Complex trade details can only be provided for respective parties in the trade.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template name="swbPackageDetails">
<xsl:param name="context"/>
<xsl:param name="packageDetails"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:variable name="packagePriceType">
<xsl:value-of select="$packageDetails/swbPackagePriceDetails/swbType"/>
</xsl:variable>
<xsl:variable name="packagePriceNotation">
<xsl:value-of select="$packageDetails/swbPackagePriceDetails/swbNotation"/>
</xsl:variable>
<xsl:if test="($packagePriceType = 'Price') and (not (contains('Amount;Decimal',$packagePriceNotation)))">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** When Package Price Type is Price, Package Price Notation cannot be '<xsl:value-of select="$packagePriceNotation"/>'. </text>
</error>
</xsl:if>
<xsl:if test="($packagePriceType = 'Spread') and (not (contains('Amount;Decimal;BasisPoints',$packagePriceNotation)))">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** When Package Price Type is Spread, Package Price Notation cannot be '<xsl:value-of select="$packagePriceNotation"/>'. </text>
</error>
</xsl:if>
<xsl:if test="($packagePriceType = '') and ($packagePriceNotation != '')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Package Price Type cannot be blank when Package Price Notation is specified. </text>
</error>
</xsl:if>
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
