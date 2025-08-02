<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns:fpml40="http://www.fpml.org/2003/FpML-4-0"
xmlns:fpml41="http://www.fpml.org/2004/FpML-4-1"
xmlns:fpml42="http://www.fpml.org/2005/FpML-4-2"
xmlns:fpml44="http://www.fpml.org/2007/FpML-4-4"
xmlns:fpml45="http://www.fpml.org/2008/FpML-4-5"
xmlns:fpml46="http://www.fpml.org/2009/FpML-4-6"
xmlns:fpml47="http://www.fpml.org/2009/FpML-4-7"
xmlns:fpml49="http://www.fpml.org/2010/FpML-4-9"
xmlns:fpml53="http://www.markitserv.com/swml"
xmlns:fpml511="http://www.markitserv.com/swml-5-11"
exclude-result-prefixes="fpml40 fpml41 fpml42 fpml44 fpml45 fpml46 fpml47 fpml49 fpml53 fpml511"
version="1.0">
<xsl:output method="text"/>
<xsl:template match="SWDML|fpml42:SWDML|fpml44:SWDML|fpml45:SWDML|fpml46:SWDML|fpml47:SWDML|fpml49:SWDML|fpml53:SWDML|fpml511:SWDML">
<xsl:call-template name="getSwdmlDetails"/>
</xsl:template>
<xsl:template name="getSwdmlDetails">
<xsl:variable name="productType">
<xsl:choose>
<xsl:when test="swShortFormTrade|fpml42:swShortFormTrade|fpml44:swShortFormTrade|fpml46:swShortFormTrade|fpml47:swShortFormTrade|fpml49:swShortFormTrade">
<xsl:choose>
<xsl:when
test="/SWDML/swShortFormTrade/swFraParameters |
/fpml42:SWDML/fpml42:swShortFormTrade/fpml42:swFraParameters"
>FRA</xsl:when>
<xsl:when
test="/SWDML/swShortFormTrade/swFixedFixedParameters |
/fpml42:SWDML/fpml42:swShortFormTrade/fpml42:swFixedFixedParameters"
>Fixed Fixed Swap</xsl:when>
<xsl:when
test="/SWDML/swShortFormTrade/swIrsParameters |
/fpml42:SWDML/fpml42:swShortFormTrade/fpml42:swIrsParameters"
>SingleCurrencyInterestRateSwap</xsl:when>
<xsl:when
test="/fpml42:SWDML/fpml42:swShortFormTrade/fpml42:swCrossCurrencyIrsParameters"
>Cross Currency IRS</xsl:when>
<xsl:when
test="/SWDML/swShortFormTrade/swOisParameters |
/fpml42:SWDML/fpml42:swShortFormTrade/fpml42:swOisParameters"
>OIS</xsl:when>
<xsl:when
test="/SWDML/swShortFormTrade/swSwaptionParameters |
/fpml42:SWDML/fpml42:swShortFormTrade/fpml42:swSwaptionParameters"
>Swaption</xsl:when>
<xsl:when
test="/SWDML/swShortFormTrade/swBasisSwapParameters |
/fpml42:SWDML/fpml42:swShortFormTrade/fpml42:swBasisSwapParameters"
>Single Currency Basis Swap</xsl:when>
<xsl:when
test="/fpml42:SWDML/fpml42:swShortFormTrade/fpml42:swCrossCurrencyBasisSwapParameters"
>Cross Currency Basis Swap</xsl:when>
<xsl:when
test="/fpml42:SWDML/fpml42:swShortFormTrade/fpml42:swZCInflationSwapParameters"
>ZC Inflation Swap</xsl:when>
<xsl:when test="/fpml46:SWDML/fpml46:swShortFormTrade/fpml46:swEquityOptionParameters/fpml46:swEquityUnderlyer">Equity Share Option</xsl:when>
<xsl:when test="/fpml46:SWDML/fpml46:swShortFormTrade/fpml46:swEquityOptionParameters/fpml46:swIndexUnderlyer">Equity Index Option</xsl:when>
<xsl:when test="/fpml46:SWDML/fpml46:swShortFormTrade/fpml46:swVarianceSwapParameters/fpml46:swEquityUnderlyer">Share Variance Swap</xsl:when>
<xsl:when test="/fpml46:SWDML/fpml46:swShortFormTrade/fpml46:swVarianceSwapParameters/fpml46:swIndexUnderlyer">Index Variance Swap</xsl:when>
<xsl:when test="/fpml46:SWDML/fpml46:swShortFormTrade/fpml46:swEquitySwapParameters/fpml46:swEquityUnderlyer">Equity Share Swap</xsl:when>
<xsl:when test="/fpml46:SWDML/fpml46:swShortFormTrade/fpml46:swEquitySwapParameters/fpml46:swIndexUnderlyer">Equity Index Swap</xsl:when>
<xsl:when test="/fpml47:SWDML/fpml47:swShortFormTrade/fpml47:swEquitySwapParameters/fpml47:swIndexUnderlyer">Equity Index Swap</xsl:when>
<xsl:when test="/fpml47:SWDML/fpml47:swShortFormTrade/fpml47:swEquitySwapParameters/fpml47:swEquityUnderlyer">Equity Share Swap</xsl:when>
<xsl:when test="/fpml47:SWDML/fpml47:swShortFormTrade/fpml47:swEquityOptionParameters/fpml47:swEquityUnderlyer">Equity Share Option</xsl:when>
<xsl:when test="/fpml47:SWDML/fpml47:swShortFormTrade/fpml47:swEquityOptionParameters/fpml47:swIndexUnderlyer">Equity Index Option</xsl:when>
<xsl:when test="/fpml47:SWDML/fpml47:swShortFormTrade/fpml47:swVarianceSwapParameters/fpml47:swEquityUnderlyer">Share Variance Swap</xsl:when>
<xsl:when test="/fpml47:SWDML/fpml47:swShortFormTrade/fpml47:swVarianceSwapParameters/fpml47:swIndexUnderlyer">Index Variance Swap</xsl:when>
<xsl:when test="/fpml49:SWDML/fpml49:swShortFormTrade/fpml49:swEquitySwapParameters/fpml49:swIndexUnderlyer">Equity Index Swap</xsl:when>
<xsl:when test="/fpml49:SWDML/fpml49:swShortFormTrade/fpml49:swEquitySwapParameters/fpml49:swEquityUnderlyer">Equity Share Swap</xsl:when>
<xsl:when test="/fpml49:SWDML/fpml49:swShortFormTrade/fpml49:swEquityOptionParameters/fpml49:swEquityUnderlyer">Equity Share Option</xsl:when>
<xsl:when test="/fpml49:SWDML/fpml49:swShortFormTrade/fpml49:swEquityOptionParameters/fpml49:swIndexUnderlyer">Equity Index Option</xsl:when>
<xsl:when test="/fpml49:SWDML/fpml49:swShortFormTrade/fpml49:swVarianceSwapParameters/fpml49:swEquityUnderlyer">Share Variance Swap</xsl:when>
<xsl:when test="/fpml49:SWDML/fpml49:swShortFormTrade/fpml49:swVarianceSwapParameters/fpml49:swIndexUnderlyer">Index Variance Swap</xsl:when>
<xsl:when test="/fpml49:SWDML/fpml49:swShortFormTrade/fpml49:swVolatilitySwapParameters/fpml49:swEquityUnderlyer">Equity Share Volatility Swap</xsl:when>
<xsl:when test="/fpml49:SWDML/fpml49:swShortFormTrade/fpml49:swVolatilitySwapParameters/fpml49:swIndexUnderlyer">Equity Index Volatility Swap</xsl:when>
<xsl:otherwise>*** Not Supported ***</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="/SWDML/swLongFormTrade/swStructuredTradeDetails/swProductType"/>
<xsl:value-of select="/fpml42:SWDML/fpml42:swLongFormTrade/fpml42:swStructuredTradeDetails/fpml42:swProductType"/>
<xsl:value-of select="/fpml44:SWDML/fpml44:swLongFormTrade/fpml44:swStructuredTradeDetails/fpml44:swProductType"/>
<xsl:value-of select="/fpml45:SWDML/fpml45:swLongFormTrade/fpml45:swStructuredTradeDetails/fpml45:swProductType"/>
<xsl:value-of select="/fpml46:SWDML/fpml46:swLongFormTrade/fpml46:swStructuredTradeDetails/fpml46:swProductType"/>
<xsl:value-of select="/fpml47:SWDML/fpml47:swLongFormTrade/fpml47:swStructuredTradeDetails/fpml47:swProductType"/>
<xsl:value-of select="/fpml49:SWDML/fpml49:swLongFormTrade/fpml49:swStructuredTradeDetails/fpml49:swProductType"/>
<xsl:value-of select="/fpml53:SWDML/fpml53:swLongFormTrade/fpml53:swStructuredTradeDetails/fpml53:swProductType"/>
<xsl:value-of select="/fpml511:SWDML/fpml511:swLongFormTrade/fpml511:swStructuredTradeDetails/fpml511:swProductType"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:value-of select="@version"/>,<xsl:value-of select="$productType"/>,<xsl:value-of select="@xsi:schemaLocation"/>
</xsl:template>
<xsl:template match="*">Not SWDML</xsl:template>
</xsl:stylesheet>
