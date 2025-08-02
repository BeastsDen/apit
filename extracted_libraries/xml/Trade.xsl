<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:lcl="http://www.markitserv.com/detail/SWDMLTrade.xsl" version="1.0" exclude-result-prefixes="lcl">
<xsl:template name="lcl:Trade">
<xsl:param name="SWBMLVersion" select="/.."/>
<xsl:param name="BrokerSubmitted" select="/.."/>
<xsl:param name="BrokerTradeId" select="/.."/>
<xsl:param name="TotalLegs" select="/.."/>
<xsl:param name="BrokerLegId" select="/.."/>
<xsl:param name="ReplacementTradeId" select="/.."/>
<xsl:param name="ReplacementTradeIdType" select="/.."/>
<xsl:param name="ReplacementReason" select="/.."/>
<xsl:param name="StrategyType" select="/.."/>
<xsl:param name="StrategyComment" select="/.."/>
<xsl:param name="BrokerTradeVersionId" select="/.."/>
<xsl:param name="LinkedTradeId" select="/.."/>
<xsl:param name="TradeSource" select="/.."/>
<xsl:param name="VenueId" select="/.."/>
<xsl:param name="VenueIdScheme" select="/.."/>
<xsl:param name="MessageText" select="/.."/>
<xsl:param name="SettlementAgency" select="/.."/>
<xsl:param name="SettlementAgencyModel" select="/.."/>
<xsl:param name="PBEBSettlementAgency" select="/.."/>
<xsl:param name="PBEBSettlementAgencyModel" select="/.."/>
<xsl:param name="PBClientSettlementAgency" select="/.."/>
<xsl:param name="PBClientSettlementAgencyModel" select="/.."/>
<xsl:param name="ConditionPrecedentBondId" select="/.."/>
<xsl:param name="ConditionPrecedentBondMaturity" select="/.."/>
<xsl:param name="ConditionPrecedentBondIdType" select="/.."/>
<xsl:param name="ConditionPrecedentBond" select="/.."/>
<xsl:param name="DiscrepancyClause" select="/.."/>
<xsl:param name="AllocatedTrade" select="/.."/>
<xsl:param name="Allocation" select="/.."/>
<xsl:param name="EmptyBlockTrade" select="/.."/>
<xsl:param name="PrimeBrokerTrade" select="/.."/>
<xsl:param name="ReversePrimeBrokerLegalEntities" select="/.."/>
<xsl:param name="Recipient">
<xsl:call-template name="lcl:Trade.Recipient"/>
</xsl:param>
<xsl:param name="PartyAId">
<xsl:call-template name="lcl:Trade.PartyAId"/>
</xsl:param>
<xsl:param name="PartyAIdType" select="/.."/>
<xsl:param name="PartyAName" select="/.."/>
<xsl:param name="PartyBId">
<xsl:call-template name="lcl:Trade.PartyBId"/>
</xsl:param>
<xsl:param name="PartyBIdType" select="/.."/>
<xsl:param name="PartyBName" select="/.."/>
<xsl:param name="PartyCId">
<xsl:call-template name="lcl:Trade.PartyCId"/>
</xsl:param>
<xsl:param name="PartyCIdType" select="/.."/>
<xsl:param name="PartyCName" select="/.."/>
<xsl:param name="PartyDId">
<xsl:call-template name="lcl:Trade.PartyDId"/>
</xsl:param>
<xsl:param name="PartyDIdType" select="/.."/>
<xsl:param name="PartyDName" select="/.."/>
<xsl:param name="PartyGId">
<xsl:call-template name="lcl:Trade.PartyGId"/>
</xsl:param>
<xsl:param name="PartyGIdType" select="/.."/>
<xsl:param name="PartyGName" select="/.."/>
<xsl:param name="PartyHId" select="/.."/>
<xsl:param name="PartyHIdType" select="/.."/>
<xsl:param name="PartyHName" select="/.."/>
<xsl:param name="PartyTripartyAgentId">
<xsl:call-template name="lcl:Trade.PartyTripartyAgentId"/>
</xsl:param>
<xsl:param name="PartyTripartyAgentIdType" select="/.."/>
<xsl:param name="DeliveryByValue" select="/.."/>
<xsl:param name="BrokerAId" select="/.."/>
<xsl:param name="BrokerBId" select="/.."/>
<xsl:param name="NominalTerm" select="/.."/>
<xsl:param name="FixedRatePayer" select="/.."/>
<xsl:param name="FloatingRatePayer" select="/.."/>
<xsl:param name="OptionBuyer" select="/.."/>
<xsl:param name="TradeDate" select="/.."/>
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
<xsl:param name="Strike" select="/.."/>
<xsl:param name="StrikePercentage" select="/.."/>
<xsl:param name="StrikeDate" select="/.."/>
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
<xsl:param name="NoStubLinearInterpolation" select="/.."/>
<xsl:param name="NoStubLinearInterpolation2" select="/.."/>
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
<xsl:param name="CancelableCalcAgent" select="/.."/>
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
<xsl:param name="NoBreak" select="/.."/>
<xsl:param name="HasBreak" select="/.."/>
<xsl:param name="BreakType" select="/.."/>
<xsl:param name="BreakFirstDate" select="/.."/>
<xsl:param name="BreakFrequency" select="/.."/>
<xsl:param name="BreakOverride" select="/.."/>
<xsl:param name="BreakDate" select="/.."/>
<xsl:param name="BreakEarliestTime" select="/.."/>
<xsl:param name="BreakCalcAgentA" select="/.."/>
<xsl:param name="BreakExpiryTime" select="/.."/>
<xsl:param name="BreakLocation" select="/.."/>
<xsl:param name="BreakHolidayCentre" select="/.."/>
<xsl:param name="BreakSettlement" select="/.."/>
<xsl:param name="BreakValuationDate" select="/.."/>
<xsl:param name="BreakValuationTime" select="/.."/>
<xsl:param name="BreakMMVApplicableCSA" select="/.."/>
<xsl:param name="BreakPrescribedDocAdj" select="/.."/>
<xsl:param name="ExchangeUnderlying" select="/.."/>
<xsl:param name="SpreadCurrency" select="/.."/>
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
<xsl:param name="NoBackStubLinearInterpolation" select="/.."/>
<xsl:param name="FirstFixedRegPdStartDate" select="/.."/>
<xsl:param name="FirstFixedRegPdStartDate_2" select="/.."/>
<xsl:param name="FirstFloatRegPdStartDate" select="/.."/>
<xsl:param name="LastFixedRegPdEndDate" select="/.."/>
<xsl:param name="LastFixedRegPdEndDate_2" select="/.."/>
<xsl:param name="LastFloatRegPdEndDate" select="/.."/>
<xsl:param name="MasterAgreement" select="/.."/>
<xsl:param name="MasterAgreementDate" select="/.."/>
<xsl:param name="MasterAgreementVersion" select="/.."/>
<xsl:param name="ProductType" select="/.."/>
<xsl:param name="ProductSubType" select="/.."/>
<xsl:param name="OptionType" select="/.."/>
<xsl:param name="OptionExpirationDate" select="/.."/>
<xsl:param name="OptionExpirationDateConvention" select="/.."/>
<xsl:param name="OptionHolidayCentres" select="/.."/>
<xsl:param name="OptionEarliestTime" select="/.."/>
<xsl:param name="OptionExpiryTime" select="/.."/>
<xsl:param name="ValuationTime" select="/.."/>
<xsl:param name="OptionSpecificExpiryTime" select="/.."/>
<xsl:param name="OptionLocation" select="/.."/>
<xsl:param name="OptionCalcAgent" select="/.."/>
<xsl:param name="OptionAutomaticExercise" select="/.."/>
<xsl:param name="OptionThreshold" select="/.."/>
<xsl:param name="ManualExercise" select="/.."/>
<xsl:param name="OptionWrittenExerciseConf" select="/.."/>
<xsl:param name="OptionSettlement" select="/.."/>
<xsl:param name="OptionCashSettlementMethod" select="/.."/>
<xsl:param name="OptionCashSettlementQuotationRate" select="/.."/>
<xsl:param name="OptionCashSettlementRateSource" select="/.."/>
<xsl:param name="OptionCashSettlementReferenceBanks" select="/.."/>
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
<xsl:param name="ClearedPhysicalSettlement" select="/.."/>
<xsl:param name="UnderlyingSwapClearingHouse" select="/.."/>
<xsl:param name="PricedToClearCCP" select="/.."/>
<xsl:param name="AgreedDiscountRate" select="/.."/>
<xsl:param name="Premium">
<xsl:call-template name="lcl:Trade.Premium"/>
</xsl:param>
<xsl:param name="PremiumHolidayCentres" select="/.."/>
<xsl:param name="AssociatedFuture" select="/.."/>
<xsl:param name="DocsType" select="/.."/>
<xsl:param name="DocsSubType" select="/.."/>
<xsl:param name="OptionsComponentSecurityIndexAnnex" select="/.."/>
<xsl:param name="OptionHedgingDisruption" select="/.."/>
<xsl:param name="OptionLossOfStockBorrow" select="/.."/>
<xsl:param name="OptionMaximumStockLoanRate" select="/.."/>
<xsl:param name="OptionIncreasedCostOfStockBorrow" select="/.."/>
<xsl:param name="OptionInitialStockLoanRate" select="/.."/>
<xsl:param name="OptionIncreasedCostOfHedging" select="/.."/>
<xsl:param name="OptionForeignOwnershipEvent" select="/.."/>
<xsl:param name="OptionEntitlement" select="/.."/>
<xsl:param name="FxFeature" select="/.."/>
<xsl:param name="ContractualDefinitions" select="/.."/>
<xsl:param name="ContractualSupplement" select="/.."/>
<xsl:param name="RestructuringCreditEvent" select="/.."/>
<xsl:param name="CalculationAgentCity" select="/.."/>
<xsl:param name="CalculationAgent" select="/.."/>
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
<xsl:param name="DesignatedPriority" select="/.."/>
<xsl:param name="LegalFinalMaturity" select="/.."/>
<xsl:param name="OriginalPrincipalAmount" select="/.."/>
<xsl:param name="CreditDateAdjustments" select="/.."/>
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
<xsl:param name="IndexSeries" select="/.."/>
<xsl:param name="IndexVersion" select="/.."/>
<xsl:param name="IndexAnnexDate" select="/.."/>
<xsl:param name="IndexTradedRate" select="/.."/>
<xsl:param name="UpfrontFee" select="/.."/>
<xsl:param name="UpfrontFeeAmount" select="/.."/>
<xsl:param name="UpfrontFeeCurrency" select="/.."/>
<xsl:param name="UpfrontFeeDate" select="/.."/>
<xsl:param name="UpfrontFeePayer" select="/.."/>
<xsl:param name="AttachmentPoint" select="/.."/>
<xsl:param name="ExhaustionPoint" select="/.."/>
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
<xsl:param name="AdditionalPayment" select="/.."/>
<xsl:param name="EquityRic" select="/.."/>
<xsl:param name="OptionQuantity" select="/.."/>
<xsl:param name="OptionExpiryMonth" select="/.."/>
<xsl:param name="OptionExpiryYear" select="/.."/>
<xsl:param name="Price" select="/.."/>
<xsl:param name="OptionStyle" select="/.."/>
<xsl:param name="ExchangeLookAlike" select="/.."/>
<xsl:param name="AdjustmentMethod" select="/.."/>
<xsl:param name="RelatedExchange" select="/.."/>
<xsl:param name="MasterConfirmationDate" select="/.."/>
<xsl:param name="Multiplier" select="/.."/>
<xsl:param name="SettlementCurrency" select="/.."/>
<xsl:param name="SettlementCurrency_2" select="/.."/>
<xsl:param name="SettlementDateOffset" select="/.."/>
<xsl:param name="SettlementType" select="/.."/>
<xsl:param name="SettlementDate" select="/.."/>
<xsl:param name="FxDeterminationMethod" select="/.."/>
<xsl:param name="ReferencePriceSource" select="/.."/>
<xsl:param name="ReferencePricePage" select="/.."/>
<xsl:param name="ReferencePriceTime" select="/.."/>
<xsl:param name="ReferencePriceCity" select="/.."/>
<xsl:param name="ReferenceCurrency" select="/.."/>
<xsl:param name="ReferenceCurrency_2" select="/.."/>
<xsl:param name="DcRequired" select="/.."/>
<xsl:param name="DcEventTypeA" select="/.."/>
<xsl:param name="DcRic" select="/.."/>
<xsl:param name="DcDescription" select="/.."/>
<xsl:param name="DcExpiryMonth" select="/.."/>
<xsl:param name="DcExpiryYear" select="/.."/>
<xsl:param name="DcQuantity" select="/.."/>
<xsl:param name="DcPrice" select="/.."/>
<xsl:param name="DcCurrency" select="/.."/>
<xsl:param name="DcDelta" select="/.."/>
<xsl:param name="DcExpiryDate" select="/.."/>
<xsl:param name="DcFuturesCode" select="/.."/>
<xsl:param name="DcOffshoreCross" select="/.."/>
<xsl:param name="DcOffshoreCrossLocation" select="/.."/>
<xsl:param name="DcExchangeID" select="/.."/>
<xsl:param name="DcDeltaOptionQuantity" select="/.."/>
<xsl:param name="AveragingInOut" select="/.."/>
<xsl:param name="AveragingDateTimes">
<xsl:call-template name="lcl:Trade.AveragingDateTimes"/>
</xsl:param>
<xsl:param name="MarketDisruption" select="/.."/>
<xsl:param name="AveragingFrequency" select="/.."/>
<xsl:param name="AveragingStartDate" select="/.."/>
<xsl:param name="AveragingEndDate" select="/.."/>
<xsl:param name="ReferenceFXRate" select="/.."/>
<xsl:param name="HedgeLevel" select="/.."/>
<xsl:param name="Basis" select="/.."/>
<xsl:param name="ImpliedLevel" select="/.."/>
<xsl:param name="PremiumPercent" select="/.."/>
<xsl:param name="StrikePercent" select="/.."/>
<xsl:param name="BaseNotional" select="/.."/>
<xsl:param name="BreakOutTrade" select="/.."/>
<xsl:param name="SplitCollateral" select="/.."/>
<xsl:param name="OpenUnits" select="/.."/>
<xsl:param name="DeclaredCashDividendPercentage" select="/.."/>
<xsl:param name="DeclaredCashEquivalentDividendPercentage" select="/.."/>
<xsl:param name="DividendPayer" select="/.."/>
<xsl:param name="DividendReceiver" select="/.."/>
<xsl:param name="DividendPeriods">
<xsl:call-template name="lcl:Trade.DividendPeriods"/>
</xsl:param>
<xsl:param name="SpecialDividends" select="/.."/>
<xsl:param name="MaterialDividend" select="/.."/>
<xsl:param name="FixedPayer" select="/.."/>
<xsl:param name="FixedReceiver" select="/.."/>
<xsl:param name="FixedPeriods">
<xsl:call-template name="lcl:Trade.FixedPeriods"/>
</xsl:param>
<xsl:param name="VegaNotional" select="/.."/>
<xsl:param name="ExpectedN" select="/.."/>
<xsl:param name="ExpectedNOverride" select="/.."/>
<xsl:param name="VarianceAmount" select="/.."/>
<xsl:param name="VarianceStrikePrice" select="/.."/>
<xsl:param name="VolatilityStrikePrice" select="/.."/>
<xsl:param name="VarianceCapIndicator" select="/.."/>
<xsl:param name="VolatilityCapIndicator" select="/.."/>
<xsl:param name="VarianceCapFactor" select="/.."/>
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
<xsl:param name="HolidayDates" select="/.."/>
<xsl:param name="IndependentAmount">
<xsl:call-template name="lcl:Trade.IndependentAmount"/>
</xsl:param>
<xsl:param name="Brokerage" select="/.."/>
<xsl:param name="SettlementRateOption" select="/.."/>
<xsl:param name="SettlementRateOption_2" select="/.."/>
<xsl:param name="FxFixingAdjustableDate" select="/.."/>
<xsl:param name="FxFixingPeriod" select="/.."/>
<xsl:param name="FxFixingDayConvention" select="/.."/>
<xsl:param name="FxFixingCentres" select="/.."/>
<xsl:param name="ValuationDateType" select="/.."/>
<xsl:param name="ValuationDateType_2" select="/.."/>
<xsl:param name="FxFixingPeriod_2" select="/.."/>
<xsl:param name="FxFixingDayConvention_2" select="/.."/>
<xsl:param name="FxFixingCentres_2" select="/.."/>
<xsl:param name="CalcAgentA" select="/.."/>
<xsl:param name="DefaultSettlementMethod" select="/.."/>
<xsl:param name="SettlementPriceDefaultElectionMethod" select="/.."/>
<xsl:param name="SettlementMethodElectionDate" select="/.."/>
<xsl:param name="SettlementMethodElectingParty" select="/.."/>
<xsl:param name="NotionalFutureValue" select="/.."/>
<xsl:param name="NotionalSchedule" select="/.."/>
<xsl:param name="DispLegs">
<xsl:call-template name="lcl:Trade.DispLegs"/>
</xsl:param>
<xsl:param name="DispLegsSW">
<xsl:call-template name="lcl:Trade.DispLegsSW"/>
</xsl:param>
<xsl:param name="BalanceOfPeriod" select="/.."/>
<xsl:param name="BulletIndicator" select="/.."/>
<xsl:param name="BulletFirstContractMonth" select="/.."/>
<xsl:param name="BulletLastContractMonth" select="/.."/>
<xsl:param name="BulletContractYear" select="/.."/>
<xsl:param name="BulletContractTradingDay" select="/.."/>
<xsl:param name="ClearingVenue" select="/.."/>
<xsl:param name="ClientClearing" select="/.."/>
<xsl:param name="ExternalInteropabilityId" select="/.."/>
<xsl:param name="InteropNettingString" select="/.."/>
<xsl:param name="AutoSendForClearing" select="/.."/>
<xsl:param name="ASICMandatoryClearingIndicator" select="/.."/>
<xsl:param name="PBEBTradeASICMandatoryClearingIndicator" select="/.."/>
<xsl:param name="PBClientTradeASICMandatoryClearingIndicator" select="/.."/>
<xsl:param name="CANMandatoryClearingIndicator" select="/.."/>
<xsl:param name="CANClearingExemptIndicator1PartyId" select="/.."/>
<xsl:param name="CANClearingExemptIndicator1Value" select="/.."/>
<xsl:param name="CANClearingExemptIndicator2PartyId" select="/.."/>
<xsl:param name="CANClearingExemptIndicator2Value" select="/.."/>
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
<xsl:param name="PBEBTradeMASMandatoryClearingIndicator" select="/.."/>
<xsl:param name="PBClientTradeMASMandatoryClearingIndicator" select="/.."/>
<xsl:param name="ClearingHouseId" select="/.."/>
<xsl:param name="IntendedClearingHouse" select="/.."/>
<xsl:param name="TraderId" select="/.."/>
<xsl:param name="TraderId_2" select="/.."/>
<xsl:param name="ExecutingBroker" select="/.."/>
<xsl:param name="ClearingClient" select="/.."/>
<xsl:param name="ClientClearingBroker" select="/.."/>
<xsl:param name="EBClearingBroker" select="/.."/>
<xsl:param name="PartyAClearingBroker" select="/.."/>
<xsl:param name="PartyBClearingBroker" select="/.."/>
<xsl:param name="DisplayPartyLE_Party" select="/.."/>
<xsl:param name="DisplayPartyLE_Value" select="/.."/>
<xsl:param name="ClearingNettingParty" select="/.."/>
<xsl:param name="ClearingNettingString" select="/.."/>
<xsl:param name="ClearingNettingParty_2" select="/.."/>
<xsl:param name="ClearingNettingString_2" select="/.."/>
<xsl:param name="CreditAcceptanceParty" select="/.."/>
<xsl:param name="CreditAcceptanceIssuer" select="/.."/>
<xsl:param name="CreditAcceptanceToken" select="/.."/>
<xsl:param name="CreditAcceptanceParty_2" select="/.."/>
<xsl:param name="CreditAcceptanceIssuer_2" select="/.."/>
<xsl:param name="CreditAcceptanceToken_2" select="/.."/>
<xsl:param name="CommodityReferencePrice" select="/.."/>
<xsl:param name="CommodityReferencePrice_2" select="/.."/>
<xsl:param name="CommonPricing" select="/.."/>
<xsl:param name="DeliveryDates" select="/.."/>
<xsl:param name="DeliveryDates_2" select="/.."/>
<xsl:param name="DeliveryLocation" select="/.."/>
<xsl:param name="FloatCalculationFrequency" select="/.."/>
<xsl:param name="FloatCalculationFrequency_2" select="/.."/>
<xsl:param name="PhysicalCommodity" select="/.."/>
<xsl:param name="PhysicalElectricityProduct" select="/.."/>
<xsl:param name="PhysicalElectricityForceMajeure" select="/.."/>
<xsl:param name="PhysicalGasDeliveryType" select="/.."/>
<xsl:param name="ForwardUnderlyer" select="/.."/>
<xsl:param name="FuturesRollConvention" select="/.."/>
<xsl:param name="FuturesRollConvention_2" select="/.."/>
<xsl:param name="LoadShape" select="/.."/>
<xsl:param name="LoadShape_2" select="/.."/>
<xsl:param name="NotionalLots" select="/.."/>
<xsl:param name="NotionalQuantity" select="/.."/>
<xsl:param name="NotionalQuantity_2" select="/.."/>
<xsl:param name="PricingDayType" select="/.."/>
<xsl:param name="PricingDayType_2" select="/.."/>
<xsl:param name="PricingFrequency" select="/.."/>
<xsl:param name="PricingFrequency_2" select="/.."/>
<xsl:param name="PricingHolidayCentres" select="/.."/>
<xsl:param name="PricingHolidayCentres_2" select="/.."/>
<xsl:param name="PricingLagInterval" select="/.."/>
<xsl:param name="PricingLagInterval_2" select="/.."/>
<xsl:param name="PricingLagSkipInterval" select="/.."/>
<xsl:param name="PricingLagSkipInterval_2" select="/.."/>
<xsl:param name="PricingRange" select="/.."/>
<xsl:param name="PricingRange_2" select="/.."/>
<xsl:param name="SettlementDaysConvention" select="/.."/>
<xsl:param name="SettlementDaysType" select="/.."/>
<xsl:param name="SpecifiedPrice" select="/.."/>
<xsl:param name="SpecifiedPrice_2" select="/.."/>
<xsl:param name="UnitFrequency" select="/.."/>
<xsl:param name="Units" select="/.."/>
<xsl:param name="Units_2" select="/.."/>
<xsl:param name="ValueDate" select="/.."/>
<xsl:param name="ModifiedEquityDelivery" select="/.."/>
<xsl:param name="SettledEntityMatrixSource" select="/.."/>
<xsl:param name="SettledEntityMatrixDate" select="/.."/>
<xsl:param name="AdditionalTerms" select="/.."/>
<xsl:param name="Rule15A-6" select="/.."/>
<xsl:param name="DFData" select="/.."/>
<xsl:param name="JFSAData" select="/.."/>
<xsl:param name="ESMAData" select="/.."/>
<xsl:param name="FCAData" select="/.."/>
<xsl:param name="CAData" select="/.."/>
<xsl:param name="HKMAData" select="/.."/>
<xsl:param name="ASICData" select="/.."/>
<xsl:param name="MASData" select="/.."/>
<xsl:param name="MIData" select="/.."/>
<xsl:param name="ExecTraderA" select="/.."/>
<xsl:param name="ExecTraderB" select="/.."/>
<xsl:param name="ExecTraderLocationA" select="/.."/>
<xsl:param name="ExecTraderLocationB" select="/.."/>
<xsl:param name="ExecTraderSideAID" select="/.."/>
<xsl:param name="ExecTraderSideBID" select="/.."/>
<xsl:param name="SalesTraderA" select="/.."/>
<xsl:param name="SalesTraderB" select="/.."/>
<xsl:param name="SalesTraderLocationA" select="/.."/>
<xsl:param name="SalesTraderLocationB" select="/.."/>
<xsl:param name="SalesTraderSideAID" select="/.."/>
<xsl:param name="SalesTraderSideBID" select="/.."/>
<xsl:param name="DeskLocationA" select="/.."/>
<xsl:param name="DeskLocationB" select="/.."/>
<xsl:param name="DeskLocationSideAID" select="/.."/>
<xsl:param name="DeskLocationSideBID" select="/.."/>
<xsl:param name="CounterpartyCountryA" select="/.."/>
<xsl:param name="CounterpartyCountryB" select="/.."/>
<xsl:param name="InvestFirmNameA" select="/.."/>
<xsl:param name="InvestFirmNameB" select="/.."/>
<xsl:param name="InvestFirmLocA" select="/.."/>
<xsl:param name="InvestFirmLocB" select="/.."/>
<xsl:param name="LeiValueA" select="/.."/>
<xsl:param name="LeiValueB" select="/.."/>
<xsl:param name="UniqueTradeIdentifier" select="/.."/>
<xsl:param name="MidMarketPriceType" select="/.."/>
<xsl:param name="MidMarketPriceValue" select="/.."/>
<xsl:param name="MidMarketPriceCurrency" select="/.."/>
<xsl:param name="IntentToBlankMidMarketCurrency" select="/.."/>
<xsl:param name="IntentToBlankMidMarketPrice" select="/.."/>
<xsl:param name="EffectiveDate" select="/.."/>
<xsl:param name="TerminationDate" select="/.."/>
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
<xsl:param name="PaymentFrequency" select="/.."/>
<xsl:param name="DayCountFraction" select="/.."/>
<xsl:param name="PartyAOrderDetails" select="/.."/>
<xsl:param name="PartyBOrderDetails" select="/.."/>
<xsl:param name="PartyAPackageDetails" select="/.."/>
<xsl:param name="PartyBPackageDetails" select="/.."/>
<xsl:param name="AutoProcessing" select="/.."/>
<xsl:param name="AnonymousTrade" select="/.."/>
<xsl:param name="GCOffsettingID" select="/.."/>
<xsl:param name="CompressionType" select="/.."/>
<xsl:param name="GCExecutionMethodParty_1" select="/.."/>
<xsl:param name="GCExecutionMethodToken_1" select="/.."/>
<xsl:param name="GCExecutionMethodParty_2" select="/.."/>
<xsl:param name="GCExecutionMethodToken_2" select="/.."/>
<xsl:param name="OTVConfirmation" select="/.."/>
<xsl:param name="IntroducingBroker" select="/.."/>
<xsl:param name="IntroducingBroker_2" select="/.."/>
<xsl:param name="OriginatingEvent" select="/.."/>
<xsl:param name="PartyClearingDetails" select="/.."/>
<xsl:param name="PackageIdentifierNamespace" select="/.."/>
<xsl:param name="PackageIdentifierId" select="/.."/>
<xsl:param name="PackageSize" select="/.."/>
<xsl:param name="PackageCreditParty" select="/.."/>
<xsl:param name="PackageCreditIssuer" select="/.."/>
<xsl:param name="PackageCreditToken" select="/.."/>
<xsl:param name="PackageCreditParty_2" select="/.."/>
<xsl:param name="PackageCreditIssuer_2" select="/.."/>
<xsl:param name="PackageCreditToken_2" select="/.."/>
<xsl:param name="Tenor" select="/.."/>
<xsl:param name="InterestLegDrivenIndicator" select="/.."/>
<xsl:param name="EquityFrontStub" select="/.."/>
<xsl:param name="EquityEndStub" select="/.."/>
<xsl:param name="InterestFrontStub" select="/.."/>
<xsl:param name="InterestEndStub" select="/.."/>
<xsl:param name="FixedRateIndicator" select="/.."/>
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
<xsl:param name="EswDividendValuationCustomDatesInterim" select="/.."/>
<xsl:param name="EswDividendValuationCustomDateFinal" select="/.."/>
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
<xsl:param name="EswPaymentHolidayCentres" select="/.."/>
<xsl:param name="ReturnType" select="/.."/>
<xsl:param name="Synthetic" select="/.."/>
<xsl:param name="ValuationDay" select="/.."/>
<xsl:param name="PaymentDay" select="/.."/>
<xsl:param name="ValuationFrequency" select="/.."/>
<xsl:param name="ValuationStartDate" select="/.."/>
<xsl:param name="EswSchedulingMethod" select="/.."/>
<xsl:param name="EswValuationDates" select="/.."/>
<xsl:param name="EswInterestLegPaymentDates" select="/.."/>
<xsl:param name="EswEquityLegPaymentDates" select="/.."/>
<xsl:param name="EswCompoundingDates" select="/.."/>
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
<xsl:param name="EswEarlyTerminationElectingParty" select="/.."/>
<xsl:param name="NoticePeriodPtyA" select="/.."/>
<xsl:param name="NoticePeriodPtyB" select="/.."/>
<xsl:param name="EswInsolvencyFiling" select="/.."/>
<xsl:param name="EswLossOfStockBorrow" select="/.."/>
<xsl:param name="EswIncreasedCostOfStockBorrow" select="/.."/>
<xsl:param name="EswBulletCompoundingSpread" select="/.."/>
<xsl:param name="EswAdditionalDisruptionEventIndicator" select="/.."/>
<xsl:param name="EswOverrideNotionalCalculation" select="/.."/>
<xsl:param name="HedgingParty" select="/.."/>
<xsl:param name="DeterminingParty" select="/.."/>
<xsl:param name="MultipleExchangeIndexAnnex" select="/.."/>
<xsl:param name="ComponentSecurityIndexAnnex" select="/.."/>
<xsl:param name="EswSpecifiedExchange" select="/.."/>
<xsl:param name="sw2021ISDADefs" select="/.."/>
<xsl:param name="EswChinaConnectFlag" select="/.."/>
<xsl:param name="EswChinaConnect" select="/.."/>
<xsl:param name="DirectionComboLEA" select="/.."/>
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
<Trade>
<xsl:if test="$version">
<xsl:attribute name="version">
<xsl:value-of select="$version"/>
</xsl:attribute>
</xsl:if>
<SWBMLVersion>
<xsl:value-of select="$SWBMLVersion"/>
</SWBMLVersion>
<BrokerSubmitted>
<xsl:value-of select="$BrokerSubmitted"/>
</BrokerSubmitted>
<BrokerTradeId>
<xsl:value-of select="$BrokerTradeId"/>
</BrokerTradeId>
<TotalLegs>
<xsl:value-of select="$TotalLegs"/>
</TotalLegs>
<BrokerLegId>
<xsl:value-of select="$BrokerLegId"/>
</BrokerLegId>
<ReplacementTradeId>
<xsl:value-of select="$ReplacementTradeId"/>
</ReplacementTradeId>
<ReplacementTradeIdType>
<xsl:value-of select="$ReplacementTradeIdType"/>
</ReplacementTradeIdType>
<ReplacementReason>
<xsl:value-of select="$ReplacementReason"/>
</ReplacementReason>
<StrategyType>
<xsl:value-of select="$StrategyType"/>
</StrategyType>
<StrategyComment>
<xsl:value-of select="$StrategyComment"/>
</StrategyComment>
<BrokerTradeVersionId>
<xsl:value-of select="$BrokerTradeVersionId"/>
</BrokerTradeVersionId>
<LinkedTradeId>
<xsl:value-of select="$LinkedTradeId"/>
</LinkedTradeId>
<TradeSource>
<xsl:value-of select="$TradeSource"/>
</TradeSource>
<xsl:if test="$VenueId != ''">
<VenueId>
<xsl:value-of select="$VenueId"/>
</VenueId>
</xsl:if>
<xsl:if test="$VenueIdScheme != ''">
<VenueIdScheme>
<xsl:value-of select="$VenueIdScheme"/>
</VenueIdScheme>
</xsl:if>
<MessageText>
<xsl:value-of select="$MessageText"/>
</MessageText>
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
<xsl:if test="$PBEBSettlementAgency">
<PBEBSettlementAgency>
<xsl:value-of select="$PBEBSettlementAgency"/>
</PBEBSettlementAgency>
</xsl:if>
<xsl:if test="$PBEBSettlementAgencyModel">
<PBEBSettlementAgencyModel>
<xsl:value-of select="$PBEBSettlementAgencyModel"/>
</PBEBSettlementAgencyModel>
</xsl:if>
<xsl:if test="$PBClientSettlementAgency">
<PBClientSettlementAgency>
<xsl:value-of select="$PBClientSettlementAgency"/>
</PBClientSettlementAgency>
</xsl:if>
<xsl:if test="$PBClientSettlementAgencyModel">
<PBClientSettlementAgencyModel>
<xsl:value-of select="$PBClientSettlementAgencyModel"/>
</PBClientSettlementAgencyModel>
</xsl:if>
<xsl:if test="$ConditionPrecedentBondId">
<ConditionPrecedentBondId>
<xsl:value-of select="$ConditionPrecedentBondId"/>
</ConditionPrecedentBondId>
</xsl:if>
<xsl:if test="$ConditionPrecedentBondMaturity">
<ConditionPrecedentBondMaturity>
<xsl:value-of select="$ConditionPrecedentBondMaturity"/>
</ConditionPrecedentBondMaturity>
</xsl:if>
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
<EmptyBlockTrade>
<xsl:value-of select="$EmptyBlockTrade"/>
</EmptyBlockTrade>
<PrimeBrokerTrade>
<xsl:value-of select="$PrimeBrokerTrade"/>
</PrimeBrokerTrade>
<ReversePrimeBrokerLegalEntities>
<xsl:value-of select="$ReversePrimeBrokerLegalEntities"/>
</ReversePrimeBrokerLegalEntities>
<xsl:copy-of select="$Recipient"/>
<xsl:copy-of select="$PartyAId"/>
<xsl:if test="$PartyAIdType">
<PartyAIdType>
<xsl:value-of select="$PartyAIdType"/>
</PartyAIdType>
</xsl:if>
<PartyAName>
<xsl:value-of select="$PartyAName"/>
</PartyAName>
<xsl:copy-of select="$PartyBId"/>
<xsl:if test="$PartyBIdType">
<PartyBIdType>
<xsl:value-of select="$PartyBIdType"/>
</PartyBIdType>
</xsl:if>
<PartyBName>
<xsl:value-of select="$PartyBName"/>
</PartyBName>
<xsl:copy-of select="$PartyCId"/>
<xsl:if test="$PartyCIdType">
<PartyCIdType>
<xsl:value-of select="$PartyCIdType"/>
</PartyCIdType>
</xsl:if>
<PartyCName>
<xsl:value-of select="$PartyCName"/>
</PartyCName>
<xsl:copy-of select="$PartyDId"/>
<xsl:if test="$PartyDIdType">
<PartyDIdType>
<xsl:value-of select="$PartyDIdType"/>
</PartyDIdType>
</xsl:if>
<PartyDName>
<xsl:value-of select="$PartyDName"/>
</PartyDName>
<xsl:copy-of select="$PartyGId"/>
<xsl:if test="$PartyGIdType">
<PartyGIdType>
<xsl:value-of select="$PartyGIdType"/>
</PartyGIdType>
</xsl:if>
<PartyGName>
<xsl:value-of select="$PartyGName"/>
</PartyGName>
<xsl:copy-of select="$PartyHId"/>
<xsl:if test="$PartyHIdType">
<PartyHIdType>
<xsl:value-of select="$PartyHIdType"/>
</PartyHIdType>
</xsl:if>
<xsl:if test="$PartyHName">
<PartyHName>
<xsl:value-of select="$PartyHName"/>
</PartyHName>
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
<xsl:copy-of select="$BrokerAId"/>
<xsl:copy-of select="$BrokerBId"/>
<NominalTerm>
<xsl:value-of select="$NominalTerm"/>
</NominalTerm>
<FixedRatePayer>
<xsl:value-of select="$FixedRatePayer"/>
</FixedRatePayer>
<FloatingRatePayer>
<xsl:value-of select="$FloatingRatePayer"/>
</FloatingRatePayer>
<xsl:if test="$OptionBuyer">
<OptionBuyer>
<xsl:value-of select="$OptionBuyer"/>
</OptionBuyer>
</xsl:if>
<TradeDate>
<xsl:value-of select="$TradeDate"/>
</TradeDate>
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
<xsl:if test="$FixedRate_2">
<FixedRate_2>
<xsl:value-of select="$FixedRate_2"/>
</FixedRate_2>
</xsl:if>
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
<Strike>
<xsl:value-of select="$Strike"/>
</Strike>
<StrikePercentage>
<xsl:value-of select="$StrikePercentage"/>
</StrikePercentage>
<StrikeDate>
<xsl:value-of select="$StrikeDate"/>
</StrikeDate>
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
<FloatDayBasis_2>
<xsl:value-of select="$FloatDayBasis_2"/>
</FloatDayBasis_2>
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
<xsl:if test="$IndexTenor1_2">
<IndexTenor1_2>
<xsl:value-of select="$IndexTenor1_2"/>
</IndexTenor1_2>
</xsl:if>
<LinearInterpolation>
<xsl:value-of select="$LinearInterpolation"/>
</LinearInterpolation>
<xsl:if test="$LinearInterpolation_2">
<LinearInterpolation_2>
<xsl:value-of select="$LinearInterpolation_2"/>
</LinearInterpolation_2>
</xsl:if>
<NoStubLinearInterpolation>
<xsl:value-of select="$NoStubLinearInterpolation"/>
</NoStubLinearInterpolation>
<NoStubLinearInterpolation2>
<xsl:value-of select="$NoStubLinearInterpolation2"/>
</NoStubLinearInterpolation2>
<IndexTenor2>
<xsl:value-of select="$IndexTenor2"/>
</IndexTenor2>
<xsl:if test="$IndexTenor2_2">
<IndexTenor2_2>
<xsl:value-of select="$IndexTenor2_2"/>
</IndexTenor2_2>
</xsl:if>
<xsl:if test="$InitialInterpolationIndex">
<InitialInterpolationIndex>
<xsl:value-of select="$InitialInterpolationIndex"/>
</InitialInterpolationIndex>
</xsl:if>
<xsl:if test="$InitialInterpolationIndex_2">
<InitialInterpolationIndex_2>
<xsl:value-of select="$InitialInterpolationIndex_2"/>
</InitialInterpolationIndex_2>
</xsl:if>
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
<xsl:if test="$CancelableCalcAgent">
<CancelableCalcAgent>
<xsl:value-of select="$CancelableCalcAgent"/>
</CancelableCalcAgent>
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
<NoBreak>
<xsl:value-of select="$NoBreak"/>
</NoBreak>
<HasBreak>
<xsl:value-of select="$HasBreak"/>
</HasBreak>
<BreakType>
<xsl:value-of select="$BreakType"/>
</BreakType>
<BreakFirstDate>
<xsl:value-of select="$BreakFirstDate"/>
</BreakFirstDate>
<BreakFrequency>
<xsl:value-of select="$BreakFrequency"/>
</BreakFrequency>
<BreakOverride>
<xsl:value-of select="$BreakOverride"/>
</BreakOverride>
<BreakDate>
<xsl:value-of select="$BreakDate"/>
</BreakDate>
<xsl:if test="$BreakEarliestTime">
<BreakEarliestTime>
<xsl:value-of select="$BreakEarliestTime"/>
</BreakEarliestTime>
</xsl:if>
<xsl:if test="$BreakCalcAgentA">
<BreakCalcAgentA>
<xsl:value-of select="$BreakCalcAgentA"/>
</BreakCalcAgentA>
</xsl:if>
<xsl:if test="$BreakExpiryTime">
<BreakExpiryTime>
<xsl:value-of select="$BreakExpiryTime"/>
</BreakExpiryTime>
</xsl:if>
<xsl:if test="$BreakLocation">
<BreakLocation>
<xsl:value-of select="$BreakLocation"/>
</BreakLocation>
</xsl:if>
<xsl:if test="$BreakHolidayCentre">
<BreakHolidayCentre>
<xsl:value-of select="$BreakHolidayCentre"/>
</BreakHolidayCentre>
</xsl:if>
<xsl:if test="$BreakSettlement">
<BreakSettlement>
<xsl:value-of select="$BreakSettlement"/>
</BreakSettlement>
</xsl:if>
<xsl:if test="$BreakValuationDate">
<BreakValuationDate>
<xsl:value-of select="$BreakValuationDate"/>
</BreakValuationDate>
</xsl:if>
<xsl:if test="$BreakValuationTime">
<BreakValuationTime>
<xsl:value-of select="$BreakValuationTime"/>
</BreakValuationTime>
</xsl:if>
<xsl:if test="$BreakMMVApplicableCSA">
<BreakMMVApplicableCSA>
<xsl:value-of select="$BreakMMVApplicableCSA"/>
</BreakMMVApplicableCSA>
</xsl:if>
<xsl:if test="$BreakPrescribedDocAdj">
<BreakPrescribedDocAdj>
<xsl:value-of select="$BreakPrescribedDocAdj"/>
</BreakPrescribedDocAdj>
</xsl:if>
<ExchangeUnderlying>
<xsl:value-of select="$ExchangeUnderlying"/>
</ExchangeUnderlying>
<SpreadCurrency>
<xsl:value-of select="$SpreadCurrency"/>
</SpreadCurrency>
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
<xsl:if test="$NoBackStubLinearInterpolation">
<NoBackStubLinearInterpolation>
<xsl:value-of select="$NoBackStubLinearInterpolation"/>
</NoBackStubLinearInterpolation>
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
<MasterAgreement>
<xsl:value-of select="$MasterAgreement"/>
</MasterAgreement>
<xsl:if test="$MasterAgreementDate">
<MasterAgreementDate>
<xsl:value-of select="$MasterAgreementDate"/>
</MasterAgreementDate>
</xsl:if>
<xsl:if test="$MasterAgreementVersion">
<MasterAgreementVersion>
<xsl:value-of select="$MasterAgreementVersion"/>
</MasterAgreementVersion>
</xsl:if>
<ProductType>
<xsl:value-of select="$ProductType"/>
</ProductType>
<xsl:if test="$ProductSubType">
<ProductSubType>
<xsl:value-of select="$ProductSubType"/>
</ProductSubType>
</xsl:if>
<OptionType>
<xsl:value-of select="$OptionType"/>
</OptionType>
<OptionExpirationDate>
<xsl:value-of select="$OptionExpirationDate"/>
</OptionExpirationDate>
<xsl:if test="$OptionExpirationDateConvention">
<OptionExpirationDateConvention>
<xsl:value-of select="$OptionExpirationDateConvention"/>
</OptionExpirationDateConvention>
</xsl:if>
<OptionHolidayCentres>
<xsl:value-of select="$OptionHolidayCentres"/>
</OptionHolidayCentres>
<OptionEarliestTime>
<xsl:value-of select="$OptionEarliestTime"/>
</OptionEarliestTime>
<OptionExpiryTime>
<xsl:value-of select="$OptionExpiryTime"/>
</OptionExpiryTime>
<xsl:if test="$ValuationTime">
<ValuationTime>
<xsl:value-of select="$ValuationTime"/>
</ValuationTime>
</xsl:if>
<OptionSpecificExpiryTime>
<xsl:value-of select="$OptionSpecificExpiryTime"/>
</OptionSpecificExpiryTime>
<OptionLocation>
<xsl:value-of select="$OptionLocation"/>
</OptionLocation>
<xsl:if test="$OptionCalcAgent">
<OptionCalcAgent>
<xsl:value-of select="$OptionCalcAgent"/>
</OptionCalcAgent>
</xsl:if>
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
<OptionSettlement>
<xsl:value-of select="$OptionSettlement"/>
</OptionSettlement>
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
<ClearedPhysicalSettlement>
<xsl:value-of select="$ClearedPhysicalSettlement"/>
</ClearedPhysicalSettlement>
<xsl:if test="$UnderlyingSwapClearingHouse">
<UnderlyingSwapClearingHouse>
<xsl:value-of select="$UnderlyingSwapClearingHouse"/>
</UnderlyingSwapClearingHouse>
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
<xsl:copy-of select="$Premium"/>
<PremiumHolidayCentres>
<xsl:value-of select="$PremiumHolidayCentres"/>
</PremiumHolidayCentres>
<xsl:copy-of select="$AssociatedFuture"/>
<DocsType>
<xsl:value-of select="$DocsType"/>
</DocsType>
<DocsSubType>
<xsl:value-of select="$DocsSubType"/>
</DocsSubType>
<OptionsComponentSecurityIndexAnnex>
<xsl:value-of select="$OptionsComponentSecurityIndexAnnex"/>
</OptionsComponentSecurityIndexAnnex>
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
<ContractualDefinitions>
<xsl:value-of select="$ContractualDefinitions"/>
</ContractualDefinitions>
<xsl:for-each select="$ContractualSupplement">
<ContractualSupplement>
<xsl:value-of select="."/>
</ContractualSupplement>
</xsl:for-each>
<RestructuringCreditEvent>
<xsl:value-of select="$RestructuringCreditEvent"/>
</RestructuringCreditEvent>
<CalculationAgentCity>
<xsl:value-of select="$CalculationAgentCity"/>
</CalculationAgentCity>
<xsl:copy-of select="$CalculationAgent"/>
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
<xsl:if test="$MortgageInsurer">
<MortgageInsurer>
<xsl:value-of select="$MortgageInsurer"/>
</MortgageInsurer>
</xsl:if>
<IndexName>
<xsl:value-of select="$IndexName"/>
</IndexName>
<IndexId>
<xsl:value-of select="$IndexId"/>
</IndexId>
<IndexSeries>
<xsl:value-of select="$IndexSeries"/>
</IndexSeries>
<IndexVersion>
<xsl:value-of select="$IndexVersion"/>
</IndexVersion>
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
<xsl:copy-of select="$AdditionalPayment"/>
<EquityRic>
<xsl:value-of select="$EquityRic"/>
</EquityRic>
<OptionQuantity>
<xsl:value-of select="$OptionQuantity"/>
</OptionQuantity>
<OptionExpiryMonth>
<xsl:value-of select="$OptionExpiryMonth"/>
</OptionExpiryMonth>
<OptionExpiryYear>
<xsl:value-of select="$OptionExpiryYear"/>
</OptionExpiryYear>
<Price>
<xsl:value-of select="$Price"/>
</Price>
<OptionStyle>
<xsl:value-of select="$OptionStyle"/>
</OptionStyle>
<ExchangeLookAlike>
<xsl:value-of select="$ExchangeLookAlike"/>
</ExchangeLookAlike>
<AdjustmentMethod>
<xsl:value-of select="$AdjustmentMethod"/>
</AdjustmentMethod>
<RelatedExchange>
<xsl:value-of select="$RelatedExchange"/>
</RelatedExchange>
<MasterConfirmationDate>
<xsl:value-of select="$MasterConfirmationDate"/>
</MasterConfirmationDate>
<Multiplier>
<xsl:value-of select="$Multiplier"/>
</Multiplier>
<SettlementCurrency>
<xsl:value-of select="$SettlementCurrency"/>
</SettlementCurrency>
<SettlementCurrency_2>
<xsl:value-of select="$SettlementCurrency_2"/>
</SettlementCurrency_2>
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
<FxDeterminationMethod>
<xsl:value-of select="$FxDeterminationMethod"/>
</FxDeterminationMethod>
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
<ReferenceCurrency>
<xsl:value-of select="$ReferenceCurrency"/>
</ReferenceCurrency>
<ReferenceCurrency_2>
<xsl:value-of select="$ReferenceCurrency_2"/>
</ReferenceCurrency_2>
<DcRequired>
<xsl:value-of select="$DcRequired"/>
</DcRequired>
<DcEventTypeA>
<xsl:value-of select="$DcEventTypeA"/>
</DcEventTypeA>
<DcRic>
<xsl:value-of select="$DcRic"/>
</DcRic>
<DcDescription>
<xsl:value-of select="$DcDescription"/>
</DcDescription>
<DcExpiryMonth>
<xsl:value-of select="$DcExpiryMonth"/>
</DcExpiryMonth>
<DcExpiryYear>
<xsl:value-of select="$DcExpiryYear"/>
</DcExpiryYear>
<DcQuantity>
<xsl:value-of select="$DcQuantity"/>
</DcQuantity>
<DcPrice>
<xsl:value-of select="$DcPrice"/>
</DcPrice>
<DcCurrency>
<xsl:value-of select="$DcCurrency"/>
</DcCurrency>
<DcDelta>
<xsl:value-of select="$DcDelta"/>
</DcDelta>
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
<DcExchangeID>
<xsl:value-of select="$DcExchangeID"/>
</DcExchangeID>
<DcDeltaOptionQuantity>
<xsl:value-of select="$DcDeltaOptionQuantity"/>
</DcDeltaOptionQuantity>
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
<AveragingStartDate>
<xsl:value-of select="$AveragingStartDate"/>
</AveragingStartDate>
<AveragingEndDate>
<xsl:value-of select="$AveragingEndDate"/>
</AveragingEndDate>
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
<BreakOutTrade>
<xsl:value-of select="$BreakOutTrade"/>
</BreakOutTrade>
<SplitCollateral>
<xsl:value-of select="$SplitCollateral"/>
</SplitCollateral>
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
<xsl:if test="$VolatilityCapIndicator">
<VolatilityCapIndicator>
<xsl:value-of select="$VolatilityCapIndicator"/>
</VolatilityCapIndicator>
</xsl:if>
<VarianceCapFactor>
<xsl:value-of select="$VarianceCapFactor"/>
</VarianceCapFactor>
<xsl:if test="$TotalVolatilityCap">
<TotalVolatilityCap>
<xsl:value-of select="$TotalVolatilityCap"/>
</TotalVolatilityCap>
</xsl:if>
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
<xsl:copy-of select="$IndependentAmount"/>
<xsl:copy-of select="$Brokerage"/>
<SettlementRateOption>
<xsl:value-of select="$SettlementRateOption"/>
</SettlementRateOption>
<SettlementRateOption_2>
<xsl:value-of select="$SettlementRateOption_2"/>
</SettlementRateOption_2>
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
<FxFixingPeriod_2>
<xsl:value-of select="$FxFixingPeriod_2"/>
</FxFixingPeriod_2>
<FxFixingDayConvention_2>
<xsl:value-of select="$FxFixingDayConvention_2"/>
</FxFixingDayConvention_2>
<FxFixingCentres_2>
<xsl:value-of select="$FxFixingCentres_2"/>
</FxFixingCentres_2>
<CalcAgentA>
<xsl:value-of select="$CalcAgentA"/>
</CalcAgentA>
<DefaultSettlementMethod>
<xsl:value-of select="$DefaultSettlementMethod"/>
</DefaultSettlementMethod>
<SettlementPriceDefaultElectionMethod>
<xsl:value-of select="$SettlementPriceDefaultElectionMethod"/>
</SettlementPriceDefaultElectionMethod>
<SettlementMethodElectionDate>
<xsl:value-of select="$SettlementMethodElectionDate"/>
</SettlementMethodElectionDate>
<SettlementMethodElectingParty>
<xsl:value-of select="$SettlementMethodElectingParty"/>
</SettlementMethodElectingParty>
<NotionalFutureValue>
<xsl:value-of select="$NotionalFutureValue"/>
</NotionalFutureValue>
<xsl:copy-of select="$NotionalSchedule"/>
<xsl:copy-of select="$DispLegs"/>
<xsl:copy-of select="$DispLegsSW"/>
<BalanceOfPeriod>
<xsl:value-of select="$BalanceOfPeriod"/>
</BalanceOfPeriod>
<BulletIndicator>
<xsl:value-of select="$BulletIndicator"/>
</BulletIndicator>
<BulletFirstContractMonth>
<xsl:value-of select="$BulletFirstContractMonth"/>
</BulletFirstContractMonth>
<BulletLastContractMonth>
<xsl:value-of select="$BulletLastContractMonth"/>
</BulletLastContractMonth>
<BulletContractYear>
<xsl:value-of select="$BulletContractYear"/>
</BulletContractYear>
<BulletContractTradingDay>
<xsl:value-of select="$BulletContractTradingDay"/>
</BulletContractTradingDay>
<ClearingVenue>
<xsl:value-of select="$ClearingVenue"/>
</ClearingVenue>
<ClientClearing>
<xsl:value-of select="$ClientClearing"/>
</ClientClearing>
<ExternalInteropabilityId>
<xsl:value-of select="$ExternalInteropabilityId"/>
</ExternalInteropabilityId>
<InteropNettingString>
<xsl:value-of select="$InteropNettingString"/>
</InteropNettingString>
<AutoSendForClearing>
<xsl:value-of select="$AutoSendForClearing"/>
</AutoSendForClearing>
<ASICMandatoryClearingIndicator>
<xsl:value-of select="$ASICMandatoryClearingIndicator"/>
</ASICMandatoryClearingIndicator>
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
<PBEBTradeMASMandatoryClearingIndicator>
<xsl:value-of select="$PBEBTradeMASMandatoryClearingIndicator"/>
</PBEBTradeMASMandatoryClearingIndicator>
<PBClientTradeMASMandatoryClearingIndicator>
<xsl:value-of select="$PBClientTradeMASMandatoryClearingIndicator"/>
</PBClientTradeMASMandatoryClearingIndicator>
<ClearingHouseId>
<xsl:value-of select="$ClearingHouseId"/>
</ClearingHouseId>
<IntendedClearingHouse>
<xsl:value-of select="$IntendedClearingHouse"/>
</IntendedClearingHouse>
<TraderId>
<xsl:value-of select="$TraderId"/>
</TraderId>
<TraderId_2>
<xsl:value-of select="$TraderId_2"/>
</TraderId_2>
<xsl:if test="$ExecutingBroker">
<ExecutingBroker>
<xsl:value-of select="$ExecutingBroker"/>
</ExecutingBroker>
</xsl:if>
<xsl:if test="$ClearingClient">
<ClearingClient>
<xsl:value-of select="$ClearingClient"/>
</ClearingClient>
</xsl:if>
<xsl:if test="$ClientClearingBroker">
<ClientClearingBroker>
<xsl:value-of select="$ClientClearingBroker"/>
</ClientClearingBroker>
</xsl:if>
<xsl:if test="$EBClearingBroker">
<EBClearingBroker>
<xsl:value-of select="$EBClearingBroker"/>
</EBClearingBroker>
</xsl:if>
<xsl:if test="$PartyAClearingBroker">
<PartyAClearingBroker>
<xsl:value-of select="$PartyAClearingBroker"/>
</PartyAClearingBroker>
</xsl:if>
<xsl:if test="$PartyBClearingBroker">
<PartyBClearingBroker>
<xsl:value-of select="$PartyBClearingBroker"/>
</PartyBClearingBroker>
</xsl:if>
<DisplayPartyLE_Party>
<xsl:value-of select="$DisplayPartyLE_Party"/>
</DisplayPartyLE_Party>
<DisplayPartyLE_Value>
<xsl:value-of select="$DisplayPartyLE_Value"/>
</DisplayPartyLE_Value>
<ClearingNettingParty>
<xsl:value-of select="$ClearingNettingParty"/>
</ClearingNettingParty>
<ClearingNettingString>
<xsl:value-of select="$ClearingNettingString"/>
</ClearingNettingString>
<ClearingNettingParty_2>
<xsl:value-of select="$ClearingNettingParty_2"/>
</ClearingNettingParty_2>
<ClearingNettingString_2>
<xsl:value-of select="$ClearingNettingString_2"/>
</ClearingNettingString_2>
<xsl:if test="$CreditAcceptanceParty">
<CreditAcceptanceParty>
<xsl:value-of select="$CreditAcceptanceParty"/>
</CreditAcceptanceParty>
</xsl:if>
<xsl:if test="$CreditAcceptanceIssuer">
<CreditAcceptanceIssuer>
<xsl:value-of select="$CreditAcceptanceIssuer"/>
</CreditAcceptanceIssuer>
</xsl:if>
<xsl:if test="$CreditAcceptanceToken">
<CreditAcceptanceToken>
<xsl:value-of select="$CreditAcceptanceToken"/>
</CreditAcceptanceToken>
</xsl:if>
<xsl:if test="$CreditAcceptanceParty_2">
<CreditAcceptanceParty_2>
<xsl:value-of select="$CreditAcceptanceParty_2"/>
</CreditAcceptanceParty_2>
</xsl:if>
<xsl:if test="$CreditAcceptanceIssuer_2">
<CreditAcceptanceIssuer_2>
<xsl:value-of select="$CreditAcceptanceIssuer_2"/>
</CreditAcceptanceIssuer_2>
</xsl:if>
<xsl:if test="$CreditAcceptanceToken_2">
<CreditAcceptanceToken_2>
<xsl:value-of select="$CreditAcceptanceToken_2"/>
</CreditAcceptanceToken_2>
</xsl:if>
<CommodityReferencePrice>
<xsl:value-of select="$CommodityReferencePrice"/>
</CommodityReferencePrice>
<CommodityReferencePrice_2>
<xsl:value-of select="$CommodityReferencePrice_2"/>
</CommodityReferencePrice_2>
<CommonPricing>
<xsl:value-of select="$CommonPricing"/>
</CommonPricing>
<DeliveryDates>
<xsl:value-of select="$DeliveryDates"/>
</DeliveryDates>
<DeliveryDates_2>
<xsl:value-of select="$DeliveryDates_2"/>
</DeliveryDates_2>
<DeliveryLocation>
<xsl:value-of select="$DeliveryLocation"/>
</DeliveryLocation>
<FloatCalculationFrequency>
<xsl:value-of select="$FloatCalculationFrequency"/>
</FloatCalculationFrequency>
<FloatCalculationFrequency_2>
<xsl:value-of select="$FloatCalculationFrequency_2"/>
</FloatCalculationFrequency_2>
<PhysicalCommodity>
<xsl:value-of select="$PhysicalCommodity"/>
</PhysicalCommodity>
<PhysicalElectricityProduct>
<xsl:value-of select="$PhysicalElectricityProduct"/>
</PhysicalElectricityProduct>
<PhysicalElectricityForceMajeure>
<xsl:value-of select="$PhysicalElectricityForceMajeure"/>
</PhysicalElectricityForceMajeure>
<PhysicalGasDeliveryType>
<xsl:value-of select="$PhysicalGasDeliveryType"/>
</PhysicalGasDeliveryType>
<ForwardUnderlyer>
<xsl:value-of select="$ForwardUnderlyer"/>
</ForwardUnderlyer>
<FuturesRollConvention>
<xsl:value-of select="$FuturesRollConvention"/>
</FuturesRollConvention>
<FuturesRollConvention_2>
<xsl:value-of select="$FuturesRollConvention_2"/>
</FuturesRollConvention_2>
<LoadShape>
<xsl:value-of select="$LoadShape"/>
</LoadShape>
<LoadShape_2>
<xsl:value-of select="$LoadShape_2"/>
</LoadShape_2>
<NotionalLots>
<xsl:value-of select="$NotionalLots"/>
</NotionalLots>
<NotionalQuantity>
<xsl:value-of select="$NotionalQuantity"/>
</NotionalQuantity>
<NotionalQuantity_2>
<xsl:value-of select="$NotionalQuantity_2"/>
</NotionalQuantity_2>
<PricingDayType>
<xsl:value-of select="$PricingDayType"/>
</PricingDayType>
<PricingDayType_2>
<xsl:value-of select="$PricingDayType_2"/>
</PricingDayType_2>
<PricingFrequency>
<xsl:value-of select="$PricingFrequency"/>
</PricingFrequency>
<PricingFrequency_2>
<xsl:value-of select="$PricingFrequency_2"/>
</PricingFrequency_2>
<PricingHolidayCentres>
<xsl:value-of select="$PricingHolidayCentres"/>
</PricingHolidayCentres>
<PricingHolidayCentres_2>
<xsl:value-of select="$PricingHolidayCentres_2"/>
</PricingHolidayCentres_2>
<PricingLagInterval>
<xsl:value-of select="$PricingLagInterval"/>
</PricingLagInterval>
<PricingLagInterval_2>
<xsl:value-of select="$PricingLagInterval_2"/>
</PricingLagInterval_2>
<PricingLagSkipInterval>
<xsl:value-of select="$PricingLagSkipInterval"/>
</PricingLagSkipInterval>
<PricingLagSkipInterval_2>
<xsl:value-of select="$PricingLagSkipInterval_2"/>
</PricingLagSkipInterval_2>
<PricingRange>
<xsl:value-of select="$PricingRange"/>
</PricingRange>
<PricingRange_2>
<xsl:value-of select="$PricingRange_2"/>
</PricingRange_2>
<SettlementDaysConvention>
<xsl:value-of select="$SettlementDaysConvention"/>
</SettlementDaysConvention>
<SettlementDaysType>
<xsl:value-of select="$SettlementDaysType"/>
</SettlementDaysType>
<SpecifiedPrice>
<xsl:value-of select="$SpecifiedPrice"/>
</SpecifiedPrice>
<SpecifiedPrice_2>
<xsl:value-of select="$SpecifiedPrice_2"/>
</SpecifiedPrice_2>
<UnitFrequency>
<xsl:value-of select="$UnitFrequency"/>
</UnitFrequency>
<Units>
<xsl:value-of select="$Units"/>
</Units>
<Units_2>
<xsl:value-of select="$Units_2"/>
</Units_2>
<ValueDate>
<xsl:value-of select="$ValueDate"/>
</ValueDate>
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
<Rule15A-6>
<xsl:value-of select="$Rule15A-6"/>
</Rule15A-6>
<xsl:copy-of select="$DFData"/>
<xsl:copy-of select="$JFSAData"/>
<xsl:copy-of select="$ESMAData"/>
<xsl:copy-of select="$FCAData"/>
<xsl:copy-of select="$CAData"/>
<xsl:copy-of select="$HKMAData"/>
<xsl:copy-of select="$ASICData"/>
<xsl:copy-of select="$MASData"/>
<xsl:copy-of select="$MIData"/>
<xsl:if test="$ExecTraderA">
<ExecTraderA>
<xsl:value-of select="$ExecTraderA"/>
</ExecTraderA>
</xsl:if>
<xsl:if test="$ExecTraderB">
<ExecTraderB>
<xsl:value-of select="$ExecTraderB"/>
</ExecTraderB>
</xsl:if>
<xsl:copy-of select="$ExecTraderLocationA"/>
<xsl:copy-of select="$ExecTraderLocationB"/>
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
<xsl:if test="$SalesTraderA">
<SalesTraderA>
<xsl:value-of select="$SalesTraderA"/>
</SalesTraderA>
</xsl:if>
<xsl:if test="$SalesTraderB">
<SalesTraderB>
<xsl:value-of select="$SalesTraderB"/>
</SalesTraderB>
</xsl:if>
<xsl:copy-of select="$SalesTraderLocationA"/>
<xsl:copy-of select="$SalesTraderLocationB"/>
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
<xsl:copy-of select="$DeskLocationA"/>
<xsl:copy-of select="$DeskLocationB"/>
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
<xsl:if test="$CounterpartyCountryA">
<CounterpartyCountryA>
<xsl:value-of select="$CounterpartyCountryA"/>
</CounterpartyCountryA>
</xsl:if>
<xsl:if test="$CounterpartyCountryB">
<CounterpartyCountryB>
<xsl:value-of select="$CounterpartyCountryB"/>
</CounterpartyCountryB>
</xsl:if>
<xsl:if test="$InvestFirmNameA">
<InvestFirmNameA>
<xsl:value-of select="$InvestFirmNameA"/>
</InvestFirmNameA>
</xsl:if>
<xsl:if test="$InvestFirmNameB">
<InvestFirmNameB>
<xsl:value-of select="$InvestFirmNameB"/>
</InvestFirmNameB>
</xsl:if>
<xsl:copy-of select="$InvestFirmLocA"/>
<xsl:copy-of select="$InvestFirmLocB"/>
<xsl:if test="$LeiValueA">
<LeiValueA>
<xsl:value-of select="$LeiValueA"/>
</LeiValueA>
</xsl:if>
<xsl:if test="$LeiValueB">
<LeiValueB>
<xsl:value-of select="$LeiValueB"/>
</LeiValueB>
</xsl:if>
<xsl:copy-of select="$UniqueTradeIdentifier"/>
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
<xsl:if test="$EffectiveDate">
<EffectiveDate>
<xsl:value-of select="$EffectiveDate"/>
</EffectiveDate>
</xsl:if>
<xsl:if test="$TerminationDate">
<TerminationDate>
<xsl:value-of select="$TerminationDate"/>
</TerminationDate>
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
<xsl:if test="$PaymentFrequency">
<PaymentFrequency>
<xsl:value-of select="$PaymentFrequency"/>
</PaymentFrequency>
</xsl:if>
<xsl:copy-of select="$DayCountFraction"/>
<xsl:copy-of select="$PartyAOrderDetails"/>
<xsl:copy-of select="$PartyBOrderDetails"/>
<xsl:copy-of select="$PartyAPackageDetails"/>
<xsl:copy-of select="$PartyBPackageDetails"/>
<xsl:if test="$AutoProcessing">
<AutoProcessing>
<xsl:value-of select="$AutoProcessing"/>
</AutoProcessing>
</xsl:if>
<xsl:if test="$AnonymousTrade">
<AnonymousTrade>
<xsl:value-of select="$AnonymousTrade"/>
</AnonymousTrade>
</xsl:if>
<xsl:if test="$GCOffsettingID">
<GCOffsettingID>
<xsl:value-of select="$GCOffsettingID"/>
</GCOffsettingID>
</xsl:if>
<xsl:if test="$CompressionType">
<CompressionType>
<xsl:value-of select="$CompressionType"/>
</CompressionType>
</xsl:if>
<xsl:if test="$GCExecutionMethodParty_1">
<GCExecutionMethodParty_1>
<xsl:value-of select="$GCExecutionMethodParty_1"/>
</GCExecutionMethodParty_1>
</xsl:if>
<xsl:if test="$GCExecutionMethodToken_1">
<GCExecutionMethodToken_1>
<xsl:value-of select="$GCExecutionMethodToken_1"/>
</GCExecutionMethodToken_1>
</xsl:if>
<xsl:if test="$GCExecutionMethodParty_2">
<GCExecutionMethodParty_2>
<xsl:value-of select="$GCExecutionMethodParty_2"/>
</GCExecutionMethodParty_2>
</xsl:if>
<xsl:if test="$GCExecutionMethodToken_2">
<GCExecutionMethodToken_2>
<xsl:value-of select="$GCExecutionMethodToken_2"/>
</GCExecutionMethodToken_2>
</xsl:if>
<xsl:if test="$OTVConfirmation">
<OTVConfirmation>
<xsl:value-of select="$OTVConfirmation"/>
</OTVConfirmation>
</xsl:if>
<xsl:if test="$IntroducingBroker">
<IntroducingBroker>
<xsl:value-of select="$IntroducingBroker"/>
</IntroducingBroker>
</xsl:if>
<xsl:if test="$IntroducingBroker_2">
<IntroducingBroker_2>
<xsl:value-of select="$IntroducingBroker_2"/>
</IntroducingBroker_2>
</xsl:if>
<xsl:if test="$OriginatingEvent">
<OriginatingEvent>
<xsl:value-of select="$OriginatingEvent"/>
</OriginatingEvent>
</xsl:if>
<xsl:copy-of select="$PartyClearingDetails"/>
<xsl:if test="$PackageIdentifierNamespace">
<PackageIdentifierNamespace>
<xsl:value-of select="$PackageIdentifierNamespace"/>
</PackageIdentifierNamespace>
</xsl:if>
<xsl:if test="$PackageIdentifierId">
<PackageIdentifierId>
<xsl:value-of select="$PackageIdentifierId"/>
</PackageIdentifierId>
</xsl:if>
<xsl:if test="$PackageSize">
<PackageSize>
<xsl:value-of select="$PackageSize"/>
</PackageSize>
</xsl:if>
<xsl:if test="$PackageCreditParty">
<PackageCreditParty>
<xsl:value-of select="$PackageCreditParty"/>
</PackageCreditParty>
</xsl:if>
<xsl:if test="$PackageCreditIssuer">
<PackageCreditIssuer>
<xsl:value-of select="$PackageCreditIssuer"/>
</PackageCreditIssuer>
</xsl:if>
<xsl:if test="$PackageCreditToken">
<PackageCreditToken>
<xsl:value-of select="$PackageCreditToken"/>
</PackageCreditToken>
</xsl:if>
<xsl:if test="$PackageCreditParty_2">
<PackageCreditParty_2>
<xsl:value-of select="$PackageCreditParty_2"/>
</PackageCreditParty_2>
</xsl:if>
<xsl:if test="$PackageCreditIssuer_2">
<PackageCreditIssuer_2>
<xsl:value-of select="$PackageCreditIssuer_2"/>
</PackageCreditIssuer_2>
</xsl:if>
<xsl:if test="$PackageCreditToken_2">
<PackageCreditToken_2>
<xsl:value-of select="$PackageCreditToken_2"/>
</PackageCreditToken_2>
</xsl:if>
<xsl:if test="$Tenor">
<Tenor>
<xsl:value-of select="$Tenor"/>
</Tenor>
</xsl:if>
<xsl:if test="$InterestLegDrivenIndicator">
<InterestLegDrivenIndicator>
<xsl:value-of select="$InterestLegDrivenIndicator"/>
</InterestLegDrivenIndicator>
</xsl:if>
<xsl:if test="$EquityFrontStub">
<EquityFrontStub>
<xsl:value-of select="$EquityFrontStub"/>
</EquityFrontStub>
</xsl:if>
<xsl:if test="$EquityEndStub">
<EquityEndStub>
<xsl:value-of select="$EquityEndStub"/>
</EquityEndStub>
</xsl:if>
<xsl:if test="$InterestFrontStub">
<InterestFrontStub>
<xsl:value-of select="$InterestFrontStub"/>
</InterestFrontStub>
</xsl:if>
<xsl:if test="$InterestEndStub">
<InterestEndStub>
<xsl:value-of select="$InterestEndStub"/>
</InterestEndStub>
</xsl:if>
<xsl:if test="$FixedRateIndicator">
<FixedRateIndicator>
<xsl:value-of select="$FixedRateIndicator"/>
</FixedRateIndicator>
</xsl:if>
<xsl:if test="$DividendPaymentDates">
<DividendPaymentDates>
<xsl:value-of select="$DividendPaymentDates"/>
</DividendPaymentDates>
</xsl:if>
<xsl:if test="$DividendPaymentOffset">
<DividendPaymentOffset>
<xsl:value-of select="$DividendPaymentOffset"/>
</DividendPaymentOffset>
</xsl:if>
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
<xsl:if test="$DividendPercentage">
<DividendPercentage>
<xsl:value-of select="$DividendPercentage"/>
</DividendPercentage>
</xsl:if>
<xsl:if test="$DividendReinvestment">
<DividendReinvestment>
<xsl:value-of select="$DividendReinvestment"/>
</DividendReinvestment>
</xsl:if>
<xsl:if test="$EswDeclaredCashDividendPercentage">
<EswDeclaredCashDividendPercentage>
<xsl:value-of select="$EswDeclaredCashDividendPercentage"/>
</EswDeclaredCashDividendPercentage>
</xsl:if>
<xsl:if test="$EswDeclaredCashEquivalentDividendPercentage">
<EswDeclaredCashEquivalentDividendPercentage>
<xsl:value-of select="$EswDeclaredCashEquivalentDividendPercentage"/>
</EswDeclaredCashEquivalentDividendPercentage>
</xsl:if>
<xsl:if test="$EswDividendSettlementCurrency">
<EswDividendSettlementCurrency>
<xsl:value-of select="$EswDividendSettlementCurrency"/>
</EswDividendSettlementCurrency>
</xsl:if>
<xsl:if test="$EswNonCashDividendTreatment">
<EswNonCashDividendTreatment>
<xsl:value-of select="$EswNonCashDividendTreatment"/>
</EswNonCashDividendTreatment>
</xsl:if>
<xsl:if test="$EswDividendComposition">
<EswDividendComposition>
<xsl:value-of select="$EswDividendComposition"/>
</EswDividendComposition>
</xsl:if>
<xsl:if test="$EswSpecialDividends">
<EswSpecialDividends>
<xsl:value-of select="$EswSpecialDividends"/>
</EswSpecialDividends>
</xsl:if>
<xsl:if test="$EswDividendValuationOffset">
<EswDividendValuationOffset>
<xsl:value-of select="$EswDividendValuationOffset"/>
</EswDividendValuationOffset>
</xsl:if>
<xsl:if test="$EswDividendValuationFrequency">
<EswDividendValuationFrequency>
<xsl:value-of select="$EswDividendValuationFrequency"/>
</EswDividendValuationFrequency>
</xsl:if>
<xsl:if test="$EswDividendInitialValuation">
<EswDividendInitialValuation>
<xsl:value-of select="$EswDividendInitialValuation"/>
</EswDividendInitialValuation>
</xsl:if>
<xsl:if test="$EswDividendFinalValuation">
<EswDividendFinalValuation>
<xsl:value-of select="$EswDividendFinalValuation"/>
</EswDividendFinalValuation>
</xsl:if>
<xsl:if test="$EswDividendValuationDay">
<EswDividendValuationDay>
<xsl:value-of select="$EswDividendValuationDay"/>
</EswDividendValuationDay>
</xsl:if>
<xsl:copy-of select="$EswDividendValuationCustomDatesInterim"/>
<xsl:if test="$EswDividendValuationCustomDateFinal">
<EswDividendValuationCustomDateFinal>
<xsl:value-of select="$EswDividendValuationCustomDateFinal"/>
</EswDividendValuationCustomDateFinal>
</xsl:if>
<xsl:if test="$EquityHolidayCentres">
<EquityHolidayCentres>
<xsl:value-of select="$EquityHolidayCentres"/>
</EquityHolidayCentres>
</xsl:if>
<xsl:if test="$OtherValuationBusinessCenters">
<OtherValuationBusinessCenters>
<xsl:value-of select="$OtherValuationBusinessCenters"/>
</OtherValuationBusinessCenters>
</xsl:if>
<xsl:if test="$EswFuturesPriceValuation">
<EswFuturesPriceValuation>
<xsl:value-of select="$EswFuturesPriceValuation"/>
</EswFuturesPriceValuation>
</xsl:if>
<xsl:if test="$EswFpvFinalPriceElectionFallback">
<EswFpvFinalPriceElectionFallback>
<xsl:value-of select="$EswFpvFinalPriceElectionFallback"/>
</EswFpvFinalPriceElectionFallback>
</xsl:if>
<xsl:if test="$EswDesignatedMaturity">
<EswDesignatedMaturity>
<xsl:value-of select="$EswDesignatedMaturity"/>
</EswDesignatedMaturity>
</xsl:if>
<xsl:if test="$EswEquityValConvention">
<EswEquityValConvention>
<xsl:value-of select="$EswEquityValConvention"/>
</EswEquityValConvention>
</xsl:if>
<xsl:if test="$EswInterestFloatConvention">
<EswInterestFloatConvention>
<xsl:value-of select="$EswInterestFloatConvention"/>
</EswInterestFloatConvention>
</xsl:if>
<xsl:if test="$EswInterestFloatDayBasis">
<EswInterestFloatDayBasis>
<xsl:value-of select="$EswInterestFloatDayBasis"/>
</EswInterestFloatDayBasis>
</xsl:if>
<xsl:if test="$EswInterestFloatingRateIndex">
<EswInterestFloatingRateIndex>
<xsl:value-of select="$EswInterestFloatingRateIndex"/>
</EswInterestFloatingRateIndex>
</xsl:if>
<xsl:if test="$EswInterestFixedRate">
<EswInterestFixedRate>
<xsl:value-of select="$EswInterestFixedRate"/>
</EswInterestFixedRate>
</xsl:if>
<xsl:if test="$EswInterestSpreadOverIndex">
<EswInterestSpreadOverIndex>
<xsl:value-of select="$EswInterestSpreadOverIndex"/>
</EswInterestSpreadOverIndex>
</xsl:if>
<xsl:copy-of select="$EswInterestSpreadOverIndexStep"/>
<xsl:if test="$EswLocalJurisdiction">
<EswLocalJurisdiction>
<xsl:value-of select="$EswLocalJurisdiction"/>
</EswLocalJurisdiction>
</xsl:if>
<xsl:if test="$EswReferencePriceSource">
<EswReferencePriceSource>
<xsl:value-of select="$EswReferencePriceSource"/>
</EswReferencePriceSource>
</xsl:if>
<xsl:if test="$EswReferencePricePage">
<EswReferencePricePage>
<xsl:value-of select="$EswReferencePricePage"/>
</EswReferencePricePage>
</xsl:if>
<xsl:if test="$EswReferencePriceTime">
<EswReferencePriceTime>
<xsl:value-of select="$EswReferencePriceTime"/>
</EswReferencePriceTime>
</xsl:if>
<xsl:if test="$EswReferencePriceCity">
<EswReferencePriceCity>
<xsl:value-of select="$EswReferencePriceCity"/>
</EswReferencePriceCity>
</xsl:if>
<xsl:if test="$EswNotionalAmount">
<EswNotionalAmount>
<xsl:value-of select="$EswNotionalAmount"/>
</EswNotionalAmount>
</xsl:if>
<xsl:if test="$EswNotionalCurrency">
<EswNotionalCurrency>
<xsl:value-of select="$EswNotionalCurrency"/>
</EswNotionalCurrency>
</xsl:if>
<xsl:if test="$EswOpenUnits">
<EswOpenUnits>
<xsl:value-of select="$EswOpenUnits"/>
</EswOpenUnits>
</xsl:if>
<xsl:if test="$EswInitialUnits">
<EswInitialUnits>
<xsl:value-of select="$EswInitialUnits"/>
</EswInitialUnits>
</xsl:if>
<xsl:if test="$FeeIn">
<FeeIn>
<xsl:value-of select="$FeeIn"/>
</FeeIn>
</xsl:if>
<xsl:if test="$FeeInOutIndicator">
<FeeInOutIndicator>
<xsl:value-of select="$FeeInOutIndicator"/>
</FeeInOutIndicator>
</xsl:if>
<xsl:if test="$FeeOut">
<FeeOut>
<xsl:value-of select="$FeeOut"/>
</FeeOut>
</xsl:if>
<xsl:if test="$FinalPriceDefaultElection">
<FinalPriceDefaultElection>
<xsl:value-of select="$FinalPriceDefaultElection"/>
</FinalPriceDefaultElection>
</xsl:if>
<xsl:if test="$FinalValuationDate">
<FinalValuationDate>
<xsl:value-of select="$FinalValuationDate"/>
</FinalValuationDate>
</xsl:if>
<xsl:if test="$FullyFundedAmount">
<FullyFundedAmount>
<xsl:value-of select="$FullyFundedAmount"/>
</FullyFundedAmount>
</xsl:if>
<xsl:if test="$FullyFundedIndicator">
<FullyFundedIndicator>
<xsl:value-of select="$FullyFundedIndicator"/>
</FullyFundedIndicator>
</xsl:if>
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
<xsl:if test="$InitialPriceElection">
<InitialPriceElection>
<xsl:value-of select="$InitialPriceElection"/>
</InitialPriceElection>
</xsl:if>
<xsl:if test="$EquityNotionalReset">
<EquityNotionalReset>
<xsl:value-of select="$EquityNotionalReset"/>
</EquityNotionalReset>
</xsl:if>
<xsl:if test="$EswReferenceInitialPrice">
<EswReferenceInitialPrice>
<xsl:value-of select="$EswReferenceInitialPrice"/>
</EswReferenceInitialPrice>
</xsl:if>
<xsl:if test="$EswReferenceFXRate">
<EswReferenceFXRate>
<xsl:value-of select="$EswReferenceFXRate"/>
</EswReferenceFXRate>
</xsl:if>
<xsl:if test="$PaymentDateOffset">
<PaymentDateOffset>
<xsl:value-of select="$PaymentDateOffset"/>
</PaymentDateOffset>
</xsl:if>
<xsl:if test="$EswPaymentHolidayCentres">
<EswPaymentHolidayCentres>
<xsl:value-of select="$EswPaymentHolidayCentres"/>
</EswPaymentHolidayCentres>
</xsl:if>
<xsl:if test="$ReturnType">
<ReturnType>
<xsl:value-of select="$ReturnType"/>
</ReturnType>
</xsl:if>
<xsl:if test="$Synthetic">
<Synthetic>
<xsl:value-of select="$Synthetic"/>
</Synthetic>
</xsl:if>
<xsl:if test="$ValuationDay">
<ValuationDay>
<xsl:value-of select="$ValuationDay"/>
</ValuationDay>
</xsl:if>
<xsl:if test="$PaymentDay">
<PaymentDay>
<xsl:value-of select="$PaymentDay"/>
</PaymentDay>
</xsl:if>
<xsl:if test="$ValuationFrequency">
<ValuationFrequency>
<xsl:value-of select="$ValuationFrequency"/>
</ValuationFrequency>
</xsl:if>
<xsl:if test="$ValuationStartDate">
<ValuationStartDate>
<xsl:value-of select="$ValuationStartDate"/>
</ValuationStartDate>
</xsl:if>
<xsl:if test="$EswSchedulingMethod">
<EswSchedulingMethod>
<xsl:value-of select="$EswSchedulingMethod"/>
</EswSchedulingMethod>
</xsl:if>
<xsl:copy-of select="$EswValuationDates"/>
<xsl:copy-of select="$EswInterestLegPaymentDates"/>
<xsl:copy-of select="$EswEquityLegPaymentDates"/>
<xsl:copy-of select="$EswCompoundingDates"/>
<xsl:if test="$EswCompoundingMethod">
<EswCompoundingMethod>
<xsl:value-of select="$EswCompoundingMethod"/>
</EswCompoundingMethod>
</xsl:if>
<xsl:if test="$EswCompoundingFrequency">
<EswCompoundingFrequency>
<xsl:value-of select="$EswCompoundingFrequency"/>
</EswCompoundingFrequency>
</xsl:if>
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
<xsl:if test="$EswInterpolationMethod">
<EswInterpolationMethod>
<xsl:value-of select="$EswInterpolationMethod"/>
</EswInterpolationMethod>
</xsl:if>
<xsl:if test="$EswInterpolationPeriod">
<EswInterpolationPeriod>
<xsl:value-of select="$EswInterpolationPeriod"/>
</EswInterpolationPeriod>
</xsl:if>
<xsl:if test="$EswPaymentDaysOffset">
<EswPaymentDaysOffset>
<xsl:value-of select="$EswPaymentDaysOffset"/>
</EswPaymentDaysOffset>
</xsl:if>
<xsl:if test="$EswAveragingDatesIndicator">
<EswAveragingDatesIndicator>
<xsl:value-of select="$EswAveragingDatesIndicator"/>
</EswAveragingDatesIndicator>
</xsl:if>
<xsl:if test="$EswADTVIndicator">
<EswADTVIndicator>
<xsl:value-of select="$EswADTVIndicator"/>
</EswADTVIndicator>
</xsl:if>
<xsl:if test="$EswLimitationPercentage">
<EswLimitationPercentage>
<xsl:value-of select="$EswLimitationPercentage"/>
</EswLimitationPercentage>
</xsl:if>
<xsl:if test="$EswLimitationPeriod">
<EswLimitationPeriod>
<xsl:value-of select="$EswLimitationPeriod"/>
</EswLimitationPeriod>
</xsl:if>
<xsl:if test="$EswStockLoanRateIndicator">
<EswStockLoanRateIndicator>
<xsl:value-of select="$EswStockLoanRateIndicator"/>
</EswStockLoanRateIndicator>
</xsl:if>
<xsl:if test="$EswMaximumStockLoanRate">
<EswMaximumStockLoanRate>
<xsl:value-of select="$EswMaximumStockLoanRate"/>
</EswMaximumStockLoanRate>
</xsl:if>
<xsl:if test="$EswInitialStockLoanRate">
<EswInitialStockLoanRate>
<xsl:value-of select="$EswInitialStockLoanRate"/>
</EswInitialStockLoanRate>
</xsl:if>
<xsl:if test="$EswOptionalEarlyTermination">
<EswOptionalEarlyTermination>
<xsl:value-of select="$EswOptionalEarlyTermination"/>
</EswOptionalEarlyTermination>
</xsl:if>
<xsl:if test="$EswBreakFundingRecovery">
<EswBreakFundingRecovery>
<xsl:value-of select="$EswBreakFundingRecovery"/>
</EswBreakFundingRecovery>
</xsl:if>
<xsl:if test="$EswBreakFeeElection">
<EswBreakFeeElection>
<xsl:value-of select="$EswBreakFeeElection"/>
</EswBreakFeeElection>
</xsl:if>
<xsl:if test="$EswBreakFeeRate">
<EswBreakFeeRate>
<xsl:value-of select="$EswBreakFeeRate"/>
</EswBreakFeeRate>
</xsl:if>
<xsl:if test="$EswFinalPriceFee">
<EswFinalPriceFee>
<xsl:value-of select="$EswFinalPriceFee"/>
</EswFinalPriceFee>
</xsl:if>
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
<xsl:if test="$EswEarlyFinalValuationDateElection">
<EswEarlyFinalValuationDateElection>
<xsl:value-of select="$EswEarlyFinalValuationDateElection"/>
</EswEarlyFinalValuationDateElection>
</xsl:if>
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
<xsl:if test="$EswInsolvencyFiling">
<EswInsolvencyFiling>
<xsl:value-of select="$EswInsolvencyFiling"/>
</EswInsolvencyFiling>
</xsl:if>
<xsl:if test="$EswLossOfStockBorrow">
<EswLossOfStockBorrow>
<xsl:value-of select="$EswLossOfStockBorrow"/>
</EswLossOfStockBorrow>
</xsl:if>
<xsl:if test="$EswIncreasedCostOfStockBorrow">
<EswIncreasedCostOfStockBorrow>
<xsl:value-of select="$EswIncreasedCostOfStockBorrow"/>
</EswIncreasedCostOfStockBorrow>
</xsl:if>
<xsl:if test="$EswBulletCompoundingSpread">
<EswBulletCompoundingSpread>
<xsl:value-of select="$EswBulletCompoundingSpread"/>
</EswBulletCompoundingSpread>
</xsl:if>
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
<xsl:copy-of select="$HedgingParty"/>
<xsl:copy-of select="$DeterminingParty"/>
<xsl:if test="$MultipleExchangeIndexAnnex">
<MultipleExchangeIndexAnnex>
<xsl:value-of select="$MultipleExchangeIndexAnnex"/>
</MultipleExchangeIndexAnnex>
</xsl:if>
<xsl:if test="$ComponentSecurityIndexAnnex">
<ComponentSecurityIndexAnnex>
<xsl:value-of select="$ComponentSecurityIndexAnnex"/>
</ComponentSecurityIndexAnnex>
</xsl:if>
<xsl:if test="$EswSpecifiedExchange">
<EswSpecifiedExchange>
<xsl:value-of select="$EswSpecifiedExchange"/>
</EswSpecifiedExchange>
</xsl:if>
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
<xsl:if test="$DirectionComboLEA">
<DirectionComboLEA>
<xsl:value-of select="$DirectionComboLEA"/>
</DirectionComboLEA>
</xsl:if>
<xsl:if test="$DurationType">
<DurationType>
<xsl:value-of select="$DurationType"/>
</DurationType>
</xsl:if>
<xsl:if test="$RateCalcType">
<RateCalcType>
<xsl:value-of select="$RateCalcType"/>
</RateCalcType>
</xsl:if>
<xsl:if test="$SecurityType">
<SecurityType>
<xsl:value-of select="$SecurityType"/>
</SecurityType>
</xsl:if>
<xsl:if test="$OpenRepoRate">
<OpenRepoRate>
<xsl:value-of select="$OpenRepoRate"/>
</OpenRepoRate>
</xsl:if>
<xsl:if test="$OpenRepoSpread">
<OpenRepoSpread>
<xsl:value-of select="$OpenRepoSpread"/>
</OpenRepoSpread>
</xsl:if>
<xsl:if test="$OpenCashAmount">
<OpenCashAmount>
<xsl:value-of select="$OpenCashAmount"/>
</OpenCashAmount>
</xsl:if>
<xsl:if test="$OpenDeliveryMethod">
<OpenDeliveryMethod>
<xsl:value-of select="$OpenDeliveryMethod"/>
</OpenDeliveryMethod>
</xsl:if>
<xsl:if test="$OpenSecurityNominal">
<OpenSecurityNominal>
<xsl:value-of select="$OpenSecurityNominal"/>
</OpenSecurityNominal>
</xsl:if>
<xsl:if test="$OpenSecurityQuantity">
<OpenSecurityQuantity>
<xsl:value-of select="$OpenSecurityQuantity"/>
</OpenSecurityQuantity>
</xsl:if>
<xsl:if test="$CloseCashAmount">
<CloseCashAmount>
<xsl:value-of select="$CloseCashAmount"/>
</CloseCashAmount>
</xsl:if>
<xsl:if test="$CloseDeliveryMethod">
<CloseDeliveryMethod>
<xsl:value-of select="$CloseDeliveryMethod"/>
</CloseDeliveryMethod>
</xsl:if>
<xsl:if test="$CloseSecurityNominal">
<CloseSecurityNominal>
<xsl:value-of select="$CloseSecurityNominal"/>
</CloseSecurityNominal>
</xsl:if>
<xsl:if test="$CloseSecurityQuantity">
<CloseSecurityQuantity>
<xsl:value-of select="$CloseSecurityQuantity"/>
</CloseSecurityQuantity>
</xsl:if>
<xsl:if test="$DayCountBasis">
<DayCountBasis>
<xsl:value-of select="$DayCountBasis"/>
</DayCountBasis>
</xsl:if>
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
<xsl:if test="$SecurityIDType">
<SecurityIDType>
<xsl:value-of select="$SecurityIDType"/>
</SecurityIDType>
</xsl:if>
<xsl:if test="$SecurityID">
<SecurityID>
<xsl:value-of select="$SecurityID"/>
</SecurityID>
</xsl:if>
<xsl:if test="$SecurityDescription">
<SecurityDescription>
<xsl:value-of select="$SecurityDescription"/>
</SecurityDescription>
</xsl:if>
<xsl:if test="$SecurityCurrency">
<SecurityCurrency>
<xsl:value-of select="$SecurityCurrency"/>
</SecurityCurrency>
</xsl:if>
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
</Trade>
</xsl:template>
<xsl:template name="lcl:Trade.Allocation">
<xsl:param name="Payer" select="/.."/>
<xsl:param name="Receiver" select="/.."/>
<xsl:param name="Buyer" select="/.."/>
<xsl:param name="Seller" select="/.."/>
<xsl:param name="swbStreamReference" select="/.."/>
<xsl:param name="AllocatedNotional" select="/.."/>
<xsl:param name="AllocatedNumberOfOptions" select="/.."/>
<xsl:param name="AllocatedVegaNotional" select="/.."/>
<xsl:param name="AllocatedVarianceAmount" select="/.."/>
<xsl:param name="AllocatedUnits" select="/.."/>
<xsl:param name="AllocOpenSecurityNominal" select="/.."/>
<xsl:param name="AllocOpenSecurityQuantity" select="/.."/>
<xsl:param name="AllocGlobalUTI" select="/.."/>
<xsl:param name="ContraAmount" select="/.."/>
<xsl:param name="VariableAmount" select="/.."/>
<xsl:param name="ZCAllocAmount" select="/.."/>
<xsl:param name="ContraZCAllocAmount" select="/.."/>
<xsl:param name="AllocationIndependentAmount" select="/.."/>
<xsl:param name="swbBrokerTradeId" select="/.."/>
<xsl:param name="AllocationOtherPartyPayment" select="/.."/>
<xsl:param name="AllocationClearingBroker" select="/.."/>
<xsl:param name="AllocationPartyAClearingBroker" select="/.."/>
<xsl:param name="AllocationPartyBClearingBroker" select="/.."/>
<xsl:param name="AllocationPayerClearingBroker" select="/.."/>
<xsl:param name="AllocationReceiverClearingBroker" select="/.."/>
<xsl:param name="AllocationNettingParty" select="/.."/>
<xsl:param name="AllocationNettingString" select="/.."/>
<xsl:param name="AllocationNettingParty_2" select="/.."/>
<xsl:param name="AllocationNettingString_2" select="/.."/>
<xsl:param name="AllocationCreditAcceptanceParty" select="/.."/>
<xsl:param name="AllocationCreditAcceptanceIssuer" select="/.."/>
<xsl:param name="AllocationCreditAcceptanceToken" select="/.."/>
<xsl:param name="AllocationCreditAcceptanceParty_2" select="/.."/>
<xsl:param name="AllocationCreditAcceptanceIssuer_2" select="/.."/>
<xsl:param name="AllocationCreditAcceptanceToken_2" select="/.."/>
<xsl:param name="ReportingAllocationData" select="/.."/>
<Allocation>
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
<swbStreamReference>
<xsl:value-of select="$swbStreamReference"/>
</swbStreamReference>
<xsl:copy-of select="$AllocatedNotional"/>
<AllocatedNumberOfOptions>
<xsl:value-of select="$AllocatedNumberOfOptions"/>
</AllocatedNumberOfOptions>
<AllocatedVegaNotional>
<xsl:value-of select="$AllocatedVegaNotional"/>
</AllocatedVegaNotional>
<AllocatedVarianceAmount>
<xsl:value-of select="$AllocatedVarianceAmount"/>
</AllocatedVarianceAmount>
<AllocatedUnits>
<xsl:value-of select="$AllocatedUnits"/>
</AllocatedUnits>
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
<xsl:copy-of select="$AllocationIndependentAmount"/>
<swbBrokerTradeId>
<xsl:value-of select="$swbBrokerTradeId"/>
</swbBrokerTradeId>
<xsl:copy-of select="$AllocationOtherPartyPayment"/>
<xsl:copy-of select="$AllocationClearingBroker"/>
<xsl:if test="$AllocationPartyAClearingBroker">
<AllocationPartyAClearingBroker>
<xsl:value-of select="$AllocationPartyAClearingBroker"/>
</AllocationPartyAClearingBroker>
</xsl:if>
<xsl:if test="$AllocationPartyBClearingBroker">
<AllocationPartyBClearingBroker>
<xsl:value-of select="$AllocationPartyBClearingBroker"/>
</AllocationPartyBClearingBroker>
</xsl:if>
<xsl:if test="$AllocationPayerClearingBroker">
<AllocationPayerClearingBroker>
<xsl:value-of select="$AllocationPayerClearingBroker"/>
</AllocationPayerClearingBroker>
</xsl:if>
<xsl:if test="$AllocationReceiverClearingBroker">
<AllocationReceiverClearingBroker>
<xsl:value-of select="$AllocationReceiverClearingBroker"/>
</AllocationReceiverClearingBroker>
</xsl:if>
<xsl:if test="$AllocationNettingParty">
<AllocationNettingParty>
<xsl:value-of select="$AllocationNettingParty"/>
</AllocationNettingParty>
</xsl:if>
<xsl:if test="$AllocationNettingString">
<AllocationNettingString>
<xsl:value-of select="$AllocationNettingString"/>
</AllocationNettingString>
</xsl:if>
<xsl:if test="$AllocationNettingParty_2">
<AllocationNettingParty_2>
<xsl:value-of select="$AllocationNettingParty_2"/>
</AllocationNettingParty_2>
</xsl:if>
<xsl:if test="$AllocationNettingString_2">
<AllocationNettingString_2>
<xsl:value-of select="$AllocationNettingString_2"/>
</AllocationNettingString_2>
</xsl:if>
<xsl:if test="$AllocationCreditAcceptanceParty">
<AllocationCreditAcceptanceParty>
<xsl:value-of select="$AllocationCreditAcceptanceParty"/>
</AllocationCreditAcceptanceParty>
</xsl:if>
<xsl:if test="$AllocationCreditAcceptanceIssuer">
<AllocationCreditAcceptanceIssuer>
<xsl:value-of select="$AllocationCreditAcceptanceIssuer"/>
</AllocationCreditAcceptanceIssuer>
</xsl:if>
<xsl:if test="$AllocationCreditAcceptanceToken">
<AllocationCreditAcceptanceToken>
<xsl:value-of select="$AllocationCreditAcceptanceToken"/>
</AllocationCreditAcceptanceToken>
</xsl:if>
<xsl:if test="$AllocationCreditAcceptanceParty_2">
<AllocationCreditAcceptanceParty_2>
<xsl:value-of select="$AllocationCreditAcceptanceParty_2"/>
</AllocationCreditAcceptanceParty_2>
</xsl:if>
<xsl:if test="$AllocationCreditAcceptanceIssuer_2">
<AllocationCreditAcceptanceIssuer_2>
<xsl:value-of select="$AllocationCreditAcceptanceIssuer_2"/>
</AllocationCreditAcceptanceIssuer_2>
</xsl:if>
<xsl:if test="$AllocationCreditAcceptanceToken_2">
<AllocationCreditAcceptanceToken_2>
<xsl:value-of select="$AllocationCreditAcceptanceToken_2"/>
</AllocationCreditAcceptanceToken_2>
</xsl:if>
<xsl:copy-of select="$ReportingAllocationData"/>
</Allocation>
</xsl:template>
<xsl:template name="lcl:Trade.Allocation.AllocatedNotional">
<xsl:param name="Currency" select="/.."/>
<xsl:param name="Amount" select="/.."/>
<AllocatedNotional>
<Currency>
<xsl:value-of select="$Currency"/>
</Currency>
<Amount>
<xsl:value-of select="$Amount"/>
</Amount>
</AllocatedNotional>
</xsl:template>
<xsl:template name="lcl:Trade.Allocation.AllocationIndependentAmount">
<xsl:param name="Payer" select="/.."/>
<xsl:param name="Currency" select="/.."/>
<xsl:param name="Amount" select="/.."/>
<AllocationIndependentAmount>
<Payer>
<xsl:value-of select="$Payer"/>
</Payer>
<Currency>
<xsl:value-of select="$Currency"/>
</Currency>
<Amount>
<xsl:value-of select="$Amount"/>
</Amount>
</AllocationIndependentAmount>
</xsl:template>
<xsl:template name="lcl:Trade.Allocation.AllocationOtherPartyPayment">
<xsl:param name="Payer" select="/.."/>
<xsl:param name="Receiver" select="/.."/>
<xsl:param name="Currency" select="/.."/>
<xsl:param name="Amount" select="/.."/>
<AllocationOtherPartyPayment>
<Payer>
<xsl:value-of select="$Payer"/>
</Payer>
<Receiver>
<xsl:value-of select="$Receiver"/>
</Receiver>
<Currency>
<xsl:value-of select="$Currency"/>
</Currency>
<Amount>
<xsl:value-of select="$Amount"/>
</Amount>
</AllocationOtherPartyPayment>
</xsl:template>
<xsl:template name="lcl:Trade.Allocation.AllocationClearingBroker">
<xsl:param name="ClientClearingBroker" select="/.."/>
<xsl:param name="EBClearingBroker" select="/.."/>
<AllocationClearingBroker>
<ClientClearingBroker>
<xsl:value-of select="$ClientClearingBroker"/>
</ClientClearingBroker>
<EBClearingBroker>
<xsl:value-of select="$EBClearingBroker"/>
</EBClearingBroker>
</AllocationClearingBroker>
</xsl:template>
<xsl:template name="lcl:ReportingAllocationData">
<xsl:param name="GlobalUTI" select="/.."/>
<xsl:param name="IntentToBlankGlobalUTI" select="/.."/>
<xsl:param name="DFDataPresent" select="/.."/>
<xsl:param name="USINamespace" select="/.."/>
<xsl:param name="IntentToBlankUSINamespace" select="/.."/>
<xsl:param name="USINamespacePrefix" select="/.."/>
<xsl:param name="USI" select="/.."/>
<xsl:param name="IntentToBlankUSI" select="/.."/>
<xsl:param name="ObligatoryReporting" select="/.."/>
<xsl:param name="ReportingCounterparty" select="/.."/>
<xsl:param name="Collateralized" select="/.."/>
<xsl:param name="SEDataPresent" select="/.."/>
<xsl:param name="SEUTINamespace" select="/.."/>
<xsl:param name="IntentToBlankSEUTINamespace" select="/.."/>
<xsl:param name="SEUTINamespacePrefix" select="/.."/>
<xsl:param name="SEUTI" select="/.."/>
<xsl:param name="IntentToBlankSEUTI" select="/.."/>
<xsl:param name="SEObligatoryReporting" select="/.."/>
<xsl:param name="SEReportingCounterparty" select="/.."/>
<xsl:param name="MIObligatoryReporting" select="/.."/>
<xsl:param name="MIReportingCounterparty" select="/.."/>
<xsl:param name="MITID" select="/.."/>
<xsl:param name="MIIntentToBlankTID" select="/.."/>
<xsl:param name="MITransactionReportable" select="/.."/>
<xsl:param name="MITransparencyReportable" select="/.."/>
<xsl:param name="ESMAUTINamespace" select="/.."/>
<xsl:param name="ESMAIntentToBlankUTINamespace" select="/.."/>
<xsl:param name="ESMAUTI" select="/.."/>
<xsl:param name="ESMAIntentToBlankUTI" select="/.."/>
<xsl:param name="FCAUTINamespace" select="/.."/>
<xsl:param name="FCAIntentToBlankUTINamespace" select="/.."/>
<xsl:param name="FCAUTI" select="/.."/>
<xsl:param name="FCAIntentToBlankUTI" select="/.."/>
<xsl:param name="NexusReportingDetailsPartyA" select="/.."/>
<xsl:param name="NexusReportingDetailsPartyB" select="/.."/>
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
<xsl:if test="$DFDataPresent">
<DFDataPresent>
<xsl:value-of select="$DFDataPresent"/>
</DFDataPresent>
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
<xsl:if test="$Collateralized">
<Collateralized>
<xsl:value-of select="$Collateralized"/>
</Collateralized>
</xsl:if>
<xsl:if test="$SEDataPresent">
<SEDataPresent>
<xsl:value-of select="$SEDataPresent"/>
</SEDataPresent>
</xsl:if>
<xsl:if test="$SEUTINamespace">
<SEUTINamespace>
<xsl:value-of select="$SEUTINamespace"/>
</SEUTINamespace>
</xsl:if>
<xsl:if test="$IntentToBlankSEUTINamespace">
<IntentToBlankSEUTINamespace>
<xsl:value-of select="$IntentToBlankSEUTINamespace"/>
</IntentToBlankSEUTINamespace>
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
<xsl:if test="$IntentToBlankSEUTI">
<IntentToBlankSEUTI>
<xsl:value-of select="$IntentToBlankSEUTI"/>
</IntentToBlankSEUTI>
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
<xsl:copy-of select="$NexusReportingDetailsPartyA"/>
<xsl:copy-of select="$NexusReportingDetailsPartyB"/>
</xsl:template>
<xsl:template name="lcl:NexusReportingDetailsPartyA">
<xsl:param name="ExecutingTraderName" select="/.."/>
<xsl:param name="SalesTraderName" select="/.."/>
<xsl:param name="InvestFirmName" select="/.."/>
<xsl:param name="BranchLocation" select="/.."/>
<xsl:param name="DeskLocation" select="/.."/>
<xsl:param name="ExecutingTraderLocation" select="/.."/>
<xsl:param name="SalesTraderLocation" select="/.."/>
<xsl:param name="InvestFirmLocation" select="/.."/>
<xsl:param name="BokerLocation" select="/.."/>
<xsl:param name="ArrBrokerLocation" select="/.."/>
<NexusReportingDetailsPartyA>
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
<xsl:if test="$BokerLocation">
<BokerLocation>
<xsl:value-of select="$BokerLocation"/>
</BokerLocation>
</xsl:if>
<xsl:if test="$ArrBrokerLocation">
<ArrBrokerLocation>
<xsl:value-of select="$ArrBrokerLocation"/>
</ArrBrokerLocation>
</xsl:if>
</NexusReportingDetailsPartyA>
</xsl:template>
<xsl:template name="lcl:NexusReportingDetailsPartyB">
<xsl:param name="ExecutingTraderName" select="/.."/>
<xsl:param name="SalesTraderName" select="/.."/>
<xsl:param name="InvestFirmName" select="/.."/>
<xsl:param name="BranchLocation" select="/.."/>
<xsl:param name="DeskLocation" select="/.."/>
<xsl:param name="ExecutingTraderLocation" select="/.."/>
<xsl:param name="SalesTraderLocation" select="/.."/>
<xsl:param name="InvestFirmLocation" select="/.."/>
<xsl:param name="BokerLocation" select="/.."/>
<xsl:param name="ArrBrokerLocation" select="/.."/>
<NexusReportingDetailsPartyB>
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
<xsl:if test="$BokerLocation">
<BokerLocation>
<xsl:value-of select="$BokerLocation"/>
</BokerLocation>
</xsl:if>
<xsl:if test="$ArrBrokerLocation">
<ArrBrokerLocation>
<xsl:value-of select="$ArrBrokerLocation"/>
</ArrBrokerLocation>
</xsl:if>
</NexusReportingDetailsPartyB>
</xsl:template>
<xsl:template name="lcl:Trade.Recipient">
<xsl:param name="Id" select="/.."/>
<xsl:param name="Party" select="/.."/>
<xsl:param name="UserName" select="/.."/>
<xsl:param name="TradingBook" select="/.."/>
<xsl:param name="ExecutionMode" select="/.."/>
<Recipient>
<Id>
<xsl:value-of select="$Id"/>
</Id>
<Party>
<xsl:value-of select="$Party"/>
</Party>
<UserName>
<xsl:value-of select="$UserName"/>
</UserName>
<TradingBook>
<xsl:value-of select="$TradingBook"/>
</TradingBook>
<ExecutionMode>
<xsl:value-of select="$ExecutionMode"/>
</ExecutionMode>
</Recipient>
</xsl:template>
<xsl:template name="lcl:Trade.PartyAId">
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
<xsl:template name="lcl:Trade.PartyBId">
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
<xsl:template name="lcl:Trade.PartyCId">
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
<xsl:template name="lcl:Trade.PartyDId">
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
<xsl:template name="lcl:Trade.PartyGId">
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
<xsl:template name="lcl:Trade.PartyHId">
<xsl:param name="content"/>
<xsl:param name="id" select="/.."/>
<PartyHId>
<xsl:if test="$id">
<xsl:attribute name="id">
<xsl:value-of select="$id"/>
</xsl:attribute>
</xsl:if>
<xsl:value-of select="$content"/>
</PartyHId>
</xsl:template>
<xsl:template name="lcl:Trade.PartyTripartyAgentId">
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
<xsl:template name="lcl:Trade.BrokerAId">
<xsl:param name="content"/>
<xsl:param name="id" select="/.."/>
<BrokerAId>
<xsl:if test="$id">
<xsl:attribute name="id">
<xsl:value-of select="$id"/>
</xsl:attribute>
</xsl:if>
<xsl:value-of select="$content"/>
</BrokerAId>
</xsl:template>
<xsl:template name="lcl:Trade.BrokerBId">
<xsl:param name="content"/>
<xsl:param name="id" select="/.."/>
<BrokerBId>
<xsl:if test="$id">
<xsl:attribute name="id">
<xsl:value-of select="$id"/>
</xsl:attribute>
</xsl:if>
<xsl:value-of select="$content"/>
</BrokerBId>
</xsl:template>
<xsl:template name="lcl:Trade.Premium">
<xsl:param name="Currency" select="/.."/>
<xsl:param name="Amount" select="/.."/>
<xsl:param name="Date" select="/.."/>
<Premium>
<xsl:if test="$Currency">
<Currency>
<xsl:value-of select="$Currency"/>
</Currency>
</xsl:if>
<Amount>
<xsl:value-of select="$Amount"/>
</Amount>
<Date>
<xsl:value-of select="$Date"/>
</Date>
</Premium>
</xsl:template>
<xsl:template name="lcl:Trade.AssociatedFuture">
<xsl:param name="Party" select="/.."/>
<xsl:param name="AssociatedFutureName" select="/.."/>
<xsl:param name="AssociatedFutureQuantity" select="/.."/>
<xsl:param name="AssociatedFutureMaturity" select="/.."/>
<xsl:param name="AssociatedFutureDescription" select="/.."/>
<xsl:param name="AssociatedFuturePrice" select="/.."/>
<AssociatedFuture>
<Party>
<xsl:value-of select="$Party"/>
</Party>
<AssociatedFutureName>
<xsl:value-of select="$AssociatedFutureName"/>
</AssociatedFutureName>
<AssociatedFutureQuantity>
<xsl:value-of select="$AssociatedFutureQuantity"/>
</AssociatedFutureQuantity>
<AssociatedFutureMaturity>
<xsl:value-of select="$AssociatedFutureMaturity"/>
</AssociatedFutureMaturity>
<AssociatedFutureDescription>
<xsl:value-of select="$AssociatedFutureDescription"/>
</AssociatedFutureDescription>
<AssociatedFuturePrice>
<xsl:value-of select="$AssociatedFuturePrice"/>
</AssociatedFuturePrice>
</AssociatedFuture>
</xsl:template>
<xsl:template name="lcl:Trade.CalculationAgent">
<xsl:param name="CalculationAgentOccurrence" select="/.."/>
<CalculationAgent>
<xsl:for-each select="$CalculationAgentOccurrence">
<CalculationAgentOccurrence>
<xsl:value-of select="."/>
</CalculationAgentOccurrence>
</xsl:for-each>
</CalculationAgent>
</xsl:template>
<xsl:template name="lcl:Trade.CreditDateAdjustments">
<xsl:param name="Convention" select="/.."/>
<xsl:param name="Holidays" select="/.."/>
<CreditDateAdjustments>
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
</CreditDateAdjustments>
</xsl:template>
<xsl:template name="lcl:Trade.CancelablePremium">
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
<xsl:template name="lcl:Trade.AdditionalPayment">
<xsl:param name="Payer" select="/.."/>
<xsl:param name="Reason" select="/.."/>
<xsl:param name="Currency" select="/.."/>
<xsl:param name="Amount" select="/.."/>
<xsl:param name="Date" select="/.."/>
<xsl:param name="Convention" select="/.."/>
<xsl:param name="Holidays" select="/.."/>
<AdditionalPayment>
<Payer>
<xsl:value-of select="$Payer"/>
</Payer>
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
</AdditionalPayment>
</xsl:template>
<xsl:template name="lcl:Trade.AveragingDateTimes">
<xsl:param name="AveragingDate" select="/.."/>
<AveragingDateTimes>
<xsl:for-each select="$AveragingDate">
<AveragingDate>
<xsl:value-of select="."/>
</AveragingDate>
</xsl:for-each>
</AveragingDateTimes>
</xsl:template>
<xsl:template name="lcl:Trade.DividendPeriods">
<xsl:param name="DividendPeriod" select="/.."/>
<DividendPeriods>
<xsl:copy-of select="$DividendPeriod"/>
</DividendPeriods>
</xsl:template>
<xsl:template name="lcl:Trade.DividendPeriods.DividendPeriod">
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
<xsl:template name="lcl:Trade.FixedPeriods">
<xsl:param name="FixedPayment" select="/.."/>
<FixedPeriods>
<xsl:copy-of select="$FixedPayment"/>
</FixedPeriods>
</xsl:template>
<xsl:template name="lcl:Trade.FixedPeriods.FixedPayment">
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
<xsl:template name="lcl:Trade.HolidayDates">
<xsl:param name="HolidayDate" select="/.."/>
<HolidayDates>
<xsl:for-each select="$HolidayDate">
<HolidayDate>
<xsl:value-of select="."/>
</HolidayDate>
</xsl:for-each>
</HolidayDates>
</xsl:template>
<xsl:template name="lcl:Trade.IndependentAmount">
<xsl:param name="Payer" select="/.."/>
<xsl:param name="Currency" select="/.."/>
<xsl:param name="Amount" select="/.."/>
<xsl:param name="IndependentAmountPercentage" select="/.."/>
<xsl:param name="Date" select="/.."/>
<xsl:param name="Convention" select="/.."/>
<xsl:param name="Holidays" select="/.."/>
<IndependentAmount>
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
</IndependentAmount>
</xsl:template>
<xsl:template name="lcl:Trade.Brokerage">
<xsl:param name="Payer" select="/.."/>
<xsl:param name="Currency" select="/.."/>
<xsl:param name="Amount" select="/.."/>
<xsl:param name="Broker" select="/.."/>
<xsl:param name="BrokerTradeId" select="/.."/>
<Brokerage>
<Payer>
<xsl:value-of select="$Payer"/>
</Payer>
<Currency>
<xsl:value-of select="$Currency"/>
</Currency>
<Amount>
<xsl:value-of select="$Amount"/>
</Amount>
<Broker>
<xsl:value-of select="$Broker"/>
</Broker>
<BrokerTradeId>
<xsl:value-of select="$BrokerTradeId"/>
</BrokerTradeId>
</Brokerage>
</xsl:template>
<xsl:template name="lcl:Trade.NotionalSchedule">
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
<xsl:template name="lcl:Trade.NotionalSchedule.FixedLegNotionalStep">
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
<xsl:template name="lcl:Trade.NotionalSchedule.FixedLegNotionalStep2">
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
<xsl:template name="lcl:Trade.NotionalSchedule.FloatLegNotionalStep">
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
<xsl:template name="lcl:Trade.NotionalSchedule.FloatLegNotionalStep2">
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
<xsl:template name="lcl:Trade.DispLegs">
<xsl:param name="DispLeg" select="/.."/>
<DispLegs>
<xsl:copy-of select="$DispLeg"/>
</DispLegs>
</xsl:template>
<xsl:template name="lcl:Trade.DispLegs.DispLeg">
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
<xsl:template name="lcl:Trade.DispLegsSW">
<xsl:param name="DispLegSW" select="/.."/>
<DispLegsSW>
<xsl:copy-of select="$DispLegSW"/>
</DispLegsSW>
</xsl:template>
<xsl:template name="lcl:Trade.DispLegsSW.DispLegSW">
<xsl:param name="DispCorrespondingLeg" select="/.."/>
<xsl:param name="DispVolatilityStrikePrice" select="/.."/>
<xsl:param name="DispHolidayDates" select="/.."/>
<xsl:param name="DispExpectedNOverride" select="/.."/>
<xsl:param name="DispShareWeight" select="/.."/>
<DispLegSW>
<DispCorrespondingLeg>
<xsl:value-of select="$DispCorrespondingLeg"/>
</DispCorrespondingLeg>
<DispVolatilityStrikePrice>
<xsl:value-of select="$DispVolatilityStrikePrice"/>
</DispVolatilityStrikePrice>
<DispHolidayDates>
<xsl:value-of select="$DispHolidayDates"/>
</DispHolidayDates>
<DispExpectedNOverride>
<xsl:value-of select="$DispExpectedNOverride"/>
</DispExpectedNOverride>
<DispShareWeight>
<xsl:value-of select="$DispShareWeight"/>
</DispShareWeight>
</DispLegSW>
</xsl:template>
<xsl:template name="lcl:DFData">
<xsl:param name="ExecutionType" select="/.."/>
<xsl:param name="PriceNotationType" select="/.."/>
<xsl:param name="PriceNotationValue" select="/.."/>
<xsl:param name="PriceNotation" select="/.."/>
<xsl:param name="AdditionalPriceNotationType" select="/.."/>
<xsl:param name="AdditionalPriceNotationValue" select="/.."/>
<xsl:param name="AdditionalPriceNotation" select="/.."/>
<xsl:param name="GlobalUTI" select="/.."/>
<xsl:param name="IntentToBlankGlobalUTI" select="/.."/>
<xsl:param name="DFDataPresent" select="/.."/>
<xsl:param name="DFRegulatorType" select="/.."/>
<xsl:param name="Route1Destination" select="/.."/>
<xsl:param name="Route1Intermediary" select="/.."/>
<xsl:param name="USINamespace" select="/.."/>
<xsl:param name="IntentToBlankUSINamespace" select="/.."/>
<xsl:param name="USINamespacePrefix" select="/.."/>
<xsl:param name="USI" select="/.."/>
<xsl:param name="IntentToBlankUSI" select="/.."/>
<xsl:param name="ObligatoryReporting" select="/.."/>
<xsl:param name="SecondaryAssetClass" select="/.."/>
<xsl:param name="ReportingCounterparty" select="/.."/>
<xsl:param name="DFClearingMandatory" select="/.."/>
<xsl:param name="SEDataPresent" select="/.."/>
<xsl:param name="SERegulatorType" select="/.."/>
<xsl:param name="SERoute1Destination" select="/.."/>
<xsl:param name="SERoute1Intermediary" select="/.."/>
<xsl:param name="SEUTINamespace" select="/.."/>
<xsl:param name="IntentToBlankSEUTINamespace" select="/.."/>
<xsl:param name="SEUTINamespacePrefix" select="/.."/>
<xsl:param name="SEUTI" select="/.."/>
<xsl:param name="IntentToBlankSEUTI" select="/.."/>
<xsl:param name="SEObligatoryReporting" select="/.."/>
<xsl:param name="SEReportingCounterparty" select="/.."/>
<xsl:param name="ISIN" select="/.."/>
<xsl:param name="CFI" select="/.."/>
<xsl:param name="FullName" select="/.."/>
<xsl:param name="DFLargeSizeTrade" select="/.."/>
<xsl:param name="PartyADFLargeSizeTrade" select="/.."/>
<xsl:param name="PartyBDFLargeSizeTrade" select="/.."/>
<xsl:param name="BlockUSINamespace" select="/.."/>
<xsl:param name="IntentToBlankBlockUSINamespace" select="/.."/>
<xsl:param name="BlockUSI" select="/.."/>
<xsl:param name="IntentToBlankBlockUSI" select="/.."/>
<xsl:param name="ClearingException" select="/.."/>
<xsl:param name="Collateralized" select="/.."/>
<xsl:param name="ConfirmationTime" select="/.."/>
<xsl:param name="EmbeddedOption" select="/.."/>
<xsl:param name="ExecutionTime" select="/.."/>
<xsl:param name="Compression" select="/.."/>
<xsl:param name="ExecutionVenue" select="/.."/>
<xsl:param name="GTRBulkProcessingID" select="/.."/>
<xsl:param name="NonStandardFlag" select="/.."/>
<xsl:param name="GlobalPriorUTI" select="/.."/>
<xsl:param name="GlobalBlockUTI" select="/.."/>
<xsl:param name="OffPlatformConfirmationType" select="/.."/>
<xsl:param name="OffPlatformVerificationType" select="/.."/>
<xsl:param name="ComplexTradeIdA" select="/.."/>
<xsl:param name="ComplexTradeIdB" select="/.."/>
<xsl:param name="ComplexPriceA" select="/.."/>
<xsl:param name="ComplexPriceB" select="/.."/>
<xsl:param name="ComplexPriceTypeA" select="/.."/>
<xsl:param name="ComplexPriceTypeB" select="/.."/>
<xsl:param name="ComplexPriceCCYA" select="/.."/>
<xsl:param name="ComplexPriceCCYB" select="/.."/>
<xsl:param name="PriceFormingEvent" select="/.."/>
<xsl:param name="PrimaryAssetClass" select="/.."/>
<xsl:param name="PriorUSINamespace" select="/.."/>
<xsl:param name="IntentToBlankPriorUSINamespace" select="/.."/>
<xsl:param name="PriorUSI" select="/.."/>
<xsl:param name="IntentToBlankPriorUSI" select="/.."/>
<xsl:param name="ProductIDType" select="/.."/>
<xsl:param name="ProductIDValue" select="/.."/>
<xsl:param name="ReportRT" select="/.."/>
<xsl:param name="ReportPET" select="/.."/>
<xsl:param name="ReportCONF" select="/.."/>
<xsl:param name="PartyABlockUSINamespace" select="/.."/>
<xsl:param name="PartyAIntentToBlankBlockUSINamespace" select="/.."/>
<xsl:param name="PartyABlockUSI" select="/.."/>
<xsl:param name="PartyAIntentToBlankBlockUSI" select="/.."/>
<xsl:param name="PartyAClearingException" select="/.."/>
<xsl:param name="PartyAClearingExceptionReason" select="/.."/>
<xsl:param name="PartyACollateralized" select="/.."/>
<xsl:param name="PartyAConfirmationTime" select="/.."/>
<xsl:param name="PartyAEmbeddedOption" select="/.."/>
<xsl:param name="PartyAExecutionTime" select="/.."/>
<xsl:param name="PartyAExecutionVenue" select="/.."/>
<xsl:param name="PartyAGTRBulkProcessingID" select="/.."/>
<xsl:param name="PartyANonStandardFlag" select="/.."/>
<xsl:param name="PartyAOffPlatformConfirmationType" select="/.."/>
<xsl:param name="PartyAOffPlatformVerificationType" select="/.."/>
<xsl:param name="PartyAPriceFormingEvent" select="/.."/>
<xsl:param name="PartyAPrimaryAssetClass" select="/.."/>
<xsl:param name="PartyAPriorUSINamespace" select="/.."/>
<xsl:param name="PartyAIntentToBlankPriorUSINamespace" select="/.."/>
<xsl:param name="PartyAPriorUSI" select="/.."/>
<xsl:param name="PartyAIntentToBlankPriorUSI" select="/.."/>
<xsl:param name="PartyAProductIDType" select="/.."/>
<xsl:param name="PartyAProductIDValue" select="/.."/>
<xsl:param name="PartyBBlockUSINamespace" select="/.."/>
<xsl:param name="PartyBIntentToBlankBlockUSINamespace" select="/.."/>
<xsl:param name="PartyBBlockUSI" select="/.."/>
<xsl:param name="PartyBIntentToBlankBlockUSI" select="/.."/>
<xsl:param name="PartyBClearingException" select="/.."/>
<xsl:param name="PartyBClearingExceptionReason" select="/.."/>
<xsl:param name="PartyBCollateralized" select="/.."/>
<xsl:param name="PartyBConfirmationTime" select="/.."/>
<xsl:param name="PartyBEmbeddedOption" select="/.."/>
<xsl:param name="PartyBExecutionTime" select="/.."/>
<xsl:param name="PartyBExecutionVenue" select="/.."/>
<xsl:param name="PartyBGTRBulkProcessingID" select="/.."/>
<xsl:param name="PartyBNonStandardFlag" select="/.."/>
<xsl:param name="PartyBOffPlatformConfirmationType" select="/.."/>
<xsl:param name="PartyBOffPlatformVerificationType" select="/.."/>
<xsl:param name="PartyBPriceFormingEvent" select="/.."/>
<xsl:param name="PartyBPrimaryAssetClass" select="/.."/>
<xsl:param name="PartyBPriorUSINamespace" select="/.."/>
<xsl:param name="PartyBIntentToBlankPriorUSINamespace" select="/.."/>
<xsl:param name="PartyBPriorUSI" select="/.."/>
<xsl:param name="PartyBIntentToBlankPriorUSI" select="/.."/>
<xsl:param name="PartyBProductIDType" select="/.."/>
<xsl:param name="PartyBProductIDValue" select="/.."/>
<xsl:param name="PBClientExecutionType" select="/.."/>
<xsl:param name="PBClientPriceNotationType" select="/.."/>
<xsl:param name="PBClientPriceNotationValue" select="/.."/>
<xsl:param name="PBClientAdditionalPriceNotationType" select="/.."/>
<xsl:param name="PBClientAdditionalPriceNotationValue" select="/.."/>
<xsl:param name="PBClientDFDataPresent" select="/.."/>
<xsl:param name="PBClientDFRegulatorType" select="/.."/>
<xsl:param name="PBClientRoute1Destination" select="/.."/>
<xsl:param name="PBClientRoute1Intermediary" select="/.."/>
<xsl:param name="PBClientUSINamespace" select="/.."/>
<xsl:param name="PBClientIntentToBlankUSINamespace" select="/.."/>
<xsl:param name="PBClientUSINamespacePrefix" select="/.."/>
<xsl:param name="PBClientUSI" select="/.."/>
<xsl:param name="PBClientIntentToBlankUSI" select="/.."/>
<xsl:param name="PBClientObligatoryReporting" select="/.."/>
<xsl:param name="PBClientSecondaryAssetClass" select="/.."/>
<xsl:param name="PBClientReportingCounterparty" select="/.."/>
<xsl:param name="PBClientDFClearingMandatory" select="/.."/>
<xsl:param name="PBClientDFLargeSizeTrade" select="/.."/>
<xsl:param name="PartyAPBClientDFLargeSizeTrade" select="/.."/>
<xsl:param name="PartyBPBClientDFLargeSizeTrade" select="/.."/>
<xsl:param name="PBClientBrokerBlockUSINamespace" select="/.."/>
<xsl:param name="PBClientBrokerIntentToBlankBlockUSINamespace" select="/.."/>
<xsl:param name="PBClientBrokerBlockUSI" select="/.."/>
<xsl:param name="PBClientBrokerIntentToBlankBlockUSI" select="/.."/>
<xsl:param name="PBClientBrokerClearingException" select="/.."/>
<xsl:param name="PBClientBrokerCollateralized" select="/.."/>
<xsl:param name="PBClientBrokerConfirmationTime" select="/.."/>
<xsl:param name="PBClientBrokerEmbeddedOption" select="/.."/>
<xsl:param name="PBClientBrokerExecutionTime" select="/.."/>
<xsl:param name="PBClientBrokerExecutionVenue" select="/.."/>
<xsl:param name="PBClientBrokerGTRBulkProcessingID" select="/.."/>
<xsl:param name="PBClientBrokerNonStandardFlag" select="/.."/>
<xsl:param name="PBClientBrokerOffPlatformConfirmationType" select="/.."/>
<xsl:param name="PBClientBrokerOffPlatformVerificationType" select="/.."/>
<xsl:param name="PBClientBrokerPrimaryAssetClass" select="/.."/>
<xsl:param name="PBClientBrokerPriorUSINamespace" select="/.."/>
<xsl:param name="PBClientBrokerIntentToBlankPriorUSINamespace" select="/.."/>
<xsl:param name="PBClientBrokerPriorUSI" select="/.."/>
<xsl:param name="PBClientBrokerIntentToBlankPriorUSI" select="/.."/>
<xsl:param name="PBClientBrokerProductIDType" select="/.."/>
<xsl:param name="PBClientBrokerProductIDValue" select="/.."/>
<xsl:param name="PBClientBrokerReportPET" select="/.."/>
<xsl:param name="PBClientBrokerReportCONF" select="/.."/>
<xsl:param name="PBBlockUSINamespace" select="/.."/>
<xsl:param name="PBIntentToBlankBlockUSINamespace" select="/.."/>
<xsl:param name="PBBlockUSI" select="/.."/>
<xsl:param name="PBIntentToBlankBlockUSI" select="/.."/>
<xsl:param name="PBClearingException" select="/.."/>
<xsl:param name="PBCollateralized" select="/.."/>
<xsl:param name="PBConfirmationTime" select="/.."/>
<xsl:param name="PBEmbeddedOption" select="/.."/>
<xsl:param name="PBExecutionTime" select="/.."/>
<xsl:param name="PBExecutionVenue" select="/.."/>
<xsl:param name="PBGTRBulkProcessingID" select="/.."/>
<xsl:param name="PBNonStandardFlag" select="/.."/>
<xsl:param name="PBOffPlatformConfirmationType" select="/.."/>
<xsl:param name="PBOffPlatformVerificationType" select="/.."/>
<xsl:param name="PBPrimaryAssetClass" select="/.."/>
<xsl:param name="PBPriorUSINamespace" select="/.."/>
<xsl:param name="PBIntentToBlankPriorUSINamespace" select="/.."/>
<xsl:param name="PBPriorUSI" select="/.."/>
<xsl:param name="PBIntentToBlankPriorUSI" select="/.."/>
<xsl:param name="PBProductIDType" select="/.."/>
<xsl:param name="PBProductIDValue" select="/.."/>
<xsl:param name="ClientBlockUSINamespace" select="/.."/>
<xsl:param name="ClientIntentToBlankBlockUSINamespace" select="/.."/>
<xsl:param name="ClientBlockUSI" select="/.."/>
<xsl:param name="ClientIntentToBlankBlockUSI" select="/.."/>
<xsl:param name="ClientClearingException" select="/.."/>
<xsl:param name="ClientCollateralized" select="/.."/>
<xsl:param name="ClientConfirmationTime" select="/.."/>
<xsl:param name="ClientEmbeddedOption" select="/.."/>
<xsl:param name="ClientExecutionTime" select="/.."/>
<xsl:param name="ClientExecutionVenue" select="/.."/>
<xsl:param name="ClientGTRBulkProcessingID" select="/.."/>
<xsl:param name="ClientNonStandardFlag" select="/.."/>
<xsl:param name="ClientOffPlatformConfirmationType" select="/.."/>
<xsl:param name="ClientOffPlatformVerificationType" select="/.."/>
<xsl:param name="ClientPrimaryAssetClass" select="/.."/>
<xsl:param name="ClientPriorUSINamespace" select="/.."/>
<xsl:param name="ClientIntentToBlankPriorUSINamespace" select="/.."/>
<xsl:param name="ClientPriorUSI" select="/.."/>
<xsl:param name="ClientIntentToBlankPriorUSI" select="/.."/>
<xsl:param name="ClientProductIDType" select="/.."/>
<xsl:param name="ClientProductIDValue" select="/.."/>
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
<xsl:if test="$SERoute1Intermediary">
<SERoute1Intermediary>
<xsl:value-of select="$SERoute1Intermediary"/>
</SERoute1Intermediary>
</xsl:if>
<xsl:if test="$SEUTINamespace">
<SEUTINamespace>
<xsl:value-of select="$SEUTINamespace"/>
</SEUTINamespace>
</xsl:if>
<xsl:if test="$IntentToBlankSEUTINamespace">
<IntentToBlankSEUTINamespace>
<xsl:value-of select="$IntentToBlankSEUTINamespace"/>
</IntentToBlankSEUTINamespace>
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
<xsl:if test="$IntentToBlankSEUTI">
<IntentToBlankSEUTI>
<xsl:value-of select="$IntentToBlankSEUTI"/>
</IntentToBlankSEUTI>
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
<xsl:if test="$DFLargeSizeTrade">
<DFLargeSizeTrade>
<xsl:value-of select="$DFLargeSizeTrade"/>
</DFLargeSizeTrade>
</xsl:if>
<xsl:if test="$PartyADFLargeSizeTrade">
<PartyADFLargeSizeTrade>
<xsl:value-of select="$PartyADFLargeSizeTrade"/>
</PartyADFLargeSizeTrade>
</xsl:if>
<xsl:if test="$PartyBDFLargeSizeTrade">
<PartyBDFLargeSizeTrade>
<xsl:value-of select="$PartyBDFLargeSizeTrade"/>
</PartyBDFLargeSizeTrade>
</xsl:if>
<xsl:if test="$BlockUSINamespace">
<BlockUSINamespace>
<xsl:value-of select="$BlockUSINamespace"/>
</BlockUSINamespace>
</xsl:if>
<xsl:if test="$IntentToBlankBlockUSINamespace">
<IntentToBlankBlockUSINamespace>
<xsl:value-of select="$IntentToBlankBlockUSINamespace"/>
</IntentToBlankBlockUSINamespace>
</xsl:if>
<xsl:if test="$BlockUSI">
<BlockUSI>
<xsl:value-of select="$BlockUSI"/>
</BlockUSI>
</xsl:if>
<xsl:if test="$IntentToBlankBlockUSI">
<IntentToBlankBlockUSI>
<xsl:value-of select="$IntentToBlankBlockUSI"/>
</IntentToBlankBlockUSI>
</xsl:if>
<xsl:if test="$ClearingException">
<ClearingException>
<xsl:value-of select="$ClearingException"/>
</ClearingException>
</xsl:if>
<xsl:if test="$Collateralized">
<Collateralized>
<xsl:value-of select="$Collateralized"/>
</Collateralized>
</xsl:if>
<xsl:if test="$ConfirmationTime">
<ConfirmationTime>
<xsl:value-of select="$ConfirmationTime"/>
</ConfirmationTime>
</xsl:if>
<xsl:if test="$EmbeddedOption">
<EmbeddedOption>
<xsl:value-of select="$EmbeddedOption"/>
</EmbeddedOption>
</xsl:if>
<xsl:if test="$ExecutionTime">
<ExecutionTime>
<xsl:value-of select="$ExecutionTime"/>
</ExecutionTime>
</xsl:if>
<xsl:if test="$Compression">
<Compression>
<xsl:value-of select="$Compression"/>
</Compression>
</xsl:if>
<xsl:if test="$ExecutionVenue">
<ExecutionVenue>
<xsl:value-of select="$ExecutionVenue"/>
</ExecutionVenue>
</xsl:if>
<xsl:if test="$GTRBulkProcessingID">
<GTRBulkProcessingID>
<xsl:value-of select="$GTRBulkProcessingID"/>
</GTRBulkProcessingID>
</xsl:if>
<xsl:if test="$NonStandardFlag">
<NonStandardFlag>
<xsl:value-of select="$NonStandardFlag"/>
</NonStandardFlag>
</xsl:if>
<xsl:if test="$GlobalPriorUTI">
<GlobalPriorUTI>
<xsl:value-of select="$GlobalPriorUTI"/>
</GlobalPriorUTI>
</xsl:if>
<xsl:if test="$GlobalBlockUTI">
<GlobalBlockUTI>
<xsl:value-of select="$GlobalBlockUTI"/>
</GlobalBlockUTI>
</xsl:if>
<xsl:if test="$OffPlatformConfirmationType">
<OffPlatformConfirmationType>
<xsl:value-of select="$OffPlatformConfirmationType"/>
</OffPlatformConfirmationType>
</xsl:if>
<xsl:if test="$OffPlatformVerificationType">
<OffPlatformVerificationType>
<xsl:value-of select="$OffPlatformVerificationType"/>
</OffPlatformVerificationType>
</xsl:if>
<xsl:if test="$ComplexTradeIdA">
<ComplexTradeIdA>
<xsl:value-of select="$ComplexTradeIdA"/>
</ComplexTradeIdA>
</xsl:if>
<xsl:if test="$ComplexTradeIdB">
<ComplexTradeIdB>
<xsl:value-of select="$ComplexTradeIdB"/>
</ComplexTradeIdB>
</xsl:if>
<xsl:if test="$ComplexPriceA">
<ComplexPriceA>
<xsl:value-of select="$ComplexPriceA"/>
</ComplexPriceA>
</xsl:if>
<xsl:if test="$ComplexPriceB">
<ComplexPriceB>
<xsl:value-of select="$ComplexPriceB"/>
</ComplexPriceB>
</xsl:if>
<xsl:if test="$ComplexPriceTypeA">
<ComplexPriceTypeA>
<xsl:value-of select="$ComplexPriceTypeA"/>
</ComplexPriceTypeA>
</xsl:if>
<xsl:if test="$ComplexPriceTypeB">
<ComplexPriceTypeB>
<xsl:value-of select="$ComplexPriceTypeB"/>
</ComplexPriceTypeB>
</xsl:if>
<xsl:if test="$ComplexPriceCCYA">
<ComplexPriceCCYA>
<xsl:value-of select="$ComplexPriceCCYA"/>
</ComplexPriceCCYA>
</xsl:if>
<xsl:if test="$ComplexPriceCCYB">
<ComplexPriceCCYB>
<xsl:value-of select="$ComplexPriceCCYB"/>
</ComplexPriceCCYB>
</xsl:if>
<xsl:if test="$PriceFormingEvent">
<PriceFormingEvent>
<xsl:value-of select="$PriceFormingEvent"/>
</PriceFormingEvent>
</xsl:if>
<xsl:if test="$PrimaryAssetClass">
<PrimaryAssetClass>
<xsl:value-of select="$PrimaryAssetClass"/>
</PrimaryAssetClass>
</xsl:if>
<xsl:if test="$PriorUSINamespace">
<PriorUSINamespace>
<xsl:value-of select="$PriorUSINamespace"/>
</PriorUSINamespace>
</xsl:if>
<xsl:if test="$IntentToBlankPriorUSINamespace">
<IntentToBlankPriorUSINamespace>
<xsl:value-of select="$IntentToBlankPriorUSINamespace"/>
</IntentToBlankPriorUSINamespace>
</xsl:if>
<xsl:if test="$PriorUSI">
<PriorUSI>
<xsl:value-of select="$PriorUSI"/>
</PriorUSI>
</xsl:if>
<xsl:if test="$IntentToBlankPriorUSI">
<IntentToBlankPriorUSI>
<xsl:value-of select="$IntentToBlankPriorUSI"/>
</IntentToBlankPriorUSI>
</xsl:if>
<xsl:if test="$ProductIDType">
<ProductIDType>
<xsl:value-of select="$ProductIDType"/>
</ProductIDType>
</xsl:if>
<xsl:if test="$ProductIDValue">
<ProductIDValue>
<xsl:value-of select="$ProductIDValue"/>
</ProductIDValue>
</xsl:if>
<xsl:if test="$ReportRT">
<ReportRT>
<xsl:value-of select="$ReportRT"/>
</ReportRT>
</xsl:if>
<xsl:if test="$ReportPET">
<ReportPET>
<xsl:value-of select="$ReportPET"/>
</ReportPET>
</xsl:if>
<xsl:if test="$ReportCONF">
<ReportCONF>
<xsl:value-of select="$ReportCONF"/>
</ReportCONF>
</xsl:if>
<xsl:if test="$PartyABlockUSINamespace">
<PartyABlockUSINamespace>
<xsl:value-of select="$PartyABlockUSINamespace"/>
</PartyABlockUSINamespace>
</xsl:if>
<xsl:if test="$PartyAIntentToBlankBlockUSINamespace">
<PartyAIntentToBlankBlockUSINamespace>
<xsl:value-of select="$PartyAIntentToBlankBlockUSINamespace"/>
</PartyAIntentToBlankBlockUSINamespace>
</xsl:if>
<xsl:if test="$PartyABlockUSI">
<PartyABlockUSI>
<xsl:value-of select="$PartyABlockUSI"/>
</PartyABlockUSI>
</xsl:if>
<xsl:if test="$PartyAIntentToBlankBlockUSI">
<PartyAIntentToBlankBlockUSI>
<xsl:value-of select="$PartyAIntentToBlankBlockUSI"/>
</PartyAIntentToBlankBlockUSI>
</xsl:if>
<xsl:if test="$PartyAClearingException">
<PartyAClearingException>
<xsl:value-of select="$PartyAClearingException"/>
</PartyAClearingException>
</xsl:if>
<xsl:if test="$PartyAClearingExceptionReason">
<PartyAClearingExceptionReason>
<xsl:value-of select="$PartyAClearingExceptionReason"/>
</PartyAClearingExceptionReason>
</xsl:if>
<xsl:if test="$PartyACollateralized">
<PartyACollateralized>
<xsl:value-of select="$PartyACollateralized"/>
</PartyACollateralized>
</xsl:if>
<xsl:if test="$PartyAConfirmationTime">
<PartyAConfirmationTime>
<xsl:value-of select="$PartyAConfirmationTime"/>
</PartyAConfirmationTime>
</xsl:if>
<xsl:if test="$PartyAEmbeddedOption">
<PartyAEmbeddedOption>
<xsl:value-of select="$PartyAEmbeddedOption"/>
</PartyAEmbeddedOption>
</xsl:if>
<xsl:if test="$PartyAExecutionTime">
<PartyAExecutionTime>
<xsl:value-of select="$PartyAExecutionTime"/>
</PartyAExecutionTime>
</xsl:if>
<xsl:if test="$PartyAExecutionVenue">
<PartyAExecutionVenue>
<xsl:value-of select="$PartyAExecutionVenue"/>
</PartyAExecutionVenue>
</xsl:if>
<xsl:if test="$PartyAGTRBulkProcessingID">
<PartyAGTRBulkProcessingID>
<xsl:value-of select="$PartyAGTRBulkProcessingID"/>
</PartyAGTRBulkProcessingID>
</xsl:if>
<xsl:if test="$PartyANonStandardFlag">
<PartyANonStandardFlag>
<xsl:value-of select="$PartyANonStandardFlag"/>
</PartyANonStandardFlag>
</xsl:if>
<xsl:if test="$PartyAOffPlatformConfirmationType">
<PartyAOffPlatformConfirmationType>
<xsl:value-of select="$PartyAOffPlatformConfirmationType"/>
</PartyAOffPlatformConfirmationType>
</xsl:if>
<xsl:if test="$PartyAOffPlatformVerificationType">
<PartyAOffPlatformVerificationType>
<xsl:value-of select="$PartyAOffPlatformVerificationType"/>
</PartyAOffPlatformVerificationType>
</xsl:if>
<xsl:if test="$PartyAPriceFormingEvent">
<PartyAPriceFormingEvent>
<xsl:value-of select="$PartyAPriceFormingEvent"/>
</PartyAPriceFormingEvent>
</xsl:if>
<xsl:if test="$PartyAPrimaryAssetClass">
<PartyAPrimaryAssetClass>
<xsl:value-of select="$PartyAPrimaryAssetClass"/>
</PartyAPrimaryAssetClass>
</xsl:if>
<xsl:if test="$PartyAPriorUSINamespace">
<PartyAPriorUSINamespace>
<xsl:value-of select="$PartyAPriorUSINamespace"/>
</PartyAPriorUSINamespace>
</xsl:if>
<xsl:if test="$PartyAIntentToBlankPriorUSINamespace">
<PartyAIntentToBlankPriorUSINamespace>
<xsl:value-of select="$PartyAIntentToBlankPriorUSINamespace"/>
</PartyAIntentToBlankPriorUSINamespace>
</xsl:if>
<xsl:if test="$PartyAPriorUSI">
<PartyAPriorUSI>
<xsl:value-of select="$PartyAPriorUSI"/>
</PartyAPriorUSI>
</xsl:if>
<xsl:if test="$PartyAIntentToBlankPriorUSI">
<PartyAIntentToBlankPriorUSI>
<xsl:value-of select="$PartyAIntentToBlankPriorUSI"/>
</PartyAIntentToBlankPriorUSI>
</xsl:if>
<xsl:if test="$PartyAProductIDType">
<PartyAProductIDType>
<xsl:value-of select="$PartyAProductIDType"/>
</PartyAProductIDType>
</xsl:if>
<xsl:if test="$PartyAProductIDValue">
<PartyAProductIDValue>
<xsl:value-of select="$PartyAProductIDValue"/>
</PartyAProductIDValue>
</xsl:if>
<xsl:if test="$PartyBBlockUSINamespace">
<PartyBBlockUSINamespace>
<xsl:value-of select="$PartyBBlockUSINamespace"/>
</PartyBBlockUSINamespace>
</xsl:if>
<xsl:if test="$PartyBIntentToBlankBlockUSINamespace">
<PartyBIntentToBlankBlockUSINamespace>
<xsl:value-of select="$PartyBIntentToBlankBlockUSINamespace"/>
</PartyBIntentToBlankBlockUSINamespace>
</xsl:if>
<xsl:if test="$PartyBBlockUSI">
<PartyBBlockUSI>
<xsl:value-of select="$PartyBBlockUSI"/>
</PartyBBlockUSI>
</xsl:if>
<xsl:if test="$PartyBIntentToBlankBlockUSI">
<PartyBIntentToBlankBlockUSI>
<xsl:value-of select="$PartyBIntentToBlankBlockUSI"/>
</PartyBIntentToBlankBlockUSI>
</xsl:if>
<xsl:if test="$PartyBClearingException">
<PartyBClearingException>
<xsl:value-of select="$PartyBClearingException"/>
</PartyBClearingException>
</xsl:if>
<xsl:if test="$PartyBClearingExceptionReason">
<PartyBClearingExceptionReason>
<xsl:value-of select="$PartyBClearingExceptionReason"/>
</PartyBClearingExceptionReason>
</xsl:if>
<xsl:if test="$PartyBCollateralized">
<PartyBCollateralized>
<xsl:value-of select="$PartyBCollateralized"/>
</PartyBCollateralized>
</xsl:if>
<xsl:if test="$PartyBConfirmationTime">
<PartyBConfirmationTime>
<xsl:value-of select="$PartyBConfirmationTime"/>
</PartyBConfirmationTime>
</xsl:if>
<xsl:if test="$PartyBEmbeddedOption">
<PartyBEmbeddedOption>
<xsl:value-of select="$PartyBEmbeddedOption"/>
</PartyBEmbeddedOption>
</xsl:if>
<xsl:if test="$PartyBExecutionTime">
<PartyBExecutionTime>
<xsl:value-of select="$PartyBExecutionTime"/>
</PartyBExecutionTime>
</xsl:if>
<xsl:if test="$PartyBExecutionVenue">
<PartyBExecutionVenue>
<xsl:value-of select="$PartyBExecutionVenue"/>
</PartyBExecutionVenue>
</xsl:if>
<xsl:if test="$PartyBGTRBulkProcessingID">
<PartyBGTRBulkProcessingID>
<xsl:value-of select="$PartyBGTRBulkProcessingID"/>
</PartyBGTRBulkProcessingID>
</xsl:if>
<xsl:if test="$PartyBNonStandardFlag">
<PartyBNonStandardFlag>
<xsl:value-of select="$PartyBNonStandardFlag"/>
</PartyBNonStandardFlag>
</xsl:if>
<xsl:if test="$PartyBOffPlatformConfirmationType">
<PartyBOffPlatformConfirmationType>
<xsl:value-of select="$PartyBOffPlatformConfirmationType"/>
</PartyBOffPlatformConfirmationType>
</xsl:if>
<xsl:if test="$PartyBOffPlatformVerificationType">
<PartyBOffPlatformVerificationType>
<xsl:value-of select="$PartyBOffPlatformVerificationType"/>
</PartyBOffPlatformVerificationType>
</xsl:if>
<xsl:if test="$PartyBPriceFormingEvent">
<PartyBPriceFormingEvent>
<xsl:value-of select="$PartyBPriceFormingEvent"/>
</PartyBPriceFormingEvent>
</xsl:if>
<xsl:if test="$PartyBPrimaryAssetClass">
<PartyBPrimaryAssetClass>
<xsl:value-of select="$PartyBPrimaryAssetClass"/>
</PartyBPrimaryAssetClass>
</xsl:if>
<xsl:if test="$PartyBPriorUSINamespace">
<PartyBPriorUSINamespace>
<xsl:value-of select="$PartyBPriorUSINamespace"/>
</PartyBPriorUSINamespace>
</xsl:if>
<xsl:if test="$PartyBIntentToBlankPriorUSINamespace">
<PartyBIntentToBlankPriorUSINamespace>
<xsl:value-of select="$PartyBIntentToBlankPriorUSINamespace"/>
</PartyBIntentToBlankPriorUSINamespace>
</xsl:if>
<xsl:if test="$PartyBPriorUSI">
<PartyBPriorUSI>
<xsl:value-of select="$PartyBPriorUSI"/>
</PartyBPriorUSI>
</xsl:if>
<xsl:if test="$PartyBIntentToBlankPriorUSI">
<PartyBIntentToBlankPriorUSI>
<xsl:value-of select="$PartyBIntentToBlankPriorUSI"/>
</PartyBIntentToBlankPriorUSI>
</xsl:if>
<xsl:if test="$PartyBProductIDType">
<PartyBProductIDType>
<xsl:value-of select="$PartyBProductIDType"/>
</PartyBProductIDType>
</xsl:if>
<xsl:if test="$PartyBProductIDValue">
<PartyBProductIDValue>
<xsl:value-of select="$PartyBProductIDValue"/>
</PartyBProductIDValue>
</xsl:if>
<xsl:if test="$PBClientExecutionType">
<PBClientExecutionType>
<xsl:value-of select="$PBClientExecutionType"/>
</PBClientExecutionType>
</xsl:if>
<xsl:if test="$PBClientPriceNotationType">
<PBClientPriceNotationType>
<xsl:value-of select="$PBClientPriceNotationType"/>
</PBClientPriceNotationType>
</xsl:if>
<xsl:if test="$PBClientPriceNotationValue">
<PBClientPriceNotationValue>
<xsl:value-of select="$PBClientPriceNotationValue"/>
</PBClientPriceNotationValue>
</xsl:if>
<xsl:if test="$PBClientAdditionalPriceNotationType">
<PBClientAdditionalPriceNotationType>
<xsl:value-of select="$PBClientAdditionalPriceNotationType"/>
</PBClientAdditionalPriceNotationType>
</xsl:if>
<xsl:if test="$PBClientAdditionalPriceNotationValue">
<PBClientAdditionalPriceNotationValue>
<xsl:value-of select="$PBClientAdditionalPriceNotationValue"/>
</PBClientAdditionalPriceNotationValue>
</xsl:if>
<xsl:if test="$PBClientDFDataPresent">
<PBClientDFDataPresent>
<xsl:value-of select="$PBClientDFDataPresent"/>
</PBClientDFDataPresent>
</xsl:if>
<xsl:if test="$PBClientDFRegulatorType">
<PBClientDFRegulatorType>
<xsl:value-of select="$PBClientDFRegulatorType"/>
</PBClientDFRegulatorType>
</xsl:if>
<xsl:if test="$PBClientRoute1Destination">
<PBClientRoute1Destination>
<xsl:value-of select="$PBClientRoute1Destination"/>
</PBClientRoute1Destination>
</xsl:if>
<xsl:if test="$PBClientRoute1Intermediary">
<PBClientRoute1Intermediary>
<xsl:value-of select="$PBClientRoute1Intermediary"/>
</PBClientRoute1Intermediary>
</xsl:if>
<xsl:if test="$PBClientUSINamespace">
<PBClientUSINamespace>
<xsl:value-of select="$PBClientUSINamespace"/>
</PBClientUSINamespace>
</xsl:if>
<xsl:if test="$PBClientIntentToBlankUSINamespace">
<PBClientIntentToBlankUSINamespace>
<xsl:value-of select="$PBClientIntentToBlankUSINamespace"/>
</PBClientIntentToBlankUSINamespace>
</xsl:if>
<xsl:if test="$PBClientUSINamespacePrefix">
<PBClientUSINamespacePrefix>
<xsl:value-of select="$PBClientUSINamespacePrefix"/>
</PBClientUSINamespacePrefix>
</xsl:if>
<xsl:if test="$PBClientUSI">
<PBClientUSI>
<xsl:value-of select="$PBClientUSI"/>
</PBClientUSI>
</xsl:if>
<xsl:if test="$PBClientIntentToBlankUSI">
<PBClientIntentToBlankUSI>
<xsl:value-of select="$PBClientIntentToBlankUSI"/>
</PBClientIntentToBlankUSI>
</xsl:if>
<xsl:if test="$PBClientObligatoryReporting">
<PBClientObligatoryReporting>
<xsl:value-of select="$PBClientObligatoryReporting"/>
</PBClientObligatoryReporting>
</xsl:if>
<xsl:if test="$PBClientSecondaryAssetClass">
<PBClientSecondaryAssetClass>
<xsl:value-of select="$PBClientSecondaryAssetClass"/>
</PBClientSecondaryAssetClass>
</xsl:if>
<xsl:if test="$PBClientReportingCounterparty">
<PBClientReportingCounterparty>
<xsl:value-of select="$PBClientReportingCounterparty"/>
</PBClientReportingCounterparty>
</xsl:if>
<xsl:if test="$PBClientDFClearingMandatory">
<PBClientDFClearingMandatory>
<xsl:value-of select="$PBClientDFClearingMandatory"/>
</PBClientDFClearingMandatory>
</xsl:if>
<xsl:if test="$PBClientDFLargeSizeTrade">
<PBClientDFLargeSizeTrade>
<xsl:value-of select="$PBClientDFLargeSizeTrade"/>
</PBClientDFLargeSizeTrade>
</xsl:if>
<xsl:if test="$PartyAPBClientDFLargeSizeTrade">
<PartyAPBClientDFLargeSizeTrade>
<xsl:value-of select="$PartyAPBClientDFLargeSizeTrade"/>
</PartyAPBClientDFLargeSizeTrade>
</xsl:if>
<xsl:if test="$PartyBPBClientDFLargeSizeTrade">
<PartyBPBClientDFLargeSizeTrade>
<xsl:value-of select="$PartyBPBClientDFLargeSizeTrade"/>
</PartyBPBClientDFLargeSizeTrade>
</xsl:if>
<xsl:if test="$PBClientBrokerBlockUSINamespace">
<PBClientBrokerBlockUSINamespace>
<xsl:value-of select="$PBClientBrokerBlockUSINamespace"/>
</PBClientBrokerBlockUSINamespace>
</xsl:if>
<xsl:if test="$PBClientBrokerIntentToBlankBlockUSINamespace">
<PBClientBrokerIntentToBlankBlockUSINamespace>
<xsl:value-of select="$PBClientBrokerIntentToBlankBlockUSINamespace"/>
</PBClientBrokerIntentToBlankBlockUSINamespace>
</xsl:if>
<xsl:if test="$PBClientBrokerBlockUSI">
<PBClientBrokerBlockUSI>
<xsl:value-of select="$PBClientBrokerBlockUSI"/>
</PBClientBrokerBlockUSI>
</xsl:if>
<xsl:if test="$PBClientBrokerIntentToBlankBlockUSI">
<PBClientBrokerIntentToBlankBlockUSI>
<xsl:value-of select="$PBClientBrokerIntentToBlankBlockUSI"/>
</PBClientBrokerIntentToBlankBlockUSI>
</xsl:if>
<xsl:if test="$PBClientBrokerClearingException">
<PBClientBrokerClearingException>
<xsl:value-of select="$PBClientBrokerClearingException"/>
</PBClientBrokerClearingException>
</xsl:if>
<xsl:if test="$PBClientBrokerCollateralized">
<PBClientBrokerCollateralized>
<xsl:value-of select="$PBClientBrokerCollateralized"/>
</PBClientBrokerCollateralized>
</xsl:if>
<xsl:if test="$PBClientBrokerConfirmationTime">
<PBClientBrokerConfirmationTime>
<xsl:value-of select="$PBClientBrokerConfirmationTime"/>
</PBClientBrokerConfirmationTime>
</xsl:if>
<xsl:if test="$PBClientBrokerEmbeddedOption">
<PBClientBrokerEmbeddedOption>
<xsl:value-of select="$PBClientBrokerEmbeddedOption"/>
</PBClientBrokerEmbeddedOption>
</xsl:if>
<xsl:if test="$PBClientBrokerExecutionTime">
<PBClientBrokerExecutionTime>
<xsl:value-of select="$PBClientBrokerExecutionTime"/>
</PBClientBrokerExecutionTime>
</xsl:if>
<xsl:if test="$PBClientBrokerExecutionVenue">
<PBClientBrokerExecutionVenue>
<xsl:value-of select="$PBClientBrokerExecutionVenue"/>
</PBClientBrokerExecutionVenue>
</xsl:if>
<xsl:if test="$PBClientBrokerGTRBulkProcessingID">
<PBClientBrokerGTRBulkProcessingID>
<xsl:value-of select="$PBClientBrokerGTRBulkProcessingID"/>
</PBClientBrokerGTRBulkProcessingID>
</xsl:if>
<xsl:if test="$PBClientBrokerNonStandardFlag">
<PBClientBrokerNonStandardFlag>
<xsl:value-of select="$PBClientBrokerNonStandardFlag"/>
</PBClientBrokerNonStandardFlag>
</xsl:if>
<xsl:if test="$PBClientBrokerOffPlatformConfirmationType">
<PBClientBrokerOffPlatformConfirmationType>
<xsl:value-of select="$PBClientBrokerOffPlatformConfirmationType"/>
</PBClientBrokerOffPlatformConfirmationType>
</xsl:if>
<xsl:if test="$PBClientBrokerOffPlatformVerificationType">
<PBClientBrokerOffPlatformVerificationType>
<xsl:value-of select="$PBClientBrokerOffPlatformVerificationType"/>
</PBClientBrokerOffPlatformVerificationType>
</xsl:if>
<xsl:if test="$PBClientBrokerPrimaryAssetClass">
<PBClientBrokerPrimaryAssetClass>
<xsl:value-of select="$PBClientBrokerPrimaryAssetClass"/>
</PBClientBrokerPrimaryAssetClass>
</xsl:if>
<xsl:if test="$PBClientBrokerPriorUSINamespace">
<PBClientBrokerPriorUSINamespace>
<xsl:value-of select="$PBClientBrokerPriorUSINamespace"/>
</PBClientBrokerPriorUSINamespace>
</xsl:if>
<xsl:if test="$PBClientBrokerIntentToBlankPriorUSINamespace">
<PBClientBrokerIntentToBlankPriorUSINamespace>
<xsl:value-of select="$PBClientBrokerIntentToBlankPriorUSINamespace"/>
</PBClientBrokerIntentToBlankPriorUSINamespace>
</xsl:if>
<xsl:if test="$PBClientBrokerPriorUSI">
<PBClientBrokerPriorUSI>
<xsl:value-of select="$PBClientBrokerPriorUSI"/>
</PBClientBrokerPriorUSI>
</xsl:if>
<xsl:if test="$PBClientBrokerIntentToBlankPriorUSI">
<PBClientBrokerIntentToBlankPriorUSI>
<xsl:value-of select="$PBClientBrokerIntentToBlankPriorUSI"/>
</PBClientBrokerIntentToBlankPriorUSI>
</xsl:if>
<xsl:if test="$PBClientBrokerProductIDType">
<PBClientBrokerProductIDType>
<xsl:value-of select="$PBClientBrokerProductIDType"/>
</PBClientBrokerProductIDType>
</xsl:if>
<xsl:if test="$PBClientBrokerProductIDValue">
<PBClientBrokerProductIDValue>
<xsl:value-of select="$PBClientBrokerProductIDValue"/>
</PBClientBrokerProductIDValue>
</xsl:if>
<xsl:if test="$PBClientBrokerReportPET">
<PBClientBrokerReportPET>
<xsl:value-of select="$PBClientBrokerReportPET"/>
</PBClientBrokerReportPET>
</xsl:if>
<xsl:if test="$PBClientBrokerReportCONF">
<PBClientBrokerReportCONF>
<xsl:value-of select="$PBClientBrokerReportCONF"/>
</PBClientBrokerReportCONF>
</xsl:if>
<xsl:if test="$PBBlockUSINamespace">
<PBBlockUSINamespace>
<xsl:value-of select="$PBBlockUSINamespace"/>
</PBBlockUSINamespace>
</xsl:if>
<xsl:if test="$PBIntentToBlankBlockUSINamespace">
<PBIntentToBlankBlockUSINamespace>
<xsl:value-of select="$PBIntentToBlankBlockUSINamespace"/>
</PBIntentToBlankBlockUSINamespace>
</xsl:if>
<xsl:if test="$PBBlockUSI">
<PBBlockUSI>
<xsl:value-of select="$PBBlockUSI"/>
</PBBlockUSI>
</xsl:if>
<xsl:if test="$PBIntentToBlankBlockUSI">
<PBIntentToBlankBlockUSI>
<xsl:value-of select="$PBIntentToBlankBlockUSI"/>
</PBIntentToBlankBlockUSI>
</xsl:if>
<xsl:if test="$PBClearingException">
<PBClearingException>
<xsl:value-of select="$PBClearingException"/>
</PBClearingException>
</xsl:if>
<xsl:if test="$PBCollateralized">
<PBCollateralized>
<xsl:value-of select="$PBCollateralized"/>
</PBCollateralized>
</xsl:if>
<xsl:if test="$PBConfirmationTime">
<PBConfirmationTime>
<xsl:value-of select="$PBConfirmationTime"/>
</PBConfirmationTime>
</xsl:if>
<xsl:if test="$PBEmbeddedOption">
<PBEmbeddedOption>
<xsl:value-of select="$PBEmbeddedOption"/>
</PBEmbeddedOption>
</xsl:if>
<xsl:if test="$PBExecutionTime">
<PBExecutionTime>
<xsl:value-of select="$PBExecutionTime"/>
</PBExecutionTime>
</xsl:if>
<xsl:if test="$PBExecutionVenue">
<PBExecutionVenue>
<xsl:value-of select="$PBExecutionVenue"/>
</PBExecutionVenue>
</xsl:if>
<xsl:if test="$PBGTRBulkProcessingID">
<PBGTRBulkProcessingID>
<xsl:value-of select="$PBGTRBulkProcessingID"/>
</PBGTRBulkProcessingID>
</xsl:if>
<xsl:if test="$PBNonStandardFlag">
<PBNonStandardFlag>
<xsl:value-of select="$PBNonStandardFlag"/>
</PBNonStandardFlag>
</xsl:if>
<xsl:if test="$PBOffPlatformConfirmationType">
<PBOffPlatformConfirmationType>
<xsl:value-of select="$PBOffPlatformConfirmationType"/>
</PBOffPlatformConfirmationType>
</xsl:if>
<xsl:if test="$PBOffPlatformVerificationType">
<PBOffPlatformVerificationType>
<xsl:value-of select="$PBOffPlatformVerificationType"/>
</PBOffPlatformVerificationType>
</xsl:if>
<xsl:if test="$PBPrimaryAssetClass">
<PBPrimaryAssetClass>
<xsl:value-of select="$PBPrimaryAssetClass"/>
</PBPrimaryAssetClass>
</xsl:if>
<xsl:if test="$PBPriorUSINamespace">
<PBPriorUSINamespace>
<xsl:value-of select="$PBPriorUSINamespace"/>
</PBPriorUSINamespace>
</xsl:if>
<xsl:if test="$PBIntentToBlankPriorUSINamespace">
<PBIntentToBlankPriorUSINamespace>
<xsl:value-of select="$PBIntentToBlankPriorUSINamespace"/>
</PBIntentToBlankPriorUSINamespace>
</xsl:if>
<xsl:if test="$PBPriorUSI">
<PBPriorUSI>
<xsl:value-of select="$PBPriorUSI"/>
</PBPriorUSI>
</xsl:if>
<xsl:if test="$PBIntentToBlankPriorUSI">
<PBIntentToBlankPriorUSI>
<xsl:value-of select="$PBIntentToBlankPriorUSI"/>
</PBIntentToBlankPriorUSI>
</xsl:if>
<xsl:if test="$PBProductIDType">
<PBProductIDType>
<xsl:value-of select="$PBProductIDType"/>
</PBProductIDType>
</xsl:if>
<xsl:if test="$PBProductIDValue">
<PBProductIDValue>
<xsl:value-of select="$PBProductIDValue"/>
</PBProductIDValue>
</xsl:if>
<xsl:if test="$ClientBlockUSINamespace">
<ClientBlockUSINamespace>
<xsl:value-of select="$ClientBlockUSINamespace"/>
</ClientBlockUSINamespace>
</xsl:if>
<xsl:if test="$ClientIntentToBlankBlockUSINamespace">
<ClientIntentToBlankBlockUSINamespace>
<xsl:value-of select="$ClientIntentToBlankBlockUSINamespace"/>
</ClientIntentToBlankBlockUSINamespace>
</xsl:if>
<xsl:if test="$ClientBlockUSI">
<ClientBlockUSI>
<xsl:value-of select="$ClientBlockUSI"/>
</ClientBlockUSI>
</xsl:if>
<xsl:if test="$ClientIntentToBlankBlockUSI">
<ClientIntentToBlankBlockUSI>
<xsl:value-of select="$ClientIntentToBlankBlockUSI"/>
</ClientIntentToBlankBlockUSI>
</xsl:if>
<xsl:if test="$ClientClearingException">
<ClientClearingException>
<xsl:value-of select="$ClientClearingException"/>
</ClientClearingException>
</xsl:if>
<xsl:if test="$ClientCollateralized">
<ClientCollateralized>
<xsl:value-of select="$ClientCollateralized"/>
</ClientCollateralized>
</xsl:if>
<xsl:if test="$ClientConfirmationTime">
<ClientConfirmationTime>
<xsl:value-of select="$ClientConfirmationTime"/>
</ClientConfirmationTime>
</xsl:if>
<xsl:if test="$ClientEmbeddedOption">
<ClientEmbeddedOption>
<xsl:value-of select="$ClientEmbeddedOption"/>
</ClientEmbeddedOption>
</xsl:if>
<xsl:if test="$ClientExecutionTime">
<ClientExecutionTime>
<xsl:value-of select="$ClientExecutionTime"/>
</ClientExecutionTime>
</xsl:if>
<xsl:if test="$ClientExecutionVenue">
<ClientExecutionVenue>
<xsl:value-of select="$ClientExecutionVenue"/>
</ClientExecutionVenue>
</xsl:if>
<xsl:if test="$ClientGTRBulkProcessingID">
<ClientGTRBulkProcessingID>
<xsl:value-of select="$ClientGTRBulkProcessingID"/>
</ClientGTRBulkProcessingID>
</xsl:if>
<xsl:if test="$ClientNonStandardFlag">
<ClientNonStandardFlag>
<xsl:value-of select="$ClientNonStandardFlag"/>
</ClientNonStandardFlag>
</xsl:if>
<xsl:if test="$ClientOffPlatformConfirmationType">
<ClientOffPlatformConfirmationType>
<xsl:value-of select="$ClientOffPlatformConfirmationType"/>
</ClientOffPlatformConfirmationType>
</xsl:if>
<xsl:if test="$ClientOffPlatformVerificationType">
<ClientOffPlatformVerificationType>
<xsl:value-of select="$ClientOffPlatformVerificationType"/>
</ClientOffPlatformVerificationType>
</xsl:if>
<xsl:if test="$ClientPrimaryAssetClass">
<ClientPrimaryAssetClass>
<xsl:value-of select="$ClientPrimaryAssetClass"/>
</ClientPrimaryAssetClass>
</xsl:if>
<xsl:if test="$ClientPriorUSINamespace">
<ClientPriorUSINamespace>
<xsl:value-of select="$ClientPriorUSINamespace"/>
</ClientPriorUSINamespace>
</xsl:if>
<xsl:if test="$ClientIntentToBlankPriorUSINamespace">
<ClientIntentToBlankPriorUSINamespace>
<xsl:value-of select="$ClientIntentToBlankPriorUSINamespace"/>
</ClientIntentToBlankPriorUSINamespace>
</xsl:if>
<xsl:if test="$ClientPriorUSI">
<ClientPriorUSI>
<xsl:value-of select="$ClientPriorUSI"/>
</ClientPriorUSI>
</xsl:if>
<xsl:if test="$ClientIntentToBlankPriorUSI">
<ClientIntentToBlankPriorUSI>
<xsl:value-of select="$ClientIntentToBlankPriorUSI"/>
</ClientIntentToBlankPriorUSI>
</xsl:if>
<xsl:if test="$ClientProductIDType">
<ClientProductIDType>
<xsl:value-of select="$ClientProductIDType"/>
</ClientProductIDType>
</xsl:if>
<xsl:if test="$ClientProductIDValue">
<ClientProductIDValue>
<xsl:value-of select="$ClientProductIDValue"/>
</ClientProductIDValue>
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
<xsl:param name="JFSARegulatorType" select="/.."/>
<xsl:param name="JFSARoute1Destination" select="/.."/>
<xsl:param name="JFSARoute1Intermediary" select="/.."/>
<xsl:param name="JFSAUTINamespace" select="/.."/>
<xsl:param name="JFSAIntentToBlankUTINamespace" select="/.."/>
<xsl:param name="JFSAUTINamespacePrefix" select="/.."/>
<xsl:param name="JFSAUTI" select="/.."/>
<xsl:param name="JFSAIntentToBlankUTI" select="/.."/>
<xsl:param name="JFSABlockUTINamespace" select="/.."/>
<xsl:param name="JFSAIntentToBlankBlockUTINamespace" select="/.."/>
<xsl:param name="JFSABlockUTI" select="/.."/>
<xsl:param name="JFSAIntentToBlankBlockUTI" select="/.."/>
<xsl:param name="JFSAClearingException" select="/.."/>
<xsl:param name="JFSAPriorUTINamespace" select="/.."/>
<xsl:param name="JFSAIntentToBlankPriorUTINamespace" select="/.."/>
<xsl:param name="JFSAPriorUTI" select="/.."/>
<xsl:param name="JFSAIntentToBlankPriorUTI" select="/.."/>
<xsl:param name="JFSAPartyABlockUTINamespace" select="/.."/>
<xsl:param name="JFSAPartyAIntentToBlankBlockUTINamespace" select="/.."/>
<xsl:param name="JFSAPartyABlockUTI" select="/.."/>
<xsl:param name="JFSAPartyAIntentToBlankBlockUTI" select="/.."/>
<xsl:param name="JFSAPartyAClearingException" select="/.."/>
<xsl:param name="JFSAPartyAPriorUTINamespace" select="/.."/>
<xsl:param name="JFSAPartyAIntentToBlankPriorUTINamespace" select="/.."/>
<xsl:param name="JFSAPartyAPriorUTI" select="/.."/>
<xsl:param name="JFSAPartyAIntentToBlankPriorUTI" select="/.."/>
<xsl:param name="JFSAPartyBBlockUTINamespace" select="/.."/>
<xsl:param name="JFSAPartyBIntentToBlankBlockUTINamespace" select="/.."/>
<xsl:param name="JFSAPartyBBlockUTI" select="/.."/>
<xsl:param name="JFSAPartyBIntentToBlankBlockUTI" select="/.."/>
<xsl:param name="JFSAPartyBClearingException" select="/.."/>
<xsl:param name="JFSAPartyBPriorUTINamespace" select="/.."/>
<xsl:param name="JFSAPartyBIntentToBlankPriorUTINamespace" select="/.."/>
<xsl:param name="JFSAPartyBPriorUTI" select="/.."/>
<xsl:param name="JFSAPartyBIntentToBlankPriorUTI" select="/.."/>
<xsl:param name="JFSAPBClientDataPresent" select="/.."/>
<xsl:param name="JFSAPBClientRegulatorType" select="/.."/>
<xsl:param name="JFSAPBClientRoute1Destination" select="/.."/>
<xsl:param name="JFSAPBClientRoute1Intermediary" select="/.."/>
<xsl:param name="JFSAPBClientUTINamespace" select="/.."/>
<xsl:param name="JFSAPBClientIntentToBlankUTINamespace" select="/.."/>
<xsl:param name="JFSAPBClientUTINamespacePrefix" select="/.."/>
<xsl:param name="JFSAPBClientUTI" select="/.."/>
<xsl:param name="JFSAPBClientIntentToBlankUTI" select="/.."/>
<xsl:param name="JFSAPBClientBrokerBlockUTINamespace" select="/.."/>
<xsl:param name="JFSAPBClientBrokerIntentToBlankBlockUTINamespace" select="/.."/>
<xsl:param name="JFSAPBClientBrokerBlockUTI" select="/.."/>
<xsl:param name="JFSAPBClientBrokerIntentToBlankBlockUTI" select="/.."/>
<xsl:param name="JFSAPBClientBrokerPriorUTINamespace" select="/.."/>
<xsl:param name="JFSAPBClientBrokerIntentToBlankPriorUTINamespace" select="/.."/>
<xsl:param name="JFSAPBClientBrokerPriorUTI" select="/.."/>
<xsl:param name="JFSAPBClientBrokerIntentToBlankPriorUTI" select="/.."/>
<xsl:param name="JFSAPBBlockUTINamespace" select="/.."/>
<xsl:param name="JFSAPBIntentToBlankBlockUTINamespace" select="/.."/>
<xsl:param name="JFSAPBBlockUTI" select="/.."/>
<xsl:param name="JFSAPBIntentToBlankBlockUTI" select="/.."/>
<xsl:param name="JFSAPBPriorUTINamespace" select="/.."/>
<xsl:param name="JFSAPBIntentToBlankPriorUTINamespace" select="/.."/>
<xsl:param name="JFSAPBPriorUTI" select="/.."/>
<xsl:param name="JFSAPBIntentToBlankPriorUTI" select="/.."/>
<xsl:param name="JFSAClientBlockUTINamespace" select="/.."/>
<xsl:param name="JFSAClientIntentToBlankBlockUTINamespace" select="/.."/>
<xsl:param name="JFSAClientBlockUTI" select="/.."/>
<xsl:param name="JFSAClientIntentToBlankBlockUTI" select="/.."/>
<xsl:param name="JFSAClientPriorUTINamespace" select="/.."/>
<xsl:param name="JFSAClientIntentToBlankPriorUTINamespace" select="/.."/>
<xsl:param name="JFSAClientPriorUTI" select="/.."/>
<xsl:param name="JFSAClientIntentToBlankPriorUTI" select="/.."/>
<xsl:if test="$JFSADataPresent">
<JFSADataPresent>
<xsl:value-of select="$JFSADataPresent"/>
</JFSADataPresent>
</xsl:if>
<xsl:if test="$JFSARegulatorType">
<JFSARegulatorType>
<xsl:value-of select="$JFSARegulatorType"/>
</JFSARegulatorType>
</xsl:if>
<xsl:if test="$JFSARoute1Destination">
<JFSARoute1Destination>
<xsl:value-of select="$JFSARoute1Destination"/>
</JFSARoute1Destination>
</xsl:if>
<xsl:if test="$JFSARoute1Intermediary">
<JFSARoute1Intermediary>
<xsl:value-of select="$JFSARoute1Intermediary"/>
</JFSARoute1Intermediary>
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
<xsl:if test="$JFSAIntentToBlankUTI">
<JFSAIntentToBlankUTI>
<xsl:value-of select="$JFSAIntentToBlankUTI"/>
</JFSAIntentToBlankUTI>
</xsl:if>
<xsl:if test="$JFSABlockUTINamespace">
<JFSABlockUTINamespace>
<xsl:value-of select="$JFSABlockUTINamespace"/>
</JFSABlockUTINamespace>
</xsl:if>
<xsl:if test="$JFSAIntentToBlankBlockUTINamespace">
<JFSAIntentToBlankBlockUTINamespace>
<xsl:value-of select="$JFSAIntentToBlankBlockUTINamespace"/>
</JFSAIntentToBlankBlockUTINamespace>
</xsl:if>
<xsl:if test="$JFSABlockUTI">
<JFSABlockUTI>
<xsl:value-of select="$JFSABlockUTI"/>
</JFSABlockUTI>
</xsl:if>
<xsl:if test="$JFSAIntentToBlankBlockUTI">
<JFSAIntentToBlankBlockUTI>
<xsl:value-of select="$JFSAIntentToBlankBlockUTI"/>
</JFSAIntentToBlankBlockUTI>
</xsl:if>
<xsl:if test="$JFSAClearingException">
<JFSAClearingException>
<xsl:value-of select="$JFSAClearingException"/>
</JFSAClearingException>
</xsl:if>
<xsl:if test="$JFSAPriorUTINamespace">
<JFSAPriorUTINamespace>
<xsl:value-of select="$JFSAPriorUTINamespace"/>
</JFSAPriorUTINamespace>
</xsl:if>
<xsl:if test="$JFSAIntentToBlankPriorUTINamespace">
<JFSAIntentToBlankPriorUTINamespace>
<xsl:value-of select="$JFSAIntentToBlankPriorUTINamespace"/>
</JFSAIntentToBlankPriorUTINamespace>
</xsl:if>
<xsl:if test="$JFSAPriorUTI">
<JFSAPriorUTI>
<xsl:value-of select="$JFSAPriorUTI"/>
</JFSAPriorUTI>
</xsl:if>
<xsl:if test="$JFSAIntentToBlankPriorUTI">
<JFSAIntentToBlankPriorUTI>
<xsl:value-of select="$JFSAIntentToBlankPriorUTI"/>
</JFSAIntentToBlankPriorUTI>
</xsl:if>
<xsl:if test="$JFSAPartyABlockUTINamespace">
<JFSAPartyABlockUTINamespace>
<xsl:value-of select="$JFSAPartyABlockUTINamespace"/>
</JFSAPartyABlockUTINamespace>
</xsl:if>
<xsl:if test="$JFSAPartyAIntentToBlankBlockUTINamespace">
<JFSAPartyAIntentToBlankBlockUTINamespace>
<xsl:value-of select="$JFSAPartyAIntentToBlankBlockUTINamespace"/>
</JFSAPartyAIntentToBlankBlockUTINamespace>
</xsl:if>
<xsl:if test="$JFSAPartyABlockUTI">
<JFSAPartyABlockUTI>
<xsl:value-of select="$JFSAPartyABlockUTI"/>
</JFSAPartyABlockUTI>
</xsl:if>
<xsl:if test="$JFSAPartyAIntentToBlankBlockUTI">
<JFSAPartyAIntentToBlankBlockUTI>
<xsl:value-of select="$JFSAPartyAIntentToBlankBlockUTI"/>
</JFSAPartyAIntentToBlankBlockUTI>
</xsl:if>
<xsl:if test="$JFSAPartyAClearingException">
<JFSAPartyAClearingException>
<xsl:value-of select="$JFSAPartyAClearingException"/>
</JFSAPartyAClearingException>
</xsl:if>
<xsl:if test="$JFSAPartyAPriorUTINamespace">
<JFSAPartyAPriorUTINamespace>
<xsl:value-of select="$JFSAPartyAPriorUTINamespace"/>
</JFSAPartyAPriorUTINamespace>
</xsl:if>
<xsl:if test="$JFSAPartyAIntentToBlankPriorUTINamespace">
<JFSAPartyAIntentToBlankPriorUTINamespace>
<xsl:value-of select="$JFSAPartyAIntentToBlankPriorUTINamespace"/>
</JFSAPartyAIntentToBlankPriorUTINamespace>
</xsl:if>
<xsl:if test="$JFSAPartyAPriorUTI">
<JFSAPartyAPriorUTI>
<xsl:value-of select="$JFSAPartyAPriorUTI"/>
</JFSAPartyAPriorUTI>
</xsl:if>
<xsl:if test="$JFSAPartyAIntentToBlankPriorUTI">
<JFSAPartyAIntentToBlankPriorUTI>
<xsl:value-of select="$JFSAPartyAIntentToBlankPriorUTI"/>
</JFSAPartyAIntentToBlankPriorUTI>
</xsl:if>
<xsl:if test="$JFSAPartyBBlockUTINamespace">
<JFSAPartyBBlockUTINamespace>
<xsl:value-of select="$JFSAPartyBBlockUTINamespace"/>
</JFSAPartyBBlockUTINamespace>
</xsl:if>
<xsl:if test="$JFSAPartyBIntentToBlankBlockUTINamespace">
<JFSAPartyBIntentToBlankBlockUTINamespace>
<xsl:value-of select="$JFSAPartyBIntentToBlankBlockUTINamespace"/>
</JFSAPartyBIntentToBlankBlockUTINamespace>
</xsl:if>
<xsl:if test="$JFSAPartyBBlockUTI">
<JFSAPartyBBlockUTI>
<xsl:value-of select="$JFSAPartyBBlockUTI"/>
</JFSAPartyBBlockUTI>
</xsl:if>
<xsl:if test="$JFSAPartyBIntentToBlankBlockUTI">
<JFSAPartyBIntentToBlankBlockUTI>
<xsl:value-of select="$JFSAPartyBIntentToBlankBlockUTI"/>
</JFSAPartyBIntentToBlankBlockUTI>
</xsl:if>
<xsl:if test="$JFSAPartyBClearingException">
<JFSAPartyBClearingException>
<xsl:value-of select="$JFSAPartyBClearingException"/>
</JFSAPartyBClearingException>
</xsl:if>
<xsl:if test="$JFSAPartyBPriorUTINamespace">
<JFSAPartyBPriorUTINamespace>
<xsl:value-of select="$JFSAPartyBPriorUTINamespace"/>
</JFSAPartyBPriorUTINamespace>
</xsl:if>
<xsl:if test="$JFSAPartyBIntentToBlankPriorUTINamespace">
<JFSAPartyBIntentToBlankPriorUTINamespace>
<xsl:value-of select="$JFSAPartyBIntentToBlankPriorUTINamespace"/>
</JFSAPartyBIntentToBlankPriorUTINamespace>
</xsl:if>
<xsl:if test="$JFSAPartyBPriorUTI">
<JFSAPartyBPriorUTI>
<xsl:value-of select="$JFSAPartyBPriorUTI"/>
</JFSAPartyBPriorUTI>
</xsl:if>
<xsl:if test="$JFSAPartyBIntentToBlankPriorUTI">
<JFSAPartyBIntentToBlankPriorUTI>
<xsl:value-of select="$JFSAPartyBIntentToBlankPriorUTI"/>
</JFSAPartyBIntentToBlankPriorUTI>
</xsl:if>
<xsl:if test="$JFSAPBClientDataPresent">
<JFSAPBClientDataPresent>
<xsl:value-of select="$JFSAPBClientDataPresent"/>
</JFSAPBClientDataPresent>
</xsl:if>
<xsl:if test="$JFSAPBClientRegulatorType">
<JFSAPBClientRegulatorType>
<xsl:value-of select="$JFSAPBClientRegulatorType"/>
</JFSAPBClientRegulatorType>
</xsl:if>
<xsl:if test="$JFSAPBClientRoute1Destination">
<JFSAPBClientRoute1Destination>
<xsl:value-of select="$JFSAPBClientRoute1Destination"/>
</JFSAPBClientRoute1Destination>
</xsl:if>
<xsl:if test="$JFSAPBClientRoute1Intermediary">
<JFSAPBClientRoute1Intermediary>
<xsl:value-of select="$JFSAPBClientRoute1Intermediary"/>
</JFSAPBClientRoute1Intermediary>
</xsl:if>
<xsl:if test="$JFSAPBClientUTINamespace">
<JFSAPBClientUTINamespace>
<xsl:value-of select="$JFSAPBClientUTINamespace"/>
</JFSAPBClientUTINamespace>
</xsl:if>
<xsl:if test="$JFSAPBClientIntentToBlankUTINamespace">
<JFSAPBClientIntentToBlankUTINamespace>
<xsl:value-of select="$JFSAPBClientIntentToBlankUTINamespace"/>
</JFSAPBClientIntentToBlankUTINamespace>
</xsl:if>
<xsl:if test="$JFSAPBClientUTINamespacePrefix">
<JFSAPBClientUTINamespacePrefix>
<xsl:value-of select="$JFSAPBClientUTINamespacePrefix"/>
</JFSAPBClientUTINamespacePrefix>
</xsl:if>
<xsl:if test="$JFSAPBClientUTI">
<JFSAPBClientUTI>
<xsl:value-of select="$JFSAPBClientUTI"/>
</JFSAPBClientUTI>
</xsl:if>
<xsl:if test="$JFSAPBClientIntentToBlankUTI">
<JFSAPBClientIntentToBlankUTI>
<xsl:value-of select="$JFSAPBClientIntentToBlankUTI"/>
</JFSAPBClientIntentToBlankUTI>
</xsl:if>
<xsl:if test="$JFSAPBClientBrokerBlockUTINamespace">
<JFSAPBClientBrokerBlockUTINamespace>
<xsl:value-of select="$JFSAPBClientBrokerBlockUTINamespace"/>
</JFSAPBClientBrokerBlockUTINamespace>
</xsl:if>
<xsl:if test="$JFSAPBClientBrokerIntentToBlankBlockUTINamespace">
<JFSAPBClientBrokerIntentToBlankBlockUTINamespace>
<xsl:value-of select="$JFSAPBClientBrokerIntentToBlankBlockUTINamespace"/>
</JFSAPBClientBrokerIntentToBlankBlockUTINamespace>
</xsl:if>
<xsl:if test="$JFSAPBClientBrokerBlockUTI">
<JFSAPBClientBrokerBlockUTI>
<xsl:value-of select="$JFSAPBClientBrokerBlockUTI"/>
</JFSAPBClientBrokerBlockUTI>
</xsl:if>
<xsl:if test="$JFSAPBClientBrokerIntentToBlankBlockUTI">
<JFSAPBClientBrokerIntentToBlankBlockUTI>
<xsl:value-of select="$JFSAPBClientBrokerIntentToBlankBlockUTI"/>
</JFSAPBClientBrokerIntentToBlankBlockUTI>
</xsl:if>
<xsl:if test="$JFSAPBClientBrokerPriorUTINamespace">
<JFSAPBClientBrokerPriorUTINamespace>
<xsl:value-of select="$JFSAPBClientBrokerPriorUTINamespace"/>
</JFSAPBClientBrokerPriorUTINamespace>
</xsl:if>
<xsl:if test="$JFSAPBClientBrokerIntentToBlankPriorUTINamespace">
<JFSAPBClientBrokerIntentToBlankPriorUTINamespace>
<xsl:value-of select="$JFSAPBClientBrokerIntentToBlankPriorUTINamespace"/>
</JFSAPBClientBrokerIntentToBlankPriorUTINamespace>
</xsl:if>
<xsl:if test="$JFSAPBClientBrokerPriorUTI">
<JFSAPBClientBrokerPriorUTI>
<xsl:value-of select="$JFSAPBClientBrokerPriorUTI"/>
</JFSAPBClientBrokerPriorUTI>
</xsl:if>
<xsl:if test="$JFSAPBClientBrokerIntentToBlankPriorUTI">
<JFSAPBClientBrokerIntentToBlankPriorUTI>
<xsl:value-of select="$JFSAPBClientBrokerIntentToBlankPriorUTI"/>
</JFSAPBClientBrokerIntentToBlankPriorUTI>
</xsl:if>
<xsl:if test="$JFSAPBBlockUTINamespace">
<JFSAPBBlockUTINamespace>
<xsl:value-of select="$JFSAPBBlockUTINamespace"/>
</JFSAPBBlockUTINamespace>
</xsl:if>
<xsl:if test="$JFSAPBIntentToBlankBlockUTINamespace">
<JFSAPBIntentToBlankBlockUTINamespace>
<xsl:value-of select="$JFSAPBIntentToBlankBlockUTINamespace"/>
</JFSAPBIntentToBlankBlockUTINamespace>
</xsl:if>
<xsl:if test="$JFSAPBBlockUTI">
<JFSAPBBlockUTI>
<xsl:value-of select="$JFSAPBBlockUTI"/>
</JFSAPBBlockUTI>
</xsl:if>
<xsl:if test="$JFSAPBIntentToBlankBlockUTI">
<JFSAPBIntentToBlankBlockUTI>
<xsl:value-of select="$JFSAPBIntentToBlankBlockUTI"/>
</JFSAPBIntentToBlankBlockUTI>
</xsl:if>
<xsl:if test="$JFSAPBPriorUTINamespace">
<JFSAPBPriorUTINamespace>
<xsl:value-of select="$JFSAPBPriorUTINamespace"/>
</JFSAPBPriorUTINamespace>
</xsl:if>
<xsl:if test="$JFSAPBIntentToBlankPriorUTINamespace">
<JFSAPBIntentToBlankPriorUTINamespace>
<xsl:value-of select="$JFSAPBIntentToBlankPriorUTINamespace"/>
</JFSAPBIntentToBlankPriorUTINamespace>
</xsl:if>
<xsl:if test="$JFSAPBPriorUTI">
<JFSAPBPriorUTI>
<xsl:value-of select="$JFSAPBPriorUTI"/>
</JFSAPBPriorUTI>
</xsl:if>
<xsl:if test="$JFSAPBIntentToBlankPriorUTI">
<JFSAPBIntentToBlankPriorUTI>
<xsl:value-of select="$JFSAPBIntentToBlankPriorUTI"/>
</JFSAPBIntentToBlankPriorUTI>
</xsl:if>
<xsl:if test="$JFSAClientBlockUTINamespace">
<JFSAClientBlockUTINamespace>
<xsl:value-of select="$JFSAClientBlockUTINamespace"/>
</JFSAClientBlockUTINamespace>
</xsl:if>
<xsl:if test="$JFSAClientIntentToBlankBlockUTINamespace">
<JFSAClientIntentToBlankBlockUTINamespace>
<xsl:value-of select="$JFSAClientIntentToBlankBlockUTINamespace"/>
</JFSAClientIntentToBlankBlockUTINamespace>
</xsl:if>
<xsl:if test="$JFSAClientBlockUTI">
<JFSAClientBlockUTI>
<xsl:value-of select="$JFSAClientBlockUTI"/>
</JFSAClientBlockUTI>
</xsl:if>
<xsl:if test="$JFSAClientIntentToBlankBlockUTI">
<JFSAClientIntentToBlankBlockUTI>
<xsl:value-of select="$JFSAClientIntentToBlankBlockUTI"/>
</JFSAClientIntentToBlankBlockUTI>
</xsl:if>
<xsl:if test="$JFSAClientPriorUTINamespace">
<JFSAClientPriorUTINamespace>
<xsl:value-of select="$JFSAClientPriorUTINamespace"/>
</JFSAClientPriorUTINamespace>
</xsl:if>
<xsl:if test="$JFSAClientIntentToBlankPriorUTINamespace">
<JFSAClientIntentToBlankPriorUTINamespace>
<xsl:value-of select="$JFSAClientIntentToBlankPriorUTINamespace"/>
</JFSAClientIntentToBlankPriorUTINamespace>
</xsl:if>
<xsl:if test="$JFSAClientPriorUTI">
<JFSAClientPriorUTI>
<xsl:value-of select="$JFSAClientPriorUTI"/>
</JFSAClientPriorUTI>
</xsl:if>
<xsl:if test="$JFSAClientIntentToBlankPriorUTI">
<JFSAClientIntentToBlankPriorUTI>
<xsl:value-of select="$JFSAClientIntentToBlankPriorUTI"/>
</JFSAClientIntentToBlankPriorUTI>
</xsl:if>
</xsl:template>
<xsl:template name="lcl:ESMAData">
<xsl:param name="ESMADataPresent" select="/.."/>
<xsl:param name="ESMARegulatorType" select="/.."/>
<xsl:param name="ESMARoute1Destination" select="/.."/>
<xsl:param name="ESMARoute1Intermediary" select="/.."/>
<xsl:param name="ESMAUTINamespace" select="/.."/>
<xsl:param name="ESMAIntentToBlankUTINamespace" select="/.."/>
<xsl:param name="ESMAUTINamespacePrefix" select="/.."/>
<xsl:param name="ESMAUTI" select="/.."/>
<xsl:param name="ESMAIntentToBlankUTI" select="/.."/>
<xsl:param name="ESMABlockUTINamespace" select="/.."/>
<xsl:param name="ESMAIntentToBlankBlockUTINamespace" select="/.."/>
<xsl:param name="ESMABlockUTI" select="/.."/>
<xsl:param name="ESMAIntentToBlankBlockUTI" select="/.."/>
<xsl:param name="ESMAClearingException" select="/.."/>
<xsl:param name="ESMAPriorUTINamespace" select="/.."/>
<xsl:param name="ESMAIntentToBlankPriorUTINamespace" select="/.."/>
<xsl:param name="ESMAPriorUTI" select="/.."/>
<xsl:param name="ESMAIntentToBlankPriorUTI" select="/.."/>
<xsl:param name="ESMAPartyABlockUTINamespace" select="/.."/>
<xsl:param name="ESMAPartyAIntentToBlankBlockUTINamespace" select="/.."/>
<xsl:param name="ESMAPartyABlockUTI" select="/.."/>
<xsl:param name="ESMAPartyAIntentToBlankBlockUTI" select="/.."/>
<xsl:param name="ESMAPartyAClearingException" select="/.."/>
<xsl:param name="ESMAPartyAPriorUTINamespace" select="/.."/>
<xsl:param name="ESMAPartyAIntentToBlankPriorUTINamespace" select="/.."/>
<xsl:param name="ESMAPartyAPriorUTI" select="/.."/>
<xsl:param name="ESMAPartyAIntentToBlankPriorUTI" select="/.."/>
<xsl:param name="ESMAPartyBBlockUTINamespace" select="/.."/>
<xsl:param name="ESMAPartyBIntentToBlankBlockUTINamespace" select="/.."/>
<xsl:param name="ESMAPartyBBlockUTI" select="/.."/>
<xsl:param name="ESMAPartyBIntentToBlankBlockUTI" select="/.."/>
<xsl:param name="ESMAPartyBClearingException" select="/.."/>
<xsl:param name="ESMAPartyBPriorUTINamespace" select="/.."/>
<xsl:param name="ESMAPartyBIntentToBlankPriorUTINamespace" select="/.."/>
<xsl:param name="ESMAPartyBPriorUTI" select="/.."/>
<xsl:param name="ESMAPartyBIntentToBlankPriorUTI" select="/.."/>
<xsl:param name="ESMAPBClientDataPresent" select="/.."/>
<xsl:param name="ESMAPBClientRegulatorType" select="/.."/>
<xsl:param name="ESMAPBClientRoute1Destination" select="/.."/>
<xsl:param name="ESMAPBClientRoute1Intermediary" select="/.."/>
<xsl:param name="ESMAPBClientUTINamespace" select="/.."/>
<xsl:param name="ESMAPBClientIntentToBlankUTINamespace" select="/.."/>
<xsl:param name="ESMAPBClientUTINamespacePrefix" select="/.."/>
<xsl:param name="ESMAPBClientUTI" select="/.."/>
<xsl:param name="ESMAPBClientIntentToBlankUTI" select="/.."/>
<xsl:param name="ESMAPBClientBrokerBlockUTINamespace" select="/.."/>
<xsl:param name="ESMAPBClientBrokerIntentToBlankBlockUTINamespace" select="/.."/>
<xsl:param name="ESMAPBClientBrokerBlockUTI" select="/.."/>
<xsl:param name="ESMAPBClientBrokerIntentToBlankBlockUTI" select="/.."/>
<xsl:param name="ESMAPBClientBrokerPriorUTINamespace" select="/.."/>
<xsl:param name="ESMAPBClientBrokerIntentToBlankPriorUTINamespace" select="/.."/>
<xsl:param name="ESMAPBClientBrokerPriorUTI" select="/.."/>
<xsl:param name="ESMAPBClientBrokerIntentToBlankPriorUTI" select="/.."/>
<xsl:param name="ESMAPBBlockUTINamespace" select="/.."/>
<xsl:param name="ESMAPBIntentToBlankBlockUTINamespace" select="/.."/>
<xsl:param name="ESMAPBBlockUTI" select="/.."/>
<xsl:param name="ESMAPBIntentToBlankBlockUTI" select="/.."/>
<xsl:param name="ESMAPBPriorUTINamespace" select="/.."/>
<xsl:param name="ESMAPBIntentToBlankPriorUTINamespace" select="/.."/>
<xsl:param name="ESMAPBPriorUTI" select="/.."/>
<xsl:param name="ESMAPBIntentToBlankPriorUTI" select="/.."/>
<xsl:param name="ESMAClientBlockUTINamespace" select="/.."/>
<xsl:param name="ESMAClientIntentToBlankBlockUTINamespace" select="/.."/>
<xsl:param name="ESMAClientBlockUTI" select="/.."/>
<xsl:param name="ESMAClientIntentToBlankBlockUTI" select="/.."/>
<xsl:param name="ESMAClientPriorUTINamespace" select="/.."/>
<xsl:param name="ESMAClientIntentToBlankPriorUTINamespace" select="/.."/>
<xsl:param name="ESMAClientPriorUTI" select="/.."/>
<xsl:param name="ESMAClientIntentToBlankPriorUTI" select="/.."/>
<xsl:if test="$ESMADataPresent">
<ESMADataPresent>
<xsl:value-of select="$ESMADataPresent"/>
</ESMADataPresent>
</xsl:if>
<xsl:if test="$ESMARegulatorType">
<ESMARegulatorType>
<xsl:value-of select="$ESMARegulatorType"/>
</ESMARegulatorType>
</xsl:if>
<xsl:if test="$ESMARoute1Destination">
<ESMARoute1Destination>
<xsl:value-of select="$ESMARoute1Destination"/>
</ESMARoute1Destination>
</xsl:if>
<xsl:if test="$ESMARoute1Intermediary">
<ESMARoute1Intermediary>
<xsl:value-of select="$ESMARoute1Intermediary"/>
</ESMARoute1Intermediary>
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
<xsl:if test="$ESMAIntentToBlankUTI">
<ESMAIntentToBlankUTI>
<xsl:value-of select="$ESMAIntentToBlankUTI"/>
</ESMAIntentToBlankUTI>
</xsl:if>
<xsl:if test="$ESMABlockUTINamespace">
<ESMABlockUTINamespace>
<xsl:value-of select="$ESMABlockUTINamespace"/>
</ESMABlockUTINamespace>
</xsl:if>
<xsl:if test="$ESMAIntentToBlankBlockUTINamespace">
<ESMAIntentToBlankBlockUTINamespace>
<xsl:value-of select="$ESMAIntentToBlankBlockUTINamespace"/>
</ESMAIntentToBlankBlockUTINamespace>
</xsl:if>
<xsl:if test="$ESMABlockUTI">
<ESMABlockUTI>
<xsl:value-of select="$ESMABlockUTI"/>
</ESMABlockUTI>
</xsl:if>
<xsl:if test="$ESMAIntentToBlankBlockUTI">
<ESMAIntentToBlankBlockUTI>
<xsl:value-of select="$ESMAIntentToBlankBlockUTI"/>
</ESMAIntentToBlankBlockUTI>
</xsl:if>
<xsl:if test="$ESMAClearingException">
<ESMAClearingException>
<xsl:value-of select="$ESMAClearingException"/>
</ESMAClearingException>
</xsl:if>
<xsl:if test="$ESMAPriorUTINamespace">
<ESMAPriorUTINamespace>
<xsl:value-of select="$ESMAPriorUTINamespace"/>
</ESMAPriorUTINamespace>
</xsl:if>
<xsl:if test="$ESMAIntentToBlankPriorUTINamespace">
<ESMAIntentToBlankPriorUTINamespace>
<xsl:value-of select="$ESMAIntentToBlankPriorUTINamespace"/>
</ESMAIntentToBlankPriorUTINamespace>
</xsl:if>
<xsl:if test="$ESMAPriorUTI">
<ESMAPriorUTI>
<xsl:value-of select="$ESMAPriorUTI"/>
</ESMAPriorUTI>
</xsl:if>
<xsl:if test="$ESMAIntentToBlankPriorUTI">
<ESMAIntentToBlankPriorUTI>
<xsl:value-of select="$ESMAIntentToBlankPriorUTI"/>
</ESMAIntentToBlankPriorUTI>
</xsl:if>
<xsl:if test="$ESMAPartyABlockUTINamespace">
<ESMAPartyABlockUTINamespace>
<xsl:value-of select="$ESMAPartyABlockUTINamespace"/>
</ESMAPartyABlockUTINamespace>
</xsl:if>
<xsl:if test="$ESMAPartyAIntentToBlankBlockUTINamespace">
<ESMAPartyAIntentToBlankBlockUTINamespace>
<xsl:value-of select="$ESMAPartyAIntentToBlankBlockUTINamespace"/>
</ESMAPartyAIntentToBlankBlockUTINamespace>
</xsl:if>
<xsl:if test="$ESMAPartyABlockUTI">
<ESMAPartyABlockUTI>
<xsl:value-of select="$ESMAPartyABlockUTI"/>
</ESMAPartyABlockUTI>
</xsl:if>
<xsl:if test="$ESMAPartyAIntentToBlankBlockUTI">
<ESMAPartyAIntentToBlankBlockUTI>
<xsl:value-of select="$ESMAPartyAIntentToBlankBlockUTI"/>
</ESMAPartyAIntentToBlankBlockUTI>
</xsl:if>
<xsl:if test="$ESMAPartyAClearingException">
<ESMAPartyAClearingException>
<xsl:value-of select="$ESMAPartyAClearingException"/>
</ESMAPartyAClearingException>
</xsl:if>
<xsl:if test="$ESMAPartyAPriorUTINamespace">
<ESMAPartyAPriorUTINamespace>
<xsl:value-of select="$ESMAPartyAPriorUTINamespace"/>
</ESMAPartyAPriorUTINamespace>
</xsl:if>
<xsl:if test="$ESMAPartyAIntentToBlankPriorUTINamespace">
<ESMAPartyAIntentToBlankPriorUTINamespace>
<xsl:value-of select="$ESMAPartyAIntentToBlankPriorUTINamespace"/>
</ESMAPartyAIntentToBlankPriorUTINamespace>
</xsl:if>
<xsl:if test="$ESMAPartyAPriorUTI">
<ESMAPartyAPriorUTI>
<xsl:value-of select="$ESMAPartyAPriorUTI"/>
</ESMAPartyAPriorUTI>
</xsl:if>
<xsl:if test="$ESMAPartyAIntentToBlankPriorUTI">
<ESMAPartyAIntentToBlankPriorUTI>
<xsl:value-of select="$ESMAPartyAIntentToBlankPriorUTI"/>
</ESMAPartyAIntentToBlankPriorUTI>
</xsl:if>
<xsl:if test="$ESMAPartyBBlockUTINamespace">
<ESMAPartyBBlockUTINamespace>
<xsl:value-of select="$ESMAPartyBBlockUTINamespace"/>
</ESMAPartyBBlockUTINamespace>
</xsl:if>
<xsl:if test="$ESMAPartyBIntentToBlankBlockUTINamespace">
<ESMAPartyBIntentToBlankBlockUTINamespace>
<xsl:value-of select="$ESMAPartyBIntentToBlankBlockUTINamespace"/>
</ESMAPartyBIntentToBlankBlockUTINamespace>
</xsl:if>
<xsl:if test="$ESMAPartyBBlockUTI">
<ESMAPartyBBlockUTI>
<xsl:value-of select="$ESMAPartyBBlockUTI"/>
</ESMAPartyBBlockUTI>
</xsl:if>
<xsl:if test="$ESMAPartyBIntentToBlankBlockUTI">
<ESMAPartyBIntentToBlankBlockUTI>
<xsl:value-of select="$ESMAPartyBIntentToBlankBlockUTI"/>
</ESMAPartyBIntentToBlankBlockUTI>
</xsl:if>
<xsl:if test="$ESMAPartyBClearingException">
<ESMAPartyBClearingException>
<xsl:value-of select="$ESMAPartyBClearingException"/>
</ESMAPartyBClearingException>
</xsl:if>
<xsl:if test="$ESMAPartyBPriorUTINamespace">
<ESMAPartyBPriorUTINamespace>
<xsl:value-of select="$ESMAPartyBPriorUTINamespace"/>
</ESMAPartyBPriorUTINamespace>
</xsl:if>
<xsl:if test="$ESMAPartyBIntentToBlankPriorUTINamespace">
<ESMAPartyBIntentToBlankPriorUTINamespace>
<xsl:value-of select="$ESMAPartyBIntentToBlankPriorUTINamespace"/>
</ESMAPartyBIntentToBlankPriorUTINamespace>
</xsl:if>
<xsl:if test="$ESMAPartyBPriorUTI">
<ESMAPartyBPriorUTI>
<xsl:value-of select="$ESMAPartyBPriorUTI"/>
</ESMAPartyBPriorUTI>
</xsl:if>
<xsl:if test="$ESMAPartyBIntentToBlankPriorUTI">
<ESMAPartyBIntentToBlankPriorUTI>
<xsl:value-of select="$ESMAPartyBIntentToBlankPriorUTI"/>
</ESMAPartyBIntentToBlankPriorUTI>
</xsl:if>
<xsl:if test="$ESMAPBClientDataPresent">
<ESMAPBClientDataPresent>
<xsl:value-of select="$ESMAPBClientDataPresent"/>
</ESMAPBClientDataPresent>
</xsl:if>
<xsl:if test="$ESMAPBClientRegulatorType">
<ESMAPBClientRegulatorType>
<xsl:value-of select="$ESMAPBClientRegulatorType"/>
</ESMAPBClientRegulatorType>
</xsl:if>
<xsl:if test="$ESMAPBClientRoute1Destination">
<ESMAPBClientRoute1Destination>
<xsl:value-of select="$ESMAPBClientRoute1Destination"/>
</ESMAPBClientRoute1Destination>
</xsl:if>
<xsl:if test="$ESMAPBClientRoute1Intermediary">
<ESMAPBClientRoute1Intermediary>
<xsl:value-of select="$ESMAPBClientRoute1Intermediary"/>
</ESMAPBClientRoute1Intermediary>
</xsl:if>
<xsl:if test="$ESMAPBClientUTINamespace">
<ESMAPBClientUTINamespace>
<xsl:value-of select="$ESMAPBClientUTINamespace"/>
</ESMAPBClientUTINamespace>
</xsl:if>
<xsl:if test="$ESMAPBClientIntentToBlankUTINamespace">
<ESMAPBClientIntentToBlankUTINamespace>
<xsl:value-of select="$ESMAPBClientIntentToBlankUTINamespace"/>
</ESMAPBClientIntentToBlankUTINamespace>
</xsl:if>
<xsl:if test="$ESMAPBClientUTINamespacePrefix">
<ESMAPBClientUTINamespacePrefix>
<xsl:value-of select="$ESMAPBClientUTINamespacePrefix"/>
</ESMAPBClientUTINamespacePrefix>
</xsl:if>
<xsl:if test="$ESMAPBClientUTI">
<ESMAPBClientUTI>
<xsl:value-of select="$ESMAPBClientUTI"/>
</ESMAPBClientUTI>
</xsl:if>
<xsl:if test="$ESMAPBClientIntentToBlankUTI">
<ESMAPBClientIntentToBlankUTI>
<xsl:value-of select="$ESMAPBClientIntentToBlankUTI"/>
</ESMAPBClientIntentToBlankUTI>
</xsl:if>
<xsl:if test="$ESMAPBClientBrokerBlockUTINamespace">
<ESMAPBClientBrokerBlockUTINamespace>
<xsl:value-of select="$ESMAPBClientBrokerBlockUTINamespace"/>
</ESMAPBClientBrokerBlockUTINamespace>
</xsl:if>
<xsl:if test="$ESMAPBClientBrokerIntentToBlankBlockUTINamespace">
<ESMAPBClientBrokerIntentToBlankBlockUTINamespace>
<xsl:value-of select="$ESMAPBClientBrokerIntentToBlankBlockUTINamespace"/>
</ESMAPBClientBrokerIntentToBlankBlockUTINamespace>
</xsl:if>
<xsl:if test="$ESMAPBClientBrokerBlockUTI">
<ESMAPBClientBrokerBlockUTI>
<xsl:value-of select="$ESMAPBClientBrokerBlockUTI"/>
</ESMAPBClientBrokerBlockUTI>
</xsl:if>
<xsl:if test="$ESMAPBClientBrokerIntentToBlankBlockUTI">
<ESMAPBClientBrokerIntentToBlankBlockUTI>
<xsl:value-of select="$ESMAPBClientBrokerIntentToBlankBlockUTI"/>
</ESMAPBClientBrokerIntentToBlankBlockUTI>
</xsl:if>
<xsl:if test="$ESMAPBClientBrokerPriorUTINamespace">
<ESMAPBClientBrokerPriorUTINamespace>
<xsl:value-of select="$ESMAPBClientBrokerPriorUTINamespace"/>
</ESMAPBClientBrokerPriorUTINamespace>
</xsl:if>
<xsl:if test="$ESMAPBClientBrokerIntentToBlankPriorUTINamespace">
<ESMAPBClientBrokerIntentToBlankPriorUTINamespace>
<xsl:value-of select="$ESMAPBClientBrokerIntentToBlankPriorUTINamespace"/>
</ESMAPBClientBrokerIntentToBlankPriorUTINamespace>
</xsl:if>
<xsl:if test="$ESMAPBClientBrokerPriorUTI">
<ESMAPBClientBrokerPriorUTI>
<xsl:value-of select="$ESMAPBClientBrokerPriorUTI"/>
</ESMAPBClientBrokerPriorUTI>
</xsl:if>
<xsl:if test="$ESMAPBClientBrokerIntentToBlankPriorUTI">
<ESMAPBClientBrokerIntentToBlankPriorUTI>
<xsl:value-of select="$ESMAPBClientBrokerIntentToBlankPriorUTI"/>
</ESMAPBClientBrokerIntentToBlankPriorUTI>
</xsl:if>
<xsl:if test="$ESMAPBBlockUTINamespace">
<ESMAPBBlockUTINamespace>
<xsl:value-of select="$ESMAPBBlockUTINamespace"/>
</ESMAPBBlockUTINamespace>
</xsl:if>
<xsl:if test="$ESMAPBIntentToBlankBlockUTINamespace">
<ESMAPBIntentToBlankBlockUTINamespace>
<xsl:value-of select="$ESMAPBIntentToBlankBlockUTINamespace"/>
</ESMAPBIntentToBlankBlockUTINamespace>
</xsl:if>
<xsl:if test="$ESMAPBBlockUTI">
<ESMAPBBlockUTI>
<xsl:value-of select="$ESMAPBBlockUTI"/>
</ESMAPBBlockUTI>
</xsl:if>
<xsl:if test="$ESMAPBIntentToBlankBlockUTI">
<ESMAPBIntentToBlankBlockUTI>
<xsl:value-of select="$ESMAPBIntentToBlankBlockUTI"/>
</ESMAPBIntentToBlankBlockUTI>
</xsl:if>
<xsl:if test="$ESMAPBPriorUTINamespace">
<ESMAPBPriorUTINamespace>
<xsl:value-of select="$ESMAPBPriorUTINamespace"/>
</ESMAPBPriorUTINamespace>
</xsl:if>
<xsl:if test="$ESMAPBIntentToBlankPriorUTINamespace">
<ESMAPBIntentToBlankPriorUTINamespace>
<xsl:value-of select="$ESMAPBIntentToBlankPriorUTINamespace"/>
</ESMAPBIntentToBlankPriorUTINamespace>
</xsl:if>
<xsl:if test="$ESMAPBPriorUTI">
<ESMAPBPriorUTI>
<xsl:value-of select="$ESMAPBPriorUTI"/>
</ESMAPBPriorUTI>
</xsl:if>
<xsl:if test="$ESMAPBIntentToBlankPriorUTI">
<ESMAPBIntentToBlankPriorUTI>
<xsl:value-of select="$ESMAPBIntentToBlankPriorUTI"/>
</ESMAPBIntentToBlankPriorUTI>
</xsl:if>
<xsl:if test="$ESMAClientBlockUTINamespace">
<ESMAClientBlockUTINamespace>
<xsl:value-of select="$ESMAClientBlockUTINamespace"/>
</ESMAClientBlockUTINamespace>
</xsl:if>
<xsl:if test="$ESMAClientIntentToBlankBlockUTINamespace">
<ESMAClientIntentToBlankBlockUTINamespace>
<xsl:value-of select="$ESMAClientIntentToBlankBlockUTINamespace"/>
</ESMAClientIntentToBlankBlockUTINamespace>
</xsl:if>
<xsl:if test="$ESMAClientBlockUTI">
<ESMAClientBlockUTI>
<xsl:value-of select="$ESMAClientBlockUTI"/>
</ESMAClientBlockUTI>
</xsl:if>
<xsl:if test="$ESMAClientIntentToBlankBlockUTI">
<ESMAClientIntentToBlankBlockUTI>
<xsl:value-of select="$ESMAClientIntentToBlankBlockUTI"/>
</ESMAClientIntentToBlankBlockUTI>
</xsl:if>
<xsl:if test="$ESMAClientPriorUTINamespace">
<ESMAClientPriorUTINamespace>
<xsl:value-of select="$ESMAClientPriorUTINamespace"/>
</ESMAClientPriorUTINamespace>
</xsl:if>
<xsl:if test="$ESMAClientIntentToBlankPriorUTINamespace">
<ESMAClientIntentToBlankPriorUTINamespace>
<xsl:value-of select="$ESMAClientIntentToBlankPriorUTINamespace"/>
</ESMAClientIntentToBlankPriorUTINamespace>
</xsl:if>
<xsl:if test="$ESMAClientPriorUTI">
<ESMAClientPriorUTI>
<xsl:value-of select="$ESMAClientPriorUTI"/>
</ESMAClientPriorUTI>
</xsl:if>
<xsl:if test="$ESMAClientIntentToBlankPriorUTI">
<ESMAClientIntentToBlankPriorUTI>
<xsl:value-of select="$ESMAClientIntentToBlankPriorUTI"/>
</ESMAClientIntentToBlankPriorUTI>
</xsl:if>
</xsl:template>
<xsl:template name="lcl:FCAData">
<xsl:param name="FCADataPresent" select="/.."/>
<xsl:param name="FCARegulatorType" select="/.."/>
<xsl:param name="FCARoute1Destination" select="/.."/>
<xsl:param name="FCARoute1Intermediary" select="/.."/>
<xsl:param name="FCAUTINamespace" select="/.."/>
<xsl:param name="FCAIntentToBlankUTINamespace" select="/.."/>
<xsl:param name="FCAUTINamespacePrefix" select="/.."/>
<xsl:param name="FCAUTI" select="/.."/>
<xsl:param name="FCAIntentToBlankUTI" select="/.."/>
<xsl:param name="FCABlockUTINamespace" select="/.."/>
<xsl:param name="FCAIntentToBlankBlockUTINamespace" select="/.."/>
<xsl:param name="FCABlockUTI" select="/.."/>
<xsl:param name="FCAIntentToBlankBlockUTI" select="/.."/>
<xsl:param name="FCAClearingException" select="/.."/>
<xsl:param name="FCAPriorUTINamespace" select="/.."/>
<xsl:param name="FCAIntentToBlankPriorUTINamespace" select="/.."/>
<xsl:param name="FCAPriorUTI" select="/.."/>
<xsl:param name="FCAIntentToBlankPriorUTI" select="/.."/>
<xsl:param name="FCAPartyABlockUTINamespace" select="/.."/>
<xsl:param name="FCAPartyAIntentToBlankBlockUTINamespace" select="/.."/>
<xsl:param name="FCAPartyABlockUTI" select="/.."/>
<xsl:param name="FCAPartyAIntentToBlankBlockUTI" select="/.."/>
<xsl:param name="FCAPartyAClearingException" select="/.."/>
<xsl:param name="FCAPartyAPriorUTINamespace" select="/.."/>
<xsl:param name="FCAPartyAIntentToBlankPriorUTINamespace" select="/.."/>
<xsl:param name="FCAPartyAPriorUTI" select="/.."/>
<xsl:param name="FCAPartyAIntentToBlankPriorUTI" select="/.."/>
<xsl:param name="FCAPartyBBlockUTINamespace" select="/.."/>
<xsl:param name="FCAPartyBIntentToBlankBlockUTINamespace" select="/.."/>
<xsl:param name="FCAPartyBBlockUTI" select="/.."/>
<xsl:param name="FCAPartyBIntentToBlankBlockUTI" select="/.."/>
<xsl:param name="FCAPartyBClearingException" select="/.."/>
<xsl:param name="FCAPartyBPriorUTINamespace" select="/.."/>
<xsl:param name="FCAPartyBIntentToBlankPriorUTINamespace" select="/.."/>
<xsl:param name="FCAPartyBPriorUTI" select="/.."/>
<xsl:param name="FCAPartyBIntentToBlankPriorUTI" select="/.."/>
<xsl:param name="FCAPBClientDataPresent" select="/.."/>
<xsl:param name="FCAPBClientRegulatorType" select="/.."/>
<xsl:param name="FCAPBClientRoute1Destination" select="/.."/>
<xsl:param name="FCAPBClientRoute1Intermediary" select="/.."/>
<xsl:param name="FCAPBClientUTINamespace" select="/.."/>
<xsl:param name="FCAPBClientIntentToBlankUTINamespace" select="/.."/>
<xsl:param name="FCAPBClientUTINamespacePrefix" select="/.."/>
<xsl:param name="FCAPBClientUTI" select="/.."/>
<xsl:param name="FCAPBClientIntentToBlankUTI" select="/.."/>
<xsl:param name="FCAPBClientBrokerBlockUTINamespace" select="/.."/>
<xsl:param name="FCAPBClientBrokerIntentToBlankBlockUTINamespace" select="/.."/>
<xsl:param name="FCAPBClientBrokerBlockUTI" select="/.."/>
<xsl:param name="FCAPBClientBrokerIntentToBlankBlockUTI" select="/.."/>
<xsl:param name="FCAPBClientBrokerPriorUTINamespace" select="/.."/>
<xsl:param name="FCAPBClientBrokerIntentToBlankPriorUTINamespace" select="/.."/>
<xsl:param name="FCAPBClientBrokerPriorUTI" select="/.."/>
<xsl:param name="FCAPBClientBrokerIntentToBlankPriorUTI" select="/.."/>
<xsl:param name="FCAPBBlockUTINamespace" select="/.."/>
<xsl:param name="FCAPBIntentToBlankBlockUTINamespace" select="/.."/>
<xsl:param name="FCAPBBlockUTI" select="/.."/>
<xsl:param name="FCAPBIntentToBlankBlockUTI" select="/.."/>
<xsl:param name="FCAPBPriorUTINamespace" select="/.."/>
<xsl:param name="FCAPBIntentToBlankPriorUTINamespace" select="/.."/>
<xsl:param name="FCAPBPriorUTI" select="/.."/>
<xsl:param name="FCAPBIntentToBlankPriorUTI" select="/.."/>
<xsl:param name="FCAClientBlockUTINamespace" select="/.."/>
<xsl:param name="FCAClientIntentToBlankBlockUTINamespace" select="/.."/>
<xsl:param name="FCAClientBlockUTI" select="/.."/>
<xsl:param name="FCAClientIntentToBlankBlockUTI" select="/.."/>
<xsl:param name="FCAClientPriorUTINamespace" select="/.."/>
<xsl:param name="FCAClientIntentToBlankPriorUTINamespace" select="/.."/>
<xsl:param name="FCAClientPriorUTI" select="/.."/>
<xsl:param name="FCAClientIntentToBlankPriorUTI" select="/.."/>
<xsl:if test="$FCADataPresent">
<FCADataPresent>
<xsl:value-of select="$FCADataPresent"/>
</FCADataPresent>
</xsl:if>
<xsl:if test="$FCARegulatorType">
<FCARegulatorType>
<xsl:value-of select="$FCARegulatorType"/>
</FCARegulatorType>
</xsl:if>
<xsl:if test="$FCARoute1Destination">
<FCARoute1Destination>
<xsl:value-of select="$FCARoute1Destination"/>
</FCARoute1Destination>
</xsl:if>
<xsl:if test="$FCARoute1Intermediary">
<FCARoute1Intermediary>
<xsl:value-of select="$FCARoute1Intermediary"/>
</FCARoute1Intermediary>
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
<xsl:if test="$FCAIntentToBlankUTI">
<FCAIntentToBlankUTI>
<xsl:value-of select="$FCAIntentToBlankUTI"/>
</FCAIntentToBlankUTI>
</xsl:if>
<xsl:if test="$FCABlockUTINamespace">
<FCABlockUTINamespace>
<xsl:value-of select="$FCABlockUTINamespace"/>
</FCABlockUTINamespace>
</xsl:if>
<xsl:if test="$FCAIntentToBlankBlockUTINamespace">
<FCAIntentToBlankBlockUTINamespace>
<xsl:value-of select="$FCAIntentToBlankBlockUTINamespace"/>
</FCAIntentToBlankBlockUTINamespace>
</xsl:if>
<xsl:if test="$FCABlockUTI">
<FCABlockUTI>
<xsl:value-of select="$FCABlockUTI"/>
</FCABlockUTI>
</xsl:if>
<xsl:if test="$FCAIntentToBlankBlockUTI">
<FCAIntentToBlankBlockUTI>
<xsl:value-of select="$FCAIntentToBlankBlockUTI"/>
</FCAIntentToBlankBlockUTI>
</xsl:if>
<xsl:if test="$FCAClearingException">
<FCAClearingException>
<xsl:value-of select="$FCAClearingException"/>
</FCAClearingException>
</xsl:if>
<xsl:if test="$FCAPriorUTINamespace">
<FCAPriorUTINamespace>
<xsl:value-of select="$FCAPriorUTINamespace"/>
</FCAPriorUTINamespace>
</xsl:if>
<xsl:if test="$FCAIntentToBlankPriorUTINamespace">
<FCAIntentToBlankPriorUTINamespace>
<xsl:value-of select="$FCAIntentToBlankPriorUTINamespace"/>
</FCAIntentToBlankPriorUTINamespace>
</xsl:if>
<xsl:if test="$FCAPriorUTI">
<FCAPriorUTI>
<xsl:value-of select="$FCAPriorUTI"/>
</FCAPriorUTI>
</xsl:if>
<xsl:if test="$FCAIntentToBlankPriorUTI">
<FCAIntentToBlankPriorUTI>
<xsl:value-of select="$FCAIntentToBlankPriorUTI"/>
</FCAIntentToBlankPriorUTI>
</xsl:if>
<xsl:if test="$FCAPartyABlockUTINamespace">
<FCAPartyABlockUTINamespace>
<xsl:value-of select="$FCAPartyABlockUTINamespace"/>
</FCAPartyABlockUTINamespace>
</xsl:if>
<xsl:if test="$FCAPartyAIntentToBlankBlockUTINamespace">
<FCAPartyAIntentToBlankBlockUTINamespace>
<xsl:value-of select="$FCAPartyAIntentToBlankBlockUTINamespace"/>
</FCAPartyAIntentToBlankBlockUTINamespace>
</xsl:if>
<xsl:if test="$FCAPartyABlockUTI">
<FCAPartyABlockUTI>
<xsl:value-of select="$FCAPartyABlockUTI"/>
</FCAPartyABlockUTI>
</xsl:if>
<xsl:if test="$FCAPartyAIntentToBlankBlockUTI">
<FCAPartyAIntentToBlankBlockUTI>
<xsl:value-of select="$FCAPartyAIntentToBlankBlockUTI"/>
</FCAPartyAIntentToBlankBlockUTI>
</xsl:if>
<xsl:if test="$FCAPartyAClearingException">
<FCAPartyAClearingException>
<xsl:value-of select="$FCAPartyAClearingException"/>
</FCAPartyAClearingException>
</xsl:if>
<xsl:if test="$FCAPartyAPriorUTINamespace">
<FCAPartyAPriorUTINamespace>
<xsl:value-of select="$FCAPartyAPriorUTINamespace"/>
</FCAPartyAPriorUTINamespace>
</xsl:if>
<xsl:if test="$FCAPartyAIntentToBlankPriorUTINamespace">
<FCAPartyAIntentToBlankPriorUTINamespace>
<xsl:value-of select="$FCAPartyAIntentToBlankPriorUTINamespace"/>
</FCAPartyAIntentToBlankPriorUTINamespace>
</xsl:if>
<xsl:if test="$FCAPartyAPriorUTI">
<FCAPartyAPriorUTI>
<xsl:value-of select="$FCAPartyAPriorUTI"/>
</FCAPartyAPriorUTI>
</xsl:if>
<xsl:if test="$FCAPartyAIntentToBlankPriorUTI">
<FCAPartyAIntentToBlankPriorUTI>
<xsl:value-of select="$FCAPartyAIntentToBlankPriorUTI"/>
</FCAPartyAIntentToBlankPriorUTI>
</xsl:if>
<xsl:if test="$FCAPartyBBlockUTINamespace">
<FCAPartyBBlockUTINamespace>
<xsl:value-of select="$FCAPartyBBlockUTINamespace"/>
</FCAPartyBBlockUTINamespace>
</xsl:if>
<xsl:if test="$FCAPartyBIntentToBlankBlockUTINamespace">
<FCAPartyBIntentToBlankBlockUTINamespace>
<xsl:value-of select="$FCAPartyBIntentToBlankBlockUTINamespace"/>
</FCAPartyBIntentToBlankBlockUTINamespace>
</xsl:if>
<xsl:if test="$FCAPartyBBlockUTI">
<FCAPartyBBlockUTI>
<xsl:value-of select="$FCAPartyBBlockUTI"/>
</FCAPartyBBlockUTI>
</xsl:if>
<xsl:if test="$FCAPartyBIntentToBlankBlockUTI">
<FCAPartyBIntentToBlankBlockUTI>
<xsl:value-of select="$FCAPartyBIntentToBlankBlockUTI"/>
</FCAPartyBIntentToBlankBlockUTI>
</xsl:if>
<xsl:if test="$FCAPartyBClearingException">
<FCAPartyBClearingException>
<xsl:value-of select="$FCAPartyBClearingException"/>
</FCAPartyBClearingException>
</xsl:if>
<xsl:if test="$FCAPartyBPriorUTINamespace">
<FCAPartyBPriorUTINamespace>
<xsl:value-of select="$FCAPartyBPriorUTINamespace"/>
</FCAPartyBPriorUTINamespace>
</xsl:if>
<xsl:if test="$FCAPartyBIntentToBlankPriorUTINamespace">
<FCAPartyBIntentToBlankPriorUTINamespace>
<xsl:value-of select="$FCAPartyBIntentToBlankPriorUTINamespace"/>
</FCAPartyBIntentToBlankPriorUTINamespace>
</xsl:if>
<xsl:if test="$FCAPartyBPriorUTI">
<FCAPartyBPriorUTI>
<xsl:value-of select="$FCAPartyBPriorUTI"/>
</FCAPartyBPriorUTI>
</xsl:if>
<xsl:if test="$FCAPartyBIntentToBlankPriorUTI">
<FCAPartyBIntentToBlankPriorUTI>
<xsl:value-of select="$FCAPartyBIntentToBlankPriorUTI"/>
</FCAPartyBIntentToBlankPriorUTI>
</xsl:if>
<xsl:if test="$FCAPBClientDataPresent">
<FCAPBClientDataPresent>
<xsl:value-of select="$FCAPBClientDataPresent"/>
</FCAPBClientDataPresent>
</xsl:if>
<xsl:if test="$FCAPBClientRegulatorType">
<FCAPBClientRegulatorType>
<xsl:value-of select="$FCAPBClientRegulatorType"/>
</FCAPBClientRegulatorType>
</xsl:if>
<xsl:if test="$FCAPBClientRoute1Destination">
<FCAPBClientRoute1Destination>
<xsl:value-of select="$FCAPBClientRoute1Destination"/>
</FCAPBClientRoute1Destination>
</xsl:if>
<xsl:if test="$FCAPBClientRoute1Intermediary">
<FCAPBClientRoute1Intermediary>
<xsl:value-of select="$FCAPBClientRoute1Intermediary"/>
</FCAPBClientRoute1Intermediary>
</xsl:if>
<xsl:if test="$FCAPBClientUTINamespace">
<FCAPBClientUTINamespace>
<xsl:value-of select="$FCAPBClientUTINamespace"/>
</FCAPBClientUTINamespace>
</xsl:if>
<xsl:if test="$FCAPBClientIntentToBlankUTINamespace">
<FCAPBClientIntentToBlankUTINamespace>
<xsl:value-of select="$FCAPBClientIntentToBlankUTINamespace"/>
</FCAPBClientIntentToBlankUTINamespace>
</xsl:if>
<xsl:if test="$FCAPBClientUTINamespacePrefix">
<FCAPBClientUTINamespacePrefix>
<xsl:value-of select="$FCAPBClientUTINamespacePrefix"/>
</FCAPBClientUTINamespacePrefix>
</xsl:if>
<xsl:if test="$FCAPBClientUTI">
<FCAPBClientUTI>
<xsl:value-of select="$FCAPBClientUTI"/>
</FCAPBClientUTI>
</xsl:if>
<xsl:if test="$FCAPBClientIntentToBlankUTI">
<FCAPBClientIntentToBlankUTI>
<xsl:value-of select="$FCAPBClientIntentToBlankUTI"/>
</FCAPBClientIntentToBlankUTI>
</xsl:if>
<xsl:if test="$FCAPBClientBrokerBlockUTINamespace">
<FCAPBClientBrokerBlockUTINamespace>
<xsl:value-of select="$FCAPBClientBrokerBlockUTINamespace"/>
</FCAPBClientBrokerBlockUTINamespace>
</xsl:if>
<xsl:if test="$FCAPBClientBrokerIntentToBlankBlockUTINamespace">
<FCAPBClientBrokerIntentToBlankBlockUTINamespace>
<xsl:value-of select="$FCAPBClientBrokerIntentToBlankBlockUTINamespace"/>
</FCAPBClientBrokerIntentToBlankBlockUTINamespace>
</xsl:if>
<xsl:if test="$FCAPBClientBrokerBlockUTI">
<FCAPBClientBrokerBlockUTI>
<xsl:value-of select="$FCAPBClientBrokerBlockUTI"/>
</FCAPBClientBrokerBlockUTI>
</xsl:if>
<xsl:if test="$FCAPBClientBrokerIntentToBlankBlockUTI">
<FCAPBClientBrokerIntentToBlankBlockUTI>
<xsl:value-of select="$FCAPBClientBrokerIntentToBlankBlockUTI"/>
</FCAPBClientBrokerIntentToBlankBlockUTI>
</xsl:if>
<xsl:if test="$FCAPBClientBrokerPriorUTINamespace">
<FCAPBClientBrokerPriorUTINamespace>
<xsl:value-of select="$FCAPBClientBrokerPriorUTINamespace"/>
</FCAPBClientBrokerPriorUTINamespace>
</xsl:if>
<xsl:if test="$FCAPBClientBrokerIntentToBlankPriorUTINamespace">
<FCAPBClientBrokerIntentToBlankPriorUTINamespace>
<xsl:value-of select="$FCAPBClientBrokerIntentToBlankPriorUTINamespace"/>
</FCAPBClientBrokerIntentToBlankPriorUTINamespace>
</xsl:if>
<xsl:if test="$FCAPBClientBrokerPriorUTI">
<FCAPBClientBrokerPriorUTI>
<xsl:value-of select="$FCAPBClientBrokerPriorUTI"/>
</FCAPBClientBrokerPriorUTI>
</xsl:if>
<xsl:if test="$FCAPBClientBrokerIntentToBlankPriorUTI">
<FCAPBClientBrokerIntentToBlankPriorUTI>
<xsl:value-of select="$FCAPBClientBrokerIntentToBlankPriorUTI"/>
</FCAPBClientBrokerIntentToBlankPriorUTI>
</xsl:if>
<xsl:if test="$FCAPBBlockUTINamespace">
<FCAPBBlockUTINamespace>
<xsl:value-of select="$FCAPBBlockUTINamespace"/>
</FCAPBBlockUTINamespace>
</xsl:if>
<xsl:if test="$FCAPBIntentToBlankBlockUTINamespace">
<FCAPBIntentToBlankBlockUTINamespace>
<xsl:value-of select="$FCAPBIntentToBlankBlockUTINamespace"/>
</FCAPBIntentToBlankBlockUTINamespace>
</xsl:if>
<xsl:if test="$FCAPBBlockUTI">
<FCAPBBlockUTI>
<xsl:value-of select="$FCAPBBlockUTI"/>
</FCAPBBlockUTI>
</xsl:if>
<xsl:if test="$FCAPBIntentToBlankBlockUTI">
<FCAPBIntentToBlankBlockUTI>
<xsl:value-of select="$FCAPBIntentToBlankBlockUTI"/>
</FCAPBIntentToBlankBlockUTI>
</xsl:if>
<xsl:if test="$FCAPBPriorUTINamespace">
<FCAPBPriorUTINamespace>
<xsl:value-of select="$FCAPBPriorUTINamespace"/>
</FCAPBPriorUTINamespace>
</xsl:if>
<xsl:if test="$FCAPBIntentToBlankPriorUTINamespace">
<FCAPBIntentToBlankPriorUTINamespace>
<xsl:value-of select="$FCAPBIntentToBlankPriorUTINamespace"/>
</FCAPBIntentToBlankPriorUTINamespace>
</xsl:if>
<xsl:if test="$FCAPBPriorUTI">
<FCAPBPriorUTI>
<xsl:value-of select="$FCAPBPriorUTI"/>
</FCAPBPriorUTI>
</xsl:if>
<xsl:if test="$FCAPBIntentToBlankPriorUTI">
<FCAPBIntentToBlankPriorUTI>
<xsl:value-of select="$FCAPBIntentToBlankPriorUTI"/>
</FCAPBIntentToBlankPriorUTI>
</xsl:if>
<xsl:if test="$FCAClientBlockUTINamespace">
<FCAClientBlockUTINamespace>
<xsl:value-of select="$FCAClientBlockUTINamespace"/>
</FCAClientBlockUTINamespace>
</xsl:if>
<xsl:if test="$FCAClientIntentToBlankBlockUTINamespace">
<FCAClientIntentToBlankBlockUTINamespace>
<xsl:value-of select="$FCAClientIntentToBlankBlockUTINamespace"/>
</FCAClientIntentToBlankBlockUTINamespace>
</xsl:if>
<xsl:if test="$FCAClientBlockUTI">
<FCAClientBlockUTI>
<xsl:value-of select="$FCAClientBlockUTI"/>
</FCAClientBlockUTI>
</xsl:if>
<xsl:if test="$FCAClientIntentToBlankBlockUTI">
<FCAClientIntentToBlankBlockUTI>
<xsl:value-of select="$FCAClientIntentToBlankBlockUTI"/>
</FCAClientIntentToBlankBlockUTI>
</xsl:if>
<xsl:if test="$FCAClientPriorUTINamespace">
<FCAClientPriorUTINamespace>
<xsl:value-of select="$FCAClientPriorUTINamespace"/>
</FCAClientPriorUTINamespace>
</xsl:if>
<xsl:if test="$FCAClientIntentToBlankPriorUTINamespace">
<FCAClientIntentToBlankPriorUTINamespace>
<xsl:value-of select="$FCAClientIntentToBlankPriorUTINamespace"/>
</FCAClientIntentToBlankPriorUTINamespace>
</xsl:if>
<xsl:if test="$FCAClientPriorUTI">
<FCAClientPriorUTI>
<xsl:value-of select="$FCAClientPriorUTI"/>
</FCAClientPriorUTI>
</xsl:if>
<xsl:if test="$FCAClientIntentToBlankPriorUTI">
<FCAClientIntentToBlankPriorUTI>
<xsl:value-of select="$FCAClientIntentToBlankPriorUTI"/>
</FCAClientIntentToBlankPriorUTI>
</xsl:if>
</xsl:template>
<xsl:template name="lcl:CAData">
<xsl:param name="CADataPresent" select="/.."/>
<xsl:param name="CAObligatoryReporting" select="/.."/>
<xsl:param name="CAReportingCounterparty" select="/.."/>
<xsl:param name="CARegulatorType" select="/.."/>
<xsl:param name="CARoute1Destination" select="/.."/>
<xsl:param name="CARoute1Intermediary" select="/.."/>
<xsl:param name="CAUTINamespace" select="/.."/>
<xsl:param name="CAIntentToBlankUTINamespace" select="/.."/>
<xsl:param name="CAUTINamespacePrefix" select="/.."/>
<xsl:param name="CAUTI" select="/.."/>
<xsl:param name="CAIntentToBlankUTI" select="/.."/>
<xsl:param name="CABlockUTINamespace" select="/.."/>
<xsl:param name="CAIntentToBlankBlockUTINamespace" select="/.."/>
<xsl:param name="CABlockUTI" select="/.."/>
<xsl:param name="CAIntentToBlankBlockUTI" select="/.."/>
<xsl:param name="CAClearingException" select="/.."/>
<xsl:param name="CAPriorUTINamespace" select="/.."/>
<xsl:param name="CAIntentToBlankPriorUTINamespace" select="/.."/>
<xsl:param name="CAPriorUTI" select="/.."/>
<xsl:param name="CAIntentToBlankPriorUTI" select="/.."/>
<xsl:param name="CAPartyABlockUTINamespace" select="/.."/>
<xsl:param name="CAPartyAIntentToBlankBlockUTINamespace" select="/.."/>
<xsl:param name="CAPartyABlockUTI" select="/.."/>
<xsl:param name="CAPartyAIntentToBlankBlockUTI" select="/.."/>
<xsl:param name="CAPartyAClearingException" select="/.."/>
<xsl:param name="CAPartyAPriorUTINamespace" select="/.."/>
<xsl:param name="CAPartyAIntentToBlankPriorUTINamespace" select="/.."/>
<xsl:param name="CAPartyAPriorUTI" select="/.."/>
<xsl:param name="CAPartyAIntentToBlankPriorUTI" select="/.."/>
<xsl:param name="CAPartyBBlockUTINamespace" select="/.."/>
<xsl:param name="CAPartyBIntentToBlankBlockUTINamespace" select="/.."/>
<xsl:param name="CAPartyBBlockUTI" select="/.."/>
<xsl:param name="CAPartyBIntentToBlankBlockUTI" select="/.."/>
<xsl:param name="CAPartyBClearingException" select="/.."/>
<xsl:param name="CAPartyBPriorUTINamespace" select="/.."/>
<xsl:param name="CAPartyBIntentToBlankPriorUTINamespace" select="/.."/>
<xsl:param name="CAPartyBPriorUTI" select="/.."/>
<xsl:param name="CAPartyBIntentToBlankPriorUTI" select="/.."/>
<xsl:param name="CAPBClientDataPresent" select="/.."/>
<xsl:param name="CAPBClientRegulatorType" select="/.."/>
<xsl:param name="CAPBClientRoute1Destination" select="/.."/>
<xsl:param name="CAPBClientRoute1Intermediary" select="/.."/>
<xsl:param name="CAPBClientUTINamespace" select="/.."/>
<xsl:param name="CAPBClientIntentToBlankUTINamespace" select="/.."/>
<xsl:param name="CAPBClientUTINamespacePrefix" select="/.."/>
<xsl:param name="CAPBClientUTI" select="/.."/>
<xsl:param name="CAPBClientIntentToBlankUTI" select="/.."/>
<xsl:param name="CAPBClientBrokerBlockUTINamespace" select="/.."/>
<xsl:param name="CAPBClientBrokerIntentToBlankBlockUTINamespace" select="/.."/>
<xsl:param name="CAPBClientBrokerBlockUTI" select="/.."/>
<xsl:param name="CAPBClientBrokerIntentToBlankBlockUTI" select="/.."/>
<xsl:param name="CAPBClientBrokerPriorUTINamespace" select="/.."/>
<xsl:param name="CAPBClientBrokerIntentToBlankPriorUTINamespace" select="/.."/>
<xsl:param name="CAPBClientBrokerPriorUTI" select="/.."/>
<xsl:param name="CAPBClientBrokerIntentToBlankPriorUTI" select="/.."/>
<xsl:param name="CAPBBlockUTINamespace" select="/.."/>
<xsl:param name="CAPBIntentToBlankBlockUTINamespace" select="/.."/>
<xsl:param name="CAPBBlockUTI" select="/.."/>
<xsl:param name="CAPBIntentToBlankBlockUTI" select="/.."/>
<xsl:param name="CAPBPriorUTINamespace" select="/.."/>
<xsl:param name="CAPBIntentToBlankPriorUTINamespace" select="/.."/>
<xsl:param name="CAPBPriorUTI" select="/.."/>
<xsl:param name="CAPBIntentToBlankPriorUTI" select="/.."/>
<xsl:param name="CAClientBlockUTINamespace" select="/.."/>
<xsl:param name="CAClientIntentToBlankBlockUTINamespace" select="/.."/>
<xsl:param name="CAClientBlockUTI" select="/.."/>
<xsl:param name="CAClientIntentToBlankBlockUTI" select="/.."/>
<xsl:param name="CAClientPriorUTINamespace" select="/.."/>
<xsl:param name="CAClientIntentToBlankPriorUTINamespace" select="/.."/>
<xsl:param name="CAClientPriorUTI" select="/.."/>
<xsl:param name="CAClientIntentToBlankPriorUTI" select="/.."/>
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
<xsl:if test="$CAReportingCounterparty">
<CAReportingCounterparty>
<xsl:value-of select="$CAReportingCounterparty"/>
</CAReportingCounterparty>
</xsl:if>
<xsl:if test="$CARegulatorType">
<CARegulatorType>
<xsl:value-of select="$CARegulatorType"/>
</CARegulatorType>
</xsl:if>
<xsl:if test="$CARoute1Destination">
<CARoute1Destination>
<xsl:value-of select="$CARoute1Destination"/>
</CARoute1Destination>
</xsl:if>
<xsl:if test="$CARoute1Intermediary">
<CARoute1Intermediary>
<xsl:value-of select="$CARoute1Intermediary"/>
</CARoute1Intermediary>
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
<xsl:if test="$CAIntentToBlankUTI">
<CAIntentToBlankUTI>
<xsl:value-of select="$CAIntentToBlankUTI"/>
</CAIntentToBlankUTI>
</xsl:if>
<xsl:if test="$CABlockUTINamespace">
<CABlockUTINamespace>
<xsl:value-of select="$CABlockUTINamespace"/>
</CABlockUTINamespace>
</xsl:if>
<xsl:if test="$CAIntentToBlankBlockUTINamespace">
<CAIntentToBlankBlockUTINamespace>
<xsl:value-of select="$CAIntentToBlankBlockUTINamespace"/>
</CAIntentToBlankBlockUTINamespace>
</xsl:if>
<xsl:if test="$CABlockUTI">
<CABlockUTI>
<xsl:value-of select="$CABlockUTI"/>
</CABlockUTI>
</xsl:if>
<xsl:if test="$CAIntentToBlankBlockUTI">
<CAIntentToBlankBlockUTI>
<xsl:value-of select="$CAIntentToBlankBlockUTI"/>
</CAIntentToBlankBlockUTI>
</xsl:if>
<xsl:if test="$CAClearingException">
<CAClearingException>
<xsl:value-of select="$CAClearingException"/>
</CAClearingException>
</xsl:if>
<xsl:if test="$CAPriorUTINamespace">
<CAPriorUTINamespace>
<xsl:value-of select="$CAPriorUTINamespace"/>
</CAPriorUTINamespace>
</xsl:if>
<xsl:if test="$CAIntentToBlankPriorUTINamespace">
<CAIntentToBlankPriorUTINamespace>
<xsl:value-of select="$CAIntentToBlankPriorUTINamespace"/>
</CAIntentToBlankPriorUTINamespace>
</xsl:if>
<xsl:if test="$CAPriorUTI">
<CAPriorUTI>
<xsl:value-of select="$CAPriorUTI"/>
</CAPriorUTI>
</xsl:if>
<xsl:if test="$CAIntentToBlankPriorUTI">
<CAIntentToBlankPriorUTI>
<xsl:value-of select="$CAIntentToBlankPriorUTI"/>
</CAIntentToBlankPriorUTI>
</xsl:if>
<xsl:if test="$CAPartyABlockUTINamespace">
<CAPartyABlockUTINamespace>
<xsl:value-of select="$CAPartyABlockUTINamespace"/>
</CAPartyABlockUTINamespace>
</xsl:if>
<xsl:if test="$CAPartyAIntentToBlankBlockUTINamespace">
<CAPartyAIntentToBlankBlockUTINamespace>
<xsl:value-of select="$CAPartyAIntentToBlankBlockUTINamespace"/>
</CAPartyAIntentToBlankBlockUTINamespace>
</xsl:if>
<xsl:if test="$CAPartyABlockUTI">
<CAPartyABlockUTI>
<xsl:value-of select="$CAPartyABlockUTI"/>
</CAPartyABlockUTI>
</xsl:if>
<xsl:if test="$CAPartyAIntentToBlankBlockUTI">
<CAPartyAIntentToBlankBlockUTI>
<xsl:value-of select="$CAPartyAIntentToBlankBlockUTI"/>
</CAPartyAIntentToBlankBlockUTI>
</xsl:if>
<xsl:if test="$CAPartyAClearingException">
<CAPartyAClearingException>
<xsl:value-of select="$CAPartyAClearingException"/>
</CAPartyAClearingException>
</xsl:if>
<xsl:if test="$CAPartyAPriorUTINamespace">
<CAPartyAPriorUTINamespace>
<xsl:value-of select="$CAPartyAPriorUTINamespace"/>
</CAPartyAPriorUTINamespace>
</xsl:if>
<xsl:if test="$CAPartyAIntentToBlankPriorUTINamespace">
<CAPartyAIntentToBlankPriorUTINamespace>
<xsl:value-of select="$CAPartyAIntentToBlankPriorUTINamespace"/>
</CAPartyAIntentToBlankPriorUTINamespace>
</xsl:if>
<xsl:if test="$CAPartyAPriorUTI">
<CAPartyAPriorUTI>
<xsl:value-of select="$CAPartyAPriorUTI"/>
</CAPartyAPriorUTI>
</xsl:if>
<xsl:if test="$CAPartyAIntentToBlankPriorUTI">
<CAPartyAIntentToBlankPriorUTI>
<xsl:value-of select="$CAPartyAIntentToBlankPriorUTI"/>
</CAPartyAIntentToBlankPriorUTI>
</xsl:if>
<xsl:if test="$CAPartyBBlockUTINamespace">
<CAPartyBBlockUTINamespace>
<xsl:value-of select="$CAPartyBBlockUTINamespace"/>
</CAPartyBBlockUTINamespace>
</xsl:if>
<xsl:if test="$CAPartyBIntentToBlankBlockUTINamespace">
<CAPartyBIntentToBlankBlockUTINamespace>
<xsl:value-of select="$CAPartyBIntentToBlankBlockUTINamespace"/>
</CAPartyBIntentToBlankBlockUTINamespace>
</xsl:if>
<xsl:if test="$CAPartyBBlockUTI">
<CAPartyBBlockUTI>
<xsl:value-of select="$CAPartyBBlockUTI"/>
</CAPartyBBlockUTI>
</xsl:if>
<xsl:if test="$CAPartyBIntentToBlankBlockUTI">
<CAPartyBIntentToBlankBlockUTI>
<xsl:value-of select="$CAPartyBIntentToBlankBlockUTI"/>
</CAPartyBIntentToBlankBlockUTI>
</xsl:if>
<xsl:if test="$CAPartyBClearingException">
<CAPartyBClearingException>
<xsl:value-of select="$CAPartyBClearingException"/>
</CAPartyBClearingException>
</xsl:if>
<xsl:if test="$CAPartyBPriorUTINamespace">
<CAPartyBPriorUTINamespace>
<xsl:value-of select="$CAPartyBPriorUTINamespace"/>
</CAPartyBPriorUTINamespace>
</xsl:if>
<xsl:if test="$CAPartyBIntentToBlankPriorUTINamespace">
<CAPartyBIntentToBlankPriorUTINamespace>
<xsl:value-of select="$CAPartyBIntentToBlankPriorUTINamespace"/>
</CAPartyBIntentToBlankPriorUTINamespace>
</xsl:if>
<xsl:if test="$CAPartyBPriorUTI">
<CAPartyBPriorUTI>
<xsl:value-of select="$CAPartyBPriorUTI"/>
</CAPartyBPriorUTI>
</xsl:if>
<xsl:if test="$CAPartyBIntentToBlankPriorUTI">
<CAPartyBIntentToBlankPriorUTI>
<xsl:value-of select="$CAPartyBIntentToBlankPriorUTI"/>
</CAPartyBIntentToBlankPriorUTI>
</xsl:if>
<xsl:if test="$CAPBClientDataPresent">
<CAPBClientDataPresent>
<xsl:value-of select="$CAPBClientDataPresent"/>
</CAPBClientDataPresent>
</xsl:if>
<xsl:if test="$CAPBClientRegulatorType">
<CAPBClientRegulatorType>
<xsl:value-of select="$CAPBClientRegulatorType"/>
</CAPBClientRegulatorType>
</xsl:if>
<xsl:if test="$CAPBClientRoute1Destination">
<CAPBClientRoute1Destination>
<xsl:value-of select="$CAPBClientRoute1Destination"/>
</CAPBClientRoute1Destination>
</xsl:if>
<xsl:if test="$CAPBClientRoute1Intermediary">
<CAPBClientRoute1Intermediary>
<xsl:value-of select="$CAPBClientRoute1Intermediary"/>
</CAPBClientRoute1Intermediary>
</xsl:if>
<xsl:if test="$CAPBClientUTINamespace">
<CAPBClientUTINamespace>
<xsl:value-of select="$CAPBClientUTINamespace"/>
</CAPBClientUTINamespace>
</xsl:if>
<xsl:if test="$CAPBClientIntentToBlankUTINamespace">
<CAPBClientIntentToBlankUTINamespace>
<xsl:value-of select="$CAPBClientIntentToBlankUTINamespace"/>
</CAPBClientIntentToBlankUTINamespace>
</xsl:if>
<xsl:if test="$CAPBClientUTINamespacePrefix">
<CAPBClientUTINamespacePrefix>
<xsl:value-of select="$CAPBClientUTINamespacePrefix"/>
</CAPBClientUTINamespacePrefix>
</xsl:if>
<xsl:if test="$CAPBClientUTI">
<CAPBClientUTI>
<xsl:value-of select="$CAPBClientUTI"/>
</CAPBClientUTI>
</xsl:if>
<xsl:if test="$CAPBClientIntentToBlankUTI">
<CAPBClientIntentToBlankUTI>
<xsl:value-of select="$CAPBClientIntentToBlankUTI"/>
</CAPBClientIntentToBlankUTI>
</xsl:if>
<xsl:if test="$CAPBClientBrokerBlockUTINamespace">
<CAPBClientBrokerBlockUTINamespace>
<xsl:value-of select="$CAPBClientBrokerBlockUTINamespace"/>
</CAPBClientBrokerBlockUTINamespace>
</xsl:if>
<xsl:if test="$CAPBClientBrokerIntentToBlankBlockUTINamespace">
<CAPBClientBrokerIntentToBlankBlockUTINamespace>
<xsl:value-of select="$CAPBClientBrokerIntentToBlankBlockUTINamespace"/>
</CAPBClientBrokerIntentToBlankBlockUTINamespace>
</xsl:if>
<xsl:if test="$CAPBClientBrokerBlockUTI">
<CAPBClientBrokerBlockUTI>
<xsl:value-of select="$CAPBClientBrokerBlockUTI"/>
</CAPBClientBrokerBlockUTI>
</xsl:if>
<xsl:if test="$CAPBClientBrokerIntentToBlankBlockUTI">
<CAPBClientBrokerIntentToBlankBlockUTI>
<xsl:value-of select="$CAPBClientBrokerIntentToBlankBlockUTI"/>
</CAPBClientBrokerIntentToBlankBlockUTI>
</xsl:if>
<xsl:if test="$CAPBClientBrokerPriorUTINamespace">
<CAPBClientBrokerPriorUTINamespace>
<xsl:value-of select="$CAPBClientBrokerPriorUTINamespace"/>
</CAPBClientBrokerPriorUTINamespace>
</xsl:if>
<xsl:if test="$CAPBClientBrokerIntentToBlankPriorUTINamespace">
<CAPBClientBrokerIntentToBlankPriorUTINamespace>
<xsl:value-of select="$CAPBClientBrokerIntentToBlankPriorUTINamespace"/>
</CAPBClientBrokerIntentToBlankPriorUTINamespace>
</xsl:if>
<xsl:if test="$CAPBClientBrokerPriorUTI">
<CAPBClientBrokerPriorUTI>
<xsl:value-of select="$CAPBClientBrokerPriorUTI"/>
</CAPBClientBrokerPriorUTI>
</xsl:if>
<xsl:if test="$CAPBClientBrokerIntentToBlankPriorUTI">
<CAPBClientBrokerIntentToBlankPriorUTI>
<xsl:value-of select="$CAPBClientBrokerIntentToBlankPriorUTI"/>
</CAPBClientBrokerIntentToBlankPriorUTI>
</xsl:if>
<xsl:if test="$CAPBBlockUTINamespace">
<CAPBBlockUTINamespace>
<xsl:value-of select="$CAPBBlockUTINamespace"/>
</CAPBBlockUTINamespace>
</xsl:if>
<xsl:if test="$CAPBIntentToBlankBlockUTINamespace">
<CAPBIntentToBlankBlockUTINamespace>
<xsl:value-of select="$CAPBIntentToBlankBlockUTINamespace"/>
</CAPBIntentToBlankBlockUTINamespace>
</xsl:if>
<xsl:if test="$CAPBBlockUTI">
<CAPBBlockUTI>
<xsl:value-of select="$CAPBBlockUTI"/>
</CAPBBlockUTI>
</xsl:if>
<xsl:if test="$CAPBIntentToBlankBlockUTI">
<CAPBIntentToBlankBlockUTI>
<xsl:value-of select="$CAPBIntentToBlankBlockUTI"/>
</CAPBIntentToBlankBlockUTI>
</xsl:if>
<xsl:if test="$CAPBPriorUTINamespace">
<CAPBPriorUTINamespace>
<xsl:value-of select="$CAPBPriorUTINamespace"/>
</CAPBPriorUTINamespace>
</xsl:if>
<xsl:if test="$CAPBIntentToBlankPriorUTINamespace">
<CAPBIntentToBlankPriorUTINamespace>
<xsl:value-of select="$CAPBIntentToBlankPriorUTINamespace"/>
</CAPBIntentToBlankPriorUTINamespace>
</xsl:if>
<xsl:if test="$CAPBPriorUTI">
<CAPBPriorUTI>
<xsl:value-of select="$CAPBPriorUTI"/>
</CAPBPriorUTI>
</xsl:if>
<xsl:if test="$CAPBIntentToBlankPriorUTI">
<CAPBIntentToBlankPriorUTI>
<xsl:value-of select="$CAPBIntentToBlankPriorUTI"/>
</CAPBIntentToBlankPriorUTI>
</xsl:if>
<xsl:if test="$CAClientBlockUTINamespace">
<CAClientBlockUTINamespace>
<xsl:value-of select="$CAClientBlockUTINamespace"/>
</CAClientBlockUTINamespace>
</xsl:if>
<xsl:if test="$CAClientIntentToBlankBlockUTINamespace">
<CAClientIntentToBlankBlockUTINamespace>
<xsl:value-of select="$CAClientIntentToBlankBlockUTINamespace"/>
</CAClientIntentToBlankBlockUTINamespace>
</xsl:if>
<xsl:if test="$CAClientBlockUTI">
<CAClientBlockUTI>
<xsl:value-of select="$CAClientBlockUTI"/>
</CAClientBlockUTI>
</xsl:if>
<xsl:if test="$CAClientIntentToBlankBlockUTI">
<CAClientIntentToBlankBlockUTI>
<xsl:value-of select="$CAClientIntentToBlankBlockUTI"/>
</CAClientIntentToBlankBlockUTI>
</xsl:if>
<xsl:if test="$CAClientPriorUTINamespace">
<CAClientPriorUTINamespace>
<xsl:value-of select="$CAClientPriorUTINamespace"/>
</CAClientPriorUTINamespace>
</xsl:if>
<xsl:if test="$CAClientIntentToBlankPriorUTINamespace">
<CAClientIntentToBlankPriorUTINamespace>
<xsl:value-of select="$CAClientIntentToBlankPriorUTINamespace"/>
</CAClientIntentToBlankPriorUTINamespace>
</xsl:if>
<xsl:if test="$CAClientPriorUTI">
<CAClientPriorUTI>
<xsl:value-of select="$CAClientPriorUTI"/>
</CAClientPriorUTI>
</xsl:if>
<xsl:if test="$CAClientIntentToBlankPriorUTI">
<CAClientIntentToBlankPriorUTI>
<xsl:value-of select="$CAClientIntentToBlankPriorUTI"/>
</CAClientIntentToBlankPriorUTI>
</xsl:if>
</xsl:template>
<xsl:template name="lcl:HKMAData">
<xsl:param name="HKMADataPresent" select="/.."/>
<xsl:param name="HKMARegulatorType" select="/.."/>
<xsl:param name="HKMARoute1Destination" select="/.."/>
<xsl:param name="HKMARoute1Intermediary" select="/.."/>
<xsl:param name="HKMAUTINamespace" select="/.."/>
<xsl:param name="HKMAIntentToBlankUTINamespace" select="/.."/>
<xsl:param name="HKMAUTINamespacePrefix" select="/.."/>
<xsl:param name="HKMAUTI" select="/.."/>
<xsl:param name="HKMAIntentToBlankUTI" select="/.."/>
<xsl:param name="HKMABlockUTINamespace" select="/.."/>
<xsl:param name="HKMAIntentToBlankBlockUTINamespace" select="/.."/>
<xsl:param name="HKMABlockUTI" select="/.."/>
<xsl:param name="HKMAIntentToBlankBlockUTI" select="/.."/>
<xsl:param name="HKMAClearingException" select="/.."/>
<xsl:param name="HKMAPriorUTINamespace" select="/.."/>
<xsl:param name="HKMAIntentToBlankPriorUTINamespace" select="/.."/>
<xsl:param name="HKMAPriorUTI" select="/.."/>
<xsl:param name="HKMAIntentToBlankPriorUTI" select="/.."/>
<xsl:param name="HKMAPartyABlockUTINamespace" select="/.."/>
<xsl:param name="HKMAPartyAIntentToBlankBlockUTINamespace" select="/.."/>
<xsl:param name="HKMAPartyABlockUTI" select="/.."/>
<xsl:param name="HKMAPartyAIntentToBlankBlockUTI" select="/.."/>
<xsl:param name="HKMAPartyAClearingException" select="/.."/>
<xsl:param name="HKMAPartyAPriorUTINamespace" select="/.."/>
<xsl:param name="HKMAPartyAIntentToBlankPriorUTINamespace" select="/.."/>
<xsl:param name="HKMAPartyAPriorUTI" select="/.."/>
<xsl:param name="HKMAPartyAIntentToBlankPriorUTI" select="/.."/>
<xsl:param name="HKMAPartyBBlockUTINamespace" select="/.."/>
<xsl:param name="HKMAPartyBIntentToBlankBlockUTINamespace" select="/.."/>
<xsl:param name="HKMAPartyBBlockUTI" select="/.."/>
<xsl:param name="HKMAPartyBIntentToBlankBlockUTI" select="/.."/>
<xsl:param name="HKMAPartyBClearingException" select="/.."/>
<xsl:param name="HKMAPartyBPriorUTINamespace" select="/.."/>
<xsl:param name="HKMAPartyBIntentToBlankPriorUTINamespace" select="/.."/>
<xsl:param name="HKMAPartyBPriorUTI" select="/.."/>
<xsl:param name="HKMAPartyBIntentToBlankPriorUTI" select="/.."/>
<xsl:param name="HKMAPBClientDataPresent" select="/.."/>
<xsl:param name="HKMAPBClientRegulatorType" select="/.."/>
<xsl:param name="HKMAPBClientRoute1Destination" select="/.."/>
<xsl:param name="HKMAPBClientRoute1Intermediary" select="/.."/>
<xsl:param name="HKMAPBClientUTINamespace" select="/.."/>
<xsl:param name="HKMAPBClientIntentToBlankUTINamespace" select="/.."/>
<xsl:param name="HKMAPBClientUTINamespacePrefix" select="/.."/>
<xsl:param name="HKMAPBClientUTI" select="/.."/>
<xsl:param name="HKMAPBClientIntentToBlankUTI" select="/.."/>
<xsl:param name="HKMAPBClientBrokerBlockUTINamespace" select="/.."/>
<xsl:param name="HKMAPBClientBrokerIntentToBlankBlockUTINamespace" select="/.."/>
<xsl:param name="HKMAPBClientBrokerBlockUTI" select="/.."/>
<xsl:param name="HKMAPBClientBrokerIntentToBlankBlockUTI" select="/.."/>
<xsl:param name="HKMAPBClientBrokerPriorUTINamespace" select="/.."/>
<xsl:param name="HKMAPBClientBrokerIntentToBlankPriorUTINamespace" select="/.."/>
<xsl:param name="HKMAPBClientBrokerPriorUTI" select="/.."/>
<xsl:param name="HKMAPBClientBrokerIntentToBlankPriorUTI" select="/.."/>
<xsl:param name="HKMAPBBlockUTINamespace" select="/.."/>
<xsl:param name="HKMAPBIntentToBlankBlockUTINamespace" select="/.."/>
<xsl:param name="HKMAPBBlockUTI" select="/.."/>
<xsl:param name="HKMAPBIntentToBlankBlockUTI" select="/.."/>
<xsl:param name="HKMAPBPriorUTINamespace" select="/.."/>
<xsl:param name="HKMAPBIntentToBlankPriorUTINamespace" select="/.."/>
<xsl:param name="HKMAPBPriorUTI" select="/.."/>
<xsl:param name="HKMAPBIntentToBlankPriorUTI" select="/.."/>
<xsl:param name="HKMAClientBlockUTINamespace" select="/.."/>
<xsl:param name="HKMAClientIntentToBlankBlockUTINamespace" select="/.."/>
<xsl:param name="HKMAClientBlockUTI" select="/.."/>
<xsl:param name="HKMAClientIntentToBlankBlockUTI" select="/.."/>
<xsl:param name="HKMAClientPriorUTINamespace" select="/.."/>
<xsl:param name="HKMAClientIntentToBlankPriorUTINamespace" select="/.."/>
<xsl:param name="HKMAClientPriorUTI" select="/.."/>
<xsl:param name="HKMAClientIntentToBlankPriorUTI" select="/.."/>
<xsl:if test="$HKMADataPresent">
<HKMADataPresent>
<xsl:value-of select="$HKMADataPresent"/>
</HKMADataPresent>
</xsl:if>
<xsl:if test="$HKMARegulatorType">
<HKMARegulatorType>
<xsl:value-of select="$HKMARegulatorType"/>
</HKMARegulatorType>
</xsl:if>
<xsl:if test="$HKMARoute1Destination">
<HKMARoute1Destination>
<xsl:value-of select="$HKMARoute1Destination"/>
</HKMARoute1Destination>
</xsl:if>
<xsl:if test="$HKMARoute1Intermediary">
<HKMARoute1Intermediary>
<xsl:value-of select="$HKMARoute1Intermediary"/>
</HKMARoute1Intermediary>
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
<xsl:if test="$HKMAIntentToBlankUTI">
<HKMAIntentToBlankUTI>
<xsl:value-of select="$HKMAIntentToBlankUTI"/>
</HKMAIntentToBlankUTI>
</xsl:if>
<xsl:if test="$HKMABlockUTINamespace">
<HKMABlockUTINamespace>
<xsl:value-of select="$HKMABlockUTINamespace"/>
</HKMABlockUTINamespace>
</xsl:if>
<xsl:if test="$HKMAIntentToBlankBlockUTINamespace">
<HKMAIntentToBlankBlockUTINamespace>
<xsl:value-of select="$HKMAIntentToBlankBlockUTINamespace"/>
</HKMAIntentToBlankBlockUTINamespace>
</xsl:if>
<xsl:if test="$HKMABlockUTI">
<HKMABlockUTI>
<xsl:value-of select="$HKMABlockUTI"/>
</HKMABlockUTI>
</xsl:if>
<xsl:if test="$HKMAIntentToBlankBlockUTI">
<HKMAIntentToBlankBlockUTI>
<xsl:value-of select="$HKMAIntentToBlankBlockUTI"/>
</HKMAIntentToBlankBlockUTI>
</xsl:if>
<xsl:if test="$HKMAClearingException">
<HKMAClearingException>
<xsl:value-of select="$HKMAClearingException"/>
</HKMAClearingException>
</xsl:if>
<xsl:if test="$HKMAPriorUTINamespace">
<HKMAPriorUTINamespace>
<xsl:value-of select="$HKMAPriorUTINamespace"/>
</HKMAPriorUTINamespace>
</xsl:if>
<xsl:if test="$HKMAIntentToBlankPriorUTINamespace">
<HKMAIntentToBlankPriorUTINamespace>
<xsl:value-of select="$HKMAIntentToBlankPriorUTINamespace"/>
</HKMAIntentToBlankPriorUTINamespace>
</xsl:if>
<xsl:if test="$HKMAPriorUTI">
<HKMAPriorUTI>
<xsl:value-of select="$HKMAPriorUTI"/>
</HKMAPriorUTI>
</xsl:if>
<xsl:if test="$HKMAIntentToBlankPriorUTI">
<HKMAIntentToBlankPriorUTI>
<xsl:value-of select="$HKMAIntentToBlankPriorUTI"/>
</HKMAIntentToBlankPriorUTI>
</xsl:if>
<xsl:if test="$HKMAPartyABlockUTINamespace">
<HKMAPartyABlockUTINamespace>
<xsl:value-of select="$HKMAPartyABlockUTINamespace"/>
</HKMAPartyABlockUTINamespace>
</xsl:if>
<xsl:if test="$HKMAPartyAIntentToBlankBlockUTINamespace">
<HKMAPartyAIntentToBlankBlockUTINamespace>
<xsl:value-of select="$HKMAPartyAIntentToBlankBlockUTINamespace"/>
</HKMAPartyAIntentToBlankBlockUTINamespace>
</xsl:if>
<xsl:if test="$HKMAPartyABlockUTI">
<HKMAPartyABlockUTI>
<xsl:value-of select="$HKMAPartyABlockUTI"/>
</HKMAPartyABlockUTI>
</xsl:if>
<xsl:if test="$HKMAPartyAIntentToBlankBlockUTI">
<HKMAPartyAIntentToBlankBlockUTI>
<xsl:value-of select="$HKMAPartyAIntentToBlankBlockUTI"/>
</HKMAPartyAIntentToBlankBlockUTI>
</xsl:if>
<xsl:if test="$HKMAPartyAClearingException">
<HKMAPartyAClearingException>
<xsl:value-of select="$HKMAPartyAClearingException"/>
</HKMAPartyAClearingException>
</xsl:if>
<xsl:if test="$HKMAPartyAPriorUTINamespace">
<HKMAPartyAPriorUTINamespace>
<xsl:value-of select="$HKMAPartyAPriorUTINamespace"/>
</HKMAPartyAPriorUTINamespace>
</xsl:if>
<xsl:if test="$HKMAPartyAIntentToBlankPriorUTINamespace">
<HKMAPartyAIntentToBlankPriorUTINamespace>
<xsl:value-of select="$HKMAPartyAIntentToBlankPriorUTINamespace"/>
</HKMAPartyAIntentToBlankPriorUTINamespace>
</xsl:if>
<xsl:if test="$HKMAPartyAPriorUTI">
<HKMAPartyAPriorUTI>
<xsl:value-of select="$HKMAPartyAPriorUTI"/>
</HKMAPartyAPriorUTI>
</xsl:if>
<xsl:if test="$HKMAPartyAIntentToBlankPriorUTI">
<HKMAPartyAIntentToBlankPriorUTI>
<xsl:value-of select="$HKMAPartyAIntentToBlankPriorUTI"/>
</HKMAPartyAIntentToBlankPriorUTI>
</xsl:if>
<xsl:if test="$HKMAPartyBBlockUTINamespace">
<HKMAPartyBBlockUTINamespace>
<xsl:value-of select="$HKMAPartyBBlockUTINamespace"/>
</HKMAPartyBBlockUTINamespace>
</xsl:if>
<xsl:if test="$HKMAPartyBIntentToBlankBlockUTINamespace">
<HKMAPartyBIntentToBlankBlockUTINamespace>
<xsl:value-of select="$HKMAPartyBIntentToBlankBlockUTINamespace"/>
</HKMAPartyBIntentToBlankBlockUTINamespace>
</xsl:if>
<xsl:if test="$HKMAPartyBBlockUTI">
<HKMAPartyBBlockUTI>
<xsl:value-of select="$HKMAPartyBBlockUTI"/>
</HKMAPartyBBlockUTI>
</xsl:if>
<xsl:if test="$HKMAPartyBIntentToBlankBlockUTI">
<HKMAPartyBIntentToBlankBlockUTI>
<xsl:value-of select="$HKMAPartyBIntentToBlankBlockUTI"/>
</HKMAPartyBIntentToBlankBlockUTI>
</xsl:if>
<xsl:if test="$HKMAPartyBClearingException">
<HKMAPartyBClearingException>
<xsl:value-of select="$HKMAPartyBClearingException"/>
</HKMAPartyBClearingException>
</xsl:if>
<xsl:if test="$HKMAPartyBPriorUTINamespace">
<HKMAPartyBPriorUTINamespace>
<xsl:value-of select="$HKMAPartyBPriorUTINamespace"/>
</HKMAPartyBPriorUTINamespace>
</xsl:if>
<xsl:if test="$HKMAPartyBIntentToBlankPriorUTINamespace">
<HKMAPartyBIntentToBlankPriorUTINamespace>
<xsl:value-of select="$HKMAPartyBIntentToBlankPriorUTINamespace"/>
</HKMAPartyBIntentToBlankPriorUTINamespace>
</xsl:if>
<xsl:if test="$HKMAPartyBPriorUTI">
<HKMAPartyBPriorUTI>
<xsl:value-of select="$HKMAPartyBPriorUTI"/>
</HKMAPartyBPriorUTI>
</xsl:if>
<xsl:if test="$HKMAPartyBIntentToBlankPriorUTI">
<HKMAPartyBIntentToBlankPriorUTI>
<xsl:value-of select="$HKMAPartyBIntentToBlankPriorUTI"/>
</HKMAPartyBIntentToBlankPriorUTI>
</xsl:if>
<xsl:if test="$HKMAPBClientDataPresent">
<HKMAPBClientDataPresent>
<xsl:value-of select="$HKMAPBClientDataPresent"/>
</HKMAPBClientDataPresent>
</xsl:if>
<xsl:if test="$HKMAPBClientRegulatorType">
<HKMAPBClientRegulatorType>
<xsl:value-of select="$HKMAPBClientRegulatorType"/>
</HKMAPBClientRegulatorType>
</xsl:if>
<xsl:if test="$HKMAPBClientRoute1Destination">
<HKMAPBClientRoute1Destination>
<xsl:value-of select="$HKMAPBClientRoute1Destination"/>
</HKMAPBClientRoute1Destination>
</xsl:if>
<xsl:if test="$HKMAPBClientRoute1Intermediary">
<HKMAPBClientRoute1Intermediary>
<xsl:value-of select="$HKMAPBClientRoute1Intermediary"/>
</HKMAPBClientRoute1Intermediary>
</xsl:if>
<xsl:if test="$HKMAPBClientUTINamespace">
<HKMAPBClientUTINamespace>
<xsl:value-of select="$HKMAPBClientUTINamespace"/>
</HKMAPBClientUTINamespace>
</xsl:if>
<xsl:if test="$HKMAPBClientIntentToBlankUTINamespace">
<HKMAPBClientIntentToBlankUTINamespace>
<xsl:value-of select="$HKMAPBClientIntentToBlankUTINamespace"/>
</HKMAPBClientIntentToBlankUTINamespace>
</xsl:if>
<xsl:if test="$HKMAPBClientUTINamespacePrefix">
<HKMAPBClientUTINamespacePrefix>
<xsl:value-of select="$HKMAPBClientUTINamespacePrefix"/>
</HKMAPBClientUTINamespacePrefix>
</xsl:if>
<xsl:if test="$HKMAPBClientUTI">
<HKMAPBClientUTI>
<xsl:value-of select="$HKMAPBClientUTI"/>
</HKMAPBClientUTI>
</xsl:if>
<xsl:if test="$HKMAPBClientIntentToBlankUTI">
<HKMAPBClientIntentToBlankUTI>
<xsl:value-of select="$HKMAPBClientIntentToBlankUTI"/>
</HKMAPBClientIntentToBlankUTI>
</xsl:if>
<xsl:if test="$HKMAPBClientBrokerBlockUTINamespace">
<HKMAPBClientBrokerBlockUTINamespace>
<xsl:value-of select="$HKMAPBClientBrokerBlockUTINamespace"/>
</HKMAPBClientBrokerBlockUTINamespace>
</xsl:if>
<xsl:if test="$HKMAPBClientBrokerIntentToBlankBlockUTINamespace">
<HKMAPBClientBrokerIntentToBlankBlockUTINamespace>
<xsl:value-of select="$HKMAPBClientBrokerIntentToBlankBlockUTINamespace"/>
</HKMAPBClientBrokerIntentToBlankBlockUTINamespace>
</xsl:if>
<xsl:if test="$HKMAPBClientBrokerBlockUTI">
<HKMAPBClientBrokerBlockUTI>
<xsl:value-of select="$HKMAPBClientBrokerBlockUTI"/>
</HKMAPBClientBrokerBlockUTI>
</xsl:if>
<xsl:if test="$HKMAPBClientBrokerIntentToBlankBlockUTI">
<HKMAPBClientBrokerIntentToBlankBlockUTI>
<xsl:value-of select="$HKMAPBClientBrokerIntentToBlankBlockUTI"/>
</HKMAPBClientBrokerIntentToBlankBlockUTI>
</xsl:if>
<xsl:if test="$HKMAPBClientBrokerPriorUTINamespace">
<HKMAPBClientBrokerPriorUTINamespace>
<xsl:value-of select="$HKMAPBClientBrokerPriorUTINamespace"/>
</HKMAPBClientBrokerPriorUTINamespace>
</xsl:if>
<xsl:if test="$HKMAPBClientBrokerIntentToBlankPriorUTINamespace">
<HKMAPBClientBrokerIntentToBlankPriorUTINamespace>
<xsl:value-of select="$HKMAPBClientBrokerIntentToBlankPriorUTINamespace"/>
</HKMAPBClientBrokerIntentToBlankPriorUTINamespace>
</xsl:if>
<xsl:if test="$HKMAPBClientBrokerPriorUTI">
<HKMAPBClientBrokerPriorUTI>
<xsl:value-of select="$HKMAPBClientBrokerPriorUTI"/>
</HKMAPBClientBrokerPriorUTI>
</xsl:if>
<xsl:if test="$HKMAPBClientBrokerIntentToBlankPriorUTI">
<HKMAPBClientBrokerIntentToBlankPriorUTI>
<xsl:value-of select="$HKMAPBClientBrokerIntentToBlankPriorUTI"/>
</HKMAPBClientBrokerIntentToBlankPriorUTI>
</xsl:if>
<xsl:if test="$HKMAPBBlockUTINamespace">
<HKMAPBBlockUTINamespace>
<xsl:value-of select="$HKMAPBBlockUTINamespace"/>
</HKMAPBBlockUTINamespace>
</xsl:if>
<xsl:if test="$HKMAPBIntentToBlankBlockUTINamespace">
<HKMAPBIntentToBlankBlockUTINamespace>
<xsl:value-of select="$HKMAPBIntentToBlankBlockUTINamespace"/>
</HKMAPBIntentToBlankBlockUTINamespace>
</xsl:if>
<xsl:if test="$HKMAPBBlockUTI">
<HKMAPBBlockUTI>
<xsl:value-of select="$HKMAPBBlockUTI"/>
</HKMAPBBlockUTI>
</xsl:if>
<xsl:if test="$HKMAPBIntentToBlankBlockUTI">
<HKMAPBIntentToBlankBlockUTI>
<xsl:value-of select="$HKMAPBIntentToBlankBlockUTI"/>
</HKMAPBIntentToBlankBlockUTI>
</xsl:if>
<xsl:if test="$HKMAPBPriorUTINamespace">
<HKMAPBPriorUTINamespace>
<xsl:value-of select="$HKMAPBPriorUTINamespace"/>
</HKMAPBPriorUTINamespace>
</xsl:if>
<xsl:if test="$HKMAPBIntentToBlankPriorUTINamespace">
<HKMAPBIntentToBlankPriorUTINamespace>
<xsl:value-of select="$HKMAPBIntentToBlankPriorUTINamespace"/>
</HKMAPBIntentToBlankPriorUTINamespace>
</xsl:if>
<xsl:if test="$HKMAPBPriorUTI">
<HKMAPBPriorUTI>
<xsl:value-of select="$HKMAPBPriorUTI"/>
</HKMAPBPriorUTI>
</xsl:if>
<xsl:if test="$HKMAPBIntentToBlankPriorUTI">
<HKMAPBIntentToBlankPriorUTI>
<xsl:value-of select="$HKMAPBIntentToBlankPriorUTI"/>
</HKMAPBIntentToBlankPriorUTI>
</xsl:if>
<xsl:if test="$HKMAClientBlockUTINamespace">
<HKMAClientBlockUTINamespace>
<xsl:value-of select="$HKMAClientBlockUTINamespace"/>
</HKMAClientBlockUTINamespace>
</xsl:if>
<xsl:if test="$HKMAClientIntentToBlankBlockUTINamespace">
<HKMAClientIntentToBlankBlockUTINamespace>
<xsl:value-of select="$HKMAClientIntentToBlankBlockUTINamespace"/>
</HKMAClientIntentToBlankBlockUTINamespace>
</xsl:if>
<xsl:if test="$HKMAClientBlockUTI">
<HKMAClientBlockUTI>
<xsl:value-of select="$HKMAClientBlockUTI"/>
</HKMAClientBlockUTI>
</xsl:if>
<xsl:if test="$HKMAClientIntentToBlankBlockUTI">
<HKMAClientIntentToBlankBlockUTI>
<xsl:value-of select="$HKMAClientIntentToBlankBlockUTI"/>
</HKMAClientIntentToBlankBlockUTI>
</xsl:if>
<xsl:if test="$HKMAClientPriorUTINamespace">
<HKMAClientPriorUTINamespace>
<xsl:value-of select="$HKMAClientPriorUTINamespace"/>
</HKMAClientPriorUTINamespace>
</xsl:if>
<xsl:if test="$HKMAClientIntentToBlankPriorUTINamespace">
<HKMAClientIntentToBlankPriorUTINamespace>
<xsl:value-of select="$HKMAClientIntentToBlankPriorUTINamespace"/>
</HKMAClientIntentToBlankPriorUTINamespace>
</xsl:if>
<xsl:if test="$HKMAClientPriorUTI">
<HKMAClientPriorUTI>
<xsl:value-of select="$HKMAClientPriorUTI"/>
</HKMAClientPriorUTI>
</xsl:if>
<xsl:if test="$HKMAClientIntentToBlankPriorUTI">
<HKMAClientIntentToBlankPriorUTI>
<xsl:value-of select="$HKMAClientIntentToBlankPriorUTI"/>
</HKMAClientIntentToBlankPriorUTI>
</xsl:if>
</xsl:template>
<xsl:template name="lcl:ASICData">
<xsl:param name="ASICDataPresent" select="/.."/>
<xsl:param name="ASICRegulatorType" select="/.."/>
<xsl:param name="ASICRoute1Destination" select="/.."/>
<xsl:param name="ASICRoute1Intermediary" select="/.."/>
<xsl:param name="ASICUTINamespace" select="/.."/>
<xsl:param name="ASICIntentToBlankUTINamespace" select="/.."/>
<xsl:param name="ASICUTINamespacePrefix" select="/.."/>
<xsl:param name="ASICUTI" select="/.."/>
<xsl:param name="ASICIntentToBlankUTI" select="/.."/>
<xsl:param name="ASICBlockUTINamespace" select="/.."/>
<xsl:param name="ASICIntentToBlankBlockUTINamespace" select="/.."/>
<xsl:param name="ASICBlockUTI" select="/.."/>
<xsl:param name="ASICIntentToBlankBlockUTI" select="/.."/>
<xsl:param name="ASICClearingException" select="/.."/>
<xsl:param name="ASICPriorUTINamespace" select="/.."/>
<xsl:param name="ASICIntentToBlankPriorUTINamespace" select="/.."/>
<xsl:param name="ASICPriorUTI" select="/.."/>
<xsl:param name="ASICIntentToBlankPriorUTI" select="/.."/>
<xsl:param name="ASICPartyABlockUTINamespace" select="/.."/>
<xsl:param name="ASICPartyAIntentToBlankBlockUTINamespace" select="/.."/>
<xsl:param name="ASICPartyABlockUTI" select="/.."/>
<xsl:param name="ASICPartyAIntentToBlankBlockUTI" select="/.."/>
<xsl:param name="ASICPartyAClearingException" select="/.."/>
<xsl:param name="ASICPartyAPriorUTINamespace" select="/.."/>
<xsl:param name="ASICPartyAIntentToBlankPriorUTINamespace" select="/.."/>
<xsl:param name="ASICPartyAPriorUTI" select="/.."/>
<xsl:param name="ASICPartyAIntentToBlankPriorUTI" select="/.."/>
<xsl:param name="ASICPartyBBlockUTINamespace" select="/.."/>
<xsl:param name="ASICPartyBIntentToBlankBlockUTINamespace" select="/.."/>
<xsl:param name="ASICPartyBBlockUTI" select="/.."/>
<xsl:param name="ASICPartyBIntentToBlankBlockUTI" select="/.."/>
<xsl:param name="ASICPartyBClearingException" select="/.."/>
<xsl:param name="ASICPartyBPriorUTINamespace" select="/.."/>
<xsl:param name="ASICPartyBIntentToBlankPriorUTINamespace" select="/.."/>
<xsl:param name="ASICPartyBPriorUTI" select="/.."/>
<xsl:param name="ASICPartyBIntentToBlankPriorUTI" select="/.."/>
<xsl:param name="ASICPBClientDataPresent" select="/.."/>
<xsl:param name="ASICPBClientRegulatorType" select="/.."/>
<xsl:param name="ASICPBClientRoute1Destination" select="/.."/>
<xsl:param name="ASICPBClientRoute1Intermediary" select="/.."/>
<xsl:param name="ASICPBClientUTINamespace" select="/.."/>
<xsl:param name="ASICPBClientIntentToBlankUTINamespace" select="/.."/>
<xsl:param name="ASICPBClientUTINamespacePrefix" select="/.."/>
<xsl:param name="ASICPBClientUTI" select="/.."/>
<xsl:param name="ASICPBClientIntentToBlankUTI" select="/.."/>
<xsl:param name="ASICPBClientBrokerBlockUTINamespace" select="/.."/>
<xsl:param name="ASICPBClientBrokerIntentToBlankBlockUTINamespace" select="/.."/>
<xsl:param name="ASICPBClientBrokerBlockUTI" select="/.."/>
<xsl:param name="ASICPBClientBrokerIntentToBlankBlockUTI" select="/.."/>
<xsl:param name="ASICPBClientBrokerPriorUTINamespace" select="/.."/>
<xsl:param name="ASICPBClientBrokerIntentToBlankPriorUTINamespace" select="/.."/>
<xsl:param name="ASICPBClientBrokerPriorUTI" select="/.."/>
<xsl:param name="ASICPBClientBrokerIntentToBlankPriorUTI" select="/.."/>
<xsl:param name="ASICPBBlockUTINamespace" select="/.."/>
<xsl:param name="ASICPBIntentToBlankBlockUTINamespace" select="/.."/>
<xsl:param name="ASICPBBlockUTI" select="/.."/>
<xsl:param name="ASICPBIntentToBlankBlockUTI" select="/.."/>
<xsl:param name="ASICPBPriorUTINamespace" select="/.."/>
<xsl:param name="ASICPBIntentToBlankPriorUTINamespace" select="/.."/>
<xsl:param name="ASICPBPriorUTI" select="/.."/>
<xsl:param name="ASICPBIntentToBlankPriorUTI" select="/.."/>
<xsl:param name="ASICClientBlockUTINamespace" select="/.."/>
<xsl:param name="ASICClientIntentToBlankBlockUTINamespace" select="/.."/>
<xsl:param name="ASICClientBlockUTI" select="/.."/>
<xsl:param name="ASICClientIntentToBlankBlockUTI" select="/.."/>
<xsl:param name="ASICClientPriorUTINamespace" select="/.."/>
<xsl:param name="ASICClientIntentToBlankPriorUTINamespace" select="/.."/>
<xsl:param name="ASICClientPriorUTI" select="/.."/>
<xsl:param name="ASICClientIntentToBlankPriorUTI" select="/.."/>
<xsl:if test="$ASICDataPresent">
<ASICDataPresent>
<xsl:value-of select="$ASICDataPresent"/>
</ASICDataPresent>
</xsl:if>
<xsl:if test="$ASICRegulatorType">
<ASICRegulatorType>
<xsl:value-of select="$ASICRegulatorType"/>
</ASICRegulatorType>
</xsl:if>
<xsl:if test="$ASICRoute1Destination">
<ASICRoute1Destination>
<xsl:value-of select="$ASICRoute1Destination"/>
</ASICRoute1Destination>
</xsl:if>
<xsl:if test="$ASICRoute1Intermediary">
<ASICRoute1Intermediary>
<xsl:value-of select="$ASICRoute1Intermediary"/>
</ASICRoute1Intermediary>
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
<xsl:if test="$ASICIntentToBlankUTI">
<ASICIntentToBlankUTI>
<xsl:value-of select="$ASICIntentToBlankUTI"/>
</ASICIntentToBlankUTI>
</xsl:if>
<xsl:if test="$ASICBlockUTINamespace">
<ASICBlockUTINamespace>
<xsl:value-of select="$ASICBlockUTINamespace"/>
</ASICBlockUTINamespace>
</xsl:if>
<xsl:if test="$ASICIntentToBlankBlockUTINamespace">
<ASICIntentToBlankBlockUTINamespace>
<xsl:value-of select="$ASICIntentToBlankBlockUTINamespace"/>
</ASICIntentToBlankBlockUTINamespace>
</xsl:if>
<xsl:if test="$ASICBlockUTI">
<ASICBlockUTI>
<xsl:value-of select="$ASICBlockUTI"/>
</ASICBlockUTI>
</xsl:if>
<xsl:if test="$ASICIntentToBlankBlockUTI">
<ASICIntentToBlankBlockUTI>
<xsl:value-of select="$ASICIntentToBlankBlockUTI"/>
</ASICIntentToBlankBlockUTI>
</xsl:if>
<xsl:if test="$ASICClearingException">
<ASICClearingException>
<xsl:value-of select="$ASICClearingException"/>
</ASICClearingException>
</xsl:if>
<xsl:if test="$ASICPriorUTINamespace">
<ASICPriorUTINamespace>
<xsl:value-of select="$ASICPriorUTINamespace"/>
</ASICPriorUTINamespace>
</xsl:if>
<xsl:if test="$ASICIntentToBlankPriorUTINamespace">
<ASICIntentToBlankPriorUTINamespace>
<xsl:value-of select="$ASICIntentToBlankPriorUTINamespace"/>
</ASICIntentToBlankPriorUTINamespace>
</xsl:if>
<xsl:if test="$ASICPriorUTI">
<ASICPriorUTI>
<xsl:value-of select="$ASICPriorUTI"/>
</ASICPriorUTI>
</xsl:if>
<xsl:if test="$ASICIntentToBlankPriorUTI">
<ASICIntentToBlankPriorUTI>
<xsl:value-of select="$ASICIntentToBlankPriorUTI"/>
</ASICIntentToBlankPriorUTI>
</xsl:if>
<xsl:if test="$ASICPartyABlockUTINamespace">
<ASICPartyABlockUTINamespace>
<xsl:value-of select="$ASICPartyABlockUTINamespace"/>
</ASICPartyABlockUTINamespace>
</xsl:if>
<xsl:if test="$ASICPartyAIntentToBlankBlockUTINamespace">
<ASICPartyAIntentToBlankBlockUTINamespace>
<xsl:value-of select="$ASICPartyAIntentToBlankBlockUTINamespace"/>
</ASICPartyAIntentToBlankBlockUTINamespace>
</xsl:if>
<xsl:if test="$ASICPartyABlockUTI">
<ASICPartyABlockUTI>
<xsl:value-of select="$ASICPartyABlockUTI"/>
</ASICPartyABlockUTI>
</xsl:if>
<xsl:if test="$ASICPartyAIntentToBlankBlockUTI">
<ASICPartyAIntentToBlankBlockUTI>
<xsl:value-of select="$ASICPartyAIntentToBlankBlockUTI"/>
</ASICPartyAIntentToBlankBlockUTI>
</xsl:if>
<xsl:if test="$ASICPartyAClearingException">
<ASICPartyAClearingException>
<xsl:value-of select="$ASICPartyAClearingException"/>
</ASICPartyAClearingException>
</xsl:if>
<xsl:if test="$ASICPartyAPriorUTINamespace">
<ASICPartyAPriorUTINamespace>
<xsl:value-of select="$ASICPartyAPriorUTINamespace"/>
</ASICPartyAPriorUTINamespace>
</xsl:if>
<xsl:if test="$ASICPartyAIntentToBlankPriorUTINamespace">
<ASICPartyAIntentToBlankPriorUTINamespace>
<xsl:value-of select="$ASICPartyAIntentToBlankPriorUTINamespace"/>
</ASICPartyAIntentToBlankPriorUTINamespace>
</xsl:if>
<xsl:if test="$ASICPartyAPriorUTI">
<ASICPartyAPriorUTI>
<xsl:value-of select="$ASICPartyAPriorUTI"/>
</ASICPartyAPriorUTI>
</xsl:if>
<xsl:if test="$ASICPartyAIntentToBlankPriorUTI">
<ASICPartyAIntentToBlankPriorUTI>
<xsl:value-of select="$ASICPartyAIntentToBlankPriorUTI"/>
</ASICPartyAIntentToBlankPriorUTI>
</xsl:if>
<xsl:if test="$ASICPartyBBlockUTINamespace">
<ASICPartyBBlockUTINamespace>
<xsl:value-of select="$ASICPartyBBlockUTINamespace"/>
</ASICPartyBBlockUTINamespace>
</xsl:if>
<xsl:if test="$ASICPartyBIntentToBlankBlockUTINamespace">
<ASICPartyBIntentToBlankBlockUTINamespace>
<xsl:value-of select="$ASICPartyBIntentToBlankBlockUTINamespace"/>
</ASICPartyBIntentToBlankBlockUTINamespace>
</xsl:if>
<xsl:if test="$ASICPartyBBlockUTI">
<ASICPartyBBlockUTI>
<xsl:value-of select="$ASICPartyBBlockUTI"/>
</ASICPartyBBlockUTI>
</xsl:if>
<xsl:if test="$ASICPartyBIntentToBlankBlockUTI">
<ASICPartyBIntentToBlankBlockUTI>
<xsl:value-of select="$ASICPartyBIntentToBlankBlockUTI"/>
</ASICPartyBIntentToBlankBlockUTI>
</xsl:if>
<xsl:if test="$ASICPartyBClearingException">
<ASICPartyBClearingException>
<xsl:value-of select="$ASICPartyBClearingException"/>
</ASICPartyBClearingException>
</xsl:if>
<xsl:if test="$ASICPartyBPriorUTINamespace">
<ASICPartyBPriorUTINamespace>
<xsl:value-of select="$ASICPartyBPriorUTINamespace"/>
</ASICPartyBPriorUTINamespace>
</xsl:if>
<xsl:if test="$ASICPartyBIntentToBlankPriorUTINamespace">
<ASICPartyBIntentToBlankPriorUTINamespace>
<xsl:value-of select="$ASICPartyBIntentToBlankPriorUTINamespace"/>
</ASICPartyBIntentToBlankPriorUTINamespace>
</xsl:if>
<xsl:if test="$ASICPartyBPriorUTI">
<ASICPartyBPriorUTI>
<xsl:value-of select="$ASICPartyBPriorUTI"/>
</ASICPartyBPriorUTI>
</xsl:if>
<xsl:if test="$ASICPartyBIntentToBlankPriorUTI">
<ASICPartyBIntentToBlankPriorUTI>
<xsl:value-of select="$ASICPartyBIntentToBlankPriorUTI"/>
</ASICPartyBIntentToBlankPriorUTI>
</xsl:if>
<xsl:if test="$ASICPBClientDataPresent">
<ASICPBClientDataPresent>
<xsl:value-of select="$ASICPBClientDataPresent"/>
</ASICPBClientDataPresent>
</xsl:if>
<xsl:if test="$ASICPBClientRegulatorType">
<ASICPBClientRegulatorType>
<xsl:value-of select="$ASICPBClientRegulatorType"/>
</ASICPBClientRegulatorType>
</xsl:if>
<xsl:if test="$ASICPBClientRoute1Destination">
<ASICPBClientRoute1Destination>
<xsl:value-of select="$ASICPBClientRoute1Destination"/>
</ASICPBClientRoute1Destination>
</xsl:if>
<xsl:if test="$ASICPBClientRoute1Intermediary">
<ASICPBClientRoute1Intermediary>
<xsl:value-of select="$ASICPBClientRoute1Intermediary"/>
</ASICPBClientRoute1Intermediary>
</xsl:if>
<xsl:if test="$ASICPBClientUTINamespace">
<ASICPBClientUTINamespace>
<xsl:value-of select="$ASICPBClientUTINamespace"/>
</ASICPBClientUTINamespace>
</xsl:if>
<xsl:if test="$ASICPBClientIntentToBlankUTINamespace">
<ASICPBClientIntentToBlankUTINamespace>
<xsl:value-of select="$ASICPBClientIntentToBlankUTINamespace"/>
</ASICPBClientIntentToBlankUTINamespace>
</xsl:if>
<xsl:if test="$ASICPBClientUTINamespacePrefix">
<ASICPBClientUTINamespacePrefix>
<xsl:value-of select="$ASICPBClientUTINamespacePrefix"/>
</ASICPBClientUTINamespacePrefix>
</xsl:if>
<xsl:if test="$ASICPBClientUTI">
<ASICPBClientUTI>
<xsl:value-of select="$ASICPBClientUTI"/>
</ASICPBClientUTI>
</xsl:if>
<xsl:if test="$ASICPBClientIntentToBlankUTI">
<ASICPBClientIntentToBlankUTI>
<xsl:value-of select="$ASICPBClientIntentToBlankUTI"/>
</ASICPBClientIntentToBlankUTI>
</xsl:if>
<xsl:if test="$ASICPBClientBrokerBlockUTINamespace">
<ASICPBClientBrokerBlockUTINamespace>
<xsl:value-of select="$ASICPBClientBrokerBlockUTINamespace"/>
</ASICPBClientBrokerBlockUTINamespace>
</xsl:if>
<xsl:if test="$ASICPBClientBrokerIntentToBlankBlockUTINamespace">
<ASICPBClientBrokerIntentToBlankBlockUTINamespace>
<xsl:value-of select="$ASICPBClientBrokerIntentToBlankBlockUTINamespace"/>
</ASICPBClientBrokerIntentToBlankBlockUTINamespace>
</xsl:if>
<xsl:if test="$ASICPBClientBrokerBlockUTI">
<ASICPBClientBrokerBlockUTI>
<xsl:value-of select="$ASICPBClientBrokerBlockUTI"/>
</ASICPBClientBrokerBlockUTI>
</xsl:if>
<xsl:if test="$ASICPBClientBrokerIntentToBlankBlockUTI">
<ASICPBClientBrokerIntentToBlankBlockUTI>
<xsl:value-of select="$ASICPBClientBrokerIntentToBlankBlockUTI"/>
</ASICPBClientBrokerIntentToBlankBlockUTI>
</xsl:if>
<xsl:if test="$ASICPBClientBrokerPriorUTINamespace">
<ASICPBClientBrokerPriorUTINamespace>
<xsl:value-of select="$ASICPBClientBrokerPriorUTINamespace"/>
</ASICPBClientBrokerPriorUTINamespace>
</xsl:if>
<xsl:if test="$ASICPBClientBrokerIntentToBlankPriorUTINamespace">
<ASICPBClientBrokerIntentToBlankPriorUTINamespace>
<xsl:value-of select="$ASICPBClientBrokerIntentToBlankPriorUTINamespace"/>
</ASICPBClientBrokerIntentToBlankPriorUTINamespace>
</xsl:if>
<xsl:if test="$ASICPBClientBrokerPriorUTI">
<ASICPBClientBrokerPriorUTI>
<xsl:value-of select="$ASICPBClientBrokerPriorUTI"/>
</ASICPBClientBrokerPriorUTI>
</xsl:if>
<xsl:if test="$ASICPBClientBrokerIntentToBlankPriorUTI">
<ASICPBClientBrokerIntentToBlankPriorUTI>
<xsl:value-of select="$ASICPBClientBrokerIntentToBlankPriorUTI"/>
</ASICPBClientBrokerIntentToBlankPriorUTI>
</xsl:if>
<xsl:if test="$ASICPBBlockUTINamespace">
<ASICPBBlockUTINamespace>
<xsl:value-of select="$ASICPBBlockUTINamespace"/>
</ASICPBBlockUTINamespace>
</xsl:if>
<xsl:if test="$ASICPBIntentToBlankBlockUTINamespace">
<ASICPBIntentToBlankBlockUTINamespace>
<xsl:value-of select="$ASICPBIntentToBlankBlockUTINamespace"/>
</ASICPBIntentToBlankBlockUTINamespace>
</xsl:if>
<xsl:if test="$ASICPBBlockUTI">
<ASICPBBlockUTI>
<xsl:value-of select="$ASICPBBlockUTI"/>
</ASICPBBlockUTI>
</xsl:if>
<xsl:if test="$ASICPBIntentToBlankBlockUTI">
<ASICPBIntentToBlankBlockUTI>
<xsl:value-of select="$ASICPBIntentToBlankBlockUTI"/>
</ASICPBIntentToBlankBlockUTI>
</xsl:if>
<xsl:if test="$ASICPBPriorUTINamespace">
<ASICPBPriorUTINamespace>
<xsl:value-of select="$ASICPBPriorUTINamespace"/>
</ASICPBPriorUTINamespace>
</xsl:if>
<xsl:if test="$ASICPBIntentToBlankPriorUTINamespace">
<ASICPBIntentToBlankPriorUTINamespace>
<xsl:value-of select="$ASICPBIntentToBlankPriorUTINamespace"/>
</ASICPBIntentToBlankPriorUTINamespace>
</xsl:if>
<xsl:if test="$ASICPBPriorUTI">
<ASICPBPriorUTI>
<xsl:value-of select="$ASICPBPriorUTI"/>
</ASICPBPriorUTI>
</xsl:if>
<xsl:if test="$ASICPBIntentToBlankPriorUTI">
<ASICPBIntentToBlankPriorUTI>
<xsl:value-of select="$ASICPBIntentToBlankPriorUTI"/>
</ASICPBIntentToBlankPriorUTI>
</xsl:if>
<xsl:if test="$ASICClientBlockUTINamespace">
<ASICClientBlockUTINamespace>
<xsl:value-of select="$ASICClientBlockUTINamespace"/>
</ASICClientBlockUTINamespace>
</xsl:if>
<xsl:if test="$ASICClientIntentToBlankBlockUTINamespace">
<ASICClientIntentToBlankBlockUTINamespace>
<xsl:value-of select="$ASICClientIntentToBlankBlockUTINamespace"/>
</ASICClientIntentToBlankBlockUTINamespace>
</xsl:if>
<xsl:if test="$ASICClientBlockUTI">
<ASICClientBlockUTI>
<xsl:value-of select="$ASICClientBlockUTI"/>
</ASICClientBlockUTI>
</xsl:if>
<xsl:if test="$ASICClientIntentToBlankBlockUTI">
<ASICClientIntentToBlankBlockUTI>
<xsl:value-of select="$ASICClientIntentToBlankBlockUTI"/>
</ASICClientIntentToBlankBlockUTI>
</xsl:if>
<xsl:if test="$ASICClientPriorUTINamespace">
<ASICClientPriorUTINamespace>
<xsl:value-of select="$ASICClientPriorUTINamespace"/>
</ASICClientPriorUTINamespace>
</xsl:if>
<xsl:if test="$ASICClientIntentToBlankPriorUTINamespace">
<ASICClientIntentToBlankPriorUTINamespace>
<xsl:value-of select="$ASICClientIntentToBlankPriorUTINamespace"/>
</ASICClientIntentToBlankPriorUTINamespace>
</xsl:if>
<xsl:if test="$ASICClientPriorUTI">
<ASICClientPriorUTI>
<xsl:value-of select="$ASICClientPriorUTI"/>
</ASICClientPriorUTI>
</xsl:if>
<xsl:if test="$ASICClientIntentToBlankPriorUTI">
<ASICClientIntentToBlankPriorUTI>
<xsl:value-of select="$ASICClientIntentToBlankPriorUTI"/>
</ASICClientIntentToBlankPriorUTI>
</xsl:if>
</xsl:template>
<xsl:template name="lcl:MASData">
<xsl:param name="MASDataPresent" select="/.."/>
<xsl:param name="MASRegulatorType" select="/.."/>
<xsl:param name="MASRoute1Destination" select="/.."/>
<xsl:param name="MASRoute1Intermediary" select="/.."/>
<xsl:param name="MASUTINamespace" select="/.."/>
<xsl:param name="MASIntentToBlankUTINamespace" select="/.."/>
<xsl:param name="MASUTINamespacePrefix" select="/.."/>
<xsl:param name="MASUTI" select="/.."/>
<xsl:param name="MASIntentToBlankUTI" select="/.."/>
<xsl:param name="MASBlockUTINamespace" select="/.."/>
<xsl:param name="MASIntentToBlankBlockUTINamespace" select="/.."/>
<xsl:param name="MASBlockUTI" select="/.."/>
<xsl:param name="MASIntentToBlankBlockUTI" select="/.."/>
<xsl:param name="MASClearingException" select="/.."/>
<xsl:param name="MASPriorUTINamespace" select="/.."/>
<xsl:param name="MASIntentToBlankPriorUTINamespace" select="/.."/>
<xsl:param name="MASPriorUTI" select="/.."/>
<xsl:param name="MASIntentToBlankPriorUTI" select="/.."/>
<xsl:param name="MASPartyABlockUTINamespace" select="/.."/>
<xsl:param name="MASPartyAIntentToBlankBlockUTINamespace" select="/.."/>
<xsl:param name="MASPartyABlockUTI" select="/.."/>
<xsl:param name="MASPartyAIntentToBlankBlockUTI" select="/.."/>
<xsl:param name="MASPartyAClearingException" select="/.."/>
<xsl:param name="MASPartyAPriorUTINamespace" select="/.."/>
<xsl:param name="MASPartyAIntentToBlankPriorUTINamespace" select="/.."/>
<xsl:param name="MASPartyAPriorUTI" select="/.."/>
<xsl:param name="MASPartyAIntentToBlankPriorUTI" select="/.."/>
<xsl:param name="MASPartyBBlockUTINamespace" select="/.."/>
<xsl:param name="MASPartyBIntentToBlankBlockUTINamespace" select="/.."/>
<xsl:param name="MASPartyBBlockUTI" select="/.."/>
<xsl:param name="MASPartyBIntentToBlankBlockUTI" select="/.."/>
<xsl:param name="MASPartyBClearingException" select="/.."/>
<xsl:param name="MASPartyBPriorUTINamespace" select="/.."/>
<xsl:param name="MASPartyBIntentToBlankPriorUTINamespace" select="/.."/>
<xsl:param name="MASPartyBPriorUTI" select="/.."/>
<xsl:param name="MASPartyBIntentToBlankPriorUTI" select="/.."/>
<xsl:param name="MASPBClientDataPresent" select="/.."/>
<xsl:param name="MASPBClientRegulatorType" select="/.."/>
<xsl:param name="MASPBClientRoute1Destination" select="/.."/>
<xsl:param name="MASPBClientRoute1Intermediary" select="/.."/>
<xsl:param name="MASPBClientUTINamespace" select="/.."/>
<xsl:param name="MASPBClientIntentToBlankUTINamespace" select="/.."/>
<xsl:param name="MASPBClientUTINamespacePrefix" select="/.."/>
<xsl:param name="MASPBClientUTI" select="/.."/>
<xsl:param name="MASPBClientIntentToBlankUTI" select="/.."/>
<xsl:param name="MASPBClientBrokerBlockUTINamespace" select="/.."/>
<xsl:param name="MASPBClientBrokerIntentToBlankBlockUTINamespace" select="/.."/>
<xsl:param name="MASPBClientBrokerBlockUTI" select="/.."/>
<xsl:param name="MASPBClientBrokerIntentToBlankBlockUTI" select="/.."/>
<xsl:param name="MASPBClientBrokerPriorUTINamespace" select="/.."/>
<xsl:param name="MASPBClientBrokerIntentToBlankPriorUTINamespace" select="/.."/>
<xsl:param name="MASPBClientBrokerPriorUTI" select="/.."/>
<xsl:param name="MASPBClientBrokerIntentToBlankPriorUTI" select="/.."/>
<xsl:param name="MASPBBlockUTINamespace" select="/.."/>
<xsl:param name="MASPBIntentToBlankBlockUTINamespace" select="/.."/>
<xsl:param name="MASPBBlockUTI" select="/.."/>
<xsl:param name="MASPBIntentToBlankBlockUTI" select="/.."/>
<xsl:param name="MASPBPriorUTINamespace" select="/.."/>
<xsl:param name="MASPBIntentToBlankPriorUTINamespace" select="/.."/>
<xsl:param name="MASPBPriorUTI" select="/.."/>
<xsl:param name="MASPBIntentToBlankPriorUTI" select="/.."/>
<xsl:param name="MASClientBlockUTINamespace" select="/.."/>
<xsl:param name="MASClientIntentToBlankBlockUTINamespace" select="/.."/>
<xsl:param name="MASClientBlockUTI" select="/.."/>
<xsl:param name="MASClientIntentToBlankBlockUTI" select="/.."/>
<xsl:param name="MASClientPriorUTINamespace" select="/.."/>
<xsl:param name="MASClientIntentToBlankPriorUTINamespace" select="/.."/>
<xsl:param name="MASClientPriorUTI" select="/.."/>
<xsl:param name="MASClientIntentToBlankPriorUTI" select="/.."/>
<xsl:if test="$MASDataPresent">
<MASDataPresent>
<xsl:value-of select="$MASDataPresent"/>
</MASDataPresent>
</xsl:if>
<xsl:if test="$MASRegulatorType">
<MASRegulatorType>
<xsl:value-of select="$MASRegulatorType"/>
</MASRegulatorType>
</xsl:if>
<xsl:if test="$MASRoute1Destination">
<MASRoute1Destination>
<xsl:value-of select="$MASRoute1Destination"/>
</MASRoute1Destination>
</xsl:if>
<xsl:if test="$MASRoute1Intermediary">
<MASRoute1Intermediary>
<xsl:value-of select="$MASRoute1Intermediary"/>
</MASRoute1Intermediary>
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
<xsl:if test="$MASIntentToBlankUTI">
<MASIntentToBlankUTI>
<xsl:value-of select="$MASIntentToBlankUTI"/>
</MASIntentToBlankUTI>
</xsl:if>
<xsl:if test="$MASBlockUTINamespace">
<MASBlockUTINamespace>
<xsl:value-of select="$MASBlockUTINamespace"/>
</MASBlockUTINamespace>
</xsl:if>
<xsl:if test="$MASIntentToBlankBlockUTINamespace">
<MASIntentToBlankBlockUTINamespace>
<xsl:value-of select="$MASIntentToBlankBlockUTINamespace"/>
</MASIntentToBlankBlockUTINamespace>
</xsl:if>
<xsl:if test="$MASBlockUTI">
<MASBlockUTI>
<xsl:value-of select="$MASBlockUTI"/>
</MASBlockUTI>
</xsl:if>
<xsl:if test="$MASIntentToBlankBlockUTI">
<MASIntentToBlankBlockUTI>
<xsl:value-of select="$MASIntentToBlankBlockUTI"/>
</MASIntentToBlankBlockUTI>
</xsl:if>
<xsl:if test="$MASClearingException">
<MASClearingException>
<xsl:value-of select="$MASClearingException"/>
</MASClearingException>
</xsl:if>
<xsl:if test="$MASPriorUTINamespace">
<MASPriorUTINamespace>
<xsl:value-of select="$MASPriorUTINamespace"/>
</MASPriorUTINamespace>
</xsl:if>
<xsl:if test="$MASIntentToBlankPriorUTINamespace">
<MASIntentToBlankPriorUTINamespace>
<xsl:value-of select="$MASIntentToBlankPriorUTINamespace"/>
</MASIntentToBlankPriorUTINamespace>
</xsl:if>
<xsl:if test="$MASPriorUTI">
<MASPriorUTI>
<xsl:value-of select="$MASPriorUTI"/>
</MASPriorUTI>
</xsl:if>
<xsl:if test="$MASIntentToBlankPriorUTI">
<MASIntentToBlankPriorUTI>
<xsl:value-of select="$MASIntentToBlankPriorUTI"/>
</MASIntentToBlankPriorUTI>
</xsl:if>
<xsl:if test="$MASPartyABlockUTINamespace">
<MASPartyABlockUTINamespace>
<xsl:value-of select="$MASPartyABlockUTINamespace"/>
</MASPartyABlockUTINamespace>
</xsl:if>
<xsl:if test="$MASPartyAIntentToBlankBlockUTINamespace">
<MASPartyAIntentToBlankBlockUTINamespace>
<xsl:value-of select="$MASPartyAIntentToBlankBlockUTINamespace"/>
</MASPartyAIntentToBlankBlockUTINamespace>
</xsl:if>
<xsl:if test="$MASPartyABlockUTI">
<MASPartyABlockUTI>
<xsl:value-of select="$MASPartyABlockUTI"/>
</MASPartyABlockUTI>
</xsl:if>
<xsl:if test="$MASPartyAIntentToBlankBlockUTI">
<MASPartyAIntentToBlankBlockUTI>
<xsl:value-of select="$MASPartyAIntentToBlankBlockUTI"/>
</MASPartyAIntentToBlankBlockUTI>
</xsl:if>
<xsl:if test="$MASPartyAClearingException">
<MASPartyAClearingException>
<xsl:value-of select="$MASPartyAClearingException"/>
</MASPartyAClearingException>
</xsl:if>
<xsl:if test="$MASPartyAPriorUTINamespace">
<MASPartyAPriorUTINamespace>
<xsl:value-of select="$MASPartyAPriorUTINamespace"/>
</MASPartyAPriorUTINamespace>
</xsl:if>
<xsl:if test="$MASPartyAIntentToBlankPriorUTINamespace">
<MASPartyAIntentToBlankPriorUTINamespace>
<xsl:value-of select="$MASPartyAIntentToBlankPriorUTINamespace"/>
</MASPartyAIntentToBlankPriorUTINamespace>
</xsl:if>
<xsl:if test="$MASPartyAPriorUTI">
<MASPartyAPriorUTI>
<xsl:value-of select="$MASPartyAPriorUTI"/>
</MASPartyAPriorUTI>
</xsl:if>
<xsl:if test="$MASPartyAIntentToBlankPriorUTI">
<MASPartyAIntentToBlankPriorUTI>
<xsl:value-of select="$MASPartyAIntentToBlankPriorUTI"/>
</MASPartyAIntentToBlankPriorUTI>
</xsl:if>
<xsl:if test="$MASPartyBBlockUTINamespace">
<MASPartyBBlockUTINamespace>
<xsl:value-of select="$MASPartyBBlockUTINamespace"/>
</MASPartyBBlockUTINamespace>
</xsl:if>
<xsl:if test="$MASPartyBIntentToBlankBlockUTINamespace">
<MASPartyBIntentToBlankBlockUTINamespace>
<xsl:value-of select="$MASPartyBIntentToBlankBlockUTINamespace"/>
</MASPartyBIntentToBlankBlockUTINamespace>
</xsl:if>
<xsl:if test="$MASPartyBBlockUTI">
<MASPartyBBlockUTI>
<xsl:value-of select="$MASPartyBBlockUTI"/>
</MASPartyBBlockUTI>
</xsl:if>
<xsl:if test="$MASPartyBIntentToBlankBlockUTI">
<MASPartyBIntentToBlankBlockUTI>
<xsl:value-of select="$MASPartyBIntentToBlankBlockUTI"/>
</MASPartyBIntentToBlankBlockUTI>
</xsl:if>
<xsl:if test="$MASPartyBClearingException">
<MASPartyBClearingException>
<xsl:value-of select="$MASPartyBClearingException"/>
</MASPartyBClearingException>
</xsl:if>
<xsl:if test="$MASPartyBPriorUTINamespace">
<MASPartyBPriorUTINamespace>
<xsl:value-of select="$MASPartyBPriorUTINamespace"/>
</MASPartyBPriorUTINamespace>
</xsl:if>
<xsl:if test="$MASPartyBIntentToBlankPriorUTINamespace">
<MASPartyBIntentToBlankPriorUTINamespace>
<xsl:value-of select="$MASPartyBIntentToBlankPriorUTINamespace"/>
</MASPartyBIntentToBlankPriorUTINamespace>
</xsl:if>
<xsl:if test="$MASPartyBPriorUTI">
<MASPartyBPriorUTI>
<xsl:value-of select="$MASPartyBPriorUTI"/>
</MASPartyBPriorUTI>
</xsl:if>
<xsl:if test="$MASPartyBIntentToBlankPriorUTI">
<MASPartyBIntentToBlankPriorUTI>
<xsl:value-of select="$MASPartyBIntentToBlankPriorUTI"/>
</MASPartyBIntentToBlankPriorUTI>
</xsl:if>
<xsl:if test="$MASPBClientDataPresent">
<MASPBClientDataPresent>
<xsl:value-of select="$MASPBClientDataPresent"/>
</MASPBClientDataPresent>
</xsl:if>
<xsl:if test="$MASPBClientRegulatorType">
<MASPBClientRegulatorType>
<xsl:value-of select="$MASPBClientRegulatorType"/>
</MASPBClientRegulatorType>
</xsl:if>
<xsl:if test="$MASPBClientRoute1Destination">
<MASPBClientRoute1Destination>
<xsl:value-of select="$MASPBClientRoute1Destination"/>
</MASPBClientRoute1Destination>
</xsl:if>
<xsl:if test="$MASPBClientRoute1Intermediary">
<MASPBClientRoute1Intermediary>
<xsl:value-of select="$MASPBClientRoute1Intermediary"/>
</MASPBClientRoute1Intermediary>
</xsl:if>
<xsl:if test="$MASPBClientUTINamespace">
<MASPBClientUTINamespace>
<xsl:value-of select="$MASPBClientUTINamespace"/>
</MASPBClientUTINamespace>
</xsl:if>
<xsl:if test="$MASPBClientIntentToBlankUTINamespace">
<MASPBClientIntentToBlankUTINamespace>
<xsl:value-of select="$MASPBClientIntentToBlankUTINamespace"/>
</MASPBClientIntentToBlankUTINamespace>
</xsl:if>
<xsl:if test="$MASPBClientUTINamespacePrefix">
<MASPBClientUTINamespacePrefix>
<xsl:value-of select="$MASPBClientUTINamespacePrefix"/>
</MASPBClientUTINamespacePrefix>
</xsl:if>
<xsl:if test="$MASPBClientUTI">
<MASPBClientUTI>
<xsl:value-of select="$MASPBClientUTI"/>
</MASPBClientUTI>
</xsl:if>
<xsl:if test="$MASPBClientIntentToBlankUTI">
<MASPBClientIntentToBlankUTI>
<xsl:value-of select="$MASPBClientIntentToBlankUTI"/>
</MASPBClientIntentToBlankUTI>
</xsl:if>
<xsl:if test="$MASPBClientBrokerBlockUTINamespace">
<MASPBClientBrokerBlockUTINamespace>
<xsl:value-of select="$MASPBClientBrokerBlockUTINamespace"/>
</MASPBClientBrokerBlockUTINamespace>
</xsl:if>
<xsl:if test="$MASPBClientBrokerIntentToBlankBlockUTINamespace">
<MASPBClientBrokerIntentToBlankBlockUTINamespace>
<xsl:value-of select="$MASPBClientBrokerIntentToBlankBlockUTINamespace"/>
</MASPBClientBrokerIntentToBlankBlockUTINamespace>
</xsl:if>
<xsl:if test="$MASPBClientBrokerBlockUTI">
<MASPBClientBrokerBlockUTI>
<xsl:value-of select="$MASPBClientBrokerBlockUTI"/>
</MASPBClientBrokerBlockUTI>
</xsl:if>
<xsl:if test="$MASPBClientBrokerIntentToBlankBlockUTI">
<MASPBClientBrokerIntentToBlankBlockUTI>
<xsl:value-of select="$MASPBClientBrokerIntentToBlankBlockUTI"/>
</MASPBClientBrokerIntentToBlankBlockUTI>
</xsl:if>
<xsl:if test="$MASPBClientBrokerPriorUTINamespace">
<MASPBClientBrokerPriorUTINamespace>
<xsl:value-of select="$MASPBClientBrokerPriorUTINamespace"/>
</MASPBClientBrokerPriorUTINamespace>
</xsl:if>
<xsl:if test="$MASPBClientBrokerIntentToBlankPriorUTINamespace">
<MASPBClientBrokerIntentToBlankPriorUTINamespace>
<xsl:value-of select="$MASPBClientBrokerIntentToBlankPriorUTINamespace"/>
</MASPBClientBrokerIntentToBlankPriorUTINamespace>
</xsl:if>
<xsl:if test="$MASPBClientBrokerPriorUTI">
<MASPBClientBrokerPriorUTI>
<xsl:value-of select="$MASPBClientBrokerPriorUTI"/>
</MASPBClientBrokerPriorUTI>
</xsl:if>
<xsl:if test="$MASPBClientBrokerIntentToBlankPriorUTI">
<MASPBClientBrokerIntentToBlankPriorUTI>
<xsl:value-of select="$MASPBClientBrokerIntentToBlankPriorUTI"/>
</MASPBClientBrokerIntentToBlankPriorUTI>
</xsl:if>
<xsl:if test="$MASPBBlockUTINamespace">
<MASPBBlockUTINamespace>
<xsl:value-of select="$MASPBBlockUTINamespace"/>
</MASPBBlockUTINamespace>
</xsl:if>
<xsl:if test="$MASPBIntentToBlankBlockUTINamespace">
<MASPBIntentToBlankBlockUTINamespace>
<xsl:value-of select="$MASPBIntentToBlankBlockUTINamespace"/>
</MASPBIntentToBlankBlockUTINamespace>
</xsl:if>
<xsl:if test="$MASPBBlockUTI">
<MASPBBlockUTI>
<xsl:value-of select="$MASPBBlockUTI"/>
</MASPBBlockUTI>
</xsl:if>
<xsl:if test="$MASPBIntentToBlankBlockUTI">
<MASPBIntentToBlankBlockUTI>
<xsl:value-of select="$MASPBIntentToBlankBlockUTI"/>
</MASPBIntentToBlankBlockUTI>
</xsl:if>
<xsl:if test="$MASPBPriorUTINamespace">
<MASPBPriorUTINamespace>
<xsl:value-of select="$MASPBPriorUTINamespace"/>
</MASPBPriorUTINamespace>
</xsl:if>
<xsl:if test="$MASPBIntentToBlankPriorUTINamespace">
<MASPBIntentToBlankPriorUTINamespace>
<xsl:value-of select="$MASPBIntentToBlankPriorUTINamespace"/>
</MASPBIntentToBlankPriorUTINamespace>
</xsl:if>
<xsl:if test="$MASPBPriorUTI">
<MASPBPriorUTI>
<xsl:value-of select="$MASPBPriorUTI"/>
</MASPBPriorUTI>
</xsl:if>
<xsl:if test="$MASPBIntentToBlankPriorUTI">
<MASPBIntentToBlankPriorUTI>
<xsl:value-of select="$MASPBIntentToBlankPriorUTI"/>
</MASPBIntentToBlankPriorUTI>
</xsl:if>
<xsl:if test="$MASClientBlockUTINamespace">
<MASClientBlockUTINamespace>
<xsl:value-of select="$MASClientBlockUTINamespace"/>
</MASClientBlockUTINamespace>
</xsl:if>
<xsl:if test="$MASClientIntentToBlankBlockUTINamespace">
<MASClientIntentToBlankBlockUTINamespace>
<xsl:value-of select="$MASClientIntentToBlankBlockUTINamespace"/>
</MASClientIntentToBlankBlockUTINamespace>
</xsl:if>
<xsl:if test="$MASClientBlockUTI">
<MASClientBlockUTI>
<xsl:value-of select="$MASClientBlockUTI"/>
</MASClientBlockUTI>
</xsl:if>
<xsl:if test="$MASClientIntentToBlankBlockUTI">
<MASClientIntentToBlankBlockUTI>
<xsl:value-of select="$MASClientIntentToBlankBlockUTI"/>
</MASClientIntentToBlankBlockUTI>
</xsl:if>
<xsl:if test="$MASClientPriorUTINamespace">
<MASClientPriorUTINamespace>
<xsl:value-of select="$MASClientPriorUTINamespace"/>
</MASClientPriorUTINamespace>
</xsl:if>
<xsl:if test="$MASClientIntentToBlankPriorUTINamespace">
<MASClientIntentToBlankPriorUTINamespace>
<xsl:value-of select="$MASClientIntentToBlankPriorUTINamespace"/>
</MASClientIntentToBlankPriorUTINamespace>
</xsl:if>
<xsl:if test="$MASClientPriorUTI">
<MASClientPriorUTI>
<xsl:value-of select="$MASClientPriorUTI"/>
</MASClientPriorUTI>
</xsl:if>
<xsl:if test="$MASClientIntentToBlankPriorUTI">
<MASClientIntentToBlankPriorUTI>
<xsl:value-of select="$MASClientIntentToBlankPriorUTI"/>
</MASClientIntentToBlankPriorUTI>
</xsl:if>
</xsl:template>
<xsl:template name="lcl:MIData">
<xsl:param name="MIDataPresent" select="/.."/>
<xsl:param name="MIObligatoryReporting" select="/.."/>
<xsl:param name="MIReportingCounterparty" select="/.."/>
<xsl:param name="MIDestinationAPA" select="/.."/>
<xsl:param name="MIDestinationARM" select="/.."/>
<xsl:param name="MIUTINamespace" select="/.."/>
<xsl:param name="MIIntentToBlankUTINamespace" select="/.."/>
<xsl:param name="MIUTINamespacePrefix" select="/.."/>
<xsl:param name="MIUTI" select="/.."/>
<xsl:param name="MIIntentToBlankUTI" select="/.."/>
<xsl:param name="MIBlockUTINamespace" select="/.."/>
<xsl:param name="MIIntentToBlankBlockUTINamespace" select="/.."/>
<xsl:param name="MIBlockUTI" select="/.."/>
<xsl:param name="MIIntentToBlankBlockUTI" select="/.."/>
<xsl:param name="MIClearingException" select="/.."/>
<xsl:param name="MIPriorUTINamespace" select="/.."/>
<xsl:param name="MIIntentToBlankPriorUTINamespace" select="/.."/>
<xsl:param name="MIPriorUTI" select="/.."/>
<xsl:param name="MIIntentToBlankPriorUTI" select="/.."/>
<xsl:param name="MIToTV" select="/.."/>
<xsl:param name="TransactionReportable" select="/.."/>
<xsl:param name="TransparencyReportable" select="/.."/>
<xsl:param name="TransactionReporting" select="/.."/>
<xsl:param name="TransparencyReporting" select="/.."/>
<xsl:param name="MITransactionID" select="/.."/>
<xsl:param name="MIMIC" select="/.."/>
<xsl:param name="MIShortSale" select="/.."/>
<xsl:param name="MIOTCPostTradeIndicator" select="/.."/>
<xsl:param name="MIWaiver" select="/.."/>
<xsl:param name="MIShortSaleA" select="/.."/>
<xsl:param name="MIOTCPostTradeIndicatorA" select="/.."/>
<xsl:param name="MIWaiverA" select="/.."/>
<xsl:param name="MIShortSaleB" select="/.."/>
<xsl:param name="MIOTCPostTradeIndicatorB" select="/.."/>
<xsl:param name="MIWaiverB" select="/.."/>
<xsl:param name="MIPartyABlockUTINamespace" select="/.."/>
<xsl:param name="MIPartyAIntentToBlankBlockUTINamespace" select="/.."/>
<xsl:param name="MIPartyABlockUTI" select="/.."/>
<xsl:param name="MIPartyAIntentToBlankBlockUTI" select="/.."/>
<xsl:param name="MIPartyAClearingException" select="/.."/>
<xsl:param name="MIPartyAPriorUTINamespace" select="/.."/>
<xsl:param name="MIPartyAIntentToBlankPriorUTINamespace" select="/.."/>
<xsl:param name="MIPartyAPriorUTI" select="/.."/>
<xsl:param name="MIPartyAIntentToBlankPriorUTI" select="/.."/>
<xsl:param name="MIPartyBBlockUTINamespace" select="/.."/>
<xsl:param name="MIPartyBIntentToBlankBlockUTINamespace" select="/.."/>
<xsl:param name="MIPartyBBlockUTI" select="/.."/>
<xsl:param name="MIPartyBIntentToBlankBlockUTI" select="/.."/>
<xsl:param name="MIPartyBClearingException" select="/.."/>
<xsl:param name="MIPartyBPriorUTINamespace" select="/.."/>
<xsl:param name="MIPartyBIntentToBlankPriorUTINamespace" select="/.."/>
<xsl:param name="MIPartyBPriorUTI" select="/.."/>
<xsl:param name="MIPartyBIntentToBlankPriorUTI" select="/.."/>
<xsl:param name="MIPBClientDataPresent" select="/.."/>
<xsl:param name="MIPBClientRegulatorType" select="/.."/>
<xsl:param name="MIPBClientRoute1Destination" select="/.."/>
<xsl:param name="MIPBClientRoute1Intermediary" select="/.."/>
<xsl:param name="MIPBClientUTINamespace" select="/.."/>
<xsl:param name="MIPBClientIntentToBlankUTINamespace" select="/.."/>
<xsl:param name="MIPBClientUTINamespacePrefix" select="/.."/>
<xsl:param name="MIPBClientUTI" select="/.."/>
<xsl:param name="MIPBClientIntentToBlankUTI" select="/.."/>
<xsl:param name="MIPBClientBrokerBlockUTINamespace" select="/.."/>
<xsl:param name="MIPBClientBrokerIntentToBlankBlockUTINamespace" select="/.."/>
<xsl:param name="MIPBClientBrokerBlockUTI" select="/.."/>
<xsl:param name="MIPBClientBrokerIntentToBlankBlockUTI" select="/.."/>
<xsl:param name="MIPBClientBrokerPriorUTINamespace" select="/.."/>
<xsl:param name="MIPBClientBrokerIntentToBlankPriorUTINamespace" select="/.."/>
<xsl:param name="MIPBClientBrokerPriorUTI" select="/.."/>
<xsl:param name="MIPBClientBrokerIntentToBlankPriorUTI" select="/.."/>
<xsl:param name="MIPBBlockUTINamespace" select="/.."/>
<xsl:param name="MIPBIntentToBlankBlockUTINamespace" select="/.."/>
<xsl:param name="MIPBBlockUTI" select="/.."/>
<xsl:param name="MIPBIntentToBlankBlockUTI" select="/.."/>
<xsl:param name="MIPBPriorUTINamespace" select="/.."/>
<xsl:param name="MIPBIntentToBlankPriorUTINamespace" select="/.."/>
<xsl:param name="MIPBPriorUTI" select="/.."/>
<xsl:param name="MIPBIntentToBlankPriorUTI" select="/.."/>
<xsl:param name="MIClientBlockUTINamespace" select="/.."/>
<xsl:param name="MIClientIntentToBlankBlockUTINamespace" select="/.."/>
<xsl:param name="MIClientBlockUTI" select="/.."/>
<xsl:param name="MIClientIntentToBlankBlockUTI" select="/.."/>
<xsl:param name="MIClientPriorUTINamespace" select="/.."/>
<xsl:param name="MIClientIntentToBlankPriorUTINamespace" select="/.."/>
<xsl:param name="MIClientPriorUTI" select="/.."/>
<xsl:param name="MIClientIntentToBlankPriorUTI" select="/.."/>
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
<xsl:if test="$MIDestinationAPA">
<MIDestinationAPA>
<xsl:value-of select="$MIDestinationAPA"/>
</MIDestinationAPA>
</xsl:if>
<xsl:if test="$MIDestinationARM">
<MIDestinationARM>
<xsl:value-of select="$MIDestinationARM"/>
</MIDestinationARM>
</xsl:if>
<xsl:if test="$MIUTINamespace">
<MIUTINamespace>
<xsl:value-of select="$MIUTINamespace"/>
</MIUTINamespace>
</xsl:if>
<xsl:if test="$MIIntentToBlankUTINamespace">
<MIIntentToBlankUTINamespace>
<xsl:value-of select="$MIIntentToBlankUTINamespace"/>
</MIIntentToBlankUTINamespace>
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
<xsl:if test="$MIIntentToBlankUTI">
<MIIntentToBlankUTI>
<xsl:value-of select="$MIIntentToBlankUTI"/>
</MIIntentToBlankUTI>
</xsl:if>
<xsl:if test="$MIBlockUTINamespace">
<MIBlockUTINamespace>
<xsl:value-of select="$MIBlockUTINamespace"/>
</MIBlockUTINamespace>
</xsl:if>
<xsl:if test="$MIIntentToBlankBlockUTINamespace">
<MIIntentToBlankBlockUTINamespace>
<xsl:value-of select="$MIIntentToBlankBlockUTINamespace"/>
</MIIntentToBlankBlockUTINamespace>
</xsl:if>
<xsl:if test="$MIBlockUTI">
<MIBlockUTI>
<xsl:value-of select="$MIBlockUTI"/>
</MIBlockUTI>
</xsl:if>
<xsl:if test="$MIIntentToBlankBlockUTI">
<MIIntentToBlankBlockUTI>
<xsl:value-of select="$MIIntentToBlankBlockUTI"/>
</MIIntentToBlankBlockUTI>
</xsl:if>
<xsl:if test="$MIClearingException">
<MIClearingException>
<xsl:value-of select="$MIClearingException"/>
</MIClearingException>
</xsl:if>
<xsl:if test="$MIPriorUTINamespace">
<MIPriorUTINamespace>
<xsl:value-of select="$MIPriorUTINamespace"/>
</MIPriorUTINamespace>
</xsl:if>
<xsl:if test="$MIIntentToBlankPriorUTINamespace">
<MIIntentToBlankPriorUTINamespace>
<xsl:value-of select="$MIIntentToBlankPriorUTINamespace"/>
</MIIntentToBlankPriorUTINamespace>
</xsl:if>
<xsl:if test="$MIPriorUTI">
<MIPriorUTI>
<xsl:value-of select="$MIPriorUTI"/>
</MIPriorUTI>
</xsl:if>
<xsl:if test="$MIIntentToBlankPriorUTI">
<MIIntentToBlankPriorUTI>
<xsl:value-of select="$MIIntentToBlankPriorUTI"/>
</MIIntentToBlankPriorUTI>
</xsl:if>
<xsl:if test="$MIToTV">
<MIToTV>
<xsl:value-of select="$MIToTV"/>
</MIToTV>
</xsl:if>
<xsl:if test="$TransactionReportable">
<TransactionReportable>
<xsl:value-of select="$TransactionReportable"/>
</TransactionReportable>
</xsl:if>
<xsl:if test="$TransparencyReportable">
<TransparencyReportable>
<xsl:value-of select="$TransparencyReportable"/>
</TransparencyReportable>
</xsl:if>
<xsl:if test="$TransactionReporting">
<TransactionReporting>
<xsl:value-of select="$TransactionReporting"/>
</TransactionReporting>
</xsl:if>
<xsl:if test="$TransparencyReporting">
<TransparencyReporting>
<xsl:value-of select="$TransparencyReporting"/>
</TransparencyReporting>
</xsl:if>
<xsl:if test="$MITransactionID">
<MITransactionID>
<xsl:value-of select="$MITransactionID"/>
</MITransactionID>
</xsl:if>
<xsl:if test="$MIMIC">
<MIMIC>
<xsl:value-of select="$MIMIC"/>
</MIMIC>
</xsl:if>
<xsl:if test="$MIShortSale">
<MIShortSale>
<xsl:value-of select="$MIShortSale"/>
</MIShortSale>
</xsl:if>
<xsl:copy-of select="$MIOTCPostTradeIndicator"/>
<xsl:copy-of select="$MIWaiver"/>
<xsl:if test="$MIShortSaleA">
<MIShortSaleA>
<xsl:value-of select="$MIShortSaleA"/>
</MIShortSaleA>
</xsl:if>
<xsl:copy-of select="$MIOTCPostTradeIndicatorA"/>
<xsl:copy-of select="$MIWaiverA"/>
<xsl:if test="$MIShortSaleB">
<MIShortSaleB>
<xsl:value-of select="$MIShortSaleB"/>
</MIShortSaleB>
</xsl:if>
<xsl:copy-of select="$MIOTCPostTradeIndicatorB"/>
<xsl:copy-of select="$MIWaiverB"/>
<xsl:if test="$MIPartyABlockUTINamespace">
<MIPartyABlockUTINamespace>
<xsl:value-of select="$MIPartyABlockUTINamespace"/>
</MIPartyABlockUTINamespace>
</xsl:if>
<xsl:if test="$MIPartyAIntentToBlankBlockUTINamespace">
<MIPartyAIntentToBlankBlockUTINamespace>
<xsl:value-of select="$MIPartyAIntentToBlankBlockUTINamespace"/>
</MIPartyAIntentToBlankBlockUTINamespace>
</xsl:if>
<xsl:if test="$MIPartyABlockUTI">
<MIPartyABlockUTI>
<xsl:value-of select="$MIPartyABlockUTI"/>
</MIPartyABlockUTI>
</xsl:if>
<xsl:if test="$MIPartyAIntentToBlankBlockUTI">
<MIPartyAIntentToBlankBlockUTI>
<xsl:value-of select="$MIPartyAIntentToBlankBlockUTI"/>
</MIPartyAIntentToBlankBlockUTI>
</xsl:if>
<xsl:if test="$MIPartyAClearingException">
<MIPartyAClearingException>
<xsl:value-of select="$MIPartyAClearingException"/>
</MIPartyAClearingException>
</xsl:if>
<xsl:if test="$MIPartyAPriorUTINamespace">
<MIPartyAPriorUTINamespace>
<xsl:value-of select="$MIPartyAPriorUTINamespace"/>
</MIPartyAPriorUTINamespace>
</xsl:if>
<xsl:if test="$MIPartyAIntentToBlankPriorUTINamespace">
<MIPartyAIntentToBlankPriorUTINamespace>
<xsl:value-of select="$MIPartyAIntentToBlankPriorUTINamespace"/>
</MIPartyAIntentToBlankPriorUTINamespace>
</xsl:if>
<xsl:if test="$MIPartyAPriorUTI">
<MIPartyAPriorUTI>
<xsl:value-of select="$MIPartyAPriorUTI"/>
</MIPartyAPriorUTI>
</xsl:if>
<xsl:if test="$MIPartyAIntentToBlankPriorUTI">
<MIPartyAIntentToBlankPriorUTI>
<xsl:value-of select="$MIPartyAIntentToBlankPriorUTI"/>
</MIPartyAIntentToBlankPriorUTI>
</xsl:if>
<xsl:if test="$MIPartyBBlockUTINamespace">
<MIPartyBBlockUTINamespace>
<xsl:value-of select="$MIPartyBBlockUTINamespace"/>
</MIPartyBBlockUTINamespace>
</xsl:if>
<xsl:if test="$MIPartyBIntentToBlankBlockUTINamespace">
<MIPartyBIntentToBlankBlockUTINamespace>
<xsl:value-of select="$MIPartyBIntentToBlankBlockUTINamespace"/>
</MIPartyBIntentToBlankBlockUTINamespace>
</xsl:if>
<xsl:if test="$MIPartyBBlockUTI">
<MIPartyBBlockUTI>
<xsl:value-of select="$MIPartyBBlockUTI"/>
</MIPartyBBlockUTI>
</xsl:if>
<xsl:if test="$MIPartyBIntentToBlankBlockUTI">
<MIPartyBIntentToBlankBlockUTI>
<xsl:value-of select="$MIPartyBIntentToBlankBlockUTI"/>
</MIPartyBIntentToBlankBlockUTI>
</xsl:if>
<xsl:if test="$MIPartyBClearingException">
<MIPartyBClearingException>
<xsl:value-of select="$MIPartyBClearingException"/>
</MIPartyBClearingException>
</xsl:if>
<xsl:if test="$MIPartyBPriorUTINamespace">
<MIPartyBPriorUTINamespace>
<xsl:value-of select="$MIPartyBPriorUTINamespace"/>
</MIPartyBPriorUTINamespace>
</xsl:if>
<xsl:if test="$MIPartyBIntentToBlankPriorUTINamespace">
<MIPartyBIntentToBlankPriorUTINamespace>
<xsl:value-of select="$MIPartyBIntentToBlankPriorUTINamespace"/>
</MIPartyBIntentToBlankPriorUTINamespace>
</xsl:if>
<xsl:if test="$MIPartyBPriorUTI">
<MIPartyBPriorUTI>
<xsl:value-of select="$MIPartyBPriorUTI"/>
</MIPartyBPriorUTI>
</xsl:if>
<xsl:if test="$MIPartyBIntentToBlankPriorUTI">
<MIPartyBIntentToBlankPriorUTI>
<xsl:value-of select="$MIPartyBIntentToBlankPriorUTI"/>
</MIPartyBIntentToBlankPriorUTI>
</xsl:if>
<xsl:if test="$MIPBClientDataPresent">
<MIPBClientDataPresent>
<xsl:value-of select="$MIPBClientDataPresent"/>
</MIPBClientDataPresent>
</xsl:if>
<xsl:if test="$MIPBClientRegulatorType">
<MIPBClientRegulatorType>
<xsl:value-of select="$MIPBClientRegulatorType"/>
</MIPBClientRegulatorType>
</xsl:if>
<xsl:if test="$MIPBClientRoute1Destination">
<MIPBClientRoute1Destination>
<xsl:value-of select="$MIPBClientRoute1Destination"/>
</MIPBClientRoute1Destination>
</xsl:if>
<xsl:if test="$MIPBClientRoute1Intermediary">
<MIPBClientRoute1Intermediary>
<xsl:value-of select="$MIPBClientRoute1Intermediary"/>
</MIPBClientRoute1Intermediary>
</xsl:if>
<xsl:if test="$MIPBClientUTINamespace">
<MIPBClientUTINamespace>
<xsl:value-of select="$MIPBClientUTINamespace"/>
</MIPBClientUTINamespace>
</xsl:if>
<xsl:if test="$MIPBClientIntentToBlankUTINamespace">
<MIPBClientIntentToBlankUTINamespace>
<xsl:value-of select="$MIPBClientIntentToBlankUTINamespace"/>
</MIPBClientIntentToBlankUTINamespace>
</xsl:if>
<xsl:if test="$MIPBClientUTINamespacePrefix">
<MIPBClientUTINamespacePrefix>
<xsl:value-of select="$MIPBClientUTINamespacePrefix"/>
</MIPBClientUTINamespacePrefix>
</xsl:if>
<xsl:if test="$MIPBClientUTI">
<MIPBClientUTI>
<xsl:value-of select="$MIPBClientUTI"/>
</MIPBClientUTI>
</xsl:if>
<xsl:if test="$MIPBClientIntentToBlankUTI">
<MIPBClientIntentToBlankUTI>
<xsl:value-of select="$MIPBClientIntentToBlankUTI"/>
</MIPBClientIntentToBlankUTI>
</xsl:if>
<xsl:if test="$MIPBClientBrokerBlockUTINamespace">
<MIPBClientBrokerBlockUTINamespace>
<xsl:value-of select="$MIPBClientBrokerBlockUTINamespace"/>
</MIPBClientBrokerBlockUTINamespace>
</xsl:if>
<xsl:if test="$MIPBClientBrokerIntentToBlankBlockUTINamespace">
<MIPBClientBrokerIntentToBlankBlockUTINamespace>
<xsl:value-of select="$MIPBClientBrokerIntentToBlankBlockUTINamespace"/>
</MIPBClientBrokerIntentToBlankBlockUTINamespace>
</xsl:if>
<xsl:if test="$MIPBClientBrokerBlockUTI">
<MIPBClientBrokerBlockUTI>
<xsl:value-of select="$MIPBClientBrokerBlockUTI"/>
</MIPBClientBrokerBlockUTI>
</xsl:if>
<xsl:if test="$MIPBClientBrokerIntentToBlankBlockUTI">
<MIPBClientBrokerIntentToBlankBlockUTI>
<xsl:value-of select="$MIPBClientBrokerIntentToBlankBlockUTI"/>
</MIPBClientBrokerIntentToBlankBlockUTI>
</xsl:if>
<xsl:if test="$MIPBClientBrokerPriorUTINamespace">
<MIPBClientBrokerPriorUTINamespace>
<xsl:value-of select="$MIPBClientBrokerPriorUTINamespace"/>
</MIPBClientBrokerPriorUTINamespace>
</xsl:if>
<xsl:if test="$MIPBClientBrokerIntentToBlankPriorUTINamespace">
<MIPBClientBrokerIntentToBlankPriorUTINamespace>
<xsl:value-of select="$MIPBClientBrokerIntentToBlankPriorUTINamespace"/>
</MIPBClientBrokerIntentToBlankPriorUTINamespace>
</xsl:if>
<xsl:if test="$MIPBClientBrokerPriorUTI">
<MIPBClientBrokerPriorUTI>
<xsl:value-of select="$MIPBClientBrokerPriorUTI"/>
</MIPBClientBrokerPriorUTI>
</xsl:if>
<xsl:if test="$MIPBClientBrokerIntentToBlankPriorUTI">
<MIPBClientBrokerIntentToBlankPriorUTI>
<xsl:value-of select="$MIPBClientBrokerIntentToBlankPriorUTI"/>
</MIPBClientBrokerIntentToBlankPriorUTI>
</xsl:if>
<xsl:if test="$MIPBBlockUTINamespace">
<MIPBBlockUTINamespace>
<xsl:value-of select="$MIPBBlockUTINamespace"/>
</MIPBBlockUTINamespace>
</xsl:if>
<xsl:if test="$MIPBIntentToBlankBlockUTINamespace">
<MIPBIntentToBlankBlockUTINamespace>
<xsl:value-of select="$MIPBIntentToBlankBlockUTINamespace"/>
</MIPBIntentToBlankBlockUTINamespace>
</xsl:if>
<xsl:if test="$MIPBBlockUTI">
<MIPBBlockUTI>
<xsl:value-of select="$MIPBBlockUTI"/>
</MIPBBlockUTI>
</xsl:if>
<xsl:if test="$MIPBIntentToBlankBlockUTI">
<MIPBIntentToBlankBlockUTI>
<xsl:value-of select="$MIPBIntentToBlankBlockUTI"/>
</MIPBIntentToBlankBlockUTI>
</xsl:if>
<xsl:if test="$MIPBPriorUTINamespace">
<MIPBPriorUTINamespace>
<xsl:value-of select="$MIPBPriorUTINamespace"/>
</MIPBPriorUTINamespace>
</xsl:if>
<xsl:if test="$MIPBIntentToBlankPriorUTINamespace">
<MIPBIntentToBlankPriorUTINamespace>
<xsl:value-of select="$MIPBIntentToBlankPriorUTINamespace"/>
</MIPBIntentToBlankPriorUTINamespace>
</xsl:if>
<xsl:if test="$MIPBPriorUTI">
<MIPBPriorUTI>
<xsl:value-of select="$MIPBPriorUTI"/>
</MIPBPriorUTI>
</xsl:if>
<xsl:if test="$MIPBIntentToBlankPriorUTI">
<MIPBIntentToBlankPriorUTI>
<xsl:value-of select="$MIPBIntentToBlankPriorUTI"/>
</MIPBIntentToBlankPriorUTI>
</xsl:if>
<xsl:if test="$MIClientBlockUTINamespace">
<MIClientBlockUTINamespace>
<xsl:value-of select="$MIClientBlockUTINamespace"/>
</MIClientBlockUTINamespace>
</xsl:if>
<xsl:if test="$MIClientIntentToBlankBlockUTINamespace">
<MIClientIntentToBlankBlockUTINamespace>
<xsl:value-of select="$MIClientIntentToBlankBlockUTINamespace"/>
</MIClientIntentToBlankBlockUTINamespace>
</xsl:if>
<xsl:if test="$MIClientBlockUTI">
<MIClientBlockUTI>
<xsl:value-of select="$MIClientBlockUTI"/>
</MIClientBlockUTI>
</xsl:if>
<xsl:if test="$MIClientIntentToBlankBlockUTI">
<MIClientIntentToBlankBlockUTI>
<xsl:value-of select="$MIClientIntentToBlankBlockUTI"/>
</MIClientIntentToBlankBlockUTI>
</xsl:if>
<xsl:if test="$MIClientPriorUTINamespace">
<MIClientPriorUTINamespace>
<xsl:value-of select="$MIClientPriorUTINamespace"/>
</MIClientPriorUTINamespace>
</xsl:if>
<xsl:if test="$MIClientIntentToBlankPriorUTINamespace">
<MIClientIntentToBlankPriorUTINamespace>
<xsl:value-of select="$MIClientIntentToBlankPriorUTINamespace"/>
</MIClientIntentToBlankPriorUTINamespace>
</xsl:if>
<xsl:if test="$MIClientPriorUTI">
<MIClientPriorUTI>
<xsl:value-of select="$MIClientPriorUTI"/>
</MIClientPriorUTI>
</xsl:if>
<xsl:if test="$MIClientIntentToBlankPriorUTI">
<MIClientIntentToBlankPriorUTI>
<xsl:value-of select="$MIClientIntentToBlankPriorUTI"/>
</MIClientIntentToBlankPriorUTI>
</xsl:if>
</xsl:template>
<xsl:template name="lcl:MIOTCPostTradeIndicator">
<xsl:param name="Indicator" select="/.."/>
<MIOTCPostTradeIndicator>
<xsl:for-each select="$Indicator">
<Indicator>
<xsl:value-of select="."/>
</Indicator>
</xsl:for-each>
</MIOTCPostTradeIndicator>
</xsl:template>
<xsl:template name="lcl:MIWaiver">
<xsl:param name="Waiver" select="/.."/>
<MIWaiver>
<xsl:for-each select="$Waiver">
<Waiver>
<xsl:value-of select="."/>
</Waiver>
</xsl:for-each>
</MIWaiver>
</xsl:template>
<xsl:template name="lcl:MIOTCPostTradeIndicatorA">
<xsl:param name="Indicator" select="/.."/>
<MIOTCPostTradeIndicatorA>
<xsl:for-each select="$Indicator">
<Indicator>
<xsl:value-of select="."/>
</Indicator>
</xsl:for-each>
</MIOTCPostTradeIndicatorA>
</xsl:template>
<xsl:template name="lcl:MIWaiverA">
<xsl:param name="Waiver" select="/.."/>
<MIWaiverA>
<xsl:for-each select="$Waiver">
<Waiver>
<xsl:value-of select="."/>
</Waiver>
</xsl:for-each>
</MIWaiverA>
</xsl:template>
<xsl:template name="lcl:MIOTCPostTradeIndicatorB">
<xsl:param name="Indicator" select="/.."/>
<MIOTCPostTradeIndicatorB>
<xsl:for-each select="$Indicator">
<Indicator>
<xsl:value-of select="."/>
</Indicator>
</xsl:for-each>
</MIOTCPostTradeIndicatorB>
</xsl:template>
<xsl:template name="lcl:MIWaiverB">
<xsl:param name="Waiver" select="/.."/>
<MIWaiverB>
<xsl:for-each select="$Waiver">
<Waiver>
<xsl:value-of select="."/>
</Waiver>
</xsl:for-each>
</MIWaiverB>
</xsl:template>
<xsl:template name="lcl:Trade.ExecTraderLocationA">
<xsl:param name="Country" select="/.."/>
<ExecTraderLocationA>
<xsl:for-each select="$Country">
<Country>
<xsl:value-of select="."/>
</Country>
</xsl:for-each>
</ExecTraderLocationA>
</xsl:template>
<xsl:template name="lcl:Trade.ExecTraderLocationB">
<xsl:param name="Country" select="/.."/>
<ExecTraderLocationB>
<xsl:for-each select="$Country">
<Country>
<xsl:value-of select="."/>
</Country>
</xsl:for-each>
</ExecTraderLocationB>
</xsl:template>
<xsl:template name="lcl:Trade.SalesTraderLocationA">
<xsl:param name="Country" select="/.."/>
<SalesTraderLocationA>
<xsl:for-each select="$Country">
<Country>
<xsl:value-of select="."/>
</Country>
</xsl:for-each>
</SalesTraderLocationA>
</xsl:template>
<xsl:template name="lcl:Trade.SalesTraderLocationB">
<xsl:param name="Country" select="/.."/>
<SalesTraderLocationB>
<xsl:for-each select="$Country">
<Country>
<xsl:value-of select="."/>
</Country>
</xsl:for-each>
</SalesTraderLocationB>
</xsl:template>
<xsl:template name="lcl:Trade.DeskLocationA">
<xsl:param name="Country" select="/.."/>
<DeskLocationA>
<xsl:for-each select="$Country">
<Country>
<xsl:value-of select="."/>
</Country>
</xsl:for-each>
</DeskLocationA>
</xsl:template>
<xsl:template name="lcl:Trade.DeskLocationB">
<xsl:param name="Country" select="/.."/>
<DeskLocationB>
<xsl:for-each select="$Country">
<Country>
<xsl:value-of select="."/>
</Country>
</xsl:for-each>
</DeskLocationB>
</xsl:template>
<xsl:template name="lcl:Trade.InvestFirmLocA">
<xsl:param name="Country" select="/.."/>
<InvestFirmLocA>
<xsl:for-each select="$Country">
<Country>
<xsl:value-of select="."/>
</Country>
</xsl:for-each>
</InvestFirmLocA>
</xsl:template>
<xsl:template name="lcl:Trade.InvestFirmLocB">
<xsl:param name="Country" select="/.."/>
<InvestFirmLocB>
<xsl:for-each select="$Country">
<Country>
<xsl:value-of select="."/>
</Country>
</xsl:for-each>
</InvestFirmLocB>
</xsl:template>
<xsl:template name="lcl:Trade.UniqueTradeIdentifier">
<xsl:param name="Party" select="/.."/>
<xsl:param name="Jurisdiction" select="/.."/>
<xsl:param name="Context" select="/.."/>
<xsl:param name="RelationshipType" select="/.."/>
<xsl:param name="UTINamespace" select="/.."/>
<xsl:param name="UTI" select="/.."/>
<xsl:param name="UTINamespacePrefix" select="/.."/>
<xsl:param name="IntentToBlankUTINamespace" select="/.."/>
<xsl:param name="IntentToBlankUTI" select="/.."/>
<UniqueTradeIdentifier>
<Party>
<xsl:value-of select="$Party"/>
</Party>
<Jurisdiction>
<xsl:value-of select="$Jurisdiction"/>
</Jurisdiction>
<Context>
<xsl:value-of select="$Context"/>
</Context>
<RelationshipType>
<xsl:value-of select="$RelationshipType"/>
</RelationshipType>
<UTINamespace>
<xsl:value-of select="$UTINamespace"/>
</UTINamespace>
<UTI>
<xsl:value-of select="$UTI"/>
</UTI>
<UTINamespacePrefix>
<xsl:value-of select="$UTINamespacePrefix"/>
</UTINamespacePrefix>
<IntentToBlankUTINamespace>
<xsl:value-of select="$IntentToBlankUTINamespace"/>
</IntentToBlankUTINamespace>
<IntentToBlankUTI>
<xsl:value-of select="$IntentToBlankUTI"/>
</IntentToBlankUTI>
</UniqueTradeIdentifier>
</xsl:template>
<xsl:template name="lcl:Trade.GenProdUnderlyer">
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
<xsl:template name="lcl:Trade.GenProdNotional">
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
<xsl:template name="lcl:Trade.DayCountFraction">
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
<xsl:template name="lcl:Trade.PartyAOrderDetails">
<xsl:param name="TypeOfOrder" select="/.."/>
<xsl:param name="TotalConsideration" select="/.."/>
<xsl:param name="RateOfExchange" select="/.."/>
<xsl:param name="ClientCounterparty" select="/.."/>
<xsl:param name="TotalCommissionAndExpenses" select="/.."/>
<xsl:param name="ClientSettlementResponsibilities" select="/.."/>
<xsl:param name="id" select="/.."/>
<PartyAOrderDetails>
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
</PartyAOrderDetails>
</xsl:template>
<xsl:template name="lcl:Trade.PartyBOrderDetails">
<xsl:param name="TypeOfOrder" select="/.."/>
<xsl:param name="TotalConsideration" select="/.."/>
<xsl:param name="RateOfExchange" select="/.."/>
<xsl:param name="ClientCounterparty" select="/.."/>
<xsl:param name="TotalCommissionAndExpenses" select="/.."/>
<xsl:param name="ClientSettlementResponsibilities" select="/.."/>
<xsl:param name="id" select="/.."/>
<PartyBOrderDetails>
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
</PartyBOrderDetails>
</xsl:template>
<xsl:template name="lcl:Trade.PartyAPackageDetails">
<xsl:param name="PackageId" select="/.."/>
<xsl:param name="PackageSize" select="/.."/>
<xsl:param name="RegReportAsPackage" select="/.."/>
<xsl:param name="PackagePriceType" select="/.."/>
<xsl:param name="PackagePriceValue" select="/.."/>
<xsl:param name="PackagePriceNotation" select="/.."/>
<xsl:param name="PackagePriceCurrency" select="/.."/>
<xsl:param name="id" select="/.."/>
<PartyAPackageDetails>
<xsl:if test="$id">
<xsl:attribute name="id">
<xsl:value-of select="$id"/>
</xsl:attribute>
</xsl:if>
<PackageId>
<xsl:value-of select="$PackageId"/>
</PackageId>
<PackageSize>
<xsl:value-of select="$PackageSize"/>
</PackageSize>
<RegReportAsPackage>
<xsl:value-of select="$RegReportAsPackage"/>
</RegReportAsPackage>
<PackagePriceType>
<xsl:value-of select="$PackagePriceType"/>
</PackagePriceType>
<PackagePriceValue>
<xsl:value-of select="$PackagePriceValue"/>
</PackagePriceValue>
<PackagePriceNotation>
<xsl:value-of select="$PackagePriceNotation"/>
</PackagePriceNotation>
<PackagePriceCurrency>
<xsl:value-of select="$PackagePriceCurrency"/>
</PackagePriceCurrency>
</PartyAPackageDetails>
</xsl:template>
<xsl:template name="lcl:Trade.PartyBPackageDetails">
<xsl:param name="PackageId" select="/.."/>
<xsl:param name="PackageSize" select="/.."/>
<xsl:param name="RegReportAsPackage" select="/.."/>
<xsl:param name="PackagePriceType" select="/.."/>
<xsl:param name="PackagePriceValue" select="/.."/>
<xsl:param name="PackagePriceNotation" select="/.."/>
<xsl:param name="PackagePriceCurrency" select="/.."/>
<xsl:param name="id" select="/.."/>
<PartyBPackageDetails>
<xsl:if test="$id">
<xsl:attribute name="id">
<xsl:value-of select="$id"/>
</xsl:attribute>
</xsl:if>
<PackageId>
<xsl:value-of select="$PackageId"/>
</PackageId>
<PackageSize>
<xsl:value-of select="$PackageSize"/>
</PackageSize>
<RegReportAsPackage>
<xsl:value-of select="$RegReportAsPackage"/>
</RegReportAsPackage>
<PackagePriceType>
<xsl:value-of select="$PackagePriceType"/>
</PackagePriceType>
<PackagePriceValue>
<xsl:value-of select="$PackagePriceValue"/>
</PackagePriceValue>
<PackagePriceNotation>
<xsl:value-of select="$PackagePriceNotation"/>
</PackagePriceNotation>
<PackagePriceCurrency>
<xsl:value-of select="$PackagePriceCurrency"/>
</PackagePriceCurrency>
</PartyBPackageDetails>
</xsl:template>
<xsl:template name="lcl:Trade.PartyClearingDetails">
<xsl:param name="Party" select="/.."/>
<xsl:param name="ClearingStatus" select="/.."/>
<xsl:param name="ClearingHouseTradeID" select="/.."/>
<xsl:param name="ClearingHouseUpfrontFeeSettlementDate" select="/.."/>
<xsl:param name="ClearingHousePreferredISIN" select="/.."/>
<xsl:param name="ClearedTimestamp" select="/.."/>
<xsl:param name="ClearedUSINamespace" select="/.."/>
<xsl:param name="ClearedUSI" select="/.."/>
<xsl:param name="ClearedUTINamespace" select="/.."/>
<xsl:param name="ClearedUTI" select="/.."/>
<PartyClearingDetails>
<Party>
<xsl:value-of select="$Party"/>
</Party>
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
</PartyClearingDetails>
</xsl:template>
<xsl:template name="lcl:Trade.EswDividendValuationCustomDatesInterim">
<xsl:param name="EswDividendValuationCustomDateInterim" select="/.."/>
<EswDividendValuationCustomDatesInterim>
<xsl:for-each select="$EswDividendValuationCustomDateInterim">
<EswDividendValuationCustomDateInterim>
<xsl:value-of select="."/>
</EswDividendValuationCustomDateInterim>
</xsl:for-each>
</EswDividendValuationCustomDatesInterim>
</xsl:template>
<xsl:template name="lcl:Trade.EswInterestSpreadOverIndexStep">
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
<xsl:template name="lcl:Trade.EswValuationDates">
<xsl:param name="EswUnadjustedDate" select="/.."/>
<EswValuationDates>
<xsl:for-each select="$EswUnadjustedDate">
<EswUnadjustedDate>
<xsl:value-of select="."/>
</EswUnadjustedDate>
</xsl:for-each>
</EswValuationDates>
</xsl:template>
<xsl:template name="lcl:Trade.EswInterestLegPaymentDates">
<xsl:param name="EswUnadjustedDate" select="/.."/>
<EswInterestLegPaymentDates>
<xsl:for-each select="$EswUnadjustedDate">
<EswUnadjustedDate>
<xsl:value-of select="."/>
</EswUnadjustedDate>
</xsl:for-each>
</EswInterestLegPaymentDates>
</xsl:template>
<xsl:template name="lcl:Trade.EswEquityLegPaymentDates">
<xsl:param name="EswUnadjustedDate" select="/.."/>
<EswEquityLegPaymentDates>
<xsl:for-each select="$EswUnadjustedDate">
<EswUnadjustedDate>
<xsl:value-of select="."/>
</EswUnadjustedDate>
</xsl:for-each>
</EswEquityLegPaymentDates>
</xsl:template>
<xsl:template name="lcl:Trade.EswCompoundingDates">
<xsl:param name="EswUnadjustedDate" select="/.."/>
<EswCompoundingDates>
<xsl:for-each select="$EswUnadjustedDate">
<EswUnadjustedDate>
<xsl:value-of select="."/>
</EswUnadjustedDate>
</xsl:for-each>
</EswCompoundingDates>
</xsl:template>
<xsl:template name="lcl:Trade.EswDividendComponent">
<xsl:param name="DividendPercentageComponentShare" select="/.."/>
<xsl:param name="DividendPercentageComponent" select="/.."/>
<EswDividendComponent>
<xsl:if test="$DividendPercentageComponentShare">
<DividendPercentageComponentShare>
<xsl:value-of select="$DividendPercentageComponentShare"/>
</DividendPercentageComponentShare>
</xsl:if>
<xsl:if test="$DividendPercentageComponent">
<DividendPercentageComponent>
<xsl:value-of select="$DividendPercentageComponent"/>
</DividendPercentageComponent>
</xsl:if>
</EswDividendComponent>
</xsl:template>
<xsl:template name="lcl:Trade.EswEarlyTerminationElectingParty">
<xsl:param name="PartyOccurrence" select="/.."/>
<EswEarlyTerminationElectingParty>
<xsl:for-each select="$PartyOccurrence">
<PartyOccurrence>
<xsl:value-of select="."/>
</PartyOccurrence>
</xsl:for-each>
</EswEarlyTerminationElectingParty>
</xsl:template>
<xsl:template name="lcl:Trade.HedgingParty">
<xsl:param name="HedgingPartyOccurrence" select="/.."/>
<HedgingParty>
<xsl:for-each select="$HedgingPartyOccurrence">
<HedgingPartyOccurrence>
<xsl:value-of select="."/>
</HedgingPartyOccurrence>
</xsl:for-each>
</HedgingParty>
</xsl:template>
<xsl:template name="lcl:Trade.DeterminingParty">
<xsl:param name="DeterminingPartyOccurrence" select="/.."/>
<DeterminingParty>
<xsl:for-each select="$DeterminingPartyOccurrence">
<DeterminingPartyOccurrence>
<xsl:value-of select="."/>
</DeterminingPartyOccurrence>
</xsl:for-each>
</DeterminingParty>
</xsl:template>
<xsl:template name="lcl:Trade.EswChinaConnect">
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
</xsl:stylesheet>
