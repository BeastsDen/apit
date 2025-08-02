<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:common="http://exslt.org/common"
exclude-result-prefixes="common" version="1.0">
<xsl:import href="swdml-extract-reporting.xsl"/>
<xsl:output method="xml"/>
<xsl:variable name="swGiveUp" select="/SWDML/swLongFormTrade/swGiveUp"/>
<xsl:variable name="reportingData.rtf">
<xsl:apply-templates select="/SWDML/swTradeEventReportingDetails/node()"
mode="mapReportingData"/>
<productType>
<xsl:value-of select="string(/SWDML/swLongFormTrade/swStructuredTradeDetails/swProductType)"/>
</productType>
<partyRoles>
<transferor>
<xsl:value-of select="/SWDML/swLongFormTrade/novation/transferor/@href"/>
</transferor>
<transferee>
<xsl:value-of select="/SWDML/swLongFormTrade/novation/transferee/@href"/>
</transferee>
<remainingParty>
<xsl:value-of select="/SWDML/swLongFormTrade/novation/remainingParty/@href"/>
</remainingParty>
<otherRemainingParty>
<xsl:value-of select="/SWDML/swLongFormTrade/novation/otherRemainingParty/@href"/>
</otherRemainingParty>
<primeBrokerA>
<xsl:value-of select="$swGiveUp/swInterDealerTransaction/swPrimeBroker/@href"/>
</primeBrokerA>
<primeBrokerB>
<xsl:value-of select="$swGiveUp/swCustomerTransaction/swPrimeBroker/@href"/>
</primeBrokerB>
</partyRoles>
</xsl:variable>
<xsl:variable name="swOrderDetails"    select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swOrderDetails"/>
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
<xsl:attribute name="{local-name()}">
<xsl:value-of select="."/>
</xsl:attribute>
</xsl:template>
<xsl:template match="/">
<xsl:apply-templates select="SWDML" mode="get-reporting-data"/>
</xsl:template>
<xsl:template match="/SWDML[function-available('common:node-set')]" mode="get-reporting-data">
<xsl:apply-templates select="."><xsl:with-param name="reportingData" select="common:node-set($reportingData.rtf)"/></xsl:apply-templates>
</xsl:template>
<xsl:template match="/SWDML[not(function-available('common:node-set'))]" mode="get-reporting-data">
<xsl:apply-templates select="."><xsl:with-param name="reportingData" select="$reportingData.rtf"/></xsl:apply-templates>
</xsl:template>
<xsl:variable name="floatingLeg">
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[1]/resetDates">1</xsl:when>
<xsl:otherwise>2</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="floatingLegId" select="string(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/@id)"/>
<xsl:variable name="fixedLeg">
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[1]/resetDates">2</xsl:when>
<xsl:otherwise>1</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="fixedLegId" select="string(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$fixedLeg]/@id)"/>
<xsl:variable name="partyA">
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/novation">
<xsl:value-of select="substring-after(/SWDML//transferor/@href,'#')"/>
</xsl:when>
<xsl:when test="starts-with(/SWDML//swOriginatorPartyReference/@href,'#')">
<xsl:value-of select="substring-after(/SWDML//swOriginatorPartyReference/@href,'#')"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="/SWDML//swOriginatorPartyReference/@href"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="partyB">
<xsl:choose>
<xsl:when test="(/SWDML/swLongFormTrade/swAllocations or /SWDML/swLongFormTrade/swGiveUp)">
<xsl:for-each select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/tradeHeader/partyTradeIdentifier">
<xsl:variable name="party">
<xsl:choose>
<xsl:when test="starts-with(partyReference/@href,'#')">
<xsl:value-of select="substring-after(partyReference/@href,'#')"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="partyReference/@href"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:if test="$party!=$partyA">
<xsl:value-of select="$party"/>
</xsl:if>
</xsl:for-each>
</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/novation">
<xsl:value-of select="substring-after(/SWDML//transferee/@href,'#')"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="/SWDML/swShortFormTrade//party[@id!=$partyA]/@id"/>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML//party[@id!=$partyA]/@id"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="partyC">
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/swGiveUp">
<xsl:choose>
<xsl:when test="starts-with(/SWDML//swInterDealerTransaction/swPrimeBroker/@href,'#')">
<xsl:value-of select="substring-after(/SWDML//swInterDealerTransaction/swPrimeBroker/@href,'#')"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="/SWDML//swInterDealerTransaction/swPrimeBroker/@href"/>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/novation">
<xsl:value-of select="substring-after(/SWDML//remainingParty/@href,'#')"/>
</xsl:when>
</xsl:choose>
</xsl:variable>
<xsl:variable name="partyD">
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/swGiveUp">
<xsl:choose>
<xsl:when test="starts-with(/SWDML//swCustomerTransaction/swPrimeBroker/@href,'#')">
<xsl:value-of select="substring-after(/SWDML//swCustomerTransaction/swPrimeBroker/@href,'#')"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="/SWDML//swCustomerTransaction/swPrimeBroker/@href"/>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/novation">
<xsl:if test="starts-with(/SWDML//otherRemainingParty/@href,'#')">
<xsl:value-of select="substring-after(/SWDML//otherRemainingParty/@href,'#')"/>
</xsl:if>
</xsl:when>
</xsl:choose>
</xsl:variable>
<xsl:variable name="partyE">
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/novation/payment">
<xsl:if test="starts-with(/SWDML//receiverPartyReference/@href,'#')">
<xsl:value-of select="substring-after(/SWDML//receiverPartyReference/@href,'#')"/>
</xsl:if>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="/SWDML//receiverPartyReference/@href"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="partyF">
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/novation/payment">
<xsl:if test="starts-with(/SWDML//payerPartyReference/@href,'#')">
<xsl:value-of select="substring-after(/SWDML//payerPartyReference/@href,'#')"/>
</xsl:if>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="/SWDML//payerPartyReference/@href"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="partyG">
<xsl:if test="/SWDML/swLongFormTrade/swGiveUp">
<xsl:choose>
<xsl:when test="starts-with(/SWDML//swExecutingDealerCustomerTransaction/swExecutingDealer/@href,'#')">
<xsl:value-of select="substring-after(/SWDML//swExecutingDealerCustomerTransaction/swExecutingDealer/@href,'#')"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="/SWDML//swExecutingDealerCustomerTransaction/swExecutingDealer/@href"/>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:variable>
<xsl:variable name="productType">
<xsl:choose>
<xsl:when test="/SWDML/swShortFormTrade">
<xsl:choose>
<xsl:when test="/SWDML/swShortFormTrade/swCapFloorParameters">CapFloor</xsl:when>
<xsl:when test="/SWDML/swShortFormTrade/swFraParameters">FRA</xsl:when>
<xsl:when test="/SWDML/swShortFormTrade/swOisParameters">OIS</xsl:when>
<xsl:when test="/SWDML/swShortFormTrade/swIrsParameters">IRS</xsl:when>
<xsl:when test="/SWDML/swShortFormTrade/swSwaptionParameters">Swaption</xsl:when>
<xsl:otherwise>???</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade">
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails[swProductType='SingleCurrencyInterestRateSwap']">IRS</xsl:when>
<xsl:otherwise>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swProductType"/>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
</xsl:choose>
</xsl:variable>
<xsl:variable name="currency">
<xsl:choose>
<xsl:when test="$productType='IRS' or $productType='OIS' or $productType='Swaption'">
<xsl:value-of select="/SWDML/swShortFormTrade//notional/currency"/>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/calculationPeriodAmount/calculation/notionalSchedule/notionalStepSchedule/currency"/>
</xsl:when>
<xsl:when test="$productType='FRA'">
<xsl:value-of select="/SWDML/swShortFormTrade/swFraParameters/notional/currency"/>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/fra/notional/currency"/>
</xsl:when>
<xsl:when test="$productType='CapFloor'">
<xsl:value-of select="/SWDML/swShortFormTrade//notional/currency"/>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/capFloorStream/calculationPeriodAmount/calculation/notionalSchedule/notionalStepSchedule/currency"/>
</xsl:when>
<xsl:when test="$productType='CDS Index'">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/creditDefaultSwap/protectionTerms/calculationAmount/currency"/>
</xsl:when>
</xsl:choose>
</xsl:variable>
<xsl:variable name="referenceCurrency">
<xsl:if test="$productType='IRS' or $productType='OIS' or $productType='Swaption'">
<xsl:choose>
<xsl:when test="/SWDML/swShortFormTrade//swSettlementProvision/swNonDeliverableSettlement/swReferenceCurrency">
<xsl:value-of select="/SWDML/swShortFormTrade//swSettlementProvision/swNonDeliverableSettlement/swReferenceCurrency"/>
</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swSettlementProvision/swNonDeliverableSettlement/swReferenceCurrency">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swSettlementProvision/swNonDeliverableSettlement/swReferenceCurrency"/>
</xsl:when>
</xsl:choose>
</xsl:if>
</xsl:variable>
<xsl:variable name="conditionPrecedentBondId">
<xsl:value-of select="/SWDML/swShortFormTrade//additionalTerms/conditionPrecedentBond/instrumentId"/>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swap/additionalTerms/conditionPrecedentBond/instrumentId"/>
</xsl:variable>
<xsl:template match="SWDML">
<xsl:param name="reportingData"/>
<SWDMLTrade version="1-0">
<SWDMLVersion>
<xsl:value-of select="/SWDML/@version"/>
</SWDMLVersion>
<ReplacementTradeId>
<xsl:value-of select="/SWDML/swLongFormTrade/swReplacementTradeId/swTradeId"/>
</ReplacementTradeId>
<ReplacementTradeIdType>
<xsl:value-of select="/SWDML/swLongFormTrade/swReplacementTradeId/swTradeIdType"/>
</ReplacementTradeIdType>
<ReplacementReason>
<xsl:value-of select="/SWDML/swLongFormTrade/swReplacementTradeId/swReplacementReason"/>
</ReplacementReason>
<ShortFormInput>
<xsl:choose>
<xsl:when test="/SWDML/swShortFormTrade">true</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade">false</xsl:when>
<xsl:otherwise>???</xsl:otherwise>
</xsl:choose>
</ShortFormInput>
<ProductType>
<xsl:choose>
<xsl:when test="$productType='IRS'">Single Currency Interest Rate Swap</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$productType"/>
</xsl:otherwise>
</xsl:choose>
</ProductType>
<ProductSubType>
<xsl:if test="/SWDML/swShortFormTrade and $productType='IRS'">
<xsl:value-of select="/SWDML/swShortFormTrade/swIrsParameters/swProductSubType"/>
</xsl:if>
<xsl:if test="/SWDML/swShortFormTrade and $productType='OIS'">
<xsl:value-of select="/SWDML/swShortFormTrade/swOisParameters/swProductSubType"/>
</xsl:if>
</ProductSubType>
<ParticipantSupplement>
<xsl:if test="/SWDML/swLongFormTrade/swStructuredTradeDetails/swParticipantSupplement">
<xsl:value-of select="swLongFormTrade/swStructuredTradeDetails/swParticipantSupplement"/>
</xsl:if>
<xsl:if test="/SWDML/swShortFormTrade/swParticipantSupplement">
<xsl:value-of select="swShortFormTrade/swParticipantSupplement"/>
</xsl:if>
</ParticipantSupplement>
<ConditionPrecedentBondId>
<xsl:value-of select="$conditionPrecedentBondId"/>
</ConditionPrecedentBondId>
<ConditionPrecedentBondMaturity>
<xsl:variable name="bondMaturityDate">
<xsl:value-of select="/SWDML/swShortFormTrade//additionalTerms/conditionPrecedentBond/maturity"/>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swap/additionalTerms/conditionPrecedentBond/maturity"/>
</xsl:variable>
<xsl:if test="not($bondMaturityDate='')">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string($bondMaturityDate)"/>
</xsl:call-template>
</xsl:if>
</ConditionPrecedentBondMaturity>
<ConditionPrecedentBondIdType>
<xsl:if test="string-length($conditionPrecedentBondId)=9">CUSIP</xsl:if>
<xsl:if test="string-length($conditionPrecedentBondId)=12">ISIN</xsl:if>
</ConditionPrecedentBondIdType>
<ConditionPrecedentBond>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swBondClauses/swConditionPrecedentBond"/>
</ConditionPrecedentBond>
<DiscrepancyClause>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swBondClauses/swDiscrepancyClause"/>
</DiscrepancyClause>
<AllocatedTrade>
<xsl:value-of select="string(boolean(/SWDML/swLongFormTrade/swAllocations))"/>
</AllocatedTrade>
<xsl:if test="/SWDML/swLongFormTrade/swAllocations">
<xsl:call-template name="swAllocations"/>
</xsl:if>
<PrimeBrokerTrade>
<xsl:value-of select="string(boolean(/SWDML/swLongFormTrade/swGiveUp))"/>
</PrimeBrokerTrade>
<ReversePrimeBrokerLegalEntities>
<xsl:if test="/SWDML/swLongFormTrade/swGiveUp">
<xsl:choose>
<xsl:when test="starts-with(/SWDML//swCustomerTransaction/swCustomer/@href,'#')">
<xsl:value-of select="string(boolean(substring-after(/SWDML//swCustomerTransaction/swCustomer/@href,'#')=string($partyA)))"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="string(boolean(string(/SWDML//swCustomerTransaction/swCustomer/@href)=string($partyA)))"/>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</ReversePrimeBrokerLegalEntities>
<PartyAId>
<xsl:if test="(/SWDML/swLongFormTrade/swGiveUp or /SWDML/swLongFormTrade/novation)">
<xsl:attribute name="id">
<xsl:value-of select="$partyA"/>
</xsl:attribute>
</xsl:if>
<xsl:value-of select="/SWDML/swShortFormTrade//party[@id=$partyA]/partyId"/>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML//party[@id=$partyA]/partyId"/>
</PartyAId>
<PartyAIdType>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML//party[@id=$partyA]/partyId/@partyIdScheme"/>
</PartyAIdType>
<PartyBId>
<xsl:if test="(/SWDML/swLongFormTrade/swGiveUp or /SWDML/swLongFormTrade/novation)">
<xsl:attribute name="id">
<xsl:value-of select="$partyB"/>
</xsl:attribute>
</xsl:if>
<xsl:value-of select="/SWDML/swShortFormTrade//party[@id=$partyB]/partyId"/>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML//party[@id=$partyB]/partyId"/>
</PartyBId>
<PartyBIdType>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML//party[@id=$partyB]/partyId/@partyIdScheme"/>
</PartyBIdType>
<PartyCId>
<xsl:if test="(/SWDML/swLongFormTrade/swGiveUp or /SWDML/swLongFormTrade/novation)">
<xsl:attribute name="id">
<xsl:value-of select="$partyC"/>
</xsl:attribute>
<xsl:value-of select="/SWDML/swShortFormTrade//party[@id=$partyC]/partyId"/>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML//party[@id=$partyC]/partyId"/>
</xsl:if>
</PartyCId>
<PartyCIdType>
<xsl:if test="(/SWDML/swLongFormTrade/swGiveUp or /SWDML/swLongFormTrade/novation)">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML//party[@id=$partyC]/partyId/@partyIdScheme"/>
</xsl:if>
</PartyCIdType>
<PartyDId>
<xsl:if test="(/SWDML/swLongFormTrade/swGiveUp or /SWDML/swLongFormTrade/novation)">
<xsl:if test="$partyD!=''">
<xsl:attribute name="id">
<xsl:value-of select="$partyD"/>
</xsl:attribute>
<xsl:value-of select="/SWDML/swShortFormTrade//party[@id=$partyD]/partyId"/>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML//party[@id=$partyD]/partyId"/>
</xsl:if>
</xsl:if>
</PartyDId>
<PartyDIdType>
<xsl:if test="(/SWDML/swLongFormTrade/swGiveUp or /SWDML/swLongFormTrade/novation)">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML//party[@id=$partyD]/partyId/@partyIdScheme"/>
</xsl:if>
</PartyDIdType>
<PartyGId>
<xsl:if test="(/SWDML/swLongFormTrade/swGiveUp)">
<xsl:if test="$partyG!=''">
<xsl:attribute name="id">
<xsl:value-of select="$partyG"/>
</xsl:attribute>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML//party[@id=$partyG]/partyId"/>
</xsl:if>
</xsl:if>
</PartyGId>
<PartyGIdType>
<xsl:if test="(/SWDML/swLongFormTrade/swGiveUp)">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML//party[@id=$partyG]/partyId/@partyIdScheme"/>
</xsl:if>
</PartyGIdType>
<Interoperable>
<xsl:if test="$productType='IRS' or $productType='Swaption'">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swTradeHeader/swInteroperable"/>
</xsl:if>
</Interoperable>
<ExternalInteropabilityId>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swTradeHeader/swExternalInteropabilityId"/>
</ExternalInteropabilityId>
<InteropNettingString>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swTradeHeader/swInteropNettingString"/>
</InteropNettingString>
<DirectionA>
<xsl:choose>
<xsl:when test="$productType='CapFloor'">
<xsl:variable name="buyer">
<xsl:value-of select="/SWDML/swShortFormTrade//swFixedAmounts/receiverPartyReference/@href"/>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/capFloorStream/receiverPartyReference/@href"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="substring-after($buyer,'#')=string($partyA)">Buy</xsl:when>
<xsl:otherwise>Sell</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType='IRS' or $productType='OIS'">
<xsl:variable name="fixedPayer">
<xsl:value-of select="/SWDML/swShortFormTrade//swFixedAmounts/payerPartyReference/@href"/>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$fixedLeg]/payerPartyReference/@href"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="substring-after($fixedPayer,'#')=string($partyA)">Pay</xsl:when>
<xsl:otherwise>Rec</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType='Swaption'">
<xsl:variable name="buyer">
<xsl:value-of select="/SWDML/swShortFormTrade/swSwaptionParameters/buyerPartyReference/@href"/>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swaption/buyerPartyReference/@href"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="substring-after($buyer,'#')=string($partyA)">Buy</xsl:when>
<xsl:otherwise>Sell</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType='FRA'">
<xsl:variable name="buyer">
<xsl:value-of select="/SWDML/swShortFormTrade/swFraParameters/buyerPartyReference/@href"/>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/fra/buyerPartyReference/@href"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="substring-after($buyer,'#')=string($partyA)">Buy</xsl:when>
<xsl:otherwise>Sell</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType='CDS Index'">
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/creditDefaultSwap/generalTerms/buyerPartyReference/@href=string($partyA)">Buy</xsl:when>
<xsl:otherwise>Sell</xsl:otherwise>
</xsl:choose>
</xsl:when>
</xsl:choose>
</DirectionA>
<TradeDate>
<xsl:call-template name="formatDate">
<xsl:with-param name="date">
<xsl:value-of select="/SWDML/swShortFormTrade//tradeDate"/>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/tradeHeader/tradeDate"/>
</xsl:with-param>
</xsl:call-template>
</TradeDate>
<StartDateTenor>
<xsl:value-of select="/SWDML/swShortFormTrade/swFraParameters/swEffectiveDateTenor/periodMultiplier"/>
<xsl:value-of select="/SWDML/swShortFormTrade/swFraParameters/swEffectiveDateTenor/period"/>
</StartDateTenor>
<EndDateTenor>
<xsl:value-of select="/SWDML/swShortFormTrade/swFraParameters/swTerminationDateTenor/periodMultiplier"/>
<xsl:value-of select="/SWDML/swShortFormTrade/swFraParameters/swTerminationDateTenor/period"/>
</EndDateTenor>
<StartDateDay>
<xsl:if test="/SWDML/swShortFormTrade and $productType='FRA'">
<xsl:choose>
<xsl:when test="/SWDML/swShortFormTrade/swFraParameters/rollConvention">
<xsl:value-of select="/SWDML/swShortFormTrade/swFraParameters/rollConvention"/>
</xsl:when>
<xsl:otherwise>spot</xsl:otherwise>
</xsl:choose>
</xsl:if>
</StartDateDay>
<Tenor>
<xsl:if test="$productType='IRS' or $productType='OIS' or $productType='Swaption' or $productType='CapFloor'">
<xsl:choose>
<xsl:when test="/SWDML/swShortFormTrade">
<xsl:value-of select="/SWDML/swShortFormTrade//swSwapTermTenor/periodMultiplier"/>
<xsl:value-of select="/SWDML/swShortFormTrade//swSwapTermTenor/period"/>
</xsl:when>
<xsl:otherwise>
<xsl:call-template name="calculateTenor">
<xsl:with-param name="startDate">
<xsl:choose>
<xsl:when test="$productType='CapFloor'">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/capFloorStream/calculationPeriodDates/effectiveDate/unadjustedDate"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/calculationPeriodDates/effectiveDate/unadjustedDate"/>
</xsl:otherwise>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="endDate">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/calculationPeriodDates/terminationDate/unadjustedDate"/>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/capFloorStream/calculationPeriodDates/terminationDate/unadjustedDate"/>
</xsl:with-param>
</xsl:call-template>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</Tenor>
<StartDate>
<xsl:variable name="startDate">
<xsl:choose>
<xsl:when test="$productType='IRS' or $productType='Swaption'">
<xsl:variable name="fixedStartDate" select="string(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$fixedLeg]/calculationPeriodDates/effectiveDate/unadjustedDate)"/>
<xsl:variable name="floatStartDate" select="string(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/calculationPeriodDates/effectiveDate/unadjustedDate)"/>
<xsl:if test="/SWDML/swLongFormTrade and ($fixedStartDate = $floatStartDate)">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/calculationPeriodDates/effectiveDate/unadjustedDate)"/>
</xsl:call-template>
</xsl:if>
<xsl:if test="/SWDML/swShortFormTrade//adjustedEffectiveDate">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string(/SWDML/swShortFormTrade//adjustedEffectiveDate)"/>
</xsl:call-template>
</xsl:if>
</xsl:when>
<xsl:when test="$productType='OIS'">
<xsl:if test="/SWDML/swLongFormTrade or /SWDML/swShortFormTrade//adjustedEffectiveDate">
<xsl:call-template name="formatDate">
<xsl:with-param name="date">
<xsl:value-of select="/SWDML/swShortFormTrade//adjustedEffectiveDate"/>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/calculationPeriodDates/effectiveDate/unadjustedDate"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
</xsl:when>
<xsl:when test="$productType='FRA'">
<xsl:if test="/SWDML/swLongFormTrade">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/fra/adjustedEffectiveDate)"/>
</xsl:call-template>
</xsl:if>
</xsl:when>
<xsl:when test="$productType='CapFloor'">
<xsl:if test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/capFloorStream/calculationPeriodDates/effectiveDate/unadjustedDate">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/capFloorStream/calculationPeriodDates/effectiveDate/unadjustedDate)"/>
</xsl:call-template>
</xsl:if>
<xsl:if test="/SWDML/swShortFormTrade//adjustedEffectiveDate">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string(/SWDML/swShortFormTrade//adjustedEffectiveDate)"/>
</xsl:call-template>
</xsl:if>
</xsl:when>
<xsl:when test="$productType='CDS Index'">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/creditDefaultSwap/generalTerms/effectiveDate/unadjustedDate)"/>
</xsl:call-template>
</xsl:when>
</xsl:choose>
</xsl:variable>
<xsl:value-of select="$startDate"/>
</StartDate>
<FirstFixedPeriodStartDate>
<xsl:variable name="firstFixedPeriodStartDate">
<xsl:if test="$productType='IRS' or $productType='Swaption' or $productType='OIS'">
<xsl:variable name="fixedStartDate" select="string(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$fixedLeg]/calculationPeriodDates/effectiveDate/unadjustedDate)"/>
<xsl:variable name="floatStartDate" select="string(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/calculationPeriodDates/effectiveDate/unadjustedDate)"/>
<xsl:if test="/SWDML/swLongFormTrade and ($fixedStartDate != $floatStartDate)">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$fixedLeg]/calculationPeriodDates/effectiveDate/unadjustedDate)"/>
</xsl:call-template>
</xsl:if>
</xsl:if>
</xsl:variable>
<xsl:value-of select="$firstFixedPeriodStartDate"/>
</FirstFixedPeriodStartDate>
<FirstFloatPeriodStartDate>
<xsl:variable name="firstFloatPeriodStartDate">
<xsl:if test="$productType='IRS' or $productType='Swaption'">
<xsl:variable name="fixedStartDate" select="string(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$fixedLeg]/calculationPeriodDates/effectiveDate/unadjustedDate)"/>
<xsl:variable name="floatStartDate" select="string(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/calculationPeriodDates/effectiveDate/unadjustedDate)"/>
<xsl:if test="/SWDML/swLongFormTrade and ($fixedStartDate != $floatStartDate)">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/calculationPeriodDates/effectiveDate/unadjustedDate)"/>
</xsl:call-template>
</xsl:if>
</xsl:if>
</xsl:variable>
<xsl:value-of select="$firstFloatPeriodStartDate"/>
</FirstFloatPeriodStartDate>
<FirstFloatPeriodStartDate_2/>
<EndDate>
<xsl:variable name="endDate">
<xsl:choose>
<xsl:when test="$productType='IRS' or $productType='OIS' or $productType='Swaption'">
<xsl:if test="/SWDML/swLongFormTrade or /SWDML/swShortFormTrade//swUnadjustedTerminationDate">
<xsl:call-template name="formatDate">
<xsl:with-param name="date">
<xsl:value-of select="/SWDML/swShortFormTrade//swUnadjustedTerminationDate"/>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/calculationPeriodDates/terminationDate/unadjustedDate"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
</xsl:when>
<xsl:when test="$productType='FRA'">
<xsl:if test="/SWDML/swLongFormTrade">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/fra/adjustedTerminationDate)"/>
</xsl:call-template>
</xsl:if>
</xsl:when>
<xsl:when test="$productType='CapFloor'">
<xsl:if test="/SWDML/swLongFormTrade or /SWDML/swShortFormTrade//swUnadjustedTerminationDate">
<xsl:call-template name="formatDate">
<xsl:with-param name="date">
<xsl:value-of select="/SWDML/swShortFormTrade//swUnadjustedTerminationDate"/>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/capFloorStream/calculationPeriodDates/terminationDate/unadjustedDate"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
</xsl:when>
<xsl:when test="$productType='CDS Index'">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/creditDefaultSwap/generalTerms/scheduledTerminationDate/adjustableDate/unadjustedDate)"/>
</xsl:call-template>
</xsl:when>
</xsl:choose>
</xsl:variable>
<xsl:value-of select="$endDate"/>
</EndDate>
<FixedPaymentFreq>
<xsl:choose>
<xsl:when test="/SWDML/swShortFormTrade and (($productType='IRS') or ($productType='Swaption'))">
<xsl:value-of select="/SWDML/swShortFormTrade//swFixedPaymentFrequency/periodMultiplier"/>
<xsl:value-of select="/SWDML/swShortFormTrade//swFixedPaymentFrequency/period"/>
</xsl:when>
<xsl:when test="$productType='IRS' or $productType='OIS' or $productType='Swaption'">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$fixedLeg]/paymentDates/paymentFrequency/periodMultiplier"/>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$fixedLeg]/paymentDates/paymentFrequency/period"/>
</xsl:when>
</xsl:choose>
</FixedPaymentFreq>
<FixedPaymentFreq_2/>
<FloatPaymentFreq>
<xsl:choose>
<xsl:when test="/SWDML/swShortFormTrade and (($productType='IRS') or ($productType='Swaption'))">
<xsl:value-of select="/SWDML/swShortFormTrade//swFloatPaymentFrequency/periodMultiplier"/>
<xsl:value-of select="/SWDML/swShortFormTrade//swFloatPaymentFrequency/period"/>
</xsl:when>
<xsl:when test="$productType='IRS' or $productType='OIS' or $productType = 'Swaption'">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/paymentDates/paymentFrequency/periodMultiplier"/>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/paymentDates/paymentFrequency/period"/>
</xsl:when>
<xsl:when test="$productType='CapFloor'">
<xsl:value-of select="/SWDML/swShortFormTrade//paymentFrequency/periodMultiplier"/>
<xsl:value-of select="/SWDML/swShortFormTrade//paymentFrequency/period"/>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/capFloorStream/paymentDates/paymentFrequency/periodMultiplier"/>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/capFloorStream/paymentDates/paymentFrequency/period"/>
</xsl:when>
</xsl:choose>
</FloatPaymentFreq>
<FloatPaymentFreq_2/>
<FloatRollFreq>
<xsl:choose>
<xsl:when test="/SWDML/swShortFormTrade and (($productType='IRS') or ($productType='Swaption'))">
<xsl:value-of select="/SWDML/swShortFormTrade//swRollFrequency/periodMultiplier"/>
<xsl:value-of select="/SWDML/swShortFormTrade//swRollFrequency/period"/>
</xsl:when>
<xsl:when test="$productType='IRS' or $productType = 'Swaption'">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/calculationPeriodDates/calculationPeriodFrequency/periodMultiplier"/>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/calculationPeriodDates/calculationPeriodFrequency/period"/>
</xsl:when>
<xsl:when test="$productType='CapFloor'">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/capFloorStream/calculationPeriodDates/calculationPeriodFrequency/periodMultiplier"/>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/capFloorStream/calculationPeriodDates/calculationPeriodFrequency/period"/>
</xsl:when>
</xsl:choose>
</FloatRollFreq>
<FloatRollFreq_2/>
<RollsType>
<xsl:choose>
<xsl:when test="$productType='IRS' or $productType='OIS' or $productType='Swaption'">
<xsl:variable name="rollConvention">
<xsl:value-of select="/SWDML/swShortFormTrade//rollConvention"/>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/calculationPeriodDates/calculationPeriodFrequency/rollConvention"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="starts-with($rollConvention,'IMM')">IMM</xsl:when>
<xsl:otherwise>Standard</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType='CapFloor'">
<xsl:variable name="rollConvention">
<xsl:value-of select="/SWDML/swShortFormTrade//rollConvention"/>
<xsl:value-of select=" /SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/capFloorStream/calculationPeriodDates/calculationPeriodFrequency/rollConvention"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="starts-with($rollConvention,'IMM')">IMM</xsl:when>
<xsl:otherwise>Standard</xsl:otherwise>
</xsl:choose>
</xsl:when>
</xsl:choose>
</RollsType>
<RollsMethod>
<xsl:if test="($productType='IRS' or $productType='OIS') and ($currency='AUD' or $currency='NZD' or $currency='CAD')">
<xsl:variable name="rollConvention">
<xsl:value-of select="/SWDML/swShortFormTrade//rollConvention"/>
<xsl:value-of select="/SWDML/swLongFormTrade//swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/calculationPeriodDates/calculationPeriodFrequency/rollConvention"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="starts-with($rollConvention,'IMM') and string-length($rollConvention)=6">
<xsl:value-of select="substring($rollConvention,4,3)"/>
</xsl:when>
<xsl:when test="$rollConvention='IMM'">CME</xsl:when>
</xsl:choose>
</xsl:if>
</RollsMethod>
<RollDay>
<xsl:if test="$productType='IRS' or $productType='OIS' or $productType='Swaption' or $productType='CapFloor'">
<xsl:choose>
<xsl:when test="$productType='CapFloor'">
<xsl:variable name="rollConvention">
<xsl:value-of select="/SWDML/swShortFormTrade//rollConvention"/>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/capFloorStream/calculationPeriodDates/calculationPeriodFrequency/rollConvention"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="starts-with($rollConvention,'IMM')">IMM</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$rollConvention"/>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:otherwise>
<xsl:variable name="rollConvention">
<xsl:value-of select="/SWDML/swShortFormTrade//rollConvention"/>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/calculationPeriodDates/calculationPeriodFrequency/rollConvention"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="starts-with($rollConvention,'IMM')">IMM</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$rollConvention"/>
</xsl:otherwise>
</xsl:choose>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</RollDay>
<MonthEndRolls>
<xsl:if test="$productType='IRS' or $productType='OIS' or $productType='Swaption' or $productType='CapFloor'">
<xsl:variable name="rollConvention">
<xsl:value-of select="/SWDML/swShortFormTrade//rollConvention"/>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/calculationPeriodDates/calculationPeriodFrequency/rollConvention"/>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/capFloorStream/calculationPeriodDates/calculationPeriodFrequency/rollConvention"/>
</xsl:variable>
<xsl:value-of select="string(boolean($rollConvention='EOM'))"/>
</xsl:if>
</MonthEndRolls>
<FirstPeriodStartDate/>
<FirstPaymentDate/>
<LastRegularPaymentDate/>
<FixedRate>
<xsl:choose>
<xsl:when test="$productType='IRS' or $productType='OIS' or $productType='Swaption'">
<xsl:value-of select="/SWDML/swShortFormTrade//fixedRate"/>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$fixedLeg]/calculationPeriodAmount/calculation/fixedRateSchedule/initialValue"/>
</xsl:when>
<xsl:when test="$productType='FRA'">
<xsl:value-of select="/SWDML/swShortFormTrade/swFraParameters/fixedRate"/>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/fra/fixedRate"/>
</xsl:when>
<xsl:when test="$productType='CDS Index'">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/creditDefaultSwap/feeLeg/periodicPayment/fixedAmountCalculation/fixedRate"/>
</xsl:when>
</xsl:choose>
</FixedRate>
<FixedRate_2/>
<initialPoints/>
<quotationStyle/>
<RecoveryRate/>
<FixedSettlement/>
<Currency>
<xsl:value-of select="$currency"/>
</Currency>
<Currency_2/>
<Notional>
<xsl:choose>
<xsl:when test="$productType='IRS' or $productType='OIS' or $productType='Swaption'">
<xsl:value-of select="/SWDML/swShortFormTrade//notional/amount"/>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/calculationPeriodAmount/calculation/notionalSchedule/notionalStepSchedule/initialValue"/>
</xsl:when>
<xsl:when test="$productType='FRA'">
<xsl:value-of select="/SWDML/swShortFormTrade/swFraParameters/notional/amount"/>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/fra/notional/amount"/>
</xsl:when>
<xsl:when test="$productType='CapFloor'">
<xsl:value-of select="/SWDML/swShortFormTrade//notional/amount"/>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/capFloorStream/calculationPeriodAmount/calculation/notionalSchedule/notionalStepSchedule/initialValue"/>
</xsl:when>
<xsl:when test="$productType='CDS Index'">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/creditDefaultSwap/protectionTerms/calculationAmount/amount"/>
</xsl:when>
</xsl:choose>
</Notional>
<NotionalFloating/>
<Notional_2/>
<InitialNotional/>
<FixedAmount>
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$fixedLeg]/calculationPeriodAmount/knownAmountSchedule">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$fixedLeg]/calculationPeriodAmount/knownAmountSchedule/initialValue"/>
</xsl:when>
<xsl:when test="/SWDML/swShortFormTrade and ($productType='OIS' or $productType='IRS')">
<xsl:value-of select="/SWDML/swShortFormTrade//fixedAmount"/>
</xsl:when>
</xsl:choose>
</FixedAmount>
<FixedAmountCurrency>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$fixedLeg]/calculationPeriodAmount/knownAmountSchedule/currency"/>
</FixedAmountCurrency>
<FixedDayBasis>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$fixedLeg]/calculationPeriodAmount/calculation/dayCountFraction"/>
</FixedDayBasis>
<FloatDayBasis>
<xsl:choose>
<xsl:when test="$productType='IRS' or $productType='OIS' or $productType='Swaption'">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/calculationPeriodAmount/calculation/dayCountFraction"/>
</xsl:when>
<xsl:when test="$productType='FRA'">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/fra/dayCountFraction"/>
</xsl:when>
<xsl:when test="$productType='CapFloor'">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/capFloorStream/calculationPeriodAmount/calculation/dayCountFraction"/>
</xsl:when>
</xsl:choose>
</FloatDayBasis>
<FloatDayBasis_2/>
<FixedConvention>
<xsl:value-of select="substring(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$fixedLeg]/paymentDates/paymentDatesAdjustments/businessDayConvention,1,4)"/>
</FixedConvention>
<FixedCalcPeriodDatesConvention>
<xsl:if test="$productType='OIS' or $productType='IRS'">
<xsl:value-of select="substring(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$fixedLeg]/calculationPeriodDates/ calculationPeriodDatesAdjustments/ businessDayConvention,1,4)"/>
</xsl:if>
</FixedCalcPeriodDatesConvention>
<FixedTerminationDateConvention>
<xsl:if test="$productType='IRS' or $productType='OIS' or $productType='Swaption'">
<xsl:value-of select=" substring(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$fixedLeg]/calculationPeriodDates/terminationDate/dateAdjustments/businessDayConvention,1,4)"/>
</xsl:if>
</FixedTerminationDateConvention>
<FloatConvention>
<xsl:choose>
<xsl:when test="$productType='IRS' or $productType='OIS' or $productType='Swaption'">
<xsl:value-of select="substring(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/paymentDates/paymentDatesAdjustments/businessDayConvention,1,4)"/>
</xsl:when>
<xsl:when test="$productType='FRA'">
<xsl:value-of select="substring(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/fra/paymentDate/dateAdjustments/businessDayConvention,1,4)"/>
</xsl:when>
<xsl:when test="$productType='CapFloor'">
<xsl:value-of select="substring(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/capFloorStream/paymentDates/paymentDatesAdjustments/businessDayConvention,1,4)"/>
</xsl:when>
</xsl:choose>
</FloatConvention>
<FloatCalcPeriodDatesConvention>
<xsl:if test="$productType='OIS' or $productType='IRS'">
<xsl:value-of select="substring(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/calculationPeriodDates/ calculationPeriodDatesAdjustments/businessDayConvention,1,4)"/>
</xsl:if>
</FloatCalcPeriodDatesConvention>
<FloatTerminationDateConvention>
<xsl:if test="$productType='IRS' or $productType='OIS' or $productType='Swaption'">
<xsl:value-of select=" substring(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/calculationPeriodDates/terminationDate/dateAdjustments/businessDayConvention,1,4)"/>
</xsl:if>
</FloatTerminationDateConvention>
<FloatConvention_2/>
<FloatTerminationDateConvention_2/>
<FloatingRateIndex>
<xsl:choose>
<xsl:when test="$productType='IRS' or $productType='OIS' or $productType='Swaption'">
<xsl:value-of select="/SWDML/swShortFormTrade//floatingRateIndex"/>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/calculationPeriodAmount/calculation/floatingRateCalculation/floatingRateIndex"/>
</xsl:when>
<xsl:when test="$productType='FRA'">
<xsl:value-of select="/SWDML/swShortFormTrade/swFraParameters/floatingRateIndex"/>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/fra/floatingRateIndex"/>
</xsl:when>
<xsl:when test="$productType='CapFloor'">
<xsl:value-of select="/SWDML/swShortFormTrade//floatingRateIndex"/>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/capFloorStream/calculationPeriodAmount/calculation/floatingRateCalculation/floatingRateIndex"/>
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
<xsl:when test="$productType='IRS' and /SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swStub[2]">
<xsl:value-of select="/SWDML/swLongFormTrade//swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/stubCalculationPeriodAmount/initialStub/floatingRate[1]/indexTenor/periodMultiplier"/>
<xsl:value-of select="/SWDML/swLongFormTrade//swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/stubCalculationPeriodAmount/initialStub/floatingRate[1]/indexTenor/period"/>
</xsl:when>
<xsl:when test="/SWDML/swShortFormTrade and (($productType='IRS') or ($productType='Swaption'))">
<xsl:value-of select="/SWDML/swShortFormTrade//swStubIndexTenor[1]/periodMultiplier"/>
<xsl:value-of select="/SWDML/swShortFormTrade//swStubIndexTenor[1]/period"/>
</xsl:when>
<xsl:when test="$productType='FRA'">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/fra/indexTenor[1]/periodMultiplier"/>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/fra/indexTenor[1]/period"/>
</xsl:when>
<xsl:when test="$productType='CapFloor'">
<xsl:value-of select="/SWDML/swShortFormTrade//indexTenor/periodMultiplier"/>
<xsl:value-of select="/SWDML/swShortFormTrade//indexTenor/period"/>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/capFloorStream/calculationPeriodAmount/calculation/floatingRateCalculation/indexTenor/periodMultiplier"/>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/capFloorStream/calculationPeriodAmount/calculation/floatingRateCalculation/indexTenor/period"/>
</xsl:when>
<xsl:when test="$productType='IRS' or $productType='Swaption'">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/stubCalculationPeriodAmount//floatingRate[1]/indexTenor/periodMultiplier"/>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/stubCalculationPeriodAmount//floatingRate[1]/indexTenor/period"/>
</xsl:when>
</xsl:choose>
</IndexTenor1>
<IndexTenor1_2>
<xsl:choose>
<xsl:when test="$productType='CapFloor' and /SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/capFloorStream/stubCalculationPeriodAmount/initialStub">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/capFloorStream/stubCalculationPeriodAmount/initialStub/floatingRate[1]/indexTenor/periodMultiplier"/>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/capFloorStream/stubCalculationPeriodAmount/initialStub/floatingRate[1]/indexTenor/period"/>
</xsl:when>
</xsl:choose>
</IndexTenor1_2>
<LinearInterpolation>
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade and $productType='FRA'">
<xsl:value-of select="string(boolean(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/fra/indexTenor[2]))"/>
</xsl:when>
<xsl:when test="$productType='IRS' and /SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swStub[2]">
<xsl:value-of select="string(boolean(/SWDML/swLongFormTrade//swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/stubCalculationPeriodAmount/initialStub/floatingRate[2]))"/>
</xsl:when>
<xsl:when test="($productType='IRS' or $productType='Swaption') and /SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/stubCalculationPeriodAmount//floatingRate[1]">
<xsl:value-of select="string(boolean(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/stubCalculationPeriodAmount//floatingRate[2]))"/>
</xsl:when>
<xsl:when test="$productType='CapFloor' and /SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/capFloorStream/stubCalculationPeriodAmount/initialStub/floatingRate[1]">
<xsl:value-of select="string(boolean(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/capFloorStream/stubCalculationPeriodAmount/initialStub/floatingRate[2]))"/>
</xsl:when>
</xsl:choose>
</LinearInterpolation>
<LinearInterpolation_2/>
<IndexTenor2>
<xsl:choose>
<xsl:when test="/SWDML/swShortFormTrade and (($productType='IRS') or ($productType='Swaption'))">
<xsl:value-of select="/SWDML/swShortFormTrade//swStubIndexTenor[2]/periodMultiplier"/>
<xsl:value-of select="/SWDML/swShortFormTrade//swStubIndexTenor[2]/period"/>
</xsl:when>
<xsl:when test="$productType='FRA'">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/fra/indexTenor[2]/periodMultiplier"/>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/fra/indexTenor[2]/period"/>
</xsl:when>
<xsl:when test="$productType='IRS' and /SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swStub[2]">
<xsl:value-of select="/SWDML/swLongFormTrade//swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/stubCalculationPeriodAmount/initialStub/floatingRate[2]/indexTenor/periodMultiplier"/>
<xsl:value-of select="/SWDML/swLongFormTrade//swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/stubCalculationPeriodAmount/initialStub/floatingRate[2]/indexTenor/period"/>
</xsl:when>
<xsl:when test="$productType='IRS' or $productType='Swaption'">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/stubCalculationPeriodAmount//floatingRate[2]/indexTenor/periodMultiplier"/>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/stubCalculationPeriodAmount//floatingRate[2]/indexTenor/period"/>
</xsl:when>
<xsl:when test="$productType='CapFloor' and /SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/capFloorStream/stubCalculationPeriodAmount/initialStub/floatingRate[2]/indexTenor">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/capFloorStream/stubCalculationPeriodAmount/initialStub/floatingRate[2]/indexTenor/periodMultiplier"/>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/capFloorStream/stubCalculationPeriodAmount/initialStub/floatingRate[2]/indexTenor/period"/>
</xsl:when>
</xsl:choose>
</IndexTenor2>
<IndexTenor2_2/>
<InitialInterpolationIndex>
<xsl:choose>
<xsl:when test="/SWDML/swShortFormTrade//swStubFloatingRateIndex[2] and /SWDML/swShortFormTrade//swStubFloatingRateIndex[1] != /SWDML/swShortFormTrade//swStubFloatingRateIndex[2] and (($productType='IRS') or ($productType='Swaption'))">
<xsl:value-of select="/SWDML/swShortFormTrade//swStubFloatingRateIndex[1]"/>
</xsl:when>
<xsl:when test="$productType='CapFloor' and count(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/capFloorStream[$floatingLeg]/stubCalculationPeriodAmount//floatingRate)=2 and /SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/capFloorStream[$floatingLeg]/stubCalculationPeriodAmount//floatingRate[1]/floatingRateIndex != /SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/capFloorStream[$floatingLeg]/stubCalculationPeriodAmount//floatingRate[2]/floatingRateIndex">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/capFloorStream[$floatingLeg]/stubCalculationPeriodAmount//floatingRate[1]/floatingRateIndex"/>
</xsl:when>
<xsl:when test="$productType='IRS' and /SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swStub[2] and count(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/stubCalculationPeriodAmount/initialStub/floatingRate)=2 and /SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/stubCalculationPeriodAmount/initialStub/floatingRate[1]/floatingRateIndex != /SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/stubCalculationPeriodAmount/initialStub/floatingRate[2]/floatingRateIndex">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/stubCalculationPeriodAmount/initialStub/floatingRate[1]/floatingRateIndex"/>
</xsl:when>
<xsl:when test="($productType='IRS' or $productType='Swaption') and count(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[$floatingLeg]/stubCalculationPeriodAmount//floatingRate)=2 and /SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[$floatingLeg]/stubCalculationPeriodAmount//floatingRate[1]/floatingRateIndex != /SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[$floatingLeg]/stubCalculationPeriodAmount//floatingRate[2]/floatingRateIndex">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[$floatingLeg]/stubCalculationPeriodAmount//floatingRate[1]/floatingRateIndex"/>
</xsl:when>
</xsl:choose>
</InitialInterpolationIndex>
<InitialInterpolationIndex_2/>
<SpreadOverIndex>
<xsl:if test="/SWDML/swLongFormTrade and ($productType='IRS' or $productType='OIS' or $productType='CapFloor' or $productType='Swaption')">
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/calculationPeriodAmount/calculation/floatingRateCalculation/spreadSchedule/initialValue">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/calculationPeriodAmount/calculation/floatingRateCalculation/spreadSchedule/initialValue"/>
</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/capFloorStream/calculationPeriodAmount/calculation/floatingRateCalculation/spreadSchedule/initialValue">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/capFloorStream/calculationPeriodAmount/calculation/floatingRateCalculation/spreadSchedule/initialValue"/>
</xsl:when>
<xsl:otherwise>0</xsl:otherwise>
</xsl:choose>
</xsl:if>
</SpreadOverIndex>
<SpreadOverIndex_2/>
<FirstFixingRate>
<xsl:if test="$productType='IRS' or $productType='OIS' or $productType='Swaption'">
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/stubCalculationPeriodAmount/initialStub/stubRate">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/stubCalculationPeriodAmount/initialStub/stubRate"/>
</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/calculationPeriodAmount/calculation/floatingRateCalculation/initialRate">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/calculationPeriodAmount/calculation/floatingRateCalculation/initialRate"/>
</xsl:when>
<xsl:when test="/SWDML/swShortFormTrade//initialRate">
<xsl:value-of select="/SWDML/swShortFormTrade//initialRate"/>
</xsl:when>
</xsl:choose>
</xsl:if>
</FirstFixingRate>
<FirstFixingRate_2/>
<FixingDaysOffset>
<xsl:choose>
<xsl:when test="$productType='IRS' or $productType='OIS' or $productType='Swaption'">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/resetDates/fixingDates/periodMultiplier"/>
</xsl:when>
<xsl:when test="$productType='FRA'">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/fra/fixingDateOffset/periodMultiplier"/>
</xsl:when>
<xsl:when test="$productType='CapFloor'">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/capFloorStream/resetDates/fixingDates/periodMultiplier"/>
</xsl:when>
</xsl:choose>
</FixingDaysOffset>
<FixingDaysOffset_2/>
<FixingHolidayCentres>
<xsl:choose>
<xsl:when test="$productType='IRS' or $productType='OIS' or $productType='Swaption'">
<xsl:apply-templates select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/resetDates/fixingDates/businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:when>
<xsl:when test="$productType='FRA'">
<xsl:apply-templates select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/fra/fixingDateOffset/businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:when>
<xsl:when test="$productType='CapFloor'">
<xsl:apply-templates select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/capFloorStream/resetDates/fixingDates/businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:when>
</xsl:choose>
</FixingHolidayCentres>
<FixingHolidayCentres_2/>
<ResetInArrears>
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade and ($productType='IRS' or $productType='OIS' or $productType='Swaption')">
<xsl:value-of select="string(boolean(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/resetDates[resetRelativeTo='CalculationPeriodEndDate']))"/>
</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade and $productType='CapFloor'">
<xsl:value-of select="string(boolean(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/capFloorStream/resetDates[resetRelativeTo='CalculationPeriodEndDate']))"/>
</xsl:when>
</xsl:choose>
</ResetInArrears>
<ResetInArrears_2/>
<FirstFixingDifferent>
<xsl:if test="/SWDML/swLongFormTrade and $productType='IRS' or $productType='OIS' or $productType='Swaption'">
<xsl:value-of select="string(boolean(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/resetDates/initialFixingDate))"/>
</xsl:if>
</FirstFixingDifferent>
<FirstFixingDifferent_2/>
<FirstFixingDaysOffset>
<xsl:if test="$productType='IRS' or $productType='OIS' or $productType='Swaption'">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/resetDates/initialFixingDate/periodMultiplier"/>
</xsl:if>
</FirstFixingDaysOffset>
<FirstFixingDaysOffset_2/>
<FirstFixingHolidayCentres>
<xsl:if test="$productType='IRS' or $productType='OIS' or $productType='Swaption'">
<xsl:if test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/resetDates/initialFixingDate">
<xsl:apply-templates select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/resetDates/initialFixingDate/businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:if>
</xsl:if>
</FirstFixingHolidayCentres>
<FirstFixingHolidayCentres_2/>
<PaymentHolidayCentres>
<xsl:choose>
<xsl:when test="$productType='IRS' or $productType='OIS' or $productType='Swaption'">
<xsl:apply-templates select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/paymentDates/paymentDatesAdjustments/businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:when>
<xsl:when test="$productType='FRA'">
<xsl:apply-templates select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/fra/paymentDate/dateAdjustments/businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:when>
<xsl:when test="$productType='CapFloor'">
<xsl:apply-templates select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/capFloorStream/paymentDates/paymentDatesAdjustments/businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:when>
</xsl:choose>
</PaymentHolidayCentres>
<PaymentHolidayCentres_2>
<xsl:if test="$productType='IRS' or $productType='OIS'">
<xsl:apply-templates select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$fixedLeg]/paymentDates/paymentDatesAdjustments/businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:if>
</PaymentHolidayCentres_2>
<PaymentLag>
<xsl:if test="/SWDML/swLongFormTrade">
<xsl:if test="$productType='IRS' or $productType='OIS' or $productType='Swaption' or $productType='CapFloor'">
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/paymentDates/paymentDaysOffset">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/paymentDates/paymentDaysOffset/periodMultiplier"/>
</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/capFloorStream/paymentDates/paymentDaysOffset">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/capFloorStream/paymentDates/paymentDaysOffset/periodMultiplier"/>
</xsl:when>
<xsl:otherwise>0</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:if>
</PaymentLag>
<PaymentLag_2>
<xsl:if test="/SWDML/swLongFormTrade">
<xsl:if test="$productType='OIS' or $productType='IRS'">
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$fixedLeg]/paymentDates/paymentDaysOffset">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$fixedLeg]/paymentDates/paymentDaysOffset/periodMultiplier"/>
</xsl:when>
<xsl:otherwise>0</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:if>
</PaymentLag_2>
<RollHolidayCentres>
<xsl:choose>
<xsl:when test="$productType='IRS' or $productType='OIS' or $productType='Swaption'">
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade//swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/calculationPeriodDates/calculationPeriodDatesAdjustments/businessDayConvention != 'NONE'">
<xsl:apply-templates select="/SWDML/swLongFormTrade//swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/calculationPeriodDates/calculationPeriodDatesAdjustments/businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade//swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/calculationPeriodDates/terminationDate/dateAdjustments/businessDayConvention != 'NONE'">
<xsl:apply-templates select="/SWDML/swLongFormTrade//swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/calculationPeriodDates/terminationDate/dateAdjustments/businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:when>
<xsl:otherwise>
<xsl:apply-templates select="/SWDML/swLongFormTrade//swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/calculationPeriodDates/effectiveDate/dateAdjustments/businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType='CapFloor'">
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade//swStructuredTradeDetails/FpML/trade/capFloor/capFloorStream/calculationPeriodDates/calculationPeriodDatesAdjustments/businessDayConvention = 'NONE'">
<xsl:apply-templates select="/SWDML/swLongFormTrade//swStructuredTradeDetails/FpML/trade/capFloor/capFloorStream/paymentDates/paymentDatesAdjustments/businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:when>
<xsl:otherwise>
<xsl:apply-templates select="/SWDML/swLongFormTrade//swStructuredTradeDetails/FpML/trade/capFloor/capFloorStream/calculationPeriodDates/calculationPeriodDatesAdjustments/businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
</xsl:choose>
</RollHolidayCentres>
<RollHolidayCentres_2>
<xsl:if test="$productType='IRS' or $productType='OIS'">
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade//swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$fixedLeg]/calculationPeriodDates/calculationPeriodDatesAdjustments/businessDayConvention != 'NONE'">
<xsl:apply-templates select="/SWDML/swLongFormTrade//swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$fixedLeg]/calculationPeriodDates/calculationPeriodDatesAdjustments/businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade//swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$fixedLeg]/calculationPeriodDates/terminationDate/dateAdjustments/businessDayConvention != 'NONE'">
<xsl:apply-templates select="/SWDML/swLongFormTrade//swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$fixedLeg]/calculationPeriodDates/terminationDate/dateAdjustments/businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:when>
<xsl:otherwise>
<xsl:apply-templates select="/SWDML/swLongFormTrade//swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$fixedLeg]/calculationPeriodDates/effectiveDate/dateAdjustments/businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</RollHolidayCentres_2>
<AdjustFixedStartDate>
<xsl:if test="/SWDML/swLongFormTrade">
<xsl:if test="$productType='IRS' or $productType='OIS' or $productType='Swaption'">
<xsl:variable name="effDateBusDayConv" select="string(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$fixedLeg]/calculationPeriodDates/effectiveDate/dateAdjustments/businessDayConvention)"/>
<xsl:choose>
<xsl:when test="$effDateBusDayConv='NONE'">false</xsl:when>
<xsl:otherwise>true</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:if>
</AdjustFixedStartDate>
<AdjustFloatStartDate>
<xsl:if test="/SWDML/swLongFormTrade">
<xsl:choose>
<xsl:when test="$productType='IRS' or $productType='OIS' or $productType='Swaption'">
<xsl:variable name="effDateBusDayConv" select="string(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/calculationPeriodDates/effectiveDate/dateAdjustments/businessDayConvention)"/>
<xsl:choose>
<xsl:when test="$effDateBusDayConv='NONE'">false</xsl:when>
<xsl:otherwise>true</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType='CapFloor'">
<xsl:variable name="effDateBusDayConv" select="string(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/capFloorStream/calculationPeriodDates/effectiveDate/dateAdjustments/businessDayConvention)"/>
<xsl:choose>
<xsl:when test="$effDateBusDayConv='NONE'">false</xsl:when>
<xsl:otherwise>true</xsl:otherwise>
</xsl:choose>
</xsl:when>
</xsl:choose>
</xsl:if>
</AdjustFloatStartDate>
<AdjustFloatStartDate_2/>
<AdjustRollEnd>
<xsl:if test="/SWDML/swLongFormTrade">
<xsl:if test="$productType='IRS' or $productType='OIS' or $productType='Swaption'">
<xsl:variable name="fixedCalcPeriodBusDayConv" select="string(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$fixedLeg]/calculationPeriodDates/calculationPeriodDatesAdjustments/businessDayConvention)"/>
<xsl:choose>
<xsl:when test="$fixedCalcPeriodBusDayConv='NONE'">false</xsl:when>
<xsl:otherwise>true</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:if>
</AdjustRollEnd>
<AdjustFloatRollEnd>
<xsl:choose>
<xsl:when test="$productType='IRS' or $productType='OIS' or $productType='Swaption'">
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/calculationPeriodDates/calculationPeriodDatesAdjustments/businessDayConvention = 'NONE'">false</xsl:when>
<xsl:otherwise>true</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType='CapFloor'">
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/capFloorStream/calculationPeriodDates/calculationPeriodDatesAdjustments/businessDayConvention = 'NONE'">false</xsl:when>
<xsl:otherwise>true</xsl:otherwise>
</xsl:choose>
</xsl:when>
</xsl:choose>
</AdjustFloatRollEnd>
<AdjustFloatRollEnd_2/>
<AdjustFixedFinalRollEnd>
<xsl:if test="/SWDML/swLongFormTrade">
<xsl:if test="$productType='IRS' or $productType='OIS' or $productType='Swaption'">
<xsl:variable name="termDateBusDayConv" select="string(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$fixedLeg]/calculationPeriodDates/terminationDate/dateAdjustments/businessDayConvention)"/>
<xsl:choose>
<xsl:when test="$termDateBusDayConv='NONE'">false</xsl:when>
<xsl:otherwise>true</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:if>
</AdjustFixedFinalRollEnd>
<AdjustFinalRollEnd>
<xsl:if test="/SWDML/swLongFormTrade">
<xsl:choose>
<xsl:when test="$productType='IRS' or $productType='OIS' or $productType='Swaption'">
<xsl:variable name="termDateBusDayConv" select="string(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/calculationPeriodDates/terminationDate/dateAdjustments/businessDayConvention)"/>
<xsl:choose>
<xsl:when test="$termDateBusDayConv='NONE'">false</xsl:when>
<xsl:otherwise>true</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType='CapFloor'">
<xsl:variable name="termDateBusDayConv" select="string(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/capFloorStream/calculationPeriodDates/terminationDate/dateAdjustments/businessDayConvention)"/>
<xsl:choose>
<xsl:when test="$termDateBusDayConv='NONE'">false</xsl:when>
<xsl:otherwise>true</xsl:otherwise>
</xsl:choose>
</xsl:when>
</xsl:choose>
</xsl:if>
</AdjustFinalRollEnd>
<AdjustFinalRollEnd_2/>
<CompoundingMethod>
<xsl:if test="/SWDML/swLongFormTrade">
<xsl:choose>
<xsl:when test="$productType='IRS' or $productType='OIS' or $productType='Swaption'">
<xsl:variable name="compoundingMethod" select="string(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/calculationPeriodAmount/calculation/compoundingMethod)"/>
<xsl:choose>
<xsl:when test="$compoundingMethod='Flat'">F</xsl:when>
<xsl:when test="$compoundingMethod='Straight'">S</xsl:when>
<xsl:when test="$compoundingMethod='SpreadExclusive'">E</xsl:when>
<xsl:otherwise>N</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType='CapFloor'">
<xsl:variable name="compoundingMethod" select="string(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/capFloorStream/calculationPeriodAmount/calculation/compoundingMethod)"/>
<xsl:choose>
<xsl:when test="$compoundingMethod='Flat'">F</xsl:when>
<xsl:when test="$compoundingMethod='Straight'">S</xsl:when>
<xsl:when test="$compoundingMethod='SpreadExclusive'">E</xsl:when>
<xsl:otherwise>N</xsl:otherwise>
</xsl:choose>
</xsl:when>
</xsl:choose>
</xsl:if>
<xsl:if test="/SWDML/swShortFormTrade and (($productType='IRS') or ($productType='Swaption'))">
<xsl:variable name="compoundingMethod" select="string(/SWDML/swShortFormTrade//swCompoundingMethod)"/>
<xsl:choose>
<xsl:when test="$compoundingMethod='Flat'">F</xsl:when>
<xsl:when test="$compoundingMethod='Straight'">S</xsl:when>
<xsl:when test="$compoundingMethod='SpreadExclusive'">E</xsl:when>
<xsl:when test="$compoundingMethod='None'">N</xsl:when>
<xsl:otherwise>
<xsl:if test="/SWDML/swShortFormTrade//swFloatPaymentFrequency and /SWDML/swShortFormTrade//swRollFrequency">
<xsl:if test="(/SWDML/swShortFormTrade//swFloatPaymentFrequency/periodMultiplier=/SWDML/swShortFormTrade//swRollFrequency/periodMultiplier) and (/SWDML/swShortFormTrade//swFloatPaymentFrequency/period=/SWDML/swShortFormTrade//swRollFrequency/period)">N</xsl:if>
</xsl:if>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</CompoundingMethod>
<CompoundingMethod_2/>
<AveragingMethod/>
<AveragingMethod_2/>
<FloatingRateMultiplier/>
<FloatingRateMultiplier_2/>
<DesignatedMaturity>
<xsl:if test="$productType='IRS'">
<xsl:value-of select="/SWDML/swLongFormTrade//swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/calculationPeriodAmount/calculation/floatingRateCalculation/indexTenor/periodMultiplier"/>
<xsl:value-of select="/SWDML/swLongFormTrade//swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/calculationPeriodAmount/calculation/floatingRateCalculation/indexTenor/period"/>
</xsl:if>
</DesignatedMaturity>
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
<FallbackBondApplicable/>
<CalculationMethod/>
<CalculationStyle/>
<FinalPriceExchangeCalc/>
<SpreadCalculationMethod/>
<CouponRate/>
<Maturity/>
<RelatedBondValue/>
<RelatedBondID/>
<MTMRateSource/>
<MTMRateSourcePage/>
<MTMFixingDate/>
<MTMFixingHolidayCentres/>
<MTMFixingTime/>
<MTMLocation/>
<MTMCutoffTime/>
<CalculationPeriodDays>
<xsl:choose>
<xsl:when test="$productType='FRA'">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/fra/calculationPeriodNumberOfDays"/>
</xsl:when>
<xsl:when test="$productType='IRS' and $referenceCurrency='BRL'">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swFutureValue/calculationPeriodNumberOfDays"/>
</xsl:when>
</xsl:choose>
</CalculationPeriodDays>
<FraDiscounting>
<xsl:if test="$productType='FRA'">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/fra/fraDiscounting"/>
</xsl:if>
</FraDiscounting>
<HasBreak>
<xsl:if test="$productType='IRS' or $productType='Swaption' or $productType='CapFloor' or $productType='OIS'">
<xsl:choose>
<xsl:when test="/SWDML/swShortFormTrade//swEarlyTerminationProvision">true</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swEarlyTerminationProvision">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:if>
</HasBreak>
<BreakFromSwap>
<xsl:if test="$productType='IRS' or $productType='Swaption' or $productType='CapFloor'  or $productType='OIS'">
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swEarlyTerminationProvision/swBreakFirstDate[@offsetFromSwapEffectiveDate='true']">true</xsl:when>
<xsl:when test="/SWDML/swShortFormTrade//swEarlyTerminationProvision/swBreakFirstDate[@offsetFromSwapEffectiveDate='true']">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:if>
</BreakFromSwap>
<BreakOverride>
<xsl:if test="$productType='IRS' or $productType='Swaption' or $productType='CapFloor' or $productType='OIS'">
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swEarlyTerminationProvision/swBreakOverrideFirstDate">true</xsl:when>
<xsl:when test="/SWDML/swShortFormTrade//swEarlyTerminationProvision/swBreakOverrideFirstDate">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:if>
</BreakOverride>
<BreakCalculationMethod>
<xsl:if test="$productType='IRS' or $productType='Swaption' or $productType='CapFloor' or $productType='OIS'">
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swEarlyTerminationProvision/swBreakCalculationMethod='Adjust To Coupon Dates'">Adjusted</xsl:when>
<xsl:when test="/SWDML/swShortFormTrade//swEarlyTerminationProvision/swBreakCalculationMethod='Adjust To Coupon Dates'">Adjusted</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swEarlyTerminationProvision/swBreakCalculationMethod='Straight Calendar Dates'">Unadjusted</xsl:when>
<xsl:when test="/SWDML/swShortFormTrade//swEarlyTerminationProvision/swBreakCalculationMethod='Straight Calendar Dates'">Unadjusted</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade//swEarlyTerminationProvision/swBreakCalculationMethod='ISDA Standard Method'">Standard</xsl:when>
<xsl:when test="/SWDML/swShortFormTrade//swEarlyTerminationProvision/swBreakCalculationMethod='ISDA Standard Method'">Standard</xsl:when>
<xsl:otherwise>Standard</xsl:otherwise>
</xsl:choose>
</xsl:if>
</BreakCalculationMethod>
<BreakFirstDateTenor>
<xsl:if test="$productType='IRS' or $productType='Swaption' or $productType='CapFloor' or $productType='OIS'">
<xsl:choose>
<xsl:when test="/SWDML/swShortFormTrade//swEarlyTerminationProvision/swBreakFirstDate">
<xsl:value-of select="/SWDML/swShortFormTrade//swEarlyTerminationProvision/swBreakFirstDate/periodMultiplier"/>
<xsl:value-of select="/SWDML/swShortFormTrade//swEarlyTerminationProvision/swBreakFirstDate/period"/>
</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swEarlyTerminationProvision/swBreakFirstDate">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swEarlyTerminationProvision/swBreakFirstDate/periodMultiplier"/>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swEarlyTerminationProvision/swBreakFirstDate/period"/>
</xsl:when>
</xsl:choose>
</xsl:if>
</BreakFirstDateTenor>
<BreakFrequency>
<xsl:if test="$productType='IRS' or $productType='Swaption' or $productType='CapFloor' or $productType='OIS'">
<xsl:choose>
<xsl:when test="/SWDML/swShortFormTrade//swEarlyTerminationProvision/swBreakFrequency">
<xsl:value-of select="/SWDML/swShortFormTrade//swEarlyTerminationProvision/swBreakFrequency/periodMultiplier"/>
<xsl:value-of select="/SWDML/swShortFormTrade//swEarlyTerminationProvision/swBreakFrequency/period"/>
</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swEarlyTerminationProvision/swBreakFrequency">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swEarlyTerminationProvision/swBreakFrequency/periodMultiplier"/>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swEarlyTerminationProvision/swBreakFrequency/period"/>
</xsl:when>
</xsl:choose>
</xsl:if>
</BreakFrequency>
<BreakOptionA>
<xsl:if test="$productType='IRS' or $productType='Swaption' or $productType='OIS'">
<xsl:choose>
<xsl:when test="/SWDML/swShortFormTrade//swEarlyTerminationProvision/swMandatoryEarlyTerminationIndicator">M</xsl:when>
<xsl:when test="/SWDML/swShortFormTrade//swEarlyTerminationProvision">OM</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/earlyTerminationProvision/mandatoryEarlyTermination">M</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/earlyTerminationProvision/optionalEarlyTermination">
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/earlyTerminationProvision/optionalEarlyTermination/singlePartyOption/buyerPartyReference[@href=concat('#',$partyA)]">OUM</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/earlyTerminationProvision/optionalEarlyTermination/singlePartyOption/buyerPartyReference[@href=concat('#',$partyB)]">OUO</xsl:when>
<xsl:otherwise>OM</xsl:otherwise>
</xsl:choose>
</xsl:when>
</xsl:choose>
</xsl:if>
<xsl:if test="$productType='CapFloor'">
<xsl:choose>
<xsl:when test="/SWDML/swShortFormTrade//swEarlyTerminationProvision">OM</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/earlyTerminationProvision/mandatoryEarlyTermination">M</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/earlyTerminationProvision/optionalEarlyTermination">
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/earlyTerminationProvision/optionalEarlyTermination/singlePartyOption/buyerPartyReference[@href=concat('#',$partyA)]">OUM</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/earlyTerminationProvision/optionalEarlyTermination/singlePartyOption/buyerPartyReference[@href=concat('#',$partyB)]">OUO</xsl:when>
<xsl:otherwise>OM</xsl:otherwise>
</xsl:choose>
</xsl:when>
</xsl:choose>
</xsl:if>
</BreakOptionA>
<BreakDate>
<xsl:if test="$productType='IRS' or $productType='Swaption' or $productType='OIS'">
<xsl:if test="/SWDML/swShortFormTrade//swEarlyTerminationProvision/swBreakOverrideFirstDate">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string(/SWDML/swShortFormTrade//swEarlyTerminationProvision/swBreakOverrideFirstDate)"/>
</xsl:call-template>
</xsl:if>
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/earlyTerminationProvision">
<xsl:call-template name="formatDate">
<xsl:with-param name="date">
<xsl:apply-templates select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/earlyTerminationProvision/mandatoryEarlyTermination/mandatoryEarlyTerminationDate/unadjustedDate"/>
<xsl:apply-templates select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/earlyTerminationProvision/optionalEarlyTermination/cashSettlement/cashSettlementPaymentDate/adjustableDates/unadjustedDate[1]"/>
<xsl:apply-templates select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/earlyTerminationProvision/optionalEarlyTermination/cashSettlement/cashSettlementPaymentDate/businessDateRange/unadjustedFirstDate"/>
</xsl:with-param>
</xsl:call-template>
</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swEarlyTerminationProvision/swBreakOverrideFirstDate">
<xsl:call-template name="formatDate">
<xsl:with-param name="date">
<xsl:apply-templates select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swEarlyTerminationProvision/swBreakOverrideFirstDate"/>
</xsl:with-param>
</xsl:call-template>
</xsl:when>
</xsl:choose>
</xsl:if>
<xsl:if test="$productType='CapFloor'">
<xsl:if test="/SWDML/swShortFormTrade//swEarlyTerminationProvision/swBreakOverrideFirstDate">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string(/SWDML/swShortFormTrade//swEarlyTerminationProvision/swBreakOverrideFirstDate)"/>
</xsl:call-template>
</xsl:if>
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/earlyTerminationProvision">
<xsl:call-template name="formatDate">
<xsl:with-param name="date">
<xsl:apply-templates select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/earlyTerminationProvision/mandatoryEarlyTermination/mandatoryEarlyTerminationDate/unadjustedDate"/>
<xsl:apply-templates select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/earlyTerminationProvision/optionalEarlyTermination/cashSettlement/cashSettlementPaymentDate/adjustableDates/unadjustedDate[1]"/>
<xsl:apply-templates select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/earlyTerminationProvision/optionalEarlyTermination/cashSettlement/cashSettlementPaymentDate/businessDateRange/unadjustedFirstDate"/>
</xsl:with-param>
</xsl:call-template>
</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swEarlyTerminationProvision/swBreakOverrideFirstDate">
<xsl:call-template name="formatDate">
<xsl:with-param name="date">
<xsl:apply-templates select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swEarlyTerminationProvision/swBreakOverrideFirstDate"/>
</xsl:with-param>
</xsl:call-template>
</xsl:when>
</xsl:choose>
</xsl:if>
</BreakDate>
<BreakExpirationDate>
<xsl:if test="$productType='IRS' or $productType='Swaption' or $productType='OIS'">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/earlyTerminationProvision/optionalEarlyTermination//expirationDate/relativeDate/periodMultiplier"/>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/earlyTerminationProvision/optionalEarlyTermination/bermudaExercise/bermudaExerciseDates/relativeDates/periodMultiplier"/>
</xsl:if>
<xsl:if test="$productType='CapFloor'">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/earlyTerminationProvision/optionalEarlyTermination//expirationDate/relativeDate/periodMultiplier"/>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/earlyTerminationProvision/optionalEarlyTermination/bermudaExercise/bermudaExerciseDates/relativeDates/periodMultiplier"/>
</xsl:if>
</BreakExpirationDate>
<BreakEarliestTime>
<xsl:if test="$productType='IRS' or $productType='Swaption' or $productType='OIS'">
<xsl:if test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/earlyTerminationProvision/optionalEarlyTermination">
<xsl:call-template name="formatTime">
<xsl:with-param name="time" select="string(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/earlyTerminationProvision/optionalEarlyTermination//earliestExerciseTime/hourMinuteTime)"/>
</xsl:call-template>
</xsl:if>
</xsl:if>
<xsl:if test="$productType='CapFloor'">
<xsl:if test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/earlyTerminationProvision/optionalEarlyTermination">
<xsl:call-template name="formatTime">
<xsl:with-param name="time" select="string(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/earlyTerminationProvision/optionalEarlyTermination//earliestExerciseTime/hourMinuteTime)"/>
</xsl:call-template>
</xsl:if>
</xsl:if>
</BreakEarliestTime>
<BreakLatestTime/>
<BreakCalcAgentA>
<xsl:if test="$productType='IRS' or $productType='Swaption' or $productType='OIS'">
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/earlyTerminationProvision/mandatoryEarlyTermination">
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/earlyTerminationProvision/mandatoryEarlyTermination/calculationAgent/calculationAgentParty[.='AsSpecifiedInMasterAgreement']">As Specified in Master Agreement</xsl:when>
<xsl:when test="count(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/earlyTerminationProvision/mandatoryEarlyTermination/calculationAgent/calculationAgentPartyReference)=2">Joint</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/earlyTerminationProvision/mandatoryEarlyTermination/calculationAgent/calculationAgentPartyReference[@href=concat('#',$partyA)]">My Entity</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/earlyTerminationProvision/mandatoryEarlyTermination/calculationAgent/calculationAgentPartyReference[@href=concat('#',$partyB)]">Other Entity</xsl:when>
</xsl:choose>
</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/earlyTerminationProvision/optionalEarlyTermination">
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/earlyTerminationProvision/optionalEarlyTermination/calculationAgent/calculationAgentParty[.='AsSpecifiedInMasterAgreement']">As Specified in Master Agreement</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/earlyTerminationProvision/optionalEarlyTermination/calculationAgent/calculationAgentParty[.='NonExercisingParty']">Non-Exercising Party</xsl:when>
<xsl:when test="count(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/earlyTerminationProvision/optionalEarlyTermination/calculationAgent/calculationAgentPartyReference)=2">Joint</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/earlyTerminationProvision/optionalEarlyTermination/calculationAgent/calculationAgentPartyReference[@href=concat('#',$partyA)]">My Entity</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/earlyTerminationProvision/optionalEarlyTermination/calculationAgent/calculationAgentPartyReference[@href=concat('#',$partyB)]">Other Entity</xsl:when>
</xsl:choose>
</xsl:when>
</xsl:choose>
</xsl:if>
<xsl:if test="$productType='CapFloor'">
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/earlyTerminationProvision/mandatoryEarlyTermination">
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/earlyTerminationProvision/mandatoryEarlyTermination/calculationAgent/calculationAgentParty[.='AsSpecifiedInMasterAgreement']">As Specified in Master Agreement</xsl:when>
<xsl:when test="count(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/earlyTerminationProvision/mandatoryEarlyTermination/calculationAgent/calculationAgentPartyReference)=2">Joint</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/earlyTerminationProvision/mandatoryEarlyTermination/calculationAgent/calculationAgentPartyReference[@href=concat('#',$partyA)]">My Entity</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/earlyTerminationProvision/mandatoryEarlyTermination/calculationAgent/calculationAgentPartyReference[@href=concat('#',$partyB)]">Other Entity</xsl:when>
</xsl:choose>
</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/earlyTerminationProvision/optionalEarlyTermination">
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/earlyTerminationProvision/optionalEarlyTermination/calculationAgent/calculationAgentParty[.='AsSpecifiedInMasterAgreement']">As Specified in Master Agreement</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/earlyTerminationProvision/optionalEarlyTermination/calculationAgent/calculationAgentParty[.='NonExercisingParty']">Non-Exercising Party</xsl:when>
<xsl:when test="count(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/earlyTerminationProvision/optionalEarlyTermination/calculationAgent/calculationAgentPartyReference)=2">Joint</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/earlyTerminationProvision/optionalEarlyTermination/calculationAgent/calculationAgentPartyReference[@href=concat('#',$partyA)]">My Entity</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/earlyTerminationProvision/optionalEarlyTermination/calculationAgent/calculationAgentPartyReference[@href=concat('#',$partyB)]">Other Entity</xsl:when>
</xsl:choose>
</xsl:when>
</xsl:choose>
</xsl:if>
</BreakCalcAgentA>
<BreakExpiryTime>
<xsl:if test="$productType='IRS' or $productType='Swaption' or $productType='OIS'">
<xsl:if test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/earlyTerminationProvision/optionalEarlyTermination">
<xsl:call-template name="formatTime">
<xsl:with-param name="time" select="string(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/earlyTerminationProvision/optionalEarlyTermination//expirationTime/hourMinuteTime)"/>
</xsl:call-template>
</xsl:if>
</xsl:if>
<xsl:if test="$productType='CapFloor'">
<xsl:if test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/earlyTerminationProvision/optionalEarlyTermination">
<xsl:call-template name="formatTime">
<xsl:with-param name="time" select="string(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/earlyTerminationProvision/optionalEarlyTermination//expirationTime/hourMinuteTime)"/>
</xsl:call-template>
</xsl:if>
</xsl:if>
</BreakExpiryTime>
<BreakCashSettleCcy/>
<BreakLocation>
<xsl:if test="$productType='IRS' or $productType='Swaption' or $productType='OIS'">
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/earlyTerminationProvision/optionalEarlyTermination">
<xsl:apply-templates select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/earlyTerminationProvision/optionalEarlyTermination//earliestExerciseTime/businessCenter"/>
</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/earlyTerminationProvision/mandatoryEarlyTermination">
<xsl:apply-templates select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/earlyTerminationProvision/mandatoryEarlyTermination/cashSettlement/cashSettlementValuationTime/businessCenter"/>
</xsl:when>
</xsl:choose>
</xsl:if>
<xsl:if test="$productType='CapFloor'">
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/earlyTerminationProvision/optionalEarlyTermination">
<xsl:apply-templates select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/earlyTerminationProvision/optionalEarlyTermination//earliestExerciseTime/businessCenter"/>
</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/earlyTerminationProvision/mandatoryEarlyTermination">
<xsl:apply-templates select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/earlyTerminationProvision/mandatoryEarlyTermination/cashSettlement/cashSettlementValuationTime/businessCenter"/>
</xsl:when>
</xsl:choose>
</xsl:if>
</BreakLocation>
<BreakHolidayCentre>
<xsl:if test="$productType='IRS' or $productType='Swaption' or $productType='OIS'">
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/earlyTerminationProvision/optionalEarlyTermination">
<xsl:apply-templates select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/earlyTerminationProvision/optionalEarlyTermination/europeanExercise/expirationDate/relativeDate/businessCenters"/>
<xsl:apply-templates select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/earlyTerminationProvision/optionalEarlyTermination/bermudaExercise/bermudaExerciseDates/relativeDates/businessCenters"/>
<xsl:apply-templates select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/earlyTerminationProvision/optionalEarlyTermination/americanExercise/expirationDate/relativeDate/businessCenters"/>
</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/earlyTerminationProvision/mandatoryEarlyTermination">
<xsl:apply-templates select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/earlyTerminationProvision/mandatoryEarlyTermination/cashSettlement/cashSettlementValuationDate/businessCenters"/>
</xsl:when>
</xsl:choose>
</xsl:if>
<xsl:if test="$productType='CapFloor'">
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/earlyTerminationProvision/optionalEarlyTermination">
<xsl:apply-templates select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/earlyTerminationProvision/optionalEarlyTermination/europeanExercise/expirationDate/relativeDate/businessCenters"/>
<xsl:apply-templates select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/earlyTerminationProvision/optionalEarlyTermination/bermudaExercise/bermudaExerciseDates/relativeDates/businessCenters"/>
<xsl:apply-templates select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/earlyTerminationProvision/optionalEarlyTermination/americanExercise/expirationDate/relativeDate/businessCenters"/>
</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/earlyTerminationProvision/mandatoryEarlyTermination">
<xsl:apply-templates select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/earlyTerminationProvision/mandatoryEarlyTermination/cashSettlement/cashSettlementValuationDate/businessCenters"/>
</xsl:when>
</xsl:choose>
</xsl:if>
</BreakHolidayCentre>
<BreakSettlement>
<xsl:if test="$productType='IRS' or $productType='Swaption' or $productType='OIS'">
<xsl:if test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/earlyTerminationProvision//cashSettlement">
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/earlyTerminationProvision//cashSettlement/cashPriceMethod">Cash Price</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/earlyTerminationProvision//cashSettlement/cashPriceAlternateMethod">Cash Price - Alternate Method</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/earlyTerminationProvision//cashSettlement/parYieldCurveAdjustedMethod">Par Yield Curve - Adjusted</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/earlyTerminationProvision//cashSettlement/zeroCouponYieldAdjustedMethod">Zero Coupon Yield - Adjusted</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/earlyTerminationProvision//cashSettlement/parYieldCurveUnadjustedMethod">Par Yield Curve - Unadjusted</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swEarlyTerminationProvision/swCollateralizedCashPrice">Collateralized Cash Price</xsl:when>
</xsl:choose>
</xsl:if>
</xsl:if>
<xsl:if test="$productType='CapFloor'">
<xsl:if test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/earlyTerminationProvision//cashSettlement">
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/earlyTerminationProvision//cashSettlement/cashPriceMethod">Cash Price</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/earlyTerminationProvision//cashSettlement/cashPriceAlternateMethod">Cash Price - Alternate Method</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/earlyTerminationProvision//cashSettlement/parYieldCurveAdjustedMethod">Par Yield Curve - Adjusted</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/earlyTerminationProvision//cashSettlement/zeroCouponYieldAdjustedMethod">Zero Coupon Yield - Adjusted</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/earlyTerminationProvision//cashSettlement/parYieldCurveUnadjustedMethod">Par Yield Curve - Unadjusted</xsl:when>
</xsl:choose>
</xsl:if>
</xsl:if>
</BreakSettlement>
<BreakValuationDate>
<xsl:if test="$productType='IRS' or $productType='Swaption' or $productType='OIS'">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/earlyTerminationProvision//cashSettlementValuationDate/periodMultiplier"/>
</xsl:if>
<xsl:if test="$productType='CapFloor'">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/earlyTerminationProvision//cashSettlementValuationDate/periodMultiplier"/>
</xsl:if>
</BreakValuationDate>
<BreakValuationTime>
<xsl:if test="$productType='IRS' or $productType='Swaption' or $productType='OIS'">
<xsl:if test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/earlyTerminationProvision//cashSettlement">
<xsl:call-template name="formatTime">
<xsl:with-param name="time" select="string(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/earlyTerminationProvision//cashSettlement/cashSettlementValuationTime/hourMinuteTime)"/>
</xsl:call-template>
</xsl:if>
</xsl:if>
<xsl:if test="$productType='CapFloor'">
<xsl:if test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/earlyTerminationProvision//cashSettlement">
<xsl:call-template name="formatTime">
<xsl:with-param name="time" select="string(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/earlyTerminationProvision//cashSettlement/cashSettlementValuationTime/hourMinuteTime)"/>
</xsl:call-template>
</xsl:if>
</xsl:if>
</BreakValuationTime>
<BreakSource>
<xsl:if test="$productType='IRS' or $productType='Swaption' or $productType='OIS'">
<xsl:if test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/earlyTerminationProvision//cashSettlement">
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/earlyTerminationProvision//cashSettlement//settlementRateSource/informationSource/rateSourcePage">
<xsl:variable name="pageString" select="' Page '"/>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/earlyTerminationProvision//cashSettlement//settlementRateSource/informationSource/rateSource"/>
<xsl:value-of select="$pageString"/>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/earlyTerminationProvision//cashSettlement//settlementRateSource/informationSource/rateSourcePage"/>
</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/earlyTerminationProvision//cashSettlement//settlementRateSource/informationSource/rateSource[.='ISDA']">ISDA Source</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/earlyTerminationProvision//cashSettlement//settlementRateSource/informationSource/rateSource[.='ICESWAP']">ICESWAP Rate</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swEarlyTerminationProvision/swCollateralizedCashPrice/settlementRateSource/informationSource/rateSource[.='ISDA']">ISDA Source</xsl:when>
<xsl:otherwise>Reference Banks</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:if>
<xsl:if test="$productType='CapFloor'">
<xsl:if test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/earlyTerminationProvision//cashSettlement">
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/earlyTerminationProvision//cashSettlement//settlementRateSource/informationSource/rateSourcePage">
<xsl:variable name="pageString" select="' Page '"/>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/earlyTerminationProvision//cashSettlement//settlementRateSource/informationSource/rateSource"/>
<xsl:value-of select="$pageString"/>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/earlyTerminationProvision//cashSettlement//settlementRateSource/informationSource/rateSourcePage"/>
</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/earlyTerminationProvision//cashSettlement//settlementRateSource/informationSource/rateSource[.='ISDA']">ISDA Source</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/earlyTerminationProvision//cashSettlement//settlementRateSource/informationSource/rateSource[.='ICESWAP']">ICESWAP Rate</xsl:when>
<xsl:otherwise>Reference Banks</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:if>
</BreakSource>
<BreakReferenceBanks>
<xsl:if test="$productType='IRS' or $productType='Swaption' or $productType='OIS'">
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/earlyTerminationProvision//cashSettlementReferenceBanks">
<xsl:apply-templates select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/earlyTerminationProvision//cashSettlementReferenceBanks"/>
</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swEarlyTerminationProvision/swCollateralizedCashPrice/settlementRateSource/cashSettlementReferenceBanks">
<xsl:apply-templates select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swEarlyTerminationProvision/swCollateralizedCashPrice/settlementRateSource/cashSettlementReferenceBanks"/>
</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/earlyTerminationProvision">Agreed on exercise</xsl:when>
<xsl:otherwise/>
</xsl:choose>
</xsl:if>
<xsl:if test="$productType='CapFloor'">
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/earlyTerminationProvision//cashSettlementReferenceBanks">
<xsl:apply-templates select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/earlyTerminationProvision//cashSettlementReferenceBanks"/>
</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/earlyTerminationProvision">Agreed on exercise</xsl:when>
<xsl:otherwise/>
</xsl:choose>
</xsl:if>
</BreakReferenceBanks>
<BreakQuotation>
<xsl:if test="$productType='IRS' or $productType='Swaption' or $productType='OIS'">
<xsl:if test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/earlyTerminationProvision//cashSettlement//quotationRateType">
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/earlyTerminationProvision//cashSettlement//quotationRateType[.='Mid']">Mid</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/earlyTerminationProvision//cashSettlement//quotationRateType[.='Bid']">Bid</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/earlyTerminationProvision//cashSettlement//quotationRateType[.='Ask']">Ask</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/earlyTerminationProvision//cashSettlement//quotationRateType[.='ExercisingPartyPays']">Exercising Party Pays</xsl:when>
</xsl:choose>
</xsl:if>
<xsl:if test="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swEarlyTerminationProvision/swCollateralizedCashPrice/quotationRateType">
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swEarlyTerminationProvision/swCollateralizedCashPrice/quotationRateType[.='Mid']">Mid</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swEarlyTerminationProvision/swCollateralizedCashPrice/quotationRateType[.='Bid']">Bid</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swEarlyTerminationProvision/swCollateralizedCashPrice/quotationRateType[.='Ask']">Ask</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swEarlyTerminationProvision/swCollateralizedCashPrice/quotationRateType[.='ExercisingPartyPays']">Exercising Party Pays</xsl:when>
</xsl:choose>
</xsl:if>
</xsl:if>
<xsl:if test="$productType='CapFloor'">
<xsl:if test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/earlyTerminationProvision//cashSettlement//quotationRateType">
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/earlyTerminationProvision//cashSettlement//quotationRateType[.='Mid']">Mid</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/earlyTerminationProvision//cashSettlement//quotationRateType[.='Bid']">Bid</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/earlyTerminationProvision//cashSettlement//quotationRateType[.='Ask']">Ask</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/earlyTerminationProvision//cashSettlement//quotationRateType[.='ExercisingPartyPays']">Exercising Party Pays</xsl:when>
</xsl:choose>
</xsl:if>
</xsl:if>
</BreakQuotation>
<BreakMMVApplicableCSA/>
<BreakCollateralCurrency/>
<BreakCollateralInterestRate/>
<BreakAgreedDiscountRate/>
<BreakProtectedPartyA/>
<BreakMutuallyAgreedCH/>
<BreakPrescribedDocAdj/>
<ExchangeUnderlying>
<xsl:if test="$productType='IRS' or $productType='OIS'">
<xsl:choose>
<xsl:when test="/SWDML/swShortFormTrade//swAssociatedBonds">true</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swAssociatedBonds">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:if>
</ExchangeUnderlying>
<SwapSpread>
<xsl:if test="$productType='IRS' or $productType='OIS'">
<xsl:choose>
<xsl:when test="/SWDML/swShortFormTrade//swAssociatedBonds/swNegotiatedSpreadRate">
<xsl:value-of select="/SWDML/swShortFormTrade//swAssociatedBonds/swNegotiatedSpreadRate"/>
</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swAssociatedBonds/swNegotiatedSpreadRate">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swAssociatedBonds/swNegotiatedSpreadRate"/>
</xsl:when>
</xsl:choose>
</xsl:if>
</SwapSpread>
<BondId1>
<xsl:if test="$productType='IRS' or $productType='OIS'">
<xsl:value-of select="/SWDML/swShortFormTrade//swAssociatedBonds/swBondDetails[position()=1]/swBondId"/>
</xsl:if>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swAssociatedBonds/swBondDetails[position()=1]/swBondId"/>
</BondId1>
<BondName1>
<xsl:if test="$productType='IRS' or $productType='OIS'">
<xsl:value-of select="/SWDML/swShortFormTrade//swAssociatedBonds/swBondDetails[position()=1]/swBondName"/>
</xsl:if>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swAssociatedBonds/swBondDetails[position()=1]/swBondName"/>
</BondName1>
<BondAmount1>
<xsl:if test="$productType='IRS' or $productType='OIS'">
<xsl:value-of select="/SWDML/swShortFormTrade//swAssociatedBonds/swBondDetails[position()=1]/swBondFaceAmount"/>
</xsl:if>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swAssociatedBonds/swBondDetails[position()=1]/swBondFaceAmount"/>
</BondAmount1>
<BondPriceType1>
<xsl:if test="$productType='IRS' or $productType='OIS'">
<xsl:value-of select="/SWDML/swShortFormTrade//swAssociatedBonds/swBondDetails[position()=1]/swPriceType"/>
</xsl:if>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swAssociatedBonds/swBondDetails[position()=1]/swPriceType"/>
</BondPriceType1>
<BondPrice1>
<xsl:if test="$productType='IRS' or $productType='OIS'">
<xsl:value-of select="/SWDML/swShortFormTrade//swAssociatedBonds/swBondDetails[position()=1]/swBondPrice"/>
</xsl:if>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swAssociatedBonds/swBondDetails[position()=1]/swBondPrice"/>
</BondPrice1>
<BondId2>
<xsl:if test="$productType='IRS' or $productType='OIS'">
<xsl:value-of select="/SWDML/swShortFormTrade//swAssociatedBonds/swBondDetails[position()=2]/swBondId"/>
</xsl:if>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swAssociatedBonds/swBondDetails[position()=2]/swBondId"/>
</BondId2>
<BondName2>
<xsl:if test="$productType='IRS' or $productType='OIS'">
<xsl:value-of select="/SWDML/swShortFormTrade//swAssociatedBonds/swBondDetails[position()=2]/swBondName"/>
</xsl:if>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swAssociatedBonds/swBondDetails[position()=2]/swBondName"/>
</BondName2>
<BondAmount2>
<xsl:if test="$productType='IRS' or $productType='OIS'">
<xsl:value-of select="/SWDML/swShortFormTrade//swAssociatedBonds/swBondDetails[position()=2]/swBondFaceAmount"/>
</xsl:if>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swAssociatedBonds/swBondDetails[position()=2]/swBondFaceAmount"/>
</BondAmount2>
<BondPriceType2>
<xsl:if test="$productType='IRS' or $productType='OIS'">
<xsl:value-of select="/SWDML/swShortFormTrade//swAssociatedBonds/swBondDetails[position()=2]/swPriceType"/>
</xsl:if>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swAssociatedBonds/swBondDetails[position()=2]/swPriceType"/>
</BondPriceType2>
<BondPrice2>
<xsl:if test="$productType='IRS' or $productType='OIS'">
<xsl:value-of select="/SWDML/swShortFormTrade//swAssociatedBonds/swBondDetails[position()=2]/swBondPrice"/>
</xsl:if>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swAssociatedBonds/swBondDetails[position()=2]/swBondPrice"/>
</BondPrice2>
<StubAt>
<xsl:if test="$productType='IRS' or $productType='OIS' or $productType='Swaption' or $productType='CapFloor'">
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swStub[1]/swStubPosition">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swStub[1]/swStubPosition"/>
</xsl:when>
<xsl:when test="/SWDML/swShortFormTrade//swStubPosition">
<xsl:value-of select="/SWDML/swShortFormTrade//swStubPosition"/>
</xsl:when>
<xsl:otherwise>Start</xsl:otherwise>
</xsl:choose>
</xsl:if>
</StubAt>
<IsUserStartStub>
<xsl:variable name="stubAtPos">
<xsl:if test="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swStub[1]/swStubPosition">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swStub[1]/swStubPosition"/>
</xsl:if>
</xsl:variable>
<xsl:variable name="stubPeriod">
<xsl:if test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/calculationPeriodDates/stubPeriodType">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/calculationPeriodDates/stubPeriodType"/>
</xsl:if>
</xsl:variable>
<xsl:variable name="CapstubPeriod">
<xsl:if test="/SWDML/swLongFormTrade/swStructuredTradeDetails/capFloor/capFloorStream/calculationPeriodDates/stubPeriodType">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/capFloor/capFloorStream/calculationPeriodDates/stubPeriodType"/>
</xsl:if>
</xsl:variable>
<xsl:if test="$productType='IRS' or $productType='OIS' or $productType='Swaption'">
<xsl:choose>
<xsl:when test="$stubAtPos = 'Start'">true</xsl:when>
<xsl:when test="$stubPeriod = 'ShortInitial'">true</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/stubCalculationPeriodAmount/initialStub">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="$productType='CapFloor'">
<xsl:choose>
<xsl:when test="$stubAtPos = 'Start'">true</xsl:when>
<xsl:when test="$CapstubPeriod = 'ShortInitial'">true</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/capFloorStream/stubCalculationPeriodAmount/initialStub">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:if>
</IsUserStartStub>
<FixedStub>
<xsl:choose>
<xsl:when test="/SWDML/swShortFormTrade//swFixedStubLength and (($productType='IRS') or ($productType='Swaption'))">
<xsl:value-of select="/SWDML/swShortFormTrade//swFixedStubLength"/>
</xsl:when>
<xsl:when test="$productType='IRS' or $productType='OIS' or $productType='Swaption'">
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swStub[1]/swStubLength[@href=concat('#',$fixedLegId)]">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swStub[1]/swStubLength[@href=concat('#',$fixedLegId)]"/>
</xsl:when>
<xsl:otherwise>Short</xsl:otherwise>
</xsl:choose>
</xsl:when>
</xsl:choose>
</FixedStub>
<FloatStub>
<xsl:choose>
<xsl:when test="/SWDML/swShortFormTrade//swFloatStubLength and (($productType='IRS') or ($productType='Swaption'))">
<xsl:value-of select="/SWDML/swShortFormTrade//swFloatStubLength"/>
</xsl:when>
<xsl:when test="$productType='IRS' or $productType='OIS' or $productType='Swaption'">
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swStub[1]/swStubLength[@href=concat('#',$floatingLegId)]">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swStub[1]/swStubLength[@href=concat('#',$floatingLegId)]"/>
</xsl:when>
<xsl:otherwise>Short</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType='CapFloor'">
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swStub/swStubLength">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swStub/swStubLength"/>
</xsl:when>
<xsl:otherwise>Short</xsl:otherwise>
</xsl:choose>
</xsl:when>
</xsl:choose>
</FloatStub>
<FloatStub_2/>
<FrontAndBackStubs>
<xsl:if test="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swStub[2]">true</xsl:if>
</FrontAndBackStubs>
<FixedBackStub>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swStub[2]/swStubLength[@href=concat('#',$fixedLegId)]"/>
</FixedBackStub>
<FloatBackStub>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swStub[2]/swStubLength[@href=concat('#',$floatingLegId)]"/>
</FloatBackStub>
<BackStubIndexTenor1>
<xsl:if test="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swStub[2]">
<xsl:value-of select="/SWDML/swLongFormTrade//swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/stubCalculationPeriodAmount/finalStub/floatingRate[1]/indexTenor/periodMultiplier"/>
<xsl:value-of select="/SWDML/swLongFormTrade//swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/stubCalculationPeriodAmount/finalStub/floatingRate[1]/indexTenor/period"/>
</xsl:if>
</BackStubIndexTenor1>
<BackStubIndexTenor2>
<xsl:if test="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swStub[2]">
<xsl:value-of select="/SWDML/swLongFormTrade//swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/stubCalculationPeriodAmount/finalStub/floatingRate[2]/indexTenor/periodMultiplier"/>
<xsl:value-of select="/SWDML/swLongFormTrade//swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/stubCalculationPeriodAmount/finalStub/floatingRate[2]/indexTenor/period"/>
</xsl:if>
</BackStubIndexTenor2>
<BackStubLinearInterpolation>
<xsl:if test="$productType='IRS' and /SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swStub[2] and /SWDML/swLongFormTrade//swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/stubCalculationPeriodAmount/finalStub/floatingRate[1]">
<xsl:value-of select="string(boolean(/SWDML/swLongFormTrade//swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/stubCalculationPeriodAmount/finalStub/floatingRate[2]))"/>
</xsl:if>
</BackStubLinearInterpolation>
<BackStubInitialInterpIndex>
<xsl:if test="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swStub[2] and /SWDML/swLongFormTrade//swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/stubCalculationPeriodAmount/finalStub/floatingRate[2] and (/SWDML/swLongFormTrade//swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/stubCalculationPeriodAmount/finalStub/floatingRate[1]/floatingRateIndex!=/SWDML/swLongFormTrade//swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/stubCalculationPeriodAmount/finalStub/floatingRate[2]/floatingRateIndex)">
<xsl:value-of select="/SWDML/swLongFormTrade//swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/stubCalculationPeriodAmount/finalStub/floatingRate[1]/floatingRateIndex"/>
</xsl:if>
</BackStubInitialInterpIndex>
<FirstFixedRegPdStartDate>
<xsl:if test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$fixedLeg]/calculationPeriodDates/firstRegularPeriodStartDate">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$fixedLeg]/calculationPeriodDates/firstRegularPeriodStartDate)"/>
</xsl:call-template>
</xsl:if>
</FirstFixedRegPdStartDate>
<FirstFloatRegPdStartDate>
<xsl:if test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/calculationPeriodDates/firstRegularPeriodStartDate">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/calculationPeriodDates/firstRegularPeriodStartDate)"/>
</xsl:call-template>
</xsl:if>
</FirstFloatRegPdStartDate>
<LastFixedRegPdEndDate>
<xsl:if test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$fixedLeg]/calculationPeriodDates/lastRegularPeriodEndDate">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$fixedLeg]/calculationPeriodDates/lastRegularPeriodEndDate)"/>
</xsl:call-template>
</xsl:if>
</LastFixedRegPdEndDate>
<LastFloatRegPdEndDate>
<xsl:if test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/calculationPeriodDates/lastRegularPeriodEndDate">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/calculationPeriodDates/lastRegularPeriodEndDate)"/>
</xsl:call-template>
</xsl:if>
</LastFloatRegPdEndDate>
<MasterAgreement>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swTradeHeader/swMasterAgreementType"/>
</MasterAgreement>
<ManualConfirm>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swTradeHeader/swManualConfirmationRequired"/>
</ManualConfirm>
<NovationExecution>
<xsl:value-of select="/SWDML/swLongFormTrade//swStructuredTradeDetails/swExtendedTradeDetails/swTradeHeader/swNovationExecution"/>
</NovationExecution>
<ExclFromClearing>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swTradeHeader/swClearingNotRequired"/>
</ExclFromClearing>
<NonStdSettlInst>
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swTradeHeader/swStandardSettlementInstructions[.='true']">false</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swTradeHeader/swStandardSettlementInstructions[.='false']">true</xsl:when>
</xsl:choose>
</NonStdSettlInst>
<Normalised>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swTradeHeader/swNormalised"/>
</Normalised>
<DataMigrationId>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swTradeHeader/swDataMigrationId"/>
</DataMigrationId>
<NormalisedStubLength>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swTradeHeader/swNormalised/@stubLength"/>
</NormalisedStubLength>
<ClientClearing>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swTradeHeader/swClientClearing"/>
</ClientClearing>
<AutoSendForClearing>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swTradeHeader/swAutoSendForClearing"/>
</AutoSendForClearing>
<CBClearedTimestamp>
<xsl:value-of select="/SWDML/swLongFormTrade//swStructuredTradeDetails/swExtendedTradeDetails/swTradeHeader/swCBClearedTimestamp"/>
</CBClearedTimestamp>
<CBTradeType>
<xsl:value-of select="/SWDML/swLongFormTrade//swStructuredTradeDetails/swExtendedTradeDetails/swTradeHeader/swCBTradeType"/>
</CBTradeType>
<ASICMandatoryClearingIndicator>
<xsl:value-of select="/SWDML/swLongFormTrade//swStructuredTradeDetails/swExtendedTradeDetails/swTradeHeader/swMandatoryClearing[swJurisdiction='ASIC']/swMandatoryClearingIndicator"/>
</ASICMandatoryClearingIndicator>
<NewNovatedASICMandatoryClearingIndicator>
<xsl:value-of select="/SWDML/swLongFormTrade/novation/swMandatoryClearingNewNovatedTrade[swJurisdiction='ASIC']/swMandatoryClearingIndicator"/>
</NewNovatedASICMandatoryClearingIndicator>
<PBEBTradeASICMandatoryClearingIndicator>
<xsl:value-of select="/SWDML/swLongFormTrade/swGiveUp/swInterDealerTransaction/swMandatoryClearing[swJurisdiction='ASIC']/swMandatoryClearingIndicator"/>
</PBEBTradeASICMandatoryClearingIndicator>
<PBClientTradeASICMandatoryClearingIndicator>
<xsl:value-of select="/SWDML/swLongFormTrade/swGiveUp/swCustomerTransaction/swMandatoryClearing[swJurisdiction='ASIC']/swMandatoryClearingIndicator"/>
</PBClientTradeASICMandatoryClearingIndicator>
<CANMandatoryClearingIndicator>
<xsl:value-of select="/SWDML/swLongFormTrade//swStructuredTradeDetails/swExtendedTradeDetails/swTradeHeader/swMandatoryClearing[swJurisdiction='CAN']/swMandatoryClearingIndicator"/>
</CANMandatoryClearingIndicator>
<CANClearingExemptIndicator1PartyId>
<xsl:value-of select="/SWDML/swLongFormTrade//swStructuredTradeDetails/FpML/trade/party[@id=substring-after(/SWDML/swLongFormTrade//swStructuredTradeDetails/swExtendedTradeDetails/swTradeHeader/swMandatoryClearing[swJurisdiction='CAN']/swPartyExemption[1]/swPartyReference/@href,'#')]/partyId"/>
</CANClearingExemptIndicator1PartyId>
<CANClearingExemptIndicator1Value>
<xsl:value-of select="/SWDML/swLongFormTrade//swStructuredTradeDetails/swExtendedTradeDetails/swTradeHeader/swMandatoryClearing[swJurisdiction='CAN']/swPartyExemption[1]/swExemption"/>
</CANClearingExemptIndicator1Value>
<CANClearingExemptIndicator2PartyId>
<xsl:value-of select="/SWDML/swLongFormTrade//swStructuredTradeDetails/FpML/trade/party[@id=substring-after(/SWDML/swLongFormTrade//swStructuredTradeDetails/swExtendedTradeDetails/swTradeHeader/swMandatoryClearing[swJurisdiction='CAN']/swPartyExemption[2]/swPartyReference/@href,'#')]/partyId"/>
</CANClearingExemptIndicator2PartyId>
<CANClearingExemptIndicator2Value>
<xsl:value-of select="/SWDML/swLongFormTrade//swStructuredTradeDetails/swExtendedTradeDetails/swTradeHeader/swMandatoryClearing[swJurisdiction='CAN']/swPartyExemption[2]/swExemption"/>
</CANClearingExemptIndicator2Value>
<NewNovatedCANMandatoryClearingIndicator>
<xsl:value-of select="/SWDML/swLongFormTrade/novation/swMandatoryClearingNewNovatedTrade[swJurisdiction='CAN']/swMandatoryClearingIndicator"/>
</NewNovatedCANMandatoryClearingIndicator>
<NewNovatedCANClearingExemptIndicator1PartyId>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/party[@id=substring-after(/SWDML/swLongFormTrade/novation/swMandatoryClearingNewNovatedTrade[swJurisdiction='CAN']/swPartyExemption[1]/swPartyReference/@href,'#')]/partyId"/>
</NewNovatedCANClearingExemptIndicator1PartyId>
<NewNovatedCANClearingExemptIndicator1Value>
<xsl:value-of select="/SWDML/swLongFormTrade/novation/swMandatoryClearingNewNovatedTrade[swJurisdiction='CAN']/swPartyExemption[1]/swExemption"/>
</NewNovatedCANClearingExemptIndicator1Value>
<NewNovatedCANClearingExemptIndicator2PartyId>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/party[@id=substring-after(/SWDML/swLongFormTrade/novation/swMandatoryClearingNewNovatedTrade[swJurisdiction='CAN']/swPartyExemption[2]/swPartyReference/@href,'#')]/partyId"/>
</NewNovatedCANClearingExemptIndicator2PartyId>
<NewNovatedCANClearingExemptIndicator2Value>
<xsl:value-of select="/SWDML/swLongFormTrade/novation/swMandatoryClearingNewNovatedTrade[swJurisdiction='CAN']/swPartyExemption[2]/swExemption"/>
</NewNovatedCANClearingExemptIndicator2Value>
<PBEBTradeCANMandatoryClearingIndicator>
<xsl:value-of select="/SWDML/swLongFormTrade/swGiveUp/swInterDealerTransaction/swMandatoryClearing[swJurisdiction='CAN']/swMandatoryClearingIndicator"/>
</PBEBTradeCANMandatoryClearingIndicator>
<PBEBTradeCANClearingExemptIndicator1PartyId>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/party[@id=substring-after(/SWDML/swLongFormTrade/swGiveUp/swInterDealerTransaction/swMandatoryClearing[swJurisdiction='CAN']/swPartyExemption[1]/swPartyReference/@href,'#')]/partyId"/>
</PBEBTradeCANClearingExemptIndicator1PartyId>
<PBEBTradeCANClearingExemptIndicator1Value>
<xsl:value-of select="/SWDML/swLongFormTrade/swGiveUp/swInterDealerTransaction/swMandatoryClearing[swJurisdiction='CAN']/swPartyExemption[1]/swExemption"/>
</PBEBTradeCANClearingExemptIndicator1Value>
<PBEBTradeCANClearingExemptIndicator2PartyId>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/party[@id=substring-after(/SWDML/swLongFormTrade/swGiveUp/swInterDealerTransaction/swMandatoryClearing[swJurisdiction='CAN']/swPartyExemption[2]/swPartyReference/@href,'#')]/partyId"/>
</PBEBTradeCANClearingExemptIndicator2PartyId>
<PBEBTradeCANClearingExemptIndicator2Value>
<xsl:value-of select="/SWDML/swLongFormTrade/swGiveUp/swInterDealerTransaction/swMandatoryClearing[swJurisdiction='CAN']/swPartyExemption[2]/swExemption"/>
</PBEBTradeCANClearingExemptIndicator2Value>
<PBClientTradeCANMandatoryClearingIndicator>
<xsl:value-of select="/SWDML/swLongFormTrade/swGiveUp/swCustomerTransaction/swMandatoryClearing[swJurisdiction='CAN']/swMandatoryClearingIndicator"/>
</PBClientTradeCANMandatoryClearingIndicator>
<PBClientTradeCANClearingExemptIndicator1PartyId>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/party[@id=substring-after(/SWDML/swLongFormTrade/swGiveUp/swCustomerTransaction/swMandatoryClearing[swJurisdiction='CAN']/swPartyExemption[1]/swPartyReference/@href,'#')]/partyId"/>
</PBClientTradeCANClearingExemptIndicator1PartyId>
<PBClientTradeCANClearingExemptIndicator1Value>
<xsl:value-of select="/SWDML/swLongFormTrade/swGiveUp/swCustomerTransaction/swMandatoryClearing[swJurisdiction='CAN']/swPartyExemption[1]/swExemption"/>
</PBClientTradeCANClearingExemptIndicator1Value>
<PBClientTradeCANClearingExemptIndicator2PartyId>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/party[@id=substring-after(/SWDML/swLongFormTrade/swGiveUp/swCustomerTransaction/swMandatoryClearing[swJurisdiction='CAN']/swPartyExemption[2]/swPartyReference/@href,'#')]/partyId"/>
</PBClientTradeCANClearingExemptIndicator2PartyId>
<PBClientTradeCANClearingExemptIndicator2Value>
<xsl:value-of select="/SWDML/swLongFormTrade/swGiveUp/swCustomerTransaction/swMandatoryClearing[swJurisdiction='CAN']/swPartyExemption[2]/swExemption"/>
</PBClientTradeCANClearingExemptIndicator2Value>
<ESMAMandatoryClearingIndicator>
<xsl:value-of select="/SWDML/swLongFormTrade//swStructuredTradeDetails/swExtendedTradeDetails/swTradeHeader/swMandatoryClearing[swJurisdiction='ESMA']/swMandatoryClearingIndicator"/>
</ESMAMandatoryClearingIndicator>
<ESMAClearingExemptIndicator1PartyId>
<xsl:value-of select="/SWDML/swLongFormTrade//swStructuredTradeDetails/FpML/trade/party[@id=substring-after(/SWDML/swLongFormTrade//swStructuredTradeDetails/swExtendedTradeDetails/swTradeHeader/swMandatoryClearing[swJurisdiction='ESMA']/swPartyExemption[1]/swPartyReference/@href,'#')]/partyId"/>
</ESMAClearingExemptIndicator1PartyId>
<ESMAClearingExemptIndicator1Value>
<xsl:value-of select="/SWDML/swLongFormTrade//swStructuredTradeDetails/swExtendedTradeDetails/swTradeHeader/swMandatoryClearing[swJurisdiction='ESMA']/swPartyExemption[1]/swExemption"/>
</ESMAClearingExemptIndicator1Value>
<ESMAClearingExemptIndicator2PartyId>
<xsl:value-of select="/SWDML/swLongFormTrade//swStructuredTradeDetails/FpML/trade/party[@id=substring-after(/SWDML/swLongFormTrade//swStructuredTradeDetails/swExtendedTradeDetails/swTradeHeader/swMandatoryClearing[swJurisdiction='ESMA']/swPartyExemption[2]/swPartyReference/@href,'#')]/partyId"/>
</ESMAClearingExemptIndicator2PartyId>
<ESMAClearingExemptIndicator2Value>
<xsl:value-of select="/SWDML/swLongFormTrade//swStructuredTradeDetails/swExtendedTradeDetails/swTradeHeader/swMandatoryClearing[swJurisdiction='ESMA']/swPartyExemption[2]/swExemption"/>
</ESMAClearingExemptIndicator2Value>
<NewNovatedESMAMandatoryClearingIndicator>
<xsl:value-of select="/SWDML/swLongFormTrade/novation/swMandatoryClearingNewNovatedTrade[swJurisdiction='ESMA']/swMandatoryClearingIndicator"/>
</NewNovatedESMAMandatoryClearingIndicator>
<NewNovatedESMAClearingExemptIndicator1PartyId>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/party[@id=substring-after(/SWDML/swLongFormTrade/novation/swMandatoryClearingNewNovatedTrade[swJurisdiction='ESMA']/swPartyExemption[1]/swPartyReference/@href,'#')]/partyId"/>
</NewNovatedESMAClearingExemptIndicator1PartyId>
<NewNovatedESMAClearingExemptIndicator1Value>
<xsl:value-of select="/SWDML/swLongFormTrade/novation/swMandatoryClearingNewNovatedTrade[swJurisdiction='ESMA']/swPartyExemption[1]/swExemption"/>
</NewNovatedESMAClearingExemptIndicator1Value>
<NewNovatedESMAClearingExemptIndicator2PartyId>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/party[@id=substring-after(/SWDML/swLongFormTrade/novation/swMandatoryClearingNewNovatedTrade[swJurisdiction='ESMA']/swPartyExemption[2]/swPartyReference/@href,'#')]/partyId"/>
</NewNovatedESMAClearingExemptIndicator2PartyId>
<NewNovatedESMAClearingExemptIndicator2Value>
<xsl:value-of select="/SWDML/swLongFormTrade/novation/swMandatoryClearingNewNovatedTrade[swJurisdiction='ESMA']/swPartyExemption[2]/swExemption"/>
</NewNovatedESMAClearingExemptIndicator2Value>
<PBEBTradeESMAMandatoryClearingIndicator>
<xsl:value-of select="/SWDML/swLongFormTrade/swGiveUp/swInterDealerTransaction/swMandatoryClearing[swJurisdiction='ESMA']/swMandatoryClearingIndicator"/>
</PBEBTradeESMAMandatoryClearingIndicator>
<PBEBTradeESMAClearingExemptIndicator1PartyId>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/party[@id=substring-after(/SWDML/swLongFormTrade/swGiveUp/swInterDealerTransaction/swMandatoryClearing[swJurisdiction='ESMA']/swPartyExemption[1]/swPartyReference/@href,'#')]/partyId"/>
</PBEBTradeESMAClearingExemptIndicator1PartyId>
<PBEBTradeESMAClearingExemptIndicator1Value>
<xsl:value-of select="/SWDML/swLongFormTrade/swGiveUp/swInterDealerTransaction/swMandatoryClearing[swJurisdiction='ESMA']/swPartyExemption[1]/swExemption"/>
</PBEBTradeESMAClearingExemptIndicator1Value>
<PBEBTradeESMAClearingExemptIndicator2PartyId>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/party[@id=substring-after(/SWDML/swLongFormTrade/swGiveUp/swInterDealerTransaction/swMandatoryClearing[swJurisdiction='ESMA']/swPartyExemption[2]/swPartyReference/@href,'#')]/partyId"/>
</PBEBTradeESMAClearingExemptIndicator2PartyId>
<PBEBTradeESMAClearingExemptIndicator2Value>
<xsl:value-of select="/SWDML/swLongFormTrade/swGiveUp/swInterDealerTransaction/swMandatoryClearing[swJurisdiction='ESMA']/swPartyExemption[2]/swExemption"/>
</PBEBTradeESMAClearingExemptIndicator2Value>
<PBClientTradeESMAMandatoryClearingIndicator>
<xsl:value-of select="/SWDML/swLongFormTrade/swGiveUp/swCustomerTransaction/swMandatoryClearing[swJurisdiction='ESMA']/swMandatoryClearingIndicator"/>
</PBClientTradeESMAMandatoryClearingIndicator>
<PBClientTradeESMAClearingExemptIndicator1PartyId>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/party[@id=substring-after(/SWDML/swLongFormTrade/swGiveUp/swCustomerTransaction/swMandatoryClearing[swJurisdiction='ESMA']/swPartyExemption[1]/swPartyReference/@href,'#')]/partyId"/>
</PBClientTradeESMAClearingExemptIndicator1PartyId>
<PBClientTradeESMAClearingExemptIndicator1Value>
<xsl:value-of select="/SWDML/swLongFormTrade/swGiveUp/swCustomerTransaction/swMandatoryClearing[swJurisdiction='ESMA']/swPartyExemption[1]/swExemption"/>
</PBClientTradeESMAClearingExemptIndicator1Value>
<PBClientTradeESMAClearingExemptIndicator2PartyId>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/party[@id=substring-after(/SWDML/swLongFormTrade/swGiveUp/swCustomerTransaction/swMandatoryClearing[swJurisdiction='ESMA']/swPartyExemption[2]/swPartyReference/@href,'#')]/partyId"/>
</PBClientTradeESMAClearingExemptIndicator2PartyId>
<PBClientTradeESMAClearingExemptIndicator2Value>
<xsl:value-of select="/SWDML/swLongFormTrade/swGiveUp/swCustomerTransaction/swMandatoryClearing[swJurisdiction='ESMA']/swPartyExemption[2]/swExemption"/>
</PBClientTradeESMAClearingExemptIndicator2Value>
<FCAMandatoryClearingIndicator>
<xsl:value-of select="/SWDML/swLongFormTrade//swStructuredTradeDetails/swExtendedTradeDetails/swTradeHeader/swMandatoryClearing[swJurisdiction='FCA']/swMandatoryClearingIndicator"/>
</FCAMandatoryClearingIndicator>
<FCAClearingExemptIndicator1PartyId>
<xsl:value-of select="/SWDML/swLongFormTrade//swStructuredTradeDetails/FpML/trade/party[@id=substring-after(/SWDML/swLongFormTrade//swStructuredTradeDetails/swExtendedTradeDetails/swTradeHeader/swMandatoryClearing[swJurisdiction='FCA']/swPartyExemption[1]/swPartyReference/@href,'#')]/partyId"/>
</FCAClearingExemptIndicator1PartyId>
<FCAClearingExemptIndicator1Value>
<xsl:value-of select="/SWDML/swLongFormTrade//swStructuredTradeDetails/swExtendedTradeDetails/swTradeHeader/swMandatoryClearing[swJurisdiction='FCA']/swPartyExemption[1]/swExemption"/>
</FCAClearingExemptIndicator1Value>
<FCAClearingExemptIndicator2PartyId>
<xsl:value-of select="/SWDML/swLongFormTrade//swStructuredTradeDetails/FpML/trade/party[@id=substring-after(/SWDML/swLongFormTrade//swStructuredTradeDetails/swExtendedTradeDetails/swTradeHeader/swMandatoryClearing[swJurisdiction='FCA']/swPartyExemption[2]/swPartyReference/@href,'#')]/partyId"/>
</FCAClearingExemptIndicator2PartyId>
<FCAClearingExemptIndicator2Value>
<xsl:value-of select="/SWDML/swLongFormTrade//swStructuredTradeDetails/swExtendedTradeDetails/swTradeHeader/swMandatoryClearing[swJurisdiction='FCA']/swPartyExemption[2]/swExemption"/>
</FCAClearingExemptIndicator2Value>
<NewNovatedFCAMandatoryClearingIndicator>
<xsl:value-of select="/SWDML/swLongFormTrade/novation/swMandatoryClearingNewNovatedTrade[swJurisdiction='FCA']/swMandatoryClearingIndicator"/>
</NewNovatedFCAMandatoryClearingIndicator>
<NewNovatedFCAClearingExemptIndicator1PartyId>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/party[@id=substring-after(/SWDML/swLongFormTrade/novation/swMandatoryClearingNewNovatedTrade[swJurisdiction='FCA']/swPartyExemption[1]/swPartyReference/@href,'#')]/partyId"/>
</NewNovatedFCAClearingExemptIndicator1PartyId>
<NewNovatedFCAClearingExemptIndicator1Value>
<xsl:value-of select="/SWDML/swLongFormTrade/novation/swMandatoryClearingNewNovatedTrade[swJurisdiction='FCA']/swPartyExemption[1]/swExemption"/>
</NewNovatedFCAClearingExemptIndicator1Value>
<NewNovatedFCAClearingExemptIndicator2PartyId>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/party[@id=substring-after(/SWDML/swLongFormTrade/novation/swMandatoryClearingNewNovatedTrade[swJurisdiction='FCA']/swPartyExemption[2]/swPartyReference/@href,'#')]/partyId"/>
</NewNovatedFCAClearingExemptIndicator2PartyId>
<NewNovatedFCAClearingExemptIndicator2Value>
<xsl:value-of select="/SWDML/swLongFormTrade/novation/swMandatoryClearingNewNovatedTrade[swJurisdiction='FCA']/swPartyExemption[2]/swExemption"/>
</NewNovatedFCAClearingExemptIndicator2Value>
<PBEBTradeFCAMandatoryClearingIndicator>
<xsl:value-of select="/SWDML/swLongFormTrade/swGiveUp/swInterDealerTransaction/swMandatoryClearing[swJurisdiction='FCA']/swMandatoryClearingIndicator"/>
</PBEBTradeFCAMandatoryClearingIndicator>
<PBEBTradeFCAClearingExemptIndicator1PartyId>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/party[@id=substring-after(/SWDML/swLongFormTrade/swGiveUp/swInterDealerTransaction/swMandatoryClearing[swJurisdiction='FCA']/swPartyExemption[1]/swPartyReference/@href,'#')]/partyId"/>
</PBEBTradeFCAClearingExemptIndicator1PartyId>
<PBEBTradeFCAClearingExemptIndicator1Value>
<xsl:value-of select="/SWDML/swLongFormTrade/swGiveUp/swInterDealerTransaction/swMandatoryClearing[swJurisdiction='FCA']/swPartyExemption[1]/swExemption"/>
</PBEBTradeFCAClearingExemptIndicator1Value>
<PBEBTradeFCAClearingExemptIndicator2PartyId>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/party[@id=substring-after(/SWDML/swLongFormTrade/swGiveUp/swInterDealerTransaction/swMandatoryClearing[swJurisdiction='FCA']/swPartyExemption[2]/swPartyReference/@href,'#')]/partyId"/>
</PBEBTradeFCAClearingExemptIndicator2PartyId>
<PBEBTradeFCAClearingExemptIndicator2Value>
<xsl:value-of select="/SWDML/swLongFormTrade/swGiveUp/swInterDealerTransaction/swMandatoryClearing[swJurisdiction='FCA']/swPartyExemption[2]/swExemption"/>
</PBEBTradeFCAClearingExemptIndicator2Value>
<PBClientTradeFCAMandatoryClearingIndicator>
<xsl:value-of select="/SWDML/swLongFormTrade/swGiveUp/swCustomerTransaction/swMandatoryClearing[swJurisdiction='FCA']/swMandatoryClearingIndicator"/>
</PBClientTradeFCAMandatoryClearingIndicator>
<PBClientTradeFCAClearingExemptIndicator1PartyId>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/party[@id=substring-after(/SWDML/swLongFormTrade/swGiveUp/swCustomerTransaction/swMandatoryClearing[swJurisdiction='FCA']/swPartyExemption[1]/swPartyReference/@href,'#')]/partyId"/>
</PBClientTradeFCAClearingExemptIndicator1PartyId>
<PBClientTradeFCAClearingExemptIndicator1Value>
<xsl:value-of select="/SWDML/swLongFormTrade/swGiveUp/swCustomerTransaction/swMandatoryClearing[swJurisdiction='FCA']/swPartyExemption[1]/swExemption"/>
</PBClientTradeFCAClearingExemptIndicator1Value>
<PBClientTradeFCAClearingExemptIndicator2PartyId>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/party[@id=substring-after(/SWDML/swLongFormTrade/swGiveUp/swCustomerTransaction/swMandatoryClearing[swJurisdiction='FCA']/swPartyExemption[2]/swPartyReference/@href,'#')]/partyId"/>
</PBClientTradeFCAClearingExemptIndicator2PartyId>
<PBClientTradeFCAClearingExemptIndicator2Value>
<xsl:value-of select="/SWDML/swLongFormTrade/swGiveUp/swCustomerTransaction/swMandatoryClearing[swJurisdiction='FCA']/swPartyExemption[2]/swExemption"/>
</PBClientTradeFCAClearingExemptIndicator2Value>
<HKMAMandatoryClearingIndicator>
<xsl:value-of select="/SWDML/swLongFormTrade//swStructuredTradeDetails/swExtendedTradeDetails/swTradeHeader/swMandatoryClearing[swJurisdiction='HKMA']/swMandatoryClearingIndicator"/>
</HKMAMandatoryClearingIndicator>
<HKMAClearingExemptIndicator1PartyId>
<xsl:value-of select="/SWDML/swLongFormTrade//swStructuredTradeDetails/FpML/trade/party[@id=substring-after(/SWDML/swLongFormTrade//swStructuredTradeDetails/swExtendedTradeDetails/swTradeHeader/swMandatoryClearing[swJurisdiction='HKMA']/swPartyExemption[1]/swPartyReference/@href,'#')]/partyId"/>
</HKMAClearingExemptIndicator1PartyId>
<HKMAClearingExemptIndicator1Value>
<xsl:value-of select="/SWDML/swLongFormTrade//swStructuredTradeDetails/swExtendedTradeDetails/swTradeHeader/swMandatoryClearing[swJurisdiction='HKMA']/swPartyExemption[1]/swExemption"/>
</HKMAClearingExemptIndicator1Value>
<HKMAClearingExemptIndicator2PartyId>
<xsl:value-of select="/SWDML/swLongFormTrade//swStructuredTradeDetails/FpML/trade/party[@id=substring-after(/SWDML/swLongFormTrade//swStructuredTradeDetails/swExtendedTradeDetails/swTradeHeader/swMandatoryClearing[swJurisdiction='HKMA']/swPartyExemption[2]/swPartyReference/@href,'#')]/partyId"/>
</HKMAClearingExemptIndicator2PartyId>
<HKMAClearingExemptIndicator2Value>
<xsl:value-of select="/SWDML/swLongFormTrade//swStructuredTradeDetails/swExtendedTradeDetails/swTradeHeader/swMandatoryClearing[swJurisdiction='HKMA']/swPartyExemption[2]/swExemption"/>
</HKMAClearingExemptIndicator2Value>
<NewNovatedHKMAMandatoryClearingIndicator>
<xsl:value-of select="/SWDML/swLongFormTrade/novation/swMandatoryClearingNewNovatedTrade[swJurisdiction='HKMA']/swMandatoryClearingIndicator"/>
</NewNovatedHKMAMandatoryClearingIndicator>
<NewNovatedHKMAClearingExemptIndicator1PartyId>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/party[@id=substring-after(/SWDML/swLongFormTrade/novation/swMandatoryClearingNewNovatedTrade[swJurisdiction='HKMA']/swPartyExemption[1]/swPartyReference/@href,'#')]/partyId"/>
</NewNovatedHKMAClearingExemptIndicator1PartyId>
<NewNovatedHKMAClearingExemptIndicator1Value>
<xsl:value-of select="/SWDML/swLongFormTrade/novation/swMandatoryClearingNewNovatedTrade[swJurisdiction='HKMA']/swPartyExemption[1]/swExemption"/>
</NewNovatedHKMAClearingExemptIndicator1Value>
<NewNovatedHKMAClearingExemptIndicator2PartyId>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/party[@id=substring-after(/SWDML/swLongFormTrade/novation/swMandatoryClearingNewNovatedTrade[swJurisdiction='HKMA']/swPartyExemption[2]/swPartyReference/@href,'#')]/partyId"/>
</NewNovatedHKMAClearingExemptIndicator2PartyId>
<NewNovatedHKMAClearingExemptIndicator2Value>
<xsl:value-of select="/SWDML/swLongFormTrade/novation/swMandatoryClearingNewNovatedTrade[swJurisdiction='HKMA']/swPartyExemption[2]/swExemption"/>
</NewNovatedHKMAClearingExemptIndicator2Value>
<PBEBTradeHKMAMandatoryClearingIndicator>
<xsl:value-of select="/SWDML/swLongFormTrade/swGiveUp/swInterDealerTransaction/swMandatoryClearing[swJurisdiction='HKMA']/swMandatoryClearingIndicator"/>
</PBEBTradeHKMAMandatoryClearingIndicator>
<PBEBTradeHKMAClearingExemptIndicator1PartyId>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/party[@id=substring-after(/SWDML/swLongFormTrade/swGiveUp/swInterDealerTransaction/swMandatoryClearing[swJurisdiction='HKMA']/swPartyExemption[1]/swPartyReference/@href,'#')]/partyId"/>
</PBEBTradeHKMAClearingExemptIndicator1PartyId>
<PBEBTradeHKMAClearingExemptIndicator1Value>
<xsl:value-of select="/SWDML/swLongFormTrade/swGiveUp/swInterDealerTransaction/swMandatoryClearing[swJurisdiction='HKMA']/swPartyExemption[1]/swExemption"/>
</PBEBTradeHKMAClearingExemptIndicator1Value>
<PBEBTradeHKMAClearingExemptIndicator2PartyId>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/party[@id=substring-after(/SWDML/swLongFormTrade/swGiveUp/swInterDealerTransaction/swMandatoryClearing[swJurisdiction='HKMA']/swPartyExemption[2]/swPartyReference/@href,'#')]/partyId"/>
</PBEBTradeHKMAClearingExemptIndicator2PartyId>
<PBEBTradeHKMAClearingExemptIndicator2Value>
<xsl:value-of select="/SWDML/swLongFormTrade/swGiveUp/swInterDealerTransaction/swMandatoryClearing[swJurisdiction='HKMA']/swPartyExemption[2]/swExemption"/>
</PBEBTradeHKMAClearingExemptIndicator2Value>
<PBClientTradeHKMAMandatoryClearingIndicator>
<xsl:value-of select="/SWDML/swLongFormTrade/swGiveUp/swCustomerTransaction/swMandatoryClearing[swJurisdiction='HKMA']/swMandatoryClearingIndicator"/>
</PBClientTradeHKMAMandatoryClearingIndicator>
<PBClientTradeHKMAClearingExemptIndicator1PartyId>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/party[@id=substring-after(/SWDML/swLongFormTrade/swGiveUp/swCustomerTransaction/swMandatoryClearing[swJurisdiction='HKMA']/swPartyExemption[1]/swPartyReference/@href,'#')]/partyId"/>
</PBClientTradeHKMAClearingExemptIndicator1PartyId>
<PBClientTradeHKMAClearingExemptIndicator1Value>
<xsl:value-of select="/SWDML/swLongFormTrade/swGiveUp/swCustomerTransaction/swMandatoryClearing[swJurisdiction='HKMA']/swPartyExemption[1]/swExemption"/>
</PBClientTradeHKMAClearingExemptIndicator1Value>
<PBClientTradeHKMAClearingExemptIndicator2PartyId>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/party[@id=substring-after(/SWDML/swLongFormTrade/swGiveUp/swCustomerTransaction/swMandatoryClearing[swJurisdiction='HKMA']/swPartyExemption[2]/swPartyReference/@href,'#')]/partyId"/>
</PBClientTradeHKMAClearingExemptIndicator2PartyId>
<PBClientTradeHKMAClearingExemptIndicator2Value>
<xsl:value-of select="/SWDML/swLongFormTrade/swGiveUp/swCustomerTransaction/swMandatoryClearing[swJurisdiction='HKMA']/swPartyExemption[2]/swExemption"/>
</PBClientTradeHKMAClearingExemptIndicator2Value>
<JFSAMandatoryClearingIndicator>
<xsl:value-of select="/SWDML/swLongFormTrade//swStructuredTradeDetails/swExtendedTradeDetails/swTradeHeader/swMandatoryClearing[swJurisdiction='JFSA']/swMandatoryClearingIndicator"/>
</JFSAMandatoryClearingIndicator>
<CFTCMandatoryClearingIndicator>
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade//swStructuredTradeDetails/swExtendedTradeDetails/swTradeHeader/swMandatoryClearing[swJurisdiction='DoddFrank']/swMandatoryClearingIndicator">
<xsl:value-of select="/SWDML/swLongFormTrade//swStructuredTradeDetails/swExtendedTradeDetails/swTradeHeader/swMandatoryClearing[swJurisdiction='DoddFrank']/swMandatoryClearingIndicator"/>
</xsl:when>
<xsl:when test="/SWDML/swTradeEventReportingDetails/swReportingRegimeInformation[swJurisdiction/text()='DoddFrank']/swMandatoryClearingIndicator">
<xsl:value-of select="/SWDML/swTradeEventReportingDetails/swReportingRegimeInformation[swJurisdiction/text()='DoddFrank']/swMandatoryClearingIndicator"/>
</xsl:when>
</xsl:choose>
</CFTCMandatoryClearingIndicator>
<CFTCClearingExemptIndicator1PartyId>
<xsl:value-of select="/SWDML/swLongFormTrade//swStructuredTradeDetails/FpML/trade/party[@id=substring-after(/SWDML/swLongFormTrade//swStructuredTradeDetails/swExtendedTradeDetails/swTradeHeader/swMandatoryClearing[swJurisdiction='DoddFrank']/swPartyExemption[1]/swPartyReference/@href,'#')]/partyId"/>
</CFTCClearingExemptIndicator1PartyId>
<CFTCClearingExemptIndicator1Value>
<xsl:value-of select="/SWDML/swLongFormTrade//swStructuredTradeDetails/swExtendedTradeDetails/swTradeHeader/swMandatoryClearing[swJurisdiction='DoddFrank']/swPartyExemption[1]/swExemption"/>
</CFTCClearingExemptIndicator1Value>
<CFTCClearingExemptIndicator2PartyId>
<xsl:value-of select="/SWDML/swLongFormTrade//swStructuredTradeDetails/FpML/trade/party[@id=substring-after(/SWDML/swLongFormTrade//swStructuredTradeDetails/swExtendedTradeDetails/swTradeHeader/swMandatoryClearing[swJurisdiction='DoddFrank']/swPartyExemption[2]/swPartyReference/@href,'#')]/partyId"/>
</CFTCClearingExemptIndicator2PartyId>
<CFTCClearingExemptIndicator2Value>
<xsl:value-of select="/SWDML/swLongFormTrade//swStructuredTradeDetails/swExtendedTradeDetails/swTradeHeader/swMandatoryClearing[swJurisdiction='DoddFrank']/swPartyExemption[2]/swExemption"/>
</CFTCClearingExemptIndicator2Value>
<CFTCInterAffiliateExemption>
<xsl:value-of select="/SWDML/swLongFormTrade//swStructuredTradeDetails/swExtendedTradeDetails/swTradeHeader/swMandatoryClearing[swJurisdiction='DoddFrank']/swInterAffiliateExemption"/>
</CFTCInterAffiliateExemption>
<NewNovatedCFTCMandatoryClearingIndicator>
<xsl:value-of select="/SWDML/swLongFormTrade/novation/swMandatoryClearingNewNovatedTrade[swJurisdiction='DoddFrank']/swMandatoryClearingIndicator"/>
</NewNovatedCFTCMandatoryClearingIndicator>
<NewNovatedCFTCClearingExemptIndicator1PartyId>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/party[@id=substring-after(/SWDML/swLongFormTrade/novation/swMandatoryClearingNewNovatedTrade[swJurisdiction='DoddFrank']/swPartyExemption[1]/swPartyReference/@href,'#')]/partyId"/>
</NewNovatedCFTCClearingExemptIndicator1PartyId>
<NewNovatedCFTCClearingExemptIndicator1Value>
<xsl:value-of select="/SWDML/swLongFormTrade/novation/swMandatoryClearingNewNovatedTrade[swJurisdiction='DoddFrank']/swPartyExemption[1]/swExemption"/>
</NewNovatedCFTCClearingExemptIndicator1Value>
<NewNovatedCFTCClearingExemptIndicator2PartyId>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/party[@id=substring-after(/SWDML/swLongFormTrade/novation/swMandatoryClearingNewNovatedTrade[swJurisdiction='DoddFrank']/swPartyExemption[2]/swPartyReference/@href,'#')]/partyId"/>
</NewNovatedCFTCClearingExemptIndicator2PartyId>
<NewNovatedCFTCClearingExemptIndicator2Value>
<xsl:value-of select="/SWDML/swLongFormTrade/novation/swMandatoryClearingNewNovatedTrade[swJurisdiction='DoddFrank']/swPartyExemption[2]/swExemption"/>
</NewNovatedCFTCClearingExemptIndicator2Value>
<NewNovatedCFTCInterAffiliateExemption>
<xsl:value-of select="/SWDML/swLongFormTrade/novation/swMandatoryClearingNewNovatedTrade[swJurisdiction='DoddFrank']/swInterAffiliateExemption"/>
</NewNovatedCFTCInterAffiliateExemption>
<PBEBTradeCFTCMandatoryClearingIndicator>
<xsl:value-of select="/SWDML/swLongFormTrade/swGiveUp/swInterDealerTransaction/swMandatoryClearing[swJurisdiction='DoddFrank']/swMandatoryClearingIndicator"/>
</PBEBTradeCFTCMandatoryClearingIndicator>
<PBEBTradeJFSAMandatoryClearingIndicator>
<xsl:value-of select="/SWDML/swLongFormTrade/swGiveUp/swInterDealerTransaction/swMandatoryClearing[swJurisdiction='JFSA']/swMandatoryClearingIndicator"/>
</PBEBTradeJFSAMandatoryClearingIndicator>
<PBEBTradeCFTCClearingExemptIndicator1PartyId>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/party[@id=substring-after(/SWDML/swLongFormTrade/swGiveUp/swInterDealerTransaction/swMandatoryClearing[swJurisdiction='DoddFrank']/swPartyExemption[1]/swPartyReference/@href,'#')]/partyId"/>
</PBEBTradeCFTCClearingExemptIndicator1PartyId>
<PBEBTradeCFTCClearingExemptIndicator1Value>
<xsl:value-of select="/SWDML/swLongFormTrade/swGiveUp/swInterDealerTransaction/swMandatoryClearing[swJurisdiction='DoddFrank']/swPartyExemption[1]/swExemption"/>
</PBEBTradeCFTCClearingExemptIndicator1Value>
<PBEBTradeCFTCClearingExemptIndicator2PartyId>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/party[@id=substring-after(/SWDML/swLongFormTrade/swGiveUp/swInterDealerTransaction/swMandatoryClearing[swJurisdiction='DoddFrank']/swPartyExemption[2]/swPartyReference/@href,'#')]/partyId"/>
</PBEBTradeCFTCClearingExemptIndicator2PartyId>
<PBEBTradeCFTCClearingExemptIndicator2Value>
<xsl:value-of select="/SWDML/swLongFormTrade/swGiveUp/swInterDealerTransaction/swMandatoryClearing[swJurisdiction='DoddFrank']/swPartyExemption[2]/swExemption"/>
</PBEBTradeCFTCClearingExemptIndicator2Value>
<PBEBTradeCFTCInterAffiliateExemption>
<xsl:value-of select="/SWDML/swLongFormTrade/swGiveUp/swInterDealerTransaction/swMandatoryClearing[swJurisdiction='DoddFrank']/swInterAffiliateExemption"/>
</PBEBTradeCFTCInterAffiliateExemption>
<PBClientTradeCFTCMandatoryClearingIndicator>
<xsl:value-of select="/SWDML/swLongFormTrade/swGiveUp/swCustomerTransaction/swMandatoryClearing[swJurisdiction='DoddFrank']/swMandatoryClearingIndicator"/>
</PBClientTradeCFTCMandatoryClearingIndicator>
<PBClientTradeJFSAMandatoryClearingIndicator>
<xsl:value-of select="/SWDML/swLongFormTrade/swGiveUp/swCustomerTransaction/swMandatoryClearing[swJurisdiction='JFSA']/swMandatoryClearingIndicator"/>
</PBClientTradeJFSAMandatoryClearingIndicator>
<PBClientTradeCFTCClearingExemptIndicator1PartyId>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/party[@id=substring-after(/SWDML/swLongFormTrade/swGiveUp/swCustomerTransaction/swMandatoryClearing[swJurisdiction='DoddFrank']/swPartyExemption[1]/swPartyReference/@href,'#')]/partyId"/>
</PBClientTradeCFTCClearingExemptIndicator1PartyId>
<PBClientTradeCFTCClearingExemptIndicator1Value>
<xsl:value-of select="/SWDML/swLongFormTrade/swGiveUp/swCustomerTransaction/swMandatoryClearing[swJurisdiction='DoddFrank']/swPartyExemption[1]/swExemption"/>
</PBClientTradeCFTCClearingExemptIndicator1Value>
<PBClientTradeCFTCClearingExemptIndicator2PartyId>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/party[@id=substring-after(/SWDML/swLongFormTrade/swGiveUp/swCustomerTransaction/swMandatoryClearing[swJurisdiction='DoddFrank']/swPartyExemption[2]/swPartyReference/@href,'#')]/partyId"/>
</PBClientTradeCFTCClearingExemptIndicator2PartyId>
<PBClientTradeCFTCClearingExemptIndicator2Value>
<xsl:value-of select="/SWDML/swLongFormTrade/swGiveUp/swCustomerTransaction/swMandatoryClearing[swJurisdiction='DoddFrank']/swPartyExemption[2]/swExemption"/>
</PBClientTradeCFTCClearingExemptIndicator2Value>
<PBClientTradeCFTCInterAffiliateExemption>
<xsl:value-of select="/SWDML/swLongFormTrade/swGiveUp/swCustomerTransaction/swMandatoryClearing[swJurisdiction='DoddFrank']/swInterAffiliateExemption"/>
</PBClientTradeCFTCInterAffiliateExemption>
<MASMandatoryClearingIndicator>
<xsl:value-of select="/SWDML/swLongFormTrade//swStructuredTradeDetails/swExtendedTradeDetails/swTradeHeader/swMandatoryClearing[swJurisdiction='MAS']/swMandatoryClearingIndicator"/>
</MASMandatoryClearingIndicator>
<NewNovatedMASMandatoryClearingIndicator>
<xsl:value-of select="/SWDML/swLongFormTrade/novation/swMandatoryClearingNewNovatedTrade[swJurisdiction='MAS']/swMandatoryClearingIndicator"/>
</NewNovatedMASMandatoryClearingIndicator>
<PBEBTradeMASMandatoryClearingIndicator>
<xsl:value-of select="/SWDML/swLongFormTrade/swGiveUp/swInterDealerTransaction/swMandatoryClearing[swJurisdiction='MAS']/swMandatoryClearingIndicator"/>
</PBEBTradeMASMandatoryClearingIndicator>
<PBClientTradeMASMandatoryClearingIndicator>
<xsl:value-of select="/SWDML/swLongFormTrade/swGiveUp/swCustomerTransaction/swMandatoryClearing[swJurisdiction='MAS']/swMandatoryClearingIndicator"/>
</PBClientTradeMASMandatoryClearingIndicator>
<ClearingHouseId>
<xsl:value-of select="/SWDML/swShortFormTrade/swClearingHouse/partyId"/>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swTradeHeader/swClearingHouse/partyId"/>
</ClearingHouseId>
<ClearingBrokerId>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swTradeHeader/swClearingBroker/partyId"/>
</ClearingBrokerId>
<OriginatingEvent>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swTradeHeader/swOriginatingEvent"/>
</OriginatingEvent>
<ESMAFrontloading>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swTradeHeader/swESMAFrontloading"/>
</ESMAFrontloading>
<ESMAClearingExemption>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swTradeHeader/swESMAClearingExemption"/>
</ESMAClearingExemption>
<BackLoadingFlag>
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swTradeHeader/swBackLoadingFlag">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swTradeHeader/swBackLoadingFlag"/>
</xsl:when>
<xsl:when test="/SWDML/swShortFormTrade/swBackLoadingFlag">
<xsl:value-of select="/SWDML/swShortFormTrade/swBackLoadingFlag"/>
</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</BackLoadingFlag>
<xsl:if test="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swTradeHeader/swBulkAction">
<BulkAction>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swTradeHeader/swBulkAction"/>
</BulkAction>
</xsl:if>
<Novation>
<xsl:value-of select="string(boolean(/SWDML/swLongFormTrade/novation))"/>
</Novation>
<xsl:variable name="tradeNotional">
<xsl:choose>
<xsl:when test="$productType='IRS' or $productType='OIS' or $productType='Swaption'">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/calculationPeriodAmount/calculation/notionalSchedule/notionalStepSchedule/initialValue"/>
</xsl:when>
<xsl:when test="$productType='FRA'">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/fra/notional/amount"/>
</xsl:when>
<xsl:when test="$productType='CapFloor'">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/capFloorStream/calculationPeriodAmount/calculation/notionalSchedule/notionalStepSchedule/initialValue"/>
</xsl:when>
</xsl:choose>
</xsl:variable>
<xsl:variable name="novatedAmount">
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/novation/novatedAmount/amount">
<xsl:value-of select="/SWDML/swLongFormTrade/novation/novatedAmount/amount"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$tradeNotional"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<PartialNovation>
<xsl:if test="/SWDML/swLongFormTrade//novation/swPartialNovationIndicator">
<xsl:value-of select="string(boolean(/SWDML/swLongFormTrade/novation/swPartialNovationIndicator = 'true'))"/>
</xsl:if>
</PartialNovation>
<FourWayNovation>
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/novation">
<xsl:value-of select="string(boolean(/SWDML/swLongFormTrade/novation/otherRemainingParty))"/>
</xsl:when>
<xsl:otherwise/>
</xsl:choose>
</FourWayNovation>
<NovationTradeDate>
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/novation">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string(/SWDML/swLongFormTrade/novation/novationTradeDate)"/>
</xsl:call-template>
</xsl:when>
<xsl:otherwise/>
</xsl:choose>
</NovationTradeDate>
<NovationDate>
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/novation">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string(/SWDML/swLongFormTrade/novation/novationDate)"/>
</xsl:call-template>
</xsl:when>
<xsl:otherwise/>
</xsl:choose>
</NovationDate>
<NovatedAmount>
<xsl:value-of select="$novatedAmount"/>
</NovatedAmount>
<NovatedAmount_2>
<xsl:if test="($productType = 'IRS' or $productType = 'OIS') and /SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$fixedLeg]/calculationPeriodAmount/knownAmountSchedule">
<xsl:value-of select="/SWDML/swLongFormTrade/novation/swNovatedAmount/amount"/>
</xsl:if>
</NovatedAmount_2>
<NovatedCurrency/>
<NovatedCurrency_2/>
<NovatedFV>
<xsl:if test="/SWDML/swLongFormTrade/novation and $productType='IRS' and $currency='BRL'">
<xsl:value-of select="/SWDML/swLongFormTrade/novation/swNovatedFV/amount"/>
</xsl:if>
</NovatedFV>
<FullFirstCalculationPeriod>
<xsl:value-of select="/SWDML/swLongFormTrade/novation/fullFirstCalculationPeriod"/>
</FullFirstCalculationPeriod>
<NonReliance>
<xsl:if test="/SWDML/swLongFormTrade/novation">
<xsl:value-of select="string(boolean(/SWDML/swLongFormTrade/novation/nonReliance))"/>
</xsl:if>
</NonReliance>
<PreserveEarlyTerminationProvision>
<xsl:if test="/SWDML/swLongFormTrade/novation/swPreserveEarlyTerminationProvision">
<xsl:value-of select="string(boolean(/SWDML/swLongFormTrade/novation/swPreserveEarlyTerminationProvision = 'true'))"/>
</xsl:if>
</PreserveEarlyTerminationProvision>
<CopyPremiumToNewTrade>
<xsl:if test="/SWDML/swLongFormTrade/novation and $productType='Swaption'">
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/novation/swCopyPremiumToNewTrade = 'true'">true</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/novation/swCopyPremiumToNewTrade = 'false'">false</xsl:when>
<xsl:otherwise/>
</xsl:choose>
</xsl:if>
</CopyPremiumToNewTrade>
<CopyInitialRateToNewTradeIfRelevant>
<xsl:if test="/SWDML/swLongFormTrade/novation">
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/novation/swCopyInitialRateToNewTradeIfRelevant = 'true'">true</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/novation/swCopyInitialRateToNewTradeIfRelevant = 'false'">false</xsl:when>
<xsl:otherwise/>
</xsl:choose>
</xsl:if>
</CopyInitialRateToNewTradeIfRelevant>
<IntendedClearingHouse>
<xsl:if test="$productType='IRS' or
$productType='Single Currency Basis Swap' or
$productType='FRA' or
$productType='Swaption' or
$productType='ZCInflationSwap' or
$productType='OIS' or
$productType='CDS Index' or
$productType='CDS Matrix'">
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/novation">
<xsl:value-of select="/SWDML/swLongFormTrade/novation/swBilateralClearingHouse/partyId"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="/SWDML/swShortFormTrade/swClearingHouse/partyId"/>
<xsl:value-of select="/SWDML/swLongFormTrade//swStructuredTradeDetails/swExtendedTradeDetails/swTradeHeader/swClearingHouse/partyId"/>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</IntendedClearingHouse>
<xsl:if test="/SWDML/swLongFormTrade/novation/swBulkAction">
<NovationBulkAction>
<xsl:value-of select="/SWDML/swLongFormTrade/novation/swBulkAction"/>
</NovationBulkAction>
</xsl:if>
<NovationFallbacksSupplement>
<xsl:if test="$productType='IRS' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='Single Currency Basis Swap' or $productType='Swaption'">
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/novation/swFallbacksSupplement">
<xsl:value-of select="/SWDML/swLongFormTrade/novation/swFallbacksSupplement"/>
</xsl:when>
<xsl:otherwise>Incorporate</xsl:otherwise>
</xsl:choose>
</xsl:if>
</NovationFallbacksSupplement>
<ClientClearingFlag>
<xsl:if test="/SWDML/swLongFormTrade/novation/swNewTradeClearingDetails">
<xsl:value-of select="string(boolean(/SWDML/swLongFormTrade/novation/swNewTradeClearingDetails/swClientClearing))"/>
</xsl:if>
</ClientClearingFlag>
<ClearingBroker>
<xsl:if test="/SWDML/swLongFormTrade/novation/swNewTradeClearingDetails">
<xsl:value-of select="/SWDML/swLongFormTrade/novation/swNewTradeClearingDetails/swClearingBroker"/>
</xsl:if>
</ClearingBroker>
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade and $productType='FRA'">
<xsl:apply-templates select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/additionalPayment"/>
</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade and ($productType='IRS' or $productType='OIS' or $productType='Swaption'  or $productType='CapFloor' )">
<xsl:apply-templates select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swap/additionalPayment"/>
<xsl:apply-templates select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/additionalPayment"/>
<xsl:apply-templates select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/additionalPayment"/>
</xsl:when>
</xsl:choose>
<xsl:if test="/SWDML/swLongFormTrade/novation/payment">
<xsl:apply-templates select="/SWDML/swLongFormTrade/novation/payment"/>
</xsl:if>
<OptionStyle>
<xsl:if test="$productType='Swaption'">
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swaption/europeanExercise">European</xsl:when>
<xsl:when test="/SWDML/swShortFormTrade/swSwaptionParameters/swEuropeanExercise">European</xsl:when>
<xsl:otherwise>!!!</xsl:otherwise>
</xsl:choose>
</xsl:if>
</OptionStyle>
<OptionType>
<xsl:choose>
<xsl:when test="$productType='CapFloor'">
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/capFloorStream/calculationPeriodAmount/calculation/floatingRateCalculation/capRateSchedule  and /SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/capFloorStream/calculationPeriodAmount/calculation/floatingRateCalculation/floorRateSchedule">Cap Floor Straddle</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/capFloorStream/calculationPeriodAmount/calculation/floatingRateCalculation/capRateSchedule">Cap</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/capFloorStream/calculationPeriodAmount/calculation/floatingRateCalculation/floorRateSchedule">Floor</xsl:when>
</xsl:choose>
<xsl:value-of select="/SWDML/swShortFormTrade/swCapFloorParameters/swOptionType"/>
</xsl:when>
<xsl:when test="$productType='Swaption'">
<xsl:variable name="fixedPayer">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$fixedLeg]/payerPartyReference/@href"/>
<xsl:value-of select="/SWDML/swShortFormTrade/swSwaptionParameters/swFixedAmounts/payerPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="floatingPayer">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/payerPartyReference/@href"/>
<xsl:value-of select="/SWDML/swShortFormTrade/swSwaptionParameters/swFixedAmounts/receiverPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="swaptionBuyer">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swaption/buyerPartyReference/@href"/>
<xsl:value-of select="/SWDML/swShortFormTrade/swSwaptionParameters/buyerPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="straddle">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swaption/swaptionStraddle"/>
<xsl:value-of select="/SWDML/swShortFormTrade/swSwaptionParameters/swaptionStraddle"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$straddle='true'">Straddle</xsl:when>
<xsl:when test="$swaptionBuyer=$fixedPayer">Payers</xsl:when>
<xsl:when test="$swaptionBuyer=$floatingPayer">Receivers</xsl:when>
<xsl:otherwise>!!!</xsl:otherwise>
</xsl:choose>
</xsl:when>
</xsl:choose>
</OptionType>
<OptionExpirationDate>
<xsl:if test="$productType='Swaption'">
<xsl:call-template name="formatDate">
<xsl:with-param name="date">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swaption/europeanExercise/expirationDate/adjustableDate/unadjustedDate"/>
<xsl:value-of select="/SWDML/swShortFormTrade/swSwaptionParameters/swEuropeanExercise/swExpirationDate"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
</OptionExpirationDate>
<OptionExpirationDateConvention>
<xsl:if test="$productType='Swaption'">
<xsl:value-of select="substring(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swaption/europeanExercise/expirationDate/adjustableDate/dateAdjustments/businessDayConvention,1,4)"/>
</xsl:if>
</OptionExpirationDateConvention>
<OptionHolidayCenters>
<xsl:if test="$productType='Swaption'">
<xsl:if test="$productType='Swaption'">
<xsl:apply-templates select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swaption/europeanExercise/expirationDate/adjustableDate/dateAdjustments/businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:if>
</xsl:if>
</OptionHolidayCenters>
<OptionEarliestTime>
<xsl:if test="$productType='Swaption'">
<xsl:if test="/SWDML/swLongFormTrade">
<xsl:call-template name="formatTime">
<xsl:with-param name="time" select="string(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swaption/europeanExercise/earliestExerciseTime/hourMinuteTime)"/>
</xsl:call-template>
</xsl:if>
</xsl:if>
</OptionEarliestTime>
<OptionEarliestTimeHolidayCentre/>
<OptionExpiryTime>
<xsl:if test="$productType='Swaption'">
<xsl:if test="/SWDML/swLongFormTrade">
<xsl:call-template name="formatTime">
<xsl:with-param name="time" select="string(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swaption/europeanExercise/expirationTime/hourMinuteTime)"/>
</xsl:call-template>
</xsl:if>
</xsl:if>
</OptionExpiryTime>
<OptionExpiryTimeHolidayCentre/>
<OptionSpecificExpiryTime/>
<OptionLocation>
<xsl:if test="$productType='Swaption'">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swaption/europeanExercise/expirationTime/businessCenter"/>
</xsl:if>
</OptionLocation>
<OptionCalcAgent>
<xsl:if test="$productType='Swaption'">
<xsl:if test="/SWDML/swLongFormTrade">
<xsl:choose>
<xsl:when test="count(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swaption/calculationAgentPartyReference) = 2">Joint</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swaption/calculationAgentPartyReference/@href = /SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swaption/buyerPartyReference/@href">Buyer</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swaption/calculationAgentPartyReference/@href = /SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swaption/sellerPartyReference/@href">Seller</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swaption/calculationAgent/calculationAgentParty[.='AsSpecifiedInMasterAgreement']">As Specified in Master Agreement</xsl:when>
<xsl:otherwise>???</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:if>
</OptionCalcAgent>
<OptionAutomaticExercise>
<xsl:if test="$productType='Swaption'">
<xsl:value-of select="string(boolean(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swaption/exerciseProcedure/automaticExercise))"/>
</xsl:if>
</OptionAutomaticExercise>
<OptionThreshold>
<xsl:if test="$productType='Swaption'">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swaption/exerciseProcedure/automaticExercise/thresholdRate"/>
</xsl:if>
</OptionThreshold>
<ManualExercise>
<xsl:if test="$productType='Swaption'">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swaption/exerciseProcedure/manualExercise/fallbackExercise"/>
</xsl:if>
</ManualExercise>
<OptionWrittenExerciseConf>
<xsl:if test="$productType='Swaption'">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swaption/exerciseProcedure/followUpConfirmation"/>
</xsl:if>
</OptionWrittenExerciseConf>
<PremiumAmount>
<xsl:choose>
<xsl:when test="$productType='CapFloor'">
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/additionalPayment[paymentType = 'Premium']">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/additionalPayment[paymentType = 'Premium']/paymentAmount/amount"/>
</xsl:when>
<xsl:when test="/SWDML/swShortFormTrade/swCapFloorParameters/swPremium">
<xsl:value-of select="/SWDML/swShortFormTrade/swCapFloorParameters/swPremium/paymentAmount/amount"/>
</xsl:when>
<xsl:otherwise>0</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType='Swaption'">
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swaption/premium">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swaption/premium/paymentAmount/amount"/>
</xsl:when>
<xsl:when test="/SWDML/swShortFormTrade/swSwaptionParameters/swPremium">
<xsl:value-of select="/SWDML/swShortFormTrade/swSwaptionParameters/swPremium/paymentAmount/amount"/>
</xsl:when>
<xsl:otherwise>0</xsl:otherwise>
</xsl:choose>
</xsl:when>
</xsl:choose>
</PremiumAmount>
<PremiumCurrency>
<xsl:if test="$productType='Swaption'">
<xsl:choose>
<xsl:when test="/SWDML/swShortFormTrade/swSwaptionParameters/swPremium">
<xsl:value-of select="/SWDML/swShortFormTrade/swSwaptionParameters/swPremium/paymentAmount/currency"/>
</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swaption/premium">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swaption/premium/paymentAmount/currency"/>
</xsl:when>
</xsl:choose>
</xsl:if>
</PremiumCurrency>
<PremiumPaymentDate>
<xsl:choose>
<xsl:when test="$productType='Swaption'">
<xsl:if test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swaption/premium/paymentDate/unadjustedDate">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swaption/premium/paymentDate/unadjustedDate)"/>
</xsl:call-template>
</xsl:if>
<xsl:if test="/SWDML/swShortFormTrade//swPremium/swPaymentDate">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string(/SWDML/swShortFormTrade//swPremium/swPaymentDate)"/>
</xsl:call-template>
</xsl:if>
</xsl:when>
<xsl:when test="$productType='CapFloor'">
<xsl:if test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/additionalPayment[paymentType='Premium']">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/additionalPayment[paymentType='Premium']/paymentDate/unadjustedDate)"/>
</xsl:call-template>
</xsl:if>
<xsl:if test="/SWDML/swShortFormTrade//swPremium/swPaymentDate">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string(/SWDML/swShortFormTrade//swPremium/swPaymentDate)"/>
</xsl:call-template>
</xsl:if>
</xsl:when>
</xsl:choose>
</PremiumPaymentDate>
<PremiumHolidayCentres>
<xsl:if test="$productType='Swaption'">
<xsl:apply-templates select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swaption/premium/paymentDate/dateAdjustments/businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:if>
</PremiumHolidayCentres>
<Strike>
<xsl:choose>
<xsl:when test="$productType='Swaption'">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$fixedLeg]/calculationPeriodAmount/calculation/fixedRateSchedule/initialValue"/>
<xsl:value-of select="/SWDML/swShortFormTrade/swSwaptionParameters/fixedRate"/>
</xsl:when>
<xsl:when test="$productType='CapFloor'">
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/capFloorStream/calculationPeriodAmount/calculation/floatingRateCalculation/capRateSchedule">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/capFloorStream/calculationPeriodAmount/calculation/floatingRateCalculation/capRateSchedule/initialValue"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor/capFloorStream/calculationPeriodAmount/calculation/floatingRateCalculation/floorRateSchedule/initialValue"/>
</xsl:otherwise>
</xsl:choose>
<xsl:value-of select="/SWDML/swShortFormTrade/swCapFloorParameters/swStrikeRate"/>
</xsl:when>
</xsl:choose>
</Strike>
<StrikeCurrency/>
<StrikePercentage/>
<StrikeDate/>
<OptionSettlement>
<xsl:if test="$productType='Swaption'">
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swaption/cashSettlement">Cash</xsl:when>
<xsl:when test="/SWDML/swShortFormTrade/swSwaptionParameters/swCashSettlement[.='true']">Cash</xsl:when>
<xsl:otherwise>Physical</xsl:otherwise>
</xsl:choose>
</xsl:if>
</OptionSettlement>
<OptionCashSettlementValuationTime>
<xsl:if test="$productType='Swaption'">
<xsl:if test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swaption/cashSettlement/cashSettlementValuationTime/hourMinuteTime">
<xsl:call-template name="formatTime">
<xsl:with-param name="time" select="string(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swaption/cashSettlement/cashSettlementValuationTime/hourMinuteTime)"/>
</xsl:call-template>
</xsl:if>
</xsl:if>
</OptionCashSettlementValuationTime>
<OptionSpecificValuationTime/>
<OptionCashSettlementValuationDate>
<xsl:if test="$productType='Swaption'">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swaption/cashSettlement/cashSettlementValuationDate/periodMultiplier"/>
</xsl:if>
</OptionCashSettlementValuationDate>
<OptionCashSettlementPaymentDate>
<xsl:if test="$productType='Swaption'">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swaption/cashSettlement/cashSettlementPaymentDate/relativeDate/periodMultiplier"/>
</xsl:if>
</OptionCashSettlementPaymentDate>
<OptionCashSettlementMethod>
<xsl:if test="$productType='Swaption'">
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swaption/cashSettlement/cashPriceMethod">Cash Price</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swaption/cashSettlement/cashPriceAlternateMethod">Cash Price - Alternate Method</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swaption/cashSettlement/parYieldCurveAdjustedMethod ">Par Yield Curve - Adjusted</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swaption/cashSettlement/zeroCouponYieldAdjustedMethod ">Zero Coupon Yield - Adjusted</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swaption/cashSettlement/parYieldCurveUnadjustedMethod ">Par Yield Curve - Unadjusted</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swCollateralizedCashPrice">Collateralized Cash Price</xsl:when>
</xsl:choose>
</xsl:if>
</OptionCashSettlementMethod>
<OptionCashSettlementQuotationRate>
<xsl:choose>
<xsl:when test="$productType='Swaption' and /SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swCollateralizedCashPrice">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swCollateralizedCashPrice/quotationRateType"/>
</xsl:when>
<xsl:when test="$productType='Swaption'">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swaption/cashSettlement//quotationRateType"/>
</xsl:when>
</xsl:choose>
</OptionCashSettlementQuotationRate>
<OptionCashSettlementRateSource>
<xsl:if test="$productType='Swaption'">
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade//swStructuredTradeDetails/swExtendedTradeDetails/swCollateralizedCashPrice/settlementRateSource/informationSource/rateSourcePage">
<xsl:variable name="pageString" select="' Page '"/>
<xsl:value-of select="/SWDML/swLongFormTrade//swStructuredTradeDetails/swExtendedTradeDetails/swCollateralizedCashPrice/settlementRateSource/informationSource/rateSource"/>
<xsl:value-of select="$pageString"/>
<xsl:value-of select="/SWDML/swLongFormTrade//swStructuredTradeDetails/swExtendedTradeDetails/swCollateralizedCashPrice/settlementRateSource/informationSource/rateSourcePage"/>
</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade//swStructuredTradeDetails/swExtendedTradeDetails/swCollateralizedCashPrice/settlementRateSource/informationSource/rateSource[.='ISDA']">ISDA Source</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade//swStructuredTradeDetails/swExtendedTradeDetails/swCollateralizedCashPrice/settlementRateSource/informationSource/rateSource[.='ICESWAP']">ICESWAP Rate</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade//swStructuredTradeDetails/swExtendedTradeDetails/swCollateralizedCashPrice/settlementRateSource/informationSource/rateSource[.='TOKYOSWAP']">Tokyo Swap Rate</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade//swStructuredTradeDetails/swExtendedTradeDetails/swCollateralizedCashPrice/settlementRateSource/informationSource/rateSource[.='Reference Banks']">Reference Banks</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swaption/cashSettlement//settlementRateSource/informationSource/rateSourcePage">
<xsl:variable name="pageString" select="' Page '"/>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swaption/cashSettlement//settlementRateSource/informationSource/rateSource"/>
<xsl:value-of select="$pageString"/>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swaption/cashSettlement//settlementRateSource/informationSource/rateSourcePage"/>
</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swaption/cashSettlement//settlementRateSource/informationSource/rateSource[.='ISDA']">ISDA Source</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swaption/cashSettlement//settlementRateSource/informationSource/rateSource[.='ICESWAP']">ICESWAP Rate</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swaption/cashSettlement//settlementRateSource/informationSource/rateSource[.='TOKYOSWAP']">Tokyo Swap Rate</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swaption/cashSettlement//settlementRateSource/informationSource/rateSource[.='Reference Banks']">Reference Banks</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swaption/cashSettlement/cashPriceMethod or /SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swaption/cashSettlement/cashPriceAlternateMethod or /SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swaption/cashSettlement//cashSettlementReferenceBanks or /SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swCollateralizedCashPrice/settlementRateSource/cashSettlementReferenceBanks">Reference Banks</xsl:when>
</xsl:choose>
</xsl:if>
</OptionCashSettlementRateSource>
<OptionCashSettlementReferenceBanks>
<xsl:if test="$productType='Swaption'">
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swCollateralizedCashPrice/settlementRateSource/cashSettlementReferenceBanks">
<xsl:apply-templates select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swCollateralizedCashPrice/settlementRateSource/cashSettlementReferenceBanks"/>
</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swaption/cashSettlement//cashSettlementReferenceBanks">
<xsl:apply-templates select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swaption/cashSettlement//cashSettlementReferenceBanks"/>
</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swaption/cashSettlement">Agreed on exercise</xsl:when>
<xsl:otherwise/>
</xsl:choose>
</xsl:if>
</OptionCashSettlementReferenceBanks>
<ClearedPhysicalSettlement>
<xsl:choose>
<xsl:when test="$productType='Swaption'">
<xsl:value-of select="string(boolean(/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swTradeHeader/swClearedPhysicalSettlement = 'true'))"/>
</xsl:when>
<xsl:otherwise/>
</xsl:choose>
</ClearedPhysicalSettlement>
<UnderlyingSwapClearingHouse>
<xsl:if test="$productType='Swaption'">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swTradeHeader/swPredeterminedClearerForUnderlyingSwap"/>
</xsl:if>
</UnderlyingSwapClearingHouse>
<PricedToClearCCP>
<xsl:if test="$productType='Swaption' or $productType='OIS' or $productType='FRA' or $productType='ZCInflationSwap' or $productType='Fixed Fixed Swap' or $productType='IRS' or $productType='Single Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='Cross Currency Basis Swap'">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swTradeHeader/swPricedToClearCCP/partyId"/>
</xsl:if>
</PricedToClearCCP>
<AgreedDiscountRate>
<xsl:if test="$productType='Swaption'">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swAgreedDiscountRate"/>
</xsl:if>
</AgreedDiscountRate>
<EconomicAmendmentType>
<xsl:if test="$productType='OIS' or $productType='IRS' or $productType='Single Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='Cross Currency Basis Swap'">
<xsl:if test="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swEconomicAmendmentType">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swEconomicAmendmentType"/>
</xsl:if>
</xsl:if>
</EconomicAmendmentType>
<EconomicAmendmentReason>
<xsl:if test="$productType='OIS' or $productType='IRS' or $productType='Single Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='Cross Currency Basis Swap'">
<xsl:if test="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swEconomicAmendmentReason">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swEconomicAmendmentReason"/>
</xsl:if>
</xsl:if>
</EconomicAmendmentReason>
<xsl:variable name="swClearingTakeup"
select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swTradeHeader/swClearingTakeup"/>
<ClearingTakeupClientId>
<xsl:value-of select="$swClearingTakeup/swClient/partyId"/>
</ClearingTakeupClientId>
<ClearingTakeupClientName>
<xsl:value-of select="$swClearingTakeup/swClient/partyName"/>
</ClearingTakeupClientName>
<ClearingTakeupClientTradeId>
<xsl:value-of select="$swClearingTakeup/swClient/tradeId"/>
</ClearingTakeupClientTradeId>
<ClearingTakeupExecSrcId>
<xsl:value-of select="$swClearingTakeup/swExecutionSource/partyId"/>
</ClearingTakeupExecSrcId>
<ClearingTakeupExecSrcName>
<xsl:value-of select="$swClearingTakeup/swExecutionSource/partyName"/>
</ClearingTakeupExecSrcName>
<ClearingTakeupExecSrcTradeId>
<xsl:value-of select="$swClearingTakeup/swExecutionSource/tradeId"/>
</ClearingTakeupExecSrcTradeId>
<ClearingTakeupCorrelationId>
<xsl:value-of select="$swClearingTakeup/swCorrelationId"/>
</ClearingTakeupCorrelationId>
<ClearingTakeupClearingHouseTradeId>
<xsl:value-of select="$swClearingTakeup/swClearingHouseTradeId"/>
</ClearingTakeupClearingHouseTradeId>
<ClearingTakeupOriginatingEvent>
<xsl:value-of select="$swClearingTakeup/swOriginatingEvent"/>
</ClearingTakeupOriginatingEvent>
<ClearingTakeupBlockTradeId>
<xsl:value-of select="$swClearingTakeup/swBlockTradeId"/>
</ClearingTakeupBlockTradeId>
<ClearingTakeupSentBy>
<xsl:value-of select="$swClearingTakeup/swSentBy"/>
</ClearingTakeupSentBy>
<ClearingTakeupCreditTokenIssuer>
<xsl:value-of select="$swClearingTakeup/swCreditAcceptanceToken/swCreditIssuer"/>
</ClearingTakeupCreditTokenIssuer>
<ClearingTakeupCreditToken>
<xsl:value-of select="$swClearingTakeup/swCreditAcceptanceToken/swToken"/>
</ClearingTakeupCreditToken>
<ClearingTakeupClearingStatus>
<xsl:value-of select="$swClearingTakeup/swClearingStatus"/>
</ClearingTakeupClearingStatus>
<ClearingTakeupVenueLEI>
<xsl:value-of select="$swClearingTakeup/swVenueId"/>
</ClearingTakeupVenueLEI>
<ClearingTakeupVenueLEIScheme>
<xsl:value-of select="$swClearingTakeup/swVenueId/@swVenueIdScheme"/>
</ClearingTakeupVenueLEIScheme>
<DocsType>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/documentation/masterConfirmation/masterConfirmationType"/>
</DocsType>
<DocsSubType/>
<ContractualDefinitions>
<xsl:if test="$productType='IRS' or $productType='OIS' or $productType='CapFloor' or $productType='Swaption' or $productType='FRA'">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swTradeHeader/swContractualDefinitions"/>
</xsl:if>
</ContractualDefinitions>
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
<IndexName>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/creditDefaultSwap/generalTerms/indexReferenceInformation/indexName"/>
</IndexName>
<IndexId>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/creditDefaultSwap/generalTerms/indexReferenceInformation/indexId"/>
</IndexId>
<IndexAnnexDate>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/creditDefaultSwap/generalTerms/indexReferenceInformation/indexAnnexDate"/>
</IndexAnnexDate>
<IndexTradedRate/>
<UpfrontFee>
<xsl:value-of select="string(boolean(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/creditDefaultSwap/feeLeg/initialPayment))"/>
</UpfrontFee>
<UpfrontFeeAmount>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/creditDefaultSwap/feeLeg/initialPayment/paymentAmount/amount"/>
</UpfrontFeeAmount>
<UpfrontFeeDate/>
<UpfrontFeePayer>
<xsl:value-of select="substring-after(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/creditDefaultSwap/feeLeg/initialPayment/payerPartyReference/@href,'party')"/>
</UpfrontFeePayer>
<AttachmentPoint/>
<ExhaustionPoint/>
<PublicationDate/>
<MasterAgreementDate/>
<MasterAgreementVersion/>
<AmendmentTradeDate/>
<xsl:apply-templates select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/otherPartyPayment"/>
<SettlementCurrency>
<xsl:if test="$productType='IRS' or $productType='OIS' or $productType='Swaption'">
<xsl:choose>
<xsl:when test="/SWDML/swShortFormTrade//swSettlementProvision/swSettlementCurrency">
<xsl:value-of select="/SWDML/swShortFormTrade//swSettlementProvision/swSettlementCurrency"/>
</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swSettlementProvision/swSettlementCurrency">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swSettlementProvision/swSettlementCurrency"/>
</xsl:when>
</xsl:choose>
</xsl:if>
</SettlementCurrency>
<ReferenceCurrency>
<xsl:value-of select="$referenceCurrency"/>
</ReferenceCurrency>
<SettlementRateOption>
<xsl:if test="$productType='IRS' or $productType='OIS' or $productType='Swaption'">
<xsl:choose>
<xsl:when test="/SWDML/swShortFormTrade//swSettlementProvision/swNonDeliverableSettlement/swSettlementRateOption">
<xsl:value-of select="/SWDML/swShortFormTrade//swSettlementProvision/swNonDeliverableSettlement/swSettlementRateOption"/>
</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swSettlementProvision/swNonDeliverableSettlement/swSettlementRateOption">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swSettlementProvision/swNonDeliverableSettlement/swSettlementRateOption"/>
</xsl:when>
</xsl:choose>
</xsl:if>
</SettlementRateOption>
<NonDeliverable>
<xsl:if test="$productType='IRS' or $productType='OIS'">
<xsl:value-of select="/SWDML/swShortFormTrade//nonDeliverable"/>
</xsl:if>
</NonDeliverable>
<FxFixingDate>
<FxFixingAdjustableDate>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swSettlementProvision/swNonDeliverableSettlement/swFxFixingSchedule/unadjustedDate"/>
</FxFixingAdjustableDate>
<FxFixingPeriod>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swSettlementProvision/swNonDeliverableSettlement/swFxFixingDate/periodMultiplier"/>
</FxFixingPeriod>
<FxFixingDayConvention>
<xsl:if test="$productType='IRS' or $productType='OIS'">
<xsl:value-of select="substring(/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swSettlementProvision/swNonDeliverableSettlement//businessDayConvention,1,4)"/>
</xsl:if>
</FxFixingDayConvention>
<FxFixingCentres>
<xsl:if test="$productType='IRS' or $productType='OIS'">
<xsl:apply-templates select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swSettlementProvision/swNonDeliverableSettlement//businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:if>
</FxFixingCentres>
</FxFixingDate>
<SettlementCurrency_2/>
<ReferenceCurrency_2/>
<SettlementRateOption_2/>
<FxFixingDate_2>
<FxFixingPeriod_2/>
<FxFixingDayConvention_2/>
<FxFixingCentres_2/>
</FxFixingDate_2>
<OutsideNovationTradeDate>
<xsl:if test="$productType='IRS' or $productType='OIS'">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swOutsideNovation/novationTradeDate"/>
</xsl:if>
</OutsideNovationTradeDate>
<OutsideNovationNovationDate>
<xsl:if test="$productType='IRS' or $productType='OIS'">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swOutsideNovation/novationDate"/>
</xsl:if>
</OutsideNovationNovationDate>
<OutsideNovationOutgoingParty>
<xsl:if test="$productType='IRS' or $productType='OIS'">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swOutsideNovation/swTransferor/partyId"/>
</xsl:if>
</OutsideNovationOutgoingParty>
<OutsideNovationIncomingParty>
<xsl:if test="$productType='IRS' or $productType='OIS'">
<xsl:variable name="incomingParty" select="string(substring-after(/SWDML/swLongFormTrade//swStructuredTradeDetails/swExtendedTradeDetails/swOutsideNovation/transferee/@href,'#'))"/>
<xsl:value-of select="/SWDML/swLongFormTrade//party[@id=$incomingParty]/partyId"/>
</xsl:if>
</OutsideNovationIncomingParty>
<OutsideNovationRemainingParty>
<xsl:if test="$productType='IRS' or $productType='OIS'">
<xsl:variable name="remainingParty" select="string(substring-after(/SWDML/swLongFormTrade//swStructuredTradeDetails/swExtendedTradeDetails/swOutsideNovation/remainingParty/@href,'#'))"/>
<xsl:value-of select="/SWDML/swLongFormTrade//party[@id=$remainingParty]/partyId"/>
</xsl:if>
</OutsideNovationRemainingParty>
<OutsideNovationFullFirstCalculationPeriod>
<xsl:if test="$productType='IRS' or $productType='OIS'">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swOutsideNovation/fullFirstCalculationPeriod"/>
</xsl:if>
</OutsideNovationFullFirstCalculationPeriod>
<CalcAgentA>
<xsl:if test="$referenceCurrency='BRL'">
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/calculationAgent/calculationAgentParty[.='AsSpecifiedInMasterAgreement']">As Specified in Master Agreement</xsl:when>
<xsl:when test="count(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/calculationAgent/calculationAgentPartyReference)=2">Joint</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/calculationAgent/calculationAgentPartyReference[@href=concat('#',$partyA)]">My Entity</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/calculationAgent/calculationAgentPartyReference[@href=concat('#',$partyB)]">Other Entity</xsl:when>
</xsl:choose>
</xsl:if>
</CalcAgentA>
<AmendmentType>
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swAmendmentType='PartialTermination'">Partial Termination</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swAmendmentType='ErrorCorrection'">Error Correction</xsl:when>
<xsl:otherwise>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swAmendmentType"/>
</xsl:otherwise>
</xsl:choose>
</AmendmentType>
<CancellationType>
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swCancellationType='BookedInError'">Booked in Error</xsl:when>
<xsl:otherwise>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swCancellationType"/>
</xsl:otherwise>
</xsl:choose>
</CancellationType>
<Cancelable>
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swap/cancelableProvision">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</Cancelable>
<CancelableDirectionA>
<xsl:variable name="cancelableBuyer">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swap/cancelableProvision/buyerPartyReference/@href"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="string(substring-after($cancelableBuyer,'#'))=string($partyA)">Buy</xsl:when>
<xsl:otherwise>Sell</xsl:otherwise>
</xsl:choose>
</CancelableDirectionA>
<CancelableOptionStyle>
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swap/cancelableProvision/bermudaExercise">Bermudan</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swap/cancelableProvision/americanExercise">American</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swap/cancelableProvision/europeanExercise">European</xsl:when>
<xsl:otherwise>>???</xsl:otherwise>
</xsl:choose>
</CancelableOptionStyle>
<CancelableFirstExerciseDate>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swap/cancelableProvision//relevantUnderlyingDate//scheduleBounds/unadjustedFirstDate"/>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swap/cancelableProvision//relevantUnderlyingDate/adjustableDates/unadjustedDate"/>
</CancelableFirstExerciseDate>
<CancelableExerciseFrequency>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swap/cancelableProvision//relevantUnderlyingDate/relativeDates/periodMultiplier"/>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swap/cancelableProvision//relevantUnderlyingDate/relativeDates/period"/>
</CancelableExerciseFrequency>
<CancelableEarliestTime>
<xsl:call-template name="formatTime">
<xsl:with-param name="time" select="string(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swap/cancelableProvision//earliestExerciseTime/hourMinuteTime)"/>
</xsl:call-template>
</CancelableEarliestTime>
<CancelableExpiryTime>
<xsl:call-template name="formatTime">
<xsl:with-param name="time" select="string(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swap/cancelableProvision//expirationTime/hourMinuteTime)"/>
</xsl:call-template>
</CancelableExpiryTime>
<CancelableExerciseLag>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swap/cancelableProvision//bermudaExerciseDates/relativeDates/periodMultiplier"/>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swap/cancelableProvision//americanExercise/commencementDate/relativeDate/periodMultiplier"/>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swap/cancelableProvision//europeanExercise/expirationDate/relativeDate/periodMultiplier"/>
</CancelableExerciseLag>
<CancelableHolidayCentre>
<xsl:apply-templates select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swap/cancelableProvision//bermudaExerciseDates/relativeDates/businessCenters"/>
<xsl:apply-templates select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swap/cancelableProvision//americanExercise/commencementDate/relativeDate/businessCenters"/>
<xsl:apply-templates select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swap/cancelableProvision//europeanExercise/expirationDate/relativeDate/businessCenters"/>
</CancelableHolidayCentre>
<CancelableLocation>
<xsl:apply-templates select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swap/cancelableProvision//expirationTime/businessCenter"/>
</CancelableLocation>
<CancelableConvention>
<xsl:variable name="cancelableConvention" select="substring(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swap/cancelableProvision//relevantUnderlyingDate//businessDayConvention,1,4)"/>
<xsl:choose>
<xsl:when test="$cancelableConvention='NotA'">NA</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$cancelableConvention"/>
</xsl:otherwise>
</xsl:choose>
</CancelableConvention>
<CancelableFUC>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swap/cancelableProvision/followUpConfirmation"/>
</CancelableFUC>
<CancelableDayType>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swap/cancelableProvision//bermudaExerciseDates/relativeDates/dayType"/>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swap/cancelableProvision//americanExercise/commencementDate/relativeDate/dayType"/>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swap/cancelableProvision//europeanExercise/expirationDate/relativeDate/dayType"/>
</CancelableDayType>
<CancelableLagConvention>
<xsl:value-of select="substring(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swap/cancelableProvision//bermudaExerciseDates/relativeDates/businessDayConvention,1,4)"/>
<xsl:value-of select="substring(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swap/cancelableProvision//americanExercise/commencementDate/relativeDate/businessDayConvention,1,4)"/>
<xsl:value-of select="substring(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swap/cancelableProvision//europeanExercise/expirationDate/relativeDate/businessDayConvention,1,4)"/>
</CancelableLagConvention>
<CancelableRollCentres>
<xsl:if test="$productType='IRS' or $productType='OIS'">
<xsl:apply-templates select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swap/cancelableProvision//bermudaExercise/relevantUnderlyingDate/relativeDates/businessCenters"/>
<xsl:apply-templates select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swap/cancelableProvision//americanExercise/relevantUnderlyingDate/relativeDates/businessCenters"/>
<xsl:apply-templates select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swap/cancelableProvision//europeanExercise/relevantUnderlyingDate/adjustableDates/dateAdjustments/businessCenters"/>
</xsl:if>
</CancelableRollCentres>
<xsl:if test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swap/additionalPayment[paymentType='CancellablePremium']">
<CancelablePremium>
<PaymentDirectionA>
<xsl:variable name="payer" select="string(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swap/additionalPayment[paymentType='CancellablePremium']/payerPartyReference/@href)"/>
<xsl:choose>
<xsl:when test="string(substring-after($payer,'#'))=string($partyA)">Pay</xsl:when>
<xsl:otherwise>Rec</xsl:otherwise>
</xsl:choose>
</PaymentDirectionA>
<Currency>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swap/additionalPayment[paymentType='CancellablePremium']/paymentAmount/currency"/>
</Currency>
<Amount>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swap/additionalPayment[paymentType='CancellablePremium']/paymentAmount/amount"/>
</Amount>
<Date>
<xsl:if test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swap/additionalPayment[paymentType='CancellablePremium']/paymentDate">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swap/additionalPayment[paymentType='CancellablePremium']/paymentDate/unadjustedDate)"/>
</xsl:call-template>
</xsl:if>
</Date>
<Convention>
<xsl:value-of select="substring(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swap/additionalPayment[paymentType='CancellablePremium']/paymentDate/dateAdjustments/businessDayConvention,1,4)"/>
</Convention>
<Holidays>
<xsl:apply-templates select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swap/additionalPayment[paymentType='CancellablePremium']/paymentDate/dateAdjustments/businessCenters"/>
</Holidays>
</CancelablePremium>
</xsl:if>
<CancellationForwardPremium>
<xsl:choose>
<xsl:when test="$productType='Swaption'">
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swForwardPremium = 'true'">true</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swForwardPremium = 'false'">false</xsl:when>
<xsl:otherwise/>
</xsl:choose>
</xsl:when>
<xsl:otherwise/>
</xsl:choose>
</CancellationForwardPremium>
<xsl:if test="not(/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swTradeHeader/swClearingHouse/partyId)">
<SettlementAgency>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swSettlementAgent/swSettlementAgency/partyId"/>
</SettlementAgency>
<SettlementAgencyModel>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swSettlementAgent/swSettlementAgencyModel"/>
</SettlementAgencyModel>
</xsl:if>
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
<ExitReason>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swExitReason"/>
</ExitReason>
<TransactionDate>
<xsl:if test="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swModificationTradeDate">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string(/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swModificationTradeDate)"/>
</xsl:call-template>
</xsl:if>
</TransactionDate>
<EffectiveDate>
<xsl:if test="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swModificationEffectiveDate">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string(/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swModificationEffectiveDate)"/>
</xsl:call-template>
</xsl:if>
</EffectiveDate>
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
<EswInterestSpreadOverIndexStep>
<EswInterestSpreadOverIndexStepValue/>
<EswInterestSpreadOverIndexStepDate/>
</EswInterestSpreadOverIndexStep>
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
<NCAdditionalMatrixProvision/>
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
<NotionalFutureValue>
<xsl:if test="$referenceCurrency='BRL'">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swFutureValue/swNotionalFutureValue/amount"/>
</xsl:if>
</NotionalFutureValue>
<NotionalSchedule>
<xsl:if test="$productType='IRS' or $productType='OIS'">
<xsl:for-each select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$fixedLeg]/calculationPeriodAmount/calculation/notionalSchedule/notionalStepSchedule/step">
<xsl:call-template name="formatNotionalSchedule">
<xsl:with-param name="position" select="string(position())"/>
<xsl:with-param name="leg" select="string($fixedLeg)"/>
</xsl:call-template>
</xsl:for-each>
<xsl:if test="not(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$fixedLeg]/calculationPeriodAmount/calculation/notionalSchedule/notionalStepSchedule/step)">
<xsl:for-each select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$fixedLeg]/calculationPeriodAmount/calculation/fixedRateSchedule/step">
<xsl:call-template name="formatNotionalSchedule">
<xsl:with-param name="position" select="string(position())"/>
<xsl:with-param name="leg" select="string($fixedLeg)"/>
</xsl:call-template>
</xsl:for-each>
</xsl:if>
<xsl:for-each select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/calculationPeriodAmount/calculation/notionalSchedule/notionalStepSchedule/step">
<xsl:call-template name="formatNotionalSchedule">
<xsl:with-param name="position" select="string(position())"/>
<xsl:with-param name="leg" select="string($floatingLeg)"/>
</xsl:call-template>
</xsl:for-each>
<xsl:if test="not(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/calculationPeriodAmount/calculation/notionalSchedule/notionalStepSchedule/step)">
<xsl:for-each select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/calculationPeriodAmount/calculation/floatingRateCalculation/spreadSchedule/step">
<xsl:call-template name="formatNotionalSchedule">
<xsl:with-param name="position" select="string(position())"/>
<xsl:with-param name="leg" select="string($floatingLeg)"/>
</xsl:call-template>
</xsl:for-each>
</xsl:if>
</xsl:if>
</NotionalSchedule>
<SendForPublishing/>
<SubscriberId/>
<ModifiedEquityDelivery/>
<SettledEntityMatrixSource/>
<SettledEntityMatrixDate/>
<AdditionalTerms/>
<NovationInitiatedBy>
<xsl:if test="/SWDML/swLongFormTrade/novation">
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/novation/swNovationInitiatorReference/@href = /SWDML/swLongFormTrade/novation/transferor/@href">Transferor</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/novation/swNovationInitiatorReference/@href = /SWDML/swLongFormTrade/novation/transferee/@href">Transferee</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/novation/swNovationInitiatorReference/@href = /SWDML/swLongFormTrade/novation/remainingParty/@href">RemainingParty</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/novation/swNovationInitiatorReference/@href = /SWDML/swLongFormTrade/novation/otherRemainingParty/@href">RemainingParty</xsl:when>
<xsl:otherwise>Transferor</xsl:otherwise>
</xsl:choose>
</xsl:if>
</NovationInitiatedBy>
<ReportingData>
<PriorUSI/>
<UPI/>
</ReportingData>
<xsl:call-template name="outputCommonReportingFields">
<xsl:with-param name="reportingData" select="$reportingData"/>
</xsl:call-template>
<xsl:for-each select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swBusinessConductDetails/swMidMarketPrice">
<xsl:choose>
<xsl:when test="swUnit | swAmount | swCurrency">
<MidMarketPriceType>
<xsl:value-of select="swUnit"/>
</MidMarketPriceType>
<MidMarketPriceValue>
<xsl:value-of select="swAmount"/>
</MidMarketPriceValue>
<xsl:choose>
<xsl:when test="swUnit='Price'">
<MidMarketPriceCurrency>
<xsl:value-of select="swCurrency"/>
</MidMarketPriceCurrency>
</xsl:when>
<xsl:otherwise>
<IntentToBlankMidMarketCurrency>true</IntentToBlankMidMarketCurrency>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:otherwise>
<IntentToBlankMidMarketPrice>true</IntentToBlankMidMarketPrice>
</xsl:otherwise>
</xsl:choose>
</xsl:for-each>
<xsl:for-each select="/SWDML/swLongFormTrade/novation/swBusinessConductDetails/swMidMarketPrice">
<xsl:choose>
<xsl:when test="swUnit | swAmount | swCurrency">
<NovationFeeMidMarketPriceType>
<xsl:value-of select="swUnit"/>
</NovationFeeMidMarketPriceType>
<NovationFeeMidMarketPriceValue>
<xsl:value-of select="swAmount"/>
</NovationFeeMidMarketPriceValue>
<xsl:choose>
<xsl:when test="swUnit='Price'">
<NovationFeeMidMarketPriceCurrency>
<xsl:value-of select="swCurrency"/>
</NovationFeeMidMarketPriceCurrency>
</xsl:when>
<xsl:otherwise>
<NovationFeeIntentToBlankMidMarketCurrency>true</NovationFeeIntentToBlankMidMarketCurrency>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:otherwise>
<NovationFeeIntentToBlankMidMarketPrice>true</NovationFeeIntentToBlankMidMarketPrice>
</xsl:otherwise>
</xsl:choose>
</xsl:for-each>
<DFEmbeddedOptionType/>
<GenProdPrimaryAssetClass/>
<GenProdSecondaryAssetClass/>
<ProductId/>
<OptionDirectionA/>
<OptionPremium/>
<OptionPremiumCurrency/>
<OptionStrike/>
<OptionStrikeType/>
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
<xsl:if test="boolean($swOrderDetails)">
<OrderDetails>
<xsl:if test="boolean($swOrderDetails/swTypeOfOrder)">
<TypeOfOrder>
<xsl:value-of select="$swOrderDetails/swTypeOfOrder"/>
</TypeOfOrder>
</xsl:if>
<xsl:if test="boolean($swOrderDetails/swTotalConsideration)">
<TotalConsideration>
<xsl:value-of select="$swOrderDetails/swTotalConsideration"/>
</TotalConsideration>
</xsl:if>
<xsl:if test="boolean($swOrderDetails/swRateOfExchange)">
<RateOfExchange>
<xsl:value-of select="$swOrderDetails/swRateOfExchange"/>
</RateOfExchange>
</xsl:if>
<xsl:if test="boolean($swOrderDetails/swClientCounterparty)">
<ClientCounterparty>
<xsl:value-of select="$swOrderDetails/swClientCounterparty"/>
</ClientCounterparty>
</xsl:if>
<xsl:if test="boolean($swOrderDetails/swTotalCommissionAndExpenses)">
<TotalCommissionAndExpenses>
<xsl:value-of select="$swOrderDetails/swTotalCommissionAndExpenses"/>
</TotalCommissionAndExpenses>
</xsl:if>
<xsl:if test="boolean($swOrderDetails/swClientSettlementResponsibilities)">
<ClientSettlementResponsibilities>
<xsl:value-of select="$swOrderDetails/swClientSettlementResponsibilities"/>
</ClientSettlementResponsibilities>
</xsl:if>
</OrderDetails>
</xsl:if>
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
</xsl:template>
<xsl:template name="formatNotionalSchedule">
<xsl:param name="position"/>
<xsl:param name="leg"/>
<xsl:choose>
<xsl:when test="$leg=$floatingLeg">
<FloatLegNotionalStep>
<FloatRollDates>
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$leg]/calculationPeriodAmount/calculation/notionalSchedule/notionalStepSchedule/step[position()= $position]/stepDate">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$leg]/calculationPeriodAmount/calculation/notionalSchedule/notionalStepSchedule/step[position()= $position]/stepDate"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$leg]/calculationPeriodAmount/calculation/floatingRateCalculation/spreadSchedule/step[position()= $position]/stepDate"/>
</xsl:otherwise>
</xsl:choose>
</FloatRollDates>
<FloatNotionals>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$leg]/calculationPeriodAmount/calculation/notionalSchedule/notionalStepSchedule/step[position()= $position]/stepValue"/>
</FloatNotionals>
<FloatSpreads>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$leg]/calculationPeriodAmount/calculation/floatingRateCalculation/spreadSchedule/step[position()= $position]/stepValue"/>
</FloatSpreads>
</FloatLegNotionalStep>
</xsl:when>
<xsl:when test="$leg=$fixedLeg">
<FixedLegNotionalStep>
<FixedPaymentDates>
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$leg]/calculationPeriodAmount/calculation/notionalSchedule/notionalStepSchedule/step[position()= $position]/stepDate">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$leg]/calculationPeriodAmount/calculation/notionalSchedule/notionalStepSchedule/step[position()= $position]/stepDate"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$leg]/calculationPeriodAmount/calculation/fixedRateSchedule/step[position()= $position]/stepDate"/>
</xsl:otherwise>
</xsl:choose>
</FixedPaymentDates>
<FixedNotionals>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$leg]/calculationPeriodAmount/calculation/notionalSchedule/notionalStepSchedule/step[position()= $position]/stepValue"/>
</FixedNotionals>
<FixedRates>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$leg]/calculationPeriodAmount/calculation/fixedRateSchedule/step[position()= $position]/stepValue"/>
</FixedRates>
</FixedLegNotionalStep>
</xsl:when>
</xsl:choose>
</xsl:template>
<xsl:template match="businessCenters">
<xsl:for-each select="businessCenter">
<xsl:value-of select="."/>
<xsl:if test="../businessCenter[last()]!=.">; </xsl:if>
</xsl:for-each>
</xsl:template>
<xsl:template match="cashSettlementReferenceBanks">
<xsl:for-each select="referenceBank">
<xsl:value-of select="referenceBankId"/>
<xsl:if test="../referenceBank[last()]!=.">; </xsl:if>
</xsl:for-each>
</xsl:template>
<xsl:template match="additionalPayment|payment">
<xsl:choose>
<xsl:when test="$productType='CapFloor' and paymentType='Premium'"/>
<xsl:otherwise>
<xsl:if test="string(paymentType) != 'CancellablePremium'">
<AdditionalPayment>
<PaymentDirectionA>
<xsl:variable name="payer" select="string(payerPartyReference/@href)"/>
<xsl:choose>
<xsl:when test="substring-after($payer,'#')=string($partyA)">Pay</xsl:when>
<xsl:otherwise>Rec</xsl:otherwise>
</xsl:choose>
</PaymentDirectionA>
<Reason>
<xsl:choose>
<xsl:when test="../payment">Novation</xsl:when>
<xsl:otherwise>
<xsl:value-of select="paymentType"/>
</xsl:otherwise>
</xsl:choose>
</Reason>
<Currency>
<xsl:value-of select="paymentAmount/currency"/>
</Currency>
<Amount>
<xsl:value-of select="paymentAmount/amount"/>
</Amount>
<Date>
<xsl:if test="paymentDate">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string(paymentDate/unadjustedDate)"/>
</xsl:call-template>
</xsl:if>
</Date>
<Convention>
<xsl:value-of select="substring(paymentDate/dateAdjustments/businessDayConvention,1,4)"/>
</Convention>
<Holidays>
<xsl:apply-templates select="paymentDate/dateAdjustments/businessCenters"/>
</Holidays>
<LegalEntity>
<xsl:if test="/SWDML/swLongFormTrade/novation">
<xsl:choose>
<xsl:when test="$partyE = $partyA">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML//party[@id=$partyF]/partyId"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML//party[@id=$partyE]/partyId"/>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</LegalEntity>
</AdditionalPayment>
</xsl:if>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template name="formatDate"><xsl:param name="date"/><xsl:variable name="month" select="string(substring($date,6,2))"/><xsl:value-of select="substring($date,9,2)"/>-<xsl:choose><xsl:when test="$month='01'">Jan</xsl:when><xsl:when test="$month='02'">Feb</xsl:when><xsl:when test="$month='03'">Mar</xsl:when><xsl:when test="$month='04'">Apr</xsl:when><xsl:when test="$month='05'">May</xsl:when><xsl:when test="$month='06'">Jun</xsl:when><xsl:when test="$month='07'">Jul</xsl:when><xsl:when test="$month='08'">Aug</xsl:when><xsl:when test="$month='09'">Sep</xsl:when><xsl:when test="$month='10'">Oct</xsl:when><xsl:when test="$month='11'">Nov</xsl:when><xsl:when test="$month='12'">Dec</xsl:when><xsl:otherwise>???</xsl:otherwise></xsl:choose>-<xsl:value-of select="substring($date,1,4)"/></xsl:template>
<xsl:template name="formatTime">
<xsl:param name="time"/>
<xsl:choose>
<xsl:when test="$time='09:00:00'">9am</xsl:when>
<xsl:when test="$time='09:30:00'">9:30am</xsl:when>
<xsl:when test="$time='11:00:00'">11am</xsl:when>
<xsl:when test="$time='11:15:00'">11:15am</xsl:when>
<xsl:when test="$time='11:30:00'">11:30am</xsl:when>
<xsl:when test="$time='12:00:00'">12noon</xsl:when>
<xsl:when test="$time='15:00:00'">3pm</xsl:when>
<xsl:when test="$time='15:30:00'">3:30pm</xsl:when>
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
<xsl:when test="$time='10:30:00'">10:30am</xsl:when>
<xsl:when test="$time='12:30:00'">12:30pm</xsl:when>
<xsl:when test="$time='13:00:00'">1pm</xsl:when>
<xsl:when test="$time='13:30:00'">1:30pm</xsl:when>
<xsl:when test="$time='14:00:00'">2pm</xsl:when>
<xsl:when test="$time='14:30:00'">2:30pm</xsl:when>
<xsl:when test="$time='16:00:00'">4pm</xsl:when>
<xsl:when test="$time='16:30:00'">4:30pm</xsl:when>
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
<xsl:template name="calculateTenor">
<xsl:param name="startDate"/>
<xsl:param name="endDate"/>
<xsl:variable name="startDateMonth" select="string(number(substring($startDate,6,2)))"/>
<xsl:variable name="endDateMonth" select="string(number(substring($endDate,6,2)))"/>
<xsl:variable name="startDateYear" select="string(number(substring($startDate,1,4)))"/>
<xsl:variable name="endDateYear" select="string(number(substring($endDate,1,4)))"/>
<xsl:variable name="tenorMultiplier" select="string((($endDateYear - $startDateYear)*12) + ($endDateMonth - $startDateMonth))"/>
<xsl:choose>
<xsl:when test="$tenorMultiplier &gt; 1">
<xsl:value-of select="concat($tenorMultiplier,'M')"/>
</xsl:when>
<xsl:otherwise>1M</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template name="swAllocations">
<xsl:apply-templates select="/SWDML/swLongFormTrade/swAllocations/swAllocation"/>
</xsl:template>
<xsl:template match="swAllocation">
<Allocation>
<xsl:variable name="directionRev">
<xsl:choose>
<xsl:when test="@directionReversed">
<xsl:value-of select="@directionReversed"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="'false'"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<DirectionReversed>
<xsl:value-of select="$directionRev"/>
</DirectionReversed>
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/swAllocations/swAllocation/payerPartyReference">
<xsl:variable name="PayerRef">
<xsl:choose>
<xsl:when test="starts-with(payerPartyReference/@href,'#')">
<xsl:value-of select="substring-after(payerPartyReference/@href,'#')"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="payerPartyReference/@href"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="ReceiverRef">
<xsl:choose>
<xsl:when test="starts-with(receiverPartyReference/@href,'#')">
<xsl:value-of select="substring-after(receiverPartyReference/@href,'#')"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="receiverPartyReference/@href"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="PayerBIC" select="string(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML//party[@id=$PayerRef]/partyId)"/>
<xsl:variable name="ReceiverBIC" select="string(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML//party[@id=$ReceiverRef]/partyId)"/>
<Payer>
<xsl:value-of select="$PayerBIC"/>
</Payer>
<Receiver>
<xsl:value-of select="$ReceiverBIC"/>
</Receiver>
</xsl:when>
<xsl:otherwise>
<xsl:variable name="BuyerRef">
<xsl:choose>
<xsl:when test="starts-with(buyerPartyReference/@href,'#')">
<xsl:value-of select="substring-after(buyerPartyReference/@href,'#')"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="buyerPartyReference/@href"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="SellerRef">
<xsl:choose>
<xsl:when test="starts-with(sellerPartyReference/@href,'#')">
<xsl:value-of select="substring-after(sellerPartyReference/@href,'#')"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="sellerPartyReference/@href"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="BuyerBIC" select="string(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML//party[@id=$BuyerRef]/partyId)"/>
<xsl:variable name="SellerBIC" select="string(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML//party[@id=$SellerRef]/partyId)"/>
<Buyer>
<xsl:value-of select="$BuyerBIC"/>
</Buyer>
<Seller>
<xsl:value-of select="$SellerBIC"/>
</Seller>
</xsl:otherwise>
</xsl:choose>
<xsl:variable name="amount" select="string(allocatedNotional/amount)"/>
<Amount>
<xsl:value-of select="$amount"/>
</Amount>
<IAExpected>
<xsl:value-of select="swIAExpected"/>
</IAExpected>
<xsl:if test="swAllocationReportingDetails[count(swJurisdiction)=0 and count(swUniqueTransactionId/swIssuer)=0]/swUniqueTransactionId/swTradeId">
<xsl:variable name="globalUti" select="string(swAllocationReportingDetails[count(swJurisdiction)=0 and count(swUniqueTransactionId/swIssuer)=0]/swUniqueTransactionId/swTradeId)"/>
<GlobalUTI>
<xsl:value-of select="$globalUti"/>
</GlobalUTI>
</xsl:if>
<xsl:if test="independentAmount">
<xsl:apply-templates select="independentAmount"/>
</xsl:if>
<xsl:if test="additionalPayment">
<xsl:call-template name="AllocationAdditionalPayment"/>
</xsl:if>
<xsl:if test="swPrivateTradeId">
<xsl:apply-templates select="swPrivateTradeId"/>
</xsl:if>
<xsl:if test="swSalesCredit">
<xsl:apply-templates select="swSalesCredit"/>
</xsl:if>
<xsl:if test="swAdditionalField">
<xsl:apply-templates select="swAdditionalField"/>
</xsl:if>
<xsl:if test="/SWDML/swLongFormTrade/swAllocations/swAllocation/swClearingBroker/partyId">
<xsl:variable name="clearingbroker" select="string(swClearingBroker/partyId)"/>
<ClearingBrokerId>
<xsl:value-of select="$clearingbroker"/>
</ClearingBrokerId>
</xsl:if>
<xsl:if test="/SWDML/swLongFormTrade/swAllocations/swAllocation/swNettingString">
<xsl:variable name="nettingstring" select="string(swNettingString)"/>
<NettingString>
<xsl:value-of select="$nettingstring"/>
</NettingString>
</xsl:if>
<xsl:if test="swAllocationReportingDetails[swJurisdiction='DoddFrank']/swObligatoryReporting">
<ObligatoryReporting>
<xsl:value-of select="swAllocationReportingDetails[swJurisdiction='DoddFrank']/swObligatoryReporting"/>
</ObligatoryReporting>
</xsl:if>
<xsl:if test="swAllocationReportingDetails[swJurisdiction='DoddFrank']/swReportingCounterpartyReference/@href">
<xsl:variable name="rcp" select="substring-after(swAllocationReportingDetails[swJurisdiction='DoddFrank']/swReportingCounterpartyReference/@href, '#')"/>
<xsl:variable name="rcpBIC" select="string(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/party[@id=$rcp]/partyId)"/>
<ReportingCounterparty>
<xsl:value-of select="$rcpBIC"/>
</ReportingCounterparty>
</xsl:if>
<xsl:if test="swAllocationReportingDetails/swUniqueTransactionId/swIssuer">
<xsl:variable name="usinamespace" select="string(swAllocationReportingDetails/swUniqueTransactionId/swIssuer)"/>
<USINamespace>
<xsl:value-of select="$usinamespace"/>
</USINamespace>
</xsl:if>
<xsl:if test="swAllocationReportingDetails[count(swUniqueTransactionId/swIssuer) > 0]/swUniqueTransactionId/swTradeId">
<xsl:variable name="usi" select="string(swAllocationReportingDetails[count(swUniqueTransactionId/swIssuer) > 0]/swUniqueTransactionId/swTradeId)"/>
<USI>
<xsl:value-of select="$usi"/>
</USI>
</xsl:if>
<xsl:if test="swAllocationReportingDetails[swJurisdiction='ESMA']/swUniqueTransactionId/swIssuer">
<xsl:variable name="esutinamespace" select="string(swAllocationReportingDetails[swJurisdiction='ESMA']/swUniqueTransactionId/swIssuer)"/>
<ESMAUTINamespace>
<xsl:value-of select="$esutinamespace"/>
</ESMAUTINamespace>
<ESMAIntentToBlankUTINamespace>
<xsl:choose>
<xsl:when test="swAllocationReportingDetails[swJurisdiction='ESMA']/swUniqueTransactionId/swIssuer and $esutinamespace ='' ">
<xsl:value-of select="'true'"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="'false'"/>
</xsl:otherwise>
</xsl:choose>
</ESMAIntentToBlankUTINamespace>
</xsl:if>
<xsl:if test="swAllocationReportingDetails[swJurisdiction='ESMA']/swUniqueTransactionId/swTradeId">
<xsl:variable name="esuti" select="string(swAllocationReportingDetails[swJurisdiction='ESMA']/swUniqueTransactionId/swTradeId)"/>
<ESMAUTI>
<xsl:value-of select="$esuti"/>
</ESMAUTI>
<ESMAIntentToBlankUTI>
<xsl:choose>
<xsl:when test="swAllocationReportingDetails[swJurisdiction='ESMA']/swUniqueTransactionId/swTradeId and $esuti ='' ">
<xsl:value-of select="'true'"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="'false'"/>
</xsl:otherwise>
</xsl:choose>
</ESMAIntentToBlankUTI>
</xsl:if>
<xsl:if test="swAllocationReportingDetails[swJurisdiction='ESMA']/swReportForCounterparty">
<ESMAReportForCpty>
<xsl:value-of select="swAllocationReportingDetails[swJurisdiction='ESMA']/swReportForCounterparty"/>
</ESMAReportForCpty>
</xsl:if>
<xsl:if test="swAllocationReportingDetails[swJurisdiction='FCA']/swUniqueTransactionId/swIssuer">
<xsl:variable name="fcautinamespace" select="string(swAllocationReportingDetails[swJurisdiction='FCA']/swUniqueTransactionId/swIssuer)"/>
<FCAUTINamespace>
<xsl:value-of select="$fcautinamespace"/>
</FCAUTINamespace>
<FCAIntentToBlankUTINamespace>
<xsl:choose>
<xsl:when test="swAllocationReportingDetails[swJurisdiction='FCA']/swUniqueTransactionId/swIssuer and $fcautinamespace ='' ">
<xsl:value-of select="'true'"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="'false'"/>
</xsl:otherwise>
</xsl:choose>
</FCAIntentToBlankUTINamespace>
</xsl:if>
<xsl:if test="swAllocationReportingDetails[swJurisdiction='FCA']/swUniqueTransactionId/swTradeId">
<xsl:variable name="fcauti" select="string(swAllocationReportingDetails[swJurisdiction='FCA']/swUniqueTransactionId/swTradeId)"/>
<FCAUTI>
<xsl:value-of select="$fcauti"/>
</FCAUTI>
<FCAIntentToBlankUTI>
<xsl:choose>
<xsl:when test="swAllocationReportingDetails[swJurisdiction='FCA']/swUniqueTransactionId/swTradeId and $fcauti ='' ">
<xsl:value-of select="'true'"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="'false'"/>
</xsl:otherwise>
</xsl:choose>
</FCAIntentToBlankUTI>
</xsl:if>
<xsl:if test="swAllocationReportingDetails[swJurisdiction='FCA']/swReportForCounterparty">
<FCAReportForCpty>
<xsl:value-of select="swAllocationReportingDetails[swJurisdiction='FCA']/swReportForCounterparty"/>
</FCAReportForCpty>
</xsl:if>
<xsl:if test="swAllocationReportingDetails[swJurisdiction='JFSA']/swUniqueTransactionId/swIssuer">
<xsl:variable name="jfutinamespace" select="string(swAllocationReportingDetails[swJurisdiction='JFSA']/swUniqueTransactionId/swIssuer)"/>
<JFSAUTINamespace>
<xsl:value-of select="$jfutinamespace"/>
</JFSAUTINamespace>
<JFSAIntentToBlankUTINamespace>
<xsl:choose>
<xsl:when test="swAllocationReportingDetails[swJurisdiction='JFSA']/swUniqueTransactionId/swIssuer and $jfutinamespace ='' ">
<xsl:value-of select="'true'"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="'false'"/>
</xsl:otherwise>
</xsl:choose>
</JFSAIntentToBlankUTINamespace>
</xsl:if>
<xsl:if test="swAllocationReportingDetails[swJurisdiction='JFSA']/swUniqueTransactionId/swTradeId">
<xsl:variable name="jfuti" select="string(swAllocationReportingDetails[swJurisdiction='JFSA']/swUniqueTransactionId/swTradeId)"/>
<JFSAUTI>
<xsl:value-of select="$jfuti"/>
</JFSAUTI>
<JFSAIntentToBlankUTI>
<xsl:choose>
<xsl:when test="swAllocationReportingDetails[swJurisdiction='JFSA']/swUniqueTransactionId/swTradeId and $jfuti ='' ">
<xsl:value-of select="'true'"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="'false'"/>
</xsl:otherwise>
</xsl:choose>
</JFSAIntentToBlankUTI>
</xsl:if>
<xsl:if test="swAllocationReportingDetails[swJurisdiction='HKMA']/swUniqueTransactionId/swIssuer">
<xsl:variable name="hkutinamespace" select="string(swAllocationReportingDetails[swJurisdiction='HKMA']/swUniqueTransactionId/swIssuer)"/>
<HKMIUTINamespace>
<xsl:value-of select="$hkutinamespace"/>
</HKMIUTINamespace>
<HKMAIntentToBlankUTINamespace>
<xsl:choose>
<xsl:when test="swAllocationReportingDetails[swJurisdiction='HKMA']/swUniqueTransactionId/swIssuer and $hkutinamespace ='' ">
<xsl:value-of select="'true'"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="'false'"/>
</xsl:otherwise>
</xsl:choose>
</HKMAIntentToBlankUTINamespace>
</xsl:if>
<xsl:if test="swAllocationReportingDetails[swJurisdiction='HKMA']/swUniqueTransactionId/swTradeId">
<xsl:variable name="hkuti" select="string(swAllocationReportingDetails[swJurisdiction='HKMA']/swUniqueTransactionId/swTradeId)"/>
<HKMIUTI>
<xsl:value-of select="$hkuti"/>
</HKMIUTI>
<HKMAIntentToBlankUTI>
<xsl:choose>
<xsl:when test="swAllocationReportingDetails[swJurisdiction='HKMA']/swUniqueTransactionId/swTradeId and $hkuti ='' ">
<xsl:value-of select="'true'"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="'false'"/>
</xsl:otherwise>
</xsl:choose>
</HKMAIntentToBlankUTI>
</xsl:if>
<xsl:if test="swAllocationReportingDetails[swJurisdiction='CAN']/swObligatoryReporting">
<CAObligatoryReporting>
<xsl:value-of select="swAllocationReportingDetails[swJurisdiction='CAN']/swObligatoryReporting"/>
</CAObligatoryReporting>
</xsl:if>
<xsl:if test="swAllocationReportingDetails[swJurisdiction='CAN']/swReportingCounterpartyReference/@href">
<xsl:variable name="rcp" select="substring-after(swAllocationReportingDetails[swJurisdiction='CAN']/swReportingCounterpartyReference/@href, '#')"/>
<xsl:variable name="rcpBIC" select="string(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/party[@id=$rcp]/partyId)"/>
<CAReportingCounterparty>
<xsl:value-of select="$rcpBIC"/>
</CAReportingCounterparty>
</xsl:if>
<xsl:if test="swAllocationReportingDetails[swJurisdiction='CAN']/swUniqueTransactionId/swIssuer">
<xsl:variable name="cautinamespace" select="string(swAllocationReportingDetails[swJurisdiction='CAN']/swUniqueTransactionId/swIssuer)"/>
<CAUTINamespace>
<xsl:value-of select="$cautinamespace"/>
</CAUTINamespace>
<CAIntentToBlankUTINamespace>
<xsl:choose>
<xsl:when test="swAllocationReportingDetails[swJurisdiction='CAN']/swUniqueTransactionId/swIssuer and $cautinamespace ='' ">
<xsl:value-of select="'true'"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="'false'"/>
</xsl:otherwise>
</xsl:choose>
</CAIntentToBlankUTINamespace>
</xsl:if>
<xsl:if test="swAllocationReportingDetails[swJurisdiction='CAN']/swUniqueTransactionId/swTradeId">
<xsl:variable name="cauti" select="string(swAllocationReportingDetails[swJurisdiction='CAN']/swUniqueTransactionId/swTradeId)"/>
<CAUTI>
<xsl:value-of select="$cauti"/>
</CAUTI>
<CAIntentToBlankUTI>
<xsl:choose>
<xsl:when test="swAllocationReportingDetails[swJurisdiction='CAN']/swUniqueTransactionId/swTradeId and $cauti ='' ">
<xsl:value-of select="'true'"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="'false'"/>
</xsl:otherwise>
</xsl:choose>
</CAIntentToBlankUTI>
</xsl:if>
<xsl:if test="swAllocationReportingDetails[swJurisdiction='MIFID']/swObligatoryReporting">
<MIObligatoryReporting>
<xsl:value-of select="swAllocationReportingDetails[swJurisdiction='MIFID']/swObligatoryReporting"/>
</MIObligatoryReporting>
</xsl:if>
<xsl:if test="swAllocationReportingDetails[swJurisdiction='MIFID']/swReportingCounterpartyReference/@href">
<xsl:variable name="rcp" select="substring-after(swAllocationReportingDetails[swJurisdiction='MIFID']/swReportingCounterpartyReference/@href, '#')"/>
<xsl:choose>
<xsl:when test="$rcp = 'venue' or $rcp = '#venue'">
<MIReportingCounterparty>
<xsl:value-of select="'venue'"/>
</MIReportingCounterparty>
</xsl:when>
<xsl:otherwise>
<xsl:variable name="rcpBIC" select="string(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/party[@id=$rcp]/partyId)"/>
<MIReportingCounterparty>
<xsl:value-of select="$rcpBIC"/>
</MIReportingCounterparty>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="swAllocationReportingDetails[swJurisdiction='MIFID']/swMIFIDTransactionIdentifier">
<xsl:variable name="mitid" select="string(swAllocationReportingDetails[swJurisdiction='MIFID']/swMIFIDTransactionIdentifier)"/>
<MITID>
<xsl:value-of select="$mitid"/>
</MITID>
<MIIntentToBlankTID>
<xsl:choose>
<xsl:when test="swAllocationReportingDetails[swJurisdiction='MIFID']/swMIFIDTransactionIdentifier and $mitid ='' ">
<xsl:value-of select="'true'"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="'false'"/>
</xsl:otherwise>
</xsl:choose>
</MIIntentToBlankTID>
</xsl:if>
<xsl:if test="swAllocationReportingDetails[swJurisdiction='MIFID']/swRegulatoryReportable">
<MITransactionReportable>
<xsl:value-of select="swAllocationReportingDetails[swJurisdiction='MIFID']/swRegulatoryReportable"/>
</MITransactionReportable>
</xsl:if>
<xsl:if test="swAllocationReportingDetails[swJurisdiction='MIFID']/swTransparencyReportable">
<MITransparencyReportable>
<xsl:value-of select="swAllocationReportingDetails[swJurisdiction='MIFID']/swTransparencyReportable"/>
</MITransparencyReportable>
</xsl:if>
<xsl:if test="swAllocationReportingDetails[swJurisdiction='ASIC']/swUniqueTransactionId/swIssuer">
<xsl:variable name="asutinamespace" select="string(swAllocationReportingDetails[swJurisdiction='ASIC']/swUniqueTransactionId/swIssuer)"/>
<ASICUTINamespace>
<xsl:value-of select="$asutinamespace"/>
</ASICUTINamespace>
<ASICIntentToBlankUTINamespace>
<xsl:choose>
<xsl:when test="swAllocationReportingDetails[swJurisdiction='ASIC']/swUniqueTransactionId/swIssuer and $asutinamespace ='' ">
<xsl:value-of select="'true'"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="'false'"/>
</xsl:otherwise>
</xsl:choose>
</ASICIntentToBlankUTINamespace>
</xsl:if>
<xsl:if test="swAllocationReportingDetails[swJurisdiction='ASIC']/swUniqueTransactionId/swTradeId">
<xsl:variable name="asuti" select="string(swAllocationReportingDetails[swJurisdiction='ASIC']/swUniqueTransactionId/swTradeId)"/>
<ASICUTI>
<xsl:value-of select="$asuti"/>
</ASICUTI>
<ASICIntentToBlankUTI>
<xsl:choose>
<xsl:when test="swAllocationReportingDetails[swJurisdiction='ASIC']/swUniqueTransactionId/swTradeId and $asuti ='' ">
<xsl:value-of select="'true'"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="'false'"/>
</xsl:otherwise>
</xsl:choose>
</ASICIntentToBlankUTI>
</xsl:if>
<xsl:if test="swAllocationReportingDetails[swJurisdiction='MAS']/swUniqueTransactionId/swIssuer">
<xsl:variable name="masutinamespace" select="string(swAllocationReportingDetails[swJurisdiction='MAS']/swUniqueTransactionId/swIssuer)"/>
<MASUTINamespace>
<xsl:value-of select="$masutinamespace"/>
</MASUTINamespace>
<MASIntentToBlankUTINamespace>
<xsl:choose>
<xsl:when test="swAllocationReportingDetails[swJurisdiction='MAS']/swUniqueTransactionId/swIssuer and $masutinamespace ='' ">
<xsl:value-of select="'true'"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="'false'"/>
</xsl:otherwise>
</xsl:choose>
</MASIntentToBlankUTINamespace>
</xsl:if>
<xsl:if test="swAllocationReportingDetails[swJurisdiction='MAS']/swUniqueTransactionId/swTradeId">
<xsl:variable name="masuti" select="string(swAllocationReportingDetails[swJurisdiction='MAS']/swUniqueTransactionId/swTradeId)"/>
<MASUTI>
<xsl:value-of select="$masuti"/>
</MASUTI>
<MASIntentToBlankUTI>
<xsl:choose>
<xsl:when test="swAllocationReportingDetails[swJurisdiction='MAS']/swUniqueTransactionId/swTradeId and $masuti ='' ">
<xsl:value-of select="'true'"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="'false'"/>
</xsl:otherwise>
</xsl:choose>
</MASIntentToBlankUTI>
</xsl:if>
<xsl:if test="swIdentifiers">
<PartyIdentifiers>
<xsl:if test="swIdentifiers/swPartyIdentifiers/swCounterpartyLEI">
<CounterpartyLEI><xsl:value-of select="swIdentifiers/swPartyIdentifiers/swCounterpartyLEI"/></CounterpartyLEI>
</xsl:if>
<xsl:if test="swIdentifiers/swPartyIdentifiers/swCounterpartyPLI">
<CounterpartyPLI><xsl:value-of select="swIdentifiers/swPartyIdentifiers/swCounterpartyPLI"/></CounterpartyPLI>
</xsl:if>
<xsl:if test="swIdentifiers/swPartyIdentifiers/swDataMaskingFlag">
<xsl:variable name="dataMaskingFlag" select="swIdentifiers/swPartyIdentifiers/swDataMaskingFlag"/>
<DataMaskingFlag>
<xsl:if test="$dataMaskingFlag/swMaskCFTC">
<MaskCFTC><xsl:value-of select="$dataMaskingFlag/swMaskCFTC"/></MaskCFTC>
</xsl:if>
<xsl:if test="$dataMaskingFlag/swMaskJFSA">
<MaskJFSA><xsl:value-of select="$dataMaskingFlag/swMaskJFSA"/></MaskJFSA>
</xsl:if>
<xsl:if test="$dataMaskingFlag/swMaskCanada">
<MaskCanada><xsl:value-of select="$dataMaskingFlag/swMaskCanada"/></MaskCanada>
</xsl:if>
<xsl:if test="$dataMaskingFlag/swMaskHKMA">
<MaskHKMA><xsl:value-of select="$dataMaskingFlag/swMaskHKMA"/></MaskHKMA>
</xsl:if>
<xsl:if test="$dataMaskingFlag/swMaskASIC">
<MaskASIC><xsl:value-of select="$dataMaskingFlag/swMaskASIC"/></MaskASIC>
</xsl:if>
<xsl:if test="$dataMaskingFlag/swMaskMAS">
<MaskMAS><xsl:value-of select="$dataMaskingFlag/swMaskMAS"/></MaskMAS>
</xsl:if>
</DataMaskingFlag>
</xsl:if>
</PartyIdentifiers>
</xsl:if>
<xsl:if test="swNexusReportingDetails">
<xsl:variable name="nexusNode" select="swNexusReportingDetails"/>
<NexusReportingDetails>
<xsl:variable name="execTraderHref">
<xsl:choose>
<xsl:when test="starts-with($nexusNode/swRelatedPerson[swRole='Trader']/swPersonReference/@href,'#')">
<xsl:value-of select="substring-after($nexusNode/swRelatedPerson[swRole='Trader']/swPersonReference/@href,'#')"/>
</xsl:when>
<xsl:otherwise><xsl:value-of select="''"/></xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="execTraderName" select="$nexusNode/swPartyExtension/swReferencedPerson[@id=$execTraderHref]/swName"/>
<xsl:variable name="execTraderLocation" select="$nexusNode/swPartyExtension/swReferencedPerson[@id=$execTraderHref]/swCountry"/>
<xsl:variable name="salesTraderHref">
<xsl:choose>
<xsl:when test="starts-with($nexusNode/swRelatedPerson[swRole='Sales']/swPersonReference/@href,'#')">
<xsl:value-of select="substring-after($nexusNode/swRelatedPerson[swRole='Sales']/swPersonReference/@href,'#')"/>
</xsl:when>
<xsl:otherwise><xsl:value-of select="''"/></xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="salesTraderName" select="$nexusNode/swPartyExtension/swReferencedPerson[@id=$salesTraderHref]/swName"/>
<xsl:variable name="salesTraderLocation" select="$nexusNode/swPartyExtension/swReferencedPerson[@id=$salesTraderHref]/swCountry"/>
<xsl:variable name="investFirmHref">
<xsl:choose>
<xsl:when test="starts-with($nexusNode/swRelatedPerson[swRole='InvestmentDecisionMaker']/swPersonReference/@href,'#')">
<xsl:value-of select="substring-after($nexusNode/swRelatedPerson[swRole='InvestmentDecisionMaker']/swPersonReference/@href,'#')"/>
</xsl:when>
<xsl:otherwise><xsl:value-of select="''"/></xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="investFirmName" select="$nexusNode/swPartyExtension/swReferencedPerson[@id=$investFirmHref]/swName"/>
<xsl:variable name="investFirmLocation" select="$nexusNode/swPartyExtension/swReferencedPerson[@id=$investFirmHref]/swCountry"/>
<xsl:variable name="branchHref">
<xsl:choose>
<xsl:when test="starts-with($nexusNode/swRelatedBusinessUnit[swRole='Branch']/swBusinessUnitReference/@href,'#')">
<xsl:value-of select="substring-after($nexusNode/swRelatedBusinessUnit[swRole='Branch']/swBusinessUnitReference/@href,'#')"/>
</xsl:when>
<xsl:otherwise><xsl:value-of select="''"/></xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="branchLocation" select="$nexusNode/swPartyExtension/swBusinessUnit[@id=$branchHref]/swCountry"/>
<xsl:variable name="deskHref">
<xsl:choose>
<xsl:when test="starts-with($nexusNode/swRelatedBusinessUnit[swRole='Trader']/swBusinessUnitReference/@href,'#')">
<xsl:value-of select="substring-after($nexusNode/swRelatedBusinessUnit[swRole='Trader']/swBusinessUnitReference/@href,'#')"/>
</xsl:when>
<xsl:otherwise><xsl:value-of select="''"/></xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="deskLocation" select="$nexusNode/swPartyExtension/swBusinessUnit[@id=$deskHref]/swCountry"/>
<xsl:variable name="brokerHref">
<xsl:choose>
<xsl:when test="starts-with($nexusNode/swRelatedParty[swRole='ExecutingBroker']/swPartyReference/@href,'#')">
<xsl:value-of select="substring-after($nexusNode/swRelatedParty[swRole='ExecutingBroker']/swPartyReference/@href,'#')"/>
</xsl:when>
<xsl:otherwise><xsl:value-of select="''"/></xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="brokerLocation" select="$nexusNode/swAdditionalParty[@id=$brokerHref]/swCountry"/>
<xsl:variable name="arrBrokerHref">
<xsl:choose>
<xsl:when test="starts-with($nexusNode/swRelatedParty[swRole='ArrangingBroker']/swPartyReference/@href,'#')">
<xsl:value-of select="substring-after($nexusNode/swRelatedParty[swRole='ArrangingBroker']/swPartyReference/@href,'#')"/>
</xsl:when>
<xsl:otherwise><xsl:value-of select="''"/></xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="arrBrokerLocation" select="$nexusNode/swAdditionalParty[@id=$arrBrokerHref]/swCountry"/>
<xsl:if test="$execTraderName">
<ExecutingTraderName><xsl:value-of select="$execTraderName"/></ExecutingTraderName>
</xsl:if>
<xsl:if test="$salesTraderName">
<SalesTraderName><xsl:value-of select="$salesTraderName"/></SalesTraderName>
</xsl:if>
<xsl:if test="$investFirmName">
<InvestFirmName><xsl:value-of select="$investFirmName"/></InvestFirmName>
</xsl:if>
<xsl:if test="$branchLocation">
<BranchLocation><xsl:value-of select="$branchLocation"/></BranchLocation>
</xsl:if>
<xsl:if test="$deskLocation">
<DeskLocation><xsl:value-of select="$deskLocation"/></DeskLocation>
</xsl:if>
<xsl:if test="$execTraderLocation">
<ExecutingTraderLocation><xsl:value-of select="$execTraderLocation"/></ExecutingTraderLocation>
</xsl:if>
<xsl:if test="$salesTraderLocation">
<SalesTraderLocation><xsl:value-of select="$salesTraderLocation"/></SalesTraderLocation>
</xsl:if>
<xsl:if test="$investFirmLocation">
<InvestFirmLocation><xsl:value-of select="$investFirmLocation"/></InvestFirmLocation>
</xsl:if>
<xsl:if test="$brokerLocation">
<BrokerLocation><xsl:value-of select="$brokerLocation"/></BrokerLocation>
</xsl:if>
<xsl:if test="$arrBrokerLocation">
<ArrBrokerLocation><xsl:value-of select="$arrBrokerLocation"/></ArrBrokerLocation>
</xsl:if>
</NexusReportingDetails>
</xsl:if>
<xsl:if test="swCounterpartyCorporateSector">
<CounterpartyCorporateSector>
<xsl:value-of select="swCounterpartyCorporateSector"/>
</CounterpartyCorporateSector>
</xsl:if>
</Allocation>
</xsl:template>
<xsl:template match="independentAmount">
<IndependentAmount>
<xsl:variable name="amount" select="string(paymentDetail/paymentAmount/amount)"/>
<Amount>
<xsl:value-of select="$amount"/>
</Amount>
</IndependentAmount>
</xsl:template>
<xsl:template name="AllocationAdditionalPayment">
<xsl:for-each select="additionalPayment">
<xsl:choose>
<xsl:when test="paymentType='CancellablePremium'">
<xsl:variable name="amount" select="string(paymentAmount/amount)"/>
<AllocCancellablePremiumAmount>
<xsl:value-of select="$amount"/>
</AllocCancellablePremiumAmount>
</xsl:when>
<xsl:otherwise>
<AllocAdditionalPayment>
<AddPaySequence>
<xsl:value-of select="@seq"/>
</AddPaySequence>
<xsl:variable name="directionRev">
<xsl:choose>
<xsl:when test="@directionReversed">
<xsl:value-of select="'true'"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="'false'"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<DirectionReversed>
<xsl:value-of select="$directionRev"/>
</DirectionReversed>
<xsl:variable name="amount" select="string(paymentAmount/amount)"/>
<Amount>
<xsl:value-of select="$amount"/>
</Amount>
</AllocAdditionalPayment>
</xsl:otherwise>
</xsl:choose>
</xsl:for-each>
</xsl:template>
<xsl:template match="swPrivateTradeId">
<InternalTradeId>
<xsl:variable name="value" select="string(.)"/>
<xsl:value-of select="$value"/>
</InternalTradeId>
</xsl:template>
<xsl:template match="swSalesCredit">
<SalesCredit>
<xsl:variable name="amount" select="string(.)"/>
<xsl:value-of select="$amount"/>
</SalesCredit>
</xsl:template>
<xsl:template match="swAdditionalField">
<AdditionalField>
<xsl:variable name="name" select="string(@fieldName)"/>
<xsl:variable name="sequence" select="string(@sequence)"/>
<xsl:variable name="value" select="string(.)"/>
<Name>
<xsl:value-of select="$name"/>
</Name>
<Sequence>
<xsl:value-of select="$sequence"/>
</Sequence>
<Value>
<xsl:value-of select="$value"/>
</Value>
</AdditionalField>
</xsl:template>
</xsl:stylesheet>
