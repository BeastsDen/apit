<?xml version="1.0"?>
<xsl:stylesheet
xmlns:lcl="http://www.markit.com/swdml-extract-ird-4-2.xsl"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:fpml="http://www.fpml.org/2005/FpML-4-2"
xmlns:tx="http://www.markitserv.com/detail/SWDMLTrade.xsl"
xmlns:common="http://exslt.org/common"
exclude-result-prefixes="fpml common lcl"
version="1.0">
<xsl:import href="swdml-extract-reporting.xsl"/>
<xsl:output method="xml"/>
<xsl:variable name="SWDML"                     select="/fpml:SWDML"/>
<xsl:variable name="version"                   select="$SWDML/@version"/>
<xsl:variable name="swLongFormTrade"           select="$SWDML/fpml:swLongFormTrade"/>
<xsl:variable name="ReplacementTradeId"        select="$swLongFormTrade/fpml:swReplacementTradeId"/>
<xsl:variable name="swShortFormTrade"          select="$SWDML/fpml:swShortFormTrade"/>
<xsl:variable name="novation"                  select="$swLongFormTrade/fpml:novation"/>
<xsl:variable name="swGiveUp"                  select="$swLongFormTrade/fpml:swGiveUp"/>
<xsl:variable name="swStructuredTradeDetails"  select="$swLongFormTrade/fpml:swStructuredTradeDetails"/>
<xsl:variable name="swTradeEventReportingDetails" select="$SWDML/fpml:swTradeEventReportingDetails"/>
<xsl:variable name="FpML"                      select="$swStructuredTradeDetails/fpml:FpML"/>
<xsl:variable name="swOfflineTrade"            select="$swStructuredTradeDetails/fpml:swOfflineTrade"/>
<xsl:variable name="swMidMarketPrice"          select="$swStructuredTradeDetails/fpml:swBusinessConductDetails/fpml:swMidMarketPrice"/>
<xsl:variable name="novMidMarketPrice"         select="$novation/fpml:swBusinessConductDetails/fpml:swMidMarketPrice"/>
<xsl:variable name="swExtendedTradeDetails"    select="$swStructuredTradeDetails/fpml:swExtendedTradeDetails"/>
<xsl:variable name="swOrderDetails"    select="$swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swOrderDetails"/>
<xsl:variable name="swOutsideNovation"         select="$swExtendedTradeDetails/fpml:swOutsideNovation"/>
<xsl:variable name="swAssociatedBonds"         select="$swShortFormTrade/fpml:swIrsParameters/fpml:swAssociatedBonds |
$swShortFormTrade/fpml:swOisParameters/fpml:swAssociatedBonds |
$swShortFormTrade/fpml:swFixedFixedParameters/fpml:swAssociatedBonds |
$swExtendedTradeDetails/fpml:swAssociatedBonds"/>
<xsl:variable name="swBondDetails"             select="$swAssociatedBonds/fpml:swBondDetails"/>
<xsl:variable name="swTradeHeader"             select="$swExtendedTradeDetails/fpml:swTradeHeader"/>
<xsl:variable name="swAssociatedTrades"        select="$swTradeHeader/fpml:swAssociatedTrades"/>
<xsl:variable name="swClearingTakeup"          select="$swTradeHeader/fpml:swClearingTakeup"/>
<xsl:variable name="swSettlementAgent"         select="$swExtendedTradeDetails/fpml:swSettlementAgent"/>
<xsl:variable name="swMandatoryClearing"       select="$swTradeHeader/fpml:swMandatoryClearing"/>
<xsl:variable name="swMandatoryClearingDF"     select="$swMandatoryClearing[fpml:swJurisdiction='DoddFrank']"/>
<xsl:variable name="swMandatoryClearingNewNovatedTrade" select="$novation/fpml:swMandatoryClearingNewNovatedTrade"/>
<xsl:variable name="swMandatoryClearingNewNovatedTradeDF" select="$swMandatoryClearingNewNovatedTrade[fpml:swJurisdiction='DoddFrank']"/>
<xsl:variable name="swMandatoryClearingNewNovatedTradeES" select="$swMandatoryClearingNewNovatedTrade[fpml:swJurisdiction='ESMA']"/>
<xsl:variable name="swMandatoryClearingNewNovatedTradeAS" select="$swMandatoryClearingNewNovatedTrade[fpml:swJurisdiction='ASIC']"/>
<xsl:variable name="swMandatoryClearingNewNovatedTradeMS" select="$swMandatoryClearingNewNovatedTrade[fpml:swJurisdiction='MAS']"/>
<xsl:variable name="trade"                     select="$FpML/fpml:trade"/>
<xsl:variable name="capFloor"                  select="$trade/fpml:capFloor"/>
<xsl:variable name="fra"                       select="$trade/fpml:fra"/>
<xsl:variable name="swaption"                  select="$trade/fpml:swaption"/>
<xsl:variable name="swap"                      select="$trade/fpml:swap | $swaption/fpml:swap"/>
<xsl:variable name="product"                   select="$fra | $capFloor | $swap | $swaption"/>
<xsl:variable name="capFloorStream"            select="$capFloor/fpml:capFloorStream"/>
<xsl:variable name="earlyTerminationProvision" select="$capFloor/fpml:earlyTerminationProvision | $swap/fpml:earlyTerminationProvision"/>
<xsl:variable name="swapStream"                select="$swap/fpml:swapStream"/>
<xsl:variable name="apiBatchId" select="/.."/>
<xsl:variable name="nettingBatchId" select="/.."/>
<xsl:variable name="privateClearingTradeID" select="/.."/>
<xsl:variable name="linkTradeID" select="/.."/>
<xsl:variable name="linkCCPID" select="/.."/>
<xsl:variable name="bulkEventID" select="/.."/>
<xsl:variable name="nettingString" select="/.."/>
<xsl:variable name="swLinkedTradeDetails" select="/.."/>
<xsl:variable name="swHeader" select="/.."/>
<lcl:true>true</lcl:true>
<xsl:variable name="true" select="document('')/xsl:stylesheet/lcl:true"/>
<lcl:false>false</lcl:false>
<xsl:variable name="false" select="document('')/xsl:stylesheet/lcl:false"/>
<xsl:variable name="isNettingInstruction">
<xsl:choose>
<xsl:when test="fpml:NettingInstruction/fpml:swHeader/fpml:swNettingBatchId">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="clearingTakeupSentBy">
<xsl:choose>
<xsl:when test="$swClearingTakeup/fpml:swSentBy">
<xsl:value-of select="$swClearingTakeup/fpml:swSentBy"/>
</xsl:when>
<xsl:otherwise>NONE</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="isClearingTakeup">
<xsl:choose>
<xsl:when test="$clearingTakeupSentBy = 'LCHTAKEUP'">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="reportingData.rtf">
<xsl:apply-templates select="$swTradeEventReportingDetails/node()" mode="mapReportingData"/>
<productType><xsl:value-of select="string($swStructuredTradeDetails/fpml:swProductType)"/></productType>
<partyRoles>
<transferor><xsl:value-of select="$novation/fpml:transferor/@href"/></transferor>
<transferee><xsl:value-of select="$novation/fpml:transferee/@href"/></transferee>
<remainingParty><xsl:value-of select="$novation/fpml:remainingParty/@href"/></remainingParty>
<otherRemainingParty><xsl:value-of select="$novation/fpml:otherRemainingParty/@href"/></otherRemainingParty>
<primeBrokerA><xsl:value-of select="$swGiveUp/fpml:swInterDealerTransaction/fpml:swPrimeBroker/@href"/></primeBrokerA>
<primeBrokerB><xsl:value-of select="$swGiveUp/fpml:swCustomerTransaction/fpml:swPrimeBroker/@href"/></primeBrokerB>
</partyRoles>
<xsl:if test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:party[@id = 'branch1']/fpml:partyId">
<branch1prefix><xsl:value-of select="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:party[@id = 'branch1']/fpml:partyId/@partyIdScheme"/></branch1prefix>
</xsl:if>
<xsl:if test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:party[@id = 'branch1']/fpml:partyId">
<branch1><xsl:value-of select="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:party[@id = 'branch1']/fpml:partyId"/></branch1>
</xsl:if>
<xsl:if test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:party[@id = 'branch2']/fpml:partyId">
<branch2prefix><xsl:value-of select="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:party[@id = 'branch2']/fpml:partyId/@partyIdScheme"/></branch2prefix>
</xsl:if>
<xsl:if test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:party[@id = 'branch2']/fpml:partyId">
<branch2><xsl:value-of select="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:party[@id = 'branch2']/fpml:partyId"/></branch2>
</xsl:if>
<xsl:if test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:party[@id = 'indirectCounterparty1']/fpml:partyId">
<indirCpty1prefix><xsl:value-of select="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:party[@id = 'indirectCounterparty1']/fpml:partyId/@partyIdScheme"/></indirCpty1prefix>
</xsl:if>
<xsl:if test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:party[@id = 'indirectCounterparty1']/fpml:partyId">
<indirCpty1><xsl:value-of select="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:party[@id = 'indirectCounterparty1']/fpml:partyId"/></indirCpty1>
</xsl:if>
<xsl:if test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:party[@id = 'indirectCounterparty2']/fpml:partyId">
<indirCpty2prefix><xsl:value-of select="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:party[@id = 'indirectCounterparty2']/fpml:partyId/@partyIdScheme"/></indirCpty2prefix>
</xsl:if>
<xsl:if test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:party[@id = 'indirectCounterparty2']/fpml:partyId">
<indirCpty2><xsl:value-of select="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:party[@id = 'indirectCounterparty2']/fpml:partyId"/></indirCpty2>
</xsl:if>
<xsl:if test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:party[@id = 'arrangingBroker1']/fpml:partyId">
<arrangingBroker1prefix><xsl:value-of select="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:party[@id = 'arrangingBroker1']/fpml:partyId/@partyIdScheme"/></arrangingBroker1prefix>
</xsl:if>
<xsl:if test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:party[@id = 'arrangingBroker1']/fpml:partyId">
<arrangingBroker1><xsl:value-of select="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:party[@id = 'arrangingBroker1']/fpml:partyId"/></arrangingBroker1>
</xsl:if>
<xsl:if test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:party[@id = 'arrangingBroker2']/fpml:partyId">
<arrangingBroker2prefix><xsl:value-of select="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:party[@id = 'arrangingBroker2']/fpml:partyId/@partyIdScheme"/></arrangingBroker2prefix>
</xsl:if>
<xsl:if test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:party[@id = 'arrangingBroker2']/fpml:partyId">
<arrangingBroker2><xsl:value-of select="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:party[@id = 'arrangingBroker2']/fpml:partyId"/></arrangingBroker2>
</xsl:if>
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
<xsl:apply-templates select="*" mode="get-reporting-data"/>
</xsl:template>
<xsl:template match="/*[function-available('common:node-set')]" mode="get-reporting-data">
<xsl:apply-templates select=".">
<xsl:with-param name="reportingData" select="common:node-set($reportingData.rtf)"/>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="/*[not(function-available('common:node-set'))]" mode="get-reporting-data">
<xsl:apply-templates select=".">
<xsl:with-param name="reportingData" select="$reportingData.rtf"/>
</xsl:apply-templates>
</xsl:template>
<xsl:variable name="productType">
<xsl:choose>
<xsl:when test="$swShortFormTrade">
<xsl:choose>
<xsl:when test="$swShortFormTrade//fpml:swCapFloorParameters">CapFloor</xsl:when>
<xsl:when test="$swShortFormTrade//fpml:swFraParameters">FRA</xsl:when>
<xsl:when test="$swShortFormTrade//fpml:swOisParameters">OIS</xsl:when>
<xsl:when test="$swShortFormTrade//fpml:swIrsParameters">IRS</xsl:when>
<xsl:when test="$swShortFormTrade//fpml:swCrossCurrencyIrsParameters">Cross Currency IRS</xsl:when>
<xsl:when test="$swShortFormTrade//fpml:swSwaptionParameters">Swaption</xsl:when>
<xsl:when test="$swShortFormTrade//fpml:swZCInflationSwapParameters">ZCInflationSwap</xsl:when>
<xsl:when test="$swShortFormTrade//fpml:swBasisSwapParameters">Single Currency Basis Swap</xsl:when>
<xsl:when test="$swShortFormTrade//fpml:swCrossCurrencyBasisSwapParameters">Cross Currency Basis Swap</xsl:when>
<xsl:when test="$swShortFormTrade//fpml:swFixedFixedParameters">Fixed Fixed Swap</xsl:when>
<xsl:otherwise>???</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$swLongFormTrade">
<xsl:choose>
<xsl:when test="$swStructuredTradeDetails[fpml:swProductType='SingleCurrencyInterestRateSwap']">IRS</xsl:when>
<xsl:when test="$swStructuredTradeDetails[fpml:swProductType='ZC Inflation Swap']">ZCInflationSwap</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$swStructuredTradeDetails/fpml:swProductType"/>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
</xsl:choose>
</xsl:variable>
<xsl:variable name="floatingLeg">
<xsl:choose>
<xsl:when test="$swapStream[1][@id='floatingLeg']">1</xsl:when>
<xsl:when test="$swapStream[1]/fpml:calculationPeriodAmount/fpml:calculation/fpml:inflationRateCalculation/fpml:inflationLag">1</xsl:when>
<xsl:when test="$swShortFormTrade/fpml:swBasisSwapParameters/fpml:swFloatingRateCalculation[1][@id!='floatingLeg2']">1</xsl:when>
<xsl:when test="$swShortFormTrade/fpml:swCrossCurrencyBasisSwapParameters/fpml:swFloatingRateCalculation[1][@id!='floatingLeg2']">1</xsl:when>
<xsl:otherwise>2</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="floatingStream" select="$swapStream[position() = $floatingLeg]"/>
<xsl:variable name="floatingLegId">
<xsl:choose>
<xsl:when test="$trade">
<xsl:value-of select="$floatingStream/@id"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$swOfflineTrade/fpml:swLegDetails[position()=$offlinefloatingLeg]/@id"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="fixedLeg">
<xsl:choose>
<xsl:when test="$productType = 'Single Currency Basis Swap' or $productType = 'Cross Currency Basis Swap'"/>
<xsl:when test="$swapStream[1]/fpml:resetDates or $swapStream[1]/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:calculationMethod">2</xsl:when>
<xsl:when test="$swapStream[1]/fpml:calculationPeriodAmount/fpml:calculation/fpml:inflationRateCalculation/fpml:inflationLag">2</xsl:when>
<xsl:otherwise>1</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="fixedStream" select="$swapStream[position()=$fixedLeg]"/>
<xsl:variable name="offlinefixedLeg">
<xsl:if test="$productType='Offline Trade Rates'">
<xsl:choose>
<xsl:when test="$swOfflineTrade/fpml:swLegDetails[1][@id='fixedLeg']">1</xsl:when>
<xsl:otherwise>0</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:variable>
<xsl:variable name="fixedLegId">
<xsl:choose>
<xsl:when test="$trade">
<xsl:value-of select="$fixedStream/@id"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$swOfflineTrade/fpml:swLegDetails[position()=$offlinefixedLeg]/@id"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="offlinefixedLeg2">
<xsl:if test="$productType='Offline Trade Rates'">
<xsl:choose>
<xsl:when test="$swOfflineTrade/fpml:swLegDetails[2][@id='fixedLeg2']">2</xsl:when>
<xsl:when test="$swOfflineTrade/fpml:swLegDetails[2][@id='fixedLeg']">2</xsl:when>
<xsl:otherwise>0</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:variable>
<xsl:variable name="fixedLegId2">
<xsl:choose>
<xsl:when test="$trade">
<xsl:value-of select="$fixedStream2/@id"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$swOfflineTrade/fpml:swLegDetails[position()=$offlinefixedLeg2]/@id"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="floatingLeg2">
<xsl:choose>
<xsl:when test="$productType != 'Single Currency Basis Swap' and $productType != 'Cross Currency Basis Swap'"/>
<xsl:when test="$swapStream[1][@id='floatingLeg2']">1</xsl:when>
<xsl:when test="$swShortFormTrade/fpml:swBasisSwapParameters/fpml:swFloatingRateCalculation[1][@id='floatingLeg2']">1</xsl:when>
<xsl:when test="$swShortFormTrade/fpml:swCrossCurrencyBasisSwapParameters/fpml:swFloatingRateCalculation[1][@id='floatingLeg2']">1</xsl:when>
<xsl:otherwise>2</xsl:otherwise>
</xsl:choose>
<xsl:if test="$productType='Cross Currency IRS'">
<xsl:value-of select="$floatingLeg"/>
</xsl:if>
</xsl:variable>
<xsl:variable name="fixedLeg2">
<xsl:choose>
<xsl:when test="$productType != 'Fixed Fixed Swap'"/>
<xsl:when test="$swapStream[1][@id='fixedLeg2']">2</xsl:when>
<xsl:otherwise>2</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="fixedStream2" select="$swapStream[position()=$fixedLeg2]"/>
<xsl:variable name="offlinefloatingLeg">
<xsl:if test="$productType='Offline Trade Rates'">
<xsl:choose>
<xsl:when test="$swOfflineTrade/fpml:swLegDetails[1][@id='floatingLeg']">1</xsl:when>
<xsl:otherwise>0</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:variable>
<xsl:variable name="offlinefloatingLeg2">
<xsl:if test="$productType='Offline Trade Rates'">
<xsl:choose>
<xsl:when test="$swOfflineTrade/fpml:swLegDetails[2][@id='floatingLeg2']">2</xsl:when>
<xsl:when test="$swOfflineTrade/fpml:swLegDetails[2][@id='floatingLeg']">2</xsl:when>
<xsl:otherwise>0</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:variable>
<xsl:variable name="floatingStream2" select="$swapStream[position()=$floatingLeg2]"/>
<xsl:variable name="floatingLegId2">
<xsl:choose>
<xsl:when test="$trade">
<xsl:value-of select="$floatingStream2/@id"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$swOfflineTrade/fpml:swLegDetails[position()=$offlinefloatingLeg2]/@id"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="currency">
<xsl:choose>
<xsl:when test="$productType='IRS' or $productType='OIS' or $productType='ZCInflationSwap' or $productType='Swaption' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap'">
<xsl:value-of select="$swShortFormTrade//fpml:notional/fpml:currency"/>
<xsl:value-of select="$floatingStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:currency"/>
</xsl:when>
<xsl:when test="$productType='FRA'">
<xsl:value-of select="$swShortFormTrade//fpml:swFraParameters/fpml:notional/fpml:currency"/>
<xsl:value-of select="$fra/fpml:notional/fpml:currency"/>
</xsl:when>
<xsl:when test="$productType='CapFloor'">
<xsl:value-of select="$swShortFormTrade//fpml:notional/fpml:currency"/>
<xsl:value-of select="$capFloorStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:currency"/>
</xsl:when>
<xsl:when test="$productType='Offline Trade Rates'">
<xsl:value-of select="$swOfflineTrade/fpml:swLegDetails[1]/fpml:notional/fpml:currency"/>
</xsl:when>
<xsl:when test="$productType='Cross Currency IRS'">
<xsl:value-of select="$fixedStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:currency"/>
<xsl:value-of select="$swShortFormTrade//fpml:notional/fpml:currency"/>
</xsl:when>
<xsl:when test="$productType='Fixed Fixed Swap'">
<xsl:choose>
<xsl:when test="$fixedStream/fpml:calculationPeriodAmount/fpml:knownAmountSchedule">
<xsl:value-of select="$fixedStream/fpml:calculationPeriodAmount/fpml:knownAmountSchedule/fpml:currency"/>
</xsl:when>
<xsl:when test="$swShortFormTrade">
<xsl:value-of select="$swShortFormTrade//fpml:notional/fpml:currency"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$fixedStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:currency"/>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
</xsl:choose>
</xsl:variable>
<xsl:variable name="partyA">
<xsl:choose>
<xsl:when test="$novation">
<xsl:value-of select="$SWDML//fpml:transferor/@href"/>
</xsl:when>
<xsl:when test="starts-with($SWDML//fpml:swOriginatorPartyReference/@href,'#')">
<xsl:value-of select="substring-after($SWDML//fpml:swOriginatorPartyReference/@href,'#')"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$SWDML//fpml:swOriginatorPartyReference/@href"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="partyB">
<xsl:choose>
<xsl:when test="($swLongFormTrade//fpml:swAllocations or $swGiveUp)">
<xsl:for-each select="$trade//fpml:tradeHeader/fpml:partyTradeIdentifier">
<xsl:variable name="party">
<xsl:choose>
<xsl:when test="starts-with(/fpml:partyReference/@href,'#')">
<xsl:value-of select="substring-after(/fpml:partyReference/@href,'#')"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="fpml:partyReference/@href"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:if test="$party!=$partyA">
<xsl:value-of select="$party"/>
</xsl:if>
</xsl:for-each>
</xsl:when>
<xsl:when test="$novation">
<xsl:value-of select="$SWDML//fpml:transferee/@href"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$swShortFormTrade//fpml:party[@id!=$partyA]/@id"/>
<xsl:value-of select="$FpML//fpml:party[@id!=$partyA]/@id"/>
<xsl:value-of select="$swOfflineTrade//fpml:party[@id!=$partyA]/@id"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="partyC">
<xsl:choose>
<xsl:when test="$swGiveUp">
<xsl:choose>
<xsl:when test="starts-with($SWDML//fpml:swInterDealerTransaction/fpml:swPrimeBroker/@href,'#')">
<xsl:value-of select="substring-after($SWDML//fpml:swInterDealerTransaction/fpml:swPrimeBroker/@href,'#')"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$SWDML//fpml:swInterDealerTransaction/fpml:swPrimeBroker/@href"/>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$novation">
<xsl:value-of select="$SWDML//fpml:remainingParty/@href"/>
</xsl:when>
</xsl:choose>
</xsl:variable>
<xsl:variable name="partyD">
<xsl:choose>
<xsl:when test="$swGiveUp">
<xsl:choose>
<xsl:when test="starts-with($SWDML//fpml:swCustomerTransaction/fpml:swPrimeBroker/@href,'#')">
<xsl:value-of select="substring-after($SWDML/fpml:swCustomerTransaction/fpml:swPrimeBroker/@href,'#')"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$SWDML//fpml:swCustomerTransaction/fpml:swPrimeBroker/@href"/>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$novation">
<xsl:value-of select="$SWDML//fpml:otherRemainingParty/@href"/>
</xsl:when>
</xsl:choose>
</xsl:variable>
<xsl:variable name="partyE">
<xsl:choose>
<xsl:when test="$novation/fpml:payment">
<xsl:choose>
<xsl:when test="$productType = 'Offline Trade Rates'">
<xsl:value-of select="$SWDML//fpml:novation/fpml:payment/fpml:receiverPartyReference/@href"/>
</xsl:when>
<xsl:otherwise>
<xsl:choose>
<xsl:when test="starts-with($SWDML//fpml:receiverPartyReference/@href,'#')">
<xsl:value-of select="substring-after($SWDML//fpml:receiverPartyReference/@href,'#')"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$SWDML//fpml:receiverPartyReference/@href"/>
</xsl:otherwise>
</xsl:choose>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$SWDML//fpml:receiverPartyReference/@href"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="partyF">
<xsl:choose>
<xsl:when test="$novation/fpml:payment">
<xsl:choose>
<xsl:when test="$productType = 'Offline Trade Rates'">
<xsl:value-of select="$SWDML//fpml:novation/fpml:payment/fpml:payerPartyReference/@href"/>
</xsl:when>
<xsl:otherwise>
<xsl:choose>
<xsl:when test="starts-with($SWDML//fpml:payerPartyReference/@href,'#')">
<xsl:value-of select="substring-after($SWDML//fpml:payerPartyReference/@href,'#')"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$SWDML//fpml:payerPartyReference/@href"/>
</xsl:otherwise>
</xsl:choose>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$SWDML//fpml:payerPartyReference/@href"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="partyG">
<xsl:if test="$swGiveUp">
<xsl:choose>
<xsl:when test="starts-with($SWDML//fpml:swExecutingDealerCustomerTransaction/fpml:swExecutingDealer/@href,'#')">
<xsl:value-of select="substring-after($SWDML/fpml:swExecutingDealerCustomerTransaction/fpml:swExecutingDealer/@href,'#')"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$SWDML//fpml:swExecutingDealerCustomerTransaction/fpml:swExecutingDealer/@href"/>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:variable>
<xsl:variable name="conditionPrecedentBondId">
<xsl:value-of select="$swShortFormTrade//fpml:additionalTerms/fpml:conditionPrecedentBond/fpml:instrumentId"/>
<xsl:value-of select="$swap/fpml:additionalTerms/fpml:bondReference/fpml:bond/fpml:instrumentId"/>
</xsl:variable>
<xsl:template match="/*">
<xsl:param name="reportingData"/>
<xsl:variable name="referenceCurrency">
<xsl:if test="$productType='IRS' or $productType='OIS' or $productType='Swaption' or $productType='Fixed Fixed Swap'">
<xsl:choose>
<xsl:when test="$swShortFormTrade//fpml:swSettlementProvision/fpml:swNonDeliverableSettlement/fpml:swReferenceCurrency">
<xsl:value-of select="$swShortFormTrade//fpml:swSettlementProvision/fpml:swNonDeliverableSettlement/fpml:swReferenceCurrency"/>
</xsl:when>
<xsl:when test="$swapStream/fpml:settlementProvision/fpml:nonDeliverableSettlement/fpml:referenceCurrency">
<xsl:value-of select="$swapStream/fpml:settlementProvision/fpml:nonDeliverableSettlement/fpml:referenceCurrency"/>
</xsl:when>
<xsl:when test="$swExtendedTradeDetails/fpml:swSettlementProvision/fpml:swNonDeliverableSettlement/fpml:swReferenceCurrency">
<xsl:value-of select="$swExtendedTradeDetails/fpml:swSettlementProvision/fpml:swNonDeliverableSettlement/fpml:swReferenceCurrency"/>
</xsl:when>
</xsl:choose>
</xsl:if>
</xsl:variable>
<SWDMLTrade version="4-2">
<SWDMLVersion>
<xsl:value-of select="$version"/>
</SWDMLVersion>
<ReplacementTradeId>
<xsl:value-of select="$ReplacementTradeId/fpml:swTradeId"/>
</ReplacementTradeId>
<ReplacementTradeIdType>
<xsl:value-of select="$ReplacementTradeId/fpml:swTradeIdType"/>
</ReplacementTradeIdType>
<ReplacementReason>
<xsl:value-of select="$ReplacementTradeId/fpml:swReplacementReason"/>
</ReplacementReason>
<ShortFormInput>
<xsl:choose>
<xsl:when test="$swShortFormTrade">true</xsl:when>
<xsl:when test="$swLongFormTrade">false</xsl:when>
<xsl:otherwise>???</xsl:otherwise>
</xsl:choose>
</ShortFormInput>
<ProductType>
<xsl:choose>
<xsl:when test="$productType='IRS'">Single Currency Interest Rate Swap</xsl:when>
<xsl:when test="$productType='ZCInflationSwap'">ZC Inflation Swap</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$productType"/>
</xsl:otherwise>
</xsl:choose>
</ProductType>
<ProductSubType>
<xsl:if test="$swShortFormTrade and $productType='IRS'">
<xsl:value-of select="$swShortFormTrade//fpml:swIrsParameters/fpml:swProductSubType"/>
</xsl:if>
<xsl:if test="$swShortFormTrade and $productType='OIS'">
<xsl:value-of select="$swShortFormTrade//fpml:swOisParameters/fpml:swProductSubType"/>
</xsl:if>
<xsl:if test="$swShortFormTrade and $productType='Fixed Fixed Swap'">
<xsl:value-of select="$swShortFormTrade//fpml:swFixedFixedParameters/fpml:swProductSubType"/>
</xsl:if>
</ProductSubType>
<ParticipantSupplement>
<xsl:if test="$swStructuredTradeDetails/fpml:swParticipantSupplement">
<xsl:value-of select="$swStructuredTradeDetails/fpml:swParticipantSupplement"/>
</xsl:if>
<xsl:if test="$swShortFormTrade//fpml:swParticipantSupplement">
<xsl:value-of select="$swShortFormTrade//fpml:swParticipantSupplement"/>
</xsl:if>
</ParticipantSupplement>
<ConditionPrecedentBondId>
<xsl:value-of select="$conditionPrecedentBondId"/>
</ConditionPrecedentBondId>
<ConditionPrecedentBondMaturity>
<xsl:variable name="bondMaturityDate">
<xsl:value-of select="$swShortFormTrade//fpml:additionalTerms/fpml:conditionPrecedentBond/fpml:maturity"/>
<xsl:value-of select="$swap/fpml:additionalTerms/fpml:bondReference/fpml:bond/fpml:maturity"/>
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
<xsl:value-of select="$swap/fpml:additionalTerms/fpml:bondReference/fpml:conditionPrecedentBond"/>
</ConditionPrecedentBond>
<DiscrepancyClause>
<xsl:value-of select="$swap/fpml:additionalTerms/fpml:bondReference/fpml:discrepancyClause"/>
</DiscrepancyClause>
<AllocatedTrade>
<xsl:value-of select="string(boolean($swLongFormTrade//fpml:swAllocations))"/>
</AllocatedTrade>
<xsl:if test="$swLongFormTrade//fpml:swAllocations">
<xsl:call-template name="fpml:swAllocations"/>
</xsl:if>
<PrimeBrokerTrade>
<xsl:value-of select="string(boolean($swGiveUp))"/>
</PrimeBrokerTrade>
<ReversePrimeBrokerLegalEntities>
<xsl:if test="$swGiveUp">
<xsl:choose>
<xsl:when test="starts-with($SWDML//fpml:swCustomerTransaction/fpml:swCustomer/@href,'#')">
<xsl:value-of select="string(boolean($SWDML//fpml:swCustomerTransaction/fpml:swCustomer/@href=string($partyA)))"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="string(boolean(string($SWDML//fpml:swCustomerTransaction/fpml:swCustomer/@href)=string($partyA)))"/>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</ReversePrimeBrokerLegalEntities>
<PartyAId>
<xsl:if test="($swGiveUp or $novation)">
<xsl:attribute name="id"><xsl:value-of select="$partyA"/></xsl:attribute>
</xsl:if>
<xsl:value-of select="$swShortFormTrade//fpml:party[@id=$partyA]/fpml:partyId"/>
<xsl:value-of select="$FpML/fpml:party[@id=$partyA]/fpml:partyId"/>
<xsl:value-of select="$swOfflineTrade/fpml:party[@id=$partyA]/fpml:partyId"/>
</PartyAId>
<PartyAIdType>
<xsl:value-of select="$FpML/fpml:party[@id=$partyA]/fpml:partyId/@partyIdScheme"/>
<xsl:value-of select="$swOfflineTrade/fpml:party[@id=$partyA]/fpml:partyId/@partyIdScheme"/>
</PartyAIdType>
<PartyBId>
<xsl:if test="($swGiveUp or $novation)">
<xsl:attribute name="id"><xsl:value-of select="$partyB"/></xsl:attribute>
</xsl:if>
<xsl:value-of select="$swShortFormTrade//fpml:party[@id=$partyB]/fpml:partyId"/>
<xsl:value-of select="$FpML/fpml:party[@id=$partyB]/fpml:partyId"/>
<xsl:value-of select="$swOfflineTrade/fpml:party[@id=$partyB]/fpml:partyId"/>
</PartyBId>
<PartyBIdType>
<xsl:value-of select="$FpML/fpml:party[@id=$partyB]/fpml:partyId/@partyIdScheme"/>
<xsl:value-of select="$swOfflineTrade/fpml:party[@id=$partyB]/fpml:partyId/@partyIdScheme"/>
</PartyBIdType>
<PartyCId>
<xsl:if test="($swGiveUp or $novation)">
<xsl:attribute name="id"><xsl:value-of select="$partyC"/></xsl:attribute>
<xsl:value-of select="$swShortFormTrade//fpml:party[@id=$partyC]/fpml:partyId"/>
<xsl:value-of select="$FpML/fpml:party[@id=$partyC]/fpml:partyId"/>
<xsl:value-of select="$swOfflineTrade/fpml:party[@id=$partyC]/fpml:partyId"/>
</xsl:if>
</PartyCId>
<PartyCIdType>
<xsl:if test="($swGiveUp or $novation)">
<xsl:value-of select="$FpML/fpml:party[@id=$partyC]/fpml:partyId/@partyIdScheme"/>
<xsl:value-of select="$swOfflineTrade/fpml:party[@id=$partyC]/fpml:partyId/@partyIdScheme"/>
</xsl:if>
</PartyCIdType>
<PartyDId>
<xsl:if test="($swGiveUp or $novation)">
<xsl:if test="$partyD!=''">
<xsl:attribute name="id"><xsl:value-of select="$partyD"/></xsl:attribute>
<xsl:value-of select="$swShortFormTrade//fpml:party[@id=$partyD]/fpml:partyId"/>
<xsl:value-of select="$FpML/fpml:party[@id=$partyD]/fpml:partyId"/>
<xsl:value-of select="$swOfflineTrade/fpml:party[@id=$partyD]/fpml:partyId"/>
</xsl:if>
</xsl:if>
</PartyDId>
<PartyDIdType>
<xsl:if test="($swGiveUp or $novation)">
<xsl:value-of select="$FpML/fpml:party[@id=$partyD]/fpml:partyId/@partyIdScheme"/>
<xsl:value-of select="$swOfflineTrade/fpml:party[@id=$partyD]/fpml:partyId/@partyIdScheme"/>
</xsl:if>
</PartyDIdType>
<PartyGId>
<xsl:if test="$swGiveUp">
<xsl:if test="$partyG!=''">
<xsl:attribute name="id"><xsl:value-of select="$partyG"/></xsl:attribute>
<xsl:value-of select="$FpML/fpml:party[@id=$partyG]/fpml:partyId"/>
</xsl:if>
</xsl:if>
</PartyGId>
<PartyGIdType>
<xsl:if test="$swGiveUp">
<xsl:value-of select="$FpML/fpml:party[@id=$partyG]/fpml:partyId/@partyIdScheme"/>
</xsl:if>
</PartyGIdType>
<Interoperable>
<xsl:if test="$productType='IRS' or $productType='Swaption'">
<xsl:value-of select="$swTradeHeader/fpml:swInteroperable"/>
</xsl:if>
</Interoperable>
<ExternalInteropabilityId>
<xsl:value-of select="$swTradeHeader/fpml:swExternalInteropabilityId"/>
</ExternalInteropabilityId>
<InteropNettingString>
<xsl:value-of select="$swTradeHeader/fpml:swInteropNettingString"/>
</InteropNettingString>
<DirectionA>
<xsl:choose>
<xsl:when test="$productType='CapFloor'">
<xsl:variable name="buyer">
<xsl:value-of select="$swShortFormTrade//fpml:swFixedAmounts/fpml:receiverPartyReference/@href"/>
<xsl:value-of select="$capFloorStream/fpml:receiverPartyReference/@href"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="string($buyer)=string($partyA)">Buy</xsl:when>
<xsl:otherwise>Sell</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType='IRS' or $productType='ZCInflationSwap' or $productType='OIS' or $productType='Cross Currency IRS' or $productType='Fixed Fixed Swap'">
<xsl:variable name="fixedPayer">
<xsl:value-of select="$swShortFormTrade//fpml:swFixedAmounts/fpml:payerPartyReference/@href"/>
<xsl:value-of select="$fixedStream/fpml:payerPartyReference/@href"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$fixedPayer=string($partyA)">Pay</xsl:when>
<xsl:otherwise>Rec</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType='Swaption'">
<xsl:variable name="buyer">
<xsl:value-of select="$swShortFormTrade//fpml:swSwaptionParameters/fpml:buyerPartyReference/@href"/>
<xsl:value-of select="$swaption/fpml:buyerPartyReference/@href"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="string($buyer)=string($partyA)">Buy</xsl:when>
<xsl:otherwise>Sell</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType='FRA'">
<xsl:variable name="buyer">
<xsl:value-of select="$swShortFormTrade//fpml:swFraParameters/fpml:buyerPartyReference/@href"/>
<xsl:value-of select="$fra/fpml:buyerPartyReference/@href"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="string($buyer)=string($partyA)">Buy</xsl:when>
<xsl:otherwise>Sell</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType='Cross Currency Basis Swap'">
<xsl:variable name="floatingRatePayer">
<xsl:value-of select="$swShortFormTrade/fpml:swCrossCurrencyBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg]/fpml:payerPartyReference/@href"/>
<xsl:value-of select="$floatingStream/fpml:payerPartyReference/@href"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$floatingRatePayer=string($partyA)">Pay</xsl:when>
<xsl:otherwise>Rec</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType='Single Currency Basis Swap'">
<xsl:variable name="floatingRatePayer">
<xsl:value-of select="$swShortFormTrade/fpml:swBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg]/fpml:payerPartyReference/@href"/>
<xsl:value-of select="$floatingStream/fpml:payerPartyReference/@href"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$floatingRatePayer=string($partyA)">Pay</xsl:when>
<xsl:otherwise>Rec</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType='Offline Trade Rates'">
<xsl:if test="$swOfflineTrade/fpml:swLegDetails/fpml:buyerPartyReference">
<xsl:variable name="buyer" select="string($swOfflineTrade/fpml:swLegDetails/fpml:buyerPartyReference/@href)"/>
<xsl:choose>
<xsl:when test="string($buyer)=string($partyA)">Buy</xsl:when>
<xsl:otherwise>Sell</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="$swOfflineTrade/fpml:swLegDetails/fpml:payerPartyReference">
<xsl:variable name="payer" select="string($swOfflineTrade/fpml:swLegDetails/fpml:payerPartyReference/@href)"/>
<xsl:choose>
<xsl:when test="string($payer)=string($partyA)">Pay</xsl:when>
<xsl:otherwise>Rec</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:when>
</xsl:choose>
</DirectionA>
<TradeDate>
<xsl:call-template name="formatDate">
<xsl:with-param name="date">
<xsl:value-of select="$swShortFormTrade//fpml:tradeDate"/>
<xsl:value-of select="$trade//fpml:tradeHeader/fpml:tradeDate"/>
<xsl:value-of select="$swOfflineTrade/fpml:swTradeDate"/>
</xsl:with-param>
</xsl:call-template>
</TradeDate>
<StartDateTenor>
<xsl:call-template name="formatInterval">
<xsl:with-param name="interval" select="$swShortFormTrade//fpml:swFraParameters/fpml:swEffectiveDateTenor"/>
</xsl:call-template>
</StartDateTenor>
<EndDateTenor>
<xsl:call-template name="formatInterval">
<xsl:with-param name="interval" select="$swShortFormTrade//fpml:swFraParameters/fpml:swTerminationDateTenor"/>
</xsl:call-template>
</EndDateTenor>
<StartDateDay>
<xsl:if test="$swShortFormTrade and $productType='FRA'">
<xsl:choose>
<xsl:when test="$swShortFormTrade//fpml:swFraParameters/fpml:rollConvention">
<xsl:value-of select="$swShortFormTrade//fpml:swFraParameters/fpml:rollConvention"/>
</xsl:when>
<xsl:otherwise>spot</xsl:otherwise>
</xsl:choose>
</xsl:if>
</StartDateDay>
<Tenor>
<xsl:if test="$productType='IRS'  or $productType='OIS' or $productType='ZCInflationSwap' or $productType='Swaption' or $productType='Single Currency Basis Swap' or $productType='CapFloor' or $productType='Cross Currency Basis Swap' or $productType='Offline Trade Rates' or $productType='Cross Currency IRS' or $productType='Fixed Fixed Swap'">
<xsl:choose>
<xsl:when test="$swShortFormTrade">
<xsl:call-template name="formatInterval">
<xsl:with-param name="interval" select="$swShortFormTrade//fpml:swSwapTermTenor"/>
</xsl:call-template>
</xsl:when>
<xsl:otherwise>
<xsl:call-template name="calculateTenor">
<xsl:with-param name="startDate">
<xsl:choose>
<xsl:when test="$productType='CapFloor'">
<xsl:value-of select="$capFloorStream/fpml:calculationPeriodDates/fpml:effectiveDate/fpml:unadjustedDate"/>
</xsl:when>
<xsl:when test="$productType='Offline Trade Rates'">
<xsl:value-of select="$swOfflineTrade/fpml:effectiveDate"/>
</xsl:when>
<xsl:when test="$productType='Fixed Fixed Swap'">
<xsl:value-of select="$fixedStream/fpml:calculationPeriodDates/fpml:effectiveDate/fpml:unadjustedDate"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$floatingStream/fpml:calculationPeriodDates/fpml:effectiveDate/fpml:unadjustedDate"/>
</xsl:otherwise>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="endDate">
<xsl:choose>
<xsl:when test="$productType='Fixed Fixed Swap'">
<xsl:value-of select="$fixedStream2/fpml:calculationPeriodDates/fpml:terminationDate/fpml:unadjustedDate"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$floatingStream/fpml:calculationPeriodDates/fpml:terminationDate/fpml:unadjustedDate"/>
<xsl:value-of select="$capFloorStream/fpml:calculationPeriodDates/fpml:terminationDate/fpml:unadjustedDate"/>
<xsl:value-of select="$swExtendedTradeDetails/fpml:swCapFloorDetails/fpml:swFloatingRateFixingDate/fpml:unadjustedDate"/>
<xsl:value-of select="$swOfflineTrade/fpml:terminationDate"/>
</xsl:otherwise>
</xsl:choose>
</xsl:with-param>
</xsl:call-template>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</Tenor>
<StartDate>
<xsl:variable name="startDate">
<xsl:choose>
<xsl:when test="$productType='IRS' or $productType='ZCInflationSwap' or $productType='Swaption' or $productType='Cross Currency IRS' or $productType='OIS'">
<xsl:variable name="fixedStartDate" select="string($fixedStream/fpml:calculationPeriodDates/fpml:effectiveDate/fpml:unadjustedDate)"/>
<xsl:variable name="floatStartDate" select="string($floatingStream/fpml:calculationPeriodDates/fpml:effectiveDate/fpml:unadjustedDate)"/>
<xsl:if test="$swLongFormTrade and ($fixedStartDate = $floatStartDate)">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string($floatingStream/fpml:calculationPeriodDates/fpml:effectiveDate/fpml:unadjustedDate)"/>
</xsl:call-template>
</xsl:if>
<xsl:if test="$swShortFormTrade//fpml:adjustedEffectiveDate">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string($swShortFormTrade//fpml:adjustedEffectiveDate)"/>
</xsl:call-template>
</xsl:if>
</xsl:when>
<xsl:when test="$productType='OIS'">
<xsl:if test="$swLongFormTrade or $swShortFormTrade//fpml:adjustedEffectiveDate">
<xsl:call-template name="formatDate">
<xsl:with-param name="date">
<xsl:value-of select="$swShortFormTrade//fpml:adjustedEffectiveDate"/>
<xsl:value-of select="$floatingStream/fpml:calculationPeriodDates/fpml:effectiveDate/fpml:unadjustedDate"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
</xsl:when>
<xsl:when test="$productType='FRA'">
<xsl:if test="$swLongFormTrade">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string($fra/fpml:adjustedEffectiveDate)"/>
</xsl:call-template>
</xsl:if>
</xsl:when>
<xsl:when test="$productType='CapFloor'">
<xsl:if test="$capFloorStream/fpml:calculationPeriodDates/fpml:effectiveDate/fpml:unadjustedDate">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string($capFloorStream/fpml:calculationPeriodDates/fpml:effectiveDate/fpml:unadjustedDate)"/>
</xsl:call-template>
</xsl:if>
<xsl:if test="$swShortFormTrade//fpml:adjustedEffectiveDate">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string($swShortFormTrade//fpml:adjustedEffectiveDate)"/>
</xsl:call-template>
</xsl:if>
</xsl:when>
<xsl:when test="$productType='Offline Trade Rates'">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string($swOfflineTrade/fpml:effectiveDate)"/>
</xsl:call-template>
</xsl:when>
<xsl:when test="$productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap'">
<xsl:variable name="floatingStartDate" select="string($floatingStream/fpml:calculationPeriodDates/fpml:effectiveDate/fpml:unadjustedDate)"/>
<xsl:variable name="floating2StartDate" select="string($floatingStream2/fpml:calculationPeriodDates/fpml:effectiveDate/fpml:unadjustedDate)"/>
<xsl:if test="$swLongFormTrade and ($floatingStartDate = $floating2StartDate)">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string($floatingStream/fpml:calculationPeriodDates/fpml:effectiveDate/fpml:unadjustedDate)"/>
</xsl:call-template>
</xsl:if>
<xsl:if test="$swShortFormTrade//fpml:adjustedEffectiveDate">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string($swShortFormTrade//fpml:adjustedEffectiveDate)"/>
</xsl:call-template>
</xsl:if>
</xsl:when>
<xsl:when test="$productType='Fixed Fixed Swap'">
<xsl:variable name="fixedStartDate" select="string($fixedStream/fpml:calculationPeriodDates/fpml:effectiveDate/fpml:unadjustedDate)"/>
<xsl:variable name="fixed2StartDate" select="string($fixedStream2/fpml:calculationPeriodDates/fpml:effectiveDate/fpml:unadjustedDate)"/>
<xsl:if test="$swLongFormTrade and ($fixedStartDate = $fixed2StartDate)">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string($fixedStream2/fpml:calculationPeriodDates/fpml:effectiveDate/fpml:unadjustedDate)"/>
</xsl:call-template>
</xsl:if>
<xsl:if test="$swShortFormTrade//fpml:adjustedEffectiveDate">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string($swShortFormTrade//fpml:adjustedEffectiveDate)"/>
</xsl:call-template>
</xsl:if>
</xsl:when>
</xsl:choose>
</xsl:variable>
<xsl:value-of select="$startDate"/>
</StartDate>
<FirstFixedPeriodStartDate>
<xsl:variable name="firstFixedPeriodStartDate">
<xsl:if test="$productType='IRS' or $productType='Swaption' or $productType='ZCInflationSwap' or $productType='Cross Currency IRS' or $productType='OIS'">
<xsl:variable name="fixedStartDate" select="string($fixedStream/fpml:calculationPeriodDates/fpml:effectiveDate/fpml:unadjustedDate)"/>
<xsl:variable name="floatStartDate" select="string($floatingStream/fpml:calculationPeriodDates/fpml:effectiveDate/fpml:unadjustedDate)"/>
<xsl:if test="$swLongFormTrade and ($fixedStartDate != $floatStartDate)">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string($fixedStream/fpml:calculationPeriodDates/fpml:effectiveDate/fpml:unadjustedDate)"/>
</xsl:call-template>
</xsl:if>
</xsl:if>
<xsl:if test="$productType='Fixed Fixed Swap'">
<xsl:variable name="fixedStartDate" select="string($fixedStream/fpml:calculationPeriodDates/fpml:effectiveDate/fpml:unadjustedDate)"/>
<xsl:variable name="fixed2StartDate" select="string($fixedStream2/fpml:calculationPeriodDates/fpml:effectiveDate/fpml:unadjustedDate)"/>
<xsl:if test="$swLongFormTrade and ($fixedStartDate != $fixed2StartDate)">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string($fixedStream/fpml:calculationPeriodDates/fpml:effectiveDate/fpml:unadjustedDate)"/>
</xsl:call-template>
</xsl:if>
</xsl:if>
</xsl:variable>
<xsl:value-of select="$firstFixedPeriodStartDate"/>
</FirstFixedPeriodStartDate>
<FirstFixedPeriodStartDate_2>
<xsl:variable name="firstFixedPeriodStartDate_2">
<xsl:if test="$productType='Fixed Fixed Swap'">
<xsl:variable name="fixedStartDate" select="string($fixedStream/fpml:calculationPeriodDates/fpml:effectiveDate/fpml:unadjustedDate)"/>
<xsl:variable name="fixed2StartDate" select="string($fixedStream2/fpml:calculationPeriodDates/fpml:effectiveDate/fpml:unadjustedDate)"/>
<xsl:if test="$swLongFormTrade and ($fixedStartDate != $fixed2StartDate)">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string($fixedStream2/fpml:calculationPeriodDates/fpml:effectiveDate/fpml:unadjustedDate)"/>
</xsl:call-template>
</xsl:if>
</xsl:if>
</xsl:variable>
<xsl:value-of select="$firstFixedPeriodStartDate_2"/>
</FirstFixedPeriodStartDate_2>
<FirstFloatPeriodStartDate>
<xsl:variable name="firstFloatPeriodStartDate">
<xsl:choose>
<xsl:when test="$productType='IRS' or $productType='Swaption' or $productType='ZCInflationSwap' or $productType='OIS'">
<xsl:variable name="fixedStartDate" select="string($fixedStream/fpml:calculationPeriodDates/fpml:effectiveDate/fpml:unadjustedDate)"/>
<xsl:variable name="floatStartDate" select="string($floatingStream/fpml:calculationPeriodDates/fpml:effectiveDate/fpml:unadjustedDate)"/>
<xsl:if test="$swLongFormTrade and ($fixedStartDate != $floatStartDate)">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string($floatingStream/fpml:calculationPeriodDates/fpml:effectiveDate/fpml:unadjustedDate)"/>
</xsl:call-template>
</xsl:if>
</xsl:when>
<xsl:when test="$productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap'">
<xsl:variable name="floatingStartDate" select="string($floatingStream/fpml:calculationPeriodDates/fpml:effectiveDate/fpml:unadjustedDate)"/>
<xsl:variable name="floating2StartDate" select="string($floatingStream2/fpml:calculationPeriodDates/fpml:effectiveDate/fpml:unadjustedDate)"/>
<xsl:if test="$swLongFormTrade and ($floatingStartDate != $floating2StartDate)">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string($floatingStream/fpml:calculationPeriodDates/fpml:effectiveDate/fpml:unadjustedDate)"/>
</xsl:call-template>
</xsl:if>
</xsl:when>
</xsl:choose>
</xsl:variable>
<xsl:value-of select="$firstFloatPeriodStartDate"/>
</FirstFloatPeriodStartDate>
<FirstFloatPeriodStartDate_2>
<xsl:variable name="firstFloatPeriodStartDate_2">
<xsl:choose>
<xsl:when test="$productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap'">
<xsl:variable name="floatingStartDate" select="string($floatingStream/fpml:calculationPeriodDates/fpml:effectiveDate/fpml:unadjustedDate)"/>
<xsl:variable name="floating2StartDate" select="string($floatingStream2/fpml:calculationPeriodDates/fpml:effectiveDate/fpml:unadjustedDate)"/>
<xsl:if test="$swLongFormTrade and ($floatingStartDate != $floating2StartDate)">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string($floatingStream2/fpml:calculationPeriodDates/fpml:effectiveDate/fpml:unadjustedDate)"/>
</xsl:call-template>
</xsl:if>
</xsl:when>
<xsl:when test="$productType='Cross Currency IRS'">
<xsl:variable name="fixedStartDate" select="string($fixedStream/fpml:calculationPeriodDates/fpml:effectiveDate/fpml:unadjustedDate)"/>
<xsl:variable name="floating2StartDate" select="string($floatingStream2/fpml:calculationPeriodDates/fpml:effectiveDate/fpml:unadjustedDate)"/>
<xsl:if test="$swLongFormTrade and ($fixedStartDate != $floating2StartDate)">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string($floatingStream2/fpml:calculationPeriodDates/fpml:effectiveDate/fpml:unadjustedDate)"/>
</xsl:call-template>
</xsl:if>
</xsl:when>
</xsl:choose>
</xsl:variable>
<xsl:value-of select="$firstFloatPeriodStartDate_2"/>
</FirstFloatPeriodStartDate_2>
<EndDate>
<xsl:variable name="endDate">
<xsl:choose>
<xsl:when test="$productType='IRS' or $productType='OIS' or $productType='Swaption' or $productType='ZCInflationSwap' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS'">
<xsl:if test="$swLongFormTrade or $swShortFormTrade//fpml:swUnadjustedTerminationDate">
<xsl:call-template name="formatDate">
<xsl:with-param name="date">
<xsl:value-of select="$swShortFormTrade//fpml:swUnadjustedTerminationDate"/>
<xsl:value-of select="$floatingStream/fpml:calculationPeriodDates/fpml:terminationDate/fpml:unadjustedDate"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
</xsl:when>
<xsl:when test="$productType='FRA'">
<xsl:if test="$swLongFormTrade">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string($fra/fpml:adjustedTerminationDate)"/>
</xsl:call-template>
</xsl:if>
</xsl:when>
<xsl:when test="$productType='CapFloor'">
<xsl:if test="($swLongFormTrade and not($swExtendedTradeDetails/fpml:swCapFloorDetails/fpml:swFloatingRateFixingDate/fpml:unadjustedDate)) or $swShortFormTrade//fpml:swUnadjustedTerminationDate">
<xsl:call-template name="formatDate">
<xsl:with-param name="date">
<xsl:value-of select="$swShortFormTrade//fpml:swUnadjustedTerminationDate"/>
<xsl:value-of select="$capFloorStream/fpml:calculationPeriodDates/fpml:terminationDate/fpml:unadjustedDate"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
</xsl:when>
<xsl:when test="$productType='Offline Trade Rates'">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string($swOfflineTrade/fpml:terminationDate)"/>
</xsl:call-template>
</xsl:when>
<xsl:when test="$productType='Fixed Fixed Swap'">
<xsl:if test="$swLongFormTrade or $swShortFormTrade//fpml:swUnadjustedTerminationDate">
<xsl:call-template name="formatDate">
<xsl:with-param name="date">
<xsl:value-of select="$swShortFormTrade//fpml:swUnadjustedTerminationDate"/>
<xsl:value-of select="$fixedStream2/fpml:calculationPeriodDates/fpml:terminationDate/fpml:unadjustedDate"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
</xsl:when>
</xsl:choose>
</xsl:variable>
<xsl:value-of select="$endDate"/>
</EndDate>
<FixingDate>
<xsl:variable name="fixingDate">
<xsl:choose>
<xsl:when test="$productType='CapFloor' and $swExtendedTradeDetails/fpml:swCapFloorDetails/fpml:swFloatingRateFixingDate/fpml:unadjustedDate != ''">
<xsl:if test="$swLongFormTrade">
<xsl:call-template name="formatDate">
<xsl:with-param name="date">
<xsl:value-of select="$swExtendedTradeDetails/fpml:swCapFloorDetails/fpml:swFloatingRateFixingDate/fpml:unadjustedDate"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
</xsl:when>
</xsl:choose>
</xsl:variable>
<xsl:value-of select="$fixingDate"/>
</FixingDate>
<TerminationDays>
<xsl:variable name="terminationDays">
<xsl:choose>
<xsl:when test="$productType='CapFloor'">
<xsl:if test="$swLongFormTrade">
<xsl:value-of select="$capFloorStream/fpml:calculationPeriodDates/fpml:relativeTerminationDate/fpml:periodMultiplier"/>
</xsl:if>
</xsl:when>
</xsl:choose>
</xsl:variable>
<xsl:value-of select="$terminationDays"/>
</TerminationDays>
<FixedPaymentFreq>
<xsl:choose>
<xsl:when test="$swShortFormTrade and (($productType='IRS') or ($productType='Cross Currency IRS') or ($productType='Swaption') or ($productType='OIS') or ($productType='Fixed Fixed Swap'))">
<xsl:call-template name="formatInterval">
<xsl:with-param name="interval" select="$swShortFormTrade//fpml:swFixedPaymentFrequency"/>
</xsl:call-template>
</xsl:when>
<xsl:when test="$productType='IRS' or $productType='OIS' or $productType='Swaption' or $productType='ZCInflationSwap' or $productType='Cross Currency IRS' or $productType='Fixed Fixed Swap'">
<xsl:call-template name="formatInterval">
<xsl:with-param name="interval" select="$fixedStream/fpml:paymentDates/fpml:paymentFrequency"/>
</xsl:call-template>
</xsl:when>
<xsl:when test="$productType='Offline Trade Rates'">
<xsl:call-template name="formatInterval">
<xsl:with-param name="interval" select="$swOfflineTrade/fpml:swLegDetails[position()=$offlinefixedLeg]/fpml:paymentFrequency"/>
</xsl:call-template>
</xsl:when>
</xsl:choose>
</FixedPaymentFreq>
<FixedPaymentFreq_2>
<xsl:if test="$productType='Offline Trade Rates'">
<xsl:call-template name="formatInterval">
<xsl:with-param name="interval" select="$swOfflineTrade/fpml:swLegDetails[position()=$offlinefixedLeg2]/fpml:paymentFrequency"/>
</xsl:call-template>
</xsl:if>
<xsl:if test="$productType='Fixed Fixed Swap'">
<xsl:choose>
<xsl:when test="$swShortFormTrade">
<xsl:call-template name="formatInterval">
<xsl:with-param name="interval" select="$swShortFormTrade//fpml:swFixed2PaymentFrequency"/>
</xsl:call-template>
</xsl:when>
<xsl:otherwise>
<xsl:call-template name="formatInterval">
<xsl:with-param name="interval" select="$fixedStream2/fpml:paymentDates/fpml:paymentFrequency"/>
</xsl:call-template>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</FixedPaymentFreq_2>
<FloatPaymentFreq>
<xsl:choose>
<xsl:when test="$swShortFormTrade">
<xsl:choose>
<xsl:when test="$productType='IRS' or $productType='Swaption'">
<xsl:call-template name="formatInterval">
<xsl:with-param name="interval" select="$swShortFormTrade//fpml:swFloatPaymentFrequency"/>
</xsl:call-template>
</xsl:when>
<xsl:when test="$productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap'">
<xsl:call-template name="formatInterval">
<xsl:with-param name="interval" select="$swShortFormTrade//fpml:swFloatingRateCalculation[position()=$floatingLeg]/fpml:swFloatPaymentFrequency"/>
</xsl:call-template>
</xsl:when>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType='IRS' or $productType='OIS' or $productType='ZCInflationSwap' or $productType = 'Swaption' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap'">
<xsl:call-template name="formatInterval">
<xsl:with-param name="interval" select="$floatingStream/fpml:paymentDates/fpml:paymentFrequency"/>
</xsl:call-template>
</xsl:when>
<xsl:when test="$productType='CapFloor'">
<xsl:call-template name="formatInterval">
<xsl:with-param name="interval" select="$swShortFormTrade//fpml:paymentFrequency |
$capFloorStream/fpml:paymentDates/fpml:paymentFrequency"/>
</xsl:call-template>
</xsl:when>
<xsl:when test="$productType='Offline Trade Rates'">
<xsl:call-template name="formatInterval">
<xsl:with-param name="interval" select="$swOfflineTrade/fpml:swLegDetails[position()=$offlinefloatingLeg]/fpml:paymentFrequency"/>
</xsl:call-template>
</xsl:when>
</xsl:choose>
</FloatPaymentFreq>
<FloatPaymentFreq_2>
<xsl:if test="$productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS'">
<xsl:call-template name="formatInterval">
<xsl:with-param name="interval" select="$floatingStream2/fpml:paymentDates/fpml:paymentFrequency |
$swShortFormTrade//fpml:swFloatingRateCalculation[position()=$floatingLeg2]/fpml:swFloatPaymentFrequency |
$swShortFormTrade/fpml:swCrossCurrencyIrsParameters/fpml:swFloatPaymentFrequency"/>
</xsl:call-template>
</xsl:if>
<xsl:if test="$productType='Offline Trade Rates'">
<xsl:call-template name="formatInterval">
<xsl:with-param name="interval" select="$swOfflineTrade/fpml:swLegDetails[position()=$offlinefloatingLeg2]/fpml:paymentFrequency"/>
</xsl:call-template>
</xsl:if>
</FloatPaymentFreq_2>
<FloatRollFreq>
<xsl:choose>
<xsl:when test="$swShortFormTrade and (($productType='IRS') or ($productType='Swaption'))">
<xsl:call-template name="formatInterval">
<xsl:with-param name="interval" select="$swShortFormTrade//fpml:swRollFrequency"/>
</xsl:call-template>
</xsl:when>
<xsl:when test="$productType='IRS' or $productType='ZCInflationSwap' or $productType = 'Swaption' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap'">
<xsl:call-template name="formatInterval">
<xsl:with-param name="interval" select="$floatingStream/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency"/>
</xsl:call-template>
</xsl:when>
<xsl:when test="$productType='CapFloor'">
<xsl:call-template name="formatInterval">
<xsl:with-param name="interval" select="$capFloorStream/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency"/>
</xsl:call-template>
</xsl:when>
</xsl:choose>
</FloatRollFreq>
<FloatRollFreq_2>
<xsl:if test="$productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS'">
<xsl:call-template name="formatInterval">
<xsl:with-param name="interval" select="$floatingStream2/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency |
$swShortFormTrade/fpml:swCrossCurrencyIrsParameters/fpml:swRollFrequency"/>
</xsl:call-template>
</xsl:if>
</FloatRollFreq_2>
<RollsType>
<xsl:choose>
<xsl:when test="$productType='IRS' or $productType='ZCInflationSwap' or $productType='OIS' or $productType='Swaption' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS'">
<xsl:variable name="rollConvention">
<xsl:value-of select="$swShortFormTrade//fpml:rollConvention"/>
<xsl:value-of select="$floatingStream/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:rollConvention"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="starts-with($rollConvention,'IMM')">IMM</xsl:when>
<xsl:otherwise>Standard</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType='CapFloor'">
<xsl:variable name="rollConvention">
<xsl:value-of select="$swShortFormTrade//fpml:rollConvention"/>
<xsl:value-of select="$capFloorStream/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:rollConvention"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="starts-with($rollConvention,'IMM')">IMM</xsl:when>
<xsl:otherwise>Standard</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType='Fixed Fixed Swap'">
<xsl:variable name="rollConvention">
<xsl:value-of select="$swShortFormTrade//fpml:rollConvention"/>
<xsl:value-of select="$fixedStream/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:rollConvention"/>
</xsl:variable>
<xsl:variable name="rollConvention2">
<xsl:value-of select="$fixedStream2/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:rollConvention"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="starts-with($rollConvention,'IMM')">IMM</xsl:when>
<xsl:when test="starts-with($rollConvention2,'IMM')">IMM</xsl:when>
<xsl:otherwise>Standard</xsl:otherwise>
</xsl:choose>
</xsl:when>
</xsl:choose>
</RollsType>
<RollsMethod>
<xsl:if test="($productType='IRS' or $productType='OIS') and ($currency='AUD' or $currency='NZD' or $currency='CAD')">
<xsl:variable name="rollConvention">
<xsl:value-of select="$swShortFormTrade//fpml:rollConvention"/>
<xsl:value-of select="$floatingStream/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:rollConvention"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="starts-with($rollConvention,'IMM') and string-length($rollConvention)=6">
<xsl:value-of select="substring($rollConvention,4,3)"/>
</xsl:when>
<xsl:when test="$rollConvention='IMM'">CME</xsl:when>
</xsl:choose>
</xsl:if>
<xsl:if test="$productType='Fixed Fixed Swap' and ($currency='AUD' or $currency='NZD' or $currency='CAD')">
<xsl:variable name="rollConvention">
<xsl:value-of select="$swShortFormTrade//fpml:rollConvention"/>
<xsl:value-of select="$fixedStream2/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:rollConvention"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="starts-with($rollConvention,'IMM') and string-length($rollConvention)=6">
<xsl:value-of select="substring($rollConvention,4,3)"/>
</xsl:when>
<xsl:when test="$rollConvention='IMM'">CME</xsl:when>
</xsl:choose>
</xsl:if>
<xsl:if test="($productType='Single Currency Basis Swap') and ($currency='AUD')">
<xsl:variable name="rollConvention">
<xsl:value-of select="$swShortFormTrade//fpml:rollConvention"/>
<xsl:value-of select="$floatingStream/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:rollConvention"/>
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
<xsl:if test="$productType='IRS' or $productType='ZCInflationSwap' or $productType='OIS' or $productType='Swaption' or $productType='CapFloor' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='Fixed Fixed Swap'">
<xsl:choose>
<xsl:when test="$productType='CapFloor'">
<xsl:variable name="rollConvention">
<xsl:value-of select="$swShortFormTrade//fpml:rollConvention"/>
<xsl:value-of select="$capFloorStream/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:rollConvention"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="starts-with($rollConvention,'IMM')">IMM</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$rollConvention"/>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType='Fixed Fixed Swap'">
<xsl:variable name="fixedPaymntFreq2">
<xsl:call-template name="formatInterval">
<xsl:with-param name="interval" select="$fixedStream2/fpml:paymentDates/fpml:paymentFrequency"/>
</xsl:call-template>
</xsl:variable>
<xsl:variable name="rollConvention">
<xsl:value-of select="$swShortFormTrade//fpml:rollConvention"/>
<xsl:choose>
<xsl:when test="$fixedPaymntFreq2='1T'">
<xsl:value-of select="$fixedStream/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:rollConvention"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$fixedStream2/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:rollConvention"/>
</xsl:otherwise>
</xsl:choose>
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
<xsl:value-of select="$swShortFormTrade//fpml:rollConvention"/>
<xsl:value-of select="$floatingStream/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:rollConvention"/>
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
<xsl:if test="$productType='IRS' or $productType='OIS' or $productType='Swaption' or $productType='ZCInflationSwap' or $productType='CapFloor' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS'">
<xsl:variable name="rollConvention">
<xsl:value-of select="$swShortFormTrade//fpml:rollConvention"/>
<xsl:value-of select="$floatingStream/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:rollConvention"/>
<xsl:value-of select="$capFloorStream/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:rollConvention"/>
</xsl:variable>
<xsl:value-of select="string(boolean($rollConvention='EOM'))"/>
</xsl:if>
<xsl:if test="$productType='Fixed Fixed Swap'">
<xsl:variable name="rollConvention">
<xsl:value-of select="$swShortFormTrade//fpml:rollConvention"/>
<xsl:value-of select="$fixedStream2/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:rollConvention"/>
</xsl:variable>
<xsl:value-of select="string(boolean($rollConvention='EOM'))"/>
</xsl:if>
</MonthEndRolls>
<FirstPeriodStartDate/>
<FirstPaymentDate/>
<LastRegularPaymentDate/>
<FixedRate>
<xsl:choose>
<xsl:when test="$productType='IRS' or $productType='OIS' or $productType='Swaption' or $productType='ZCInflationSwap' or $productType='Cross Currency IRS' or $productType='Fixed Fixed Swap'">
<xsl:value-of select="$swShortFormTrade//fpml:fixedRate"/>
<xsl:value-of select="$fixedStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:fixedRateSchedule/fpml:initialValue"/>
</xsl:when>
<xsl:when test="$productType='FRA'">
<xsl:value-of select="$swShortFormTrade//fpml:swFraParameters/fpml:fixedRate"/>
<xsl:value-of select="$fra/fpml:fixedRate"/>
</xsl:when>
<xsl:when test="$productType='Offline Trade Rates'">
<xsl:variable name="OfflineProductType" select="string($swOfflineTrade/fpml:swOfflineProductType)"/>
<xsl:choose>
<xsl:when test="$OfflineProductType='FRA' or $OfflineProductType='Cap' or $OfflineProductType='Floor' or $OfflineProductType='Swaption'">
<xsl:value-of select="$swOfflineTrade/fpml:swLegDetails/fpml:fixedRate"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$swOfflineTrade/fpml:swLegDetails[position()=$offlinefixedLeg]/fpml:fixedRate"/>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
</xsl:choose>
</FixedRate>
<FixedRate_2>
<xsl:if test="$productType='Offline Trade Rates'">
<xsl:value-of select="$swOfflineTrade/fpml:swLegDetails[position()=$offlinefixedLeg2]/fpml:fixedRate"/>
</xsl:if>
<xsl:if test="$productType='Fixed Fixed Swap'">
<xsl:value-of select="$swShortFormTrade//fpml:fixedRate2"/>
<xsl:value-of select="$fixedStream2/fpml:calculationPeriodAmount/fpml:calculation/fpml:fixedRateSchedule/fpml:initialValue"/>
</xsl:if>
</FixedRate_2>
<initialPoints/>
<quotationStyle/>
<RecoveryRate/>
<FixedSettlement/>
<Currency>
<xsl:value-of select="$currency"/>
</Currency>
<Currency_2>
<xsl:if test="$productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS'">
<xsl:choose>
<xsl:when test="$floatingStream2/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule">
<xsl:value-of select="$floatingStream2/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:currency"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$floatingStream2/fpml:calculationPeriodAmount/fpml:calculation/fpml:fxLinkedNotionalSchedule/fpml:varyingNotionalCurrency"/>
</xsl:otherwise>
</xsl:choose>
<xsl:value-of select="$swShortFormTrade//fpml:swNotional2/fpml:currency"/>
<xsl:value-of select="$swShortFormTrade//fpml:swFloatingRateCalculation[position()=$floatingLeg2]/fpml:notional/fpml:currency"/>
</xsl:if>
<xsl:if test="$productType='Offline Trade Rates'">
<xsl:value-of select="$swOfflineTrade/fpml:swLegDetails[2]/fpml:notional/fpml:currency"/>
</xsl:if>
<xsl:if test="$productType='Fixed Fixed Swap'">
<xsl:choose>
<xsl:when test="$fixedStream2/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule">
<xsl:value-of select="$fixedStream2/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:currency"/>
</xsl:when>
<xsl:when test="$fixedStream2/fpml:calculationPeriodAmount/fpml:knownAmountSchedule">
<xsl:value-of select="$fixedStream2/fpml:calculationPeriodAmount/fpml:knownAmountSchedule/fpml:currency"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$fixedStream2/fpml:calculationPeriodAmount/fpml:calculation/fpml:fxLinkedNotionalSchedule/fpml:varyingNotionalCurrency"/>
</xsl:otherwise>
</xsl:choose>
<xsl:value-of select="$swShortFormTrade//fpml:swNotional2/fpml:currency"/>
</xsl:if>
</Currency_2>
<Notional>
<xsl:choose>
<xsl:when test="(($productType='IRS' or $productType='OIS') and $fixedStream/fpml:calculationPeriodAmount/fpml:knownAmountSchedule) or $productType='Swaption' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or ($productType='ZCInflationSwap' and not(//fpml:additionalTerms/fpml:bondReference/fpml:bond/fpml:couponRate))">
<xsl:value-of select="$swShortFormTrade//fpml:notional/fpml:amount"/>
<xsl:value-of select="$floatingStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:initialValue"/>
</xsl:when>
<xsl:when test="$productType='FRA'">
<xsl:value-of select="$swShortFormTrade//fpml:swFraParameters/fpml:notional/fpml:amount"/>
<xsl:value-of select="$fra/fpml:notional/fpml:amount"/>
</xsl:when>
<xsl:when test="$productType='CapFloor'">
<xsl:value-of select="$swShortFormTrade//fpml:notional/fpml:amount"/>
<xsl:value-of select="$capFloorStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:initialValue"/>
</xsl:when>
<xsl:when test="$productType='IRS' or $productType='OIS' or $productType='Cross Currency IRS' or $productType='Fixed Fixed Swap' or ($productType='ZCInflationSwap' and //fpml:additionalTerms/fpml:bondReference/fpml:bond/fpml:couponRate)">
<xsl:value-of select="$fixedStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:initialValue"/>
<xsl:value-of select="$swShortFormTrade//fpml:notional/fpml:amount"/>
</xsl:when>
<xsl:when test="$productType='Offline Trade Rates'">
<xsl:value-of select="$swOfflineTrade/fpml:swLegDetails[1]/fpml:notional/fpml:amount"/>
</xsl:when>
</xsl:choose>
</Notional>
<NotionalFloating>
<xsl:if test="$productType='ZCInflationSwap'or (($productType='IRS' or $productType='OIS') and $floatingStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:initialValue != $fixedStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:initialValue)">
<xsl:value-of select="$swShortFormTrade//fpml:notional/fpml:amount"/>
<xsl:value-of select="$floatingStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:initialValue"/>
</xsl:if>
</NotionalFloating>
<Notional_2>
<xsl:if test="$productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS'">
<xsl:value-of select="$swShortFormTrade//fpml:swNotional2/fpml:amount"/>
<xsl:value-of select="$swShortFormTrade//fpml:swFloatingRateCalculation[position()=$floatingLeg2]/fpml:notional/fpml:amount"/>
<xsl:value-of select="$floatingStream2/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:initialValue"/>
</xsl:if>
<xsl:if test="$productType='Offline Trade Rates'">
<xsl:value-of select="$swOfflineTrade/fpml:swLegDetails[2]/fpml:notional/fpml:amount"/>
</xsl:if>
<xsl:if test="$productType='Fixed Fixed Swap'">
<xsl:value-of select="$fixedStream2/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:initialValue"/>
<xsl:value-of select="$swShortFormTrade//fpml:swNotional2/fpml:amount"/>
</xsl:if>
</Notional_2>
<InitialNotional>
<xsl:if test="$productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS'">
<xsl:value-of select="$floatingStream2/fpml:calculationPeriodAmount/fpml:calculation/fpml:fxLinkedNotionalSchedule/fpml:initialValue"/>
</xsl:if>
<xsl:if test="$productType='Fixed Fixed Swap'">
<xsl:value-of select="$fixedStream2/fpml:calculationPeriodAmount/fpml:calculation/fpml:fxLinkedNotionalSchedule/fpml:initialValue"/>
<xsl:value-of select="$swShortFormTrade//fpml:swFixedFixedParameters/fpml:InitialNotional"/>
</xsl:if>
</InitialNotional>
<xsl:if test="$productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS'">
<xsl:for-each select="$floatingStream2/fpml:cashflows/fpml:principalExchange">
<xsl:variable name="unadjustedPrincipalExchangeDate"><xsl:value-of select="fpml:unadjustedPrincipalExchangeDate"/></xsl:variable>
<xsl:variable name="unadjustedDate"><xsl:value-of select="$floatingStream2/fpml:calculationPeriodDates/fpml:terminationDate/fpml:unadjustedDate"/></xsl:variable>
<xsl:if test="$unadjustedPrincipalExchangeDate = $unadjustedDate">
<FinalExchangeAmount>
<xsl:value-of select="translate(fpml:principalExchangeAmount/text(),'-','')"/>
</FinalExchangeAmount>
</xsl:if>
</xsl:for-each>
</xsl:if>
<FixedAmount>
<xsl:choose>
<xsl:when test="$fixedStream/fpml:calculationPeriodAmount/fpml:knownAmountSchedule">
<xsl:value-of select="$fixedStream/fpml:calculationPeriodAmount/fpml:knownAmountSchedule/fpml:initialValue"/>
</xsl:when>
<xsl:when test="$productType='ZCInflationSwap'">
<xsl:value-of select="$fixedStream/fpml:cashflows/fpml:paymentCalculationPeriod/fpml:fixedPaymentAmount"/>
</xsl:when>
<xsl:when test="$swShortFormTrade and ($productType='OIS' or $productType='IRS' or $productType='Fixed Fixed Swap')">
<xsl:value-of select="$swShortFormTrade//fpml:fixedAmount"/>
</xsl:when>
</xsl:choose>
</FixedAmount>
<FixedAmount_2>
<xsl:if test="$fixedStream2/fpml:calculationPeriodAmount/fpml:knownAmountSchedule">
<xsl:value-of select="$fixedStream2/fpml:calculationPeriodAmount/fpml:knownAmountSchedule/fpml:initialValue"/>
</xsl:if>
<xsl:if test="$swShortFormTrade and $productType='Fixed Fixed Swap'">
<xsl:value-of select="$swShortFormTrade//fpml:fixedAmount2"/>
</xsl:if>
</FixedAmount_2>
<FixedAmountCurrency>
<xsl:choose>
<xsl:when test="$fixedStream/fpml:calculationPeriodAmount/fpml:knownAmountSchedule">
<xsl:value-of select="$fixedStream/fpml:calculationPeriodAmount/fpml:knownAmountSchedule/fpml:currency"/>
</xsl:when>
<xsl:when test="$productType='ZCInflationSwap'">
<xsl:value-of select="$fixedStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:currency"/>
</xsl:when>
</xsl:choose>
</FixedAmountCurrency>
<FixedAmountCurrency_2>
<xsl:if test="$fixedStream2/fpml:calculationPeriodAmount/fpml:knownAmountSchedule">
<xsl:value-of select="$fixedStream2/fpml:calculationPeriodAmount/fpml:knownAmountSchedule/fpml:currency"/>
</xsl:if>
<xsl:if test="$fixedStream/fpml:calculationPeriodAmount/fpml:knownAmountSchedule and $productType='ZCInflationSwap'">ZCISFA</xsl:if>
</FixedAmountCurrency_2>
<FixedDayBasis>
<xsl:if test="not($productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap')">
<xsl:value-of select="$fixedStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:dayCountFraction"/>
</xsl:if>
</FixedDayBasis>
<FixedDayBasis_2>
<xsl:if test="$productType='Fixed Fixed Swap'">
<xsl:value-of select="$fixedStream2/fpml:calculationPeriodAmount/fpml:calculation/fpml:dayCountFraction"/>
</xsl:if>
</FixedDayBasis_2>
<FloatDayBasis>
<xsl:choose>
<xsl:when test="$productType='IRS' or $productType='OIS' or $productType='ZCInflationSwap' or $productType='Swaption' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap'">
<xsl:value-of select="$floatingStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:dayCountFraction"/>
</xsl:when>
<xsl:when test="$productType='FRA'">
<xsl:value-of select="$fra/fpml:dayCountFraction"/>
</xsl:when>
<xsl:when test="$productType='CapFloor'">
<xsl:value-of select="$capFloorStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:dayCountFraction"/>
</xsl:when>
</xsl:choose>
</FloatDayBasis>
<FloatDayBasis_2>
<xsl:if test="$productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS'">
<xsl:value-of select="$floatingStream2/fpml:calculationPeriodAmount/fpml:calculation/fpml:dayCountFraction"/>
</xsl:if>
</FloatDayBasis_2>
<FixedConvention>
<xsl:if test="not($productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap')">
<xsl:value-of select="substring($fixedStream/fpml:paymentDates/fpml:paymentDatesAdjustments/fpml:businessDayConvention,1,4)"/>
</xsl:if>
</FixedConvention>
<FixedConvention_2>
<xsl:if test="$productType='Fixed Fixed Swap'">
<xsl:value-of select="substring($fixedStream2/fpml:paymentDates/fpml:paymentDatesAdjustments/fpml:businessDayConvention,1,4)"/>
</xsl:if>
</FixedConvention_2>
<FixedCalcPeriodDatesConvention>
<xsl:if test="$productType='OIS' or $productType='IRS' or $productType='Fixed Fixed Swap' or $productType='ZCInflationSwap'">
<xsl:value-of select="substring ($fixedStream/fpml:calculationPeriodDates/fpml:calculationPeriodDatesAdjustments/fpml:businessDayConvention,1,4)"/>
</xsl:if>
</FixedCalcPeriodDatesConvention>
<FixedCalcPeriodDatesConvention_2>
<xsl:if test="$productType='Fixed Fixed Swap'">
<xsl:value-of select="substring ($fixedStream2/fpml:calculationPeriodDates/fpml:calculationPeriodDatesAdjustments/fpml:businessDayConvention,1,4)"/>
</xsl:if>
</FixedCalcPeriodDatesConvention_2>
<FixedTerminationDateConvention>
<xsl:if test="$productType='IRS' or $productType='OIS' or $productType='Swaption' or $productType='Cross Currency IRS' or $productType='Fixed Fixed Swap' or $productType='ZCInflationSwap'">
<xsl:value-of select="substring($fixedStream/fpml:calculationPeriodDates/fpml:terminationDate/fpml:dateAdjustments/fpml:businessDayConvention,1,4)"/>
</xsl:if>
</FixedTerminationDateConvention>
<FixedTerminationDateConvention_2>
<xsl:if test="$productType='Fixed Fixed Swap'">
<xsl:value-of select="substring($fixedStream2/fpml:calculationPeriodDates/fpml:terminationDate/fpml:dateAdjustments/fpml:businessDayConvention,1,4)"/>
</xsl:if>
</FixedTerminationDateConvention_2>
<FloatConvention>
<xsl:choose>
<xsl:when test="$productType='IRS' or $productType='OIS' or $productType='ZCInflationSwap' or $productType='Swaption' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap'">
<xsl:value-of select="substring($floatingStream/fpml:paymentDates/fpml:paymentDatesAdjustments/fpml:businessDayConvention,1,4)"/>
</xsl:when>
<xsl:when test="$productType='FRA'">
<xsl:value-of select="substring($fra/fpml:paymentDate/fpml:dateAdjustments/fpml:businessDayConvention,1,4)"/>
</xsl:when>
<xsl:when test="$productType='CapFloor'">
<xsl:value-of select="substring($capFloorStream/fpml:paymentDates/fpml:paymentDatesAdjustments/fpml:businessDayConvention,1,4)"/>
</xsl:when>
</xsl:choose>
</FloatConvention>
<FloatCalcPeriodDatesConvention>
<xsl:if test="$productType='OIS' or $productType='IRS' or $productType='ZCInflationSwap'">
<xsl:value-of select="substring($floatingStream/fpml:calculationPeriodDates/fpml:calculationPeriodDatesAdjustments/fpml:businessDayConvention,1,4)"/>
</xsl:if>
</FloatCalcPeriodDatesConvention>
<FloatTerminationDateConvention>
<xsl:if test="$productType='IRS' or $productType='OIS' or $productType='Swaption' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='ZCInflationSwap'">
<xsl:value-of select="substring($floatingStream/fpml:calculationPeriodDates/fpml:terminationDate/fpml:dateAdjustments/fpml:businessDayConvention,1,4)"/>
</xsl:if>
</FloatTerminationDateConvention>
<FloatConvention_2>
<xsl:if test="$productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap'  or $productType='Cross Currency IRS'">
<xsl:value-of select="substring($floatingStream2/fpml:paymentDates/fpml:paymentDatesAdjustments/fpml:businessDayConvention,1,4)"/>
</xsl:if>
</FloatConvention_2>
<FloatTerminationDateConvention_2>
<xsl:if test="$productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap'  or $productType='Cross Currency IRS'">
<xsl:value-of select="substring($floatingStream2/fpml:calculationPeriodDates/fpml:terminationDate/fpml:dateAdjustments/fpml:businessDayConvention,1,4)"/>
</xsl:if>
</FloatTerminationDateConvention_2>
<FloatingRateIndex>
<xsl:choose>
<xsl:when test="$productType='IRS' or $productType='OIS' or $productType='Swaption' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap'">
<xsl:value-of select="$swShortFormTrade//fpml:floatingRateIndex"/>
<xsl:value-of select="$floatingStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:floatingRateIndex"/>
</xsl:when>
<xsl:when test="$productType='ZCInflationSwap'">
<xsl:value-of select="$swShortFormTrade//fpml:swFloatingRateIndex"/>
<xsl:value-of select="$floatingStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:inflationRateCalculation/fpml:floatingRateIndex"/>
</xsl:when>
<xsl:when test="$productType='FRA'">
<xsl:value-of select="$swShortFormTrade//fpml:swFraParameters/fpml:floatingRateIndex"/>
<xsl:value-of select="$fra/fpml:floatingRateIndex"/>
</xsl:when>
<xsl:when test="$productType='CapFloor'">
<xsl:value-of select="$swShortFormTrade//fpml:floatingRateIndex"/>
<xsl:value-of select="$capFloorStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:floatingRateIndex"/>
</xsl:when>
<xsl:when test="$productType='Single Currency Basis Swap'">
<xsl:value-of select="$swShortFormTrade/fpml:swBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg]/fpml:floatingRateIndex"/>
<xsl:value-of select="$floatingStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:floatingRateIndex"/>
</xsl:when>
<xsl:when test="$productType='Offline Trade Rates'">
<xsl:value-of select="$swOfflineTrade/fpml:swLegDetails[position()=$offlinefloatingLeg]/fpml:floatingRateIndex"/>
</xsl:when>
</xsl:choose>
</FloatingRateIndex>
<FloatingRateIndex_2>
<xsl:if test="$productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap'  or $productType='Cross Currency IRS'">
<xsl:value-of select="$swShortFormTrade/fpml:swBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg2]/fpml:floatingRateIndex"/>
<xsl:value-of select="$swShortFormTrade/fpml:swCrossCurrencyBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg2]/fpml:floatingRateIndex"/>
<xsl:value-of select="$swShortFormTrade/fpml:swCrossCurrencyIrsParameters/fpml:floatingRateIndex"/>
<xsl:value-of select="$floatingStream2/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:floatingRateIndex"/>
</xsl:if>
<xsl:if test="$productType='Offline Trade Rates'">
<xsl:value-of select="$swOfflineTrade/fpml:swLegDetails[position()=$offlinefloatingLeg2]/fpml:floatingRateIndex"/>
</xsl:if>
</FloatingRateIndex_2>
<InflationLag>
<xsl:if test="$productType='ZCInflationSwap'">
<xsl:call-template name="formatInterval">
<xsl:with-param name="interval" select="$floatingStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:inflationRateCalculation/fpml:inflationLag |
$swShortFormTrade//fpml:swInflationLag"/>
</xsl:call-template>
</xsl:if>
</InflationLag>
<IndexSource>
<xsl:if test="$productType='ZCInflationSwap'">
<xsl:value-of select="$floatingStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:inflationRateCalculation/fpml:indexSource"/>
<xsl:value-of select="$swShortFormTrade//fpml:swIndexSource"/>
</xsl:if>
</IndexSource>
<InterpolationMethod>
<xsl:if test="$productType='ZCInflationSwap'">
<xsl:value-of select="$floatingStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:inflationRateCalculation/fpml:interpolationMethod"/>
<xsl:value-of select="$swShortFormTrade//fpml:swInterpolationMethod"/>
</xsl:if>
</InterpolationMethod>
<InitialIndexLevel>
<xsl:if test="$productType='ZCInflationSwap'">
<xsl:value-of select="$floatingStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:inflationRateCalculation/fpml:initialIndexLevel"/>
<xsl:value-of select="$swShortFormTrade//fpml:swInitialIndexLevel"/>
</xsl:if>
</InitialIndexLevel>
<RelatedBond>
<xsl:if test="$productType='ZCInflationSwap'">
<xsl:value-of select="$swap/fpml:additionalTerms/fpml:bondReference/fpml:bond/fpml:instrumentId"/>
<xsl:value-of select="$swShortFormTrade//fpml:swRelatedBond"/>
</xsl:if>
</RelatedBond>
<IndexTenor1>
<xsl:choose>
<xsl:when test="$swShortFormTrade">
<xsl:choose>
<xsl:when test="$productType='IRS' or $productType='Swaption' or $productType='Fixed Fixed Swap'">
<xsl:call-template name="formatInterval">
<xsl:with-param name="interval" select="$swShortFormTrade//fpml:swStubIndexTenor[1]"/>
</xsl:call-template>
</xsl:when>
<xsl:when test="$productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap'">
<xsl:call-template name="formatInterval">
<xsl:with-param name="interval" select="$swShortFormTrade//fpml:swFloatingRateCalculation[position()=$floatingLeg]/fpml:swStubIndexTenor[1]"/>
</xsl:call-template>
</xsl:when>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType='FRA'">
<xsl:call-template name="formatInterval">
<xsl:with-param name="interval" select="$fra/fpml:indexTenor[1]"/>
</xsl:call-template>
</xsl:when>
<xsl:when test="$productType='CapFloor'">
<xsl:call-template name="formatInterval">
<xsl:with-param name="interval" select="$swShortFormTrade//fpml:indexTenor |
$capFloorStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:indexTenor"/>
</xsl:call-template>
</xsl:when>
<xsl:when test="$productType='IRS' and $swExtendedTradeDetails/fpml:swStub[2]">
<xsl:call-template name="formatInterval">
<xsl:with-param name="interval" select="$floatingStream/fpml:stubCalculationPeriodAmount/fpml:initialStub/fpml:floatingRate[1]/fpml:indexTenor"/>
</xsl:call-template>
</xsl:when>
<xsl:when test="$productType='IRS' or $productType='Swaption' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap'">
<xsl:call-template name="formatInterval">
<xsl:with-param name="interval" select="$floatingStream/fpml:stubCalculationPeriodAmount//fpml:floatingRate[1]/fpml:indexTenor"/>
</xsl:call-template>
</xsl:when>
<xsl:when test="$productType='Offline Trade Rates'">
<xsl:call-template name="formatInterval">
<xsl:with-param name="interval" select="$swOfflineTrade/fpml:swLegDetails[position()=$offlinefloatingLeg]/fpml:indexTenor"/>
</xsl:call-template>
</xsl:when>
<xsl:when test="$productType='Fixed Fixed Swap'">
<xsl:call-template name="formatInterval">
<xsl:with-param name="interval" select="$fixedStream/fpml:stubCalculationPeriodAmount//fpml:fixedRate[1]/fpml:indexTenor"/>
</xsl:call-template>
</xsl:when>
</xsl:choose>
</IndexTenor1>
<IndexTenor1_2>
<xsl:choose>
<xsl:when test="$swShortFormTrade">
<xsl:choose>
<xsl:when test="$productType='Single Currency Basis Swap'">
<xsl:call-template name="formatInterval">
<xsl:with-param name="interval" select="$swShortFormTrade//fpml:swFloatingRateCalculation[position()=$floatingLeg2]/fpml:swStubIndexTenor[1]"/>
</xsl:call-template>
</xsl:when>
<xsl:when test="$productType='Cross Currency Basis Swap'">
<xsl:call-template name="formatInterval">
<xsl:with-param name="interval" select="$swShortFormTrade//fpml:swFloatingRateCalculation[position()=$floatingLeg2]/fpml:swStubIndexTenor[1]"/>
</xsl:call-template>
</xsl:when>
<xsl:when test="$productType='Cross Currency IRS' or $productType='Fixed Fixed Swap'">
<xsl:call-template name="formatInterval">
<xsl:with-param name="interval" select="$swShortFormTrade//fpml:swStubIndexTenor[1]"/>
</xsl:call-template>
</xsl:when>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType='CapFloor' and $capFloorStream/fpml:stubCalculationPeriodAmount/fpml:initialStub">
<xsl:call-template name="formatInterval">
<xsl:with-param name="interval" select="$capFloorStream/fpml:stubCalculationPeriodAmount/fpml:initialStub/fpml:floatingRate[1]/fpml:indexTenor"/>
</xsl:call-template>
</xsl:when>
<xsl:when test="$productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS'">
<xsl:call-template name="formatInterval">
<xsl:with-param name="interval" select="$floatingStream2/fpml:stubCalculationPeriodAmount//fpml:floatingRate[1]/fpml:indexTenor"/>
</xsl:call-template>
</xsl:when>
</xsl:choose>
<xsl:if test="$productType='Offline Trade Rates'">
<xsl:call-template name="formatInterval">
<xsl:with-param name="interval" select="$swOfflineTrade/fpml:swLegDetails[position()=$offlinefloatingLeg2]/fpml:indexTenor"/>
</xsl:call-template>
</xsl:if>
<xsl:if test="$productType='Fixed Fixed Swap'">
<xsl:call-template name="formatInterval">
<xsl:with-param name="interval" select="$fixedStream2/fpml:stubCalculationPeriodAmount//fpml:fixedRate[1]/fpml:indexTenor"/>
</xsl:call-template>
</xsl:if>
</IndexTenor1_2>
<LinearInterpolation>
<xsl:choose>
<xsl:when test="$swLongFormTrade and $productType='FRA'">
<xsl:value-of select="string(boolean($fra/fpml:indexTenor[2]))"/>
</xsl:when>
<xsl:when test="$productType='IRS' and $swExtendedTradeDetails/fpml:swStub[2]">
<xsl:value-of select="string(boolean($floatingStream/fpml:stubCalculationPeriodAmount/fpml:initialStub/fpml:floatingRate[2]))"/>
</xsl:when>
<xsl:when test="($productType='IRS' or $productType='ZCInflationSwap' or $productType='Swaption' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap') and $floatingStream/fpml:stubCalculationPeriodAmount//fpml:floatingRate[1]">
<xsl:value-of select="string(boolean($floatingStream/fpml:stubCalculationPeriodAmount//fpml:floatingRate[2]))"/>
</xsl:when>
<xsl:when test="($productType='CapFloor' and $capFloorStream/fpml:stubCalculationPeriodAmount/fpml:initialStub//fpml:floatingRate[1])">
<xsl:value-of select="string(boolean($capFloorStream/fpml:stubCalculationPeriodAmount/fpml:initialStub//fpml:floatingRate[2]))"/>
</xsl:when>
<xsl:when test="($productType='Cross Currency Basis Swap' or $productType='Single Currency Basis Swap') and $swShortFormTrade//fpml:swFloatingRateCalculation[position()=$floatingLeg]/fpml:swStubIndexTenor[1]">
<xsl:value-of select="string(boolean($swShortFormTrade//fpml:swFloatingRateCalculation[position()=$floatingLeg]/fpml:swStubIndexTenor[2]))"/>
</xsl:when>
</xsl:choose>
</LinearInterpolation>
<LinearInterpolation_2>
<xsl:choose>
<xsl:when test="($productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS') and $floatingStream2/fpml:stubCalculationPeriodAmount//fpml:floatingRate[1]">
<xsl:value-of select="string(boolean($floatingStream2/fpml:stubCalculationPeriodAmount//fpml:floatingRate[2]))"/>
</xsl:when>
<xsl:when test="($productType='Cross Currency Basis Swap' or $productType='Single Currency Basis Swap') and $swShortFormTrade//fpml:swFloatingRateCalculation[position()=$floatingLeg2]/fpml:swStubIndexTenor[1]">
<xsl:value-of select="string(boolean($swShortFormTrade//fpml:swFloatingRateCalculation[position()=$floatingLeg2]/fpml:swStubIndexTenor[2]))"/>
</xsl:when>
</xsl:choose>
</LinearInterpolation_2>
<IndexTenor2>
<xsl:choose>
<xsl:when test="$swShortFormTrade">
<xsl:choose>
<xsl:when test=" $productType='IRS' or $productType='Swaption' or $productType='Fixed Fixed Swap'">
<xsl:call-template name="formatInterval">
<xsl:with-param name="interval" select="$swShortFormTrade//fpml:swStubIndexTenor[2]"/>
</xsl:call-template>
</xsl:when>
<xsl:when test=" $productType='Single Currency Basis Swap'">
<xsl:call-template name="formatInterval">
<xsl:with-param name="interval" select="$swShortFormTrade//fpml:swFloatingRateCalculation[position()=$floatingLeg]/fpml:swStubIndexTenor[2]"/>
</xsl:call-template>
</xsl:when>
<xsl:when test=" $productType='Cross Currency Basis Swap'">
<xsl:call-template name="formatInterval">
<xsl:with-param name="interval" select="$swShortFormTrade//fpml:swFloatingRateCalculation[position()=$floatingLeg]/fpml:swStubIndexTenor[2]"/>
</xsl:call-template>
</xsl:when>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType='FRA'">
<xsl:call-template name="formatInterval">
<xsl:with-param name="interval" select="$fra/fpml:indexTenor[2]"/>
</xsl:call-template>
</xsl:when>
<xsl:when test="$productType='IRS' and $swExtendedTradeDetails/fpml:swStub[2]">
<xsl:call-template name="formatInterval">
<xsl:with-param name="interval" select="$floatingStream/fpml:stubCalculationPeriodAmount/fpml:initialStub/fpml:floatingRate[2]/fpml:indexTenor"/>
</xsl:call-template>
</xsl:when>
<xsl:when test="$productType='IRS' or $productType='ZCInflationSwap' or $productType='Swaption' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap'">
<xsl:call-template name="formatInterval">
<xsl:with-param name="interval" select="$floatingStream/fpml:stubCalculationPeriodAmount//fpml:floatingRate[2]/fpml:indexTenor"/>
</xsl:call-template>
</xsl:when>
<xsl:when test="$productType='Fixed Fixed Swap'">
<xsl:call-template name="formatInterval">
<xsl:with-param name="interval" select="$fixedStream2/fpml:stubCalculationPeriodAmount//fpml:fixedRate[2]/fpml:indexTenor"/>
</xsl:call-template>
</xsl:when>
<xsl:when test="$productType='CapFloor' and $capFloorStream/fpml:stubCalculationPeriodAmount/fpml:initialStub/fpml:floatingRate[2]/fpml:indexTenor">
<xsl:call-template name="formatInterval">
<xsl:with-param name="interval" select="$capFloorStream/fpml:stubCalculationPeriodAmount/fpml:initialStub/fpml:floatingRate[2]/fpml:indexTenor"/>
</xsl:call-template>
</xsl:when>
</xsl:choose>
</IndexTenor2>
<IndexTenor2_2>
<xsl:if test="$productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap'  or $productType='Cross Currency IRS' or $productType='Fixed Fixed Swap'">
<xsl:call-template name="formatInterval">
<xsl:with-param name="interval" select="$floatingStream2/fpml:stubCalculationPeriodAmount//fpml:floatingRate[2]/fpml:indexTenor |
$swShortFormTrade//fpml:swFloatingRateCalculation[position()=$floatingLeg2]/fpml:swStubIndexTenor[2]|
$swShortFormTrade/fpml:swFixedFixedParameters/fpml:swStubIndexTenor[2]|
$swShortFormTrade/fpml:swCrossCurrencyIrsParameters/fpml:swStubIndexTenor[2]"/>
</xsl:call-template>
</xsl:if>
<xsl:if test="$productType='Fixed Fixed Swap'">
<xsl:call-template name="formatInterval">
<xsl:with-param name="interval" select="$fixedStream2/fpml:stubCalculationPeriodAmount//fpml:fixedRate[2]/fpml:indexTenor"/>
</xsl:call-template>
</xsl:if>
</IndexTenor2_2>
<InitialInterpolationIndex>
<xsl:choose>
<xsl:when test="count($swShortFormTrade//fpml:swStubFloatingRateIndex)=2 and $swShortFormTrade//fpml:swStubFloatingRateIndex[1] != $swShortFormTrade//fpml:swStubFloatingRateIndex[2] and (($productType='IRS') or ($productType='Swaption'))">
<xsl:value-of select="$swShortFormTrade//fpml:swStubFloatingRateIndex[1]"/>
</xsl:when>
<xsl:when test="$productType='CapFloor' and count($capFloorStream/fpml:stubCalculationPeriodAmount//fpml:floatingRate)=2 and $capFloorStream/fpml:stubCalculationPeriodAmount//fpml:floatingRate[1]/fpml:floatingRateIndex != $capFloorStream/fpml:stubCalculationPeriodAmount//fpml:floatingRate[2]/fpml:floatingRateIndex">
<xsl:value-of select="$capFloorStream/fpml:stubCalculationPeriodAmount//fpml:floatingRate[1]/fpml:floatingRateIndex"/>
</xsl:when>
<xsl:when test="$productType='IRS' and $swExtendedTradeDetails/fpml:swStub[2] and count($floatingStream/fpml:stubCalculationPeriodAmount/fpml:initialStub/fpml:floatingRate)=2 and $floatingStream/fpml:stubCalculationPeriodAmount/fpml:initialStub/fpml:floatingRate[1]/fpml:floatingRateIndex != $floatingStream/fpml:stubCalculationPeriodAmount/fpml:initialStub/fpml:floatingRate[2]/fpml:floatingRateIndex">
<xsl:value-of select="$floatingStream/fpml:stubCalculationPeriodAmount/fpml:initialStub/fpml:floatingRate[1]/fpml:floatingRateIndex"/>
</xsl:when>
<xsl:when test="($productType='IRS' or $productType='Swaption' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap') and count($floatingStream/fpml:stubCalculationPeriodAmount//fpml:floatingRate)=2 and $floatingStream/fpml:stubCalculationPeriodAmount//fpml:floatingRate[1]/fpml:floatingRateIndex != $floatingStream/fpml:stubCalculationPeriodAmount//fpml:floatingRate[2]/fpml:floatingRateIndex">
<xsl:value-of select="$floatingStream/fpml:stubCalculationPeriodAmount//fpml:floatingRate[1]/fpml:floatingRateIndex"/>
</xsl:when>
</xsl:choose>
</InitialInterpolationIndex>
<InitialInterpolationIndex_2>
<xsl:choose>
<xsl:when test="$productType='Cross Currency IRS' and count($floatingStream/fpml:stubCalculationPeriodAmount//fpml:floatingRate)=2 and $floatingStream/fpml:stubCalculationPeriodAmount//fpml:floatingRate[1]/fpml:floatingRateIndex != $floatingStream/fpml:stubCalculationPeriodAmount//fpml:floatingRate[2]/fpml:floatingRateIndex">
<xsl:value-of select="$floatingStream/fpml:stubCalculationPeriodAmount//fpml:floatingRate[1]/fpml:floatingRateIndex"/>
</xsl:when>
<xsl:when test="($productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap') and count($floatingStream2/fpml:stubCalculationPeriodAmount//fpml:floatingRate)=2 and $floatingStream2/fpml:stubCalculationPeriodAmount//fpml:floatingRate[1]/fpml:floatingRateIndex != $floatingStream2/fpml:stubCalculationPeriodAmount//fpml:floatingRate[2]/fpml:floatingRateIndex">
<xsl:value-of select="$floatingStream2/fpml:stubCalculationPeriodAmount//fpml:floatingRate[1]/fpml:floatingRateIndex"/>
</xsl:when>
</xsl:choose>
</InitialInterpolationIndex_2>
<CMSCalcAgent>
<xsl:if test="$productType='CapFloor'">
<xsl:if test="$swLongFormTrade and $swExtendedTradeDetails/fpml:swCapFloorDetails/fpml:calculationAgent">
<xsl:choose>
<xsl:when test="count($swExtendedTradeDetails/fpml:swCapFloorDetails/fpml:calculationAgent/fpml:calculationAgentPartyReference) = 2">Joint</xsl:when>
<xsl:when test="$swExtendedTradeDetails/fpml:swCapFloorDetails/fpml:calculationAgent/fpml:calculationAgentPartyReference/@href = $capFloor/fpml:capFloorStream/fpml:receiverPartyReference/@href">Buyer</xsl:when>
<xsl:when test="$swExtendedTradeDetails/fpml:swCapFloorDetails/fpml:calculationAgent/fpml:calculationAgentPartyReference/@href = $capFloor/fpml:capFloorStream/fpml:payerPartyReference/@href">Seller</xsl:when>
<xsl:when test="$swExtendedTradeDetails/fpml:swCapFloorDetails/fpml:calculationAgent/fpml:calculationAgentParty[.='AsSpecifiedInMasterAgreement']">As Specified in Master Agreement</xsl:when>
<xsl:otherwise>???</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:if>
</CMSCalcAgent>
<CompoundingCalculationMethod>
<xsl:if test="($productType='Single Currency Basis Swap' or $productType='OIS' or $productType='Cross Currency Basis Swap')">
<xsl:choose>
<xsl:when test="$floatingStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:calculationMethod">
<xsl:value-of select="$floatingStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:calculationMethod"/>
</xsl:when>
<xsl:when test="$swShortFormTrade/fpml:swBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg]/fpml:calculationParameters/fpml:calculationMethod">
<xsl:value-of select="$swShortFormTrade/fpml:swBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg]/fpml:calculationParameters/fpml:calculationMethod"/>
</xsl:when>
<xsl:when test="$swShortFormTrade/fpml:swOisParameters/fpml:calculationParameters/fpml:calculationMethod">
<xsl:value-of select="$swShortFormTrade/fpml:swOisParameters/fpml:calculationParameters/fpml:calculationMethod"/>
</xsl:when>
<xsl:when test="$swShortFormTrade/fpml:swCrossCurrencyBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg]/fpml:calculationParameters/fpml:calculationMethod">
<xsl:value-of select="$swShortFormTrade/fpml:swCrossCurrencyBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg]/fpml:calculationParameters/fpml:calculationMethod"/>
</xsl:when>
</xsl:choose>
</xsl:if>
</CompoundingCalculationMethod>
<CompoundingCalculationMethod_2>
<xsl:if test="$productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS'">
<xsl:choose>
<xsl:when test="$floatingStream2/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:calculationMethod">
<xsl:value-of select="$floatingStream2/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:calculationMethod"/>
</xsl:when>
<xsl:when test="$swShortFormTrade/fpml:swBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg2]/fpml:calculationParameters/fpml:calculationMethod">
<xsl:value-of select="$swShortFormTrade/fpml:swBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg2]/fpml:calculationParameters/fpml:calculationMethod"/>
</xsl:when>
<xsl:when test="$swShortFormTrade/fpml:swCrossCurrencyBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg2]/fpml:calculationParameters/fpml:calculationMethod">
<xsl:value-of select="$swShortFormTrade/fpml:swCrossCurrencyBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg2]/fpml:calculationParameters/fpml:calculationMethod"/>
</xsl:when>
<xsl:when test="$swShortFormTrade/fpml:swCrossCurrencyIrsParameters/fpml:calculationParameters/fpml:calculationMethod">
<xsl:value-of select="$swShortFormTrade/fpml:swCrossCurrencyIrsParameters/fpml:calculationParameters/fpml:calculationMethod"/>
</xsl:when>
</xsl:choose>
</xsl:if>
</CompoundingCalculationMethod_2>
<ObservationMethod>
<xsl:if test="($productType='Single Currency Basis Swap' or $productType='OIS' or $productType='Cross Currency Basis Swap')">
<xsl:choose>
<xsl:when test="$floatingStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:lookback">Lookback</xsl:when>
<xsl:when test="$swShortFormTrade/fpml:swBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg]/fpml:calculationParameters/fpml:lookback">Lookback</xsl:when>
<xsl:when test="$swShortFormTrade/fpml:swOisParameters/fpml:calculationParameters/fpml:lookback">Lookback</xsl:when>
<xsl:when test="$swShortFormTrade/fpml:swCrossCurrencyBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg]/fpml:calculationParameters/fpml:lookback">Lookback</xsl:when>
<xsl:when test="$floatingStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:lockout">Lockout</xsl:when>
<xsl:when test="$swShortFormTrade/fpml:swBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg]/fpml:calculationParameters/fpml:lockout">Lockout</xsl:when>
<xsl:when test="$swShortFormTrade/fpml:swOisParameters/fpml:calculationParameters/fpml:lockout">Lockout</xsl:when>
<xsl:when test="$swShortFormTrade/fpml:swCrossCurrencyBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg]/fpml:calculationParameters/fpml:lockout">Lockout</xsl:when>
<xsl:when test="$floatingStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:observationShift">ObservationPeriodShift</xsl:when>
<xsl:when test="$swShortFormTrade/fpml:swBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg]/fpml:calculationParameters/fpml:observationShift">ObservationPeriodShift</xsl:when>
<xsl:when test="$swShortFormTrade/fpml:swOisParameters/fpml:calculationParameters/fpml:observationShift">ObservationPeriodShift</xsl:when>
<xsl:when test="$swShortFormTrade/fpml:swCrossCurrencyBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg]/fpml:calculationParameters/fpml:observationShift">ObservationPeriodShift</xsl:when>
</xsl:choose>
</xsl:if>
</ObservationMethod>
<ObservationMethod_2>
<xsl:if test="($productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS')">
<xsl:choose>
<xsl:when test="$floatingStream2/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:lookback">Lookback</xsl:when>
<xsl:when test="$swShortFormTrade/fpml:swBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg2]/fpml:calculationParameters/fpml:lookback">Lookback</xsl:when>
<xsl:when test="$swShortFormTrade/fpml:swCrossCurrencyBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg2]/fpml:calculationParameters/fpml:lookback">Lookback</xsl:when>
<xsl:when test="$swShortFormTrade/fpml:swCrossCurrencyIrsParameters/fpml:calculationParameters/fpml:lookback">Lookback</xsl:when>
<xsl:when test="$floatingStream2/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:lockout">Lockout</xsl:when>
<xsl:when test="$swShortFormTrade/fpml:swBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg2]/fpml:calculationParameters/fpml:lockout">Lockout</xsl:when>
<xsl:when test="$swShortFormTrade/fpml:swCrossCurrencyBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg2]/fpml:calculationParameters/fpml:lockout">Lockout</xsl:when>
<xsl:when test="$swShortFormTrade/fpml:swCrossCurrencyIrsParameters/fpml:calculationParameters/fpml:lockout">Lockout</xsl:when>
<xsl:when test="$floatingStream2/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:observationShift">ObservationPeriodShift</xsl:when>
<xsl:when test="$swShortFormTrade/fpml:swBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg2]/fpml:calculationParameters/fpml:observationShift">ObservationPeriodShift</xsl:when>
<xsl:when test="$swShortFormTrade/fpml:swCrossCurrencyBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg2]/fpml:calculationParameters/fpml:observationShift">ObservationPeriodShift</xsl:when>
<xsl:when test="$swShortFormTrade/fpml:swCrossCurrencyIrsParameters/fpml:calculationParameters/fpml:observationShift">ObservationPeriodShift</xsl:when>
</xsl:choose>
</xsl:if>
</ObservationMethod_2>
<OffsetDays>
<xsl:if test="($productType='Single Currency Basis Swap' or $productType='OIS' or $productType='Cross Currency Basis Swap')">
<xsl:choose>
<xsl:when test="$floatingStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:lookback/fpml:offsetDays or $floatingStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:lockout/fpml:offsetDays or $floatingStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:observationShift/fpml:offsetDays">
<xsl:value-of select="$floatingStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters//fpml:offsetDays"/>
</xsl:when>
<xsl:when test="$swShortFormTrade/fpml:swBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg]/fpml:calculationParameters/fpml:lookback/fpml:offsetDays or $swShortFormTrade/fpml:swBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg]/fpml:calculationParameters/fpml:lockout/fpml:offsetDays or $swShortFormTrade/fpml:swBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg]/fpml:calculationParameters/fpml:observationShift/fpml:offsetDays">
<xsl:value-of select="$swShortFormTrade/fpml:swBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg]/fpml:calculationParameters//fpml:offsetDays"/>
</xsl:when>
<xsl:when test="$swShortFormTrade/fpml:swOisParameters/fpml:calculationParameters/fpml:lookback/fpml:offsetDays or $swShortFormTrade/fpml:swOisParameters/fpml:calculationParameters/fpml:lockout/fpml:offsetDays or $swShortFormTrade/fpml:swOisParameters/calculationParameters/fpml:observationShift/fpml:offsetDays">
<xsl:value-of select="$swShortFormTrade/fpml:swOisParameters/fpml:calculationParameters//fpml:offsetDays"/>
</xsl:when>
<xsl:when test="$swShortFormTrade/fpml:swCrossCurrencyBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg]/fpml:calculationParameters/fpml:lookback/fpml:offsetDays or $swShortFormTrade/fpml:swCrossCurrencyBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg]/fpml:calculationParameters/fpml:lockout/fpml:offsetDays or $swShortFormTrade/fpml:swCrossCurrencyBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg]/fpml:calculationParameters/fpml:observationShift/fpml:offsetDays">
<xsl:value-of select="$swShortFormTrade/fpml:swCrossCurrencyBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg]/fpml:calculationParameters//fpml:offsetDays"/>
</xsl:when>
</xsl:choose>
</xsl:if>
</OffsetDays>
<OffsetDays_2>
<xsl:if test="($productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS')">
<xsl:choose>
<xsl:when test="$floatingStream2/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:lookback/fpml:offsetDays or $floatingStream2/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:lockout/fpml:offsetDays or $floatingStream2/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:observationShift/fpml:offsetDays">
<xsl:value-of select="$floatingStream2/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters//fpml:offsetDays"/>
</xsl:when>
<xsl:when test="$swShortFormTrade/fpml:swBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg2]/fpml:calculationParameters/fpml:lookback/fpml:offsetDays or $swShortFormTrade/fpml:swBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg2]/fpml:calculationParameters/fpml:lockout/fpml:offsetDays or $swShortFormTrade/fpml:swBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg2]/fpml:calculationParameters/fpml:observationShift/fpml:offsetDays">
<xsl:value-of select="$swShortFormTrade/fpml:swBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg2]/fpml:calculationParameters//fpml:offsetDays"/>
</xsl:when>
<xsl:when test="$swShortFormTrade/fpml:swCrossCurrencyBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg2]/fpml:calculationParameters/fpml:lookback/fpml:offsetDays or $swShortFormTrade/fpml:swCrossCurrencyBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg2]/fpml:calculationParameters/fpml:lockout/fpml:offsetDays or $swShortFormTrade/fpml:swCrossCurrencyBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg2]/fpml:calculationParameters/fpml:observationShift/fpml:offsetDays">
<xsl:value-of select="$swShortFormTrade/fpml:swCrossCurrencyBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg2]/fpml:calculationParameters//fpml:offsetDays"/>
</xsl:when>
<xsl:when test="$swShortFormTrade/fpml:swCrossCurrencyIrsParameters/fpml:calculationParameters/fpml:lookback/fpml:offsetDays or $swShortFormTrade/fpml:swCrossCurrencyIrsParameters/fpml:calculationParameters/fpml:lockout/fpml:offsetDays or $swShortFormTrade/fpml:swCrossCurrencyIrsParameters/fpml:calculationParameters/fpml:observationShift/fpml:offsetDays">
<xsl:value-of select="$swShortFormTrade/fpml:swCrossCurrencyIrsParameters/fpml:calculationParameters//
fpml:offsetDays"/>
</xsl:when>
</xsl:choose>
</xsl:if>
</OffsetDays_2>
<ObservationPeriodDates>
<xsl:if test="($productType='Single Currency Basis Swap' or $productType='OIS' or $productType='Cross Currency Basis Swap')">
<xsl:choose>
<xsl:when test="$floatingStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:observationShift/fpml:observationPeriodDates">
<xsl:value-of select="$floatingStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:observationShift/fpml:observationPeriodDates"/>
</xsl:when>
<xsl:when test="$swShortFormTrade/fpml:swBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg]/fpml:calculationParameters/fpml:observationShift/fpml:observationPeriodDates">
<xsl:value-of select="$swShortFormTrade/fpml:swBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg]/fpml:calculationParameters/fpml:observationShift/fpml:observationPeriodDates"/>
</xsl:when>
<xsl:when test="$swShortFormTrade/fpml:swOisParameters/fpml:calculationParameters/fpml:observationShift/fpml:observationPeriodDates">
<xsl:value-of select="$swShortFormTrade/fpml:swOisParameters/fpml:calculationParameters/fpml:observationShift/fpml:observationPeriodDates"/>
</xsl:when>
<xsl:when test="$swShortFormTrade/fpml:swCrossCurrencyBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg]/fpml:calculationParameters/fpml:observationShift/fpml:observationPeriodDates">
<xsl:value-of select="$swShortFormTrade/fpml:swCrossCurrencyBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg]/fpml:calculationParameters/fpml:observationShift/fpml:observationPeriodDates"/>
</xsl:when>
</xsl:choose>
</xsl:if>
</ObservationPeriodDates>
<ObservationPeriodDates_2>
<xsl:if test="($productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS')">
<xsl:choose>
<xsl:when test="$floatingStream2/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:observationShift/fpml:observationPeriodDates">
<xsl:value-of select="$floatingStream2/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:observationShift/fpml:observationPeriodDates"/>
</xsl:when>
<xsl:when test="$swShortFormTrade/fpml:swBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg2]/fpml:calculationParameters/fpml:observationShift/fpml:observationPeriodDates">
<xsl:value-of select="$swShortFormTrade/fpml:swBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg2]/fpml:calculationParameters/fpml:observationShift/fpml:observationPeriodDates"/>
</xsl:when>
<xsl:when test="$swShortFormTrade/fpml:swCrossCurrencyBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg2]/fpml:calculationParameters/fpml:observationShift/fpml:observationPeriodDates">
<xsl:value-of select="$swShortFormTrade/fpml:swCrossCurrencyBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg2]/fpml:calculationParameters/fpml:observationShift/fpml:observationPeriodDates"/>
</xsl:when>
<xsl:when test="$swShortFormTrade/fpml:swOisParameters/fpml:swCrossCurrencyIrsParameters/fpml:observationShift/fpml:observationPeriodDates">
<xsl:value-of select="$swShortFormTrade/fpml:swCrossCurrencyIrsParameters/fpml:calculationParameters/fpml:observationShift/fpml:observationPeriodDates"/>
</xsl:when>
</xsl:choose>
</xsl:if>
</ObservationPeriodDates_2>
<ObservationAdditionalBusinessDays>
<xsl:if test="($productType='Single Currency Basis Swap' or $productType='OIS' or $productType='Cross Currency Basis Swap')">
<xsl:choose>
<xsl:when test="$floatingStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:observationShift/fpml:additionalBusinessDays/fpml:businessCenters">
<xsl:apply-templates select="$floatingStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:observationShift/fpml:additionalBusinessDays/fpml:businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:when>
<xsl:when test="$swShortFormTrade/fpml:swBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg]/fpml:calculationParameters/fpml:observationShift/fpml:additionalBusinessDays/fpml:businessCenters">
<xsl:apply-templates select="$swShortFormTrade/fpml:swBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg]/fpml:calculationParameters/fpml:observationShift/fpml:additionalBusinessDays/fpml:businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:when>
<xsl:when test="$swShortFormTrade/fpml:swOisParameters/fpml:calculationParameters/fpml:observationShift/fpml:additionalBusinessDays/fpml:businessCenters">
<xsl:apply-templates select="$swShortFormTrade/fpml:swOisParameters/fpml:calculationParameters/fpml:observationShift/fpml:additionalBusinessDays/fpml:businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:when>
<xsl:when test="$swShortFormTrade/fpml:swCrossCurrencyBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg]/fpml:calculationParameters/fpml:observationShift/fpml:additionalBusinessDays/fpml:businessCenters">
<xsl:apply-templates select="$swShortFormTrade/fpml:swCrossCurrencyBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg]/fpml:calculationParameters/fpml:observationShift/fpml:additionalBusinessDays/fpml:businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:when>
</xsl:choose>
</xsl:if>
</ObservationAdditionalBusinessDays>
<ObservationAdditionalBusinessDays_2>
<xsl:if test="$productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS'">
<xsl:choose>
<xsl:when test="$floatingStream2/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:observationShift/fpml:additionalBusinessDays/fpml:businessCenters">
<xsl:apply-templates select="$floatingStream2/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:observationShift/fpml:additionalBusinessDays/fpml:businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:when>
<xsl:when test="$swShortFormTrade/fpml:swBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg2]/fpml:calculationParameters/fpml:observationShift/fpml:additionalBusinessDays/fpml:businessCenters">
<xsl:apply-templates select="$swShortFormTrade/fpml:swBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg2]/fpml:calculationParameters/fpml:observationShift/fpml:additionalBusinessDays/fpml:businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:when>
<xsl:when test="$swShortFormTrade/fpml:swCrossCurrencyBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg2]/fpml:calculationParameters/fpml:observationShift/fpml:additionalBusinessDays/fpml:businessCenters">
<xsl:apply-templates select="$swShortFormTrade/fpml:swCrossCurrencyBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg2]/fpml:calculationParameters/fpml:observationShift/fpml:additionalBusinessDays/fpml:businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:when>
<xsl:when test="$swShortFormTrade/fpml:swCrossCurrencyIrsParameters/fpml:calculationParameters/fpml:observationShift/fpml:additionalBusinessDays/fpml:businessCenters">
<xsl:apply-templates select="$swShortFormTrade/fpml:swCrossCurrencyIrsParameters/fpml:calculationParameters/fpml:observationShift/fpml:additionalBusinessDays/fpml:businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:when>
</xsl:choose>
</xsl:if>
</ObservationAdditionalBusinessDays_2>
<ObservationHolidayCentre>
<xsl:if test="($productType='Single Currency Basis Swap' or $productType='OIS' or $productType='Cross Currency Basis Swap')">
<xsl:choose>
<xsl:when test="$floatingStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:applicableBusinessDays/fpml:businessCenters">
<xsl:apply-templates select="$floatingStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:applicableBusinessDays/fpml:businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:when>
<xsl:when test="$swShortFormTrade/fpml:swBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg]/fpml:calculationParameters/fpml:applicableBusinessDays/fpml:businessCenters">
<xsl:apply-templates select="$swShortFormTrade/fpml:swBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg]/fpml:calculationParameters/fpml:applicableBusinessDays/fpml:businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:when>
<xsl:when test="$swShortFormTrade//fpml:swOisParameters/fpml:calculationParameters/fpml:applicableBusinessDays/fpml:businessCenters">
<xsl:apply-templates select="$swShortFormTrade//fpml:swOisParameters/fpml:calculationParameters/fpml:applicableBusinessDays/fpml:businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:when>
<xsl:when test="$swShortFormTrade/fpml:swCrossCurrencyBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg]/fpml:calculationParameters/fpml:applicableBusinessDays/fpml:businessCenters">
<xsl:apply-templates select="$swShortFormTrade/fpml:swCrossCurrencyBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg]/fpml:calculationParameters/fpml:applicableBusinessDays/fpml:businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:when>
</xsl:choose>
</xsl:if>
</ObservationHolidayCentre>
<ObservationHolidayCentre_2>
<xsl:if test="($productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS')">
<xsl:choose>
<xsl:when test="$floatingStream2/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:applicableBusinessDays/fpml:businessCenters">
<xsl:apply-templates select="$floatingStream2/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:applicableBusinessDays/fpml:businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:when>
<xsl:when test="$swShortFormTrade/fpml:swBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg2]/fpml:calculationParameters/fpml:applicableBusinessDays/fpml:businessCenters">
<xsl:apply-templates select="$swShortFormTrade/fpml:swBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg2]/fpml:calculationParameters/fpml:applicableBusinessDays/fpml:businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:when>
<xsl:when test="$swShortFormTrade/fpml:swCrossCurrencyBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg2]/fpml:calculationParameters/fpml:applicableBusinessDays/fpml:businessCenters">
<xsl:apply-templates select="$swShortFormTrade/fpml:swCrossCurrencyBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg2]/fpml:calculationParameters/fpml:applicableBusinessDays/fpml:businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:when>
<xsl:when test="$swShortFormTrade//fpml:swCrossCurrencyIrsParameters/fpml:calculationParameters/fpml:applicableBusinessDays/fpml:businessCenters">
<xsl:apply-templates select="$swShortFormTrade//fpml:swCrossCurrencyIrsParameters/fpml:calculationParameters/fpml:applicableBusinessDays/fpml:businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:when>
</xsl:choose>
</xsl:if>
</ObservationHolidayCentre_2>
<SpreadOverIndex>
<xsl:if test="$swLongFormTrade and ($productType='IRS' or $productType='OIS' or $productType='ZCInflationSwap' or $productType='CapFloor' or $productType='Swaption' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap')">
<xsl:choose>
<xsl:when test="$floatingStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:spreadSchedule/fpml:initialValue">
<xsl:value-of select="$floatingStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:spreadSchedule/fpml:initialValue"/>
</xsl:when>
<xsl:when test="$capFloorStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:spreadSchedule/fpml:initialValue">
<xsl:value-of select="$capFloorStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:spreadSchedule/fpml:initialValue"/>
</xsl:when>
<xsl:otherwise>0</xsl:otherwise>
</xsl:choose>
</xsl:if>
</SpreadOverIndex>
<SpreadOverIndex_2>
<xsl:if test="$swLongFormTrade and ($productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS')">
<xsl:choose>
<xsl:when test="$floatingStream2/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:spreadSchedule/fpml:initialValue">
<xsl:value-of select="$floatingStream2/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:spreadSchedule/fpml:initialValue"/>
</xsl:when>
<xsl:otherwise>0</xsl:otherwise>
</xsl:choose>
</xsl:if>
</SpreadOverIndex_2>
<FirstFixingRate>
<xsl:if test="$productType='IRS' or $productType='OIS' or $productType='ZCInflationSwap' or $productType='Swaption' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap'">
<xsl:choose>
<xsl:when test="$floatingStream/fpml:stubCalculationPeriodAmount/fpml:initialStub/fpml:stubRate">
<xsl:value-of select="$floatingStream/fpml:stubCalculationPeriodAmount/fpml:initialStub/fpml:stubRate"/>
</xsl:when>
<xsl:when test="$floatingStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:initialRate">
<xsl:value-of select="$floatingStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:initialRate"/>
</xsl:when>
<xsl:when test="$swShortFormTrade//fpml:initialRate and ($productType='IRS' or $productType='OIS')">
<xsl:value-of select="$swShortFormTrade//fpml:initialRate"/>
</xsl:when>
<xsl:when test="$swShortFormTrade/fpml:swBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg]/fpml:initialRate">
<xsl:value-of select="$swShortFormTrade/fpml:swBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg]/fpml:initialRate"/>
</xsl:when>
<xsl:when test="$swShortFormTrade/fpml:swCrossCurrencyBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg]/fpml:initialRate">
<xsl:value-of select="$swShortFormTrade/fpml:swCrossCurrencyBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg]/fpml:initialRate"/>
</xsl:when>
</xsl:choose>
</xsl:if>
</FirstFixingRate>
<FirstFixingRate_2>
<xsl:if test="$productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap'  or $productType='Cross Currency IRS'">
<xsl:choose>
<xsl:when test="$floatingStream2/fpml:stubCalculationPeriodAmount/fpml:initialStub/fpml:stubRate">
<xsl:value-of select="$floatingStream2/fpml:stubCalculationPeriodAmount/fpml:initialStub/fpml:stubRate"/>
</xsl:when>
<xsl:when test="$floatingStream2/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:initialRate">
<xsl:value-of select="$floatingStream2/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:initialRate"/>
</xsl:when>
<xsl:when test="$swShortFormTrade/fpml:swBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg2]/fpml:initialRate">
<xsl:value-of select="$swShortFormTrade/fpml:swBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg2]/fpml:initialRate"/>
</xsl:when>
<xsl:when test="$swShortFormTrade/fpml:swCrossCurrencyBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg2]/fpml:initialRate">
<xsl:value-of select="$swShortFormTrade/fpml:swCrossCurrencyBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg2]/fpml:initialRate"/>
</xsl:when>
<xsl:when test="$swShortFormTrade//fpml:swCrossCurrencyIrsParameters/fpml:initialRate">
<xsl:value-of select="$swShortFormTrade//fpml:swCrossCurrencyIrsParameters/fpml:initialRate"/>
</xsl:when>
</xsl:choose>
</xsl:if>
</FirstFixingRate_2>
<FixingDaysOffset>
<xsl:choose>
<xsl:when test="$productType='IRS' or $productType='OIS' or $productType='ZCInflationSwap' or $productType='Swaption' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap'">
<xsl:value-of select="$floatingStream/fpml:resetDates/fpml:fixingDates/fpml:periodMultiplier"/>
</xsl:when>
<xsl:when test="$productType='FRA'">
<xsl:value-of select="$fra/fpml:fixingDateOffset/fpml:periodMultiplier"/>
</xsl:when>
<xsl:when test="$productType='CapFloor'">
<xsl:value-of select="$capFloorStream/fpml:resetDates/fpml:fixingDates/fpml:periodMultiplier"/>
</xsl:when>
</xsl:choose>
</FixingDaysOffset>
<FixingDaysOffset_2>
<xsl:if test="$productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap'  or $productType='Cross Currency IRS'">
<xsl:value-of select="$floatingStream2/fpml:resetDates/fpml:fixingDates/fpml:periodMultiplier"/>
</xsl:if>
</FixingDaysOffset_2>
<FixingHolidayCentres>
<xsl:choose>
<xsl:when test="$productType='IRS'  or $productType='OIS' or $productType='ZCInflationSwap' or $productType='Swaption' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap'">
<xsl:apply-templates select="$floatingStream/fpml:resetDates/fpml:fixingDates/fpml:businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:when>
<xsl:when test="$productType='FRA'">
<xsl:apply-templates select="$fra/fpml:fixingDateOffset/fpml:businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:when>
<xsl:when test="$productType='CapFloor'">
<xsl:choose>
<xsl:when test="not($swExtendedTradeDetails/fpml:swCapFloorDetails/fpml:swFloatingRateFixingDate/fpml:unadjustedDate)">
<xsl:apply-templates select="$capFloorStream/fpml:resetDates/fpml:fixingDates/fpml:businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:when>
<xsl:otherwise>
<xsl:apply-templates select="$swExtendedTradeDetails/fpml:swCapFloorDetails/fpml:swFloatingRateFixingDate/fpml:dateAdjustments/fpml:businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
</xsl:choose>
</FixingHolidayCentres>
<FixingHolidayCentres_2>
<xsl:if test="$productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap'  or $productType='Cross Currency IRS'">
<xsl:apply-templates select="$floatingStream2/fpml:resetDates/fpml:fixingDates/fpml:businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:if>
</FixingHolidayCentres_2>
<ResetInArrears>
<xsl:choose>
<xsl:when test="$swLongFormTrade and ($productType='IRS' or $productType='OIS' or $productType='ZCInflationSwap' or $productType='Swaption' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap')">
<xsl:value-of select="string(boolean($floatingStream/fpml:resetDates[fpml:resetRelativeTo='CalculationPeriodEndDate']))"/>
</xsl:when>
<xsl:when test="$swLongFormTrade and $productType='CapFloor'">
<xsl:value-of select="string(boolean($capFloorStream/fpml:resetDates[fpml:resetRelativeTo='CalculationPeriodEndDate']))"/>
</xsl:when>
</xsl:choose>
</ResetInArrears>
<ResetInArrears_2>
<xsl:if test="$swLongFormTrade and ($productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS')">
<xsl:value-of select="string(boolean($floatingStream2/fpml:resetDates[fpml:resetRelativeTo='CalculationPeriodEndDate']))"/>
</xsl:if>
</ResetInArrears_2>
<FirstFixingDifferent>
<xsl:if test="$swLongFormTrade and ($productType='IRS' or $productType='OIS' or $productType='ZCInflationSwap' or $productType='Swaption' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap')">
<xsl:value-of select="string(boolean($floatingStream/fpml:resetDates/fpml:initialFixingDate))"/>
</xsl:if>
</FirstFixingDifferent>
<FirstFixingDifferent_2>
<xsl:if test="$swLongFormTrade and ($productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS')">
<xsl:value-of select="string(boolean($floatingStream2/fpml:resetDates/fpml:initialFixingDate))"/>
</xsl:if>
</FirstFixingDifferent_2>
<FirstFixingDaysOffset>
<xsl:if test="$productType='IRS' or $productType='OIS' or $productType='Swaption' or $productType='ZCInflationSwap' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap'">
<xsl:value-of select="$floatingStream/fpml:resetDates/fpml:initialFixingDate/fpml:periodMultiplier"/>
</xsl:if>
</FirstFixingDaysOffset>
<FirstFixingDaysOffset_2>
<xsl:if test="$productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap'  or $productType='Cross Currency IRS'">
<xsl:value-of select="$floatingStream2/fpml:resetDates/fpml:initialFixingDate/fpml:periodMultiplier"/>
</xsl:if>
</FirstFixingDaysOffset_2>
<FirstFixingHolidayCentres>
<xsl:if test="$productType='IRS' or $productType='OIS' or $productType='Swaption' or $productType='ZCInflationSwap' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap'">
<xsl:if test="$floatingStream/fpml:resetDates/fpml:initialFixingDate">
<xsl:apply-templates select="$floatingStream/fpml:resetDates/fpml:initialFixingDate/fpml:businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:if>
</xsl:if>
</FirstFixingHolidayCentres>
<FirstFixingHolidayCentres_2>
<xsl:if test="$productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap'  or $productType='Cross Currency IRS'">
<xsl:if test="$floatingStream2/fpml:resetDates/fpml:initialFixingDate">
<xsl:apply-templates select="$floatingStream2/fpml:resetDates/fpml:initialFixingDate/fpml:businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:if>
</xsl:if>
</FirstFixingHolidayCentres_2>
<PaymentHolidayCentres>
<xsl:choose>
<xsl:when test="$productType='IRS' or $productType='ZCInflationSwap' or $productType='OIS' or $productType='Swaption' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap'">
<xsl:apply-templates select="$floatingStream/fpml:paymentDates/fpml:paymentDatesAdjustments/fpml:businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:when>
<xsl:when test="$productType='FRA'">
<xsl:apply-templates select="$fra/fpml:paymentDate/fpml:dateAdjustments/fpml:businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:when>
<xsl:when test="$productType='CapFloor'">
<xsl:apply-templates select="$capFloorStream/fpml:paymentDates/fpml:paymentDatesAdjustments/fpml:businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:when>
<xsl:when test="$productType='Cross Currency IRS' or $productType='Fixed Fixed Swap'">
<xsl:apply-templates select="$fixedStream/fpml:paymentDates/fpml:paymentDatesAdjustments/fpml:businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:when>
</xsl:choose>
</PaymentHolidayCentres>
<PaymentHolidayCentres_2>
<xsl:choose>
<xsl:when test="$productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap'  or $productType='Cross Currency IRS'">
<xsl:apply-templates select="$floatingStream2/fpml:paymentDates/fpml:paymentDatesAdjustments/fpml:businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:when>
<xsl:when test="$productType='Cross Currency IRS'">
<xsl:apply-templates select="$floatingStream/fpml:paymentDates/fpml:paymentDatesAdjustments/fpml:businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:when>
<xsl:when test="$productType='Fixed Fixed Swap'">
<xsl:apply-templates select="$fixedStream2/fpml:paymentDates/fpml:paymentDatesAdjustments/fpml:businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:when>
<xsl:when test="$productType='IRS' or $productType='OIS'">
<xsl:apply-templates select="$fixedStream/fpml:paymentDates/fpml:paymentDatesAdjustments/fpml:businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:when>
</xsl:choose>
</PaymentHolidayCentres_2>
<PaymentLag>
<xsl:if test="$swLongFormTrade">
<xsl:choose>
<xsl:when test="$productType='IRS' or  $productType='OIS' or $productType='Swaption' or $productType='CapFloor' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap'">
<xsl:choose>
<xsl:when test="$floatingStream/fpml:paymentDates/fpml:paymentDaysOffset">
<xsl:value-of select="$floatingStream/fpml:paymentDates/fpml:paymentDaysOffset/fpml:periodMultiplier"/>
</xsl:when>
<xsl:when test="$capFloorStream/fpml:paymentDates/fpml:paymentDaysOffset">
<xsl:value-of select="$capFloorStream/fpml:paymentDates/fpml:paymentDaysOffset/fpml:periodMultiplier"/>
</xsl:when>
<xsl:otherwise>0</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType='Cross Currency IRS' or $productType='Fixed Fixed Swap'">
<xsl:choose>
<xsl:when test="$fixedStream/fpml:paymentDates/fpml:paymentDaysOffset">
<xsl:value-of select="$fixedStream/fpml:paymentDates/fpml:paymentDaysOffset/fpml:periodMultiplier"/>
</xsl:when>
<xsl:otherwise>0</xsl:otherwise>
</xsl:choose>
</xsl:when>
</xsl:choose>
</xsl:if>
</PaymentLag>
<PaymentLag_2>
<xsl:choose>
<xsl:when test="$swLongFormTrade and ($productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap'  or $productType='Cross Currency IRS')">
<xsl:choose>
<xsl:when test="$floatingStream2/fpml:paymentDates/fpml:paymentDaysOffset">
<xsl:value-of select="$floatingStream2/fpml:paymentDates/fpml:paymentDaysOffset/fpml:periodMultiplier"/>
</xsl:when>
<xsl:otherwise>0</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$swLongFormTrade and ($productType='Cross Currency IRS')">
<xsl:choose>
<xsl:when test="$floatingStream/fpml:paymentDates/fpml:paymentDaysOffset">
<xsl:value-of select="$floatingStream/fpml:paymentDates/fpml:paymentDaysOffset/fpml:periodMultiplier"/>
</xsl:when>
<xsl:otherwise>0</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$swLongFormTrade and ($productType='Fixed Fixed Swap')">
<xsl:choose>
<xsl:when test="$fixedStream2/fpml:paymentDates/fpml:paymentDaysOffset">
<xsl:value-of select="$fixedStream2/fpml:paymentDates/fpml:paymentDaysOffset/fpml:periodMultiplier"/>
</xsl:when>
<xsl:otherwise>0</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$swLongFormTrade and ($productType='OIS' or $productType='IRS')">
<xsl:choose>
<xsl:when test="$fixedStream/fpml:paymentDates/fpml:paymentDaysOffset">
<xsl:value-of select="$fixedStream/fpml:paymentDates/fpml:paymentDaysOffset/fpml:periodMultiplier"/>
</xsl:when>
<xsl:otherwise>0</xsl:otherwise>
</xsl:choose>
</xsl:when>
</xsl:choose>
</PaymentLag_2>
<RollHolidayCentres>
<xsl:choose>
<xsl:when test="$productType='IRS' or $productType='ZCInflationSwap' or $productType='OIS' or $productType='Swaption' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap'">
<xsl:choose>
<xsl:when test="$floatingStream/fpml:calculationPeriodDates/fpml:calculationPeriodDatesAdjustments/fpml:businessDayConvention != 'NONE'">
<xsl:apply-templates select="$floatingStream/fpml:calculationPeriodDates/fpml:calculationPeriodDatesAdjustments/fpml:businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:when>
<xsl:when test="$floatingStream/fpml:calculationPeriodDates/fpml:terminationDate/fpml:dateAdjustments/fpml:businessDayConvention != 'NONE'">
<xsl:apply-templates select="$floatingStream/fpml:calculationPeriodDates/fpml:terminationDate/fpml:dateAdjustments/fpml:businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:when>
<xsl:otherwise>
<xsl:apply-templates select="$floatingStream/fpml:calculationPeriodDates/fpml:effectiveDate/fpml:dateAdjustments/fpml:businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType='CapFloor'">
<xsl:choose>
<xsl:when test="$capFloorStream/fpml:calculationPeriodDates/fpml:relativeTerminationDate/fpml:businessDayConvention != ''">
<xsl:apply-templates select="$capFloorStream/fpml:calculationPeriodDates/fpml:relativeTerminationDate/fpml:businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:when>
<xsl:when test="$capFloorStream/fpml:calculationPeriodDates/fpml:calculationPeriodDatesAdjustments/fpml:businessDayConvention = 'NONE'">
<xsl:apply-templates select="$capFloorStream/fpml:paymentDates/fpml:paymentDatesAdjustments/fpml:businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:when>
<xsl:otherwise>
<xsl:apply-templates select="$capFloorStream/fpml:calculationPeriodDates/fpml:calculationPeriodDatesAdjustments/fpml:businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType='Cross Currency IRS' or $productType='Fixed Fixed Swap'">
<xsl:apply-templates select="$fixedStream/fpml:calculationPeriodDates/fpml:calculationPeriodDatesAdjustments/fpml:businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:when>
</xsl:choose>
</RollHolidayCentres>
<RollHolidayCentres_2>
<xsl:if test="$productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS'">
<xsl:choose>
<xsl:when test="$floatingStream2/fpml:calculationPeriodDates/fpml:calculationPeriodDatesAdjustments/fpml:businessDayConvention != 'NONE'">
<xsl:apply-templates select="$floatingStream2/fpml:calculationPeriodDates/fpml:calculationPeriodDatesAdjustments/fpml:businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:when>
<xsl:when test="$floatingStream2/fpml:calculationPeriodDates/fpml:terminationDate/fpml:dateAdjustments/fpml:businessDayConvention != 'NONE'">
<xsl:apply-templates select="$floatingStream2/fpml:calculationPeriodDates/fpml:terminationDate/fpml:dateAdjustments/fpml:businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:when>
<xsl:otherwise>
<xsl:apply-templates select="$floatingStream2/fpml:calculationPeriodDates/fpml:effectiveDate/fpml:dateAdjustments/fpml:businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="$productType='IRS'  or $productType='OIS'">
<xsl:choose>
<xsl:when test="$fixedStream/fpml:calculationPeriodDates/fpml:calculationPeriodDatesAdjustments/fpml:businessDayConvention != 'NONE'">
<xsl:apply-templates select="$fixedStream/fpml:calculationPeriodDates/fpml:calculationPeriodDatesAdjustments/fpml:businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:when>
<xsl:when test="$fixedStream/fpml:calculationPeriodDates/fpml:terminationDate/fpml:dateAdjustments/fpml:businessDayConvention != 'NONE'">
<xsl:apply-templates select="$fixedStream/fpml:calculationPeriodDates/fpml:terminationDate/fpml:dateAdjustments/fpml:businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:when>
<xsl:otherwise>
<xsl:apply-templates select="$fixedStream/fpml:calculationPeriodDates/fpml:effectiveDate/fpml:dateAdjustments/fpml:businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="$productType='Fixed Fixed Swap'">
<xsl:apply-templates select="$fixedStream2/fpml:calculationPeriodDates/fpml:calculationPeriodDatesAdjustments/fpml:businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:if>
</RollHolidayCentres_2>
<AdjustFixedStartDate>
<xsl:if test="$swLongFormTrade">
<xsl:if test="$productType='IRS' or $productType='ZCInflationSwap' or $productType='OIS' or $productType='Swaption' or $productType='Cross Currency IRS' or $productType='Fixed Fixed Swap'">
<xsl:variable name="effDateBusDayConv" select="string($fixedStream/fpml:calculationPeriodDates/fpml:effectiveDate/fpml:dateAdjustments/fpml:businessDayConvention)"/>
<xsl:choose>
<xsl:when test="$effDateBusDayConv='NONE'">false</xsl:when>
<xsl:otherwise>true</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:if>
</AdjustFixedStartDate>
<AdjustFixedStartDate_2>
<xsl:if test="$swLongFormTrade">
<xsl:if test="$productType='Fixed Fixed Swap'">
<xsl:variable name="effDateBusDayConv2" select="string($fixedStream2/fpml:calculationPeriodDates/fpml:effectiveDate/fpml:dateAdjustments/fpml:businessDayConvention)"/>
<xsl:variable name="norm" select="string($swTradeHeader/fpml:swNormalised)"/>
<xsl:choose>
<xsl:when test="$effDateBusDayConv2='NONE' and $norm!='true'">false</xsl:when>
<xsl:otherwise>true</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:if>
</AdjustFixedStartDate_2>
<AdjustFloatStartDate>
<xsl:if test="$swLongFormTrade">
<xsl:choose>
<xsl:when test="$productType='IRS' or $productType='ZCInflationSwap' or $productType='OIS' or $productType='Swaption' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap'">
<xsl:variable name="effDateBusDayConv" select="string($floatingStream/fpml:calculationPeriodDates/fpml:effectiveDate/fpml:dateAdjustments/fpml:businessDayConvention)"/>
<xsl:choose>
<xsl:when test="$effDateBusDayConv='NONE'">false</xsl:when>
<xsl:otherwise>true</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType='CapFloor'">
<xsl:variable name="effDateBusDayConv" select="string($capFloorStream/fpml:calculationPeriodDates/fpml:effectiveDate/fpml:dateAdjustments/fpml:businessDayConvention)"/>
<xsl:choose>
<xsl:when test="$effDateBusDayConv='NONE'">false</xsl:when>
<xsl:otherwise>true</xsl:otherwise>
</xsl:choose>
</xsl:when>
</xsl:choose>
</xsl:if>
</AdjustFloatStartDate>
<AdjustFloatStartDate_2>
<xsl:if test="$swLongFormTrade and ($productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS')">
<xsl:variable name="effDateBusDayConv2" select="string($floatingStream2/fpml:calculationPeriodDates/fpml:effectiveDate/fpml:dateAdjustments/fpml:businessDayConvention)"/>
<xsl:choose>
<xsl:when test="$effDateBusDayConv2='NONE'">false</xsl:when>
<xsl:otherwise>true</xsl:otherwise>
</xsl:choose>
</xsl:if>
</AdjustFloatStartDate_2>
<AdjustRollEnd>
<xsl:if test="$swLongFormTrade">
<xsl:if test="$productType='IRS' or $productType='ZCInflationSwap' or $productType='OIS' or $productType='Swaption' or $productType='Cross Currency IRS' or $productType='Fixed Fixed Swap'">
<xsl:variable name="fixedCalcPeriodBusDayConv" select="string($fixedStream/fpml:calculationPeriodDates/fpml:calculationPeriodDatesAdjustments/fpml:businessDayConvention)"/>
<xsl:choose>
<xsl:when test="$fixedCalcPeriodBusDayConv='NONE'">false</xsl:when>
<xsl:otherwise>true</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:if>
</AdjustRollEnd>
<AdjustRollEnd_2>
<xsl:if test="$swLongFormTrade">
<xsl:if test="$productType='Fixed Fixed Swap'">
<xsl:variable name="fixedCalcPeriodBusDayConv2" select="string($fixedStream2/fpml:calculationPeriodDates/fpml:calculationPeriodDatesAdjustments/fpml:businessDayConvention)"/>
<xsl:choose>
<xsl:when test="$fixedCalcPeriodBusDayConv2='NONE'">false</xsl:when>
<xsl:otherwise>true</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:if>
</AdjustRollEnd_2>
<AdjustFloatRollEnd>
<xsl:choose>
<xsl:when test="$productType='IRS' or $productType='OIS' or $productType='Swaption' or $productType='Single Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='Cross Currency Basis Swap' or $productType='ZCInflationSwap'">
<xsl:choose>
<xsl:when test="$floatingStream/fpml:calculationPeriodDates/fpml:calculationPeriodDatesAdjustments/fpml:businessDayConvention = 'NONE'">false</xsl:when>
<xsl:otherwise>true</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType='CapFloor'">
<xsl:choose>
<xsl:when test="$capFloorStream/fpml:calculationPeriodDates/fpml:calculationPeriodDatesAdjustments/fpml:businessDayConvention = 'NONE'">false</xsl:when>
<xsl:otherwise>true</xsl:otherwise>
</xsl:choose>
</xsl:when>
</xsl:choose>
</AdjustFloatRollEnd>
<AdjustFloatRollEnd_2>
<xsl:if test="$productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS'">
<xsl:choose>
<xsl:when test="$floatingStream2/fpml:calculationPeriodDates/fpml:calculationPeriodDatesAdjustments/fpml:businessDayConvention = 'NONE'">false</xsl:when>
<xsl:otherwise>true</xsl:otherwise>
</xsl:choose>
</xsl:if>
</AdjustFloatRollEnd_2>
<AdjustFixedFinalRollEnd>
<xsl:if test="$swLongFormTrade">
<xsl:if test="$productType='IRS' or $productType='ZCInflationSwap' or $productType='OIS' or $productType='Swaption' or $productType='Cross Currency IRS' or $productType='Fixed Fixed Swap'">
<xsl:variable name="termDateBusDayConv" select="string($fixedStream/fpml:calculationPeriodDates/fpml:terminationDate/fpml:dateAdjustments/fpml:businessDayConvention)"/>
<xsl:choose>
<xsl:when test="$termDateBusDayConv='NONE'">false</xsl:when>
<xsl:otherwise>true</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:if>
</AdjustFixedFinalRollEnd>
<AdjustFixedFinalRollEnd_2>
<xsl:if test="$swLongFormTrade">
<xsl:if test="$productType='Fixed Fixed Swap'">
<xsl:variable name="termDateBusDayConv2" select="string($fixedStream2/fpml:calculationPeriodDates/fpml:terminationDate/fpml:dateAdjustments/fpml:businessDayConvention)"/>
<xsl:choose>
<xsl:when test="$termDateBusDayConv2='NONE'">false</xsl:when>
<xsl:otherwise>true</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:if>
</AdjustFixedFinalRollEnd_2>
<AdjustFinalRollEnd>
<xsl:if test="$swLongFormTrade">
<xsl:choose>
<xsl:when test="$productType='IRS' or $productType='ZCInflationSwap' or $productType='OIS' or $productType='Swaption' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap'">
<xsl:variable name="termDateBusDayConv" select="string($floatingStream/fpml:calculationPeriodDates/fpml:terminationDate/fpml:dateAdjustments/fpml:businessDayConvention)"/>
<xsl:choose>
<xsl:when test="$termDateBusDayConv='NONE'">false</xsl:when>
<xsl:otherwise>true</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType='CapFloor'">
<xsl:variable name="termDateBusDayConv" select="string($capFloorStream/fpml:calculationPeriodDates/fpml:terminationDate/fpml:dateAdjustments/fpml:businessDayConvention)"/>
<xsl:choose>
<xsl:when test="$termDateBusDayConv='NONE'">false</xsl:when>
<xsl:otherwise>true</xsl:otherwise>
</xsl:choose>
</xsl:when>
</xsl:choose>
</xsl:if>
</AdjustFinalRollEnd>
<AdjustFinalRollEnd_2>
<xsl:if test="$swLongFormTrade and ($productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS')">
<xsl:variable name="termDateBusDayConv2" select="string($floatingStream2/fpml:calculationPeriodDates/fpml:terminationDate/fpml:dateAdjustments/fpml:businessDayConvention)"/>
<xsl:choose>
<xsl:when test="$termDateBusDayConv2='NONE'">false</xsl:when>
<xsl:otherwise>true</xsl:otherwise>
</xsl:choose>
</xsl:if>
</AdjustFinalRollEnd_2>
<CompoundingMethod>
<xsl:if test="$swLongFormTrade">
<xsl:choose>
<xsl:when test="$productType='IRS' or $productType='OIS' or $productType='ZCInflationSwap' or $productType='Swaption' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap'">
<xsl:variable name="compoundingMethod" select="string($floatingStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:compoundingMethod)"/>
<xsl:choose>
<xsl:when test="$compoundingMethod='Flat'">F</xsl:when>
<xsl:when test="$compoundingMethod='Straight'">S</xsl:when>
<xsl:when test="$compoundingMethod='SpreadExclusive'">E</xsl:when>
<xsl:otherwise>N</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType='CapFloor'">
<xsl:variable name="compoundingMethod" select="string($capFloorStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:compoundingMethod)"/>
<xsl:choose>
<xsl:when test="$compoundingMethod='Flat'">F</xsl:when>
<xsl:when test="$compoundingMethod='Straight'">S</xsl:when>
<xsl:when test="$compoundingMethod='SpreadExclusive'">E</xsl:when>
<xsl:otherwise>N</xsl:otherwise>
</xsl:choose>
</xsl:when>
</xsl:choose>
</xsl:if>
<xsl:if test="$swShortFormTrade and (($productType='IRS') or ($productType='OIS') or ($productType='Swaption') or ($productType='Fixed Fixed Swap'))">
<xsl:variable name="compoundingMethod" select="string($swShortFormTrade//fpml:swCompoundingMethod)"/>
<xsl:choose>
<xsl:when test="$compoundingMethod='Flat'">F</xsl:when>
<xsl:when test="$compoundingMethod='Straight'">S</xsl:when>
<xsl:when test="$compoundingMethod='SpreadExclusive'">E</xsl:when>
<xsl:when test="$compoundingMethod='None'">N</xsl:when>
<xsl:otherwise>
<xsl:if test="$swShortFormTrade//fpml:swFloatPaymentFrequency and $swShortFormTrade//fpml:swRollFrequency">
<xsl:if test="($swShortFormTrade//fpml:swFloatPaymentFrequency/fpml:periodMultiplier=$swShortFormTrade//fpml:swRollFrequency/fpml:periodMultiplier) and ($swShortFormTrade//fpml:swFloatPaymentFrequency/fpml:period=$swShortFormTrade//fpml:swRollFrequency/fpml:period)">N</xsl:if>
</xsl:if>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="$swShortFormTrade and ($productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap')">
<xsl:variable name="compoundingMethod" select="string($swShortFormTrade//fpml:swFloatingRateCalculation[position()=$floatingLeg]/fpml:swCompoundingMethod)"/>
<xsl:choose>
<xsl:when test="$compoundingMethod='Flat'">F</xsl:when>
<xsl:when test="$compoundingMethod='Straight'">S</xsl:when>
<xsl:when test="$compoundingMethod='SpreadExclusive'">E</xsl:when>
<xsl:when test="$compoundingMethod='None'">N</xsl:when>
<xsl:otherwise>N</xsl:otherwise>
</xsl:choose>
</xsl:if>
</CompoundingMethod>
<CompoundingMethod_2>
<xsl:if test="$swLongFormTrade and ($productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS')">
<xsl:variable name="compoundingMethod" select="string($floatingStream2/fpml:calculationPeriodAmount/fpml:calculation/fpml:compoundingMethod)"/>
<xsl:choose>
<xsl:when test="$compoundingMethod='Flat'">F</xsl:when>
<xsl:when test="$compoundingMethod='Straight'">S</xsl:when>
<xsl:when test="$compoundingMethod='SpreadExclusive'">E</xsl:when>
<xsl:otherwise>N</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="$swShortFormTrade and ($productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='Fixed Fixed Swap')">
<xsl:variable name="compoundingMethod" select="string($swShortFormTrade//fpml:swFloatingRateCalculation[position()=$floatingLeg2]/fpml:swCompoundingMethod |
$swShortFormTrade/fpml:swCrossCurrencyIrsParameters/fpml:swCompoundingMethod)"/>
<xsl:choose>
<xsl:when test="$compoundingMethod='Flat'">F</xsl:when>
<xsl:when test="$compoundingMethod='Straight'">S</xsl:when>
<xsl:when test="$compoundingMethod='SpreadExclusive'">E</xsl:when>
<xsl:when test="$compoundingMethod='None'">N</xsl:when>
<xsl:otherwise>N</xsl:otherwise>
</xsl:choose>
</xsl:if>
</CompoundingMethod_2>
<AveragingMethod>
<xsl:if test="$swLongFormTrade and $productType='Single Currency Basis Swap'">
<xsl:variable name="averagingMethod" select="string($floatingStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:averagingMethod)"/>
<xsl:choose>
<xsl:when test="$averagingMethod='Unweighted'">U</xsl:when>
<xsl:when test="$averagingMethod='Weighted'">W</xsl:when>
<xsl:otherwise>N</xsl:otherwise>
</xsl:choose>
</xsl:if>
</AveragingMethod>
<AveragingMethod_2>
<xsl:if test="$swLongFormTrade and $productType='Single Currency Basis Swap'">
<xsl:variable name="averagingMethod2" select="string($floatingStream2/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:averagingMethod)"/>
<xsl:choose>
<xsl:when test="$averagingMethod2='Unweighted'">U</xsl:when>
<xsl:when test="$averagingMethod2='Weighted'">W</xsl:when>
<xsl:otherwise>N</xsl:otherwise>
</xsl:choose>
</xsl:if>
</AveragingMethod_2>
<FloatingRateMultiplier>
<xsl:if test="$productType='Single Currency Basis Swap'">
<xsl:value-of select="$floatingStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:floatingRateMultiplierSchedule/fpml:initialValue"/>
<xsl:value-of select="$swShortFormTrade/fpml:swBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg]/fpml:swFloatingRateMultiplier"/>
</xsl:if>
</FloatingRateMultiplier>
<FloatingRateMultiplier_2>
<xsl:if test="$productType='Single Currency Basis Swap'">
<xsl:value-of select="$floatingStream2/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:floatingRateMultiplierSchedule/fpml:initialValue"/>
<xsl:value-of select="$swShortFormTrade/fpml:swBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg2]/fpml:swFloatingRateMultiplier"/>
</xsl:if>
</FloatingRateMultiplier_2>
<DesignatedMaturity>
<xsl:choose>
<xsl:when test="$swLongFormTrade  and ($productType='IRS' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap')">
<xsl:call-template name="formatInterval">
<xsl:with-param name="interval" select="$floatingStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:indexTenor"/>
</xsl:call-template>
</xsl:when>
<xsl:when test="$swLongFormTrade  and ($productType='Fixed Fixed Swap')">
<xsl:call-template name="formatInterval">
<xsl:with-param name="interval" select="$fixedStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:fixedRateCalculation/fpml:indexTenor"/>
</xsl:call-template>
</xsl:when>
<xsl:when test="$swShortFormTrade and $productType='Single Currency Basis Swap'">
<xsl:call-template name="formatInterval">
<xsl:with-param name="interval" select="$swShortFormTrade/fpml:swBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg]/fpml:indexTenor"/>
</xsl:call-template>
</xsl:when>
<xsl:when test="$swShortFormTrade and $productType='Cross Currency Basis Swap'">
<xsl:call-template name="formatInterval">
<xsl:with-param name="interval" select="$swShortFormTrade/fpml:swCrossCurrencyBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg]/fpml:indexTenor"/>
</xsl:call-template>
</xsl:when>
</xsl:choose>
</DesignatedMaturity>
<DesignatedMaturity_2>
<xsl:choose>
<xsl:when test="$swLongFormTrade  and ($productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS')">
<xsl:call-template name="formatInterval">
<xsl:with-param name="interval" select="$floatingStream2/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:indexTenor"/>
</xsl:call-template>
</xsl:when>
<xsl:when test="$swLongFormTrade  and ($productType='Fixed Fixed Swap')">
<xsl:call-template name="formatInterval">
<xsl:with-param name="interval" select="$fixedStream2/fpml:calculationPeriodAmount/fpml:calculation/fpml:fixedRateCalculation/fpml:indexTenor"/>
</xsl:call-template>
</xsl:when>
<xsl:when test="$swShortFormTrade and $productType='Single Currency Basis Swap'">
<xsl:call-template name="formatInterval">
<xsl:with-param name="interval" select="$swShortFormTrade/fpml:swBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg2]/fpml:indexTenor"/>
</xsl:call-template>
</xsl:when>
<xsl:when test="$swShortFormTrade and $productType='Cross Currency Basis Swap'">
<xsl:call-template name="formatInterval">
<xsl:with-param name="interval" select="$swShortFormTrade/fpml:swCrossCurrencyBasisSwapParameters/fpml:swFloatingRateCalculation[position()=$floatingLeg2]/fpml:indexTenor"/>
</xsl:call-template>
</xsl:when>
<xsl:when test="$swShortFormTrade and $productType='Cross Currency IRS'">
<xsl:call-template name="formatInterval">
<xsl:with-param name="interval" select="$swShortFormTrade/fpml:swCrossCurrencyIrsParameters/fpml:indexTenor"/>
</xsl:call-template>
</xsl:when>
</xsl:choose>
</DesignatedMaturity_2>
<ResetFreq>
<xsl:if test="$swLongFormTrade and $productType='Single Currency Basis Swap'">
<xsl:call-template name="formatInterval">
<xsl:with-param name="interval" select="$floatingStream/fpml:resetDates/fpml:resetFrequency"/>
</xsl:call-template>
</xsl:if>
</ResetFreq>
<ResetFreq_2>
<xsl:if test="$swLongFormTrade and $productType='Single Currency Basis Swap'">
<xsl:call-template name="formatInterval">
<xsl:with-param name="interval" select="$floatingStream2/fpml:resetDates/fpml:resetFrequency"/>
</xsl:call-template>
</xsl:if>
</ResetFreq_2>
<WeeklyRollConvention>
<xsl:if test="$swLongFormTrade  and $productType='Single Currency Basis Swap'">
<xsl:value-of select="$floatingStream/fpml:resetDates/fpml:resetFrequency/fpml:weeklyRollConvention"/>
</xsl:if>
</WeeklyRollConvention>
<WeeklyRollConvention_2>
<xsl:if test="$swLongFormTrade  and $productType='Single Currency Basis Swap'">
<xsl:value-of select="$floatingStream2/fpml:resetDates/fpml:resetFrequency/fpml:weeklyRollConvention"/>
</xsl:if>
</WeeklyRollConvention_2>
<RateCutOffDays>
<xsl:if test="$swLongFormTrade  and $productType='Single Currency Basis Swap'">
<xsl:value-of select="$floatingStream/fpml:resetDates/fpml:rateCutOffDaysOffset/fpml:periodMultiplier"/>
</xsl:if>
</RateCutOffDays>
<RateCutOffDays_2>
<xsl:if test="$swLongFormTrade  and $productType='Single Currency Basis Swap'">
<xsl:value-of select="$floatingStream2/fpml:resetDates/fpml:rateCutOffDaysOffset/fpml:periodMultiplier"/>
</xsl:if>
</RateCutOffDays_2>
<InitialExchange>
<xsl:if test="$productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='ZCInflationSwap'">
<xsl:choose>
<xsl:when test="$swLongFormTrade">
<xsl:value-of select="string(boolean($floatingStream/fpml:principalExchanges/fpml:initialExchange='true'))"/>
</xsl:when>
<xsl:when test="$swShortFormTrade">
<xsl:value-of select="string(boolean($swShortFormTrade//fpml:principalExchanges/fpml:initialExchange='true'))"/>
</xsl:when>
</xsl:choose>
</xsl:if>
<xsl:if test="$productType='Fixed Fixed Swap'">
<xsl:choose>
<xsl:when test="$swShortFormTrade">
<xsl:value-of select="string(boolean($swShortFormTrade//fpml:principalExchanges/fpml:initialExchange='true'))"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="string(boolean($fixedStream2/fpml:principalExchanges/fpml:initialExchange='true'))"/>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</InitialExchange>
<FinalExchange>
<xsl:if test="$productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS'">
<xsl:choose>
<xsl:when test="$swLongFormTrade">
<xsl:value-of select="string(boolean($floatingStream/fpml:principalExchanges/fpml:finalExchange='true'))"/>
</xsl:when>
<xsl:when test="$swShortFormTrade">
<xsl:value-of select="string(boolean($swShortFormTrade//fpml:principalExchanges/fpml:finalExchange='true'))"/>
</xsl:when>
</xsl:choose>
</xsl:if>
<xsl:if test="$productType='ZCInflationSwap'">
<xsl:choose>
<xsl:when test="$swLongFormTrade">
<xsl:choose>
<xsl:when test="$floatingStream/fpml:principalExchanges/fpml:finalExchange">
<xsl:value-of select="string(boolean($floatingStream/fpml:principalExchanges/fpml:finalExchange='true'))"/>
</xsl:when>
<xsl:otherwise>true</xsl:otherwise>
</xsl:choose>
</xsl:when>
</xsl:choose>
</xsl:if>
<xsl:if test="$productType='Fixed Fixed Swap'">
<xsl:choose>
<xsl:when test="$swShortFormTrade">
<xsl:value-of select="string(boolean($swShortFormTrade//fpml:principalExchanges/fpml:finalExchange='true'))"/>
</xsl:when>
<xsl:when test="$swLongFormTrade">
<xsl:value-of select="string(boolean($fixedStream2/fpml:principalExchanges/fpml:finalExchange='true'))"/>
</xsl:when>
</xsl:choose>
</xsl:if>
</FinalExchange>
<MarkToMarket>
<xsl:if test="$productType='Cross Currency Basis Swap'  or $productType='Cross Currency IRS'">
<xsl:choose>
<xsl:when test="$swLongFormTrade">
<xsl:value-of select="string(boolean($floatingStream2/fpml:calculationPeriodAmount/fpml:calculation/fpml:fxLinkedNotionalSchedule))"/>
</xsl:when>
<xsl:when test="$swShortFormTrade">
<xsl:value-of select="string(boolean($swShortFormTrade//fpml:principalExchanges/fpml:intermediateExchange='true'))"/>
</xsl:when>
</xsl:choose>
</xsl:if>
<xsl:if test="$productType='Fixed Fixed Swap'">
<xsl:choose>
<xsl:when test="$swLongFormTrade">
<xsl:value-of select="string(boolean($fixedStream2/fpml:calculationPeriodAmount/fpml:calculation/fpml:fxLinkedNotionalSchedule))"/>
</xsl:when>
<xsl:when test="$swShortFormTrade">
<xsl:value-of select="string(boolean($swShortFormTrade//fpml:principalExchanges/fpml:intermediateExchange='true'))"/>
</xsl:when>
</xsl:choose>
</xsl:if>
</MarkToMarket>
<IntermediateExchange>
<xsl:if test="$productType='Cross Currency IRS'">
<xsl:choose>
<xsl:when test="$swLongFormTrade">
<xsl:value-of select="string(boolean($floatingStream/fpml:principalExchanges/fpml:intermediateExchange='true'))"/>
</xsl:when>
<xsl:when test="$swShortFormTrade">
<xsl:value-of select="string(boolean($swShortFormTrade/fpml:swCrossCurrencyIrsParameters/fpml:principalExchanges/fpml:intermediateExchange='true'))"/>
</xsl:when>
</xsl:choose>
</xsl:if>
<xsl:if test="$productType='ZCInflationSwap'">
<xsl:choose>
<xsl:when test="$swLongFormTrade">
<xsl:value-of select="string(boolean($floatingStream/fpml:principalExchanges/fpml:intermediateExchange='true'))"/>
</xsl:when>
<xsl:when test="$swShortFormTrade">
<xsl:value-of select="string(boolean($swShortFormTrade//fpml:principalExchanges/fpml:intermediateExchange='true'))"/>
</xsl:when>
</xsl:choose>
</xsl:if>
<xsl:if test="$productType='Fixed Fixed Swap'">
<xsl:choose>
<xsl:when test="$swLongFormTrade">
<xsl:value-of select="string(boolean($fixedStream2/fpml:principalExchanges/fpml:intermediateExchange='true'))"/>
</xsl:when>
<xsl:when test="$swShortFormTrade">
<xsl:value-of select="string(boolean($swShortFormTrade/fpml:swFixedFixedParameters/fpml:principalExchanges/fpml:intermediateExchange='true'))"/>
</xsl:when>
</xsl:choose>
</xsl:if>
<xsl:if test="$productType='Cross Currency Basis Swap'">
<xsl:choose>
<xsl:when test="$swLongFormTrade">
<xsl:choose>
<xsl:when test="$floatingStream/fpml:principalExchanges/fpml:intermediateExchange">
<xsl:value-of select="string(boolean($floatingStream/fpml:principalExchanges/fpml:intermediateExchange='true'))"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="string(boolean($floatingStream2/fpml:calculationPeriodAmount/fpml:calculation/fpml:fxLinkedNotionalSchedule))"/>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$swShortFormTrade">
<xsl:value-of select="string(boolean($swShortFormTrade//fpml:principalExchanges/fpml:intermediateExchange='true'))"/>
</xsl:when>
</xsl:choose>
</xsl:if>
</IntermediateExchange>
<FallbackBondApplicable>
<xsl:if test="$productType='ZCInflationSwap'">
<xsl:value-of select="//fpml:swInflationSwapDetails/fpml:swfallbackBondApplicable"/>
</xsl:if>
</FallbackBondApplicable>
<CalculationMethod>
<xsl:if test="$productType='ZCInflationSwap'">
<xsl:value-of select="//fpml:swInflationSwapDetails/fpml:swCalculationMethod"/>
</xsl:if>
</CalculationMethod>
<CalculationStyle>
<xsl:if test="$productType='ZCInflationSwap'">
<xsl:value-of select="//fpml:swInflationSwapDetails/fpml:swCalculationStyle"/>
</xsl:if>
</CalculationStyle>
<FinalPriceExchangeCalc>
<xsl:if test="$productType='ZCInflationSwap'">
<xsl:value-of select="//fpml:swInflationSwapDetails/fpml:swFinalPrincipalExchangeCalculation/fpml:swFloored"/>
</xsl:if>
</FinalPriceExchangeCalc>
<SpreadCalculationMethod>
<xsl:if test="$productType='ZCInflationSwap'">
<xsl:value-of select="//fpml:swInflationSwapDetails/fpml:swSpreadCalculationMethod"/>
</xsl:if>
</SpreadCalculationMethod>
<CouponRate>
<xsl:if test="$productType='ZCInflationSwap'">
<xsl:value-of select="$swap/fpml:additionalTerms/fpml:bondReference/fpml:bond/fpml:couponRate"/>
</xsl:if>
</CouponRate>
<Maturity>
<xsl:if test="$productType='ZCInflationSwap'">
<xsl:value-of select="$swap/fpml:additionalTerms/fpml:bondReference/fpml:bond/fpml:maturity"/>
</xsl:if>
</Maturity>
<RelatedBondValue>
<xsl:if test="$productType='ZCInflationSwap'">
<xsl:value-of select="$swap/fpml:additionalTerms/fpml:bondReference/fpml:bond/fpml:instrumentId"/>
</xsl:if>
</RelatedBondValue>
<RelatedBondID>
<xsl:if test="$productType='ZCInflationSwap'">
<xsl:value-of select="$swap/fpml:additionalTerms/fpml:bondReference/fpml:bond/fpml:instrumentId/@instrumentIdScheme"/>
</xsl:if>
</RelatedBondID>
<MTMRateSource>
<xsl:if test="$productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS'">
<xsl:value-of select="$floatingStream2/fpml:calculationPeriodAmount/fpml:calculation/fpml:fxLinkedNotionalSchedule/fpml:fxSpotRateSource/fpml:primaryRateSource/fpml:rateSource"/>
</xsl:if>
<xsl:if test="$productType='Fixed Fixed Swap'">
<xsl:value-of select="$fixedStream2/fpml:calculationPeriodAmount/fpml:calculation/fpml:fxLinkedNotionalSchedule/fpml:fxSpotRateSource/fpml:primaryRateSource/fpml:rateSource"/>
</xsl:if>
</MTMRateSource>
<MTMRateSourcePage>
<xsl:if test="$productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS'">
<xsl:value-of select="$floatingStream2/fpml:calculationPeriodAmount/fpml:calculation/fpml:fxLinkedNotionalSchedule/fpml:fxSpotRateSource/fpml:primaryRateSource/fpml:rateSourcePage"/>
</xsl:if>
<xsl:if test="$productType='Fixed Fixed Swap'">
<xsl:value-of select="$fixedStream2/fpml:calculationPeriodAmount/fpml:calculation/fpml:fxLinkedNotionalSchedule/fpml:fxSpotRateSource/fpml:primaryRateSource/fpml:rateSourcePage"/>
</xsl:if>
</MTMRateSourcePage>
<MTMFixingDate>
<xsl:if test="$productType='Cross Currency Basis Swap'  or $productType='Cross Currency IRS'">
<xsl:value-of select="$floatingStream2/fpml:calculationPeriodAmount/fpml:calculation/fpml:fxLinkedNotionalSchedule/fpml:varyingNotionalFixingDates/fpml:periodMultiplier"/>
</xsl:if>
<xsl:if test="$productType='Fixed Fixed Swap'">
<xsl:value-of select="$fixedStream2/fpml:calculationPeriodAmount/fpml:calculation/fpml:fxLinkedNotionalSchedule/fpml:varyingNotionalFixingDates/fpml:periodMultiplier"/>
</xsl:if>
</MTMFixingDate>
<MTMFixingHolidayCentres>
<xsl:if test="$productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS'">
<xsl:if test="$floatingStream2/fpml:calculationPeriodAmount/fpml:calculation/fpml:fxLinkedNotionalSchedule">
<xsl:apply-templates select="$floatingStream2/fpml:calculationPeriodAmount/fpml:calculation/fpml:fxLinkedNotionalSchedule/fpml:varyingNotionalFixingDates/fpml:businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:if>
</xsl:if>
<xsl:if test="$productType='Fixed Fixed Swap'">
<xsl:if test="$fixedStream2/fpml:calculationPeriodAmount/fpml:calculation/fpml:fxLinkedNotionalSchedule">
<xsl:apply-templates select="$fixedStream2/fpml:calculationPeriodAmount/fpml:calculation/fpml:fxLinkedNotionalSchedule/fpml:varyingNotionalFixingDates/fpml:businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:if>
</xsl:if>
</MTMFixingHolidayCentres>
<MTMFixingTime>
<xsl:if test="$productType='Cross Currency Basis Swap'  or $productType='Cross Currency IRS'">
<xsl:if test="$floatingStream2/fpml:calculationPeriodAmount/fpml:calculation/fpml:fxLinkedNotionalSchedule">
<xsl:call-template name="formatTime">
<xsl:with-param name="time" select="string($floatingStream2/fpml:calculationPeriodAmount/fpml:calculation/fpml:fxLinkedNotionalSchedule/fpml:fxSpotRateSource/fpml:fixingTime/fpml:hourMinuteTime)"/>
</xsl:call-template>
</xsl:if>
</xsl:if>
<xsl:if test="$productType='Fixed Fixed Swap'">
<xsl:if test="$fixedStream2/fpml:calculationPeriodAmount/fpml:calculation/fpml:fxLinkedNotionalSchedule">
<xsl:call-template name="formatTime">
<xsl:with-param name="time" select="string($fixedStream2/fpml:calculationPeriodAmount/fpml:calculation/fpml:fxLinkedNotionalSchedule/fpml:fxSpotRateSource/fpml:fixingTime/fpml:hourMinuteTime)"/>
</xsl:call-template>
</xsl:if>
</xsl:if>
</MTMFixingTime>
<MTMLocation>
<xsl:if test="$productType='Cross Currency Basis Swap'  or $productType='Cross Currency IRS'">
<xsl:value-of select="$floatingStream2/fpml:calculationPeriodAmount/fpml:calculation/fpml:fxLinkedNotionalSchedule/fpml:fxSpotRateSource/fpml:fixingTime/fpml:businessCenter"/>
</xsl:if>
<xsl:if test="$productType='Fixed Fixed Swap'">
<xsl:value-of select="$fixedStream2/fpml:calculationPeriodAmount/fpml:calculation/fpml:fxLinkedNotionalSchedule/fpml:fxSpotRateSource/fpml:fixingTime/fpml:businessCenter"/>
</xsl:if>
</MTMLocation>
<MTMCutoffTime>
<xsl:if test="$productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='Fixed Fixed Swap'">
<xsl:if test="$swExtendedTradeDetails/fpml:swFxCutoffTime">
<xsl:call-template name="formatTime">
<xsl:with-param name="time" select="string($swExtendedTradeDetails/fpml:swFxCutoffTime/fpml:hourMinuteTime)"/>
</xsl:call-template>
</xsl:if>
</xsl:if>
</MTMCutoffTime>
<CalculationPeriodDays>
<xsl:choose>
<xsl:when test="$productType='FRA'">
<xsl:value-of select="$fra/fpml:calculationPeriodNumberOfDays"/>
</xsl:when>
<xsl:when test="$productType='IRS' and $referenceCurrency='BRL'">
<xsl:value-of select="$swExtendedTradeDetails/fpml:swFutureValue/fpml:calculationPeriodNumberOfDays"/>
</xsl:when>
</xsl:choose>
</CalculationPeriodDays>
<FraDiscounting>
<xsl:if test="$productType='FRA'">
<xsl:choose>
<xsl:when test="$fra[fpml:fraDiscounting='ISDA']">true</xsl:when>
<xsl:when test="$fra[fpml:fraDiscounting='NONE']">false</xsl:when>
<xsl:otherwise>???</xsl:otherwise>
</xsl:choose>
</xsl:if>
</FraDiscounting>
<HasBreak>
<xsl:if test="$productType='IRS' or  $productType='ZCInflationSwap' or $productType='Swaption' or $productType='Single Currency Basis Swap' or $productType='CapFloor' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='OIS' or $productType='Fixed Fixed Swap'">
<xsl:choose>
<xsl:when test="$swShortFormTrade//fpml:swEarlyTerminationProvision">true</xsl:when>
<xsl:when test="$swExtendedTradeDetails/fpml:swEarlyTerminationProvision">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:if>
</HasBreak>
<BreakFromSwap>
<xsl:if test="$productType='IRS' or $productType='ZCInflationSwap' or $productType='Swaption' or $productType='Single Currency Basis Swap' or $productType='CapFloor' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='OIS' or $productType='Fixed Fixed Swap'">
<xsl:choose>
<xsl:when test="$swExtendedTradeDetails/fpml:swEarlyTerminationProvision/fpml:swBreakFirstDate[@offsetFromSwapEffectiveDate='true']">true</xsl:when>
<xsl:when test="$swShortFormTrade//fpml:swEarlyTerminationProvision/fpml:swBreakFirstDate[@offsetFromSwapEffectiveDate='true']">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:if>
</BreakFromSwap>
<BreakOverride>
<xsl:if test="$productType='IRS' or $productType='ZCInflationSwap' or $productType='Swaption' or $productType='Single Currency Basis Swap' or $productType='CapFloor' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='OIS' or $productType='Fixed Fixed Swap'">
<xsl:choose>
<xsl:when test="$swExtendedTradeDetails/fpml:swEarlyTerminationProvision/fpml:swBreakOverrideFirstDate">true</xsl:when>
<xsl:when test="$swShortFormTrade//fpml:swEarlyTerminationProvision/fpml:swBreakOverrideFirstDate">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:if>
</BreakOverride>
<BreakCalculationMethod>
<xsl:if test="$productType='IRS' or$productType='ZCInflationSwap' or $productType='Swaption' or $productType='Single Currency Basis Swap' or $productType='CapFloor' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='OIS' or $productType='Fixed Fixed Swap'">
<xsl:choose>
<xsl:when test="$swExtendedTradeDetails/fpml:swEarlyTerminationProvision/fpml:swBreakCalculationMethod='Adjust To Coupon Dates'">Adjusted</xsl:when>
<xsl:when test="$swShortFormTrade//fpml:swEarlyTerminationProvision/fpml:swBreakCalculationMethod='Adjust To Coupon Dates'">Adjusted</xsl:when>
<xsl:when test="$swExtendedTradeDetails/fpml:swEarlyTerminationProvision/fpml:swBreakCalculationMethod='Straight Calendar Dates'">Unadjusted</xsl:when>
<xsl:when test="$swShortFormTrade//fpml:swEarlyTerminationProvision/fpml:swBreakCalculationMethod='Straight Calendar Dates'">Unadjusted</xsl:when>
<xsl:when test="$swLongFormTrade//fpml:swEarlyTerminationProvision/fpml:swBreakCalculationMethod='ISDA Standard Method'">Standard</xsl:when>
<xsl:when test="$swShortFormTrade//fpml:swEarlyTerminationProvision/fpml:swBreakCalculationMethod='ISDA Standard Method'">Standard</xsl:when>
<xsl:otherwise>Standard</xsl:otherwise>
</xsl:choose>
</xsl:if>
</BreakCalculationMethod>
<BreakFirstDateTenor>
<xsl:if test="$productType='IRS' or $productType='ZCInflationSwap' or $productType='Swaption' or $productType='Single Currency Basis Swap' or $productType='CapFloor' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='OIS' or $productType='Fixed Fixed Swap'">
<xsl:choose>
<xsl:when test="$swShortFormTrade//fpml:swEarlyTerminationProvision/fpml:swBreakFirstDate">
<xsl:call-template name="formatInterval">
<xsl:with-param name="interval" select="$swShortFormTrade//fpml:swEarlyTerminationProvision/fpml:swBreakFirstDate"/>
</xsl:call-template>
</xsl:when>
<xsl:when test="$swExtendedTradeDetails/fpml:swEarlyTerminationProvision/fpml:swBreakFirstDate">
<xsl:call-template name="formatInterval">
<xsl:with-param name="interval" select="$swExtendedTradeDetails/fpml:swEarlyTerminationProvision/fpml:swBreakFirstDate"/>
</xsl:call-template>
</xsl:when>
</xsl:choose>
</xsl:if>
</BreakFirstDateTenor>
<BreakFrequency>
<xsl:if test="$productType='IRS' or $productType='ZCInflationSwap' or $productType='Swaption' or $productType='Single Currency Basis Swap' or $productType='CapFloor' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='OIS' or $productType='Fixed Fixed Swap'">
<xsl:choose>
<xsl:when test="$swShortFormTrade//fpml:swEarlyTerminationProvision/fpml:swBreakFrequency">
<xsl:call-template name="formatInterval">
<xsl:with-param name="interval" select="$swShortFormTrade//fpml:swEarlyTerminationProvision/fpml:swBreakFrequency"/>
</xsl:call-template>
</xsl:when>
<xsl:when test="$swExtendedTradeDetails/fpml:swEarlyTerminationProvision/fpml:swBreakFrequency">
<xsl:call-template name="formatInterval">
<xsl:with-param name="interval" select="$swExtendedTradeDetails/fpml:swEarlyTerminationProvision/fpml:swBreakFrequency"/>
</xsl:call-template>
</xsl:when>
</xsl:choose>
</xsl:if>
</BreakFrequency>
<BreakOptionA>
<xsl:if test="$productType='IRS' or $productType='ZCInflationSwap' or $productType='Swaption' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='OIS' or $productType='CapFloor' or $productType='Fixed Fixed Swap'">
<xsl:choose>
<xsl:when test="$swShortFormTrade//fpml:swEarlyTerminationProvision/fpml:swMandatoryEarlyTerminationIndicator">M</xsl:when>
<xsl:when test="$swShortFormTrade//fpml:swEarlyTerminationProvision">OM</xsl:when>
<xsl:when test="$earlyTerminationProvision/fpml:mandatoryEarlyTermination">M</xsl:when>
<xsl:when test="$earlyTerminationProvision/fpml:optionalEarlyTermination">
<xsl:choose>
<xsl:when test="$earlyTerminationProvision/fpml:optionalEarlyTermination/fpml:singlePartyOption/fpml:buyerPartyReference[@href=$partyA]">OUM</xsl:when>
<xsl:when test="$earlyTerminationProvision/fpml:optionalEarlyTermination/fpml:singlePartyOption/fpml:buyerPartyReference[@href=$partyB]">OUO</xsl:when>
<xsl:otherwise>OM</xsl:otherwise>
</xsl:choose>
</xsl:when>
</xsl:choose>
</xsl:if>
</BreakOptionA>
<BreakDate>
<xsl:if test="$productType='IRS' or $productType='ZCInflationSwap' or $productType='Swaption' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='OIS' or $productType='CapFloor' or $productType='Fixed Fixed Swap'">
<xsl:if test="$swShortFormTrade//fpml:swEarlyTerminationProvision/fpml:swBreakOverrideFirstDate">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string($swShortFormTrade//fpml:swEarlyTerminationProvision/fpml:swBreakOverrideFirstDate)"/>
</xsl:call-template>
</xsl:if>
<xsl:choose>
<xsl:when test="$earlyTerminationProvision">
<xsl:call-template name="formatDate">
<xsl:with-param name="date">
<xsl:apply-templates select="$earlyTerminationProvision/fpml:mandatoryEarlyTermination/fpml:mandatoryEarlyTerminationDate/fpml:unadjustedDate"/>
<xsl:apply-templates select="$earlyTerminationProvision/fpml:optionalEarlyTermination/fpml:cashSettlement/fpml:cashSettlementPaymentDate/fpml:adjustableDates/fpml:unadjustedDate[1]"/>
<xsl:apply-templates select="$earlyTerminationProvision/fpml:optionalEarlyTermination/fpml:cashSettlement/fpml:cashSettlementPaymentDate/fpml:businessDateRange/fpml:unadjustedFirstDate"/>
</xsl:with-param>
</xsl:call-template>
</xsl:when>
<xsl:when test="$swExtendedTradeDetails/fpml:swEarlyTerminationProvision/fpml:swBreakOverrideFirstDate">
<xsl:call-template name="formatDate">
<xsl:with-param name="date">
<xsl:apply-templates select="$swExtendedTradeDetails/fpml:swEarlyTerminationProvision/fpml:swBreakOverrideFirstDate"/>
</xsl:with-param>
</xsl:call-template>
</xsl:when>
</xsl:choose>
</xsl:if>
</BreakDate>
<BreakExpirationDate>
<xsl:if test="$productType='IRS' or $productType='ZCInflationSwap' or $productType='Swaption' or $productType= 'Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='OIS' or $productType='CapFloor' or $productType='Fixed Fixed Swap'">
<xsl:value-of select="$earlyTerminationProvision/fpml:optionalEarlyTermination//fpml:expirationDate/fpml:relativeDate/fpml:periodMultiplier"/>
<xsl:value-of select="$earlyTerminationProvision/fpml:optionalEarlyTermination/fpml:bermudaExercise/fpml:bermudaExerciseDates/fpml:relativeDates/fpml:periodMultiplier"/>
</xsl:if>
</BreakExpirationDate>
<BreakEarliestTime>
<xsl:if test="$productType='IRS' or $productType='ZCInflationSwap' or $productType='Swaption' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='OIS' or $productType='CapFloor' or $productType='Fixed Fixed Swap'">
<xsl:if test="$earlyTerminationProvision/fpml:optionalEarlyTermination">
<xsl:call-template name="formatTime">
<xsl:with-param name="time" select="string($earlyTerminationProvision/fpml:optionalEarlyTermination//fpml:earliestExerciseTime/fpml:hourMinuteTime)"/>
</xsl:call-template>
</xsl:if>
</xsl:if>
</BreakEarliestTime>
<BreakLatestTime/>
<BreakCalcAgentA>
<xsl:if test="$productType='IRS' or $productType='ZCInflationSwap' or $productType='Swaption' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='OIS' or $productType='CapFloor' or $productType='Fixed Fixed Swap'">
<xsl:choose>
<xsl:when test="$earlyTerminationProvision/fpml:mandatoryEarlyTermination">
<xsl:choose>
<xsl:when test="$earlyTerminationProvision/fpml:mandatoryEarlyTermination/fpml:calculationAgent/fpml:calculationAgentParty[.='AsSpecifiedInMasterAgreement']">As Specified in Master Agreement</xsl:when>
<xsl:when test="count($earlyTerminationProvision/fpml:mandatoryEarlyTermination/fpml:calculationAgent/fpml:calculationAgentPartyReference)=2">Joint</xsl:when>
<xsl:when test="$earlyTerminationProvision/fpml:mandatoryEarlyTermination/fpml:calculationAgent/fpml:calculationAgentPartyReference[@href=$partyA]">My Entity</xsl:when>
<xsl:when test="$earlyTerminationProvision/fpml:mandatoryEarlyTermination/fpml:calculationAgent/fpml:calculationAgentPartyReference[@href=$partyB]">Other Entity</xsl:when>
</xsl:choose>
</xsl:when>
<xsl:when test="$earlyTerminationProvision/fpml:optionalEarlyTermination">
<xsl:choose>
<xsl:when test="$earlyTerminationProvision/fpml:optionalEarlyTermination/fpml:calculationAgent/fpml:calculationAgentParty[.='AsSpecifiedInMasterAgreement']">As Specified in Master Agreement</xsl:when>
<xsl:when test="$earlyTerminationProvision/fpml:optionalEarlyTermination/fpml:calculationAgent/fpml:calculationAgentParty[.='NonExercisingParty']">Non-Exercising Party</xsl:when>
<xsl:when test="count($earlyTerminationProvision/fpml:optionalEarlyTermination/fpml:calculationAgent/fpml:calculationAgentPartyReference)=2">Joint</xsl:when>
<xsl:when test="$earlyTerminationProvision/fpml:optionalEarlyTermination/fpml:calculationAgent/fpml:calculationAgentPartyReference[@href=$partyA]">My Entity</xsl:when>
<xsl:when test="$earlyTerminationProvision/fpml:optionalEarlyTermination/fpml:calculationAgent/fpml:calculationAgentPartyReference[@href=$partyB]">Other Entity</xsl:when>
</xsl:choose>
</xsl:when>
</xsl:choose>
</xsl:if>
</BreakCalcAgentA>
<BreakExpiryTime>
<xsl:if test="$productType='IRS' or $productType='ZCInflationSwap' or $productType='Swaption' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='OIS' or $productType='CapFloor' or $productType='Fixed Fixed Swap'">
<xsl:if test="$earlyTerminationProvision/fpml:optionalEarlyTermination">
<xsl:call-template name="formatTime">
<xsl:with-param name="time" select="string($earlyTerminationProvision/fpml:optionalEarlyTermination//fpml:expirationTime/fpml:hourMinuteTime)"/>
</xsl:call-template>
</xsl:if>
</xsl:if>
</BreakExpiryTime>
<BreakCashSettleCcy>
<xsl:if test="$productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='Fixed Fixed Swap'">
<xsl:value-of select="$swExtendedTradeDetails/fpml:swCrossCurrencyMethod/fpml:cashSettlementCurrency"/>
<xsl:value-of select="$earlyTerminationProvision/*/fpml:cashSettlement/*/fpml:cashSettlementCurrency"/>
</xsl:if>
</BreakCashSettleCcy>
<BreakLocation>
<xsl:if test="$productType='IRS' or $productType='ZCInflationSwap' or $productType='Swaption' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='OIS' or $productType='CapFloor' or $productType='Fixed Fixed Swap'">
<xsl:choose>
<xsl:when test="$earlyTerminationProvision/fpml:optionalEarlyTermination">
<xsl:apply-templates select="$earlyTerminationProvision/fpml:optionalEarlyTermination//fpml:earliestExerciseTime/fpml:businessCenter"/>
</xsl:when>
<xsl:when test="$earlyTerminationProvision/fpml:mandatoryEarlyTermination">
<xsl:apply-templates select="$earlyTerminationProvision/fpml:mandatoryEarlyTermination/fpml:cashSettlement/fpml:cashSettlementValuationTime/fpml:businessCenter"/>
</xsl:when>
</xsl:choose>
</xsl:if>
</BreakLocation>
<BreakHolidayCentre>
<xsl:if test="$productType='IRS' or $productType='ZCInflationSwap' or $productType='Swaption' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='OIS' or $productType='CapFloor' or $productType='Fixed Fixed Swap'">
<xsl:choose>
<xsl:when test="$earlyTerminationProvision/fpml:optionalEarlyTermination">
<xsl:apply-templates select="$earlyTerminationProvision/fpml:optionalEarlyTermination/fpml:europeanExercise/fpml:expirationDate/fpml:relativeDate/fpml:businessCenters"/>
<xsl:apply-templates select="$earlyTerminationProvision/fpml:optionalEarlyTermination/fpml:bermudaExercise/fpml:bermudaExerciseDates/fpml:relativeDates/fpml:businessCenters"/>
<xsl:apply-templates select="$earlyTerminationProvision/fpml:optionalEarlyTermination/fpml:americanExercise/fpml:expirationDate/fpml:relativeDate/fpml:businessCenters"/>
</xsl:when>
<xsl:when test="$earlyTerminationProvision/fpml:mandatoryEarlyTermination">
<xsl:apply-templates select="$earlyTerminationProvision/fpml:mandatoryEarlyTermination/fpml:cashSettlement/fpml:cashSettlementValuationDate/fpml:businessCenters"/>
</xsl:when>
</xsl:choose>
</xsl:if>
</BreakHolidayCentre>
<BreakSettlement>
<xsl:if test="($productType='IRS' or $productType='ZCInflationSwap' or $productType='Swaption' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='OIS' or $productType='CapFloor' or $productType='Fixed Fixed Swap') and $earlyTerminationProvision//fpml:cashSettlement">
<xsl:if test="$earlyTerminationProvision//fpml:cashSettlement/fpml:cashPriceMethod">Cash Price</xsl:if>
<xsl:if test="$earlyTerminationProvision//fpml:cashSettlement/fpml:cashPriceAlternateMethod">Cash Price - Alternate Method</xsl:if>
<xsl:if test="$earlyTerminationProvision//fpml:cashSettlement/fpml:parYieldCurveAdjustedMethod">Par Yield Curve - Adjusted</xsl:if>
<xsl:if test="$earlyTerminationProvision//fpml:cashSettlement/fpml:zeroCouponYieldAdjustedMethod">Zero Coupon Yield - Adjusted</xsl:if>
<xsl:if test="$swExtendedTradeDetails/fpml:swEarlyTerminationProvision/fpml:swCollateralizedCashPrice">Collateralized Cash Price</xsl:if>
<xsl:if test="$swExtendedTradeDetails/fpml:swCrossCurrencyMethod">Cross Currency Method</xsl:if>
<xsl:if test="$earlyTerminationProvision//fpml:cashSettlement/fpml:midMarketValuation/fpml:indicativeQuotations">Mid-market Valuation (Indicative Quotations)</xsl:if>
<xsl:if test="$earlyTerminationProvision//fpml:cashSettlement/fpml:midMarketValuation/fpml:indicativeQuotationsAlternate">Mid-market Valuation (Indicative Quotations) - Alternate Method</xsl:if>
<xsl:if test="$earlyTerminationProvision//fpml:cashSettlement/fpml:midMarketValuation/fpml:calculationAgentDetermination">Mid-market Valuation (Calculation Agent Determination)</xsl:if>
<xsl:if test="$earlyTerminationProvision//fpml:cashSettlement/fpml:replacementValue/fpml:firmQuotations">Replacement Value (Firm Quotations)</xsl:if>
<xsl:if test="$earlyTerminationProvision//fpml:cashSettlement/fpml:replacementValue/fpml:calculationAgentDetermination">Replacement Value (Calculation Agent Determination)</xsl:if>
<xsl:if test="$earlyTerminationProvision//fpml:cashSettlement/fpml:collateralizedCashPriceMethod">Collateralized Cash Price</xsl:if>
</xsl:if>
</BreakSettlement>
<BreakValuationDate>
<xsl:if test="$productType='IRS' or $productType='ZCInflationSwap' or $productType='Swaption' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='OIS' or $productType='CapFloor' or $productType='Fixed Fixed Swap'">
<xsl:value-of select="$earlyTerminationProvision//fpml:cashSettlement/fpml:cashSettlementValuationDate/fpml:periodMultiplier"/>
</xsl:if>
</BreakValuationDate>
<BreakValuationTime>
<xsl:if test="$productType='IRS' or $productType='ZCInflationSwap' or $productType='Swaption' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='OIS' or $productType='CapFloor' or $productType='Fixed Fixed Swap'">
<xsl:if test="$earlyTerminationProvision//fpml:cashSettlement">
<xsl:call-template name="formatTime">
<xsl:with-param name="time" select="string($earlyTerminationProvision//fpml:cashSettlement/fpml:cashSettlementValuationTime/fpml:hourMinuteTime)"/>
</xsl:call-template>
</xsl:if>
</xsl:if>
</BreakValuationTime>
<BreakSource>
<xsl:if test="$productType='IRS' or  $productType='ZCInflationSwap' or $productType='Swaption' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='OIS' or $productType='CapFloor' or $productType='Fixed Fixed Swap'">
<xsl:if test="$earlyTerminationProvision//fpml:cashSettlement">
<xsl:choose>
<xsl:when test="$earlyTerminationProvision//fpml:cashSettlement//fpml:settlementRateSource/fpml:informationSource/fpml:rateSourcePage">
<xsl:variable name="pageString" select="' Page '"/>
<xsl:value-of select="$earlyTerminationProvision//fpml:cashSettlement//fpml:settlementRateSource/fpml:informationSource/fpml:rateSource"/>
<xsl:value-of select="$pageString"/>
<xsl:value-of select="$earlyTerminationProvision//fpml:cashSettlement//fpml:settlementRateSource/fpml:informationSource/fpml:rateSourcePage"/>
</xsl:when>
<xsl:when test="$earlyTerminationProvision//fpml:cashSettlement//fpml:settlementRateSource/fpml:informationSource/fpml:rateSource[.='ISDA']">ISDA Source</xsl:when>
<xsl:when test="$earlyTerminationProvision//fpml:cashSettlement//fpml:settlementRateSource/fpml:informationSource/fpml:rateSource[.='ICESWAP']">ICESWAP Rate</xsl:when>
<xsl:when test="$earlyTerminationProvision//fpml:cashSettlement//fpml:settlementRateSource/fpml:informationSource/fpml:rateSource[.='TOKYOSWAP']">Tokyo Swap Rate</xsl:when>
<xsl:when test="$swExtendedTradeDetails/fpml:swEarlyTerminationProvision/fpml:swCollateralizedCashPrice/fpml:settlementRateSource/fpml:informationSource/fpml:rateSource[.='ISDA']">ISDA Source</xsl:when>
<xsl:when test="$earlyTerminationProvision//fpml:cashSettlement/fpml:midMarketValuation/fpml:calculationAgentDetermination"/>
<xsl:otherwise>Reference Banks</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:if>
</BreakSource>
<BreakReferenceBanks>
<xsl:if test="$productType='IRS' or $productType='ZCInflationSwap' or $productType='Swaption' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='OIS' or $productType='CapFloor' or $productType='Fixed Fixed Swap'">
<xsl:choose>
<xsl:when test="$earlyTerminationProvision//fpml:cashSettlementReferenceBanks">
<xsl:apply-templates select="$earlyTerminationProvision//fpml:cashSettlementReferenceBanks"/>
</xsl:when>
<xsl:when test="$swExtendedTradeDetails/fpml:swCrossCurrencyMethod/fpml:cashSettlementReferenceBanks">
<xsl:apply-templates select="$swExtendedTradeDetails/fpml:swCrossCurrencyMethod/fpml:cashSettlementReferenceBanks"/>
</xsl:when>
<xsl:when test="$swExtendedTradeDetails/fpml:swEarlyTerminationProvision/fpml:swCollateralizedCashPrice/fpml:settlementRateSource/fpml:cashSettlementReferenceBanks">
<xsl:apply-templates select="$swExtendedTradeDetails/fpml:swEarlyTerminationProvision/fpml:swCollateralizedCashPrice/fpml:settlementRateSource/fpml:cashSettlementReferenceBanks"/>
</xsl:when>
<xsl:when test="$earlyTerminationProvision//fpml:cashSettlement/fpml:midMarketValuation/fpml:calculationAgentDetermination"/>
<xsl:when test="$earlyTerminationProvision">Agreed on exercise</xsl:when>
<xsl:otherwise/>
</xsl:choose>
</xsl:if>
</BreakReferenceBanks>
<BreakQuotation>
<xsl:if test="$productType='IRS' or $productType='ZCInflationSwap' or $productType='Swaption' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='OIS' or $productType='CapFloor' or $productType='Fixed Fixed Swap'">
<xsl:if test="$earlyTerminationProvision//fpml:cashSettlement//fpml:quotationRateType">
<xsl:choose>
<xsl:when test="$earlyTerminationProvision//fpml:cashSettlement//fpml:quotationRateType[.='Mid']">Mid</xsl:when>
<xsl:when test="$earlyTerminationProvision//fpml:cashSettlement//fpml:quotationRateType[.='Bid']">Bid</xsl:when>
<xsl:when test="$earlyTerminationProvision//fpml:cashSettlement//fpml:quotationRateType[.='Ask']">Ask</xsl:when>
<xsl:when test="$earlyTerminationProvision//fpml:cashSettlement//fpml:quotationRateType[.='ExercisingPartyPays']">Exercising Party Pays</xsl:when>
</xsl:choose>
</xsl:if>
<xsl:if test="$swExtendedTradeDetails/fpml:swEarlyTerminationProvision/fpml:swCollateralizedCashPrice/fpml:quotationRateType">
<xsl:choose>
<xsl:when test="$swExtendedTradeDetails/fpml:swEarlyTerminationProvision/fpml:swCollateralizedCashPrice/fpml:quotationRateType[.='Mid']">Mid</xsl:when>
<xsl:when test="$swExtendedTradeDetails/fpml:swEarlyTerminationProvision/fpml:swCollateralizedCashPrice/fpml:quotationRateType[.='Bid']">Bid</xsl:when>
<xsl:when test="$swExtendedTradeDetails/fpml:swEarlyTerminationProvision/fpml:swCollateralizedCashPrice/fpml:quotationRateType[.='Ask']">Ask</xsl:when>
<xsl:when test="$swExtendedTradeDetails/fpml:swEarlyTerminationProvision/fpml:swCollateralizedCashPrice/fpml:quotationRateType[.='ExercisingPartyPays']">Exercising Party Pays</xsl:when>
</xsl:choose>
</xsl:if>
</xsl:if>
<xsl:if test="$productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='Fixed Fixed Swap'">
<xsl:if test="$swExtendedTradeDetails/fpml:swCrossCurrencyMethod">
<xsl:choose>
<xsl:when test="$swExtendedTradeDetails/fpml:swCrossCurrencyMethod//fpml:quotationRateType[.='Mid']">Mid</xsl:when>
<xsl:when test="$swExtendedTradeDetails/fpml:swCrossCurrencyMethod//fpml:quotationRateType[.='Bid']">Bid</xsl:when>
<xsl:when test="$swExtendedTradeDetails/fpml:swCrossCurrencyMethod//fpml:quotationRateType[.='Ask']">Ask</xsl:when>
<xsl:when test="$swExtendedTradeDetails/fpml:swCrossCurrencyMethod//fpml:quotationRateType[.='ExercisingPartyPays']">Exercising Party Pays</xsl:when>
</xsl:choose>
</xsl:if>
</xsl:if>
</BreakQuotation>
<BreakMMVApplicableCSA>
<xsl:if test="($productType='IRS' or $productType='OIS' or $productType='CapFloor' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='Single Currency Basis Swap' or $productType='Fixed Fixed Swap' or $productType='ZCInflationSwap' or $productType='Swaption') and $earlyTerminationProvision//fpml:cashSettlement/fpml:midMarketValuation//fpml:applicableCsa">
<xsl:choose>
<xsl:when test="$earlyTerminationProvision//fpml:cashSettlement/fpml:midMarketValuation//fpml:applicableCsa[.='NoCSA']">No CSA</xsl:when>
<xsl:when test="$earlyTerminationProvision//fpml:cashSettlement/fpml:midMarketValuation//fpml:applicableCsa[.='ExistingCSA']">Existing CSA</xsl:when>
<xsl:when test="$earlyTerminationProvision//fpml:cashSettlement/fpml:midMarketValuation//fpml:applicableCsa[.='ReferenceVMCSA']">Reference VM CSA</xsl:when>
</xsl:choose>
</xsl:if>
</BreakMMVApplicableCSA>
<BreakCollateralCurrency>
<xsl:if test="$productType='IRS' or $productType='OIS' or $productType='CapFloor' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='Single Currency Basis Swap' or $productType='Fixed Fixed Swap' or $productType='ZCInflationSwap' or $productType='Swaption'">
<xsl:choose>
<xsl:when test="$earlyTerminationProvision//fpml:cashSettlement/fpml:midMarketValuation//fpml:cashCollateralCurrency">
<xsl:value-of select="$earlyTerminationProvision//fpml:cashSettlement/fpml:midMarketValuation//fpml:cashCollateralCurrency"/>
</xsl:when>
<xsl:when test="$earlyTerminationProvision//fpml:cashSettlement/fpml:replacementValue//fpml:cashCollateralCurrency">
<xsl:value-of select="$earlyTerminationProvision//fpml:cashSettlement/fpml:replacementValue//fpml:cashCollateralCurrency"/>
</xsl:when>
</xsl:choose>
</xsl:if>
</BreakCollateralCurrency>
<BreakCollateralInterestRate>
<xsl:if test="($productType='IRS' or $productType='OIS' or $productType='CapFloor' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='Single Currency Basis Swap' or $productType='Fixed Fixed Swap' or $productType='ZCInflationSwap' or $productType='Swaption') and $earlyTerminationProvision//fpml:cashSettlement/fpml:midMarketValuation//fpml:cashCollateralInterestRate">
<xsl:value-of select="$earlyTerminationProvision//fpml:cashSettlement/fpml:midMarketValuation//fpml:cashCollateralInterestRate"/>
</xsl:if>
</BreakCollateralInterestRate>
<BreakAgreedDiscountRate>
<xsl:if test="$productType='IRS' or $productType='OIS' or $productType='CapFloor' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='Single Currency Basis Swap' or $productType='Fixed Fixed Swap' or $productType='ZCInflationSwap' or $productType='Swaption'">
<xsl:choose>
<xsl:when test="$earlyTerminationProvision//fpml:cashSettlement/fpml:midMarketValuation//fpml:agreedDiscountRate">
<xsl:value-of select="$earlyTerminationProvision//fpml:cashSettlement/fpml:midMarketValuation//fpml:agreedDiscountRate"/>
</xsl:when>
<xsl:when test="$earlyTerminationProvision//fpml:cashSettlement/fpml:collateralizedCashPriceMethod/fpml:agreedDiscountRate">
<xsl:value-of select="$earlyTerminationProvision//fpml:cashSettlement/fpml:collateralizedCashPriceMethod/fpml:agreedDiscountRate"/>
</xsl:when>
</xsl:choose>
</xsl:if>
</BreakAgreedDiscountRate>
<BreakProtectedPartyA>
<xsl:if test="$productType='IRS' or $productType='OIS' or $productType='CapFloor' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='Single Currency Basis Swap' or $productType='Fixed Fixed Swap' or $productType='ZCInflationSwap' or $productType='Swaption'">
<xsl:choose>
<xsl:when test="$earlyTerminationProvision//fpml:cashSettlement/fpml:replacementValue//fpml:protectedParty/fpml:partyDetermination">
<xsl:choose>
<xsl:when test="$earlyTerminationProvision//fpml:cashSettlement/fpml:replacementValue//fpml:protectedParty/fpml:partyDetermination[.='NonExercisingParty']">Non-Exercising Party</xsl:when>
<xsl:when test="$earlyTerminationProvision//fpml:cashSettlement/fpml:replacementValue//fpml:protectedParty/fpml:partyDetermination[.='Both']">Both</xsl:when>
</xsl:choose>
</xsl:when>
<xsl:when test="$earlyTerminationProvision//fpml:cashSettlement/fpml:replacementValue//fpml:protectedParty/fpml:partyReference">
<xsl:choose>
<xsl:when test="$earlyTerminationProvision//fpml:cashSettlement/fpml:replacementValue//fpml:protectedParty/fpml:partyReference[@href=$partyA]">My Entity</xsl:when>
<xsl:when test="$earlyTerminationProvision//fpml:cashSettlement/fpml:replacementValue//fpml:protectedParty/fpml:partyReference[@href=$partyB]">Other Entity</xsl:when>
</xsl:choose>
</xsl:when>
</xsl:choose>
</xsl:if>
</BreakProtectedPartyA>
<BreakMutuallyAgreedCH>
<xsl:if test="($productType='IRS' or $productType='OIS' or $productType='CapFloor' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='Single Currency Basis Swap' or $productType='Fixed Fixed Swap' or $productType='ZCInflationSwap' or $productType='Swaption') and $earlyTerminationProvision//fpml:cashSettlement/fpml:collateralizedCashPriceMethod/fpml:mutuallyAgreedClearinghouse">
<xsl:value-of select="$earlyTerminationProvision//fpml:cashSettlement/fpml:collateralizedCashPriceMethod/fpml:mutuallyAgreedClearinghouse"/>
</xsl:if>
</BreakMutuallyAgreedCH>
<BreakPrescribedDocAdj>
<xsl:if test="($productType='IRS' or $productType='OIS' or $productType='CapFloor' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='Single Currency Basis Swap' or $productType='Fixed Fixed Swap' or $productType='ZCInflationSwap' or $productType='Swaption') and $earlyTerminationProvision//fpml:cashSettlement/fpml:replacementValue/fpml:firmQuotations/fpml:prescribedDocumentationAdjustment">
<xsl:choose>
<xsl:when test="$earlyTerminationProvision//fpml:cashSettlement/fpml:replacementValue//fpml:prescribedDocumentationAdjustment[.='false']">Not Applicable</xsl:when>
<xsl:when test="$earlyTerminationProvision//fpml:cashSettlement/fpml:replacementValue//fpml:prescribedDocumentationAdjustment[.='true']">Applicable</xsl:when>
</xsl:choose>
</xsl:if>
</BreakPrescribedDocAdj>
<ExchangeUnderlying>
<xsl:if test="$productType='IRS' or $productType='OIS' or $productType='Fixed Fixed Swap' or $productType='ZCInflationSwap'">
<xsl:choose>
<xsl:when test="$swAssociatedBonds">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:if>
</ExchangeUnderlying>
<SwapSpread>
<xsl:if test="$productType='IRS' or $productType='OIS' or $productType='ZCInflationSwap'">
<xsl:value-of select="$swAssociatedBonds/fpml:swNegotiatedSpreadRate"/>
</xsl:if>
</SwapSpread>
<BondId1>
<xsl:value-of select="$swBondDetails[1]/fpml:swBondId"/>
</BondId1>
<BondName1>
<xsl:value-of select="$swBondDetails[1]/fpml:swBondName"/>
</BondName1>
<BondAmount1>
<xsl:value-of select="$swBondDetails[1]/fpml:swBondFaceAmount"/>
</BondAmount1>
<BondPriceType1>
<xsl:value-of select="$swBondDetails[1]/fpml:swPriceType"/>
</BondPriceType1>
<BondPrice1>
<xsl:value-of select="$swBondDetails[1]/fpml:swBondPrice"/>
</BondPrice1>
<BondId2>
<xsl:value-of select="$swBondDetails[2]/fpml:swBondId"/>
</BondId2>
<BondName2>
<xsl:value-of select="$swBondDetails[2]/fpml:swBondName"/>
</BondName2>
<BondAmount2>
<xsl:value-of select="$swBondDetails[2]/fpml:swBondFaceAmount"/>
</BondAmount2>
<BondPriceType2>
<xsl:value-of select="$swBondDetails[2]/fpml:swPriceType"/>
</BondPriceType2>
<BondPrice2>
<xsl:value-of select="$swBondDetails[2]/fpml:swBondPrice"/>
</BondPrice2>
<StubAt>
<xsl:if test="$productType='IRS' or $productType='OIS' or $productType='ZCInflationSwap' or $productType='Swaption' or $productType='CapFloor' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='Fixed Fixed Swap'">
<xsl:choose>
<xsl:when test="$swExtendedTradeDetails/fpml:swStub[1]/fpml:swStubPosition">
<xsl:value-of select="$swExtendedTradeDetails/fpml:swStub[1]/fpml:swStubPosition"/>
</xsl:when>
<xsl:when test="$swShortFormTrade//fpml:swStubPosition">
<xsl:value-of select="$swShortFormTrade//fpml:swStubPosition"/>
</xsl:when>
<xsl:when test="$swapStream/fpml:calculationPeriodDates/fpml:stubPeriodType">
<xsl:call-template name="formatStubAt">
<xsl:with-param name="stubAt" select="string($swapStream/fpml:calculationPeriodDates/fpml:stubPeriodType)"/>
</xsl:call-template>
</xsl:when>
<xsl:when test="$capFloorStream/fpml:calculationPeriodDates/fpml:stubPeriodType">
<xsl:call-template name="formatStubAt">
<xsl:with-param name="stubAt" select="string($capFloorStream/fpml:calculationPeriodDates/fpml:stubPeriodType)"/>
</xsl:call-template>
</xsl:when>
<xsl:otherwise>Start</xsl:otherwise>
</xsl:choose>
</xsl:if>
</StubAt>
<IsUserStartStub>
<xsl:variable name="stubAtPos">
<xsl:if test="$swExtendedTradeDetails/fpml:swStub[1]/fpml:swStubPosition">
<xsl:value-of select="$swExtendedTradeDetails/fpml:swStub[1]/fpml:swStubPosition"/>
</xsl:if>
</xsl:variable>
<xsl:if test="$productType='IRS' or $productType='OIS' or $productType='ZCInflationSwap' or $productType='Swaption'or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='Fixed Fixed Swap'">
<xsl:choose>
<xsl:when test="$stubAtPos = 'Start'">true</xsl:when>
<xsl:when test="$swapStream//fpml:calculationPeriodDates/fpml:stubPeriodType">
<xsl:variable name="stubPeriodTemplate">
<xsl:call-template name="formatStubAt">
<xsl:with-param name="stubAt" select="string($swapStream//fpml:calculationPeriodDates/fpml:stubPeriodType)"/>
</xsl:call-template>
</xsl:variable>
<xsl:if test="$stubPeriodTemplate = 'Start'">true</xsl:if>
</xsl:when>
<xsl:when test="$swapStream/fpml:stubCalculationPeriodAmount/fpml:initialStub">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="$productType='CapFloor'">
<xsl:choose>
<xsl:when test="$stubAtPos = 'Start'">true</xsl:when>
<xsl:when test="$capFloorStream/fpml:calculationPeriodDates/fpml:stubPeriodType">
<xsl:variable name="stubTemplate">
<xsl:call-template name="formatStubAt">
<xsl:with-param name="stubAt" select="string($capFloorStream/fpml:calculationPeriodDates/fpml:stubPeriodType)"/>
</xsl:call-template>
</xsl:variable>
<xsl:if test="$stubTemplate = 'Start'">true</xsl:if>
</xsl:when>
<xsl:when test="$capFloorStream/fpml:stubCalculationPeriodAmount/fpml:initialStub">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:if>
</IsUserStartStub>
<FixedStub>
<xsl:choose>
<xsl:when test="$swShortFormTrade//fpml:swFixedStubLength and (($productType='IRS') or ($productType='Cross Currency IRS') or ($productType='Swaption') or ($productType='OIS') or ($productType='Single Currency Basis Swap') or ($productType='Fixed Fixed Swap'))">
<xsl:value-of select="$swShortFormTrade//fpml:swFixedStubLength"/>
</xsl:when>
<xsl:when test="$productType='IRS' or $productType='OIS' or $productType='ZCInflationSwap' or $productType='Swaption' or $productType='Cross Currency IRS' or $productType='Fixed Fixed Swap'">
<xsl:choose>
<xsl:when test="$swExtendedTradeDetails/fpml:swStub[1]/fpml:swStubLength[@href=$fixedLegId]">
<xsl:value-of select="$swExtendedTradeDetails/fpml:swStub[1]/fpml:swStubLength[@href=$fixedLegId]"/>
</xsl:when>
<xsl:when test="$fixedStream/fpml:calculationPeriodDates/fpml:stubPeriodType">
<xsl:variable name="stubAtValue">
<xsl:call-template name="formatStubAt">
<xsl:with-param name="stubAt" select="string($fixedStream/fpml:calculationPeriodDates/fpml:stubPeriodType)"/>
</xsl:call-template>
</xsl:variable>
<xsl:choose>
<xsl:when test="not ($stubAtValue='End' and count($swExtendedTradeDetails/fpml:swStub)=2)">
<xsl:call-template name="formatStubLen">
<xsl:with-param name="stubLen" select="string($fixedStream/fpml:calculationPeriodDates/fpml:stubPeriodType)"/>
</xsl:call-template>
</xsl:when>
<xsl:otherwise>Short</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:otherwise>Short</xsl:otherwise>
</xsl:choose>
</xsl:when>
</xsl:choose>
</FixedStub>
<FixedStub_2>
<xsl:choose>
<xsl:when test="$swShortFormTrade//fpml:swFixed2StubLength and ($productType='Fixed Fixed Swap')">
<xsl:value-of select="$swShortFormTrade//fpml:swFixed2StubLength"/>
</xsl:when>
<xsl:when test="$productType='Fixed Fixed Swap'">
<xsl:choose>
<xsl:when test="$swExtendedTradeDetails/fpml:swStub[1]/fpml:swStubLength[@href=$fixedLegId2]">
<xsl:value-of select="$swExtendedTradeDetails/fpml:swStub[1]/fpml:swStubLength[@href=$fixedLegId2]"/>
</xsl:when>
<xsl:when test="$fixedStream2/fpml:calculationPeriodDates/fpml:stubPeriodType">
<xsl:call-template name="formatStubLen">
<xsl:with-param name="stubLen" select="string($fixedStream2/fpml:calculationPeriodDates/fpml:stubPeriodType)"/>
</xsl:call-template>
</xsl:when>
<xsl:otherwise>Short</xsl:otherwise>
</xsl:choose>
</xsl:when>
</xsl:choose>
</FixedStub_2>
<FloatStub>
<xsl:choose>
<xsl:when test="$swShortFormTrade//fpml:swFloatStubLength and (($productType='IRS') or ($productType='Swaption') or ($productType='OIS') or ($productType='Single Currency Basis Swap') or ($productType='Cross Currency Basis Swap'))">
<xsl:value-of select="$swShortFormTrade//fpml:swFloatStubLength"/>
</xsl:when>
<xsl:when test="$productType='IRS' or $productType='OIS' or $productType='ZCInflationSwap' or $productType='Swaption' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap'">
<xsl:choose>
<xsl:when test="$swExtendedTradeDetails/fpml:swStub[1]/fpml:swStubLength[@href=$floatingLegId]">
<xsl:value-of select="$swExtendedTradeDetails/fpml:swStub[1]/fpml:swStubLength[@href=$floatingLegId]"/>
</xsl:when>
<xsl:when test="$floatingStream/fpml:calculationPeriodDates/fpml:stubPeriodType">
<xsl:variable name="stubAtValue">
<xsl:call-template name="formatStubAt">
<xsl:with-param name="stubAt" select="string($floatingStream/fpml:calculationPeriodDates/fpml:stubPeriodType)"/>
</xsl:call-template>
</xsl:variable>
<xsl:choose>
<xsl:when test="not ($stubAtValue='End' and count($swExtendedTradeDetails/fpml:swStub)=2)">
<xsl:call-template name="formatStubLen">
<xsl:with-param name="stubLen" select="string($floatingStream/fpml:calculationPeriodDates/fpml:stubPeriodType)"/>
</xsl:call-template>
</xsl:when>
<xsl:otherwise>Short</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:otherwise>Short</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType='CapFloor'">
<xsl:choose>
<xsl:when test="$swExtendedTradeDetails/fpml:swStub/fpml:swStubLength">
<xsl:value-of select="$swExtendedTradeDetails/fpml:swStub/fpml:swStubLength"/>
</xsl:when>
<xsl:when test="$capFloorStream/fpml:calculationPeriodDates/fpml:stubPeriodType">
<xsl:call-template name="formatStubLen">
<xsl:with-param name="stubLen" select="string($capFloorStream/fpml:calculationPeriodDates/fpml:stubPeriodType)"/>
</xsl:call-template>
</xsl:when>
<xsl:otherwise>Short</xsl:otherwise>
</xsl:choose>
</xsl:when>
</xsl:choose>
</FloatStub>
<FloatStub_2>
<xsl:if test="$productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS'">
<xsl:choose>
<xsl:when test="$swExtendedTradeDetails/fpml:swStub/fpml:swStubLength[@href=$floatingLegId2]">
<xsl:value-of select="$swExtendedTradeDetails/fpml:swStub/fpml:swStubLength[@href=$floatingLegId2]"/>
</xsl:when>
<xsl:when test="$floatingStream2/fpml:calculationPeriodDates/fpml:stubPeriodType">
<xsl:call-template name="formatStubLen">
<xsl:with-param name="stubLen" select="string($floatingStream2/fpml:calculationPeriodDates/fpml:stubPeriodType)"/>
</xsl:call-template>
</xsl:when>
<xsl:when test="$swShortFormTrade/fpml:swCrossCurrencyIrsParameters/fpml:swFloatStubLength">
<xsl:value-of select="$swShortFormTrade/fpml:swCrossCurrencyIrsParameters/fpml:swFloatStubLength"/>
</xsl:when>
<xsl:when test="$swShortFormTrade//fpml:swFloatingRateCalculation[position()=$floatingLeg2]/fpml:swFloatStubLength">
<xsl:value-of select="$swShortFormTrade//fpml:swFloatingRateCalculation[position()=$floatingLeg2]/fpml:swFloatStubLength"/>
</xsl:when>
<xsl:otherwise>Short</xsl:otherwise>
</xsl:choose>
</xsl:if>
</FloatStub_2>
<FrontAndBackStubs>
<xsl:if test="$swExtendedTradeDetails/fpml:swStub[2]">true</xsl:if>
</FrontAndBackStubs>
<FixedBackStub>
<xsl:choose>
<xsl:when test="$swExtendedTradeDetails/fpml:swStub[2]/fpml:swStubLength[@href=$fixedLegId]">
<xsl:value-of select="$swExtendedTradeDetails/fpml:swStub[2]/fpml:swStubLength[@href=$fixedLegId]"/>
</xsl:when>
<xsl:when test="count($swExtendedTradeDetails/fpml:swStub)=2 and $fixedStream/fpml:calculationPeriodDates/fpml:stubPeriodType and ($productType='IRS' or $productType='OIS')">
<xsl:variable name="stubAtValue">
<xsl:call-template name="formatStubAt">
<xsl:with-param name="stubAt" select="string($fixedStream/fpml:calculationPeriodDates/fpml:stubPeriodType)"/>
</xsl:call-template>
</xsl:variable>
<xsl:choose>
<xsl:when test="$stubAtValue='End'">
<xsl:call-template name="formatStubLen">
<xsl:with-param name="stubLen" select="string($fixedStream/fpml:calculationPeriodDates/fpml:stubPeriodType)"/>
</xsl:call-template>
</xsl:when>
</xsl:choose>
</xsl:when>
</xsl:choose>
</FixedBackStub>
<FloatBackStub>
<xsl:choose>
<xsl:when test="$swExtendedTradeDetails/fpml:swStub[2]/fpml:swStubLength[@href=$floatingLegId]">
<xsl:value-of select="$swExtendedTradeDetails/fpml:swStub[2]/fpml:swStubLength[@href=$floatingLegId]"/>
</xsl:when>
<xsl:when test="count($swExtendedTradeDetails/fpml:swStub)=2 and $floatingStream/fpml:calculationPeriodDates/fpml:stubPeriodType and ($productType='IRS' or $productType='OIS')">
<xsl:variable name="stubAtValue">
<xsl:call-template name="formatStubAt">
<xsl:with-param name="stubAt" select="string($floatingStream/fpml:calculationPeriodDates/fpml:stubPeriodType)"/>
</xsl:call-template>
</xsl:variable>
<xsl:choose>
<xsl:when test="$stubAtValue='End'">
<xsl:call-template name="formatStubLen">
<xsl:with-param name="stubLen" select="string($floatingStream/fpml:calculationPeriodDates/fpml:stubPeriodType)"/>
</xsl:call-template>
</xsl:when>
</xsl:choose>
</xsl:when>
</xsl:choose>
</FloatBackStub>
<BackStubIndexTenor1>
<xsl:if test="$swExtendedTradeDetails/fpml:swStub[2]">
<xsl:call-template name="formatInterval">
<xsl:with-param name="interval" select="$floatingStream/fpml:stubCalculationPeriodAmount/fpml:finalStub/fpml:floatingRate[1]/fpml:indexTenor"/>
</xsl:call-template>
</xsl:if>
</BackStubIndexTenor1>
<BackStubIndexTenor2>
<xsl:if test="$swExtendedTradeDetails/fpml:swStub[2]">
<xsl:call-template name="formatInterval">
<xsl:with-param name="interval" select="$floatingStream/fpml:stubCalculationPeriodAmount/fpml:finalStub/fpml:floatingRate[2]/fpml:indexTenor"/>
</xsl:call-template>
</xsl:if>
</BackStubIndexTenor2>
<BackStubLinearInterpolation>
<xsl:if test="$productType='IRS' and $swExtendedTradeDetails/fpml:swStub[2] and $floatingStream/fpml:stubCalculationPeriodAmount/fpml:finalStub/fpml:floatingRate[1]">
<xsl:value-of select="string(boolean($floatingStream/fpml:stubCalculationPeriodAmount/fpml:finalStub/fpml:floatingRate[2]))"/>
</xsl:if>
</BackStubLinearInterpolation>
<BackStubInitialInterpIndex>
<xsl:if test="$swExtendedTradeDetails/fpml:swStub[2] and $floatingStream/fpml:stubCalculationPeriodAmount/fpml:finalStub/fpml:floatingRate[2] and ($floatingStream/fpml:stubCalculationPeriodAmount/fpml:finalStub/fpml:floatingRate[1]/fpml:floatingRateIndex!=$floatingStream/fpml:stubCalculationPeriodAmount/fpml:finalStub/fpml:floatingRate[2]/fpml:floatingRateIndex)">
<xsl:value-of select="$floatingStream/fpml:stubCalculationPeriodAmount/fpml:finalStub/fpml:floatingRate[1]/fpml:floatingRateIndex"/>
</xsl:if>
</BackStubInitialInterpIndex>
<FirstFixedRegPdStartDate>
<xsl:if test="$fixedStream/fpml:calculationPeriodDates/fpml:firstRegularPeriodStartDate">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string($fixedStream/fpml:calculationPeriodDates/fpml:firstRegularPeriodStartDate)"/>
</xsl:call-template>
</xsl:if>
</FirstFixedRegPdStartDate>
<FirstFixedRegPdStartDate_2>
<xsl:if test="$fixedStream2/fpml:calculationPeriodDates/fpml:firstRegularPeriodStartDate">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string($fixedStream2/fpml:calculationPeriodDates/fpml:firstRegularPeriodStartDate)"/>
</xsl:call-template>
</xsl:if>
</FirstFixedRegPdStartDate_2>
<FirstFloatRegPdStartDate>
<xsl:if test="$floatingStream/fpml:calculationPeriodDates/fpml:firstRegularPeriodStartDate">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string($floatingStream/fpml:calculationPeriodDates/fpml:firstRegularPeriodStartDate)"/>
</xsl:call-template>
</xsl:if>
</FirstFloatRegPdStartDate>
<FirstFloatRegPdStartDate_2>
<xsl:if test="$productType='Single Currency Basis Swap'">
<xsl:if test="$floatingStream2/fpml:calculationPeriodDates/fpml:firstRegularPeriodStartDate">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string($floatingStream2/fpml:calculationPeriodDates/fpml:firstRegularPeriodStartDate)"/>
</xsl:call-template>
</xsl:if>
</xsl:if>
</FirstFloatRegPdStartDate_2>
<LastFixedRegPdEndDate>
<xsl:if test="$fixedStream/fpml:calculationPeriodDates/fpml:lastRegularPeriodEndDate">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string($fixedStream/fpml:calculationPeriodDates/fpml:lastRegularPeriodEndDate)"/>
</xsl:call-template>
</xsl:if>
</LastFixedRegPdEndDate>
<LastFixedRegPdEndDate_2>
<xsl:if test="$fixedStream2/fpml:calculationPeriodDates/fpml:lastRegularPeriodEndDate">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string($fixedStream2/fpml:calculationPeriodDates/fpml:lastRegularPeriodEndDate)"/>
</xsl:call-template>
</xsl:if>
</LastFixedRegPdEndDate_2>
<LastFloatRegPdEndDate>
<xsl:if test="$floatingStream/fpml:calculationPeriodDates/fpml:lastRegularPeriodEndDate">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string($floatingStream/fpml:calculationPeriodDates/fpml:lastRegularPeriodEndDate)"/>
</xsl:call-template>
</xsl:if>
</LastFloatRegPdEndDate>
<LastFloatRegPdEndDate_2>
<xsl:if test="$productType='Single Currency Basis Swap'">
<xsl:if test="$floatingStream2/fpml:calculationPeriodDates/fpml:lastRegularPeriodEndDate">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string($floatingStream2/fpml:calculationPeriodDates/fpml:lastRegularPeriodEndDate)"/>
</xsl:call-template>
</xsl:if>
</xsl:if>
</LastFloatRegPdEndDate_2>
<MasterAgreement>
<xsl:value-of select="$trade/fpml:documentation/fpml:masterAgreement/fpml:masterAgreementType"/>
</MasterAgreement>
<ManualConfirm>
<xsl:value-of select="$swTradeHeader/fpml:swManualConfirmationRequired"/>
</ManualConfirm>
<NovationExecution>
<xsl:value-of select="$swTradeHeader/fpml:swNovationExecution"/>
</NovationExecution>
<ExclFromClearing>
<xsl:value-of select="$swTradeHeader/fpml:swClearingNotRequired"/>
</ExclFromClearing>
<NonStdSettlInst>
<xsl:choose>
<xsl:when test="$swTradeHeader/fpml:swStandardSettlementInstructions[.='true']">false</xsl:when>
<xsl:when test="$swTradeHeader/fpml:swStandardSettlementInstructions[.='false']">true</xsl:when>
</xsl:choose>
</NonStdSettlInst>
<Normalised>
<xsl:value-of select="$swTradeHeader/fpml:swNormalised"/>
</Normalised>
<DataMigrationId>
<xsl:value-of select="$swTradeHeader/fpml:swDataMigrationId"/>
</DataMigrationId>
<NormalisedStubLength>
<xsl:value-of select="$swTradeHeader/fpml:swNormalised/@stubLength"/>
</NormalisedStubLength>
<ClientClearing>
<xsl:value-of select="$swTradeHeader/fpml:swClientClearing"/>
</ClientClearing>
<AutoSendForClearing>
<xsl:value-of select="$swTradeHeader/fpml:swAutoSendForClearing"/>
</AutoSendForClearing>
<CBClearedTimestamp>
<xsl:value-of select="$swTradeHeader/fpml:swCBClearedTimestamp"/>
</CBClearedTimestamp>
<CBTradeType>
<xsl:value-of select="$swTradeHeader/fpml:swCBTradeType"/>
</CBTradeType>
<ASICMandatoryClearingIndicator>
<xsl:value-of select="$swMandatoryClearing[fpml:swJurisdiction='ASIC']/fpml:swMandatoryClearingIndicator"/>
</ASICMandatoryClearingIndicator>
<NewNovatedASICMandatoryClearingIndicator>
<xsl:value-of select="$swMandatoryClearingNewNovatedTradeAS/fpml:swMandatoryClearingIndicator"/>
</NewNovatedASICMandatoryClearingIndicator>
<PBEBTradeASICMandatoryClearingIndicator>
<xsl:value-of select="$swGiveUp/fpml:swInterDealerTransaction/fpml:swMandatoryClearing[fpml:swJurisdiction='ASIC']/fpml:swMandatoryClearingIndicator"/>
</PBEBTradeASICMandatoryClearingIndicator>
<PBClientTradeASICMandatoryClearingIndicator>
<xsl:value-of select="$swGiveUp/fpml:swCustomerTransaction/fpml:swMandatoryClearing[fpml:swJurisdiction='ASIC']/fpml:swMandatoryClearingIndicator"/>
</PBClientTradeASICMandatoryClearingIndicator>
<CANMandatoryClearingIndicator>
<xsl:value-of select="$swMandatoryClearing[fpml:swJurisdiction='CAN']/fpml:swMandatoryClearingIndicator"/>
</CANMandatoryClearingIndicator>
<CANClearingExemptIndicator1PartyId>
<xsl:value-of select="$FpML/fpml:party[@id=$swMandatoryClearing[fpml:swJurisdiction='CAN']/fpml:swPartyExemption[1]/fpml:swPartyReference/@href]/fpml:partyId"/>
</CANClearingExemptIndicator1PartyId>
<CANClearingExemptIndicator1Value>
<xsl:value-of select="$swMandatoryClearing[fpml:swJurisdiction='CAN']/fpml:swPartyExemption[1]/fpml:swExemption"/>
</CANClearingExemptIndicator1Value>
<CANClearingExemptIndicator2PartyId>
<xsl:value-of select="$FpML/fpml:party[@id=$swMandatoryClearing[fpml:swJurisdiction='CAN']/fpml:swPartyExemption[2]/fpml:swPartyReference/@href]/fpml:partyId"/>
</CANClearingExemptIndicator2PartyId>
<CANClearingExemptIndicator2Value>
<xsl:value-of select="$swMandatoryClearing[fpml:swJurisdiction='CAN']/fpml:swPartyExemption[2]/fpml:swExemption"/>
</CANClearingExemptIndicator2Value>
<NewNovatedCANMandatoryClearingIndicator>
<xsl:value-of select="$swMandatoryClearingNewNovatedTradeES/fpml:swMandatoryClearingIndicator"/>
</NewNovatedCANMandatoryClearingIndicator>
<NewNovatedCANClearingExemptIndicator1PartyId>
<xsl:value-of select="$FpML/fpml:party[@id=$swMandatoryClearingNewNovatedTradeES/fpml:swPartyExemption[1]/fpml:swPartyReference/@href]/fpml:partyId"/>
</NewNovatedCANClearingExemptIndicator1PartyId>
<NewNovatedCANClearingExemptIndicator1Value>
<xsl:value-of select="$swMandatoryClearingNewNovatedTradeES/fpml:swPartyExemption[1]/fpml:swExemption"/>
</NewNovatedCANClearingExemptIndicator1Value>
<NewNovatedCANClearingExemptIndicator2PartyId>
<xsl:value-of select="$FpML/fpml:party[@id=$swMandatoryClearingNewNovatedTradeES/fpml:swPartyExemption[2]/fpml:swPartyReference/@href]/fpml:partyId"/>
</NewNovatedCANClearingExemptIndicator2PartyId>
<NewNovatedCANClearingExemptIndicator2Value>
<xsl:value-of select="$swMandatoryClearingNewNovatedTradeES/fpml:swPartyExemption[2]/fpml:swExemption"/>
</NewNovatedCANClearingExemptIndicator2Value>
<PBEBTradeCANMandatoryClearingIndicator>
<xsl:value-of select="$swGiveUp/fpml:swInterDealerTransaction/fpml:swMandatoryClearing[fpml:swJurisdiction='CAN']/fpml:swMandatoryClearingIndicator"/>
</PBEBTradeCANMandatoryClearingIndicator>
<PBEBTradeCANClearingExemptIndicator1PartyId>
<xsl:value-of select="$FpML/fpml:party[@id=$swGiveUp/fpml:swInterDealerTransaction/fpml:swMandatoryClearing[fpml:swJurisdiction='CAN']/fpml:swPartyExemption[1]/fpml:swPartyReference/@href]/fpml:partyId"/>
</PBEBTradeCANClearingExemptIndicator1PartyId>
<PBEBTradeCANClearingExemptIndicator1Value>
<xsl:value-of select="$swGiveUp/fpml:swInterDealerTransaction/fpml:swMandatoryClearing[fpml:swJurisdiction='CAN']/fpml:swPartyExemption[1]/fpml:swExemption"/>
</PBEBTradeCANClearingExemptIndicator1Value>
<PBEBTradeCANClearingExemptIndicator2PartyId>
<xsl:value-of select="$FpML/fpml:party[@id=$swGiveUp/fpml:swInterDealerTransaction/fpml:swMandatoryClearing[fpml:swJurisdiction='CAN']/fpml:swPartyExemption[2]/fpml:swPartyReference/@href]/fpml:partyId"/>
</PBEBTradeCANClearingExemptIndicator2PartyId>
<PBEBTradeCANClearingExemptIndicator2Value>
<xsl:value-of select="$swGiveUp/fpml:swInterDealerTransaction/fpml:swMandatoryClearing[fpml:swJurisdiction='CAN']/fpml:swPartyExemption[2]/fpml:swExemption"/>
</PBEBTradeCANClearingExemptIndicator2Value>
<PBClientTradeCANMandatoryClearingIndicator>
<xsl:value-of select="$swGiveUp/fpml:swCustomerTransaction/fpml:swMandatoryClearing[fpml:swJurisdiction='CAN']/fpml:swMandatoryClearingIndicator"/>
</PBClientTradeCANMandatoryClearingIndicator>
<PBClientTradeCANClearingExemptIndicator1PartyId>
<xsl:value-of select="$FpML/fpml:party[@id=$swGiveUp/fpml:swCustomerTransaction/fpml:swMandatoryClearing[fpml:swJurisdiction='CAN']/fpml:swPartyExemption[1]/fpml:swPartyReference/@href]/fpml:partyId"/>
</PBClientTradeCANClearingExemptIndicator1PartyId>
<PBClientTradeCANClearingExemptIndicator1Value>
<xsl:value-of select="$swGiveUp/fpml:swCustomerTransaction/fpml:swMandatoryClearing[fpml:swJurisdiction='CAN']/fpml:swPartyExemption[1]/fpml:swExemption"/>
</PBClientTradeCANClearingExemptIndicator1Value>
<PBClientTradeCANClearingExemptIndicator2PartyId>
<xsl:value-of select="$FpML/fpml:party[@id=$swGiveUp/fpml:swCustomerTransaction/fpml:swMandatoryClearing[fpml:swJurisdiction='CAN']/fpml:swPartyExemption[2]/fpml:swPartyReference/@href]/fpml:partyId"/>
</PBClientTradeCANClearingExemptIndicator2PartyId>
<PBClientTradeCANClearingExemptIndicator2Value>
<xsl:value-of select="$swGiveUp/fpml:swCustomerTransaction/fpml:swMandatoryClearing[fpml:swJurisdiction='CAN']/fpml:swPartyExemption[2]/fpml:swExemption"/>
</PBClientTradeCANClearingExemptIndicator2Value>
<ESMAMandatoryClearingIndicator>
<xsl:value-of select="$swMandatoryClearing[fpml:swJurisdiction='ESMA']/fpml:swMandatoryClearingIndicator"/>
</ESMAMandatoryClearingIndicator>
<ESMAClearingExemptIndicator1PartyId>
<xsl:value-of select="$FpML/fpml:party[@id=$swMandatoryClearing[fpml:swJurisdiction='ESMA']/fpml:swPartyExemption[1]/fpml:swPartyReference/@href]/fpml:partyId"/>
</ESMAClearingExemptIndicator1PartyId>
<ESMAClearingExemptIndicator1Value>
<xsl:value-of select="$swMandatoryClearing[fpml:swJurisdiction='ESMA']/fpml:swPartyExemption[1]/fpml:swExemption"/>
</ESMAClearingExemptIndicator1Value>
<ESMAClearingExemptIndicator2PartyId>
<xsl:value-of select="$FpML/fpml:party[@id=$swMandatoryClearing[fpml:swJurisdiction='ESMA']/fpml:swPartyExemption[2]/fpml:swPartyReference/@href]/fpml:partyId"/>
</ESMAClearingExemptIndicator2PartyId>
<ESMAClearingExemptIndicator2Value>
<xsl:value-of select="$swMandatoryClearing[fpml:swJurisdiction='ESMA']/fpml:swPartyExemption[2]/fpml:swExemption"/>
</ESMAClearingExemptIndicator2Value>
<NewNovatedESMAMandatoryClearingIndicator>
<xsl:value-of select="$swMandatoryClearingNewNovatedTradeES/fpml:swMandatoryClearingIndicator"/>
</NewNovatedESMAMandatoryClearingIndicator>
<NewNovatedESMAClearingExemptIndicator1PartyId>
<xsl:value-of select="$FpML/fpml:party[@id=$swMandatoryClearingNewNovatedTradeES/fpml:swPartyExemption[1]/fpml:swPartyReference/@href]/fpml:partyId"/>
</NewNovatedESMAClearingExemptIndicator1PartyId>
<NewNovatedESMAClearingExemptIndicator1Value>
<xsl:value-of select="$swMandatoryClearingNewNovatedTradeES/fpml:swPartyExemption[1]/fpml:swExemption"/>
</NewNovatedESMAClearingExemptIndicator1Value>
<NewNovatedESMAClearingExemptIndicator2PartyId>
<xsl:value-of select="$FpML/fpml:party[@id=$swMandatoryClearingNewNovatedTradeES/fpml:swPartyExemption[2]/fpml:swPartyReference/@href]/fpml:partyId"/>
</NewNovatedESMAClearingExemptIndicator2PartyId>
<NewNovatedESMAClearingExemptIndicator2Value>
<xsl:value-of select="$swMandatoryClearingNewNovatedTradeES/fpml:swPartyExemption[2]/fpml:swExemption"/>
</NewNovatedESMAClearingExemptIndicator2Value>
<PBEBTradeESMAMandatoryClearingIndicator>
<xsl:value-of select="$swGiveUp/fpml:swInterDealerTransaction/fpml:swMandatoryClearing[fpml:swJurisdiction='ESMA']/fpml:swMandatoryClearingIndicator"/>
</PBEBTradeESMAMandatoryClearingIndicator>
<PBEBTradeESMAClearingExemptIndicator1PartyId>
<xsl:value-of select="$FpML/fpml:party[@id=$swGiveUp/fpml:swInterDealerTransaction/fpml:swMandatoryClearing[fpml:swJurisdiction='ESMA']/fpml:swPartyExemption[1]/fpml:swPartyReference/@href]/fpml:partyId"/>
</PBEBTradeESMAClearingExemptIndicator1PartyId>
<PBEBTradeESMAClearingExemptIndicator1Value>
<xsl:value-of select="$swGiveUp/fpml:swInterDealerTransaction/fpml:swMandatoryClearing[fpml:swJurisdiction='ESMA']/fpml:swPartyExemption[1]/fpml:swExemption"/>
</PBEBTradeESMAClearingExemptIndicator1Value>
<PBEBTradeESMAClearingExemptIndicator2PartyId>
<xsl:value-of select="$FpML/fpml:party[@id=$swGiveUp/fpml:swInterDealerTransaction/fpml:swMandatoryClearing[fpml:swJurisdiction='ESMA']/fpml:swPartyExemption[2]/fpml:swPartyReference/@href]/fpml:partyId"/>
</PBEBTradeESMAClearingExemptIndicator2PartyId>
<PBEBTradeESMAClearingExemptIndicator2Value>
<xsl:value-of select="$swGiveUp/fpml:swInterDealerTransaction/fpml:swMandatoryClearing[fpml:swJurisdiction='ESMA']/fpml:swPartyExemption[2]/fpml:swExemption"/>
</PBEBTradeESMAClearingExemptIndicator2Value>
<PBClientTradeESMAMandatoryClearingIndicator>
<xsl:value-of select="$swGiveUp/fpml:swCustomerTransaction/fpml:swMandatoryClearing[fpml:swJurisdiction='ESMA']/fpml:swMandatoryClearingIndicator"/>
</PBClientTradeESMAMandatoryClearingIndicator>
<PBClientTradeESMAClearingExemptIndicator1PartyId>
<xsl:value-of select="$FpML/fpml:party[@id=$swGiveUp/fpml:swCustomerTransaction/fpml:swMandatoryClearing[fpml:swJurisdiction='ESMA']/fpml:swPartyExemption[1]/fpml:swPartyReference/@href]/fpml:partyId"/>
</PBClientTradeESMAClearingExemptIndicator1PartyId>
<PBClientTradeESMAClearingExemptIndicator1Value>
<xsl:value-of select="$swGiveUp/fpml:swCustomerTransaction/fpml:swMandatoryClearing[fpml:swJurisdiction='ESMA']/fpml:swPartyExemption[1]/fpml:swExemption"/>
</PBClientTradeESMAClearingExemptIndicator1Value>
<PBClientTradeESMAClearingExemptIndicator2PartyId>
<xsl:value-of select="$FpML/fpml:party[@id=$swGiveUp/fpml:swCustomerTransaction/fpml:swMandatoryClearing[fpml:swJurisdiction='ESMA']/fpml:swPartyExemption[2]/fpml:swPartyReference/@href]/fpml:partyId"/>
</PBClientTradeESMAClearingExemptIndicator2PartyId>
<PBClientTradeESMAClearingExemptIndicator2Value>
<xsl:value-of select="$swGiveUp/fpml:swCustomerTransaction/fpml:swMandatoryClearing[fpml:swJurisdiction='ESMA']/fpml:swPartyExemption[2]/fpml:swExemption"/>
</PBClientTradeESMAClearingExemptIndicator2Value>
<FCAMandatoryClearingIndicator>
<xsl:value-of select="$swMandatoryClearing[fpml:swJurisdiction='FCA']/fpml:swMandatoryClearingIndicator"/>
</FCAMandatoryClearingIndicator>
<FCAClearingExemptIndicator1PartyId>
<xsl:value-of select="$FpML/fpml:party[@id=$swMandatoryClearing[fpml:swJurisdiction='FCA']/fpml:swPartyExemption[1]/fpml:swPartyReference/@href]/fpml:partyId"/>
</FCAClearingExemptIndicator1PartyId>
<FCAClearingExemptIndicator1Value>
<xsl:value-of select="$swMandatoryClearing[fpml:swJurisdiction='FCA']/fpml:swPartyExemption[1]/fpml:swExemption"/>
</FCAClearingExemptIndicator1Value>
<FCAClearingExemptIndicator2PartyId>
<xsl:value-of select="$FpML/fpml:party[@id=$swMandatoryClearing[fpml:swJurisdiction='FCA']/fpml:swPartyExemption[2]/fpml:swPartyReference/@href]/fpml:partyId"/>
</FCAClearingExemptIndicator2PartyId>
<FCAClearingExemptIndicator2Value>
<xsl:value-of select="$swMandatoryClearing[fpml:swJurisdiction='FCA']/fpml:swPartyExemption[2]/fpml:swExemption"/>
</FCAClearingExemptIndicator2Value>
<NewNovatedFCAMandatoryClearingIndicator>
<xsl:value-of select="$swMandatoryClearingNewNovatedTradeES/fpml:swMandatoryClearingIndicator"/>
</NewNovatedFCAMandatoryClearingIndicator>
<NewNovatedFCAClearingExemptIndicator1PartyId>
<xsl:value-of select="$FpML/fpml:party[@id=$swMandatoryClearingNewNovatedTradeES/fpml:swPartyExemption[1]/fpml:swPartyReference/@href]/fpml:partyId"/>
</NewNovatedFCAClearingExemptIndicator1PartyId>
<NewNovatedFCAClearingExemptIndicator1Value>
<xsl:value-of select="$swMandatoryClearingNewNovatedTradeES/fpml:swPartyExemption[1]/fpml:swExemption"/>
</NewNovatedFCAClearingExemptIndicator1Value>
<NewNovatedFCAClearingExemptIndicator2PartyId>
<xsl:value-of select="$FpML/fpml:party[@id=$swMandatoryClearingNewNovatedTradeES/fpml:swPartyExemption[2]/fpml:swPartyReference/@href]/fpml:partyId"/>
</NewNovatedFCAClearingExemptIndicator2PartyId>
<NewNovatedFCAClearingExemptIndicator2Value>
<xsl:value-of select="$swMandatoryClearingNewNovatedTradeES/fpml:swPartyExemption[2]/fpml:swExemption"/>
</NewNovatedFCAClearingExemptIndicator2Value>
<PBEBTradeFCAMandatoryClearingIndicator>
<xsl:value-of select="$swGiveUp/fpml:swInterDealerTransaction/fpml:swMandatoryClearing[fpml:swJurisdiction='FCA']/fpml:swMandatoryClearingIndicator"/>
</PBEBTradeFCAMandatoryClearingIndicator>
<PBEBTradeFCAClearingExemptIndicator1PartyId>
<xsl:value-of select="$FpML/fpml:party[@id=$swGiveUp/fpml:swInterDealerTransaction/fpml:swMandatoryClearing[fpml:swJurisdiction='FCA']/fpml:swPartyExemption[1]/fpml:swPartyReference/@href]/fpml:partyId"/>
</PBEBTradeFCAClearingExemptIndicator1PartyId>
<PBEBTradeFCAClearingExemptIndicator1Value>
<xsl:value-of select="$swGiveUp/fpml:swInterDealerTransaction/fpml:swMandatoryClearing[fpml:swJurisdiction='FCA']/fpml:swPartyExemption[1]/fpml:swExemption"/>
</PBEBTradeFCAClearingExemptIndicator1Value>
<PBEBTradeFCAClearingExemptIndicator2PartyId>
<xsl:value-of select="$FpML/fpml:party[@id=$swGiveUp/fpml:swInterDealerTransaction/fpml:swMandatoryClearing[fpml:swJurisdiction='FCA']/fpml:swPartyExemption[2]/fpml:swPartyReference/@href]/fpml:partyId"/>
</PBEBTradeFCAClearingExemptIndicator2PartyId>
<PBEBTradeFCAClearingExemptIndicator2Value>
<xsl:value-of select="$swGiveUp/fpml:swInterDealerTransaction/fpml:swMandatoryClearing[fpml:swJurisdiction='FCA']/fpml:swPartyExemption[2]/fpml:swExemption"/>
</PBEBTradeFCAClearingExemptIndicator2Value>
<PBClientTradeFCAMandatoryClearingIndicator>
<xsl:value-of select="$swGiveUp/fpml:swCustomerTransaction/fpml:swMandatoryClearing[fpml:swJurisdiction='FCA']/fpml:swMandatoryClearingIndicator"/>
</PBClientTradeFCAMandatoryClearingIndicator>
<PBClientTradeFCAClearingExemptIndicator1PartyId>
<xsl:value-of select="$FpML/fpml:party[@id=$swGiveUp/fpml:swCustomerTransaction/fpml:swMandatoryClearing[fpml:swJurisdiction='FCA']/fpml:swPartyExemption[1]/fpml:swPartyReference/@href]/fpml:partyId"/>
</PBClientTradeFCAClearingExemptIndicator1PartyId>
<PBClientTradeFCAClearingExemptIndicator1Value>
<xsl:value-of select="$swGiveUp/fpml:swCustomerTransaction/fpml:swMandatoryClearing[fpml:swJurisdiction='FCA']/fpml:swPartyExemption[1]/fpml:swExemption"/>
</PBClientTradeFCAClearingExemptIndicator1Value>
<PBClientTradeFCAClearingExemptIndicator2PartyId>
<xsl:value-of select="$FpML/fpml:party[@id=$swGiveUp/fpml:swCustomerTransaction/fpml:swMandatoryClearing[fpml:swJurisdiction='FCA']/fpml:swPartyExemption[2]/fpml:swPartyReference/@href]/fpml:partyId"/>
</PBClientTradeFCAClearingExemptIndicator2PartyId>
<PBClientTradeFCAClearingExemptIndicator2Value>
<xsl:value-of select="$swGiveUp/fpml:swCustomerTransaction/fpml:swMandatoryClearing[fpml:swJurisdiction='FCA']/fpml:swPartyExemption[2]/fpml:swExemption"/>
</PBClientTradeFCAClearingExemptIndicator2Value>
<HKMAMandatoryClearingIndicator>
<xsl:value-of select="$swMandatoryClearing[fpml:swJurisdiction='HKMA']/fpml:swMandatoryClearingIndicator"/>
</HKMAMandatoryClearingIndicator>
<HKMAClearingExemptIndicator1PartyId>
<xsl:value-of select="$FpML/fpml:party[@id=$swMandatoryClearing[fpml:swJurisdiction='HKMA']/fpml:swPartyExemption[1]/fpml:swPartyReference/@href]/fpml:partyId"/>
</HKMAClearingExemptIndicator1PartyId>
<HKMAClearingExemptIndicator1Value>
<xsl:value-of select="$swMandatoryClearing[fpml:swJurisdiction='HKMA']/fpml:swPartyExemption[1]/fpml:swExemption"/>
</HKMAClearingExemptIndicator1Value>
<HKMAClearingExemptIndicator2PartyId>
<xsl:value-of select="$FpML/fpml:party[@id=$swMandatoryClearing[fpml:swJurisdiction='HKMA']/fpml:swPartyExemption[2]/fpml:swPartyReference/@href]/fpml:partyId"/>
</HKMAClearingExemptIndicator2PartyId>
<HKMAClearingExemptIndicator2Value>
<xsl:value-of select="$swMandatoryClearing[fpml:swJurisdiction='HKMA']/fpml:swPartyExemption[2]/fpml:swExemption"/>
</HKMAClearingExemptIndicator2Value>
<NewNovatedHKMAMandatoryClearingIndicator>
<xsl:value-of select="$swMandatoryClearingNewNovatedTradeES/fpml:swMandatoryClearingIndicator"/>
</NewNovatedHKMAMandatoryClearingIndicator>
<NewNovatedHKMAClearingExemptIndicator1PartyId>
<xsl:value-of select="$FpML/fpml:party[@id=$swMandatoryClearingNewNovatedTradeES/fpml:swPartyExemption[1]/fpml:swPartyReference/@href]/fpml:partyId"/>
</NewNovatedHKMAClearingExemptIndicator1PartyId>
<NewNovatedHKMAClearingExemptIndicator1Value>
<xsl:value-of select="$swMandatoryClearingNewNovatedTradeES/fpml:swPartyExemption[1]/fpml:swExemption"/>
</NewNovatedHKMAClearingExemptIndicator1Value>
<NewNovatedHKMAClearingExemptIndicator2PartyId>
<xsl:value-of select="$FpML/fpml:party[@id=$swMandatoryClearingNewNovatedTradeES/fpml:swPartyExemption[2]/fpml:swPartyReference/@href]/fpml:partyId"/>
</NewNovatedHKMAClearingExemptIndicator2PartyId>
<NewNovatedHKMAClearingExemptIndicator2Value>
<xsl:value-of select="$swMandatoryClearingNewNovatedTradeES/fpml:swPartyExemption[2]/fpml:swExemption"/>
</NewNovatedHKMAClearingExemptIndicator2Value>
<PBEBTradeHKMAMandatoryClearingIndicator>
<xsl:value-of select="$swGiveUp/fpml:swInterDealerTransaction/fpml:swMandatoryClearing[fpml:swJurisdiction='HKMA']/fpml:swMandatoryClearingIndicator"/>
</PBEBTradeHKMAMandatoryClearingIndicator>
<PBEBTradeHKMAClearingExemptIndicator1PartyId>
<xsl:value-of select="$FpML/fpml:party[@id=$swGiveUp/fpml:swInterDealerTransaction/fpml:swMandatoryClearing[fpml:swJurisdiction='HKMA']/fpml:swPartyExemption[1]/fpml:swPartyReference/@href]/fpml:partyId"/>
</PBEBTradeHKMAClearingExemptIndicator1PartyId>
<PBEBTradeHKMAClearingExemptIndicator1Value>
<xsl:value-of select="$swGiveUp/fpml:swInterDealerTransaction/fpml:swMandatoryClearing[fpml:swJurisdiction='HKMA']/fpml:swPartyExemption[1]/fpml:swExemption"/>
</PBEBTradeHKMAClearingExemptIndicator1Value>
<PBEBTradeHKMAClearingExemptIndicator2PartyId>
<xsl:value-of select="$FpML/fpml:party[@id=$swGiveUp/fpml:swInterDealerTransaction/fpml:swMandatoryClearing[fpml:swJurisdiction='HKMA']/fpml:swPartyExemption[2]/fpml:swPartyReference/@href]/fpml:partyId"/>
</PBEBTradeHKMAClearingExemptIndicator2PartyId>
<PBEBTradeHKMAClearingExemptIndicator2Value>
<xsl:value-of select="$swGiveUp/fpml:swInterDealerTransaction/fpml:swMandatoryClearing[fpml:swJurisdiction='HKMA']/fpml:swPartyExemption[2]/fpml:swExemption"/>
</PBEBTradeHKMAClearingExemptIndicator2Value>
<PBClientTradeHKMAMandatoryClearingIndicator>
<xsl:value-of select="$swGiveUp/fpml:swCustomerTransaction/fpml:swMandatoryClearing[fpml:swJurisdiction='HKMA']/fpml:swMandatoryClearingIndicator"/>
</PBClientTradeHKMAMandatoryClearingIndicator>
<PBClientTradeHKMAClearingExemptIndicator1PartyId>
<xsl:value-of select="$FpML/fpml:party[@id=$swGiveUp/fpml:swCustomerTransaction/fpml:swMandatoryClearing[fpml:swJurisdiction='HKMA']/fpml:swPartyExemption[1]/fpml:swPartyReference/@href]/fpml:partyId"/>
</PBClientTradeHKMAClearingExemptIndicator1PartyId>
<PBClientTradeHKMAClearingExemptIndicator1Value>
<xsl:value-of select="$swGiveUp/fpml:swCustomerTransaction/fpml:swMandatoryClearing[fpml:swJurisdiction='HKMA']/fpml:swPartyExemption[1]/fpml:swExemption"/>
</PBClientTradeHKMAClearingExemptIndicator1Value>
<PBClientTradeHKMAClearingExemptIndicator2PartyId>
<xsl:value-of select="$FpML/fpml:party[@id=$swGiveUp/fpml:swCustomerTransaction/fpml:swMandatoryClearing[fpml:swJurisdiction='HKMA']/fpml:swPartyExemption[2]/fpml:swPartyReference/@href]/fpml:partyId"/>
</PBClientTradeHKMAClearingExemptIndicator2PartyId>
<PBClientTradeHKMAClearingExemptIndicator2Value>
<xsl:value-of select="$swGiveUp/fpml:swCustomerTransaction/fpml:swMandatoryClearing[fpml:swJurisdiction='HKMA']/fpml:swPartyExemption[2]/fpml:swExemption"/>
</PBClientTradeHKMAClearingExemptIndicator2Value>
<JFSAMandatoryClearingIndicator>
<xsl:value-of select="$swMandatoryClearing[fpml:swJurisdiction='JFSA']/fpml:swMandatoryClearingIndicator"/>
</JFSAMandatoryClearingIndicator>
<CFTCMandatoryClearingIndicator>
<xsl:choose>
<xsl:when test="$swMandatoryClearingDF/fpml:swMandatoryClearingIndicator">
<xsl:value-of select="$swMandatoryClearingDF/fpml:swMandatoryClearingIndicator"/>
</xsl:when>
<xsl:when test="$swTradeEventReportingDetails/fpml:swReportingRegimeInformation[fpml:swJurisdiction/text()='DoddFrank']/fpml:swMandatoryClearingIndicator">
<xsl:value-of select="$swTradeEventReportingDetails/fpml:swReportingRegimeInformation[fpml:swJurisdiction/text()='DoddFrank']/fpml:swMandatoryClearingIndicator"/>
</xsl:when>
</xsl:choose>
</CFTCMandatoryClearingIndicator>
<CFTCClearingExemptIndicator1PartyId>
<xsl:value-of select="$FpML/fpml:party[@id=$swMandatoryClearingDF/fpml:swPartyExemption[1]/fpml:swPartyReference/@href]/fpml:partyId"/>
</CFTCClearingExemptIndicator1PartyId>
<CFTCClearingExemptIndicator1Value>
<xsl:value-of select="$swMandatoryClearingDF/fpml:swPartyExemption[1]/fpml:swExemption"/>
</CFTCClearingExemptIndicator1Value>
<CFTCClearingExemptIndicator2PartyId>
<xsl:value-of select="$FpML/fpml:party[@id=$swMandatoryClearingDF/fpml:swPartyExemption[2]/fpml:swPartyReference/@href]/fpml:partyId"/>
</CFTCClearingExemptIndicator2PartyId>
<CFTCClearingExemptIndicator2Value>
<xsl:value-of select="$swMandatoryClearingDF/fpml:swPartyExemption[2]/fpml:swExemption"/>
</CFTCClearingExemptIndicator2Value>
<CFTCInterAffiliateExemption>
<xsl:value-of select="$swMandatoryClearingDF/fpml:swInterAffiliateExemption"/>
</CFTCInterAffiliateExemption>
<NewNovatedCFTCMandatoryClearingIndicator>
<xsl:value-of select="$swMandatoryClearingNewNovatedTradeDF/fpml:swMandatoryClearingIndicator"/>
</NewNovatedCFTCMandatoryClearingIndicator>
<NewNovatedCFTCClearingExemptIndicator1PartyId>
<xsl:value-of select="$FpML/fpml:party[@id=$swMandatoryClearingNewNovatedTradeDF/fpml:swPartyExemption[1]/fpml:swPartyReference/@href]/fpml:partyId"/>
</NewNovatedCFTCClearingExemptIndicator1PartyId>
<NewNovatedCFTCClearingExemptIndicator1Value>
<xsl:value-of select="$swMandatoryClearingNewNovatedTradeDF/fpml:swPartyExemption[1]/fpml:swExemption"/>
</NewNovatedCFTCClearingExemptIndicator1Value>
<NewNovatedCFTCClearingExemptIndicator2PartyId>
<xsl:value-of select="$FpML/fpml:party[@id=$swMandatoryClearingNewNovatedTradeDF/fpml:swPartyExemption[2]/fpml:swPartyReference/@href]/fpml:partyId"/>
</NewNovatedCFTCClearingExemptIndicator2PartyId>
<NewNovatedCFTCClearingExemptIndicator2Value>
<xsl:value-of select="$swMandatoryClearingNewNovatedTradeDF/fpml:swPartyExemption[2]/fpml:swExemption"/>
</NewNovatedCFTCClearingExemptIndicator2Value>
<NewNovatedCFTCInterAffiliateExemption>
<xsl:value-of select="$swMandatoryClearingNewNovatedTradeDF/fpml:swInterAffiliateExemption"/>
</NewNovatedCFTCInterAffiliateExemption>
<PBEBTradeCFTCMandatoryClearingIndicator>
<xsl:value-of select="$swGiveUp/fpml:swInterDealerTransaction/fpml:swMandatoryClearing[fpml:swJurisdiction='DoddFrank']/fpml:swMandatoryClearingIndicator"/>
</PBEBTradeCFTCMandatoryClearingIndicator>
<PBEBTradeJFSAMandatoryClearingIndicator>
<xsl:value-of select="$swGiveUp/fpml:swInterDealerTransaction/fpml:swMandatoryClearing[fpml:swJurisdiction='JFSA']/fpml:swMandatoryClearingIndicator"/>
</PBEBTradeJFSAMandatoryClearingIndicator>
<PBEBTradeCFTCClearingExemptIndicator1PartyId>
<xsl:value-of select="$FpML/fpml:party[@id=$swGiveUp/fpml:swInterDealerTransaction/fpml:swMandatoryClearing[fpml:swJurisdiction='DoddFrank']/fpml:swPartyExemption[1]/fpml:swPartyReference/@href]/fpml:partyId"/>
</PBEBTradeCFTCClearingExemptIndicator1PartyId>
<PBEBTradeCFTCClearingExemptIndicator1Value>
<xsl:value-of select="$swGiveUp/fpml:swInterDealerTransaction/fpml:swMandatoryClearing[fpml:swJurisdiction='DoddFrank']/fpml:swPartyExemption[1]/fpml:swExemption"/>
</PBEBTradeCFTCClearingExemptIndicator1Value>
<PBEBTradeCFTCClearingExemptIndicator2PartyId>
<xsl:value-of select="$FpML/fpml:party[@id=$swGiveUp/fpml:swInterDealerTransaction/fpml:swMandatoryClearing[fpml:swJurisdiction='DoddFrank']/fpml:swPartyExemption[2]/fpml:swPartyReference/@href]/fpml:partyId"/>
</PBEBTradeCFTCClearingExemptIndicator2PartyId>
<PBEBTradeCFTCClearingExemptIndicator2Value>
<xsl:value-of select="$swGiveUp/fpml:swInterDealerTransaction/fpml:swMandatoryClearing[fpml:swJurisdiction='DoddFrank']/fpml:swPartyExemption[2]/fpml:swExemption"/>
</PBEBTradeCFTCClearingExemptIndicator2Value>
<PBEBTradeCFTCInterAffiliateExemption>
<xsl:value-of select="$swGiveUp/fpml:swInterDealerTransaction/fpml:swMandatoryClearing[fpml:swJurisdiction='DoddFrank']/fpml:swInterAffiliateExemption"/>
</PBEBTradeCFTCInterAffiliateExemption>
<PBClientTradeCFTCMandatoryClearingIndicator>
<xsl:value-of select="$swGiveUp/fpml:swCustomerTransaction/fpml:swMandatoryClearing[fpml:swJurisdiction='DoddFrank']/fpml:swMandatoryClearingIndicator"/>
</PBClientTradeCFTCMandatoryClearingIndicator>
<PBClientTradeJFSAMandatoryClearingIndicator>
<xsl:value-of select="$swGiveUp/fpml:swCustomerTransaction/fpml:swMandatoryClearing[fpml:swJurisdiction='JFSA']/fpml:swMandatoryClearingIndicator"/>
</PBClientTradeJFSAMandatoryClearingIndicator>
<PBClientTradeCFTCClearingExemptIndicator1PartyId>
<xsl:value-of select="$FpML/fpml:party[@id=$swGiveUp/fpml:swCustomerTransaction/fpml:swMandatoryClearing[fpml:swJurisdiction='DoddFrank']/fpml:swPartyExemption[1]/fpml:swPartyReference/@href]/fpml:partyId"/>
</PBClientTradeCFTCClearingExemptIndicator1PartyId>
<PBClientTradeCFTCClearingExemptIndicator1Value>
<xsl:value-of select="$swGiveUp/fpml:swCustomerTransaction/fpml:swMandatoryClearing[fpml:swJurisdiction='DoddFrank']/fpml:swPartyExemption[1]/fpml:swExemption"/>
</PBClientTradeCFTCClearingExemptIndicator1Value>
<PBClientTradeCFTCClearingExemptIndicator2PartyId>
<xsl:value-of select="$FpML/fpml:party[@id=$swGiveUp/fpml:swCustomerTransaction/fpml:swMandatoryClearing[fpml:swJurisdiction='DoddFrank']/fpml:swPartyExemption[2]/fpml:swPartyReference/@href]/fpml:partyId"/>
</PBClientTradeCFTCClearingExemptIndicator2PartyId>
<PBClientTradeCFTCClearingExemptIndicator2Value>
<xsl:value-of select="$swGiveUp/fpml:swCustomerTransaction/fpml:swMandatoryClearing[fpml:swJurisdiction='DoddFrank']/fpml:swPartyExemption[2]/fpml:swExemption"/>
</PBClientTradeCFTCClearingExemptIndicator2Value>
<PBClientTradeCFTCInterAffiliateExemption>
<xsl:value-of select="$swGiveUp/fpml:swCustomerTransaction/fpml:swMandatoryClearing[fpml:swJurisdiction='DoddFrank']/fpml:swInterAffiliateExemption"/>
</PBClientTradeCFTCInterAffiliateExemption>
<MASMandatoryClearingIndicator>
<xsl:value-of select="$swMandatoryClearing[fpml:swJurisdiction='MAS']/fpml:swMandatoryClearingIndicator"/>
</MASMandatoryClearingIndicator>
<NewNovatedMASMandatoryClearingIndicator>
<xsl:value-of select="$swMandatoryClearingNewNovatedTradeMS/fpml:swMandatoryClearingIndicator"/>
</NewNovatedMASMandatoryClearingIndicator>
<PBEBTradeMASMandatoryClearingIndicator>
<xsl:value-of select="$swGiveUp/fpml:swInterDealerTransaction/fpml:swMandatoryClearing[fpml:swJurisdiction='MAS']/fpml:swMandatoryClearingIndicator"/>
</PBEBTradeMASMandatoryClearingIndicator>
<PBClientTradeMASMandatoryClearingIndicator>
<xsl:value-of select="$swGiveUp/fpml:swCustomerTransaction/fpml:swMandatoryClearing[fpml:swJurisdiction='MAS']/fpml:swMandatoryClearingIndicator"/>
</PBClientTradeMASMandatoryClearingIndicator>
<ClearingHouseId>
<xsl:value-of select="$swShortFormTrade/fpml:swClearingHouse/fpml:partyId"/>
<xsl:value-of select="$swTradeHeader/fpml:swClearingHouse/fpml:partyId"/>
</ClearingHouseId>
<ClearingBrokerId>
<xsl:value-of select="$swTradeHeader/fpml:swClearingBroker/fpml:partyId"/>
</ClearingBrokerId>
<OriginatingEvent>
<xsl:value-of select="$swTradeHeader/fpml:swOriginatingEvent"/>
</OriginatingEvent>
<SendToCLS>
<xsl:if test="$productType='Cross Currency IRS' or $productType='Cross Currency Basis Swap' or $productType='Fixed Fixed Swap'">
<SendToCLSIE>
<xsl:if test="$swTradeHeader/fpml:swSendToCLS/fpml:swSettlementLegEligibility[@swSettlementLeg='Initial Exchange']">
<xsl:value-of select="$swTradeHeader/fpml:swSendToCLS/fpml:swSettlementLegEligibility[@swSettlementLeg='Initial Exchange']"/>
</xsl:if>
<xsl:if test="$swShortFormTrade/fpml:swCrossCurrencyIrsParameters/fpml:swSendToCLS/fpml:swSettlementLegEligibility[@swSettlementLeg='Initial Exchange']">
<xsl:value-of select="$swShortFormTrade/fpml:swCrossCurrencyIrsParameters/fpml:swSendToCLS/fpml:swSettlementLegEligibility[@swSettlementLeg='Initial Exchange']"/>
</xsl:if>
<xsl:if test="$swShortFormTrade/fpml:swCrossCurrencyBasisSwapParameters/fpml:swSendToCLS/fpml:swSettlementLegEligibility[@swSettlementLeg='Initial Exchange']">
<xsl:value-of select="$swShortFormTrade/fpml:swCrossCurrencyBasisSwapParameters/fpml:swSendToCLS/fpml:swSettlementLegEligibility[@swSettlementLeg='Initial Exchange']"/>
</xsl:if>
<xsl:if test="$swShortFormTrade/fpml:swFixedFixedParameters/fpml:swSendToCLS/fpml:swSettlementLegEligibility[@swSettlementLeg='Initial Exchange']">
<xsl:value-of select="$swShortFormTrade/fpml:swCrossCurrencyBasisSwapParameters/fpml:swSendToCLS/fpml:swSettlementLegEligibility[@swSettlementLeg='Initial Exchange']"/>
</xsl:if>
</SendToCLSIE>
<SendToCLSFE>
<xsl:if test="$swTradeHeader/fpml:swSendToCLS/fpml:swSettlementLegEligibility[@swSettlementLeg='Final Exchange']">
<xsl:value-of select="$swTradeHeader/fpml:swSendToCLS/fpml:swSettlementLegEligibility[@swSettlementLeg='Final Exchange']"/>
</xsl:if>
<xsl:if test="$swShortFormTrade/fpml:swCrossCurrencyIrsParameters/fpml:swSendToCLS/fpml:swSettlementLegEligibility[@swSettlementLeg='Final Exchange']">
<xsl:value-of select="$swShortFormTrade/fpml:swCrossCurrencyIrsParameters/fpml:swSendToCLS/fpml:swSettlementLegEligibility[@swSettlementLeg='Final Exchange']"/>
</xsl:if>
<xsl:if test="$swShortFormTrade/fpml:swCrossCurrencyBasisSwapParameters/fpml:swSendToCLS/fpml:swSettlementLegEligibility[@swSettlementLeg='Final Exchange']">
<xsl:value-of select="$swShortFormTrade/fpml:swCrossCurrencyBasisSwapParameters/fpml:swSendToCLS/fpml:swSettlementLegEligibility[@swSettlementLeg='Final Exchange']"/>
</xsl:if>
<xsl:if test="$swShortFormTrade/fpml:swFixedFixedParameters/fpml:swSendToCLS/fpml:swSettlementLegEligibility[@swSettlementLeg='Final Exchange']">
<xsl:value-of select="$swShortFormTrade/fpml:swCrossCurrencyIrsParameters/fpml:swSendToCLS/fpml:swSettlementLegEligibility[@swSettlementLeg='Final Exchange']"/>
</xsl:if>
</SendToCLSFE>
</xsl:if>
</SendToCLS>
<ESMAFrontloading>
<xsl:value-of select="$swTradeHeader/fpml:swESMAFrontloading"/>
</ESMAFrontloading>
<ESMAClearingExemption>
<xsl:value-of select="$swTradeHeader/fpml:swESMAClearingExemption"/>
</ESMAClearingExemption>
<BackLoadingFlag>
<xsl:choose>
<xsl:when test="$swTradeHeader/fpml:swBackLoadingFlag">
<xsl:value-of select="$swTradeHeader/fpml:swBackLoadingFlag"/>
</xsl:when>
<xsl:when test="$swShortFormTrade/fpml:swBackLoadingFlag">
<xsl:value-of select="$swShortFormTrade/fpml:swBackLoadingFlag"/>
</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</BackLoadingFlag>
<xsl:if test="$swTradeHeader/fpml:swBulkAction">
<BulkAction>
<xsl:value-of select="$swTradeHeader/fpml:swBulkAction"/>
</BulkAction>
</xsl:if>
<Novation>
<xsl:value-of select="string(boolean($novation))"/>
</Novation>
<xsl:variable name="tradeNotional">
<xsl:choose>
<xsl:when test="$productType='IRS' or $productType='OIS' or $productType='Swaption'">
<xsl:value-of select="$floatingStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:initialValue"/>
</xsl:when>
<xsl:when test="$productType='Fixed Fixed Swap'">
<xsl:value-of select="$fixedStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:initialValue"/>
</xsl:when>
<xsl:when test="$productType='FRA'">
<xsl:value-of select="$fra/fpml:notional/fpml:amount"/>
</xsl:when>
<xsl:when test="$productType='CapFloor'">
<xsl:value-of select="$capFloorStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:initialValue"/>
</xsl:when>
</xsl:choose>
</xsl:variable>
<xsl:variable name="novatedAmount">
<xsl:choose>
<xsl:when test="$novation/fpml:novatedAmount/fpml:amount">
<xsl:value-of select="$novation/fpml:novatedAmount/fpml:amount"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$tradeNotional"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<PartialNovation>
<xsl:if test="$novation/fpml:swPartialNovationIndicator">
<xsl:value-of select="string(boolean($novation/fpml:swPartialNovationIndicator = 'true'))"/>
</xsl:if>
</PartialNovation>
<FourWayNovation>
<xsl:choose>
<xsl:when test="$novation">
<xsl:value-of select="string(boolean($novation/fpml:otherRemainingParty))"/>
</xsl:when>
<xsl:otherwise/>
</xsl:choose>
</FourWayNovation>
<NovationTradeDate>
<xsl:choose>
<xsl:when test="$novation">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string($novation/fpml:novationTradeDate)"/>
</xsl:call-template>
</xsl:when>
<xsl:otherwise/>
</xsl:choose>
</NovationTradeDate>
<NovationDate>
<xsl:choose>
<xsl:when test="$novation">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string($novation/fpml:novationDate)"/>
</xsl:call-template>
</xsl:when>
<xsl:otherwise/>
</xsl:choose>
</NovationDate>
<NovatedAmount>
<xsl:value-of select="$novatedAmount"/>
</NovatedAmount>
<NovatedAmount_2>
<xsl:if test="$productType = 'Offline Trade Rates' or (($productType = 'Cross Currency Basis Swap' or $productType = 'Cross Currency IRS' or $productType = 'Fixed Fixed Swap') and $novation/fpml:swNovatedAmount/fpml:amount != 0) or (($productType = 'IRS' or $productType = 'OIS' or $productType = 'ZCInflationSwap') and $fixedStream/fpml:calculationPeriodAmount/fpml:knownAmountSchedule)">
<xsl:value-of select="$novation/fpml:swNovatedAmount/fpml:amount"/>
</xsl:if>
</NovatedAmount_2>
<NovatedCurrency>
<xsl:if test="$productType = 'Offline Trade Rates' or $productType = 'Cross Currency Basis Swap' or $productType = 'Cross Currency IRS' or $productType = 'Fixed Fixed Swap'">
<xsl:value-of select="$novation/fpml:novatedAmount/fpml:currency"/>
</xsl:if>
</NovatedCurrency>
<NovatedCurrency_2>
<xsl:if test="$productType = 'Offline Trade Rates' or $productType = 'Cross Currency Basis Swap' or $productType = 'Cross Currency IRS' or $productType = 'Fixed Fixed Swap'">
<xsl:value-of select="$novation/fpml:swNovatedAmount/fpml:currency"/>
</xsl:if>
</NovatedCurrency_2>
<NovatedFV>
<xsl:if test="$novation and $productType='IRS' and $currency='BRL'">
<xsl:value-of select="$novation/fpml:swNovatedFV/amount"/>
</xsl:if>
</NovatedFV>
<FullFirstCalculationPeriod>
<xsl:value-of select="$novation/fpml:fullFirstCalculationPeriod"/>
</FullFirstCalculationPeriod>
<NonReliance>
<xsl:if test="$novation">
<xsl:value-of select="string(boolean($novation/fpml:nonReliance))"/>
</xsl:if>
</NonReliance>
<PreserveEarlyTerminationProvision>
<xsl:if test="$novation/fpml:swPreserveEarlyTerminationProvision">
<xsl:value-of select="string(boolean($novation/fpml:swPreserveEarlyTerminationProvision = 'true'))"/>
</xsl:if>
</PreserveEarlyTerminationProvision>
<CopyPremiumToNewTrade>
<xsl:if test="$novation and $productType='Swaption'">
<xsl:choose>
<xsl:when test="$novation/fpml:swCopyPremiumToNewTrade = 'true'">true</xsl:when>
<xsl:when test="$novation/fpml:swCopyPremiumToNewTrade = 'false'">false</xsl:when>
<xsl:otherwise/>
</xsl:choose>
</xsl:if>
</CopyPremiumToNewTrade>
<CopyInitialRateToNewTradeIfRelevant>
<xsl:if test="$novation">
<xsl:choose>
<xsl:when test="$novation/fpml:swCopyInitialRateToNewTradeIfRelevant = 'true'">true</xsl:when>
<xsl:when test="$novation/fpml:swCopyInitialRateToNewTradeIfRelevant = 'false'">false</xsl:when>
<xsl:otherwise/>
</xsl:choose>
</xsl:if>
</CopyInitialRateToNewTradeIfRelevant>
<IntendedClearingHouse>
<xsl:if test="$productType='IRS' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='Single Currency Basis Swap' or $productType='FRA' or $productType='OIS' or $productType='ZCInflationSwap' or $productType='Swaption' or $productType='Fixed Fixed Swap'">
<xsl:choose>
<xsl:when test="$novation ">
<xsl:value-of select="$novation/fpml:swBilateralClearingHouse/fpml:partyId"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$swShortFormTrade/fpml:swClearingHouse/fpml:partyId"/>
<xsl:value-of select="$swTradeHeader/fpml:swClearingHouse/fpml:partyId"/>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</IntendedClearingHouse>
<xsl:if test="$novation/fpml:swBulkAction">
<NovationBulkAction>
<xsl:value-of select="$novation/fpml:swBulkAction"/>
</NovationBulkAction>
</xsl:if>
<NovationFallbacksSupplement>
<xsl:if test="$productType='IRS' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='Single Currency Basis Swap' or $productType='Swaption'">
<xsl:choose>
<xsl:when test="$novation/fpml:swFallbacksSupplement">
<xsl:value-of select="$novation/fpml:swFallbacksSupplement"/>
</xsl:when>
<xsl:otherwise>Incorporate</xsl:otherwise>
</xsl:choose>
</xsl:if>
</NovationFallbacksSupplement>
<NovationFallbacksAmendment>
<xsl:if test="$productType='Swaption'">
<xsl:choose>
<xsl:when test="$novation/fpml:swSwapRateFallbacksAmendment">
<xsl:value-of select="$novation/fpml:swSwapRateFallbacksAmendment"/>
</xsl:when>
<xsl:otherwise>Incorporate</xsl:otherwise>
</xsl:choose>
</xsl:if>
</NovationFallbacksAmendment>
<ClientClearingFlag>
<xsl:if test="$novation/fpml:swNewTradeClearingDetails">
<xsl:value-of select="string(boolean($novation/fpml:swNewTradeClearingDetails/fpml:swClientClearing))"/>
</xsl:if>
</ClientClearingFlag>
<ClearingBroker>
<xsl:if test="$novation/fpml:swNewTradeClearingDetails">
<xsl:value-of select="$novation/fpml:swNewTradeClearingDetails/fpml:swClearingBroker"/>
</xsl:if>
</ClearingBroker>
<xsl:if test="$trade/fpml:collateral/fpml:independentAmount">
<AdditionalPayment>
<PaymentDirectionA>
<xsl:variable name="payer" select="string($trade/fpml:collateral/fpml:independentAmount/fpml:payerPartyReference/@href)"/>
<xsl:choose>
<xsl:when test="string($payer)=string($partyA)">Pay</xsl:when>
<xsl:otherwise>Rec</xsl:otherwise>
</xsl:choose>
</PaymentDirectionA>
<Reason>Independent Amount</Reason>
<Currency>
<xsl:value-of select="$trade/fpml:collateral/fpml:independentAmount/fpml:paymentDetail/fpml:paymentAmount/fpml:currency"/>
</Currency>
<Amount>
<xsl:value-of select="$trade/fpml:collateral/fpml:independentAmount/fpml:paymentDetail/fpml:paymentAmount/fpml:amount"/>
</Amount>
<Date>
<xsl:if test="$trade/fpml:collateral/fpml:independentAmount/fpml:paymentDetail/fpml:adjustablePaymentDate/fpml:unadjustedDate">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string($trade/fpml:collateral/fpml:independentAmount/fpml:paymentDetail/fpml:adjustablePaymentDate/fpml:unadjustedDate)"/>
</xsl:call-template>
</xsl:if>
</Date>
<Convention>
<xsl:value-of select="substring($trade/fpml:collateral/fpml:independentAmount/fpml:paymentDetail/fpml:adjustablePaymentDate/fpml:dateAdjustments/fpml:businessDayConvention,1,4)"/>
</Convention>
<Holidays>
<xsl:apply-templates select="$trade/fpml:collateral/fpml:independentAmount/fpml:paymentDetail/fpml:adjustablePaymentDate/fpml:dateAdjustments/fpml:businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</Holidays>
<LegalEntity>
<xsl:if test="$novation">
<xsl:choose>
<xsl:when test="$partyE = $partyA">
<xsl:value-of select="$FpML//fpml:party[@id=$partyF]/fpml:partyId"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$FpML//fpml:party[@id=$partyE]/fpml:partyId"/>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</LegalEntity>
</AdditionalPayment>
</xsl:if>
<xsl:choose>
<xsl:when test="$swLongFormTrade and $productType='FRA'">
<xsl:apply-templates select="$swExtendedTradeDetails/fpml:additionalPayment"/>
</xsl:when>
<xsl:when test="$swLongFormTrade and ($productType='CapFloor' or $productType='IRS' or $productType='OIS' or $productType='ZCInflationSwap' or $productType='Swaption' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='Fixed Fixed Swap')">
<xsl:apply-templates select="$swap/fpml:additionalPayment"/>
<xsl:apply-templates select="$capFloor/fpml:additionalPayment"/>
<xsl:apply-templates select="$swExtendedTradeDetails/fpml:additionalPayment"/>
</xsl:when>
</xsl:choose>
<xsl:if test="$novation/fpml:payment">
<xsl:apply-templates select="$novation/fpml:payment"/>
</xsl:if>
<OptionStyle>
<xsl:if test="$productType='Swaption'">
<xsl:choose>
<xsl:when test="$swaption/fpml:europeanExercise">European</xsl:when>
<xsl:when test="$swShortFormTrade//fpml:swSwaptionParameters/fpml:swEuropeanExercise">European</xsl:when>
<xsl:otherwise>!!!</xsl:otherwise>
</xsl:choose>
</xsl:if>
</OptionStyle>
<OptionType>
<xsl:choose>
<xsl:when test="$productType='CapFloor'">
<xsl:choose>
<xsl:when test="$capFloorStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:capRateSchedule  and $capFloorStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:floorRateSchedule">Cap Floor Straddle</xsl:when>
<xsl:when test="$capFloorStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:capRateSchedule">Cap</xsl:when>
<xsl:when test="$capFloorStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:floorRateSchedule">Floor</xsl:when>
</xsl:choose>
<xsl:value-of select="$swShortFormTrade/fpml:swCapFloorParameters/fpml:swOptionType"/>
</xsl:when>
<xsl:when test="$productType='Swaption'">
<xsl:variable name="fixedPayer">
<xsl:value-of select="$fixedStream/fpml:payerPartyReference/@href"/>
<xsl:value-of select="$swShortFormTrade//fpml:swSwaptionParameters/fpml:swFixedAmounts/fpml:payerPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="floatingPayer">
<xsl:value-of select="$floatingStream/fpml:payerPartyReference/@href"/>
<xsl:value-of select="$swShortFormTrade//fpml:swSwaptionParameters/fpml:swFixedAmounts/fpml:receiverPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="swaptionBuyer">
<xsl:value-of select="$swaption/fpml:buyerPartyReference/@href"/>
<xsl:value-of select="$swShortFormTrade//fpml:swSwaptionParameters/fpml:buyerPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="straddle">
<xsl:value-of select="$swaption/fpml:swaptionStraddle"/>
<xsl:value-of select="$swShortFormTrade//fpml:swSwaptionParameters/fpml:swaptionStraddle"/>
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
<xsl:value-of select="$swaption/fpml:europeanExercise/fpml:expirationDate/fpml:adjustableDate/fpml:unadjustedDate"/>
<xsl:value-of select="$swShortFormTrade//fpml:swSwaptionParameters/fpml:swEuropeanExercise/fpml:swExpirationDate"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
</OptionExpirationDate>
<OptionExpirationDateConvention>
<xsl:if test="$productType='Swaption'">
<xsl:value-of select="substring($swaption/fpml:europeanExercise/fpml:expirationDate/fpml:adjustableDate/fpml:dateAdjustments/fpml:businessDayConvention,1,4)"/>
</xsl:if>
</OptionExpirationDateConvention>
<OptionHolidayCenters>
<xsl:if test="$productType='Swaption'">
<xsl:if test="$productType='Swaption'">
<xsl:apply-templates select="$swaption/fpml:europeanExercise/fpml:expirationDate/fpml:adjustableDate/fpml:dateAdjustments/fpml:businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:if>
</xsl:if>
</OptionHolidayCenters>
<OptionEarliestTime>
<xsl:if test="$productType='Swaption'">
<xsl:if test="$swLongFormTrade">
<xsl:call-template name="formatTime">
<xsl:with-param name="time" select="string($swaption/fpml:europeanExercise/fpml:earliestExerciseTime/fpml:hourMinuteTime)"/>
</xsl:call-template>
</xsl:if>
</xsl:if>
</OptionEarliestTime>
<OptionEarliestTimeHolidayCentre/>
<OptionExpiryTime>
<xsl:if test="$productType='Swaption'">
<xsl:if test="$swLongFormTrade">
<xsl:call-template name="formatTime">
<xsl:with-param name="time" select="string($swaption/fpml:europeanExercise/fpml:expirationTime/fpml:hourMinuteTime)"/>
</xsl:call-template>
</xsl:if>
</xsl:if>
</OptionExpiryTime>
<OptionExpiryTimeHolidayCentre/>
<OptionSpecificExpiryTime/>
<OptionLocation>
<xsl:if test="$productType='Swaption'">
<xsl:value-of select="$swaption/fpml:europeanExercise/fpml:expirationTime/fpml:businessCenter"/>
</xsl:if>
</OptionLocation>
<OptionCalcAgent>
<xsl:if test="$productType='Swaption'">
<xsl:if test="$swLongFormTrade">
<xsl:choose>
<xsl:when test="count($swaption/fpml:calculationAgent/fpml:calculationAgentPartyReference) = 2">Joint</xsl:when>
<xsl:when test="$swaption/fpml:calculationAgent/fpml:calculationAgentPartyReference/@href = $swaption/fpml:buyerPartyReference/@href">Buyer</xsl:when>
<xsl:when test="$swaption/fpml:calculationAgent/fpml:calculationAgentPartyReference/@href = $swaption/fpml:sellerPartyReference/@href">Seller</xsl:when>
<xsl:when test="$swaption/fpml:calculationAgent/fpml:calculationAgentParty[.='AsSpecifiedInMasterAgreement']">As Specified in Master Agreement</xsl:when>
<xsl:otherwise>???</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:if>
</OptionCalcAgent>
<OptionAutomaticExercise>
<xsl:if test="$productType='Swaption'">
<xsl:value-of select="string(boolean($swaption/fpml:exerciseProcedure/fpml:automaticExercise))"/>
</xsl:if>
</OptionAutomaticExercise>
<OptionThreshold>
<xsl:if test="$productType='Swaption'">
<xsl:value-of select="$swaption/fpml:exerciseProcedure/fpml:automaticExercise/fpml:thresholdRate"/>
</xsl:if>
</OptionThreshold>
<ManualExercise>
<xsl:if test="$productType='Swaption'">
<xsl:value-of select="$swaption/fpml:exerciseProcedure/fpml:manualExercise/fpml:fallbackExercise"/>
</xsl:if>
</ManualExercise>
<OptionWrittenExerciseConf>
<xsl:if test="$productType='Swaption'">
<xsl:value-of select="$swaption/fpml:exerciseProcedure/fpml:followUpConfirmation"/>
</xsl:if>
</OptionWrittenExerciseConf>
<PremiumAmount>
<xsl:choose>
<xsl:when test="$productType='CapFloor'">
<xsl:choose>
<xsl:when test="$capFloor/fpml:premium">
<xsl:value-of select="$capFloor/fpml:premium/fpml:paymentAmount/fpml:amount"/>
</xsl:when>
<xsl:when test="$swShortFormTrade/fpml:swCapFloorParameters/fpml:swPremium">
<xsl:value-of select="$swShortFormTrade/fpml:swCapFloorParameters/fpml:swPremium/fpml:paymentAmount/fpml:amount"/>
</xsl:when>
<xsl:otherwise>0</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType='Swaption'">
<xsl:choose>
<xsl:when test="$swaption/fpml:premium">
<xsl:value-of select="$swaption/fpml:premium/fpml:paymentAmount/fpml:amount"/>
</xsl:when>
<xsl:when test="$swShortFormTrade/fpml:swSwaptionParameters/fpml:swPremium">
<xsl:value-of select="$swShortFormTrade/fpml:swSwaptionParameters/fpml:swPremium/fpml:paymentAmount/fpml:amount"/>
</xsl:when>
<xsl:otherwise>0</xsl:otherwise>
</xsl:choose>
</xsl:when>
</xsl:choose>
</PremiumAmount>
<PremiumCurrency>
<xsl:if test="$productType='Swaption'">
<xsl:choose>
<xsl:when test="$swShortFormTrade//fpml:swSwaptionParameters/fpml:swPremium">
<xsl:value-of select="$swShortFormTrade//fpml:swSwaptionParameters/fpml:swPremium/fpml:paymentAmount/fpml:currency"/>
</xsl:when>
<xsl:when test="$swaption/fpml:premium">
<xsl:value-of select="$swaption/fpml:premium/fpml:paymentAmount/fpml:currency"/>
</xsl:when>
</xsl:choose>
</xsl:if>
</PremiumCurrency>
<PremiumPaymentDate>
<xsl:choose>
<xsl:when test="$productType='Swaption'">
<xsl:if test="$swaption/fpml:premium/fpml:paymentDate/fpml:unadjustedDate">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string($swaption/fpml:premium/fpml:paymentDate/fpml:unadjustedDate)"/>
</xsl:call-template>
</xsl:if>
<xsl:if test="$swShortFormTrade/fpml:swSwaptionParameters/fpml:swPremium/fpml:swPaymentDate">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string($swShortFormTrade/fpml:swSwaptionParameters/fpml:swPremium/fpml:swPaymentDate)"/>
</xsl:call-template>
</xsl:if>
</xsl:when>
<xsl:when test="$productType='CapFloor'">
<xsl:if test="$capFloor/fpml:premium/fpml:paymentDate/fpml:unadjustedDate">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string($capFloor/fpml:premium/fpml:paymentDate/fpml:unadjustedDate)"/>
</xsl:call-template>
</xsl:if>
<xsl:if test="$swShortFormTrade//fpml:swPremium/fpml:swPaymentDate">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string($swShortFormTrade//fpml:swPremium/fpml:swPaymentDate)"/>
</xsl:call-template>
</xsl:if>
</xsl:when>
</xsl:choose>
</PremiumPaymentDate>
<PremiumHolidayCentres>
<xsl:if test="$productType='Swaption'">
<xsl:apply-templates select="$swaption/fpml:premium/fpml:paymentDate/fpml:dateAdjustments/fpml:businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:if>
</PremiumHolidayCentres>
<Strike>
<xsl:choose>
<xsl:when test="$productType='Swaption'">
<xsl:value-of select="$fixedStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:fixedRateSchedule/fpml:initialValue"/>
<xsl:value-of select="$swShortFormTrade/fpml:swSwaptionParameters/fpml:fixedRate"/>
</xsl:when>
<xsl:when test="$productType='CapFloor'">
<xsl:choose>
<xsl:when test="$capFloorStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:capRateSchedule">
<xsl:value-of select="$capFloorStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:capRateSchedule/fpml:initialValue"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$capFloorStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:floorRateSchedule/fpml:initialValue"/>
</xsl:otherwise>
</xsl:choose>
<xsl:value-of select="$swShortFormTrade/fpml:swCapFloorParameters/fpml:swStrikeRate"/>
</xsl:when>
</xsl:choose>
</Strike>
<StrikeCurrency/>
<StrikePercentage/>
<StrikeDate/>
<OptionSettlement>
<xsl:if test="$productType='Swaption'">
<xsl:if test="$swaption/fpml:cashSettlement or $swShortFormTrade//fpml:swSwaptionParameters/fpml:swCashSettlement[.='true']">Cash</xsl:if>
<xsl:if test="$swaption/fpml:physicalSettlement or not($swaption/fpml:cashSettlement or $swShortFormTrade//fpml:swSwaptionParameters/fpml:swCashSettlement[.='true'])">Physical</xsl:if>
</xsl:if>
</OptionSettlement>
<OptionCashSettlementValuationTime>
<xsl:if test="$productType='Swaption'">
<xsl:if test="$swaption/fpml:cashSettlement/fpml:cashSettlementValuationTime/fpml:hourMinuteTime">
<xsl:call-template name="formatTime">
<xsl:with-param name="time" select="string($swaption/fpml:cashSettlement/fpml:cashSettlementValuationTime/fpml:hourMinuteTime)"/>
</xsl:call-template>
</xsl:if>
</xsl:if>
</OptionCashSettlementValuationTime>
<OptionSpecificValuationTime/>
<OptionCashSettlementValuationDate>
<xsl:if test="$productType='Swaption'">
<xsl:value-of select="$swaption/fpml:cashSettlement/fpml:cashSettlementValuationDate/fpml:periodMultiplier"/>
</xsl:if>
</OptionCashSettlementValuationDate>
<OptionCashSettlementPaymentDate>
<xsl:if test="$productType='Swaption'">
<xsl:value-of select="$swaption/fpml:cashSettlement/fpml:cashSettlementPaymentDate/fpml:relativeDate/fpml:periodMultiplier"/>
</xsl:if>
</OptionCashSettlementPaymentDate>
<OptionCashSettlementMethod>
<xsl:if test="$productType='Swaption'">
<xsl:if test="$swaption/fpml:cashSettlement/fpml:cashPriceMethod">Cash Price</xsl:if>
<xsl:if test="$swaption/fpml:cashSettlement/fpml:cashPriceAlternateMethod">Cash Price - Alternate Method</xsl:if>
<xsl:if test="$swaption/fpml:cashSettlement/fpml:parYieldCurveAdjustedMethod">Par Yield Curve - Adjusted</xsl:if>
<xsl:if test="$swaption/fpml:cashSettlement/fpml:parYieldCurveUnadjustedMethod">Par Yield Curve - Unadjusted</xsl:if>
<xsl:if test="$swaption/fpml:cashSettlement/fpml:zeroCouponYieldAdjustedMethod">Zero Coupon Yield - Adjusted</xsl:if>
<xsl:if test="$swExtendedTradeDetails/fpml:swCollateralizedCashPrice">Collateralized Cash Price</xsl:if>
<xsl:if test="$swaption/fpml:cashSettlement/fpml:collateralizedCashPriceMethod">Collateralized Cash Price</xsl:if>
<xsl:if test="$swaption/fpml:cashSettlement/fpml:midMarketValuation/fpml:indicativeQuotations">Mid-market Valuation (Indicative Quotations)</xsl:if>
<xsl:if test="$swaption/fpml:cashSettlement/fpml:midMarketValuation/fpml:indicativeQuotationsAlternate">Mid-market Valuation (Indicative Quotations) - Alternate Method</xsl:if>
<xsl:if test="$swaption/fpml:cashSettlement/fpml:midMarketValuation/fpml:calculationAgentDetermination">Mid-market Valuation (Calculation Agent Determination)</xsl:if>
</xsl:if>
</OptionCashSettlementMethod>
<OptionCashSettlementQuotationRate>
<xsl:if test="$productType='Swaption'">
<xsl:if test="$swExtendedTradeDetails/fpml:swCollateralizedCashPrice/fpml:quotationRateType">
<xsl:value-of select="$swExtendedTradeDetails/fpml:swCollateralizedCashPrice/fpml:quotationRateType"/>
</xsl:if>
<xsl:if test="$swaption/fpml:cashSettlement//fpml:quotationRateType">
<xsl:value-of select="$swaption/fpml:cashSettlement//fpml:quotationRateType"/>
</xsl:if>
<xsl:if test="$swaption/fpml:physicalSettlement/fpml:quotationRateType">
<xsl:value-of select="$swaption/fpml:physicalSettlement/fpml:quotationRateType"/>
</xsl:if>
</xsl:if>
</OptionCashSettlementQuotationRate>
<OptionCashSettlementRateSource>
<xsl:if test="$productType='Swaption'">
<xsl:variable name="firstCase" select="boolean($swExtendedTradeDetails/fpml:swCollateralizedCashPrice/fpml:settlementRateSource/fpml:informationSource/fpml:rateSourcePage or $swExtendedTradeDetails/fpml:swCollateralizedCashPrice/fpml:settlementRateSource/fpml:informationSource/fpml:rateSource)"/>
<xsl:variable name="secondCase" select="boolean($swaption/fpml:cashSettlement//fpml:settlementRateSource/fpml:informationSource/fpml:rateSourcePage or $swaption/fpml:cashSettlement//fpml:settlementRateSource/fpml:informationSource/fpml:rateSource)"/>
<xsl:variable name="thirdCase" select="boolean($swaption/fpml:physicalSettlement//fpml:settlementRateSource/fpml:informationSource/fpml:rateSourcePage or $swaption/fpml:physicalSettlement//fpml:settlementRateSource/fpml:informationSource/fpml:rateSource)"/>
<xsl:if test="$firstCase">
<xsl:choose>
<xsl:when test="$swExtendedTradeDetails/fpml:swCollateralizedCashPrice/fpml:settlementRateSource/fpml:informationSource/fpml:rateSourcePage">
<xsl:variable name="pageString" select="' Page '"/>
<xsl:value-of select="$swExtendedTradeDetails/fpml:swCollateralizedCashPrice/fpml:settlementRateSource/fpml:informationSource/fpml:rateSource"/>
<xsl:value-of select="$pageString"/>
<xsl:value-of select="$swExtendedTradeDetails/fpml:swCollateralizedCashPrice/fpml:settlementRateSource/fpml:informationSource/fpml:rateSourcePage"/>
</xsl:when>
<xsl:when test="$swExtendedTradeDetails/fpml:swCollateralizedCashPrice/fpml:settlementRateSource/fpml:informationSource/fpml:rateSource[.='ISDA']">ISDA Source</xsl:when>
<xsl:when test="$swExtendedTradeDetails/fpml:swCollateralizedCashPrice/fpml:settlementRateSource/fpml:informationSource/fpml:rateSource[.='ICESWAP']">ICESWAP Rate</xsl:when>
<xsl:when test="$swExtendedTradeDetails/fpml:swCollateralizedCashPrice/fpml:settlementRateSource/fpml:informationSource/fpml:rateSource[.='TOKYOSWAP']">Tokyo Swap Rate</xsl:when>
<xsl:when test="$swExtendedTradeDetails/fpml:swCollateralizedCashPrice/fpml:settlementRateSource/fpml:informationSource/fpml:rateSource[.='Reference Banks']">Reference Banks</xsl:when>
</xsl:choose>
</xsl:if>
<xsl:if test="$secondCase">
<xsl:choose>
<xsl:when test="$swaption/fpml:cashSettlement//fpml:settlementRateSource/fpml:informationSource/fpml:rateSourcePage">
<xsl:variable name="pageString" select="' Page '"/>
<xsl:value-of select="$swaption/fpml:cashSettlement//fpml:settlementRateSource/fpml:informationSource/fpml:rateSource"/>
<xsl:value-of select="$pageString"/>
<xsl:value-of select="$swaption/fpml:cashSettlement//fpml:settlementRateSource/fpml:informationSource/fpml:rateSourcePage"/>
</xsl:when>
<xsl:when test="$swaption/fpml:cashSettlement//fpml:settlementRateSource/fpml:informationSource/fpml:rateSource[.='ISDA']">ISDA Source</xsl:when>
<xsl:when test="$swaption/fpml:cashSettlement//fpml:settlementRateSource/fpml:informationSource/fpml:rateSource[.='ICESWAP']">ICESWAP Rate</xsl:when>
<xsl:when test="$swaption/fpml:cashSettlement//fpml:settlementRateSource/fpml:informationSource/fpml:rateSource[.='TOKYOSWAP']">Tokyo Swap Rate</xsl:when>
<xsl:when test="$swaption/fpml:cashSettlement//fpml:settlementRateSource/fpml:informationSource/fpml:rateSource[.='Reference Banks']">Reference Banks</xsl:when>
</xsl:choose>
</xsl:if>
<xsl:if test="$thirdCase">
<xsl:choose>
<xsl:when test="$swaption/fpml:physicalSettlement//fpml:settlementRateSource/fpml:informationSource/fpml:rateSourcePage">
<xsl:variable name="pageString" select="' Page '"/>
<xsl:value-of select="$swaption/fpml:physicalSettlement//fpml:settlementRateSource/fpml:informationSource/fpml:rateSource"/>
<xsl:value-of select="$pageString"/>
<xsl:value-of select="$swaption/fpml:physicalSettlement//fpml:settlementRateSource/fpml:informationSource/fpml:rateSourcePage"/>
</xsl:when>
<xsl:when test="$swaption/fpml:physicalSettlement//fpml:settlementRateSource/fpml:informationSource/fpml:rateSource[.='ISDA']">ISDA Source</xsl:when>
<xsl:when test="$swaption/fpml:physicalSettlement//fpml:settlementRateSource/fpml:informationSource/fpml:rateSource[.='ICESWAP']">ICESWAP Rate</xsl:when>
<xsl:when test="$swaption/fpml:physicalSettlement//fpml:settlementRateSource/fpml:informationSource/fpml:rateSource[.='TOKYOSWAP']">Tokyo Swap Rate</xsl:when>
<xsl:when test="$swaption/fpml:physicalSettlement//fpml:settlementRateSource/fpml:informationSource/fpml:rateSource[.='Reference Banks']">Reference Banks</xsl:when>
</xsl:choose>
</xsl:if>
<xsl:if test="not($firstCase) and not($secondCase) and not($thirdCase)">
<xsl:if test="$swaption/fpml:cashSettlement/fpml:cashPriceMethod or $swaption/fpml:cashSettlement/fpml:cashPriceAlternateMethod or $swaption/fpml:cashSettlement//fpml:cashSettlementReferenceBanks or $swExtendedTradeDetails/fpml:swCollateralizedCashPrice/fpml:settlementRateSource/fpml:cashSettlementReferenceBanks or $swaption/fpml:physicalSettlement//fpml:cashSettlementReferenceBanks">Reference Banks</xsl:if>
</xsl:if>
</xsl:if>
</OptionCashSettlementRateSource>
<OptionCashSettlementReferenceBanks>
<xsl:if test="$productType='Swaption'">
<xsl:if test="$swaption/fpml:cashSettlement">
<xsl:if test="$swaption/fpml:cashSettlement//fpml:cashSettlementReferenceBanks">
<xsl:apply-templates select="$swaption/fpml:cashSettlement//fpml:cashSettlementReferenceBanks"/>
</xsl:if>
<xsl:if test="$swExtendedTradeDetails/fpml:swCollateralizedCashPrice/fpml:settlementRateSource/fpml:cashSettlementReferenceBanks">
<xsl:apply-templates select="$swExtendedTradeDetails/fpml:swCollateralizedCashPrice/fpml:settlementRateSource/fpml:cashSettlementReferenceBanks"/>
</xsl:if>
<xsl:if test="not($swExtendedTradeDetails/fpml:swCollateralizedCashPrice/fpml:settlementRateSource/fpml:cashSettlementReferenceBanks or $swaption/fpml:cashSettlement//fpml:cashSettlementReferenceBanks)">Agreed on exercise</xsl:if>
</xsl:if>
<xsl:if test="$swaption/fpml:physicalSettlement">
<xsl:choose>
<xsl:when test="$swaption/fpml:physicalSettlement//fpml:cashSettlementReferenceBanks">
<xsl:apply-templates select="$swaption/fpml:physicalSettlement//fpml:cashSettlementReferenceBanks"/>
</xsl:when>
<xsl:otherwise>Agreed on exercise</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:if>
</OptionCashSettlementReferenceBanks>
<OptionMMVApplicableCSA>
<xsl:if test="$productType='Swaption' and $swaption/fpml:cashSettlement/fpml:midMarketValuation//fpml:applicableCsa">
<xsl:choose>
<xsl:when test="$swaption/fpml:cashSettlement/fpml:midMarketValuation//fpml:applicableCsa[.='NoCSA']">No CSA</xsl:when>
<xsl:when test="$swaption/fpml:cashSettlement/fpml:midMarketValuation//fpml:applicableCsa[.='ExistingCSA']">Existing CSA</xsl:when>
<xsl:when test="$swaption/fpml:cashSettlement/fpml:midMarketValuation//fpml:applicableCsa[.='ReferenceVMCSA']">Reference VM CSA</xsl:when>
</xsl:choose>
</xsl:if>
</OptionMMVApplicableCSA>
<ClearedPhysicalSettlement>
<xsl:if test="$productType='Swaption'">
<xsl:if test="$swTradeHeader/fpml:swClearedPhysicalSettlement">
<xsl:value-of select="string(boolean($swTradeHeader/fpml:swClearedPhysicalSettlement = 'true'))"/>
</xsl:if>
<xsl:if test="$swaption/fpml:physicalSettlement/fpml:clearedPhysicalSettlement">
<xsl:value-of select="string(boolean($swaption/fpml:physicalSettlement/fpml:clearedPhysicalSettlement = 'true'))"/>
</xsl:if>
</xsl:if>
</ClearedPhysicalSettlement>
<UnderlyingSwapClearingHouse>
<xsl:if test="$productType='Swaption'">
<xsl:if test="$swTradeHeader/fpml:swPredeterminedClearerForUnderlyingSwap">
<xsl:value-of select="$swTradeHeader/fpml:swPredeterminedClearerForUnderlyingSwap"/>
</xsl:if>
<xsl:if test="$swaption/fpml:cashSettlement/fpml:collateralizedCashPriceMethod/fpml:mutuallyAgreedClearinghouse/fpml:identifier">
<xsl:value-of select="$swaption/fpml:cashSettlement/fpml:collateralizedCashPriceMethod/fpml:mutuallyAgreedClearinghouse/fpml:identifier"/>
</xsl:if>
<xsl:if test="$swaption/fpml:physicalSettlement/fpml:mutuallyAgreedClearinghouse">
<xsl:value-of select="$swaption/fpml:physicalSettlement/fpml:mutuallyAgreedClearinghouse"/>
</xsl:if>
</xsl:if>
</UnderlyingSwapClearingHouse>
<UnderlyingSwapClientClearing>
<xsl:if test="$productType='Swaption'">
<xsl:value-of select="$swTradeHeader/fpml:swUnderlyingSwapDetails/fpml:swClientClearing"/>
</xsl:if>
</UnderlyingSwapClientClearing>
<UnderlyingSwapAutoSendForClearing>
<xsl:if test="$productType='Swaption'">
<xsl:value-of select="$swTradeHeader/fpml:swUnderlyingSwapDetails/fpml:swAutoSendForClearing"/>
</xsl:if>
</UnderlyingSwapAutoSendForClearing>
<AutoCreateExercised>
<xsl:if test="$productType='Swaption'">
<xsl:value-of select="$swTradeHeader/fpml:swAutoCreateAffirmReleaseSwap"/>
</xsl:if>
</AutoCreateExercised>
<ConvertUnderlyingSwapToRFR>
<xsl:if test="$productType='Swaption'">
<xsl:value-of select="$swTradeHeader/fpml:swConvertUnderlyingSwapToRFR"/>
</xsl:if>
</ConvertUnderlyingSwapToRFR>
<PricedToClearCCP>
<xsl:if test="$productType='Swaption' or $productType='OIS' or $productType='FRA' or $productType='ZCInflationSwap' or $productType='Fixed Fixed Swap' or $productType='IRS' or $productType='Single Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='Cross Currency Basis Swap'">
<xsl:value-of select="$swTradeHeader/fpml:swPricedToClearCCP/fpml:partyId"/>
</xsl:if>
</PricedToClearCCP>
<AgreedDiscountRate>
<xsl:if test="$productType='Swaption'">
<xsl:if test="$swExtendedTradeDetails/fpml:swAgreedDiscountRate">
<xsl:value-of select="$swExtendedTradeDetails/fpml:swAgreedDiscountRate"/>
</xsl:if>
<xsl:if test="$swaption/fpml:cashSettlement/fpml:collateralizedCashPriceMethod/fpml:agreedDiscountRate">
<xsl:value-of select="$swaption/fpml:cashSettlement/fpml:collateralizedCashPriceMethod/fpml:agreedDiscountRate"/>
</xsl:if>
<xsl:if test="$swaption/fpml:physicalSettlement/fpml:agreedDiscountRate">
<xsl:value-of select="$swaption/fpml:physicalSettlement/fpml:agreedDiscountRate"/>
</xsl:if>
</xsl:if>
</AgreedDiscountRate>
<EconomicAmendmentType>
<xsl:if test="$productType='OIS' or $productType='IRS' or $productType='Single Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='Cross Currency Basis Swap'">
<xsl:if test="$swExtendedTradeDetails/fpml:swEconomicAmendmentType">
<xsl:value-of select="$swExtendedTradeDetails/fpml:swEconomicAmendmentType"/>
</xsl:if>
</xsl:if>
</EconomicAmendmentType>
<EconomicAmendmentReason>
<xsl:if test="$productType='OIS' or $productType='IRS' or $productType='Single Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='Cross Currency Basis Swap'">
<xsl:if test="$swExtendedTradeDetails/fpml:swEconomicAmendmentReason">
<xsl:value-of select="$swExtendedTradeDetails/fpml:swEconomicAmendmentReason"/>
</xsl:if>
</xsl:if>
</EconomicAmendmentReason>
<CancelableCalcAgent>
<xsl:if test="$productType='OIS' or $productType='IRS'">
<xsl:if test="$swLongFormTrade and $swExtendedTradeDetails/fpml:calculationAgent">
<xsl:choose>
<xsl:when test="count($swExtendedTradeDetails/fpml:calculationAgent/fpml:calculationAgentPartyReference) = 2">Joint</xsl:when>
<xsl:when test="$swExtendedTradeDetails/fpml:calculationAgent/fpml:calculationAgentPartyReference/@href = $swapStream[@id='floatingLeg']/fpml:receiverPartyReference/@href">Buyer</xsl:when>
<xsl:when test="$swExtendedTradeDetails/fpml:calculationAgent/fpml:calculationAgentPartyReference/@href = $swapStream[@id='floatingLeg']/fpml:payerPartyReference/@href">Seller</xsl:when>
<xsl:when test="$swExtendedTradeDetails/fpml:calculationAgent/fpml:calculationAgentParty[.='AsSpecifiedInMasterAgreement']">As Specified in Master Agreement</xsl:when>
<xsl:otherwise>???</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:if>
</CancelableCalcAgent>
<SwapRateFallbacksAmendment>
<xsl:if test="$productType='Swaption'">
<xsl:choose>
<xsl:when test="$swExtendedTradeDetails/fpml:swSwapRateFallbacksAmendment">
<xsl:value-of select="$swExtendedTradeDetails/fpml:swSwapRateFallbacksAmendment"/>
</xsl:when>
</xsl:choose>
</xsl:if>
</SwapRateFallbacksAmendment>
<ClearingTakeupClientId>
<xsl:value-of select="$swClearingTakeup/fpml:swClient/fpml:partyId"/>
</ClearingTakeupClientId>
<ClearingTakeupClientName>
<xsl:value-of select="$swClearingTakeup/fpml:swClient/fpml:partyName"/>
</ClearingTakeupClientName>
<ClearingTakeupClientTradeId>
<xsl:value-of select="$swClearingTakeup/fpml:swClient/fpml:tradeId"/>
</ClearingTakeupClientTradeId>
<ClearingTakeupExecSrcId>
<xsl:value-of select="$swClearingTakeup/fpml:swExecutionSource/fpml:partyId"/>
</ClearingTakeupExecSrcId>
<ClearingTakeupExecSrcName>
<xsl:value-of select="$swClearingTakeup/fpml:swExecutionSource/fpml:partyName"/>
</ClearingTakeupExecSrcName>
<ClearingTakeupExecSrcTradeId>
<xsl:value-of select="$swClearingTakeup/fpml:swExecutionSource/fpml:tradeId"/>
</ClearingTakeupExecSrcTradeId>
<ClearingTakeupCorrelationId>
<xsl:value-of select="$swClearingTakeup/fpml:swCorrelationId"/>
</ClearingTakeupCorrelationId>
<ClearingTakeupClearingHouseTradeId>
<xsl:value-of select="$swClearingTakeup/fpml:swClearingHouseTradeId"/>
</ClearingTakeupClearingHouseTradeId>
<ClearingTakeupOriginatingEvent>
<xsl:value-of select="$swClearingTakeup/fpml:swOriginatingEvent"/>
</ClearingTakeupOriginatingEvent>
<ClearingTakeupBlockTradeId>
<xsl:value-of select="$swClearingTakeup/fpml:swBlockTradeId"/>
</ClearingTakeupBlockTradeId>
<ClearingTakeupSentBy>
<xsl:value-of select="$swClearingTakeup/fpml:swSentBy"/>
</ClearingTakeupSentBy>
<ClearingTakeupCreditTokenIssuer>
<xsl:value-of select="$swClearingTakeup/fpml:swCreditAcceptanceToken/fpml:swCreditIssuer"/>
</ClearingTakeupCreditTokenIssuer>
<ClearingTakeupCreditToken>
<xsl:value-of select="$swClearingTakeup/fpml:swCreditAcceptanceToken/fpml:swToken"/>
</ClearingTakeupCreditToken>
<ClearingTakeupClearingStatus>
<xsl:value-of select="$swClearingTakeup/fpml:swClearingStatus"/>
</ClearingTakeupClearingStatus>
<ClearingTakeupVenueLEI>
<xsl:value-of select="$swClearingTakeup/fpml:swVenueId"/>
</ClearingTakeupVenueLEI>
<ClearingTakeupVenueLEIScheme>
<xsl:value-of select="$swClearingTakeup/fpml:swVenueId/@swVenueIdScheme"/>
</ClearingTakeupVenueLEIScheme>
<xsl:for-each select="$swAssociatedTrades/fpml:swAssociatedTrade">
<xsl:call-template name="tx:SWDMLTrade.AssociatedTrade">
<xsl:with-param name="AssociatedTradeId" select="normalize-space(.)"/>
<xsl:with-param name="RelationshipType" select="@name"/>
</xsl:call-template>
</xsl:for-each>
<DocsType>
<xsl:value-of select="$trade//fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType"/>
</DocsType>
<DocsSubType/>
<ContractualDefinitions>
<xsl:if test="$productType='IRS' or $productType='OIS' or $productType='CapFloor' or $productType='ZCInflationSwap' or $productType='Swaption' or $productType='FRA' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='Fixed Fixed Swap'">
<xsl:value-of select="$swShortFormTrade//fpml:contractualDefinitions"/>
<xsl:apply-templates select="$trade/fpml:documentation"/>
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
<xsl:value-of select="$trade//fpml:creditDefaultSwap/fpml:generalTerms/fpml:indexReferenceInformation/fpml:indexName"/>
</IndexName>
<IndexId>
<xsl:value-of select="$trade//fpml:creditDefaultSwap/fpml:generalTerms/fpml:indexReferenceInformation/fpml:indexId"/>
</IndexId>
<IndexAnnexDate>
<xsl:value-of select="$trade//fpml:creditDefaultSwap/fpml:generalTerms/fpml:indexReferenceInformation/fpml:indexAnnexDate"/>
</IndexAnnexDate>
<IndexTradedRate/>
<UpfrontFee>
<xsl:value-of select="string(boolean($trade//fpml:creditDefaultSwap/fpml:feeLeg/fpml:initialPayment))"/>
</UpfrontFee>
<UpfrontFeeAmount>
<xsl:value-of select="$trade//fpml:creditDefaultSwap/fpml:feeLeg/fpml:initialPayment/fpml:paymentAmount/fpml:amount"/>
</UpfrontFeeAmount>
<UpfrontFeeDate/>
<UpfrontFeePayer>
<xsl:value-of select="substring-after($trade//fpml:creditDefaultSwap/fpml:feeLeg/fpml:initialPayment/fpml:payerPartyReference/@href,'party')"/>
</UpfrontFeePayer>
<AttachmentPoint/>
<ExhaustionPoint/>
<PublicationDate/>
<MasterAgreementDate/>
<MasterAgreementVersion/>
<AmendmentTradeDate/>
<xsl:apply-templates select="$trade//fpml:otherPartyPayment"/>
<SettlementCurrency>
<xsl:choose>
<xsl:when test="$productType='IRS' or $productType='OIS' or $productType='Swaption' or $productType='Cross Currency IRS' or $productType='Fixed Fixed Swap'">
<xsl:choose>
<xsl:when test="$swShortFormTrade//fpml:swSettlementProvision/fpml:swSettlementCurrency">
<xsl:value-of select="$swShortFormTrade//fpml:swSettlementProvision/fpml:swSettlementCurrency"/>
</xsl:when>
<xsl:when test="$swExtendedTradeDetails/fpml:swSettlementProvision/fpml:swSettlementCurrency and $referenceCurrency='BRL'">
<xsl:value-of select="$swExtendedTradeDetails/fpml:swSettlementProvision/fpml:swSettlementCurrency"/>
</xsl:when>
<xsl:when test="$fixedStream/fpml:settlementProvision/fpml:settlementCurrency">
<xsl:value-of select="$fixedStream/fpml:settlementProvision/fpml:settlementCurrency"/>
</xsl:when>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType='Cross Currency Basis Swap'">
<xsl:choose>
<xsl:when test="$swShortFormTrade//fpml:swSettlementProvision/fpml:swSettlementCurrency">
<xsl:value-of select="$swShortFormTrade//fpml:swSettlementProvision/fpml:swSettlementCurrency"/>
</xsl:when>
<xsl:when test="$floatingStream/fpml:settlementProvision/fpml:settlementCurrency">
<xsl:value-of select="$floatingStream/fpml:settlementProvision/fpml:settlementCurrency"/>
</xsl:when>
</xsl:choose>
</xsl:when>
</xsl:choose>
</SettlementCurrency>
<ReferenceCurrency>
<xsl:choose>
<xsl:when test="$productType='IRS' or $productType='OIS' or $productType='Swaption' or $productType='Cross Currency IRS' or $productType='Fixed Fixed Swap'">
<xsl:choose>
<xsl:when test="$swShortFormTrade//fpml:swSettlementProvision/fpml:swNonDeliverableSettlement/fpml:swReferenceCurrency">
<xsl:value-of select="$swShortFormTrade//fpml:swSettlementProvision/fpml:swNonDeliverableSettlement/fpml:swReferenceCurrency"/>
</xsl:when>
<xsl:when test="$referenceCurrency='BRL'">
<xsl:value-of select="$referenceCurrency"/>
</xsl:when>
<xsl:when test="$fixedStream/fpml:settlementProvision/fpml:nonDeliverableSettlement/fpml:referenceCurrency">
<xsl:value-of select="$fixedStream/fpml:settlementProvision/fpml:nonDeliverableSettlement/fpml:referenceCurrency"/>
</xsl:when>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType='Cross Currency Basis Swap'">
<xsl:choose>
<xsl:when test="$swShortFormTrade//fpml:swSettlementProvision/fpml:swNonDeliverableSettlement/fpml:swReferenceCurrency">
<xsl:value-of select="$swShortFormTrade//fpml:swSettlementProvision/fpml:swNonDeliverableSettlement/fpml:swReferenceCurrency"/>
</xsl:when>
<xsl:when test="$floatingStream/fpml:settlementProvision/fpml:nonDeliverableSettlement/fpml:referenceCurrency">
<xsl:value-of select="$floatingStream/fpml:settlementProvision/fpml:nonDeliverableSettlement/fpml:referenceCurrency"/>
</xsl:when>
</xsl:choose>
</xsl:when>
</xsl:choose>
</ReferenceCurrency>
<SettlementRateOption>
<xsl:choose>
<xsl:when test="$productType='IRS' or $productType='OIS' or $productType='Swaption' or $productType='Cross Currency IRS' or $productType='Fixed Fixed Swap'">
<xsl:choose>
<xsl:when test="$swShortFormTrade//fpml:swSettlementProvision/fpml:swNonDeliverableSettlement/fpml:swSettlementRateOption">
<xsl:value-of select="$swShortFormTrade//fpml:swSettlementProvision/fpml:swNonDeliverableSettlement/fpml:swSettlementRateOption"/>
</xsl:when>
<xsl:when test="$swExtendedTradeDetails/fpml:swSettlementProvision/fpml:swNonDeliverableSettlement/fpml:swSettlementRateOption and $referenceCurrency='BRL'">
<xsl:value-of select="$swExtendedTradeDetails/fpml:swSettlementProvision/fpml:swNonDeliverableSettlement/fpml:swSettlementRateOption"/>
</xsl:when>
<xsl:when test="$fixedStream/fpml:settlementProvision/fpml:nonDeliverableSettlement/fpml:settlementRateOption">
<xsl:value-of select="$fixedStream/fpml:settlementProvision/fpml:nonDeliverableSettlement/fpml:settlementRateOption"/>
</xsl:when>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType='Cross Currency Basis Swap'">
<xsl:choose>
<xsl:when test="$swShortFormTrade//fpml:swSettlementProvision/fpml:swNonDeliverableSettlement/fpml:swSettlementRateOption">
<xsl:value-of select="$swShortFormTrade//fpml:swSettlementProvision/fpml:swNonDeliverableSettlement/fpml:swSettlementRateOption"/>
</xsl:when>
<xsl:when test="$floatingStream/fpml:settlementProvision/fpml:nonDeliverableSettlement/fpml:settlementRateOption">
<xsl:value-of select="$floatingStream/fpml:settlementProvision/fpml:nonDeliverableSettlement/fpml:settlementRateOption"/>
</xsl:when>
</xsl:choose>
</xsl:when>
</xsl:choose>
</SettlementRateOption>
<NonDeliverable>
<xsl:if test="$productType='IRS' or $productType='OIS' or $productType='Cross Currency IRS' or $productType='Fixed Fixed Swap' or $productType='Cross Currency Basis Swap'">
<xsl:value-of select="$swShortFormTrade//fpml:nonDeliverable"/>
</xsl:if>
</NonDeliverable>
<NonDeliverable2>
<xsl:if test="$productType='Fixed Fixed Swap'">
<xsl:value-of select="$swShortFormTrade//fpml:nonDeliverable2"/>
</xsl:if>
</NonDeliverable2>
<FxFixingDate>
<FxFixingAdjustableDate/>
<FxFixingPeriod>
<xsl:choose>
<xsl:when test="$productType='IRS' or $productType='OIS' or $productType='Swaption' or $productType='Cross Currency IRS' or $productType='Fixed Fixed Swap'">
<xsl:value-of select="$fixedStream/fpml:settlementProvision/fpml:nonDeliverableSettlement/fpml:fxFixingDate/fpml:periodMultiplier"/>
</xsl:when>
<xsl:when test="$productType='Cross Currency Basis Swap'">
<xsl:value-of select="$floatingStream/fpml:settlementProvision/fpml:nonDeliverableSettlement/fpml:fxFixingDate/fpml:periodMultiplier"/>
</xsl:when>
</xsl:choose>
</FxFixingPeriod>
<FxFixingDayConvention>
<xsl:choose>
<xsl:when test="$productType='IRS' or $productType='OIS' or $productType='Swaption' or $productType='Cross Currency IRS' or $productType='Fixed Fixed Swap'">
<xsl:value-of select="substring($fixedStream/fpml:settlementProvision/fpml:nonDeliverableSettlement/fpml:fxFixingDate/fpml:businessDayConvention,1,4)"/>
</xsl:when>
<xsl:when test="$productType='Cross Currency Basis Swap'">
<xsl:value-of select="substring($floatingStream/fpml:settlementProvision/fpml:nonDeliverableSettlement/fpml:fxFixingDate/fpml:businessDayConvention,1,4)"/>
</xsl:when>
</xsl:choose>
</FxFixingDayConvention>
<FxFixingCentres>
<xsl:choose>
<xsl:when test="$productType='IRS' or $productType='OIS' or $productType='Swaption' or $productType='Cross Currency IRS' or $productType='Fixed Fixed Swap'">
<xsl:apply-templates select="$fixedStream/fpml:settlementProvision/fpml:nonDeliverableSettlement/fpml:fxFixingDate/fpml:businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:when>
<xsl:when test="$productType='Cross Currency Basis Swap'">
<xsl:apply-templates select="$floatingStream/fpml:settlementProvision/fpml:nonDeliverableSettlement/fpml:fxFixingDate/fpml:businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:when>
</xsl:choose>
</FxFixingCentres>
</FxFixingDate>
<ValuationDateType>
<xsl:choose>
<xsl:when test="$productType='Cross Currency IRS'">
<xsl:apply-templates select="$fixedStream/fpml:settlementProvision/fpml:nonDeliverableSettlement/fpml:fxFixingDate/fpml:dateRelativeToPaymentDates/fpml:paymentDatesReference[position()=2]/@href">
</xsl:apply-templates>
</xsl:when>
<xsl:when test="$productType='Cross Currency Basis Swap'">
<xsl:apply-templates select="$floatingStream/fpml:settlementProvision/fpml:nonDeliverableSettlement/fpml:fxFixingDate/fpml:dateRelativeToPaymentDates/fpml:paymentDatesReference[position()=2]/@href">
</xsl:apply-templates>
</xsl:when>
</xsl:choose>
</ValuationDateType>
<ValuationDateType_2>
<xsl:choose>
<xsl:when test="$productType='Cross Currency IRS'">
<xsl:apply-templates select="$floatingStream/fpml:settlementProvision/fpml:nonDeliverableSettlement/fpml:fxFixingDate/fpml:dateRelativeToPaymentDates/fpml:paymentDatesReference[position()=2]/@href">
</xsl:apply-templates>
</xsl:when>
<xsl:when test="$productType='Cross Currency Basis Swap'">
<xsl:apply-templates select="$floatingStream2/fpml:settlementProvision/fpml:nonDeliverableSettlement/fpml:fxFixingDate/fpml:dateRelativeToPaymentDates/fpml:paymentDatesReference[position()=2]/@href">
</xsl:apply-templates>
</xsl:when>
</xsl:choose>
</ValuationDateType_2>
<SettlementCurrency_2>
<xsl:choose>
<xsl:when test="$productType='Cross Currency IRS'">
<xsl:value-of select="$floatingStream/fpml:settlementProvision/fpml:settlementCurrency"/>
</xsl:when>
<xsl:when test="$productType='Cross Currency Basis Swap'">
<xsl:value-of select="$floatingStream2/fpml:settlementProvision/fpml:settlementCurrency"/>
</xsl:when>
<xsl:when test="$productType='Fixed Fixed Swap'">
<xsl:value-of select="$fixedStream2/fpml:settlementProvision/fpml:settlementCurrency"/>
</xsl:when>
</xsl:choose>
</SettlementCurrency_2>
<ReferenceCurrency_2>
<xsl:choose>
<xsl:when test="$productType='Cross Currency IRS'">
<xsl:value-of select="$floatingStream/fpml:settlementProvision/fpml:nonDeliverableSettlement/fpml:referenceCurrency"/>
</xsl:when>
<xsl:when test="$productType='Cross Currency Basis Swap'">
<xsl:value-of select="$floatingStream2/fpml:settlementProvision/fpml:nonDeliverableSettlement/fpml:referenceCurrency"/>
</xsl:when>
<xsl:when test="$productType='Fixed Fixed Swap'">
<xsl:value-of select="$fixedStream2/fpml:settlementProvision/fpml:nonDeliverableSettlement/fpml:referenceCurrency"/>
</xsl:when>
</xsl:choose>
</ReferenceCurrency_2>
<SettlementRateOption_2>
<xsl:choose>
<xsl:when test="$productType='Cross Currency IRS'">
<xsl:value-of select="$floatingStream/fpml:settlementProvision/fpml:nonDeliverableSettlement/fpml:settlementRateOption"/>
</xsl:when>
<xsl:when test="$productType='Cross Currency Basis Swap'">
<xsl:value-of select="$floatingStream2/fpml:settlementProvision/fpml:nonDeliverableSettlement/fpml:settlementRateOption"/>
</xsl:when>
<xsl:when test="$productType='Fixed Fixed Swap'">
<xsl:value-of select="$fixedStream2/fpml:settlementProvision/fpml:nonDeliverableSettlement/fpml:settlementRateOption"/>
</xsl:when>
</xsl:choose>
</SettlementRateOption_2>
<FxFixingDate_2>
<FxFixingPeriod_2>
<xsl:choose>
<xsl:when test="$productType='Cross Currency IRS'">
<xsl:value-of select="$floatingStream/fpml:settlementProvision/fpml:nonDeliverableSettlement/fpml:fxFixingDate/fpml:periodMultiplier"/>
</xsl:when>
<xsl:when test="$productType='Cross Currency Basis Swap'">
<xsl:value-of select="$floatingStream2/fpml:settlementProvision/fpml:nonDeliverableSettlement/fpml:fxFixingDate/fpml:periodMultiplier"/>
</xsl:when>
<xsl:when test="$productType='Fixed Fixed Swap'">
<xsl:value-of select="$fixedStream2/fpml:settlementProvision/fpml:nonDeliverableSettlement/fpml:fxFixingDate/fpml:periodMultiplier"/>
</xsl:when>
</xsl:choose>
</FxFixingPeriod_2>
<FxFixingDayConvention_2>
<xsl:choose>
<xsl:when test="$productType='Cross Currency IRS'">
<xsl:value-of select="substring($floatingStream/fpml:settlementProvision/fpml:nonDeliverableSettlement/fpml:fxFixingDate/fpml:businessDayConvention,1,4)"/>
</xsl:when>
<xsl:when test="$productType='Cross Currency Basis Swap'">
<xsl:value-of select="substring($floatingStream2/fpml:settlementProvision/fpml:nonDeliverableSettlement/fpml:fxFixingDate/fpml:businessDayConvention,1,4)"/>
</xsl:when>
<xsl:when test="$productType='Fixed Fixed Swap'">
<xsl:value-of select="substring($fixedStream2/fpml:settlementProvision/fpml:nonDeliverableSettlement/fpml:fxFixingDate/fpml:businessDayConvention,1,4)"/>
</xsl:when>
</xsl:choose>
</FxFixingDayConvention_2>
<FxFixingCentres_2>
<xsl:choose>
<xsl:when test="$productType='Cross Currency IRS'">
<xsl:apply-templates select="$floatingStream/fpml:settlementProvision/fpml:nonDeliverableSettlement/fpml:fxFixingDate/fpml:businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:when>
<xsl:when test="$productType='Cross Currency Basis Swap'">
<xsl:apply-templates select="$floatingStream2/fpml:settlementProvision/fpml:nonDeliverableSettlement/fpml:fxFixingDate/fpml:businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:when>
<xsl:when test="$productType='Fixed Fixed Swap'">
<xsl:apply-templates select="$fixedStream2/fpml:settlementProvision/fpml:nonDeliverableSettlement/fpml:fxFixingDate/fpml:businessCenters">
<xsl:sort select="."/>
</xsl:apply-templates>
</xsl:when>
</xsl:choose>
</FxFixingCentres_2>
</FxFixingDate_2>
<OutsideNovationTradeDate>
<xsl:if test="$productType='IRS' or $productType='OIS'">
<xsl:value-of select="$swOutsideNovation/fpml:novationTradeDate"/>
</xsl:if>
</OutsideNovationTradeDate>
<OutsideNovationNovationDate>
<xsl:if test="$productType='IRS' or $productType='OIS'">
<xsl:value-of select="$swOutsideNovation/fpml:novationDate"/>
</xsl:if>
</OutsideNovationNovationDate>
<OutsideNovationOutgoingParty>
<xsl:if test="$productType='IRS' or $productType='OIS'">
<xsl:value-of select="$swOutsideNovation/fpml:swTransferor/fpml:partyId"/>
</xsl:if>
</OutsideNovationOutgoingParty>
<OutsideNovationIncomingParty>
<xsl:if test="$productType='IRS' or $productType='OIS'">
<xsl:value-of select="$swLongFormTrade//fpml:party[@id=$swOutsideNovation/fpml:transferee/@href]/fpml:partyId"/>
</xsl:if>
</OutsideNovationIncomingParty>
<OutsideNovationRemainingParty>
<xsl:if test="$productType='IRS' or $productType='OIS'">
<xsl:value-of select="$swLongFormTrade//fpml:party[@id=$swOutsideNovation/fpml:remainingParty/@href]/fpml:partyId"/>
</xsl:if>
</OutsideNovationRemainingParty>
<OutsideNovationFullFirstCalculationPeriod>
<xsl:if test="$productType='IRS' or $productType='OIS'">
<xsl:value-of select="$swOutsideNovation/fpml:fullFirstCalculationPeriod"/>
</xsl:if>
</OutsideNovationFullFirstCalculationPeriod>
<CalcAgentA>
<xsl:if test="$referenceCurrency='BRL'">
<xsl:choose>
<xsl:when test="$trade/fpml:calculationAgent/fpml:calculationAgentParty[.='AsSpecifiedInMasterAgreement']">As Specified in Master Agreement</xsl:when>
<xsl:when test="count($trade/fpml:calculationAgent/fpml:calculationAgentPartyReference)=2">Joint</xsl:when>
<xsl:when test="$trade/fpml:calculationAgent/fpml:calculationAgentPartyReference[$partyA]">My Entity</xsl:when>
<xsl:when test="$trade/fpml:calculationAgent/fpml:calculationAgentPartyReference[$partyB]">Other Entity</xsl:when>
</xsl:choose>
</xsl:if>
</CalcAgentA>
<AmendmentType>
<xsl:choose>
<xsl:when test="$swExtendedTradeDetails/fpml:swAmendmentType='PartialTermination'">Partial Termination</xsl:when>
<xsl:when test="$swExtendedTradeDetails/fpml:swAmendmentType='ErrorCorrection'">Error Correction</xsl:when>
<xsl:when test="$swExtendedTradeDetails/fpml:swAmendmentType='FixingOnly'">Fixing Only</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$swExtendedTradeDetails/fpml:swAmendmentType"/>
</xsl:otherwise>
</xsl:choose>
</AmendmentType>
<CancellationType>
<xsl:choose>
<xsl:when test="$swExtendedTradeDetails/fpml:swCancellationType='BookedInError'">Booked in Error</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$swExtendedTradeDetails/fpml:swCancellationType"/>
</xsl:otherwise>
</xsl:choose>
</CancellationType>
<Cancelable>
<xsl:choose>
<xsl:when test="$swap/fpml:cancelableProvision">true</xsl:when>
<xsl:when test="$swShortFormTrade//fpml:swCancelableProvision and ($productType='IRS' or $productType='OIS')">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</Cancelable>
<CancelableDirectionA>
<xsl:variable name="cancelableBuyer">
<xsl:value-of select="$swap/fpml:cancelableProvision/fpml:buyerPartyReference/@href"/>
<xsl:if test="$productType='IRS' or $productType='OIS'">
<xsl:value-of select="$swShortFormTrade//fpml:swCancelableProvision/fpml:swCancelableBuyerPartyReference/@href"/>
</xsl:if>
</xsl:variable>
<xsl:choose>
<xsl:when test="string($cancelableBuyer)=string($partyA)">Buy</xsl:when>
<xsl:otherwise>Sell</xsl:otherwise>
</xsl:choose>
</CancelableDirectionA>
<CancelableOptionStyle>
<xsl:choose>
<xsl:when test="$swap/fpml:cancelableProvision/fpml:bermudaExercise">Bermudan</xsl:when>
<xsl:when test="$swap/fpml:cancelableProvision/fpml:americanExercise">American</xsl:when>
<xsl:when test="$swap/fpml:cancelableProvision/fpml:europeanExercise">European</xsl:when>
<xsl:otherwise>???</xsl:otherwise>
</xsl:choose>
</CancelableOptionStyle>
<CancelableFirstExerciseDate>
<xsl:value-of select="$swap/fpml:cancelableProvision//fpml:relevantUnderlyingDate//fpml:scheduleBounds/fpml:unadjustedFirstDate"/>
<xsl:value-of select="$swap/fpml:cancelableProvision//fpml:relevantUnderlyingDate/fpml:adjustableDates/fpml:unadjustedDate"/>
<xsl:if test="$productType='IRS' or $productType='OIS'">
<xsl:value-of select="$swShortFormTrade//fpml:swCancelableProvision/fpml:swCancelableFirstExerciseDate"/>
</xsl:if>
</CancelableFirstExerciseDate>
<CancelableExerciseFrequency>
<xsl:call-template name="formatInterval">
<xsl:with-param name="interval" select="$swap/fpml:cancelableProvision//fpml:relevantUnderlyingDate/fpml:relativeDates"/>
</xsl:call-template>
<xsl:if test="$productType='IRS' or $productType='OIS'">
<xsl:call-template name="formatInterval">
<xsl:with-param name="interval" select="$swShortFormTrade//fpml:swCancelableProvision/fpml:swCancelableExerciseFrequency"/>
</xsl:call-template>
</xsl:if>
</CancelableExerciseFrequency>
<CancelableEarliestTime>
<xsl:call-template name="formatTime">
<xsl:with-param name="time" select="string($swap/fpml:cancelableProvision//fpml:earliestExerciseTime/fpml:hourMinuteTime)"/>
</xsl:call-template>
</CancelableEarliestTime>
<CancelableExpiryTime>
<xsl:call-template name="formatTime">
<xsl:with-param name="time" select="string($swap/fpml:cancelableProvision//fpml:expirationTime/fpml:hourMinuteTime)"/>
</xsl:call-template>
</CancelableExpiryTime>
<CancelableExerciseLag>
<xsl:value-of select="$swap/fpml:cancelableProvision//fpml:bermudaExerciseDates/fpml:relativeDates/fpml:periodMultiplier"/>
<xsl:value-of select="$swap/fpml:cancelableProvision//fpml:americanExercise/fpml:commencementDate/fpml:relativeDate/fpml:periodMultiplier"/>
<xsl:value-of select="$swap/fpml:cancelableProvision//fpml:europeanExercise/fpml:expirationDate/fpml:relativeDate/fpml:periodMultiplier"/>
</CancelableExerciseLag>
<CancelableHolidayCentre>
<xsl:apply-templates select="$swap/fpml:cancelableProvision//fpml:bermudaExerciseDates/fpml:relativeDates/fpml:businessCenters"/>
<xsl:apply-templates select="$swap/fpml:cancelableProvision//fpml:americanExercise/fpml:commencementDate/fpml:relativeDate/fpml:businessCenters"/>
<xsl:apply-templates select="$swap/fpml:cancelableProvision//fpml:europeanExercise/fpml:expirationDate/fpml:relativeDate/fpml:businessCenters"/>
</CancelableHolidayCentre>
<CancelableLocation>
<xsl:apply-templates select="$swap/fpml:cancelableProvision//fpml:expirationTime/fpml:businessCenter"/>
</CancelableLocation>
<CancelableConvention>
<xsl:variable name="cancelableConvention" select="substring($swap/fpml:cancelableProvision//fpml:relevantUnderlyingDate//fpml:businessDayConvention,1,4)"/>
<xsl:choose>
<xsl:when test="$cancelableConvention='NotA'">NA</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$cancelableConvention"/>
</xsl:otherwise>
</xsl:choose>
</CancelableConvention>
<CancelableFUC>
<xsl:value-of select="$swap/fpml:cancelableProvision/fpml:followUpConfirmation"/>
</CancelableFUC>
<CancelableDayType>
<xsl:value-of select="$swap/fpml:cancelableProvision//fpml:bermudaExerciseDates/fpml:relativeDates/fpml:dayType"/>
<xsl:value-of select="$swap/fpml:cancelableProvision//fpml:americanExercise/fpml:commencementDate/fpml:relativeDate/fpml:dayType"/>
<xsl:value-of select="$swap/fpml:cancelableProvision//fpml:europeanExercise/fpml:expirationDate/fpml:relativeDate/fpml:dayType"/>
</CancelableDayType>
<CancelableLagConvention>
<xsl:value-of select="substring($swap/fpml:cancelableProvision//fpml:bermudaExerciseDates/fpml:relativeDates/fpml:businessDayConvention,1,4)"/>
<xsl:value-of select="substring($swap/fpml:cancelableProvision//fpml:americanExercise/fpml:commencementDate/fpml:relativeDate/fpml:businessDayConvention,1,4)"/>
<xsl:value-of select="substring($swap/fpml:cancelableProvision//fpml:europeanExercise/fpml:expirationDate/fpml:relativeDate/fpml:businessDayConvention,1,4)"/>
</CancelableLagConvention>
<CancelableRollCentres>
<xsl:if test="$productType='IRS' or $productType='OIS'">
<xsl:apply-templates select="$swap/fpml:cancelableProvision//fpml:bermudaExercise/fpml:relevantUnderlyingDate/fpml:relativeDates/fpml:businessCenters"/>
<xsl:apply-templates select="$swap/fpml:cancelableProvision//fpml:americanExercise/fpml:relevantUnderlyingDate/fpml:relativeDates/fpml:businessCenters"/>
<xsl:apply-templates select="$swap/fpml:cancelableProvision//fpml:europeanExercise/fpml:relevantUnderlyingDate/fpml:adjustableDates/fpml:dateAdjustments/fpml:businessCenters"/>
</xsl:if>
</CancelableRollCentres>
<xsl:if test="$swap/fpml:additionalPayment[fpml:paymentType='CancellablePremium']">
<CancelablePremium>
<PaymentDirectionA>
<xsl:variable name="payer" select="string($swap/fpml:additionalPayment[fpml:paymentType='CancellablePremium']/fpml:payerPartyReference/@href)"/>
<xsl:choose>
<xsl:when test="string($payer)=string($partyA)">Pay</xsl:when>
<xsl:otherwise>Rec</xsl:otherwise>
</xsl:choose>
</PaymentDirectionA>
<Currency>
<xsl:value-of select="$swap/fpml:additionalPayment[fpml:paymentType='CancellablePremium']/fpml:paymentAmount/fpml:currency"/>
</Currency>
<Amount>
<xsl:value-of select="$swap/fpml:additionalPayment[fpml:paymentType='CancellablePremium']/fpml:paymentAmount/fpml:amount"/>
</Amount>
<Date>
<xsl:if test="$swap/fpml:additionalPayment[fpml:paymentType='CancellablePremium']/fpml:paymentDate">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string($swap/fpml:additionalPayment[fpml:paymentType='CancellablePremium']/fpml:paymentDate/fpml:unadjustedDate)"/>
</xsl:call-template>
</xsl:if>
</Date>
<Convention>
<xsl:value-of select="substring($swap/fpml:additionalPayment[fpml:paymentType='CancellablePremium']/fpml:paymentDate/fpml:dateAdjustments/fpml:businessDayConvention,1,4)"/>
</Convention>
<Holidays>
<xsl:apply-templates select="$swap/fpml:additionalPayment[fpml:paymentType='CancellablePremium']/fpml:paymentDate/fpml:dateAdjustments/fpml:businessCenters"/>
</Holidays>
</CancelablePremium>
</xsl:if>
<CancellationForwardPremium>
<xsl:choose>
<xsl:when test="$productType='Swaption'">
<xsl:choose>
<xsl:when test="$swExtendedTradeDetails/fpml:swForwardPremium = 'true'">true</xsl:when>
<xsl:when test="$swExtendedTradeDetails/fpml:swForwardPremium = 'false'">false</xsl:when>
<xsl:otherwise/>
</xsl:choose>
</xsl:when>
<xsl:otherwise/>
</xsl:choose>
</CancellationForwardPremium>
<xsl:if test="not($swTradeHeader/fpml:swClearingHouse/fpml:partyId)">
<SettlementAgency>
<xsl:value-of select="$swSettlementAgent/fpml:swSettlementAgency/fpml:partyId"/>
</SettlementAgency>
<SettlementAgencyModel>
<xsl:value-of select="$swSettlementAgent/fpml:swSettlementAgencyModel"/>
</SettlementAgencyModel>
</xsl:if>
<OfflineLeg1>
<xsl:if test="$productType = 'Offline Trade Rates'">
<xsl:variable name="OfflineProdType" select="string($swOfflineTrade/fpml:swOfflineProductType)"/>
<xsl:choose>
<xsl:when test="$offlinefloatingLeg=1">Float</xsl:when>
<xsl:when test="$offlinefixedLeg=1">Fixed</xsl:when>
<xsl:when test="$OfflineProdType='FRA' or $OfflineProdType='Cap' or $OfflineProdType='Floor' or $OfflineProdType='Swaption'">Fixed</xsl:when>
<xsl:otherwise>Unknown</xsl:otherwise>
</xsl:choose>
</xsl:if>
</OfflineLeg1>
<OfflineLeg2>
<xsl:if test="$productType = 'Offline Trade Rates'">
<xsl:choose>
<xsl:when test="$offlinefloatingLeg2=2">Float</xsl:when>
<xsl:when test="$offlinefixedLeg2=2">Fixed</xsl:when>
<xsl:otherwise>Unknown</xsl:otherwise>
</xsl:choose>
</xsl:if>
</OfflineLeg2>
<OfflineSpread>
<xsl:value-of select="$swOfflineTrade/fpml:swSpread/fpml:spread"/>
</OfflineSpread>
<OfflineSpreadLeg>
<xsl:value-of select="$swOfflineTrade/fpml:swSpread/fpml:swSpreadLeg"/>
</OfflineSpreadLeg>
<OfflineSpreadParty>
<xsl:value-of select="$swOfflineTrade/fpml:swSpread/fpml:payerPartyReference/@href"/>
</OfflineSpreadParty>
<OfflineSpreadDirection>
<xsl:if test="$swOfflineTrade/fpml:swSpread/fpml:payerPartyReference">
<xsl:variable name="payer" select="string($swOfflineTrade/fpml:swSpread/fpml:payerPartyReference/@href)"/>
<xsl:choose>
<xsl:when test="string($payer)=string($partyA)">Pay</xsl:when>
<xsl:otherwise>Rec</xsl:otherwise>
</xsl:choose>
</xsl:if>
</OfflineSpreadDirection>
<OfflineAdditionalDetails>
<xsl:value-of select="$swOfflineTrade/fpml:swAdditionalDetails"/>
</OfflineAdditionalDetails>
<OfflineOrigRef>
<xsl:if test="$productType='Offline Trade Rates'">
<xsl:for-each select="$swOfflineTrade/fpml:swOriginalTradeReferences//fpml:swOriginalTradeReference">
<xsl:if test="fpml:partyReference/@href = $SWDML//fpml:swOriginatorPartyReference/@href">
<xsl:value-of select="fpml:swTradeReference"/>
</xsl:if>
</xsl:for-each>
</xsl:if>
</OfflineOrigRef>
<OfflineOrigRef_2>
<xsl:if test="$productType='Offline Trade Rates'">
<xsl:for-each select="$swOfflineTrade/fpml:swOriginalTradeReferences//fpml:swOriginalTradeReference">
<xsl:if test="fpml:partyReference/@href != $SWDML//fpml:swOriginatorPartyReference/@href">
<xsl:value-of select="fpml:swTradeReference"/>
</xsl:if>
</xsl:for-each>
</xsl:if>
</OfflineOrigRef_2>
<OfflineTradeDesk>
<xsl:if test="$productType='Offline Trade Rates'">
<xsl:for-each select="$swOfflineTrade/fpml:swOriginalTradeReferences//fpml:swOriginalTradeReference">
<xsl:if test="fpml:partyReference/@href = $SWDML//fpml:swOriginatorPartyReference/@href">
<xsl:value-of select="fpml:swTradeDesk"/>
</xsl:if>
</xsl:for-each>
</xsl:if>
</OfflineTradeDesk>
<OfflineTradeDesk_2>
<xsl:if test="$productType='Offline Trade Rates'">
<xsl:for-each select="$swOfflineTrade/fpml:swOriginalTradeReferences//fpml:swOriginalTradeReference">
<xsl:if test="fpml:partyReference/@href != $SWDML//fpml:swOriginatorPartyReference/@href">
<xsl:value-of select="fpml:swTradeDesk"/>
</xsl:if>
</xsl:for-each>
</xsl:if>
</OfflineTradeDesk_2>
<OfflineProductType>
<xsl:if test="$productType='Offline Trade Rates'">
<xsl:value-of select="$swOfflineTrade/fpml:swOfflineProductType"/>
</xsl:if>
</OfflineProductType>
<OfflineExpirationDate>
<xsl:if test="$productType='Offline Trade Rates'">
<xsl:value-of select="$swOfflineTrade/fpml:expirationDate"/>
</xsl:if>
</OfflineExpirationDate>
<OfflineOptionType>
<xsl:if test="$productType='Offline Trade Rates'">
<xsl:value-of select="$swOfflineTrade/fpml:swOptionType"/>
</xsl:if>
</OfflineOptionType>
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
<xsl:value-of select="$swExtendedTradeDetails/fpml:swExitReason"/>
</ExitReason>
<TransactionDate>
<xsl:if test="$swExtendedTradeDetails/fpml:swModificationTradeDate">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string($swExtendedTradeDetails/fpml:swModificationTradeDate)"/>
</xsl:call-template>
</xsl:if>
</TransactionDate>
<EffectiveDate>
<xsl:if test="$swExtendedTradeDetails/fpml:swModificationEffectiveDate">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string($swExtendedTradeDetails/fpml:swModificationEffectiveDate)"/>
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
<xsl:value-of select="$swExtendedTradeDetails/fpml:swFutureValue/fpml:swNotionalFutureValue/fpml:amount"/>
</xsl:if>
</NotionalFutureValue>
<NotionalSchedule>
<xsl:if test="$productType='IRS' or $productType='Fixed Fixed Swap' or $productType='OIS'">
<xsl:for-each select="$fixedStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:step">
<xsl:call-template name="formatNotionalSchedule">
<xsl:with-param name="position" select="string(position())"/>
<xsl:with-param name="leg" select="string($fixedLeg)"/>
</xsl:call-template>
</xsl:for-each>
<xsl:if test="not($fixedStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:step)">
<xsl:for-each select="$fixedStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:fixedRateSchedule/fpml:step">
<xsl:call-template name="formatNotionalSchedule">
<xsl:with-param name="position" select="string(position())"/>
<xsl:with-param name="leg" select="string($fixedLeg)"/>
</xsl:call-template>
</xsl:for-each>
</xsl:if>
</xsl:if>
<xsl:if test="$productType='Fixed Fixed Swap'">
<xsl:for-each select="$fixedStream2/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:step">
<xsl:call-template name="formatNotionalSchedule">
<xsl:with-param name="position" select="string(position())"/>
<xsl:with-param name="leg" select="string($fixedLeg2)"/>
</xsl:call-template>
</xsl:for-each>
<xsl:if test="not($fixedStream2/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:step)">
<xsl:for-each select="$fixedStream2/fpml:calculationPeriodAmount/fpml:calculation/fpml:fixedRateSchedule/fpml:step">
<xsl:call-template name="formatNotionalSchedule">
<xsl:with-param name="position" select="string(position())"/>
<xsl:with-param name="leg" select="string($fixedLeg2)"/>
</xsl:call-template>
</xsl:for-each>
</xsl:if>
</xsl:if>
<xsl:if test="$productType='IRS' or $productType='Single Currency Basis Swap' or $productType='OIS'">
<xsl:for-each select="$floatingStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:step">
<xsl:call-template name="formatNotionalSchedule">
<xsl:with-param name="position" select="string(position())"/>
<xsl:with-param name="leg" select="string($floatingLeg)"/>
</xsl:call-template>
</xsl:for-each>
<xsl:if test="not($floatingStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:step)">
<xsl:for-each select="$floatingStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:spreadSchedule/fpml:step">
<xsl:call-template name="formatNotionalSchedule">
<xsl:with-param name="position" select="string(position())"/>
<xsl:with-param name="leg" select="string($floatingLeg)"/>
</xsl:call-template>
</xsl:for-each>
</xsl:if>
</xsl:if>
<xsl:if test="$productType='Single Currency Basis Swap'">
<xsl:for-each select="$floatingStream2/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:step">
<xsl:call-template name="formatNotionalSchedule">
<xsl:with-param name="position" select="string(position())"/>
<xsl:with-param name="leg" select="string($floatingLeg2)"/>
</xsl:call-template>
</xsl:for-each>
<xsl:if test="not($floatingStream2/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:step)">
<xsl:for-each select="$floatingStream2/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:spreadSchedule/fpml:step">
<xsl:call-template name="formatNotionalSchedule">
<xsl:with-param name="position" select="string(position())"/>
<xsl:with-param name="leg" select="string($floatingLeg2)"/>
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
<xsl:if test="$novation">
<xsl:choose>
<xsl:when test="$novation/fpml:swNovationInitiatorReference/@href = $novation/fpml:transferor/@href">Transferor</xsl:when>
<xsl:when test="$novation/fpml:swNovationInitiatorReference/@href = $novation/fpml:transferee/@href">Transferee</xsl:when>
<xsl:when test="$novation/fpml:swNovationInitiatorReference/@href = $novation/fpml:remainingParty/@href">RemainingParty</xsl:when>
<xsl:when test="$novation/fpml:swNovationInitiatorReference/@href = $novation/fpml:otherRemainingParty/@href">RemainingParty</xsl:when>
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
<xsl:for-each select="$swMidMarketPrice">
<xsl:choose>
<xsl:when test="fpml:swUnit | fpml:swAmount | fpml:swCurrency">
<MidMarketPriceType>
<xsl:value-of select="fpml:swUnit"/>
</MidMarketPriceType>
<MidMarketPriceValue>
<xsl:value-of select="fpml:swAmount"/>
</MidMarketPriceValue>
<xsl:choose>
<xsl:when test="fpml:swUnit='Price'">
<MidMarketPriceCurrency>
<xsl:value-of select="fpml:swCurrency"/>
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
<xsl:for-each select="$novMidMarketPrice">
<xsl:choose>
<xsl:when test="fpml:swUnit | fpml:swAmount | fpml:swCurrency">
<NovationFeeMidMarketPriceType>
<xsl:value-of select="fpml:swUnit"/>
</NovationFeeMidMarketPriceType>
<NovationFeeMidMarketPriceValue>
<xsl:value-of select="fpml:swAmount"/>
</NovationFeeMidMarketPriceValue>
<xsl:choose>
<xsl:when test="fpml:swUnit='Price'">
<NovationFeeMidMarketPriceCurrency>
<xsl:value-of select="fpml:swCurrency"/>
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
<xsl:if test="boolean($swOrderDetails/fpml:swTypeOfOrder)">
<TypeOfOrder>
<xsl:value-of select="$swOrderDetails/fpml:swTypeOfOrder"/>
</TypeOfOrder>
</xsl:if>
<xsl:if test="boolean($swOrderDetails/fpml:swTotalConsideration)">
<TotalConsideration>
<xsl:value-of select="$swOrderDetails/fpml:swTotalConsideration"/>
</TotalConsideration>
</xsl:if>
<xsl:if test="boolean($swOrderDetails/fpml:swRateOfExchange)">
<RateOfExchange>
<xsl:value-of select="$swOrderDetails/fpml:swRateOfExchange"/>
</RateOfExchange>
</xsl:if>
<xsl:if test="boolean($swOrderDetails/fpml:swClientCounterparty)">
<ClientCounterparty>
<xsl:value-of select="$swOrderDetails/fpml:swClientCounterparty"/>
</ClientCounterparty>
</xsl:if>
<xsl:if test="boolean($swOrderDetails/fpml:swTotalCommissionAndExpenses)">
<TotalCommissionAndExpenses>
<xsl:value-of select="$swOrderDetails/fpml:swTotalCommissionAndExpenses"/>
</TotalCommissionAndExpenses>
</xsl:if>
<xsl:if test="boolean($swOrderDetails/fpml:swClientSettlementResponsibilities)">
<ClientSettlementResponsibilities>
<xsl:value-of select="$swOrderDetails/fpml:swClientSettlementResponsibilities"/>
</ClientSettlementResponsibilities>
</xsl:if>
</OrderDetails>
</xsl:if>
<xsl:apply-templates select="$swTradeHeader/fpml:swClearingDetails"/>
<xsl:for-each select="$apiBatchId">
<ApiBatchId>
<xsl:value-of select="."/>
</ApiBatchId>
</xsl:for-each>
<xsl:for-each select="$nettingBatchId">
<NettingBatchId>
<xsl:value-of select="."/>
</NettingBatchId>
</xsl:for-each>
<xsl:for-each select="$privateClearingTradeID">
<PrivateClearingTradeID>
<xsl:value-of select="."/>
</PrivateClearingTradeID>
</xsl:for-each>
<xsl:for-each
select="$swStructuredTradeDetails/fpml:swSequenceNumber">
<NettingSequenceNumber>
<xsl:value-of select="."/>
</NettingSequenceNumber>
</xsl:for-each>
<xsl:for-each
select="$swStructuredTradeDetails/fpml:swExecutionDateTime">
<ExecutionTime>
<xsl:value-of select="."/>
</ExecutionTime>
</xsl:for-each>
<xsl:for-each select="$bulkEventID">
<BulkEventID>
<xsl:value-of select="$bulkEventID"/>
</BulkEventID>
</xsl:for-each>
<xsl:for-each select="$nettingString">
<NettingString>
<xsl:value-of select="$nettingString"/>
</NettingString>
</xsl:for-each>
<xsl:for-each select="$linkTradeID">
<NettingLinkedTradeID>
<xsl:value-of select="$linkTradeID"/>
</NettingLinkedTradeID>
</xsl:for-each>
<xsl:for-each select="$linkCCPID">
<NettingLinkedCCPID>
<xsl:value-of select="$linkCCPID"/>
</NettingLinkedCCPID>
</xsl:for-each>
<xsl:if test="$swHeader/fpml:swOriginatingEvent!='PortfolioTransfer'">
<LinkedTradeDetails>
<xsl:for-each select="$swLinkedTradeDetails">
<xsl:variable name="iter" select="position()"/>
<xsl:if test="@linkIdScheme='http://www.swapswire.com/spec/2001/trade-id-1-0'">
<LinkedIDType>MarkitWireID</LinkedIDType>
</xsl:if>
<xsl:if test="@linkIdScheme='http://www.swapswire.com/spec/2001/ccp-trade-id-1-0'">
<LinkedIDType>CCPTradeID</LinkedIDType>
</xsl:if>
<xsl:if test="@linkIdScheme='http://www.swapswire.com/spec/2001/internal-trade-id-1-0'">
<LinkedIDType>InternalTradeID</LinkedIDType>
</xsl:if>
<xsl:if test="@linkIdScheme='http://www.swapswire.com/spec/2001/trade-id-1-0' or @linkIdScheme='http://www.swapswire.com/spec/2001/ccp-trade-id-1-0' or @linkIdScheme='http://www.swapswire.com/spec/2001/internal-trade-id-1-0'">
<LinkedTradeID>
<xsl:value-of select="$swLinkedTradeDetails[$iter]"/>
</LinkedTradeID>
</xsl:if>
</xsl:for-each>
</LinkedTradeDetails>
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
<xsl:template match="fpml:swClearingDetails">
<ClearingDetails>
<ClearingStatus>
<xsl:value-of select="fpml:swClearingStatus"/>
</ClearingStatus>
<ClearingHouseTradeID>
<xsl:value-of select="fpml:swClearingHouseTradeID"/>
</ClearingHouseTradeID>
<ClearingHouseUpfrontFeeSettlementDate>
<xsl:value-of select="fpml:swClearingHouseUpfrontFeeSettlementDate"/>
</ClearingHouseUpfrontFeeSettlementDate>
<ClearingHousePreferredISIN>
<xsl:value-of select="fpml:swClearingHousePreferredISIN"/>
</ClearingHousePreferredISIN>
<ClearedTimestamp>
<xsl:value-of select="fpml:swClearedTimestamp"/>
</ClearedTimestamp>
<ClearedUSINamespace>
<xsl:value-of select="fpml:swClearedUSI/fpml:swIssuer"/>
</ClearedUSINamespace>
<ClearedUSI>
<xsl:value-of select="fpml:swClearedUSI/fpml:swTradeId"/>
</ClearedUSI>
<ClearedUTINamespace>
<xsl:value-of select="fpml:swClearedUTI/fpml:swIssuer"/>
</ClearedUTINamespace>
<ClearedUTI>
<xsl:value-of select="fpml:swClearedUTI/fpml:swTradeId"/>
</ClearedUTI>
</ClearingDetails>
</xsl:template>
<xsl:template name="formatNotionalSchedule">
<xsl:param name="position"/>
<xsl:param name="leg"/>
<xsl:variable name="calculation"  select="$swapStream[position()=$leg]/fpml:calculationPeriodAmount/fpml:calculation"/>
<xsl:variable name="notionalStep" select="$calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:step[position()= $position]"/>
<xsl:variable name="floatingStep" select="$calculation/fpml:floatingRateCalculation/fpml:spreadSchedule/fpml:step[position()= $position]"/>
<xsl:variable name="fixedStep"    select="$calculation/fpml:fixedRateSchedule/fpml:step[position()= $position]"/>
<xsl:choose>
<xsl:when test="$leg=$floatingLeg and $productType!='Fixed Fixed Swap'">
<FloatLegNotionalStep>
<FloatRollDates>
<xsl:choose>
<xsl:when test="$notionalStep/fpml:stepDate">
<xsl:value-of select="$notionalStep/fpml:stepDate"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$floatingStep/fpml:stepDate"/>
</xsl:otherwise>
</xsl:choose>
</FloatRollDates>
<FloatNotionals>
<xsl:value-of select="$notionalStep/fpml:stepValue"/>
</FloatNotionals>
<FloatSpreads>
<xsl:value-of select="$floatingStep/fpml:stepValue"/>
</FloatSpreads>
</FloatLegNotionalStep>
</xsl:when>
<xsl:when test="$leg=$floatingLeg2">
<FloatLegNotionalStep2>
<FloatRollDates2>
<xsl:choose>
<xsl:when test="$notionalStep/fpml:stepDate">
<xsl:value-of select="$notionalStep/fpml:stepDate"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$floatingStep/fpml:stepDate"/>
</xsl:otherwise>
</xsl:choose>
</FloatRollDates2>
<FloatNotionals2>
<xsl:value-of select="$notionalStep/fpml:stepValue"/>
</FloatNotionals2>
<FloatSpreads2>
<xsl:value-of select="$floatingStep/fpml:stepValue"/>
</FloatSpreads2>
</FloatLegNotionalStep2>
</xsl:when>
<xsl:when test="$leg=$fixedLeg">
<FixedLegNotionalStep>
<FixedPaymentDates>
<xsl:choose>
<xsl:when test="$notionalStep/fpml:stepDate">
<xsl:value-of select="$notionalStep/fpml:stepDate"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$fixedStep/fpml:stepDate"/>
</xsl:otherwise>
</xsl:choose>
</FixedPaymentDates>
<FixedNotionals>
<xsl:value-of select="$notionalStep/fpml:stepValue"/>
</FixedNotionals>
<FixedRates>
<xsl:value-of select="$fixedStep/fpml:stepValue"/>
</FixedRates>
</FixedLegNotionalStep>
</xsl:when>
<xsl:when test="$leg=$fixedLeg2">
<FixedLegNotionalStep2>
<FixedPaymentDates2>
<xsl:choose>
<xsl:when test="$notionalStep/fpml:stepDate">
<xsl:value-of select="$notionalStep/fpml:stepDate"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$fixedStep/fpml:stepDate"/>
</xsl:otherwise>
</xsl:choose>
</FixedPaymentDates2>
<FixedNotionals2>
<xsl:value-of select="$notionalStep/fpml:stepValue"/>
</FixedNotionals2>
<FixedRates2>
<xsl:value-of select="$fixedStep/fpml:stepValue"/>
</FixedRates2>
</FixedLegNotionalStep2>
</xsl:when>
</xsl:choose>
</xsl:template>
<xsl:template match="fpml:businessCenters">
<xsl:for-each select="fpml:businessCenter">
<xsl:value-of select="."/>
<xsl:if test="../fpml:businessCenter[last()]!=.">; </xsl:if>
</xsl:for-each>
</xsl:template>
<xsl:template match="fpml:cashSettlementReferenceBanks">
<xsl:for-each select="fpml:referenceBank">
<xsl:value-of select="fpml:referenceBankId"/>
<xsl:if test="../fpml:referenceBank[last()]!=.">; </xsl:if>
</xsl:for-each>
</xsl:template>
<xsl:template match="fpml:additionalPayment|fpml:payment">
<xsl:if test="string(fpml:paymentType) != 'CancellablePremium'">
<AdditionalPayment>
<PaymentDirectionA>
<xsl:variable name="payer" select="string(fpml:payerPartyReference/@href)"/>
<xsl:choose>
<xsl:when test="string($payer)=string($partyA)">Pay</xsl:when>
<xsl:otherwise>Rec</xsl:otherwise>
</xsl:choose>
</PaymentDirectionA>
<Reason>
<xsl:choose>
<xsl:when test="$productType = 'Offline Trade Rates' and ../fpml:payment">NovationConsent</xsl:when>
<xsl:when test="../fpml:novation/fpml:payment">
<xsl:choose>
<xsl:when test="../fpml:novation/fpml:payment/fpml:paymentType='Novation Notional Exchange'">Novation Notional Exchange</xsl:when>
<xsl:otherwise>Novation</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="fpml:paymentType"/>
</xsl:otherwise>
</xsl:choose>
</Reason>
<Currency>
<xsl:value-of select="fpml:paymentAmount/fpml:currency"/>
</Currency>
<Amount>
<xsl:value-of select="fpml:paymentAmount/fpml:amount"/>
</Amount>
<Date>
<xsl:if test="fpml:paymentDate">
<xsl:call-template name="formatDate">
<xsl:with-param name="date" select="string(fpml:paymentDate/fpml:unadjustedDate)"/>
</xsl:call-template>
</xsl:if>
</Date>
<Convention>
<xsl:value-of select="substring(fpml:paymentDate/fpml:dateAdjustments/fpml:businessDayConvention,1,4)"/>
</Convention>
<Holidays>
<xsl:apply-templates select="fpml:paymentDate/fpml:dateAdjustments/fpml:businessCenters"/>
</Holidays>
<LegalEntity>
<xsl:if test="$novation">
<xsl:choose>
<xsl:when test="$productType = 'Offline Trade Rates'">
<xsl:choose>
<xsl:when test="$partyE = $partyA">
<xsl:value-of select="$swOfflineTrade//fpml:party[@id=$partyF]/fpml:partyId"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$swOfflineTrade//fpml:party[@id=$partyE]/fpml:partyId"/>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:otherwise>
<xsl:choose>
<xsl:when test="$partyE = $partyA">
<xsl:value-of select="$FpML//fpml:party[@id=$partyF]/fpml:partyId"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$FpML//fpml:party[@id=$partyE]/fpml:partyId"/>
</xsl:otherwise>
</xsl:choose>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</LegalEntity>
</AdditionalPayment>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:documentation">
<xsl:for-each select="fpml:contractualDefinitions">
<xsl:apply-templates select="."/>
<xsl:if test="../fpml:contractualDefinitions[last()]!=.">; </xsl:if>
</xsl:for-each>
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
<xsl:when test="$time='00:00:00'">12midnight</xsl:when>
<xsl:when test="$time='01:00:00'">1am</xsl:when>
<xsl:when test="$time='02:00:00'">2am</xsl:when>
<xsl:when test="$time='03:00:00'">3am</xsl:when>
<xsl:when test="$time='04:00:00'">4am</xsl:when>
<xsl:when test="$time='05:00:00'">5am</xsl:when>
<xsl:when test="$time='06:00:00'">6am</xsl:when>
<xsl:when test="$time='07:00:00'">7am</xsl:when>
<xsl:when test="$time='08:00:00'">8am</xsl:when>
<xsl:when test="$time='09:00:00'">9am</xsl:when>
<xsl:when test="$time='09:30:00'">9:30am</xsl:when>
<xsl:when test="$time='09:55:00'">9:55am</xsl:when>
<xsl:when test="$time='10:00:00'">10am</xsl:when>
<xsl:when test="$time='10:30:00'">10:30am</xsl:when>
<xsl:when test="$time='11:00:00'">11am</xsl:when>
<xsl:when test="$time='11:10:00'">11:10am</xsl:when>
<xsl:when test="$time='11:15:00'">11:15am</xsl:when>
<xsl:when test="$time='11:30:00'">11:30am</xsl:when>
<xsl:when test="$time='11:40:00'">11:40am</xsl:when>
<xsl:when test="$time='12:00:00'">12noon</xsl:when>
<xsl:when test="$time='12:10:00'">12:10pm</xsl:when>
<xsl:when test="$time='12:15:00'">12:15pm</xsl:when>
<xsl:when test="$time='12:30:00'">12:30pm</xsl:when>
<xsl:when test="$time='12:35:00'">12:35pm</xsl:when>
<xsl:when test="$time='12:40:00'">12:40pm</xsl:when>
<xsl:when test="$time='13:00:00'">1pm</xsl:when>
<xsl:when test="$time='13:15:00'">1:15pm</xsl:when>
<xsl:when test="$time='13:30:00'">1:30pm</xsl:when>
<xsl:when test="$time='13:35:00'">1:35pm</xsl:when>
<xsl:when test="$time='14:00:00'">2pm</xsl:when>
<xsl:when test="$time='14:10:00'">2:10pm</xsl:when>
<xsl:when test="$time='14:15:00'">2:15pm</xsl:when>
<xsl:when test="$time='14:30:00'">2:30pm</xsl:when>
<xsl:when test="$time='14:45:00'">2:45pm</xsl:when>
<xsl:when test="$time='15:00:00'">3pm</xsl:when>
<xsl:when test="$time='15:15:00'">3:15pm</xsl:when>
<xsl:when test="$time='15:30:00'">3:30pm</xsl:when>
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
<xsl:template name="fpml:swAllocations">
<xsl:apply-templates select="$swLongFormTrade//fpml:swAllocations/fpml:swAllocation"/>
</xsl:template>
<xsl:template match="fpml:swAllocation">
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
<xsl:when test="$swLongFormTrade//fpml:swAllocations/fpml:swAllocation/fpml:payerPartyReference">
<xsl:variable name="PayerRef" select="string(fpml:payerPartyReference/@href)"/>
<xsl:variable name="ReceiverRef" select="string(fpml:receiverPartyReference/@href)"/>
<xsl:variable name="PayerBIC" select="string($FpML/fpml:party[@id=$PayerRef]/fpml:partyId)"/>
<xsl:variable name="ReceiverBIC" select="string($FpML/fpml:party[@id=$ReceiverRef]/fpml:partyId)"/>
<Payer>
<xsl:value-of select="$PayerBIC"/>
</Payer>
<Receiver>
<xsl:value-of select="$ReceiverBIC"/>
</Receiver>
</xsl:when>
<xsl:otherwise>
<xsl:variable name="BuyerRef" select="string(fpml:buyerPartyReference/@href)"/>
<xsl:variable name="SellerRef" select="string(fpml:sellerPartyReference/@href)"/>
<xsl:variable name="BuyerBIC" select="string($FpML/fpml:party[@id=$BuyerRef]/fpml:partyId)"/>
<xsl:variable name="SellerBIC" select="string($FpML/fpml:party[@id=$SellerRef]/fpml:partyId)"/>
<Buyer>
<xsl:value-of select="$BuyerBIC"/>
</Buyer>
<Seller>
<xsl:value-of select="$SellerBIC"/>
</Seller>
</xsl:otherwise>
</xsl:choose>
<xsl:variable name="amount" select="string(fpml:allocatedNotional/fpml:amount)"/>
<Amount>
<xsl:value-of select="$amount"/>
</Amount>
<xsl:if test="fpml:swAllocatedContraNotional">
<ContraAmount>
<xsl:value-of select="fpml:swAllocatedContraNotional/fpml:amount"/>
</ContraAmount>
</xsl:if>
<xsl:if test="fpml:swVariableAmount">
<VariableAmount>
<xsl:value-of select="fpml:swVariableAmount/fpml:amount"/>
</VariableAmount>
</xsl:if>
<xsl:if test="fpml:swFixedAmount">
<ZCAllocAmount>
<xsl:value-of select="string(fpml:swFixedAmount/fpml:amount)"/>
</ZCAllocAmount>
</xsl:if>
<xsl:if test="fpml:swContraFixedAmount">
<ContraZCAllocAmount>
<xsl:value-of select="fpml:swContraFixedAmount/fpml:amount"/>
</ContraZCAllocAmount>
</xsl:if>
<IAExpected>
<xsl:value-of select="fpml:swIAExpected"/>
</IAExpected>
<xsl:if test="fpml:swAllocationReportingDetails[count(fpml:swJurisdiction)=0 and count(fpml:swUniqueTransactionId/fpml:swIssuer)=0]/fpml:swUniqueTransactionId/fpml:swTradeId">
<xsl:variable name="globalUti" select="string(fpml:swAllocationReportingDetails[count(fpml:swJurisdiction)=0 and count(fpml:swUniqueTransactionId/fpml:swIssuer)=0]/fpml:swUniqueTransactionId/fpml:swTradeId)"/>
<GlobalUTI>
<xsl:value-of select="$globalUti"/>
</GlobalUTI>
</xsl:if>
<xsl:if test="$swLongFormTrade/fpml:swAllocations/fpml:swAllocation/fpml:independentAmount">
<xsl:apply-templates select="fpml:independentAmount"/>
</xsl:if>
<xsl:if test="$swLongFormTrade/fpml:swAllocations/fpml:swAllocation/fpml:additionalPayment">
<xsl:call-template name="AllocationAdditionalPayment"/>
</xsl:if>
<xsl:if test="fpml:swPrivateTradeId">
<xsl:apply-templates select="fpml:swPrivateTradeId"/>
</xsl:if>
<xsl:if test="fpml:swSalesCredit">
<xsl:apply-templates select="fpml:swSalesCredit"/>
</xsl:if>
<xsl:if test="fpml:swAdditionalField">
<xsl:apply-templates select="fpml:swAdditionalField"/>
</xsl:if>
<xsl:if test="$swLongFormTrade//fpml:swAllocations/fpml:swAllocation/fpml:swClearingBroker/fpml:partyId">
<xsl:variable name="clearingbroker" select="string(fpml:swClearingBroker/fpml:partyId)"/>
<ClearingBrokerId>
<xsl:value-of select="$clearingbroker"/>
</ClearingBrokerId>
</xsl:if>
<xsl:if test="$swLongFormTrade/fpml:swAllocations/fpml:swAllocation/fpml:swNettingString">
<xsl:variable name="nettingstring" select="string(fpml:swNettingString)"/>
<NettingString>
<xsl:value-of select="$nettingstring"/>
</NettingString>
</xsl:if>
<xsl:if test="fpml:swAllocationReportingDetails[count(fpml:swJurisdiction)=0 or fpml:swJurisdiction='DoddFrank']/fpml:swObligatoryReporting">
<ObligatoryReporting>
<xsl:value-of select="fpml:swAllocationReportingDetails[count(fpml:swJurisdiction)=0 or fpml:swJurisdiction='DoddFrank']/fpml:swObligatoryReporting"/>
</ObligatoryReporting>
</xsl:if>
<xsl:if test="fpml:swAllocationReportingDetails[count(fpml:swJurisdiction)=0 or fpml:swJurisdiction='DoddFrank']/fpml:swReportingCounterpartyReference/@href">
<xsl:variable name="rcp" select="string(fpml:swAllocationReportingDetails[count(fpml:swJurisdiction)=0 or fpml:swJurisdiction='DoddFrank']/fpml:swReportingCounterpartyReference/@href)"/>
<xsl:variable name="rcpBIC" select="string($FpML//fpml:party[@id=$rcp]/fpml:partyId)"/>
<ReportingCounterparty>
<xsl:value-of select="$rcpBIC"/>
</ReportingCounterparty>
</xsl:if>
<xsl:if test="fpml:swAllocationReportingDetails[count(fpml:swJurisdiction)=0 or fpml:swJurisdiction='DoddFrank']/fpml:swUniqueTransactionId/fpml:swIssuer">
<xsl:variable name="usinamespace" select="string(fpml:swAllocationReportingDetails[count(fpml:swJurisdiction)=0 or fpml:swJurisdiction='DoddFrank']/fpml:swUniqueTransactionId/fpml:swIssuer)"/>
<USINamespace>
<xsl:value-of select="$usinamespace"/>
</USINamespace>
</xsl:if>
<xsl:if test="fpml:swAllocationReportingDetails[(count(fpml:swJurisdiction)=0 or fpml:swJurisdiction='DoddFrank') and count(fpml:swUniqueTransactionId/fpml:swIssuer)=1]/fpml:swUniqueTransactionId/fpml:swTradeId">
<xsl:variable name="usi" select="string(fpml:swAllocationReportingDetails[(count(fpml:swJurisdiction)=0 or fpml:swJurisdiction='DoddFrank') and count(fpml:swUniqueTransactionId/fpml:swIssuer)=1]/fpml:swUniqueTransactionId/fpml:swTradeId)"/>
<USI>
<xsl:value-of select="$usi"/>
</USI>
</xsl:if>
<xsl:if test="fpml:swAllocationReportingDetails[fpml:swJurisdiction='ESMA']/fpml:swUniqueTransactionId/fpml:swIssuer">
<xsl:variable name="esutinamespace" select="string(fpml:swAllocationReportingDetails[fpml:swJurisdiction='ESMA']/fpml:swUniqueTransactionId/fpml:swIssuer)"/>
<ESMAUTINamespace>
<xsl:value-of select="$esutinamespace"/>
</ESMAUTINamespace>
<ESMAIntentToBlankUTINamespace>
<xsl:choose>
<xsl:when test="fpml:swAllocationReportingDetails[fpml:swJurisdiction='ESMA']/fpml:swUniqueTransactionId/fpml:swIssuer and $esutinamespace ='' ">
<xsl:value-of select="'true'"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="'false'"/>
</xsl:otherwise>
</xsl:choose>
</ESMAIntentToBlankUTINamespace>
</xsl:if>
<xsl:if test="fpml:swAllocationReportingDetails[fpml:swJurisdiction='ESMA']/fpml:swUniqueTransactionId/fpml:swTradeId">
<xsl:variable name="esuti" select="string(fpml:swAllocationReportingDetails[fpml:swJurisdiction='ESMA']/fpml:swUniqueTransactionId/fpml:swTradeId)"/>
<ESMAUTI>
<xsl:value-of select="$esuti"/>
</ESMAUTI>
<ESMAIntentToBlankUTI>
<xsl:choose>
<xsl:when test="fpml:swAllocationReportingDetails[fpml:swJurisdiction='ESMA']/fpml:swUniqueTransactionId/fpml:swTradeId and $esuti ='' ">
<xsl:value-of select="'true'"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="'false'"/>
</xsl:otherwise>
</xsl:choose>
</ESMAIntentToBlankUTI>
</xsl:if>
<xsl:if test="fpml:swAllocationReportingDetails[fpml:swJurisdiction='ESMA']/fpml:swReportForCounterparty">
<ESMAReportForCpty>
<xsl:value-of select="fpml:swAllocationReportingDetails[fpml:swJurisdiction='ESMA']/fpml:swReportForCounterparty"/>
</ESMAReportForCpty>
</xsl:if>
<xsl:if test="fpml:swAllocationReportingDetails[fpml:swJurisdiction='FCA']/fpml:swUniqueTransactionId/fpml:swIssuer">
<xsl:variable name="fcautinamespace" select="string(fpml:swAllocationReportingDetails[fpml:swJurisdiction='FCA']/fpml:swUniqueTransactionId/fpml:swIssuer)"/>
<FCAUTINamespace>
<xsl:value-of select="$fcautinamespace"/>
</FCAUTINamespace>
<FCAIntentToBlankUTINamespace>
<xsl:choose>
<xsl:when test="fpml:swAllocationReportingDetails[fpml:swJurisdiction='FCA']/fpml:swUniqueTransactionId/fpml:swIssuer and $fcautinamespace ='' ">
<xsl:value-of select="'true'"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="'false'"/>
</xsl:otherwise>
</xsl:choose>
</FCAIntentToBlankUTINamespace>
</xsl:if>
<xsl:if test="fpml:swAllocationReportingDetails[fpml:swJurisdiction='FCA']/fpml:swUniqueTransactionId/fpml:swTradeId">
<xsl:variable name="fcauti" select="string(fpml:swAllocationReportingDetails[fpml:swJurisdiction='FCA']/fpml:swUniqueTransactionId/fpml:swTradeId)"/>
<FCAUTI>
<xsl:value-of select="$fcauti"/>
</FCAUTI>
<FCAIntentToBlankUTI>
<xsl:choose>
<xsl:when test="fpml:swAllocationReportingDetails[fpml:swJurisdiction='FCA']/fpml:swUniqueTransactionId/fpml:swTradeId and $fcauti ='' ">
<xsl:value-of select="'true'"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="'false'"/>
</xsl:otherwise>
</xsl:choose>
</FCAIntentToBlankUTI>
</xsl:if>
<xsl:if test="fpml:swAllocationReportingDetails[fpml:swJurisdiction='FCA']/fpml:swReportForCounterparty">
<FCAReportForCpty>
<xsl:value-of select="fpml:swAllocationReportingDetails[fpml:swJurisdiction='FCA']/fpml:swReportForCounterparty"/>
</FCAReportForCpty>
</xsl:if>
<xsl:if test="fpml:swAllocationReportingDetails[fpml:swJurisdiction='JFSA']/fpml:swUniqueTransactionId/fpml:swIssuer">
<xsl:variable name="jfutinamespace" select="string(fpml:swAllocationReportingDetails[fpml:swJurisdiction='JFSA']/fpml:swUniqueTransactionId/fpml:swIssuer)"/>
<JFSAUTINamespace>
<xsl:value-of select="$jfutinamespace"/>
</JFSAUTINamespace>
<JFSAIntentToBlankUTINamespace>
<xsl:choose>
<xsl:when test="fpml:swAllocationReportingDetails[fpml:swJurisdiction='JFSA']/fpml:swUniqueTransactionId/fpml:swIssuer and $jfutinamespace ='' ">
<xsl:value-of select="'true'"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="'false'"/>
</xsl:otherwise>
</xsl:choose>
</JFSAIntentToBlankUTINamespace>
</xsl:if>
<xsl:if test="fpml:swAllocationReportingDetails[fpml:swJurisdiction='JFSA']/fpml:swUniqueTransactionId/fpml:swTradeId">
<xsl:variable name="jfuti" select="string(fpml:swAllocationReportingDetails[fpml:swJurisdiction='JFSA']/fpml:swUniqueTransactionId/fpml:swTradeId)"/>
<JFSAUTI>
<xsl:value-of select="$jfuti"/>
</JFSAUTI>
<JFSAIntentToBlankUTI>
<xsl:choose>
<xsl:when test="fpml:swAllocationReportingDetails[fpml:swJurisdiction='JFSA']/fpml:swUniqueTransactionId/fpml:swTradeId and $jfuti ='' ">
<xsl:value-of select="'true'"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="'false'"/>
</xsl:otherwise>
</xsl:choose>
</JFSAIntentToBlankUTI>
</xsl:if>
<xsl:if test="fpml:swAllocationReportingDetails[fpml:swJurisdiction='HKMA']/fpml:swUniqueTransactionId/fpml:swIssuer">
<xsl:variable name="hkutinamespace" select="string(fpml:swAllocationReportingDetails[fpml:swJurisdiction='HKMA']/fpml:swUniqueTransactionId/fpml:swIssuer)"/>
<HKMIUTINamespace>
<xsl:value-of select="$hkutinamespace"/>
</HKMIUTINamespace>
<HKMAIntentToBlankUTINamespace>
<xsl:choose>
<xsl:when test="fpml:swAllocationReportingDetails[fpml:swJurisdiction='HKMA']/fpml:swUniqueTransactionId/fpml:swIssuer and $hkutinamespace ='' ">
<xsl:value-of select="'true'"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="'false'"/>
</xsl:otherwise>
</xsl:choose>
</HKMAIntentToBlankUTINamespace>
</xsl:if>
<xsl:if test="fpml:swAllocationReportingDetails[fpml:swJurisdiction='HKMA']/fpml:swUniqueTransactionId/fpml:swTradeId">
<xsl:variable name="hkuti" select="string(fpml:swAllocationReportingDetails[fpml:swJurisdiction='HKMA']/fpml:swUniqueTransactionId/fpml:swTradeId)"/>
<HKMIUTI>
<xsl:value-of select="$hkuti"/>
</HKMIUTI>
<HKMAIntentToBlankUTI>
<xsl:choose>
<xsl:when test="fpml:swAllocationReportingDetails[fpml:swJurisdiction='HKMA']/fpml:swUniqueTransactionId/fpml:swTradeId and $hkuti ='' ">
<xsl:value-of select="'true'"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="'false'"/>
</xsl:otherwise>
</xsl:choose>
</HKMAIntentToBlankUTI>
</xsl:if>
<xsl:if test="fpml:swAllocationReportingDetails[fpml:swJurisdiction='CAN']/fpml:swObligatoryReporting">
<CAObligatoryReporting>
<xsl:value-of select="fpml:swAllocationReportingDetails[fpml:swJurisdiction='CAN']/fpml:swObligatoryReporting"/>
</CAObligatoryReporting>
</xsl:if>
<xsl:if test="fpml:swAllocationReportingDetails[fpml:swJurisdiction='CAN']/fpml:swReportingCounterpartyReference/@href">
<xsl:variable name="rcp" select="string(fpml:swAllocationReportingDetails[fpml:swJurisdiction='CAN']/fpml:swReportingCounterpartyReference/@href)"/>
<xsl:variable name="rcpBIC" select="string($FpML//fpml:party[@id=$rcp]/fpml:partyId)"/>
<CAReportingCounterparty>
<xsl:value-of select="$rcpBIC"/>
</CAReportingCounterparty>
</xsl:if>
<xsl:if test="fpml:swAllocationReportingDetails[fpml:swJurisdiction='CAN']/fpml:swUniqueTransactionId/fpml:swIssuer">
<xsl:variable name="cautinamespace" select="string(fpml:swAllocationReportingDetails[fpml:swJurisdiction='CAN']/fpml:swUniqueTransactionId/fpml:swIssuer)"/>
<CAUTINamespace>
<xsl:value-of select="$cautinamespace"/>
</CAUTINamespace>
<CAIntentToBlankUTINamespace>
<xsl:choose>
<xsl:when test="fpml:swAllocationReportingDetails[fpml:swJurisdiction='CAN']/fpml:swUniqueTransactionId/fpml:swIssuer and $cautinamespace ='' ">
<xsl:value-of select="'true'"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="'false'"/>
</xsl:otherwise>
</xsl:choose>
</CAIntentToBlankUTINamespace>
</xsl:if>
<xsl:if test="fpml:swAllocationReportingDetails[fpml:swJurisdiction='CAN']/fpml:swUniqueTransactionId/fpml:swTradeId">
<xsl:variable name="cauti" select="string(fpml:swAllocationReportingDetails[fpml:swJurisdiction='CAN']/fpml:swUniqueTransactionId/fpml:swTradeId)"/>
<CAUTI>
<xsl:value-of select="$cauti"/>
</CAUTI>
<CAIntentToBlankUTI>
<xsl:choose>
<xsl:when test="fpml:swAllocationReportingDetails[fpml:swJurisdiction='CAN']/fpml:swUniqueTransactionId/fpml:swTradeId and $cauti ='' ">
<xsl:value-of select="'true'"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="'false'"/>
</xsl:otherwise>
</xsl:choose>
</CAIntentToBlankUTI>
</xsl:if>
<xsl:if test="fpml:swAllocationReportingDetails[fpml:swJurisdiction='MIFID']/fpml:swObligatoryReporting">
<MIObligatoryReporting>
<xsl:value-of select="fpml:swAllocationReportingDetails[fpml:swJurisdiction='MIFID']/fpml:swObligatoryReporting"/>
</MIObligatoryReporting>
</xsl:if>
<xsl:if test="fpml:swAllocationReportingDetails[fpml:swJurisdiction='MIFID']/fpml:swReportingCounterpartyReference/@href">
<xsl:variable name="rcp" select="string(fpml:swAllocationReportingDetails[fpml:swJurisdiction='MIFID']/fpml:swReportingCounterpartyReference/@href)"/>
<xsl:choose>
<xsl:when test="$rcp = 'venue' or $rcp = '#venue'">
<MIReportingCounterparty>
<xsl:value-of select="'venue'"/>
</MIReportingCounterparty>
</xsl:when>
<xsl:otherwise>
<xsl:variable name="rcpBIC" select="string($FpML//fpml:party[@id=$rcp]/fpml:partyId)"/>
<MIReportingCounterparty>
<xsl:value-of select="$rcpBIC"/>
</MIReportingCounterparty>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="fpml:swAllocationReportingDetails[fpml:swJurisdiction='MIFID']/fpml:swMIFIDTransactionIdentifier">
<xsl:variable name="mitid" select="string(fpml:swAllocationReportingDetails[fpml:swJurisdiction='MIFID']/fpml:swMIFIDTransactionIdentifier)"/>
<MITID>
<xsl:value-of select="$mitid"/>
</MITID>
<MIIntentToBlankTID>
<xsl:choose>
<xsl:when test="fpml:swAllocationReportingDetails[fpml:swJurisdiction='MIFID']/fpml:swMIFIDTransactionIdentifier and $mitid ='' ">
<xsl:value-of select="'true'"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="'false'"/>
</xsl:otherwise>
</xsl:choose>
</MIIntentToBlankTID>
</xsl:if>
<xsl:if test="fpml:swAllocationReportingDetails[fpml:swJurisdiction='MIFID']/fpml:swRegulatoryReportable">
<MITransactionReportable>
<xsl:value-of select="fpml:swAllocationReportingDetails[fpml:swJurisdiction='MIFID']/fpml:swRegulatoryReportable"/>
</MITransactionReportable>
</xsl:if>
<xsl:if test="fpml:swAllocationReportingDetails[fpml:swJurisdiction='MIFID']/fpml:swTransparencyReportable">
<MITransparencyReportable>
<xsl:value-of select="fpml:swAllocationReportingDetails[fpml:swJurisdiction='MIFID']/fpml:swTransparencyReportable"/>
</MITransparencyReportable>
</xsl:if>
<xsl:if test="fpml:swAllocationReportingDetails[fpml:swJurisdiction='ASIC']/fpml:swUniqueTransactionId/fpml:swIssuer">
<xsl:variable name="asutinamespace" select="string(fpml:swAllocationReportingDetails[fpml:swJurisdiction='ASIC']/fpml:swUniqueTransactionId/fpml:swIssuer)"/>
<ASICUTINamespace>
<xsl:value-of select="$asutinamespace"/>
</ASICUTINamespace>
<ASICIntentToBlankUTINamespace>
<xsl:choose>
<xsl:when test="fpml:swAllocationReportingDetails[fpml:swJurisdiction='ASIC']/fpml:swUniqueTransactionId/fpml:swIssuer and $asutinamespace ='' ">
<xsl:value-of select="'true'"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="'false'"/>
</xsl:otherwise>
</xsl:choose>
</ASICIntentToBlankUTINamespace>
</xsl:if>
<xsl:if test="fpml:swAllocationReportingDetails[fpml:swJurisdiction='ASIC']/fpml:swUniqueTransactionId/fpml:swTradeId">
<xsl:variable name="asuti" select="string(fpml:swAllocationReportingDetails[fpml:swJurisdiction='ASIC']/fpml:swUniqueTransactionId/fpml:swTradeId)"/>
<ASICUTI>
<xsl:value-of select="$asuti"/>
</ASICUTI>
<ASICIntentToBlankUTI>
<xsl:choose>
<xsl:when test="fpml:swAllocationReportingDetails[fpml:swJurisdiction='ASIC']/fpml:swUniqueTransactionId/fpml:swTradeId and $asuti ='' ">
<xsl:value-of select="'true'"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="'false'"/>
</xsl:otherwise>
</xsl:choose>
</ASICIntentToBlankUTI>
</xsl:if>
<xsl:if test="fpml:swAllocationReportingDetails[fpml:swJurisdiction='MAS']/fpml:swUniqueTransactionId/fpml:swIssuer">
<xsl:variable name="masutinamespace" select="string(fpml:swAllocationReportingDetails[fpml:swJurisdiction='MAS']/fpml:swUniqueTransactionId/fpml:swIssuer)"/>
<MASUTINamespace>
<xsl:value-of select="$masutinamespace"/>
</MASUTINamespace>
<MASIntentToBlankUTINamespace>
<xsl:choose>
<xsl:when test="fpml:swAllocationReportingDetails[fpml:swJurisdiction='MAS']/fpml:swUniqueTransactionId/fpml:swIssuer and $masutinamespace ='' ">
<xsl:value-of select="'true'"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="'false'"/>
</xsl:otherwise>
</xsl:choose>
</MASIntentToBlankUTINamespace>
</xsl:if>
<xsl:if test="fpml:swAllocationReportingDetails[fpml:swJurisdiction='MAS']/fpml:swUniqueTransactionId/fpml:swTradeId">
<xsl:variable name="masuti" select="string(fpml:swAllocationReportingDetails[fpml:swJurisdiction='MAS']/fpml:swUniqueTransactionId/fpml:swTradeId)"/>
<MASUTI>
<xsl:value-of select="$masuti"/>
</MASUTI>
<MASIntentToBlankUTI>
<xsl:choose>
<xsl:when test="fpml:swAllocationReportingDetails[fpml:swJurisdiction='MAS']/fpml:swUniqueTransactionId/fpml:swTradeId and $masuti ='' ">
<xsl:value-of select="'true'"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="'false'"/>
</xsl:otherwise>
</xsl:choose>
</MASIntentToBlankUTI>
</xsl:if>
<xsl:apply-templates select="$swLongFormTrade/fpml:swAllocations/fpml:swAllocation/fpml:swClearingDetails"/>
<xsl:if test="fpml:swIdentifiers">
<PartyIdentifiers>
<xsl:if test="fpml:swIdentifiers/fpml:swPartyIdentifiers/fpml:swCounterpartyLEI">
<CounterpartyLEI><xsl:value-of select="fpml:swIdentifiers/fpml:swPartyIdentifiers/fpml:swCounterpartyLEI"/></CounterpartyLEI>
</xsl:if>
<xsl:if test="fpml:swIdentifiers/fpml:swPartyIdentifiers/fpml:swCounterpartyPLI">
<CounterpartyPLI><xsl:value-of select="fpml:swIdentifiers/fpml:swPartyIdentifiers/fpml:swCounterpartyPLI"/></CounterpartyPLI>
</xsl:if>
<xsl:if test="fpml:swIdentifiers/fpml:swPartyIdentifiers/fpml:swDataMaskingFlag">
<xsl:variable name="dataMaskingFlag" select="fpml:swIdentifiers/fpml:swPartyIdentifiers/fpml:swDataMaskingFlag"/>
<DataMaskingFlag>
<xsl:if test="$dataMaskingFlag/fpml:swMaskCFTC">
<MaskCFTC><xsl:value-of select="$dataMaskingFlag/fpml:swMaskCFTC"/></MaskCFTC>
</xsl:if>
<xsl:if test="$dataMaskingFlag/fpml:swMaskJFSA">
<MaskJFSA><xsl:value-of select="$dataMaskingFlag/fpml:swMaskJFSA"/></MaskJFSA>
</xsl:if>
<xsl:if test="$dataMaskingFlag/fpml:swMaskCanada">
<MaskCanada><xsl:value-of select="$dataMaskingFlag/fpml:swMaskCanada"/></MaskCanada>
</xsl:if>
<xsl:if test="$dataMaskingFlag/fpml:swMaskHKMA">
<MaskHKMA><xsl:value-of select="$dataMaskingFlag/fpml:swMaskHKMA"/></MaskHKMA>
</xsl:if>
<xsl:if test="$dataMaskingFlag/fpml:swMaskASIC">
<MaskASIC><xsl:value-of select="$dataMaskingFlag/fpml:swMaskASIC"/></MaskASIC>
</xsl:if>
<xsl:if test="$dataMaskingFlag/fpml:swMaskMAS">
<MaskMAS><xsl:value-of select="$dataMaskingFlag/fpml:swMaskMAS"/></MaskMAS>
</xsl:if>
</DataMaskingFlag>
</xsl:if>
</PartyIdentifiers>
</xsl:if>
<xsl:if test="fpml:swNexusReportingDetails">
<xsl:variable name="nexusParentNode.rtf">
<xsl:apply-templates select="fpml:swNexusReportingDetails/node()" mode="mapReportingData"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="function-available('common:node-set')">
<xsl:call-template name="AllocationNexusFields">
<xsl:with-param name="nexusNode" select="common:node-set($nexusParentNode.rtf)"/>
</xsl:call-template>
</xsl:when>
<xsl:otherwise>
<xsl:call-template name="AllocationNexusFields">
<xsl:with-param name="nexusNode" select="nexusParentNode.rtf"/>
</xsl:call-template>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="fpml:swCounterpartyCorporateSector">
<CounterpartyCorporateSector>
<xsl:value-of select="fpml:swCounterpartyCorporateSector"/>
</CounterpartyCorporateSector>
</xsl:if>
</Allocation>
</xsl:template>
<xsl:template match="fpml:independentAmount">
<IndependentAmount>
<xsl:variable name="amount" select="string(fpml:paymentDetail/fpml:paymentAmount/fpml:amount)"/>
<Amount>
<xsl:value-of select="$amount"/>
</Amount>
</IndependentAmount>
</xsl:template>
<xsl:template name="AllocationAdditionalPayment">
<xsl:for-each select="fpml:additionalPayment">
<xsl:choose>
<xsl:when test="fpml:paymentType='CancellablePremium'">
<xsl:variable name="amount" select="string(fpml:paymentAmount/fpml:amount)"/>
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
<xsl:variable name="amount" select="string(fpml:paymentAmount/fpml:amount)"/>
<Amount>
<xsl:value-of select="$amount"/>
</Amount>
</AllocAdditionalPayment>
</xsl:otherwise>
</xsl:choose>
</xsl:for-each>
</xsl:template>
<xsl:template match="fpml:swPrivateTradeId">
<InternalTradeId>
<xsl:variable name="value" select="string(.)"/>
<xsl:value-of select="$value"/>
</InternalTradeId>
</xsl:template>
<xsl:template match="fpml:swSalesCredit">
<SalesCredit>
<xsl:variable name="amount" select="string(.)"/>
<xsl:value-of select="$amount"/>
</SalesCredit>
</xsl:template>
<xsl:template match="fpml:swAdditionalField">
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
<xsl:template name="formatStubAt">
<xsl:param name="stubAt"/>
<xsl:variable name="pos">
<xsl:choose>
<xsl:when test="starts-with($stubAt,'Short')">
<xsl:value-of select="substring-after($stubAt,'Short')"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="substring-after($stubAt,'Long')"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:choose>
<xsl:when test="$pos='Initial'">Start</xsl:when>
<xsl:when test="$pos='Final'">End</xsl:when>
<xsl:otherwise>???</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template name="formatStubLen">
<xsl:param name="stubLen"/>
<xsl:choose>
<xsl:when test="starts-with($stubLen,'Short')">Short</xsl:when>
<xsl:when test="starts-with($stubLen,'Long')">Long</xsl:when>
<xsl:otherwise>???</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template name="formatInterval">
<xsl:param name="interval" select="."/>
<xsl:value-of select="$interval/fpml:periodMultiplier"/>
<xsl:value-of select="$interval/fpml:period"/>
</xsl:template>
</xsl:stylesheet>
