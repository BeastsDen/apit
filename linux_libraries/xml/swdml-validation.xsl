<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:common="http://exslt.org/common">
<xsl:import href="CrossAssetValidation.xsl" />
<xsl:import href="swdml-validation-reporting.xsl"/>
<xsl:variable name="reportingData.rtf">
<xsl:apply-templates select="/SWDML/swTradeEventReportingDetails" mode="mapReportingData"/>
<xsl:apply-templates select="/SWDML/swLongFormTrade/swAllocations/node()" mode="mapReportingData"/>
<xsl:apply-templates select="/SWDML/swLongFormTrade/novation/swNovationExecutionUniqueTransactionId" mode="mapReportingData"/>
</xsl:variable>
<xsl:template match="swAllocation" mode="mapReportingData">
<swAllocation>
<xsl:apply-templates select ="swAllocationReportingDetails" mode="mapReportingData"/>
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
<xsl:attribute name="{local-name()}"><xsl:value-of select="."/></xsl:attribute>
</xsl:template>
<xsl:template match="/">
<xsl:apply-templates select="SWDML" mode="get-reporting-data"/>
</xsl:template>
<xsl:template match="/SWDML[function-available('common:node-set')]" mode="get-reporting-data">
<xsl:apply-templates select=".">
<xsl:with-param name="reportingData" select="common:node-set($reportingData.rtf)"/>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="/SWDML[not(function-available('common:node-set'))]" mode="get-reporting-data">
<xsl:apply-templates select=".">
<xsl:with-param name="reportingData" select="$reportingData.rtf"/>
</xsl:apply-templates>
</xsl:template>
<xsl:variable name="version">
<xsl:value-of select="/SWDML/@version"/>
</xsl:variable>
<xsl:variable name="assetClass">Rates</xsl:variable>
<xsl:variable name="productType">
<xsl:choose>
<xsl:when test="/SWDML/swShortFormTrade/swFraParameters">FRA</xsl:when>
<xsl:when test="/SWDML/swShortFormTrade/swOisParameters">OIS</xsl:when>
<xsl:when test="/SWDML/swShortFormTrade/swIrsParameters">IRS</xsl:when>
<xsl:when test="/SWDML/swShortFormTrade/swSwaptionParameters">Swaption</xsl:when>
<xsl:when test="/SWDML/swShortFormTrade/swCapFloorParameters">CapFloor</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails[swProductType='SingleCurrencyInterestRateSwap']">IRS</xsl:when>
<xsl:otherwise>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swProductType"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="productSubType">
<xsl:choose>
<xsl:when test="/SWDML/swShortFormTrade and ($productType='IRS' or $productType='OIS')">
<xsl:value-of select="/SWDML/swShortFormTrade//swProductSubType"/>
</xsl:when>
</xsl:choose>
</xsl:variable>
<xsl:variable name="fixedLeg">
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[1]/resetDates">2</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[1]/resetDates">2</xsl:when>
<xsl:otherwise>1</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="floatingLeg">
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[1]/resetDates">1</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/capFloor">1</xsl:when>
<xsl:otherwise>2</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="tradeCurrency">
<xsl:choose>
<xsl:when test="/SWDML/swShortFormTrade">
<xsl:value-of select="/SWDML/swShortFormTrade//notional/currency"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//fra/notional/currency"/>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/calculationPeriodAmount/calculation/notionalSchedule/notionalStepSchedule/currency"/>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//capFloorStream/calculationPeriodAmount/calculation/notionalSchedule/notionalStepSchedule/currency"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="isOIScurrency">
<xsl:choose>
<xsl:when test="($tradeCurrency='AUD' or $tradeCurrency='CAD' or $tradeCurrency='CHF' or $tradeCurrency='COP' or $tradeCurrency='DKK' or $tradeCurrency='EUR' or $tradeCurrency='GBP' or $tradeCurrency='HKD' or $tradeCurrency='INR' or $tradeCurrency='JPY' or $tradeCurrency='NOK' or $tradeCurrency='NZD' or $tradeCurrency='PLN' or $tradeCurrency='SEK' or $tradeCurrency='SGD' or $tradeCurrency='THB' or $tradeCurrency='TRY' or $tradeCurrency='USD')">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="isOISIndex">
<xsl:variable name="friValue">
<xsl:value-of select="//swapStream[position()=$floatingLeg]/calculationPeriodAmount/calculation/floatingRateCalculation/floatingRateIndex | //capFloorStream/calculationPeriodAmount/calculation/floatingRateCalculation/floatingRateIndex"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="(string-length(substring-before($friValue,'-OIS')) > 0) or ($friValue='GBP-SONIA-COMPOUND' or $friValue='USD-DTCC GCF Repo Index-Treasury-Bloomberg-COMPOUND' or $friValue='USD-SOFR-COMPOUND' or $friValue='EUR-EuroSTR-COMPOUND' or $friValue='SGD-SORA-COMPOUND' or $friValue='GBP-WMBA-SONIA-COMPOUND' or $friValue='GBP-WMBA-RONIA-COMPOUND' or $friValue='THB-THOR-COMPOUND')">true</xsl:when>
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
<xsl:variable name="fixedPaymentFreq">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$fixedLeg]/paymentDates/paymentFrequency/periodMultiplier"/>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$fixedLeg]/paymentDates/paymentFrequency/period"/>
</xsl:variable>
<xsl:variable name="floatPaymentFreq">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/paymentDates/paymentFrequency/periodMultiplier"/>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/paymentDates/paymentFrequency/period"/>
</xsl:variable>
<xsl:variable name="FixedAmount">
<xsl:if test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$fixedLeg]/calculationPeriodAmount/knownAmountSchedule">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$fixedLeg]/calculationPeriodAmount/knownAmountSchedule/initialValue"/>
</xsl:if>
</xsl:variable>
<xsl:variable name="FixedNotional">
<xsl:if test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$fixedLeg]/calculationPeriodAmount/calculation">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$fixedLeg]/calculationPeriodAmount/calculation/initialValue"/>
</xsl:if>
</xsl:variable>
<xsl:variable name="interestRateSwapType">
<xsl:choose>
<xsl:when test="(($productType='IRS' or $productType='OIS' or $isOISonSwaption='true') and $fixedPaymentFreq = '1T' and /SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$fixedLeg]/calculationPeriodAmount/knownAmountSchedule and /SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/calculationPeriodAmount/calculation )">
<xsl:value-of select="'zeroCouponInterestRateSwapWithFixedAmount'"/>
</xsl:when>
<xsl:when test="(($productType='IRS' or $productType='OIS' or $isOISonSwaption='true') and $fixedPaymentFreq = '1T' and
/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/calculationPeriodAmount/calculation and /SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$fixedLeg]/calculationPeriodAmount/calculation)">
<xsl:value-of select="'zeroCouponInterestRateSwapWithFixedNotional'"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="'someOtherInterestRateProduct'"/>
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
<xsl:when test="/SWDML/swShortFormTrade">
<xsl:value-of select="/SWDML/swShortFormTrade/swParticipantSupplement"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swParticipantSupplement"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="isLongFormTrade">
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade">1</xsl:when>
<xsl:otherwise>0</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="isPrimeBrokerTrade">
<xsl:choose>
<xsl:when test="/SWDML//swGiveUp">1</xsl:when>
<xsl:otherwise>0</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="isNovationTrade">
<xsl:choose>
<xsl:when test="/SWDML//novation">1</xsl:when>
<xsl:otherwise>0</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="isAllocatedTrade">
<xsl:choose>
<xsl:when test="/SWDML//swAllocations">1</xsl:when>
<xsl:otherwise>0</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="blockAdditionalPaymentCount">
<xsl:value-of select="count(/SWDML//swStructuredTradeDetails//additionalPayment)"/>
</xsl:variable>
<xsl:variable name="isBlockIndependentAmountPresent">
<xsl:for-each select="/SWDML//swStructuredTradeDetails//additionalPayment">
<xsl:choose>
<xsl:when test="paymentType='Independent Amount'">true</xsl:when>
</xsl:choose>
</xsl:for-each>
</xsl:variable>
<xsl:variable name="test1">
<xsl:choose>
<xsl:when test="/SWDML//swStructuredTradeDetails//additionalPayment[position()=1] and (not(/SWDML//swStructuredTradeDetails//additionalPayment[position()=1]/paymentType) or /SWDML//swStructuredTradeDetails//additionalPayment[position()=1]/paymentType !='Independent Amount')">1</xsl:when>
<xsl:otherwise>0</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="test2">
<xsl:choose>
<xsl:when test="/SWDML//swStructuredTradeDetails//additionalPayment[position()=2] and (not(/SWDML//swStructuredTradeDetails//additionalPayment[position()=2]/paymentType) or /SWDML//swStructuredTradeDetails//additionalPayment[position()=2]/paymentType !='Independent Amount')">1</xsl:when>
<xsl:otherwise>0</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="test3">
<xsl:choose>
<xsl:when test="/SWDML//swStructuredTradeDetails//additionalPayment[position()=3] and (not(/SWDML//swStructuredTradeDetails//additionalPayment[position()=3]/paymentType) or /SWDML//swStructuredTradeDetails//additionalPayment[position()=3]/paymentType !='Independent Amount')">1</xsl:when>
<xsl:otherwise>0</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="test4">
<xsl:choose>
<xsl:when test="/SWDML//swStructuredTradeDetails//additionalPayment[position()=4] and (not(/SWDML//swStructuredTradeDetails//additionalPayment[position()=4]/paymentType) or /SWDML//swStructuredTradeDetails//additionalPayment[position()=4]/paymentType !='Independent Amount')">1</xsl:when>
<xsl:otherwise>0</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="test5">
<xsl:choose>
<xsl:when test="/SWDML//swStructuredTradeDetails//additionalPayment[position()=5] and (not(/SWDML//swStructuredTradeDetails//additionalPayment[position()=5]/paymentType) or /SWDML//swStructuredTradeDetails//additionalPayment[position()=5]/paymentType !='Independent Amount')">1</xsl:when>
<xsl:otherwise>0</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="test6">
<xsl:choose>
<xsl:when test="/SWDML//swStructuredTradeDetails//additionalPayment[position()=6] and (not(/SWDML//swStructuredTradeDetails//additionalPayment[position()=6]/paymentType) or /SWDML//swStructuredTradeDetails//additionalPayment[position()=6]/paymentType !='Independent Amount')">1</xsl:when>
<xsl:otherwise>0</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="test7">
<xsl:choose>
<xsl:when test="/SWDML//swStructuredTradeDetails//additionalPayment[position()=7] and (not(/SWDML//swStructuredTradeDetails//additionalPayment[position()=7]/paymentType) or /SWDML//swStructuredTradeDetails//additionalPayment[position()=7]/paymentType !='Independent Amount')">1</xsl:when>
<xsl:otherwise>0</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="blockAdditionalPayCurrency1">
<xsl:choose>
<xsl:when test="$test1">
<xsl:value-of select="/SWDML//swStructuredTradeDetails//additionalPayment[position()=1]/paymentAmount/currency"/>
</xsl:when>
<xsl:when test="$test2">
<xsl:value-of select="/SWDML//swStructuredTradeDetails//additionalPayment[position()=2]/paymentAmount/currency"/>
</xsl:when>
<xsl:when test="$test3">
<xsl:value-of select="/SWDML//swStructuredTradeDetails//additionalPayment[position()=3]/paymentAmount/currency"/>
</xsl:when>
</xsl:choose>
</xsl:variable>
<xsl:variable name="blockAdditionalPayUnadjDate1">
<xsl:choose>
<xsl:when test="$test1">
<xsl:value-of select="/SWDML//swStructuredTradeDetails//additionalPayment[position()=1]/paymentDate/unadjustedDate"/>
</xsl:when>
<xsl:when test="$test2">
<xsl:value-of select="/SWDML//swStructuredTradeDetails//additionalPayment[position()=2]/paymentDate/unadjustedDate"/>
</xsl:when>
<xsl:when test="$test3">
<xsl:value-of select="/SWDML//swStructuredTradeDetails//additionalPayment[position()=3]/paymentDate/unadjustedDate"/>
</xsl:when>
</xsl:choose>
</xsl:variable>
<xsl:variable name="blockAdditionalPayConvention1">
<xsl:choose>
<xsl:when test="$test1">
<xsl:value-of select="/SWDML//swStructuredTradeDetails//additionalPayment[position()=1]/paymentDate/dateAdjustments/businessDayConvention"/>
</xsl:when>
<xsl:when test="$test2">
<xsl:value-of select="/SWDML//swStructuredTradeDetails//additionalPayment[position()=2]/paymentDate/dateAdjustments/businessDayConvention"/>
</xsl:when>
<xsl:when test="$test3">
<xsl:value-of select="/SWDML//swStructuredTradeDetails//additionalPayment[position()=3]/paymentDate/dateAdjustments/businessDayConvention"/>
</xsl:when>
</xsl:choose>
</xsl:variable>
<xsl:variable name="blockAdditionalPayBusCenters1">
<xsl:choose>
<xsl:when test="$test1">
<xsl:for-each select="/SWDML//swStructuredTradeDetails//additionalPayment[position()=1]/paymentDate/dateAdjustments/businessCenters/businessCenter">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:when>
<xsl:when test="$test2">
<xsl:for-each select="/SWDML//swStructuredTradeDetails//additionalPayment[position()=2]/paymentDate/dateAdjustments/businessCenters/businessCenter">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:when>
<xsl:when test="$test3">
<xsl:for-each select="/SWDML//swStructuredTradeDetails//additionalPayment[position()=3]/paymentDate/dateAdjustments/businessCenters/businessCenter">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:when>
</xsl:choose>
</xsl:variable>
<xsl:variable name="blockAdditionalPayType1">
<xsl:choose>
<xsl:when test="$test1">
<xsl:value-of select="/SWDML//swStructuredTradeDetails//additionalPayment[position()=1]/paymentType"/>
</xsl:when>
<xsl:when test="$test2">
<xsl:value-of select="/SWDML//swStructuredTradeDetails//additionalPayment[position()=2]/paymentType"/>
</xsl:when>
<xsl:when test="$test3">
<xsl:value-of select="/SWDML//swStructuredTradeDetails//additionalPayment[position()=3]/paymentType"/>
</xsl:when>
</xsl:choose>
</xsl:variable>
<xsl:variable name="blockAdditionalPayCurrency2">
<xsl:choose>
<xsl:when test="$test2">
<xsl:value-of select="/SWDML//swStructuredTradeDetails//additionalPayment[position()=2]/paymentAmount/currency"/>
</xsl:when>
<xsl:when test="$test3">
<xsl:value-of select="/SWDML//swStructuredTradeDetails//additionalPayment[position()=3]/paymentAmount/currency"/>
</xsl:when>
</xsl:choose>
</xsl:variable>
<xsl:variable name="blockAdditionalPayUnadjDate2">
<xsl:choose>
<xsl:when test="$test2">
<xsl:value-of select="/SWDML//swStructuredTradeDetails//additionalPayment[position()=2]/paymentDate/unadjustedDate"/>
</xsl:when>
<xsl:when test="$test3">
<xsl:value-of select="/SWDML//swStructuredTradeDetails//additionalPayment[position()=3]/paymentDate/unadjustedDate"/>
</xsl:when>
</xsl:choose>
</xsl:variable>
<xsl:variable name="blockAdditionalPayConvention2">
<xsl:choose>
<xsl:when test="$test2">
<xsl:value-of select="/SWDML//swStructuredTradeDetails//additionalPayment[position()=2]/paymentDate/dateAdjustments/businessDayConvention"/>
</xsl:when>
<xsl:when test="$test3">
<xsl:value-of select="/SWDML//swStructuredTradeDetails//additionalPayment[position()=3]/paymentDate/dateAdjustments/businessDayConvention"/>
</xsl:when>
</xsl:choose>
</xsl:variable>
<xsl:variable name="blockAdditionalPayBusCenters2">
<xsl:choose>
<xsl:when test="$test2">
<xsl:for-each select="/SWDML//swStructuredTradeDetails//additionalPayment[position()=2]/paymentDate/dateAdjustments/businessCenters/businessCenter">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:when>
<xsl:when test="$test3">
<xsl:for-each select="/SWDML//swStructuredTradeDetails//additionalPayment[position()=3]/paymentDate/dateAdjustments/businessCenters/businessCenter">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:when>
</xsl:choose>
</xsl:variable>
<xsl:variable name="blockAdditionalPayType2">
<xsl:choose>
<xsl:when test="$test2">
<xsl:value-of select="/SWDML//swStructuredTradeDetails//additionalPayment[position()=2]/paymentType"/>
</xsl:when>
<xsl:when test="$test3">
<xsl:value-of select="/SWDML//swStructuredTradeDetails//additionalPayment[position()=3]/paymentType"/>
</xsl:when>
</xsl:choose>
</xsl:variable>
<xsl:variable name="blockIndependentAmountCurrency">
<xsl:for-each select="/SWDML//swStructuredTradeDetails//additionalPayment">
<xsl:choose>
<xsl:when test="paymentType='Independent Amount'">
<xsl:value-of select="paymentAmount/currency"/>
</xsl:when>
</xsl:choose>
</xsl:for-each>
</xsl:variable>
<xsl:template match="swGiveUp">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:variable name="hrefC">
<xsl:value-of select="swCustomerTransaction/swCustomer/@href"/>
</xsl:variable>
<xsl:variable name="hrefD">
<xsl:value-of select="swInterDealerTransaction/swExecutingDealer/@href"/>
</xsl:variable>
<xsl:variable name="hrefCPB">
<xsl:value-of select="swCustomerTransaction/swPrimeBroker/@href"/>
</xsl:variable>
<xsl:variable name="hrefDPB">
<xsl:value-of select="swInterDealerTransaction/swPrimeBroker/@href"/>
</xsl:variable>
<xsl:variable name="hrefG">
<xsl:value-of select="swExecutingDealerCustomerTransaction/swExecutingDealer/@href"/>
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
<text>*** swExecutingDealerCustomerTransaction/swExecutingDealer/@href and swCustomerTransaction/swCustomer/@href values must not be the same.</text>
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
<xsl:if test="swExecutingDealerCustomerTransaction">
<xsl:if test="not(//FpML/trade/party[@id=substring-after($hrefG,'#')])">
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
<xsl:if test="not(//FpML/trade/party[@id=substring-after($hrefC,'#')])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swCustomerTransaction/swCustomer/@href does not reference a valid //FpML/trade/party/@id. Value = '<xsl:value-of select="$hrefC"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not(//FpML/trade/party[@id=substring-after($hrefCPB,'#')])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swCustomerTransaction/swPrimeBroker/@href does not reference a valid //FpML/trade/party/@id. Value = '<xsl:value-of select="$hrefCPB"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not(//FpML/trade/party[@id=substring-after($hrefD,'#')])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swInterDealerTransaction/swExecutingDealer/@href does not reference a valid //FpML/trade/party/@id. Value = '<xsl:value-of select="$hrefD"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not(//FpML/trade/party[@id=substring-after($hrefDPB,'#')])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swInterDealerTransaction/swPrimeBroker/@href does not reference a valid //FpML/trade/party/@id. Value = '<xsl:value-of select="$hrefDPB"/>'.</text>
</error>
</xsl:if>
<xsl:if test="$isAllocatedTrade = 0">
<xsl:if test="$hrefDPB=$hrefCPB and not(swExecutingDealerCustomerTransaction)">
<xsl:if test="count(//FpML/trade/party) &lt; 3">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of party child elements encountered. 3 expected.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$hrefDPB!=$hrefCPB and not(swExecutingDealerCustomerTransaction)">
<xsl:if test="count(//FpML/trade/party) &lt; 4">
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
<xsl:if test="$hrefDPB=$hrefCPB and not(swExecutingDealerCustomerTransaction)">
<xsl:if test="count(//FpML/trade/party) &lt; 3">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of party child elements encountered. At least 3 expected.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$hrefDPB!=$hrefCPB and not(swExecutingDealerCustomerTransaction)">
<xsl:if test="count(//FpML/trade/party) &lt; 4">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of party child elements encountered. At least 4 expected.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
<xsl:if test="$productType = 'OIS' or $productType = 'IRS' or $productType='Swaption'">
<xsl:if test="($hrefD != //FpML/trade//swap/swapStream[position()=$floatingLeg]/payerPartyReference/@href) and ($hrefD != //FpML/trade//swap/swapStream[position()=$floatingLeg]/receiverPartyReference/@href)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swInterDealerTransaction/swExecutingDealer/@href must be a payer or receiver on swap if product type is 'SingleCurrencyInterestRateSwap', 'OIS' or 'Swaption'.</text>
</error>
</xsl:if>
<xsl:if test="($hrefC != //FpML/trade//swap/swapStream[position()=$floatingLeg]/receiverPartyReference/@href) and ($hrefC != //FpML/trade//swap/swapStream[position()=$floatingLeg]/payerPartyReference/@href)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swCustomerTransaction/swCustomer/@href must be a payer or receiver on swap if product type is 'SingleCurrencyInterestRateSwap', 'OIS' or 'Swaption'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$productType = 'FRA'">
<xsl:if test="($hrefD != //FpML/trade/fra/buyerPartyReference/@href) and ($hrefD != //FpML/trade/fra/sellerPartyReference/@href)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swInterDealerTransaction/swExecutingDealer/@href must be a buyer or seller on FRA if product type is 'FRA'.</text>
</error>
</xsl:if>
<xsl:if test="($hrefC != //FpML/trade/fra/sellerPartyReference/@href) and ($hrefC != //FpML/trade/fra/buyerPartyReference/@href)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swCustomerTransaction/swCustomer/@href must be a buyer or seller on FRA if product type is 'FRA'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$productType = 'IRS' or $productType='Swaption' or $productType='OIS'">
<xsl:if test=".//swEarlyTerminationProvision">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** .//swEarlyTerminationProvision must not be specified in a Primary Prime Brokered Trade.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="node()/swMandatoryClearing">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="swAllocations">
<xsl:param name="context"/>
<xsl:param name="reportingData"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:apply-templates select="swAllocation">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
<xsl:with-param name="reportingData" select="$reportingData"/>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="swAllocation">
<xsl:param name="context"/>
<xsl:param name="reportingData"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:apply-templates select="allocatedNotional">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:variable name="AddPayNumber">
<xsl:value-of select="count(additionalPayment)"/>
</xsl:variable>
<xsl:if test="$AddPayNumber>2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of additionalPayment child elements encountered. 0 to 2 expected.</text>
</error>
</xsl:if>
<xsl:if test="($blockAdditionalPaymentCount=2 and $isBlockIndependentAmountPresent='true' and $AddPayNumber>1) or ($blockAdditionalPaymentCount=1 and $isBlockIndependentAmountPresent='true' and $AddPayNumber>0) or ($blockAdditionalPaymentCount=1 and $isBlockIndependentAmountPresent!='true' and $AddPayNumber>1) or ($blockAdditionalPaymentCount=0 and $AddPayNumber>0)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** There must not be more additionalPayment child elements in swAllocation than in the block trade.</text>
</error>
</xsl:if>
<xsl:if test="swStreamReference and not(swStreamReference/@href='#fixedLeg')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swStreamReference must reference fixed leg ***</text>
</error>
</xsl:if>
<xsl:if test="$productType = 'OIS' or $productType = 'IRS'">
<xsl:if test="not(swStreamReference)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swStreamReference must be present if product type is 'SingleCurrencyInterestRateSwap' or 'OIS'.</text>
</error>
</xsl:if>
<xsl:variable name="payerPartyRef">
<xsl:value-of select="substring-after(payerPartyReference/@href,'#')"/>
</xsl:variable>
<xsl:variable name="receiverPartyRef">
<xsl:value-of select="substring-after(receiverPartyReference/@href,'#')"/>
</xsl:variable>
<xsl:if test="$payerPartyRef=$receiverPartyRef">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** payerPartyReference/@href and receiverPartyReference/@href values must not be the same.</text>
</error>
</xsl:if>
<xsl:if test="not(//FpML/trade/party[@id=$payerPartyRef])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** payerPartyReference/@href does not reference a valid //FpML/trade/party/@id. Value = '<xsl:value-of select="$payerPartyRef"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not(//FpML/trade/party[@id=$receiverPartyRef])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** receiverPartyReference/@href does not reference a valid //FpML/trade/party/@id. Value = '<xsl:value-of select="$receiverPartyRef"/>'.</text>
</error>
</xsl:if>
<xsl:variable name="payerPartyId">
<xsl:value-of select="//FpML/trade/party[@id=$payerPartyRef]/partyId"/>
</xsl:variable>
<xsl:variable name="receiverPartyId">
<xsl:value-of select="//FpML/trade/party[@id=$receiverPartyRef]/partyId"/>
</xsl:variable>
<xsl:if test="$payerPartyId=$receiverPartyId">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** partyId (legal entity) referenced by payerPartyReference/@href must not equal partyId (legal entity) referenced by receiverPartyReference/@href.</text>
</error>
</xsl:if>
<xsl:if test="swIAExpected = 'true' and not(independentAmount)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***  independentAmount element must be present if swIAExpected flag is set to true</text>
</error>
</xsl:if>
<xsl:if test="swIAExpected = 'true' and independentAmount/paymentDetail/paymentAmount/amount != 0">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***  independentAmount must be zero if swIAExpected flag is set to true</text>
</error>
</xsl:if>
<xsl:apply-templates select="independentAmount">
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
<xsl:apply-templates mode="allocation" select="additionalPayment">
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
<xsl:if test="not(buyerPartyReference)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** buyerPartyReference must be present if product type is 'Swaption' or 'FRA' or 'CapFloor'.</text>
</error>
</xsl:if>
<xsl:variable name="buyerPartyRef">
<xsl:value-of select="substring-after(buyerPartyReference/@href,'#')"/>
</xsl:variable>
<xsl:variable name="sellerPartyRef">
<xsl:value-of select="substring-after(sellerPartyReference/@href,'#')"/>
</xsl:variable>
<xsl:if test="$buyerPartyRef=$sellerPartyRef">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** buyerPartyReference/@href and sellerPartyReference/@href values must not be the same.</text>
</error>
</xsl:if>
<xsl:if test="not(//FpML/trade/party[@id=$buyerPartyRef])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** buyerPartyReference/@href does not reference a valid //FpML/trade/party/@id. Value = '<xsl:value-of select="$buyerPartyRef"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not(//FpML/trade/party[@id=$sellerPartyRef])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** sellerPartyReference/@href does not reference a valid //FpML/trade/party/@id. Value = '<xsl:value-of select="$sellerPartyRef"/>'.</text>
</error>
</xsl:if>
<xsl:variable name="buyerPartyId">
<xsl:value-of select="//FpML/trade/party[@id=$buyerPartyRef]/partyId"/>
</xsl:variable>
<xsl:variable name="sellerPartyId">
<xsl:value-of select="//FpML/trade/party[@id=$sellerPartyRef]/partyId"/>
</xsl:variable>
<xsl:if test="$buyerPartyId=$sellerPartyId">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** partyId (legal entity) referenced by buyerPartyReference/@href must not equal partyId (legal entity) referenced by sellerPartyReference/@href.</text>
</error>
</xsl:if>
<xsl:if test="swIAExpected = 'true' and not(independentAmount)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***  independentAmount element must be present if swIAExpected flag is set to true</text>
</error>
</xsl:if>
<xsl:if test="swIAExpected = 'true' and independentAmount/paymentDetail/paymentAmount/amount != 0">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***  independentAmount must be zero if swIAExpected flag is set to true</text>
</error>
</xsl:if>
<xsl:apply-templates select="independentAmount">
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
<xsl:apply-templates mode="allocation" select="additionalPayment">
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
<xsl:if test="swSalesCredit">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swSalesCredit</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="swSalesCredit"/>
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
<xsl:template match="allocatedNotional">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:variable name="allocatedNotionalCurrency">
<xsl:value-of select="currency"/>
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
<xsl:value-of select="currency"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:variable name="amount">
<xsl:value-of select="amount"/>
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
<xsl:template match="independentAmount">
<xsl:param name="context"/>
<xsl:param name="allocPartyA"/>
<xsl:param name="allocPartyB"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:variable name="payerPartyRef">
<xsl:value-of select="substring-after(payerPartyReference/@href,'#')"/>
</xsl:variable>
<xsl:variable name="receiverPartyRef">
<xsl:value-of select="substring-after(receiverPartyReference/@href,'#')"/>
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
<xsl:apply-templates select="paymentDetail">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="paymentDetail">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:apply-templates select="independentAmount/paymentDetail/paymentAmount">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:variable name="currency">
<xsl:value-of select="paymentAmount/currency"/>
</xsl:variable>
<xsl:if test="$currency!=$blockIndependentAmountCurrency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** paymentAmount/currency must equal the block trade independent amount currency.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template mode="allocation" match="additionalPayment">
<xsl:param name="context"/>
<xsl:param name="allocPartyA"/>
<xsl:param name="allocPartyB"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:if test="paymentType != 'CancellablePremium' and not(@seq)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing @seq attribute. Required in this context.</text>
</error>
</xsl:if>
<xsl:variable name="payerPartyRef">
<xsl:value-of select="substring-after(payerPartyReference/@href,'#')"/>
</xsl:variable>
<xsl:variable name="receiverPartyRef">
<xsl:value-of select="substring-after(receiverPartyReference/@href,'#')"/>
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
<xsl:apply-templates select="paymentAmount">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="not(paymentDate)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing paymentDate. Required in this context.</text>
</error>
</xsl:if>
<xsl:apply-templates select="paymentDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:variable name="allocAdditionalPayCurrency">
<xsl:value-of select="paymentAmount/currency"/>
</xsl:variable>
<xsl:variable name="allocAdditionalPayUnadjDate">
<xsl:value-of select="paymentDate/unadjustedDate"/>
</xsl:variable>
<xsl:variable name="allocAdditionalPayConvention">
<xsl:value-of select="paymentDate/dateAdjustments/businessDayConvention"/>
</xsl:variable>
<xsl:variable name="allocAdditionalPayBusCenters">
<xsl:for-each select="paymentDate/dateAdjustments/businessCenters/businessCenter">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:variable>
<xsl:variable name="allocAdditionalPayType">
<xsl:value-of select="paymentType"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="@seq='1'">
<xsl:if test="$allocAdditionalPayCurrency!=$blockAdditionalPayCurrency1">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** paymentAmount/currency must equal the paymentAmount/currency of the corresponding additional payment on the block trade.</text>
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
<text>*** paymentDate/dateAdjustments/businessCenters must equal the paymentDate/dateAdjustments/businessCenters of the corresponding additional payment on the block trade.</text>
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
<xsl:template match="novation">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:variable name="transferor">
<xsl:value-of select="transferor/@href"/>
</xsl:variable>
<xsl:if test="not(//FpML/trade/party[@id=substring-after($transferor,'#')])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** transferor/@href does not reference a valid //FpML/trade/party/@id. Value = '<xsl:value-of select="$transferor"/>'.</text>
</error>
</xsl:if>
<xsl:variable name="transferee">
<xsl:value-of select="transferee/@href"/>
</xsl:variable>
<xsl:if test="not(//FpML/trade/party[@id=substring-after($transferee,'#')])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** transferee/@href does not reference a valid //FpML/trade/party/@id. Value = '<xsl:value-of select="$transferee"/>'.</text>
</error>
</xsl:if>
<xsl:variable name="remainingParty">
<xsl:value-of select="remainingParty/@href"/>
</xsl:variable>
<xsl:if test="not(//FpML/trade/party[@id=substring-after($remainingParty,'#')])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** remainingParty/@href does not reference a valid //FpML/trade/party/@id. Value = '<xsl:value-of select="$remainingParty"/>'.</text>
</error>
</xsl:if>
<xsl:variable name="otherRemainingParty">
<xsl:value-of select="otherRemainingParty/@href"/>
</xsl:variable>
<xsl:if test="otherRemainingParty">
<xsl:if test="not(//FpML/trade/party[@id=substring-after($otherRemainingParty,'#')])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** otherRemainingParty/@href does not reference a valid //FpML/trade/party/@id. Value = '<xsl:value-of select="$otherRemainingParty"/>'.</text>
</error>
</xsl:if>
<xsl:if test="$remainingParty = $otherRemainingParty">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** otherRemainingParty/@href must not equal remainingParty/@href.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">novationDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="novationDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">novationTradeDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="novationTradeDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:variable name="novationTradeDate">
<xsl:value-of select="novationTradeDate"/>
</xsl:variable>
<xsl:variable name="novationDate">
<xsl:value-of select="novationDate"/>
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
<xsl:if test="not($productType='Swaption') and not($productType='FRA')">
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">fullFirstCalculationPeriod</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fullFirstCalculationPeriod"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="not(novatedAmount)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing novatedAmount. Required in this context.</text>
</error>
</xsl:if>
<xsl:if test="novatedAmount/currency != $tradeCurrency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** novatedAmount/currency must equal trade currency.</text>
</error>
</xsl:if>
<xsl:if test="../novation and $tradeCurrency='BRL'">
<xsl:if test="not(swNovatedFV)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swNovatedAmount. Required in this context.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="not($productType='Offline Trade Rates') and $tradeCurrency = 'BRL'">
<xsl:if test="../novation/swNovatedFV/currency != $tradeCurrency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swNovatedFV/currency must equal trade currency.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$productType='IRS' and swNovatedAmount/amount">
<xsl:if test="swNovatedAmount/currency != $tradeCurrency">
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
<xsl:if test="($productType='IRS' or $productType='Swaption' or $productType='OIS' or $productType='FRA') and number(novatedAmount/amount) > number($tradeNotional)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** novatedAmount/notional must not be greater than trade notional.</text>
</error>
</xsl:if>
<xsl:if test="($productType='CapFloor') and number(novatedAmount/amount) != number($tradeNotional)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** novatedAmount/notional must equal trade notional.</text>
</error>
</xsl:if>
<xsl:apply-templates select="novatedAmount">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:variable name="notionalFutureValue">
<xsl:if test="$productType='IRS' and $tradeCurrency='BRL'">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swFutureValue/swNotionalFutureValue/amount"/>
</xsl:if>
</xsl:variable>
<xsl:if test="$tradeCurrency='BRL' and (number(swNovatedFV/amount) > number($notionalFutureValue))">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Novated Future Value (swNovatedFV)  must not be greater than Future Value (swNotionalFutureValue). Value = '<xsl:value-of select="number(swNovatedFV/amount)"/>'</text>
</error>
</xsl:if>
<xsl:apply-templates select="swNovatedFV">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="$productType='IRS' and /SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$fixedLeg]/calculationPeriodAmount/knownAmountSchedule">
<xsl:if test="number(swNovatedAmount/amount) > number(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$fixedLeg]/calculationPeriodAmount/knownAmountSchedule/initialValue)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Novated Amount 2 (swNovatedAmount) must not be greater than Trade Fixed Amount.  Value = '<xsl:value-of select="number(swNovatedAmount/amount)"/>'</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="swNovatedAmount">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="payment">
<xsl:if test="payment[paymentType != 'Novation']">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** payment/paymentType must be equal to 'Novation'. Value = '<xsl:value-of select="payment/paymentType"/>'.</text>
</error>
</xsl:if>
<xsl:if test="payment[payerPartyReference/@href != $transferor and receiverPartyReference/@href != $transferor]">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** transferor/@href must equal payment/payerPartyReference/@href or payment/receiverPartyReference/@href.</text>
</error>
</xsl:if>
<xsl:if test="payment[payerPartyReference/@href = $remainingParty or receiverPartyReference/@href = $remainingParty]">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** payment/payerPartyReference/@href or payment/receiverPartyReference/@href must not be equal to remainingParty/@href.</text>
</error>
</xsl:if>
<xsl:if test="otherRemainingParty">
<xsl:if test="payment[payerPartyReference/@href = $otherRemainingParty or receiverPartyReference/@href = $otherRemainingParty]">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** payment/payerPartyReference/@href or payment/receiverPartyReference/@href must not be equal to otherRemainingParty/@href.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
<xsl:if test="swPartialNovationIndicator">
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">swPartialNovationIndicator</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="swPartialNovationIndicator"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="swBilateralClearingHouse/partyId">
<xsl:if test="$productType!='IRS' and $productType!='OIS' and $productType!='FRA' and $productType!='ZCInflationSwap' and $productType!='Swaption'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swBilateralClearingHouse  should only be present if product type is 'IRS', 'OIS', 'FRA', 'ZC Inflation Swap' or 'Swaption'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="//swNovationExecutionUniqueTransactionId">
<xsl:call-template name="swNovationExecutionUniqueTransactionId">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
<xsl:with-param name="reportingData" select="$reportingData"/>
</xsl:call-template>
</xsl:if>
<xsl:apply-templates select="swMandatoryClearingNewNovatedTrade">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="payment">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="swBusinessConductDetails">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="SWDML">
<xsl:param name="reportingData"/>
<xsl:variable name="newContext">In <xsl:value-of select="local-name()"/>
</xsl:variable>
<results version="1.0">
<xsl:if test="not($version='3-0') and not($version='3-1')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid version attribute. Value = '<xsl:value-of select="$version"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not(swShortFormTrade or swLongFormTrade)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swShortFormTrade or swLongFormTrade element. Required in this context.</text>
</error>
</xsl:if>
<xsl:apply-templates select="swShortFormTrade">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="swLongFormTrade">
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
<xsl:template match="swShortFormTrade">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="not(swOriginatorPartyReference)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swOriginatorPartyReference.</text>
</error>
</xsl:if>
<xsl:variable name="href">
<xsl:value-of select="swOriginatorPartyReference/@href"/>
</xsl:variable>
<xsl:if test="not(.//party[@id=substring-after($href,'#')])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swOriginatorPartyReference/@href does not reference a valid .//party/@id. Value = '<xsl:value-of select="$href"/>'.</text>
</error>
</xsl:if>
<xsl:apply-templates select="swSwaptionParameters">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="swIrsParameters">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="swOisParameters">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="swFraParameters">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="swCapFloorParameters">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="swBackLoadingFlag">
<xsl:if test="not(swBackLoadingFlag[. = 'true'])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swBackLoadingFlag must be equal to 'true'. Value = '<xsl:value-of select="swBackLoadingFlag"/>'.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:template>
<xsl:template match="swLongFormTrade">
<xsl:param name="context"/>
<xsl:param name="reportingData"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:apply-templates select="swGiveUp">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="swAllocations">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
<xsl:with-param name="reportingData" select="$reportingData"/>
</xsl:apply-templates>
<xsl:apply-templates select="novation">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="not(swOriginatorPartyReference)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swOriginatorPartyReference.</text>
</error>
</xsl:if>
<xsl:if test="swReplacementTradeId and //swReplacementReason = 'IndexTransitionReplacedByTrade'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** IndexTransitionReplacedByTrade is not a valid value for Replacement Reason in this context.</text>
</error>
</xsl:if>
<xsl:if test="($productType = 'IRS' or $productType = 'OIS') and $isZeroCouponInterestRateSwap = 'false'">
<xsl:variable name="dt1"><xsl:value-of select="swStructuredTradeDetails/FpML/trade/swap/swapStream[position()=$fixedLeg]/calculationPeriodDates/firstRegularPeriodStartDate"/></xsl:variable>
<xsl:variable name="dt2"><xsl:value-of select="swStructuredTradeDetails/FpML/trade/swap/swapStream[position()=$floatingLeg]/calculationPeriodDates/firstRegularPeriodStartDate"/></xsl:variable>
<xsl:variable name="rollconv"><xsl:value-of select="swStructuredTradeDetails/FpML/trade/swap/swapStream[position()=$fixedLeg]/calculationPeriodDates/calculationPeriodFrequency/rollConvention"/></xsl:variable>
<xsl:variable name="frontandbackstub">
<xsl:choose>
<xsl:when test = "count(swStructuredTradeDetails/swExtendedTradeDetails/swStub) = 2">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
</xsl:if>
<xsl:variable name="href">
<xsl:value-of select="swOriginatorPartyReference/@href"/>
</xsl:variable>
<xsl:if test="not(//FpML/trade/party[@id=substring-after($href,'#')])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swOriginatorPartyReference/@href does not reference a valid //FpML/trade/party/@id. Value = '<xsl:value-of select="$href"/>'.</text>
</error>
</xsl:if>
<xsl:apply-templates select="swStructuredTradeDetails">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="swFraParameters">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="swProductSubType">
<xsl:call-template name="isValidProductSubType">
<xsl:with-param name="elementName">swProductSubType</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="swProductSubType"/>
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
<xsl:value-of select="tradeDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:apply-templates select="swEffectiveDateTenor">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="swTerminationDateTenor">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="swTerminationDateTenor/periodMultiplier &lt;= swEffectiveDateTenor/periodMultiplier">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swTerminationDateTenor must be greater than swEffectiveDateTenor. swEffectiveDateTenor = '<xsl:value-of select="swEffectiveDateTenor/periodMultiplier"/>
<xsl:value-of select="swEffectiveDateTenor/period"/>' and swTerminationDateTenor = '<xsl:value-of select="swTerminationDateTenor/periodMultiplier"/>
<xsl:value-of select="swTerminationDateTenor/period"/>'.</text>
</error>
</xsl:if>
<xsl:if test="swTerminationDateTenor/periodMultiplier - swEffectiveDateTenor/periodMultiplier &gt; 12">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swTerminationDateTenor minus swEffectiveDateTenor must not be greater than 12 months. swEffectiveDateTenor = '<xsl:value-of select="swEffectiveDateTenor/periodMultiplier"/>
<xsl:value-of select="swEffectiveDateTenor/period"/>' and swTerminationDateTenor = '<xsl:value-of select="swTerminationDateTenor/periodMultiplier"/>
<xsl:value-of select="swTerminationDateTenor/period"/>'.</text>
</error>
</xsl:if>
<xsl:if test="rollConvention">
<xsl:call-template name="isValidRollConvention">
<xsl:with-param name="elementName">rollConvention</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="rollConvention"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:variable name="href1">
<xsl:value-of select="buyerPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="href2">
<xsl:value-of select="sellerPartyReference/@href"/>
</xsl:variable>
<xsl:if test="$href1=$href2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** buyerPartyReference/@href and sellerPartyReference/@href values must not be the same.</text>
</error>
</xsl:if>
<xsl:if test="not(party[@id=substring-after($href1,'#')])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** buyerPartyReference/@href does not reference a valid party/@id. Value = '<xsl:value-of select="$href1"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not(party[@id=substring-after($href2,'#')])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** sellerPartyReference/@href does not reference a valid party/@id. Value = '<xsl:value-of select="$href2"/>'.</text>
</error>
</xsl:if>
<xsl:apply-templates select="notional">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">fixedRate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fixedRate"/>
</xsl:with-param>
<xsl:with-param name="minIncl">-9.9999999999</xsl:with-param>
<xsl:with-param name="maxIncl">9.9999999999</xsl:with-param>
<xsl:with-param name="maxDecs">10</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="floatingRateIndex">
<xsl:variable name="floatingRateIndex">
<xsl:value-of select="floatingRateIndex"/>
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
<xsl:if test="count(party)!=2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of party child elements encountered. Exactly 2 expected.</text>
</error>
</xsl:if>
<xsl:variable name="id1">
<xsl:value-of select="party[1]/@id"/>
</xsl:variable>
<xsl:variable name="id2">
<xsl:value-of select="party[2]/@id"/>
</xsl:variable>
<xsl:if test="$id1=$id2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** party[1]/@id and party[2]/@id values must not be the same.</text>
</error>
</xsl:if>
<xsl:apply-templates select="party">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="swOisParameters">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">tradeDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="tradeDate"/>
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
<xsl:if test="adjustedEffectiveDate">
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">adjustedEffectiveDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="adjustedEffectiveDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="swUnadjustedTerminationDate">
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">swUnadjustedTerminationDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="swUnadjustedTerminationDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="rollConvention">
<xsl:call-template name="isValidRollConvention">
<xsl:with-param name="elementName">rollConvention</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="rollConvention"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:apply-templates select="swFixedAmounts">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="swAssociatedBonds">
<xsl:if test="not($tradeCurrency = 'USD' or $tradeCurrency = 'CAD')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swAssociatedBonds should only be present if trade currency is equal to 'USD' or 'CAD'. Value = '<xsl:value-of select="$tradeCurrency"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="swAssociatedBonds">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="notional">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fixedRate">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">fixedRate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fixedRate"/>
</xsl:with-param>
<xsl:with-param name="minIncl">-9.9999999999</xsl:with-param>
<xsl:with-param name="maxIncl">9.9999999999</xsl:with-param>
<xsl:with-param name="maxDecs">10</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fixedAmount">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">fixedAmount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fixedAmount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.01</xsl:with-param>
<xsl:with-param name="maxIncl">3999999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="floatingRateIndex">
<xsl:variable name="floatingRateIndex">
<xsl:value-of select="floatingRateIndex"/>
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
<xsl:apply-templates select="additionalTerms">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="count(party)!=2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of party child elements encountered. Exactly 2 expected.</text>
</error>
</xsl:if>
<xsl:variable name="id1">
<xsl:value-of select="party[1]/@id"/>
</xsl:variable>
<xsl:variable name="id2">
<xsl:value-of select="party[2]/@id"/>
</xsl:variable>
<xsl:if test="$id1=$id2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** party[1]/@id and party[2]/@id values must not be the same.</text>
</error>
</xsl:if>
<xsl:apply-templates select="party">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="swSettlementProvision">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="swIrsParameters">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:call-template name="isValidShortFormCompoundingMethod">
<xsl:with-param name="floatPaymentFrequency">
<xsl:value-of select="/SWDML/swShortFormTrade/swIrsParameters/swFloatPaymentFrequency/periodMultiplier"/>
<xsl:value-of select="/SWDML/swShortFormTrade/swIrsParameters/swFloatPaymentFrequency/period"/>
</xsl:with-param>
<xsl:with-param name="floatRollFrequency">
<xsl:value-of select="/SWDML/swShortFormTrade/swIrsParameters/swRollFrequency/periodMultiplier"/>
<xsl:value-of select="/SWDML/swShortFormTrade/swIrsParameters/swRollFrequency/period"/>
</xsl:with-param>
<xsl:with-param name="compoundingMethod">
<xsl:value-of select="/SWDML/swShortFormTrade/swIrsParameters/swCompoundingMethod"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="swProductSubType">
<xsl:call-template name="isValidProductSubType">
<xsl:with-param name="elementName">swProductSubType</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="swProductSubType"/>
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
<xsl:value-of select="tradeDate"/>
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
<xsl:if test="adjustedEffectiveDate">
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">adjustedEffectiveDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="adjustedEffectiveDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="swUnadjustedTerminationDate">
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">swUnadjustedTerminationDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="swUnadjustedTerminationDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="rollConvention">
<xsl:call-template name="isValidRollConvention">
<xsl:with-param name="elementName">rollConvention</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="rollConvention"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="swRollFrequency">
<xsl:apply-templates select="swRollFrequency">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
<xsl:if test="swFloatPaymentFrequency">
<xsl:apply-templates select="swFloatPaymentFrequency">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
<xsl:if test="swFixedPaymentFrequency">
<xsl:apply-templates select="swFixedPaymentFrequency">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
<xsl:if test="swCompoundingMethod">
<xsl:apply-templates select="swCompoundingMethod">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
<xsl:if test="swStubPosition">
<xsl:call-template name="isValidStubPosition">
<xsl:with-param name="elementName">swStubPosition</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="swStubPosition"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:apply-templates select="swFixedAmounts">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="swEarlyTerminationProvision">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="swFixedStubLength">
<xsl:apply-templates select="swFixedStubLength">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
<xsl:if test="swFloatStubLength">
<xsl:apply-templates select="swFloatStubLength">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
<xsl:if test="swStubIndexTenor">
<xsl:apply-templates select="swStubIndexTenor">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
<xsl:if test="swAssociatedBonds">
<xsl:if test="not($tradeCurrency = 'USD' or $tradeCurrency = 'CAD')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swAssociatedBonds should only be present if trade currency is equal to 'USD' or 'CAD'. Value = '<xsl:value-of select="$tradeCurrency"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="swAssociatedBonds">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="notional">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fixedRate">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">fixedRate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fixedRate"/>
</xsl:with-param>
<xsl:with-param name="minIncl">-9.9999999999</xsl:with-param>
<xsl:with-param name="maxIncl">9.9999999999</xsl:with-param>
<xsl:with-param name="maxDecs">10</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fixedAmount">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">fixedAmount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fixedAmount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.01</xsl:with-param>
<xsl:with-param name="maxIncl">3999999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="floatingRateIndex">
<xsl:variable name="floatingRateIndex">
<xsl:value-of select="floatingRateIndex"/>
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
<xsl:if test="initialRate">
<xsl:variable name="initialRate">
<xsl:value-of select="initialRate"/>
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
<xsl:apply-templates select="additionalTerms">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="count(party)!=2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of party child elements encountered. Exactly 2 expected.</text>
</error>
</xsl:if>
<xsl:variable name="id1">
<xsl:value-of select="party[1]/@id"/>
</xsl:variable>
<xsl:variable name="id2">
<xsl:value-of select="party[2]/@id"/>
</xsl:variable>
<xsl:if test="$id1=$id2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** party[1]/@id and party[2]/@id values must not be the same.</text>
</error>
</xsl:if>
<xsl:apply-templates select="party">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="swSettlementProvision">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="swSwaptionParameters">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:call-template name="isValidShortFormCompoundingMethod">
<xsl:with-param name="floatPaymentFrequency">
<xsl:value-of select="/SWDML/swShortFormTrade/swSwaptionParameters/swFloatPaymentFrequency/periodMultiplier"/>
<xsl:value-of select="/SWDML/swShortFormTrade/swSwaptionParameters/swFloatPaymentFrequency/period"/>
</xsl:with-param>
<xsl:with-param name="floatRollFrequency">
<xsl:value-of select="/SWDML/swShortFormTrade/swSwaptionParameters/swRollFrequency/periodMultiplier"/>
<xsl:value-of select="/SWDML/swShortFormTrade/swSwaptionParameters/swRollFrequency/period"/>
</xsl:with-param>
<xsl:with-param name="compoundingMethod">
<xsl:value-of select="/SWDML/swShortFormTrade/swSwaptionParameters/swCompoundingMethod"/>
</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">tradeDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="tradeDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:variable name="href1">
<xsl:value-of select="buyerPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="href2">
<xsl:value-of select="sellerPartyReference/@href"/>
</xsl:variable>
<xsl:if test="$href1=$href2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** buyerPartyReference/@href and sellerPartyReference/@href values must not be the same.</text>
</error>
</xsl:if>
<xsl:if test="not(party[@id=substring-after($href1,'#')])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** buyerPartyReference/@href does not reference a valid party/@id. Value = '<xsl:value-of select="$href1"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not(party[@id=substring-after($href2,'#')])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** sellerPartyReference/@href does not reference a valid party/@id. Value = '<xsl:value-of select="$href2"/>'.</text>
</error>
</xsl:if>
<xsl:apply-templates select="swPremium">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="swEuropeanExercise">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">swaptionStraddle</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="swaptionStraddle"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">swCashSettlement</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="swCashSettlement"/>
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
<xsl:if test="adjustedEffectiveDate">
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">adjustedEffectiveDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="adjustedEffectiveDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="swUnadjustedTerminationDate">
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">swUnadjustedTerminationDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="swUnadjustedTerminationDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="rollConvention">
<xsl:call-template name="isValidRollConvention">
<xsl:with-param name="elementName">rollConvention</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="rollConvention"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="swRollFrequency">
<xsl:apply-templates select="swRollFrequency">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
<xsl:if test="swFloatPaymentFrequency">
<xsl:apply-templates select="swFloatPaymentFrequency">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
<xsl:if test="swFixedPaymentFrequency">
<xsl:apply-templates select="swFixedPaymentFrequency">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
<xsl:if test="swCompoundingMethod">
<xsl:apply-templates select="swCompoundingMethod">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
<xsl:if test="swStubPosition">
<xsl:call-template name="isValidStubPosition">
<xsl:with-param name="elementName">swStubPosition</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="swStubPosition"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="swStubPosition and rollConvention">
<xsl:variable name="rollConvention">
<xsl:value-of select="rollConvention"/>
</xsl:variable>
<xsl:if test="starts-with($rollConvention,'IMM') and not(swStubPosition[.='Start'])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swStubPosition must equal 'Start' if rollConvention is equal to 'IMM'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="swFixedStubLength">
<xsl:apply-templates select="swFixedStubLength">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
<xsl:if test="swFloatStubLength">
<xsl:apply-templates select="swFloatStubLength">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
<xsl:if test="swStubIndexTenor">
<xsl:apply-templates select="swStubIndexTenor">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
<xsl:apply-templates select="swFixedAmounts">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="swEarlyTerminationProvision">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="notional">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">fixedRate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fixedRate"/>
</xsl:with-param>
<xsl:with-param name="minIncl">-9.9999999999</xsl:with-param>
<xsl:with-param name="maxIncl">9.9999999999</xsl:with-param>
<xsl:with-param name="maxDecs">10</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="floatingRateIndex">
<xsl:variable name="floatingRateIndex">
<xsl:value-of select="floatingRateIndex"/>
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
<xsl:if test="count(party)!=2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of party child elements encountered. Exactly 2 expected.</text>
</error>
</xsl:if>
<xsl:variable name="id1">
<xsl:value-of select="party[1]/@id"/>
</xsl:variable>
<xsl:variable name="id2">
<xsl:value-of select="party[2]/@id"/>
</xsl:variable>
<xsl:if test="$id1=$id2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** party[1]/@id and party[2]/@id values must not be the same.</text>
</error>
</xsl:if>
<xsl:apply-templates select="party">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="swCapFloorParameters">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">tradeDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="tradeDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:variable name="href1">
<xsl:value-of select="buyerPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="href2">
<xsl:value-of select="sellerPartyReference/@href"/>
</xsl:variable>
<xsl:if test="$href1=$href2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** buyerPartyReference/@href and sellerPartyReference/@href values must not be the same.</text>
</error>
</xsl:if>
<xsl:if test="not(party[@id=substring-after($href1,'#')])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** buyerPartyReference/@href does not reference a valid party/@id. Value = '<xsl:value-of select="$href1"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not(party[@id=substring-after($href2,'#')])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** sellerPartyReference/@href does not reference a valid party/@id. Value = '<xsl:value-of select="$href2"/>'.</text>
</error>
</xsl:if>
<xsl:apply-templates select="swPremium">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="not(swOptionType = 'Cap' or 'Floor' or 'Cap Floor Straddle')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swOptionType must be one of 'Cap', 'Floor' or 'Cap Floor Straddle'. Value = '<xsl:value-of select="swOptionType"/>'.</text>
</error>
</xsl:if>
<xsl:apply-templates select="swSwapTermTenor">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="adjustedEffectiveDate">
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">adjustedEffectiveDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="adjustedEffectiveDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="swUnadjustedTerminationDate">
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">swUnadjustedTerminationDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="swUnadjustedTerminationDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="rollConvention">
<xsl:call-template name="isValidRollConvention">
<xsl:with-param name="elementName">rollConvention</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="rollConvention"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="swStubPosition">
<xsl:call-template name="isValidStubPosition">
<xsl:with-param name="elementName">swStubPosition</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="swStubPosition"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="swStubPosition and rollConvention">
<xsl:variable name="rollConvention">
<xsl:value-of select="rollConvention"/>
</xsl:variable>
<xsl:if test="starts-with($rollConvention,'IMM') and not(swStubPosition[.='Start'])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swStubPosition must equal 'Start' if rollConvention is equal to 'IMM'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="swEarlyTerminationProvision">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="notional">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swStrikeRate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="swStrikeRate"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">9.99999999</xsl:with-param>
<xsl:with-param name="maxDecs">8</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="floatingRateIndex">
<xsl:variable name="floatingRateIndex">
<xsl:value-of select="floatingRateIndex"/>
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
<xsl:apply-templates select="indexTenor">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="paymentFrequency">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="count(party)!=2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of party child elements encountered. Exactly 2 expected.</text>
</error>
</xsl:if>
<xsl:variable name="id1">
<xsl:value-of select="party[1]/@id"/>
</xsl:variable>
<xsl:variable name="id2">
<xsl:value-of select="party[2]/@id"/>
</xsl:variable>
<xsl:if test="$id1=$id2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** party[1]/@id and party[2]/@id values must not be the same.</text>
</error>
</xsl:if>
<xsl:apply-templates select="party">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="swPremium">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:call-template name="isValidCurrency">
<xsl:with-param name="elementName">paymentAmount/currency</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="paymentAmount/currency"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:variable name="amount">
<xsl:value-of select="paymentAmount/amount"/>
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
<xsl:value-of select="swPaymentDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:template>
<xsl:template match="swEuropeanExercise">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">swExpirationDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="swExpirationDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:template>
<xsl:template match="swFixedAmounts">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:variable name="href1">
<xsl:value-of select="payerPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="href2">
<xsl:value-of select="receiverPartyReference/@href"/>
</xsl:variable>
<xsl:if test="$href1=$href2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** payerPartyReference/@href and receiverPartyReference/@href values must not be the same.</text>
</error>
</xsl:if>
<xsl:if test="not(../party[@id=substring-after($href1,'#')])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** payerPartyReference/@href does not reference a valid ../party/@id. Value = '<xsl:value-of select="$href1"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not(../party[@id=substring-after($href2,'#')])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** receiverPartyReference/@href does not reference a valid ../party/@id. Value = '<xsl:value-of select="$href2"/>'.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="swStructuredTradeDetails">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:call-template name="isValidProductType">
<xsl:with-param name="elementName">swProductType</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="swProductType"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:apply-templates select="FpML">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="swExtendedTradeDetails">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="swBusinessConductDetails">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="//cancelableProvision">
<xsl:if test="not($productType ='IRS' or $productType ='OIS')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** cancelableProvision should only be present if product type is 'SingleCurrencyInterestRateSwap' or 'OIS'.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:template>
<xsl:template match="swExtendedTradeDetails">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:apply-templates select="swTradeHeader">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="swStub">
<xsl:if test="not($productType ='IRS' or $productType ='OIS' or $productType='Swaption'or $productType='CapFloor')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swStub should only be present if product type is 'SingleCurrencyInterestRateSwap' or 'OIS or 'Swaption' or 'CapFloor'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:variable name="frontAndBackStubs">
<xsl:choose>
<xsl:when test="($productType='IRS' or $productType='OIS') and count(swStub)=2">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:if test="$frontAndBackStubs='true'">
<xsl:if test="not(swStub[1]/swStubPosition='Start' and swStub[2]/swStubPosition='End')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swStub instances must relate to start and end stubs respectively.  swStub[1]/swStubPosition value ='<xsl:value-of select="swStub[1]/swStubPosition"/>'.  swStub[2]/swStubPosition value ='<xsl:value-of select="swStub[2]/swStubPosition"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="swStub">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
<xsl:with-param name="frontAndBackStubs">
<xsl:value-of select="$frontAndBackStubs"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="$productType ='Fixed Fixed Swap' and $tradeCurrency != $tradeCurrency2 and count(swStub)=2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Front and Back stubs are allowed only when Currency on both legs are same.</text>
</error>
</xsl:if>
<xsl:if test="swEarlyTerminationProvision">
<xsl:if test="not($productType ='IRS' or $productType='Swaption'or $productType='CapFloor'or $productType='OIS')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swEarlyTerminationProvision should only be present if product type is 'SingleCurrencyInterestRateSwap' or 'Swaption'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="swEarlyTerminationProvision">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="swAssociatedBonds">
<xsl:if test="not($productType ='IRS' or $productType ='OIS') or not($tradeCurrency = 'USD' or $tradeCurrency = 'CAD')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swAssociatedBonds should only be present if product type is 'SingleCurrencyInterestRateSwap' or 'OIS' and trade currency is equal to 'USD' or 'CAD'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="swAssociatedBonds">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="count(additionalPayment) &gt; 8">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of additionalPayment child elements encountered. 0 to 8 expected.</text>
</error>
</xsl:if>
<xsl:if test="count(additionalPayment) = 7">
<xsl:if test="not(additionalPayment[paymentType = 'Independent Amount'] or additionalPayment[paymentType = 'Cancellation'])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** If seven additionalPayment child elements are present then one must be identified as an Independent Amount (paymentType = 'Independent Amount') or Cancellation (paymentType = 'Cancellation').</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="count(additionalPayment) = 8">
<xsl:if test="not(additionalPayment[paymentType = 'Independent Amount'] and additionalPayment[paymentType = 'Cancellation'])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** If eight additionalPayment child elements are present then one must be identified as an Independent Amount (paymentType = 'Independent Amount') and one a Cancellation (paymentType = 'Independent Amount').</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="count(additionalPayment[paymentType = 'Independent Amount']) &gt; 1">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** A maximum of one additionalPayment child element can be identified as an Independent Amount (paymentType = 'Independent Amount').</text>
</error>
</xsl:if>
<xsl:if test="count(additionalPayment[paymentType = 'Cancellation']) &gt; 1">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** A maximum of one additionalPayment child element can be identified as a Cancellation (paymentType = 'Cancellation').</text>
</error>
</xsl:if>
<xsl:if test="additionalPayment">
<xsl:if test="not($productType='FRA' or $productType='Swaption')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** additionalPayment is only allowed in this context if product type is 'FRA' or 'Swaption'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="additionalPayment">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="swSettlementProvision">
<xsl:if test="not($productType='IRS' or $productType='OIS' or $productType='Swaption')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swSettlementProvision should only be present if product type is 'IRS' or 'OIS' or 'Swaption'. Value = '<xsl:value-of select="$productType"/>' .</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="swSettlementProvision">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="swFutureValue">
<xsl:if test="not($productType='IRS' and $tradeCurrency='BRL')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swFutureValue should only be present if product type is 'IRS' and currency is 'BRL''. Values are '<xsl:value-of select="$productType"/>', '<xsl:value-of select="$tradeCurrency"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="swFutureValue">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="swModificationEffectiveDate">
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">swModificationEffectiveDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="swModificationEffectiveDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="swAmendmentType">
<xsl:if test="not(swAmendmentType='Exit' or swAmendmentType='Amendment' or swAmendmentType='ErrorCorrection' or swAmendmentType='PartialTermination' or swAmendmentType='Corporate Action')">
<error>
<context>
<xsl:value-of select="$newContext"/>/swAmendmentType
</context>
<text>*** valid values are 'Exit', 'Amendment', 'ErrorCorrection' or 'PartialTermination'.  Value='<xsl:value-of select="swAmendmentType"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="swCancellationType">
<xsl:if test="not(swCancellationType='BookedInError') and not(swCancellationType='CancellableExercise')">
<error>
<context>
<xsl:value-of select="$newContext"/>/swCancellationType
</context>
<text>*** element, if present, can only contain the value 'BookedInError' or 'CancellableExercise'.  Value='<xsl:value-of select="swCancellationType"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="swCancellationType">
<xsl:if test="swCancellationType='CancellableExercise' and not (//cancelableProvision)">
<error>
<context>
<xsl:value-of select="$newContext"/>/swCancellationType
</context>
<text>*** element, if present, can only contain the value 'CancellableExercise' when trade has a cancelableProvision.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="swCancellationType and $productType='Swaption'">
<xsl:if test="swCancellationType='BookedInError' and swForwardPremium='true'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Value of swForwardPremium is invalid for swCancellationType 'BookedInError'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="swAmendmentType and swCancellationType">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** amendment type and cancellation type cannot both be present.  Amendment type is '<xsl:value-of select="swAmendmentType"/>'.  Cancellation type is '<xsl:value-of select="swCancellationType"/>.'</text>
</error>
</xsl:if>
<xsl:if test="swOutsideNovation">
<xsl:if test="not($productType='IRS' or $productType='OIS')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swOutsideNovation should only be present if product type is 'IRS' or 'OIS'. Product Type is  '<xsl:value-of select="$productType"/>.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="swOutsideNovation">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="swCollateralizedCashPrice">
<xsl:choose>
<xsl:when test="not($productType='Swaption')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swCollateralizedCashPrice should only be present if product type is 'Swaption'.</text>
</error>
</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swTradeHeader/swContractualDefinitions='ISDA2000'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swCollateralizedCashPrice is not valid under stated ContractualDefinitions.  Value = '<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swTradeHeader/swContractualDefinitions"/>'.</text>
</error>
</xsl:when>
<xsl:when test="((/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swCollateralizedCashPrice) and (/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swaption/cashSettlement[cashPriceMethod | cashPriceAlternateMethod | parYieldCurveUnadjustedMethod | zeroCouponYieldAdjustedMethod]))">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Only one swaption cash settlement method can be specified. If swCollateralizedCashPrice is present then neither cashPriceMethod, cashPriceAlternateMethod, parYieldCurveUnadjustedMethod or zeroCouponYieldAdjustedMethod can be present within ../FpML/trade/swaption/cashSettlement</text>
</error>
</xsl:when>
<xsl:otherwise>
<xsl:apply-templates select="swCollateralizedCashPrice">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:template>
<xsl:template match="swTradeHeader">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="swOriginatingEvent">
<xsl:choose>
<xsl:when test="swOriginatingEvent=''"/>
<xsl:when test="swOriginatingEvent='Bunched Order Block'"/>
<xsl:when test="swOriginatingEvent='Bunched Order Allocation'"/>
<xsl:when test="swOriginatingEvent='Backload'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***swOriginatingEvent element value is not supported. Supported values are '', 'Bunched Order Block', 'Bunched Order Allocation', 'Backload' (for backloaded trade). Value = '<xsl:value-of select="swOriginatingEvent"/>'."/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">swManualConfirmationRequired</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="swManualConfirmationRequired"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="swNovationExecution">
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">swNovationExecution</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="swNovationExecution"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="swNovationExecution='true' and swManualConfirmationRequired !='false'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swManualConfirmationRequired must be set to 'false' if swNovationExecution is set to 'true'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:call-template name="isValidMasterAgreementType">
<xsl:with-param name="elementName">swMasterAgreementType</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="swMasterAgreementType"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="swContractualDefinitions">
<xsl:call-template name="isValidContractualDefinitions">
<xsl:with-param name="elementName">swContractualDefinitions</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="swContractualDefinitions"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="$productType='IRS' or $productType='Swaption' or $productType='OIS' or $productType='FRA'">
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">swClearingNotRequired</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="swClearingNotRequired"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="not(swStandardSettlementInstructions[. = 'true'])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swStandardSettlementInstructions must be equal to 'true'. Value = '<xsl:value-of select="swStandardSettlementInstructions"/>'.</text>
</error>
</xsl:if>
<xsl:if test="swAssociatedTrades">
<xsl:if test="not (swClearingTakeup)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***swAssociatedTrades must only be present when swClearingTakeup is present</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="swNormalised">
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">swNormalised</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="swNormalised"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="not($productType='IRS' or $productType='OIS')">
<xsl:if test="swNormalised">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swNormalised must not be present if product type is not equal to 'SingleCurrencyInterestRateSwap' or 'OIS'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="swClientClearing">
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">swClientClearing</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="swClientClearing"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="not($productType='IRS' or $productType='OIS' or $productType='FRA' or $productType ='ZCInflationSwap' or $productType='Swaption')">
<xsl:if test="swClientClearing">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swClientClearing must not be present if product type is not equal to 'SingleCurrencyInterestRateSwap' or 'OIS' or 'FRA' or 'ZC Inflation Swap' or 'Swaption'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="swAutoSendForClearing">
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">swAutoSendForClearing</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="swAutoSendForClearing"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="not($productType='IRS' or $productType='OIS' or $productType='FRA' or $productType='Single Currency Basis Swap' or $productType ='ZCInflationSwap' or $productType='Swaption')">
<xsl:if test="swAutoSendForClearing">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swAutoSendForClearing must not be present if product type is not equal to 'SingleCurrencyInterestRateSwap' or 'OIS' or 'FRA' or 'Single Currency Basis Swap' or 'ZC Inflation Swap' or 'Swaption'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="swInteroperable">
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">swInteroperable</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="swInteroperable"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="not($productType='IRS' or $productType='Swaption')">
<xsl:if test="swInteroperable">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swInteroperable must not be present if product type is not equal to 'SingleCurrencyInterestRateSwap' or 'Swaption'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="swExternalInteropabilityId">
<xsl:if test="swClientClearing !='true' or not (swClientClearing)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swExternalInteropabilityId must not be present if swClientClearing is not true.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="swInteropNettingString">
<xsl:if test="swClientClearing !='true' or not (swClientClearing)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swInteropNettingString must not be present if swClientClearing is not true.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="swClearedPhysicalSettlement">
<xsl:choose>
<xsl:when test="not($productType='Swaption')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swClearedPhysicalSettlement should only be present if product type is 'Swaption'.</text>
</error>
</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swaption/cashSettlement">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swClearedPhysicalSettlement should not be present when cash settlement method specified.</text>
</error>
</xsl:when>
<xsl:when test="swContractualDefinitions='ISDA2000'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swClearedPhysicalSettlement is not valid under stated swContractualDefinitions. Value = '<xsl:value-of select="swContractualDefinitions"/>'.</text>
</error>
</xsl:when>
<xsl:when test="swClearedPhysicalSettlement !='true'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swClearedPhysicalSettlement must be set to 'true' if present. Value = '<xsl:value-of select="swClearedPhysicalSettlement"/>'.</text>
</error>
</xsl:when>
</xsl:choose>
</xsl:if>
<xsl:if test="swPredeterminedClearerForUnderlyingSwap">
<xsl:if test="not($productType='Swaption')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swPredeterminedClearerForUnderlyingSwap should only be present if product type is 'Swaption'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="swPricedToClearCCP">
<xsl:if test="not($productType='Swaption' or $productType='OIS' or $productType='FRA' or $productType='ZCInflationSwap' or $productType='Fixed Fixed Swap' or $productType='IRS' or $productType='Single Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='Cross Currency Basis Swap')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swPricedToClearCCP is not valid for product type '<xsl:value-of select="$productType"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="swBackLoadingFlag">
<xsl:if test="not(swBackLoadingFlag[. = 'true'])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swBackLoadingFlag must be equal to 'true'. Value = '<xsl:value-of select="swBackLoadingFlag"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="swBackLoadingFlag">
<xsl:if test="(swBackLoadingFlag[. != 'true'] and swOriginatingEvent ='Backload') or (swBackLoadingFlag = 'true' and swOriginatingEvent !='Backload')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** *** Invalid combination of swBackLoadingFlag and swOriginatingEvent.  Either both values must indicate a 'backload' or neither. Value = '<xsl:value-of select="swBackLoadingFlag"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swTradeHeader/swMandatoryClearing">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="swStub">
<xsl:param name="context"/>
<xsl:param name="frontAndBackStubs"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:call-template name="isValidStubPosition">
<xsl:with-param name="elementName">swStubPosition</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="swStubPosition"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="swStubPosition[.='Start'] and not($frontAndBackStubs='true')">
<xsl:if test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/stubCalculationPeriodAmount/finalStub">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swStubPosition value of 'Start' is inconsistent with presence of floating leg //stubCalculationPeriodAmount/finalStub element.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="swStubPosition[.='End'] and not($frontAndBackStubs='true')">
<xsl:if test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/stubCalculationPeriodAmount/initialStub">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swStubPosition value of 'End' is inconsistent with presence of floating leg //stubCalculationPeriodAmount/initialStub element.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$productType='FRA'">
<xsl:if test="swStubLength">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swStubLength must not be present if product type is 'FRA'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:for-each select="swStubLength">
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
<xsl:if test="not(//FpML/trade//capFloor/capFloorStream[@id=substring-after($href,'#')])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swStubLength[<xsl:number value="position()"/>]/@href does not reference a valid //FpML/trade//capFloor/capFloorStream/@id. Value = '<xsl:value-of select="$href"/>'.</text>
</error>
</xsl:if>
</xsl:when>
<xsl:otherwise>
<xsl:if test="not(//FpML/trade//swap/swapStream[@id=substring-after($href,'#')])">
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
<xsl:if test="swStubLength[2]">
<xsl:if test="count(swStubLength)=2">
<xsl:variable name="href1">
<xsl:value-of select="swStubLength[1]/@href"/>
</xsl:variable>
<xsl:variable name="href2">
<xsl:value-of select="swStubLength[2]/@href"/>
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
<xsl:template match="additionalPayment|payment">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:variable name="href1">
<xsl:value-of select="payerPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="href2">
<xsl:value-of select="receiverPartyReference/@href"/>
</xsl:variable>
<xsl:if test="$href1=$href2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** payerPartyReference/@href and receiverPartyReference/@href values must not be the same.</text>
</error>
</xsl:if>
<xsl:if test="not(//FpML/trade/party[@id=substring-after($href1,'#')])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** payerPartyReference/@href does not reference a valid //FpML/trade/party/@id. Value = '<xsl:value-of select="$href1"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not(//FpML/trade/party[@id=substring-after($href2,'#')])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** receiverPartyReference/@href does not reference a valid //FpML/trade/party/@id. Value = '<xsl:value-of select="$href2"/>'.</text>
</error>
</xsl:if>
<xsl:apply-templates select="paymentAmount">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:variable name="paymentTypeDesc">
<xsl:value-of select="paymentType"/>
</xsl:variable>
<xsl:if test="not(paymentDate) and $paymentTypeDesc != 'Independent Amount'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing paymentDate. Required in this context unless paymentType equals 'Independent Amount'.</text>
</error>
</xsl:if>
<xsl:apply-templates select="paymentDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:variable name="paymentDate">
<xsl:value-of select="paymentDate/unadjustedDate"/>
</xsl:variable>
<xsl:variable name="payDate">
<xsl:value-of select="number(concat(substring($paymentDate,1,4),substring($paymentDate,6,2),substring($paymentDate,9,2)))"/>
</xsl:variable>
<xsl:if test="../additionalPayment/paymentType and $paymentTypeDesc != '' and $payDate &gt;= 20171001">
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
<xsl:template match="novatedAmount|swNovatedFV|swNovatedAmount">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:call-template name="isValidCurrency">
<xsl:with-param name="elementName">currency</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="currency"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:variable name="amount">
<xsl:value-of select="amount"/>
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
<xsl:template match="independentAmount/paymentDetail/paymentAmount">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:call-template name="isValidCurrency">
<xsl:with-param name="elementName">currency</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="currency"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:variable name="amount">
<xsl:value-of select="amount"/>
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
<xsl:template match="paymentAmount">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:call-template name="isValidCurrency">
<xsl:with-param name="elementName">currency</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="currency"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:choose>
<xsl:when test="$isBlockIndependentAmountPresent='true'">
<xsl:variable name="amount">
<xsl:value-of select="amount"/>
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
</xsl:when>
<xsl:otherwise>
<xsl:variable name="amount">
<xsl:value-of select="amount"/>
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
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template match="FpML">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:variable name="businessCenterSchemeDefault">
<xsl:value-of select="@businessCenterSchemeDefault"/>
</xsl:variable>
<xsl:variable name="businessDayConventionSchemeDefault">
<xsl:value-of select="@businessDayConventionSchemeDefault"/>
</xsl:variable>
<xsl:variable name="compoundingMethodSchemeDefault">
<xsl:value-of select="@compoundingMethodSchemeDefault"/>
</xsl:variable>
<xsl:variable name="currencySchemeDefault">
<xsl:value-of select="@currencySchemeDefault"/>
</xsl:variable>
<xsl:variable name="dateRelativeToSchemeDefault">
<xsl:value-of select="@dateRelativeToSchemeDefault"/>
</xsl:variable>
<xsl:variable name="dayCountFractionSchemeDefault">
<xsl:value-of select="@dayCountFractionSchemeDefault"/>
</xsl:variable>
<xsl:variable name="dayTypeSchemeDefault">
<xsl:value-of select="@dayTypeSchemeDefault"/>
</xsl:variable>
<xsl:variable name="floatingRateIndexSchemeDefault">
<xsl:value-of select="@floatingRateIndexSchemeDefault"/>
</xsl:variable>
<xsl:variable name="partyIdSchemeDefault">
<xsl:value-of select="@partyIdSchemeDefault"/>
</xsl:variable>
<xsl:variable name="payerReceiverSchemeDefault">
<xsl:value-of select="@payerReceiverSchemeDefault"/>
</xsl:variable>
<xsl:variable name="paymentTypeSchemeDefault">
<xsl:value-of select="@paymentTypeSchemeDefault"/>
</xsl:variable>
<xsl:variable name="payRelativeToSchemeDefault">
<xsl:value-of select="@payRelativeToSchemeDefault"/>
</xsl:variable>
<xsl:variable name="periodSchemeDefault">
<xsl:value-of select="@periodSchemeDefault"/>
</xsl:variable>
<xsl:variable name="resetRelativeToSchemeDefault">
<xsl:value-of select="@resetRelativeToSchemeDefault"/>
</xsl:variable>
<xsl:variable name="rollConventionSchemeDefault">
<xsl:value-of select="@rollConventionSchemeDefault"/>
</xsl:variable>
<xsl:variable name="tradeIdSchemeDefault">
<xsl:value-of select="@tradeIdSchemeDefault"/>
</xsl:variable>
<xsl:variable name="FpMLVersion">
<xsl:value-of select="@version"/>
</xsl:variable>
<xsl:if test="not($FpMLVersion='2-0')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid version attribute. Value = '<xsl:value-of select="$FpMLVersion"/>'.</text>
</error>
</xsl:if>
<xsl:apply-templates select="trade">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="trade">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="count(party)&lt; 2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of party child elements encountered. At least 2 expected.</text>
</error>
</xsl:if>
<xsl:apply-templates select="tradeHeader">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="capFloor">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fra">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="swap">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="swaption">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="party">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="calculationAgent">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="tradeHeader">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">tradeDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="tradeDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:apply-templates select="partyTradeIdentifier">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="partyTradeInformation">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="partyTradeIdentifier">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:variable name="href">
<xsl:value-of select="partyReference/@href"/>
</xsl:variable>
<xsl:if test="not(//FpML/trade/party[@id=substring-after($href,'#')])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** partyReference/@href does not reference a valid //FpML/trade/party/@id. Value = '<xsl:value-of select="$href"/>'.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="partyTradeInformation">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:variable name="href">
<xsl:value-of select="partyReference/@href"/>
</xsl:variable>
<xsl:if test="not(//FpML/trade/party[@id=substring-after($href,'#')])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** partyReference/@href does not reference a valid //FpML/trade/party/@id. Value = '<xsl:value-of select="$href"/>'.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="premium">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:variable name="href1">
<xsl:value-of select="payerPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="href2">
<xsl:value-of select="receiverPartyReference/@href"/>
</xsl:variable>
<xsl:if test="not(//FpML/trade/party[@id=substring-after($href1,'#')])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** payerPartyReference/@href does not reference a valid /FpML/trade/party/@id. Value = '<xsl:value-of select="$href1"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not(//FpML/trade/party[@id=substring-after($href2,'#')])">
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
<xsl:variable name="amount">
<xsl:value-of select="paymentAmount/amount"/>
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
<xsl:if test="paymentDate/dateAdjustments[businessDayConvention!='FOLLOWING']">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** paymentDate/dateAdjustments/businessDayConvention must be equal to 'FOLLOWING'. Value = '<xsl:value-of select="paymentDate/dateAdjustments/businessDayConvention"/>'</text>
</error>
</xsl:if>
<xsl:variable name="tradeDate">
<xsl:value-of select="/SWDML/swStructuredTradeDetails/FpML/trade/tradeHeader/tradeDate"/>
</xsl:variable>
<xsl:variable name="paymentDate">
<xsl:value-of select="paymentDate/unadjustedDate"/>
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
<text>*** The premium payment date (paymentDate/unadjustedDate) must be greater than or equal to the tradeDate.  Value = '<xsl:value-of select="paymentDate/unadjustedDate"/>'.</text>
</error>
</xsl:if>
<xsl:apply-templates select="paymentDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:call-template name="isValidBusinessCenter">
<xsl:with-param name="elementName">businessCenter</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="paymentDate/dateAdjustments/businessCenters/businessCenter"/>
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
<xsl:template match="exerciseProcedure">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="not(automaticExercise) and not(manualExercise)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing automaticExercise or manualExercise element. Required in this context'.</text>
</error>
</xsl:if>
<xsl:apply-templates select="automaticExercise">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="manualExercise">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="followUpConfirmation">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="automaticExercise">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">thresholdRate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="thresholdRate"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">9.9999999</xsl:with-param>
<xsl:with-param name="maxDecs">7</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:template>
<xsl:template match="manualExercise">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="not(fallbackExercise)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing fallbackExercise element. Required in this context'.</text>
</error>
</xsl:if>
<xsl:if test="fallbackExercise!='true'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** fallbackExercise element must have the value of 'true' in SwapsWire.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="followUpConfirmation">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">followUpConfirmation</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="../followUpConfirmation"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:template>
<xsl:template match="capFloor">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="not($productType='CapFloor')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** /SWDML/swLongFormTrade/swStructuredTradeDetails/swProductType must be equal to 'CapFloor' if capFloor element is present.</text>
</error>
</xsl:if>
<xsl:variable name="effectiveDate">
<xsl:value-of select="capFloorStream/calculationPeriodDates/effectiveDate/unadjustedDate"/>
</xsl:variable>
<xsl:variable name="tradeDate">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/tradeHeader/tradeDate"/>
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
<xsl:apply-templates select="capFloorStream">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="additionalPayment">
<xsl:variable name="optionBuyer">
<xsl:value-of select="capFloorStream/receiverPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="optionSeller">
<xsl:value-of select="capFloorStream/payerPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="premiumPayer">
<xsl:value-of select="additionalPayment/payerPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="premiumReceiver">
<xsl:value-of select="additionalPayment/receiverPartyReference/@href"/>
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
<xsl:if test="count(additionalPayment) &gt; 8">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of additionalPayment child elements encountered. 0 to 8 expected.</text>
</error>
</xsl:if>
<xsl:variable name="additionalPaymentCount">
<xsl:value-of select="count(additionalPayment)"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$additionalPaymentCount = 8">
<xsl:if test="not(additionalPayment[paymentType = 'Independent Amount'])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** If eight additionalPayment child elements are present then one must be identified as an Independent Amount (paymentType = 'Independent Amount').</text>
</error>
</xsl:if>
<xsl:if test="not(additionalPayment[paymentType = 'Premium'])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** If eight additionalPayment child elements are present then one must be identified as a Premium (paymentType = 'Premium').</text>
</error>
</xsl:if>
</xsl:when>
<xsl:when test="$additionalPaymentCount = 7">
<xsl:if test="not(additionalPayment[paymentType = 'Independent Amount'] or additionalPayment[paymentType = 'Premium'])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** If seven additionalPayment child elements are present then one must be identified as an Independent Amount (paymentType = 'Independent Amount') or Premium (paymentType = 'Premium').</text>
</error>
</xsl:if>
</xsl:when>
</xsl:choose>
<xsl:if test="count(additionalPayment[paymentType = 'Premium']) &gt; 1">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** One and only one additionalPayment child element must be identified as a Premium (paymentType = 'Premium').</text>
</error>
</xsl:if>
<xsl:if test="count(additionalPayment[paymentType = 'Independent Amount']) &gt; 1">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** A maximum of one additionalPayment child element can be identified as a Independent Amount  (paymentType = 'Independent Amount').</text>
</error>
</xsl:if>
<xsl:apply-templates select="additionalPayment">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="earlyTerminationProvision">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="capFloorStream">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:variable name="href1">
<xsl:value-of select="payerPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="href2">
<xsl:value-of select="receiverPartyReference/@href"/>
</xsl:variable>
<xsl:if test="not(//FpML/trade/party[@id=substring-after($href1,'#')])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** payerPartyReference/@href does not reference a valid /FpML/trade/party/@id. Value = '<xsl:value-of select="$href1"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not(//FpML/trade/party[@id=substring-after($href2,'#')])">
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
<xsl:value-of select="calculationPeriodDates/calculationPeriodFrequency/periodMultiplier"/>
</xsl:variable>
<xsl:variable name="periodMultiplier2">
<xsl:value-of select="paymentDates/paymentFrequency/periodMultiplier"/>
</xsl:variable>
<xsl:variable name="period1">
<xsl:value-of select="calculationPeriodDates/calculationPeriodFrequency/period"/>
</xsl:variable>
<xsl:variable name="period2">
<xsl:value-of select="paymentDates/paymentFrequency/period"/>
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
<xsl:value-of select="calculationPeriodDates/calculationPeriodFrequency/rollConvention"/>
</xsl:variable>
<xsl:variable name="floatCalcPayFreqCombo">
<xsl:value-of select="$periodMultiplier1"/>
<xsl:value-of select="$period1"/>
<xsl:value-of select="$periodMultiplier2"/>
<xsl:value-of select="$period2"/>
</xsl:variable>
<xsl:if test="starts-with($rollConvention,'IMM')">
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
<xsl:value-of select="calculationPeriodDates/calculationPeriodDatesAdjustments/businessDayConvention"/>
</xsl:variable>
<xsl:variable name="businessDayConvention2">
<xsl:value-of select="paymentDates/paymentDatesAdjustments/businessDayConvention"/>
</xsl:variable>
<xsl:variable name="businessDayConvention3">
<xsl:value-of select="resetDates/resetDatesAdjustments/businessDayConvention"/>
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
<xsl:apply-templates select="calculationPeriodDates">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="paymentDates">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="calculationPeriodDates/relativeTerminationDate or /SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swCapFloorDetails">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** One-Look is not supported for <xsl:value-of select="$version"/> SWDML.</text>
</error>
</xsl:if>
<xsl:if test="not(resetDates)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** resetDates must be present within capFloorStream.</text>
</error>
</xsl:if>
<xsl:apply-templates select="resetDates">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="calculationPeriodAmount">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="stubCalculationPeriodAmount">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="swaption">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:variable name="buyerhref1">
<xsl:value-of select="buyerPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="sellerhref2">
<xsl:value-of select="sellerPartyReference/@href"/>
</xsl:variable>
<xsl:if test="$buyerhref1=$sellerhref2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** buyerPartyReference/@href and sellerPartyReference/@href values must not be the same.</text>
</error>
</xsl:if>
<xsl:if test="not(//FpML/trade/party[@id=substring-after($buyerhref1,'#')])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** buyerPartyReference/@href does not reference a valid //FpML/trade/party/@id. Value = '<xsl:value-of select="$buyerhref1"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not(//FpML/trade/party[@id=substring-after($sellerhref2,'#')])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** sellerPartyReference/@href does not reference a valid //FpML/trade/party/@id. Value = '<xsl:value-of select="$sellerhref2"/>'.</text>
</error>
</xsl:if>
<xsl:if test="premium">
<xsl:variable name="payer">
<xsl:value-of select="premium/payerPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="receiver">
<xsl:value-of select="premium/receiverPartyReference/@href"/>
</xsl:variable>
<xsl:if test="$buyerhref1!=$payer">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** buyerPartyReference/@href (buyer) and premium/payerPartyReference/@href (premium payer) values are not the same.</text>
</error>
</xsl:if>
<xsl:if test="$sellerhref2!=$receiver">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** sellerPartyReference/@href (seller) and premium/receiverPartyReference/@href (premium receiver) values are not the same.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="count(premium) &gt; 1">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of premium child elements encountered. 0 or 1 expected.</text>
</error>
</xsl:if>
<xsl:apply-templates select="premium">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="not(europeanExercise)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing europeanExercise element. Required in this context'.</text>
</error>
</xsl:if>
<xsl:apply-templates select="europeanExercise">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="exerciseProcedure">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="calculationAgent">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="not(calculationAgent/calculationAgentParty) and (count(calculationAgentPartyReference) = 0 or count(calculationAgentPartyReference) &gt; 2)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of calculationAgentPartyReference child elements encountered. 1 or 2 expected.</text>
</error>
</xsl:if>
<xsl:if test="count(calculationAgentPartyReference) = 2">
<xsl:variable name="calAgentParty1">
<xsl:value-of select="substring-after(calculationAgentPartyReference[1]/@href,'#')"/>
</xsl:variable>
<xsl:if test="not($calAgentParty1=substring-after($buyerhref1,'#'))">
<xsl:if test="not($calAgentParty1=substring-after($sellerhref2,'#'))">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** calculationAgentPartyReference[1]@href must reference a buyerPartyReference/@href or sellerPartyReference/@href. Value = '<xsl:value-of select="$calAgentParty1"/>'</text>
</error>
</xsl:if>
</xsl:if>
<xsl:variable name="calAgentParty2">
<xsl:value-of select="substring-after(calculationAgentPartyReference[2]/@href,'#')"/>
</xsl:variable>
<xsl:if test="not($calAgentParty2=substring-after($buyerhref1,'#'))">
<xsl:if test="not($calAgentParty2=substring-after($sellerhref2,'#'))">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** calculationAgentPartyReference[2]@href must reference a buyerPartyReference/@href or sellerPartyReference/@href. Value = '<xsl:value-of select="$calAgentParty2"/>'</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$calAgentParty1=$calAgentParty2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** calculationAgentPartyReference[1]/@href and calculationAgentPartyReference[2]/@href values must not be the same.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="calculationAgentPartyReference">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="cashSettlement">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">swaptionStraddle</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="swaptionStraddle"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:apply-templates select="swap">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="swap">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="not($productType='IRS' or $productType='OIS' or $productType='Swaption')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** /SWDML/swLongFormTrade/swStructuredTradeDetails/swProductType must be equal to 'SingleCurrencyInterestRateSwap' or 'OIS' or 'Swaption' if swap element is present.</text>
</error>
</xsl:if>
<xsl:if test="count(swapStream)!=2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of swapStream child elements encountered. Exactly 2 expected.</text>
</error>
</xsl:if>
<xsl:if test="not(swapStream[position()=$floatingLeg]/calculationPeriodAmount/calculation/floatingRateCalculation)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The floating swapStream is missing calculationPeriodAmount/calculation/floatingRateCalculation element.</text>
</error>
</xsl:if>
<xsl:if test="swapStream[position()=$fixedLeg]/resetDates">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The fixed swapStream should not contain a resetDates element.</text>
</error>
</xsl:if>
<xsl:if test="$interestRateSwapType != 'zeroCouponInterestRateSwapWithFixedAmount'">
<xsl:if test="not(swapStream[@id='fixedLeg']/calculationPeriodAmount/calculation/fixedRateSchedule)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The fixed swapStream is missing the calculationPeriodAmount/calculation/fixedRateSchedule element.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$interestRateSwapType = 'zeroCouponInterestRateSwapWithFixedNotional'">
<xsl:if test="swapStream[@id='fixedLeg']/calculationPeriodAmount/knownAmountSchedule">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The fixed swapStream is missing the knownAmountSchedule element.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$interestRateSwapType = 'zeroCouponInterestRateSwapWithFixedAmount'">
<xsl:if test="swapStream[@id='fixedLeg']/calculationPeriodAmount/calculation">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The fixed swapStream should not contain the calculationPeriodAmount/calculation element for the product 'SingleCurrencyInterestRateSwap' (and Zero Coupon IRS with fixed amount).</text>
</error>
</xsl:if>
</xsl:if>
<xsl:variable name="stream1Payer">
<xsl:value-of select="swapStream[position()=1]/payerPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="stream2Receiver">
<xsl:value-of select="swapStream[position()=2]/receiverPartyReference/@href"/>
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
<xsl:value-of select="swapStream[position()=1]/receiverPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="stream2Payer">
<xsl:value-of select="swapStream[position()=2]/payerPartyReference/@href"/>
</xsl:variable>
<xsl:if test="$stream1Receiver != $stream2Payer">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swapStream[1] receiver party is not swapStream[2] payer party.</text>
</error>
</xsl:if>
<xsl:if test="not($productType='IRS' or $productType='Swaption' or $productType='OIS' or $productType='Single Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='Fixed Fixed Swap')">
<xsl:variable name="effectiveDate1">
<xsl:value-of select="swapStream[position()=1]/calculationPeriodDates/effectiveDate/unadjustedDate"/>
</xsl:variable>
<xsl:variable name="effectiveDate2">
<xsl:value-of select="swapStream[position()=2]/calculationPeriodDates/effectiveDate/unadjustedDate"/>
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
<xsl:value-of select="swapStream[position()=1]/calculationPeriodDates/terminationDate/unadjustedDate"/>
</xsl:variable>
<xsl:variable name="terminationDate2">
<xsl:value-of select="swapStream[position()=2]/calculationPeriodDates/terminationDate/unadjustedDate"/>
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
<xsl:value-of select="swapStream[position()=1]/calculationPeriodDates/calculationPeriodFrequency/rollConvention"/>
</xsl:variable>
<xsl:variable name="rollConvention2">
<xsl:value-of select="swapStream[position()=2]/calculationPeriodDates/calculationPeriodFrequency/rollConvention"/>
</xsl:variable>
<xsl:if test="$isZeroCouponInterestRateSwap != 'true'">
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
<xsl:value-of select="swapStream[position()=1]/calculationPeriodAmount/calculation/notionalSchedule/notionalStepSchedule/initialValue"/>
</xsl:variable>
<xsl:variable name="notional2">
<xsl:value-of select="swapStream[position()=2]/calculationPeriodAmount/calculation/notionalSchedule/notionalStepSchedule/initialValue"/>
</xsl:variable>
<xsl:if test="($interestRateSwapType != 'zeroCouponInterestRateSwapWithFixedAmount')">
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
<xsl:value-of select="swapStream[position()=1]/calculationPeriodAmount/calculation/notionalSchedule/notionalStepSchedule/currency"/>
</xsl:variable>
<xsl:variable name="currency2">
<xsl:value-of select="swapStream[position()=2]/calculationPeriodAmount/calculation/notionalSchedule/notionalStepSchedule/currency"/>
</xsl:variable>
<xsl:if test="($interestRateSwapType != 'zeroCouponInterestRateSwapWithFixedAmount')">
<xsl:if test="$currency1!= $currency2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swapStream[1] and swapStream[2] currency do not match.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:variable name="floatingLegCurrency">
<xsl:value-of select="swapStream[position()=$floatingLeg]/calculationPeriodAmount/calculation/notionalSchedule/notionalStepSchedule/currency"/>
</xsl:variable>
<xsl:variable name="fixedLegCurrency">
<xsl:value-of select="swapStream[position()=$fixedLeg]/calculationPeriodAmount/knownAmountSchedule/currency"/>
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
<xsl:value-of select="swapStream[position()=1]/paymentDates/paymentDaysOffset/periodMultiplier"/>
</xsl:variable>
<xsl:variable name="paymentLag2">
<xsl:value-of select="swapStream[position()=2]/paymentDates/paymentDaysOffset/periodMultiplier"/>
</xsl:variable>
<xsl:if test="$paymentLag1!= $paymentLag2 and $productType!='OIS'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swapStream[1] and swapStream[2] paymentDaysOffset do not match.</text>
</error>
</xsl:if>
<xsl:variable name="busCenters5">
<xsl:for-each select="swapStream[position()=1]/paymentDates/paymentDatesAdjustments/businessCenters/businessCenter">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:variable>
<xsl:variable name="busCenters6">
<xsl:for-each select="swapStream[position()=2]/paymentDates/paymentDatesAdjustments/businessCenters/businessCenter">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:variable>
<xsl:if test="$busCenters5!= $busCenters6 and $productType!='IRS' and $productType!='OIS'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swapStream[1] and swapStream[2] paymentDates/paymentDatesAdjustments/businessCenters do not match.</text>
</error>
</xsl:if>
<xsl:variable name="periodMultiplier1">
<xsl:value-of select="swapStream[position()=$floatingLeg]/calculationPeriodDates/calculationPeriodFrequency/periodMultiplier"/>
</xsl:variable>
<xsl:variable name="periodMultiplier2">
<xsl:value-of select="swapStream[position()=$floatingLeg]/resetDates/resetFrequency/periodMultiplier"/>
</xsl:variable>
<xsl:variable name="periodMultiplier3">
<xsl:value-of select="swapStream[position()=$floatingLeg]/calculationPeriodAmount/calculation/floatingRateCalculation/indexTenor/periodMultiplier"/>
</xsl:variable>
<xsl:variable name="periodMultiplier6">
<xsl:value-of select="swapStream[position()=$floatingLeg]/paymentDates/paymentFrequency/periodMultiplier"/>
</xsl:variable>
<xsl:variable name="periodMultiplier4">
<xsl:value-of select="swapStream[position()=$fixedLeg]/calculationPeriodDates/calculationPeriodFrequency/periodMultiplier"/>
</xsl:variable>
<xsl:variable name="periodMultiplier5">
<xsl:value-of select="swapStream[position()=$fixedLeg]/paymentDates/paymentFrequency/periodMultiplier"/>
</xsl:variable>
<xsl:variable name="period1">
<xsl:value-of select="swapStream[position()=$floatingLeg]/calculationPeriodDates/calculationPeriodFrequency/period"/>
</xsl:variable>
<xsl:variable name="period2">
<xsl:value-of select="swapStream[position()=$floatingLeg]/resetDates/resetFrequency/period"/>
</xsl:variable>
<xsl:variable name="period3">
<xsl:value-of select="swapStream[position()=$floatingLeg]/calculationPeriodAmount/calculation/floatingRateCalculation/indexTenor/period"/>
</xsl:variable>
<xsl:variable name="period6">
<xsl:value-of select="swapStream[position()=$floatingLeg]/paymentDates/paymentFrequency/period"/>
</xsl:variable>
<xsl:variable name="period4">
<xsl:value-of select="swapStream[position()=$fixedLeg]/calculationPeriodDates/calculationPeriodFrequency/period"/>
</xsl:variable>
<xsl:variable name="period5">
<xsl:value-of select="swapStream[position()=$fixedLeg]/paymentDates/paymentFrequency/period"/>
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
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="$productType='OIS' or $isOISonSwaption='true'">
<xsl:if test="not($periodMultiplier1 = $periodMultiplier2) or not($period1 = $period2)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The floating swapStream calculationPeriodFrequency and resetFrequency do not match. They must match if product type is 'OIS' or an 'OIS on Swaption'</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="not($periodMultiplier4 = $periodMultiplier5)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The fixed swapStream calculationPeriodFrequency/periodMultiplier and paymentFrequency/periodMultiplier do not match.</text>
</error>
</xsl:if>
<xsl:if test="not($period4 = $period5)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The fixed swapStream calculationPeriodFrequency/period and paymentFrequency/period do not match.</text>
</error>
</xsl:if>
<xsl:variable name="businessDayConvention1">
<xsl:value-of select="swapStream[position()=$floatingLeg]/calculationPeriodDates/calculationPeriodDatesAdjustments/businessDayConvention"/>
</xsl:variable>
<xsl:variable name="businessDayConvention2">
<xsl:value-of select="swapStream[position()=$floatingLeg]/paymentDates/paymentDatesAdjustments/businessDayConvention"/>
</xsl:variable>
<xsl:variable name="businessDayConvention3">
<xsl:value-of select="swapStream[position()=$floatingLeg]/resetDates/resetDatesAdjustments/businessDayConvention"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="($productType='OIS' or $isOISonSwaption='true') and $businessDayConvention3 != 'NONE'">
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
<xsl:if test="$businessDayConvention3 != 'NONE'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The floating swapStream calculationPeriodDatesAdjustments/businessDayConvention and resetDatesAdjustments/businessDayConvention do not match:  calculationPeriodDatesAdjustments/businessDayConvention=NONE resetDatesAdjustments/businessDayConvention=<xsl:value-of select="$businessDayConvention3"/></text>
</error>
</xsl:if>
</xsl:when>
<xsl:otherwise>
<xsl:if test="not(($businessDayConvention1 = $businessDayConvention2) and ($businessDayConvention1 = $businessDayConvention3))  and  ($tradeCurrency != 'BRL') ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The floating swapStream calculationPeriodDatesAdjustments/businessDayConvention, paymentDatesAdjustments/businessDayConvention and resetDatesAdjustments/businessDayConvention do not match.</text>
</error>
</xsl:if>
</xsl:otherwise>
</xsl:choose>
<xsl:variable name="floatCalcPayFreqCombo">
<xsl:value-of select="swapStream[position()=$floatingLeg]/calculationPeriodDates/calculationPeriodFrequency/periodMultiplier"/>
<xsl:value-of select="swapStream[position()=$floatingLeg]/calculationPeriodDates/calculationPeriodFrequency/period"/>
<xsl:value-of select="swapStream[position()=$floatingLeg]/paymentDates/paymentFrequency/periodMultiplier"/>
<xsl:value-of select="swapStream[position()=$floatingLeg]/paymentDates/paymentFrequency/period"/>
</xsl:variable>
<xsl:if test="($productType='IRS' or $productType='Swaption') and not($interestRateSwapFloatingLegType='zeroCouponInterestRateSwapFloatingLeg')">
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
<xsl:if test="($productType='IRS' or $productType='Swaption') and ($interestRateSwapFloatingLegType='zeroCouponInterestRateSwapFloatingLeg')">
<xsl:choose>
<xsl:when test="$tradeCurrency = 'BRL' and $floatCalcPayFreqCombo='1T1T'"/>
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
<xsl:variable name="floatCalcFreq">
<xsl:value-of select="swapStream[@id='floatingLeg']/calculationPeriodDates/calculationPeriodFrequency/periodMultiplier"/>
<xsl:value-of select="swapStream[@id='floatingLeg']/calculationPeriodDates/calculationPeriodFrequency/period"/>
</xsl:variable>
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
<text>*** The floating swapStream calculationPeriodFrequency must be equal to 1T (OIS on Swaption), 28D, 1M, 3M, 6M or 1Y if product type is 'SingleCurrencyInterestRateSwap' or 'Swaption'. Value = '<xsl:value-of select="$floatCalcFreq"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:variable name="fixedCalcFreq">
<xsl:value-of select="swapStream[@id='fixedLeg']/calculationPeriodDates/calculationPeriodFrequency/periodMultiplier"/>
<xsl:value-of select="swapStream[@id='fixedLeg']/calculationPeriodDates/calculationPeriodFrequency/period"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$isZeroCouponInterestRateSwap != 'true'">
<xsl:if test="$productType='IRS' or $productType='Swaption'">
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
<text>*** The fixed swapStream calculationPeriodFrequency must be equal to 28D, 1M, 3M, 6M or 1Y if product type is 'SingleCurrencyInterestRateSwap' (except Zero Coupon IRS) or 'Swaption'. Value = '<xsl:value-of select="$fixedCalcFreq"/>'.</text>
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
<text>*** The fixed swapStream calculationPeriodFrequency must be equal to 1T, if product type is 'SingleCurrencyInterestRateSwap', 'OIS' or 'Swaption' with OIS indices, and a Zero Coupon IRS / OIS / Swaption. Value = '<xsl:value-of select="$fixedCalcFreq"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:when>
</xsl:choose>
<xsl:variable name="floatPayFreq">
<xsl:value-of select="swapStream[@id='floatingLeg']/paymentDates/paymentFrequency/periodMultiplier"/>
<xsl:value-of select="swapStream[@id='floatingLeg']/paymentDates/paymentFrequency/period"/>
</xsl:variable>
<xsl:choose>
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
<xsl:when test="$productType='IRS'">
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
<xsl:variable name="fixedPayFreq">
<xsl:value-of select="swapStream[@id='fixedLeg']/paymentDates/paymentFrequency/periodMultiplier"/>
<xsl:value-of select="swapStream[@id='fixedLeg']/paymentDates/paymentFrequency/period"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$isZeroCouponInterestRateSwap != 'true'">
<xsl:if test="$productType='IRS' or $productType='Swaption'">
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
<text>*** The fixed swapstream paymentFrequency must be equal to 28D, 1M, 3M, 6M or 1Y if product type is 'SingleCurrencyInterestRateSwap' (except Zero Coupon IRS) or 'Swaption'. Value = '<xsl:value-of select="$fixedPayFreq"/>'.</text>
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
<text>*** The fixed swapStream paymentFrequency must be equal to 1T, if product type is 'SingleCurrencyInterestRateSwap', 'OIS' or 'Swaption' with OIS indices, and a Zero Coupon IRS / OIS / Swaption. Value = '<xsl:value-of select="$fixedPayFreq"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:when>
</xsl:choose>
<xsl:variable name="rollConvention">
<xsl:value-of select="swapStream[position()=$floatingLeg]/calculationPeriodDates/calculationPeriodFrequency/rollConvention"/>
</xsl:variable>
<xsl:if test="starts-with($rollConvention,'IMM') and $productType!='IRS' and $productType!='OIS'">
<xsl:if test="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swStub/swStubPosition and not(//SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swStub/swStubPosition[.='Start'])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** /SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swStub/swStubPosition must be equal to 'Start' for IMM rolls.</text>
</error>
</xsl:if>
<xsl:if test="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swStub/swStubLength and not(//SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swStub/swStubLength[.='Short'])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** /SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swStub/swStubLength must be equal to 'Short' for IMM rolls.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="($productType='IRS' or $productType='OIS') and count(//swExtendedTradeDetails/swStub)=2">
<xsl:variable name="firstFixedRegularPeriodStartDate">
<xsl:value-of select="swapStream[@id='fixedLeg']/calculationPeriodDates/firstRegularPeriodStartDate"/>
</xsl:variable>
<xsl:variable name="firstFloatRegularPeriodStartDate">
<xsl:value-of select="swapStream[@id='floatingLeg']/calculationPeriodDates/firstRegularPeriodStartDate"/>
</xsl:variable>
<xsl:variable name="firstFixedPaymentDate">
<xsl:value-of select="swapStream[@id='fixedLeg']/paymentDates/firstPaymentDate"/>
</xsl:variable>
<xsl:variable name="firstFloatPaymentDate">
<xsl:value-of select="swapStream[@id='floatingLeg']/paymentDates/firstPaymentDate"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="starts-with($rollConvention,'IMM')"/>
<xsl:when test="$rollConvention='EOM'"/>
<xsl:otherwise>
<xsl:if test="not($isZeroCouponInterestRateSwap) and $firstFixedRegularPeriodStartDate != number(substring($firstFixedRegularPeriodStartDate,9))!=number($rollConvention) and not(substring($firstFixedRegularPeriodStartDate,6,2) ='02' and number($rollConvention) &gt;=29)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Fixed leg calculationPeriodDates/firstRegularPeriodStartDate must fall on same day of month as rollConvention.  Value = '<xsl:value-of select = "$firstFixedRegularPeriodStartDate"/>'.  RollConvention = '<xsl:value-of select="$rollConvention"/>'.</text>
</error>
</xsl:if>
<xsl:if test="$firstFloatRegularPeriodStartDate !='' and $interestRateSwapFloatingLegType='aNonZCIRSFloatingLeg' and number(substring($firstFloatRegularPeriodStartDate,9))!=number($rollConvention) and not (substring($firstFloatRegularPeriodStartDate,6,2) ='02' and number($rollConvention) &gt;=29)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Floating leg calculationPeriodDates/firstRegularPeriodStartDate must fall on same day of month as rollConvention.  Value = '<xsl:value-of select = "$firstFloatRegularPeriodStartDate"/>'.  RollConvention = '<xsl:value-of select="$rollConvention"/>'.</text>
</error>
</xsl:if>
<xsl:if test="$firstFixedPaymentDate !='' and not($isZeroCouponInterestRateSwap) and number(substring($firstFixedPaymentDate,9))!=number($rollConvention) and not(substring($firstFixedPaymentDate,6,2) ='02' and number($rollConvention) &gt;=29)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Fixed leg paymentDates/firstPaymentDate must fall on same day of month as rollConvention.  Value = '<xsl:value-of select = "$firstFixedPaymentDate"/>'.  RollConvention = '<xsl:value-of select="$rollConvention"/>'.</text>
</error>
</xsl:if>
<xsl:if test="$firstFloatPaymentDate !='' and $interestRateSwapFloatingLegType='aNonZCIRSFloatingLeg' and number(substring($firstFloatPaymentDate,9))!=number($rollConvention) and not (substring($firstFloatPaymentDate,6,2) ='02' and number($rollConvention) &gt;=29)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Floating leg paymentDates/firstPaymentDate must fall on same day of month as rollConvention.  Value = '<xsl:value-of select = "$firstFloatPaymentDate"/>'.  RollConvention = '<xsl:value-of select="$rollConvention"/>'.</text>
</error>
</xsl:if>
</xsl:otherwise>
</xsl:choose>
<xsl:if test="swapStream/calculationPeriodDates/stubPeriodType">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** calculationPeriodDates/stubPeriodType must not be present for trades with both front and back stubs.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="swapStream">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="earlyTerminationProvision">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="count(additionalPayment) &gt; 8">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of additionalPayment child elements encountered. 0 to 8 expected.</text>
</error>
</xsl:if>
<xsl:if test="count(additionalPayment) = 7">
<xsl:if test="not(additionalPayment[paymentType = 'Independent Amount'] or additionalPayment[paymentType = 'Cancellation'])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** If seven additionalPayment child elements are present then one must be identified as an Independent Amount (paymentType = 'Independent Amount') or Cancellation (paymentType = 'Cancellation').</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="count(additionalPayment) = 8">
<xsl:if test="not(additionalPayment[paymentType = 'Independent Amount'] and additionalPayment[paymentType = 'Cancellation'])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** If eight additionalPayment child elements are present then one must be identified as an Independent Amount (paymentType = 'Independent Amount') and one a Cancellation (paymentType = 'Independent Amount').</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="count(additionalPayment[paymentType = 'Independent Amount']) &gt; 1">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** A maximum of one additionalPayment child element can be identified as an Independent Amount (paymentType = 'Independent Amount').</text>
</error>
</xsl:if>
<xsl:if test="count(additionalPayment[paymentType = 'Cancellation']) &gt; 1">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** A maximum of one additionalPayment child element can be identified as a Cancellation (paymentType = 'Cancellation').</text>
</error>
</xsl:if>
<xsl:if test="additionalPayment">
<xsl:if test="not($productType='IRS' or $productType='OIS' or $productType='Swaption')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** additionalPayment is only allowed in this context if product type is 'SingleCurrencyInterestRateSwap' or 'OIS' or 'Swaption'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="additionalPayment">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="additionalTerms">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="additionalTerms">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="$productType='IRS' or $productType='OIS'">
<xsl:variable name="conditionPrecedentBondId">
<xsl:value-of select="conditionPrecedentBond/instrumentId"/>
</xsl:variable>
<xsl:variable name="conditionPrecedentBondMaturity">
<xsl:value-of select="conditionPrecedentBond/maturity"/>
</xsl:variable>
<xsl:if test="$participantSupplement='Fannie Mae' and (($conditionPrecedentBondId!='' and $conditionPrecedentBondMaturity='') or ($conditionPrecedentBondMaturity!='' and $conditionPrecedentBondId=''))">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** For a swParticipantSupplement value of Fannie Mae if either conditionPrecedentBond/instrumentId or conditionPrecedentBond/maturity have a value they both must have.</text>
</error>
</xsl:if>
<xsl:if test="//cancelableProvision">
<xsl:variable name="conditionPrecedentBond">
<xsl:value-of select="//swExtendedTradeDetails/swBondClauses/swConditionPrecedentBond"/>
</xsl:variable>
<xsl:variable name="discrepancyClause">
<xsl:value-of select="//swExtendedTradeDetails/swBondClauses/swDiscrepancyClause"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$conditionPrecedentBondId!='' and not (//swExtendedTradeDetails/swBondClauses)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** A cancelable option with a conditionPrecedentBond/instrumentId must have a swBondClauses tag</text>
</error>
</xsl:when>
<xsl:when test="$conditionPrecedentBondId!='' and $conditionPrecedentBond!='true' and $conditionPrecedentBond!='false'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** A cancelable option with a conditionPrecedentBond/instrumentId must have a swBondClauses/swConditionPrecedentBond value of true or false</text>
</error>
</xsl:when>
<xsl:when test="$conditionPrecedentBondId!='' and $discrepancyClause!='true' and $discrepancyClause!='false'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** A cancelable option with a conditionPrecedentBond/instrumentId must have a swBondClauses/swDiscrepancyClause value of true or false</text>
</error>
</xsl:when>
<xsl:otherwise/>
</xsl:choose>
</xsl:if>
</xsl:if>
</xsl:template>
<xsl:template match="swapStream">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:variable name="href1">
<xsl:value-of select="payerPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="href2">
<xsl:value-of select="receiverPartyReference/@href"/>
</xsl:variable>
<xsl:if test="$href1=$href2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** payerPartyReference/@href and receiverPartyReference/@href values must not be the same.</text>
</error>
</xsl:if>
<xsl:if test="not(//FpML/trade/party[@id=substring-after($href1,'#')])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** payerPartyReference/@href does not reference a valid //FpML/trade/party/@id. Value = '<xsl:value-of select="$href1"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not(//FpML/trade/party[@id=substring-after($href2,'#')])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** receiverPartyReference/@href does not reference a valid //FpML/trade/party/@id. Value = '<xsl:value-of select="$href2"/>'.</text>
</error>
</xsl:if>
<xsl:apply-templates select="calculationPeriodDates">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="paymentDates">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="resetDates">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="calculationPeriodAmount">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="stubCalculationPeriodAmount">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="calculationPeriodDates">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
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
<xsl:value-of select="effectiveDate/unadjustedDate"/>
</xsl:variable>
<xsl:variable name="terminationDate">
<xsl:value-of select="terminationDate/unadjustedDate"/>
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
<xsl:apply-templates select="effectiveDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="terminationDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="calculationPeriodDatesAdjustments">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="firstRegularPeriodStartDate">
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">firstRegularPeriodStartDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="firstRegularPeriodStartDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="lastRegularPeriodEndDate">
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">lastRegularPeriodEndDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="lastRegularPeriodEndDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:apply-templates select="calculationPeriodFrequency">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="effectiveDate">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="//swap">
<xsl:variable name="businessDayConvention1">
<xsl:value-of select="dateAdjustments/businessDayConvention"/>
</xsl:variable>
<xsl:if test="$businessDayConvention1!='NONE'">
<xsl:variable name="businessDayConvention2">
<xsl:value-of select="../../paymentDates/paymentDatesAdjustments/businessDayConvention"/>
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
<xsl:if test="//swap and $productType!='IRS' and $productType!='OIS'">
<xsl:variable name="businessDayConvention1">
<xsl:value-of select="dateAdjustments/businessDayConvention"/>
</xsl:variable>
<xsl:variable name="businessDayConvention2">
<xsl:value-of select="calculationPeriodDatesAdjustments/businessDayConvention"/>
</xsl:variable>
<xsl:if test="$businessDayConvention1!='NONE' and $businessDayConvention2!='NONE'">
<xsl:variable name="busCenters1">
<xsl:for-each select="dateAdjustments/businessCenters/businessCenter">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:variable>
<xsl:variable name="busCenters2">
<xsl:for-each select="//swapStream[position()=$floatingLeg]/calculationPeriodDates/calculationPeriodDatesAdjustments/businessCenters/businessCenter">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:variable>
<xsl:if test="$busCenters1!= $busCenters2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Under effectiveDate, if dateAdjustments/businessDayConvention is not equal to 'NONE' /dateAdjustments/businessCenters must equal floating leg calculationPeriodDates/calculationPeriodDatesAdjustments/businessCenters.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">unadjustedDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="unadjustedDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:apply-templates select="dateAdjustments">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="terminationDate">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="//swap">
<xsl:variable name="businessDayConvention1">
<xsl:value-of select="dateAdjustments/businessDayConvention"/>
</xsl:variable>
<xsl:variable name="businessDayConvention2">
<xsl:choose>
<xsl:when test="$productType='CapFloor'">
<xsl:value-of select="//trade/capFloor/capFloorStream/calculationPeriodDates/calculationPeriodDatesAdjustments/businessDayConvention"/>
</xsl:when>
<xsl:when test="$productType='IRS'">
<xsl:value-of select="../calculationPeriodDatesAdjustments/businessDayConvention"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="//trade//swapStream[position()=$floatingLeg]/calculationPeriodDates/calculationPeriodDatesAdjustments/businessDayConvention"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:if test="$businessDayConvention1!='NONE' and $businessDayConvention2!='NONE'">
<xsl:variable name="busCenters1">
<xsl:for-each select="dateAdjustments/businessCenters/businessCenter">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:variable>
<xsl:variable name="busCenters2">
<xsl:choose>
<xsl:when test="$productType='IRS' or $productType='OIS'">
<xsl:for-each select="../calculationPeriodDatesAdjustments/businessCenters/businessCenter">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:when>
<xsl:otherwise>
<xsl:for-each select="//swapStream[position()=$floatingLeg]/calculationPeriodDates/calculationPeriodDatesAdjustments/businessCenters/businessCenter">
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
<text>*** Under terminationDate, if dateAdjustments/businessDayConvention is not equal to 'NONE' /dateAdjustments/businessCenters must equal floating leg calculationPeriodDates/calculationPeriodDatesAdjustments/businessCenters.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">unadjustedDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="unadjustedDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:apply-templates select="dateAdjustments">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="calculationPeriodDatesAdjustments">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="($productType='IRS' or $productType='Swaption')">
<xsl:variable name="businessDayConvention1">
<xsl:value-of select="businessDayConvention"/>
</xsl:variable>
<xsl:if test="$businessDayConvention1!='NONE'">
<xsl:variable name="businessDayConvention2">
<xsl:value-of select="../../paymentDates/paymentDatesAdjustments/businessDayConvention"/>
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
<xsl:if test="//swap and $productType!='IRS' and $productType!='OIS'">
<xsl:variable name="businessDayConvention1">
<xsl:value-of select="//swapStream[position()=$floatingLeg]/calculationPeriodDates/calculationPeriodDatesAdjustments/businessDayConvention"/>
</xsl:variable>
<xsl:variable name="businessDayConvention2">
<xsl:value-of select="//swapStream[position()=3-$floatingLeg]/calculationPeriodDates/calculationPeriodDatesAdjustments/businessDayConvention"/>
</xsl:variable>
<xsl:if test="$businessDayConvention1!='NONE' and $businessDayConvention2!='NONE'">
<xsl:variable name="busCenters1">
<xsl:for-each select="//swapStream[position()=3-$floatingLeg]/calculationPeriodDates/calculationPeriodDatesAdjustments/businessCenters/businessCenter">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:variable>
<xsl:variable name="busCenters2">
<xsl:for-each select="//swapStream[position()=$floatingLeg]/calculationPeriodDates/calculationPeriodDatesAdjustments/businessCenters/businessCenter">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:variable>
<xsl:if test="$busCenters1!= $busCenters2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** If businessDayConvention is not equal to 'NONE' businessCenters must equal floating leg calculationPeriodDates/calculationPeriodDatesAdjustments/businessCenters.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
<xsl:if test="$productType='IRS'">
<xsl:variable name="floatingRateIndex">
<xsl:value-of select="//swapStream[position()=$floatingLeg]/calculationPeriodAmount/calculation/floatingRateCalculation/floatingRateIndex"/>
</xsl:variable>
<xsl:variable name="contractualDefinition">
<xsl:value-of select="//swStructuredTradeDetails/swExtendedTradeDetails/swTradeHeader/swContractualDefinitions"/>
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
<xsl:variable name="businessDayConvention">
<xsl:value-of select="businessDayConvention"/>
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
<xsl:if test="businessCentersReference">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected element businessCentersReference encountered.</text>
</error>
</xsl:if>
<xsl:if test="$businessDayConvention='NONE'">
<xsl:if test="businessCenters">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected element businessCenters encountered when businessDayConvention = 'NONE'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$businessDayConvention!='NONE'">
<xsl:if test="not(businessCenters)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing businessCenters. Needed when businessDayConvention not equal to 'NONE'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="businessCenters">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="calculationPeriodFrequency">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:call-template name="isValidPeriodMultiplier">
<xsl:with-param name="elementName">periodMultiplier</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="periodMultiplier"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="isValidPeriod">
<xsl:with-param name="elementName">period</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="period"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:variable name="freq">
<xsl:value-of select="periodMultiplier"/>
<xsl:value-of select="period"/>
</xsl:variable>
<xsl:variable name="oisfloatFreq">
<xsl:value-of select="//swapStream[@id='floatingLeg']/calculationPeriodDates/calculationPeriodFrequency/periodMultiplier"/>
<xsl:value-of select="//swapStream[@id='floatingLeg']/calculationPeriodDates/calculationPeriodFrequency/period"/>
</xsl:variable>
<xsl:variable name="oisfixedFreq">
<xsl:value-of select="//swapStream[@id='fixedLeg']/calculationPeriodDates/calculationPeriodFrequency/periodMultiplier"/>
<xsl:value-of select="//swapStream[@id='fixedLeg']/calculationPeriodDates/calculationPeriodFrequency/period"/>
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
<text>*** calculationPeriodFrequency must be equal to 1Y or 1T if product type is 'OIS'. Value = '<xsl:value-of select="$freq"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:call-template name="isValidRollConvention">
<xsl:with-param name="elementName">rollConvention</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="rollConvention"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:variable name="rollConvention">
<xsl:value-of select="rollConvention"/>
</xsl:variable>
<xsl:if test="$freq='1T' and $tradeCurrency != 'CLP' and $productType != 'Single Currency Basis Swap' and $productType != 'OIS' and $isOISonSwaption='false' and not(starts-with($rollConvention,'IMM'))">
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
<xsl:if test="($productType='IRS' or $productType='Swaption' or $productType='CapFloor') and $tradeCurrency='MXN'">
<xsl:if test="not($rollConvention='NONE')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** rollConvention must be equal to 'NONE' if product type is 'SingleCurrencyInterestRateSwap', 'Swaption' or 'CapFloor' and currency is 'MXN'. Value = '<xsl:value-of select="$rollConvention"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$productType='IRS' and $tradeCurrency='BRL'">
<xsl:if test="not($rollConvention='NONE')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** rollConvention must be equal to 'NONE' if product type is 'SingleCurrencyInterestRateSwap' and currency is 'BRL'. Value = '<xsl:value-of select="$rollConvention"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="(starts-with($rollConvention,'IMM'))">
<xsl:variable name="floatFreq">
<xsl:value-of select="//swapStream[@id='floatingLeg']/calculationPeriodDates/calculationPeriodFrequency/periodMultiplier"/>
<xsl:value-of select="//swapStream[@id='floatingLeg']/calculationPeriodDates/calculationPeriodFrequency/period"/>
<xsl:value-of select="//capFloorStream/calculationPeriodDates/calculationPeriodFrequency/periodMultiplier"/>
<xsl:value-of select="//capFloorStream/calculationPeriodDates/calculationPeriodFrequency/period"/>
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
<xsl:if test="not(../firstRegularPeriodStartDate or $productType='OIS')">
<xsl:if test="not( $productType='IRS' or $productType='Single Currency Basis Swap')">
<xsl:call-template name="isValidIMMMonth">
<xsl:with-param name="elementName">../effectiveDate/unadjustedDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="../effectiveDate/unadjustedDate"/>
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
<xsl:if test="not((../lastRegularPeriodEndDate and ($productType='IRS')) or $productType='OIS')">
<xsl:if test="not( $productType='IRS' or $productType='Single Currency Basis Swap')">
<xsl:call-template name="isValidIMMMonth">
<xsl:with-param name="elementName">../terminationDate/unadjustedDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="../terminationDate/unadjustedDate"/>
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
<xsl:template match="paymentDates">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:variable name="href">
<xsl:value-of select="substring-after(calculationPeriodDatesReference/@href,'#')"/>
</xsl:variable>
<xsl:variable name="id">
<xsl:value-of select="../calculationPeriodDates/@id"/>
</xsl:variable>
<xsl:if test="$href!=$id">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid calculationPeriodDatesReference/@href value. Value is not equal to ../calculationPeriodDates/@id. Value of href = '<xsl:value-of select="$href"/>' and id = '<xsl:value-of select="$id"/>'.</text>
</error>
</xsl:if>
<xsl:apply-templates select="paymentFrequency">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="firstPaymentDate">
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">firstPaymentDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="firstPaymentDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="lastRegularPaymentDate">
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">lastRegularPaymentDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="lastRegularPaymentDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:variable name="payRelativeTo">
<xsl:value-of select="payRelativeTo"/>
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
<xsl:apply-templates select="paymentDaysOffset">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="paymentDatesAdjustments">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="paymentFrequency">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:variable name="periodMultiplier">
<xsl:value-of select="periodMultiplier"/>
</xsl:variable>
<xsl:call-template name="isValidPeriodMultiplier">
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
<xsl:value-of select="period"/>
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
<xsl:value-of select="periodMultiplier"/>
<xsl:value-of select="period"/>
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
<text>*** paymentFrequency must be equal to 1M, 3M, 6M, 1Y or 1T if product type is 'OIS'. Value = '<xsl:value-of select="$freq"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:template>
<xsl:template match="paymentDaysOffset">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:variable name="periodMultiplier">
<xsl:value-of select="periodMultiplier"/>
</xsl:variable>
<xsl:call-template name="isValidPeriodMultiplier">
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
<xsl:value-of select="period"/>
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
<xsl:value-of select="dayType"/>
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
<xsl:template match="paymentDatesAdjustments">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:variable name="businessDayConvention">
<xsl:value-of select="businessDayConvention"/>
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
<xsl:if test="businessCentersReference">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected element businessCentersReference encountered.</text>
</error>
</xsl:if>
<xsl:if test="$businessDayConvention!='NONE'">
<xsl:if test="not(businessCenters)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing businessCenters. Needed when businessDayConvention not equal to 'NONE'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="businessCenters">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="resetDates">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:variable name="href">
<xsl:value-of select="substring-after(calculationPeriodDatesReference/@href,'#')"/>
</xsl:variable>
<xsl:variable name="id">
<xsl:value-of select="../calculationPeriodDates/@id"/>
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
<xsl:value-of select="resetFrequency/periodMultiplier"/>
<xsl:value-of select="resetFrequency/period"/>
</xsl:variable>
<xsl:if test="resetRelativeTo">
<xsl:if test="$resetFreq= '1D'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected resetRelativeTo child element encountered. Not allowed if Reset Frequency is daily.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$resetFreq!='1D'">
<xsl:call-template name="isValidResetRelativeTo">
<xsl:with-param name="elementName">resetRelativeTo</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="resetRelativeTo"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="initialFixingDate">
<xsl:if test="$productType='CapFloor'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected initialFixingDate child element encountered. Not allowed if product type is '<xsl:value-of select="$productType"/>'</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="initialFixingDate">
<xsl:if test="not($tradeCurrency = 'USD' or $tradeCurrency = 'CHF' or $tradeCurrency = 'CNY' or $tradeCurrency = 'MYR' or $tradeCurrency = 'TWD')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** initialFixingDate should only be present if trade currency is equal to 'USD' or 'CHF' or 'CNY' or 'MYR' or 'TWD'. Value = '<xsl:value-of select="$tradeCurrency"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="initialFixingDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fixingDates">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="initialFixingDate">
<xsl:variable name="initialFixingPeriodMultiplier">
<xsl:for-each select="initialFixingDate/periodMultiplier">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:variable>
<xsl:variable name="fixingPeriodMultiplier">
<xsl:for-each select="fixingDates/periodMultiplier">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:variable>
<xsl:variable name="initialFixingBusCenters">
<xsl:for-each select="initialFixingDate/businessCenters/businessCenter">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:variable>
<xsl:variable name="fixingBusCenters">
<xsl:for-each select="fixingDates/businessCenters/businessCenter">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:variable>
<xsl:if test="($initialFixingPeriodMultiplier = $fixingPeriodMultiplier) and ($initialFixingBusCenters = $fixingBusCenters)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** initialFixingDate offset rules must only be included if they are different to those specified in fixingDates. Currently they are specified the same.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="resetFrequency">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="resetDatesAdjustments">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="initialFixingDate|fixingDates">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:variable name="periodMultiplier">
<xsl:value-of select="periodMultiplier"/>
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
<xsl:value-of select="period"/>
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
<xsl:if test="not(businessDayConvention='PRECEDING') and not($tradeCurrency='BRL')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** businessDayConvention must equal 'PRECEDING' if periodMultiplier is '0' and period is 'D'. Value = '<xsl:value-of select="businessDayConvention"/>'.</text>
</error>
</xsl:if>
<xsl:if test="($tradeCurrency='BRL') and not(businessDayConvention='FOLLOWING')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** businessDayConvention must equal 'FOLLOWING' if periodMultiplier is '0' and period is 'D' and trade currency is BRL. Value = '<xsl:value-of select="businessDayConvention"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:variable name="dayType">
<xsl:value-of select="dayType"/>
</xsl:variable>
<xsl:if test="$periodMultiplier!='0' and $period='D' and $dayType='Business'">
<xsl:if test="not(businessDayConvention='NONE')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** businessDayConvention must equal 'NONE' if period is equal to 'D' and periodMultiplier is not equal to '0' and dayType is equal to 'Business'. Value = '<xsl:value-of select="businessDayConvention"/>'.</text>
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
<xsl:value-of select="businessDayConvention"/>
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
<xsl:if test="businessCentersReference">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected element businessCentersReference encountered.</text>
</error>
</xsl:if>
<xsl:if test="$businessDayConvention!='NONE'">
<xsl:if test="not(businessCenters)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing businessCenters. Needed when businessDayConvention not equal to 'NONE'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$dayType='Business'">
<xsl:if test="not(businessCenters)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing businessCenters. Needed when dayType is equal to 'Business'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="businessCenters">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:variable name="href">
<xsl:value-of select="substring-after(dateRelativeTo/@href,'#')"/>
</xsl:variable>
<xsl:variable name="id">
<xsl:choose>
<xsl:when test="$productType='Fixed Fixed Swap'">
<xsl:value-of select="../../../../paymentDates/@id"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="../../resetDates/@id"/>
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
<xsl:variable name="dateRelativeTo">
<xsl:value-of select="dateRelativeTo"/>
</xsl:variable>
<xsl:if test="$dateRelativeTo!='ResetDate'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid dateRelativeTo value. Value = '<xsl:value-of select="$dateRelativeTo"/>'.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="resetFrequency">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:call-template name="isValidPeriodMultiplier">
<xsl:with-param name="elementName">periodMultiplier</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="periodMultiplier"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="isValidPeriod">
<xsl:with-param name="elementName">period</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="period"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:variable name="freq">
<xsl:value-of select="periodMultiplier"/>
<xsl:value-of select="period"/>
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
<text>*** resetFrequency must be equal to 1M, 3M, 6M,1Y or 1T if product type is 'OIS'. Value = '<xsl:value-of select="$freq"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:template>
<xsl:template match="swRollFrequency">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:call-template name="isValidPeriodMultiplier">
<xsl:with-param name="elementName">periodMultiplier</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="periodMultiplier"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="isValidPeriod">
<xsl:with-param name="elementName">period</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="period"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:template>
<xsl:template match="swFloatPaymentFrequency">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:call-template name="isValidPeriodMultiplier">
<xsl:with-param name="elementName">periodMultiplier</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="periodMultiplier"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="isValidPeriod">
<xsl:with-param name="elementName">period</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="period"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:template>
<xsl:template match="swFixedPaymentFrequency">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:call-template name="isValidPeriodMultiplier">
<xsl:with-param name="elementName">periodMultiplier</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="periodMultiplier"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="isValidPeriod">
<xsl:with-param name="elementName">period</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="period"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:template>
<xsl:template match="swCompoundingMethod">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:call-template name="isValidCompoundingMethod">
<xsl:with-param name="elementName">swCompoundingMethod</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="/SWDML/swShortFormTrade//swCompoundingMethod"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:template>
<xsl:template match="swFixedStubLength">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:call-template name="isValidStubLength">
<xsl:with-param name="elementName">swFixedStubLength</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="/SWDML/swShortFormTrade//swFixedStubLength"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:template>
<xsl:template match="swFloatStubLength">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:call-template name="isValidStubLength">
<xsl:with-param name="elementName">swFloatStubLength</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="/SWDML/swShortFormTrade//swFloatStubLength"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:template>
<xsl:template match="swStubIndexTenor">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:call-template name="isValidPeriodMultiplier">
<xsl:with-param name="elementName">periodMultiplier</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="periodMultiplier"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="isValidPeriod">
<xsl:with-param name="elementName">period</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="period"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:template>
<xsl:template match="resetDatesAdjustments">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:variable name="businessDayConvention">
<xsl:value-of select="businessDayConvention"/>
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
<xsl:if test="businessCentersReference">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected element businessCentersReference encountered.</text>
</error>
</xsl:if>
<xsl:if test="$businessDayConvention!='NONE'">
<xsl:if test="not(businessCenters)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing businessCenters. Needed when businessDayConvention not equal to 'NONE'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="businessCenters">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="calculationPeriodAmount">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="$interestRateSwapType = 'zeroCouponInterestRateSwapWithFixedAmount'">
<xsl:apply-templates select="knownAmountSchedule">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
<xsl:apply-templates select="calculation">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="knownAmountSchedule">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:variable name="initialValue">
<xsl:value-of select="initialValue"/>
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
</xsl:template>
<xsl:template match="calculation">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:call-template name="isValidDayCountFraction">
<xsl:with-param name="elementName">dayCountFraction</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="dayCountFraction"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="compoundingMethod">
<xsl:choose>
<xsl:when test="not(../../resetDates)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** compoundingMethod must only exist on floating stream.</text>
</error>
</xsl:when>
<xsl:when test="compoundingMethod = 'SpreadExclusive' and //swExtendedTradeDetails/swTradeHeader/swContractualDefinitions = 'ISDA2000'">
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
<xsl:value-of select="compoundingMethod"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="../../resetDates">
<xsl:variable name="calcFreq">
<xsl:value-of select="../../calculationPeriodDates/calculationPeriodFrequency/periodMultiplier"/>
<xsl:value-of select="../../calculationPeriodDates/calculationPeriodFrequency/period"/>
</xsl:variable>
<xsl:variable name="payFreq">
<xsl:value-of select="../../paymentDates/paymentFrequency/periodMultiplier"/>
<xsl:value-of select="../../paymentDates/paymentFrequency/period"/>
</xsl:variable>
<xsl:if test="not($calcFreq = $payFreq)">
<xsl:if test="not(compoundingMethod)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing element. compoundingMethod must be present when compounding is implied by different payment and calculation frequencies.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$calcFreq = $payFreq and $tradeCurrency != 'CLP'">
<xsl:if test="compoundingMethod">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** compoundingMethod must not be present when compounding is not implied by payment and calculation frequencies.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="notionalSchedule">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fixedRateSchedule">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="floatingRateCalculation">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="notionalSchedule">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:apply-templates select="notionalStepSchedule">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="notionalStepSchedule">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:variable name="initialValue">
<xsl:value-of select="initialValue"/>
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
<xsl:value-of select="currency"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="step and $productType != 'IRS' and $productType != 'OIS'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** step element must not be specified. Step up/down notional not currently supported via API.</text>
</error>
</xsl:if>
<xsl:apply-templates select="step">
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
<xsl:value-of select="(count(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$leg]/calculationPeriodAmount/calculation/floatingRateCalculation/spreadSchedule/step))"/>
</xsl:variable>
<xsl:variable name="notionalScheduleSteps">
<xsl:value-of select="
count(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$leg]/calculationPeriodAmount/calculation/notionalSchedule/notionalStepSchedule/step)"/>
</xsl:variable>
<xsl:variable name="fixedRateScheduleNumberOfSteps">
<xsl:value-of select="(count(/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$leg]/calculationPeriodAmount/calculation/fixedRateSchedule/step))"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$leg = $floatingLeg">
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
<xsl:template match="step">
<xsl:param name="context"/>
<xsl:param name="parent"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="position()=1 and number(stepValue) != number(../initialValue)">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** initial stepValue ('<xsl:value-of select="stepValue"/>') of schedule does not equal initialValue ('<xsl:value-of select="../initialValue"/>') for schedule.</text>
</error>
</xsl:if>
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">stepDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="stepDate"/>
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
<xsl:value-of select="stepDate"/>
</xsl:variable>
<xsl:variable name="thisLeg">
<xsl:choose>
<xsl:when test="ancestor::swapStream = /SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=1]">1</xsl:when>
<xsl:when test="ancestor::swapStream = /SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=2]">2</xsl:when>
</xsl:choose>
</xsl:variable>
<xsl:variable name="comparisonStepDate">
<xsl:choose>
<xsl:when test="$parent ='notionalStepSchedule'">
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$thisLeg]/calculationPeriodAmount/calculation/fixedRateSchedule/step[position()=$stepOrdinal]/stepDate">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$thisLeg]/calculationPeriodAmount/calculation/fixedRateSchedule/step[position()=$stepOrdinal]/stepDate"/>
</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$thisLeg]/calculationPeriodAmount/calculation/floatingRateCalculation/spreadSchedule/step[position()=$stepOrdinal]/stepDate">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$thisLeg]/calculationPeriodAmount/calculation/floatingRateCalculation/spreadSchedule/step[position()=$stepOrdinal]/stepDate"/>
</xsl:when>
<xsl:otherwise>0</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$parent ='fixedRateSchedule' or $parent ='spreadSchedule'">
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$thisLeg]/calculationPeriodAmount/calculation/notionalSchedule/notionalStepSchedule/step[position()=$stepOrdinal]/stepDate">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$thisLeg]/calculationPeriodAmount/calculation/notionalSchedule/notionalStepSchedule/step[position()=$stepOrdinal]/stepDate"/>
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
<xsl:if test="$stepOrdinal > 1">
<xsl:if test="(number(translate($stepDate, '-', '')) - number(translate(../step[position()=$stepOrdinal - 1]/stepDate, '-', ''))) &lt; 1">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$parent"/>/step(<xsl:value-of select="$stepOrdinal"/>)/stepDate of '<xsl:value-of select="$stepDate"/>' is not greater than the stepDate of the preceding step (<xsl:value-of select="../step[position()=$stepOrdinal - 1]/stepDate"/>)</text>
</error>
</xsl:if>
</xsl:if>
<xsl:choose>
<xsl:when test="$parent='notionalStepSchedule'">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">stepValue</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="stepValue"/>
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
<xsl:value-of select="stepValue"/>
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
<xsl:template match="fixedRateSchedule">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:variable name="initialValue">
<xsl:value-of select="initialValue"/>
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
<xsl:if test="step">
<xsl:choose>
<xsl:when test="$productType != 'IRS' and $productType != 'OIS'">
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
<xsl:apply-templates select="step">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
<xsl:with-param name="parent">fixedRateSchedule</xsl:with-param>
</xsl:apply-templates>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:template>
<xsl:template match="floatingRateCalculation">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:variable name="floatingRateIndex">
<xsl:value-of select="floatingRateIndex"/>
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
<xsl:if test="$productType='OIS'">
<xsl:if test="initialRate">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** initialRate must not be present if product type is 'OIS'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$productType='Swaption'">
<xsl:if test="initialRate">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** initialRate must not be present if product type is 'Swaption'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$productType='CapFloor'">
<xsl:if test="initialRate">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** initialRate must not be present if product type is 'CapFloor'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="initialRate">
<xsl:if test="../../../stubCalculationPeriodAmount/initialStub">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** initialRate and ../../../stubCalculationPeriodAmount/initialStub must not both be present.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="initialRate">
<xsl:variable name="initialRate">
<xsl:value-of select="initialRate"/>
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
<xsl:if test="indexTenor">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** indexTenor must not be present if product type is 'OIS', 'OIS on Swaption' or 'OIS on CapFloor'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="indexTenor">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="spreadSchedule">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="$productType='CapFloor'">
<xsl:if test="not(capRateSchedule or floorRateSchedule)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing element. capRateSchedule or floorRateSchedule must be present if product type is 'CapFloor'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$productType='CapFloor'">
<xsl:if test="capRateSchedule and floorRateSchedule">
<xsl:if test="number(capRateSchedule/initialValue) != number(floorRateSchedule/initialValue)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** When both capRateSchedule and floorRateSchedule are present they must contain the same data.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="capRateSchedule">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="floorRateSchedule">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="indexTenor">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:call-template name="isValidPeriodMultiplier">
<xsl:with-param name="elementName">periodMultiplier</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="periodMultiplier"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="isValidPeriod">
<xsl:with-param name="elementName">period</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="period"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="($productType='IRS' or $productType='Swaption') and not(parent::floatingRate)">
<xsl:variable name="indexTenor">
<xsl:value-of select="periodMultiplier"/>
<xsl:value-of select="period"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$indexTenor='28D'"/>
<xsl:when test="$indexTenor='1M'"/>
<xsl:when test="$indexTenor='3M'"/>
<xsl:when test="$indexTenor='6M'"/>
<xsl:when test="$indexTenor='12M'"/>
<xsl:when test="$indexTenor='1Y'"/>
<xsl:when test="$indexTenor='1W' and $tradeCurrency='CNY'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** indexTenor must be equal to 28D, 1M, 3M, 6M or 1Y if product type is 'SingleCurrencyInterestRateSwap' or 'Swaption'. Value = '<xsl:value-of select="$indexTenor"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="$productType='FRA'">
<xsl:variable name="indexTenor">
<xsl:value-of select="periodMultiplier"/>
<xsl:value-of select="period"/>
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
</xsl:template>
<xsl:template match="spreadSchedule">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:variable name="initialValue">
<xsl:value-of select="initialValue"/>
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
<xsl:if test="step">
<xsl:choose>
<xsl:when test="$productType != 'IRS' and $productType != 'OIS'">
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
<xsl:apply-templates select="step">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
<xsl:with-param name="parent">spreadSchedule</xsl:with-param>
</xsl:apply-templates>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:template>
<xsl:template match="capRateSchedule">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">initialValue</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="initialValue"/>
</xsl:with-param>
<xsl:with-param name="minIncl">-9.9999999999</xsl:with-param>
<xsl:with-param name="maxIncl">9.9999999999</xsl:with-param>
<xsl:with-param name="maxDecs">10</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:variable name="buyer">
<xsl:value-of select="buyer"/>
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
<xsl:value-of select="seller"/>
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
<xsl:template match="floorRateSchedule">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">initialValue</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="initialValue"/>
</xsl:with-param>
<xsl:with-param name="minIncl">-9.9999999999</xsl:with-param>
<xsl:with-param name="maxIncl">9.9999999999</xsl:with-param>
<xsl:with-param name="maxDecs">10</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:variable name="buyer">
<xsl:value-of select="buyer"/>
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
<xsl:value-of select="seller"/>
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
<xsl:template match="stubCalculationPeriodAmount">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:variable name="href">
<xsl:value-of select="substring-after(calculationPeriodDatesReference/@href,'#')"/>
</xsl:variable>
<xsl:variable name="id">
<xsl:value-of select="../calculationPeriodDates/@id"/>
</xsl:variable>
<xsl:if test="$href!=$id">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid calculationPeriodDatesReference/@href value. Value is not equal to ../calculationPeriodDates/@id. Value of href = '<xsl:value-of select="$href"/>' and id = '<xsl:value-of select="$id"/>'.</text>
</error>
</xsl:if>
<xsl:if test="initialStub and finalStub and not($productType='IRS' or $productType='OIS')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** initialStub and finalStub must not both be present.</text>
</error>
</xsl:if>
<xsl:if test="not(initialStub or finalStub)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** initialStub or finalStub must be present.</text>
</error>
</xsl:if>
<xsl:apply-templates select="initialStub">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="finalStub">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test=" ($tradeCurrency = 'AUD') and (initialStub/floatingRate[1]/floatingRateIndex = 'AUD-RBA Cash Rate' or initialStub/floatingRate[1]/floatingRateIndex = 'AUD-AONIA' or finalStub/floatingRate[1]/floatingRateIndex = 'AUD-RBA Cash Rate' or finalStub/floatingRate[1]/floatingRateIndex = 'AUD-AONIA' ) ">
<xsl:if test="(string-length(initialStub/floatingRate[2]/floatingRateIndex) &lt; 3) and (string-length(finalStub/floatingRate[2]/floatingRateIndex) &lt; 3)  ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text> *** stub floatingRateIndex[1] value of 'AUD-RBA Cash Rate' or 'AUD-AONIA' is not valid without stub floatingRateIndex[2]. Linear interpolation is required.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test=" ($tradeCurrency = 'NZD') and (initialStub/floatingRate[1]/floatingRateIndex = 'NZD-RBNZ OCR' or initialStub/floatingRate[1]/floatingRateIndex = 'NZD-NZIONA' or finalStub/floatingRate[1]/floatingRateIndex = 'NZD-RBNZ OCR' or finalStub/floatingRate[1]/floatingRateIndex = 'NZD-NZIONA' ) ">
<xsl:if test="(string-length(initialStub/floatingRate[2]/floatingRateIndex) &lt; 3) and (string-length(finalStub/floatingRate[2]/floatingRateIndex) &lt; 3)  ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text> *** stub floatingRateIndex[1] value of 'NZD-RBNZ OCR' or 'NZD-NZIONA' is not valid without stub floatingRateIndex[2]. Linear interpolation is required.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:template>
<xsl:template match="initialStub">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="count(floatingRate) &gt; 2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of floatingRate child elements encountered. 0, 1 or 2 expected. <xsl:value-of select="count(floatingRate)"/> found.</text>
</error>
</xsl:if>
<xsl:apply-templates select="floatingRate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="stubRate">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">stubRate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="stubRate"/>
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
<xsl:template match="finalStub">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="not(count(floatingRate)=1 or count(floatingRate)=2)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of floatingRate child elements encountered. 1 or 2 expected. <xsl:value-of select="count(floatingRate)"/> found.</text>
</error>
</xsl:if>
<xsl:apply-templates select="floatingRate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="stubRate">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** stubRate must not be present in this context.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="floatingRate">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:variable name="floatingRateIndex">
<xsl:value-of select="floatingRateIndex"/>
</xsl:variable>
<xsl:if test="$floatingRateIndex=''">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Empty or missing floatingRateIndex.</text>
</error>
</xsl:if>
<xsl:if test="../../../stubCalculationPeriodAmount">
<xsl:variable name="floatingRateIndex2">
<xsl:choose>
<xsl:when test="$productType='ZCInflationSwap'">
<xsl:value-of select="../../../calculationPeriodAmount/calculation/inflationRateCalculation/floatingRateIndex"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="../../../calculationPeriodAmount/calculation/floatingRateCalculation/floatingRateIndex"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:if test="$floatingRateIndex != $floatingRateIndex2">
<xsl:variable name="interpTenor">
<xsl:value-of select="indexTenor/periodMultiplier"/>
<xsl:value-of select="indexTenor/period"/>
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
<xsl:if test="$tradeCurrency != 'PLN' and not($productType='ZCInflationSwap')">
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
<xsl:apply-templates select="indexTenor">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="spreadSchedule">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** spreadSchedule must not be present in this context.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="earlyTerminationProvision">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="not(/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swEarlyTerminationProvision)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing /SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swEarlyTerminationProvision element. Required if earlyTerminationProvision is present.</text>
</error>
</xsl:if>
<xsl:apply-templates select="mandatoryEarlyTermination">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="optionalEarlyTermination">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="mandatoryEarlyTermination">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swEarlyTerminationProvision/swBreakFrequency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected /SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swEarlyTerminationProvision/swBreakFrequency element encountered. Element not allowed for mandatory early termination.</text>
</error>
</xsl:if>
<xsl:variable name="id">
<xsl:value-of select="./@id"/>
</xsl:variable>
<xsl:if test="$id=''">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or empty mandatoryEarlyTermination/@id attribute value. Value = '<xsl:value-of select="$id"/>'.</text>
</error>
</xsl:if>
<xsl:apply-templates select="mandatoryEarlyTerminationDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swEarlyTerminationProvision/swBreakCalculationMethod = 'ISDA Standard Method'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** /SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swEarlyTerminationProvision/swBreakCalculationMethod must not be equal to 'ISDA Standard Method' for mandatory early termination. For mandatory early termination valid values are 'Adjust To Coupon Dates' or 'Straight Calendar Dates'.</text>
</error>
</xsl:if>
<xsl:apply-templates select="calculationAgent">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="cashSettlement">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="mandatoryEarlyTerminationDate">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:variable name="businessDayConvention">
<xsl:value-of select="dateAdjustments/businessDayConvention"/>
</xsl:variable>
<xsl:if test="$businessDayConvention='NONE'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** dateAdjustments/businessDayConvention must not be equal to 'NONE'.</text>
</error>
</xsl:if>
<xsl:apply-templates select="dateAdjustments">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:variable name="businessDayConvention1">
<xsl:value-of select="dateAdjustments/businessDayConvention"/>
</xsl:variable>
<xsl:variable name="businessDayConvention2">
<xsl:value-of select="//FpML/trade//*/*[position()=$floatingLeg]/paymentDates/paymentDatesAdjustments/businessDayConvention"/>
</xsl:variable>
<xsl:if test="$businessDayConvention1!=$businessDayConvention2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** dateAdjustments/businessDayConvention must be the same as the floating stream paymentDates/paymentDatesAdjustments/businessDayConvention. Value = '<xsl:value-of select="$businessDayConvention1"/>' and '<xsl:value-of select="$businessDayConvention2"/>.'</text>
</error>
</xsl:if>
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swap/swapStream/calculationPeriodAmount/calculation/notionalSchedule/notionalStepSchedule/currency!= 'ILS'">
<xsl:variable name="businessCenters1">
<xsl:for-each select="dateAdjustments/businessCenters/businessCenter">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:variable>
<xsl:variable name="businessCenters2">
<xsl:for-each select="//FpML/trade//*/*[position()=$floatingLeg]/paymentDates/paymentDatesAdjustments/businessCenters/businessCenter">
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
<xsl:value-of select="unadjustedDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:template>
<xsl:template match="calculationAgent">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="parent::trade and not($productType='IRS' and $tradeCurrency='BRL')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected trade/calculationAgent element encountered.</text>
</error>
</xsl:if>
<xsl:if test="count(calculationAgentPartyReference) &gt; 2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of calculationAgentPartyReference child elements encountered. 0 to 2 expected.</text>
</error>
</xsl:if>
<xsl:apply-templates select="calculationAgentPartyReference">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="calculationAgentParty">
<xsl:call-template name="isValidCalculationAgentParty">
<xsl:with-param name="elementName">calculationAgentParty</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="calculationAgentParty"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
</xsl:template>
<xsl:template match="calculationAgentPartyReference">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:if test="ancestor::swaption/calculationAgent">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swaption/calculationAgent/calculationAgentPartyReference element encountered. Element swaption/calculationAgentPartyReference expected.</text>
</error>
</xsl:if>
<xsl:variable name="href">
<xsl:value-of select="@href"/>
</xsl:variable>
<xsl:if test="not(//FpML/trade/party[@id=substring-after($href,'#')])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** calculationAgentPartyReference/@href does not reference a valid //FpML/trade/party/@id. Value = '<xsl:value-of select="$href"/>'.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="cashSettlement">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="ancestor::optionalEarlyTermination">
<xsl:variable name="id">
<xsl:value-of select="@id"/>
</xsl:variable>
<xsl:if test="$id=''">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or empty cashSettlement/@id attribute value.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="cashSettlementValuationTime">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="cashSettlementValuationDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="../../mandatoryEarlyTermination">
<xsl:if test="cashSettlementPaymentDate">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Element cashSettlementPaymentDate must not be present for mandatory early termination.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="../../optionalEarlyTermination">
<xsl:if test="not(cashSettlementPaymentDate)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** cashSettlementPaymentDate must be present for optional early termination.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="cashSettlementPaymentDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="cashPriceMethod">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="cashPriceAlternateMethod">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="parYieldCurveAdjustedMethod">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="parYieldCurveUnadjustedMethod">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="zeroCouponYieldAdjustedMethod">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="cashSettlementValuationTime|earliestExerciseTime|latestExerciseTime|expirationTime">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:call-template name="isValidTime">
<xsl:with-param name="elementName">hourMinuteTime</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="hourMinuteTime"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="isValidBusinessCenter">
<xsl:with-param name="elementName">businessCenter</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="businessCenter"/>
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
<xsl:value-of select="businessCenter"/>
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
<xsl:template match="cashSettlementValuationDate|relativeDate|relativeDates">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:variable name="periodMultiplier">
<xsl:value-of select="periodMultiplier"/>
</xsl:variable>
<xsl:call-template name="isValidPeriodMultiplier">
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
<xsl:value-of select="period"/>
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
<xsl:choose>
<xsl:when test="not(../../../../swaption) and not(../../../swaption)">
<xsl:if test="not(businessDayConvention='PRECEDING')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** businessDayConvention must equal 'PRECEDING' if periodMultiplier is '0' and period is 'D' if product type is 'SingleCurrencyInterestRateSwap'. Value = '<xsl:value-of select="businessDayConvention"/>'.</text>
</error>
</xsl:if>
</xsl:when>
<xsl:when test="../../../../swaption or ../../../swaption">
<xsl:if test="not(businessDayConvention='NONE')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** businessDayConvention must equal 'NONE' if periodMultiplier is '0' and period is 'D' if product type is 'Swaption'. Value = '<xsl:value-of select="businessDayConvention"/>'.</text>
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
<xsl:value-of select="dayType"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:variable name="businessDayConvention">
<xsl:value-of select="businessDayConvention"/>
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
<xsl:if test="businessCentersReference">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected element businessCentersReference encountered.</text>
</error>
</xsl:if>
<xsl:if test="$businessDayConvention!='NONE'">
<xsl:if test="not(businessCenters)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing businessCenters.  Needed when businessDayConvention not equal to 'NONE'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="businessCenters">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="ancestor::mandatoryEarlyTermination">
<xsl:variable name="href">
<xsl:value-of select="substring-after(dateRelativeTo/@href,'#')"/>
</xsl:variable>
<xsl:variable name="id">
<xsl:value-of select="ancestor::mandatoryEarlyTermination/@id"/>
</xsl:variable>
<xsl:if test="$href!=$id">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid dateRelativeTo/@href value. Value is not equal to ancestor::mandatoryEarlyTermination/@id. Value of href = '<xsl:value-of select="$href"/>' and id = '<xsl:value-of select="$id"/>'..</text>
</error>
</xsl:if>
<xsl:variable name="dateRelativeTo">
<xsl:value-of select="dateRelativeTo"/>
</xsl:variable>
<xsl:if test="$dateRelativeTo!='MandatoryEarlyTerminationDate'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid dateRelativeTo value. Value = '<xsl:value-of select="$dateRelativeTo"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="ancestor::optionalEarlyTermination">
<xsl:variable name="href">
<xsl:value-of select="substring-after(dateRelativeTo/@href,'#')"/>
</xsl:variable>
<xsl:variable name="id">
<xsl:value-of select="ancestor::optionalEarlyTermination/cashSettlement/@id"/>
</xsl:variable>
<xsl:if test="$href!=$id">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid dateRelativeTo/@href value. Value is not equal to ancestor::optionalEarlyTermination/cashSettlement/@id. Value of href = '<xsl:value-of select="$href"/>' and id = '<xsl:value-of select="$id"/>'..</text>
</error>
</xsl:if>
<xsl:variable name="dateRelativeTo">
<xsl:value-of select="dateRelativeTo"/>
</xsl:variable>
<xsl:if test="$dateRelativeTo!='CashSettlementPaymentDate'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid dateRelativeTo value. Value = '<xsl:value-of select="$dateRelativeTo"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="../../../../swaption or ../../../swaption">
<xsl:variable name="href">
<xsl:value-of select="substring-after(dateRelativeTo/@href,'#')"/>
</xsl:variable>
<xsl:variable name="id">
<xsl:value-of select="ancestor::swaption/europeanExercise/@id"/>
</xsl:variable>
<xsl:if test="$href!=$id">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid dateRelativeTo/@href value. Value is not equal to ancestor::swaption/europeanExercise/@id. Value of href = '<xsl:value-of select="$href"/>' and id = '<xsl:value-of select="$id"/>'..</text>
</error>
</xsl:if>
<xsl:variable name="dateRelativeTo">
<xsl:value-of select="dateRelativeTo"/>
</xsl:variable>
<xsl:if test="$dateRelativeTo!='ExerciseDate'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid dateRelativeTo value. Value = '<xsl:value-of select="$dateRelativeTo"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="ancestor::swaption/cashSettlement">
<xsl:if test="../../../../swaption or ../../../swaption">
<xsl:if test="../../cashSettlementPaymentDate or ../cashSettlementValuationDate">
<xsl:variable name="href">
<xsl:value-of select="substring-after(dateRelativeTo/@href,'#')"/>
</xsl:variable>
<xsl:variable name="id">
<xsl:value-of select="//FpML/trade//swaption/europeanExercise/@id"/>
</xsl:variable>
<xsl:if test="$href!=$id">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid dateRelativeTo/@href value. Value is not equal to //FpML/trade//swaption/europeanExercise/@id. Value of href = '<xsl:value-of select="$href"/>' and id = '<xsl:value-of select="$id"/>'..</text>
</error>
</xsl:if>
<xsl:variable name="dateRelativeTo">
<xsl:value-of select="dateRelativeTo"/>
</xsl:variable>
<xsl:if test="$dateRelativeTo!='ExerciseDate'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid dateRelativeTo value. Value = '<xsl:value-of select="$dateRelativeTo"/>'.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
</xsl:if>
</xsl:template>
<xsl:template match="cashPriceMethod|cashPriceAlternateMethod">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:apply-templates select="cashSettlementReferenceBanks">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="not(/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swSettlementProvision/swNonDeliverableSettlement)">
<xsl:variable name="cashSettlementCurrency">
<xsl:value-of select="cashSettlementCurrency"/>
</xsl:variable>
<xsl:if test="not($cashSettlementCurrency=$tradeCurrency)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** cashSettlementCurrency must be the same as trade currency if trade currency is deliverable. Value = '<xsl:value-of select="$cashSettlementCurrency"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swSettlementProvision/swNonDeliverableSettlement">
<xsl:if test="cashSettlementCurrency!='USD'">
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
<xsl:value-of select="quotationRateType"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="ancestor::mandatoryEarlyTermination">
<xsl:if test="quotationRateType='ExercisingPartyPays'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** A quotationRateType value of 'ExercisingPartyPays' is not allowed for a mandatory early termination.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:template>
<xsl:template match="parYieldCurveAdjustedMethod|parYieldCurveUnadjustedMethod|zeroCouponYieldAdjustedMethod|swCollateralizedCashPrice">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:apply-templates select="settlementRateSource">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:call-template name="isValidQuotationRateType">
<xsl:with-param name="elementName">quotationRateType</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="quotationRateType"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="ancestor::mandatoryEarlyTermination">
<xsl:if test="quotationRateType='ExercisingPartyPays'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** A quotationRateType value of 'ExercisingPartyPays' is not allowed for a mandatory early termination.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:template>
<xsl:template match="settlementRateSource">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:apply-templates select="informationSource">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="cashSettlementReferenceBanks">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="informationSource">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:call-template name="isValidInformationProvider">
<xsl:with-param name="elementName">rateSource</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="rateSource"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="rateSourcePage">
<xsl:if test="rateSourcePage=''">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** rateSourcePage is empty.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:template>
<xsl:template match="cashSettlementPaymentDate">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:apply-templates select="relativeDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="adjustableDates">
<xsl:if test="../../americanExercise">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** adjustableDates must only be present if European or Bermuda exercise.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="businessDateRange">
<xsl:if test="not(../../americanExercise)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** businessDateRange must only be present if American exercise.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="adjustableDates">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="businessDateRange">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="adjustableDate">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">unadjustedDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="unadjustedDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:apply-templates select="dateAdjustments">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="adjustableDates">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="../../../europeanExercise">
<xsl:if test="count(unadjustedDate)!=1">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of unadjustedDate child elements encountered for European exercise. Exactly 1 expected.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="ancestor::optionalEarlyTermination">
<xsl:variable name="unadjustedDate">
<xsl:value-of select="unadjustedDate[position()=last()]"/>
</xsl:variable>
<xsl:variable name="terminationDate">
<xsl:value-of select="//FpML/trade//*/*[position()=$floatingLeg]/calculationPeriodDates/terminationDate/unadjustedDate"/>
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
<text>*** The last unadjustedDate child element is greater than the floating stream terminationDate. Value = '<xsl:value-of select="$unadjustedDate"/>'</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="unadjustedDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="ancestor::optionalEarlyTermination">
<xsl:variable name="businessDayConvention1">
<xsl:value-of select="dateAdjustments/businessDayConvention"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swEarlyTerminationProvision[swBreakCalculationMethod='ISDA Standard Method']">
<xsl:if test="$businessDayConvention1!='FOLLOWING'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** dateAdjustments/businessDayConvention must equal 'FOLLOWING' when /SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swEarlyTerminationProvision/swBreakCalculationMethod is equal to 'ISDA Standard Method'. Value = '<xsl:value-of select="$businessDayConvention1"/>'</text>
</error>
</xsl:if>
</xsl:when>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swTradeHeader[swInteroperable='true']">
<xsl:if test="$businessDayConvention1!='FOLLOWING'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***dateAdjustments/businessDayConvention must equal 'FOLLOWING' when /SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swTradeHeader/swInteroperable is equal to 'true'. Value = '<xsl:value-of select="$businessDayConvention1"/>'</text>
</error>
</xsl:if>
</xsl:when>
<xsl:otherwise>
<xsl:variable name="businessDayConvention2">
<xsl:value-of select="//FpML/trade//*/*[position()=$floatingLeg]/paymentDates/paymentDatesAdjustments/businessDayConvention"/>
</xsl:variable>
<xsl:if test="$businessDayConvention1!=$businessDayConvention2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** dateAdjustments/businessDayConvention must be the same as the floating stream paymentDates/paymentDatesAdjustments/businessDayConvention. Value = '<xsl:value-of select="$businessDayConvention1"/>' and '<xsl:value-of select="$businessDayConvention2"/>'</text>
</error>
</xsl:if>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade/swap/swapStream/calculationPeriodAmount/calculation/notionalSchedule/notionalStepSchedule/currency!= 'ILS'">
<xsl:if test="ancestor::optionalEarlyTermination">
<xsl:variable name="businessCenters1">
<xsl:for-each select="dateAdjustments/businessCenters/businessCenter">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:variable>
<xsl:variable name="businessCenters2">
<xsl:for-each select="//FpML/trade//*/*[position()=$floatingLeg]/paymentDates/paymentDatesAdjustments/businessCenters/businessCenter">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:variable>
<xsl:if test="$businessCenters1!=$businessCenters2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** dateAdjustments/businessCenters must be the same as the floating stream paymentDates/paymentDatesAdjustments/businessCenters. Value = '<xsl:value-of select="$businessCenters1"/>' and '<xsl:value-of select="$businessCenters2"/>'</text>
</error>
</xsl:if>
</xsl:if>
</xsl:when>
</xsl:choose>
<xsl:apply-templates select="dateAdjustments">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="unadjustedDate">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
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
<xsl:template match="businessDateRange">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">unadjustedFirstDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="unadjustedFirstDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">unadjustedLastDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="unadjustedLastDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="ancestor::optionalEarlyTermination">
<xsl:variable name="unadjustedLastDate">
<xsl:value-of select="unadjustedLastDate"/>
</xsl:variable>
<xsl:variable name="terminationDate">
<xsl:choose>
<xsl:when test="$productType='CapFloor'">
<xsl:value-of select="//FpML/trade//capFloor/capFloorStream[position()=$floatingLeg]/calculationPeriodDates/terminationDate/unadjustedDate"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="//FpML/trade//swap/swapStream[position()=$floatingLeg]/calculationPeriodDates/terminationDate/unadjustedDate"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:if test="$unadjustedLastDate!=$terminationDate">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** unadjustedLastDate does not match the swap floating stream calculationPeriodDates/terminationDate/unadjustedDate.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:variable name="businessDayConvention">
<xsl:value-of select="businessDayConvention"/>
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
<xsl:if test="businessCentersReference">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected element businessCentersReference encountered.</text>
</error>
</xsl:if>
<xsl:if test="$businessDayConvention='NONE' and businessCenters">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected element businessCenters encountered when businessDayConvention = 'NONE'.</text>
</error>
</xsl:if>
<xsl:if test="$businessDayConvention!='NONE' and not(businessCenters)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing businessCenters. Needed when businessDayConvention not equal to 'NONE'.</text>
</error>
</xsl:if>
<xsl:choose>
<xsl:when test="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swEarlyTerminationProvision[swBreakCalculationMethod='ISDA Standard Method']">
<xsl:if test="$businessDayConvention!='FOLLOWING'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** dateAdjustments/businessDayConvention must equal 'FOLLOWING' when /SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swEarlyTerminationProvision/swBreakCalculationMethod is equal to 'ISDA Standard Method'. Value = '<xsl:value-of select="$businessDayConvention"/>'</text>
</error>
</xsl:if>
</xsl:when>
<xsl:otherwise>
<xsl:variable name="businessDayConvention2">
<xsl:value-of select="//FpML/trade//*/*[position()=$floatingLeg]/paymentDates/paymentDatesAdjustments/businessDayConvention"/>
</xsl:variable>
<xsl:if test="$businessDayConvention!=$businessDayConvention2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** dateAdjustments/businessDayConvention must be the same as the floating stream paymentDates/paymentDatesAdjustments/businessDayConvention. Value = '<xsl:value-of select="$businessDayConvention"/>' and '<xsl:value-of select="$businessDayConvention2"/>'</text>
</error>
</xsl:if>
</xsl:otherwise>
</xsl:choose>
<xsl:variable name="businessCenters1">
<xsl:for-each select="businessCenters/businessCenter">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:variable>
<xsl:variable name="businessCenters2">
<xsl:choose>
<xsl:when test="$productType='CapFloor'">
<xsl:for-each select="//FpML/trade//capFloor/capFloorStream[position()=$floatingLeg]/paymentDates/paymentDatesAdjustments/businessCenters/businessCenter">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:when>
<xsl:otherwise>
<xsl:for-each select="//FpML/trade//swap/swapStream[position()=$floatingLeg]/paymentDates/paymentDatesAdjustments/businessCenters/businessCenter">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:if test="$businessCenters1!=$businessCenters2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** businessCenters must be the same as floating stream paymentDates/paymentDatesAdjustments/businessCenters. Value = '<xsl:value-of select="$businessCenters1"/>' and '<xsl:value-of select="$businessCenters2"/>'</text>
</error>
</xsl:if>
<xsl:apply-templates select="businessCenters">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="optionalEarlyTermination">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:apply-templates select="singlePartyOption">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="europeanExercise and /SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swEarlyTerminationProvision/swBreakFrequency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected /SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swEarlyTerminationProvision/swBreakFrequency element encountered. Element not allowed for european style optional early termination.</text>
</error>
</xsl:if>
<xsl:if test="americanExercise">
<xsl:variable name="breakFrequency">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swEarlyTerminationProvision/swBreakFrequency/periodMultiplier"/>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swEarlyTerminationProvision/swBreakFrequency/period"/>
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
<xsl:if test="bermudaExercise">
<xsl:variable name="breakFrequency">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swEarlyTerminationProvision/swBreakFrequency/periodMultiplier"/>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swEarlyTerminationProvision/swBreakFrequency/period"/>
</xsl:variable>
<xsl:if test="not(/SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swEarlyTerminationProvision/swBreakFrequency)">
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
<text>*** /SWDML/swLongFormTrade/swStructuredTradeDetails/swExtendedTradeDetails/swEarlyTerminationProvision/swBreakFrequency element must not be equal to 1D for bermuda style optional early termination.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="europeanExercise">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="bermudaExercise">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="americanExercise">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="calculationAgent">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="cashSettlement">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="singlePartyOption">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:variable name="href1">
<xsl:value-of select="buyerPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="href2">
<xsl:value-of select="sellerPartyReference/@href"/>
</xsl:variable>
<xsl:if test="$href1=$href2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** buyerPartyReference/@href and sellerPartyReference/@href values must not be the same.</text>
</error>
</xsl:if>
<xsl:if test="not(//FpML/trade/party[@id=substring-after($href1,'#')])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** buyerPartyReference/@href does not reference a valid //FpML/trade/party/@id. Value = '<xsl:value-of select="$href1"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not(//FpML/trade/party[@id=substring-after($href2,'#')])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** sellerPartyReference/@href does not reference a valid //FpML/trade/party/@id. Value = '<xsl:value-of select="$href2"/>'.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="europeanExercise">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="earliestExerciseTime/businessCenter != expirationTime/businessCenter">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** earliestExerciseTime/businessCenter must equal expirationTime/businessCenter.</text>
</error>
</xsl:if>
<xsl:if test="../cashSettlement/cashSettlementValuationTime/businessCenter != expirationTime/businessCenter">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** ../cashSettlement/cashSettlementValuationTime/businessCenter must equal expirationTime/businessCenter.</text>
</error>
</xsl:if>
<xsl:variable name="earliest">
<xsl:value-of select="concat(substring(earliestExerciseTime/hourMinuteTime,1,2),substring(earliestExerciseTime/hourMinuteTime,4,2),substring(earliestExerciseTime/hourMinuteTime,7,2))"/>
</xsl:variable>
<xsl:variable name="expiration">
<xsl:value-of select="concat(substring(expirationTime/hourMinuteTime,1,2),substring(expirationTime/hourMinuteTime,4,2),substring(expirationTime/hourMinuteTime,7,2))"/>
</xsl:variable>
<xsl:if test="not($earliest &lt;= $expiration)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** earliestExerciseTime/hourMinuteTime (<xsl:value-of select="earliestExerciseTime/hourMinuteTime"/>) must be less than expirationTime/hourMinuteTime (<xsl:value-of select="expirationTime/hourMinuteTime"/>).</text>
</error>
</xsl:if>
<xsl:apply-templates select="expirationDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="earliestExerciseTime">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="expirationTime">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="expirationDate|commencementDate">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:apply-templates select="relativeDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="adjustableDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="bermudaExerciseDates">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:apply-templates select="relativeDates">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="bermudaExercise">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="earliestExerciseTime/businessCenter != expirationTime/businessCenter">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** earliestExerciseTime/businessCenter must equal expirationTime/businessCenter.</text>
</error>
</xsl:if>
<xsl:variable name="earliest">
<xsl:value-of select="concat(substring(earliestExerciseTime/hourMinuteTime,1,2),substring(earliestExerciseTime/hourMinuteTime,4,2),substring(earliestExerciseTime/hourMinuteTime,7,2))"/>
</xsl:variable>
<xsl:variable name="expiration">
<xsl:value-of select="concat(substring(expirationTime/hourMinuteTime,1,2),substring(expirationTime/hourMinuteTime,4,2),substring(expirationTime/hourMinuteTime,7,2))"/>
</xsl:variable>
<xsl:if test="not($earliest &lt;= $expiration)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** earliestExerciseTime/hourMinuteTime (<xsl:value-of select="earliestExerciseTime/hourMinuteTime"/>) must be less than expirationTime/hourMinuteTime (<xsl:value-of select="expirationTime/hourMinuteTime"/>).</text>
</error>
</xsl:if>
<xsl:if test="latestExerciseTime and not(latestExerciseTime/businessCenter = expirationTime/businessCenter)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** latestExerciseTime/businessCenter must equal expirationTime/businessCenter.</text>
</error>
</xsl:if>
<xsl:if test="latestExerciseTime and not(latestExerciseTime/hourMinuteTime = expirationTime/hourMinuteTime)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** latestExerciseTime/hourMinuteTime must equal expirationTime/hourMinuteTime.</text>
</error>
</xsl:if>
<xsl:apply-templates select="bermudaExerciseDates">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="earliestExerciseTime">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="latestExerciseTime">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="expirationTime">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="americanExercise">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="earliestExerciseTime/businessCenter != expirationTime/businessCenter">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** earliestExerciseTime/businessCenter must equal expirationTime/businessCenter.</text>
</error>
</xsl:if>
<xsl:variable name="earliest">
<xsl:value-of select="concat(substring(earliestExerciseTime/hourMinuteTime,1,2),substring(earliestExerciseTime/hourMinuteTime,4,2),substring(earliestExerciseTime/hourMinuteTime,7,2))"/>
</xsl:variable>
<xsl:variable name="expiration">
<xsl:value-of select="concat(substring(expirationTime/hourMinuteTime,1,2),substring(expirationTime/hourMinuteTime,4,2),substring(expirationTime/hourMinuteTime,7,2))"/>
</xsl:variable>
<xsl:if test="not($earliest &lt;= $expiration)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** earliestExerciseTime/hourMinuteTime (<xsl:value-of select="earliestExerciseTime/hourMinuteTime"/>) must be less than expirationTime/hourMinuteTime (<xsl:value-of select="expirationTime/hourMinuteTime"/>).</text>
</error>
</xsl:if>
<xsl:if test="latestExerciseTime and not(latestExerciseTime/businessCenter = expirationTime/businessCenter)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** latestExerciseTime/businessCenter must equal expirationTime/businessCenter.</text>
</error>
</xsl:if>
<xsl:if test="latestExerciseTime and not(latestExerciseTime/hourMinuteTime = expirationTime/hourMinuteTime)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** latestExerciseTime/hourMinuteTime must equal expirationTime/hourMinuteTime.</text>
</error>
</xsl:if>
<xsl:apply-templates select="commencementDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="expirationDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="earliestExerciseTime">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="latestExerciseTime">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="expirationTime">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="cashSettlementReferenceBanks">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="count(referenceBank) &gt; 5">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of referenceBank child elements encountered. 1 to 5 expected.</text>
</error>
</xsl:if>
<xsl:apply-templates select="referenceBank">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="referenceBank">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:variable name="referenceBankId">
<xsl:value-of select="referenceBankId"/>
</xsl:variable>
<xsl:if test="$referenceBankId=''">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Empty referenceBankId.</text>
</error>
</xsl:if>
<xsl:if test="referenceBankName">
<xsl:variable name="referenceBankName">
<xsl:value-of select="referenceBankName"/>
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
<xsl:template match="fra">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="not($productType='FRA')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** /SWDML/swLongFormTrade/swStructuredTradeDetails/swProductType must be equal to 'FRA' if fra element is present.</text>
</error>
</xsl:if>
<xsl:variable name="href1">
<xsl:value-of select="buyerPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="href2">
<xsl:value-of select="sellerPartyReference/@href"/>
</xsl:variable>
<xsl:if test="$href1=$href2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** buyerPartyReference/@href and sellerPartyReference/@href values must not be the same.</text>
</error>
</xsl:if>
<xsl:if test="not(//FpML/trade/party[@id=substring-after($href1,'#')])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** buyerPartyReference/@href does not reference a valid //FpML/trade/party/@id. Value = '<xsl:value-of select="$href1"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not(//FpML/trade/party[@id=substring-after($href2,'#')])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** sellerPartyReference/@href does not reference a valid //FpML/trade/party/@id. Value = '<xsl:value-of select="$href2"/>'.</text>
</error>
</xsl:if>
<xsl:variable name="id">
<xsl:value-of select="adjustedEffectiveDate/@id"/>
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
<xsl:value-of select="adjustedEffectiveDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">adjustedTerminationDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="adjustedTerminationDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:apply-templates select="paymentDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fixingDateOffset">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:call-template name="isValidDayCountFraction">
<xsl:with-param name="elementName">dayCountFraction</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="dayCountFraction"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:variable name="calculationPeriodNumberOfDays">
<xsl:value-of select="calculationPeriodNumberOfDays"/>
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
<xsl:apply-templates select="notional">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:variable name="floatingRateIndex">
<xsl:value-of select="floatingRateIndex"/>
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
<xsl:value-of select="fixedRate"/>
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
<xsl:if test="not(count(indexTenor)=1 or count(indexTenor)=2)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of indexTenor child elements encountered. Exactly 1 or 2 expected.</text>
</error>
</xsl:if>
<xsl:apply-templates select="indexTenor">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">fraDiscounting</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fraDiscounting"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:template>
<xsl:template match="paymentDate">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">unadjustedDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="unadjustedDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:apply-templates select="dateAdjustments">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:variable name="businessDayConvention">
<xsl:value-of select="dateAdjustments/businessDayConvention"/>
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
<xsl:template match="dateAdjustments">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:variable name="businessDayConvention">
<xsl:value-of select="businessDayConvention"/>
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
<xsl:if test="businessCentersReference">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected element businessCentersReference encountered.</text>
</error>
</xsl:if>
<xsl:if test="$businessDayConvention='NONE'">
<xsl:if test="businessCenters">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected element businessCenters encountered when businessDayConvention = 'NONE'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$businessDayConvention!='NONE'">
<xsl:if test="not(businessCenters)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing businessCenters. Needed when businessDayConvention not equal to 'NONE'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="businessCenters">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="businessCenters">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:apply-templates select="businessCenter">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="businessCenter">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
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
<xsl:template match="fixingDateOffset">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:variable name="periodMultiplier">
<xsl:value-of select="periodMultiplier"/>
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
<xsl:value-of select="period"/>
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
<xsl:if test="not(businessDayConvention='PRECEDING')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** businessDayConvention must equal 'PRECEDING' if periodMultiplier is '0' and period is 'D'. Value = '<xsl:value-of select="businessDayConvention"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:variable name="dayType">
<xsl:value-of select="dayType"/>
</xsl:variable>
<xsl:if test="$periodMultiplier!='0' and $period='D' and $dayType='Business'">
<xsl:if test="not(businessDayConvention='NONE')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** businessDayConvention must equal 'NONE' if period is equal to 'D' and periodMultiplier is not equal to '0' and dayType is equal to 'Business'. Value = '<xsl:value-of select="businessDayConvention"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="not($periodMultiplier='0' and $period='D')">
<xsl:call-template name="isValidDayType">
<xsl:with-param name="elementName">dayType</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="dayType"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:variable name="businessDayConvention">
<xsl:value-of select="businessDayConvention"/>
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
<xsl:if test="businessCentersReference">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected element businessCentersReference encountered.</text>
</error>
</xsl:if>
<xsl:if test="$businessDayConvention!='NONE'">
<xsl:if test="not(businessCenters)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing businessCenters. Needed when businessDayConvention not equal to 'NONE'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$dayType='Business'">
<xsl:if test="not(businessCenters)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing businessCenters. Needed when dayType is equal to 'Business'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="businessCenters">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:variable name="href">
<xsl:value-of select="substring-after(dateRelativeTo/@href,'#')"/>
</xsl:variable>
<xsl:variable name="id">
<xsl:value-of select="../adjustedEffectiveDate/@id"/>
</xsl:variable>
<xsl:if test="$href!=$id">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid dateRelativeTo/@href value. Value is not equal to ../adjustedEffectiveDate/@id. Value of href = '<xsl:value-of select="$href"/>' and id = '<xsl:value-of select="$id"/>'.</text>
</error>
</xsl:if>
<xsl:variable name="dateRelativeTo">
<xsl:value-of select="dateRelativeTo"/>
</xsl:variable>
<xsl:if test="$dateRelativeTo!='ResetDate'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid dateRelativeTo value. Value = '<xsl:value-of select="$dateRelativeTo"/>'.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="notional">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:call-template name="isValidCurrency">
<xsl:with-param name="elementName">currency</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="currency"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:variable name="amount">
<xsl:value-of select="amount"/>
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
<xsl:template match="swSwapTermTenor">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:variable name="period">
<xsl:value-of select="period"/>
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
<xsl:call-template name="isValidPeriodMultiplier">
<xsl:with-param name="elementName">periodMultiplier</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="periodMultiplier"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:variable name="periodMultiplier">
<xsl:value-of select="periodMultiplier"/>
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
<xsl:template match="swEffectiveDateTenor">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:variable name="period">
<xsl:value-of select="period"/>
</xsl:variable>
<xsl:if test="not($period='M')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** period must be equal to 'M' in this context. Value = '<xsl:value-of select="$period"/>'</text>
</error>
</xsl:if>
<xsl:call-template name="isValidPeriodMultiplier">
<xsl:with-param name="elementName">periodMultiplier</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="periodMultiplier"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:variable name="periodMultiplier">
<xsl:value-of select="periodMultiplier"/>
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
<xsl:template match="swTerminationDateTenor">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:variable name="period">
<xsl:value-of select="period"/>
</xsl:variable>
<xsl:if test="not($period='M')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** period must be equal to 'M' in this context. Value = '<xsl:value-of select="$period"/>'</text>
</error>
</xsl:if>
<xsl:call-template name="isValidPeriodMultiplier">
<xsl:with-param name="elementName">periodMultiplier</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="periodMultiplier"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:variable name="periodMultiplier">
<xsl:value-of select="periodMultiplier"/>
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
<xsl:template match="party">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:variable name="partyId">
<xsl:value-of select="partyId"/>
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
<xsl:value-of select="partyName"/>
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
<xsl:template match="swEarlyTerminationProvision">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:apply-templates select="swBreakFirstDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="swBreakOverrideFirstDate">
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">swBreakOverrideFirstDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="swBreakOverrideFirstDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/earlyTerminationProvision/mandatoryEarlyTermination/mandatoryEarlyTerminationDate/unadjustedDate">
<xsl:variable name="overrideFirstDate">
<xsl:value-of select="swBreakOverrideFirstDate"/>
</xsl:variable>
<xsl:variable name="firstDate">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/earlyTerminationProvision/mandatoryEarlyTermination/mandatoryEarlyTerminationDate/unadjustedDate"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$overrideFirstDate=$firstDate"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** For a mandatory early termination swBreakOverrideFirstDate whose value = '<xsl:value-of select="$overrideFirstDate"/>', must be equal to /SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/earlyTerminationProvision/mandatoryEarlyTermination/mandatoryEarlyTerminationDate/unadjustedDate. Value = '<xsl:value-of select="$firstDate"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/earlyTerminationProvision/optionalEarlyTermination/cashSettlement/cashSettlementPaymentDate/adjustableDates/unadjustedDate[1]">
<xsl:variable name="overrideFirstDate">
<xsl:value-of select="swBreakOverrideFirstDate"/>
</xsl:variable>
<xsl:variable name="firstDate">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/earlyTerminationProvision/optionalEarlyTermination/cashSettlement/cashSettlementPaymentDate/adjustableDates/unadjustedDate[1]"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$overrideFirstDate=$firstDate"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** For a Bermudan or European style optional early termination swBreakOverrideFirstDate whose value = '<xsl:value-of select="$overrideFirstDate"/>',  must be equal to /SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/earlyTerminationProvision/optionalEarlyTermination/cashSettlement/cashSettlementPaymentDate/adjustableDates/unadjustedDate[1]. Value = '<xsl:value-of select="$firstDate"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/earlyTerminationProvision/optionalEarlyTermination/cashSettlement/cashSettlementPaymentDate/businessDateRange/unadjustedFirstDate">
<xsl:variable name="overrideFirstDate">
<xsl:value-of select="swBreakOverrideFirstDate"/>
</xsl:variable>
<xsl:variable name="firstDate">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/earlyTerminationProvision/optionalEarlyTermination/cashSettlement/cashSettlementPaymentDate/businessDateRange/unadjustedFirstDate"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$overrideFirstDate=$firstDate"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** For an American style optional early termination swBreakOverrideFirstDate whose value = '<xsl:value-of select="$overrideFirstDate"/>',  must be equal to /SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/earlyTerminationProvision/optionalEarlyTermination/cashSettlement/cashSettlementPaymentDate/businessDateRange/unadjustedFirstDate. Value = '<xsl:value-of select="$firstDate"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="swBreakFrequency">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:call-template name="isValidBreakCalculationMethod">
<xsl:with-param name="elementName">swBreakCalculationMethod</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="swBreakCalculationMethod"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:template>
<xsl:template match="swBreakFirstDate">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:variable name="freq">
<xsl:value-of select="periodMultiplier"/>
<xsl:value-of select="period"/>
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
<xsl:template match="swBreakFrequency">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:variable name="freq">
<xsl:value-of select="periodMultiplier"/>
<xsl:value-of select="period"/>
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
<xsl:template match="swSettlementProvision">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:variable name="swSettlementCurrency">
<xsl:value-of select="swSettlementCurrency"/>
</xsl:variable>
<xsl:if test="not(swSettlementCurrency = 'USD')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swSettlementCurrency must be equal to 'USD'. Value = '<xsl:value-of select="swSettlementCurrency"/>'.</text>
</error>
</xsl:if>
<xsl:apply-templates select="swNonDeliverableSettlement">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="swNonDeliverableSettlement">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:call-template name="isValidNonDeliverableCurrency">
<xsl:with-param name="elementName">swReferenceCurrency</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="swReferenceCurrency"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="$tradeCurrency != swReferenceCurrency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swReferenceCurrency value of '<xsl:value-of select="swReferenceCurrency"/>' must equal Trade Currency of '<xsl:value-of select="$tradeCurrency"/>'.</text>
</error>
</xsl:if>
<xsl:if test="swFxFixingDate and swReferenceCurrency='BRL'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swFxFixingSchedule must be given for swReferenceCurrency value of '<xsl:value-of select="swReferenceCurrency"/>'.</text>
</error>
</xsl:if>
<xsl:if test="swFxFixingSchedule and swReferenceCurrency!='BRL'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swFxFixingSchedule must not be given when swReferenceCurrency value is not 'BRL'.</text>
</error>
</xsl:if>
<xsl:apply-templates select="swFxFixingDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="swFxFixingSchedule">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="swFxFixingSchedule">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">unadjustedDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="unadjustedDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:for-each select="dateAdjustments">
<xsl:call-template name="isValidNonDeliverableDateAdjustments">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:for-each>
</xsl:template>
<xsl:template match="swFxFixingDate">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:variable name="periodMultiplier">
<xsl:value-of select="periodMultiplier"/>
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
<xsl:value-of select="period"/>
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
<xsl:if test="dayType">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** dayType should not be present if periodMultiplier is '0' and period is 'D'.</text>
</error>
</xsl:if>
<xsl:if test="not(businessDayConvention='NONE')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** businessDayConvention must equal 'NONE' if periodMultiplier is '0' and period is 'D'. Value = '<xsl:value-of select="businessDayConvention"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:variable name="dayType">
<xsl:value-of select="dayType"/>
</xsl:variable>
<xsl:if test="$periodMultiplier!='0' and $period='D' and $dayType='Business'">
<xsl:if test="not(businessDayConvention='NONE')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** businessDayConvention must equal 'NONE' if period is equal to 'D' and periodMultiplier is not equal to '0' and dayType is equal to 'Business'. Value = '<xsl:value-of select="businessDayConvention"/>'.</text>
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
<xsl:call-template name="isValidNonDeliverableDateAdjustments">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="count(.//swPaymentDatesReference[@href])  != 2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of swPaymentDatesReference elements encountered. 2 expected.</text>
</error>
</xsl:if>
<xsl:if test="swDateRelativeToCalculationPeriodDates">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected element swDateRelativeToCalculationPeriodDates encountered.</text>
</error>
</xsl:if>
<xsl:variable name="href1">
<xsl:value-of select="substring-after(swDateRelativeToPaymentDates/swPaymentDatesReference[position()=1]/@href,'#')"/>
</xsl:variable>
<xsl:variable name="href2">
<xsl:value-of select="substring-after(swDateRelativeToPaymentDates/swPaymentDatesReference[position()=2]/@href,'#')"/>
</xsl:variable>
<xsl:variable name="fixedId">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$fixedLeg]/paymentDates/@id"/>
</xsl:variable>
<xsl:variable name="floatingId">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/paymentDates/@id"/>
</xsl:variable>
<xsl:if test="($href1!=$fixedId) and ($href1!=$floatingId)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid swPaymentDatesReference/@href value. Value is not equal to ../paymentDates/@id. Value of href = <xsl:value-of select="$href1"/>' and id values are <xsl:value-of select="$fixedId"/> and <xsl:value-of select="$floatingId"/>.</text>
</error>
</xsl:if>
<xsl:if test="($href2!=$fixedId) and ($href2!=$floatingId)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid swPaymentDatesReference/@href value. Value is not equal to ../paymentDates/@id. Value of href = <xsl:value-of select="$href2"/>' and id values are <xsl:value-of select="$fixedId"/> and <xsl:value-of select="$floatingId"/>'.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template name="isValidNonDeliverableDateAdjustments">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:call-template name="isValidBusinessDayConvention">
<xsl:with-param name="elementName">businessDayConvention</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="businessDayConvention"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="businessCentersReference">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected element businessCentersReference encountered.</text>
</error>
</xsl:if>
<xsl:if test="businessDayConvention!='NONE'">
<xsl:if test="not(businessCenters)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing businessCenters. Needed when businessDayConvention not equal to 'NONE'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="dayType='Business'">
<xsl:if test="not(businessCenters)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing businessCenters. Needed when dayType is equal to 'Business'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="businessCenters">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="swFutureValue">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:variable name="calculationPeriodNumberOfDays">
<xsl:value-of select="calculationPeriodNumberOfDays"/>
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
<xsl:apply-templates select="swNotionalFutureValue">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="swNotionalFutureValue">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:variable name="href">
<xsl:value-of select="substring-after(@href,'#')"/>
</xsl:variable>
<xsl:variable name="id">
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$fixedLeg]/calculationPeriodAmount/calculation/notionalSchedule/@id"/>
</xsl:variable>
<xsl:if test="($href!=$id)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid swNotionalFutureValue/@href value. Value is not equal to ../calculationPeriodAmount/calculation/notionalSchedule/@id. Value of href = <xsl:value-of select="$href"/>' and id value is <xsl:value-of select="$id"/>.</text>
</error>
</xsl:if>
<xsl:variable name="notionalFutureValueCurrency">
<xsl:value-of select="currency"/>
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
<xsl:value-of select="currency"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:variable name="amount">
<xsl:value-of select="amount"/>
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
<xsl:template match="swOutsideNovation">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="not(swTransferor/partyId)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swOutsideNovation/swTransferor/partyId must be present for an Outside Novation./>'.</text>
</error>
</xsl:if>
<xsl:variable name="transferee">
<xsl:value-of select="transferee/@href"/>
</xsl:variable>
<xsl:if test="not(//FpML/trade/party[@id=substring-after($transferee,'#')])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swOutsideNovation/transferee/@href does not reference a valid //FpML/trade/party/@id. Value = '<xsl:value-of select="$transferee"/>'.</text>
</error>
</xsl:if>
<xsl:variable name="remainingParty">
<xsl:value-of select="remainingParty/@href"/>
</xsl:variable>
<xsl:if test="not(//FpML/trade/party[@id=substring-after($remainingParty,'#')])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swOutsideNovation/remainingParty/@href does not reference a valid //FpML/trade/party/@id. Value = '<xsl:value-of select="$remainingParty"/>'.</text>
</error>
</xsl:if>
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">novationDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="novationDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">novationTradeDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="novationTradeDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="fullFirstCalculationPeriod">
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">fullFirstCalculationPeriod</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fullFirstCalculationPeriod"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
</xsl:template>
<xsl:template match="swAssociatedBonds">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="swNegotiatedSpreadRate">
<xsl:variable name="swNegotiatedSpreadRate">
<xsl:value-of select="swNegotiatedSpreadRate"/>
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
<xsl:if test="count(swBondDetails) &gt; 2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of swBondDetails child elements encountered. 0 to 2 expected.</text>
</error>
</xsl:if>
<xsl:apply-templates select="swBondDetails">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="swBondDetails">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:if test="swBondId">
<xsl:call-template name="isValidBondId">
<xsl:with-param name="elementName">swBondId</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="swBondId"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:variable name="swBondName">
<xsl:value-of select="swBondName"/>
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
<xsl:value-of select="swBondFaceAmount"/>
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
<xsl:value-of select="swPriceType"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:variable name="swPriceType">
<xsl:value-of select="swPriceType"/>
</xsl:variable>
<xsl:if test="$tradeCurrency ='USD'">
<xsl:if test="$swPriceType !='F128' and $swPriceType !='F256' and $swPriceType !='D5'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swPriceType must be equal to 'F128' or 'F256' or 'D5' if trade currency is equal to 'USD'. Value = '<xsl:value-of select="$swPriceType"/>'.</text>
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
<xsl:value-of select="swBondPrice"/>
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
<xsl:template name="isValidBondId">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/>. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='USD.OTR.4W'"/>
<xsl:when test="$elementValue='USD.OTR.8W'"/>
<xsl:when test="$elementValue='USD.OTR.13W'"/>
<xsl:when test="$elementValue='USD.OTR.17W'"/>
<xsl:when test="$elementValue='USD.OTR.26W'"/>
<xsl:when test="$elementValue='USD.OTR.52W'"/>
<xsl:when test="$elementValue='USD.OTR.2Y'"/>
<xsl:when test="$elementValue='USD.OTR.3Y'"/>
<xsl:when test="$elementValue='USD.OTR.5Y'"/>
<xsl:when test="$elementValue='USD.OTR.7Y'"/>
<xsl:when test="$elementValue='USD.OTR.10Y'"/>
<xsl:when test="$elementValue='USD.OTR.20Y'"/>
<xsl:when test="$elementValue='USD.OTR.30Y'"/>
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
<xsl:if test="ancestor::trade/calculationAgent and ($productType='IRS' and $tradeCurrency='BRL')">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:if>
<xsl:if test="ancestor::swaption/calculationAgent and not(ancestor::swap/earlyTerminationProvision)">
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
<xsl:when test="$elementValue='INR'"/>
<xsl:when test="$elementValue='JPY'"/>
<xsl:when test="$elementValue='NOK'"/>
<xsl:when test="$elementValue='NZD'"/>
<xsl:when test="$elementValue='SEK'"/>
<xsl:when test="$elementValue='SGD'"/>
<xsl:when test="$elementValue='THB'"/>
<xsl:when test="$elementValue='TRY'"/>
<xsl:when test="$elementValue='USD'"/>
<xsl:when test="$elementValue='PLN'"/>
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
<xsl:otherwise>
</xsl:otherwise>
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
<xsl:if test="$productType='IRS' or $productType='OIS' or $productType='Swaption' or $productType='CapFloor'">
<xsl:if test="$tradeCurrency='GBP'">
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
<xsl:otherwise>
<xsl:choose>
<xsl:when test="(($elementValue='BUS/252') and ($tradeCurrency='BRL') and ($productType='IRS'))"/>
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
</xsl:if>
<xsl:if test="$tradeCurrency!='GBP'">
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
<xsl:otherwise>
<xsl:choose>
<xsl:when test="(($elementValue='BUS/252') and ($tradeCurrency='BRL') and ($productType='IRS'))"/>
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
<xsl:when test="$elementValue='ISDA2021'">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>Trades with ISDA 2021 Contractual Definitions are not supported in 3-0 version.
</text>
</error>
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
<xsl:when test="$elementValue='Premium'"/>
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
<xsl:if test="not($productType='OIS')">
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
</xsl:if>
<xsl:if test="$productType='OIS'">
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
</xsl:if>
</xsl:template>
<xsl:template name="isValidPeriodMultiplier">
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
<xsl:if test="$version='3-0'">
<xsl:choose>
<xsl:when test="$elementValue='SingleCurrencyInterestRateSwap'"/>
<xsl:when test="$elementValue='FRA'"/>
<xsl:when test="$elementValue='OIS'"/>
<xsl:when test="$elementValue='Swaption'"/>
<xsl:when test="$elementValue='CapFloor'"/>
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
<xsl:if test="$productType='IRS' or $productType='CapFloor' or $productType='Swaption'">
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
<xsl:when test="$elementValue='10:00:00'"/>
<xsl:when test="$elementValue='10:30:00'"/>
<xsl:when test="$elementValue='11:00:00'"/>
<xsl:when test="$elementValue='11:15:00'"/>
<xsl:when test="$elementValue='11:30:00'"/>
<xsl:when test="$elementValue='12:00:00'"/>
<xsl:when test="$elementValue='12:30:00'"/>
<xsl:when test="$elementValue='13:00:00'"/>
<xsl:when test="$elementValue='13:30:00'"/>
<xsl:when test="$elementValue='14:00:00'"/>
<xsl:when test="$elementValue='14:30:00'"/>
<xsl:when test="$elementValue='15:00:00'"/>
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
</xsl:choose>
</xsl:template>
<xsl:template name="isValidShortFormCompoundingMethod">
<xsl:param name="floatPaymentFrequency"/>
<xsl:param name="floatRollFrequency"/>
<xsl:param name="compoundingMethod"/>
<xsl:variable name="context"/>
<xsl:if test="not($floatPaymentFrequency='') and not ($floatRollFrequency='')">
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
<xsl:if test="not($floatPaymentFrequency=$floatRollFrequency)">
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
<xsl:template match="swMandatoryClearing|swMandatoryClearingNewNovatedTrade">
<xsl:param name="context"/>
<xsl:if test="swMandatoryClearingIndicator">
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">swMandatoryClearingIndicator</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="swMandatoryClearingIndicator"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$context"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:for-each select="swPartyExemption/swExemption">
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
<xsl:if test="swPartyExemption[position()=1]/swPartyReference/@href = swPartyExemption[position()=2]/swPartyReference/@href">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** swPartyExemption cannot be provided twice for the same party for the same clearing jurisdiction</text>
</error>
</xsl:if>
<xsl:if test="current()[swJurisdiction/text()!='DoddFrank'][swSupervisoryBodyCategory]">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** swSupervisoryBodyCategory not supported for '<xsl:value-of select="swJurisdiction"/>' clearing</text>
</error>
</xsl:if>
<xsl:if test="current()[contains(';ASIC;JFSA;MAS;', concat(';', swJurisdiction/text(),';'))][swPartyExemption]">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** swPartyExemption cannot be provided for '<xsl:value-of select="swJurisdiction"/>' </text>
</error>
</xsl:if>
<xsl:if test="not(contains(';ASIC;CAN;ESMA;FCA;HKMA;JFSA;DoddFrank;MIFID;MAS;', concat(';', swJurisdiction/text(),';')))">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** This value:'<xsl:value-of select="swJurisdiction"/>' of swJurisdiction is not in supported list for mandatory clearing - Permitted values: ASIC;CAN;ESMA;FCA;HKMA;JFSA;DoddFrank;MIFID;MAS. Concat result: '<xsl:value-of select="concat(';', swJurisdiction/text(),';')"/>' function contains returns: '<xsl:value-of select="contains(';ASIC;CAN;ESMA;FCA;HKMA;JFSA;DoddFrank;MIFID;MAS;', concat(';', swJurisdiction/text(),';'))"/>'.</text>
</error>
</xsl:if>
<xsl:if test="current()[swJurisdiction/text()='DoddFrank'][not(swSupervisoryBodyCategory='BroadBased')]">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** Invalid value: swSupervisoryBodyCategory not in supported list. Value='<xsl:value-of select="swSupervisoryBodyCategory/text()"/>'.</text>
</error>
</xsl:if>
<xsl:if test="current()[swJurisdiction/text()='JFSA']">
<xsl:if test="/SWDML/swTradeEventReportingDetails/swReportingRegimeInformation[swJurisdiction/text()=current()/swJurisdiction/text()]/swMandatoryClearingIndicator">
<xsl:if test="not(/SWDML/swTradeEventReportingDetails/swReportingRegimeInformation[swJurisdiction/text()=current()/swJurisdiction/text()]/swMandatoryClearingIndicator = current()/swMandatoryClearingIndicator)">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** Different values have been specified for swMandatoryClearingIndicator in reporting and clearing sections for jurisdiction '<xsl:value-of select="Jurisdiction"/>'.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
</xsl:template>
<xsl:template match="swBusinessConductDetails">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:apply-templates select="swMidMarketPrice">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="swMidMarketPrice">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="swUnit">
<xsl:choose>
<xsl:when test="swUnit/text()='Price'"/>
<xsl:when test="swUnit/text()='BasisPoints'"/>
<xsl:when test="swUnit/text()='Percentage'"/>
<xsl:when test="swUnit/text()='Level'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** Invalid value submitted for <xsl:value-of select="local-name()"/>/swUnit. Value = '<xsl:value-of select="swUnit/text()"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test=" swAmount and (string(number(swAmount/text())) ='NaN' or contains(swAmount/text(),'e') or 	contains(swAmount/text(),'E'))">
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
<xsl:value-of select="swAmount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">-9999999999.99999999</xsl:with-param>
<xsl:with-param name="maxIncl">9999999999.99999999</xsl:with-param>
<xsl:with-param name="maxDecs">8</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="not(string-length(swUnit) &gt; 0) and (swCurrency or swAmount)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***Mid-Market Price Type is required.</text>
</error>
</xsl:if>
<xsl:if test="string-length(swUnit) &gt; 0 and not (swCurrency) and not (swAmount)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***Mid-Market Price Value is required.</text>
</error>
</xsl:if>
<xsl:if test="swUnit/text() = 'Price' and swCurrency and not(swAmount)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***Mid-Market Price Value is required.</text>
</error>
</xsl:if>
<xsl:if test="not(swUnit/text() = 'Price') and string-length(swUnit) &gt; 0 and string-length(swCurrency) &gt; 0">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***Mid-Market Price Currency not allowed for type.</text>
</error>
</xsl:if>
<xsl:if test=" swUnit/text()= 'Price' and swAmount and not(string-length(swCurrency) &gt; 0)">
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
