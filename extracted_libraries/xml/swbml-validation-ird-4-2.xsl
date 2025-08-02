<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fpml="http://www.fpml.org/2005/FpML-4-2" xmlns:common="http://exslt.org/common" exclude-result-prefixes="fpml common" version="1.0">
<xsl:import href="CrossAssetValidation.xsl"/>
<xsl:import href="swbml-validation-reporting.xsl"/>
<xsl:variable name="version">
<xsl:value-of select="/fpml:SWBML/@version"/>
</xsl:variable>
<xsl:variable name="assetClass">Rates</xsl:variable>
<xsl:variable name="productType">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:swbProductType"/>
</xsl:variable>
<xsl:variable name="FpMLVersion">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/@version"/>
</xsl:variable>
<xsl:variable name="trade" select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade"/>
<xsl:variable name="isAllocatedTrade">
<xsl:choose>
<xsl:when test="/fpml:SWBML//fpml:swbAllocations">1</xsl:when>
<xsl:otherwise>0</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="frontandbackstub">
<xsl:choose>
<xsl:when test = "fpml:SWBML//fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbFrontAndBackStubs">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="isEmptyBlockTrade">
<xsl:choose>
<xsl:when test="/fpml:SWBML//fpml:swbBlockTrade">1</xsl:when>
<xsl:otherwise>0</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="blockIndependentAmountCurrency">
<xsl:if test="/fpml:SWBML//fpml:swbStructuredTradeDetails//fpml:collateral">
<xsl:value-of select="/fpml:SWBML//fpml:swbStructuredTradeDetails//fpml:collateral/fpml:independentAmount/fpml:paymentDetail/fpml:paymentAmount/fpml:currency"/>
</xsl:if>
</xsl:variable>
<xsl:variable name="isPrimeBrokerTrade">
<xsl:choose>
<xsl:when test="/fpml:SWBML/fpml:swbGiveUp">1</xsl:when>
<xsl:otherwise>0</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="isHarmonisedTrade">
<xsl:choose>
<xsl:when test="not(/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbTradeHeader//fpml:swbExecutingBroker) and not(/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbTradeHeader//fpml:swbClearingClient)">1</xsl:when>
<xsl:otherwise>0</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="fixedLeg">
<xsl:choose>
<xsl:when test="$productType='ZC Inflation Swap'">
<xsl:choose>
<xsl:when test="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=1]/fpml:calculationPeriodAmount/fpml:calculation/fpml:inflationRateCalculation">2</xsl:when>
<xsl:otherwise>1</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:otherwise>
<xsl:choose>
<xsl:when test="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=1]/fpml:resetDates or (($productType='OIS' or $productType='Cross Currency Basis Swap') and /fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=1]/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters)">2</xsl:when>
<xsl:otherwise>1</xsl:otherwise>
</xsl:choose>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="fixedLeg2">
<xsl:choose>
<xsl:when test="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[1][@id='fixedLeg2']">1</xsl:when>
<xsl:otherwise>2</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="floatingLeg">
<xsl:choose>
<xsl:when test="$productType='ZC Inflation Swap'">
<xsl:choose>
<xsl:when test="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=1]/fpml:calculationPeriodAmount/fpml:calculation/fpml:inflationRateCalculation">1</xsl:when>
<xsl:otherwise>2</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap'">
<xsl:choose>
<xsl:when test="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[1][@id='floatingLeg']">1</xsl:when>
<xsl:otherwise>2</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:otherwise>
<xsl:choose>
<xsl:when test="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=1]/fpml:resetDates or ($productType='OIS' and /fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=1]/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters)">1</xsl:when>
<xsl:otherwise>2</xsl:otherwise>
</xsl:choose>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="floatingLeg2">
<xsl:choose>
<xsl:when test="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[1][@id='floatingLeg2']">1</xsl:when>
<xsl:otherwise>2</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="tradeCurrency">
<xsl:choose>
<xsl:when test="$productType='Cross Currency IRS'">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$fixedLeg]/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:currency"/>
</xsl:when>
<xsl:when test="$productType='Fixed Fixed Swap'">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$fixedLeg]/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:currency"/>
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$fixedLeg]/fpml:calculationPeriodAmount/fpml:knownAmountSchedule/fpml:currency"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:currency"/>
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:capFloor/fpml:capFloorStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:currency"/>
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:fra/fpml:notional/fpml:currency"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="isOIScurrency">
<xsl:choose>
<xsl:when test="($tradeCurrency='AUD' or $tradeCurrency='CAD' or $tradeCurrency='CHF' or $tradeCurrency='COP' or $tradeCurrency='DKK' or $tradeCurrency='EUR' or $tradeCurrency='GBP' or $tradeCurrency='HKD' or $tradeCurrency='ILS' or $tradeCurrency='INR' or $tradeCurrency='JPY' or $tradeCurrency='MYR' or $tradeCurrency='NOK' or $tradeCurrency='NZD' or $tradeCurrency='PLN' or $tradeCurrency='RUB' or $tradeCurrency='SEK' or $tradeCurrency='SGD' or $tradeCurrency='THB' or $tradeCurrency='TRY' or $tradeCurrency='USD')">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="isOISIndex">
<xsl:variable name="friValue">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails//fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:floatingRateIndex | /fpml:SWBML/fpml:swbStructuredTradeDetails//fpml:FpML/fpml:trade//fpml:capFloor/fpml:capFloorStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:floatingRateIndex"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="(string-length(substring-before($friValue,'-OIS')) > 0) or ($friValue='GBP-SONIA-COMPOUND' or $friValue='USD-DTCC GCF Repo Index-Treasury-Bloomberg-COMPOUND' or $friValue='USD-SOFR-COMPOUND' or $friValue='EUR-EuroSTR-COMPOUND' or $friValue='SGD-SORA-COMPOUND' or $friValue='GBP-WMBA-SONIA-COMPOUND' or $friValue='GBP-WMBA-RONIA-COMPOUND' or $friValue='THB-THOR-COMPOUND' or $friValue='GBP-SONIA' or $friValue='USD-SOFR' or $friValue='EUR-EuroSTR' or $friValue='CHF-SARON' or $friValue='JPY-TONA' or $friValue='SGD-SORA' or $friValue='HKD-HONIA' or $friValue='AUD-AONIA' or $friValue='CAD-CORRA' or $friValue='GBP-RONIA' or $friValue='NOK-NOWA' or $friValue='NZD-NZIONA' or $friValue='PLN-POLONIA' or $friValue='PLN-WIRON'  or $friValue='THB-THOR' or $friValue='SEK-SWESTR' or $friValue='DKK-DESTR' or $friValue='RUB-RUONIA' or $friValue='ILS-SHIR' or $friValue='MYR-MYOR')">true</xsl:when>
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
<xsl:variable name="isCompoundingEnabledIndex">
<xsl:variable name="compoundingfriValue">
<xsl:value-of select="//fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:floatingRateIndex"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="($compoundingfriValue='GBP-SONIA' or  $compoundingfriValue='USD-SOFR' or $compoundingfriValue='EUR-EuroSTR' or $compoundingfriValue='SGD-SORA' or $compoundingfriValue='GBP-SONIA' or $compoundingfriValue='GBP-RONIA' or $compoundingfriValue='THB-THOR' or $compoundingfriValue='CHF-SARON' or $compoundingfriValue='JPY-TONA' or $compoundingfriValue='HKD-HONIA' or $compoundingfriValue='AUD-AONIA' or $compoundingfriValue='CAD-CORRA' or $compoundingfriValue='NOK-NOWA' or $compoundingfriValue='NZD-NZIONA' or  $compoundingfriValue='PLN-POLONIA'  or  $compoundingfriValue='PLN-WIRON' or $compoundingfriValue='SEK-SWESTR' or $compoundingfriValue='DKK-DESTR' or $compoundingfriValue='RUB-RUONIA' or $compoundingfriValue='ILS-SHIR' or $compoundingfriValue='MYR-MYOR')">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="isCompoundingEnabledIndex2">
<xsl:variable name="compoundingfriValue2">
<xsl:value-of select="//fpml:swapStream[position()=$floatingLeg2]/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:floatingRateIndex"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="($compoundingfriValue2='GBP-SONIA' or  $compoundingfriValue2='USD-SOFR' or
$compoundingfriValue2='EUR-EuroSTR' or $compoundingfriValue2='SGD-SORA' or $compoundingfriValue2='GBP-SONIA' or $compoundingfriValue2='GBP-RONIA' or $compoundingfriValue2='THB-THOR' or $compoundingfriValue2='CHF-SARON' or $compoundingfriValue2='JPY-TONA' or $compoundingfriValue2='HKD-HONIA' or $compoundingfriValue2='AUD-AONIA' or      $compoundingfriValue2='CAD-CORRA' or $compoundingfriValue2='NOK-NOWA' or $compoundingfriValue2='NZD-NZIONA' or      $compoundingfriValue2='PLN-POLONIA' or      $compoundingfriValue2='PLN-WIRON'  or $compoundingfriValue2='SEK-SWESTR' or $compoundingfriValue2='DKK-DESTR' or $compoundingfriValue2='RUB-RUONIA' or $compoundingfriValue2='ILS-SHIR' or $compoundingfriValue2='MYR-MYOR')">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="MarkToMarket">
<xsl:choose>
<xsl:when test="$productType='Fixed Fixed Swap'">
<xsl:choose>
<xsl:when test="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:swap/fpml:swapStream[position()=$fixedLeg2]/fpml:calculationPeriodAmount/fpml:calculation/fpml:fxLinkedNotionalSchedule">true</xsl:when>
<xsl:when test="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:swap/fpml:swapStream[position()=$fixedLeg]/fpml:calculationPeriodAmount/fpml:calculation/fpml:fxLinkedNotionalSchedule">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:otherwise>
<xsl:choose>
<xsl:when test="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:swap/fpml:swapStream[position()=$floatingLeg2]/fpml:calculationPeriodAmount/fpml:calculation/fpml:fxLinkedNotionalSchedule">true</xsl:when>
<xsl:when test="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodAmount/fpml:calculation/fpml:fxLinkedNotionalSchedule">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="tradeCurrency2">
<xsl:choose>
<xsl:when test="$productType='Cross Currency IRS'">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:currency"/>
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodAmount/fpml:calculation/fpml:fxLinkedNotionalSchedule/fpml:varyingNotionalCurrency"/>
</xsl:when>
<xsl:when test="$productType='Fixed Fixed Swap'">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$fixedLeg2]/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:currency"/>
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:swap/fpml:swapStream[position()=$fixedLeg2]/fpml:calculationPeriodAmount/fpml:calculation/fpml:fxLinkedNotionalSchedule/fpml:varyingNotionalCurrency"/>
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$fixedLeg2]/fpml:calculationPeriodAmount/fpml:knownAmountSchedule/fpml:currency"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$floatingLeg2]/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:currency"/>
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:swap/fpml:swapStream[position()=$floatingLeg2]/fpml:calculationPeriodAmount/fpml:calculation/fpml:fxLinkedNotionalSchedule/fpml:varyingNotionalCurrency"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="fixedPaymentFreq">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$fixedLeg]/fpml:paymentDates/fpml:paymentFrequency/fpml:periodMultiplier"/>
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$fixedLeg]/fpml:paymentDates/fpml:paymentFrequency/fpml:period"/>
</xsl:variable>
<xsl:variable name="fixedPaymentFreq2">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$fixedLeg2]/fpml:paymentDates/fpml:paymentFrequency/fpml:periodMultiplier"/>
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$fixedLeg2]/fpml:paymentDates/fpml:paymentFrequency/fpml:period"/>
</xsl:variable>
<xsl:variable name="floatPaymentFreq">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:paymentDates/fpml:paymentFrequency/fpml:periodMultiplier"/>
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:paymentDates/fpml:paymentFrequency/fpml:period"/>
</xsl:variable>
<xsl:variable name="interestRateSwapType">
<xsl:choose>
<xsl:when test="(($productType='SingleCurrencyInterestRateSwap' or $productType='OIS' or $isOISonSwaption='true') and $fixedPaymentFreq = '1T' and /fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$fixedLeg]/fpml:calculationPeriodAmount/fpml:knownAmountSchedule and /fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodAmount/fpml:calculation )">
<xsl:value-of select="'zeroCouponInterestRateSwapWithFixedAmount'"/>
</xsl:when>
<xsl:when test="(($productType='SingleCurrencyInterestRateSwap' or $productType='OIS' or $isOISonSwaption='true') and $fixedPaymentFreq = '1T' and /fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodAmount/fpml:calculation and /fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$fixedLeg]/fpml:calculationPeriodAmount/fpml:calculation)">
<xsl:value-of select="'zeroCouponInterestRateSwapWithFixedNotional'"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="'someOtherInterestRateProduct'"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="interestRateSwapFloatingLegType">
<xsl:choose>
<xsl:when test="(($productType='SingleCurrencyInterestRateSwap' or $productType='OIS' or $isOISonSwaption='true') and $floatPaymentFreq = '1T' )">
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
<xsl:variable name="SWBML" select="/fpml:SWBML"/>
<xsl:variable name="swbStructuredTradeDetails"  select="$SWBML/fpml:swbStructuredTradeDetails"/>
<xsl:variable name="swbExtendedTradeDetails"    select="$swbStructuredTradeDetails/fpml:swbExtendedTradeDetails"/>
<xsl:variable name="reportingData.rtf">
<xsl:apply-templates select="/fpml:SWBML/fpml:swbTradeEventReportingDetails" mode="mapReportingData"/>
<xsl:apply-templates select="/fpml:SWBML/fpml:swbPrivatePartyTradeEventReportingDetails" mode="mapReportingData"/>
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
<xsl:attribute name="{local-name()}">
<xsl:value-of select="."/>
</xsl:attribute>
</xsl:template>
<xsl:template match="/">
<xsl:apply-templates select="fpml:SWBML" mode="get-reporting-data"/>
</xsl:template>
<xsl:template match="/fpml:SWBML[function-available('common:node-set')]" mode="get-reporting-data">
<xsl:apply-templates select=".">
<xsl:with-param name="reportingData" select="common:node-set($reportingData.rtf)"/>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="/fpml:SWBML[not(function-available('common:node-set'))]" mode="get-reporting-data">
<xsl:apply-templates select=".">
<xsl:with-param name="reportingData" select="$reportingData.rtf"/>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:SWBML">
<xsl:param name="reportingData"/>
<xsl:variable name="newContext">In <xsl:value-of select="local-name()"/>
</xsl:variable>
<results version="1.0">
<xsl:if test="not($version='4-2')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid version attribute. Value = '<xsl:value-of select="$version"/>'.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:swbHeader">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:swbGiveUp">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:swbAllocations">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:swbStructuredTradeDetails">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:call-template name="swbTradeEventReportingDetails">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
<xsl:with-param name="reportingData" select="$reportingData"/>
</xsl:call-template>
</results>
</xsl:template>
<xsl:template match="fpml:swbHeader">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="href1">
<xsl:value-of select="fpml:swbRecipient[1]/fpml:partyReference/@href"/>
</xsl:variable>
<xsl:variable name="href2">
<xsl:value-of select="fpml:swbRecipient[2]/fpml:partyReference/@href"/>
</xsl:variable>
<xsl:if test="$href1=$href2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbRecipient[1]/partyReference/@href and swbRecipient[2]/partyReference/@href values must not be the same.</text>
</error>
</xsl:if>
<xsl:variable name="swbBrokerTradeId">
<xsl:value-of select="fpml:swbBrokerTradeId"/>
</xsl:variable>
<xsl:if test="$swbBrokerTradeId=''">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Empty or missing swbBrokerTradeId.</text>
</error>
</xsl:if>
<xsl:if test="string-length($swbBrokerTradeId) &gt; 50">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid swbBrokerTradeId string length. Exceeded max length of 50 characters.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swbBrokerLegId">
<xsl:variable name="swbBrokerLegId">
<xsl:value-of select="fpml:swbBrokerLegId"/>
</xsl:variable>
<xsl:if test="$swbBrokerLegId=''">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Empty swbBrokerLegId element.</text>
</error>
</xsl:if>
<xsl:if test="string-length($swbBrokerLegId) &gt; 20">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid swbBrokerLegId element value length. Exceeded max length of 20 characters.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:variable name="swbTradeSource">
<xsl:value-of select="fpml:swbTradeSource"/>
</xsl:variable>
<xsl:if test="$swbTradeSource=''">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Empty or missing swbTradeSource.</text>
</error>
</xsl:if>
<xsl:variable name="swbReplacementReason">
<xsl:value-of select="//fpml:swbReplacementReason"/>
</xsl:variable>
<xsl:if test="$swbReplacementReason = 'IndexTransitionReplacedByTrade'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** IndexTransitionReplacedByTrade is not a valid value for Replacement Reason in this context.</text>
</error>
</xsl:if>
<xsl:variable name="swbVenueIdScheme">
<xsl:value-of select="fpml:swbVenueId/@swbVenueIdScheme"/>
</xsl:variable>
<xsl:if test="$swbVenueIdScheme != 'http://www.fpml.org/coding-scheme/external/cftc/interim-compliant-identifier' and
$swbVenueIdScheme != 'http://www.fpml.org/coding-scheme/external/iso17442' and
$swbVenueIdScheme != ''">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid swbVenueIdScheme.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:swbRecipient">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:swbRecipient">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:variable name="id">
<xsl:value-of select="./@id"/>
</xsl:variable>
<xsl:if test="contains($id,' ')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid swbRecipient/@id value. Space characters are not allowed. Value = '<xsl:value-of select="$id"/>'.</text>
</error>
</xsl:if>
<xsl:if test="string-length($id) &gt; 40">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid swbRecipient/@id string length. Exceeded max length of 40 characters.</text>
</error>
</xsl:if>
<xsl:variable name="href">
<xsl:value-of select="fpml:partyReference/@href"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$href='partyA'"/>
<xsl:when test="$href='partyB'"/>
<xsl:when test="$href='partyC'"/>
<xsl:when test="$href='partyD'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid partyReference/@href value. Value = '<xsl:value-of select="$href"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
<xsl:if test="fpml:swbUserName[.='']">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Empty swbUserName.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:swbGiveUp">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="hrefC">
<xsl:value-of select="fpml:swbCustomerTransaction/fpml:swbCustomer/@href"/>
</xsl:variable>
<xsl:variable name="hrefD">
<xsl:value-of select="fpml:swbInterDealerTransaction/fpml:swbExecutingDealer/@href"/>
</xsl:variable>
<xsl:variable name="hrefCPB">
<xsl:value-of select="fpml:swbCustomerTransaction/fpml:swbPrimeBroker/@href"/>
</xsl:variable>
<xsl:variable name="hrefDPB">
<xsl:value-of select="fpml:swbInterDealerTransaction/fpml:swbPrimeBroker/@href"/>
</xsl:variable>
<xsl:variable name="hrefG">
<xsl:value-of select="fpml:swbExecutingDealerCustomerTransaction/fpml:swbExecutingDealer/@href"/>
</xsl:variable>
<xsl:if test="$hrefD != 'partyA'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***  Invalid party reference specified for Executing Dealer. Expecting 'partyA'. Value = '<xsl:value-of select="$hrefD"/>'.***.</text>
</error>
</xsl:if>
<xsl:if test="$hrefC != 'partyB'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***  Invalid party reference specified for Customer. Expecting 'partyB'. Value = '<xsl:value-of select="$hrefC"/>'.***.</text>
</error>
</xsl:if>
<xsl:if test="not($productType='SingleCurrencyInterestRateSwap' or $productType='OIS' or $productType='Single Currency Basis Swap' or $productType='FRA' or $productType='Fixed Fixed Swap') and ($isPrimeBrokerTrade='1')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***  Broker submission of prime brokered trades is only supported for IRS, OIS, FRA and Single Currency Basis Swap  products***.</text>
</error>
</xsl:if>
<xsl:if test="$hrefG=$hrefD">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbExecutingDealerCustomerTransaction/swbExecutingDealer/@href and swbInterDealerTransaction/swbExecutingDealer/@href values must not be the same.</text>
</error>
</xsl:if>
<xsl:if test="$hrefG=$hrefC">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbExecutingDealerCustomerTransaction/swbExecutingDealer/@href and swbCustomerTransaction/swbCustomer/@href values must not be the same.</text>
</error>
</xsl:if>
<xsl:if test="$hrefG=$hrefCPB">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbExecutingDealerCustomerTransaction/swbExecutingDealer/@href and swbCustomerTransaction/swbPrimeBroker/@href values must not be the same.</text>
</error>
</xsl:if>
<xsl:if test="$hrefG=$hrefDPB">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbExecutingDealerCustomerTransaction/swbExecutingDealer/@href and swbInterDealerTransaction/swbPrimeBroker/@href values must not be the same.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swbExecutingDealerCustomerTransaction">
<xsl:if test="not(//fpml:FpML/fpml:party[@id=$hrefG])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbExecutingDealerCustomerTransaction/swbExecutingDealer/@href does not reference a valid FpML/trade/party/@id. Value = '<xsl:value-of select="$hrefG"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$hrefC=$hrefD">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbCustomerTransaction/swbCustomer/@href and swbInterDealerTransaction/swbExecutingDealer/@href values must not be the same.</text>
</error>
</xsl:if>
<xsl:if test="$hrefC=$hrefCPB">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbCustomerTransaction/swbCustomer/@href and swbCustomerTransaction/swbPrimeBroker/@href values must not be the same.</text>
</error>
</xsl:if>
<xsl:if test="$hrefD=$hrefCPB">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbInterDealerTransaction/swbExecutingDealer/@href and swbCustomerTransaction/swbPrimeBroker/@href values must not be the same.</text>
</error>
</xsl:if>
<xsl:if test="$hrefD=$hrefDPB">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbInterDealerTransaction/swbExecutingDealer/@href and swbInterDealerTransaction/swbPrimeBroker/@href values must not be the same.</text>
</error>
</xsl:if>
<xsl:if test="$hrefC=$hrefDPB">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbCustomerTransaction/swbCustomer/@href and swbInterDealerTransaction/swbPrimeBroker/@href values must not be the same.</text>
</error>
</xsl:if>
<xsl:if test="not(//fpml:FpML/fpml:party[@id=$hrefC])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbCustomerTransaction/swbCustomer/@href does not reference a valid FpML/trade/party/@id. Value = '<xsl:value-of select="$hrefC"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not(//fpml:FpML/fpml:party[@id=$hrefCPB])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbCustomerTransaction/swbPrimeBroker/@href does not reference a valid FpML/trade/party/@id. Value = '<xsl:value-of select="$hrefCPB"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not(//fpml:FpML/fpml:party[@id=$hrefD])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbInterDealerTransaction/swbExecutingDealer/@href does not reference a valid FpML/trade/party/@id. Value = '<xsl:value-of select="$hrefD"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not(//fpml:FpML/fpml:party[@id=$hrefDPB])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbInterDealerTransaction/swbPrimeBroker/@href does not reference a valid /FpML/trade/party/@id. Value = '<xsl:value-of select="$hrefDPB"/>'.</text>
</error>
</xsl:if>
<xsl:if test="$productType = 'OIS' or $productType = 'SingleCurrencyInterestRateSwap' or $productType='Single Currency Basis Swap' or $productType='Fixed Fixed Swap'">
<xsl:if test="($hrefD != //fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:payerPartyReference/@href) and ($hrefD != //fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:receiverPartyReference/@href)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbInterDealerTransaction/swbExecutingDealer/@href must be a payer or receiver on swap if product type is 'SingleCurrencyInterestRateSwap', 'OIS' or 'Single Currency Basis Swap'.</text>
</error>
</xsl:if>
<xsl:if test="($hrefC != //fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:receiverPartyReference/@href) and ($hrefC != //fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:payerPartyReference/@href)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbCustomerTransaction/swbCustomer/@href must be a payer or receiver on swap if product type is 'SingleCurrencyInterestRateSwap', 'OIS' or 'Single Currency Basis Swap'.</text>
</error>
</xsl:if>
<xsl:if test="($hrefC != //fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$fixedLeg2]/fpml:receiverPartyReference/@href) and ($hrefC != //fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$fixedLeg2]/fpml:payerPartyReference/@href)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbCustomerTransaction/swbCustomer/@href must be a payer or receiver on swap if product type is 'SingleCurrencyInterestRateSwap', 'OIS' or 'Single Currency Basis Swap'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$productType = 'SingleCurrencyInterestRateSwap' or $productType='Single Currency Basis Swap' or $productType = 'OIS'">
<xsl:if test=".//fpml:swEarlyTerminationProvision">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** ./swEarlyTerminationProvision must not be specified in a Primary Prime Brokered Trade.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:swbAllocations">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="($isAllocatedTrade='1') and ($isEmptyBlockTrade='1')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Validation 1 BROKEN: Message contains tags that are mutually exclusive: swbBlockTrade and swbAllocations. Please revise and resubmit***.</text>
</error>
</xsl:if>
<xsl:if test="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbTradeHeader/fpml:swbPartyClearingBroker and /fpml:SWBML/fpml:swbAllocations/fpml:swbAllocation/fpml:swbPartyClearingBroker">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Both Allocated CB and Block CB should not be present at the same time***.</text>
</error>
</xsl:if>
<xsl:if test="($isAllocatedTrade='1') and /fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbTradeHeader/fpml:swbPartyClearingBroker">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Block CB should not be present on an Allocated trade***.</text>
</error>
</xsl:if>
<xsl:if test="not($productType='SingleCurrencyInterestRateSwap' or
$productType='OIS' or
$productType='Single Currency Basis Swap' or
$productType='Cross Currency Basis Swap' or
$productType='Cross Currency IRS' or
$productType='Fixed Fixed Swap' or
$productType='FRA' or
$productType='Swaption' or
$productType='ZC Inflation Swap') and ($isAllocatedTrade='1')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***  Broker submission of allocated trades is not supported for this product type.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:swbAllocation">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:swbAllocation">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]
</xsl:variable>
<xsl:variable name="reportingAllocationData.rtf">
<xsl:apply-templates select="fpml:swbAllocationReportingDetails/node()" mode="mapReportingData"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$productType = 'Single Currency Basis Swap' or $productType = 'Cross Currency Basis Swap'">
<xsl:if test="fpml:swbStreamReference and not(fpml:swbStreamReference/@href='floatingLeg')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbStreamReference must reference first floating leg ***</text>
</error>
</xsl:if>
</xsl:when>
<xsl:otherwise>
<xsl:if test="fpml:swbStreamReference and not(fpml:swbStreamReference/@href='fixedLeg')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbStreamReference must reference fixed leg ***</text>
</error>
</xsl:if>
</xsl:otherwise>
</xsl:choose>
<xsl:if test="$productType = 'OIS' or $productType = 'SingleCurrencyInterestRateSwap' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType = 'Fixed Fixed Swap'">
<xsl:if test="not(fpml:swbStreamReference)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbStreamReference must be present if product type is 'SingleCurrencyInterestRateSwap', OIS or Single Currency Basis Swap.</text>
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
<text>*** Validation 4a BROKEN: fpml:payerPartyReference/@href and receiverPartyReference/@href values must not be the same.</text>
</error>
</xsl:if>
<xsl:if test="not(//fpml:FpML/fpml:party[@id=$payerPartyRef])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Validation 4b BROKEN: fpml:payerPartyReference/@href does not reference a valid FpML/trade/party/@id. Value = '<xsl:value-of select="$payerPartyRef"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not(//fpml:FpML/fpml:party[@id=$receiverPartyRef])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Validation 4c BROKEN: receiverPartyReference/@href does not reference a valid FpML/trade/party/@id. Value = '<xsl:value-of select="$receiverPartyRef"/>'.</text>
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
<text>*** Validation 4d BROKEN: partyId (legal entity) referenced by payerPartyReference/@href must not equal partyId (legal entity) referenced by receiverPartyReference/@href.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swbPartyNettingString[2]">
<xsl:variable name="NettingParty">
<xsl:value-of select="fpml:swbPartyNettingString[1]/fpml:partyReference/@href"/>
</xsl:variable>
<xsl:variable name="NettingParty2">
<xsl:value-of select="fpml:swbPartyNettingString[2]/fpml:partyReference/@href"/>
</xsl:variable>
<xsl:if test="$NettingParty = $NettingParty2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Duplicate Allocation partyReference/@href for nettng String is not allowed.</text>
</error>
</xsl:if>
<xsl:if test="($NettingParty != $payerPartyRef) and ($NettingParty != $receiverPartyRef)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Allocation partyReference/@href for nettng String does not reference the Payer / Receiver party reference.</text>
</error>
</xsl:if>
<xsl:if test="($NettingParty2 != $payerPartyRef) and ($NettingParty2 != $receiverPartyRef)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Allocation partyReference/@href for nettng String does not reference the Payer / Receiver party reference.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:swbPartyCreditAcceptanceToken[2]">
<xsl:variable name="CreditAcceptanceParty">
<xsl:value-of select="fpml:swbPartyCreditAcceptanceToken[1]/fpml:partyReference/@href"/>
</xsl:variable>
<xsl:variable name="CreditAcceptanceParty2">
<xsl:value-of select="fpml:swbPartyCreditAcceptanceToken[2]/fpml:partyReference/@href"/>
</xsl:variable>
<xsl:if test="$CreditAcceptanceParty = $CreditAcceptanceParty2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Duplicate Allocation partyReference/@href for credit acceptance token is not allowed.</text>
</error>
</xsl:if>
<xsl:if test="($CreditAcceptanceParty != $payerPartyRef) and ($CreditAcceptanceParty != $receiverPartyRef)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Allocation partyReference/@href for credit acceptance token does not reference the Buyer / Seller party reference.</text>
</error>
</xsl:if>
<xsl:if test="($CreditAcceptanceParty2 != $payerPartyRef) and ($CreditAcceptanceParty2 != $receiverPartyRef)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Allocation partyReference/@href for credit acceptance token does not reference the Buyer / Seller party reference.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:allocatedNotional">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:swbAllocatedContraNotional">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:swbVariableAmount">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
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
</xsl:if>
<xsl:if test="$productType = 'FRA' or $productType = 'Swaption'">
<xsl:if test="not(fpml:buyerPartyReference)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***buyerPartyReference must be present if product type is 'FRA' or 'Swaption'.</text>
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
<xsl:if test="fpml:swbPartyNettingString[2]">
<xsl:variable name="NettingParty">
<xsl:value-of select="fpml:swbPartyNettingString[1]/fpml:partyReference/@href"/>
</xsl:variable>
<xsl:variable name="NettingParty2">
<xsl:value-of select="fpml:swbPartyNettingString[2]/fpml:partyReference/@href"/>
</xsl:variable>
<xsl:if test="$NettingParty = $NettingParty2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Duplicate Allocation partyReference/@href for nettng String is not allowed.</text>
</error>
</xsl:if>
<xsl:if test="($NettingParty != $buyerPartyRef) and ($NettingParty != $sellerPartyRef)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Allocation partyReference/@href for nettng String does not reference the Buyer / Seller party reference.</text>
</error>
</xsl:if>
<xsl:if test="($NettingParty2 != $buyerPartyRef) and ($NettingParty2 != $sellerPartyRef)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Allocation partyReference/@href for nettng String does not reference the Buyer / Seller party reference.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:swbPartyCreditAcceptanceToken[2]">
<xsl:variable name="CreditAcceptanceParty">
<xsl:value-of select="fpml:swbPartyCreditAcceptanceToken[1]/fpml:partyReference/@href"/>
</xsl:variable>
<xsl:variable name="CreditAcceptanceParty2">
<xsl:value-of select="fpml:swbPartyCreditAcceptanceToken[2]/fpml:partyReference/@href"/>
</xsl:variable>
<xsl:if test="$CreditAcceptanceParty = $CreditAcceptanceParty2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Duplicate Allocation partyReference/@href for credit acceptance token is not allowed.</text>
</error>
</xsl:if>
<xsl:if test="($CreditAcceptanceParty != $buyerPartyRef) and ($CreditAcceptanceParty != $sellerPartyRef)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Allocation partyReference/@href for credit acceptance token does not reference the Buyer / Seller party reference.</text>
</error>
</xsl:if>
<xsl:if test="($CreditAcceptanceParty2 != $buyerPartyRef) and ($CreditAcceptanceParty2 != $sellerPartyRef)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Allocation partyReference/@href for credit acceptance token does not reference the Buyer / Seller party reference.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:allocatedNotional">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
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
</xsl:if>
<xsl:variable name="messageText">
<xsl:value-of select="fpml:swbBrokerTradeId"/>
</xsl:variable>
<xsl:if test="string-length($messageText) &gt; 200">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid swbBrokerTradeId string length. Exceeded max length of 200 characters.</text>
</error>
</xsl:if>
<xsl:choose>
<xsl:when test="function-available('common:node-set')">
<xsl:call-template name="swbAllocationReportingDetails">
<xsl:with-param name="reportingAllocationData" select="common:node-set($reportingAllocationData.rtf)"/>
</xsl:call-template>
</xsl:when>
<xsl:otherwise>
<xsl:call-template name="swbAllocationReportingDetails">
<xsl:with-param name="reportingAllocationData" select="$reportingAllocationData.rtf"/>
</xsl:call-template>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template match="fpml:allocatedNotional">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="allocatedNotionalCurrency">
<xsl:value-of select="fpml:currency"/>
</xsl:variable>
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
<xsl:if test="$allocatedNotionalCurrency != $tradeCurrency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Validation 6 BROKEN: allocatedNotional/currency must be the same as the block notional currency within an allocated trade. Value = '<xsl:value-of select="$allocatedNotionalCurrency"/>'.</text>
</error>
</xsl:if>
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
<xsl:template match="fpml:swbAllocatedContraNotional">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="$MarkToMarket='true' and ($productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='Fixed Fixed Swap')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbAllocatedContraNotional should not be present if product type is 'Cross Currency Basis Swap' or 'Cross Currency IRS' or 'Fixed Fixed Swap' and MarkToMarket is True.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:swbVariableAmount">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="$MarkToMarket!='true' and ($productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='Fixed Fixed Swap')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbVariableAmount should not be present if product type is 'Cross Currency Basis Swap' or 'Cross Currency IRS' and MarkToMarket is False.</text>
</error>
</xsl:if>
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
<text>*** Validation 9a BROKEN: payerPartyReference/@href and receiverPartyReference/@href values must not be the same.</text>
</error>
</xsl:if>
<xsl:if test="$payerPartyRef!=$allocPartyA and $payerPartyRef!=$allocPartyB">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Validation 9b BROKEN: payerPartyReference/@href must reference one of the parties to the allocation.</text>
</error>
</xsl:if>
<xsl:if test="$receiverPartyRef!=$allocPartyA and $receiverPartyRef!=$allocPartyB">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Validation 9c BROKEN: receiverPartyReference/@href must reference one of the parties to the allocation.</text>
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
<xsl:apply-templates select="fpml:paymentAmount">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:paymentAmount">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="IA_paymentCurrency">
<xsl:value-of select="fpml:currency"/>
</xsl:variable>
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
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">3999999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:template>
<xsl:template match="fpml:swbStructuredTradeDetails">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:call-template name="isValidProductType">
<xsl:with-param name="elementName">swbProductType</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swbProductType"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="not(fpml:swbExtendedTradeDetails)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swbExtendedTradeDetails.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:FpML">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:swbExtendedTradeDetails">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:swbBusinessConductDetails">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:swbTradePackageHeader">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
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
<xsl:apply-templates select="fpml:trade">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="$isAllocatedTrade=0 and $isPrimeBrokerTrade=0">
<xsl:if test="(not(count(fpml:party)=3 or count(fpml:party)=4))">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of party child elements encountered. 3 or 4 expected.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$isAllocatedTrade=1 or $isPrimeBrokerTrade=1">
<xsl:if test="not(count(fpml:party) &gt;2)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of party child elements encountered. 3 or more expected.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:party">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:trade">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="count(otherPartyPayment) &gt; 2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of otherPartyPayment child elements encountered. 0 to 2 expected.</text>
</error>
</xsl:if>
<xsl:if test="fpml:otherPartyPayment[2]">
<xsl:variable name="href1">
<xsl:value-of select="fpml:otherPartyPayment[1]/fpml:payerPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="href2">
<xsl:value-of select="fpml:otherPartyPayment[2]/fpml:payerPartyReference/@href"/>
</xsl:variable>
<xsl:if test="$href1=$href2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** otherPartyPayment[1]/payerPartyReference/@href and otherPartyPayment[2]/payerPartyReference/@href must not be the same.</text>
</error>
</xsl:if>
</xsl:if>
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
<xsl:apply-templates select="fpml:otherPartyPayment">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:calculationAgent">
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
<xsl:template match="fpml:swbExtendedTradeDetails">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="fpml:swbTradeHeader/fpml:swbOriginatingEvent">
<xsl:choose>
<xsl:when test="fpml:swbTradeHeader/fpml:swbOriginatingEvent=''"/>
<xsl:when test="fpml:swbTradeHeader/fpml:swbOriginatingEvent='Bunched Order Block'"/>
<xsl:when test="fpml:swbTradeHeader/fpml:swbOriginatingEvent='Bunched Order Allocation'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***swOriginatingEvent element value is not supported. Supported values are '', 'Bunched Order Block', 'Bunched Order Allocation'. Value = '<xsl:value-of select="fpml:swbTradeHeader/fpml:swbOriginatingEvent"/>'."/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="count(fpml:swbTradeHeader/fpml:swbClientFund)='2'">
<xsl:for-each select="fpml:swbTradeHeader/fpml:swbClientFund" >
<xsl:if test="not (fpml:partyReference)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***When two swbClientFund tags are provided, a partyReference tag must be added to link swbClientFund to a Party .</text>
</error>
</xsl:if>
</xsl:for-each>
</xsl:if>
<xsl:apply-templates select="node()/fpml:swbMandatoryClearing">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:swbTradeHeader/fpml:swbClientClearing='true' and $isPrimeBrokerTrade='0' and $isHarmonisedTrade='0'">
<xsl:if test="not(fpml:swbTradeHeader//fpml:swbExecutingBroker)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing Executing Broker href element for a bilateral client clearing deal.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:swbTradeHeader/fpml:swbClearingClient)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing Clearing Client href element for a bilateral client clearing deal.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:swbTradeHeader/fpml:swbPartyNettingString">
<xsl:variable name="NettingParty">
<xsl:value-of select="fpml:swbTradeHeader/fpml:swbPartyNettingString/fpml:partyReference/@href"/>
</xsl:variable>
<xsl:if test="not(//fpml:FpML/fpml:party[@id=$NettingParty])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** partyReference/@href for nettng String does not reference a valid FpML/party/@id.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:swbTradeHeader/fpml:swbPartyCreditAcceptanceToken">
<xsl:variable name="CreditAcceptanceParty">
<xsl:value-of select="fpml:swbTradeHeader/fpml:swbPartyCreditAcceptanceToken/fpml:partyReference/@href"/>
</xsl:variable>
<xsl:if test="not(//fpml:FpML/fpml:party[@id=$CreditAcceptanceParty])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** partyReference/@href for credit acceptance token does not reference a valid FpML//party/@id.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:swbTradeHeader/fpml:swbDisplayPartyLegalEntity">
<xsl:if test="not(count(fpml:swbTradeHeader/fpml:swbDisplayPartyLegalEntity)=0 or  count(fpml:swbTradeHeader/fpml:swbDisplayPartyLegalEntity)=1)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>Clearing anonymity can be specified for only one side on the trade.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:swbTradeHeader/fpml:swbClearedPhysicalSettlement">
<xsl:choose>
<xsl:when test="not($productType='Swaption')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbClearedPhysicalSettlement should only be present if product type is 'Swaption'.</text>
</error>
</xsl:when>
<xsl:when test="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:swaption/fpml:cashSettlement">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbClearedPhysicalSettlement should not be present when cash settlement method specified.</text>
</error>
</xsl:when>
<xsl:when test="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:contractualDefinitions='ISDA2000'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbClearedPhysicalSettlement is not valid under stated swbContractualDefinitions.  Value = '<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:contractualDefinitions"/>'.</text>
</error>
</xsl:when>
<xsl:when test="fpml:swbTradeHeader/fpml:swbClearedPhysicalSettlement !='true'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbClearedPhysicalSettlement must be set to 'true' if present.  Value = '<xsl:value-of select="fpml:swbTradeHeader/fpml:swbClearedPhysicalSettlement"/>'.</text>
</error>
</xsl:when>
</xsl:choose>
</xsl:if>
<xsl:if test="fpml:swbTradeHeader/fpml:swbPredeterminedClearerForUnderlyingSwap">
<xsl:if test="not($productType='Swaption')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbPredeterminedClearerForUnderlyingSwap should only be present if product type is 'Swaption'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:swbTradeHeader/fpml:swbPricedToClearCCP">
<xsl:if test="not($productType='Swaption' or $productType='OIS' or $productType='FRA' or $productType='ZC Inflation Swap' or $productType='Fixed Fixed Swap' or $productType='SingleCurrencyInterestRateSwap' or $productType='Single Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='Cross Currency Basis Swap')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbPricedToClearCCP is not valid for product type '<xsl:value-of select="$productType"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:swbAgreedDiscountRate">
<xsl:if test="not($productType='Swaption')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbAgreedDiscountRate is not valid for product type '<xsl:value-of select="$productType"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="not(fpml:swbProductTerm) and not($productType='FRA')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swbProductTerm.</text>
</error>
</xsl:if>
<xsl:if test="$productType='FRA'">
<xsl:if test="fpml:swbProductTerm">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbProductTerm must not be present if product type is 'FRA'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:swbProductTerm">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:variable name="packageDetailsA.rtf">
<xsl:apply-templates select="fpml:swbPackageDetails[@href='partyA']/node()" mode="mapReportingData"/>
</xsl:variable>
<xsl:variable name="packageDetailsB.rtf">
<xsl:apply-templates select="fpml:swbPackageDetails[@href='partyB']/node()" mode="mapReportingData"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="function-available('common:node-set')">
<xsl:call-template name="swbPackageDetails">
<xsl:with-param name="packageDetails" select="common:node-set($packageDetailsA.rtf)"/>
</xsl:call-template>
<xsl:call-template name="swbPackageDetails">
<xsl:with-param name="packageDetails" select="common:node-set($packageDetailsB.rtf)"/>
</xsl:call-template>
</xsl:when>
<xsl:otherwise>
<xsl:call-template name="swbPackageDetails">
<xsl:with-param name="packageDetails" select="$packageDetailsA.rtf"/>
</xsl:call-template>
<xsl:call-template name="swbPackageDetails">
<xsl:with-param name="packageDetails" select="$packageDetailsB.rtf"/>
</xsl:call-template>
</xsl:otherwise>
</xsl:choose>
<xsl:if test="fpml:swbMessageText">
<xsl:if test="fpml:swbMessageText=''">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Empty swbMessageText.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:variable name="messageText">
<xsl:value-of select="fpml:swbMessageText"/>
</xsl:variable>
<xsl:if test="string-length($messageText) &gt; 200">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid swbMessageText string length. Exceeded max length of 200 characters.</text>
</error>
</xsl:if>
<xsl:if test="$productType='FRA'">
<xsl:if test="fpml:swbStubPosition">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbStubPosition must not be present if product type is 'FRA'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:choose>
<xsl:when test="fpml:swbFrontAndBackStubs">
<xsl:if test="not($productType = 'SingleCurrencyInterestRateSwap' or $productType = 'OIS' or $productType = 'Fixed Fixed Swap')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbFrontAndBackStubs should only be present if product type is 'SingleCurrencyInterestRateSwap', 'OIS' or 'Fixed Fixed Swap'. Value = '<xsl:value-of select="$productType"/>' .</text>
</error>
</xsl:if>
<xsl:if test="fpml:swbStubPosition='End'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbStubPosition must be 'Start' if front and back stubs apply.</text>
</error>
</xsl:if>
</xsl:when>
<xsl:otherwise>
<xsl:choose>
<xsl:when test="fpml:swbStubPosition='End'">
<xsl:if test="(/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream/fpml:stubCalculationPeriodAmount/fpml:initialStub or /fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:capFloor/fpml:capFloorStream/fpml:stubCalculationPeriodAmount/fpml:initialStub)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbStubPosition value of 'End' is inconsistent with presence of floating leg /stubCalculationPeriodAmount/initialStub element</text>
</error>
</xsl:if>
</xsl:when>
<xsl:otherwise>
<xsl:if test= "(/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream/fpml:stubCalculationPeriodAmount/fpml:finalStub or /fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:capFloor/fpml:capFloorStream/fpml:stubCalculationPeriodAmount/fpml:finalStub) and fpml:swbStubPosition = 'Start'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbStubPosition value of '<xsl:value-of select="fpml:swbStubPosition"/>' is inconsistent with presence of floating leg /stubCalculationPeriodAmount/finalStub element</text>
</error>
</xsl:if>
</xsl:otherwise>
</xsl:choose>
</xsl:otherwise>
</xsl:choose>
<xsl:if test="fpml:swbNoStubLinearInterpolation and (/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[@id='floatingLeg']/fpml:stubCalculationPeriodAmount or /fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[@id='floatingLeg2']/fpml:stubCalculationPeriodAmount or  /fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:capFloor/fpml:capFloorStream[@id='floatingLeg']/fpml:stubCalculationPeriodAmount)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbNoStubLinearInterpolation element and floating leg /stubCalculationPeriodAmount element cannot both be present.</text>
</error>
</xsl:if>
<xsl:if test="$productType='FRA'">
<xsl:if test="fpml:swbStubLength">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbStubLength must not be present if product type is 'FRA' or 'CapFloor'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:swbStubLength">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="count(fpml:swbStubLength)=2">
<xsl:variable name="href1">
<xsl:value-of select="fpml:swbStubLength[1]/@href"/>
</xsl:variable>
<xsl:variable name="href2">
<xsl:value-of select="fpml:swbStubLength[2]/@href"/>
</xsl:variable>
<xsl:if test="$href1=$href2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbStubLength[1]/@href and swbStubLength[2]/@href values must not be the same.</text>
</error>
</xsl:if>
<xsl:if test="$productType='CapFloor'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** A maximum of 1 swbStubLength value can be specified if product type is 'CapFloor'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:swbFrontAndBackStubs/fpml:swbNoStubLinearInterpolation and (/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[@id='floatingLeg']/fpml:stubCalculationPeriodAmount/fpml:finalStub or /fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[@id='floatingLeg2']/fpml:stubCalculationPeriodAmount/fpml:finalStub or /fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:capFloor/fpml:capFloorStream[@id='floatingLeg']/fpml:stubCalculationPeriodAmount/fpml:finalStub)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbFrontAndBackStubs/swbNoStubLinearInterpolation element and floating leg /stubCalculationPeriodAmount element cannot both be present.</text>
</error>
</xsl:if>
<xsl:if test="$productType='FRA'">
<xsl:if test="fpml:swbEarlyTerminationProvision">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbEarlyTerminationProvision must not be present if product type is  'FRA'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:swbEarlyTerminationProvision">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="$productType='FRA' or $productType='CapFloor' or $productType='Swaption' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='Fixed Fixed Swap'">
<xsl:if test="fpml:swbAssociatedBonds">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbAssociatedBonds must not be present if product type is 'FRA', 'CapFloor', 'Swaption',  'Single Currency Basis Swap' or 'Cross Currency Basis Swap' or 'Cross Currency IRS'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:swbAssociatedBonds">
<xsl:if test="not($tradeCurrency = 'USD' or $tradeCurrency = 'CAD')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbAssociatedBonds should only be present if trade currency is equal to 'USD' or 'CAD'. Value = '<xsl:value-of select="$tradeCurrency"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:swbAssociatedBonds">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:swbAssociatedFuture">
<xsl:if test="not($productType='SingleCurrencyInterestRateSwap' or $productType='OIS' or $productType='Fixed Fixed Swap')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbAssociatedFuture should only be present if product type is 'SingleCurrencyInterestRateSwap', 'OIS' or 'Fixed Fixed Swap'. Value = '<xsl:value-of select="$productType"/>' .</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:swbAssociatedFuture">
<xsl:if test="not($tradeCurrency = 'EUR' or $tradeCurrency = 'CHF' or $tradeCurrency = 'GBP' or $tradeCurrency = 'AUD' or $tradeCurrency = 'NZD')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbAssociatedFuture should only be present if trade currency is equal to 'EUR' or 'CHF' or 'GBP' or 'AUD' or 'NZD'. Value = '<xsl:value-of select="$tradeCurrency"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:choose>
<xsl:when test="count(fpml:swbAssociatedFuture[@href='partyA']) &gt; 2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** No more than two swbAssociatedFuture child elements allowed per party. 'partyA' has <xsl:value-of select="count(fpml:swbAssociatedFuture[@href='partyA'])"/>.</text>
</error>
</xsl:when>
<xsl:when test="count(fpml:swbAssociatedFuture[@href='partyB']) &gt; 2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** No more than two swbAssociatedFuture child elements allowed per party. 'partyB' has <xsl:value-of select="count(fpml:swbAssociatedFuture[@href='partyB'])"/>.</text>
</error>
</xsl:when>
</xsl:choose>
<xsl:apply-templates select="fpml:swbAssociatedFuture">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:swbFutureValue">
<xsl:if test="not($productType='SingleCurrencyInterestRateSwap' and $tradeCurrency='BRL')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbFutureValue should only be present if product type is 'IRS' and currency is 'BRL''. Values are '<xsl:value-of select="$productType"/>', '<xsl:value-of select="$tradeCurrency"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:swbSettlementProvision">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:swbFutureValue">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:swbFxCutoffTime">
<xsl:if test="not($productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='Fixed Fixed Swap')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbFxCutoffTime should only be present if product type is 'Cross Currency Basis Swap' or 'Cross Currency IRS' or 'Fixed Fixed Swap'.</text>
</error>
</xsl:if>
<xsl:if test="$MarkToMarket!='true' and ($productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='Fixed Fixed Swap')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbFxCutoffTime should only be present if product type is 'Cross Currency Basis Swap' or 'Cross Currency IRS' and MarkToMarket is True.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:swbFxCutoffTime">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:swbCollateralizedCashPrice">
<xsl:choose>
<xsl:when test="not($productType='Swaption')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbCollateralizedCashPrice should only be present if product type is 'Swaption'.</text>
</error>
</xsl:when>
<xsl:when test="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:contractualDefinitions='ISDA2000'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbCollateralizedCashPrice is not valid under stated swbContractualDefinitions.  Value = '<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:contractualDefinitions"/>'.</text>
</error>
</xsl:when>
<xsl:when test="((/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbCollateralizedCashPrice) and (/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:swaption/fpml:cashSettlement[fpml:cashPriceMethod | fpml:cashPriceAlternateMethod | fpml:parYieldCurveUnadjustedMethod | fpml:zeroCouponYieldAdjustedMethod]))">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Only one swaption cash settlement method can be specified. If swbCollateralizedCashPrice is present then neither cashPriceMethod, cashPriceAlternateMethod, parYieldCurveUnadjustedMethod or zeroCouponYieldAdjustedMethod can be present within ../FpML/trade/swaption/cashSettlement</text>
</error>
</xsl:when>
<xsl:otherwise>
<xsl:apply-templates select="fpml:swbCollateralizedCashPrice">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="/fpml:SWBML/fpml:swbStructuredTradeDetails//fpml:swbExtendedTradeDetails/fpml:swbTradeHeader/fpml:swbMandatoryClearing/fpml:swbMandatoryClearingIndicator">
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">swbMandatoryClearingIndicator</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails//fpml:swbExtendedTradeDetails/fpml:swbTradeHeader/fpml:swbMandatoryClearing/fpml:swbMandatoryClearingIndicator"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="/fpml:SWBML/fpml:swbStructuredTradeDetails//fpml:swbExtendedTradeDetails/fpml:swbTradeHeader/fpml:swbMandatoryClearing/fpml:swbMandatoryClearingIndicator">
<xsl:variable name="Jurisdiciton">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails//fpml:swbExtendedTradeDetails/fpml:swbTradeHeader/fpml:swbMandatoryClearing/fpml:swbJurisdiction"/>
</xsl:variable>
<xsl:if test="$Jurisdiciton=''">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** You must provide a Jurisdiction (swbMandatoryClearing/swbJurisdiction) when specifying a value in swbMandatoryClearing/swbMandatoryClearingIndicator</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="/fpml:SWBML/fpml:swbStructuredTradeDetails//fpml:swbExtendedTradeDetails/fpml:swbTradeHeader/fpml:swbMandatoryClearing/fpml:swbJurisdiction">
<xsl:variable name="Jurisdiciton">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails//fpml:swbExtendedTradeDetails/fpml:swbTradeHeader/fpml:swbMandatoryClearing/fpml:swbJurisdiction"/>
</xsl:variable>
<xsl:if test="$Jurisdiciton='JFSA'">
<xsl:variable name="MandatoryClearingIndicator">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails//fpml:swbExtendedTradeDetails/fpml:swbTradeHeader/fpml:swbMandatoryClearing/fpml:swbMandatoryClearingIndicator"/>
</xsl:variable>
<xsl:if test="$productType='SingleCurrencyInterestRateSwap'">
<xsl:variable name="floatingRateIndex">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails//fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:floatingRateIndex"/>
</xsl:variable>
<xsl:variable name="FloatingRollFreq">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails//fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:periodMultiplier"/>
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails//fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:period"/>
</xsl:variable>
<xsl:if test="($MandatoryClearingIndicator='true' or $MandatoryClearingIndicator='false') and $productType='SingleCurrencyInterestRateSwap'">
<xsl:if test="not($productType='SingleCurrencyInterestRateSwap' and $tradeCurrency='JPY' and ($floatingRateIndex='JPY-LIBOR-BBA' or $floatingRateIndex='JPY-TIBOR-ZTIBOR' or  $floatingRateIndex='JPY-ZTIBOR' or  $floatingRateIndex='JPY-LIBOR') and ($FloatingRollFreq='3M' or $FloatingRollFreq='6M') )">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** For JFSA, swbMandatoryClearingIndicator can only be set for an IRS (Single Currency Interest Rate Swap) where the trade currency is JPY, Floating Rate Index is JPY-LIBOR-BBA or JPY-LIBOR or JPY-ZTIBOR or  JPY-TIBOR-ZTIBOR and the Floating Roll Frequency is either 3M or 6M</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
<xsl:if test="$productType='Single Currency Basis Swap'">
<xsl:variable name="floatingRateIndex1">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails//fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:floatingRateIndex"/>
</xsl:variable>
<xsl:variable name="floatingRateIndex2">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails//fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$floatingLeg2]/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:floatingRateIndex"/>
</xsl:variable>
<xsl:variable name="DesignatedMaturity1">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails//fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:indexTenor/fpml:periodMultiplier"/>
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails//fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:indexTenor/fpml:period"/>
</xsl:variable>
<xsl:variable name="DesignatedMaturity2">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails//fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$floatingLeg2]/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:indexTenor/fpml:periodMultiplier"/>
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails//fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$floatingLeg2]/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:indexTenor/fpml:period"/>
</xsl:variable>
<xsl:if test="($MandatoryClearingIndicator='true' or $MandatoryClearingIndicator='false') and $productType='Single Currency Basis Swap'">
<xsl:if test="not($productType='Single Currency Basis Swap' and $tradeCurrency='JPY' and (($floatingRateIndex1='JPY-LIBOR-BBA' or $floatingRateIndex1='JPY-LIBOR')   and $floatingRateIndex2='JPY-LIBOR-BBA' or $floatingRateIndex2='JPY-LIBOR' or $floatingRateIndex1='JPY-TIBOR-ZTIBOR' or $floatingRateIndex1='JPY-ZTIBOR' or $floatingRateIndex2='JPY-TIBOR-ZTIBOR' or $floatingRateIndex2='JPY-ZTIBOR') and ($DesignatedMaturity1='3M' or $DesignatedMaturity1='6M') and ($DesignatedMaturity2='3M' or $DesignatedMaturity2='6M'))">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** For JFSA, swbMandatoryClearingIndicator can only be set for a Single Currency Basis Swap where the trade currency is JPY, Floating Rate Index 1 is JPY-LIBOR-BBA or JPY-TIBOR-ZTIBOR for ISDA2006 or JPY-LIBOR or  JPY-ZTIBOR for ISDA2021, Floating Rate Index 2 is  JPY-LIBOR-BBA or JPY-TIBOR-ZTIBOR for ISDA2006 or JPY-LIBOR or  JPY-ZTIBOR for ISDA2021, Designated Maturity 1 is either 3M or 6M and Designated Maturity 2 is either 3M or 6M</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
</xsl:if>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:swbSettlementProvision">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="not(fpml:swbSettlementCurrency = 'USD')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbSettlementCurrency must be equal to 'USD'. Value = '<xsl:value-of select="fpml:swbSettlementCurrency"/>'.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:swbNonDeliverableSettlement">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:swbNonDeliverableSettlement">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:call-template name="isValidNonDeliverableCurrency">
<xsl:with-param name="elementName">swbReferenceCurrency</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swbReferenceCurrency"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="$tradeCurrency != fpml:swbReferenceCurrency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbReferenceCurrency value of '<xsl:value-of select="fpml:swbReferenceCurrency"/>' must equal Trade Currency of '<xsl:value-of select="$tradeCurrency"/>'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swbFxFixingSchedule and fpml:swReferenceCurrency!='BRL'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swFxFixingSchedule must not be given when swReferenceCurrency value is not 'BRL'.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:swbFxFixingSchedule">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:swbFxFixingSchedule">
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
<xsl:template match="fpml:swbNotionalFutureValue">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="href">
<xsl:value-of select="@href"/>
</xsl:variable>
<xsl:variable name="id">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$fixedLeg]/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/@id"/>
</xsl:variable>
<xsl:if test="($href!=$id)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid swbNotionalFutureValue/@href value. Value is not equal to ../calculationPeriodAmount/calculation/notionalSchedule/@id. Value of href = '<xsl:value-of select="$href"/>' and id value is '<xsl:value-of select="$id"/>'.</text>
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
<text>*** swbNotionalFutureValue/currency must be the same as the trade currency. Value = '<xsl:value-of select="$notionalFutureValueCurrency"/>'.</text>
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
<xsl:template match="fpml:swbFutureValue">
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
<xsl:apply-templates select="fpml:swbNotionalFutureValue">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:swbFxCutoffTime">
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
<xsl:template match="fpml:swbCollateralizedCashPrice">
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
<xsl:template match="fpml:swbProductTerm">
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
<xsl:if test="$period='W'">
<xsl:variable name="periodMultiplier">
<xsl:value-of select="fpml:periodMultiplier"/>
</xsl:variable>
<xsl:call-template name="isValidIntegerNumber">
<xsl:with-param name="elementName">periodMultiplier</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$periodMultiplier"/>
</xsl:with-param>
<xsl:with-param name="minIncl">1</xsl:with-param>
<xsl:with-param name="maxIncl">3</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="$period='M'">
<xsl:variable name="periodMultiplier">
<xsl:value-of select="fpml:periodMultiplier"/>
</xsl:variable>
<xsl:call-template name="isValidIntegerNumber">
<xsl:with-param name="elementName">periodMultiplier</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$periodMultiplier"/>
</xsl:with-param>
<xsl:with-param name="minIncl">1</xsl:with-param>
<xsl:with-param name="maxIncl">11999</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="$period='Y'">
<xsl:variable name="periodMultiplier">
<xsl:value-of select="fpml:periodMultiplier"/>
</xsl:variable>
<xsl:call-template name="isValidIntegerNumber">
<xsl:with-param name="elementName">periodMultiplier</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$periodMultiplier"/>
</xsl:with-param>
<xsl:with-param name="minIncl">1</xsl:with-param>
<xsl:with-param name="maxIncl">999</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:swbEarlyTerminationProvision">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:apply-templates select="fpml:swbMandatoryEarlyTerminationDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:swbOptionalEarlyTermination">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:swbMandatoryEarlyTerminationDate">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="period">
<xsl:value-of select="fpml:period"/>
</xsl:variable>
<xsl:if test="not($period='Y') and not($period='M') and not($period='D')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** period must be equal to 'Y' or 'M' or 'D'. Value = '<xsl:value-of select="$period"/>'</text>
</error>
</xsl:if>
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
<text>*** swbMandatoryEarlyTerminationDate must be equal to  1D, 6M, 1Y, 2Y, 3Y, 4Y, 5Y, 6Y, 7Y, 8Y, 9Y, 10Y, 11Y, 12Y, 15Y, 20Y, 25Y or 30Y. Value = '<xsl:value-of select="$freq"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
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
<xsl:template match="fpml:swbOptionalEarlyTermination">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/ <xsl:value-of select="local-name()"/></xsl:variable>
<xsl:apply-templates select="fpml:swbOptionalEarlyTerminationDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:swbOptionalEarlyTerminationFrequency">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:swbCashSettlementMethod">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="not($productType='SingleCurrencyInterestRateSwap' or $productType='Single Currency Basis Swap' or $productType='OIS' or $productType='Swaption' or $productType='CapFloor' or $productType='ZC Inflation Swap' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='Fixed Fixed Swap')">
<xsl:if test="fpml:swbExerciseBusinessCenters">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected element swbExerciseBusinessCenters encountered.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swbEarliestExerciseTime">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected element swbEarliestExerciseTime encountered.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swbExpirationTime">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected element swbExpirationTime encountered.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swbValuationTime">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected element swbValuationTime encountered.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swbTimeBusinessCenter">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected element swbTimeBusinessCenter encountered.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swbCalculationAgent">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected element swbCalculationAgent encountered.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swbCashSettlementMethod">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected element swbCashSettlementMethod encountered.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:swbCalculationAgent/fpml:calculationAgentPartyReference">
<xsl:variable name="href1">
<xsl:value-of select="fpml:swbCalculationAgent/fpml:calculationAgentPartyReference[1]/@href"/>
</xsl:variable>
<xsl:variable name="href2">
<xsl:value-of select="fpml:swbCalculationAgent/fpml:calculationAgentPartyReference[2]/@href"/>
</xsl:variable>
<xsl:if test="$href1=$href2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbCalculationAgent/calculationAgentPartyReference[1]/@href swbCalculationAgent/calculationAgentPartyReference[2]/@hrefvalues must not be the same.</text>
</error>
</xsl:if>
<xsl:apply-templates select="./fpml:swbCalculationAgent/fpml:calculationAgentPartyReference">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
<xsl:if test="fpml:swbExerciseBusinessCenters">
<xsl:call-template name="isValidBusinessCenter">
<xsl:with-param name="elementName">businessCenter</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="./fpml:swbExerciseBusinessCenters/fpml:businessCenter"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="assetClass">
<xsl:value-of select="$assetClass"/>
</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swbTimeBusinessCenter">
<xsl:call-template name="isValidBusinessCenter">
<xsl:with-param name="elementName">businessCenter</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="./fpml:swbTimeBusinessCenter"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="assetClass">
<xsl:value-of select="$assetClass"/>
</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:swbOptionalEarlyTerminationDate">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/ <xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="period">
<xsl:value-of select="fpml:period"/>
</xsl:variable>
<xsl:if test="not($period='Y') and not($period='M') and not($period='D')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** period must be equal to 'Y' or 'M' or 'D'. Value = '<xsl:value-of select="$period"/>'</text>
</error>
</xsl:if>
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
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbOptionalEarlyTerminationDate must be equal to 1D, 6M, 1Y, 2Y, 3Y, 4Y, 5Y, 6Y, 7Y, 8Y, 9Y, 10Y, 11Y, 12Y, 15Y, 20Y, 25Y or 30Y. Value = '<xsl:value-of select="$freq"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template match="fpml:swbOptionalEarlyTerminationFrequency">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/ <xsl:value-of select="local-name()"/></xsl:variable>
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
<text>*** swbOptionalEarlyTerminationFrequency must be equal to 1D, 1M, 3M, 6M, 1Y, 2Y, 3Y, 4Y, 5Y, 6Y, 7Y, 8Y, 9Y or 10Y. Value = '<xsl:value-of select="$freq"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template match="fpml:swbCashSettlementMethod">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="$productType='Single Currency Basis Swap' and .= 'Zero Coupon Yield - Adjusted'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid value of swbCashSettlementMethod. Value = '<xsl:value-of select="."/>' in case of Basis Swap.</text>
</error>
</xsl:if>
<xsl:if test="not($productType='Cross Currency Basis Swap' or $productType='Fixed Fixed Swap' or $productType='Cross Currency IRS') and .= 'Cross Currency Method'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid value of swbCashSettlementMethod. Value = '<xsl:value-of select="."/>' for non cross currency product.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:swbAssociatedBonds">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="fpml:swbExchangeBonds!='true'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbExchangeBonds must be equal to 'true'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swbNegotiatedSpreadRate">
<xsl:variable name="swbNegotiatedSpreadRate">
<xsl:value-of select="fpml:swbNegotiatedSpreadRate"/>
</xsl:variable>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swbNegotiatedSpreadRate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$swbNegotiatedSpreadRate"/>
</xsl:with-param>
<xsl:with-param name="minIncl">-0.0999999</xsl:with-param>
<xsl:with-param name="maxIncl">0.0999999</xsl:with-param>
<xsl:with-param name="maxDecs">7</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:apply-templates select="fpml:swbBondDetails">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:swbAssociatedFuture">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:variable name="href1">
<xsl:value-of select="./@href"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$href1='partyA'"/>
<xsl:when test="$href1='partyB'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid swbAssociatedFuture/@href value. Value = '<xsl:value-of select="$href1"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
<xsl:call-template name="isValidFuture">
<xsl:with-param name="elementName">swbFutureName</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swbFutureName"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="isValidIntegerNumber">
<xsl:with-param name="elementName">swbQuantity</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swbQuantity"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">999999999</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:choose>
<xsl:when test="$tradeCurrency = 'AUD' or $tradeCurrency = 'NZD'">
<xsl:if test="fpml:swbDescription =''">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***swbDescription cannot be empty when currency is AUD or NZD.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swbFutureName = 'Bill' and not(fpml:swbDescription[.='Mar' or .='Jun' or .='Sep' or .='Dec'])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***swbDescription must be either Mar, Jun, Sep or Dec when swbFutureName is Bill.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swbFutureName = 'Bond' and not(fpml:swbDescription[.='3 year' or .='5 year' or .='10 year'])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***swbDescription must be either 3 year or 5 year or 10 year when swbFutureName is Bond.</text>
</error>
</xsl:if>
</xsl:when>
<xsl:otherwise>
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">swbMaturity</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swbMaturity"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:otherwise>
</xsl:choose>
<xsl:choose>
<xsl:when test="fpml:swbFutureName = 'Schatz' or fpml:swbFutureName = 'Bobl' or fpml:swbFutureName = 'Bund' or fpml:swbFutureName = 'Buxl'">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swbPrice</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swbPrice"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.001</xsl:with-param>
<xsl:with-param name="maxIncl">999999999.999</xsl:with-param>
<xsl:with-param name="maxDecs">3</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:when>
<xsl:when test="$tradeCurrency = 'AUD' or $tradeCurrency = 'NZD'">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swbPrice</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swbPrice"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.001</xsl:with-param>
<xsl:with-param name="maxIncl">999999999.999</xsl:with-param>
<xsl:with-param name="maxDecs">3</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:when>
<xsl:otherwise>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swbPrice</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swbPrice"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.01</xsl:with-param>
<xsl:with-param name="maxIncl">999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template match="fpml:swbBondDetails">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:variable name="swbBondName">
<xsl:value-of select="fpml:swbBondName"/>
</xsl:variable>
<xsl:if test="$swbBondName =''">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Empty swbBondName.</text>
</error>
</xsl:if>
<xsl:if test="string-length($swbBondName) &gt; 40">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid swbBondName string length. Exceeded max length of 40 characters.</text>
</error>
</xsl:if>
<xsl:variable name="swbBondFaceAmount">
<xsl:value-of select="fpml:swbBondFaceAmount"/>
</xsl:variable>
<xsl:call-template name="isValidIntegerNumber">
<xsl:with-param name="elementName">swbBondFaceAmount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$swbBondFaceAmount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">1</xsl:with-param>
<xsl:with-param name="maxIncl">999999999999</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:variable name="swbPriceType">
<xsl:value-of select="fpml:swbPriceType"/>
</xsl:variable>
<xsl:if test="$tradeCurrency ='USD'">
<xsl:if test="$swbPriceType !='F128' and $swbPriceType !='F256' and $swbPriceType !='D5'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbPriceType must be equal to 'F128' or 'F256' or 'D5' if trade currency is equal to 'USD'. Value = '<xsl:value-of select="$swbPriceType"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$tradeCurrency ='CAD'">
<xsl:if test="$swbPriceType !='D5'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbPriceType must be equal to 'D5' if trade currency is equal to 'CAD'. Value = '<xsl:value-of select="$swbPriceType"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:variable name="swbBondPrice">
<xsl:value-of select="fpml:swbBondPrice"/>
</xsl:variable>
<xsl:if test="$swbPriceType='F128' or $swbPriceType='F256'">
<xsl:choose>
<xsl:when test="not($swbBondPrice='')">
<xsl:choose>
<xsl:when test="contains($swbBondPrice,'-')">
<xsl:call-template name="isValidIntegerNumber2">
<xsl:with-param name="elementName">swbBondPrice</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="substring-before($swbBondPrice,'-')"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">999</xsl:with-param>
<xsl:with-param name="maxDigits">3</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="isValid32nd">
<xsl:with-param name="elementName">swbBondPrice</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="substring(substring-after($swbBondPrice,'-'),1,2)"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="$swbPriceType = 'F128'">
<xsl:call-template name="isValid128th">
<xsl:with-param name="elementName">swbBondPrice</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="substring(substring-after($swbBondPrice,'-'),3)"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="$swbPriceType = 'F256'">
<xsl:call-template name="isValid256th">
<xsl:with-param name="elementName">swbBondPrice</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="substring(substring-after($swbBondPrice,'-'),3)"/>
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
<text>*** If swbPriceType is equal to 'F128' or 'F256' swbBondPrice must contain '-' fractional separator. Value = '<xsl:value-of select="$swbBondPrice"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Empty swbBondPrice.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="$swbPriceType='D5'">
<xsl:call-template name="isValidNumber2">
<xsl:with-param name="elementName">swbBondPrice</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$swbBondPrice"/>
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
<xsl:template match="fpml:tradeHeader">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="count(fpml:partyTradeIdentifier)!=2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of partyTradeIdentifier child elements encountered. Exactly 2 expected.</text>
</error>
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
<xsl:choose>
<xsl:when test="$href='partyA'"/>
<xsl:when test="$href='partyB'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid partyReference/@href value. Value = '<xsl:value-of select="$href"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
<xsl:variable name="tradeId">
<xsl:value-of select="fpml:tradeId"/>
</xsl:variable>
<xsl:if test="$tradeId=''">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Empty tradeId.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:product">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:apply-templates select="fpml:swap">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:fra">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:swap">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="($productType = 'SingleCurrencyInterestRateSwap' or $productType ='OIS') and $isZeroCouponInterestRateSwap = 'false'">
<xsl:variable name="dt1"><xsl:value-of select="fpml:swapStream[position()=$fixedLeg]/fpml:calculationPeriodDates/fpml:firstRegularPeriodStartDate"/></xsl:variable>
<xsl:variable name="dt2"><xsl:value-of select="fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodDates/fpml:firstRegularPeriodStartDate"/></xsl:variable>
<xsl:variable name="rollconv"><xsl:value-of select="fpml:swapStream[position()=$fixedLeg]/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:rollConvention"/></xsl:variable>
<xsl:if test="$dt1 != $dt2 and ($dt1 != '' and $dt2 != '') and starts-with($rollconv,'IMM') and $frontandbackstub='true'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** 1st Fixed Reg Period Start and 1st Float Reg Period Start must be same while using different IMM date from its original IMM start date.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$productType = 'Fixed Fixed Swap' and isZeroCouponFixedFixedSwap = 'false'">
<xsl:variable name="dt1"><xsl:value-of select="fpml:swapStream[position()=$fixedLeg]/fpml:calculationPeriodDates/fpml:firstRegularPeriodStartDate"/></xsl:variable>
<xsl:variable name="dt2"><xsl:value-of select="fpml:swapStream[position()=$fixedLeg2]/fpml:calculationPeriodDates/fpml:firstRegularPeriodStartDate"/></xsl:variable>
<xsl:variable name="rollconv"><xsl:value-of select="fpml:swapStream[position()=$fixedLeg]/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:rollConvention"/></xsl:variable>
<xsl:if test="($dt1 != $dt2 and $tradeCurrency = $tradeCurrency2) and starts-with($rollconv,'IMM') and $frontandbackstub='true'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** 1st Fixed Reg Period Start and 1st Fixed Reg Period Start 2 must be same while using different IMM date from its original IMM start date.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="not($productType='SingleCurrencyInterestRateSwap' or $productType='OIS' or $productType='Swaption' or $productType='ZC Inflation Swap' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='Fixed Fixed Swap')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** /SWBML/swbStructuredTradeDetails/swbProductType must be equal to 'SingleCurrencyInterestRateSwap', 'OIS' or 'Swaption', 'ZC Inflation Swap',  'Single Currency Basis Swap' or 'Cross Currency Basis Swap' or 'Cross Currency IRS' or 'Fixed Fixed Swap' if swap element is present.</text>
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
<xsl:if test="not($productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Fixed Fixed Swap')">
<xsl:if test="not(fpml:swapStream[@id='fixedLeg'])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** One swapStream must have a swapStream/@id attribute value of 'fixedLeg'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="not(fpml:swapStream[@id='floatingLeg']) and $productType!='Fixed Fixed Swap'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** One swapStream must have a swapStream/@id attribute value of 'floatingLeg'.</text>
</error>
</xsl:if>
<xsl:if test="($productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap')">
<xsl:if test="not(fpml:swapStream[@id='floatingLeg2'])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** One swapStream must have a swapStream/@id attribute value of 'floatingLeg2' when product type = 'Single Currency Basis Swap' or 'Cross Currency Basis Swap'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$productType='Fixed Fixed Swap'">
<xsl:if test="not(fpml:swapStream[@id='fixedLeg'])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** One swapStream must have a swapStream/@id attribute value of 'fixedLeg' when product type = 'Fixed Fixed Swap'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:choose>
<xsl:when test="($productType='SingleCurrencyInterestRateSwap' or $productType='OIS' or $productType='Swaption' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS')">
<xsl:if test="not(fpml:swapStream[@id='floatingLeg']/fpml:resetDates) and not(fpml:swapStream[@id='floatingLeg']/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:lookback or fpml:swapStream[@id='floatingLeg']/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:lockout or fpml:swapStream[@id='floatingLeg']/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:observationShift)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The floatingLeg swapStream is missing the resetDates element.</text>
</error>
</xsl:if>
</xsl:when>
<xsl:when test="($productType='ZC Inflation Swap')">
<xsl:if test="(fpml:swapStream[@id='floatingLeg']/fpml:resetDates)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The floatingLeg swapStream should not contain the resetDates element for 'ZC Inflation Swap'.</text>
</error>
</xsl:if>
</xsl:when>
</xsl:choose>
<xsl:choose>
<xsl:when test="($productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap')">
<xsl:if test="not(fpml:swapStream[@id='floatingLeg2']/fpml:resetDates) and not(fpml:swapStream[@id='floatingLeg2']/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:lookback or fpml:swapStream[@id='floatingLeg2']/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:lockout or fpml:swapStream[@id='floatingLeg2']/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:observationShift)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The 'floatingLeg2' swapStream is missing the resetDates element.</text>
</error>
</xsl:if>
</xsl:when>
</xsl:choose>
<xsl:if test="not($productType='ZC Inflation Swap' or $productType='Fixed Fixed Swap')">
<xsl:if test="not(fpml:swapStream[@id='floatingLeg']/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The floatingLeg swapStream is missing calculationPeriodAmount/calculation/floatingRateCalculation element.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="($productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap')">
<xsl:if test="not(fpml:swapStream[@id='floatingLeg2']/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The floatingLeg2 swapStream is missing calculationPeriodAmount/calculation/floatingRateCalculation element.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="($productType='ZC Inflation Swap')">
<xsl:if test="not(fpml:swapStream[@id='floatingLeg']/fpml:calculationPeriodAmount/fpml:calculation/fpml:inflationRateCalculation)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The floating swapStream of an ZC Inflation Swap is missing the calculationPeriodAmount/calculation/inflationRateCalculation element.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="($productType='OIS' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS') and $isCompoundingEnabledIndex='false'">
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
<xsl:if test= "fpml:swapStream[@id='floatingLeg']/fpml:resetDates/fpml:fixingDates and ($productType='OIS' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS')">
<xsl:if test="fpml:swapStream[@id='floatingLeg']/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:lookback or fpml:swapStream[@id='floatingLeg']/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:lockout or fpml:swapStream[@id='floatingLeg']/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:observationShift">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected Fixing Days child element encountered. Not allowed for lookback,lockout or observationShift method.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test= "fpml:swapStream[@id='floatingLeg2']/fpml:resetDates/fpml:fixingDates and ($productType='OIS' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap')">
<xsl:if test="fpml:swapStream[@id='floatingLeg2']/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:lookback or fpml:swapStream[@id='floatingLeg2']/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:lockout or fpml:swapStream[@id='floatingLeg2']/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:observationShift">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected Fixing Days child element encountered. Not allowed for lookback,lockout or observationShift method.</text>
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
<xsl:if test="$interestRateSwapType != 'zeroCouponInterestRateSwapWithFixedAmount' and not($productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Fixed Fixed Swap' or $productType = 'OIS' or $productType = 'ZC Inflation Swap')">
<xsl:if test="not(fpml:swapStream[@id='fixedLeg']/fpml:calculationPeriodAmount/fpml:calculation/fpml:fixedRateSchedule)">
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
<xsl:variable name="effectiveDate1">
<xsl:value-of select="fpml:swapStream[position()=1]/fpml:calculationPeriodDates/fpml:effectiveDate/fpml:unadjustedDate"/>
</xsl:variable>
<xsl:variable name="effectiveDate2">
<xsl:value-of select="fpml:swapStream[position()=2]/fpml:calculationPeriodDates/fpml:effectiveDate/fpml:unadjustedDate"/>
</xsl:variable>
<xsl:if test="not ($productType='SingleCurrencyInterestRateSwap' or $productType='OIS' or $productType='Single Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='Fixed Fixed Swap' or ($productType='ZC Inflation Swap' and //fpml:couponRate))">
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
<text>*** swapStream[1] and swapStream[2] terminationDate do not match.</text>
</error>
</xsl:if>
<xsl:variable name="rollConvention1">
<xsl:value-of select="fpml:swapStream[position()=1]/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:rollConvention"/>
</xsl:variable>
<xsl:variable name="rollConvention2">
<xsl:value-of select="fpml:swapStream[position()=2]/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:rollConvention"/>
</xsl:variable>
<xsl:if test="(($isZeroCouponInterestRateSwap != 'true') and ($productType!='Single Currency Basis Swap') and ($productType!='Cross Currency Basis Swap') and ($productType!='Cross Currency IRS') and ($productType!='Fixed Fixed Swap'))">
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
<xsl:if test="(($productType!='SingleCurrencyInterestRateSwap') and ($productType!='Cross Currency Basis Swap') and ($productType!='Cross Currency IRS') and ($productType!='Fixed Fixed Swap') and ($productType!='OIS') and ($productType!='ZC Inflation Swap'))">
<xsl:if test="$notional1!= $notional2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swapStream[1] and swapStream[2] notional do not match.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:variable name="notional">
<xsl:value-of select="fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:initialValue"/>
</xsl:variable>
<xsl:variable name="fixedAmount">
<xsl:value-of select="fpml:swapStream[position()=$fixedLeg]/fpml:calculationPeriodAmount/fpml:knownAmountSchedule/fpml:initialValue"/>
</xsl:variable>
<xsl:if test="($interestRateSwapType = 'zeroCouponInterestRateSwapWithFixedAmount')">
<xsl:if test="$notional= $fixedAmount">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** fixedLeg fixed amount and floatingLeg notional match.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:variable name="currency1">
<xsl:value-of select="fpml:swapStream[position()=1]/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:currency"/>
</xsl:variable>
<xsl:variable name="currency2">
<xsl:value-of select="fpml:swapStream[position()=2]/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:currency"/>
</xsl:variable>
<xsl:if test="($interestRateSwapType != 'zeroCouponInterestRateSwapWithFixedAmount' and $productType!='Cross Currency Basis Swap' and $productType!='Cross Currency IRS' and $productType!='Fixed Fixed Swap' and        $productType!='OIS' and $productType!='ZC Inflation Swap')">
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
<xsl:if test="$tradeCurrency != $floatingRateIndexCurrency and $floatingRateIndex != 'CNH-HIBOR-TMA' and $floatingRateIndex != 'CNH-HIBOR' and not ($tradeCurrency = 'EUR' and ($floatingRateIndex = 'REPOFUNDS RATE-FRANCE-OIS-COMPOUND' or $floatingRateIndex = 'REPOFUNDS RATE-GERMANY-OIS-COMPOUND' or $floatingRateIndex = 'REPOFUNDS RATE-ITALY-OIS-COMPOUND'))">
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
<xsl:variable name="floatingRateIndex">
<xsl:value-of select="fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:floatingRateIndex"/>
</xsl:variable>
<xsl:if test="$tradeCurrency2 != $floatingRateIndexCurrency and $floatingRateIndex != 'CNH-HIBOR-TMA' and $floatingRateIndex != 'CNH-HIBOR' and not ($tradeCurrency2 = 'EUR' and ($floatingRateIndex = 'REPOFUNDS RATE-FRANCE-OIS-COMPOUND' or $floatingRateIndex = 'REPOFUNDS RATE-GERMANY-OIS-COMPOUND' or $floatingRateIndex = 'REPOFUNDS RATE-ITALY-OIS-COMPOUND'))">
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
<xsl:if test="$productType='Cross Currency IRS' or $productType='SingleCurrencyInterestRateSwap'">
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
<xsl:if test="($productType!='Single Currency Basis Swap' and $productType!='Cross Currency Basis Swap' and $productType!='Cross Currency IRS' and $productType!='Fixed Fixed Swap' and $productType!='OIS')">
<xsl:if test="$paymentLag1!= $paymentLag2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swapStream[1] and swapStream[2] paymentDaysOffset do not match.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:variable name="busCenters5">
<xsl:for-each select="fpml:swapStream[position()=1]/fpml:paymentDates/fpml:paymentDatesAdjustments/fpml:businessCenters/fpml:businessCenter">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:variable>
<xsl:variable name="busCenters6">
<xsl:for-each select="fpml:swapStream[position()=2]/fpml:paymentDates/fpml:paymentDatesAdjustments/fpml:businessCenters/fpml:businessCenter">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:variable>
<xsl:if test="not($productType='Single Currency Basis Swap' or $productType='OIS' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='SingleCurrencyInterestRateSwap' or $productType='Fixed Fixed Swap' or $productType='OIS')">
<xsl:if test="$busCenters5!= $busCenters6">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swapStream[1] and swapStream[2] paymentDates/paymentDatesAdjustments/businessCenters do not match.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:variable name="fixedAdjustment">
<xsl:value-of select="fpml:swapStream[@id='fixedLeg']/fpml:calculationPeriodDates/fpml:calculationPeriodDatesAdjustments/fpml:businessDayConvention"/>
</xsl:variable>
<xsl:if test="$fixedAdjustment != 'NONE'">
<xsl:variable name="busCenters7">
<xsl:for-each select="fpml:swapStream[position()=1]/fpml:calculationPeriodDates/fpml:calculationPeriodDatesAdjustments/fpml:businessCenters/fpml:businessCenter">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:variable>
<xsl:variable name="busCenters8">
<xsl:for-each select="fpml:swapStream[position()=2]/fpml:calculationPeriodDates/fpml:calculationPeriodDatesAdjustments/fpml:businessCenters/fpml:businessCenter">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:variable>
<xsl:if test="$busCenters7!= $busCenters8 and $productType!='Single Currency Basis Swap' and $productType!='Cross Currency Basis Swap' and $productType!='Cross Currency IRS' and $productType!='Fixed Fixed Swap' and fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodDatesAdjustments/fpml:businessDayConvention!='NONE' and fpml:swapStream[position()=$floatingLeg2]/fpml:calculationPeriodDatesAdjustments/fpml:businessDayConvention!='NONE'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swapStream[1] and swapStream[2] calculationPeriodDates/calculationPeriodDatesAdjustments/businessCenters do not match.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:variable name="periodMultiplier1">
<xsl:value-of select="fpml:swapStream[@id='floatingLeg']/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:periodMultiplier"/>
</xsl:variable>
<xsl:variable name="periodMultiplier2">
<xsl:value-of select="fpml:swapStream[@id='floatingLeg']/fpml:resetDates/fpml:resetFrequency/fpml:periodMultiplier"/>
</xsl:variable>
<xsl:variable name="periodMultiplier3">
<xsl:value-of select="fpml:swapStream[@id='floatingLeg']/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:indexTenor/fpml:periodMultiplier"/>
</xsl:variable>
<xsl:variable name="periodMultiplier6">
<xsl:value-of select="fpml:swapStream[@id='floatingLeg']/fpml:paymentDates/fpml:paymentFrequency/fpml:periodMultiplier"/>
</xsl:variable>
<xsl:variable name="periodMultiplier4">
<xsl:value-of select="fpml:swapStream[@id='fixedLeg']/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:periodMultiplier"/>
</xsl:variable>
<xsl:variable name="periodMultiplier5">
<xsl:value-of select="fpml:swapStream[@id='fixedLeg']/fpml:paymentDates/fpml:paymentFrequency/fpml:periodMultiplier"/>
</xsl:variable>
<xsl:variable name="period1">
<xsl:value-of select="fpml:swapStream[@id='floatingLeg']/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:period"/>
</xsl:variable>
<xsl:variable name="period2">
<xsl:value-of select="fpml:swapStream[@id='floatingLeg']/fpml:resetDates/fpml:resetFrequency/fpml:period"/>
</xsl:variable>
<xsl:variable name="period3">
<xsl:value-of select="fpml:swapStream[@id='floatingLeg']/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:indexTenor/fpml:period"/>
</xsl:variable>
<xsl:variable name="period6">
<xsl:value-of select="fpml:swapStream[@id='floatingLeg']/fpml:paymentDates/fpml:paymentFrequency/fpml:period"/>
</xsl:variable>
<xsl:variable name="period4">
<xsl:value-of select="fpml:swapStream[@id='fixedLeg']/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:period"/>
</xsl:variable>
<xsl:variable name="period5">
<xsl:value-of select="fpml:swapStream[@id='fixedLeg']/fpml:paymentDates/fpml:paymentFrequency/fpml:period"/>
</xsl:variable>
<xsl:if test="($productType='SingleCurrencyInterestRateSwap' or $productType='Swaption') and not($interestRateSwapFloatingLegType='zeroCouponInterestRateSwapFloatingLeg') and not ($tradeCurrency='CLP') and $isOISonSwaption='false'">
<xsl:if test="not(($periodMultiplier1 = $periodMultiplier2) and ($periodMultiplier1 = $periodMultiplier3))">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The floating swapStream calculationPeriodFrequency, resetFrequency and indexTenor do not match.</text>
</error>
</xsl:if>
<xsl:if test="not(($period1 = $period2) and ($period1 = $period3))">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The floating stream calculationPeriodFrequency, resetFrequency and indexTenor do not match.</text>
</error>
</xsl:if>
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
<xsl:if test="$productType='ZCInflationSwap' and not(//fpml:couponRate)">
<xsl:if test="not($periodMultiplier6 = $periodMultiplier5)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swapStream[1] and swapStream[2] paymentFrequency do not match. They must match if product type is 'ZC Inflation Swap'.</text>
</error>
</xsl:if>
<xsl:if test="not($period6 = $period5)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***  swapStream[1] and swapStream[2] paymentFrequency do not match. They must match if product type is 'ZC Inflation Swap'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="not($productType='ZC Inflation Swap')">
<xsl:if test="not($periodMultiplier4 = $periodMultiplier5)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The fixed swapStream calculationPeriodFrequency/periodMultiplier and paymentFrequency/periodMultiplier do not match.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="not($period4 = $period5)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The fixed swapStream calculationPeriodFrequency/period and paymentFrequency/period  do not match.</text>
</error>
</xsl:if>
<xsl:variable name="businessDayConvention1">
<xsl:value-of select="fpml:swapStream[@id='floatingLeg']/fpml:calculationPeriodDates/fpml:calculationPeriodDatesAdjustments/fpml:businessDayConvention"/>
</xsl:variable>
<xsl:variable name="businessDayConvention2">
<xsl:value-of select="fpml:swapStream[@id='floatingLeg']/fpml:paymentDates/fpml:paymentDatesAdjustments/fpml:businessDayConvention"/>
</xsl:variable>
<xsl:variable name="businessDayConvention3">
<xsl:value-of select="fpml:swapStream[@id='floatingLeg']/fpml:resetDates/fpml:resetDatesAdjustments/fpml:businessDayConvention"/>
</xsl:variable>
<xsl:if test="not($productType='ZC Inflation Swap')">
<xsl:choose>
<xsl:when test="($productType='OIS' or $isOISonSwaption='true') and $businessDayConvention3 != 'NONE' and not (fpml:swapStream[@id='floatingLeg']/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:lookback or fpml:swapStream[@id='floatingLeg']/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:lockout or fpml:swapStream[@id='floatingLeg']/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:observationShift)">
<xsl:if test="not($businessDayConvention2 = $businessDayConvention3)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The floating swapStream paymentDatesAdjustments/businessDayConvention and resetDatesAdjustments/businessDayConvention do not match.</text>
</error>
</xsl:if>
</xsl:when>
<xsl:when test="$businessDayConvention1 = 'NONE' and $tradeCurrency !='BRL'">
<xsl:if test="$businessDayConvention3 != 'NONE' and not(fpml:swapStream[@id='floatingLeg']/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:lookback or fpml:swapStream[@id='floatingLeg']/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:lockout or fpml:swapStream[@id='floatingLeg']/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:observationShift)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The floating swapStream calculationPeriodDatesAdjustments/businessDayConvention and resetDatesAdjustments/businessDayConvention do not match.</text>
</error>
</xsl:if>
</xsl:when>
<xsl:otherwise>
<xsl:if test="not(($businessDayConvention1 = $businessDayConvention2) and ($businessDayConvention1 = $businessDayConvention3)) and  ($tradeCurrency != 'BRL')  and not(fpml:swapStream[@id='floatingLeg']/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:lookback or fpml:swapStream[@id='floatingLeg']/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:lockout or fpml:swapStream[@id='floatingLeg']/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:calculationParameters/fpml:observationShift)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The floating swapStream calculationPeriodDatesAdjustments/businessDayConvention, paymentDatesAdjustments/businessDayConvention and resetDatesAdjustments/businessDayConvention do not match.</text>
</error>
</xsl:if>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:variable name="floatCalcPayFreqCombo">
<xsl:value-of select="fpml:swapStream[@id='floatingLeg']/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:periodMultiplier"/>
<xsl:value-of select="fpml:swapStream[@id='floatingLeg']/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:period"/>
<xsl:value-of select="fpml:swapStream[@id='floatingLeg']/fpml:paymentDates/fpml:paymentFrequency/fpml:periodMultiplier"/>
<xsl:value-of select="fpml:swapStream[@id='floatingLeg']/fpml:paymentDates/fpml:paymentFrequency/fpml:period"/>
</xsl:variable>
<xsl:if test="($productType='SingleCurrencyInterestRateSwap' or $productType='Swaption') and not($interestRateSwapFloatingLegType='zeroCouponInterestRateSwapFloatingLeg')">
<xsl:choose>
<xsl:when test="$tradeCurrency='CNY' and $floatCalcPayFreqCombo='1W1M'"/>
<xsl:when test="$tradeCurrency='CNY' and $floatCalcPayFreqCombo='1W3M'"/>
<xsl:when test="$tradeCurrency='CNY' and $floatCalcPayFreqCombo='1W6M'"/>
<xsl:when test="$tradeCurrency='CNY' and $floatCalcPayFreqCombo='1W1Y'"/>
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
<xsl:when test="$floatCalcPayFreqCombo='1W1T'"/>
<xsl:when test="$floatCalcPayFreqCombo='1T1T' and $tradeCurrency = 'CLP'"/>
<xsl:when test="$floatCalcPayFreqCombo='1T1T' and $isOISonSwaption='true'"/>
<xsl:when test="$tradeCurrency = 'BRL'">
<xsl:if test="$floatCalcPayFreqCombo!='1T1T'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The floating swapStream calculationPeriodDates/calculationPeriodFrequency and paymentDates/paymentFrequency combination is invalid for a product type of 'SingleCurrencyInterestRateSwap' of currency 'BRL'.</text>
</error>
</xsl:if>
</xsl:when>
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
<xsl:if test="$productType='ZC Inflation Swap' and not(//fpml:couponRate)">
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
<text>*** The floating swapStream calculationPeriodDates/calculationPeriodFrequency and paymentDates/paymentFrequency combination is invalid for a product type of 'ZC Inflation Swap'.</text>
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
<text>*** The floating swapStream calculationPeriodDates/calculationPeriodFrequency and paymentDates/paymentFrequency combination is invalid for a product type of 'Single Currency Basis Swap'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="$productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS'">
<xsl:choose>
<xsl:when test="$floatCalcPayFreqCombo='1T1T'"/>
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
<text>*** The <xsl:value-of select="$floatCalcPayFreqCombo"/> floating <xsl:value-of select="$tradeCurrency"/> swapStream calculationPeriodDates/calculationPeriodFrequency and paymentDates/paymentFrequency combination is invalid for a product type of 'Cross Currency Basis Swap' or 'Cross Currency IRS'.</text>
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
<xsl:if test="$productType='Single Currency Basis Swap'">
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
</xsl:if>
<xsl:if test="$productType='Cross Currency Basis Swap'">
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
<xsl:when test="$float2CalcPayFreqCombo='1W1M' and $tradeCurrency2='CNY'"/>
<xsl:when test="$float2CalcPayFreqCombo='1W3M' and $tradeCurrency2='CNY'"/>
<xsl:when test="$float2CalcPayFreqCombo='1W6M' and $tradeCurrency2='CNY'"/>
<xsl:when test="$float2CalcPayFreqCombo='1W1Y' and $tradeCurrency2='CNY'"/>
<xsl:when test="$float2CalcPayFreqCombo='1T1T'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The floatingLeg2 swapStream calculationPeriodDates/calculationPeriodFrequency and paymentDates/paymentFrequency combination is invalid for a product type of 'Cross Currency Basis Swap'. Value = '<xsl:value-of select="$float2CalcPayFreqCombo"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:if>
<xsl:variable name="floatCalcFreq">
<xsl:value-of select="fpml:swapStream[@id='floatingLeg']/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:periodMultiplier"/>
<xsl:value-of select="fpml:swapStream[@id='floatingLeg']/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:period"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$productType='Single Currency Basis Swap'">
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
</xsl:when>
<xsl:when test="$productType='CapFloor'or $productType='Swaption'">
<xsl:choose>
<xsl:when test="$floatCalcFreq='1W' and $tradeCurrency='CNY'"/>
<xsl:when test="$floatCalcFreq='28D'"/>
<xsl:when test="$floatCalcFreq='1M'"/>
<xsl:when test="$floatCalcFreq='3M'"/>
<xsl:when test="$floatCalcFreq='6M'"/>
<xsl:when test="$floatCalcFreq='1Y'"/>
<xsl:when test="$floatCalcFreq='1T' and $isOISonSwaption='true'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The floating swapStream calculationPeriodFrequency must be equal to 1T (OIS on Swaption), 28D, 1M, 3M, 6M or 1Y if product type is 'CapFloor' or 'Swaption'. Value = '<xsl:value-of select="$floatCalcFreq"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType='SingleCurrencyInterestRateSwap'">
<xsl:choose>
<xsl:when test="$floatCalcFreq='1W' and $tradeCurrency='CNY'"/>
<xsl:when test="$floatCalcFreq='28D'"/>
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
<text>*** The floating swapStream calculationPeriodFrequency must be equal to 28D, 1M, 3M, 6M, 1Y or 1T if product type is 'SingleCurrencyInterestRateSwap'. Value = '<xsl:value-of select="$floatCalcFreq"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS'">
<xsl:choose>
<xsl:when test="$floatCalcFreq='1T'"/>
<xsl:when test="$floatCalcFreq='28D'"/>
<xsl:when test="$floatCalcFreq='1M'"/>
<xsl:when test="$floatCalcFreq='3M'"/>
<xsl:when test="$floatCalcFreq='6M'"/>
<xsl:when test="$floatCalcFreq='1Y'"/>
<xsl:when test="$floatCalcFreq='1W' and $tradeCurrency='CNY'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The floating swapStream calculationPeriodFrequency must be equal to 28D, 1M, 3M, 6M or 1Y if product type is 'Cross Currency Basis Swap' or 'Cross Currency IRS'. Value = '<xsl:value-of select="$floatCalcFreq"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
</xsl:choose>
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
<xsl:when test="$floatCalcFreq2='1W' and $tradeCurrency2='CNY'"/>
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
<xsl:if test="$productType='SingleCurrencyInterestRateSwap' or $productType='CapFloor'or $productType='Swaption'">
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
<text>*** The fixed swapStream calculationPeriodFrequency must be equal to 28D, 1M, 3M, 6M or 1Y if product type is 'SingleCurrencyInterestRateSwap' (except Zero Coupon IRS), 'CapFloor' or 'Swaption'. Value = '<xsl:value-of select="$fixedCalcFreq"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="$productType='Cross Currency IRS'">
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
<text>*** The fixed swapStream calculationPeriodFrequency must be equal to 28D, 1M, 3M, 6M or 1Y if product type is 'Cross Currency IRS'. Value = '<xsl:value-of select="$fixedCalcFreq"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="$productType='ZC Inflation Swap' and not(//fpml:couponRate)">
<xsl:choose>
<xsl:when test="$fixedCalcFreq='1Y'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The fixed swapStream calculationPeriodFrequency must be equal to 1Y if product type is 'ZC Inflation Swap'. Value = '<xsl:value-of select="$fixedCalcFreq"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:when>
<xsl:when test="$isZeroCouponInterestRateSwap = 'true'">
<xsl:if test="$productType='SingleCurrencyInterestRateSwap' or $isOISonSwaption='true'">
<xsl:choose>
<xsl:when test="$fixedCalcFreq='1T'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The fixed swapStream calculationPeriodFrequency must be equal to 1T, if product type is 'SingleCurrencyInterestRateSwap' or 'Swaption' with OIS indices, and a Zero Coupon IRS / Swaption. Value = '<xsl:value-of select="$fixedCalcFreq"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:when>
</xsl:choose>
<xsl:variable name="floatPayFreq">
<xsl:value-of select="fpml:swapStream[@id='floatingLeg']/fpml:paymentDates/fpml:paymentFrequency/fpml:periodMultiplier"/>
<xsl:value-of select="fpml:swapStream[@id='floatingLeg']/fpml:paymentDates/fpml:paymentFrequency/fpml:period"/>
</xsl:variable>
<xsl:choose>
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
<xsl:when test="$productType='CapFloor'or $productType='Swaption'">
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
<text>*** The floating swapStream paymentFrequency must be equal to 1T (OIS on Swaption), 28D, 1M, 3M, 6M or 1Y if product type is 'CapFloor' or 'Swaption'. Value = '<xsl:value-of select="$floatPayFreq"/>'.</text>
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
<xsl:when test="$floatCalcFreq2='1T'"/>
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
<xsl:variable name="fixedPayFreq2">
<xsl:value-of select="fpml:swapStream[@id='fixedLeg2']/fpml:paymentDates/fpml:paymentFrequency/fpml:periodMultiplier"/>
<xsl:value-of select="fpml:swapStream[@id='fixedLeg2']/fpml:paymentDates/fpml:paymentFrequency/fpml:period"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$isZeroCouponInterestRateSwap != 'true'">
<xsl:if test="$productType='SingleCurrencyInterestRateSwap' or $productType='CapFloor' or $productType='Swaption' or $productType='Cross Currency IRS'">
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
<text>*** The fixed swapstream paymentFrequency must be equal to 28D, 1M, 3M, 6M or 1Y if product type is 'SingleCurrencyInterestRateSwap' (except Zero Coupon IRS), 'CapFloor' or 'Swaption' or 'Cross Currency IRS'. Value = '<xsl:value-of select="$fixedPayFreq"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:when>
<xsl:when test="$isZeroCouponInterestRateSwap = 'true'">
<xsl:if test="$productType='SingleCurrencyInterestRateSwap' or $productType='OIS' or $isOISonSwaption='true'">
<xsl:choose>
<xsl:when test="$fixedPayFreq='1T'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The fixed swapStream paymentFrequency must be equal to 1T, if product type is 'SingleCurrencyInterestRateSwap', 'OIS' or 'Swaption' with OIS indices, and a Zero Coupon IRS / OIS / Swaption. Value = '<xsl:value-of select="$fixedPayFreq"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:when>
</xsl:choose>
<xsl:variable name="rollConvention">
<xsl:value-of select="fpml:swapStream[@id='floatingLeg']/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:rollConvention"/>
</xsl:variable>
<xsl:if test="starts-with($rollConvention,'IMM') and $productType!='SingleCurrencyInterestRateSwap' and $productType!='Cross Currency IRS' and $productType!='OIS' and $productType!='Single Currency Basis Swap'">
<xsl:if test="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbStubPosition">
<xsl:variable name="stubPosition">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbStubPosition"/>
</xsl:variable>
<xsl:if test="not($stubPosition='Start')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** /SWBML/swbStructuredTradeDetails/swbExtendedTradeDetails/swbStubPosition, if present, must equal 'Start' for IMM rolls. Value = '<xsl:value-of select="$stubPosition"/>'.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
<xsl:if test="$productType='Cross Currency Basis Swap'" >
<xsl:if test="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:principalExchanges/fpml:intermediateExchange">
<xsl:if test = "$MarkToMarket!=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:principalExchanges/fpml:intermediateExchange">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Intermediate Exchange must have the same value as Mark-to-Market.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
<xsl:if test="$MarkToMarket='true'">
<xsl:choose>
<xsl:when test="$productType='Cross Currency IRS'">
<xsl:variable name="href">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[@id='floatingLeg']/fpml:calculationPeriodAmount/fpml:calculation/fpml:fxLinkedNotionalSchedule/fpml:constantNotionalScheduleReference/@href"/>
</xsl:variable>
<xsl:variable name="id">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[@id='fixedLeg']/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/@id"/>
</xsl:variable>
<xsl:if test="$href != $id">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid constantNotionalScheduleReference/@href value. Value is not equal to fpml:swapStream[@id='floatingLeg']/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/@id. Value of href = '<xsl:value-of select="$href"/>' and id = '<xsl:value-of select="$id"/>'.</text>
</error>
</xsl:if>
</xsl:when>
<xsl:when test="$productType='Fixed Fixed Swap'">
<xsl:variable name="href">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[@id='fixedLeg2']/fpml:calculationPeriodAmount/fpml:calculation/fpml:fxLinkedNotionalSchedule/fpml:constantNotionalScheduleReference/@href"/>
</xsl:variable>
<xsl:variable name="id">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[@id='fixedLeg']/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/@id"/>
</xsl:variable>
<xsl:if test="$href != $id">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid constantNotionalScheduleReference/@href value. Value is not equal to fpml:swapStream[@id='floatingLeg']/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/@id. Value of href = '<xsl:value-of select="$href"/>' and id = '<xsl:value-of select="$id"/>'.</text>
</error>
</xsl:if>
</xsl:when>
<xsl:otherwise>
<xsl:variable name="href">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[@id='floatingLeg2']/fpml:calculationPeriodAmount/fpml:calculation/fpml:fxLinkedNotionalSchedule/fpml:constantNotionalScheduleReference/@href"/>
</xsl:variable>
<xsl:variable name="id">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[@id='floatingLeg']/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/@id"/>
</xsl:variable>
<xsl:if test="$href != $id">
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
<xsl:if test="($productType='SingleCurrencyInterestRateSwap' or $productType='OIS') and //fpml:swbExtendedTradeDetails/fpml:swbFrontAndBackStubs">
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
<xsl:if test="$firstFixedRegularPeriodStartDate !='' and not($isZeroCouponInterestRateSwap) and number(substring($firstFixedRegularPeriodStartDate,9))!=number($rollConvention) and not(substring($firstFixedRegularPeriodStartDate,6,2) ='02' and number($rollConvention) &gt;=29)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Fixed leg calculationPeriodDates/firstRegularPeriodStartDate must fall on same day of month as rollConvention.  Value = '<xsl:value-of select="$firstFixedRegularPeriodStartDate"/>'.  RollConvention = '<xsl:value-of select="$rollConvention"/>'.</text>
</error>
</xsl:if>
<xsl:if test="$firstFloatRegularPeriodStartDate !='' and $interestRateSwapFloatingLegType='aNonZCIRSFloatingLeg' and number(substring($firstFloatRegularPeriodStartDate,9))!=number($rollConvention) and not(substring($firstFloatRegularPeriodStartDate,6,2) ='02' and number($rollConvention) &gt;=29)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Floating leg calculationPeriodDates/firstRegularPeriodStartDate must fall on same day of month as rollConvention.  Value = '<xsl:value-of select="$firstFloatRegularPeriodStartDate"/>'.  RollConvention = '<xsl:value-of select="$rollConvention"/>'.</text>
</error>
</xsl:if>
<xsl:if test="$firstFixedPaymentDate !='' and not($isZeroCouponInterestRateSwap) and number(substring($firstFixedPaymentDate,9))!=number($rollConvention)  and not(substring($firstFixedPaymentDate,6,2) ='02' and number($rollConvention) &gt;=29)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Fixed leg paymentDates/firstPaymentDate must fall on same day of month as rollConvention.  Value = '<xsl:value-of select="$firstFixedPaymentDate"/>'.  RollConvention = '<xsl:value-of select="$rollConvention"/>'.</text>
</error>
</xsl:if>
<xsl:if test="$firstFloatPaymentDate !='' and $interestRateSwapFloatingLegType='aNonZCIRSFloatingLeg' and number(substring($firstFloatPaymentDate,9))!=number($rollConvention)  and not(substring($firstFloatPaymentDate,6,2) ='02' and number($rollConvention) &gt;=29)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Floating leg paymentDates/firstPaymentDate must fall on same day of month as rollConvention.  Value = '<xsl:value-of select="$firstFloatPaymentDate"/>'.  RollConvention = '<xsl:value-of select="$rollConvention"/>'.</text>
</error>
</xsl:if>
</xsl:otherwise>
</xsl:choose>
<xsl:if test="fpml:swapStream/fpml:calculationPeriodDates/fpml:stubPeriodType">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** calculationPeriodDates/stubPeriodType must not be present for trades with both front and back stubs.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:swapStream">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:additionalTerms">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="additionalPayment">
<xsl:if test="not($productType='SingleCurrencyInterestRateSwap' or $productType='OIS'or $productType='ZC Inflation Swap' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='Fixed Fixed Swap' or $productType='FRA')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** additionalPayment is only allowed in this context if product type is 'SingleCurrencyInterestRateSwap', 'OIS',  'ZC Inflation Swap' or 'Single Currency Basis Swap' or 'Cross Currency Basis Swap' or 'Cross Currency IRS' or 'Fixed Fixed Swap' or 'FRA'.</text>
</error>
</xsl:if>
<xsl:if test="$version='1-0' or $version='2-0'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** additionalPayment is not allowed if SWBML version = "1-0" or "2-0".</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="count(fpml:additionalPayment[fpml:paymentType!='CancellablePremium']) &gt; 2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of additionalPayment child elements encountered. 0 to 2 expected with a reason other than 'CancellablePremium'.</text>
</error>
</xsl:if>
<xsl:if test="count(fpml:additionalPayment[fpml:paymentType='CancellablePremium']) &gt; 1">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of additionalPayment child elements encountered. 0 to 1 expected with a reason of 'CancellablePremium'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:additionalPayment[fpml:paymentType = 'Independent Amount']">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** AdditionalPayment\PaymentType "Independent Amount" is not supported in FpML 4-2. Please use Colateral section to enter Independent Amount."</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:additionalPayment">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:additionalTerms">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:variable name="instrumentId">
<xsl:value-of select="fpml:bondReference/fpml:bond/fpml:instrumentId"/>
</xsl:variable>
<xsl:if test="$productType='ZC Inflation Swap'">
<xsl:call-template name="isValidInflationAssetSwap">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="$productType='ZC Inflation Swap'">
<xsl:if test="string-length($instrumentId) &gt; 12">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid instrumentId string length. Exceeded max length of 12 characters for productType 'ZC Inflation Swap'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:variable name="conditionPrecedentBond">
<xsl:value-of select="fpml:bondReference/fpml:conditionPrecedentBond"/>
</xsl:variable>
<xsl:if test="$productType='ZC Inflation Swap'">
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
<xsl:template match="fpml:additionalPayment">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:variable name="href1">
<xsl:value-of select="fpml:payerPartyReference/@href"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$href1='partyA'"/>
<xsl:when test="$href1='partyB'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid payerPartyReference/@href value. Value = '<xsl:value-of select="$href1"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
<xsl:variable name="href2">
<xsl:value-of select="fpml:receiverPartyReference/@href"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$href2='partyA'"/>
<xsl:when test="$href2='partyB'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid receiverPartyReference/@href value. Value = '<xsl:value-of select="$href2"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
<xsl:if test="$href1=$href2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** payerPartyReference/@href and receiverPartyReference/@href values must not be the same.</text>
</error>
</xsl:if>
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
<xsl:with-param name="maxIncl">999999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="$productType='CapFloor'">
<xsl:if test="fpml:paymentAmount/fpml:currency!=../fpml:capFloorStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:currency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** paymentAmount/currency (premium currency) and ../capFloorStream/calculationPeriodAmount/calculation/notionalSchedule/notionalStepSchedule/currency (cap/floor currency) must be the same if product type is 'CapFloor'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$productType='CapFloor' and fpml:paymentDate/fpml:dateAdjustments[fpml:businessDayConvention!='FOLLOWING']">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** paymentDate/dateAdjustments/businessDayConvention must be equal to 'FOLLOWING' if product type is 'CapFloor'. Value = '<xsl:value-of select="fpml:paymentDate/fpml:dateAdjustments/fpml:businessDayConvention"/>'.</text>
</error>
</xsl:if>
<xsl:variable name="paymentType">
<xsl:value-of select="fpml:paymentType"/>
</xsl:variable>
<xsl:if test="string-length($paymentType) &gt; 40">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid paymentType string length. Exceeded max length of 40 characters.</text>
</error>
</xsl:if>
<xsl:variable name="paymentTypeDesc">
<xsl:value-of select="fpml:paymentType"/>
</xsl:variable>
<xsl:if test="not(fpml:paymentDate) and $paymentTypeDesc != 'Independent Amount'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing paymentDate. Required in this context unless paymentType equals 'Independent Amount'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:paymentDate and $paymentTypeDesc = 'Independent Amount'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected paymentDate. Not allowed if paymentType equals 'Independent Amount'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:paymentDate">
<xsl:variable name="tradeDate">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:tradeHeader/fpml:tradeDate"/>
</xsl:variable>
<xsl:variable name="trdDate">
<xsl:value-of select="number(concat(substring($tradeDate,1,4),substring($tradeDate,6,2),substring($tradeDate,9,2)))"/>
</xsl:variable>
<xsl:variable name="paymentDate">
<xsl:value-of select="fpml:paymentDate/fpml:unadjustedDate"/>
</xsl:variable>
<xsl:variable name="payDate">
<xsl:value-of select="number(concat(substring($paymentDate,1,4),substring($paymentDate,6,2),substring($paymentDate,9,2)))"/>
</xsl:variable>
<xsl:if test="$payDate &lt; $trdDate and not($productType='CapFloor' or $productType='Swaption')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The payment date (paymentDate/unadjustedDate) must be greater than or equal to the tradeDate.  Value = '<xsl:value-of select="fpml:paymentDate/fpml:unadjustedDate"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:paymentDate">
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
<text>*** /SWBML/swbStructuredTradeDetails/swbProductType must be equal to 'CapFloor' if capFloor element is present.</text>
</error>
</xsl:if>
<xsl:variable name="effectiveDate">
<xsl:value-of select="fpml:capFloorStream/fpml:calculationPeriodDates/fpml:effectiveDate/fpml:unadjustedDate"/>
</xsl:variable>
<xsl:variable name="tradeDate">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:tradeHeader/fpml:tradeDate"/>
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
<xsl:if test="count(fpml:additionalPayment) &gt; 2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of additionalPayment child elements encountered. 0 to 2 expected.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:capFloorStream">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:additionalPayment">
<xsl:variable name="optionBuyer">
<xsl:value-of select="fpml:capFloorStream/fpml:receiverPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="optionSeller">
<xsl:value-of select="fpml:capFloorStream/fpml:payerPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="premiumPayer">
<xsl:value-of select="fpml:premium/fpml:payerPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="premiumReceiver">
<xsl:value-of select="fpml:premium/fpml:receiverPartyReference/@href"/>
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
<xsl:if test="fpml:additionalPayment/fpml:paymentType='Premium'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** AdditionalPayment\PaymentType "Premium" is not supported in FpML 4-2. Please use Premium section to enter Premium information."</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:additionalPayment">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:premium">
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
<xsl:choose>
<xsl:when test="$href1='partyA'"/>
<xsl:when test="$href1='partyB'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid payerPartyReference/@href value. Value = '<xsl:value-of select="$href1"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
<xsl:variable name="href2">
<xsl:value-of select="fpml:receiverPartyReference/@href"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$href2='partyA'"/>
<xsl:when test="$href2='partyB'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid receiverPartyReference/@href value. Value = '<xsl:value-of select="$href2"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
<xsl:if test="$href1=$href2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** payerPartyReference/@href and receiverPartyReference/@href values must not be the same.</text>
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
<xsl:variable name="businessDayConvention1">
<xsl:value-of select="fpml:calculationPeriodDates/fpml:calculationPeriodDatesAdjustments/fpml:businessDayConvention"/>
</xsl:variable>
<xsl:variable name="businessDayConvention2">
<xsl:value-of select="fpml:paymentDates/fpml:paymentDatesAdjustments/fpml:businessDayConvention"/>
</xsl:variable>
<xsl:variable name="businessDayConvention3">
<xsl:choose>
<xsl:when test="$swbExtendedTradeDetails/fpml:swbCapFloorDetails/fpml:swbFloatingRateFixingDate/fpml:unadjustedDate = ''">
<xsl:value-of select="fpml:resetDates/fpml:resetDatesAdjustments/fpml:businessDayConvention"/>
</xsl:when>
<xsl:otherwise><xsl:value-of select="$businessDayConvention1"/></xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:choose>
<xsl:when test="$businessDayConvention1 !='NONE'">
<xsl:if test="not(($businessDayConvention1 = $businessDayConvention2) and ($businessDayConvention1 = $businessDayConvention3))">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The calculationPeriodDatesAdjustments/businessDayConvention, paymentDatesAdjustments/businessDayConvention and resetDatesAdjustments/businessDayConvention do not match.</text>
</error>
</xsl:if>
</xsl:when>
<xsl:when test="$businessDayConvention3 !='NONE'">
<xsl:if test="not($businessDayConvention2 = $businessDayConvention3)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The paymentDatesAdjustments/businessDayConvention and resetDatesAdjustments/businessDayConvention do not match.</text>
</error>
</xsl:if>
</xsl:when>
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
<xsl:if test="not(fpml:resetDates) and ($swbExtendedTradeDetails/fpml:swbCapFloorDetails/fpml:swbFloatingRateFixingDate/fpml:unadjustedDate = '')">
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
<xsl:apply-templates select="fpml:stubCalculationPeriodAmount">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:settlementProvision">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** settlementProvision should only be present if product type is 'SingleCurrencyInterestRateSwap' or 'OIS'. Value = '<xsl:value-of select="$productType"/>' .</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:swaption">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="not($productType='Swaption')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** /SWBML/swbStructuredTradeDetails/swbProductType must be equal to 'Swaption' if swaption element is present.</text>
</error>
</xsl:if>
<xsl:variable name="tradeDate">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:tradeHeader/fpml:tradeDate"/>
</xsl:variable>
<xsl:variable name="expirationDate">
<xsl:value-of select="fpml:europeanExercise/fpml:expirationDate/fpml:adjustableDate/fpml:unadjustedDate"/>
</xsl:variable>
<xsl:variable name="expDate">
<xsl:value-of select="number(concat(substring($expirationDate,1,4),substring($expirationDate,6,2),substring($expirationDate,9,2)))"/>
</xsl:variable>
<xsl:variable name="trdDate">
<xsl:value-of select="number(concat(substring($tradeDate,1,4),substring($tradeDate,6,2),substring($tradeDate,9,2)))"/>
</xsl:variable>
<xsl:if test="$trdDate &gt; $expDate">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The tradeDate must be less than or equal to the expirationDate.</text>
</error>
</xsl:if>
<xsl:variable name="href1">
<xsl:value-of select="fpml:buyerPartyReference/@href"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$href1='partyA'"/>
<xsl:when test="$href1='partyB'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid buyerPartyReference/@href value. Value = '<xsl:value-of select="$href1"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
<xsl:variable name="href2">
<xsl:value-of select="fpml:sellerPartyReference/@href"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$href2='partyA'"/>
<xsl:when test="$href2='partyB'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid sellerPartyReference/@href value. Value = '<xsl:value-of select="$href2"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
<xsl:if test="$href1=$href2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** buyerPartyReference/@href and sellerPartyReference/@href values must not be the same.</text>
</error>
</xsl:if>
<xsl:if test="fpml:premium">
<xsl:variable name="payer">
<xsl:value-of select="fpml:premium/fpml:payerPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="receiver">
<xsl:value-of select="fpml:premium/fpml:receiverPartyReference/@href"/>
</xsl:variable>
<xsl:if test="$href1!=$payer">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** buyerPartyReference/@href (buyer) and premium/payerPartyReference/@href (premium payer) values must be the same.</text>
</error>
</xsl:if>
<xsl:if test="$href2!=$receiver">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** sellerPartyReference/@href (seller) and premium/receiverPartyReference/@href (premium receiver) values must be the same.</text>
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
<xsl:template match="fpml:premium">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="href1">
<xsl:value-of select="fpml:payerPartyReference/@href"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$href1='partyA'"/>
<xsl:when test="$href1='partyB'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid payerPartyReference/@href value. Value = '<xsl:value-of select="$href1"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
<xsl:variable name="href2">
<xsl:value-of select="fpml:receiverPartyReference/@href"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$href2='partyA'"/>
<xsl:when test="$href2='partyB'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid receiverPartyReference/@href value. Value = '<xsl:value-of select="$href2"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
<xsl:if test="$href1=$href2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** payerPartyReference/@href and receiverPartyReference/@href values must not be the same.</text>
</error>
</xsl:if>
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
<xsl:choose>
<xsl:when test="$productType='CapFloor'">
<xsl:if test="fpml:paymentAmount/fpml:currency!=../fpml:capFloorStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:currency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** paymentAmount/currency (premium currency) and ../capFloor/capFloorStream/calculationPeriodAmount/calculation/notionalSchedule/notionalStepSchedule/currency must be the same.</text>
</error>
</xsl:if>
</xsl:when>
</xsl:choose>
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
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:tradeHeader/fpml:tradeDate"/>
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
<xsl:if test="$payDate &lt; $trdDate and not($productType='CapFloor' or $productType='Swaption')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The premium payment date (paymentDate/unadjustedDate) must be greater than or equal to the tradeDate.  Value = '<xsl:value-of select="fpml:paymentDate/fpml:unadjustedDate"/>'.</text>
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
<xsl:if test="$productType='CapFloor' and fpml:paymentDate/fpml:dateAdjustments[businessDayConvention!='FOLLOWING']">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** paymentDate/dateAdjustments/businessDayConvention must be equal to 'FOLLOWING' if product type is 'CapFloor'. Value = '<xsl:value-of select="paymentDate/dateAdjustments/businessDayConvention"/>'.</text>
</error>
</xsl:if>
<xsl:variable name="premiumPaymentBusCenters">
<xsl:for-each select="fpml:paymentDate/fpml:dateAdjustments/fpml:businessCenters/fpml:businessCenter">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:variable>
<xsl:choose>
<xsl:when test="$productType='CapFloor'">
<xsl:variable name="capFloorPaymentBusCenters">
<xsl:for-each select="../fpml:capFloorStream/fpml:paymentDates/fpml:paymentDatesAdjustments/fpml:businessCenters/fpml:businessCenter">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:variable>
<xsl:if test="$premiumPaymentBusCenters != $capFloorPaymentBusCenters">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** paymentDate/dateAdjustments/businessCenters (premium payment business centers) must be the same as the payment business centers on the cap/floor  (../capFloorStream/paymentDates/paymentDatesAdjustments/businessCenters) if product type is 'CapFloor'.</text>
</error>
</xsl:if>
</xsl:when>
</xsl:choose>
</xsl:template>
<xsl:template match="fpml:europeanExercise">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
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
<xsl:if test="fpml:earliestExerciseTime/businessCenter != fpml:expirationTime/businessCenter">
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
<text>*** earliestExerciseTime/hourMinuteTime (<xsl:value-of select="earliestExerciseTime/hourMinuteTime"/>) must be less than expirationTime/hourMinuteTime (<xsl:value-of select="fpml:expirationTime/fpml:hourMinuteTime"/>).</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:expirationDate">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="fpml:adjustableDate/fpml:dateAdjustments[fpml:businessDayConvention!=('FOLLOWING' or 'MODFOLLOWING' or 'PRECEDING')]">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** adjustableDate/dateAdjustments/businessDayConvention must be equal to 'FOLLOWING'.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:adjustableDate">
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
<xsl:template match="fpml:earliestExerciseTime">
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
<xsl:template match="fpml:expirationTime">
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
<xsl:template match="fpml:swapStream">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:variable name="href1">
<xsl:value-of select="fpml:payerPartyReference/@href"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$href1='partyA'"/>
<xsl:when test="$href1='partyB'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid payerPartyReference/@href value. Value = '<xsl:value-of select="$href1"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
<xsl:variable name="href2">
<xsl:value-of select="fpml:receiverPartyReference/@href"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$href2='partyA'"/>
<xsl:when test="$href2='partyB'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid receiverPartyReference/@href value. Value = '<xsl:value-of select="$href2"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
<xsl:if test="$href1=$href2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** payerPartyReference/@href and receiverPartyReference/@href values must not be the same.</text>
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
<xsl:if test="(fpml:settlementProvision and ($productType = 'IRS' or $productType = 'OIS' or $productType ='Swaption') and  position()!=$fixedLeg)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** settlementProvision should only be specified on the fixed leg of a non deliverable trade for IRS,OIS Swaption.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:settlementProvision">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:party">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:if test="not(fpml:partyId)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing partyId.</text>
</error>
</xsl:if>
<xsl:if test="not(string-length(fpml:partyId) = string-length(normalize-space(fpml:partyId)))">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid partyId element. </text>
</error>
</xsl:if>
<xsl:variable name="partyName">
<xsl:value-of select="fpml:partyName"/>
</xsl:variable>
<xsl:if test="fpml:partyName">
<xsl:if test="$partyName=''">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Empty partyName.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="string-length($partyName) &gt; 200">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid partyName string length. Exceeded max length of 200 characters.</text>
</error>
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
<xsl:choose>
<xsl:when test="(fpml:stubPeriodType='InitialShort' or fpml:stubPeriodType='InitialLong') and ../fpml:stubCalculationPeriodAmount/fpml:finalStub">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** stubPeriodType value of '<xsl:value-of select="fpml:StubPeriodType"/>' is inconsistent with presence of ../stubCalculationPeriodAmount/finalStub element.</text>
</error>
</xsl:when>
<xsl:when test="(fpml:stubPeriodType='FinalShort' or fpml:stubPeriodType='FinalLong') and ../fpml:stubCalculationPeriodAmount/fpml:initialStub">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** stubPeriodType value of '<xsl:value-of select="fpml:StubPeriodType"/>' is inconsistent with presence of ../stubCalculationPeriodAmount/initialStub element.</text>
</error>
</xsl:when>
</xsl:choose>
<xsl:apply-templates select="fpml:calculationPeriodFrequency">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:effectiveDate">
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
<xsl:if test="//fpml:swap and not($productType='ZC Inflation Swap') and $productType!='IRS' and $productType!='OIS'">
<xsl:variable name="businessDayConvention1">
<xsl:value-of select="fpml:dateAdjustments/fpml:businessDayConvention"/>
</xsl:variable>
<xsl:variable name="businessDayConvention2">
<xsl:choose>
<xsl:when test="$productType = 'Fixed Fixed Swap'">
<xsl:value-of select="//fpml:trade//fpml:swapStream[position()=$fixedLeg]/fpml:calculationPeriodDates/fpml:calculationPeriodDatesAdjustments/fpml:businessDayConvention"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="//fpml:trade//fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodDates/fpml:calculationPeriodDatesAdjustments/fpml:businessDayConvention"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="businessDayConvention3">
<xsl:choose>
<xsl:when test="$productType = 'Fixed Fixed Swap'">
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
<xsl:when test="$productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Fixed Fixed Swap' or $productType='Cross Currency IRS'">
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
</xsl:template>
<xsl:template match="fpml:terminationDate">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="businessDayConvention1">
<xsl:value-of select="fpml:dateAdjustments/fpml:businessDayConvention"/>
</xsl:variable>
<xsl:variable name="businessDayConvention2">
<xsl:choose>
<xsl:when test="$productType = 'Fixed Fixed Swap'">
<xsl:value-of select="//fpml:trade//fpml:swapStream[position()=$fixedLeg]/fpml:calculationPeriodDates/fpml:calculationPeriodDatesAdjustments/fpml:businessDayConvention"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="//fpml:trade//fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodDates/fpml:calculationPeriodDatesAdjustments/fpml:businessDayConvention"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="businessDayConvention3">
<xsl:choose>
<xsl:when test="$productType = 'Fixed Fixed Swap'">
<xsl:value-of select="//fpml:trade//fpml:swapStream[position()=$fixedLeg2]/fpml:calculationPeriodDates/fpml:calculationPeriodDatesAdjustments/fpml:businessDayConvention"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="//fpml:trade//fpml:swapStream[position()=$floatingLeg2]/fpml:calculationPeriodDates/fpml:calculationPeriodDatesAdjustments/fpml:businessDayConvention"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:if test="//fpml:swap and not($productType='ZC Inflation Swap')">
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
<xsl:for-each select="//fpml:swapStream[@id='floatingLeg']/fpml:calculationPeriodDates/fpml:calculationPeriodDatesAdjustments/fpml:businessCenters/fpml:businessCenter">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:if test="$busCenters1!= $busCenters2 and $productType!='SingleCurrencyInterestRateSwap' and $productType!='OIS'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Under terminationDate, if dateAdjustments/businessDayConvention is not equal to 'NONE' /dateAdjustments/businessCenters must equal floating/fixed leg calculationPeriodDates/calculationPeriodDatesAdjustments/businessCenters.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
<xsl:if test="//fpml:swap and ($productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS')">
<xsl:if test="$businessDayConvention1!='NONE' and $businessDayConvention2!='NONE' and $businessDayConvention3!='NONE'">
<xsl:variable name="busCenters1">
<xsl:for-each select="fpml:dateAdjustments/fpml:businessCenters/fpml:businessCenter">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:variable>
<xsl:variable name="busCenters2">
<xsl:for-each select="../fpml:calculationPeriodDatesAdjustments/fpml:businessCenters/fpml:businessCenter">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:variable>
<xsl:if test="$busCenters1!= $busCenters2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** If dateAdjustments/businessDayConvention is not equal to 'NONE' /dateAdjustments/businessCenters must equal same leg calculationPeriodDates/calculationPeriodDatesAdjustments/businessCenters.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
<xsl:if test="$productType='CapFloor'">
<xsl:variable name="capFloorCalcPeriodDatesBusinessDayConvention">
<xsl:value-of select="//fpml:trade//fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodDates/fpml:calculationPeriodDatesAdjustments/fpml:businessDayConvention"/>
</xsl:variable>
<xsl:if test="$businessDayConvention1!='NONE' and capFloorCalcPeriodDatesBusinessDayConvention!='NONE'">
<xsl:variable name="busCenters1">
<xsl:for-each select="fpml:dateAdjustments/fpml:businessCenters/fpml:businessCenter">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:variable>
<xsl:variable name="busCenters2">
<xsl:for-each select="../fpml:calculationPeriodDatesAdjustments/fpml:businessCenters/fpml:businessCenter">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:variable>
<xsl:if test="$busCenters1!= $busCenters2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** If dateAdjustments/businessDayConvention is not equal to 'NONE' /dateAdjustments/businessCenters must equal ../calculationPeriodDatesAdjustments/businessCenters if product type is 'CapFloor'.</text>
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
<text>*** calculationPeriodFrequency must be equal to  1M, 3M, 6M,1Y or 1T if product type is 'OIS'. Value = '<xsl:value-of select="$freq"/>'.</text>
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
<xsl:if test="($productType='SingleCurrencyInterestRateSwap' or $productType='Swaption' or $productType='CapFloor') and $tradeCurrency='MXN'">
<xsl:if test="not($rollConvention='NONE')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** rollConvention must be equal to 'NONE' if product type is 'SingleCurrencyInterestRateSwap', 'Swaption' or 'CapFloor' and currency is 'MXN'. Value = '<xsl:value-of select="$rollConvention"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="starts-with($rollConvention,'IMM')">
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
<xsl:if test="$productType!='SingleCurrencyInterestRateSwap' and $productType!='Cross Currency IRS' and $productType!='OIS' and $productType!='Single Currency Basis Swap'">
<xsl:call-template name="isValidIMMMonth">
<xsl:with-param name="elementName">../fpml:effectiveDate/fpml:unadjustedDate</xsl:with-param>
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
<xsl:if test="$version='1-0' and paymentDaysOffset">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** paymentDaysOffset must not be present if SWBML version = "1-0".</text>
</error>
</xsl:if>
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
<xsl:if test="$FpMLVersion='1-0'">
<xsl:if test="fpml:initialFixingDate">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected initialFixingDate child element encountered. Not valid in FpML version = "1-0".</text>
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
<xsl:template match="fpml:initialFixingDate">
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
<xsl:variable name="initialFixingPeriodMultiplier">
<xsl:for-each select="periodMultiplier">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:variable>
<xsl:variable name="fixingPeriodMultiplier">
<xsl:for-each select="../fpml:fixingDates/fpml:periodMultiplier">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:variable>
<xsl:variable name="initialFixingBusCenters">
<xsl:for-each select="fpml:businessCenters/fpml:businessCenter">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:variable>
<xsl:variable name="fixingBusCenters">
<xsl:for-each select="../fpml:fixingDates/fpml:businessCenters/fpml:businessCenter">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:variable>
<xsl:if test="($initialFixingPeriodMultiplier = $fixingPeriodMultiplier) and ($initialFixingBusCenters = $fixingBusCenters)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** initialFixingDate offset rules must only be included if they are different to those specified in ..\fixingDates. Currently they are specified the same.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:fixingDates">
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
<xsl:choose>
<xsl:when test="$productType='Single Currency Basis Swap'">
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
</xsl:when>
<xsl:when test="$productType='SingleCurrencyInterestRateSwap' or $productType='CapFloor' or $productType='Swaption' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='Fixed Fixed Swap'">
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
<xsl:when test="$freq='1W' and $tradeCurrency='CNY'"/>
<xsl:when test="$freq='28D'"/>
<xsl:when test="$freq='1M'"/>
<xsl:when test="$freq='3M'"/>
<xsl:when test="$freq='6M'"/>
<xsl:when test="$freq='1Y'"/>
<xsl:when test="$freq='1T' and $tradeCurrency='CLP'"/>
<xsl:when test="$freq='1T' and $isOISonSwaption='true'"/>
<xsl:when test="$freq='1T' and ($productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS')"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** resetFrequency must be equal to 1T (OIS on Swaption), 28D, 1M, 3M, 6M or 1Y if product type is 'SingleCurrencyInterestRateSwap', 'CapFloor', 'Swaption' or 'Cross Currency Basis Swap' or $'Cross Currency IRS'. Value = '<xsl:value-of select="$freq"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType='OIS'">
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
<text>*** resetFrequency must be equal to 1M, 3M, 6M,1Y or 1T if product type is 'OIS'. Value = '<xsl:value-of select="$freq"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
</xsl:choose>
<xsl:if test="$freq='1W'">
<xsl:if test="$tradeCurrency!='CNY'">
<xsl:if test="not(fpml:weeklyRollConvention)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** weeklyRollConvention must be present if resetFrequency='1W'</text>
</error>
</xsl:if>
</xsl:if>
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
<xsl:when test="$productType = 'IRS' or $productType = 'OIS' or $productType = 'ZC Inflation Swap'">
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
<xsl:when test="($productType='CapFloor')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** compoundingMethod must not be present if product type is 'CapFloor'.</text>
</error>
</xsl:when>
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
<xsl:if test="not($productType='CapFloor')">
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
<xsl:if test="not(fpml:compoundingMethod)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing element. compoundingMethod must be present when compounding is implied by different payment and calculation frequencies.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$calcFreq = $payFreq and $tradeCurrency != 'CLP'">
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
</xsl:if>
<xsl:apply-templates select="fpml:notionalSchedule">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="($productType='ZC Inflation Swap')">
<xsl:apply-templates select="fpml:inflationRateCalculation">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
<xsl:if test="$productType='CapFloor'">
<xsl:if test="fpml:fixedRateSchedule">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** fixedRateSchedule must not be present if product type is 'CapFloor'.</text>
</error>
</xsl:if>
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
<xsl:when test="$productType='Cross Currency IRS'">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[@id='floatingLeg']/fpml:calculationPeriodAmount/fpml:calculation/fpml:fxLinkedNotionalSchedule/fpml:varyingNotionalCurrency"/>
</xsl:when>
<xsl:when test="$productType='Cross Currency Basis Swap'">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[@id='floatingLeg2']/fpml:calculationPeriodAmount/fpml:calculation/fpml:fxLinkedNotionalSchedule/fpml:varyingNotionalCurrency"/>
</xsl:when>
<xsl:when test="$productType='Fixed Fixed Swap'">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[@id='fixedLeg2']/fpml:calculationPeriodAmount/fpml:calculation/fpml:fxLinkedNotionalSchedule/fpml:varyingNotionalCurrency"/>
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
<text>*** primaryRateSource/rateSource must be present if product type is 'Cross Currency Basis Swap' or 'Cross Currency IRS' and it is a Mark-To-Market Swap.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:primaryRateSource/fpml:rateSourcePage) or string-length(fpml:primaryRateSource/fpml:rateSourcePage) = 0">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** primaryRateSource/rateSourcePage must be present if product type is 'Cross Currency Basis Swap' or 'Cross Currency IRS' and it is a Mark-To-Market Swap.</text>
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
<text>*** varyingNotionalInterimExchangePaymentDates/periodMultiplier must be 0 if product type is 'Cross Currency Basis Swap'  or 'Cross Currency IRS'and it is a Mark-To-Market Swap.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:period='D')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** varyingNotionalInterimExchangePaymentDates/period must be D if product type is 'Cross Currency Basis Swap' or 'Cross Currency IRS'and it is a Mark-To-Market Swap.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:businessDayConvention='NONE')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** varyingNotionalInterimExchangePaymentDates/businessDayConvention must be NONE if product type is 'Cross Currency Basis Swap' or 'Cross Currency IRS'and it is a Mark-To-Market Swap.</text>
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
<xsl:template match="fpml:notionalSchedule">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:apply-templates select="fpml:notionalStepSchedule">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:settlementProvision">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="fpml:settlementProvision">
<xsl:if test="not($productType='SingleCurrencyInterestRateSwap' or $productType='OIS')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** settlementProvision should only be present if product type is 'SingleCurrencyInterestRateSwap' or 'OIS'. Value = '<xsl:value-of select="$productType"/>' .</text>
</error>
</xsl:if>
</xsl:if>
<xsl:variable name="fpml:settlementCurrency">
<xsl:value-of select="fpml:settlementCurrency"/>
</xsl:variable>
<xsl:if test="not(fpml:settlementCurrency = 'USD')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** settlementCurrency must be equal to 'USD'. Value = '<xsl:value-of select="settlementCurrency"/>'.</text>
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
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$fixedLeg]/fpml:calculationPeriodDates/fpml:terminationDate/@id"/>
</xsl:variable>
<xsl:variable name="floatingId">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodDates/fpml:terminationDate/@id"/>
</xsl:variable>
<xsl:if test="($href1!=$fixedId) and ($href1!=$floatingId)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid paymentDatesReference/@href value. Value is not equal to ../paymentDates/@id. Value of href = &#xFFFD;<xsl:value-of select="$href1"/>' and id values are &#xFFFD;<xsl:value-of select="$fixedId"/>&#xFFFD; and &#xFFFD;<xsl:value-of select="$floatingId"/>&#xFFFD;.</text>
</error>
</xsl:if>
<xsl:if test="($href2!=$fixedId) and ($href2!=$floatingId)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid paymentDatesReference/@href value. Value is not equal to ../paymentDates/@id. Value of href = &#xFFFD;<xsl:value-of select="$href2"/>' and id values are &#xFFFD;<xsl:value-of select="$fixedId"/>&#xFFFD; and &#xFFFD;<xsl:value-of select="$floatingId"/>'.</text>
</error>
</xsl:if>
</xsl:when>
<xsl:otherwise>
<xsl:variable name="fixedId">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails//fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$fixedLeg]/fpml:paymentDates/@id"/>
</xsl:variable>
<xsl:variable name="floatingId">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails//fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:paymentDates/@id"/>
</xsl:variable>
<xsl:variable name="fixedRef">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails//fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$fixedLeg]/fpml:paymentDates/fpml:calculationPeriodDatesReference/@href"/>
</xsl:variable>
<xsl:variable name="floatingRef">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails//fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:paymentDates/fpml:calculationPeriodDatesReference/@href"/>
</xsl:variable>
<xsl:variable name="floatingRef2">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails//fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$floatingLeg2]/fpml:paymentDates/fpml:calculationPeriodDatesReference/@href"/>
</xsl:variable>
<xsl:if test="($href1!=$fixedId) and ($href1!=$floatingId) and $href1!=$floatingRef and $href1!=$fixedRef">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid paymentDatesReference/@href value. Value is not equal to ../paymentDates/@id or calculationPeriodDatesReference/@href. Value of href ='<xsl:value-of select="$href1"/>' and id values '<xsl:value-of select="$fixedId"/>','<xsl:value-of select="$floatingRef"/>','<xsl:value-of select="$fixedRef"/>','<xsl:value-of select="$floatingRef2"/>' and '<xsl:value-of select="$floatingId"/>'.</text>
</error>
</xsl:if>
<xsl:if test="($href2!=$fixedId) and ($href2!=$floatingId)  and $href2!=$floatingRef and $href2!=$floatingRef2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid paymentDatesReference/@href value. Value is not equal to ../paymentDates/@id or calculationPeriodDatesReference/@href. Value of href ='<xsl:value-of select="$href1"/>' and id values are '<xsl:value-of select="$fixedId"/>','<xsl:value-of select="$fixedRef"/>','<xsl:value-of select="$floatingRef"/>','<xsl:value-of select="$floatingRef2"/>' and '<xsl:value-of select="$floatingId"/>'.</text>
</error>
</xsl:if>
<xsl:if test="($productType='Cross Currency IRS' and (($href1=$fixedRef and $href2!=$floatingRef) or ($href2=$floatingRef and $href1!=$fixedRef))) or ($productType='Cross Currency Basis Swap' and (($href1=$floatingRef and $href2!=$floatingRef2) or ($href2=$floatingRef2 and $href1!=$floatingRef))) ">
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
</xsl:template>
<xsl:template match="fpml:inflationRateCalculation">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="fpml:initialIndexLevel">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">initialIndexLevel</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:initialIndexLevel"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.0000000000</xsl:with-param>
<xsl:with-param name="maxIncl">1000.0000000000</xsl:with-param>
<xsl:with-param name="maxDecs">10</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:variable name="inflationLag">
<xsl:value-of select="fpml:inflationLag/fpml:periodMultiplier"/>
<xsl:value-of select="fpml:inflationLag/fpml:period"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$inflationLag='0M'"/>
<xsl:when test="$inflationLag='1M'"/>
<xsl:when test="$inflationLag='2M'"/>
<xsl:when test="$inflationLag='3M'"/>
<xsl:when test="$inflationLag='4M'"/>
<xsl:when test="$inflationLag='5M'"/>
<xsl:when test="$inflationLag='6M'"/>
<xsl:when test="$inflationLag='7M'"/>
<xsl:when test="$inflationLag='8M'"/>
<xsl:when test="$inflationLag='9M'"/>
<xsl:when test="$inflationLag='10M'"/>
<xsl:when test="$inflationLag='11M'"/>
<xsl:when test="$inflationLag='12M'"/>
<xsl:when test="$inflationLag='13M'"/>
<xsl:when test="$inflationLag='14M'"/>
<xsl:when test="$inflationLag='15M'"/>
<xsl:when test="$inflationLag='16M'"/>
<xsl:when test="$inflationLag='17M'"/>
<xsl:when test="$inflationLag='18M'"/>
<xsl:when test="$inflationLag='19M'"/>
<xsl:when test="$inflationLag='20M'"/>
<xsl:when test="$inflationLag='21M'"/>
<xsl:when test="$inflationLag='22M'"/>
<xsl:when test="$inflationLag='23M'"/>
<xsl:when test="$inflationLag='24M'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** inflationLag must be equal to 0M, 1M, 2M, 3M, 4M, 5M, 6M, 7M, 8M, 9M, 10M, 11M, 12M, 13M, 14M, 15M, 16M, 17M, 18M, 19M, 20M, 21M, 22M, 23M or 24M. Value = '<xsl:value-of select="$inflationLag"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
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
<xsl:if test="$tradeCurrency != 'PLN' and not($productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='Fixed Fixed Swap') ">
<xsl:if test="contains(substring($floatingRateIndex,4,4),'-')">
<xsl:variable name="floatingRateIndexCurrency">
<xsl:value-of select="substring($floatingRateIndex,1,3)"/>
</xsl:variable>
<xsl:if test="$tradeCurrency != $floatingRateIndexCurrency and $floatingRateIndex != 'CNH-HIBOR-TMA' and $floatingRateIndex != 'CNH-HIBOR'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** floatingRateIndex value of '<xsl:value-of select="$floatingRateIndex"/>' is not valid for trade currency of '<xsl:value-of select="$tradeCurrency"/>'.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
<xsl:if test="$productType='CapFloor' or $productType='Swaption'">
<xsl:if test="fpml:initialRate">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** initialRate must not be present if product type is 'CapFloor' or 'Swaption'.</text>
</error>
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
<xsl:if test="$productType!='CapFloor'">
<xsl:if test="fpml:capRateSchedule">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected capRateSchedule element encountered in this context. capRateSchedule must only be present if product type is 'CapFloor'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:floorRateSchedule">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected floorRateSchedule element encountered in this context. floorRateSchedule must only be present if product type is 'CapFloor'.</text>
</error>
</xsl:if>
</xsl:if>
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
<xsl:apply-templates select="fpml:spreadSchedule">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:indexTenor">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
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
<xsl:if test="($productType='SingleCurrencyInterestRateSwap' or $productType='Swaption') and not(parent::fpml:floatingRate)">
<xsl:variable name="indexTenor">
<xsl:value-of select="fpml:periodMultiplier"/>
<xsl:value-of select="fpml:period"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$indexTenor='1W' and $tradeCurrency='CNY'"/>
<xsl:when test="$indexTenor='28D'"/>
<xsl:when test="$indexTenor='1M'"/>
<xsl:when test="$indexTenor='3M'"/>
<xsl:when test="$indexTenor='6M'"/>
<xsl:when test="$indexTenor='1Y'"/>
<xsl:when test="$indexTenor='1T' and $tradeCurrency='CLP'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** indexTenor must be equal to 1T (CLP currency), 28D, 1M, 3M, 6M or 1Y if product type is 'SingleCurrencyInterestRateSwap' or 'Swaption'. Value = '<xsl:value-of select="$indexTenor"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="$productType='Single Currency Basis Swap' and not(parent::fpml:floatingRate)">
<xsl:variable name="indexTenor">
<xsl:value-of select="fpml:periodMultiplier"/>
<xsl:value-of select="fpml:period"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$indexTenor='1W'"/>
<xsl:when test="$indexTenor='2W'"/>
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
<text>*** indexTenor must be equal to 1W, 2W, 1M, 2M, 3M, 4M, 5M, 6M, 7M, 8M, 9M, 10, 11M, 12M if product type is 'Basis Swap'. Value = '<xsl:value-of select="$indexTenor"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="($productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='Fixed Fixed Swap') and not(parent::fpml:floatingRate)">
<xsl:variable name="indexTenor">
<xsl:value-of select="fpml:periodMultiplier"/>
<xsl:value-of select="fpml:period"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$indexTenor='28D'"/>
<xsl:when test="$indexTenor='1W'"/>
<xsl:when test="$indexTenor='2W'"/>
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
<text>*** indexTenor must be equal to 28D, 1W, 2W, 1M, 2M, 3M, 4M, 5M, 6M, 7M, 8M, 9M, 10, 11M, 12M if product type is 'Cross Currency products'. Value = '<xsl:value-of select="$indexTenor"/>'.</text>
</error>
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
<xsl:if test="fpml:initialStub and fpml:finalStub and not($productType='SingleCurrencyInterestRateSwap' or $productType='OIS')">
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
<xsl:if test="($tradeCurrency = 'AUD' or $tradeCurrency2 = 'AUD') and (fpml:initialStub/fpml:floatingRate[1]/fpml:floatingRateIndex = 'AUD-RBA Cash Rate' or fpml:initialStub/fpml:floatingRate[1]/fpml:floatingRateIndex = 'AUD-AONIA' or fpml:finalStub/fpml:floatingRate[1]/fpml:floatingRateIndex = 'AUD-AONIA' or fpml:finalStub/fpml:floatingRate[1]/fpml:floatingRateIndex = 'AUD-RBA Cash Rate' ) and fpml:floatingRateCalculation/fpml:floatingRate[1] != 'AUD-AONIA'">
<xsl:if test="(string-length(fpml:initialStub/fpml:floatingRate[2]/fpml:floatingRateIndex) &lt; 3) and (string-length(fpml:finalStub/fpml:floatingRate[2]/fpml:floatingRateIndex) &lt; 3)  ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text> *** stub floatingRateIndex[1] value of 'AUD-RBA Cash Rate' or 'AUD-AONIA'is not valid without stub floatingRateIndex[2]. Linear interpolation is required.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="($tradeCurrency = 'NZD' or $tradeCurrency2 = 'NZD') and (fpml:initialStub/fpml:floatingRate[1]/fpml:floatingRateIndex = 'NZD-RBNZ OCR' or fpml:initialStub/fpml:floatingRate[1]/fpml:floatingRateIndex = 'NZD-NZIONA' or fpml:finalStub/fpml:floatingRate[1]/fpml:floatingRateIndex = 'NZD-RBNZ OCR' or fpml:finalStub/fpml:floatingRate[1]/fpml:floatingRateIndex = 'NZD-NZIONA' ) and fpml:floatingRateCalculation/fpml:floatingRate[1] !='NZD-NZIONA'">
<xsl:if test="(string-length(fpml:initialStub/fpml:floatingRate[2]/fpml:floatingRateIndex) &lt; 3) and (string-length(fpml:finalStub/fpml:floatingRate[2]/fpml:floatingRateIndex) &lt; 3)  ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text> *** stub floatingRateIndex[1] value of 'NZD-RBNZ OCR' or 'NZD-NZIONA' is not valid without stub floatingRateIndex[2]. Linear interpolation is required.</text>
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
<xsl:when test="$productType='ZC Inflation Swap'">
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
<xsl:if test="($tradeCurrency != 'PLN') and not($productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='ZC Inflation Swap')">
<xsl:if test="contains(substring($floatingRateIndex,4,4),'-')">
<xsl:variable name="floatingRateIndexCurrency">
<xsl:value-of select="substring($floatingRateIndex,1,3)"/>
</xsl:variable>
<xsl:if test="$tradeCurrency != $floatingRateIndexCurrency and $floatingRateIndex != 'CNH-HIBOR-TMA' and $floatingRateIndex != 'CNH-HIBOR'">
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
<xsl:template mode="FRA" match="fpml:indexTenor">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
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
</xsl:template>
<xsl:template match="fpml:otherPartyPayment">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:variable name="href1">
<xsl:value-of select="fpml:payerPartyReference/@href"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$href1='partyA'"/>
<xsl:when test="$href1='partyB'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid payerPartyReference/@href value. Value = '<xsl:value-of select="$href1"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
<xsl:variable name="href2">
<xsl:value-of select="fpml:receiverPartyReference/@href"/>
</xsl:variable>
<xsl:if test="$href2='partyA' or $href2='partyB'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid receiverPartyReference/@href value. Value = '<xsl:value-of select="$href2"/>'.</text>
</error>
</xsl:if>
<xsl:if test="$href1=$href2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** payerPartyReference/@href and receiverPartyReference/@href values must not be the same.</text>
</error>
</xsl:if>
<xsl:if test="not(/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:party[@id=$href2])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The receiverPartyReference/@href value does not match an id value for any party. Value = '<xsl:value-of select="$href2"/>'.</text>
</error>
</xsl:if>
<xsl:variable name="amount">
<xsl:value-of select="fpml:paymentAmount/fpml:amount"/>
</xsl:variable>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">paymentAmount/amount</xsl:with-param>
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
<xsl:if test="fpml:paymentDate">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected paymentDate element encountered in this context. Not expected for brokerage payment.</text>
</error>
</xsl:if>
<xsl:if test="fpml:paymentType">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected paymentType element encountered in this context. Not expected for brokerage payment.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:calculationAgent">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="parent::fpml:trade and not($productType='SingleCurrencyInterestRateSwap' and $tradeCurrency='BRL')">
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
<xsl:template match="fpml:documentation">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:apply-templates select="fpml:masterAgreement">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
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
<xsl:template match="fpml:masterAgreement">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:call-template name="isValidMasterAgreementType">
<xsl:with-param name="elementName">masterAgreementType</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:masterAgreementType"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="fpml:masterAgreementType/@masterAgreementTypeScheme!='http://www.swapswire.com/spec/2001/master-agreement-type-1-0'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid masterAgreementType/@masterAgreementTypeScheme attribute. Value = '<xsl:value-of select="fpml:masterAgreementType/@masterAgreementTypeScheme"/>'.</text>
</error>
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
<text>*** /SWBML/swbStructuredTradeDetails/swbProductType must be equal to 'FRA' if fra element is present.</text>
</error>
</xsl:if>
<xsl:variable name="href1">
<xsl:value-of select="fpml:buyerPartyReference/@href"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$href1='partyA'"/>
<xsl:when test="$href1='partyB'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid buyerPartyReference/@href value. Value = '<xsl:value-of select="$href1"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
<xsl:variable name="href2">
<xsl:value-of select="fpml:sellerPartyReference/@href"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$href2='partyA'"/>
<xsl:when test="$href2='partyB'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid sellerPartyReference/@href value. Value = '<xsl:value-of select="$href2"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
<xsl:if test="$href1=$href2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** buyerPartyReference/@href and sellerPartyReference/@href values must not be the same.</text>
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
<xsl:if test="not(count(fpml:indexTenor)=1 or count(fpml:indexTenor)=2)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of indexTenor child elements encountered. Exactly 1 or 2 expected.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:indexTenor" mode="FRA">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:call-template name="isValidFraDiscounting">
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
<xsl:if test="$businessDayConvention='NONE'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** dateAdjustments/businessDayConvention must not equal 'NONE' in this context.</text>
</error>
</xsl:if>
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
<xsl:if test="ancestor::fpml:trade/fpml:calculationAgent and ($productType='SingleCurrencyInterestRateSwap' and $tradeCurrency='BRL')">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:if>
<xsl:if test="ancestor::fpml:swaption/fpml:calculationAgent">
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
<xsl:when test="$productType='SingleCurrencyInterestRateSwap'">
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
<xsl:when test="$elementValue='PLN'"/>
<xsl:when test="$elementValue='NZD'"/>
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
<xsl:when test="$elementValue='THB'"/>
<xsl:when test="$elementValue='TRY'"/>
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
<xsl:when test="$productType='ZC Inflation Swap'">
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
<xsl:when test="$elementValue='JPY'"/>
<xsl:when test="$elementValue='KRW'"/>
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
<xsl:when test="$productType='Cross Currency Basis Swap'">
<xsl:choose>
<xsl:when test="$elementValue='AUD'"/>
<xsl:when test="$elementValue='CAD'"/>
<xsl:when test="$elementValue='CHF'"/>
<xsl:when test="$elementValue='CLP'"/>
<xsl:when test="$elementValue='COP'"/>
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
<xsl:when test="$productType='Cross Currency IRS' or $productType='Fixed Fixed Swap'">
<xsl:choose>
<xsl:when test="$elementValue='AUD'"/>
<xsl:when test="$elementValue='CAD'"/>
<xsl:when test="$elementValue='CHF'"/>
<xsl:when test="$elementValue='CLP' and $productType='Cross Currency IRS'"/>
<xsl:when test="$elementValue='CNY'"/>
<xsl:when test="$elementValue='COP'"/>
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
<xsl:if test="$productType='SingleCurrencyInterestRateSwap' or $productType='OIS' or $productType='CapFloor' or $productType='Swaption' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='Fixed Fixed Swap'">
<xsl:if test="$tradeCurrency='GBP' or ($productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='Fixed Fixed Swap' and ($tradeCurrency2='GBP'))">
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
<xsl:when test="(($elementValue='BUS/252') and ($tradeCurrency='BRL') and ($productType='SingleCurrencyInterestRateSwap'))"/>
<xsl:when test="($elementValue='1/1') and ($swbExtendedTradeDetails/fpml:swbCapFloorDetails/fpml:swbFloatingRateFixingDate/fpml:unadjustedDate !='')"/>
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
<xsl:if test="$tradeCurrency!='GBP' and (not($productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='Fixed Fixed Swap') or $tradeCurrency2!='GBP')">
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
<xsl:when test="(($elementValue='BUS/252') and ($tradeCurrency='BRL') and ($productType='SingleCurrencyInterestRateSwap'))"/>
<xsl:when test="($elementValue='1/1') and ($swbExtendedTradeDetails/fpml:swbCapFloorDetails/fpml:swbFloatingRateFixingDate/fpml:unadjustedDate !='')"/>
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
</xsl:if>
<xsl:if test="$productType='FRA'">
<xsl:if test="$tradeCurrency='GBP'">
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
</xsl:if>
<xsl:if test="$tradeCurrency!='GBP'">
<xsl:choose>
<xsl:when test="$elementValue='ACT/365.FIXED'"/>
<xsl:when test="$elementValue='ACT/360'"/>
<xsl:when test="$elementValue='ACT/ACT.ISDA'"/>
<xsl:when test="$elementValue='ACT/365.ISDA'"/>
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
</xsl:if>
<xsl:if test="$productType='ZC Inflation Swap' and (//fpml:couponRate)">
<xsl:choose>
<xsl:when test="$elementValue='ACT/365.FIXED'"/>
<xsl:when test="$elementValue='ACT/360'"/>
<xsl:when test="$elementValue='30/360'"/>
<xsl:when test="$elementValue='30E/360'"/>
<xsl:when test="$elementValue='30E/360.ISDA'"/>
<xsl:when test="$elementValue='ACT/365L'"/>
<xsl:when test="$elementValue='ACT/ACT.ICMA'"/>
<xsl:when test="$elementValue='1/1'"/>
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
</xsl:if>
<xsl:if test="$productType='ZC Inflation Swap' and not(//fpml:couponRate)">
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
<xsl:template name="isValidFraDiscounting">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/>. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
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
<xsl:template name="isValidIMMCurrency">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">rollConvention must not be equal to 'IMM' if trade currency is equal to '<xsl:value-of select="$elementValue"/>' (IMM Rolls not currently supported in MarkitWire for <xsl:value-of select="$elementValue"/>).</xsl:variable>
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
<xsl:when test="$elementValue='ISDA2006Inflation' and $productType='ZC Inflation Swap'"/>
<xsl:when test="$elementValue='ISDA2008Inflation' and $productType='ZC Inflation Swap'"/>
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
<xsl:when test="string(number($elementValue)) !='NaN' and not(contains($elementValue,' ')) and not(contains($elementValue,'e'))">
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
<xsl:when test="string(number($elementValue)) !='NaN' and not(contains($elementValue,' ')) and not(contains($elementValue,'e'))">
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
<xsl:when test="(//fpml:couponRate and //fpml:swbfallbackBondApplicable and //fpml:swbCalculationMethod and //fpml:swbCalculationStyle and //fpml:swbFloored and //fpml:swbSpreadCalculationMethod)"/>
<xsl:when test="(not(//fpml:couponRate) and not(//fpml:swbfallbackBondApplicable) and not(//fpml:swbCalculationMethod) and not(//fpml:swbCalculationStyle) and not(//fpml:swbFloored) and not(//fpml:swbSpreadCalculationMethod))"/>
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
<xsl:template name="isValidPartyRef">
<xsl:param name="elementName"/>
<xsl:param name="attributeName"/>
<xsl:param name="attributeValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/>/@<xsl:value-of select="$attributeName"/> attribute value. Value = '<xsl:value-of select="$attributeValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$attributeValue='partyA'"/>
<xsl:when test="$attributeValue='partyB'"/>
<xsl:when test="$attributeValue='broker'"/>
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
<xsl:when test="$productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='Fixed Fixed Swap'">
<xsl:choose>
<xsl:when test="$elementValue='W'"/>
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
<xsl:when test="$productType='FRA'">
<xsl:choose>
<xsl:when test="$elementValue='W'"/>
<xsl:when test="$elementValue='D'"/>
<xsl:when test="$elementValue='M'"/>
<xsl:when test="$elementValue='Y'"/>
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
<xsl:when test="$productType='CapFloor'">
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
<xsl:when test="$elementValue='W'"/>
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
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> if SWBML version = "<xsl:value-of select="$version"/>". Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:if test="$version='1-0'">
<xsl:choose>
<xsl:when test="$elementValue='SingleCurrencyInterestRateSwap'"/>
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
<xsl:if test="$version='2-0'">
<xsl:choose>
<xsl:when test="$elementValue='SingleCurrencyInterestRateSwap'"/>
<xsl:when test="$elementValue='OIS'"/>
<xsl:when test="$elementValue='FRA'"/>
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
<xsl:if test="$version = '3-0'">
<xsl:choose>
<xsl:when test="$elementValue='SingleCurrencyInterestRateSwap'"/>
<xsl:when test="$elementValue='OIS'"/>
<xsl:when test="$elementValue='FRA'"/>
<xsl:when test="$elementValue='CapFloor'"/>
<xsl:when test="$elementValue='Swaption'"/>
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
<xsl:if test="$version = '4-2'">
<xsl:choose>
<xsl:when test="$elementValue='SingleCurrencyInterestRateSwap'"/>
<xsl:when test="$elementValue='OIS'"/>
<xsl:when test="$elementValue='FRA'"/>
<xsl:when test="$elementValue='CapFloor'"/>
<xsl:when test="$elementValue='Swaption'"/>
<xsl:when test="$elementValue='ZC Inflation Swap'"/>
<xsl:when test="$elementValue='Single Currency Basis Swap'"/>
<xsl:when test="$elementValue='Cross Currency Basis Swap'"/>
<xsl:when test="$elementValue='Cross Currency IRS'"/>
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
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> for product type '<xsl:value-of select="$productType"/>'. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:variable name="oisErrorText">Empty or invalid <xsl:value-of select="$elementName"/> for a product type which uses OIS indices (OIS, OIS on CapFloor, etc.)'. Use CalculationPeriodEndDate instead.'</xsl:variable>
<xsl:if test="$productType='SingleCurrencyInterestRateSwap' or $productType='CapFloor' or $productType='Swaption' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='Fixed Fixed Swap'">
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
<xsl:when test="$elementValue='IMMAUD'"/>
<xsl:when test="$elementValue='IMMCAD'"/>
<xsl:when test="$elementValue='IMMNZD'"/>
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
<xsl:template match="fpml:swbStubLength">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:call-template name="isValidStubLength">
<xsl:with-param name="elementName">swbStubLength[<xsl:number value="position()"/>]</xsl:with-param>
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
<text>*** swbStubLength[<xsl:number value="position()"/>]/@href does not reference a valid //FpML/trade//capFloor/capFloorStream/@id. Value = '<xsl:value-of select="$href"/>'.</text>
</error>
</xsl:if>
</xsl:when>
<xsl:otherwise>
<xsl:if test="not(//fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[@id=$href])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbStubLength[<xsl:number value="position()"/>]/@href does not reference a valid //FpML/trade//swap/swapStream/@id. Value = '<xsl:value-of select="$href"/>'.</text>
</error>
</xsl:if>
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
<xsl:template name="isValidTime">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Missing, empty or invalid <xsl:value-of select="$elementName"/>. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
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
<xsl:when test="$elementValue='12:30:00'"/>
<xsl:when test="$elementValue='12:40:00'"/>
<xsl:when test="$elementValue='13:00:00'"/>
<xsl:when test="$elementValue='13:15:00'"/>
<xsl:when test="$elementValue='13:30:00'"/>
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
<xsl:variable name="errorText"> If swbPriceType is equal to 'F128' or 'F256' two characters to right of fractional separator in <xsl:value-of select="$elementName"/> are not in range 00 - 31. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
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
<xsl:variable name="errorText"> If swbPriceType is equal to 'F128' third character to right of fractional separator in <xsl:value-of select="$elementName"/> must be '2', '+' or '6'. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
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
<xsl:variable name="errorText"> If swbPriceType is equal to 'F256' third character to right of fractional separator in <xsl:value-of select="$elementName"/> must be '0', '1', '2', '3', '4', '5', '6', '7' or '+'. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
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
<xsl:template name="isValidFuture">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> for product type of '<xsl:value-of select="$productType"/>' when currency is '<xsl:value-of select="$tradeCurrency"/>'. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$tradeCurrency='EUR'">
<xsl:choose>
<xsl:when test="$elementValue='Bobl'"/>
<xsl:when test="$elementValue='Bund'"/>
<xsl:when test="$elementValue='Buxl'"/>
<xsl:when test="$elementValue='Schatz'"/>
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
<xsl:when test="$tradeCurrency='CHF'">
<xsl:choose>
<xsl:when test="$elementValue='Bobl'"/>
<xsl:when test="$elementValue='Bund'"/>
<xsl:when test="$elementValue='Buxl'"/>
<xsl:when test="$elementValue='Schatz'"/>
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
<xsl:when test="$tradeCurrency='GBP'">
<xsl:choose>
<xsl:when test="$elementValue='Gilt'"/>
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
<xsl:template name="isValidNonDeliverableCurrency">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> for Non-deliverable product type of '<xsl:value-of select="$productType"/>'. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$productType='SingleCurrencyInterestRateSwap'">
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
<xsl:when test="$productType='Cross Currency IRS' or $productType='Fixed Fixed Swap'">
<xsl:choose>
<xsl:when test="$elementValue='CLP' and $productType='Cross Currency IRS'"/>
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
<xsl:template match="fpml:swbMandatoryClearing|fpml:swbMandatoryClearingNewNovatedTrade">
<xsl:param name="context"/>
<xsl:if test="fpml:swbMandatoryClearingIndicator">
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">swbMandatoryClearingIndicator</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swbMandatoryClearingIndicator"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$context"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:for-each select="fpml:swbPartyExemption/fpml:swbExemption">
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">swbExemption</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="current()"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$context"/>
</xsl:with-param>
</xsl:call-template>
</xsl:for-each>
<xsl:if test="fpml:swbPartyExemption[position()=1]/fpml:swbPartyReference/@href = fpml:swbPartyExemption[position()=2]/fpml:swbPartyReference/@href">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** swbPartyExemption cannot be provided twice for the same party for the same clearing jurisdiction</text>
</error>
</xsl:if>
<xsl:if test="current()[fpml:swbJurisdiction/text()!='DoddFrank'][fpml:swbSupervisoryBodyCategory]">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** swbSupervisoryBodyCategory not supported for '<xsl:value-of select="fpml:swbJurisdiction"/>' clearing</text>
</error>
</xsl:if>
<xsl:if test="current()[contains(';ASIC;JFSA;MAS;', concat(';', fpml:swbJurisdiction/text(),';'))][fpml:swbPartyExemption]">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** swbPartyExemption cannot be provided for '<xsl:value-of select="fpml:swbJurisdiction"/>'</text>
</error>
</xsl:if>
<xsl:if test="not(contains(';ASIC;CAN;ESMA;FCA;HKMA;JFSA;DoddFrank;MIFID;MAS;', concat(';', fpml:swbJurisdiction/text(),';')))">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** This value:'<xsl:value-of select="fpml:swbJurisdiction"/>' of swbJurisdiction is not in supported list for mandatory clearing - Permitted values: ASIC;CAN;ESMA;FCA;HKMA;JFSA;DoddFrank;MIFID;MAS. </text>
</error>
</xsl:if>
<xsl:if test="current()[fpml:swbJurisdiction/text()='DoddFrank'][not(fpml:swbSupervisoryBodyCategory='BroadBased')]">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** Invalid value: swbSupervisoryBodyCategory not in supported list. Value='<xsl:value-of select="fpml:swbSupervisoryBodyCategory/text()"/>'.</text>
</error>
</xsl:if>
<xsl:choose>
<xsl:when test="current()[fpml:swbJurisdiction/text()='JFSA']">
<xsl:if test="not(parent::node()[local-name()='swbTradeHeader'])">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** Mandatory Clearing details cannot be specified in this context for JFSA</text>
</error>
</xsl:if>
<xsl:variable name="MandatoryClearingIndicator">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbTradeHeader/fpml:swbMandatoryClearing/fpml:swbMandatoryClearingIndicator"/>
</xsl:variable>
<xsl:if test="$productType='IRS'">
<xsl:variable name="floatingRateIndex">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails//fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:floatingRateIndex"/>
</xsl:variable>
<xsl:variable name="FloatingRollFreq">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails//fpml:FpML/fpml:trade//fpml:swap/fpml:swbapStream[position()=$floatingLeg]/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:periodMultiplier"/>
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails//fpml:FpML/fpml:trade//fpml:swap/fpml:swbapStream[position()=$floatingLeg]/fpml:calculationPeriodDates/fpml:calculationPeriodFrequency/fpml:period"/>
</xsl:variable>
<xsl:if test="($MandatoryClearingIndicator='true' or $MandatoryClearingIndicator='false') and $productType='IRS'">
<xsl:if test="not($productType='IRS' and $tradeCurrency='JPY' and ($floatingRateIndex='JPY-LIBOR-BBA' or $floatingRateIndex='JPY-LIBOR' or $floatingRateIndex='JPY-TIBOR-ZTIBOR' or $floatingRateIndex='JPY-ZTIBOR' ) and ($FloatingRollFreq='3M' or $FloatingRollFreq='6M') )">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** For JFSA, swbMandatoryClearingIndicator can only be set for an IRS where the trade currency is JPY, Floating Rate Index is JPY-LIBOR-BBA or JPY-LIBOR and the Floating Roll Frequency is either 3M or 6M</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
<xsl:if test="$productType='Single Currency Basis swap'">
<xsl:variable name="floatingRateIndex1">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails//fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:floatingRateIndex"/>
</xsl:variable>
<xsl:variable name="floatingRateIndex2">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails//fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$floatingLeg2]/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:floatingRateIndex"/>
</xsl:variable>
<xsl:variable name="DesignatedMaturity1">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails//fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:indexTenor/fpml:periodMultiplier"/>
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails//fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$floatingLeg]/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:indexTenor/fpml:period"/>
</xsl:variable>
<xsl:variable name="DesignatedMaturity2">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails//fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$floatingLeg2]/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:indexTenor/fpml:periodMultiplier"/>
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails//fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=$floatingLeg2]/fpml:calculationPeriodAmount/fpml:calculation/fpml:floatingRateCalculation/fpml:indexTenor/fpml:period"/>
</xsl:variable>
<xsl:if test="($MandatoryClearingIndicator='true' or $MandatoryClearingIndicator='false') and $productType='Single Currency Basis Swap'">
<xsl:if test="not($productType='Single Currency Basis Swap' and $tradeCurrency='JPY' and ($floatingRateIndex1='JPY-LIBOR-BBA' or $floatingRateIndex1='JPY-LIBOR')and ($floatingRateIndex2='JPY-LIBOR-BBA' or $floatingRateIndex2='JPY-LIBOR') and ($DesignatedMaturity1='3M' or $DesignatedMaturity1='6M') and ($DesignatedMaturity2='3M' or $DesignatedMaturity2='6M'))">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** For JFSA, swbMandatoryClearingIndicator can only be set for a Single Currency Basis swap where the trade currency is JPY, Floating Rate Index 1 is JPY-LIBOR-BBA/JPY-LIBOR, Floating Rate Index 2 is JPY-LIBOR-BBA/JPY-LIBOR, Designated Maturity 1 is either 3M or 6M and Designated Maturity 2 is either 3M or 6M</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
</xsl:when>
<xsl:otherwise>
<xsl:if test="parent::node()[local-name()='swbTradeHeader']">
<xsl:if test="/fpml:SWBML/fpml:swbTradeEventReportingDetails/fpml:swbReportingRegimeInformation[fpml:swbJurisdiction/text()=current()/fpml:swbJurisdiction/text()]/fpml:swbMandatoryClearingIndicator">
<xsl:if test="not(/fpml:SWBML/fpml:swbTradeEventReportingDetails/fpml:swbReportingRegimeInformation[fpml:swbJurisdiction/text()=current()/fpml:swbJurisdiction/text()]/fpml:swbMandatoryClearingIndicator = current()/fpml:swbMandatoryClearingIndicator)">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** Different values have been specified for swbMandatoryClearingIndicator in reporting and clearing sections for jurisdiction '<xsl:value-of select="fpml:Jurisdiction"/>'.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
</xsl:otherwise>
</xsl:choose>
<xsl:if test="current()[fpml:swbInterAffiliateExemption]">
<xsl:if test="not(current()[fpml:swbJurisdiction/text()='DoddFrank'])">
<xsl:if test="not(current()[fpml:swbSupervisoryBodyCategory/text()='BroadBased'])">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** May only provide a value for swbInterAffiliateExemption under CFTC (swbJurisdiction='DoddFrank' and swbSupervisoryBodyCategory='BroadBased'), value of '<xsl:value-of select="fpml:swbInterAffiliateExemption"/>' has been provided under jurisdiction '<xsl:value-of select="fpml:swbJurisdiction"/>'.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:swbBusinessConductDetails">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:apply-templates select="fpml:swbMidMarketPrice">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:swbMidMarketPrice">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="fpml:swbUnit">
<xsl:choose>
<xsl:when test="fpml:swbUnit/text()='Price'"/>
<xsl:when test="fpml:swbUnit/text()='BasisPoints'"/>
<xsl:when test="fpml:swbUnit/text()='Percentage'"/>
<xsl:when test="fpml:swbUnit/text()='Level'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** Invalid value submitted for <xsl:value-of select="local-name()"/>/fpml:swbUnit Value = '<xsl:value-of select="fpml:swbUnit/text()"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test=" fpml:swbAmount and (string(number(fpml:swbAmount/text())) ='NaN' or contains(fpml:swbAmount/text(),'e') or  contains(fpml:swbAmount/text(),'E'))">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** Invalid value submitted for <xsl:value-of select="local-name()"/>/swbAmount Value = '<xsl:value-of select="fpml:swbAmount/text()"/>'.</text>
</error>
</xsl:if>
<xsl:call-template name="isValidMidMarketAmount">
<xsl:with-param name="elementName">fpml:swbAmount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swbAmount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">-9999999999.99999999</xsl:with-param>
<xsl:with-param name="maxIncl">9999999999.99999999</xsl:with-param>
<xsl:with-param name="maxDecs">8</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="not(string-length(fpml:swbUnit) &gt; 0) and (fpml:swbCurrency or fpml:swbAmount)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***Mid-Market Price Type is required.</text>
</error>
</xsl:if>
<xsl:if test="string-length(fpml:swbUnit) &gt; 0 and not (fpml:swbCurrency) and not (fpml:swbAmount)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***Mid-Market Price Value is required.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swbUnit/text() = 'Price' and  fpml:swbCurrency and not(fpml:swbAmount)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***Mid-Market Price Value is required.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:swbUnit/text() = 'Price') and string-length(fpml:swbUnit) &gt; 0 and string-length(fpml:swbCurrency) &gt; 0">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***Mid-Market Price Currency not allowed for type.</text>
</error>
</xsl:if>
<xsl:if test=" fpml:swbUnit/text()= 'Price' and fpml:swbAmount and not(string-length(fpml:swbCurrency) &gt; 0)">
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
<xsl:template match="fpml:swbTradePackageHeader">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:choose>
<xsl:when test="$productType='SingleCurrencyInterestRateSwap'"/>
<xsl:when test="$productType='Single Currency Basis Swap'"/>
<xsl:when test="$productType='FRA'"/>
<xsl:when test="$productType='OIS'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** Package trades is not supported for the <xsl:value-of select="$productType"/> product type.</text>
</error>
</xsl:otherwise>
</xsl:choose>
<xsl:if test="($isAllocatedTrade='1') or ($isEmptyBlockTrade='1')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Allocations are not allowed on package trades.</text>
</error>
</xsl:if>
<xsl:choose>
<xsl:when test="fpml:swbPackageIdentifier">
<xsl:choose>
<xsl:when test="fpml:swbPackageIdentifier/fpml:swbIssuer"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swbPackageIdentifier/swbIssuer.</text>
</error>
</xsl:otherwise>
</xsl:choose>
<xsl:choose>
<xsl:when test="fpml:swbPackageIdentifier/fpml:swbTradeId"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swbPackageIdentifier/swbTradeId.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swbPackageIdentifier.</text>
</error>
</xsl:otherwise>
</xsl:choose>
<xsl:choose>
<xsl:when test="fpml:swbSize"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swbSize.</text>
</error>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="fpml:swbPackageIdentifier">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:swbSize">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:swbPartyCreditAcceptanceToken">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:swbPackageIdentifier">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:apply-templates select="fpml:swbIssuer">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:swbTradeId">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:swbIssuer">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
</xsl:template>
<xsl:template match="fpml:swbTradeId">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
</xsl:template>
<xsl:template match="fpml:swbSize">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="pkgSize"><xsl:value-of select="."/></xsl:variable>
<xsl:if test="$pkgSize &lt; 2">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** Package trade size should be 2 or greater. Actual = '<xsl:value-of select="$pkgSize"/>'.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:swbPartyCreditAcceptanceToken">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
</xsl:template>
</xsl:stylesheet>
