<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:fpml="http://www.fpml.org/2009/FpML-4-6" xmlns="http://www.fpml.org/2009/FpML-4-6"  exclude-result-prefixes="fpml" version="1.0">
<xsl:output method="xml" encoding="iso-8859-1"/>
<xsl:variable name="docsType">
<xsl:value-of select="//fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType"/>
</xsl:variable>
<xsl:variable name="productType">
<xsl:value-of select="//fpml:SWML/fpml:swStructuredTradeDetails/fpml:swProductType"/>
</xsl:variable>
<xsl:template match="fpml:SWML">
<xsl:variable name="originator-href">
<xsl:value-of select="fpml:swHeader/fpml:swOriginatorPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="swdml-version">4-6</xsl:variable>
<SWDML version="{$swdml-version}" xmlns="http://www.fpml.org/2009/FpML-4-6" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.fpml.org/2009/FpML-4-6 swdml-cd-main-4-6.xsd">
<swLongFormTrade>
<swOriginatorPartyReference href="{$originator-href}"/>
<xsl:apply-templates select="fpml:swGiveUp"/>
<xsl:apply-templates select="fpml:novation"/>
<xsl:apply-templates select="fpml:swAllocations"/>
<xsl:apply-templates select="fpml:swStructuredTradeDetails"/>
</swLongFormTrade>
<xsl:apply-templates select="fpml:swStructuredTradeDetails/fpml:swTradeEventReportingDetails"/>
</SWDML>
</xsl:template>
<xsl:template match="fpml:swAllocations">
<swAllocations>
<xsl:apply-templates select="fpml:swAllocation"/>
</swAllocations>
</xsl:template>
<xsl:template match="fpml:swAllocation">
<swAllocation>
<xsl:copy-of select="./@directionReversed"/>
<xsl:copy-of select="fpml:tradeId"/>
<xsl:copy-of select="fpml:swStreamReference"/>
<xsl:copy-of select="fpml:payerPartyReference"/>
<xsl:copy-of select="fpml:receiverPartyReference"/>
<xsl:copy-of select="fpml:buyerPartyReference"/>
<xsl:copy-of select="fpml:sellerPartyReference"/>
<xsl:copy-of select="fpml:allocatedNotional"/>
<xsl:copy-of select="fpml:swAllocatedNumberOfOptions"/>
<xsl:copy-of select="fpml:swAllocatedVegaNotional"/>
<xsl:copy-of select="fpml:swAllocatedVarianceAmount"/>
<xsl:copy-of select="fpml:swFixedAmount"/>
<xsl:copy-of select="fpml:swIAExpected"/>
<xsl:copy-of select="fpml:independentAmount"/>
<xsl:copy-of select="fpml:additionalPayment"/>
<xsl:copy-of select="fpml:swPrivateTradeId"/>
<xsl:copy-of select="fpml:swSalesCredit"/>
<xsl:copy-of select="fpml:swAdditionalField"/>
<xsl:copy-of select="fpml:swClearingBroker"/>
<xsl:copy-of select="fpml:swNettingString"/>
<xsl:copy-of select="fpml:swAllocationReportingDetails[not(fpml:swJurisdiction='ASIC') and not(fpml:swJurisdiction='MAS')]"/>
<xsl:apply-templates select="fpml:swNexusReportingDetails"/>
<xsl:copy-of select="fpml:swCounterpartyCorporateSector"/>
</swAllocation>
</xsl:template>
<xsl:template match="fpml:swNexusReportingDetails">
<swNexusReportingDetails>
<xsl:copy-of select="fpml:swRelatedParty"/>
<xsl:copy-of select="fpml:swRelatedBusinessUnit"/>
<xsl:copy-of select="fpml:swRelatedPerson"/>
<xsl:apply-templates select="fpml:swPartyExtension"/>
<xsl:copy-of select="fpml:swAdditionalParty"/>
</swNexusReportingDetails>
</xsl:template>
<xsl:template match="fpml:swPartyExtension">
<xsl:variable name="partyHref" select="./@href"/>
<swPartyExtension href='{$partyHref}'>
<xsl:apply-templates select="fpml:swBusinessUnit"/>
<xsl:apply-templates select="fpml:swReferencedPerson"/>
</swPartyExtension>
</xsl:template>
<xsl:template match="fpml:swBusinessUnit">
<xsl:variable name="businessHref" select="./@id"/>
<swBusinessUnit id='{$businessHref}'>
<swCountry countryScheme="http://www.fpml.org/ext/iso3166">
<xsl:for-each select="fpml:swCountry">
<xsl:value-of select="."/>
<xsl:if test="../fpml:swCountry[position()=last()] != .">;</xsl:if>
</xsl:for-each>
</swCountry>
</swBusinessUnit>
</xsl:template>
<xsl:template match="fpml:swReferencedPerson">
<xsl:variable name="personHref" select="./@id"/>
<swReferencedPerson id='{$personHref}'>
<xsl:copy-of select="fpml:swName"/>
<xsl:if test="fpml:swCountry">
<swCountry countryScheme="http://www.fpml.org/ext/iso3166">
<xsl:for-each select="fpml:swCountry">
<xsl:value-of select="."/>
<xsl:if test="../fpml:swCountry[position()=last()] != .">;</xsl:if>
</xsl:for-each>
</swCountry>
</xsl:if>
</swReferencedPerson>
</xsl:template>
<xsl:template match="fpml:swGiveUp">
<swGiveUp>
<xsl:copy-of select="fpml:swEligiblePrimeBrokerTrade"/>
<xsl:apply-templates select="fpml:swCustomerTransaction"/>
<xsl:apply-templates select="fpml:swInterDealerTransaction"/>
<xsl:apply-templates select="fpml:swExecutingDealerCustomerTransaction"/>
</swGiveUp>
</xsl:template>
<xsl:template match="fpml:swCustomerTransaction">
<swCustomerTransaction>
<xsl:copy-of select="fpml:swCustomer"/>
<xsl:copy-of select="fpml:swPrimeBroker"/>
</swCustomerTransaction>
</xsl:template>
<xsl:template match="fpml:swInterDealerTransaction">
<swInterDealerTransaction>
<xsl:copy-of select="fpml:swExecutingDealer"/>
<xsl:copy-of select="fpml:swPrimeBroker"/>
</swInterDealerTransaction>
</xsl:template>
<xsl:template match="fpml:swExecutingDealerCustomerTransaction">
<swExecutingDealerCustomerTransaction>
<xsl:copy-of select="fpml:swExecutingDealer"/>
</swExecutingDealerCustomerTransaction>
</xsl:template>
<xsl:template match="fpml:novation">
<novation>
<xsl:copy-of select="fpml:eventId"/>
<xsl:copy-of select="fpml:transferor"/>
<xsl:copy-of select="fpml:transferee"/>
<xsl:copy-of select="fpml:remainingParty"/>
<xsl:copy-of select="fpml:otherRemainingParty"/>
<xsl:copy-of select="fpml:novationDate"/>
<xsl:copy-of select="fpml:novationTradeDate"/>
<xsl:copy-of select="fpml:novatedAmount"/>
<xsl:copy-of select="fpml:fullFirstCalculationPeriod"/>
<xsl:copy-of select="fpml:nonReliance"/>
<xsl:copy-of select="fpml:payment"/>
<xsl:copy-of select="fpml:swBusinessConductDetails"/>
</novation>
</xsl:template>
<xsl:template match="fpml:swStructuredTradeDetails">
<swStructuredTradeDetails>
<xsl:copy-of select="fpml:swProductType"/>
<xsl:copy-of select="fpml:swParticipantSupplement"/>
<xsl:copy-of select="fpml:FpML"/>
<xsl:apply-templates select="fpml:swExtendedTradeDetails"/>
<xsl:apply-templates select="fpml:swBusinessConductDetails"/>
</swStructuredTradeDetails>
</xsl:template>
<xsl:template match="fpml:swAssociatedTrades"/>
<xsl:template match="fpml:swOffsettingTradeId"/>
<xsl:template match="fpml:swCompressionType"/>
<xsl:template match="fpml:swExecutionMethod"/>
<xsl:template match="fpml:swOTVConfirmation"/>
<xsl:template match="fpml:swIntroducingBroker"/>
<xsl:template match="fpml:swExtendedTradeDetails">
<swExtendedTradeDetails>
<xsl:apply-templates select="fpml:swTradeHeader"/>
<xsl:copy-of select="fpml:swCreditProductType"/>
<xsl:choose>
<xsl:when test="$productType='Offline Trade Credit' or $productType='Offline Trade Credit Summary'">
<xsl:choose>
<xsl:when test="fpml:swIndividualTradeSummary">
<swInternalTradeDetails>
<xsl:copy-of select="fpml:swNovationBlockId"/>
<swSummaryLinkId>
<xsl:choose>
<xsl:when test="fpml:swNovationBlockId">
<xsl:value-of select="fpml:swNovationBlockId"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="fpml:swIndividualTradeSummary/fpml:partyTradeIdentifier/fpml:tradeId[@tradeIdScheme='NovationConsentId']"/>
</xsl:otherwise>
</xsl:choose>
</swSummaryLinkId>
<xsl:for-each select="fpml:swIndividualTradeSummary">
<swIndividualTradeSummary>
<xsl:for-each select="fpml:partyTradeIdentifier">
<partyTradeIdentifier>
<xsl:copy-of select="fpml:partyReference"/>
<xsl:copy-of select="fpml:tradeId"/>
<xsl:copy-of select="fpml:versionedTradeId"/>
<xsl:copy-of select="fpml:linkId"/>
</partyTradeIdentifier>
</xsl:for-each>
<xsl:copy-of select="fpml:calculationAmount"/>
<xsl:copy-of select="fpml:paymentAmount"/>
<xsl:copy-of select="fpml:status"/>
</swIndividualTradeSummary>
</xsl:for-each>
<xsl:copy-of select="fpml:swConsentConfirmationEligible"/>
<xsl:copy-of select="fpml:tradeId"/>
</swInternalTradeDetails>
</xsl:when>
<xsl:otherwise>
<swInternalTradeDetails>
<xsl:copy-of select="fpml:swNovationBlockId"/>
<swSummaryLinkId>
<xsl:choose>
<xsl:when test="fpml:swNovationBlockId">
<xsl:value-of select="fpml:swNovationBlockId"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="fpml:swIndividualTradeSummary/fpml:partyTradeIdentifier/fpml:tradeId[@tradeIdScheme='NovationConsentId']"/>
</xsl:otherwise>
</xsl:choose>
</swSummaryLinkId>
<xsl:copy-of select="fpml:swConsentConfirmationEligible"/>
<xsl:for-each select="fpml:tradeId">
<xsl:copy-of select="."/>
</xsl:for-each>
</swInternalTradeDetails>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
</xsl:choose>
<xsl:copy-of select="fpml:additionalPayment"/>
<xsl:copy-of select="fpml:swExitReason"/>
<xsl:copy-of select="fpml:swCreditDefaultSwapDetails"/>
<xsl:copy-of select="fpml:swAsOfDate"/>
<xsl:copy-of select="fpml:swValueDate"/>
<xsl:apply-templates select="fpml:swOrderDetails[not(@href='broker' or @href='partyA' or @href='partyB')]"/>
</swExtendedTradeDetails>
</xsl:template>
<xsl:template match="fpml:swTradeEventReportingDetails">
<swTradeEventReportingDetails>
<xsl:copy-of select="fpml:swUniqueTransactionId"/>
<xsl:apply-templates select="fpml:swReportingRegimeInformation"/>
<xsl:apply-templates select="fpml:swReportableProduct"/>
<xsl:copy-of select="fpml:swPriceNotation"/>
<xsl:copy-of select="fpml:swAdditionalPriceNotation"/>
<xsl:if test="fpml:swNewNovatedTradeReportingDetails and $productType = ('Offline Trade Credit Summary' or 'Offline Trade Credit Summary')">
<swNewNovatedTradeReportingDetails>
<xsl:apply-templates select="fpml:swNewNovatedTradeReportingDetails/fpml:swReportingRegimeInformation"/>
</swNewNovatedTradeReportingDetails>
<xsl:copy-of select="fpml:swNewNovatedTradeReportingDetails/fpml:swPriceNotation"/>
<xsl:copy-of select="fpml:swNewNovatedTradeReportingDetails/fpml:swAdditionalPriceNotation"/>
</xsl:if>
<xsl:if test="fpml:swNovationFeeTradeReportingDetails">
<swNovationFeeTradeReportingDetails>
<xsl:apply-templates select="fpml:swNovationFeeTradeReportingDetails/fpml:swReportingRegimeInformation"/>
</swNovationFeeTradeReportingDetails>
<xsl:copy-of select="fpml:swNovationFeeTradeReportingDetails/fpml:swPriceNotation"/>
<xsl:copy-of select="fpml:swNovationFeeTradeReportingDetails/fpml:swAdditionalPriceNotation"/>
</xsl:if>
</swTradeEventReportingDetails>
</xsl:template>
<xsl:template match="fpml:swReportingRegimeInformation">
<swReportingRegimeInformation>
<xsl:copy-of select="fpml:swJurisdiction"/>
<xsl:copy-of select="fpml:swSupervisoryBodyCategory"/>
<xsl:copy-of select="fpml:swUniqueTransactionId"/>
<xsl:copy-of select="fpml:swObligatoryReporting"/>
<xsl:copy-of select="fpml:swReportingCounterpartyReference"/>
<xsl:copy-of select="fpml:swReportTo[not(fpml:swPartyReference/@href='broker')]"/>
<xsl:copy-of select="fpml:swMandatoryClearingIndicator"/>
<xsl:copy-of select="fpml:swToTV"/>
</swReportingRegimeInformation>
</xsl:template>
<xsl:template match="@*|node()">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>
</xsl:stylesheet>
