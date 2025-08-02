<?xml version="1.0"?>
<xsl:stylesheet
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:fpml="http://www.fpml.org/FpML-5/confirmation"
xmlns:swml="http://www.markitserv.com/swml-5-11"
exclude-result-prefixes="swml"
version="1.0">
<xsl:output method="xml"/>
<xsl:variable name="SWDML" select="swml:SWDML"/>
<xsl:variable name="swLongFormTrade" select="$SWDML/swml:swLongFormTrade"/>
<xsl:variable name="swStructuredTradeDetails" select="$swLongFormTrade/swml:swStructuredTradeDetails"/>
<xsl:variable name="dataDocument" select="$swStructuredTradeDetails/fpml:dataDocument"/>
<xsl:variable name="trade" select="$dataDocument/fpml:trade"/>
<xsl:variable name="repo" select="$trade/fpml:repo"/>
<xsl:variable name="version" select="$SWDML/@version"/>
<xsl:variable name="product" select="$swStructuredTradeDetails/swml:swProductType"/>
<xsl:template match="/">
<xsl:apply-templates select="$SWDML"/>
</xsl:template>
<xsl:template match="swml:SWDML">
<xsl:variable name="newContext">
In <xsl:value-of select="local-name()"/>
</xsl:variable>
<results version="1.0">
<xsl:if test="not($version='5-11')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid version attribute. Value = '<xsl:value-of select="$version"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not($swLongFormTrade)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swLongFormTrade element. Required in this context.</text>
</error>
</xsl:if>
<xsl:apply-templates select="swml:swLongFormTrade">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</results>
</xsl:template>
<xsl:template match="swml:swLongFormTrade">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="not(swml:swOriginatorPartyReference)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swOriginatorPartyReference.</text>
</error>
</xsl:if>
<xsl:variable name="href">
<xsl:value-of select="swml:swOriginatorPartyReference/@href"/>
</xsl:variable>
<xsl:if test="not($dataDocument/fpml:party[@id=$href])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swOriginatorPartyReference/@href does not reference a valid party/@id. Value = '<xsl:value-of select="$href"/>'.</text>
</error>
</xsl:if>
<xsl:apply-templates select="swml:swAllocations">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="swml:swStructuredTradeDetails">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="swml:swAllocations">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:apply-templates select="swml:swAllocation">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="swml:swAllocation">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="swml:swNearLeg/swml:collateral//fpml:nominalAmount//fpml:amount">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">Alloc Open Security Nominal</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="swml:swNearLeg/swml:collateral//fpml:nominalAmount//fpml:amount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.00</xsl:with-param>
<xsl:with-param name="maxIncl">9999999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>/swNearLeg/collateral/nominalAmount/amount
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="swml:swNearLeg/swml:collateral//fpml:quantity">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">Alloc Open Security Quantity</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="swml:swNearLeg/swml:collateral//fpml:quantity"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">9999999999999</xsl:with-param>
<xsl:with-param name="maxDecs">0</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>/swNearLeg/collateral/quantity
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:variable name="buyerPartyReference">
<xsl:value-of select="swml:swNearLeg//fpml:buyerPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="sellerPartyReference">
<xsl:value-of select="swml:swNearLeg//fpml:sellerPartyReference/@href"/>
</xsl:variable>
<xsl:if test="not($dataDocument/fpml:party[@id=$buyerPartyReference])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** fpml:buyerPartyReference/@href does not reference a valid party/@id. Value = '<xsl:value-of select="$buyerPartyReference"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not($dataDocument/fpml:party[@id=$sellerPartyReference])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** fpml:sellerPartyReference/@href does not reference a valid party/@id. Value = '<xsl:value-of select="$sellerPartyReference"/>'.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="swml:swStructuredTradeDetails">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:apply-templates select="fpml:dataDocument">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="swml:swExtendedTradeDetails">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:dataDocument">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:apply-templates select="fpml:trade">
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
<xsl:apply-templates select="fpml:repo">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:repo">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="fpml:initialMargin/fpml:margin/fpml:haircut">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">Haircut</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:initialMargin/fpml:margin/fpml:haircut"/>
</xsl:with-param>
<xsl:with-param name="minIncl">-99999.99999999</xsl:with-param>
<xsl:with-param name="maxIncl">99999.99999999</xsl:with-param>
<xsl:with-param name="maxDecs">10</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>/initialMargin/margin/haircut
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:initialMargin/fpml:margin/fpml:marginRatio">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">Initial Margin</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:initialMargin/fpml:margin/fpml:marginRatio"/>
</xsl:with-param>
<xsl:with-param name="minIncl">-99999.99999999</xsl:with-param>
<xsl:with-param name="maxIncl">99999.99999999</xsl:with-param>
<xsl:with-param name="maxDecs">10</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>/initialMargin/margin/marginRatio
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:nearLeg/fpml:settlementAmount/fpml:amount">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">Open Cash Amount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:nearLeg/fpml:settlementAmount/fpml:amount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.000</xsl:with-param>
<xsl:with-param name="maxIncl">999999999999.999</xsl:with-param>
<xsl:with-param name="maxDecs">3</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>/nearLeg/settlementAmount/amount
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:farLeg/fpml:settlementAmount/fpml:amount">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">Close Cash Amount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:farLeg/fpml:settlementAmount/fpml:amount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.000</xsl:with-param>
<xsl:with-param name="maxIncl">999999999999.999</xsl:with-param>
<xsl:with-param name="maxDecs">3</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>/farLeg/settlementAmount/amount
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:fixedRateSchedule/fpml:initialValue">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">Open Repo Rate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:fixedRateSchedule/fpml:initialValue"/>
</xsl:with-param>
<xsl:with-param name="minIncl">-99999.99999999</xsl:with-param>
<xsl:with-param name="maxIncl">99999.99999999</xsl:with-param>
<xsl:with-param name="maxDecs">10</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>/fixedRateSchedule/initialValue
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:floatingRateCalculation/fpml:spreadSchedule/fpml:initialValue">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">Open Repo Spread</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:floatingRateCalculation/fpml:spreadSchedule/fpml:initialValue"/>
</xsl:with-param>
<xsl:with-param name="minIncl">-99999.999999</xsl:with-param>
<xsl:with-param name="maxIncl">99999.999999</xsl:with-param>
<xsl:with-param name="maxDecs">10</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>/floatingRateCalculation/spreadSchedule/initialValue
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:nearLeg/fpml:collateral/fpml:nominalAmount/fpml:amount">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">Open Security Nominal</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:nearLeg/fpml:collateral/fpml:nominalAmount/fpml:amount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.00</xsl:with-param>
<xsl:with-param name="maxIncl">9999999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>/nearLeg/collateral/nominalAmount/amount
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:farLeg/fpml:collateral/fpml:nominalAmount/fpml:amount">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">Close Security Nominal</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:farLeg/fpml:collateral/fpml:nominalAmount/fpml:amount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.00</xsl:with-param>
<xsl:with-param name="maxIncl">9999999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>/farLeg/collateral/nominalAmount/amount
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:nearLeg/fpml:collateral/fpml:quantity">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">Open Security Quantity</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:nearLeg/fpml:collateral/fpml:quantity"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">9999999999999</xsl:with-param>
<xsl:with-param name="maxDecs">0</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>/nearLeg/collateral/quantity
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:farLeg/fpml:collateral/fpml:quantity">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">Close Security Quantity</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:farLeg/fpml:collateral/fpml:quantity"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">9999999999999</xsl:with-param>
<xsl:with-param name="maxDecs">0</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>/farLeg/collateral/quantity
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:duration='Term' and not(fpml:farLeg)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***The Repurchase leg (//repo/farLeg) must be provided for Termination or when the Duration Type is not "Open".</text>
</error>
</xsl:if>
<xsl:if test="fpml:nearLeg/fpml:collateral/fpml:nominalAmount/fpml:amount and fpml:farLeg/fpml:collateral/fpml:nominalAmount/fpml:amount">
<xsl:variable name="openNominal">
<xsl:value-of select="fpml:nearLeg/fpml:collateral/fpml:nominalAmount/fpml:amount"/>
</xsl:variable>
<xsl:variable name="closeNominal">
<xsl:value-of select="fpml:farLeg/fpml:collateral/fpml:nominalAmount/fpml:amount"/>
</xsl:variable>
<xsl:if test="$openNominal != $closeNominal">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***The Close Security Nominal and the Open Security Nominal must have the same value.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:nearLeg/fpml:collateral/fpml:quantity and fpml:farLeg/fpml:collateral/fpml:quantity">
<xsl:variable name="openQty">
<xsl:value-of select="fpml:nearLeg/fpml:collateral/fpml:quantity"/>
</xsl:variable>
<xsl:variable name="closeQty">
<xsl:value-of select="fpml:farLeg/fpml:collateral/fpml:quantity"/>
</xsl:variable>
<xsl:if test="$openQty != $closeQty">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***The Close Security Quantity and the Open Security Quantity must have the same value.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:nearLeg/fpml:buyerPartyReference and fpml:farLeg/fpml:sellerPartyReference">
<xsl:variable name="href1">
<xsl:value-of select="fpml:nearLeg/fpml:buyerPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="href2">
<xsl:value-of select="fpml:farLeg/fpml:sellerPartyReference/@href"/>
</xsl:variable>
<xsl:if test="$href1 != $href2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***The seller party on the Repurchase leg must be the same as the buyer party on the Purchase leg.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:nearLeg/fpml:sellerPartyReference and fpml:farLeg/fpml:buyerPartyReference">
<xsl:variable name="href1">
<xsl:value-of select="fpml:nearLeg/fpml:sellerPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="href2">
<xsl:value-of select="fpml:farLeg/fpml:buyerPartyReference/@href"/>
</xsl:variable>
<xsl:if test="$href1 != $href2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***The buyer party on the Repurchase leg must be the same as the seller party on the Purchase leg.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:nearLeg/fpml:settlementAmount/fpml:currency and fpml:farLeg/fpml:settlementAmount/fpml:currency">
<xsl:variable name="nearCurrency">
<xsl:value-of select="fpml:nearLeg/fpml:settlementAmount/fpml:currency"/>
</xsl:variable>
<xsl:variable name="farCurrency">
<xsl:value-of select="fpml:farLeg/fpml:settlementAmount/fpml:currency"/>
</xsl:variable>
<xsl:if test="$nearCurrency != $farCurrency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***The currency of the Open Cash Amount must match the currency of the Close Cash Amount.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:bond/fpml:currency and fpml:nearLeg/fpml:collateral/fpml:nominalAmount/fpml:currency">
<xsl:variable name="nearCollCurrency">
<xsl:value-of select="fpml:nearLeg/fpml:collateral/fpml:nominalAmount/fpml:currency"/>
</xsl:variable>
<xsl:variable name="bondCurrency">
<xsl:value-of select="fpml:bond/fpml:currency"/>
</xsl:variable>
<xsl:if test="$nearCollCurrency != $bondCurrency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***The currency of the Open Security Nominal must match the Security Currency.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:bond/fpml:currency and fpml:farLeg/fpml:collateral/fpml:nominalAmount/fpml:currency">
<xsl:variable name="farCollCurrency">
<xsl:value-of select="fpml:farLeg/fpml:collateral/fpml:nominalAmount/fpml:currency"/>
</xsl:variable>
<xsl:variable name="bondCurrency">
<xsl:value-of select="fpml:bond/fpml:currency"/>
</xsl:variable>
<xsl:if test="$farCollCurrency != $bondCurrency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***The currency of the Close Security Nominal must be the Security Currency.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:noticePeriod/fpml:period">
<xsl:variable name="periodType">
<xsl:value-of select="fpml:noticePeriod/fpml:period"/>
</xsl:variable>
<xsl:if test="$periodType != 'D'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***The Call Notice Period must be provided as Days.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:template>
<xsl:template match="swml:swExtendedTradeDetails">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="swml:swAmendmentType and swml:swAmendmentType='Termination' and not($repo/fpml:farLeg)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***The Repurchase leg (//repo/farLeg) must be provided for Termination or when the Duration Type is not "Open".</text>
</error>
</xsl:if>
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
</xsl:stylesheet>
