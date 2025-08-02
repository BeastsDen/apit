<?xml version="1.0"?>
<xsl:stylesheet xmlns="http://www.fpml.org/2005/FpML-4-2" xmlns:dsig="http://www.w3.org/2000/09/xmldsig#" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fpml="http://www.fpml.org/2005/FpML-4-2" exclude-result-prefixes="fpml" version="1.0">
<xsl:output method="xml" encoding="iso-8859-1"/>
<xsl:template match="fpml:SWML">
<xsl:variable name="originator-href">
<xsl:value-of select="fpml:swHeader/fpml:swOriginatorPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="swdml-version">4-2</xsl:variable>
<SWDML version="{$swdml-version}" xmlns="http://www.fpml.org/2005/FpML-4-2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.fpml.org/2005/FpML-4-2 swdml-ird-main-4-2.xsd">
<swLongFormTrade>
<swOriginatorPartyReference href="{$originator-href}"/>
<xsl:apply-templates select="fpml:swGiveUp"/>
<xsl:if test="fpml:swHeader/fpml:swReplacementTradeId">
<swReplacementTradeId>
<xsl:copy-of select="fpml:swHeader/fpml:swReplacementTradeId/fpml:swTradeId"/>
<xsl:copy-of select="fpml:swHeader/fpml:swReplacementTradeId/fpml:swTradeIdType"/>
<xsl:copy-of select="fpml:swHeader/fpml:swReplacementTradeId/fpml:swReplacementReason"/>
</swReplacementTradeId>
</xsl:if>
<xsl:apply-templates select="fpml:novation"/>
<xsl:apply-templates select="fpml:swAllocations"/>
<xsl:apply-templates select="fpml:swStructuredTradeDetails"/>
</swLongFormTrade>
<xsl:apply-templates select="fpml:swStructuredTradeDetails/fpml:swTradeEventReportingDetails"/>
</SWDML>
</xsl:template>
<xsl:template match="fpml:party[@id = 'branch1']"/>
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
<xsl:copy-of select="fpml:swAllocatedContraNotional"/>
<xsl:copy-of select="fpml:swAllocatedNumberOfOptions"/>
<xsl:copy-of select="fpml:swAllocatedVegaNotional"/>
<xsl:copy-of select="fpml:swAllocatedVarianceAmount"/>
<xsl:copy-of select="fpml:swFixedAmount"/>
<xsl:copy-of select="fpml:swContraFixedAmount"/>
<xsl:copy-of select="fpml:swVariableAmount"/>
<xsl:copy-of select="fpml:swIAExpected"/>
<xsl:copy-of select="fpml:independentAmount"/>
<xsl:copy-of select="fpml:additionalPayment"/>
<xsl:copy-of select="fpml:swPrivateTradeId"/>
<xsl:copy-of select="fpml:swSalesCredit"/>
<xsl:copy-of select="fpml:swAdditionalField"/>
<xsl:copy-of select="fpml:swClearingBroker"/>
<xsl:copy-of select="fpml:swNettingString"/>
<xsl:copy-of select="fpml:swAllocationReportingDetails[not(fpml:swJurisdiction='ASIC') and not(fpml:swJurisdiction='MAS')]"/>
<xsl:copy-of select="fpml:swIdentifiers"/>
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
<xsl:copy-of select="fpml:swNovatedAmount"/>
<xsl:copy-of select="fpml:novatedAmount/currency"/>
<xsl:copy-of select="fpml:swNovatedAmount/currency"/>
<xsl:copy-of select="fpml:swNovatedFV"/>
<xsl:copy-of select="fpml:fullFirstCalculationPeriod"/>
<xsl:copy-of select="fpml:nonReliance"/>
<xsl:copy-of select="fpml:swPreserveEarlyTerminationProvision"/>
<xsl:copy-of select="fpml:swCopyPremiumToNewTrade"/>
<xsl:copy-of select="fpml:swBilateralClearingHouse"/>
<xsl:copy-of select="swBulkAction"/>
<xsl:copy-of select="fpml:swFallbacksSupplement"/>
<xsl:copy-of select="fpml:swSwapRateFallbacksAmendment"/>
<xsl:copy-of select="fpml:payment"/>
<xsl:copy-of select="fpml:swBusinessConductDetails"/>
</novation>
</xsl:template>
<xsl:template match="fpml:swStructuredTradeDetails">
<swStructuredTradeDetails>
<xsl:copy-of select="fpml:swProductType"/>
<xsl:copy-of select="fpml:swParticipantSupplement"/>
<xsl:apply-templates select="fpml:FpML"/>
<xsl:copy-of select="fpml:swOfflineTrade"/>
<xsl:apply-templates select="fpml:swExtendedTradeDetails"/>
<xsl:apply-templates select="fpml:swBusinessConductDetails"/>
</swStructuredTradeDetails>
</xsl:template>
<xsl:template match="fpml:swOffsettingTradeId"/>
<xsl:template match="fpml:swCompressionType"/>
<xsl:template match="fpml:swExecutionMethod"/>
<xsl:template match="fpml:swExtendedTradeDetails">
<swExtendedTradeDetails>
<swTradeHeader>
<xsl:copy-of select="fpml:swTradeHeader/fpml:swManualConfirmationRequired"/>
<xsl:copy-of select="fpml:swTradeHeader/fpml:swNovationExecution"/>
<xsl:copy-of select="fpml:swTradeHeader/fpml:swClearingNotRequired"/>
<xsl:copy-of select="fpml:swTradeHeader/fpml:swStandardSettlementInstructions"/>
<xsl:copy-of select="fpml:swTradeHeader/fpml:swInteroperable"/>
<xsl:copy-of select="fpml:swTradeHeader/fpml:swExternalInteropabilityId"/>
<xsl:copy-of select="fpml:swTradeHeader/fpml:swInteropNettingString"/>
<xsl:copy-of select="fpml:swTradeHeader/fpml:swNormalised"/>
<xsl:copy-of select="fpml:swTradeHeader/fpml:swAutoSendForClearing"/>
<xsl:copy-of select="fpml:swTradeHeader/fpml:swCBClearedTimestamp"/>
<xsl:copy-of select="fpml:swTradeHeader/fpml:swCBTradeType"/>
<xsl:copy-of select="fpml:swTradeHeader/fpml:swMandatoryClearing"/>
<xsl:copy-of select="fpml:swTradeHeader/fpml:swClientClearing"/>
<xsl:copy-of select="fpml:swTradeHeader/fpml:swClearingHouse"/>
<xsl:copy-of select="fpml:swTradeHeader/fpml:swClearingBroker"/>
<xsl:copy-of select="fpml:swTradeHeader/fpml:swPartyClearingBroker"/>
<xsl:copy-of select="fpml:swTradeHeader/fpml:swExecutingBroker"/>
<xsl:copy-of select="fpml:swTradeHeader/fpml:swClearingClient"/>
<xsl:copy-of select="fpml:swTradeHeader/fpml:swClientFund"/>
<xsl:copy-of select="fpml:swTradeHeader/fpml:swPartyNettingString"/>
<xsl:copy-of select="fpml:swTradeHeader/fpml:swDataMigrationId"/>
<xsl:copy-of select="fpml:swTradeHeader/fpml:swClearedPhysicalSettlement"/>
<xsl:copy-of select="fpml:swTradeHeader/fpml:swPredeterminedClearerForUnderlyingSwap"/>
<xsl:copy-of select="fpml:swTradeHeader/fpml:swClearingTakeup"/>
<xsl:copy-of select="fpml:swTradeHeader/fpml:swBackLoadingFlag"/>
<xsl:copy-of select="fpml:swTradeHeader/fpml:swBulkAction"/>
<xsl:copy-of select="fpml:swTradeHeader/fpml:swOriginatingEvent"/>
<xsl:copy-of select="fpml:swTradeHeader/fpml:swSendToCLS"/>
<xsl:copy-of select="fpml:swTradeHeader/fpml:swESMAFrontloading"/>
<xsl:copy-of select="fpml:swTradeHeader/fpml:swESMAClearingExemption"/>
<xsl:copy-of select="fpml:swTradeHeader/fpml:swPricedToClearCCP"/>
<xsl:if test="//fpml:swTradeHeader/fpml:swUnderlyingSwapDetails/fpml:swClientClearing|//fpml:swTradeHeader/fpml:swUnderlyingSwapDetails/fpml:swAutoSendForClearing">
<swUnderlyingSwapDetails>
<xsl:copy-of select="fpml:swTradeHeader/fpml:swUnderlyingSwapDetails/fpml:swClientClearing"/>
<xsl:copy-of select="fpml:swTradeHeader/fpml:swUnderlyingSwapDetails/fpml:swAutoSendForClearing"/>
</swUnderlyingSwapDetails>
</xsl:if>
<xsl:copy-of select="fpml:swTradeHeader/fpml:swAutoCreateAffirmReleaseSwap"/>
<xsl:copy-of select="fpml:swTradeHeader/fpml:swConvertUnderlyingSwapToRFR"/>
</swTradeHeader>
<xsl:variable name="allPaymentDateIds">
<xsl:for-each select="//fpml:paymentDates/@id">
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:variable>
<xsl:if test="(contains($allPaymentDateIds,'Short') or contains($allPaymentDateIds,'Long'))">
<xsl:variable name="stub-position">
<xsl:choose>
<xsl:when test="//fpml:paymentDates/fpml:firstPaymentDate">Start</xsl:when>
<xsl:otherwise>End</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:choose>
<xsl:when test="//fpml:firstRegularPeriodStartDate and //fpml:lastRegularPeriodEndDate">
<xsl:variable name="fixedStubLengths">
<xsl:if test="(contains(//fpml:swapStream[@id='fixedLeg']/fpml:paymentDates/@id,'Long') or contains(//fpml:swapStream[@id='fixedLeg']/fpml:paymentDates/@id,'Short'))">
<xsl:value-of select="substring-after(//fpml:swapStream[@id='fixedLeg']/fpml:paymentDates/@id,'fixedLeg')"/>
</xsl:if>
</xsl:variable>
<xsl:variable name="fixedStubLengths2">
<xsl:if test="(contains(//fpml:swapStream[@id='fixedLeg2']/fpml:paymentDates/@id,'Long') or contains(//fpml:swapStream[@id='fixedLeg2']/fpml:paymentDates/@id,'Short'))">
<xsl:value-of select="substring-after(//fpml:swapStream[@id='fixedLeg2']/fpml:paymentDates/@id,'fixedLeg2')"/>
</xsl:if>
</xsl:variable>
<xsl:variable name="floatStubLengths">
<xsl:if test="(contains(//fpml:swapStream[@id='floatingLeg']/fpml:paymentDates/@id,'Long') or contains( //fpml:swapStream[@id='floatingLeg']/fpml:paymentDates/@id,'Short'))">
<xsl:value-of select="substring-after(//fpml:swapStream[@id='floatingLeg']/fpml:paymentDates/@id,'floatingLeg')"/>
</xsl:if>
</xsl:variable>
<swStub>
<swStubPosition>Start</swStubPosition>
<xsl:if test="(contains(//fpml:swapStream[@id='fixedLeg']/fpml:paymentDates/@id,'Long') or contains(//fpml:swapStream[@id='fixedLeg']/fpml:paymentDates/@id,'Short'))">
<swStubLength href="fixedLeg">
<xsl:choose>
<xsl:when test="contains($fixedStubLengths,'_')">
<xsl:value-of select="substring-before($fixedStubLengths,'_')"/>
</xsl:when>
<xsl:otherwise><xsl:value-of select="$fixedStubLengths"/></xsl:otherwise>
</xsl:choose>
</swStubLength>
</xsl:if>
<xsl:if test="(contains(//fpml:swapStream[@id='fixedLeg2']/fpml:paymentDates/@id,'Long') or contains(//fpml:swapStream[@id='fixedLeg2']/fpml:paymentDates/@id,'Short'))">
<swStubLength href="fixedLeg2">
<xsl:choose>
<xsl:when test="contains($fixedStubLengths2,'_')">
<xsl:value-of select="substring-before($fixedStubLengths2,'_')"/>
</xsl:when>
<xsl:otherwise><xsl:value-of select="$fixedStubLengths2"/></xsl:otherwise>
</xsl:choose>
</swStubLength>
</xsl:if>
<xsl:if test="(contains(//fpml:swapStream[@id='floatingLeg']/fpml:paymentDates/@id,'Long') or contains(//fpml:swapStream[@id='floatingLeg']/fpml:paymentDates/@id,'Short'))">
<swStubLength href="floatingLeg">
<xsl:choose>
<xsl:when test="contains($floatStubLengths,'_')">
<xsl:value-of select="substring-before($floatStubLengths,'_')"/>
</xsl:when>
<xsl:otherwise><xsl:value-of select="$floatStubLengths"/></xsl:otherwise>
</xsl:choose>
</swStubLength>
</xsl:if>
</swStub>
<swStub>
<swStubPosition>End</swStubPosition>
<xsl:if test="(contains(//fpml:swapStream[@id='fixedLeg']/fpml:paymentDates/@id,'Long') or contains(//fpml:swapStream[@id='fixedLeg']/fpml:paymentDates/@id,'Short'))">
<swStubLength href="fixedLeg">
<xsl:choose>
<xsl:when test="contains($fixedStubLengths,'_')">
<xsl:value-of select="substring-after($fixedStubLengths,'_')"/>
</xsl:when>
<xsl:otherwise><xsl:value-of select="$fixedStubLengths"/></xsl:otherwise>
</xsl:choose>
</swStubLength>
</xsl:if>
<xsl:if test="(contains(//fpml:swapStream[@id='fixedLeg2']/fpml:paymentDates/@id,'Long') or contains(//fpml:swapStream[@id='fixedLeg2']/fpml:paymentDates/@id,'Short'))">
<swStubLength href="fixedLeg2">
<xsl:choose>
<xsl:when test="contains($fixedStubLengths2,'_')">
<xsl:value-of select="substring-after($fixedStubLengths2,'_')"/>
</xsl:when>
<xsl:otherwise><xsl:value-of select="$fixedStubLengths2"/></xsl:otherwise>
</xsl:choose>
</swStubLength>
</xsl:if>
<xsl:if test="(contains(//fpml:swapStream[@id='floatingLeg']/fpml:paymentDates/@id,'Long') or contains(//fpml:swapStream[@id='floatingLeg']/fpml:paymentDates/@id,'Short'))">
<swStubLength href="floatingLeg">
<xsl:choose>
<xsl:when test="contains($floatStubLengths,'_')">
<xsl:value-of select="substring-after($floatStubLengths,'_')"/>
</xsl:when>
<xsl:otherwise><xsl:value-of select="$floatStubLengths"/></xsl:otherwise>
</xsl:choose>
</swStubLength>
</xsl:if>
</swStub>
</xsl:when>
<xsl:otherwise>
<swStub>
<swStubPosition>
<xsl:value-of select="$stub-position"/>
</swStubPosition>
<xsl:if test="(contains(//fpml:swapStream[@id='fixedLeg']/fpml:paymentDates/@id,'Long') or contains(//fpml:swapStream[@id='fixedLeg']/fpml:paymentDates/@id,'Short'))">
<swStubLength href="fixedLeg">
<xsl:value-of select="substring-after(//fpml:swapStream[@id='fixedLeg']/fpml:paymentDates/@id,'fixedLeg')"/>
</swStubLength>
</xsl:if>
<xsl:if test="(contains(//fpml:swapStream[@id='fixedLeg2']/fpml:paymentDates/@id,'Long') or contains(//fpml:swapStream[@id='fixedLeg2']/fpml:paymentDates/@id,'Short'))">
<swStubLength href="fixedLeg2">
<xsl:value-of select="substring-after(//fpml:swapStream[@id='fixedLeg2']/fpml:paymentDates/@id,'fixedLeg2')"/>
</swStubLength>
</xsl:if>
<xsl:if test="(contains( (//fpml:swapStream|//fpml:capFloorStream)[@id='floatingLeg']/fpml:paymentDates/@id,'Long') or contains( (//fpml:swapStream|//fpml:capFloorStream)[@id='floatingLeg']/fpml:paymentDates/@id,'Short'))">
<swStubLength href="floatingLeg">
<xsl:value-of select="substring-after((//fpml:swapStream|//fpml:capFloorStream)[@id='floatingLeg']/fpml:paymentDates/@id,'floatingLeg')"/>
</swStubLength>
</xsl:if>
<xsl:if test="(contains(//fpml:swapStream[@id='floatingLeg2']/fpml:paymentDates/@id,'Long') or contains(//fpml:swapStream[@id='floatingLeg2']/fpml:paymentDates/@id,'Short'))">
<swStubLength href="floatingLeg2">
<xsl:value-of select="substring-after(//fpml:swapStream[@id='floatingLeg2']/fpml:paymentDates/@id,'floatingLeg2')"/>
</swStubLength>
</xsl:if>
</swStub>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:copy-of select="fpml:swEarlyTerminationProvision"/>
<xsl:copy-of select="fpml:swAssociatedBonds"/>
<xsl:copy-of select="fpml:additionalPayment"/>
<xsl:copy-of select="fpml:swExitReason"/>
<xsl:copy-of select="fpml:swAmendmentType"/>
<xsl:copy-of select="fpml:swCancellationType"/>
<xsl:if test="//fpml:swForwardPremium = 'true'">
<swForwardPremium>true</swForwardPremium>
</xsl:if>
<xsl:copy-of select="fpml:swSettlementProvision"/>
<xsl:copy-of select="fpml:swInflationSwapDetails"/>
<xsl:copy-of select="fpml:swFutureValue"/>
<xsl:copy-of select="fpml:swModificationTradeDate"/>
<xsl:copy-of select="fpml:swModificationEffectiveDate"/>
<xsl:copy-of select="fpml:swOutsideNovation"/>
<xsl:copy-of select="fpml:swFxCutoffTime"/>
<xsl:copy-of select="fpml:swCrossCurrencyMethod"/>
<xsl:copy-of select="fpml:swCollateralizedCashPrice"/>
<xsl:apply-templates select="fpml:swSettlementAgent"/>
<xsl:apply-templates select="fpml:swOrderDetails[not(@href='broker' or @href='partyA' or @href='partyB')]"/>
<xsl:apply-templates select="fpml:swCapFloorDetails"/>
<xsl:copy-of select="fpml:swAgreedDiscountRate"/>
<xsl:copy-of select="fpml:swEconomicAmendmentType"/>
<xsl:copy-of select="fpml:swEconomicAmendmentReason"/>
<xsl:apply-templates select="fpml:calculationAgent"/>
<xsl:copy-of select="fpml:swSwapRateFallbacksAmendment"/>
</swExtendedTradeDetails>
</xsl:template>
<xsl:template match="calculationAgent">
<calculationAgent>
<xsl:copy-of select="calculationAgent"/>
</calculationAgent>
</xsl:template>
<xsl:template match="fpml:swSettlementAgent">
<xsl:if test="fpml:swSettlementAgency/fpml:partyId">
<swSettlementAgent>
<swSettlementAgency>
<xsl:copy-of select="fpml:swSettlementAgency/fpml:partyId"/>
</swSettlementAgency>
<xsl:copy-of select="fpml:swSettlementAgencyModel"/>
</swSettlementAgent>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:swTradeEventReportingDetails">
<swTradeEventReportingDetails>
<xsl:copy-of select="fpml:swUniqueTransactionId"/>
<xsl:apply-templates select="fpml:swReportingRegimeInformation"/>
<xsl:apply-templates select="fpml:swReportableProduct"/>
<xsl:if test="fpml:swNovationFeeTradeReportingDetails">
<swNovationFeeTradeReportingDetails>
<xsl:apply-templates select="fpml:swNovationFeeTradeReportingDetails/fpml:swReportingRegimeInformation"/>
</swNovationFeeTradeReportingDetails>
</xsl:if>
</swTradeEventReportingDetails>
</xsl:template>
<xsl:template match="fpml:swReportingRegimeInformation">
<swReportingRegimeInformation>
<xsl:copy-of select="fpml:swJurisdiction"/>
<xsl:copy-of select="fpml:swSupervisoryBodyCategory"/>
<xsl:copy-of select="fpml:swReportableLocations"/>
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
