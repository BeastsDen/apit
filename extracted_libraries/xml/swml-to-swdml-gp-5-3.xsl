<xsl:stylesheet version="1.0" xmlns="http://www.markitserv.com/swml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fpml="http://www.fpml.org/FpML-5/confirmation" xmlns:swml="http://www.markitserv.com/swml">
<xsl:output method="xml" encoding="iso-8859-1"/>
<xsl:variable name="docsType">
<xsl:value-of select="//swml:FpML/swml:trade/swml:documentation/swml:masterConfirmation/swml:masterConfirmationType"/>
</xsl:variable>
<xsl:variable name="productType">
<xsl:value-of select="//swml:SWML/swml:swStructuredTradeDetails/swml:swProductType"/>
</xsl:variable>
<xsl:template match="@*|node()">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>
<xsl:template match="swml:SWML">
<xsl:variable name="originator-href">
<xsl:value-of select="swml:swHeader/swml:swOriginatorPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="swdml-version">5-3</xsl:variable>
<SWDML xmlns:fpml="http://www.fpml.org/FpML-5/confirmation" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="{$swdml-version}" xsi:schemaLocation="http://www.markitserv.com/swml swdml-generic-main-5-3.xsd">
<swLongFormTrade>
<swOriginatorPartyReference href="{$originator-href}"/>
<xsl:if test="swml:swHeader/swml:swReplacementTradeId">
<swReplacementTradeId>
<xsl:copy-of select="swml:swHeader/swml:swReplacementTradeId/swml:swTradeId"/>
<xsl:copy-of select="swml:swHeader/swml:swReplacementTradeId/swml:swTradeIdType"/>
<xsl:copy-of select="swml:swHeader/swml:swReplacementTradeId/swml:swReplacementReason"/>
</swReplacementTradeId>
</xsl:if>
<xsl:apply-templates select="swml:swAllocations"/>
<xsl:apply-templates select="swml:swStructuredTradeDetails"/>
</swLongFormTrade>
<xsl:apply-templates select="swml:swStructuredTradeDetails/swml:swTradeEventReportingDetails"/>
</SWDML>
</xsl:template>
<xsl:template match="swml:swAllocations">
<swAllocations>
<xsl:apply-templates select="swml:swAllocation"/>
</swAllocations>
</xsl:template>
<xsl:template match="swml:swAllocation">
<swAllocation>
<xsl:copy-of select="./@directionReversed"/>
<xsl:copy-of select="*[name() != 'swNexusReportingDetails' and name() != 'swCounterpartyCorporateSector']"/>
<xsl:apply-templates select="swml:swNexusReportingDetails"/>
<xsl:copy-of select="swml:swCounterpartyCorporateSector"/>
</swAllocation>
</xsl:template>
<xsl:template match="swml:swNexusReportingDetails">
<swNexusReportingDetails>
<xsl:copy-of select="swml:swRelatedParty"/>
<xsl:copy-of select="swml:swRelatedBusinessUnit"/>
<xsl:copy-of select="swml:swRelatedPerson"/>
<xsl:apply-templates select="swml:swPartyExtension"/>
<xsl:copy-of select="swml:swAdditionalParty"/>
</swNexusReportingDetails>
</xsl:template>
<xsl:template match="swml:swPartyExtension">
<xsl:variable name="partyHref" select="./@href"/>
<swPartyExtension href='{$partyHref}'>
<xsl:apply-templates select="swml:swBusinessUnit"/>
<xsl:apply-templates select="swml:swReferencedPerson"/>
</swPartyExtension>
</xsl:template>
<xsl:template match="swml:swBusinessUnit">
<xsl:variable name="businessHref" select="./@id"/>
<swBusinessUnit id='{$businessHref}'>
<swCountry countryScheme="http://www.fpml.org/ext/iso3166">
<xsl:for-each select="swml:swCountry">
<xsl:value-of select="."/>
<xsl:if test="../swml:swCountry[position()=last()] != .">;</xsl:if>
</xsl:for-each>
</swCountry>
</swBusinessUnit>
</xsl:template>
<xsl:template match="swml:swReferencedPerson">
<xsl:variable name="personHref" select="./@id"/>
<swReferencedPerson id='{$personHref}'>
<xsl:copy-of select="swml:swName"/>
<xsl:if test="swml:swCountry">
<swCountry countryScheme="http://www.fpml.org/ext/iso3166">
<xsl:for-each select="swml:swCountry">
<xsl:value-of select="."/>
<xsl:if test="../swml:swCountry[position()=last()] != .">;</xsl:if>
</xsl:for-each>
</swCountry>
</xsl:if>
</swReferencedPerson>
</xsl:template>
<xsl:template match="swml:swInterDealerTransaction">
<swInterDealerTransaction>
<xsl:copy-of select="swml:swExecutingDealer"/>
<xsl:copy-of select="swml:swPrimeBroker"/>
</swInterDealerTransaction>
</xsl:template>
<xsl:template match="swml:swEarlyTerminationProvision"/>
<xsl:template match="swExecutingDealerCustomerTransaction">
<swExecutingDealerCustomerTransaction>
<xsl:copy-of select="swml:swExecutingDealer"/>
</swExecutingDealerCustomerTransaction>
</xsl:template>
<xsl:template match="swml:novation">
<novation>
<xsl:copy-of select="swml:eventId"/>
<xsl:copy-of select="swml:transferor"/>
<xsl:copy-of select="swml:transferee"/>
<xsl:copy-of select="swml:remainingParty"/>
<xsl:copy-of select="swml:otherRemainingParty"/>
<xsl:copy-of select="swml:novationDate"/>
<xsl:copy-of select="swml:novationTradeDate"/>
<xsl:copy-of select="swml:novatedAmount"/>
<xsl:copy-of select="swml:fullFirstCalculationPeriod"/>
<xsl:copy-of select="swml:nonReliance"/>
<xsl:copy-of select="swml:payment"/>
<xsl:copy-of select="fpml:swBusinessConductDetails"/>
</novation>
</xsl:template>
<xsl:template match="swml:swStructuredTradeDetails">
<swStructuredTradeDetails>
<xsl:copy-of select="swml:swProductType"/>
<xsl:copy-of select="swml:swTemplateName"/>
<xsl:copy-of select="fpml:dataDocument"/>
<xsl:apply-templates select="swml:swExtendedTradeDetails"/>
<xsl:apply-templates select="swml:swBusinessConductDetails"/>
</swStructuredTradeDetails>
</xsl:template>
<xsl:template match="fpml:dataDocument">
<dataDocument xmlns="http://www.fpml.org/FpML-5/confirmation">
<xsl:apply-templates/>
</dataDocument>
</xsl:template>
<xsl:template match="swml:swOffsettingTradeId"/>
<xsl:template match="swml:swCompressionType"/>
<xsl:template match="swml:swExecutionMethod"/>
<xsl:template match="swml:swExtendedTradeDetails">
<swExtendedTradeDetails>
<swTradeHeader>
<xsl:copy-of select="swml:swTradeHeader/swml:swManualConfirmationRequired"/>
<xsl:copy-of select="swml:swTradeHeader/swml:swNovationExecution"/>
<xsl:copy-of select="swml:swTradeHeader/swml:swBackLoadingFlag"/>
<xsl:copy-of select="swml:swTradeHeader/swml:swMandatoryClearing"/>
<xsl:copy-of select="swml:swTradeHeader/swml:swESMAClearingExemption"/>
</swTradeHeader>
<xsl:copy-of select="swml:swCreditProductType"/>
<xsl:choose>
<xsl:when test="$productType='Offline Trade Credit' or $productType='Offline Trade Credit Summary' ">
<xsl:variable name="tradeId" select="swml:swIndividualTradeSummary/swml:partyTradeIdentifier/swml:tradeId"/>
<xsl:choose>
<xsl:when test="swml:swIndividualTradeSummary">
<swInternalTradeDetails>
<xsl:copy-of select="swml:swNovationBlockId"/>
<swSummaryLinkId>
<xsl:choose>
<xsl:when test="swml:swNovationBlockId">
<xsl:value-of select="swml:swNovationBlockId"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$tradeId[@tradeIdScheme='NovationConsentId']"/>
</xsl:otherwise>
</xsl:choose>
</swSummaryLinkId>
<xsl:for-each select="swml:swIndividualTradeSummary">
<swIndividualTradeSummary>
<xsl:for-each select="swml:partyTradeIdentifier">
<partyTradeIdentifier>
<xsl:copy-of select="swml:partyReference"/>
<xsl:copy-of select="swml:tradeId"/>
<xsl:copy-of select="swml:versionedTradeId"/>
<xsl:copy-of select="swml:linkId"/>
</partyTradeIdentifier>
</xsl:for-each>
<xsl:copy-of select="swml:calculationAmount"/>
<xsl:copy-of select="swml:paymentAmount"/>
<xsl:copy-of select="swml:status"/>
</swIndividualTradeSummary>
</xsl:for-each>
<xsl:copy-of select="swml:swConsentConfirmationEligible"/>
<xsl:copy-of select="swml:tradeId"/>
</swInternalTradeDetails>
</xsl:when>
<xsl:otherwise>
<swInternalTradeDetails>
<xsl:copy-of select="swml:swNovationBlockId"/>
<swSummaryLinkId>
<xsl:choose>
<xsl:when test="swml:swNovationBlockId">
<xsl:value-of select="swml:swNovationBlockId"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$tradeId[@tradeIdScheme='NovationConsentId']"/>
</xsl:otherwise>
</xsl:choose>
</swSummaryLinkId>
<xsl:copy-of select="swml:swConsentConfirmationEligible"/>
<xsl:for-each select="swml:tradeId">
<xsl:copy-of select="."/>
</xsl:for-each>
</swInternalTradeDetails>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
</xsl:choose>
<xsl:copy-of select="swml:additionalPayment"/>
<xsl:copy-of select="swml:swExitReason"/>
<xsl:copy-of select="swml:swAmendmentType"/>
<xsl:copy-of select="swml:swCancellationType"/>
<xsl:copy-of select="swml:swCreditDefaultSwapDetails"/>
<xsl:apply-templates select="swml:swOrderDetails[not(@href='broker' or @href='partyA' or @href='partyB')]"/>
</swExtendedTradeDetails>
</xsl:template>
<xsl:template match="swml:swTradeEventReportingDetails">
<swTradeEventReportingDetails>
<xsl:copy-of select="swml:swUniqueTransactionId"/>
<xsl:copy-of select="swml:swTradeInformation"/>
<xsl:apply-templates select="swml:swReportingRegimeInformation"/>
<xsl:apply-templates select="swml:swReportableProduct"/>
<xsl:copy-of select="swml:swBuyerPartyReference"/>
<xsl:copy-of select="swml:swSellerPartyReference"/>
<xsl:apply-templates select="swml:swPriceNotation"/>
<xsl:apply-templates select="swml:swAdditionalPriceNotation"/>
</swTradeEventReportingDetails>
</xsl:template>
<xsl:template match="swml:swReportingRegimeInformation">
<swReportingRegimeInformation>
<xsl:copy-of select="swml:swJurisdiction"/>
<xsl:copy-of select="swml:swSupervisoryBodyCategory"/>
<xsl:copy-of select="swml:swReportableLocations"/>
<xsl:copy-of select="swml:swUniqueTransactionId"/>
<xsl:copy-of select="swml:swObligatoryReporting"/>
<xsl:copy-of select="swml:swReportingCounterpartyReference"/>
<xsl:copy-of select="swml:swReportTo[not(swml:swPartyReference/@href='broker')]"/>
<xsl:copy-of select="swml:swMandatoryClearingIndicator"/>
<xsl:copy-of select="swml:swToTV"/>
</swReportingRegimeInformation>
</xsl:template>
<xsl:template match="swml:swPriceNotation">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>
<xsl:template match="swml:swAdditionalPriceNotation">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>
</xsl:stylesheet>
