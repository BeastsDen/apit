<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:lcl="http://www.markitserv.com/local/csv2exercise.xsl"
xmlns:gx="http://www.markitserv.com/generic_xml_tools.xsl"
xmlns=""
exclude-result-prefixes="lcl gx xsl">
<xsl:import href="generic_xml_tools.xsl"/>
<xsl:output method="xml" encoding="iso-8859-1" indent="yes"/>
<xsl:variable name="xsl" select="document('')/xsl:stylesheet"/>
<xsl:namespace-alias stylesheet-prefix="gx" result-prefix="#default"/>
<xsl:namespace-alias stylesheet-prefix="lcl" result-prefix="#default"/>
<xsl:variable name="gx:keepDefault" select="true()"/>
<gx:template>
<SWDMLTrade version="1-0">
<SWDMLVersion>Match</SWDMLVersion>
<ReplacementTradeId gx:data="replacementtradeid"/>
<ReplacementTradeIdType gx:data="replacementtradeidtype"/>
<ReplacementReason gx:data="replacementreason"/>
<ShortFormInput                 gx:data="shortforminput"/>
<ProductType                    gx:data="producttype"/>
<ProductSubType                 gx:data="productsubtype"/>
<ParticipantSupplement          gx:data="participantsupplement"/>
<ConditionPrecedentBondId       gx:data="conditionprecedentbondid"/>
<ConditionPrecedentBondMaturity gx:data="conditionprecedentbondmaturity"/>
<AllocatedTrade gx:format="boolean"/>
<Allocation>
<DirectionReversed       gx:data="allocdirectionreversed"/>
<Payer                   gx:data="allocbuyer"/>
<Receiver                gx:data="allocseller"/>
<Buyer                   gx:data="allocbuyer"/>
<Seller                  gx:data="allocseller"/>
<Amount                  gx:data="allocamount"/>
<AllocatedVarianceAmount gx:data="swallocatedvarianceamount"/>
<IAExpected              gx:data="iaexpected"/>
<IndependentAmount gx:requires="allocindependentamount">
<Amount gx:data='allocindependentamount'/>
</IndependentAmount>
<AllocAdditionalPayment gx:requires="allocaddpayment1">
<AddPaySequence>1</AddPaySequence>
<DirectionReversed gx:data="allocaddpaydirectionreversed1"/>
<Amount            gx:data="allocaddpayamount1"/>
</AllocAdditionalPayment>
<AllocAdditionalPayment gx:requires="allocaddpayment2">
<AddPaySequence>2</AddPaySequence>
<DirectionReversed gx:data="allocaddpaydirectionreversed2"/>
<Amount            gx:data="allocaddpayamount2"/>
</AllocAdditionalPayment>
<InternalTradeId       gx:data="allocinternaltradeid"/>
<SalesCredit           gx:data="salescredit"/>
<ClearingBrokerId      gx:data="clearingbrokerid"/>
</Allocation>
<PrimeBrokerTrade>false</PrimeBrokerTrade>
<ReversePrimeBrokerLegalEntities gx:data="reverseprimebrokerlegalentities"/>
<PartyAId                    gx:data="partyaid"/>
<PartyBId                    gx:data="partybid"/>
<PartyCId                    gx:data="partycid"/>
<PartyDId                    gx:data="partydid"/>
<PartyGId                    gx:data="partygid"/>
<PartyTripartyAgentId        gx:data="partytripartyagentid"/>
<Interoperable               gx:data="interoperable"/>
<ExternalInteropabilityId    gx:data="externalinteropabilityid"/>
<InteropNettingString        gx:data="interopnettingstring"/>
<DirectionA                  gx:data="directiona"/>
<TradeDate                   gx:data="tradedate"                   gx:format="date"/>
<StartDateTenor              gx:data="startdatetenor"/>
<EndDateTenor                gx:data="enddatetenor"/>
<StartDateDay                gx:data="startdateday"/>
<Tenor                       gx:data="tenor"/>
<StartDate                   gx:data="startdate"                   gx:format="date"/>
<FirstFixedPeriodStartDate   gx:data="firstfixedperiodstartdate"   gx:format="date"/>
<FirstFloatPeriodStartDate   gx:data="firstfloatperiodstartdate"   gx:format="date"/>
<FirstFloatPeriodStartDate_2 gx:data="firstfloatperiodstartdate"   gx:format="date"/>
<EndDate                     gx:data="enddate"                     gx:format="date"/>
<FixedPaymentFreq            gx:data="fixedpaymentfreq"/>
<FixedPaymentFreq_2          gx:data="fixedpaymentfreq"/>
<FloatPaymentFreq            gx:data="floatpaymentfreq"/>
<FloatPaymentFreq_2          gx:data="floatpaymentfreq"/>
<FloatRollFreq               gx:data="floatrollfreq"/>
<FloatRollFreq_2             gx:data="floatrollfreq"/>
<RollsType                   gx:data="rollstype"/>
<RollsMethod                 gx:data="rollsmethod"/>
<RollDay                     gx:data="rollday"/>
<MonthEndRolls               gx:data="monthendrolls"/>
<FirstPeriodStartDate        gx:data="firstperiodstartdate"/>
<FirstPaymentDate            gx:data="firstpaymentdate"/>
<LastRegularPaymentDate      gx:data="lastregularpaymentdate"/>
<FixedRate                   gx:data="fixedrate"/>
<FixedRate_2                 gx:data="fixedrate"/>
<initialPoints               gx:data="initialpoints"/>
<quotationStyle              gx:data="quotationstyle"/>
<RecoveryRate                gx:data="recoveryrate"/>
<FixedSettlement             gx:data="fixedsettlement"/>
<Currency                    gx:data="currency"/>
<Currency_2                  gx:data="currency"/>
<Notional                    gx:data="notional"/>
<Notional_2                  gx:data="notional"/>
<InitialNotional             gx:data="initialnotional"/>
<FixedAmount                 gx:data="fixedamount"/>
<FixedAmountCurrency         gx:data="fixedamountcurrency"/>
<FixedDayBasis               gx:data="fixeddaybasis"/>
<FixedDayBasis_2             gx:data="fixeddaybasis"/>
<FloatDayBasis               gx:data="floatdaybasis"/>
<FloatDayBasis_2             gx:data="floatdaybasis"/>
<FixedConvention             gx:data="fixedconvention"/>
<FixedConvention_2           gx:data="fixedconvention"/>
<FixedCalcPeriodDatesConvention  gx:data="fixedcalcperioddatesconvention"/>
<FixedCalcPeriodDatesConvention_2  gx:data="fixedcalcperioddatesconvention"/>
<FixedTerminationDateConvention  gx:data="fixedterminationdateconvention"/>
<FixedTerminationDateConvention_2  gx:data="fixedterminationdateconvention"/>
<FloatConvention                 gx:data="floatconvention"/>
<FloatCalcPeriodDatesConvention  gx:data="floatcalcperioddatesconvention"/>
<FloatTerminationDateConvention  gx:data="floatterminationdateconvention"/>
<FloatConvention_2                gx:data="floatconvention"/>
<FloatTerminationDateConvention_2 gx:data="floatterminationdateconvention"/>
<FloatingRateIndex                gx:data="floatingrateindex"/>
<FloatingRateIndex_2              gx:data="floatingrateindex"/>
<InflationLag                     gx:data="inflationlag"/>
<IndexSource                      gx:data="indexsource"/>
<InterpolationMethod              gx:data="interpolationmethod"/>
<InitialIndexLevel                gx:data="initialindexlevel"/>
<RelatedBond                      gx:data="relatedbond"/>
<IndexTenor1                      gx:data="indextenor1"/>
<IndexTenor1_2                    gx:data="indextenor1"/>
<LinearInterpolation              gx:data="linearinterpolation"/>
<LinearInterpolation_2            gx:data="linearinterpolation"/>
<IndexTenor2                      gx:data="indextenor2"/>
<IndexTenor2_2                    gx:data="indextenor2"/>
<InitialInterpolationIndex/>
<InitialInterpolationIndex_2/>
<SpreadOverIndex                  gx:data="spreadoverindex"/>
<SpreadOverIndex_2                gx:data="spreadoverindex"/>
<FirstFixingRate                  gx:data="firstfixingrate"/>
<FirstFixingRate_2                gx:data="firstfixingrate"/>
<FixingDaysOffset                 gx:data="fixingdaysoffset"/>
<FixingDaysOffset_2               gx:data="fixingdaysoffset"/>
<FixingHolidayCentres             gx:data="fixingholidaycentres"/>
<FixingHolidayCentres_2           gx:data="fixingholidaycentres"/>
<ResetInArrears                   gx:data="resetinarrears"/>
<ResetInArrears_2                 gx:data="resetinarrears"/>
<FirstFixingDifferent             gx:data="firstfixingdifferent"/>
<FirstFixingDifferent_2           gx:data="firstfixingdifferent"/>
<FirstFixingDaysOffset            gx:data="firstfixingdaysoffset"/>
<FirstFixingDaysOffset_2          gx:data="firstfixingdaysoffset"/>
<FirstFixingHolidayCentres        gx:data="firstfixingholidaycentres"/>
<FirstFixingHolidayCentres_2      gx:data="firstfixingholidaycentres"/>
<PaymentHolidayCentres            gx:data="paymentholidaycentres"/>
<PaymentHolidayCentres_2          gx:data="paymentholidaycentres"/>
<PaymentLag                       gx:data="paymentlag"/>
<PaymentLag_2                     gx:data="paymentlag"/>
<RollHolidayCentres               gx:data="rollholidaycentres"/>
<RollHolidayCentres_2             gx:data="rollholidaycentres"/>
<AdjustFixedStartDate             gx:data="adjustfixedstartdate"/>
<AdjustFixedStartDate_2           gx:data="adjustfixedstartdate"/>
<AdjustFloatStartDate             gx:data="adjustfloatstartdate"/>
<AdjustFloatStartDate_2           gx:data="adjustfloatstartdate"/>
<AdjustRollEnd                    gx:data="adjustfixedrollend"/>
<AdjustFloatRollEnd               gx:data="adjustfloatrollend"/>
<AdjustFloatRollEnd_2               gx:data="adjustfloatrollend"/>
<AdjustFixedFinalRollEnd          gx:data="adjustfixedfinalrollend"/>
<AdjustFinalRollEnd               gx:data="adjustfloatfinalrollend"/>
<AdjustFinalRollEnd_2             gx:data="adjustfinalrollend"/>
<CompoundingMethod                gx:data="compoundingmethod"/>
<CompoundingMethod_2              gx:data="compoundingmethod"/>
<AveragingMethod                  gx:data="averagingmethod"/>
<AveragingMethod_2                gx:data="averagingmethod"/>
<FloatingRateMultiplier           gx:data="floatingratemultiplier"/>
<FloatingRateMultiplier_2         gx:data="floatingratemultiplier"/>
<DesignatedMaturity               gx:data="designatedmaturity"/>
<DesignatedMaturity_2             gx:data="designatedmaturity"/>
<ResetFreq                        gx:data="resetfreq"/>
<ResetFreq_2                      gx:data="resetfreq"/>
<WeeklyRollConvention             gx:data="weeklyrollconvention"/>
<WeeklyRollConvention_2           gx:data="weeklyrollconvention"/>
<RateCutOffDays                   gx:data="ratecutoffdays"/>
<RateCutOffDays_2                 gx:data="ratecutoffdays"/>
<InitialExchange                  gx:data="initialexchange"/>
<FinalExchange                    gx:data="finalexchange"/>
<MarkToMarket                     gx:data="marktomarket"/>
<IntermediateExchange             gx:data="intermediateexchange"/>
<MTMRateSource                    gx:data="mtmratesource"/>
<MTMRateSourcePage                gx:data="mtmratesourcepage"/>
<MTMFixingDate                    gx:data="mtmfixingdate"/>
<MTMFixingHolidayCentres          gx:data="mtmfixingholidaycentres"/>
<MTMFixingTime                    gx:data="mtmfixingtime"/>
<MTMLocation                      gx:data="mtmlocation"/>
<MTMCutoffTime                    gx:data="mtmcutofftime"/>
<CalculationPeriodDays            gx:data="calculationperioddays"/>
<FraDiscounting                   gx:data="fradiscounting"/>
<HasBreak                         gx:data="hasbreak"/>
<BreakFromSwap                    gx:data="breakoffsetfromswap"/>
<BreakOverride                    gx:data="breakoverride"/>
<BreakCalculationMethod           gx:data="breakcalculationmethod"/>
<BreakFirstDateTenor              gx:data="breakfirstdatetenor"/>
<BreakFrequency                   gx:data="breakfrequency"/>
<BreakOptionA                     gx:data="breakoptiona"/>
<BreakDate                        gx:data="breakdate"                   gx:format="date"/>
<BreakExpirationDate              gx:data="breakexpirationdate"/>
<BreakEarliestTime                gx:data="breakearliesttime"/>
<BreakLatestTime                  gx:data="breaklatesttime"/>
<BreakCalcAgentA                  gx:data="breakcalcagenta"/>
<BreakExpiryTime                  gx:data="breakexpirytime"/>
<BreakCashSettleCcy               gx:data="breakcashsettleccy"/>
<BreakLocation                    gx:data="breaklocation"/>
<BreakHolidayCentre               gx:data="breakholidaycentre"/>
<BreakSettlement                  gx:data="breaksettlement"/>
<BreakValuationDate               gx:data="breakvaluationdate"/>
<BreakValuationTime               gx:data="breakvaluationtime"/>
<BreakSource                      gx:data="breaksource"/>
<BreakReferenceBanks              gx:data="breakreferencebanks"/>
<BreakQuotation                   gx:data="breakquotation"/>
<BreakMMVApplicableCSA/>
<BreakCollateralCurrency/>
<BreakCollateralInterestRate/>
<BreakAgreedDiscountRate/>
<BreakProtectedPartyA/>
<BreakMutuallyAgreedCH/>
<BreakPrescribedDocAdj/>
<ExchangeUnderlying               gx:data="exchangeunderlying"/>
<SwapSpread                       gx:data="swapspread"/>
<BondId1                          gx:data="bondid1"/>
<BondName1                        gx:data="bondname1"/>
<BondAmount1                      gx:data="bondamount1"/>
<BondPriceType1                   gx:data="bondpriceType1"/>
<BondPrice1                       gx:data="bondprice1"/>
<BondId2                          gx:data="bondid2"/>
<BondName2                        gx:data="bondname2"/>
<BondAmount2                      gx:data="bondamount2"/>
<BondPriceType2                   gx:data="bondpriceType2"/>
<BondPrice2                       gx:data="bondprice2"/>
<StubAt                           gx:data="stubat"/>
<FixedStub                        gx:data="fixedstub"/>
<FloatStub                        gx:data="floatstub"/>
<FloatStub_2                      gx:data="floatstub"/>
<MasterAgreement                  gx:data="masteragreement"/>
<ManualConfirm                    gx:data="manualconfirm"/>
<NovationExecution                gx:data="novationexecution"/>
<ExclFromClearing                 gx:data="exclfromclearing"/>
<NonStdSettlInst                  gx:data="nonstdsettlinst"/>
<Normalised/>
<DataMigrationId                  gx:data="datamigrationid"/>
<NormalisedStubLength             gx:data="normalisedstublength"/>
<ClientClearing                   gx:data="clientclearing"/>
<AutoSendForClearing              gx:data="autosendforclearing"/>
<ASICMandatoryClearingIndicator gx:data="asicmandatoryclearingindicator"/>
<NewNovatedASICMandatoryClearingIndicator gx:data="newnovatedasicmandatoryclearingindicator"/>
<PBEBTradeASICMandatoryClearingIndicator  gx:data="pbebtradeasicmandatoryclearingindicator"/>
<PBClientTradeASICMandatoryClearingIndicator  gx:data="PBClientTradeasicmandatoryclearingindicator"/>
<CANMandatoryClearingIndicator gx:data="canmandatoryclearingindicator"/>
<CANClearingExemptIndicator1PartyId  gx:data="canclearingexemptIndicator1partyid"/>
<CANClearingExemptIndicator1Value  gx:data="canclearingexemptIndicator1value"/>
<CANClearingExemptIndicator2PartyId  gx:data="canclearingexemptIndicator2partyid"/>
<CANClearingExemptIndicator2Value  gx:data="canclearingexemptIndicator2value"/>
<NewNovatedCANMandatoryClearingIndicator gx:data="newnovatedcanmandatoryclearingindicator"/>
<NewNovatedCANClearingExemptIndicator1PartyId  gx:data="newnovatedcanclearingexemptindicator1partyId"/>
<NewNovatedCANClearingExemptIndicator1Value  gx:data="newnovatedcanclearingexemptindicator1value"/>
<NewNovatedCANClearingExemptIndicator2PartyId  gx:data="newnovatedcanclearingexemptindicator2partyId"/>
<NewNovatedCANClearingExemptIndicator2Value  gx:data="newnovatedcanclearingexemptindicator2value"/>
<PBEBTradeCANMandatoryClearingIndicator  gx:data="pbebtradecanmandatoryclearingindicator"/>
<PBEBTradeCANClearingExemptIndicator1PartyId  gx:data="pbebtradecanclearingexemptindicator1partyId"/>
<PBEBTradeCANClearingExemptIndicator1Value  gx:data="pbebtradecanclearingexemptindicator1value"/>
<PBEBTradeCANClearingExemptIndicator2PartyId  gx:data="ptebtradecanclearingexemptindicator2partyId"/>
<PBEBTradeCANClearingExemptIndicator2Value  gx:data="pbebtradecanclearingexemptindicator2value"/>
<PBClientTradeCANMandatoryClearingIndicator  gx:data="PBClientTradecanmandatoryclearingindicator"/>
<PBClientTradeCANClearingExemptIndicator1PartyId  gx:data="pblclientradecanclearingexemptindicator1partyId"/>
<PBClientTradeCANClearingExemptIndicator1Value  gx:data="pbclienttradecanclearingexemptindicator1value"/>
<PBClientTradeCANClearingExemptIndicator2PartyId  gx:data="pbclienttradecanclearingexemptindicator2partyId"/>
<PBClientTradeCANClearingExemptIndicator2Value  gx:data="pbclienttradecanclearingexemptindicator2value"/>
<ESMAMandatoryClearingIndicator gx:data="esmamandatoryclearingindicator"/>
<ESMAClearingExemptIndicator1PartyId  gx:data="ESMAclearingexemptIndicator1partyid"/>
<ESMAClearingExemptIndicator1Value  gx:data="ESMAclearingexemptIndicator1value"/>
<ESMAClearingExemptIndicator2PartyId  gx:data="ESMAclearingexemptIndicator2partyid"/>
<ESMAClearingExemptIndicator2Value  gx:data="ESMAclearingexemptIndicator2value"/>
<NewNovatedESMAMandatoryClearingIndicator gx:data="newnovatedesmamandatoryclearingindicator"/>
<NewNovatedESMAClearingExemptIndicator1PartyId  gx:data="newnovatedESMAclearingexemptindicator1partyId"/>
<NewNovatedESMAClearingExemptIndicator1Value  gx:data="newnovatedESMAclearingexemptindicator1value"/>
<NewNovatedESMAClearingExemptIndicator2PartyId  gx:data="newnovatedESMAclearingexemptindicator2partyId"/>
<NewNovatedESMAClearingExemptIndicator2Value  gx:data="newnovatedESMAclearingexemptindicator2value"/>
<PBEBTradeESMAMandatoryClearingIndicator  gx:data="pbebtradeesmamandatoryclearingindicator"/>
<PBEBTradeESMAClearingExemptIndicator1PartyId  gx:data="pbebtradeESMAclearingexemptindicator1partyId"/>
<PBEBTradeESMAClearingExemptIndicator1Value  gx:data="pbebtradeESMAclearingexemptindicator1value"/>
<PBEBTradeESMAClearingExemptIndicator2PartyId  gx:data="ptebtradeESMAclearingexemptindicator2partyId"/>
<PBEBTradeESMAClearingExemptIndicator2Value  gx:data="pbebtradeESMAclearingexemptindicator2value"/>
<PBClientTradeESMAMandatoryClearingIndicator  gx:data="PBClientTradeesmamandatoryclearingindicator"/>
<PBClientTradeESMAClearingExemptIndicator1PartyId  gx:data="pblclientradeESMAclearingexemptindicator1partyId"/>
<PBClientTradeESMAClearingExemptIndicator1Value  gx:data="pbclienttradeESMAclearingexemptindicator1value"/>
<PBClientTradeESMAClearingExemptIndicator2PartyId  gx:data="pbclienttradeESMAclearingexemptindicator2partyId"/>
<PBClientTradeESMAClearingExemptIndicator2Value  gx:data="pbclienttradeESMAclearingexemptindicator2value"/>
<FCAMandatoryClearingIndicator gx:data="fcamandatoryclearingindicator"/>
<FCAClearingExemptIndicator1PartyId  gx:data="FCAclearingexemptIndicator1partyid"/>
<FCAClearingExemptIndicator1Value  gx:data="FCAclearingexemptIndicator1value"/>
<FCAClearingExemptIndicator2PartyId  gx:data="FCAclearingexemptIndicator2partyid"/>
<FCAClearingExemptIndicator2Value  gx:data="FCAclearingexemptIndicator2value"/>
<NewNovatedFCAMandatoryClearingIndicator gx:data="newnovatedfcamandatoryclearingindicator"/>
<NewNovatedFCAClearingExemptIndicator1PartyId  gx:data="newnovatedFCAclearingexemptindicator1partyId"/>
<NewNovatedFCAClearingExemptIndicator1Value  gx:data="newnovatedFCAclearingexemptindicator1value"/>
<NewNovatedFCAClearingExemptIndicator2PartyId  gx:data="newnovatedFCAclearingexemptindicator2partyId"/>
<NewNovatedFCAClearingExemptIndicator2Value  gx:data="newnovatedFCAclearingexemptindicator2value"/>
<PBEBTradeFCAMandatoryClearingIndicator  gx:data="pbebtradefcamandatoryclearingindicator"/>
<PBEBTradeFCAClearingExemptIndicator1PartyId  gx:data="pbebtradeFCAclearingexemptindicator1partyId"/>
<PBEBTradeFCAClearingExemptIndicator1Value  gx:data="pbebtradeFCAclearingexemptindicator1value"/>
<PBEBTradeFCAClearingExemptIndicator2PartyId  gx:data="ptebtradeFCAclearingexemptindicator2partyId"/>
<PBEBTradeFCAClearingExemptIndicator2Value  gx:data="pbebtradeFCAclearingexemptindicator2value"/>
<PBClientTradeFCAMandatoryClearingIndicator  gx:data="PBClientTradefcamandatoryclearingindicator"/>
<PBClientTradeFCAClearingExemptIndicator1PartyId  gx:data="pblclientradeFCAclearingexemptindicator1partyId"/>
<PBClientTradeFCAClearingExemptIndicator1Value  gx:data="pbclienttradeFCAclearingexemptindicator1value"/>
<PBClientTradeFCAClearingExemptIndicator2PartyId  gx:data="pbclienttradeFCAclearingexemptindicator2partyId"/>
<PBClientTradeFCAClearingExemptIndicator2Value  gx:data="pbclienttradeFCAclearingexemptindicator2value"/>
<HKMAMandatoryClearingIndicator gx:data="hkmamandatoryclearingindicator"/>
<HKMAClearingExemptIndicator1PartyId  gx:data="hkmaclearingexemptIndicator1partyid"/>
<HKMAClearingExemptIndicator1Value  gx:data="hkmaclearingexemptIndicator1value"/>
<HKMAClearingExemptIndicator2PartyId  gx:data="hkmaclearingexemptIndicator2partyid"/>
<HKMAClearingExemptIndicator2Value  gx:data="hkmaclearingexemptIndicator2value"/>
<NewNovatedHKMAMandatoryClearingIndicator gx:data="newnovatedhkmamandatoryclearingindicator"/>
<NewNovatedHKMAClearingExemptIndicator1PartyId  gx:data="newnovatedhkmaclearingexemptindicator1partyId"/>
<NewNovatedHKMAClearingExemptIndicator1Value  gx:data="newnovatedhkmaclearingexemptindicator1value"/>
<NewNovatedHKMAClearingExemptIndicator2PartyId  gx:data="newnovatedhkmaclearingexemptindicator2partyId"/>
<NewNovatedHKMAClearingExemptIndicator2Value  gx:data="newnovatedhkmaclearingexemptindicator2value"/>
<PBEBTradeHKMAMandatoryClearingIndicator  gx:data="pbebtradehkmamandatoryclearingindicator"/>
<PBEBTradeHKMAClearingExemptIndicator1PartyId  gx:data="pbebtradehkmaclearingexemptindicator1partyId"/>
<PBEBTradeHKMAClearingExemptIndicator1Value  gx:data="pbebtradehkmaclearingexemptindicator1value"/>
<PBEBTradeHKMAClearingExemptIndicator2PartyId  gx:data="ptebtradehkmaclearingexemptindicator2partyId"/>
<PBEBTradeHKMAClearingExemptIndicator2Value  gx:data="pbebtradehkmaclearingexemptindicator2value"/>
<PBClientTradeHKMAMandatoryClearingIndicator  gx:data="PBClientTradehkmamandatoryclearingindicator"/>
<PBClientTradeHKMAClearingExemptIndicator1PartyId  gx:data="pblclientradehkmaclearingexemptindicator1partyId"/>
<PBClientTradeHKMAClearingExemptIndicator1Value  gx:data="pbclienttradehkmaclearingexemptindicator1value"/>
<PBClientTradeHKMAClearingExemptIndicator2PartyId  gx:data="pbclienttradehkmaclearingexemptindicator2partyId"/>
<PBClientTradeHKMAClearingExemptIndicator2Value  gx:data="pbclienttradehkmaclearingexemptindicator2value"/>
<JFSAMandatoryClearingIndicator gx:data="jfsamandatoryclearingindicator"/>
<CFTCMandatoryClearingIndicator gx:data="cftcmandatoryclearingindicator"/>
<CFTCClearingExemptIndicator1PartyId  gx:data="cftcclearingexemptIndicator1partyid"/>
<CFTCClearingExemptIndicator1Value  gx:data="cftcclearingexemptIndicator1value"/>
<CFTCClearingExemptIndicator2PartyId  gx:data="cftcclearingexemptIndicator2partyid"/>
<CFTCClearingExemptIndicator2Value  gx:data="cftcclearingexemptIndicator2value"/>
<NewNovatedCFTCMandatoryClearingIndicator  gx:data="newnovatedcftcmandatoryclearingindicator"/>
<NewNovatedCFTCClearingExemptIndicator1PartyId  gx:data="newnovatedcftcclearingexemptindicator1partyId"/>
<NewNovatedCFTCClearingExemptIndicator1Value  gx:data="newnovatedcftcclearingexemptindicator1value"/>
<NewNovatedCFTCClearingExemptIndicator2PartyId  gx:data="newnovatedcftcclearingexemptindicator2partyId"/>
<NewNovatedCFTCClearingExemptIndicator2Value  gx:data="newnovatedcftcclearingexemptindicator2value"/>
<PBEBTradeCFTCMandatoryClearingIndicator  gx:data="pbebtradecftcmandatoryclearingindicator"/>
<PBEBTradeJFSAMandatoryClearingIndicator  gx:data="pbebtradejfsamandatoryclearingindicator"/>
<PBEBTradeCFTCClearingExemptIndicator1PartyId  gx:data="pbebtradecftcclearingexemptindicator1partyId"/>
<PBEBTradeCFTCClearingExemptIndicator1Value  gx:data="pbebtradecftcclearingexemptindicator1value"/>
<PBEBTradeCFTCClearingExemptIndicator2PartyId  gx:data="ptebtradecftcclearingexemptindicator2partyId"/>
<PBEBTradeCFTCClearingExemptIndicator2Value  gx:data="pbebtradecftcclearingexemptindicator2value"/>
<PBClientTradeCFTCMandatoryClearingIndicator  gx:data="PBClientTradecftcmandatoryclearingindicator"/>
<PBClientTradeJFSAMandatoryClearingIndicator  gx:data="PBClientTradejfsamandatoryclearingindicator"/>
<PBClientTradeCFTCClearingExemptIndicator1PartyId  gx:data="pblclientradecftcclearingexemptindicator1partyId"/>
<PBClientTradeCFTCClearingExemptIndicator1Value  gx:data="pbclienttradecftcclearingexemptindicator1value"/>
<PBClientTradeCFTCClearingExemptIndicator2PartyId  gx:data="pbclienttradecftcclearingexemptindicator2partyId"/>
<PBClientTradeCFTCClearingExemptIndicator2Value  gx:data="pbclienttradecftcclearingexemptindicator2value"/>
<MASMandatoryClearingIndicator gx:data="masmandatoryclearingindicator"/>
<NewNovatedMASMandatoryClearingIndicator gx:data="newnovatedmasmandatoryclearingindicator"/>
<PBEBTradeMASMandatoryClearingIndicator  gx:data="pbebtrademasmandatoryclearingindicator"/>
<PBClientTradeMASMandatoryClearingIndicator  gx:data="PBClientTrademasmandatoryclearingindicator"/>
<ClearingHouseId                  gx:data="clearinghouseid"/>
<ClearingBrokerId                 gx:data="clearingbrokerid"/>
<BackLoadingFlag                  gx:data="ratesbackloadingflag"/>
<Novation>false</Novation>
<PartialNovation>false</PartialNovation>
<FourWayNovation/>
<NovationTradeDate                 gx:data="novationtradedate"           gx:format="date"/>
<NovationDate                      gx:data="novationdate"                gx:format="date"/>
<NovatedAmount                     gx:data="novatedamount"/>
<NovatedAmount_2                   gx:data="novatedamount"/>
<NovatedCurrency                   gx:data="novatedcurrency"/>
<NovatedCurrency_2                 gx:data="novatedcurrency"/>
<NovatedFV                         gx:data="novatedfv"/>
<FullFirstCalculationPeriod        gx:data="fullfirstcalculationperiod"/>
<NonReliance                       gx:data="nonreliance"/>
<PreserveEarlyTerminationProvision gx:data="preserveearlyterminationprovision"/>
<CopyPremiumToNewTrade             gx:data="copypremiumtonewtrade"/>
<CopyInitialRateToNewTradeIfRelevant    gx:data="copyinitialratetonewtradeifrelevant"/>
<IntendedClearingHouse                  gx:data="intendedclearinghouse"/>
<AdditionalPayment>
<PaymentDirectionA gx:data="addpaydirectiona"/>
<Reason            gx:data="addpayreason"/>
<Currency          gx:data="addpaycurrency"/>
<Amount            gx:data="addpayamount"/>
<Date              gx:data="addpaydate" gx:format="date"/>
<Convention        gx:data="addpayconvention"/>
<Holidays          gx:data="addpayholidays"/>
</AdditionalPayment>
<OptionStyle                     gx:data="optionstyle"/>
<OptionType                      gx:data="optiontype"/>
<OptionExpirationDate            gx:data="optionexpirationdate"        gx:format="date"/>
<OptionExpirationDateConvention  gx:data="optionexpirationdateconvention"/>
<OptionHolidayCenters            gx:data="optionholidaycenters"/>
<OptionEarliestTime              gx:data="optionearliesttime"/>
<OptionEarliestTimeHolidayCentre gx:data="optionearliesttimeholidaycentre"/>
<OptionExpiryTime                gx:data="optionexpirytime"/>
<OptionExpiryTimeHolidayCentre   gx:data="optionexpirytimeholidaycentre"/>
<OptionSpecificExpiryTime        gx:data="optionspecificexpirytime"/>
<OptionLocation                  gx:data="optionlocation"/>
<OptionCalcAgent                 gx:data="optioncalcagent"/>
<OptionAutomaticExercise         gx:data="optionautomaticexercise"/>
<OptionThreshold                 gx:data="optionthreshold"/>
<ManualExercise                  gx:data="manualexercise"/>
<OptionWrittenExerciseConf       gx:data="optionwrittenexerciseconf"/>
<PremiumAmount                   gx:data="premiumamount"/>
<PremiumCurrency                 gx:data="premiumcurrency"/>
<PremiumPaymentDate              gx:data="premiumpaymentdate"          gx:format="date"/>
<PremiumHolidayCentres           gx:data="premiumholidaycentres"/>
<Strike                          gx:data="strike"/>
<StrikeCurrency                  gx:data="strikecurrency"/>
<StrikePercentage                gx:data="strikepercentage"/>
<StrikeDate                      gx:data="strikedate"                  gx:format="date"/>
<OptionSettlement                gx:data="optionsettlement"/>
<OptionCashSettlementValuationTime  gx:data="optioncashsettlementvaluationtime"/>
<OptionSpecificValuationTime        gx:data="optionspecificvaluationtime"/>
<OptionCashSettlementValuationDate  gx:data="optioncashsettlementvaluationdate"/>
<OptionCashSettlementPaymentDate    gx:data="optioncashsettlementpaymentdate"/>
<OptionCashSettlementMethod         gx:data="optioncashsettlementmethod"/>
<OptionCashSettlementQuotationRate  gx:data="optioncashsettlementquotationrate"/>
<OptionCashSettlementRateSource     gx:data="optioncashsettlementratesource"/>
<OptionCashSettlementReferenceBanks gx:data="optioncashsettlementreferencebanks"/>
<ClearedPhysicalSettlement          gx:data="clearedphysicalsettlement"/>
<ClearingTakeupClientId             gx:data="clearingtakeupclientid"/>
<ClearingTakeupClientName           gx:data="clearingtakeupclientname"/>
<ClearingTakeupClientTradeId        gx:data="clearingtakeupclienttradeid"/>
<ClearingTakeupExecSrcId            gx:data="clearingtakeupexecsrcid"/>
<ClearingTakeupExecSrcName          gx:data="clearingtakeupexecsrcname"/>
<ClearingTakeupExecSrcTradeId       gx:data="clearingtakeupexecsrctradeid"/>
<ClearingTakeupCorrelationId        gx:data="clearingtakeupcorrelationid"/>
<ClearingTakeupClearingHouseTradeId gx:data="clearingtakeupclearinghousetradeid"/>
<ClearingTakeupOriginatingEvent     gx:data="clearingtakeuporiginatingevent"/>
<ClearingTakeupBlockTradeId         gx:data="clearingtakeupblocktradeid"/>
<ClearingTakeupSentBy               gx:data="clearingtakeupsentby"/>
<ClearingTakeupCreditTokenIssuer    gx:data="clearingtakeupcredittokenissuer"/>
<ClearingTakeupCreditToken          gx:data="clearingtakeupcredittoken"/>
<ClearingTakeupClearingStatus       gx:data="clearingtakeupclearingstatus"/>
<ClearingTakeupVenueLEI             gx:data="clearingtakeupvenuelei"/>
<ClearingTakeupVenueLEIScheme       gx:data="clearingtakeupvenueleischeme"/>
<DocsType                      gx:data="docstype"/>
<DocsSubType                   gx:data="docssubtype"/>
<ContractualDefinitions        gx:data="contractualdefinitions"/>
<ContractualSupplement         gx:data="contractualsupplement"/>
<CanadianSupplement            gx:data="canadiansupplement"/>
<ExchangeTradedContractNearest gx:data="exchangetradedcontractnearest"/>
<RestructuringCreditEvent      gx:data="restructuringcreditevent"/>
<CalculationAgentCity          gx:data="calculationagentcity"/>
<RefEntName                    gx:data="refentname"/>
<RefEntStdId                   gx:data="refentstdid"/>
<REROPairStdId                 gx:data="reropairstdid"/>
<RefOblRERole                  gx:data="refoblrerole"/>
<RefOblSecurityIdType          gx:data="refoblsecurityidtype"/>
<RefOblSecurityId              gx:data="refoblsecurityid"/>
<BloombergID                   gx:data="bloombergid"/>
<RefOblMaturity                gx:data="refoblmaturity"/>
<RefOblCoupon                  gx:data="refoblcoupon"/>
<RefOblPrimaryObligor          gx:data="refoblprimaryobligor"/>
<BorrowerNames                 gx:data="borrowernames"/>
<FacilityType                  gx:data="facilitytype"/>
<CreditAgreementDate           gx:data="creditagreementdate"/>
<IsSecuredList                 gx:data="issecuredlist"/>
<ObligationCategory            gx:data="obligationcategory"/>
<DesignatedPriority            gx:data="designatedpriority"/>
<CreditDateAdjustments>
<Convention                gx:data="convention"/>
<Holidays                  gx:data="holidays"/>
</CreditDateAdjustments>
<OptionalEarlyTermination      gx:data="optionalearlytermination"/>
<ReferencePrice                gx:data="referenceprice"/>
<ReferencePolicy               gx:data="referencepolicy"/>
<PaymentDelay                  gx:data="paymentdelay"/>
<StepUpProvision               gx:data="stepupprovision"/>
<WACCapInterestProvision       gx:data="waccapinterestprovision"/>
<InterestShortfallCapIndicator gx:data="interestshortfallcapindicator"/>
<InterestShortfallCompounding  gx:data="interestshortfallcompounding"/>
<InterestShortfallCapBasis     gx:data="interestshortfallcapbasis"/>
<InterestShortfallRateSource   gx:data="interestshortfallratesource"/>
<MortgagePaymentFrequency      gx:data="mortgagepaymentfrequency"/>
<MortgageFinalMaturity         gx:data="mortgagefinalmaturity"/>
<MortgageOriginalAmount        gx:data="mortgageoriginalamount"/>
<MortgageInitialFactor         gx:data="mortgageinitialfactor"/>
<MortgageSector                gx:data="mortgagesector"/>
<MortgageInsurer               gx:data="mortgageinsurer"/>
<IndexName                     gx:data="indexname"/>
<IndexId                       gx:data="indexid"/>
<IndexAnnexDate                gx:data="indexannexdate"              gx:format="date"/>
<IndexTradedRate               gx:data="indextradedtate"/>
<UpfrontFee                    gx:data="upfrontfee"/>
<UpfrontFeeAmount              gx:data="upfrontfeeamount"/>
<UpfrontFeeDate                gx:data="upfrontfeedate"/>
<UpfrontFeePayer               gx:data="upfrontfeepayer"/>
<AttachmentPoint               gx:data="attachmentpoint"/>
<ExhaustionPoint               gx:data="exhaustionpoint"/>
<PublicationDate               gx:data="publicationdate"             gx:format="date"/>
<MasterAgreementDate           gx:data="masteragreementdate"         gx:format="date"/>
<MasterAgreementVersion/>
<AmendmentTradeDate            gx:data="amendmenttradetate"          gx:format="date"/>
<SettlementCurrency            gx:data="settlementcurrency"/>
<ReferenceCurrency             gx:data="referencecurrency"/>
<SettlementRateOption          gx:data="settlementrateoption"/>
<NonDeliverable                gx:data="nondeliverable"/>
<FxFixingDate>
<FxFixingAdjustableDate gx:data="fxfixingadjustabledate"/>
<FxFixingPeriod         gx:data="fxfixingperiod"/>
<FxFixingDayConvention  gx:data="fxfixingdayconvention"/>
<FxFixingCentres        gx:data="fxfixingcentres"/>
</FxFixingDate>
<SettlementCurrency_2          gx:data="settlementcurrency"/>
<ReferenceCurrency_2           gx:data="referencecurrency"/>
<SettlementRateOption_2        gx:data="settlementrateoption"/>
<FxFixingDate_2>
<FxFixingPeriod_2        gx:data="fxfixingperiod"/>
<FxFixingDayConvention_2 gx:data="fxfixingdayconvention"/>
<FxFixingCentres_2       gx:data="fxfixingcentres"/>
</FxFixingDate_2>
<OutsideNovationTradeDate      gx:data="outsidenovationtradedate"    gx:format="date"/>
<OutsideNovationNovationDate   gx:data="outsidenovationnovationdate" gx:format="date"/>
<OutsideNovationOutgoingParty  gx:data="outsidenovationoutgoingparty"/>
<OutsideNovationIncomingParty  gx:data="outsidenovationincomingparty"/>
<OutsideNovationRemainingParty gx:data="outsidenovationremainingparty"/>
<OutsideNovationFullFirstCalculationPeriod gx:data="outsidenovationfullfirstcalculationperiod"/>
<CalcAgentA               gx:data="calcagenta"/>
<AmendmentType            gx:data="amendmenttype"/>
<CancellationType         gx:data="cancellationtype"/>
<OfflineLeg1              gx:data="offlineleg1"/>
<OfflineLeg2              gx:data="offlineleg2"/>
<OfflineSpread            gx:data="offlinespread"/>
<OfflineSpreadLeg         gx:data="offlinespreadleg"/>
<OfflineSpreadParty       gx:data="offlinespreadparty"/>
<OfflineSpreadDirection   gx:data="offlinespreaddirection"/>
<OfflineAdditionalDetails gx:data="offlineadditioanldetails"/>
<OfflineOrigRef           gx:data="offlineorigref"/>
<OfflineOrigRef_2         gx:data="offlineorigref"/>
<OfflineTradeDesk         gx:data="offlinetradedesk"/>
<OfflineTradeDesk_2       gx:data="offlinetradedesk"/>
<OfflineProductType       gx:data="offlineproducttype"/>
<OfflineExpirationDate    gx:data="offlineexpirationdate"/>
<OfflineOptionType        gx:data="offlineoptiontype"/>
<EquityRic                gx:data="equityric"/>
<OptionQuantity           gx:data="optionquantity"/>
<OptionNumberOfShares     gx:data="optionnumberofshares"/>
<Price                    gx:data="price"/>
<PricePerOptionCurrency   gx:data="priceperoptioncurrency"/>
<ExchangeLookAlike        gx:data="exchangelookalike"/>
<AdjustmentMethod         gx:data="adjustmentmethod"/>
<MasterConfirmationDate   gx:data="masterconfirmationdate"/>
<Multiplier               gx:data="multiplier"/>
<OptionExchange           gx:data="optionexchange"/>
<RelatedExchange          gx:data="relatedexchange"/>
<DefaultSettlementMethod  gx:data="defaultsettlementmethod"/>
<SettlementPriceDefaultElectionMethod gx:data="settlementpricedefaultelectionmethod"/>
<DesignatedContract               gx:data="designatedcontract"/>
<FxDeterminationMethod            gx:data="fxdeterminationmethod"/>
<SWFXRateSource                   gx:data="swfxratesource"/>
<SWFXRateSourcePage               gx:data="swfxratesourcepage"/>
<SWFXHourMinuteTime               gx:data="swfxhourminutetime"/>
<SWFXBusinessCenter               gx:data="swfxbusinesscenter"/>
<SettlementMethodElectionDate     gx:data="settlementmethodelectiondate"/>
<SettlementMethodElectingParty    gx:data="settlementmethodelectingparty"/>
<SettlementDateOffset             gx:data="settlementdateoffset"/>
<SettlementType                   gx:data="settlementtype"/>
<MultipleExchangeIndexAnnex       gx:data="multipleexchangeindexannex"/>
<ComponentSecurityIndexAnnex      gx:data="componentsecurityindexannex"/>
<LocalJurisdiction                gx:data="localjurisdiction"/>
<OptionHedgingDisruption          gx:data="optionhedgingdisruption"/>
<OptionLossOfStockBorrow          gx:data="optionlossofstockborrow"/>
<OptionMaximumStockLoanRate       gx:data="optionmaximumstockloanrate"/>
<OptionIncreasedCostOfStockBorrow gx:data="optionincreasedcostofstockborrow"/>
<OptionInitialStockLoanRate       gx:data="optioninitialstockloanrate"/>
<OptionIncreasedCostOfHedging     gx:data="optionincreasedcostofhedging"/>
<OptionForeignOwnershipEvent      gx:data="optionforeignownershipevent"/>
<OptionEntitlement                gx:data="optionentitlement"/>
<ReferencePriceSource             gx:data="referencepricesource"/>
<ReferencePricePage               gx:data="referencepricepage"/>
<ReferencePriceTime               gx:data="referencepricetime"/>
<ReferencePriceCity               gx:data="referencepricecity"/>
<MinimumNumberOfOptions           gx:data="minimumnumberofoptions"/>
<IntegralMultiple                 gx:data="integralmultiple"/>
<MaximumNumberOfOptions           gx:data="maximumnumberofoptions"/>
<ExerciseCommencementDate         gx:data="exercisecommencementdate"/>
<BermudaExerciseDates             gx:data="bermudaexercisedates"/>
<BermudaFrequency                 gx:data="bermudafrequency"/>
<BermudaFirstDate                 gx:data="bermudafirstdate"/>
<BermudaFinalDate                 gx:data="bermudafinaldate"/>
<LatestExerciseTimeMethod         gx:data="latestexercisetimemethod"/>
<LatestExerciseSpecificTime       gx:data="latestexercisespecifictime"/>
<DcCurrency                       gx:data="dccurrency"/>
<DcDelta                          gx:data="dcdelta"/>
<DcEventTypeA                     gx:data="dceventtypea"/>
<DcExchange                       gx:data="dcexchange"/>
<DcExpiryDate                     gx:data="dcexpirydate"/>
<DcFuturesCode                    gx:data="dcfuturescode"/>
<DcOffshoreCross                  gx:data="dcoffshorecross"/>
<DcOffshoreCrossLocation          gx:data="dcoffshorecrosslocation"/>
<DcPrice                          gx:data="dcprice"/>
<DcQuantity                       gx:data="dcquantity"/>
<DcRequired                       gx:data="dcrequired"/>
<DcRic                            gx:data="dcric"/>
<DcDescription                    gx:data="dcdescription"/>
<AveragingInOut                   gx:data="averaginginout"/>
<AveragingDateTimes               gx:data="averagingdatetimes"/>
<MarketDisruption                 gx:data="marketdisruption"/>
<AveragingFrequency               gx:data="averagingfrequency"/>
<AveragingStartDate               gx:data="averagingstartdate"          gx:format="date"/>
<AveragingEndDate                 gx:data="averagingenddate"            gx:format="date"/>
<AveragingBusinessDayConvention   gx:data="averagingbusinessdayconvention"/>
<ReferenceFXRate                  gx:data="referencefxrate"/>
<HedgeLevel                       gx:data="hedgelevel"/>
<Basis                            gx:data="basis"/>
<ImpliedLevel                     gx:data="impliedlevel"/>
<PremiumPercent                   gx:data="premiumpercent"/>
<StrikePercent                    gx:data="strikepercent"/>
<BaseNotional                     gx:data="basenotional"/>
<BaseNotionalCurrency             gx:data="basenotionalcurrency"/>
<BreakOutTrade                    gx:data="breakouttrade"/>
<SplitCollateral                  gx:data="splitcollateral"/>
<OpenUnits                        gx:data="openunits"/>
<DeclaredCashDividendPercentage   gx:data="declaredcashdividendpercentage"/>
<DeclaredCashEquivalentDividendPercentage gx:data="declaredcashequivalentdividendpercentage"/>
<DividendPayer               gx:data="dividendpayer"/>
<DividendReceiver            gx:data="dividendreceiver"/>
<DividendPeriods             gx:data="dividendperiods"/>
<SpecialDividends            gx:data="specialdividends"/>
<MaterialDividend            gx:data="materialdividend"/>
<FixedPayer                  gx:data="fixedpayer"/>
<FixedReceiver               gx:data="fixedreceiver"/>
<FixedPeriods                gx:data="fixedperiods"/>
<EquityAveragingObservations gx:data="equityaveragingobservations"/>
<EquityInitialSpot           gx:data="equityinitialspot"/>
<EquityCap                   gx:data="equitycap"/>
<EquityCapPercentage         gx:data="equitycappercentage"/>
<EquityFloor                 gx:data="equityfloor"/>
<EquityFloorPercentage       gx:data="equityfloorpercentage"/>
<EquityNotional              gx:data="equitynotional"/>
<EquityNotionalCurrency      gx:data="equitynotionalcurrency"/>
<EquityFrequency             gx:data="equityfrequency"/>
<EquityValuationMethod       gx:data="equityvaluationmethod"/>
<EquityFrequencyConvention   gx:data="equityfrequencyconvention"/>
<EquityFreqFirstDate         gx:data="equityfreqfirstdate"/>
<EquityFreqFinalDate         gx:data="equityfreqfinaldate"/>
<EquityFreqRoll              gx:data="equityfreqroll"/>
<EquityListedValuationDates  gx:data="equitylistedvaluationdates"/>
<EquityListedDatesConvention gx:data="equitylisteddatesconvention"/>
<StrategyType                gx:data="strategytype"/>
<StrategyDeltaLeg            gx:data="strategydeltaleg"/>
<StrategyDeltaQuantity       gx:data="strategydeltaquantity"/>
<StrategyComments            gx:data="strategycomments"/>
<StrategyLegs                gx:data="strategylegs"/>
<VegaNotional                gx:data="veganotional"/>
<ExpectedN                   gx:data="expectedn"/>
<ExpectedNOverride           gx:data="expectednoverride"/>
<VarianceAmount              gx:data="varianceamount"/>
<VarianceStrikePrice         gx:data="variancestrikeprice"/>
<VolatilityStrikePrice       gx:data="volatilitystrikeprice"/>
<VarianceCapIndicator        gx:data="variancecapindicator"/>
<VarianceCapFactor           gx:data="variancecapfactor"/>
<TotalVarianceCap            gx:data="totalvariancecap"/>
<TotalVolatilityCap          gx:data="totalvolatilitycap"/>
<ObservationStartDate        gx:data="observationstartdate"        gx:format="date"/>
<ValuationDate               gx:data="valuationdate"               gx:format="date"/>
<InitialSharePriceOrIndexLevel gx:data="initialsharepriceorindexlevel"/>
<ClosingSharePriceOrClosingIndexLevelIndicator gx:data="closingsharepriceorclosingindexlevelindicator"/>
<FuturesPriceValuation          gx:data="futurespricevaluation"/>
<AllDividends                   gx:data="alldividends"/>
<SettlementCurrencyVegaNotional gx:data="settlementcurrencyveganotional"/>
<VegaFxRate                     gx:data="vegafxrate"/>
<HolidayDates/>
<DispLegs                       gx:data="displegs"/>
<DispLegsSW                     gx:data="displegssw"/>
<BulletIndicator                gx:data="bulletindicator"/>
<DocsSelection                  gx:data="docsselection"/>
<NovationReporting>
<Novated    gx:data="novated"/>
<NewNovated gx:data="newnovated"/>
</NovationReporting>
<InterestLegDrivenIndicator     gx:data="interestlegdrivenindicator"/>
<EquityFrontStub                gx:data="equityfrontstub"/>
<EquityEndStub                  gx:data="equityendstub"/>
<InterestFrontStub              gx:data="interestfrontstub"/>
<InterestEndStub                gx:data="interestendstub"/>
<FixedRateIndicator             gx:data="fixedrateindicator"/>
<EswFixingDateOffset            gx:data="eswfixingdateoffset"/>
<DividendPaymentDates           gx:data="dividendpaymentdates"/>
<DividendPaymentOffset          gx:data="dividendpaymentoffset"/>
<DividendPercentage             gx:data="dividendpercentage"/>
<DividendReinvestment           gx:data="dividendreinvestment"/>
<EswDeclaredCashDividendPercentage gx:data="eswdeclaredcashdividendpercentage"/>
<EswDeclaredCashEquivalentDividendPercentage gx:data="eswdeclaredcashequivalentdividendpercentage"/>
<EswDividendSettlementCurrency gx:data="eswdividendsettlementcurrency"/>
<EswNonCashDividendTreatment   gx:data="eswnoncashdividendtreatment"/>
<EswDividendComposition        gx:data="eswdividendcomposition"/>
<EswSpecialDividends           gx:data="eswspecialdividends"/>
<EswDividendValuationOffset    gx:data="eswdividendvaluationoffset"/>
<EswDividendValuationFrequency gx:data="eswdividendvaluationfrequency"/>
<EswDividendInitialValuation   gx:data="eswdividendinitialvaluation"/>
<EswDividendFinalValuation     gx:data="eswdividendfinalvaluation"/>
<EswDividendValuationDay       gx:data="eswdividendvaluationday"/>
<EswDividendValuationCustomDatesInterim>
<EswDividendValuationCustomDateInterim gx:data="eswdividendvaluationcustomdateinterim"/>
</EswDividendValuationCustomDatesInterim>
<EswDividendValuationCustomDateFinal gx:data="eswdividendvaluationcustomdatefinal"/>
<ExitReason                         gx:data="exitreason"/>
<TransactionDate                    gx:data="transactiondate"             gx:format="date"/>
<EffectiveDate                      gx:data="effectivedate"               gx:format="date"/>
<EquityHolidayCentres               gx:data="equityholidaycentres"/>
<OtherValuationBusinessCenters      gx:data="othervaluationbusinesscenters"/>
<EswFuturesPriceValuation           gx:data="eswfuturespricevaluation"/>
<EswFpvFinalPriceElectionFallback   gx:data="eswfpvfinalpriceelectionfallback"/>
<EswDesignatedMaturity              gx:data="eswdesignatedmaturity"/>
<EswEquityValConvention             gx:data="eswequityvalconvention"/>
<EswInterestFloatConvention         gx:data="eswinterestfloatconvention"/>
<EswInterestFloatDayBasis           gx:data="eswinterestfloatdaybasis"/>
<EswInterestFloatingRateIndex       gx:data="eswinterestfloatingrateindex"/>
<EswInterestFixedRate               gx:data="eswinterestfixedrate"/>
<EswInterestSpreadOverIndex         gx:data="eswinterestspreadoverindex"/>
<EswInterestSpreadOverIndexStep>
<EswInterestSpreadOverIndexStepValue gx:data="eswinterestspreadoverindexstepvalue"/>
<EswInterestSpreadOverIndexStepDate gx:data="eswinterestspreadoverindexstepdate" gx:format="date"/>
</EswInterestSpreadOverIndexStep>
<EswLocalJurisdiction               gx:data="eswlocaljurisdiction"/>
<EswReferencePriceSource            gx:data="eswreferencepricesource"/>
<EswReferencePricePage              gx:data="eswreferencepricepage"/>
<EswReferencePriceTime              gx:data="eswreferencepricetime"/>
<EswReferencePriceCity              gx:data="eswreferencepricecity"/>
<EswNotionalAmount                  gx:data="eswnotionalamount"/>
<EswNotionalCurrency                gx:data="eswnotionalcurrency"/>
<EswOpenUnits                       gx:data="eswopenunits"/>
<FeeIn                              gx:data="feein"/>
<FeeInOutIndicator                  gx:data="feeinoutindicator"/>
<FeeOut                             gx:data="feeout"/>
<FinalPriceDefaultElection          gx:data="finalpricedefaultelection"/>
<FinalValuationDate                 gx:data="finalvaluationdate"          gx:format="date"/>
<FullyFundedAmount                  gx:data="fullyfundedamount"/>
<FullyFundedIndicator               gx:data="fullyfundedindicator"/>
<InitialPrice                       gx:data="initialprice"/>
<InitialPriceElection               gx:data="initialpriceelection"/>
<EquityNotionalReset                gx:data="equitynotionalreset"/>
<EswReferenceInitialPrice           gx:data="eswreferenceinitialprice"/>
<EswReferenceFXRate                 gx:data="eswreferencefxrate"/>
<PaymentDateOffset                  gx:data="paymentdateoffset"/>
<PaymentFrequency                   gx:data="paymentfrequency"/>
<EswFixingHolidayCentres            gx:data="eswfixingholidaycentres"/>
<EswPaymentHolidayCentres           gx:data="eswpaymentholidaycentres"/>
<ReturnType                         gx:data="returntype"/>
<Synthetic                          gx:data="synthetic"/>
<TerminationDate                    gx:data="terminationdate"             gx:format="date"/>
<ValuationDay                       gx:data="valuationday"/>
<PaymentDay                         gx:data="paymentday"/>
<ValuationFrequency                 gx:data="valuationfrequency"/>
<ValuationStartDate                 gx:data="valuationstartdate"          gx:format="date"/>
<EswSchedulingMethod                gx:data="eswschedulingmethod"/>
<EswValuationDates                  gx:data="eswvaluationdates"/>
<EswFixingDates                     gx:data="eswfixingdates"/>
<EswInterestLegPaymentDates         gx:data="eswinterestlegpaymentdates"/>
<EswEquityLegPaymentDates           gx:data="eswequitylegpaymentdates"/>
<EswCompoundingDates                gx:data="eswcompoundingdates"/>
<EswCompoundingMethod               gx:data="eswcompoundingmethod"/>
<EswCompoundingFrequency            gx:data="eswcompoundingfrequency"/>
<EswInterpolationMethod             gx:data="eswinterpolationmethod"/>
<EswInterpolationPeriod             gx:data="eswinterpolationperiod"/>
<EswAveragingDatesIndicator         gx:data="eswaveragingdatesindicator"/>
<EswADTVIndicator                   gx:data="eswadtvindicator"/>
<EswLimitationPercentage            gx:data="eswlimitationpercentage"/>
<EswLimitationPeriod                gx:data="eswlimitationperiod"/>
<EswStockLoanRateIndicator          gx:data="eswstockloanrateindicator"/>
<EswMaximumStockLoanRate            gx:data="eswmaximumstockloanrate"/>
<EswInitialStockLoanRate            gx:data="eswinitialstockloanrate"/>
<EswOptionalEarlyTermination        gx:data="eswoptionalearlytermination"/>
<EswBreakFundingRecovery            gx:data="eswbreakfundingrecovery"/>
<EswBreakFeeElection                gx:data="eswbreakfeeelection"/>
<EswBreakFeeRate                    gx:data="eswbreakfeerate"/>
<EswFinalPriceFee                   gx:data="eswfinalpricefee"/>
<EswEarlyFinalValuationDateElection gx:data="eswearlyfinalvaluationdateelection"/>
<EswEarlyTerminationElectingParty   gx:data="eswearlyterminationelectingparty"/>
<EswInsolvencyFiling                gx:data="eswinsolvencyfiling"/>
<EswLossOfStockBorrow               gx:data="eswlossofstockborrow"/>
<EswIncreasedCostOfStockBorrow      gx:data="eswincreasedcostofstockborrow"/>
<EswBulletCompoundingSpread         gx:data="eswbulletcompoundingspread"/>
<EswSpecifiedExchange               gx:data="eswspecifiedexchange"/>
<EswCorporateActionFlag             gx:data="eswcorporateactionflag"/>
<NCCreditProductType                gx:data="nccreditproducttype"/>
<NCIndivTradeSummary>
<NCIndivNCMId/>
<NCIndivMWId/>
<NCIndivORFundId/>
<NCIndivORFund/>
<NCIndivRPFundId/>
<NCIndivRPFund/>
<NCIndivEEFundId/>
<NCIndivEEFund/>
<NCIndivNotionalAmount/>
<NCIndivNotionalCurrency/>
<NCIndivFeeAmount/>
<NCIndivFeeCurrency/>
<NCIndivStatus/>
</NCIndivTradeSummary>
<NCNovationBlockID           gx:data="ncnovationblockid"/>
<NCNCMID                     gx:data="ncncmid"/>
<NCRPOldTRN                  gx:data="ncrpoldtrn"/>
<NCCEqualsCEligible          gx:data="nccequalsceligible"/>
<NCSummaryLinkID             gx:data="ncsummarylinkid"/>
<NCORFundId                  gx:data="ncorfundid"/>
<NCORFundName                gx:data="ncorfundname"/>
<NCRPFundId                  gx:data="ncrpfundid"/>
<NCRPFundName                gx:data="ncrpfundname"/>
<NCEEFundId                  gx:data="nceefundid"/>
<NCEEFundName                gx:data="nceefundname"/>
<NCRecoveryFactor            gx:data="ncrecoveryfactor"/>
<NCFixedSettlement           gx:data="ncfixedsettlement"/>
<NCSwaptionDocsType          gx:data="ncswaptiondocstype"/>
<NCAdditionalMatrixProvision gx:data="ncadditionalmatrixprovision"/>
<NCSwaptionPublicationDate   gx:data="ncswaptionpublicationdate"/>
<NCOptionDirectionA          gx:data="ncoptiondirectiona"/>
<TIWDTCCTRI            gx:data="tiwdtcctri"/>
<TIWActiveStatus       gx:data="tiwactivestatus"/>
<TIWValueDate          gx:data="tiwvaluedate"/>
<TIWAsOfDate           gx:data="tiwasofdate"/>
<EquityBackLoadingFlag gx:data="equitybackloadingflag"/>
<MigrationReferences   gx:data="migrationreferences"/>
<Rule15A-6             gx:data="rule15a"/>
<HedgingParty          gx:data="hedgingparty"/>
<DeterminingParty      gx:data="determiningparty"/>
<CalculationAgent      gx:data="calculationagent"/>
<IndependentAmount2>
<Payer/>
<Currency/>
<Amount/>
</IndependentAmount2>
<NotionalFutureValue gx:data="notionalfuturevalue"/>
<NotionalSchedule    gx:data="notionalschedule"/>
<SendForPublishing/>
<SubscriberId/>
<ModifiedEquityDelivery/>
<SettledEntityMatrixSource/>
<SettledEntityMatrixDate/>
<AdditionalTerms/>
<ReportingData>
<PriorUSI/>
<UPI/>
</ReportingData>
<ExecutionType                           gx:data="executiontype"/>
<PriceNotationType                       gx:data="pricenotationtype"/>
<PriceNotationValue                      gx:data="pricenotationvalue"/>
<AdditionalPriceNotationType             gx:data="additionalpricenotationtype"/>
<AdditionalPriceNotationValue            gx:data="additionalpricenotationvalue"/>
<DFDataPresent                           gx:data="dfdatapresent"/>
<DFRegulatorType                         gx:data="dfregulatortype"/>
<USINamespace                            gx:data="usinamespace"/>
<USINamespacePrefix                      gx:data="usinamespaceprefix"/>
<USI                                     gx:data="usi"/>
<ObligatoryReporting                     gx:data="obligatoryreporting"/>
<SecondaryAssetClass                     gx:data="secondaryassetclass"/>
<ReportingCounterparty                   gx:data="reportingcounterparty"/>
<DFClearingMandatory                     gx:data="dfclearingmandatory"/>
<NewNovatedPriceNotationType             gx:data="newnovatedpricenotationtype"/>
<NewNovatedPriceNotationValue            gx:data="newnovatedpricenotationvalue"/>
<NewNovatedAdditionalPriceNotationType   gx:data="newnovatedadditionalpricenotationtype"/>
<NewNovatedAdditionalPriceNotationValue  gx:data="newnovatedadditionalpricenotationvalue"/>
<NewNovatedDFDataPresent                 gx:data="newnovateddfdatapresent"/>
<NewNovatedDFRegulatorType               gx:data="newnovateddfregulatortype"/>
<NewNovatedUSINamespace                  gx:data="newnovatedusinamespace"/>
<NewNovatedUSINamespacePrefix            gx:data="newnovatedusinamespaceprefix"/>
<NewNovatedUSI                           gx:data="newnovatedusi"/>
<NewNovatedObligatoryReporting           gx:data="newnovatedobligatoryreporting"/>
<NewNovatedReportingCounterparty         gx:data="newnovatedreportingcounterparty"/>
<NewNovatedDFClearingMandatory           gx:data="newnovateddfclearingmandatory"/>
<NovationFeePriceNotationType            gx:data="novationfeepricenotationtype"/>
<NovationFeePriceNotationValue           gx:data="novationfeepricenotationvalue"/>
<NovationFeeAdditionalPriceNotationType  gx:data="novationfeeadditionalpricenotationtype"/>
<NovationFeeAdditionalPriceNotationValue gx:data="novationfeeadditionalpricenotationvalue"/>
<NovationFeeDFDataPresent                gx:data="novationfeedfdatapresent"/>
<NovationFeeDFRegulatorType              gx:data="novationfeedfregulatortype"/>
<NovationFeeUSINamespace                 gx:data="novationfeeusinamespace"/>
<NovationFeeUSINamespacePrefix           gx:data="novationfeeusinamespaceprefix"/>
<NovationFeeUSI                          gx:data="novationfeeusi"/>
<NovationFeeObligatoryReporting          gx:data="novationfeeobligatoryreporting"/>
<NovationFeeReportingCounterparty        gx:data="novationfeereportingcounterparty"/>
<NovationFeeDFClearingMandatory          gx:data="novationfeedfclearingmandatory"/>
<DFEmbeddedOptionType/>
<GenProdPrimaryAssetClass/>
<GenProdSecondaryAssetClass/>
<ProductId/>
<OptionDirectionA/>
<OptionPremium/>
<OptionPremiumCurrency/>
<OptionStrike/>
<OptionStrikeType/>
<OptionStrikeCurrency/>
<FirstExerciseDate/>
<FloatingDayCountConvention/>
<DayCountConvention/>
<GenProdUnderlyer>
<UnderlyerType/>
<UnderlyerDescription/>
<UnderlyerDirectionA/>
<UnderlyerFixedRate/>
<UnderlyerIDCode/>
<UnderlyerIDType/>
<UnderlyerReferenceCurrency/>
<UnderlyerFXCurrency/>
</GenProdUnderlyer>
<GenProdNotional>
<NotionalCurrency/>
<NotionalUnit/>
<Notional/>
</GenProdNotional>
<ResetFrequency/>
<DayCountFraction>
<Schema/>
<Fraction/>
</DayCountFraction>
<DurationType/>
<RateCalcType/>
<SecurityType/>
<OpenRepoRate/>
<OpenRepoSpread/>
<OpenCashAmount/>
<OpenDeliveryMethod/>
<OpenSecurityNominal/>
<OpenSecurityQuantity/>
<CloseDeliveryMethod/>
<CloseSecurityNominal/>
<CloseSecurityQuantity/>
<DayCountBasis/>
<SecurityIDType/>
<SecurityID/>
<SecurityCurrency/>
</SWDMLTrade>
</gx:template>
<xsl:variable name="allocation"
select="/SWGenericXML/data[@name='Allocation']"/>
<xsl:template match="AllocatedTrade">
<xsl:call-template name="gx:elem">
<xsl:with-param name="value" select="$allocation"/>
</xsl:call-template>
</xsl:template>
<xsl:template match="Allocation">
<xsl:call-template name="gx:continue-with">
<xsl:with-param name="rows" select="$allocation"/>
</xsl:call-template>
</xsl:template>
<xsl:variable name="additionalPayments"
select="/SWGenericXML/data[@name='AdditionalPayment']"/>
<xsl:template match="AdditionalPayment">
<xsl:call-template name="gx:continue-with">
<xsl:with-param name="rows" select="$additionalPayments"/>
</xsl:call-template>
</xsl:template>
<xsl:variable name="trade" select="/SWGenericXML/data[@name='Trade']"/>
<xsl:variable name="productType" select="$trade/data[@name='producttype']"/>
<xsl:template match="Allocation/Payer | Allocation/Receiver">
<xsl:param name="row"/>
<xsl:if test="$productType[. = 'Single Currency Interest Rate Swap' or
. = 'OIS']">
<xsl:call-template name="gx:elem">
<xsl:with-param name="row" select="."/>
</xsl:call-template>
</xsl:if>
</xsl:template>
<xsl:template match="Allocation/Buyer | Allocation/Seller">
<xsl:param name="row"/>
<xsl:if
test="not($productType[. = 'Single Currency Interest Rate Swap' or
. = 'OIS'])">
<xsl:call-template name="gx:elem">
<xsl:with-param name="row" select="."/>
</xsl:call-template>
</xsl:if>
</xsl:template>
<xsl:template match="SalesCredit">
<xsl:param name="row"/>
<xsl:if test="$row/data[@name = 'allocsalescredit'] = 'true'">
<xsl:call-template name="gx:elem">
<xsl:with-param name="row" select="."/>
</xsl:call-template>
</xsl:if>
</xsl:template>
<xsl:template match="/">
<xsl:call-template name="gx:start">
<xsl:with-param name="row" select="$trade"/>
</xsl:call-template>
</xsl:template>
</xsl:stylesheet>
