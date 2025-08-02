<?xml version="1.0"?>
<xsl:stylesheet
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:fpml="http://www.fpml.org/2004/FpML-4-1"
xmlns:common="http://exslt.org/common"
xmlns:mwrpt="http://www.markitserv.com/swbml-extract-reporting.xsl"
exclude-result-prefixes="fpml common mwrpt"
version="1.0">
<xsl:import href="swbml-extract-reporting.xsl"/>
<xsl:output method="xml"/>
<xsl:variable name="reportingData.rtf">
<xsl:apply-templates select="/fpml:SWBML/fpml:swbTradeEventReportingDetails/node()" mode="mapReportingData"/>
</xsl:variable>
<xsl:variable name="partyIdentifiers.rtf">
<xsl:apply-templates select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/node()" mode="mapReportingData"/>
</xsl:variable>
<xsl:variable name="extendedTradeDetails.rtf">
<xsl:apply-templates select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/node()" mode="mapReportingData"/>
</xsl:variable>
<xsl:template match="/|comment()|processing-instruction()" mode="mapReportingData">
<xsl:copy>
<xsl:apply-templates mode="mapReportingData"/>
</xsl:copy>
</xsl:template>
<xsl:template match="*" mode="mapReportingData">
<xsl:element name="{local-name()}">
<xsl:apply-templates select="@*|node()" mode="mapReportingData"/>
</xsl:element>
</xsl:template>
<xsl:template match="@*" mode="mapReportingData">
<xsl:attribute name="{local-name()}"><xsl:value-of select="."/></xsl:attribute>
</xsl:template>
<xsl:template match="/">
<xsl:apply-templates select="fpml:SWBML" mode="get-reporting-data"/>
</xsl:template>
<xsl:template match="/fpml:SWBML[function-available('common:node-set')]" mode="get-reporting-data">
<xsl:apply-templates select=".">
<xsl:with-param name="reportingData" select="common:node-set($reportingData.rtf)"/>
<xsl:with-param name="extendedTradeDetails" select="common:node-set($extendedTradeDetails.rtf)"/>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="/fpml:SWBML[not(function-available('common:node-set'))]" mode="get-reporting-data">
<xsl:apply-templates select=".">
<xsl:with-param name="reportingData" select="$reportingData.rtf"/>
<xsl:with-param name="extendedTradeDetails" select="$extendedTradeDetails.rtf"/>
</xsl:apply-templates>
</xsl:template>
<xsl:variable name="floatingLeg">
<xsl:choose>
<xsl:when test="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[1]/fpml:resetDates">1</xsl:when>
<xsl:otherwise>2</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="fixedLeg">
<xsl:choose>
<xsl:when test="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[1]/fpml:resetDates">2</xsl:when>
<xsl:otherwise>1</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="floatingLegId" select="string(/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/@id)"/>
<xsl:variable name="fixedLegId" select="string(/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$fixedLeg]/@id)"/>
<xsl:variable name="partyA">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:buyerPartyReference/@href"/>
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:swap/fpml:swapStream[position()=$fixedLeg]/fpml:payerPartyReference/@href"/>
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:fra/fpml:buyerPartyReference/@href"/>
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:capFloor/fpml:capFloorStream/fpml:receiverPartyReference/@href"/>
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:swaption/fpml:buyerPartyReference/@href"/>
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:buyerPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="partyB">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:sellerPartyReference/@href"/>
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:payerPartyReference/@href"/>
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:fra/fpml:sellerPartyReference/@href"/>
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:capFloor/fpml:capFloorStream/fpml:payerPartyReference/@href"/>
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:swaption/fpml:sellerPartyReference/@href"/>
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:sellerPartyReference/@href"/>
</xsl:variable>
<xsl:template match="fpml:SWBML">
<xsl:param name="reportingData"/>
<xsl:param name="extendedTradeDetails"/>
<xsl:variable name="reportingAllocationData.rtf">
<xsl:apply-templates select="fpml:swbAllocationReportingDetails/node()" mode="mapReportingData"/>
</xsl:variable>
<xsl:variable name="isPrimeBrokered">
<xsl:choose>
<xsl:when test="fpml:swbGiveUp">1</xsl:when>
<xsl:otherwise>0</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<Trade version="4-1">
<SWBMLVersion>
<xsl:value-of select="@version"/>
</SWBMLVersion>
<xsl:variable name="productType" select="string(fpml:swbStructuredTradeDetails/fpml:swbProductType)"/>
<BrokerSubmitted>true</BrokerSubmitted>
<BrokerTradeId>
<xsl:value-of select="fpml:swbHeader/fpml:swbBrokerTradeId"/>
</BrokerTradeId>
<TotalLegs/>
<BrokerLegId>
<xsl:value-of select="fpml:swbHeader/fpml:swbBrokerLegId"/>
</BrokerLegId>
<StrategyType/>
<StrategyComment/>
<BrokerTradeVersionId>
<xsl:value-of select="fpml:swbHeader/fpml:swbBrokerTradeVersionId"/>
</BrokerTradeVersionId>
<LinkedTradeId/>
<TradeSource>
<xsl:choose>
<xsl:when test="fpml:swbHeader/fpml:swbTradeSource">
<xsl:value-of select="fpml:swbHeader/fpml:swbTradeSource"/>
</xsl:when>
<xsl:otherwise>Voice</xsl:otherwise>
</xsl:choose>
</TradeSource>
<xsl:for-each select="/fpml:SWBML/fpml:swbHeader/fpml:swbVenueId">
<VenueId>
<xsl:value-of select="."/>
</VenueId>
<xsl:for-each select="@swbVenueIdScheme">
<xsl:call-template name="mwrpt:mapVenueIdScheme"/>
</xsl:for-each>
</xsl:for-each>
<MessageText>
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbMessageText"/>
</MessageText>
<xsl:if test="not(/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbTradeHeader/fpml:swbClearingHouse/fpml:partyId)">
<xsl:variable name="swbSettlementAgent" select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbSettlementAgent"/>
<SettlementAgency>
<xsl:value-of select="$swbSettlementAgent/fpml:swbSettlementAgency/fpml:partyId"/>
</SettlementAgency>
<SettlementAgencyModel>
<xsl:value-of select="$swbSettlementAgent/fpml:swbSettlementAgencyModel"/>
</SettlementAgencyModel>
<PBEBSettlementAgency>
<xsl:value-of select="/fpml:SWBML/fpml:swbGiveUp/fpml:swbInterDealerTransaction/fpml:swbSettlementAgent/fpml:swbSettlementAgency/fpml:partyId"/>
</PBEBSettlementAgency>
<PBEBSettlementAgencyModel>
<xsl:value-of select="/fpml:SWBML/fpml:swbGiveUp/fpml:swbInterDealerTransaction/fpml:swbSettlementAgent/fpml:swbSettlementAgencyModel"/>
</PBEBSettlementAgencyModel>
<PBClientSettlementAgency>
<xsl:value-of select="/fpml:SWBML/fpml:swbGiveUp/fpml:swbCustomerTransaction/fpml:swbSettlementAgent/fpml:swbSettlementAgency/fpml:partyId"/>
</PBClientSettlementAgency>
<PBClientSettlementAgencyModel>
<xsl:value-of select="/fpml:SWBML/fpml:swbGiveUp/fpml:swbCustomerTransaction/fpml:swbSettlementAgent/fpml:swbSettlementAgencyModel"/>
</PBClientSettlementAgencyModel>
</xsl:if>
<AllocatedTrade/>
<Allocation>
<Payer/>
<Receiver/>
<swbStreamReference/>
<AllocatedNotional>
<Currency/>
<Amount/>
</AllocatedNotional>
<AllocatedNumberOfOptions/>
<AllocatedVegaNotional/>
<AllocatedVarianceAmount/>
<AllocatedUnits/>
<AllocationIndependentAmount>
<Payer/>
<Currency/>
<Amount/>
</AllocationIndependentAmount>
<swbBrokerTradeId/>
<AllocationOtherPartyPayment>
<Payer/>
<Receiver/>
<Currency/>
<Amount/>
</AllocationOtherPartyPayment>
<AllocationClearingBroker>
<EBClearingBroker/>
<ClearingNettingParty/>
</AllocationClearingBroker>
<AllocationPartyAClearingBroker/>
<AllocationPartyBClearingBroker/>
<AllocationPayerClearingBroker/>
<AllocationReceiverClearingBroker/>
<AllocationNettingParty/>
<AllocationNettingString/>
<AllocationNettingParty_2/>
<AllocationNettingString_2/>
<xsl:apply-templates select="/fpml:SWBML/fpml:swbAllocations/fpml:swbAllocation/fpml:swbPartyClearingDetails"/>
<xsl:choose>
<xsl:when test="function-available('common:node-set')">
<xsl:call-template name="outputAllocationReportingFields">
<xsl:with-param name="reportingAllocationData" select="common:node-set($reportingAllocationData.rtf)"/>
<xsl:with-param name="partyIdentifiers" select="common:node-set($partyIdentifiers.rtf)"/>
</xsl:call-template>
</xsl:when>
<xsl:otherwise>
<xsl:call-template name="outputAllocationReportingFields">
<xsl:with-param name="reportingAllocationData" select="$reportingAllocationData.rtf"/>
<xsl:with-param name="partyIdentifiers" select="$partyIdentifiers.rtf"/>
</xsl:call-template>
</xsl:otherwise>
</xsl:choose>
</Allocation>
<EmptyBlockTrade/>
<PrimeBrokerTrade/>
<ReversePrimeBrokerLegalEntities/>
<xsl:apply-templates select="fpml:swbHeader/fpml:swbRecipient"/>
<PartyAId>
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:party[@id=$partyA]/fpml:partyId"/>
</PartyAId>
<PartyAName>
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:party[@id=$partyA]/fpml:partyId/@partyIdScheme"/>
</PartyAName>
<PartyAName>
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:party[@id=$partyA]/fpml:partyName"/>
</PartyAName>
<PartyBId>
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:party[@id=$partyB]/fpml:partyId"/>
</PartyBId>
<PartyBName>
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:party[@id=$partyB]/fpml:partyId/@partyIdScheme"/>
</PartyBName>
<PartyBName>
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:party[@id=$partyB]/fpml:partyName"/>
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
<BrokerAId>
<xsl:variable name="broker1" select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:otherPartyPayment[1]/fpml:receiverPartyReference/@href"/>
<xsl:attribute name="id"><xsl:value-of select="$broker1"/></xsl:attribute>
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:party[@id=$broker1]/fpml:partyId"/>
</BrokerAId>
<BrokerBId>
<xsl:variable name="broker2" select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:otherPartyPayment[2]/fpml:receiverPartyReference/@href"/>
<xsl:attribute name="id"><xsl:value-of select="$broker2"/></xsl:attribute>
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:party[@id=$broker2]/fpml:partyId"/>
</BrokerBId>
<NominalTerm>
<xsl:choose>
<xsl:when test="$productType='CDS Index'">
<xsl:variable name="effDateYear" select="string(substring(fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:effectiveDate/fpml:unadjustedDate,1,4))"/>
<xsl:variable name="termDateYear" select="string(substring(fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:scheduledTerminationDate/fpml:adjustableDate/fpml:unadjustedDate,1,4))"/>
<xsl:variable name="effDateMonth" select="string(substring(fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:effectiveDate/fpml:unadjustedDate,6,2))"/>
<xsl:variable name="termDateMonth" select="string(substring(fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:scheduledTerminationDate/fpml:adjustableDate/fpml:unadjustedDate,6,2))"/>
<xsl:variable name="termInMonths" select="string(((number($termDateYear)-number($effDateYear))*12)+number($termDateMonth)-number($effDateMonth))"/>
<xsl:choose>
<xsl:when test="number($termInMonths)&gt;=120">10Y</xsl:when>
<xsl:when test="number($termInMonths)&gt;=84">7Y</xsl:when>
<xsl:when test="number($termInMonths)&gt;=60">5Y</xsl:when>
<xsl:when test="number($termInMonths)&gt;=48">4Y</xsl:when>
<xsl:when test="number($termInMonths)&gt;=36">3Y</xsl:when>
<xsl:when test="number($termInMonths)&gt;=24">2Y</xsl:when>
<xsl:otherwise>1Y</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbProductTerm/fpml:periodMultiplier"/>
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbProductTerm/fpml:period"/>
</xsl:otherwise>
</xsl:choose>
</NominalTerm>
<FixedRatePayer>A</FixedRatePayer>
<FloatingRatePayer/>
<TradeDate>
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string(fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:tradeHeader/fpml:tradeDate)"/>
</xsl:call-template>
</TradeDate>
<StartDate>
<xsl:variable name="startDate">
<xsl:choose>
<xsl:when test="$productType='SingleCurrencyInterestRateSwap' or $productType='OIS' or $productType='Swaption'">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string(fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodDates/fpml:effectiveDate/fpml:unadjustedDate)"/>
</xsl:call-template>
</xsl:when>
<xsl:when test="$productType='FRA'">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string(fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:fra/fpml:adjustedEffectiveDate)"/>
</xsl:call-template>
</xsl:when>
<xsl:when test="$productType='CapFloor'">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string(fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:capFloor/fpml:capFloorStream/fpml:calculationPeriodDates/fpml:effectiveDate/fpml:unadjustedDate)"/>
</xsl:call-template>
</xsl:when>
<xsl:when test="$productType='CDS' or $productType='CDS Index'">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string(fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:effectiveDate/fpml:unadjustedDate)"/>
</xsl:call-template>
</xsl:when>
</xsl:choose>
</xsl:variable>
<xsl:value-of select="$startDate"/>
</StartDate>
<EndDate>
<xsl:variable name="endDate">
<xsl:choose>
<xsl:when test="$productType='SingleCurrencyInterestRateSwap' or $productType='OIS' or $productType='Swaption'">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string(fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodDates/fpml:terminationDate/fpml:unadjustedDate)"/>
</xsl:call-template>
</xsl:when>
<xsl:when test="$productType='FRA'">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string(fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:fra/fpml:adjustedTerminationDate)"/>
</xsl:call-template>
</xsl:when>
<xsl:when test="$productType='CapFloor'">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string(fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:capFloor/fpml:capFloorStream/fpml:calculationPeriodDates/fpml:terminationDate/fpml:unadjustedDate)"/>
</xsl:call-template>
</xsl:when>
<xsl:when test="$productType='CDS' or $productType='CDS Index'">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string(fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:scheduledTerminationDate/fpml:adjustableDate/fpml:unadjustedDate)"/>
</xsl:call-template>
</xsl:when>
</xsl:choose>
</xsl:variable>
<xsl:value-of select="$endDate"/>
</EndDate>
<xsl:variable name="termPeriodMultiplier" select="string(fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbProductTerm/fpml:periodMultiplier)"/>
<xsl:variable name="termPeriod" select="string(fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbProductTerm/fpml:period)"/>
<FixedPaymentFreq>
<xsl:choose>
<xsl:when test="$productType='OIS' and (($termPeriod='M' and $termPeriodMultiplier &lt; '12') or $termPeriod='W')">1T</xsl:when>
<xsl:otherwise>
<xsl:choose>
<xsl:when test="$productType='SingleCurrencyInterestRateSwap' or $productType='OIS' or $productType='Swaption'">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$fixedLeg]/fpml:paymentDates/fpml:paymentFrequency/fpml:periodMultiplier"/>
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$fixedLeg]/fpml:paymentDates/fpml:paymentFrequency/fpml:period"/>
</xsl:when>
<xsl:when test="$productType='CDS'">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:feeLeg/fpml:periodicPayment/fpml:paymentFrequency/fpml:periodMultiplier"/>
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:feeLeg/fpml:periodicPayment/fpml:paymentFrequency/fpml:period"/>
</xsl:when>
</xsl:choose>
</xsl:otherwise>
</xsl:choose>
</FixedPaymentFreq>
<FloatPaymentFreq>
<xsl:choose>
<xsl:when test="$productType='OIS' and (($termPeriod='M' and $termPeriodMultiplier &lt; '12') or $termPeriod='W')">1T</xsl:when>
<xsl:otherwise>
<xsl:choose>
<xsl:when test="$productType='SingleCurrencyInterestRateSwap' or $productType='OIS' or $productType = 'Swaption'">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:paymentDates/fpml:paymentFrequency/fpml:periodMultiplier"/>
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:paymentDates/fpml:paymentFrequency/fpml:period"/>
</xsl:when>
<xsl:when test="$productType='CapFloor'">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:capFloor/fpml:capFloorStream/fpml:paymentDates/fpml:paymentFrequency/fpml:periodMultiplier"/>
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:capFloor/fpml:capFloorStream/fpml:paymentDates/fpml:paymentFrequency/fpml:period"/>
</xsl:when>
</xsl:choose>
</xsl:otherwise>
</xsl:choose>
</FloatPaymentFreq>
<FloatPaymentFreq_2/>
<FloatRollFreq>
<xsl:choose>
<xsl:when test="$productType='OIS' and (($termPeriod='M' and $termPeriodMultiplier &lt; '12') or $termPeriod='W')">1T</xsl:when>
<xsl:otherwise>
<xsl:choose>
<xsl:when test="$productType='SingleCurrencyInterestRateSwap' or $productType='OIS' or $productType = 'Swaption'">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:periodMultiplier"/>
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:period"/>
</xsl:when>
<xsl:when test="$productType='CapFloor'">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:capFloor/fpml:capFloorStream/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:periodMultiplier"/>
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:capFloor/fpml:capFloorStream/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:period"/>
</xsl:when>
</xsl:choose>
</xsl:otherwise>
</xsl:choose>
</FloatRollFreq>
<FloatRollFreq_2/>
<RollsType>
<xsl:choose>
<xsl:when test="$productType='SingleCurrencyInterestRateSwap' or $productType='OIS' or $productType='Swaption'">
<xsl:variable name="rollConvention" select="string(fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:rollConvention)"/>
<xsl:choose>
<xsl:when test="$rollConvention='IMM'">IMM</xsl:when>
<xsl:otherwise>Standard</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType='CapFloor'">
<xsl:variable name="rollConvention" select="string(fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:capFloor/fpml:capFloorStream/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:rollConvention)"/>
<xsl:choose>
<xsl:when test="$rollConvention='IMM'">IMM</xsl:when>
<xsl:otherwise>Standard</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType='CDS'">
<xsl:variable name="rollConvention" select="string(fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:feeLeg/fpml:periodicPayment/fpml:rollConvention)"/>
<xsl:variable name="termDateMMDD" select="string(substring(fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:scheduledTerminationDate/fpml:adjustableDate/fpml:unadjustedDate,6,5))"/>
<xsl:choose>
<xsl:when test="($rollConvention='20' and ($termDateMMDD='03-20' or $termDateMMDD='06-20' or $termDateMMDD='09-20' or $termDateMMDD='12-20') and not(fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:feeLeg/fpml:periodicPayment/fpml:lastRegularPaymentDate)) or not(fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:feeLeg/fpml:periodicPayment)">Standard</xsl:when>
<xsl:otherwise>Custom</xsl:otherwise>
</xsl:choose>
</xsl:when>
</xsl:choose>
</RollsType>
<RollsMethod/>
<RollDay>
<xsl:if test="$productType='SingleCurrencyInterestRateSwap' or $productType='OIS' or $productType='Swaption' or $productType='CapFloor' or $productType='CDS'">
<xsl:choose>
<xsl:when test="$productType='OIS' and (($termPeriod='M' and $termPeriodMultiplier &lt; '12') or $termPeriod='W')">NONE</xsl:when>
<xsl:when test="$productType='CapFloor'">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:capFloor/fpml:capFloorStream/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:rollConvention"/>
</xsl:when>
<xsl:when test="$productType='CDS'">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:feeLeg/fpml:periodicPayment/fpml:rollConvention"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:rollConvention"/>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</RollDay>
<MonthEndRolls>
<xsl:if test="$productType='SingleCurrencyInterestRateSwap' or $productType='OIS' or $productType='Swaption' or $productType='CapFloor' or $productType='CDS'">
<xsl:variable name="rollConvention">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:rollConvention"/>
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:capFloor/fpml:capFloorStream/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:rollConvention"/>
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:feeLeg/fpml:periodicPayment/fpml:rollConvention"/>
</xsl:variable>
<xsl:value-of select="string(boolean($rollConvention='EOM'))"/>
</xsl:if>
</MonthEndRolls>
<FirstPeriodStartDate/>
<FirstPaymentDate>
<xsl:if test="$productType='CDS' and fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:feeLeg/fpml:periodicPayment">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string(fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:feeLeg/fpml:periodicPayment/fpml:firstPaymentDate)"/>
</xsl:call-template>
</xsl:if>
</FirstPaymentDate>
<LastRegularPaymentDate>
<xsl:if test="$productType='CDS' and fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:feeLeg/fpml:periodicPayment/fpml:lastRegularPaymentDate">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string(fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:feeLeg/fpml:periodicPayment/fpml:lastRegularPaymentDate)"/>
</xsl:call-template>
</xsl:if>
</LastRegularPaymentDate>
<FixedRate>
<xsl:choose>
<xsl:when test="$productType='SingleCurrencyInterestRateSwap' or $productType='OIS' or $productType='Swaption'">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$fixedLeg]/fpml:calculationPeriodAmount/fpml:calculation/fpml:fixedRateSchedule/fpml:initialValue"/>
</xsl:when>
<xsl:when test="$productType='FRA'">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:fra/fpml:fixedRate"/>
</xsl:when>
<xsl:when test="$productType='CDS' or $productType='CDS Index'">
<xsl:choose>
<xsl:when test="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:feeLeg/fpml:periodicPayment">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:feeLeg/fpml:periodicPayment/fpml:fixedAmountCalculation/fpml:fixedRate"/>
</xsl:when>
<xsl:otherwise>0</xsl:otherwise>
</xsl:choose>
</xsl:when>
</xsl:choose>
</FixedRate>
<initialPoints/>
<quotationStyle/>
<RecoveryRate/>
<FixedSettlement/>
<Strike>
<xsl:choose>
<xsl:when test="$productType='CapFloor'">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:capFloor/fpml:capFloorStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:capRateSchedule/fpml:initialValue"/>
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:capFloor/fpml:capFloorStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:floorRateSchedule/fpml:initialValue"/>
</xsl:when>
<xsl:when test="$productType='Swaption'">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:swaption/fpml:swap/fpml:swapStream[position()=$fixedLeg]/fpml:calculationPeriodAmount/fpml:calculation/fpml:fixedRateSchedule/fpml:initialValue"/>
</xsl:when>
<xsl:when test="$productType='Equity Share Option' or $productType='Equity Index Option'">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:strike/fpml:strikePrice"/>
</xsl:when>
</xsl:choose>
</Strike>
<StrikePercentage/>
<StrikeDate/>
<Currency>
<xsl:choose>
<xsl:when test="$productType='SingleCurrencyInterestRateSwap' or $productType='OIS' or $productType='Swaption'">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:currency"/>
</xsl:when>
<xsl:when test="$productType='FRA'">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:fra/fpml:notional/fpml:currency"/>
</xsl:when>
<xsl:when test="$productType='CapFloor'">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:capFloor/fpml:capFloorStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:currency"/>
</xsl:when>
<xsl:when test="$productType='CDS' or $productType='CDS Index'">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:protectionTerms/fpml:calculationAmount/fpml:currency"/>
</xsl:when>
<xsl:when test="$productType='Equity Share Option' or $productType='Equity Index Option'">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:strike/fpml:currency"/>
</xsl:when>
</xsl:choose>
</Currency>
<Currency_2/>
<Notional>
<xsl:choose>
<xsl:when test="$productType='SingleCurrencyInterestRateSwap' or $productType='OIS' or $productType='Swaption'">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:initialValue"/>
</xsl:when>
<xsl:when test="$productType='FRA'">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:fra/fpml:notional/fpml:amount"/>
</xsl:when>
<xsl:when test="$productType='CapFloor'">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:capFloor/fpml:capFloorStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:initialValue"/>
</xsl:when>
<xsl:when test="$productType='CDS' or $productType='CDS Index'">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:protectionTerms/fpml:calculationAmount/fpml:amount"/>
</xsl:when>
</xsl:choose>
</Notional>
<Notional_2/>
<InitialNotional/>
<FixedAmount/>
<FixedAmountCurrency/>
<FixedDayBasis>
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$fixedLeg]/fpml:calculationPeriodAmount/fpml:calculation/fpml:dayCountFraction"/>
</FixedDayBasis>
<FloatDayBasis>
<xsl:choose>
<xsl:when test="$productType='SingleCurrencyInterestRateSwap' or $productType='OIS' or $productType='Swaption'">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodAmount/fpml:calculation/fpml:dayCountFraction"/>
</xsl:when>
<xsl:when test="$productType='FRA'">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:fra/fpml:dayCountFraction"/>
</xsl:when>
<xsl:when test="$productType='CapFloor'">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:capFloor/fpml:capFloorStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:dayCountFraction"/>
</xsl:when>
</xsl:choose>
</FloatDayBasis>
<FloatDayBasis_2/>
<FixedConvention>
<xsl:value-of select="substring(fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$fixedLeg]/fpml:paymentDates/fpml:paymentDatesAdjustments/fpml:businessDayConvention,1,4)"/>
</FixedConvention>
<FixedCalcPeriodDatesConvention/>
<FixedTerminationDateConvention>
<xsl:if test="$productType='SingleCurrencyInterestRateSwap' or $productType='OIS' or $productType='Swaption'">
<xsl:value-of select=" substring(fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$fixedLeg]/fpml:calculationPeriodDates/fpml:terminationDate/fpml:dateAdjustments/fpml:businessDayConvention,1,4)"/>
</xsl:if>
</FixedTerminationDateConvention>
<FloatConvention>
<xsl:choose>
<xsl:when test="$productType='SingleCurrencyInterestRateSwap' or $productType='OIS' or $productType='Swaption'">
<xsl:value-of select="substring(fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:paymentDates/fpml:paymentDatesAdjustments/fpml:businessDayConvention,1,4)"/>
</xsl:when>
<xsl:when test="$productType='FRA'">
<xsl:value-of select="substring(fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:fra/fpml:paymentDate/fpml:dateAdjustments/fpml:businessDayConvention,1,4)"/>
</xsl:when>
<xsl:when test="$productType='CapFloor'">
<xsl:value-of select="substring(fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:capFloor/fpml:capFloorStream/fpml:paymentDates/fpml:paymentDatesAdjustments/fpml:businessDayConvention,1,4)"/>
</xsl:when>
</xsl:choose>
</FloatConvention>
<FloatCalcPeriodDatesConvention/>
<FloatTerminationDateConvention>
<xsl:if test="$productType='SingleCurrencyInterestRateSwap' or $productType='OIS' or $productType='Swaption'">
<xsl:value-of select=" substring(fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodDates/fpml:terminationDate/fpml:dateAdjustments/fpml:businessDayConvention,1,4)"/>
</xsl:if>
</FloatTerminationDateConvention>
<FloatConvention_2/>
<FloatTerminationDateConvention_2/>
<FloatingRateIndex>
<xsl:choose>
<xsl:when test="$productType='SingleCurrencyInterestRateSwap' or $productType='OIS' or $productType='Swaption'">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:floatingRateIndex"/>
</xsl:when>
<xsl:when test="$productType='FRA'">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:fra/fpml:floatingRateIndex"/>
</xsl:when>
<xsl:when test="$productType='CapFloor'">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:capFloor/fpml:capFloorStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:floatingRateIndex"/>
</xsl:when>
</xsl:choose>
</FloatingRateIndex>
<FloatingRateIndex_2/>
<InflationLag/>
<IndexSource/>
<InterpolationMethod/>
<InitialIndexLevel/>
<RelatedBond/>
<IndexTenor1>
<xsl:choose>
<xsl:when test="$productType='FRA'">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:fra/fpml:indexTenor[1]/fpml:periodMultiplier"/>
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:fra/fpml:indexTenor[1]/fpml:period"/>
</xsl:when>
<xsl:when test="$productType='CapFloor'">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:capFloor/fpml:capFloorStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:indexTenor/fpml:periodMultiplier"/>
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:capFloor/fpml:capFloorStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:indexTenor/fpml:period"/>
</xsl:when>
</xsl:choose>
</IndexTenor1>
<LinearInterpolation>
<xsl:if test="$productType='FRA'">
<xsl:value-of select="string(boolean(fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:fra/fpml:indexTenor[2]))"/>
</xsl:if>
</LinearInterpolation>
<NoStubLinearInterpolation/>
<NoStubLinearInterpolation2/>
<IndexTenor2>
<xsl:if test="$productType='FRA'">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:fra/fpml:indexTenor[2]/fpml:periodMultiplier"/>
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:fra/fpml:indexTenor[2]/fpml:period"/>
</xsl:if>
</IndexTenor2>
<SpreadOverIndex>
<xsl:if test="$productType='SingleCurrencyInterestRateSwap' or $productType='CapFloor' or $productType='Swaption'">
<xsl:choose>
<xsl:when test="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:spreadSchedule/fpml:initialValue">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:spreadSchedule/fpml:initialValue"/>
</xsl:when>
<xsl:when test="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:capFloor/fpml:capFloorStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:spreadSchedule/fpml:initialValue">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:capFloor/fpml:capFloorStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:spreadSchedule/fpml:initialValue"/>
</xsl:when>
<xsl:otherwise>0</xsl:otherwise>
</xsl:choose>
</xsl:if>
</SpreadOverIndex>
<SpreadOverIndex_2/>
<FirstFixingRate>
<xsl:if test="$productType='SingleCurrencyInterestRateSwap' or $productType='OIS'">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:initialRate"/>
</xsl:if>
</FirstFixingRate>
<FirstFixingRate_2/>
<FixingDaysOffset>
<xsl:choose>
<xsl:when test="$productType='SingleCurrencyInterestRateSwap' or $productType='OIS' or $productType='Swaption'">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:resetDates/fpml:fixingDates/fpml:periodMultiplier"/>
</xsl:when>
<xsl:when test="$productType='FRA'">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:fra/fpml:fixingDateOffset/fpml:periodMultiplier"/>
</xsl:when>
<xsl:when test="$productType='CapFloor'">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:capFloor/fpml:capFloorStream/fpml:resetDates/fpml:fixingDates/fpml:periodMultiplier"/>
</xsl:when>
</xsl:choose>
</FixingDaysOffset>
<FixingDaysOffset_2/>
<FixingHolidayCentres>
<xsl:choose>
<xsl:when test="$productType='SingleCurrencyInterestRateSwap' or $productType='OIS' or $productType='Swaption'">
<xsl:apply-templates select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:resetDates/fpml:fixingDates/fpml:businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:when>
<xsl:when test="$productType='FRA'">
<xsl:apply-templates select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:fra/fpml:fixingDateOffset/fpml:businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:when>
<xsl:when test="$productType='CapFloor'">
<xsl:apply-templates select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:capFloor/fpml:capFloorStream/fpml:resetDates/fpml:fixingDates/fpml:businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:when>
</xsl:choose>
</FixingHolidayCentres>
<FixingHolidayCentres_2/>
<ResetInArrears>
<xsl:choose>
<xsl:when test="$productType='SingleCurrencyInterestRateSwap' or $productType='OIS' or $productType='Swaption'">
<xsl:value-of select="string(boolean(fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[@id='floatingLeg']/fpml:resetDates[fpml:resetRelativeTo='CalculationPeriodEndDate']))"/>
</xsl:when>
<xsl:when test="$productType='CapFloor'">
<xsl:value-of select="string(boolean(fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:capFloor/fpml:capFloorStream/fpml:resetDates[fpml:resetRelativeTo='CalculationPeriodEndDate']))"/>
</xsl:when>
</xsl:choose>
</ResetInArrears>
<ResetInArrears_2/>
<FirstFixingDifferent>
<xsl:if test="$productType='SingleCurrencyInterestRateSwap' or $productType='OIS' or $productType='Swaption'">
<xsl:value-of select="string(boolean(fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:resetDates/fpml:initialFixingDate))"/>
</xsl:if>
</FirstFixingDifferent>
<FirstFixingDifferent_2/>
<FirstFixingDaysOffset>
<xsl:if test="$productType='SingleCurrencyInterestRateSwap' or $productType='OIS' or $productType='Swaption'">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:resetDates/fpml:initialFixingDate/fpml:periodMultiplier"/>
</xsl:if>
</FirstFixingDaysOffset>
<FirstFixingDaysOffset_2/>
<FirstFixingHolidayCentres>
<xsl:if test="$productType='SingleCurrencyInterestRateSwap' or $productType='OIS' or $productType='Swaption'">
<xsl:apply-templates select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:resetDates/fpml:initialFixingDate/fpml:businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:if>
</FirstFixingHolidayCentres>
<FirstFixingHolidayCentres_2/>
<PaymentHolidayCentres>
<xsl:choose>
<xsl:when test="$productType='SingleCurrencyInterestRateSwap' or $productType='OIS' or $productType='Swaption'">
<xsl:apply-templates select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:paymentDates/fpml:paymentDatesAdjustments/fpml:businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:when>
<xsl:when test="$productType='FRA'">
<xsl:apply-templates select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:fra/fpml:paymentDate/fpml:dateAdjustments/fpml:businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:when>
<xsl:when test="$productType='CapFloor'">
<xsl:apply-templates select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:capFloor/fpml:capFloorStream/fpml:paymentDates/fpml:paymentDatesAdjustments/fpml:businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:when>
</xsl:choose>
</PaymentHolidayCentres>
<PaymentHolidayCentres_2/>
<PaymentLag>
<xsl:if test="$productType='SingleCurrencyInterestRateSwap' or $productType='OIS' or $productType='Swaption' or $productType='CapFloor'">
<xsl:choose>
<xsl:when test="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:paymentDates/fpml:paymentDaysOffset">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:paymentDates/fpml:paymentDaysOffset/fpml:periodMultiplier"/>
</xsl:when>
<xsl:when test="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:capFloor/fpml:capFloorStream/fpml:paymentDates/fpml:paymentDaysOffset">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:capFloor/fpml:capFloorStream/fpml:paymentDates/fpml:paymentDaysOffset/fpml:periodMultiplier"/>
</xsl:when>
<xsl:otherwise>0</xsl:otherwise>
</xsl:choose>
</xsl:if>
</PaymentLag>
<PaymentLag_2/>
<RollHolidayCentres>
<xsl:choose>
<xsl:when test="$productType='SingleCurrencyInterestRateSwap' or $productType='OIS' or $productType='Swaption'">
<xsl:apply-templates select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodDates/fpml:calculationPeriodDatesAdjustments/fpml:businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:when>
<xsl:when test="$productType='CapFloor'">
<xsl:apply-templates select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:capFloor/fpml:capFloorStream/fpml:calculationPeriodDates/fpml:calculationPeriodDatesAdjustments/fpml:businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:when>
</xsl:choose>
</RollHolidayCentres>
<RollHolidayCentres_2/>
<AdjustFixedStartDate/>
<AdjustFloatStartDate/>
<AdjustFloatStartDate_2/>
<AdjustRollEnd>
<xsl:if test="$productType='SingleCurrencyInterestRateSwap' or $productType='OIS' or $productType='Swaption' or $productType='CapFloor'">
<xsl:if test="$productType='SingleCurrencyInterestRateSwap' or $productType='OIS' or $productType='Swaption'">
<xsl:variable name="fixedCalcPeriodBusDayConv" select="string(fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$fixedLeg]/fpml:calculationPeriodDates/fpml:calculationPeriodDatesAdjustments/fpml:businessDayConvention)"/>
<xsl:choose>
<xsl:when test="$fixedCalcPeriodBusDayConv='NONE'">false</xsl:when>
<xsl:otherwise>true</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:if>
</AdjustRollEnd>
<AdjustFloatRollEnd/>
<AdjustFloatRollEnd_2/>
<AdjustFixedFinalRollEnd>
<xsl:if test="$productType='SingleCurrencyInterestRateSwap' or $productType='OIS' or $productType='Swaption'">
<xsl:variable name="termDateBusDayConv" select="string(fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$fixedLeg]/fpml:calculationPeriodDates/fpml:terminationDate/fpml:dateAdjustments/fpml:businessDayConvention)"/>
<xsl:choose>
<xsl:when test="$termDateBusDayConv='NONE'">false</xsl:when>
<xsl:otherwise>true</xsl:otherwise>
</xsl:choose>
</xsl:if>
</AdjustFixedFinalRollEnd>
<AdjustFinalRollEnd>
<xsl:choose>
<xsl:when test="$productType='SingleCurrencyInterestRateSwap' or $productType='OIS' or $productType='Swaption'">
<xsl:variable name="termDateBusDayConv" select="string(fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodDates/fpml:terminationDate/fpml:dateAdjustments/fpml:businessDayConvention)"/>
<xsl:choose>
<xsl:when test="$termDateBusDayConv='NONE'">false</xsl:when>
<xsl:otherwise>true</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType='CapFloor'">
<xsl:variable name="termDateBusDayConv" select="string(fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:capFloor/fpml:capFloorStream/fpml:calculationPeriodDates/fpml:terminationDate/fpml:dateAdjustments/fpml:businessDayConvention)"/>
<xsl:choose>
<xsl:when test="$termDateBusDayConv='NONE'">false</xsl:when>
<xsl:otherwise>true</xsl:otherwise>
</xsl:choose>
</xsl:when>
</xsl:choose>
</AdjustFinalRollEnd>
<AdjustFinalRollEnd_2/>
<CompoundingMethod>
<xsl:choose>
<xsl:when test="$productType='SingleCurrencyInterestRateSwap' or $productType='OIS' or $productType='Swaption'">
<xsl:variable name="compoundingMethod" select="string(fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodAmount/fpml:calculation/fpml:compoundingMethod)"/>
<xsl:choose>
<xsl:when test="$compoundingMethod='Flat'">F</xsl:when>
<xsl:when test="$compoundingMethod='Straight'">S</xsl:when>
<xsl:otherwise>N</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType='CapFloor'">
<xsl:variable name="compoundingMethod" select="string(fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:capFloor/fpml:capFloorStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:compoundingMethod)"/>
<xsl:choose>
<xsl:when test="$compoundingMethod='Flat'">F</xsl:when>
<xsl:when test="$compoundingMethod='Straight'">S</xsl:when>
<xsl:otherwise>N</xsl:otherwise>
</xsl:choose>
</xsl:when>
</xsl:choose>
</CompoundingMethod>
<CompoundingMethod_2/>
<AveragingMethod/>
<AveragingMethod_2/>
<FloatingRateMultiplier/>
<FloatingRateMultiplier_2/>
<DesignatedMaturity/>
<DesignatedMaturity_2/>
<ResetFreq/>
<ResetFreq_2/>
<WeeklyRollConvention/>
<WeeklyRollConvention_2/>
<RateCutOffDays/>
<RateCutOffDays_2/>
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
<CalculationPeriodDays>
<xsl:if test="$productType='FRA'">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:fra/fpml:calculationPeriodNumberOfDays"/>
</xsl:if>
</CalculationPeriodDays>
<FraDiscounting>
<xsl:if test="$productType='FRA'">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:fra/fpml:fraDiscounting"/>
</xsl:if>
</FraDiscounting>
<NoBreak>
<xsl:if test="$productType='SingleCurrencyInterestRateSwap' or $productType='Swaption'">
<xsl:value-of select="string(boolean(fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbNoEarlyTerminationProvision))"/>
</xsl:if>
</NoBreak>
<HasBreak>
<xsl:if test="$productType='SingleCurrencyInterestRateSwap' or $productType='Swaption'">
<xsl:value-of select="string(boolean(fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbEarlyTerminationProvision))"/>
</xsl:if>
</HasBreak>
<BreakType>
<xsl:if test="$productType='SingleCurrencyInterestRateSwap' or $productType='Swaption'">
<xsl:choose>
<xsl:when test="fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbEarlyTerminationProvision/fpml:swbOptionalEarlyTermination">OM</xsl:when>
<xsl:when test="fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbEarlyTerminationProvision/fpml:swbMandatoryEarlyTerminationDate">M</xsl:when>
<xsl:when test="fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbEarlyTerminationProvision/fpml:swbMandatoryEarlyTermination">M</xsl:when>
</xsl:choose>
</xsl:if>
</BreakType>
<BreakFirstDate>
<xsl:if test="$productType='SingleCurrencyInterestRateSwap' or $productType='Swaption'">
<xsl:choose>
<xsl:when test="fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbEarlyTerminationProvision/fpml:swbOptionalEarlyTermination/fpml:swbOptionalEarlyTerminationDate">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbEarlyTerminationProvision/fpml:swbOptionalEarlyTermination/fpml:swbOptionalEarlyTerminationDate/fpml:periodMultiplier"/>
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbEarlyTerminationProvision/fpml:swbOptionalEarlyTermination/fpml:swbOptionalEarlyTerminationDate/fpml:period"/>
</xsl:when>
<xsl:when test="fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbEarlyTerminationProvision/fpml:swbMandatoryEarlyTermination/fpml:swbMandatoryEarlyTerminationDate">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbEarlyTerminationProvision/fpml:swbMandatoryEarlyTermination/fpml:swbMandatoryEarlyTerminationDate/fpml:periodMultiplier"/>
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbEarlyTerminationProvision/fpml:swbMandatoryEarlyTermination/fpml:swbMandatoryEarlyTerminationDate/fpml:period"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbEarlyTerminationProvision/fpml:swbMandatoryEarlyTerminationDate/fpml:periodMultiplier"/>
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbEarlyTerminationProvision/fpml:swbMandatoryEarlyTerminationDate/fpml:period"/>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</BreakFirstDate>
<BreakFrequency>
<xsl:if test="$productType='SingleCurrencyInterestRateSwap' or $productType='Swaption'">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbEarlyTerminationProvision/fpml:swbOptionalEarlyTermination/fpml:swbOptionalEarlyTerminationFrequency/fpml:periodMultiplier"/>
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbEarlyTerminationProvision/fpml:swbOptionalEarlyTermination/fpml:swbOptionalEarlyTerminationFrequency/fpml:period"/>
</xsl:if>
</BreakFrequency>
<BreakOverride>
<xsl:if test="$productType='SingleCurrencyInterestRateSwap' or $productType='Swaption'">
<xsl:choose>
<xsl:when test="fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbEarlyTerminationProvision/fpml:swbBreakOverrideFirstDate">true</xsl:when>
<xsl:when test="fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbEarlyTerminationProvision/fpml:swbMandatoryEarlyTermination/fpml:swbBreakOverrideFirstDate">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:if>
</BreakOverride>
<BreakDate>
<xsl:if test="$productType='SingleCurrencyInterestRateSwap' or $productType='Swaption'">
<xsl:if test="fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbEarlyTerminationProvision/fpml:swbMandatoryEarlyTermination/fpml:swbBreakOverrideFirstDate">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string(fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbEarlyTerminationProvision/fpml:swbMandatoryEarlyTermination/fpml:swbBreakOverrideFirstDate)"/>
</xsl:call-template>
</xsl:if>
</xsl:if>
</BreakDate>
<ExchangeUnderlying>
<xsl:if test="$productType='SingleCurrencyInterestRateSwap' or $productType='OIS'">
<xsl:value-of select="string(boolean(fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbAssociatedBonds))"/>
</xsl:if>
</ExchangeUnderlying>
<SpreadCurrency/>
<SwapSpread>
<xsl:if test="$productType='SingleCurrencyInterestRateSwap' or $productType='OIS'">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbAssociatedBonds/fpml:swbNegotiatedSpreadRate"/>
</xsl:if>
</SwapSpread>
<BondId1>
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbAssociatedBonds/fpml:swbBondDetails[position()=1]/fpml:swbBondId"/>
</BondId1>
<BondName1>
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbAssociatedBonds/fpml:swbBondDetails[position()=1]/fpml:swbBondName"/>
</BondName1>
<BondAmount1>
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbAssociatedBonds/fpml:swbBondDetails[position()=1]/fpml:swbBondFaceAmount"/>
</BondAmount1>
<BondPriceType1>
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbAssociatedBonds/fpml:swbBondDetails[position()=1]/fpml:swbPricetype"/>
</BondPriceType1>
<BondPrice1>
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbAssociatedBonds/fpml:swbBondDetails[position()=1]/fpml:swbBondPrice"/>
</BondPrice1>
<BondId2>
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbAssociatedBonds/fpml:swbBondDetails[position()=2]/fpml:swbBondId"/>
</BondId2>
<BondName2>
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbAssociatedBonds/fpml:swbBondDetails[position()=2]/fpml:swbBondName"/>
</BondName2>
<BondAmount2>
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbAssociatedBonds/fpml:swbBondDetails[position()=2]/fpml:swbBondFaceAmount"/>
</BondAmount2>
<BondPriceType2>
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbAssociatedBonds/fpml:swbBondDetails[position()=2]/fpml:swbPricetype"/>
</BondPriceType2>
<BondPrice2>
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbAssociatedBonds/fpml:swbBondDetails[position()=2]/fpml:swbBondPrice"/>
</BondPrice2>
<StubAt>
<xsl:choose>
<xsl:when test="$productType='SingleCurrencyInterestRateSwap' or $productType='OIS' or $productType='Swaption' or $productType='CapFloor'">
<xsl:choose>
<xsl:when test="fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbStubPosition">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbStubPosition"/>
</xsl:when>
<xsl:otherwise>Start</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType='CDS'">
<xsl:choose>
<xsl:when test="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:feeLeg/fpml:periodicPayment/fpml:lastRegularPaymentDate">End</xsl:when>
<xsl:otherwise>Start</xsl:otherwise>
</xsl:choose>
</xsl:when>
</xsl:choose>
</StubAt>
<FixedStub/>
<FloatStub/>
<FloatStub_2/>
<FrontAndBackStubs/>
<FixedBackStub/>
<FloatBackStub/>
<NoBackStubLinearInterpolation/>
<FirstFixedRegPdStartDate/>
<FirstFloatRegPdStartDate/>
<LastFixedRegPdEndDate/>
<LastFloatRegPdEndDate/>
<MasterAgreement>
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterAgreement/fpml:masterAgreementType"/>
</MasterAgreement>
<ProductType>
<xsl:choose>
<xsl:when test="$productType='SingleCurrencyInterestRateSwap'">Single Currency Interest Rate Swap</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$productType"/>
</xsl:otherwise>
</xsl:choose>
</ProductType>
<OptionType>
<xsl:choose>
<xsl:when test="$productType='CapFloor'">
<xsl:choose>
<xsl:when test="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:capFloor/fpml:capFloorStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:capRateSchedule">Cap</xsl:when>
<xsl:when test="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:capFloor/fpml:capFloorStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:floorRateSchedule">Floor</xsl:when>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType='Swaption'">
<xsl:variable name="straddle" select="string(fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:swaption/fpml:swaptionStraddle)"/>
<xsl:variable name="swaptionBuyer" select="string(fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:swaption/fpml:buyerPartyReference/@href)"/>
<xsl:variable name="swapFixedPayer" select="string(fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$fixedLeg]/fpml:payerPartyReference/@href)"/>
<xsl:choose>
<xsl:when test="$straddle='true'">Straddle</xsl:when>
<xsl:when test="$swaptionBuyer=$swapFixedPayer">Payers</xsl:when>
<xsl:otherwise>Receivers</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType='Equity Share Option' or $productType='Equity Index Option'">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:optionType"/>
</xsl:when>
</xsl:choose>
</OptionType>
<OptionExpirationDate>
<xsl:choose>
<xsl:when test="$productType='Swaption'">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string(fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:swaption/fpml:europeanExercise/fpml:expirationDate/fpml:adjustableDate/fpml:unadjustedDate)"/>
</xsl:call-template>
</xsl:when>
<xsl:when test="$productType='Equity Share Option' or $productType='Equity Index Option'">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:equityExercise/fpml:equityAmericanExercise/fpml:expirationDate/fpml:adjustableDate/fpml:unadjustedDate"/>
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:equityExercise/fpml:equityEuropeanExercise/fpml:expirationDate/fpml:adjustableDate/fpml:unadjustedDate"/>
</xsl:when>
</xsl:choose>
</OptionExpirationDate>
<OptionHolidayCentres>
<xsl:if test="$productType='Swaption'">
<xsl:apply-templates select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:swaption/fpml:europeanExercise/fpml:expirationDate/fpml:adjustableDate/fpml:dateAdjustments/fpml:businessCenters"/>
</xsl:if>
</OptionHolidayCentres>
<OptionEarliestTime>
<xsl:if test="$productType='Swaption'">
<xsl:call-template name="formatTime">
<xsl:with-param name="time" select="string(fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:swaption/fpml:europeanExercise/fpml:earliestExerciseTime/fpml:hourMinuteTime)"/>
</xsl:call-template>
</xsl:if>
</OptionEarliestTime>
<OptionExpiryTime>
<xsl:if test="$productType='Swaption'">
<xsl:call-template name="formatTime">
<xsl:with-param name="time" select="string(fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:swaption/fpml:europeanExercise/fpml:expirationTime/fpml:hourMinuteTime)"/>
</xsl:call-template>
</xsl:if>
<xsl:if test="$productType='Equity Share Option' or $productType='Equity Index Option'">
<xsl:choose>
<xsl:when test="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:equityExercise//fpml:equityExpirationTimeType = 'AsSpecifiedInMasterConfirmation'">Per Master Confirm</xsl:when>
<xsl:when test="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:equityExercise//fpml:equityExpirationTimeType = 'MorningClose'">Morning Close</xsl:when>
<xsl:otherwise>
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:equityExercise//fpml:equityExpirationTimeType"/>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</OptionExpiryTime>
<OptionSpecificExpiryTime/>
<OptionLocation>
<xsl:if test="$productType='Swaption'">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:swaption/fpml:europeanExercise/fpml:expirationTime/fpml:businessCenter"/>
</xsl:if>
</OptionLocation>
<OptionAutomaticExercise/>
<OptionThreshold/>
<ManualExercise/>
<OptionWrittenExerciseConf/>
<OptionSettlement>
<xsl:if test="$productType='Swaption'">
<xsl:choose>
<xsl:when test="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:swaption/fpml:cashSettlement">Cash</xsl:when>
<xsl:otherwise>Physical</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="$productType='Equity Share Option' or'Equity Index Option'">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:equityExercise/fpml:settlementType"/>
</xsl:if>
</OptionSettlement>
<OptionCashSettlementMethod/>
<OptionCashSettlementQuotationRate/>
<OptionCashSettlementRateSource/>
<OptionCashSettlementReferenceBanks/>
<ClearedPhysicalSettlement/>
<Premium>
<Currency>
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:equityPremium/fpml:paymentAmount/fpml:currency"/>
</Currency>
<Amount>
<xsl:choose>
<xsl:when test="$productType='CapFloor'">
<xsl:choose>
<xsl:when test="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:capFloor/fpml:additionalPayment[1]">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:capFloor/fpml:additionalPayment[1]/fpml:paymentAmount/fpml:amount"/>
</xsl:when>
<xsl:otherwise>0</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType='Swaption'">
<xsl:choose>
<xsl:when test="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:swaption/fpml:premium">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:swaption/fpml:premium/fpml:paymentAmount/fpml:amount"/>
</xsl:when>
<xsl:otherwise>0</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType='Equity Share Option' or'Equity Index Option'">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:equityPremium/fpml:paymentAmount/fpml:amount"/>
</xsl:when>
</xsl:choose>
</Amount>
<Date>
<xsl:choose>
<xsl:when test="$productType='CapFloor'">
<xsl:if test="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:capFloor/fpml:additionalPayment[1]">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string(fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:capFloor/fpml:additionalPayment[1]/fpml:paymentDate/fpml:unadjustedDate)"/>
</xsl:call-template>
</xsl:if>
</xsl:when>
<xsl:when test="$productType='Swaption'">
<xsl:if test="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:swaption/fpml:premium">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string(fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:swaption/fpml:premium/fpml:paymentDate/fpml:unadjustedDate)"/>
</xsl:call-template>
</xsl:if>
</xsl:when>
<xsl:when test="$productType='Equity Share Option' or'Equity Index Option'">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:equityPremium/fpml:paymentDate/fpml:unadjustedDate"/>
</xsl:when>
</xsl:choose>
</Date>
</Premium>
<PremiumHolidayCentres/>
<DocsType>
<xsl:if test="$productType='CDS' or $productType='CDS Index'">
<xsl:variable name="docsType">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbConfirmationType"/>
<xsl:choose>
<xsl:when test="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:brokerConfirmation/fpml:brokerConfirmationType">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:brokerConfirmation/fpml:brokerConfirmationType"/>
</xsl:when>
<xsl:when test="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:contractualTermsSupplement/fpml:type">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:contractualTermsSupplement/fpml:type"/>
</xsl:when>
<xsl:otherwise>???</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:choose>
<xsl:when test="$docsType='EuropeCorporate'">Europe Corp</xsl:when>
<xsl:when test="$docsType='EuropeInsurerSubDebt'">Europe Insurer Sub Debt</xsl:when>
<xsl:when test="$docsType='EuropeSovereign'">Europe Sov</xsl:when>
<xsl:when test="$docsType='NorthAmericaCorporate'">US Corp</xsl:when>
<xsl:when test="$docsType='NorthAmericaMonolineInsurer'">US Mono</xsl:when>
<xsl:when test="$docsType='EMEuropeCorporate'">EM Europe Corp</xsl:when>
<xsl:when test="$docsType='EMEuropeSovereign'">EM Europe Sov</xsl:when>
<xsl:when test="$docsType='EMLatinAmericaCorporate'">EM Latin America Corp</xsl:when>
<xsl:when test="$docsType='EMLatinAmericaSovereign'">EM Latin America Sov</xsl:when>
<xsl:when test="$docsType='JapanCorporate'">Japan Corp</xsl:when>
<xsl:when test="$docsType='JapanSovereign'">Japan Sov</xsl:when>
<xsl:when test="$docsType='AustraliaCorporate'">Australia Corp</xsl:when>
<xsl:when test="$docsType='NewZealandCorporate'">New Zealand Corp</xsl:when>
<xsl:when test="$docsType='AsiaCorporate'">Asia Corp</xsl:when>
<xsl:when test="$docsType='AsiaSovereign'">Asia Sov</xsl:when>
<xsl:when test="$docsType='SingaporeCorporate'">Singapore Corp</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$docsType"/>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="$productType='Equity Share Option' or $productType='Equity Index Option' or $productType='Equity Share Option Strategy' or $productType='Equity Index Option Strategy'">
<xsl:variable name="docsType" select="string(fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:brokerConfirmation/fpml:brokerConfirmationType)"/>
<xsl:choose>
<xsl:when test="$docsType='2004EquityEuropeanInterdealer'">European Master</xsl:when>
<xsl:when test="$docsType='ISDA2007EquityEuropean'">European Master</xsl:when>
<xsl:when test="$docsType='Equity Options (Europe)'">European Master</xsl:when>
<xsl:when test="$docsType='ISDA2005EquityJapaneseInterdealer'">Japanese Master</xsl:when>
<xsl:when test="$docsType='ISDA2008EquityJapanese'">Japanese Master</xsl:when>
<xsl:when test="$docsType='Equity Options (Japan)'">Japanese Master</xsl:when>
<xsl:when test="$docsType='ISDA2005EquityAsiaExcludingJapanInterdealer'">AEJ Master</xsl:when>
<xsl:when test="$docsType='ISDA2008EquityAsiaExcludingJapan'">AEJ Master</xsl:when>
<xsl:when test="$docsType='Equity Options (AEJ)'">AEJ Master</xsl:when>
<xsl:when test="$docsType='ISDA2004EquityAmericasInterdealer'">Americas Master</xsl:when>
<xsl:when test="$docsType='ISDA2008EquityAmericas'">Americas Master</xsl:when>
<xsl:when test="$docsType='Equity Options (Americas)'">Americas Master</xsl:when>
</xsl:choose>
</xsl:if>
</DocsType>
<DocsSubType>
<xsl:if test="$productType='Equity Share Option' or $productType='Equity Index Option' or $productType='Equity Share Option Strategy' or $productType='Equity Index Option Strategy'">
<xsl:variable name="docsType" select="string(fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:brokerConfirmation/fpml:brokerConfirmationType)"/>
<xsl:choose>
<xsl:when test="$docsType='2004EquityEuropeanInterdealer'">2004 Interdealer</xsl:when>
<xsl:when test="$docsType='ISDA2007EquityEuropean'">2007 ISDA</xsl:when>
<xsl:when test="$docsType='ISDA2005EquityJapaneseInterdealer'">2005 ISDA</xsl:when>
<xsl:when test="$docsType='ISDA2008EquityJapanese'">2008 ISDA</xsl:when>
<xsl:when test="$docsType='ISDA2005EquityAsiaExcludingJapanInterdealer'">2006 ISDA</xsl:when>
<xsl:when test="$docsType='ISDA2008EquityAsiaExcludingJapan'">2008 ISDA</xsl:when>
<xsl:when test="$docsType='ISDA2004EquityAmericasInterdealer'">2004 Interdealer</xsl:when>
<xsl:when test="$docsType='ISDA2008EquityAmericas'">2008 ISDA</xsl:when>
</xsl:choose>
</xsl:if>
</DocsSubType>
<OptionsComponentSecurityIndexAnnex/>
<OptionHedgingDisruption/>
<OptionLossOfStockBorrow/>
<OptionMaximumStockLoanRate/>
<OptionIncreasedCostOfStockBorrow/>
<OptionInitialStockLoanRate/>
<OptionIncreasedCostOfHedging/>
<OptionForeignOwnershipEvent/>
<OptionEntitlement/>
<ContractualDefinitions>
<xsl:if test="$productType='CDS'">
<xsl:variable name="defs" select="string(fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:contractualDefinitions)"/>
<xsl:choose>
<xsl:when test="$defs='ISDA2003Credit'">2003 ISDA Credit</xsl:when>
<xsl:when test="$defs='ISDA1999Credit'">1999 ISDA Credit</xsl:when>
<xsl:otherwise>???</xsl:otherwise>
</xsl:choose>
</xsl:if>
</ContractualDefinitions>
<RestructuringCreditEvent>
<xsl:if test="$productType='CDS'">
<xsl:variable name="restructuringType" select="string(fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:protectionTerms/fpml:creditEvents/fpml:restructuring/fpml:restructuringType)"/>
<xsl:choose>
<xsl:when test="$restructuringType='R'">Full</xsl:when>
<xsl:when test="$restructuringType='ModR'">Mod</xsl:when>
<xsl:when test="$restructuringType='ModModR'">Mod Mod</xsl:when>
<xsl:otherwise>N/A</xsl:otherwise>
</xsl:choose>
</xsl:if>
</RestructuringCreditEvent>
<CalculationAgentCity>
<xsl:if test="$productType='CDS' or $productType='CDS Index'">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:calculationAgentBusinessCenter"/>
</xsl:if>
</CalculationAgentCity>
<RefEntName>
<xsl:if test="$productType='CDS'">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:referenceInformation/fpml:referenceEntity/fpml:entityName"/>
</xsl:if>
</RefEntName>
<RefEntStdId>
<xsl:if test="$productType='CDS'">
<xsl:variable name="entityCLIP" select="string(fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:referenceInformation/fpml:referenceEntity/fpml:entityId)"/>
<xsl:value-of select="translate($entityCLIP,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
</xsl:if>
</RefEntStdId>
<REROPairStdId>
<xsl:if test="$productType='CDS'">
<xsl:variable name="pairCLIP" select="string(fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:referenceInformation/fpml:referenceObligation/fpml:bond/fpml:instrumentId[@instrumentIdScheme='http://www.fpml.org/spec/2003/instrument-id-RED-pair-1-0'])"/>
<xsl:value-of select="translate($pairCLIP,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
</xsl:if>
</REROPairStdId>
<RefOblRERole>
<xsl:if test="$productType='CDS'">
<xsl:choose>
<xsl:when test="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:referenceInformation/fpml:referenceObligation/fpml:primaryObligorReference">I</xsl:when>
<xsl:when test="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:referenceInformation/fpml:referenceObligation/fpml:guarantorReference">G</xsl:when>
<xsl:otherwise/>
</xsl:choose>
</xsl:if>
</RefOblRERole>
<RefOblSecurityIdType>
<xsl:if test="$productType='CDS' and fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:referenceInformation/fpml:referenceObligation">
<xsl:choose>
<xsl:when test="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:referenceInformation/fpml:referenceObligation/fpml:bond/fpml:instrumentId[@instrumentIdScheme='http://www.fpml.org/spec/2002/instrument-id-ISIN-1-0']">ISIN</xsl:when>
<xsl:when test="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:referenceInformation/fpml:referenceObligation/fpml:bond/fpml:instrumentId[@instrumentIdScheme='http://www.fpml.org/spec/2002/instrument-id-CUSIP-1-0']">CUSIP</xsl:when>
<xsl:otherwise>???</xsl:otherwise>
</xsl:choose>
</xsl:if>
</RefOblSecurityIdType>
<RefOblSecurityId>
<xsl:if test="$productType='CDS' and fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:referenceInformation/fpml:referenceObligation">
<xsl:choose>
<xsl:when test="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:referenceInformation/fpml:referenceObligation/fpml:bond/fpml:instrumentId[@instrumentIdScheme='http://www.fpml.org/spec/2002/instrument-id-ISIN-1-0']">
<xsl:variable name="isin" select="string(fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:referenceInformation/fpml:referenceObligation/fpml:bond/fpml:instrumentId[@instrumentIdScheme='http://www.fpml.org/spec/2002/instrument-id-ISIN-1-0'])"/>
<xsl:value-of select="translate($isin,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
</xsl:when>
<xsl:when test="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:referenceInformation/fpml:referenceObligation/fpml:bond/fpml:instrumentId[@instrumentIdScheme='http://www.fpml.org/spec/2002/instrument-id-CUSIP-1-0']">
<xsl:variable name="cusip" select="string(fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:referenceInformation/fpml:referenceObligation/fpml:bond/fpml:instrumentId[@instrumentIdScheme='http://www.fpml.org/spec/2002/instrument-id-CUSIP-1-0'])"/>
<xsl:value-of select="translate($cusip,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
</xsl:when>
<xsl:otherwise>???</xsl:otherwise>
</xsl:choose>
</xsl:if>
</RefOblSecurityId>
<BloombergID/>
<RefOblMaturity>
<xsl:if test="$productType='CDS'and fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:referenceInformation/fpml:referenceObligation">
<xsl:choose>
<xsl:when test="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:referenceInformation/fpml:referenceObligation/fpml:bond/fpml:maturity">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string(fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:referenceInformation/fpml:referenceObligation/fpml:bond/fpml:maturity)"/>
</xsl:call-template>
</xsl:when>
<xsl:otherwise/>
</xsl:choose>
</xsl:if>
</RefOblMaturity>
<RefOblCoupon>
<xsl:if test="$productType='CDS' and fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:referenceInformation/fpml:referenceObligation">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:referenceInformation/fpml:referenceObligation/fpml:bond/fpml:couponRate"/>
</xsl:if>
</RefOblCoupon>
<RefOblPrimaryObligor>
<xsl:if test="$productType='CDS' and fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:referenceInformation/fpml:referenceObligation">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:referenceInformation/fpml:referenceObligation/fpml:primaryObligor/fpml:entityName"/>
</xsl:if>
</RefOblPrimaryObligor>
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
<IndexName>
<xsl:if test="$productType='CDS Index'">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:indexReferenceInformation/fpml:indexName"/>
</xsl:if>
</IndexName>
<IndexId>
<xsl:if test="$productType='CDS Index'">
<xsl:variable name="indexCLIP" select="string(fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:indexReferenceInformation/fpml:indexId)"/>
<xsl:value-of select="translate($indexCLIP,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
</xsl:if>
</IndexId>
<IndexSeries>
<xsl:if test="$productType='CDS Index'">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:indexReferenceInformation/fpml:indexSeries"/>
</xsl:if>
</IndexSeries>
<IndexVersion>
<xsl:if test="$productType='CDS Index'">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:indexReferenceInformation/fpml:indexAnnexVersion"/>
</xsl:if>
</IndexVersion>
<IndexAnnexDate>
<xsl:if test="$productType='CDS Index'">
<xsl:if test="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:indexReferenceInformation/fpml:indexAnnexDate">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string(fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:indexReferenceInformation/fpml:indexAnnexDate)"/>
</xsl:call-template>
</xsl:if>
</xsl:if>
</IndexAnnexDate>
<IndexTradedRate>
<xsl:if test="$productType='CDS Index'">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:feeLeg/fpml:marketFixedRate"/>
</xsl:if>
</IndexTradedRate>
<UpfrontFee>
<xsl:choose>
<xsl:when test="$productType='CDS'">
<xsl:value-of select="string(boolean(fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:feeLeg/fpml:singlePayment))"/>
</xsl:when>
<xsl:when test="$productType='CDS Index'">
<xsl:value-of select="string(boolean(fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:feeLeg/fpml:initialPayment))"/>
</xsl:when>
</xsl:choose>
</UpfrontFee>
<UpfrontFeeAmount>
<xsl:choose>
<xsl:when test="$productType='CDS' and fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:feeLeg/fpml:singlePayment">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:feeLeg/fpml:singlePayment/fpml:fixedAmount/fpml:amount"/>
</xsl:when>
<xsl:when test="$productType='CDS Index' and fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:feeLeg/fpml:initialPayment">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:feeLeg/fpml:initialPayment/fpml:paymentAmount/fpml:amount"/>
</xsl:when>
</xsl:choose>
</UpfrontFeeAmount>
<UpfrontFeeDate>
<xsl:if test="$productType='CDS' and fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:feeLeg/fpml:singlePayment">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string(fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:feeLeg/fpml:singlePayment/fpml:adjustablePaymentDate)"/>
</xsl:call-template>
</xsl:if>
</UpfrontFeeDate>
<UpfrontFeePayer>
<xsl:if test="$productType='CDS Index' and fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:feeLeg/fpml:initialPayment">
<xsl:variable name="payer" select="string(fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:feeLeg/fpml:initialPayment/fpml:payerPartyReference/@href)"/>
<xsl:choose>
<xsl:when test="$payer='partyA'">A</xsl:when>
<xsl:when test="$payer='partyB'">B</xsl:when>
<xsl:otherwise>???</xsl:otherwise>
</xsl:choose>
</xsl:if>
</UpfrontFeePayer>
<AttachmentPoint/>
<ExhaustionPoint/>
<xsl:if test="$productType='SingleCurrencyInterestRateSwap' or $productType='OIS'">
<xsl:apply-templates select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:additionalPayment"/>
</xsl:if>
<EquityRic>
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:underlyer/fpml:singleUnderlyer/fpml:equity/fpml:instrumentId"/>
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:underlyer/fpml:singleUnderlyer/fpml:index/fpml:instrumentId"/>
</EquityRic>
<OptionQuantity>
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:numberOfOptions"/>
</OptionQuantity>
<OptionExpiryMonth>
<xsl:value-of select="substring(fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:equityExercise/fpml:equityAmericanExercise/fpml:expirationDate/fpml:adjustableDate/fpml:unadjustedDate,6,2)"/>
<xsl:value-of select="substring(fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:equityExercise/fpml:equityEuropeanExercise/fpml:expirationDate/fpml:adjustableDate/fpml:unadjustedDate,6,2)"/>
</OptionExpiryMonth>
<OptionExpiryYear>
<xsl:value-of select="substring(fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:equityExercise/fpml:equityAmericanExercise/fpml:expirationDate/fpml:adjustableDate/fpml:unadjustedDate,1,4)"/>
<xsl:value-of select="substring(fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:equityExercise/fpml:equityEuropeanExercise/fpml:expirationDate/fpml:adjustableDate/fpml:unadjustedDate,1,4)"/>
</OptionExpiryYear>
<Price>
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:equityPremium/fpml:pricePerOption/fpml:amount"/>
</Price>
<OptionStyle>
<xsl:if test="$productType='Equity Share Option' or $productType='Equity Index Option'">
<xsl:choose>
<xsl:when test="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:equityExercise/fpml:equityAmericanExercise">American</xsl:when>
<xsl:otherwise>European</xsl:otherwise>
</xsl:choose>
</xsl:if>
</OptionStyle>
<ExchangeLookAlike>
<xsl:if test="$productType='Equity Share Option'">
<xsl:value-of select="string(boolean(fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:exchangeLookAlike='true'))"/>
</xsl:if>
</ExchangeLookAlike>
<AdjustmentMethod>
<xsl:variable name="adjustmentMethod" select="string(fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:methodOfAdjustment)"/>
<xsl:choose>
<xsl:when test="$adjustmentMethod='CalculationAgent'">CAA</xsl:when>
<xsl:when test="$adjustmentMethod='OptionsExchange'">OEA</xsl:when>
<xsl:otherwise/>
</xsl:choose>
</AdjustmentMethod>
<RelatedExchange>
<xsl:if test="$productType='Equity Share Option' or $productType='Equity Index Option'">
<xsl:choose>
<xsl:when test="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:underlyer/fpml:singleUnderlyer//fpml:relatedExchangeId">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:underlyer/fpml:singleUnderlyer//fpml:relatedExchangeId"/>
</xsl:when>
<xsl:otherwise/>
</xsl:choose>
</xsl:if>
</RelatedExchange>
<MasterConfirmationDate>
</MasterConfirmationDate>
<Multiplier/>
<SettlementCurrency>
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:equityExercise/fpml:settlementCurrency"/>
</SettlementCurrency>
<SettlementCurrency_2/>
<SettlementDateOffset>
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:equityExercise/fpml:settlementDate/fpml:relativeDate/fpml:periodMultiplier"/>
</SettlementDateOffset>
<SettlementType/>
<FxDeterminationMethod/>
<ReferencePriceSource/>
<ReferencePricePage/>
<ReferencePriceTime/>
<ReferencePriceCity/>
<ReferenceCurrency/>
<ReferenceCurrency_2/>
<DcRequired>
<xsl:if test="$productType='Equity Share Option' or $productType='Equity Index Option'">
<xsl:value-of select="string(boolean(fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbDeltaCross))"/>
</xsl:if>
</DcRequired>
<DcEventTypeA>
<xsl:if test="fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbDeltaCross">
<xsl:variable name="buyer" select="string(fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbDeltaCross/fpml:buyerPartyReference/@href)"/>
<xsl:choose>
<xsl:when test="$buyer=$partyA">A</xsl:when>
<xsl:otherwise>B</xsl:otherwise>
</xsl:choose>
</xsl:if>
</DcEventTypeA>
<DcRic>
<xsl:if test="$productType='Equity Share Option'">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbDeltaCross/fpml:equity/fpml:instrumentId"/>
</xsl:if>
</DcRic>
<DcDescription/>
<DcExpiryMonth>
<xsl:if test="$productType='Equity Index Option'">
<xsl:value-of select="substring(fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbDeltaCross/fpml:future/fpml:maturity,6,2)"/>
</xsl:if>
</DcExpiryMonth>
<DcExpiryYear>
<xsl:if test="$productType='Equity Index Option'">
<xsl:value-of select="substring(fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbDeltaCross/fpml:future/fpml:maturity,1,4)"/>
</xsl:if>
</DcExpiryYear>
<DcQuantity>
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbDeltaCross/fpml:swbQuantity"/>
</DcQuantity>
<DcPrice>
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbDeltaCross/fpml:swbPrice/fpml:amount"/>
</DcPrice>
<DcCurrency>
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbDeltaCross/fpml:swbPrice/fpml:currency"/>
</DcCurrency>
<DcDelta>
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbDeltaCross/fpml:swbDelta"/>
</DcDelta>
<DcExpiryDate>
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbDeltaCross/fpml:future/fpml:maturity"/>
</DcExpiryDate>
<DcFuturesCode>
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbDeltaCross/fpml:future/fpml:instrumentId"/>
</DcFuturesCode>
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
<HedgeLevel>
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbEquityOptionDetails/fpml:swbEquityOptionPercentInput/fpml:swbHedgeLevel"/>
</HedgeLevel>
<Basis>
<xsl:if test="$productType='Equity Index Option'">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbEquityOptionDetails/fpml:swbEquityOptionPercentInput/fpml:swbBasis"/>
</xsl:if>
</Basis>
<ImpliedLevel>
<xsl:if test="$productType='Equity Index Option'">
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbEquityOptionDetails/fpml:swbEquityOptionPercentInput/fpml:swbImpliedLevel"/>
</xsl:if>
</ImpliedLevel>
<PremiumPercent>
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbEquityOptionDetails/fpml:swbEquityOptionPercentInput/fpml:swbPremiumPercentage"/>
</PremiumPercent>
<StrikePercent>
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbEquityOptionDetails/fpml:swbEquityOptionPercentInput/fpml:swbStrikePercentage"/>
</StrikePercent>
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
<Payer>
<xsl:variable name="payer" select="string(fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:collateral/fpml:independentAmount/fpml:payerPartyReference/@href)"/>
<xsl:choose>
<xsl:when test="$payer='partyA'">A</xsl:when>
<xsl:when test="$payer='partyB'">B</xsl:when>
</xsl:choose>
</Payer>
<Currency>
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:collateral/fpml:independentAmount/fpml:paymentDetail/fpml:paymentAmount/fpml:currency"/>
</Currency>
<Amount>
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:collateral/fpml:independentAmount/fpml:paymentDetail/fpml:paymentAmount/fpml:amount"/>
</Amount>
<Date>
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:collateral/fpml:independentAmount/fpml:paymentDetail/fpml:adjustablePaymentDate/fpml:unadjustedDate"/>
</Date>
<Convention>
<xsl:value-of select="substring(fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:collateral/fpml:independentAmount/fpml:paymentDetail/fpml:adjustablePaymentDate/fpml:dateAdjustments/fpml:businessDayConvention,1,4)"/>
</Convention>
<Holidays>
<xsl:apply-templates select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:collateral/fpml:independentAmount/fpml:paymentDetail/fpml:adjustablePaymentDate/fpml:dateAdjustments/fpml:businessCenters"/>
</Holidays>
</IndependentAmount>
<xsl:apply-templates select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:otherPartyPayment"/>
<SettlementRateOption/>
<SettlementRateOption_2/>
<FxFixingAdjustableDate/>
<FxFixingPeriod/>
<FxFixingDayConvention/>
<FxFixingCentres/>
<FxFixingPeriod_2/>
<FxFixingDayConvention_2/>
<FxFixingCentres_2/>
<xsl:variable name="calcAgentRef" select="string(fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:calculationAgent/fpml:calculationAgentPartyReference/@href)"/>
<xsl:variable name="buyerPartyRef" select="string(fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:buyerPartyReference/@href)"/>
<CalcAgentA>
<xsl:choose>
<xsl:when test="$productType='CDS Index' and $calcAgentRef=$buyerPartyRef">Buy</xsl:when>
<xsl:when test="$productType='CDS Index' and $calcAgentRef!=$buyerPartyRef">Sell</xsl:when>
<xsl:otherwise>
<xsl:value-of select="fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:calculationAgent/fpml:calculationAgentPartyReference/@href"/>
</xsl:otherwise>
</xsl:choose>
</CalcAgentA>
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
<CFTCInterAffiliateExemption/>
<PBEBTradeCFTCMandatoryClearingIndicator/>
<PBEBTradeCFTCClearingExemptIndicator1PartyId/>
<PBEBTradeCFTCClearingExemptIndicator1Value/>
<PBEBTradeCFTCClearingExemptIndicator2PartyId/>
<PBEBTradeCFTCClearingExemptIndicator2Value/>
<PBEBTradeCFTCInterAffiliateExemption/>
<PBClientTradeCFTCMandatoryClearingIndicator/>
<PBClientTradeCFTCClearingExemptIndicator1PartyId/>
<PBClientTradeCFTCClearingExemptIndicator1Value/>
<PBClientTradeCFTCClearingExemptIndicator2PartyId/>
<PBClientTradeCFTCClearingExemptIndicator2Value/>
<PBClientTradeCFTCInterAffiliateExemption/>
<MASMandatoryClearingIndicator/>
<PBEBTradeMASMandatoryClearingIndicator/>
<PBClientTradeMASMandatoryClearingIndicator/>
<ClearingHouseId/>
<IntendedClearingHouse/>
<TraderId/>
<TraderId_2/>
<xsl:if test="fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbTradeHeader/fpml:swbExecutingBroker and fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbTradeHeader/fpml:swbClearingClient and fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbTradeHeader/fpml:swbClientClearing='true' and not(fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbTradeHeader/fpml:swbDisplayPartyLegalEntity) and $isPrimeBrokered='0'">
<ExecutingBroker>
<xsl:value-of select="$partyA"/>
</ExecutingBroker>
<ClearingClient>
<xsl:value-of select="$partyB"/>
</ClearingClient>
</xsl:if>
<ClientClearingBroker/>
<PartyAClearingBroker/>
<PartyBClearingBroker/>
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
<xsl:call-template name="outputCommonReportingFields">
<xsl:with-param name="reportingData" select="$reportingData"/>
</xsl:call-template>
<xsl:call-template name="brokerProvidedOrderDetails">
<xsl:with-param name="extendedTradeDetails" select="$extendedTradeDetails"/>
</xsl:call-template>
<xsl:call-template name="brokerProvidedPackageDetails">
<xsl:with-param name="extendedTradeDetails" select="$extendedTradeDetails"/>
</xsl:call-template>
<xsl:variable name="swbTradeHeader" select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbTradeHeader"/>
<AutoProcessing>
<xsl:value-of select="$swbTradeHeader/fpml:swbAutoProcessing"/>
</AutoProcessing>
<AnonymousTrade>
<xsl:value-of select="$swbTradeHeader/fpml:swbAnonymousTrade"/>
</AnonymousTrade>
<GCOffsettingID>
<xsl:value-of select="$swbTradeHeader/fpml:swbOffsettingTradeId"/>
</GCOffsettingID>
<CompressionType>
<xsl:value-of select="$swbTradeHeader/fpml:swbCompressionType"/>
</CompressionType>
<xsl:for-each select="$swbTradeHeader/fpml:swbPartyExecutionMethod">
<xsl:if test="fpml:partyReference/@href = 'partyA'">
<GCExecutionMethodParty_1>
<xsl:value-of select="fpml:partyReference/@href"/>
</GCExecutionMethodParty_1>
<GCExecutionMethodToken_1>
<xsl:value-of select="fpml:swbExecutionMethod"/>
</GCExecutionMethodToken_1>
</xsl:if>
</xsl:for-each>
<xsl:for-each select="$swbTradeHeader/fpml:swbPartyExecutionMethod">
<xsl:if test="fpml:partyReference/@href = 'partyB'">
<GCExecutionMethodParty_2>
<xsl:value-of select="fpml:partyReference/@href"/>
</GCExecutionMethodParty_2>
<GCExecutionMethodToken_2>
<xsl:value-of select="fpml:swbExecutionMethod"/>
</GCExecutionMethodToken_2>
</xsl:if>
</xsl:for-each>
<OTVConfirmation>
<xsl:value-of select="$swbTradeHeader/fpml:swbOTVConfirmation"/>
</OTVConfirmation>
<xsl:apply-templates select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbTradeHeader/fpml:swbPartyClearingDetails"/>
</Trade>
</xsl:template>
<xsl:template match="additionalPayment">
<xsl:variable name="paymentType" select="string(fpml:paymentType)"/>
<xsl:choose>
<xsl:when test="$paymentType='Premium'">
<xsl:call-template name="premium"/>
</xsl:when>
<xsl:otherwise>
<xsl:apply-templates select="."/>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template match="fpml:businessCenters">
<xsl:for-each select="fpml:businessCenter">
<xsl:apply-templates select="."/>
<xsl:if test="../fpml:businessCenter[last()]!=.">; </xsl:if>
</xsl:for-each>
</xsl:template>
<xsl:template match="fpml:swbPartyClearingDetails">
<PartyClearingDetails>
<Party>
<xsl:variable name="party" select="string(fpml:partyReference/@href)"/>
<xsl:choose>
<xsl:when test="$party='partyA'">A</xsl:when>
<xsl:when test="$party='partyB'">B</xsl:when>
<xsl:otherwise>???</xsl:otherwise>
</xsl:choose>
</Party>
<ClearingStatus>
<xsl:value-of select="fpml:swbClearingStatus"/>
</ClearingStatus>
<ClearingHouseTradeID>
<xsl:value-of select="fpml:swbClearingHouseTradeID"/>
</ClearingHouseTradeID>
<ClearingHouseUpfrontFeeSettlementDate>
<xsl:value-of select="fpml:swbClearingHouseUpfrontFeeSettlementDate"/>
</ClearingHouseUpfrontFeeSettlementDate>
<ClearingHousePreferredISIN>
<xsl:value-of select="fpml:swbClearingHousePreferredISIN"/>
</ClearingHousePreferredISIN>
<ClearedTimestamp>
<xsl:value-of select="fpml:swbClearedTimestamp"/>
</ClearedTimestamp>
<ClearedUSINamespace>
<xsl:value-of select="fpml:swbClearedUSI/fpml:swbIssuer"/>
</ClearedUSINamespace>
<ClearedUSI>
<xsl:value-of select="fpml:swbClearedUSI/fpml:swbTradeId"/>
</ClearedUSI>
<ClearedUTINamespace>
<xsl:value-of select="fpml:swbClearedUTI/fpml:swbIssuer"/>
</ClearedUTINamespace>
<ClearedUTI>
<xsl:value-of select="fpml:swbClearedUTI/fpml:swbTradeId"/>
</ClearedUTI>
</PartyClearingDetails>
</xsl:template>
<xsl:template match="fpml:swbRecipient">
<Recipient>
<Id>
<xsl:value-of select="./@id"/>
</Id>
<xsl:variable name="party" select="string(fpml:partyReference/@href)"/>
<Party>
<xsl:choose>
<xsl:when test="$party=$partyA">A</xsl:when>
<xsl:when test="$party=$partyB">B</xsl:when>
<xsl:otherwise>???</xsl:otherwise>
</xsl:choose>
</Party>
<UserName>
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:tradeHeader/fpml:partyTradeInformation[fpml:partyReference/@href=$party]/fpml:trader"/>
</UserName>
<TradingBook>
<xsl:value-of select="fpml:swbTradingBookId"/>
</TradingBook>
<ExecutionMode/>
</Recipient>
</xsl:template>
<xsl:template match="fpml:additionalPayment">
<AdditionalPayment>
<Payer>
<xsl:variable name="payer" select="string(fpml:payerPartyReference/@href)"/>
<xsl:choose>
<xsl:when test="$payer=$partyA">A</xsl:when>
<xsl:when test="$payer=$partyB">B</xsl:when>
<xsl:otherwise>???</xsl:otherwise>
</xsl:choose>
</Payer>
<Reason>
<xsl:value-of select="fpml:paymentType"/>
</Reason>
<Currency>
<xsl:value-of select="fpml:paymentAmount/fpml:currency"/>
</Currency>
<Amount>
<xsl:value-of select="fpml:paymentAmount/fpml:amount"/>
</Amount>
<Date>
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string(fpml:paymentDate/fpml:unadjustedDate)"/>
</xsl:call-template>
</Date>
<Convention>
<xsl:value-of select="substring(fpml:paymentDate/fpml:dateAdjustments/fpml:businessDayConvention,1,4)"/>
</Convention>
<Holidays>
<xsl:apply-templates select="fpml:paymentDate/fpml:dateAdjustments/fpml:businessCenters"/>
</Holidays>
</AdditionalPayment>
</xsl:template>
<xsl:template name="premium"/>
<xsl:template match="fpml:otherPartyPayment">
<Brokerage>
<Payer>
<xsl:variable name="payer" select="string(fpml:payerPartyReference/@href)"/>
<xsl:choose>
<xsl:when test="$payer=$partyA">A</xsl:when>
<xsl:when test="$payer=$partyB">B</xsl:when>
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
<xsl:variable name="version" select="string(/fpml:SWBML/@version)"/>
<xsl:variable name="broker" select="string(fpml:receiverPartyReference/@href)"/>
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:party[@id=$broker]/fpml:partyId"/>
</Broker>
<BrokerTradeId>
<xsl:variable name="version" select="string(/fpml:SWBML/@version)"/>
<xsl:variable name="party" select="string(fpml:payerPartyReference/@href)"/>
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:tradeHeader/fpml:partyTradeIdentifier/fpml:partyReference[@href=$party]/../fpml:tradeId"/>
</BrokerTradeId>
</Brokerage>
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
<xsl:template name="formatTime">
<xsl:param name="time"/>
<xsl:choose>
<xsl:when test="$time='09:00:00'">9am</xsl:when>
<xsl:when test="$time='11:00:00'">11am</xsl:when>
<xsl:when test="$time='12:00:00'">12noon</xsl:when>
<xsl:when test="$time='15:00:00'">3pm</xsl:when>
<xsl:when test="$time='00:00:00'">12midnight</xsl:when>
<xsl:when test="$time='01:00:00'">1am</xsl:when>
<xsl:when test="$time='02:00:00'">2am</xsl:when>
<xsl:when test="$time='03:00:00'">3am</xsl:when>
<xsl:when test="$time='04:00:00'">4am</xsl:when>
<xsl:when test="$time='05:00:00'">5am</xsl:when>
<xsl:when test="$time='06:00:00'">6am</xsl:when>
<xsl:when test="$time='07:00:00'">7am</xsl:when>
<xsl:when test="$time='08:00:00'">8am</xsl:when>
<xsl:when test="$time='10:00:00'">10am</xsl:when>
<xsl:when test="$time='13:00:00'">1pm</xsl:when>
<xsl:when test="$time='14:00:00'">2pm</xsl:when>
<xsl:when test="$time='16:00:00'">4pm</xsl:when>
<xsl:when test="$time='17:00:00'">5pm</xsl:when>
<xsl:when test="$time='18:00:00'">6pm</xsl:when>
<xsl:when test="$time='19:00:00'">7pm</xsl:when>
<xsl:when test="$time='20:00:00'">8pm</xsl:when>
<xsl:when test="$time='21:00:00'">9pm</xsl:when>
<xsl:when test="$time='22:00:00'">10pm</xsl:when>
<xsl:when test="$time='23:00:00'">11pm</xsl:when>
<xsl:otherwise>???</xsl:otherwise>
</xsl:choose>
</xsl:template>
</xsl:stylesheet>
