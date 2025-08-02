<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="xml" encoding="iso-8859-1"/>
<xsl:template match="SWML">
<xsl:variable name="originator-href">
<xsl:value-of select="swHeader/swOriginatorPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="swdml-version">3-0</xsl:variable>
<SWDML version="{$swdml-version}">
<swLongFormTrade>
<swOriginatorPartyReference href="{$originator-href}"/>
<xsl:apply-templates select="swGiveUp"/>
<xsl:if test="swHeader/swReplacementTradeId">
<swReplacementTradeId>
<xsl:copy-of select="swHeader/swReplacementTradeId/swTradeId"/>
<xsl:copy-of select="swHeader/swReplacementTradeId/swTradeIdType"/>
<xsl:copy-of select="swHeader/swReplacementTradeId/swReplacementReason"/>
</swReplacementTradeId>
</xsl:if>
<xsl:apply-templates select="novation"/>
<xsl:apply-templates select="swAllocations"/>
<xsl:apply-templates select="swStructuredTradeDetails"/>
</swLongFormTrade>
<xsl:apply-templates select="swStructuredTradeDetails/swTradeEventReportingDetails"/>
</SWDML>
</xsl:template>
<xsl:template match="party[@id = 'branch1']"/>
<xsl:template match="swAllocations">
<swAllocations>
<xsl:apply-templates select="swAllocation"/>
</swAllocations>
</xsl:template>
<xsl:template match="swAllocation">
<swAllocation>
<xsl:copy-of select="./@directionReversed"/>
<xsl:copy-of select="tradeId"/>
<xsl:copy-of select="swStreamReference"/>
<xsl:copy-of select="payerPartyReference"/>
<xsl:copy-of select="receiverPartyReference"/>
<xsl:copy-of select="buyerPartyReference"/>
<xsl:copy-of select="sellerPartyReference"/>
<xsl:copy-of select="allocatedNotional"/>
<xsl:copy-of select="swFixedAmount"/>
<xsl:copy-of select="swIAExpected"/>
<xsl:copy-of select="independentAmount"/>
<xsl:copy-of select="additionalPayment"/>
<xsl:copy-of select="swPrivateTradeId"/>
<xsl:copy-of select="swSalesCredit"/>
<xsl:copy-of select="swAdditionalField"/>
<xsl:copy-of select="swClearingBroker"/>
<xsl:copy-of select="swNettingString"/>
<xsl:copy-of select="swAllocationReportingDetails[not(swJurisdiction='ASIC') and not(swJurisdiction='MAS')]"/>
<xsl:apply-templates select="swNexusReportingDetails"/>
<xsl:copy-of select="swCounterpartyCorporateSector"/>
</swAllocation>
</xsl:template>
<xsl:template match="swNexusReportingDetails">
<swNexusReportingDetails>
<xsl:copy-of select="swRelatedParty"/>
<xsl:copy-of select="swRelatedBusinessUnit"/>
<xsl:copy-of select="swRelatedPerson"/>
<xsl:apply-templates select="swPartyExtension"/>
<xsl:copy-of select="swAdditionalParty"/>
</swNexusReportingDetails>
</xsl:template>
<xsl:template match="swPartyExtension">
<xsl:variable name="partyHref" select="./@href"/>
<swPartyExtension href='{$partyHref}'>
<xsl:apply-templates select="swBusinessUnit"/>
<xsl:apply-templates select="swReferencedPerson"/>
</swPartyExtension>
</xsl:template>
<xsl:template match="swBusinessUnit">
<xsl:variable name="businessHref" select="./@id"/>
<swBusinessUnit id='{$businessHref}'>
<swCountry countryScheme="http://www.fpml.org/ext/iso3166">
<xsl:for-each select="swCountry">
<xsl:value-of select="."/>
<xsl:if test="../swCountry[position()=last()] != .">;</xsl:if>
</xsl:for-each>
</swCountry>
</swBusinessUnit>
</xsl:template>
<xsl:template match="swReferencedPerson">
<xsl:variable name="personHref" select="./@id"/>
<swReferencedPerson id='{$personHref}'>
<xsl:copy-of select="swName"/>
<xsl:if test="swCountry">
<swCountry countryScheme="http://www.fpml.org/ext/iso3166">
<xsl:for-each select="swCountry">
<xsl:value-of select="."/>
<xsl:if test="../swCountry[position()=last()] != .">;</xsl:if>
</xsl:for-each>
</swCountry>
</xsl:if>
</swReferencedPerson>
</xsl:template>
<xsl:template match="swGiveUp">
<swGiveUp>
<xsl:copy-of select="swEligiblePrimeBrokerTrade"/>
<xsl:apply-templates select="swCustomerTransaction"/>
<xsl:apply-templates select="swInterDealerTransaction"/>
<xsl:apply-templates select="swExecutingDealerCustomerTransaction"/>
</swGiveUp>
</xsl:template>
<xsl:template match="swCustomerTransaction">
<swCustomerTransaction>
<xsl:copy-of select="swCustomer"/>
<xsl:copy-of select="swPrimeBroker"/>
</swCustomerTransaction>
</xsl:template>
<xsl:template match="swInterDealerTransaction">
<swInterDealerTransaction>
<xsl:copy-of select="swExecutingDealer"/>
<xsl:copy-of select="swPrimeBroker"/>
</swInterDealerTransaction>
</xsl:template>
<xsl:template match="swExecutingDealerCustomerTransaction">
<swExecutingDealerCustomerTransaction>
<xsl:copy-of select="swExecutingDealer"/>
</swExecutingDealerCustomerTransaction>
</xsl:template>
<xsl:template match="novation">
<novation>
<xsl:copy-of select="transferor"/>
<xsl:copy-of select="transferee"/>
<xsl:copy-of select="remainingParty"/>
<xsl:copy-of select="otherRemainingParty"/>
<xsl:copy-of select="novationDate"/>
<xsl:copy-of select="novationTradeDate"/>
<xsl:copy-of select="novatedAmount"/>
<xsl:copy-of select="swNovatedAmount"/>
<xsl:copy-of select="swNovatedFV"/>
<xsl:copy-of select="fullFirstCalculationPeriod"/>
<xsl:copy-of select="nonReliance"/>
<xsl:copy-of select="swPreserveEarlyTerminationProvision"/>
<xsl:copy-of select="swCopyPremiumToNewTrade"/>
<xsl:copy-of select="swBilateralClearingHouse"/>
<xsl:copy-of select="swBulkAction"/>
<xsl:copy-of select="swFallbacksSupplement"/>
<xsl:copy-of select="payment"/>
<xsl:copy-of select="swBusinessConductDetails"/>
</novation>
</xsl:template>
<xsl:template match="swStructuredTradeDetails">
<swStructuredTradeDetails>
<xsl:copy-of select="swProductType"/>
<xsl:copy-of select="swParticipantSupplement"/>
<xsl:apply-templates select="FpML"/>
<xsl:apply-templates select="swBusinessConductDetails"/>
<xsl:apply-templates select="swExtendedTradeDetails"/>
</swStructuredTradeDetails>
</xsl:template>
<xsl:template match="swExecutionMethod"/>
<xsl:template match="swOffsettingTradeId"/>
<xsl:template match="swCompressionType"/>
<xsl:template match="swExtendedTradeDetails">
<swExtendedTradeDetails>
<swTradeHeader>
<xsl:copy-of select="swTradeHeader/swManualConfirmationRequired"/>
<xsl:copy-of select="swTradeHeader/swNovationExecution"/>
<xsl:copy-of select="swTradeHeader/swMasterAgreementType"/>
<xsl:copy-of select="swTradeHeader/swContractualDefinitions"/>
<xsl:copy-of select="swTradeHeader/swClearingNotRequired"/>
<xsl:copy-of select="swTradeHeader/swStandardSettlementInstructions"/>
<xsl:copy-of select="swTradeHeader/swInteroperable"/>
<xsl:copy-of select="swTradeHeader/swExternalInteropabilityId"/>
<xsl:copy-of select="swTradeHeader/swInteropNettingString"/>
<xsl:copy-of select="swTradeHeader/swNormalised"/>
<xsl:copy-of select="swTradeHeader/swAutoSendForClearing"/>
<xsl:copy-of select="swTradeHeader/swCBClearedTimestamp"/>
<xsl:copy-of select="swTradeHeader/swCBTradeType"/>
<xsl:copy-of select="swTradeHeader/swMandatoryClearing"/>
<xsl:copy-of select="swTradeHeader/swClientClearing"/>
<xsl:copy-of select="swTradeHeader/swClearingHouse"/>
<xsl:copy-of select="swTradeHeader/swPartyClearingBroker"/>
<xsl:copy-of select="swTradeHeader/swClearingBroker"/>
<xsl:copy-of select="swTradeHeader/swPartyNettingString"/>
<xsl:copy-of select="swTradeHeader/swDataMigrationId"/>
<xsl:copy-of select="swTradeHeader/swClearedPhysicalSettlement"/>
<xsl:copy-of select="swTradeHeader/swPredeterminedClearerForUnderlyingSwap"/>
<xsl:copy-of select="swTradeHeader/swClearingTakeup"/>
<xsl:copy-of select="swTradeHeader/swBackLoadingFlag"/>
<xsl:copy-of select="swTradeHeader/swBulkAction"/>
<xsl:copy-of select="swTradeHeader/swOriginatingEvent"/>
<xsl:copy-of select="swTradeHeader/swESMAFrontloading"/>
<xsl:copy-of select="swTradeHeader/swESMAClearingExemption"/>
<xsl:copy-of select="swTradeHeader/swPricedToClearCCP"/>
<xsl:if test="//swTradeHeader/swUnderlyingSwapDetails/swClientClearing|//swTradeHeader/swUnderlyingSwapDetails/swAutoSendForClearing">
<swUnderlyingSwapDetails>
<xsl:copy-of select="swTradeHeader/swUnderlyingSwapDetails/swClientClearing"/>
<xsl:copy-of select="swTradeHeader/swUnderlyingSwapDetails/swAutoSendForClearing"/>
</swUnderlyingSwapDetails>
</xsl:if>
</swTradeHeader>
<xsl:variable name="allPaymentDateIds">
<xsl:for-each select="//paymentDates/@id">
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:variable>
<xsl:if test="(contains($allPaymentDateIds,'Short') or contains($allPaymentDateIds,'Long'))">
<xsl:variable name="stub-position">
<xsl:choose>
<xsl:when test="//paymentDates/firstPaymentDate">Start</xsl:when>
<xsl:otherwise>End</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:choose>
<xsl:when test="//firstRegularPeriodStartDate and //lastRegularPeriodEndDate">
<xsl:variable name="fixedStubLengths">
<xsl:if test="(contains(//swapStream[@id='fixedLeg']/paymentDates/@id,'Long') or contains(//swapStream[@id='fixedLeg']/paymentDates/@id,'Short'))">
<xsl:value-of select="substring-after(//swapStream[@id='fixedLeg']/paymentDates/@id,'fixed')"/>
</xsl:if>
</xsl:variable>
<xsl:variable name="floatStubLengths">
<xsl:if test="(contains(//swapStream[@id='floatingLeg']/paymentDates/@id,'Long') or contains( //swapStream[@id='floatingLeg']/paymentDates/@id,'Short'))">
<xsl:value-of select="substring-after(//swapStream[@id='floatingLeg']/paymentDates/@id,'floating')"/>
</xsl:if>
</xsl:variable>
<swStub>
<swStubPosition>Start</swStubPosition>
<xsl:if test="(contains(//swapStream[@id='fixedLeg']/paymentDates/@id,'Long') or contains(//swapStream[@id='fixedLeg']/paymentDates/@id,'Short'))">
<swStubLength href="#fixedLeg">
<xsl:choose>
<xsl:when test="contains($fixedStubLengths,'_')">
<xsl:value-of select="substring-before($fixedStubLengths,'_')"/>
</xsl:when>
<xsl:otherwise><xsl:value-of select="$fixedStubLengths"/></xsl:otherwise>
</xsl:choose>
</swStubLength>
</xsl:if>
<swStubLength href="#floatingLeg">
<xsl:choose>
<xsl:when test="contains($floatStubLengths,'_')">
<xsl:value-of select="substring-before($floatStubLengths,'_')"/>
</xsl:when>
<xsl:otherwise><xsl:value-of select="$floatStubLengths"/></xsl:otherwise>
</xsl:choose>
</swStubLength>
</swStub>
<swStub>
<swStubPosition>End</swStubPosition>
<xsl:if test="(contains(//swapStream[@id='fixedLeg']/paymentDates/@id,'Long') or contains(//swapStream[@id='fixedLeg']/paymentDates/@id,'Short'))">
<swStubLength href="#fixedLeg">
<xsl:choose>
<xsl:when test="contains($fixedStubLengths,'_')">
<xsl:value-of select="substring-after($fixedStubLengths,'_')"/>
</xsl:when>
<xsl:otherwise><xsl:value-of select="$fixedStubLengths"/></xsl:otherwise>
</xsl:choose>
</swStubLength>
</xsl:if>
<swStubLength href="#floatingLeg">
<xsl:choose>
<xsl:when test="contains($floatStubLengths,'_')">
<xsl:value-of select="substring-after($floatStubLengths,'_')"/>
</xsl:when>
<xsl:otherwise><xsl:value-of select="$floatStubLengths"/></xsl:otherwise>
</xsl:choose>
</swStubLength>
</swStub>
</xsl:when>
<xsl:otherwise>
<swStub>
<swStubPosition>
<xsl:value-of select="$stub-position"/>
</swStubPosition>
<xsl:if test="(contains(//swapStream[@id='fixedLeg']/paymentDates/@id,'Long') or contains(//swapStream[@id='fixedLeg']/paymentDates/@id,'Short'))">
<swStubLength href="#fixedLeg">
<xsl:value-of select="substring-after(//swapStream[@id='fixedLeg']/paymentDates/@id,'fixed')"/>
</swStubLength>
</xsl:if>
<xsl:if test="(contains( (//swapStream|//capFloorStream)[@id='floatingLeg']/paymentDates/@id,'Long') or contains( (//swapStream|//capFloorStream)[@id='floatingLeg']/paymentDates/@id,'Short'))">
<swStubLength href="#floatingLeg">
<xsl:value-of select="substring-after((//swapStream|//capFloorStream)[@id='floatingLeg']/paymentDates/@id,'floating')"/>
</swStubLength>
</xsl:if>
</swStub>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:copy-of select="swEarlyTerminationProvision"/>
<xsl:copy-of select="swBondClauses"/>
<xsl:copy-of select="swAssociatedBonds"/>
<xsl:copy-of select="additionalPayment"/>
<xsl:copy-of select="swExitReason"/>
<xsl:copy-of select="swAmendmentType"/>
<xsl:copy-of select="swCancellationType"/>
<xsl:if test="//swForwardPremium = 'true'">
<swForwardPremium>true</swForwardPremium>
</xsl:if>
<xsl:copy-of select="swModificationTradeDate"/>
<xsl:copy-of select="swModificationEffectiveDate"/>
<xsl:copy-of select="swSettlementProvision"/>
<xsl:copy-of select="swFutureValue"/>
<xsl:copy-of select="swOutsideNovation"/>
<xsl:copy-of select="swCollateralizedCashPrice"/>
<xsl:apply-templates select="swSettlementAgent"/>
<xsl:apply-templates select="swOrderDetails[not(@href='#broker' or @href='#partyA' or @href='#partyB')]"/>
<xsl:copy-of select="swAgreedDiscountRate"/>
<xsl:copy-of select="swEconomicAmendmentType"/>
<xsl:copy-of select="swEconomicAmendmentReason"/>
</swExtendedTradeDetails>
</xsl:template>
<xsl:template match="swSettlementAgent">
<xsl:if test="swSettlementAgency/partyId">
<swSettlementAgent>
<swSettlementAgency>
<xsl:copy-of select="swSettlementAgency/partyId"/>
</swSettlementAgency>
<xsl:copy-of select="swSettlementAgencyModel"/>
</swSettlementAgent>
</xsl:if>
</xsl:template>
<xsl:template match="swTradeEventReportingDetails">
<swTradeEventReportingDetails>
<xsl:copy-of select="swUniqueTransactionId"/>
<xsl:apply-templates select="swReportingRegimeInformation"/>
<xsl:apply-templates select="swReportableProduct"/>
<xsl:if test="swNovationFeeTradeReportingDetails">
<swNovationFeeTradeReportingDetails>
<xsl:apply-templates select="swNovationFeeTradeReportingDetails/swReportingRegimeInformation"/>
</swNovationFeeTradeReportingDetails>
</xsl:if>
</swTradeEventReportingDetails>
</xsl:template>
<xsl:template match="swReportingRegimeInformation">
<swReportingRegimeInformation>
<xsl:copy-of select="swJurisdiction"/>
<xsl:copy-of select="swReportableLocations"/>
<xsl:copy-of select="swUniqueTransactionId"/>
<xsl:copy-of select="swObligatoryReporting"/>
<xsl:copy-of select="swReportingCounterpartyReference"/>
<xsl:copy-of select="swReportTo[not(swPartyReference/@href='#broker')]"/>
<xsl:copy-of select="swMandatoryClearingIndicator"/>
<xsl:copy-of select="swToTV"/>
</swReportingRegimeInformation>
</xsl:template>
<xsl:template match="@*|node()">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>
</xsl:stylesheet>
