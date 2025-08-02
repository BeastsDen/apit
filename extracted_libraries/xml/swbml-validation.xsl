<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:common="http://exslt.org/common" version="1.0" exclude-result-prefixes="common">
<xsl:import href="CrossAssetValidation.xsl"/>
<xsl:import href="swbml-validation-reporting.xsl"/>
<xsl:variable name="version">
<xsl:value-of select="/SWBML/@version"/>
</xsl:variable>
<xsl:variable name="assetClass">Rates</xsl:variable>
<xsl:variable name="productType">
<xsl:value-of select="/SWBML/swbStructuredTradeDetails/swbProductType"/>
</xsl:variable>
<xsl:variable name="FpMLVersion">
<xsl:value-of select="/SWBML/swbStructuredTradeDetails/FpML/@version"/>
</xsl:variable>
<xsl:variable name="isAllocatedTrade">
<xsl:choose>
<xsl:when test="/SWBML/swbAllocations">1</xsl:when>
<xsl:otherwise>0</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="frontandbackstub">
<xsl:choose>
<xsl:when test = "/SWBML//swbStructuredTradeDetails/swbExtendedTradeDetails/swbFrontAndBackStubs">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="isEmptyBlockTrade">
<xsl:choose>
<xsl:when test="/SWBML/swbBlockTrade">1</xsl:when>
<xsl:otherwise>0</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="blockIndependentAmountCurrency">
<xsl:for-each select="/SWBML//swbStructuredTradeDetails//additionalPayment">
<xsl:choose>
<xsl:when test="paymentType='Independent Amount'">
<xsl:value-of select="paymentAmount/currency"/>
</xsl:when>
</xsl:choose>
</xsl:for-each>
</xsl:variable>
<xsl:variable name="isPrimeBrokerTrade">
<xsl:choose>
<xsl:when test="/SWBML/swbGiveUp">1</xsl:when>
<xsl:otherwise>0</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="isClientClearingTrade">
<xsl:choose>
<xsl:when test="/SWBML/swbStructuredTradeDetails/swbExtendedTradeDetails/swbTradeHeader/swbClientClearing='true'">1</xsl:when>
<xsl:otherwise>0</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="fixedLeg">
<xsl:choose>
<xsl:when test="/SWBML/swbStructuredTradeDetails/FpML/trade//swap/swapStream[position()=1]/resetDates">2</xsl:when>
<xsl:otherwise>1</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="floatingLeg">
<xsl:choose>
<xsl:when test="/SWBML/swbStructuredTradeDetails/FpML/trade//swap/swapStream[position()=1]/resetDates">1</xsl:when>
<xsl:otherwise>2</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="tradeCurrency">
<xsl:value-of select="/SWBML/swbStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/calculationPeriodAmount/calculation/notionalSchedule/notionalStepSchedule/currency"/>
<xsl:value-of select="/SWBML/swbStructuredTradeDetails/FpML/trade/capFloor/capFloorStream/calculationPeriodAmount/calculation/notionalSchedule/notionalStepSchedule/currency"/>
<xsl:value-of select="/SWBML/swbStructuredTradeDetails/FpML/trade//fra/notional/currency"/>
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
<xsl:value-of select="/SWBML/swbStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$fixedLeg]/paymentDates/paymentFrequency/periodMultiplier"/>
<xsl:value-of select="/SWBML/swbStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$fixedLeg]/paymentDates/paymentFrequency/period"/>
</xsl:variable>
<xsl:variable name="floatPaymentFreq">
<xsl:value-of select="/SWBML/swbStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/paymentDates/paymentFrequency/periodMultiplier"/>
<xsl:value-of select="/SWBML/swbStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/paymentDates/paymentFrequency/period"/>
</xsl:variable>
<xsl:variable name="interestRateSwapType">
<xsl:choose>
<xsl:when test="(($productType='SingleCurrencyInterestRateSwap' or $productType='OIS' or $isOISonSwaption='true') and $fixedPaymentFreq = '1T' and /SWBML/swbStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$fixedLeg]/calculationPeriodAmount/knownAmountSchedule and /SWBML/swbStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/calculationPeriodAmount/calculation )">
<xsl:value-of select="'zeroCouponInterestRateSwapWithFixedAmount'"/>
</xsl:when>
<xsl:when test="(($productType='SingleCurrencyInterestRateSwap' or $productType='OIS' or $isOISonSwaption='true') and $fixedPaymentFreq = '1T' and /SWBML/swbStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/calculationPeriodAmount/calculation and /SWBML/swbStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$fixedLeg]/calculationPeriodAmount/calculation)">
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
<xsl:variable name="reportingData.rtf">
<xsl:apply-templates select="/SWBML/swbTradeEventReportingDetails/node()" mode="mapReportingData"/>
<xsl:apply-templates select="/SWBML/swbPrivatePartyTradeEventReportingDetails/node()" mode="mapReportingData"/>
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
<xsl:apply-templates select="SWBML" mode="get-reporting-data"/>
</xsl:template>
<xsl:template match="/SWBML[function-available('common:node-set')]" mode="get-reporting-data">
<xsl:apply-templates select=".">
<xsl:with-param name="reportingData" select="common:node-set($reportingData.rtf)"/>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="/SWBML[not(function-available('common:node-set'))]" mode="get-reporting-data">
<xsl:apply-templates select=".">
<xsl:with-param name="reportingData" select="$reportingData.rtf"/>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="SWBML">
<xsl:param name="reportingData"/>
<xsl:variable name="newContext">In <xsl:value-of select="local-name()"/>
</xsl:variable>
<results version="1.0">
<xsl:variable name="periodSchemeDefault">
<xsl:value-of select="@periodSchemeDefault"/>
</xsl:variable>
<xsl:variable name="swbBondIdSchemeDefault">
<xsl:value-of select="@swbBondIdSchemeDefault"/>
</xsl:variable>
<xsl:variable name="swbMasterAgreementTypeSchemeDefault">
<xsl:value-of select="@swbMasterAgreementTypeSchemeDefault"/>
</xsl:variable>
<xsl:variable name="swbPriceTypeSchemeDefault">
<xsl:value-of select="@swbPriceTypeSchemeDefault"/>
</xsl:variable>
<xsl:variable name="swbProductTypeSchemeDefault">
<xsl:value-of select="@swbProductTypeSchemeDefault"/>
</xsl:variable>
<xsl:variable name="swbStubPositionSchemeDefault">
<xsl:value-of select="@swbStubPositionSchemeDefault"/>
</xsl:variable>
<xsl:variable name="swbTradeSourceSchemeDefault">
<xsl:value-of select="@swbTradeSourceSchemeDefault"/>
</xsl:variable>
<xsl:if test="not($version='1-0' or $version='2-0' or $version='3-0')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid version attribute. Value = '<xsl:value-of select="$version"/>'.</text>
</error>
</xsl:if>
<xsl:if test="($isClientClearingTrade=1) and ($version='1-0' or $version='2-0' or $version='3-0')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Client Clearing trade submission is only support under version 4-2. Value = '<xsl:value-of select="$version"/>'.</text>
</error>
</xsl:if>
<xsl:if test="$periodSchemeDefault!='http://www.fpml.org/spec/2000/period-1-0'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid periodSchemeDefault attribute. Value = '<xsl:value-of select="$periodSchemeDefault"/>'.</text>
</error>
</xsl:if>
<xsl:if test="$swbBondIdSchemeDefault!='http://www.swapswire.com/spec/2001/bond-id-1-0'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid swbBondIdSchemeDefault attribute. Value = '<xsl:value-of select="$swbBondIdSchemeDefault"/>'.</text>
</error>
</xsl:if>
<xsl:if test="$swbMasterAgreementTypeSchemeDefault!='http://www.swapswire.com/spec/2001/master-agreement-type-1-0'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid swbMasterAgreementTypeSchemeDefault attribute. Value = '<xsl:value-of select="$swbMasterAgreementTypeSchemeDefault"/>'.</text>
</error>
</xsl:if>
<xsl:if test="$swbPriceTypeSchemeDefault!='http://www.swapswire.com/spec/2002/price-type-1-0'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid swbPriceTypeSchemeDefault attribute. Value = '<xsl:value-of select="$swbPriceTypeSchemeDefault"/>'.</text>
</error>
</xsl:if>
<xsl:if test="$swbProductTypeSchemeDefault!='http://www.swapswire.com/spec/2001/product-type-1-0'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid swbProductTypeSchemeDefault attribute. Value = '<xsl:value-of select="$swbProductTypeSchemeDefault"/>'.</text>
</error>
</xsl:if>
<xsl:if test="$swbStubPositionSchemeDefault!='http://www.swapswire.com/spec/2002/stub-position-1-0'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid swbStubPositionSchemeDefault attribute. Value = '<xsl:value-of select="$swbStubPositionSchemeDefault"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not($version='1-0' or $version='2-0')">
<xsl:if test="$swbTradeSourceSchemeDefault!='http://www.swapswire.com/spec/2002/trade-source-1-0'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid swbTradeSourceSchemeDefault attribute. Value = '<xsl:value-of select="$swbTradeSourceSchemeDefault"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="not(swbHeader)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swbHeader.</text>
</error>
</xsl:if>
<xsl:if test="not(swbStructuredTradeDetails)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swbStructuredTradeDetails.</text>
</error>
</xsl:if>
<xsl:apply-templates select="swbHeader">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="swbGiveUp">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="swbAllocations">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="swbStructuredTradeDetails">
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
<xsl:template match="swbHeader">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="$isPrimeBrokerTrade=0 and count(swbRecipient)!=2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of swbRecipient child elements encountered. Exactly 2 expected.</text>
</error>
</xsl:if>
<xsl:variable name="id1">
<xsl:value-of select="swbRecipient[1]/@id"/>
</xsl:variable>
<xsl:variable name="id2">
<xsl:value-of select="swbRecipient[2]/@id"/>
</xsl:variable>
<xsl:if test="$id1=$id2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbRecipient[1]/@id and swbRecipient[2]/@id values are the same.</text>
</error>
</xsl:if>
<xsl:variable name="href1">
<xsl:value-of select="swbRecipient[1]/partyReference/@href"/>
</xsl:variable>
<xsl:variable name="href2">
<xsl:value-of select="swbRecipient[2]/partyReference/@href"/>
</xsl:variable>
<xsl:if test="$href1=$href2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbRecipient[1]/partyReference/@href and swbRecipient[2]/partyReference/@href values are the same.</text>
</error>
</xsl:if>
<xsl:variable name="swbBrokerTradeId">
<xsl:value-of select="swbBrokerTradeId"/>
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
<xsl:if test="swbBrokerLegId">
<xsl:variable name="swbBrokerLegId">
<xsl:value-of select="swbBrokerLegId"/>
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
<xsl:variable name="swbBrokerTradeVersionId">
<xsl:value-of select="swbBrokerTradeVersionId"/>
</xsl:variable>
<xsl:if test="$swbBrokerTradeVersionId=''">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Empty or missing swbBrokerTradeVersionId.</text>
</error>
</xsl:if>
<xsl:if test="string-length($swbBrokerTradeVersionId) &gt; 40">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid swbBrokerTradeVersionId string length. Exceeded max length of 40 characters.</text>
</error>
</xsl:if>
<xsl:if test="not($version='1-0')">
<xsl:variable name="swbTradeSource">
<xsl:value-of select="swbTradeSource"/>
</xsl:variable>
<xsl:if test="$swbTradeSource=''">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Empty or missing swbTradeSource.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$version='1-0'">
<xsl:if test="swbTradeSource">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Element swbTradeSource must not be present if SWBML version = "1-0".</text>
</error>
</xsl:if>
</xsl:if>
<xsl:variable name="swbVenueIdScheme">
<xsl:value-of select="swbVenueId/@swbVenueIdScheme"/>
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
<xsl:variable name="swbReplacementReason">
<xsl:value-of select="//swbReplacementReason"/>
</xsl:variable>
<xsl:if test="$swbReplacementReason = 'IndexTransitionReplacedByTrade'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** IndexTransitionReplacedByTrade is not a valid value for Replacement Reason in this context.</text>
</error>
</xsl:if>
<xsl:apply-templates select="swbRecipient">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="swbRecipient">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:variable name="id">
<xsl:value-of select="./@id"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$id!=''"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Empty or missing swbRecipient/@id value.</text>
</error>
</xsl:otherwise>
</xsl:choose>
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
<xsl:value-of select="partyReference/@href"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$href='#partyA'"/>
<xsl:when test="$href='#partyB'"/>
<xsl:when test="$href='#partyC'"/>
<xsl:when test="$href='#partyD'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid partyReference/@href value. Value = '<xsl:value-of select="$href"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
<xsl:if test="swbUserName">
<xsl:if test="$version='1-0' or $version='2-0'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Element swbUserName must not be present if SWBML version = "1-0" or "2-0".</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="swbUserName[.='']">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Empty swbUserName.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="swbGiveUp">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="hrefC">
<xsl:value-of select="swbCustomerTransaction/swbCustomer/@href"/>
</xsl:variable>
<xsl:variable name="hrefD">
<xsl:value-of select="swbInterDealerTransaction/swbExecutingDealer/@href"/>
</xsl:variable>
<xsl:variable name="hrefCPB">
<xsl:value-of select="swbCustomerTransaction/swbPrimeBroker/@href"/>
</xsl:variable>
<xsl:variable name="hrefDPB">
<xsl:value-of select="swbInterDealerTransaction/swbPrimeBroker/@href"/>
</xsl:variable>
<xsl:variable name="hrefG">
<xsl:value-of select="swbExecutingDealerCustomerTransaction/swbExecutingDealer/@href"/>
</xsl:variable>
<xsl:if test="$hrefD != '#partyA'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***  Invalid party reference specified for Executing Dealer. Expecting '#partyA'. Value = '<xsl:value-of select="$hrefD"/>'.***.</text>
</error>
</xsl:if>
<xsl:if test="$hrefC != '#partyB'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***  Invalid party reference specified for Customer. Expecting '#partyB'. Value = '<xsl:value-of select="$hrefC"/>'.***.</text>
</error>
</xsl:if>
<xsl:if test="not($productType='SingleCurrencyInterestRateSwap' or $productType='OIS' or $productType='Single Currency Basis Swap' or $productType='FRA') and ($isPrimeBrokerTrade='1')">
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
<xsl:if test="swbExecutingDealerCustomerTransaction">
<xsl:if test="not(//FpML/trade/party[@id=substring-after($hrefG,'#')])">
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
<xsl:if test="not(//FpML/trade/party[@id=substring-after($hrefC,'#')])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbCustomerTransaction/swbCustomer/@href does not reference a valid //FpML/trade/party/@id. Value = '<xsl:value-of select="$hrefC"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not(//FpML/trade/party[@id=substring-after($hrefCPB,'#')])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbCustomerTransaction/swbPrimeBroker/@href does not reference a valid //FpML/trade/party/@id. Value = '<xsl:value-of select="$hrefCPB"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not(//FpML/trade/party[@id=substring-after($hrefD,'#')])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbInterDealerTransaction/swbExecutingDealer/@href does not reference a valid //FpML/trade/party/@id. Value = '<xsl:value-of select="$hrefD"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not(//FpML/trade/party[@id=substring-after($hrefDPB,'#')])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbInterDealerTransaction/swbPrimeBroker/@href does not reference a valid //FpML/trade/party/@id. Value = '<xsl:value-of select="$hrefDPB"/>'.</text>
</error>
</xsl:if>
<xsl:if test="$productType = 'OIS' or $productType = 'IRS'">
<xsl:if test="($hrefD != //FpML/trade//swap/swapStream[position()=$floatingLeg]/payerPartyReference/@href) and ($hrefD != //FpML/trade//swap/swapStream[position()=$floatingLeg]/receiverPartyReference/@href)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbInterDealerTransaction/swbExecutingDealer/@href must be a payer or receiver on swap if product type is 'SingleCurrencyInterestRateSwap' or 'OIS'.</text>
</error>
</xsl:if>
<xsl:if test="($hrefC != //FpML/trade//swap/swapStream[position()=$floatingLeg]/receiverPartyReference/@href) and ($hrefC != //FpML/trade//swap/swapStream[position()=$floatingLeg]/payerPartyReference/@href)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbCustomerTransaction/swbCustomer/@href must be a payer or receiver on swap if product type is 'SingleCurrencyInterestRateSwap' or 'OIS'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$productType = 'IRS' or $productType='OIS'">
<xsl:if test=".//swEarlyTerminationProvision">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** .//swEarlyTerminationProvision must not be specified in a Primary Prime Brokered Trade.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="node()/swbMandatoryClearing">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="swbAllocations">
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
<xsl:if test="not($productType='SingleCurrencyInterestRateSwap' or $productType='OIS' or $productType='Single Currency Basis Swap' or $productType='FRA') and ($isAllocatedTrade='1')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***  Validation 2 BROKEN: Broker submission of allocated trades is only supported for IRS, OIS, FRA and Single Currency Basis Swap  products***.</text>
</error>
</xsl:if>
<xsl:apply-templates select="swbAllocation">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="swbAllocation">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]
</xsl:variable>
<xsl:variable name="reportingAllocationData.rtf">
<xsl:apply-templates select="swbAllocationReportingDetails/node()" mode="mapReportingData"/>
</xsl:variable>
<xsl:if test="swbStreamReference and not(swbStreamReference/@href='#fixedLeg')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbStreamReference must reference fixed leg ***</text>
</error>
</xsl:if>
<xsl:if test="$productType = 'OIS' or $productType = 'IRS'">
<xsl:if test="not(swbStreamReference)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbStreamReference must be present if product type is 'SingleCurrencyInterestRateSwap', OIS or 'Single Currency Basis Swap'.</text>
</error>
</xsl:if>
<xsl:variable name="payerPartyRef">
<xsl:value-of select="payerPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="receiverPartyRef">
<xsl:value-of select="receiverPartyReference/@href"/>
</xsl:variable>
<xsl:if test="$payerPartyRef=$receiverPartyRef">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Validation 4a BROKEN: payerPartyReference/@href and receiverPartyReference/@href values must not be the same.</text>
</error>
</xsl:if>
<xsl:if test="not(//FpML/trade/party[@id=substring-after($payerPartyRef,'#')])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Validation 4b BROKEN: payerPartyReference/@href does not reference a valid FpML/trade/party/@id. Value = '<xsl:value-of select="$payerPartyRef"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not(//FpML/trade/party[@id=substring-after($receiverPartyRef,'#')])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Validation 4c BROKEN: receiverPartyReference/@href does not reference a valid FpML/trade/party/@id. Value = '<xsl:value-of select="$receiverPartyRef"/>'.</text>
</error>
</xsl:if>
<xsl:variable name="payerPartyId">
<xsl:value-of select="//FpML/trade/party[@id=substring-after($payerPartyRef,'#')]/partyId"/>
</xsl:variable>
<xsl:variable name="receiverPartyId">
<xsl:value-of select="//FpML/trade/party[@id=substring-after($receiverPartyRef,'#')]/partyId"/>
</xsl:variable>
<xsl:if test="$payerPartyId=$receiverPartyId">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Validation 4d BROKEN: partyId (legal entity) referenced by payerPartyReference/@href must not equal partyId (legal entity) referenced by receiverPartyReference/@href.</text>
</error>
</xsl:if>
<xsl:apply-templates select="allocatedNotional">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
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
</xsl:if>
<xsl:if test="$productType = 'FRA'">
<xsl:if test="not(buyerPartyReference)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***buyerPartyReference must be present if product type is 'FRA''.</text>
</error>
</xsl:if>
<xsl:variable name="buyerPartyRef">
<xsl:value-of select="buyerPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="sellerPartyRef">
<xsl:value-of select="sellerPartyReference/@href"/>
</xsl:variable>
<xsl:if test="$buyerPartyRef=$sellerPartyRef">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***buyerPartyReference/@href and sellerPartyReference/@href values must not be the same.</text>
</error>
</xsl:if>
<xsl:if test="not(//FpML/trade/party[@id=substring-after($buyerPartyRef,'#')])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***buyerPartyReference/@href does not reference a valid /FpML/trade/party/@id. Value = '<xsl:value-of select="$buyerPartyRef"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not(//FpML/trade/party[@id=substring-after($sellerPartyRef,'#')])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***sellerPartyReference/@href does not reference a valid /FpML/trade/party/@id. Value = '<xsl:value-of select="$sellerPartyRef"/>'.</text>
</error>
</xsl:if>
<xsl:variable name="buyerPartyId">
<xsl:value-of select="//FpML/trade/party[@id=substring-after($buyerPartyRef,'#')]/partyId"/>
</xsl:variable>
<xsl:variable name="sellerPartyId">
<xsl:value-of select="//FpML/trade/party[@id=substring-after($sellerPartyRef,'#')]/partyId"/>
</xsl:variable>
<xsl:if test="$buyerPartyId=$sellerPartyId">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** partyId (legal entity) referenced by buyerPartyReference/@href must not equal partyId (legal entity) referenced by sellerPartyReference/@href.</text>
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
</xsl:if>
<xsl:variable name="messageText">
<xsl:value-of select="swbBrokerTradeId"/>
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
<xsl:template match="allocatedNotional">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="allocatedNotionalCurrency">
<xsl:value-of select="currency"/>
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
<xsl:if test="$allocatedNotionalCurrency != $tradeCurrency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Validation 6 BROKEN: allocatedNotional/currency must be the same as the block notional currency within an allocated trade. Value = '<xsl:value-of select="$allocatedNotionalCurrency"/>'.</text>
</error>
</xsl:if>
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
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="payerPartyRef">
<xsl:value-of select="payerPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="receiverPartyRef">
<xsl:value-of select="receiverPartyReference/@href"/>
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
<xsl:apply-templates select="paymentDetail">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="paymentDetail">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:apply-templates select="paymentAmount">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:variable name="currency">
<xsl:value-of select="paymentAmount/currency"/>
</xsl:variable>
</xsl:template>
<xsl:template match="paymentAmount">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="IA_paymentCurrency">
<xsl:value-of select="currency"/>
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
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">3999999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:template>
<xsl:template match="swbStructuredTradeDetails">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:call-template name="isValidProductType">
<xsl:with-param name="elementName">swbProductType</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="swbProductType"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="not(FpML)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing FpML element.</text>
</error>
</xsl:if>
<xsl:if test="not(swbExtendedTradeDetails)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swbExtendedTradeDetails.</text>
</error>
</xsl:if>
<xsl:apply-templates select="FpML">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="swbExtendedTradeDetails">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="swbBusinessConductDetails">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="swbTradePackageHeader">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="FpML">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
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
<xsl:if test="not($FpMLVersion='1-0' or $FpMLVersion='2-0')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid version attribute. Value = '<xsl:value-of select="$FpMLVersion"/>'.</text>
</error>
</xsl:if>
<xsl:if test="$FpMLVersion='2-0'">
<xsl:if test="$version='1-0' or $version='2-0'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** FpML version = "2-0" is not allowed if SWBML version = "1-0" or "2-0". SWBML version = "<xsl:value-of select="$version"/>".</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$FpMLVersion='1-0'">
<xsl:if test="not($version='1-0' or $version='2-0')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** FpML version = "1-0" is not allowed if SWBML version is not equal to "1-0" or "2-0". SWBML version = "<xsl:value-of select="$version"/>".</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$businessCenterSchemeDefault!='http://www.fpml.org/spec/2000/business-center-1-0'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid businessCenterSchemeDefault atriibute. Value = '<xsl:value-of select="$businessCenterSchemeDefault"/>'.</text>
</error>
</xsl:if>
<xsl:if test="$businessDayConventionSchemeDefault!='http://www.swapswire.com/spec/2001/business-day-convention-1-0'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid businessDayConventionSchemeDefault attribute. Value = '<xsl:value-of select="$businessDayConventionSchemeDefault"/>'.</text>
</error>
</xsl:if>
<xsl:if test="$compoundingMethodSchemeDefault!='http://www.fpml.org/spec/2000/compounding-method-1-0'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid compoundingMethodSchemeDefault attribute. Value = '<xsl:value-of select="$compoundingMethodSchemeDefault"/>'.</text>
</error>
</xsl:if>
<xsl:if test="$currencySchemeDefault!='http://www.fpml.org/ext/iso4217'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid currencySchemeDefault attribute. Value = '<xsl:value-of select="$currencySchemeDefault"/>'.</text>
</error>
</xsl:if>
<xsl:if test="$dateRelativeToSchemeDefault!='http://www.fpml.org/spec/2001/date-relative-to-1-0'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid dateRelativeToSchemeDefault attribute. Value = '<xsl:value-of select="$dateRelativeToSchemeDefault"/>'.</text>
</error>
</xsl:if>
<xsl:if test="$dayCountFractionSchemeDefault!='http://www.fpml.org/spec/2000/day-count-fraction-1-0'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid dayCountFractionSchemeDefault attribute. Value = '<xsl:value-of select="$dayCountFractionSchemeDefault"/>'.</text>
</error>
</xsl:if>
<xsl:if test="$dayTypeSchemeDefault!='http://www.fpml.org/spec/2000/day-type-1-0'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid dayTypeSchemeDefault attribute. Value = '<xsl:value-of select="$dayTypeSchemeDefault"/>'.</text>
</error>
</xsl:if>
<xsl:if test="$floatingRateIndexSchemeDefault!='http://www.swapswire.com/spec/2001/floating-rate-index-1-0'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid floatingRateIndexSchemeDefault attribute. Value = '<xsl:value-of select="$floatingRateIndexSchemeDefault"/>'.</text>
</error>
</xsl:if>
<xsl:if test="$partyIdSchemeDefault!='http://www.fpml.org/ext/iso9362'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid partyIdSchemeDefault attribute. Value = '<xsl:value-of select="$partyIdSchemeDefault"/>'.</text>
</error>
</xsl:if>
<xsl:if test="$version='3-0'">
<xsl:if test="$payerReceiverSchemeDefault!='http://www.fpml.org/spec/2001/payer-receiver-1-0'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid payerReceiverSchemeDefault attribute. Value = '<xsl:value-of select="$payerReceiverSchemeDefault"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$version='3-0'">
<xsl:if test="$paymentTypeSchemeDefault!='http://www.swapswire.com/spec/2001/payment-type-1-0'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid paymentTypeSchemeDefault attribute. Value = '<xsl:value-of select="$paymentTypeSchemeDefault"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$payRelativeToSchemeDefault!='http://www.swapswire.com/spec/2001/pay-relative-to-1-0'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid payRelativeToSchemeDefault attribute. Value = '<xsl:value-of select="$payRelativeToSchemeDefault"/>'.</text>
</error>
</xsl:if>
<xsl:if test="$periodSchemeDefault!='http://www.fpml.org/spec/2000/period-1-0'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid periodSchemeDefault attribute. Value = '<xsl:value-of select="$periodSchemeDefault"/>'.</text>
</error>
</xsl:if>
<xsl:if test="$resetRelativeToSchemeDefault!='http://www.fpml.org/spec/2000/reset-relative-to-1-0'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid resetRelativeToSchemeDefault attribute. Value = '<xsl:value-of select="$resetRelativeToSchemeDefault"/>'.</text>
</error>
</xsl:if>
<xsl:if test="$rollConventionSchemeDefault!='http://www.swapswire.com/spec/2001/roll-convention-1-0'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid rollConventionSchemeDefault attribute. Value = '<xsl:value-of select="$rollConventionSchemeDefault"/>'.</text>
</error>
</xsl:if>
<xsl:if test="$tradeIdSchemeDefault=''">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing tradeIdSchemeDefault attribute.</text>
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
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="$version='1-0'">
<xsl:if test="count(party)!=3">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of party child elements encountered. Exactly 3 expected if SWBML version = "1-0".</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="not($version='1-0') and ($isAllocatedTrade=0) and ($isPrimeBrokerTrade=0)">
<xsl:if test="(not(count(party)=3 or count(party)=4))">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of party child elements encountered. 3 or 4 expected if SWBML version is not equal to "1-0".</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="not($version='1-0') and (($isAllocatedTrade=1) or ($isPrimeBrokerTrade=1))">
<xsl:if test="not(count(party) &gt; 2)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of party child elements encountered. 3 or more expected if SWBML version is not equal to "1-0".</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="count(otherPartyPayment) &gt; 2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of otherPartyPayment child elements encountered. 0 to 2 expected.</text>
</error>
</xsl:if>
<xsl:if test="otherPartyPayment[2]">
<xsl:variable name="href1">
<xsl:value-of select="otherPartyPayment[1]/payerPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="href2">
<xsl:value-of select="otherPartyPayment[2]/payerPartyReference/@href"/>
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
<xsl:apply-templates select="tradeHeader">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="$FpMLVersion='2-0'">
<xsl:if test="product">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected product child element encountered. Not valid in FpML version = "2-0".</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="product">
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
<xsl:apply-templates select="otherPartyPayment">
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
<xsl:template match="swbExtendedTradeDetails">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:apply-templates select="swbTradeHeader">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="swbTradeHeader/swbOriginatingEvent">
<xsl:choose>
<xsl:when test="swbTradeHeader/swbOriginatingEvent=''"/>
<xsl:when test="swbTradeHeader/swbOriginatingEvent='Bunched Order Block'"/>
<xsl:when test="swbTradeHeader/swbOriginatingEvent='Bunched Order Allocation'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***swOriginatingEvent element value is not supported. Supported values are '', 'Bunched Order Block', 'Bunched Order Allocation'. Value = '<xsl:value-of select="swbTradeHeader/swbOriginatingEvent"/>'."/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="not(swbProductTerm) and not($productType='FRA')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swbProductTerm.</text>
</error>
</xsl:if>
<xsl:if test="$productType='FRA'">
<xsl:if test="swbProductTerm">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbProductTerm must not be present if product type is 'FRA'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="swbProductTerm">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="swbMasterAgreementType">
<xsl:call-template name="isValidMasterAgreementType">
<xsl:with-param name="elementName">swbMasterAgreementType</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="swbMasterAgreementType"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="swbContractualDefinitions">
<xsl:call-template name="isValidContractualDefinitions">
<xsl:with-param name="elementName">swbContractualDefinitions</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="swbContractualDefinitions"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="swbMessageText">
<xsl:if test="swbMessageText=''">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Empty swbMessageText.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:variable name="messageText">
<xsl:value-of select="swbMessageText"/>
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
<xsl:if test="swbStubPosition">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbStubPosition must not be present if product type is 'FRA'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="swbStubPosition">
<xsl:call-template name="isValidStubPosition">
<xsl:with-param name="elementName">swbStubPosition</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="swbStubPosition"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:choose>
<xsl:when test="swbFrontAndBackStubs">
<xsl:if test="not($productType = 'SingleCurrencyInterestRateSwap' or $productType = 'OIS')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbFrontAndBackStubs should only be present if product type is 'SingleCurrencyInterestRateSwap' or 'OIS'. Value = '<xsl:value-of select="$productType"/>' .</text>
</error>
</xsl:if>
<xsl:if test="swbStubPosition='End'">
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
<xsl:when test="swbStubPosition='End'">
<xsl:if test="/SWBML/swbStructuredTradeDetails/FpML/trade//swap/swapStream/stubCalculationPeriodAmount/initialStub or /SWBML/swbStructuredTradeDetails/FpML/trade//capFloor/capFloorStream/stubCalculationPeriodAmount/initialStub">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbStubPosition value of 'End' is inconsistent with presence of floating leg /stubCalculationPeriodAmount/initialStub element</text>
</error>
</xsl:if>
</xsl:when>
<xsl:otherwise>
<xsl:if test="/SWBML/swbStructuredTradeDetails/FpML/trade//swap/swapStream/stubCalculationPeriodAmount/finalStub or /SWBML/swbStructuredTradeDetails/FpML/trade//capFloor/capFloorStream/stubCalculationPeriodAmount/finalStub">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbStubPosition value of '<xsl:value-of select="swbStubPosition"/>' is inconsistent with presence of floating leg /stubCalculationPeriodAmount/finalStub element</text>
</error>
</xsl:if>
</xsl:otherwise>
</xsl:choose>
</xsl:otherwise>
</xsl:choose>
<xsl:if test="swbNoStubLinearInterpolation and (/SWBML/swbStructuredTradeDetails/FpML/trade//swap/swapStream[@id='floatingLeg']/stubCalculationPeriodAmount or /SWBML/swbStructuredTradeDetails/FpML/trade//capFloor/capFloorStream[@id='floatingLeg']/stubCalculationPeriodAmount)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbNoStubLinearInterpolation element and floating leg /stubCalculationPeriodAmount element cannot both be present.</text>
</error>
</xsl:if>
<xsl:if test="$productType='FRA'">
<xsl:if test="swbStubLength">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbStubLength must not be present if product type is 'FRA''.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="swbStubLength">
<xsl:variable name="swbStubLengthSchemeDefault">
<xsl:value-of select="/SWBML/@swbStubLengthSchemeDefault"/>
</xsl:variable>
<xsl:if test="$swbStubLengthSchemeDefault!='http://www.swapswire.com/spec/2002/stub-length-1-0'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid swbStubLengthSchemeDefault attribute. Value = '<xsl:value-of select="$swbStubLengthSchemeDefault"/>'.</text>
</error>
</xsl:if>
<xsl:apply-templates select="swbStubLength">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="count(swbStubLength)=2">
<xsl:variable name="href1">
<xsl:value-of select="swbStubLength[1]/@href"/>
</xsl:variable>
<xsl:variable name="href2">
<xsl:value-of select="swbStubLength[2]/@href"/>
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
</xsl:if>
<xsl:if test="swbFrontAndBackStubs/swbNoStubLinearInterpolation and (/SWBML/swbStructuredTradeDetails/FpML/trade//swap/swapStream[@id='floatingLeg']/stubCalculationPeriodAmount/finalStub or /SWBML/swbStructuredTradeDetails/FpML/trade//capFloor/capFloorStream[@id='floatingLeg']/stubCalculationPeriodAmount/finalStub)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbFrontAndBackStubs/swbNoStubLinearInterpolation element and floating leg /stubCalculationPeriodAmount element cannot both be present.</text>
</error>
</xsl:if>
<xsl:if test="$productType='FRA'">
<xsl:if test="swbEarlyTerminationProvision">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbEarlyTerminationProvision must not be present if product type is 'FRA' .</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="swbEarlyTerminationProvision">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="$productType='FRA' or $productType='CapFloor' or $productType='Swaption'">
<xsl:if test="swbAssociatedBonds">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbAssociatedBonds must not be present if product type is 'FRA', 'CapFloor' or 'Swaption'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="swbAssociatedBonds">
<xsl:if test="not($tradeCurrency = 'USD' or $tradeCurrency = 'CAD')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbAssociatedBonds should only be present if trade currency is equal to 'USD' or 'CAD'. Value = '<xsl:value-of select="$tradeCurrency"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="swbAssociatedBonds">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="swbAssociatedFuture">
<xsl:if test="not($productType='SingleCurrencyInterestRateSwap' or $productType='OIS')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbAssociatedFuture should only be present if product type is 'SingleCurrencyInterestRateSwap' or 'OIS'. Value = '<xsl:value-of select="$productType"/>' .</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="swbAssociatedFuture">
<xsl:if test="not($tradeCurrency = 'EUR' or $tradeCurrency = 'CHF' or $tradeCurrency = 'GBP' or $tradeCurrency = 'AUD' or $tradeCurrency = 'NZD')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbAssociatedFuture should only be present if trade currency is equal to 'EUR' or 'CHF' or 'GBP' or 'AUD' or 'NZD'. Value = '<xsl:value-of select="$tradeCurrency"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="count(swbAssociatedFuture) &gt; 4">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of swbAssociatedFuture child elements encountered. 0 to 4 expected.</text>
</error>
</xsl:if>
<xsl:choose>
<xsl:when test="count(swbAssociatedFuture[@href='#partyA']) &gt; 2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** No more than two swbAssociatedFuture element children allowed per party. 'partyA' has <xsl:value-of select="count(swbAssociatedFuture[@href='#partyA'])"/>.</text>
</error>
</xsl:when>
<xsl:when test="count(swbAssociatedFuture[@href='#partyB']) &gt; 2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** No more than two swbAssociatedFuture element children allowed per party. 'partyB' has <xsl:value-of select="count(swbAssociatedFuture[@href='#partyB'])"/>.</text>
</error>
</xsl:when>
</xsl:choose>
<xsl:apply-templates select="swbAssociatedFuture">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="swbSettlementProvision">
<xsl:if test="not($productType='SingleCurrencyInterestRateSwap' or $productType='OIS' or $productType='Swaption')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbSettlementProvision should only be present if product type is 'SingleCurrencyInterestRateSwap','OIS' or 'Swaption'. Value = '<xsl:value-of select="$productType"/>' .</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="swbSettlementProvision">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="swbFutureValue">
<xsl:if test="not($productType='SingleCurrencyInterestRateSwap' and $tradeCurrency='BRL')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbFutureValue should only be present if product type is 'IRS' and currency is 'BRL''. Values are '<xsl:value-of select="$productType"/>', '<xsl:value-of select="$tradeCurrency"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="swbFutureValue">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="swbCollateralizedCashPrice">
<xsl:choose>
<xsl:when test="not($productType='Swaption')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbCollateralizedCashPrice should only be present if product type is 'Swaption'.</text>
</error>
</xsl:when>
<xsl:when test="/SWBML/swbStructuredTradeDetails/swbExtendedTradeDetails/swbContractualDefinitions='ISDA2000'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbCollateralizedCashPrice is not valid under stated swbContractualDefinitions.  Value = '<xsl:value-of select="/SWBML/swbStructuredTradeDetails/swbExtendedTradeDetails/swbContractualDefinitions"/>'.</text>
</error>
</xsl:when>
<xsl:when test="((/SWBML/swbStructuredTradeDetails/swbExtendedTradeDetails/swbCollateralizedCashPrice) and (/SWBML/swbStructuredTradeDetails/FpML/trade/swaption/cashSettlement[cashPriceMethod | cashPriceAlternateMethod | parYieldCurveUnadjustedMethod | zeroCouponYieldAdjustedMethod]))">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Only one swaption cash settlement method can be specified. If swbCollateralizedCashPrice is present then neither cashPriceMethod, cashPriceAlternateMethod, parYieldCurveUnadjustedMethod or zeroCouponYieldAdjustedMethod can be present within ../FpML/trade/swaption/cashSettlement</text>
</error>
</xsl:when>
<xsl:otherwise>
<xsl:apply-templates select="swbCollateralizedCashPrice">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:template>
<xsl:template match="swbTradeHeader">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="swbClearedPhysicalSettlement">
<xsl:choose>
<xsl:when test="not($productType='Swaption')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbClearedPhysicalSettlement should only be present if product type is 'Swaption'.</text>
</error>
</xsl:when>
<xsl:when test="/SWBML/swbStructuredTradeDetails/FpML/trade/swaption/cashSettlement">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbClearedPhysicalSettlement should not be present when cash settlement method specified.</text>
</error>
</xsl:when>
<xsl:when test="/SWBML/swbStructuredTradeDetails/swbExtendedTradeDetails/swbContractualDefinitions='ISDA2000'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbClearedPhysicalSettlement is not valid under stated swbContractualDefinitions.  Value = '<xsl:value-of select="/SWBML/swbStructuredTradeDetails/swbExtendedTradeDetails/swbContractualDefinitions"/>'.</text>
</error>
</xsl:when>
<xsl:when test="swbClearedPhysicalSettlement !='true'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbClearedPhysicalSettlement must be set to 'true' if present.  Value = '<xsl:value-of select="swbClearedPhysicalSettlement"/>'.</text>
</error>
</xsl:when>
</xsl:choose>
</xsl:if>
<xsl:if test="swbPredeterminedClearerForUnderlyingSwap">
<xsl:if test="not($productType='Swaption')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbPredeterminedClearerForUnderlyingSwap should only be present if product type is 'Swaption'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="swbPricedToClearCCP">
<xsl:if test="not($productType='Swaption' or $productType='OIS' or $productType='FRA' or $productType='ZC Inflation Swap' or $productType='Fixed Fixed Swap' or $productType='SingleCurrencyInterestRateSwap' or $productType='Single Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='Cross Currency Basis Swap')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbPricedToClearCCP is not valid for product type '<xsl:value-of select="$productType"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="count(swbTradeHeader/swbClientFund)='2'">
<xsl:for-each select="swbTradeHeader/swbClientFund" >
<xsl:if test="not (partyReference)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***When two swbClientFund tags are provided, a partyReference tag must be added to link swbClientFund to a Party .</text>
</error>
</xsl:if>
</xsl:for-each>
</xsl:if>
<xsl:apply-templates select="node()/swbMandatoryClearing">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="swbSettlementProvision">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="swbSettlementCurrency">
<xsl:value-of select="swbSettlementCurrency"/>
</xsl:variable>
<xsl:if test="not(swbSettlementCurrency = 'USD')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbSettlementCurrency must be equal to 'USD'. Value = '<xsl:value-of select="swbSettlementCurrency"/>'.</text>
</error>
</xsl:if>
<xsl:apply-templates select="swbNonDeliverableSettlement">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="swbNonDeliverableSettlement">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:call-template name="isValidNonDeliverableCurrency">
<xsl:with-param name="elementName">swbReferenceCurrency</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="swbReferenceCurrency"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="$tradeCurrency != swbReferenceCurrency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbReferenceCurrency value of '<xsl:value-of select="swbReferenceCurrency"/>' must equal Trade Currency of '<xsl:value-of select="$tradeCurrency"/>'.</text>
</error>
</xsl:if>
<xsl:if test="swbFxFixingDate and swbReferenceCurrency='BRL'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbFxFixingSchedule must be given for swbReferenceCurrency value of '<xsl:value-of select="swbReferenceCurrency"/>'.</text>
</error>
</xsl:if>
<xsl:if test="swbFxFixingSchedule and swbReferenceCurrency!='BRL'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbFxFixingSchedule must not be given when swbReferenceCurrency value is not 'BRL'.</text>
</error>
</xsl:if>
<xsl:apply-templates select="swbFxFixingDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="swbFxFixingSchedule">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="swbFxFixingSchedule">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
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
<xsl:template match="swbFxFixingDate ">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
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
<xsl:if test="count(.//swbPaymentDatesReference[@href])  != 2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of swbPaymentDatesReference elements encountered. 2 expected.</text>
</error>
</xsl:if>
<xsl:if test="swbDateRelativeToCalculationPeriodDates">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected element swbDateRelativeToCalculationPeriodDates encountered.</text>
</error>
</xsl:if>
<xsl:variable name="href1">
<xsl:value-of select="substring-after(swbDateRelativeToPaymentDates/swbPaymentDatesReference[position()=1]/@href,'#')"/>
</xsl:variable>
<xsl:variable name="href2">
<xsl:value-of select="substring-after(swbDateRelativeToPaymentDates/swbPaymentDatesReference[position()=2]/@href,'#')"/>
</xsl:variable>
<xsl:variable name="fixedId">
<xsl:value-of select="/SWBML/swbStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$fixedLeg]/paymentDates/@id"/>
</xsl:variable>
<xsl:variable name="floatingId">
<xsl:value-of select="/SWBML/swbStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$floatingLeg]/paymentDates/@id"/>
</xsl:variable>
<xsl:if test="($href1!=$fixedId) and ($href1!=$floatingId)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid swbPaymentDatesReference/@href value. Value is not equal to ../paymentDates/@id. Value of href = &#x2018;<xsl:value-of select="$href1"/>' and id values are &#x2018;<xsl:value-of select="$fixedId"/>&#x2019; and &#x2018;<xsl:value-of select="$floatingId"/>&#x2019;.</text>
</error>
</xsl:if>
<xsl:if test="($href2!=$fixedId) and ($href2!=$floatingId)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid swbPaymentDatesReference/@href value. Value is not equal to ../paymentDates/@id. Value of href = &#x2018;<xsl:value-of select="$href2"/>' and id values are &#x2018;<xsl:value-of select="$fixedId"/>&#x2019; and &#x2018;<xsl:value-of select="$floatingId"/>'.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template name="isValidNonDeliverableDateAdjustments">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
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
<xsl:template match="swbFutureValue">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
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
<xsl:apply-templates select="swbNotionalFutureValue">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="swbNotionalFutureValue">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="href">
<xsl:value-of select="substring-after(@href,'#')"/>
</xsl:variable>
<xsl:variable name="id">
<xsl:value-of select="/SWBML/swbStructuredTradeDetails/FpML/trade//swap/swapStream[position()=$fixedLeg]/calculationPeriodAmount/calculation/notionalSchedule/@id"/>
</xsl:variable>
<xsl:if test="($href!=$id)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid swNotionalFutureValue/@href value. Value is not equal to ../calculationPeriodAmount/calculation/notionalSchedule/@id. Value of href = &#x2018;<xsl:value-of select="$href"/>' and id value is &#x2018;<xsl:value-of select="$id"/>&#x2019;.</text>
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
<text>*** swbNotionalFutureValue/currency must be the same as the trade currency. Value = '<xsl:value-of select="$notionalFutureValueCurrency"/>'.</text>
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
<xsl:template match="swbProductTerm">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
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
<xsl:if test="$period='W'">
<xsl:variable name="periodMultiplier">
<xsl:value-of select="periodMultiplier"/>
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
<xsl:value-of select="periodMultiplier"/>
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
<xsl:value-of select="periodMultiplier"/>
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
<xsl:template match="swbEarlyTerminationProvision">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:apply-templates select="swbMandatoryEarlyTerminationDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="swbOptionalEarlyTermination">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="swbMandatoryEarlyTerminationDate">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
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
<xsl:variable name="period">
<xsl:value-of select="period"/>
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
<text>*** swbMandatoryEarlyTerminationDate must be equal to 1D, 6M, 1Y, 2Y, 3Y, 4Y, 5Y, 6Y, 7Y, 8Y, 9Y, 10Y, 11Y, 12Y, 15Y, 20Y, 25Y or 30Y. Value = '<xsl:value-of select="$freq"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template match="unadjustedDate">
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
<xsl:template match="swbOptionalEarlyTermination">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/ <xsl:value-of select="local-name()"/></xsl:variable>
<xsl:apply-templates select="swbOptionalEarlyTerminationDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="swbOptionalEarlyTerminationFrequency">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="swbOptionalEarlyTerminationDate">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/ <xsl:value-of select="local-name()"/></xsl:variable>
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
<xsl:variable name="period">
<xsl:value-of select="period"/>
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
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbOptionalEarlyTerminationDate must be equal to 1D, 6M, 1Y, 2Y, 3Y, 4Y, 5Y, 6Y, 7Y, 8Y, 9Y, 10Y, 11Y, 12Y, 15Y, 20Y, 25Y or 30Y. Value = '<xsl:value-of select="$freq"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template match="swbOptionalEarlyTerminationFrequency">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/ <xsl:value-of select="local-name()"/></xsl:variable>
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
<xsl:template match="swbAssociatedBonds">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">swbExchangeBonds</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="swbExchangeBonds"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="swbNegotiatedSpreadRate">
<xsl:variable name="swbNegotiatedSpreadRate">
<xsl:value-of select="swbNegotiatedSpreadRate"/>
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
<xsl:variable name="countBondDetails">
<xsl:value-of select="count(swbBondDetails)"/>
</xsl:variable>
<xsl:if test="not($countBondDetails=1 or $countBondDetails=2)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of swbBondDetails child elements encountered. 1 or 2 expected. <xsl:value-of select="$countBondDetails"/> found."</text>
</error>
</xsl:if>
<xsl:variable name="swbExchangeBonds">
<xsl:value-of select="swbExchangeBonds"/>
</xsl:variable>
<xsl:if test="swbBondDetails">
<xsl:if test="$swbExchangeBonds='false'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbExchangeBonds must be equal to 'true' if swbBondDetails child elements are present.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$swbExchangeBonds='true'">
<xsl:if test="not(swbBondDetails)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing element. swbBondDetails child elements must be present if swbExchangeBonds is equal to 'true'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="swbBondDetails">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="swbAssociatedFuture">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:variable name="href1">
<xsl:value-of select="./@href"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$href1='#partyA'"/>
<xsl:when test="$href1='#partyB'"/>
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
<xsl:value-of select="swbFutureName"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="isValidIntegerNumber">
<xsl:with-param name="elementName">swbQuantity</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="swbQuantity"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">999999999</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:choose>
<xsl:when test="$tradeCurrency = 'AUD' or $tradeCurrency = 'NZD'">
<xsl:if test="swbDescription =''">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***swbDescription cannot be empty when currency is AUD or NZD.</text>
</error>
</xsl:if>
<xsl:if test="swbFutureName = 'Bill' and not(swbDescription[.='Mar' or .='Jun' or .='Sep' or .='Dec'])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***swbDescription must be either Mar, Jun, Sep or Dec when swbFutureName is Bill.</text>
</error>
</xsl:if>
<xsl:if test="swbFutureName = 'Bond' and not(swbDescription[.='3 year' or .='5 year' or .='10 year'])">
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
<xsl:value-of select="swbMaturity"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:otherwise>
</xsl:choose>
<xsl:choose>
<xsl:when test="swbFutureName = 'Schatz' or swbFutureName = 'Bobl'">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swbPrice</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="swbPrice"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.01</xsl:with-param>
<xsl:with-param name="maxIncl">999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:when>
<xsl:when test="$tradeCurrency = 'AUD' or $tradeCurrency = 'NZD'">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swbPrice</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="swbPrice"/>
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
<xsl:value-of select="swbPrice"/>
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
<xsl:template match="swbBondDetails">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:if test="swbBondId">
<xsl:call-template name="isValidBondId">
<xsl:with-param name="elementName">swbBondId</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="swbBondId"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:variable name="swbBondName">
<xsl:value-of select="swbBondName"/>
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
<xsl:value-of select="swbBondFaceAmount"/>
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
<xsl:call-template name="isValidPriceType">
<xsl:with-param name="elementName">swbPriceType</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="swbPriceType"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:variable name="swbPriceType">
<xsl:value-of select="swbPriceType"/>
</xsl:variable>
<xsl:if test="$tradeCurrency ='USD'">
<xsl:if test="$swbPriceType !='F128' and $swbPriceType !='F256'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbPriceType must be equal to 'F128' or 'F256' if trade currency is equal to 'USD'. Value = '<xsl:value-of select="$swbPriceType"/>'.</text>
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
<xsl:value-of select="swbBondPrice"/>
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
<xsl:template match="swbCollateralizedCashPrice">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
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
<xsl:template match="tradeHeader">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="count(partyTradeIdentifier)!=2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of partyTradeIdentifier child elements encountered. Exactly 2 expected.</text>
</error>
</xsl:if>
<xsl:variable name="tradeId1">
<xsl:value-of select="partyTradeIdentifier[position()=1]/tradeId"/>
</xsl:variable>
<xsl:variable name="tradeId2">
<xsl:value-of select="partyTradeIdentifier[position()=2]/tradeId"/>
</xsl:variable>
<xsl:if test="$version='1-0'">
<xsl:if test="$tradeId1 != $tradeId2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** partyTradeIdentifier[1] and partyTradeIdentifier[2] tradeId do not match.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$version='1-0'">
<xsl:variable name="tradeId3">
<xsl:value-of select="/SWBML/swbHeader/swbBrokerTradeId"/>
</xsl:variable>
<xsl:if test="$tradeId1 != $tradeId3">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** tradeId in partyTradeIdentifier element does not match swbBrokerTradeId in swbHeader.</text>
</error>
</xsl:if>
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
<xsl:apply-templates select="partyTradeIdentifier">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="partyTradeIdentifier">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:variable name="href">
<xsl:value-of select="partyReference/@href"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$href='#partyA'"/>
<xsl:when test="$href='#partyB'"/>
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
<xsl:value-of select="tradeId"/>
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
<xsl:template match="product">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:apply-templates select="swap">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fra">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="swap">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="not($productType='SingleCurrencyInterestRateSwap' or $productType='OIS' or $productType='Swaption')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** /SWBML/swbStructuredTradeDetails/swbProductType must be equal to 'SingleCurrencyInterestRateSwap', 'OIS' or 'Swaption' if swap element is present.</text>
</error>
</xsl:if>
<xsl:if test="($productType = 'SingleCurrencyInterestRateSwap' or $productType='OIS') and $isZeroCouponInterestRateSwap = 'false'">
<xsl:variable name="dt1"><xsl:value-of select="swapStream[position()=$fixedLeg]/calculationPeriodDates/firstRegularPeriodStartDate"/></xsl:variable>
<xsl:variable name="dt2"><xsl:value-of select="swapStream[position()=$floatingLeg]/calculationPeriodDates/firstRegularPeriodStartDate"/></xsl:variable>
<xsl:variable name="rollconv"><xsl:value-of select="swapStream[position()=$fixedLeg]/calculationPeriodDates/calculationPeriodFrequency/rollConvention"/></xsl:variable>
<xsl:if test="$dt1 != $dt2 and ($dt1 != '' and $dt2 != '') and  starts-with($rollconv,'IMM') and $frontandbackstub='true'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** 1st Fixed Reg Period Start and 1st Float Reg Period Start must be same while using different IMM date from its original IMM start date.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$productType='IRS'">
<xsl:variable name="floatingRateIndex">
<xsl:value-of select="//swapStream[position()=$floatingLeg]/calculationPeriodAmount/calculation/floatingRateCalculation/floatingRateIndex"/>
</xsl:variable>
<xsl:variable name="contractualDefinition">
<xsl:value-of select="//swbStructuredTradeDetails/swbExtendedTradeDetails/swbTradeHeader/swbContractualDefinitions"/>
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
<xsl:if test="count(swapStream)!=2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of swapStream child elements encountered. Exactly 2 expected.</text>
</error>
</xsl:if>
<xsl:if test="not(swapStream[@id='fixedLeg'])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** One swapStream must have a swapStream/@id attribute value of 'fixedLeg'.</text>
</error>
</xsl:if>
<xsl:if test="not(swapStream[@id='floatingLeg'])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** One swapStream must have a swapStream/@id attribute value of 'floatingLeg'.</text>
</error>
</xsl:if>
<xsl:if test="not(swapStream[@id='floatingLeg']/resetDates)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The floating swapStream is missing the resetDates element.</text>
</error>
</xsl:if>
<xsl:if test="not(swapStream[@id='floatingLeg']/calculationPeriodAmount/calculation/floatingRateCalculation)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The floating swapStream is missing calculationPeriodAmount/calculation/floatingRateCalculation element.</text>
</error>
</xsl:if>
<xsl:if test="swapStream[@id='fixedLeg']/resetDates">
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
<xsl:variable name="effectiveDate1">
<xsl:value-of select="swapStream[position()=1]/calculationPeriodDates/effectiveDate/unadjustedDate"/>
</xsl:variable>
<xsl:variable name="effectiveDate2">
<xsl:value-of select="swapStream[position()=2]/calculationPeriodDates/effectiveDate/unadjustedDate"/>
</xsl:variable>
<xsl:if test="not ($productType='SingleCurrencyInterestRateSwap' or $productType='OIS' or $productType='Single Currency Basis Swap' or $productType='Cross Currency IRS' or $productType='Fixed Fixed Swap')">
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
<text>*** swapStream[1] and swapStream[2] terminationDate do not match.</text>
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
<xsl:variable name="notional">
<xsl:value-of select="swapStream[position()=$floatingLeg]/calculationPeriodAmount/calculation/notionalSchedule/notionalStepSchedule/initialValue"/>
</xsl:variable>
<xsl:variable name="fixedAmount">
<xsl:value-of select="swapStream[position()=$fixedLeg]/calculationPeriodAmount/knownAmountSchedule/initialValue"/>
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
<xsl:if test="$busCenters5!= $busCenters6 and $productType!='SingleCurrencyInterestRateSwap' and $productType!='OIS'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swapStream[1] and swapStream[2] paymentDates/paymentDatesAdjustments/businessCenters do not match.</text>
</error>
</xsl:if>
<xsl:variable name="fixedAdjustment">
<xsl:value-of select="swapStream[@id='fixedLeg']/calculationPeriodDates/calculationPeriodDatesAdjustments/businessDayConvention"/>
</xsl:variable>
<xsl:if test="$fixedAdjustment != 'NONE'">
<xsl:variable name="busCenters7">
<xsl:for-each select="swapStream[position()=1]/calculationPeriodDates/calculationPeriodDatesAdjustments/businessCenters/businessCenter">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:variable>
<xsl:variable name="busCenters8">
<xsl:for-each select="swapStream[position()=2]/calculationPeriodDates/calculationPeriodDatesAdjustments/businessCenters/businessCenter">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:variable>
<xsl:if test="$busCenters7!= $busCenters8 and swapStream[position()=$floatingLeg]/calculationPeriodDates/calculationPeriodDatesAdjustments/businessDayConvention!='NONE' and $productType!='SingleCurrencyInterestRateSwap' and $productType!='OIS'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swapStream[1] and swapStream[2] calculationPeriodDates/calculationPeriodDatesAdjustments/businessCenters do not match.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:variable name="periodMultiplier1">
<xsl:value-of select="swapStream[@id='floatingLeg']/calculationPeriodDates/calculationPeriodFrequency/periodMultiplier"/>
</xsl:variable>
<xsl:variable name="periodMultiplier2">
<xsl:value-of select="swapStream[@id='floatingLeg']/resetDates/resetFrequency/periodMultiplier"/>
</xsl:variable>
<xsl:variable name="periodMultiplier3">
<xsl:value-of select="swapStream[@id='floatingLeg']/calculationPeriodAmount/calculation/floatingRateCalculation/indexTenor/periodMultiplier"/>
</xsl:variable>
<xsl:variable name="periodMultiplier6">
<xsl:value-of select="swapStream[@id='floatingLeg']/paymentDates/paymentFrequency/periodMultiplier"/>
</xsl:variable>
<xsl:variable name="periodMultiplier4">
<xsl:value-of select="swapStream[@id='fixedLeg']/calculationPeriodDates/calculationPeriodFrequency/periodMultiplier"/>
</xsl:variable>
<xsl:variable name="periodMultiplier5">
<xsl:value-of select="swapStream[@id='fixedLeg']/paymentDates/paymentFrequency/periodMultiplier"/>
</xsl:variable>
<xsl:variable name="period1">
<xsl:value-of select="swapStream[@id='floatingLeg']/calculationPeriodDates/calculationPeriodFrequency/period"/>
</xsl:variable>
<xsl:variable name="period2">
<xsl:value-of select="swapStream[@id='floatingLeg']/resetDates/resetFrequency/period"/>
</xsl:variable>
<xsl:variable name="period3">
<xsl:value-of select="swapStream[@id='floatingLeg']/calculationPeriodAmount/calculation/floatingRateCalculation/indexTenor/period"/>
</xsl:variable>
<xsl:variable name="period6">
<xsl:value-of select="swapStream[@id='floatingLeg']/paymentDates/paymentFrequency/period"/>
</xsl:variable>
<xsl:variable name="period4">
<xsl:value-of select="swapStream[@id='fixedLeg']/calculationPeriodDates/calculationPeriodFrequency/period"/>
</xsl:variable>
<xsl:variable name="period5">
<xsl:value-of select="swapStream[@id='fixedLeg']/paymentDates/paymentFrequency/period"/>
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
<text>*** The fixed swapStream calculationPeriodFrequency/period and paymentFrequency/period  do not match.</text>
</error>
</xsl:if>
<xsl:variable name="businessDayConvention1">
<xsl:value-of select="swapStream[@id='floatingLeg']/calculationPeriodDates/calculationPeriodDatesAdjustments/businessDayConvention"/>
</xsl:variable>
<xsl:variable name="businessDayConvention2">
<xsl:value-of select="swapStream[@id='floatingLeg']/paymentDates/paymentDatesAdjustments/businessDayConvention"/>
</xsl:variable>
<xsl:variable name="businessDayConvention3">
<xsl:value-of select="swapStream[@id='floatingLeg']/resetDates/resetDatesAdjustments/businessDayConvention"/>
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
<text>*** The floating swapStream calculationPeriodDatesAdjustments/businessDayConvention and resetDatesAdjustments/businessDayConvention do not match.</text>
</error>
</xsl:if>
</xsl:when>
<xsl:otherwise>
<xsl:if test="not(($businessDayConvention1 = $businessDayConvention2) and ($businessDayConvention1 = $businessDayConvention3))">
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
<xsl:value-of select="swapStream[@id='floatingLeg']/calculationPeriodDates/calculationPeriodFrequency/periodMultiplier"/>
<xsl:value-of select="swapStream[@id='floatingLeg']/calculationPeriodDates/calculationPeriodFrequency/period"/>
<xsl:value-of select="swapStream[@id='floatingLeg']/paymentDates/paymentFrequency/periodMultiplier"/>
<xsl:value-of select="swapStream[@id='floatingLeg']/paymentDates/paymentFrequency/period"/>
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
<text>*** The floating swapStream calculationPeriodDates/calculationPeriodFrequency and paymentDates/paymentFrequency combination is invalid, for a product type of 'SingleCurrencyInterestRateSwap' or 'Swaption' with OIS indices, with a Zero Coupon floating leg.</text>
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
<xsl:choose>
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
</xsl:choose>
<xsl:variable name="fixedCalcFreq">
<xsl:value-of select="swapStream[@id='fixedLeg']/calculationPeriodDates/calculationPeriodFrequency/periodMultiplier"/>
<xsl:value-of select="swapStream[@id='fixedLeg']/calculationPeriodDates/calculationPeriodFrequency/period"/>
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
<text>*** The fixed swapStream calculationPeriodFrequency must be equal to 1T if product type is 'SingleCurrencyInterestRateSwap' or 'Swaption' with OIS indices and a Zero Coupon IRS / Swaption. Value = '<xsl:value-of select="$fixedCalcFreq"/>'.</text>
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
<xsl:variable name="fixedPayFreq">
<xsl:value-of select="swapStream[@id='fixedLeg']/paymentDates/paymentFrequency/periodMultiplier"/>
<xsl:value-of select="swapStream[@id='fixedLeg']/paymentDates/paymentFrequency/period"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$isZeroCouponInterestRateSwap != 'true'">
<xsl:if test="$productType='SingleCurrencyInterestRateSwap' or $productType='CapFloor' or $productType='Swaption'">
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
<text>*** The fixed swapstream paymentFrequency must be equal to 28D, 1M, 3M, 6M or 1Y if product type is 'SingleCurrencyInterestRateSwap' (except Zero Coupon IRS), 'CapFloor' or 'Swaption'. Value = '<xsl:value-of select="$fixedPayFreq"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:when>
<xsl:when test="$isZeroCouponInterestRateSwap = 'true'">
<xsl:if test="$productType='SingleCurrencyInterestRateSwap' or $isOISonSwaption='true'">
<xsl:choose>
<xsl:when test="$fixedPayFreq='1T'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The fixed swapStream paymentFrequency must be equal to 1T if product type is 'SingleCurrencyInterestRateSwap' or 'Swaption' with OIS indices and a Zero Coupon IRS / Swaption. Value = '<xsl:value-of select="$fixedPayFreq"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:when>
</xsl:choose>
<xsl:variable name="rollConvention">
<xsl:value-of select="swapStream[@id='floatingLeg']/calculationPeriodDates/calculationPeriodFrequency/rollConvention"/>
</xsl:variable>
<xsl:if test="starts-with($rollConvention,'IMM') and $productType!='SingleCurrencyInterestRateSwap' and $productType!='OIS'">
<xsl:if test="/SWBML/swbStructuredTradeDetails/swbExtendedTradeDetails/swbStubPosition">
<xsl:variable name="stubPosition">
<xsl:value-of select="/SWBML/swbStructuredTradeDetails/swbExtendedTradeDetails/swbStubPosition"/>
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
<xsl:if test="($productType='SingleCurrencyInterestRateSwap' or $productType='OIS') and //swbExtendedTradeDetails/swbFrontAndBackStubs">
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
<xsl:if test="$firstFixedRegularPeriodStartDate !='' and not($isZeroCouponInterestRateSwap) and number(substring($firstFixedRegularPeriodStartDate,9))!=number($rollConvention) and not (substring($firstFixedRegularPeriodStartDate,6,2) ='02' and number($rollConvention) &gt;=29)">
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
<xsl:if test="$firstFixedPaymentDate !='' and not($isZeroCouponInterestRateSwap) and number(substring($firstFixedPaymentDate,9))!=number($rollConvention) and not (substring($firstFixedPaymentDate,6,2) ='02' and number($rollConvention) &gt;=29)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Fixed leg paymentDates/firstPaymentDate must fall on same day of month as rollConvention.  Value = '<xsl:value-of select="$firstFixedPaymentDate"/>'.  RollConvention = '<xsl:value-of select="$rollConvention"/>'.</text>
</error>
</xsl:if>
<xsl:if test="$firstFloatPaymentDate !='' and $interestRateSwapFloatingLegType='aNonZCIRSFloatingLeg' and number(substring($firstFloatPaymentDate,9))!=number($rollConvention) and not (substring($firstFloatPaymentDate,6,2) ='02' and number($rollConvention) &gt;=29)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Floating leg paymentDates/firstPaymentDate must fall on same day of month as rollConvention.  Value = '<xsl:value-of select="$firstFloatPaymentDate"/>'.  RollConvention = '<xsl:value-of select="$rollConvention"/>'.</text>
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
<xsl:if test="additionalPayment">
<xsl:if test="not($productType='SingleCurrencyInterestRateSwap' or $productType='OIS')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** additionalPayment is only allowed in this context if product type is 'SingleCurrencyInterestRateSwap' or 'OIS'.</text>
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
<xsl:apply-templates select="additionalPayment">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="additionalPayment">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:variable name="href1">
<xsl:value-of select="payerPartyReference/@href"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$href1='#partyA'"/>
<xsl:when test="$href1='#partyB'"/>
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
<xsl:value-of select="receiverPartyReference/@href"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$href2='#partyA'"/>
<xsl:when test="$href2='#partyB'"/>
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
<text>*** payerPartyReference/@href and receiverPartyReference/@href values are the same.</text>
</error>
</xsl:if>
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
<xsl:with-param name="maxIncl">999999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="$productType='CapFloor'">
<xsl:if test="paymentAmount/currency!=../capFloorStream/calculationPeriodAmount/calculation/notionalSchedule/notionalStepSchedule/currency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** paymentAmount/currency (premium currency) and ../capFloorStream/calculationPeriodAmount/calculation/notionalSchedule/notionalStepSchedule/currency (cap/floor currency) must be the same if product type is 'CapFloor'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$productType='CapFloor' and paymentDate/dateAdjustments[businessDayConvention!='FOLLOWING']">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** paymentDate/dateAdjustments/businessDayConvention must be equal to 'FOLLOWING' if product type is 'CapFloor'. Value = '<xsl:value-of select="paymentDate/dateAdjustments/businessDayConvention"/>'.</text>
</error>
</xsl:if>
<xsl:if test="$productType='CapFloor'">
<xsl:variable name="premiumPaymentBusCenters">
<xsl:for-each select="paymentDate/dateAdjustments/businessCenters/businessCenter">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:variable>
<xsl:variable name="capFloorPaymentBusCenters">
<xsl:for-each select="../capFloorStream/paymentDates/paymentDatesAdjustments/businessCenters/businessCenter">
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
</xsl:if>
<xsl:variable name="paymentType">
<xsl:value-of select="paymentType"/>
</xsl:variable>
<xsl:if test="$productType='CapFloor' and $paymentType!='Premium'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** paymentType must equal 'Premium' if product type is 'CapFloor'. Value = '<xsl:value-of select="$paymentType"/>'</text>
</error>
</xsl:if>
<xsl:if test="string-length($paymentType) &gt; 40">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid paymentType string length. Exceeded max length of 40 characters.</text>
</error>
</xsl:if>
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
<xsl:if test="paymentDate and $paymentTypeDesc = 'Independent Amount'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected paymentDate. Not allowed if paymentType equals 'Independent Amount'.</text>
</error>
</xsl:if>
<xsl:if test="paymentDate">
<xsl:variable name="tradeDate">
<xsl:value-of select="/SWBML/swbStructuredTradeDetails/FpML/trade/tradeHeader/tradeDate"/>
</xsl:variable>
<xsl:variable name="trdDate">
<xsl:value-of select="number(concat(substring($tradeDate,1,4),substring($tradeDate,6,2),substring($tradeDate,9,2)))"/>
</xsl:variable>
<xsl:variable name="paymentDate">
<xsl:value-of select="paymentDate/unadjustedDate"/>
</xsl:variable>
<xsl:variable name="payDate">
<xsl:value-of select="number(concat(substring($paymentDate,1,4),substring($paymentDate,6,2),substring($paymentDate,9,2)))"/>
</xsl:variable>
<xsl:if test="$payDate &lt; $trdDate and not($productType='CapFloor' or $productType='Swaption')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The payment date (paymentDate/unadjustedDate) must be greater than or equal to the tradeDate.  Value = '<xsl:value-of select="paymentDate/unadjustedDate"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="paymentDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="capFloor">
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
<xsl:value-of select="capFloorStream/calculationPeriodDates/effectiveDate/unadjustedDate"/>
</xsl:variable>
<xsl:variable name="tradeDate">
<xsl:value-of select="/SWBML/swbStructuredTradeDetails/FpML/trade/tradeHeader/tradeDate"/>
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
<xsl:if test="count(additionalPayment) &gt; 1">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of additionalPayment child elements encountered. 0 or 1 expected.</text>
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
<xsl:apply-templates select="additionalPayment">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="capFloorStream">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="href1">
<xsl:value-of select="payerPartyReference/@href"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$href1='#partyA'"/>
<xsl:when test="$href1='#partyB'"/>
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
<xsl:value-of select="receiverPartyReference/@href"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$href2='#partyA'"/>
<xsl:when test="$href2='#partyB'"/>
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
<xsl:when test="$businessDayConvention1='NONE'">
<xsl:if test="not($businessDayConvention3 = 'NONE')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The calculationPeriodDatesAdjustments/businessDayConvention and resetDatesAdjustments/businessDayConvention do not match.</text>
</error>
</xsl:if>
</xsl:when>
<xsl:otherwise>
<xsl:if test="not(($businessDayConvention1 = $businessDayConvention2) and ($businessDayConvention1 = $businessDayConvention3))">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The calculationPeriodDatesAdjustments/businessDayConvention, paymentDatesAdjustments/businessDayConvention and resetDatesAdjustments/businessDayConvention do not match.</text>
</error>
</xsl:if>
</xsl:otherwise>
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
<xsl:value-of select="/SWBML/swbStructuredTradeDetails/FpML/trade/tradeHeader/tradeDate"/>
</xsl:variable>
<xsl:variable name="expirationDate">
<xsl:value-of select="europeanExercise/expirationDate/adjustableDate/unadjustedDate"/>
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
<xsl:value-of select="buyerPartyReference/@href"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$href1='#partyA'"/>
<xsl:when test="$href1='#partyB'"/>
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
<xsl:value-of select="sellerPartyReference/@href"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$href2='#partyA'"/>
<xsl:when test="$href2='#partyB'"/>
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
<text>*** buyerPartyReference/@href and sellerPartyReference/@href values are the same.</text>
</error>
</xsl:if>
<xsl:if test="premium">
<xsl:variable name="payer">
<xsl:value-of select="premium/payerPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="receiver">
<xsl:value-of select="premium/receiverPartyReference/@href"/>
</xsl:variable>
<xsl:if test="$href1!=$payer">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** buyerPartyReference/@href (buyer) and premium/payerPartyReference/@href (premium payer) values are not the same.</text>
</error>
</xsl:if>
<xsl:if test="$href2!=$receiver">
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
<xsl:if test="not(calculationAgent/calculationAgentParty) and count(calculationAgentPartyReference) &gt; 2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of calculationAgentPartyReference child elements encountered. 0 to 2 expected.</text>
</error>
</xsl:if>
<xsl:if test="count(calculationAgentPartyReference) = 2">
<xsl:variable name="calAgentParty1">
<xsl:value-of select="substring-after(calculationAgentPartyReference[1]/@href,'#')"/>
</xsl:variable>
<xsl:if test="not($calAgentParty1=substring-after($href1,'#'))">
<xsl:if test="not($calAgentParty1=substring-after($href2,'#'))">
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
<xsl:if test="not($calAgentParty2=substring-after($href1,'#'))">
<xsl:if test="not($calAgentParty2=substring-after($href2,'#'))">
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
<xsl:template match="exerciseProcedure">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
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
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
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
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
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
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
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
<xsl:template match="premium">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="href1">
<xsl:value-of select="payerPartyReference/@href"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$href1='#partyA'"/>
<xsl:when test="$href1='#partyB'"/>
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
<xsl:value-of select="receiverPartyReference/@href"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$href2='#partyA'"/>
<xsl:when test="$href2='#partyB'"/>
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
<xsl:value-of select="/SWBML/swbStructuredTradeDetails/FpML/trade/tradeHeader/tradeDate"/>
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
<xsl:if test="$payDate &lt; $trdDate and not($productType='CapFloor' or $productType='Swaption')">
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
<xsl:template match="europeanExercise">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
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
</xsl:template>
<xsl:template match="expirationDate">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="adjustableDate/dateAdjustments[businessDayConvention!=('FOLLOWING' or 'PRECEDING' or 'MODFOLLOWING')]">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** adjustableDate/dateAdjustments/businessDayConvention must be equal to 'FOLLOWING'.</text>
</error>
</xsl:if>
<xsl:apply-templates select="adjustableDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="adjustableDate">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
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
<xsl:template match="earliestExerciseTime">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
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
<xsl:template match="expirationTime">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
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
<xsl:template match="swapStream">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:variable name="href1">
<xsl:value-of select="payerPartyReference/@href"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$href1='#partyA'"/>
<xsl:when test="$href1='#partyB'"/>
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
<xsl:value-of select="receiverPartyReference/@href"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$href2='#partyA'"/>
<xsl:when test="$href2='#partyB'"/>
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
<text>*** payerPartyReference/@href and receiverPartyReference/@href values are the same.</text>
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
<xsl:template match="party">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:if test="not(partyId)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing partyId.</text>
</error>
</xsl:if>
<xsl:if test="not(string-length(partyId) = string-length(normalize-space(partyId)))">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid partyId element. </text>
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
<xsl:if test="string-length($partyName) &gt; 200">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid partyName string length. Exceeded max length of 200 characters.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="calculationPeriodDates">
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
<xsl:apply-templates select="calculationPeriodFrequency">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="effectiveDate">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
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
<xsl:value-of select="//swapStream[position()=$floatingLeg]/calculationPeriodDates/calculationPeriodDatesAdjustments/businessDayConvention"/>
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
</xsl:template>
<xsl:template match="terminationDate">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="businessDayConvention1">
<xsl:value-of select="dateAdjustments/businessDayConvention"/>
</xsl:variable>
<xsl:if test="//swap">
<xsl:variable name="businessDayConvention2">
<xsl:value-of select="dateAdjustments/businessDayConvention"/>
</xsl:variable>
<xsl:variable name="businessDayConvention3">
<xsl:value-of select="//swapStream[position()=$floatingLeg]/calculationPeriodDates/calculationPeriodDatesAdjustments/businessDayConvention"/>
</xsl:variable>
<xsl:if test="$businessDayConvention2!='NONE'">
<xsl:variable name="busCenters1">
<xsl:for-each select="dateAdjustments/businessCenters/businessCenter">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:variable>
<xsl:variable name="busCenters2">
<xsl:for-each select="//swapStream[@id='floatingLeg']/calculationPeriodDates/calculationPeriodDatesAdjustments/businessCenters/businessCenter">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:variable>
<xsl:if test="$busCenters1!= $busCenters2 and $businessDayConvention3!='NONE' and $productType!='SingleCurrencyInterestRateSwap' and $productType!='OIS'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Under terminationDate, if dateAdjustments/businessDayConvention is not equal to 'NONE' /dateAdjustments/businessCenters must equal floating leg calculationPeriodDates/calculationPeriodDatesAdjustments/businessCenters.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
<xsl:if test="$productType='CapFloor'">
<xsl:variable name="businessDayConvention2">
<xsl:value-of select="//calculationPeriodDatesAdjustments/businessDayConvention"/>
</xsl:variable>
<xsl:if test="$businessDayConvention1!='NONE' and $businessDayConvention2!='NONE'">
<xsl:variable name="busCenters1">
<xsl:for-each select="dateAdjustments/businessCenters/businessCenter">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:variable>
<xsl:variable name="busCenters2">
<xsl:for-each select="../calculationPeriodDatesAdjustments/businessCenters/businessCenter">
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
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
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
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
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
<text>*** calculationPeriodFrequency must be equal to 1M, 3M, 6M,1Y or 1T if product type is 'OIS'. Value = '<xsl:value-of select="$freq"/>'.</text>
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
<xsl:if test=" $productType!='SingleCurrencyInterestRateSwap' and $productType!='OIS'">
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
</xsl:template>
<xsl:template match="dateAdjustments">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
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
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:apply-templates select="businessCenter">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="businessCenter">
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
<xsl:template match="paymentDates">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
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
<xsl:if test="$version='1-0' and paymentDaysOffset">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** paymentDaysOffset must not be present if SWBML version = "1-0".</text>
</error>
</xsl:if>
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
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
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
<text>*** paymentFrequency must be equal to 1M, 3M, 6M,1Y or 1T if product type is 'OIS'. Value = '<xsl:value-of select="$freq"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:template>
<xsl:template match="paymentDaysOffset">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
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
<text>*** period must be equal to 'D'. Value = '<xsl:value-of select="$period"/>'</text>
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
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
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
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
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
<xsl:if test="$FpMLVersion='1-0'">
<xsl:if test="initialFixingDate">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected initialFixingDate child element encountered. Not valid in FpML version = "1-0".</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="initialFixingDate">
<xsl:if test="$productType='CapFloor'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected initialFixingDate child element encountered. Not allowed if product type is 'CapFloor'.</text>
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
<xsl:template match="initialFixingDate">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
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
<xsl:value-of select="../../resetDates/@id"/>
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
<xsl:variable name="initialFixingPeriodMultiplier">
<xsl:for-each select="periodMultiplier">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:variable>
<xsl:variable name="fixingPeriodMultiplier">
<xsl:for-each select="../fixingDates/periodMultiplier">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:variable>
<xsl:variable name="initialFixingBusCenters">
<xsl:for-each select="businessCenters/businessCenter">
<xsl:sort select="."/>
<xsl:value-of select="."/>
</xsl:for-each>
</xsl:variable>
<xsl:variable name="fixingBusCenters">
<xsl:for-each select="../fixingDates/businessCenters/businessCenter">
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
<xsl:template match="fixingDates">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
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
<xsl:value-of select="../../resetDates/@id"/>
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
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
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
<xsl:if test="$productType='SingleCurrencyInterestRateSwap' or $productType='CapFloor' or $productType='Swaption'">
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
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** resetFrequency must be equal to 1T (OIS on Swaption), 28D, 1M, 3M, 6M or 1Y if product type is 'SingleCurrencyInterestRateSwap', 'CapFloor' or 'Swaption'. Value = '<xsl:value-of select="$freq"/>'.</text>
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
<text>*** resetFrequency must be equal to  1M, 3M, 6M,1Y or 1T if product type is 'OIS'. Value = '<xsl:value-of select="$freq"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:template>
<xsl:template match="resetDatesAdjustments">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
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
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
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
<xsl:template match="stubCalculationPeriodAmount">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
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
<xsl:if test="initialStub and finalStub and not($productType='SingleCurrencyInterestRateSwap' or $productType='OIS')">
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
<xsl:if test=" ($tradeCurrency = 'AUD') and (((initialStub/floatingRate[1]/floatingRateIndex = 'AUD-RBA Cash Rate' or initialStub/floatingRate[1]/floatingRateIndex = 'AUD-AONIA') and not(initialStub/floatingRate[2]/floatingRateIndex)) or ((finalStub/floatingRate[1]/floatingRateIndex = 'AUD-RBA Cash Rate' or finalStub/floatingRate[1]/floatingRateIndex = 'AUD-AONIA') and not(finalStub/floatingRate[2]/floatingRateIndex)))">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text> *** stub floatingRateIndex[1] value of 'AUD-RBA Cash Rate' or 'AUD-AONIA' is not valid without stub floatingRateIndex[2]. Linear interpolation is required.</text>
</error>
</xsl:if>
<xsl:if test=" ($tradeCurrency = 'NZD') and (((initialStub/floatingRate[1]/floatingRateIndex = 'NZD-RBNZ OCR' or initialStub/floatingRate[1]/floatingRateIndex = 'NZD-NZIONA') and not(initialStub/floatingRate[2]/floatingRateIndex)) or ((finalStub/floatingRate[1]/floatingRateIndex = 'NZD-RBNZ OCR' or finalStub/floatingRate[1]/floatingRateIndex = 'NZD-NZIONA') and not(finalStub/floatingRate[2]/floatingRateIndex)))">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text> *** stub floatingRateIndex[1] value of 'NZD-RBNZ OCR' or 'NZD-NZIONA' is not valid without stub floatingRateIndex[2]. Linear interpolation is required.</text>
</error>
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
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]
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
<xsl:if test="../../../stubCalculationPeriodAmount">
<xsl:variable name="floatingRateIndex2">
<xsl:choose>
<xsl:when test="$productType='ZC Inflation Swap'">
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
<xsl:if test="$tradeCurrency != 'PLN' and not($productType='ZC Inflation Swap')">
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
<xsl:template match="knownAmountSchedule">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
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
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
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
<xsl:when test="($productType='CapFloor')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** compoundingMethod must not be present if product type is 'CapFloor'.</text>
</error>
</xsl:when>
<xsl:when test="not(../../resetDates)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** compoundingMethod must only exist on floating stream.</text>
</error>
</xsl:when>
<xsl:when test="compoundingMethod = 'SpreadExclusive' and //swbExtendedTradeDetails/swbContractualDefinitions = 'ISDA2000'">
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
<xsl:if test="not($productType='CapFloor')">
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
</xsl:if>
<xsl:apply-templates select="notionalSchedule">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="$productType='CapFloor'">
<xsl:if test="fixedRateSchedule">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** fixedRateSchedule must not be present if product type is 'CapFloor'.</text>
</error>
</xsl:if>
</xsl:if>
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
<xsl:template match="calculationAgent">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="parent::trade and not($productType='SingleCurrencyInterestRateSwap' and $tradeCurrency='BRL')">
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
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
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
<xsl:template match="notionalSchedule">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:apply-templates select="notionalStepSchedule">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="notionalStepSchedule">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
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
</xsl:template>
<xsl:template match="fixedRateSchedule">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
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
</xsl:template>
<xsl:template match="floatingRateCalculation">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
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
<xsl:if test="$productType='CapFloor' or $productType='Swaption'">
<xsl:if test="initialRate">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** initialRate must not be present if product type is 'CapFloor' or 'Swaption'.</text>
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
<xsl:if test="$productType!='CapFloor'">
<xsl:if test="capRateSchedule">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected capRateSchedule element encountered in this context. capRateSchedule must only be present if product type is 'CapFloor'.</text>
</error>
</xsl:if>
<xsl:if test="floorRateSchedule">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected floorRateSchedule element encountered in this context. floorRateSchedule must only be present if product type is 'CapFloor'.</text>
</error>
</xsl:if>
</xsl:if>
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
<xsl:apply-templates select="spreadSchedule">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="indexTenor">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
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
<xsl:if test="($productType='SingleCurrencyInterestRateSwap' or $productType='Swaption') and not(parent::floatingRate)">
<xsl:variable name="indexTenor">
<xsl:value-of select="periodMultiplier"/>
<xsl:value-of select="period"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$indexTenor='28D'"/>
<xsl:when test="$indexTenor='1M'"/>
<xsl:when test="$indexTenor='3M'"/>
<xsl:when test="$indexTenor='6M'"/>
<xsl:when test="$indexTenor='1Y'"/>
<xsl:when test="$indexTenor='1W' and $tradeCurrency='CNY'"/>
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
<xsl:template match="capRateSchedule">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">initialValue</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="initialValue"/>
</xsl:with-param>
<xsl:with-param name="minIncl">-9.99999999</xsl:with-param>
<xsl:with-param name="maxIncl">9.99999999</xsl:with-param>
<xsl:with-param name="maxDecs">8</xsl:with-param>
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
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
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
<xsl:template mode="FRA" match="indexTenor">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
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
</xsl:template>
<xsl:template match="spreadSchedule">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
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
</xsl:template>
<xsl:template match="otherPartyPayment">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:variable name="href1">
<xsl:value-of select="payerPartyReference/@href"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$href1='#partyA'"/>
<xsl:when test="$href1='#partyB'"/>
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
<xsl:value-of select="receiverPartyReference/@href"/>
</xsl:variable>
<xsl:if test="$href2='#partyA' or $href2='#partyB'">
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
<text>*** payerPartyReference/@href and receiverPartyReference/@href values are the same.</text>
</error>
</xsl:if>
<xsl:if test="not(/SWBML/swbStructuredTradeDetails/FpML/trade/party[@id=substring-after($href2,'#')])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The receiverPartyReference/@href value does not match an id value for any party. Value = '<xsl:value-of select="$href2"/>'.</text>
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
<xsl:with-param name="minIncl">0.00</xsl:with-param>
<xsl:with-param name="maxIncl">999999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="paymentDate">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected paymentDate element encountered in this context. Not expected for brokerage payment.</text>
</error>
</xsl:if>
<xsl:if test="paymentType">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected paymentType element encountered in this context. Not expected for brokerage payment.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="settlementRateSource">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:apply-templates select="informationSource">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="informationSource">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
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
<xsl:template match="cashSettlementReferenceBanks">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
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
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
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
<xsl:value-of select="buyerPartyReference/@href"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$href1='#partyA'"/>
<xsl:when test="$href1='#partyB'"/>
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
<xsl:value-of select="sellerPartyReference/@href"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$href2='#partyA'"/>
<xsl:when test="$href2='#partyB'"/>
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
<text>*** buyerPartyReference/@href and sellerPartyReference/@href values are the same.</text>
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
<xsl:apply-templates select="indexTenor" mode="FRA">
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
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
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
<xsl:template match="fixingDateOffset">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
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
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
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
<xsl:template name="isValidBondId">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/>. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
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
<xsl:if test="$elementValue!='AsSpecifiedInMasterAgreement'">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:if>
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
<xsl:when test="$elementValue='INR'"/>
<xsl:when test="$elementValue='JPY'"/>
<xsl:when test="$elementValue='NOK'"/>
<xsl:when test="$elementValue='NZD'"/>
<xsl:when test="$elementValue='PLN'"/>
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
<xsl:if test="$productType='SingleCurrencyInterestRateSwap' or $productType='OIS' or $productType='CapFloor' or $productType='Swaption'">
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
<xsl:when test="(($elementValue='BUS/252') and ($tradeCurrency='BRL') and ($productType='SingleCurrencyInterestRateSwap'))"/>
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
<xsl:when test="(($elementValue='BUS/252') and ($tradeCurrency='BRL') and ($productType='SingleCurrencyInterestRateSwap'))"/>
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
<xsl:template name="isValidPartyRef">
<xsl:param name="elementName"/>
<xsl:param name="attributeName"/>
<xsl:param name="attributeValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/>/@<xsl:value-of select="$attributeName"/> attribute value. Value = '<xsl:value-of select="$attributeValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$attributeValue='#partyA'"/>
<xsl:when test="$attributeValue='#partyB'"/>
<xsl:when test="$attributeValue='#broker'"/>
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
<xsl:template name="isValidPeriodMultiplier">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/>. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="not(contains($elementValue,'.'))">
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
<xsl:if test="$productType='SingleCurrencyInterestRateSwap' or $productType='CapFloor' or $productType='Swaption'">
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
<xsl:if test="not($productType='OIS')">
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
</xsl:if>
<xsl:if test="$productType='OIS'">
<xsl:choose>
<xsl:when test="$elementValue='NONE'"/>
<xsl:when test="$elementValue='EOM'"/>
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
</xsl:if>
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
<xsl:template match="swbStubLength">
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
<xsl:if test="not(//FpML/trade//capFloor/capFloorStream[@id=substring-after($href,'#')])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbStubLength[<xsl:number value="position()"/>]/@href does not reference a valid //FpML/trade//capFloor/capFloorStream/@id. Value = '<xsl:value-of select="$href"/>'.</text>
</error>
</xsl:if>
</xsl:when>
<xsl:otherwise>
<xsl:if test="not(//FpML/trade//swap/swapStream[@id=substring-after($href,'#')])">
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
<xsl:when test="$elementValue='10:00:00'"/>
<xsl:when test="$elementValue='10:30:00'"/>
<xsl:when test="$elementValue='11:00:00'"/>
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
<xsl:template match="swbMandatoryClearing">
<xsl:param name="context"/>
<xsl:if test="swbMandatoryClearingIndicator">
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">swbMandatoryClearingIndicator</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="swbMandatoryClearingIndicator"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$context"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:for-each select="swbPartyExemption/swbExemption">
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
<xsl:if test="swbPartyExemption[position()=1]/swbPartyReference/@href = swbPartyExemption[position()=2]/swbPartyReference/@href">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** swbPartyExemption cannot be provided twice for the same party for the same clearing jurisdiction</text>
</error>
</xsl:if>
<xsl:if test="current()[swbJurisdiction/text()!='DoddFrank'][swbSupervisoryBodyCategory]">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** swbSupervisoryBodyCategory not supported for '<xsl:value-of select="swbJurisdiction"/>' clearing</text>
</error>
</xsl:if>
<xsl:if test="current()[contains(';ASIC;JFSA;MAS;', concat(';', swbJurisdiction/text(),';'))][swbPartyExemption]">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** swbPartyExemption cannot be provided for '<xsl:value-of select="swbJurisdiction"/>'</text>
</error>
</xsl:if>
<xsl:if test="not(contains(';ASIC;CAN;ESMA;FCA;HKMA;JFSA;DoddFrank;MIFID;MAS;', concat(';', swbJurisdiction/text(),';')))">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** This value:'<xsl:value-of select="swbJurisdiction"/>' of swbJurisdiction is not in supported list for mandatory clearing - Permitted values: ASIC;CAN;ESMA;FCA;HKMA;JFSA;DoddFrank;MIFID;MAS. </text>
</error>
</xsl:if>
<xsl:if test="current()[swbJurisdiction/text()='DoddFrank'][not(swbSupervisoryBodyCategory='BroadBased')]">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** Invalid value: swbSupervisoryBodyCategory not in supported list. Value='<xsl:value-of select="swbSupervisoryBodyCategory/text()"/>'.</text>
</error>
</xsl:if>
<xsl:choose>
<xsl:when test="current()[swbJurisdiction/text()='JFSA']">
<xsl:variable name="MandatoryClearingIndicator">
<xsl:value-of select="/SWBML/swbLongFormTrade/swbStructuredTradeDetails//swbExtendedTradeDetails/swbTradeHeader/swbMandatoryClearing[swJurisdiction/text()='JFSA']/swbMandatoryClearingIndicator"/>
</xsl:variable>
<xsl:if test="$productType='IRS'">
<xsl:variable name="floatingRateIndex">
<xsl:value-of select="/SWBML/swbLongFormTrade/swbStructuredTradeDetails//FpML/trade//swap/swapStream[position()=$floatingLeg]/calculationPeriodAmount/calculation/floatingRateCalculation/floatingRateIndex"/>
</xsl:variable>
<xsl:variable name="FloatingRollFreq">
<xsl:value-of select="/SWBML/swbLongFormTrade/swbStructuredTradeDetails//FpML/trade//swap/swapStream[position()=$floatingLeg]/calculationPeriodDates/calculationPeriodFrequency/periodMultiplier"/>
<xsl:value-of select="/SWBML/swbLongFormTrade/swbStructuredTradeDetails//FpML/trade//swap/swapStream[position()=$floatingLeg]/calculationPeriodDates/calculationPeriodFrequency/period"/>
</xsl:variable>
<xsl:if test="($MandatoryClearingIndicator='true' or $MandatoryClearingIndicator='false') and $productType='IRS'">
<xsl:if test="not($productType='IRS' and $tradeCurrency='JPY' and ($floatingRateIndex='JPY-LIBOR-BBA' or $floatingRateIndex='JPY-LIBOR') and ($FloatingRollFreq='3M' or $FloatingRollFreq='6M') )">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** For JFSA, swbMandatoryClearingIndicator can only be set for an IRS where the trade currency is JPY, Floating Rate Index is JPY-LIBOR-BBA/JPY-LIBOR and the Floating Roll Frequency is either 3M or 6M</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
<xsl:if test="$productType='Single Currency Basis Swap'">
<xsl:variable name="floatingRateIndex1">
<xsl:value-of select="/SWBML/swbLongFormTrade/swbStructuredTradeDetails//FpML/trade//swap/swapStream[position()=$floatingLeg]/calculationPeriodAmount/calculation/floatingRateCalculation/floatingRateIndex"/>
</xsl:variable>
<xsl:variable name="floatingRateIndex2">
<xsl:value-of select="/SWBML/swbLongFormTrade/swbStructuredTradeDetails//FpML/trade//swap/swapStream[position()=$floatingLeg2]/calculationPeriodAmount/calculation/floatingRateCalculation/floatingRateIndex"/>
</xsl:variable>
<xsl:variable name="DesignatedMaturity1">
<xsl:value-of select="/SWBML/swbLongFormTrade/swbStructuredTradeDetails//FpML/trade//swap/swapStream[position()=$floatingLeg]/calculationPeriodAmount/calculation/floatingRateCalculation/indexTenor/periodMultiplier"/>
<xsl:value-of select="/SWBML/swbLongFormTrade/swbStructuredTradeDetails//FpML/trade//swap/swapStream[position()=$floatingLeg]/calculationPeriodAmount/calculation/floatingRateCalculation/indexTenor/period"/>
</xsl:variable>
<xsl:variable name="DesignatedMaturity2">
<xsl:value-of select="/SWBML/swbLongFormTrade/swbStructuredTradeDetails//FpML/trade//swap/swapStream[position()=$floatingLeg2]/calculationPeriodAmount/calculation/floatingRateCalculation/indexTenor/periodMultiplier"/>
<xsl:value-of select="/SWBML/swbLongFormTrade/swbStructuredTradeDetails//FpML/trade//swap/swapStream[position()=$floatingLeg2]/calculationPeriodAmount/calculation/floatingRateCalculation/indexTenor/period"/>
</xsl:variable>
<xsl:if test="($MandatoryClearingIndicator='true' or $MandatoryClearingIndicator='false') and $productType='Single Currency Basis Swap'">
<xsl:if test="not($productType='Single Currency Basis Swap' and $tradeCurrency='JPY' and ($floatingRateIndex1='JPY-LIBOR-BBA' or $floatingRateIndex1='JPY-LIBOR') and ($floatingRateIndex2='JPY-LIBOR-BBA' or $floatingRateIndex2='JPY-LIBOR') and ($DesignatedMaturity1='3M' or $DesignatedMaturity1='6M') and ($DesignatedMaturity2='3M' or $DesignatedMaturity2='6M'))">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** For JFSA, swbMandatoryClearingIndicator can only be set for a Single Currency Basis Swap where the trade currency is JPY, Floating Rate Index 1 is JPY-LIBOR-BBA/JPY-LIBOR, Floating Rate Index 2 is JPY-LIBOR-BBA/JPY-LIBOR, Designated Maturity 1 is either 3M or 6M and Designated Maturity 2 is either 3M or 6M</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
</xsl:when>
<xsl:otherwise>
<xsl:if test="/SWBML/swbTradeEventReportingDetails/swbReportingRegimeInformation[swbJurisdiction/text()=current()/swbJurisdiction/text()]/swbMandatoryClearingIndicator">
<xsl:if test="not(/SWBML/swbTradeEventReportingDetails/swbReportingRegimeInformation[swbJurisdiction/text()=current()/swbJurisdiction/text()]/swbMandatoryClearingIndicator = current()/swbMandatoryClearingIndicator)">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** Different values have been specified for swbMandatoryClearingIndicator in reporting and clearing sections for jurisdiction '<xsl:value-of select="Jurisdiction"/>'.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:otherwise>
</xsl:choose>
<xsl:if test="current()[swbInterAffiliateExemption]">
<xsl:if test="not(current()[swbJurisdiction/text()='DoddFrank'])">
<xsl:if test="not(current()[swbSupervisoryBodyCategory/text()='BroadBased'])">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** May only provide a value for swbInterAffiliateExemption under CFTC (swbJurisdiction='DoddFrank' and swbSupervisoryBodyCategory='BroadBased'), value of '<xsl:value-of select="swbInterAffiliateExemption"/>' has been provided under jurisdiction '<xsl:value-of select="swbJurisdiction"/>'.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
</xsl:template>
<xsl:template match="swbBusinessConductDetails">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:apply-templates select="swbMidMarketPrice">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="swbMidMarketPrice">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="swbUnit">
<xsl:choose>
<xsl:when test="swbUnit/text()='Price'"/>
<xsl:when test="swbUnit/text()='BasisPoints'"/>
<xsl:when test="swbUnit/text()='Percentage'"/>
<xsl:when test="swbUnit/text()='Level'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** Invalid value submitted for <xsl:value-of select="local-name()"/>/swbUnit Value = '<xsl:value-of select="swbUnit/text()"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test=" swbAmount and (string(number(swbAmount/text())) ='NaN' or contains(swbAmount/text(),'e') or contains(swbAmount/text(),'E'))">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** Invalid value submitted for <xsl:value-of select="local-name()"/>/swbAmount Value = '<xsl:value-of select="swbAmount/text()"/>'.</text>
</error>
</xsl:if>
<xsl:call-template name="isValidMidMarketAmount">
<xsl:with-param name="elementName">swbAmount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="swbAmount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">-9999999999.99999999</xsl:with-param>
<xsl:with-param name="maxIncl">9999999999.99999999</xsl:with-param>
<xsl:with-param name="maxDecs">8</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="not(string-length(swbUnit) &gt; 0) and (swbCurrency or swbAmount)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***Mid-Market Price Type is required.</text>
</error>
</xsl:if>
<xsl:if test="string-length(swbUnit) &gt; 0 and not (swbCurrency) and not (swbAmount)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***Mid-Market Price Value is required.</text>
</error>
</xsl:if>
<xsl:if test="swbUnit/text() = 'Price' and  swbCurrency and not(swbAmount)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***Mid-Market Price Value is required.</text>
</error>
</xsl:if>
<xsl:if test="not(swbUnit/text() = 'Price') and string-length(swbUnit) &gt; 0 and string-length(swbCurrency) &gt; 0">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***Mid-Market Price Currency not allowed for type.</text>
</error>
</xsl:if>
<xsl:if test=" swbUnit/text()= 'Price' and swbAmount and not(string-length(swbCurrency) &gt; 0)">
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
<xsl:template match="swbTradePackageHeader">
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
<xsl:when test="swbPackageIdentifier">
<xsl:choose>
<xsl:when test="swbPackageIdentifier/swbIssuer"/>
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
<xsl:when test="swbPackageIdentifier/swbTradeId"/>
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
<xsl:when test="swbSize"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swbSize.</text>
</error>
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="swbPackageIdentifier">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="swbSize">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="swbPartyCreditAcceptanceToken">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="swbPackageIdentifier">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:apply-templates select="swbIssuer">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="swbTradeId">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="swbIssuer">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
</xsl:template>
<xsl:template match="swbTradeId">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
</xsl:template>
<xsl:template match="swbSize">
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
<xsl:template match="swbPartyCreditAcceptanceToken">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
</xsl:template>
</xsl:stylesheet>
