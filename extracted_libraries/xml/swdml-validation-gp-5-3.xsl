<?xml version="1.0" ?>
<xsl:stylesheet
xmlns:swml="http://www.markitserv.com/swml"
xmlns:fpml="http://www.fpml.org/FpML-5/confirmation"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
exclude-result-prefixes="swml fpml"
version="1.0">
<xsl:output method="xml"/>
<xsl:variable name="SWDML" select="swml:SWDML"/>
<xsl:variable name="swLongFormTrade" select="$SWDML/swml:swLongFormTrade"/>
<xsl:variable name="swStructuredTradeDetails" select="$swLongFormTrade/swml:swStructuredTradeDetails"/>
<xsl:variable name="dataDocument" select="$swStructuredTradeDetails/fpml:dataDocument"/>
<xsl:variable name="trade" select="$dataDocument/fpml:trade"/>
<xsl:variable name="genericProduct" select="$trade/swml:swGenericProduct"/>
<xsl:variable name="optionstrike" select="$genericProduct/swml:swOptionStrike"/>
<xsl:variable name="paymentfrequency" select="$genericProduct/swml:swPaymentFrequency"/>
<xsl:variable name="resetfrequency" select="$genericProduct/swml:swResetFrequency"/>
<xsl:variable name="primaryAssetClass" select="normalize-space($genericProduct/fpml:primaryAssetClass)"/>
<xsl:variable name="fixeddcf">
<xsl:value-of select="$genericProduct/swml:swDayCountFraction/swml:dayCountFraction[@dayCountFractionScheme='http://www.markitserv.com/day-count-fraction']"/>
</xsl:variable>
<xsl:variable name="product" select="$swStructuredTradeDetails/swml:swProductType"/>
<xsl:template match="/">
<xsl:apply-templates select="swml:SWDML"/>
</xsl:template>
<xsl:template match="swml:SWDML">
<xsl:variable name="newContext">
In <xsl:value-of select="local-name()"/>
</xsl:variable>
<results version="1.0">
<xsl:apply-templates select="swml:swLongFormTrade">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="swml:swTradeEventReportingDetails">
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
<xsl:apply-templates select="swml:novation">
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
<xsl:template match="swml:novation">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:apply-templates select="swml:swBusinessConductDetails">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
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
<xsl:apply-templates select="swml:swBusinessConductDetails">
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
<xsl:apply-templates select="swml:swGenericProduct">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="swml:swGenericProduct">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="$primaryAssetClass = 'Credit' and $fixeddcf ='' ">
<xsl:variable name="error">
[ ERR-VALID-GP-00502 ] For [<xsl:value-of select="$primaryAssetClass"/>] primary asset class, fixed rate day count fraction field is mandatory for [<xsl:value-of select="$product"/>].
</xsl:variable>
<xsl:call-template name="buildErrorData">
<xsl:with-param name="context" select="$newContext"/>
<xsl:with-param name="error" select="$error"/>
</xsl:call-template>
</xsl:if>
<xsl:if test="$optionstrike/swml:swStrikeUnits/text() != 'Price' and string-length($optionstrike/swml:swStrikeCurrency) != 0">
<xsl:variable name="error">
[ERR-VALID-GP-00510] Option Strike Currency not allowed for unit.
</xsl:variable>
<xsl:call-template name="buildErrorData">
<xsl:with-param name="context" select="$newContext"/>
<xsl:with-param name="error" select="$error"/>
</xsl:call-template>
</xsl:if>
<xsl:if test="$optionstrike/swml:swStrikeUnits/text() = 'Price' and string-length($optionstrike/swml:swStrikeCurrency) = 0">
<xsl:variable name="error">
[ERR-VALID-GP-00511] Option Strike Currency cannot be blank
</xsl:variable>
<xsl:call-template name="buildErrorData">
<xsl:with-param name="context" select="$newContext"/>
<xsl:with-param name="error" select="$error"/>
</xsl:call-template>
</xsl:if>
<xsl:for-each select="$swStructuredTradeDetails/fpml:dataDocument/fpml:trade/swml:swGenericProduct/swml:swDayCountFraction">
<xsl:if test="string-length(./swml:underlyerReference/@href) = 0">
<xsl:variable name="error">
[ERR-VALID-GP-00516] Underlyer Reference must be specified for the Day Count Convention  [<xsl:value-of select="position()"/>]
</xsl:variable>
<xsl:call-template name="buildErrorData">
<xsl:with-param name="context" select="$context"/>
<xsl:with-param name="error" select="$error"/>
</xsl:call-template>
</xsl:if>
</xsl:for-each>
<xsl:for-each select="$paymentfrequency">
<xsl:if test="string-length(./swml:underlyerReference/@href) = 0">
<xsl:variable name="error">
[ERR-VALID-GP-00512] Underlyer Reference must be specified for the Payment Frequency  [<xsl:value-of select="position()"/>]
</xsl:variable>
<xsl:call-template name="buildErrorData">
<xsl:with-param name="context" select="$context"/>
<xsl:with-param name="error" select="$error"/>
</xsl:call-template>
</xsl:if>
</xsl:for-each>
<xsl:for-each select="$resetfrequency">
<xsl:if test="string-length(./swml:underlyerReference/@href) = 0">
<xsl:variable name="error">
[ERR-VALID-GP-00513] Underlyer Reference must be specified for the Reset Frequency  [<xsl:value-of select="position()"/>]
</xsl:variable>
<xsl:call-template name="buildErrorData">
<xsl:with-param name="context" select="$context"/>
<xsl:with-param name="error" select="$error"/>
</xsl:call-template>
</xsl:if>
</xsl:for-each>
<xsl:variable name="paymentfrequencyperiod" select="$paymentfrequency/fpml:period"/>
<xsl:for-each select="$paymentfrequency/fpml:periodMultiplier">
<xsl:variable name="currentposition" select="position()" />
<xsl:variable name="currentperiod" select="$paymentfrequencyperiod[$currentposition]" />
<xsl:call-template name="isValidAmount">
<xsl:with-param name="elementName">periodMultiplier</xsl:with-param>
<xsl:with-param name="elementValue" select="."/>
<xsl:with-param name="minIncl">1</xsl:with-param>
<xsl:with-param name="maxIncl">999</xsl:with-param>
<xsl:with-param name="maxDecs">0</xsl:with-param>
<xsl:with-param name="context" select="$newContext"/>
</xsl:call-template>
<xsl:call-template name="isValidPeriod">
<xsl:with-param name="elementName">periodMultiplier</xsl:with-param>
<xsl:with-param name="elementValue" select="."/>
<xsl:with-param name="period" select="$currentperiod" />
<xsl:with-param name="context" select="$newContext"/>
</xsl:call-template>
</xsl:for-each>
<xsl:variable name="resetfrequencyperiod" select="$resetfrequency/fpml:period"/>
<xsl:for-each select="$resetfrequency/fpml:periodMultiplier">
<xsl:variable name="currentposition" select="position()" />
<xsl:variable name="currentperiod" select="$resetfrequencyperiod[$currentposition]" />
<xsl:call-template name="isValidAmount">
<xsl:with-param name="elementName">periodMultiplier</xsl:with-param>
<xsl:with-param name="elementValue" select="."/>
<xsl:with-param name="minIncl">1</xsl:with-param>
<xsl:with-param name="maxIncl">999</xsl:with-param>
<xsl:with-param name="maxDecs">0</xsl:with-param>
<xsl:with-param name="context" select="$newContext"/>
</xsl:call-template>
<xsl:call-template name="isValidPeriod">
<xsl:with-param name="elementName">periodMultiplier</xsl:with-param>
<xsl:with-param name="elementValue" select="."/>
<xsl:with-param name="period" select="$currentperiod" />
<xsl:with-param name="context" select="$newContext"/>
</xsl:call-template>
</xsl:for-each>
</xsl:template>
<xsl:template name="isValidPeriod">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="period"/>
<xsl:param name="context"/>
<xsl:if test="$period/text() = 'T' and $elementValue != '1' ">
<xsl:variable name="error">
[ERR-VALID-GP-00512] Period Multiplier must be 1 for Period 'Term' (T). Period Multiplier = [<xsl:value-of select="$elementValue"/>]
</xsl:variable>
<xsl:call-template name="buildErrorData">
<xsl:with-param name="context" select="$context"/>
<xsl:with-param name="error" select="$error"/>
</xsl:call-template>
</xsl:if>
</xsl:template>
<xsl:template match="swml:swTradeEventReportingDetails">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:variable name="mandatoryClearingIndicator">
<xsl:value-of select="swml:swReportingRegimeInformation/swml:swMandatoryClearingIndicator"/>
</xsl:variable>
<xsl:if test="$mandatoryClearingIndicator = 'true' ">
<xsl:variable name="error">
[ ERR-VALID-GP-00501 ] Mandatory Clearing Indicator value [<xsl:value-of select="$mandatoryClearingIndicator"/>] is invalid for [<xsl:value-of select="$product"/>].
</xsl:variable>
<xsl:call-template name="buildErrorData">
<xsl:with-param name="context" select="$newContext"/>
<xsl:with-param name="error" select="$error"/>
</xsl:call-template>
</xsl:if>
<xsl:variable name="buyerPartyRef">
<xsl:value-of select="swml:swBuyerPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="sellerPartyRef">
<xsl:value-of select="swml:swSellerPartyReference/@href"/>
</xsl:variable>
<xsl:if test="$buyerPartyRef=$sellerPartyRef and swml:swBuyerPartyReference and swml:swSellerPartyReference">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***buyerPartyReference/@href and sellerPartyReference/@href values must not be the same.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template name="buildErrorData">
<xsl:param name="context"/>
<xsl:param name="error"/>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>
<xsl:value-of select="$error"/>
</text>
</error>
</xsl:template>
<xsl:template match="swml:swExtendedTradeDetails">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:apply-templates select="node()/swml:swMandatoryClearing">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="swml:swMandatoryClearing">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="current()[swml:swJurisdiction/text()!='DoddFrank'][swml:swSupervisoryBodyCategory]">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** swSupervisoryBodyCategory not supported for '<xsl:value-of select="swml:swJurisdiction"/>' clearing</text>
</error>
</xsl:if>
<xsl:if test="current()[swml:swJurisdiction/text()='MAS' or swml:swJurisdiction/text()='JFSA' or swml:swJurisdiction/text()='ASIC'][swml:swPartyExemption]">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** swPartyExemption cannot be provided for '<xsl:value-of select="swml:swJurisdiction"/>'</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="swml:swBusinessConductDetails">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:apply-templates select="swml:swMidMarketPrice">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="swml:swMidMarketPrice">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="swml:swUnit">
<xsl:choose>
<xsl:when test="swml:swUnit/text()='Price'"/>
<xsl:when test="swml:swUnit/text()='BasisPoints'"/>
<xsl:when test="swml:swUnit/text()='Percentage'"/>
<xsl:when test="swml:swUnit/text()='Level'"/>
<xsl:otherwise>
<xsl:variable name="error">
[ ERR-VALID-GP-00503 ] Invalid value submitted for [<xsl:value-of select="local-name()"/>/swml:swUnit]. Value = '<xsl:value-of select="					swml:swUnit/text()"/>'.
</xsl:variable>
<xsl:call-template name="buildErrorData">
<xsl:with-param name="context" select="$newContext"/>
<xsl:with-param name="error" select="$error"/>
</xsl:call-template>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test=" swml:swAmount and (string(number(swml:swAmount/text())) ='NaN' or contains(swml:swAmount/text(),'e') or contains(fpml:swAmount/text(),'E'))">
<xsl:variable name="error">
[ ERR-VALID-GP-00504 ] Invalid value submitted for [<xsl:value-of select="local-name()"/>/swml:swAmount]. Value = '<xsl:value-of select="swml:swAmount./text()"/>'.
</xsl:variable>
<xsl:call-template name="buildErrorData">
<xsl:with-param name="context" select="$newContext"/>
<xsl:with-param name="error" select="$error"/>
</xsl:call-template>
</xsl:if>
<xsl:call-template name="isValidAmount">
<xsl:with-param name="elementName">swAmount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="swml:swAmount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">-9999999999.99999999</xsl:with-param>
<xsl:with-param name="maxIncl">9999999999.99999999</xsl:with-param>
<xsl:with-param name="maxDecs">8</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="not(string-length(swml:swUnit) &gt; 0) and (swml:swCurrency or swml:swAmount)">
<xsl:variable name="error">
[ ERR-VALID-GP-00505 ] Mid-Market Price Type is required.
</xsl:variable>
<xsl:call-template name="buildErrorData">
<xsl:with-param name="context" select="$newContext"/>
<xsl:with-param name="error" select="$error"/>
</xsl:call-template>
</xsl:if>
<xsl:if test="string-length(swml:swUnit) &gt; 0 and not (swml:swCurrency) and not (swml:swAmount)">
<xsl:variable name="error">
[ ERR-VALID-GP-00506 ] Mid-Market Price Value is required.
</xsl:variable>
<xsl:call-template name="buildErrorData">
<xsl:with-param name="context" select="$newContext"/>
<xsl:with-param name="error" select="$error"/>
</xsl:call-template>
</xsl:if>
<xsl:if test="swml:swUnit/text() = 'Price' and  swml:swCurrency and not(swml:swAmount)">
<xsl:variable name="error">
[ ERR-VALID-GP-00507 ] Mid-Market Price Value is required.
</xsl:variable>
<xsl:call-template name="buildErrorData">
<xsl:with-param name="context" select="$newContext"/>
<xsl:with-param name="error" select="$error"/>
</xsl:call-template>
</xsl:if>
<xsl:if test="not(swml:swUnit/text() = 'Price') and string-length(swml:swUnit) &gt; 0 and string-length(swml:swCurrency) &gt; 0">
<xsl:variable name="error">
[ ERR-VALID-GP-00508 ] Mid-Market Price Currency not allowed for type.
</xsl:variable>
<xsl:call-template name="buildErrorData">
<xsl:with-param name="context" select="$newContext"/>
<xsl:with-param name="error" select="$error"/>
</xsl:call-template>
</xsl:if>
<xsl:if test=" swml:swUnit/text()= 'Price' and swml:swAmount and not(string-length(swml:swCurrency) &gt; 0)">
<xsl:variable name="error">
[ ERR-VALID-GP-00509 ] Mid-Market Price currency cannot be blank.
</xsl:variable>
<xsl:call-template name="buildErrorData">
<xsl:with-param name="context" select="$newContext"/>
<xsl:with-param name="error" select="$error"/>
</xsl:call-template>
</xsl:if>
</xsl:template>
<xsl:template name="isValidAmount">
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
<text>
*** <xsl:value-of select="$elementName"/> is outside allowable range; minIncl=<xsl:value-of select="$minIncl"/>, maxIncl=<xsl:value-of select="$maxIncl"/>. Value = '<xsl:value-of select="$elementValue"/>'.
</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="string-length(substring-after($elementValue,'.')) &gt; $maxDecs">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>
*** <xsl:value-of select="$elementName"/> has too many decimal places; maxDecs=<xsl:value-of select="$maxDecs"/>. Value = '<xsl:value-of select="$elementValue"/>'.
</text>
</error>
</xsl:if>
</xsl:template>
</xsl:stylesheet>
