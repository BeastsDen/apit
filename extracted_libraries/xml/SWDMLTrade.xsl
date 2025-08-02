<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:lcl="http://www.markitserv.com/detail/SWDMLTrade.xsl" version="1.0" exclude-result-prefixes="lcl">
<xsl:template name="lcl:SWDMLTrade">
<xsl:param name="SWDMLVersion" select="/.."/>
<xsl:param name="TradeOriginator" select="/.."/>
<xsl:param name="ReplacementTradeId" select="/.."/>
<xsl:param name="ReplacementTradeIdType" select="/.."/>
<xsl:param name="ReplacementReason" select="/.."/>
<xsl:param name="ShortFormInput" select="/.."/>
<xsl:param name="ProductType" select="/.."/>
<xsl:param name="ProductSubType" select="/.."/>
<xsl:param name="ParticipantSupplement" select="/.."/>
<xsl:param name="ConditionPrecedentBondId" select="/.."/>
<xsl:param name="ConditionPrecedentBondMaturity" select="/.."/>
<xsl:param name="ConditionPrecedentBondIdType" select="/.."/>
<xsl:param name="ConditionPrecedentBond" select="/.."/>
<xsl:param name="DiscrepancyClause" select="/.."/>
<xsl:param name="AllocatedTrade" select="/.."/>
<xsl:param name="Allocation" select="/.."/>
<xsl:param name="PrimeBrokerTrade" select="/.."/>
<xsl:param name="ReversePrimeBrokerLegalEntities" select="/.."/>
<xsl:param name="PartyAId">
<xsl:call-template name="lcl:SWDMLTrade.PartyAId"/>
</xsl:param>
<xsl:param name="PartyAIdType" select="/.."/>
<xsl:param name="PartyBId">
<xsl:call-template name="lcl:SWDMLTrade.PartyBId"/>
</xsl:param>
<xsl:param name="PartyBIdType" select="/.."/>
<xsl:param name="PartyCId">
<xsl:call-template name="lcl:SWDMLTrade.PartyCId"/>
</xsl:param>
<xsl:param name="PartyCIdType" select="/.."/>
<xsl:param name="PartyDId">
<xsl:call-template name="lcl:SWDMLTrade.PartyDId"/>
</xsl:param>
<xsl:param name="PartyDIdType" select="/.."/>
<xsl:param name="PartyGId">
<xsl:call-template name="lcl:SWDMLTrade.PartyGId"/>
</xsl:param>
<xsl:param name="PartyGIdType" select="/.."/>
<xsl:param name="PartyTripartyAgentId">
<xsl:call-template name="lcl:SWDMLTrade.PartyTripartyAgentId"/>
</xsl:param>
<xsl:param name="PartyTripartyAgentIdType" select="/.."/>
<xsl:param name="DeliveryByValue" select="/.."/>
<xsl:param name="Interoperable" select="/.."/>
<xsl:param name="ExternalInteropabilityId" select="/.."/>
<xsl:param name="InteropNettingString" select="/.."/>
<xsl:param name="DirectionA" select="/.."/>
<xsl:param name="TradeDate" select="/.."/>
<xsl:param name="StartDateTenor" select="/.."/>
<xsl:param name="EndDateTenor" select="/.."/>
<xsl:param name="StartDateDay" select="/.."/>
<xsl:param name="Tenor" select="/.."/>
<xsl:param name="StartDate" select="/.."/>
<xsl:param name="FirstFixedPeriodStartDate" select="/.."/>
<xsl:param name="FirstFixedPeriodStartDate_2" select="/.."/>
<xsl:param name="FirstFloatPeriodStartDate" select="/.."/>
<xsl:param name="FirstFloatPeriodStartDate_2" select="/.."/>
<xsl:param name="EndDate" select="/.."/>
<xsl:param name="FixingDate" select="/.."/>
<xsl:param name="TerminationDays" select="/.."/>
<xsl:param name="FixedPaymentFreq" select="/.."/>
<xsl:param name="FixedPaymentFreq_2" select="/.."/>
<xsl:param name="FloatPaymentFreq" select="/.."/>
<xsl:param name="FloatPaymentFreq_2" select="/.."/>
<xsl:param name="FloatRollFreq" select="/.."/>
<xsl:param name="FloatRollFreq_2" select="/.."/>
<xsl:param name="RollsType" select="/.."/>
<xsl:param name="RollsMethod" select="/.."/>
<xsl:param name="RollDay" select="/.."/>
<xsl:param name="MonthEndRolls" select="/.."/>
<xsl:param name="FirstPeriodStartDate" select="/.."/>
<xsl:param name="FirstPaymentDate" select="/.."/>
<xsl:param name="LastRegularPaymentDate" select="/.."/>
<xsl:param name="FixedRate" select="/.."/>
<xsl:param name="FixedRate_2" select="/.."/>
<xsl:param name="initialPoints" select="/.."/>
<xsl:param name="quotationStyle" select="/.."/>
<xsl:param name="RecoveryRate" select="/.."/>
<xsl:param name="FixedSettlement" select="/.."/>
<xsl:param name="Currency" select="/.."/>
<xsl:param name="Currency_2" select="/.."/>
<xsl:param name="Notional" select="/.."/>
<xsl:param name="NotionalFloating" select="/.."/>
<xsl:param name="Notional_2" select="/.."/>
<xsl:param name="InitialNotional" select="/.."/>
<xsl:param name="FinalExchangeAmount" select="/.."/>
<xsl:param name="FixedAmount" select="/.."/>
<xsl:param name="FixedAmount_2" select="/.."/>
<xsl:param name="FixedAmountCurrency" select="/.."/>
<xsl:param name="FixedAmountCurrency_2" select="/.."/>
<xsl:param name="FixedDayBasis" select="/.."/>
<xsl:param name="FixedDayBasis_2" select="/.."/>
<xsl:param name="FloatDayBasis" select="/.."/>
<xsl:param name="FloatDayBasis_2" select="/.."/>
<xsl:param name="FixedConvention" select="/.."/>
<xsl:param name="FixedConvention_2" select="/.."/>
<xsl:param name="FixedCalcPeriodDatesConvention" select="/.."/>
<xsl:param name="FixedCalcPeriodDatesConvention_2" select="/.."/>
<xsl:param name="FixedTerminationDateConvention" select="/.."/>
<xsl:param name="FixedTerminationDateConvention_2" select="/.."/>
<xsl:param name="FloatConvention" select="/.."/>
<xsl:param name="FloatCalcPeriodDatesConvention" select="/.."/>
<xsl:param name="FloatTerminationDateConvention" select="/.."/>
<xsl:param name="FloatConvention_2" select="/.."/>
<xsl:param name="FloatTerminationDateConvention_2" select="/.."/>
<xsl:param name="FloatingRateIndex" select="/.."/>
<xsl:param name="FloatingRateIndexTenor" select="/.."/>
<xsl:param name="FloatingRateIndex_2" select="/.."/>
<xsl:param name="InflationLag" select="/.."/>
<xsl:param name="IndexSource" select="/.."/>
<xsl:param name="InterpolationMethod" select="/.."/>
<xsl:param name="InitialIndexLevel" select="/.."/>
<xsl:param name="RelatedBond" select="/.."/>
<xsl:param name="IndexTenor1" select="/.."/>
<xsl:param name="IndexTenor1_2" select="/.."/>
<xsl:param name="LinearInterpolation" select="/.."/>
<xsl:param name="LinearInterpolation_2" select="/.."/>
<xsl:param name="IndexTenor2" select="/.."/>
<xsl:param name="IndexTenor2_2" select="/.."/>
<xsl:param name="InitialInterpolationIndex" select="/.."/>
<xsl:param name="InitialInterpolationIndex_2" select="/.."/>
<xsl:param name="CMSCalcAgent" select="/.."/>
<xsl:param name="CompoundingCalculationMethod" select="/.."/>
<xsl:param name="CompoundingCalculationMethod_2" select="/.."/>
<xsl:param name="ObservationMethod" select="/.."/>
<xsl:param name="ObservationMethod_2" select="/.."/>
<xsl:param name="OffsetDays" select="/.."/>
<xsl:param name="OffsetDays_2" select="/.."/>
<xsl:param name="ObservationPeriodDates" select="/.."/>
<xsl:param name="ObservationPeriodDates_2" select="/.."/>
<xsl:param name="ObservationAdditionalBusinessDays" select="/.."/>
<xsl:param name="ObservationAdditionalBusinessDays_2" select="/.."/>
<xsl:param name="ObservationHolidayCentre" select="/.."/>
<xsl:param name="ObservationHolidayCentre_2" select="/.."/>
<xsl:param name="SpreadOverIndex" select="/.."/>
<xsl:param name="SpreadOverIndex_2" select="/.."/>
<xsl:param name="FirstFixingRate" select="/.."/>
<xsl:param name="FirstFixingRate_2" select="/.."/>
<xsl:param name="FixingDaysOffset" select="/.."/>
<xsl:param name="FixingDaysOffset_2" select="/.."/>
<xsl:param name="FixingHolidayCentres" select="/.."/>
<xsl:param name="FixingHolidayCentres_2" select="/.."/>
<xsl:param name="ResetInArrears" select="/.."/>
<xsl:param name="ResetInArrears_2" select="/.."/>
<xsl:param name="FirstFixingDifferent" select="/.."/>
<xsl:param name="FirstFixingDifferent_2" select="/.."/>
<xsl:param name="FirstFixingDaysOffset" select="/.."/>
<xsl:param name="FirstFixingDaysOffset_2" select="/.."/>
<xsl:param name="FirstFixingHolidayCentres" select="/.."/>
<xsl:param name="FirstFixingHolidayCentres_2" select="/.."/>
<xsl:param name="PaymentHolidayCentres" select="/.."/>
<xsl:param name="PaymentHolidayCentres_2" select="/.."/>
<xsl:param name="PaymentLag" select="/.."/>
<xsl:param name="PaymentLag_2" select="/.."/>
<xsl:param name="RollHolidayCentres" select="/.."/>
<xsl:param name="RollHolidayCentres_2" select="/.."/>
<xsl:param name="AdjustFixedStartDate" select="/.."/>
<xsl:param name="AdjustFixedStartDate_2" select="/.."/>
<xsl:param name="AdjustFloatStartDate" select="/.."/>
<xsl:param name="AdjustFloatStartDate_2" select="/.."/>
<xsl:param name="AdjustRollEnd" select="/.."/>
<xsl:param name="AdjustRollEnd_2" select="/.."/>
<xsl:param name="AdjustFloatRollEnd" select="/.."/>
<xsl:param name="AdjustFloatRollEnd_2" select="/.."/>
<xsl:param name="AdjustFixedFinalRollEnd" select="/.."/>
<xsl:param name="AdjustFixedFinalRollEnd_2" select="/.."/>
<xsl:param name="AdjustFinalRollEnd" select="/.."/>
<xsl:param name="AdjustFinalRollEnd_2" select="/.."/>
<xsl:param name="CompoundingMethod" select="/.."/>
<xsl:param name="CompoundingMethod_2" select="/.."/>
<xsl:param name="AveragingMethod" select="/.."/>
<xsl:param name="AveragingMethod_2" select="/.."/>
<xsl:param name="FloatingRateMultiplier" select="/.."/>
<xsl:param name="FloatingRateMultiplier_2" select="/.."/>
<xsl:param name="DesignatedMaturity" select="/.."/>
<xsl:param name="DesignatedMaturity_2" select="/.."/>
<xsl:param name="ResetFreq" select="/.."/>
<xsl:param name="ResetFreq_2" select="/.."/>
<xsl:param name="WeeklyRollConvention" select="/.."/>
<xsl:param name="WeeklyRollConvention_2" select="/.."/>
<xsl:param name="RateCutOffDays" select="/.."/>
<xsl:param name="RateCutOffDays_2" select="/.."/>
<xsl:param name="InitialExchange" select="/.."/>
<xsl:param name="FinalExchange" select="/.."/>
<xsl:param name="MarkToMarket" select="/.."/>
<xsl:param name="IntermediateExchange" select="/.."/>
<xsl:param name="FallbackBondApplicable" select="/.."/>
<xsl:param name="CalculationMethod" select="/.."/>
<xsl:param name="CalculationStyle" select="/.."/>
<xsl:param name="FinalPriceExchangeCalc" select="/.."/>
<xsl:param name="SpreadCalculationMethod" select="/.."/>
<xsl:param name="CouponRate" select="/.."/>
<xsl:param name="Maturity" select="/.."/>
<xsl:param name="RelatedBondValue" select="/.."/>
<xsl:param name="RelatedBondID" select="/.."/>
<xsl:param name="MTMRateSource" select="/.."/>
<xsl:param name="MTMRateSourcePage" select="/.."/>
<xsl:param name="MTMFixingDate" select="/.."/>
<xsl:param name="MTMFixingHolidayCentres" select="/.."/>
<xsl:param name="MTMFixingTime" select="/.."/>
<xsl:param name="MTMLocation" select="/.."/>
<xsl:param name="MTMCutoffTime" select="/.."/>
<xsl:param name="CalculationPeriodDays" select="/.."/>
<xsl:param name="FraDiscounting" select="/.."/>
<xsl:param name="HasBreak" select="/.."/>
<xsl:param name="BreakFromSwap" select="/.."/>
<xsl:param name="BreakOverride" select="/.."/>
<xsl:param name="BreakCalculationMethod" select="/.."/>
<xsl:param name="BreakFirstDateTenor" select="/.."/>
<xsl:param name="BreakFrequency" select="/.."/>
<xsl:param name="BreakOptionA" select="/.."/>
<xsl:param name="BreakDate" select="/.."/>
<xsl:param name="BreakExpirationDate" select="/.."/>
<xsl:param name="BreakEarliestTime" select="/.."/>
<xsl:param name="BreakLatestTime" select="/.."/>
<xsl:param name="BreakCalcAgentA" select="/.."/>
<xsl:param name="BreakExpiryTime" select="/.."/>
<xsl:param name="BreakCashSettleCcy" select="/.."/>
<xsl:param name="BreakLocation" select="/.."/>
<xsl:param name="BreakHolidayCentre" select="/.."/>
<xsl:param name="BreakSettlement" select="/.."/>
<xsl:param name="BreakValuationDate" select="/.."/>
<xsl:param name="BreakValuationTime" select="/.."/>
<xsl:param name="BreakSource" select="/.."/>
<xsl:param name="BreakReferenceBanks" select="/.."/>
<xsl:param name="BreakQuotation" select="/.."/>
<xsl:param name="BreakMMVApplicableCSA" select="/.."/>
<xsl:param name="BreakCollateralCurrency" select="/.."/>
<xsl:param name="BreakCollateralInterestRate" select="/.."/>
<xsl:param name="BreakAgreedDiscountRate" select="/.."/>
<xsl:param name="BreakProtectedPartyA" select="/.."/>
<xsl:param name="BreakMutuallyAgreedCH" select="/.."/>
<xsl:param name="BreakPrescribedDocAdj" select="/.."/>
<xsl:param name="ExchangeUnderlying" select="/.."/>
<xsl:param name="SwapSpread" select="/.."/>
<xsl:param name="BondId1" select="/.."/>
<xsl:param name="BondName1" select="/.."/>
<xsl:param name="BondAmount1" select="/.."/>
<xsl:param name="BondPriceType1" select="/.."/>
<xsl:param name="BondPrice1" select="/.."/>
<xsl:param name="BondId2" select="/.."/>
<xsl:param name="BondName2" select="/.."/>
<xsl:param name="BondAmount2" select="/.."/>
<xsl:param name="BondPriceType2" select="/.."/>
<xsl:param name="BondPrice2" select="/.."/>
<xsl:param name="StubAt" select="/.."/>
<xsl:param name="IsUserStartStub" select="/.."/>
<xsl:param name="FixedStub" select="/.."/>
<xsl:param name="FixedStub_2" select="/.."/>
<xsl:param name="FloatStub" select="/.."/>
<xsl:param name="FloatStub_2" select="/.."/>
<xsl:param name="FrontAndBackStubs" select="/.."/>
<xsl:param name="FixedBackStub" select="/.."/>
<xsl:param name="FloatBackStub" select="/.."/>
<xsl:param name="BackStubIndexTenor1" select="/.."/>
<xsl:param name="BackStubIndexTenor2" select="/.."/>
<xsl:param name="BackStubLinearInterpolation" select="/.."/>
<xsl:param name="BackStubInitialInterpIndex" select="/.."/>
<xsl:param name="FirstFixedRegPdStartDate" select="/.."/>
<xsl:param name="FirstFixedRegPdStartDate_2" select="/.."/>
<xsl:param name="FirstFloatRegPdStartDate" select="/.."/>
<xsl:param name="FirstFloatRegPdStartDate_2" select="/.."/>
<xsl:param name="LastFixedRegPdEndDate" select="/.."/>
<xsl:param name="LastFixedRegPdEndDate_2" select="/.."/>
<xsl:param name="LastFloatRegPdEndDate" select="/.."/>
<xsl:param name="LastFloatRegPdEndDate_2" select="/.."/>
<xsl:param name="MasterAgreement" select="/.."/>
<xsl:param name="ManualConfirm" select="/.."/>
<xsl:param name="PlaceOfSettlementA" select="/.."/>
<xsl:param name="PlaceOfSettlementB" select="/.."/>
<xsl:param name="SettlementAgentA" select="/.."/>
<xsl:param name="SettlementAgentB" select="/.."/>
<xsl:param name="SettlementAgentSafeKeepA" select="/.."/>
<xsl:param name="SettlementAgentSafeKeepB" select="/.."/>
<xsl:param name="IntermediaryIDA" select="/.."/>
<xsl:param name="IntermediaryIDB" select="/.."/>
<xsl:param name="IntermediarySafeKeepA" select="/.."/>
<xsl:param name="IntermediarySafeKeepB" select="/.."/>
<xsl:param name="CustodianIDA" select="/.."/>
<xsl:param name="CustodianIDB" select="/.."/>
<xsl:param name="CustodianSafeKeepA" select="/.."/>
<xsl:param name="CustodianSafeKeepB" select="/.."/>
<xsl:param name="BuyerSellerIDA" select="/.."/>
<xsl:param name="BuyerSellerIDB" select="/.."/>
<xsl:param name="BuyerSellerSafeKeepA" select="/.."/>
<xsl:param name="BuyerSellerSafeKeepB" select="/.."/>
<xsl:param name="NovationExecution" select="/.."/>
<xsl:param name="ExclFromClearing" select="/.."/>
<xsl:param name="NonStdSettlInst" select="/.."/>
<xsl:param name="Normalised" select="/.."/>
<xsl:param name="DataMigrationId" select="/.."/>
<xsl:param name="NormalisedStubLength" select="/.."/>
<xsl:param name="ClientClearing" select="/.."/>
<xsl:param name="AutoSendForClearing" select="/.."/>
<xsl:param name="CBClearedTimestamp" select="/.."/>
<xsl:param name="CBTradeType" select="/.."/>
<xsl:param name="ASICMandatoryClearingIndicator" select="/.."/>
<xsl:param name="NewNovatedASICMandatoryClearingIndicator" select="/.."/>
<xsl:param name="PBEBTradeASICMandatoryClearingIndicator" select="/.."/>
<xsl:param name="PBClientTradeASICMandatoryClearingIndicator" select="/.."/>
<xsl:param name="CANMandatoryClearingIndicator" select="/.."/>
<xsl:param name="CANClearingExemptIndicator1PartyId" select="/.."/>
<xsl:param name="CANClearingExemptIndicator1Value" select="/.."/>
<xsl:param name="CANClearingExemptIndicator2PartyId" select="/.."/>
<xsl:param name="CANClearingExemptIndicator2Value" select="/.."/>
<xsl:param name="NewNovatedCANMandatoryClearingIndicator" select="/.."/>
<xsl:param name="NewNovatedCANClearingExemptIndicator1PartyId" select="/.."/>
<xsl:param name="NewNovatedCANClearingExemptIndicator1Value" select="/.."/>
<xsl:param name="NewNovatedCANClearingExemptIndicator2PartyId" select="/.."/>
<xsl:param name="NewNovatedCANClearingExemptIndicator2Value" select="/.."/>
<xsl:param name="PBEBTradeCANMandatoryClearingIndicator" select="/.."/>
<xsl:param name="PBEBTradeCANClearingExemptIndicator1PartyId" select="/.."/>
<xsl:param name="PBEBTradeCANClearingExemptIndicator1Value" select="/.."/>
<xsl:param name="PBEBTradeCANClearingExemptIndicator2PartyId" select="/.."/>
<xsl:param name="PBEBTradeCANClearingExemptIndicator2Value" select="/.."/>
<xsl:param name="PBClientTradeCANMandatoryClearingIndicator" select="/.."/>
<xsl:param name="PBClientTradeCANClearingExemptIndicator1PartyId" select="/.."/>
<xsl:param name="PBClientTradeCANClearingExemptIndicator1Value" select="/.."/>
<xsl:param name="PBClientTradeCANClearingExemptIndicator2PartyId" select="/.."/>
<xsl:param name="PBClientTradeCANClearingExemptIndicator2Value" select="/.."/>
<xsl:param name="ESMAMandatoryClearingIndicator" select="/.."/>
<xsl:param name="ESMAClearingExemptIndicator1PartyId" select="/.."/>
<xsl:param name="ESMAClearingExemptIndicator1Value" select="/.."/>
<xsl:param name="ESMAClearingExemptIndicator2PartyId" select="/.."/>
<xsl:param name="ESMAClearingExemptIndicator2Value" select="/.."/>
<xsl:param name="NewNovatedESMAMandatoryClearingIndicator" select="/.."/>
<xsl:param name="NewNovatedESMAClearingExemptIndicator1PartyId" select="/.."/>
<xsl:param name="NewNovatedESMAClearingExemptIndicator1Value" select="/.."/>
<xsl:param name="NewNovatedESMAClearingExemptIndicator2PartyId" select="/.."/>
<xsl:param name="NewNovatedESMAClearingExemptIndicator2Value" select="/.."/>
<xsl:param name="PBEBTradeESMAMandatoryClearingIndicator" select="/.."/>
<xsl:param name="PBEBTradeESMAClearingExemptIndicator1PartyId" select="/.."/>
<xsl:param name="PBEBTradeESMAClearingExemptIndicator1Value" select="/.."/>
<xsl:param name="PBEBTradeESMAClearingExemptIndicator2PartyId" select="/.."/>
<xsl:param name="PBEBTradeESMAClearingExemptIndicator2Value" select="/.."/>
<xsl:param name="PBClientTradeESMAMandatoryClearingIndicator" select="/.."/>
<xsl:param name="PBClientTradeESMAClearingExemptIndicator1PartyId" select="/.."/>
<xsl:param name="PBClientTradeESMAClearingExemptIndicator1Value" select="/.."/>
<xsl:param name="PBClientTradeESMAClearingExemptIndicator2PartyId" select="/.."/>
<xsl:param name="PBClientTradeESMAClearingExemptIndicator2Value" select="/.."/>
<xsl:param name="FCAMandatoryClearingIndicator" select="/.."/>
<xsl:param name="FCAClearingExemptIndicator1PartyId" select="/.."/>
<xsl:param name="FCAClearingExemptIndicator1Value" select="/.."/>
<xsl:param name="FCAClearingExemptIndicator2PartyId" select="/.."/>
<xsl:param name="FCAClearingExemptIndicator2Value" select="/.."/>
<xsl:param name="NewNovatedFCAMandatoryClearingIndicator" select="/.."/>
<xsl:param name="NewNovatedFCAClearingExemptIndicator1PartyId" select="/.."/>
<xsl:param name="NewNovatedFCAClearingExemptIndicator1Value" select="/.."/>
<xsl:param name="NewNovatedFCAClearingExemptIndicator2PartyId" select="/.."/>
<xsl:param name="NewNovatedFCAClearingExemptIndicator2Value" select="/.."/>
<xsl:param name="PBEBTradeFCAMandatoryClearingIndicator" select="/.."/>
<xsl:param name="PBEBTradeFCAClearingExemptIndicator1PartyId" select="/.."/>
<xsl:param name="PBEBTradeFCAClearingExemptIndicator1Value" select="/.."/>
<xsl:param name="PBEBTradeFCAClearingExemptIndicator2PartyId" select="/.."/>
<xsl:param name="PBEBTradeFCAClearingExemptIndicator2Value" select="/.."/>
<xsl:param name="PBClientTradeFCAMandatoryClearingIndicator" select="/.."/>
<xsl:param name="PBClientTradeFCAClearingExemptIndicator1PartyId" select="/.."/>
<xsl:param name="PBClientTradeFCAClearingExemptIndicator1Value" select="/.."/>
<xsl:param name="PBClientTradeFCAClearingExemptIndicator2PartyId" select="/.."/>
<xsl:param name="PBClientTradeFCAClearingExemptIndicator2Value" select="/.."/>
<xsl:param name="HKMAMandatoryClearingIndicator" select="/.."/>
<xsl:param name="HKMAClearingExemptIndicator1PartyId" select="/.."/>
<xsl:param name="HKMAClearingExemptIndicator1Value" select="/.."/>
<xsl:param name="HKMAClearingExemptIndicator2PartyId" select="/.."/>
<xsl:param name="HKMAClearingExemptIndicator2Value" select="/.."/>
<xsl:param name="NewNovatedHKMAMandatoryClearingIndicator" select="/.."/>
<xsl:param name="NewNovatedHKMAClearingExemptIndicator1PartyId" select="/.."/>
<xsl:param name="NewNovatedHKMAClearingExemptIndicator1Value" select="/.."/>
<xsl:param name="NewNovatedHKMAClearingExemptIndicator2PartyId" select="/.."/>
<xsl:param name="NewNovatedHKMAClearingExemptIndicator2Value" select="/.."/>
<xsl:param name="PBEBTradeHKMAMandatoryClearingIndicator" select="/.."/>
<xsl:param name="PBEBTradeHKMAClearingExemptIndicator1PartyId" select="/.."/>
<xsl:param name="PBEBTradeHKMAClearingExemptIndicator1Value" select="/.."/>
<xsl:param name="PBEBTradeHKMAClearingExemptIndicator2PartyId" select="/.."/>
<xsl:param name="PBEBTradeHKMAClearingExemptIndicator2Value" select="/.."/>
<xsl:param name="PBClientTradeHKMAMandatoryClearingIndicator" select="/.."/>
<xsl:param name="PBClientTradeHKMAClearingExemptIndicator1PartyId" select="/.."/>
<xsl:param name="PBClientTradeHKMAClearingExemptIndicator1Value" select="/.."/>
<xsl:param name="PBClientTradeHKMAClearingExemptIndicator2PartyId" select="/.."/>
<xsl:param name="PBClientTradeHKMAClearingExemptIndicator2Value" select="/.."/>
<xsl:param name="JFSAMandatoryClearingIndicator" select="/.."/>
<xsl:param name="CFTCMandatoryClearingIndicator" select="/.."/>
<xsl:param name="CFTCClearingExemptIndicator1PartyId" select="/.."/>
<xsl:param name="CFTCClearingExemptIndicator1Value" select="/.."/>
<xsl:param name="CFTCClearingExemptIndicator2PartyId" select="/.."/>
<xsl:param name="CFTCClearingExemptIndicator2Value" select="/.."/>
<xsl:param name="CFTCInterAffiliateExemption" select="/.."/>
<xsl:param name="NewNovatedCFTCMandatoryClearingIndicator" select="/.."/>
<xsl:param name="NewNovatedCFTCClearingExemptIndicator1PartyId" select="/.."/>
<xsl:param name="NewNovatedCFTCClearingExemptIndicator1Value" select="/.."/>
<xsl:param name="NewNovatedCFTCClearingExemptIndicator2PartyId" select="/.."/>
<xsl:param name="NewNovatedCFTCClearingExemptIndicator2Value" select="/.."/>
<xsl:param name="NewNovatedCFTCInterAffiliateExemption" select="/.."/>
<xsl:param name="PBEBTradeCFTCMandatoryClearingIndicator" select="/.."/>
<xsl:param name="PBEBTradeJFSAMandatoryClearingIndicator" select="/.."/>
<xsl:param name="PBEBTradeCFTCClearingExemptIndicator1PartyId" select="/.."/>
<xsl:param name="PBEBTradeCFTCClearingExemptIndicator1Value" select="/.."/>
<xsl:param name="PBEBTradeCFTCClearingExemptIndicator2PartyId" select="/.."/>
<xsl:param name="PBEBTradeCFTCClearingExemptIndicator2Value" select="/.."/>
<xsl:param name="PBEBTradeCFTCInterAffiliateExemption" select="/.."/>
<xsl:param name="PBClientTradeCFTCMandatoryClearingIndicator" select="/.."/>
<xsl:param name="PBClientTradeJFSAMandatoryClearingIndicator" select="/.."/>
<xsl:param name="PBClientTradeCFTCClearingExemptIndicator1PartyId" select="/.."/>
<xsl:param name="PBClientTradeCFTCClearingExemptIndicator1Value" select="/.."/>
<xsl:param name="PBClientTradeCFTCClearingExemptIndicator2PartyId" select="/.."/>
<xsl:param name="PBClientTradeCFTCClearingExemptIndicator2Value" select="/.."/>
<xsl:param name="PBClientTradeCFTCInterAffiliateExemption" select="/.."/>
<xsl:param name="MASMandatoryClearingIndicator" select="/.."/>
<xsl:param name="NewNovatedMASMandatoryClearingIndicator" select="/.."/>
<xsl:param name="PBEBTradeMASMandatoryClearingIndicator" select="/.."/>
<xsl:param name="PBClientTradeMASMandatoryClearingIndicator" select="/.."/>
<xsl:param name="ClearingHouseId" select="/.."/>
<xsl:param name="ClearingBrokerId" select="/.."/>
<xsl:param name="OriginatingEvent" select="/.."/>
<xsl:param name="OriginatingTradeId" select="/.."/>
<xsl:param name="SendToCLS" select="/.."/>
<xsl:param name="ESMAFrontloading" select="/.."/>
<xsl:param name="ESMAClearingExemption" select="/.."/>
<xsl:param name="BackLoadingFlag" select="/.."/>
<xsl:param name="BulkAction" select="/.."/>
<xsl:param name="Novation" select="/.."/>
<xsl:param name="PartialNovation" select="/.."/>
<xsl:param name="FourWayNovation" select="/.."/>
<xsl:param name="NovationTradeDate" select="/.."/>
<xsl:param name="NovationDate" select="/.."/>
<xsl:param name="NovatedAmount" select="/.."/>
<xsl:param name="NovatedAmount_2" select="/.."/>
<xsl:param name="NovatedCurrency" select="/.."/>
<xsl:param name="NovatedCurrency_2" select="/.."/>
<xsl:param name="NovatedFV" select="/.."/>
<xsl:param name="FullFirstCalculationPeriod" select="/.."/>
<xsl:param name="NonReliance" select="/.."/>
<xsl:param name="PreserveEarlyTerminationProvision" select="/.."/>
<xsl:param name="CopyPremiumToNewTrade" select="/.."/>
<xsl:param name="CopyInitialRateToNewTradeIfRelevant" select="/.."/>
<xsl:param name="IntendedClearingHouse" select="/.."/>
<xsl:param name="NovationBulkAction" select="/.."/>
<xsl:param name="NovationFallbacksSupplement" select="/.."/>
<xsl:param name="NovationFallbacksAmendment" select="/.."/>
<xsl:param name="ClientClearingFlag" select="/.."/>
<xsl:param name="ClearingBroker" select="/.."/>
<xsl:param name="AdditionalPayment" select="/.."/>
<xsl:param name="OptionStyle" select="/.."/>
<xsl:param name="OptionType" select="/.."/>
<xsl:param name="OptionExpirationDate" select="/.."/>
<xsl:param name="OptionExpirationDateConvention" select="/.."/>
<xsl:param name="OptionHolidayCenters" select="/.."/>
<xsl:param name="OptionEarliestTime" select="/.."/>
<xsl:param name="OptionEarliestTimeHolidayCentre" select="/.."/>
<xsl:param name="OptionExpiryTime" select="/.."/>
<xsl:param name="ValuationTime" select="/.."/>
<xsl:param name="OptionExpiryTimeHolidayCentre" select="/.."/>
<xsl:param name="OptionSpecificExpiryTime" select="/.."/>
<xsl:param name="OptionLocation" select="/.."/>
<xsl:param name="OptionCalcAgent" select="/.."/>
<xsl:param name="OptionAutomaticExercise" select="/.."/>
<xsl:param name="OptionThreshold" select="/.."/>
<xsl:param name="ManualExercise" select="/.."/>
<xsl:param name="OptionWrittenExerciseConf" select="/.."/>
<xsl:param name="PremiumAmount" select="/.."/>
<xsl:param name="PremiumCurrency" select="/.."/>
<xsl:param name="PremiumPaymentDate" select="/.."/>
<xsl:param name="PremiumHolidayCentres" select="/.."/>
<xsl:param name="Strike" select="/.."/>
<xsl:param name="StrikeCurrency" select="/.."/>
<xsl:param name="StrikePercentage" select="/.."/>
<xsl:param name="StrikeDate" select="/.."/>
<xsl:param name="OptionSettlement" select="/.."/>
<xsl:param name="OptionCashSettlementValuationTime" select="/.."/>
<xsl:param name="OptionSpecificValuationTime" select="/.."/>
<xsl:param name="OptionCashSettlementValuationDate" select="/.."/>
<xsl:param name="OptionCashSettlementPaymentDate" select="/.."/>
<xsl:param name="OptionCashSettlementMethod" select="/.."/>
<xsl:param name="OptionCashSettlementQuotationRate" select="/.."/>
<xsl:param name="OptionCashSettlementRateSource" select="/.."/>
<xsl:param name="OptionCashSettlementReferenceBanks" select="/.."/>
<xsl:param name="OptionMMVApplicableCSA" select="/.."/>
<xsl:param name="BarrierType" select="/.."/>
<xsl:param name="KnockInTriggerType" select="/.."/>
<xsl:param name="KnockInPrice" select="/.."/>
<xsl:param name="KnockInPeriodStartDate" select="/.."/>
<xsl:param name="KnockInPeriodEndDate" select="/.."/>
<xsl:param name="KnockInValuationTime" select="/.."/>
<xsl:param name="KnockOutTriggerType" select="/.."/>
<xsl:param name="KnockOutPrice" select="/.."/>
<xsl:param name="KnockOutPeriodStartDate" select="/.."/>
<xsl:param name="KnockOutPeriodEndDate" select="/.."/>
<xsl:param name="KnockOutValuationTime" select="/.."/>
<xsl:param name="Rebate" select="/.."/>
<xsl:param name="RebateAmount" select="/.."/>
<xsl:param name="RebateAmountPaymentDate" select="/.."/>
<xsl:param name="RebateAmountPaymentLag" select="/.."/>
<xsl:param name="KnockObservationDate" select="/.."/>
<xsl:param name="ClearedPhysicalSettlement" select="/.."/>
<xsl:param name="UnderlyingSwapClearingHouse" select="/.."/>
<xsl:param name="UnderlyingSwapClientClearing" select="/.."/>
<xsl:param name="UnderlyingSwapAutoSendForClearing" select="/.."/>
<xsl:param name="AutoCreateExercised" select="/.."/>
<xsl:param name="ConvertUnderlyingSwapToRFR" select="/.."/>
<xsl:param name="PricedToClearCCP" select="/.."/>
<xsl:param name="AgreedDiscountRate" select="/.."/>
<xsl:param name="EconomicAmendmentType" select="/.."/>
<xsl:param name="EconomicAmendmentReason" select="/.."/>
<xsl:param name="CancelableCalcAgent" select="/.."/>
<xsl:param name="SwapRateFallbacksAmendment" select="/.."/>
<xsl:param name="ClearingTakeupClientId" select="/.."/>
<xsl:param name="ClearingTakeupClientName" select="/.."/>
<xsl:param name="ClearingTakeupClientTradeId" select="/.."/>
<xsl:param name="ClearingTakeupExecSrcId" select="/.."/>
<xsl:param name="ClearingTakeupExecSrcName" select="/.."/>
<xsl:param name="ClearingTakeupExecSrcTradeId" select="/.."/>
<xsl:param name="ClearingTakeupCorrelationId" select="/.."/>
<xsl:param name="ClearingTakeupClearingHouseTradeId" select="/.."/>
<xsl:param name="ClearingTakeupOriginatingEvent" select="/.."/>
<xsl:param name="ClearingTakeupBlockTradeId" select="/.."/>
<xsl:param name="ClearingTakeupSentBy" select="/.."/>
<xsl:param name="ClearingTakeupCreditTokenIssuer" select="/.."/>
<xsl:param name="ClearingTakeupCreditToken" select="/.."/>
<xsl:param name="ClearingTakeupClearingStatus" select="/.."/>
<xsl:param name="ClearingTakeupVenueLEI" select="/.."/>
<xsl:param name="ClearingTakeupVenueLEIScheme" select="/.."/>
<xsl:param name="AssociatedTrade" select="/.."/>
<xsl:param name="DocsType" select="/.."/>
<xsl:param name="DocsSubType" select="/.."/>
<xsl:param name="ContractualDefinitions" select="/.."/>
<xsl:param name="ContractualSupplement" select="/.."/>
<xsl:param name="CanadianSupplement" select="/.."/>
<xsl:param name="ExchangeTradedContractNearest" select="/.."/>
<xsl:param name="RestructuringCreditEvent" select="/.."/>
<xsl:param name="CalculationAgentCity" select="/.."/>
<xsl:param name="RefEntName" select="/.."/>
<xsl:param name="RefEntStdId" select="/.."/>
<xsl:param name="REROPairStdId" select="/.."/>
<xsl:param name="RefOblRERole" select="/.."/>
<xsl:param name="RefOblSecurityIdType" select="/.."/>
<xsl:param name="RefOblSecurityId" select="/.."/>
<xsl:param name="BloombergID" select="/.."/>
<xsl:param name="RefOblMaturity" select="/.."/>
<xsl:param name="RefOblCoupon" select="/.."/>
<xsl:param name="RefOblPrimaryObligor" select="/.."/>
<xsl:param name="BorrowerNames" select="/.."/>
<xsl:param name="FacilityType" select="/.."/>
<xsl:param name="CreditAgreementDate" select="/.."/>
<xsl:param name="IsSecuredList" select="/.."/>
<xsl:param name="CashSettlementOnly" select="/.."/>
<xsl:param name="Continuity" select="/.."/>
<xsl:param name="DeliveryOfCommitments" select="/.."/>
<xsl:param name="ObligationCategory" select="/.."/>
<xsl:param name="DesignatedPriority" select="/.."/>
<xsl:param name="LegalFinalMaturity" select="/.."/>
<xsl:param name="OriginalPrincipalAmount" select="/.."/>
<xsl:param name="CreditDateAdjustments">
<xsl:call-template name="lcl:SWDMLTrade.CreditDateAdjustments"/>
</xsl:param>
<xsl:param name="OptionalEarlyTermination" select="/.."/>
<xsl:param name="ReferencePrice" select="/.."/>
<xsl:param name="ReferencePolicy" select="/.."/>
<xsl:param name="PaymentDelay" select="/.."/>
<xsl:param name="StepUpProvision" select="/.."/>
<xsl:param name="WACCapInterestProvision" select="/.."/>
<xsl:param name="InterestShortfallCapIndicator" select="/.."/>
<xsl:param name="InterestShortfallCompounding" select="/.."/>
<xsl:param name="InterestShortfallCapBasis" select="/.."/>
<xsl:param name="InterestShortfallRateSource" select="/.."/>
<xsl:param name="MortgagePaymentFrequency" select="/.."/>
<xsl:param name="MortgageFinalMaturity" select="/.."/>
<xsl:param name="MortgageOriginalAmount" select="/.."/>
<xsl:param name="MortgageInitialFactor" select="/.."/>
<xsl:param name="MortgageSector" select="/.."/>
<xsl:param name="MortgageInsurer" select="/.."/>
<xsl:param name="IndexName" select="/.."/>
<xsl:param name="IndexId" select="/.."/>
<xsl:param name="IndexAnnexDate" select="/.."/>
<xsl:param name="IndexTradedRate" select="/.."/>
<xsl:param name="UpfrontFee" select="/.."/>
<xsl:param name="UpfrontFeeAmount" select="/.."/>
<xsl:param name="UpfrontFeeCurrency" select="/.."/>
<xsl:param name="UpfrontFeeDate" select="/.."/>
<xsl:param name="UpfrontFeePayer" select="/.."/>
<xsl:param name="AttachmentPoint" select="/.."/>
<xsl:param name="ExhaustionPoint" select="/.."/>
<xsl:param name="PublicationDate" select="/.."/>
<xsl:param name="MasterAgreementDate" select="/.."/>
<xsl:param name="MasterAgreementVersion" select="/.."/>
<xsl:param name="AmendmentTradeDate" select="/.."/>
<xsl:param name="SettlementCurrency" select="/.."/>
<xsl:param name="ReferenceCurrency" select="/.."/>
<xsl:param name="SettlementRateOption" select="/.."/>
<xsl:param name="NonDeliverable" select="/.."/>
<xsl:param name="NonDeliverable2" select="/.."/>
<xsl:param name="FxFixingDate">
<xsl:call-template name="lcl:SWDMLTrade.FxFixingDate"/>
</xsl:param>
<xsl:param name="ValuationDateType" select="/.."/>
<xsl:param name="ValuationDateType_2" select="/.."/>
<xsl:param name="SettlementCurrency_2" select="/.."/>
<xsl:param name="ReferenceCurrency_2" select="/.."/>
<xsl:param name="SettlementRateOption_2" select="/.."/>
<xsl:param name="FxFixingDate_2">
<xsl:call-template name="lcl:SWDMLTrade.FxFixingDate_2"/>
</xsl:param>
<xsl:param name="OutsideNovationTradeDate" select="/.."/>
<xsl:param name="OutsideNovationNovationDate" select="/.."/>
<xsl:param name="OutsideNovationOutgoingParty" select="/.."/>
<xsl:param name="OutsideNovationIncomingParty" select="/.."/>
<xsl:param name="OutsideNovationRemainingParty" select="/.."/>
<xsl:param name="OutsideNovationFullFirstCalculationPeriod" select="/.."/>
<xsl:param name="CalcAgentA" select="/.."/>
<xsl:param name="AmendmentType" select="/.."/>
<xsl:param name="AmendmentEffectiveDate" select="/.."/>
<xsl:param name="CancellationType" select="/.."/>
<xsl:param name="Cancelable" select="/.."/>
<xsl:param name="CancelableDirectionA" select="/.."/>
<xsl:param name="CancelableOptionStyle" select="/.."/>
<xsl:param name="CancelableFirstExerciseDate" select="/.."/>
<xsl:param name="CancelableExerciseFrequency" select="/.."/>
<xsl:param name="CancelableEarliestTime" select="/.."/>
<xsl:param name="CancelableExpiryTime" select="/.."/>
<xsl:param name="CancelableExerciseLag" select="/.."/>
<xsl:param name="CancelableHolidayCentre" select="/.."/>
<xsl:param name="CancelableLocation" select="/.."/>
<xsl:param name="CancelableConvention" select="/.."/>
<xsl:param name="CancelableFUC" select="/.."/>
<xsl:param name="CancelableDayType" select="/.."/>
<xsl:param name="CancelableLagConvention" select="/.."/>
<xsl:param name="CancelableRollCentres" select="/.."/>
<xsl:param name="CancelablePremium" select="/.."/>
<xsl:param name="CancellationForwardPremium" select="/.."/>
<xsl:param name="SettlementAgency" select="/.."/>
<xsl:param name="SettlementAgencyModel" select="/.."/>
<xsl:param name="OfflineLeg1" select="/.."/>
<xsl:param name="OfflineLeg2" select="/.."/>
<xsl:param name="OfflineSpread" select="/.."/>
<xsl:param name="OfflineSpreadLeg" select="/.."/>
<xsl:param name="OfflineSpreadParty" select="/.."/>
<xsl:param name="OfflineSpreadDirection" select="/.."/>
<xsl:param name="OfflineAdditionalDetails" select="/.."/>
<xsl:param name="OfflineOrigRef" select="/.."/>
<xsl:param name="OfflineOrigRef_2" select="/.."/>
<xsl:param name="OfflineTradeDesk" select="/.."/>
<xsl:param name="OfflineTradeDesk_2" select="/.."/>
<xsl:param name="OfflineProductType" select="/.."/>
<xsl:param name="OfflineExpirationDate" select="/.."/>
<xsl:param name="OfflineOptionType" select="/.."/>
<xsl:param name="EquityRic" select="/.."/>
<xsl:param name="eqStartDate" select="/.."/>
<xsl:param name="eqEndDate" select="/.."/>
<xsl:param name="initialAmtPayer" select="/.."/>
<xsl:param name="noOfGuaranteedPrd" select="/.."/>
<xsl:param name="prePaymentAmount" select="/.."/>
<xsl:param name="prePaymentAmountCurrency" select="/.."/>
<xsl:param name="prePaymentDate" select="/.."/>
<xsl:param name="knockOutCommencementDate" select="/.."/>
<xsl:param name="customDate" select="/.."/>
<xsl:param name="swPaymentDateOffset" select="/.."/>
<xsl:param name="targetPerformance" select="/.."/>
<xsl:param name="knockOutPrice" select="/.."/>
<xsl:param name="knockOutType" select="/.."/>
<xsl:param name="spotPrice" select="/.."/>
<xsl:param name="spotPriceCurrency" select="/.."/>
<xsl:param name="forwardPrice" select="/.."/>
<xsl:param name="forwardPriceCurrency" select="/.."/>
<xsl:param name="purchaseFrequency" select="/.."/>
<xsl:param name="settlementFrequency" select="/.."/>
<xsl:param name="NumberOfSharesPerDay" select="/.."/>
<xsl:param name="gearingFactor" select="/.."/>
<xsl:param name="leverageTriggerPrice" select="/.."/>
<xsl:param name="higherForwardPrice" select="/.."/>
<xsl:param name="lowerForwardPrice" select="/.."/>
<xsl:param name="AccumulatorSettlementDetails" select="/.."/>
<xsl:param name="OptionQuantity" select="/.."/>
<xsl:param name="OptionNumberOfShares" select="/.."/>
<xsl:param name="Price" select="/.."/>
<xsl:param name="PricePerOptionCurrency" select="/.."/>
<xsl:param name="ExchangeLookAlike" select="/.."/>
<xsl:param name="AdjustmentMethod" select="/.."/>
<xsl:param name="MasterConfirmationDate" select="/.."/>
<xsl:param name="Multiplier" select="/.."/>
<xsl:param name="OptionExchange" select="/.."/>
<xsl:param name="RelatedExchange" select="/.."/>
<xsl:param name="DefaultSettlementMethod" select="/.."/>
<xsl:param name="SettlementPriceDefaultElectionMethod" select="/.."/>
<xsl:param name="DesignatedContract" select="/.."/>
<xsl:param name="FxDeterminationMethod" select="/.."/>
<xsl:param name="SWFXRateSource" select="/.."/>
<xsl:param name="SWFXRateSourcePage" select="/.."/>
<xsl:param name="SWFXHourMinuteTime" select="/.."/>
<xsl:param name="SWFXBusinessCenter" select="/.."/>
<xsl:param name="SettlementMethodElectionDate" select="/.."/>
<xsl:param name="SettlementMethodElectingParty" select="/.."/>
<xsl:param name="SettlementDateOffset" select="/.."/>
<xsl:param name="SettlementType" select="/.."/>
<xsl:param name="SettlementDate" select="/.."/>
<xsl:param name="MultipleExchangeIndexAnnex" select="/.."/>
<xsl:param name="ComponentSecurityIndexAnnex" select="/.."/>
<xsl:param name="LocalJurisdiction" select="/.."/>
<xsl:param name="OptionHedgingDisruption" select="/.."/>
<xsl:param name="OptionLossOfStockBorrow" select="/.."/>
<xsl:param name="OptionMaximumStockLoanRate" select="/.."/>
<xsl:param name="OptionIncreasedCostOfStockBorrow" select="/.."/>
<xsl:param name="OptionInitialStockLoanRate" select="/.."/>
<xsl:param name="OptionIncreasedCostOfHedging" select="/.."/>
<xsl:param name="OptionForeignOwnershipEvent" select="/.."/>
<xsl:param name="OptionEntitlement" select="/.."/>
<xsl:param name="FxFeature" select="/.."/>
<xsl:param name="ReferencePriceSource" select="/.."/>
<xsl:param name="ReferencePricePage" select="/.."/>
<xsl:param name="ReferencePriceTime" select="/.."/>
<xsl:param name="ReferencePriceCity" select="/.."/>
<xsl:param name="MinimumNumberOfOptions" select="/.."/>
<xsl:param name="IntegralMultiple" select="/.."/>
<xsl:param name="MaximumNumberOfOptions" select="/.."/>
<xsl:param name="ExerciseCommencementDate" select="/.."/>
<xsl:param name="BermudaExerciseDates">
<xsl:call-template name="lcl:SWDMLTrade.BermudaExerciseDates"/>
</xsl:param>
<xsl:param name="BermudaFrequency" select="/.."/>
<xsl:param name="BermudaFirstDate" select="/.."/>
<xsl:param name="BermudaFinalDate" select="/.."/>
<xsl:param name="LatestExerciseTimeMethod" select="/.."/>
<xsl:param name="LatestExerciseSpecificTime" select="/.."/>
<xsl:param name="DcCurrency" select="/.."/>
<xsl:param name="DcDelta" select="/.."/>
<xsl:param name="DcEventTypeA" select="/.."/>
<xsl:param name="DcExchange" select="/.."/>
<xsl:param name="DcExpiryDate" select="/.."/>
<xsl:param name="DcFuturesCode" select="/.."/>
<xsl:param name="DcOffshoreCross" select="/.."/>
<xsl:param name="DcOffshoreCrossLocation" select="/.."/>
<xsl:param name="DcPrice" select="/.."/>
<xsl:param name="DcQuantity" select="/.."/>
<xsl:param name="DcRequired" select="/.."/>
<xsl:param name="DcRic" select="/.."/>
<xsl:param name="DcDescription" select="/.."/>
<xsl:param name="AveragingInOut" select="/.."/>
<xsl:param name="AveragingDateTimes">
<xsl:call-template name="lcl:SWDMLTrade.AveragingDateTimes"/>
</xsl:param>
<xsl:param name="MarketDisruption" select="/.."/>
<xsl:param name="AveragingFrequency" select="/.."/>
<xsl:param name="AveragingRollConvention" select="/.."/>
<xsl:param name="AveragingStartDate" select="/.."/>
<xsl:param name="AveragingEndDate" select="/.."/>
<xsl:param name="AveragingBusinessDayConvention" select="/.."/>
<xsl:param name="ReferenceFXRate" select="/.."/>
<xsl:param name="HedgeLevel" select="/.."/>
<xsl:param name="Basis" select="/.."/>
<xsl:param name="ImpliedLevel" select="/.."/>
<xsl:param name="PremiumPercent" select="/.."/>
<xsl:param name="StrikePercent" select="/.."/>
<xsl:param name="BaseNotional" select="/.."/>
<xsl:param name="BaseNotionalCurrency" select="/.."/>
<xsl:param name="BreakOutTrade" select="/.."/>
<xsl:param name="SplitCollateral" select="/.."/>
<xsl:param name="PeriodPaymentDate" select="/.."/>
<xsl:param name="OpenUnits" select="/.."/>
<xsl:param name="DeclaredCashDividendPercentage" select="/.."/>
<xsl:param name="DeclaredCashEquivalentDividendPercentage" select="/.."/>
<xsl:param name="DividendPayer" select="/.."/>
<xsl:param name="DividendReceiver" select="/.."/>
<xsl:param name="DividendPeriods">
<xsl:call-template name="lcl:SWDMLTrade.DividendPeriods"/>
</xsl:param>
<xsl:param name="SpecialDividends" select="/.."/>
<xsl:param name="MaterialDividend" select="/.."/>
<xsl:param name="FixedPayer" select="/.."/>
<xsl:param name="FixedReceiver" select="/.."/>
<xsl:param name="FixedPeriods">
<xsl:call-template name="lcl:SWDMLTrade.FixedPeriods"/>
</xsl:param>
<xsl:param name="EquityAveragingObservations">
<xsl:call-template name="lcl:SWDMLTrade.EquityAveragingObservations"/>
</xsl:param>
<xsl:param name="EquityInitialSpot" select="/.."/>
<xsl:param name="EquityCap" select="/.."/>
<xsl:param name="EquityCapPercentage" select="/.."/>
<xsl:param name="EquityFloor" select="/.."/>
<xsl:param name="EquityFloorPercentage" select="/.."/>
<xsl:param name="EquityNotional" select="/.."/>
<xsl:param name="EquityNotionalCurrency" select="/.."/>
<xsl:param name="EquityFrequency" select="/.."/>
<xsl:param name="EquityValuationMethod" select="/.."/>
<xsl:param name="EquityFrequencyConvention" select="/.."/>
<xsl:param name="EquityFreqFirstDate" select="/.."/>
<xsl:param name="EquityFreqFinalDate" select="/.."/>
<xsl:param name="EquityFreqRoll" select="/.."/>
<xsl:param name="EquityListedValuationDates">
<xsl:call-template name="lcl:SWDMLTrade.EquityListedValuationDates"/>
</xsl:param>
<xsl:param name="EquityListedDatesConvention" select="/.."/>
<xsl:param name="StrategyType" select="/.."/>
<xsl:param name="StrategyDeltaLeg" select="/.."/>
<xsl:param name="StrategyDeltaQuantity" select="/.."/>
<xsl:param name="StrategyComments" select="/.."/>
<xsl:param name="StrategySingleTrade" select="/.."/>
<xsl:param name="StrategyLegs">
<xsl:call-template name="lcl:SWDMLTrade.StrategyLegs"/>
</xsl:param>
<xsl:param name="VegaNotional" select="/.."/>
<xsl:param name="ExpectedN" select="/.."/>
<xsl:param name="ExpectedNOverride" select="/.."/>
<xsl:param name="VarianceAmount" select="/.."/>
<xsl:param name="VarianceStrikePrice" select="/.."/>
<xsl:param name="VolatilityStrikePrice" select="/.."/>
<xsl:param name="VarianceCapIndicator" select="/.."/>
<xsl:param name="VarianceCapFactor" select="/.."/>
<xsl:param name="TotalVarianceCap" select="/.."/>
<xsl:param name="VolatilityCapIndicator" select="/.."/>
<xsl:param name="TotalVolatilityCap" select="/.."/>
<xsl:param name="VolatilityCapFactor" select="/.."/>
<xsl:param name="ObservationStartDate" select="/.."/>
<xsl:param name="ValuationDate" select="/.."/>
<xsl:param name="InitialSharePriceOrIndexLevel" select="/.."/>
<xsl:param name="ClosingSharePriceOrClosingIndexLevelIndicator" select="/.."/>
<xsl:param name="FuturesPriceValuation" select="/.."/>
<xsl:param name="AllDividends" select="/.."/>
<xsl:param name="SettlementCurrencyVegaNotional" select="/.."/>
<xsl:param name="VegaFxRate" select="/.."/>
<xsl:param name="HolidayDates">
<xsl:call-template name="lcl:SWDMLTrade.HolidayDates"/>
</xsl:param>
<xsl:param name="DispLegs">
<xsl:call-template name="lcl:SWDMLTrade.DispLegs"/>
</xsl:param>
<xsl:param name="DispLegsSW">
<xsl:call-template name="lcl:SWDMLTrade.DispLegsSW"/>
</xsl:param>
<xsl:param name="BulletIndicator" select="/.."/>
<xsl:param name="DocsSelection" select="/.."/>
<xsl:param name="NovationReporting">
<xsl:call-template name="lcl:SWDMLTrade.NovationReporting"/>
</xsl:param>
<xsl:param name="InterestLegDrivenIndicator" select="/.."/>
<xsl:param name="EquityFrontStub" select="/.."/>
<xsl:param name="EquityEndStub" select="/.."/>
<xsl:param name="InterestFrontStub" select="/.."/>
<xsl:param name="InterestEndStub" select="/.."/>
<xsl:param name="FixedRateIndicator" select="/.."/>
<xsl:param name="EswFixingDateOffset" select="/.."/>
<xsl:param name="DividendPaymentDates" select="/.."/>
<xsl:param name="DividendPaymentOffset" select="/.."/>
<xsl:param name="EswDividendAmount" select="/.."/>
<xsl:param name="EswDividendPeriod" select="/.."/>
<xsl:param name="DividendPercentage" select="/.."/>
<xsl:param name="DividendReinvestment" select="/.."/>
<xsl:param name="EswDeclaredCashDividendPercentage" select="/.."/>
<xsl:param name="EswDeclaredCashEquivalentDividendPercentage" select="/.."/>
<xsl:param name="EswDividendSettlementCurrency" select="/.."/>
<xsl:param name="EswNonCashDividendTreatment" select="/.."/>
<xsl:param name="EswDividendComposition" select="/.."/>
<xsl:param name="EswSpecialDividends" select="/.."/>
<xsl:param name="EswDividendValuationOffset" select="/.."/>
<xsl:param name="EswDividendValuationFrequency" select="/.."/>
<xsl:param name="EswDividendInitialValuation" select="/.."/>
<xsl:param name="EswDividendFinalValuation" select="/.."/>
<xsl:param name="EswDividendValuationDay" select="/.."/>
<xsl:param name="EswDividendValuationCustomDatesInterim">
<xsl:call-template name="lcl:SWDMLTrade.EswDividendValuationCustomDatesInterim"/>
</xsl:param>
<xsl:param name="EswDividendValuationCustomDateFinal" select="/.."/>
<xsl:param name="ExitReason" select="/.."/>
<xsl:param name="TransactionDate" select="/.."/>
<xsl:param name="EffectiveDate" select="/.."/>
<xsl:param name="EquityHolidayCentres" select="/.."/>
<xsl:param name="OtherValuationBusinessCenters" select="/.."/>
<xsl:param name="EswFuturesPriceValuation" select="/.."/>
<xsl:param name="EswFpvFinalPriceElectionFallback" select="/.."/>
<xsl:param name="EswDesignatedMaturity" select="/.."/>
<xsl:param name="EswEquityValConvention" select="/.."/>
<xsl:param name="EswInterestFloatConvention" select="/.."/>
<xsl:param name="EswInterestFloatDayBasis" select="/.."/>
<xsl:param name="EswInterestFloatingRateIndex" select="/.."/>
<xsl:param name="EswInterestFixedRate" select="/.."/>
<xsl:param name="EswInterestSpreadOverIndex" select="/.."/>
<xsl:param name="EswInterestSpreadOverIndexStep" select="/.."/>
<xsl:param name="EswLocalJurisdiction" select="/.."/>
<xsl:param name="EswReferencePriceSource" select="/.."/>
<xsl:param name="EswReferencePricePage" select="/.."/>
<xsl:param name="EswReferencePriceTime" select="/.."/>
<xsl:param name="EswReferencePriceCity" select="/.."/>
<xsl:param name="EswNotionalAmount" select="/.."/>
<xsl:param name="EswNotionalCurrency" select="/.."/>
<xsl:param name="EswOpenUnits" select="/.."/>
<xsl:param name="EswInitialUnits" select="/.."/>
<xsl:param name="FeeIn" select="/.."/>
<xsl:param name="FeeInOutIndicator" select="/.."/>
<xsl:param name="FeeOut" select="/.."/>
<xsl:param name="FinalPriceDefaultElection" select="/.."/>
<xsl:param name="FinalValuationDate" select="/.."/>
<xsl:param name="FullyFundedAmount" select="/.."/>
<xsl:param name="FullyFundedIndicator" select="/.."/>
<xsl:param name="FullyFundedFixedRate" select="/.."/>
<xsl:param name="FullyFundedDayCountFract" select="/.."/>
<xsl:param name="InitialPrice" select="/.."/>
<xsl:param name="InitialPriceElection" select="/.."/>
<xsl:param name="EquityNotionalReset" select="/.."/>
<xsl:param name="EswReferenceInitialPrice" select="/.."/>
<xsl:param name="EswReferenceFXRate" select="/.."/>
<xsl:param name="PaymentDateOffset" select="/.."/>
<xsl:param name="PaymentFrequency" select="/.."/>
<xsl:param name="EswFixingHolidayCentres" select="/.."/>
<xsl:param name="EswPaymentHolidayCentres" select="/.."/>
<xsl:param name="ReturnType" select="/.."/>
<xsl:param name="Synthetic" select="/.."/>
<xsl:param name="TerminationDate" select="/.."/>
<xsl:param name="ValuationDay" select="/.."/>
<xsl:param name="PaymentDay" select="/.."/>
<xsl:param name="ValuationFrequency" select="/.."/>
<xsl:param name="ValuationStartDate" select="/.."/>
<xsl:param name="EswSchedulingMethod" select="/.."/>
<xsl:param name="EswValuationDates">
<xsl:call-template name="lcl:SWDMLTrade.EswValuationDates"/>
</xsl:param>
<xsl:param name="EswFixingDates">
<xsl:call-template name="lcl:SWDMLTrade.EswFixingDates"/>
</xsl:param>
<xsl:param name="EswInterestLegPaymentDates">
<xsl:call-template name="lcl:SWDMLTrade.EswInterestLegPaymentDates"/>
</xsl:param>
<xsl:param name="EswEquityLegPaymentDates">
<xsl:call-template name="lcl:SWDMLTrade.EswEquityLegPaymentDates"/>
</xsl:param>
<xsl:param name="EswCompoundingDates">
<xsl:call-template name="lcl:SWDMLTrade.EswCompoundingDates"/>
</xsl:param>
<xsl:param name="EswCompoundingMethod" select="/.."/>
<xsl:param name="EswCompoundingFrequency" select="/.."/>
<xsl:param name="EswCalculationMethod" select="/.."/>
<xsl:param name="EswApplicableBusinessDays" select="/.."/>
<xsl:param name="EswObservationMethod" select="/.."/>
<xsl:param name="EswAdditionalBusinessDays" select="/.."/>
<xsl:param name="EswOffsetDays" select="/.."/>
<xsl:param name="EswObservationPeriod" select="/.."/>
<xsl:param name="EswDailyCapRate" select="/.."/>
<xsl:param name="EswDailyFloorRate" select="/.."/>
<xsl:param name="EswInterpolationMethod" select="/.."/>
<xsl:param name="EswInterpolationPeriod" select="/.."/>
<xsl:param name="EswAdditionalDisruptionEventIndicator" select="/.."/>
<xsl:param name="EswOverrideNotionalCalculation" select="/.."/>
<xsl:param name="EswPaymentDaysOffset" select="/.."/>
<xsl:param name="EswAveragingDatesIndicator" select="/.."/>
<xsl:param name="EswADTVIndicator" select="/.."/>
<xsl:param name="EswLimitationPercentage" select="/.."/>
<xsl:param name="EswLimitationPeriod" select="/.."/>
<xsl:param name="EswStockLoanRateIndicator" select="/.."/>
<xsl:param name="EswMaximumStockLoanRate" select="/.."/>
<xsl:param name="EswInitialStockLoanRate" select="/.."/>
<xsl:param name="EswOptionalEarlyTermination" select="/.."/>
<xsl:param name="EswBreakFundingRecovery" select="/.."/>
<xsl:param name="EswBreakFeeElection" select="/.."/>
<xsl:param name="EswBreakFeeRate" select="/.."/>
<xsl:param name="EswFinalPriceFee" select="/.."/>
<xsl:param name="EswFinalPriceFeeAmount" select="/.."/>
<xsl:param name="EswFinalPriceFeeCurrency" select="/.."/>
<xsl:param name="EswRightToIncrease" select="/.."/>
<xsl:param name="EswGrossPrice" select="/.."/>
<xsl:param name="EswApplicableRegion" select="/.."/>
<xsl:param name="EswDividendComponent" select="/.."/>
<xsl:param name="EswEarlyFinalValuationDateElection" select="/.."/>
<xsl:param name="EswEarlyTerminationElectingParty">
<xsl:call-template name="lcl:SWDMLTrade.EswEarlyTerminationElectingParty"/>
</xsl:param>
<xsl:param name="NoticePeriodPtyA" select="/.."/>
<xsl:param name="NoticePeriodPtyB" select="/.."/>
<xsl:param name="EswInsolvencyFiling" select="/.."/>
<xsl:param name="EswLossOfStockBorrow" select="/.."/>
<xsl:param name="EswIncreasedCostOfStockBorrow" select="/.."/>
<xsl:param name="EswBulletCompoundingSpread" select="/.."/>
<xsl:param name="EswSpecifiedExchange" select="/.."/>
<xsl:param name="EswCorporateActionFlag" select="/.."/>
<xsl:param name="sw2021ISDADefs" select="/.."/>
<xsl:param name="EswChinaConnectFlag" select="/.."/>
<xsl:param name="EswChinaConnect" select="/.."/>
<xsl:param name="EswEventId" select="/.."/>
<xsl:param name="EquityExchange" select="/.."/>
<xsl:param name="EbsSubstitutionSelection" select="/.."/>
<xsl:param name="EbsSubstitutionTrigger" select="/.."/>
<xsl:param name="EbsSubstitutionElectingParty" select="/.."/>
<xsl:param name="EbsSubstitutionCriteria" select="/.."/>
<xsl:param name="EbsEligibleIndexGrid" select="/.."/>
<xsl:param name="EbsRestrictedRegion" select="/.."/>
<xsl:param name="EbsRestrictedRegionMinPercent" select="/.."/>
<xsl:param name="EbsRestrictedRegionMaxPercent" select="/.."/>
<xsl:param name="EbsSubstitutionAmount" select="/.."/>
<xsl:param name="EbsSubstitutionAmountMinPercent" select="/.."/>
<xsl:param name="EbsSubstitutionAmountMaxPercent" select="/.."/>
<xsl:param name="EbsEligibleSectorGrid" select="/.."/>
<xsl:param name="EbsADTVDays" select="/.."/>
<xsl:param name="EbsADTVPercentage" select="/.."/>
<xsl:param name="SwapSideLetter" select="/.."/>
<xsl:param name="SubstitutionSideLetter" select="/.."/>
<xsl:param name="EbsGrid" select="/.."/>
<xsl:param name="NCCreditProductType" select="/.."/>
<xsl:param name="NCIndivTradeSummary" select="/.."/>
<xsl:param name="NCNovationBlockID" select="/.."/>
<xsl:param name="NCNCMID" select="/.."/>
<xsl:param name="NCRPOldTRN" select="/.."/>
<xsl:param name="NCCEqualsCEligible" select="/.."/>
<xsl:param name="NCSummaryLinkID" select="/.."/>
<xsl:param name="MandatoryClearingIndicator" select="/.."/>
<xsl:param name="MandatoryClearingHouseId" select="/.."/>
<xsl:param name="MandatoryClearingHouseIdForUnderlyingSwap" select="/.."/>
<xsl:param name="NCORFundId" select="/.."/>
<xsl:param name="NCORFundName" select="/.."/>
<xsl:param name="NCRPFundId" select="/.."/>
<xsl:param name="NCRPFundName" select="/.."/>
<xsl:param name="NCEEFundId" select="/.."/>
<xsl:param name="NCEEFundName" select="/.."/>
<xsl:param name="NCRecoveryFactor" select="/.."/>
<xsl:param name="NCFixedSettlement" select="/.."/>
<xsl:param name="NCSwaptionDocsType" select="/.."/>
<xsl:param name="NCAdditionalMatrixProvision" select="/.."/>
<xsl:param name="NCSwaptionPublicationDate" select="/.."/>
<xsl:param name="NCOptionDirectionA" select="/.."/>
<xsl:param name="TIWDTCCTRI" select="/.."/>
<xsl:param name="TIWActiveStatus" select="/.."/>
<xsl:param name="TIWValueDate" select="/.."/>
<xsl:param name="TIWAsOfDate" select="/.."/>
<xsl:param name="CreditPTETradeDate" select="/.."/>
<xsl:param name="CreditPTEEffectiveDate" select="/.."/>
<xsl:param name="CreditPTEFeePaymentDate" select="/.."/>
<xsl:param name="CreditPTEFeePayer" select="/.."/>
<xsl:param name="CreditPTEFeeAmount" select="/.."/>
<xsl:param name="CreditPTEFeeCurrency" select="/.."/>
<xsl:param name="EquityBackLoadingFlag" select="/.."/>
<xsl:param name="MigrationReferences">
<xsl:call-template name="lcl:SWDMLTrade.MigrationReferences"/>
</xsl:param>
<xsl:param name="Rule15A-6" select="/.."/>
<xsl:param name="HedgingParty">
<xsl:call-template name="lcl:SWDMLTrade.HedgingParty"/>
</xsl:param>
<xsl:param name="DeterminingParty">
<xsl:call-template name="lcl:SWDMLTrade.DeterminingParty"/>
</xsl:param>
<xsl:param name="CalculationAgent">
<xsl:call-template name="lcl:SWDMLTrade.CalculationAgent"/>
</xsl:param>
<xsl:param name="IndependentAmount2">
<xsl:call-template name="lcl:SWDMLTrade.IndependentAmount2"/>
</xsl:param>
<xsl:param name="NotionalFutureValue" select="/.."/>
<xsl:param name="NotionalSchedule">
<xsl:call-template name="lcl:SWDMLTrade.NotionalSchedule"/>
</xsl:param>
<xsl:param name="SendForPublishing" select="/.."/>
<xsl:param name="SubscriberId" select="/.."/>
<xsl:param name="ModifiedEquityDelivery" select="/.."/>
<xsl:param name="SettledEntityMatrixSource" select="/.."/>
<xsl:param name="SettledEntityMatrixDate" select="/.."/>
<xsl:param name="AdditionalTerms" select="/.."/>
<xsl:param name="NovationInitiatedBy" select="/.."/>
<xsl:param name="ReportingData" select="/.."/>
<xsl:param name="DFData" select="/.."/>
<xsl:param name="JFSAData" select="/.."/>
<xsl:param name="ESMAData" select="/.."/>
<xsl:param name="HKMAData" select="/.."/>
<xsl:param name="CAData" select="/.."/>
<xsl:param name="SEData" select="/.."/>
<xsl:param name="MIData" select="/.."/>
<xsl:param name="ASICData" select="/.."/>
<xsl:param name="MASData" select="/.."/>
<xsl:param name="FCAData" select="/.."/>
<xsl:param name="MidMarketPriceType" select="/.."/>
<xsl:param name="MidMarketPriceValue" select="/.."/>
<xsl:param name="MidMarketPriceCurrency" select="/.."/>
<xsl:param name="IntentToBlankMidMarketCurrency" select="/.."/>
<xsl:param name="IntentToBlankMidMarketPrice" select="/.."/>
<xsl:param name="NovationFeeMidMarketPriceType" select="/.."/>
<xsl:param name="NovationFeeMidMarketPriceValue" select="/.."/>
<xsl:param name="NovationFeeMidMarketPriceCurrency" select="/.."/>
<xsl:param name="NovationFeeIntentToBlankMidMarketCurrency" select="/.."/>
<xsl:param name="NovationFeeIntentToBlankMidMarketPrice" select="/.."/>
<xsl:param name="DFEmbeddedOptionType" select="/.."/>
<xsl:param name="GenProdPrimaryAssetClass" select="/.."/>
<xsl:param name="GenProdSecondaryAssetClass" select="/.."/>
<xsl:param name="ProductId" select="/.."/>
<xsl:param name="OptionDirectionA" select="/.."/>
<xsl:param name="OptionPremium" select="/.."/>
<xsl:param name="OptionPremiumCurrency" select="/.."/>
<xsl:param name="OptionStrike" select="/.."/>
<xsl:param name="OptionStrikeType" select="/.."/>
<xsl:param name="OptionStrikeCurrency" select="/.."/>
<xsl:param name="FirstExerciseDate" select="/.."/>
<xsl:param name="FloatingDayCountConvention" select="/.."/>
<xsl:param name="DayCountConvention" select="/.."/>
<xsl:param name="GenProdUnderlyer" select="/.."/>
<xsl:param name="GenProdNotional" select="/.."/>
<xsl:param name="ResetFrequency" select="/.."/>
<xsl:param name="DayCountFraction" select="/.."/>
<xsl:param name="OrderDetails" select="/.."/>
<xsl:param name="ClearingDetails" select="/.."/>
<xsl:param name="NettingBatchId" select="/.."/>
<xsl:param name="PrivateClearingTradeID" select="/.."/>
<xsl:param name="NettingSequenceNumber" select="/.."/>
<xsl:param name="ExecutionTime" select="/.."/>
<xsl:param name="BulkEventID" select="/.."/>
<xsl:param name="NettingString" select="/.."/>
<xsl:param name="NettingLinkedTradeID" select="/.."/>
<xsl:param name="NettingLinkedCCPID" select="/.."/>
<xsl:param name="LinkedTradeDetails" select="/.."/>
<xsl:param name="DurationType" select="/.."/>
<xsl:param name="RateCalcType" select="/.."/>
<xsl:param name="SecurityType" select="/.."/>
<xsl:param name="OpenRepoRate" select="/.."/>
<xsl:param name="OpenRepoSpread" select="/.."/>
<xsl:param name="OpenCashAmount" select="/.."/>
<xsl:param name="OpenDeliveryMethod" select="/.."/>
<xsl:param name="OpenSecurityNominal" select="/.."/>
<xsl:param name="OpenSecurityQuantity" select="/.."/>
<xsl:param name="CloseCashAmount" select="/.."/>
<xsl:param name="CloseDeliveryMethod" select="/.."/>
<xsl:param name="CloseSecurityNominal" select="/.."/>
<xsl:param name="CloseSecurityQuantity" select="/.."/>
<xsl:param name="DayCountBasis" select="/.."/>
<xsl:param name="Haircut" select="/.."/>
<xsl:param name="InitialMargin" select="/.."/>
<xsl:param name="SecurityIDType" select="/.."/>
<xsl:param name="SecurityID" select="/.."/>
<xsl:param name="SecurityDescription" select="/.."/>
<xsl:param name="SecurityCurrency" select="/.."/>
<xsl:param name="ExtensionStyle" select="/.."/>
<xsl:param name="ExtensionPeriod" select="/.."/>
<xsl:param name="ExtensionPeriodUnits" select="/.."/>
<xsl:param name="CallingParty" select="/.."/>
<xsl:param name="CallDate" select="/.."/>
<xsl:param name="CallNoticePeriod" select="/.."/>
<xsl:param name="version" select="/.."/>
<SWDMLTrade>
<xsl:if test="$version">
<xsl:attribute name="version">
<xsl:value-of select="$version"/>
</xsl:attribute>
</xsl:if>
<SWDMLVersion>
<xsl:value-of select="$SWDMLVersion"/>
</SWDMLVersion>
<xsl:if test="$TradeOriginator">
<TradeOriginator>
<xsl:value-of select="$TradeOriginator"/>
</TradeOriginator>
</xsl:if>
<ReplacementTradeId>
<xsl:value-of select="$ReplacementTradeId"/>
</ReplacementTradeId>
<ReplacementTradeIdType>
<xsl:value-of select="$ReplacementTradeIdType"/>
</ReplacementTradeIdType>
<ReplacementReason>
<xsl:value-of select="$ReplacementReason"/>
</ReplacementReason>
<ShortFormInput>
<xsl:value-of select="$ShortFormInput"/>
</ShortFormInput>
<ProductType>
<xsl:value-of select="$ProductType"/>
</ProductType>
<xsl:if test="$ProductSubType">
<ProductSubType>
<xsl:value-of select="$ProductSubType"/>
</ProductSubType>
</xsl:if>
<ParticipantSupplement>
<xsl:value-of select="$ParticipantSupplement"/>
</ParticipantSupplement>
<ConditionPrecedentBondId>
<xsl:value-of select="$ConditionPrecedentBondId"/>
</ConditionPrecedentBondId>
<ConditionPrecedentBondMaturity>
<xsl:value-of select="$ConditionPrecedentBondMaturity"/>
</ConditionPrecedentBondMaturity>
<xsl:if test="$ConditionPrecedentBondIdType">
<ConditionPrecedentBondIdType>
<xsl:value-of select="$ConditionPrecedentBondIdType"/>
</ConditionPrecedentBondIdType>
</xsl:if>
<xsl:if test="$ConditionPrecedentBond">
<ConditionPrecedentBond>
<xsl:value-of select="$ConditionPrecedentBond"/>
</ConditionPrecedentBond>
</xsl:if>
<xsl:if test="$DiscrepancyClause">
<DiscrepancyClause>
<xsl:value-of select="$DiscrepancyClause"/>
</DiscrepancyClause>
</xsl:if>
<AllocatedTrade>
<xsl:value-of select="$AllocatedTrade"/>
</AllocatedTrade>
<xsl:copy-of select="$Allocation"/>
<PrimeBrokerTrade>
<xsl:value-of select="$PrimeBrokerTrade"/>
</PrimeBrokerTrade>
<ReversePrimeBrokerLegalEntities>
<xsl:value-of select="$ReversePrimeBrokerLegalEntities"/>
</ReversePrimeBrokerLegalEntities>
<xsl:copy-of select="$PartyAId"/>
<xsl:if test="$PartyAIdType">
<PartyAIdType>
<xsl:value-of select="$PartyAIdType"/>
</PartyAIdType>
</xsl:if>
<xsl:copy-of select="$PartyBId"/>
<xsl:if test="$PartyBIdType">
<PartyBIdType>
<xsl:value-of select="$PartyBIdType"/>
</PartyBIdType>
</xsl:if>
<xsl:copy-of select="$PartyCId"/>
<xsl:if test="$PartyCIdType">
<PartyCIdType>
<xsl:value-of select="$PartyCIdType"/>
</PartyCIdType>
</xsl:if>
<xsl:copy-of select="$PartyDId"/>
<xsl:if test="$PartyDIdType">
<PartyDIdType>
<xsl:value-of select="$PartyDIdType"/>
</PartyDIdType>
</xsl:if>
<xsl:copy-of select="$PartyGId"/>
<xsl:if test="$PartyGIdType">
<PartyGIdType>
<xsl:value-of select="$PartyGIdType"/>
</PartyGIdType>
</xsl:if>
<xsl:if test="$PartyTripartyAgentIdType">
<PartyTripartyAgentIdType>
<xsl:value-of select="$PartyTripartyAgentIdType"/>
</PartyTripartyAgentIdType>
</xsl:if>
<xsl:if test="$DeliveryByValue">
<DeliveryByValue>
<xsl:value-of select="$DeliveryByValue"/>
</DeliveryByValue>
</xsl:if>
<Interoperable>
<xsl:value-of select="$Interoperable"/>
</Interoperable>
<ExternalInteropabilityId>
<xsl:value-of select="$ExternalInteropabilityId"/>
</ExternalInteropabilityId>
<InteropNettingString>
<xsl:value-of select="$InteropNettingString"/>
</InteropNettingString>
<DirectionA>
<xsl:value-of select="$DirectionA"/>
</DirectionA>
<TradeDate>
<xsl:value-of select="$TradeDate"/>
</TradeDate>
<StartDateTenor>
<xsl:value-of select="$StartDateTenor"/>
</StartDateTenor>
<EndDateTenor>
<xsl:value-of select="$EndDateTenor"/>
</EndDateTenor>
<StartDateDay>
<xsl:value-of select="$StartDateDay"/>
</StartDateDay>
<Tenor>
<xsl:value-of select="$Tenor"/>
</Tenor>
<StartDate>
<xsl:value-of select="$StartDate"/>
</StartDate>
<FirstFixedPeriodStartDate>
<xsl:value-of select="$FirstFixedPeriodStartDate"/>
</FirstFixedPeriodStartDate>
<xsl:if test="$FirstFixedPeriodStartDate_2">
<FirstFixedPeriodStartDate_2>
<xsl:value-of select="$FirstFixedPeriodStartDate_2"/>
</FirstFixedPeriodStartDate_2>
</xsl:if>
<FirstFloatPeriodStartDate>
<xsl:value-of select="$FirstFloatPeriodStartDate"/>
</FirstFloatPeriodStartDate>
<FirstFloatPeriodStartDate_2>
<xsl:value-of select="$FirstFloatPeriodStartDate_2"/>
</FirstFloatPeriodStartDate_2>
<EndDate>
<xsl:value-of select="$EndDate"/>
</EndDate>
<xsl:if test="$FixingDate">
<FixingDate>
<xsl:value-of select="$FixingDate"/>
</FixingDate>
</xsl:if>
<xsl:if test="$TerminationDays">
<TerminationDays>
<xsl:value-of select="$TerminationDays"/>
</TerminationDays>
</xsl:if>
<FixedPaymentFreq>
<xsl:value-of select="$FixedPaymentFreq"/>
</FixedPaymentFreq>
<xsl:if test="$FixedPaymentFreq_2">
<FixedPaymentFreq_2>
<xsl:value-of select="$FixedPaymentFreq_2"/>
</FixedPaymentFreq_2>
</xsl:if>
<FloatPaymentFreq>
<xsl:value-of select="$FloatPaymentFreq"/>
</FloatPaymentFreq>
<FloatPaymentFreq_2>
<xsl:value-of select="$FloatPaymentFreq_2"/>
</FloatPaymentFreq_2>
<FloatRollFreq>
<xsl:value-of select="$FloatRollFreq"/>
</FloatRollFreq>
<FloatRollFreq_2>
<xsl:value-of select="$FloatRollFreq_2"/>
</FloatRollFreq_2>
<RollsType>
<xsl:value-of select="$RollsType"/>
</RollsType>
<RollsMethod>
<xsl:value-of select="$RollsMethod"/>
</RollsMethod>
<RollDay>
<xsl:value-of select="$RollDay"/>
</RollDay>
<MonthEndRolls>
<xsl:value-of select="$MonthEndRolls"/>
</MonthEndRolls>
<FirstPeriodStartDate>
<xsl:value-of select="$FirstPeriodStartDate"/>
</FirstPeriodStartDate>
<FirstPaymentDate>
<xsl:value-of select="$FirstPaymentDate"/>
</FirstPaymentDate>
<LastRegularPaymentDate>
<xsl:value-of select="$LastRegularPaymentDate"/>
</LastRegularPaymentDate>
<FixedRate>
<xsl:value-of select="$FixedRate"/>
</FixedRate>
<FixedRate_2>
<xsl:value-of select="$FixedRate_2"/>
</FixedRate_2>
<initialPoints>
<xsl:value-of select="$initialPoints"/>
</initialPoints>
<quotationStyle>
<xsl:value-of select="$quotationStyle"/>
</quotationStyle>
<RecoveryRate>
<xsl:value-of select="$RecoveryRate"/>
</RecoveryRate>
<FixedSettlement>
<xsl:value-of select="$FixedSettlement"/>
</FixedSettlement>
<Currency>
<xsl:value-of select="$Currency"/>
</Currency>
<Currency_2>
<xsl:value-of select="$Currency_2"/>
</Currency_2>
<Notional>
<xsl:value-of select="$Notional"/>
</Notional>
<xsl:if test="$NotionalFloating">
<NotionalFloating>
<xsl:value-of select="$NotionalFloating"/>
</NotionalFloating>
</xsl:if>
<Notional_2>
<xsl:value-of select="$Notional_2"/>
</Notional_2>
<InitialNotional>
<xsl:value-of select="$InitialNotional"/>
</InitialNotional>
<xsl:if test="$FinalExchangeAmount">
<FinalExchangeAmount>
<xsl:value-of select="$FinalExchangeAmount"/>
</FinalExchangeAmount>
</xsl:if>
<FixedAmount>
<xsl:value-of select="$FixedAmount"/>
</FixedAmount>
<xsl:if test="$FixedAmount_2">
<FixedAmount_2>
<xsl:value-of select="$FixedAmount_2"/>
</FixedAmount_2>
</xsl:if>
<FixedAmountCurrency>
<xsl:value-of select="$FixedAmountCurrency"/>
</FixedAmountCurrency>
<xsl:if test="$FixedAmountCurrency_2">
<FixedAmountCurrency_2>
<xsl:value-of select="$FixedAmountCurrency_2"/>
</FixedAmountCurrency_2>
</xsl:if>
<FixedDayBasis>
<xsl:value-of select="$FixedDayBasis"/>
</FixedDayBasis>
<xsl:if test="$FixedDayBasis_2">
<FixedDayBasis_2>
<xsl:value-of select="$FixedDayBasis_2"/>
</FixedDayBasis_2>
</xsl:if>
<FloatDayBasis>
<xsl:value-of select="$FloatDayBasis"/>
</FloatDayBasis>
<xsl:if test="$FloatDayBasis_2">
<FloatDayBasis_2>
<xsl:value-of select="$FloatDayBasis_2"/>
</FloatDayBasis_2>
</xsl:if>
<FixedConvention>
<xsl:value-of select="$FixedConvention"/>
</FixedConvention>
<xsl:if test="$FixedConvention_2">
<FixedConvention_2>
<xsl:value-of select="$FixedConvention_2"/>
</FixedConvention_2>
</xsl:if>
<FixedCalcPeriodDatesConvention>
<xsl:value-of select="$FixedCalcPeriodDatesConvention"/>
</FixedCalcPeriodDatesConvention>
<xsl:if test="$FixedCalcPeriodDatesConvention_2">
<FixedCalcPeriodDatesConvention_2>
<xsl:value-of select="$FixedCalcPeriodDatesConvention_2"/>
</FixedCalcPeriodDatesConvention_2>
</xsl:if>
<FixedTerminationDateConvention>
<xsl:value-of select="$FixedTerminationDateConvention"/>
</FixedTerminationDateConvention>
<xsl:if test="$FixedTerminationDateConvention_2">
<FixedTerminationDateConvention_2>
<xsl:value-of select="$FixedTerminationDateConvention_2"/>
</FixedTerminationDateConvention_2>
</xsl:if>
<FloatConvention>
<xsl:value-of select="$FloatConvention"/>
</FloatConvention>
<FloatCalcPeriodDatesConvention>
<xsl:value-of select="$FloatCalcPeriodDatesConvention"/>
</FloatCalcPeriodDatesConvention>
<FloatTerminationDateConvention>
<xsl:value-of select="$FloatTerminationDateConvention"/>
</FloatTerminationDateConvention>
<FloatConvention_2>
<xsl:value-of select="$FloatConvention_2"/>
</FloatConvention_2>
<FloatTerminationDateConvention_2>
<xsl:value-of select="$FloatTerminationDateConvention_2"/>
</FloatTerminationDateConvention_2>
<FloatingRateIndex>
<xsl:value-of select="$FloatingRateIndex"/>
</FloatingRateIndex>
<xsl:if test="$FloatingRateIndexTenor">
<FloatingRateIndexTenor>
<xsl:value-of select="$FloatingRateIndexTenor"/>
</FloatingRateIndexTenor>
</xsl:if>
<FloatingRateIndex_2>
<xsl:value-of select="$FloatingRateIndex_2"/>
</FloatingRateIndex_2>
<InflationLag>
<xsl:value-of select="$InflationLag"/>
</InflationLag>
<IndexSource>
<xsl:value-of select="$IndexSource"/>
</IndexSource>
<InterpolationMethod>
<xsl:value-of select="$InterpolationMethod"/>
</InterpolationMethod>
<InitialIndexLevel>
<xsl:value-of select="$InitialIndexLevel"/>
</InitialIndexLevel>
<RelatedBond>
<xsl:value-of select="$RelatedBond"/>
</RelatedBond>
<IndexTenor1>
<xsl:value-of select="$IndexTenor1"/>
</IndexTenor1>
<IndexTenor1_2>
<xsl:value-of select="$IndexTenor1_2"/>
</IndexTenor1_2>
<LinearInterpolation>
<xsl:value-of select="$LinearInterpolation"/>
</LinearInterpolation>
<LinearInterpolation_2>
<xsl:value-of select="$LinearInterpolation_2"/>
</LinearInterpolation_2>
<IndexTenor2>
<xsl:value-of select="$IndexTenor2"/>
</IndexTenor2>
<IndexTenor2_2>
<xsl:value-of select="$IndexTenor2_2"/>
</IndexTenor2_2>
<InitialInterpolationIndex>
<xsl:value-of select="$InitialInterpolationIndex"/>
</InitialInterpolationIndex>
<InitialInterpolationIndex_2>
<xsl:value-of select="$InitialInterpolationIndex_2"/>
</InitialInterpolationIndex_2>
<xsl:if test="$CMSCalcAgent">
<CMSCalcAgent>
<xsl:value-of select="$CMSCalcAgent"/>
</CMSCalcAgent>
</xsl:if>
<xsl:if test="$CompoundingCalculationMethod">
<CompoundingCalculationMethod>
<xsl:value-of select="$CompoundingCalculationMethod"/>
</CompoundingCalculationMethod>
</xsl:if>
<xsl:if test="$CompoundingCalculationMethod_2">
<CompoundingCalculationMethod_2>
<xsl:value-of select="$CompoundingCalculationMethod_2"/>
</CompoundingCalculationMethod_2>
</xsl:if>
<xsl:if test="$ObservationMethod">
<ObservationMethod>
<xsl:value-of select="$ObservationMethod"/>
</ObservationMethod>
</xsl:if>
<xsl:if test="$ObservationMethod_2">
<ObservationMethod_2>
<xsl:value-of select="$ObservationMethod_2"/>
</ObservationMethod_2>
</xsl:if>
<xsl:if test="$OffsetDays">
<OffsetDays>
<xsl:value-of select="$OffsetDays"/>
</OffsetDays>
</xsl:if>
<xsl:if test="$OffsetDays_2">
<OffsetDays_2>
<xsl:value-of select="$OffsetDays_2"/>
</OffsetDays_2>
</xsl:if>
<xsl:if test="$ObservationPeriodDates">
<ObservationPeriodDates>
<xsl:value-of select="$ObservationPeriodDates"/>
</ObservationPeriodDates>
</xsl:if>
<xsl:if test="$ObservationPeriodDates_2">
<ObservationPeriodDates_2>
<xsl:value-of select="$ObservationPeriodDates_2"/>
</ObservationPeriodDates_2>
</xsl:if>
<xsl:if test="$ObservationAdditionalBusinessDays">
<ObservationAdditionalBusinessDays>
<xsl:value-of select="$ObservationAdditionalBusinessDays"/>
</ObservationAdditionalBusinessDays>
</xsl:if>
<xsl:if test="$ObservationAdditionalBusinessDays_2">
<ObservationAdditionalBusinessDays_2>
<xsl:value-of select="$ObservationAdditionalBusinessDays_2"/>
</ObservationAdditionalBusinessDays_2>
</xsl:if>
<xsl:if test="$ObservationHolidayCentre">
<ObservationHolidayCentre>
<xsl:value-of select="$ObservationHolidayCentre"/>
</ObservationHolidayCentre>
</xsl:if>
<xsl:if test="$ObservationHolidayCentre_2">
<ObservationHolidayCentre_2>
<xsl:value-of select="$ObservationHolidayCentre_2"/>
</ObservationHolidayCentre_2>
</xsl:if>
<SpreadOverIndex>
<xsl:value-of select="$SpreadOverIndex"/>
</SpreadOverIndex>
<SpreadOverIndex_2>
<xsl:value-of select="$SpreadOverIndex_2"/>
</SpreadOverIndex_2>
<FirstFixingRate>
<xsl:value-of select="$FirstFixingRate"/>
</FirstFixingRate>
<FirstFixingRate_2>
<xsl:value-of select="$FirstFixingRate_2"/>
</FirstFixingRate_2>
<FixingDaysOffset>
<xsl:value-of select="$FixingDaysOffset"/>
</FixingDaysOffset>
<FixingDaysOffset_2>
<xsl:value-of select="$FixingDaysOffset_2"/>
</FixingDaysOffset_2>
<FixingHolidayCentres>
<xsl:value-of select="$FixingHolidayCentres"/>
</FixingHolidayCentres>
<FixingHolidayCentres_2>
<xsl:value-of select="$FixingHolidayCentres_2"/>
</FixingHolidayCentres_2>
<ResetInArrears>
<xsl:value-of select="$ResetInArrears"/>
</ResetInArrears>
<ResetInArrears_2>
<xsl:value-of select="$ResetInArrears_2"/>
</ResetInArrears_2>
<FirstFixingDifferent>
<xsl:value-of select="$FirstFixingDifferent"/>
</FirstFixingDifferent>
<FirstFixingDifferent_2>
<xsl:value-of select="$FirstFixingDifferent_2"/>
</FirstFixingDifferent_2>
<FirstFixingDaysOffset>
<xsl:value-of select="$FirstFixingDaysOffset"/>
</FirstFixingDaysOffset>
<FirstFixingDaysOffset_2>
<xsl:value-of select="$FirstFixingDaysOffset_2"/>
</FirstFixingDaysOffset_2>
<FirstFixingHolidayCentres>
<xsl:value-of select="$FirstFixingHolidayCentres"/>
</FirstFixingHolidayCentres>
<FirstFixingHolidayCentres_2>
<xsl:value-of select="$FirstFixingHolidayCentres_2"/>
</FirstFixingHolidayCentres_2>
<PaymentHolidayCentres>
<xsl:value-of select="$PaymentHolidayCentres"/>
</PaymentHolidayCentres>
<PaymentHolidayCentres_2>
<xsl:value-of select="$PaymentHolidayCentres_2"/>
</PaymentHolidayCentres_2>
<PaymentLag>
<xsl:value-of select="$PaymentLag"/>
</PaymentLag>
<PaymentLag_2>
<xsl:value-of select="$PaymentLag_2"/>
</PaymentLag_2>
<RollHolidayCentres>
<xsl:value-of select="$RollHolidayCentres"/>
</RollHolidayCentres>
<RollHolidayCentres_2>
<xsl:value-of select="$RollHolidayCentres_2"/>
</RollHolidayCentres_2>
<AdjustFixedStartDate>
<xsl:value-of select="$AdjustFixedStartDate"/>
</AdjustFixedStartDate>
<xsl:if test="$AdjustFixedStartDate_2">
<AdjustFixedStartDate_2>
<xsl:value-of select="$AdjustFixedStartDate_2"/>
</AdjustFixedStartDate_2>
</xsl:if>
<AdjustFloatStartDate>
<xsl:value-of select="$AdjustFloatStartDate"/>
</AdjustFloatStartDate>
<AdjustFloatStartDate_2>
<xsl:value-of select="$AdjustFloatStartDate_2"/>
</AdjustFloatStartDate_2>
<AdjustRollEnd>
<xsl:value-of select="$AdjustRollEnd"/>
</AdjustRollEnd>
<xsl:if test="$AdjustRollEnd_2">
<AdjustRollEnd_2>
<xsl:value-of select="$AdjustRollEnd_2"/>
</AdjustRollEnd_2>
</xsl:if>
<AdjustFloatRollEnd>
<xsl:value-of select="$AdjustFloatRollEnd"/>
</AdjustFloatRollEnd>
<AdjustFloatRollEnd_2>
<xsl:value-of select="$AdjustFloatRollEnd_2"/>
</AdjustFloatRollEnd_2>
<AdjustFixedFinalRollEnd>
<xsl:value-of select="$AdjustFixedFinalRollEnd"/>
</AdjustFixedFinalRollEnd>
<xsl:if test="$AdjustFixedFinalRollEnd_2">
<AdjustFixedFinalRollEnd_2>
<xsl:value-of select="$AdjustFixedFinalRollEnd_2"/>
</AdjustFixedFinalRollEnd_2>
</xsl:if>
<AdjustFinalRollEnd>
<xsl:value-of select="$AdjustFinalRollEnd"/>
</AdjustFinalRollEnd>
<xsl:if test="$AdjustFinalRollEnd_2">
<AdjustFinalRollEnd_2>
<xsl:value-of select="$AdjustFinalRollEnd_2"/>
</AdjustFinalRollEnd_2>
</xsl:if>
<CompoundingMethod>
<xsl:value-of select="$CompoundingMethod"/>
</CompoundingMethod>
<xsl:if test="$CompoundingMethod_2">
<CompoundingMethod_2>
<xsl:value-of select="$CompoundingMethod_2"/>
</CompoundingMethod_2>
</xsl:if>
<AveragingMethod>
<xsl:value-of select="$AveragingMethod"/>
</AveragingMethod>
<xsl:if test="$AveragingMethod_2">
<AveragingMethod_2>
<xsl:value-of select="$AveragingMethod_2"/>
</AveragingMethod_2>
</xsl:if>
<FloatingRateMultiplier>
<xsl:value-of select="$FloatingRateMultiplier"/>
</FloatingRateMultiplier>
<FloatingRateMultiplier_2>
<xsl:value-of select="$FloatingRateMultiplier_2"/>
</FloatingRateMultiplier_2>
<DesignatedMaturity>
<xsl:value-of select="$DesignatedMaturity"/>
</DesignatedMaturity>
<xsl:if test="$DesignatedMaturity_2">
<DesignatedMaturity_2>
<xsl:value-of select="$DesignatedMaturity_2"/>
</DesignatedMaturity_2>
</xsl:if>
<ResetFreq>
<xsl:value-of select="$ResetFreq"/>
</ResetFreq>
<xsl:if test="$ResetFreq_2">
<ResetFreq_2>
<xsl:value-of select="$ResetFreq_2"/>
</ResetFreq_2>
</xsl:if>
<WeeklyRollConvention>
<xsl:value-of select="$WeeklyRollConvention"/>
</WeeklyRollConvention>
<xsl:if test="$WeeklyRollConvention_2">
<WeeklyRollConvention_2>
<xsl:value-of select="$WeeklyRollConvention_2"/>
</WeeklyRollConvention_2>
</xsl:if>
<RateCutOffDays>
<xsl:value-of select="$RateCutOffDays"/>
</RateCutOffDays>
<xsl:if test="$RateCutOffDays_2">
<RateCutOffDays_2>
<xsl:value-of select="$RateCutOffDays_2"/>
</RateCutOffDays_2>
</xsl:if>
<InitialExchange>
<xsl:value-of select="$InitialExchange"/>
</InitialExchange>
<FinalExchange>
<xsl:value-of select="$FinalExchange"/>
</FinalExchange>
<MarkToMarket>
<xsl:value-of select="$MarkToMarket"/>
</MarkToMarket>
<IntermediateExchange>
<xsl:value-of select="$IntermediateExchange"/>
</IntermediateExchange>
<xsl:if test="$FallbackBondApplicable">
<FallbackBondApplicable>
<xsl:value-of select="$FallbackBondApplicable"/>
</FallbackBondApplicable>
</xsl:if>
<xsl:if test="$CalculationMethod">
<CalculationMethod>
<xsl:value-of select="$CalculationMethod"/>
</CalculationMethod>
</xsl:if>
<xsl:if test="$CalculationStyle">
<CalculationStyle>
<xsl:value-of select="$CalculationStyle"/>
</CalculationStyle>
</xsl:if>
<xsl:if test="$FinalPriceExchangeCalc">
<FinalPriceExchangeCalc>
<xsl:value-of select="$FinalPriceExchangeCalc"/>
</FinalPriceExchangeCalc>
</xsl:if>
<xsl:if test="$SpreadCalculationMethod">
<SpreadCalculationMethod>
<xsl:value-of select="$SpreadCalculationMethod"/>
</SpreadCalculationMethod>
</xsl:if>
<xsl:if test="$CouponRate">
<CouponRate>
<xsl:value-of select="$CouponRate"/>
</CouponRate>
</xsl:if>
<xsl:if test="$Maturity">
<Maturity>
<xsl:value-of select="$Maturity"/>
</Maturity>
</xsl:if>
<xsl:if test="$RelatedBondValue">
<RelatedBondValue>
<xsl:value-of select="$RelatedBondValue"/>
</RelatedBondValue>
</xsl:if>
<xsl:if test="$RelatedBondID">
<RelatedBondID>
<xsl:value-of select="$RelatedBondID"/>
</RelatedBondID>
</xsl:if>
<MTMRateSource>
<xsl:value-of select="$MTMRateSource"/>
</MTMRateSource>
<MTMRateSourcePage>
<xsl:value-of select="$MTMRateSourcePage"/>
</MTMRateSourcePage>
<MTMFixingDate>
<xsl:value-of select="$MTMFixingDate"/>
</MTMFixingDate>
<MTMFixingHolidayCentres>
<xsl:value-of select="$MTMFixingHolidayCentres"/>
</MTMFixingHolidayCentres>
<MTMFixingTime>
<xsl:value-of select="$MTMFixingTime"/>
</MTMFixingTime>
<MTMLocation>
<xsl:value-of select="$MTMLocation"/>
</MTMLocation>
<MTMCutoffTime>
<xsl:value-of select="$MTMCutoffTime"/>
</MTMCutoffTime>
<CalculationPeriodDays>
<xsl:value-of select="$CalculationPeriodDays"/>
</CalculationPeriodDays>
<FraDiscounting>
<xsl:value-of select="$FraDiscounting"/>
</FraDiscounting>
<HasBreak>
<xsl:value-of select="$HasBreak"/>
</HasBreak>
<BreakFromSwap>
<xsl:value-of select="$BreakFromSwap"/>
</BreakFromSwap>
<BreakOverride>
<xsl:value-of select="$BreakOverride"/>
</BreakOverride>
<BreakCalculationMethod>
<xsl:value-of select="$BreakCalculationMethod"/>
</BreakCalculationMethod>
<BreakFirstDateTenor>
<xsl:value-of select="$BreakFirstDateTenor"/>
</BreakFirstDateTenor>
<BreakFrequency>
<xsl:value-of select="$BreakFrequency"/>
</BreakFrequency>
<BreakOptionA>
<xsl:value-of select="$BreakOptionA"/>
</BreakOptionA>
<BreakDate>
<xsl:value-of select="$BreakDate"/>
</BreakDate>
<BreakExpirationDate>
<xsl:value-of select="$BreakExpirationDate"/>
</BreakExpirationDate>
<BreakEarliestTime>
<xsl:value-of select="$BreakEarliestTime"/>
</BreakEarliestTime>
<BreakLatestTime>
<xsl:value-of select="$BreakLatestTime"/>
</BreakLatestTime>
<BreakCalcAgentA>
<xsl:value-of select="$BreakCalcAgentA"/>
</BreakCalcAgentA>
<BreakExpiryTime>
<xsl:value-of select="$BreakExpiryTime"/>
</BreakExpiryTime>
<BreakCashSettleCcy>
<xsl:value-of select="$BreakCashSettleCcy"/>
</BreakCashSettleCcy>
<BreakLocation>
<xsl:value-of select="$BreakLocation"/>
</BreakLocation>
<BreakHolidayCentre>
<xsl:value-of select="$BreakHolidayCentre"/>
</BreakHolidayCentre>
<BreakSettlement>
<xsl:value-of select="$BreakSettlement"/>
</BreakSettlement>
<BreakValuationDate>
<xsl:value-of select="$BreakValuationDate"/>
</BreakValuationDate>
<BreakValuationTime>
<xsl:value-of select="$BreakValuationTime"/>
</BreakValuationTime>
<BreakSource>
<xsl:value-of select="$BreakSource"/>
</BreakSource>
<BreakReferenceBanks>
<xsl:value-of select="$BreakReferenceBanks"/>
</BreakReferenceBanks>
<BreakQuotation>
<xsl:value-of select="$BreakQuotation"/>
</BreakQuotation>
<xsl:if test="$BreakMMVApplicableCSA">
<BreakMMVApplicableCSA>
<xsl:value-of select="$BreakMMVApplicableCSA"/>
</BreakMMVApplicableCSA>
</xsl:if>
<xsl:if test="$BreakCollateralCurrency">
<BreakCollateralCurrency>
<xsl:value-of select="$BreakCollateralCurrency"/>
</BreakCollateralCurrency>
</xsl:if>
<xsl:if test="$BreakCollateralInterestRate">
<BreakCollateralInterestRate>
<xsl:value-of select="$BreakCollateralInterestRate"/>
</BreakCollateralInterestRate>
</xsl:if>
<xsl:if test="$BreakAgreedDiscountRate">
<BreakAgreedDiscountRate>
<xsl:value-of select="$BreakAgreedDiscountRate"/>
</BreakAgreedDiscountRate>
</xsl:if>
<xsl:if test="$BreakProtectedPartyA">
<BreakProtectedPartyA>
<xsl:value-of select="$BreakProtectedPartyA"/>
</BreakProtectedPartyA>
</xsl:if>
<xsl:if test="$BreakMutuallyAgreedCH">
<BreakMutuallyAgreedCH>
<xsl:value-of select="$BreakMutuallyAgreedCH"/>
</BreakMutuallyAgreedCH>
</xsl:if>
<BreakPrescribedDocAdj>
<xsl:value-of select="$BreakPrescribedDocAdj"/>
</BreakPrescribedDocAdj>
<ExchangeUnderlying>
<xsl:value-of select="$ExchangeUnderlying"/>
</ExchangeUnderlying>
<SwapSpread>
<xsl:value-of select="$SwapSpread"/>
</SwapSpread>
<BondId1>
<xsl:value-of select="$BondId1"/>
</BondId1>
<BondName1>
<xsl:value-of select="$BondName1"/>
</BondName1>
<BondAmount1>
<xsl:value-of select="$BondAmount1"/>
</BondAmount1>
<BondPriceType1>
<xsl:value-of select="$BondPriceType1"/>
</BondPriceType1>
<BondPrice1>
<xsl:value-of select="$BondPrice1"/>
</BondPrice1>
<BondId2>
<xsl:value-of select="$BondId2"/>
</BondId2>
<BondName2>
<xsl:value-of select="$BondName2"/>
</BondName2>
<BondAmount2>
<xsl:value-of select="$BondAmount2"/>
</BondAmount2>
<BondPriceType2>
<xsl:value-of select="$BondPriceType2"/>
</BondPriceType2>
<BondPrice2>
<xsl:value-of select="$BondPrice2"/>
</BondPrice2>
<StubAt>
<xsl:value-of select="$StubAt"/>
</StubAt>
<xsl:if test="$IsUserStartStub">
<IsUserStartStub>
<xsl:value-of select="$IsUserStartStub"/>
</IsUserStartStub>
</xsl:if>
<FixedStub>
<xsl:value-of select="$FixedStub"/>
</FixedStub>
<xsl:if test="$FixedStub_2">
<FixedStub_2>
<xsl:value-of select="$FixedStub_2"/>
</FixedStub_2>
</xsl:if>
<FloatStub>
<xsl:value-of select="$FloatStub"/>
</FloatStub>
<FloatStub_2>
<xsl:value-of select="$FloatStub_2"/>
</FloatStub_2>
<xsl:if test="$FrontAndBackStubs">
<FrontAndBackStubs>
<xsl:value-of select="$FrontAndBackStubs"/>
</FrontAndBackStubs>
</xsl:if>
<xsl:if test="$FixedBackStub">
<FixedBackStub>
<xsl:value-of select="$FixedBackStub"/>
</FixedBackStub>
</xsl:if>
<xsl:if test="$FloatBackStub">
<FloatBackStub>
<xsl:value-of select="$FloatBackStub"/>
</FloatBackStub>
</xsl:if>
<xsl:if test="$BackStubIndexTenor1">
<BackStubIndexTenor1>
<xsl:value-of select="$BackStubIndexTenor1"/>
</BackStubIndexTenor1>
</xsl:if>
<xsl:if test="$BackStubIndexTenor2">
<BackStubIndexTenor2>
<xsl:value-of select="$BackStubIndexTenor2"/>
</BackStubIndexTenor2>
</xsl:if>
<xsl:if test="$BackStubLinearInterpolation">
<BackStubLinearInterpolation>
<xsl:value-of select="$BackStubLinearInterpolation"/>
</BackStubLinearInterpolation>
</xsl:if>
<xsl:if test="$BackStubInitialInterpIndex">
<BackStubInitialInterpIndex>
<xsl:value-of select="$BackStubInitialInterpIndex"/>
</BackStubInitialInterpIndex>
</xsl:if>
<xsl:if test="$FirstFixedRegPdStartDate">
<FirstFixedRegPdStartDate>
<xsl:value-of select="$FirstFixedRegPdStartDate"/>
</FirstFixedRegPdStartDate>
</xsl:if>
<xsl:if test="$FirstFixedRegPdStartDate_2">
<FirstFixedRegPdStartDate_2>
<xsl:value-of select="$FirstFixedRegPdStartDate_2"/>
</FirstFixedRegPdStartDate_2>
</xsl:if>
<xsl:if test="$FirstFloatRegPdStartDate">
<FirstFloatRegPdStartDate>
<xsl:value-of select="$FirstFloatRegPdStartDate"/>
</FirstFloatRegPdStartDate>
</xsl:if>
<xsl:if test="$FirstFloatRegPdStartDate_2">
<FirstFloatRegPdStartDate_2>
<xsl:value-of select="$FirstFloatRegPdStartDate_2"/>
</FirstFloatRegPdStartDate_2>
</xsl:if>
<xsl:if test="$LastFixedRegPdEndDate">
<LastFixedRegPdEndDate>
<xsl:value-of select="$LastFixedRegPdEndDate"/>
</LastFixedRegPdEndDate>
</xsl:if>
<xsl:if test="$LastFixedRegPdEndDate_2">
<LastFixedRegPdEndDate_2>
<xsl:value-of select="$LastFixedRegPdEndDate_2"/>
</LastFixedRegPdEndDate_2>
</xsl:if>
<xsl:if test="$LastFloatRegPdEndDate">
<LastFloatRegPdEndDate>
<xsl:value-of select="$LastFloatRegPdEndDate"/>
</LastFloatRegPdEndDate>
</xsl:if>
<xsl:if test="$LastFloatRegPdEndDate_2">
<LastFloatRegPdEndDate_2>
<xsl:value-of select="$LastFloatRegPdEndDate_2"/>
</LastFloatRegPdEndDate_2>
</xsl:if>
<MasterAgreement>
<xsl:value-of select="$MasterAgreement"/>
</MasterAgreement>
<ManualConfirm>
<xsl:value-of select="$ManualConfirm"/>
</ManualConfirm>
<xsl:if test="$PlaceOfSettlementA">
<PlaceOfSettlementA>
<xsl:value-of select="$PlaceOfSettlementA"/>
</PlaceOfSettlementA>
</xsl:if>
<xsl:if test="$PlaceOfSettlementB">
<PlaceOfSettlementB>
<xsl:value-of select="$PlaceOfSettlementB"/>
</PlaceOfSettlementB>
</xsl:if>
<xsl:if test="$SettlementAgentA">
<SettlementAgentA>
<xsl:value-of select="$SettlementAgentA"/>
</SettlementAgentA>
</xsl:if>
<xsl:if test="$SettlementAgentB">
<SettlementAgentB>
<xsl:value-of select="$SettlementAgentB"/>
</SettlementAgentB>
</xsl:if>
<xsl:if test="$SettlementAgentSafeKeepA">
<SettlementAgentSafeKeepA>
<xsl:value-of select="$SettlementAgentSafeKeepA"/>
</SettlementAgentSafeKeepA>
</xsl:if>
<xsl:if test="$SettlementAgentSafeKeepB">
<SettlementAgentSafeKeepB>
<xsl:value-of select="$SettlementAgentSafeKeepB"/>
</SettlementAgentSafeKeepB>
</xsl:if>
<xsl:if test="$IntermediaryIDA">
<IntermediaryIDA>
<xsl:value-of select="$IntermediaryIDA"/>
</IntermediaryIDA>
</xsl:if>
<xsl:if test="$IntermediaryIDB">
<IntermediaryIDB>
<xsl:value-of select="$IntermediaryIDB"/>
</IntermediaryIDB>
</xsl:if>
<xsl:if test="$IntermediarySafeKeepA">
<IntermediarySafeKeepA>
<xsl:value-of select="$IntermediarySafeKeepA"/>
</IntermediarySafeKeepA>
</xsl:if>
<xsl:if test="$IntermediarySafeKeepB">
<IntermediarySafeKeepB>
<xsl:value-of select="$IntermediarySafeKeepB"/>
</IntermediarySafeKeepB>
</xsl:if>
<xsl:if test="$CustodianIDA">
<CustodianIDA>
<xsl:value-of select="$CustodianIDA"/>
</CustodianIDA>
</xsl:if>
<xsl:if test="$CustodianIDB">
<CustodianIDB>
<xsl:value-of select="$CustodianIDB"/>
</CustodianIDB>
</xsl:if>
<xsl:if test="$CustodianSafeKeepA">
<CustodianSafeKeepA>
<xsl:value-of select="$CustodianSafeKeepA"/>
</CustodianSafeKeepA>
</xsl:if>
<xsl:if test="$CustodianSafeKeepB">
<CustodianSafeKeepB>
<xsl:value-of select="$CustodianSafeKeepB"/>
</CustodianSafeKeepB>
</xsl:if>
<xsl:if test="$BuyerSellerIDA">
<BuyerSellerIDA>
<xsl:value-of select="$BuyerSellerIDA"/>
</BuyerSellerIDA>
</xsl:if>
<xsl:if test="$BuyerSellerIDB">
<BuyerSellerIDB>
<xsl:value-of select="$BuyerSellerIDB"/>
</BuyerSellerIDB>
</xsl:if>
<xsl:if test="$BuyerSellerSafeKeepA">
<BuyerSellerSafeKeepA>
<xsl:value-of select="$BuyerSellerSafeKeepA"/>
</BuyerSellerSafeKeepA>
</xsl:if>
<xsl:if test="$BuyerSellerSafeKeepB">
<BuyerSellerSafeKeepB>
<xsl:value-of select="$BuyerSellerSafeKeepB"/>
</BuyerSellerSafeKeepB>
</xsl:if>
<xsl:if test="$NovationExecution">
<NovationExecution>
<xsl:value-of select="$NovationExecution"/>
</NovationExecution>
</xsl:if>
<ExclFromClearing>
<xsl:value-of select="$ExclFromClearing"/>
</ExclFromClearing>
<NonStdSettlInst>
<xsl:value-of select="$NonStdSettlInst"/>
</NonStdSettlInst>
<Normalised>
<xsl:value-of select="$Normalised"/>
</Normalised>
<DataMigrationId>
<xsl:value-of select="$DataMigrationId"/>
</DataMigrationId>
<NormalisedStubLength>
<xsl:value-of select="$NormalisedStubLength"/>
</NormalisedStubLength>
<ClientClearing>
<xsl:value-of select="$ClientClearing"/>
</ClientClearing>
<AutoSendForClearing>
<xsl:value-of select="$AutoSendForClearing"/>
</AutoSendForClearing>
<xsl:if test="$CBClearedTimestamp">
<CBClearedTimestamp>
<xsl:value-of select="$CBClearedTimestamp"/>
</CBClearedTimestamp>
</xsl:if>
<xsl:if test="$CBTradeType">
<CBTradeType>
<xsl:value-of select="$CBTradeType"/>
</CBTradeType>
</xsl:if>
<ASICMandatoryClearingIndicator>
<xsl:value-of select="$ASICMandatoryClearingIndicator"/>
</ASICMandatoryClearingIndicator>
<NewNovatedASICMandatoryClearingIndicator>
<xsl:value-of select="$NewNovatedASICMandatoryClearingIndicator"/>
</NewNovatedASICMandatoryClearingIndicator>
<PBEBTradeASICMandatoryClearingIndicator>
<xsl:value-of select="$PBEBTradeASICMandatoryClearingIndicator"/>
</PBEBTradeASICMandatoryClearingIndicator>
<PBClientTradeASICMandatoryClearingIndicator>
<xsl:value-of select="$PBClientTradeASICMandatoryClearingIndicator"/>
</PBClientTradeASICMandatoryClearingIndicator>
<CANMandatoryClearingIndicator>
<xsl:value-of select="$CANMandatoryClearingIndicator"/>
</CANMandatoryClearingIndicator>
<CANClearingExemptIndicator1PartyId>
<xsl:value-of select="$CANClearingExemptIndicator1PartyId"/>
</CANClearingExemptIndicator1PartyId>
<CANClearingExemptIndicator1Value>
<xsl:value-of select="$CANClearingExemptIndicator1Value"/>
</CANClearingExemptIndicator1Value>
<CANClearingExemptIndicator2PartyId>
<xsl:value-of select="$CANClearingExemptIndicator2PartyId"/>
</CANClearingExemptIndicator2PartyId>
<CANClearingExemptIndicator2Value>
<xsl:value-of select="$CANClearingExemptIndicator2Value"/>
</CANClearingExemptIndicator2Value>
<NewNovatedCANMandatoryClearingIndicator>
<xsl:value-of select="$NewNovatedCANMandatoryClearingIndicator"/>
</NewNovatedCANMandatoryClearingIndicator>
<NewNovatedCANClearingExemptIndicator1PartyId>
<xsl:value-of select="$NewNovatedCANClearingExemptIndicator1PartyId"/>
</NewNovatedCANClearingExemptIndicator1PartyId>
<NewNovatedCANClearingExemptIndicator1Value>
<xsl:value-of select="$NewNovatedCANClearingExemptIndicator1Value"/>
</NewNovatedCANClearingExemptIndicator1Value>
<NewNovatedCANClearingExemptIndicator2PartyId>
<xsl:value-of select="$NewNovatedCANClearingExemptIndicator2PartyId"/>
</NewNovatedCANClearingExemptIndicator2PartyId>
<NewNovatedCANClearingExemptIndicator2Value>
<xsl:value-of select="$NewNovatedCANClearingExemptIndicator2Value"/>
</NewNovatedCANClearingExemptIndicator2Value>
<PBEBTradeCANMandatoryClearingIndicator>
<xsl:value-of select="$PBEBTradeCANMandatoryClearingIndicator"/>
</PBEBTradeCANMandatoryClearingIndicator>
<PBEBTradeCANClearingExemptIndicator1PartyId>
<xsl:value-of select="$PBEBTradeCANClearingExemptIndicator1PartyId"/>
</PBEBTradeCANClearingExemptIndicator1PartyId>
<PBEBTradeCANClearingExemptIndicator1Value>
<xsl:value-of select="$PBEBTradeCANClearingExemptIndicator1Value"/>
</PBEBTradeCANClearingExemptIndicator1Value>
<PBEBTradeCANClearingExemptIndicator2PartyId>
<xsl:value-of select="$PBEBTradeCANClearingExemptIndicator2PartyId"/>
</PBEBTradeCANClearingExemptIndicator2PartyId>
<PBEBTradeCANClearingExemptIndicator2Value>
<xsl:value-of select="$PBEBTradeCANClearingExemptIndicator2Value"/>
</PBEBTradeCANClearingExemptIndicator2Value>
<PBClientTradeCANMandatoryClearingIndicator>
<xsl:value-of select="$PBClientTradeCANMandatoryClearingIndicator"/>
</PBClientTradeCANMandatoryClearingIndicator>
<PBClientTradeCANClearingExemptIndicator1PartyId>
<xsl:value-of select="$PBClientTradeCANClearingExemptIndicator1PartyId"/>
</PBClientTradeCANClearingExemptIndicator1PartyId>
<PBClientTradeCANClearingExemptIndicator1Value>
<xsl:value-of select="$PBClientTradeCANClearingExemptIndicator1Value"/>
</PBClientTradeCANClearingExemptIndicator1Value>
<PBClientTradeCANClearingExemptIndicator2PartyId>
<xsl:value-of select="$PBClientTradeCANClearingExemptIndicator2PartyId"/>
</PBClientTradeCANClearingExemptIndicator2PartyId>
<PBClientTradeCANClearingExemptIndicator2Value>
<xsl:value-of select="$PBClientTradeCANClearingExemptIndicator2Value"/>
</PBClientTradeCANClearingExemptIndicator2Value>
<ESMAMandatoryClearingIndicator>
<xsl:value-of select="$ESMAMandatoryClearingIndicator"/>
</ESMAMandatoryClearingIndicator>
<ESMAClearingExemptIndicator1PartyId>
<xsl:value-of select="$ESMAClearingExemptIndicator1PartyId"/>
</ESMAClearingExemptIndicator1PartyId>
<ESMAClearingExemptIndicator1Value>
<xsl:value-of select="$ESMAClearingExemptIndicator1Value"/>
</ESMAClearingExemptIndicator1Value>
<ESMAClearingExemptIndicator2PartyId>
<xsl:value-of select="$ESMAClearingExemptIndicator2PartyId"/>
</ESMAClearingExemptIndicator2PartyId>
<ESMAClearingExemptIndicator2Value>
<xsl:value-of select="$ESMAClearingExemptIndicator2Value"/>
</ESMAClearingExemptIndicator2Value>
<NewNovatedESMAMandatoryClearingIndicator>
<xsl:value-of select="$NewNovatedESMAMandatoryClearingIndicator"/>
</NewNovatedESMAMandatoryClearingIndicator>
<NewNovatedESMAClearingExemptIndicator1PartyId>
<xsl:value-of select="$NewNovatedESMAClearingExemptIndicator1PartyId"/>
</NewNovatedESMAClearingExemptIndicator1PartyId>
<NewNovatedESMAClearingExemptIndicator1Value>
<xsl:value-of select="$NewNovatedESMAClearingExemptIndicator1Value"/>
</NewNovatedESMAClearingExemptIndicator1Value>
<NewNovatedESMAClearingExemptIndicator2PartyId>
<xsl:value-of select="$NewNovatedESMAClearingExemptIndicator2PartyId"/>
</NewNovatedESMAClearingExemptIndicator2PartyId>
<NewNovatedESMAClearingExemptIndicator2Value>
<xsl:value-of select="$NewNovatedESMAClearingExemptIndicator2Value"/>
</NewNovatedESMAClearingExemptIndicator2Value>
<PBEBTradeESMAMandatoryClearingIndicator>
<xsl:value-of select="$PBEBTradeESMAMandatoryClearingIndicator"/>
</PBEBTradeESMAMandatoryClearingIndicator>
<PBEBTradeESMAClearingExemptIndicator1PartyId>
<xsl:value-of select="$PBEBTradeESMAClearingExemptIndicator1PartyId"/>
</PBEBTradeESMAClearingExemptIndicator1PartyId>
<PBEBTradeESMAClearingExemptIndicator1Value>
<xsl:value-of select="$PBEBTradeESMAClearingExemptIndicator1Value"/>
</PBEBTradeESMAClearingExemptIndicator1Value>
<PBEBTradeESMAClearingExemptIndicator2PartyId>
<xsl:value-of select="$PBEBTradeESMAClearingExemptIndicator2PartyId"/>
</PBEBTradeESMAClearingExemptIndicator2PartyId>
<PBEBTradeESMAClearingExemptIndicator2Value>
<xsl:value-of select="$PBEBTradeESMAClearingExemptIndicator2Value"/>
</PBEBTradeESMAClearingExemptIndicator2Value>
<PBClientTradeESMAMandatoryClearingIndicator>
<xsl:value-of select="$PBClientTradeESMAMandatoryClearingIndicator"/>
</PBClientTradeESMAMandatoryClearingIndicator>
<PBClientTradeESMAClearingExemptIndicator1PartyId>
<xsl:value-of select="$PBClientTradeESMAClearingExemptIndicator1PartyId"/>
</PBClientTradeESMAClearingExemptIndicator1PartyId>
<PBClientTradeESMAClearingExemptIndicator1Value>
<xsl:value-of select="$PBClientTradeESMAClearingExemptIndicator1Value"/>
</PBClientTradeESMAClearingExemptIndicator1Value>
<PBClientTradeESMAClearingExemptIndicator2PartyId>
<xsl:value-of select="$PBClientTradeESMAClearingExemptIndicator2PartyId"/>
</PBClientTradeESMAClearingExemptIndicator2PartyId>
<PBClientTradeESMAClearingExemptIndicator2Value>
<xsl:value-of select="$PBClientTradeESMAClearingExemptIndicator2Value"/>
</PBClientTradeESMAClearingExemptIndicator2Value>
<FCAMandatoryClearingIndicator>
<xsl:value-of select="$FCAMandatoryClearingIndicator"/>
</FCAMandatoryClearingIndicator>
<FCAClearingExemptIndicator1PartyId>
<xsl:value-of select="$FCAClearingExemptIndicator1PartyId"/>
</FCAClearingExemptIndicator1PartyId>
<FCAClearingExemptIndicator1Value>
<xsl:value-of select="$FCAClearingExemptIndicator1Value"/>
</FCAClearingExemptIndicator1Value>
<FCAClearingExemptIndicator2PartyId>
<xsl:value-of select="$FCAClearingExemptIndicator2PartyId"/>
</FCAClearingExemptIndicator2PartyId>
<FCAClearingExemptIndicator2Value>
<xsl:value-of select="$FCAClearingExemptIndicator2Value"/>
</FCAClearingExemptIndicator2Value>
<NewNovatedFCAMandatoryClearingIndicator>
<xsl:value-of select="$NewNovatedFCAMandatoryClearingIndicator"/>
</NewNovatedFCAMandatoryClearingIndicator>
<NewNovatedFCAClearingExemptIndicator1PartyId>
<xsl:value-of select="$NewNovatedFCAClearingExemptIndicator1PartyId"/>
</NewNovatedFCAClearingExemptIndicator1PartyId>
<NewNovatedFCAClearingExemptIndicator1Value>
<xsl:value-of select="$NewNovatedFCAClearingExemptIndicator1Value"/>
</NewNovatedFCAClearingExemptIndicator1Value>
<NewNovatedFCAClearingExemptIndicator2PartyId>
<xsl:value-of select="$NewNovatedFCAClearingExemptIndicator2PartyId"/>
</NewNovatedFCAClearingExemptIndicator2PartyId>
<NewNovatedFCAClearingExemptIndicator2Value>
<xsl:value-of select="$NewNovatedFCAClearingExemptIndicator2Value"/>
</NewNovatedFCAClearingExemptIndicator2Value>
<PBEBTradeFCAMandatoryClearingIndicator>
<xsl:value-of select="$PBEBTradeFCAMandatoryClearingIndicator"/>
</PBEBTradeFCAMandatoryClearingIndicator>
<PBEBTradeFCAClearingExemptIndicator1PartyId>
<xsl:value-of select="$PBEBTradeFCAClearingExemptIndicator1PartyId"/>
</PBEBTradeFCAClearingExemptIndicator1PartyId>
<PBEBTradeFCAClearingExemptIndicator1Value>
<xsl:value-of select="$PBEBTradeFCAClearingExemptIndicator1Value"/>
</PBEBTradeFCAClearingExemptIndicator1Value>
<PBEBTradeFCAClearingExemptIndicator2PartyId>
<xsl:value-of select="$PBEBTradeFCAClearingExemptIndicator2PartyId"/>
</PBEBTradeFCAClearingExemptIndicator2PartyId>
<PBEBTradeFCAClearingExemptIndicator2Value>
<xsl:value-of select="$PBEBTradeFCAClearingExemptIndicator2Value"/>
</PBEBTradeFCAClearingExemptIndicator2Value>
<PBClientTradeFCAMandatoryClearingIndicator>
<xsl:value-of select="$PBClientTradeFCAMandatoryClearingIndicator"/>
</PBClientTradeFCAMandatoryClearingIndicator>
<PBClientTradeFCAClearingExemptIndicator1PartyId>
<xsl:value-of select="$PBClientTradeFCAClearingExemptIndicator1PartyId"/>
</PBClientTradeFCAClearingExemptIndicator1PartyId>
<PBClientTradeFCAClearingExemptIndicator1Value>
<xsl:value-of select="$PBClientTradeFCAClearingExemptIndicator1Value"/>
</PBClientTradeFCAClearingExemptIndicator1Value>
<PBClientTradeFCAClearingExemptIndicator2PartyId>
<xsl:value-of select="$PBClientTradeFCAClearingExemptIndicator2PartyId"/>
</PBClientTradeFCAClearingExemptIndicator2PartyId>
<PBClientTradeFCAClearingExemptIndicator2Value>
<xsl:value-of select="$PBClientTradeFCAClearingExemptIndicator2Value"/>
</PBClientTradeFCAClearingExemptIndicator2Value>
<HKMAMandatoryClearingIndicator>
<xsl:value-of select="$HKMAMandatoryClearingIndicator"/>
</HKMAMandatoryClearingIndicator>
<HKMAClearingExemptIndicator1PartyId>
<xsl:value-of select="$HKMAClearingExemptIndicator1PartyId"/>
</HKMAClearingExemptIndicator1PartyId>
<HKMAClearingExemptIndicator1Value>
<xsl:value-of select="$HKMAClearingExemptIndicator1Value"/>
</HKMAClearingExemptIndicator1Value>
<HKMAClearingExemptIndicator2PartyId>
<xsl:value-of select="$HKMAClearingExemptIndicator2PartyId"/>
</HKMAClearingExemptIndicator2PartyId>
<HKMAClearingExemptIndicator2Value>
<xsl:value-of select="$HKMAClearingExemptIndicator2Value"/>
</HKMAClearingExemptIndicator2Value>
<NewNovatedHKMAMandatoryClearingIndicator>
<xsl:value-of select="$NewNovatedHKMAMandatoryClearingIndicator"/>
</NewNovatedHKMAMandatoryClearingIndicator>
<NewNovatedHKMAClearingExemptIndicator1PartyId>
<xsl:value-of select="$NewNovatedHKMAClearingExemptIndicator1PartyId"/>
</NewNovatedHKMAClearingExemptIndicator1PartyId>
<NewNovatedHKMAClearingExemptIndicator1Value>
<xsl:value-of select="$NewNovatedHKMAClearingExemptIndicator1Value"/>
</NewNovatedHKMAClearingExemptIndicator1Value>
<NewNovatedHKMAClearingExemptIndicator2PartyId>
<xsl:value-of select="$NewNovatedHKMAClearingExemptIndicator2PartyId"/>
</NewNovatedHKMAClearingExemptIndicator2PartyId>
<NewNovatedHKMAClearingExemptIndicator2Value>
<xsl:value-of select="$NewNovatedHKMAClearingExemptIndicator2Value"/>
</NewNovatedHKMAClearingExemptIndicator2Value>
<PBEBTradeHKMAMandatoryClearingIndicator>
<xsl:value-of select="$PBEBTradeHKMAMandatoryClearingIndicator"/>
</PBEBTradeHKMAMandatoryClearingIndicator>
<PBEBTradeHKMAClearingExemptIndicator1PartyId>
<xsl:value-of select="$PBEBTradeHKMAClearingExemptIndicator1PartyId"/>
</PBEBTradeHKMAClearingExemptIndicator1PartyId>
<PBEBTradeHKMAClearingExemptIndicator1Value>
<xsl:value-of select="$PBEBTradeHKMAClearingExemptIndicator1Value"/>
</PBEBTradeHKMAClearingExemptIndicator1Value>
<PBEBTradeHKMAClearingExemptIndicator2PartyId>
<xsl:value-of select="$PBEBTradeHKMAClearingExemptIndicator2PartyId"/>
</PBEBTradeHKMAClearingExemptIndicator2PartyId>
<PBEBTradeHKMAClearingExemptIndicator2Value>
<xsl:value-of select="$PBEBTradeHKMAClearingExemptIndicator2Value"/>
</PBEBTradeHKMAClearingExemptIndicator2Value>
<PBClientTradeHKMAMandatoryClearingIndicator>
<xsl:value-of select="$PBClientTradeHKMAMandatoryClearingIndicator"/>
</PBClientTradeHKMAMandatoryClearingIndicator>
<PBClientTradeHKMAClearingExemptIndicator1PartyId>
<xsl:value-of select="$PBClientTradeHKMAClearingExemptIndicator1PartyId"/>
</PBClientTradeHKMAClearingExemptIndicator1PartyId>
<PBClientTradeHKMAClearingExemptIndicator1Value>
<xsl:value-of select="$PBClientTradeHKMAClearingExemptIndicator1Value"/>
</PBClientTradeHKMAClearingExemptIndicator1Value>
<PBClientTradeHKMAClearingExemptIndicator2PartyId>
<xsl:value-of select="$PBClientTradeHKMAClearingExemptIndicator2PartyId"/>
</PBClientTradeHKMAClearingExemptIndicator2PartyId>
<PBClientTradeHKMAClearingExemptIndicator2Value>
<xsl:value-of select="$PBClientTradeHKMAClearingExemptIndicator2Value"/>
</PBClientTradeHKMAClearingExemptIndicator2Value>
<JFSAMandatoryClearingIndicator>
<xsl:value-of select="$JFSAMandatoryClearingIndicator"/>
</JFSAMandatoryClearingIndicator>
<CFTCMandatoryClearingIndicator>
<xsl:value-of select="$CFTCMandatoryClearingIndicator"/>
</CFTCMandatoryClearingIndicator>
<CFTCClearingExemptIndicator1PartyId>
<xsl:value-of select="$CFTCClearingExemptIndicator1PartyId"/>
</CFTCClearingExemptIndicator1PartyId>
<CFTCClearingExemptIndicator1Value>
<xsl:value-of select="$CFTCClearingExemptIndicator1Value"/>
</CFTCClearingExemptIndicator1Value>
<CFTCClearingExemptIndicator2PartyId>
<xsl:value-of select="$CFTCClearingExemptIndicator2PartyId"/>
</CFTCClearingExemptIndicator2PartyId>
<CFTCClearingExemptIndicator2Value>
<xsl:value-of select="$CFTCClearingExemptIndicator2Value"/>
</CFTCClearingExemptIndicator2Value>
<xsl:if test="$CFTCInterAffiliateExemption">
<CFTCInterAffiliateExemption>
<xsl:value-of select="$CFTCInterAffiliateExemption"/>
</CFTCInterAffiliateExemption>
</xsl:if>
<NewNovatedCFTCMandatoryClearingIndicator>
<xsl:value-of select="$NewNovatedCFTCMandatoryClearingIndicator"/>
</NewNovatedCFTCMandatoryClearingIndicator>
<NewNovatedCFTCClearingExemptIndicator1PartyId>
<xsl:value-of select="$NewNovatedCFTCClearingExemptIndicator1PartyId"/>
</NewNovatedCFTCClearingExemptIndicator1PartyId>
<NewNovatedCFTCClearingExemptIndicator1Value>
<xsl:value-of select="$NewNovatedCFTCClearingExemptIndicator1Value"/>
</NewNovatedCFTCClearingExemptIndicator1Value>
<NewNovatedCFTCClearingExemptIndicator2PartyId>
<xsl:value-of select="$NewNovatedCFTCClearingExemptIndicator2PartyId"/>
</NewNovatedCFTCClearingExemptIndicator2PartyId>
<NewNovatedCFTCClearingExemptIndicator2Value>
<xsl:value-of select="$NewNovatedCFTCClearingExemptIndicator2Value"/>
</NewNovatedCFTCClearingExemptIndicator2Value>
<xsl:if test="$NewNovatedCFTCInterAffiliateExemption">
<NewNovatedCFTCInterAffiliateExemption>
<xsl:value-of select="$NewNovatedCFTCInterAffiliateExemption"/>
</NewNovatedCFTCInterAffiliateExemption>
</xsl:if>
<PBEBTradeCFTCMandatoryClearingIndicator>
<xsl:value-of select="$PBEBTradeCFTCMandatoryClearingIndicator"/>
</PBEBTradeCFTCMandatoryClearingIndicator>
<xsl:if test="$PBEBTradeJFSAMandatoryClearingIndicator">
<PBEBTradeJFSAMandatoryClearingIndicator>
<xsl:value-of select="$PBEBTradeJFSAMandatoryClearingIndicator"/>
</PBEBTradeJFSAMandatoryClearingIndicator>
</xsl:if>
<PBEBTradeCFTCClearingExemptIndicator1PartyId>
<xsl:value-of select="$PBEBTradeCFTCClearingExemptIndicator1PartyId"/>
</PBEBTradeCFTCClearingExemptIndicator1PartyId>
<PBEBTradeCFTCClearingExemptIndicator1Value>
<xsl:value-of select="$PBEBTradeCFTCClearingExemptIndicator1Value"/>
</PBEBTradeCFTCClearingExemptIndicator1Value>
<PBEBTradeCFTCClearingExemptIndicator2PartyId>
<xsl:value-of select="$PBEBTradeCFTCClearingExemptIndicator2PartyId"/>
</PBEBTradeCFTCClearingExemptIndicator2PartyId>
<PBEBTradeCFTCClearingExemptIndicator2Value>
<xsl:value-of select="$PBEBTradeCFTCClearingExemptIndicator2Value"/>
</PBEBTradeCFTCClearingExemptIndicator2Value>
<xsl:if test="$PBEBTradeCFTCInterAffiliateExemption">
<PBEBTradeCFTCInterAffiliateExemption>
<xsl:value-of select="$PBEBTradeCFTCInterAffiliateExemption"/>
</PBEBTradeCFTCInterAffiliateExemption>
</xsl:if>
<PBClientTradeCFTCMandatoryClearingIndicator>
<xsl:value-of select="$PBClientTradeCFTCMandatoryClearingIndicator"/>
</PBClientTradeCFTCMandatoryClearingIndicator>
<xsl:if test="$PBClientTradeJFSAMandatoryClearingIndicator">
<PBClientTradeJFSAMandatoryClearingIndicator>
<xsl:value-of select="$PBClientTradeJFSAMandatoryClearingIndicator"/>
</PBClientTradeJFSAMandatoryClearingIndicator>
</xsl:if>
<PBClientTradeCFTCClearingExemptIndicator1PartyId>
<xsl:value-of select="$PBClientTradeCFTCClearingExemptIndicator1PartyId"/>
</PBClientTradeCFTCClearingExemptIndicator1PartyId>
<PBClientTradeCFTCClearingExemptIndicator1Value>
<xsl:value-of select="$PBClientTradeCFTCClearingExemptIndicator1Value"/>
</PBClientTradeCFTCClearingExemptIndicator1Value>
<PBClientTradeCFTCClearingExemptIndicator2PartyId>
<xsl:value-of select="$PBClientTradeCFTCClearingExemptIndicator2PartyId"/>
</PBClientTradeCFTCClearingExemptIndicator2PartyId>
<PBClientTradeCFTCClearingExemptIndicator2Value>
<xsl:value-of select="$PBClientTradeCFTCClearingExemptIndicator2Value"/>
</PBClientTradeCFTCClearingExemptIndicator2Value>
<xsl:if test="$PBClientTradeCFTCInterAffiliateExemption">
<PBClientTradeCFTCInterAffiliateExemption>
<xsl:value-of select="$PBClientTradeCFTCInterAffiliateExemption"/>
</PBClientTradeCFTCInterAffiliateExemption>
</xsl:if>
<MASMandatoryClearingIndicator>
<xsl:value-of select="$MASMandatoryClearingIndicator"/>
</MASMandatoryClearingIndicator>
<NewNovatedMASMandatoryClearingIndicator>
<xsl:value-of select="$NewNovatedMASMandatoryClearingIndicator"/>
</NewNovatedMASMandatoryClearingIndicator>
<PBEBTradeMASMandatoryClearingIndicator>
<xsl:value-of select="$PBEBTradeMASMandatoryClearingIndicator"/>
</PBEBTradeMASMandatoryClearingIndicator>
<PBClientTradeMASMandatoryClearingIndicator>
<xsl:value-of select="$PBClientTradeMASMandatoryClearingIndicator"/>
</PBClientTradeMASMandatoryClearingIndicator>
<ClearingHouseId>
<xsl:value-of select="$ClearingHouseId"/>
</ClearingHouseId>
<ClearingBrokerId>
<xsl:value-of select="$ClearingBrokerId"/>
</ClearingBrokerId>
<xsl:if test="$OriginatingEvent">
<OriginatingEvent>
<xsl:value-of select="$OriginatingEvent"/>
</OriginatingEvent>
</xsl:if>
<xsl:if test="$OriginatingTradeId">
<OriginatingTradeId>
<xsl:value-of select="$OriginatingTradeId"/>
</OriginatingTradeId>
</xsl:if>
<xsl:copy-of select="$SendToCLS"/>
<xsl:if test="$ESMAFrontloading">
<ESMAFrontloading>
<xsl:value-of select="$ESMAFrontloading"/>
</ESMAFrontloading>
</xsl:if>
<xsl:if test="$ESMAClearingExemption">
<ESMAClearingExemption>
<xsl:value-of select="$ESMAClearingExemption"/>
</ESMAClearingExemption>
</xsl:if>
<xsl:if test="$BackLoadingFlag">
<BackLoadingFlag>
<xsl:value-of select="$BackLoadingFlag"/>
</BackLoadingFlag>
</xsl:if>
<xsl:if test="$BulkAction">
<BulkAction>
<xsl:value-of select="$BulkAction"/>
</BulkAction>
</xsl:if>
<Novation>
<xsl:value-of select="$Novation"/>
</Novation>
<PartialNovation>
<xsl:value-of select="$PartialNovation"/>
</PartialNovation>
<FourWayNovation>
<xsl:value-of select="$FourWayNovation"/>
</FourWayNovation>
<NovationTradeDate>
<xsl:value-of select="$NovationTradeDate"/>
</NovationTradeDate>
<NovationDate>
<xsl:value-of select="$NovationDate"/>
</NovationDate>
<NovatedAmount>
<xsl:value-of select="$NovatedAmount"/>
</NovatedAmount>
<NovatedAmount_2>
<xsl:value-of select="$NovatedAmount_2"/>
</NovatedAmount_2>
<NovatedCurrency>
<xsl:value-of select="$NovatedCurrency"/>
</NovatedCurrency>
<NovatedCurrency_2>
<xsl:value-of select="$NovatedCurrency_2"/>
</NovatedCurrency_2>
<NovatedFV>
<xsl:value-of select="$NovatedFV"/>
</NovatedFV>
<FullFirstCalculationPeriod>
<xsl:value-of select="$FullFirstCalculationPeriod"/>
</FullFirstCalculationPeriod>
<NonReliance>
<xsl:value-of select="$NonReliance"/>
</NonReliance>
<PreserveEarlyTerminationProvision>
<xsl:value-of select="$PreserveEarlyTerminationProvision"/>
</PreserveEarlyTerminationProvision>
<CopyPremiumToNewTrade>
<xsl:value-of select="$CopyPremiumToNewTrade"/>
</CopyPremiumToNewTrade>
<xsl:if test="$CopyInitialRateToNewTradeIfRelevant">
<CopyInitialRateToNewTradeIfRelevant>
<xsl:value-of select="$CopyInitialRateToNewTradeIfRelevant"/>
</CopyInitialRateToNewTradeIfRelevant>
</xsl:if>
<IntendedClearingHouse>
<xsl:value-of select="$IntendedClearingHouse"/>
</IntendedClearingHouse>
<xsl:if test="$NovationBulkAction">
<NovationBulkAction>
<xsl:value-of select="$NovationBulkAction"/>
</NovationBulkAction>
</xsl:if>
<xsl:if test="$NovationFallbacksSupplement">
<NovationFallbacksSupplement>
<xsl:value-of select="$NovationFallbacksSupplement"/>
</NovationFallbacksSupplement>
</xsl:if>
<xsl:if test="$NovationFallbacksAmendment">
<NovationFallbacksAmendment>
<xsl:value-of select="$NovationFallbacksAmendment"/>
</NovationFallbacksAmendment>
</xsl:if>
<xsl:if test="$ClientClearingFlag">
<ClientClearingFlag>
<xsl:value-of select="$ClientClearingFlag"/>
</ClientClearingFlag>
</xsl:if>
<xsl:if test="$ClearingBroker">
<ClearingBroker>
<xsl:value-of select="$ClearingBroker"/>
</ClearingBroker>
</xsl:if>
<xsl:copy-of select="$AdditionalPayment"/>
<OptionStyle>
<xsl:value-of select="$OptionStyle"/>
</OptionStyle>
<OptionType>
<xsl:value-of select="$OptionType"/>
</OptionType>
<OptionExpirationDate>
<xsl:value-of select="$OptionExpirationDate"/>
</OptionExpirationDate>
<OptionExpirationDateConvention>
<xsl:value-of select="$OptionExpirationDateConvention"/>
</OptionExpirationDateConvention>
<OptionHolidayCenters>
<xsl:value-of select="$OptionHolidayCenters"/>
</OptionHolidayCenters>
<OptionEarliestTime>
<xsl:value-of select="$OptionEarliestTime"/>
</OptionEarliestTime>
<OptionEarliestTimeHolidayCentre>
<xsl:value-of select="$OptionEarliestTimeHolidayCentre"/>
</OptionEarliestTimeHolidayCentre>
<OptionExpiryTime>
<xsl:value-of select="$OptionExpiryTime"/>
</OptionExpiryTime>
<xsl:if test="$ValuationTime">
<ValuationTime>
<xsl:value-of select="$ValuationTime"/>
</ValuationTime>
</xsl:if>
<OptionExpiryTimeHolidayCentre>
<xsl:value-of select="$OptionExpiryTimeHolidayCentre"/>
</OptionExpiryTimeHolidayCentre>
<OptionSpecificExpiryTime>
<xsl:value-of select="$OptionSpecificExpiryTime"/>
</OptionSpecificExpiryTime>
<OptionLocation>
<xsl:value-of select="$OptionLocation"/>
</OptionLocation>
<OptionCalcAgent>
<xsl:value-of select="$OptionCalcAgent"/>
</OptionCalcAgent>
<OptionAutomaticExercise>
<xsl:value-of select="$OptionAutomaticExercise"/>
</OptionAutomaticExercise>
<OptionThreshold>
<xsl:value-of select="$OptionThreshold"/>
</OptionThreshold>
<ManualExercise>
<xsl:value-of select="$ManualExercise"/>
</ManualExercise>
<OptionWrittenExerciseConf>
<xsl:value-of select="$OptionWrittenExerciseConf"/>
</OptionWrittenExerciseConf>
<PremiumAmount>
<xsl:value-of select="$PremiumAmount"/>
</PremiumAmount>
<PremiumCurrency>
<xsl:value-of select="$PremiumCurrency"/>
</PremiumCurrency>
<PremiumPaymentDate>
<xsl:value-of select="$PremiumPaymentDate"/>
</PremiumPaymentDate>
<PremiumHolidayCentres>
<xsl:value-of select="$PremiumHolidayCentres"/>
</PremiumHolidayCentres>
<Strike>
<xsl:value-of select="$Strike"/>
</Strike>
<StrikeCurrency>
<xsl:value-of select="$StrikeCurrency"/>
</StrikeCurrency>
<StrikePercentage>
<xsl:value-of select="$StrikePercentage"/>
</StrikePercentage>
<StrikeDate>
<xsl:value-of select="$StrikeDate"/>
</StrikeDate>
<OptionSettlement>
<xsl:value-of select="$OptionSettlement"/>
</OptionSettlement>
<OptionCashSettlementValuationTime>
<xsl:value-of select="$OptionCashSettlementValuationTime"/>
</OptionCashSettlementValuationTime>
<OptionSpecificValuationTime>
<xsl:value-of select="$OptionSpecificValuationTime"/>
</OptionSpecificValuationTime>
<OptionCashSettlementValuationDate>
<xsl:value-of select="$OptionCashSettlementValuationDate"/>
</OptionCashSettlementValuationDate>
<OptionCashSettlementPaymentDate>
<xsl:value-of select="$OptionCashSettlementPaymentDate"/>
</OptionCashSettlementPaymentDate>
<OptionCashSettlementMethod>
<xsl:value-of select="$OptionCashSettlementMethod"/>
</OptionCashSettlementMethod>
<OptionCashSettlementQuotationRate>
<xsl:value-of select="$OptionCashSettlementQuotationRate"/>
</OptionCashSettlementQuotationRate>
<OptionCashSettlementRateSource>
<xsl:value-of select="$OptionCashSettlementRateSource"/>
</OptionCashSettlementRateSource>
<OptionCashSettlementReferenceBanks>
<xsl:value-of select="$OptionCashSettlementReferenceBanks"/>
</OptionCashSettlementReferenceBanks>
<xsl:if test="$OptionMMVApplicableCSA">
<OptionMMVApplicableCSA>
<xsl:value-of select="$OptionMMVApplicableCSA"/>
</OptionMMVApplicableCSA>
</xsl:if>
<xsl:if test="$BarrierType">
<BarrierType>
<xsl:value-of select="$BarrierType"/>
</BarrierType>
</xsl:if>
<xsl:if test="$KnockInTriggerType">
<KnockInTriggerType>
<xsl:value-of select="$KnockInTriggerType"/>
</KnockInTriggerType>
</xsl:if>
<xsl:if test="$KnockInPrice">
<KnockInPrice>
<xsl:value-of select="$KnockInPrice"/>
</KnockInPrice>
</xsl:if>
<xsl:if test="$KnockInPeriodStartDate">
<KnockInPeriodStartDate>
<xsl:value-of select="$KnockInPeriodStartDate"/>
</KnockInPeriodStartDate>
</xsl:if>
<xsl:if test="$KnockInPeriodEndDate">
<KnockInPeriodEndDate>
<xsl:value-of select="$KnockInPeriodEndDate"/>
</KnockInPeriodEndDate>
</xsl:if>
<xsl:if test="$KnockInValuationTime">
<KnockInValuationTime>
<xsl:value-of select="$KnockInValuationTime"/>
</KnockInValuationTime>
</xsl:if>
<xsl:if test="$KnockOutTriggerType">
<KnockOutTriggerType>
<xsl:value-of select="$KnockOutTriggerType"/>
</KnockOutTriggerType>
</xsl:if>
<xsl:if test="$KnockOutPrice">
<KnockOutPrice>
<xsl:value-of select="$KnockOutPrice"/>
</KnockOutPrice>
</xsl:if>
<xsl:if test="$KnockOutPeriodStartDate">
<KnockOutPeriodStartDate>
<xsl:value-of select="$KnockOutPeriodStartDate"/>
</KnockOutPeriodStartDate>
</xsl:if>
<xsl:if test="$KnockOutPeriodEndDate">
<KnockOutPeriodEndDate>
<xsl:value-of select="$KnockOutPeriodEndDate"/>
</KnockOutPeriodEndDate>
</xsl:if>
<xsl:if test="$KnockOutValuationTime">
<KnockOutValuationTime>
<xsl:value-of select="$KnockOutValuationTime"/>
</KnockOutValuationTime>
</xsl:if>
<xsl:if test="$Rebate">
<Rebate>
<xsl:value-of select="$Rebate"/>
</Rebate>
</xsl:if>
<xsl:if test="$RebateAmount">
<RebateAmount>
<xsl:value-of select="$RebateAmount"/>
</RebateAmount>
</xsl:if>
<xsl:if test="$RebateAmountPaymentDate">
<RebateAmountPaymentDate>
<xsl:value-of select="$RebateAmountPaymentDate"/>
</RebateAmountPaymentDate>
</xsl:if>
<xsl:if test="$RebateAmountPaymentLag">
<RebateAmountPaymentLag>
<xsl:value-of select="$RebateAmountPaymentLag"/>
</RebateAmountPaymentLag>
</xsl:if>
<xsl:if test="$KnockObservationDate">
<KnockObservationDate>
<xsl:value-of select="$KnockObservationDate"/>
</KnockObservationDate>
</xsl:if>
<ClearedPhysicalSettlement>
<xsl:value-of select="$ClearedPhysicalSettlement"/>
</ClearedPhysicalSettlement>
<xsl:if test="$UnderlyingSwapClearingHouse">
<UnderlyingSwapClearingHouse>
<xsl:value-of select="$UnderlyingSwapClearingHouse"/>
</UnderlyingSwapClearingHouse>
</xsl:if>
<xsl:if test="$UnderlyingSwapClientClearing">
<UnderlyingSwapClientClearing>
<xsl:value-of select="$UnderlyingSwapClientClearing"/>
</UnderlyingSwapClientClearing>
</xsl:if>
<xsl:if test="$UnderlyingSwapAutoSendForClearing">
<UnderlyingSwapAutoSendForClearing>
<xsl:value-of select="$UnderlyingSwapAutoSendForClearing"/>
</UnderlyingSwapAutoSendForClearing>
</xsl:if>
<xsl:if test="$AutoCreateExercised">
<AutoCreateExercised>
<xsl:value-of select="$AutoCreateExercised"/>
</AutoCreateExercised>
</xsl:if>
<xsl:if test="$ConvertUnderlyingSwapToRFR">
<ConvertUnderlyingSwapToRFR>
<xsl:value-of select="$ConvertUnderlyingSwapToRFR"/>
</ConvertUnderlyingSwapToRFR>
</xsl:if>
<xsl:if test="$PricedToClearCCP">
<PricedToClearCCP>
<xsl:value-of select="$PricedToClearCCP"/>
</PricedToClearCCP>
</xsl:if>
<xsl:if test="$AgreedDiscountRate">
<AgreedDiscountRate>
<xsl:value-of select="$AgreedDiscountRate"/>
</AgreedDiscountRate>
</xsl:if>
<xsl:if test="$EconomicAmendmentType">
<EconomicAmendmentType>
<xsl:value-of select="$EconomicAmendmentType"/>
</EconomicAmendmentType>
</xsl:if>
<xsl:if test="$EconomicAmendmentReason">
<EconomicAmendmentReason>
<xsl:value-of select="$EconomicAmendmentReason"/>
</EconomicAmendmentReason>
</xsl:if>
<xsl:if test="$CancelableCalcAgent">
<CancelableCalcAgent>
<xsl:value-of select="$CancelableCalcAgent"/>
</CancelableCalcAgent>
</xsl:if>
<xsl:if test="$SwapRateFallbacksAmendment">
<SwapRateFallbacksAmendment>
<xsl:value-of select="$SwapRateFallbacksAmendment"/>
</SwapRateFallbacksAmendment>
</xsl:if>
<ClearingTakeupClientId>
<xsl:value-of select="$ClearingTakeupClientId"/>
</ClearingTakeupClientId>
<ClearingTakeupClientName>
<xsl:value-of select="$ClearingTakeupClientName"/>
</ClearingTakeupClientName>
<ClearingTakeupClientTradeId>
<xsl:value-of select="$ClearingTakeupClientTradeId"/>
</ClearingTakeupClientTradeId>
<ClearingTakeupExecSrcId>
<xsl:value-of select="$ClearingTakeupExecSrcId"/>
</ClearingTakeupExecSrcId>
<ClearingTakeupExecSrcName>
<xsl:value-of select="$ClearingTakeupExecSrcName"/>
</ClearingTakeupExecSrcName>
<ClearingTakeupExecSrcTradeId>
<xsl:value-of select="$ClearingTakeupExecSrcTradeId"/>
</ClearingTakeupExecSrcTradeId>
<ClearingTakeupCorrelationId>
<xsl:value-of select="$ClearingTakeupCorrelationId"/>
</ClearingTakeupCorrelationId>
<ClearingTakeupClearingHouseTradeId>
<xsl:value-of select="$ClearingTakeupClearingHouseTradeId"/>
</ClearingTakeupClearingHouseTradeId>
<ClearingTakeupOriginatingEvent>
<xsl:value-of select="$ClearingTakeupOriginatingEvent"/>
</ClearingTakeupOriginatingEvent>
<ClearingTakeupBlockTradeId>
<xsl:value-of select="$ClearingTakeupBlockTradeId"/>
</ClearingTakeupBlockTradeId>
<ClearingTakeupSentBy>
<xsl:value-of select="$ClearingTakeupSentBy"/>
</ClearingTakeupSentBy>
<ClearingTakeupCreditTokenIssuer>
<xsl:value-of select="$ClearingTakeupCreditTokenIssuer"/>
</ClearingTakeupCreditTokenIssuer>
<ClearingTakeupCreditToken>
<xsl:value-of select="$ClearingTakeupCreditToken"/>
</ClearingTakeupCreditToken>
<ClearingTakeupClearingStatus>
<xsl:value-of select="$ClearingTakeupClearingStatus"/>
</ClearingTakeupClearingStatus>
<ClearingTakeupVenueLEI>
<xsl:value-of select="$ClearingTakeupVenueLEI"/>
</ClearingTakeupVenueLEI>
<ClearingTakeupVenueLEIScheme>
<xsl:value-of select="$ClearingTakeupVenueLEIScheme"/>
</ClearingTakeupVenueLEIScheme>
<xsl:copy-of select="$AssociatedTrade"/>
<DocsType>
<xsl:value-of select="$DocsType"/>
</DocsType>
<DocsSubType>
<xsl:value-of select="$DocsSubType"/>
</DocsSubType>
<ContractualDefinitions>
<xsl:value-of select="$ContractualDefinitions"/>
</ContractualDefinitions>
<ContractualSupplement>
<xsl:value-of select="$ContractualSupplement"/>
</ContractualSupplement>
<CanadianSupplement>
<xsl:value-of select="$CanadianSupplement"/>
</CanadianSupplement>
<ExchangeTradedContractNearest>
<xsl:value-of select="$ExchangeTradedContractNearest"/>
</ExchangeTradedContractNearest>
<RestructuringCreditEvent>
<xsl:value-of select="$RestructuringCreditEvent"/>
</RestructuringCreditEvent>
<CalculationAgentCity>
<xsl:value-of select="$CalculationAgentCity"/>
</CalculationAgentCity>
<RefEntName>
<xsl:value-of select="$RefEntName"/>
</RefEntName>
<RefEntStdId>
<xsl:value-of select="$RefEntStdId"/>
</RefEntStdId>
<REROPairStdId>
<xsl:value-of select="$REROPairStdId"/>
</REROPairStdId>
<RefOblRERole>
<xsl:value-of select="$RefOblRERole"/>
</RefOblRERole>
<RefOblSecurityIdType>
<xsl:value-of select="$RefOblSecurityIdType"/>
</RefOblSecurityIdType>
<RefOblSecurityId>
<xsl:value-of select="$RefOblSecurityId"/>
</RefOblSecurityId>
<BloombergID>
<xsl:value-of select="$BloombergID"/>
</BloombergID>
<RefOblMaturity>
<xsl:value-of select="$RefOblMaturity"/>
</RefOblMaturity>
<RefOblCoupon>
<xsl:value-of select="$RefOblCoupon"/>
</RefOblCoupon>
<RefOblPrimaryObligor>
<xsl:value-of select="$RefOblPrimaryObligor"/>
</RefOblPrimaryObligor>
<BorrowerNames>
<xsl:value-of select="$BorrowerNames"/>
</BorrowerNames>
<FacilityType>
<xsl:value-of select="$FacilityType"/>
</FacilityType>
<CreditAgreementDate>
<xsl:value-of select="$CreditAgreementDate"/>
</CreditAgreementDate>
<IsSecuredList>
<xsl:value-of select="$IsSecuredList"/>
</IsSecuredList>
<xsl:if test="$CashSettlementOnly">
<CashSettlementOnly>
<xsl:value-of select="$CashSettlementOnly"/>
</CashSettlementOnly>
</xsl:if>
<xsl:if test="$Continuity">
<Continuity>
<xsl:value-of select="$Continuity"/>
</Continuity>
</xsl:if>
<xsl:if test="$DeliveryOfCommitments">
<DeliveryOfCommitments>
<xsl:value-of select="$DeliveryOfCommitments"/>
</DeliveryOfCommitments>
</xsl:if>
<ObligationCategory>
<xsl:value-of select="$ObligationCategory"/>
</ObligationCategory>
<DesignatedPriority>
<xsl:value-of select="$DesignatedPriority"/>
</DesignatedPriority>
<xsl:if test="$LegalFinalMaturity">
<LegalFinalMaturity>
<xsl:value-of select="$LegalFinalMaturity"/>
</LegalFinalMaturity>
</xsl:if>
<xsl:if test="$OriginalPrincipalAmount">
<OriginalPrincipalAmount>
<xsl:value-of select="$OriginalPrincipalAmount"/>
</OriginalPrincipalAmount>
</xsl:if>
<xsl:copy-of select="$CreditDateAdjustments"/>
<OptionalEarlyTermination>
<xsl:value-of select="$OptionalEarlyTermination"/>
</OptionalEarlyTermination>
<ReferencePrice>
<xsl:value-of select="$ReferencePrice"/>
</ReferencePrice>
<ReferencePolicy>
<xsl:value-of select="$ReferencePolicy"/>
</ReferencePolicy>
<PaymentDelay>
<xsl:value-of select="$PaymentDelay"/>
</PaymentDelay>
<StepUpProvision>
<xsl:value-of select="$StepUpProvision"/>
</StepUpProvision>
<WACCapInterestProvision>
<xsl:value-of select="$WACCapInterestProvision"/>
</WACCapInterestProvision>
<InterestShortfallCapIndicator>
<xsl:value-of select="$InterestShortfallCapIndicator"/>
</InterestShortfallCapIndicator>
<InterestShortfallCompounding>
<xsl:value-of select="$InterestShortfallCompounding"/>
</InterestShortfallCompounding>
<InterestShortfallCapBasis>
<xsl:value-of select="$InterestShortfallCapBasis"/>
</InterestShortfallCapBasis>
<InterestShortfallRateSource>
<xsl:value-of select="$InterestShortfallRateSource"/>
</InterestShortfallRateSource>
<MortgagePaymentFrequency>
<xsl:value-of select="$MortgagePaymentFrequency"/>
</MortgagePaymentFrequency>
<MortgageFinalMaturity>
<xsl:value-of select="$MortgageFinalMaturity"/>
</MortgageFinalMaturity>
<MortgageOriginalAmount>
<xsl:value-of select="$MortgageOriginalAmount"/>
</MortgageOriginalAmount>
<MortgageInitialFactor>
<xsl:value-of select="$MortgageInitialFactor"/>
</MortgageInitialFactor>
<MortgageSector>
<xsl:value-of select="$MortgageSector"/>
</MortgageSector>
<MortgageInsurer>
<xsl:value-of select="$MortgageInsurer"/>
</MortgageInsurer>
<IndexName>
<xsl:value-of select="$IndexName"/>
</IndexName>
<IndexId>
<xsl:value-of select="$IndexId"/>
</IndexId>
<IndexAnnexDate>
<xsl:value-of select="$IndexAnnexDate"/>
</IndexAnnexDate>
<IndexTradedRate>
<xsl:value-of select="$IndexTradedRate"/>
</IndexTradedRate>
<UpfrontFee>
<xsl:value-of select="$UpfrontFee"/>
</UpfrontFee>
<UpfrontFeeAmount>
<xsl:value-of select="$UpfrontFeeAmount"/>
</UpfrontFeeAmount>
<xsl:if test="$UpfrontFeeCurrency">
<UpfrontFeeCurrency>
<xsl:value-of select="$UpfrontFeeCurrency"/>
</UpfrontFeeCurrency>
</xsl:if>
<UpfrontFeeDate>
<xsl:value-of select="$UpfrontFeeDate"/>
</UpfrontFeeDate>
<UpfrontFeePayer>
<xsl:value-of select="$UpfrontFeePayer"/>
</UpfrontFeePayer>
<AttachmentPoint>
<xsl:value-of select="$AttachmentPoint"/>
</AttachmentPoint>
<ExhaustionPoint>
<xsl:value-of select="$ExhaustionPoint"/>
</ExhaustionPoint>
<PublicationDate>
<xsl:value-of select="$PublicationDate"/>
</PublicationDate>
<MasterAgreementDate>
<xsl:value-of select="$MasterAgreementDate"/>
</MasterAgreementDate>
<xsl:if test="$MasterAgreementVersion">
<MasterAgreementVersion>
<xsl:value-of select="$MasterAgreementVersion"/>
</MasterAgreementVersion>
</xsl:if>
<AmendmentTradeDate>
<xsl:value-of select="$AmendmentTradeDate"/>
</AmendmentTradeDate>
<SettlementCurrency>
<xsl:value-of select="$SettlementCurrency"/>
</SettlementCurrency>
<ReferenceCurrency>
<xsl:value-of select="$ReferenceCurrency"/>
</ReferenceCurrency>
<SettlementRateOption>
<xsl:value-of select="$SettlementRateOption"/>
</SettlementRateOption>
<NonDeliverable>
<xsl:value-of select="$NonDeliverable"/>
</NonDeliverable>
<xsl:if test="$NonDeliverable2">
<NonDeliverable2>
<xsl:value-of select="$NonDeliverable2"/>
</NonDeliverable2>
</xsl:if>
<xsl:copy-of select="$FxFixingDate"/>
<xsl:if test="$ValuationDateType">
<ValuationDateType>
<xsl:value-of select="$ValuationDateType"/>
</ValuationDateType>
</xsl:if>
<xsl:if test="$ValuationDateType_2">
<ValuationDateType_2>
<xsl:value-of select="$ValuationDateType_2"/>
</ValuationDateType_2>
</xsl:if>
<SettlementCurrency_2>
<xsl:value-of select="$SettlementCurrency_2"/>
</SettlementCurrency_2>
<ReferenceCurrency_2>
<xsl:value-of select="$ReferenceCurrency_2"/>
</ReferenceCurrency_2>
<SettlementRateOption_2>
<xsl:value-of select="$SettlementRateOption_2"/>
</SettlementRateOption_2>
<xsl:copy-of select="$FxFixingDate_2"/>
<OutsideNovationTradeDate>
<xsl:value-of select="$OutsideNovationTradeDate"/>
</OutsideNovationTradeDate>
<OutsideNovationNovationDate>
<xsl:value-of select="$OutsideNovationNovationDate"/>
</OutsideNovationNovationDate>
<OutsideNovationOutgoingParty>
<xsl:value-of select="$OutsideNovationOutgoingParty"/>
</OutsideNovationOutgoingParty>
<OutsideNovationIncomingParty>
<xsl:value-of select="$OutsideNovationIncomingParty"/>
</OutsideNovationIncomingParty>
<OutsideNovationRemainingParty>
<xsl:value-of select="$OutsideNovationRemainingParty"/>
</OutsideNovationRemainingParty>
<OutsideNovationFullFirstCalculationPeriod>
<xsl:value-of select="$OutsideNovationFullFirstCalculationPeriod"/>
</OutsideNovationFullFirstCalculationPeriod>
<CalcAgentA>
<xsl:value-of select="$CalcAgentA"/>
</CalcAgentA>
<AmendmentType>
<xsl:value-of select="$AmendmentType"/>
</AmendmentType>
<xsl:if test="$AmendmentEffectiveDate">
<AmendmentEffectiveDate>
<xsl:value-of select="$AmendmentEffectiveDate"/>
</AmendmentEffectiveDate>
</xsl:if>
<CancellationType>
<xsl:value-of select="$CancellationType"/>
</CancellationType>
<xsl:if test="$Cancelable">
<Cancelable>
<xsl:value-of select="$Cancelable"/>
</Cancelable>
</xsl:if>
<xsl:if test="$CancelableDirectionA">
<CancelableDirectionA>
<xsl:value-of select="$CancelableDirectionA"/>
</CancelableDirectionA>
</xsl:if>
<xsl:if test="$CancelableOptionStyle">
<CancelableOptionStyle>
<xsl:value-of select="$CancelableOptionStyle"/>
</CancelableOptionStyle>
</xsl:if>
<xsl:if test="$CancelableFirstExerciseDate">
<CancelableFirstExerciseDate>
<xsl:value-of select="$CancelableFirstExerciseDate"/>
</CancelableFirstExerciseDate>
</xsl:if>
<xsl:if test="$CancelableExerciseFrequency">
<CancelableExerciseFrequency>
<xsl:value-of select="$CancelableExerciseFrequency"/>
</CancelableExerciseFrequency>
</xsl:if>
<xsl:if test="$CancelableEarliestTime">
<CancelableEarliestTime>
<xsl:value-of select="$CancelableEarliestTime"/>
</CancelableEarliestTime>
</xsl:if>
<xsl:if test="$CancelableExpiryTime">
<CancelableExpiryTime>
<xsl:value-of select="$CancelableExpiryTime"/>
</CancelableExpiryTime>
</xsl:if>
<xsl:if test="$CancelableExerciseLag">
<CancelableExerciseLag>
<xsl:value-of select="$CancelableExerciseLag"/>
</CancelableExerciseLag>
</xsl:if>
<xsl:if test="$CancelableHolidayCentre">
<CancelableHolidayCentre>
<xsl:value-of select="$CancelableHolidayCentre"/>
</CancelableHolidayCentre>
</xsl:if>
<xsl:if test="$CancelableLocation">
<CancelableLocation>
<xsl:value-of select="$CancelableLocation"/>
</CancelableLocation>
</xsl:if>
<xsl:if test="$CancelableConvention">
<CancelableConvention>
<xsl:value-of select="$CancelableConvention"/>
</CancelableConvention>
</xsl:if>
<xsl:if test="$CancelableFUC">
<CancelableFUC>
<xsl:value-of select="$CancelableFUC"/>
</CancelableFUC>
</xsl:if>
<xsl:if test="$CancelableDayType">
<CancelableDayType>
<xsl:value-of select="$CancelableDayType"/>
</CancelableDayType>
</xsl:if>
<xsl:if test="$CancelableLagConvention">
<CancelableLagConvention>
<xsl:value-of select="$CancelableLagConvention"/>
</CancelableLagConvention>
</xsl:if>
<xsl:if test="$CancelableRollCentres">
<CancelableRollCentres>
<xsl:value-of select="$CancelableRollCentres"/>
</CancelableRollCentres>
</xsl:if>
<xsl:copy-of select="$CancelablePremium"/>
<xsl:if test="$CancellationForwardPremium">
<CancellationForwardPremium>
<xsl:value-of select="$CancellationForwardPremium"/>
</CancellationForwardPremium>
</xsl:if>
<xsl:if test="$SettlementAgency">
<SettlementAgency>
<xsl:value-of select="$SettlementAgency"/>
</SettlementAgency>
</xsl:if>
<xsl:if test="$SettlementAgencyModel">
<SettlementAgencyModel>
<xsl:value-of select="$SettlementAgencyModel"/>
</SettlementAgencyModel>
</xsl:if>
<OfflineLeg1>
<xsl:value-of select="$OfflineLeg1"/>
</OfflineLeg1>
<OfflineLeg2>
<xsl:value-of select="$OfflineLeg2"/>
</OfflineLeg2>
<OfflineSpread>
<xsl:value-of select="$OfflineSpread"/>
</OfflineSpread>
<OfflineSpreadLeg>
<xsl:value-of select="$OfflineSpreadLeg"/>
</OfflineSpreadLeg>
<OfflineSpreadParty>
<xsl:value-of select="$OfflineSpreadParty"/>
</OfflineSpreadParty>
<OfflineSpreadDirection>
<xsl:value-of select="$OfflineSpreadDirection"/>
</OfflineSpreadDirection>
<OfflineAdditionalDetails>
<xsl:value-of select="$OfflineAdditionalDetails"/>
</OfflineAdditionalDetails>
<OfflineOrigRef>
<xsl:value-of select="$OfflineOrigRef"/>
</OfflineOrigRef>
<OfflineOrigRef_2>
<xsl:value-of select="$OfflineOrigRef_2"/>
</OfflineOrigRef_2>
<OfflineTradeDesk>
<xsl:value-of select="$OfflineTradeDesk"/>
</OfflineTradeDesk>
<OfflineTradeDesk_2>
<xsl:value-of select="$OfflineTradeDesk_2"/>
</OfflineTradeDesk_2>
<OfflineProductType>
<xsl:value-of select="$OfflineProductType"/>
</OfflineProductType>
<OfflineExpirationDate>
<xsl:value-of select="$OfflineExpirationDate"/>
</OfflineExpirationDate>
<OfflineOptionType>
<xsl:value-of select="$OfflineOptionType"/>
</OfflineOptionType>
<EquityRic>
<xsl:value-of select="$EquityRic"/>
</EquityRic>
<xsl:if test="$eqStartDate">
<eqStartDate>
<xsl:value-of select="$eqStartDate"/>
</eqStartDate>
</xsl:if>
<xsl:if test="$eqEndDate">
<eqEndDate>
<xsl:value-of select="$eqEndDate"/>
</eqEndDate>
</xsl:if>
<xsl:if test="$initialAmtPayer">
<initialAmtPayer>
<xsl:value-of select="$initialAmtPayer"/>
</initialAmtPayer>
</xsl:if>
<xsl:if test="$noOfGuaranteedPrd">
<noOfGuaranteedPrd>
<xsl:value-of select="$noOfGuaranteedPrd"/>
</noOfGuaranteedPrd>
</xsl:if>
<xsl:if test="$prePaymentAmount">
<prePaymentAmount>
<xsl:value-of select="$prePaymentAmount"/>
</prePaymentAmount>
</xsl:if>
<xsl:if test="$prePaymentAmountCurrency">
<prePaymentAmountCurrency>
<xsl:value-of select="$prePaymentAmountCurrency"/>
</prePaymentAmountCurrency>
</xsl:if>
<xsl:if test="$prePaymentDate">
<prePaymentDate>
<xsl:value-of select="$prePaymentDate"/>
</prePaymentDate>
</xsl:if>
<xsl:if test="$knockOutCommencementDate">
<knockOutCommencementDate>
<xsl:value-of select="$knockOutCommencementDate"/>
</knockOutCommencementDate>
</xsl:if>
<xsl:if test="$customDate">
<customDate>
<xsl:value-of select="$customDate"/>
</customDate>
</xsl:if>
<xsl:if test="$swPaymentDateOffset">
<swPaymentDateOffset>
<xsl:value-of select="$swPaymentDateOffset"/>
</swPaymentDateOffset>
</xsl:if>
<xsl:if test="$targetPerformance">
<targetPerformance>
<xsl:value-of select="$targetPerformance"/>
</targetPerformance>
</xsl:if>
<xsl:if test="$knockOutPrice">
<knockOutPrice>
<xsl:value-of select="$knockOutPrice"/>
</knockOutPrice>
</xsl:if>
<xsl:if test="$knockOutType">
<knockOutType>
<xsl:value-of select="$knockOutType"/>
</knockOutType>
</xsl:if>
<xsl:if test="$spotPrice">
<spotPrice>
<xsl:value-of select="$spotPrice"/>
</spotPrice>
</xsl:if>
<xsl:if test="$spotPriceCurrency">
<spotPriceCurrency>
<xsl:value-of select="$spotPriceCurrency"/>
</spotPriceCurrency>
</xsl:if>
<xsl:if test="$forwardPrice">
<forwardPrice>
<xsl:value-of select="$forwardPrice"/>
</forwardPrice>
</xsl:if>
<xsl:if test="$forwardPriceCurrency">
<forwardPriceCurrency>
<xsl:value-of select="$forwardPriceCurrency"/>
</forwardPriceCurrency>
</xsl:if>
<xsl:if test="$purchaseFrequency">
<purchaseFrequency>
<xsl:value-of select="$purchaseFrequency"/>
</purchaseFrequency>
</xsl:if>
<xsl:if test="$settlementFrequency">
<settlementFrequency>
<xsl:value-of select="$settlementFrequency"/>
</settlementFrequency>
</xsl:if>
<xsl:if test="$NumberOfSharesPerDay">
<NumberOfSharesPerDay>
<xsl:value-of select="$NumberOfSharesPerDay"/>
</NumberOfSharesPerDay>
</xsl:if>
<xsl:if test="$gearingFactor">
<gearingFactor>
<xsl:value-of select="$gearingFactor"/>
</gearingFactor>
</xsl:if>
<xsl:if test="$leverageTriggerPrice">
<leverageTriggerPrice>
<xsl:value-of select="$leverageTriggerPrice"/>
</leverageTriggerPrice>
</xsl:if>
<xsl:if test="$higherForwardPrice">
<higherForwardPrice>
<xsl:value-of select="$higherForwardPrice"/>
</higherForwardPrice>
</xsl:if>
<xsl:if test="$lowerForwardPrice">
<lowerForwardPrice>
<xsl:value-of select="$lowerForwardPrice"/>
</lowerForwardPrice>
</xsl:if>
<xsl:copy-of select="$AccumulatorSettlementDetails"/>
<OptionQuantity>
<xsl:value-of select="$OptionQuantity"/>
</OptionQuantity>
<OptionNumberOfShares>
<xsl:value-of select="$OptionNumberOfShares"/>
</OptionNumberOfShares>
<Price>
<xsl:value-of select="$Price"/>
</Price>
<PricePerOptionCurrency>
<xsl:value-of select="$PricePerOptionCurrency"/>
</PricePerOptionCurrency>
<ExchangeLookAlike>
<xsl:value-of select="$ExchangeLookAlike"/>
</ExchangeLookAlike>
<AdjustmentMethod>
<xsl:value-of select="$AdjustmentMethod"/>
</AdjustmentMethod>
<MasterConfirmationDate>
<xsl:value-of select="$MasterConfirmationDate"/>
</MasterConfirmationDate>
<Multiplier>
<xsl:value-of select="$Multiplier"/>
</Multiplier>
<OptionExchange>
<xsl:value-of select="$OptionExchange"/>
</OptionExchange>
<RelatedExchange>
<xsl:value-of select="$RelatedExchange"/>
</RelatedExchange>
<DefaultSettlementMethod>
<xsl:value-of select="$DefaultSettlementMethod"/>
</DefaultSettlementMethod>
<SettlementPriceDefaultElectionMethod>
<xsl:value-of select="$SettlementPriceDefaultElectionMethod"/>
</SettlementPriceDefaultElectionMethod>
<DesignatedContract>
<xsl:value-of select="$DesignatedContract"/>
</DesignatedContract>
<FxDeterminationMethod>
<xsl:value-of select="$FxDeterminationMethod"/>
</FxDeterminationMethod>
<SWFXRateSource>
<xsl:value-of select="$SWFXRateSource"/>
</SWFXRateSource>
<SWFXRateSourcePage>
<xsl:value-of select="$SWFXRateSourcePage"/>
</SWFXRateSourcePage>
<SWFXHourMinuteTime>
<xsl:value-of select="$SWFXHourMinuteTime"/>
</SWFXHourMinuteTime>
<SWFXBusinessCenter>
<xsl:value-of select="$SWFXBusinessCenter"/>
</SWFXBusinessCenter>
<SettlementMethodElectionDate>
<xsl:value-of select="$SettlementMethodElectionDate"/>
</SettlementMethodElectionDate>
<SettlementMethodElectingParty>
<xsl:value-of select="$SettlementMethodElectingParty"/>
</SettlementMethodElectingParty>
<SettlementDateOffset>
<xsl:value-of select="$SettlementDateOffset"/>
</SettlementDateOffset>
<SettlementType>
<xsl:value-of select="$SettlementType"/>
</SettlementType>
<xsl:if test="$SettlementDate">
<SettlementDate>
<xsl:value-of select="$SettlementDate"/>
</SettlementDate>
</xsl:if>
<MultipleExchangeIndexAnnex>
<xsl:value-of select="$MultipleExchangeIndexAnnex"/>
</MultipleExchangeIndexAnnex>
<ComponentSecurityIndexAnnex>
<xsl:value-of select="$ComponentSecurityIndexAnnex"/>
</ComponentSecurityIndexAnnex>
<LocalJurisdiction>
<xsl:value-of select="$LocalJurisdiction"/>
</LocalJurisdiction>
<OptionHedgingDisruption>
<xsl:value-of select="$OptionHedgingDisruption"/>
</OptionHedgingDisruption>
<OptionLossOfStockBorrow>
<xsl:value-of select="$OptionLossOfStockBorrow"/>
</OptionLossOfStockBorrow>
<OptionMaximumStockLoanRate>
<xsl:value-of select="$OptionMaximumStockLoanRate"/>
</OptionMaximumStockLoanRate>
<OptionIncreasedCostOfStockBorrow>
<xsl:value-of select="$OptionIncreasedCostOfStockBorrow"/>
</OptionIncreasedCostOfStockBorrow>
<OptionInitialStockLoanRate>
<xsl:value-of select="$OptionInitialStockLoanRate"/>
</OptionInitialStockLoanRate>
<OptionIncreasedCostOfHedging>
<xsl:value-of select="$OptionIncreasedCostOfHedging"/>
</OptionIncreasedCostOfHedging>
<OptionForeignOwnershipEvent>
<xsl:value-of select="$OptionForeignOwnershipEvent"/>
</OptionForeignOwnershipEvent>
<OptionEntitlement>
<xsl:value-of select="$OptionEntitlement"/>
</OptionEntitlement>
<xsl:if test="$FxFeature">
<FxFeature>
<xsl:value-of select="$FxFeature"/>
</FxFeature>
</xsl:if>
<ReferencePriceSource>
<xsl:value-of select="$ReferencePriceSource"/>
</ReferencePriceSource>
<ReferencePricePage>
<xsl:value-of select="$ReferencePricePage"/>
</ReferencePricePage>
<ReferencePriceTime>
<xsl:value-of select="$ReferencePriceTime"/>
</ReferencePriceTime>
<ReferencePriceCity>
<xsl:value-of select="$ReferencePriceCity"/>
</ReferencePriceCity>
<MinimumNumberOfOptions>
<xsl:value-of select="$MinimumNumberOfOptions"/>
</MinimumNumberOfOptions>
<IntegralMultiple>
<xsl:value-of select="$IntegralMultiple"/>
</IntegralMultiple>
<MaximumNumberOfOptions>
<xsl:value-of select="$MaximumNumberOfOptions"/>
</MaximumNumberOfOptions>
<ExerciseCommencementDate>
<xsl:value-of select="$ExerciseCommencementDate"/>
</ExerciseCommencementDate>
<xsl:copy-of select="$BermudaExerciseDates"/>
<BermudaFrequency>
<xsl:value-of select="$BermudaFrequency"/>
</BermudaFrequency>
<BermudaFirstDate>
<xsl:value-of select="$BermudaFirstDate"/>
</BermudaFirstDate>
<BermudaFinalDate>
<xsl:value-of select="$BermudaFinalDate"/>
</BermudaFinalDate>
<LatestExerciseTimeMethod>
<xsl:value-of select="$LatestExerciseTimeMethod"/>
</LatestExerciseTimeMethod>
<LatestExerciseSpecificTime>
<xsl:value-of select="$LatestExerciseSpecificTime"/>
</LatestExerciseSpecificTime>
<DcCurrency>
<xsl:value-of select="$DcCurrency"/>
</DcCurrency>
<DcDelta>
<xsl:value-of select="$DcDelta"/>
</DcDelta>
<DcEventTypeA>
<xsl:value-of select="$DcEventTypeA"/>
</DcEventTypeA>
<DcExchange>
<xsl:value-of select="$DcExchange"/>
</DcExchange>
<DcExpiryDate>
<xsl:value-of select="$DcExpiryDate"/>
</DcExpiryDate>
<DcFuturesCode>
<xsl:value-of select="$DcFuturesCode"/>
</DcFuturesCode>
<DcOffshoreCross>
<xsl:value-of select="$DcOffshoreCross"/>
</DcOffshoreCross>
<DcOffshoreCrossLocation>
<xsl:value-of select="$DcOffshoreCrossLocation"/>
</DcOffshoreCrossLocation>
<DcPrice>
<xsl:value-of select="$DcPrice"/>
</DcPrice>
<DcQuantity>
<xsl:value-of select="$DcQuantity"/>
</DcQuantity>
<DcRequired>
<xsl:value-of select="$DcRequired"/>
</DcRequired>
<DcRic>
<xsl:value-of select="$DcRic"/>
</DcRic>
<DcDescription>
<xsl:value-of select="$DcDescription"/>
</DcDescription>
<AveragingInOut>
<xsl:value-of select="$AveragingInOut"/>
</AveragingInOut>
<xsl:copy-of select="$AveragingDateTimes"/>
<MarketDisruption>
<xsl:value-of select="$MarketDisruption"/>
</MarketDisruption>
<AveragingFrequency>
<xsl:value-of select="$AveragingFrequency"/>
</AveragingFrequency>
<xsl:if test="$AveragingRollConvention">
<AveragingRollConvention>
<xsl:value-of select="$AveragingRollConvention"/>
</AveragingRollConvention>
</xsl:if>
<AveragingStartDate>
<xsl:value-of select="$AveragingStartDate"/>
</AveragingStartDate>
<AveragingEndDate>
<xsl:value-of select="$AveragingEndDate"/>
</AveragingEndDate>
<AveragingBusinessDayConvention>
<xsl:value-of select="$AveragingBusinessDayConvention"/>
</AveragingBusinessDayConvention>
<ReferenceFXRate>
<xsl:value-of select="$ReferenceFXRate"/>
</ReferenceFXRate>
<HedgeLevel>
<xsl:value-of select="$HedgeLevel"/>
</HedgeLevel>
<Basis>
<xsl:value-of select="$Basis"/>
</Basis>
<ImpliedLevel>
<xsl:value-of select="$ImpliedLevel"/>
</ImpliedLevel>
<PremiumPercent>
<xsl:value-of select="$PremiumPercent"/>
</PremiumPercent>
<StrikePercent>
<xsl:value-of select="$StrikePercent"/>
</StrikePercent>
<BaseNotional>
<xsl:value-of select="$BaseNotional"/>
</BaseNotional>
<BaseNotionalCurrency>
<xsl:value-of select="$BaseNotionalCurrency"/>
</BaseNotionalCurrency>
<BreakOutTrade>
<xsl:value-of select="$BreakOutTrade"/>
</BreakOutTrade>
<SplitCollateral>
<xsl:value-of select="$SplitCollateral"/>
</SplitCollateral>
<xsl:copy-of select="$PeriodPaymentDate"/>
<OpenUnits>
<xsl:value-of select="$OpenUnits"/>
</OpenUnits>
<DeclaredCashDividendPercentage>
<xsl:value-of select="$DeclaredCashDividendPercentage"/>
</DeclaredCashDividendPercentage>
<DeclaredCashEquivalentDividendPercentage>
<xsl:value-of select="$DeclaredCashEquivalentDividendPercentage"/>
</DeclaredCashEquivalentDividendPercentage>
<DividendPayer>
<xsl:value-of select="$DividendPayer"/>
</DividendPayer>
<DividendReceiver>
<xsl:value-of select="$DividendReceiver"/>
</DividendReceiver>
<xsl:copy-of select="$DividendPeriods"/>
<SpecialDividends>
<xsl:value-of select="$SpecialDividends"/>
</SpecialDividends>
<MaterialDividend>
<xsl:value-of select="$MaterialDividend"/>
</MaterialDividend>
<FixedPayer>
<xsl:value-of select="$FixedPayer"/>
</FixedPayer>
<FixedReceiver>
<xsl:value-of select="$FixedReceiver"/>
</FixedReceiver>
<xsl:copy-of select="$FixedPeriods"/>
<xsl:copy-of select="$EquityAveragingObservations"/>
<EquityInitialSpot>
<xsl:value-of select="$EquityInitialSpot"/>
</EquityInitialSpot>
<EquityCap>
<xsl:value-of select="$EquityCap"/>
</EquityCap>
<EquityCapPercentage>
<xsl:value-of select="$EquityCapPercentage"/>
</EquityCapPercentage>
<EquityFloor>
<xsl:value-of select="$EquityFloor"/>
</EquityFloor>
<EquityFloorPercentage>
<xsl:value-of select="$EquityFloorPercentage"/>
</EquityFloorPercentage>
<EquityNotional>
<xsl:value-of select="$EquityNotional"/>
</EquityNotional>
<EquityNotionalCurrency>
<xsl:value-of select="$EquityNotionalCurrency"/>
</EquityNotionalCurrency>
<EquityFrequency>
<xsl:value-of select="$EquityFrequency"/>
</EquityFrequency>
<EquityValuationMethod>
<xsl:value-of select="$EquityValuationMethod"/>
</EquityValuationMethod>
<EquityFrequencyConvention>
<xsl:value-of select="$EquityFrequencyConvention"/>
</EquityFrequencyConvention>
<EquityFreqFirstDate>
<xsl:value-of select="$EquityFreqFirstDate"/>
</EquityFreqFirstDate>
<EquityFreqFinalDate>
<xsl:value-of select="$EquityFreqFinalDate"/>
</EquityFreqFinalDate>
<EquityFreqRoll>
<xsl:value-of select="$EquityFreqRoll"/>
</EquityFreqRoll>
<xsl:copy-of select="$EquityListedValuationDates"/>
<EquityListedDatesConvention>
<xsl:value-of select="$EquityListedDatesConvention"/>
</EquityListedDatesConvention>
<StrategyType>
<xsl:value-of select="$StrategyType"/>
</StrategyType>
<StrategyDeltaLeg>
<xsl:value-of select="$StrategyDeltaLeg"/>
</StrategyDeltaLeg>
<StrategyDeltaQuantity>
<xsl:value-of select="$StrategyDeltaQuantity"/>
</StrategyDeltaQuantity>
<StrategyComments>
<xsl:value-of select="$StrategyComments"/>
</StrategyComments>
<xsl:if test="$StrategySingleTrade">
<StrategySingleTrade>
<xsl:value-of select="$StrategySingleTrade"/>
</StrategySingleTrade>
</xsl:if>
<xsl:copy-of select="$StrategyLegs"/>
<VegaNotional>
<xsl:value-of select="$VegaNotional"/>
</VegaNotional>
<ExpectedN>
<xsl:value-of select="$ExpectedN"/>
</ExpectedN>
<ExpectedNOverride>
<xsl:value-of select="$ExpectedNOverride"/>
</ExpectedNOverride>
<VarianceAmount>
<xsl:value-of select="$VarianceAmount"/>
</VarianceAmount>
<VarianceStrikePrice>
<xsl:value-of select="$VarianceStrikePrice"/>
</VarianceStrikePrice>
<VolatilityStrikePrice>
<xsl:value-of select="$VolatilityStrikePrice"/>
</VolatilityStrikePrice>
<VarianceCapIndicator>
<xsl:value-of select="$VarianceCapIndicator"/>
</VarianceCapIndicator>
<VarianceCapFactor>
<xsl:value-of select="$VarianceCapFactor"/>
</VarianceCapFactor>
<TotalVarianceCap>
<xsl:value-of select="$TotalVarianceCap"/>
</TotalVarianceCap>
<xsl:if test="$VolatilityCapIndicator">
<VolatilityCapIndicator>
<xsl:value-of select="$VolatilityCapIndicator"/>
</VolatilityCapIndicator>
</xsl:if>
<TotalVolatilityCap>
<xsl:value-of select="$TotalVolatilityCap"/>
</TotalVolatilityCap>
<xsl:if test="$VolatilityCapFactor">
<VolatilityCapFactor>
<xsl:value-of select="$VolatilityCapFactor"/>
</VolatilityCapFactor>
</xsl:if>
<ObservationStartDate>
<xsl:value-of select="$ObservationStartDate"/>
</ObservationStartDate>
<ValuationDate>
<xsl:value-of select="$ValuationDate"/>
</ValuationDate>
<InitialSharePriceOrIndexLevel>
<xsl:value-of select="$InitialSharePriceOrIndexLevel"/>
</InitialSharePriceOrIndexLevel>
<ClosingSharePriceOrClosingIndexLevelIndicator>
<xsl:value-of select="$ClosingSharePriceOrClosingIndexLevelIndicator"/>
</ClosingSharePriceOrClosingIndexLevelIndicator>
<FuturesPriceValuation>
<xsl:value-of select="$FuturesPriceValuation"/>
</FuturesPriceValuation>
<AllDividends>
<xsl:value-of select="$AllDividends"/>
</AllDividends>
<SettlementCurrencyVegaNotional>
<xsl:value-of select="$SettlementCurrencyVegaNotional"/>
</SettlementCurrencyVegaNotional>
<VegaFxRate>
<xsl:value-of select="$VegaFxRate"/>
</VegaFxRate>
<xsl:copy-of select="$HolidayDates"/>
<xsl:copy-of select="$DispLegs"/>
<xsl:copy-of select="$DispLegsSW"/>
<BulletIndicator>
<xsl:value-of select="$BulletIndicator"/>
</BulletIndicator>
<DocsSelection>
<xsl:value-of select="$DocsSelection"/>
</DocsSelection>
<xsl:copy-of select="$NovationReporting"/>
<InterestLegDrivenIndicator>
<xsl:value-of select="$InterestLegDrivenIndicator"/>
</InterestLegDrivenIndicator>
<EquityFrontStub>
<xsl:value-of select="$EquityFrontStub"/>
</EquityFrontStub>
<EquityEndStub>
<xsl:value-of select="$EquityEndStub"/>
</EquityEndStub>
<InterestFrontStub>
<xsl:value-of select="$InterestFrontStub"/>
</InterestFrontStub>
<InterestEndStub>
<xsl:value-of select="$InterestEndStub"/>
</InterestEndStub>
<FixedRateIndicator>
<xsl:value-of select="$FixedRateIndicator"/>
</FixedRateIndicator>
<EswFixingDateOffset>
<xsl:value-of select="$EswFixingDateOffset"/>
</EswFixingDateOffset>
<DividendPaymentDates>
<xsl:value-of select="$DividendPaymentDates"/>
</DividendPaymentDates>
<DividendPaymentOffset>
<xsl:value-of select="$DividendPaymentOffset"/>
</DividendPaymentOffset>
<xsl:if test="$EswDividendAmount">
<EswDividendAmount>
<xsl:value-of select="$EswDividendAmount"/>
</EswDividendAmount>
</xsl:if>
<xsl:if test="$EswDividendPeriod">
<EswDividendPeriod>
<xsl:value-of select="$EswDividendPeriod"/>
</EswDividendPeriod>
</xsl:if>
<DividendPercentage>
<xsl:value-of select="$DividendPercentage"/>
</DividendPercentage>
<DividendReinvestment>
<xsl:value-of select="$DividendReinvestment"/>
</DividendReinvestment>
<EswDeclaredCashDividendPercentage>
<xsl:value-of select="$EswDeclaredCashDividendPercentage"/>
</EswDeclaredCashDividendPercentage>
<EswDeclaredCashEquivalentDividendPercentage>
<xsl:value-of select="$EswDeclaredCashEquivalentDividendPercentage"/>
</EswDeclaredCashEquivalentDividendPercentage>
<EswDividendSettlementCurrency>
<xsl:value-of select="$EswDividendSettlementCurrency"/>
</EswDividendSettlementCurrency>
<EswNonCashDividendTreatment>
<xsl:value-of select="$EswNonCashDividendTreatment"/>
</EswNonCashDividendTreatment>
<EswDividendComposition>
<xsl:value-of select="$EswDividendComposition"/>
</EswDividendComposition>
<EswSpecialDividends>
<xsl:value-of select="$EswSpecialDividends"/>
</EswSpecialDividends>
<EswDividendValuationOffset>
<xsl:value-of select="$EswDividendValuationOffset"/>
</EswDividendValuationOffset>
<EswDividendValuationFrequency>
<xsl:value-of select="$EswDividendValuationFrequency"/>
</EswDividendValuationFrequency>
<EswDividendInitialValuation>
<xsl:value-of select="$EswDividendInitialValuation"/>
</EswDividendInitialValuation>
<EswDividendFinalValuation>
<xsl:value-of select="$EswDividendFinalValuation"/>
</EswDividendFinalValuation>
<EswDividendValuationDay>
<xsl:value-of select="$EswDividendValuationDay"/>
</EswDividendValuationDay>
<xsl:copy-of select="$EswDividendValuationCustomDatesInterim"/>
<EswDividendValuationCustomDateFinal>
<xsl:value-of select="$EswDividendValuationCustomDateFinal"/>
</EswDividendValuationCustomDateFinal>
<ExitReason>
<xsl:value-of select="$ExitReason"/>
</ExitReason>
<TransactionDate>
<xsl:value-of select="$TransactionDate"/>
</TransactionDate>
<EffectiveDate>
<xsl:value-of select="$EffectiveDate"/>
</EffectiveDate>
<EquityHolidayCentres>
<xsl:value-of select="$EquityHolidayCentres"/>
</EquityHolidayCentres>
<OtherValuationBusinessCenters>
<xsl:value-of select="$OtherValuationBusinessCenters"/>
</OtherValuationBusinessCenters>
<EswFuturesPriceValuation>
<xsl:value-of select="$EswFuturesPriceValuation"/>
</EswFuturesPriceValuation>
<EswFpvFinalPriceElectionFallback>
<xsl:value-of select="$EswFpvFinalPriceElectionFallback"/>
</EswFpvFinalPriceElectionFallback>
<EswDesignatedMaturity>
<xsl:value-of select="$EswDesignatedMaturity"/>
</EswDesignatedMaturity>
<EswEquityValConvention>
<xsl:value-of select="$EswEquityValConvention"/>
</EswEquityValConvention>
<EswInterestFloatConvention>
<xsl:value-of select="$EswInterestFloatConvention"/>
</EswInterestFloatConvention>
<EswInterestFloatDayBasis>
<xsl:value-of select="$EswInterestFloatDayBasis"/>
</EswInterestFloatDayBasis>
<EswInterestFloatingRateIndex>
<xsl:value-of select="$EswInterestFloatingRateIndex"/>
</EswInterestFloatingRateIndex>
<EswInterestFixedRate>
<xsl:value-of select="$EswInterestFixedRate"/>
</EswInterestFixedRate>
<EswInterestSpreadOverIndex>
<xsl:value-of select="$EswInterestSpreadOverIndex"/>
</EswInterestSpreadOverIndex>
<xsl:copy-of select="$EswInterestSpreadOverIndexStep"/>
<EswLocalJurisdiction>
<xsl:value-of select="$EswLocalJurisdiction"/>
</EswLocalJurisdiction>
<EswReferencePriceSource>
<xsl:value-of select="$EswReferencePriceSource"/>
</EswReferencePriceSource>
<EswReferencePricePage>
<xsl:value-of select="$EswReferencePricePage"/>
</EswReferencePricePage>
<EswReferencePriceTime>
<xsl:value-of select="$EswReferencePriceTime"/>
</EswReferencePriceTime>
<EswReferencePriceCity>
<xsl:value-of select="$EswReferencePriceCity"/>
</EswReferencePriceCity>
<EswNotionalAmount>
<xsl:value-of select="$EswNotionalAmount"/>
</EswNotionalAmount>
<EswNotionalCurrency>
<xsl:value-of select="$EswNotionalCurrency"/>
</EswNotionalCurrency>
<EswOpenUnits>
<xsl:value-of select="$EswOpenUnits"/>
</EswOpenUnits>
<xsl:if test="$EswInitialUnits">
<EswInitialUnits>
<xsl:value-of select="$EswInitialUnits"/>
</EswInitialUnits>
</xsl:if>
<FeeIn>
<xsl:value-of select="$FeeIn"/>
</FeeIn>
<FeeInOutIndicator>
<xsl:value-of select="$FeeInOutIndicator"/>
</FeeInOutIndicator>
<FeeOut>
<xsl:value-of select="$FeeOut"/>
</FeeOut>
<FinalPriceDefaultElection>
<xsl:value-of select="$FinalPriceDefaultElection"/>
</FinalPriceDefaultElection>
<FinalValuationDate>
<xsl:value-of select="$FinalValuationDate"/>
</FinalValuationDate>
<FullyFundedAmount>
<xsl:value-of select="$FullyFundedAmount"/>
</FullyFundedAmount>
<FullyFundedIndicator>
<xsl:value-of select="$FullyFundedIndicator"/>
</FullyFundedIndicator>
<xsl:if test="$FullyFundedFixedRate">
<FullyFundedFixedRate>
<xsl:value-of select="$FullyFundedFixedRate"/>
</FullyFundedFixedRate>
</xsl:if>
<xsl:if test="$FullyFundedDayCountFract">
<FullyFundedDayCountFract>
<xsl:value-of select="$FullyFundedDayCountFract"/>
</FullyFundedDayCountFract>
</xsl:if>
<xsl:if test="$InitialPrice">
<InitialPrice>
<xsl:value-of select="$InitialPrice"/>
</InitialPrice>
</xsl:if>
<InitialPriceElection>
<xsl:value-of select="$InitialPriceElection"/>
</InitialPriceElection>
<EquityNotionalReset>
<xsl:value-of select="$EquityNotionalReset"/>
</EquityNotionalReset>
<EswReferenceInitialPrice>
<xsl:value-of select="$EswReferenceInitialPrice"/>
</EswReferenceInitialPrice>
<EswReferenceFXRate>
<xsl:value-of select="$EswReferenceFXRate"/>
</EswReferenceFXRate>
<PaymentDateOffset>
<xsl:value-of select="$PaymentDateOffset"/>
</PaymentDateOffset>
<PaymentFrequency>
<xsl:value-of select="$PaymentFrequency"/>
</PaymentFrequency>
<EswFixingHolidayCentres>
<xsl:value-of select="$EswFixingHolidayCentres"/>
</EswFixingHolidayCentres>
<EswPaymentHolidayCentres>
<xsl:value-of select="$EswPaymentHolidayCentres"/>
</EswPaymentHolidayCentres>
<ReturnType>
<xsl:value-of select="$ReturnType"/>
</ReturnType>
<Synthetic>
<xsl:value-of select="$Synthetic"/>
</Synthetic>
<TerminationDate>
<xsl:value-of select="$TerminationDate"/>
</TerminationDate>
<ValuationDay>
<xsl:value-of select="$ValuationDay"/>
</ValuationDay>
<PaymentDay>
<xsl:value-of select="$PaymentDay"/>
</PaymentDay>
<ValuationFrequency>
<xsl:value-of select="$ValuationFrequency"/>
</ValuationFrequency>
<ValuationStartDate>
<xsl:value-of select="$ValuationStartDate"/>
</ValuationStartDate>
<EswSchedulingMethod>
<xsl:value-of select="$EswSchedulingMethod"/>
</EswSchedulingMethod>
<xsl:copy-of select="$EswValuationDates"/>
<xsl:copy-of select="$EswFixingDates"/>
<xsl:copy-of select="$EswInterestLegPaymentDates"/>
<xsl:copy-of select="$EswEquityLegPaymentDates"/>
<xsl:copy-of select="$EswCompoundingDates"/>
<EswCompoundingMethod>
<xsl:value-of select="$EswCompoundingMethod"/>
</EswCompoundingMethod>
<EswCompoundingFrequency>
<xsl:value-of select="$EswCompoundingFrequency"/>
</EswCompoundingFrequency>
<xsl:if test="$EswCalculationMethod">
<EswCalculationMethod>
<xsl:value-of select="$EswCalculationMethod"/>
</EswCalculationMethod>
</xsl:if>
<xsl:if test="$EswApplicableBusinessDays">
<EswApplicableBusinessDays>
<xsl:value-of select="$EswApplicableBusinessDays"/>
</EswApplicableBusinessDays>
</xsl:if>
<xsl:if test="$EswObservationMethod">
<EswObservationMethod>
<xsl:value-of select="$EswObservationMethod"/>
</EswObservationMethod>
</xsl:if>
<xsl:if test="$EswAdditionalBusinessDays">
<EswAdditionalBusinessDays>
<xsl:value-of select="$EswAdditionalBusinessDays"/>
</EswAdditionalBusinessDays>
</xsl:if>
<xsl:if test="$EswOffsetDays">
<EswOffsetDays>
<xsl:value-of select="$EswOffsetDays"/>
</EswOffsetDays>
</xsl:if>
<xsl:if test="$EswObservationPeriod">
<EswObservationPeriod>
<xsl:value-of select="$EswObservationPeriod"/>
</EswObservationPeriod>
</xsl:if>
<xsl:if test="$EswDailyCapRate">
<EswDailyCapRate>
<xsl:value-of select="$EswDailyCapRate"/>
</EswDailyCapRate>
</xsl:if>
<xsl:if test="$EswDailyFloorRate">
<EswDailyFloorRate>
<xsl:value-of select="$EswDailyFloorRate"/>
</EswDailyFloorRate>
</xsl:if>
<EswInterpolationMethod>
<xsl:value-of select="$EswInterpolationMethod"/>
</EswInterpolationMethod>
<EswInterpolationPeriod>
<xsl:value-of select="$EswInterpolationPeriod"/>
</EswInterpolationPeriod>
<xsl:if test="$EswAdditionalDisruptionEventIndicator">
<EswAdditionalDisruptionEventIndicator>
<xsl:value-of select="$EswAdditionalDisruptionEventIndicator"/>
</EswAdditionalDisruptionEventIndicator>
</xsl:if>
<xsl:if test="$EswOverrideNotionalCalculation">
<EswOverrideNotionalCalculation>
<xsl:value-of select="$EswOverrideNotionalCalculation"/>
</EswOverrideNotionalCalculation>
</xsl:if>
<xsl:if test="$EswPaymentDaysOffset">
<EswPaymentDaysOffset>
<xsl:value-of select="$EswPaymentDaysOffset"/>
</EswPaymentDaysOffset>
</xsl:if>
<EswAveragingDatesIndicator>
<xsl:value-of select="$EswAveragingDatesIndicator"/>
</EswAveragingDatesIndicator>
<EswADTVIndicator>
<xsl:value-of select="$EswADTVIndicator"/>
</EswADTVIndicator>
<EswLimitationPercentage>
<xsl:value-of select="$EswLimitationPercentage"/>
</EswLimitationPercentage>
<EswLimitationPeriod>
<xsl:value-of select="$EswLimitationPeriod"/>
</EswLimitationPeriod>
<EswStockLoanRateIndicator>
<xsl:value-of select="$EswStockLoanRateIndicator"/>
</EswStockLoanRateIndicator>
<EswMaximumStockLoanRate>
<xsl:value-of select="$EswMaximumStockLoanRate"/>
</EswMaximumStockLoanRate>
<EswInitialStockLoanRate>
<xsl:value-of select="$EswInitialStockLoanRate"/>
</EswInitialStockLoanRate>
<EswOptionalEarlyTermination>
<xsl:value-of select="$EswOptionalEarlyTermination"/>
</EswOptionalEarlyTermination>
<EswBreakFundingRecovery>
<xsl:value-of select="$EswBreakFundingRecovery"/>
</EswBreakFundingRecovery>
<EswBreakFeeElection>
<xsl:value-of select="$EswBreakFeeElection"/>
</EswBreakFeeElection>
<EswBreakFeeRate>
<xsl:value-of select="$EswBreakFeeRate"/>
</EswBreakFeeRate>
<EswFinalPriceFee>
<xsl:value-of select="$EswFinalPriceFee"/>
</EswFinalPriceFee>
<xsl:if test="$EswFinalPriceFeeAmount">
<EswFinalPriceFeeAmount>
<xsl:value-of select="$EswFinalPriceFeeAmount"/>
</EswFinalPriceFeeAmount>
</xsl:if>
<xsl:if test="$EswFinalPriceFeeCurrency">
<EswFinalPriceFeeCurrency>
<xsl:value-of select="$EswFinalPriceFeeCurrency"/>
</EswFinalPriceFeeCurrency>
</xsl:if>
<xsl:if test="$EswRightToIncrease">
<EswRightToIncrease>
<xsl:value-of select="$EswRightToIncrease"/>
</EswRightToIncrease>
</xsl:if>
<xsl:if test="$EswGrossPrice">
<EswGrossPrice>
<xsl:value-of select="$EswGrossPrice"/>
</EswGrossPrice>
</xsl:if>
<xsl:if test="$EswApplicableRegion">
<EswApplicableRegion>
<xsl:value-of select="$EswApplicableRegion"/>
</EswApplicableRegion>
</xsl:if>
<xsl:copy-of select="$EswDividendComponent"/>
<EswEarlyFinalValuationDateElection>
<xsl:value-of select="$EswEarlyFinalValuationDateElection"/>
</EswEarlyFinalValuationDateElection>
<xsl:copy-of select="$EswEarlyTerminationElectingParty"/>
<xsl:if test="$NoticePeriodPtyA">
<NoticePeriodPtyA>
<xsl:value-of select="$NoticePeriodPtyA"/>
</NoticePeriodPtyA>
</xsl:if>
<xsl:if test="$NoticePeriodPtyB">
<NoticePeriodPtyB>
<xsl:value-of select="$NoticePeriodPtyB"/>
</NoticePeriodPtyB>
</xsl:if>
<EswInsolvencyFiling>
<xsl:value-of select="$EswInsolvencyFiling"/>
</EswInsolvencyFiling>
<EswLossOfStockBorrow>
<xsl:value-of select="$EswLossOfStockBorrow"/>
</EswLossOfStockBorrow>
<EswIncreasedCostOfStockBorrow>
<xsl:value-of select="$EswIncreasedCostOfStockBorrow"/>
</EswIncreasedCostOfStockBorrow>
<EswBulletCompoundingSpread>
<xsl:value-of select="$EswBulletCompoundingSpread"/>
</EswBulletCompoundingSpread>
<EswSpecifiedExchange>
<xsl:value-of select="$EswSpecifiedExchange"/>
</EswSpecifiedExchange>
<EswCorporateActionFlag>
<xsl:value-of select="$EswCorporateActionFlag"/>
</EswCorporateActionFlag>
<xsl:if test="$sw2021ISDADefs">
<sw2021ISDADefs>
<xsl:value-of select="$sw2021ISDADefs"/>
</sw2021ISDADefs>
</xsl:if>
<xsl:if test="$EswChinaConnectFlag">
<EswChinaConnectFlag>
<xsl:value-of select="$EswChinaConnectFlag"/>
</EswChinaConnectFlag>
</xsl:if>
<xsl:copy-of select="$EswChinaConnect"/>
<xsl:if test="$EswEventId">
<EswEventId>
<xsl:value-of select="$EswEventId"/>
</EswEventId>
</xsl:if>
<xsl:if test="$EquityExchange">
<EquityExchange>
<xsl:value-of select="$EquityExchange"/>
</EquityExchange>
</xsl:if>
<xsl:if test="$EbsSubstitutionSelection">
<EbsSubstitutionSelection>
<xsl:value-of select="$EbsSubstitutionSelection"/>
</EbsSubstitutionSelection>
</xsl:if>
<xsl:if test="$EbsSubstitutionTrigger">
<EbsSubstitutionTrigger>
<xsl:value-of select="$EbsSubstitutionTrigger"/>
</EbsSubstitutionTrigger>
</xsl:if>
<xsl:if test="$EbsSubstitutionElectingParty">
<EbsSubstitutionElectingParty>
<xsl:value-of select="$EbsSubstitutionElectingParty"/>
</EbsSubstitutionElectingParty>
</xsl:if>
<xsl:if test="$EbsSubstitutionCriteria">
<EbsSubstitutionCriteria>
<xsl:value-of select="$EbsSubstitutionCriteria"/>
</EbsSubstitutionCriteria>
</xsl:if>
<xsl:copy-of select="$EbsEligibleIndexGrid"/>
<xsl:for-each select="$EbsRestrictedRegion">
<EbsRestrictedRegion>
<xsl:value-of select="."/>
</EbsRestrictedRegion>
</xsl:for-each>
<xsl:if test="$EbsRestrictedRegionMinPercent">
<EbsRestrictedRegionMinPercent>
<xsl:value-of select="$EbsRestrictedRegionMinPercent"/>
</EbsRestrictedRegionMinPercent>
</xsl:if>
<xsl:if test="$EbsRestrictedRegionMaxPercent">
<EbsRestrictedRegionMaxPercent>
<xsl:value-of select="$EbsRestrictedRegionMaxPercent"/>
</EbsRestrictedRegionMaxPercent>
</xsl:if>
<xsl:if test="$EbsSubstitutionAmount">
<EbsSubstitutionAmount>
<xsl:value-of select="$EbsSubstitutionAmount"/>
</EbsSubstitutionAmount>
</xsl:if>
<xsl:if test="$EbsSubstitutionAmountMinPercent">
<EbsSubstitutionAmountMinPercent>
<xsl:value-of select="$EbsSubstitutionAmountMinPercent"/>
</EbsSubstitutionAmountMinPercent>
</xsl:if>
<xsl:if test="$EbsSubstitutionAmountMaxPercent">
<EbsSubstitutionAmountMaxPercent>
<xsl:value-of select="$EbsSubstitutionAmountMaxPercent"/>
</EbsSubstitutionAmountMaxPercent>
</xsl:if>
<xsl:copy-of select="$EbsEligibleSectorGrid"/>
<xsl:if test="$EbsADTVDays">
<EbsADTVDays>
<xsl:value-of select="$EbsADTVDays"/>
</EbsADTVDays>
</xsl:if>
<xsl:if test="$EbsADTVPercentage">
<EbsADTVPercentage>
<xsl:value-of select="$EbsADTVPercentage"/>
</EbsADTVPercentage>
</xsl:if>
<xsl:if test="$SwapSideLetter">
<SwapSideLetter>
<xsl:value-of select="$SwapSideLetter"/>
</SwapSideLetter>
</xsl:if>
<xsl:if test="$SubstitutionSideLetter">
<SubstitutionSideLetter>
<xsl:value-of select="$SubstitutionSideLetter"/>
</SubstitutionSideLetter>
</xsl:if>
<xsl:copy-of select="$EbsGrid"/>
<NCCreditProductType>
<xsl:value-of select="$NCCreditProductType"/>
</NCCreditProductType>
<xsl:copy-of select="$NCIndivTradeSummary"/>
<NCNovationBlockID>
<xsl:value-of select="$NCNovationBlockID"/>
</NCNovationBlockID>
<NCNCMID>
<xsl:value-of select="$NCNCMID"/>
</NCNCMID>
<NCRPOldTRN>
<xsl:value-of select="$NCRPOldTRN"/>
</NCRPOldTRN>
<NCCEqualsCEligible>
<xsl:value-of select="$NCCEqualsCEligible"/>
</NCCEqualsCEligible>
<NCSummaryLinkID>
<xsl:value-of select="$NCSummaryLinkID"/>
</NCSummaryLinkID>
<xsl:if test="$MandatoryClearingIndicator">
<MandatoryClearingIndicator>
<xsl:value-of select="$MandatoryClearingIndicator"/>
</MandatoryClearingIndicator>
</xsl:if>
<xsl:if test="$MandatoryClearingHouseId">
<MandatoryClearingHouseId>
<xsl:value-of select="$MandatoryClearingHouseId"/>
</MandatoryClearingHouseId>
</xsl:if>
<xsl:if test="$MandatoryClearingHouseIdForUnderlyingSwap">
<MandatoryClearingHouseIdForUnderlyingSwap>
<xsl:value-of select="$MandatoryClearingHouseIdForUnderlyingSwap"/>
</MandatoryClearingHouseIdForUnderlyingSwap>
</xsl:if>
<NCORFundId>
<xsl:value-of select="$NCORFundId"/>
</NCORFundId>
<NCORFundName>
<xsl:value-of select="$NCORFundName"/>
</NCORFundName>
<NCRPFundId>
<xsl:value-of select="$NCRPFundId"/>
</NCRPFundId>
<NCRPFundName>
<xsl:value-of select="$NCRPFundName"/>
</NCRPFundName>
<NCEEFundId>
<xsl:value-of select="$NCEEFundId"/>
</NCEEFundId>
<NCEEFundName>
<xsl:value-of select="$NCEEFundName"/>
</NCEEFundName>
<NCRecoveryFactor>
<xsl:value-of select="$NCRecoveryFactor"/>
</NCRecoveryFactor>
<NCFixedSettlement>
<xsl:value-of select="$NCFixedSettlement"/>
</NCFixedSettlement>
<NCSwaptionDocsType>
<xsl:value-of select="$NCSwaptionDocsType"/>
</NCSwaptionDocsType>
<xsl:for-each select="$NCAdditionalMatrixProvision">
<NCAdditionalMatrixProvision>
<xsl:value-of select="."/>
</NCAdditionalMatrixProvision>
</xsl:for-each>
<NCSwaptionPublicationDate>
<xsl:value-of select="$NCSwaptionPublicationDate"/>
</NCSwaptionPublicationDate>
<NCOptionDirectionA>
<xsl:value-of select="$NCOptionDirectionA"/>
</NCOptionDirectionA>
<TIWDTCCTRI>
<xsl:value-of select="$TIWDTCCTRI"/>
</TIWDTCCTRI>
<TIWActiveStatus>
<xsl:value-of select="$TIWActiveStatus"/>
</TIWActiveStatus>
<TIWValueDate>
<xsl:value-of select="$TIWValueDate"/>
</TIWValueDate>
<TIWAsOfDate>
<xsl:value-of select="$TIWAsOfDate"/>
</TIWAsOfDate>
<xsl:if test="$CreditPTETradeDate">
<CreditPTETradeDate>
<xsl:value-of select="$CreditPTETradeDate"/>
</CreditPTETradeDate>
</xsl:if>
<xsl:if test="$CreditPTEEffectiveDate">
<CreditPTEEffectiveDate>
<xsl:value-of select="$CreditPTEEffectiveDate"/>
</CreditPTEEffectiveDate>
</xsl:if>
<xsl:if test="$CreditPTEFeePaymentDate">
<CreditPTEFeePaymentDate>
<xsl:value-of select="$CreditPTEFeePaymentDate"/>
</CreditPTEFeePaymentDate>
</xsl:if>
<xsl:if test="$CreditPTEFeePayer">
<CreditPTEFeePayer>
<xsl:value-of select="$CreditPTEFeePayer"/>
</CreditPTEFeePayer>
</xsl:if>
<xsl:if test="$CreditPTEFeeAmount">
<CreditPTEFeeAmount>
<xsl:value-of select="$CreditPTEFeeAmount"/>
</CreditPTEFeeAmount>
</xsl:if>
<xsl:if test="$CreditPTEFeeCurrency">
<CreditPTEFeeCurrency>
<xsl:value-of select="$CreditPTEFeeCurrency"/>
</CreditPTEFeeCurrency>
</xsl:if>
<EquityBackLoadingFlag>
<xsl:value-of select="$EquityBackLoadingFlag"/>
</EquityBackLoadingFlag>
<xsl:copy-of select="$MigrationReferences"/>
<Rule15A-6>
<xsl:value-of select="$Rule15A-6"/>
</Rule15A-6>
<xsl:copy-of select="$HedgingParty"/>
<xsl:copy-of select="$DeterminingParty"/>
<xsl:copy-of select="$CalculationAgent"/>
<xsl:copy-of select="$IndependentAmount2"/>
<NotionalFutureValue>
<xsl:value-of select="$NotionalFutureValue"/>
</NotionalFutureValue>
<xsl:copy-of select="$NotionalSchedule"/>
<SendForPublishing>
<xsl:value-of select="$SendForPublishing"/>
</SendForPublishing>
<SubscriberId>
<xsl:value-of select="$SubscriberId"/>
</SubscriberId>
<ModifiedEquityDelivery>
<xsl:value-of select="$ModifiedEquityDelivery"/>
</ModifiedEquityDelivery>
<SettledEntityMatrixSource>
<xsl:value-of select="$SettledEntityMatrixSource"/>
</SettledEntityMatrixSource>
<SettledEntityMatrixDate>
<xsl:value-of select="$SettledEntityMatrixDate"/>
</SettledEntityMatrixDate>
<AdditionalTerms>
<xsl:value-of select="$AdditionalTerms"/>
</AdditionalTerms>
<xsl:if test="$NovationInitiatedBy">
<NovationInitiatedBy>
<xsl:value-of select="$NovationInitiatedBy"/>
</NovationInitiatedBy>
</xsl:if>
<xsl:copy-of select="$ReportingData"/>
<xsl:copy-of select="$DFData"/>
<xsl:copy-of select="$JFSAData"/>
<xsl:copy-of select="$ESMAData"/>
<xsl:copy-of select="$HKMAData"/>
<xsl:copy-of select="$CAData"/>
<xsl:copy-of select="$SEData"/>
<xsl:copy-of select="$MIData"/>
<xsl:copy-of select="$ASICData"/>
<xsl:copy-of select="$MASData"/>
<xsl:copy-of select="$FCAData"/>
<xsl:if test="$MidMarketPriceType">
<MidMarketPriceType>
<xsl:value-of select="$MidMarketPriceType"/>
</MidMarketPriceType>
</xsl:if>
<xsl:if test="$MidMarketPriceValue">
<MidMarketPriceValue>
<xsl:value-of select="$MidMarketPriceValue"/>
</MidMarketPriceValue>
</xsl:if>
<xsl:if test="$MidMarketPriceCurrency">
<MidMarketPriceCurrency>
<xsl:value-of select="$MidMarketPriceCurrency"/>
</MidMarketPriceCurrency>
</xsl:if>
<xsl:if test="$IntentToBlankMidMarketCurrency">
<IntentToBlankMidMarketCurrency>
<xsl:value-of select="$IntentToBlankMidMarketCurrency"/>
</IntentToBlankMidMarketCurrency>
</xsl:if>
<xsl:if test="$IntentToBlankMidMarketPrice">
<IntentToBlankMidMarketPrice>
<xsl:value-of select="$IntentToBlankMidMarketPrice"/>
</IntentToBlankMidMarketPrice>
</xsl:if>
<xsl:if test="$NovationFeeMidMarketPriceType">
<NovationFeeMidMarketPriceType>
<xsl:value-of select="$NovationFeeMidMarketPriceType"/>
</NovationFeeMidMarketPriceType>
</xsl:if>
<xsl:if test="$NovationFeeMidMarketPriceValue">
<NovationFeeMidMarketPriceValue>
<xsl:value-of select="$NovationFeeMidMarketPriceValue"/>
</NovationFeeMidMarketPriceValue>
</xsl:if>
<xsl:if test="$NovationFeeMidMarketPriceCurrency">
<NovationFeeMidMarketPriceCurrency>
<xsl:value-of select="$NovationFeeMidMarketPriceCurrency"/>
</NovationFeeMidMarketPriceCurrency>
</xsl:if>
<xsl:if test="$NovationFeeIntentToBlankMidMarketCurrency">
<NovationFeeIntentToBlankMidMarketCurrency>
<xsl:value-of select="$NovationFeeIntentToBlankMidMarketCurrency"/>
</NovationFeeIntentToBlankMidMarketCurrency>
</xsl:if>
<xsl:if test="$NovationFeeIntentToBlankMidMarketPrice">
<NovationFeeIntentToBlankMidMarketPrice>
<xsl:value-of select="$NovationFeeIntentToBlankMidMarketPrice"/>
</NovationFeeIntentToBlankMidMarketPrice>
</xsl:if>
<xsl:if test="$DFEmbeddedOptionType">
<DFEmbeddedOptionType>
<xsl:value-of select="$DFEmbeddedOptionType"/>
</DFEmbeddedOptionType>
</xsl:if>
<xsl:if test="$GenProdPrimaryAssetClass">
<GenProdPrimaryAssetClass>
<xsl:value-of select="$GenProdPrimaryAssetClass"/>
</GenProdPrimaryAssetClass>
</xsl:if>
<xsl:if test="$GenProdSecondaryAssetClass">
<GenProdSecondaryAssetClass>
<xsl:value-of select="$GenProdSecondaryAssetClass"/>
</GenProdSecondaryAssetClass>
</xsl:if>
<xsl:if test="$ProductId">
<ProductId>
<xsl:value-of select="$ProductId"/>
</ProductId>
</xsl:if>
<xsl:if test="$OptionDirectionA">
<OptionDirectionA>
<xsl:value-of select="$OptionDirectionA"/>
</OptionDirectionA>
</xsl:if>
<xsl:if test="$OptionPremium">
<OptionPremium>
<xsl:value-of select="$OptionPremium"/>
</OptionPremium>
</xsl:if>
<xsl:if test="$OptionPremiumCurrency">
<OptionPremiumCurrency>
<xsl:value-of select="$OptionPremiumCurrency"/>
</OptionPremiumCurrency>
</xsl:if>
<xsl:if test="$OptionStrike">
<OptionStrike>
<xsl:value-of select="$OptionStrike"/>
</OptionStrike>
</xsl:if>
<xsl:if test="$OptionStrikeType">
<OptionStrikeType>
<xsl:value-of select="$OptionStrikeType"/>
</OptionStrikeType>
</xsl:if>
<xsl:if test="$OptionStrikeCurrency">
<OptionStrikeCurrency>
<xsl:value-of select="$OptionStrikeCurrency"/>
</OptionStrikeCurrency>
</xsl:if>
<xsl:if test="$FirstExerciseDate">
<FirstExerciseDate>
<xsl:value-of select="$FirstExerciseDate"/>
</FirstExerciseDate>
</xsl:if>
<xsl:if test="$FloatingDayCountConvention">
<FloatingDayCountConvention>
<xsl:value-of select="$FloatingDayCountConvention"/>
</FloatingDayCountConvention>
</xsl:if>
<xsl:if test="$DayCountConvention">
<DayCountConvention>
<xsl:value-of select="$DayCountConvention"/>
</DayCountConvention>
</xsl:if>
<xsl:copy-of select="$GenProdUnderlyer"/>
<xsl:copy-of select="$GenProdNotional"/>
<xsl:if test="$ResetFrequency">
<ResetFrequency>
<xsl:value-of select="$ResetFrequency"/>
</ResetFrequency>
</xsl:if>
<xsl:copy-of select="$DayCountFraction"/>
<xsl:copy-of select="$OrderDetails"/>
<xsl:copy-of select="$ClearingDetails"/>
<xsl:if test="$NettingBatchId">
<NettingBatchId>
<xsl:value-of select="$NettingBatchId"/>
</NettingBatchId>
</xsl:if>
<xsl:if test="$PrivateClearingTradeID">
<PrivateClearingTradeID>
<xsl:value-of select="$PrivateClearingTradeID"/>
</PrivateClearingTradeID>
</xsl:if>
<xsl:if test="$NettingSequenceNumber">
<NettingSequenceNumber>
<xsl:value-of select="$NettingSequenceNumber"/>
</NettingSequenceNumber>
</xsl:if>
<xsl:if test="$ExecutionTime">
<ExecutionTime>
<xsl:value-of select="$ExecutionTime"/>
</ExecutionTime>
</xsl:if>
<xsl:if test="$BulkEventID">
<BulkEventID>
<xsl:value-of select="$BulkEventID"/>
</BulkEventID>
</xsl:if>
<xsl:if test="$NettingString">
<NettingString>
<xsl:value-of select="$NettingString"/>
</NettingString>
</xsl:if>
<xsl:if test="$NettingLinkedTradeID">
<NettingLinkedTradeID>
<xsl:value-of select="$NettingLinkedTradeID"/>
</NettingLinkedTradeID>
</xsl:if>
<xsl:if test="$NettingLinkedCCPID">
<NettingLinkedCCPID>
<xsl:value-of select="$NettingLinkedCCPID"/>
</NettingLinkedCCPID>
</xsl:if>
<xsl:copy-of select="$LinkedTradeDetails"/>
<DurationType>
<xsl:value-of select="$DurationType"/>
</DurationType>
<RateCalcType>
<xsl:value-of select="$RateCalcType"/>
</RateCalcType>
<SecurityType>
<xsl:value-of select="$SecurityType"/>
</SecurityType>
<OpenRepoRate>
<xsl:value-of select="$OpenRepoRate"/>
</OpenRepoRate>
<OpenRepoSpread>
<xsl:value-of select="$OpenRepoSpread"/>
</OpenRepoSpread>
<OpenCashAmount>
<xsl:value-of select="$OpenCashAmount"/>
</OpenCashAmount>
<OpenDeliveryMethod>
<xsl:value-of select="$OpenDeliveryMethod"/>
</OpenDeliveryMethod>
<OpenSecurityNominal>
<xsl:value-of select="$OpenSecurityNominal"/>
</OpenSecurityNominal>
<OpenSecurityQuantity>
<xsl:value-of select="$OpenSecurityQuantity"/>
</OpenSecurityQuantity>
<xsl:if test="$CloseCashAmount">
<CloseCashAmount>
<xsl:value-of select="$CloseCashAmount"/>
</CloseCashAmount>
</xsl:if>
<CloseDeliveryMethod>
<xsl:value-of select="$CloseDeliveryMethod"/>
</CloseDeliveryMethod>
<CloseSecurityNominal>
<xsl:value-of select="$CloseSecurityNominal"/>
</CloseSecurityNominal>
<CloseSecurityQuantity>
<xsl:value-of select="$CloseSecurityQuantity"/>
</CloseSecurityQuantity>
<DayCountBasis>
<xsl:value-of select="$DayCountBasis"/>
</DayCountBasis>
<xsl:if test="$Haircut">
<Haircut>
<xsl:value-of select="$Haircut"/>
</Haircut>
</xsl:if>
<xsl:if test="$InitialMargin">
<InitialMargin>
<xsl:value-of select="$InitialMargin"/>
</InitialMargin>
</xsl:if>
<SecurityIDType>
<xsl:value-of select="$SecurityIDType"/>
</SecurityIDType>
<SecurityID>
<xsl:value-of select="$SecurityID"/>
</SecurityID>
<xsl:if test="$SecurityDescription">
<SecurityDescription>
<xsl:value-of select="$SecurityDescription"/>
</SecurityDescription>
</xsl:if>
<SecurityCurrency>
<xsl:value-of select="$SecurityCurrency"/>
</SecurityCurrency>
<xsl:if test="$ExtensionStyle">
<ExtensionStyle>
<xsl:value-of select="$ExtensionStyle"/>
</ExtensionStyle>
</xsl:if>
<xsl:if test="$ExtensionPeriod">
<ExtensionPeriod>
<xsl:value-of select="$ExtensionPeriod"/>
</ExtensionPeriod>
</xsl:if>
<xsl:if test="$ExtensionPeriodUnits">
<ExtensionPeriodUnits>
<xsl:value-of select="$ExtensionPeriodUnits"/>
</ExtensionPeriodUnits>
</xsl:if>
<xsl:if test="$CallingParty">
<CallingParty>
<xsl:value-of select="$CallingParty"/>
</CallingParty>
</xsl:if>
<xsl:if test="$CallDate">
<CallDate>
<xsl:value-of select="$CallDate"/>
</CallDate>
</xsl:if>
<xsl:if test="$CallNoticePeriod">
<CallNoticePeriod>
<xsl:value-of select="$CallNoticePeriod"/>
</CallNoticePeriod>
</xsl:if>
</SWDMLTrade>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.Allocation">
<xsl:param name="DirectionReversed" select="/.."/>
<xsl:param name="Payer" select="/.."/>
<xsl:param name="Receiver" select="/.."/>
<xsl:param name="Buyer" select="/.."/>
<xsl:param name="Seller" select="/.."/>
<xsl:param name="Amount" select="/.."/>
<xsl:param name="ContraAmount" select="/.."/>
<xsl:param name="VariableAmount" select="/.."/>
<xsl:param name="Currency" select="/.."/>
<xsl:param name="ZCAllocAmount" select="/.."/>
<xsl:param name="ContraZCAllocAmount" select="/.."/>
<xsl:param name="AllocatedVarianceAmount" select="/.."/>
<xsl:param name="IAExpected" select="/.."/>
<xsl:param name="GlobalUTI" select="/.."/>
<xsl:param name="IndependentAmount" select="/.."/>
<xsl:param name="AllocationIndependentAmountPercentage" select="/.."/>
<xsl:param name="AllocCancellablePremiumAmount" select="/.."/>
<xsl:param name="AllocAdditionalPayment" select="/.."/>
<xsl:param name="AllocOpenSecurityNominal" select="/.."/>
<xsl:param name="AllocOpenSecurityQuantity" select="/.."/>
<xsl:param name="AllocGlobalUTI" select="/.."/>
<xsl:param name="InternalTradeId" select="/.."/>
<xsl:param name="SalesCredit" select="/.."/>
<xsl:param name="AllocOriginator" select="/.."/>
<xsl:param name="AllocPlaceofSettleID" select="/.."/>
<xsl:param name="AllocSettleAgentID" select="/.."/>
<xsl:param name="AllocSettleAgentSafekeepAC" select="/.."/>
<xsl:param name="AllocIntermediaryID" select="/.."/>
<xsl:param name="AllocIntermediarySafekeepAC" select="/.."/>
<xsl:param name="AllocCustodianID" select="/.."/>
<xsl:param name="AllocCustodianSafekeepAC" select="/.."/>
<xsl:param name="AllocBuyerSellerID" select="/.."/>
<xsl:param name="AllocBuyerSellerSafekeepAC" select="/.."/>
<xsl:param name="AdditionalField" select="/.."/>
<xsl:param name="ClearingBrokerId" select="/.."/>
<xsl:param name="NettingString" select="/.."/>
<xsl:param name="ObligatoryReporting" select="/.."/>
<xsl:param name="ReportingCounterparty" select="/.."/>
<xsl:param name="USINamespace" select="/.."/>
<xsl:param name="USI" select="/.."/>
<xsl:param name="SEObligatoryReporting" select="/.."/>
<xsl:param name="SEReportingCounterparty" select="/.."/>
<xsl:param name="SEUSINamespace" select="/.."/>
<xsl:param name="SEUSI" select="/.."/>
<xsl:param name="ESMAUTINamespace" select="/.."/>
<xsl:param name="ESMAIntentToBlankUTINamespace" select="/.."/>
<xsl:param name="ESMAUTI" select="/.."/>
<xsl:param name="ESMAIntentToBlankUTI" select="/.."/>
<xsl:param name="ESMAReportForCpty" select="/.."/>
<xsl:param name="FCAUTINamespace" select="/.."/>
<xsl:param name="FCAIntentToBlankUTINamespace" select="/.."/>
<xsl:param name="FCAUTI" select="/.."/>
<xsl:param name="FCAIntentToBlankUTI" select="/.."/>
<xsl:param name="FCAReportForCpty" select="/.."/>
<xsl:param name="JFSAUTINamespace" select="/.."/>
<xsl:param name="JFSAIntentToBlankUTINamespace" select="/.."/>
<xsl:param name="JFSAUTI" select="/.."/>
<xsl:param name="JFSAIntentToBlankUTI" select="/.."/>
<xsl:param name="HKMAUTINamespace" select="/.."/>
<xsl:param name="HKMAIntentToBlankUTINamespace" select="/.."/>
<xsl:param name="HKMAUTI" select="/.."/>
<xsl:param name="HKMAIntentToBlankUTI" select="/.."/>
<xsl:param name="CAObligatoryReporting" select="/.."/>
<xsl:param name="CAReportingCounterparty" select="/.."/>
<xsl:param name="CAUTINamespace" select="/.."/>
<xsl:param name="CAIntentToBlankUTINamespace" select="/.."/>
<xsl:param name="CAUTI" select="/.."/>
<xsl:param name="CAIntentToBlankUTI" select="/.."/>
<xsl:param name="MIObligatoryReporting" select="/.."/>
<xsl:param name="MIReportingCounterparty" select="/.."/>
<xsl:param name="MITID" select="/.."/>
<xsl:param name="MIIntentToBlankTID" select="/.."/>
<xsl:param name="MITransactionReportable" select="/.."/>
<xsl:param name="MITransparencyReportable" select="/.."/>
<xsl:param name="ASICUTINamespace" select="/.."/>
<xsl:param name="ASICIntentToBlankUTINamespace" select="/.."/>
<xsl:param name="ASICUTI" select="/.."/>
<xsl:param name="ASICIntentToBlankUTI" select="/.."/>
<xsl:param name="MASUTINamespace" select="/.."/>
<xsl:param name="MASIntentToBlankUTINamespace" select="/.."/>
<xsl:param name="MASUTI" select="/.."/>
<xsl:param name="MASIntentToBlankUTI" select="/.."/>
<xsl:param name="ClearingDetails" select="/.."/>
<xsl:param name="PartyIdentifiers" select="/.."/>
<xsl:param name="NexusReportingDetails" select="/.."/>
<xsl:param name="CounterpartyCorporateSector" select="/.."/>
<Allocation>
<DirectionReversed>
<xsl:value-of select="$DirectionReversed"/>
</DirectionReversed>
<xsl:choose>
<xsl:when test="false() or $Payer or $Receiver">
<Payer>
<xsl:value-of select="$Payer"/>
</Payer>
<Receiver>
<xsl:value-of select="$Receiver"/>
</Receiver>
</xsl:when>
<xsl:when test="false() or $Buyer or $Seller">
<Buyer>
<xsl:value-of select="$Buyer"/>
</Buyer>
<Seller>
<xsl:value-of select="$Seller"/>
</Seller>
</xsl:when>
<xsl:otherwise>
<xsl:message terminate="yes">No element specified for choice.</xsl:message>
</xsl:otherwise>
</xsl:choose>
<xsl:if test="$Amount">
<Amount>
<xsl:value-of select="$Amount"/>
</Amount>
</xsl:if>
<xsl:if test="$ContraAmount">
<ContraAmount>
<xsl:value-of select="$ContraAmount"/>
</ContraAmount>
</xsl:if>
<xsl:if test="$VariableAmount">
<VariableAmount>
<xsl:value-of select="$VariableAmount"/>
</VariableAmount>
</xsl:if>
<xsl:if test="$Currency">
<Currency>
<xsl:value-of select="$Currency"/>
</Currency>
</xsl:if>
<xsl:if test="$ZCAllocAmount">
<ZCAllocAmount>
<xsl:value-of select="$ZCAllocAmount"/>
</ZCAllocAmount>
</xsl:if>
<xsl:if test="$ContraZCAllocAmount">
<ContraZCAllocAmount>
<xsl:value-of select="$ContraZCAllocAmount"/>
</ContraZCAllocAmount>
</xsl:if>
<xsl:if test="$AllocatedVarianceAmount">
<AllocatedVarianceAmount>
<xsl:value-of select="$AllocatedVarianceAmount"/>
</AllocatedVarianceAmount>
</xsl:if>
<xsl:if test="$IAExpected">
<IAExpected>
<xsl:value-of select="$IAExpected"/>
</IAExpected>
</xsl:if>
<xsl:if test="$GlobalUTI">
<GlobalUTI>
<xsl:value-of select="$GlobalUTI"/>
</GlobalUTI>
</xsl:if>
<xsl:copy-of select="$IndependentAmount"/>
<xsl:copy-of select="$AllocationIndependentAmountPercentage"/>
<xsl:if test="$AllocCancellablePremiumAmount">
<AllocCancellablePremiumAmount>
<xsl:value-of select="$AllocCancellablePremiumAmount"/>
</AllocCancellablePremiumAmount>
</xsl:if>
<xsl:copy-of select="$AllocAdditionalPayment"/>
<xsl:if test="$AllocOpenSecurityNominal">
<AllocOpenSecurityNominal>
<xsl:value-of select="$AllocOpenSecurityNominal"/>
</AllocOpenSecurityNominal>
</xsl:if>
<xsl:if test="$AllocOpenSecurityQuantity">
<AllocOpenSecurityQuantity>
<xsl:value-of select="$AllocOpenSecurityQuantity"/>
</AllocOpenSecurityQuantity>
</xsl:if>
<xsl:if test="$AllocGlobalUTI">
<AllocGlobalUTI>
<xsl:value-of select="$AllocGlobalUTI"/>
</AllocGlobalUTI>
</xsl:if>
<xsl:if test="$InternalTradeId">
<InternalTradeId>
<xsl:value-of select="$InternalTradeId"/>
</InternalTradeId>
</xsl:if>
<xsl:if test="$SalesCredit">
<SalesCredit>
<xsl:value-of select="$SalesCredit"/>
</SalesCredit>
</xsl:if>
<xsl:copy-of select="$AdditionalField"/>
<xsl:if test="$ClearingBrokerId">
<ClearingBrokerId>
<xsl:value-of select="$ClearingBrokerId"/>
</ClearingBrokerId>
</xsl:if>
<xsl:if test="$NettingString">
<NettingString>
<xsl:value-of select="$NettingString"/>
</NettingString>
</xsl:if>
<xsl:if test="$ObligatoryReporting">
<ObligatoryReporting>
<xsl:value-of select="$ObligatoryReporting"/>
</ObligatoryReporting>
</xsl:if>
<xsl:if test="$ReportingCounterparty">
<ReportingCounterparty>
<xsl:value-of select="$ReportingCounterparty"/>
</ReportingCounterparty>
</xsl:if>
<xsl:if test="$USINamespace">
<USINamespace>
<xsl:value-of select="$USINamespace"/>
</USINamespace>
</xsl:if>
<xsl:if test="$USI">
<USI>
<xsl:value-of select="$USI"/>
</USI>
</xsl:if>
<xsl:if test="$SEObligatoryReporting">
<SEObligatoryReporting>
<xsl:value-of select="$SEObligatoryReporting"/>
</SEObligatoryReporting>
</xsl:if>
<xsl:if test="$SEReportingCounterparty">
<SEReportingCounterparty>
<xsl:value-of select="$SEReportingCounterparty"/>
</SEReportingCounterparty>
</xsl:if>
<xsl:if test="$SEUSINamespace">
<SEUSINamespace>
<xsl:value-of select="$SEUSINamespace"/>
</SEUSINamespace>
</xsl:if>
<xsl:if test="$SEUSI">
<SEUSI>
<xsl:value-of select="$SEUSI"/>
</SEUSI>
</xsl:if>
<xsl:if test="$ESMAUTINamespace">
<ESMAUTINamespace>
<xsl:value-of select="$ESMAUTINamespace"/>
</ESMAUTINamespace>
</xsl:if>
<xsl:if test="$ESMAIntentToBlankUTINamespace">
<ESMAIntentToBlankUTINamespace>
<xsl:value-of select="$ESMAIntentToBlankUTINamespace"/>
</ESMAIntentToBlankUTINamespace>
</xsl:if>
<xsl:if test="$ESMAUTI">
<ESMAUTI>
<xsl:value-of select="$ESMAUTI"/>
</ESMAUTI>
</xsl:if>
<xsl:if test="$ESMAIntentToBlankUTI">
<ESMAIntentToBlankUTI>
<xsl:value-of select="$ESMAIntentToBlankUTI"/>
</ESMAIntentToBlankUTI>
</xsl:if>
<xsl:if test="$ESMAReportForCpty">
<ESMAReportForCpty>
<xsl:value-of select="$ESMAReportForCpty"/>
</ESMAReportForCpty>
</xsl:if>
<xsl:if test="$FCAUTINamespace">
<FCAUTINamespace>
<xsl:value-of select="$FCAUTINamespace"/>
</FCAUTINamespace>
</xsl:if>
<xsl:if test="$FCAIntentToBlankUTINamespace">
<FCAIntentToBlankUTINamespace>
<xsl:value-of select="$FCAIntentToBlankUTINamespace"/>
</FCAIntentToBlankUTINamespace>
</xsl:if>
<xsl:if test="$FCAUTI">
<FCAUTI>
<xsl:value-of select="$FCAUTI"/>
</FCAUTI>
</xsl:if>
<xsl:if test="$FCAIntentToBlankUTI">
<FCAIntentToBlankUTI>
<xsl:value-of select="$FCAIntentToBlankUTI"/>
</FCAIntentToBlankUTI>
</xsl:if>
<xsl:if test="$FCAReportForCpty">
<FCAReportForCpty>
<xsl:value-of select="$FCAReportForCpty"/>
</FCAReportForCpty>
</xsl:if>
<xsl:if test="$JFSAUTINamespace">
<JFSAUTINamespace>
<xsl:value-of select="$JFSAUTINamespace"/>
</JFSAUTINamespace>
</xsl:if>
<xsl:if test="$JFSAIntentToBlankUTINamespace">
<JFSAIntentToBlankUTINamespace>
<xsl:value-of select="$JFSAIntentToBlankUTINamespace"/>
</JFSAIntentToBlankUTINamespace>
</xsl:if>
<xsl:if test="$JFSAUTI">
<JFSAUTI>
<xsl:value-of select="$JFSAUTI"/>
</JFSAUTI>
</xsl:if>
<xsl:if test="$JFSAIntentToBlankUTI">
<JFSAIntentToBlankUTI>
<xsl:value-of select="$JFSAIntentToBlankUTI"/>
</JFSAIntentToBlankUTI>
</xsl:if>
<xsl:if test="$HKMAUTINamespace">
<HKMAUTINamespace>
<xsl:value-of select="$HKMAUTINamespace"/>
</HKMAUTINamespace>
</xsl:if>
<xsl:if test="$HKMAIntentToBlankUTINamespace">
<HKMAIntentToBlankUTINamespace>
<xsl:value-of select="$HKMAIntentToBlankUTINamespace"/>
</HKMAIntentToBlankUTINamespace>
</xsl:if>
<xsl:if test="$HKMAUTI">
<HKMAUTI>
<xsl:value-of select="$HKMAUTI"/>
</HKMAUTI>
</xsl:if>
<xsl:if test="$HKMAIntentToBlankUTI">
<HKMAIntentToBlankUTI>
<xsl:value-of select="$HKMAIntentToBlankUTI"/>
</HKMAIntentToBlankUTI>
</xsl:if>
<xsl:if test="$CAObligatoryReporting">
<CAObligatoryReporting>
<xsl:value-of select="$CAObligatoryReporting"/>
</CAObligatoryReporting>
</xsl:if>
<xsl:if test="$CAReportingCounterparty">
<CAReportingCounterparty>
<xsl:value-of select="$CAReportingCounterparty"/>
</CAReportingCounterparty>
</xsl:if>
<xsl:if test="$CAUTINamespace">
<CAUTINamespace>
<xsl:value-of select="$CAUTINamespace"/>
</CAUTINamespace>
</xsl:if>
<xsl:if test="$CAIntentToBlankUTINamespace">
<CAIntentToBlankUTINamespace>
<xsl:value-of select="$CAIntentToBlankUTINamespace"/>
</CAIntentToBlankUTINamespace>
</xsl:if>
<xsl:if test="$CAUTI">
<CAUTI>
<xsl:value-of select="$CAUTI"/>
</CAUTI>
</xsl:if>
<xsl:if test="$CAIntentToBlankUTI">
<CAIntentToBlankUTI>
<xsl:value-of select="$CAIntentToBlankUTI"/>
</CAIntentToBlankUTI>
</xsl:if>
<xsl:if test="$MIObligatoryReporting">
<MIObligatoryReporting>
<xsl:value-of select="$MIObligatoryReporting"/>
</MIObligatoryReporting>
</xsl:if>
<xsl:if test="$MIReportingCounterparty">
<MIReportingCounterparty>
<xsl:value-of select="$MIReportingCounterparty"/>
</MIReportingCounterparty>
</xsl:if>
<xsl:if test="$MITID">
<MITID>
<xsl:value-of select="$MITID"/>
</MITID>
</xsl:if>
<xsl:if test="$MIIntentToBlankTID">
<MIIntentToBlankTID>
<xsl:value-of select="$MIIntentToBlankTID"/>
</MIIntentToBlankTID>
</xsl:if>
<xsl:if test="$MITransactionReportable">
<MITransactionReportable>
<xsl:value-of select="$MITransactionReportable"/>
</MITransactionReportable>
</xsl:if>
<xsl:if test="$MITransparencyReportable">
<MITransparencyReportable>
<xsl:value-of select="$MITransparencyReportable"/>
</MITransparencyReportable>
</xsl:if>
<xsl:if test="$ASICUTINamespace">
<ASICUTINamespace>
<xsl:value-of select="$ASICUTINamespace"/>
</ASICUTINamespace>
</xsl:if>
<xsl:if test="$ASICIntentToBlankUTINamespace">
<ASICIntentToBlankUTINamespace>
<xsl:value-of select="$ASICIntentToBlankUTINamespace"/>
</ASICIntentToBlankUTINamespace>
</xsl:if>
<xsl:if test="$ASICUTI">
<ASICUTI>
<xsl:value-of select="$ASICUTI"/>
</ASICUTI>
</xsl:if>
<xsl:if test="$ASICIntentToBlankUTI">
<ASICIntentToBlankUTI>
<xsl:value-of select="$ASICIntentToBlankUTI"/>
</ASICIntentToBlankUTI>
</xsl:if>
<xsl:if test="$MASUTINamespace">
<MASUTINamespace>
<xsl:value-of select="$MASUTINamespace"/>
</MASUTINamespace>
</xsl:if>
<xsl:if test="$MASIntentToBlankUTINamespace">
<MASIntentToBlankUTINamespace>
<xsl:value-of select="$MASIntentToBlankUTINamespace"/>
</MASIntentToBlankUTINamespace>
</xsl:if>
<xsl:if test="$MASUTI">
<MASUTI>
<xsl:value-of select="$MASUTI"/>
</MASUTI>
</xsl:if>
<xsl:if test="$MASIntentToBlankUTI">
<MASIntentToBlankUTI>
<xsl:value-of select="$MASIntentToBlankUTI"/>
</MASIntentToBlankUTI>
</xsl:if>
<xsl:copy-of select="$ClearingDetails"/>
<xsl:copy-of select="$PartyIdentifiers"/>
<xsl:copy-of select="$NexusReportingDetails"/>
<xsl:if test="$CounterpartyCorporateSector">
<CounterpartyCorporateSector>
<xsl:value-of select="$CounterpartyCorporateSector"/>
</CounterpartyCorporateSector>
</xsl:if>
</Allocation>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.Allocation.IndependentAmount">
<xsl:param name="Amount" select="/.."/>
<IndependentAmount>
<Amount>
<xsl:value-of select="$Amount"/>
</Amount>
</IndependentAmount>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.Allocation.AllocationIndependentAmountPercentage">
<xsl:param name="Payer" select="/.."/>
<xsl:param name="Receiver" select="/.."/>
<xsl:param name="Currency" select="/.."/>
<xsl:param name="Percentage" select="/.."/>
<AllocationIndependentAmountPercentage>
<Payer>
<xsl:value-of select="$Payer"/>
</Payer>
<Receiver>
<xsl:value-of select="$Receiver"/>
</Receiver>
<Currency>
<xsl:value-of select="$Currency"/>
</Currency>
<Percentage>
<xsl:value-of select="$Percentage"/>
</Percentage>
</AllocationIndependentAmountPercentage>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.Allocation.AllocAdditionalPayment">
<xsl:param name="AddPaySequence" select="/.."/>
<xsl:param name="DirectionReversed" select="/.."/>
<xsl:param name="Amount" select="/.."/>
<AllocAdditionalPayment>
<AddPaySequence>
<xsl:value-of select="$AddPaySequence"/>
</AddPaySequence>
<DirectionReversed>
<xsl:value-of select="$DirectionReversed"/>
</DirectionReversed>
<Amount>
<xsl:value-of select="$Amount"/>
</Amount>
</AllocAdditionalPayment>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.Allocation.AdditionalField">
<xsl:param name="Name" select="/.."/>
<xsl:param name="Sequence" select="/.."/>
<xsl:param name="Value" select="/.."/>
<AdditionalField>
<Name>
<xsl:value-of select="$Name"/>
</Name>
<Sequence>
<xsl:value-of select="$Sequence"/>
</Sequence>
<Value>
<xsl:value-of select="$Value"/>
</Value>
</AdditionalField>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.Allocation.ClearingDetails">
<xsl:param name="ClearingStatus" select="/.."/>
<xsl:param name="ClearingHouseTradeID" select="/.."/>
<xsl:param name="ClearedTimestamp" select="/.."/>
<xsl:param name="ClearedUSINamespace" select="/.."/>
<xsl:param name="ClearedUSI" select="/.."/>
<xsl:param name="ClearedUTINamespace" select="/.."/>
<xsl:param name="ClearedUTI" select="/.."/>
<ClearingDetails>
<xsl:if test="$ClearingStatus">
<ClearingStatus>
<xsl:value-of select="$ClearingStatus"/>
</ClearingStatus>
</xsl:if>
<xsl:if test="$ClearingHouseTradeID">
<ClearingHouseTradeID>
<xsl:value-of select="$ClearingHouseTradeID"/>
</ClearingHouseTradeID>
</xsl:if>
<xsl:if test="$ClearedTimestamp">
<ClearedTimestamp>
<xsl:value-of select="$ClearedTimestamp"/>
</ClearedTimestamp>
</xsl:if>
<xsl:if test="$ClearedUSINamespace">
<ClearedUSINamespace>
<xsl:value-of select="$ClearedUSINamespace"/>
</ClearedUSINamespace>
</xsl:if>
<xsl:if test="$ClearedUSI">
<ClearedUSI>
<xsl:value-of select="$ClearedUSI"/>
</ClearedUSI>
</xsl:if>
<xsl:if test="$ClearedUTINamespace">
<ClearedUTINamespace>
<xsl:value-of select="$ClearedUTINamespace"/>
</ClearedUTINamespace>
</xsl:if>
<xsl:if test="$ClearedUTI">
<ClearedUTI>
<xsl:value-of select="$ClearedUTI"/>
</ClearedUTI>
</xsl:if>
</ClearingDetails>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.Allocation.PartyIdentifiers">
<xsl:param name="CounterpartyLEI" select="/.."/>
<xsl:param name="CounterpartyPLI" select="/.."/>
<xsl:param name="DataMaskingFlag" select="/.."/>
<PartyIdentifiers>
<xsl:if test="$CounterpartyLEI">
<CounterpartyLEI>
<xsl:value-of select="$CounterpartyLEI"/>
</CounterpartyLEI>
</xsl:if>
<xsl:if test="$CounterpartyPLI">
<CounterpartyPLI>
<xsl:value-of select="$CounterpartyPLI"/>
</CounterpartyPLI>
</xsl:if>
<xsl:copy-of select="$DataMaskingFlag"/>
</PartyIdentifiers>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.Allocation.PartyIdentifiers.DataMaskingFlag">
<xsl:param name="MaskCFTC" select="/.."/>
<xsl:param name="MaskJFSA" select="/.."/>
<xsl:param name="MaskCanada" select="/.."/>
<xsl:param name="MaskHKMA" select="/.."/>
<xsl:param name="MaskASIC" select="/.."/>
<xsl:param name="MaskMAS" select="/.."/>
<DataMaskingFlag>
<xsl:if test="$MaskCFTC">
<MaskCFTC>
<xsl:value-of select="$MaskCFTC"/>
</MaskCFTC>
</xsl:if>
<xsl:if test="$MaskJFSA">
<MaskJFSA>
<xsl:value-of select="$MaskJFSA"/>
</MaskJFSA>
</xsl:if>
<xsl:if test="$MaskCanada">
<MaskCanada>
<xsl:value-of select="$MaskCanada"/>
</MaskCanada>
</xsl:if>
<xsl:if test="$MaskHKMA">
<MaskHKMA>
<xsl:value-of select="$MaskHKMA"/>
</MaskHKMA>
</xsl:if>
<xsl:if test="$MaskASIC">
<MaskASIC>
<xsl:value-of select="$MaskASIC"/>
</MaskASIC>
</xsl:if>
<xsl:if test="$MaskMAS">
<MaskMAS>
<xsl:value-of select="$MaskMAS"/>
</MaskMAS>
</xsl:if>
</DataMaskingFlag>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.Allocation.NexusReportingDetails">
<xsl:param name="ExecutingTraderName" select="/.."/>
<xsl:param name="SalesTraderName" select="/.."/>
<xsl:param name="InvestFirmName" select="/.."/>
<xsl:param name="BranchLocation" select="/.."/>
<xsl:param name="DeskLocation" select="/.."/>
<xsl:param name="ExecutingTraderLocation" select="/.."/>
<xsl:param name="SalesTraderLocation" select="/.."/>
<xsl:param name="InvestFirmLocation" select="/.."/>
<xsl:param name="BrokerLocation" select="/.."/>
<xsl:param name="ArrBrokerLocation" select="/.."/>
<NexusReportingDetails>
<xsl:if test="$ExecutingTraderName">
<ExecutingTraderName>
<xsl:value-of select="$ExecutingTraderName"/>
</ExecutingTraderName>
</xsl:if>
<xsl:if test="$SalesTraderName">
<SalesTraderName>
<xsl:value-of select="$SalesTraderName"/>
</SalesTraderName>
</xsl:if>
<xsl:if test="$InvestFirmName">
<InvestFirmName>
<xsl:value-of select="$InvestFirmName"/>
</InvestFirmName>
</xsl:if>
<xsl:if test="$BranchLocation">
<BranchLocation>
<xsl:value-of select="$BranchLocation"/>
</BranchLocation>
</xsl:if>
<xsl:if test="$DeskLocation">
<DeskLocation>
<xsl:value-of select="$DeskLocation"/>
</DeskLocation>
</xsl:if>
<xsl:if test="$ExecutingTraderLocation">
<ExecutingTraderLocation>
<xsl:value-of select="$ExecutingTraderLocation"/>
</ExecutingTraderLocation>
</xsl:if>
<xsl:if test="$SalesTraderLocation">
<SalesTraderLocation>
<xsl:value-of select="$SalesTraderLocation"/>
</SalesTraderLocation>
</xsl:if>
<xsl:if test="$InvestFirmLocation">
<InvestFirmLocation>
<xsl:value-of select="$InvestFirmLocation"/>
</InvestFirmLocation>
</xsl:if>
<xsl:if test="$BrokerLocation">
<BrokerLocation>
<xsl:value-of select="$BrokerLocation"/>
</BrokerLocation>
</xsl:if>
<xsl:if test="$ArrBrokerLocation">
<ArrBrokerLocation>
<xsl:value-of select="$ArrBrokerLocation"/>
</ArrBrokerLocation>
</xsl:if>
</NexusReportingDetails>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.PartyAId">
<xsl:param name="content"/>
<xsl:param name="id" select="/.."/>
<PartyAId>
<xsl:if test="$id">
<xsl:attribute name="id">
<xsl:value-of select="$id"/>
</xsl:attribute>
</xsl:if>
<xsl:value-of select="$content"/>
</PartyAId>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.PartyBId">
<xsl:param name="content"/>
<xsl:param name="id" select="/.."/>
<PartyBId>
<xsl:if test="$id">
<xsl:attribute name="id">
<xsl:value-of select="$id"/>
</xsl:attribute>
</xsl:if>
<xsl:value-of select="$content"/>
</PartyBId>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.PartyCId">
<xsl:param name="content"/>
<xsl:param name="id" select="/.."/>
<PartyCId>
<xsl:if test="$id">
<xsl:attribute name="id">
<xsl:value-of select="$id"/>
</xsl:attribute>
</xsl:if>
<xsl:value-of select="$content"/>
</PartyCId>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.PartyDId">
<xsl:param name="content"/>
<xsl:param name="id" select="/.."/>
<PartyDId>
<xsl:if test="$id">
<xsl:attribute name="id">
<xsl:value-of select="$id"/>
</xsl:attribute>
</xsl:if>
<xsl:value-of select="$content"/>
</PartyDId>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.PartyGId">
<xsl:param name="content"/>
<xsl:param name="id" select="/.."/>
<PartyGId>
<xsl:if test="$id">
<xsl:attribute name="id">
<xsl:value-of select="$id"/>
</xsl:attribute>
</xsl:if>
<xsl:value-of select="$content"/>
</PartyGId>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.PartyTripartyAgentId">
<xsl:param name="content"/>
<xsl:param name="id" select="/.."/>
<PartyTripartyAgentId>
<xsl:if test="$id">
<xsl:attribute name="id">
<xsl:value-of select="$id"/>
</xsl:attribute>
</xsl:if>
<xsl:value-of select="$content"/>
</PartyTripartyAgentId>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.SendToCLS">
<xsl:param name="SendToCLSIE" select="/.."/>
<xsl:param name="SendToCLSFE" select="/.."/>
<SendToCLS>
<xsl:if test="$SendToCLSIE">
<SendToCLSIE>
<xsl:value-of select="$SendToCLSIE"/>
</SendToCLSIE>
</xsl:if>
<xsl:if test="$SendToCLSFE">
<SendToCLSFE>
<xsl:value-of select="$SendToCLSFE"/>
</SendToCLSFE>
</xsl:if>
</SendToCLS>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.AdditionalPayment">
<xsl:param name="PaymentDirectionA" select="/.."/>
<xsl:param name="Reason" select="/.."/>
<xsl:param name="Currency" select="/.."/>
<xsl:param name="Amount" select="/.."/>
<xsl:param name="Date" select="/.."/>
<xsl:param name="Convention" select="/.."/>
<xsl:param name="Holidays" select="/.."/>
<xsl:param name="LegalEntity" select="/.."/>
<AdditionalPayment>
<PaymentDirectionA>
<xsl:value-of select="$PaymentDirectionA"/>
</PaymentDirectionA>
<Reason>
<xsl:value-of select="$Reason"/>
</Reason>
<Currency>
<xsl:value-of select="$Currency"/>
</Currency>
<Amount>
<xsl:value-of select="$Amount"/>
</Amount>
<Date>
<xsl:value-of select="$Date"/>
</Date>
<Convention>
<xsl:value-of select="$Convention"/>
</Convention>
<Holidays>
<xsl:value-of select="$Holidays"/>
</Holidays>
<xsl:if test="$LegalEntity">
<LegalEntity>
<xsl:value-of select="$LegalEntity"/>
</LegalEntity>
</xsl:if>
</AdditionalPayment>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.AssociatedTrade">
<xsl:param name="AssociatedTradeId" select="/.."/>
<xsl:param name="RelationshipType" select="/.."/>
<AssociatedTrade>
<AssociatedTradeId>
<xsl:value-of select="$AssociatedTradeId"/>
</AssociatedTradeId>
<RelationshipType>
<xsl:value-of select="$RelationshipType"/>
</RelationshipType>
</AssociatedTrade>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.CreditDateAdjustments">
<xsl:param name="Convention" select="/.."/>
<xsl:param name="Holidays" select="/.."/>
<CreditDateAdjustments>
<xsl:if test="$Convention">
<Convention>
<xsl:value-of select="$Convention"/>
</Convention>
</xsl:if>
<Holidays>
<xsl:value-of select="$Holidays"/>
</Holidays>
</CreditDateAdjustments>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.FxFixingDate">
<xsl:param name="FxFixingAdjustableDate" select="/.."/>
<xsl:param name="FxFixingPeriod" select="/.."/>
<xsl:param name="FxFixingDayConvention" select="/.."/>
<xsl:param name="FxFixingCentres" select="/.."/>
<FxFixingDate>
<FxFixingAdjustableDate>
<xsl:value-of select="$FxFixingAdjustableDate"/>
</FxFixingAdjustableDate>
<FxFixingPeriod>
<xsl:value-of select="$FxFixingPeriod"/>
</FxFixingPeriod>
<FxFixingDayConvention>
<xsl:value-of select="$FxFixingDayConvention"/>
</FxFixingDayConvention>
<FxFixingCentres>
<xsl:value-of select="$FxFixingCentres"/>
</FxFixingCentres>
</FxFixingDate>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.FxFixingDate_2">
<xsl:param name="FxFixingPeriod_2" select="/.."/>
<xsl:param name="FxFixingDayConvention_2" select="/.."/>
<xsl:param name="FxFixingCentres_2" select="/.."/>
<FxFixingDate_2>
<FxFixingPeriod_2>
<xsl:value-of select="$FxFixingPeriod_2"/>
</FxFixingPeriod_2>
<FxFixingDayConvention_2>
<xsl:value-of select="$FxFixingDayConvention_2"/>
</FxFixingDayConvention_2>
<FxFixingCentres_2>
<xsl:value-of select="$FxFixingCentres_2"/>
</FxFixingCentres_2>
</FxFixingDate_2>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.CancelablePremium">
<xsl:param name="PaymentDirectionA" select="/.."/>
<xsl:param name="Currency" select="/.."/>
<xsl:param name="Amount" select="/.."/>
<xsl:param name="Date" select="/.."/>
<xsl:param name="Convention" select="/.."/>
<xsl:param name="Holidays" select="/.."/>
<CancelablePremium>
<PaymentDirectionA>
<xsl:value-of select="$PaymentDirectionA"/>
</PaymentDirectionA>
<Currency>
<xsl:value-of select="$Currency"/>
</Currency>
<Amount>
<xsl:value-of select="$Amount"/>
</Amount>
<Date>
<xsl:value-of select="$Date"/>
</Date>
<Convention>
<xsl:value-of select="$Convention"/>
</Convention>
<Holidays>
<xsl:value-of select="$Holidays"/>
</Holidays>
</CancelablePremium>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.AccumulatorSettlementDetails">
<xsl:param name="ObservationPeriod">
<xsl:call-template name="lcl:SWDMLTrade.AccumulatorSettlementDetails.ObservationPeriod"/>
</xsl:param>
<AccumulatorSettlementDetails>
<xsl:copy-of select="$ObservationPeriod"/>
</AccumulatorSettlementDetails>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.AccumulatorSettlementDetails.ObservationPeriod">
<xsl:param name="observationPeriodStartDate" select="/.."/>
<xsl:param name="observationPeriodEndDate" select="/.."/>
<xsl:param name="GuaranteedPeriod" select="/.."/>
<xsl:param name="UpFrontSettlement" select="/.."/>
<xsl:param name="ObservationPeriodSettlementDate" select="/.."/>
<ObservationPeriod>
<observationPeriodStartDate>
<xsl:value-of select="$observationPeriodStartDate"/>
</observationPeriodStartDate>
<observationPeriodEndDate>
<xsl:value-of select="$observationPeriodEndDate"/>
</observationPeriodEndDate>
<GuaranteedPeriod>
<xsl:value-of select="$GuaranteedPeriod"/>
</GuaranteedPeriod>
<UpFrontSettlement>
<xsl:value-of select="$UpFrontSettlement"/>
</UpFrontSettlement>
<ObservationPeriodSettlementDate>
<xsl:value-of select="$ObservationPeriodSettlementDate"/>
</ObservationPeriodSettlementDate>
</ObservationPeriod>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.BermudaExerciseDates">
<xsl:param name="BermudaExerciseDate" select="/.."/>
<BermudaExerciseDates>
<xsl:for-each select="$BermudaExerciseDate">
<BermudaExerciseDate>
<xsl:value-of select="."/>
</BermudaExerciseDate>
</xsl:for-each>
</BermudaExerciseDates>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.AveragingDateTimes">
<xsl:param name="AveragingDate" select="/.."/>
<AveragingDateTimes>
<xsl:for-each select="$AveragingDate">
<AveragingDate>
<xsl:value-of select="."/>
</AveragingDate>
</xsl:for-each>
</AveragingDateTimes>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.PeriodPaymentDate">
<xsl:param name="PeriodPaymentDateRef" select="/.."/>
<xsl:param name="PeriodPaymentDateValue" select="/.."/>
<PeriodPaymentDate>
<PeriodPaymentDateRef>
<xsl:value-of select="$PeriodPaymentDateRef"/>
</PeriodPaymentDateRef>
<PeriodPaymentDateValue>
<xsl:value-of select="$PeriodPaymentDateValue"/>
</PeriodPaymentDateValue>
</PeriodPaymentDate>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.DividendPeriods">
<xsl:param name="DividendPeriod" select="/.."/>
<DividendPeriods>
<xsl:copy-of select="$DividendPeriod"/>
</DividendPeriods>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.DividendPeriods.DividendPeriod">
<xsl:param name="DividendPeriodId" select="/.."/>
<xsl:param name="UnadjustedStartDate" select="/.."/>
<xsl:param name="UnadjustedEndDate" select="/.."/>
<xsl:param name="PaymentDateReference" select="/.."/>
<xsl:param name="FixedStrike" select="/.."/>
<xsl:param name="DividendValuationDateReference" select="/.."/>
<xsl:param name="DividendValuationDate" select="/.."/>
<DividendPeriod>
<DividendPeriodId>
<xsl:value-of select="$DividendPeriodId"/>
</DividendPeriodId>
<UnadjustedStartDate>
<xsl:value-of select="$UnadjustedStartDate"/>
</UnadjustedStartDate>
<UnadjustedEndDate>
<xsl:value-of select="$UnadjustedEndDate"/>
</UnadjustedEndDate>
<PaymentDateReference>
<xsl:value-of select="$PaymentDateReference"/>
</PaymentDateReference>
<FixedStrike>
<xsl:value-of select="$FixedStrike"/>
</FixedStrike>
<DividendValuationDateReference>
<xsl:value-of select="$DividendValuationDateReference"/>
</DividendValuationDateReference>
<DividendValuationDate>
<xsl:value-of select="$DividendValuationDate"/>
</DividendValuationDate>
</DividendPeriod>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.FixedPeriods">
<xsl:param name="FixedPayment" select="/.."/>
<FixedPeriods>
<xsl:copy-of select="$FixedPayment"/>
</FixedPeriods>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.FixedPeriods.FixedPayment">
<xsl:param name="DivSwapFixedAmount" select="/.."/>
<xsl:param name="DivSwapFixedDateOffset" select="/.."/>
<xsl:param name="DivSwapFixedDateRelativeTo" select="/.."/>
<FixedPayment>
<DivSwapFixedAmount>
<xsl:value-of select="$DivSwapFixedAmount"/>
</DivSwapFixedAmount>
<DivSwapFixedDateOffset>
<xsl:value-of select="$DivSwapFixedDateOffset"/>
</DivSwapFixedDateOffset>
<DivSwapFixedDateRelativeTo>
<xsl:value-of select="$DivSwapFixedDateRelativeTo"/>
</DivSwapFixedDateRelativeTo>
</FixedPayment>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.EquityAveragingObservations">
<xsl:param name="EquityAveragingObservation" select="/.."/>
<EquityAveragingObservations>
<xsl:copy-of select="$EquityAveragingObservation"/>
</EquityAveragingObservations>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.EquityAveragingObservations.EquityAveragingObservation">
<xsl:param name="EquityAveragingDate" select="/.."/>
<xsl:param name="EquityAveragingWeight" select="/.."/>
<EquityAveragingObservation>
<xsl:for-each select="$EquityAveragingDate">
<EquityAveragingDate>
<xsl:value-of select="."/>
</EquityAveragingDate>
</xsl:for-each>
<xsl:for-each select="$EquityAveragingWeight">
<EquityAveragingWeight>
<xsl:value-of select="."/>
</EquityAveragingWeight>
</xsl:for-each>
</EquityAveragingObservation>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.EquityListedValuationDates">
<xsl:param name="EquityListedValuationDate" select="/.."/>
<EquityListedValuationDates>
<xsl:for-each select="$EquityListedValuationDate">
<EquityListedValuationDate>
<xsl:value-of select="."/>
</EquityListedValuationDate>
</xsl:for-each>
</EquityListedValuationDates>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.StrategyLegs">
<xsl:param name="StrategyLeg" select="/.."/>
<StrategyLegs>
<xsl:copy-of select="$StrategyLeg"/>
</StrategyLegs>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.StrategyLegs.StrategyLeg">
<xsl:param name="SlDirectionA" select="/.."/>
<xsl:param name="SlLegId" select="/.."/>
<xsl:param name="SlExpirationDate" select="/.."/>
<xsl:param name="SlNumberOfOptions" select="/.."/>
<xsl:param name="SlOptionType" select="/.."/>
<xsl:param name="SlPayAmount" select="/.."/>
<xsl:param name="SlPricePerOptionAmount" select="/.."/>
<xsl:param name="SlStrikePrice" select="/.."/>
<xsl:param name="SlFwdStrikePercentage" select="/.."/>
<xsl:param name="SlFwdStrikeDate" select="/.."/>
<xsl:param name="SlPremiumPercent" select="/.."/>
<xsl:param name="SlStrikePercent" select="/.."/>
<xsl:param name="SlBaseNotional" select="/.."/>
<StrategyLeg>
<SlDirectionA>
<xsl:value-of select="$SlDirectionA"/>
</SlDirectionA>
<SlLegId>
<xsl:value-of select="$SlLegId"/>
</SlLegId>
<SlExpirationDate>
<xsl:value-of select="$SlExpirationDate"/>
</SlExpirationDate>
<SlNumberOfOptions>
<xsl:value-of select="$SlNumberOfOptions"/>
</SlNumberOfOptions>
<SlOptionType>
<xsl:value-of select="$SlOptionType"/>
</SlOptionType>
<SlPayAmount>
<xsl:value-of select="$SlPayAmount"/>
</SlPayAmount>
<SlPricePerOptionAmount>
<xsl:value-of select="$SlPricePerOptionAmount"/>
</SlPricePerOptionAmount>
<SlStrikePrice>
<xsl:value-of select="$SlStrikePrice"/>
</SlStrikePrice>
<SlFwdStrikePercentage>
<xsl:value-of select="$SlFwdStrikePercentage"/>
</SlFwdStrikePercentage>
<SlFwdStrikeDate>
<xsl:value-of select="$SlFwdStrikeDate"/>
</SlFwdStrikeDate>
<SlPremiumPercent>
<xsl:value-of select="$SlPremiumPercent"/>
</SlPremiumPercent>
<SlStrikePercent>
<xsl:value-of select="$SlStrikePercent"/>
</SlStrikePercent>
<SlBaseNotional>
<xsl:value-of select="$SlBaseNotional"/>
</SlBaseNotional>
</StrategyLeg>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.HolidayDates">
<xsl:param name="HolidayDate" select="/.."/>
<HolidayDates>
<xsl:for-each select="$HolidayDate">
<HolidayDate>
<xsl:value-of select="."/>
</HolidayDate>
</xsl:for-each>
</HolidayDates>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.DispLegs">
<xsl:param name="DispLeg" select="/.."/>
<DispLegs>
<xsl:copy-of select="$DispLeg"/>
</DispLegs>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.DispLegs.DispLeg">
<xsl:param name="DispLegId" select="/.."/>
<xsl:param name="DispLegVersionId" select="/.."/>
<xsl:param name="DispLegPayer" select="/.."/>
<xsl:param name="DispLegReceiver" select="/.."/>
<xsl:param name="DispEquityRic" select="/.."/>
<xsl:param name="DispEquityRelEx" select="/.."/>
<xsl:param name="DispVegaNotional" select="/.."/>
<xsl:param name="DispExpectedN" select="/.."/>
<xsl:param name="DispSettlementDateOffset" select="/.."/>
<xsl:param name="DispVarianceAmount" select="/.."/>
<xsl:param name="DispShareVarCurrency" select="/.."/>
<xsl:param name="DispVarianceStrikePrice" select="/.."/>
<xsl:param name="DispVarianceCapIndicator" select="/.."/>
<xsl:param name="DispVarianceCapFactor" select="/.."/>
<xsl:param name="DispVegaNotionalAmount" select="/.."/>
<xsl:param name="DispObservationStartDate" select="/.."/>
<xsl:param name="DispValuationDate" select="/.."/>
<xsl:param name="DispInitialLevel" select="/.."/>
<xsl:param name="DispClosingLevelIndicator" select="/.."/>
<xsl:param name="DispFuturesPriceValuation" select="/.."/>
<xsl:param name="DispAllDividends" select="/.."/>
<DispLeg>
<DispLegId>
<xsl:value-of select="$DispLegId"/>
</DispLegId>
<DispLegVersionId>
<xsl:value-of select="$DispLegVersionId"/>
</DispLegVersionId>
<DispLegPayer>
<xsl:value-of select="$DispLegPayer"/>
</DispLegPayer>
<DispLegReceiver>
<xsl:value-of select="$DispLegReceiver"/>
</DispLegReceiver>
<DispEquityRic>
<xsl:value-of select="$DispEquityRic"/>
</DispEquityRic>
<DispEquityRelEx>
<xsl:value-of select="$DispEquityRelEx"/>
</DispEquityRelEx>
<DispVegaNotional>
<xsl:value-of select="$DispVegaNotional"/>
</DispVegaNotional>
<DispExpectedN>
<xsl:value-of select="$DispExpectedN"/>
</DispExpectedN>
<DispSettlementDateOffset>
<xsl:value-of select="$DispSettlementDateOffset"/>
</DispSettlementDateOffset>
<DispVarianceAmount>
<xsl:value-of select="$DispVarianceAmount"/>
</DispVarianceAmount>
<DispShareVarCurrency>
<xsl:value-of select="$DispShareVarCurrency"/>
</DispShareVarCurrency>
<DispVarianceStrikePrice>
<xsl:value-of select="$DispVarianceStrikePrice"/>
</DispVarianceStrikePrice>
<DispVarianceCapIndicator>
<xsl:value-of select="$DispVarianceCapIndicator"/>
</DispVarianceCapIndicator>
<DispVarianceCapFactor>
<xsl:value-of select="$DispVarianceCapFactor"/>
</DispVarianceCapFactor>
<DispVegaNotionalAmount>
<xsl:value-of select="$DispVegaNotionalAmount"/>
</DispVegaNotionalAmount>
<DispObservationStartDate>
<xsl:value-of select="$DispObservationStartDate"/>
</DispObservationStartDate>
<DispValuationDate>
<xsl:value-of select="$DispValuationDate"/>
</DispValuationDate>
<DispInitialLevel>
<xsl:value-of select="$DispInitialLevel"/>
</DispInitialLevel>
<DispClosingLevelIndicator>
<xsl:value-of select="$DispClosingLevelIndicator"/>
</DispClosingLevelIndicator>
<DispFuturesPriceValuation>
<xsl:value-of select="$DispFuturesPriceValuation"/>
</DispFuturesPriceValuation>
<DispAllDividends>
<xsl:value-of select="$DispAllDividends"/>
</DispAllDividends>
</DispLeg>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.DispLegsSW">
<xsl:param name="DispLegSW" select="/.."/>
<DispLegsSW>
<xsl:copy-of select="$DispLegSW"/>
</DispLegsSW>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.DispLegsSW.DispLegSW">
<xsl:param name="DispCorrespondingLeg" select="/.."/>
<xsl:param name="DispVolatilityStrikePrice" select="/.."/>
<xsl:param name="DispHolidayDates">
<xsl:call-template name="lcl:SWDMLTrade.DispLegsSW.DispLegSW.DispHolidayDates"/>
</xsl:param>
<xsl:param name="DispExpectedNOverride" select="/.."/>
<xsl:param name="DispShareWeight" select="/.."/>
<DispLegSW>
<DispCorrespondingLeg>
<xsl:value-of select="$DispCorrespondingLeg"/>
</DispCorrespondingLeg>
<DispVolatilityStrikePrice>
<xsl:value-of select="$DispVolatilityStrikePrice"/>
</DispVolatilityStrikePrice>
<xsl:copy-of select="$DispHolidayDates"/>
<DispExpectedNOverride>
<xsl:value-of select="$DispExpectedNOverride"/>
</DispExpectedNOverride>
<DispShareWeight>
<xsl:value-of select="$DispShareWeight"/>
</DispShareWeight>
</DispLegSW>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.DispLegsSW.DispLegSW.DispHolidayDates">
<xsl:param name="HolidayDate" select="/.."/>
<DispHolidayDates>
<xsl:for-each select="$HolidayDate">
<HolidayDate>
<xsl:value-of select="."/>
</HolidayDate>
</xsl:for-each>
</DispHolidayDates>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.NovationReporting">
<xsl:param name="Novated" select="/.."/>
<xsl:param name="NewNovated" select="/.."/>
<NovationReporting>
<xsl:for-each select="$Novated">
<Novated>
<xsl:value-of select="."/>
</Novated>
</xsl:for-each>
<xsl:for-each select="$NewNovated">
<NewNovated>
<xsl:value-of select="."/>
</NewNovated>
</xsl:for-each>
</NovationReporting>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.EswDividendValuationCustomDatesInterim">
<xsl:param name="EswDividendValuationCustomDateInterim" select="/.."/>
<EswDividendValuationCustomDatesInterim>
<xsl:for-each select="$EswDividendValuationCustomDateInterim">
<EswDividendValuationCustomDateInterim>
<xsl:value-of select="."/>
</EswDividendValuationCustomDateInterim>
</xsl:for-each>
</EswDividendValuationCustomDatesInterim>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.EswInterestSpreadOverIndexStep">
<xsl:param name="EswInterestSpreadOverIndexStepValue" select="/.."/>
<xsl:param name="EswInterestSpreadOverIndexStepDate" select="/.."/>
<EswInterestSpreadOverIndexStep>
<xsl:for-each select="$EswInterestSpreadOverIndexStepValue">
<EswInterestSpreadOverIndexStepValue>
<xsl:value-of select="."/>
</EswInterestSpreadOverIndexStepValue>
</xsl:for-each>
<xsl:for-each select="$EswInterestSpreadOverIndexStepDate">
<EswInterestSpreadOverIndexStepDate>
<xsl:value-of select="."/>
</EswInterestSpreadOverIndexStepDate>
</xsl:for-each>
</EswInterestSpreadOverIndexStep>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.EswValuationDates">
<xsl:param name="EswUnadjustedDate" select="/.."/>
<EswValuationDates>
<xsl:for-each select="$EswUnadjustedDate">
<EswUnadjustedDate>
<xsl:value-of select="."/>
</EswUnadjustedDate>
</xsl:for-each>
</EswValuationDates>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.EswFixingDates">
<xsl:param name="EswUnadjustedDate" select="/.."/>
<EswFixingDates>
<xsl:for-each select="$EswUnadjustedDate">
<EswUnadjustedDate>
<xsl:value-of select="."/>
</EswUnadjustedDate>
</xsl:for-each>
</EswFixingDates>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.EswInterestLegPaymentDates">
<xsl:param name="EswUnadjustedDate" select="/.."/>
<EswInterestLegPaymentDates>
<xsl:for-each select="$EswUnadjustedDate">
<EswUnadjustedDate>
<xsl:value-of select="."/>
</EswUnadjustedDate>
</xsl:for-each>
</EswInterestLegPaymentDates>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.EswEquityLegPaymentDates">
<xsl:param name="EswUnadjustedDate" select="/.."/>
<EswEquityLegPaymentDates>
<xsl:for-each select="$EswUnadjustedDate">
<EswUnadjustedDate>
<xsl:value-of select="."/>
</EswUnadjustedDate>
</xsl:for-each>
</EswEquityLegPaymentDates>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.EswCompoundingDates">
<xsl:param name="EswUnadjustedDate" select="/.."/>
<EswCompoundingDates>
<xsl:for-each select="$EswUnadjustedDate">
<EswUnadjustedDate>
<xsl:value-of select="."/>
</EswUnadjustedDate>
</xsl:for-each>
</EswCompoundingDates>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.EswDividendComponent">
<xsl:param name="DividendPercentageComponentShare" select="/.."/>
<xsl:param name="DividendPercentageComponent" select="/.."/>
<EswDividendComponent>
<DividendPercentageComponentShare>
<xsl:value-of select="$DividendPercentageComponentShare"/>
</DividendPercentageComponentShare>
<DividendPercentageComponent>
<xsl:value-of select="$DividendPercentageComponent"/>
</DividendPercentageComponent>
</EswDividendComponent>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.EswEarlyTerminationElectingParty">
<xsl:param name="PartyOccurrence" select="/.."/>
<EswEarlyTerminationElectingParty>
<xsl:for-each select="$PartyOccurrence">
<PartyOccurrence>
<xsl:value-of select="."/>
</PartyOccurrence>
</xsl:for-each>
</EswEarlyTerminationElectingParty>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.EswChinaConnect">
<xsl:param name="EswShareDisqualification" select="/.."/>
<xsl:param name="EswServiceTermination" select="/.."/>
<EswChinaConnect>
<xsl:if test="$EswShareDisqualification">
<EswShareDisqualification>
<xsl:value-of select="$EswShareDisqualification"/>
</EswShareDisqualification>
</xsl:if>
<xsl:if test="$EswServiceTermination">
<EswServiceTermination>
<xsl:value-of select="$EswServiceTermination"/>
</EswServiceTermination>
</xsl:if>
</EswChinaConnect>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.EbsEligibleIndexGrid">
<xsl:param name="EbsEligibleIndexEntry">
<xsl:call-template name="lcl:SWDMLTrade.EbsEligibleIndexGrid.EbsEligibleIndexEntry"/>
</xsl:param>
<EbsEligibleIndexGrid>
<xsl:copy-of select="$EbsEligibleIndexEntry"/>
</EbsEligibleIndexGrid>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.EbsEligibleIndexGrid.EbsEligibleIndexEntry">
<xsl:param name="EligibleIndex" select="/.."/>
<xsl:param name="MinPercent" select="/.."/>
<xsl:param name="MaxPercent" select="/.."/>
<EbsEligibleIndexEntry>
<EligibleIndex>
<xsl:value-of select="$EligibleIndex"/>
</EligibleIndex>
<MinPercent>
<xsl:value-of select="$MinPercent"/>
</MinPercent>
<MaxPercent>
<xsl:value-of select="$MaxPercent"/>
</MaxPercent>
</EbsEligibleIndexEntry>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.EbsEligibleSectorGrid">
<xsl:param name="EbsEligibleSectorEntry">
<xsl:call-template name="lcl:SWDMLTrade.EbsEligibleSectorGrid.EbsEligibleSectorEntry"/>
</xsl:param>
<EbsEligibleSectorGrid>
<xsl:copy-of select="$EbsEligibleSectorEntry"/>
</EbsEligibleSectorGrid>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.EbsEligibleSectorGrid.EbsEligibleSectorEntry">
<xsl:param name="EligibleIndustrialSector" select="/.."/>
<xsl:param name="EligibleSectorMinPercent" select="/.."/>
<xsl:param name="EligibleSectorMaxPercent" select="/.."/>
<EbsEligibleSectorEntry>
<EligibleIndustrialSector>
<xsl:value-of select="$EligibleIndustrialSector"/>
</EligibleIndustrialSector>
<EligibleSectorMinPercent>
<xsl:value-of select="$EligibleSectorMinPercent"/>
</EligibleSectorMinPercent>
<EligibleSectorMaxPercent>
<xsl:value-of select="$EligibleSectorMaxPercent"/>
</EligibleSectorMaxPercent>
</EbsEligibleSectorEntry>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.EbsGrid">
<xsl:param name="TotalShares" select="/.."/>
<xsl:param name="EbsEntry">
<xsl:call-template name="lcl:SWDMLTrade.EbsGrid.EbsEntry"/>
</xsl:param>
<EbsGrid>
<TotalShares>
<xsl:value-of select="$TotalShares"/>
</TotalShares>
<xsl:copy-of select="$EbsEntry"/>
</EbsGrid>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.EbsGrid.EbsEntry">
<xsl:param name="RIC" select="/.."/>
<xsl:param name="ISIN" select="/.."/>
<xsl:param name="Description" select="/.."/>
<xsl:param name="Exchange" select="/.."/>
<xsl:param name="SharesAmount" select="/.."/>
<xsl:param name="ReferenceAmount" select="/.."/>
<xsl:param name="RefCurrency" select="/.."/>
<xsl:param name="FxRate" select="/.."/>
<xsl:param name="UnitPrice" select="/.."/>
<xsl:param name="Currency" select="/.."/>
<xsl:param name="Notional" select="/.."/>
<xsl:param name="RelatedExchange" select="/.."/>
<xsl:param name="DividendPercentage" select="/.."/>
<EbsEntry>
<RIC>
<xsl:value-of select="$RIC"/>
</RIC>
<ISIN>
<xsl:value-of select="$ISIN"/>
</ISIN>
<Description>
<xsl:value-of select="$Description"/>
</Description>
<Exchange>
<xsl:value-of select="$Exchange"/>
</Exchange>
<SharesAmount>
<xsl:value-of select="$SharesAmount"/>
</SharesAmount>
<ReferenceAmount>
<xsl:value-of select="$ReferenceAmount"/>
</ReferenceAmount>
<RefCurrency>
<xsl:value-of select="$RefCurrency"/>
</RefCurrency>
<FxRate>
<xsl:value-of select="$FxRate"/>
</FxRate>
<UnitPrice>
<xsl:value-of select="$UnitPrice"/>
</UnitPrice>
<Currency>
<xsl:value-of select="$Currency"/>
</Currency>
<Notional>
<xsl:value-of select="$Notional"/>
</Notional>
<RelatedExchange>
<xsl:value-of select="$RelatedExchange"/>
</RelatedExchange>
<DividendPercentage>
<xsl:value-of select="$DividendPercentage"/>
</DividendPercentage>
</EbsEntry>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.NCIndivTradeSummary">
<xsl:param name="NCIndivNCMId" select="/.."/>
<xsl:param name="NCIndivMWId" select="/.."/>
<xsl:param name="NCIndivORFundId" select="/.."/>
<xsl:param name="NCIndivORFund" select="/.."/>
<xsl:param name="NCIndivRPFundId" select="/.."/>
<xsl:param name="NCIndivRPFund" select="/.."/>
<xsl:param name="NCIndivEEFundId" select="/.."/>
<xsl:param name="NCIndivEEFund" select="/.."/>
<xsl:param name="NCIndivNotionalAmount" select="/.."/>
<xsl:param name="NCIndivNotionalCurrency" select="/.."/>
<xsl:param name="NCIndivFeeAmount" select="/.."/>
<xsl:param name="NCIndivFeeCurrency" select="/.."/>
<xsl:param name="NCIndivStatus" select="/.."/>
<NCIndivTradeSummary>
<NCIndivNCMId>
<xsl:value-of select="$NCIndivNCMId"/>
</NCIndivNCMId>
<NCIndivMWId>
<xsl:value-of select="$NCIndivMWId"/>
</NCIndivMWId>
<NCIndivORFundId>
<xsl:value-of select="$NCIndivORFundId"/>
</NCIndivORFundId>
<NCIndivORFund>
<xsl:value-of select="$NCIndivORFund"/>
</NCIndivORFund>
<NCIndivRPFundId>
<xsl:value-of select="$NCIndivRPFundId"/>
</NCIndivRPFundId>
<NCIndivRPFund>
<xsl:value-of select="$NCIndivRPFund"/>
</NCIndivRPFund>
<NCIndivEEFundId>
<xsl:value-of select="$NCIndivEEFundId"/>
</NCIndivEEFundId>
<NCIndivEEFund>
<xsl:value-of select="$NCIndivEEFund"/>
</NCIndivEEFund>
<NCIndivNotionalAmount>
<xsl:value-of select="$NCIndivNotionalAmount"/>
</NCIndivNotionalAmount>
<NCIndivNotionalCurrency>
<xsl:value-of select="$NCIndivNotionalCurrency"/>
</NCIndivNotionalCurrency>
<NCIndivFeeAmount>
<xsl:value-of select="$NCIndivFeeAmount"/>
</NCIndivFeeAmount>
<NCIndivFeeCurrency>
<xsl:value-of select="$NCIndivFeeCurrency"/>
</NCIndivFeeCurrency>
<NCIndivStatus>
<xsl:value-of select="$NCIndivStatus"/>
</NCIndivStatus>
</NCIndivTradeSummary>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.MigrationReferences">
<xsl:param name="MigrationReference" select="/.."/>
<MigrationReferences>
<xsl:copy-of select="$MigrationReference"/>
</MigrationReferences>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.MigrationReferences.MigrationReference">
<xsl:param name="MigrationIDParty" select="/.."/>
<xsl:param name="MigrationID" select="/.."/>
<MigrationReference>
<MigrationIDParty>
<xsl:value-of select="$MigrationIDParty"/>
</MigrationIDParty>
<MigrationID>
<xsl:value-of select="$MigrationID"/>
</MigrationID>
</MigrationReference>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.HedgingParty">
<xsl:param name="HedgingPartyOccurrence" select="/.."/>
<HedgingParty>
<xsl:for-each select="$HedgingPartyOccurrence">
<HedgingPartyOccurrence>
<xsl:value-of select="."/>
</HedgingPartyOccurrence>
</xsl:for-each>
</HedgingParty>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.DeterminingParty">
<xsl:param name="DeterminingPartyOccurrence" select="/.."/>
<DeterminingParty>
<xsl:for-each select="$DeterminingPartyOccurrence">
<DeterminingPartyOccurrence>
<xsl:value-of select="."/>
</DeterminingPartyOccurrence>
</xsl:for-each>
</DeterminingParty>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.CalculationAgent">
<xsl:param name="CalculationAgentOccurrence" select="/.."/>
<CalculationAgent>
<xsl:for-each select="$CalculationAgentOccurrence">
<CalculationAgentOccurrence>
<xsl:value-of select="."/>
</CalculationAgentOccurrence>
</xsl:for-each>
</CalculationAgent>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.IndependentAmount2">
<xsl:param name="Payer" select="/.."/>
<xsl:param name="Currency" select="/.."/>
<xsl:param name="Amount" select="/.."/>
<xsl:param name="IndependentAmountPercentage" select="/.."/>
<xsl:param name="PercentagePaymentRule" select="/.."/>
<xsl:param name="Date" select="/.."/>
<xsl:param name="Convention" select="/.."/>
<xsl:param name="Holidays" select="/.."/>
<IndependentAmount2>
<Payer>
<xsl:value-of select="$Payer"/>
</Payer>
<Currency>
<xsl:value-of select="$Currency"/>
</Currency>
<Amount>
<xsl:value-of select="$Amount"/>
</Amount>
<xsl:if test="$IndependentAmountPercentage">
<IndependentAmountPercentage>
<xsl:value-of select="$IndependentAmountPercentage"/>
</IndependentAmountPercentage>
</xsl:if>
<xsl:copy-of select="$PercentagePaymentRule"/>
<xsl:if test="$Date">
<Date>
<xsl:value-of select="$Date"/>
</Date>
</xsl:if>
<xsl:if test="$Convention">
<Convention>
<xsl:value-of select="$Convention"/>
</Convention>
</xsl:if>
<xsl:if test="$Holidays">
<Holidays>
<xsl:value-of select="$Holidays"/>
</Holidays>
</xsl:if>
</IndependentAmount2>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.IndependentAmount2.PercentagePaymentRule">
<xsl:param name="PaymentPercent" select="/.."/>
<xsl:param name="NotionalAmountReference" select="/.."/>
<PercentagePaymentRule>
<PaymentPercent>
<xsl:value-of select="$PaymentPercent"/>
</PaymentPercent>
<xsl:if test="$NotionalAmountReference">
<NotionalAmountReference>
<xsl:value-of select="$NotionalAmountReference"/>
</NotionalAmountReference>
</xsl:if>
</PercentagePaymentRule>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.NotionalSchedule">
<xsl:param name="FixedLegNotionalStep" select="/.."/>
<xsl:param name="FixedLegNotionalStep2" select="/.."/>
<xsl:param name="FloatLegNotionalStep" select="/.."/>
<xsl:param name="FloatLegNotionalStep2" select="/.."/>
<NotionalSchedule>
<xsl:copy-of select="$FixedLegNotionalStep"/>
<xsl:copy-of select="$FixedLegNotionalStep2"/>
<xsl:copy-of select="$FloatLegNotionalStep"/>
<xsl:copy-of select="$FloatLegNotionalStep2"/>
</NotionalSchedule>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.NotionalSchedule.FixedLegNotionalStep">
<xsl:param name="FixedPaymentDates" select="/.."/>
<xsl:param name="FixedNotionals" select="/.."/>
<xsl:param name="FixedRates" select="/.."/>
<FixedLegNotionalStep>
<FixedPaymentDates>
<xsl:value-of select="$FixedPaymentDates"/>
</FixedPaymentDates>
<FixedNotionals>
<xsl:value-of select="$FixedNotionals"/>
</FixedNotionals>
<FixedRates>
<xsl:value-of select="$FixedRates"/>
</FixedRates>
</FixedLegNotionalStep>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.NotionalSchedule.FixedLegNotionalStep2">
<xsl:param name="FixedPaymentDates2" select="/.."/>
<xsl:param name="FixedNotionals2" select="/.."/>
<xsl:param name="FixedRates2" select="/.."/>
<FixedLegNotionalStep2>
<FixedPaymentDates2>
<xsl:value-of select="$FixedPaymentDates2"/>
</FixedPaymentDates2>
<FixedNotionals2>
<xsl:value-of select="$FixedNotionals2"/>
</FixedNotionals2>
<FixedRates2>
<xsl:value-of select="$FixedRates2"/>
</FixedRates2>
</FixedLegNotionalStep2>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.NotionalSchedule.FloatLegNotionalStep">
<xsl:param name="FloatRollDates" select="/.."/>
<xsl:param name="FloatNotionals" select="/.."/>
<xsl:param name="FloatSpreads" select="/.."/>
<FloatLegNotionalStep>
<FloatRollDates>
<xsl:value-of select="$FloatRollDates"/>
</FloatRollDates>
<FloatNotionals>
<xsl:value-of select="$FloatNotionals"/>
</FloatNotionals>
<FloatSpreads>
<xsl:value-of select="$FloatSpreads"/>
</FloatSpreads>
</FloatLegNotionalStep>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.NotionalSchedule.FloatLegNotionalStep2">
<xsl:param name="FloatRollDates2" select="/.."/>
<xsl:param name="FloatNotionals2" select="/.."/>
<xsl:param name="FloatSpreads2" select="/.."/>
<FloatLegNotionalStep2>
<FloatRollDates2>
<xsl:value-of select="$FloatRollDates2"/>
</FloatRollDates2>
<FloatNotionals2>
<xsl:value-of select="$FloatNotionals2"/>
</FloatNotionals2>
<FloatSpreads2>
<xsl:value-of select="$FloatSpreads2"/>
</FloatSpreads2>
</FloatLegNotionalStep2>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.ReportingData">
<xsl:param name="PriorUSI" select="/.."/>
<xsl:param name="UPI" select="/.."/>
<ReportingData>
<PriorUSI>
<xsl:value-of select="$PriorUSI"/>
</PriorUSI>
<UPI>
<xsl:value-of select="$UPI"/>
</UPI>
</ReportingData>
</xsl:template>
<xsl:template name="lcl:DFData">
<xsl:param name="ExecutionType" select="/.."/>
<xsl:param name="PriceNotationType" select="/.."/>
<xsl:param name="PriceNotationValue" select="/.."/>
<xsl:param name="PriceNotation" select="/.."/>
<xsl:param name="AdditionalPriceNotationType" select="/.."/>
<xsl:param name="AdditionalPriceNotationValue" select="/.."/>
<xsl:param name="AdditionalPriceNotation" select="/.."/>
<xsl:param name="ExecTraderSideAID" select="/.."/>
<xsl:param name="ExecTraderSideBID" select="/.."/>
<xsl:param name="SalesTraderSideAID" select="/.."/>
<xsl:param name="SalesTraderSideBID" select="/.."/>
<xsl:param name="DeskLocationSideAID" select="/.."/>
<xsl:param name="DeskLocationSideBID" select="/.."/>
<xsl:param name="ArrBrokerLocationSideAIDPrefix" select="/.."/>
<xsl:param name="ArrBrokerLocationSideAID" select="/.."/>
<xsl:param name="ArrBrokerLocationSideBIDPrefix" select="/.."/>
<xsl:param name="ArrBrokerLocationSideBID" select="/.."/>
<xsl:param name="BranchLocationSideAIDPrefix" select="/.."/>
<xsl:param name="BranchLocationSideAID" select="/.."/>
<xsl:param name="BranchLocationSideBIDPrefix" select="/.."/>
<xsl:param name="BranchLocationSideBID" select="/.."/>
<xsl:param name="IndirectCptySideAIDPrefix" select="/.."/>
<xsl:param name="IndirectCptySideAID" select="/.."/>
<xsl:param name="IndirectCptySideBIDPrefix" select="/.."/>
<xsl:param name="IndirectCptySideBID" select="/.."/>
<xsl:param name="DFDataPresent" select="/.."/>
<xsl:param name="DFRegulatorType" select="/.."/>
<xsl:param name="Route1Destination" select="/.."/>
<xsl:param name="Route1Intermediary" select="/.."/>
<xsl:param name="USINamespace" select="/.."/>
<xsl:param name="IntentToBlankUSINamespace" select="/.."/>
<xsl:param name="USINamespacePrefix" select="/.."/>
<xsl:param name="USI" select="/.."/>
<xsl:param name="IntentToBlankUSI" select="/.."/>
<xsl:param name="GlobalUTI" select="/.."/>
<xsl:param name="IntentToBlankGlobalUTI" select="/.."/>
<xsl:param name="ObligatoryReporting" select="/.."/>
<xsl:param name="SecondaryAssetClass" select="/.."/>
<xsl:param name="ReportingCounterparty" select="/.."/>
<xsl:param name="DFClearingMandatory" select="/.."/>
<xsl:param name="ISIN" select="/.."/>
<xsl:param name="CFI" select="/.."/>
<xsl:param name="FullName" select="/.."/>
<xsl:param name="OrderDirectionA" select="/.."/>
<xsl:param name="OrderDirectionB" select="/.."/>
<xsl:param name="NewNovatedPriceNotationType" select="/.."/>
<xsl:param name="NewNovatedPriceNotationValue" select="/.."/>
<xsl:param name="NewNovatedAdditionalPriceNotationType" select="/.."/>
<xsl:param name="NewNovatedAdditionalPriceNotationValue" select="/.."/>
<xsl:param name="NewNovatedDFDataPresent" select="/.."/>
<xsl:param name="NewNovatedDFRegulatorType" select="/.."/>
<xsl:param name="NewNovatedRoute1Destination" select="/.."/>
<xsl:param name="NewNovatedRoute1Intermediary" select="/.."/>
<xsl:param name="NewNovatedUSINamespace" select="/.."/>
<xsl:param name="NewNovatedUSINamespacePrefix" select="/.."/>
<xsl:param name="NewNovatedUSI" select="/.."/>
<xsl:param name="NewNovatedGlobalUTI" select="/.."/>
<xsl:param name="NewNovatedObligatoryReporting" select="/.."/>
<xsl:param name="NewNovatedReportingCounterparty" select="/.."/>
<xsl:param name="NewNovatedDFClearingMandatory" select="/.."/>
<xsl:param name="NovatedPriceNotationType" select="/.."/>
<xsl:param name="NovatedPriceNotationValue" select="/.."/>
<xsl:param name="NovatedAdditionalPriceNotationType" select="/.."/>
<xsl:param name="NovatedAdditionalPriceNotationValue" select="/.."/>
<xsl:param name="NovatedDFDataPresent" select="/.."/>
<xsl:param name="NovatedDFRegulatorType" select="/.."/>
<xsl:param name="NovatedRoute1Destination" select="/.."/>
<xsl:param name="NovatedRoute1Intermediary" select="/.."/>
<xsl:param name="NovatedUSINamespace" select="/.."/>
<xsl:param name="NovatedUSINamespacePrefix" select="/.."/>
<xsl:param name="NovatedUSI" select="/.."/>
<xsl:param name="NovatedObligatoryReporting" select="/.."/>
<xsl:param name="NovatedReportingCounterparty" select="/.."/>
<xsl:param name="NovatedDFClearingMandatory" select="/.."/>
<xsl:param name="NovationFeePriceNotationType" select="/.."/>
<xsl:param name="NovationFeePriceNotationValue" select="/.."/>
<xsl:param name="NovationFeeAdditionalPriceNotationType" select="/.."/>
<xsl:param name="NovationFeeAdditionalPriceNotationValue" select="/.."/>
<xsl:param name="NovationFeeDFDataPresent" select="/.."/>
<xsl:param name="NovationFeeDFRegulatorType" select="/.."/>
<xsl:param name="NovationFeeRoute1Destination" select="/.."/>
<xsl:param name="NovationFeeRoute1Intermediary" select="/.."/>
<xsl:param name="NovationFeeUSINamespace" select="/.."/>
<xsl:param name="NovationFeeUSINamespacePrefix" select="/.."/>
<xsl:param name="NovationFeeUSI" select="/.."/>
<xsl:param name="NovationFeeGlobalUTI" select="/.."/>
<xsl:param name="NovationFeeObligatoryReporting" select="/.."/>
<xsl:param name="NovationFeeReportingCounterparty" select="/.."/>
<xsl:param name="NovationFeeDFClearingMandatory" select="/.."/>
<xsl:if test="$ExecutionType">
<ExecutionType>
<xsl:value-of select="$ExecutionType"/>
</ExecutionType>
</xsl:if>
<xsl:if test="$PriceNotationType">
<PriceNotationType>
<xsl:value-of select="$PriceNotationType"/>
</PriceNotationType>
</xsl:if>
<xsl:if test="$PriceNotationValue">
<PriceNotationValue>
<xsl:value-of select="$PriceNotationValue"/>
</PriceNotationValue>
</xsl:if>
<xsl:copy-of select="$PriceNotation"/>
<xsl:if test="$AdditionalPriceNotationType">
<AdditionalPriceNotationType>
<xsl:value-of select="$AdditionalPriceNotationType"/>
</AdditionalPriceNotationType>
</xsl:if>
<xsl:if test="$AdditionalPriceNotationValue">
<AdditionalPriceNotationValue>
<xsl:value-of select="$AdditionalPriceNotationValue"/>
</AdditionalPriceNotationValue>
</xsl:if>
<xsl:copy-of select="$AdditionalPriceNotation"/>
<xsl:if test="$ExecTraderSideAID">
<ExecTraderSideAID>
<xsl:value-of select="$ExecTraderSideAID"/>
</ExecTraderSideAID>
</xsl:if>
<xsl:if test="$ExecTraderSideBID">
<ExecTraderSideBID>
<xsl:value-of select="$ExecTraderSideBID"/>
</ExecTraderSideBID>
</xsl:if>
<xsl:if test="$SalesTraderSideAID">
<SalesTraderSideAID>
<xsl:value-of select="$SalesTraderSideAID"/>
</SalesTraderSideAID>
</xsl:if>
<xsl:if test="$SalesTraderSideBID">
<SalesTraderSideBID>
<xsl:value-of select="$SalesTraderSideBID"/>
</SalesTraderSideBID>
</xsl:if>
<xsl:if test="$DeskLocationSideAID">
<DeskLocationSideAID>
<xsl:value-of select="$DeskLocationSideAID"/>
</DeskLocationSideAID>
</xsl:if>
<xsl:if test="$DeskLocationSideBID">
<DeskLocationSideBID>
<xsl:value-of select="$DeskLocationSideBID"/>
</DeskLocationSideBID>
</xsl:if>
<xsl:if test="$ArrBrokerLocationSideAIDPrefix">
<ArrBrokerLocationSideAIDPrefix>
<xsl:value-of select="$ArrBrokerLocationSideAIDPrefix"/>
</ArrBrokerLocationSideAIDPrefix>
</xsl:if>
<xsl:if test="$ArrBrokerLocationSideAID">
<ArrBrokerLocationSideAID>
<xsl:value-of select="$ArrBrokerLocationSideAID"/>
</ArrBrokerLocationSideAID>
</xsl:if>
<xsl:if test="$ArrBrokerLocationSideBIDPrefix">
<ArrBrokerLocationSideBIDPrefix>
<xsl:value-of select="$ArrBrokerLocationSideBIDPrefix"/>
</ArrBrokerLocationSideBIDPrefix>
</xsl:if>
<xsl:if test="$ArrBrokerLocationSideBID">
<ArrBrokerLocationSideBID>
<xsl:value-of select="$ArrBrokerLocationSideBID"/>
</ArrBrokerLocationSideBID>
</xsl:if>
<xsl:if test="$BranchLocationSideAIDPrefix">
<BranchLocationSideAIDPrefix>
<xsl:value-of select="$BranchLocationSideAIDPrefix"/>
</BranchLocationSideAIDPrefix>
</xsl:if>
<xsl:if test="$BranchLocationSideAID">
<BranchLocationSideAID>
<xsl:value-of select="$BranchLocationSideAID"/>
</BranchLocationSideAID>
</xsl:if>
<xsl:if test="$BranchLocationSideBIDPrefix">
<BranchLocationSideBIDPrefix>
<xsl:value-of select="$BranchLocationSideBIDPrefix"/>
</BranchLocationSideBIDPrefix>
</xsl:if>
<xsl:if test="$BranchLocationSideBID">
<BranchLocationSideBID>
<xsl:value-of select="$BranchLocationSideBID"/>
</BranchLocationSideBID>
</xsl:if>
<xsl:if test="$IndirectCptySideAIDPrefix">
<IndirectCptySideAIDPrefix>
<xsl:value-of select="$IndirectCptySideAIDPrefix"/>
</IndirectCptySideAIDPrefix>
</xsl:if>
<xsl:if test="$IndirectCptySideAID">
<IndirectCptySideAID>
<xsl:value-of select="$IndirectCptySideAID"/>
</IndirectCptySideAID>
</xsl:if>
<xsl:if test="$IndirectCptySideBIDPrefix">
<IndirectCptySideBIDPrefix>
<xsl:value-of select="$IndirectCptySideBIDPrefix"/>
</IndirectCptySideBIDPrefix>
</xsl:if>
<xsl:if test="$IndirectCptySideBID">
<IndirectCptySideBID>
<xsl:value-of select="$IndirectCptySideBID"/>
</IndirectCptySideBID>
</xsl:if>
<xsl:if test="$DFDataPresent">
<DFDataPresent>
<xsl:value-of select="$DFDataPresent"/>
</DFDataPresent>
</xsl:if>
<xsl:if test="$DFRegulatorType">
<DFRegulatorType>
<xsl:value-of select="$DFRegulatorType"/>
</DFRegulatorType>
</xsl:if>
<xsl:if test="$Route1Destination">
<Route1Destination>
<xsl:value-of select="$Route1Destination"/>
</Route1Destination>
</xsl:if>
<xsl:if test="$Route1Intermediary">
<Route1Intermediary>
<xsl:value-of select="$Route1Intermediary"/>
</Route1Intermediary>
</xsl:if>
<xsl:if test="$USINamespace">
<USINamespace>
<xsl:value-of select="$USINamespace"/>
</USINamespace>
</xsl:if>
<xsl:if test="$IntentToBlankUSINamespace">
<IntentToBlankUSINamespace>
<xsl:value-of select="$IntentToBlankUSINamespace"/>
</IntentToBlankUSINamespace>
</xsl:if>
<xsl:if test="$USINamespacePrefix">
<USINamespacePrefix>
<xsl:value-of select="$USINamespacePrefix"/>
</USINamespacePrefix>
</xsl:if>
<xsl:if test="$USI">
<USI>
<xsl:value-of select="$USI"/>
</USI>
</xsl:if>
<xsl:if test="$IntentToBlankUSI">
<IntentToBlankUSI>
<xsl:value-of select="$IntentToBlankUSI"/>
</IntentToBlankUSI>
</xsl:if>
<xsl:if test="$GlobalUTI">
<GlobalUTI>
<xsl:value-of select="$GlobalUTI"/>
</GlobalUTI>
</xsl:if>
<xsl:if test="$IntentToBlankGlobalUTI">
<IntentToBlankGlobalUTI>
<xsl:value-of select="$IntentToBlankGlobalUTI"/>
</IntentToBlankGlobalUTI>
</xsl:if>
<xsl:if test="$ObligatoryReporting">
<ObligatoryReporting>
<xsl:value-of select="$ObligatoryReporting"/>
</ObligatoryReporting>
</xsl:if>
<xsl:if test="$SecondaryAssetClass">
<SecondaryAssetClass>
<xsl:value-of select="$SecondaryAssetClass"/>
</SecondaryAssetClass>
</xsl:if>
<xsl:if test="$ReportingCounterparty">
<ReportingCounterparty>
<xsl:value-of select="$ReportingCounterparty"/>
</ReportingCounterparty>
</xsl:if>
<xsl:if test="$DFClearingMandatory">
<DFClearingMandatory>
<xsl:value-of select="$DFClearingMandatory"/>
</DFClearingMandatory>
</xsl:if>
<xsl:if test="$ISIN">
<ISIN>
<xsl:value-of select="$ISIN"/>
</ISIN>
</xsl:if>
<xsl:if test="$CFI">
<CFI>
<xsl:value-of select="$CFI"/>
</CFI>
</xsl:if>
<xsl:if test="$FullName">
<FullName>
<xsl:value-of select="$FullName"/>
</FullName>
</xsl:if>
<xsl:if test="$OrderDirectionA">
<OrderDirectionA>
<xsl:value-of select="$OrderDirectionA"/>
</OrderDirectionA>
</xsl:if>
<xsl:if test="$OrderDirectionB">
<OrderDirectionB>
<xsl:value-of select="$OrderDirectionB"/>
</OrderDirectionB>
</xsl:if>
<xsl:if test="$NewNovatedPriceNotationType">
<NewNovatedPriceNotationType>
<xsl:value-of select="$NewNovatedPriceNotationType"/>
</NewNovatedPriceNotationType>
</xsl:if>
<xsl:if test="$NewNovatedPriceNotationValue">
<NewNovatedPriceNotationValue>
<xsl:value-of select="$NewNovatedPriceNotationValue"/>
</NewNovatedPriceNotationValue>
</xsl:if>
<xsl:if test="$NewNovatedAdditionalPriceNotationType">
<NewNovatedAdditionalPriceNotationType>
<xsl:value-of select="$NewNovatedAdditionalPriceNotationType"/>
</NewNovatedAdditionalPriceNotationType>
</xsl:if>
<xsl:if test="$NewNovatedAdditionalPriceNotationValue">
<NewNovatedAdditionalPriceNotationValue>
<xsl:value-of select="$NewNovatedAdditionalPriceNotationValue"/>
</NewNovatedAdditionalPriceNotationValue>
</xsl:if>
<xsl:if test="$NewNovatedDFDataPresent">
<NewNovatedDFDataPresent>
<xsl:value-of select="$NewNovatedDFDataPresent"/>
</NewNovatedDFDataPresent>
</xsl:if>
<xsl:if test="$NewNovatedDFRegulatorType">
<NewNovatedDFRegulatorType>
<xsl:value-of select="$NewNovatedDFRegulatorType"/>
</NewNovatedDFRegulatorType>
</xsl:if>
<xsl:if test="$NewNovatedRoute1Destination">
<NewNovatedRoute1Destination>
<xsl:value-of select="$NewNovatedRoute1Destination"/>
</NewNovatedRoute1Destination>
</xsl:if>
<xsl:if test="$NewNovatedRoute1Intermediary">
<NewNovatedRoute1Intermediary>
<xsl:value-of select="$NewNovatedRoute1Intermediary"/>
</NewNovatedRoute1Intermediary>
</xsl:if>
<xsl:if test="$NewNovatedUSINamespace">
<NewNovatedUSINamespace>
<xsl:value-of select="$NewNovatedUSINamespace"/>
</NewNovatedUSINamespace>
</xsl:if>
<xsl:if test="$NewNovatedUSINamespacePrefix">
<NewNovatedUSINamespacePrefix>
<xsl:value-of select="$NewNovatedUSINamespacePrefix"/>
</NewNovatedUSINamespacePrefix>
</xsl:if>
<xsl:if test="$NewNovatedUSI">
<NewNovatedUSI>
<xsl:value-of select="$NewNovatedUSI"/>
</NewNovatedUSI>
</xsl:if>
<xsl:if test="$NewNovatedGlobalUTI">
<NewNovatedGlobalUTI>
<xsl:value-of select="$NewNovatedGlobalUTI"/>
</NewNovatedGlobalUTI>
</xsl:if>
<xsl:if test="$NewNovatedObligatoryReporting">
<NewNovatedObligatoryReporting>
<xsl:value-of select="$NewNovatedObligatoryReporting"/>
</NewNovatedObligatoryReporting>
</xsl:if>
<xsl:if test="$NewNovatedReportingCounterparty">
<NewNovatedReportingCounterparty>
<xsl:value-of select="$NewNovatedReportingCounterparty"/>
</NewNovatedReportingCounterparty>
</xsl:if>
<xsl:if test="$NewNovatedDFClearingMandatory">
<NewNovatedDFClearingMandatory>
<xsl:value-of select="$NewNovatedDFClearingMandatory"/>
</NewNovatedDFClearingMandatory>
</xsl:if>
<xsl:if test="$NovatedPriceNotationType">
<NovatedPriceNotationType>
<xsl:value-of select="$NovatedPriceNotationType"/>
</NovatedPriceNotationType>
</xsl:if>
<xsl:if test="$NovatedPriceNotationValue">
<NovatedPriceNotationValue>
<xsl:value-of select="$NovatedPriceNotationValue"/>
</NovatedPriceNotationValue>
</xsl:if>
<xsl:if test="$NovatedAdditionalPriceNotationType">
<NovatedAdditionalPriceNotationType>
<xsl:value-of select="$NovatedAdditionalPriceNotationType"/>
</NovatedAdditionalPriceNotationType>
</xsl:if>
<xsl:if test="$NovatedAdditionalPriceNotationValue">
<NovatedAdditionalPriceNotationValue>
<xsl:value-of select="$NovatedAdditionalPriceNotationValue"/>
</NovatedAdditionalPriceNotationValue>
</xsl:if>
<xsl:if test="$NovatedDFDataPresent">
<NovatedDFDataPresent>
<xsl:value-of select="$NovatedDFDataPresent"/>
</NovatedDFDataPresent>
</xsl:if>
<xsl:if test="$NovatedDFRegulatorType">
<NovatedDFRegulatorType>
<xsl:value-of select="$NovatedDFRegulatorType"/>
</NovatedDFRegulatorType>
</xsl:if>
<xsl:if test="$NovatedRoute1Destination">
<NovatedRoute1Destination>
<xsl:value-of select="$NovatedRoute1Destination"/>
</NovatedRoute1Destination>
</xsl:if>
<xsl:if test="$NovatedRoute1Intermediary">
<NovatedRoute1Intermediary>
<xsl:value-of select="$NovatedRoute1Intermediary"/>
</NovatedRoute1Intermediary>
</xsl:if>
<xsl:if test="$NovatedUSINamespace">
<NovatedUSINamespace>
<xsl:value-of select="$NovatedUSINamespace"/>
</NovatedUSINamespace>
</xsl:if>
<xsl:if test="$NovatedUSINamespacePrefix">
<NovatedUSINamespacePrefix>
<xsl:value-of select="$NovatedUSINamespacePrefix"/>
</NovatedUSINamespacePrefix>
</xsl:if>
<xsl:if test="$NovatedUSI">
<NovatedUSI>
<xsl:value-of select="$NovatedUSI"/>
</NovatedUSI>
</xsl:if>
<xsl:if test="$NovatedObligatoryReporting">
<NovatedObligatoryReporting>
<xsl:value-of select="$NovatedObligatoryReporting"/>
</NovatedObligatoryReporting>
</xsl:if>
<xsl:if test="$NovatedReportingCounterparty">
<NovatedReportingCounterparty>
<xsl:value-of select="$NovatedReportingCounterparty"/>
</NovatedReportingCounterparty>
</xsl:if>
<xsl:if test="$NovatedDFClearingMandatory">
<NovatedDFClearingMandatory>
<xsl:value-of select="$NovatedDFClearingMandatory"/>
</NovatedDFClearingMandatory>
</xsl:if>
<xsl:if test="$NovationFeePriceNotationType">
<NovationFeePriceNotationType>
<xsl:value-of select="$NovationFeePriceNotationType"/>
</NovationFeePriceNotationType>
</xsl:if>
<xsl:if test="$NovationFeePriceNotationValue">
<NovationFeePriceNotationValue>
<xsl:value-of select="$NovationFeePriceNotationValue"/>
</NovationFeePriceNotationValue>
</xsl:if>
<xsl:if test="$NovationFeeAdditionalPriceNotationType">
<NovationFeeAdditionalPriceNotationType>
<xsl:value-of select="$NovationFeeAdditionalPriceNotationType"/>
</NovationFeeAdditionalPriceNotationType>
</xsl:if>
<xsl:if test="$NovationFeeAdditionalPriceNotationValue">
<NovationFeeAdditionalPriceNotationValue>
<xsl:value-of select="$NovationFeeAdditionalPriceNotationValue"/>
</NovationFeeAdditionalPriceNotationValue>
</xsl:if>
<xsl:if test="$NovationFeeDFDataPresent">
<NovationFeeDFDataPresent>
<xsl:value-of select="$NovationFeeDFDataPresent"/>
</NovationFeeDFDataPresent>
</xsl:if>
<xsl:if test="$NovationFeeDFRegulatorType">
<NovationFeeDFRegulatorType>
<xsl:value-of select="$NovationFeeDFRegulatorType"/>
</NovationFeeDFRegulatorType>
</xsl:if>
<xsl:if test="$NovationFeeRoute1Destination">
<NovationFeeRoute1Destination>
<xsl:value-of select="$NovationFeeRoute1Destination"/>
</NovationFeeRoute1Destination>
</xsl:if>
<xsl:if test="$NovationFeeRoute1Intermediary">
<NovationFeeRoute1Intermediary>
<xsl:value-of select="$NovationFeeRoute1Intermediary"/>
</NovationFeeRoute1Intermediary>
</xsl:if>
<xsl:if test="$NovationFeeUSINamespace">
<NovationFeeUSINamespace>
<xsl:value-of select="$NovationFeeUSINamespace"/>
</NovationFeeUSINamespace>
</xsl:if>
<xsl:if test="$NovationFeeUSINamespacePrefix">
<NovationFeeUSINamespacePrefix>
<xsl:value-of select="$NovationFeeUSINamespacePrefix"/>
</NovationFeeUSINamespacePrefix>
</xsl:if>
<xsl:if test="$NovationFeeUSI">
<NovationFeeUSI>
<xsl:value-of select="$NovationFeeUSI"/>
</NovationFeeUSI>
</xsl:if>
<xsl:if test="$NovationFeeGlobalUTI">
<NovationFeeGlobalUTI>
<xsl:value-of select="$NovationFeeGlobalUTI"/>
</NovationFeeGlobalUTI>
</xsl:if>
<xsl:if test="$NovationFeeObligatoryReporting">
<NovationFeeObligatoryReporting>
<xsl:value-of select="$NovationFeeObligatoryReporting"/>
</NovationFeeObligatoryReporting>
</xsl:if>
<xsl:if test="$NovationFeeReportingCounterparty">
<NovationFeeReportingCounterparty>
<xsl:value-of select="$NovationFeeReportingCounterparty"/>
</NovationFeeReportingCounterparty>
</xsl:if>
<xsl:if test="$NovationFeeDFClearingMandatory">
<NovationFeeDFClearingMandatory>
<xsl:value-of select="$NovationFeeDFClearingMandatory"/>
</NovationFeeDFClearingMandatory>
</xsl:if>
</xsl:template>
<xsl:template name="lcl:PriceNotation">
<xsl:param name="PriceNotationType" select="/.."/>
<xsl:param name="PriceNotationValue" select="/.."/>
<xsl:param name="id" select="/.."/>
<PriceNotation>
<xsl:if test="$id">
<xsl:attribute name="id">
<xsl:value-of select="$id"/>
</xsl:attribute>
</xsl:if>
<PriceNotationType>
<xsl:value-of select="$PriceNotationType"/>
</PriceNotationType>
<PriceNotationValue>
<xsl:value-of select="$PriceNotationValue"/>
</PriceNotationValue>
</PriceNotation>
</xsl:template>
<xsl:template name="lcl:AdditionalPriceNotation">
<xsl:param name="AdditionalPriceNotationType" select="/.."/>
<xsl:param name="AdditionalPriceNotationValue" select="/.."/>
<xsl:param name="id" select="/.."/>
<AdditionalPriceNotation>
<xsl:if test="$id">
<xsl:attribute name="id">
<xsl:value-of select="$id"/>
</xsl:attribute>
</xsl:if>
<AdditionalPriceNotationType>
<xsl:value-of select="$AdditionalPriceNotationType"/>
</AdditionalPriceNotationType>
<AdditionalPriceNotationValue>
<xsl:value-of select="$AdditionalPriceNotationValue"/>
</AdditionalPriceNotationValue>
</AdditionalPriceNotation>
</xsl:template>
<xsl:template name="lcl:JFSAData">
<xsl:param name="JFSADataPresent" select="/.."/>
<xsl:param name="JFSANewNovatedDataPresent" select="/.."/>
<xsl:param name="JFSANovatedDataPresent" select="/.."/>
<xsl:param name="JFSAUTINamespace" select="/.."/>
<xsl:param name="JFSAUTINamespacePrefix" select="/.."/>
<xsl:param name="JFSAUTI" select="/.."/>
<xsl:param name="JFSAIntentToBlankUTINamespace" select="/.."/>
<xsl:param name="JFSAIntentToBlankUTI" select="/.."/>
<xsl:param name="JFSANewNovatedUTINamespace" select="/.."/>
<xsl:param name="JFSANewNovatedUTINamespacePrefix" select="/.."/>
<xsl:param name="JFSANewNovatedUTI" select="/.."/>
<xsl:param name="JFSANovatedUTINamespace" select="/.."/>
<xsl:param name="JFSANovatedUTINamespacePrefix" select="/.."/>
<xsl:param name="JFSANovatedUTI" select="/.."/>
<xsl:if test="$JFSADataPresent">
<JFSADataPresent>
<xsl:value-of select="$JFSADataPresent"/>
</JFSADataPresent>
</xsl:if>
<xsl:if test="$JFSANewNovatedDataPresent">
<JFSANewNovatedDataPresent>
<xsl:value-of select="$JFSANewNovatedDataPresent"/>
</JFSANewNovatedDataPresent>
</xsl:if>
<xsl:if test="$JFSANovatedDataPresent">
<JFSANovatedDataPresent>
<xsl:value-of select="$JFSANovatedDataPresent"/>
</JFSANovatedDataPresent>
</xsl:if>
<xsl:if test="$JFSAUTINamespace">
<JFSAUTINamespace>
<xsl:value-of select="$JFSAUTINamespace"/>
</JFSAUTINamespace>
</xsl:if>
<xsl:if test="$JFSAUTINamespacePrefix">
<JFSAUTINamespacePrefix>
<xsl:value-of select="$JFSAUTINamespacePrefix"/>
</JFSAUTINamespacePrefix>
</xsl:if>
<xsl:if test="$JFSAUTI">
<JFSAUTI>
<xsl:value-of select="$JFSAUTI"/>
</JFSAUTI>
</xsl:if>
<xsl:if test="$JFSAIntentToBlankUTINamespace">
<JFSAIntentToBlankUTINamespace>
<xsl:value-of select="$JFSAIntentToBlankUTINamespace"/>
</JFSAIntentToBlankUTINamespace>
</xsl:if>
<xsl:if test="$JFSAIntentToBlankUTI">
<JFSAIntentToBlankUTI>
<xsl:value-of select="$JFSAIntentToBlankUTI"/>
</JFSAIntentToBlankUTI>
</xsl:if>
<xsl:if test="$JFSANewNovatedUTINamespace">
<JFSANewNovatedUTINamespace>
<xsl:value-of select="$JFSANewNovatedUTINamespace"/>
</JFSANewNovatedUTINamespace>
</xsl:if>
<xsl:if test="$JFSANewNovatedUTINamespacePrefix">
<JFSANewNovatedUTINamespacePrefix>
<xsl:value-of select="$JFSANewNovatedUTINamespacePrefix"/>
</JFSANewNovatedUTINamespacePrefix>
</xsl:if>
<xsl:if test="$JFSANewNovatedUTI">
<JFSANewNovatedUTI>
<xsl:value-of select="$JFSANewNovatedUTI"/>
</JFSANewNovatedUTI>
</xsl:if>
<xsl:if test="$JFSANovatedUTINamespace">
<JFSANovatedUTINamespace>
<xsl:value-of select="$JFSANovatedUTINamespace"/>
</JFSANovatedUTINamespace>
</xsl:if>
<xsl:if test="$JFSANovatedUTINamespacePrefix">
<JFSANovatedUTINamespacePrefix>
<xsl:value-of select="$JFSANovatedUTINamespacePrefix"/>
</JFSANovatedUTINamespacePrefix>
</xsl:if>
<xsl:if test="$JFSANovatedUTI">
<JFSANovatedUTI>
<xsl:value-of select="$JFSANovatedUTI"/>
</JFSANovatedUTI>
</xsl:if>
</xsl:template>
<xsl:template name="lcl:ESMAData">
<xsl:param name="ESMADataPresent" select="/.."/>
<xsl:param name="ESMANewNovatedDataPresent" select="/.."/>
<xsl:param name="ESMANovatedDataPresent" select="/.."/>
<xsl:param name="ESMAUTINamespace" select="/.."/>
<xsl:param name="ESMAUTINamespacePrefix" select="/.."/>
<xsl:param name="ESMAUTI" select="/.."/>
<xsl:param name="ESMAIntentToBlankUTINamespace" select="/.."/>
<xsl:param name="ESMAIntentToBlankUTI" select="/.."/>
<xsl:param name="ESMANewNovatedUTINamespace" select="/.."/>
<xsl:param name="ESMANewNovatedUTINamespacePrefix" select="/.."/>
<xsl:param name="ESMANewNovatedUTI" select="/.."/>
<xsl:param name="ESMANovatedUTINamespace" select="/.."/>
<xsl:param name="ESMANovatedUTINamespacePrefix" select="/.."/>
<xsl:param name="ESMANovatedUTI" select="/.."/>
<xsl:if test="$ESMADataPresent">
<ESMADataPresent>
<xsl:value-of select="$ESMADataPresent"/>
</ESMADataPresent>
</xsl:if>
<xsl:if test="$ESMANewNovatedDataPresent">
<ESMANewNovatedDataPresent>
<xsl:value-of select="$ESMANewNovatedDataPresent"/>
</ESMANewNovatedDataPresent>
</xsl:if>
<xsl:if test="$ESMANovatedDataPresent">
<ESMANovatedDataPresent>
<xsl:value-of select="$ESMANovatedDataPresent"/>
</ESMANovatedDataPresent>
</xsl:if>
<xsl:if test="$ESMAUTINamespace">
<ESMAUTINamespace>
<xsl:value-of select="$ESMAUTINamespace"/>
</ESMAUTINamespace>
</xsl:if>
<xsl:if test="$ESMAUTINamespacePrefix">
<ESMAUTINamespacePrefix>
<xsl:value-of select="$ESMAUTINamespacePrefix"/>
</ESMAUTINamespacePrefix>
</xsl:if>
<xsl:if test="$ESMAUTI">
<ESMAUTI>
<xsl:value-of select="$ESMAUTI"/>
</ESMAUTI>
</xsl:if>
<xsl:if test="$ESMAIntentToBlankUTINamespace">
<ESMAIntentToBlankUTINamespace>
<xsl:value-of select="$ESMAIntentToBlankUTINamespace"/>
</ESMAIntentToBlankUTINamespace>
</xsl:if>
<xsl:if test="$ESMAIntentToBlankUTI">
<ESMAIntentToBlankUTI>
<xsl:value-of select="$ESMAIntentToBlankUTI"/>
</ESMAIntentToBlankUTI>
</xsl:if>
<xsl:if test="$ESMANewNovatedUTINamespace">
<ESMANewNovatedUTINamespace>
<xsl:value-of select="$ESMANewNovatedUTINamespace"/>
</ESMANewNovatedUTINamespace>
</xsl:if>
<xsl:if test="$ESMANewNovatedUTINamespacePrefix">
<ESMANewNovatedUTINamespacePrefix>
<xsl:value-of select="$ESMANewNovatedUTINamespacePrefix"/>
</ESMANewNovatedUTINamespacePrefix>
</xsl:if>
<xsl:if test="$ESMANewNovatedUTI">
<ESMANewNovatedUTI>
<xsl:value-of select="$ESMANewNovatedUTI"/>
</ESMANewNovatedUTI>
</xsl:if>
<xsl:if test="$ESMANovatedUTINamespace">
<ESMANovatedUTINamespace>
<xsl:value-of select="$ESMANovatedUTINamespace"/>
</ESMANovatedUTINamespace>
</xsl:if>
<xsl:if test="$ESMANovatedUTINamespacePrefix">
<ESMANovatedUTINamespacePrefix>
<xsl:value-of select="$ESMANovatedUTINamespacePrefix"/>
</ESMANovatedUTINamespacePrefix>
</xsl:if>
<xsl:if test="$ESMANovatedUTI">
<ESMANovatedUTI>
<xsl:value-of select="$ESMANovatedUTI"/>
</ESMANovatedUTI>
</xsl:if>
</xsl:template>
<xsl:template name="lcl:HKMAData">
<xsl:param name="HKMADataPresent" select="/.."/>
<xsl:param name="HKMANewNovatedDataPresent" select="/.."/>
<xsl:param name="HKMANovatedDataPresent" select="/.."/>
<xsl:param name="HKMAUTINamespace" select="/.."/>
<xsl:param name="HKMAUTINamespacePrefix" select="/.."/>
<xsl:param name="HKMAUTI" select="/.."/>
<xsl:param name="HKMAIntentToBlankUTINamespace" select="/.."/>
<xsl:param name="HKMAIntentToBlankUTI" select="/.."/>
<xsl:param name="HKMANewNovatedUTINamespace" select="/.."/>
<xsl:param name="HKMANewNovatedUTINamespacePrefix" select="/.."/>
<xsl:param name="HKMANewNovatedUTI" select="/.."/>
<xsl:param name="HKMANovatedUTINamespace" select="/.."/>
<xsl:param name="HKMANovatedUTINamespacePrefix" select="/.."/>
<xsl:param name="HKMANovatedUTI" select="/.."/>
<xsl:if test="$HKMADataPresent">
<HKMADataPresent>
<xsl:value-of select="$HKMADataPresent"/>
</HKMADataPresent>
</xsl:if>
<xsl:if test="$HKMANewNovatedDataPresent">
<HKMANewNovatedDataPresent>
<xsl:value-of select="$HKMANewNovatedDataPresent"/>
</HKMANewNovatedDataPresent>
</xsl:if>
<xsl:if test="$HKMANovatedDataPresent">
<HKMANovatedDataPresent>
<xsl:value-of select="$HKMANovatedDataPresent"/>
</HKMANovatedDataPresent>
</xsl:if>
<xsl:if test="$HKMAUTINamespace">
<HKMAUTINamespace>
<xsl:value-of select="$HKMAUTINamespace"/>
</HKMAUTINamespace>
</xsl:if>
<xsl:if test="$HKMAUTINamespacePrefix">
<HKMAUTINamespacePrefix>
<xsl:value-of select="$HKMAUTINamespacePrefix"/>
</HKMAUTINamespacePrefix>
</xsl:if>
<xsl:if test="$HKMAUTI">
<HKMAUTI>
<xsl:value-of select="$HKMAUTI"/>
</HKMAUTI>
</xsl:if>
<xsl:if test="$HKMAIntentToBlankUTINamespace">
<HKMAIntentToBlankUTINamespace>
<xsl:value-of select="$HKMAIntentToBlankUTINamespace"/>
</HKMAIntentToBlankUTINamespace>
</xsl:if>
<xsl:if test="$HKMAIntentToBlankUTI">
<HKMAIntentToBlankUTI>
<xsl:value-of select="$HKMAIntentToBlankUTI"/>
</HKMAIntentToBlankUTI>
</xsl:if>
<xsl:if test="$HKMANewNovatedUTINamespace">
<HKMANewNovatedUTINamespace>
<xsl:value-of select="$HKMANewNovatedUTINamespace"/>
</HKMANewNovatedUTINamespace>
</xsl:if>
<xsl:if test="$HKMANewNovatedUTINamespacePrefix">
<HKMANewNovatedUTINamespacePrefix>
<xsl:value-of select="$HKMANewNovatedUTINamespacePrefix"/>
</HKMANewNovatedUTINamespacePrefix>
</xsl:if>
<xsl:if test="$HKMANewNovatedUTI">
<HKMANewNovatedUTI>
<xsl:value-of select="$HKMANewNovatedUTI"/>
</HKMANewNovatedUTI>
</xsl:if>
<xsl:if test="$HKMANovatedUTINamespace">
<HKMANovatedUTINamespace>
<xsl:value-of select="$HKMANovatedUTINamespace"/>
</HKMANovatedUTINamespace>
</xsl:if>
<xsl:if test="$HKMANovatedUTINamespacePrefix">
<HKMANovatedUTINamespacePrefix>
<xsl:value-of select="$HKMANovatedUTINamespacePrefix"/>
</HKMANovatedUTINamespacePrefix>
</xsl:if>
<xsl:if test="$HKMANovatedUTI">
<HKMANovatedUTI>
<xsl:value-of select="$HKMANovatedUTI"/>
</HKMANovatedUTI>
</xsl:if>
</xsl:template>
<xsl:template name="lcl:CAData">
<xsl:param name="CADataPresent" select="/.."/>
<xsl:param name="CAObligatoryReporting" select="/.."/>
<xsl:param name="CAReportableLocationsA" select="/.."/>
<xsl:param name="CAReportableLocationsB" select="/.."/>
<xsl:param name="CAReportableLocationsC" select="/.."/>
<xsl:param name="CAReportableLocationsD" select="/.."/>
<xsl:param name="CAReportingCounterparty" select="/.."/>
<xsl:param name="CANewNovatedDataPresent" select="/.."/>
<xsl:param name="CANovatedDataPresent" select="/.."/>
<xsl:param name="CAUTINamespace" select="/.."/>
<xsl:param name="CAUTINamespacePrefix" select="/.."/>
<xsl:param name="CAUTI" select="/.."/>
<xsl:param name="CAIntentToBlankUTINamespace" select="/.."/>
<xsl:param name="CAIntentToBlankUTI" select="/.."/>
<xsl:param name="CANewNovatedUTINamespace" select="/.."/>
<xsl:param name="CANewNovatedUTINamespacePrefix" select="/.."/>
<xsl:param name="CANewNovatedUTI" select="/.."/>
<xsl:param name="CANovatedUTINamespace" select="/.."/>
<xsl:param name="CANovatedUTINamespacePrefix" select="/.."/>
<xsl:param name="CANovatedUTI" select="/.."/>
<xsl:param name="NovationFeeCAPriceNotationType" select="/.."/>
<xsl:param name="NovationFeeCAPriceNotationValue" select="/.."/>
<xsl:param name="NovationFeeCAAdditionalPriceNotationType" select="/.."/>
<xsl:param name="NovationFeeCAAdditionalPriceNotationValue" select="/.."/>
<xsl:param name="NovationFeeCADataPresent" select="/.."/>
<xsl:param name="NovationFeeCARegulatorType" select="/.."/>
<xsl:param name="NovationFeeCARoute1Destination" select="/.."/>
<xsl:param name="NovationFeeCARoute1Intermediary" select="/.."/>
<xsl:param name="NovationFeeCAUTINamespace" select="/.."/>
<xsl:param name="NovationFeeCAUTINamespacePrefix" select="/.."/>
<xsl:param name="NovationFeeCAUTI" select="/.."/>
<xsl:param name="NovationFeeCAObligatoryReporting" select="/.."/>
<xsl:param name="NovationFeeCAReportingCounterparty" select="/.."/>
<xsl:param name="NovationFeeCAClearingMandatory" select="/.."/>
<xsl:param name="NovationFeeCAReportableLocationsA" select="/.."/>
<xsl:param name="NovationFeeCAReportableLocationsB" select="/.."/>
<xsl:param name="NovationFeeCAReportableLocationsC" select="/.."/>
<xsl:param name="NovationFeeCAReportableLocationsD" select="/.."/>
<xsl:if test="$CADataPresent">
<CADataPresent>
<xsl:value-of select="$CADataPresent"/>
</CADataPresent>
</xsl:if>
<xsl:if test="$CAObligatoryReporting">
<CAObligatoryReporting>
<xsl:value-of select="$CAObligatoryReporting"/>
</CAObligatoryReporting>
</xsl:if>
<xsl:if test="$CAReportableLocationsA">
<CAReportableLocationsA>
<xsl:value-of select="$CAReportableLocationsA"/>
</CAReportableLocationsA>
</xsl:if>
<xsl:if test="$CAReportableLocationsB">
<CAReportableLocationsB>
<xsl:value-of select="$CAReportableLocationsB"/>
</CAReportableLocationsB>
</xsl:if>
<xsl:if test="$CAReportableLocationsC">
<CAReportableLocationsC>
<xsl:value-of select="$CAReportableLocationsC"/>
</CAReportableLocationsC>
</xsl:if>
<xsl:if test="$CAReportableLocationsD">
<CAReportableLocationsD>
<xsl:value-of select="$CAReportableLocationsD"/>
</CAReportableLocationsD>
</xsl:if>
<xsl:if test="$CAReportingCounterparty">
<CAReportingCounterparty>
<xsl:value-of select="$CAReportingCounterparty"/>
</CAReportingCounterparty>
</xsl:if>
<xsl:if test="$CANewNovatedDataPresent">
<CANewNovatedDataPresent>
<xsl:value-of select="$CANewNovatedDataPresent"/>
</CANewNovatedDataPresent>
</xsl:if>
<xsl:if test="$CANovatedDataPresent">
<CANovatedDataPresent>
<xsl:value-of select="$CANovatedDataPresent"/>
</CANovatedDataPresent>
</xsl:if>
<xsl:if test="$CAUTINamespace">
<CAUTINamespace>
<xsl:value-of select="$CAUTINamespace"/>
</CAUTINamespace>
</xsl:if>
<xsl:if test="$CAUTINamespacePrefix">
<CAUTINamespacePrefix>
<xsl:value-of select="$CAUTINamespacePrefix"/>
</CAUTINamespacePrefix>
</xsl:if>
<xsl:if test="$CAUTI">
<CAUTI>
<xsl:value-of select="$CAUTI"/>
</CAUTI>
</xsl:if>
<xsl:if test="$CAIntentToBlankUTINamespace">
<CAIntentToBlankUTINamespace>
<xsl:value-of select="$CAIntentToBlankUTINamespace"/>
</CAIntentToBlankUTINamespace>
</xsl:if>
<xsl:if test="$CAIntentToBlankUTI">
<CAIntentToBlankUTI>
<xsl:value-of select="$CAIntentToBlankUTI"/>
</CAIntentToBlankUTI>
</xsl:if>
<xsl:if test="$CANewNovatedUTINamespace">
<CANewNovatedUTINamespace>
<xsl:value-of select="$CANewNovatedUTINamespace"/>
</CANewNovatedUTINamespace>
</xsl:if>
<xsl:if test="$CANewNovatedUTINamespacePrefix">
<CANewNovatedUTINamespacePrefix>
<xsl:value-of select="$CANewNovatedUTINamespacePrefix"/>
</CANewNovatedUTINamespacePrefix>
</xsl:if>
<xsl:if test="$CANewNovatedUTI">
<CANewNovatedUTI>
<xsl:value-of select="$CANewNovatedUTI"/>
</CANewNovatedUTI>
</xsl:if>
<xsl:if test="$CANovatedUTINamespace">
<CANovatedUTINamespace>
<xsl:value-of select="$CANovatedUTINamespace"/>
</CANovatedUTINamespace>
</xsl:if>
<xsl:if test="$CANovatedUTINamespacePrefix">
<CANovatedUTINamespacePrefix>
<xsl:value-of select="$CANovatedUTINamespacePrefix"/>
</CANovatedUTINamespacePrefix>
</xsl:if>
<xsl:if test="$CANovatedUTI">
<CANovatedUTI>
<xsl:value-of select="$CANovatedUTI"/>
</CANovatedUTI>
</xsl:if>
<xsl:if test="$NovationFeeCAPriceNotationType">
<NovationFeeCAPriceNotationType>
<xsl:value-of select="$NovationFeeCAPriceNotationType"/>
</NovationFeeCAPriceNotationType>
</xsl:if>
<xsl:if test="$NovationFeeCAPriceNotationValue">
<NovationFeeCAPriceNotationValue>
<xsl:value-of select="$NovationFeeCAPriceNotationValue"/>
</NovationFeeCAPriceNotationValue>
</xsl:if>
<xsl:if test="$NovationFeeCAAdditionalPriceNotationType">
<NovationFeeCAAdditionalPriceNotationType>
<xsl:value-of select="$NovationFeeCAAdditionalPriceNotationType"/>
</NovationFeeCAAdditionalPriceNotationType>
</xsl:if>
<xsl:if test="$NovationFeeCAAdditionalPriceNotationValue">
<NovationFeeCAAdditionalPriceNotationValue>
<xsl:value-of select="$NovationFeeCAAdditionalPriceNotationValue"/>
</NovationFeeCAAdditionalPriceNotationValue>
</xsl:if>
<xsl:if test="$NovationFeeCADataPresent">
<NovationFeeCADataPresent>
<xsl:value-of select="$NovationFeeCADataPresent"/>
</NovationFeeCADataPresent>
</xsl:if>
<xsl:if test="$NovationFeeCARegulatorType">
<NovationFeeCARegulatorType>
<xsl:value-of select="$NovationFeeCARegulatorType"/>
</NovationFeeCARegulatorType>
</xsl:if>
<xsl:if test="$NovationFeeCARoute1Destination">
<NovationFeeCARoute1Destination>
<xsl:value-of select="$NovationFeeCARoute1Destination"/>
</NovationFeeCARoute1Destination>
</xsl:if>
<xsl:if test="$NovationFeeCARoute1Intermediary">
<NovationFeeCARoute1Intermediary>
<xsl:value-of select="$NovationFeeCARoute1Intermediary"/>
</NovationFeeCARoute1Intermediary>
</xsl:if>
<xsl:if test="$NovationFeeCAUTINamespace">
<NovationFeeCAUTINamespace>
<xsl:value-of select="$NovationFeeCAUTINamespace"/>
</NovationFeeCAUTINamespace>
</xsl:if>
<xsl:if test="$NovationFeeCAUTINamespacePrefix">
<NovationFeeCAUTINamespacePrefix>
<xsl:value-of select="$NovationFeeCAUTINamespacePrefix"/>
</NovationFeeCAUTINamespacePrefix>
</xsl:if>
<xsl:if test="$NovationFeeCAUTI">
<NovationFeeCAUTI>
<xsl:value-of select="$NovationFeeCAUTI"/>
</NovationFeeCAUTI>
</xsl:if>
<xsl:if test="$NovationFeeCAObligatoryReporting">
<NovationFeeCAObligatoryReporting>
<xsl:value-of select="$NovationFeeCAObligatoryReporting"/>
</NovationFeeCAObligatoryReporting>
</xsl:if>
<xsl:if test="$NovationFeeCAReportingCounterparty">
<NovationFeeCAReportingCounterparty>
<xsl:value-of select="$NovationFeeCAReportingCounterparty"/>
</NovationFeeCAReportingCounterparty>
</xsl:if>
<xsl:if test="$NovationFeeCAClearingMandatory">
<NovationFeeCAClearingMandatory>
<xsl:value-of select="$NovationFeeCAClearingMandatory"/>
</NovationFeeCAClearingMandatory>
</xsl:if>
<xsl:if test="$NovationFeeCAReportableLocationsA">
<NovationFeeCAReportableLocationsA>
<xsl:value-of select="$NovationFeeCAReportableLocationsA"/>
</NovationFeeCAReportableLocationsA>
</xsl:if>
<xsl:if test="$NovationFeeCAReportableLocationsB">
<NovationFeeCAReportableLocationsB>
<xsl:value-of select="$NovationFeeCAReportableLocationsB"/>
</NovationFeeCAReportableLocationsB>
</xsl:if>
<xsl:if test="$NovationFeeCAReportableLocationsC">
<NovationFeeCAReportableLocationsC>
<xsl:value-of select="$NovationFeeCAReportableLocationsC"/>
</NovationFeeCAReportableLocationsC>
</xsl:if>
<xsl:if test="$NovationFeeCAReportableLocationsD">
<NovationFeeCAReportableLocationsD>
<xsl:value-of select="$NovationFeeCAReportableLocationsD"/>
</NovationFeeCAReportableLocationsD>
</xsl:if>
</xsl:template>
<xsl:template name="lcl:SEData">
<xsl:param name="SEDataPresent" select="/.."/>
<xsl:param name="SERegulatorType" select="/.."/>
<xsl:param name="SERoute1Destination" select="/.."/>
<xsl:param name="Route1Intermediary" select="/.."/>
<xsl:param name="SEUTINamespace" select="/.."/>
<xsl:param name="SEIntentToBlankUTINamespace" select="/.."/>
<xsl:param name="SEUTINamespacePrefix" select="/.."/>
<xsl:param name="SEUTI" select="/.."/>
<xsl:param name="SEIntentToBlankUTI" select="/.."/>
<xsl:param name="SEObligatoryReporting" select="/.."/>
<xsl:param name="SEReportingCounterparty" select="/.."/>
<xsl:param name="NewNovatedSEDataPresent" select="/.."/>
<xsl:param name="NewNovatedSERegulatorType" select="/.."/>
<xsl:param name="NewNovatedSERoute1Destination" select="/.."/>
<xsl:param name="NewNovatedRoute1Intermediary" select="/.."/>
<xsl:param name="NewNovatedSEUTINamespace" select="/.."/>
<xsl:param name="NewNovatedSEUTINamespacePrefix" select="/.."/>
<xsl:param name="NewNovatedSEUTI" select="/.."/>
<xsl:param name="NewNovatedSEObligatoryReporting" select="/.."/>
<xsl:param name="NewNovatedSEReportingCounterparty" select="/.."/>
<xsl:param name="NovatedSEDataPresent" select="/.."/>
<xsl:param name="NovatedSERegulatorType" select="/.."/>
<xsl:param name="NovatedSEUTINamespace" select="/.."/>
<xsl:param name="NovatedSEUTINamespacePrefix" select="/.."/>
<xsl:param name="NovatedSEUTI" select="/.."/>
<xsl:param name="NovatedSEObligatoryReporting" select="/.."/>
<xsl:param name="NovatedSEReportingCounterparty" select="/.."/>
<xsl:param name="NovationFeeSEDataPresent" select="/.."/>
<xsl:param name="NovationFeeSERegulatorType" select="/.."/>
<xsl:param name="NovationFeeSERoute1Destination" select="/.."/>
<xsl:param name="NovationFeeRoute1Intermediary" select="/.."/>
<xsl:param name="NovationFeeSEUTINamespace" select="/.."/>
<xsl:param name="NovationFeeSEUTINamespacePrefix" select="/.."/>
<xsl:param name="NovationFeeSEUTI" select="/.."/>
<xsl:param name="NovationFeeSEObligatoryReporting" select="/.."/>
<xsl:param name="NovationFeeSEReportingCounterparty" select="/.."/>
<xsl:if test="$SEDataPresent">
<SEDataPresent>
<xsl:value-of select="$SEDataPresent"/>
</SEDataPresent>
</xsl:if>
<xsl:if test="$SERegulatorType">
<SERegulatorType>
<xsl:value-of select="$SERegulatorType"/>
</SERegulatorType>
</xsl:if>
<xsl:if test="$SERoute1Destination">
<SERoute1Destination>
<xsl:value-of select="$SERoute1Destination"/>
</SERoute1Destination>
</xsl:if>
<xsl:if test="$Route1Intermediary">
<Route1Intermediary>
<xsl:value-of select="$Route1Intermediary"/>
</Route1Intermediary>
</xsl:if>
<xsl:if test="$SEUTINamespace">
<SEUTINamespace>
<xsl:value-of select="$SEUTINamespace"/>
</SEUTINamespace>
</xsl:if>
<xsl:if test="$SEIntentToBlankUTINamespace">
<SEIntentToBlankUTINamespace>
<xsl:value-of select="$SEIntentToBlankUTINamespace"/>
</SEIntentToBlankUTINamespace>
</xsl:if>
<xsl:if test="$SEUTINamespacePrefix">
<SEUTINamespacePrefix>
<xsl:value-of select="$SEUTINamespacePrefix"/>
</SEUTINamespacePrefix>
</xsl:if>
<xsl:if test="$SEUTI">
<SEUTI>
<xsl:value-of select="$SEUTI"/>
</SEUTI>
</xsl:if>
<xsl:if test="$SEIntentToBlankUTI">
<SEIntentToBlankUTI>
<xsl:value-of select="$SEIntentToBlankUTI"/>
</SEIntentToBlankUTI>
</xsl:if>
<xsl:if test="$SEObligatoryReporting">
<SEObligatoryReporting>
<xsl:value-of select="$SEObligatoryReporting"/>
</SEObligatoryReporting>
</xsl:if>
<xsl:if test="$SEReportingCounterparty">
<SEReportingCounterparty>
<xsl:value-of select="$SEReportingCounterparty"/>
</SEReportingCounterparty>
</xsl:if>
<xsl:if test="$NewNovatedSEDataPresent">
<NewNovatedSEDataPresent>
<xsl:value-of select="$NewNovatedSEDataPresent"/>
</NewNovatedSEDataPresent>
</xsl:if>
<xsl:if test="$NewNovatedSERegulatorType">
<NewNovatedSERegulatorType>
<xsl:value-of select="$NewNovatedSERegulatorType"/>
</NewNovatedSERegulatorType>
</xsl:if>
<xsl:if test="$NewNovatedSERoute1Destination">
<NewNovatedSERoute1Destination>
<xsl:value-of select="$NewNovatedSERoute1Destination"/>
</NewNovatedSERoute1Destination>
</xsl:if>
<xsl:if test="$NewNovatedRoute1Intermediary">
<NewNovatedRoute1Intermediary>
<xsl:value-of select="$NewNovatedRoute1Intermediary"/>
</NewNovatedRoute1Intermediary>
</xsl:if>
<xsl:if test="$NewNovatedSEUTINamespace">
<NewNovatedSEUTINamespace>
<xsl:value-of select="$NewNovatedSEUTINamespace"/>
</NewNovatedSEUTINamespace>
</xsl:if>
<xsl:if test="$NewNovatedSEUTINamespacePrefix">
<NewNovatedSEUTINamespacePrefix>
<xsl:value-of select="$NewNovatedSEUTINamespacePrefix"/>
</NewNovatedSEUTINamespacePrefix>
</xsl:if>
<xsl:if test="$NewNovatedSEUTI">
<NewNovatedSEUTI>
<xsl:value-of select="$NewNovatedSEUTI"/>
</NewNovatedSEUTI>
</xsl:if>
<xsl:if test="$NewNovatedSEObligatoryReporting">
<NewNovatedSEObligatoryReporting>
<xsl:value-of select="$NewNovatedSEObligatoryReporting"/>
</NewNovatedSEObligatoryReporting>
</xsl:if>
<xsl:if test="$NewNovatedSEReportingCounterparty">
<NewNovatedSEReportingCounterparty>
<xsl:value-of select="$NewNovatedSEReportingCounterparty"/>
</NewNovatedSEReportingCounterparty>
</xsl:if>
<xsl:if test="$NovatedSEDataPresent">
<NovatedSEDataPresent>
<xsl:value-of select="$NovatedSEDataPresent"/>
</NovatedSEDataPresent>
</xsl:if>
<xsl:if test="$NovatedSERegulatorType">
<NovatedSERegulatorType>
<xsl:value-of select="$NovatedSERegulatorType"/>
</NovatedSERegulatorType>
</xsl:if>
<xsl:if test="$NovatedSEUTINamespace">
<NovatedSEUTINamespace>
<xsl:value-of select="$NovatedSEUTINamespace"/>
</NovatedSEUTINamespace>
</xsl:if>
<xsl:if test="$NovatedSEUTINamespacePrefix">
<NovatedSEUTINamespacePrefix>
<xsl:value-of select="$NovatedSEUTINamespacePrefix"/>
</NovatedSEUTINamespacePrefix>
</xsl:if>
<xsl:if test="$NovatedSEUTI">
<NovatedSEUTI>
<xsl:value-of select="$NovatedSEUTI"/>
</NovatedSEUTI>
</xsl:if>
<xsl:if test="$NovatedSEObligatoryReporting">
<NovatedSEObligatoryReporting>
<xsl:value-of select="$NovatedSEObligatoryReporting"/>
</NovatedSEObligatoryReporting>
</xsl:if>
<xsl:if test="$NovatedSEReportingCounterparty">
<NovatedSEReportingCounterparty>
<xsl:value-of select="$NovatedSEReportingCounterparty"/>
</NovatedSEReportingCounterparty>
</xsl:if>
<xsl:if test="$NovationFeeSEDataPresent">
<NovationFeeSEDataPresent>
<xsl:value-of select="$NovationFeeSEDataPresent"/>
</NovationFeeSEDataPresent>
</xsl:if>
<xsl:if test="$NovationFeeSERegulatorType">
<NovationFeeSERegulatorType>
<xsl:value-of select="$NovationFeeSERegulatorType"/>
</NovationFeeSERegulatorType>
</xsl:if>
<xsl:if test="$NovationFeeSERoute1Destination">
<NovationFeeSERoute1Destination>
<xsl:value-of select="$NovationFeeSERoute1Destination"/>
</NovationFeeSERoute1Destination>
</xsl:if>
<xsl:if test="$NovationFeeRoute1Intermediary">
<NovationFeeRoute1Intermediary>
<xsl:value-of select="$NovationFeeRoute1Intermediary"/>
</NovationFeeRoute1Intermediary>
</xsl:if>
<xsl:if test="$NovationFeeSEUTINamespace">
<NovationFeeSEUTINamespace>
<xsl:value-of select="$NovationFeeSEUTINamespace"/>
</NovationFeeSEUTINamespace>
</xsl:if>
<xsl:if test="$NovationFeeSEUTINamespacePrefix">
<NovationFeeSEUTINamespacePrefix>
<xsl:value-of select="$NovationFeeSEUTINamespacePrefix"/>
</NovationFeeSEUTINamespacePrefix>
</xsl:if>
<xsl:if test="$NovationFeeSEUTI">
<NovationFeeSEUTI>
<xsl:value-of select="$NovationFeeSEUTI"/>
</NovationFeeSEUTI>
</xsl:if>
<xsl:if test="$NovationFeeSEObligatoryReporting">
<NovationFeeSEObligatoryReporting>
<xsl:value-of select="$NovationFeeSEObligatoryReporting"/>
</NovationFeeSEObligatoryReporting>
</xsl:if>
<xsl:if test="$NovationFeeSEReportingCounterparty">
<NovationFeeSEReportingCounterparty>
<xsl:value-of select="$NovationFeeSEReportingCounterparty"/>
</NovationFeeSEReportingCounterparty>
</xsl:if>
</xsl:template>
<xsl:template name="lcl:MIData">
<xsl:param name="MIDataPresent" select="/.."/>
<xsl:param name="MIObligatoryReporting" select="/.."/>
<xsl:param name="MIReportingCounterparty" select="/.."/>
<xsl:param name="MINewNovatedDataPresent" select="/.."/>
<xsl:param name="MINovatedDataPresent" select="/.."/>
<xsl:param name="MIUTINamespace" select="/.."/>
<xsl:param name="MIUTINamespacePrefix" select="/.."/>
<xsl:param name="MIUTI" select="/.."/>
<xsl:param name="MIIntentToBlankUTINamespace" select="/.."/>
<xsl:param name="MIIntentToBlankUTI" select="/.."/>
<xsl:param name="MINewNovatedUTINamespace" select="/.."/>
<xsl:param name="MINewNovatedUTINamespacePrefix" select="/.."/>
<xsl:param name="MINewNovatedUTI" select="/.."/>
<xsl:param name="MINovatedUTINamespace" select="/.."/>
<xsl:param name="MINovatedUTINamespacePrefix" select="/.."/>
<xsl:param name="MINovatedUTI" select="/.."/>
<xsl:param name="MIToTV" select="/.."/>
<xsl:if test="$MIDataPresent">
<MIDataPresent>
<xsl:value-of select="$MIDataPresent"/>
</MIDataPresent>
</xsl:if>
<xsl:if test="$MIObligatoryReporting">
<MIObligatoryReporting>
<xsl:value-of select="$MIObligatoryReporting"/>
</MIObligatoryReporting>
</xsl:if>
<xsl:if test="$MIReportingCounterparty">
<MIReportingCounterparty>
<xsl:value-of select="$MIReportingCounterparty"/>
</MIReportingCounterparty>
</xsl:if>
<xsl:if test="$MINewNovatedDataPresent">
<MINewNovatedDataPresent>
<xsl:value-of select="$MINewNovatedDataPresent"/>
</MINewNovatedDataPresent>
</xsl:if>
<xsl:if test="$MINovatedDataPresent">
<MINovatedDataPresent>
<xsl:value-of select="$MINovatedDataPresent"/>
</MINovatedDataPresent>
</xsl:if>
<xsl:if test="$MIUTINamespace">
<MIUTINamespace>
<xsl:value-of select="$MIUTINamespace"/>
</MIUTINamespace>
</xsl:if>
<xsl:if test="$MIUTINamespacePrefix">
<MIUTINamespacePrefix>
<xsl:value-of select="$MIUTINamespacePrefix"/>
</MIUTINamespacePrefix>
</xsl:if>
<xsl:if test="$MIUTI">
<MIUTI>
<xsl:value-of select="$MIUTI"/>
</MIUTI>
</xsl:if>
<xsl:if test="$MIIntentToBlankUTINamespace">
<MIIntentToBlankUTINamespace>
<xsl:value-of select="$MIIntentToBlankUTINamespace"/>
</MIIntentToBlankUTINamespace>
</xsl:if>
<xsl:if test="$MIIntentToBlankUTI">
<MIIntentToBlankUTI>
<xsl:value-of select="$MIIntentToBlankUTI"/>
</MIIntentToBlankUTI>
</xsl:if>
<xsl:if test="$MINewNovatedUTINamespace">
<MINewNovatedUTINamespace>
<xsl:value-of select="$MINewNovatedUTINamespace"/>
</MINewNovatedUTINamespace>
</xsl:if>
<xsl:if test="$MINewNovatedUTINamespacePrefix">
<MINewNovatedUTINamespacePrefix>
<xsl:value-of select="$MINewNovatedUTINamespacePrefix"/>
</MINewNovatedUTINamespacePrefix>
</xsl:if>
<xsl:if test="$MINewNovatedUTI">
<MINewNovatedUTI>
<xsl:value-of select="$MINewNovatedUTI"/>
</MINewNovatedUTI>
</xsl:if>
<xsl:if test="$MINovatedUTINamespace">
<MINovatedUTINamespace>
<xsl:value-of select="$MINovatedUTINamespace"/>
</MINovatedUTINamespace>
</xsl:if>
<xsl:if test="$MINovatedUTINamespacePrefix">
<MINovatedUTINamespacePrefix>
<xsl:value-of select="$MINovatedUTINamespacePrefix"/>
</MINovatedUTINamespacePrefix>
</xsl:if>
<xsl:if test="$MINovatedUTI">
<MINovatedUTI>
<xsl:value-of select="$MINovatedUTI"/>
</MINovatedUTI>
</xsl:if>
<xsl:if test="$MIToTV">
<MIToTV>
<xsl:value-of select="$MIToTV"/>
</MIToTV>
</xsl:if>
</xsl:template>
<xsl:template name="lcl:ASICData">
<xsl:param name="ASICDataPresent" select="/.."/>
<xsl:param name="ASICNewNovatedDataPresent" select="/.."/>
<xsl:param name="ASICNovatedDataPresent" select="/.."/>
<xsl:param name="ASICUTINamespace" select="/.."/>
<xsl:param name="ASICUTINamespacePrefix" select="/.."/>
<xsl:param name="ASICUTI" select="/.."/>
<xsl:param name="ASICIntentToBlankUTINamespace" select="/.."/>
<xsl:param name="ASICIntentToBlankUTI" select="/.."/>
<xsl:param name="ASICNewNovatedUTINamespace" select="/.."/>
<xsl:param name="ASICNewNovatedUTINamespacePrefix" select="/.."/>
<xsl:param name="ASICNewNovatedUTI" select="/.."/>
<xsl:param name="ASICNovatedUTINamespace" select="/.."/>
<xsl:param name="ASICNovatedUTINamespacePrefix" select="/.."/>
<xsl:param name="ASICNovatedUTI" select="/.."/>
<xsl:if test="$ASICDataPresent">
<ASICDataPresent>
<xsl:value-of select="$ASICDataPresent"/>
</ASICDataPresent>
</xsl:if>
<xsl:if test="$ASICNewNovatedDataPresent">
<ASICNewNovatedDataPresent>
<xsl:value-of select="$ASICNewNovatedDataPresent"/>
</ASICNewNovatedDataPresent>
</xsl:if>
<xsl:if test="$ASICNovatedDataPresent">
<ASICNovatedDataPresent>
<xsl:value-of select="$ASICNovatedDataPresent"/>
</ASICNovatedDataPresent>
</xsl:if>
<xsl:if test="$ASICUTINamespace">
<ASICUTINamespace>
<xsl:value-of select="$ASICUTINamespace"/>
</ASICUTINamespace>
</xsl:if>
<xsl:if test="$ASICUTINamespacePrefix">
<ASICUTINamespacePrefix>
<xsl:value-of select="$ASICUTINamespacePrefix"/>
</ASICUTINamespacePrefix>
</xsl:if>
<xsl:if test="$ASICUTI">
<ASICUTI>
<xsl:value-of select="$ASICUTI"/>
</ASICUTI>
</xsl:if>
<xsl:if test="$ASICIntentToBlankUTINamespace">
<ASICIntentToBlankUTINamespace>
<xsl:value-of select="$ASICIntentToBlankUTINamespace"/>
</ASICIntentToBlankUTINamespace>
</xsl:if>
<xsl:if test="$ASICIntentToBlankUTI">
<ASICIntentToBlankUTI>
<xsl:value-of select="$ASICIntentToBlankUTI"/>
</ASICIntentToBlankUTI>
</xsl:if>
<xsl:if test="$ASICNewNovatedUTINamespace">
<ASICNewNovatedUTINamespace>
<xsl:value-of select="$ASICNewNovatedUTINamespace"/>
</ASICNewNovatedUTINamespace>
</xsl:if>
<xsl:if test="$ASICNewNovatedUTINamespacePrefix">
<ASICNewNovatedUTINamespacePrefix>
<xsl:value-of select="$ASICNewNovatedUTINamespacePrefix"/>
</ASICNewNovatedUTINamespacePrefix>
</xsl:if>
<xsl:if test="$ASICNewNovatedUTI">
<ASICNewNovatedUTI>
<xsl:value-of select="$ASICNewNovatedUTI"/>
</ASICNewNovatedUTI>
</xsl:if>
<xsl:if test="$ASICNovatedUTINamespace">
<ASICNovatedUTINamespace>
<xsl:value-of select="$ASICNovatedUTINamespace"/>
</ASICNovatedUTINamespace>
</xsl:if>
<xsl:if test="$ASICNovatedUTINamespacePrefix">
<ASICNovatedUTINamespacePrefix>
<xsl:value-of select="$ASICNovatedUTINamespacePrefix"/>
</ASICNovatedUTINamespacePrefix>
</xsl:if>
<xsl:if test="$ASICNovatedUTI">
<ASICNovatedUTI>
<xsl:value-of select="$ASICNovatedUTI"/>
</ASICNovatedUTI>
</xsl:if>
</xsl:template>
<xsl:template name="lcl:MASData">
<xsl:param name="MASDataPresent" select="/.."/>
<xsl:param name="MASNewNovatedDataPresent" select="/.."/>
<xsl:param name="MASNovatedDataPresent" select="/.."/>
<xsl:param name="MASUTINamespace" select="/.."/>
<xsl:param name="MASUTINamespacePrefix" select="/.."/>
<xsl:param name="MASUTI" select="/.."/>
<xsl:param name="MASIntentToBlankUTINamespace" select="/.."/>
<xsl:param name="MASIntentToBlankUTI" select="/.."/>
<xsl:param name="MASNewNovatedUTINamespace" select="/.."/>
<xsl:param name="MASNewNovatedUTINamespacePrefix" select="/.."/>
<xsl:param name="MASNewNovatedUTI" select="/.."/>
<xsl:param name="MASNovatedUTINamespace" select="/.."/>
<xsl:param name="MASNovatedUTINamespacePrefix" select="/.."/>
<xsl:param name="MASNovatedUTI" select="/.."/>
<xsl:if test="$MASDataPresent">
<MASDataPresent>
<xsl:value-of select="$MASDataPresent"/>
</MASDataPresent>
</xsl:if>
<xsl:if test="$MASNewNovatedDataPresent">
<MASNewNovatedDataPresent>
<xsl:value-of select="$MASNewNovatedDataPresent"/>
</MASNewNovatedDataPresent>
</xsl:if>
<xsl:if test="$MASNovatedDataPresent">
<MASNovatedDataPresent>
<xsl:value-of select="$MASNovatedDataPresent"/>
</MASNovatedDataPresent>
</xsl:if>
<xsl:if test="$MASUTINamespace">
<MASUTINamespace>
<xsl:value-of select="$MASUTINamespace"/>
</MASUTINamespace>
</xsl:if>
<xsl:if test="$MASUTINamespacePrefix">
<MASUTINamespacePrefix>
<xsl:value-of select="$MASUTINamespacePrefix"/>
</MASUTINamespacePrefix>
</xsl:if>
<xsl:if test="$MASUTI">
<MASUTI>
<xsl:value-of select="$MASUTI"/>
</MASUTI>
</xsl:if>
<xsl:if test="$MASIntentToBlankUTINamespace">
<MASIntentToBlankUTINamespace>
<xsl:value-of select="$MASIntentToBlankUTINamespace"/>
</MASIntentToBlankUTINamespace>
</xsl:if>
<xsl:if test="$MASIntentToBlankUTI">
<MASIntentToBlankUTI>
<xsl:value-of select="$MASIntentToBlankUTI"/>
</MASIntentToBlankUTI>
</xsl:if>
<xsl:if test="$MASNewNovatedUTINamespace">
<MASNewNovatedUTINamespace>
<xsl:value-of select="$MASNewNovatedUTINamespace"/>
</MASNewNovatedUTINamespace>
</xsl:if>
<xsl:if test="$MASNewNovatedUTINamespacePrefix">
<MASNewNovatedUTINamespacePrefix>
<xsl:value-of select="$MASNewNovatedUTINamespacePrefix"/>
</MASNewNovatedUTINamespacePrefix>
</xsl:if>
<xsl:if test="$MASNewNovatedUTI">
<MASNewNovatedUTI>
<xsl:value-of select="$MASNewNovatedUTI"/>
</MASNewNovatedUTI>
</xsl:if>
<xsl:if test="$MASNovatedUTINamespace">
<MASNovatedUTINamespace>
<xsl:value-of select="$MASNovatedUTINamespace"/>
</MASNovatedUTINamespace>
</xsl:if>
<xsl:if test="$MASNovatedUTINamespacePrefix">
<MASNovatedUTINamespacePrefix>
<xsl:value-of select="$MASNovatedUTINamespacePrefix"/>
</MASNovatedUTINamespacePrefix>
</xsl:if>
<xsl:if test="$MASNovatedUTI">
<MASNovatedUTI>
<xsl:value-of select="$MASNovatedUTI"/>
</MASNovatedUTI>
</xsl:if>
</xsl:template>
<xsl:template name="lcl:FCAData">
<xsl:param name="FCADataPresent" select="/.."/>
<xsl:param name="FCANewNovatedDataPresent" select="/.."/>
<xsl:param name="FCANovatedDataPresent" select="/.."/>
<xsl:param name="FCAUTINamespace" select="/.."/>
<xsl:param name="FCAUTINamespacePrefix" select="/.."/>
<xsl:param name="FCAUTI" select="/.."/>
<xsl:param name="FCAIntentToBlankUTINamespace" select="/.."/>
<xsl:param name="FCAIntentToBlankUTI" select="/.."/>
<xsl:param name="FCANewNovatedUTINamespace" select="/.."/>
<xsl:param name="FCANewNovatedUTINamespacePrefix" select="/.."/>
<xsl:param name="FCANewNovatedUTI" select="/.."/>
<xsl:param name="FCANovatedUTINamespace" select="/.."/>
<xsl:param name="FCANovatedUTINamespacePrefix" select="/.."/>
<xsl:param name="FCANovatedUTI" select="/.."/>
<xsl:if test="$FCADataPresent">
<FCADataPresent>
<xsl:value-of select="$FCADataPresent"/>
</FCADataPresent>
</xsl:if>
<xsl:if test="$FCANewNovatedDataPresent">
<FCANewNovatedDataPresent>
<xsl:value-of select="$FCANewNovatedDataPresent"/>
</FCANewNovatedDataPresent>
</xsl:if>
<xsl:if test="$FCANovatedDataPresent">
<FCANovatedDataPresent>
<xsl:value-of select="$FCANovatedDataPresent"/>
</FCANovatedDataPresent>
</xsl:if>
<xsl:if test="$FCAUTINamespace">
<FCAUTINamespace>
<xsl:value-of select="$FCAUTINamespace"/>
</FCAUTINamespace>
</xsl:if>
<xsl:if test="$FCAUTINamespacePrefix">
<FCAUTINamespacePrefix>
<xsl:value-of select="$FCAUTINamespacePrefix"/>
</FCAUTINamespacePrefix>
</xsl:if>
<xsl:if test="$FCAUTI">
<FCAUTI>
<xsl:value-of select="$FCAUTI"/>
</FCAUTI>
</xsl:if>
<xsl:if test="$FCAIntentToBlankUTINamespace">
<FCAIntentToBlankUTINamespace>
<xsl:value-of select="$FCAIntentToBlankUTINamespace"/>
</FCAIntentToBlankUTINamespace>
</xsl:if>
<xsl:if test="$FCAIntentToBlankUTI">
<FCAIntentToBlankUTI>
<xsl:value-of select="$FCAIntentToBlankUTI"/>
</FCAIntentToBlankUTI>
</xsl:if>
<xsl:if test="$FCANewNovatedUTINamespace">
<FCANewNovatedUTINamespace>
<xsl:value-of select="$FCANewNovatedUTINamespace"/>
</FCANewNovatedUTINamespace>
</xsl:if>
<xsl:if test="$FCANewNovatedUTINamespacePrefix">
<FCANewNovatedUTINamespacePrefix>
<xsl:value-of select="$FCANewNovatedUTINamespacePrefix"/>
</FCANewNovatedUTINamespacePrefix>
</xsl:if>
<xsl:if test="$FCANewNovatedUTI">
<FCANewNovatedUTI>
<xsl:value-of select="$FCANewNovatedUTI"/>
</FCANewNovatedUTI>
</xsl:if>
<xsl:if test="$FCANovatedUTINamespace">
<FCANovatedUTINamespace>
<xsl:value-of select="$FCANovatedUTINamespace"/>
</FCANovatedUTINamespace>
</xsl:if>
<xsl:if test="$FCANovatedUTINamespacePrefix">
<FCANovatedUTINamespacePrefix>
<xsl:value-of select="$FCANovatedUTINamespacePrefix"/>
</FCANovatedUTINamespacePrefix>
</xsl:if>
<xsl:if test="$FCANovatedUTI">
<FCANovatedUTI>
<xsl:value-of select="$FCANovatedUTI"/>
</FCANovatedUTI>
</xsl:if>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.GenProdUnderlyer">
<xsl:param name="UnderlyerType" select="/.."/>
<xsl:param name="UnderlyerDescription" select="/.."/>
<xsl:param name="UnderlyerDirectionA" select="/.."/>
<xsl:param name="UnderlyerFixedRate" select="/.."/>
<xsl:param name="UnderlyerIDCode" select="/.."/>
<xsl:param name="UnderlyerIDType" select="/.."/>
<xsl:param name="UnderlyerReferenceCurrency" select="/.."/>
<xsl:param name="UnderlyerFXCurrency" select="/.."/>
<GenProdUnderlyer>
<UnderlyerType>
<xsl:value-of select="$UnderlyerType"/>
</UnderlyerType>
<UnderlyerDescription>
<xsl:value-of select="$UnderlyerDescription"/>
</UnderlyerDescription>
<UnderlyerDirectionA>
<xsl:value-of select="$UnderlyerDirectionA"/>
</UnderlyerDirectionA>
<UnderlyerFixedRate>
<xsl:value-of select="$UnderlyerFixedRate"/>
</UnderlyerFixedRate>
<UnderlyerIDCode>
<xsl:value-of select="$UnderlyerIDCode"/>
</UnderlyerIDCode>
<UnderlyerIDType>
<xsl:value-of select="$UnderlyerIDType"/>
</UnderlyerIDType>
<UnderlyerReferenceCurrency>
<xsl:value-of select="$UnderlyerReferenceCurrency"/>
</UnderlyerReferenceCurrency>
<UnderlyerFXCurrency>
<xsl:value-of select="$UnderlyerFXCurrency"/>
</UnderlyerFXCurrency>
</GenProdUnderlyer>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.GenProdNotional">
<xsl:param name="NotionalCurrency" select="/.."/>
<xsl:param name="NotionalUnit" select="/.."/>
<xsl:param name="Notional" select="/.."/>
<GenProdNotional>
<NotionalCurrency>
<xsl:value-of select="$NotionalCurrency"/>
</NotionalCurrency>
<NotionalUnit>
<xsl:value-of select="$NotionalUnit"/>
</NotionalUnit>
<Notional>
<xsl:value-of select="$Notional"/>
</Notional>
</GenProdNotional>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.DayCountFraction">
<xsl:param name="Schema" select="/.."/>
<xsl:param name="Fraction" select="/.."/>
<DayCountFraction>
<Schema>
<xsl:value-of select="$Schema"/>
</Schema>
<Fraction>
<xsl:value-of select="$Fraction"/>
</Fraction>
</DayCountFraction>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.OrderDetails">
<xsl:param name="TypeOfOrder" select="/.."/>
<xsl:param name="TotalConsideration" select="/.."/>
<xsl:param name="RateOfExchange" select="/.."/>
<xsl:param name="ClientCounterparty" select="/.."/>
<xsl:param name="TotalCommissionAndExpenses" select="/.."/>
<xsl:param name="ClientSettlementResponsibilities" select="/.."/>
<xsl:param name="id" select="/.."/>
<OrderDetails>
<xsl:if test="$id">
<xsl:attribute name="id">
<xsl:value-of select="$id"/>
</xsl:attribute>
</xsl:if>
<TypeOfOrder>
<xsl:value-of select="$TypeOfOrder"/>
</TypeOfOrder>
<TotalConsideration>
<xsl:value-of select="$TotalConsideration"/>
</TotalConsideration>
<RateOfExchange>
<xsl:value-of select="$RateOfExchange"/>
</RateOfExchange>
<ClientCounterparty>
<xsl:value-of select="$ClientCounterparty"/>
</ClientCounterparty>
<TotalCommissionAndExpenses>
<xsl:value-of select="$TotalCommissionAndExpenses"/>
</TotalCommissionAndExpenses>
<ClientSettlementResponsibilities>
<xsl:value-of select="$ClientSettlementResponsibilities"/>
</ClientSettlementResponsibilities>
</OrderDetails>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.ClearingDetails">
<xsl:param name="ClearingStatus" select="/.."/>
<xsl:param name="ClearingHouseTradeID" select="/.."/>
<xsl:param name="ClearingHouseUpfrontFeeSettlementDate" select="/.."/>
<xsl:param name="ClearingHousePreferredISIN" select="/.."/>
<xsl:param name="ClearedTimestamp" select="/.."/>
<xsl:param name="ClearedUSINamespace" select="/.."/>
<xsl:param name="ClearedUSI" select="/.."/>
<xsl:param name="ClearedUTINamespace" select="/.."/>
<xsl:param name="ClearedUTI" select="/.."/>
<ClearingDetails>
<xsl:if test="$ClearingStatus">
<ClearingStatus>
<xsl:value-of select="$ClearingStatus"/>
</ClearingStatus>
</xsl:if>
<xsl:if test="$ClearingHouseTradeID">
<ClearingHouseTradeID>
<xsl:value-of select="$ClearingHouseTradeID"/>
</ClearingHouseTradeID>
</xsl:if>
<xsl:if test="$ClearingHouseUpfrontFeeSettlementDate">
<ClearingHouseUpfrontFeeSettlementDate>
<xsl:value-of select="$ClearingHouseUpfrontFeeSettlementDate"/>
</ClearingHouseUpfrontFeeSettlementDate>
</xsl:if>
<xsl:if test="$ClearingHousePreferredISIN">
<ClearingHousePreferredISIN>
<xsl:value-of select="$ClearingHousePreferredISIN"/>
</ClearingHousePreferredISIN>
</xsl:if>
<xsl:if test="$ClearedTimestamp">
<ClearedTimestamp>
<xsl:value-of select="$ClearedTimestamp"/>
</ClearedTimestamp>
</xsl:if>
<xsl:if test="$ClearedUSINamespace">
<ClearedUSINamespace>
<xsl:value-of select="$ClearedUSINamespace"/>
</ClearedUSINamespace>
</xsl:if>
<xsl:if test="$ClearedUSI">
<ClearedUSI>
<xsl:value-of select="$ClearedUSI"/>
</ClearedUSI>
</xsl:if>
<xsl:if test="$ClearedUTINamespace">
<ClearedUTINamespace>
<xsl:value-of select="$ClearedUTINamespace"/>
</ClearedUTINamespace>
</xsl:if>
<xsl:if test="$ClearedUTI">
<ClearedUTI>
<xsl:value-of select="$ClearedUTI"/>
</ClearedUTI>
</xsl:if>
</ClearingDetails>
</xsl:template>
<xsl:template name="lcl:SWDMLTrade.LinkedTradeDetails">
<xsl:param name="LinkedIDType" select="/.."/>
<xsl:param name="LinkedTradeID" select="/.."/>
<LinkedTradeDetails>
<LinkedIDType>
<xsl:value-of select="$LinkedIDType"/>
</LinkedIDType>
<LinkedTradeID>
<xsl:value-of select="$LinkedTradeID"/>
</LinkedTradeID>
</LinkedTradeDetails>
</xsl:template>
</xsl:stylesheet>
