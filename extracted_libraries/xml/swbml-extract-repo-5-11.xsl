<xsl:stylesheet
version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:swml="http://www.markitserv.com/swml-5-11"
xmlns:fpml="http://www.fpml.org/FpML-5/confirmation"
xmlns:tx="http://www.markitserv.com/detail/Trade.xsl"
exclude-result-prefixes="fpml">
<xsl:import href="Trade.xsl"/>
<xsl:output method="xml" indent="yes"/>
<xsl:variable name="SWBML"                              select="/swml:SWBML"/>
<xsl:variable name="version"                            select="$SWBML/@version"/>
<xsl:variable name="swStructuredTradeDetails"           select="$SWBML/swml:swStructuredTradeDetails"/>
<xsl:variable name="swbHeader"                          select="$SWBML/swml:swbHeader"/>
<xsl:variable name="dataDocument"                       select="$swStructuredTradeDetails/fpml:dataDocument"/>
<xsl:variable name="trade"                              select="$dataDocument/fpml:trade"/>
<xsl:variable name="repo"                               select="$trade/fpml:repo"/>
<xsl:variable name="swExtendedTradeDetails"             select="$swStructuredTradeDetails/swml:swExtendedTradeDetails"/>
<xsl:variable name="swbTradeEventReportingDetails"      select="$SWBML/swml:swbTradeEventReportingDetails"/>
<xsl:variable name="productType">
<xsl:value-of select="string($swStructuredTradeDetails/swml:swProductType)"/>
</xsl:variable>
<xsl:variable name="currency">
<xsl:choose>
<xsl:when test="$productType='Repurchase' or $productType='BuySellback'">
<xsl:if test="$repo/fpml:nearLeg">
<xsl:value-of select="$repo/fpml:nearLeg/fpml:settlementAmount/fpml:currency"/>
</xsl:if>
</xsl:when>
</xsl:choose>
</xsl:variable>
<xsl:variable name="partyA">partyA</xsl:variable>
<xsl:variable name="partyB">partyB</xsl:variable>
<xsl:variable name="partyTripartyAgent">partyTripartyAgent</xsl:variable>
<xsl:variable name="idScheme">
<xsl:choose>
<xsl:when test="$repo//fpml:triParty//fpml:collateralProfile">
<xsl:value-of select="$repo//fpml:triParty//fpml:collateralProfile/@collateralProfileScheme"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$repo//fpml:instrumentId/@instrumentIdScheme"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="securityID">
<xsl:choose>
<xsl:when test="$repo//fpml:triParty//fpml:collateralProfile">
<xsl:value-of select="$repo//fpml:triParty//fpml:collateralProfile"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$repo//fpml:instrumentId"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:template match="/*">
<Trade version="5-11">
<SWBMLVersion>
<xsl:value-of select="$version"/>
</SWBMLVersion>
<BrokerSubmitted>true</BrokerSubmitted>
<BrokerTradeId>
<xsl:value-of select="$swbHeader/swml:swbBrokerTradeId"/>
</BrokerTradeId>
<TotalLegs/>
<BrokerLegId>
<xsl:value-of select="$swbHeader/swml:swbBrokerLegId"/>
</BrokerLegId>
<ReplacementTradeId/>
<ReplacementTradeIdType/>
<ReplacementReason/>
<StrategyType/>
<StrategyComment/>
<BrokerTradeVersionId/>
<LinkedTradeId/>
<TradeSource>
<xsl:choose>
<xsl:when test="$swbHeader/swml:swbTradeSource">
<xsl:value-of select="$swbHeader/swml:swbTradeSource"/>
</xsl:when>
<xsl:otherwise>Voice</xsl:otherwise>
</xsl:choose>
</TradeSource>
<MessageText/>
<AllocatedTrade>
<xsl:value-of select="string(boolean($SWBML/swml:swAllocations))"/>
</AllocatedTrade>
<xsl:if test="$SWBML/swml:swAllocations">
<xsl:call-template name="swml:swAllocations"/>
</xsl:if>
<EmptyBlockTrade>
<xsl:value-of select="string(boolean($SWBML/swml:swbBlockTrade))"/>
</EmptyBlockTrade>
<PrimeBrokerTrade>
<xsl:value-of select="string(boolean($SWBML/swml:swbGiveUp))"/>
</PrimeBrokerTrade>
<ReversePrimeBrokerLegalEntities/>
<xsl:apply-templates select="$swbHeader/swml:swbRecipient"/>
<PartyAId id="{$partyA}">
<xsl:value-of select="$dataDocument/fpml:party[@id=$partyA]/fpml:partyId"/>
</PartyAId>
<PartyAIdType>
<xsl:value-of select="$dataDocument/fpml:party[@id=$partyA]/fpml:partyId/@partyIdScheme"/>
</PartyAIdType>
<PartyAName>
<xsl:value-of select="$dataDocument/fpml:party[@id=$partyA]/fpml:partyName"/>
</PartyAName>
<PartyBId id="{$partyB}">
<xsl:value-of select="$dataDocument/fpml:party[@id=$partyB]/fpml:partyId"/>
</PartyBId>
<PartyBIdType>
<xsl:value-of select="$dataDocument/fpml:party[@id=$partyA]/fpml:partyId/@partyIdScheme"/>
</PartyBIdType>
<PartyBName>
<xsl:value-of select="$dataDocument/fpml:party[@id=$partyB]/fpml:partyName"/>
</PartyBName>
<PartyCId/>
<PartyCIdType/>
<PartyCName/>
<PartyDId/>
<PartyDIdType/>
<PartyDName/>
<PartyGId/>
<PartyGIdType/>
<PartyGName/>
<PartyHId id="partyH"/>
<PartyHIdType/>
<PartyHName/>
<PartyTripartyAgentId>
<xsl:value-of select="$dataDocument/fpml:party[@id=$partyTripartyAgent]/fpml:partyId"/>
</PartyTripartyAgentId>
<PartyTripartyAgentIdType>
<xsl:value-of select="$dataDocument/fpml:party[@id=$partyTripartyAgent]/fpml:partyId/@partyIdScheme"/>
</PartyTripartyAgentIdType>
<DeliveryByValue>
<xsl:value-of select="$repo/fpml:triParty/fpml:deliveryByValue"/>
</DeliveryByValue>
<BrokerAId id="broker"/>
<BrokerBId id="broker"/>
<NominalTerm/>
<FixedRatePayer/>
<FloatingRatePayer/>
<TradeDate>
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="$trade//fpml:tradeHeader/fpml:tradeDate"/>
</xsl:call-template>
</TradeDate>
<StartDate>
<xsl:variable name="startDate">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string($repo/fpml:nearLeg/fpml:settlementDate/fpml:adjustableDate/fpml:unadjustedDate)"/>
</xsl:call-template>
</xsl:variable>
<xsl:value-of select="$startDate"/>
</StartDate>
<FirstFixedPeriodStartDate/>
<FirstFloatPeriodStartDate/>
<FirstFloatPeriodStartDate_2/>
<EndDate>
<xsl:if test="$repo/fpml:farLeg/fpml:settlementDate/fpml:adjustableDate/fpml:unadjustedDate">
<xsl:variable name="endDate">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string($repo/fpml:farLeg/fpml:settlementDate/fpml:adjustableDate/fpml:unadjustedDate)"/>
</xsl:call-template>
</xsl:variable>
<xsl:value-of select="$endDate"/>
</xsl:if>
</EndDate>
<FixedPaymentFreq/>
<FloatPaymentFreq/>
<FloatPaymentFreq_2/>
<FloatRollFreq/>
<FloatRollFreq_2/>
<RollsType/>
<RollsMethod/>
<RollDay/>
<MonthEndRolls/>
<FirstPeriodStartDate/>
<FirstPaymentDate/>
<LastRegularPaymentDate/>
<FixedRate/>
<initialPoints/>
<quotationStyle/>
<RecoveryRate/>
<FixedSettlement/>
<Strike/>
<StrikePercentage/>
<StrikeDate/>
<Currency>
<xsl:value-of select="$currency"/>
</Currency>
<Currency_2/>
<Notional/>
<Notional_2/>
<InitialNotional/>
<FixedAmount/>
<FixedAmountCurrency/>
<FixedDayBasis/>
<FloatDayBasis/>
<FloatDayBasis_2/>
<FixedConvention/>
<FixedCalcPeriodDatesConvention/>
<FixedTerminationDateConvention/>
<FloatConvention/>
<FloatCalcPeriodDatesConvention/>
<FloatTerminationDateConvention/>
<FloatConvention_2/>
<FloatTerminationDateConvention_2/>
<FloatingRateIndex>
<xsl:if test="$repo/fpml:floatingRateCalculation/fpml:floatingRateIndex">
<xsl:value-of select="$repo/fpml:floatingRateCalculation/fpml:floatingRateIndex"/>
</xsl:if>
</FloatingRateIndex>
<xsl:if test="$repo/fpml:floatingRateCalculation/fpml:indexTenor">
<FloatingRateIndexTenor>
<xsl:value-of select="$repo/fpml:floatingRateCalculation/fpml:indexTenor/fpml:periodMultiplier"/>
<xsl:value-of select="$repo/fpml:floatingRateCalculation/fpml:indexTenor/fpml:period"/>
</FloatingRateIndexTenor>
</xsl:if>
<FloatingRateIndex_2/>
<InflationLag/>
<IndexSource/>
<InterpolationMethod/>
<InitialIndexLevel/>
<RelatedBond/>
<IndexTenor1/>
<LinearInterpolation/>
<NoStubLinearInterpolation/>
<NoStubLinearInterpolation2/>
<IndexTenor2/>
<SpreadOverIndex/>
<SpreadOverIndex_2/>
<FirstFixingRate/>
<FirstFixingRate_2/>
<FixingDaysOffset/>
<FixingDaysOffset_2/>
<FixingHolidayCentres/>
<FixingHolidayCentres_2/>
<ResetInArrears/>
<ResetInArrears_2/>
<FirstFixingDifferent/>
<FirstFixingDifferent_2/>
<FirstFixingDaysOffset/>
<FirstFixingDaysOffset_2/>
<FirstFixingHolidayCentres/>
<FirstFixingHolidayCentres_2/>
<PaymentHolidayCentres/>
<PaymentHolidayCentres_2/>
<PaymentLag/>
<PaymentLag_2/>
<RollHolidayCentres/>
<RollHolidayCentres_2/>
<AdjustFixedStartDate/>
<AdjustFloatStartDate/>
<AdjustFloatStartDate_2/>
<AdjustRollEnd/>
<AdjustFloatRollEnd/>
<AdjustFloatRollEnd_2/>
<AdjustFixedFinalRollEnd/>
<AdjustFinalRollEnd/>
<CompoundingMethod/>
<AveragingMethod/>
<FloatingRateMultiplier/>
<FloatingRateMultiplier_2/>
<DesignatedMaturity/>
<ResetFreq/>
<WeeklyRollConvention/>
<RateCutOffDays/>
<InitialExchange/>
<FinalExchange/>
<MarkToMarket/>
<IntermediateExchange/>
<MTMRateSource/>
<MTMRateSourcePage/>
<MTMFixingDate/>
<MTMFixingHolidayCentres/>
<MTMFixingTime/>
<MTMLocation/>
<MTMCutoffTime/>
<CalculationPeriodDays/>
<FraDiscounting/>
<NoBreak/>
<HasBreak/>
<BreakType/>
<BreakFirstDate/>
<BreakFrequency/>
<BreakOverride/>
<BreakDate/>
<ExchangeUnderlying/>
<SpreadCurrency/>
<SwapSpread/>
<BondId1/>
<BondName1/>
<BondAmount1/>
<BondPriceType1/>
<BondPrice1/>
<BondId2/>
<BondName2/>
<BondAmount2/>
<BondPriceType2/>
<BondPrice2/>
<StubAt/>
<FixedStub/>
<FloatStub/>
<FloatStub_2/>
<MasterAgreement/>
<ProductType>
<xsl:value-of select="$productType"/>
</ProductType>
<OptionType/>
<OptionExpirationDate/>
<OptionHolidayCentres/>
<OptionEarliestTime/>
<OptionExpiryTime/>
<OptionSpecificExpiryTime/>
<OptionLocation/>
<OptionAutomaticExercise/>
<OptionThreshold/>
<ManualExercise/>
<OptionWrittenExerciseConf/>
<OptionSettlement/>
<OptionCashSettlementMethod/>
<OptionCashSettlementQuotationRate/>
<OptionCashSettlementRateSource/>
<OptionCashSettlementReferenceBanks/>
<ClearedPhysicalSettlement/>
<Premium>
<Currency/>
<Amount/>
<Date/>
</Premium>
<PremiumHolidayCentres/>
<DocsType/>
<DocsSubType/>
<OptionsComponentSecurityIndexAnnex/>
<OptionHedgingDisruption/>
<OptionLossOfStockBorrow/>
<OptionMaximumStockLoanRate/>
<OptionIncreasedCostOfStockBorrow/>
<OptionInitialStockLoanRate/>
<OptionIncreasedCostOfHedging/>
<OptionForeignOwnershipEvent/>
<OptionEntitlement/>
<ContractualDefinitions/>
<RestructuringCreditEvent/>
<CalculationAgentCity/>
<RefEntName/>
<RefEntStdId/>
<REROPairStdId/>
<RefOblRERole/>
<RefOblSecurityIdType/>
<RefOblSecurityId/>
<BloombergID/>
<RefOblMaturity/>
<RefOblCoupon/>
<RefOblPrimaryObligor/>
<BorrowerNames/>
<FacilityType/>
<CreditAgreementDate/>
<IsSecuredList/>
<DesignatedPriority/>
<OptionalEarlyTermination/>
<ReferencePrice/>
<ReferencePolicy/>
<PaymentDelay/>
<StepUpProvision/>
<WACCapInterestProvision/>
<InterestShortfallCapIndicator/>
<InterestShortfallCompounding/>
<InterestShortfallCapBasis/>
<InterestShortfallRateSource/>
<MortgagePaymentFrequency/>
<MortgageFinalMaturity/>
<MortgageOriginalAmount/>
<MortgageInitialFactor/>
<MortgageSector/>
<IndexName/>
<IndexId/>
<IndexSeries/>
<IndexVersion/>
<IndexAnnexDate/>
<IndexTradedRate/>
<UpfrontFee/>
<UpfrontFeeAmount/>
<UpfrontFeeDate/>
<UpfrontFeePayer/>
<AttachmentPoint/>
<ExhaustionPoint/>
<EquityRic/>
<OptionQuantity/>
<OptionExpiryMonth/>
<OptionExpiryYear/>
<Price/>
<OptionStyle/>
<ExchangeLookAlike/>
<AdjustmentMethod/>
<RelatedExchange/>
<MasterConfirmationDate/>
<Multiplier/>
<SettlementCurrency/>
<SettlementCurrency_2/>
<SettlementDateOffset/>
<SettlementType/>
<FxDeterminationMethod/>
<ReferencePriceSource/>
<ReferencePricePage/>
<ReferencePriceTime/>
<ReferencePriceCity/>
<ReferenceCurrency/>
<ReferenceCurrency_2/>
<DcRequired/>
<DcEventTypeA/>
<DcRic/>
<DcDescription/>
<DcExpiryMonth/>
<DcExpiryYear/>
<DcQuantity/>
<DcPrice/>
<DcCurrency/>
<DcDelta/>
<DcExpiryDate/>
<DcFuturesCode/>
<DcOffshoreCross/>
<DcOffshoreCrossLocation/>
<DcExchangeID/>
<DcDeltaOptionQuantity/>
<AveragingInOut/>
<AveragingDateTimes>
<AveragingDate/>
</AveragingDateTimes>
<MarketDisruption/>
<AveragingFrequency/>
<AveragingStartDate/>
<AveragingEndDate/>
<ReferenceFXRate/>
<HedgeLevel/>
<Basis/>
<ImpliedLevel/>
<PremiumPercent/>
<StrikePercent/>
<BaseNotional/>
<BreakOutTrade/>
<SplitCollateral/>
<OpenUnits/>
<DeclaredCashDividendPercentage/>
<DeclaredCashEquivalentDividendPercentage/>
<DividendPayer/>
<DividendReceiver/>
<DividendPeriods>
<DividendPeriod>
<DividendPeriodId/>
<UnadjustedStartDate/>
<UnadjustedEndDate/>
<PaymentDateReference/>
<FixedStrike/>
<DividendValuationDateReference/>
<DividendValuationDate/>
</DividendPeriod>
</DividendPeriods>
<SpecialDividends/>
<MaterialDividend/>
<FixedPayer/>
<FixedReceiver/>
<FixedPeriods>
<FixedPayment>
<DivSwapFixedAmount/>
<DivSwapFixedDateOffset/>
<DivSwapFixedDateRelativeTo/>
</FixedPayment>
</FixedPeriods>
<VegaNotional/>
<ExpectedN/>
<ExpectedNOverride/>
<VarianceAmount/>
<VarianceStrikePrice/>
<VolatilityStrikePrice/>
<VarianceCapIndicator/>
<VarianceCapFactor/>
<ObservationStartDate/>
<ValuationDate/>
<InitialSharePriceOrIndexLevel/>
<ClosingSharePriceOrClosingIndexLevelIndicator/>
<FuturesPriceValuation/>
<AllDividends/>
<SettlementCurrencyVegaNotional/>
<VegaFxRate/>
<IndependentAmount>
<Payer/>
<Currency/>
<Amount/>
</IndependentAmount>
<xsl:apply-templates select="$trade/fpml:otherPartyPayment"/>
<SettlementRateOption/>
<SettlementRateOption_2/>
<FxFixingAdjustableDate/>
<FxFixingPeriod/>
<FxFixingDayConvention/>
<FxFixingCentres/>
<FxFixingPeriod_2/>
<FxFixingDayConvention_2/>
<FxFixingCentres_2/>
<CalcAgentA/>
<DefaultSettlementMethod/>
<SettlementPriceDefaultElectionMethod/>
<SettlementMethodElectionDate/>
<SettlementMethodElectingParty/>
<NotionalFutureValue/>
<DispLegs>
<DispLeg>
<DispLegId/>
<DispLegVersionId/>
<DispLegPayer/>
<DispLegReceiver/>
<DispEquityRic/>
<DispEquityRelEx/>
<DispVegaNotional/>
<DispExpectedN/>
<DispSettlementDateOffset/>
<DispVarianceAmount/>
<DispShareVarCurrency/>
<DispVarianceStrikePrice/>
<DispVarianceCapIndicator/>
<DispVarianceCapFactor/>
<DispVegaNotionalAmount/>
<DispObservationStartDate/>
<DispValuationDate/>
<DispInitialLevel/>
<DispClosingLevelIndicator/>
<DispFuturesPriceValuation/>
<DispAllDividends/>
</DispLeg>
</DispLegs>
<DispLegsSW>
<DispLegSW>
<DispCorrespondingLeg/>
<DispVolatilityStrikePrice/>
<DispHolidayDates/>
<DispExpectedNOverride/>
<DispShareWeight/>
</DispLegSW>
</DispLegsSW>
<BalanceOfPeriod/>
<BulletIndicator/>
<BulletFirstContractMonth/>
<BulletLastContractMonth/>
<BulletContractYear/>
<BulletContractTradingDay/>
<ClearingVenue/>
<ClientClearing/>
<ExternalInteropabilityId/>
<InteropNettingString/>
<AutoSendForClearing/>
<ASICMandatoryClearingIndicator/>
<PBEBTradeASICMandatoryClearingIndicator/>
<PBClientTradeASICMandatoryClearingIndicator/>
<CANMandatoryClearingIndicator/>
<CANClearingExemptIndicator1PartyId/>
<CANClearingExemptIndicator1Value/>
<CANClearingExemptIndicator2PartyId/>
<CANClearingExemptIndicator2Value/>
<PBEBTradeCANMandatoryClearingIndicator/>
<PBEBTradeCANClearingExemptIndicator1PartyId/>
<PBEBTradeCANClearingExemptIndicator1Value/>
<PBEBTradeCANClearingExemptIndicator2PartyId/>
<PBEBTradeCANClearingExemptIndicator2Value/>
<PBClientTradeCANMandatoryClearingIndicator/>
<PBClientTradeCANClearingExemptIndicator1PartyId/>
<PBClientTradeCANClearingExemptIndicator1Value/>
<PBClientTradeCANClearingExemptIndicator2PartyId/>
<PBClientTradeCANClearingExemptIndicator2Value/>
<ESMAMandatoryClearingIndicator/>
<ESMAClearingExemptIndicator1PartyId/>
<ESMAClearingExemptIndicator1Value/>
<ESMAClearingExemptIndicator2PartyId/>
<ESMAClearingExemptIndicator2Value/>
<PBEBTradeESMAMandatoryClearingIndicator/>
<PBEBTradeESMAClearingExemptIndicator1PartyId/>
<PBEBTradeESMAClearingExemptIndicator1Value/>
<PBEBTradeESMAClearingExemptIndicator2PartyId/>
<PBEBTradeESMAClearingExemptIndicator2Value/>
<PBClientTradeESMAMandatoryClearingIndicator/>
<PBClientTradeESMAClearingExemptIndicator1PartyId/>
<PBClientTradeESMAClearingExemptIndicator1Value/>
<PBClientTradeESMAClearingExemptIndicator2PartyId/>
<PBClientTradeESMAClearingExemptIndicator2Value/>
<FCAMandatoryClearingIndicator/>
<FCAClearingExemptIndicator1PartyId/>
<FCAClearingExemptIndicator1Value/>
<FCAClearingExemptIndicator2PartyId/>
<FCAClearingExemptIndicator2Value/>
<PBEBTradeFCAMandatoryClearingIndicator/>
<PBEBTradeFCAClearingExemptIndicator1PartyId/>
<PBEBTradeFCAClearingExemptIndicator1Value/>
<PBEBTradeFCAClearingExemptIndicator2PartyId/>
<PBEBTradeFCAClearingExemptIndicator2Value/>
<PBClientTradeFCAMandatoryClearingIndicator/>
<PBClientTradeFCAClearingExemptIndicator1PartyId/>
<PBClientTradeFCAClearingExemptIndicator1Value/>
<PBClientTradeFCAClearingExemptIndicator2PartyId/>
<PBClientTradeFCAClearingExemptIndicator2Value/>
<HKMAMandatoryClearingIndicator/>
<HKMAClearingExemptIndicator1PartyId/>
<HKMAClearingExemptIndicator1Value/>
<HKMAClearingExemptIndicator2PartyId/>
<HKMAClearingExemptIndicator2Value/>
<PBEBTradeHKMAMandatoryClearingIndicator/>
<PBEBTradeHKMAClearingExemptIndicator1PartyId/>
<PBEBTradeHKMAClearingExemptIndicator1Value/>
<PBEBTradeHKMAClearingExemptIndicator2PartyId/>
<PBEBTradeHKMAClearingExemptIndicator2Value/>
<PBClientTradeHKMAMandatoryClearingIndicator/>
<PBClientTradeHKMAClearingExemptIndicator1PartyId/>
<PBClientTradeHKMAClearingExemptIndicator1Value/>
<PBClientTradeHKMAClearingExemptIndicator2PartyId/>
<PBClientTradeHKMAClearingExemptIndicator2Value/>
<JFSAMandatoryClearingIndicator/>
<CFTCMandatoryClearingIndicator/>
<CFTCClearingExemptIndicator1PartyId/>
<CFTCClearingExemptIndicator1Value/>
<CFTCClearingExemptIndicator2PartyId/>
<CFTCClearingExemptIndicator2Value/>
<PBEBTradeCFTCMandatoryClearingIndicator/>
<PBEBTradeCFTCClearingExemptIndicator1PartyId/>
<PBEBTradeCFTCClearingExemptIndicator1Value/>
<PBEBTradeCFTCClearingExemptIndicator2PartyId/>
<PBEBTradeCFTCClearingExemptIndicator2Value/>
<PBClientTradeCFTCMandatoryClearingIndicator/>
<PBClientTradeCFTCClearingExemptIndicator1PartyId/>
<PBClientTradeCFTCClearingExemptIndicator1Value/>
<PBClientTradeCFTCClearingExemptIndicator2PartyId/>
<PBClientTradeCFTCClearingExemptIndicator2Value/>
<MASMandatoryClearingIndicator/>
<PBEBTradeMASMandatoryClearingIndicator/>
<PBClientTradeMASMandatoryClearingIndicator/>
<ClearingHouseId/>
<IntendedClearingHouse/>
<TraderId/>
<TraderId_2/>
<DisplayPartyLE_Party/>
<DisplayPartyLE_Value/>
<ClearingNettingParty/>
<ClearingNettingString/>
<ClearingNettingParty_2/>
<ClearingNettingString_2/>
<CommodityReferencePrice/>
<CommodityReferencePrice_2/>
<CommonPricing/>
<DeliveryDates/>
<DeliveryDates_2/>
<DeliveryLocation/>
<FloatCalculationFrequency/>
<FloatCalculationFrequency_2/>
<PhysicalCommodity/>
<PhysicalElectricityProduct/>
<PhysicalElectricityForceMajeure/>
<PhysicalGasDeliveryType/>
<ForwardUnderlyer/>
<FuturesRollConvention/>
<FuturesRollConvention_2/>
<LoadShape/>
<LoadShape_2/>
<NotionalLots/>
<NotionalQuantity/>
<NotionalQuantity_2/>
<PricingDayType/>
<PricingDayType_2/>
<PricingFrequency/>
<PricingFrequency_2/>
<PricingHolidayCentres/>
<PricingHolidayCentres_2/>
<PricingLagInterval/>
<PricingLagInterval_2/>
<PricingLagSkipInterval/>
<PricingLagSkipInterval_2/>
<PricingRange/>
<PricingRange_2/>
<SettlementDaysConvention/>
<SettlementDaysType/>
<SpecifiedPrice/>
<SpecifiedPrice_2/>
<UnitFrequency/>
<Units/>
<Units_2/>
<ValueDate/>
<ModifiedEquityDelivery/>
<SettledEntityMatrixSource/>
<SettledEntityMatrixDate/>
<AdditionalTerms/>
<Rule15A-6/>
<GCOffsettingID>
<xsl:value-of select="$swExtendedTradeDetails/swml:swTradeHeader/swml:swbOffsettingTradeId"/>
</GCOffsettingID>
<CompressionType>
<xsl:value-of select="$swExtendedTradeDetails/swml:swTradeHeader/swml:swbCompressionType"/>
</CompressionType>
<xsl:for-each select="$swExtendedTradeDetails/swml:swTradeHeader/swml:swbPartyExecutionMethod">
<xsl:if test="swml:partyReference/@href = 'partyA'">
<GCExecutionMethodParty_1>
<xsl:value-of select="swml:partyReference/@href"/>
</GCExecutionMethodParty_1>
<GCExecutionMethodToken_1>
<xsl:value-of select="swml:swbExecutionMethod"/>
</GCExecutionMethodToken_1>
</xsl:if>
</xsl:for-each>
<xsl:for-each select="$swExtendedTradeDetails/swml:swTradeHeader/swml:swbPartyExecutionMethod">
<xsl:if test="swml:partyReference/@href = 'partyB'">
<GCExecutionMethodParty_2>
<xsl:value-of select="swml:partyReference/@href"/>
</GCExecutionMethodParty_2>
<GCExecutionMethodToken_2>
<xsl:value-of select="swml:swbExecutionMethod"/>
</GCExecutionMethodToken_2>
</xsl:if>
</xsl:for-each>
<DirectionComboLEA>
<xsl:variable name="buyer" select="string($repo/fpml:nearLeg/fpml:buyerPartyReference/@href)"/>
<xsl:choose>
<xsl:when test="string($buyer)=string($partyA)">Buy</xsl:when>
<xsl:otherwise>Sell</xsl:otherwise>
</xsl:choose>
</DirectionComboLEA>
<DurationType>
<xsl:value-of select="$repo/fpml:duration"/>
</DurationType>
<RateCalcType>
<xsl:if test="$repo/fpml:fixedRateSchedule/fpml:initialValue">Fixed</xsl:if>
<xsl:if test="$repo/fpml:floatingRateCalculation/fpml:spreadSchedule/fpml:initialValue">Floating</xsl:if>
</RateCalcType>
<SecurityType>
<xsl:if test="$repo/fpml:bond">Bond</xsl:if>
<xsl:if test="$repo/fpml:equity">Equity</xsl:if>
<xsl:if test="$repo/fpml:triParty">Triparty GC</xsl:if>
</SecurityType>
<OpenRepoRate>
<xsl:if test="$repo/fpml:fixedRateSchedule/fpml:initialValue">
<xsl:value-of select="$repo/fpml:fixedRateSchedule/fpml:initialValue"/>
</xsl:if>
</OpenRepoRate>
<OpenRepoSpread>
<xsl:if test="$repo/fpml:floatingRateCalculation/fpml:spreadSchedule/fpml:initialValue">
<xsl:value-of select="$repo/fpml:floatingRateCalculation/fpml:spreadSchedule/fpml:initialValue"/>
</xsl:if>
</OpenRepoSpread>
<OpenCashAmount>
<xsl:value-of select="$repo/fpml:nearLeg/fpml:settlementAmount/fpml:amount"/>
</OpenCashAmount>
<OpenDeliveryMethod>
<xsl:value-of select="$repo/fpml:nearLeg/fpml:deliveryMethod"/>
</OpenDeliveryMethod>
<OpenSecurityNominal>
<xsl:value-of select="$repo/fpml:nearLeg/fpml:collateral/fpml:nominalAmount/fpml:amount"/>
</OpenSecurityNominal>
<OpenSecurityQuantity>
<xsl:value-of select="$repo/fpml:nearLeg/fpml:collateral/fpml:quantity"/>
</OpenSecurityQuantity>
<CloseCashAmount>
<xsl:value-of select="$repo/fpml:farLeg/fpml:settlementAmount/fpml:amount"/>
</CloseCashAmount>
<CloseDeliveryMethod>
<xsl:value-of select="$repo/fpml:farLeg/fpml:deliveryMethod"/>
</CloseDeliveryMethod>
<CloseSecurityNominal>
<xsl:value-of select="$repo/fpml:farLeg/fpml:collateral/fpml:nominalAmount/fpml:amount"/>
</CloseSecurityNominal>
<CloseSecurityQuantity>
<xsl:value-of select="$repo/fpml:farLeg/fpml:collateral/fpml:quantity"/>
</CloseSecurityQuantity>
<DayCountBasis>
<xsl:value-of select="$repo/fpml:dayCountFraction"/>
</DayCountBasis>
<Haircut>
<xsl:if test="$repo/fpml:initialMargin/fpml:margin/fpml:haircut">
<xsl:value-of select="$repo/fpml:initialMargin/fpml:margin/fpml:haircut"/>
</xsl:if>
</Haircut>
<InitialMargin>
<xsl:if test="$repo/fpml:initialMargin/fpml:margin/fpml:marginRatio">
<xsl:value-of select="$repo/fpml:initialMargin/fpml:margin/fpml:marginRatio"/>
</xsl:if>
</InitialMargin>
<SecurityIDType>
<xsl:choose>
<xsl:when test="$idScheme='http://www.fpml.org/coding-scheme/external/instrument-id-ISIN-1-0' and $securityID='XSUNKNOWN000'">Unknown</xsl:when>
<xsl:when test="$idScheme='http://www.fpml.org/coding-scheme/external/instrument-id-ISIN-1-0'">ISIN</xsl:when>
<xsl:when test="$idScheme='http://www.fpml.org/coding-scheme/external/instrument-id-CUSIP-1-0'">CUSIP</xsl:when>
<xsl:when test="$idScheme='http://www.fpml.org/coding-scheme/external/instrument-id-SEDOL-1-0'">SEDOL</xsl:when>
<xsl:when test="$idScheme='http://www.fpml.org/coding-scheme/external/instrument-id-DBVCLASS-1-0'">DBV Class</xsl:when>
<xsl:when test="$idScheme='http://www.fpml.org/coding-scheme/external/instrument-id-CUSTOM-1-0'">Custom ID</xsl:when>
<xsl:otherwise>???</xsl:otherwise>
</xsl:choose>
</SecurityIDType>
<SecurityID>
<xsl:value-of select="$securityID"/>
</SecurityID>
<SecurityDescription>
<xsl:choose>
<xsl:when test="$repo//fpml:triParty//fpml:collateralType">
<xsl:value-of select="$repo//fpml:triParty//fpml:collateralType"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$repo//fpml:description"/>
</xsl:otherwise>
</xsl:choose>
</SecurityDescription>
<SecurityCurrency>
<xsl:choose>
<xsl:when test="$repo//fpml:triParty">
<xsl:value-of select="$currency"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$repo/fpml:bond/fpml:currency"/>
<xsl:value-of select="$repo/fpml:equity/fpml:currency"/>
</xsl:otherwise>
</xsl:choose>
</SecurityCurrency>
<ExtensionStyle>
<xsl:value-of select="$repo/fpml:extensionStyle"/>
</ExtensionStyle>
<ExtensionPeriod>
<xsl:value-of select="$repo/fpml:extensionPeriod/fpml:periodMultiplier"/>
</ExtensionPeriod>
<ExtensionPeriodUnits>
<xsl:if test="$repo/fpml:extensionPeriod/fpml:period">
<xsl:variable name="extPerUnits" select="$repo/fpml:extensionPeriod/fpml:period"/>
<xsl:choose>
<xsl:when test="$extPerUnits='D'">Day</xsl:when>
<xsl:when test="$extPerUnits='M'">Month</xsl:when>
<xsl:when test="$extPerUnits='W'">Week</xsl:when>
<xsl:when test="$extPerUnits='Y'">Year</xsl:when>
<xsl:otherwise>???</xsl:otherwise>
</xsl:choose>
</xsl:if>
</ExtensionPeriodUnits>
<CallingParty>
<xsl:value-of select="$repo/fpml:callingParty"/>
</CallingParty>
<CallDate>
<xsl:if test="$repo/fpml:callDate/fpml:adjustableDate/fpml:unadjustedDate">
<xsl:variable name="callDate">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="$repo/fpml:callDate/fpml:adjustableDate/fpml:unadjustedDate"/>
</xsl:call-template>
</xsl:variable>
<xsl:value-of select="$callDate"/>
</xsl:if>
</CallDate>
<CallNoticePeriod>
<xsl:value-of select="$repo/fpml:noticePeriod/fpml:periodMultiplier"/>
</CallNoticePeriod>
<xsl:if test="$swbTradeEventReportingDetails/swml:swbUniqueTransactionId/swml:swbTradeId">
<GlobalUTI>
<xsl:value-of select="$swbTradeEventReportingDetails/swml:swbUniqueTransactionId/swml:swbTradeId"/>
</GlobalUTI>
</xsl:if>
</Trade>
</xsl:template>
<xsl:template match="swml:swbRecipient">
<Recipient>
<Id>
<xsl:value-of select="./@id"/>
</Id>
<xsl:variable name="party" select="string(swml:partyReference/@href)"/>
<Party>
<xsl:choose>
<xsl:when test="$party='partyA'">A</xsl:when>
<xsl:when test="$party='partyB'">B</xsl:when>
<xsl:otherwise>???</xsl:otherwise>
</xsl:choose>
</Party>
<UserName>
<xsl:value-of select="swml:swbUserName"/>
</UserName>
<TradingBook>
<xsl:value-of select="swml:swbTradingBookId"/>
</TradingBook>
<ExecutionMode/>
</Recipient>
</xsl:template>
<xsl:template match="fpml:otherPartyPayment">
<Brokerage>
<Payer>
<xsl:variable name="payer" select="string(fpml:payerPartyReference/@href)"/>
<xsl:choose>
<xsl:when test="$payer='partyA'">A</xsl:when>
<xsl:when test="$payer='partyB'">B</xsl:when>
<xsl:otherwise>???</xsl:otherwise>
</xsl:choose>
</Payer>
<Currency>
<xsl:choose>
<xsl:when test="fpml:paymentAmount/fpml:currency='XXX' and fpml:paymentAmount/fpml:amount='0'"/>
<xsl:otherwise>
<xsl:value-of select="fpml:paymentAmount/fpml:currency"/>
</xsl:otherwise>
</xsl:choose>
</Currency>
<Amount>
<xsl:choose>
<xsl:when test="fpml:paymentAmount/fpml:currency='XXX' and fpml:paymentAmount/fpml:amount='0'"/>
<xsl:otherwise>
<xsl:value-of select="fpml:paymentAmount/fpml:amount"/>
</xsl:otherwise>
</xsl:choose>
</Amount>
<Broker>
<xsl:variable name="broker" select="string(fpml:receiverPartyReference/@href)"/>
<xsl:value-of select="$dataDocument/fpml:party[@id=$broker]/fpml:partyId"/>
</Broker>
<BrokerTradeId>
<xsl:variable name="party" select="string(fpml:payerPartyReference/@href)"/>
<xsl:value-of select="$trade/fpml:tradeHeader/fpml:partyTradeIdentifier/fpml:partyReference[@href=$party]/../fpml:tradeId"/>
</BrokerTradeId>
</Brokerage>
</xsl:template>
<xsl:template name="swml:swAllocations">
<xsl:apply-templates select="/swml:SWBML/swml:swAllocations/swml:swAllocation"/>
</xsl:template>
<xsl:template match="swml:swAllocation">
<xsl:variable name="BuyerRef" select="string(swml:swNearLeg//fpml:buyerPartyReference/@href)"/>
<xsl:variable name="SellerRef" select="string(swml:swNearLeg//fpml:sellerPartyReference/@href)"/>
<xsl:variable name="BuyerBIC" select="string($dataDocument/fpml:party[@id=$BuyerRef]/fpml:partyId)"/>
<xsl:variable name="SellerBIC" select="string($dataDocument/fpml:party[@id=$SellerRef]/fpml:partyId)"/>
<Allocation>
<Buyer>
<xsl:value-of select="$BuyerBIC"/>
</Buyer>
<Seller>
<xsl:value-of select="$SellerBIC"/>
</Seller>
<swbStreamReference/>
<AllocatedNumberOfOptions/>
<AllocatedVegaNotional/>
<AllocatedVarianceAmount/>
<AllocatedUnits/>
<AllocOpenSecurityNominal>
<xsl:value-of select="string(swml:swNearLeg//fpml:nominalAmount//fpml:amount)"/>
</AllocOpenSecurityNominal>
<AllocOpenSecurityQuantity>
<xsl:value-of select="string(swml:swNearLeg//fpml:quantity)"/>
</AllocOpenSecurityQuantity>
<AllocGlobalUTI>
<xsl:value-of select="string(swml:swbAllocationReportingDetails//swml:swbUniqueTransactionId//swml:swbTradeId)"/>
</AllocGlobalUTI>
<swbBrokerTradeId>
<xsl:value-of select="string(swml:swbBrokerTradeId)"/>
</swbBrokerTradeId>
</Allocation>
</xsl:template>
<xsl:template name="formatDate">
<xsl:param name="date"/>
<xsl:variable name="month" select="string(substring($date,6,2))"/>
<xsl:value-of select="substring($date,9,2)"/>-<xsl:choose>
<xsl:when test="$month='01'">Jan</xsl:when>
<xsl:when test="$month='02'">Feb</xsl:when>
<xsl:when test="$month='03'">Mar</xsl:when>
<xsl:when test="$month='04'">Apr</xsl:when>
<xsl:when test="$month='05'">May</xsl:when>
<xsl:when test="$month='06'">Jun</xsl:when>
<xsl:when test="$month='07'">Jul</xsl:when>
<xsl:when test="$month='08'">Aug</xsl:when>
<xsl:when test="$month='09'">Sep</xsl:when>
<xsl:when test="$month='10'">Oct</xsl:when>
<xsl:when test="$month='11'">Nov</xsl:when>
<xsl:when test="$month='12'">Dec</xsl:when>
<xsl:otherwise>???</xsl:otherwise>
</xsl:choose>-<xsl:value-of select="substring($date,1,4)"/>
</xsl:template>
</xsl:stylesheet>
