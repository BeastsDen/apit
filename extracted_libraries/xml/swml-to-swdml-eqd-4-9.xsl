<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:fpml="http://www.fpml.org/2010/FpML-4-9" xmlns="http://www.fpml.org/2010/FpML-4-9"  exclude-result-prefixes="fpml" version="1.0">
<xsl:output method="xml" encoding="iso-8859-1"/>
<xsl:variable name="docsType">
<xsl:value-of select="//fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType"/>
<xsl:value-of select="//fpml:FpML/fpml:trade/fpml:documentation/fpml:contractualMatrix/fpml:matrixTerm"/>
</xsl:variable>
<xsl:variable name="productType">
<xsl:value-of select="//fpml:swStructuredTradeDetails/fpml:swProductType"/>
</xsl:variable>
<xsl:variable name="universalType">
<xsl:choose>
<xsl:when test="($productType='Equity Share Option Universal' or $productType='Equity Index Option Universal')">Equity Option Universal</xsl:when>
<xsl:otherwise>Non Universal</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:template match="fpml:SWML">
<xsl:variable name="originator-href">
<xsl:value-of select="fpml:swHeader/fpml:swOriginatorPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="swdml-version">4-9</xsl:variable>
<SWDML version="{$swdml-version}" xmlns="http://www.fpml.org/2010/FpML-4-9" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.fpml.org/2010/FpML-4-9 swdml-eqd-main-4-9.xsd">
<swLongFormTrade>
<swOriginatorPartyReference href="{$originator-href}"/>
<xsl:apply-templates select="fpml:swGiveUp"/>
<xsl:apply-templates select="fpml:novation"/>
<xsl:apply-templates select="fpml:swAllocations"/>
<xsl:copy-of select="fpml:swBackLoadingFlag"/>
<xsl:copy-of select="fpml:swMigrationReference"/>
<xsl:if test="$universalType = 'Equity Option Universal' or $productType = 'Equity Share Option' or $productType = 'Equity Index Option' ">
<xsl:copy-of select="fpml:swComplianceElection"/>
</xsl:if>
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
<xsl:copy-of select="*[name() != 'swNexusReportingDetails' and name() != 'swCounterpartyCorporateSector']"/>
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
<xsl:template match="fpml:equity">
<equity>
<xsl:copy-of select="fpml:instrumentId[1]"/>
<xsl:if test="$docsType = 'ISDA2008EquityJapanese' or $universalType = 'Equity Option Universal' or $docsType = 'ISDA2010EquityEMEAInterdealer' ">
<xsl:copy-of select="fpml:currency"/>
</xsl:if>
<xsl:if test="$universalType = 'Equity Option Universal' ">
<xsl:copy-of select="fpml:exchangeId"/>
</xsl:if>
<xsl:apply-templates select="fpml:relatedExchangeId"/>
</equity>
</xsl:template>
<xsl:template match="fpml:equityExercise">
<xsl:if test="$productType != 'Equity Accumulator' or $productType != 'Equity Decumulator'">
<equityExercise>
<xsl:copy-of select="fpml:equityAmericanExercise"/>
<xsl:copy-of select="fpml:equityEuropeanExercise"/>
<xsl:copy-of select="fpml:equityBermudaExercise"/>
<xsl:copy-of select="fpml:automaticExercise"/>
<xsl:apply-templates select="fpml:equityValuation"/>
<xsl:copy-of select="fpml:settlementDate"/>
<xsl:copy-of select="fpml:settlementCurrency"/>
<xsl:copy-of select="fpml:settlementType"/>
<xsl:copy-of select="fpml:settlementMethodElectionDate"/>
<xsl:copy-of select="fpml:settlementMethodElectingPartyReference"/>
</equityExercise>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:equityOptionTransactionSupplement">
<equityOptionTransactionSupplement>
<xsl:copy-of select="fpml:buyerPartyReference"/>
<xsl:copy-of select="fpml:sellerPartyReference"/>
<xsl:copy-of select="fpml:optionType"/>
<xsl:copy-of select="fpml:equityEffectiveDate"/>
<xsl:apply-templates select="fpml:underlyer"/>
<xsl:copy-of select="fpml:notional"/>
<xsl:apply-templates select="fpml:equityExercise"/>
<xsl:copy-of select="fpml:feature"/>
<xsl:copy-of select="fpml:fxFeature"/>
<xsl:copy-of select="fpml:strategyFeature"/>
<xsl:copy-of select="fpml:strike"/>
<xsl:copy-of select="fpml:spotPrice"/>
<xsl:copy-of select="fpml:numberOfOptions"/>
<xsl:copy-of select="fpml:equityPremium"/>
<xsl:copy-of select="fpml:exchangeLookAlike"/>
<xsl:copy-of select="fpml:exchangeTradedContractNearest"/>
<xsl:copy-of select="fpml:multipleExchangeIndexAnnexFallback"/>
<xsl:copy-of select="fpml:componentSecurityIndexAnnexFallback"/>
<xsl:if test="$docsType='EquityOptionEuropePrivate' or $docsType='2004EquityEuropeanInterdealer' or $docsType='ISDA2007EquityEuropean' or $universalType = 'Equity Option Universal' ">
<xsl:copy-of select="fpml:methodOfAdjustment"/>
</xsl:if>
<xsl:copy-of select="fpml:localJurisdiction"/>
<xsl:copy-of select="fpml:optionEntitlement"/>
<xsl:if test="not(fpml:optionEntitlement)">
<xsl:copy-of select="//fpml:swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swEquityOptionDetails/fpml:optionEntitlement"/>
</xsl:if>
<xsl:copy-of select="fpml:multiplier"/>
<xsl:if test="$universalType = 'Equity Option Universal' or $docsType ='ISDA2010EquityEMEAInterdealer'  or $docsType='EquityOptionEMEAPrivate'">
<xsl:copy-of select="fpml:extraordinaryEvents"/>
</xsl:if>
</equityOptionTransactionSupplement>
</xsl:template>
<xsl:template match="fpml:equitySwapTransactionSupplement">
<equitySwapTransactionSupplement>
<xsl:copy-of select="fpml:buyerPartyReference"/>
<xsl:copy-of select="fpml:sellerPartyReference"/>
<xsl:apply-templates select="fpml:varianceLeg"/>
<xsl:apply-templates select="fpml:interestLeg"/>
<xsl:apply-templates select="fpml:returnLeg"/>
<xsl:copy-of select="fpml:optionalEarlyTermination"/>
<xsl:copy-of select="fpml:breakFundingRecovery"/>
<xsl:copy-of select="fpml:breakFeeElection"/>
<xsl:copy-of select="fpml:breakFeeRate"/>
<xsl:copy-of select="fpml:extraordinaryEvents"/>
<xsl:copy-of select="fpml:mutualEarlyTermination"/>
<xsl:copy-of select="fpml:methodOfAdjustment"/>
<xsl:copy-of select="fpml:multipleExchangeIndexAnnexFallback"/>
<xsl:copy-of select="fpml:componentSecurityIndexAnnexFallback"/>
<xsl:copy-of select="fpml:localJurisdiction"/>
<xsl:copy-of select="fpml:relevantJurisdiction"/>
</equitySwapTransactionSupplement>
</xsl:template>
<xsl:template match="fpml:dividendSwapTransactionSupplement">
<dividendSwapTransactionSupplement>
<xsl:apply-templates select="fpml:dividendLeg"/>
<xsl:apply-templates select="fpml:fixedLeg"/>
</dividendSwapTransactionSupplement>
</xsl:template>
<xsl:template match="fpml:varianceSwapTransactionSupplement">
<varianceSwapTransactionSupplement>
<xsl:apply-templates select="fpml:varianceLeg"/>
<xsl:copy-of select="fpml:multipleExchangeIndexAnnexFallback"/>
</varianceSwapTransactionSupplement>
</xsl:template>
<xsl:template match="fpml:equityValuation">
<equityValuation>
<xsl:copy-of select="./@id"/>
<xsl:copy-of select="fpml:valuationDate"/>
<xsl:copy-of select="fpml:valuationDates"/>
<xsl:copy-of select="fpml:valuationTimeType"/>
<xsl:copy-of select="fpml:valuationTime"/>
<xsl:copy-of select="fpml:valuationDate"/>
<xsl:copy-of select="fpml:futuresPriceValuation"/>
</equityValuation>
</xsl:template>
<xsl:template match="fpml:FpML">
<FpML version="4-9" xmlns="http://www.fpml.org/2010/FpML-4-9" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="DataDocument">
<xsl:apply-templates select="fpml:trade"/>
<xsl:copy-of select="fpml:party"/>
</FpML>
</xsl:template>
<xsl:template match="fpml:index">
<index>
<xsl:copy-of select="fpml:instrumentId"/>
<xsl:copy-of select="fpml:currency"/>
<xsl:if test="$universalType = 'Equity Option Universal' ">
<xsl:copy-of select="fpml:exchangeId"/>
</xsl:if>
<xsl:apply-templates select="fpml:relatedExchangeId"/>
</index>
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
<xsl:copy-of select="fpml:novatedNumberOfOptions"/>
<xsl:copy-of select="fpml:novatedVarianceAmount"/>
<xsl:copy-of select="fpml:swNovatedVegaNotionalAmount"/>
<xsl:copy-of select="fpml:swNovatedUnits"/>
<xsl:copy-of select="fpml:fullFirstCalculationPeriod"/>
<xsl:copy-of select="fpml:nonReliance"/>
<xsl:copy-of select="fpml:swBilateralClearingHouse"/>
<xsl:copy-of select="fpml:payment"/>
<xsl:copy-of select="fpml:swBusinessConductDetails"/>
</novation>
</xsl:template>
<xsl:template match="fpml:relatedExchangeId">
<xsl:choose>
<xsl:when test="($docsType='ISDA2008EquityAsiaExcludingJapan' or 'EquityOptionAEJPrivate' or $docsType='ISDA2005EquityAsiaExcludingJapanInterdealer' or $docsType='ISDA2007VarianceSwapAsiaExcludingJapan') and //fpml:index/fpml:instrumentId[1]='.NSEI'">
<xsl:copy-of select="."/>
</xsl:when>
<xsl:when test="($docsType='ISDA2005EquityJapaneseInterdealer' and //fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:underlyer/fpml:singleUnderlyer/fpml:index) or $docsType='ISDA2006VarianceSwapJapaneseInterdealer'">
<xsl:copy-of select="."/>
</xsl:when>
<xsl:when test="$docsType='2004EquityEuropeanInterdealer' or $docsType='ISDA2007EquityEuropean' or $docsType='EquityOptionEuropePrivate' or $docsType='2005VarianceSwapEuropeanInterdealer' or $docsType='ISDA2007VarianceSwapEuropean'">
<xsl:copy-of select="."/>
</xsl:when>
<xsl:when test="$docsType='2006DividendSwapEuropeanInterdealer'">
<xsl:copy-of select="."/>
</xsl:when>
<xsl:when test="$docsType='DividendSwapEuropeanPrivate'">
<xsl:copy-of select="."/>
</xsl:when>
<xsl:when test="$docsType='ISDA2007DispersionVarianceSwapEuropean'">
<xsl:copy-of select="."/>
</xsl:when>
<xsl:when test="$docsType='ISDA2008EquityAmericas' or $docsType='ISDA2009EquityAmericas' or $docsType='EquityOptionAmericasPrivate' ">
<xsl:copy-of select="."/>
</xsl:when>
<xsl:when test="$universalType='Equity Option Universal' ">
<xsl:copy-of select="."/>
</xsl:when>
<xsl:when test="$docsType='ISDA2010EquityEMEAInterdealer' or $docsType='EquityOptionEMEAPrivate' or (($docsType='ISDA2008EquityAsiaExcludingJapan' or $docsType='ISDA2008EquityJapanese') and //fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement)">
<xsl:copy-of select="."/>
</xsl:when>
<xsl:when test="$docsType='DividendSwapAmericasPrivate' or $docsType='2013DividendSwapAmericasInterdealer'">
<xsl:copy-of select="."/>
</xsl:when>
<xsl:when test="$docsType='EquityCliquetOptionPrivate' or $docsType='EquitySpreadOptionAmericasPrivate'">
<xsl:copy-of select="."/>
</xsl:when>
<xsl:when test="$docsType='VolatilitySwapEuropeanPrivate' or $docsType='VolatilitySwapAsiaExcludingJapanPrivate' or $docsType='VolatilitySwapAmericasPrivate' or $docsType='VolatilitySwapJapanesePrivate' or $docsType='IVS1OpenMarkets'">
<xsl:copy-of select="."/>
</xsl:when>
<xsl:when test="$docsType='DividendSwapAsiaExcludingJapanPrivate' or $docsType='2014DividendSwapAsiaExcludingJapanInterdealer'">
<xsl:copy-of select="."/>
</xsl:when>
</xsl:choose>
</xsl:template>
<xsl:template match="fpml:singleUnderlyer">
<singleUnderlyer>
<xsl:apply-templates select="fpml:equity"/>
<xsl:apply-templates select="fpml:index"/>
<xsl:copy-of select="fpml:openUnits"/>
</singleUnderlyer>
</xsl:template>
<xsl:template match="fpml:swCustomerTransaction">
<swCustomerTransaction>
<xsl:copy-of select="fpml:swCustomer"/>
<xsl:copy-of select="fpml:swPrimeBroker"/>
</swCustomerTransaction>
</xsl:template>
<xsl:template match="fpml:swEquityOptionDetails">
<swEquityOptionDetails>
<xsl:copy-of select="fpml:numberOfShares"/>
<xsl:copy-of select="fpml:swCap"/>
<xsl:copy-of select="fpml:swCapPercentage"/>
<xsl:copy-of select="fpml:swFloor"/>
<xsl:copy-of select="fpml:swFloorPercentage"/>
<xsl:if test="$universalType = 'Equity Option Universal' ">
<xsl:copy-of select="fpml:swDesignatedContract"/>
</xsl:if>
<xsl:copy-of select="fpml:swDeltaCross"/>
<xsl:copy-of select="fpml:swEquityValuationMethod"/>
<xsl:copy-of select="fpml:swDefaultSettlementMethod"/>
<xsl:if test="$universalType = 'Equity Option Universal' ">
<xsl:copy-of select="fpml:swSettlementMethodElectionParty"/>
<xsl:copy-of select="fpml:swCashSettlementType"/>
<xsl:copy-of select="fpml:swFxDeterminationMethod"/>
<xsl:copy-of select="fpml:swFxSource"/>
</xsl:if>
<xsl:if test="$universalType = 'Non Universal' ">
<xsl:copy-of select="fpml:swFxDeterminationMethod"/>
</xsl:if>
<xsl:copy-of select="fpml:swReferenceFXRate"/>
<xsl:copy-of select="fpml:swEquityOptionPercentInput"/>
<xsl:copy-of select="fpml:swAveragingDates"/>
<xsl:copy-of select="fpml:swBermudaExercise"/>
<xsl:copy-of select="fpml:swEquityOptionStrategy"/>
<xsl:if test="$universalType = 'Equity Option Universal' ">
<xsl:copy-of select="fpml:swSettlementPriceDefaultElection"/>
</xsl:if>
<xsl:if test="$productType='Equity Share Option' and $docsType = 'ISDA2008EquityAsiaExcludingJapan'">
<xsl:copy-of select="fpml:swSettlementPriceDefaultElection"/>
</xsl:if>
<xsl:if test="$productType='Equity Share Option' or  $productType='Equity Index Option'">
<xsl:apply-templates select="fpml:swObservationDate"/>
</xsl:if>
</swEquityOptionDetails>
</xsl:template>
<xsl:template match="fpml:swDispersionVarianceSwapDetails">
<swDispersionVarianceSwapDetails>
<xsl:copy-of select="fpml:swLegComponentDetails"/>
</swDispersionVarianceSwapDetails>
</xsl:template>
<xsl:template match="fpml:swVarianceSwapDetails">
<swVarianceSwapDetails>
<xsl:copy-of select="fpml:volatilityStrikePrice"/>
<xsl:copy-of select="fpml:swTotalVarianceCap"/>
<xsl:copy-of select="fpml:swTotalVolatilityCap"/>
<xsl:copy-of select="fpml:swExpectedNOverride"/>
<xsl:copy-of select="fpml:swSettlementCurrencyVegaNotionalAmount"/>
<xsl:copy-of select="fpml:swVegaFxSpotRate"/>
<xsl:copy-of select="fpml:swVarianceSwapHolidayDate"/>
<xsl:copy-of select="fpml:swFxDeterminationMethod"/>
</swVarianceSwapDetails>
</xsl:template>
<xsl:template match="fpml:swVolatilitySwapDetails">
<swVolatilitySwapDetails>
<xsl:copy-of select="fpml:volatilityStrikePrice"/>
<xsl:copy-of select="fpml:swTotalVolatilityCap"/>
<xsl:copy-of select="fpml:swExpectedNOverride"/>
<xsl:copy-of select="fpml:swSettlementCurrencyVegaNotionalAmount"/>
<xsl:copy-of select="fpml:swVegaFxSpotRate"/>
<xsl:copy-of select="fpml:swVolatilitySwapHolidayDate"/>
<xsl:copy-of select="fpml:swFxDeterminationMethod"/>
</swVolatilitySwapDetails>
</xsl:template>
<xsl:template match="//fpml:SWML/fpml:swHeader">
<xsl:if test="//fpml:SWML/fpml:swHeader/fpml:swAmendmentType = 'CorporateAction'">
<xsl:copy-of select="fpml:swAmendmentType"/>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:swOffsettingTradeId"/>
<xsl:template match="fpml:swCompressionType"/>
<xsl:template match="fpml:swExecutionMethod"/>
<xsl:template match="fpml:swOTVConfirmation"/>
<xsl:template match="fpml:swIntroducingBroker"/>
<xsl:template match="fpml:swExtendedTradeDetails">
<swExtendedTradeDetails>
<xsl:apply-templates select="fpml:swTradeHeader"/>
<xsl:copy-of select="fpml:swDocsSelection"/>
<xsl:apply-templates select="//fpml:SWML/fpml:swHeader"/>
<xsl:copy-of select="fpml:swExitReason"/>
<xsl:copy-of select="fpml:swIndependentAmountPercentage"/>
<xsl:copy-of select="fpml:swNovationReporting"/>
<xsl:apply-templates select="fpml:swEquityOptionDetails"/>
<xsl:apply-templates select="fpml:swVarianceSwapDetails"/>
<xsl:apply-templates select="fpml:swVolatilitySwapDetails"/>
<xsl:apply-templates select="fpml:swDividendSwapDetails"/>
<xsl:apply-templates select="fpml:swEquitySwapDetails"/>
<xsl:apply-templates select="fpml:swBasketSwapDetails"/>
<xsl:apply-templates select="fpml:swDispersionVarianceSwapDetails"/>
<xsl:copy-of select="fpml:swCorporateActionFlag"/>
<xsl:apply-templates select="fpml:swApplicableSideLetters"/>
<xsl:copy-of select="fpml:swChinaConnect"/>
<xsl:apply-templates select="fpml:swOrderDetails[not(@href='broker' or @href='partyA' or @href='partyB')]"/>
</swExtendedTradeDetails>
</xsl:template>
<xsl:template match="fpml:swGiveUp">
<swGiveUp>
<xsl:copy-of select="fpml:swEligiblePrimeBrokerTrade"/>
<xsl:apply-templates select="fpml:swCustomerTransaction"/>
<xsl:apply-templates select="fpml:swInterDealerTransaction"/>
</swGiveUp>
</xsl:template>
<xsl:template match="fpml:swInterDealerTransaction">
<swInterDealerTransaction>
<xsl:copy-of select="fpml:swExecutingDealer"/>
<xsl:copy-of select="fpml:swPrimeBroker"/>
</swInterDealerTransaction>
</xsl:template>
<xsl:template match="fpml:swStructuredTradeDetails">
<swStructuredTradeDetails>
<xsl:copy-of select="fpml:swProductType"/>
<xsl:copy-of select="fpml:swParticipantSupplement"/>
<xsl:apply-templates select="fpml:FpML"/>
<xsl:apply-templates select="fpml:swExtendedTradeDetails"/>
<xsl:apply-templates select="fpml:swBusinessConductDetails"/>
</swStructuredTradeDetails>
</xsl:template>
<xsl:template match="fpml:trade">
<trade>
<xsl:copy-of select="fpml:tradeHeader"/>
<xsl:apply-templates select="fpml:equityOptionTransactionSupplement"/>
<xsl:apply-templates select="fpml:equitySwapTransactionSupplement"/>
<xsl:apply-templates select="fpml:dividendSwapTransactionSupplement"/>
<xsl:apply-templates select="fpml:varianceSwapTransactionSupplement"/>
<xsl:apply-templates select="fpml:swVolatilitySwapTransactionSupplement"/>
<xsl:copy-of select="fpml:swEquityAccumulatorForwardShort"/>
<xsl:copy-of select="fpml:otherPartyPayment"/>
<xsl:apply-templates select="fpml:calculationAgent"/>
<xsl:copy-of select="fpml:determiningParty"/>
<xsl:copy-of select="fpml:hedgingParty"/>
<xsl:copy-of select="fpml:collateral"/>
<xsl:copy-of select="fpml:documentation"/>
</trade>
</xsl:template>
<xsl:template match="fpml:underlyer">
<underlyer>
<xsl:apply-templates select="fpml:singleUnderlyer"/>
<xsl:copy-of select="fpml:basket"/>
</underlyer>
</xsl:template>
<xsl:template match="fpml:varianceLeg">
<varianceLeg>
<xsl:choose>
<xsl:when test="$docsType='ISDA2007DispersionVarianceSwapEuropean'">
<xsl:copy-of select="fpml:legIdentifier"/>
<xsl:copy-of select="fpml:payerPartyReference"/>
<xsl:copy-of select="fpml:receiverPartyReference"/>
<xsl:apply-templates select="fpml:underlyer"/>
<xsl:copy-of select="fpml:settlementType"/>
<xsl:copy-of select="fpml:settlementDate"/>
<xsl:copy-of select="fpml:settlementCurrency"/>
<xsl:copy-of select="fpml:valuation"/>
<xsl:copy-of select="fpml:amount"/>
</xsl:when>
<xsl:otherwise>
<xsl:copy-of select="fpml:payerPartyReference"/>
<xsl:copy-of select="fpml:receiverPartyReference"/>
<xsl:copy-of select = "fpml:paymentFrequency"/>
<xsl:apply-templates select="fpml:underlyer"/>
<xsl:copy-of select="fpml:equityValuation"/>
<xsl:copy-of select="fpml:equityAmount"/>
</xsl:otherwise>
</xsl:choose>
</varianceLeg>
</xsl:template>
<xsl:template match="fpml:interestLeg">
<interestLeg legIdentifier="interestLeg">
<xsl:copy-of select="fpml:payerPartyReference"/>
<xsl:copy-of select="fpml:receiverPartyReference"/>
<xsl:copy-of select="fpml:interestLegCalculationPeriodDates"/>
<xsl:copy-of select="fpml:notional"/>
<xsl:copy-of select="fpml:interestAmount"/>
<xsl:copy-of select="fpml:interestCalculation"/>
</interestLeg>
</xsl:template>
<xsl:template match="fpml:returnLeg">
<returnLeg legIdentifier="returnLeg">
<xsl:copy-of select="fpml:payerPartyReference"/>
<xsl:copy-of select="fpml:receiverPartyReference"/>
<xsl:copy-of select="fpml:effectiveDate"/>
<xsl:copy-of select="fpml:terminationDate"/>
<xsl:copy-of select="fpml:strikeDate"/>
<xsl:copy-of select="fpml:underlyer"/>
<xsl:copy-of select="fpml:rateOfReturn"/>
<xsl:copy-of select="fpml:notional"/>
<xsl:copy-of select="fpml:amount"/>
<xsl:copy-of select="fpml:return"/>
<xsl:copy-of select="fpml:notionalAdjustments"/>
<xsl:if test="$docsType='ISDA2009EquitySwapPanAsia' and //fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:returnLeg/fpml:rateOfReturn/fpml:valuationPriceFinal/fpml:determinationMethod='Close'">
<xsl:copy-of select="fpml:fxFeature"/>
</xsl:if>
</returnLeg>
</xsl:template>
<xsl:template match="fpml:dividendLeg">
<dividendLeg id="dividendLeg">
<xsl:copy-of select="fpml:payerPartyReference"/>
<xsl:copy-of select="fpml:receiverPartyReference"/>
<xsl:apply-templates select="fpml:underlyer"/>
<xsl:copy-of select="fpml:settlementType"/>
<xsl:copy-of select="fpml:settlementCurrency"/>
<xsl:copy-of select="fpml:declaredCashDividendPercentage"/>
<xsl:copy-of select="fpml:declaredCashEquivalentDividendPercentage"/>
<xsl:copy-of select="fpml:dividendPeriod"/>
<xsl:copy-of select="fpml:specialDividends"/>
<xsl:copy-of select="fpml:materialDividend"/>
</dividendLeg>
</xsl:template>
<xsl:template match="fpml:fixedLeg">
<fixedLeg id="fixedLeg">
<xsl:copy-of select="fpml:payerPartyReference"/>
<xsl:copy-of select="fpml:receiverPartyReference"/>
<xsl:copy-of select="fpml:fixedPayment"/>
</fixedLeg>
</xsl:template>
<xsl:template match="fpml:swDividendSwapDetails">
<swDividendSwapDetails>
<xsl:copy-of select="fpml:swBreakOutTrade"/>
<xsl:copy-of select="fpml:swSplitCollateral"/>
<xsl:if test ="$docsType != 'ISDA2008DividendSwapJapan' and $docsType != 'ISDA2008DividendSwapJapaneseRev1'">
<xsl:copy-of select="fpml:swPeriodPaymentDate"/>
</xsl:if>
</swDividendSwapDetails>
</xsl:template>
<xsl:template match="fpml:swEquitySwapDetails">
<swEquitySwapDetails>
<xsl:copy-of select="fpml:swFullyFunded"/>
<xsl:copy-of select="fpml:swSpreadDetails"/>
<xsl:copy-of select="fpml:initialUnits"/>
<xsl:copy-of select="fpml:swMultiplier"/>
<xsl:copy-of select="fpml:swBulletIndicator"/>
<xsl:copy-of select="fpml:swInterestLegDriven"/>
<xsl:copy-of select="fpml:swSchedulingMethod"/>
<xsl:if test="fpml:swSchedulingMethod = 'ListDateEntry' ">
<xsl:copy-of select="fpml:swScheduleFrequencies"/>
</xsl:if>
<xsl:copy-of select="fpml:swStubControl"/>
<xsl:copy-of select="fpml:swEarlyFinalValuationDateElection"/>
<xsl:copy-of select="fpml:swEarlyTerminationElectingParty"/>
<xsl:copy-of select="fpml:swEarlyTerminationElectingPartyMethod"/>
<xsl:copy-of select="fpml:noticePeriod"/>
<xsl:copy-of select="fpml:swFixedRateIndicator"/>
<xsl:copy-of select="fpml:swOtherValuationBusinessCenter"/>
<xsl:copy-of select="fpml:swReferenceInitialPrice"/>
<xsl:copy-of select="fpml:swReferenceFXRate"/>
<xsl:copy-of select="fpml:swNotionalCurrency"/>
<xsl:copy-of select="fpml:swDeltaCross"/>
<xsl:copy-of select="fpml:swAveragingDatesIndicator"/>
<xsl:copy-of select="fpml:swAveragingDates2"/>
<xsl:copy-of select="fpml:swADTVIndicator"/>
<xsl:copy-of select="fpml:swStockLoanRateIndicator"/>
<xsl:copy-of select="fpml:swStockLoanRate"/>
<xsl:copy-of select="fpml:swAdditionalDisruptionEventIndicator"/>
<xsl:copy-of select="fpml:swFinalPriceFee"/>
<xsl:copy-of select="fpml:swFinalPriceFeeAmount"/>
<xsl:copy-of select="fpml:swRightToIncrease"/>
<xsl:copy-of select="fpml:swGrossPrice"/>
<xsl:copy-of select="fpml:swApplicableRegion"/>
<xsl:copy-of select="fpml:swDividendPercentageComponent"/>
<xsl:copy-of select="fpml:swBulletCompoundingSpread"/>
<xsl:copy-of select="fpml:swOverrideNotionalCalculation"/>
<xsl:copy-of select="fpml:swPaymentDaysOffset"/>
</swEquitySwapDetails>
</xsl:template>
<xsl:template match="fpml:swBasketSwapDetails">
<swBasketSwapDetails>
<xsl:copy-of select="fpml:swFullyFunded"/>
<xsl:copy-of select="fpml:swSpreadDetails"/>
<xsl:copy-of select="fpml:swSwapExchangeId"/>
<xsl:copy-of select="fpml:swOverrideNotionalCalculation"/>
<xsl:copy-of select="fpml:swInterestLegDriven"/>
<xsl:copy-of select="fpml:swBasketSubstitutionDetails"/>
<xsl:copy-of select="fpml:swReferencePrice"/>
<xsl:copy-of select="fpml:swStockLoanRate"/>
<xsl:copy-of select="fpml:swFinalPriceFee"/>
<xsl:copy-of select="fpml:swFinalPriceFeeAmount"/>
<xsl:copy-of select="fpml:swRightToIncrease"/>
<xsl:copy-of select="fpml:swEarlyFinalValuationDateElection"/>
<xsl:copy-of select="fpml:swEarlyTerminationElectingParty"/>
<xsl:copy-of select="fpml:swEarlyTerminationElectingPartyMethod"/>
<xsl:copy-of select="fpml:swDividendPercentageComponent"/>
<xsl:copy-of select="fpml:swBulletCompoundingSpread"/>
<xsl:copy-of select="fpml:swDeltaCross"/>
<xsl:copy-of select="fpml:swSchedulingMethod"/>
<xsl:if test="fpml:swSchedulingMethod = 'ListDateEntry' ">
<xsl:copy-of select="fpml:swScheduleFrequencies"/>
</xsl:if>
<xsl:copy-of select="fpml:swFixedRateIndicator"/>
<xsl:copy-of select="fpml:swAveragingDatesIndicator"/>
<xsl:copy-of select="fpml:swAveragingDates2"/>
<xsl:copy-of select="fpml:swPaymentDaysOffset"/>
</swBasketSwapDetails>
</xsl:template>
<xsl:template match="fpml:swTradeEventReportingDetails">
<swTradeEventReportingDetails>
<xsl:copy-of select="fpml:swUniqueTransactionId"/>
<xsl:apply-templates select="fpml:swReportingRegimeInformation"/>
<xsl:apply-templates select="fpml:swReportableProduct"/>
<xsl:if test="fpml:swNovationFeeTradeReportingDetails">
<swNovationFeeTradeReportingDetails>
<xsl:apply-templates select="fpml:swNovationFeeTradeReportingDetails/fpml:swReportingRegimeInformation"/>
<xsl:apply-templates select="fpml:swNovationFeeTradeReportingDetails/fpml:swReportableProduct"/>
</swNovationFeeTradeReportingDetails>
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
<xsl:template match="fpml:swReportingRegimeInformation[fpml:swJurisdiction = 'CAN']"/>
<xsl:template match="fpml:swReportableProduct">
<swReportableProduct>
<xsl:copy-of select="fpml:swSecondaryAssetClass"/>
<xsl:apply-templates select="fpml:swProductId"/>
<xsl:apply-templates select="fpml:swProductFullName"/>
</swReportableProduct>
</xsl:template>
<xsl:template match="@*|node()">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>
<xsl:template match="@*|node()">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>
<xsl:template match="fpml:calculationAgent">
<calculationAgent>
<xsl:copy-of select="fpml:calculationAgentPartyReference"/>
</calculationAgent>
</xsl:template>
</xsl:stylesheet>
