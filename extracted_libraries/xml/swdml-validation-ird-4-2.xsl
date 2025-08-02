<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fpml="http://www.fpml.org/2005/FpML-4-2" xmlns:common="http://exslt.org/common" exclude-result-prefixes="fpml common" version="1.0">
<xsl:import href="CrossAssetValidation.xsl"/>
<xsl:import href="swdml-validation-reporting.xsl"/>
<xsl:variable name="SWDML" select="/fpml:SWDML"/>
<xsl:variable name="swLongFormTrade"           select="$SWDML/fpml:swLongFormTrade"/>
<xsl:variable name="swShortFormTrade"          select="$SWDML/fpml:swShortFormTrade"/>
<xsl:variable name="swStructuredTradeDetails"  select="$swLongFormTrade/fpml:swStructuredTradeDetails"/>
<xsl:variable name="swExtendedTradeDetails"    select="$swStructuredTradeDetails/fpml:swExtendedTradeDetails"/>
<xsl:variable name="swTradeHeader"             select="$swExtendedTradeDetails/fpml:swTradeHeader"/>
<xsl:variable name="swClearingTakeup"          select="$swTradeHeader/fpml:swClearingTakeup"/>
<xsl:variable name="FpML"                      select="$swStructuredTradeDetails/fpml:FpML"/>
<xsl:variable name="trade"                     select="$FpML/fpml:trade"/>
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
<xsl:variable name="clearingTakeupOriginatingEvent">
<xsl:choose>
<xsl:when test="$swClearingTakeup/fpml:swOriginatingEvent">
<xsl:value-of select="$swClearingTakeup/fpml:swOriginatingEvent"/>
</xsl:when>
<xsl:otherwise>NONE</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="isTransitionEvent">
<xsl:choose>
<xsl:when test="($clearingTakeupOriginatingEvent = 'Conversion' or $clearingTakeupOriginatingEvent = 'Risk Compensation' or $clearingTakeupOriginatingEvent = 'Cash Compensation')">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="reportingData.rtf">
<xsl:apply-templates select="$SWDML/fpml:swTradeEventReportingDetails" mode="mapReportingData"/>
<xsl:apply-templates select="$swLongFormTrade/fpml:swAllocations/node()" mode="mapReportingData"/>
<xsl:apply-templates select="$swLongFormTrade/fpml:novation/fpml:swNovationExecutionUniqueTransactionId" mode="mapReportingData"/>
</xsl:variable>
<xsl:template match="fpml:swAllocation" mode="mapReportingData">
<swAllocation>
<xsl:apply-templates select="fpml:swAllocationReportingDetails" mode="mapReportingData"/>
</swAllocation>
</xsl:template>
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
<xsl:apply-templates select="$SWDML" mode="get-reporting-data"/>
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
<xsl:variable name="version" select="$SWDML/@version"/>
<xsl:variable name="assetClass">Rates</xsl:variable>
<xsl:variable name="productType">
<xsl:choose>
<xsl:when test="$swShortFormTrade/fpml:swFraParameters">FRA</xsl:when>
<xsl:when test="$swShortFormTrade/fpml:swOisParameters">OIS</xsl:when>
<xsl:when test="$swShortFormTrade/fpml:swIrsParameters">IRS</xsl:when>
<xsl:when test="$swShortFormTrade/fpml:swSwaptionParameters">Swaption</xsl:when>
<xsl:when test="$swShortFormTrade/fpml:swCapFloorParameters">CapFloor</xsl:when>
<xsl:when test="$swShortFormTrade/fpml:swZCInflationSwapParameters">ZCInflationSwap</xsl:when>
<xsl:when test="$swShortFormTrade/fpml:swBasisSwapParameters">Single Currency Basis Swap</xsl:when>
<xsl:when test="$swStructuredTradeDetails[fpml:swProductType='SingleCurrencyInterestRateSwap']">IRS</xsl:when>
<xsl:when test="$swStructuredTradeDetails[fpml:swProductType='ZC Inflation Swap']">ZCInflationSwap</xsl:when>
<xsl:when test="$swShortFormTrade/fpml:swFixedFixedParameters">Fixed Fixed Swap</xsl:when>
<xsl:when test="$swShortFormTrade/fpml:swCrossCurrencyBasisSwapParameters">Cross Currency Basis Swap</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$swStructuredTradeDetails/fpml:swProductType"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="FpMLVersion">
<xsl:value-of select="$FpML/@version"/>
</xsl:variable>
<xsl:variable name="docsType">
<xsl:value-of select="$trade//fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType"/>
</xsl:variable>
<xsl:variable name="productSubType">
<xsl:choose>
<xsl:when test="$swShortFormTrade and ($productType='IRS' or $productType='Fixed Fixed Swap' or $productType='OIS')">
<xsl:value-of select="$swShortFormTrade//fpml:swProductSubType"/>
</xsl:when>
</xsl:choose>
</xsl:variable>
<xsl:variable name="fixedLeg">
<xsl:choose>
<xsl:when test="$productType='Cross Currency Basis Swap' or $productType='Single Currency Basis Swap'">0</xsl:when>
<xsl:when test="$productType='ZCInflationSwap'">
<xsl:choose>
<xsl:when test="$trade//fpml:swap/fpml:swapStream[1]/fpml:calculationPeriodAmount/fpml:calculation/fpml:inflationRateCalculation">2</xsl:when>
<xsl:otherwise>1</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:otherwise>
<xsl:choose>
<xsl:when test="$trade//fpml:swap/fpml:swapStream[1]/fpml:resetDates or ($productType='OIS' and $trade//fpml:swap/fpml:swapStream[1]/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters)">2</xsl:when>
<xsl:otherwise>1</xsl:otherwise>
</xsl:choose>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="fixedLeg2">
<xsl:if test="$productType='Fixed Fixed Swap'">
<xsl:choose>
<xsl:when test="$trade//fpml:swap/fpml:swapStream[1][@id='fixedLeg2']">2</xsl:when>
<xsl:otherwise>2</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:variable>
<xsl:variable name="floatingLeg">
<xsl:choose>
<xsl:when test="$productType='CapFloor'">1</xsl:when>
<xsl:when test="$productType='ZCInflationSwap'">
<xsl:choose>
<xsl:when test="$trade//fpml:swap/fpml:swapStream[1]/fpml:calculationPeriodAmount/fpml:calculation/fpml:inflationRateCalculation">1</xsl:when>
<xsl:otherwise>2</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap'">
<xsl:choose>
<xsl:when test="$trade//fpml:swap/fpml:swapStream[1][@id='floatingLeg']">1</xsl:when>
<xsl:otherwise>2</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:otherwise>
<xsl:choose>
<xsl:when test="$trade//fpml:swap/fpml:swapStream[1]/fpml:resetDates or ($productType='OIS' and $trade//fpml:swap/fpml:swapStream[1]/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters)">1</xsl:when>
<xsl:otherwise>2</xsl:otherwise>
</xsl:choose>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="floatingLeg2">
<xsl:if test="$productType='Cross Currency Basis Swap' or $productType='Single Currency Basis Swap'">
<xsl:choose>
<xsl:when test="$trade//fpml:swap/fpml:swapStream[1][@id='floatingLeg2']">1</xsl:when>
<xsl:otherwise>2</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:variable>
<xsl:variable name="tradeCurrency">
<xsl:choose>
<xsl:when test="$swShortFormTrade">
<xsl:value-of select="$swShortFormTrade//fpml:notional/fpml:currency"/>
</xsl:when>
<xsl:when test="$productType='Cross Currency IRS'">
<xsl:value-of select="$trade//fpml:swap/fpml:swapStream[position()=$fixedLeg]/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:currency"/>
</xsl:when>
<xsl:when test="$productType='Fixed Fixed Swap'">
<xsl:value-of select="$trade//fpml:swap/fpml:swapStream[position()=$fixedLeg]/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:currency"/>
<xsl:value-of select="$trade//fpml:swap/fpml:swapStream[position()=$fixedLeg]/fpml:calculationPeriodAmount/fpml:knownAmountSchedule/fpml:currency"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:currency"/>
<xsl:value-of select="$trade//fpml:fra/fpml:notional/fpml:currency"/>
<xsl:value-of select="$trade//fpml:capFloor/fpml:capFloorStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:currency"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="tradeCurrency2">
<xsl:choose>
<xsl:when test="$productType='Fixed Fixed Swap'">
<xsl:value-of select="$trade//fpml:swap/fpml:swapStream[position()=$fixedLeg2]/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:currency"/>
<xsl:value-of select="$trade//fpml:swap/fpml:swapStream[position()=$fixedLeg2]/fpml:calculationPeriodAmount/fpml:knownAmountSchedule/fpml:currency"/>
<xsl:value-of select="$swShortFormTrade//fpml:swNotional2/fpml:currency"/>
</xsl:when>
<xsl:when test="$productType='Cross Currency IRS'">
<xsl:value-of select="$trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:currency"/>
<xsl:value-of select="$trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodAmount/fpml:calculation/fpml:fxLinkedNotionalSchedule/fpml:varyingNotionalCurrency"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$trade//fpml:swap/fpml:swapStream[position()=$floatingLeg2]/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:currency"/>
<xsl:value-of select="$trade//fpml:swap/fpml:swapStream[position()=$floatingLeg2]/fpml:calculationPeriodAmount/fpml:calculation/fpml:fxLinkedNotionalSchedule/fpml:varyingNotionalCurrency"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="isOIScurrency">
<xsl:choose>
<xsl:when test="($tradeCurrency='AUD' or $tradeCurrency='CAD' or $tradeCurrency='CHF' or $tradeCurrency='COP' or $tradeCurrency='DKK' or $tradeCurrency='EUR' or $tradeCurrency='GBP' or $tradeCurrency='HKD' or $tradeCurrency='ILS' or $tradeCurrency='INR' or $tradeCurrency='JPY' or $tradeCurrency='MYR' or $tradeCurrency='NOK' or $tradeCurrency='NZD' or $tradeCurrency='PLN' or $tradeCurrency='RUB' or $tradeCurrency='SEK' or $tradeCurrency='SGD' or  $tradeCurrency='THB' or $tradeCurrency='TRY' or $tradeCurrency='USD')">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="isOISIndex">
<xsl:variable name="friValue">
<xsl:value-of select="//fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:floatingRateIndex | $swShortFormTrade/fpml:swSwaptionParameters/fpml:floatingRateIndex | //fpml:capFloorStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:floatingRateIndex"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="(string-length(substring-before($friValue,'-OIS')) > 0) or ($friValue='GBP-SONIA-COMPOUND' or $friValue='USD-DTCC GCF Repo Index-Treasury-Bloomberg-COMPOUND' or $friValue='USD-SOFR-COMPOUND' or $friValue='EUR-EuroSTR-COMPOUND' or $friValue='SGD-SORA-COMPOUND' or $friValue='GBP-WMBA-SONIA-COMPOUND' or $friValue='GBP-WMBA-RONIA-COMPOUND' or $friValue='THB-THOR-COMPOUND' or $friValue='GBP-SONIA' or $friValue='USD-SOFR' or $friValue='EUR-EuroSTR' or $friValue='CHF-SARON' or $friValue='JPY-TONA' or $friValue='SGD-SORA' or $friValue='HKD-HONIA' or $friValue='AUD-AONIA' or $friValue='CAD-CORRA' or $friValue='GBP-RONIA' or $friValue='NOK-NOWA' or $friValue='NZD-NZIONA' or $friValue='PLN-POLONIA' or $friValue='PLN-WIRON' or $friValue='THB-THOR' or $friValue='SEK-SWESTR' or $friValue='DKK-DESTR' or $friValue='RUB-RUONIA' or $friValue='ILS-SHIR' or $friValue='MYR-MYOR')">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="isCompoundingEnabledIndex">
<xsl:variable name="compoundingfriValue">
<xsl:value-of select="//fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:floatingRateIndex | $swShortFormTrade/fpml:swOisParameter/fpml:floatingRateIndex | $swShortFormTrade/fpml:swBasisSwapParameters/fpml:floatingRateIndex"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="($compoundingfriValue='GBP-SONIA' or  $compoundingfriValue='USD-SOFR' or $compoundingfriValue='EUR-EuroSTR' or $compoundingfriValue='SGD-SORA' or $compoundingfriValue='GBP-SONIA' or $compoundingfriValue='GBP-RONIA' or $compoundingfriValue='THB-THOR' or $compoundingfriValue='CHF-SARON' or $compoundingfriValue='JPY-TONA' or $compoundingfriValue='HKD-HONIA' or $compoundingfriValue='AUD-AONIA' or $compoundingfriValue='CAD-CORRA' or $compoundingfriValue='NOK-NOWA' or $compoundingfriValue='NZD-NZIONA' or  $compoundingfriValue='PLN-POLONIA' or $compoundingfriValue='PLN-WIRON' or  $compoundingfriValue='SEK-SWESTR' or $compoundingfriValue='DKK-DESTR' or $compoundingfriValue='RUB-RUONIA' or $compoundingfriValue='ILS-SHIR' or $compoundingfriValue='MYR-MYOR')">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="isCompoundingEnabledIndex2">
<xsl:variable name="compoundingfriValue2">
<xsl:value-of select="//fpml:swapStream[position()=$floatingLeg2]/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:floatingRateIndex | $swShortFormTrade/fpml:swBasisSwapParameters/fpml:floatingRateIndex"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="($compoundingfriValue2='GBP-SONIA' or  $compoundingfriValue2='USD-SOFR' or
$compoundingfriValue2='EUR-EuroSTR' or $compoundingfriValue2='SGD-SORA' or $compoundingfriValue2='GBP-SONIA' or
$compoundingfriValue2='GBP-RONIA' or $compoundingfriValue2='THB-THOR' or $compoundingfriValue2='CHF-SARON' or
$compoundingfriValue2='JPY-TONA' or $compoundingfriValue2='HKD-HONIA' or $compoundingfriValue2='AUD-AONIA' or
$compoundingfriValue2='CAD-CORRA' or $compoundingfriValue2='NOK-NOWA' or $compoundingfriValue2='NZD-NZIONA' or
$compoundingfriValue2='PLN-POLONIA' or  $compoundingfriValue2='PLN-WIRON' or $compoundingfriValue2='SEK-SWESTR' or $compoundingfriValue2='DKK-DESTR' or $compoundingfriValue2='RUB-RUONIA' or $compoundingfriValue2='ILS-SHIR' or $compoundingfriValue2='MYR-MYOR')">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="isOISonSwaption">
<xsl:choose>
<xsl:when test="$productType='Swaption' and $isOIScurrency='true' and $isOISIndex='true'">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="isOISonCapFloor">
<xsl:choose>
<xsl:when test="$productType='CapFloor' and $isOIScurrency='true' and $isOISIndex='true'">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="MarkToMarket">
<xsl:choose>
<xsl:when test="$trade//fpml:swap/fpml:swapStream[position()=$floatingLeg2]/fpml:calculationPeriodAmount/fpml:calculation/fpml:fxLinkedNotionalSchedule">true</xsl:when>
<xsl:when test="$trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodAmount/fpml:calculation/fpml:fxLinkedNotionalSchedule">true</xsl:when>
<xsl:when test="$productType='Cross Currency Basis Swap' and $swShortFormTrade and $swShortFormTrade//fpml:principalExchanges/fpml:intermediateExchange='true'">true</xsl:when>
<xsl:when test="$productType='Fixed Fixed Swap' and $swShortFormTrade and $swShortFormTrade//fpml:principalExchanges/fpml:intermediateExchange='true'">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="fixedPaymentFreq">
<xsl:value-of select="$trade//fpml:swap/fpml:swapStream[position()=$fixedLeg]/fpml:paymentDates/fpml:paymentFrequency/fpml:periodMultiplier"/>
<xsl:value-of select="$trade//fpml:swap/fpml:swapStream[position()=$fixedLeg]/fpml:paymentDates/fpml:paymentFrequency/fpml:period"/>
</xsl:variable>
<xsl:variable name="fixedPaymentFreq2">
<xsl:value-of select="$trade//fpml:swap/fpml:swapStream[position()=$fixedLeg2]/fpml:paymentDates/fpml:paymentFrequency/fpml:periodMultiplier"/>
<xsl:value-of select="$trade//fpml:swap/fpml:swapStream[position()=$fixedLeg2]/fpml:paymentDates/fpml:paymentFrequency/fpml:period"/>
</xsl:variable>
<xsl:variable name="floatPaymentFreq">
<xsl:value-of select="$trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:paymentDates/fpml:paymentFrequency/fpml:periodMultiplier"/>
<xsl:value-of select="$trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:paymentDates/fpml:paymentFrequency/fpml:period"/>
</xsl:variable>
<xsl:variable name="FixedAmount">
<xsl:if test="$trade//fpml:swap/fpml:swapStream[position()=$fixedLeg]/fpml:calculationPeriodAmount/fpml:knownAmountSchedule">
<xsl:value-of select="$trade//fpml:swap/fpml:swapStream[position()=$fixedLeg]/fpml:calculationPeriodAmount/fpml:knownAmountSchedule/fpml:initialValue"/>
</xsl:if>
</xsl:variable>
<xsl:variable name="FixedAmount2">
<xsl:if test="$trade//fpml:swap/fpml:swapStream[position()=$fixedLeg2]/fpml:calculationPeriodAmount/fpml:knownAmountSchedule">
<xsl:value-of select="$trade//fpml:swap/fpml:swapStream[position()=$fixedLeg2]/fpml:calculationPeriodAmount/fpml:knownAmountSchedule/fpml:initialValue"/>
</xsl:if>
</xsl:variable>
<xsl:variable name="FixedNotional">
<xsl:if test="$trade//fpml:swap/fpml:swapStream[position()=$fixedLeg]/fpml:calculationPeriodAmount/fpml:calculation">
<xsl:value-of select="$trade//fpml:swap/fpml:swapStream[position()=$fixedLeg]/fpml:calculationPeriodAmount/fpml:calculation/fpml:initialValue"/>
</xsl:if>
</xsl:variable>
<xsl:variable name="FixedNotional2">
<xsl:if test="$trade//fpml:swap/fpml:swapStream[position()=$fixedLeg2]/fpml:calculationPeriodAmount/fpml:calculation">
<xsl:value-of select="$trade//fpml:swap/fpml:swapStream[position()=$fixedLeg2]/fpml:calculationPeriodAmount/fpml:calculation/fpml:initialValue"/>
</xsl:if>
</xsl:variable>
<xsl:variable name="interestRateSwapType">
<xsl:choose>
<xsl:when test="(($productType='IRS' or $productType='OIS' or $isOISonSwaption='true') and $fixedPaymentFreq = '1T' and $trade//fpml:swap/fpml:swapStream[position()=$fixedLeg]/fpml:calculationPeriodAmount/fpml:knownAmountSchedule and $trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodAmount/fpml:calculation )">
<xsl:value-of select="'zeroCouponInterestRateSwapWithFixedAmount'"/>
</xsl:when>
<xsl:when test="(($productType='IRS' or $productType='OIS' or $isOISonSwaption='true') and $fixedPaymentFreq = '1T' and $trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodAmount/fpml:calculation and $trade//fpml:swap/fpml:swapStream[position()=$fixedLeg]/fpml:calculationPeriodAmount/fpml:calculation)">
<xsl:value-of select="'zeroCouponInterestRateSwapWithFixedNotional'"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="'fpml:someOtherInterestRateProduct'"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="interestRateSwapFloatingLegType">
<xsl:choose>
<xsl:when test="(($productType='IRS' or $productType='OIS' or $isOISonSwaption='true') and $floatPaymentFreq = '1T' )">
<xsl:value-of select="'zeroCouponInterestRateSwapFloatingLeg'"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="'aNonZCIRSFloatingLeg'"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="isZeroCouponFixedFixedSwap">
<xsl:choose>
<xsl:when test="($productType='Fixed Fixed Swap' and ($fixedPaymentFreq = '1T' or $fixedPaymentFreq2 = '1T'))">
<xsl:value-of select="'true'"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="'false'"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="isZeroCouponFixedFixedSwap_L1">
<xsl:choose>
<xsl:when test="($productType='Fixed Fixed Swap' and ($fixedPaymentFreq = '1T'))">
<xsl:value-of select="'true'"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="'false'"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="isZeroCouponFixedFixedSwap_L2">
<xsl:choose>
<xsl:when test="($productType='Fixed Fixed Swap' and ($fixedPaymentFreq2 = '1T'))">
<xsl:value-of select="'true'"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="'false'"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="isZeroCouponInterestRateSwap">
<xsl:choose>
<xsl:when test="($interestRateSwapType='zeroCouponInterestRateSwapWithFixedAmount' or $interestRateSwapType='zeroCouponInterestRateSwapWithFixedNotional')">
<xsl:value-of select="'true'"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="'false'"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="participantSupplement">
<xsl:choose>
<xsl:when test="$swShortFormTrade">
<xsl:value-of select="$swShortFormTrade/fpml:swParticipantSupplement"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$swStructuredTradeDetails/fpml:swParticipantSupplement"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="isLongFormTrade">
<xsl:choose>
<xsl:when test="$swLongFormTrade">1</xsl:when>
<xsl:otherwise>0</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="isPrimeBrokerTrade">
<xsl:choose>
<xsl:when test="$SWDML//fpml:swGiveUp">1</xsl:when>
<xsl:otherwise>0</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="isNovationTrade">
<xsl:choose>
<xsl:when test="$SWDML//fpml:novation">1</xsl:when>
<xsl:otherwise>0</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="isAllocatedTrade">
<xsl:choose>
<xsl:when test="$SWDML//fpml:swAllocations">1</xsl:when>
<xsl:otherwise>0</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="blockAdditionalPaymentCount">
<xsl:value-of select="count($swStructuredTradeDetails//fpml:additionalPayment)"/>
</xsl:variable>
<xsl:variable name="isBlockIndependentAmountPresent">
<xsl:if test="$swStructuredTradeDetails//fpml:collateral">true</xsl:if>
</xsl:variable>
<xsl:variable name="test1">
<xsl:choose>
<xsl:when test="$swStructuredTradeDetails//fpml:additionalPayment[position()=1] and (not($swStructuredTradeDetails//fpml:additionalPayment[position()=1]/fpml:paymentType))">1</xsl:when>
<xsl:otherwise>0</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="test2">
<xsl:choose>
<xsl:when test="$swStructuredTradeDetails//fpml:additionalPayment[position()=2] and (not($swStructuredTradeDetails//fpml:additionalPayment[position()=2]/fpml:paymentType))">1</xsl:when>
<xsl:otherwise>0</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="test3">
<xsl:choose>
<xsl:when test="$swStructuredTradeDetails//fpml:additionalPayment[position()=3] and (not($swStructuredTradeDetails//fpml:additionalPayment[position()=3]/fpml:paymentType))">1</xsl:when>
<xsl:otherwise>0</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="test4">
<xsl:choose>
<xsl:when test="$swStructuredTradeDetails//fpml:additionalPayment[position()=4] and (not($swStructuredTradeDetails//fpml:additionalPayment[position()=4]/fpml:paymentType))">1</xsl:when>
<xsl:otherwise>0</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="test5">
<xsl:choose>
<xsl:when test="$swStructuredTradeDetails//fpml:additionalPayment[position()=5] and (not($swStructuredTradeDetails//fpml:additionalPayment[position()=5]/fpml:paymentType))">1</xsl:when>
<xsl:otherwise>0</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="test6">
<xsl:choose>
<xsl:when test="$swStructuredTradeDetails//fpml:additionalPayment[position()=6] and (not($swStructuredTradeDetails//fpml:additionalPayment[position()=6]/fpml:paymentType))">1</xsl:when>
<xsl:otherwise>0</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="test7">
<xsl:choose>
<xsl:when test="$swStructuredTradeDetails//fpml:additionalPayment[position()=7] and (not($swStructuredTradeDetails//fpml:additionalPayment[position()=7]/fpml:paymentType))">1</xsl:when>
<xsl:otherwise>0</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="blockAdditionalPayCurrency1">
<xsl:choose>
<xsl:when test="$test1">
<xsl:value-of select="$swStructuredTradeDetails//fpml:additionalPayment[position()=1]/fpml:paymentAmount/fpml:currency"/>
</xsl:when>
<xsl:when test="$test2">
<xsl:value-of select="$swStructuredTradeDetails//fpml:additionalPayment[position()=2]/fpml:paymentAmount/fpml:currency"/>
</xsl:when>
<xsl:when test="$test3">
<xsl:value-of select="$swStructuredTradeDetails//fpml:additionalPayment[position()=3]/fpml:paymentAmount/fpml:currency"/>
</xsl:when>
</xsl:choose>
</xsl:variable>
<xsl:variable name="blockAdditionalPayUnadjDate1">
<xsl:choose>
<xsl:when test="$test1">
<xsl:value-of select="$swStructuredTradeDetails//fpml:additionalPayment[position()=1]/fpml:paymentDate/fpml:unadjustedDate"/>
</xsl:when>
<xsl:when test="$test2">
<xsl:value-of select="$swStructuredTradeDetails//fpml:additionalPayment[position()=2]/fpml:paymentDate/fpml:unadjustedDate"/>
</xsl:when>
<xsl:when test="$test3">
<xsl:value-of select="$swStructuredTradeDetails//fpml:additionalPayment[position()=3]/fpml:paymentDate/fpml:unadjustedDate"/>
</xsl:when>
</xsl:choose>
</xsl:variable>
<xsl:variable name="blockAdditionalPayConvention1">
<xsl:choose>
<xsl:when test="$test1">
<xsl:value-of select="$swStructuredTradeDetails//fpml:additionalPayment[position()=1]/fpml:paymentDate/fpml:dateAdjustments/fpml:businessDayConvention"/>
</xsl:when>
<xsl:when test="$test2">
<xsl:value-of select="$swStructuredTradeDetails//fpml:additionalPayment[position()=2]/fpml:paymentDate/fpml:dateAdjustments/fpml:businessDayConvention"/>
</xsl:when>
<xsl:when test="$test3">
<xsl:value-of select="$swStructuredTradeDetails//fpml:additionalPayment[position()=3]/fpml:paymentDate/fpml:dateAdjustments/fpml:businessDayConvention"/>
</xsl:when>
</xsl:choose>
</xsl:variable>
<xsl:variable name="blockAdditionalPayBusCenters1">
<xsl:choose>
<xsl:when test="$test1">
<xsl:for-each select="$swStructuredTradeDetails//fpml:additionalPayment[position()=1]/fpml:paymentDate/fpml:dateAdjustments/fpml:businessCenters/fpml:businessCenter">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:when>
<xsl:when test="$test2">
<xsl:for-each select="$swStructuredTradeDetails//fpml:additionalPayment[position()=2]/fpml:paymentDate/fpml:dateAdjustments/fpml:businessCenters/fpml:businessCenter">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:when>
<xsl:when test="$test3">
<xsl:for-each select="$swStructuredTradeDetails//fpml:additionalPayment[position()=3]/fpml:paymentDate/fpml:dateAdjustments/fpml:businessCenters/fpml:businessCenter">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:when>
</xsl:choose>
</xsl:variable>
<xsl:variable name="blockAdditionalPayType1">
<xsl:choose>
<xsl:when test="$test1">
<xsl:value-of select="$swStructuredTradeDetails//fpml:additionalPayment[position()=1]/fpml:paymentType"/>
</xsl:when>
<xsl:when test="$test2">
<xsl:value-of select="$swStructuredTradeDetails//fpml:additionalPayment[position()=2]/fpml:paymentType"/>
</xsl:when>
<xsl:when test="$test3">
<xsl:value-of select="$swStructuredTradeDetails//fpml:additionalPayment[position()=3]/fpml:paymentType"/>
</xsl:when>
</xsl:choose>
</xsl:variable>
<xsl:variable name="blockAdditionalPayCurrency2">
<xsl:choose>
<xsl:when test="$test2">
<xsl:value-of select="$swStructuredTradeDetails//fpml:additionalPayment[position()=2]/fpml:paymentAmount/fpml:currency"/>
</xsl:when>
<xsl:when test="$test3">
<xsl:value-of select="$swStructuredTradeDetails//fpml:additionalPayment[position()=3]/fpml:paymentAmount/fpml:currency"/>
</xsl:when>
</xsl:choose>
</xsl:variable>
<xsl:variable name="blockAdditionalPayUnadjDate2">
<xsl:choose>
<xsl:when test="$test2">
<xsl:value-of select="$swStructuredTradeDetails//fpml:additionalPayment[position()=2]/fpml:paymentDate/fpml:unadjustedDate"/>
</xsl:when>
<xsl:when test="$test3">
<xsl:value-of select="$swStructuredTradeDetails//fpml:additionalPayment[position()=3]/fpml:paymentDate/fpml:unadjustedDate"/>
</xsl:when>
</xsl:choose>
</xsl:variable>
<xsl:variable name="blockAdditionalPayConvention2">
<xsl:choose>
<xsl:when test="$test2">
<xsl:value-of select="$swStructuredTradeDetails//fpml:additionalPayment[position()=2]/fpml:paymentDate/fpml:dateAdjustments/fpml:businessDayConvention"/>
</xsl:when>
<xsl:when test="$test3">
<xsl:value-of select="$swStructuredTradeDetails//fpml:additionalPayment[position()=3]/fpml:paymentDate/fpml:dateAdjustments/fpml:businessDayConvention"/>
</xsl:when>
</xsl:choose>
</xsl:variable>
<xsl:variable name="blockAdditionalPayBusCenters2">
<xsl:choose>
<xsl:when test="$test2">
<xsl:for-each select="$swStructuredTradeDetails//fpml:additionalPayment[position()=2]/fpml:paymentDate/fpml:dateAdjustments/fpml:businessCenters/fpml:businessCenter">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:when>
<xsl:when test="$test3">
<xsl:for-each select="$swStructuredTradeDetails//fpml:additionalPayment[position()=3]/fpml:paymentDate/fpml:dateAdjustments/fpml:businessCenters/fpml:businessCenter">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:when>
</xsl:choose>
</xsl:variable>
<xsl:variable name="blockAdditionalPayType2">
<xsl:choose>
<xsl:when test="$test2">
<xsl:value-of select="$swStructuredTradeDetails//fpml:additionalPayment[position()=2]/fpml:paymentType"/>
</xsl:when>
<xsl:when test="$test3">
<xsl:value-of select="$swStructuredTradeDetails//fpml:additionalPayment[position()=3]/fpml:paymentType"/>
</xsl:when>
</xsl:choose>
</xsl:variable>
<xsl:variable name="blockIndependentAmountCurrency">
<xsl:if test="$swStructuredTradeDetails//fpml:collateral">
<xsl:value-of select="$swStructuredTradeDetails//fpml:collateral/fpml:independentAmount/fpml:paymentDetail/fpml:paymentAmount/fpml:currency"/>
</xsl:if>
</xsl:variable>
<xsl:template match="fpml:swGiveUp">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="hrefC">
<xsl:value-of select="fpml:swCustomerTransaction/fpml:swCustomer/@href"/>
</xsl:variable>
<xsl:variable name="hrefD">
<xsl:value-of select="fpml:swInterDealerTransaction/fpml:swExecutingDealer/@href"/>
</xsl:variable>
<xsl:variable name="hrefCPB">
<xsl:value-of select="fpml:swCustomerTransaction/fpml:swPrimeBroker/@href"/>
</xsl:variable>
<xsl:variable name="hrefDPB">
<xsl:value-of select="fpml:swInterDealerTransaction/fpml:swPrimeBroker/@href"/>
</xsl:variable>
<xsl:variable name="hrefG">
<xsl:value-of select="fpml:swExecutingDealerCustomerTransaction/fpml:swExecutingDealer/@href"/>
</xsl:variable>
<xsl:if test="$hrefG=$hrefD">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swExecutingDealerCustomerTransaction/swExecutingDealer/@href and swInterDealerTransaction/swExecutingDealer/@href values must not be the same.</text>
</error>
</xsl:if>
<xsl:if test="$hrefG=$hrefC">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swExecutingDealerCustomerTransaction/swExecutingDealer/@href and swCustomerTransaction/:swCustomer/@href values must not be the same.</text>
</error>
</xsl:if>
<xsl:if test="$hrefG=$hrefCPB">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swExecutingDealerCustomerTransaction/swExecutingDealer/@href and swCustomerTransaction/swPrimeBroker/@href values must not be the same.</text>
</error>
</xsl:if>
<xsl:if test="$hrefG=$hrefDPB">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swExecutingDealerCustomerTransaction/swExecutingDealer/@href and swInterDealerTransaction/swPrimeBroker/@href values must not be the same.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swExecutingDealerCustomerTransaction">
<xsl:if test="not(//fpml:FpML/fpml:party[@id=$hrefG])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swExecutingDealerCustomerTransaction/swExecutingDealer/@href does not reference a valid FpML/trade/party/@id. Value = '<xsl:value-of select="$hrefG"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$hrefC=$hrefD">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swCustomerTransaction/swCustomer/@href and swInterDealerTransaction/swExecutingDealer/@href values must not be the same.</text>
</error>
</xsl:if>
<xsl:if test="$hrefC=$hrefCPB">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swCustomerTransaction/swCustomer/@href and swCustomerTransaction/swPrimeBroker/@href values must not be the same.</text>
</error>
</xsl:if>
<xsl:if test="$hrefD=$hrefCPB">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swInterDealerTransaction/swExecutingDealer/@href and swCustomerTransaction/swPrimeBroker/@href values must not be the same.</text>
</error>
</xsl:if>
<xsl:if test="$hrefD=$hrefDPB">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swInterDealerTransaction/swExecutingDealer/@href and swInterDealerTransaction/swPrimeBroker/@href values must not be the same.</text>
</error>
</xsl:if>
<xsl:if test="$hrefC=$hrefDPB">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swCustomerTransaction/swCustomer/@href and swInterDealerTransaction/swPrimeBroker/@href values must not be the same.</text>
</error>
</xsl:if>
<xsl:if test="not(//fpml:FpML/fpml:party[@id=$hrefC])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swCustomerTransaction/swCustomer/@href does not reference a valid FpML/trade/party/@id. Value = '<xsl:value-of select="$hrefC"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not(//fpml:FpML/fpml:party[@id=$hrefCPB])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swCustomerTransaction/swPrimeBroker/@href does not reference a valid FpML/trade/party/@id. Value = '<xsl:value-of select="$hrefCPB"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not(//fpml:FpML/fpml:party[@id=$hrefD])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swInterDealerTransaction/swExecutingDealer/@href does not reference a valid FpML/trade/party/@id. Value = '<xsl:value-of select="$hrefD"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not(//fpml:FpML/fpml:party[@id=$hrefDPB])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swInterDealerTransaction/swPrimeBroker/@href does not reference a valid /FpML/trade/party/@id. Value = '<xsl:value-of select="$hrefDPB"/>'.</text>
</error>
</xsl:if>
<xsl:if test="$isAllocatedTrade = 0">
<xsl:if test="$hrefDPB=$hrefCPB and not(fpml:swExecutingDealerCustomerTransaction)">
<xsl:if test="count(//fpml:FpML/fpml:party) &lt; 3">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of party child elements encountered. 3 expected.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$hrefDPB!=$hrefCPB and not(fpml:swExecutingDealerCustomerTransaction)">
<xsl:if test="count(//fpml:FpML/fpml:party) &lt; 4">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of party child elements encountered. 4 expected.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
<xsl:if test="$isAllocatedTrade != 0">
<xsl:if test="$hrefDPB=$hrefCPB and not(fpml:swExecutingDealerCustomerTransaction)">
<xsl:if test="count(//fpml:FpML/fpml:party) &lt; 3">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of party child elements encountered. At least 3 expected.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$hrefDPB!=$hrefCPB and not(fpml:swExecutingDealerCustomerTransaction)">
<xsl:if test="count(//fpml:FpML/fpml:party) &lt; 4">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of party child elements encountered. At least 4 expected.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
<xsl:if test="$productType = 'OIS' or $productType = 'IRS' or $productType='Swaption' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS'">
<xsl:if test="($hrefD != //fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:payerPartyReference/@href) and ($hrefD != //fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:receiverPartyReference/@href)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swInterDealerTransaction/swExecutingDealer/@href must be a payer or receiver on swap if product type is 'SingleCurrencyInterestRateSwap', 'OIS',  'Swaption', 'Single Currency Basis Swap' or 'Cross Currency Basis Swap'.</text>
</error>
</xsl:if>
<xsl:if test="($hrefC != //fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:receiverPartyReference/@href) and ($hrefC != //fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:payerPartyReference/@href)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swCustomerTransaction/swCustomer/@href must be a payer or receiver on swap if product type is 'SingleCurrencyInterestRateSwap', 'OIS',  'Swaption', 'Single Currency Basis Swap' or 'Cross Currency Basis Swap' or 'Cross Currency IRS'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$productType = 'FRA'">
<xsl:if test="($hrefD != //fpml:FpML/fpml:trade//fpml:fra/fpml:buyerPartyReference/@href) and ($hrefD != //fpml:FpML/fpml:trade//fpml:fra/fpml:sellerPartyReference/@href)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swInterDealerTransaction/swExecutingDealer/@href must be a buyer or seller on FRA if product type is 'FRA'.</text>
</error>
</xsl:if>
<xsl:if test="($hrefC != //fpml:FpML/fpml:trade//fpml:fra/fpml:sellerPartyReference/@href) and ($hrefC != //fpml:FpML/fpml:trade//fpml:fra/fpml:buyerPartyReference/@href)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swCustomerTransaction/swCustomer/@href must be a buyer or seller on FRA if product type is 'FRA'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$productType = 'IRS' or $productType='Swaption' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType = 'OIS'">
<xsl:if test=".//fpml:swEarlyTerminationProvision">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** ./swEarlyTerminationProvision must not be specified in a Primary Prime Brokered Trade.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="node()/fpml:swMandatoryClearing">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:swAllocations">
<xsl:param name="context"/>
<xsl:param name="reportingData"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:apply-templates select="fpml:swAllocation">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
<xsl:with-param name="reportingData" select="$reportingData"/>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:swAllocation">
<xsl:param name="context"/>
<xsl:param name="reportingData"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:apply-templates select="fpml:allocatedNotional">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:swAllocatedContraNotional">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:swVariableAmount">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:variable name="AddPayNumber">
<xsl:value-of select="count(fpml:additionalPayment)"/>
</xsl:variable>
<xsl:if test="$AddPayNumber&gt;2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of additionalPayment child elements encountered. 0 to 2 expected.</text>
</error>
</xsl:if>
<xsl:if test="($AddPayNumber &gt; $blockAdditionalPaymentCount) and $isBlockIndependentAmountPresent!='true'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** There must not be more additionalPayment child elements in swAllocation than in the block trade.</text>
</error>
</xsl:if>
<xsl:choose>
<xsl:when test="$productType = 'Single Currency Basis Swap' or $productType = 'Cross Currency Basis Swap'">
<xsl:if test="fpml:swStreamReference and not(fpml:swStreamReference/@href='floatingLeg')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swStreamReference must reference first floating leg ***</text>
</error>
</xsl:if>
</xsl:when>
<xsl:otherwise>
<xsl:if test="fpml:swStreamReference and not(fpml:swStreamReference/@href='fixedLeg')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swStreamReference must reference fixed leg ***</text>
</error>
</xsl:if>
</xsl:otherwise>
</xsl:choose>
<xsl:if test="$productType = 'OIS' or $productType = 'IRS' or $productType='Single Currency Basis Swap' or $productType='ZCInflationSwap' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType = 'Fixed Fixed Swap'">
<xsl:if test="not(fpml:swStreamReference)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swStreamReference must be present if product type is 'SingleCurrencyInterestRateSwap', 'OIS', 'Single Currency Basis Swap',  'ZC Inflation Swap' or 'Cross Currency Basis Swap' or 'Cross Currency IRS' or 'Fixed Fixed Swap'.</text>
</error>
</xsl:if>
<xsl:variable name="payerPartyRef">
<xsl:value-of select="fpml:payerPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="receiverPartyRef">
<xsl:value-of select="fpml:receiverPartyReference/@href"/>
</xsl:variable>
<xsl:if test="$payerPartyRef=$receiverPartyRef">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** fpml:payerPartyReference/@href and receiverPartyReference/@href values must not be the same.</text>
</error>
</xsl:if>
<xsl:if test="not(//fpml:FpML/fpml:party[@id=$payerPartyRef])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** fpml:payerPartyReference/@href does not reference a valid FpML/trade/party/@id. Value = '<xsl:value-of select="$payerPartyRef"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not(//fpml:FpML/fpml:party[@id=$receiverPartyRef])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** receiverPartyReference/@href does not reference a valid FpML/trade/party/@id. Value = '<xsl:value-of select="$receiverPartyRef"/>'.</text>
</error>
</xsl:if>
<xsl:variable name="payerPartyId">
<xsl:value-of select="//fpml:FpML/fpml:party[@id=$payerPartyRef]/fpml:partyId"/>
</xsl:variable>
<xsl:variable name="receiverPartyId">
<xsl:value-of select="//fpml:FpML/fpml:party[@id=$receiverPartyRef]/fpml:partyId"/>
</xsl:variable>
<xsl:if test="$payerPartyId=$receiverPartyId">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** partyId (legal entity) referenced by payerPartyReference/@href must not equal partyId (legal entity) referenced by receiverPartyReference/@href.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swIAExpected = 'true' and not(fpml:independentAmount)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***  independentAmount element must be present if swIAExpected flag is set to true</text>
</error>
</xsl:if>
<xsl:if test="fpml:swIAExpected = 'true' and fpml:independentAmount/fpml:paymentDetail/fpml:paymentAmount/fpml:amount != 0">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***  independentAmount must be zero if swIAExpected flag is set to true</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:independentAmount">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
<xsl:with-param name="allocPartyA">
<xsl:value-of select="$payerPartyRef"/>
</xsl:with-param>
<xsl:with-param name="allocPartyB">
<xsl:value-of select="$receiverPartyRef"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates mode="allocation" select="fpml:additionalPayment">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
<xsl:with-param name="allocPartyA">
<xsl:value-of select="$payerPartyRef"/>
</xsl:with-param>
<xsl:with-param name="allocPartyB">
<xsl:value-of select="$receiverPartyRef"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
<xsl:if test="$productType = 'Swaption' or $productType = 'FRA' or $productType = 'CapFloor'">
<xsl:if test="not(fpml:buyerPartyReference)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***buyerPartyReference must be present if product type is 'Swaption' or 'FRA' or 'CapFloor'.</text>
</error>
</xsl:if>
<xsl:variable name="buyerPartyRef">
<xsl:value-of select="fpml:buyerPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="sellerPartyRef">
<xsl:value-of select="fpml:sellerPartyReference/@href"/>
</xsl:variable>
<xsl:if test="$buyerPartyRef=$sellerPartyRef">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***buyerPartyReference/@href and sellerPartyReference/@href values must not be the same.</text>
</error>
</xsl:if>
<xsl:if test="not(//fpml:FpML/fpml:party[@id=$buyerPartyRef])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***buyerPartyReference/@href does not reference a valid /FpML/trade/party/@id. Value = '<xsl:value-of select="$buyerPartyRef"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not(//fpml:FpML/fpml:party[@id=$sellerPartyRef])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***sellerPartyReference/@href does not reference a valid /FpML/trade/party/@id. Value = '<xsl:value-of select="$sellerPartyRef"/>'.</text>
</error>
</xsl:if>
<xsl:variable name="buyerPartyId">
<xsl:value-of select="//fpml:FpML/fpml:party[@id=$buyerPartyRef]/fpml:partyId"/>
</xsl:variable>
<xsl:variable name="sellerPartyId">
<xsl:value-of select="//fpml:FpML/fpml:party[@id=$sellerPartyRef]/fpml:partyId"/>
</xsl:variable>
<xsl:if test="$buyerPartyId=$sellerPartyId">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** partyId (legal entity) referenced by buyerPartyReference/@href must not equal partyId (legal entity) referenced by sellerPartyReference/@href.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swIAExpected = 'true' and not(fpml:independentAmount)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***  independentAmount element must be present if swIAExpected flag is set to true</text>
</error>
</xsl:if>
<xsl:if test="fpml:swIAExpected = 'true' and fpml:independentAmount/fpml:paymentDetail/fpml:paymentAmount/fpml:amount != 0">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***  independentAmount must be zero if swIAExpected flag is set to true</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:independentAmount">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
<xsl:with-param name="allocPartyA">
<xsl:value-of select="$buyerPartyRef"/>
</xsl:with-param>
<xsl:with-param name="allocPartyB">
<xsl:value-of select="$sellerPartyRef"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates mode="allocation" select="fpml:additionalPayment">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
<xsl:with-param name="allocPartyA">
<xsl:value-of select="$buyerPartyRef"/>
</xsl:with-param>
<xsl:with-param name="allocPartyB">
<xsl:value-of select="$sellerPartyRef"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
<xsl:if test="fpml:swSalesCredit">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swSalesCredit</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swSalesCredit"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.01</xsl:with-param>
<xsl:with-param name="maxIncl">999999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:call-template name="swAllocationReportingDetails">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
<xsl:with-param name="reportingData" select="$reportingData"/>
<xsl:with-param name="allocationNum" select="position()"/>
</xsl:call-template>
</xsl:template>
<xsl:template match="fpml:allocatedNotional">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="allocatedNotionalCurrency">
<xsl:value-of select="fpml:currency"/>
</xsl:variable>
<xsl:if test="$allocatedNotionalCurrency != $tradeCurrency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** allocatedNotional/currency must be the same as the block notional currency within an allocated trade. Value = '<xsl:value-of select="$allocatedNotionalCurrency"/>'.</text>
</error>
</xsl:if>
<xsl:call-template name="isValidCurrency">
<xsl:with-param name="elementName">currency</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:currency"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:variable name="amount">
<xsl:value-of select="fpml:amount"/>
</xsl:variable>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">amount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$amount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.01</xsl:with-param>
<xsl:with-param name="maxIncl">3999999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:template>
<xsl:template match="fpml:swAllocatedContraNotional">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="$MarkToMarket='true' and ($productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swAllocatedContraNotional should not be present if product type is 'Cross Currency Basis Swap' or 'Cross Currency IRS' and MarkToMarket is True.</text>
</error>
</xsl:if>
<xsl:variable name="swAllocatedContraNotionalCurrency">
<xsl:value-of select="fpml:currency"/>
</xsl:variable>
<xsl:variable name="notional2Currency">
<xsl:value-of select="//fpml:swapStream[2]/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:currency"/>
<xsl:value-of select="//fpml:swapStream[2]/fpml:calculationPeriodAmount/fpml:calculation/fpml:fxLinkedNotionalSchedule/fpml:varyingNotionalCurrency"/>
</xsl:variable>
<xsl:if test="$swAllocatedContraNotionalCurrency != $notional2Currency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>
*** swAllocatedContraNotional/currency must be the same as the block notional 2 currency within an allocated trade. Value = '<xsl:value-of select="$swAllocatedContraNotionalCurrency"/>'.
</text>
</error>
</xsl:if>
<xsl:call-template name="isValidCurrency">
<xsl:with-param name="elementName">currency</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:currency"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:variable name="amount">
<xsl:value-of select="fpml:amount"/>
</xsl:variable>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">amount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$amount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.01</xsl:with-param>
<xsl:with-param name="maxIncl">3999999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:template>
<xsl:template match="fpml:swVariableAmount">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="$MarkToMarket!='true' and ($productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swVariableAmount should not be present if product type is 'Cross Currency Basis Swap' or 'Cross Currency IRS' and MarkToMarket is False.</text>
</error>
</xsl:if>
<xsl:variable name="swVariableAmountCurrency">
<xsl:value-of select="fpml:currency"/>
</xsl:variable>
<xsl:variable name="notional2Currency">
<xsl:value-of select="//fpml:swapStream[2]/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:currency"/>
<xsl:value-of select="//fpml:swapStream[2]/fpml:calculationPeriodAmount/fpml:calculation/fpml:fxLinkedNotionalSchedule/fpml:varyingNotionalCurrency"/>
</xsl:variable>
<xsl:if test="$swVariableAmountCurrency != $notional2Currency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>
*** swVariableAmount/currency must be the same as the block notional 2 currency within an allocated trade. Value = '<xsl:value-of select="$swVariableAmountCurrency"/>'.
</text>
</error>
</xsl:if>
<xsl:call-template name="isValidCurrency">
<xsl:with-param name="elementName">currency</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:currency"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:variable name="amount">
<xsl:value-of select="fpml:amount"/>
</xsl:variable>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">amount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$amount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.01</xsl:with-param>
<xsl:with-param name="maxIncl">3999999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:template>
<xsl:template match="fpml:independentAmount">
<xsl:param name="context"/>
<xsl:param name="allocPartyA"/>
<xsl:param name="allocPartyB"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="payerPartyRef">
<xsl:value-of select="fpml:payerPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="receiverPartyRef">
<xsl:value-of select="fpml:receiverPartyReference/@href"/>
</xsl:variable>
<xsl:if test="$payerPartyRef=$receiverPartyRef">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** payerPartyReference/@href and receiverPartyReference/@href values must not be the same.</text>
</error>
</xsl:if>
<xsl:if test="$payerPartyRef!=$allocPartyA and $payerPartyRef!=$allocPartyB">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** payerPartyReference/@href must reference one of the parties to the allocation.</text>
</error>
</xsl:if>
<xsl:if test="$receiverPartyRef!=$allocPartyA and $receiverPartyRef!=$allocPartyB">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** receiverPartyReference/@href must reference one of the parties to the allocation.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:paymentDetail">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:paymentDetail">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:apply-templates select="fpml:independentAmount/fpml:paymentDetail/fpml:paymentAmount">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:variable name="currency">
<xsl:value-of select="fpml:paymentAmount/fpml:currency"/>
</xsl:variable>
<xsl:if test="not(ancestor::fpml:collateral)">
<xsl:if test="$currency!=$blockIndependentAmountCurrency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** paymentAmount/currency must equal the block trade independent amount currency.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:template>
<xsl:template mode="allocation" match="fpml:additionalPayment">
<xsl:param name="context"/>
<xsl:param name="allocPartyA"/>
<xsl:param name="allocPartyB"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:if test="paymentType != 'CancellablePremium' and not(@seq)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing @seq attribute. Required in this context.</text>
</error>
</xsl:if>
<xsl:variable name="payerPartyRef">
<xsl:value-of select="fpml:payerPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="receiverPartyRef">
<xsl:value-of select="fpml:receiverPartyReference/@href"/>
</xsl:variable>
<xsl:if test="$payerPartyRef=$receiverPartyRef">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** payerPartyReference/@href and receiverPartyReference/@href values must not be the same.</text>
</error>
</xsl:if>
<xsl:if test="$payerPartyRef!=$allocPartyA and $payerPartyRef!=$allocPartyB">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** payerPartyReference/@href must reference one of the parties to the allocation.</text>
</error>
</xsl:if>
<xsl:if test="$receiverPartyRef!=$allocPartyA and $receiverPartyRef!=$allocPartyB">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** receiverPartyReference/@href must reference one of the parties to the allocation.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:paymentAmount">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="not(fpml:paymentDate)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing paymentDate. Required in this context.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:paymentDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:variable name="allocAdditionalPayCurrency">
<xsl:value-of select="fpml:paymentAmount/fpml:currency"/>
</xsl:variable>
<xsl:variable name="allocAdditionalPayUnadjDate">
<xsl:value-of select="fpml:paymentDate/fpml:unadjustedDate"/>
</xsl:variable>
<xsl:variable name="allocAdditionalPayConvention">
<xsl:value-of select="fpml:paymentDate/fpml:dateAdjustments/fpml:businessDayConvention"/>
</xsl:variable>
<xsl:variable name="allocAdditionalPayBusCenters">
<xsl:for-each select="fpml:paymentDate/fpml:dateAdjustments/fpml:businessCenters/fpml:businessCenter">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:variable>
<xsl:variable name="allocAdditionalPayType">
<xsl:value-of select="fpml:paymentType"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="@seq='1'">
<xsl:if test="$allocAdditionalPayCurrency!=$blockAdditionalPayCurrency1">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** paymentAmount/currency must equal thepaymentAmount/currency of the corresponding additional payment on the block trade.</text>
</error>
</xsl:if>
<xsl:if test="$allocAdditionalPayUnadjDate!=$blockAdditionalPayUnadjDate1">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** paymentDate/unadjustedDate must equal the paymentDate/unadjustedDate of the corresponding additional payment on the block trade..</text>
</error>
</xsl:if>
<xsl:if test="$allocAdditionalPayConvention!=$blockAdditionalPayConvention1">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** paymentDate/dateAdjustments/businessDayConvention must equal the paymentDate/dateAdjustments/businessDayConvention of the corresponding additional payment on the block trade.</text>
</error>
</xsl:if>
<xsl:if test="$allocAdditionalPayBusCenters!=$blockAdditionalPayBusCenters1">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** paymentDate/dateAdjustments/businessCenters must equal the paymentDate/dateAdjustments/businessCenters of the corresponding additional payment on the block trade.</text>
</error>
</xsl:if>
<xsl:if test="$allocAdditionalPayType!=$blockAdditionalPayType1">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** paymentType must equal the paymentType of the corresponding additional payment on the block trade.</text>
</error>
</xsl:if>
</xsl:when>
<xsl:when test="@seq='2'">
<xsl:if test="$allocAdditionalPayCurrency!=$blockAdditionalPayCurrency2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** paymentAmount/currency must equal the paymentAmount/currency of the corresponding additional payment on the block trade.</text>
</error>
</xsl:if>
<xsl:if test="$allocAdditionalPayUnadjDate!=$blockAdditionalPayUnadjDate2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** paymentDate/unadjustedDate must equal the paymentDate/unadjustedDate of the corresponding additional payment on the block trade..</text>
</error>
</xsl:if>
<xsl:if test="$allocAdditionalPayConvention!=$blockAdditionalPayConvention2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** paymentDate/dateAdjustments/businessDayConvention must equal the paymentDate/dateAdjustments/businessDayConvention of the corresponding additional payment on the block trade.</text>
</error>
</xsl:if>
<xsl:if test="$allocAdditionalPayBusCenters!=$blockAdditionalPayBusCenters2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** paymentDate/fpml:dateAdjustments/businessCenters must equal the paymentDate/dateAdjustments/businessCenters of the corresponding additional payment on the block trade.</text>
</error>
</xsl:if>
<xsl:if test="$allocAdditionalPayType!=$blockAdditionalPayType2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** paymentType must equal the paymentType of the corresponding additional payment on the block trade.</text>
</error>
</xsl:if>
</xsl:when>
</xsl:choose>
</xsl:template>
<xsl:template match="fpml:novation">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="transferor">
<xsl:value-of select="fpml:transferor/@href"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$productType='Offline Trade Rates'">
<xsl:if test="not(//fpml:swOfflineTrade/fpml:party[@id=$transferor])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** transferor/@href does not reference a valid swOfflineTrade/trade/party/@id. Value = '<xsl:value-of select="$transferor"/>'.</text>
</error>
</xsl:if>
</xsl:when>
<xsl:otherwise>
<xsl:if test="not(//fpml:FpML/fpml:party[@id=$transferor])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** transferor/@href does not reference a valid FpML/trade/party/@id. Value = '<xsl:value-of select="$transferor"/>'.</text>
</error>
</xsl:if>
</xsl:otherwise>
</xsl:choose>
<xsl:variable name="transferee">
<xsl:value-of select="fpml:transferee/@href"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$productType='Offline Trade Rates'">
<xsl:if test="not(//fpml:swOfflineTrade/fpml:party[@id=$transferee])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** transferee/@href does not reference a valid /swOfflineTrade/trade/party/@id. Value = '<xsl:value-of select="$transferee"/>'.</text>
</error>
</xsl:if>
</xsl:when>
<xsl:otherwise>
<xsl:if test="not(//fpml:FpML/fpml:party[@id=$transferee])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** transferee/@href does not reference a valid /FpML/trade/party/@id. Value = '<xsl:value-of select="$transferee"/>'.</text>
</error>
</xsl:if>
</xsl:otherwise>
</xsl:choose>
<xsl:variable name="remainingParty">
<xsl:value-of select="fpml:remainingParty/@href"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$productType='Offline Trade Rates'">
<xsl:if test="not(//fpml:swOfflineTrade/fpml:party[@id=$remainingParty])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** remainingParty/@href does not reference a valid /swOfflineTrade/trade/party/@id. Value = '<xsl:value-of select="$remainingParty"/>'.</text>
</error>
</xsl:if>
</xsl:when>
<xsl:otherwise>
<xsl:if test="not(//fpml:FpML/fpml:party[@id=$remainingParty])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** remainingParty/@href does not reference a valid /FpML/trade/party/@id. Value = '<xsl:value-of select="$remainingParty"/>'.</text>
</error>
</xsl:if>
</xsl:otherwise>
</xsl:choose>
<xsl:variable name="otherRemainingParty">
<xsl:value-of select="fpml:otherRemainingParty/@href"/>
</xsl:variable>
<xsl:if test="fpml:otherRemainingParty">
<xsl:choose>
<xsl:when test="$productType='Offline Trade Rates'">
<xsl:if test="not(//fpml:swOfflineTrade/fpml:party[@id=$otherRemainingParty])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** otherRemainingParty/@href does not reference a valid swOfflineTrade/trade/party/@id. Value = '<xsl:value-of select="$otherRemainingParty"/>'.</text>
</error>
</xsl:if>
</xsl:when>
<xsl:otherwise>
<xsl:if test="not(//fpml:FpML/fpml:party[@id=$otherRemainingParty])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** otherRemainingParty/@href does not reference a valid /FpML/trade/party/@id. Value = '<xsl:value-of select="$otherRemainingParty"/>'.</text>
</error>
</xsl:if>
</xsl:otherwise>
</xsl:choose>
<xsl:if test="$remainingParty = $otherRemainingParty">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***otherRemainingParty/@href must not equal remainingParty/@href.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">novationDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:novationDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">novationTradeDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:novationTradeDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:variable name="novationTradeDate">
<xsl:value-of select="fpml:novationTradeDate"/>
</xsl:variable>
<xsl:variable name="novationDate">
<xsl:value-of select="fpml:novationDate"/>
</xsl:variable>
<xsl:variable name="novTradeDate">
<xsl:value-of select="number(concat(substring($novationTradeDate,1,4),substring($novationTradeDate,6,2),substring($novationTradeDate,9,2)))"/>
</xsl:variable>
<xsl:variable name="novDate">
<xsl:value-of select="number(concat(substring($novationDate,1,4),substring($novationDate,6,2),substring($novationDate,9,2)))"/>
</xsl:variable>
<xsl:if test="$novDate &lt; $novTradeDate">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The novationDate must be greater than or equal to the novationTradeDate.</text>
</error>
</xsl:if>
<xsl:if test="not($productType='Swaption') and not($productType='Offline Trade Rates') and not($productType='FRA')">
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">fullFirstCalculationPeriod</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:fullFirstCalculationPeriod"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="not(fpml:novatedAmount)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing fpml:novatedAmount. Required in this context.</text>
</error>
</xsl:if>
<xsl:if test="not($productType='Offline Trade Rates')">
<xsl:if test="fpml:novatedAmount/fpml:currency != $tradeCurrency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** novatedAmount/currency must equal trade currency.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="../fpml:novation and $tradeCurrency='BRL'">
<xsl:if test="not(fpml:swNovatedFV)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing fpml:swNovatedFV. Required in this context.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="../fpml:novation and ($productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS')">
<xsl:if test="($MarkToMarket='false')">
<xsl:if test="not(fpml:swNovatedAmount)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing fpml:swNovatedAmount. Required in this context.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
<xsl:if test="not($productType='Offline Trade Rates') and $tradeCurrency = 'BRL'">
<xsl:if test="fpml:swNovatedFV/fpml:currency != $tradeCurrency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swNovatedFV/currency must equal trade currency.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS'">
<xsl:if test="fpml:swNovatedAmount/fpml:currency != $tradeCurrency2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swNovatedAmount/currency must equal  trade currency 2.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$productType='IRS' and fpml:swNovatedAmount/fpml:amount">
<xsl:if test="fpml:swNovatedAmount/fpml:currency != $tradeCurrency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swNovatedAmount/currency must equal trade currency.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:variable name="tradeNotional">
<xsl:choose>
<xsl:when test="$productType='IRS' or $productType='OIS' or $productType='Swaption' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS'">
<xsl:value-of select="$trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:initialValue"/>
</xsl:when>
<xsl:when test="$productType='FRA'">
<xsl:value-of select="$trade//fpml:fra/fpml:notional/fpml:amount"/>
</xsl:when>
<xsl:when test="$productType='CapFloor'">
<xsl:value-of select="$trade//fpml:capFloor/fpml:capFloorStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:initialValue"/>
</xsl:when>
<xsl:when test="$productType='Cross Currency IRS'">
<xsl:value-of select="$trade//fpml:swap/fpml:swapStream[position()=$fixedLeg]/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:initialValue"/>
</xsl:when>
<xsl:when test="$productType='Fixed Fixed Swap'">
<xsl:value-of select="$trade//fpml:swap/fpml:swapStream[position()=$fixedLeg]/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:initialValue"/>
</xsl:when>
</xsl:choose>
</xsl:variable>
<xsl:variable name="tradeNotional_2">
<xsl:choose>
<xsl:when test="$productType='Cross Currency Basis Swap' and not(fpml:fxLinkedNotionalSchedule)">
<xsl:value-of select="$trade//fpml:swap/fpml:swapStream[position()=$floatingLeg2]/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:initialValue"/>
</xsl:when>
<xsl:when test="$productType='Cross Currency IRS' and not(fpml:fxLinkedNotionalSchedule)">
<xsl:value-of select="$trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:initialValue"/>
</xsl:when>
<xsl:when test="$productType='Fixed Fixed Swap' and not(fpml:fxLinkedNotionalSchedule)">
<xsl:value-of select="$trade//fpml:swap/fpml:swapStream[position()=$fixedLeg2]/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:initialValue"/>
</xsl:when>
</xsl:choose>
</xsl:variable>
<xsl:if test="($productType='IRS' or $productType='Swaption' or $productType='OIS' or $productType='FRA') and number(fpml:novatedAmount/fpml:amount) &gt; number($tradeNotional)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** novatedAmount/notional must not be greater than trade notional. Value = '<xsl:value-of select="number(fpml:novatedAmount/fpml:amount)"/>'</text>
</error>
</xsl:if>
<xsl:if test="($productType='CapFloor') and number(fpml:novatedAmount/fpml:amount) != number($tradeNotional)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** novatedAmount/notional must equal trade notional. Value = '<xsl:value-of select="number(fpml:novatedAmount/fpml:amount)"/>'</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:novatedAmount">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:variable name="notionalFutureValue">
<xsl:if test="$productType='IRS' and $tradeCurrency='BRL'">
<xsl:value-of select="$swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swFutureValue/fpml:swNotionalFutureValue/fpml:amount"/>
</xsl:if>
</xsl:variable>
<xsl:if test="$tradeCurrency='BRL' and (number(fpml:swNovatedFV/fpml:amount) &gt; number($notionalFutureValue))">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Novated Future Value (swNovatedFV)  must not be greater than Future Value (swNotionalFutureValue). Value = '<xsl:value-of select="number(fpml:swNovatedFV/fpml:amount)"/>'</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:swNovatedFV">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="($productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS') and not(fpml:fxLinkedNotionalSchedule)">
<xsl:if test="(number(fpml:swNovatedAmount/fpml:amount) &gt; number($tradeNotional_2))">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Novated Amount 2 (swNovatedAmount)  must not be greater than Notional 2 . Value = '<xsl:value-of select="number(fpml:swNovatedAmount/fpml:amount)"/>'</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$productType='IRS' and $trade//fpml:swap/fpml:swapStream[position()=$fixedLeg]/fpml:calculationPeriodAmount/fpml:knownAmountSchedule">
<xsl:if test="number(fpml:swNovatedAmount/fpml:amount) &gt; number($trade//fpml:swap/fpml:swapStream[position()=$fixedLeg]/fpml:calculationPeriodAmount/fpml:knownAmountSchedule/fpml:initialValue)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Novated Amount 2 (swNovatedAmount)  must not be greater than Trade Fixed Amount. Value = '<xsl:value-of select="number(fpml:swNovatedAmount/fpml:amount)"/>'</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:swNovatedAmount">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:payment">
<xsl:choose>
<xsl:when test="$productType = 'Offline Trade Rates'">
<xsl:if test="fpml:payment/fpml:paymentType">
<xsl:if test="fpml:payment[fpml:paymentType != 'NovationConsent']">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** payment/paymentType must be equal to 'NovationConsent'. Value = '<xsl:value-of select="fpml:payment/fpml:paymentType"/>'.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:when>
<xsl:when test="$productType='Cross Currency Basis Swap' or $productType ='Cross Currency IRS' or ($productType='Fixed Fixed Swap' and $tradeCurrency != $tradeCurrency2)">
<xsl:if test="fpml:payment/fpml:paymentType">
<xsl:if test="(fpml:payment[(fpml:paymentType != 'Novation' and fpml:paymentType != 'Novation Notional Exchange')])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Novation payment type (novation/payment/paymentType) must be equal to 'Novation' or 'Novation Notional Exchange' for Cross Currency Products.   Values = <xsl:for-each select="fpml:payment">'<xsl:value-of select="fpml:paymentType"/>'<xsl:if test="position()!=last()">, </xsl:if>
</xsl:for-each>.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:when>
<xsl:otherwise>
<xsl:if test="fpml:payment[fpml:paymentType != 'Novation']">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** payment/paymentType must be equal to 'Novation'. Value = '<xsl:value-of select="fpml:payment/fpml:paymentType"/>'.</text>
</error>
</xsl:if>
</xsl:otherwise>
</xsl:choose>
<xsl:if test="fpml:payment[fpml:payerPartyReference/@href != $transferor and fpml:receiverPartyReference/@href != $transferor]">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** transferor/@href must equal payment/fpml:payerPartyReference/@href or payment/fpml:receiverPartyReference/@href.</text>
</error>
</xsl:if>
<xsl:if test="fpml:payment[fpml:payerPartyReference/@href = $remainingParty or fpml:receiverPartyReference = $remainingParty]">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** payment/fpml:payerPartyReference/@href or payment/fpml:receiverPartyReference/@href must not be equal to remainingParty/@href.</text>
</error>
</xsl:if>
<xsl:if test="fpml:otherRemainingParty">
<xsl:if test="fpml:payment[fpml:payerPartyReference/@href = $otherRemainingParty or fpml:receiverPartyReference/@href = $otherRemainingParty]">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** payment/fpml:payerPartyReference/@href or payment/fpml:receiverPartyReference/@href must not be equal to fpml:otherRemainingParty/@href.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:swPartialNovationIndicator">
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">swPartialNovationIndicator</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swPartialNovationIndicator"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swBilateralClearingHouse/partyId">
<xsl:if test="$productType!='IRS' and $productType!='OIS' and $productType!='FRA' and $productType!='Single Currency Basis Swap'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swBilateralClearingHouse should only be present if product type is 'IRS' or 'OIS'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="//fpml:swNovationExecutionUniqueTransactionId">
<xsl:call-template name="swNovationExecutionUniqueTransactionId">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
<xsl:with-param name="reportingData" select="$reportingData"/>
</xsl:call-template>
</xsl:if>
<xsl:apply-templates select="fpml:swMandatoryClearingNewNovatedTrade">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:payment">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:swBusinessConductDetails">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="/fpml:SWDML">
<xsl:param name="reportingData"/>
<xsl:variable name="newContext">In <xsl:value-of select="local-name()"/>
</xsl:variable>
<results version="1.0">
<xsl:if test="not($version='4-2')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid version attribute. Value = '<xsl:value-of select="$version"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not($swShortFormTrade or $swLongFormTrade)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swShortFormTrade or swLongFormTrade element. Required in this context.</text>
</error>
</xsl:if>
<xsl:apply-templates select="$swShortFormTrade">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="$swLongFormTrade">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
<xsl:with-param name="reportingData" select="$reportingData"/>
</xsl:apply-templates>
<xsl:call-template name="swTradeEventReportingDetails">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
<xsl:with-param name="reportingData" select="$reportingData"/>
</xsl:call-template>
</results>
</xsl:template>
<xsl:template match="fpml:swShortFormTrade">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="not(fpml:swOriginatorPartyReference)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swOriginatorPartyReference.</text>
</error>
</xsl:if>
<xsl:variable name="href">
<xsl:value-of select="fpml:swOriginatorPartyReference/@href"/>
</xsl:variable>
<xsl:if test="not(.//fpml:party[@id=$href])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swOriginatorPartyReference/@href does not reference a valid .party/@id. Value = '<xsl:value-of select="$href"/>'.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:swSwaptionParameters">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:swIrsParameters">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:swOisParameters">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:swFraParameters">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:swZCInflationSwapParameters">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:swCapFloorParameters">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:swFixedFixedParameters">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:swBasisSwapParameters">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:swCrossCurrencyBasisSwapParameters">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:swBackLoadingFlag">
<xsl:if test="not(fpml:swBackLoadingFlag[. = 'true'])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swBackLoadingFlag must be equal to 'true'. Value = '<xsl:value-of select="fpml:swBackLoadingFlag"/>'.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:swLongFormTrade">
<xsl:param name="context"/>
<xsl:param name="reportingData"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:apply-templates select="fpml:swGiveUp">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:swAllocations">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
<xsl:with-param name="reportingData" select="$reportingData"/>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:novation">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="($productType = 'IRS' or $productType = 'OIS') and $isZeroCouponInterestRateSwap = 'false'">
<xsl:variable name="dt1"><xsl:value-of select="fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:swap/fpml:swapStream[position()=$fixedLeg]/fpml:calculationPeriodDates/fpml:firstRegularPeriodStartDate"/></xsl:variable>
<xsl:variable name="dt2"><xsl:value-of select="fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodDates/fpml:firstRegularPeriodStartDate"/></xsl:variable>
<xsl:variable name="rollconv"><xsl:value-of select="fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:swap/fpml:swapStream[position()=$fixedLeg]/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:rollConvention"/></xsl:variable>
<xsl:variable name="frontandbackstub">
<xsl:choose>
<xsl:when test = "count(fpml:swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swStub) = 2">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
</xsl:if>
<xsl:if test="$productType = 'Fixed Fixed Swap' and isZeroCouponFixedFixedSwap = 'false'">
<xsl:variable name="dt1"><xsl:value-of select="fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:swap/fpml:swapStream[position()=$fixedLeg]/fpml:calculationPeriodDates/fpml:firstRegularPeriodStartDate"/></xsl:variable>
<xsl:variable name="dt2"><xsl:value-of select="fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:swap/fpml:swapStream[position()=$fixedLeg2]/fpml:calculationPeriodDates/fpml:firstRegularPeriodStartDate"/></xsl:variable>
<xsl:variable name="rollconv"><xsl:value-of select="fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:swap/fpml:swapStream[position()=$fixedLeg]/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:rollConvention"/></xsl:variable>
<xsl:variable name="frontandbackstub">
<xsl:choose>
<xsl:when test = "count(fpml:swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swStub) = 2">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:if test="($dt1 != $dt2 and $tradeCurrency = $tradeCurrency2) and starts-with($rollconv,'IMM') and $frontandbackstub='true'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** 1st Fixed Reg Period Start and 1st Fixed Reg Period Start 2 must be same while using different IMM date from its original IMM start date.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="not(fpml:swOriginatorPartyReference)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swOriginatorPartyReference.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swReplacementTradeId and //fpml:swReplacementReason = 'IndexTransitionReplacedByTrade'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** IndexTransitionReplacedByTrade is not a valid value for Replacement Reason in this context.</text>
</error>
</xsl:if>
<xsl:variable name="href">
<xsl:value-of select="fpml:swOriginatorPartyReference/@href"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$productType = 'Offline Trade Rates'">
<xsl:if test="not(//fpml:swOfflineTrade/fpml:party[@id=$href])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swOriginatorPartyReference/@href does not reference a valid /swOfflineTrade/trade/party/@id. Value = '<xsl:value-of select="$href"/>'.</text>
</error>
</xsl:if>
</xsl:when>
<xsl:otherwise>
<xsl:if test="not(//fpml:FpML/fpml:party[@id=$href])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swOriginatorPartyReference/@href does not reference a valid /FpML/trade/party/@id. Value = '<xsl:value-of select="$href"/>'.</text>
</error>
</xsl:if>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="fpml:swStructuredTradeDetails">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="$productType='Cross Currency Basis Swap'" >
<xsl:if test="$trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:principalExchanges/fpml:intermediateExchange">
<xsl:if test = "$MarkToMarket!=$trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:principalExchanges/fpml:intermediateExchange">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Intermediate Exchange must have the same value as Mark-to-Market.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:CapFloorParameters">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">tradeDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:tradeDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:variable name="href1">
<xsl:value-of select="fpml:buyerPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="href2">
<xsl:value-of select="fpml:sellerPartyReference/@href"/>
</xsl:variable>
<xsl:if test="$href1=$href2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***buyerPartyReference/@href and fpml:sellerPartyReference/@href values must not be the same.</text>
</error>
</xsl:if>
<xsl:if test="not(//fpml:party[@id=$href1])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***buyerPartyReference/@href does not reference a valid party/@id. Value = '<xsl:value-of select="$href1"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not(//fpml:party[@id=$href2])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***sellerPartyReference/@href does not reference a valid party/@id. Value = '<xsl:value-of select="$href2"/>'.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:swPremium">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="not(fpml:swOptionType = 'Cap' or 'Floor' or 'Cap Floor Straddle')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swOptionType must be one of 'Cap', 'Floor' or 'Cap Floor Straddle'. Value = '<xsl:value-of select="fpml:swOptionType"/>'.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:swSwapTermTenor">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:adjustedEffectiveDate">
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">adjustedEffectiveDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:adjustedEffectiveDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swUnadjustedTerminationDate">
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">swUnadjustedTerminationDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swUnadjustedTerminationDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:rollConvention">
<xsl:call-template name="isValidRollConvention">
<xsl:with-param name="elementName">rollConvention</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:rollConvention"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swStubPosition">
<xsl:call-template name="isValidStubPosition">
<xsl:with-param name="elementName">swStubPosition</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swStubPosition"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swStubPosition and fpml:rollConvention">
<xsl:variable name="rollConvention">
<xsl:value-of select="fpml:rollConvention"/>
</xsl:variable>
<xsl:if test="starts-with($rollConvention,'IMM') and not(//fpml:swStubPosition[.='Start'])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swStubPosition must equal 'Start' if rollConvention is equal to 'IMM'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:swEarlyTerminationProvision">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:notional">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swStrikeRate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swStrikeRate"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">9.99999999</xsl:with-param>
<xsl:with-param name="maxDecs">8</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="fpml:floatingRateIndex">
<xsl:variable name="floatingRateIndex">
<xsl:value-of select="fpml:floatingRateIndex"/>
</xsl:variable>
<xsl:if test="$floatingRateIndex=''">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Empty or missing floatingRateIndex.</text>
</error>
</xsl:if>
<xsl:if test="$tradeCurrency != 'PLN'">
<xsl:variable name="floatingRateIndexCurrency">
<xsl:value-of select="substring($floatingRateIndex,1,3)"/>
</xsl:variable>
<xsl:if test="$tradeCurrency != $floatingRateIndexCurrency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** floatingRateIndex value of '<xsl:value-of select="$floatingRateIndex"/>' is not valid for trade currency of '<xsl:value-of select="$tradeCurrency"/>'.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:indexTenor">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:paymentFrequency">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="count(fpml:party)!=2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of party child elements encountered. Exactly 2 expected.</text>
</error>
</xsl:if>
<xsl:variable name="id1">
<xsl:value-of select="fpml:party[1]/@id"/>
</xsl:variable>
<xsl:variable name="id2">
<xsl:value-of select="fpml:party[2]/@id"/>
</xsl:variable>
<xsl:if test="$id1=$id2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** party[1]/@id and party[2]/@id values must not be the same.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:party">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:swFraParameters">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">tradeDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:tradeDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:apply-templates select="fpml:swEffectiveDateTenor">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:swTerminationDateTenor">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:swTerminationDateTenor/fpml:periodMultiplier &lt;= fpml:swEffectiveDateTenor/fpml:periodMultiplier">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swTerminationDateTenor must be greater than swEffectiveDateTenor. swEffectiveDateTenor = '<xsl:value-of select="fpml:swEffectiveDateTenor/fpml:periodMultiplier"/>
<xsl:value-of select="fpml:swEffectiveDateTenor/fpml:period"/>' and fpml:swTerminationDateTenor = '<xsl:value-of select="fpml:swTerminationDateTenor/fpml:periodMultiplier"/>
<xsl:value-of select="fpml:swTerminationDateTenor/fpml:period"/>'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swTerminationDateTenor/fpml:periodMultiplier - fpml:swEffectiveDateTenor/fpml:periodMultiplier &gt; 12">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swTerminationDateTenor minus swEffectiveDateTenor must not be greater than 12 months. swEffectiveDateTenor = '<xsl:value-of select="fpml:swEffectiveDateTenor/fpml:periodMultiplier"/>
<xsl:value-of select="fpml:swEffectiveDateTenor/fpml:period"/>' and fpml:swTerminationDateTenor = '<xsl:value-of select="fpml:swTerminationDateTenor/fpml:periodMultiplier"/>
<xsl:value-of select="fpml:swTerminationDateTenor/fpml:period"/>'.</text>
</error>
</xsl:if>
<xsl:if test="rollConvention">
<xsl:call-template name="isValidRollConvention">
<xsl:with-param name="elementName">rollConvention</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:rollConvention"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:variable name="href1">
<xsl:value-of select="fpml:buyerPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="href2">
<xsl:value-of select="fpml:sellerPartyReference/@href"/>
</xsl:variable>
<xsl:if test="$href1=$href2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***buyerPartyReference/@href and sellerPartyReference/@href values must not be the same.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:party[@id=$href1])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***buyerPartyReference/@href does not reference a valid party/@id. Value = '<xsl:value-of select="$href1"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:party[@id=$href2])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***sellerPartyReference/@href does not reference a valid party/@id. Value = '<xsl:value-of select="$href2"/>'.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:notional">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">fixedRate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:fixedRate"/>
</xsl:with-param>
<xsl:with-param name="minIncl">-9.9999999999</xsl:with-param>
<xsl:with-param name="maxIncl">9.9999999999</xsl:with-param>
<xsl:with-param name="maxDecs">10</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="fpml:floatingRateIndex">
<xsl:variable name="floatingRateIndex">
<xsl:value-of select="fpml:floatingRateIndex"/>
</xsl:variable>
<xsl:if test="$floatingRateIndex=''">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Empty floatingRateIndex.</text>
</error>
</xsl:if>
<xsl:if test="$tradeCurrency != 'PLN'">
<xsl:variable name="floatingRateIndexCurrency">
<xsl:value-of select="substring($floatingRateIndex,1,3)"/>
</xsl:variable>
<xsl:if test="$tradeCurrency != $floatingRateIndexCurrency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** floatingRateIndex value of '<xsl:value-of select="$floatingRateIndex"/>' is not valid for trade currency of '<xsl:value-of select="$tradeCurrency"/>'.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
<xsl:if test="count(fpml:party)!=2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of party child elements encountered. Exactly 2 expected.</text>
</error>
</xsl:if>
<xsl:variable name="id1">
<xsl:value-of select="fpml:party[1]/@id"/>
</xsl:variable>
<xsl:variable name="id2">
<xsl:value-of select="fpml:party[2]/@id"/>
</xsl:variable>
<xsl:if test="$id1=$id2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** party[1]/@id and party[2]/@id values must not be the same.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:party">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:swOisParameters">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="fpml:swProductSubType">
<xsl:call-template name="isValidProductSubType">
<xsl:with-param name="elementName">swProductSubType</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swProductSubType"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">tradeDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:tradeDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:apply-templates select="swSwapTermTenor">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:adjustedEffectiveDate">
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">adjustedEffectiveDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:adjustedEffectiveDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swUnadjustedTerminationDate">
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">swUnadjustedTerminationDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swUnadjustedTerminationDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:rollConvention">
<xsl:call-template name="isValidRollConvention">
<xsl:with-param name="elementName">rollConvention</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:rollConvention"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:apply-templates select="fpml:swFixedAmounts">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:swAssociatedBonds">
<xsl:if test="not($tradeCurrency = 'USD' or $tradeCurrency = 'CAD')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swAssociatedBonds should only be present if trade currency is equal to 'USD' or 'CAD'. Value = '<xsl:value-of select="$tradeCurrency"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:swAssociatedBonds">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:notional">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:fixedRate">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">fixedRate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:fixedRate"/>
</xsl:with-param>
<xsl:with-param name="minIncl">-9.9999999999</xsl:with-param>
<xsl:with-param name="maxIncl">9.9999999999</xsl:with-param>
<xsl:with-param name="maxDecs">10</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:fixedAmount">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">fixedAmount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:fixedAmount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.01</xsl:with-param>
<xsl:with-param name="maxIncl">3999999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:floatingRateIndex">
<xsl:variable name="floatingRateIndex">
<xsl:value-of select="fpml:floatingRateIndex"/>
</xsl:variable>
<xsl:if test="$floatingRateIndex=''">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Empty or missing floatingRateIndex.</text>
</error>
</xsl:if>
<xsl:if test="$tradeCurrency != 'PLN'">
<xsl:variable name="floatingRateIndexCurrency">
<xsl:value-of select="substring($floatingRateIndex,1,3)"/>
</xsl:variable>
<xsl:if test="$tradeCurrency != $floatingRateIndexCurrency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** floatingRateIndex value of '<xsl:value-of select="$floatingRateIndex"/>' is not valid for trade currency of '<xsl:value-of select="$tradeCurrency"/>'.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:additionalTerms">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="count(fpml:party)!=2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of party child elements encountered. Exactly 2 expected.</text>
</error>
</xsl:if>
<xsl:variable name="id1">
<xsl:value-of select="fpml:party[1]/@id"/>
</xsl:variable>
<xsl:variable name="id2">
<xsl:value-of select="fpml:party[2]/@id"/>
</xsl:variable>
<xsl:if test="$id1=$id2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** party[1]/@id and party[2]/@id values must not be the same.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:party">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:settlementProvision">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:swIrsParameters">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:call-template name="isValidShortFormCompoundingMethod">
<xsl:with-param name="floatPaymentFrequency">
<xsl:value-of select="$swShortFormTrade/fpml:swIrsParameters/fpml:swFloatPaymentFrequency/fpml:periodMultiplier"/>
<xsl:value-of select="$swShortFormTrade/fpml:swIrsParameters/fpml:swFloatPaymentFrequency/fpml:period"/>
</xsl:with-param>
<xsl:with-param name="floatRollFrequency">
<xsl:value-of select="$swShortFormTrade/fpml:swIrsParameters/fpml:swRollFrequency/fpml:periodMultiplier"/>
<xsl:value-of select="$swShortFormTrade/fpml:swIrsParameters/fpml:swRollFrequency/fpml:period"/>
</xsl:with-param>
<xsl:with-param name="compoundingMethod">
<xsl:value-of select="$swShortFormTrade/fpml:swIrsParameters/fpml:swCompoundingMethod"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="fpml:swProductSubType">
<xsl:call-template name="isValidProductSubType">
<xsl:with-param name="elementName">swProductSubType</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swProductSubType"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">tradeDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:tradeDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:apply-templates select="fpml:swSwapTermTenor">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:adjustedEffectiveDate">
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">adjustedEffectiveDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:adjustedEffectiveDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swUnadjustedTerminationDate">
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">swUnadjustedTerminationDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swUnadjustedTerminationDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:rollConvention">
<xsl:call-template name="isValidRollConvention">
<xsl:with-param name="elementName">rollConvention</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:rollConvention"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swRollFrequency">
<xsl:apply-templates select="fpml:swRollFrequency">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
<xsl:if test="fpml:swFloatPaymentFrequency">
<xsl:apply-templates select="fpml:swFloatPaymentFrequency">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
<xsl:if test="fpml:swFixedPaymentFrequency">
<xsl:apply-templates select="fpml:swFixedPaymentFrequency">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
<xsl:if test="fpml:swCompoundingMethod">
<xsl:apply-templates select="fpml:swCompoundingMethod">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
<xsl:if test="fpml:swStubPosition">
<xsl:call-template name="isValidStubPosition">
<xsl:with-param name="elementName">swStubPosition</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swStubPosition"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swFixedStubLength">
<xsl:apply-templates select="fpml:swFixedStubLength">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
<xsl:if test="fpml:swFloatStubLength">
<xsl:apply-templates select="fpml:swFloatStubLength">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
<xsl:if test="fpml:swStubIndexTenor">
<xsl:apply-templates select="fpml:swStubIndexTenor">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
<xsl:apply-templates select="fpml:swFixedAmounts">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:swEarlyTerminationProvision">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:swAssociatedBonds">
<xsl:if test="not($tradeCurrency = 'USD' or $tradeCurrency = 'CAD')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swAssociatedBonds should only be present if trade currency is equal to 'USD' or 'CAD'. Value = '<xsl:value-of select="$tradeCurrency"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:swAssociatedBonds">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:notional">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:fixedRate">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">fixedRate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:fixedRate"/>
</xsl:with-param>
<xsl:with-param name="minIncl">-9.9999999999</xsl:with-param>
<xsl:with-param name="maxIncl">9.9999999999</xsl:with-param>
<xsl:with-param name="maxDecs">10</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:fixedAmount">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">fixedAmount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:fixedAmount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.01</xsl:with-param>
<xsl:with-param name="maxIncl">3999999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:floatingRateIndex">
<xsl:variable name="floatingRateIndex">
<xsl:value-of select="fpml:floatingRateIndex"/>
</xsl:variable>
<xsl:if test="$floatingRateIndex=''">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Empty or missing floatingRateIndex.</text>
</error>
</xsl:if>
<xsl:if test="$tradeCurrency != 'PLN' and $floatingRateIndex != 'CNH-HIBOR-TMA' and $floatingRateIndex != 'CNH-HIBOR'">
<xsl:variable name="floatingRateIndexCurrency">
<xsl:value-of select="substring($floatingRateIndex,1,3)"/>
</xsl:variable>
<xsl:if test="$tradeCurrency != $floatingRateIndexCurrency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** floatingRateIndex value of '<xsl:value-of select="$floatingRateIndex"/>' is not valid for trade currency of '<xsl:value-of select="$tradeCurrency"/>'.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:initialRate">
<xsl:variable name="initialRate">
<xsl:value-of select="fpml:initialRate"/>
</xsl:variable>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">initialRate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$initialRate"/>
</xsl:with-param>
<xsl:with-param name="minIncl">-9.9999999999</xsl:with-param>
<xsl:with-param name="maxIncl">9.9999999999</xsl:with-param>
<xsl:with-param name="maxDecs">10</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:apply-templates select="fpml:additionalTerms">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="count(fpml:party)!=2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of party child elements encountered. Exactly 2 expected.</text>
</error>
</xsl:if>
<xsl:variable name="id1">
<xsl:value-of select="fpml:party[1]/@id"/>
</xsl:variable>
<xsl:variable name="id2">
<xsl:value-of select="fpml:party[2]/@id"/>
</xsl:variable>
<xsl:if test="$id1=$id2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** party[1]/@id and party[2]/@id values must not be the same.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:party">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:settlementProvision">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:swFixedFixedParameters">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="fpml:swProductSubType">
<xsl:call-template name="isValidProductSubType">
<xsl:with-param name="elementName">swProductSubType</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swProductSubType"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">tradeDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:tradeDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:apply-templates select="fpml:swSwapTermTenor">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:adjustedEffectiveDate">
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">adjustedEffectiveDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:adjustedEffectiveDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swUnadjustedTerminationDate">
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">swUnadjustedTerminationDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swUnadjustedTerminationDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:rollConvention">
<xsl:call-template name="isValidRollConvention">
<xsl:with-param name="elementName">rollConvention</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:rollConvention"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swFixedPaymentFrequency">
<xsl:apply-templates select="fpml:swFixedPaymentFrequency">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
<xsl:if test="fpml:swFixed2PaymentFrequency">
<xsl:apply-templates select="fpml:swFixed2PaymentFrequency">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
<xsl:if test="fpml:swStubPosition">
<xsl:call-template name="isValidStubPosition">
<xsl:with-param name="elementName">swStubPosition</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swStubPosition"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swFixedStubLength">
<xsl:apply-templates select="fpml:swFixedStubLength">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
<xsl:if test="fpml:swFixed2StubLength">
<xsl:apply-templates select="fpml:swFixed2StubLength">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
<xsl:apply-templates select="fpml:swFixedAmounts">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:swEarlyTerminationProvision">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:swAssociatedBonds">
<xsl:if test="not($tradeCurrency = 'USD' or $tradeCurrency = 'CAD')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swAssociatedBonds should only be present if trade currency is equal to 'USD' or 'CAD'. Value = '<xsl:value-of select="$tradeCurrency"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:swAssociatedBonds">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:notional">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:swNotional2">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:fixedRate">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">fixedRate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:fixedRate"/>
</xsl:with-param>
<xsl:with-param name="minIncl">-9.9999999999</xsl:with-param>
<xsl:with-param name="maxIncl">9.9999999999</xsl:with-param>
<xsl:with-param name="maxDecs">10</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:fixedRate2">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">fixedRate2</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:fixedRate2"/>
</xsl:with-param>
<xsl:with-param name="minIncl">-9.9999999999</xsl:with-param>
<xsl:with-param name="maxIncl">9.9999999999</xsl:with-param>
<xsl:with-param name="maxDecs">10</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:fixedAmount">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">fixedAmount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:fixedAmount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.01</xsl:with-param>
<xsl:with-param name="maxIncl">3999999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:fixedAmount2">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">fixedAmount2</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:fixedAmount2"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.01</xsl:with-param>
<xsl:with-param name="maxIncl">3999999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:initialRate">
<xsl:variable name="initialRate">
<xsl:value-of select="fpml:initialRate"/>
</xsl:variable>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">initialRate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$initialRate"/>
</xsl:with-param>
<xsl:with-param name="minIncl">-9.9999999999</xsl:with-param>
<xsl:with-param name="maxIncl">9.9999999999</xsl:with-param>
<xsl:with-param name="maxDecs">10</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:apply-templates select="fpml:additionalTerms">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="count(fpml:party)!=2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of party child elements encountered. Exactly 2 expected.</text>
</error>
</xsl:if>
<xsl:if test="fpml:principalExchanges and ($tradeCurrency=$tradeCurrency2)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** partyExchange tag is not allowed for Single Currency Fixed Fixed Swap trade.</text>
</error>
</xsl:if>
<xsl:variable name="id1">
<xsl:value-of select="fpml:party[1]/@id"/>
</xsl:variable>
<xsl:variable name="id2">
<xsl:value-of select="fpml:party[2]/@id"/>
</xsl:variable>
<xsl:if test="$id1=$id2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** party[1]/@id and party[2]/@id values must not be the same.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:party">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:settlementProvision">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:swBasisSwapParameters">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">tradeDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:tradeDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:apply-templates select="fpml:swSwapTermTenor">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:adjustedEffectiveDate">
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">adjustedEffectiveDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:adjustedEffectiveDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swUnadjustedTerminationDate">
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">swUnadjustedTerminationDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swUnadjustedTerminationDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:rollConvention">
<xsl:call-template name="isValidRollConvention">
<xsl:with-param name="elementName">rollConvention</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:rollConvention"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swStubPosition">
<xsl:call-template name="isValidStubPosition">
<xsl:with-param name="elementName">swStubPosition</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swStubPosition"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swStubPosition and fpml:rollConvention">
<xsl:variable name="rollConvention">
<xsl:value-of select="fpml:rollConvention"/>
</xsl:variable>
<xsl:if test="starts-with($rollConvention,'IMM') and not(//fpml:swStubPosition[.='Start'])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swStubPosition must equal 'Start' if rollConvention is equal to 'IMM'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:swEarlyTerminationProvision">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="count(fpml:swFloatingRateCalculation)!=2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of swFloatingRateCalculation child elements encountered. Exactly 2 expected.</text>
</error>
</xsl:if>
<xsl:if test="$swLongFormTrade">
<xsl:choose>
<xsl:when test="$productType='Cross Currency IRS'">
<xsl:variable name="href1">
<xsl:value-of select="fpml:swFloatingRateCalculation[@id='fixedLeg']/fpml:payerPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="href2">
<xsl:value-of select="fpml:swFloatingRateCalculation[@id='floatingLeg']/fpml:payerPartyReference/@href"/>
</xsl:variable>
</xsl:when>
<xsl:when test="$productType='Fixed Fixed Swap'">
<xsl:variable name="href1">
<xsl:value-of select="fpml:swFloatingRateCalculation[@id='fixedLeg']/fpml:payerPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="href2">
<xsl:value-of select="fpml:swFloatingRateCalculation[@id='fixedLeg2']/fpml:payerPartyReference/@href"/>
</xsl:variable>
</xsl:when>
<xsl:otherwise>
<xsl:variable name="href1">
<xsl:value-of select="fpml:swFloatingRateCalculation[@id='floatingLeg']/fpml:payerPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="href2">
<xsl:value-of select="fpml:swFloatingRateCalculation[@id='floatingLeg2']/fpml:payerPartyReference/@href"/>
</xsl:variable>
</xsl:otherwise>
</xsl:choose>
<xsl:if test="$href1=$href2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** payerPartyReference values must not be the same on both legs.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$swShortFormTrade">
<xsl:variable name="href1">
<xsl:value-of select="$swShortFormTrade/fpml:swBasisSwapParameters/fpml:swFloatingRateCalculation[1]/fpml:payerPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="href2">
<xsl:value-of select="$swShortFormTrade/fpml:swBasisSwapParameters/fpml:swFloatingRateCalculation[2]/fpml:payerPartyReference/@href"/>
</xsl:variable>
</xsl:if>
<xsl:apply-templates select="fpml:swFloatingRateCalculation">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="count(fpml:party)!=2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of party child elements encountered. Exactly 2 expected.</text>
</error>
</xsl:if>
<xsl:variable name="id1">
<xsl:value-of select="fpml:party[1]/@id"/>
</xsl:variable>
<xsl:variable name="id2">
<xsl:value-of select="fpml:party[2]/@id"/>
</xsl:variable>
<xsl:if test="$id1=$id2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** party[1]/@id and party[2]/@id values must not be the same.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:party">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:settlementProvision">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:swCrossCurrencyBasisSwapParameters">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="test_id_leg1">
<xsl:value-of select="$swShortFormTrade/fpml:swCrossCurrencyBasisSwapParameters/fpml:swFloatingRateCalculation[1]/@id"/>
</xsl:variable>
<xsl:variable name="test_val_leg1">
<xsl:value-of select="$swShortFormTrade/fpml:swCrossCurrencyBasisSwapParameters/fpml:swFloatingRateCalculation[@id=$test_id_leg1]/fpml:notional/fpml:amount"/>
</xsl:variable>
<xsl:if test="($test_val_leg1='')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Notional Amount for Leg 1 for a Cross Currency Basis Swap product cannot be empty ***</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:swFloatingRateCalculation">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="href1">
<xsl:value-of select="fpml:payerPartyReference/@href"/>
</xsl:variable>
<xsl:if test="not(../fpml:party[@id=$href1])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** payerPartyReference/@href does not reference a valid ..:/party/@id. Value = '<xsl:value-of select="$href1"/>'.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:notional">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:floatingRateIndex">
<xsl:variable name="floatingRateIndex">
<xsl:value-of select="fpml:floatingRateIndex"/>
</xsl:variable>
<xsl:if test="$floatingRateIndex=''">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Empty or missing floatingRateIndex.</text>
</error>
</xsl:if>
<xsl:if test="$tradeCurrency != 'PLN'">
<xsl:variable name="floatingRateIndexCurrency">
<xsl:value-of select="substring($floatingRateIndex,1,3)"/>
</xsl:variable>
<xsl:if test="$tradeCurrency != $floatingRateIndexCurrency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** floatingRateIndex value of '<xsl:value-of select="$floatingRateIndex"/>' is not valid for trade currency of '<xsl:value-of select="$tradeCurrency"/>'.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:indexTenor">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:swFloatingRateMultiplier">
<xsl:variable name="floatingratemultiplier">
<xsl:value-of select="fpml:swFloatingRateMultiplier"/>
</xsl:variable>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">initialRate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$floatingratemultiplier"/>
</xsl:with-param>
<xsl:with-param name="minIncl">-9.9999999</xsl:with-param>
<xsl:with-param name="maxIncl">9.9999999</xsl:with-param>
<xsl:with-param name="maxDecs">7</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:initialRate">
<xsl:variable name="initialRate">
<xsl:value-of select="fpml:initialRate"/>
</xsl:variable>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">initialRate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$initialRate"/>
</xsl:with-param>
<xsl:with-param name="minIncl">-9.9999999999</xsl:with-param>
<xsl:with-param name="maxIncl">9.9999999999</xsl:with-param>
<xsl:with-param name="maxDecs">10</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:swZCInflationSwapParameters">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">tradeDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:tradeDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:apply-templates select="fpml:swSwapTermTenor">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:adjustedEffectiveDate">
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">adjustedEffectiveDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:adjustedEffectiveDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:apply-templates select="fpml:swFixedAmounts">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:swEarlyTerminationProvision">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:notional">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:fixedRate">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">fixedRate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:fixedRate"/>
</xsl:with-param>
<xsl:with-param name="minIncl">-9.9999999999</xsl:with-param>
<xsl:with-param name="maxIncl">9.9999999999</xsl:with-param>
<xsl:with-param name="maxDecs">10</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:fixedAmount">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">fixedAmount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:fixedAmount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.01</xsl:with-param>
<xsl:with-param name="maxIncl">999999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swInflationRateCalculation/fpml:swFloatingRateIndex">
<xsl:variable name="floatingRateIndex">
<xsl:value-of select="fpml:swInflationRateCalculation/fpml:swFloatingRateIndex"/>
</xsl:variable>
<xsl:if test="$floatingRateIndex=''">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Empty or missing floatingRateIndex.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:swInflationRateCalculation/fpml:swInflationLag">
<xsl:variable name="inflationLag">
<xsl:value-of select="fpml:swInflationRateCalculation/fpml:swInflationLag/fpml:periodMultiplier"/>
<xsl:value-of select="fpml:swInflationRateCalculation/fpml:swInflationLag/fpml:period"/>
</xsl:variable>
<xsl:call-template name="isValidInflationLag">
<xsl:with-param name="elementName">inflationLag</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$inflationLag"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swInflationRateCalculation/fpml:swInitialIndexLevel">
<xsl:variable name="initialIndexLevel">
<xsl:value-of select="fpml:swInflationRateCalculation/fpml:swInitialIndexLevel"/>
</xsl:variable>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swInitialIndexLevel</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$initialIndexLevel"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.0000000000</xsl:with-param>
<xsl:with-param name="maxIncl">1000.0000000000</xsl:with-param>
<xsl:with-param name="maxDecs">10</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swInflationRateCalculation/fpml:indexSource">
<xsl:if test="fpml:swInflationRateCalculation/fpml:indexSource=''">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** indexSource is empty.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:swInflationRateCalculation/fpml:swInterpolationMethod">
<xsl:variable name="interpolationMethod">
<xsl:value-of select="fpml:swInflationRateCalculation/fpml:swInterpolationMethod"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$interpolationMethod='Linear'"/>
<xsl:when test="$interpolationMethod='None'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** interpolationMethod, if supplied, must be equal to 'Linear' or 'None'. Value = '<xsl:value-of select="$interpolationMethod"/>'. '<xsl:value-of select="fpml:swInflationRateCalculation/fpml:inflationLag/fpml:swInterpolationMethod"/>'</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="fpml:swInflationRateCalculation/fpml:swRelatedBond">
<xsl:variable name="relatedBond">
<xsl:value-of select="fpml:swInflationRateCalculation/fpml:swRelatedBond"/>
</xsl:variable>
<xsl:if test="string-length($relatedBond) &gt; 12">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid instrumentId string length. Exceeded max length of 12 characters for productType 'ZCInflationSwap'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="count(fpml:party)!=2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of party child elements encountered. Exactly 2 expected.</text>
</error>
</xsl:if>
<xsl:variable name="id1">
<xsl:value-of select="fpml:party[1]/@id"/>
</xsl:variable>
<xsl:variable name="id2">
<xsl:value-of select="fpml:party[2]/@id"/>
</xsl:variable>
<xsl:if test="$id1=$id2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** party[1]/@id and party[2]/@id values must not be the same.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:party">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:swSwaptionParameters">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:call-template name="isValidShortFormCompoundingMethod">
<xsl:with-param name="floatPaymentFrequency">
<xsl:value-of select="$swShortFormTrade/fpml:swSwaptionParameters/fpml:swFloatPaymentFrequency/fpml:periodMultiplier"/>
<xsl:value-of select="$swShortFormTrade/fpml:swSwaptionParameters/fpml:swFloatPaymentFrequency/fpml:period"/>
</xsl:with-param>
<xsl:with-param name="floatRollFrequency">
<xsl:value-of select="$swShortFormTrade/fpml:swSwaptionParameters/fpml:swRollFrequency/fpml:periodMultiplier"/>
<xsl:value-of select="$swShortFormTrade/fpml:swSwaptionParameters/fpml:swRollFrequency/fpml:period"/>
</xsl:with-param>
<xsl:with-param name="compoundingMethod">
<xsl:value-of select="$swShortFormTrade/fpml:swSwaptionParameters/fpml:swCompoundingMethod"/>
</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">tradeDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:tradeDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:variable name="href1">
<xsl:value-of select="fpml:buyerPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="href2">
<xsl:value-of select="fpml:sellerPartyReference/@href"/>
</xsl:variable>
<xsl:if test="$href1=$href2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***buyerPartyReference/@href and fpml:sellerPartyReference/@href values must not be the same.</text>
</error>
</xsl:if>
<xsl:if test="not(//fpml:party[@id=$href1])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***buyerPartyReference/@href does not reference a valid party/@id. Value = '<xsl:value-of select="$href1"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not(//fpml:party[@id=$href2])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***sellerPartyReference/@href does not reference a valid party/@id. Value = '<xsl:value-of select="$href2"/>'.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:swPremium">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:swEuropeanExercise">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">swaptionStraddle</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swaptionStraddle"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">swCashSettlement</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swCashSettlement"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:apply-templates select="fpml:swSwapTermTenor">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:adjustedEffectiveDate">
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">adjustedEffectiveDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:adjustedEffectiveDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swUnadjustedTerminationDate">
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">swUnadjustedTerminationDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swUnadjustedTerminationDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:rollConvention">
<xsl:call-template name="isValidRollConvention">
<xsl:with-param name="elementName">rollConvention</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:rollConvention"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swRollFrequency">
<xsl:apply-templates select="fpml:swRollFrequency">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
<xsl:if test="fpml:swFloatPaymentFrequency">
<xsl:apply-templates select="fpml:swFloatPaymentFrequency">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
<xsl:if test="fpml:swFixedPaymentFrequency">
<xsl:apply-templates select="fpml:swFixedPaymentFrequency">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
<xsl:if test="fpml:swCompoundingMethod">
<xsl:apply-templates select="fpml:swCompoundingMethod">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
<xsl:if test="fpml:swStubPosition">
<xsl:call-template name="isValidStubPosition">
<xsl:with-param name="elementName">swStubPosition</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swStubPosition"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swStubPosition and fpml:rollConvention">
<xsl:variable name="rollConvention">
<xsl:value-of select="fpml:rollConvention"/>
</xsl:variable>
<xsl:if test="starts-with($rollConvention,'IMM') and not(//fpml:swStubPosition[.='Start'])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swStubPosition must equal 'Start' if rollConvention is equal to 'IMM'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:swFixedStubLength">
<xsl:apply-templates select="fpml:swFixedStubLength">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
<xsl:if test="fpml:swFloatStubLength">
<xsl:apply-templates select="fpml:swFloatStubLength">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
<xsl:if test="fpml:swStubIndexTenor">
<xsl:apply-templates select="fpml:swStubIndexTenor">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
<xsl:apply-templates select="fpml:swFixedAmounts">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:swEarlyTerminationProvision">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:notional">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">fixedRate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:fixedRate"/>
</xsl:with-param>
<xsl:with-param name="minIncl">-9.9999999999</xsl:with-param>
<xsl:with-param name="maxIncl">9.9999999999</xsl:with-param>
<xsl:with-param name="maxDecs">10</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="fpml:floatingRateIndex">
<xsl:variable name="floatingRateIndex">
<xsl:value-of select="fpml:floatingRateIndex"/>
</xsl:variable>
<xsl:if test="$floatingRateIndex=''">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Empty or missing floatingRateIndex.</text>
</error>
</xsl:if>
<xsl:if test="$tradeCurrency != 'PLN' and $floatingRateIndex != 'CNH-HIBOR-TMA' and $floatingRateIndex != 'CNH-HIBOR'">
<xsl:variable name="floatingRateIndexCurrency">
<xsl:value-of select="substring($floatingRateIndex,1,3)"/>
</xsl:variable>
<xsl:if test="$tradeCurrency != $floatingRateIndexCurrency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** floatingRateIndex value of '<xsl:value-of select="$floatingRateIndex"/>' is not valid for trade currency of '<xsl:value-of select="$tradeCurrency"/>'.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
<xsl:if test="count(fpml:party)!=2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of party child elements encountered. Exactly 2 expected.</text>
</error>
</xsl:if>
<xsl:variable name="id1">
<xsl:value-of select="fpml:party[1]/@id"/>
</xsl:variable>
<xsl:variable name="id2">
<xsl:value-of select="fpml:party[2]/@id"/>
</xsl:variable>
<xsl:if test="$id1=$id2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** party[1]/@id and party[2]/@id values must not be the same.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:party">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:swPremium">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:call-template name="isValidCurrency">
<xsl:with-param name="elementName">paymentAmount/currency</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:paymentAmount/fpml:currency"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:variable name="amount">
<xsl:value-of select="fpml:paymentAmount/fpml:amount"/>
</xsl:variable>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">paymentAmount/amount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$amount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.01</xsl:with-param>
<xsl:with-param name="maxIncl">3999999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">swPaymentDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swPaymentDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:template>
<xsl:template match="fpml:swEuropeanExercise">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">swExpirationDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swExpirationDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:template>
<xsl:template match="fpml:swFixedAmounts">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="href1">
<xsl:value-of select="fpml:payerPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="href2">
<xsl:value-of select="fpml:receiverPartyReference/@href"/>
</xsl:variable>
<xsl:if test="$href1=$href2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** payerPartyReference/@href and receiverPartyReference/@href values must not be the same.</text>
</error>
</xsl:if>
<xsl:if test="not(../fpml:party[@id=$href1])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** payerPartyReference/@href does not reference a valid ..:/party/@id. Value = '<xsl:value-of select="$href1"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not(../fpml:party[@id=$href2])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** receiverPartyReference/@href does not reference a valid ../party/@id. Value = '<xsl:value-of select="$href2"/>'.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:swStructuredTradeDetails">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:call-template name="isValidProductType">
<xsl:with-param name="elementName">swProductType</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swProductType"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:apply-templates select="fpml:FpML">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:swOfflineTrade">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:swExtendedTradeDetails">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:swBusinessConductDetails">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="//fpml:cancelableProvision">
<xsl:if test="not($productType = 'IRS' or $productType = 'OIS')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** cancelableProvision should only be present if product type is 'SingleCurrencyInterestRateSwap' or 'OIS'.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:swExtendedTradeDetails">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:apply-templates select="fpml:swTradeHeader">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:swStub">
<xsl:if test="not($productType ='IRS' or $productType ='OIS' or $productType='Swaption' or $productType='Single Currency Basis Swap' or $productType='CapFloor' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='Fixed Fixed Swap' or ($productType='ZCInflationSwap' and //fpml:couponRate))">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swStub should only be present if product type is 'SingleCurrencyInterestRateSwap', 'OIS', 'Swaption',  'Single Currency Basis Swap', 'CapFloor' or 'Cross Currency Basis Swap' or 'Cross Currency IRS'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$productType='Single Currency Basis Swap' and count(fpml:swStub)=2 and ($isNettingInstruction='true' or $isTransitionEvent='true' or $isClearingTakeup='true')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swStub must not occur twice, indicating front and back stubs, if product type is 'Single Currency Basis Swap'.</text>
</error>
</xsl:if>
<xsl:variable name="frontAndBackStubs">
<xsl:choose>
<xsl:when test="($productType='IRS' or $productType='OIS') and count(fpml:swStub)=2">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:if test="$frontAndBackStubs='true'">
<xsl:if test="not(fpml:swStub[1]/fpml:swStubPosition='Start' and fpml:swStub[2]/fpml:swStubPosition='End')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swStub instances must relate to start and end stubs respectively.  swStub[1]/swStubPosition value ='<xsl:value-of select="fpml:swStub[1]/fpml:swStubPosition"/>'.  swStub[2]/swStubPosition value ='<xsl:value-of select="fpml:swStub[2]/fpml:swStubPosition"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:swStub">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
<xsl:with-param name="frontAndBackStubs">
<xsl:value-of select="$frontAndBackStubs"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="$productType ='Fixed Fixed Swap' and $tradeCurrency != $tradeCurrency2 and count(fpml:swStub)=2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Front and Back stubs are allowed only when Currency on both legs are same.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swEarlyTerminationProvision">
<xsl:if test="not($productType ='IRS' or $productType='ZCInflationSwap' or $productType='Swaption' or $productType='Single Currency Basis Swap' or $productType='CapFloor' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='OIS' or $productType='Fixed Fixed Swap')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swEarlyTerminationProvision should only be present if product type is 'SingleCurrencyInterestRateSwap',  'Swaption', 'Single Currency Basis Swap', 'CapFloor' or 'Cross Currency Basis Swap' or 'Cross Currency IRS' or 'OIS' or 'Fixed Fixed Swap'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:swEarlyTerminationProvision">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:swAssociatedBonds">
<xsl:if test="not($productType ='IRS' or $productType ='OIS') or not($tradeCurrency = 'USD' or $tradeCurrency = 'CAD')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swAssociatedBonds should only be present if product type is 'SingleCurrencyInterestRateSwap' or 'OIS' and trade currency is equal to 'USD' or 'CAD'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:swAssociatedBonds">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="count(fpml:additionalPayment) &gt; 8">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of additionalPayment child elements encountered. 0 to 8 expected.</text>
</error>
</xsl:if>
<xsl:if test="count(fpml:additionalPayment) = 7">
<xsl:if test="not(//fpml:additionalPayment[fpml:paymentType = 'Independent Amount'] or fpml:additionalPayment[fpml:paymentType = 'Cancellation'])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** If seven additionalPayment child elements are present then one must be identified as an Independent Amount (paymentType = 'Independent Amount') or Cancellation (paymentType = 'Cancellation').</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="count(fpml:additionalPayment) = 8">
<xsl:if test="not(//fpml:additionalPayment[fpml:paymentType = 'Independent Amount'] and fpml:additionalPayment[fpml:paymentType = 'Cancellation'])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** If eight additionalPayment child elements are present then one must be identified as an Independent Amount (paymentType = 'Independent Amount') and one a Cancellation (paymentType = 'Independent Amount').</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="count(fpml:additionalPayment[fpml:paymentType = 'Independent Amount']) &gt; 1">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** A maximum of one additionalPayment child element can be identified as an Independent Amount (paymentType = 'Independent Amount').</text>
</error>
</xsl:if>
<xsl:if test="count(fpml:additionalPayment[fpml:paymentType = 'Cancellation']) &gt; 1">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** A maximum of one additionalPayment child element can be identified as a Cancellation (paymentType = 'Cancellation').</text>
</error>
</xsl:if>
<xsl:if test="fpml:additionalPayment">
<xsl:if test="not($productType='FRA' or $productType='Swaption')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** additionalPayment is only allowed in this context if product type is 'FRA' or 'Swaption'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:additionalPayment">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:swFutureValue">
<xsl:if test="not($productType='IRS' and $tradeCurrency='BRL')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swFutureValue should only be present if product type is 'IRS' and currency is 'BRL''. Values are '<xsl:value-of select="$productType"/>', '<xsl:value-of select="$tradeCurrency"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:swFutureValue">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:swSettlementProvision">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:swModificationEffectiveDate">
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">swModificationEffectiveDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swModificationEffectiveDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swAmendmentType">
<xsl:if test="not(fpml:swAmendmentType='Exit' or fpml:swAmendmentType='Amendment' or fpml:swAmendmentType='ErrorCorrection' or fpml:swAmendmentType='PartialTermination' or fpml:swAmendmentType='FixingOnly')">
<error>
<context><xsl:value-of select="$newContext"/>/swAmendmentType
</context>
<text>*** valid values are 'Exit', 'Amendment', 'ErrorCorrection', 'PartialTermination' or 'FixingOnly'.  Value='<xsl:value-of select="fpml:swAmendmentType"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:swCancellationType">
<xsl:if test="not(fpml:swCancellationType='BookedInError') and not(fpml:swCancellationType='CancellableExercise')">
<error>
<context><xsl:value-of select="$newContext"/>/swCancellationType
</context>
<text>*** element, if present, can only contain the value 'BookedInError' or 'CancellableExercise'.  Value='<xsl:value-of select="fpml:swCancellationType"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:swCancellationType">
<xsl:if test="fpml:swCancellationType='CancellableExercise' and not (//fpml:cancelableProvision)">
<error>
<context><xsl:value-of select="$newContext"/>/swCancellationType
</context>
<text>*** element, if present, can only contain the value 'CancellableExercise' when trade has a cancelableProvision.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:swCancellationType and $productType='Swaption'">
<xsl:if test="fpml:swCancellationType='BookedInError' and fpml:swForwardPremium='true'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Value of swForwardPremium is invalid for swCancellationType 'BookedInError'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:swAmendmentType and fpml:swCancellationType">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** amendment type and cancellation type cannot both be present.  Amendment type is '<xsl:value-of select="fpml:swAmendmentType"/>'.  Cancellation type is '<xsl:value-of select="fpml:swCancellationType"/>.'</text>
</error>
</xsl:if>
<xsl:if test="fpml:swOutsideNovation">
<xsl:if test="not($productType='IRS' or $productType='OIS')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swOutsideNovation should only be present if product type is 'IRS' or 'OIS'. Product Type is  '<xsl:value-of select="$productType"/>.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:swOutsideNovation">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:swFxCutoffTime">
<xsl:if test="not($productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='Fixed Fixed Swap')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swFxCutoffTime should only be present if product type is 'Cross Currency Basis Swap' or 'Cross Currency IRS'.</text>
</error>
</xsl:if>
<xsl:if test="$MarkToMarket!='true' and ($productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='Fixed Fixed Swap')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swFxCutoffTime should only be present if product type is 'Cross Currency Basis Swap' or 'Cross Currency IRS' and MarkToMarket is True.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:swFxCutoffTime">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:swCrossCurrencyMethod">
<xsl:if test="not($productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swCrossCurrencyMethod should only be present if product type is 'Cross Currency Basis Swap' or 'Cross Currency IRS'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:swCrossCurrencyMethod">
<xsl:if test="not(fpml:swEarlyTerminationProvision)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swCrossCurrencyMethod should only be present if swEarlyTerminationProvision is also present.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="(($swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swCrossCurrencyMethod) and    ($trade/fpml:swap/fpml:earlyTerminationProvision//fpml:cashSettlement[fpml:cashPriceMethod | fpml:cashPriceAlternateMethod | fpml:parYieldCurveUnadjustedMethod | fpml:zeroCouponYieldAdjustedMethod]))">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Only one cash settlement method can be specified. If swCrossCurrencyMethod is present then neither cashPriceMethod, cashPriceAlternateMethod, parYieldCurveUnadjustedMethod or zeroCouponYieldAdjustedMethod can be present within .//earlyTerminationProvision//cashSettlement</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:swCrossCurrencyMethod">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:swEarlyTerminationProvision/fpml:swCollateralizedCashPrice">
<xsl:if test="not($productType='IRS' or $productType='Cross Currency IRS' or $productType='OIS' or $productType='Swaption' or $productType='ZCInflationSwap')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swCollateralizedCashPrice (Break Settlement) should only be present if product type is 'IRS', 'Cross Currency IRS', 'OIS', 'Swaption' or 'ZC Inflation Swap'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="(($swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swEarlyTerminationProvision/fpml:swCollateralizedCashPrice) and ($swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swCrossCurrencyMethod or $trade/fpml:swap/fpml:earlyTerminationProvision//fpml:cashSettlement[fpml:cashPriceMethod | fpml:cashPriceAlternateMethod | fpml:parYieldCurveUnadjustedMethod | fpml:zeroCouponYieldAdjustedMethod]))">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Only one cash settlement method can be specified. If swCollateralizedCashPrice (Break Settlement) is present then neither cashPriceMethod, cashPriceAlternateMethod, parYieldCurveUnadjustedMethod, zeroCouponYieldAdjustedMethod or swCrossCurrencyMethod can be present.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:swEarlyTerminationProvision/fpml:swCollateralizedCashPrice">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:swAgreedDiscountRate">
<xsl:if test="not($productType='Swaption')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swAgreedDiscountRate is not valid for product type '<xsl:value-of select="$productType"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$trade/fpml:swaption/fpml:cashSettlement/fpml:midMarketValuation">
<xsl:if test="$trade/fpml:swaption/fpml:cashSettlement/fpml:midMarketValuation//fpml:agreedDiscountRate">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Agreed Discount Rate is only allowed when Swaption Cash Method is 'Collateralized Cash Price'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:swCollateralizedCashPrice">
<xsl:choose>
<xsl:when test="not($productType='Swaption')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swCollateralizedCashPrice should only be present if product type is 'Swaption'.</text>
</error>
</xsl:when>
<xsl:when test="$trade/fpml:documentation/fpml:contractualDefinitions='ISDA2000'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swCollateralizedCashPrice is not valid under stated ContractualDefinitions.  Value = '<xsl:value-of select="$trade/fpml:documentation/fpml:contractualDefinitions"/>'.</text>
</error>
</xsl:when>
<xsl:when test="(($swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swCollateralizedCashPrice) and ($trade/fpml:swaption/fpml:cashSettlement[fpml:cashPriceMethod | fpml:cashPriceAlternateMethod | fpml:parYieldCurveUnadjustedMethod | fpml:zeroCouponYieldAdjustedMethod]))">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Only one swaption cash settlement method can be specified. If swCollateralizedCashPrice is present then neither cashPriceMethod, cashPriceAlternateMethod, parYieldCurveUnadjustedMethod or zeroCouponYieldAdjustedMethod can be present within ../FpML/trade/swaption/cashSettlement</text>
</error>
</xsl:when>
<xsl:otherwise>
<xsl:apply-templates select="fpml:swCollateralizedCashPrice">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:swTradeHeader">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="fpml:swOriginatingEvent">
<xsl:choose>
<xsl:when test="fpml:swOriginatingEvent=''"/>
<xsl:when test="fpml:swOriginatingEvent='Bunched Order Block'"/>
<xsl:when test="fpml:swOriginatingEvent='Bunched Order Allocation'"/>
<xsl:when test="fpml:swOriginatingEvent='Backload'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***swOriginatingEvent element value is not supported. Supported values are '', 'Bunched Order Block', 'Bunched Order Allocation', 'Backload' (for backloaded trade). Value = '<xsl:value-of select="fpml:swOriginatingEvent"/>'."/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="$productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS'">
<xsl:if test="$swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swTradeHeader/fpml:swSendToCLS">
<xsl:choose>
<xsl:when test="$swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swTradeHeader/fpml:swSendToCLS/fpml:swSettlementLegEligibility[@swSettlementLeg='Initial Exchange'] or $swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swTradeHeader/fpml:swSendToCLS/fpml:swSettlementLegEligibility[@swSettlementLeg='Final Exchange']">
<xsl:if test="swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swTradeHeader/fpml:swSendToCLS/fpml:swSettlementLegEligibility[@swSettlementLeg='Initial Exchange']">
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">swSettlementLegEligibility/swSettlementLeg='Initial Exchange'</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swTradeHeader/fpml:swSendToCLS/fpml:swSettlementLegEligibility[@swSettlementLeg='Initial Exchange']"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$context"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test=" $swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swTradeHeader/fpml:swSendToCLS/fpml:swSettlementLegEligibility[@swSettlementLeg='Final Exchange']">
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">swSettlementLegEligibility/swSettlementLeg='Final Exchange'</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swTradeHeader/fpml:swSendToCLS/fpml:swSettlementLegEligibility[@swSettlementLeg='Final Exchange']"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$context"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:variable name="isClsOnIE">
<xsl:value-of select="$swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swTradeHeader/fpml:swSendToCLS/fpml:swSettlementLegEligibility[@swSettlementLeg='Initial Exchange']"/>
</xsl:variable>
<xsl:variable name="isClsOnFE">
<xsl:value-of select="$swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swTradeHeader/fpml:swSendToCLS/fpml:swSettlementLegEligibility[@swSettlementLeg='Final Exchange']"/>
</xsl:variable>
<xsl:if test="$swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swTradeHeader/fpml:swClearingHouse and ($isClsOnIE = 'true' or $isClsOnFE = 'true')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swClearingHouse and swSendToCLS with CLS true for any leg should not be provided together.</text>
</error>
</xsl:if>
</xsl:when>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***swSendToCLS element should only be present if one of the applicable leg or both are present.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:if>
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">swManualConfirmationRequired</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swManualConfirmationRequired"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="fpml:swNovationExecution">
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">swNovationExecution</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swNovationExecution"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="fpml:swNovationExecution='true' and fpml:swManualConfirmationRequired !='false'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swManualConfirmationRequired must be set to 'false' if swNovationExecution is set to 'true'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$productType='Offline Trade Rates'">
<xsl:if test="not(//fpml:swClearingNotRequired[. = 'true'])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swClearingNotRequired must be equal to 'true' if product type is 'Offline Trade Rates. Value = '<xsl:value-of select="fpml:swClearingNotRequired"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$productType='IRS' or $productType='OIS' or $productType='FRA' or $productType='Swaption' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='Fixed Fixed Swap'">
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">swClearingNotRequired</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swClearingNotRequired"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="not(//fpml:swStandardSettlementInstructions[. = 'true'])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swStandardSettlementInstructions must be equal to 'true'. Value = '<xsl:value-of select="fpml:swStandardSettlementInstructions"/>'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swAssociatedTrades">
<xsl:if test="not (fpml:swClearingTakeup)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***swAssociatedTrades must only be present when swClearingTakeup is present</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:swNormalised">
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">swNormalised</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swNormalised"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="not($productType='IRS' or $productType='OIS' or $productType='Single Currency Basis Swap')">
<xsl:if test="fpml:swNormalised">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swNormalised must not be present if product type is not equal to 'SingleCurrencyInterestRateSwap', 'OIS' or 'Single Currency Basis Swap'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:swClientClearing">
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">swClientClearing</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swClientClearing"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="not($productType='IRS' or $productType='OIS' or $productType='FRA' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='Equity Index Option' or $productType='ZCInflationSwap'or $productType='Swaption')">
<xsl:if test="fpml:swClientClearing">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swClientClearing must not be present if product type is not equal to 'SingleCurrencyInterestRateSwap' or 'OIS' or 'FRA' or 'Single Currency Basis Swap' or 'Cross Currency Basis Swap' or 'Cross Currency IRS' or 'Equity Index Option' or 'ZCInflationSwap' or 'Swaption'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:swAutoSendForClearing">
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">swAutoSendForClearing</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swAutoSendForClearing"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="not($productType='IRS' or $productType='OIS' or $productType='FRA' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType ='ZCInflationSwap' or $productType ='Swaption')">
<xsl:if test="fpml:swAutoSendForClearing">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swAutoSendForClearing must not be present if product type is not equal to 'SingleCurrencyInterestRateSwap' or 'OIS' or 'FRA' or 'Single Currency Basis Swap' or 'Cross Currency Basis Swap' or 'Cross Currency IRS' or 'ZC Inflation Swap' or 'Swaption'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:swInteroperable">
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">swInteroperable</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swInteroperable"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="not($productType='IRS' or $productType='Swaption')">
<xsl:if test="fpml:swInteroperable">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swInteroperable must not be present if product type is not equal to 'SingleCurrencyInterestRateSwap' or 'Swaption'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:swExternalInteropabilityId">
<xsl:if test="fpml:swClientClearing !='true' or not (fpml:swClientClearing)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swExternalInteropabilityId can only be present if swClientClearing is true.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:swInteropNettingString">
<xsl:if test="fpml:swClientClearing !='true' or not (fpml:swClientClearing)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swInteropNettingString can only be present if swClientClearing is true.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:swClearedPhysicalSettlement">
<xsl:choose>
<xsl:when test="not($productType='Swaption')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swClearedPhysicalSettlement should only be present if product type is 'Swaption'.</text>
</error>
</xsl:when>
<xsl:when test="$trade/fpml:swaption/fpml:cashSettlement">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swClearedPhysicalSettlement should not be present when cash settlement method specified.</text>
</error>
</xsl:when>
<xsl:when test="$trade/fpml:documentation/fpml:contractualDefinitions='ISDA2000'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swClearedPhysicalSettlement is not valid under stated swContractualDefinitions. Value = '<xsl:value-of select="$trade/fpml:documentation/fpml:contractualDefinitions"/>'.</text>
</error>
</xsl:when>
<xsl:when test="fpml:swClearedPhysicalSettlement !='true'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swClearedPhysicalSettlement must be set to 'true' if present. Value = '<xsl:value-of select="fpml:swClearedPhysicalSettlement"/>'.</text>
</error>
</xsl:when>
</xsl:choose>
</xsl:if>
<xsl:if test="fpml:swPredeterminedClearerForUnderlyingSwap">
<xsl:if test="not($productType='Swaption')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swPredeterminedClearerForUnderlyingSwap should only be present if product type is 'Swaption'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:swPricedToClearCCP">
<xsl:if test="not($productType='Swaption' or $productType='OIS' or $productType='FRA' or $productType='ZCInflationSwap' or $productType='Fixed Fixed Swap' or $productType='IRS' or $productType='Single Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='Cross Currency Basis Swap')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swPricedToClearCCP is not valid for product type '<xsl:value-of select="$productType"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="//fpml:swBackLoadingFlag">
<xsl:if test="not(//fpml:swBackLoadingFlag[. = 'true'])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swBackLoadingFlag must be equal to 'true'. Value = '<xsl:value-of select="fpml:swBackLoadingFlag"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="//fpml:swBackLoadingFlag">
<xsl:if test="(//fpml:swBackLoadingFlag[. != 'true'] and //fpml:swOriginatingEvent ='Backload') or (//fpml:swBackLoadingFlag[. = 'true'] and //fpml:swOriginatingEvent !='Backload')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***  Invalid combination of swBackLoadingFlag and swOriginatingEvent. Either both values must indicate a 'backload' or neither. Value = '<xsl:value-of select="//fpml:swBackLoadingFlag"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="$swStructuredTradeDetails//fpml:swExtendedTradeDetails/fpml:swTradeHeader/fpml:swMandatoryClearing">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="//fpml:swCBTradeType">
<xsl:if test="not(//fpml:swCBClearedTimestamp) or (//fpml:swCBClearedTimestamp = '')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid timestamp. swCBClearedTimestamp must have a valid non empty value.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:swStub">
<xsl:param name="context"/>
<xsl:param name="frontAndBackStubs"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:call-template name="isValidStubPosition">
<xsl:with-param name="elementName">swStubPosition</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swStubPosition"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="fpml:swStubPosition[.='Start'] and not($frontAndBackStubs='true')">
<xsl:if test="$trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:stubCalculationPeriodAmount/fpml:finalStub">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swStubPosition value of 'Start' is inconsistent with presence of floating leg /stubCalculationPeriodAmount/finalStub element.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:swStubPosition[.='End'] and not($frontAndBackStubs='true')">
<xsl:if test="$trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:stubCalculationPeriodAmount/fpml:initialStub">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swStubPosition value of 'End' is inconsistent with presence of floating leg //stubCalculationPeriodAmount/initialStub element.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:for-each select="fpml:swStubLength">
<xsl:call-template name="isValidStubLength">
<xsl:with-param name="elementName">swStubLength[<xsl:number value="position()"/>]</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="."/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:variable name="href">
<xsl:value-of select="@href"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$productType='CapFloor'">
<xsl:if test="not(//fpml:FpML/fpml:trade//fpml:capFloor/fpml:capFloorStream[@id=$href])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swStubLength[<xsl:number value="position()"/>]/@href does not reference a valid //FpML/trade//capFloor/capFloorStream/@id. Value = '<xsl:value-of select="$href"/>'.</text>
</error>
</xsl:if>
</xsl:when>
<xsl:otherwise>
<xsl:if test="not(//fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[@id=$href])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swStubLength[<xsl:number value="position()"/>]/@href does not reference a valid //FpML/trade//swap/swapStream/@id. Value = '<xsl:value-of select="$href"/>'.</text>
</error>
</xsl:if>
</xsl:otherwise>
</xsl:choose>
</xsl:for-each>
<xsl:if test="fpml:swStubLength[2]">
<xsl:if test="count(fpml:swStubLength)=2">
<xsl:variable name="href1">
<xsl:value-of select="fpml:swStubLength[1]/@href"/>
</xsl:variable>
<xsl:variable name="href2">
<xsl:value-of select="fpml:swStubLength[2]/@href"/>
</xsl:variable>
<xsl:if test="$href1=$href2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swStubLength[1]/@href and swStubLength[2]/@href values must not be the same.</text>
</error>
</xsl:if>
<xsl:if test="$productType='CapFloor'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** A maximum of 1 swStubLength value can be specified if product type is 'CapFloor'.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:additionalPayment|fpml:payment">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:variable name="href1">
<xsl:value-of select="fpml:payerPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="href2">
<xsl:value-of select="fpml:receiverPartyReference/@href"/>
</xsl:variable>
<xsl:if test="$href1=$href2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** payerPartyReference/@href and receiverPartyReference/@href values must not be the same.</text>
</error>
</xsl:if>
<xsl:choose>
<xsl:when test="$productType='Offline Trade Rates'">
<xsl:if test="not(//fpml:swOfflineTrade/fpml:party[@id=$href1])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** payerPartyReference/@href does not reference a valid /swOfflineTrade/trade/party/@id. Value = '<xsl:value-of select="$href1"/>'.</text>
</error>
</xsl:if>
</xsl:when>
<xsl:otherwise>
<xsl:if test="not(//fpml:FpML/fpml:party[@id=$href1])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** payerPartyReference/@href does not reference a valid /FpML/trade/party/@id. Value = '<xsl:value-of select="$href1"/>'.</text>
</error>
</xsl:if>
</xsl:otherwise>
</xsl:choose>
<xsl:choose>
<xsl:when test="$productType='Offline Trade Rates'">
<xsl:if test="not(//fpml:swOfflineTrade/fpml:party[@id=$href1])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** payerPartyReference/@href does not reference a valid /swOfflineTrade/trade/party/@id. Value = '<xsl:value-of select="$href1"/>'.</text>
</error>
</xsl:if>
</xsl:when>
<xsl:otherwise>
<xsl:if test="not(//fpml:FpML/fpml:party[@id=$href2])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** receiverPartyReference/@href does not reference a valid /FpML/trade/party/@id. Value = '<xsl:value-of select="$href2"/>'.</text>
</error>
</xsl:if>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="fpml:paymentAmount">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:variable name="paymentTypeDesc">
<xsl:value-of select="fpml:paymentType"/>
</xsl:variable>
<xsl:if test="not(//fpml:paymentDate) and $paymentTypeDesc != 'Independent Amount'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing paymentDate. Required in this context unless paymentType equals 'Independent Amount'.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:paymentDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:variable name="paymentDate">
<xsl:value-of select="fpml:paymentDate/fpml:unadjustedDate"/>
</xsl:variable>
<xsl:variable name="payDate">
<xsl:value-of select="number(concat(substring($paymentDate,1,4),substring($paymentDate,6,2),substring($paymentDate,9,2)))"/>
</xsl:variable>
<xsl:if test="../fpml:additionalPayment/fpml:paymentType and $paymentTypeDesc != '' and $payDate &gt;= 20171001">
<xsl:call-template name="isValidPaymentType">
<xsl:with-param name="elementName">paymentType</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$paymentTypeDesc"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:novatedAmount|fpml:swNovatedFV|fpml:swNovatedAmount">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:call-template name="isValidCurrency">
<xsl:with-param name="elementName">currency</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:currency"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="not ($MarkToMarket='true' and self::fpml:swNovatedAmount and ($productType='Cross Currency IRS' or $productType='Cross Currency Basis Swap') and (fpml:amount &gt;= 0))">
<xsl:variable name="amount">
<xsl:value-of select="fpml:amount"/>
</xsl:variable>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">amount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$amount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.01</xsl:with-param>
<xsl:with-param name="maxIncl">3999999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:independentAmount/fpml:paymentDetail/fpml:paymentAmount">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:call-template name="isValidCurrency">
<xsl:with-param name="elementName">currency</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:currency"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:variable name="amount">
<xsl:value-of select="fpml:amount"/>
</xsl:variable>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">amount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$amount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.00</xsl:with-param>
<xsl:with-param name="maxIncl">999999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:template>
<xsl:template match="fpml:payment/fpml:paymentAmount">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:call-template name="isValidCurrency">
<xsl:with-param name="elementName">currency</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:currency"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:variable name="amount">
<xsl:value-of select="fpml:amount"/>
</xsl:variable>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">amount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$amount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.01</xsl:with-param>
<xsl:with-param name="maxIncl">3999999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:template>
<xsl:template match="fpml:paymentAmount">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:call-template name="isValidCurrency">
<xsl:with-param name="elementName">currency</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:currency"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:variable name="amount">
<xsl:value-of select="fpml:amount"/>
</xsl:variable>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">amount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$amount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.01</xsl:with-param>
<xsl:with-param name="maxIncl">999999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:template>
<xsl:template match="fpml:swOfflineTrade">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="count(fpml:party)&lt; 2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of party child elements encountered. At least 2 expected.</text>
</error>
</xsl:if>
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">swTradeDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swTradeDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="fpml:expirationDate">
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">expirationDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:effectiveDate"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:effectiveDate">
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">effectiveDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:effectiveDate"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:terminationDate">
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">terminationDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:terminationDate"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swOfflineProductType">
<xsl:choose>
<xsl:when test="fpml:swOfflineProductType='Basis Swap'"/>
<xsl:when test="fpml:swOfflineProductType='Cap'"/>
<xsl:when test="fpml:swOfflineProductType='FRA'"/>
<xsl:when test="fpml:swOfflineProductType='Floor'"/>
<xsl:when test="fpml:swOfflineProductType='IRS'"/>
<xsl:when test="fpml:swOfflineProductType='OIS'"/>
<xsl:when test="fpml:swOfflineProductType='Swaption'"/>
<xsl:when test="fpml:swOfflineProductType='ZC Inflation Swap'"/>
<xsl:when test="fpml:swOfflineProductType='Cross Currency Basis Swap'"/>
<xsl:when test="fpml:swOfflineProductType='Cross Currency IRS'"/>
<xsl:when test="fpml:swOfflineProductType='Other'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid product type for Novation Consent.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="fpml:swOfflineProductType='Cap' or fpml:swOfflineProductType='FRA' or fpml:swOfflineProductType='Floor' or fpml:swOfflineProductType='Swaption'">
<xsl:if test="count(fpml:swLegDetails) = 2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** only one swLegDetails component expected for offline products of Cap, FRA, Floor, Swaption.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:swSpread">
<xsl:variable name="spreadPayer">
<xsl:value-of select="//fpml:swSpread/fpml:payerPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="spreadReceiver">
<xsl:value-of select="//fpml:swSpread/fpml:receiverPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="Incoming">
<xsl:value-of select="$swLongFormTrade/fpml:novation/fpml:transferee/@href"/>
</xsl:variable>
<xsl:if test="not(//fpml:swOfflineTrade/fpml:party[@id=$spreadPayer])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** spread payer Party/@href does not reference a valid /swOfflineTrade/trade/party/@id. Value = '<xsl:value-of select="$spreadPayer"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not(//fpml:swOfflineTrade/fpml:party[@id=$spreadReceiver])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** spread receiver Party/@href does not reference a valid /swOfflineTrade/trade/party/@id. Value = '<xsl:value-of select="$spreadReceiver"/>'.</text>
</error>
</xsl:if>
<xsl:if test="$spreadPayer = $spreadReceiver">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** spread payer and receiver Party/@href must not be the same</text>
</error>
</xsl:if>
<xsl:if test="$spreadPayer = $Incoming">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** spread payer and Incoming Party/@href must not be the same</text>
</error>
</xsl:if>
<xsl:if test="$spreadReceiver = $Incoming">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** spread receiver and Incoming Party/@href must not be the same</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$swLongFormTrade/fpml:novation/fpml:novatedAmount">
<xsl:if test="$swLongFormTrade/fpml:novation/fpml:novatedAmount/fpml:amount &gt; //fpml:swLegDetails[1]/fpml:notional/fpml:amount">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** novated amount must not be greater than original trade amount of Leg1</text>
</error>
</xsl:if>
<xsl:if test="$swLongFormTrade/fpml:novation/fpml:novatedAmount/fpml:currency != //fpml:swLegDetails[1]/fpml:notional/fpml:currency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** novated amount currency must be the same as currency for original trade of Leg1</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$swLongFormTrade/fpml:novation/fpml:swNovatedAmount">
<xsl:if test="$swLongFormTrade/fpml:novation/fpml:swNovatedAmount/fpml:amount &gt; //fpml:swLegDetails[2]/fpml:notional/fpml:amount">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** novated amount must not be greater than original trade amount of Leg2</text>
</error>
</xsl:if>
<xsl:if test="$swLongFormTrade/fpml:novation/fpml:swNovatedAmount/fpml:currency != //fpml:swLegDetails[2]/fpml:notional/fpml:currency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** novated amount currency must be the same as currency for original trade of Leg2</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:swLegDetails">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:swOriginalTradeReferences">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:party">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:swLegDetails">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="Party1">
<xsl:choose>
<xsl:when test="fpml:payerPartyReference/@href">
<xsl:value-of select="fpml:payerPartyReference/@href"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="fpml:buyerPartyReference/@href"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="Party2">
<xsl:choose>
<xsl:when test="fpml:receiverPartyReference/@href">
<xsl:value-of select="fpml:receiverPartyReference/@href"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="fpml:sellerPartyReference/@href"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="IncomingParty">
<xsl:value-of select="$swLongFormTrade/fpml:novation/fpml:transferee/@href"/>
</xsl:variable>
<xsl:if test="$Party1 != ''">
<xsl:if test="not(//fpml:swOfflineTrade/fpml:party[@id=$Party1])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** payer or buyer Party/@href does not reference a valid /swOfflineTrade/trade/party/@id. Value = '<xsl:value-of select="$Party1"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$Party2 != ''">
<xsl:if test="not(//fpml:swOfflineTrade/fpml:party[@id=$Party2])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** receiver or seller Party/@href does not reference a valid /swOfflineTrade/trade/party/@id. Value = '<xsl:value-of select="$Party2"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:fixedRate and fpml:indexTenor">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** both fixedRate element and indexTenor element must not be present for a leg</text>
</error>
</xsl:if>
<xsl:if test="fpml:swOfflineProductType='Swaption'">
<xsl:choose>
<xsl:when test="fpml:swOptionType='Payers'"/>
<xsl:when test="fpml:swOptionType='Receivers'"/>
<xsl:when test="fpml:swOptionType='Straddle'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid option type for offline product. Valid options are Payers, Receivers, Straddle</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="fpml:swOfflineProductType!='Swaption' and fpml:swOptionType">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Option type not required if offline product type is not Swaption</text>
</error>
</xsl:if>
<xsl:if test="//fpml:swOfflineProductType='Cap' or //fpml:swOfflineProductType='FRA' or //fpml:swOfflineProductType='Floor' or //fpml:swOfflineProductType='Swaption'">
<xsl:if test="fpml:payerPartyReference">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** payer / receiver Party not valid for offline product types of Cap, FRA, Floor, Swaption.</text>
</error>
</xsl:if>
<xsl:if test="fpml:floatingRateIndex">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** floating rate indices not valid for offline product types of Cap, FRA, Floor, Swaption.</text>
</error>
</xsl:if>
<xsl:if test="fpml:indexTenor">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** index tenor not valid for offline product types of Cap, FRA, Floor, Swaption.</text>
</error>
</xsl:if>
<xsl:if test="fpml:paymentFrequency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** payment frequency not valid for offline product types of Cap, FRA, Floor, Swaption.</text>
</error>
</xsl:if>
<xsl:if test="//fpml:swNovatedAmount">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swNovatedAmount element not valid for offline product types of Cap, FRA, Floor, Swaption.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="//fpml:swOfflineProductType='Basis Swap' or //fpml:swOfflineProductType='IRS' or //fpml:swOfflineProductType='OIS' or  //fpml:swOfflineProductType='ZC Inflation Swap' or //fpml:swOfflineProductType='Cross Currency IRS'">
<xsl:if test="fpml:buyerPartyReference">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** buyer / seller Party not valid for offline product types of Basis Swap, IRS, OIS, ZC Inflation Swap,Cross Currency IRS.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:swOriginalTradeReferences">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:for-each select="fpml:swOriginalTradeReference">
<xsl:variable name="OrigRef">
<xsl:value-of select="fpml:partyReference/@href"/>
</xsl:variable>
<xsl:variable name="StepinParty">
<xsl:value-of select="$swLongFormTrade/fpml:novation/fpml:transferee/@href"/>
</xsl:variable>
<xsl:if test="not(//fpml:swOfflineTrade/fpml:party[@id=$OrigRef])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Original reference Party/@href does not reference a valid /swOfflineTrade/trade/party/@id. Value = '<xsl:value-of select="$OrigRef"/>'.</text>
</error>
</xsl:if>
<xsl:if test="$OrigRef = $StepinParty">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Original reference Party/@href and transferee/@href values must not be the same</text>
</error>
</xsl:if>
</xsl:for-each>
</xsl:template>
<xsl:template match="fpml:FpML">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="not($FpMLVersion='4-2')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid version attribute. Value = '<xsl:value-of select="$FpMLVersion"/>'.</text>
</error>
</xsl:if>
<xsl:if test="count(fpml:party)&lt; 2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of party child elements encountered. At least 2 expected.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:party">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:trade">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:trade">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:apply-templates select="fpml:tradeHeader">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:capFloor">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:fra">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:swap">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:swaption">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:calculationAgent">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:collateral">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:documentation">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:tradeHeader">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">tradeDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:tradeDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:apply-templates select="fpml:partyTradeIdentifier">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:partyTradeIdentifier">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:variable name="href">
<xsl:value-of select="fpml:partyReference/@href"/>
</xsl:variable>
<xsl:if test="not(//fpml:FpML/fpml:party[@id=$href])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** partyReference/@href does not reference a valid FpML/trade/party/@id. Value = '<xsl:value-of select="$href"/>'.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:premium">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="href1">
<xsl:value-of select="fpml:payerPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="href2">
<xsl:value-of select="fpml:receiverPartyReference/@href"/>
</xsl:variable>
<xsl:if test="not(//fpml:FpML/fpml:party[@id=$href1])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** payerPartyReference/@href does not reference a valid /swOfflineTrade/trade/party/@id. Value = '<xsl:value-of select="$href1"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not(//fpml:FpML/fpml:party[@id=$href2])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** receiverPartyReference/@href does not reference a valid /FpML/trade/party/@id. Value = '<xsl:value-of select="$href2"/>'.</text>
</error>
</xsl:if>
<xsl:if test="$href1=$href2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** payerPartyReference/@href and receiverPartyReference/@href values are the same.</text>
</error>
</xsl:if>
<xsl:if test="$productType='CapFloor'">
<xsl:call-template name="isValidCurrency">
<xsl:with-param name="elementName">paymentAmount/currency</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:paymentAmount/fpml:currency"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:variable name="amount">
<xsl:value-of select="fpml:paymentAmount/fpml:amount"/>
</xsl:variable>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">paymentAmount/amount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$amount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.01</xsl:with-param>
<xsl:with-param name="maxIncl">3999999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="fpml:paymentDate/fpml:dateAdjustments[fpml:businessDayConvention!='FOLLOWING']">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** paymentDate/dateAdjustments/businessDayConvention must be equal to 'FOLLOWING'. Value = '<xsl:value-of select="fpml:paymentDate/fpml:dateAdjustments/fpml:businessDayConvention"/>'</text>
</error>
</xsl:if>
<xsl:variable name="tradeDate">
<xsl:value-of select="$SWDML/fpml:swStructuredTradeDetails//fpml:FpML/fpml:trade//fpml:tradeHeader/fpml:tradeDate"/>
</xsl:variable>
<xsl:variable name="paymentDate">
<xsl:value-of select="fpml:paymentDate/fpml:unadjustedDate"/>
</xsl:variable>
<xsl:variable name="trdDate">
<xsl:value-of select="number(concat(substring($tradeDate,1,4),substring($tradeDate,6,2),substring($tradeDate,9,2)))"/>
</xsl:variable>
<xsl:variable name="payDate">
<xsl:value-of select="number(concat(substring($paymentDate,1,4),substring($paymentDate,6,2),substring($paymentDate,9,2)))"/>
</xsl:variable>
<xsl:if test="$payDate &lt; $trdDate">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The premium payment date (paymentDate/fpml:unadjustedDate) must be greater than or equal to the tradeDate.  Value = '<xsl:value-of select="fpml:paymentDate/fpml:unadjustedDate"/>'.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:paymentDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:call-template name="isValidBusinessCenter">
<xsl:with-param name="elementName">businessCenter</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:paymentDate/fpml:dateAdjustments/fpml:businessCenters/fpml:businessCenter"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="assetClass">
<xsl:value-of select="$assetClass"/>
</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:template>
<xsl:template match="fpml:exerciseProcedure">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="not(fpml:automaticExercise) and not(fpml:manualExercise)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing automaticExercise or manualExercise element. Required in this context'.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:automaticExercise">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:manualExercise">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:followUpConfirmation">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:automaticExercise">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">thresholdRate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:thresholdRate"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">9.9999999</xsl:with-param>
<xsl:with-param name="maxDecs">7</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:template>
<xsl:template match="fpml:manualExercise">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="not(fpml:fallbackExercise)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing fallbackExercise element. Required in this context'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:fallbackExercise!='true'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** fallbackExercise element must have the value of 'true' in SwapsWire.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:followUpConfirmation">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">followUpConfirmation</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="../fpml:followUpConfirmation"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:template>
<xsl:template match="fpml:collateral">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="payerPartyRef">
<xsl:value-of select="fpml:independentAmount/fpml:payerPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="receiverPartyRef">
<xsl:value-of select="fpml:independentAmount/fpml:receiverPartyReference/@href"/>
</xsl:variable>
<xsl:if test="$payerPartyRef=$receiverPartyRef">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** fpml:payerPartyReference/@href and receiverPartyReference/@href values must not be the same.</text>
</error>
</xsl:if>
<xsl:if test="not(//fpml:FpML/fpml:party[@id=$payerPartyRef])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** fpml:payerPartyReference/@href does not reference a valid FpML/trade/party/@id. Value = '<xsl:value-of select="$payerPartyRef"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not(//fpml:FpML/fpml:party[@id=$receiverPartyRef])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** receiverPartyReference/@href does not reference a valid FpML/trade/party/@id. Value = '<xsl:value-of select="$receiverPartyRef"/>'.</text>
</error>
</xsl:if>
<xsl:variable name="payerPartyId">
<xsl:value-of select="//fpml:FpML/fpml:party[@id=$payerPartyRef]/fpml:partyId"/>
</xsl:variable>
<xsl:variable name="receiverPartyId">
<xsl:value-of select="//fpml:FpML/fpml:party[@id=$receiverPartyRef]/fpml:partyId"/>
</xsl:variable>
<xsl:apply-templates select="fpml:independentAmount/fpml:paymentDetail">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:capFloor">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="not($productType='CapFloor')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** /SWDML/swLongFormTrade/swStructuredTradeDetails/swProductType must be equal to 'CapFloor' if capFloor element is present.</text>
</error>
</xsl:if>
<xsl:variable name="effectiveDate">
<xsl:value-of select="fpml:capFloorStream/fpml:calculationPeriodDates/fpml:effectiveDate/fpml:unadjustedDate"/>
</xsl:variable>
<xsl:variable name="tradeDate">
<xsl:value-of select="$trade/fpml:tradeHeader/fpml:tradeDate"/>
</xsl:variable>
<xsl:variable name="effDate">
<xsl:value-of select="number(concat(substring($effectiveDate,1,4),substring($effectiveDate,6,2),substring($effectiveDate,9,2)))"/>
</xsl:variable>
<xsl:variable name="trdDate">
<xsl:value-of select="number(concat(substring($tradeDate,1,4),substring($tradeDate,6,2),substring($tradeDate,9,2)))"/>
</xsl:variable>
<xsl:if test="$trdDate &gt; $effDate">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The tradeDate must be less than or equal to the effectiveDate.</text>
</error>
</xsl:if>
<xsl:if test="count(fpml:additionalPayment) &gt; 6">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of additionalPayment child elements encountered. 0 to 6 expected.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:capFloorStream">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="additionalPayment">
<xsl:variable name="optionBuyer">
<xsl:value-of select="fpml:capFloorStream/receiverPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="optionSeller">
<xsl:value-of select="fpml:capFloorStream/payerPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="premiumPayer">
<xsl:value-of select="fpml:additionalPayment/payerPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="premiumReceiver">
<xsl:value-of select="fpml:additionalPayment/receiverPartyReference/@href"/>
</xsl:variable>
<xsl:if test="$optionBuyer!=$premiumPayer">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** capFloorStream/receiverPartyReference/@href (buyer) and additionalPayment/payerPartyReference/@href (premium payer) values are not the same.</text>
</error>
</xsl:if>
<xsl:if test="$optionSeller!=$premiumReceiver">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** capFloorStream/receiverPartyReference/@href (seller) and additionalPayment/payerPartyReference/@href (premium receiver) values are not the same.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:premium">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:additionalPayment">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:earlyTerminationProvision">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:capFloorStream">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="href1">
<xsl:value-of select="fpml:payerPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="href2">
<xsl:value-of select="fpml:receiverPartyReference/@href"/>
</xsl:variable>
<xsl:if test="not(//fpml:FpML/fpml:party[@id=$href1])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** payerPartyReference/@href does not reference a valid /swOfflineTrade/trade/party/@id. Value = '<xsl:value-of select="$href1"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not(//fpml:FpML/fpml:party[@id=$href2])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** receiverPartyReference/@href does not reference a valid /FpML/trade/party/@id. Value = '<xsl:value-of select="$href2"/>'.</text>
</error>
</xsl:if>
<xsl:if test="$href1=$href2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** payerPartyReference/@href and receiverPartyReference/@href values are the same.</text>
</error>
</xsl:if>
<xsl:variable name="periodMultiplier1">
<xsl:value-of select="fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:periodMultiplier"/>
</xsl:variable>
<xsl:variable name="periodMultiplier2">
<xsl:value-of select="fpml:paymentDates/fpml:paymentFrequency/fpml:periodMultiplier"/>
</xsl:variable>
<xsl:variable name="period1">
<xsl:value-of select="fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:period"/>
</xsl:variable>
<xsl:variable name="period2">
<xsl:value-of select="fpml:paymentDates/fpml:paymentFrequency/fpml:period"/>
</xsl:variable>
<xsl:if test="not($periodMultiplier1 = $periodMultiplier2) or not($period1 = $period2)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The calculationPeriodDates/calculationPeriodFrequency and paymentDates/paymentFrequency do not match. They must match because compounding is not allowed if product type is 'CapFloor'.</text>
</error>
</xsl:if>
<xsl:variable name="rollConvention">
<xsl:value-of select="fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:rollConvention"/>
</xsl:variable>
<xsl:variable name="floatCalcPayFreqCombo">
<xsl:value-of select="$periodMultiplier1"/>
<xsl:value-of select="$period1"/>
<xsl:value-of select="$periodMultiplier2"/>
<xsl:value-of select="$period2"/>
</xsl:variable>
<xsl:if test="starts-with($rollConvention,'IMM') and $swExtendedTradeDetails/fpml:swCapFloorDetails/fpml:swFloatingRateFixingDate/fpml:unadjustedDate = ''">
<xsl:choose>
<xsl:when test="$floatCalcPayFreqCombo='1M1M'"/>
<xsl:when test="$floatCalcPayFreqCombo='3M3M'"/>
<xsl:when test="$floatCalcPayFreqCombo='6M6M'"/>
<xsl:when test="$floatCalcPayFreqCombo='1Y1Y'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The calculationPeriodDates/calculationPeriodFrequency and paymentDates/paymentFrequency combination is invalid for IMM rolls (must be 1M/1M, 3M/3M, 6M/6M or 1Y/1Y).</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:variable name="businessDayConvention1">
<xsl:value-of select="fpml:calculationPeriodDates/fpml:calculationPeriodDatesAdjustments/fpml:businessDayConvention"/>
</xsl:variable>
<xsl:variable name="businessDayConvention2">
<xsl:value-of select="fpml:paymentDates/fpml:paymentDatesAdjustments/fpml:businessDayConvention"/>
</xsl:variable>
<xsl:variable name="businessDayConvention3">
<xsl:choose>
<xsl:when test="$swExtendedTradeDetails/fpml:swCapFloorDetails/fpml:swFloatingRateFixingDate/fpml:unadjustedDate = ''">
<xsl:value-of select="fpml:resetDates/fpml:resetDatesAdjustments/fpml:businessDayConvention"/>
</xsl:when>
<xsl:otherwise><xsl:value-of select="$businessDayConvention1"/></xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:choose>
<xsl:when test="$businessDayConvention1 != 'NONE'">
<xsl:if test="not(($businessDayConvention1 = $businessDayConvention2) and ($businessDayConvention1 = $businessDayConvention3))">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The calculationPeriodDatesAdjustments/businessDayConvention, paymentDatesAdjustments/businessDayConvention and resetDatesAdjustments/businessDayConvention do not match.</text>
</error>
</xsl:if>
</xsl:when>
<xsl:when test="$businessDayConvention1 = 'NONE' and $tradeCurrency !='BRL'">
<xsl:if test="$businessDayConvention3 != 'NONE'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The calculationPeriodDatesAdjustments/businessDayConvention and resetDatesAdjustments/businessDayConvention do not match.</text>
</error>
</xsl:if>
</xsl:when>
<xsl:otherwise>
<xsl:if test="not($businessDayConvention2 = $businessDayConvention3)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The paymentDatesAdjustments/businessDayConvention and resetDatesAdjustments/businessDayConvention do not match.</text>
</error>
</xsl:if>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="fpml:calculationPeriodDates">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:paymentDates">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="not(fpml:resetDates) and ($swExtendedTradeDetails/fpml:swCapFloorDetails/fpml:swFloatingRateFixingDate/fpml:unadjustedDate = '')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** resetDates must be present within capFloorStream.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:resetDates">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:calculationPeriodAmount">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:settlementProvision">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** settlementProvision should only be present if product type is 'SingleCurrencyInterestRateSwap' or 'OIS' or 'Swaption'. Value = '<xsl:value-of select="$productType"/>' .</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:stubCalculationPeriodAmount">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:swaption">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="buyerhref1">
<xsl:value-of select="fpml:buyerPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="sellerhref2">
<xsl:value-of select="fpml:sellerPartyReference/@href"/>
</xsl:variable>
<xsl:if test="$buyerhref1=$sellerhref2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***buyerPartyReference/@href and sellerPartyReference/@href values must not be the same.</text>
</error>
</xsl:if>
<xsl:if test="not(//fpml:FpML/fpml:party[@id=$buyerhref1])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***buyerPartyReference/@href does not reference a valid /FpML/party/@id. Value = '<xsl:value-of select="$buyerhref1"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not(//fpml:FpML/fpml:party[@id=$sellerhref2])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***sellerPartyReference/@href does not reference a valid /FpML/party/@id. Value = '<xsl:value-of select="$sellerhref2"/>'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:premium">
<xsl:variable name="payer">
<xsl:value-of select="fpml:premium/fpml:payerPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="receiver">
<xsl:value-of select="fpml:premium/fpml:receiverPartyReference/@href"/>
</xsl:variable>
<xsl:if test="$buyerhref1!=$payer">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***buyerPartyReference/@href (buyer) and premium/payerPartyReference/@href (premium payer) values are not the same.</text>
</error>
</xsl:if>
<xsl:if test="$sellerhref2!=$receiver">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***sellerPartyReference/@href (seller) and premium/receiverPartyReference/@href (premium receiver) values are not the same.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="count(fpml:premium) &gt; 1">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of premium child elements encountered. 0 or 1 expected.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:premium">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="not(fpml:europeanExercise)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing europeanExercise element. Required in this context'.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:europeanExercise">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:exerciseProcedure">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:calculationAgent">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:cashSettlement">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">swaptionStraddle</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swaptionStraddle"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:apply-templates select="fpml:swap">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:swap">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="not($productType='IRS' or $productType='OIS' or $productType='ZCInflationSwap' or $productType='Swaption' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='Fixed Fixed Swap')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** SWDML/swLongFormTrade/swStructuredTradeDetails/productType must be equal to 'SingleCurrencyInterestRateSwap', 'OIS', 'ZCInflationSwap', 'Swaption', 'Single Currency Basis Swap','Cross Currency Basis Swap' or 'Cross Currency IRS' or 'Fixed Fixed Swap'  if swap element is present.</text>
</error>
</xsl:if>
<xsl:if test="count(fpml:swapStream)!=2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of swapStream child elements encountered. Exactly 2 expected.</text>
</error>
</xsl:if>
<xsl:if test="$productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap'">
<xsl:if test="not(fpml:swapStream[@id='floatingLeg2'])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** One swapStream must have a swapStream/@id attribute value of 'floatingLeg2' when product type = 'Single Currency Basis Swap' or 'Cross Currency Basis Swap'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$productType ='ZCInflationSwap'">
<xsl:if test="not(fpml:swapStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:inflationRateCalculation)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The floating swapStream is missing /calculationPeriodAmount/calculation/inflationRateCalculation element.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$productType ='ZCInflationSwap'">
<xsl:if test="not(fpml:swapStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:inflationRateCalculation/fpml:inflationLag)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The floating swapStream is missing /calculationPeriodAmount/calculation/inflationRateCalculation/inflationLag element.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$productType !='ZCInflationSwap' and $productType !='Fixed Fixed Swap'">
<xsl:if test="not(fpml:swapStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The floating swapStream is missing calculationPeriodAmount/calculation/floatingRateCalculation element.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="($productType!='ZCInflationSwap' and $productType !='Fixed Fixed Swap')">
<xsl:if test="not(fpml:swapStream[@id='floatingLeg']/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The floating swapStream is missing calculationPeriodAmount/calculation/floatingRateCalculation element.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap'">
<xsl:if test="not(fpml:swapStream[@id='floatingLeg2']/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The floatingLeg2 swapStream is missing calculationPeriodAmount/calculation/floatingRateCalculation element.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="($productType='OIS' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or  $productType='Cross Currency IRS') and $isCompoundingEnabledIndex='false'">
<xsl:if test="fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:calculationMethod">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Calculation Method is not allowed for this Floating Rate Index</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="($productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap') and $isCompoundingEnabledIndex2='false'">
<xsl:if test="fpml:swapStream[@id='floatingLeg2']/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:calculationMethod">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Calculation Method is not allowed for this Floating Rate Index.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test= "fpml:swapStream[@id='floatingLeg']/fpml:resetDates and ($productType='OIS' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS')">
<xsl:if test="fpml:swapStream[@id='floatingLeg']/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:lookback or fpml:swapStream[@id='floatingLeg']/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:lockout or fpml:swapStream[@id='floatingLeg']/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:observationShift">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected reset Dates element encountered. Not allowed for lookback,lockout or observationShift method.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test= "fpml:swapStream[@id='floatingLeg2']/fpml:resetDates and ($productType='OIS' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap')">
<xsl:if test="fpml:swapStream[@id='floatingLeg2']/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:lookback or fpml:swapStream[@id='floatingLeg2']/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:lockout or fpml:swapStream[@id='floatingLeg2']/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:observationShift">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected reset Dates tag element encountered. Not allowed for lookback,lockout or observationShift method.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="($productType='ZCInflationSwap')">
<xsl:if test="(fpml:swapStream[@id='floatingLeg']/fpml:resetDates)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The floating swapStream should not contain the resetDates element for 'ZCInflationSwap'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="($productType='ZCInflationSwap')">
<xsl:if test="not(fpml:swapStream[@id='floatingLeg']/fpml:calculationPeriodAmount/fpml:calculation/fpml:inflationRateCalculation)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The floating swapStream of an ZCInflationSwap is missing the calculationPeriodAmount/calculation/inflationRateCalculation element.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:swapStream[@id='fixedLeg']/fpml:resetDates">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The fixed swapStream should not contain a resetDates element.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swapStream[@id='fixedLeg2']/fpml:resetDates">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The fixed2 swapStream should not contain a resetDates element.</text>
</error>
</xsl:if>
<xsl:if test="$productType='ZCInflationSwap' and not(//fpml:couponRate) and not(//fpml:swapStream[@id='fixedLeg']/fpml:calculationPeriodAmount/fpml:knownAmountSchedule)">
<xsl:if test="not(//fpml:swapStream[@id='fixedLeg']/fpml:cashflows)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The fixed swapStream should contain a cashflows element.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$productType='ZCInflationSwap' and not(//fpml:couponRate) and not(//fpml:swapStream[@id='fixedLeg']/fpml:calculationPeriodAmount/fpml:knownAmountSchedule)">
<xsl:if test="not(//fpml:swapStream[@id='fixedLeg']/fpml:cashflows/fpml:paymentCalculationPeriod/fpml:unadjustedPaymentDate)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The fixed swapStream should contain a cashflows/paymentCalculationPeriod/unadjustedPaymentDate element.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$productType='ZCInflationSwap' and not(//fpml:couponRate) and not(//fpml:swapStream[@id='fixedLeg']/fpml:calculationPeriodAmount/fpml:knownAmountSchedule)">
<xsl:if test="not(//fpml:swapStream[@id='fixedLeg']/fpml:cashflows/fpml:paymentCalculationPeriod/fpml:fixedPaymentAmount)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The fixed swapStream should contain a cashflows/paymentCalculationPeriod/fixedPaymentAmount element.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:swapStream[@id='fixedLeg']/fpml:cashflows/fpml:paymentCalculationPeriod/fpml:fixedPaymentAmount">
<xsl:variable name="fixedpaymentAmount"><xsl:value-of select="fpml:swapStream[@id='fixedLeg']/fpml:cashflows/fpml:paymentCalculationPeriod/fpml:fixedPaymentAmount"/></xsl:variable>
<xsl:if test="$fixedpaymentAmount != ''">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">fixedpaymentAmount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$fixedpaymentAmount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">-999999999999.99</xsl:with-param>
<xsl:with-param name="maxIncl">999999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
</xsl:if>
<xsl:if test="$interestRateSwapType != 'zeroCouponInterestRateSwapWithFixedAmount' and $productType !='Single Currency Basis Swap' and $productType!='Cross Currency Basis Swap' and $productType !='Fixed Fixed Swap' and $productType != 'ZCInflationSwap'">
<xsl:if test="not(//fpml:swapStream[@id='fixedLeg']/fpml:calculationPeriodAmount/fpml:calculation/fpml:fixedRateSchedule)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The fixed swapStream is missing the calculationPeriodAmount/calculation/fixedRateSchedule element.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$interestRateSwapType = 'zeroCouponInterestRateSwapWithFixedNotional'">
<xsl:if test="fpml:swapStream[@id='fixedLeg']/fpml:calculationPeriodAmount/fpml:knownAmountSchedule">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The fixed swapStream is missing the knownAmountSchedule element.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$interestRateSwapType = 'zeroCouponInterestRateSwapWithFixedAmount'">
<xsl:if test="fpml:swapStream[@id='fixedLeg']/fpml:calculationPeriodAmount/fpml:calculation">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The fixed swapStream should not contain the calculationPeriodAmount/calculation element for the product 'SingleCurrencyInterestRateSwap' (and Zero Coupon IRS with fixed amount).</text>
</error>
</xsl:if>
</xsl:if>
<xsl:variable name="stream1Payer">
<xsl:value-of select="fpml:swapStream[position()=1]/fpml:payerPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="stream2Receiver">
<xsl:value-of select="fpml:swapStream[position()=2]/fpml:receiverPartyReference/@href"/>
</xsl:variable>
<xsl:if test="$stream1Payer != $stream2Receiver">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swapStream[1] payer party is not swapStream[2] receiver party.</text>
</error>
</xsl:if>
<xsl:variable name="stream1Receiver">
<xsl:value-of select="fpml:swapStream[position()=1]/fpml:receiverPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="stream2Payer">
<xsl:value-of select="fpml:swapStream[position()=2]/fpml:payerPartyReference/@href"/>
</xsl:variable>
<xsl:if test="$stream1Receiver != $stream2Payer">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swapStream[1] receiver party is not swapStream[2] payer party.</text>
</error>
</xsl:if>
<xsl:if test="not($productType='IRS' or $productType='Swaption' or $productType='Cross Currency IRS' or $productType='OIS' or $productType='Single Currency Basis Swap' or $productType='Fixed Fixed Swap' or ($productType='ZCInflationSwap' and //fpml:couponRate)) and $isNettingInstruction='false' and $isClearingTakeup='false'">
<xsl:variable name="effectiveDate1">
<xsl:value-of select="fpml:swapStream[position()=1]/fpml:calculationPeriodDates/fpml:effectiveDate/fpml:unadjustedDate"/>
</xsl:variable>
<xsl:variable name="effectiveDate2">
<xsl:value-of select="fpml:swapStream[position()=2]/fpml:calculationPeriodDates/fpml:effectiveDate/fpml:unadjustedDate"/>
</xsl:variable>
<xsl:if test="$effectiveDate1!= $effectiveDate2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swapStream[1] and swapStream[2] effectiveDate do not match.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:variable name="terminationDate1">
<xsl:value-of select="fpml:swapStream[position()=1]/fpml:calculationPeriodDates/fpml:terminationDate/fpml:unadjustedDate"/>
</xsl:variable>
<xsl:variable name="terminationDate2">
<xsl:value-of select="fpml:swapStream[position()=2]/fpml:calculationPeriodDates/fpml:terminationDate/fpml:unadjustedDate"/>
</xsl:variable>
<xsl:if test="$terminationDate1!= $terminationDate2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swapStream[1] and swapStream[2] terminationDate/unadjustedDate do not match.</text>
</error>
</xsl:if>
<xsl:variable name="rollConvention1">
<xsl:value-of select="fpml:swapStream[position()=1]/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:rollConvention"/>
</xsl:variable>
<xsl:variable name="rollConvention2">
<xsl:value-of select="fpml:swapStream[position()=2]/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:rollConvention"/>
</xsl:variable>
<xsl:if test="($isZeroCouponInterestRateSwap != 'true' and not($productType='OIS' and $interestRateSwapFloatingLegType = 'zeroCouponInterestRateSwapFloatingLeg')) and not($productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='Fixed Fixed Swap')">
<xsl:if test="$rollConvention1 != $rollConvention2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swapStream[1] and swapStream[2] rollConvention do not match.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:variable name="notional1">
<xsl:value-of select="fpml:swapStream[position()=1]/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:initialValue"/>
</xsl:variable>
<xsl:variable name="notional2">
<xsl:value-of select="fpml:swapStream[position()=2]/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:initialValue"/>
</xsl:variable>
<xsl:if test="not($productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='Fixed Fixed Swap' or $productType ='OIS' or $productType = 'ZCInflationSwap' or $productType='IRS')">
<xsl:if test="$notional1!= $notional2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swapStream[1] and swapStream[2] notional do not match.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:variable name="currency1">
<xsl:value-of select="fpml:swapStream[position()=1]/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:currency"/>
</xsl:variable>
<xsl:variable name="currency2">
<xsl:value-of select="fpml:swapStream[position()=2]/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:currency"/>
</xsl:variable>
<xsl:if test="($interestRateSwapType != 'zeroCouponInterestRateSwapWithFixedAmount') and not($productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='Fixed Fixed Swap' or $productType ='OIS' or $productType = 'ZCInflationSwap')">
<xsl:if test="$currency1!= $currency2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swapStream[1] and swapStream[2] currency do not match.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$productType='Cross Currency Basis Swap'">
<xsl:variable name="floatingRateIndexCurrency">
<xsl:value-of select="substring(fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:floatingRateIndex,1,3)"/>
</xsl:variable>
<xsl:variable name="floatingRateIndex">
<xsl:value-of select="fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:floatingRateIndex"/>
</xsl:variable>
<xsl:if test="$tradeCurrency != $floatingRateIndexCurrency and $floatingRateIndex != 'CNH-HIBOR-TMA'and $floatingRateIndex != 'CNH-HIBOR'  and not ($tradeCurrency = 'EUR' and ($floatingRateIndex = 'REPOFUNDS RATE-FRANCE-OIS-COMPOUND' or $floatingRateIndex = 'REPOFUNDS RATE-GERMANY-OIS-COMPOUND' or $floatingRateIndex = 'REPOFUNDS RATE-ITALY-OIS-COMPOUND'))">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** floatingRateIndex value of '<xsl:value-of select="fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:floatingRateIndex"/>' is not valid for trade currency of '<xsl:value-of select="$tradeCurrency"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:choose>
<xsl:when test="$productType='Cross Currency Basis Swap'">
<xsl:variable name="floatingRateIndexCurrency2">
<xsl:value-of select="substring(fpml:swapStream[position()=$floatingLeg2]/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:floatingRateIndex,1,3)"/>
</xsl:variable>
<xsl:variable name="floatingRateIndex2">
<xsl:value-of select="fpml:swapStream[position()=$floatingLeg2]/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:floatingRateIndex"/>
</xsl:variable>
<xsl:if test="$tradeCurrency2 != $floatingRateIndexCurrency2 and $floatingRateIndex2 != 'CNH-HIBOR-TMA' and $floatingRateIndex2 != 'CNH-HIBOR' and not ($tradeCurrency2 = 'EUR' and ($floatingRateIndex2 = 'REPOFUNDS RATE-FRANCE-OIS-COMPOUND' or $floatingRateIndex2 = 'REPOFUNDS RATE-GERMANY-OIS-COMPOUND' or $floatingRateIndex2 = 'REPOFUNDS RATE-ITALY-OIS-COMPOUND'))">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** floatingRateIndex value of '<xsl:value-of select="fpml:swapStream[position()=$floatingLeg2]/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:floatingRateIndex"/>' is not valid for trade currency of '<xsl:value-of select="$tradeCurrency2"/>'.</text>
</error>
</xsl:if>
</xsl:when>
<xsl:when test="$productType='Cross Currency IRS'">
<xsl:variable name="floatingRateIndexCurrency">
<xsl:value-of select="substring(fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:floatingRateIndex,1,3)"/>
</xsl:variable>
<xsl:variable name="floatingRateIndex2">
<xsl:value-of select="fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:floatingRateIndex"/>
</xsl:variable>
<xsl:if test="$tradeCurrency2 != $floatingRateIndexCurrency and $floatingRateIndex2 != 'CNH-HIBOR-TMA' and $floatingRateIndex2 != 'CNH-HIBOR' and not ($tradeCurrency2 = 'EUR' and ($floatingRateIndex2 = 'REPOFUNDS RATE-FRANCE-OIS-COMPOUND' or $floatingRateIndex2 = 'REPOFUNDS RATE-GERMANY-OIS-COMPOUND' or $floatingRateIndex2 = 'REPOFUNDS RATE-ITALY-OIS-COMPOUND'))">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** floatingRateIndex value of '<xsl:value-of select="fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:floatingRateIndex"/>' is not valid for trade currency of '<xsl:value-of select="$tradeCurrency2"/>'.</text>
</error>
</xsl:if>
</xsl:when>
</xsl:choose>
<xsl:if test="$productType='Cross Currency Basis Swap' or $productType='Single Currency Basis Swap'">
<xsl:variable name="floatingRateIndex">
<xsl:value-of select="fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:floatingRateIndex"/>
</xsl:variable>
<xsl:variable name="floatingRateIndex2">
<xsl:value-of select="fpml:swapStream[position()=$floatingLeg2]/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:floatingRateIndex"/>
</xsl:variable>
<xsl:variable name="contractualDefinition">
<xsl:value-of select="//fpml:trade/fpml:documentation/fpml:contractualDefinitions"/>
</xsl:variable>
<xsl:if test="$contractualDefinition = 'ISDA2000' and ($floatingRateIndex = 'IDR-JIBOR-Reuters' or $floatingRateIndex2 = 'IDR-JIBOR-Reuters')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** IDR-JIBOR-Reuters is not valid under 2000 ISDA Definitions. Please use 2006 ISDA.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$productType='Cross Currency IRS' or $productType='IRS'">
<xsl:variable name="floatingRateIndex">
<xsl:value-of select="fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:floatingRateIndex"/>
</xsl:variable>
<xsl:variable name="contractualDefinition">
<xsl:value-of select="//fpml:trade/fpml:documentation/fpml:contractualDefinitions"/>
</xsl:variable>
<xsl:if test="$contractualDefinition = 'ISDA2000' and $floatingRateIndex = 'IDR-JIBOR-Reuters'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** IDR-JIBOR-Reuters is not valid under 2000 ISDA Definitions. Please use 2006 ISDA.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:variable name="floatingLegCurrency">
<xsl:value-of select="fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:currency"/>
</xsl:variable>
<xsl:variable name="fixedLegCurrency">
<xsl:value-of select="fpml:swapStream[position()=$fixedLeg]/fpml:calculationPeriodAmount/fpml:knownAmountSchedule/fpml:currency"/>
</xsl:variable>
<xsl:if test="$interestRateSwapType = 'zeroCouponInterestRateSwapWithFixedAmount'">
<xsl:if test="$floatingLegCurrency!= $fixedLegCurrency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swapStream[1] and swapStream[2] currency do not match.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:variable name="paymentLag1">
<xsl:value-of select="fpml:swapStream[position()=1]/fpml:paymentDates/fpml:paymentDaysOffset/fpml:periodMultiplier"/>
</xsl:variable>
<xsl:variable name="paymentLag2">
<xsl:value-of select="fpml:swapStream[position()=2]/fpml:paymentDates/fpml:paymentDaysOffset/fpml:periodMultiplier"/>
</xsl:variable>
<xsl:if test="$productType!='Single Currency Basis Swap' and $productType!='Cross Currency Basis Swap' and $productType!='Cross Currency IRS' and $productType!='Fixed Fixed Swap' and $productType!='OIS' and not ($productType='IRS' and ($isNettingInstruction='true' or $isTransitionEvent='true' or $isClearingTakeup='true'))">
<xsl:if test="$paymentLag1!= $paymentLag2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swapStream[1] and swapStream[2] paymentDaysOffset do not match.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:variable name="periodMultiplier1">
<xsl:value-of select="fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:periodMultiplier"/>
</xsl:variable>
<xsl:variable name="periodMultiplier2">
<xsl:value-of select="fpml:swapStream[position()=$floatingLeg]/fpml:resetDates/fpml:resetFrequency/fpml:periodMultiplier"/>
</xsl:variable>
<xsl:variable name="periodMultiplier3">
<xsl:value-of select="fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:indexTenor/fpml:periodMultiplier"/>
</xsl:variable>
<xsl:variable name="periodMultiplier6">
<xsl:value-of select="fpml:swapStream[position()=$floatingLeg]/fpml:paymentDates/fpml:paymentFrequency/fpml:periodMultiplier"/>
</xsl:variable>
<xsl:variable name="periodMultiplier4">
<xsl:value-of select="fpml:swapStream[position()=$fixedLeg]/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:periodMultiplier"/>
</xsl:variable>
<xsl:variable name="periodMultiplier5">
<xsl:value-of select="fpml:swapStream[position()=$fixedLeg]/fpml:paymentDates/fpml:paymentFrequency/fpml:periodMultiplier"/>
</xsl:variable>
<xsl:variable name="period1">
<xsl:value-of select="fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:period"/>
</xsl:variable>
<xsl:variable name="period2">
<xsl:value-of select="fpml:swapStream[position()=$floatingLeg]/fpml:resetDates/fpml:resetFrequency/fpml:period"/>
</xsl:variable>
<xsl:variable name="period3">
<xsl:value-of select="fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:indexTenor/fpml:period"/>
</xsl:variable>
<xsl:variable name="period6">
<xsl:value-of select="fpml:swapStream[position()=$floatingLeg]/fpml:paymentDates/fpml:paymentFrequency/fpml:period"/>
</xsl:variable>
<xsl:variable name="period4">
<xsl:value-of select="fpml:swapStream[position()=$fixedLeg]/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:period"/>
</xsl:variable>
<xsl:variable name="period5">
<xsl:value-of select="fpml:swapStream[position()=$fixedLeg]/fpml:paymentDates/fpml:paymentFrequency/fpml:period"/>
</xsl:variable>
<xsl:if test="$productType='IRS' or $productType='Swaption'">
<xsl:choose>
<xsl:when test="$tradeCurrency='BRL'">
<xsl:if test="not($periodMultiplier1 = '1' and $period1 = 'T')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The floating swapStream calculationPeriodFrequency for a BRL swap must equal '1T'.</text>
</error>
</xsl:if>
<xsl:if test="not($periodMultiplier2 = '1' and $period2 = 'D')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The floating swapStream resetFrequency for a BRL swap must equal '1D'.</text>
</error>
</xsl:if>
</xsl:when>
<xsl:otherwise>
<xsl:if test="not($interestRateSwapFloatingLegType='zeroCouponInterestRateSwapFloatingLeg') and not ($tradeCurrency='CLP') and $isOISonSwaption='false'">
<xsl:if test="not(($periodMultiplier1 = $periodMultiplier2) and ($periodMultiplier1 = $periodMultiplier3))">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The floating fpml:swapStream calculationPeriodFrequency, resetFrequency and indexTenor do not match.</text>
</error>
</xsl:if>
<xsl:if test="not(($period1 = $period2) and ($period1 = $period3))">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The floating stream calculationPeriodFrequency, resetFrequency and indexTenor do not match. calculationPeriodFrequency=<xsl:value-of select="$period1"/> resetFrequency=<xsl:value-of select="$period2"/> indexTenor=<xsl:value-of select="$period3"/>
</text>
</error>
</xsl:if>
</xsl:if>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="$productType='OIS' or $isOISonSwaption='true'">
<xsl:if test="(not($periodMultiplier1 = $periodMultiplier2) or not($period1 = $period2)) and not (fpml:swapStream[@id='floatingLeg']/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:lookback or fpml:swapStream[@id='floatingLeg']/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:lockout or fpml:swapStream[@id='floatingLeg']/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:observationShift)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The floating swapStream calculationPeriodFrequency and resetFrequency do not match. They must match if product type is 'OIS' or an 'OIS on Swaption'</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$productType='ZCInflationSwap' and  not(//fpml:couponRate)">
<xsl:if test="not($periodMultiplier6 = $periodMultiplier5)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** fpml:swapStream[1] and fpml:swapStream[2] paymentFrequency do not match. They must match if product type is 'ZCInflationSwap'.</text>
</error>
</xsl:if>
<xsl:if test="not($period6 = $period5)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***  swapStream[1] and swapStream[2] paymentFrequency do not match. They must match if product type is 'ZCInflationSwap'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="not($productType='ZCInflationSwap' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap')">
<xsl:if test="not($periodMultiplier4 = $periodMultiplier5)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The fixed swapStream calculationPeriodFrequency/periodMultiplier and paymentFrequency/periodMultiplier do not match.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="not($productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap')">
<xsl:if test="not($period4 = $period5)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The fixed swapStream calculationPeriodFrequency/period and paymentFrequency/period do not match.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:variable name="businessDayConvention1">
<xsl:value-of select="fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodDates/fpml:calculationPeriodDatesAdjustments/fpml:businessDayConvention"/>
</xsl:variable>
<xsl:variable name="businessDayConvention2">
<xsl:value-of select="fpml:swapStream[position()=$floatingLeg]/fpml:paymentDates/fpml:paymentDatesAdjustments/fpml:businessDayConvention"/>
</xsl:variable>
<xsl:variable name="businessDayConvention3">
<xsl:value-of select="fpml:swapStream[position()=$floatingLeg]/fpml:resetDates/fpml:resetDatesAdjustments/fpml:businessDayConvention"/>
</xsl:variable>
<xsl:if test="($productType!='ZCInflationSwap' and $productType !='Fixed Fixed Swap')">
<xsl:choose>
<xsl:when test="($productType='OIS' or $isOISonSwaption='true') and $businessDayConvention3 != 'NONE' and not (fpml:swapStream[@id='floatingLeg']/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:lookback or fpml:swapStream[@id='floatingLeg']/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:lockout or fpml:swapStream[@id='floatingLeg']/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:observationShift)">
<xsl:if test="not($businessDayConvention2 = $businessDayConvention3)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The floating swapStream paymentDatesAdjustments/businessDayConvention and resetDatesAdjustments/businessDayConvention do not match. paymentDatesAdjustments/businessDayConvention=<xsl:value-of select="$businessDayConvention2"/> resetDatesAdjustments/businessDayConvention=<xsl:value-of select="$businessDayConvention3"/>
</text>
</error>
</xsl:if>
</xsl:when>
<xsl:when test="$businessDayConvention1 = 'NONE' and $tradeCurrency !='BRL' and $isNettingInstruction = 'false' and $isClearingTakeup = 'false'">
<xsl:if test="$businessDayConvention3 != 'NONE' and not(fpml:swapStream[@id='floatingLeg']/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:lookback or fpml:swapStream[@id='floatingLeg']/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:lockout or fpml:swapStream[@id='floatingLeg']/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:observationShift)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The floating swapStream calculationPeriodDatesAdjustments/businessDayConvention and resetDatesAdjustments/businessDayConvention do not match:  calculationPeriodDatesAdjustments/businessDayConvention=NONE resetDatesAdjustments/businessDayConvention=<xsl:value-of select="$businessDayConvention3"/></text>
</error>
</xsl:if>
</xsl:when>
<xsl:when test="$businessDayConvention1 = 'NONE' and $tradeCurrency !='BRL' and ($isNettingInstruction = 'true' or $isClearingTakeup = 'true')">
<xsl:if test="not($businessDayConvention3 = 'NONE' or ($businessDayConvention2 = $businessDayConvention3) or fpml:swapStream[@id='floatingLeg']/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:lookback or fpml:swapStream[@id='floatingLeg']/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:lockout or fpml:swapStream[id='floatingLeg']/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:observationShift)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** When calculationPeriodDatesAdjustments/businessDayConvention is equal to 'NONE' either resetDatesAdjustments/businessDayConvention must be equal to 'NONE', or resetDatesAdjustments/businessDayConvention must match paymentDatesAdjustments/businessDayConvention: resetDatesAdjustments/businessDayConvention=<xsl:value-of select="$businessDayConvention3"/> paymentDatesAdjustments/businessDayConvention=<xsl:value-of select="$businessDayConvention2"/>.</text>
</error>
</xsl:if>
</xsl:when>
<xsl:otherwise>
<xsl:if test="not(($businessDayConvention1 = $businessDayConvention2) and ($businessDayConvention1 = $businessDayConvention3)) and  ($tradeCurrency != 'BRL')  and not(fpml:swapStream[@id='floatingLeg']/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:lookback or fpml:swapStream[@id='floatingLeg']/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:lockout or fpml:swapStream[@id='floatingLeg']/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:observationShift)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The floating swapStream calculationPeriodDatesAdjustments/businessDayConvention, paymentDatesAdjustments/businessDayConvention and (or) resetDatesAdjustments/businessDayConvention do not match:<xsl:value-of select="$businessDayConvention1"/> paymentDatesAdjustments/businessDayConvention=<xsl:value-of select="$businessDayConvention2"/> resetDatesAdjustments/businessDayConvention=<xsl:value-of select="$businessDayConvention3"/>
</text>
</error>
</xsl:if>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:variable name="fixedCalcPeriodAdjustment1">
<xsl:value-of select="$SWDML//fpml:swap/fpml:swapStream[position()=$fixedLeg]/fpml:calculationPeriodDates/fpml:calculationPeriodDatesAdjustments/fpml:businessDayConvention"/>
</xsl:variable>
<xsl:variable name="fixedPayDatesAdjustment1">
<xsl:value-of select="$SWDML//fpml:swap/fpml:swapStream[position()=$fixedLeg]/fpml:paymentDates/fpml:paymentDatesAdjustments/fpml:businessDayConvention"/>
</xsl:variable>
<xsl:if test="$fixedCalcPeriodAdjustment1 != $fixedPayDatesAdjustment1 and $productType!='OIS'">
<xsl:if test="$fixedCalcPeriodAdjustment1 != 'NONE'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text> *** Fixed leg calculationPeriodDates/calculationPeriodDatesAdjustments/businessDayConvention must either be equal to fixed leg paymentDates/paymentDatesAdjustments/businessDayConvention or be set to 'NONE'. Value = <xsl:value-of select="$fixedCalcPeriodAdjustment1"/>
</text>
</error>
</xsl:if>
</xsl:if>
<xsl:variable name="floatCalcPayFreqCombo">
<xsl:value-of select="fpml:swapStream[@id='floatingLeg']/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:periodMultiplier"/>
<xsl:value-of select="fpml:swapStream[@id='floatingLeg']/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:period"/>
<xsl:value-of select="fpml:swapStream[@id='floatingLeg']/fpml:paymentDates/fpml:paymentFrequency/fpml:periodMultiplier"/>
<xsl:value-of select="fpml:swapStream[@id='floatingLeg']/fpml:paymentDates/fpml:paymentFrequency/fpml:period"/>
</xsl:variable>
<xsl:if test="($productType='SingleCurrencyInterestRateSwap' or $productType='Swaption') and not($interestRateSwapFloatingLegType='zeroCouponInterestRateSwapFloatingLeg')">
<xsl:choose>
<xsl:when test="$floatCalcPayFreqCombo='28D28D'"/>
<xsl:when test="$floatCalcPayFreqCombo='1M1M'"/>
<xsl:when test="$floatCalcPayFreqCombo='1M3M'"/>
<xsl:when test="$floatCalcPayFreqCombo='1M6M'"/>
<xsl:when test="$floatCalcPayFreqCombo='1M1Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='3M3M'"/>
<xsl:when test="$floatCalcPayFreqCombo='3M6M'"/>
<xsl:when test="$floatCalcPayFreqCombo='3M1Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='6M6M'"/>
<xsl:when test="$floatCalcPayFreqCombo='6M1Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='1Y1Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='1W1M' and $tradeCurrency='CNY'"/>
<xsl:when test="$floatCalcPayFreqCombo='1W3M' and $tradeCurrency='CNY'"/>
<xsl:when test="$floatCalcPayFreqCombo='1W6M' and $tradeCurrency='CNY'"/>
<xsl:when test="$floatCalcPayFreqCombo='1W1Y' and $tradeCurrency='CNY'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The floating swapStream calculationPeriodDates/calculationPeriodFrequency and paymentDates/paymentFrequency combination is invalid for a product type of 'SingleCurrencyInterestRateSwap' or 'Swaption'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="($productType='SingleCurrencyInterestRateSwap' or $productType='Swaption') and ($interestRateSwapFloatingLegType='zeroCouponInterestRateSwapFloatingLeg')">
<xsl:choose>
<xsl:when test="$floatCalcPayFreqCombo='28D1T'"/>
<xsl:when test="$floatCalcPayFreqCombo='1M1T'"/>
<xsl:when test="$floatCalcPayFreqCombo='3M1T'"/>
<xsl:when test="$floatCalcPayFreqCombo='6M1T'"/>
<xsl:when test="$floatCalcPayFreqCombo='1Y1T'"/>
<xsl:when test="$tradeCurrency = 'CLP' and $floatCalcPayFreqCombo='1T1T'"/>
<xsl:when test="$floatCalcPayFreqCombo='1T1T' and $isOISonSwaption='true'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The floating swapStream calculationPeriodDates/calculationPeriodFrequency and paymentDates/paymentFrequency combination is invalid for a product type of 'SingleCurrencyInterestRateSwap' or 'Swaption' (with OIS indices) with a Zero Coupon floating leg.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="$productType='Single Currency Basis Swap'">
<xsl:choose>
<xsl:when test="$floatCalcPayFreqCombo='1M1M'"/>
<xsl:when test="$floatCalcPayFreqCombo='1M3M'"/>
<xsl:when test="$floatCalcPayFreqCombo='1M6M'"/>
<xsl:when test="$floatCalcPayFreqCombo='1M1Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='1M1T'"/>
<xsl:when test="$floatCalcPayFreqCombo='3M3M'"/>
<xsl:when test="$floatCalcPayFreqCombo='3M6M'"/>
<xsl:when test="$floatCalcPayFreqCombo='3M1Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='3M1T'"/>
<xsl:when test="$floatCalcPayFreqCombo='6M6M'"/>
<xsl:when test="$floatCalcPayFreqCombo='6M1Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='6M1T'"/>
<xsl:when test="$floatCalcPayFreqCombo='1Y1Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='1Y1T'"/>
<xsl:when test="$floatCalcPayFreqCombo='1T1T'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The floatingLeg swapStream calculationPeriodDates/calculationPeriodFrequency and paymentDates/paymentFrequency combination is invalid for a product type of 'Single Currency Basis Swap.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:variable name="float1Currency">
<xsl:choose>
<xsl:when test="$floatingLeg=1"><xsl:value-of select="$tradeCurrency"/></xsl:when>
<xsl:otherwise>
<xsl:value-of select="$tradeCurrency2"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="float2Currency">
<xsl:choose>
<xsl:when test="$floatingLeg2=2">
<xsl:value-of select="$tradeCurrency2"/>
</xsl:when>
<xsl:otherwise><xsl:value-of select="$tradeCurrency"/></xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:if test="$productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS'">
<xsl:choose>
<xsl:when test="$floatCalcPayFreqCombo='28D28D'"/>
<xsl:when test="$floatCalcPayFreqCombo='1M1M'"/>
<xsl:when test="$floatCalcPayFreqCombo='1M3M'"/>
<xsl:when test="$floatCalcPayFreqCombo='1M6M'"/>
<xsl:when test="$floatCalcPayFreqCombo='1M1Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='3M3M'"/>
<xsl:when test="$floatCalcPayFreqCombo='3M6M'"/>
<xsl:when test="$floatCalcPayFreqCombo='3M1Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='6M6M'"/>
<xsl:when test="$floatCalcPayFreqCombo='6M1Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='1Y1Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='1W1M' and $float1Currency='CNY'"/>
<xsl:when test="$floatCalcPayFreqCombo='1W3M' and $float1Currency='CNY'"/>
<xsl:when test="$floatCalcPayFreqCombo='1W6M' and $float1Currency='CNY'"/>
<xsl:when test="$floatCalcPayFreqCombo='1W1Y' and $float1Currency='CNY'"/>
<xsl:when test="$floatCalcPayFreqCombo='1T1T'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The floatingLeg swapStream calculationPeriodDates/calculationPeriodFrequency and paymentDates/paymentFrequency combination is invalid for a product type of 'Cross Currency Basis Swap' or 'Cross Currency IRS'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="$productType='ZCInflationSwap' and not(//fpml:couponRate)">
<xsl:choose>
<xsl:when test="$floatCalcPayFreqCombo='1Y1Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='2Y2Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='3Y3Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='4Y4Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='5Y5Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='6Y6Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='7Y7Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='8Y8Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='9Y9Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='10Y10Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='11Y11Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='12Y12Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='13Y13Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='14Y14Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='15Y15Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='16Y16Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='17Y17Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='18Y18Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='19Y19Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='20Y20Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='21Y21Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='22Y22Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='23Y23Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='24Y24Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='25Y25Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='26Y26Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='27Y27Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='28Y28Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='29Y29Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='30Y30Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='31Y31Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='32Y32Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='33Y33Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='34Y34Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='35Y35Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='36Y36Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='37Y37Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='38Y38Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='39Y39Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='40Y40Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='41Y41Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='42Y42Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='43Y43Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='44Y44Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='45Y45Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='46Y46Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='47Y47Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='48Y48Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='49Y49Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='50Y50Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='51Y51Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='52Y52Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='53Y53Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='54Y54Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='55Y55Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='56Y56Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='57Y57Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='58Y58Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='59Y59Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='60Y60Y'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The floating swapStream calculationPeriodDates/calculationPeriodFrequency and paymentDates/paymentFrequency combination is invalid for a product type of 'ZCInflationSwap'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="$productType='OIS'">
<xsl:choose>
<xsl:when test="$floatCalcPayFreqCombo='1M1M'"/>
<xsl:when test="$floatCalcPayFreqCombo='3M3M'"/>
<xsl:when test="$floatCalcPayFreqCombo='6M6M'"/>
<xsl:when test="$floatCalcPayFreqCombo='1Y1Y'"/>
<xsl:when test="$floatCalcPayFreqCombo='1T1T'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The floating swapStream calculationPeriodDates/calculationPeriodFrequency and paymentDates/paymentFrequency combination is invalid for a product type of 'OIS'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="$productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap'">
<xsl:variable name="float2CalcPayFreqCombo">
<xsl:value-of select="fpml:swapStream[@id='floatingLeg2']/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:periodMultiplier"/>
<xsl:value-of select="fpml:swapStream[@id='floatingLeg2']/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:period"/>
<xsl:value-of select="fpml:swapStream[@id='floatingLeg2']/fpml:paymentDates/fpml:paymentFrequency/fpml:periodMultiplier"/>
<xsl:value-of select="fpml:swapStream[@id='floatingLeg2']/fpml:paymentDates/fpml:paymentFrequency/fpml:period"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$productType='Single Currency Basis Swap'">
<xsl:choose>
<xsl:when test="$float2CalcPayFreqCombo='1M1M'"/>
<xsl:when test="$float2CalcPayFreqCombo='1M3M'"/>
<xsl:when test="$float2CalcPayFreqCombo='1M6M'"/>
<xsl:when test="$float2CalcPayFreqCombo='1M1Y'"/>
<xsl:when test="$float2CalcPayFreqCombo='1M1T'"/>
<xsl:when test="$float2CalcPayFreqCombo='3M3M'"/>
<xsl:when test="$float2CalcPayFreqCombo='3M6M'"/>
<xsl:when test="$float2CalcPayFreqCombo='3M1Y'"/>
<xsl:when test="$float2CalcPayFreqCombo='3M1T'"/>
<xsl:when test="$float2CalcPayFreqCombo='6M6M'"/>
<xsl:when test="$float2CalcPayFreqCombo='6M1Y'"/>
<xsl:when test="$float2CalcPayFreqCombo='6M1T'"/>
<xsl:when test="$float2CalcPayFreqCombo='1Y1Y'"/>
<xsl:when test="$float2CalcPayFreqCombo='1Y1T'"/>
<xsl:when test="$float2CalcPayFreqCombo='1T1T'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The floatingLeg2 swapStream calculationPeriodDates/calculationPeriodFrequency and paymentDates/paymentFrequency combination is invalid for a product type of 'Single Currency Basis Swap'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType='Cross Currency Basis Swap'">
<xsl:choose>
<xsl:when test="$float2CalcPayFreqCombo='28D28D'"/>
<xsl:when test="$float2CalcPayFreqCombo='1M1M'"/>
<xsl:when test="$float2CalcPayFreqCombo='1M3M'"/>
<xsl:when test="$float2CalcPayFreqCombo='1M6M'"/>
<xsl:when test="$float2CalcPayFreqCombo='1M1Y'"/>
<xsl:when test="$float2CalcPayFreqCombo='3M3M'"/>
<xsl:when test="$float2CalcPayFreqCombo='3M6M'"/>
<xsl:when test="$float2CalcPayFreqCombo='3M1Y'"/>
<xsl:when test="$float2CalcPayFreqCombo='6M6M'"/>
<xsl:when test="$float2CalcPayFreqCombo='6M1Y'"/>
<xsl:when test="$float2CalcPayFreqCombo='1Y1Y'"/>
<xsl:when test="$float2CalcPayFreqCombo='1W1M' and $float2Currency='CNY'"/>
<xsl:when test="$float2CalcPayFreqCombo='1W3M' and $float2Currency='CNY'"/>
<xsl:when test="$float2CalcPayFreqCombo='1W6M' and $float2Currency='CNY'"/>
<xsl:when test="$float2CalcPayFreqCombo='1W1Y' and $float2Currency='CNY'"/>
<xsl:when test="$float2CalcPayFreqCombo='1T1T'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The floatingLeg2 swapStream calculationPeriodDates/calculationPeriodFrequency and paymentDates/paymentFrequency combination is invalid for a product type of 'Cross Currency Basis Swap'.Value = '<xsl:value-of select="$float2CalcPayFreqCombo"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
</xsl:choose>
</xsl:if>
<xsl:variable name="floatCalcFreq">
<xsl:value-of select="fpml:swapStream[@id='floatingLeg']/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:periodMultiplier"/>
<xsl:value-of select="fpml:swapStream[@id='floatingLeg']/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:period"/>
</xsl:variable>
<xsl:if test="$productType='Single Currency Basis Swap'">
<xsl:choose>
<xsl:when test="$floatCalcFreq='1M'"/>
<xsl:when test="$floatCalcFreq='3M'"/>
<xsl:when test="$floatCalcFreq='6M'"/>
<xsl:when test="$floatCalcFreq='1Y'"/>
<xsl:when test="$floatCalcFreq='1T'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The floatingLeg swapStream calculationPeriodFrequency must be equal to 1M, 3M, 6M, 1Y or 1T if product type is 'Single Currency Basis Swap'( 1T is supported only for OIS Indices). Value = '<xsl:value-of select="$floatCalcFreq"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="$productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS'">
<xsl:choose>
<xsl:when test="$floatCalcFreq='1T'"/>
<xsl:when test="$floatCalcFreq='28D'"/>
<xsl:when test="$floatCalcFreq='1M'"/>
<xsl:when test="$floatCalcFreq='3M'"/>
<xsl:when test="$floatCalcFreq='6M'"/>
<xsl:when test="$floatCalcFreq='1Y'"/>
<xsl:when test="$floatCalcFreq='1W' and $float1Currency='CNY'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The floating swapStream calculationPeriodFrequency must be equal to 28D, 1M, 3M, 6M or 1Y if product type is 'Cross Currency Basis Swap' or 'Cross Currency IRS'. Value = '<xsl:value-of select="$floatCalcFreq"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="$productType='IRS' or $productType='Swaption'">
<xsl:choose>
<xsl:when test="$tradeCurrency = 'BRL'">
<xsl:if test="$floatCalcFreq!='1T'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The floating swapStream calculationPeriodFrequency must be equal to 1T if product type is 'SingleCurrencyInterestRateSwap' and currency is 'BRL''. Value = '<xsl:value-of select="$floatCalcFreq"/>'.</text>
</error>
</xsl:if>
</xsl:when>
<xsl:when test="$floatCalcFreq='28D'"/>
<xsl:when test="$floatCalcFreq='1M'"/>
<xsl:when test="$floatCalcFreq='3M'"/>
<xsl:when test="$floatCalcFreq='6M'"/>
<xsl:when test="$floatCalcFreq='1Y'"/>
<xsl:when test="$floatCalcFreq='1W' and $tradeCurrency='CNY'"/>
<xsl:when test="$floatCalcFreq='1T' and $tradeCurrency='CLP'"/>
<xsl:when test="$floatCalcFreq='1T' and $isOISonSwaption='true'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The floating swapStream calculationPeriodFrequency must be equal to 1T (OIS on Swaption), 28D, 1M, 3M, 6M, 1Y if product type is 'SingleCurrencyInterestRateSwap' or 'Swaption'. Value = '<xsl:value-of select="$floatCalcFreq"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:variable name="floatCalcFreq2">
<xsl:value-of select="fpml:swapStream[@id='floatingLeg2']/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:periodMultiplier"/>
<xsl:value-of select="fpml:swapStream[@id='floatingLeg2']/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:period"/>
</xsl:variable>
<xsl:if test="$productType='Single Currency Basis Swap'">
<xsl:choose>
<xsl:when test="$floatCalcFreq2='1M'"/>
<xsl:when test="$floatCalcFreq2='3M'"/>
<xsl:when test="$floatCalcFreq2='6M'"/>
<xsl:when test="$floatCalcFreq2='1Y'"/>
<xsl:when test="$floatCalcFreq2='1T'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The floatingLeg2 swapStream calculationPeriodFrequency must be equal to 1M, 3M, 6M, 1Y or 1T if product type is 'Single Currency Basis Swap'( 1T is supported only for OIS Indices). Value = '<xsl:value-of select="$floatCalcFreq2"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="$productType='Cross Currency Basis Swap'">
<xsl:choose>
<xsl:when test="$floatCalcFreq2='28D'"/>
<xsl:when test="$floatCalcFreq2='1M'"/>
<xsl:when test="$floatCalcFreq2='3M'"/>
<xsl:when test="$floatCalcFreq2='6M'"/>
<xsl:when test="$floatCalcFreq2='1Y'"/>
<xsl:when test="$floatCalcFreq2='1W' and $float2Currency='CNY'"/>
<xsl:when test="$floatCalcFreq2='1T'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The floatingLeg2 swapStream calculationPeriodFrequency must be equal to 28D, 1M, 3M, 6M or 1Y if product type is 'Cross Currency Basis Swap'. Value = '<xsl:value-of select="$floatCalcFreq2"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:variable name="fixedCalcFreq">
<xsl:value-of select="fpml:swapStream[@id='fixedLeg']/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:periodMultiplier"/>
<xsl:value-of select="fpml:swapStream[@id='fixedLeg']/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:period"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$isZeroCouponInterestRateSwap != 'true'">
<xsl:if test="$productType='IRS' or $productType='Swaption' or $productType='Cross Currency IRS'">
<xsl:choose>
<xsl:when test="$fixedCalcFreq='28D'"/>
<xsl:when test="$fixedCalcFreq='1M'"/>
<xsl:when test="$fixedCalcFreq='3M'"/>
<xsl:when test="$fixedCalcFreq='6M'"/>
<xsl:when test="$fixedCalcFreq='1Y'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The fixed fpml:swapStream calculationPeriodFrequency must be equal to 28D, 1M, 3M, 6M or 1Y if product type is 'SingleCurrencyInterestRateSwap' (except Zero Coupon IRS) or 'Swaption' or 'Cross Currency IRS'. Value = '<xsl:value-of select="$fixedCalcFreq"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:when>
<xsl:when test="$isZeroCouponInterestRateSwap = 'true'">
<xsl:if test="$productType='IRS' or $productType='OIS' or $isOISonSwaption='true'">
<xsl:choose>
<xsl:when test="$fixedCalcFreq='1T'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The fixed fpml:swapStream calculationPeriodFrequency must be equal to 1T, if product type is 'SingleCurrencyInterestRateSwap' or 'OIS' or 'Swaption' with OIS indices, and a Zero Coupon IRS / OIS / Swaption. Value = '<xsl:value-of select="$fixedCalcFreq"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:when>
</xsl:choose>
<xsl:if test="$productType='ZCInflationSwap' and not(//fpml:couponRate)">
<xsl:choose>
<xsl:when test="$fixedCalcFreq='1Y'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The fixed fpml:swapStream calculationPeriodFrequency must be equal to 1Y if product type is 'ZCInflationSwap''. Value = '<xsl:value-of select="$fixedCalcFreq"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:variable name="floatPayFreq">
<xsl:value-of select="fpml:swapStream[@id='floatingLeg']/fpml:paymentDates/fpml:paymentFrequency/fpml:periodMultiplier"/>
<xsl:value-of select="fpml:swapStream[@id='floatingLeg']/fpml:paymentDates/fpml:paymentFrequency/fpml:period"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$productType='Swaption'">
<xsl:choose>
<xsl:when test="$floatPayFreq='28D'"/>
<xsl:when test="$floatPayFreq='1M'"/>
<xsl:when test="$floatPayFreq='3M'"/>
<xsl:when test="$floatPayFreq='6M'"/>
<xsl:when test="$floatPayFreq='1Y'"/>
<xsl:when test="$floatPayFreq='1T' and $isOISonSwaption='true'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The floating swapStream paymentFrequency must be equal to 1T (OIS on Swaption), 28D, 1M, 3M, 6M or 1Y if product type is 'Swaption'. Value = '<xsl:value-of select="$floatPayFreq"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType='SingleCurrencyInterestRateSwap'">
<xsl:choose>
<xsl:when test="$floatPayFreq='28D'"/>
<xsl:when test="$floatPayFreq='1M'"/>
<xsl:when test="$floatPayFreq='3M'"/>
<xsl:when test="$floatPayFreq='6M'"/>
<xsl:when test="$floatPayFreq='1Y'"/>
<xsl:when test="$floatPayFreq='1T'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The floating swapStream paymentFrequency must be equal to 28D, 1M, 3M, 6M, 1Y or 1T if product type is 'SingleCurrencyInterestRateSwap'. Value = '<xsl:value-of select="$floatPayFreq"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType='Single Currency Basis Swap'">
<xsl:choose>
<xsl:when test="$floatPayFreq='1M'"/>
<xsl:when test="$floatPayFreq='3M'"/>
<xsl:when test="$floatPayFreq='6M'"/>
<xsl:when test="$floatPayFreq='1Y'"/>
<xsl:when test="$floatPayFreq='1T'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The floatingLeg swapStream paymentFrequency must be equal to 1M, 3M, 6M, 1Y or 1T if product type is 'Single Currency Basis Swap'(1T is supported only for OIS Indices). Value = '<xsl:value-of select="$floatPayFreq"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS'">
<xsl:choose>
<xsl:when test="$floatPayFreq='1T'"/>
<xsl:when test="$floatPayFreq='28D'"/>
<xsl:when test="$floatPayFreq='1M'"/>
<xsl:when test="$floatPayFreq='3M'"/>
<xsl:when test="$floatPayFreq='6M'"/>
<xsl:when test="$floatPayFreq='1Y'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The floating swapStream paymentFrequency must be equal to 28D, 1M, 3M, 6M or 1Y if product type is 'Cross Currency Basis Swap' or 'Cross Currency IRS'. Value = '<xsl:value-of select="$floatPayFreq"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
</xsl:choose>
<xsl:variable name="floatPayFreq2">
<xsl:value-of select="fpml:swapStream[@id='floatingLeg2']/fpml:paymentDates/fpml:paymentFrequency/fpml:periodMultiplier"/>
<xsl:value-of select="fpml:swapStream[@id='floatingLeg2']/fpml:paymentDates/fpml:paymentFrequency/fpml:period"/>
</xsl:variable>
<xsl:if test="$productType='Single Currency Basis Swap'">
<xsl:choose>
<xsl:when test="$floatPayFreq2='1M'"/>
<xsl:when test="$floatPayFreq2='3M'"/>
<xsl:when test="$floatPayFreq2='6M'"/>
<xsl:when test="$floatPayFreq2='1Y'"/>
<xsl:when test="$floatPayFreq2='1T'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The floatingLeg2 swapStream paymentFrequency must be equal to 1M, 3M, 6M, 1Y or 1T if product type is 'Single Currency Basis Swap'(1T is supported only for OIS Indices). Value = '<xsl:value-of select="$floatPayFreq2"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="$productType='Cross Currency Basis Swap'">
<xsl:choose>
<xsl:when test="$floatPayFreq2='28D'"/>
<xsl:when test="$floatPayFreq2='1M'"/>
<xsl:when test="$floatPayFreq2='3M'"/>
<xsl:when test="$floatPayFreq2='6M'"/>
<xsl:when test="$floatPayFreq2='1Y'"/>
<xsl:when test="$floatPayFreq2='1T'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The floatingLeg2 swapStream paymentFrequency must be equal to 28D, 1M, 3M, 6M or 1Y if product type is 'Cross Currency Basis Swap'. Value = '<xsl:value-of select="$floatPayFreq2"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:variable name="fixedPayFreq">
<xsl:value-of select="fpml:swapStream[@id='fixedLeg']/fpml:paymentDates/fpml:paymentFrequency/fpml:periodMultiplier"/>
<xsl:value-of select="fpml:swapStream[@id='fixedLeg']/fpml:paymentDates/fpml:paymentFrequency/fpml:period"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$isZeroCouponInterestRateSwap != 'true'">
<xsl:if test="$productType='IRS' or $productType='Swaption' or $productType='Cross Currency IRS'">
<xsl:choose>
<xsl:when test="$fixedPayFreq='28D'"/>
<xsl:when test="$fixedPayFreq='1M'"/>
<xsl:when test="$fixedPayFreq='3M'"/>
<xsl:when test="$fixedPayFreq='6M'"/>
<xsl:when test="$fixedPayFreq='1Y'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The fixed swapstream paymentFrequency must be equal to 28D, 1M, 3M, 6M or 1Y if product type is 'SingleCurrencyInterestRateSwap' (except Zero Coupon IRS) or 'Swaption' or 'Cross Currency IRS'. Value = '<xsl:value-of select="$fixedPayFreq"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:when>
<xsl:when test="$isZeroCouponInterestRateSwap = 'true'">
<xsl:if test="$productType='IRS' or $productType='OIS' or $isOISonSwaption='true'">
<xsl:choose>
<xsl:when test="$fixedPayFreq='1T'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The fixed swapStream paymentFrequency must be equal to 1T, if product type is 'SingleCurrencyInterestRateSwap' or 'OIS' or 'Swaption' with OIS indices, and a Zero Coupon IRS / OIS / Swaption. Value = '<xsl:value-of select="$fixedPayFreq"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:when>
</xsl:choose>
<xsl:variable name="rollConvention">
<xsl:value-of select="fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:rollConvention"/>
</xsl:variable>
<xsl:if test="starts-with($rollConvention,'IMM') and $productType!='IRS' and $productType!='Cross Currency IRS' and $productType!='OIS' and $productType!='Single Currency Basis Swap'">
<xsl:if test="$swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swStub/fpml:swStubPosition and not($swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swStub/fpml:swStubPosition[.='Start'])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swStub/swStubPosition must be equal to 'Start' for IMM rolls.</text>
</error>
</xsl:if>
<xsl:if test="$swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swStub/fpml:swStubLength and not($swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swStub/fpml:swStubLength[.='Short'])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swStub/swStubLength must be equal to 'Short' for IMM rolls.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$MarkToMarket='true'">
<xsl:choose>
<xsl:when test="$productType='Fixed Fixed Swap'">
<xsl:variable name="href">
<xsl:value-of select="$trade//fpml:swap/fpml:swapStream[@id='fixedLeg2']/fpml:calculationPeriodAmount/fpml:calculation/fpml:fxLinkedNotionalSchedule/fpml:constantNotionalScheduleReference/@href"/>
</xsl:variable>
<xsl:variable name="id">
<xsl:value-of select="$trade//fpml:swap/fpml:swapStream[@id='fixedLeg']/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/@id"/>
</xsl:variable>
<xsl:if test="$href!=$id">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid constantNotionalScheduleReference/@href value. Value is not equal to fpml:swapStream[@id='fixedLeg']/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/@id. Value of href = '<xsl:value-of select="$href"/>' and id = '<xsl:value-of select="$id"/>'.</text>
</error>
</xsl:if>
</xsl:when>
<xsl:when test="$productType='Cross Currency IRS'">
<xsl:variable name="href">
<xsl:value-of select="$trade//fpml:swap/fpml:swapStream[@id='floatingLeg']/fpml:calculationPeriodAmount/fpml:calculation/fpml:fxLinkedNotionalSchedule/fpml:constantNotionalScheduleReference/@href"/>
</xsl:variable>
<xsl:variable name="id">
<xsl:value-of select="$trade//fpml:swap/fpml:swapStream[@id='fixedLeg']/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/@id"/>
</xsl:variable>
<xsl:if test="$href!=$id">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid constantNotionalScheduleReference/@href value. Value is not equal to fpml:swapStream[@id='fixedLeg']/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/@id. Value of href = '<xsl:value-of select="$href"/>' and id = '<xsl:value-of select="$id"/>'.</text>
</error>
</xsl:if>
</xsl:when>
<xsl:otherwise>
<xsl:variable name="href">
<xsl:value-of select="$trade//fpml:swap/fpml:swapStream[@id='floatingLeg2']/fpml:calculationPeriodAmount/fpml:calculation/fpml:fxLinkedNotionalSchedule/fpml:constantNotionalScheduleReference/@href"/>
</xsl:variable>
<xsl:variable name="id">
<xsl:value-of select="$trade//fpml:swap/fpml:swapStream[@id='floatingLeg']/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/@id"/>
</xsl:variable>
<xsl:if test="$href!=$id">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid constantNotionalScheduleReference/@href value. Value is not equal to fpml:swapStream[@id='floatingLeg']/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/@id. Value of href = '<xsl:value-of select="$href"/>' and id = '<xsl:value-of select="$id"/>'.</text>
</error>
</xsl:if>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:choose>
<xsl:when test="($productType='IRS' or $productType='OIS') and count(//fpml:swExtendedTradeDetails/fpml:swStub)=2">
<xsl:variable name="firstFixedRegularPeriodStartDate">
<xsl:value-of select="fpml:swapStream[@id='fixedLeg']/fpml:calculationPeriodDates/fpml:firstRegularPeriodStartDate"/>
</xsl:variable>
<xsl:variable name="firstFloatRegularPeriodStartDate">
<xsl:value-of select="fpml:swapStream[@id='floatingLeg']/fpml:calculationPeriodDates/fpml:firstRegularPeriodStartDate"/>
</xsl:variable>
<xsl:variable name="firstFixedPaymentDate">
<xsl:value-of select="fpml:swapStream[@id='fixedLeg']/fpml:paymentDates/fpml:firstPaymentDate"/>
</xsl:variable>
<xsl:variable name="firstFloatPaymentDate">
<xsl:value-of select="fpml:swapStream[@id='floatingLeg']/fpml:paymentDates/fpml:firstPaymentDate"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="starts-with($rollConvention,'IMM')"/>
<xsl:when test="$rollConvention='EOM'"/>
<xsl:otherwise>
<xsl:if test="$firstFixedRegularPeriodStartDate !='' and not($isZeroCouponInterestRateSwap) and number(substring($firstFixedRegularPeriodStartDate,9)) != number($rollConvention) and not( substring($firstFixedRegularPeriodStartDate,6,2)='02' and number($rollConvention) &gt;=29)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Fixed leg calculationPeriodDates/firstRegularPeriodStartDate must fall on same day of month as rollConvention.  Value = '<xsl:value-of select="$firstFixedRegularPeriodStartDate"/>'.  RollConvention = '<xsl:value-of select="$rollConvention"/>'.</text>
</error>
</xsl:if>
<xsl:if test="$firstFloatRegularPeriodStartDate !='' and $interestRateSwapFloatingLegType='aNonZCIRSFloatingLeg' and number(substring($firstFloatRegularPeriodStartDate,9))!=number($rollConvention) and not (substring($firstFloatRegularPeriodStartDate,6,2) ='02' and number($rollConvention) &gt;=29)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Floating leg calculationPeriodDates/firstRegularPeriodStartDate must fall on same day of month as rollConvention.  Value = '<xsl:value-of select="$firstFloatRegularPeriodStartDate"/>'.  RollConvention = '<xsl:value-of select="$rollConvention"/>'.</text>
</error>
</xsl:if>
<xsl:if test="$firstFixedPaymentDate !='' and not($isZeroCouponInterestRateSwap) and number(substring($firstFixedPaymentDate,9))!=number($rollConvention) and not(substring($firstFixedPaymentDate,6,2) ='02' and number($rollConvention) &gt;=29)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Fixed leg paymentDates/firstPaymentDate must fall on same day of month as rollConvention.  Value = '<xsl:value-of select="$firstFixedPaymentDate"/>'.  RollConvention = '<xsl:value-of select="$rollConvention"/>'.</text>
</error>
</xsl:if>
<xsl:if test="$firstFloatPaymentDate !='' and $interestRateSwapFloatingLegType='aNonZCIRSFloatingLeg' and number(substring($firstFloatPaymentDate,9))!=number($rollConvention)and not(substring($firstFloatPaymentDate,6,2)='02' and number($rollConvention) &gt;=29) ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Floating leg paymentDates/firstPaymentDate must fall on same day of month as rollConvention.  Value = '<xsl:value-of select="$firstFloatPaymentDate"/>'.  RollConvention = '<xsl:value-of select="$rollConvention"/>'.</text>
</error>
</xsl:if>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:otherwise>
<xsl:if test="count(//fpml:stubPeriodType)=2">
<xsl:if test="contains(//fpml:swapStream[position()=1]/fpml:calculationPeriodDates/fpml:stubPeriodType,'Initial')">
<xsl:if test="not(contains(//fpml:swapStream[position()=2]/fpml:calculationPeriodDates/fpml:stubPeriodType,'Initial'))">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***  stubPeriodType Value = '<xsl:value-of select="//fpml:swapStream[position()=1]/fpml:calculationPeriodDates/fpml:stubPeriodType"/>' is inconsistent with following leg Value = '<xsl:value-of select="//fpml:swapStream[position()=2]/fpml:calculationPeriodDates/fpml:stubPeriodType"/>'. Only pairs of Initial or Final stubs supported.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="contains(//fpml:swapStream[position()=1]/fpml:calculationPeriodDates/fpml:stubPeriodType,'Final')">
<xsl:if test="not(contains(//fpml:swapStream[position()=2]/fpml:calculationPeriodDates/fpml:stubPeriodType,'Final'))">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***  stubPeriodType Value = '<xsl:value-of select="//fpml:swapStream[position()=1]/fpml:calculationPeriodDates/fpml:stubPeriodType"/>' is inconsistent with following leg Value = '<xsl:value-of select="//fpml:swapStream[position()=2]/fpml:calculationPeriodDates/fpml:stubPeriodType"/>'. Only pairs of Initial or Final stubs supported.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="fpml:swapStream">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:earlyTerminationProvision">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:choose>
<xsl:when test="$productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS'">
<xsl:if test="count(fpml:additionalPayment) &gt; 8">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of additionalPayment child elements encountered. 0 to 9 expected for Cross Currency products.</text>
</error>
</xsl:if>
<xsl:if test="count(fpml:additionalPayment[fpml:paymentType = 'Cancellation']) &gt; 2 ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** A maximum of two additionalPayment child elements can be identified as a Cancellation (paymentType = 'Cancellation') in Cross Currency products.</text>
</error>
</xsl:if>
</xsl:when>
<xsl:otherwise>
<xsl:if test="count(fpml:additionalPayment) &gt; 8">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of additionalPayment child elements encountered. 0 to 8 expected.</text>
</error>
</xsl:if>
<xsl:if test="count(fpml:additionalPayment) = 7">
<xsl:if test="not(//fpml:additionalPayment[fpml:paymentType = 'Independent Amount'] or fpml:additionalPayment[fpml:paymentType = 'Cancellation'])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** If seven additionalPayment child elements are present then one must be identified as an Independent Amount (paymentType = 'Independent Amount') or Cancellation (paymentType = 'Cancellation').</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="count(fpml:additionalPayment) = 8">
<xsl:if test="not(//fpml:additionalPayment[fpml:paymentType = 'Independent Amount'] and fpml:additionalPayment[fpml:paymentType = 'Cancellation'])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** If eight additionalPayment child elements are present then one must be identified as an Independent Amount (paymentType = 'Independent Amount') and one a Cancellation (paymentType = 'Independent Amount').</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="count(fpml:additionalPayment[fpml:paymentType = 'Independent Amount']) &gt; 1">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** A maximum of one additionalPayment child element can be identified as an Independent Amount (paymentType = 'Independent Amount').</text>
</error>
</xsl:if>
<xsl:if test="count(fpml:additionalPayment[fpml:paymentType = 'Cancellation']) &gt; 1">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** A maximum of one additionalPayment child element can be identified as a Cancellation (paymentType = 'Cancellation').</text>
</error>
</xsl:if>
</xsl:otherwise>
</xsl:choose>
<xsl:if test="fpml:additionalPayment">
<xsl:if test="not($productType='IRS' or $productType='OIS' or $productType='Swaption' or $productType='OIS' or $productType='ZCInflationSwap' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='Fixed Fixed Swap')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** additionalPayment is only allowed in this context if product type is 'SingleCurrencyInterestRateSwap', 'OIS', 'Swaption', 'ZCInflationSwap', ' Single Currency Basis Swap' or 'Cross Currency Basis Swap' or 'Cross Currency IRS' or 'Fixed Fixed Swap'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:additionalPayment">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:additionalTerms">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:documentation">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:call-template name="isValidMasterAgreementType">
<xsl:with-param name="elementName">masterAgreementType</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:masterAgreement/fpml:masterAgreementType"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:apply-templates select="fpml:contractualDefinitions">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="count(fpml:contractualDefinitions) &gt; 2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of contractualDefinitions  elements encountered. 0 to 2 expected.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:contractualDefinitions">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:call-template name="isValidContractualDefinitions">
<xsl:with-param name="elementName">contractualDefinitions</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="."/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:template>
<xsl:template match="fpml:additionalTerms">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:variable name="instrumentId">
<xsl:value-of select="fpml:bondReference/fpml:bond/fpml:instrumentId"/>
</xsl:variable>
<xsl:if test="$productType='ZCInflationSwap'">
<xsl:call-template name="isValidInflationAssetSwap">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="$productType='ZCInflationSwap'">
<xsl:if test="string-length($instrumentId) &gt; 12">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid instrumentId string length. Exceeded max length of 12 characters for productType 'ZCInflationSwap'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$productType='IRS' or $productType='OIS' or $productType='Single Currency Basis Swap' or $productType='Fixed Fixed Swap'">
<xsl:variable name="conditionPrecedentBondId">
<xsl:value-of select="fpml:conditionPrecedentBond/fpml:instrumentId"/>
</xsl:variable>
<xsl:variable name="conditionPrecedentBondMaturity">
<xsl:value-of select="fpml:conditionPrecedentBond/fpml:maturity"/>
</xsl:variable>
<xsl:if test="$participantSupplement='Fannie Mae' and (($conditionPrecedentBondId!='' and $conditionPrecedentBondMaturity='') or ($conditionPrecedentBondMaturity!='' and $conditionPrecedentBondId=''))">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** For a swParticipantSupplement value of Fannie Mae if either conditionPrecedentBond/instrumentId or conditionPrecedentBond/maturity have a value they both must have.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:variable name="conditionPrecedentBond">
<xsl:value-of select="fpml:bondReference/fpml:conditionPrecedentBond"/>
</xsl:variable>
<xsl:if test="$productType='ZCInflationSwap'">
<xsl:if test="$conditionPrecedentBond != 'false'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** conditionPrecedentBond must be present and equal to 'false'. Value = '<xsl:value-of select="$conditionPrecedentBond"/>'.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:swapStream">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:variable name="href1">
<xsl:value-of select="fpml:payerPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="href2">
<xsl:value-of select="fpml:receiverPartyReference/@href"/>
</xsl:variable>
<xsl:if test="$href1=$href2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** payerPartyReference/@href and receiverPartyReference/@href values must not be the same.</text>
</error>
</xsl:if>
<xsl:if test="not(//fpml:FpML/fpml:party[@id=$href1])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** payerPartyReference/@href does not reference a valid /FpML/trade/party/@id. Value = '<xsl:value-of select="$href1"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not(//fpml:FpML/fpml:party[@id=$href2])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** receiverPartyReference/@href does not reference a valid /FpML/trade/party/@id. Value = '<xsl:value-of select="$href2"/>'.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:calculationPeriodDates">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:paymentDates">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:resetDates">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:calculationPeriodAmount">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:stubCalculationPeriodAmount">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="(fpml:settlementProvision and ($productType = 'IRS' or $productType = 'OIS') and  position()!=$fixedLeg)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** settlementProvision should only be specified on the fixed leg of a non deliverable IRS or OIS trade.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:settlementProvision">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:cashflows">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:cashflows">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="($productType = 'Cross Currency IRS' or $productType = 'Cross Currency Basis Swap')">
<xsl:apply-templates select="fpml:principalExchange">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:principalExchange">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="($productType = 'Cross Currency IRS' or $productType = 'Cross Currency Basis Swap' or $productType = 'Fixed Fixd Swap')">
<xsl:if test="fpml:adjustedPrincipalExchangeDate">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected element adjustedPrincipalExchangeDate encountered.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:calculationPeriodDates">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="id">
<xsl:value-of select="./@id"/>
</xsl:variable>
<xsl:if test="$id = ''">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or empty calculationPeriodDates/@id value.</text>
</error>
</xsl:if>
<xsl:variable name="effectiveDate">
<xsl:value-of select="fpml:effectiveDate/fpml:unadjustedDate"/>
</xsl:variable>
<xsl:variable name="terminationDate">
<xsl:value-of select="fpml:terminationDate/fpml:unadjustedDate"/>
</xsl:variable>
<xsl:variable name="effDate">
<xsl:value-of select="number(concat(substring($effectiveDate,1,4),substring($effectiveDate,6,2),substring($effectiveDate,9,2)))"/>
</xsl:variable>
<xsl:variable name="termDate">
<xsl:value-of select="number(concat(substring($terminationDate,1,4),substring($terminationDate,6,2),substring($terminationDate,9,2)))"/>
</xsl:variable>
<xsl:if test="$effDate &gt;= $termDate">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The terminationDate must be greater than the effectiveDate.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:effectiveDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:terminationDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:calculationPeriodDatesAdjustments">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:firstRegularPeriodStartDate">
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">firstRegularPeriodStartDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:firstRegularPeriodStartDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:lastRegularPeriodEndDate">
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">lastRegularPeriodEndDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:lastRegularPeriodEndDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:apply-templates select="fpml:stubPeriodType">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:calculationPeriodFrequency">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:stubPeriodType">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="href">
<xsl:choose>
<xsl:when test="$productType='CapFloor'">
<xsl:value-of select="ancestor::fpml:capFloorStream/@id"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="ancestor::fpml:swapStream/@id"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="stubPeriodType">
<xsl:value-of select="."/>
</xsl:variable>
<xsl:variable name="stubPosition">
<xsl:value-of select="$swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swStub/fpml:swStubPosition"/>
</xsl:variable>
<xsl:variable name="stubPosition2">
<xsl:value-of select="$swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swStub[2]/fpml:swStubPosition"/>
</xsl:variable>
<xsl:variable name="stubLength">
<xsl:value-of select="$swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swStub/fpml:swStubLength[@href=$href]"/>
</xsl:variable>
<xsl:variable name="stubLength2">
<xsl:value-of select="$swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swStub[2]/fpml:swStubLength[@href=$href]"/>
</xsl:variable>
<xsl:variable name="frontAndBackStubs">
<xsl:choose>
<xsl:when test="($productType='IRS' or $productType='OIS') and count(//fpml:swExtendedTradeDetails/fpml:swStub)=2">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:choose>
<xsl:when test="starts-with($stubPeriodType,'Short')">
<xsl:if test="($frontAndBackStubs='false' and $stubLength='Long') or ($frontAndBackStubs='true' and $stubLength2='Long' and $stubPeriodType='ShortFinal')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***  Value = '<xsl:value-of select="$stubPeriodType"/>' is inconsistent with presence of swStubLength[<xsl:value-of select="$href"/>] Value = Long.</text>
</error>
</xsl:if>
</xsl:when>
<xsl:when test="starts-with($stubPeriodType,'Long')">
<xsl:if test="($frontAndBackStubs='false' and $stubLength='Short') or ($frontAndBackStubs='true' and $stubLength2='Short' and $stubPeriodType='LongFinal')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***  Value = '<xsl:value-of select="$stubPeriodType"/>' is inconsistent with presence of swStubLength[<xsl:value-of select="$href"/>] Value = Short.</text>
</error>
</xsl:if>
</xsl:when>
</xsl:choose>
<xsl:variable name="pos">
<xsl:choose>
<xsl:when test="starts-with($stubPeriodType,'Short')">
<xsl:value-of select="substring-after($stubPeriodType,'Short')"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="substring-after($stubPeriodType,'Long')"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:choose>
<xsl:when test="$pos='Initial' and $stubPosition='End' and $frontAndBackStubs='false'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***  Value = '<xsl:value-of select="$stubPeriodType"/>' is inconsistent with presence of swbStubPosition Value = 'End'.</text>
</error>
</xsl:when>
<xsl:when test="$pos='Final'and $stubPosition='Start' and $frontAndBackStubs='false'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***  Value = '<xsl:value-of select="$stubPeriodType"/>' is inconsistent with presence of swbStubPosition Value = 'Start'.</text>
</error>
</xsl:when>
</xsl:choose>
<xsl:if test="$pos='Initial' and $frontAndBackStubs='false'">
<xsl:if test="$trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:stubCalculationPeriodAmount/fpml:finalStub">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** stubPeriodType value of '<xsl:value-of select="$stubPeriodType"/> is inconsistent with presence of floating leg /stubCalculationPeriodAmount/finalStub element.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$pos='Final' and $frontAndBackStubs='false'">
<xsl:if test="$trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:stubCalculationPeriodAmount/fpml:initialStub">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** stubPeriodType value of '<xsl:value-of select="$stubPeriodType"/> is inconsistent with presence of floating leg /stubCalculationPeriodAmount/initialStub element.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:variable name="rollConvention">
<xsl:value-of select="ancestor::fpml:swapStream/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:rollConvention"/>
</xsl:variable>
<xsl:if test="starts-with($rollConvention,'IMM') and $productType!='IRS' and $productType!='Cross Currency IRS' and $productType!='Fixed Fixed Swap' and $productType!='OIS' and $productType!='Single Currency Basis Swap'">
<xsl:if test="$stubPeriodType !='ShortInitial' and $stubPeriodType !='LongInitial'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** stubPeriodType must equal ShortInitial or LongInitial for IMM rolls.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:effectiveDate">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="//fpml:swap">
<xsl:variable name="businessDayConvention1">
<xsl:value-of select="fpml:dateAdjustments/fpml:businessDayConvention"/>
</xsl:variable>
<xsl:if test="$businessDayConvention1!='NONE'">
<xsl:variable name="businessDayConvention2">
<xsl:value-of select="../../fpml:paymentDates/fpml:paymentDatesAdjustments/fpml:businessDayConvention"/>
</xsl:variable>
<xsl:if test="$businessDayConvention1!=$businessDayConvention2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***  If not equal to 'NONE' dateAdjustments/businessDayConvention must equal ../../paymentDates/paymentDatesAdjustments/businessDayConvention.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
<xsl:if test="//fpml:swap and not($productType='ZCInflationSwap') and $productType!='IRS' and $productType!='OIS'">
<xsl:variable name="businessDayConvention1">
<xsl:value-of select="fpml:dateAdjustments/fpml:businessDayConvention"/>
</xsl:variable>
<xsl:variable name="businessDayConvention2">
<xsl:choose>
<xsl:when test="$productType='Fixed Fixed Swap'">
<xsl:value-of select="//fpml:trade//fpml:swapStream[position()=$fixedLeg]/fpml:calculationPeriodDates/fpml:calculationPeriodDatesAdjustments/fpml:businessDayConvention"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="//fpml:trade//fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodDates/fpml:calculationPeriodDatesAdjustments/fpml:businessDayConvention"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="businessDayConvention3">
<xsl:choose>
<xsl:when test="$productType='Fixed Fixed Swap'">
<xsl:value-of select="//fpml:trade//fpml:swapStream[position()=$fixedLeg2]/fpml:calculationPeriodDates/fpml:calculationPeriodDatesAdjustments/fpml:businessDayConvention"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="//fpml:trade//fpml:swapStream[position()=$floatingLeg2]/fpml:calculationPeriodDates/fpml:calculationPeriodDatesAdjustments/fpml:businessDayConvention"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:if test="$businessDayConvention1!='NONE' and $businessDayConvention2!='NONE' and $businessDayConvention3!='NONE'">
<xsl:variable name="busCenters1">
<xsl:for-each select="fpml:dateAdjustments/fpml:businessCenters/fpml:businessCenter">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:variable>
<xsl:variable name="busCenters2">
<xsl:choose>
<xsl:when test="$productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='Fixed Fixed Swap'">
<xsl:for-each select="../fpml:calculationPeriodDatesAdjustments/fpml:businessCenters/fpml:businessCenter">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:when>
<xsl:otherwise>
<xsl:for-each select="//fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodDates/fpml:calculationPeriodDatesAdjustments/fpml:businessCenters/fpml:businessCenter">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:if test="$busCenters1!= $busCenters2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Under effectiveDate, if dateAdjustments/businessDayConvention is not equal to 'NONE' /dateAdjustments/businessCenters must equal floating/fixed leg calculationPeriodDates/calculationPeriodDatesAdjustments/businessCenters.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">unadjustedDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:unadjustedDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:apply-templates select="fpml:dateAdjustments">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:terminationDate">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="//fpml:swap and not($productType='ZCInflationSwap')">
<xsl:variable name="businessDayConvention1">
<xsl:value-of select="fpml:dateAdjustments/fpml:businessDayConvention"/>
</xsl:variable>
<xsl:variable name="businessDayConvention2">
<xsl:choose>
<xsl:when test="$productType='IRS' or $productType='Cross Currency IRS'">
<xsl:value-of select="../fpml:calculationPeriodDatesAdjustments/fpml:businessDayConvention"/>
</xsl:when>
<xsl:when test="$productType='Fixed Fixed Swap'">
<xsl:value-of select="//fpml:trade//fpml:swapStream[position()=$fixedLeg]/fpml:calculationPeriodDates/fpml:calculationPeriodDatesAdjustments/fpml:businessDayConvention"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="//fpml:trade//fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodDates/fpml:calculationPeriodDatesAdjustments/fpml:businessDayConvention"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="businessDayConvention3">
<xsl:choose>
<xsl:when test="$productType='Fixed Fixed Swap'">
<xsl:value-of select="//fpml:trade//fpml:swapStream[position()=$fixedLeg2]/fpml:calculationPeriodDates/fpml:calculationPeriodDatesAdjustments/fpml:businessDayConvention"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="//fpml:trade//fpml:swapStream[position()=$floatingLeg2]/fpml:calculationPeriodDates/fpml:calculationPeriodDatesAdjustments/fpml:businessDayConvention"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:if test="$businessDayConvention1!='NONE' and $businessDayConvention2!='NONE' and $businessDayConvention3!='NONE'">
<xsl:variable name="busCenters1">
<xsl:for-each select="fpml:dateAdjustments/fpml:businessCenters/fpml:businessCenter">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:variable>
<xsl:variable name="busCenters2">
<xsl:choose>
<xsl:when test="$productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='IRS' or $productType='Cross Currency IRS' or $productType='Fixed Fixed Swap' or $productType='OIS'">
<xsl:for-each select="../fpml:calculationPeriodDatesAdjustments/fpml:businessCenters/fpml:businessCenter">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:when>
<xsl:otherwise>
<xsl:for-each select="//fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodDates/fpml:calculationPeriodDatesAdjustments/fpml:businessCenters/fpml:businessCenter">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:if test="$busCenters1 !='' and $busCenters2 !='' and $busCenters1!= $busCenters2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Under terminationDate, if dateAdjustments/businessDayConvention is not equal to 'NONE' /dateAdjustments/businessCenters must equal floating/fixed leg calculationPeriodDates/calculationPeriodDatesAdjustments/businessCenters.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">unadjustedDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:unadjustedDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:apply-templates select="fpml:dateAdjustments">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:calculationPeriodDatesAdjustments">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="fpml:swap">
<xsl:variable name="businessDayConvention1">
<xsl:value-of select="fpml:businessDayConvention"/>
</xsl:variable>
<xsl:if test="$businessDayConvention1!='NONE'">
<xsl:variable name="businessDayConvention2">
<xsl:value-of select="../../fpml:paymentDates/fpml:paymentDatesAdjustments/fpml:businessDayConvention"/>
</xsl:variable>
<xsl:if test="$businessDayConvention1!=$businessDayConvention2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***  If not equal to 'NONE' businessDayConvention must equal ../../paymentDates/paymentDatesAdjustments/businessDayConvention.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
<xsl:variable name="businessDayConvention">
<xsl:value-of select="fpml:businessDayConvention"/>
</xsl:variable>
<xsl:call-template name="isValidBusinessDayConvention">
<xsl:with-param name="elementName">businessDayConvention</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$businessDayConvention"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="fpml:businessCentersReference">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected element businessCentersReference encountered.</text>
</error>
</xsl:if>
<xsl:if test="$businessDayConvention='NONE'">
<xsl:if test="fpml:businessCenters">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected element businessCenters encountered when businessDayConvention = 'NONE'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$businessDayConvention!='NONE'">
<xsl:if test="not(fpml:businessCenters)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing businessCenters. Needed when businessDayConvention not equal to 'NONE'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:businessCenters">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:calculationPeriodFrequency">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:call-template name="isValidperiodMultiplier">
<xsl:with-param name="elementName">periodMultiplier</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:periodMultiplier"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="isValidPeriod">
<xsl:with-param name="elementName">period</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:period"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:variable name="freq">
<xsl:value-of select="fpml:periodMultiplier"/>
<xsl:value-of select="fpml:period"/>
</xsl:variable>
<xsl:variable name="oisfloatFreq">
<xsl:value-of select="//fpml:swapStream[@id='floatingLeg']/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:periodMultiplier"/>
<xsl:value-of select="//fpml:swapStream[@id='floatingLeg']/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:period"/>
</xsl:variable>
<xsl:variable name="oisfixedFreq">
<xsl:value-of select="//fpml:swapStream[@id='fixedLeg']/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:periodMultiplier"/>
<xsl:value-of select="//fpml:swapStream[@id='fixedLeg']/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:period"/>
</xsl:variable>
<xsl:if test="$productType='OIS'">
<xsl:choose>
<xsl:when test="$freq='1M'"/>
<xsl:when test="$freq='3M'"/>
<xsl:when test="$freq='6M'"/>
<xsl:when test="$freq='1Y'"/>
<xsl:when test="$freq='1T'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** calculationPeriodFrequency must be equal to 1M, 3M, 6M,1Y or 1T if product type is 'OIS'. Value = '<xsl:value-of select="$freq"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:call-template name="isValidRollConvention">
<xsl:with-param name="elementName">rollConvention</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:rollConvention"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:variable name="rollConvention">
<xsl:value-of select="fpml:rollConvention"/>
</xsl:variable>
<xsl:if test="$freq='1T' and $tradeCurrency != 'CLP' and $productType != 'Cross Currency Basis Swap' and $productType != 'Single Currency Basis Swap' and $productType != 'Fixed Fixed Swap' and $productType!='OIS' and $isOISonSwaption='false' and not(starts-with($rollConvention,'IMM'))">
<xsl:if test="not($rollConvention='NONE')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** rollConvention must be equal to 'NONE' if calculationPeriodFrequency is equal to '1T'. Value = '<xsl:value-of select="$rollConvention"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="($productType='OIS' or $isOISonSwaption='true') and $oisfloatFreq='1T' and $oisfixedFreq='1T' and not(starts-with($rollConvention,'IMM'))">
<xsl:if test="not($rollConvention='NONE')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** rollConvention must be equal to 'NONE' if calculationPeriodFrequency is equal to '1T'. Value = '<xsl:value-of select="$rollConvention"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$productType='IRS' and ($tradeCurrency='MXN' or $tradeCurrency='BRL')">
<xsl:if test="not($rollConvention='NONE')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** rollConvention must be equal to 'NONE' if product type is 'SingleCurrencyInterestRateSwap' and currency is 'MXN' or 'BRL'. Value = '<xsl:value-of select="$rollConvention"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="(starts-with($rollConvention,'IMM'))">
<xsl:variable name="floatFreq">
<xsl:value-of select="//fpml:swapStream[@id='floatingLeg']/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:periodMultiplier"/>
<xsl:value-of select="//fpml:swapStream[@id='floatingLeg']/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:period"/>
<xsl:value-of select="//fpml:capFloorStream/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:periodMultiplier"/>
<xsl:value-of select="//fpml:capFloorStream/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:period"/>
</xsl:variable>
<xsl:call-template name="isValidIMMCurrency">
<xsl:with-param name="elementName"/>
<xsl:with-param name="elementValue">
<xsl:value-of select="$tradeCurrency"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="not(../fpml:firstRegularPeriodStartDate or $productType='OIS') ">
<xsl:if test="not( $productType='IRS' or $productType='Single Currency Basis Swap')">
<xsl:call-template name="isValidIMMMonth">
<xsl:with-param name="elementName">../effectiveDate/unadjustedDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="../fpml:effectiveDate/fpml:unadjustedDate"/>
</xsl:with-param>
<xsl:with-param name="calculationPeriodFrequency">
<xsl:value-of select="$floatFreq"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
</xsl:if>
<xsl:if test="not((../fpml:lastRegularPeriodEndDate and ($productType='IRS' or $productType='Cross Currency IRS')) or $productType='OIS')">
<xsl:if test="not( $productType='IRS' or $productType='Single Currency Basis Swap')">
<xsl:call-template name="isValidIMMMonth">
<xsl:with-param name="elementName">../terminationDate/unadjustedDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="../fpml:terminationDate/fpml:unadjustedDate"/>
</xsl:with-param>
<xsl:with-param name="calculationPeriodFrequency">
<xsl:value-of select="$floatFreq"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
</xsl:if>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:paymentDates">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="href">
<xsl:value-of select="fpml:calculationPeriodDatesReference/@href"/>
</xsl:variable>
<xsl:variable name="id">
<xsl:value-of select="../fpml:calculationPeriodDates/@id"/>
</xsl:variable>
<xsl:if test="$href!=$id">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid calculationPeriodDatesReference/@href value. Value is not equal to ../calculationPeriodDates/@id. Value of href = '<xsl:value-of select="$href"/>' and id = '<xsl:value-of select="$id"/>'.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:paymentFrequency">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:firstPaymentDate">
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">firstPaymentDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:firstPaymentDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:lastRegularPaymentDate">
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">lastRegularPaymentDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:lastRegularPaymentDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:variable name="payRelativeTo">
<xsl:value-of select="fpml:payRelativeTo"/>
</xsl:variable>
<xsl:call-template name="isValidPayRelativeTo">
<xsl:with-param name="elementName">payRelativeTo</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$payRelativeTo"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:apply-templates select="fpml:paymentDaysOffset">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:paymentDatesAdjustments">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:paymentFrequency">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="periodMultiplier">
<xsl:value-of select="fpml:periodMultiplier"/>
</xsl:variable>
<xsl:call-template name="isValidperiodMultiplier">
<xsl:with-param name="elementName">periodMultiplier</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$periodMultiplier"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:variable name="period">
<xsl:value-of select="fpml:period"/>
</xsl:variable>
<xsl:call-template name="isValidPeriod">
<xsl:with-param name="elementName">period</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$period"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:variable name="freq">
<xsl:value-of select="fpml:periodMultiplier"/>
<xsl:value-of select="fpml:period"/>
</xsl:variable>
<xsl:if test="$productType='OIS'">
<xsl:choose>
<xsl:when test="$freq='1M'"/>
<xsl:when test="$freq='3M'"/>
<xsl:when test="$freq='6M'"/>
<xsl:when test="$freq='1Y'"/>
<xsl:when test="$freq='1T'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** paymentFrequency must be equal to 1M, 3M, 6M,1Y or 1T if product type is 'OIS'. Value = '<xsl:value-of select="$freq"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:paymentDaysOffset">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="periodMultiplier">
<xsl:value-of select="fpml:periodMultiplier"/>
</xsl:variable>
<xsl:call-template name="isValidperiodMultiplier">
<xsl:with-param name="elementName">periodMultiplier</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$periodMultiplier"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="$periodMultiplier='0'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** periodMultiplier must not be equal to '0'</text>
</error>
</xsl:if>
<xsl:variable name="period">
<xsl:value-of select="fpml:period"/>
</xsl:variable>
<xsl:if test="$period!='D'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** period must be equal to 'D' in this context. Value = '<xsl:value-of select="$period"/>'</text>
</error>
</xsl:if>
<xsl:variable name="dayType">
<xsl:value-of select="fpml:dayType"/>
</xsl:variable>
<xsl:if test="$dayType!='Business'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** dayType must be equal to 'Business'. Value = '<xsl:value-of select="$dayType"/>'</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:paymentDatesAdjustments">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="businessDayConvention">
<xsl:value-of select="fpml:businessDayConvention"/>
</xsl:variable>
<xsl:if test="$businessDayConvention='NONE'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** businessDayConvention must not be equal to 'NONE'.</text>
</error>
</xsl:if>
<xsl:call-template name="isValidBusinessDayConvention">
<xsl:with-param name="elementName">businessDayConvention</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$businessDayConvention"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="fpml:businessCentersReference">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected element businessCentersReference encountered.</text>
</error>
</xsl:if>
<xsl:if test="$businessDayConvention!='NONE'">
<xsl:if test="not(fpml:businessCenters)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing businessCenters. Needed when businessDayConvention not equal to 'NONE'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:businessCenters">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:resetDates">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="href">
<xsl:value-of select="fpml:calculationPeriodDatesReference/@href"/>
</xsl:variable>
<xsl:variable name="id">
<xsl:value-of select="../fpml:calculationPeriodDates/@id"/>
</xsl:variable>
<xsl:if test="$href!=$id">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid calculationPeriodDatesReference/@href value. Value is not equal to ../calculationPeriodDates/@id. Value of href = '<xsl:value-of select="$href"/>' and id = '<xsl:value-of select="$id"/>'.</text>
</error>
</xsl:if>
<xsl:variable name="id2">
<xsl:value-of select="./@id"/>
</xsl:variable>
<xsl:if test="$id2 =''">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Empty or missing resetDates/@id value. Value = '<xsl:value-of select="$id2"/>'.</text>
</error>
</xsl:if>
<xsl:variable name="resetFreq">
<xsl:value-of select="fpml:resetFrequency/fpml:periodMultiplier"/>
<xsl:value-of select="fpml:resetFrequency/fpml:period"/>
</xsl:variable>
<xsl:if test="fpml:resetRelativeTo">
<xsl:if test="$resetFreq= '1D'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected resetRelativeTo child element encountered. Not allowed if Reset Frequency is daily.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="($productType='Single Currency Basis Swap' or $productType='OIS') and fpml:calculationMethod">
<xsl:variable name="calcMethod">
<xsl:value-of select="fpml:calculationMethod"/>
</xsl:variable>
<xsl:if test="$resetFreq!='1D' and $calcMethod=''">
<xsl:call-template name="isValidResetRelativeTo">
<xsl:with-param name="elementName">resetRelativeTo</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:resetRelativeTo"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
</xsl:if>
<xsl:if test="$resetFreq!='1D' and ($productType != 'Single Currency Basis Swap' and  $productType !='OIS')">
<xsl:call-template name="isValidResetRelativeTo">
<xsl:with-param name="elementName">resetRelativeTo</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:resetRelativeTo"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:rateCutOffDaysOffset">
<xsl:if test="$resetFreq!='1D'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected rateCutOffDays child element encountered. Not allowed unless Reset Frequency is daily.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:initialFixingDate">
<xsl:if test="$productType='CapFloor'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected initialFixingDate child element encountered. Not allowed if product type is 'CapFloor'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:initialFixingDate">
<xsl:if test="not($productType='Cross Currency IRS' or $productType='Cross Currency Basis Swap' or $tradeCurrency = 'USD' or $tradeCurrency = 'CHF' or $tradeCurrency = 'JPY' or $tradeCurrency = 'MXN' or $tradeCurrency = 'SGD' or $tradeCurrency = 'CNY' or $tradeCurrency = 'MYR' or $tradeCurrency = 'TWD' or $tradeCurrency2 = 'USD' or $tradeCurrency2 = 'CHF' or $tradeCurrency2 = 'JPY' or $tradeCurrency2 = 'MXN' or $tradeCurrency2 = 'SGD' or $tradeCurrency2 = 'CNY' or $tradeCurrency2 = 'MYR' or $tradeCurrency2 = 'TWD' )">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** initialFixingDate should only be present if trade currency is equal to 'USD' or 'CHF' or 'JPY' or 'MXN' or 'SGD' or 'CNY' or 'MYR' or 'TWD'. Value = '<xsl:value-of select="$tradeCurrency"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:initialFixingDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:fixingDates">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:initialFixingDate">
<xsl:variable name="initialFixingperiodMultiplier">
<xsl:for-each select="fpml:initialFixingDate/fpml:periodMultiplier">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:variable>
<xsl:variable name="fixingperiodMultiplier">
<xsl:for-each select="fpml:fixingDates/fpml:periodMultiplier">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:variable>
<xsl:variable name="initialFixingBusCenters">
<xsl:for-each select="fpml:initialFixingDate/fpml:businessCenters/fpml:businessCenter">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:variable>
<xsl:variable name="fixingBusCenters">
<xsl:for-each select="fpml:fixingDates/fpml:businessCenters/fpml:businessCenter">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:variable>
<xsl:if test="($initialFixingperiodMultiplier = $fixingperiodMultiplier) and ($initialFixingBusCenters = $fixingBusCenters)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** initialFixingDate offset rules must only be included if they are different to those specified in fixingDates. Currently they are specified the same.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:resetFrequency">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:resetDatesAdjustments">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:rateCutOffDaysOffset">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:initialFixingDate|fpml:fixingDates">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="periodMultiplier">
<xsl:value-of select="fpml:periodMultiplier"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$tradeCurrency = 'BRL'">
<xsl:call-template name="isValidIntegerNumber">
<xsl:with-param name="elementName">periodMultiplier</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$periodMultiplier"/>
</xsl:with-param>
<xsl:with-param name="minIncl">-99</xsl:with-param>
<xsl:with-param name="maxIncl">99</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:when>
<xsl:otherwise>
<xsl:call-template name="isValidIntegerNumber">
<xsl:with-param name="elementName">periodMultiplier</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$periodMultiplier"/>
</xsl:with-param>
<xsl:with-param name="minIncl">-99</xsl:with-param>
<xsl:with-param name="maxIncl">0</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:otherwise>
</xsl:choose>
<xsl:variable name="period">
<xsl:value-of select="fpml:period"/>
</xsl:variable>
<xsl:if test="$period!='D'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** period must be equal to 'D' in this context. Value = '<xsl:value-of select="$period"/>'</text>
</error>
</xsl:if>
<xsl:if test="$periodMultiplier='0' and $period='D'">
<xsl:if test="dayType">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** dayType should not be present if periodMultiplier is '0' and period is 'D'.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:businessDayConvention='PRECEDING')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** businessDayConvention must equal 'PRECEDING' if periodMultiplier is '0' and period is 'D'. Value = '<xsl:value-of select="fpml:businessDayConvention"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:variable name="dayType">
<xsl:value-of select="fpml:dayType"/>
</xsl:variable>
<xsl:if test="$periodMultiplier!='0' and $period='D' and $dayType='Business'">
<xsl:if test="not(//fpml:businessDayConvention='NONE')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** businessDayConvention must equal 'NONE' if period is equal to 'D' and periodMultiplier is not equal to '0' and dayType is equal to 'Business'. Value = '<xsl:value-of select="fpml:businessDayConvention"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="not($periodMultiplier='0' and $period='D')">
<xsl:call-template name="isValidDayType">
<xsl:with-param name="elementName">dayType</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$dayType"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:variable name="businessDayConvention">
<xsl:value-of select="fpml:businessDayConvention"/>
</xsl:variable>
<xsl:call-template name="isValidBusinessDayConvention">
<xsl:with-param name="elementName">businessDayConvention</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$businessDayConvention"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="fpml:businessCentersReference">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected element businessCentersReference encountered.</text>
</error>
</xsl:if>
<xsl:if test="$businessDayConvention!='NONE'">
<xsl:if test="not(//fpml:businessCenters)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing businessCenters. Needed when businessDayConvention not equal to 'NONE'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$dayType='Business'">
<xsl:if test="not(//fpml:businessCenters)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing businessCenters. Needed when dayType is equal to 'Business'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:businessCenters">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:variable name="href">
<xsl:value-of select="fpml:dateRelativeTo/@href"/>
</xsl:variable>
<xsl:variable name="id">
<xsl:choose>
<xsl:when test="$productType='Fixed Fixed Swap'">
<xsl:value-of select="../../../../fpml:paymentDates/@id"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="../../fpml:resetDates/@id"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:if test="$href!=$id">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid dateRelativeTo/@href value. Value is not equal to ../../resetDates/@id. Value of href = '<xsl:value-of select="$href"/>' and id = '<xsl:value-of select="$id"/>'.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:resetFrequency">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:call-template name="isValidperiodMultiplier">
<xsl:with-param name="elementName">periodMultiplier</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:periodMultiplier"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="isValidPeriod">
<xsl:with-param name="elementName">period</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:period"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:variable name="freq">
<xsl:value-of select="fpml:periodMultiplier"/>
<xsl:value-of select="fpml:period"/>
</xsl:variable>
<xsl:variable name="swapStreamCurrency">
<xsl:value-of select="../../fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:currency"/>
<xsl:value-of select="../../fpml:calculationPeriodAmount/fpml:calculation/fpml:fxLinkedNotionalSchedule/fpml:varyingNotionalCurrency"/>
</xsl:variable>
<xsl:if test="$productType='CapFloor' or $productType='IRS' or $productType='Swaption'">
<xsl:choose>
<xsl:when test="$tradeCurrency='BRL'">
<xsl:if test="$freq!='1D'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** resetFrequency must be equal to 1D if product type is 'SingleCurrencyInterestRateSwap' and currency is 'BRL'. Value = '<xsl:value-of select="$freq"/>'.</text>
</error>
</xsl:if>
</xsl:when>
<xsl:when test="$freq='28D'"/>
<xsl:when test="$freq='1M'"/>
<xsl:when test="$freq='3M'"/>
<xsl:when test="$freq='6M'"/>
<xsl:when test="$freq='1Y'"/>
<xsl:when test="$freq='1W' and $tradeCurrency='CNY'"/>
<xsl:when test="$freq='1T' and $tradeCurrency='CLP'"/>
<xsl:when test="$freq='1T' and $isOISonSwaption='true'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** resetFrequency must be equal to 1T (OIS on Swaption), 28D, 1M, 3M, 6M or 1Y if product type is 'CapFloor', 'SingleCurrencyInterestRateSwap' or 'Swaption'. Value = '<xsl:value-of select="$freq"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="$productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS'">
<xsl:choose>
<xsl:when test="$freq='1T'"/>
<xsl:when test="$freq='28D'"/>
<xsl:when test="$freq='1M'"/>
<xsl:when test="$freq='3M'"/>
<xsl:when test="$freq='6M'"/>
<xsl:when test="$freq='1Y'"/>
<xsl:when test="$freq='1W' and $swapStreamCurrency='CNY'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** resetFrequency must be equal to 28D, 1M, 3M, 6M or 1Y if product type is 'Cross Currency Basis Swap' or 'Cross Currency IRS'. Value = '<xsl:value-of select="$freq"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="$productType='OIS'">
<xsl:choose>
<xsl:when test="$freq='1M'"/>
<xsl:when test="$freq='3M'"/>
<xsl:when test="$freq='6M'"/>
<xsl:when test="$freq='1Y'"/>
<xsl:when test="$freq='1T'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** resetFrequency must be equal to 1M, 3M, 6M, 1Y or 1T if product type is 'OIS'. Value = '<xsl:value-of select="$freq"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="$productType='Single Currency Basis Swap'">
<xsl:choose>
<xsl:when test="$freq='1D'"/>
<xsl:when test="$freq='1W'"/>
<xsl:when test="$freq='1M'"/>
<xsl:when test="$freq='3M'"/>
<xsl:when test="$freq='6M'"/>
<xsl:when test="$freq='1Y'"/>
<xsl:when test="$freq='1T'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** resetFrequency must be equal to 1D, 1W, 1M, 3M, 6M 1Y or 1T if product type is 'Single Currency Basis Swap'(1T is only supported for OIS indices). Value = '<xsl:value-of select="$freq"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="$freq='1W'">
<xsl:choose>
<xsl:when test="fpml:weeklyRollConvention"/>
<xsl:when test="($productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS') and $swapStreamCurrency='CNY'"/>
<xsl:when test="$tradeCurrency='CNY'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** weeklyRollConvention must be present if resetFrequency='1W'</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="fpml:weeklyRollConvention">
<xsl:if test="$freq!='1W'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected weeklyRollConvention child element encountered. Not allowed unless Reset Frequency is weekly.</text>
</error>
</xsl:if>
<xsl:call-template name="isValidWeeklyRollConvention">
<xsl:with-param name="elementName">weeklyRollConvention</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:weeklyRollConvention"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:swRollFrequency">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:call-template name="isValidperiodMultiplier">
<xsl:with-param name="elementName">periodMultiplier</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:periodMultiplier"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="isValidPeriod">
<xsl:with-param name="elementName">period</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:period"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:template>
<xsl:template match="fpml:swFixed2PaymentFrequency">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:call-template name="isValidperiodMultiplier">
<xsl:with-param name="elementName">periodMultiplier</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:periodMultiplier"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="isValidPeriod">
<xsl:with-param name="elementName">period</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:period"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:template>
<xsl:template match="fpml:swFixedPaymentFrequency">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:call-template name="isValidperiodMultiplier">
<xsl:with-param name="elementName">periodMultiplier</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:periodMultiplier"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="isValidPeriod">
<xsl:with-param name="elementName">period</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:period"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:template>
<xsl:template match="fpml:swFloatPaymentFrequency">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:call-template name="isValidperiodMultiplier">
<xsl:with-param name="elementName">periodMultiplier</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:periodMultiplier"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="isValidPeriod">
<xsl:with-param name="elementName">period</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:period"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:template>
<xsl:template match="fpml:swCompoundingMethod">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:call-template name="isValidCompoundingMethod">
<xsl:with-param name="elementName">swCompoundingMethod</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$swShortFormTrade//fpml:swCompoundingMethod"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:template>
<xsl:template match="fpml:swFixed2StubLength">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:call-template name="isValidStubLength">
<xsl:with-param name="elementName">swFixed2StubLength</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$swShortFormTrade//fpml:swFixed2StubLength"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:template>
<xsl:template match="fpml:swFixedStubLength">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:call-template name="isValidStubLength">
<xsl:with-param name="elementName">swFixedStubLength</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$swShortFormTrade//fpml:swFixedStubLength"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:template>
<xsl:template match="fpml:swFloatStubLength">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:call-template name="isValidStubLength">
<xsl:with-param name="elementName">swFloatStubLength</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$swShortFormTrade//fpml:swFloatStubLength"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:template>
<xsl:template match="fpml:swStubIndexTenor">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:call-template name="isValidperiodMultiplier">
<xsl:with-param name="elementName">periodMultiplier</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:periodMultiplier"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="isValidPeriod">
<xsl:with-param name="elementName">period</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:period"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:template>
<xsl:template match="fpml:resetDatesAdjustments">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="businessDayConvention">
<xsl:value-of select="fpml:businessDayConvention"/>
</xsl:variable>
<xsl:call-template name="isValidBusinessDayConvention">
<xsl:with-param name="elementName">businessDayConvention</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$businessDayConvention"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="fpml:businessCentersReference">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected element businessCentersReference encountered.</text>
</error>
</xsl:if>
<xsl:if test="$businessDayConvention!='NONE'">
<xsl:if test="not(//fpml:businessCenters)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing businessCenters. Needed when businessDayConvention not equal to 'NONE'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:businessCenters">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:rateCutOffDaysOffset">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="periodMultiplier">
<xsl:value-of select="fpml:periodMultiplier"/>
</xsl:variable>
<xsl:call-template name="isValidIntegerNumber">
<xsl:with-param name="elementName">periodMultiplier</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$periodMultiplier"/>
</xsl:with-param>
<xsl:with-param name="minIncl">-99</xsl:with-param>
<xsl:with-param name="maxIncl">0</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="$periodMultiplier='0'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** periodMultiplier must not be equal to '0'</text>
</error>
</xsl:if>
<xsl:variable name="period">
<xsl:value-of select="fpml:period"/>
</xsl:variable>
<xsl:if test="$period!='D'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** period must be equal to 'D'. Value = '<xsl:value-of select="$period"/>'</text>
</error>
</xsl:if>
<xsl:variable name="dayType">
<xsl:value-of select="fpml:dayType"/>
</xsl:variable>
<xsl:if test="$dayType!='Business'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** dayType must be equal to 'Business'. Value = '<xsl:value-of select="$dayType"/>'</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:calculationPeriodAmount">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="$interestRateSwapType = 'zeroCouponInterestRateSwapWithFixedAmount'">
<xsl:apply-templates select="fpml:knownAmountSchedule">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
<xsl:apply-templates select="fpml:calculation">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:knownAmountSchedule">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="initialValue">
<xsl:value-of select="fpml:initialValue"/>
</xsl:variable>
<xsl:variable name="minimumBound">
<xsl:choose>
<xsl:when test="$isNettingInstruction and ($productType = 'IRS' or $productType = 'OIS' or $productType = 'ZC Inflation Swap')">
<xsl:value-of select="-3999999999999.99"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="0.01"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">initialValue</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$initialValue"/>
</xsl:with-param>
<xsl:with-param name="minIncl">minimumBound</xsl:with-param>
<xsl:with-param name="maxIncl">3999999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:template>
<xsl:template match="fpml:calculation">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:call-template name="isValidDayCountFraction">
<xsl:with-param name="elementName">dayCountFraction</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:dayCountFraction"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="fpml:compoundingMethod">
<xsl:choose>
<xsl:when test="not(../../fpml:resetDates)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** compoundingMethod must only exist on floating stream.</text>
</error>
</xsl:when>
<xsl:when test="fpml:compoundingMethod = 'SpreadExclusive' and //fpml:documentation/fpml:contractualDefinitions = 'ISDA2000'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** compoundingMethod of SpreadExclusive not valid under contractual definition of ISDA2000.</text>
</error>
</xsl:when>
<xsl:otherwise>
<xsl:call-template name="isValidCompoundingMethod">
<xsl:with-param name="elementName">compoundingMethod</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:compoundingMethod"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="../../fpml:resetDates">
<xsl:variable name="calcFreq">
<xsl:value-of select="../../fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:periodMultiplier"/>
<xsl:value-of select="../../fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:period"/>
</xsl:variable>
<xsl:variable name="payFreq">
<xsl:value-of select="../../fpml:paymentDates/fpml:paymentFrequency/fpml:periodMultiplier"/>
<xsl:value-of select="../../fpml:paymentDates/fpml:paymentFrequency/fpml:period"/>
</xsl:variable>
<xsl:if test="not($calcFreq = $payFreq)">
<xsl:if test="not(//fpml:compoundingMethod) and $isNettingInstruction='false'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing element. compoundingMethod must be present when compounding is implied by different payment and calculation frequencies.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$calcFreq = $payFreq and $tradeCurrency != 'CLP' ">
<xsl:if test="fpml:compoundingMethod">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** compoundingMethod must not be present when compounding is not implied by payment and calculation frequencies.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:notionalSchedule">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="($productType='ZCInflationSwap')">
<xsl:apply-templates select="fpml:inflationRateCalculation">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
<xsl:apply-templates select="fpml:fixedRateSchedule">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:floatingRateCalculation">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="$MarkToMarket='true'">
<xsl:apply-templates select="fpml:fxLinkedNotionalSchedule">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:settlementProvision">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="fpml:settlementProvision">
<xsl:if test="not($productType='IRS' or $productType='OIS' or $productType='Swaption' or $productType='Cross Currency IRS' or $productType='Cross Currency Basis Swap' or $productType='Fixed Fixed Swap')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** settlementProvision should only be present if product type is 'SingleCurrencyInterestRateSwap' or 'OIS' or 'Swaption' or 'Cross Currency IRS' or 'Cross Currency Basis Swap'. Value = '<xsl:value-of select="$productType"/>' .</text>
</error>
</xsl:if>
</xsl:if>
<xsl:variable name="settlementCurrency">
<xsl:value-of select="fpml:settlementCurrency"/>
</xsl:variable>
<xsl:if test="not($settlementCurrency = 'USD')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** settlementCurrency must be equal to 'USD'. Value = '<xsl:value-of select="$settlementCurrency"/>'.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:nonDeliverableSettlement">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:nonDeliverableSettlement">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:call-template name="isValidNonDeliverableCurrency">
<xsl:with-param name="elementName">fpml:referenceCurrency</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:referenceCurrency"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="not($productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='Fixed Fixed Swap')">
<xsl:if test="$tradeCurrency != fpml:referenceCurrency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** referenceCurrency value of '<xsl:value-of select="fpml:referenceCurrency"/>' must equal Trade Currency of '<xsl:value-of select="$tradeCurrency"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:fxFixingDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:fxFixingDate ">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="periodMultiplier">
<xsl:value-of select="fpml:periodMultiplier"/>
</xsl:variable>
<xsl:call-template name="isValidIntegerNumber">
<xsl:with-param name="elementName">periodMultiplier</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$periodMultiplier"/>
</xsl:with-param>
<xsl:with-param name="minIncl">-99</xsl:with-param>
<xsl:with-param name="maxIncl">0</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:variable name="period">
<xsl:value-of select="fpml:period"/>
</xsl:variable>
<xsl:if test="$period!='D'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** period must be equal to 'D'. Value = '<xsl:value-of select="$period"/>'</text>
</error>
</xsl:if>
<xsl:if test="$periodMultiplier='0' and $period='D'">
<xsl:if test="fpml:dayType">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** dayType should not be present if periodMultiplier is '0' and period is 'D'.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:businessDayConvention='NONE')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** businessDayConvention must equal 'NONE' if periodMultiplier is '0' and period is 'D'. Value = '<xsl:value-of select="fpml:businessDayConvention"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:variable name="dayType">
<xsl:value-of select="fpml:dayType"/>
</xsl:variable>
<xsl:if test="$periodMultiplier!='0' and $period='D' and $dayType='Business'">
<xsl:if test="not(fpml:businessDayConvention='NONE')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** businessDayConvention must equal 'NONE' if period is equal to 'D' and periodMultiplier is not equal to '0' and dayType is equal to 'Business'. Value = '<xsl:value-of select="fpml:businessDayConvention"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="not($periodMultiplier='0' and $period='D')">
<xsl:call-template name="isValidDayType">
<xsl:with-param name="elementName">dayType</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$dayType"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:variable name="businessDayConvention">
<xsl:value-of select="fpml:businessDayConvention"/>
</xsl:variable>
<xsl:call-template name="isValidBusinessDayConvention">
<xsl:with-param name="elementName">businessDayConvention</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$businessDayConvention"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="fpml:businessCentersReference">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected element businessCentersReference encountered.</text>
</error>
</xsl:if>
<xsl:if test="$businessDayConvention!='NONE'">
<xsl:if test="not(fpml:businessCenters)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing businessCenters. Needed when businessDayConvention not equal to 'NONE'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$dayType='Business'">
<xsl:if test="not(fpml:businessCenters)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing businessCenters. Needed when dayType is equal to 'Business'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:businessCenters">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="count(.//fpml:paymentDatesReference[@href])  != 2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of paymentDatesReference elements encountered. 2 expected.</text>
</error>
</xsl:if>
<xsl:variable name="href1">
<xsl:value-of select="fpml:dateRelativeToPaymentDates/fpml:paymentDatesReference[position()=1]/@href"/>
</xsl:variable>
<xsl:variable name="href2">
<xsl:value-of select="fpml:dateRelativeToPaymentDates/fpml:paymentDatesReference[position()=2]/@href"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="($tradeCurrency = 'BRL')">
<xsl:variable name="fixedId">
<xsl:value-of select="$trade//fpml:swap/fpml:swapStream[position()=$fixedLeg]/fpml:calculationPeriodDates/fpml:terminationDate/@id"/>
</xsl:variable>
<xsl:variable name="floatingId">
<xsl:value-of select="$trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodDates/fpml:terminationDate/@id"/>
</xsl:variable>
<xsl:if test="($href1!=$fixedId) and ($href1!=$floatingId)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid paymentDatesReference/@href value. Value is not equal to ../paymentDates/@id. Value of href = '<xsl:value-of select="$href1"/>' and id values are '<xsl:value-of select="$fixedId"/>' and '<xsl:value-of select="$floatingId"/>'.</text>
</error>
</xsl:if>
<xsl:if test="($href2!=$fixedId) and ($href2!=$floatingId)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid paymentDatesReference/@href value. Value is not equal to ../paymentDates/@id. Value of href = '<xsl:value-of select="$href2"/>' and id values are '<xsl:value-of select="$fixedId"/>' and '<xsl:value-of select="$floatingId"/>'.</text>
</error>
</xsl:if>
</xsl:when>
<xsl:when test="$productType='Cross Currency Basis Swap'">
<xsl:variable name="floatingId">
<xsl:value-of select="$trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:paymentDates/@id"/>
</xsl:variable>
<xsl:variable name="floatingRef">
<xsl:value-of select="$trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:paymentDates/fpml:calculationPeriodDatesReference/@href"/>
</xsl:variable>
<xsl:variable name="floatingId2">
<xsl:value-of select="$trade//fpml:swap/fpml:swapStream[position()=$floatingLeg2]/fpml:paymentDates/@id"/>
</xsl:variable>
<xsl:variable name="floatingRef2">
<xsl:value-of select="$trade//fpml:swap/fpml:swapStream[position()=$floatingLeg2]/fpml:paymentDates/fpml:calculationPeriodDatesReference/@href"/>
</xsl:variable>
<xsl:if test="($href1!=$floatingId) and ($href1!=$floatingId2) and ($href1!=$floatingRef)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid paymentDatesReference/@href value. Value is not equal to ../paymentDates/@id or calculationPeriodDatesReference/@href. Value of href = '<xsl:value-of select="$href1"/>' and id values are '<xsl:value-of select="$floatingId"/>','<xsl:value-of select="$floatingRef"/>','<xsl:value-of select="$floatingRef2"/>' and '<xsl:value-of select="$floatingId2"/>'.</text>
</error>
</xsl:if>
<xsl:if test="($href2!=$floatingId) and ($href2!=$floatingId2) and ($href2!=$floatingRef2)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid paymentDatesReference/@href value. Value is not equal to ../paymentDates/@id or calculationPeriodDatesReference/@href. Value of href = '<xsl:value-of select="$href2"/>' and id values are '<xsl:value-of select="$floatingId"/>','<xsl:value-of select="$floatingRef2"/>','<xsl:value-of select="$floatingRef"/>' and '<xsl:value-of select="$floatingId2"/>'.</text>
</error>
</xsl:if>
<xsl:if test="($href1=$floatingRef and $href2!=$floatingRef2) or ($href2=$floatingRef2 and $href1!=$floatingRef)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid paymentDatesReference/@href values combination.Value of href1 = '<xsl:value-of select="$href1"/> and Value of href2 = '<xsl:value-of select="$href2"/>'.</text>
</error>
</xsl:if>
</xsl:when>
<xsl:otherwise>
<xsl:variable name="fixedId">
<xsl:value-of select="$trade//fpml:swap/fpml:swapStream[position()=$fixedLeg]/fpml:paymentDates/@id"/>
</xsl:variable>
<xsl:variable name="fixedRef">
<xsl:value-of select="$trade//fpml:swap/fpml:swapStream[position()=$fixedLeg]/fpml:paymentDates/fpml:calculationPeriodDatesReference/@href"/>
</xsl:variable>
<xsl:variable name="floatingId">
<xsl:value-of select="$trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:paymentDates/@id"/>
</xsl:variable>
<xsl:variable name="floatingRef">
<xsl:value-of select="$trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:paymentDates/fpml:calculationPeriodDatesReference/@href"/>
</xsl:variable>
<xsl:if test="($href1!=$fixedId) and ($href1!=$floatingId) and ($href1!=$fixedRef)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid paymentDatesReference/@href value. Value is not equal to ../paymentDates/@id or calculationPeriodDatesReference/@href. Value of href = '<xsl:value-of select="$href1"/>' and id values are '<xsl:value-of select="$fixedId"/>', '<xsl:value-of select="$fixedRef"/>,'<xsl:value-of select="$floatingRef"/>' and '<xsl:value-of select="$floatingId"/>'.</text>
</error>
</xsl:if>
<xsl:if test="($href2!=$fixedId) and ($href2!=$floatingId) and ($href2!=$floatingRef)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid paymentDatesReference/@href value. Value is not equal to ../paymentDates/@id or calculationPeriodDatesReference/@href. Value of href = '<xsl:value-of select="$href2"/>' and id values are '<xsl:value-of select="$fixedId"/>','<xsl:value-of select="$fixedRef"/>,'<xsl:value-of select="$floatingRef"/>' and '<xsl:value-of select="$floatingId"/>'.</text>
</error>
</xsl:if>
<xsl:if test="($href1=$fixedRef and $href2!=$floatingRef) or ($href2=$floatingRef and $href1!=$fixedRef)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid paymentDatesReference/@href values combination.Value of href1 = '<xsl:value-of select="$href1"/> and Value of href2 = '<xsl:value-of select="$href2"/>'.</text>
</error>
</xsl:if>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template match="fpml:swSettlementProvision">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="not(fpml:swSettlementCurrency = 'USD')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swSettlementCurrency must be equal to 'USD'. Value = '<xsl:value-of select="fpml:swSettlementCurrency"/>'.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:swNonDeliverableSettlement">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:swNonDeliverableSettlement">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:call-template name="isValidNonDeliverableCurrency">
<xsl:with-param name="elementName">swReferenceCurrency</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swReferenceCurrency"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="not($productType='Cross Currency Basis Swap' and $productType='Cross Currency IRS' or $productType='Fixed Fixed Swap')">
<xsl:if test="$tradeCurrency != fpml:swReferenceCurrency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swReferenceCurrency value of '<xsl:value-of select="fpml:swReferenceCurrency"/>' must equal Trade Currency of '<xsl:value-of select="$tradeCurrency"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="swFxFixingSchedule and fpml:swReferenceCurrency!='BRL'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swFxFixingSchedule must not be given when swReferenceCurrency value is not 'BRL'.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:swFxFixingSchedule">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:swFxFixingSchedule">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">unadjustedDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:unadjustedDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:for-each select="fpml:dateAdjustments">
<xsl:call-template name="isValidNonDeliverableDateAdjustments">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:for-each>
</xsl:template>
<xsl:template name="isValidNonDeliverableDateAdjustments">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:call-template name="isValidBusinessDayConvention">
<xsl:with-param name="elementName">businessDayConvention</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:businessDayConvention"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="fpml:businessCentersReference">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected element businessCentersReference encountered.</text>
</error>
</xsl:if>
<xsl:if test="businessDayConvention!='NONE'">
<xsl:if test="not(fpml:businessCenters)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing businessCenters. Needed when businessDayConvention not equal to 'NONE'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:dayType='Business'">
<xsl:if test="not(fpml:businessCenters)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing businessCenters. Needed when dayType is equal to 'Business'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:businessCenters">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:swFutureValue">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="calculationPeriodNumberOfDays">
<xsl:value-of select="fpml:calculationPeriodNumberOfDays"/>
</xsl:variable>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">calculationPeriodNumberOfDays</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$calculationPeriodNumberOfDays"/>
</xsl:with-param>
<xsl:with-param name="minIncl">1</xsl:with-param>
<xsl:with-param name="maxIncl">3999999999999</xsl:with-param>
<xsl:with-param name="maxDecs">0</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:apply-templates select="fpml:swNotionalFutureValue">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:swNotionalFutureValue">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="href">
<xsl:value-of select="@href"/>
</xsl:variable>
<xsl:variable name="id">
<xsl:value-of select="$trade//fpml:swap/fpml:swapStream[position()=$fixedLeg]/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/@id"/>
</xsl:variable>
<xsl:if test="($href!=$id)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid swNotionalFutureValue/@href value. Value is not equal to ../calculationPeriodAmount/calculation/notionalSchedule/@id. Value of href = '<xsl:value-of select="$href"/>' and id value is: <xsl:value-of select="$id"/>.</text>
</error>
</xsl:if>
<xsl:variable name="notionalFutureValueCurrency">
<xsl:value-of select="fpml:currency"/>
</xsl:variable>
<xsl:if test="$notionalFutureValueCurrency != $tradeCurrency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swNotionalFutureValue/currency must be the same as the trade currency. Value = '<xsl:value-of select="$notionalFutureValueCurrency"/>'.</text>
</error>
</xsl:if>
<xsl:call-template name="isValidCurrency">
<xsl:with-param name="elementName">currency</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:currency"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:variable name="amount">
<xsl:value-of select="fpml:amount"/>
</xsl:variable>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">amount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$amount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.01</xsl:with-param>
<xsl:with-param name="maxIncl">3999999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:template>
<xsl:template match="fpml:notionalSchedule">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:apply-templates select="fpml:notionalStepSchedule">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:notionalStepSchedule">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="initialValue">
<xsl:value-of select="fpml:initialValue"/>
</xsl:variable>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">initialValue</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$initialValue"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.01</xsl:with-param>
<xsl:with-param name="maxIncl">3999999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="isValidCurrency">
<xsl:with-param name="elementName">currency</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:currency"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="fpml:step and $productType != 'IRS' and $productType != 'Single Currency Basis Swap' and $productType != 'Fixed Fixed Swap' and $productType != 'OIS'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** step element must not be specified. Step up/down notional not currently supported via API.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:step">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
<xsl:with-param name="parent">notionalStepSchedule</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template name="validateSteps">
<xsl:param name="context"/>
<xsl:param name="leg"/>
<xsl:variable name="floatingRateScheduleNumberOfSteps">
<xsl:value-of select="(count($trade//fpml:swap/fpml:swapStream[position()=$leg]/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:spreadSchedule/fpml:step))"/>
</xsl:variable>
<xsl:variable name="notionalScheduleSteps">
<xsl:value-of select=" count($trade//fpml:swap/fpml:swapStream[position()=$leg]/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:step)"/>
</xsl:variable>
<xsl:variable name="fixedRateScheduleNumberOfSteps">
<xsl:value-of select="(count($trade//fpml:swap/fpml:swapStream[position()=$leg]/fpml:calculationPeriodAmount/fpml:calculation/fpml:fixedRateSchedule/fpml:step))"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$leg = $floatingLeg or $leg = $floatingLeg2">
<xsl:choose>
<xsl:when test="$floatingRateScheduleNumberOfSteps = $notionalScheduleSteps"/>
<xsl:when test="$floatingRateScheduleNumberOfSteps = 0 or $notionalScheduleSteps = 0"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** same number of step elements not specified in notionalSchedule and spreadSchedule on floating leg <xsl:value-of select="$leg"/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$leg = $fixedLeg">
<xsl:choose>
<xsl:when test="$fixedRateScheduleNumberOfSteps = $notionalScheduleSteps"/>
<xsl:when test="$fixedRateScheduleNumberOfSteps = 0 or $notionalScheduleSteps = 0"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** same number of step elements not specified in notionalSchedule and fixedRateSchedule on the fixed leg.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** swap leg not identified as fixed or floating.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template match="fpml:step">
<xsl:param name="context"/>
<xsl:param name="parent"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="position()=1 and number(fpml:stepValue) != number(../fpml:initialValue)">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** initial stepValue ('<xsl:value-of select="fpml:stepValue"/>') of schedule does not equal initialValue ('<xsl:value-of select="../fpml:initialValue"/>') for schedule.</text>
</error>
</xsl:if>
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">stepDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:stepDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:variable name="stepOrdinal">
<xsl:value-of select="position()"/>
</xsl:variable>
<xsl:variable name="stepDate">
<xsl:value-of select="fpml:stepDate"/>
</xsl:variable>
<xsl:variable name="thisLeg">
<xsl:choose>
<xsl:when test="ancestor::fpml:swapStream = $trade//fpml:swap/fpml:swapStream[position()=1]">1</xsl:when>
<xsl:when test="ancestor::fpml:swapStream = $trade//fpml:swap/fpml:swapStream[position()=2]">2</xsl:when>
</xsl:choose>
</xsl:variable>
<xsl:variable name="comparisonStepDate">
<xsl:choose>
<xsl:when test="$parent ='notionalStepSchedule'">
<xsl:choose>
<xsl:when test="$trade//fpml:swap/fpml:swapStream[position()=$thisLeg]/fpml:calculationPeriodAmount/fpml:calculation/fpml:fixedRateSchedule/fpml:step[position()=$stepOrdinal]/fpml:stepDate">
<xsl:value-of select="$trade//fpml:swap/fpml:swapStream[position()=$thisLeg]/fpml:calculationPeriodAmount/fpml:calculation/fpml:fixedRateSchedule/fpml:step[position()=$stepOrdinal]/fpml:stepDate"/>
</xsl:when>
<xsl:when test="$trade//fpml:swap/fpml:swapStream[position()=$thisLeg]/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:spreadSchedule/fpml:step[position()=$stepOrdinal]/fpml:stepDate">
<xsl:value-of select="$trade//fpml:swap/fpml:swapStream[position()=$thisLeg]/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:spreadSchedule/fpml:step[position()=$stepOrdinal]/fpml:stepDate"/>
</xsl:when>
<xsl:otherwise>0</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$parent ='fixedRateSchedule' or $parent ='spreadSchedule'">
<xsl:choose>
<xsl:when test="$trade//fpml:swap/fpml:swapStream[position()=$thisLeg]/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:step[position()=$stepOrdinal]/fpml:stepDate">
<xsl:value-of select="$trade//fpml:swap/fpml:swapStream[position()=$thisLeg]/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:step[position()=$stepOrdinal]/fpml:stepDate"/>
</xsl:when>
<xsl:otherwise>0</xsl:otherwise>
</xsl:choose>
</xsl:when>
</xsl:choose>
</xsl:variable>
<xsl:if test="$stepDate != $comparisonStepDate and not ($stepDate = '0' or $comparisonStepDate = '0')">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$parent"/>/step(<xsl:value-of select="$stepOrdinal"/>)/stepDate of '<xsl:value-of select="$stepDate"/>' does not equal the stepDate for the same step in /calculationPeriodAmount/calculation/notionalSchedule/notionalStepSchedule/step(<xsl:value-of select="$stepOrdinal"/>)/stepDate (value of '<xsl:value-of select="$comparisonStepDate"/>').</text>
</error>
</xsl:if>
<xsl:if test="$stepOrdinal &gt; 1">
<xsl:if test="(number(translate($stepDate, '-', '')) - number(translate(../fpml:step[position()=$stepOrdinal - 1]/fpml:stepDate, '-', ''))) &lt; 1">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$parent"/>/step(<xsl:value-of select="$stepOrdinal"/>)/stepDate of '<xsl:value-of select="$stepDate"/>' is not greater than the stepDate of the preceding step (<xsl:value-of select="../fpml:step[position()=$stepOrdinal - 1]/fpml:stepDate"/>)</text>
</error>
</xsl:if>
</xsl:if>
<xsl:choose>
<xsl:when test="$parent='notionalStepSchedule'">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">stepValue</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:stepValue"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.00</xsl:with-param>
<xsl:with-param name="maxIncl">999999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:when>
<xsl:otherwise>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">stepValue</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:stepValue"/>
</xsl:with-param>
<xsl:with-param name="minIncl">
<xsl:choose>
<xsl:when test="$parent='fixedRateSchedule'">-9.9999999999</xsl:when>
<xsl:when test="$parent='spreadSchedule'">-0.099999999999</xsl:when>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="maxIncl">
<xsl:choose>
<xsl:when test="$parent='fixedRateSchedule'">9.9999999999</xsl:when>
<xsl:when test="$parent='spreadSchedule'">0.099999999999</xsl:when>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="maxDecs">
<xsl:choose>
<xsl:when test="$parent='fixedRateSchedule'">10</xsl:when>
<xsl:when test="$parent='spreadSchedule'">12</xsl:when>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template match="fpml:inflationRateCalculation">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="inflationLag">
<xsl:value-of select="fpml:inflationLag/fpml:periodMultiplier"/>
<xsl:value-of select="fpml:inflationLag/fpml:period"/>
</xsl:variable>
<xsl:call-template name="isValidInflationLag">
<xsl:with-param name="elementName">inflationLag</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$inflationLag"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:variable name="interpolationMethod">
<xsl:value-of select="fpml:interpolationMethod"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$interpolationMethod='Linear'"/>
<xsl:when test="$interpolationMethod='None'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** interpolationMethod must be equal to 'Linear' or 'None'. Value = '<xsl:value-of select="$interpolationMethod"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
<xsl:if test="fpml:initialIndexLevel">
<xsl:variable name="initialIndexLevel">
<xsl:value-of select="fpml:initialIndexLevel"/>
</xsl:variable>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">initialIndexLevel</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$initialIndexLevel"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.0000000000</xsl:with-param>
<xsl:with-param name="maxIncl">1000.0000000000</xsl:with-param>
<xsl:with-param name="maxDecs">10</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:variable name="relatedBond">
<xsl:value-of select="fpml:relatedBond"/>
</xsl:variable>
<xsl:if test="string-length($relatedBond) &gt; 12">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid instrumentId string length. Exceeeded max length of 12 characters for productType 'ZCInflationSwap'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:floatingRateIndex">
<xsl:variable name="floatingRateIndex">
<xsl:value-of select="fpml:floatingRateIndex"/>
</xsl:variable>
<xsl:if test="$floatingRateIndex=''">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Empty or missing floatingRateIndex.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:indexSource">
<xsl:if test="fpml:indexSource=''">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** indexSource is empty.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:fixedRateSchedule">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="initialValue">
<xsl:value-of select="fpml:initialValue"/>
</xsl:variable>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">initialValue</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$initialValue"/>
</xsl:with-param>
<xsl:with-param name="minIncl">-9.9999999999</xsl:with-param>
<xsl:with-param name="maxIncl">9.9999999999</xsl:with-param>
<xsl:with-param name="maxDecs">10</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="fpml:step">
<xsl:choose>
<xsl:when test="$productType != 'IRS' and $productType != 'Fixed Fixed Swap' and $productType != 'OIS'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** step element must not be specified. Step up/down fixed rate not currently supported via API.</text>
</error>
</xsl:when>
<xsl:otherwise>
<xsl:call-template name="validateSteps">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
<xsl:with-param name="leg">
<xsl:value-of select="$fixedLeg"/>
</xsl:with-param>
</xsl:call-template>
<xsl:apply-templates select="fpml:step">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
<xsl:with-param name="parent">fixedRateSchedule</xsl:with-param>
</xsl:apply-templates>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:floatingRateCalculation">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="floatingRateIndex">
<xsl:value-of select="fpml:floatingRateIndex"/>
</xsl:variable>
<xsl:if test="$floatingRateIndex=''">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Empty or missing floatingRateIndex.</text>
</error>
</xsl:if>
<xsl:if test="($tradeCurrency != 'PLN' and $floatingRateIndex != 'CNH-HIBOR-TMA' and $floatingRateIndex != 'CNH-HIBOR') and not($productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS') ">
<xsl:if test="contains(substring($floatingRateIndex,4,4),'-')">
<xsl:variable name="floatingRateIndexCurrency">
<xsl:value-of select="substring($floatingRateIndex,1,3)"/>
</xsl:variable>
<xsl:if test="$tradeCurrency != $floatingRateIndexCurrency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** floatingRateIndex value of '<xsl:value-of select="$floatingRateIndex"/>' is not valid for trade currency of '<xsl:value-of select="$tradeCurrency"/>'.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
<xsl:if test="$floatingRateIndex='JPY-TONA-OIS-COMPOUND' or $floatingRateIndex='JPY-TONA-OIS Compound'">
<xsl:if test="fpml:initialRate">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** initialRate must not be present if floating rate index is 'JPY-TONA-OIS-COMPOUND' or 'JPY-TONA-OIS Compound'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$productType='Swaption'">
<xsl:if test="fpml:initialRate">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** initialRate must not be present if product type is 'Swaption'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:initialRate">
<xsl:if test="../../../fpml:stubCalculationPeriodAmount/fpml:initialStub">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** initialRate and ../../../stubCalculationPeriodAmount/initialStub must not both be present.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:initialRate">
<xsl:variable name="initialRate">
<xsl:value-of select="fpml:initialRate"/>
</xsl:variable>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">initialRate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$initialRate"/>
</xsl:with-param>
<xsl:with-param name="minIncl">-9.9999999999</xsl:with-param>
<xsl:with-param name="maxIncl">9.9999999999</xsl:with-param>
<xsl:with-param name="maxDecs">10</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="$productType='Single Currency Basis Swap'">
<xsl:if test="fpml:averagingMethod">
<xsl:call-template name="isValidAveragingMethod">
<xsl:with-param name="elementName">averagingMethod</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:averagingMethod"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="$productType='Single Currency Basis Swap'">
<xsl:variable name="resetFreq">
<xsl:value-of select="../../../fpml:resetDates/fpml:resetFrequency/fpml:periodMultiplier"/>
<xsl:value-of select="../../../fpml:resetDates/fpml:resetFrequency/fpml:period"/>
</xsl:variable>
<xsl:variable name="calcFreq">
<xsl:value-of select="../../../fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:periodMultiplier"/>
<xsl:value-of select="../../../fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:period"/>
</xsl:variable>
<xsl:if test="not(../../../fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:lookback or ../../../fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:lockout or ../../../fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:observationShift)">
<xsl:if test="not($resetFreq = $calcFreq)">
<xsl:if test="not(fpml:averagingMethod)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing element. averagingMethod must be present when averaging is implied by different calculation and reset frequencies.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
<xsl:if test="$resetFreq = $calcFreq">
<xsl:if test="fpml:averagingMethod">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** averagingMethod must not be present when averaging is not implied by calculation and reset frequencies.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
</xsl:if>
<xsl:if test="$productType='OIS' or $isOISonSwaption='true' or $isOISonCapFloor='true'">
<xsl:if test="fpml:indexTenor">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** indexTenor must not be present if product type is 'OIS', 'OIS on Swaption' or 'OIS on CapFloor'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:indexTenor">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:spreadSchedule">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="$productType='CapFloor'">
<xsl:if test="not(fpml:capRateSchedule or fpml:floorRateSchedule)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing element. capRateSchedule or floorRateSchedule must be present if product type is 'CapFloor'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$productType='CapFloor'">
<xsl:if test="fpml:capRateSchedule and fpml:floorRateSchedule">
<xsl:if test="number(fpml:capRateSchedule/fpml:initialValue) != number(fpml:floorRateSchedule/fpml:initialValue)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** When both capRateSchedule and floorRateSchedule are present they must contain the same data.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:capRateSchedule">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:floorRateSchedule">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:fxLinkedNotionalSchedule">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="fpml:initialValue">
<xsl:variable name="initialValue">
<xsl:value-of select="fpml:initialValue"/>
</xsl:variable>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">initialValue</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$initialValue"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.01</xsl:with-param>
<xsl:with-param name="maxIncl">3999999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:call-template name="isValidCurrency">
<xsl:with-param name="elementName">varyingNotionalCurrency</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:choose>
<xsl:when test="$productType='Cross Currency Basis Swap'">
<xsl:value-of select="$trade//fpml:swap/fpml:swapStream[@id='floatingLeg2']/fpml:calculationPeriodAmount/fpml:calculation/fpml:fxLinkedNotionalSchedule/fpml:varyingNotionalCurrency"/>
</xsl:when>
<xsl:when test="$productType='Cross Currency IRS'">
<xsl:value-of select="$trade//fpml:swap/fpml:swapStream[@id='floatingLeg']/fpml:calculationPeriodAmount/fpml:calculation/fpml:fxLinkedNotionalSchedule/fpml:varyingNotionalCurrency"/>
</xsl:when>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:apply-templates select="fpml:varyingNotionalFixingDates">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:fxSpotRateSource">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:varyingNotionalInterimExchangePaymentDates">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:varyingNotionalFixingDates">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="periodMultiplier">
<xsl:value-of select="fpml:periodMultiplier"/>
</xsl:variable>
<xsl:call-template name="isValidIntegerNumber">
<xsl:with-param name="elementName">periodMultiplier</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$periodMultiplier"/>
</xsl:with-param>
<xsl:with-param name="minIncl">-99</xsl:with-param>
<xsl:with-param name="maxIncl">0</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:variable name="period">
<xsl:value-of select="fpml:period"/>
</xsl:variable>
<xsl:if test="$period!='D'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** period must be equal to 'D'. Value = '<xsl:value-of select="$period"/>'</text>
</error>
</xsl:if>
<xsl:variable name="dayType">
<xsl:value-of select="fpml:dayType"/>
</xsl:variable>
<xsl:if test="$dayType!='Business'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** dayType must equal 'Business'. Value = '<xsl:value-of select="fpml:dayType"/>'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:businessDayConvention!='NONE'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** businessDayConvention must equal 'NONE''. Value = '<xsl:value-of select="fpml:businessDayConvention"/>'.</text>
</error>
</xsl:if>
<xsl:if test="$dayType='Business'">
<xsl:if test="not(fpml:businessCenters)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing businessCenters. Needed when dayType is equal to 'Business'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:businessCenters">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:variable name="href">
<xsl:value-of select="fpml:dateRelativeTo/@href"/>
</xsl:variable>
<xsl:variable name="id">
<xsl:choose>
<xsl:when test="$productType='Fixed Fixed Swap'">
<xsl:value-of select="../../../../fpml:paymentDates/@id"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="../../../../fpml:resetDates/@id"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:choose>
<xsl:when test="$productType='Cross Currency Basis Swap'">
<xsl:if test="$href!=$id and $isCompoundingEnabledIndex2 = 'false'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid dateRelativeTo/@href value. Value is not equal to ../resetDates/@id. Value of href = '<xsl:value-of select="$href"/>' and id = '<xsl:value-of select="$id"/>'.</text>
</error>
</xsl:if>
</xsl:when>
<xsl:when test="$productType='Cross Currency IRS'">
<xsl:if test="$href!=$id and $isCompoundingEnabledIndex = 'false'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid dateRelativeTo/@href value. Value is not equal to ../resetDates/@id. Value of href = '<xsl:value-of select="$href"/>' and id = '<xsl:value-of select="$id"/>'.</text>
</error>
</xsl:if>
</xsl:when>
<xsl:otherwise>
<xsl:if test="$href!=$id">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid dateRelativeTo/@href value. Value is not equal to ../resetDates/@id. Value of href = '<xsl:value-of select="$href"/>' and id = '<xsl:value-of select="$id"/>'.</text>
</error>
</xsl:if>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template match="fpml:fxSpotRateSource">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="not(fpml:primaryRateSource/fpml:rateSource) or string-length(fpml:primaryRateSource/fpml:rateSource) = 0">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** primaryRateSource/rateSource must be present if product type is 'Cross Currency Basis Swap' or  'Cross Currency IRS' and it is a Mark-To-Market Swap.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:primaryRateSource/fpml:rateSourcePage) or string-length(fpml:primaryRateSource/fpml:rateSourcePage) = 0">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** primaryRateSource/rateSourcePage must be present if product type is 'Cross Currency Basis Swap' or  'Cross Currency IRS' and it is a Mark-To-Market Swap.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:fixingTime">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:fixingTime">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:call-template name="isValidTime">
<xsl:with-param name="elementName">hourMinuteTime</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:hourMinuteTime"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="isValidBusinessCenter">
<xsl:with-param name="elementName">businessCenter</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:businessCenter"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="assetClass">
<xsl:value-of select="$assetClass"/>
</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:template>
<xsl:template match="fpml:varyingNotionalInterimExchangePaymentDates">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="not(fpml:periodMultiplier='0')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** varyingNotionalInterimExchangePaymentDates/periodMultiplier must be 0 if product type is 'Cross Currency Basis Swap' or  'Cross Currency IRS' and it is a Mark-To-Market Swap.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:period='D')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** varyingNotionalInterimExchangePaymentDates/period must be D if product type is 'Cross Currency Basis Swap' or  'Cross Currency IRS' and it is a Mark-To-Market Swap.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:businessDayConvention='NONE')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** varyingNotionalInterimExchangePaymentDates/businessDayConvention must be NONE if product type is 'Cross Currency Basis Swap' or  'Cross Currency IRS' and it is a Mark-To-Market Swap.</text>
</error>
</xsl:if>
<xsl:variable name="href">
<xsl:value-of select="fpml:dateRelativeTo/@href"/>
</xsl:variable>
<xsl:variable name="id">
<xsl:value-of select="../../../../fpml:paymentDates/@id"/>
</xsl:variable>
<xsl:if test="$href!=$id">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid dateRelativeTo/@href value. Value is not equal to ../../../../paymentDates/@id. Value of href = '<xsl:value-of select="$href"/>' and id = '<xsl:value-of select="$id"/>'.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:indexTenor">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:call-template name="isValidperiodMultiplier">
<xsl:with-param name="elementName">periodMultiplier</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:periodMultiplier"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="isValidPeriod">
<xsl:with-param name="elementName">period</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:period"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="($productType='IRS' or $productType='Swaption') and not(parent::fpml:floatingRate)">
<xsl:variable name="indexTenor">
<xsl:value-of select="fpml:periodMultiplier"/>
<xsl:value-of select="fpml:period"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$indexTenor='28D'"/>
<xsl:when test="$indexTenor='1M'"/>
<xsl:when test="$indexTenor='3M'"/>
<xsl:when test="$indexTenor='6M'"/>
<xsl:when test="$indexTenor='1Y'"/>
<xsl:when test="$indexTenor='12M'"/>
<xsl:when test="$indexTenor='1W' and $tradeCurrency='CNY'"/>
<xsl:when test="$indexTenor='1T' and $tradeCurrency='CLP'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** indexTenor must be equal to 1T (CLP currency), 28D, 1M, 3M, 6M, 12M or 1Y if product type is 'SingleCurrencyInterestRateSwap' or 'Swaption'. Value = '<xsl:value-of select="$indexTenor"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="$productType='FRA'">
<xsl:variable name="indexTenor">
<xsl:value-of select="fpml:periodMultiplier"/>
<xsl:value-of select="fpml:period"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$indexTenor='1W'"/>
<xsl:when test="$indexTenor='2W'"/>
<xsl:when test="$indexTenor='3W'"/>
<xsl:when test="$indexTenor='1M'"/>
<xsl:when test="$indexTenor='2M'"/>
<xsl:when test="$indexTenor='3M'"/>
<xsl:when test="$indexTenor='4M'"/>
<xsl:when test="$indexTenor='5M'"/>
<xsl:when test="$indexTenor='6M'"/>
<xsl:when test="$indexTenor='7M'"/>
<xsl:when test="$indexTenor='8M'"/>
<xsl:when test="$indexTenor='9M'"/>
<xsl:when test="$indexTenor='10M'"/>
<xsl:when test="$indexTenor='11M'"/>
<xsl:when test="$indexTenor='12M'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** indexTenor must be equal to 1W, 2W, 3W, 1M, 2M, 3M, 4M, 5M, 6M, 7M, 8M, 9M, 10M, 11M or 12M if product type is 'FRA'. Value = '<xsl:value-of select="$indexTenor"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="$productType='Single Currency Basis Swap'">
<xsl:variable name="indexTenor">
<xsl:value-of select="fpml:periodMultiplier"/>
<xsl:value-of select="fpml:period"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$indexTenor='1D'"/>
<xsl:when test="$indexTenor='1W'"/>
<xsl:when test="$indexTenor='2W'"/>
<xsl:when test="$indexTenor='3W'"/>
<xsl:when test="$indexTenor='1M'"/>
<xsl:when test="$indexTenor='2M'"/>
<xsl:when test="$indexTenor='3M'"/>
<xsl:when test="$indexTenor='4M'"/>
<xsl:when test="$indexTenor='5M'"/>
<xsl:when test="$indexTenor='6M'"/>
<xsl:when test="$indexTenor='7M'"/>
<xsl:when test="$indexTenor='8M'"/>
<xsl:when test="$indexTenor='9M'"/>
<xsl:when test="$indexTenor='10M'"/>
<xsl:when test="$indexTenor='11M'"/>
<xsl:when test="$indexTenor='12M'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** indexTenor must be equal to 1D, 1W, 2W, 3W, 1M, 2M, 3M, 4M, 5M, 6M, 7M, 8M, 9M, 10, 11M, 12M if product type is 'Single Currency Basis Swap'. Value = '<xsl:value-of select="$indexTenor"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="$productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS'">
<xsl:variable name="indexTenor">
<xsl:value-of select="fpml:periodMultiplier"/>
<xsl:value-of select="fpml:period"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$indexTenor='1D'"/>
<xsl:when test="$indexTenor='28D'"/>
<xsl:when test="$indexTenor='1W'"/>
<xsl:when test="$indexTenor='2W'"/>
<xsl:when test="$indexTenor='3W'"/>
<xsl:when test="$indexTenor='1M'"/>
<xsl:when test="$indexTenor='2M'"/>
<xsl:when test="$indexTenor='3M'"/>
<xsl:when test="$indexTenor='4M'"/>
<xsl:when test="$indexTenor='5M'"/>
<xsl:when test="$indexTenor='6M'"/>
<xsl:when test="$indexTenor='7M'"/>
<xsl:when test="$indexTenor='8M'"/>
<xsl:when test="$indexTenor='9M'"/>
<xsl:when test="$indexTenor='10M'"/>
<xsl:when test="$indexTenor='11M'"/>
<xsl:when test="$indexTenor='12M'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** indexTenor must be equal to 1D, 28D, 1W, 2W, 3W, 1M, 2M, 3M, 4M, 5M, 6M, 7M, 8M, 9M, 10, 11M, 12M if product type is 'Cross Currency Basis Swap'. Value = '<xsl:value-of select="$indexTenor"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:spreadSchedule">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="initialValue">
<xsl:value-of select="fpml:initialValue"/>
</xsl:variable>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">initialValue</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$initialValue"/>
</xsl:with-param>
<xsl:with-param name="minIncl">-0.099999999999</xsl:with-param>
<xsl:with-param name="maxIncl">0.099999999999</xsl:with-param>
<xsl:with-param name="maxDecs">12</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="fpml:step">
<xsl:choose>
<xsl:when test="$productType != 'IRS' and $productType != 'Single Currency Basis Swap' and $productType != 'Fixed Fixed Swap' and $productType != 'OIS'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** step element must not be specified. Step up/down spread not currently supported via API.</text>
</error>
</xsl:when>
<xsl:otherwise>
<xsl:call-template name="validateSteps">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
<xsl:with-param name="leg">
<xsl:value-of select="$floatingLeg"/>
</xsl:with-param>
</xsl:call-template>
<xsl:apply-templates select="fpml:step">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
<xsl:with-param name="parent">spreadSchedule</xsl:with-param>
</xsl:apply-templates>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:capRateSchedule">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">initialValue</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:initialValue"/>
</xsl:with-param>
<xsl:with-param name="minIncl">-9.9999999999</xsl:with-param>
<xsl:with-param name="maxIncl">9.9999999999</xsl:with-param>
<xsl:with-param name="maxDecs">10</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:variable name="buyer">
<xsl:value-of select="fpml:buyer"/>
</xsl:variable>
<xsl:if test="$buyer!='Receiver'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** buyer must be present and equal to 'Receiver'. Value = '<xsl:value-of select="$buyer"/>'.</text>
</error>
</xsl:if>
<xsl:variable name="seller">
<xsl:value-of select="fpml:seller"/>
</xsl:variable>
<xsl:if test="$seller!='Payer'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** seller must be present and equal to 'Payer'. Value = '<xsl:value-of select="$seller"/>'.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:floorRateSchedule">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">initialValue</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:initialValue"/>
</xsl:with-param>
<xsl:with-param name="minIncl">-9.9999999999</xsl:with-param>
<xsl:with-param name="maxIncl">9.9999999999</xsl:with-param>
<xsl:with-param name="maxDecs">10</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:variable name="buyer">
<xsl:value-of select="fpml:buyer"/>
</xsl:variable>
<xsl:if test="$buyer!='Receiver'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** buyer must be present and equal to 'Receiver'. Value = '<xsl:value-of select="$buyer"/>'.</text>
</error>
</xsl:if>
<xsl:variable name="seller">
<xsl:value-of select="fpml:seller"/>
</xsl:variable>
<xsl:if test="$seller!='Payer'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** seller must be present and equal to 'Payer'. Value = '<xsl:value-of select="$seller"/>'.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:stubCalculationPeriodAmount">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="href">
<xsl:value-of select="fpml:calculationPeriodDatesReference/@href"/>
</xsl:variable>
<xsl:variable name="id">
<xsl:value-of select="../fpml:calculationPeriodDates/@id"/>
</xsl:variable>
<xsl:if test="$href!=$id">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid calculationPeriodDatesReference/@href value. Value is not equal to ../calculationPeriodDates/@id. Value of href = '<xsl:value-of select="$href"/>' and id = '<xsl:value-of select="$id"/>'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:initialStub and fpml:finalStub and not($productType='IRS' or $productType='OIS')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** initialStub and finalStub must not both be present.</text>
</error>
</xsl:if>
<xsl:if test="not(//fpml:initialStub or fpml:finalStub)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** initialStub or finalStub must be present.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:initialStub">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:finalStub">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="($tradeCurrency = 'AUD' or $tradeCurrency2 = 'AUD') and (fpml:initialStub/fpml:floatingRate[1]/fpml:floatingRateIndex = 'AUD-RBA Cash Rate'  or fpml:initialStub/fpml:floatingRate[1]/fpml:floatingRateIndex = 'AUD-AONIA' or fpml:finalStub/fpml:floatingRate[1]/fpml:floatingRateIndex = 'AUD-RBA Cash Rate' or fpml:finalStub/fpml:floatingRate[1]/fpml:floatingRateIndex = 'AUD-AONIA') and fpml:floatingRateCalculation/fpml:floatingRate[1] != 'AUD-AONIA'">
<xsl:if test="(string-length(fpml:initialStub/fpml:floatingRate[2]/fpml:floatingRateIndex) &lt; 3) and (string-length(fpml:finalStub/fpml:floatingRate[2]/fpml:floatingRateIndex) &lt; 3)  ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text> *** stub floatingRateIndex[1] value of 'AUD-RBA Cash Rate' or 'AUD-AONIA' is not valid without stub floatingRateIndex[2]. Linear interpolation is required.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="($tradeCurrency = 'NZD' or $tradeCurrency2 = 'NZD') and (fpml:initialStub/fpml:floatingRate[1]/fpml:floatingRateIndex = 'NZD-RBNZ OCR' or fpml:initialStub/fpml:floatingRate[1]/fpml:floatingRateIndex = 'NZD-NZIONA' or fpml:finalStub/fpml:floatingRate[1]/fpml:floatingRateIndex = 'NZD-RBNZ OCR' or fpml:finalStub/fpml:floatingRate[1]/fpml:floatingRateIndex = 'NZD-NZIONA' ) and fpml:floatingRateCalculation/fpml:floatingRate[1] !='NZD-NZIONA'">
<xsl:if test="(string-length(fpml:initialStub/fpml:floatingRate[2]/fpml:floatingRateIndex) &lt; 3) and (string-length(fpml:finalStub/fpml:floatingRate[2]/fpml:floatingRateIndex) &lt; 3)  ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text> *** stub floatingRateIndex[1] value of 'NZD-RBNZ OCR' or 'NZD-NZIONA is not valid without stub floatingRateIndex[2]. Linear interpolation is required.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:initialStub">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="count(fpml:floatingRate) &gt; 2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of floatingRate child elements encountered. 0, 1 or 2 expected. <xsl:value-of select="count(fpml:floatingRate)"/> found.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:floatingRate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:stubRate">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">stubRate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:stubRate"/>
</xsl:with-param>
<xsl:with-param name="minIncl">-9.9999999999</xsl:with-param>
<xsl:with-param name="maxIncl">9.9999999999</xsl:with-param>
<xsl:with-param name="maxDecs">10</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="$productType='CapFloor'or $productType='Swaption'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** stubRate (First fixing rate) is not applicable if product type is 'CapFloor' or 'Swaption'.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:finalStub">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="not(count(fpml:floatingRate)=1 or count(fpml:floatingRate)=2)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of floatingRate child elements encountered. 1 or 2 expected. <xsl:value-of select="count(fpml:floatingRate)"/> found.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:floatingRate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:stubRate">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** stubRate must not be present in this context.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:floatingRate">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:variable name="floatingRateIndex">
<xsl:value-of select="fpml:floatingRateIndex"/>
</xsl:variable>
<xsl:if test="$floatingRateIndex=''">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Empty or missing floatingRateIndex.</text>
</error>
</xsl:if>
<xsl:if test="../../../fpml:stubCalculationPeriodAmount">
<xsl:variable name="floatingRateIndex2">
<xsl:choose>
<xsl:when test="$productType='ZCInflationSwap'">
<xsl:value-of select="../../../fpml:calculationPeriodAmount/fpml:calculation/fpml:inflationRateCalculation/fpml:floatingRateIndex"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="../../../fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:floatingRateIndex"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:if test="$floatingRateIndex != $floatingRateIndex2">
<xsl:variable name="interpTenor">
<xsl:value-of select="fpml:indexTenor/fpml:periodMultiplier"/>
<xsl:value-of select="fpml:indexTenor/fpml:period"/>
</xsl:variable>
<xsl:if test="$interpTenor != '1D' or position() != '1'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** floatingRateIndex (<xsl:value-of select="$floatingRateIndex"/>) must equal ../../../calculationPeriodAmount/calculation/floatingRateCalculation/floatingRateIndex (<xsl:value-of select="$floatingRateIndex2"/>)</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
<xsl:if test="($tradeCurrency != 'PLN' and $floatingRateIndex != 'CNH-HIBOR-TMA' and $floatingRateIndex != 'CNH-HIBOR') and not($productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='ZCInflationSwap')">
<xsl:if test="contains(substring($floatingRateIndex,4,4),'-')">
<xsl:variable name="floatingRateIndexCurrency">
<xsl:value-of select="substring($floatingRateIndex,1,3)"/>
</xsl:variable>
<xsl:if test="$tradeCurrency != $floatingRateIndexCurrency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** floatingRateIndex value of '<xsl:value-of select="$floatingRateIndex"/>' is not valid for trade currency of '<xsl:value-of select="$tradeCurrency"/>'.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:indexTenor">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:spreadSchedule">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** spreadSchedule must not be present in this context.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:earlyTerminationProvision">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="not($swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swEarlyTerminationProvision)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing /SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swEarlyTerminationProvision element. Required if earlyTerminationProvision is present.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:mandatoryEarlyTermination">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:optionalEarlyTermination">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:mandatoryEarlyTermination">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="$swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swEarlyTerminationProvision/fpml:swBreakFrequency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected /SWDML/swLongFormTrade/swStructuredTradeDetails/fpml:swExtendedTradeDetails/swEarlyTerminationProvision/swBreakFrequency element encountered. Element not allowed for mandatory early termination.</text>
</error>
</xsl:if>
<xsl:variable name="id">
<xsl:value-of select=".//@id"/>
</xsl:variable>
<xsl:if test="$id=''">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or empty mandatoryEarlyTermination/@id attribute value. Value = '<xsl:value-of select="$id"/>'.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:mandatoryEarlyTerminationDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="$swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swEarlyTerminationProvision/fpml:swBreakCalculationMethod = 'ISDA Standard Method'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** $SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/fpml:swEarlyTerminationProvision/swBreakCalculationMethod must not be equal to 'ISDA Standard Method' for mandatory early termination. For mandatory early termination valid values are 'Adjust To Coupon Dates' or 'Straight Calendar Dates'.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:calculationAgent">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:cashSettlement">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:mandatoryEarlyTerminationDate">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="businessDayConvention">
<xsl:value-of select="fpml:dateAdjustments/fpml:businessDayConvention"/>
</xsl:variable>
<xsl:if test="$businessDayConvention='NONE'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** dateAdjustments/businessDayConvention must not be equal to 'NONE'.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:dateAdjustments">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:variable name="businessDayConvention1">
<xsl:value-of select="fpml:dateAdjustments/fpml:businessDayConvention"/>
</xsl:variable>
<xsl:variable name="businessDayConvention2">
<xsl:value-of select="$trade//*/*[position()=$floatingLeg]/fpml:paymentDates/fpml:paymentDatesAdjustments/fpml:businessDayConvention"/>
</xsl:variable>
<xsl:if test="$businessDayConvention1!=$businessDayConvention2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** dateAdjustments/fpml:businessDayConvention must be the same as the swap floating stream paymentDates/fpml:paymentDatesAdjustments/fpml:businessDayConvention. Value = '<xsl:value-of select="$businessDayConvention1"/>' and '<xsl:value-of select="$businessDayConvention2"/>.'</text>
</error>
</xsl:if>
<xsl:choose>
<xsl:when test="$trade/fpml:swap/fpml:swapStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:currency!= 'ILS'">
<xsl:variable name="businessCenters1">
<xsl:for-each select="fpml:dateAdjustments/fpml:businessCenters/fpml:businessCenter">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:variable>
<xsl:variable name="businessCenters2">
<xsl:for-each select="$trade/*//fpml:swapStream[position()=$floatingLeg]/fpml:paymentDates/fpml:paymentDatesAdjustments/fpml:businessCenters/fpml:businessCenter">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:variable>
<xsl:if test="$businessCenters1!=$businessCenters2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** dateAdjustments/businessCenters must be the same as the floating stream paymentDates/paymentDatesAdjustments/businessCenters. Value = '<xsl:value-of select="$businessCenters1"/>' and '<xsl:value-of select="$businessCenters2"/>.'</text>
</error>
</xsl:if>
</xsl:when>
</xsl:choose>
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">unadjustedDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:unadjustedDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:template>
<xsl:template match="fpml:calculationAgent">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="parent::fpml:trade and not($productType='IRS' and $tradeCurrency='BRL')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected trade/calculationAgent element encountered.</text>
</error>
</xsl:if>
<xsl:if test="count(fpml:calculationAgentPartyReference) &gt; 2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of calculationAgentPartyReference child elements encountered. 0 to 2 expected.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:calculationAgentPartyReference">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:calculationAgentParty">
<xsl:call-template name="isValidCalculationAgentParty">
<xsl:with-param name="elementName">calculationAgentParty</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:calculationAgentParty"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:calculationAgentPartyReference">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:variable name="href">
<xsl:value-of select="@href"/>
</xsl:variable>
<xsl:if test="not(//fpml:FpML/fpml:party[@id=$href])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** calculationAgentPartyReference/@href does not reference a valid /FpML/party/@id. Value = '<xsl:value-of select="$href"/>'.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:cashSettlement">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:apply-templates select="fpml:cashSettlementValuationTime">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:cashSettlementValuationDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="../../fpml:mandatoryEarlyTermination">
<xsl:if test="fpml:cashSettlementPaymentDate">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Element cashSettlementPaymentDate must not be present for mandatory early termination.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="../../fpml:optionalEarlyTermination">
<xsl:if test="not(fpml:cashSettlementPaymentDate)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** cashSettlementPaymentDate must be present for optional early termination.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:cashSettlementPaymentDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:cashPriceMethod">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:cashPriceAlternateMethod">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:parYieldCurveAdjustedMethod">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:parYieldCurveUnadjustedMethod">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:zeroCouponYieldAdjustedMethod">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:midMarketValuation">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:replacementValue">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:cashSettlementValuationTime|fpml:earliestExerciseTime|fpml:latestExerciseTime|fpml:expirationTime">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:call-template name="isValidTime">
<xsl:with-param name="elementName">hourMinuteTime</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:hourMinuteTime"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="isValidBusinessCenter">
<xsl:with-param name="elementName">businessCenter</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:businessCenter"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="assetClass">
<xsl:value-of select="$assetClass"/>
</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:variable name="businessCenter">
<xsl:value-of select="fpml:businessCenter"/>
</xsl:variable>
<xsl:if test="$businessCenter='EUTA'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** A time businessCenter must not be equal to 'EUTA'.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:cashSettlementValuationDate|fpml:relativeDate|fpml:relativeDates">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="periodMultiplier">
<xsl:value-of select="fpml:periodMultiplier"/>
</xsl:variable>
<xsl:call-template name="isValidperiodMultiplier">
<xsl:with-param name="elementName">periodMultiplier</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$periodMultiplier"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:variable name="period">
<xsl:value-of select="fpml:period"/>
</xsl:variable>
<xsl:if test="$period!='D'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** period must be equal to 'D' in this context. Value = '<xsl:value-of select="$period"/>'</text>
</error>
</xsl:if>
<xsl:if test="$periodMultiplier='0' and $period='D'">
<xsl:if test="fpml:dayType">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** dayType should not be present if periodMultiplier is '0' and period is 'D'.</text>
</error>
</xsl:if>
<xsl:choose>
<xsl:when test="not(../../../../fpml:swaption) and not(../../../fpml:swaption)">
<xsl:if test="not(//fpml:businessDayConvention='PRECEDING')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** businessDayConvention must equal 'PRECEDING' if periodMultiplier is '0' and period is 'D' if product type is 'SingleCurrencyInterestRateSwap'. Value = '<xsl:value-of select="fpml:businessDayConvention"/>'.</text>
</error>
</xsl:if>
</xsl:when>
<xsl:when test="../../../../fpml:swaption or ../../../fpml:swaption">
<xsl:if test="not(fpml:businessDayConvention='NONE')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** businessDayConvention must equal 'NONE' if periodMultiplier is '0' and period is 'D' if product type is 'Swaption'. Value = '<xsl:value-of select="fpml:businessDayConvention"/>'.</text>
</error>
</xsl:if>
</xsl:when>
<xsl:otherwise>*** Unknown condition occurred</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="not($periodMultiplier='0' and $period='D')">
<xsl:call-template name="isValidDayType">
<xsl:with-param name="elementName">dayType</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:dayType"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:variable name="businessDayConvention">
<xsl:value-of select="fpml:businessDayConvention"/>
</xsl:variable>
<xsl:call-template name="isValidBusinessDayConvention">
<xsl:with-param name="elementName">businessDayConvention</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$businessDayConvention"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="fpml:businessCentersReference">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected element businessCentersReference encountered.</text>
</error>
</xsl:if>
<xsl:if test="$businessDayConvention!='NONE'">
<xsl:if test="not(fpml:businessCenters)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing businessCenters.  Needed when businessDayConvention not equal to 'NONE'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:businessCenters">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="ancestor::fpml:mandatoryEarlyTermination">
<xsl:variable name="href">
<xsl:value-of select="fpml:dateRelativeTo/@href"/>
</xsl:variable>
<xsl:variable name="id">
<xsl:value-of select="ancestor::fpml:mandatoryEarlyTermination//@id"/>
</xsl:variable>
<xsl:if test="$href!=$id">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid dateRelativeTo/@href value. Value is not equal to ancestor::mandatoryEarlyTermination/@id. Value of href = '<xsl:value-of select="$href"/>' and id = '<xsl:value-of select="$id"/>'..</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="ancestor::fpml:swap/fpml:optionalEarlyTermination">
<xsl:variable name="href">
<xsl:value-of select="fpml:dateRelativeTo/@href"/>
</xsl:variable>
<xsl:variable name="id">
<xsl:value-of select="//fpml:FpML/fpml:trade//fpml:swap/fpml:earlyTerminationProvision/fpml:optionalEarlyTermination/fpml:cashSettlement/@id"/>
</xsl:variable>
<xsl:if test="$href!=$id">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid dateRelativeTo/@href value. Value is not equal to FpML/trade/swap/fpml:earlyTerminationProvision/fpml:optionalEarlyTermination/fpml:cashSettlement/@id. Value of href = '<xsl:value-of select="$href"/>' and id = '<xsl:value-of select="$id"/>'..</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="ancestor::fpml:capFloor/fpml:optionalEarlyTermination">
<xsl:variable name="href">
<xsl:value-of select="fpml:dateRelativeTo/@href"/>
</xsl:variable>
<xsl:variable name="id">
<xsl:value-of select="//fpml:FpML/fpml:trade//fpml:capFloor/fpml:earlyTerminationProvision/fpml:optionalEarlyTermination/fpml:cashSettlement/@id"/>
</xsl:variable>
<xsl:if test="$href!=$id">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid dateRelativeTo/@href value. Value is not equal to FpML/trade/capFloor/fpml:earlyTerminationProvision/fpml:optionalEarlyTermination/fpml:cashSettlement/@id. Value of href = '<xsl:value-of select="$href"/>' and id = '<xsl:value-of select="$id"/>'..</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="ancestor::fpml:swaption/fpml:cashSettlement">
<xsl:if test="../../../../fpml:swaption or ../../../fpml:swaption">
<xsl:if test="../../fpml:cashSettlementPaymentDate or ../fpml:cashSettlementValuationDate">
<xsl:variable name="href">
<xsl:value-of select="fpml:dateRelativeTo/@href"/>
</xsl:variable>
<xsl:variable name="id">
<xsl:value-of select="//fpml:FpML/fpml:trade//fpml:swaption/fpml:europeanExercise/@id"/>
</xsl:variable>
<xsl:if test="$href!=$id">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid dateRelativeTo/@href value. Value is not equal to //fpml:FpML/fpml:trade//fpml:swaption/fpml:europeanExercise/@id. Value of href = '<xsl:value-of select="$href"/>' and id = '<xsl:value-of select="$id"/>'..</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:cashPriceMethod|fpml:cashPriceAlternateMethod|fpml:swCrossCurrencyMethod">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="cashSettlementCurrency">
<xsl:value-of select="fpml:cashSettlementCurrency"/>
</xsl:variable>
<xsl:apply-templates select="fpml:cashSettlementReferenceBanks">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="not($productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='Fixed Fixed Swap')">
<xsl:if test="not($trade/fpml:swap/fpml:swapStream/fpml:settlementProvision/fpml:nonDeliverableSettlement)">
<xsl:if test="not($trade/fpml:swaption/fpml:swap/fpml:swapStream/fpml:settlementProvision/fpml:nonDeliverableSettlement)">
<xsl:if test="not($cashSettlementCurrency=$tradeCurrency) and $tradeCurrency != 'BRL'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** cashSettlementCurrency must be the same as trade currency if trade currency is deliverable. Value = '<xsl:value-of select="$cashSettlementCurrency"/>'.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
</xsl:if>
<xsl:if test="$productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS'">
<xsl:call-template name="isValidCurrency">
<xsl:with-param name="elementName">cashSettlementCurrency</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:cashSettlementCurrency"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="(($trade/fpml:swap/fpml:swapStream/fpml:settlementProvision/fpml:nonDeliverableSettlement) and not($productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='Fixed Fixed Swap')) or ($trade/fpml:swaption/fpml:swap/fpml:swapStream/fpml:settlementProvision/fpml:nonDeliverableSettlement)">
<xsl:if test="fpml:cashSettlementCurrency!='USD'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** cashSettlementCurrency must be equal to 'USD' if trade currency is non-deliverable. Value = '<xsl:value-of select="cashSettlementCurrency"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:call-template name="isValidQuotationRateType">
<xsl:with-param name="elementName">quotationRateType</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:quotationRateType"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="ancestor::fpml:mandatoryEarlyTermination">
<xsl:if test="fpml:quotationRateType='ExercisingPartyPays'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** A quotationRateType value of 'ExercisingPartyPays' is not allowed for a mandatory early termination.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:parYieldCurveAdjustedMethod|fpml:parYieldCurveUnadjustedMethod|fpml:zeroCouponYieldAdjustedMethod|fpml:swCollateralizedCashPrice">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:apply-templates select="fpml:settlementRateSource">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:call-template name="isValidQuotationRateType">
<xsl:with-param name="elementName">quotationRateType</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:quotationRateType"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="ancestor::fpml:mandatoryEarlyTermination">
<xsl:if test="fpml:quotationRateType='fpml:ExercisingPartyPays'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** A quotationRateType value of 'ExercisingPartyPays' is not allowed for a mandatory early termination.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:midMarketValuation">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="not(.//fpml:applicableCsa or ./../../../fpml:swaption)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing element. applicableCsa must be present when a Mid-market Valuation cash settlement method is specified.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:replacementValue">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:variable name="hrefProtectedParty">
<xsl:value-of select=".//fpml:protectedParty/fpml:partyReference/@href"/>
</xsl:variable>
<xsl:if test="not(.//fpml:protectedParty)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing element. protectedParty/partyDetermination or protectedParty/partyReference must be present when one of Replacement Value cash settlement methods is specified.</text>
</error>
</xsl:if>
<xsl:if test="$hrefProtectedParty != ''">
<xsl:if test="not(//fpml:FpML/fpml:party[@id=$hrefProtectedParty])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** protectedParty/partyReference/@href does not reference a valid /FpML/party/@id. Value = '<xsl:value-of select="$hrefProtectedParty"/>'.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:settlementRateSource">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:apply-templates select="fpml:informationSource">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:cashSettlementReferenceBanks">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:informationSource">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:call-template name="isValidInformationProvider">
<xsl:with-param name="elementName">rateSource</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:rateSource"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="fpml:rateSourcePage">
<xsl:if test="fpml:rateSourcePage=''">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** rateSourcePage is empty.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:cashSettlementPaymentDate">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:apply-templates select="fpml:relativeDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:adjustableDates">
<xsl:if test="../../fpml:americanExercise">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** adjustableDates must only be present if European or Bermuda exercise.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:businessDateRange">
<xsl:if test="not(../../fpml:americanExercise)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** businessDateRange must only be present if American exercise.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:adjustableDates">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:businessDateRange">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:adjustableDate">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">unadjustedDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:unadjustedDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:apply-templates select="fpml:dateAdjustments">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:adjustableDates">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="../../../fpml:europeanExercise">
<xsl:if test="count(fpml:unadjustedDate)!=1">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of unadjustedDate child elements encountered for European exercise. Exactly 1 expected.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="ancestor::fpml:optionalEarlyTermination">
<xsl:variable name="unadjustedDate">
<xsl:value-of select="fpml:unadjustedDate[position()=last()]"/>
</xsl:variable>
<xsl:variable name="terminationDate">
<xsl:value-of select="//fpml:FpML/fpml:trade/*//fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodDates/fpml:terminationDate/fpml:unadjustedDate"/>
</xsl:variable>
<xsl:variable name="unadjDate">
<xsl:value-of select="number(concat(substring($unadjustedDate,1,4),substring($unadjustedDate,6,2),substring($unadjustedDate,9,2)))"/>
</xsl:variable>
<xsl:variable name="termDate">
<xsl:value-of select="number(concat(substring($terminationDate,1,4),substring($terminationDate,6,2),substring($terminationDate,9,2)))"/>
</xsl:variable>
<xsl:if test="$unadjDate &gt; $termDate">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The last unadjustedDate child element is greater than the swap floating leg terminationDate. Value = '<xsl:value-of select="$unadjustedDate"/>' Value = '<xsl:value-of select="$terminationDate"/>' </text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:unadjustedDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="ancestor::fpml:optionalEarlyTermination">
<xsl:variable name="leg">
<xsl:choose>
<xsl:when test="$productType='Cross Currency IRS'">
<xsl:value-of select="$fixedLeg"/>
</xsl:when>
<xsl:when test="$productType='Fixed Fixed Swap'">
<xsl:value-of select="$fixedLeg2"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$floatingLeg"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="label">
<xsl:choose>
<xsl:when test="$productType='Cross Currency IRS'">fixed</xsl:when>
<xsl:otherwise>floating</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="businessDayConvention1">
<xsl:value-of select="fpml:dateAdjustments/fpml:businessDayConvention"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swEarlyTerminationProvision[fpml:swBreakCalculationMethod='ISDA Standard Method']">
<xsl:if test="$businessDayConvention1!='FOLLOWING'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** dateAdjustments/fpml:businessDayConvention must equal 'FOLLOWING' when /SWDML/swLongFormTrade/swStructuredTradeDetails/fpml:swExtendedTradeDetails/swEarlyTerminationProvision/swBreakCalculationMethod is equal to 'ISDA Standard Method'. Value = '<xsl:value-of select="$businessDayConvention1"/>'</text>
</error>
</xsl:if>
</xsl:when>
<xsl:when test="$swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swTradeHeader[fpml:swInteroperable='true']">
<xsl:if test="$businessDayConvention1!='FOLLOWING'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***dateAdjustments/businessDayConvention must equal 'FOLLOWING' when $swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swTradeHeader/fpml:swInteroperable is equal to 'true'. Value = '<xsl:value-of select="$businessDayConvention1"/>'</text>
</error>
</xsl:if>
</xsl:when>
<xsl:otherwise>
<xsl:variable name="businessDayConvention2">
<xsl:value-of select="//fpml:FpML/fpml:trade//*/*[position()=$leg]/fpml:paymentDates/fpml:paymentDatesAdjustments/fpml:businessDayConvention"/>
</xsl:variable>
<xsl:if test="$businessDayConvention1!=$businessDayConvention2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** dateAdjustments/businessDayConvention must be the same as the <xsl:value-of select="$label"/> stream paymentDates/paymentDatesAdjustments/businessDayConvention. Value = '<xsl:value-of select="$businessDayConvention1"/>' and '<xsl:value-of select="$businessDayConvention2"/>'</text>
</error>
</xsl:if>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:choose>
<xsl:when test="$trade/fpml:swap/fpml:swapStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:currency!= 'ILS'">
<xsl:if test="ancestor::fpml:optionalEarlyTermination">
<xsl:variable name="leg">
<xsl:choose>
<xsl:when test="$productType='Cross Currency IRS'">
<xsl:value-of select="$fixedLeg"/>
</xsl:when>
<xsl:when test="$productType='Fixed Fixed Swap'">
<xsl:value-of select="$fixedLeg"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$floatingLeg"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="label">
<xsl:choose>
<xsl:when test="$productType='Cross Currency IRS'">fixed</xsl:when>
<xsl:otherwise>floating</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="businessCenters1">
<xsl:for-each select="fpml:dateAdjustments/fpml:businessCenters/fpml:businessCenter">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:variable>
<xsl:variable name="businessCenters2">
<xsl:for-each select="$trade/*//fpml:swapStream[position()=$leg]/fpml:paymentDates/fpml:paymentDatesAdjustments/fpml:businessCenters/fpml:businessCenter">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:variable>
<xsl:if test="$businessCenters1!=$businessCenters2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** dateAdjustments/businessCenters must be the same as the <xsl:value-of select="$label"/> stream paymentDates/paymentDatesAdjustments/businessCenters. Value = '<xsl:value-of select="$businessCenters1"/>' and '<xsl:value-of select="$businessCenters2"/>' </text>
</error>
</xsl:if>
</xsl:if>
</xsl:when>
</xsl:choose>
<xsl:apply-templates select="fpml:dateAdjustments">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:unadjustedDate">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">unadjustedDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="."/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:template>
<xsl:template match="fpml:businessDateRange">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">unadjustedFirstDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:unadjustedFirstDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">unadjustedLastDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:unadjustedLastDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="ancestor::fpml:optionalEarlyTermination">
<xsl:variable name="unadjustedLastDate">
<xsl:value-of select="fpml:unadjustedLastDate"/>
</xsl:variable>
<xsl:variable name="terminationDate">
<xsl:value-of select="//fpml:FpML/fpml:trade//*/*[position()=$floatingLeg]/fpml:calculationPeriodDates/fpml:terminationDate/fpml:unadjustedDate"/>
</xsl:variable>
<xsl:if test="$unadjustedLastDate!=$terminationDate">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** unadjustedLastDate does not match the floating stream calculationPeriodDates/terminationDate/unadjustedDate.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:variable name="businessDayConvention">
<xsl:value-of select="fpml:businessDayConvention"/>
</xsl:variable>
<xsl:call-template name="isValidBusinessDayConvention">
<xsl:with-param name="elementName">businessDayConvention</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$businessDayConvention"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="fpml:businessCentersReference">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected element businessCentersReference encountered.</text>
</error>
</xsl:if>
<xsl:if test="$businessDayConvention='NONE' and fpml:businessCenters">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected element businessCenters encountered when businessDayConvention = 'NONE'.</text>
</error>
</xsl:if>
<xsl:if test="$businessDayConvention!='NONE' and not(//fpml:businessCenters)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing businessCenters. Needed when businessDayConvention not equal to 'NONE'.</text>
</error>
</xsl:if>
<xsl:choose>
<xsl:when test="$swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swEarlyTerminationProvision/fpml:swBreakCalculationMethod='ISDA Standard Method'">
<xsl:if test="$businessDayConvention!='FOLLOWING'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** dateAdjustments/businessDayConvention must equal 'FOLLOWING' when $swStructuredTradeDetails/fpml:swExtendedTradeDetails/swEarlyTerminationProvision/swBreakCalculationMethod is equal to 'ISDA Standard Method'. Value = '<xsl:value-of select="$businessDayConvention"/>'</text>
</error>
</xsl:if>
</xsl:when>
<xsl:otherwise>
<xsl:variable name="businessDayConvention2">
<xsl:value-of select="//fpml:FpML/fpml:trade//*/*[position()=$floatingLeg]/fpml:paymentDates/fpml:paymentDatesAdjustments/fpml:businessDayConvention"/>
</xsl:variable>
<xsl:if test="$businessDayConvention!=$businessDayConvention2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** dateAdjustments/fpml:businessDayConvention must be the same as the floating stream paymentDates/paymentDatesAdjustments/businessDayConvention. Value = '<xsl:value-of select="$businessDayConvention"/>' and '<xsl:value-of select="$businessDayConvention2"/>'</text>
</error>
</xsl:if>
<xsl:if test="$productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap'">
<xsl:variable name="businessDayConvention3">
<xsl:value-of select="//fpml:FpML/fpml:trade//*/*[position()=$floatingLeg2]/fpml:paymentDates/fpml:paymentDatesAdjustments/fpml:businessDayConvention"/>
</xsl:variable>
<xsl:if test="$businessDayConvention!=$businessDayConvention3">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** dateAdjustments/fpml:businessDayConvention must be the same as the floatingLeg2 stream paymentDates/paymentDatesAdjustments/businessDayConvention. Value = '<xsl:value-of select="$businessDayConvention"/>' and '<xsl:value-of select="$businessDayConvention3"/>'</text>
</error>
</xsl:if>
</xsl:if>
</xsl:otherwise>
</xsl:choose>
<xsl:variable name="businessCenters1">
<xsl:for-each select="fpml:businessCenters/fpml:businessCenter">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:variable>
<xsl:variable name="businessCenters2">
<xsl:for-each select="$trade//*/*[position()=$floatingLeg]/fpml:paymentDates/fpml:paymentDatesAdjustments/fpml:businessCenters/fpml:businessCenter">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:variable>
<xsl:if test="$businessCenters1!=$businessCenters2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** businessCenters must be the same as floating stream paymentDates/paymentDatesAdjustments/businessCenters. Value = '<xsl:value-of select="$businessCenters1"/>' and '<xsl:value-of select="$businessCenters2"/>'</text>
</error>
</xsl:if>
<xsl:if test="$productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap'">
<xsl:variable name="businessCenters3">
<xsl:for-each select="//fpml:FpML/fpml:trade//*/*[position()=$floatingLeg2]/fpml:paymentDates/fpml:paymentDatesAdjustments/fpml:businessCenters/fpml:businessCenter">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:variable>
<xsl:if test="$businessCenters1!=$businessCenters3">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** businessCenters must be the same as floatingLeg2 stream paymentDates/paymentDatesAdjustments/businessCenters. Value = '<xsl:value-of select="$businessCenters1"/>' and '<xsl:value-of select="$businessCenters3"/>'</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:businessCenters">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:optionalEarlyTermination">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:apply-templates select="fpml:singlePartyOption">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:europeanExercise and $swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swEarlyTerminationProvision/fpml:swBreakFrequency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected /SWDML/swLongFormTrade/swStructuredTradeDetails/fpml:swExtendedTradeDetails/swEarlyTerminationProvision/swBreakFrequency element encountered. Element not allowed for european style optional early termination.</text>
</error>
</xsl:if>
<xsl:if test="fpml:americanExercise">
<xsl:variable name="breakFrequency">
<xsl:value-of select="$swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swEarlyTerminationProvision/fpml:swBreakFrequency/fpml:periodMultiplier"/>
<xsl:value-of select="$swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swEarlyTerminationProvision/fpml:swBreakFrequency/fpml:period"/>
</xsl:variable>
<xsl:if test="not($breakFrequency = '1D')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** /SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swEarlyTerminationProvision/swBreakFrequency element must be equal to 1D for american style optional early termination. Value = '<xsl:value-of select="$breakFrequency"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:bermudaExercise">
<xsl:variable name="breakFrequency">
<xsl:value-of select="$swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swEarlyTerminationProvision/fpml:swBreakFrequency/fpml:periodMultiplier"/>
<xsl:value-of select="$swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swEarlyTerminationProvision/fpml:swBreakFrequency/fpml:period"/>
</xsl:variable>
<xsl:if test="not($swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swEarlyTerminationProvision/fpml:swBreakFrequency)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing /SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swEarlyTerminationProvision/swBreakFrequency element. Required for bermuda style optional early termination.</text>
</error>
</xsl:if>
<xsl:if test="$breakFrequency = '1D'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** $SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swEarlyTerminationProvision/swBreakFrequency element must not be equal to 1D for bermuda style optional early termination.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:europeanExercise">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:bermudaExercise">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:americanExercise">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:calculationAgent">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:cashSettlement">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:singlePartyOption">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="href1">
<xsl:value-of select="fpml:buyerPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="href2">
<xsl:value-of select="fpml:sellerPartyReference/@href"/>
</xsl:variable>
<xsl:if test="$href1=$href2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***buyerPartyReference/@href and sellerPartyReference/@href values must not be the same.</text>
</error>
</xsl:if>
<xsl:if test="not(//fpml:FpML/fpml:party[@id=$href1])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***buyerPartyReference/@href does not reference a valid /FpML/trade/party/@id. Value = '<xsl:value-of select="$href1"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not(//fpml:FpML/fpml:party[@id=$href2])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***sellerPartyReference/@href does not reference a valid //fpml:FpML/trade/party/@id. Value = '<xsl:value-of select="$href2"/>'.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:europeanExercise">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="fpml:earliestExerciseTime/fpml:businessCenter != fpml:expirationTime/fpml:businessCenter">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** earliestExerciseTime/businessCenter must equal expirationTime/businessCenter.</text>
</error>
</xsl:if>
<xsl:if test="../fpml:cashSettlement/fpml:cashSettlementValuationTime/fpml:businessCenter != fpml:expirationTime/fpml:businessCenter">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** ../fpml:cashSettlement/fpml:cashSettlementValuationTime/businessCenter must equal expirationTime/businessCenter.</text>
</error>
</xsl:if>
<xsl:variable name="earliest">
<xsl:value-of select="concat(substring(fpml:earliestExerciseTime/fpml:hourMinuteTime,1,2),substring(fpml:earliestExerciseTime/fpml:hourMinuteTime,4,2),substring(fpml:earliestExerciseTime/fpml:hourMinuteTime,7,2))"/>
</xsl:variable>
<xsl:variable name="expiration">
<xsl:value-of select="concat(substring(fpml:expirationTime/fpml:hourMinuteTime,1,2),substring(fpml:expirationTime/fpml:hourMinuteTime,4,2),substring(fpml:expirationTime/fpml:hourMinuteTime,7,2))"/>
</xsl:variable>
<xsl:if test="not($earliest &lt;= $expiration)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** earliestExerciseTime/hourMinuteTime (<xsl:value-of select="fpml:earliestExerciseTime/hourMinuteTime"/>) must be less than expirationTime/hourMinuteTime (<xsl:value-of select="fpml:expirationTime/hourMinuteTime"/>).</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:expirationDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:earliestExerciseTime">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:expirationTime">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:expirationDate|fpml:commencementDate">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:apply-templates select="fpml:relativeDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:adjustableDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:bermudaExerciseDates">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:apply-templates select="fpml:relativeDates">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:bermudaExercise">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="fpml:earliestExerciseTime/fpml:businessCenter != fpml:expirationTime/fpml:businessCenter">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** earliestExerciseTime/fpml:businessCenter must equal expirationTime/fpml:businessCenter.</text>
</error>
</xsl:if>
<xsl:variable name="earliest">
<xsl:value-of select="concat(substring(fpml:earliestExerciseTime/fpml:hourMinuteTime,1,2),substring(fpml:earliestExerciseTime/fpml:hourMinuteTime,4,2),substring(fpml:earliestExerciseTime/fpml:hourMinuteTime,7,2))"/>
</xsl:variable>
<xsl:variable name="expiration">
<xsl:value-of select="concat(substring(fpml:expirationTime/fpml:hourMinuteTime,1,2),substring(fpml:expirationTime/fpml:hourMinuteTime,4,2),substring(fpml:expirationTime/fpml:hourMinuteTime,7,2))"/>
</xsl:variable>
<xsl:if test="fpml:latestExerciseTime and not(//fpml:latestExerciseTime/fpml:businessCenter = fpml:expirationTime/fpml:businessCenter)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** latestExerciseTime/fpml:businessCenter must equal expirationTime/businessCenter.</text>
</error>
</xsl:if>
<xsl:if test="fpml:latestExerciseTime and not(//fpml:latestExerciseTime/fpml:hourMinuteTime = fpml:expirationTime/fpml:hourMinuteTime)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** latestExerciseTime/hourMinuteTime must equal expirationTime/hourMinuteTime.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:bermudaExerciseDates">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:earliestExerciseTime">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:latestExerciseTime">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:expirationTime">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:americanExercise">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="fpml:earliestExerciseTime/fpml:businessCenter != fpml:expirationTime/fpml:businessCenter">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** earliestExerciseTime/businessCenter must equal expirationTime/businessCenter.</text>
</error>
</xsl:if>
<xsl:variable name="earliest">
<xsl:value-of select="concat(substring(fpml:earliestExerciseTime/fpml:hourMinuteTime,1,2),substring(fpml:earliestExerciseTime/fpml:hourMinuteTime,4,2),substring(fpml:earliestExerciseTime/fpml:hourMinuteTime,7,2))"/>
</xsl:variable>
<xsl:variable name="expiration">
<xsl:value-of select="concat(substring(fpml:expirationTime/fpml:hourMinuteTime,1,2),substring(fpml:expirationTime/fpml:hourMinuteTime,4,2),substring(fpml:expirationTime/fpml:hourMinuteTime,7,2))"/>
</xsl:variable>
<xsl:if test="not($earliest &lt;= $expiration)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** earliestExerciseTime/hourMinuteTime (<xsl:value-of select="fpml:earliestExerciseTime/hourMinuteTime"/>) must be less than expirationTime/hourMinuteTime (<xsl:value-of select="fpml:expirationTime/fpml:hourMinuteTime"/>).</text>
</error>
</xsl:if>
<xsl:if test="fpml:latestExerciseTime and not(//fpml:latestExerciseTime/fpml:businessCenter = fpml:expirationTime/fpml:businessCenter)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** latestExerciseTime/fpml:businessCenter must equal expirationTime/fpml:businessCenter.</text>
</error>
</xsl:if>
<xsl:if test="fpml:latestExerciseTime and not(//fpml:latestExerciseTime/fpml:hourMinuteTime = fpml:expirationTime/fpml:hourMinuteTime)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** latestExerciseTime/hourMinuteTime must equal expirationTime/hourMinuteTime.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:commencementDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:expirationDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:earliestExerciseTime">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:latestExerciseTime">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:expirationTime">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:cashSettlementReferenceBanks">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="count(fpml:referenceBank) &gt; 5">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of referenceBank child elements encountered. 1 to 5 expected.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:referenceBank">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:referenceBank">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:variable name="referenceBankId">
<xsl:value-of select="fpml:referenceBankId"/>
</xsl:variable>
<xsl:if test="$referenceBankId=''">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Empty referenceBankId.</text>
</error>
</xsl:if>
<xsl:if test="fpml:referenceBankName">
<xsl:variable name="referenceBankName">
<xsl:value-of select="fpml:referenceBankName"/>
</xsl:variable>
<xsl:if test="$referenceBankName=''">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Empty referenceBankName.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:fra">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="not($productType='FRA')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** /SWDML/swLongFormTrade/swStructuredTradeDetails/productType must be equal to 'FRA' if fra element is present.</text>
</error>
</xsl:if>
<xsl:variable name="href1">
<xsl:value-of select="fpml:buyerPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="href2">
<xsl:value-of select="fpml:sellerPartyReference/@href"/>
</xsl:variable>
<xsl:if test="$href1=$href2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***buyerPartyReference/@href and sellerPartyReference/@href values must not be the same.</text>
</error>
</xsl:if>
<xsl:if test="not(//fpml:FpML/fpml:party[@id=$href1])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***buyerPartyReference/@href does not reference a valid /FpML/trade/party/@id. Value = '<xsl:value-of select="$href1"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not(//fpml:FpML/fpml:party[@id=$href2])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***sellerPartyReference/@href does not reference a valid /FpML/trade/party/@id. Value = '<xsl:value-of select="$href2"/>'.</text>
</error>
</xsl:if>
<xsl:variable name="id">
<xsl:value-of select="fpml:adjustedEffectiveDate/@id"/>
</xsl:variable>
<xsl:if test="$id = ''">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or empty adjustedEffectiveDate/@id value.</text>
</error>
</xsl:if>
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">adjustedEffectiveDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:adjustedEffectiveDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">adjustedTerminationDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:adjustedTerminationDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:apply-templates select="fpml:paymentDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:fixingDateOffset">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:call-template name="isValidDayCountFraction">
<xsl:with-param name="elementName">dayCountFraction</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:dayCountFraction"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:variable name="calculationPeriodNumberOfDays">
<xsl:value-of select="fpml:calculationPeriodNumberOfDays"/>
</xsl:variable>
<xsl:call-template name="isValidIntegerNumber">
<xsl:with-param name="elementName">calculationPeriodNumberOfDays</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$calculationPeriodNumberOfDays"/>
</xsl:with-param>
<xsl:with-param name="minIncl">1</xsl:with-param>
<xsl:with-param name="maxIncl">99999</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:apply-templates select="fpml:notional">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:variable name="floatingRateIndex">
<xsl:value-of select="fpml:floatingRateIndex"/>
</xsl:variable>
<xsl:if test="$floatingRateIndex=''">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Empty or missing floatingRateIndex.</text>
</error>
</xsl:if>
<xsl:if test="$tradeCurrency != 'PLN'">
<xsl:variable name="floatingRateIndexCurrency">
<xsl:value-of select="substring($floatingRateIndex,1,3)"/>
</xsl:variable>
<xsl:if test="$tradeCurrency != $floatingRateIndexCurrency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** floatingRateIndex value of '<xsl:value-of select="$floatingRateIndex"/>' is not valid for trade currency of '<xsl:value-of select="$tradeCurrency"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:variable name="fixedRate">
<xsl:value-of select="fpml:fixedRate"/>
</xsl:variable>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">fixedRate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$fixedRate"/>
</xsl:with-param>
<xsl:with-param name="minIncl">-9.9999999999</xsl:with-param>
<xsl:with-param name="maxIncl">9.9999999999</xsl:with-param>
<xsl:with-param name="maxDecs">10</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="not(count(fpml:indexTenor)=1 or count(fpml:indexTenor)=2)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of indexTenor child elements encountered. Exactly 1 or 2 expected.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:indexTenor">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:call-template name="isValidFRADiscounting">
<xsl:with-param name="elementName">fraDiscounting</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:fraDiscounting"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:template>
<xsl:template match="fpml:paymentDate">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">unadjustedDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:unadjustedDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:apply-templates select="fpml:dateAdjustments">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:variable name="businessDayConvention">
<xsl:value-of select="fpml:dateAdjustments/fpml:businessDayConvention"/>
</xsl:variable>
<xsl:if test="$businessDayConvention='NONE' and ($isNettingInstruction='false' or not(ancestor::fpml:additionalPayment)) and ($isClearingTakeup='false' or $isTransitionEvent='false' or not(ancestor::fpml:additionalPayment))">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** dateAdjustments/fpml:businessDayConvention must not equal 'NONE' in this context.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:dateAdjustments">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="businessDayConvention">
<xsl:value-of select="fpml:businessDayConvention"/>
</xsl:variable>
<xsl:call-template name="isValidBusinessDayConvention">
<xsl:with-param name="elementName">businessDayConvention</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$businessDayConvention"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="fpml:businessCentersReference">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected element businessCentersReference encountered.</text>
</error>
</xsl:if>
<xsl:if test="$businessDayConvention='NONE'">
<xsl:if test="fpml:businessCenters">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected element businessCenters encountered when businessDayConvention = 'NONE'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$businessDayConvention!='NONE'">
<xsl:if test="not(//fpml:businessCenters)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing businessCenters. Needed when businessDayConvention not equal to 'NONE'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:businessCenters">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:businessCenters">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:apply-templates select="fpml:businessCenter">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:businessCenter">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:call-template name="isValidBusinessCenter">
<xsl:with-param name="elementName">businessCenter</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="."/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="assetClass">
<xsl:value-of select="$assetClass"/>
</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:template>
<xsl:template match="fpml:fixingDateOffset">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="periodMultiplier">
<xsl:value-of select="fpml:periodMultiplier"/>
</xsl:variable>
<xsl:call-template name="isValidIntegerNumber">
<xsl:with-param name="elementName">periodMultiplier</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$periodMultiplier"/>
</xsl:with-param>
<xsl:with-param name="minIncl">-99</xsl:with-param>
<xsl:with-param name="maxIncl">0</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:variable name="period">
<xsl:value-of select="fpml:period"/>
</xsl:variable>
<xsl:if test="$period!='D'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** period must be equal to 'D' in this context. Value = '<xsl:value-of select="$period"/>'</text>
</error>
</xsl:if>
<xsl:if test="$periodMultiplier='0' and $period='D'">
<xsl:if test="fpml:dayType">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** dayType should not be present if periodMultiplier is '0' and period is 'D'.</text>
</error>
</xsl:if>
<xsl:if test="not(//fpml:businessDayConvention='PRECEDING')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** businessDayConvention must equal 'PRECEDING' if periodMultiplier is '0' and period is 'D'. Value = '<xsl:value-of select="fpml:businessDayConvention"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:variable name="dayType">
<xsl:value-of select="fpml:dayType"/>
</xsl:variable>
<xsl:if test="$periodMultiplier!='0' and $period='D' and $dayType='Business'">
<xsl:if test="not(//fpml:businessDayConvention='NONE')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** businessDayConvention must equal 'NONE' if period is equal to 'D' and periodMultiplier is not equal to '0' and dayType is equal to 'Business'. Value = '<xsl:value-of select="fpml:businessDayConvention"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="not($periodMultiplier='0' and $period='D')">
<xsl:call-template name="isValidDayType">
<xsl:with-param name="elementName">dayType</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:dayType"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:variable name="businessDayConvention">
<xsl:value-of select="fpml:businessDayConvention"/>
</xsl:variable>
<xsl:call-template name="isValidBusinessDayConvention">
<xsl:with-param name="elementName">businessDayConvention</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$businessDayConvention"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="fpml:businessCentersReference">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected element businessCentersReference encountered.</text>
</error>
</xsl:if>
<xsl:if test="$businessDayConvention!='NONE'">
<xsl:if test="not(//fpml:businessCenters)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing businessCenters. Needed when businessDayConvention not equal to 'NONE'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$dayType='Business'">
<xsl:if test="not(//fpml:businessCenters)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing businessCenters. Needed when dayType is equal to 'Business'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:businessCenters">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:variable name="href">
<xsl:value-of select="fpml:dateRelativeTo/@href"/>
</xsl:variable>
<xsl:variable name="id">
<xsl:value-of select="../fpml:adjustedEffectiveDate/@id"/>
</xsl:variable>
<xsl:if test="$href!=$id">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid dateRelativeTo/@href value. Value is not equal to ../adjustedEffectiveDate/@id. Value of href = '<xsl:value-of select="$href"/>' and id = '<xsl:value-of select="$id"/>'.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:notional">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:call-template name="isValidCurrency">
<xsl:with-param name="elementName">currency</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:currency"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:variable name="amount">
<xsl:value-of select="fpml:amount"/>
</xsl:variable>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">amount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$amount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.01</xsl:with-param>
<xsl:with-param name="maxIncl">3999999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:template>
<xsl:template match="fpml:swNotional2">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:call-template name="isValidCurrency">
<xsl:with-param name="elementName">currency</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:currency"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:variable name="amount">
<xsl:value-of select="fpml:amount"/>
</xsl:variable>
<xsl:if test="not($productType='Fixed Fixed Swap' and $MarkToMarket='true')">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">amount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$amount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.01</xsl:with-param>
<xsl:with-param name="maxIncl">3999999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:swSwapTermTenor">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="period">
<xsl:value-of select="fpml:period"/>
</xsl:variable>
<xsl:if test="not($period='W' or $period='M' or $period='Y')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** period must be equal to 'W', 'M' or 'Y'. Value = '<xsl:value-of select="$period"/>'</text>
</error>
</xsl:if>
<xsl:if test="$period='W'">
<xsl:if test="not($productType='OIS')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** period can only be in expressed in weeks (W) if product type is 'OIS'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:call-template name="isValidperiodMultiplier">
<xsl:with-param name="elementName">periodMultiplier</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:periodMultiplier"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:variable name="periodMultiplier">
<xsl:value-of select="fpml:periodMultiplier"/>
</xsl:variable>
<xsl:if test="$period='W' and ($periodMultiplier &lt; 1 or $periodMultiplier &gt; 3)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** periodMultiplier must be in the range 1 to 3 in this context if period is equal to 'W'. Value = '<xsl:value-of select="$periodMultiplier"/>'</text>
</error>
</xsl:if>
<xsl:if test="$period='M' and ($periodMultiplier &lt; 1 or $periodMultiplier &gt; 11999)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** periodMultiplier must be in the range 1 to 11999 in this context if period is equal to 'M'. Value = '<xsl:value-of select="$periodMultiplier"/>'</text>
</error>
</xsl:if>
<xsl:if test="$period='Y' and ($periodMultiplier &lt; 1 or $periodMultiplier &gt; 999)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** periodMultiplier must be in the range 1 to 999 in this context if period is equal to 'Y'. Value = '<xsl:value-of select="$periodMultiplier"/>'</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:swEffectiveDateTenor">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="period">
<xsl:value-of select="fpml:period"/>
</xsl:variable>
<xsl:if test="not($period='M')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** period must be equal to 'M' in this context. Value = '<xsl:value-of select="$period"/>'</text>
</error>
</xsl:if>
<xsl:call-template name="isValidperiodMultiplier">
<xsl:with-param name="elementName">periodMultiplier</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:periodMultiplier"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:variable name="periodMultiplier">
<xsl:value-of select="fpml:periodMultiplier"/>
</xsl:variable>
<xsl:if test="$periodMultiplier &lt; 0 or $periodMultiplier &gt; 99">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** periodMultiplier must be in the range 0 to 99 in this context. Value = '<xsl:value-of select="$periodMultiplier"/>'</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:swTerminationDateTenor">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="period">
<xsl:value-of select="fpml:period"/>
</xsl:variable>
<xsl:if test="not($period='M')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** period must be equal to 'M' in this context. Value = '<xsl:value-of select="$period"/>'</text>
</error>
</xsl:if>
<xsl:call-template name="isValidperiodMultiplier">
<xsl:with-param name="elementName">periodMultiplier</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:periodMultiplier"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:variable name="periodMultiplier">
<xsl:value-of select="fpml:periodMultiplier"/>
</xsl:variable>
<xsl:if test="$periodMultiplier &lt; 0 or $periodMultiplier &gt; 99">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** periodMultiplier must be in the range 0 to 99 in this context. Value = '<xsl:value-of select="$periodMultiplier"/>'</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:party">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:variable name="partyId">
<xsl:value-of select="fpml:partyId"/>
</xsl:variable>
<xsl:if test="$partyId=''">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or empty partyId.</text>
</error>
</xsl:if>
<xsl:variable name="id">
<xsl:value-of select="@id"/>
</xsl:variable>
<xsl:if test="$id=''">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or empty @id.</text>
</error>
</xsl:if>
<xsl:variable name="partyName">
<xsl:value-of select="fpml:partyName"/>
</xsl:variable>
<xsl:if test="partyName">
<xsl:if test="$partyName=''">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Empty partyName.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:swEarlyTerminationProvision">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:apply-templates select="fpml:swBreakFirstDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:swBreakOverrideFirstDate">
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">swBreakOverrideFirstDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swBreakOverrideFirstDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="$trade//fpml:swap/fpml:earlyTerminationProvision/fpml:mandatoryEarlyTermination/fpml:mandatoryEarlyTerminationDate/fpml:unadjustedDate">
<xsl:variable name="overrideFirstDate">
<xsl:value-of select="fpml:swBreakOverrideFirstDate"/>
</xsl:variable>
<xsl:variable name="firstDate">
<xsl:value-of select="$trade//fpml:swap/fpml:earlyTerminationProvision/fpml:mandatoryEarlyTermination/fpml:mandatoryEarlyTerminationDate/fpml:unadjustedDate"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$overrideFirstDate=$firstDate"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** For a mandatory early termination swBreakOverrideFirstDate whose value = '<xsl:value-of select="$overrideFirstDate"/>', must be equal to fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails//fpml:FpML/fpml:trade//fpml:swap/fpml:earlyTerminationProvision/fpml:mandatoryEarlyTermination/fpml:mandatoryEarlyTerminationDate/fpml:unadjustedDate. Value = '<xsl:value-of select="$firstDate"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="$trade//fpml:swap/fpml:earlyTerminationProvision/fpml:optionalEarlyTermination/fpml:cashSettlement/fpml:cashSettlementPaymentDate/fpml:adjustableDates/fpml:unadjustedDate[1]">
<xsl:variable name="overrideFirstDate">
<xsl:value-of select="fpml:swBreakOverrideFirstDate"/>
</xsl:variable>
<xsl:variable name="firstDate">
<xsl:value-of select="$trade//fpml:swap/fpml:earlyTerminationProvision/fpml:optionalEarlyTermination/fpml:cashSettlement/fpml:cashSettlementPaymentDate/fpml:adjustableDates/fpml:unadjustedDate[1]"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$overrideFirstDate=$firstDate"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** For a Bermudan or European style optional early termination swBreakOverrideFirstDate whose value = '<xsl:value-of select="$overrideFirstDate"/>',  must be equal to $trade//fpml:swap/fpml:earlyTerminationProvision/fpml:optionalEarlyTermination/fpml:cashSettlement/fpml:cashSettlementPaymentDate/fpml:adjustableDates/fpml:unadjustedDate[1]. Value = '<xsl:value-of select="$firstDate"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="$trade//fpml:swap/fpml:earlyTerminationProvision/fpml:optionalEarlyTermination/fpml:cashSettlement/fpml:cashSettlementPaymentDate/fpml:businessDateRange/fpml:unadjustedFirstDate">
<xsl:variable name="overrideFirstDate">
<xsl:value-of select="fpml:swBreakOverrideFirstDate"/>
</xsl:variable>
<xsl:variable name="firstDate">
<xsl:value-of select="$trade//fpml:swap/fpml:earlyTerminationProvision/fpml:optionalEarlyTermination/fpml:cashSettlement/fpml:cashSettlementPaymentDate/fpml:businessDateRange/fpml:unadjustedFirstDate"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$overrideFirstDate=$firstDate"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** For an American style optional early termination swBreakOverrideFirstDate whose value = '<xsl:value-of select="$overrideFirstDate"/>',  must be equal to $trade//fpml:swap/fpml:earlyTerminationProvision/fpml:optionalEarlyTermination/fpml:cashSettlement/fpml:cashSettlementPaymentDate/fpml:businessDateRange/fpml:unadjustedFirstDate. Value = '<xsl:value-of select="$firstDate"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:swBreakFrequency">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:call-template name="isValidBreakCalculationMethod">
<xsl:with-param name="elementName">swBreakCalculationMethod</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swBreakCalculationMethod"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:choose>
<xsl:when test="not($trade//fpml:swap/fpml:earlyTerminationProvision//fpml:cashSettlement/fpml:midMarketValuation/fpml:calculationAgentDetermination/fpml:cashSettlementReferenceBanks)"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** The supplied combination of Cash Method and Settlement Rate Source under earlyTerminationProvision(Break) is invalid.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template match="fpml:swBreakFirstDate">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="freq">
<xsl:value-of select="fpml:periodMultiplier"/>
<xsl:value-of select="fpml:period"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$freq='1D'"/>
<xsl:when test="$freq='6M'"/>
<xsl:when test="$freq='1Y'"/>
<xsl:when test="$freq='2Y'"/>
<xsl:when test="$freq='3Y'"/>
<xsl:when test="$freq='4Y'"/>
<xsl:when test="$freq='5Y'"/>
<xsl:when test="$freq='6Y'"/>
<xsl:when test="$freq='7Y'"/>
<xsl:when test="$freq='8Y'"/>
<xsl:when test="$freq='9Y'"/>
<xsl:when test="$freq='10Y'"/>
<xsl:when test="$freq='11Y'"/>
<xsl:when test="$freq='12Y'"/>
<xsl:when test="$freq='15Y'"/>
<xsl:when test="$freq='20Y'"/>
<xsl:when test="$freq='25Y'"/>
<xsl:when test="$freq='30Y'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** swBreakFirstDate must be equal to 1D, 6M, 1Y, 2Y, 3Y, 4Y, 5Y, 6Y, 7Y, 8Y, 9Y, 10Y, 11Y, 12Y, 15Y, 20Y, 25Y and 30Y. Value = '<xsl:value-of select="$freq"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template match="fpml:swBreakFrequency">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="freq">
<xsl:value-of select="fpml:periodMultiplier"/>
<xsl:value-of select="fpml:period"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$freq='1D'"/>
<xsl:when test="$freq='1M'"/>
<xsl:when test="$freq='3M'"/>
<xsl:when test="$freq='6M'"/>
<xsl:when test="$freq='1Y'"/>
<xsl:when test="$freq='2Y'"/>
<xsl:when test="$freq='3Y'"/>
<xsl:when test="$freq='4Y'"/>
<xsl:when test="$freq='5Y'"/>
<xsl:when test="$freq='6Y'"/>
<xsl:when test="$freq='7Y'"/>
<xsl:when test="$freq='8Y'"/>
<xsl:when test="$freq='9Y'"/>
<xsl:when test="$freq='10Y'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swBreakFrequency must be equal to 1D, 1M, 3M, 6M, 1Y, 2Y, 3Y, 4Y, 5Y, 6Y, 7Y, 8Y, 9Y or 10Y. Value = '<xsl:value-of select="$freq"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template match="fpml:swOutsideNovation">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="not(fpml:swTransferor/fpml:partyId)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swOutsideNovation/swTransferor/partyId must be present for an Outside Novation./&gt;'.</text>
</error>
</xsl:if>
<xsl:variable name="transferee">
<xsl:value-of select="fpml:transferee/@href"/>
</xsl:variable>
<xsl:if test="not(//fpml:FpML/fpml:party[@id=$transferee])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swOustideNovation/transferee/@href does not reference a valid /FpML/trade/party/@id. Value = '<xsl:value-of select="$transferee"/>'.</text>
</error>
</xsl:if>
<xsl:variable name="remainingParty">
<xsl:value-of select="fpml:remainingParty/@href"/>
</xsl:variable>
<xsl:if test="not(//fpml:FpML/fpml:party[@id=$remainingParty])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swOutsideNovation/remainingParty/@href does not reference a valid /FpML/trade/party/@id. Value = '<xsl:value-of select="$remainingParty"/>'.</text>
</error>
</xsl:if>
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">novationDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:novationDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">novationTradeDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:novationTradeDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="fpml:fullFirstCalculationPeriod">
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">fullFirstCalculationPeriod</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:fullFirstCalculationPeriod"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:swFxCutoffTime">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:call-template name="isValidTime">
<xsl:with-param name="elementName">hourMinuteTime</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:hourMinuteTime"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:template>
<xsl:template match="fpml:swAssociatedBonds">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="fpml:swNegotiatedSpreadRate">
<xsl:variable name="swNegotiatedSpreadRate">
<xsl:value-of select="fpml:swNegotiatedSpreadRate"/>
</xsl:variable>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swNegotiatedSpreadRate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$swNegotiatedSpreadRate"/>
</xsl:with-param>
<xsl:with-param name="minIncl">-0.0999999</xsl:with-param>
<xsl:with-param name="maxIncl">0.0999999</xsl:with-param>
<xsl:with-param name="maxDecs">7</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="count(fpml:swBondDetails) &gt; 2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of swBondDetails child elements encountered. 0 to 2 expected.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:swBondDetails">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:swBondDetails">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:variable name="swBondName">
<xsl:value-of select="fpml:swBondName"/>
</xsl:variable>
<xsl:if test="$swBondName =''">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Empty swBondName.</text>
</error>
</xsl:if>
<xsl:if test="string-length($swBondName) &gt; 40">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid swBondName string length. Exceeded max length of 40 characters.</text>
</error>
</xsl:if>
<xsl:variable name="swBondFaceAmount">
<xsl:value-of select="fpml:swBondFaceAmount"/>
</xsl:variable>
<xsl:call-template name="isValidIntegerNumber">
<xsl:with-param name="elementName">swBondFaceAmount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$swBondFaceAmount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">1</xsl:with-param>
<xsl:with-param name="maxIncl">999999999999</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="isValidPriceType">
<xsl:with-param name="elementName">swPriceType</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swPriceType"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:variable name="swPriceType">
<xsl:value-of select="fpml:swPriceType"/>
</xsl:variable>
<xsl:if test="$tradeCurrency ='USD'">
<xsl:if test="$swPriceType !='F128' and $swPriceType !='F256' and $swPriceType !='D5'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swPriceType must be equal to 'F128' or 'F256' or D5 if trade currency is equal to 'USD'. Value = '<xsl:value-of select="$swPriceType"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$tradeCurrency ='CAD'">
<xsl:if test="$swPriceType !='D5'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swPriceType must be equal to 'D5' if trade currency is equal to 'CAD'. Value = '<xsl:value-of select="$swPriceType"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:variable name="swBondPrice">
<xsl:value-of select="fpml:swBondPrice"/>
</xsl:variable>
<xsl:if test="$swPriceType='F128' or $swPriceType='F256'">
<xsl:choose>
<xsl:when test="not($swBondPrice='')">
<xsl:choose>
<xsl:when test="contains($swBondPrice,'-')">
<xsl:call-template name="isValidIntegerNumber2">
<xsl:with-param name="elementName">swBondPrice</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="substring-before($swBondPrice,'-')"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">999</xsl:with-param>
<xsl:with-param name="maxDigits">3</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="isValid32nd">
<xsl:with-param name="elementName">swBondPrice</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="substring(substring-after($swBondPrice,'-'),1,2)"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="$swPriceType = 'F128'">
<xsl:call-template name="isValid128th">
<xsl:with-param name="elementName">swBondPrice</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="substring(substring-after($swBondPrice,'-'),3)"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="$swPriceType = 'F256'">
<xsl:call-template name="isValid256th">
<xsl:with-param name="elementName">swBondPrice</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="substring(substring-after($swBondPrice,'-'),3)"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
</xsl:when>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** If swPriceType is equal to 'F128' or 'F256' swBondPrice must contain '-' fractional separator. Value = '<xsl:value-of select="$swBondPrice"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Empty swBondPrice.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="$swPriceType='D5'">
<xsl:call-template name="isValidNumber2">
<xsl:with-param name="elementName">swBondPrice</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$swBondPrice"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">999.99999</xsl:with-param>
<xsl:with-param name="maxDecs">5</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
</xsl:template>
<xsl:template name="isValidBoolean">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/>. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='true'"/>
<xsl:when test="$elementValue='false'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template name="isValidBusinessDayConvention">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/>. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='MODFOLLOWING'"/>
<xsl:when test="$elementValue='FOLLOWING'"/>
<xsl:when test="$elementValue='PRECEDING'"/>
<xsl:when test="$elementValue='NONE'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template name="isValidCalculationAgentParty">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/>. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='NonExercisingParty'">
<xsl:if test="ancestor::fpml:trade/fpml:calculationAgent and ($productType='IRS' and $tradeCurrency='BRL')">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:if>
<xsl:if test="ancestor::fpml:swaption/fpml:calculationAgent and not(ancestor::fpml:swap/fpml:earlyTerminationProvision)">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:if>
</xsl:when>
<xsl:when test="$elementValue='AsSpecifiedInMasterAgreement'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template name="isValidCompoundingMethod">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/>. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='Flat'"/>
<xsl:when test="$elementValue='Straight'"/>
<xsl:when test="$elementValue='SpreadExclusive'"/>
<xsl:when test="$elementValue='None'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template name="isValidCurrency">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> for product type of '<xsl:value-of select="$productType"/>'. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$productType='IRS'">
<xsl:choose>
<xsl:when test="$elementValue='AUD'"/>
<xsl:when test="$elementValue='BRL'"/>
<xsl:when test="$elementValue='CAD'"/>
<xsl:when test="$elementValue='CHF'"/>
<xsl:when test="$elementValue='CLP'"/>
<xsl:when test="$elementValue='CNY'"/>
<xsl:when test="$elementValue='CZK'"/>
<xsl:when test="$elementValue='DKK'"/>
<xsl:when test="$elementValue='EUR'"/>
<xsl:when test="$elementValue='GBP'"/>
<xsl:when test="$elementValue='HKD'"/>
<xsl:when test="$elementValue='HUF'"/>
<xsl:when test="$elementValue='IDR'"/>
<xsl:when test="$elementValue='ILS'"/>
<xsl:when test="$elementValue='INR'"/>
<xsl:when test="$elementValue='ISK'"/>
<xsl:when test="$elementValue='KRW'"/>
<xsl:when test="$elementValue='JPY'"/>
<xsl:when test="$elementValue='MXN'"/>
<xsl:when test="$elementValue='MYR'"/>
<xsl:when test="$elementValue='NOK'"/>
<xsl:when test="$elementValue='NZD'"/>
<xsl:when test="$elementValue='PHP'"/>
<xsl:when test="$elementValue='PLN'"/>
<xsl:when test="$elementValue='RUB'"/>
<xsl:when test="$elementValue='SEK'"/>
<xsl:when test="$elementValue='SGD'"/>
<xsl:when test="$elementValue='SKK'"/>
<xsl:when test="$elementValue='THB'"/>
<xsl:when test="$elementValue='TRY'"/>
<xsl:when test="$elementValue='TWD'"/>
<xsl:when test="$elementValue='USD'"/>
<xsl:when test="$elementValue='ZAR'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType='Swaption'">
<xsl:choose>
<xsl:when test="$elementValue='AUD'"/>
<xsl:when test="$elementValue='CAD'"/>
<xsl:when test="$elementValue='CHF'"/>
<xsl:when test="$elementValue='CNY'"/>
<xsl:when test="$elementValue='COP'"/>
<xsl:when test="$elementValue='CZK'"/>
<xsl:when test="$elementValue='DKK'"/>
<xsl:when test="$elementValue='EUR'"/>
<xsl:when test="$elementValue='GBP'"/>
<xsl:when test="$elementValue='HKD'"/>
<xsl:when test="$elementValue='HUF'"/>
<xsl:when test="$elementValue='ILS'"/>
<xsl:when test="$elementValue='INR'"/>
<xsl:when test="$elementValue='ISK'"/>
<xsl:when test="$elementValue='JPY'"/>
<xsl:when test="$elementValue='KRW'"/>
<xsl:when test="$elementValue='MXN'"/>
<xsl:when test="$elementValue='MYR'"/>
<xsl:when test="$elementValue='NOK'"/>
<xsl:when test="$elementValue='NZD'"/>
<xsl:when test="$elementValue='PLN'"/>
<xsl:when test="$elementValue='RUB'"/>
<xsl:when test="$elementValue='SEK'"/>
<xsl:when test="$elementValue='SGD'"/>
<xsl:when test="$elementValue='SKK'"/>
<xsl:when test="$elementValue='THB'"/>
<xsl:when test="$elementValue='TRY'"/>
<xsl:when test="$elementValue='TWD'"/>
<xsl:when test="$elementValue='USD'"/>
<xsl:when test="$elementValue='ZAR'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType='FRA'">
<xsl:choose>
<xsl:when test="$elementValue='AUD'"/>
<xsl:when test="$elementValue='CAD'"/>
<xsl:when test="$elementValue='CHF'"/>
<xsl:when test="$elementValue='CZK'"/>
<xsl:when test="$elementValue='DKK'"/>
<xsl:when test="$elementValue='EUR'"/>
<xsl:when test="$elementValue='GBP'"/>
<xsl:when test="$elementValue='HKD'"/>
<xsl:when test="$elementValue='HUF'"/>
<xsl:when test="$elementValue='ILS'"/>
<xsl:when test="$elementValue='JPY'"/>
<xsl:when test="$elementValue='NOK'"/>
<xsl:when test="$elementValue='NZD'"/>
<xsl:when test="$elementValue='PLN'"/>
<xsl:when test="$elementValue='RUB'"/>
<xsl:when test="$elementValue='SEK'"/>
<xsl:when test="$elementValue='SGD'"/>
<xsl:when test="$elementValue='SKK'"/>
<xsl:when test="$elementValue='USD'"/>
<xsl:when test="$elementValue='ZAR'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType='OIS'">
<xsl:choose>
<xsl:when test="$elementValue='AUD'"/>
<xsl:when test="$elementValue='CAD'"/>
<xsl:when test="$elementValue='CHF'"/>
<xsl:when test="$elementValue='COP'"/>
<xsl:when test="$elementValue='DKK'"/>
<xsl:when test="$elementValue='EUR'"/>
<xsl:when test="$elementValue='GBP'"/>
<xsl:when test="$elementValue='HKD'"/>
<xsl:when test="$elementValue='ILS'"/>
<xsl:when test="$elementValue='INR'"/>
<xsl:when test="$elementValue='JPY'"/>
<xsl:when test="$elementValue='MYR'"/>
<xsl:when test="$elementValue='NOK'"/>
<xsl:when test="$elementValue='NZD'"/>
<xsl:when test="$elementValue='PLN'"/>
<xsl:when test="$elementValue='RUB'"/>
<xsl:when test="$elementValue='SEK'"/>
<xsl:when test="$elementValue='SGD'"/>
<xsl:when test="$elementValue='TRY'"/>
<xsl:when test="$elementValue='THB'"/>
<xsl:when test="$elementValue='USD'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType='ZCInflationSwap'">
<xsl:choose>
<xsl:when test="$elementValue='AUD'"/>
<xsl:when test="$elementValue='CAD'"/>
<xsl:when test="$elementValue='DKK'"/>
<xsl:when test="$elementValue='EUR'"/>
<xsl:when test="$elementValue='GBP'"/>
<xsl:when test="$elementValue='JPY'"/>
<xsl:when test="$elementValue='SEK'"/>
<xsl:when test="$elementValue='USD'"/>
<xsl:when test="$elementValue='ZAR'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType='Single Currency Basis Swap'">
<xsl:choose>
<xsl:when test="$elementValue='AUD'"/>
<xsl:when test="$elementValue='CAD'"/>
<xsl:when test="$elementValue='CHF'"/>
<xsl:when test="$elementValue='CZK'"/>
<xsl:when test="$elementValue='DKK'"/>
<xsl:when test="$elementValue='EUR'"/>
<xsl:when test="$elementValue='GBP'"/>
<xsl:when test="$elementValue='HKD'"/>
<xsl:when test="$elementValue='HUF'"/>
<xsl:when test="$elementValue='IDR'"/>
<xsl:when test="$elementValue='ILS'"/>
<xsl:when test="$elementValue='KRW'"/>
<xsl:when test="$elementValue='JPY'"/>
<xsl:when test="$elementValue='NOK'"/>
<xsl:when test="$elementValue='NZD'"/>
<xsl:when test="$elementValue='PLN'"/>
<xsl:when test="$elementValue='SEK'"/>
<xsl:when test="$elementValue='SGD'"/>
<xsl:when test="$elementValue='SKK'"/>
<xsl:when test="$elementValue='THB'"/>
<xsl:when test="$elementValue='TRY'"/>
<xsl:when test="$elementValue='TWD'"/>
<xsl:when test="$elementValue='USD'"/>
<xsl:when test="$elementValue='ZAR'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType='CapFloor'">
<xsl:choose>
<xsl:when test="$elementValue='AUD'"/>
<xsl:when test="$elementValue='CAD'"/>
<xsl:when test="$elementValue='CZK'"/>
<xsl:when test="$elementValue='CHF'"/>
<xsl:when test="$elementValue='DKK'"/>
<xsl:when test="$elementValue='EUR'"/>
<xsl:when test="$elementValue='GBP'"/>
<xsl:when test="$elementValue='HKD'"/>
<xsl:when test="$elementValue='HUF'"/>
<xsl:when test="$elementValue='ILS'"/>
<xsl:when test="$elementValue='JPY'"/>
<xsl:when test="$elementValue='MXN'"/>
<xsl:when test="$elementValue='NOK'"/>
<xsl:when test="$elementValue='NZD'"/>
<xsl:when test="$elementValue='PLN'"/>
<xsl:when test="$elementValue='SEK'"/>
<xsl:when test="$elementValue='USD'"/>
<xsl:when test="$elementValue='ZAR'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType='Cross Currency Basis Swap'">
<xsl:choose>
<xsl:when test="$elementValue='AUD'"/>
<xsl:when test="$elementValue='CAD'"/>
<xsl:when test="$elementValue='CHF'"/>
<xsl:when test="$elementValue='CLP'"/>
<xsl:when test="$elementValue='CNY'"/>
<xsl:when test="$elementValue='COP'"/>
<xsl:when test="$elementValue='CZK'"/>
<xsl:when test="$elementValue='DKK'"/>
<xsl:when test="$elementValue='EUR'"/>
<xsl:when test="$elementValue='GBP'"/>
<xsl:when test="$elementValue='HKD'"/>
<xsl:when test="$elementValue='HUF'"/>
<xsl:when test="$elementValue='IDR'"/>
<xsl:when test="$elementValue='INR'"/>
<xsl:when test="$elementValue='ILS'"/>
<xsl:when test="$elementValue='JPY'"/>
<xsl:when test="$elementValue='KRW'"/>
<xsl:when test="$elementValue='MXN'"/>
<xsl:when test="$elementValue='MYR'"/>
<xsl:when test="$elementValue='NOK'"/>
<xsl:when test="$elementValue='NZD'"/>
<xsl:when test="$elementValue='PLN'"/>
<xsl:when test="$elementValue='PHP'"/>
<xsl:when test="$elementValue='RUB'"/>
<xsl:when test="$elementValue='SEK'"/>
<xsl:when test="$elementValue='SGD'"/>
<xsl:when test="$elementValue='SKK'"/>
<xsl:when test="$elementValue='THB'"/>
<xsl:when test="$elementValue='TRY'"/>
<xsl:when test="$elementValue='TWD'"/>
<xsl:when test="$elementValue='USD'"/>
<xsl:when test="$elementValue='ZAR'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType='Cross Currency IRS'">
<xsl:choose>
<xsl:when test="$elementValue='AUD'"/>
<xsl:when test="$elementValue='CAD'"/>
<xsl:when test="$elementValue='CHF'"/>
<xsl:when test="$elementValue='CLP'"/>
<xsl:when test="$elementValue='CNY'"/>
<xsl:when test="$elementValue='COP'"/>
<xsl:when test="$elementValue='CZK'"/>
<xsl:when test="$elementValue='DKK'"/>
<xsl:when test="$elementValue='EUR'"/>
<xsl:when test="$elementValue='GBP'"/>
<xsl:when test="$elementValue='HKD'"/>
<xsl:when test="$elementValue='HUF'"/>
<xsl:when test="$elementValue='IDR'"/>
<xsl:when test="$elementValue='INR'"/>
<xsl:when test="$elementValue='ILS'"/>
<xsl:when test="$elementValue='JPY'"/>
<xsl:when test="$elementValue='KRW'"/>
<xsl:when test="$elementValue='MXN'"/>
<xsl:when test="$elementValue='MYR'"/>
<xsl:when test="$elementValue='NOK'"/>
<xsl:when test="$elementValue='NZD'"/>
<xsl:when test="$elementValue='PLN'"/>
<xsl:when test="$elementValue='PHP'"/>
<xsl:when test="$elementValue='RUB'"/>
<xsl:when test="$elementValue='SEK'"/>
<xsl:when test="$elementValue='SGD'"/>
<xsl:when test="$elementValue='SKK'"/>
<xsl:when test="$elementValue='THB'"/>
<xsl:when test="$elementValue='TRY'"/>
<xsl:when test="$elementValue='TWD'"/>
<xsl:when test="$elementValue='USD'"/>
<xsl:when test="$elementValue='ZAR'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
</xsl:choose>
</xsl:template>
<xsl:template name="isValidDate">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Invalid date format for <xsl:value-of select="$elementName"/>. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:if test="not(string-length($elementValue)=10)">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:if>
<xsl:choose>
<xsl:when test="substring($elementValue,5,1)='-'">
<xsl:choose>
<xsl:when test="substring($elementValue,8,1)='-'">
<xsl:choose>
<xsl:when test="string(number(substring($elementValue,1,1)))!= 'NaN'">
<xsl:choose>
<xsl:when test="string(number(substring($elementValue,2,1)))!= 'NaN'">
<xsl:choose>
<xsl:when test="string(number(substring($elementValue,3,1)))!= 'NaN'">
<xsl:choose>
<xsl:when test="string(number(substring($elementValue,4,1)))!= 'NaN'">
<xsl:choose>
<xsl:when test="string(number(substring($elementValue,6,1)))!= 'NaN'">
<xsl:choose>
<xsl:when test="string(number(substring($elementValue,7,1)))!= 'NaN'">
<xsl:choose>
<xsl:when test="string(number(substring($elementValue,9,1)))!= 'NaN'">
<xsl:choose>
<xsl:when test="string(number(substring($elementValue,10,1)))!= 'NaN'">
<xsl:choose>
<xsl:when test="number(substring($elementValue,1,4)) != 0">
<xsl:choose>
<xsl:when test="number(substring($elementValue,6,2)) != 0 and number(substring($elementValue,6,2)) &lt; 13">
<xsl:choose>
<xsl:when test="number(substring($elementValue,9,2)) != 0 and number(substring($elementValue,9,2)) &lt; 32">
</xsl:when>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template name="isValidDayCountFraction">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> for product type of '<xsl:value-of select="$productType"/>'. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:if test="$productType='IRS' or $productType='OIS' or $productType='Swaption' or $productType='Single Currency Basis Swap' or $productType='CapFloor' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS'">
<xsl:choose>
<xsl:when test="$tradeCurrency='GBP' or $tradeCurrency2='GBP'">
<xsl:choose>
<xsl:when test="$elementValue='ACT/365.FIXED'"/>
<xsl:when test="$elementValue='ACT/365.ISDA'"/>
<xsl:when test="$elementValue='ACT/360'"/>
<xsl:when test="$elementValue='30/360'"/>
<xsl:when test="$elementValue='30E/360'"/>
<xsl:when test="$elementValue='30E/360.ISDA'"/>
<xsl:when test="$elementValue='ACT/ACT.ISMA'"/>
<xsl:when test="$elementValue='ACT/ACT.ICMA'"/>
<xsl:when test="$elementValue='ACT/ACT.ISDA'"/>
<xsl:when test="$elementValue='ACT/365L'"/>
<xsl:when test="($elementValue='1/1') and ($swExtendedTradeDetails/fpml:swCapFloorDetails/fpml:swFloatingRateFixingDate/fpml:unadjustedDate !='')"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$tradeCurrency!='GBP' or $tradeCurrency2!='GBP'">
<xsl:choose>
<xsl:when test="$elementValue='ACT/365.FIXED'"/>
<xsl:when test="$elementValue='ACT/365.ISDA'"/>
<xsl:when test="$elementValue='ACT/360'"/>
<xsl:when test="$elementValue='30/360'"/>
<xsl:when test="$elementValue='30E/360'"/>
<xsl:when test="$elementValue='30E/360.ISDA'"/>
<xsl:when test="$elementValue='ACT/ACT.ISMA'"/>
<xsl:when test="$elementValue='ACT/ACT.ICMA'"/>
<xsl:when test="$elementValue='ACT/ACT.ISDA'"/>
<xsl:when test="(($elementValue='BUS/252') and ($tradeCurrency='BRL') and ($productType='IRS'))"/>
<xsl:when test="($elementValue='1/1') and ($swExtendedTradeDetails/fpml:swCapFloorDetails/fpml:swFloatingRateFixingDate/fpml:unadjustedDate !='')"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
</xsl:choose>
</xsl:if>
<xsl:if test="$productType='FRA'">
<xsl:choose>
<xsl:when test="$tradeCurrency='GBP'">
<xsl:choose>
<xsl:when test="$elementValue='ACT/365.FIXED'"/>
<xsl:when test="$elementValue='ACT/360'"/>
<xsl:when test="$elementValue='ACT/ACT.ISDA'"/>
<xsl:when test="$elementValue='ACT/365L'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$tradeCurrency!='GBP'">
<xsl:choose>
<xsl:when test="$elementValue='ACT/365.FIXED'"/>
<xsl:when test="$elementValue='ACT/360'"/>
<xsl:when test="$elementValue='ACT/ACT.ISDA'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
</xsl:choose>
</xsl:if>
<xsl:if test="$productType='ZCInflationSwap' and (//fpml:couponRate)">
<xsl:choose>
<xsl:when test="$elementValue='ACT/365.FIXED'"/>
<xsl:when test="$elementValue='ACT/360'"/>
<xsl:when test="$elementValue='30/360'"/>
<xsl:when test="$elementValue='30E/360'"/>
<xsl:when test="$elementValue='30E/360.ISDA'"/>
<xsl:when test="$elementValue='ACT/365L'"/>
<xsl:when test="$elementValue='ACT/ACT.ICMA'"/>
<xsl:when test="$elementValue='ACT/ACT.ISDA'"/>
<xsl:when test="$elementValue='1/1'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="$productType='ZCInflationSwap' and not(//fpml:couponRate)">
<xsl:choose>
<xsl:when test="$elementValue='1/1'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:template>
<xsl:template name="isValidDayType">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/>. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='Business'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template name="isValidInformationProvider">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Missing, empty or invalid <xsl:value-of select="$elementName"/>. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='ISDA'"/>
<xsl:when test="$elementValue='ICESWAP'"/>
<xsl:when test="$elementValue='Telerate'"/>
<xsl:when test="$elementValue='Reuters'"/>
<xsl:when test="$elementValue='Reference Banks'"/>
<xsl:when test="$elementValue='TOKYOSWAP' and $tradeCurrency='JPY'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template name="isValidIntegerNumber">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="minIncl"/>
<xsl:param name="maxIncl"/>
<xsl:param name="context"/>
<xsl:choose>
<xsl:when test="string(number($elementValue)) !='NaN' and not(contains($elementValue,'.')) and not(contains($elementValue,' '))">
<xsl:if test="number($elementValue) &lt; $minIncl or number($elementValue) &gt; $maxIncl">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$elementName"/> is outside allowable range; minIncl=<xsl:value-of select="$minIncl"/>, maxIncl=<xsl:value-of select="$maxIncl"/>. Value = '<xsl:value-of select="$elementValue"/>'.</text>
</error>
</xsl:if>
</xsl:when>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$elementName"/> is not a valid integer number. Value = '<xsl:value-of select="$elementValue"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template name="isValidIMMCurrency">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">rollConvention must not be equal to 'IMM' if trade currency is equal to '<xsl:value-of select="$elementValue"/>' (IMM Rolls not currently supported in SwapsWire for <xsl:value-of select="$elementValue"/>).</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='AUD'"/>
<xsl:when test="$elementValue='CAD'"/>
<xsl:when test="$elementValue='CHF'"/>
<xsl:when test="$elementValue='CLP'"/>
<xsl:when test="$elementValue='CNY'"/>
<xsl:when test="$elementValue='COP'"/>
<xsl:when test="$elementValue='CZK'"/>
<xsl:when test="$elementValue='DKK'"/>
<xsl:when test="$elementValue='EUR'"/>
<xsl:when test="$elementValue='GBP'"/>
<xsl:when test="$elementValue='HKD'"/>
<xsl:when test="$elementValue='IDR'"/>
<xsl:when test="$elementValue='ILS'"/>
<xsl:when test="$elementValue='INR'"/>
<xsl:when test="$elementValue='HUF'"/>
<xsl:when test="$elementValue='JPY'"/>
<xsl:when test="$elementValue='KRW'"/>
<xsl:when test="$elementValue='MYR'"/>
<xsl:when test="$elementValue='NOK'"/>
<xsl:when test="$elementValue='NZD'"/>
<xsl:when test="$elementValue='PLN'"/>
<xsl:when test="$elementValue='SEK'"/>
<xsl:when test="$elementValue='SGD'"/>
<xsl:when test="$elementValue='SKK'"/>
<xsl:when test="$elementValue='THB'"/>
<xsl:when test="$elementValue='TWD'"/>
<xsl:when test="$elementValue='USD'"/>
<xsl:when test="$elementValue='ZAR'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template name="isValidIMMMonth">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="calculationPeriodFrequency"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">When rollConvention is equal to 'IMM' and floating leg calculationPeriodFrequency is equal to '3M', '6M' or '1Y' <xsl:value-of select="$elementName"/> month must be Mar, Jun, Sep or Dec. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:variable name="month">
<xsl:value-of select="substring($elementValue,6,2)"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$calculationPeriodFrequency='3M' or $calculationPeriodFrequency='6M' or $calculationPeriodFrequency='1Y'">
<xsl:choose>
<xsl:when test="$month='03'"/>
<xsl:when test="$month='06'"/>
<xsl:when test="$month='09'"/>
<xsl:when test="$month='12'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:otherwise/>
</xsl:choose>
</xsl:template>
<xsl:template name="isValidIntegerNumber2">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="minIncl"/>
<xsl:param name="maxIncl"/>
<xsl:param name="maxDigits"/>
<xsl:param name="context"/>
<xsl:choose>
<xsl:when test="string(number($elementValue)) !='NaN' and not(contains($elementValue,'.')) and not(contains($elementValue,' '))">
<xsl:if test="number($elementValue) &lt; $minIncl or number($elementValue) &gt; $maxIncl">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** The part of <xsl:value-of select="$elementName"/> left of fractional separator is outside allowable range; minIncl=<xsl:value-of select="$minIncl"/>, maxIncl=<xsl:value-of select="$maxIncl"/>. Value = '<xsl:value-of select="$elementValue"/>'.</text>
</error>
</xsl:if>
</xsl:when>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** The part of <xsl:value-of select="$elementName"/> left of fractional separator is not a valid integer number. Value = '<xsl:value-of select="$elementValue"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
<xsl:if test="string-length($elementValue) &gt; $maxDigits">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$elementName"/> has too many digits to left of fractional separator; maxDigits=<xsl:value-of select="$maxDigits"/>. Value = '<xsl:value-of select="$elementValue"/>'.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template name="isValidInflationAssetSwap">
<xsl:param name="context"/>
<xsl:choose>
<xsl:when test="(//fpml:couponRate and //fpml:swfallbackBondApplicable and //fpml:swCalculationMethod and //fpml:swCalculationStyle and //fpml:swFloored and //fpml:swSpreadCalculationMethod)"/>
<xsl:when test="(not(//fpml:couponRate) and not(//fpml:swfallbackBondApplicable) and not(//fpml:swCalculationMethod) and not(//fpml:swCalculationStyle) and not(//fpml:swFloored) and not(//fpml:swSpreadCalculationMethod))"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** Something was wrong with the deal submitted. The following fields are required for Standard Coupon Inflation Swap: Initial Index Level, Calculation Method, Calculation Style, Final Price Exchange Calculation, Coupon Rate, Fallback Bond Applicable, Related Bond, Spread Calculation Method</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template name="isValidContractualDefinitions">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Invalid <xsl:value-of select="$elementName"/>. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='ISDA2000'"/>
<xsl:when test="$elementValue='ISDA2006'"/>
<xsl:when test="$elementValue='ISDA2021'"/>
<xsl:when test="$elementValue='ISDA2006Inflation' and $productType='ZCInflationSwap'"/>
<xsl:when test="$elementValue='ISDA2008Inflation' and $productType='ZCInflationSwap'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template name="isValidMasterAgreementType">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/>. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='ISDA'"/>
<xsl:when test="$elementValue='AFB/FBF'"/>
<xsl:when test="$elementValue='DERV'"/>
<xsl:when test="$elementValue='CMOF'"/>
<xsl:when test="$elementValue='SWISS'"/>
<xsl:when test="$elementValue='AUSTRIAN'"/>
<xsl:when test="$elementValue='ISDAFIA-CDEA'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template name="isValidNumber">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="minIncl"/>
<xsl:param name="maxIncl"/>
<xsl:param name="maxDecs"/>
<xsl:param name="context"/>
<xsl:choose>
<xsl:when test="string(number($elementValue)) !='NaN' and not(contains($elementValue,' ')) and not(contains($elementValue,'e')) and not(contains($elementValue,'E'))">
<xsl:if test="number($elementValue) &lt; $minIncl or number($elementValue) &gt; $maxIncl">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$elementName"/> is outside allowable range; minIncl=<xsl:value-of select="$minIncl"/>, maxIncl=<xsl:value-of select="$maxIncl"/>. Value = '<xsl:value-of select="$elementValue"/>'.</text>
</error>
</xsl:if>
</xsl:when>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$elementName"/> is not a valid number. Value = '<xsl:value-of select="$elementValue"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
<xsl:if test="string-length(substring-after($elementValue,'.')) &gt; $maxDecs">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$elementName"/> has too many decimal places; maxDecs=<xsl:value-of select="$maxDecs"/>. Value = '<xsl:value-of select="$elementValue"/>'.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template name="isValidNumber2">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="minIncl"/>
<xsl:param name="maxIncl"/>
<xsl:param name="maxDecs"/>
<xsl:param name="context"/>
<xsl:choose>
<xsl:when test="string(number($elementValue)) !='NaN' and not(contains($elementValue,' ')) and not(contains($elementValue,'e')) and not(contains($elementValue,'E'))">
<xsl:if test="number($elementValue) &lt; $minIncl or number($elementValue) &gt; $maxIncl">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$elementName"/> is outside allowable range; minIncl=<xsl:value-of select="$minIncl"/>, maxIncl=<xsl:value-of select="$maxIncl"/>. Value = '<xsl:value-of select="$elementValue"/>'.</text>
</error>
</xsl:if>
<xsl:if test="contains($elementValue,'.') and string-length(substring-after($elementValue,'.')) = 0">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$elementName"/> is not a valid number. At least one digit must follow decimal separator. Value = '<xsl:value-of select="$elementValue"/>'.</text>
</error>
</xsl:if>
<xsl:if test="contains($elementValue,'.') and string-length(substring-before($elementValue,'.')) = 0">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$elementName"/> is not a valid number. At least one digit must precede decimal separator. Value = '<xsl:value-of select="$elementValue"/>'.</text>
</error>
</xsl:if>
</xsl:when>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$elementName"/> is not a valid number. Value = '<xsl:value-of select="$elementValue"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
<xsl:if test="string-length(substring-after($elementValue,'.')) &gt; $maxDecs">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$elementName"/> has too many decimal places; maxDecs=<xsl:value-of select="$maxDecs"/>. Value = '<xsl:value-of select="$elementValue"/>'.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template name="isValidPaymentType">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/>. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='UpfrontFee'"/>
<xsl:when test="$elementValue='NovationExecutionFee'"/>
<xsl:when test="$elementValue='AmendmentFee'"/>
<xsl:when test="$elementValue='PartialTermination'"/>
<xsl:when test="$elementValue='UnclassifiedFee'"/>
<xsl:when test="$elementValue='Independent Amount'"/>
<xsl:when test="$elementValue='CancellablePremium'"/>
<xsl:when test="$elementValue='Cancellation'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template name="isValidPayRelativeTo">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/>. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='CalculationPeriodEndDate'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template name="isValidPeriod">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> for product type of '<xsl:value-of select="$productType"/>'. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$productType='OIS'">
<xsl:choose>
<xsl:when test="$elementValue='D'"/>
<xsl:when test="$elementValue='M'"/>
<xsl:when test="$elementValue='Y'"/>
<xsl:when test="$elementValue='T'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS'">
<xsl:choose>
<xsl:when test="$elementValue='D'"/>
<xsl:when test="$elementValue='W'"/>
<xsl:when test="$elementValue='M'"/>
<xsl:when test="$elementValue='Y'"/>
<xsl:when test="$elementValue='T'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:otherwise>
<xsl:choose>
<xsl:when test="$elementValue='D'"/>
<xsl:when test="$elementValue='W'"/>
<xsl:when test="$elementValue='M'"/>
<xsl:when test="$elementValue='Y'"/>
<xsl:when test="$elementValue='T'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template name="isValidperiodMultiplier">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/>. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="not(contains($elementValue,'.')) and not(contains($elementValue,'e')) and not(contains($elementValue,'E'))">
<xsl:if test="string(number($elementValue)) ='NaN'">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:if>
</xsl:when>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template name="isValidPriceType">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/>. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='F128'"/>
<xsl:when test="$elementValue='F256'"/>
<xsl:when test="$elementValue='D5'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template name="isValidProductType">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> if SWDML version = "<xsl:value-of select="$version"/>". Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:if test="$version='4-2'">
<xsl:choose>
<xsl:when test="$elementValue='SingleCurrencyInterestRateSwap'"/>
<xsl:when test="$elementValue='FRA'"/>
<xsl:when test="$elementValue='OIS'"/>
<xsl:when test="$elementValue='Swaption'"/>
<xsl:when test="$elementValue='ZC Inflation Swap'"/>
<xsl:when test="$elementValue='Single Currency Basis Swap'"/>
<xsl:when test="$elementValue='CapFloor'"/>
<xsl:when test="$elementValue='Cross Currency Basis Swap'"/>
<xsl:when test="$elementValue='Cross Currency IRS'"/>
<xsl:when test="$elementValue='Offline Trade Rates'"/>
<xsl:when test="$elementValue='Fixed Fixed Swap'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:template>
<xsl:template name="isValidProductSubType">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/>. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='ZeroCouponFixed'"/>
<xsl:when test="$elementValue='ZeroCouponFloat'"/>
<xsl:when test="$elementValue='ZeroCouponFixedFloat'"/>
<xsl:when test="$elementValue='ZeroCouponFixed2'"/>
<xsl:when test="$elementValue='ZeroCouponFixedFixed2'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template name="isValidQuotationRateType">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Missing, empty or invalid <xsl:value-of select="$elementName"/>. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='Bid'"/>
<xsl:when test="$elementValue='Ask'"/>
<xsl:when test="$elementValue='Mid'"/>
<xsl:when test="$elementValue='ExercisingPartyPays'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template name="isValidResetRelativeTo">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> for product type is '<xsl:value-of select="$productType"/>'. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:variable name="oisErrorText">Empty or invalid <xsl:value-of select="$elementName"/> for a product type which uses OIS indices (OIS, OIS on CapFloor, etc.)'. Use CalculationPeriodEndDate instead.'</xsl:variable>
<xsl:if test="$productType='IRS' or $productType='fpml:capFloor' or $productType='Swaption' or $productType='Single Currency Basis Swap'">
<xsl:choose>
<xsl:when test="$elementValue='CalculationPeriodStartDate'"/>
<xsl:when test="$elementValue='CalculationPeriodEndDate'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="$productType='OIS' or $isOISonCapFloor='true'">
<xsl:choose>
<xsl:when test="$elementValue='CalculationPeriodEndDate'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$oisErrorText"/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:template>
<xsl:template name="isValidRollConvention">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> for product type of '<xsl:value-of select="$productType"/>'. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='NONE'"/>
<xsl:when test="$elementValue='EOM'"/>
<xsl:when test="$elementValue='IMM'"/>
<xsl:when test="$elementValue='IMMAUD' and $tradeCurrency='AUD'"/>
<xsl:when test="$elementValue='IMMCAD' and $tradeCurrency='CAD'"/>
<xsl:when test="$elementValue='IMMNZD' and $tradeCurrency='NZD'"/>
<xsl:when test="$elementValue='1'"/>
<xsl:when test="$elementValue='2'"/>
<xsl:when test="$elementValue='3'"/>
<xsl:when test="$elementValue='4'"/>
<xsl:when test="$elementValue='5'"/>
<xsl:when test="$elementValue='6'"/>
<xsl:when test="$elementValue='7'"/>
<xsl:when test="$elementValue='8'"/>
<xsl:when test="$elementValue='9'"/>
<xsl:when test="$elementValue='10'"/>
<xsl:when test="$elementValue='11'"/>
<xsl:when test="$elementValue='12'"/>
<xsl:when test="$elementValue='13'"/>
<xsl:when test="$elementValue='14'"/>
<xsl:when test="$elementValue='15'"/>
<xsl:when test="$elementValue='16'"/>
<xsl:when test="$elementValue='17'"/>
<xsl:when test="$elementValue='18'"/>
<xsl:when test="$elementValue='19'"/>
<xsl:when test="$elementValue='20'"/>
<xsl:when test="$elementValue='21'"/>
<xsl:when test="$elementValue='22'"/>
<xsl:when test="$elementValue='23'"/>
<xsl:when test="$elementValue='24'"/>
<xsl:when test="$elementValue='25'"/>
<xsl:when test="$elementValue='26'"/>
<xsl:when test="$elementValue='27'"/>
<xsl:when test="$elementValue='28'"/>
<xsl:when test="$elementValue='29'"/>
<xsl:when test="$elementValue='30'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template name="isValidStubLength">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/>. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='Short'"/>
<xsl:when test="$elementValue='Long'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template name="isValidStubPosition">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/>. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='Start'"/>
<xsl:when test="$elementValue='End'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template name="isValidTime">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/>. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='00:00:00'"/>
<xsl:when test="$elementValue='01:00:00'"/>
<xsl:when test="$elementValue='02:00:00'"/>
<xsl:when test="$elementValue='03:00:00'"/>
<xsl:when test="$elementValue='04:00:00'"/>
<xsl:when test="$elementValue='05:00:00'"/>
<xsl:when test="$elementValue='06:00:00'"/>
<xsl:when test="$elementValue='07:00:00'"/>
<xsl:when test="$elementValue='08:00:00'"/>
<xsl:when test="$elementValue='09:00:00'"/>
<xsl:when test="$elementValue='09:30:00'"/>
<xsl:when test="$elementValue='09:55:00'"/>
<xsl:when test="$elementValue='10:00:00'"/>
<xsl:when test="$elementValue='10:30:00'"/>
<xsl:when test="$elementValue='11:00:00'"/>
<xsl:when test="$elementValue='11:10:00'"/>
<xsl:when test="$elementValue='11:15:00'"/>
<xsl:when test="$elementValue='11:30:00'"/>
<xsl:when test="$elementValue='11:40:00'"/>
<xsl:when test="$elementValue='12:00:00'"/>
<xsl:when test="$elementValue='12:10:00'"/>
<xsl:when test="$elementValue='12:15:00'"/>
<xsl:when test="$elementValue='12:35:00'"/>
<xsl:when test="$elementValue='12:30:00'"/>
<xsl:when test="$elementValue='12:40:00'"/>
<xsl:when test="$elementValue='13:00:00'"/>
<xsl:when test="$elementValue='13:15:00'"/>
<xsl:when test="$elementValue='13:30:00'"/>
<xsl:when test="$elementValue='13:35:00'"/>
<xsl:when test="$elementValue='14:00:00'"/>
<xsl:when test="$elementValue='14:15:00'"/>
<xsl:when test="$elementValue='14:30:00'"/>
<xsl:when test="$elementValue='14:45:00'"/>
<xsl:when test="$elementValue='15:00:00'"/>
<xsl:when test="$elementValue='15:15:00'"/>
<xsl:when test="$elementValue='15:30:00'"/>
<xsl:when test="$elementValue='16:00:00'"/>
<xsl:when test="$elementValue='16:30:00'"/>
<xsl:when test="$elementValue='17:00:00'"/>
<xsl:when test="$elementValue='18:00:00'"/>
<xsl:when test="$elementValue='19:00:00'"/>
<xsl:when test="$elementValue='20:00:00'"/>
<xsl:when test="$elementValue='21:00:00'"/>
<xsl:when test="$elementValue='22:00:00'"/>
<xsl:when test="$elementValue='23:00:00'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template name="isValid32nd">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText"> If swPriceType is equal to 'F128' or 'F256' two characters to right of fractional separator in <xsl:value-of select="$elementName"/> are not in range 00 - 31. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='00'"/>
<xsl:when test="$elementValue='01'"/>
<xsl:when test="$elementValue='02'"/>
<xsl:when test="$elementValue='03'"/>
<xsl:when test="$elementValue='04'"/>
<xsl:when test="$elementValue='05'"/>
<xsl:when test="$elementValue='06'"/>
<xsl:when test="$elementValue='07'"/>
<xsl:when test="$elementValue='08'"/>
<xsl:when test="$elementValue='09'"/>
<xsl:when test="$elementValue='10'"/>
<xsl:when test="$elementValue='11'"/>
<xsl:when test="$elementValue='12'"/>
<xsl:when test="$elementValue='13'"/>
<xsl:when test="$elementValue='14'"/>
<xsl:when test="$elementValue='15'"/>
<xsl:when test="$elementValue='16'"/>
<xsl:when test="$elementValue='17'"/>
<xsl:when test="$elementValue='18'"/>
<xsl:when test="$elementValue='19'"/>
<xsl:when test="$elementValue='20'"/>
<xsl:when test="$elementValue='21'"/>
<xsl:when test="$elementValue='22'"/>
<xsl:when test="$elementValue='23'"/>
<xsl:when test="$elementValue='24'"/>
<xsl:when test="$elementValue='25'"/>
<xsl:when test="$elementValue='26'"/>
<xsl:when test="$elementValue='27'"/>
<xsl:when test="$elementValue='28'"/>
<xsl:when test="$elementValue='29'"/>
<xsl:when test="$elementValue='30'"/>
<xsl:when test="$elementValue='31'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template name="isValid128th">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText"> If swPriceType is equal to 'F128' third character to right of fractional separator in <xsl:value-of select="$elementName"/> must be '2', '+' or '6'. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue=''"/>
<xsl:when test="$elementValue='2'"/>
<xsl:when test="$elementValue='+'"/>
<xsl:when test="$elementValue='6'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template name="isValid256th">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText"> If swPriceType is equal to 'F256' third character to right of fractional separator in <xsl:value-of select="$elementName"/> must be '0', '1', '2', '3', '4', '5', '6', '7' or '+'. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue=''"/>
<xsl:when test="$elementValue='0'"/>
<xsl:when test="$elementValue='1'"/>
<xsl:when test="$elementValue='2'"/>
<xsl:when test="$elementValue='3'"/>
<xsl:when test="$elementValue='4'"/>
<xsl:when test="$elementValue='5'"/>
<xsl:when test="$elementValue='6'"/>
<xsl:when test="$elementValue='7'"/>
<xsl:when test="$elementValue='+'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template name="isValidBreakCalculationMethod">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/>. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='Adjust To Coupon Dates'"/>
<xsl:when test="$elementValue='Straight Calendar Dates'"/>
<xsl:when test="$elementValue='ISDA Standard Method'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template name="isValidAveragingMethod">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/>. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='Weighted'"/>
<xsl:when test="$elementValue='Unweighted'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template name="isValidWeeklyRollConvention">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/>. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='MON'"/>
<xsl:when test="$elementValue='TUE'"/>
<xsl:when test="$elementValue='WED'"/>
<xsl:when test="$elementValue='THU'"/>
<xsl:when test="$elementValue='FRI'"/>
<xsl:when test="$elementValue='SAT'"/>
<xsl:when test="$elementValue='SUN'"/>
<xsl:when test="$elementValue='TBILL'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template name="isValidNonDeliverableCurrency">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> for Non-deliverable product type of '<xsl:value-of select="$productType"/>'. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$productType='IRS'">
<xsl:choose>
<xsl:when test="$elementValue='BRL'"/>
<xsl:when test="$elementValue='CLP'"/>
<xsl:when test="$elementValue='CNY'"/>
<xsl:when test="$elementValue='IDR'"/>
<xsl:when test="$elementValue='INR'"/>
<xsl:when test="$elementValue='KRW'"/>
<xsl:when test="$elementValue='MYR'"/>
<xsl:when test="$elementValue='PHP'"/>
<xsl:when test="$elementValue='THB'"/>
<xsl:when test="$elementValue='TWD'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType='Swaption'">
<xsl:choose>
<xsl:when test="$elementValue='CNY'"/>
<xsl:when test="$elementValue='COP'"/>
<xsl:when test="$elementValue='INR'"/>
<xsl:when test="$elementValue='KRW'"/>
<xsl:when test="$elementValue='MYR'"/>
<xsl:when test="$elementValue='THB'"/>
<xsl:when test="$elementValue='TWD'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType='OIS'">
<xsl:choose>
<xsl:when test="$elementValue='COP'"/>
<xsl:when test="$elementValue='INR'"/>
<xsl:when test="$elementValue='MYR'"/>
<xsl:when test="$elementValue='THB'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType='Cross Currency Basis Swap'">
<xsl:choose>
<xsl:when test="$elementValue='CLP'"/>
<xsl:when test="$elementValue='CNY'"/>
<xsl:when test="$elementValue='COP'"/>
<xsl:when test="$elementValue='IDR'"/>
<xsl:when test="$elementValue='INR'"/>
<xsl:when test="$elementValue='KRW'"/>
<xsl:when test="$elementValue='MYR'"/>
<xsl:when test="$elementValue='PHP'"/>
<xsl:when test="$elementValue='THB'"/>
<xsl:when test="$elementValue='TWD'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType='Cross Currency IRS'">
<xsl:choose>
<xsl:when test="$elementValue='CNY'"/>
<xsl:when test="$elementValue='CLP'"/>
<xsl:when test="$elementValue='COP'"/>
<xsl:when test="$elementValue='IDR'"/>
<xsl:when test="$elementValue='INR'"/>
<xsl:when test="$elementValue='KRW'"/>
<xsl:when test="$elementValue='MYR'"/>
<xsl:when test="$elementValue='PHP'"/>
<xsl:when test="$elementValue='THB'"/>
<xsl:when test="$elementValue='TWD'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType='Fixed Fixed Swap'">
<xsl:choose>
<xsl:when test="$elementValue='BRL'"/>
<xsl:when test="$elementValue='CLP'"/>
<xsl:when test="$elementValue='CNY'"/>
<xsl:when test="$elementValue='IDR'"/>
<xsl:when test="$elementValue='INR'"/>
<xsl:when test="$elementValue='KRW'"/>
<xsl:when test="$elementValue='MYR'"/>
<xsl:when test="$elementValue='PHP'"/>
<xsl:when test="$elementValue='THB'"/>
<xsl:when test="$elementValue='TWD'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
</xsl:choose>
</xsl:template>
<xsl:template name="isValidFRADiscounting">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText"> Empty or invalid <xsl:value-of select="$elementName"/>. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='ISDA'"/>
<xsl:when test="$elementValue='NONE'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template name="isValidInflationLag">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText"> Empty or invalid <xsl:value-of select="$elementName"/>. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='0M'"/>
<xsl:when test="$elementValue='1M'"/>
<xsl:when test="$elementValue='2M'"/>
<xsl:when test="$elementValue='3M'"/>
<xsl:when test="$elementValue='4M'"/>
<xsl:when test="$elementValue='5M'"/>
<xsl:when test="$elementValue='6M'"/>
<xsl:when test="$elementValue='7M'"/>
<xsl:when test="$elementValue='8M'"/>
<xsl:when test="$elementValue='9M'"/>
<xsl:when test="$elementValue='10M'"/>
<xsl:when test="$elementValue='11M'"/>
<xsl:when test="$elementValue='12M'"/>
<xsl:when test="$elementValue='13M'"/>
<xsl:when test="$elementValue='14M'"/>
<xsl:when test="$elementValue='15M'"/>
<xsl:when test="$elementValue='16M'"/>
<xsl:when test="$elementValue='17M'"/>
<xsl:when test="$elementValue='18M'"/>
<xsl:when test="$elementValue='19M'"/>
<xsl:when test="$elementValue='20M'"/>
<xsl:when test="$elementValue='21M'"/>
<xsl:when test="$elementValue='22M'"/>
<xsl:when test="$elementValue='23M'"/>
<xsl:when test="$elementValue='24M'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template name="isValidShortFormCompoundingMethod">
<xsl:param name="floatPaymentFrequency"/>
<xsl:param name="floatRollFrequency"/>
<xsl:param name="compoundingMethod"/>
<xsl:variable name="context"/>
<xsl:if test="not($floatPaymentFrequency='') and not($floatRollFrequency='')">
<xsl:if test="$floatPaymentFrequency=$floatRollFrequency">
<xsl:choose>
<xsl:when test="$compoundingMethod=''"/>
<xsl:when test="$compoundingMethod='None'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** When swRollFrequency is the same as swFloatPaymentFrequency, swCompoundingMethod must be None.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:if>
<xsl:if test="not($floatPaymentFrequency=$floatRollFrequency) and $isOISonSwaption='false'">
<xsl:choose>
<xsl:when test="$compoundingMethod='Straight'"/>
<xsl:when test="$compoundingMethod='Flat'"/>
<xsl:when test="$compoundingMethod='SpreadExclusive'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** When swRollFrequency is not the same as swFloatPaymentFrequency, swCompoundingMethod must be provided and not be None.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:swMandatoryClearing|fpml:swMandatoryClearingNewNovatedTrade">
<xsl:param name="context"/>
<xsl:if test="fpml:swMandatoryClearingIndicator">
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">swMandatoryClearingIndicator</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swMandatoryClearingIndicator"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$context"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:for-each select="fpml:swPartyExemption/fpml:swExemption">
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">swExemption</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="current()"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$context"/>
</xsl:with-param>
</xsl:call-template>
</xsl:for-each>
<xsl:if test="fpml:swPartyExemption[position()=1]/fpml:swPartyReference/@href = fpml:swPartyExemption[position()=2]/fpml:swPartyReference/@href">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** swPartyExemption cannot be provided twice for the same party for the same clearing jurisdiction</text>
</error>
</xsl:if>
<xsl:if test="current()[fpml:swJurisdiction/text()!='DoddFrank'][fpml:swSupervisoryBodyCategory]">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** swSupervisoryBodyCategory not supported for '<xsl:value-of select="fpml:swJurisdiction"/>' clearing</text>
</error>
</xsl:if>
<xsl:if test="current()[contains(';ASIC;JFSA;MAS;', concat(';', fpml:swJurisdiction/text(),';'))][fpml:swPartyExemption]">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** swPartyExemption cannot be provided for '<xsl:value-of select="fpml:swJurisdiction"/>'</text>
</error>
</xsl:if>
<xsl:if test="not(contains(';ASIC;CAN;ESMA;FCA;HKMA;JFSA;DoddFrank;MIFID;MAS;', concat(';', fpml:swJurisdiction/text(),';')))">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** This value:'<xsl:value-of select="fpml:swJurisdiction"/>' of swJurisdiction is not in supported list for mandatory clearing - Permitted values: ASIC;CAN;ESMA;FCA;HKMA;JFSA;DoddFrank;MIFID;MAS. Concat result: '<xsl:value-of select="concat(';', fpml:swJurisdiction/text(),';')"/>' function contains returns: '<xsl:value-of select="contains(';ASIC;CAN;ESMA;FCA;HKMA;JFSA;DoddFrank;MIFID;MAS;', concat(';', fpml:swJurisdiction/text(),';'))"/>'
</text>
</error>
</xsl:if>
<xsl:if test="current()[fpml:swJurisdiction/text()='DoddFrank'][not(fpml:swSupervisoryBodyCategory='BroadBased')]">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** Invalid value: swSupervisoryBodyCategory not in supported list. Value='<xsl:value-of select="fpml:swSupervisoryBodyCategory/text()"/>'.</text>
</error>
</xsl:if>
<xsl:if test="current()[fpml:swJurisdiction/text()='JFSA']">
<xsl:if test="parent::node()[local-name()='swTradeHeader']">
<xsl:if test="$SWDML/fpml:swTradeEventReportingDetails/fpml:swReportingRegimeInformation[fpml:swJurisdiction/text()=current()/fpml:swJurisdiction/text()]/fpml:swMandatoryClearingIndicator">
<xsl:if test="not($SWDML/fpml:swTradeEventReportingDetails/fpml:swReportingRegimeInformation[fpml:swJurisdiction/text()=current()/fpml:swJurisdiction/text()]/fpml:swMandatoryClearingIndicator = current()/fpml:swMandatoryClearingIndicator)">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** Different values have been specified for swMandatoryClearingIndicator in reporting and clearing sections for jurisdiction '<xsl:value-of select="fpml:Jurisdiction"/>'.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
</xsl:if>
<xsl:if test="current()[fpml:swInterAffiliateExemption]">
<xsl:if test="not(current()[fpml:swJurisdiction/text()='DoddFrank'])">
<xsl:if test="not(current()[fpml:swSupervisoryBodyCategory/text()='BroadBased'])">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** May only provide a value for swInterAffiliateExemption under CFTC (swJurisdiction='DoddFrank' and swSupervisoryBodyCategory='BroadBased'), value of '<xsl:value-of select="fpml:swInterAffiliateExemption"/>' has been provided under jurisdiction '<xsl:value-of select="fpml:swJurisdiction"/>'.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:swBusinessConductDetails">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:apply-templates select="fpml:swMidMarketPrice">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:swMidMarketPrice">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="fpml:swUnit">
<xsl:choose>
<xsl:when test="fpml:swUnit/text()='Price'"/>
<xsl:when test="fpml:swUnit/text()='BasisPoints'"/>
<xsl:when test="fpml:swUnit/text()='Percentage'"/>
<xsl:when test="fpml:swUnit/text()='Level'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** Invalid value submitted for <xsl:value-of select="local-name()"/>/fpml:swUnit. Value = '<xsl:value-of select="fpml:swUnit/text()"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test=" fpml:swAmount and (string(number(fpml:swAmount/text())) ='NaN' or contains(fpml:swAmount/text(),'e') or contains(fpml:swAmount/text(),'E'))">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** Invalid value submitted for <xsl:value-of select="local-name()"/>/swAmount. Value = '<xsl:value-of select="swAmount/text()"/>'.</text>
</error>
</xsl:if>
<xsl:call-template name="isValidMidMarketAmount">
<xsl:with-param name="elementName">swAmount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swAmount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">-9999999999.99999999</xsl:with-param>
<xsl:with-param name="maxIncl">9999999999.99999999</xsl:with-param>
<xsl:with-param name="maxDecs">8</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="not(string-length(fpml:swUnit) &gt; 0) and (fpml:swCurrency or fpml:swAmount)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***Mid-Market Price Type is required.</text>
</error>
</xsl:if>
<xsl:if test="string-length(fpml:swUnit) &gt; 0 and not (fpml:swCurrency) and not (fpml:swAmount)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***Mid-Market Price Value is required.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swUnit/text() = 'Price' and  fpml:swCurrency and not(fpml:swAmount)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***Mid-Market Price Value is required.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:swUnit/text() = 'Price') and string-length(fpml:swUnit) &gt; 0 and string-length(fpml:swCurrency) &gt; 0">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***Mid-Market Price Currency not allowed for type.</text>
</error>
</xsl:if>
<xsl:if test=" fpml:swUnit/text()= 'Price' and fpml:swAmount and not(string-length(fpml:swCurrency) &gt; 0)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***Mid-Market Price currency cannot be blank.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template name="isValidMidMarketAmount">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="minIncl"/>
<xsl:param name="maxIncl"/>
<xsl:param name="maxDecs"/>
<xsl:param name="context"/>
<xsl:if test="string(number($elementValue)) and (string(number($elementValue)) !='NaN' and not(contains($elementValue,'e')) and    not(contains($elementValue,'E')))">
<xsl:if test="number($elementValue) &lt; $minIncl or number($elementValue) &gt; $maxIncl">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$elementName"/> is outside allowable range; minIncl=<xsl:value-of select="$minIncl"/>, maxIncl=<xsl:value-of select="$maxIncl"/>. Value = '<xsl:value-of select="$elementValue"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="string-length(substring-after($elementValue,'.')) &gt; $maxDecs">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$elementName"/> has too many decimal places; maxDecs=<xsl:value-of select="$maxDecs"/>. Value = '<xsl:value-of select="$elementValue"/>'.</text>
</error>
</xsl:if>
</xsl:template>
</xsl:stylesheet>
