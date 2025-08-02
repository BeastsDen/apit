<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fpml="http://www.fpml.org/2010/FpML-4-9" exclude-result-prefixes="fpml common" version="1.0" xmlns:common="http://exslt.org/common">
<xsl:import href="CrossAssetValidation.xsl"/>
<xsl:import href="swbml-validation-reporting.xsl"/>
<xsl:variable name="version">
<xsl:value-of select="/fpml:SWBML/@version"/>
</xsl:variable>
<xsl:variable name="assetClass">Equities</xsl:variable>
<xsl:variable name="productType">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:swbProductType"/>
</xsl:variable>
<xsl:variable name="FpMLVersion">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/@version"/>
</xsl:variable>
<xsl:variable name="docsType">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:brokerConfirmation/fpml:brokerConfirmationType"/>
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:contractualMatrix/fpml:matrixTerm"/>
</xsl:variable>
<xsl:variable name="isEMEAOption">
<xsl:choose>
<xsl:when test="$docsType='Equity Options (EMEA)'">true</xsl:when>
<xsl:when test="$docsType='ISDA2010EquityEMEAInterdealer' and ($productType = 'Equity Share Option' or $productType = 'Equity Index Option' or $productType = 'Equity Share Option Strategy' or $productType = 'Equity Index Option Strategy')">true</xsl:when>
<xsl:when test="$docsType='EquityOptionEMEAPrivate' and ($productType = 'Equity Share Option' or $productType = 'Equity Index Option' or $productType = 'Equity Share Option Strategy' or $productType = 'Equity Index Option Strategy')">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="isEuropeOption">
<xsl:choose>
<xsl:when test="$docsType='Equity Options (Europe)'and ($productType = 'Equity Share Option' or $productType = 'Equity Index Option' or $productType = 'Equity Share Option Strategy' or $productType = 'Equity Index Option Strategy')">true</xsl:when>
<xsl:when test="$docsType='2004EquityEuropeanInterdealer'and ($productType = 'Equity Share Option' or $productType = 'Equity Index Option' or $productType = 'Equity Share Option Strategy' or $productType = 'Equity Index Option Strategy')">true</xsl:when>
<xsl:when test="$docsType='ISDA2007EquityEuropean'and ($productType = 'Equity Share Option' or $productType = 'Equity Index Option' or $productType = 'Equity Share Option Strategy' or $productType = 'Equity Index Option Strategy')">true</xsl:when>
<xsl:when test="$docsType='EquityOptionEuropePrivate'and ($productType = 'Equity Share Option' or $productType = 'Equity Index Option' or $productType = 'Equity Share Option Strategy' or $productType = 'Equity Index Option Strategy')">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="docsTypeEqSwap">
<xsl:choose>
<xsl:when test="$docsType = 'ISDA2007EquityFinanceSwapEuropean'">Equity Swap (Europe)</xsl:when>
<xsl:when test="$docsType = 'ISDA2007EquityEuropean' and ($productType = 'Equity Share Swap' or $productType = 'Equity Index Swap') ">Equity Swap (Europe)</xsl:when>
<xsl:when test="$docsType = 'EquitySwapEuropePrivate' ">Equity Swap (Europe)</xsl:when>
<xsl:when test="$docsType = 'EmergingEquitySwapIndustry' and ($productType = 'Equity Index Swap' or $productType = 'Equity Share Swap')">Equity Swap (Emerging)</xsl:when>
<xsl:when test="$docsType = 'EmergingEquitySwapLATAM' and ($productType = 'Equity Index Swap' or $productType = 'Equity Share Swap')">Equity Swap (Emerging)</xsl:when>
<xsl:when test="$docsType = 'EmergingEquitySwapEMEA' and ($productType = 'Equity Index Swap' or $productType = 'Equity Share Swap')">Equity Swap (Emerging)</xsl:when>
<xsl:when test="$docsType = 'ISDA2009EquityEuropeanInterdealer' ">Equity Swap (Europe)</xsl:when>
<xsl:when test="$docsType = 'EquitySwapAEJPrivate' ">Equity Swap (AEJ)</xsl:when>
<xsl:when test="$docsType = 'ISDA2005EquitySwapAsiaExcludingJapanInterdealer' ">Equity Swap (AEJ)</xsl:when>
<xsl:when test="$docsType = 'ISDA2008EquityFinanceSwapAsiaExcludingJapan' ">Equity Swap (AEJ)</xsl:when>
<xsl:when test="$docsType = 'ISDA2009EquityFinanceSwapAsiaExcludingJapan' ">Equity Swap (AEJ)</xsl:when>
<xsl:when test="$docsType = 'EquitySwapAmericasPrivate' ">Equity Swap (Americas)</xsl:when>
<xsl:when test="$docsType = 'ISDA2004EquityAmericasInterdealer' and ($productType = 'Equity Share Swap' or $productType = 'Equity Index Swap')">Equity Swap (Americas)</xsl:when>
<xsl:when test="$docsType = 'ISDA2009EquitySwapAmericas' ">Equity Swap (Americas)</xsl:when>
<xsl:when test="$docsType = 'EquitySwapPanAsiaPrivate' ">Equity Swap (Pan Asia)</xsl:when>
<xsl:when test="$docsType = 'ISDA2009EquitySwapPanAsia' ">Equity Swap (Pan Asia)</xsl:when>
<xsl:when test="$docsType = 'EquitySwapGlobalPrivate' ">Equity Swap (Global)</xsl:when>
<xsl:when test="$docsType = 'ISDA2010FairValueShareSwapEuropeanInterdealer' ">Equity Swap (Europe)</xsl:when>
<xsl:when test="$docsType = 'VolatilitySwapAsiaExcludingJapanPrivate' ">Volatility Swap (AEJ)</xsl:when>
<xsl:when test="$docsType = 'VolatilitySwapAmericasPrivate' ">Volatility Swap (Americas)</xsl:when>
<xsl:when test="$docsType = 'VolatilitySwapEuropeanPrivate' ">Volatility Swap (Europe)</xsl:when>
<xsl:when test="$docsType = 'VolatilitySwapJapanesePrivate' ">Volatility Swap (Japan)</xsl:when>
<xsl:when test="$docsType = 'IVS1OpenMarkets' ">Volatility Swap (Open Markets)</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="docsSubType">
<xsl:choose>
<xsl:when test="$docsType = 'ISDA2007EquityFinanceSwapEuropean'">2007 ISDA</xsl:when>
<xsl:when test="$docsType = 'ISDA2007EquityEuropean' and ($productType = 'Equity Share Swap' or $productType = 'Equity Index Swap') ">2007 ISDA</xsl:when>
<xsl:when test="$docsType = 'EquitySwapEuropePrivate' ">Private</xsl:when>
<xsl:when test="$docsType = 'ISDA2009EquityEuropeanInterdealer' ">2009 ISDA</xsl:when>
<xsl:when test="$docsType = 'EquitySwapAEJPrivate' ">Private</xsl:when>
<xsl:when test="$docsType = 'ISDA2005EquitySwapAsiaExcludingJapanInterdealer' ">2005 ISDA</xsl:when>
<xsl:when test="$docsType = 'ISDA2008EquityFinanceSwapAsiaExcludingJapan' ">2008 ISDA</xsl:when>
<xsl:when test="$docsType = 'ISDA2009EquityFinanceSwapAsiaExcludingJapan' ">2009 ISDA</xsl:when>
<xsl:when test="$docsType = 'EquitySwapAmericasPrivate' ">Private</xsl:when>
<xsl:when test="$docsType = 'ISDA2004EquityAmericasInterdealer' and ($productType = 'Equity Share Swap' or $productType = 'Equity Index Swap')">2004 ISDA</xsl:when>
<xsl:when test="$docsType = 'ISDA2009EquitySwapAmericas' ">Private</xsl:when>
<xsl:when test="$docsType = 'EquitySwapPanAsiaPrivate' ">Private</xsl:when>
<xsl:when test="$docsType = 'ISDA2009EquitySwapPanAsia' ">2009 ISDA</xsl:when>
<xsl:when test="$docsType = 'EquitySwapGlobalPrivate' ">Private</xsl:when>
<xsl:when test="$docsType = 'ISDA2010FairValueShareSwapEuropeanInterdealer' ">2009 ISDA (FVSS)</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
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
<xsl:variable name="reportingData.rtf">
<xsl:apply-templates select="/fpml:SWBML/fpml:swbTradeEventReportingDetails/node()" mode="mapReportingData"/>
<xsl:apply-templates select="/fpml:SWBML/fpml:swbPrivatePartyTradeEventReportingDetails/node()" mode="mapReportingData"/>
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
<xsl:if test="not($version='4-9')">
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
<xsl:apply-templates select="fpml:swbAllocations">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:swbComplianceElection/fpml:rule15A-6 and not($productType = 'Equity Share Option' or $productType = 'Equity Index Option' or $productType = 'Equity Share Option Universal' or $productType = 'Equity Index Option Universal')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** rule15A-6 must not be present when the product is not an Equity Option.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swbPrivatePartyTradeEventReportingDetails/fpml:swbPartyReportingRegimeInformation/fpml:swbLargeSizeTrade">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbLargeSizeTrade must not be present for equities products.</text>
</error>
</xsl:if>
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
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
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
<xsl:if test="count(fpml:swbRecipient) != 2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of swbRecipient child elements encountered. Exactly 2 expected (<xsl:value-of select="count(fpml:swbRecipient)"/> found).</text>
</error>
</xsl:if>
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
<text>*** swbRecipient[1]/partyReference/@href and swbRecipient[2]/partyReference/@href values are the same.</text>
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
<text>*** Empty swbBrokerTradeId element.</text>
</error>
</xsl:if>
<xsl:if test="string-length($swbBrokerTradeId) &gt; 50">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid swbBrokerTradeId element value length. Exceeded max length of 50 characters.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swbTotalLegs">
<xsl:variable name="swbTotalLegs">
<xsl:value-of select="fpml:swbTotalLegs"/>
</xsl:variable>
<xsl:if test="$swbTotalLegs=''">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Empty swbTotalLegs element, required if a strategy trade.</text>
</error>
</xsl:if>
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
<xsl:if test="fpml:swbStrategyType">
<xsl:call-template name="isValidStrategyType">
<xsl:with-param name="elementName">swbStrategyType</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swbStrategyType"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swbStrategyType">
<xsl:variable name="swbBrokerLegId">
<xsl:value-of select="fpml:swbBrokerLegId"/>
</xsl:variable>
<xsl:if test="$swbBrokerLegId=''">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Empty swbBrokerLegId element, required if a strategy trade.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swbStrategyType">
<xsl:if test="fpml:swbStrategyType = 'Butterfly' or fpml:swbStrategyType = 'Option with Synthetic Fwd'">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swbTotalLegs</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swbTotalLegs"/>
</xsl:with-param>
<xsl:with-param name="minIncl">1</xsl:with-param>
<xsl:with-param name="maxIncl">3</xsl:with-param>
<xsl:with-param name="maxDecs">0</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swbStrategyType = 'Calendar Spread' or fpml:swbStrategyType = 'Risk Reversal' or fpml:swbStrategyType = 'Ratio Spread' or fpml:swbStrategyType = 'Spread' or fpml:swbStrategyType = 'Straddle' or fpml:swbStrategyType = 'Strangle' or fpml:swbStrategyType = 'Synthetic Underlying'">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swbTotalLegs</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swbTotalLegs"/>
</xsl:with-param>
<xsl:with-param name="minIncl">1</xsl:with-param>
<xsl:with-param name="maxIncl">2</xsl:with-param>
<xsl:with-param name="maxDecs">0</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swbStrategyType = 'Custom' or fpml:swbStrategyType = 'Synthetic Roll'">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swbTotalLegs</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swbTotalLegs"/>
</xsl:with-param>
<xsl:with-param name="minIncl">1</xsl:with-param>
<xsl:with-param name="maxIncl">4</xsl:with-param>
<xsl:with-param name="maxDecs">0</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:swbStrategyType">
<xsl:variable name="LegTotal">
<xsl:value-of select="fpml:swbTotalLegs"/>
</xsl:variable>
<xsl:variable name="LegId">
<xsl:value-of select="fpml:swbBrokerLegId"/>
</xsl:variable>
<xsl:if test="number($LegId) &gt; number($LegTotal)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Leg ID is too great for this strategy type.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:variable name="swbStrategyComment">
<xsl:value-of select="fpml:swbStrategyComment"/>
</xsl:variable>
<xsl:if test="string-length($swbStrategyComment) &gt; 2000">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid swbStrategyComment element value length. Exceeded max length of 2000 characters.</text>
</error>
</xsl:if>
<xsl:variable name="LegId">
<xsl:value-of select="fpml:swbBrokerLegId"/>
</xsl:variable>
<xsl:if test="number($LegId) &gt; 1 and fpml:swbStrategyComment">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid swbStrategyComment element. Comments can only be submitted on Leg One of a Strategy Trade.</text>
</error>
</xsl:if>
<xsl:if test="number($LegId) &gt; 1 and //fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:collateral">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected collateral element.  Independent Amount can only be submitted on Leg One of a Strategy Trade.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swbStrategyType">
<xsl:if test="number($LegId) &gt; 1 and //fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbMessageText">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid swbMessageText element. Messages can only be submitted on Leg One of a Strategy Trade.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="//fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:strike/fpml:strikeDeterminationDate">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected forward starting elements encountered in this context. Forward Starting options are not supported for strategies in this release.</text>
</error>
</xsl:if>
<xsl:if test="//fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:feature/fpml:asian">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected averaging elements encountered in this context. Averaging options are not supported for strategies in this release.</text>
</error>
</xsl:if>
<xsl:variable name="OtherPartyAmount">
<xsl:value-of select="//fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:otherPartyPayment/fpml:paymentAmount/fpml:amount"/>
</xsl:variable>
<xsl:if test="number($LegId) &gt; 1 and number($OtherPartyAmount) &gt; 1">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid otherPartyPayment/paymentAmount/amount element. Brokerage with a value greater than zero can only be submitted on Leg One of a Strategy Trade.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:variable name="swbBrokerTradeVersionId">
<xsl:value-of select="fpml:swbBrokerTradeVersionId"/>
</xsl:variable>
<xsl:if test="$swbBrokerTradeVersionId=''">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Empty swbBrokerTradeVersionId element.</text>
</error>
</xsl:if>
<xsl:variable name="swbTradeSource">
<xsl:value-of select="fpml:swbTradeSource"/>
</xsl:variable>
<xsl:if test="$swbTradeSource=''">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Empty swbTradeSource element.</text>
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
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:variable name="id">
<xsl:value-of select="./@id"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$id != ''"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Empty swbRecipient/@id attribute.</text>
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
<text>*** Invalid swbRecipient/@id attribute value length. Exceeded max length of 40 characters.</text>
</error>
</xsl:if>
<xsl:if test="$productType = 'Equity Share Option' or $productType = 'Equity Index Option'">
<xsl:choose>
<xsl:when test="fpml:partyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:buyerPartyReference/@href"/>
<xsl:when test="fpml:partyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:sellerPartyReference/@href"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid partyReference/@href attribute value. Value = '<xsl:value-of select="fpml:partyReference/@href"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="$productType = 'Share Variance Swap' or $productType = 'Index Variance Swap'">
<xsl:choose>
<xsl:when test="fpml:partyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:buyerPartyReference/@href"/>
<xsl:when test="fpml:partyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:sellerPartyReference/@href"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid partyReference/@href attribute value. Value = '<xsl:value-of select="fpml:partyReference/@href"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:swbStructuredTradeDetails">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
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
<xsl:if test="not(fpml:swbExtendedTradeDetails/fpml:swbVarianceSwapDetails) and ($productType='Share Variance Swap' or $productType='Index Variance Swap')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swbVarianceSwapDetails element encountered in this context. Element must be present if product type is 'Share Variance Swap' or 'Index Variance Swap'.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:swbExtendedTradeDetails/fpml:swbDispersionVarianceSwapDetails) and ($productType='Dispersion Variance Swap')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swbDispersionVarianceSwapDetails element encountered in this context. Element must be present if product type is 'Dispersion Variance Swap'.</text>
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
</xsl:template>
<xsl:template match="fpml:FpML">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="not($FpMLVersion='4-9')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid version attribute. Value = '<xsl:value-of select="$FpMLVersion"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:trade)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing trade element.</text>
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
<xsl:if test="not(count(fpml:party)=3 or count(fpml:party)=4)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of party child elements encountered. 3 or 4 expected (<xsl:value-of select="count(fpml:party)"/> found).</text>
</error>
</xsl:if>
<xsl:if test="fpml:validation">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected validation element encountered in this context.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:trade">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:portfolio">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected portfolio element encountered in this context.</text>
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
</xsl:template>
<xsl:template match="fpml:trade">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
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
<xsl:if test="$productType='Equity Share Option' or $productType='Equity Index Option'">
<xsl:if test="not(fpml:equityOptionTransactionSupplement)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing equityOptionTransactionSupplement element. Element must be present if product type is 'Equity Share Option' or 'Equity Index Option'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$productType='Share Variance Swap' or $productType='Index Variance Swap' or $productType='Equity Share Swap' or $productType='Equity Index Swap' ">
<xsl:if test="not(fpml:equitySwapTransactionSupplement)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing equitySwapTransactionSupplement element. Element must be present if product type is 'Share Variance Swap' or 'Index Variance Swap' or 'Equity Share Swap' or 'Equity Index Swap'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$productType='Dispersion Variance Swap'">
<xsl:if test="not(fpml:varianceSwapTransactionSupplement)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing varianceSwapTransactionSupplement element. Element must be present if product type is 'Dispersion Variance Swap'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:equityOptionTransactionSupplement|fpml:equitySwapTransactionSupplement|fpml:dividendSwapTransactionSupplement|fpml:varianceSwapTransactionSupplement|fpml:swVolatilitySwapTransactionSupplement">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:otherPartyPayment">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="not(fpml:brokerPartyReference)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing brokerPartyReference element.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:brokerPartyReference">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="not($productType='Equity Share Swap' or $productType='Equity Index Swap')">
<xsl:if test="fpml:calculationAgent">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected calculationAgent element encountered in this context.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:calculationAgentBusinessCenter">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected calculationAgentBusinessCenter element encountered in this context.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:collateral">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="not(fpml:documentation)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing documentation element.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:documentation">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:governingLaw">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected governingLaw element encountered in this context.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:brokerPartyReference">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:variable name="broker">
<xsl:value-of select="@href"/>
</xsl:variable>
<xsl:if test="not(/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:party[@id=$broker])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The brokerPartyReference/@href value does not match an //FpML/party/@id value for any party. Value = '<xsl:value-of select="$broker"/>'.</text>
</error>
</xsl:if>
<xsl:if test="$productType='Equity Share Option' or $productType='Equity Index Option'">
<xsl:choose>
<xsl:when test="$broker=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:buyerPartyReference/@href">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid brokerPartyReference/@href attribute value. Value = '<xsl:value-of select="$broker"/>'.</text>
</error>
</xsl:when>
<xsl:when test="$broker=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:sellerPartyReference/@href">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid brokerPartyReference/@href attribute value. Value = '<xsl:value-of select="$broker"/>'.</text>
</error>
</xsl:when>
<xsl:otherwise/>
</xsl:choose>
</xsl:if>
<xsl:if test="$productType='Share Variance Swap' or $productType='Index Variance Swap'">
<xsl:choose>
<xsl:when test="$broker=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:buyerPartyReference/@href">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid brokerPartyReference/@href attribute value. Value = '<xsl:value-of select="$broker"/>'.</text>
</error>
</xsl:when>
<xsl:when test="$broker=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:sellerPartyReference/@href">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid brokerPartyReference/@href attribute value. Value = '<xsl:value-of select="$broker"/>'.</text>
</error>
</xsl:when>
<xsl:otherwise/>
</xsl:choose>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:collateral">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:apply-templates select="fpml:independentAmount">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:independentAmount">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:variable name="payer">
<xsl:value-of select="fpml:payerPartyReference/@href"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$payer='partyA'"/>
<xsl:when test="$payer='partyB'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid payerPartyReference/@href value. Value = '<xsl:value-of select="$payer"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
<xsl:variable name="receiver">
<xsl:value-of select="fpml:receiverPartyReference/@href"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$receiver='partyA'"/>
<xsl:when test="$receiver='partyB'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid receiverPartyReference/@href value. Value = '<xsl:value-of select="$receiver"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
<xsl:if test="$payer=$receiver">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** payerPartyReference/@href and receiverPartyReference/@href values are the same.</text>
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
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="fpml:adjustablePaymentDate">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected adjustablePaymentDate element in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:adjustedPaymentDate">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected adjustedPaymentDate element in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:paymentDate and ($productType = 'Equity Share Swap' or $productType = 'Equity Index Swap') ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected paymentDate element encountered in this context.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:paymentAmount">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:paymentRule">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected paymentRule element in this context.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:documentation">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="fpml:masterAgreement and not ($productType = 'Equity Index Volatility Swap')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected masterAgreement element in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:masterAgreement and not ($productType = 'Equity Index Volatility Swap')">
<xsl:apply-templates select="fpml:masterAgreement">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
<xsl:if test="fpml:contractualMatrix and not ($productType = 'Equity Index Volatility Swap')">
<xsl:apply-templates select="fpml:contractualMatrix">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
<xsl:if test="not(fpml:brokerConfirmation) and not ($productType ='Equity Index Volatility Swap')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing brokerConfirmation element.</text>
</error>
</xsl:if>
<xsl:if test="fpml:contractualDefinitions and not ($productType = 'Equity Index Volatility Swap')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected contractualDefinitions element in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:masterConfirmation">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected masterConfirmation element in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:contractualSupplement">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected contractualSupplement element in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:contractualMatrix and not ($productType = 'Equity Index Volatility Swap')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected contractualMatrix element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:creditSupportDocument">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected creditSupportDocument element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:contractualTermsSupplement and ($productType='Equity Share Swap' or $productType='Equity Index Swap') ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected contractualTermsSupplement element encountered in this context.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:brokerConfirmation">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:brokerConfirmation">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:variable name="brokerConfirmationTypeScheme">
<xsl:value-of select="fpml:brokerConfirmationType/@brokerConfirmationTypeScheme"/>
</xsl:variable>
<xsl:if test="$brokerConfirmationTypeScheme != 'http://www.swapswire.com/spec/2004/broker-confirmation-type-1-0'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or unrecognised brokerConfirmationType/@brokerConfirmationTypeScheme attribute value. Value = '<xsl:value-of select="$brokerConfirmationTypeScheme"/>'.</text>
</error>
</xsl:if>
<xsl:if test="$productType = 'Equity Share Option' or $productType = 'Equity Index Option'">
<xsl:call-template name="isValidEquityConfirmationType">
<xsl:with-param name="elementName">brokerConfirmationType</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:brokerConfirmationType"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="$productType = 'Share Variance Swap' or $productType = 'Index Variance Swap'">
<xsl:call-template name="isValidVarianceSwapConfirmationType">
<xsl:with-param name="elementName">brokerConfirmationType</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:brokerConfirmationType"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="$productType = 'Dispersion Variance Swap'">
<xsl:call-template name="isValidDispersionVarianceSwapConfirmationType">
<xsl:with-param name="elementName">brokerConfirmationType</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:brokerConfirmationType"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="$productType = 'Share Dividend Swap' or $productType = 'Index Dividend Swap'">
<xsl:call-template name="isValidDividendSwapConfirmationType">
<xsl:with-param name="elementName">brokerConfirmationType</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:brokerConfirmationType"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="$productType = 'Equity Share Swap' or $productType = 'Equity Index Swap'">
<xsl:call-template name="isValidEquitySwapConfirmationType">
<xsl:with-param name="elementName">brokerConfirmationType</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:brokerConfirmationType"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:swbExtendedTradeDetails">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
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
<text>***swbOriginatingEvent element value is not supported. Supported values are '', 'Bunched Order Block', 'Bunched Order Allocation'. Value = '<xsl:value-of select="fpml:swbTradeHeader/fpml:swbOriginatingEvent"/>'."/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
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
<xsl:if test="fpml:swbProductTerm">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swbProductTerm element in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swbMessageText">
<xsl:if test="fpml:swbMessageText=''">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Empty swbMessageText element.</text>
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
<xsl:if test="fpml:swbDeltaCross and ($productType='Share Variance Swap' or $productType='Index Variance Swap')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swbDeltaCross element encountered in this context. Element must not be present if product type is 'Share Variance Swap' or 'Index Variance Swap'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swbDeltaCross and ($productType='Dispersion Variance Swap')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swbDeltaCross element encountered in this context. Element must not be present if product type is 'Dispersion Variance Swap'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swbIndependentAmountPercentage and /fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:collateral">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** FpML/trade/collateral and swbIndependentAmountPercentage cannot be both present.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swbVarianceSwapDetails and ($productType='Equity Share Option' or $productType='Equity Index Option')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swbVarianceSwapDetails element encountered in this context. Element must not be present if product type is 'Equity Share Option' or 'Equity Index Option'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swbVarianceSwapDetails and ($productType='Dispersion Variance Swap')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swbVarianceSwapDetails element encountered in this context. Element must not be present if product type is 'Dispersion Variance Swap'.</text>
</error>
</xsl:if>
<xsl:choose>
<xsl:when test="fpml:swbDeltaCross and ($productType='Share Dividend Swap' or $productType='Index Dividend Swap')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swbDeltaCross element encountered in this context. Element must not be present if product type is 'Share Dividend Swap' or 'Index Dividend Swap'.</text>
</error>
</xsl:when>
</xsl:choose>
<xsl:if test="fpml:swbVarianceSwapDetails and ($productType='Index Dividend Swap' or $productType='Share Dividend Swap')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swbVarianceSwapDetails element encountered in this context. Element must not be present if product type is 'Index Dividend Swap' or 'Share Dividend Swap'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swbEquityOptionDetails and ($productType='Index Dividend Swap' or $productType='Share Dividend Swap')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swbEquityOptionDetails element encountered in this context. Element must not be present if product type is 'Index Dividend Swap' or 'Share Dividend Swap'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swbEquityOptionDetails and ($productType='Dispersion Variance Swap')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swbEquityOptionDetails element encountered in this context. Element must not be present if product type is 'Dispersion Variance Swap' </text>
</error>
</xsl:if>
<xsl:if test="fpml:swbChinaConnect">
<xsl:if test="not (fpml:swbChinaConnect/fpml:swbShareDisqualification)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Element swbShareDisqualification must be present if swbChinaConnect element is present.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swbChinaConnect/fpml:swbShareDisqualification">
<xsl:call-template name="isValidChinaConnectFieldValue">
<xsl:with-param name="elementName">swbShareDisqualification</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swbChinaConnect/fpml:swbShareDisqualification"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="not (fpml:swbChinaConnect/fpml:swbServiceTermination)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Element swbServiceTermination must be present if swbChinaConnect element is present.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swbChinaConnect/fpml:swbServiceTermination">
<xsl:call-template name="isValidChinaConnectFieldValue">
<xsl:with-param name="elementName">swbServiceTermination</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swbChinaConnect/fpml:swbServiceTermination"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:swbVarianceSwapDetails">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:swbDeltaCross">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:swbEquityOptionDetails">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:swbDividendSwapDetails">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:swbEquitySwapDetails">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:swbDispersionVarianceSwapDetails">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="($productType='Share Dividend Swap' or $productType='Index Dividend Swap') and /fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbIndependentAmountPercentage">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbIndependentAmountPercentage must not be present for Dividend Swaps.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:swbDispersionVarianceSwapDetails">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="count(fpml:swbLegComponentDetails) != count(//fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:varianceSwapTransactionSupplement/fpml:varianceLeg)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of  elements encountered. There must be as many instances of swbLegComponentDetails as there are varianceLegs (<xsl:value-of select="count(fpml:swbLegComponentDetails)"/> found) vs.(<xsl:value-of select="count(//fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:varianceSwapTransactionSupplement/fpml:varianceLeg)"/> found)</text>
</error>
</xsl:if>
<xsl:for-each select="fpml:swbLegComponentDetails">
<xsl:variable name="varid">
<xsl:value-of select="@id"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$varid != ''"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Empty swbLegComponentDetails/@id attribute.</text>
</error>
</xsl:otherwise>
</xsl:choose>
<xsl:if test="not(fpml:volatilityStrikePrice)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing volatilityStrikePrice element in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:volatilityStrikePrice ">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">volatilityStrikePrice</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:volatilityStrikePrice"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.001</xsl:with-param>
<xsl:with-param name="maxIncl">300.000</xsl:with-param>
<xsl:with-param name="maxDecs">3</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swbExpectedNOverride">
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">swbExpectedNOverride</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swbExpectedNOverride"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swbComponentWeighting">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swbComponentWeighting</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swbComponentWeighting"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.001</xsl:with-param>
<xsl:with-param name="maxIncl">100.000</xsl:with-param>
<xsl:with-param name="maxDecs">3</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
</xsl:for-each>
</xsl:template>
<xsl:template match="fpml:swbEquitySwapDetails">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:variable name="optionalEarlyTermination">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:optionalEarlyTermination"/>
</xsl:variable>
<xsl:if test="fpml:swbMultiplier and $docsSubType != 'Private' and ($productType = 'Equity Share Swap' or $productType = 'Equity Index Swap')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbMultiplier is only applicable for Private Master Confirms for Equity Index/Share Swap products.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swbFullyFunded and $docsSubType != 'Private' and ($productType = 'Equity Share Swap' or $productType = 'Equity Index Swap')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swbFullyFunded element encountered in this context. Element must be not present unless docs sub-type is 'Private'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swbSpreadDetails and $docsSubType != 'Private' and ($productType = 'Equity Share Swap' or $productType = 'Equity Index Swap')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swbSpreadDetails element encountered in this context. Element must be not present unless docs sub-type is 'Private'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swbFullyFunded and fpml:swbSpreadDetails">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbFullyFunded and swbSpreadDetails must not co-exist.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swbFullyFunded and not (fpml:swbFullyFunded/fpml:currency = //fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:returnLeg/fpml:amount/fpml:paymentCurrency/fpml:currency)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbFullyFunded/currency must be the same as settlement currency (return leg payment currency).</text>
</error>
</xsl:if>
<xsl:if test="fpml:swbFullyFunded">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">amount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swbFullyFunded/fpml:amount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">-9999999999999.99</xsl:with-param>
<xsl:with-param name="maxIncl">9999999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="$productType = 'Equity Index Swap' and (//fpml:FpML/fpml:trade/fpml:documentation/fpml:brokerConfirmation/fpml:brokerConfirmationType = 'ISDA2009EquitySwapAmericas')">
<xsl:if test="fpml:swbStockLoanRateIndicator = 'true' and not(fpml:swbAdditionalDisruptionEventIndicator = 'true') ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbStockLoanRateIndicator can be 'true' only if swbAdditionalDisruptionEventIndicator is 'true' in this context.</text>
</error>
</xsl:if>
<xsl:if test="//fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:extraordinaryEvents/fpml:additionalDisruptionEvents/fpml:insolvencyFiling = 'true' and not(fpml:swbAdditionalDisruptionEventIndicator = 'true') ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** additionalDisruptionEvents/insolvencyFiling can be 'true' only if swbAdditionalDisruptionEventIndicator is 'true' in this context.</text>
</error>
</xsl:if>
<xsl:if test="//fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:extraordinaryEvents/fpml:additionalDisruptionEvents/fpml:lossOfStockBorrow  = 'true' and not(fpml:swbAdditionalDisruptionEventIndicator = 'true') ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** additionalDisruptionEvents/lossOfStockBorrow can be 'true' only if swbAdditionalDisruptionEventIndicator is 'true' in this context.</text>
</error>
</xsl:if>
<xsl:if test="//fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:extraordinaryEvents/fpml:additionalDisruptionEvents/fpml:increasedCostOfStockBorrow = 'true' and not(fpml:swbAdditionalDisruptionEventIndicator = 'true') ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** additionalDisruptionEvents/increasedCostOfStockBorrow can be 'true' only if swbAdditionalDisruptionEventIndicator is 'true' in this context.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:swbSpreadDetails and not (fpml:swbSpreadDetails/fpml:swbSpreadIn or fpml:swbSpreadDetails/fpml:swbSpreadOut)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** One of swbSpreadIn, swbSpreadOut is mandatory when swbSpreadDetails is present.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swbSpreadDetails/fpml:swbSpreadIn">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">SpreadIn</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swbSpreadDetails/fpml:swbSpreadIn"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">0.0999999</xsl:with-param>
<xsl:with-param name="maxDecs">7</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swbSpreadDetails/fpml:swbSpreadOut">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">SpreadOut</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swbSpreadDetails/fpml:swbSpreadOut"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">0.0999999</xsl:with-param>
<xsl:with-param name="maxDecs">7</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:initialUnits">
<xsl:choose>
<xsl:when test="$docsTypeEqSwap = 'Equity Swap (AEJ)' or $docsTypeEqSwap = 'Equity Swap (Pan Asia)'">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">initialUnits</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:initialUnits"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">9999999999</xsl:with-param>
<xsl:with-param name="maxDecs">0</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:when>
<xsl:when test="$docsTypeEqSwap = 'Equity Swap (Global)' or ($docsTypeEqSwap = 'Equity Swap (Americas)' and $productType = 'Equity Index Swap')">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">initialUnits</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:initialUnits"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">9999999999.99999</xsl:with-param>
<xsl:with-param name="maxDecs">5</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:when>
<xsl:otherwise>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">initialUnits</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:initialUnits"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">99999999.99999</xsl:with-param>
<xsl:with-param name="maxDecs">5</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="fpml:swbBulletIndicator = 'true' and not(fpml:swbInterestLegDriven = 'true') and not(fpml:swbSchedulingMethod = 'ListDateEntry')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** If swbBulletIndicator is 'true', swbInterestLegDriven must be 'true'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swbBulletIndicator = 'true' and fpml:swbSchedulingMethod = 'ListDateEntry'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbBulletIndicator must not be 'true' for 'ListDateEntry' Scheduling Method.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swbBulletIndicator">
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">swbBulletIndicator</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swbBulletIndicator"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swbInterestLegDriven">
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">swbInterestLegDriven</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swbInterestLegDriven"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swbScheduleFrequencies and not(fpml:swbSchedulingMethod = 'ListDateEntry')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swbScheduleFrequencies element encountered in this context. Schedule Frequency parameters can be passed explicitly only if swbSchedulingMethod has a value of 'ListDateEntry' </text>
</error>
</xsl:if>
<xsl:if test="fpml:swbStubControl and (fpml:swbSchedulingMethod = 'ListDateEntry')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swbStubControl element encountered in this context. Stub Control parameters not supported for 'ListDateEntry' mode. </text>
</error>
</xsl:if>
<xsl:if test="fpml:swbSchedulingMethod = 'ListDateEntry' and fpml:swbScheduleFrequencies">
<xsl:apply-templates select="fpml:swbScheduleFrequencies">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
<xsl:if test="not(fpml:swbSchedulingMethod = 'ListDateEntry')">
<xsl:apply-templates select="fpml:swbStubControl">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
<xsl:variable name="swbEarlyFinalValuationDateElectionFieldApplicable">
<xsl:choose>
<xsl:when test="$docsType = 'ISDA2009EquityEuropeanInterdealer' and not($optionalEarlyTermination = 'false')">true</xsl:when>
<xsl:when test="$docsType = 'EmergingEquitySwapIndustry' and not($optionalEarlyTermination = 'false')">true</xsl:when>
<xsl:when test="$docsType = 'EmergingEquitySwapLATAM' and not($optionalEarlyTermination = 'false')">true</xsl:when>
<xsl:when test="$docsType = 'EmergingEquitySwapEMEA' and not($optionalEarlyTermination = 'false')">true</xsl:when>
<xsl:when test="$docsType = 'EquitySwapAmericasPrivate' and not($optionalEarlyTermination = 'false')">true</xsl:when>
<xsl:when test="$docsType = 'ISDA2009EquitySwapAmericas' and not($optionalEarlyTermination = 'false')">true</xsl:when>
<xsl:when test="$docsType = 'EquitySwapAEJPrivate' and not($optionalEarlyTermination = 'false')">true</xsl:when>
<xsl:when test="$docsType = 'EquitySwapEuropePrivate' and not($optionalEarlyTermination = 'false')">true</xsl:when>
<xsl:when test="$docsType = 'ISDA2004EquityAmericasInterdealer' and not($optionalEarlyTermination = 'false')">true</xsl:when>
<xsl:when test="$docsType = 'ISDA2005EquitySwapAsiaExcludingJapanInterdealer' and not($optionalEarlyTermination = 'false')">true</xsl:when>
<xsl:when test="$docsType = 'ISDA2007EquityEuropean' and not($optionalEarlyTermination = 'false')">true</xsl:when>
<xsl:when test="$docsType = 'ISDA2007EquityFinanceSwapEuropean' and not($optionalEarlyTermination = 'false')">true</xsl:when>
<xsl:when test="$docsType = 'ISDA2009EquitySwapPanAsia' and not($optionalEarlyTermination = 'false')">true</xsl:when>
<xsl:when test="$docsType = 'EquitySwapPanAsiaPrivate' and not($optionalEarlyTermination = 'false')">true</xsl:when>
<xsl:when test="$docsType = 'EquitySwapGlobalPrivate' and not($optionalEarlyTermination = 'false')">true</xsl:when>
<xsl:when test="$docsType = 'ISDA2008EquityFinanceSwapAsiaExcludingJapan' and not($optionalEarlyTermination = 'false') and $productType = 'Equity Share Swap'">true</xsl:when>
<xsl:when test="$docsType = 'ISDA2009EquityFinanceSwapAsiaExcludingJapan' and not($optionalEarlyTermination = 'false') and $productType = 'Equity Share Swap'">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:if test="fpml:swbEarlyFinalValuationDateElection and $swbEarlyFinalValuationDateElectionFieldApplicable = 'false' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swbEarlyFinalValuationDateElection element encountered in this context.</text>
</error>
</xsl:if>
<xsl:variable name="swbEarlyTerminationElectingPartyApplicable">
<xsl:choose>
<xsl:when test="$docsType = 'EquitySwapAmericasPrivate' and not($optionalEarlyTermination = 'false')">true</xsl:when>
<xsl:when test="$docsType = 'ISDA2009EquitySwapAmericas' and not($optionalEarlyTermination = 'false')">true</xsl:when>
<xsl:when test="$docsType = 'ISDA2004EquityAmericasInterdealer' and not($optionalEarlyTermination = 'false')">true</xsl:when>
<xsl:when test="$docsType = 'EquitySwapAEJPrivate' and not($optionalEarlyTermination = 'false')">true</xsl:when>
<xsl:when test="$docsType = 'EquitySwapEuropePrivate' and not($optionalEarlyTermination = 'false')">true</xsl:when>
<xsl:when test="$docsType = 'ISDA2007EquityEuropean' and not($optionalEarlyTermination = 'false')">true</xsl:when>
<xsl:when test="$docsType = 'ISDA2007EquityFinanceSwapEuropean' and not($optionalEarlyTermination = 'false')">true</xsl:when>
<xsl:when test="$docsType = 'ISDA2009EquityEuropeanInterdealer' and not($optionalEarlyTermination = 'false')">true</xsl:when>
<xsl:when test="$docsType = 'EmergingEquitySwapIndustry' and not($optionalEarlyTermination = 'false')">true</xsl:when>
<xsl:when test="$docsType = 'EmergingEquitySwapLATAM' and not($optionalEarlyTermination = 'false')">true</xsl:when>
<xsl:when test="$docsType = 'EmergingEquitySwapEMEA' and not($optionalEarlyTermination = 'false')">true</xsl:when>
<xsl:when test="$docsType = 'ISDA2009EquitySwapPanAsia' and not($optionalEarlyTermination = 'false')">true</xsl:when>
<xsl:when test="$docsType = 'EquitySwapPanAsiaPrivate' and not($optionalEarlyTermination = 'false')">true</xsl:when>
<xsl:when test="$docsType = 'EquitySwapGlobalPrivate' and not($optionalEarlyTermination = 'false')">true</xsl:when>
<xsl:when test="$docsType = 'ISDA2005EquitySwapAsiaExcludingJapanInterdealer' and not($optionalEarlyTermination = 'false')">true</xsl:when>
<xsl:when test="$docsType = 'ISDA2008EquityFinanceSwapAsiaExcludingJapan' and not($optionalEarlyTermination = 'false') and $productType = 'Equity Share Swap'">true</xsl:when>
<xsl:when test="$docsType = 'ISDA2009EquityFinanceSwapAsiaExcludingJapan' and not($optionalEarlyTermination = 'false') and $productType = 'Equity Share Swap'">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:if test="(fpml:swbEarlyTerminationElectingParty or fpml:swbEarlyTerminationElectingPartyMethod) and $swbEarlyTerminationElectingPartyApplicable = 'false'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected fpml:swbEarlyTerminationElectingParty or fpml:swbEarlyTerminationElectingPartyMethod element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swbEarlyTerminationElectingParty and $swbEarlyFinalValuationDateElectionFieldApplicable = 'true' ">
<xsl:if test="fpml:swbEarlyTerminationElectingParty[1]/@href = fpml:swbEarlyTerminationElectingParty[2]/@href">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbEarlyTerminationElectingParty[1]/@href and swbEarlyTerminationElectingParty[2]/@href values must not be the same.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:swbBulletCompoundingSpread and not($docsType='EquitySwapAmericasPrivate' or $docsType='EquitySwapAEJPrivate' or $docsType='EquitySwapEuropePrivate' or $docsType='EquitySwapGlobalPrivate')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swbBulletCompoundingSpread element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swbBulletCompoundingSpread">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swbBulletCompoundingSpread</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swbBulletCompoundingSpread"/>
</xsl:with-param>
<xsl:with-param name="minIncl">-9.9999999</xsl:with-param>
<xsl:with-param name="maxIncl">9.9999999</xsl:with-param>
<xsl:with-param name="maxDecs">7</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swbFixedRateIndicator">
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">swbFixedRateIndicator</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swbFixedRateIndicator"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swbOtherValuationBusinessCenter and not($docsType = 'EquitySwapAmericasPrivate')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swbOtherValuationBusinessCenter element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swbReferenceInitialPrice">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swbReferenceInitialPrice</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swbReferenceInitialPrice"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.000001</xsl:with-param>
<xsl:with-param name="maxIncl">9999999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">6</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swbReferenceFXRate">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swbReferenceFXRate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swbReferenceFXRate"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.000001</xsl:with-param>
<xsl:with-param name="maxIncl">99999.999999</xsl:with-param>
<xsl:with-param name="maxDecs">6</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="not(fpml:swbNotionalCurrency) and ($productType = 'Equity Share Swap' or $productType = 'Equity Index Swap') and not(/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:returnLeg/fpml:notional/fpml:notionalAmount/fpml:currency) and /fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:returnLeg/fpml:rateOfReturn/fpml:initialPrice/fpml:determinationMethod">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing element swbNotionalCurrency when Notional is not known for a Forward Starting Swap.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swbNotionalCurrency and ($productType = 'Equity Share Swap' or $productType = 'Equity Index Swap') and /fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:returnLeg/fpml:notional/fpml:notionalAmount/fpml:currency and (fpml:swbNotionalCurrency != /fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:returnLeg/fpml:notional/fpml:notionalAmount/fpml:currency)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbNotionalCurrency "<xsl:value-of select="fpml:swbNotionalCurrency"/>" must equal Equity notionalAmount/currency ''<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:returnLeg/fpml:notional/fpml:notionalAmount/fpml:currency"/>'' when Notional is known for a Forward Starting Swap.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swbFinalPriceFeeAmount and not($docsType = 'EquitySwapGlobalPrivate')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbFinalPriceFeeAmount element not supported by this MCA.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swbFinalPriceFeeAmount and fpml:swbFinalPriceFee">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbFinalPriceFee and swbFinalPriceFeeAmount elements are mutually exclusive.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:swbScheduleFrequencies">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="fpml:swbPaymentDateOffset">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swbPaymentDateOffset</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swbPaymentDateOffset"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">999</xsl:with-param>
<xsl:with-param name="maxDecs">0</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swbFixingDayOffset">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swbFixingDayOffset</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swbFixingDayOffset"/>
</xsl:with-param>
<xsl:with-param name="minIncl">-999</xsl:with-param>
<xsl:with-param name="maxIncl">0</xsl:with-param>
<xsl:with-param name="maxDecs">0</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swbValuationDate">
<xsl:call-template name="isValidPeriodMultiplier">
<xsl:with-param name="elementName">periodMultiplier</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swbValuationDate/fpml:periodMultiplier"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="isValidPeriod">
<xsl:with-param name="elementName">period</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swbValuationDate/fpml:period"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swbCompoundingDate">
<xsl:call-template name="isValidPeriodMultiplier">
<xsl:with-param name="elementName">periodMultiplier</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swbCompoundingDate/fpml:periodMultiplier"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="isValidPeriod">
<xsl:with-param name="elementName">period</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swbCompoundingDate/fpml:period"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swbInterestLegPaymentDate">
<xsl:call-template name="isValidPeriodMultiplier">
<xsl:with-param name="elementName">periodMultiplier</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swbInterestLegPaymentDate/fpml:periodMultiplier"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="isValidPeriod">
<xsl:with-param name="elementName">period</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swbInterestLegPaymentDate/fpml:period"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:rollConvention/returnLeg">
<xsl:call-template name="isValidRollConvention">
<xsl:with-param name="elementName">rollConvention</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:rollConvention/returnLeg"/>
</xsl:with-param>
<xsl:with-param name="rollConvention"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:rollConvention/interestLeg">
<xsl:call-template name="isValidRollConvention">
<xsl:with-param name="elementName">rollConvention</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:rollConvention/interestLeg"/>
</xsl:with-param>
<xsl:with-param name="rollConvention"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:swbStubControl | fpml:stubControl">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="fpml:swbEquityFrontStub">
<xsl:if test="not(fpml:swbEquityFrontStub='Long' or fpml:swbEquityFrontStub='Short') ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid Equity Front Stub value. The value must be 'Long' or 'Short'. Value = '<xsl:value-of select="fpml:swbEquityFrontStub"/>'</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:swbEquityEndStub">
<xsl:if test="not(fpml:swbEquityEndStub='Long' or fpml:swbEquityEndStub='Short') ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid Equity End Stub value. The value must be 'Long' or 'Short'. Value = '<xsl:value-of select="fpml:swbEquityEndStub"/>'</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:swbInterestFrontStub">
<xsl:if test="not(fpml:swbInterestFrontStub='Long' or fpml:swbInterestFrontStub='Short') ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid Interest Front Stub value. The value must be 'Long' or 'Short'. Value = '<xsl:value-of select="fpml:swbInterestFrontStub"/>'</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:swbInterestEndStub">
<xsl:if test="not(fpml:swbInterestEndStub='Long' or fpml:swbInterestEndStub='Short') ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid Interest End Stub value. The value must be 'Long' or 'Short'. Value = '<xsl:value-of select="fpml:swbInterestEndStub"/>'</text>
</error>
</xsl:if>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:swbVarianceSwapDetails">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="not(fpml:volatilityStrikePrice)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing volatilityStrikePrice element in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:volatilityStrikePrice and ($docsType='ISDA2007VarianceSwapAsiaExcludingJapan' or $docsType='ISDA2006VarianceSwapJapaneseInterdealer' or $docsType='ISDA2004EquityAmericasInterdealer')">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">volatilityStrikePrice</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:volatilityStrikePrice"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.001</xsl:with-param>
<xsl:with-param name="maxIncl">300.000</xsl:with-param>
<xsl:with-param name="maxDecs">3</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:volatilityStrikePrice and ($docsType='2005VarianceSwapEuropeanInterdealer')">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">volatilityStrikePrice</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:volatilityStrikePrice"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.01</xsl:with-param>
<xsl:with-param name="maxIncl">300.00</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swbExpectedNOverride">
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">swbExpectedNOverride</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swbExpectedNOverride"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swbSettlementCurrencyVegaNotionalAmount and not (/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:varianceLeg/fpml:equityAmount/fpml:variance/fpml:fxFeature)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swbSettlementCurrencyVegaNotionalAmount encountered in this context when no fxFeature is present. A settlement currency vega notional is only allowed for trades settling cross currency.</text>
</error>
</xsl:if>
<xsl:choose>
<xsl:when test="not (fpml:swbSettlementCurrencyVegaNotionalAmount) and  /fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:varianceLeg/fpml:equityAmount/fpml:variance/fpml:fxFeature">
<xsl:if test="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:varianceLeg/fpml:equityAmount/fpml:variance/fpml:fxFeature/fpml:referenceCurrency='AUD'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swbSettlementCurrencyVegaNotionalAmount in this context when currency is AUD. If a normally deliverable currency is traded as non deliverable, swbSettlementCurrencyVegaNotionalAmount is required.</text>
</error>
</xsl:if>
<xsl:if test="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:varianceLeg/fpml:equityAmount/fpml:variance/fpml:fxFeature/fpml:referenceCurrency='HKD'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swbSettlementCurrencyVegaNotionalAmount in this context when currency is HKD. If a normally deliverable currency is traded as non deliverable, swbSettlementCurrencyVegaNotionalAmount is required.</text>
</error>
</xsl:if>
<xsl:if test="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:varianceLeg/fpml:equityAmount/fpml:variance/fpml:fxFeature/fpml:referenceCurrency='NZD'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swbSettlementCurrencyVegaNotionalAmount in this context when currency is NZD. If a normally deliverable currency is traded as non deliverable, swbSettlementCurrencyVegaNotionalAmount is required.</text>
</error>
</xsl:if>
<xsl:if test="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:varianceLeg/fpml:equityAmount/fpml:variance/fpml:fxFeature/fpml:referenceCurrency='SGD'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swbSettlementCurrencyVegaNotionalAmount in this context when currency is SGD. If a normally deliverable currency is traded as non deliverable, swbSettlementCurrencyVegaNotionalAmount is required.</text>
</error>
</xsl:if>
</xsl:when>
</xsl:choose>
<xsl:if test="fpml:swbSettlementCurrencyVegaNotionalAmount">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swbSettlementCurrencyVegaNotionalAmount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swbSettlementCurrencyVegaNotionalAmount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.01</xsl:with-param>
<xsl:with-param name="maxIncl">9999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swbVegaFxSpotRate and not (/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:varianceLeg/fpml:equityAmount/fpml:variance/fpml:fxFeature)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swbVegaFxSpotRate encountered in this context when no fxFeature is present. A vega spot rate is only allowed for trades settling cross currency.</text>
</error>
</xsl:if>
<xsl:choose>
<xsl:when test="not (fpml:swbVegaFxSpotRate) and /fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:varianceLeg/fpml:equityAmount/fpml:variance/fpml:fxFeature">
<xsl:if test="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:varianceLeg/fpml:equityAmount/fpml:variance/fpml:fxFeature/fpml:referenceCurrency='AUD'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swbVegaFxSpotRate in this context when currency is AUD. If a normally deliverable currency is traded as non deliverable, swbVegaFxSpotRate is required.</text>
</error>
</xsl:if>
<xsl:if test="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:varianceLeg/fpml:equityAmount/fpml:variance/fpml:fxFeature/fpml:referenceCurrency='HKD'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swbVegaFxSpotRate in this context when currency is HKD. If a normally deliverable currency is traded as non deliverable, swbVegaFxSpotRate is required.</text>
</error>
</xsl:if>
<xsl:if test="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:varianceLeg/fpml:equityAmount/fpml:variance/fpml:fxFeature/fpml:referenceCurrency='NZD'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swbVegaFxSpotRate in this context when currency is NZD. If a normally deliverable currency is traded as non deliverable, swbVegaFxSpotRate is required.</text>
</error>
</xsl:if>
<xsl:if test="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:varianceLeg/fpml:equityAmount/fpml:variance/fpml:fxFeature/fpml:referenceCurrency='SGD'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swbVegaFxSpotRate in this context when currency is SGD. If a normally deliverable currency is traded as non deliverable, swbVegaFxSpotRate is required.</text>
</error>
</xsl:if>
</xsl:when>
</xsl:choose>
<xsl:if test="fpml:swbVegaFxSpotRate">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swbVegaFxSpotRate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swbVegaFxSpotRate"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.000001</xsl:with-param>
<xsl:with-param name="maxIncl">9999.999999</xsl:with-param>
<xsl:with-param name="maxDecs">6</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="//fpml:fxFeature//fpml:fxSpotRateSource and (//fpml:swbExtendedTradeDetails/fpml:swbVarianceSwapDetails/fpml:swbFxDeterminationMethod = 'AsSpecifiedInMasterConfirmation')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected fxSpotRateSource element encountered in this context. Element must not be present when swbFxDeterminationMethod is 'AsSpecifiedInMasterConfirmation'</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:swbDeltaCross">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="not( $productType = 'Equity Index Swap' or $productType = 'Equity Share Swap')">
<xsl:choose>
<xsl:when test="fpml:buyerPartyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:buyerPartyReference/@href"/>
<xsl:when test="fpml:buyerPartyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:sellerPartyReference/@href"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid buyerPartyReference/@href attribute value. Value = '<xsl:value-of select="fpml:buyerPartyReference/@href"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
<xsl:choose>
<xsl:when test="fpml:sellerPartyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:buyerPartyReference/@href"/>
<xsl:when test="fpml:sellerPartyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:sellerPartyReference/@href"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid sellerPartyReference/@href attribute value. Value = '<xsl:value-of select="fpml:sellerPartyReference/@href"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="fpml:buyerPartyReference/@href = fpml:sellerPartyReference/@href">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** buyerPartyReference/@href and sellerPartyReference/@href values are the same.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:equity) and $productType = 'Equity Share Option'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing equity element when product type is 'Equity Share Option'.</text>
</error>
</xsl:if>
<xsl:if test="$productType = 'Equity Share Option'">
<xsl:if test="not(fpml:equity/fpml:instrumentId = //fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:underlyer/fpml:singleUnderlyer/fpml:equity/fpml:instrumentId)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The equity/instrumentId must equal the //FpML/trade/equityOptionTransactionSupplement/underlyer/singleUnderlyer/equity/instrumentId.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:equity and not($productType = 'Equity Share Option' or $productType = 'Equity Share Swap')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The swbDeltaCross/equity should only be present for Share Options/Swaps.</text>
</error>
</xsl:if>
<xsl:if test="fpml:future and not($productType = 'Equity Index Option' or $productType = 'Equity Index Swap')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The swbDeltaCross/future should only be present for Index Options/Swaps.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:equity|fpml:future">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:swbPrice">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swbQuantity</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swbQuantity"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">9999999999.9999</xsl:with-param>
<xsl:with-param name="maxDecs">4</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="fpml:swbDelta">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swbDelta</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swbDelta"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">99.9999999</xsl:with-param>
<xsl:with-param name="maxDecs">7</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swbOffshoreCross and not(($docsType='ISDA2005EquityAsiaExcludingJapanInterdealer' or $docsType='ISDA2008EquityAsiaExcludingJapan' or $docsType='EquityOptionAEJPrivate')) and $productType = 'Equity Share Option'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swbOffshoreCross in this context when brokerConfirmation type is '<xsl:value-of select="$docsType"/>' and product is 'Equity Share Option'. This element may only be used with 'ISDA2005EquityAsiaExcludingJapanInterdealer' or 'ISDA2008EquityAsiaExcludingJapan' or 'EquityOptionAEJPrivate' Share Options.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swbOffshoreCross and  ($docsType='ISDA2005EquityAsiaExcludingJapanInterdealer' or $docsType='ISDA2008EquityAsiaExcludingJapan' or $docsType='EquityOptionAEJPrivate')">
<xsl:call-template name="isValidBusinessCenter">
<xsl:with-param name="elementName">swbOffshoreCrossLocation</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swbOffshoreCross/fpml:swbOffshoreCrossLocation"/>
</xsl:with-param>
<xsl:with-param name="assetClass">
<xsl:value-of select="$assetClass"/>
</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="not($docsType='ISDA2010EquityEMEAInterdealer' or $docsType='EquityOptionEMEAPrivate') and not( $productType = 'Equity Index Swap' or $productType = 'Equity Share Swap')">
<xsl:if test="fpml:swbCrossExchangeId and not($productType='Equity Share Option' and ($docsType='ISDA2004EquityAmericasInterdealer' or $docsType='ISDA2008EquityAmericas' or $docsType='ISDA2009EquityAmericas'  or $docsType='EquityOptionAmericasPrivate' ) and //fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:equityPremium/fpml:paymentAmount/fpml:currency='USD')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swbCrossExchangeId in this context. This element may only be used for product type 'Equity Share Options', brokerConfirmationType 'ISDA2004EquityAmericasInterdealer' or 'ISDA2008EquityAmericas'  or 'ISDA2009EquityAmericas' or 'EquityOptionAmericasPrivate' and currency 'USD' </text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:swbDeltaOptionQuantity">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swbDeltaOptionQuantity</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swbDeltaOptionQuantity"/>
</xsl:with-param>
<xsl:with-param name="minIncl">1</xsl:with-param>
<xsl:with-param name="maxIncl">99999999999</xsl:with-param>
<xsl:with-param name="maxDecs">0</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="not(//fpml:SWBML/fpml:swbHeader/fpml:swbStrategyType)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected Delta Option Quantity found in this context. Not expected for non-Strategy trades.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:swbEquityOptionDetails">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="fpml:swbDefaultSettlementMethod">
<xsl:call-template name="isValidDefaultSettlementMethod">
<xsl:with-param name="elementName">swbDefaultSettlementMethod</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swbDefaultSettlementMethod"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swbSettlementPriceDefaultElection">
<xsl:call-template name="isValidSettlementPriceDefaultElectionMethod">
<xsl:with-param name="elementName">SettlementPriceDefaultElection</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swbSettlementPriceDefaultElection"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="(fpml:swbSettlementPriceDefaultElection) and not($docsType='ISDA2008EquityAsiaExcludingJapan') and not($docsType='ISDA2005EquityAsiaExcludingJapanInterdealer')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Settlement Price Default Election should only be supplied where Docs Type is 'ISDA2005EquityAsiaExcludingJapanInterdealer' or 'ISDA2008EquityAsiaExcludingJapan' .</text>
</error>
</xsl:if>
<xsl:if test="(fpml:swbSettlementPriceDefaultElection and $productType!='Equity Share Option')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Settlement Price Default Election should only be supplied where product type is Equity Share Option.</text>
</error>
</xsl:if>
<xsl:if test="(fpml:swbSettlementPriceDefaultElection) and (($docsType = 'ISDA2008EquityAsiaExcludingJapan') or ($docsType = 'ISDA2005EquityAsiaExcludingJapanInterdealer'))">
<xsl:choose>
<xsl:when test="//fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:equityExercise/fpml:settlementCurrency = 'USD'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Settlement Price Default Election can only be present when equityExercise/settlementCurrency is a non-deliverable currency and docsType is 'ISDA2005EquityAsiaExcludingJapanInterdealer' or 'ISDA2008EquityAsiaExcludingJapan'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="fpml:swbReferenceFXRate">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swbReferenceFXRate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swbReferenceFXRate"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">99999.999999</xsl:with-param>
<xsl:with-param name="maxDecs">6</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="(not //fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:fxFeature/fpml:composite or not //fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:fxFeature/fpml:crossCurrency or not //fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:fxFeature/fpml:quanto) and fpml:swbReferenceFXRate">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swbReferenceFXRate provided - Not expected for Vanilla Trades.</text>
</error>
</xsl:if>
<xsl:if test="(not //fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbEquityOptionDetails/fpml:swbEquityOptionPercentInput) and fpml:swbReferenceFXRate">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swbReferenceFXRate provided - Not expected for non percent input Trades.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swbEquityOptionPercentInput">
<xsl:apply-templates select="fpml:swbEquityOptionPercentInput">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
<xsl:if test="fpml:swbAveragingDates">
<xsl:apply-templates select="fpml:swbAveragingDates">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:swbDividendSwapDetails">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="fpml:swbSplitCollateral and not (/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:collateral)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing fpml:collateral sequence, expected in this context</text>
</error>
</xsl:if>
<xsl:if test="fpml:swbSplitCollateral and not (/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbDividendSwapDetails/fpml:swbBreakOutTrade)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swbBreakOutTrade element, expected in this context</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:swbEquityOptionPercentInput">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="not(//fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:equityPremium/fpml:pricePerOption/fpml:amount)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing Price element. You must supply pricePerOption/amount for % input trades. Required in this context.</text>
</error>
</xsl:if>
<xsl:if test="not($docsType = 'ISDA2008EquityJapanese')">
<xsl:if test="not(/fpml:SWBML//fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbEquityOptionDetails/fpml:swbEquityOptionPercentInput/fpml:swbPremiumPercentage)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing element. You must supply swbPremiumPercentage for % input trades. Required in this context.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="not (//fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:equityPremium/fpml:paymentAmount/fpml:amount) ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing element. You must supply paymentAmount/amount for % input trades. Required in this context.</text>
</error>
</xsl:if>
<xsl:if test="not(/fpml:SWBML//fpml:swbStructuredTradeDetails//fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:strike/fpml:strikePercentage)">
<xsl:if test="not(/fpml:SWBML//fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbEquityOptionDetails/fpml:swbEquityOptionPercentInput/fpml:swbStrikePercentage)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing element. You must supply swbStrikePercentage for % input trades. Required in this context.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="not ($docsType = 'ISDA2005EquityJapaneseInterdealer' or $docsType = 'ISDA2008EquityJapanese' or $docsType = 'ISDA2005EquityAsiaExcludingJapanInterdealer' or $docsType = 'ISDA2008EquityAsiaExcludingJapan' or $docsType = 'EquityOptionAEJPrivate' )">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swbEquityOptionPercentInput element encountered in this context. Element must not be present if product is not on a Japanese or AEJ Underlier. Value = '<xsl:value-of select="$docsType"/>'</text>
</error>
</xsl:if>
<xsl:if test="not ($productType!='Equity Index Option' or $productType!='Equity Share Option')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swbEquityOptionPercentInput element encountered in this context. Element must not be present if product is not an Equity Index Option or Equity Share Option.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:swbHedgeLevel)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swbHedgeLevel element encountered in this context. Element must be present if swbEquityOptionPercentInput is present.</text>
</error>
</xsl:if>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swbHedgeLevel</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swbHedgeLevel"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.000001</xsl:with-param>
<xsl:with-param name="maxIncl">9999999.999999</xsl:with-param>
<xsl:with-param name="maxDecs">6</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="$productType = 'Equity Share Option'">
<xsl:if test="fpml:swbBasis or fpml:swbImpliedLevel">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbBasis should only be specified on Index Options.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$productType = 'Equity Share Option'">
<xsl:if test="fpml:swbImpliedLevel">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbImpliedLevel should only be specified on Index Options.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:swbBasis">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swbBasis</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swbBasis"/>
</xsl:with-param>
<xsl:with-param name="minIncl">-9999999.999999</xsl:with-param>
<xsl:with-param name="maxIncl">9999999.999999</xsl:with-param>
<xsl:with-param name="maxDecs">6</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swbImpliedLevel">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swbImpliedLevel</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swbImpliedLevel"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.000001</xsl:with-param>
<xsl:with-param name="maxIncl">9999999.999999</xsl:with-param>
<xsl:with-param name="maxDecs">6</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swbPremiumPercentage">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swbPremiumPercentage</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swbPremiumPercentage"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">9999999.9999999</xsl:with-param>
<xsl:with-param name="maxDecs">7</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swbStrikePercentage">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swbStrikePercentage</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swbStrikePercentage"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">99.9999999</xsl:with-param>
<xsl:with-param name="maxDecs">7</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swbNotional">
<xsl:if test="not(/fpml:SWBML//fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbEquityOptionDetails/fpml:swbEquityOptionPercentInput/fpml:swbNotional/fpml:currency='USD')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected Currency found in this context Currency must be 'USD' in this context. </text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:swbNotional">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swbNotional</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swbNotional/fpml:amount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">9999999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:swbAveragingDates">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="not(/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:feature)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Expected fpml:feature element not encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:swbAveragingFrequency)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Expected swbAveragingFrequency element not encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:swbAveragingFrequency ='Custom')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***Averaging Frequency must be equal to 'Custom' in this context.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:swbAveragingStart)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** ExpectedswbAveragingStart element not encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:swbAveragingEnd)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** ExpectedswbAveragingEnd element not encountered in this context.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:swbPrice">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="not( $productType = 'Equity Index Swap' or $productType = 'Equity Share Swap')">
<xsl:if test="not($docsType='ISDA2010EquityEMEAInterdealer' or $docsType='EquityOptionEMEAPrivate' or $docsType='2004EquityEuropeanInterdealer' or $docsType='ISDA2007EquityEuropean' or $docsType='EquityOptionEuropePrivate')">
<xsl:if test="not($docsType = 'ISDA2008EquityJapanese')">
<xsl:if test="not(fpml:currency = //fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:equityPremium/fpml:paymentAmount/fpml:currency) and not(//fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:fxFeature)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The currency must equal equityPremium/paymentAmount/currency when option is Vanilla settled.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="not(fpml:currency = //fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:fxFeature/fpml:referenceCurrency) and //fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:fxFeature">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The currency must equal fxFeature/referenceCurrency when option is not Vanilla settled.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
<xsl:if test="$productType = 'Equity Share Option'">
<xsl:choose>
<xsl:when test="$docsType='2004EquityEuropeanInterdealer' or $docsType='ISDA2007EquityEuropean' or $docsType='EquityOptionEuropePrivate' or $docsType='ISDA2004EquityAmericasInterdealer' or $docsType='ISDA2008EquityAmericas' or $docsType='ISDA2009EquityAmericas' or $docsType='EquityOptionAmericasPrivate' or $docsType='ISDA2010EquityEMEAInterdealer' or $docsType='EquityOptionEMEAPrivate' ">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">amount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:amount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.00001</xsl:with-param>
<xsl:with-param name="maxIncl">9999.99999</xsl:with-param>
<xsl:with-param name="maxDecs">5</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:when>
<xsl:when test="$docsType='ISDA2005EquityJapaneseInterdealer' or $docsType = 'ISDA2008EquityJapanese' or $docsType='ISDA2005EquityAsiaExcludingJapanInterdealer' or $docsType='ISDA2008EquityAsiaExcludingJapan' or $docsType='EquityOptionAEJPrivate'">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">amount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:amount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.00001</xsl:with-param>
<xsl:with-param name="maxIncl">999999999.99999</xsl:with-param>
<xsl:with-param name="maxDecs">5</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:when>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Empty or invalid brokerConfirmationType element. Value = '<xsl:value-of select="$docsType"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="$productType='Equity Index Option'">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">amount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:amount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.00001</xsl:with-param>
<xsl:with-param name="maxIncl">999999999.99999</xsl:with-param>
<xsl:with-param name="maxDecs">5</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:tradeHeader">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="count(fpml:partyTradeIdentifier) != 2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of partyTradeIdentifier child elements encountered. Exactly 2 expected.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:partyTradeIdentifier">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:partyTradeInformation">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:partyTradeInformation and ($productType='Equity Share Swap' or $productType='Equity Index Swap')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected partyTradeInformation element encountered in this context.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:partyTradeIdentifier">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:if test="$productType = 'Equity Share Option' or $productType = 'Equity Index Option'">
<xsl:choose>
<xsl:when test="fpml:partyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:buyerPartyReference/@href"/>
<xsl:when test="fpml:partyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:sellerPartyReference/@href"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid partyReference/@href attribute value. Value = '<xsl:value-of select="fpml:partyReference/@href"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="$productType = 'Share Variance Swap' or $productType = 'Index Variance Swap'">
<xsl:choose>
<xsl:when test="fpml:partyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:buyerPartyReference/@href"/>
<xsl:when test="fpml:partyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:sellerPartyReference/@href"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid partyReference/@href attribute value. Value = '<xsl:value-of select="fpml:partyReference/@href"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="$productType = 'Equity Share Swap' or $productType = 'Equity Index Swap' ">
<xsl:if test="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:buyerPartyReference">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected buyerPartyReference element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:sellerPartyReference">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected sellerPartyReference element encountered in this context.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:variable name="tradeIdScheme">
<xsl:value-of select="fpml:tradeId/@tradeIdScheme"/>
</xsl:variable>
<xsl:if test="$tradeIdScheme=''">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or empty tradeId/@tradeIdScheme attribute.</text>
</error>
</xsl:if>
<xsl:variable name="tradeId">
<xsl:value-of select="fpml:tradeId"/>
</xsl:variable>
<xsl:if test="$tradeId=''">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Empty tradeId element.</text>
</error>
</xsl:if>
<xsl:if test="fpml:linkId">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected linkId element encountered in this context.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:partyTradeInformation">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:if test="$productType = 'Equity Share Option' or $productType = 'Equity Index Option'">
<xsl:choose>
<xsl:when test="fpml:partyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:buyerPartyReference/@href"/>
<xsl:when test="fpml:partyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:sellerPartyReference/@href"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid partyReference/@href attribute value. Value = '<xsl:value-of select="fpml:partyReference/@href"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="$productType = 'Share Variance Swap' or $productType = 'Index Variance Swap'">
<xsl:choose>
<xsl:when test="fpml:partyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:buyerPartyReference/@href"/>
<xsl:when test="fpml:partyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:sellerPartyReference/@href"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid partyReference/@href attribute value. Value = '<xsl:value-of select="fpml:partyReference/@href"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="fpml:trader">
<xsl:if test="fpml:trader=''">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Empty trader element.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:adjustableDate">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="$productType = 'Equity Share Swap' or $productType = 'Equity Index Swap' ">
<xsl:if test="(ancestor::fpml:returnLeg and ancestor::fpml:terminationDate) and not(fpml:unadjustedDate = //fpml:equitySwapTransactionSupplement/fpml:returnLeg/fpml:rateOfReturn/fpml:valuationPriceFinal/fpml:valuationRules/fpml:valuationDate/fpml:adjustableDate/fpml:unadjustedDate)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Return leg termination date must be equal to final valuation date.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:variable name="dateValidationApplicable">
<xsl:choose>
<xsl:when test="$productType = 'Equity Share Swap' or $productType = 'Equity Index Swap' or $productType = 'Dispersion Variance Swap' ">true</xsl:when>
<xsl:when test="$docsType = 'ISDA2009EquityAmericas' and ($productType='Equity Share Option' or $productType='Equity Index Option') ">true</xsl:when>
<xsl:when test="$docsType = 'EquityOptionAmericasPrivate' and ($productType='Equity Share Option' or $productType='Equity Index Option') ">true</xsl:when>
<xsl:when test="$docsType = 'ISDA2010EquityEMEAInterdealer' ">true</xsl:when>
<xsl:when test="$docsType = 'EquityOptionEMEAPrivate' ">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:if test="$dateValidationApplicable = 'true' ">
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
</xsl:if>
<xsl:apply-templates select="fpml:dateAdjustments">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:party">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:if test="not(fpml:partyId)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing partyId element.</text>
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
<text>*** Empty partyName element.</text>
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
<xsl:template match="fpml:otherPartyPayment">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:if test="$productType='Equity Share Option' or $productType='Equity Index Option'">
<xsl:choose>
<xsl:when test="fpml:payerPartyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:buyerPartyReference/@href"/>
<xsl:when test="fpml:payerPartyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:sellerPartyReference/@href"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid payerPartyReference/@href attribute value. Value = '<xsl:value-of select="fpml:payerPartyReference/@href"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="$productType='Equity Share Option' or $productType='Equity Index Option'">
<xsl:choose>
<xsl:when test="fpml:receiverPartyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:buyerPartyReference/@href">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid receiverPartyReference/@href attribute value. Value = '<xsl:value-of select="fpml:receiverPartyReference/@href"/>'.</text>
</error>
</xsl:when>
<xsl:when test="fpml:receiverPartyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:sellerPartyReference/@href">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid receiverPartyReference/@href attribute value. Value = '<xsl:value-of select="fpml:receiverPartyReference/@href"/>'.</text>
</error>
</xsl:when>
<xsl:otherwise/>
</xsl:choose>
</xsl:if>
<xsl:if test="$productType='Share Variance Swap' or $productType='Index Variance Swap'">
<xsl:choose>
<xsl:when test="fpml:payerPartyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:buyerPartyReference/@href"/>
<xsl:when test="fpml:payerPartyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:sellerPartyReference/@href"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid payerPartyReference/@href attribute value. Value = '<xsl:value-of select="fpml:payerPartyReference/@href"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="$productType='Share Variance Swap' or $productType='Index Variance Swap'">
<xsl:choose>
<xsl:when test="fpml:receiverPartyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:buyerPartyReference/@href">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid receiverPartyReference/@href attribute value. Value = '<xsl:value-of select="fpml:receiverPartyReference/@href"/>'.</text>
</error>
</xsl:when>
<xsl:when test="fpml:receiverPartyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:sellerPartyReference/@href">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid receiverPartyReference/@href attribute value. Value = '<xsl:value-of select="fpml:receiverPartyReference/@href"/>'.</text>
</error>
</xsl:when>
<xsl:otherwise/>
</xsl:choose>
</xsl:if>
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
<text>*** payerPartyReference/@href and receiverPartyReference/@href values are the same.</text>
</error>
</xsl:if>
<xsl:if test="not(/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:party[@id=$href2])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The receiverPartyReference/@href value does not match an //FpML/party/@id value for any party. Value = '<xsl:value-of select="$href2"/>'.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:paymentAmount">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:paymentDate">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected paymentDate element encountered in this context. Not expected for brokerage payment.</text>
</error>
</xsl:if>
<xsl:if test="fpml:adjustedPaymentDate">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected adjustedPaymentDate element encountered in this context. Not expected for brokerage payment.</text>
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
<xsl:if test="fpml:settlementInformation">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected settlementInformation element encountered in this context. Not expected for brokerage payment.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:paymentAmount">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
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
<xsl:if test="ancestor::fpml:otherPartyPayment">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">amount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:amount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.00</xsl:with-param>
<xsl:with-param name="maxIncl">999999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="ancestor::fpml:independentAmount">
<xsl:variable name="minIncl">
<xsl:choose>
<xsl:when test="ancestor::fpml:swbAllocation">0.00</xsl:when>
<xsl:otherwise>1.00</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">paymentAmount/amount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:amount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">
<xsl:value-of select="$minIncl"/>
</xsl:with-param>
<xsl:with-param name="maxIncl">999999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="($docsType='2004EquityEuropeanInterdealer' or $docsType='ISDA2007EquityEuropean' or $docsType='EquityOptionEuropePrivate' or $docsType='ISDA2005EquityAsiaExcludingJapanInterdealer' or $docsType='ISDA2008EquityAsiaExcludingJapan' or $docsType='EquityOptionAEJPrivate' or $docsType='ISDA2004EquityAmericasInterdealer' or $docsType='ISDA2008EquityAmericas' or $docsType='ISDA2009EquityAmericas' or $docsType='EquityOptionAmericasPrivate' or $docsType='ISDA2010EquityEMEAInterdealer' or $docsType='EquityOptionEMEAPrivate') and ancestor::fpml:equityOptionTransactionSupplement">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">amount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:amount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.00</xsl:with-param>
<xsl:with-param name="maxIncl">9999999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="($docsType='ISDA2005EquityJapaneseInterdealer'  or $docsType = 'ISDA2008EquityJapanese') and ancestor::fpml:equityOptionTransactionSupplement">
<xsl:call-template name="isValidIntegerNumber">
<xsl:with-param name="elementName">amount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:amount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">901000000000000</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="ancestor::fpml:independentAmount">
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
</xsl:if>
</xsl:template>
<xsl:template match="fpml:instrumentId">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:call-template name="isValidInstrumentIdScheme">
<xsl:with-param name="elementName">instrumentId/@instrumentIdScheme</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="@instrumentIdScheme"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:template>
<xsl:template match="fpml:equityOptionTransactionSupplement">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:variable name="buyer">
<xsl:value-of select="fpml:buyerPartyReference/@href"/>
</xsl:variable>
<xsl:if test="not(/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:party[@id=$buyer])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The buyerPartyReference/@href value does not match an //FpML/party/@id value for any party. Value = '<xsl:value-of select="$buyer"/>'.</text>
</error>
</xsl:if>
<xsl:variable name="seller">
<xsl:value-of select="fpml:sellerPartyReference/@href"/>
</xsl:variable>
<xsl:if test="not(/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:party[@id=$seller])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The sellerPartyReference/@href value does not match an //FpML/party/@id value for any party. Value = '<xsl:value-of select="$seller"/>'.</text>
</error>
</xsl:if>
<xsl:if test="$buyer=$seller">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** buyerPartyReference/@href and sellerPartyReference/@href values are the same.</text>
</error>
</xsl:if>
<xsl:if test="fpml:equityEffectiveDate">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected equityEffectiveDate element encountered in this context.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:underlyer">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:notional">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected notional element encountered in this context.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:equityExercise">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:fxFeature and not (($docsType='ISDA2005EquityAsiaExcludingJapanInterdealer' or $docsType = 'ISDA2008EquityAsiaExcludingJapan' or $docsType = 'EquityOptionAEJPrivate') and fpml:equityExercise/fpml:settlementType = 'Cash')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected fxFeature element encountered in this context. Element must not be present when brokerConfirmationType is not 'ISDA2005EquityAsiaExcludingJapanInterdealer' and not 'ISDA2008EquityAsiaExcludingJapan'' and not 'EquityOptionAEJPrivate' and equityExercise/settlementType is not 'Cash'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:fxFeature//fpml:fxSpotRateSource and (//fpml:swbExtendedTradeDetails/fpml:swbEquityOptionDetails/fpml:swbFxDeterminationMethod = 'AsSpecifiedInMasterConfirmation')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected fxSpotRateSource element encountered in this context. Element must not be present when swbFxDeterminationMethod is 'AsSpecifiedInMasterConfirmation'</text>
</error>
</xsl:if>
<xsl:if test="fpml:fxFeature//fpml:fxSpotRateSource and (//fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbEquityOptionDetails/fpml:swbSettlementPriceDefaultElection = 'HedgeExecution')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected fxSpotRateSource element encountered in this context. Element must not be present when swbSettlementPriceDefaultElection is 'HedgeExecution'</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:fxFeature//fpml:fxSpotRateSource) and (//fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbEquityOptionDetails/fpml:swbSettlementPriceDefaultElection = 'Close')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected fxSpotRateSource element encountered in this context. Element must not be present when swbSettlementPriceDefaultElection is 'Close'</text>
</error>
</xsl:if>
<xsl:if test="not(//fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbEquityOptionDetails/fpml:swbSettlementPriceDefaultElection = 'HedgeExecution')">
<xsl:if test="not(fpml:fxFeature) and ($docsType='ISDA2005EquityAsiaExcludingJapanInterdealer' or $docsType = 'ISDA2008EquityAsiaExcludingJapan' or $docsType = 'EquityOptionAEJPrivate') and fpml:equityExercise/fpml:settlementType = 'Cash'">
<xsl:choose>
<xsl:when test="fpml:equityExercise/fpml:settlementCurrency = 'AUD'"/>
<xsl:when test="fpml:equityExercise/fpml:settlementCurrency = 'HKD'"/>
<xsl:when test="fpml:equityExercise/fpml:settlementCurrency = 'NZD'"/>
<xsl:when test="fpml:equityExercise/fpml:settlementCurrency = 'SGD'"/>
<xsl:when test="fpml:equityExercise/fpml:settlementCurrency = 'KRW'"/>
<xsl:when test="fpml:equityExercise/fpml:settlementCurrency = 'INR'"/>
<xsl:when test="fpml:equityExercise/fpml:settlementCurrency = 'TWD'"/>
<xsl:when test="fpml:equityExercise/fpml:settlementCurrency = 'THB'"/>
<xsl:when test="fpml:equityExercise/fpml:settlementCurrency = 'MYR'"/>
<xsl:when test="fpml:equityExercise/fpml:settlementCurrency = 'PKR'"/>
<xsl:when test="fpml:equityExercise/fpml:settlementCurrency = 'PHP'"/>
<xsl:when test="fpml:equityExercise/fpml:settlementCurrency = 'VNP'"/>
<xsl:when test="fpml:equityExercise/fpml:settlementCurrency = 'IDR'"/>
<xsl:when test="fpml:equityExercise/fpml:settlementCurrency = 'USD'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing fxFeature element when brokerConfirmationType is 'ISDA2005EquityAsiaExcludingJapanInterdealer' or 'ISDA2008EquityAsiaExcludingJapan' or 'EquityOptionAEJPrivate' and equityExercise/settlementType is 'Cash' and equityExercise/settlementCurrency is a non-deliverable currency and swbSettlementPriceDefaultElection is not 'HedgeExecution'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:feature">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:fxFeature">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:strategyFeature">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected strategyFeature element encountered in this context.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:strike">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:spotPrice">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected spotPrice element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="$docsType='2004EquityEuropeanInterdealer' or $docsType='ISDA2007EquityEuropean' or $docsType='EquityOptionEuropePrivate' or $docsType='ISDA2005EquityAsiaExcludingJapanInterdealer' or $docsType = 'ISDA2008EquityAsiaExcludingJapan' or $docsType='EquityOptionAEJPrivate' or $docsType='ISDA2004EquityAmericasInterdealer' or $docsType='ISDA2008EquityAmericas' or $docsType='ISDA2009EquityAmericas' or $docsType='EquityOptionAmericasPrivate' or $docsType='ISDA2010EquityEMEAInterdealer' or $docsType='EquityOptionEMEAPrivate' ">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">numberOfOptions</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:numberOfOptions"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.00001</xsl:with-param>
<xsl:with-param name="maxIncl">9999999999.9999</xsl:with-param>
<xsl:with-param name="maxDecs">5</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="$docsType='ISDA2005EquityJapaneseInterdealer' or $docsType = 'ISDA2008EquityJapanese'">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">numberOfOptions</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:numberOfOptions"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.01</xsl:with-param>
<xsl:with-param name="maxIncl">9999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:apply-templates select="fpml:equityPremium">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="$productType='Equity Share Option' and ($docsType='2004EquityEuropeanInterdealer' or $docsType='ISDA2007EquityEuropean' or $docsType='EquityOptionEuropePrivate')">
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">exchangeLookAlike</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:exchangeLookAlike"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="($productType='Equity Share Option' or $productType='Equity Index Option') and fpml:exchangeLookAlike and ($docsType='ISDA2008EquityAmericas')">
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">exchangeLookAlike</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:exchangeLookAlike"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="$productType='Equity Share Option' and fpml:exchangeLookAlike and not($docsType='2004EquityEuropeanInterdealer' or $docsType='ISDA2007EquityEuropean' or $docsType='EquityOptionEuropePrivate' or $docsType='ISDA2008EquityAmericas' or $docsType='ISDA2010EquityEMEAInterdealer' or $docsType='EquityOptionEMEAPrivate')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected exchangeLookAlike element encountered in this context when product type is 'Equity Share Option' and brokerConfirmationType is not '2004EquityEuropeanInterdealer' or 'ISDA2007EquityEuropean' or 'EquityOptionEuropePrivate' or 'ISDA2008EquityAmericas' or 'ISDA2010EquityEMEAInterdealer' or 'EquityOptionEMEAPrivate'.</text>
</error>
</xsl:if>
<xsl:if test="$productType='Equity Index Option' and fpml:exchangeLookAlike and $docsType='ISDA2008EquityAmericas'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected exchangeLookAlike element encountered in this context when product type is 'Equity Index Option' and brokerConfirmationType is not 'ISDA2008EquityAmericas'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:exchangeTradedContractNearest and ($productType = 'Equity Index Option' or $productType ='Equity Index Option Strategy') and not($isEuropeOption='true' or $isEMEAOption='true') ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected exchangeTradedContractNearest element encountered in this context when productType is 'Equity Index Option' or 'Equity Index Option Strategy' and Docs Type is not 'Equity Options (Europe)' or 'Equity Options (EMEA)'.</text>
</error>
</xsl:if>
<xsl:if test="($productType='Equity Share Option' or $productType='Equity Share Option Strategy') and fpml:exchangeTradedContractNearest">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected exchangeTradedContractNearest element encountered in this context when product type is 'Equity Share Option' or 'Equity Share Option Strategy'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:multipleExchangeIndexAnnexFallback and ($productType='Equity Share Option' or $productType='Equity Share Option Strategy' or isEuropeOption='false')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected multipleExchangeIndexAnnexFallback element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="($productType = 'Equity Index Option' and fpml:methodOfAdjustment) or (fpml:methodOfAdjustment and $productType = 'Equity Share Option' and  not($docsType='2004EquityEuropeanInterdealer' or $docsType='ISDA2004EquityAmericasInterdealer' or $docsType='ISDA2008EquityAmericas' or $docsType='ISDA2007EquityEuropean' or $docsType='EquityOptionEuropePrivate'))">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected methodOfAdjustment element encountered in this context. Element must not be present when product type is 'Equity Index Option' or when product type is 'Equity Share Option' and brokerConfirmationType is not 'ISDA2004EquityAmericasInterdealer' or 'ISDA2004EquityEuropeanInterdealer' or 'ISDA2007EquityEuropean' or 'EquityOptionEuropePrivate' or 'ISDA2008EquityAmericas'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:methodOfAdjustment">
<xsl:if test="fpml:exchangeLookAlike='false' and not (fpml:methodOfAdjustment='CalculationAgent')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** methodOfAdjustment may only be 'CalculationAgent' when the option is not an exchange look-alike option.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:localJurisdiction">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected localJurisdiction element encountered in this context.</text>
</error>
</xsl:if>
<xsl:variable name="optionEntitlementFieldApplicable">
<xsl:choose>
<xsl:when test="$productType = 'Equity Share Option' ">true</xsl:when>
<xsl:when test="$productType = 'Equity Share Option Strategy' ">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:if test="fpml:optionEntitlement and $optionEntitlementFieldApplicable = 'false' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected optionEntitlement element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="$productType = 'Equity Share Option' and fpml:multiplier">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected multiplier element encountered in this context. Element must not be present when product type is 'Equity Share Option'.</text>
</error>
</xsl:if>
<xsl:choose>
<xsl:when test="fpml:multiplier">
<xsl:call-template name="isValidIntegerNumber">
<xsl:with-param name="elementName">multiplier</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:multiplier"/>
</xsl:with-param>
<xsl:with-param name="minIncl">1</xsl:with-param>
<xsl:with-param name="maxIncl">999999</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:when>
</xsl:choose>
</xsl:template>
<xsl:template match="fpml:underlyer">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="fpml:basket">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected basket element encountered in this context.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:singleUnderlyer">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:singleUnderlyer">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="not(fpml:equity) and ($productType = 'Equity Share Option'  or $productType = 'Equity Share Option Strategy' or $productType = 'Share Variance Swap' or $productType = 'Equity Share Swap' or $productType = 'Equity Share Volatility Swap') ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing equity element when product type is 'Equity Share Option' or 'Equity Share Option Strategy' or 'Share Variance Swap' or 'Equity Share Swap' or 'Equity Share Volatility Swap'.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:index) and ($productType = 'Equity Index Option' or $productType='Equity Index Option Strategy' or $productType = 'Index Variance Swap' or $productType = 'Equity Index Swap' or $productType = 'Equity Index Volatility Swap') ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing index element when product type is 'Equity Index Option' or 'Equity Index Option Strategy'  or 'Index Variance Swap' or 'Equity Index Swap' or 'Equity Index Volatility Swap'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:openUnits and not ($productType = 'Equity Share Swap' or $productType = 'Equity Index Swap') ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected openUnits element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:openUnits) and ($productType = 'Equity Share Swap' or $productType = 'Equity Index Swap') and not(/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:returnLeg/fpml:rateOfReturn/fpml:initialPrice/fpml:determinationMethod)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** missing openUnits element in this context.</text>
</error>
</xsl:if>
<xsl:if test="$docsTypeEqSwap = 'Equity Swap (Europe)'">
<xsl:if test="fpml:openUnits">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">openUnits</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:openUnits"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">99999999.99999</xsl:with-param>
<xsl:with-param name="maxDecs">5</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
</xsl:if>
<xsl:if test="$docsTypeEqSwap = 'Equity Swap (AEJ)' or ($docsTypeEqSwap = 'Equity Swap (Americas)' and $productType = 'Equity Index Swap')">
<xsl:if test="fpml:openUnits">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">openUnits</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:openUnits"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">9999999999.99999</xsl:with-param>
<xsl:with-param name="maxDecs">5</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
</xsl:if>
<xsl:if test="$docsType = 'EquitySwapGlobalPrivate'">
<xsl:if test="fpml:openUnits">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">openUnits</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:openUnits"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">9999999999.99999</xsl:with-param>
<xsl:with-param name="maxDecs">5</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:dividendPayout and not ($productType = 'Equity Share Swap' or $productType = 'Equity Index Swap') ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected dividendPayout element encountered in this context (product type).</text>
</error>
</xsl:if>
<xsl:if test="$productType = 'Equity Share Swap' or $productType = 'Equity Index Swap' ">
<xsl:if test="fpml:dividendPayout and not(//fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:returnLeg/fpml:return/fpml:returnType = 'Total') ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected dividendPayout element encountered where returnType is not 'Total'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:dividendPayout">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">dividendPayout/dividendPayoutRatio</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:dividendPayout/fpml:dividendPayoutRatio"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">9.9999999</xsl:with-param>
<xsl:with-param name="maxDecs">7</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:couponPayout">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected couponPayout element encountered in this context.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:equity|fpml:index">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:equity|fpml:index">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="not($productType='Equity Index Option' or $productType='Equity Index Dividend Swap' or $productType='Index Variance Swap' or $productType='Equity Share Swap' or $productType='Equity Index Swap' or $productType='Equity Share Volatilty Swap' or $productType='Equity Index Volatility Swap')">
<xsl:if test="not(count(fpml:instrumentId)=1)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The instrumentId element must occur once only in this context</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$productType='Equity Index Option' or $productType='Equity Index Dividend Swap' or $productType='Index Variance Swap' or $productType='Equity Share Swap' or $productType='Equity Index Swap' or $productType='Equity Share Volatilty Swap' or $productType='Equity Index Volatility Swap'">
<xsl:if test="not(count(fpml:instrumentId)&gt;=1)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The instrumentId element must occur at least once in this context</text>
</error>
</xsl:if>
<xsl:if test="count(fpml:instrumentId)&gt;2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The instrumentId element may not occur more than twice in this context</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:description">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected description element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:exchangeId and not($productType='Equity Share Volatility Swap' or $productType='Equity Index Volatility Swap')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected exchangeId element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:clearanceSystem">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected clearanceSystem element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:definition">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected definition element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="ancestor::fpml:swbDeltaCross and fpml:relatedExchangeId">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected relatedExchangeId element encountered in this context when ancestor is swbDeltaCross.</text>
</error>
</xsl:if>
<xsl:if test="fpml:relatedExchangeId and $productType='Equity Share Option' and ($docsType='ISDA2005EquityJapaneseInterdealer' or $docsType = 'ISDA2008EquityJapanese')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected  relatedExchangeId encountered in this context when product type is 'Equity Share Option' and brokerConfirmationType is 'ISDA2005EquityJapaneseInterdealer or 'ISDA2008EquityJapanese'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:relatedExchangeId='All Exchanges' and (fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:returnLeg/fpml:rateOfReturn/fpml:valuationPriceFinal/fpml:valuationRules/fpml:futuresPriceValuation='true' and $docsType = 'ISDA2009EquitySwapAmericas' and $productType ='Equity Index Swap')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected value for relatedExchangeId encountered in this context when brokerConfirmationType =  'ISDA2009EquitySwapAmericas' and futuresPriceValution = 'true'. Expected value 'All Exchanges'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:relatedExchangeId!='All Exchanges' and (fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:returnLeg/fpml:rateOfReturn/fpml:valuationPriceFinal/fpml:valuationRules/fpml:futuresPriceValuation='false' and $docsType = 'ISDA2009EquitySwapAmericas' and $productType ='Equity Index Swap')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected value for relatedExchangeId encountered in this context when brokerConfirmationType =  'ISDA2009EquitySwapAmericas' and futuresPriceValution = 'false'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:optionsExchangeId">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected optionsExchangeId element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:futureId">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected futureId element encountered in this context.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:instrumentId">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:relatedExchangeId">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:future">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="not(count(fpml:instrumentId)=1)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The instrumentId element must occur once only in this context</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:instrumentId/@instrumentIdScheme = 'http://www.swapswire.com/spec/2005/future-id-1-0')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid instrumentId/@instrumentIdScheme attribute value. It must equal 'http://www.swapswire.com/spec/2005/future-id-1-0'</text>
</error>
</xsl:if>
<xsl:if test="fpml:currency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected currency element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:exchangeId">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected exchangeId element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:clearanceSystem">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected clearanceSystem element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:definition">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected definition element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:relatedExchangeId">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected relatedExchangeId element encountered in this context.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:relatedExchangeId">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:optionsExchangeId">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected optionsExchangeId element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:multiplier">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected multiplier element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:futureContractReference">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected futureContractReference element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:maturity)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing maturity element.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:relatedExchangeId">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:choose>
<xsl:when test="@exchangeIdScheme='http://www.fpml.org/spec/2002/exchange-id-REC-1-0'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** @exchangeIdScheme value is invalid. Value = '<xsl:value-of select="@exchangeIdScheme"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template match="fpml:equityExercise">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="fpml:equityBermudaExercise">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected equityBermudaExercise element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:equityAmericanExercise and ($docsType='ISDA2005EquityJapaneseInterdealer' or $docsType = 'ISDA2008EquityJapanese')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected equityAmericanExercise element in this context when brokerConfirmationType is 'ISDA2005EquityJapaneseInterdealer' or 'ISDA2008EquityJapanese'. Only European Style options can be confirmed under the Japanse Master Confirmation.</text>
</error>
</xsl:if>
<xsl:if test="$productType='Equity Share Option' or $productType='Equity Index Option'">
<xsl:if test="not(fpml:automaticExercise[.='true'])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid automaticExercise element value. Must contain 'true' when product type is 'Equity Share Option' or 'Equity Index Option'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:makeWholeProvisions">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected makeWholeProvisions element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:prePayment">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected prePayment element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="(fpml:settlementDate and fpml:settlementType = 'Physical') or (fpml:settlementDate and fpml:settlementType = 'Election' and /fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbEquityOptionDetails/fpml:swbDefaultSettlementMethod != 'Cash')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected settlementDate element encountered in this context when settlementType is 'Physical' or when settlementType is 'Election' and swbDefaultSettlementMethod is not equal to 'Cash'. settlementDate only applies to cash settled options or to options for which Settlement Election applies and the default settlement method is 'Cash'.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:settlementCurrency = //fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:equityPremium/fpml:paymentAmount/fpml:currency) and not($docsType='ISDA2008EquityJapanese' or $docsType='ISDA2007EquityEuropean')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** settlementCurrency must equal //FpML/trade/equityOptionTransactionSupplement/equityPremium/paymentAmount/currency.</text>
</error>
</xsl:if>
<xsl:if test="fpml:settlementPriceSource">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected settlementPriceSource element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:settlementType[.='Cash']) and $productType='Equity Index Option'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid settlementType element encountered in this context when product type is 'Equity Index Option'. Value = '<xsl:value-of select="fpml:settlementType"/>'. Index options must be cash settled.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:settlementType[.='Physical']) and $productType='Equity Share Option' and $docsType='ISDA2005EquityJapaneseInterdealer'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid settlementType element encountered in this context when brokerConfirmationType is 'ISDA2005EquityJapaneseInterdealer' and product type = 'Equity Share Option'. Share Options confirmed under the Japanse Master Confirmation.must be physically settled. ISDA2008EquityJapanese allows cash settlements.</text>
</error>
</xsl:if>
<xsl:if test="fpml:settlementType = 'Election'">
<xsl:if test="not($productType='Equity Share Option' and ($docsType='ISDA2004EquityAmericasInterdealer' or $docsType='ISDA2008EquityAmericas' or $docsType='ISDA2009EquityAmericas' or $docsType='EquityOptionAmericasPrivate' or $docsType='ISDA2005EquityAsiaExcludingJapanInterdealer' or $docsType='ISDA2008EquityAsiaExcludingJapan' or $docsType='2004EquityEuropeanInterdealer' or $docsType='ISDA2007EquityEuropean' or $docsType='ISDA2008EquityJapanese'))">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid settlementType 'Election' in this context. 'Election' is valid only when product type is 'Equity Share Option' and brokerConfirmationType is 'ISDA2004EquityAmericasInterdealer' or 'ISDA2008EquityAmericas' or 'ISDA2009EquityAmericas' or 'EquityOptionAmericasPrivate' or 'ISDA2005EquityAsiaExcludingJapanInterdealer' or 'ISDA2008EquityAsiaExcludingJapan' or '2004EquityEuropeanInterdealer' or 'ISDA2007EquityEuropean' or 'ISDA2008EquityJapanese'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:settlementType='Election' and not(/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbEquityOptionDetails/fpml:swbDefaultSettlementMethod)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** If settlementType is equal to 'Election' then /SWBML/swbStructuredTradeDetails/swbExtendedTradeDetails/swbEquityOptionDetails/swbDefaultSettlementMethod must be present.</text>
</error>
</xsl:if>
<xsl:if test="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbEquityOptionDetails/fpml:swbDefaultSettlementMethod and fpml:settlementType!='Election'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** If settlementType is not equal to 'Election' then /SWBML/swbStructuredTradeDetails/swbExtendedTradeDetails/swbEquityOptionDetails/swbDefaultSettlementMethod must not be present.</text>
</error>
</xsl:if>
<xsl:variable name="settlementMethodElectionDateFieldApplicable">
<xsl:choose>
<xsl:when test="$docsType = 'ISDA2009EquityAmericas' and ($productType = 'Equity Share Option' or $productType='Equity Index Option') and fpml:settlementType = 'Election' ">true</xsl:when>
<xsl:when test="$docsType = 'EquityOptionAmericasPrivate' and ($productType = 'Equity Share Option' or $productType='Equity Index Option') and fpml:settlementType = 'Election' ">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:if test="fpml:settlementMethodElectionDate and $settlementMethodElectionDateFieldApplicable = 'false' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected settlementMethodElectionDate element encountered in this context.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:settlementMethodElectionDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:variable name="settlementMethodElectingPartyReferenceFieldApplicable">
<xsl:choose>
<xsl:when test="$docsType = 'ISDA2009EquityAmericas' and ($productType = 'Equity Share Option' or $productType='Equity Index Option') ">true</xsl:when>
<xsl:when test="$docsType = 'EquityOptionAmericasPrivate' and ($productType = 'Equity Share Option' or $productType='Equity Index Option') ">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:if test="fpml:settlementMethodElectingPartyReference and $settlementMethodElectingPartyReferenceFieldApplicable = 'false' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected settlementMethodElectingPartyReference element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:settlementMethodElectingPartyReference">
<xsl:variable name="electingParty">
<xsl:value-of select="fpml:settlementMethodElectingPartyReference/@href"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$electingParty='partyA'"/>
<xsl:when test="$electingParty='partyB'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid settlementMethodElectingPartyReference/@href value. Value = '<xsl:value-of select="$electingParty"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:apply-templates select="fpml:equityEuropeanExercise|fpml:equityAmericanExercise">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:settlementDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:equityValuation">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:equityValuation">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="($productType = 'Equity Share Option' and not ($docsType='EquityOptionAmericasPrivate' or $docsType='EquityOptionEuropePrivate' or $docsType='EquityOptionAEJPrivate' or $docsType='EquityOptionEMEAPrivate')) or ($productType='Equity Index Option' and not ($docsType='ISDA2005EquityAsiaExcludingJapanInterdealer' or $docsType = 'ISDA2008EquityAsiaExcludingJapan' or $docsType='EquityOptionAEJPrivate' or $docsType='ISDA2004EquityAmericasInterdealer' or $docsType='ISDA2008EquityAmericas'  or $docsType='ISDA2009EquityAmericas' or $docsType='EquityOptionAmericasPrivate' or $docsType='ISDA2008EquityJapanese' or $docsType='ISDA2010EquityEMEAInterdealer' or $docsType='EquityOptionEMEAPrivate' or $docsType='ISDA2005EquityJapaneseInterdealer' or $docsType='2004EquityEuropeanInterdealer' or $docsType='ISDA2007EquityEuropean' or $docsType='EquityOptionEuropePrivate'))">
<xsl:if test="not(count(child::*)=0)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected child elements  encountered in this context when product type is 'Equity Share Option' or when product type is 'Equity Index Option' and brokerConfirmationType is not 'ISDA2005EquityAsiaExcludingJapanInterdealer' or 'ISDA2008EquityAsiaExcludingJapan' or 'EquityOptionAEJPrivate' or 'ISDA2004EquityAmericasInterdealer' or 'ISDA2008EquityAmericas' or 'ISDA2009EquityAmericas' or 'EquityOptionAmericasPrivate' or 'ISDA2008EquityJapanese' or 'ISDA2010EquityEMEAInterdealer' or 'EquityOptionEMEAPrivate' or $docsType='ISDA2005EquityJapaneseInterdealer' or $docsType='2004EquityEuropeanInterdealer' or $docsType='ISDA2007EquityEuropean' or $docsType='EquityOptionEuropePrivate'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$productType = 'Equity Share Option' or $productType='Equity Index Option'">
<xsl:if test="(./@id !='valuationDate' or not(./@id)) and //fpml:equityExercise/fpml:settlementDate">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** @id must be present and must be equal to "valuationDate" in this context if //equityExercise/settlementDate is present and product type is 'Equity Share Option' or 'Equity Index Option'. Value = "<xsl:value-of select="./@id"/>".</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:valuationDate and ($productType = 'Equity Share Option' or $productType='Equity Index Option')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected valuationDate element encountered in this context when product type is 'Equity Share Option' or 'Equity Index Option'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:valuationDates">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected valuationDates element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:valuationTimeType">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected valuationTimeType element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:valuationTime">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected valuationTime element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:futuresPriceValuation and ($productType = 'Share Variance Swap' or ($productType='Equity Share Option' and not ($docsType='EquityOptionAmericasPrivate' or $docsType='EquityOptionEuropePrivate' or $docsType='EquityOptionAEJPrivate' or $docsType='EquityOptionEMEAPrivate')))">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected futuresPriceValuation element encountered in this context when product type is 'Share Variance Swap' or 'Equity Share Option'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:futuresPriceValuation and  ($productType='Equity Index Option' and not ($docsType='ISDA2005EquityAsiaExcludingJapanInterdealer' or $docsType = 'ISDA2008EquityAsiaExcludingJapan' or $docsType='ISDA2004EquityAmericasInterdealer' or $docsType='ISDA2008EquityAmericas' or $docsType='ISDA2009EquityAmericas' or $docsType='EquityOptionAmericasPrivate' or $docsType='ISDA2008EquityJapanese' or $docsType='ISDA2005EquityJapaneseInterdealer' or $docsType='EquityOptionAEJPrivate'or $docsType='2004EquityEuropeanInterdealer' or $docsType='ISDA2007EquityEuropean' or $docsType='EquityOptionEuropePrivate' or $docsType='ISDA2010EquityEMEAInterdealer' or $docsType='EquityOptionEMEAPrivate' ))">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected futuresPriceValuation element encountered in this context when product type is 'Equity Index Option' and brokerConfirmationType is not 'ISDA2005EquityAsiaExcludingJapanInterdealer' or 'ISDA2008EquityAsiaExcludingJapan' or 'ISDA2004EquityAmericasInterdealer' or 'ISDA2008EquityAmericas' or 'ISDA2009EquityAmericas' or 'EquityOptionAmericasPrivate' or 'ISDA2008EquityJapanese' or $docsType='ISDA2005EquityJapaneseInterdealer' or 'EquityOptionAEJPrivate' or $docsType='2004EquityEuropeanInterdealer' or $docsType='ISDA2007EquityEuropean' or $docsType='EquityOptionEuropePrivate' or 'ISDA2010EquityEMEAInterdealer' or 'EquityOptionEMEAPrivate'.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:futuresPriceValuation) and $productType='Equity Index Option' and ($docsType='ISDA2004EquityAmericasInterdealer' or $docsType='ISDA2008EquityAmericas' or $docsType='ISDA2009EquityAmericas' or $docsType='EquityOptionAmericasPrivate' or $docsType='ISDA2010EquityEMEAInterdealer' or $docsType='EquityOptionEMEAPrivate'
)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** futuresPriceValuation element must be present when product type is 'Equity Index Option' and brokerConfirmationType 'ISDA2004EquityAmericasInterdealer' or 'ISDA2008EquityAmericas' or 'ISDA2009EquityAmericas' or 'EquityOptionAmericasPrivate' or 'ISDA2010EquityEMEAInterdealer' or 'EquityOptionEMEAPrivate'.</text>
</error>
</xsl:if>
<xsl:choose>
<xsl:when test="fpml:futuresPriceValuation">
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">futuresPriceValuation</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:futuresPriceValuation"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:when>
</xsl:choose>
<xsl:if test="($productType='Equity Index Option') and ($docsType='ISDA2004EquityAmericasInterdealer')">
<xsl:if test="(fpml:futuresPriceValuation='true') and not(//fpml:equityExpirationTimeType='OSP')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** 'equityExpirationTimeType' must be 'OSP' where product type is 'Equity Index Option' and Docs Type is 'Equity Options(Americas) 2004 Interdealer' where futuresPriceValuation is 'True'.</text>
</error>
</xsl:if>
<xsl:if test="not (fpml:futuresPriceValuation='true') and (//fpml:equityExpirationTimeType='OSP')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** futuresPriceValuation must be 'True' where product type is 'Equity Index Option' and Docs Type is 'Equity Options (Americas) 2004 Interdealer' where 'equityExpirationTimeType' is 'OSP'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:futuresPriceValuation='true' and $productType='Equity Index Option' and ($docsType='ISDA2004EquityAmericasInterdealer') and not(//fpml:equityExpirationTimeType='OSP' or //fpml:equityExpirationTimeType='AsSpecifiedInMasterConfirmation' or //fpml:equityExpirationTimeType='Open' or //fpml:equityExpirationTimeType='Close')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** futuresPriceValuation should be 'False' where product type is 'Equity Index Option' and Docs Type is 'ISDA2004EquityAmericasInterdealer' unless 'equityExpirationTimeType' is 'OSP' or 'AsSpecifiedInMasterConfirmation' or 'Open' or 'Close'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:futuresPriceValuation='true' and $productType='Equity Index Option' and ($docsType='ISDA2008EquityAmericas') and not(//fpml:equityExpirationTimeType='OSP' or //fpml:equityExpirationTimeType='AsSpecifiedInMasterConfirmation')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** futuresPriceValuation should be 'False' where product type is 'Equity Index Option' and Docs Type is 'ISDA2008EquityAmericas' unless 'equityExpirationTimeType' is 'OSP' or 'AsSpecifiedInMasterConfirmation' .</text>
</error>
</xsl:if>
<xsl:if test="$productType='Equity Index Option' and $docsType='ISDA2008EquityAmericas' and not(//fpml:equityExpirationTimeType='OSP' or //fpml:equityExpirationTimeType='Close' or //fpml:equityExpirationTimeType='AsSpecifiedInMasterConfirmation')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** When product type is 'Equity Index Option' and Docs Type 'ISDA2008EquityAmericas' equityExpirationTimeType should be 'AsSpecifiedInMasterConfirmation', 'OSP' or 'Close'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:optionsPriceValuation">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected optionsPriceValuation element encountered in this context.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:valuationDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:valuationDate">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="fpml:relativeDate">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected relativeDate element encountered in this context.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:adjustableDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:settlementDate">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="fpml:adjustableDate">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected adjustableDate element encountered in this context.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:relativeDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:relativeDate">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:call-template name="isValidPeriodMultiplier">
<xsl:with-param name="elementName">periodMultiplier</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:periodMultiplier"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="$productType='Equity Share Swap' or $productType='Equity Index Swap' ">
<xsl:if test="ancestor::fpml:calculationStartDate or ancestor::fpml:calculationEndDate">
<xsl:if test="not(fpml:periodMultiplier = '0') ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** periodMultiplier must be equal to '0' in this context. Value = '<xsl:value-of select="fpml:periodMultiplier"/>'</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:period!='D'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** period must be equal to 'D' in this context. Value = '<xsl:value-of select="fpml:period"/>'</text>
</error>
</xsl:if>
<xsl:if test="fpml:dayType != 'CurrencyBusiness' and not(ancestor::fpml:valuationDates) ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** dayType must be equal to 'CurrencyBusiness' in this context. Value = '<xsl:value-of select="fpml:dayType"/>'</text>
</error>
</xsl:if>
<xsl:if test="fpml:dayType != 'ExchangeBusiness' and ancestor::fpml:valuationDates ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** dayType must be equal to 'ExchangeBusiness' in this context. Value = '<xsl:value-of select="fpml:dayType"/>'</text>
</error>
</xsl:if>
<xsl:if test="not($productType='Equity Share Swap' or $productType='Equity Index Swap') ">
<xsl:if test="fpml:businessDayConvention != 'NotApplicable'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** businessDayConvention must be equal to 'NotApplicable' in this context. Value = '<xsl:value-of select="fpml:businessDayConvention"/>'</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$productType='Equity Share Swap' or $productType='Equity Index Swap' ">
<xsl:if test="ancestor::fpml:calculationStartDate or ancestor::fpml:calculationEndDate">
<xsl:if test="not(fpml:businessDayConvention = 'NotApplicable') ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** businessDayConvention must be equal to 'NotApplicable' in this context. Value = '<xsl:value-of select="fpml:businessDayConvention"/>'</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="ancestor::fpml:fixingDates">
<xsl:if test="not(fpml:businessDayConvention = 'PRECEDING') ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** businessDayConvention must be equal to 'PRECEDING' in this context. Value = '<xsl:value-of select="fpml:businessDayConvention"/>'</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:businessCentersReference">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected businessCentersReference element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:businessCenters and not($productType='Equity Share Swap' or $productType='Equity Index Swap')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected businessCenters element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="$productType='Equity Share Swap' or $productType='Equity Index Swap' ">
<xsl:if test="fpml:businessCenters and (ancestor::fpml:calculationStartDate or ancestor::fpml:calculationEndDate) ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected businessCenters element encountered in this context.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:dateRelativeTo/@href != 'valuationDate' and not($productType='Equity Share Swap' or $productType='Equity Index Swap')  ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** dateRelativeTo/@href must be equal to 'valuationDate' in this context. Value = '<xsl:value-of select="fpml:dateRelativeTo/@href"/>'</text>
</error>
</xsl:if>
<xsl:if test="$productType='Equity Share Swap' or $productType='Equity Index Swap' ">
<xsl:if test="ancestor::fpml:fixingDates and fpml:dateRelativeTo/@href != 'interestLegPaymentDates' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** dateRelativeTo/@href must be equal to 'interestLegPaymentDates' in this context. Value = '<xsl:value-of select="fpml:dateRelativeTo/@href"/>'</text>
</error>
</xsl:if>
<xsl:if test="(name(../../..) = 'interestLegPaymentDates' and name(..) = 'calculationStartDate') and fpml:dateRelativeTo/@href != 'interestEffectiveDate' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** dateRelativeTo/@href must be equal to 'interestEffectiveDate' in this context. Value = '<xsl:value-of select="fpml:dateRelativeTo/@href"/>'</text>
</error>
</xsl:if>
<xsl:if test="(name(../../..) = 'interestLegPaymentDates' and name(..) = 'calculationEndDate') and fpml:dateRelativeTo/@href != 'interestTerminationDate' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** dateRelativeTo/@href must be equal to 'interestTerminationDate' in this context. Value = '<xsl:value-of select="fpml:dateRelativeTo/@href"/>'</text>
</error>
</xsl:if>
<xsl:if test="(name(../../..) = 'valuationDates' and name(..) = 'calculationStartDate') and fpml:dateRelativeTo/@href != 'equityEffectiveDate' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** dateRelativeTo/@href must be equal to 'equityEffectiveDate' in this context. Value = '<xsl:value-of select="fpml:dateRelativeTo/@href"/>'</text>
</error>
</xsl:if>
<xsl:if test="(name(../../..) = 'valuationDates' and name(..) = 'calculationEndDate') and fpml:dateRelativeTo/@href != 'finalValuationDate' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** dateRelativeTo/@href must be equal to 'finalValuationDate' in this context. Value = '<xsl:value-of select="fpml:dateRelativeTo/@href"/>'</text>
</error>
</xsl:if>
<xsl:if test="ancestor::fpml:paymentDateFinal and fpml:dateRelativeTo/@href != 'finalValuationDate' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** dateRelativeTo/@href must be equal to 'finalValuationDate' in this context. Value = '<xsl:value-of select="fpml:dateRelativeTo/@href"/>'</text>
</error>
</xsl:if>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:feature">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="not(($productType='Equity Index Option' or $productType='Equity Share Option') and fpml:knock and ($docsType!='Equity Options (Spread)' or $docsType != 'Equity Options (Cliquet)'))">
<xsl:if test="not(/fpml:SWBML//fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbEquityOptionDetails/fpml:swbAveragingDates)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbAveragingDates sequence is compulsory when an Asian feature exists.</text>
</error>
</xsl:if>
<xsl:if test="fpml:barrier">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected barrier element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:knock">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected knock element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:passThrough">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected passThrough element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:asian/fpml:averagingInOut='Out')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** asian/averagingInOut must be equal to 'Out' in this context. Value = '<xsl:value-of select="fpml:asian/fpml:averagingInOut"/>'</text>
</error>
</xsl:if>
<xsl:if test="fpml:asian/fpml:strikeFactor">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected strikeFactor element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:asian/fpml:averagingPeriodIn">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected averagingPeriodIn element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:asian/fpml:averagingPeriodOut)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Expected averagingPeriodOut element not encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:asian/fpml:averagingPeriodOut/fpml:schedule">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected schedule element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:asian/fpml:averagingPeriodOut/fpml:averagingDateTimes)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Expected averagingDateTimes element not encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:asian/fpml:averagingPeriodOut/fpml:averagingDateTimes/fpml:dateTime)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Expected DateTime element not encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:asian/fpml:averagingPeriodOut/fpml:marketDisruption)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Expected marketDisruption element not encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="not(/fpml:SWBML//fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbEquityOptionDetails/fpml:swbAveragingDates/fpml:swbAveragingFrequency)">
<error>
<text>*** ExpectedswbAveragingFrequency element not encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="not(/fpml:SWBML//fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbEquityOptionDetails/fpml:swbAveragingDates/fpml:swbAveragingFrequency ='Custom')">
<error>
<text>***Averaging Frequency must be equal to 'Custom' in this context.</text>
</error>
</xsl:if>
<xsl:if test="not(/fpml:SWBML//fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbEquityOptionDetails/fpml:swbAveragingDates/fpml:swbAveragingStart)">
<error>
<text>*** Expected swbAveragingStart element not encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="not(/fpml:SWBML//fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbEquityOptionDetails/fpml:swbAveragingDates/fpml:swbAveragingEnd)">
<error>
<text>*** Expected swbAveragingEnd element not encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:asian/fpml:averagingPeriodOut/fpml:marketDisruption = 'Modified Postponement' or fpml:asian/fpml:averagingPeriodOut/fpml:marketDisruption= 'Omission' or  fpml:asian/fpml:averagingPeriodOut/fpml:marketDisruption= 'Postponement')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** marketDisruptionScheme must be equal to 'ModifiedPostponement' or 'Omission' or 'Postponement' in this context. Value = '<xsl:value-of select="fpml:asian/fpml:averagingPeriodOut/fpml:marketDisruption"/>'</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="($productType='Equity Index Option' or $productType='Equity Share Option') and fpml:knock and ($docsType!='Equity Options (Spread)' or $docsType != 'Equity Options (Cliquet)')">
<xsl:if test="(fpml:knock/fpml:knockIn) and (fpml:knock/fpml:knockOut)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Only one of Knock In and Knock Out is expected.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:knock">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:fxFeature">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:call-template name="isValidReferenceCurrency">
<xsl:with-param name="elementName">referenceCurrency</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:referenceCurrency"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="fpml:composite|fpml:crossCurrency">
<xsl:apply-templates select="fpml:composite|fpml:crossCurrency">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
<xsl:if test="fpml:quanto">
<xsl:apply-templates select="fpml:quanto">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:composite|fpml:crossCurrency">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="fpml:determinationMethod">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected determinationMethod in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:relativeDate">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected relativeDate in this context.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:fxSpotRateSource">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="/fpml:SWBML//fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbEquityOptionDetails/fpml:swbEquityOptionPercentInput and not (/fpml:SWBML//fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbEquityOptionDetails/fpml:swbReferenceFXRate)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbReferenceFXRate expected in this context.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:fxSpotRateSource">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:apply-templates select="fpml:primaryRateSource">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:secondaryRateSource">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected secondaryRateSource in this context.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:fixingTime">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:primaryRateSource">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:call-template name="isValidRateSource">
<xsl:with-param name="elementName">rateSource</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:rateSource"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:variable name="rateSourcePageScheme">
<xsl:value-of select="fpml:rateSourcePage/@rateSourcePageScheme"/>
</xsl:variable>
<xsl:if test="$rateSourcePageScheme != 'http://www.swapswire.com/spec/2006/rate-source-page-1-0'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or unrecognised rateSourcePage/@rateSourcePageScheme attribute value. Value = '<xsl:value-of select="$rateSourcePageScheme"/>'.</text>
</error>
</xsl:if>
<xsl:call-template name="isValidRateSourcePage">
<xsl:with-param name="elementName">rateSourcePage</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:rateSourcePage"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="fpml:rateSourcePageHeading">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected rateSourcePageHeading in this context.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:fixingTime">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
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
<xsl:template match="fpml:quanto">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="not(count(child::*)=0)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected child elements  encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="/fpml:SWBML//fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbEquityOptionDetails/fpml:swbEquityOptionPercentInput and not (/fpml:SWBML//fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbEquityOptionDetails/fpml:swbReferenceFXRate)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbReferenceFXRate expected in this context.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:strike">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="fpml:strikePrice">
<xsl:if test="$docsType='2004EquityEuropeanInterdealer' or $docsType='ISDA2004EquityAmericasInterdealer' or $docsType='ISDA2007EquityEuropean' or $docsType='EquityOptionEuropePrivate' or $docsType='ISDA2008EquityAmericas' or $docsType='ISDA2009EquityAmericas' or $docsType='EquityOptionAmericasPrivate' or $docsType='ISDA2010EquityEMEAInterdealer' or $docsType='EquityOptionEMEAPrivate' ">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">strikePrice</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:strikePrice"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">1000000.00000</xsl:with-param>
<xsl:with-param name="maxDecs">5</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="$docsType='ISDA2005EquityJapaneseInterdealer' or $docsType = 'ISDA2008EquityJapanese' or $docsType='ISDA2005EquityAsiaExcludingJapanInterdealer' or $docsType = 'ISDA2008EquityAsiaExcludingJapan' or $docsType='EquityOptionAEJPrivate'">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">strikePrice</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:strikePrice"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">9999999.999999</xsl:with-param>
<xsl:with-param name="maxDecs">6</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:strikePercentage">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected strikePercentage element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="$productType='Equity Share Option'">
<xsl:if test="not(fpml:currency)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing currency element. Required in this context.</text>
</error>
</xsl:if>
<xsl:if test="not($docsType = 'ISDA2008EquityJapanese' or $docsType='ISDA2010EquityEMEAInterdealer' or $docsType='EquityOptionEMEAPrivate' or $docsType='2004EquityEuropeanInterdealer' or $docsType='ISDA2007EquityEuropean' or $docsType='EquityOptionEuropePrivate' or $docsType = 'EquityOptionAmericasPrivate')">
<xsl:if test="not(fpml:currency = //fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:equityPremium/fpml:paymentAmount/fpml:currency) and not(/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:fxFeature/fpml:crossCurrency or /fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:fxFeature/fpml:quanto)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The currency must equal equityPremium/paymentAmount/currency unless option is Cross-Currency or Quanto settled.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="not(fpml:currency = //fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:fxFeature/fpml:referenceCurrency) and (//fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:fxFeature/fpml:crossCurrency or //fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:fxFeature/fpml:quanto)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The currency must equal fxFeature/referenceCurrency when option is Cross-Currency or Quanto settled.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:currency and $productType='Equity Index Option'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected currency element encountered in this context when product type is 'Equity Index Option'.</text>
</error>
</xsl:if>
</xsl:when>
<xsl:when test="fpml:strikePercentage">
<xsl:if test="fpml:strikePercentage and $docsType != '2004EquityEuropeanInterdealer' and $docsType !='ISDA2008EquityAsiaExcludingJapan' and $docsType !='ISDA2007EquityEuropean' and $docsType !='EquityOptionEuropePrivate' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected strikePercentage element encountered in this context. Forward-starting options are only supported under the European Options MCA, and the 2008 AEJ MCA. Submitted brokerConfirmationType = '<xsl:value-of select="$docsType"/>'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:strikePrice">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected strikePrice element encountered in this context. Forward-starting trades should have their strike expressed as a strikePercentage to be determined on the strikDeterminationDate.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:strikeDeterminationDate)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing strikeDeterminationDate element in this context. Forward-starting trades should have their strike expressed as a strikePercentage to be determined on the strikDeterminationDate.</text>
</error>
</xsl:if>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">strikePercentage</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:strikePercentage"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">9.99999999</xsl:with-param>
<xsl:with-param name="maxDecs">8</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">strikeDeterminationDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:strikeDeterminationDate/fpml:adjustableDate/fpml:unadjustedDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="fpml:currency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected currency element encountered in this context when trade is forward starting.</text>
</error>
</xsl:if>
</xsl:when>
</xsl:choose>
</xsl:template>
<xsl:template match="fpml:equityPremium">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="not(fpml:payerPartyReference/@href = /fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:buyerPartyReference/@href)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid payerPartyReference/@href attribute value. The payerPartyReference/@href must be equal to //FpML/trade/equityOptionTransactionSupplement/buyerPartyReference/@href (payer of premium is option buyer).</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:receiverPartyReference/@href = /fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:sellerPartyReference/@href)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid receiverPartyReference/@href attribute value. The receiverPartyReference/@href must be equal to //FpML/trade/equityOptionTransactionSupplement/sellerPartyReference/@href (receiver of premium is option seller).</text>
</error>
</xsl:if>
<xsl:if test="fpml:premiumType">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected premiumType element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:paymentAmount)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing paymentAmount element. Required in this context.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:paymentAmount">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="not(fpml:paymentAmount/fpml:currency = fpml:pricePerOption/fpml:currency)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The paymentAmount/currency and pricePerOption/currency must be equal.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:paymentDate)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing paymentDate element. Required in this context.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:paymentDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:swapPremium">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swapPremium element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:pricePerOption)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing pricePerOption element. Required in this context.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:pricePerOption">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:percentageOfNotional">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected percentageOfNotional element encountered in this context.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:paymentDate">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:apply-templates select="fpml:dateAdjustments">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:dateAdjustments | fpml:calculationPeriodDatesAdjustments">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="ancestor::fpml:returnLeg and ancestor::fpml:terminationDate">
<xsl:if test="not(fpml:businessDayConvention = //fpml:valuationPriceFinal/fpml:valuationRules/fpml:valuationDate/fpml:adjustableDate//fpml:businessDayConvention)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** returnLeg/terminationDate//fpml:businessDayConvention must be equal to valuationPriceFinal/valuationRules/valuationDate//fpml:businessDayConvention.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="not(fpml:businessDayConvention[.='NotApplicable']) and not($productType = 'Equity Share Swap' or $productType = 'Equity Index Swap' or $productType = 'Equity Index Option')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid businessDayConvention element value. Must contain 'NotApplicable' when product type is other than 'Equity Swap'.</text>
</error>
</xsl:if>
<xsl:variable name="businessDayConvention">
<xsl:value-of select="fpml:businessDayConvention"/>
</xsl:variable>
<xsl:if test="$productType = 'Equity Share Swap' or $productType = 'Equity Index Swap' or $productType = 'Equity Index Option'">
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
</xsl:if>
<xsl:if test="fpml:businessCenters and not($productType = 'Equity Share Swap' or $productType = 'Equity Index Swap') ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected businessCenters element encountered in this context when product type is other than 'Equity Swap'.</text>
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
<xsl:if test="$businessDayConvention != 'NONE' and $businessDayConvention != 'NotApplicable'">
<xsl:if test="($productType = 'Equity Share Swap' or $productType = 'Equity Index Swap') and not(fpml:businessCenters)">
<xsl:if test="fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbEquitySwapDetails/fpml:swbSchedulingMethod!='ListDateEntry' or fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbEquitySwapDetails/fpml:swbSchedulingMethod='' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing businessCenters. Needed when businessDayConvention not equal to 'NONE' or 'NotApplicable'.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:businessCentersReference">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected businessCentersReference element encountered in this context.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:pricePerOption">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="$docsType='2004EquityEuropeanInterdealer' or $docsType='ISDA2007EquityEuropean' or $docsType='EquityOptionEuropePrivate' ">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">amount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:amount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">999999.99999</xsl:with-param>
<xsl:with-param name="maxDecs">5</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="$docsType='ISDA2004EquityAmericasInterdealer' or $docsType='ISDA2008EquityAmericas' or $docsType='ISDA2009EquityAmericas' or $docsType='EquityOptionAmericasPrivate' or $docsType='ISDA2010EquityEMEAInterdealer' or $docsType='EquityOptionEMEAPrivate' ">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">amount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:amount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">999999.999999</xsl:with-param>
<xsl:with-param name="maxDecs">6</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test=" $docsType='ISDA2005EquityAsiaExcludingJapanInterdealer' or $docsType='EquityOptionAEJPrivate' or $docsType='ISDA2008EquityAsiaExcludingJapan'">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">amount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:amount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">999999.999999999</xsl:with-param>
<xsl:with-param name="maxDecs">9</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="$docsType='ISDA2005EquityJapaneseInterdealer' or $docsType = 'ISDA2008EquityJapanese'">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">amount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:amount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">999999.99999</xsl:with-param>
<xsl:with-param name="maxDecs">5</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:swVolatilitySwapTransactionSupplement">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="$productType='Equity Share Volatility Swap' or $productType='Equity Index Volatility Swap'">
<xsl:if test="fpml:productType">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected productType element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:productId">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected productId element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:equityLeg">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected equityLeg element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:interestLeg">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected interestLeg element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:returnLeg">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected returnLeg element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:swVolatilityLeg)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Volatility Leg is missing and expected in this context..</text>
</error>
</xsl:if>
<xsl:if test="fpml:principalExchangeFeatures">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected principalExchangeFeatures element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:mutualEarlyTermination">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected mutualEarlyTermination element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:localJurisdiction and ($productType = 'Equity Index Volatility Swap' or $docsType!='VolatilitySwapAsiaExcludingJapanPrivate')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected localJurisdiction element encountered in this context when Product Type is 'Equity Index Volatility Swap' or Docs Type is not 'Volatility Swap (AEJ)'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:localJurisdiction">
<xsl:call-template name="isValidLocalJurisdiction">
<xsl:with-param name="elementName">localJurisdiction</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:localJurisdiction"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:componentSecurityIndexAnnexFallback">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected componentSecurityIndexAnnexFallback element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:relevantJurisdiction">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected relevantJurisdiction element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:multipleExchangeIndexAnnexFallback and ($productType='Equity Share Volatility Swap' or $docsType='VolatilitySwapJapanesePrivate' or $docsType='VolatilitySwapAmericasPrivate')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected multipleExchangeIndexAnnexFallback element encountered in this contex when product type is 'Equity Share Volatility Swap' or when Docs Type is 'Volatility Swap (Japan)' or 'Volatility Swap (Americas)'.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:swVolatilityLeg">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:varianceSwapTransactionSupplement">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="$productType='Dispersion Variance Swap'">
<xsl:if test="fpml:productType">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected productType element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:productId">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected productId element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:varianceLeg)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected equityLeg element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:localJurisdiction">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected mutualEarlyTermination element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:relevantJurisdiction">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected mutualEarlyTermination element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:multipleExchangeIndexAnnexFallback">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected multipleExchangeIndexAnnexFallback element encountered in this context.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:varianceLeg">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:valuation">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="fpml:valuationDates">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected valuationDates element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:valuationTimeType">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected valuationTimeType element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:valuationTime">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected valuationTime element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:futuresPriceValuation and (//fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:varianceSwapTransactionSupplement/fpml:underlyer/fpml:singleUnderlyer//fpml:equity or //fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:swVolatilitySwapTransactionSupplement/fpml:underlyer/fpml:singleUnderlyer//fpml:equity)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected futuresPriceValuation element encountered in this context when underlyer is a share</text>
</error>
</xsl:if>
<xsl:choose>
<xsl:when test="fpml:futuresPriceValuation">
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">futuresPriceValuation</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:futuresPriceValuation"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:when>
</xsl:choose>
<xsl:if test="fpml:optionsPriceValuation">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected optionsPriceValuation element encountered in this context.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:valuationDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:equityEuropeanExercise">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:apply-templates select="fpml:expirationDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:variable name="equityExpirationTimeFieldApplicable">
<xsl:choose>
<xsl:when test="$docsType = 'ISDA2009EquityAmericas' and ($productType = 'Equity Index Option' or $productType = 'Equity Share Option') and fpml:equityExpirationTimeType = 'SpecificTime' ">true</xsl:when>
<xsl:when test="$docsType = 'EquityOptionAmericasPrivate' and ($productType = 'Equity Index Option' or $productType = 'Equity Share Option') and fpml:equityExpirationTimeType = 'SpecificTime' ">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:if test="fpml:equityExpirationTime and $equityExpirationTimeFieldApplicable = 'false' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected equityExpirationTime element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:equityExpirationTime">
<xsl:call-template name="isValidHourMinuteTime">
<xsl:with-param name="elementName">equityExpirationTime/hourMinuteTime</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:equityExpirationTime/fpml:hourMinuteTime"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:call-template name="isValidEquityExpirationTimeType">
<xsl:with-param name="elementName">equityExpirationTimeType</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:equityExpirationTimeType"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="$productType = 'Equity Index Option' and ($docsType='ISDA2008EquityAmericas')">
<xsl:if test="fpml:equityExpirationTimeType='OSP' and not(//fpml:futuresPriceValuation='true')">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** When product type is 'Equity Index Option'  and Docs Type is 'ISDA2008EquityAmericas', the 'OSP' can only be supplied when fpml:futuresPriceValuation is 'true'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$productType = 'Equity Share Option' and ($docsType='ISDA2004EquityAmericasInterdealer')">
<xsl:if test="(fpml:equityExpirationTimeType='Open') and not(fpml:settlementType='Cash') and not(//fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:equityExercise/fpml:equityAmericanExercise)">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>***  When product type is 'Equity Share Option' and Docs Type is 'ISDA2004EquityAmericasInterdealer', 'Open' can only be supplied when option style is 'American' and SettlementType is 'Cash'.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:expirationDate|fpml:commencementDate|fpml:settlementMethodElectionDate">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="fpml:relativeDate">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected relativeDate element encountered in this context.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:adjustableDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:equityAmericanExercise">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
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
<xsl:if test="not(fpml:commencementDate/fpml:adjustableDate/fpml:unadjustedDate = //fpml:FpML/fpml:trade/fpml:tradeHeader/fpml:tradeDate)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The commencementDate/adjustableDate/unadjustedDate must equal the //FpML/trade/tradeHeader/tradeDate (American exercise period must commence on the trade date).</text>
</error>
</xsl:if>
<xsl:if test="fpml:latestExerciseTime">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected latestExerciseTime element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:latestExerciseTimeType">
<xsl:choose>
<xsl:when test="$docsType='ISDA2009EquityAmericas'"/>
<xsl:when test="$docsType='EquityOptionAmericasPrivate'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected latestExerciseTimeType element encountered in this context.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:variable name="equityExpirationTimeFieldApplicable">
<xsl:choose>
<xsl:when test="$docsType = 'ISDA2009EquityAmericas' and ($productType = 'Equity Index Option' or $productType = 'Equity Share Option') and fpml:equityExpirationTimeType = 'SpecificTime' ">true</xsl:when>
<xsl:when test="$docsType = 'EquityOptionAmericasPrivate' and ($productType = 'Equity Index Option' or $productType = 'Equity Share Option') and fpml:equityExpirationTimeType = 'SpecificTime' ">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:if test="fpml:equityExpirationTime and $equityExpirationTimeFieldApplicable = 'false' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected equityExpirationTime element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:equityExpirationTime">
<xsl:call-template name="isValidHourMinuteTime">
<xsl:with-param name="elementName">equityExpirationTime/hourMinuteTime</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:equityExpirationTime/fpml:hourMinuteTime"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:equityExpirationTime/fpml:businessCenter">
<xsl:if test="not(fpml:equityExpirationTime/fpml:businessCenter = 'NotApplicable')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid businessCenter element value. Must contain 'NotApplicable' in this context. Value = '<xsl:value-of select="fpml:equityExpirationTime/fpml:businessCenter"/>
</text>
</error>
</xsl:if>
</xsl:if>
<xsl:call-template name="isValidEquityExpirationTimeType">
<xsl:with-param name="elementName">equityExpirationTimeType</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:equityExpirationTimeType"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:variable name="equityMultipleExerciseFieldApplicable">
<xsl:choose>
<xsl:when test="$docsType = 'ISDA2009EquityAmericas' ">true</xsl:when>
<xsl:when test="$docsType = 'EquityOptionAmericasPrivate' ">true</xsl:when>
<xsl:when test="$docsType = 'ISDA2010EquityEMEAInterdealer' ">true</xsl:when>
<xsl:when test="$docsType = 'EquityOptionEMEAPrivate' ">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:if test="fpml:equityMultipleExercise and $equityMultipleExerciseFieldApplicable = 'false' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected equityMultipleExercise element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="$productType = 'Equity Index Option' and ($docsType='ISDA2008EquityAmericas')">
<xsl:if test="fpml:equityExpirationTimeType='OSP' and not(//fpml:futuresPriceValuation='true')">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** When product type is 'Equity Index Option'  and Docs Type is 'ISDA2008EquityAmericas', the 'OSP' can only be supplied when fpml:futuresPriceValuation is 'true'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$productType = 'Equity Share Option' and ($docsType='ISDA2004EquityAmericasInterdealer' or $docsType='ISDA2008EquityAmericas')">
<xsl:if test="(fpml:equityExpirationTimeType='Open' or fpml:equityExpirationTimeType='Close') and not(fpml:settlementType='Cash') and not(//fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:equityExercise/fpml:equityAmericanExercise)">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>***  When product type is 'Equity Share Option'  and Docs Type is 'ISDA2004EquityAmericasInterdealer' or 'ISDA2008EquityAmericas', the 'Open' and 'Close' can only be supplied when option style is 'American' and SettlementType is 'Cash'.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:dividendSwapTransactionSupplement">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="fpml:productType">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected productType element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:productId">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected productId element encountered in this context.</text>
</error>
</xsl:if>
<xsl:variable name="payer">
<xsl:value-of select="fpml:dividendLeg/fpml:payerPartyReference/@href"/>
</xsl:variable>
<xsl:if test="not(/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:party[@id=$payer])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The payerPartyReference/@href value does not match an //FpML/party/@id value for any party. Value = '<xsl:value-of select="$payer"/>'.</text>
</error>
</xsl:if>
<xsl:variable name="receiver">
<xsl:value-of select="fpml:dividendLeg/fpml:receiverPartyReference/@href"/>
</xsl:variable>
<xsl:if test="not(/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:party[@id=$receiver])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The receiverPartyReference/@href value does not match an //FpML/party/@id value for any party. Value = '<xsl:value-of select="$receiver"/>'.</text>
</error>
</xsl:if>
<xsl:if test="$payer=$receiver">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** payerPartyReference/@href and receiverPartyReference/@href values are the same.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:dividendLeg/fpml:underlyer/fpml:singleUnderlyer//fpml:instrumentId)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Expected instrumentId element not found in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:dividendLeg/fpml:underlyer/fpml:singleUnderlyer//fpml:currency">
<xsl:call-template name="isValidCurrency">
<xsl:with-param name="elementName">currency</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:dividendLeg/fpml:underlyer/fpml:singleUnderlyer//fpml:currency"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="$docsType='ISDA2008DividendSwapJapan' or $docsType='ISDA2008DividendSwapJapaneseRev1'">
<xsl:if test="not(fpml:dividendLeg/fpml:underlyer/fpml:singleUnderlyer/fpml:index/fpml:exchangeId = 'TYO') ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected exchangeId value encountered in this context. The value must be 'TYO' </text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="not($docsType='ISDA2008DividendSwapJapan' or $docsType='ISDA2008DividendSwapJapaneseRev1')">
<xsl:if test="not(fpml:dividendLeg/fpml:underlyer/fpml:singleUnderlyer//fpml:relatedExchangeId)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Expected relatedExchangeId element not found in this context.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$docsType='ISDA2008DividendSwapJapan' or $docsType='ISDA2008DividendSwapJapaneseRev1'">
<xsl:if test="fpml:dividendLeg/fpml:underlyer/fpml:singleUnderlyer//fpml:relatedExchangeId">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected relatedExchangeId element encountered in this context.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="not(fpml:dividendLeg/fpml:underlyer/fpml:singleUnderlyer/fpml:openUnits)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** MissingopenUnits element in this context.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:dividendLeg/fpml:settlementType)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing settlementType element in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:dividendLeg/fpml:settlementDate">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected settlementDate element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:dividendLeg/fpml:effectiveDate">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected effectiveDate element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:dividendLeg/fpml:terminationDate">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected terminationDate element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:dividendLeg/fpml:fxFeature">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected fxFeature element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:dividendLeg/fpml:settlementType='Cash')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***Settlement Type must be equal to 'Cash' in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:dividendLeg/fpml:settlementAmount">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** settlementAmount element encountered, not expected in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:dividendLeg/fpml:settlementCurrency">
<xsl:call-template name="isValidCurrency">
<xsl:with-param name="elementName">settlementCurrency</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:dividendLeg/fpml:settlementCurrency"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="not(fpml:dividendLeg/fpml:settlementCurrency)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing settlementCurrency element, expected in this context.</text>
</error>
</xsl:if>
<xsl:if test="not($docsType='ISDA2008DividendSwapJapan' or $docsType='ISDA2008DividendSwapJapaneseRev1')">
<xsl:if test="not(fpml:dividendLeg/fpml:declaredCashDividendPercentage)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing declaredCashDividendPercentage element in this context.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:dividendLeg/fpml:declaredCashEquivalentDividendPercentage)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing declaredCashEquivalentDividendPercentage element in this context.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$docsType='ISDA2008DividendSwapJapan' or $docsType='ISDA2008DividendSwapJapaneseRev1'">
<xsl:if test="fpml:dividendLeg/fpml:declaredCashDividendPercentage">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected declaredCashDividendPercentage element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:dividendLeg/fpml:declaredCashEquivalentDividendPercentage">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected declaredCashEquivalentDividendPercentage element encountered in this context.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:dividendLeg/fpml:declaredCashDividendPercentage">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">declaredCashDividendPercentage</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:dividendLeg/fpml:declaredCashDividendPercentage"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.0001</xsl:with-param>
<xsl:with-param name="maxIncl">9.9999</xsl:with-param>
<xsl:with-param name="maxDecs">4</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:dividendLeg/fpml:declaredCashEquivalentDividendPercentage">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">declaredCashEquivalentDividendPercentage</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:dividendLeg/fpml:declaredCashEquivalentDividendPercentage"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.0001</xsl:with-param>
<xsl:with-param name="maxIncl">9.9999</xsl:with-param>
<xsl:with-param name="maxDecs">4</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="not(fpml:dividendLeg/fpml:dividendPeriod)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing dividendPeriod element in this context.</text>
</error>
</xsl:if>
<xsl:variable name="reldate1">
<xsl:value-of select="fpml:dividendLeg/fpml:dividendPeriod/fpml:paymentDate/fpml:relativeDate/fpml:periodMultiplier"/>
</xsl:variable>
<xsl:variable name="relmult1">
<xsl:value-of select="fpml:dividendLeg/fpml:dividendPeriod/fpml:paymentDate/fpml:relativeDate/fpml:period"/>
</xsl:variable>
<xsl:if test="count(fpml:dividendLeg/fpml:dividendPeriod) != count(fpml:fixedLeg/fpml:fixedPayment)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Number of Dividend Periods (<xsl:value-of select="count(fpml:dividendLeg/fpml:dividendPeriod)"/>) is different to the number of Fixed payments (<xsl:value-of select="count(fpml:fixedLeg/fpml:fixedPayment)"/>) in this context.</text>
</error>
</xsl:if>
<xsl:for-each select="fpml:dividendLeg/fpml:dividendPeriod">
<xsl:variable name="divid">
<xsl:value-of select="./@id"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$divid != ''"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Empty dividendPeriod/@id attribute.</text>
</error>
</xsl:otherwise>
</xsl:choose>
<xsl:if test="not(fpml:unadjustedStartDate)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing element in this context.</text>
</error>
</xsl:if>
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">unadjustedStartDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:unadjustedStartDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="not(fpml:unadjustedEndDate)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing unadjusted end date element expected  in this context.</text>
</error>
</xsl:if>
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">unadjustedEndDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:unadjustedEndDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="not($docsType='ISDA2008DividendSwapJapan' or $docsType='ISDA2008DividendSwapJapaneseRev1')">
<xsl:variable name="endid">
<xsl:value-of select="fpml:unadjustedEndDate/@id"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$endid != ''"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Empty unadjustedEndDate/@id attribute.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="not(fpml:dateAdjustments)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing dateadjustments element in this context.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:paymentDate/fpml:relativeDate/fpml:businessDayConvention)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing businessDayConention element in this context.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:paymentDate/fpml:relativeDate/fpml:businessDayConvention[.='FOLLOWING'])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid businessDayConvention element value. Must contain 'FOLLOWING' when product type is 'Share Dividend Swap' or 'Index Dividend Swap'</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:dateAdjustments/fpml:businessDayConvention[.='NotApplicable'])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid businessDayConvention element value. Must contain 'NotApplicable' when product type is 'Share Dividend Swap' or 'Index Dividend Swap'</text>
</error>
</xsl:if>
<xsl:if test="fpml:dateAdjustments/fpml:businessCentersReference">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected businessCentersReference element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:dateAdjustments/fpml:businessCenters">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected businessCenters element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:fixedStrike)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing fixedStrike element in this context.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:paymentDate)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing paymentDate 1 element, expected in this context.</text>
</error>
</xsl:if>
<xsl:variable name="payid">
<xsl:value-of select="fpml:paymentDate/@id"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$payid != ''"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Empty paymentDate/@id attribute.</text>
</error>
</xsl:otherwise>
</xsl:choose>
<xsl:call-template name="isValidPeriodMultiplier">
<xsl:with-param name="elementName">periodMultiplier</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:paymentDate/fpml:relativeDate/fpml:periodMultiplier"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="fpml:paymentDate/fpml:adjustableDate">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected adjustableDate element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:paymentDate/fpml:relativeDate/@id">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected @id element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:paymentDate/fpml:relativeDate/fpml:period!='D'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** period must be equal to 'D' in this context. Value = '<xsl:value-of select="fpml:paymentDate/fpml:relativeDate/fpml:period"/>'</text>
</error>
</xsl:if>
<xsl:variable name="reldate2">
<xsl:value-of select="fpml:paymentDate/fpml:relativeDate/fpml:periodMultiplier"/>
</xsl:variable>
<xsl:if test="$reldate1!= $reldate2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** dividendPeriod multipliers do not match. Value = '<xsl:value-of select="$reldate1"/>' Value = '<xsl:value-of select="$reldate2"/>'</text>
</error>
</xsl:if>
<xsl:variable name="relmult2">
<xsl:value-of select="fpml:paymentDate/fpml:relativeDate/fpml:period"/>
</xsl:variable>
<xsl:if test="$relmult1!= $relmult2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** dividendPeriod periods do not match. Value = '<xsl:value-of select="$relmult1"/>' Value = '<xsl:value-of select="$relmult2"/>'</text>
</error>
</xsl:if>
<xsl:if test="fpml:paymentDate/fpml:relativeDate/fpml:dayType">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected dayType element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:paymentDate/fpml:relativeDate/fpml:businessDayConvention)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing   businessDayConvention element, expected in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:paymentDate/fpml:relativeDate/fpml:businessCenters">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected businessCenters element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:paymentDate/fpml:relativeDate/fpml:businessCentersReference">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected businessCentersReference element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:paymentDate/fpml:relativeDate/fpml:dateRelativeTo/@href)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing dateRelativeTo element reference, expected in this context.</text>
</error>
</xsl:if>
<xsl:variable name="dividendLegDateRelativeTo_href">
<xsl:value-of select="fpml:paymentDate/fpml:relativeDate/fpml:dateRelativeTo/@href"/>
</xsl:variable>
<xsl:if test="$docsType='ISDA2008DividendSwapJapan' or $docsType='ISDA2008DividendSwapJapaneseRev1'">
<xsl:if test="not(fpml:valuationDate[@id=$dividendLegDateRelativeTo_href])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The dateRelativeTo/@href value does not match the valuationDate/@id value. Value = '<xsl:value-of select="$dividendLegDateRelativeTo_href"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="not($docsType='ISDA2008DividendSwapJapan' or $docsType='ISDA2008DividendSwapJapaneseRev1')">
<xsl:if test="not(fpml:unadjustedEndDate[@id=$dividendLegDateRelativeTo_href])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The dateRelativeTo/@href value does not match the unadjustedEndDate/@id value. Value = '<xsl:value-of select="$dividendLegDateRelativeTo_href"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:fixedStrike">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">fixedStrike</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:fixedStrike"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.00001</xsl:with-param>
<xsl:with-param name="maxIncl">999999.99999</xsl:with-param>
<xsl:with-param name="maxDecs">5</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="not(fpml:paymentDate/fpml:relativeDate)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing paymentDate/relativeDate element in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:paymentDate/fpml:adjustableDate">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***Unexpected adjustableDate element in this context.</text>
</error>
</xsl:if>
<xsl:if test="$docsType='ISDA2008DividendSwapJapan' or $docsType='ISDA2008DividendSwapJapaneseRev1'">
<xsl:if test="not(fpml:valuationDate)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***Missing valuationDate element in this context.</text>
</error>
</xsl:if>
<xsl:variable name="vdid">
<xsl:value-of select="fpml:valuationDate/@id"/>
</xsl:variable>
<xsl:if test="$vdid = '' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***Missing valuationDate id value in this context.</text>
</error>
</xsl:if>
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">unadjustedDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:valuationDate/fpml:adjustableDate/fpml:unadjustedDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="fpml:valuationDate/fpml:adjustableDate/fpml:dateAdjustments/fpml:businessCentersReference">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***Unexpected businessCentersReference element in this context.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:valuationDate/fpml:adjustableDate/fpml:dateAdjustments/fpml:businessCenters)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***Missing businessCenters in this context.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:for-each>
<xsl:variable name="payer2">
<xsl:value-of select="fpml:fixedLeg/fpml:payerPartyReference/@href"/>
</xsl:variable>
<xsl:if test="not(/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:party[@id=$payer])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The payerPartyReference/@href value does not match an //FpML/party/@id value for any party. Value = '<xsl:value-of select="$payer2"/>'.</text>
</error>
</xsl:if>
<xsl:variable name="receiver2">
<xsl:value-of select="fpml:fixedLeg/fpml:receiverPartyReference/@href"/>
</xsl:variable>
<xsl:if test="not(/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:party[@id=$receiver])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The receiverPartyReference/@href value does not match an //FpML/party/@id value for any party. Value = '<xsl:value-of select="$receiver2"/>' '<xsl:value-of select="$payer2"/>'.</text>
</error>
</xsl:if>
<xsl:if test="$payer2=$receiver2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** payerPartyReference/@href and receiverPartyReference/@href values are the same. Value = '<xsl:value-of select="$receiver2"/>
</text>
</error>
</xsl:if>
<xsl:if test="fpml:fixedLeg/fpml:effectiveDate">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected effectiveDate element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:fixedLeg/fpml:terminationDate">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected terminationDate element encountered in this context.</text>
</error>
</xsl:if>
<xsl:variable name="currency1">
<xsl:value-of select="fpml:fixedLeg/fpml:fixedPayment/fpml:paymentAmount/fpml:currency"/>
</xsl:variable>
<xsl:for-each select="fpml:fixedLeg/fpml:fixedPayment">
<xsl:if test="not(fpml:paymentDate)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing paymentDate element, expected in this context.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:paymentAmount/fpml:currency)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing currency element, expected in this context.</text>
</error>
</xsl:if>
<xsl:variable name="currency2">
<xsl:value-of select="fpml:paymentAmount/fpml:currency"/>
</xsl:variable>
<xsl:if test="$currency1!= $currency2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** fixedLeg currencies do not match. Value = '<xsl:value-of select="$currency1"/>' Value = '<xsl:value-of select="$currency2"/>'</text>
</error>
</xsl:if>
<xsl:if test="fpml:paymentAmount/fpml:amount">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">amount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:paymentAmount/fpml:amount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.01</xsl:with-param>
<xsl:with-param name="maxIncl">999999999989990.00</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="not($docsType='ISDA2008DividendSwapJapan' or $docsType='ISDA2008DividendSwapJapaneseRev1')">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">periodMultiplier</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:paymentDate/fpml:periodMultiplier"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">0</xsl:with-param>
<xsl:with-param name="maxDecs">0</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:paymentDate/fpml:period!='D'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** period must be equal to 'D' in this context. Value = '<xsl:value-of select="fpml:paymentDate/fpml:period"/>'</text>
</error>
</xsl:if>
<xsl:if test="fpml:paymentDate/fpml:dayType">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected dayType element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:paymentDate/fpml:businessCenters">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected businessCenters element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:paymentDate/fpml:businessCentersReference">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected businessCentersReference element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:paymentDate/fpml:businessDayConvention)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing 2 businessDayConvention element, expected in this context.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:paymentDate/fpml:dateRelativeTo/@href)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing dateRelativeTo element reference, expected in this context.</text>
</error>
</xsl:if>
<xsl:variable name="drtid">
<xsl:value-of select="fpml:paymentDate/fpml:dateRelativeTo/@href"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$drtid != ''"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Empty dateRelativeTo/@href attribute.</text>
</error>
</xsl:otherwise>
</xsl:choose>
<xsl:if test="$docsType='ISDA2008DividendSwapJapan' or $docsType='ISDA2008DividendSwapJapaneseRev1'">
<xsl:if test="not(/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:dividendSwapTransactionSupplement/fpml:dividendLeg/fpml:dividendPeriod/fpml:valuationDate[@id=$drtid])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The fixedleg/fixedPayment/dateRelativeTo/@href value does not match a dividendLeg/dividendPeriod/valuationDate/@id value. Value = '<xsl:value-of select="$drtid"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="not($docsType='ISDA2008DividendSwapJapan' or $docsType='ISDA2008DividendSwapJapaneseRev1')">
<xsl:if test="not(/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:dividendSwapTransactionSupplement/fpml:dividendLeg/fpml:dividendPeriod/fpml:paymentDate[@id=$drtid])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The fixedLeg/fixedPayment/dateRelativeTo/@href value does not match a dividendLeg/dividendPeriod/paymentDate/@id value. Value = '<xsl:value-of select="$drtid"/>'.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:for-each>
</xsl:template>
<xsl:template match="fpml:equitySwapTransactionSupplement">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="$productType='Share Variance Swap' or $productType='Index Variance Swap' ">
<xsl:variable name="buyer">
<xsl:value-of select="fpml:buyerPartyReference/@href"/>
</xsl:variable>
<xsl:if test="not(/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:party[@id=$buyer])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The buyerPartyReference/@href value does not match an //FpML/party/@id value for any party. Value = '<xsl:value-of select="$buyer"/>'.</text>
</error>
</xsl:if>
<xsl:variable name="seller">
<xsl:value-of select="fpml:sellerPartyReference/@href"/>
</xsl:variable>
<xsl:if test="not(/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:party[@id=$seller])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The sellerPartyReference/@href value does not match an //FpML/party/@id value for any party. Value = '<xsl:value-of select="$seller"/>'.</text>
</error>
</xsl:if>
<xsl:if test="$buyer=$seller">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** buyerPartyReference/@href and sellerPartyReference/@href values are the same.</text>
</error>
</xsl:if>
<xsl:if test="fpml:productType">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected productType element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:productId">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected productId element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:equityLeg">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected equityLeg element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:interestLeg">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected interestLeg element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:returnLeg">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected returnLeg element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:principalExchangeFeatures">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected principalExchangeFeatures element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:mutualEarlyTermination">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected mutualEarlyTermination element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:multipleExchangeIndexAnnexFallback and not ($productType = 'Share Variance Swap' or $productType ='Index Variance Swap')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected multipleExchangeIndexAnnexFallback element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:localJurisdiction and not ($productType = 'Share Variance Swap' or $productType ='Index Variance Swap')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected localJurisdiction element encountered in this context.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:varianceLeg">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
<xsl:if test="$productType='Equity Share Swap' or $productType='Equity Index Swap' ">
<xsl:if test="fpml:productType">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected productType element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:productId">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected productId element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:buyerPartyReference">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected buyerPartyReference element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:sellerPartyReference">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected sellerPartyReference element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:equityLeg">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected equityLeg element encountered in this context.</text>
</error>
</xsl:if>
<xsl:choose>
<xsl:when test="not(fpml:interestLeg) and not(//fpml:swbEquitySwapDetails/fpml:swbFullyFunded) and not(//fpml:swbEquitySwapDetails/fpml:swbSpreadDetails)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing interestLeg, swbFullyFunded or swbSpreadDetails in this context.</text>
</error>
</xsl:when>
<xsl:otherwise>
<xsl:if test="(fpml:interestLeg or //fpml:swbEquitySwapDetails/fpml:swbFullyFunded or //fpml:swbEquitySwapDetails/fpml:swbSpreadDetails) and not(fpml:interestLeg) and not(//fpml:swbEquitySwapDetails/fpml:swbFullyFunded or //fpml:swbEquitySwapDetails/fpml:swbSpreadDetails)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing interestLeg element in this context.</text>
</error>
</xsl:if>
<xsl:if test="(fpml:interestLeg or //fpml:swbEquitySwapDetails/fpml:swbFullyFunded or //fpml:swbEquitySwapDetails/fpml:swbSpreadDetails) and fpml:interestLeg and (//fpml:swbEquitySwapDetails/fpml:swbFullyFunded or //fpml:swbEquitySwapDetails/fpml:swbSpreadDetails)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected interestLeg element encountered in this context.</text>
</error>
</xsl:if>
</xsl:otherwise>
</xsl:choose>
<xsl:if test="not(fpml:returnLeg)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing returnLeg element in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:varianceLeg">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected varianceLeg element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:principalExchangeFeatures">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected principalExchangeFeatures element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:mutualEarlyTermination">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected mutualEarlyTermination element encountered in this context.</text>
</error>
</xsl:if>
<xsl:variable name="optionalEarlyTerminationFieldApplicable">
<xsl:choose>
<xsl:when test="$docsType = 'ISDA2009EquitySwapAmericas'">true</xsl:when>
<xsl:when test="$docsType = 'ISDA2009EquityEuropeanInterdealer' ">true</xsl:when>
<xsl:when test="$docsType = 'ISDA2009EquitySwapPanAsia' ">true</xsl:when>
<xsl:when test="$docsType = 'ISDA2007EquityEuropean'">true</xsl:when>
<xsl:when test="$docsType = 'EquitySwapGlobalPrivate' ">true</xsl:when>
<xsl:when test="$docsType = 'EquitySwapAmericasPrivate' ">true</xsl:when>
<xsl:when test="$docsType = 'EquitySwapAEJPrivate' ">true</xsl:when>
<xsl:when test="$docsType = 'EquitySwapEuropePrivate' ">true</xsl:when>
<xsl:when test="$docsType = 'EquitySwapPanAsiaPrivate' ">true</xsl:when>
<xsl:when test="$docsType = 'ISDA2004EquityAmericasInterdealer' ">true</xsl:when>
<xsl:when test="$docsType = 'ISDA2005EquitySwapAsiaExcludingJapanInterdealer' ">true</xsl:when>
<xsl:when test="$docsType = 'ISDA2008EquityFinanceSwapAsiaExcludingJapan' ">true</xsl:when>
<xsl:when test="$docsType = 'ISDA2009EquityFinanceSwapAsiaExcludingJapan' ">true</xsl:when>
<xsl:when test="$docsType = 'ISDA2007EquityFinanceSwapEuropean' ">true</xsl:when>
<xsl:when test="$docsType = 'EmergingEquitySwapIndustry' ">true</xsl:when>
<xsl:when test="$docsType = 'EmergingEquitySwapLATAM' ">true</xsl:when>
<xsl:when test="$docsType = 'EmergingEquitySwapEMEA' ">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:if test="fpml:optionalEarlyTermination and $optionalEarlyTerminationFieldApplicable = 'false' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected optionalEarlyTermination element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:localJurisdiction and not($docsType='ISDA2005EquitySwapAsiaExcludingJapanInterdealer' or $docsType='ISDA2009EquitySwapPanAsia' or $docsType='EquitySwapPanAsiaPrivate')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected localJurisdiction element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:returnLeg/fpml:fxFeature and not ($docsTypeEqSwap = 'Equity Swap (Pan Asia)' or $docsTypeEqSwap = 'Equity Swap (AEJ)') ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected fxFeature element in this context. Element must not be present when Docs Type is not 'Equity Swap (Pan Asia)' or 'Equity Swap (AEJ)'.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:returnLeg/fpml:fxFeature) and $docsTypeEqSwap='Equity Swap (Pan Asia)' and $productType='Equity Share Swap' and fpml:returnLeg/fpml:rateOfReturn/fpml:initialPrice/fpml:netPrice/fpml:currency and /fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:returnLeg/fpml:rateOfReturn/fpml:valuationPriceFinal/fpml:determinationMethod='Close'">
<xsl:choose>
<xsl:when test="fpml:returnLeg/fpml:rateOfReturn/fpml:initialPrice/fpml:netPrice/fpml:currency = 'AUD'"/>
<xsl:when test="fpml:returnLeg/fpml:rateOfReturn/fpml:initialPrice/fpml:netPrice/fpml:currency = 'HKD'"/>
<xsl:when test="fpml:returnLeg/fpml:rateOfReturn/fpml:initialPrice/fpml:netPrice/fpml:currency = 'NZD'"/>
<xsl:when test="fpml:returnLeg/fpml:rateOfReturn/fpml:initialPrice/fpml:netPrice/fpml:currency = 'SGD'"/>
<xsl:when test="fpml:returnLeg/fpml:rateOfReturn/fpml:initialPrice/fpml:netPrice/fpml:currency = 'JPY'"/>
<xsl:when test="fpml:returnLeg/fpml:rateOfReturn/fpml:initialPrice/fpml:netPrice/fpml:currency = 'USD'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing fxFeature element when Docs Type is 'Equity Swap (Pan Asia)' and returnLeg/rateOfReturn/initialPrice/netPrice/currency is a non-deliverable currency.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:apply-templates select="fpml:fxFeature">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:interestLeg">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:returnLeg">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="($productType='Equity Index Swap' and ($docsType = 'ISDA2009EquitySwapPanAsia' or $docsType = 'EquitySwapPanAsiaPrivate'))">
<xsl:if test="fpml:returnLeg/fpml:return/fpml:returnType != 'Total' and fpml:returnLeg/fpml:rateOfReturn//fpml:valuationRules/fpml:dividendValuationDates">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected fpml:dividendValuationDates element encountered in this context. Dividends are only applicable when return type is Total. </text>
</error>
</xsl:if>
<xsl:if test="fpml:localJurisdiction">
<xsl:choose>
<xsl:when test="fpml:localJurisdiction='Applicable'"/>
<xsl:when test="fpml:localJurisdiction='Not Applicable'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected value for fpml:localJurisdiction. Element must contain a value of 'Applicable' or 'Not Applicable'</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="fpml:returnLeg/fpml:rateOfReturn/fpml:valuationPriceFinal/fpml:valuationRules/fpml:fPVFinalPriceElectionFallback">
<xsl:choose>
<xsl:when test="fpml:returnLeg/fpml:rateOfReturn/fpml:valuationPriceFinal/fpml:valuationRules/fpml:fPVFinalPriceElectionFallback='FPVHedgeExecution'"/>
<xsl:when test="fpml:returnLeg/fpml:rateOfReturn/fpml:valuationPriceFinal/fpml:valuationRules/fpml:fPVFinalPriceElectionFallback='FPVClose'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected value for fpml:fPVFinalPriceElectionFallback. Element must contain a value of 'FPVHedgeExecution' or 'FPVClose'</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="count(//fpml:hedgingParty)=2">
<xsl:if test="fpml:returnLeg/fpml:rateOfReturn/fpml:valuationPriceFinal/fpml:valuationRules/fpml:fPVFinalPriceElectionFallback != 'FPVClose'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected value for fpml:fPVFinalPriceElectionFallback. Element must contain a value of 'FPVClose' when both parties are designated as Hedging Party</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:returnLeg/fpml:return/fpml:dividendConditions/fpml:dividendPaymentDate/fpml:dividendDateReference != 'DividendValuationDate'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected value for fpml:dividendDateReference. Element should contain a value of 'DividendValuationDate'</text>
</error>
</xsl:if>
<xsl:choose>
<xsl:when test="fpml:returnLeg/fpml:rateOfReturn/fpml:valuationPriceInterim/fpml:valuationRules/fpml:dividendValuationDates/fpml:relativeDateSequence and not(fpml:returnLeg/fpml:rateOfReturn/fpml:valuationPriceFinal/fpml:valuationRules/fpml:dividendValuationDates/fpml:relativeDateSequence)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The same structure for fpml:dividendValuationDates must be present in fpml:valuationPriceInterim and fpml:valuationPriceFinal.</text>
</error>
</xsl:when>
<xsl:when test="fpml:returnLeg/fpml:rateOfReturn/fpml:valuationPriceInterim/fpml:valuationRules/fpml:dividendValuationDates/fpml:periodicDates and not(fpml:returnLeg/fpml:rateOfReturn/fpml:valuationPriceFinal/fpml:valuationRules/fpml:dividendValuationDates/fpml:periodicDates)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The same structure for fpml:dividendValuationDates must be present in fpml:valuationPriceInterim and fpml:valuationPriceFinal.</text>
</error>
</xsl:when>
<xsl:when test="fpml:returnLeg/fpml:rateOfReturn/fpml:valuationPriceInterim/fpml:valuationRules/fpml:dividendValuationDates/fpml:adjustableDates and not(fpml:returnLeg/fpml:rateOfReturn/fpml:valuationPriceFinal/fpml:valuationRules/fpml:dividendValuationDates/fpml:adjustableDates)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The same structure for fpml:dividendValuationDates must be present in fpml:valuationPriceInterim and fpml:valuationPriceFinal.</text>
</error>
</xsl:when>
</xsl:choose>
<xsl:if test="fpml:returnLeg/fpml:rateOfReturn//fpml:valuationRules/fpml:dividendValuationDates/fpml:relativeDateSequence/fpml:dateOffset/fpml:period != 'D'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected value for fpml:period. Dividend Valuation Offset must be expressed as a number of days, the fpml:period element should contain a value of 'D'</text>
</error>
</xsl:if>
<xsl:if test="fpml:returnLeg/fpml:rateOfReturn/fpml:valuationPriceFinal/fpml:valuationRules/fpml:dividendValuationDates/fpml:periodicDates/fpml:calculationPeriodFrequency">
<xsl:call-template name="isValidPeriodMultiplier">
<xsl:with-param name="elementName">dividendValuationFrequency/periodMultiplier</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:returnLeg/fpml:rateOfReturn/fpml:valuationPriceFinal/fpml:valuationRules/fpml:dividendValuationDates/fpml:periodicDates/fpml:calculationPeriodFrequency/fpml:periodMultiplier"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="isValidPeriod">
<xsl:with-param name="elementName">period</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:returnLeg/fpml:rateOfReturn/fpml:valuationPriceFinal/fpml:valuationRules/fpml:dividendValuationDates/fpml:periodicDates/fpml:calculationPeriodFrequency/fpml:period"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:returnLeg/fpml:rateOfReturn/fpml:valuationPriceFinal/fpml:valuationRules/fpml:dividendValuationDates/fpml:periodicDates">
<xsl:variable name="divValFreq">
<xsl:value-of select="fpml:returnLeg/fpml:rateOfReturn/fpml:valuationPriceFinal/fpml:valuationRules/fpml:dividendValuationDates/fpml:periodicDates/fpml:calculationPeriodFrequency/fpml:periodMultiplier"/>
<xsl:value-of select="fpml:returnLeg/fpml:rateOfReturn/fpml:valuationPriceFinal/fpml:valuationRules/fpml:dividendValuationDates/fpml:periodicDates/fpml:calculationPeriodFrequency/fpml:period"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$divValFreq='1D'"/>
<xsl:when test="$divValFreq='2D'"/>
<xsl:when test="$divValFreq='5D'"/>
<xsl:when test="$divValFreq='1W'"/>
<xsl:when test="$divValFreq='2W'"/>
<xsl:when test="$divValFreq='3W'"/>
<xsl:when test="$divValFreq='4W'"/>
<xsl:when test="$divValFreq='1M'"/>
<xsl:when test="$divValFreq='2M'"/>
<xsl:when test="$divValFreq='3M'"/>
<xsl:when test="$divValFreq='6M'"/>
<xsl:when test="$divValFreq='9M'"/>
<xsl:when test="$divValFreq='12M'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid periodMultiplier and period value combination encountered for Dividend Valuation Frequency. Value combination = '<xsl:value-of select="$divValFreq"/>'</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:variable name="valuationDay">
<xsl:value-of select="fpml:returnLeg/fpml:rateOfReturn/fpml:valuationPriceFinal/fpml:valuationRules/fpml:dividendValuationDates/fpml:periodicDates/fpml:calculationPeriodFrequency/fpml:rollConvention"/>
</xsl:variable>
<xsl:if test="fpml:returnLeg/fpml:rateOfReturn/fpml:valuationPriceFinal/fpml:valuationRules/fpml:dividendValuationDates/fpml:periodicDates/fpml:calculationPeriodFrequency">
<xsl:choose>
<xsl:when test="$valuationDay='1'"/>
<xsl:when test="$valuationDay='2'"/>
<xsl:when test="$valuationDay='3'"/>
<xsl:when test="$valuationDay='4'"/>
<xsl:when test="$valuationDay='5'"/>
<xsl:when test="$valuationDay='6'"/>
<xsl:when test="$valuationDay='7'"/>
<xsl:when test="$valuationDay='8'"/>
<xsl:when test="$valuationDay='9'"/>
<xsl:when test="$valuationDay='10'"/>
<xsl:when test="$valuationDay='11'"/>
<xsl:when test="$valuationDay='12'"/>
<xsl:when test="$valuationDay='13'"/>
<xsl:when test="$valuationDay='14'"/>
<xsl:when test="$valuationDay='15'"/>
<xsl:when test="$valuationDay='16'"/>
<xsl:when test="$valuationDay='17'"/>
<xsl:when test="$valuationDay='18'"/>
<xsl:when test="$valuationDay='19'"/>
<xsl:when test="$valuationDay='20'"/>
<xsl:when test="$valuationDay='21'"/>
<xsl:when test="$valuationDay='22'"/>
<xsl:when test="$valuationDay='23'"/>
<xsl:when test="$valuationDay='24'"/>
<xsl:when test="$valuationDay='25'"/>
<xsl:when test="$valuationDay='26'"/>
<xsl:when test="$valuationDay='27'"/>
<xsl:when test="$valuationDay='28'"/>
<xsl:when test="$valuationDay='29'"/>
<xsl:when test="$valuationDay='30'"/>
<xsl:when test="$valuationDay='EOM'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid value for fpml:rollConvention. Value = '<xsl:value-of select="$valuationDay"/>'</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="fpml:returnLeg/fpml:rateOfReturn/fpml:valuationPriceFinal/fpml:valuationRules/fpml:dividendValuationDates/fpml:periodicDates/fpml:calculationStartDate/fpml:adjustableDate">
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">initialValuationDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:returnLeg/fpml:rateOfReturn/fpml:valuationPriceFinal/fpml:valuationRules/fpml:dividendValuationDates/fpml:periodicDates/fpml:calculationStartDate/fpml:adjustableDate/fpml:unadjustedDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:returnLeg/fpml:rateOfReturn/fpml:valuationPriceFinal/fpml:valuationRules/fpml:dividendValuationDates/fpml:periodicDates/fpml:calculationEndDate/fpml:adjustableDate">
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">finalValuationDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:returnLeg/fpml:rateOfReturn/fpml:valuationPriceFinal/fpml:valuationRules/fpml:dividendValuationDates/fpml:periodicDates/fpml:calculationEndDate/fpml:adjustableDate/fpml:unadjustedDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:returnLeg/fpml:rateOfReturn/fpml:valuationPriceFinal/fpml:valuationRules/fpml:dividendValuationDates/fpml:adjustableDates">
<xsl:for-each select="fpml:returnLeg/fpml:rateOfReturn//fpml:valuationRules/fpml:dividendValuationDates/fpml:adjustableDates/fpml:unadjustedDate">
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">customValuationDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="."/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:for-each>
</xsl:if>
</xsl:if>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:varianceLeg">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="not($productType='Dispersion Variance Swap')">
<xsl:variable name="payer">
<xsl:value-of select="fpml:payerPartyReference/@href"/>
</xsl:variable>
<xsl:if test="not(/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:buyerPartyReference[@href=$payer])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The payerPartyReference/@href value does not match the /fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/trade/equitySwapTransactionSupplement/buyerPartyReference. Value = '<xsl:value-of select="$payer"/>'.</text>
</error>
</xsl:if>
<xsl:variable name="receiver">
<xsl:value-of select="fpml:receiverPartyReference/@href"/>
</xsl:variable>
<xsl:if test="not(/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:sellerPartyReference[@href=$receiver])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The receiverPartyReference/@href value does not match the //FpML/trade/equitySwapTransactionSupplement/sellerPartyReference. Value = '<xsl:value-of select="$receiver"/>'.</text>
</error>
</xsl:if>
<xsl:if test="$payer=$receiver">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** payerPartyReference/@href and receiverPartyReference/@href values are the same.</text>
</error>
</xsl:if>
<xsl:if test="fpml:paymentFrequency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected paymentFrequency element encountered in this context.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:underlyer">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:equityValuation">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:equityAmount">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
<xsl:if test="$productType='Dispersion Variance Swap'">
<xsl:for-each select=".">
<xsl:sort select="."/>
<xsl:variable name="varid">
<xsl:value-of select=".//@id"/>
</xsl:variable>
<xsl:call-template name="isValidIntegerNumber">
<xsl:with-param name="elementName">legId</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select=".//fpml:legId"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">10000</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="isValidIntegerNumber">
<xsl:with-param name="elementName">version</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select=".//fpml:version"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">10000</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test=".//fpml:underlyer/fpml:singleUnderlyer/fpml:index ">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">LegId</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select=".//fpml:legId"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">0</xsl:with-param>
<xsl:with-param name="maxDecs">0</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test=".//fpml:underlyer/fpml:singleUnderlyer/fpml:equity">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">LegId</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select=".//fpml:legId"/>
</xsl:with-param>
<xsl:with-param name="minIncl">1</xsl:with-param>
<xsl:with-param name="maxIncl">10000</xsl:with-param>
<xsl:with-param name="maxDecs">0</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:variable name="LegIdDis">
<xsl:value-of select=".//fpml:legId"/>
</xsl:variable>
<xsl:if test="number($LegIdDis) &lt; 1 and .//fpml:amount/fpml:allDividends">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid allDividends element. allDividends can only be submitted on Leg One of a Dispersion Variance Swap Trade.</text>
</error>
</xsl:if>
<xsl:variable name="LegIdDis2">
<xsl:value-of select=".//fpml:legId"/>
</xsl:variable>
<xsl:if test="number($LegIdDis2) &gt; 0 and .//fpml:valuation//fpml:futuresPriceValuation">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid futuresPriceValuation element. futuresPriceValuation can only be submitted on the Index Leg of a Dispersion Variance Swap Trade.</text>
</error>
</xsl:if>
<xsl:variable name="LegIdDis3">
<xsl:value-of select=".//fpml:legId"/>
</xsl:variable>
<xsl:if test="number($LegIdDis3) &gt; 0 and .//fpml:settlementDate">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected settlement element. SettlementDate can only be submitted on the Index Leg of a Dispersion Variance Swap Trade.</text>
</error>
</xsl:if>
<xsl:variable name="LegIdDis0">
<xsl:value-of select=".//fpml:legId"/>
</xsl:variable>
<xsl:if test="number($LegIdDis0) &gt; 1 and .//fpml:amount/fpml:allDividends">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid allDividends element. allDividends can only be submitted on Leg One of a Dispersion Variance Swap Trade.</text>
</error>
</xsl:if>
<xsl:variable name="LegIdDis4">
<xsl:value-of select=".//fpml:legId"/>
</xsl:variable>
<xsl:if test="number($LegIdDis4) &gt; 1 and .//fpml:amount/fpml:variance/fpml:varianceCap">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected varianceCap element. varianceCap can only be submitted on the Index Leg and first share leg of a Dispersion Variance Swap Trade.</text>
</error>
</xsl:if>
<xsl:variable name="LegIdDis5">
<xsl:value-of select=".//fpml:legId"/>
</xsl:variable>
<xsl:if test="number($LegIdDis5) &gt; 1 and .//fpml:amount/fpml:variance/fpml:unadjustedVarianceCap">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected unadjustedVarianceCap element. unadjustedVarianceCap can only be submitted on the Index Leg and first share leg of a Dispersion Variance Swap Trade.</text>
</error>
</xsl:if>
<xsl:variable name="LegIdDis6">
<xsl:value-of select=".//fpml:legId"/>
</xsl:variable>
<xsl:if test="number($LegIdDis6) &gt; 0 and .//fpml:multipleExchangeIndexAnnexFallback">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid multipleExchangeIndexAnnexFallback element. multipleExchangeIndexAnnexFallback can only be submitted on the Index Leg of a Dispersion Variance Swap Trade.</text>
</error>
</xsl:if>
<xsl:variable name="payer">
<xsl:value-of select="fpml:payerPartyReference/@href"/>
</xsl:variable>
<xsl:if test="not(//fpml:swbStructuredTradeDetails/fpml:FpML/fpml:party[@id=$payer])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The payerPartyReference/@href value does not match an //FpML/party/@id value for any party. Value = '<xsl:value-of select="$payer"/>'.</text>
</error>
</xsl:if>
<xsl:variable name="receiver">
<xsl:value-of select="//fpml:receiverPartyReference/@href"/>
</xsl:variable>
<xsl:if test="not(//fpml:swbStructuredTradeDetails/fpml:FpML/fpml:party[@id=$receiver])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The receiverPartyReference/@href value does not match an //FpML/party/@id value for any party. Value = '<xsl:value-of select="$receiver"/>'.</text>
</error>
</xsl:if>
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
<text>*** payerPartyReference/@href and receiverPartyReference/@href values are the same</text>
</error>
</xsl:if>
<xsl:if test=".//fpml:paymentFrequency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected paymentFrequency element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test=".//fpml:effectiveDate">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected effectiveDate element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test=".//fpml:terminationDate">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected termination Date element encountered in this context.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:underlyer">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:settlementType">
<xsl:if test="(fpml:settlementType != 'Cash')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Settlement Type must equal 'Cash' in this context.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:settlementDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:settlementCurrency">
<xsl:call-template name="isValidCurrency">
<xsl:with-param name="elementName">settlementCurrency</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:settlementCurrency"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:apply-templates select="fpml:underlyer">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:valuation">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:amount">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:for-each>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:interestLeg">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:variable name="payer">
<xsl:value-of select="fpml:payerPartyReference/@href"/>
</xsl:variable>
<xsl:if test="not(//fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:returnLeg/fpml:receiverPartyReference[@href=$payer])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The payerPartyReference/@href value does not match the //FpML/trade/equitySwapTransactionSupplement/returnLeg/receiverPartyReference. Value = '<xsl:value-of select="$payer"/>'.</text>
</error>
</xsl:if>
<xsl:variable name="receiver">
<xsl:value-of select="fpml:receiverPartyReference/@href"/>
</xsl:variable>
<xsl:if test="not(//fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:returnLeg/fpml:payerPartyReference[@href=$receiver])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The receiverPartyReference/@href value does not match the //FpML/trade/equitySwapTransactionSupplement/returnLeg/payerPartyReference. Value = '<xsl:value-of select="$receiver"/>'.</text>
</error>
</xsl:if>
<xsl:if test="$payer=$receiver">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** payerPartyReference/@href and receiverPartyReference/@href values are the same.</text>
</error>
</xsl:if>
<xsl:if test="fpml:paymentFrequency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected paymentFrequency element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:stubCalculationPeriod">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected stubCalculationPeriod element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:interestLegCalculationPeriodDates/@id = 'interestCalcPeriodDates') ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** interestLegCalculationPeriodDates/@id must be equal to  'interestCalcPeriodDates' in this context. Value = '<xsl:value-of select="fpml:interestLegCalculationPeriodDates/@id"/>'</text>
</error>
</xsl:if>
<xsl:if test="(fpml:interestLegCalculationPeriodDates/fpml:interestLegPaymentDates/fpml:periodicDates/fpml:calculationPeriodDatesAdjustments/fpml:businessDayConvention[.='NotApplicable'] or fpml:interestLegCalculationPeriodDates/fpml:interestLegPaymentDates/fpml:periodicDates/fpml:calculationPeriodDatesAdjustments/fpml:businessDayConvention[.='NONE']) and (//fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbEquitySwapDetails/fpml:swbSchedulingMethod!='ListDateEntry')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid businessDayConvention element value.Value = '<xsl:value-of select="fpml:interestLegCalculationPeriodDates/fpml:interestLegPaymentDates/fpml:periodicDates/fpml:calculationPeriodDatesAdjustments/fpml:businessDayConvention"/>'</text>
</error>
</xsl:if>
<xsl:if test="(fpml:interestLegCalculationPeriodDates/fpml:interestLegPaymentDates/fpml:adjustableDates/fpml:dateAdjustments/fpml:businessDayConvention[.='NotApplicable'] or fpml:interestLegCalculationPeriodDates/fpml:interestLegPaymentDates/fpml:adjustableDates/fpml:dateAdjustments/fpml:businessDayConvention[.='NONE']) and (//fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbEquitySwapDetails/fpml:swbSchedulingMethod!='ListDateEntry')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid businessDayConvention element value.Value = '<xsl:value-of select="fpml:interestLegCalculationPeriodDates/fpml:interestLegPaymentDates/fpml:periodicDates/fpml:calculationPeriodDatesAdjustments/fpml:businessDayConvention"/>'</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:interestLegCalculationPeriodDates">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:notional">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:interestAmount">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:interestCalculation">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:interestLegCalculationPeriodDates">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
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
<xsl:apply-templates select="fpml:interestLegResetDates">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:interestLegPaymentDates">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:effectiveDate|fpml:terminationDate">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:apply-templates select="fpml:adjustableDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:relativeDate">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected relativeDate element encountered in this context.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:interestLegResetDates">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="not(fpml:calculationPeriodDatesReference/@href = 'interestCalcPeriodDates') ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** calculationPeriodDatesReference/@href must be equal to 'interestCalcPeriodDates' in this context. Value = '<xsl:value-of select="fpml:calculationPeriodDatesReference/@href"/>'</text>
</error>
</xsl:if>
<xsl:if test="fpml:resetRelativeTo and not(//fpml:swbSchedulingMethod = 'ListDateEntry')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected resetRelativeTo element encountered in this context.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:resetFrequency">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:initialFixingDate">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected initialFixingDate element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbEquitySwapDetails/fpml:swbFullyFunded or /fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbEquitySwapDetails/fpml:swbSpreadDetails  or /fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbEquitySwapDetails/fpml:swbFixedRateIndicator='true' ">
<xsl:if test="fpml:fixingDates">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected fixingDates element encountered in this context.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:fixingDates">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:resetFrequency">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:call-template name="isValidPeriodMultiplier">
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
<xsl:if test="fpml:weeklyRollConvention">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected weeklyRollConvention element encountered in this context.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:fixingDates">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="fpml:adjustableDates and not(//fpml:swbSchedulingMethod = 'ListDateEntry')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected adjustableDates element encountered in this context.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:relativeDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:equitySwapTransactionSupplement/fpml:interestLeg/fpml:interestLegCalculationPeriodDates/fpml:interestLegPaymentDates">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="fpml:adjustableDates and not(//fpml:swbSchedulingMethod = 'ListDateEntry')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected adjustableDates element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:adjustableDates) and //fpml:swbSchedulingMethod = 'ListDateEntry'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing element adjustableDates in this context for ListDateEntry Mode.</text>
</error>
</xsl:if>
<xsl:if test="fpml:relativeDates">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected relativeDates element encountered in this context.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:periodicDates">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:notional">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="fpml:amountRelativeTo/@href != 'equityNotionalAmount' and ancestor::fpml:interestLeg">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** amountRelativeTo/@href must be equal to 'equityNotionalAmount' in this context. Value = '<xsl:value-of select="fpml:amountRelativeTo/@href"/>'</text>
</error>
</xsl:if>
<xsl:if test="fpml:amountRelativeTo and ancestor::fpml:returnLeg">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected amountRelativeTo element in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:notionalAmount and ancestor::fpml:interestLeg ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected notionalAmount element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="ancestor::fpml:returnLeg and not(fpml:determinationMethod)">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">notionalAmount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:notionalAmount/fpml:amount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.00</xsl:with-param>
<xsl:with-param name="maxIncl">9999999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:interestAmount">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="fpml:currency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected currency element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:determinationMethod">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected determinationMethod element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:currencyReference">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected currencyReference element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:paymentCurrency/@href != 'equityPaymentCurrency' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** paymentCurrency/@href must be equal to 'equityPaymentCurrency' in this context. Value = '<xsl:value-of select="fpml:paymentCurrency/@href"/>'</text>
</error>
</xsl:if>
<xsl:if test="fpml:paymentCurrency/fpml:currency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected paymentCurrency/currency element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:paymentCurrency/fpml:determinationMethod">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected paymentCurrency/determinationMethod element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:referenceAmount/@href != 'StandardISDA' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** referenceAmount/@href must be equal to 'StandardISDA' in this context. Value = '<xsl:value-of select="fpml:referenceAmount/@href"/>'</text>
</error>
</xsl:if>
<xsl:if test="fpml:formula">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected formula element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:encodedDescription">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected encodedDescription element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:variance">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected variance element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:calculationDates">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected calculationDates element encountered in this context.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:interestCalculation">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:apply-templates select="fpml:floatingRateCalculation">
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
<xsl:with-param name="minIncl">-9.99999999</xsl:with-param>
<xsl:with-param name="maxIncl">9.99999999</xsl:with-param>
<xsl:with-param name="maxDecs">8</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:apply-templates select="fpml:compounding">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:variable name="linearInterpolationFieldApplicable">
<xsl:choose>
<xsl:when test="$docsType = 'ISDA2004EquityAmericasInterdealer' ">false</xsl:when>
<xsl:when test="$docsType = 'ISDA2009EquitySwapAmericas' ">true</xsl:when>
<xsl:when test="$docsType = 'EquitySwapAmericasPrivate' ">true</xsl:when>
<xsl:when test="$docsType = 'ISDA2009EquityEuropeanInterdealer' ">true</xsl:when>
<xsl:when test="$docsType = 'ISDA2007EquityEuropean'">true</xsl:when>
<xsl:when test="$docsType = 'EquitySwapEuropePrivate' ">true</xsl:when>
<xsl:when test="$docsType = 'ISDA2007EquityFinanceSwapEuropean' ">true</xsl:when>
<xsl:when test="$docsType = 'ISDA2010FairValueShareSwapEuropeanInterdealer' ">true</xsl:when>
<xsl:when test="$docsType = 'ISDA2009EquitySwapPanAsia' ">true</xsl:when>
<xsl:when test="$docsType = 'EquitySwapPanAsiaPrivate' ">true</xsl:when>
<xsl:when test="$docsType = 'EquitySwapGlobalPrivate' ">true</xsl:when>
<xsl:when test="$docsType = 'ISDA2005EquitySwapAsiaExcludingJapanInterdealer' ">true</xsl:when>
<xsl:when test="$docsType = 'ISDA2008EquityFinanceSwapAsiaExcludingJapan' ">true</xsl:when>
<xsl:when test="$docsType = 'ISDA2009EquityFinanceSwapAsiaExcludingJapan' ">true</xsl:when>
<xsl:when test="$docsType = 'EmergingEquitySwapIndustry' ">true</xsl:when>
<xsl:when test="$docsType = 'EmergingEquitySwapLATAM' ">true</xsl:when>
<xsl:when test="$docsType = 'EmergingEquitySwapEMEA' ">true</xsl:when>
<xsl:when test="$docsType = 'EquitySwapAEJPrivate' ">false</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:if test="fpml:interpolationMethod and $linearInterpolationFieldApplicable='false' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected interpolationMethod element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:interpolationPeriod and $linearInterpolationFieldApplicable='false' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected interpolationPeriod element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="(fpml:interpolationPeriod and fpml:interpolationMethod = 'None')" >
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected interpolationPeriod element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="(fpml:interpolationMethod and fpml:interpolationMethod = 'LinearZeroYield' and not (fpml:interpolationPeriod))">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** interpolationPeriod must be present where interpolationMethod = 'LinearZeroYield' ***</text>
</error>
</xsl:if>
<xsl:if test="(fpml:interpolationMethod and fpml:interpolationMethod = 'LinearZeroYield' and fpml:interpolationPeriod and
fpml:interpolationPeriod != 'Initial' and fpml:interpolationPeriod != 'InitialAndFinal'
and fpml:interpolationPeriod != 'Final' and fpml:interpolationPeriod != 'AnyPeriod')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** interpolationPeriod must be either 'Initial', 'InitialAndFinal', 'Final' or 'AnyPeriod'  where interpolationMethod = 'LinearZeroYield ***</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:floatingRateCalculation">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="not(($productType='Equity Share Swap' or $productType='Equity Index Swap' or $productType='Equity Basket Swap') and (fpml:floatingRateIndex = 'GBP-SONIA' or fpml:floatingRateIndex = 'CHF-SARON' or fpml:floatingRateIndex = 'USD-SOFR' or fpml:floatingRateIndex = 'USD-Overnight Bank Funding Rate' or fpml:floatingRateIndex = 'USD-Federal Funds-H.15' or fpml:floatingRateIndex = 'USD-Federal Funds' or fpml:floatingRateIndex = 'EUR-EuroSTR' or fpml:floatingRateIndex = 'JPY-TONA' or fpml:floatingRateIndex = 'AUD-AONIA' or fpml:floatingRateIndex = 'CAD-CORRA' or fpml:floatingRateIndex = 'HKD-HONIA' or fpml:floatingRateIndex = 'SGD-SORA' or fpml:floatingRateIndex = 'GBP-SONIA-COMPOUND' or fpml:floatingRateIndex = 'GBP-SONIA-OIS Compound' or fpml:floatingRateIndex = 'USD-SOFR-COMPOUND' or fpml:floatingRateIndex = 'USD-SOFR-OIS Compound' or fpml:floatingRateIndex = 'USD-Federal Funds-H.15-OIS-COMPOUND' or fpml:floatingRateIndex = 'USD-Federal Funds-OIS Compound' or fpml:floatingRateIndex = 'EUR-EuroSTR-COMPOUND' or fpml:floatingRateIndex = 'EUR-EuroSTR-OIS Compound' or fpml:floatingRateIndex = 'CHF-SARON-OIS-COMPOUND' or fpml:floatingRateIndex = 'CHF-SARON-OIS Compound' or fpml:floatingRateIndex = 'CAD-CORRA-OIS-COMPOUND' or fpml:floatingRateIndex = 'CAD-CORRA-OIS Compound' or fpml:floatingRateIndex = 'JPY-TONA-OIS-COMPOUND' or fpml:floatingRateIndex = 'JPY-TONA-OIS Compound' or fpml:floatingRateIndex = 'SGD-SORA-COMPOUND' or fpml:floatingRateIndex = 'SGD-SORA-OIS Compound' or fpml:floatingRateIndex = 'EUR-EONIA' or fpml:floatingRateIndex = 'EUR-EONIA-OIS-COMPOUND' or fpml:floatingRateIndex = 'EUR-EONIA-OIS Compound'))">
<xsl:if test="not(fpml:indexTenor)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing indexTenor element in this context.</text>
</error>
</xsl:if>
<xsl:call-template name="isValidPeriodMultiplier">
<xsl:with-param name="elementName">indexTenor/periodMultiplier</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:indexTenor/fpml:periodMultiplier"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="isValidPeriod">
<xsl:with-param name="elementName">indexTenor/period</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:indexTenor/fpml:period"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="(($productType='Equity Share Swap' or $productType='Equity Index Swap' or $productType='Equity Basket Swap') and (fpml:floatingRateIndex = 'AUD-AONIA' or fpml:floatingRateIndex = 'CAD-CORRA' or fpml:floatingRateIndex = 'CHF-SARON' or fpml:floatingRateIndex = 'EUR-EuroSTR' or fpml:floatingRateIndex = 'EUR-EONIA' or fpml:floatingRateIndex = 'GBP-SONIA' or fpml:floatingRateIndex = 'HKD-HONIA' or fpml:floatingRateIndex = 'JPY-TONA' or fpml:floatingRateIndex = 'SGD-SORA' or fpml:floatingRateIndex = 'USD-Federal Funds-H.15' or fpml:floatingRateIndex = 'USD-Federal Funds' or fpml:floatingRateIndex = 'USD-SOFR' or fpml:floatingRateIndex = 'USD-Overnight Bank Funding Rate')) ">
<xsl:if test="(fpml:calculationParameters/fpml:calculationMethod='NotApplicable') and (fpml:calculationParameters/fpml:observationShift or
fpml:calculationParameters/fpml:lockout or fpml:calculationParameters/fpml:lookback)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid calculationMethod element value 'NotApplicable' in this context, only 'Compounding' and 'Averaging' is allowed.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:floatingRateMultiplierSchedule">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected floatingRateMultiplierSchedule element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:spreadSchedule/fpml:initialValue)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing spreadSchedule/initialValue element in this context.</text>
</error>
</xsl:if>
<xsl:if test="not($productType='Equity Share Swap' or $productType='Equity Index Swap')">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">spreadSchedule/initialValue</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:spreadSchedule/fpml:initialValue"/>
</xsl:with-param>
<xsl:with-param name="minIncl">-0.9999999</xsl:with-param>
<xsl:with-param name="maxIncl">0.9999999</xsl:with-param>
<xsl:with-param name="maxDecs">7</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="($productType='Equity Share Swap' or $productType='Equity Index Swap')">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">spreadSchedule/initialValue</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:spreadSchedule/fpml:initialValue"/>
</xsl:with-param>
<xsl:with-param name="minIncl">-9.9999999</xsl:with-param>
<xsl:with-param name="maxIncl">9.9999999</xsl:with-param>
<xsl:with-param name="maxDecs">7</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:for-each select="fpml:spreadSchedule/fpml:step/fpml:stepDate">
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">stepDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="."/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:for-each>
<xsl:if test="($productType != 'Equity Index Swap' and $productType != 'Equity Share Swap') and fpml:spreadSchedule/fpml:step">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected spreadSchedule/step element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="($productType != 'Equity Index Swap' and $productType != 'Equity Share Swap') and fpml:spreadSchedule/fpml:type">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected spreadSchedule/type element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:rateTreatment">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected rateTreatment element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:capRateSchedule">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected capRateSchedule element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:floorRateSchedule">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected floorRateSchedule element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:initialRate">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected initialRate element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:finalRateRounding">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected finalRateRounding element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:averagingMethod">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected averagingMethod element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:negativeInterestRateTreatment">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected negativeInterestRateTreatment element encountered in this context.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:compounding">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="not(fpml:compoundingMethod)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing compoundingMethod element in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:compoundingRate/fpml:specificRate">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected compoundingRate/specificRate encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:compoundingSpread">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected compoundingSpread encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:compoundingDates)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing compoundingDates element in this context.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:compoundingDates">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:compoundingDates">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="fpml:adjustableDates and not(//fpml:swbSchedulingMethod = 'ListDateEntry')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected adjustableDates encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:relativeDates">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected relativeDates encountered in this context.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:periodicDates">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:periodicDates">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:apply-templates select="fpml:calculationStartDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:calculationStartDate/fpml:adjustableDate">
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">unadjustedDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:calculationStartDate/fpml:adjustableDate/fpml:unadjustedDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:apply-templates select="fpml:calculationEndDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:calculationPeriodFrequency">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:calculationPeriodDatesAdjustments">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:calculationStartDate | fpml:calculationEndDate">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="fpml:adjustableDate and $docsType!='Equity Options (Cliquet)'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected adjustableDate element encountered in this context.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:relativeDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:calculationPeriodFrequency | fpml:valuationFrequency | fpml:paymentFrequency | fpml:compoundingFrequency">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:variable name="rollFrequency">
<xsl:value-of select="fpml:periodMultiplier"/>
<xsl:value-of select="fpml:period"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$rollFrequency='1D' and $docsType='Equity Options (Cliquet)'"/>
<xsl:when test="$rollFrequency='1W' and $docsType='Equity Options (Cliquet)'"/>
<xsl:when test="$rollFrequency='2W' and $docsType='Equity Options (Cliquet)'"/>
<xsl:when test="$rollFrequency='4W' and $docsType='Equity Options (Cliquet)'"/>
<xsl:when test="$rollFrequency='1M' "/>
<xsl:when test="$rollFrequency='2M' and $docsType='Equity Options (Cliquet)'"/>
<xsl:when test="$rollFrequency='3M' "/>
<xsl:when test="$rollFrequency='6M' "/>
<xsl:when test="$rollFrequency='1Y' "/>
<xsl:when test="$rollFrequency='1T' "/>
<xsl:when test="$productType = 'Equity Share Swap' or $productType = 'Equity Index Swap' "/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid periodMultiplier and period value combination encountered in this context. Value combination = '<xsl:value-of select="$rollFrequency"/>'</text>
</error>
</xsl:otherwise>
</xsl:choose>
<xsl:call-template name="isValidPeriodMultiplier">
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
<xsl:template match="fpml:returnLeg">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:variable name="payer">
<xsl:value-of select="fpml:payerPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="receiver">
<xsl:value-of select="fpml:receiverPartyReference/@href"/>
</xsl:variable>
<xsl:if test="//fpml:interestLeg">
<xsl:if test="not(//fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:interestLeg/fpml:receiverPartyReference[@href=$payer])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The payerPartyReference/@href value does not match the //FpML/trade/equitySwapTransactionSupplement/interestLeg/receiverPartyReference. Value = '<xsl:value-of select="$payer"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not(//fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:interestLeg/fpml:payerPartyReference[@href=$receiver])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The receiverPartyReference/@href value does not match the //FpML/trade/equitySwapTransactionSupplement/interestLeg/payerPartyReference. Value = '<xsl:value-of select="$receiver"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$payer=$receiver">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** payerPartyReference/@href and receiverPartyReference/@href values are the same.</text>
</error>
</xsl:if>
<xsl:if test="fpml:paymentFrequency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected paymentFrequency element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:effectiveDate/@id = 'equityEffectiveDate') ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** effectiveDate/@id must be equal to 'equityEffectiveDate' in this context. Value = '<xsl:value-of select="fpml:notional/@id"/>'</text>
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
<xsl:apply-templates select="fpml:underlyer">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:rateOfReturn">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="not(fpml:notional/@id = 'equityNotionalAmount') ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** notional/@id must be equal to 'equityNotionalAmount' in this context. Value = '<xsl:value-of select="fpml:notional/@id"/>'</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:notional">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:amount">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:return">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:fxFeature and not($docsType = 'ISDA2005EquitySwapAsiaExcludingJapanInterdealer' or $docsType ='ISDA2009EquitySwapPanAsia' or $docsType ='EquitySwapPanAsiaPrivate')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected fxFeature element encountered in this context.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:rateOfReturn">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:apply-templates select="fpml:initialPrice">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:notionalReset">
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">notionalReset</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:notionalReset"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:valuationPriceInterim and (//fpml:swbEquitySwapDetails/fpml:swbBulletIndicator = 'true' or //fpml:swbEquitySwapDetails/fpml:swbFullyFunded or //fpml:swbEquitySwapDetails/fpml:swbSpreadDetails)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected valuationPriceInterim element encountered in this context.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:valuationPriceInterim">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:valuationPriceFinal">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:paymentDates">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:exchangeTradedContractNearest">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected exchangeTradedContractNearest element encountered in this context.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:initialPrice">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="fpml:commission">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected commission element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:amountRelativeTo">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected amountRelativeTo element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:grossPrice">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected grossPrice element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:accruedInterestPrice">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected accruedInterestPrice element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:fxConversion">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected fxConversion element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:cleanNetPrice">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected cleanNetPrice element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:quotationCharacteristics">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected quotationCharacteristics element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:valuationRules">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected valuationRules element encountered in this context.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:valuationPriceInterim|fpml:valuationPriceFinal">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="fpml:commission">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected commission element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:determinationMethod)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing determinationMethod element in this context.</text>
</error>
</xsl:if>
<xsl:if test="($productType = 'Equity Share Swap' or $productType = 'Equity Index Swap') and $docsTypeEqSwap = 'Equity Swap (AEJ)' and $docsType = 'ISDA2005EquitySwapAsiaExcludingJapanInterdealer'">
<xsl:if test="self::fpml:valuationPriceFinal and fpml:determinationMethod != 'AsSpecifiedInMasterConfirmation'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected value of 'determinationMethod' in the context, only 'AsSpecifiedInMasterConfirmation' is allowed for AEJ 2005 ISDA EIS or ESS.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="($productType = 'Equity Index Swap') and $docsTypeEqSwap = 'Equity Swap (Americas)' and ($docsType = 'ISDA2004EquityAmericasInterdealer' or $docsType = 'ISDA2009EquitySwapAmericas')">
<xsl:if test="self::fpml:valuationPriceFinal and (fpml:determinationMethod != 'Close' and fpml:determinationMethod != 'AsSpecifiedInMasterConfirmation')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected value of 'determinationMethod' in the context, only 'Close' and 'AsSpecifiedInMasterConfirmation' are allowed for ISDA 2004 Interdealer and ISDA 2009 on America MCA EIS.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="($productType = 'Equity Index Swap') and $docsTypeEqSwap = 'Equity Swap (Europe)' and $docsType = 'ISDA2009EquityEuropeanInterdealer'">
<xsl:if test="self::fpml:valuationPriceFinal and fpml:determinationMethod != 'Close'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected value of 'determinationMethod' in the context, only 'Close' is allowed for Europe 2009 ISDA EIS.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="($productType = 'Equity Index Swap') and $docsTypeEqSwap = 'Equity Swap (Global)' and $docsType = 'EquitySwapGlobalPrivate'">
<xsl:if test="self::fpml:valuationPriceFinal and fpml:determinationMethod != 'Close' and fpml:determinationMethod != 'AsSpecifiedInMasterConfirmation' and fpml:determinationMethod != 'HedgeExecution' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected value of 'determinationMethod' in the context, only 'Close', 'AsSpecifiedInMasterConfirmation', 'HedgeExecution' are allowed for Global Private EIS.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="($productType = 'Equity Index Swap' or $productType = 'Equity Share Swap') and $docsTypeEqSwap = 'Equity Swap (Pan Asia)' and $docsType = 'ISDA2009EquitySwapPanAsia'">
<xsl:if test="self::fpml:valuationPriceFinal and fpml:determinationMethod != 'Close' and fpml:determinationMethod != 'AsSpecifiedInMasterConfirmation' and fpml:determinationMethod != 'HedgeExecution' and fpml:determinationMethod != 'TWAP' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected value of 'determinationMethod' in the context, only 'Close', 'AsSpecifiedInMasterConfirmation', 'HedgeExecution' and 'TWAP' are allowed for PanAsia 2009 ISDA EIS and ESS.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="($productType = 'Equity Index Swap') and $docsTypeEqSwap = 'Equity Swap (AEJ)' and $docsType = 'EquitySwapAEJPrivate'">
<xsl:if test="self::fpml:valuationPriceFinal and (fpml:determinationMethod != 'Close' and fpml:determinationMethod !='AsSpecifiedInMasterConfirmation' and fpml:determinationMethod !='HedgeExecution')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected value of 'determinationMethod' in the context, only 'Close', 'AsSpecifiedInMasterConfirmation' or 'HedgeExecution' are allowed for AEJ Private EIS</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="($productType = 'Equity Index Swap') and $docsTypeEqSwap = 'Equity Swap (Emerging)' and ($docsType = 'EmergingEquitySwapIndustry')">
<xsl:if test="self::fpml:valuationPriceFinal and (fpml:determinationMethod != 'Close' and fpml:determinationMethod != 'AsSpecifiedInMasterConfirmation' and fpml:determinationMethod != 'HedgeExecution')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected value of 'determinationMethod' in the context, only 'Close', 'AsSpecifiedInMasterConfirmation' or 'HedgeExecution' are allowed for Emerging Industry EIS.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$productType = 'Equity Share Swap' and $docsTypeEqSwap = 'Equity Swap (Americas)' and $docsType = 'ISDA2004EquityAmericasInterdealer'">
<xsl:if test="self::fpml:valuationPriceFinal and fpml:determinationMethod != 'AsSpecifiedInMasterConfirmation' and fpml:determinationMethod != 'Close'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected value of 'determinationMethod' in the context, only 'AsSpecifiedInMasterConfirmation' or 'Close' are allowed for Americas 2004 Interdealer ESS.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="($productType = 'Equity Share Swap') and $docsTypeEqSwap = 'Equity Swap (Americas)' and $docsType = 'ISDA2009EquitySwapAmericas'">
<xsl:if test="self::fpml:valuationPriceFinal and (fpml:determinationMethod != 'VWAP' and fpml:determinationMethod != 'Close')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected value of 'determinationMethod' in the context, only 'VWAP' and 'Close' are allowed for Americas 2009 ISDA ESS.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="($productType = 'Equity Share Swap') and $docsTypeEqSwap = 'Equity Swap (Europe)' and ($docsType = 'ISDA2009EquityEuropeanInterdealer' or $docsType ='ISDA2007EquityFinanceSwapEuropean')">
<xsl:if test="self::fpml:valuationPriceFinal and (fpml:determinationMethod != 'AsSpecifiedInMasterConfirmation' and fpml:determinationMethod != 'Close' and fpml:determinationMethod != 'HedgeExecution')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected value of 'determinationMethod' in the context, only 'AsSpecifiedInMasterConfirmation', 'HedgeExecution' and 'Close' are allowed for Europe 2009 ISDA and 2009 ISDA FVSS for ESS.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="($productType = 'Equity Share Swap') and $docsTypeEqSwap = 'Equity Swap (AEJ)' and $docsType = 'EquitySwapAEJPrivate'">
<xsl:if test="self::fpml:valuationPriceFinal and (fpml:determinationMethod != 'Close' and fpml:determinationMethod !='AsSpecifiedInMasterConfirmation' and fpml:determinationMethod !='HedgeExecution' and fpml:determinationMethod !='VWAP')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected value of 'determinationMethod' in the context, only 'Close', 'AsSpecifiedInMasterConfirmation', 'VWAP' or 'HedgeExecution' are allowed for AEJ Private ESS</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="($productType = 'Equity Share Swap' ) and $docsTypeEqSwap = 'Equity Swap (Emerging)' and ($docsType = 'EmergingEquitySwapIndustry')">
<xsl:if test="self::fpml:valuationPriceFinal and (fpml:determinationMethod != 'Close' and fpml:determinationMethod != 'AsSpecifiedInMasterConfirmation' and fpml:determinationMethod != 'HedgeExecution' and fpml:determinationMethod != 'VWAP')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected value of 'determinationMethod' in the context, only 'Close', 'AsSpecifiedInMasterConfirmation', 'VWAP' or 'HedgeExecution' are allowed for Emerging Industry ESS.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:amountRelativeTo">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected amountRelativeTo element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:grossPrice">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected grossPrice element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:netPrice">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected netPrice element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:accruedInterestPrice">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected accruedInterestPrice element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:fxConversion">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected fxConversion element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:cleanNetPrice">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected cleanNetPrice element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:quotationCharacteristics">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected quotationCharacteristics element encountered in this context.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:paymentDates">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:apply-templates select="fpml:paymentDatesInterim">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:paymentDateFinal">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:paymentDatesInterim">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="fpml:adjustableDates and not(//fpml:swbSchedulingMethod = 'ListDateEntry')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected adjustableDates element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:adjustableDates) and (//fpml:swbSchedulingMethod = 'ListDateEntry')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing adjustableDates element in this context for ListDateEntry Mode.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:relativeDates">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:paymentDateFinal">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="fpml:adjustableDates and not(//fpml:swbSchedulingMethod = 'ListDateEntry')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected adjustableDates element encountered in this context.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:relativeDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:relativeDates">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:call-template name="isValidPeriodMultiplier">
<xsl:with-param name="elementName">periodMultiplier</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:periodMultiplier"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="fpml:period!='D'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** period must be equal to 'D' in this context. Value = '<xsl:value-of select="fpml:period"/>'</text>
</error>
</xsl:if>
<xsl:if test="fpml:dayType != 'CurrencyBusiness'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** dayType must be equal to 'CurrencyBusiness' in this context. Value = '<xsl:value-of select="fpml:dayType"/>'</text>
</error>
</xsl:if>
<xsl:if test="($productType='Equity Share Swap' or $productType='Equity Index Swap')">
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
</xsl:if>
<xsl:if test="fpml:businessCentersReference">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected businessCentersReference element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:businessCenters) and ($productType='Equity Share Swap' or $productType='Equity Index Swap')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing businessCenters element in this context.</text>
</error>
</xsl:if>
<xsl:if test="not(//fpml:swbEquitySwapDetails/fpml:swbBulletIndicator = 'true') and fpml:dateRelativeTo/@href != 'interimValuationDate'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** dateRelativeTo/@href must be equal to 'interimValuationDate' in this context. Value = '<xsl:value-of select="fpml:dateRelativeTo/@href"/>'</text>
</error>
</xsl:if>
<xsl:if test="fpml:periodSkip">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected periodSkip element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:scheduleBounds">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected scheduleBounds element encountered in this context.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:return">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="$productType = 'Equity Share Swap' or $productType = 'Equity Index Swap' ">
<xsl:if test="fpml:dividendConditions and not(//fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:returnLeg/fpml:return/fpml:returnType = 'Total') ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected dividendConditions element encountered where returnType is not 'Total'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:dividendConditions">
<xsl:apply-templates select="fpml:dividendConditions">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:dividendConditions">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="fpml:dividendEntitlement">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected dividendEntitlement element encountered in this context.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:dividendPaymentDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:dividendAmount">
<xsl:choose>
<xsl:when test="not(fpml:dividendAmount = 'ExAmount') and not(fpml:dividendAmount = 'RecordAmount') and not(fpml:dividendAmount = 'AsSpecifiedInMasterConfirmation') and not(fpml:dividendAmount = '')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected value found for dividend amount. Available values are "ExAmount", "RecordAmount", "AsSpecifiedInMasterConfirmation" or empty string but found "<xsl:value-of select="fpml:dividendAmount"/>"</text>
</error>
</xsl:when>
</xsl:choose>
</xsl:if>
<xsl:if test="fpml:dividendPeriod">
<xsl:choose>
<xsl:when test="not(fpml:dividendPeriod = 'FirstPeriod') and not(fpml:dividendPeriod = 'SecondPeriod') and not(fpml:dividendPeriod = '')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected value found for dividend period. Available values are "FirstPeriod", "SecondPeriod" or empty string but found "<xsl:value-of select="fpml:dividendPeriod"/>" </text>
</error>
</xsl:when>
</xsl:choose>
</xsl:if>
<xsl:if test="fpml:extraOrdinaryDividends">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected extraOrdinaryDividends element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:excessDividendAmount">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected excessDividendAmount element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:currency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected currency element encountered in this context.</text>
</error>
</xsl:if>
<xsl:variable name="dividendSettlementCurrencyFieldApplicable">
<xsl:choose>
<xsl:when test="$docsType = 'EquitySwapAmericasPrivate' ">true</xsl:when>
<xsl:when test="$docsType = 'ISDA2009EquityEuropeanInterdealer' ">true</xsl:when>
<xsl:when test="$docsType = 'EmergingEquitySwapIndustry' ">true</xsl:when>
<xsl:when test="$docsType = 'EmergingEquitySwapLATAM' ">true</xsl:when>
<xsl:when test="$docsType = 'EmergingEquitySwapEMEA' ">true</xsl:when>
<xsl:when test="$docsType = 'ISDA2010FairValueShareSwapEuropeanInterdealer' ">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:if test="fpml:determinationMethod and $dividendSettlementCurrencyFieldApplicable='false' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected determinationMethod element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:determinationMethod">
<xsl:if test="not(fpml:determinationMethod = 'SettlementCurrency' or fpml:determinationMethod = 'IssuerPaymentCurrency') ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected determinationMethod element value. Valid values are SettlementCurrency and IssuerPaymentCurrency. Value = '<xsl:value-of select="fpml:determinationMethod"/>'</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:currencyReference">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected currencyReference element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:paymentCurrency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected paymentCurrency element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:dividendFxTriggerDate">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected dividendFxTriggerDate element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:interestAccrualsMethod">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected interestAccrualsMethod element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:numberOfIndexUnits">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected numberOfIndexUnits element encountered in this context.</text>
</error>
</xsl:if>
<xsl:variable name="declaredCashDividendPercentageFieldApplicable">
<xsl:choose>
<xsl:when test="$docsType = 'ISDA2009EquitySwapAmericas' and $productType = 'Equity Index Swap' ">true</xsl:when>
<xsl:when test="$docsType = 'EquitySwapAmericasPrivate' and $productType = 'Equity Index Swap' ">true</xsl:when>
<xsl:when test="$docsType = 'ISDA2009EquityEuropeanInterdealer' ">true</xsl:when>
<xsl:when test="$docsType = 'ISDA2007EquityEuropean' ">true</xsl:when>
<xsl:when test="$docsType = 'EquitySwapGlobalPrivate' ">true</xsl:when>
<xsl:when test="$docsType = 'EmergingEquitySwapIndustry' ">true</xsl:when>
<xsl:when test="$docsType = 'EmergingEquitySwapLATAM' ">true</xsl:when>
<xsl:when test="$docsType = 'EmergingEquitySwapEMEA' ">true</xsl:when>
<xsl:when test="$docsType = 'ISDA2010FairValueShareSwapEuropeanInterdealer' ">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:if test="fpml:declaredCashDividendPercentage and $declaredCashDividendPercentageFieldApplicable = 'false' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected declaredCashDividendPercentage element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:declaredCashDividendPercentage and $declaredCashDividendPercentageFieldApplicable = 'true' ">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">declaredCashDividendPercentage</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:declaredCashDividendPercentage"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">9.9999999</xsl:with-param>
<xsl:with-param name="maxDecs">7</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:variable name="declaredCashEquivalentDividendPercentageFieldApplicable">
<xsl:choose>
<xsl:when test="$docsType = 'ISDA2009EquitySwapAmericas' and $productType = 'Equity Index Swap' ">true</xsl:when>
<xsl:when test="$docsType = 'EquitySwapAmericasPrivate' and $productType = 'Equity Index Swap' ">true</xsl:when>
<xsl:when test="$docsType = 'ISDA2009EquityEuropeanInterdealer' ">true</xsl:when>
<xsl:when test="$docsType = 'ISDA2007EquityEuropean' ">true</xsl:when>
<xsl:when test="$docsType = 'EquitySwapGlobalPrivate' ">true</xsl:when>
<xsl:when test="$docsType = 'EmergingEquitySwapIndustry' ">true</xsl:when>
<xsl:when test="$docsType = 'EmergingEquitySwapLATAM' ">true</xsl:when>
<xsl:when test="$docsType = 'EmergingEquitySwapEMEA' ">true</xsl:when>
<xsl:when test="$docsType = 'ISDA2010FairValueShareSwapEuropeanInterdealer' ">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:if test="fpml:declaredCashEquivalentDividendPercentage and $declaredCashEquivalentDividendPercentageFieldApplicable = 'false' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected declaredCashEquivalentDividendPercentage element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:declaredCashEquivalentDividendPercentage and $declaredCashEquivalentDividendPercentageFieldApplicable = 'true' ">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">declaredCashEquivalentDividendPercentage</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:declaredCashEquivalentDividendPercentage"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">9.9999999</xsl:with-param>
<xsl:with-param name="maxDecs">7</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:variable name="nonCashDividendTreatmentFieldApplicable">
<xsl:choose>
<xsl:when test="$docsType = 'ISDA2009EquityEuropeanInterdealer' ">true</xsl:when>
<xsl:when test="$docsType = 'EmergingEquitySwapIndustry' ">true</xsl:when>
<xsl:when test="$docsType = 'EmergingEquitySwapLATAM' ">true</xsl:when>
<xsl:when test="$docsType = 'EmergingEquitySwapEMEA' ">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:if test="fpml:nonCashDividendTreatment and $nonCashDividendTreatmentFieldApplicable='false' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected nonCashDividendTreatment element encountered in this context.</text>
</error>
</xsl:if>
<xsl:variable name="dividendCompositionFieldApplicable">
<xsl:choose>
<xsl:when test="$docsType = 'ISDA2009EquityEuropeanInterdealer' ">true</xsl:when>
<xsl:when test="$docsType = 'EmergingEquitySwapIndustry' ">true</xsl:when>
<xsl:when test="$docsType = 'EmergingEquitySwapLATAM' ">true</xsl:when>
<xsl:when test="$docsType = 'EmergingEquitySwapEMEA' ">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:if test="fpml:dividendComposition and $dividendCompositionFieldApplicable='false' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected dividendComposition element encountered in this context.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:dividendPaymentDate">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:variable name="paymentDateOffsetFieldApplicable">
<xsl:choose>
<xsl:when test="fpml:dividendDateReference = 'SharePayment' ">true</xsl:when>
<xsl:when test="fpml:dividendDateReference = 'ExDate' and ($docsType = 'EquitySwapEuropePrivate' or $docsType = 'ISDA2009EquityEuropeanInterdealer')">true</xsl:when>
<xsl:when test="fpml:dividendDateReference = 'ExDate' and $productType = 'Equity Share Swap' and $docsType = 'EmergingEquitySwapIndustry'">true</xsl:when>
<xsl:when test="fpml:dividendDateReference = 'ExDate' and ($productType = 'Equity Share Swap' or $productType = 'Equity Index Swap') and ($docsType = 'EmergingEquitySwapLATAM' or $docsType = 'EmergingEquitySwapEMEA')">true</xsl:when>
<xsl:when test="fpml:dividendDateReference = 'ExDividendPaymentDate' and $docsType = 'ISDA2010FairValueShareSwapEuropeanInterdealer'">true</xsl:when>
<xsl:when test="fpml:dividendDateReference = 'DividendValuationDate' and ($docsType='ISDA2009EquitySwapPanAsia' or $docsType='EquitySwapPanAsiaPrivate')">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:if test="fpml:paymentDateOffset and $paymentDateOffsetFieldApplicable = 'false' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected paymentDateOffset element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:paymentDateOffset) and $paymentDateOffsetFieldApplicable = 'true' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing paymentDateOffset element in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:paymentDateOffset/fpml:periodMultiplier">
<xsl:call-template name="isValidPeriodMultiplier">
<xsl:with-param name="elementName">paymentDateOffset/periodMultiplier</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:paymentDateOffset/fpml:periodMultiplier"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:paymentDateOffset/period != 'D'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** period must be equal to 'D' in this context. Value = '<xsl:value-of select="fpml:period"/>'</text>
</error>
</xsl:if>
<xsl:if test="fpml:paymentDateOffset/dayType != 'CurrencyBusiness' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** paymentDateOffset/dayType must have a value of 'CurrencyBusiness' in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:adjustableDate">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected adjustableDate element encountered in this context.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:equityAmount">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="not(fpml:cashSettlement[.='true'])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid cashSettlement element value. Must contain 'true'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:referenceAmount">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected referenceAmount element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:formula">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected formula element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:encodedDescription">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected encodedDescription element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:calculationDates">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected calculationDates element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:optionsExchangeDividends">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected optionsExchangeDividends element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:additionalDividends">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected additionalDividends element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:observationStartDate)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing observationStartDate element in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:allDividends and ($productType = 'Index Variance Swap' or ($docsType='ISDA2006VarianceSwapJapaneseInterdealer' or $docsType='ISDA2004EquityAmericasInterdealer' or $docsType='ISDA2008EquityAmericas'))">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected allDividends element encountered in this context when productType is 'Index Variance Swap' or brokerConfirmationType is 'ISDA2006VarianceSwapJapaneseInterdealer' or brokerConfirmationType is 'ISDA2004EquityAmericasInterdealer' or 'ISDA2008EquityAmericas'.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:variance">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:cashSettlementPaymentDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:observationStartDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:amount">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="not($productType='Equity Share Swap' or $productType='Equity Index Swap')">
<xsl:if test="fpml:calculationDates">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected calculationDates element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="not(//fpml:observationStartDate)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing observationStartDate element in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:optionsExchangeDividends">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected optionsExchangeDividends element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:additionalDividends">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected additionalDividends element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:currency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected currency element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:determinationMethod">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected determinationMethod element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:currencyReference">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected currencyReference element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="($productType!='Dispersion Variance Swap')">
<xsl:if test="not(fpml:paymentCurrency)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing paymentCurrency element in this context.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:paymentCurrency/@id = 'equityPaymentCurrency') ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** paymentCurrency/@id must be equal to 'equityPaymentCurrency' in this context. Value = '<xsl:value-of select="fpml:paymentCurrency/@id"/>'</text>
</error>
</xsl:if>
<xsl:call-template name="isValidCurrency">
<xsl:with-param name="elementName">paymentCurrency/currency</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:paymentCurrency/fpml:currency"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="not(fpml:referenceAmount = 'StandardISDA')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** referenceAmount must equal to 'StandardISDA' in this context.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:paymentCurrency/fpml:determinationMethod">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected paymentCurrency/determinationMethod element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:formula">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected formula element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:encodedDescription">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected encodedDescription element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:variance and $productType!='Dispersion Variance Swap'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected variance element encountered in this context.</text>
</error>
</xsl:if>
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">cashSettlement</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:cashSettlement"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:apply-templates select="fpml:variance">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
<xsl:if test="$productType='Equity Share Swap' or $productType='Equity Index Swap' ">
<xsl:if test="fpml:currency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected currency element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:determinationMethod">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected determinationMethod element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:currencyReference">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected currencyReference element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:paymentCurrency)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing paymentCurrency element in this context.</text>
</error>
</xsl:if>
<xsl:call-template name="isValidCurrency">
<xsl:with-param name="elementName">paymentCurrency/currency</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:paymentCurrency/fpml:currency"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="fpml:paymentCurrency/fpml:determinationMethod">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected paymentCurrency/determinationMethod element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:referenceAmount = 'StandardISDA')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** referenceAmount must equal to 'StandardISDA' in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:formula">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected formula element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:encodedDescription">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected encodedDescription element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:variance">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected variance element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:calculationDates">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected calculationDates element encountered in this context.</text>
</error>
</xsl:if>
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">cashSettlement</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:cashSettlement"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="fpml:optionsExchangeDividends">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected optionsExchangeDividends element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:additionalDividends">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected additionalDividends element encountered in this context.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:variance">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="fpml:initialLevel">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">initialLevel</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:initialLevel"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.01</xsl:with-param>
<xsl:with-param name="maxIncl">999999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:closingLevel">
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">closingLevel</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:closingLevel"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:expiringLevel and $productType = 'Share Variance Swap'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected expiringLevel element in this context. Element must not be present when productType is 'Share Variance Swap'.</text>
</error>
</xsl:if>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">amount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:varianceAmount/fpml:amount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.01</xsl:with-param>
<xsl:with-param name="maxIncl">9999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="not(fpml:varianceStrikePrice)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing varianceStrikePrice element in this context. Element must be present for all Variance Swap products - the volatilityStrikePrice element should be submitted in the swVarianceSwapDetails or swDispersionVarianceSwap details component.</text>
</error>
</xsl:if>
<xsl:if test="fpml:varianceStrikePrice">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">varianceStrikePrice</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:varianceStrikePrice"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.0001</xsl:with-param>
<xsl:with-param name="maxIncl">99999999.9999</xsl:with-param>
<xsl:with-param name="maxDecs">4</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:expiringLevel">
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">expiringLevel</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:expiringLevel"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="not(fpml:expectedN) and //fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbVarianceSwapDetails/fpml:swbExpectedNOverride[.='true']">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing expectedN element in this context. Element must be present for all Variance Swap products where the expectedN value has been overridden.</text>
</error>
</xsl:if>
<xsl:if test="fpml:varianceCap[.='true'] and not(fpml:unadjustedVarianceCap)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing unadjustedVarianceCap element when varianceCap is set to 'true'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:varianceCap">
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">varianceCap</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:varianceCap"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:varianceCap[.='false'] and fpml:unadjustedVarianceCap">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected unadjustedVarianceCap element when varianceCap is set to 'false'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:volatilityStrikePrice">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected volatilityStrikePrice element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:exchangeTradedContractNearest">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected exchangeTradedContractNearest element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:vegaNotionalAmount)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing vegaNotionalAmount element in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:vegaNotionalAmount">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">vegaNotionalAmount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:vegaNotionalAmount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.01</xsl:with-param>
<xsl:with-param name="maxIncl">9999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:fxFeature and $docsType != 'ISDA2007VarianceSwapAsiaExcludingJapan'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected fxFeature element in this context. Element must not be present when brokerConfirmationType is not 'ISDA2007VarianceSwapAsiaExcludingJapan'.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:fxFeature) and $docsType='ISDA2007VarianceSwapAsiaExcludingJapan'">
<xsl:choose>
<xsl:when test="fpml:varianceAmount/fpml:currency = 'AUD'"/>
<xsl:when test="fpml:varianceAmount/fpml:currency = 'HKD'"/>
<xsl:when test="fpml:varianceAmount/fpml:currency = 'NZD'"/>
<xsl:when test="fpml:varianceAmount/fpml:currency = 'SGD'"/>
<xsl:when test="fpml:varianceAmount/fpml:currency = 'USD'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing fxFeature element  when brokerConfirmationType is 'ISDA2007VarianceSwapAsiaExcludingJapan' and varianceAmount/currency is a non-deliverable currency.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:apply-templates select="fpml:fxFeature">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:cashSettlementPaymentDate">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="fpml:adjustableDate">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected adjustableDate element encountered in this context.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:relativeDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:observationStartDate">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="fpml:relativeDate">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected relativeDate element encountered in this context.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:adjustableDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template name="isValidRollConvention">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:choose>
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
<xsl:when test="$elementValue='EOM'"/>
<xsl:when test="$elementValue='NONE'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** Invalid value for fpml:rollConvention. Value = '<xsl:value-of select="$elementValue"/>'</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template name="isValidBoolean">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> element. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
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
<xsl:template name="isValidCurrency">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> element. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='BHD'"/>
<xsl:when test="$elementValue='CAD'"/>
<xsl:when test="$elementValue='CHF'"/>
<xsl:when test="$elementValue='DKK'"/>
<xsl:when test="$elementValue='EUR'"/>
<xsl:when test="$elementValue='GBP'"/>
<xsl:when test="$elementValue='JPY'"/>
<xsl:when test="$elementValue='NOK'"/>
<xsl:when test="$elementValue='SEK'"/>
<xsl:when test="$elementValue='USD'"/>
<xsl:when test="$elementValue='HKD'"/>
<xsl:when test="$elementValue='AUD'"/>
<xsl:when test="$elementValue='SGD'"/>
<xsl:when test="$elementValue='NZD'"/>
<xsl:when test="$elementValue='PLN'"/>
<xsl:when test="$elementValue='TRY'"/>
<xsl:when test="$elementValue='ZAR'"/>
<xsl:when test="$elementValue='EGP'"/>
<xsl:when test="$elementValue='CZK'"/>
<xsl:when test="$elementValue='HUF'"/>
<xsl:when test="$elementValue='ILS'"/>
<xsl:when test="$elementValue='KWD'"/>
<xsl:when test="$elementValue='QAR'"/>
<xsl:when test="$elementValue='RUB'"/>
<xsl:when test="$elementValue='AED'"/>
<xsl:when test="$elementValue='BRL'"/>
<xsl:when test="$elementValue='INR'"/>
<xsl:when test="$elementValue='KRW'"/>
<xsl:when test="$elementValue='TWD'"/>
<xsl:when test="$elementValue='THB'"/>
<xsl:when test="$elementValue='MYR'"/>
<xsl:when test="$elementValue='PKR'"/>
<xsl:when test="$elementValue='PHP'"/>
<xsl:when test="$elementValue='VNP'"/>
<xsl:when test="$elementValue='IDR'"/>
<xsl:when test="$elementValue='RON'"/>
<xsl:when test="$elementValue='MAD'"/>
<xsl:when test="$elementValue='COP'"/>
<xsl:when test="$elementValue='NGN'"/>
<xsl:when test="$elementValue='MXN'"/>
<xsl:when test="$elementValue='OMR'"/>
<xsl:when test="$elementValue='SAR'"/>
<xsl:when test="$elementValue='CLP'"/>
<xsl:when test="$elementValue='UAH'"/>
<xsl:when test="$elementValue='CNY' and (//fpml:swExtendedTradeDetails/fpml:swChinaConnect)"/>
<xsl:when test="$elementValue='XXX'"/>
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
<xsl:when test="$elementValue='NotApplicable'"/>
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
<xsl:template name="isValidDefaultSettlementMethod">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> element. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='Cash'"/>
<xsl:when test="$elementValue='Physical'"/>
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
<xsl:template name="isValidSettlementPriceDefaultElectionMethod">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> element. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='Close'"/>
<xsl:when test="$elementValue='HedgeExecution'"/>
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
<xsl:template name="isValidStrategyType">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> element. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='Butterfly'"/>
<xsl:when test="$elementValue='Calendar Spread'"/>
<xsl:when test="$elementValue='Risk Reversal'"/>
<xsl:when test="$elementValue='Custom'"/>
<xsl:when test="$elementValue='Ratio Spread'"/>
<xsl:when test="$elementValue='Spread'"/>
<xsl:when test="$elementValue='Straddle'"/>
<xsl:when test="$elementValue='Strangle'"/>
<xsl:when test="$elementValue='Synthetic Underlying'"/>
<xsl:when test="$elementValue='Option with Synthetic Fwd'"/>
<xsl:when test="$elementValue='Synthetic Roll'"/>
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
<xsl:template name="isValidEquityConfirmationType">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> element. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='2004EquityEuropeanInterdealer'"/>
<xsl:when test="$elementValue='ISDA2007EquityEuropean'"/>
<xsl:when test="$elementValue='EquityOptionEuropePrivate'"/>
<xsl:when test="$elementValue='ISDA2005EquityJapaneseInterdealer'"/>
<xsl:when test="$elementValue='ISDA2008EquityJapanese'"/>
<xsl:when test="$elementValue='ISDA2005EquityAsiaExcludingJapanInterdealer'"/>
<xsl:when test="$elementValue='EquityOptionAEJPrivate'"/>
<xsl:when test="$elementValue='ISDA2008EquityAsiaExcludingJapan'"/>
<xsl:when test="$elementValue='ISDA2004EquityAmericasInterdealer'"/>
<xsl:when test="$elementValue='ISDA2008EquityAmericas'"/>
<xsl:when test="$elementValue='ISDA2009EquityAmericas'"/>
<xsl:when test="$elementValue='EquityOptionAmericasPrivate'"/>
<xsl:when test="$elementValue='ISDA2010EquityEMEAInterdealer'"/>
<xsl:when test="$elementValue='EquityOptionEMEAPrivate'"/>
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
<xsl:template name="isValidEquityExpirationTimeType">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> element. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$productType = 'Equity Index Option' and ($docsType='2004EquityEuropeanInterdealer' or $docsType='ISDA2007EquityEuropean' or $docsType='EquityOptionEuropePrivate')">
<xsl:choose>
<xsl:when test="$elementValue='OSP'"/>
<xsl:when test="$elementValue='Open'"/>
<xsl:when test="$elementValue='Close'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/> When product type is 'Equity Index Option' and brokerConfirmationType is '2004EquityEuropeanInterdealer' or 'ISDA2007EquityEuropean' or 'EquityOptionEuropePrivate', the permitted values are 'OSP', 'Open' or 'Close'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType = 'Equity Share Option' and ($docsType='EquityOptionAmericasPrivate' or $docsType='EquityOptionAEJPrivate' or $docsType='EquityOptionEMEAPrivate')">
<xsl:choose>
<xsl:when test="$elementValue='AsSpecifiedInMasterConfirmation' "/>
<xsl:when test="$elementValue='Open' "/>
<xsl:when test="$elementValue='OSP'"/>
<xsl:when test="$elementValue='Close'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/> When product type is 'Equity Share Option' , the permitted values are 'AsSpecifiedInMasterConfirmation' or 'Open' or 'OSP' or 'Close'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType = 'Equity Share Option' and ($docsType='2004EquityEuropeanInterdealer' or $docsType='ISDA2007EquityEuropean' or $docsType='EquityOptionEuropePrivate')">
<xsl:choose>
<xsl:when test="$elementValue='AsSpecifiedInMasterConfirmation'"/>
<xsl:when test="$elementValue='Open'"/>
<xsl:when test="$elementValue='Close'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/> When product type is 'Equity Share Option' and brokerConfirmationType is '2004EquityEuropeanInterdealer' or 'ISDA2007EquityEuropean' or 'EquityOptionEuropePrivate', the permitted values are 'AsSpecifiedInMasterConfirmation', 'Open' or 'Close'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType = 'Equity Index Option' and ($docsType='ISDA2004EquityAmericasInterdealer' or $docsType='ISDA2008EquityAmericas')">
<xsl:choose>
<xsl:when test="$elementValue='AsSpecifiedInMasterConfirmation'"/>
<xsl:when test="$elementValue='OSP'"/>
<xsl:when test="$elementValue='Open'"/>
<xsl:when test="$elementValue='Close'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/> When product type is 'Equity Index Option' and Docs Type is 'Equity Options (Americas)', the permitted values are 'OSP', 'Open' or 'Close'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType = 'Equity Share Option' and ($docsType='ISDA2004EquityAmericasInterdealer' or $docsType='ISDA2008EquityAmericas')">
<xsl:choose>
<xsl:when test="$elementValue='AsSpecifiedInMasterConfirmation'"/>
<xsl:when test="$elementValue='Open'"/>
<xsl:when test="$elementValue='Close'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/> When product type is 'Equity Share Option' and Docs Type is 'Equity Options (Americas)', the permitted values are 'AsSpecifiedInMasterConfirmation', 'Open' or 'Close'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="($productType = 'Equity Share Option' or $productType = 'Equity Index Option') and ($docsType='ISDA2009EquityAmericas')">
<xsl:choose>
<xsl:when test="$elementValue='AsSpecifiedInMasterConfirmation' "/>
<xsl:when test="$elementValue='SpecificTime' "/>
<xsl:when test="$elementValue='OSP'"/>
<xsl:when test="$elementValue='Close'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/> When product type is 'Equity Share Option' or 'Equity Index Option' and Docs Type is 'ISDA2009EquityAmericas', the permitted values are 'AsSpecifiedInMasterConfirmation' or 'SpecificTime' or 'OSP' or 'Close'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="($productType = 'Equity Index Option') and ($docsType='EquityOptionAmericasPrivate')">
<xsl:choose>
<xsl:when test="$elementValue='AsSpecifiedInMasterConfirmation' "/>
<xsl:when test="$elementValue='SpecificTime' "/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/> When product type is 'Equity Share Option' or 'Equity Index Option' and Docs Type is 'EquityOptionAmericasPrivate', the permitted values are 'AsSpecifiedInMasterConfirmation' or 'SpecificTime'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="($productType = 'Equity Share Option' or $productType = 'Equity Share Option Strategy') and ($docsType='ISDA2005EquityJapaneseInterdealer' or $docsType='ISDA2008EquityJapanese')">
<xsl:choose>
<xsl:when test="$elementValue='MorningClose'"/>
<xsl:when test="$elementValue='Close'"/>
<xsl:when test="$elementValue='AsSpecifiedInMasterConfirmation'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/> When product type is 'Equity Share Option' or 'Equity Share Option Strategy' and Docs Type is 'Equity Options (Japan)' under the 2005/2008 MCA, the permitted values are 'MorningClose' or 'Close' or 'AsSpecifiedInMasterConfirmation'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType = 'Equity Index Option' and ($docsType='ISDA2008EquityJapanese') and //fpml:futuresPriceValuation='true'">
<xsl:choose>
<xsl:when test="$elementValue='AsSpecifiedInMasterConfirmation'"/>
<xsl:when test="$elementValue='OSP'"/>
<xsl:when test="$elementValue='Close'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/> When product type is 'Equity Index Option' and Docs Type is 'ISDA2008EquityJapanese', the permitted values are 'AsSpecifiedInMasterConfirmation', 'OSP' when FPV is 'true'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:otherwise>
<xsl:choose>
<xsl:when test="$elementValue='AsSpecifiedInMasterConfirmation'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/> Element must be passed with a value of 'AsSpecifiedInMasterConfirmation' when brokerConfirmationType is 'ISDA2005EquityJapaneseInterdealer' or 'ISDA2008EquityJapanese' OR you have chosen another invalid value.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template name="isValidHourMinuteTime">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Missing, empty or invalid <xsl:value-of select="$elementName"/>. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:variable name="hour">
<xsl:value-of select="substring($elementValue,1,2)"/>
</xsl:variable>
<xsl:variable name="minute">
<xsl:value-of select="substring($elementValue,4,2)"/>
</xsl:variable>
<xsl:variable name="second">
<xsl:value-of select="substring($elementValue,7,2)"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$hour='00' "/>
<xsl:when test="$hour='01' "/>
<xsl:when test="$hour='02' "/>
<xsl:when test="$hour='03' "/>
<xsl:when test="$hour='04' "/>
<xsl:when test="$hour='05' "/>
<xsl:when test="$hour='06' "/>
<xsl:when test="$hour='07' "/>
<xsl:when test="$hour='08' "/>
<xsl:when test="$hour='09' "/>
<xsl:when test="$hour='10' "/>
<xsl:when test="$hour='11' "/>
<xsl:when test="$hour='12' "/>
<xsl:when test="$hour='13' "/>
<xsl:when test="$hour='14' "/>
<xsl:when test="$hour='15' "/>
<xsl:when test="$hour='16' "/>
<xsl:when test="$hour='17' "/>
<xsl:when test="$hour='18' "/>
<xsl:when test="$hour='19' "/>
<xsl:when test="$hour='20' "/>
<xsl:when test="$hour='21' "/>
<xsl:when test="$hour='22' "/>
<xsl:when test="$hour='23' "/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/> Invalid Hour value.</text>
</error>
</xsl:otherwise>
</xsl:choose>
<xsl:choose>
<xsl:when test="$minute='00' "/>
<xsl:when test="$minute='15' "/>
<xsl:when test="$minute='30' "/>
<xsl:when test="$minute='45' "/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/> Invalid Minute value.</text>
</error>
</xsl:otherwise>
</xsl:choose>
<xsl:if test="not($second='00')">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/> Invalid Second value.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template name="isValidInstrumentIdScheme">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">>*** @instrumentIdScheme value is Empty or invalid <xsl:value-of select="$elementName"/>. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='http://www.fpml.org/spec/2003/instrument-id-Reuters-RIC-1-0'"/>
<xsl:when test="$elementValue='http://www.fpml.org/spec/2002/instrument-id-ISIN-1-0'"/>
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
<xsl:when test="string(number($elementValue)) != 'NaN' and not(contains($elementValue,'.')) and not(contains($elementValue,' '))">
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
<xsl:template name="isValidPeriod">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> element for product type of '<xsl:value-of select="$productType"/>'. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
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
</xsl:template>
<xsl:template name="isValidPeriodMultiplier">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> element. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
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
<xsl:template name="isValidProductType">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> element WIBBLE when SWBML version = "<xsl:value-of select="$version"/>". Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:if test="$version='4-9'">
<xsl:choose>
<xsl:when test="$elementValue='Index Variance Swap'"/>
<xsl:when test="$elementValue='Share Variance Swap'"/>
<xsl:when test="$elementValue='Equity Share Option'"/>
<xsl:when test="$elementValue='Equity Index Option'"/>
<xsl:when test="$elementValue='Equity Share Swap'"/>
<xsl:when test="$elementValue='Equity Index Swap'"/>
<xsl:when test="$elementValue='Share Dividend Swap'"/>
<xsl:when test="$elementValue='Equity Index Volatility Swap'"/>
<xsl:when test="$elementValue='Equity Share Volatility Swap'"/>
<xsl:when test="$elementValue='Index Dividend Swap'"/>
<xsl:when test="$elementValue='Dispersion Variance Swap'"/>
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
<xsl:template name="isValidRateSource">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> element. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='Reuters'"/>
<xsl:when test="$elementValue='Telerate'"/>
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
<xsl:template name="isValidRateSourcePage">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> element. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='TAIFX1'"/>
<xsl:when test="$elementValue='HKD='"/>
<xsl:when test="$elementValue='KRW='"/>
<xsl:when test="$elementValue='INR='"/>
<xsl:when test="$elementValue='MYR='"/>
<xsl:when test="$elementValue='NZD='"/>
<xsl:when test="$elementValue='IDR01'"/>
<xsl:when test="$elementValue='THBDFIX=ABSG'"/>
<xsl:when test="$elementValue='SIBP'"/>
<xsl:when test="$elementValue='HSRA'"/>
<xsl:when test="$elementValue='Official RBIB'"/>
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
<xsl:template name="isValidReferenceCurrency">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> element. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='AUD'"/>
<xsl:when test="$elementValue='HKD'"/>
<xsl:when test="$elementValue='IDR'"/>
<xsl:when test="$elementValue='INR'"/>
<xsl:when test="$elementValue='KRW'"/>
<xsl:when test="$elementValue='MYR'"/>
<xsl:when test="$elementValue='NZD'"/>
<xsl:when test="$elementValue='SGD'"/>
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
</xsl:template>
<xsl:template name="isValidTime">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Missing, empty or invalid <xsl:value-of select="$elementName"/>. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='10:00:00'"/>
<xsl:when test="$elementValue='11:00:00'"/>
<xsl:when test="$elementValue='11:30:00'"/>
<xsl:when test="$elementValue='12:00:00'"/>
<xsl:when test="$elementValue='12:30:00'"/>
<xsl:when test="$elementValue='14:10:00'"/>
<xsl:when test="$elementValue='14:15:00'"/>
<xsl:when test="$elementValue='14:30:00'"/>
<xsl:when test="$elementValue='14:45:00'"/>
<xsl:when test="$elementValue='15:15:00'"/>
<xsl:when test="$elementValue='16:00:00'"/>
<xsl:when test="$elementValue='16:30:00'"/>
<xsl:when test="$elementValue='17:00:00'"/>
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
<xsl:template name="isValidVarianceSwapConfirmationType">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> element. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='ISDA2004EquityAmericasInterdealer'"/>
<xsl:when test="$elementValue='ISDA2007VarianceSwapAmericas'"/>
<xsl:when test="$elementValue='ISDA2007VarianceSwapEuropean'"/>
<xsl:when test="$elementValue='2005VarianceSwapEuropeanInterdealer'"/>
<xsl:when test="$elementValue='ISDA2006VarianceSwapJapaneseInterdealer'"/>
<xsl:when test="$elementValue='ISDA2007VarianceSwapAsiaExcludingJapan'"/>
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
<xsl:template name="isValidDispersionVarianceSwapConfirmationType">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> element. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='ISDA2007DispersionVarianceSwapEuropean'"/>
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
<xsl:template name="isValidDividendSwapConfirmationType">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> element. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='2006DividendSwapEuropeanInterdealer'"/>
<xsl:when test="$elementValue='DividendSwapEuropeanPrivate'"/>
<xsl:when test="$elementValue='DividendSwapAmericasPrivate'"/>
<xsl:when test="$elementValue='ISDA2008DividendSwapJapan' "/>
<xsl:when test="$elementValue='ISDA2008DividendSwapJapaneseRev1' "/>
<xsl:when test="$elementValue='DividendSwapAsiaExcludingJapanPrivate' "/>
<xsl:when test="$elementValue='2014DividendSwapAsiaExcludingJapanInterdealer' "/>
<xsl:when test="$elementValue='2013DividendSwapAmericasInterdealer' "/>
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
<xsl:template name="isValidEquitySwapConfirmationType">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> element. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='ISDA2007EquityFinanceSwapEuropean' "/>
<xsl:when test="$elementValue='ISDA2007EquityEuropean' "/>
<xsl:when test="$elementValue='EquitySwapEuropePrivate' "/>
<xsl:when test="$elementValue='EquitySwapAEJPrivate' "/>
<xsl:when test="$elementValue='ISDA2005EquitySwapAsiaExcludingJapanInterdealer' "/>
<xsl:when test="$elementValue='EquitySwapAmericasPrivate' "/>
<xsl:when test="$elementValue='ISDA2009EquitySwapAmericas' "/>
<xsl:when test="$elementValue='ISDA2004EquityAmericasInterdealer' "/>
<xsl:when test="$elementValue='ISDA2008EquityFinanceSwapAsiaExcludingJapan' "/>
<xsl:when test="$elementValue='ISDA2009EquityFinanceSwapAsiaExcludingJapan' "/>
<xsl:when test="$elementValue='ISDA2009EquitySwapPanAsia' "/>
<xsl:when test="$elementValue='ISDA2009EquityEuropeanInterdealer' "/>
<xsl:when test="$elementValue='EmergingEquitySwapIndustry' "/>
<xsl:when test="$elementValue='EmergingEquitySwapLATAM' "/>
<xsl:when test="$elementValue='EmergingEquitySwapEMEA' "/>
<xsl:when test="$elementValue='EquitySwapGlobalPrivate' "/>
<xsl:when test="$elementValue='EquitySwapPanAsiaPrivate' "/>
<xsl:when test="$elementValue='ISDA2010FairValueShareSwapEuropeanInterdealer' "/>
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
<xsl:template match="fpml:swbBusinessConductDetails">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:apply-templates select="fpml:swbMidMarketPrice">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:swbMidMarketPrice">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
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
<xsl:if test=" fpml:swbAmount and (string(number(fpml:swbAmount/text())) ='NaN' or contains(fpml:swbAmount/text(),'e') or 	contains(fpml:swbAmount/text(),'E'))">
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
<xsl:template match="fpml:swbAllocations">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:apply-templates select="fpml:swbAllocation">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:swbAllocation">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]
</xsl:variable>
<xsl:variable name="reportingAllocationData.rtf">
<xsl:apply-templates select="fpml:swbAllocationReportingDetails/node()" mode="mapReportingData"/>
</xsl:variable>
<xsl:if test="($productType='Share Dividend Swap' or $productType='Index Dividend Swap') and fpml:independentAmountPercentage">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** IndependentAmountPercentage must not be present for Dividend Swaps.</text>
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
<xsl:template name="isValidChinaConnectFieldValue">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Element <xsl:value-of select="$elementName"/> value = '<xsl:value-of select="$elementValue"/>' is invalid or not Supported.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='Not Applicable' or $elementValue='Joint' or $elementValue='Hedging Party'"/>
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
<xsl:template match="fpml:knock">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="fpml:knockIn">
<xsl:apply-templates select="fpml:knockIn">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:when>
<xsl:when test="fpml:knockOut">
<xsl:apply-templates select="fpml:knockOut">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:when>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** knock/knockIn or knock/knockOut is expected in case of Barrier Option.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template match="fpml:knockIn">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:apply-templates select="fpml:schedule">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:trigger">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="(fpml:featurePayment)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected featurePayment element encountered in this context.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:knockOut">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:apply-templates select="fpml:schedule">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:trigger">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="(fpml:featurePayment)">
<xsl:apply-templates select="fpml:featurePayment">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:schedule">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="not(fpml:startDate and fpml:endDate)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Start Date and End Date are mandatory in case of Barrier Option.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:averagingPeriodFrequency/@id = 'observationDate')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Expected "observationDate" as averagingPeriodFrequency/@id. Value = '<xsl:value-of select="fpml:averagingPeriodFrequency/@id"/>'.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:trigger">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="not(fpml:level)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** trigger/level is mandatory in case of Barrier Option.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:triggerType)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** trigger/triggerType is  mandatory in case of Barrier Option.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:triggerTimeType)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** trigger/triggerTimeType is mandatory in case of Barrier Option.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:featurePayment">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="not(fpml:amount)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Expected amount under featurePayment.</text>
</error>
</xsl:if>
<xsl:if test="fpml:featurePaymentDate/fpml:relativeDate/fpml:period != 'D'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** period must be equal to 'D' in this context. Value = '<xsl:value-of select="fpml:featurePaymentDate/fpml:relativeDate/fpml:period"/>'</text>
</error>
</xsl:if>
<xsl:if test="fpml:featurePaymentDate/fpml:relativeDate/fpml:dayType != 'CurrencyBusiness'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** dayType must be equal to 'CurrencyBusiness' in this context. Value = '<xsl:value-of select="fpml:featurePaymentDate/fpml:relativeDate/fpml:dayType"/>'</text>
</error>
</xsl:if>
<xsl:if test="fpml:featurePaymentDate/fpml:relativeDate/fpml:businessDayConvention != 'NotApplicable'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** businessDayConvention must be equal to 'NotApplicable' in this context. Value = '<xsl:value-of select="fpml:featurePaymentDate/fpml:relativeDate/fpml:businessDayConvention"/>'</text>
</error>
</xsl:if>
<xsl:variable name="href1">
<xsl:value-of select="fpml:featurePaymentDate/fpml:relativeDate/fpml:dateRelativeTo/@href"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$href1 = 'observationDate'"/>
<xsl:when test="$href1 = 'expirationDate'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Expected dateRelativeTo/@id to be observationDate or expirationDate in this context. Value = '<xsl:value-of select="$href1"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
<xsl:if test="$href1 = 'expirationDate'">
<xsl:choose>
<xsl:when test="//fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:equityExercise/fpml:equityEuropeanExercise/fpml:expirationDate/@id = 'expirationDate'"/>
<xsl:when test="//fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:equityExercise/fpml:equityAmericanExercise/fpml:expirationDate/@id = 'expirationDate'"/>
<xsl:when test="//fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:equityExercise/fpml:equityBermudaExercise/fpml:expirationDate/@id = 'expirationDate'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Expected equityExercise/../expirationDate/@id to be expirationDate in this context.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:template>
<xsl:template name="isValidLocalJurisdiction">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> element. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='Not Applicable'"/>
<xsl:when test="$elementValue='India'"/>
<xsl:when test="$elementValue='Indonesia'"/>
<xsl:when test="$elementValue='Korea'"/>
<xsl:when test="$elementValue='Malaysia'"/>
<xsl:when test="$elementValue='Taiwan'"/>
<xsl:when test="$elementValue='Vietnam'"/>
<xsl:when test="$elementValue='Pakistan'"/>
<xsl:when test="$elementValue='Philippines'"/>
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
<xsl:template match="fpml:swVolatilityLeg">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="$productType='Equity Share Volatility Swap' or $productType='Equity Index Volatility Swap'">
<xsl:variable name="payer">
<xsl:value-of select="fpml:payerPartyReference/@href"/>
</xsl:variable>
<xsl:if test="not(/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:party[@id=$payer])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The payerPartyReference/@href value does not match an //FpML/party/@id value for any party. Value = '<xsl:value-of select="$payer"/>'.</text>
</error>
</xsl:if>
<xsl:variable name="receiver">
<xsl:value-of select="fpml:receiverPartyReference/@href"/>
</xsl:variable>
<xsl:if test="not(/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:party[@id=$receiver])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The receiverPartyReference/@href value does not match an //FpML/party/@id value for any party. Value = '<xsl:value-of select="$receiver"/>'.</text>
</error>
</xsl:if>
<xsl:if test="$payer=$receiver">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** payerPartyReference/@href and receiverPartyReference/@href values are the same.</text>
</error>
</xsl:if>
<xsl:if test="fpml:paymentFrequency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected paymentFrequency element encountered in this context.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:underlyer">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:valuation">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:swAmount">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="not(fpml:settlementType[.='Cash'])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>
*** Invalid settlementType element encountered in this context when product type is 'Equity Index Volatility Swap' or 'Equity Share Volatility Swap'. Value = '<xsl:value-of select="fpml:settlementType"/>'. Must be cash settled.
</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:settlementCurrency)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Settlement Currency element is expected in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:settlementCurrency">
<xsl:call-template name="isValidCurrency">
<xsl:with-param name="elementName">fpml:settlementCurrency</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:settlementCurrency"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:fxFeature and $docsType != 'VolatilitySwapAsiaExcludingJapanPrivate'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** ABC <xsl:value-of select = "$docsType"/>Unexpected fxFeature element in this context. Element must not be present when Docs Type is not 'Volatility Swap (AEJ)'.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:fxFeature">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:settlementDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:swAmount">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="fpml:allDividends and ($productType = 'Equity Index Volatility Swap' or ($docsType='VolatilitySwapJapanesePrivate' or $docsType='VolatilitySwapAmericasPrivate'))">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected allDividends element encountered in this context when productType is 'Equity Index Volatility Swap' or Docs Type is 'Volatility Swap (Japan)' or Docs Type is 'Volatility Swap (Americas)'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:calculationDates">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** calculationDates element should not be present in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:optionsExchangeDividends">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** optionsExchangeDividends element should not be present in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:additionalDividends">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** additionalDividends element should not be present in this context.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:swVolatility">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="not(fpml:observationStartDate)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing observationStartDate element in this context.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:observationStartDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:swVolatility">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="fpml:swInitialLevel">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swInitialLevel</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swInitialLevel"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.01</xsl:with-param>
<xsl:with-param name="maxIncl">999999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swInitialLevelSource != 'ExpiringContractLevel' and fpml:swInitialLevelSource != 'ClosingPrice' and fpml:swInitialLevelSource != 'OSPPricing' and fpml:swInitialLevelSource != 'IndexClosePricing'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>
*** Invalid swInitialLevelSource value encountered in this context. Value = '<xsl:value-of select="fpml:swInitialLevelSource"/>'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swInitialLevelSource = 'ExpiringContractLevel' and $productType = 'Equity Share Volatility Swap'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>
*** Unexpected swInitialLevelSource value encountered in this context when Product Type is 'Equity Share Volatility Swap.  Value = '<xsl:value-of select="fpml:swInitialLevelSource"/>'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swInitialLevelSource = 'OSPPricing' and $docsType != 'IVS1OpenMarkets' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>
*** Unexpected swInitialLevelSource value encountered in this context when matrixTerm = 'IVS1OpenMarkets'.  Value = '<xsl:value-of select="fpml:swInitialLevelSource"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:swVolatilityStrikePrice)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swVolatilityStrikePrice element in this context.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:swExpectedN)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swExpectedN element in this context. Element must be present for all Variance Swap products.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swVolatilityCap">
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">swVolatilityCap</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swVolatilityCap"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swTotalVolatilityCap and not (fpml:swVolatilityCap='true')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swTotalVolatilityCap element encountered in this context. Element must be not present unless swVolatilityCap is equal to 'true'.</text>
</error>
</xsl:if>
<xsl:if test="swVolatilityCap='true'">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swTotalVolatilityCap</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swTotalVolatilityCap"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.0000</xsl:with-param>
<xsl:with-param name="maxIncl">998001.0000</xsl:with-param>
<xsl:with-param name="maxDecs">4</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:choose>
<xsl:when test="$docsType='VolatilitySwapEuropeanPrivate'">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swVolatilityStrikePrice</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swVolatilityStrikePrice"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.01</xsl:with-param>
<xsl:with-param name="maxIncl">300.00</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:when>
<xsl:when test="$docsType='VolatilitySwapAsiaExcludingJapanPrivate' or $docsType='VolatilitySwapJapanesePrivate' or $docsType='VolatilitySwapAmericasPrivate'">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swVolatilityStrikePrice</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swVolatilityStrikePrice"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.001</xsl:with-param>
<xsl:with-param name="maxIncl">300.000</xsl:with-param>
<xsl:with-param name="maxDecs">3</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:when>
</xsl:choose>
<xsl:if test="not(fpml:swVegaNotionalAmount)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swVegaNotionalAmount element in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swVegaNotionalAmount">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swVegaNotionalAmount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swVegaNotionalAmount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.01</xsl:with-param>
<xsl:with-param name="maxIncl">999999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:masterAgreement">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="$productType = 'Equity Index Volatility Swap'">
<xsl:call-template name="isValidVolatilitySwapMasterAgreementType">
<xsl:with-param name="elementName">masterAgreementType</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:masterAgreementType"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
</xsl:template>
<xsl:template name="isValidVolatilitySwapMasterAgreementType">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> element. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='ISDA'"/>
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
<xsl:template match="fpml:contractualMatrix">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="$productType = 'Equity Index Volatility Swap'">
<xsl:call-template name="isValidVolatilitySwapContractualMatrix">
<xsl:with-param name="elementName">matrixType</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:matrixType"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="isValidVolatilitySwapContractualMatrix1">
<xsl:with-param name="elementName">matrixTerm</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:matrixTerm"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
</xsl:template>
<xsl:template name="isValidVolatilitySwapContractualMatrix">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> element. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='EquityDerivativesMatrix'"/>
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
<xsl:template name="isValidVolatilitySwapContractualMatrix1">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> element. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='IVS1OpenMarkets'"/>
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
</xsl:stylesheet>
