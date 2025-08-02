<xsl:stylesheet
version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:swml="http://www.markitserv.com/swml-5-11"
xmlns:fpml="http://www.fpml.org/FpML-5/confirmation"
xmlns:tx="http://www.markitserv.com/detail/SWDMLTrade.xsl"
exclude-result-prefixes="fpml">
<xsl:import href="SWDMLTrade.xsl"/>
<xsl:output method="xml" indent="yes"/>
<xsl:variable name="SWDML"                          select="/swml:SWDML"/>
<xsl:variable name="version"                        select="$SWDML/@version"/>
<xsl:variable name="swLongFormTrade"                select="$SWDML/swml:swLongFormTrade"/>
<xsl:variable name="swStructuredTradeDetails"       select="$swLongFormTrade/swml:swStructuredTradeDetails"/>
<xsl:variable name="dataDocument"                   select="$swStructuredTradeDetails/fpml:dataDocument"/>
<xsl:variable name="trade"                          select="$dataDocument/fpml:trade"/>
<xsl:variable name="repo"                           select="$trade/fpml:repo"/>
<xsl:variable name="swExtendedTradeDetails"         select="$swStructuredTradeDetails/swml:swExtendedTradeDetails"/>
<xsl:variable name="swTradeEventReportingDetails"   select="$SWDML/swml:swTradeEventReportingDetails"/>
<xsl:variable name="novation"                       select="$swLongFormTrade/swml:novation"/>
<xsl:variable name="ssi_partyA"                     select="$swExtendedTradeDetails/swml:swTradeHeader/swml:swPartyTradeInformation/swml:swPartyReference/@href='partyA'"/>
<xsl:variable name="ssi_partyB"                     select="$swExtendedTradeDetails/swml:swTradeHeader/swml:swPartyTradeInformation/swml:swPartyReference/@href='partyB'"/>
<xsl:variable name="ssi_2nd">
<xsl:value-of select="$swExtendedTradeDetails/swml:swTradeHeader/swml:swPartyTradeInformation[2]/swml:swPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="TradeOriginator">
<xsl:value-of select="$swLongFormTrade/swml:swOriginatorPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="partyA">
<xsl:value-of select="$swLongFormTrade/swml:swOriginatorPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="partyB">
<xsl:value-of select="$dataDocument/fpml:party[@id!=$partyA]/@id"/>
</xsl:variable>
<xsl:variable name="partyC">partyC</xsl:variable>
<xsl:variable name="partyTripartyAgent">partyTripartyAgent</xsl:variable>
<xsl:variable name="productType">
<xsl:if test="$swLongFormTrade">
<xsl:value-of select="string($swStructuredTradeDetails/swml:swProductType)"/>
</xsl:if>
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
<SWDMLTrade version="5-11">
<SWDMLVersion>
<xsl:value-of select="$version"/>
</SWDMLVersion>
<TradeOriginator>
<xsl:value-of select="$swLongFormTrade/swml:swOriginatorPartyReference/@href"/>
</TradeOriginator>
<ReplacementTradeId>
<xsl:value-of select="$swLongFormTrade/swml:swReplacementTradeId/swml:swTradeId"/>
</ReplacementTradeId>
<ReplacementTradeIdType>
<xsl:value-of select="$swLongFormTrade/swml:swReplacementTradeId/swml:swTradeIdType"/>
</ReplacementTradeIdType>
<ReplacementReason>
<xsl:value-of select="$swLongFormTrade/swml:swReplacementTradeId/swml:swReplacementReason"/>
</ReplacementReason>
<ShortFormInput>
<xsl:choose>
<xsl:when test="$swLongFormTrade">false</xsl:when>
<xsl:otherwise>???</xsl:otherwise>
</xsl:choose>
</ShortFormInput>
<ProductType>
<xsl:value-of select="$productType"/>
</ProductType>
<ParticipantSupplement/>
<ConditionPrecedentBondId/>
<ConditionPrecedentBondMaturity/>
<AllocatedTrade>
<xsl:value-of select="string(boolean($swLongFormTrade//swml:swAllocations))"/>
</AllocatedTrade>
<xsl:if test="$swLongFormTrade//swml:swAllocations">
<xsl:call-template name="swml:swAllocations"/>
</xsl:if>
<PrimeBrokerTrade/>
<ReversePrimeBrokerLegalEntities/>
<PartyAId>
<xsl:value-of select="$dataDocument/fpml:party[@id=$partyA]/fpml:partyId"/>
</PartyAId>
<PartyAIdType>
<xsl:value-of select="$dataDocument/fpml:party[@id=$partyA]/fpml:partyId/@partyIdScheme"/>
</PartyAIdType>
<PartyBId>
<xsl:value-of select="$dataDocument/fpml:party[@id=$partyB]/fpml:partyId"/>
</PartyBId>
<PartyBIdType>
<xsl:value-of select="$dataDocument/fpml:party[@id=$partyB]/fpml:partyId/@partyIdScheme"/>
</PartyBIdType>
<PartyCId>
<xsl:value-of select="$dataDocument/fpml:party[@id=$partyC]/fpml:partyId"/>
</PartyCId>
<PartyCIdType>
<xsl:value-of select="$dataDocument/fpml:party[@id=$partyC]/fpml:partyId/@partyIdScheme"/>
</PartyCIdType>
<PartyDId/>
<PartyDIdType/>
<PartyGId/>
<PartyGIdType/>
<PartyTripartyAgentId>
<xsl:value-of select="$dataDocument/fpml:party[@id=$partyTripartyAgent]/fpml:partyId"/>
</PartyTripartyAgentId>
<PartyTripartyAgentIdType>
<xsl:value-of select="$dataDocument/fpml:party[@id=$partyTripartyAgent]/fpml:partyId/@partyIdScheme"/>
</PartyTripartyAgentIdType>
<DeliveryByValue>
<xsl:value-of select="$repo/fpml:triParty/fpml:deliveryByValue"/>
</DeliveryByValue>
<Interoperable/>
<ExternalInteropabilityId/>
<InteropNettingString/>
<DirectionA>
<xsl:variable name="buyer" select="string($repo/fpml:nearLeg/fpml:buyerPartyReference/@href)"/>
<xsl:choose>
<xsl:when test="string($buyer)=string($partyA)">Buy</xsl:when>
<xsl:otherwise>Sell</xsl:otherwise>
</xsl:choose>
</DirectionA>
<xsl:if test="$trade//fpml:tradeHeader/fpml:partyTradeInformation">
<Agent>
<xsl:apply-templates select="$trade//fpml:tradeHeader/fpml:partyTradeInformation/fpml:partyReference"/>
</Agent>
<PrincipalCode>
<xsl:apply-templates select="$trade//fpml:tradeHeader/fpml:partyTradeInformation/fpml:relatedParty/fpml:partyReference"/>
</PrincipalCode>
</xsl:if>
<TradeDate>
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="$trade//fpml:tradeHeader/fpml:tradeDate"/>
</xsl:call-template>
</TradeDate>
<StartDateTenor/>
<EndDateTenor/>
<StartDateDay/>
<Tenor/>
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
<FixedRate_2/>
<initialPoints/>
<quotationStyle/>
<RecoveryRate/>
<FixedSettlement/>
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
<IndexTenor1_2/>
<LinearInterpolation/>
<LinearInterpolation_2/>
<IndexTenor2/>
<IndexTenor2_2/>
<InitialInterpolationIndex/>
<InitialInterpolationIndex_2/>
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
<HasBreak/>
<BreakFromSwap/>
<BreakOverride/>
<BreakCalculationMethod/>
<BreakFirstDateTenor/>
<BreakFrequency/>
<BreakOptionA/>
<BreakDate/>
<BreakExpirationDate/>
<BreakEarliestTime/>
<BreakLatestTime/>
<BreakCalcAgentA/>
<BreakExpiryTime/>
<BreakCashSettleCcy/>
<BreakLocation/>
<BreakHolidayCentre/>
<BreakSettlement/>
<BreakValuationDate/>
<BreakValuationTime/>
<BreakSource/>
<BreakReferenceBanks/>
<BreakQuotation/>
<BreakPrescribedDocAdj/>
<ExchangeUnderlying/>
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
<MasterAgreement>
<xsl:value-of select="$trade/fpml:documentation/fpml:masterAgreement/fpml:masterAgreementType"/>
</MasterAgreement>
<ManualConfirm>
<xsl:value-of select="$swExtendedTradeDetails/swml:swTradeHeader/swml:swManualConfirmationRequired"/>
</ManualConfirm>
<PlaceOfSettlementA>
<xsl:choose>
<xsl:when test="($TradeOriginator='partyB' and (not($ssi_partyA) and $ssi_partyB)) or ($ssi_partyA and not($ssi_partyB))">
<xsl:value-of select="$swExtendedTradeDetails/swml:swTradeHeader/swml:swPartyTradeInformation/swml:swSettlementInformation/swml:swPlaceOfSettlement/swml:swPartyId"/>
</xsl:when>
<xsl:when test="$ssi_partyA and $ssi_partyB">
<xsl:if test="($TradeOriginator='partyA' and $ssi_2nd='partyB') or ($TradeOriginator='partyB' and $ssi_2nd='partyA')">
<xsl:value-of select="$swExtendedTradeDetails/swml:swTradeHeader/swml:swPartyTradeInformation[1]/swml:swSettlementInformation/swml:swPlaceOfSettlement/swml:swPartyId"/>
</xsl:if>
<xsl:if test="($TradeOriginator='partyA' and $ssi_2nd='partyA') or ($TradeOriginator='partyB' and $ssi_2nd='partyB')">
<xsl:value-of select="$swExtendedTradeDetails/swml:swTradeHeader/swml:swPartyTradeInformation[2]/swml:swSettlementInformation/swml:swPlaceOfSettlement/swml:swPartyId"/>
</xsl:if>
</xsl:when>
</xsl:choose>
</PlaceOfSettlementA>
<PlaceOfSettlementB>
<xsl:choose>
<xsl:when test="($TradeOriginator='partyA' and (not($ssi_partyA) and $ssi_partyB)) or ($TradeOriginator='partyB' and ($ssi_partyA and not($ssi_partyB)))">
<xsl:value-of select="$swExtendedTradeDetails/swml:swTradeHeader/swml:swPartyTradeInformation/swml:swSettlementInformation/swml:swPlaceOfSettlement/swml:swPartyId"/>
</xsl:when>
<xsl:when test="$ssi_partyA and $ssi_partyB">
<xsl:if test="($TradeOriginator='partyA' and $ssi_2nd='partyB') or ($TradeOriginator='partyB' and $ssi_2nd='partyA')">
<xsl:value-of select="$swExtendedTradeDetails/swml:swTradeHeader/swml:swPartyTradeInformation[2]/swml:swSettlementInformation/swml:swPlaceOfSettlement/swml:swPartyId"/>
</xsl:if>
<xsl:if test="($TradeOriginator='partyA' and $ssi_2nd='partyA') or ($TradeOriginator='partyB' and $ssi_2nd='partyB')">
<xsl:value-of select="$swExtendedTradeDetails/swml:swTradeHeader/swml:swPartyTradeInformation[1]/swml:swSettlementInformation/swml:swPlaceOfSettlement/swml:swPartyId"/>
</xsl:if>
</xsl:when>
</xsl:choose>
</PlaceOfSettlementB>
<SettlementAgentA>
<xsl:choose>
<xsl:when test="($TradeOriginator='partyB' and (not($ssi_partyA) and $ssi_partyB)) or ($TradeOriginator='partyA' and ($ssi_partyA and not($ssi_partyB)))">
<xsl:value-of select="$swExtendedTradeDetails/swml:swTradeHeader/swml:swPartyTradeInformation/swml:swSettlementInformation/swml:swSettlementAgent/swml:swPartyId"/>
</xsl:when>
<xsl:when test="$ssi_partyA and $ssi_partyB">
<xsl:if test="($TradeOriginator='partyA' and $ssi_2nd='partyB') or ($TradeOriginator='partyB' and $ssi_2nd='partyA')">
<xsl:value-of select="$swExtendedTradeDetails/swml:swTradeHeader/swml:swPartyTradeInformation[1]/swml:swSettlementInformation/swml:swSettlementAgent/swml:swPartyId"/>
</xsl:if>
<xsl:if test="($TradeOriginator='partyA' and $ssi_2nd='partyA') or ($TradeOriginator='partyB' and $ssi_2nd='partyB')">
<xsl:value-of select="$swExtendedTradeDetails/swml:swTradeHeader/swml:swPartyTradeInformation[2]/swml:swSettlementInformation/swml:swSettlementAgent/swml:swPartyId"/>
</xsl:if>
</xsl:when>
</xsl:choose>
</SettlementAgentA>
<SettlementAgentB>
<xsl:choose>
<xsl:when test="($TradeOriginator='partyA' and (not($ssi_partyA) and $ssi_partyB)) or ($TradeOriginator='partyB' and ($ssi_partyA and not($ssi_partyB)))">
<xsl:value-of select="$swExtendedTradeDetails/swml:swTradeHeader/swml:swPartyTradeInformation/swml:swSettlementInformation/swml:swSettlementAgent/swml:swPartyId"/>
</xsl:when>
<xsl:when test="$ssi_partyA and $ssi_partyB">
<xsl:if test="($TradeOriginator='partyA' and $ssi_2nd='partyB') or ($TradeOriginator='partyB' and $ssi_2nd='partyA')">
<xsl:value-of select="$swExtendedTradeDetails/swml:swTradeHeader/swml:swPartyTradeInformation[2]/swml:swSettlementInformation/swml:swSettlementAgent/swml:swPartyId"/>
</xsl:if>
<xsl:if test="($TradeOriginator='partyA' and $ssi_2nd='partyA') or ($TradeOriginator='partyB' and $ssi_2nd='partyB')">
<xsl:value-of select="$swExtendedTradeDetails/swml:swTradeHeader/swml:swPartyTradeInformation[1]/swml:swSettlementInformation/swml:swSettlementAgent/swml:swPartyId"/>
</xsl:if>
</xsl:when>
</xsl:choose>
</SettlementAgentB>
<SettlementAgentSafeKeepA>
<xsl:choose>
<xsl:when test="($TradeOriginator='partyB' and (not($ssi_partyA) and $ssi_partyB)) or ($ssi_partyA and not($ssi_partyB))">
<xsl:value-of select="$swExtendedTradeDetails/swml:swTradeHeader/swml:swPartyTradeInformation/swml:swSettlementInformation/swml:swSettlementAgent/swml:swSafekeepingAccountId"/>
</xsl:when>
<xsl:when test="$ssi_partyA and $ssi_partyB">
<xsl:if test="($TradeOriginator='partyA' and $ssi_2nd='partyB') or ($TradeOriginator='partyB' and $ssi_2nd='partyA')">
<xsl:value-of select="$swExtendedTradeDetails/swml:swTradeHeader/swml:swPartyTradeInformation[1]/swml:swSettlementInformation/swml:swSettlementAgent/swml:swSafekeepingAccountId"/>
</xsl:if>
<xsl:if test="($TradeOriginator='partyA' and $ssi_2nd='partyA') or ($TradeOriginator='partyB' and $ssi_2nd='partyB')">
<xsl:value-of select="$swExtendedTradeDetails/swml:swTradeHeader/swml:swPartyTradeInformation[2]/swml:swSettlementInformation/swml:swSettlementAgent/swml:swSafekeepingAccountId"/>
</xsl:if>
</xsl:when>
</xsl:choose>
</SettlementAgentSafeKeepA>
<SettlementAgentSafeKeepB>
<xsl:choose>
<xsl:when test="($TradeOriginator='partyA' and (not($ssi_partyA) and $ssi_partyB)) or ($TradeOriginator='partyB' and ($ssi_partyA and not($ssi_partyB)))">
<xsl:value-of select="$swExtendedTradeDetails/swml:swTradeHeader/swml:swPartyTradeInformation/swml:swSettlementInformation/swml:swSettlementAgent/swml:swSafekeepingAccountId"/>
</xsl:when>
<xsl:when test="$ssi_partyA and $ssi_partyB">
<xsl:if test="($TradeOriginator='partyA' and $ssi_2nd='partyB') or ($TradeOriginator='partyB' and $ssi_2nd='partyA')">
<xsl:value-of select="$swExtendedTradeDetails/swml:swTradeHeader/swml:swPartyTradeInformation[2]/swml:swSettlementInformation/swml:swSettlementAgent/swml:swSafekeepingAccountId"/>
</xsl:if>
<xsl:if test="($TradeOriginator='partyA' and $ssi_2nd='partyA') or ($TradeOriginator='partyB' and $ssi_2nd='partyB')">
<xsl:value-of select="$swExtendedTradeDetails/swml:swTradeHeader/swml:swPartyTradeInformation[1]/swml:swSettlementInformation/swml:swSettlementAgent/swml:swSafekeepingAccountId"/>
</xsl:if>
</xsl:when>
</xsl:choose>
</SettlementAgentSafeKeepB>
<IntermediaryIDA>
<xsl:choose>
<xsl:when test="($TradeOriginator='partyB' and (not($ssi_partyA) and $ssi_partyB)) or ($ssi_partyA and not($ssi_partyB))">
<xsl:value-of select="$swExtendedTradeDetails/swml:swTradeHeader/swml:swPartyTradeInformation/swml:swSettlementInformation/swml:swIntermediary1/swml:swPartyId"/>
</xsl:when>
<xsl:when test="$ssi_partyA and $ssi_partyB">
<xsl:if test="($TradeOriginator='partyA' and $ssi_2nd='partyB') or ($TradeOriginator='partyB' and $ssi_2nd='partyA')">
<xsl:value-of select="$swExtendedTradeDetails/swml:swTradeHeader/swml:swPartyTradeInformation[1]/swml:swSettlementInformation/swml:swIntermediary1/swml:swPartyId"/>
</xsl:if>
<xsl:if test="($TradeOriginator='partyA' and $ssi_2nd='partyA') or ($TradeOriginator='partyB' and $ssi_2nd='partyB')">
<xsl:value-of select="$swExtendedTradeDetails/swml:swTradeHeader/swml:swPartyTradeInformation[2]/swml:swSettlementInformation/swml:swIntermediary1/swml:swPartyId"/>
</xsl:if>
</xsl:when>
</xsl:choose>
</IntermediaryIDA>
<IntermediaryIDB>
<xsl:choose>
<xsl:when test="($TradeOriginator='partyA' and (not($ssi_partyA) and $ssi_partyB)) or ($TradeOriginator='partyB' and ($ssi_partyA and not($ssi_partyB)))">
<xsl:value-of select="$swExtendedTradeDetails/swml:swTradeHeader/swml:swPartyTradeInformation/swml:swSettlementInformation/swml:swIntermediary1/swml:swPartyId"/>
</xsl:when>
<xsl:when test="$ssi_partyA and $ssi_partyB">
<xsl:if test="($TradeOriginator='partyA' and $ssi_2nd='partyB') or ($TradeOriginator='partyB' and $ssi_2nd='partyA')">
<xsl:value-of select="$swExtendedTradeDetails/swml:swTradeHeader/swml:swPartyTradeInformation[2]/swml:swSettlementInformation/swml:swIntermediary1/swml:swPartyId"/>
</xsl:if>
<xsl:if test="($TradeOriginator='partyA' and $ssi_2nd='partyA') or ($TradeOriginator='partyB' and $ssi_2nd='partyB')">
<xsl:value-of select="$swExtendedTradeDetails/swml:swTradeHeader/swml:swPartyTradeInformation[1]/swml:swSettlementInformation/swml:swIntermediary1/swml:swPartyId"/>
</xsl:if>
</xsl:when>
</xsl:choose>
</IntermediaryIDB>
<IntermediarySafeKeepA>
<xsl:choose>
<xsl:when test="($TradeOriginator='partyB' and (not($ssi_partyA) and $ssi_partyB)) or ($ssi_partyA and not($ssi_partyB))">
<xsl:value-of select="$swExtendedTradeDetails/swml:swTradeHeader/swml:swPartyTradeInformation/swml:swSettlementInformation/swml:swIntermediary1/swml:swSafekeepingAccountId"/>
</xsl:when>
<xsl:when test="$ssi_partyA and $ssi_partyB">
<xsl:if test="($TradeOriginator='partyA' and $ssi_2nd='partyB') or ($TradeOriginator='partyB' and $ssi_2nd='partyA')">
<xsl:value-of select="$swExtendedTradeDetails/swml:swTradeHeader/swml:swPartyTradeInformation[1]/swml:swSettlementInformation/swml:swIntermediary1/swml:swSafekeepingAccountId"/>
</xsl:if>
<xsl:if test="($TradeOriginator='partyA' and $ssi_2nd='partyA') or ($TradeOriginator='partyB' and $ssi_2nd='partyB')">
<xsl:value-of select="$swExtendedTradeDetails/swml:swTradeHeader/swml:swPartyTradeInformation[2]/swml:swSettlementInformation/swml:swIntermediary1/swml:swSafekeepingAccountId"/>
</xsl:if>
</xsl:when>
</xsl:choose>
</IntermediarySafeKeepA>
<IntermediarySafeKeepB>
<xsl:choose>
<xsl:when test="($TradeOriginator='partyA' and (not($ssi_partyA) and $ssi_partyB)) or ($TradeOriginator='partyB' and ($ssi_partyA and not($ssi_partyB)))">
<xsl:value-of select="$swExtendedTradeDetails/swml:swTradeHeader/swml:swPartyTradeInformation/swml:swSettlementInformation/swml:swIntermediary1/swml:swSafekeepingAccountId"/>
</xsl:when>
<xsl:when test="$ssi_partyA and $ssi_partyB">
<xsl:if test="($TradeOriginator='partyA' and $ssi_2nd='partyB') or ($TradeOriginator='partyB' and $ssi_2nd='partyA')">
<xsl:value-of select="$swExtendedTradeDetails/swml:swTradeHeader/swml:swPartyTradeInformation[2]/swml:swSettlementInformation/swml:swIntermediary1/swml:swSafekeepingAccountId"/>
</xsl:if>
<xsl:if test="($TradeOriginator='partyA' and $ssi_2nd='partyA') or ($TradeOriginator='partyB' and $ssi_2nd='partyB')">
<xsl:value-of select="$swExtendedTradeDetails/swml:swTradeHeader/swml:swPartyTradeInformation[1]/swml:swSettlementInformation/swml:swIntermediary1/swml:swSafekeepingAccountId"/>
</xsl:if>
</xsl:when>
</xsl:choose>
</IntermediarySafeKeepB>
<CustodianIDA>
<xsl:choose>
<xsl:when test="($TradeOriginator='partyB' and (not($ssi_partyA) and $ssi_partyB)) or ($ssi_partyA and not($ssi_partyB))">
<xsl:value-of select="$swExtendedTradeDetails/swml:swTradeHeader/swml:swPartyTradeInformation/swml:swSettlementInformation/swml:swCustodian/swml:swPartyId"/>
</xsl:when>
<xsl:when test="$ssi_partyA and $ssi_partyB">
<xsl:if test="($TradeOriginator='partyA' and $ssi_2nd='partyB') or ($TradeOriginator='partyB' and $ssi_2nd='partyA')">
<xsl:value-of select="$swExtendedTradeDetails/swml:swTradeHeader/swml:swPartyTradeInformation[1]/swml:swSettlementInformation/swml:swCustodian/swml:swPartyId"/>
</xsl:if>
<xsl:if test="($TradeOriginator='partyA' and $ssi_2nd='partyA') or ($TradeOriginator='partyB' and $ssi_2nd='partyB')">
<xsl:value-of select="$swExtendedTradeDetails/swml:swTradeHeader/swml:swPartyTradeInformation[2]/swml:swSettlementInformation/swml:swCustodian/swml:swPartyId"/>
</xsl:if>
</xsl:when>
</xsl:choose>
</CustodianIDA>
<CustodianIDB>
<xsl:choose>
<xsl:when test="($TradeOriginator='partyA' and (not($ssi_partyA) and $ssi_partyB)) or ($TradeOriginator='partyB' and ($ssi_partyA and not($ssi_partyB)))">
<xsl:value-of select="$swExtendedTradeDetails/swml:swTradeHeader/swml:swPartyTradeInformation/swml:swSettlementInformation/swml:swCustodian/swml:swPartyId"/>
</xsl:when>
<xsl:when test="$ssi_partyA and $ssi_partyB">
<xsl:if test="($TradeOriginator='partyA' and $ssi_2nd='partyB') or ($TradeOriginator='partyB' and $ssi_2nd='partyA')">
<xsl:value-of select="$swExtendedTradeDetails/swml:swTradeHeader/swml:swPartyTradeInformation[2]/swml:swSettlementInformation/swml:swCustodian/swml:swPartyId"/>
</xsl:if>
<xsl:if test="($TradeOriginator='partyA' and $ssi_2nd='partyA') or ($TradeOriginator='partyB' and $ssi_2nd='partyB')">
<xsl:value-of select="$swExtendedTradeDetails/swml:swTradeHeader/swml:swPartyTradeInformation[1]/swml:swSettlementInformation/swml:swCustodian/swml:swPartyId"/>
</xsl:if>
</xsl:when>
</xsl:choose>
</CustodianIDB>
<CustodianSafeKeepA>
<xsl:choose>
<xsl:when test="($TradeOriginator='partyB' and (not($ssi_partyA) and $ssi_partyB)) or ($ssi_partyA and not($ssi_partyB))">
<xsl:value-of select="$swExtendedTradeDetails/swml:swTradeHeader/swml:swPartyTradeInformation/swml:swSettlementInformation/swml:swCustodian/swml:swSafekeepingAccountId"/>
</xsl:when>
<xsl:when test="$ssi_partyA and $ssi_partyB">
<xsl:if test="($TradeOriginator='partyA' and $ssi_2nd='partyB') or ($TradeOriginator='partyB' and $ssi_2nd='partyA')">
<xsl:value-of select="$swExtendedTradeDetails/swml:swTradeHeader/swml:swPartyTradeInformation[1]/swml:swSettlementInformation/swml:swCustodian/swml:swSafekeepingAccountId"/>
</xsl:if>
<xsl:if test="($TradeOriginator='partyA' and $ssi_2nd='partyA') or ($TradeOriginator='partyB' and $ssi_2nd='partyB')">
<xsl:value-of select="$swExtendedTradeDetails/swml:swTradeHeader/swml:swPartyTradeInformation[2]/swml:swSettlementInformation/swml:swCustodian/swml:swSafekeepingAccountId"/>
</xsl:if>
</xsl:when>
</xsl:choose>
</CustodianSafeKeepA>
<CustodianSafeKeepB>
<xsl:choose>
<xsl:when test="($TradeOriginator='partyA' and (not($ssi_partyA) and $ssi_partyB)) or ($TradeOriginator='partyB' and ($ssi_partyA and not($ssi_partyB)))">
<xsl:value-of select="$swExtendedTradeDetails/swml:swTradeHeader/swml:swPartyTradeInformation/swml:swSettlementInformation/swml:swCustodian/swml:swSafekeepingAccountId"/>
</xsl:when>
<xsl:when test="$ssi_partyA and $ssi_partyB">
<xsl:if test="($TradeOriginator='partyA' and $ssi_2nd='partyB') or ($TradeOriginator='partyB' and $ssi_2nd='partyA')">
<xsl:value-of select="$swExtendedTradeDetails/swml:swTradeHeader/swml:swPartyTradeInformation[2]/swml:swSettlementInformation/swml:swCustodian/swml:swSafekeepingAccountId"/>
</xsl:if>
<xsl:if test="($TradeOriginator='partyA' and $ssi_2nd='partyA') or ($TradeOriginator='partyB' and $ssi_2nd='partyB')">
<xsl:value-of select="$swExtendedTradeDetails/swml:swTradeHeader/swml:swPartyTradeInformation[1]/swml:swSettlementInformation/swml:swCustodian/swml:swSafekeepingAccountId"/>
</xsl:if>
</xsl:when>
</xsl:choose>
</CustodianSafeKeepB>
<BuyerSellerIDA>
<xsl:choose>
<xsl:when test="($TradeOriginator='partyB' and (not($ssi_partyA) and $ssi_partyB)) or ($TradeOriginator='partyA' and ($ssi_partyA and not($ssi_partyB)))">
<xsl:value-of select="$swExtendedTradeDetails/swml:swTradeHeader/swml:swPartyTradeInformation/swml:swSettlementInformation/swml:swBuyerSeller/swml:swPartyId"/>
</xsl:when>
<xsl:when test="$ssi_partyA and $ssi_partyB">
<xsl:if test="($TradeOriginator='partyA' and $ssi_2nd='partyB') or ($TradeOriginator='partyB' and $ssi_2nd='partyA')">
<xsl:value-of select="$swExtendedTradeDetails/swml:swTradeHeader/swml:swPartyTradeInformation[1]/swml:swSettlementInformation/swml:swBuyerSeller/swml:swPartyId"/>
</xsl:if>
<xsl:if test="($TradeOriginator='partyA' and $ssi_2nd='partyA') or ($TradeOriginator='partyB' and $ssi_2nd='partyB')">
<xsl:value-of select="$swExtendedTradeDetails/swml:swTradeHeader/swml:swPartyTradeInformation[2]/swml:swSettlementInformation/swml:swBuyerSeller/swml:swPartyId"/>
</xsl:if>
</xsl:when>
</xsl:choose>
</BuyerSellerIDA>
<BuyerSellerIDB>
<xsl:choose>
<xsl:when test="($TradeOriginator='partyA' and (not($ssi_partyA) and $ssi_partyB)) or ($TradeOriginator='partyB' and ($ssi_partyA and not($ssi_partyB)))">
<xsl:value-of select="$swExtendedTradeDetails/swml:swTradeHeader/swml:swPartyTradeInformation/swml:swSettlementInformation/swml:swBuyerSeller/swml:swPartyId"/>
</xsl:when>
<xsl:when test="$ssi_partyA and $ssi_partyB">
<xsl:if test="($TradeOriginator='partyA' and $ssi_2nd='partyB') or ($TradeOriginator='partyB' and $ssi_2nd='partyA')">
<xsl:value-of select="$swExtendedTradeDetails/swml:swTradeHeader/swml:swPartyTradeInformation[2]/swml:swSettlementInformation/swml:swBuyerSeller/swml:swPartyId"/>
</xsl:if>
<xsl:if test="($TradeOriginator='partyA' and $ssi_2nd='partyA') or ($TradeOriginator='partyB' and $ssi_2nd='partyB')">
<xsl:value-of select="$swExtendedTradeDetails/swml:swTradeHeader/swml:swPartyTradeInformation[1]/swml:swSettlementInformation/swml:swBuyerSeller/swml:swPartyId"/>
</xsl:if>
</xsl:when>
</xsl:choose>
</BuyerSellerIDB>
<BuyerSellerSafeKeepA>
<xsl:choose>
<xsl:when test="($TradeOriginator='partyB' and (not($ssi_partyA) and $ssi_partyB)) or ($ssi_partyA and not($ssi_partyB))">
<xsl:value-of select="$swExtendedTradeDetails/swml:swTradeHeader/swml:swPartyTradeInformation/swml:swSettlementInformation/swml:swBuyerSeller/swml:swSafekeepingAccountId"/>
</xsl:when>
<xsl:when test="$ssi_partyA and $ssi_partyB">
<xsl:if test="($TradeOriginator='partyA' and $ssi_2nd='partyB') or ($TradeOriginator='partyB' and $ssi_2nd='partyA')">
<xsl:value-of select="$swExtendedTradeDetails/swml:swTradeHeader/swml:swPartyTradeInformation[1]/swml:swSettlementInformation/swml:swBuyerSeller/swml:swSafekeepingAccountId"/>
</xsl:if>
<xsl:if test="($TradeOriginator='partyA' and $ssi_2nd='partyA') or ($TradeOriginator='partyB' and $ssi_2nd='partyB')">
<xsl:value-of select="$swExtendedTradeDetails/swml:swTradeHeader/swml:swPartyTradeInformation[2]/swml:swSettlementInformation/swml:swBuyerSeller/swml:swSafekeepingAccountId"/>
</xsl:if>
</xsl:when>
</xsl:choose>
</BuyerSellerSafeKeepA>
<BuyerSellerSafeKeepB>
<xsl:choose>
<xsl:when test="($TradeOriginator='partyA' and (not($ssi_partyA) and $ssi_partyB)) or ($TradeOriginator='partyB' and ($ssi_partyA and not($ssi_partyB)))">
<xsl:value-of select="$swExtendedTradeDetails/swml:swTradeHeader/swml:swPartyTradeInformation/swml:swSettlementInformation/swml:swBuyerSeller/swml:swSafekeepingAccountId"/>
</xsl:when>
<xsl:when test="$ssi_partyA and $ssi_partyB">
<xsl:if test="($TradeOriginator='partyA' and $ssi_2nd='partyB') or ($TradeOriginator='partyB' and $ssi_2nd='partyA')">
<xsl:value-of select="$swExtendedTradeDetails/swml:swTradeHeader/swml:swPartyTradeInformation[2]/swml:swSettlementInformation/swml:swBuyerSeller/swml:swSafekeepingAccountId"/>
</xsl:if>
<xsl:if test="($TradeOriginator='partyA' and $ssi_2nd='partyA') or ($TradeOriginator='partyB' and $ssi_2nd='partyB')">
<xsl:value-of select="$swExtendedTradeDetails/swml:swTradeHeader/swml:swPartyTradeInformation[1]/swml:swSettlementInformation/swml:swBuyerSeller/swml:swSafekeepingAccountId"/>
</xsl:if>
</xsl:when>
</xsl:choose>
</BuyerSellerSafeKeepB>
<ExclFromClearing/>
<NonStdSettlInst/>
<Normalised/>
<DataMigrationId/>
<NormalisedStubLength/>
<ClientClearing/>
<AutoSendForClearing/>
<ASICMandatoryClearingIndicator/>
<NewNovatedASICMandatoryClearingIndicator/>
<PBEBTradeASICMandatoryClearingIndicator/>
<PBClientTradeASICMandatoryClearingIndicator/>
<CANMandatoryClearingIndicator/>
<CANClearingExemptIndicator1PartyId/>
<CANClearingExemptIndicator1Value/>
<CANClearingExemptIndicator2PartyId/>
<CANClearingExemptIndicator2Value/>
<NewNovatedCANMandatoryClearingIndicator/>
<NewNovatedCANClearingExemptIndicator1PartyId/>
<NewNovatedCANClearingExemptIndicator1Value/>
<NewNovatedCANClearingExemptIndicator2PartyId/>
<NewNovatedCANClearingExemptIndicator2Value/>
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
<NewNovatedESMAMandatoryClearingIndicator/>
<NewNovatedESMAClearingExemptIndicator1PartyId/>
<NewNovatedESMAClearingExemptIndicator1Value/>
<NewNovatedESMAClearingExemptIndicator2PartyId/>
<NewNovatedESMAClearingExemptIndicator2Value/>
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
<NewNovatedFCAMandatoryClearingIndicator/>
<NewNovatedFCAClearingExemptIndicator1PartyId/>
<NewNovatedFCAClearingExemptIndicator1Value/>
<NewNovatedFCAClearingExemptIndicator2PartyId/>
<NewNovatedFCAClearingExemptIndicator2Value/>
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
<NewNovatedHKMAMandatoryClearingIndicator/>
<NewNovatedHKMAClearingExemptIndicator1PartyId/>
<NewNovatedHKMAClearingExemptIndicator1Value/>
<NewNovatedHKMAClearingExemptIndicator2PartyId/>
<NewNovatedHKMAClearingExemptIndicator2Value/>
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
<NewNovatedCFTCMandatoryClearingIndicator/>
<NewNovatedCFTCClearingExemptIndicator1PartyId/>
<NewNovatedCFTCClearingExemptIndicator1Value/>
<NewNovatedCFTCClearingExemptIndicator2PartyId/>
<NewNovatedCFTCClearingExemptIndicator2Value/>
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
<NewNovatedMASMandatoryClearingIndicator/>
<PBEBTradeMASMandatoryClearingIndicator/>
<PBClientTradeMASMandatoryClearingIndicator/>
<ClearingHouseId/>
<ClearingBrokerId/>
<OriginatingEvent>
<xsl:value-of select="$swExtendedTradeDetails/swml:swTradeHeader/swml:swOriginatingEvent"/>
</OriginatingEvent>
<BackLoadingFlag>
<xsl:choose>
<xsl:when test="$swExtendedTradeDetails/swml:swTradeHeader/swml:swBackLoadingFlag">
<xsl:value-of select="$swExtendedTradeDetails/swml:swTradeHeader/swml:swBackLoadingFlag"/>
</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</BackLoadingFlag>
<Novation>
<xsl:value-of select="string(boolean($novation))"/>
</Novation>
<PartialNovation/>
<FourWayNovation/>
<NovationTradeDate/>
<NovationDate/>
<NovatedAmount/>
<NovatedAmount_2/>
<NovatedCurrency/>
<NovatedCurrency_2/>
<NovatedFV/>
<FullFirstCalculationPeriod/>
<NonReliance/>
<PreserveEarlyTerminationProvision/>
<CopyPremiumToNewTrade/>
<IntendedClearingHouse/>
<OptionStyle/>
<OptionType/>
<OptionExpirationDate/>
<OptionExpirationDateConvention/>
<OptionHolidayCenters/>
<OptionEarliestTime/>
<OptionEarliestTimeHolidayCentre/>
<OptionExpiryTime/>
<OptionExpiryTimeHolidayCentre/>
<OptionSpecificExpiryTime/>
<OptionLocation/>
<OptionCalcAgent/>
<OptionAutomaticExercise/>
<OptionThreshold/>
<ManualExercise/>
<OptionWrittenExerciseConf/>
<PremiumAmount/>
<PremiumCurrency/>
<PremiumPaymentDate/>
<PremiumHolidayCentres/>
<Strike/>
<StrikeCurrency/>
<StrikePercentage/>
<StrikeDate/>
<OptionSettlement/>
<OptionCashSettlementValuationTime/>
<OptionSpecificValuationTime/>
<OptionCashSettlementValuationDate/>
<OptionCashSettlementPaymentDate/>
<OptionCashSettlementMethod/>
<OptionCashSettlementQuotationRate/>
<OptionCashSettlementRateSource/>
<OptionCashSettlementReferenceBanks/>
<ClearedPhysicalSettlement/>
<ClearingTakeupClientId/>
<ClearingTakeupClientName/>
<ClearingTakeupClientTradeId/>
<ClearingTakeupExecSrcId/>
<ClearingTakeupExecSrcName/>
<ClearingTakeupExecSrcTradeId/>
<ClearingTakeupCorrelationId/>
<ClearingTakeupClearingHouseTradeId/>
<ClearingTakeupOriginatingEvent/>
<ClearingTakeupBlockTradeId/>
<ClearingTakeupSentBy/>
<ClearingTakeupCreditTokenIssuer/>
<ClearingTakeupCreditToken/>
<ClearingTakeupClearingStatus/>
<ClearingTakeupVenueLEI/>
<ClearingTakeupVenueLEIScheme/>
<DocsType/>
<DocsSubType/>
<ContractualDefinitions/>
<ContractualSupplement/>
<CanadianSupplement/>
<ExchangeTradedContractNearest/>
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
<ObligationCategory/>
<DesignatedPriority/>
<CreditDateAdjustments>
<Convention/>
<Holidays/>
</CreditDateAdjustments>
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
<MortgageInsurer/>
<IndexName/>
<IndexId/>
<IndexAnnexDate/>
<IndexTradedRate/>
<UpfrontFee/>
<UpfrontFeeAmount/>
<UpfrontFeeDate/>
<UpfrontFeePayer/>
<AttachmentPoint/>
<ExhaustionPoint/>
<PublicationDate/>
<MasterAgreementDate/>
<AmendmentTradeDate/>
<SettlementCurrency/>
<ReferenceCurrency/>
<SettlementRateOption/>
<NonDeliverable/>
<FxFixingDate>
<FxFixingAdjustableDate/>
<FxFixingPeriod/>
<FxFixingDayConvention/>
<FxFixingCentres/>
</FxFixingDate>
<SettlementCurrency_2/>
<ReferenceCurrency_2/>
<SettlementRateOption_2/>
<FxFixingDate_2>
<FxFixingPeriod_2/>
<FxFixingDayConvention_2/>
<FxFixingCentres_2/>
</FxFixingDate_2>
<OutsideNovationTradeDate/>
<OutsideNovationNovationDate/>
<OutsideNovationOutgoingParty/>
<OutsideNovationIncomingParty/>
<OutsideNovationRemainingParty/>
<OutsideNovationFullFirstCalculationPeriod/>
<CalcAgentA/>
<AmendmentType>
<xsl:choose>
<xsl:when test="$swExtendedTradeDetails/swml:swAmendmentType='ErrorCorrection'">Error Correction</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$swExtendedTradeDetails/swml:swAmendmentType"/>
</xsl:otherwise>
</xsl:choose>
</AmendmentType>
<CancellationType/>
<OfflineLeg1/>
<OfflineLeg2/>
<OfflineSpread/>
<OfflineSpreadLeg/>
<OfflineSpreadParty/>
<OfflineSpreadDirection/>
<OfflineAdditionalDetails/>
<OfflineOrigRef/>
<OfflineOrigRef_2/>
<OfflineTradeDesk/>
<OfflineTradeDesk_2/>
<OfflineProductType/>
<OfflineExpirationDate/>
<OfflineOptionType/>
<EquityRic/>
<OptionQuantity/>
<OptionNumberOfShares/>
<Price/>
<PricePerOptionCurrency/>
<ExchangeLookAlike/>
<AdjustmentMethod/>
<MasterConfirmationDate/>
<Multiplier/>
<OptionExchange/>
<RelatedExchange/>
<DefaultSettlementMethod/>
<SettlementPriceDefaultElectionMethod/>
<DesignatedContract/>
<FxDeterminationMethod/>
<SWFXRateSource/>
<SWFXRateSourcePage/>
<SWFXHourMinuteTime/>
<SWFXBusinessCenter/>
<SettlementMethodElectionDate/>
<SettlementMethodElectingParty/>
<SettlementDateOffset/>
<SettlementType/>
<MultipleExchangeIndexAnnex/>
<ComponentSecurityIndexAnnex/>
<LocalJurisdiction/>
<OptionHedgingDisruption/>
<OptionLossOfStockBorrow/>
<OptionMaximumStockLoanRate/>
<OptionIncreasedCostOfStockBorrow/>
<OptionInitialStockLoanRate/>
<OptionIncreasedCostOfHedging/>
<OptionForeignOwnershipEvent/>
<OptionEntitlement/>
<ReferencePriceSource/>
<ReferencePricePage/>
<ReferencePriceTime/>
<ReferencePriceCity/>
<MinimumNumberOfOptions/>
<IntegralMultiple/>
<MaximumNumberOfOptions/>
<ExerciseCommencementDate/>
<BermudaExerciseDates>
<BermudaExerciseDate/>
</BermudaExerciseDates>
<BermudaFrequency/>
<BermudaFirstDate/>
<BermudaFinalDate/>
<LatestExerciseTimeMethod/>
<LatestExerciseSpecificTime/>
<DcCurrency/>
<DcDelta/>
<DcEventTypeA/>
<DcExchange/>
<DcExpiryDate/>
<DcFuturesCode/>
<DcOffshoreCross/>
<DcOffshoreCrossLocation/>
<DcPrice/>
<DcQuantity/>
<DcRequired/>
<DcRic/>
<DcDescription/>
<AveragingInOut/>
<AveragingDateTimes>
<AveragingDate/>
</AveragingDateTimes>
<MarketDisruption/>
<AveragingFrequency/>
<AveragingStartDate/>
<AveragingEndDate/>
<AveragingBusinessDayConvention/>
<ReferenceFXRate/>
<HedgeLevel/>
<Basis/>
<ImpliedLevel/>
<PremiumPercent/>
<StrikePercent/>
<BaseNotional/>
<BaseNotionalCurrency/>
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
<EquityAveragingObservations>
<EquityAveragingObservation>
<EquityAveragingDate/>
<EquityAveragingWeight/>
</EquityAveragingObservation>
</EquityAveragingObservations>
<EquityInitialSpot/>
<EquityCap/>
<EquityCapPercentage/>
<EquityFloor/>
<EquityFloorPercentage/>
<EquityNotional/>
<EquityNotionalCurrency/>
<EquityFrequency/>
<EquityValuationMethod/>
<EquityFrequencyConvention/>
<EquityFreqFirstDate/>
<EquityFreqFinalDate/>
<EquityFreqRoll/>
<EquityListedValuationDates>
<EquityListedValuationDate/>
</EquityListedValuationDates>
<EquityListedDatesConvention/>
<StrategyType/>
<StrategyDeltaLeg/>
<StrategyDeltaQuantity/>
<StrategyComments/>
<StrategyLegs>
<StrategyLeg>
<SlDirectionA/>
<SlLegId/>
<SlExpirationDate/>
<SlNumberOfOptions/>
<SlOptionType/>
<SlPayAmount/>
<SlPricePerOptionAmount/>
<SlStrikePrice/>
<SlFwdStrikePercentage/>
<SlFwdStrikeDate/>
<SlPremiumPercent/>
<SlStrikePercent/>
<SlBaseNotional/>
</StrategyLeg>
</StrategyLegs>
<VegaNotional/>
<ExpectedN/>
<ExpectedNOverride/>
<VarianceAmount/>
<VarianceStrikePrice/>
<VolatilityStrikePrice/>
<VarianceCapIndicator/>
<VarianceCapFactor/>
<TotalVarianceCap/>
<TotalVolatilityCap/>
<ObservationStartDate/>
<ValuationDate/>
<InitialSharePriceOrIndexLevel/>
<ClosingSharePriceOrClosingIndexLevelIndicator/>
<FuturesPriceValuation/>
<AllDividends/>
<SettlementCurrencyVegaNotional/>
<VegaFxRate/>
<HolidayDates/>
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
<BulletIndicator/>
<DocsSelection/>
<NovationReporting>
<Novated/>
<NewNovated/>
</NovationReporting>
<InterestLegDrivenIndicator/>
<EquityFrontStub/>
<EquityEndStub/>
<InterestFrontStub/>
<InterestEndStub/>
<FixedRateIndicator/>
<EswFixingDateOffset/>
<DividendPaymentDates/>
<DividendPaymentOffset/>
<DividendPercentage/>
<DividendReinvestment/>
<EswDeclaredCashDividendPercentage/>
<EswDeclaredCashEquivalentDividendPercentage/>
<EswDividendSettlementCurrency/>
<EswNonCashDividendTreatment/>
<EswDividendComposition/>
<EswSpecialDividends/>
<EswDividendValuationOffset/>
<EswDividendValuationFrequency/>
<EswDividendInitialValuation/>
<EswDividendFinalValuation/>
<EswDividendValuationDay/>
<EswDividendValuationCustomDatesInterim>
<EswDividendValuationCustomDateInterim/>
</EswDividendValuationCustomDatesInterim>
<EswDividendValuationCustomDateFinal/>
<ExitReason/>
<TransactionDate/>
<EffectiveDate/>
<EquityHolidayCentres/>
<OtherValuationBusinessCenters/>
<EswFuturesPriceValuation/>
<EswFpvFinalPriceElectionFallback/>
<EswDesignatedMaturity/>
<EswEquityValConvention/>
<EswInterestFloatConvention/>
<EswInterestFloatDayBasis/>
<EswInterestFloatingRateIndex/>
<EswInterestFixedRate/>
<EswInterestSpreadOverIndex/>
<EswLocalJurisdiction/>
<EswReferencePriceSource/>
<EswReferencePricePage/>
<EswReferencePriceTime/>
<EswReferencePriceCity/>
<EswNotionalAmount/>
<EswNotionalCurrency/>
<EswOpenUnits/>
<FeeIn/>
<FeeInOutIndicator/>
<FeeOut/>
<FinalPriceDefaultElection/>
<FinalValuationDate/>
<FullyFundedAmount/>
<FullyFundedIndicator/>
<InitialPrice/>
<InitialPriceElection/>
<EquityNotionalReset/>
<EswReferenceInitialPrice/>
<EswReferenceFXRate/>
<PaymentDateOffset/>
<PaymentFrequency/>
<EswFixingHolidayCentres/>
<EswPaymentHolidayCentres/>
<ReturnType/>
<Synthetic/>
<TerminationDate/>
<ValuationDay/>
<PaymentDay/>
<ValuationFrequency/>
<ValuationStartDate/>
<EswSchedulingMethod/>
<EswValuationDates/>
<EswFixingDates/>
<EswInterestLegPaymentDates/>
<EswEquityLegPaymentDates/>
<EswCompoundingDates/>
<EswCompoundingMethod/>
<EswCompoundingFrequency/>
<EswInterpolationMethod/>
<EswInterpolationPeriod/>
<EswAveragingDatesIndicator/>
<EswADTVIndicator/>
<EswLimitationPercentage/>
<EswLimitationPeriod/>
<EswStockLoanRateIndicator/>
<EswMaximumStockLoanRate/>
<EswInitialStockLoanRate/>
<EswOptionalEarlyTermination/>
<EswBreakFundingRecovery/>
<EswBreakFeeElection/>
<EswBreakFeeRate/>
<EswFinalPriceFee/>
<EswEarlyFinalValuationDateElection/>
<EswEarlyTerminationElectingParty/>
<EswInsolvencyFiling/>
<EswLossOfStockBorrow/>
<EswIncreasedCostOfStockBorrow/>
<EswBulletCompoundingSpread/>
<EswSpecifiedExchange/>
<EswCorporateActionFlag/>
<NCCreditProductType/>
<NCNovationBlockID/>
<NCNCMID/>
<NCRPOldTRN/>
<NCCEqualsCEligible/>
<NCSummaryLinkID/>
<NCORFundId/>
<NCORFundName/>
<NCRPFundId/>
<NCRPFundName/>
<NCEEFundId/>
<NCEEFundName/>
<NCRecoveryFactor/>
<NCFixedSettlement/>
<NCSwaptionDocsType/>
<NCSwaptionPublicationDate/>
<NCOptionDirectionA/>
<TIWDTCCTRI/>
<TIWActiveStatus/>
<TIWValueDate/>
<TIWAsOfDate/>
<EquityBackLoadingFlag/>
<MigrationReferences>
<MigrationReference>
<MigrationIDParty/>
<MigrationID/>
</MigrationReference>
</MigrationReferences>
<Rule15A-6/>
<HedgingParty>
<HedgingPartyOccurrence/>
</HedgingParty>
<DeterminingParty>
<DeterminingPartyOccurrence/>
</DeterminingParty>
<CalculationAgent>
<CalculationAgentOccurrence/>
</CalculationAgent>
<IndependentAmount2>
<Payer/>
<Currency/>
<Amount/>
</IndependentAmount2>
<NotionalFutureValue/>
<NotionalSchedule/>
<SendForPublishing/>
<SubscriberId/>
<ModifiedEquityDelivery/>
<SettledEntityMatrixSource/>
<SettledEntityMatrixDate/>
<AdditionalTerms/>
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
<xsl:if test="$swTradeEventReportingDetails/swml:swUniqueTransactionId/swml:swTradeId">
<GlobalUTI>
<xsl:value-of select="$swTradeEventReportingDetails/swml:swUniqueTransactionId/swml:swTradeId"/>
</GlobalUTI>
</xsl:if>
</SWDMLTrade>
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
<xsl:template name="swml:swAllocations">
<xsl:apply-templates select="$swLongFormTrade//swml:swAllocations/swml:swAllocation"/>
</xsl:template>
<xsl:template match="swml:swAllocation">
<xsl:variable name="BuyerRef" select="string(swml:swNearLeg//fpml:buyerPartyReference/@href)"/>
<xsl:variable name="SellerRef" select="string(swml:swNearLeg//fpml:sellerPartyReference/@href)"/>
<xsl:variable name="BuyerBIC" select="string($dataDocument/fpml:party[@id=$BuyerRef]/fpml:partyId)"/>
<xsl:variable name="SellerBIC" select="string($dataDocument/fpml:party[@id=$SellerRef]/fpml:partyId)"/>
<Allocation>
<DirectionReversed/>
<Buyer>
<xsl:value-of select="$BuyerBIC"/>
</Buyer>
<Seller>
<xsl:value-of select="$SellerBIC"/>
</Seller>
<AllocOpenSecurityNominal>
<xsl:value-of select="string(swml:swNearLeg//fpml:nominalAmount//fpml:amount)"/>
</AllocOpenSecurityNominal>
<AllocOpenSecurityQuantity>
<xsl:value-of select="string(swml:swNearLeg//fpml:quantity)"/>
</AllocOpenSecurityQuantity>
<AllocGlobalUTI>
<xsl:value-of select="string(swml:swAllocationReportingDetails//swml:swUniqueTransactionId//swml:swTradeId)"/>
</AllocGlobalUTI>
<InternalTradeId>
<xsl:value-of select="string(swml:swPrivateTradeId)"/>
</InternalTradeId>
<SalesCredit>
<xsl:value-of select="string(swml:swSalesCredit)"/>
</SalesCredit>
<AllocOriginator>
<xsl:value-of select="string(swml:swPartyTradeInformation/swml:swPartyReference/@href)"/>
</AllocOriginator>
<AllocPlaceofSettleID>
<xsl:if test="$swLongFormTrade/swml:swAllocations/swml:swAllocation/swml:swPartyTradeInformation/swml:swSettlementInformation/swml:swPlaceOfSettlement/swml:swPartyId">
<xsl:value-of select="string(swml:swPartyTradeInformation//swml:swSettlementInformation/swml:swPlaceOfSettlement/swml:swPartyId)"/>
</xsl:if>
</AllocPlaceofSettleID>
<AllocSettleAgentID>
<xsl:if test="$swLongFormTrade/swml:swAllocations/swml:swAllocation/swml:swPartyTradeInformation/swml:swSettlementInformation/swml:swSettlementAgent/swml:swPartyId">
<xsl:value-of select="string(swml:swPartyTradeInformation//swml:swSettlementInformation/swml:swSettlementAgent/swml:swPartyId)"/>
</xsl:if>
</AllocSettleAgentID>
<AllocSettleAgentSafekeepAC>
<xsl:if test="$swLongFormTrade/swml:swAllocations/swml:swAllocation/swml:swPartyTradeInformation//swml:swSettlementInformation/swml:swSettlementAgent/swml:swSafekeepingAccountId">
<xsl:value-of select="string(swml:swPartyTradeInformation//swml:swSettlementInformation/swml:swSettlementAgent/swml:swSafekeepingAccountId)"/>
</xsl:if>
</AllocSettleAgentSafekeepAC>
<AllocIntermediaryID>
<xsl:if test="$swLongFormTrade/swml:swAllocations/swml:swAllocation/swml:swPartyTradeInformation//swml:swSettlementInformation/swml:swIntermediary1/swml:swPartyId">
<xsl:value-of select="string(swml:swPartyTradeInformation//swml:swSettlementInformation/swml:swIntermediary1/swml:swPartyId)"/>
</xsl:if>
</AllocIntermediaryID>
<AllocIntermediarySafekeepAC>
<xsl:if test="$swLongFormTrade/swml:swAllocations/swml:swAllocation/swml:swPartyTradeInformation//swml:swSettlementInformation/swml:swIntermediary1/swml:swSafekeepingAccountId">
<xsl:value-of select="string(swml:swPartyTradeInformation//swml:swSettlementInformation/swml:swIntermediary1/swml:swSafekeepingAccountId)"/>
</xsl:if>
</AllocIntermediarySafekeepAC>
<AllocCustodianID>
<xsl:if test="$swLongFormTrade/swml:swAllocations/swml:swAllocation/swml:swPartyTradeInformation//swml:swSettlementInformation/swml:swCustodian/swml:swPartyId">
<xsl:value-of select="string(swml:swPartyTradeInformation//swml:swSettlementInformation/swml:swCustodian/swml:swPartyId)"/>
</xsl:if>
</AllocCustodianID>
<AllocCustodianSafekeepAC>
<xsl:if test="$swLongFormTrade/swml:swAllocations/swml:swAllocation/swml:swPartyTradeInformation//swml:swSettlementInformation/swml:swCustodian/swml:swSafekeepingAccountId">
<xsl:value-of select="string(swml:swPartyTradeInformation//swml:swSettlementInformation/swml:swCustodian/swml:swSafekeepingAccountId)"/>
</xsl:if>
</AllocCustodianSafekeepAC>
<AllocBuyerSellerID>
<xsl:if test="$swLongFormTrade/swml:swAllocations/swml:swAllocation/swml:swPartyTradeInformation//swml:swSettlementInformation/swml:swBuyerSeller/swml:swPartyId">
<xsl:value-of select="string(swml:swPartyTradeInformation//swml:swSettlementInformation/swml:swBuyerSeller/swml:swPartyId)"/>
</xsl:if>
</AllocBuyerSellerID>
<AllocBuyerSellerSafekeepAC>
<xsl:if test="$swLongFormTrade/swml:swAllocations/swml:swAllocation/swml:swPartyTradeInformation/swml:swSettlementInformation/swml:swBuyerSeller/swml:swSafekeepingAccountId">
<xsl:value-of select="string(swml:swPartyTradeInformation//swml:swSettlementInformation/swml:swBuyerSeller/swml:swSafekeepingAccountId)"/>
</xsl:if>
</AllocBuyerSellerSafekeepAC>
</Allocation>
</xsl:template>
<xsl:template match="fpml:partyReference">
<xsl:if test="@href='partyA'">
<xsl:value-of select="$dataDocument/fpml:party[@id=$partyA]/fpml:partyId"/>
</xsl:if>
<xsl:if test="@href='partyB'">
<xsl:value-of select="$dataDocument/fpml:party[@id=$partyB]/fpml:partyId"/>
</xsl:if>
<xsl:if test="@href='partyC'">
<xsl:value-of select="$dataDocument/fpml:party[@id=$partyC]/fpml:partyId"/>
</xsl:if>
<xsl:if test="@href='partyTripartyAgent'">
<xsl:value-of select="$dataDocument/fpml:party[@id=$partyTripartyAgent]/fpml:partyId"/>
</xsl:if>
</xsl:template>
</xsl:stylesheet>
