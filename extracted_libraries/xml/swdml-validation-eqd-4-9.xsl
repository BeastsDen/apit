<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fpml="http://www.fpml.org/2010/FpML-4-9" exclude-result-prefixes="fpml common" version="1.0" xmlns:common="http://exslt.org/common">
<xsl:import href="CrossAssetValidation.xsl"/>
<xsl:import href="swdml-validation-reporting.xsl"/>
<xsl:variable name="reportingData.rtf">
<xsl:apply-templates select="/fpml:SWDML/fpml:swTradeEventReportingDetails" mode="mapReportingData"/>
<xsl:apply-templates select="/fpml:SWDML/fpml:swLongFormTrade/fpml:swAllocations/node()" mode="mapReportingData"/>
<xsl:apply-templates select="/fpml:SWDML/fpml:swLongFormTrade/fpml:novation/fpml:swNovationExecutionUniqueTransactionId" mode="mapReportingData"/>
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
<xsl:attribute name="{local-name()}"><xsl:value-of select="."/></xsl:attribute>
</xsl:template>
<xsl:template match="/">
<xsl:apply-templates select="fpml:SWDML" mode="get-reporting-data"/>
</xsl:template>
<xsl:template match="/fpml:SWDML[function-available('common:node-set')]" mode="get-reporting-data">
<xsl:apply-templates select=".">
<xsl:with-param name="reportingData" select="common:node-set($reportingData.rtf)"/>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="/fpml:SWDML[not(function-available('common:node-set'))]" mode="get-reporting-data">
<xsl:apply-templates select=".">
<xsl:with-param name="reportingData" select="$reportingData.rtf"/>
</xsl:apply-templates>
</xsl:template>
<xsl:variable name="version">
<xsl:value-of select="/fpml:SWDML/@version"/>
</xsl:variable>
<xsl:variable name="assetClass">Equities</xsl:variable>
<xsl:variable name="productType">
<xsl:if test="/fpml:SWDML/fpml:swLongFormTrade">
<xsl:value-of select="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:swProductType"/>
</xsl:if>
<xsl:if test="/fpml:SWDML/fpml:swShortFormTrade">
<xsl:choose>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swEquityOptionParameters/fpml:swEquityUnderlyer">Equity Share Option</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swEquityOptionParameters/fpml:swIndexUnderlyer">Equity Index Option</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swVarianceSwapParameters/fpml:swEquityUnderlyer">Share Variance Swap</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swVarianceSwapParameters/fpml:swIndexUnderlyer">Index Variance Swap</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swEquitySwapParameters/fpml:swEquityUnderlyer">Equity Share Swap</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swEquitySwapParameters/fpml:swEquityUnderlyer">Equity Basket Swap</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swEquitySwapParameters/fpml:swIndexUnderlyer">Equity Index Swap</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swVolatilitySwapParameters/fpml:swEquityUnderlyer">Equity Share Volatility Swap</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swVolatilitySwapParameters/fpml:swIndexUnderlyer">Equity Index Volatility Swap</xsl:when>
</xsl:choose>
</xsl:if>
</xsl:variable>
<xsl:variable name="FpMLVersion">
<xsl:value-of select="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/@version"/>
</xsl:variable>
<xsl:variable name="docsType">
<xsl:if test="/fpml:SWDML/fpml:swLongFormTrade">
<xsl:choose>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'ISDA2005EquityAsiaExcludingJapanInterdealer'">Equity Options (AEJ)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'EquityOptionAEJPrivate'">Equity Options (AEJ)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'ISDA2008EquityAsiaExcludingJapan'">Equity Options (AEJ)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'ISDA2004EquityAmericasInterdealer' and ($productType = 'Equity Share Option' or $productType = 'Equity Index Option' or $productType = 'Equity Share Option Strategy' or $productType = 'Equity Index Option Strategy')">Equity Options (Americas)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'ISDA2008EquityAmericas' and ($productType = 'Equity Share Option' or $productType = 'Equity Index Option' or $productType = 'Equity Share Option Strategy' or $productType = 'Equity Index Option Strategy')">Equity Options (Americas)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'ISDA2009EquityAmericas' and ($productType = 'Equity Share Option' or $productType = 'Equity Index Option' or $productType = 'Equity Share Option Strategy' or $productType = 'Equity Index Option Strategy')">Equity Options (Americas)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'EquityOptionAmericasPrivate' and ($productType = 'Equity Share Option' or $productType = 'Equity Index Option' or $productType = 'Equity Share Option Strategy' or $productType = 'Equity Index Option Strategy')">Equity Options (Americas)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'EquityCliquetOptionPrivate' and $productType = 'Equity Index Option'">Equity Options (Cliquet)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'EquitySpreadOptionAmericasPrivate' and $productType = 'Equity Index Option'">Equity Options (Spread)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'EquitySpreadOptionAmericasISDA2008' and $productType = 'Equity Index Option'">Equity Options (Spread)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'EquitySpreadOptionAmericasISDA2009' and $productType = 'Equity Index Option'">Equity Options (Spread)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'EquitySpreadOptionAmericasISDA2004' and $productType = 'Equity Index Option'">Equity Options (Spread)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = '2004EquityEuropeanInterdealer'">Equity Options (Europe)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'ISDA2007EquityEuropean' and ($productType = 'Equity Share Option' or $productType = 'Equity Index Option' or $productType = 'Equity Share Option Strategy' or $productType = 'Equity Index Option Strategy') ">Equity Options (Europe)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'EquityOptionEuropePrivate' and ($productType = 'Equity Share Option' or $productType = 'Equity Index Option' or $productType = 'Equity Share Option Strategy' or $productType = 'Equity Index Option Strategy') ">Equity Options (Europe)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'ISDA2005EquityJapaneseInterdealer'">Equity Options (Japan)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'ISDA2008EquityJapanese'">Equity Options (Japan)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'ISDA2010EquityEMEAInterdealer' ">Equity Options (EMEA)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'EquityOptionEMEAPrivate' ">Equity Options (EMEA)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'ISDA2007VarianceSwapAsiaExcludingJapan'">Variance Swap (AEJ)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'ISDA2004EquityAmericasInterdealer' and ($productType = 'Share Variance Swap' or $productType = 'Index Variance Swap')">Variance Swap (Americas)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'ISDA2007VarianceSwapAmericas'">Variance Swap (Americas)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = '2005VarianceSwapEuropeanInterdealer'">Variance Swap (Europe)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'ISDA2007VarianceSwapEuropean'">Variance Swap (Europe)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'ISDA2006VarianceSwapJapaneseInterdealer'">Variance Swap (Japan)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'ISDA2007EquityFinanceSwapEuropean'">Equity Swap (Europe)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'ISDA2007EquityEuropean' and ($productType = 'Equity Share Swap' or $productType = 'Equity Index Swap' or $productType = 'Equity Basket Swap') ">Equity Swap (Europe)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'EquitySwapEuropePrivate' ">Equity Swap (Europe)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'EmergingEquitySwapIndustry' and ($productType = 'Equity Index Swap' or $productType = 'Equity Share Swap')">Equity Swap (Emerging)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'EmergingEquitySwapEMEA' and ($productType = 'Equity Index Swap' or $productType = 'Equity Share Swap')">Equity Swap (Emerging)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'EmergingEquitySwapLATAM' and ($productType = 'Equity Index Swap' or $productType = 'Equity Share Swap')">Equity Swap (Emerging)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'ISDA2009EquityEuropeanInterdealer' ">Equity Swap (Europe)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'EquitySwapAEJPrivate' ">Equity Swap (AEJ)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'ISDA2005EquitySwapAsiaExcludingJapanInterdealer' ">Equity Swap (AEJ)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'ISDA2008EquityFinanceSwapAsiaExcludingJapan' ">Equity Swap (AEJ)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'ISDA2009EquityFinanceSwapAsiaExcludingJapan' ">Equity Swap (AEJ)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'EquitySwapAmericasPrivate' ">Equity Swap (Americas)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'ISDA2004EquityAmericasInterdealer' and ($productType = 'Equity Share Swap' or $productType = 'Equity Index Swap' or $productType = 'Equity Basket Swap')">Equity Swap (Americas)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'ISDA2009EquitySwapAmericas' ">Equity Swap (Americas)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'EquitySwapPanAsiaPrivate' ">Equity Swap (Pan Asia)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'ISDA2009EquitySwapPanAsia' ">Equity Swap (Pan Asia)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'EquitySwapGlobalPrivate' ">Equity Swap (Global)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = '2006DividendSwapEuropeanInterdealer' ">Dividend Swap (Europe)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'DividendSwapEuropeanPrivate' ">Dividend Swap (Europe)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'DividendSwapAmericasPrivate' ">Dividend Swap (Americas)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'ISDA2008DividendSwapJapan' ">Dividend Swap (Japan)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'ISDA2008DividendSwapJapaneseRev1' ">Dividend Swap (Japan)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'ISDA2007DispersionVarianceSwapEuropean' ">Dispersion Variance Swap (Europe)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'VolatilitySwapAsiaExcludingJapanPrivate' ">Volatility Swap (AEJ)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'VolatilitySwapAmericasPrivate' ">Volatility Swap (Americas)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'VolatilitySwapEuropeanPrivate' ">Volatility Swap (Europe)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'VolatilitySwapJapanesePrivate' ">Volatility Swap (Japan)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:contractualMatrix/fpml:matrixTerm = 'IVS1OpenMarkets' ">Volatility Swap (Open Markets)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'DividendSwapAsiaExcludingJapanPrivate' ">Dividend Swap (AEJ)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = '2014DividendSwapAsiaExcludingJapanInterdealer' ">Dividend Swap (AEJ)</xsl:when>
</xsl:choose>
</xsl:if>
<xsl:if test="/fpml:SWDML/fpml:swShortFormTrade">
<xsl:choose>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'ISDA2005EquityAsiaExcludingJapanInterdealer'">Equity Options (AEJ)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'EquityOptionAEJPrivate'">Equity Options (AEJ)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'ISDA2008EquityAsiaExcludingJapan'">Equity Options (AEJ)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'ISDA2004EquityAmericasInterdealer' and ($productType = 'Equity Share Option' or $productType = 'Equity Index Option')">Equity Options (Americas)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'ISDA2008EquityAmericas' and ($productType = 'Equity Share Option' or $productType = 'Equity Index Option')">Equity Options (Americas)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'ISDA2009EquityAmericas' and ($productType = 'Equity Share Option' or $productType = 'Equity Index Option')">Equity Options (Americas)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'EquityOptionAmericasPrivate' and ($productType = 'Equity Share Option' or $productType = 'Equity Index Option')">Equity Options (Americas)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'EquityCliquetOptionPrivate' and $productType = 'Equity Index Option'">Equity Options (Cliquet)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'EquitySpreadOptionAmericasPrivate' and $productType = 'Equity Index Option'">Equity Options (Spread)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'EquitySpreadOptionAmericasISDA2008' and $productType = 'Equity Index Option'">Equity Options (Spread)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'EquitySpreadOptionAmericasISDA2009' and $productType = 'Equity Index Option'">Equity Options (Spread)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'EquitySpreadOptionAmericasISDA2004' and $productType = 'Equity Index Option'">Equity Options (Spread)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = '2004EquityEuropeanInterdealer'">Equity Options (Europe)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'ISDA2007EquityEuropean' and ($productType = 'Equity Share Option' or $productType = 'Equity Index Option' or $productType = 'Equity Share Option Strategy' or $productType = 'Equity Index Option Strategy') ">Equity Options (Europe)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'EquityOptionEuropePrivate' and ($productType = 'Equity Share Option' or $productType = 'Equity Index Option' or $productType = 'Equity Share Option Strategy' or $productType = 'Equity Index Option Strategy') ">Equity Options (Europe)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'ISDA2005EquityJapaneseInterdealer'">Equity Options (Japan)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'ISDA2008EquityJapanese'">Equity Options (Japan)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'ISDA2010EquityEMEAInterdealer' ">Equity Options (EMEA)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'EquityOptionEMEAPrivate' ">Equity Options (EMEA)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'ISDA2007VarianceSwapAsiaExcludingJapan'">Variance Swap (AEJ)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'ISDA2004EquityAmericasInterdealer' and ($productType = 'Share Variance Swap' or $productType = 'Index Variance Swap')">Variance Swap (Americas)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'ISDA2007VarianceSwapAmericas'">Variance Swap (Americas)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = '2005VarianceSwapEuropeanInterdealer'">Variance Swap (Europe)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'ISDA2007VarianceSwapEuropean'">Variance Swap (Europe)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'ISDA2006VarianceSwapJapaneseInterdealer'">Variance Swap (Japan)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'ISDA2007EquityFinanceSwapEuropean' ">Equity Swap (Europe)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'ISDA2007EquityEuropean' and ($productType = 'Equity Share Swap' or $productType = 'Equity Index Swap' or $productType = 'Equity Basket Swap') ">Equity Swap (Europe)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'EquitySwapEuropePrivate' ">Equity Swap (Europe)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'ISDA2009EquityEuropeanInterdealer' ">Equity Swap (Europe)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'EmergingEquitySwapIndustry' and ($productType = 'Equity Index Swap' or $productType = 'Equity Share Swap')">Equity Swap (Emerging)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'EmergingEquitySwapEMEA' and ($productType = 'Equity Index Swap' or $productType = 'Equity Share Swap')">Equity Swap (Emerging)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'EmergingEquitySwapLATAM' and ($productType = 'Equity Index Swap' or $productType = 'Equity Share Swap')">Equity Swap (Emerging)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'EquitySwapAEJPrivate' ">Equity Swap (AEJ)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'ISDA2005EquitySwapAsiaExcludingJapanInterdealer' ">Equity Swap (AEJ)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'ISDA2008EquityFinanceSwapAsiaExcludingJapan' ">Equity Swap (AEJ)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'ISDA2009EquityFinanceSwapAsiaExcludingJapan' ">Equity Swap (AEJ)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'EquitySwapAmericasPrivate' ">Equity Swap (Americas)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'ISDA2004EquityAmericasInterdealer' and ($productType = 'Equity Share Swap' or $productType = 'Equity Index Swap' or $productType = 'Equity Basket Swap')">Equity Swap (Americas)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'ISDA2009EquitySwapAmericas' ">Equity Swap (Americas)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'EquitySwapPanAsiaPrivate' ">Equity Swap (Pan Asia)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'ISDA2009EquitySwapPanAsia' ">Equity Swap (Pan Asia)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'EquitySwapGlobalPrivate' ">Equity Swap (Global)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'VolatilitySwapAsiaExcludingJapanPrivate'">Volatility Swap (AEJ)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'IVS1OpenMarkets' and ($productType = 'Equity Share Volatility Swap' or $productType = 'Equity Index Volatility Swap')">Volatility Swap (Open Markets)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'VolatilitySwapAmericasPrivate '">Volatility Swap (Americas)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'VolatilitySwapEuropeanPrivate'">Volatility Swap (Europe)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'VolatilitySwapJapanesePrivate '">Volatility Swap (Japan)</xsl:when>
</xsl:choose>
</xsl:if>
</xsl:variable>
<xsl:variable name="mcType">
<xsl:if test="/fpml:SWDML/fpml:swLongFormTrade">
<xsl:value-of select="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType"/>
</xsl:if>
<xsl:if test="/fpml:SWDML/fpml:swShortFormTrade">
<xsl:value-of select="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType"/>
</xsl:if>
</xsl:variable>
<xsl:variable name="mcAnnexType">
<xsl:if test="/fpml:SWDML/fpml:swLongFormTrade">
<xsl:value-of select="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationAnnexType"/>
</xsl:if>
<xsl:if test="/fpml:SWDML/fpml:swShortFormTrade">
<xsl:value-of select="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsAnnexType"/>
</xsl:if>
</xsl:variable>
<xsl:variable name="docsSubType">
<xsl:if test="/fpml:SWDML/fpml:swLongFormTrade">
<xsl:choose>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'Equity Options (AEJ)'">ISDA</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'ISDA2005EquityAsiaExcludingJapanInterdealer'">2005 ISDA</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'EquityOptionAEJPrivate'">Private</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'ISDA2008EquityAsiaExcludingJapan'">2008 ISDA</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'Equity Options (Americas)'">ISDA</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'ISDA2004EquityAmericasInterdealer' and ($productType = 'Equity Share Option' or $productType = 'Equity Index Option' or $productType = 'Equity Share Option Strategy' or $productType = 'Equity Index Option Strategy')">2004 ISDA</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'ISDA2008EquityAmericas' and ($productType = 'Equity Share Option' or $productType = 'Equity Index Option' or $productType = 'Equity Share Option Strategy' or $productType = 'Equity Index Option Strategy')">2008 ISDA</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'ISDA2009EquityAmericas' and ($productType = 'Equity Share Option' or $productType = 'Equity Index Option' or $productType = 'Equity Share Option Strategy' or $productType = 'Equity Index Option Strategy')">2009 ISDA</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'EquityOptionAmericasPrivate' and ($productType = 'Equity Share Option' or $productType = 'Equity Index Option' or $productType = 'Equity Share Option Strategy' or $productType = 'Equity Index Option Strategy')">Private</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'EquityCliquetOptionPrivate' and $productType = 'Equity Index Option'">Private</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'EquitySpreadOptionAmericasPrivate' and $productType = 'Equity Index Option'">Private</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'EquitySpreadOptionAmericasISDA2008' and $productType = 'Equity Index Option'">2008 ISDA</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'EquitySpreadOptionAmericasISDA2009' and $productType = 'Equity Index Option'">2009 ISDA</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'EquitySpreadOptionAmericasISDA2004' and $productType = 'Equity Index Option'">2004 Interdealer</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'Equity Options (Europe)'">ISDA</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = '2004EquityEuropeanInterdealer'">2004 ISDA</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'ISDA2007EquityEuropean'">2007 ISDA</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'EquityOptionEuropePrivate'">Private</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'Equity Options (Japan)'">ISDA</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'ISDA2005EquityJapaneseInterdealer'">2005 ISDA</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'ISDA2008EquityJapanese'">2008 ISDA</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'ISDA2008EquityFinanceSwapAsiaExcludingJapan'">2008 ISDA</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'ISDA2009EquityFinanceSwapAsiaExcludingJapan'">2009 ISDA</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'ISDA2009EquitySwapPanAsia'">2009 ISDA</xsl:when>
<xsl:when test="$mcType='ISDA2009EquityEuropeanInterdealer' and $mcAnnexType='ISDA2009EquityEuropeanInterdealerAnnexSS' ">2009 ISDA</xsl:when>
<xsl:when test="$mcType='ISDA2009EquityEuropeanInterdealer' and $mcAnnexType='ISDA2010FairValueShareSwapEuropeanInterdealer' ">2009 ISDA (FVSS)</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'Equity Options (EMEA)'">ISDA</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'ISDA2010EquityEMEAInterdealer' ">2010 ISDA</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'EquityOptionEMEAPrivate' ">Private</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType[.='EquitySwapGlobalPrivate' or .='EquitySwapEuropePrivate' or .='EquitySwapAmericasPrivate' or .='EquitySwapAEJPrivate' or .='EquitySwapPanAsiaPrivate']">Private</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'ISDA2007DispersionVarianceSwapEuropean' ">2007 ISDA</xsl:when>
<xsl:otherwise>ISDA</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="/fpml:SWDML/fpml:swShortFormTrade">
<xsl:choose>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'Equity Options (AEJ)'">ISDA</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'ISDA2005EquityAsiaExcludingJapanInterdealer'">2005 ISDA</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'EquityOptionAEJPrivate'">Private</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'ISDA2008EquityAsiaExcludingJapan'">2008 ISDA</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'Equity Options (Americas)'">ISDA</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'ISDA2004EquityAmericasInterdealer' and ($productType = 'Equity Share Option' or $productType = 'Equity Index Option')">2004 ISDA</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'ISDA2008EquityAmericas' and ($productType = 'Equity Share Option' or $productType = 'Equity Index Option')">2008 ISDA</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'ISDA2009EquityAmericas' and ($productType = 'Equity Share Option' or $productType = 'Equity Index Option')">2009 ISDA</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'EquityOptionAmericasPrivate' and ($productType = 'Equity Share Option' or $productType = 'Equity Index Option')">Private</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'EquityCliquetOptionPrivate' and $productType = 'Equity Index Option'">Private</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'EquitySpreadOptionAmericasPrivate' and $productType = 'Equity Index Option'">Private</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'EquitySpreadOptionAmericasISDA2008' and $productType = 'Equity Index Option'">2008 ISDA</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'EquitySpreadOptionAmericasISDA2009' and $productType = 'Equity Index Option'">2009 ISDA</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'EquitySpreadOptionAmericasISDA2004' and $productType = 'Equity Index Option'">2004 Interdealer</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'Equity Options (Europe)'">ISDA</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = '2004EquityEuropeanInterdealer'">2004 ISDA</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'ISDA2007EquityEuropean'">2007 ISDA</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'EquityOptionEuropePrivate'">Private</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'Equity Options (Japan)'">ISDA</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'ISDA2005EquityJapaneseInterdealer'">2005 ISDA</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'ISDA2008EquityJapanese'">2008 ISDA</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'Equity Options (EMEA)' ">ISDA</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'ISDA2010EquityEMEAInterdealer' ">2010 ISDA</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'EquityOptionEMEAPrivate' ">Private</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'ISDA2008EquityFinanceSwapAsiaExcludingJapan'">2008 ISDA</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'ISDA2009EquitySwapPanAsia'">2009 ISDA</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'ISDA2009EquityEuropeanInterdealer'">2009 ISDA</xsl:when>
<xsl:when test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType[.='EquitySwapGlobalPrivate' or .='EquitySwapEuropePrivate' or .='EquitySwapAmericasPrivate' or .='EquitySwapAEJPrivate' or .='EquitySwapPanAsiaPrivate']">Private</xsl:when>
<xsl:otherwise>ISDA</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:variable>
<xsl:variable name="isPrimeBrokerTrade">
<xsl:choose>
<xsl:when test="/fpml:SWDML//fpml:swGiveUp">1</xsl:when>
<xsl:otherwise>0</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="isNovationTrade">
<xsl:choose>
<xsl:when test="/fpml:SWDML//fpml:novation">1</xsl:when>
<xsl:otherwise>0</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="isAllocatedTrade">
<xsl:choose>
<xsl:when test="/fpml:SWDML//fpml:swAllocations">1</xsl:when>
<xsl:otherwise>0</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:template match="fpml:swAllocations">
<xsl:param name="context"/>
<xsl:param name="reportingData"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
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
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:if test="$productType = 'Equity Share Swap' or $productType = 'Equity Index Swap' or $productType = 'Equity Basket Swap' or $productType='Share Dividend Swap' or $productType='Index Dividend Swap' or $productType='Equity Share Volatility Swap' or $productType='Equity Index Volatility Swap'">
<xsl:if test="not(fpml:swStreamReference)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swStreamReference must be present if product type is 'Equity Share Swap', 'Equity Index Swap', 'Share Dividend Swap' or 'Index Dividend Swap' or 'Equity Share Volatility Swap' or 'Equity Index Volatility Swap' or 'Equity Basket Swap'.</text>
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
<xsl:if test="not(//fpml:FpML/fpml:party[@id=$payerPartyRef])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** payerPartyReference/@href does not reference a valid //FpML/party/@id. Value = '<xsl:value-of select="$payerPartyRef"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not(//fpml:FpML/fpml:party[@id=$receiverPartyRef])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** receiverPartyReference/@href does not reference a valid //FpML/party/@id. Value = '<xsl:value-of select="$receiverPartyRef"/>'.</text>
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
<xsl:if test="$productType = 'Share Variance Swap' or $productType = 'Index Variance Swap'">
<xsl:if test="not(fpml:swAllocatedVarianceAmount)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swAllocatedVarianceAmount must be present.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$productType = 'Equity Share Volatility Swap' or $productType = 'Equity Index Volatility Swap'">
<xsl:if test="fpml:swAllocatedVarianceAmount">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swAllocatedVarianceAmount must not be present.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$productType = 'Equity Share Option' or $productType = 'Equity Index Option' or $productType = 'Equity Share Option Strategy' or $productType = 'Equity Index Option Strategy'  or $productType='Share Variance Swap' or $productType='Index Variance Swap'">
<xsl:if test="not(fpml:buyerPartyReference)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** buyerPartyReference must be present.</text>
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
<text>*** buyerPartyReference/@href and sellerPartyReference/@href values must not be the same.</text>
</error>
</xsl:if>
<xsl:if test="not(//fpml:FpML/fpml:party[@id=$buyerPartyRef])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** buyerPartyReference/@href does not reference a valid //FpML/trade/party/@id. Value = '<xsl:value-of select="$buyerPartyRef"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not(//fpml:FpML/fpml:party[@id=$sellerPartyRef])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** sellerPartyReference/@href does not reference a valid //FpML/trade/party/@id. Value = '<xsl:value-of select="$sellerPartyRef"/>'.</text>
</error>
</xsl:if>
<xsl:variable name="buyerPartyId">
<xsl:value-of select="//fpml:FpML//fpml:party[@id=$buyerPartyRef]/fpml:partyId"/>
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
<xsl:if test="fpml:swSalesCredit">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swSalesCredit</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swSalesCredit"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">999999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="($productType='Share Dividend Swap' or $productType='Index Dividend Swap') and fpml:independentAmountPercentage">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** IndependentAmountPercentage must not be present for Dividend Swaps.</text>
</error>
</xsl:if>
<xsl:if test="fpml:independentAmountPercentage">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swIAPercentage</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:independentAmountPercentage/fpml:swIAPercentage"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">999.999999</xsl:with-param>
<xsl:with-param name="maxDecs">6</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:independentAmountPercentage and //fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swIndependentAmountPercentage">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swIndependentAmountPercentage must not be present when Allocation independentAmountPercentage is present.</text>
</error>
</xsl:if>
<xsl:if test="$productType = 'Equity Share Option' or ($productType = 'Equity Index Option' and $docsType != 'Equity Options (Spread)')">
<xsl:if test="not(//fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:strike/fpml:strikePrice) and fpml:independentAmountPercentage">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Allocation independentAmountPercentage must not be present when strikePrice is not present.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:call-template name="swAllocationReportingDetails">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
<xsl:with-param name="reportingData" select="$reportingData"/>
<xsl:with-param name="allocationNum" select="position()"/>
</xsl:call-template>
</xsl:template>
<xsl:template match="fpml:novation">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:variable name="transferor">
<xsl:value-of select="fpml:transferor/@href"/>
</xsl:variable>
<xsl:if test="not(//fpml:FpML/fpml:party[@id=$transferor])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** transferor/@href does not reference a valid //FpML/party/@id. Value = '<xsl:value-of select="$transferor"/>'.</text>
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
<text>*** transferee/@href does not reference a valid //FpMLparty/@id. Value = '<xsl:value-of select="$transferee"/>'.</text>
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
<text>*** remainingParty/@href does not reference a valid //FpML/party/@id. Value = '<xsl:value-of select="$remainingParty"/>'.</text>
</error>
</xsl:if>
<xsl:variable name="otherRemainingParty">
<xsl:value-of select="fpml:otherRemainingParty/@href"/>
</xsl:variable>
<xsl:if test="fpml:otherRemainingParty">
<xsl:if test="not(//fpml:FpML/fpml:party[@id=$otherRemainingParty])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** otherRemainingParty/@href does not reference a valid //FpML/party/@id. Value = '<xsl:value-of select="$otherRemainingParty"/>'.</text>
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
<xsl:choose>
<xsl:when test="($productType = 'Equity Share Option' or $productType = 'Equity Index Option' or $productType = 'Equity Share Option Strategy' or $productType = 'Equity Index Option Strategy') and not(fpml:novatedNumberOfOptions)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing novatedNumberOfOptions when product type is 'Equity Share Option'  or 'Equity Index Option' or 'Equity Index Option Strategy' or 'Equity Share Option Strategy'. Required in this context.</text>
</error>
</xsl:when>
<xsl:when test="($productType = 'Share Variance Swap' or $productType = 'Index Variance Swap') and not(fpml:novatedVarianceAmount)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing novatedVarianceAmount when product type is 'Share Variance Swap'  or 'Index Variance Swap'. Required in this context.</text>
</error>
</xsl:when>
<xsl:when test="($productType = 'Equity Share Swap' or $productType = 'Equity Index Swap' or $productType = 'Share Dividend Swap' or $productType = 'Index Dividend Swap') and not(fpml:swNovatedUnits)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swNovatedUnits when product type is 'Equity Share Swap', 'Equity Index Swap', 'Share Dividend Swap'  or 'Index Dividend Swap'. Required in this context.</text>
</error>
</xsl:when>
</xsl:choose>
<xsl:variable name="tradeNotional">
<xsl:choose>
<xsl:when test="$productType='Equity Share Option' or $productType='Equity Index Option' or $productType='Equity Share Option Strategy' or $productType='Equity Index Option Strategy'">
<xsl:value-of select="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:numberOfOptions"/>
</xsl:when>
<xsl:when test="$productType='Share Variance Swap' or $productType='Index Variance Swap'">
<xsl:value-of select="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:varianceLeg/fpml:equityAmount/fpml:variance/fpml:varianceAmount/fpml:amount"/>
</xsl:when>
</xsl:choose>
</xsl:variable>
<xsl:choose>
<xsl:when test="($productType = 'Equity Share Option' or $productType = 'Equity Index Option' or $productType = 'Equity Share Option Strategy' or $productType = 'Equity Index Option Strategy') and number(fpml:novatedNumberOfOptions) &gt; number($tradeNotional)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** novatedNumberOfOptions must not be greater than trade numberOfOptions.</text>
</error>
</xsl:when>
</xsl:choose>
<xsl:if test="$docsType='Equity Options (Europe)' or $docsType='Equity Options (AEJ)' or $docsType='Equity Options (Americas)' or $docsType='Equity Options (EMEA)' ">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">novatedNumberOfOptions</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:novatedNumberOfOptions"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">9999999999.99999</xsl:with-param>
<xsl:with-param name="maxDecs">5</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="$docsType='Equity Options (Japan)'">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">novatedNumberOfOptions</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:novatedNumberOfOptions"/>
</xsl:with-param>
<xsl:with-param name="minIncl">1</xsl:with-param>
<xsl:with-param name="maxIncl">9999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:novatedVarianceAmount">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">novatedVarianceAmount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:novatedVarianceAmount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.01</xsl:with-param>
<xsl:with-param name="maxIncl">9999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swNovatedUnits">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swNovatedUnits</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swNovatedUnits"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.00001</xsl:with-param>
<xsl:with-param name="maxIncl">999999999.99999</xsl:with-param>
<xsl:with-param name="maxDecs">5</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swNovatedVegaNotionalAmount">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swNovatedVegaNotionalAmount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swNovatedVegaNotionalAmount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.01</xsl:with-param>
<xsl:with-param name="maxIncl">9999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:payment">
<xsl:if test="fpml:payment[fpml:paymentType != 'Novation']">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** payment/paymentType must be equal to 'Novation'. Value = '<xsl:value-of select="fpml:payment/fpml:paymentType"/>'.</text>
</error>
</xsl:if>
<xsl:if test="($transferor != fpml:payment/fpml:payerPartyReference/@href) and ($transferor != fpml:payment/fpml:receiverPartyReference/@href)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** transferor/@href must equal payment/payerPartyReference/@href or payment/receiverPartyReference/@href.</text>
</error>
</xsl:if>
<xsl:if test="($remainingParty = fpml:payment/fpml:payerPartyReference/@href) or ($remainingParty = fpml:payment/fpml:receiverPartyReference/@href)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** payment/payerPartyReference/@href or payment/receiverPartyReference/@href must not be equal to remainingParty/@href.</text>
</error>
</xsl:if>
<xsl:if test="fpml:otherRemainingParty">
<xsl:if test="($otherRemainingParty = fpml:payment/fpml:payerPartyReference/@href) or ($otherRemainingParty = fpml:payment/fpml:receiverPartyReference/@href)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** payment/payerPartyReference/@href or payment/receiverPartyReference/@href must not be equal to otherRemainingParty/@href.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
<xsl:if test="($productType='Equity Index Option' or $productType='Equity Share Option') and ($docsType = 'Equity Options (Spread)' or $docsType = 'Equity Options (Cliquet)')">
<xsl:if test="/fpml:SWDML/fpml:swLongFormTrade/fpml:novation/fpml:swCopyPremiumToNewTrade">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** copypremiumtonewtrade is not applicable on cliquet and spread.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="/fpml:SWDML/fpml:swLongFormTrade/fpml:novation/fpml:swPartialNovationIndicator">
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
<xsl:if test="$productType!='Equity Share Option' and $productType!='Equity Index Option'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swBilateralClearingHouse should only be present if product type is 'Equity Share Option' or 'Equity Index Option'.</text>
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
<xsl:template match="fpml:SWDML">
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
<xsl:if test="not(fpml:swShortFormTrade or fpml:swLongFormTrade)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swShortFormTrade or swLongFormTrade element. Required in this context.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:swShortFormTrade">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:swLongFormTrade">
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
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
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
<xsl:if test="count(//fpml:hedgingParty) &gt; 2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of hedgingParty elements encountered. One or Two expected.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swDividendSwapParameters">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Short Form trades are not currently supported for Dividend Swap.</text>
</error>
</xsl:if>
<xsl:choose>
<xsl:when test="$productType='Equity Share Option'"/>
<xsl:when test="$productType='Equity Index Option'"/>
<xsl:when test="$productType='Equity Share Option Strategy'"/>
<xsl:when test="$productType='Equity Index Option Strategy'"/>
<xsl:when test="$productType='Share Variance Swap'"/>
<xsl:when test="$productType='Index Variance Swap'"/>
<xsl:when test="$productType='Equity Share Swap'"/>
<xsl:when test="$productType='Equity Basket Swap'"/>
<xsl:when test="$productType='Equity Index Swap'"/>
<xsl:when test="$productType='Equity Share Volatility Swap'"/>
<xsl:when test="$productType='Equity Index Volatility Swap'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or unexpected product type value.</text>
</error>
</xsl:otherwise>
</xsl:choose>
<xsl:choose>
<xsl:when test="fpml:swEquityOptionParameters/fpml:swEquityUnderlyer and $productType='Equity Share Option'"/>
<xsl:when test="fpml:swEquityOptionParameters/fpml:swIndexUnderlyer and $productType='Equity Index Option'"/>
<xsl:when test="fpml:swEquityOptionParameters/fpml:swEquityUnderlyer and $productType='Equity Share Option Strategy'"/>
<xsl:when test="fpml:swEquityOptionParameters/fpml:swIndexUnderlyer and $productType='Equity Index Option Strategy'"/>
<xsl:when test="fpml:swVarianceSwapParameters/fpml:swEquityUnderlyer and $productType='Share Variance Swap'"/>
<xsl:when test="fpml:swVarianceSwapParameters/fpml:swIndexUnderlyer and $productType='Index Variance Swap'"/>
<xsl:when test="fpml:swEquitySwapParameters/fpml:swEquityUnderlyer and $productType='Equity Share Swap' "/>
<xsl:when test="fpml:swEquitySwapParameters/fpml:swEquityUnderlyer and $productType='Equity Basket Swap' "/>
<xsl:when test="fpml:swEquitySwapParameters/fpml:swIndexUnderlyer and $productType='Equity Index Swap' "/>
<xsl:when test="fpml:swVolatilitySwapParameters/fpml:swEquityUnderlyer and $productType='Equity Share Volatility Swap'"/>
<xsl:when test="fpml:swVolatilitySwapParameters/fpml:swIndexUnderlyer and $productType='Equity Index Volatility Swap'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The underlyer type does not match the product type</text>
</error>
</xsl:otherwise>
</xsl:choose>
<xsl:if test="$productType = 'Equity Share Option' or $productType = 'Equity Index Option' or $productType = 'Equity Share Option Strategy' or $productType = 'Equity Index Option Strategy'">
<xsl:call-template name="isValidEquityConfirmationType">
<xsl:with-param name="elementName">swDocsType</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swDocsType"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsAnnexType">
<xsl:if test="$productType = 'Equity Share Option' or $productType = 'Equity Index Option' or $productType = 'Equity Share Option Strategy' or $productType = 'Equity Index Option Strategy'">
<xsl:call-template name="isValidEquityOptionConfirmationAnnexType">
<xsl:with-param name="elementName">swDocsAnnexType</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swDocsAnnexType"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
</xsl:if>
<xsl:if test="$productType = 'Share Variance Swap' or $productType = 'Index Variance Swap'">
<xsl:call-template name="isValidVarianceSwapConfirmationType">
<xsl:with-param name="elementName">swDocsType</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swDocsType"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="$productType = 'Equity Share Volatility Swap' or $productType = 'Equity Index Volatility Swap'">
<xsl:call-template name="isValidVolatilitySwapConfirmationType">
<xsl:with-param name="elementName">swDocsType</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swDocsType"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="$productType = 'Equity Share Swap' or $productType = 'Equity Index Swap' or $productType = 'Equity Basket Swap'">
<xsl:call-template name="isValidEquitySwapConfirmationType">
<xsl:with-param name="elementName">swDocsType</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swDocsType"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="/fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsAnnexType">
<xsl:if test="$productType = 'Equity Share Swap' or $productType = 'Equity Index Swap' or $productType = 'Equity Basket Swap'">
<xsl:call-template name="isValidEquitySwapConfirmationAnnexType">
<xsl:with-param name="elementName">swDocsAnnexType</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swDocsAnnexType"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:swEquityOptionParameters">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:swVarianceSwapParameters">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:swVolatilitySwapParameters">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:swEquitySwapParameters">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:swIndependentAmount">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:swBackLoadingFlag">
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">swBackLoadingFlag</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swBackLoadingFlag"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swMigrationReference[1]/@href = fpml:swMigrationReference[2]/@href">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swMigrationReference[1]/@href and swMigrationReference[2]/@href values must not be the same.</text>
</error>
</xsl:if>
<xsl:if test="($productType = 'Equity Share Option' or $productType ='Equity Share Option Strategy') and fpml:swEquityOptionParameters/fpml:multiplierShortForm">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected multiplier element encountered in this context. Element must not be present when product type is 'Equity Share Option' or 'Equity Share Option Strategy'.</text>
</error>
</xsl:if>
<xsl:choose>
<xsl:when test="fpml:swEquityOptionParameters/fpml:multiplierShortForm">
<xsl:call-template name="isValidIntegerNumber">
<xsl:with-param name="elementName">multiplierShortForm</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swEquityOptionParameters/fpml:multiplierShortForm"/>
</xsl:with-param>
<xsl:with-param name="minIncl">1</xsl:with-param>
<xsl:with-param name="maxIncl">1000000000</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:when>
</xsl:choose>
</xsl:template>
<xsl:template match="fpml:swLongFormTrade">
<xsl:param name="context"/>
<xsl:param name="reportingData"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
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
<xsl:if test="not(//fpml:FpML/fpml:party[@id = $href])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swOriginatorPartyReference/@href does not reference a valid //FpML/trade/party/@id. Value = '<xsl:value-of select="$href"/>'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swBackLoadingFlag">
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">swBackLoadingFlag</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swBackLoadingFlag"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swMigrationReference[1]/@href = fpml:swMigrationReference[2]/@href">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swMigrationReference[1]/@href and swMigrationReference[2]/@href values must not be the same.</text>
</error>
</xsl:if>
<xsl:if test="fpml:independentAmountPercentage">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swIAPercentage</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:independentAmountPercentage/fpml:swIAPercentage"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">999.999999</xsl:with-param>
<xsl:with-param name="maxDecs">6</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="//fpml:swExtendedTradeDetails/fpml:swIndependentAmountPercentage and //fpml:FpML/fpml:trade/fpml:collateral">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** FpML/trade/collateral and swIndependentAmountPercentage cannot be both present.</text>
</error>
</xsl:if>
<xsl:if test="$productType = 'Equity Share Option' or ($productType = 'Equity Index Option' and $docsType != 'Equity Options (Spread)')">
<xsl:if test="not(fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:strike/fpml:strikePrice) and //fpml:swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swIndependentAmountPercentage">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swIndependentAmountPercentage must not be present when strikePrice is not present.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:swComplianceElection/fpml:rule15A-6 and not($productType = 'Equity Share Option' or $productType = 'Equity Index Option' or $productType = 'Equity Share Option Universal' or $productType = 'Equity Index Option Universal')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** rule15A-6 must not be present when the product is not an Equity Option.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:swStructuredTradeDetails">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:swEquityOptionParameters">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
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
<xsl:if test="fpml:swEquityAmericanExercise">
<xsl:apply-templates select="fpml:swEquityAmericanExercise">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
<xsl:if test="fpml:swEquityEuropeanExercise">
<xsl:apply-templates select="fpml:swEquityEuropeanExercise">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
<xsl:apply-templates select="fpml:swEquityUnderlyer|fpml:swIndexUnderlyer">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="not(fpml:optionType='Call' or fpml:optionType='Put')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***Unexpected optionType value</text>
</error>
</xsl:if>
<xsl:if test="$docsType='Equity Options (Europe)' or $docsType='Equity Options (AEJ)' or $docsType='Equity Options (Americas)' or $docsType='Equity Options (EMEA)' ">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">numberOfOptions</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:numberOfOptions"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">9999999999.99999</xsl:with-param>
<xsl:with-param name="maxDecs">5</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="$docsType='Equity Options (Japan)'">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">numberOfOptions</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:numberOfOptions"/>
</xsl:with-param>
<xsl:with-param name="minIncl">1</xsl:with-param>
<xsl:with-param name="maxIncl">9999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:strikePrice">
<xsl:if test="$docsType='Equity Options (Europe)' or $docsType='Equity Options (Americas)' or $docsType='Equity Options (EMEA)' ">
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
</xsl:if>
<xsl:if test="fpml:strikePrice">
<xsl:if test="$docsType='Equity Options (Japan)' or $docsType='Equity Options (AEJ)'">
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
</xsl:if>
<xsl:variable name="strikePercentageFieldApplicable">
<xsl:choose>
<xsl:when test="$docsType='Equity Options (Europe)' ">true</xsl:when>
<xsl:when test="$docsType='Equity Options (AEJ)' ">true</xsl:when>
<xsl:when test="$docsType='Equity Options (Spread)' ">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:if test="fpml:strikePercentage and $strikePercentageFieldApplicable = 'false' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected strikePercentage element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:strikePercentage">
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
</xsl:if>
<xsl:if test="fpml:strikePercentage and not(fpml:swStrikeDeterminationDate) ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swStrikeDeterminationDate element in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swStrikeDeterminationDate and fpml:swCap">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Cap element encountered in this context when Strike Date is present.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swStrikeDeterminationDate and fpml:swFloor">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Floor element encountered in this context when Strike Date is present.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swStrikeDeterminationDate">
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">swStrikeDeterminationDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swStrikeDeterminationDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:optionEntitlement and ($productType='Equity Index Option' or $productType='Equity Index Option Strategy')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected optionEntitlement element encountered in this context when product type is 'Equity Index Option' or 'Equity Index Option Strategy'.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:optionEntitlement) and ($productType='Equity Share Option' or $productType='Equity Share Option Strategy')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing optionEntitlement element in this context when product type is 'Equity Share Option' or 'Equity Share Option Strategy'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:optionEntitlement">
<xsl:call-template name="isValidIntegerNumber">
<xsl:with-param name="elementName">optionEntitlement</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:optionEntitlement"/>
</xsl:with-param>
<xsl:with-param name="minIncl">1</xsl:with-param>
<xsl:with-param name="maxIncl">999999</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swReferenceCurrency">
<xsl:call-template name="isValidReferenceCurrency">
<xsl:with-param name="elementName">swReferenceCurrency</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swReferenceCurrency"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swReferenceCurrency and not ($docsType='Equity Options (AEJ)' and fpml:settlementType = 'Cash')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swReferenceCurrency element encountered in this context. Element must not be present when Docs Type is not 'Equity Options (AEJ)' and settlementType is not 'Cash'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swReferenceFXRate">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swReferenceFXRate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swReferenceFXRate"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">99999.999999</xsl:with-param>
<xsl:with-param name="maxDecs">6</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="not(//fpml:swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swEquityOptionDetails/fpml:swSettlementPriceDefaultElection = 'HedgeExecution')">
<xsl:if test="fpml:swReferenceFXRate and (not(fpml:swReferenceCurrency) or fpml:swReferenceCurrency = fpml:swPremium/fpml:paymentAmount/fpml:currency)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swReferenceFXRate provided - Not expected for Vanilla Trades.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:swReferenceFXRate and fpml:settlementType != 'Cash' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swReferenceFXRate provided - Not expected for physically settled Trades.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:settlementType[.='Physical']) and ($productType='Equity Share Option' or $productType='Equity Share Option Strategy') and $docsType='Equity Options (Japan)' and $docsSubType='2005 ISDA'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid settlementType element encountered in this context when Docs Type is 'ISDA2005EquityJapaneseInterdealer' and product type = 'Equity Share Option' or 'Equity Share Option Strategy'. Share Options confirmed under the 2005 Japanse Master Confirmation must be physically settled. Cash settlement is allowed under 'ISDA2008EquityJapanese'. </text>
</error>
</xsl:if>
<xsl:if test="fpml:settlementType = 'Election'">
<xsl:if test="not(($productType='Equity Share Option' or $productType='Equity Share Option Strategy') and ($docsType='Equity Options (Americas)' or $docsType='Equity Options (AEJ)' or $mcType='2004EquityEuropeanInterdealer' or $mcType='ISDA2007EquityEuropean' or $mcType='ISDA2008EquityJapanese'))">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid settlementType 'Election' in this context. 'Election' is valid only when product type is 'Equity Share Option' or 'Equity Share Option Strategy' and Docs Type is 'Equity Options (Americas)', Docs Type is 'Equity Options (AEJ) - 2008 MCA or 2005 MCA', European 2004 Interdealer, European 2007 ISDA or Japan 2008.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:swCashSettlementType and not ($docsType='Equity Options (AEJ)' and fpml:settlementType = 'Cash')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swCashSettlementType element encountered in this context. Element must not be present when Docs Type is not 'Equity Options (AEJ)' and settlementType is not 'Cash'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swCashSettlementType">
<xsl:if test="not(fpml:swCashSettlementType='Composite' or fpml:swCashSettlementType='Quanto' or fpml:swCashSettlementType='Cross-Currency' or fpml:swCashSettlementType='Vanilla')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected value in swCashSettlementType. The value must be 'Composite' or 'Quanto' or 'Cross-Currency' or 'Vanilla'</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="(fpml:swCashSettlementPaymentDateOffset and fpml:settlementType = 'Physical') or (fpml:swCashSettlementPaymentDateOffset and fpml:settlementType = 'Election' and fpml:swDefaultSettlementMethod != 'Cash')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swCashSettlementPaymentDateOffset element encountered in this context when settlementType is 'Physical' or when settlementType is 'Election' and swDefaultSettlementMethod is not equal to 'Cash'. swCashSettlementPaymentDateOffset only applies to cash settled options or to options for which Settlement Election applies and the default settlement method is 'Cash'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swCashSettlementPaymentDateOffset">
<xsl:call-template name="isValidPeriodMultiplier">
<xsl:with-param name="elementName">swCashSettlementPaymentDateOffset</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swCashSettlementPaymentDateOffset"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swDefaultSettlementMethod and fpml:settlementType!='Election'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** If settlementType is not equal to 'Election' then swEquityOptionDetails/swDefaultSettlementMethod must not be present.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swSettlementPriceDefaultElectionMethod">
<xsl:call-template name="isValidSettlementPriceDefaultElectionMethod">
<xsl:with-param name="elementName">SettlementPriceDefaultElectionMethod</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swSettlementPriceDefaultElectionMethod"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="(fpml:swSettlementPriceDefaultElectionMethod) and not($docsType='ISDA2008EquityAsiaExcludingJapan')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Settlement Price Default Election should only be supplied where Docs Type is 'ISDA2008EquityAsiaExcludingJapan' .</text>
</error>
</xsl:if>
<xsl:if test="(fpml:swSettlementPriceDefaultElectionMethod and $productType!='Equity Share Option')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Settlement Price Default Election should only be supplied where product type is Equity Share Option.</text>
</error>
</xsl:if>
<xsl:if test="(fpml:swSettlementPriceDefaultElectionMethod) and ($docsType='ISDA2005EquityAsiaExcludingJapanInterdealer' or $docsType = 'ISDA2008EquityAsiaExcludingJapan' or $docsType = 'EquityOptionAEJPrivate')">
<xsl:choose>
<xsl:when test="//fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:equityExercise/fpml:settlementCurrency = 'USD'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Settlement Price Default Election can only be present when equityExercise/settlementCurrency is a non-deliverable currency and docsType is 'ISDA2005EquityAsiaExcludingJapanInterdealer' or 'ISDA2008EquityAsiaExcludingJapan' or 'EquityOptionAEJPrivate'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="fpml:settlementType='Election' and not(fpml:swDefaultSettlementMethod)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** If settlementType is equal to 'Election' then swEquityOptionDetails/swDefaultSettlementMethod must be present.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swDefaultSettlementMethod">
<xsl:call-template name="isValidDefaultSettlementMethod">
<xsl:with-param name="elementName">swDefaultSettlementMethod</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swDefaultSettlementMethod"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swSettlementMethodElectionDate">
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">swSettlementMethodElectionDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swSettlementMethodElectionDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
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
<xsl:apply-templates select="fpml:swPremium">
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
<xsl:apply-templates select="fpml:futuresPriceValuation">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:swDeltaCrossShortForm">
<xsl:apply-templates select="fpml:swDeltaCrossShortForm">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
<xsl:apply-templates select="fpml:swEquityOptionPercentInput">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:swEquityOptionPercentInput and not ($docsType = 'Equity Options (AEJ)' or $docsType = 'Equity Options (Japan)' or $docsType = 'Equity Options (Americas)' )">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swEquityOptionPercentInput element encountered in this context. Element must not be present if product is not on a Japanese or, Americas or AEJ Underlier. Value = '<xsl:value-of select="$docsType"/>'</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:swAveragingDatesShortForm">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
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
<xsl:template match="fpml:swAveragingDatesShortForm">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="fpml:swAveragingStart">
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">swAveragingStart</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swAveragingStart"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swAveragingEnd">
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">swAveragingEnd</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swAveragingEnd"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swAveragingFrequency">
<xsl:if test="not(fpml:swAveragingFrequency ='Custom' or fpml:swAveragingFrequency ='1 Day' or fpml:swAveragingFrequency ='1 Week' or fpml:swAveragingFrequency ='Fortnightly' or fpml:swAveragingFrequency ='4 Weekly' or fpml:swAveragingFrequency ='1m' or fpml:swAveragingFrequency ='2m' or fpml:swAveragingFrequency ='3m' or fpml:swAveragingFrequency ='Asian Tail')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***swAveragingFrequency must have one of the following values in this context: 'Custom', '1 Day', '1 Week', ' Fortnightly', '4 Weekly', '1m', '2m', '3m' ,'Asian Tail' . Value = '<xsl:value-of select="fpml:swAveragingFrequency"/>'</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="not(fpml:swAveragingInOut='Out')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swAveragingInOut must be equal to 'Out' in this context. Value = '<xsl:value-of select="fpml:swAveragingInOut"/>'</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:swMarketDisruption = 'Modified Postponement' or fpml:swMarketDisruption= 'Omission' or fpml:swMarketDisruption= 'Postponement')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swMarketDisruption must be equal to 'Modified Postponement' or 'Omission' or 'Postponement' in this context. Value = '<xsl:value-of select="fpml:swMarketDisruption"/>' .</text>
</error>
</xsl:if>
<xsl:if test="fpml:swAveragingFrequency = 'Custom' and (not(fpml:swAveragingDateTimes/fpml:dateTime) and not(fpml:swAveragingObservationsShortForm/fpml:averagingObservation/fpml:dateTime)) ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Mandatory elements missing in this context. swAverageDateTimes or swAveragingObservationsShortForm must be provided if swAveragingFrequency is set to 'Custom'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swAveragingDateTimes">
<xsl:for-each select="fpml:swAveragingDateTimes/fpml:dateTime">
<xsl:if test=". = ''">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid DateTime. swAveragingDateTimes/dateTime must have a valid non empty value. Value = '<xsl:value-of select="."/>'.</text>
</error>
</xsl:if>
</xsl:for-each>
</xsl:if>
<xsl:if test="fpml:swAveragingObservationsShortForm">
<xsl:for-each select="fpml:swAveragingObservationsShortForm/fpml:averagingObservation/fpml:dateTime">
<xsl:if test=". = ''">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid DateTime.swAveragingObservationsShortForm/averagingObservation/dateTime must have a valid non empty value. Value = '<xsl:value-of select="."/>'.</text>
</error>
</xsl:if>
</xsl:for-each>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:futuresPriceValuation">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">futuresPriceValuation</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="."/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="($productType='Equity Share Option' and not ($mcType='EquityOptionAmericasPrivate' or $mcType='EquityOptionEuropePrivate' or $mcType='EquityOptionAEJPrivate' or $mcType='EquityOptionEMEAPrivate'))">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected futuresPriceValuation element encountered in this context when product type is 'Equity Share Option'.</text>
</error>
</xsl:if>
<xsl:if test="$productType='Equity Index Option' and not ($docsType='Equity Options (AEJ)' or $docsType='Equity Options (Americas)' or $docsType='Equity Options (Europe)' or $docsType='Equity Options (Japan)' or $docsType='Equity Options (EMEA)' or $docsType='Equity Options (Spread)')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected futuresPriceValuation element encountered in this context when product type is 'Equity Index Option'  and Docs Type is not 'Equity Options (AEJ)' or 'Equity Options (Americas)' or 'Equity Options (Europe)' or 'Equity Options (Japan)' or 'Equity Options (EMEA)'.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:swVarianceSwapParameters|fpml:swVolatilitySwapParameters">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
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
<xsl:apply-templates select="fpml:swEquityUnderlyer|fpml:swIndexUnderlyer">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="$productType = 'Share Varinace Swap' or $productType = 'Index Variance Swap'">
<xsl:if test="fpml:swSettlementCurrencyVegaNotionalAmount and (fpml:swSettlementCurrency = fpml:varianceAmount/fpml:currency)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swSettlementCurrencyVegaNotionalAmount encountered in this context where swSettlementCurrency is the same as varianceAmount/currency. A settlement currency vega notional is only allowed for trades settling cross currency.</text>
</error>
</xsl:if>
<xsl:choose>
<xsl:when test="not (fpml:swSettlementCurrencyVegaNotionalAmount) and not(fpml:swSettlementCurrency = fpml:varianceAmount/fpml:currency)">
<xsl:if test="fpml:varianceAmount/fpml:currency='AUD'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swSettlementCurrencyVegaNotionalAmount in this context when currency is AUD. If a normally deliverable currency is traded as non deliverable, swSettlementCurrencyVegaNotionalAmount is required.</text>
</error>
</xsl:if>
<xsl:if test="fpml:varianceAmount/fpml:currency='HKD'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swSettlementCurrencyVegaNotionalAmount in this context when currency is HKD. If a normally deliverable currency is traded as non deliverable, swSettlementCurrencyVegaNotionalAmount is required.</text>
</error>
</xsl:if>
<xsl:if test="fpml:varianceAmount/fpml:currency='NZD'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swSettlementCurrencyVegaNotionalAmount in this context when currency is NZD. If a normally deliverable currency is traded as non deliverable, swSettlementCurrencyVegaNotionalAmount is required.</text>
</error>
</xsl:if>
<xsl:if test="fpml:varianceAmount/fpml:currency='SGD'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swSettlementCurrencyVegaNotionalAmount in this context when currency is SGD. If a normally deliverable currency is traded as non deliverable, swSettlementCurrencyVegaNotionalAmount is required.</text>
</error>
</xsl:if>
</xsl:when>
</xsl:choose>
<xsl:if test="fpml:swVegaFxSpotRate and (fpml:swSettlementCurrency = fpml:varianceAmount/fpml:currency)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swVegaFxSpotRate encountered in this context where swSettlementCurrency is the same as varianceAmount/currency. A vega spot rate is only allowed for trades settling cross currency.</text>
</error>
</xsl:if>
<xsl:choose>
<xsl:when test="not (fpml:swVegaFxSpotRate) and not(fpml:swSettlementCurrency = fpml:varianceAmount/fpml:currency)">
<xsl:if test="fpml:varianceAmount/fpml:currency='AUD'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swVegaFxSpotRate in this context when currency is AUD. If a normally deliverable currency is traded as non deliverable, swVegaFxSpotRate is required.</text>
</error>
</xsl:if>
<xsl:if test="fpml:varianceAmount/fpml:currency='HKD'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swVegaFxSpotRate in this context when currency is HKD. If a normally deliverable currency is traded as non deliverable, swVegaFxSpotRate is required.</text>
</error>
</xsl:if>
<xsl:if test="fpml:varianceAmount/fpml:currency='NZD'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swVegaFxSpotRate in this context when currency is NZD. If a normally deliverable currency is traded as non deliverable, swVegaFxSpotRate is required.</text>
</error>
</xsl:if>
<xsl:if test="fpml:varianceAmount/fpml:currency='SGD'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swVegaFxSpotRate in this context when currency is SGD. If a normally deliverable currency is traded as non deliverable, swVegaFxSpotRate is required.</text>
</error>
</xsl:if>
</xsl:when>
</xsl:choose>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">vegaNotionalAmount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:vegaNotionalAmount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.01</xsl:with-param>
<xsl:with-param name="maxIncl">999999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="fpml:swSettlementCurrency = fpml:varianceAmount/fpml:currency and $docsType='Variance Swap (AEJ)'">
<xsl:choose>
<xsl:when test="fpml:varianceAmount/fpml:currency = 'AUD'"/>
<xsl:when test="fpml:varianceAmount/fpml:currency = 'HKD'"/>
<xsl:when test="fpml:varianceAmount/fpml:currency = 'NZD'"/>
<xsl:when test="fpml:varianceAmount/fpml:currency = 'SGD'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swSettlementCurrency must not be the same as varianceAmount/currency when Docs Type is 'Variance Swap (AEJ)' and varianceAmount/currency is a non-deliverable currency.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:choose>
<xsl:when test="$docsType='Variance Swap (Europe)'">
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
</xsl:when>
<xsl:when test="$docsType='Variance Swap (AEJ)' or $docsType='Variance Swap (Japan)' or $docsType='Variance Swap (Americas)'">
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
</xsl:when>
</xsl:choose>
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
<xsl:if test="fpml:varianceCap[.='true'] and not(fpml:unadjustedVarianceCap)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing unadjustedVarianceCap element when varianceCap is set to 'true'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:unadjustedVarianceCap">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">unadjustedVarianceCap</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:unadjustedVarianceCap"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.01</xsl:with-param>
<xsl:with-param name="maxIncl">9.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swTotalVarianceCap and not(fpml:varianceCap='true')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swTotalVarianceCap element encountered in this context. Element must be not present unless varianceCap is equal to 'true'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:varianceCap='true'">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swTotalVarianceCap</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swTotalVarianceCap"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.0000</xsl:with-param>
<xsl:with-param name="maxIncl">998001.0000</xsl:with-param>
<xsl:with-param name="maxDecs">4</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swTotalVolatilityCap and not(fpml:varianceCap='true')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swTotalVolatilityCap element encountered in this context. Element must be not present unless varianceCap is equal to 'true'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:varianceCap='true'">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swTotalVolatilityCap</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swTotalVolatilityCap"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.0001</xsl:with-param>
<xsl:with-param name="maxIncl">999.9999</xsl:with-param>
<xsl:with-param name="maxDecs">4</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
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
</xsl:if>
<xsl:if test="fpml:swSettlementCurrencyVegaNotionalAmount">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swSettlementCurrencyVegaNotionalAmount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swSettlementCurrencyVegaNotionalAmount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.01</xsl:with-param>
<xsl:with-param name="maxIncl">9999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swVegaFxSpotRate">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swVegaFxSpotRate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swVegaFxSpotRate"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.000001</xsl:with-param>
<xsl:with-param name="maxIncl">9999.999999</xsl:with-param>
<xsl:with-param name="maxDecs">6</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swObservationStartDate">
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">swObservationStartDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swObservationStartDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swValuationDate">
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">swValuationDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swValuationDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:futuresPriceValuation and ($productType = 'Share Variance Swap' or $productType = 'Equity Share Volatility Swap')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected futuresPriceValuation element encountered in this context when product type is 'Share Variance Swap' or 'Share Volatility Swap'.</text>
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
<xsl:if test="fpml:allDividends and ($productType = 'Index Variance Swap' or ($docsType='Variance Swap (Japan)' or $docsType='Variance Swap (Americas)'))">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected allDividends element encountered in this context when productType is 'Index Variance Swap' or Docs Type is 'Variance Swap (Japan)' or Docs Type is 'Variance Swap (Americas)'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:allDividends and ($productType = 'Equity Index Volatility Swap' or ($docsType='Volatility Swap (Japan)' or $docsType='Volatility Swap (Americas)'))">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected allDividends element encountered in this context when productType is 'Equity Index Volatility Swap' or Docs Type is 'Volatility Swap (Japan)' or Docs Type is 'Variance Swap (Americas)'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swExpectedNOverride">
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">swExpectedNOverride</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swExpectedNOverride"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swExpectedNOverride='true' and not(fpml:expectedN)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing expectedN element where swExpectedNOverride is set to 'true'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swSettlementCurrency">
<xsl:call-template name="isValidCurrency">
<xsl:with-param name="elementName">swSettlementCurrency</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swSettlementCurrency"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swCashSettlementPaymentDateOffset">
<xsl:call-template name="isValidPeriodMultiplier">
<xsl:with-param name="elementName">swCashSettlementPaymentDateOffset</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swCashSettlementPaymentDateOffset"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="$productType = 'Equity Share Volatility Swap' or $productType = 'Equity Index Volatility Swap'">
<xsl:if test="fpml:swInitialLevel">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">initialLevel</xsl:with-param>
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
<xsl:if test="fpml:swInitialLevelSource">
<xsl:call-template name="InitialLevelSource">
<xsl:with-param name="elementName">swInitialLevelSource</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swInitialLevelSource"/>
</xsl:with-param>
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
<xsl:if test="not(fpml:swVolatilityStrikePrice)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swVolatilityStrikePrice element in this context.</text>
</error>
</xsl:if>
<xsl:choose>
<xsl:when test="$docsType='Volatility Swap (Europe)'">
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
<xsl:when test="$docsType='Volatility Swap (AEJ)' or $docsType='Volatility Swap (Japan)' or $docsType='Volatility Swap (Americas)'">
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
<xsl:if test="(fpml:swSettlementCurrencyVegaNotionalAmount or fpml:swVegaFxSpotRate) and not ($docsType='Volatility Swap (AEJ)')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swSettlementCurrencyVegaNotionalAmount or swVegaFxSpotRate is present when Docs Type is not Volatility Swap (AEJ).</text>
</error>
</xsl:if>
<xsl:if test="fpml:swVolatilityCap[.='true'] and not(fpml:swVolatilityCapFactor)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swVolatilityCapFactor element when swVolatilityCap is set to 'true'.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:swEquitySwapParameters">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="fpml:bulletIndicator = 'true' and not(fpml:scheduleDates/fpml:parameterDetails/fpml:interestLegDriven = 'true') and not(fpml:scheduleDates/fpml:schedulingMethod = 'ListDateEntry')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** If bulletIndicator is 'true', interestLegDriven must be 'true'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:bulletIndicator = 'true' and fpml:scheduleDates/fpml:schedulingMethod = 'ListDateEntry'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** bulletIndicator must not be 'true' for 'ListDateEntry' Scheduling Method.</text>
</error>
</xsl:if>
<xsl:if test="fpml:bulletIndicator">
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">bulletIndicator</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:bulletIndicator"/>
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
<xsl:apply-templates select="fpml:swEquityUnderlyer|fpml:swIndexUnderlyer">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:deltaCrossShortForm">
<xsl:apply-templates select="fpml:deltaCrossShortForm">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
<xsl:if test="fpml:synthetic/fpml:swFullyFunded and $docsSubType != 'Private' and ($productType = 'Equity Share Swap' or $productType = 'Equity Index Swap' or $productType = 'Equity Basket Swap')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected synthetic/swFullyFunded element encountered in this context. Element must be not present unless docs sub-type is 'Private'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:synthetic/fpml:swSpreadDetails and $docsSubType != 'Private' and ($productType = 'Equity Share Swap' or $productType = 'Equity Index Swap' or $productType = 'Equity Basket Swap')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected synthetic/swSpreadDetails element encountered in this context. Element must be not present unless docs sub-type is 'Private'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:synthetic/fpml:swFullyFunded and fpml:synthetic/fpml:swSpreadDetails">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** synthetic/swFullyFunded and synthetic/swSpreadDetails must not co-exist.</text>
</error>
</xsl:if>
<xsl:if test="fpml:synthetic/fpml:swFullyFunded ">
<xsl:if test="not(fpml:synthetic/fpml:swFullyFunded/fpml:currency = fpml:settlementCurrency)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** synthetic/swFullyFunded/currency must be the same as the settlement currency.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:synthetic/fpml:swFullyFunded">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">synthetic/swFullyFunded/amount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:synthetic/fpml:swFullyFunded/fpml:amount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">999999999999.999</xsl:with-param>
<xsl:with-param name="maxDecs">3</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:synthetic/fpml:swFullyFunded/fpml:fixedRate">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">synthetic/swFullyFunded/fixedRate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:synthetic/fpml:swFullyFunded/fpml:fixedRate"/>
</xsl:with-param>
<xsl:with-param name="minIncl">-999.999</xsl:with-param>
<xsl:with-param name="maxIncl">999.999</xsl:with-param>
<xsl:with-param name="maxDecs">3</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:dayCountFraction">
<xsl:choose>
<xsl:when test="fpml:dayCountFraction = 'ACT/ACT.ICMA'"/>
<xsl:when test="fpml:dayCountFraction = 'ACT/365.FIXED'"/>
<xsl:when test="fpml:dayCountFraction = 'ACT/ACT.ISDA'"/>
<xsl:when test="fpml:dayCountFraction = 'ACT/360'"/>
<xsl:when test="fpml:dayCountFraction = '30/360'"/>
<xsl:when test="fpml:dayCountFraction = '30E/360'"/>
<xsl:when test="fpml:dayCountFraction = '30E/360.ISDA'"/>
<xsl:when test="fpml:dayCountFraction = 'ACT/ACT.ISMA'"/>
<xsl:when test="fpml:dayCountFraction = 'ACT/ACT.AFB'"/>
<xsl:when test="fpml:dayCountFraction = 'BUS/252' and fpml:notionalAmount/fpml:currency = 'BRL'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid value for dayCountFraction'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="fpml:synthetic/fpml:swSpreadDetails and not (fpml:synthetic/fpml:swSpreadDetails/fpml:swSpreadIn or fpml:synthetic/fpml:swSpreadDetails/fpml:swSpreadOut)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** One of swSpreadIn, swSpreadOut is mandatory when synthetic/swSpreadDetails is present.</text>
</error>
</xsl:if>
<xsl:if test="fpml:synthetic/fpml:swSpreadDetails/fpml:swSpreadIn">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">synthetic/swSpreadDetails/swSpreadIn</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:synthetic/fpml:swSpreadDetails/fpml:swSpreadIn"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">0.0999999</xsl:with-param>
<xsl:with-param name="maxDecs">7</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:synthetic/fpml:swSpreadDetails/fpml:swSpreadOut">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">synthetic/swSpreadDetails/swSpreadOut</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:synthetic/fpml:swSpreadDetails/fpml:swSpreadOut"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">0.0999999</xsl:with-param>
<xsl:with-param name="maxDecs">7</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:scheduleDates/fpml:parameterDetails/fpml:interestLegDriven">
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">scheduleDates/parameterDetails/interestLegDriven</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:scheduleDates/fpml:parameterDetails/fpml:interestLegDriven"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:scheduleDates/fpml:listedDates and not(fpml:scheduleDates/fpml:schedulingMethod = 'ListDateEntry')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected scheduleDates/listedDates element encountered in this context. Schedule dates can be passed explicitly only if scheduleDates/schedulingMethod has a value of 'ListDateEntry' </text>
</error>
</xsl:if>
<xsl:if test="fpml:scheduleDates/fpml:listedDates/fpml:swValuationDatesInterim">
<xsl:for-each select="fpml:scheduleDates/fpml:listedDates/fpml:swValuationDatesInterim/fpml:swUnadjustedDate">
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">scheduleDates/listedDates/swValuationDatesInterim</xsl:with-param>
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
<xsl:if test="fpml:scheduleDates/fpml:listedDates/fpml:swInterestLegPaymentDates">
<xsl:for-each select="fpml:scheduleDates/fpml:listedDates/fpml:swInterestLegPaymentDates/fpml:swUnadjustedDate">
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">scheduleDates/listedDates/swInterestLegPaymentDates</xsl:with-param>
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
<xsl:if test="fpml:scheduleDates/fpml:listedDates/fpml:swEquityLegPaymentDates">
<xsl:for-each select="fpml:scheduleDates/fpml:listedDates/fpml:swEquityLegPaymentDates/fpml:swUnadjustedDate">
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">scheduleDates/listedDates/swEquityLegPaymentDates</xsl:with-param>
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
<xsl:if test="fpml:scheduleDates/fpml:listedDates/fpml:swCompoundingDates">
<xsl:for-each select="fpml:scheduleDates/fpml:listedDates/fpml:swCompoundingDates/fpml:swUnadjustedDate">
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">scheduleDates/listedDates/swCompoundingDates</xsl:with-param>
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
<xsl:variable name="optionalEarlyTerminationFieldApplicable">
<xsl:choose>
<xsl:when test="$mcType = 'EmergingEquitySwapIndustry' ">true</xsl:when>
<xsl:when test="$mcType = 'EmergingEquitySwapLATAM' ">true</xsl:when>
<xsl:when test="$mcType = 'EmergingEquitySwapEMEA' ">true</xsl:when>
<xsl:when test="$mcType = 'EquitySwapAEJPrivate' ">true</xsl:when>
<xsl:when test="$mcType = 'EquitySwapAmericasPrivate' ">true</xsl:when>
<xsl:when test="$mcType = 'EquitySwapEuropePrivate' ">true</xsl:when>
<xsl:when test="$mcType = 'EquitySwapGlobalPrivate' ">true</xsl:when>
<xsl:when test="$mcType = 'EquitySwapPanAsiaPrivate' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2004EquityAmericasInterdealer' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2005EquitySwapAsiaExcludingJapanInterdealer' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2007EquityEuropean' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2007EquityFinanceSwapEuropean' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2008EquityFinanceSwapAsiaExcludingJapan' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2009EquityEuropeanInterdealer'">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2009EquitySwapAmericas' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2009EquitySwapPanAsia' ">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:if test="fpml:optionalEarlyTermination/fpml:optionalEarlyTerminationApplicability and $optionalEarlyTerminationFieldApplicable = 'false' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected optionalEarlyTermination/optionalEarlyTerminationApplicability element encountered in this context.</text>
</error>
</xsl:if>
<xsl:variable name="optionalEarlyTerminationDataApplicable">
<xsl:choose>
<xsl:when test="$mcType = 'ISDA2008EquityFinanceSwapAsiaExcludingJapan' ">
<value-of select="not(fpml:optionalEarlyTermination/fpml:optionalEarlyTerminationApplicability='false') and ($productType = 'Equity Share Swap' or $productType = 'Equity Basket Swap')"/>
</xsl:when>
<xsl:otherwise>
<value-of select="$optionalEarlyTerminationFieldApplicable and not(fpml:optionalEarlyTermination/fpml:optionalEarlyTerminationApplicability='false')"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:if test="fpml:optionalEarlyTermination/fpml:optionalEarlyTerminationDate and $optionalEarlyTerminationDataApplicable = 'false' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected optionalEarlyTermination/optionalEarlyTerminationDate element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:optionalEarlyTermination/fpml:earlyTerminationElectingParty and $optionalEarlyTerminationDataApplicable = 'false'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected optionalEarlyTermination/earlyTerminationElectingParty element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:optionalEarlyTermination/fpml:earlyTerminationElectingPartyMethod and $optionalEarlyTerminationDataApplicable = 'false'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected optionalEarlyTermination/earlyTerminationElectingPartyMethod element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:optionalEarlyTermination/fpml:earlyTerminationElectingParty and $optionalEarlyTerminationDataApplicable = 'true' ">
<xsl:if test="fpml:optionalEarlyTermination/fpml:earlyTerminationElectingParty[1]/@href = fpml:optionalEarlyTermination/fpml:earlyTerminationElectingParty[2]/@href">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** optionalEarlyTermination/earlyTerminationElectingParty[1]/@href and optionalEarlyTermination/earlyTerminationElectingParty[2]/@href values must not be the same.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:bulletCompoundingSpread and not($mcType='EquitySwapAmericasPrivate' or $mcType='EquitySwapAEJPrivate' or $mcType='EquitySwapEuropePrivate' or $mcType='EquitySwapGlobalPrivate')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected bulletCompoundingSpread element encountered in this context. bulletCompoundingSpread should only be set for MC types EquitySwapAmericasPrivate, EquitySwapAEJPrivate, EquitySwapEuropePrivate or EquitySwapGlobalPrivate.</text>
</error>
</xsl:if>
<xsl:if test="fpml:bulletCompoundingSpread">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">bulletCompoundingSpread</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:bulletCompoundingSpread"/>
</xsl:with-param>
<xsl:with-param name="minIncl">-9.9999999</xsl:with-param>
<xsl:with-param name="maxIncl">9.9999999</xsl:with-param>
<xsl:with-param name="maxDecs">7</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swInitialPrice/fpml:initialPrice/fpml:amount and ($docsType='Equity Swap (Europe)' or $docsType='Equity Swap (Americas)') ">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swInitialPrice/initialPrice/amount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swInitialPrice/fpml:initialPrice/fpml:amount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.000001</xsl:with-param>
<xsl:with-param name="maxIncl">99999.999999</xsl:with-param>
<xsl:with-param name="maxDecs">6</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="$docsType='Equity Swap (AEJ)' ">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swInitialPrice/initialPrice/amount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swInitialPrice/fpml:initialPrice/fpml:amount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.000001</xsl:with-param>
<xsl:with-param name="maxIncl">9999999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">6</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="$mcType='EquitySwapGlobalPrivate ' ">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swInitialPrice/initialPrice/amount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swInitialPrice/fpml:initialPrice/fpml:amount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.000001</xsl:with-param>
<xsl:with-param name="maxIncl">999999999.999999</xsl:with-param>
<xsl:with-param name="maxDecs">6</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
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
<xsl:if test="fpml:swInitialPrice/fpml:initialPriceReference/fpml:amount">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swInitialPrice/initialPriceReference/amount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swInitialPrice/fpml:initialPriceReference/fpml:amount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.000001</xsl:with-param>
<xsl:with-param name="maxIncl">9999999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">6</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swInitialPrice/fpml:FxRate">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swInitialPrice/FxRate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swInitialPrice/fpml:FxRate"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.000001</xsl:with-param>
<xsl:with-param name="maxIncl">99999.999999</xsl:with-param>
<xsl:with-param name="maxDecs">6</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="$docsType='Equity Swap (Europe)'">
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
<xsl:if test="$docsType='Equity Swap (AEJ)' or ($docsType='Equity Swap (Americas)' and $productType = 'Equity Index Swap')">
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
<xsl:if test="$mcType = 'EquitySwapGlobalPrivate' ">
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
<xsl:if test="fpml:notionalAmount">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">notionalAmount/amount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:notionalAmount/fpml:amount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">9999999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:designatedMaturity">
<xsl:call-template name="isValidPeriodMultiplier">
<xsl:with-param name="elementName">designatedMaturity/periodMultiplier</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:designatedMaturity/fpml:periodMultiplier"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="isValidPeriod">
<xsl:with-param name="elementName">designatedMaturity/period</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:designatedMaturity/fpml:period"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:fixedRatePercentage">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">fixedRatePercentage</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:fixedRatePercentage"/>
</xsl:with-param>
<xsl:with-param name="minIncl">-9.99999999</xsl:with-param>
<xsl:with-param name="maxIncl">9.99999999</xsl:with-param>
<xsl:with-param name="maxDecs">8</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:spreadOverFloating">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">spreadOverFloating</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:spreadOverFloating"/>
</xsl:with-param>
<xsl:with-param name="minIncl">-0.9999999</xsl:with-param>
<xsl:with-param name="maxIncl">0.9999999</xsl:with-param>
<xsl:with-param name="maxDecs">7</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
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
<xsl:if test="fpml:futuresPriceValuation and ($productType = 'Equity Share Swap' or $productType = 'Equity Basket Swap' or $mcType='ISDA2008EquityFinanceSwapAsiaExcludingJapan')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected futuresPriceValuation element encountered in this context when product type is 'Equity Share Swap'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:futuresPriceValuation">
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
</xsl:if>
<xsl:if test="fpml:finalPriceElection and not($docsType='Equity Swap (Europe)' or $docsType='Equity Swap (Americas)' or $docsType='Equity Swap (Pan Asia)' or $mcType='EquitySwapAEJPrivate' or $mcType='ISDA2008EquityFinanceSwapAsiaExcludingJapan' or $mcType='ISDA2005EquitySwapAsiaExcludingJapanInterdealer')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected finalPriceElection element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="$productType= 'Equity Index Swap'">
<xsl:if test="fpml:finalPriceElection and $mcType='ISDA2009EquitySwapAmericas'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected finalPriceElection encountered in this context. Cannot be supplied with the 2009 MCA for Index Swaps.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$productType= 'Equity Index Swap' or $productType= 'Equity Share Swap' or $productType= 'Equity Basket Swap'">
<xsl:if test="not(fpml:finalPriceElection) and $mcType='EquitySwapAEJPrivate'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing finalPriceElection in this context, It is expected when mcType is EquitySwapAEJPrivate.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$productType= 'Equity Share Swap' or $productType= 'Equity Basket Swap'">
<xsl:if test="fpml:finalPriceElection and $mcType='ISDA2009EquitySwapAmericas'">
<xsl:if test="not(fpml:finalPriceElection = 'VWAP' or fpml:finalPriceElection = 'Close')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** For ISDA2009EquitySwapAmericas, finalPriceElection element should have value of VWAP or Close. Value = '<xsl:value-of select="fpml:finalPriceElection"/>'.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:finalPriceElection">
<xsl:if test="not(fpml:finalPriceElection = 'HedgeExecution' or fpml:finalPriceElection = 'VWAP' or fpml:finalPriceElection = 'Close' or fpml:finalPriceElection = 'TBD' or fpml:finalPriceElection = 'AsSpecifiedInMasterConfirmation') ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Empty or invalid finalPriceElection element. Value = '<xsl:value-of select="fpml:finalPriceElection"/>'.</text>
</error>
</xsl:if>
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
<xsl:apply-templates select="fpml:scheduleDates/fpml:parameterDetails/fpml:valuationFrequency">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">scheduleDates/valuationStartDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:scheduleDates/fpml:valuationStartDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">scheduleDates/finalValuationDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:scheduleDates/fpml:finalValuationDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:apply-templates select="fpml:scheduleDates/fpml:parameterDetails/fpml:paymentFrequency">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:paymentBusinessDayConvention">
<xsl:if test="not(fpml:scheduleDates/fpml:parameterDetails/fpml:interestLegDriven = 'true') and not(fpml:paymentBusinessDayConvention = 'FOLLOWING') and not(fpml:scheduleDates/fpml:schedulingMethod = 'ListDateEntry')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** paymentBusinessDayConvention must contain a value of 'FOLLOWING' if the scheduling is valuation driven and scheduling method is not List Date Entry driven. Value = '<xsl:value-of select="fpml:paymentBusinessDayConvention"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:paymentBusinessDayConvention">
<xsl:call-template name="isValidBusinessDayConvention">
<xsl:with-param name="elementName">paymentBusinessDayConvention</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:paymentBusinessDayConvention"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:scheduleDates/fpml:paymentEffectiveDate">
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">scheduleDates/paymentEffectiveDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:scheduleDates/fpml:paymentEffectiveDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:scheduleDates/fpml:paymentTerminationDate">
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">scheduleDates/paymentTerminationDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:scheduleDates/fpml:paymentTerminationDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="not(fpml:return/fpml:returnType = 'Total')">
<xsl:if test="fpml:return/fpml:dividends/fpml:dividendPaymentDate">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected return/dividends/dividendPaymentDate element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:return/fpml:dividends/fpml:dividendPaymentOffset">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected return/dividends/dividendPaymentOffset element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:return/fpml:dividends/fpml:dividendPercentage">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected return/dividends/dividendPercentage element encountered in this context.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:return/fpml:dividends/fpml:dividendPaymentOffset">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">return/dividends/dividendPaymentOffset</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:return/fpml:dividends/fpml:dividendPaymentOffset"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">999</xsl:with-param>
<xsl:with-param name="maxDecs">0</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:return/fpml:dividends/fpml:dividendPercentage">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">return/dividends/dividendPercentage</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:return/fpml:dividends/fpml:dividendPercentage"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">9.9999999</xsl:with-param>
<xsl:with-param name="maxDecs">7</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:variable name="declaredCashDividendPercentageFieldApplicable">
<xsl:choose>
<xsl:when test="$mcType = 'ISDA2009EquitySwapAmericas' and $productType = 'Equity Index Swap' ">true</xsl:when>
<xsl:when test="$mcType = 'EquitySwapAmericasPrivate' and $productType = 'Equity Index Swap' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2009EquityEuropeanInterdealer' and $mcAnnexType = 'ISDA2009EquityEuropeanInterdealerAnnexSS' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2009EquityEuropeanInterdealer' and $mcAnnexType = 'ISDA2010FairValueShareSwapEuropeanInterdealer' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2009EquityEuropeanInterdealer' and $mcAnnexType = 'ISDA2009IndexSwapEuropeanInterdealer' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2007EquityEuropean' and $mcAnnexType = 'ISDA2009EquityEuropeanIS' ">true</xsl:when>
<xsl:when test="$mcType = 'EquitySwapGlobalPrivate' ">true</xsl:when>
<xsl:when test="$mcType = 'EmergingEquitySwapIndustry' ">true</xsl:when>
<xsl:when test="$mcType = 'EmergingEquitySwapLATAM' and ($productType = 'Equity Index Swap' or $productType = 'Equity Share Swap')">true</xsl:when>
<xsl:when test="$mcType = 'EmergingEquitySwapEMEA' and ($productType = 'Equity Index Swap' or $productType = 'Equity Share Swap')">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:if test="fpml:return/fpml:dividends/fpml:declaredCashDividendPercentage and $declaredCashDividendPercentageFieldApplicable = 'false' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected return/dividends/declaredCashDividendPercentage element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:return/fpml:dividends/fpml:declaredCashDividendPercentage and $declaredCashDividendPercentageFieldApplicable = 'true' ">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">return/dividends/declaredCashDividendPercentage</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:return/fpml:dividends/fpml:declaredCashDividendPercentage"/>
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
<xsl:when test="$mcType = 'ISDA2009EquitySwapAmericas' and $productType = 'Equity Index Swap' ">true</xsl:when>
<xsl:when test="$mcType = 'EquitySwapAmericasPrivate' and $productType = 'Equity Index Swap' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2009EquityEuropeanInterdealer' and $mcAnnexType = 'ISDA2009EquityEuropeanInterdealerAnnexSS' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2009EquityEuropeanInterdealer' and $mcAnnexType = 'ISDA2010FairValueShareSwapEuropeanInterdealer' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2009EquityEuropeanInterdealer' and $mcAnnexType = 'ISDA2009IndexSwapEuropeanInterdealer' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2007EquityEuropean' and $mcAnnexType = 'ISDA2009EquityEuropeanIS' ">true</xsl:when>
<xsl:when test="$mcType = 'EquitySwapGlobalPrivate' ">true</xsl:when>
<xsl:when test="$mcType = 'EmergingEquitySwapIndustry' ">true</xsl:when>
<xsl:when test="$mcType = 'EmergingEquitySwapLATAM' and ($productType = 'Equity Index Swap' or $productType = 'Equity Share Swap')">true</xsl:when>
<xsl:when test="$mcType = 'EmergingEquitySwapEMEA' and ($productType = 'Equity Index Swap' or $productType = 'Equity Share Swap')">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:if test="fpml:return/fpml:dividends/fpml:declaredCashEquivalentDividendPercentage and $declaredCashEquivalentDividendPercentageFieldApplicable = 'false' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected return/dividends/declaredCashEquivalentDividendPercentage element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:return/fpml:dividends/fpml:declaredCashEquivalentDividendPercentage and $declaredCashEquivalentDividendPercentageFieldApplicable = 'true' ">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">return/dividends/declaredCashEquivalentDividendPercentage</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:return/fpml:dividends/fpml:declaredCashEquivalentDividendPercentage"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">9.9999999</xsl:with-param>
<xsl:with-param name="maxDecs">7</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:variable name="dividendSettlementCurrencyFieldApplicable">
<xsl:choose>
<xsl:when test="$mcType = 'EquitySwapAmericasPrivate' ">true</xsl:when>
<xsl:when test="$mcType = 'EmergingEquitySwapIndustry' ">true</xsl:when>
<xsl:when test="$mcType = 'EmergingEquitySwapLATAM' and ($productType = 'Equity Index Swap' or $productType = 'Equity Share Swap')">true</xsl:when>
<xsl:when test="$mcType = 'EmergingEquitySwapEMEA' and ($productType = 'Equity Index Swap' or $productType = 'Equity Share Swap')">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2009EquityEuropeanInterdealer' and $mcAnnexType = 'ISDA2009EquityEuropeanInterdealerAnnexSS' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2009EquityEuropeanInterdealer' and $mcAnnexType = 'ISDA2010FairValueShareSwapEuropeanInterdealer' ">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:if test="fpml:return/fpml:dividends/fpml:swDividendSettlementCurrencyDetermination and $dividendSettlementCurrencyFieldApplicable='false' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected return/dividends/swDividendSettlementCurrencyDetermination element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:return/fpml:dividends/fpml:swDividendSettlementCurrencyDetermination">
<xsl:if test="not(fpml:return/fpml:dividends/fpml:swDividendSettlementCurrencyDetermination = 'SettlementCurrency' or fpml:return/fpml:dividends/fpml:swDividendSettlementCurrencyDetermination = 'IssuerPaymentCurrency') ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected return/dividends/swDividendSettlementCurrencyDetermination element value. Valid values are SettlementCurrency and IssuerPaymentCurrency. Value = '<xsl:value-of select="fpml:return/fpml:dividends/fpml:swDividendSettlementCurrencyDetermination"/>'</text>
</error>
</xsl:if>
</xsl:if>
<xsl:variable name="nonCashDividendTreatmentFieldApplicable">
<xsl:choose>
<xsl:when test="$mcType = 'ISDA2009EquityEuropeanInterdealer' and $mcAnnexType = 'ISDA2009EquityEuropeanInterdealerAnnexSS' ">true</xsl:when>
<xsl:when test="$mcType = 'EmergingEquitySwapIndustry' ">true</xsl:when>
<xsl:when test="$mcType = 'EmergingEquitySwapLATAM' and ($productType = 'Equity Index Swap' or $productType = 'Equity Share Swap')">true</xsl:when>
<xsl:when test="$mcType = 'EmergingEquitySwapEMEA' and ($productType = 'Equity Index Swap' or $productType = 'Equity Share Swap')">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:if test="fpml:return/fpml:dividends/fpml:nonCashDividendTreatment and $nonCashDividendTreatmentFieldApplicable='false' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected return/dividends/nonCashDividendTreatment element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="$nonCashDividendTreatmentFieldApplicable='true' and not(fpml:return/fpml:dividends/fpml:nonCashDividendTreatment)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Element return/dividends/nonCashDividendTreatment expected in this context.</text>
</error>
</xsl:if>
<xsl:variable name="dividendCompositionFieldApplicable">
<xsl:choose>
<xsl:when test="$mcType = 'ISDA2009EquityEuropeanInterdealer' and $mcAnnexType = 'ISDA2009EquityEuropeanInterdealerAnnexSS' ">true</xsl:when>
<xsl:when test="$mcType = 'EmergingEquitySwapIndustry' ">true</xsl:when>
<xsl:when test="$mcType = 'EmergingEquitySwapLATAM' and ($productType = 'Equity Index Swap' or $productType = 'Equity Share Swap')">true</xsl:when>
<xsl:when test="$mcType = 'EmergingEquitySwapEMEA' and ($productType = 'Equity Index Swap' or $productType = 'Equity Share Swap')">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:if test="fpml:return/fpml:dividends/fpml:dividendComposition and $dividendCompositionFieldApplicable='false' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected return/dividends/dividendComposition element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="not (fpml:paymentHolidayCenter) and fpml:scheduleDates/fpml:schedulingMethod = 'ParameterDriven'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing paymentHolidayCenter element. Element must be present if schedulingMethod is ParameterDriven.</text>
</error>
</xsl:if>
<xsl:if test="fpml:paymentHolidayCenter">
<xsl:call-template name="isValidBusinessCenter">
<xsl:with-param name="elementName">paymentHolidayCenter</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:paymentHolidayCenter"/>
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
<xsl:apply-templates select="fpml:scheduleDates/fpml:parameterDetails/fpml:stubControl">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:variable name="linearInterpolationFieldApplicable">
<xsl:choose>
<xsl:when test="$mcType = 'ISDA2004EquityAmericasInterdealer' ">false</xsl:when>
<xsl:when test="$mcType = 'ISDA2009EquitySwapAmericas' ">true</xsl:when>
<xsl:when test="$mcType = 'EquitySwapAmericasPrivate' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2009EquityEuropeanInterdealer' and $mcAnnexType = 'ISDA2009EquityEuropeanInterdealerAnnexSS' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2009EquityEuropeanInterdealer' and $mcAnnexType = 'ISDA2010FairValueShareSwapEuropeanInterdealer' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2009EquityEuropeanInterdealer' and $mcAnnexType = 'ISDA2009IndexSwapEuropeanInterdealer' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2007EquityEuropean' and $mcAnnexType = 'ISDA2009EquityEuropeanIS' ">true</xsl:when>
<xsl:when test="$mcType = 'EquitySwapEuropePrivate' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2007EquityFinanceSwapEuropean' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2009EquitySwapPanAsia' ">true</xsl:when>
<xsl:when test="$mcType = 'EquitySwapPanAsiaPrivate' ">true</xsl:when>
<xsl:when test="$mcType = 'EquitySwapGlobalPrivate' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2005EquitySwapAsiaExcludingJapanInterdealer' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2008EquityFinanceSwapAsiaExcludingJapan' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2009EquityFinanceSwapAsiaExcludingJapan' ">true</xsl:when>
<xsl:when test="$mcType = 'EmergingEquitySwapIndustry' ">true</xsl:when>
<xsl:when test="$mcType = 'EmergingEquitySwapLATAM' and ($productType = 'Equity Index Swap' or $productType = 'Equity Share Swap')">true</xsl:when>
<xsl:when test="$mcType = 'EmergingEquitySwapEMEA' and ($productType = 'Equity Index Swap' or $productType = 'Equity Share Swap')">true</xsl:when>
<xsl:when test="$mcType = 'EquitySwapAEJPrivate' ">false</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:if test="fpml:linearInterpolation and $linearInterpolationFieldApplicable='false' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected linearInterpolation element encountered in this context.</text>
</error>
</xsl:if>
<xsl:variable name="compoundingMethodFieldApplicable">
<xsl:choose>
<xsl:when test="$mcType = 'ISDA2009EquityEuropeanInterdealer' and $mcAnnexType = 'ISDA2009IndexSwapEuropeanInterdealer' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2007EquityEuropean' and $mcAnnexType = 'ISDA2009EquityEuropeanIS' ">true</xsl:when>
<xsl:when test="$mcType = 'EquitySwapGlobalPrivate' ">true</xsl:when>
<xsl:when test="$mcType = 'EquitySwapEuropePrivate' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2009EquityEuropeanInterdealer' and $mcAnnexType = 'ISDA2010FairValueShareSwapEuropeanInterdealer' ">true</xsl:when>
<xsl:when test="$mcType = 'EmergingEquitySwapIndustry' and $productType = 'Equity Share Swap' ">true</xsl:when>
<xsl:when test="$mcType = 'EmergingEquitySwapLATAM' and ($productType = 'Equity Index Swap' or $productType = 'Equity Share Swap')">true</xsl:when>
<xsl:when test="$mcType = 'EmergingEquitySwapEMEA' and ($productType = 'Equity Index Swap' or $productType = 'Equity Share Swap')">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:if test="fpml:compoundingMethod and $compoundingMethodFieldApplicable='false' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected compoundingMethod element encountered in this context.</text>
</error>
</xsl:if>
<xsl:variable name="compoundingFrequencyFieldApplicable">
<xsl:choose>
<xsl:when test="$mcType = 'ISDA2009EquityEuropeanInterdealer' and $mcAnnexType = 'ISDA2009IndexSwapEuropeanInterdealer' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2007EquityEuropean' and $mcAnnexType = 'ISDA2009EquityEuropeanIS' ">true</xsl:when>
<xsl:when test="$mcType = 'EquitySwapGlobalPrivate' ">true</xsl:when>
<xsl:when test="$mcType = 'EquitySwapEuropePrivate' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2009EquityEuropeanInterdealer' and $mcAnnexType = 'ISDA2010FairValueShareSwapEuropeanInterdealer' ">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:if test="fpml:scheduleDates/fpml:parameterDetails/fpml:compoundingFrequency and $compoundingFrequencyFieldApplicable='false' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected scheduleDates/parameterDetails/compoundingFrequency element encountered in this context.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:scheduleDates/fpml:parameterDetails/fpml:compoundingFrequency">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="$productType = 'Equity Index Swap' and /fpml:SWDML/fpml:swShortFormTrade/fpml:swDocsType = 'ISDA2009EquitySwapAmericas'">
<xsl:if test="fpml:stockLoanRateIndicator = 'true' and not(fpml:additionalDisruptionEventIndicator = 'true') ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** stockLoanRateIndicator can be 'true' only if additionalDisruptionEventIndicator is 'true' in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:insolvencyFiling = 'true' and not(fpml:additionalDisruptionEventIndicator = 'true') ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** insolvencyFiling can be 'true' only if additionalDisruptionEventIndicator is 'true' in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:lossOfStockBorrow = 'true' and not(fpml:additionalDisruptionEventIndicator = 'true') ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** lossOfStockBorrow can be 'true' only if additionalDisruptionEventIndicator is 'true' in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:increasedCostOfStockBorrow = 'true' and not(fpml:additionalDisruptionEventIndicator = 'true') ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** increasedCostOfStockBorrow can be 'true' only if additionalDisruptionEventIndicator is 'true' in this context.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:variable name="breakFundingRecoveryFieldSFApplicable">
<xsl:choose>
<xsl:when test="$mcType = 'ISDA2009EquitySwapAmericas' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2004EquityAmericasInterdealer' ">true</xsl:when>
<xsl:when test="$mcType = 'EquitySwapGlobalPrivate' ">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:if test="fpml:breakFundingRecovery and $breakFundingRecoveryFieldSFApplicable = 'false' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected breakFundingRecovery element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:breakFundingRecovery = 'true' and not(fpml:optionalEarlyTermination/fpml:optionalEarlyTerminationApplicability = 'true') and $breakFundingRecoveryFieldSFApplicable = 'true'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** breakFundingRecovery must be equal to false if optionalEarlyTermination is not applicable.</text>
</error>
</xsl:if>
<xsl:if test="fpml:optionalEarlyTermination/fpml:breakFeeElection and not(fpml:optionalEarlyTermination/fpml:optionalEarlyTerminationApplicability = 'true') ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected optionalEarlyTermination/breakFeeElection element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:optionalEarlyTermination/fpml:breakFeeRate and not(fpml:optionalEarlyTermination/fpml:breakFeeElection = 'FlatFee' or fpml:optionalEarlyTermination/fpml:breakFeeElection = 'AmortizedFee' or fpml:optionalEarlyTermination/fpml:breakFeeElection = 'FlatFeeAndFundingFee' or fpml:optionalEarlyTermination/fpml:breakFeeElection = 'AmortizedFeeAndFundingFee') ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** When optionalEarlyTermination/breakFeeRate element is specified, optionalEarlyTermination/breakFeeElection must have one of the following values: 'FlatFee', 'AmortizedFee', 'FlatFeeAndFundingFee', or 'AmortizedFeeAndFundingFee'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:optionalEarlyTermination/fpml:breakFeeRate and $mcType = 'EquitySwapGlobalPrivate' and not(fpml:optionalEarlyTermination/fpml:optionalEarlyTerminationApplicability = 'true') ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected optionalEarlyTermination/breakFeeRate element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:optionalEarlyTermination/fpml:breakFeeRate">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">optionalEarlyTermination/breakFeeRate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:optionalEarlyTermination/fpml:breakFeeRate"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">9.99999999</xsl:with-param>
<xsl:with-param name="maxDecs">8</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:optionalEarlyTermination/fpml:finalPriceFee and not(fpml:optionalEarlyTermination/fpml:optionalEarlyTerminationApplicability = 'true') ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected optionalEarlyTermination/finalPriceFee element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:optionalEarlyTermination/fpml:finalPriceFee">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">optionalEarlyTermination/finalPriceFee</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:optionalEarlyTermination/fpml:finalPriceFee"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">9.99999999</xsl:with-param>
<xsl:with-param name="maxDecs">8</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:variable name="multipleExchangeIndexAnnexFallbackFieldApplicable">
<xsl:choose>
<xsl:when test="$mcType = 'ISDA2009EquityEuropeanInterdealer' and $mcAnnexType = 'ISDA2009IndexSwapEuropeanInterdealer' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2007EquityEuropean' and $mcAnnexType = 'ISDA2009EquityEuropeanIS' ">true</xsl:when>
<xsl:when test="$mcType= 'EquitySwapGlobalPrivate' ">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="componentSecurityIndexAnnexFallbackFieldApplicable">
<xsl:choose>
<xsl:when test="$mcType = 'ISDA2009EquityEuropeanInterdealer' and $mcAnnexType = 'ISDA2009IndexSwapEuropeanInterdealer' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2007EquityEuropean' and $mcAnnexType = 'ISDA2009EquityEuropeanIS' ">true</xsl:when>
<xsl:when test="$mcType = 'EquitySwapGlobalPrivate' ">true</xsl:when>
<xsl:when test="$mcType = 'EmergingEquitySwapIndustry' and $productType = 'Equity Index Swap'">true</xsl:when>
<xsl:when test="$mcType = 'EmergingEquitySwapLATAM' and ($productType = 'Equity Index Swap' or $productType = 'Equity Share Swap')">true</xsl:when>
<xsl:when test="$mcType = 'EmergingEquitySwapEMEA' and ($productType = 'Equity Index Swap' or $productType = 'Equity Share Swap')">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:if test="fpml:componentSecurityIndexAnnexFallback and $componentSecurityIndexAnnexFallbackFieldApplicable = 'false' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected componentSecurityIndexAnnexFallback element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:componentSecurityIndexAnnexFallback = 'true' and fpml:multipleExchangeIndexAnnexFallback = 'true'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** componentSecurityIndexAnnexFallback and multipleExchangeIndexAnnexFallback are mutually exclusive.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:swIndependentAmount">
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
<xsl:if test="fpml:paymentAmount/fpml:amount">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">amount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:paymentAmount/fpml:amount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.01</xsl:with-param>
<xsl:with-param name="maxIncl">999999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:paymentAmount/swIAPercentage">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swIAPercentage</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:paymentAmount/swIAPercentage"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">999.999999</xsl:with-param>
<xsl:with-param name="maxDecs">6</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:call-template name="isValidCurrency">
<xsl:with-param name="elementName">currency</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:paymentAmount/fpml:currency"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:template>
<xsl:template match="fpml:swEquityAmericanExercise">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="($productType='Equity Share Option' or $productType='Equity Index Option') and fpml:swEquityExpirationTimeMethod">
<xsl:call-template name="isValidEquityExpirationTimeType">
<xsl:with-param name="elementName">swEquityExpirationTimeMethod</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swEquityExpirationTimeMethod"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
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
<xsl:variable name="swEquityExpirationTimeMethodFieldApplicable">
<xsl:choose>
<xsl:when test="$mcType = 'ISDA2009EquityAmericas' and $mcAnnexType = 'ISDA2009IndexShareOptionAmericas' ">true</xsl:when>
<xsl:when test="$mcType = 'EquityOptionAmericasPrivate' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2008EquityAmericas' ">true</xsl:when>
<xsl:when test="$mcType = '2004EquityEuropeanInterdealer' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2007EquityEuropean' ">true</xsl:when>
<xsl:when test="$mcType = 'EquityOptionEuropePrivate' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2004EquityAmericasInterdealer' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2008EquityJapanese' or $mcType = 'ISDA2005EquityJapaneseInterdealer' ">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:if test="fpml:swEquityExpirationTimeMethod and $swEquityExpirationTimeMethodFieldApplicable = 'false' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swEquityExpirationTimeMethod element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swEquityExpirationTime">
<xsl:call-template name="isValidHourMinuteTime">
<xsl:with-param name="elementName">swEquityExpirationTime</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swEquityExpirationTime"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:variable name="swLatestExerciseTimeMethodFieldApplicable">
<xsl:choose>
<xsl:when test="$mcType = 'ISDA2009EquityAmericas' and $mcAnnexType = 'ISDA2009IndexShareOptionAmericas' ">true</xsl:when>
<xsl:when test="$mcType = 'EquityOptionAmericasPrivate' ">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:if test="fpml:swLatestExerciseTimeMethod and $swLatestExerciseTimeMethodFieldApplicable = 'false' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swLatestExerciseTimeMethod element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swLatestExerciseTimeMethod">
<xsl:choose>
<xsl:when test="fpml:swLatestExerciseTimeMethod = 'AsSpecifiedInMasterConfirmation' "/>
<xsl:when test="fpml:swLatestExerciseTimeMethod = 'SpecificTime' "/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swLatestExerciseTimeMethod element value in this context. Value = '<xsl:value-of select="fpml:swLatestExerciseTimeMethod"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="fpml:swLatestExerciseTime">
<xsl:call-template name="isValidHourMinuteTime">
<xsl:with-param name="elementName">swLatestExerciseTime</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swLatestExerciseTime"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:variable name="swCommencementDateFieldApplicable">
<xsl:choose>
<xsl:when test="$mcType = 'ISDA2009EquityAmericas' and $mcAnnexType = 'ISDA2009IndexShareOptionAmericas' ">true</xsl:when>
<xsl:when test="$mcType = 'EquityOptionAmericasPrivate' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2010EquityEMEAInterdealer' ">true</xsl:when>
<xsl:when test="$mcType = 'EquityOptionEMEAPrivate' ">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:if test="fpml:swCommencementDate and $swCommencementDateFieldApplicable = 'false' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swCommencementDate element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swCommencementDate">
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">swCommencementDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swCommencementDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:apply-templates select="fpml:equityMultipleExercise">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:swEquityEuropeanExercise">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="($productType='Equity Share Option' or $productType='Equity Index Option') and fpml:swEquityExpirationTimeMethod">
<xsl:call-template name="isValidEquityExpirationTimeType">
<xsl:with-param name="elementName">swEquityExpirationTimeMethod</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swEquityExpirationTimeMethod"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
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
<xsl:variable name="swEquityExpirationTimeMethodFieldApplicable">
<xsl:choose>
<xsl:when test="$mcType = 'ISDA2009EquityAmericas' and $mcAnnexType = 'ISDA2009IndexShareOptionAmericas' ">true</xsl:when>
<xsl:when test="$mcType = 'EquityOptionAmericasPrivate' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2008EquityAmericas' ">true</xsl:when>
<xsl:when test="$mcType = '2004EquityEuropeanInterdealer' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2007EquityEuropean' ">true</xsl:when>
<xsl:when test="$mcType = 'EquityOptionEuropePrivate' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2004EquityAmericasInterdealer' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2008EquityJapanese' or $mcType = 'ISDA2005EquityJapaneseInterdealer' ">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:if test="fpml:swEquityExpirationTimeMethod and $swEquityExpirationTimeMethodFieldApplicable = 'false' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swEquityExpirationTimeMethod element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swEquityExpirationTime">
<xsl:call-template name="isValidHourMinuteTime">
<xsl:with-param name="elementName">swEquityExpirationTime</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swEquityExpirationTime"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:swEquityUnderlyer|fpml:swIndexUnderlyer">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="fpml:swRelatedExchangeId and not (fpml:swInstrumentId = '.NSEI') and  ($docsType='Variance Swap (AEJ)' or $docsType='Equity Swap (AEJ)' )">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected  swRelatedExchangeId encountered in this context when Docs Type is 'Equity Options (AEJ)' or 'Variance Swap (AEJ)' or 'Equity Swap (AEJ)' and swInstrumentId is not equal to '.NSEI'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swRelatedExchangeId and $docsType='Variance Swap (Americas)'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected  swRelatedExchangeId encountered in this context when Docs Type is 'Variance Swap (Americas)'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:exchangeLookAlike and ($productType='Equity Share Option' or $productType='Equity Share Option Strategy' or $productType='Equity Index Option' or $productType='Equity Index Option Strategy') and ($docsType='Equity Options (Europe)' or $docsType ='Equity Options (Americas)' or $docsType='Equity Options (EMEA)')">
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
<xsl:if test="($productType='Equity Share Option'  or $productType='Equity Share Option Strategy') and fpml:exchangeLookAlike and $docsType!='Equity Options (Europe)' and $docsType!='Equity Options (Americas)' and $docsType!='Equity Options (EMEA)' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected exchangeLookAlike element encountered in this context when product type is 'Equity Share Option' or 'Equity Share Option Strategy' and Docs Type is not 'Equity Options (Europe)' or 'Equity Options (Americas)'  or 'Equity Options (EMEA)'.</text>
</error>
</xsl:if>
<xsl:if test="($productType='Equity Index Option' or $productType='Equity Index Option Strategy') and fpml:exchangeLookAlike and $docsType!='Equity Options (Americas)' and $docsType!='Equity Options (EMEA)' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected exchangeLookAlike element encountered in this context when product type is 'Equity Index Option' or 'Equity Index Option Strategy' and Docs Type is not 'Equity Options (Americas)' or 'Equity Options (EMEA)'.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:swPremium">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:call-template name="isValidCurrency">
<xsl:with-param name="elementName">currency</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:paymentAmount/fpml:currency"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="$docsType!='Equity Options (Cliquet)' and $docsType!='Equity Options (Spread)'">
<xsl:call-template name="isValidCurrency">
<xsl:with-param name="elementName">currency</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:pricePerOption/fpml:currency"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="not(fpml:paymentAmount/fpml:currency = fpml:pricePerOption/fpml:currency) and $docsType!='Equity Options (Cliquet)' and $docsType!='Equity Options (Spread)'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The paymentAmount/currency and pricePerOption/currency must be equal.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:pricePerOption">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="($docsType='Equity Options (Europe)' or $docsType='Equity Options (AEJ)' or $docsType='Equity Options (Americas)' or $docsType='Equity Options (EMEA)')">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">amount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:paymentAmount/fpml:amount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.00</xsl:with-param>
<xsl:with-param name="maxIncl">9999999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="$docsType='Equity Options (Japan)'">
<xsl:call-template name="isValidIntegerNumber">
<xsl:with-param name="elementName">amount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:paymentAmount/fpml:amount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">901000000000000</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swPaymentDate">
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
</xsl:if>
</xsl:template>
<xsl:template match="fpml:swGiveUp">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
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
<text>*** swCustomerTransaction/swCustomer/@href does not reference a valid //FpML/trade/party/@id. Value = '<xsl:value-of select="$hrefC"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not(//fpml:FpML/fpml:party[@id=$hrefCPB])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swCustomerTransaction/swPrimeBroker/@href does not reference a valid //FpML//party/@id. Value = '<xsl:value-of select="$hrefCPB"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not(//fpml:FpML/fpml:party[@id=$hrefD])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swInterDealerTransaction/swExecutingDealer/@href does not reference a valid //FpML/trade/party/@id. Value = '<xsl:value-of select="$hrefD"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not(//fpml:FpML/fpml:party[@id=$hrefDPB])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swInterDealerTransaction/swPrimeBroker/@href does not reference a valid //FpML/trade/party/@id. Value = '<xsl:value-of select="$hrefDPB"/>'.</text>
</error>
</xsl:if>
<xsl:if test="$isAllocatedTrade = 0">
<xsl:if test="$hrefDPB=$hrefCPB">
<xsl:if test="count(//fpml:FpML/fpml:party) &lt; 3">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of party child elements encountered. 3 expected.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$hrefDPB!=$hrefCPB">
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
<xsl:if test="$hrefDPB=$hrefCPB">
<xsl:if test="count(//fpml:FpML/fpml:party) &lt; 3">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of party child elements encountered. At least 3 expected.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$hrefDPB!=$hrefCPB">
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
<xsl:if test="$productType = 'Equity Share Option' or $productType = 'Equity Index Option' or $productType = 'Equity Share Option Strategy' or $productType = 'Equity Index Option Strategy' or $productType='Share Variance Swap' or $productType = 'Index Variance Swap'">
<xsl:if test="($hrefD != //fpml:FpML/fpml:trade/fpml:buyerPartyReference/@href) and ($hrefD != //fpml:FpML/fpml:trade/fpml:payerPartyReference/@href)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swInterDealerTransaction/swExecutingDealer/@href must be a buyer or seller if product type is 'Equity Share Option', 'Equity Index Option',  'Equity Share Option Strategy', 'Equity Index Option Strategy', 'Share Variance Swap' or 'Index Variance Swap'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$productType = 'Equity Share Swap' or $productType = 'Equity Index Swap' or $productType = 'Equity Basket Swap' or $productType='Share Dividend Swap' or $productType = 'Index Dividend Swap'">
<xsl:if test="($hrefC != //fpml:FpML/fpml:trade/fpml:payerPartyReference/@href) and ($hrefC != //fpml:FpML/fpml:trade/fpml:receiverPartyReference/@href)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swInterDealerTransaction/swExecutingDealer/@href must be a payer or receiver if product type is 'Equity Share Swap', 'Equity Index Swap', 'Share Dividend Swap' or 'Index Dividend Swap'.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:swStructuredTradeDetails">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
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
<xsl:if test="not(fpml:trade)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing trade element.</text>
</error>
</xsl:if>
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
<xsl:apply-templates select="fpml:tradeHeader">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="$productType='Equity Share Option' or $productType='Equity Index Option' or $productType='Equity Share Option Strategy' or $productType='Equity Index Option Strategy'">
<xsl:if test="not(fpml:equityOptionTransactionSupplement)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing equityOptionTransactionSupplement element. Element must be present if product type is 'Equity Share Option' or 'Equity Index Option' or 'Equity Index Option Strategy' or 'Equity Share Option Strategy'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$productType='Share Variance Swap' or $productType='Index Variance Swap' or $productType='Equity Share Swap' or $productType='Equity Index Swap' or $productType= 'Equity Basket Swap' ">
<xsl:if test="not(fpml:equitySwapTransactionSupplement)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing equitySwapTransactionSupplement element. Element must be present if product type is 'Share Variance Swap' or 'Index Variance Swap' or 'Equity Share Swap' or 'Equity Index Swap'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$productType='Equity Accumulator' or $productType='Equity Decumulator' ">
<xsl:variable name="settlementType">
<xsl:value-of select="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:swEquityAccumulatorForwardShort/fpml:swEquityExercise/fpml:swSettlementType"/>
</xsl:variable>
<xsl:if test="//fpml:swAccumulator/fpml:swPaymentDateOffset and $settlementType='Physical'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Payment Date Offset can't be provided as Settlement Type is 'Physical'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$productType='Equity Accumulator' or $productType='Equity Decumulator' ">
<xsl:if test="not(fpml:swEquityAccumulatorForwardShort)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swEquityAccumulatorForwardShort element. Element must be present if product type is 'Index Accumulator' or 'Equity Decumulator'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$productType='Equity Share Volatility Swap' or $productType='Equity Index Volatility Swap' ">
<xsl:if test="not(fpml:swVolatilitySwapTransactionSupplement)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swVolatilitySwapTransactionSupplement element. Element must be present if product type is 'Index Share Volatility Swap' or 'Equity Index Volatility Swap'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$productType='Share Dividend Swap' or $productType='Index Dividend Swap'">
<xsl:if test="not(fpml:dividendSwapTransactionSupplement)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing dividendSwapTransactionSupplement element. Element must be present if product type is 'Share Dividend Swap' or 'Index Dividend Swap'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:equityOptionTransactionSupplement|fpml:equitySwapTransactionSupplement|fpml:dividendSwapTransactionSupplement|fpml:varianceSwapTransactionSupplement|fpml:swVolatilitySwapTransactionSupplement|fpml:swEquityAccumulatorForwardShort">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:choose>
<xsl:when test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swTradeHeader/fpml:swNovationExecution"/>
<xsl:otherwise>
<xsl:if test="fpml:otherPartyPayment and ($productType='Equity Share Swap' or $productType='Equity Index Swap' or $productType= 'Equity Basket Swap') ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected otherPartyPayment element encountered in this context.</text>
</error>
</xsl:if>
</xsl:otherwise>
</xsl:choose>
<xsl:variable name="NovationExecution">
<xsl:value-of select="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swTradeHeader/fpml:swNovationExecution"/>
</xsl:variable>
<xsl:if test="$NovationExecution = 'true'">
<xsl:choose>
<xsl:when test="fpml:otherPartyPayment">
<xsl:if test="string(fpml:otherPartyPayment/fpml:paymentType) != 'NovationExecutionFee'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected payment reason encountered in this context. Expected value is 'NovationExecutionFee'</text>
</error>
</xsl:if>
</xsl:when>
</xsl:choose>
</xsl:if>
<xsl:choose>
<xsl:when test="fpml:otherPartyPayment">
<xsl:if test="not(fpml:otherPartyPayment/fpml:paymentDate)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** paymentDate is mandatory when otherPartyPayment is populated.'</text>
</error>
</xsl:if>
</xsl:when>
</xsl:choose>
<xsl:if test="fpml:brokerPartyReference and ($productType='Equity Share Swap' or $productType='Equity Index Swap' or $productType= 'Equity Basket Swap') ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected brokerPartyReference element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="count(fpml:calculationAgent/fpml:calculationAgentPartyReference) &gt; 2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of calculationAgentPartyReference elements encountered. One or Two expected.</text>
</error>
</xsl:if>
<xsl:if test="fpml:calculationAgentBusinessCenter">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected calculationAgentBusinessCenter element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="$docsType='Equity Swap (Emerging)' and (fpml:determiningParty)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected element of 'determiningParty' encountered. Not expected in Equity Swap Emerging product.</text>
</error>
</xsl:if>
<xsl:if test="$productType='Equity Index Swap' and $mcType = 'EmergingEquitySwapIndustry' and fpml:hedgingParty">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected element of 'hedgingParty' encountered. Not expected in Equity Index Swap Emerging product.</text>
</error>
</xsl:if>
<xsl:if test="$productType='Equity Index Swap' and ($mcType = 'EmergingEquitySwapEMEA' or $mcType = 'EmergingEquitySwapLATAM') and fpml:hedgingParty">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected element of 'hedgingParty' encountered. Not expected in Equity Swap EMEA or LATAM product.</text>
</error>
</xsl:if>
<xsl:if test="count(fpml:determiningParty) &gt; 2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of determiningParty elements encountered. One or Two expected.</text>
</error>
</xsl:if>
<xsl:if test="count(fpml:hedgingParty) &gt; 2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of hedgingParty elements encountered. One or Two expected.</text>
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
<xsl:if test="fpml:allocations and ($productType='Equity Share Swap' or $productType='Equity Index Swap' or $productType= 'Equity Basket Swap') ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected allocations element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:tradeSide and ($productType='Equity Share Swap' or $productType='Equity Index Swap' or $productType= 'Equity Basket Swap') ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected tradeSide element encountered in this context.</text>
</error>
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
<xsl:param name="allocPartyA"/>
<xsl:param name="allocPartyB"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
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
<xsl:if test="ancestor::fpml:swAllocation">
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
<xsl:if test="fpml:paymentDate and ($productType = 'Equity Share Swap' or $productType = 'Equity Index Swap' or $productType = 'Equity Basket Swap') ">
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
<xsl:if test="fpml:paymentDate and ($productType = 'Equity Share Swap' or $productType = 'Equity Index Swap' or $productType = 'Equity Basket Swap') ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected paymentDate element encountered in this context.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:documentation">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="fpml:masterAgreement and not (($productType = 'Equity Share Volatility Swap' or $productType = 'Equity Index Volatility Swap') and $docsType='Volatility Swap (Open Markets)')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected masterAgreement element in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:contractualMatrix and not (($productType = 'Equity Share Volatility Swap' or $productType = 'Equity Index Volatility Swap') and $docsType='Volatility Swap (Open Markets)')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected contractualMatrix element in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:masterConfirmation and ($productType = 'Equity Share Volatility Swap' or $productType = 'Equity Index Volatility Swap') and $docsType='Volatility Swap (Open Markets)'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected masterConfirmation element in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:brokerConfirmation">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected brokerConfirmation element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:contractualDefinitions and not ($productType = 'Equity Share Volatility Swap' or $productType = 'Equity Index Volatility Swap' or $productType = 'Equity Accumulator' or $productType = 'Equity Decumulator')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected contractualDefinitions element in this context.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:masterConfirmation) and not ($productType = 'Equity Share Volatility Swap' or $productType = 'Equity Index Volatility Swap')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing masterConfirmation element  in this context.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:masterConfirmation">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:masterAgreement">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:contractualMatrix">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:contractualSupplement">
<xsl:call-template name="isValidContractualSupplement">
<xsl:with-param name="elementName">contractualSupplement</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:contractualSupplement"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:contractualTermsSupplement and ($productType='Equity Share Swap' or $productType='Equity Index Swap') ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected contractualTermsSupplement element encountered in this context.</text>
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
</xsl:template>
<xsl:template match="fpml:masterConfirmation">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="$productType = 'Equity Share Option' or $productType = 'Equity Index Option' or $productType = 'Equity Share Option Strategy' or $productType = 'Equity Index Option Strategy'">
<xsl:call-template name="isValidEquityConfirmationType">
<xsl:with-param name="elementName">masterConfirmationType</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:masterConfirmationType"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationAnnexType">
<xsl:if test="$productType = 'Equity Share Option' or $productType = 'Equity Index Option' or $productType = 'Equity Share Option Strategy' or $productType = 'Equity Index Option Strategy'">
<xsl:call-template name="isValidEquityOptionConfirmationAnnexType">
<xsl:with-param name="elementName">masterConfirmationAnnexType</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:masterConfirmationAnnexType"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
</xsl:if>
<xsl:if test="$productType = 'Share Variance Swap' or $productType = 'Index Variance Swap'">
<xsl:call-template name="isValidVarianceSwapConfirmationType">
<xsl:with-param name="elementName">masterConfirmationType</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:masterConfirmationType"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="$productType = 'Share Dividend Swap' or $productType = 'Index Dividend Swap'">
<xsl:call-template name="isValidDividendSwapConfirmationType">
<xsl:with-param name="elementName">masterConfirmationType</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:masterConfirmationType"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="$productType = 'Equity Share Swap' or $productType = 'Equity Index Swap' or $productType = 'Equity Basket Swap'">
<xsl:call-template name="isValidEquitySwapConfirmationType">
<xsl:with-param name="elementName">masterConfirmationType</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:masterConfirmationType"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationAnnexType">
<xsl:if test="$productType = 'Equity Share Swap' or $productType = 'Equity Index Swap' or $productType = 'Equity Basket Swap'">
<xsl:call-template name="isValidEquitySwapConfirmationAnnexType">
<xsl:with-param name="elementName">masterConfirmationAnnexType</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:masterConfirmationAnnexType"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:masterAgreement">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="'Equity Share Volatility Swap' or $productType = 'Equity Index Volatility Swap'">
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
<xsl:template match="fpml:contractualMatrix">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="'Equity Share Volatility Swap' or $productType = 'Equity Index Volatility Swap'">
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
</xsl:if>
</xsl:template>
<xsl:template match="fpml:swExtendedTradeDetails">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:apply-templates select="fpml:swTradeHeader">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="not($productType='Equity Share Swap' or $productType='Equity Index Swap' or $productType='Equity Share Option' or $productType='Equity Index Option' or $productType='Equity Share Option Strategy' or $productType='Equity Index Option Strategy' or $productType='Equity Basket Swap') ">
<xsl:if test="fpml:swDocsSelection">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swDocsSelection element encountered in this context.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:swAmendmentType and not(fpml:swAmendmentType='CorporateAction' or (fpml:swAmendmentType='CorporateActionAmendment' and $productType = 'Equity Share Swap'))">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unxepected swAmendmentType value (<xsl:value-of select="fpml:swAmendmentType"/>) encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swAmendmentDate">
<xsl:if test="not($productType = 'Equity Share Swap' or $productType = 'Equity Index Swap' or $productType = 'Equity Basket Swap')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swAmendmentDate element encountered in this context.</text>
</error>
</xsl:if>
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">swAmendmentDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swAmendmentDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="not(fpml:swVarianceSwapDetails) and ($productType='Share Variance Swap' or $productType='Index Variance Swap')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swVarianceSwapDetails element encountered in this context. Element must be present if product type is 'Share Variance Swap' or 'Index Variance Swap'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swVarianceSwapDetails and $productType!='Share Variance Swap' and $productType != 'Index Variance Swap'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swVarianceSwapDetails element encountered in this context. Element must be not present if product type is not 'Share Variance Swap' or 'Index Variance Swap'.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:swVolatilitySwapDetails) and ($productType='Equity Share Volatility Swap' or $productType='Equity Index Volatility Swap')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swVolatilitySwapDetails element encountered in this context. Element must be present if product type is 'Equity Share Volatility Swap' or 'Equity Index Volatility Swap'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swVolatilitySwapDetails and $productType!='Equity Share Volatility Swap' and $productType != 'Equity Index Volatility Swap'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swVolatilitySwapDetails element encountered in this context. Element must be not present if product type is not 'Share Variance Swap' or 'Index Variance Swap'.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:swEquityOptionDetails) and ($productType='Equity Share Option' or  $productType='Equity Share Option Strategy')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swEquityOptionDetails element encountered in this context. Element must be present if product type is 'Equity Share Option' or 'Equity Share Option Strategy'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swEquityOptionDetails and ($productType!='Equity Share Option' and $productType != 'Equity Index Option' and $productType!='Equity Share Option Strategy' and $productType != 'Equity Index Option Strategy')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swEquityOptionDetails element encountered in this context. Element must be not present if product type is not 'Equity Share Option' or 'Equity Index Option' or 'Equity Share Option Strategy' or 'Equity Index Option Strategy'.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:swDividendSwapDetails) and $productType='Share Dividend Swap'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swDividendSwapDetails element encountered in this context. Element must be present if product type is 'Share Dividend Swap' or 'Index Dividend Swap'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swDividendSwapDetails and $productType!='Share Dividend Swap' and $productType != 'Index Dividend Swap'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swDividendSwapDetails element encountered in this context. Element must be not present if product type is not 'Share Dividend Swap' or 'Index Dividend Swap'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swCorporateActionFlag and $productType!='Equity Share Swap'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swCorporateActionFlag element encountered in this context. Element must not be present if product type is not 'Equity Share Swap' or 'Equity Basket Swap'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swChinaConnect">
<xsl:if test="not (fpml:swChinaConnect/fpml:swShareDisqualification)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Element swShareDisqualification must be present if swChinaConnect element is present.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swChinaConnect/fpml:swShareDisqualification">
<xsl:call-template name="isValidChinaConnectFieldValue">
<xsl:with-param name="elementName">swShareDisqualification</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swChinaConnect/fpml:swShareDisqualification"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="not (fpml:swChinaConnect/fpml:swServiceTermination)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Element swServiceTermination must be present if swChinaConnect element is present.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swChinaConnect/fpml:swServiceTermination">
<xsl:call-template name="isValidChinaConnectFieldValue">
<xsl:with-param name="elementName">swServiceTermination</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swChinaConnect/fpml:swServiceTermination"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:swVarianceSwapDetails">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:swVolatilitySwapDetails">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:swEquityOptionDetails">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:swDividendSwapDetails">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:swEquitySwapDetails">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:swDispersionVarianceSwapDetails">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="($productType='Share Dividend Swap' or $productType='Index Dividend Swap') and //fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swIndependentAmountPercentage">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swIndependentAmountPercentage must not be present for Dividend Swaps.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:swTradeHeader">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
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
<xsl:if test="$productType='FRA'">
<xsl:if test="not(//fpml:swClearingNotRequired[. = 'false'])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swClearingNotRequired must be equal to 'false' if product type is 'FRA'. Value = '<xsl:value-of select="fpml:swClearingNotRequired"/>'.</text>
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
<xsl:if test="$productType='IRS' or $productType='OIS' or $productType='Swaption' or $productType='Single Currency Basis Swap' or $productType='Cross Currency Basis Swap' or $productType='Cross Currency IRS'">
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
<xsl:if test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swTradeHeader/fpml:swBackLoadingFlag">
<xsl:if test="(/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swTradeHeader/fpml:swBackLoadingFlag[. != 'true'] and //fpml:swOriginatingEvent ='Backload') or (/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swTradeHeader/fpml:swBackLoadingFlag[. = 'true'] and //fpml:swOriginatingEvent !='Backload')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***  Invalid combination of swBackLoadingFlag and swOriginatingEvent. Either both values must indicate a 'backload' or neither. Value = '<xsl:value-of select="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swTradeHeader/fpml:swBackLoadingFlag"/>'.</text>
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
<xsl:if test="not($productType='IRS' or $productType='OIS' or $productType='FRA' or $productType='Single Currency Basis Swap' or $productType='Equity Index Option')">
<xsl:if test="fpml:swClientClearing">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swClientClearing must not be present if product type is not equal to 'SingleCurrencyInterestRateSwap' or 'OIS' or 'FRA' or 'Single Currency Basis Swap' or 'Equity Index Option'.</text>
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
<xsl:if test="not($productType='IRS' or $productType='OIS' or $productType='FRA' or $productType='Single Currency Basis Swap' or $productType='Equity Index Option' or $productType ='sfsgs')">
<xsl:if test="fpml:swAutoSendForClearing">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swAutoSendForClearing must not be present if product type is not equal to 'SingleCurrencyInterestRateSwap' or 'OIS' or 'FRA' or 'Single Currency Basis Swap' or 'ZC Inflation Swap'.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:swEquityAccumulatorForwardShort">
<xsl:if test="not (not (/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:swEquityAccumulatorForwardShort/fpml:feature/fpml:knock/fpml:knockOut/fpml:trigger/fpml:levelPercentage and /fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:swEquityAccumulatorForwardShort/fpml:feature/fpml:knock/fpml:knockOut/fpml:trigger/fpml:triggerTimeType and /fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:swEquityAccumulatorForwardShort/fpml:swAccumulator/fpml:swKnockOutParameters/fpml:swKnockOutCommencementDate) or (/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:swEquityAccumulatorForwardShort/fpml:feature/fpml:knock/fpml:knockOut/fpml:trigger/fpml:levelPercentage and /fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:swEquityAccumulatorForwardShort/fpml:feature/fpml:knock/fpml:knockOut/fpml:trigger/fpml:triggerTimeType and /fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:swEquityAccumulatorForwardShort/fpml:swAccumulator/fpml:swKnockOutParameters/fpml:swKnockOutCommencementDate))">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** User must either provide all 3 mandatory fields - Knock Out Price, Knock Out Commencement Date and Knock Out Type - or should provide none.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:swVarianceSwapDetails">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$docsType='Variance Swap (Europe)'">
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
</xsl:when>
<xsl:when test="$docsType='Variance Swap (AEJ)' or $docsType='Variance Swap (Japan)' or $docsType='Variance Swap (Americas)'">
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
</xsl:when>
</xsl:choose>
<xsl:if test="fpml:swTotalVarianceCap and not (//fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:varianceLeg/fpml:equityAmount/fpml:variance/fpml:varianceCap='true')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swTotalVarianceCap element encountered in this context. Element must be not present unless variance/varianceCap is equal to 'true'.</text>
</error>
</xsl:if>
<xsl:if test="//fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:varianceLeg/fpml:equityAmount/fpml:variance/fpml:varianceCap='true'">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swTotalVarianceCap</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swTotalVarianceCap"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.0000</xsl:with-param>
<xsl:with-param name="maxIncl">998001.0000</xsl:with-param>
<xsl:with-param name="maxDecs">4</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swTotalVolatilityCap and not (//fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:varianceLeg/fpml:equityAmount/fpml:variance/fpml:varianceCap='true')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swTotalVolatilityCap element encountered in this context. Element must be not present unless variance/varianceCap is equal to 'true'.</text>
</error>
</xsl:if>
<xsl:if test="//fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:varianceLeg/fpml:equityAmount/fpml:variance/fpml:varianceCap='true'">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swTotalVolatilityCap</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swTotalVolatilityCap"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.0001</xsl:with-param>
<xsl:with-param name="maxIncl">999.9999</xsl:with-param>
<xsl:with-param name="maxDecs">4</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">swExpectedNOverride</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swExpectedNOverride"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="fpml:swSettlementCurrencyVegaNotionalAmount and not (/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:varianceLeg/fpml:equityAmount/fpml:variance/fpml:fxFeature)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swSettlementCurrencyVegaNotionalAmount encountered in this context when no fxFeature is present. A settlement currency vega notional is only allowed for trades settling cross currency.</text>
</error>
</xsl:if>
<xsl:choose>
<xsl:when test="not (fpml:swSettlementCurrencyVegaNotionalAmount) and  /fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:varianceLeg/fpml:equityAmount/fpml:variance/fpml:fxFeature">
<xsl:if test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:varianceLeg/fpml:equityAmount/fpml:variance/fpml:fxFeature/fpml:referenceCurrency='AUD'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swSettlementCurrencyVegaNotionalAmount in this context when currency is AUD. If a normally deliverable currency is traded as non deliverable, swSettlementCurrencyVegaNotionalAmount is required.</text>
</error>
</xsl:if>
<xsl:if test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:varianceLeg/fpml:equityAmount/fpml:variance/fpml:fxFeature/fpml:referenceCurrency='HKD'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swSettlementCurrencyVegaNotionalAmount in this context when currency is HKD. If a normally deliverable currency is traded as non deliverable, swSettlementCurrencyVegaNotionalAmount is required.</text>
</error>
</xsl:if>
<xsl:if test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:varianceLeg/fpml:equityAmount/fpml:variance/fpml:fxFeature/fpml:referenceCurrency='NZD'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swSettlementCurrencyVegaNotionalAmount in this context when currency is NZD. If a normally deliverable currency is traded as non deliverable, swSettlementCurrencyVegaNotionalAmount is required.</text>
</error>
</xsl:if>
<xsl:if test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:varianceLeg/fpml:equityAmount/fpml:variance/fpml:fxFeature/fpml:referenceCurrency='SGD'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swSettlementCurrencyVegaNotionalAmount in this context when currency is SGD. If a normally deliverable currency is traded as non deliverable, swSettlementCurrencyVegaNotionalAmount is required.</text>
</error>
</xsl:if>
</xsl:when>
</xsl:choose>
<xsl:if test="fpml:swSettlementCurrencyVegaNotionalAmount">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swSettlementCurrencyVegaNotionalAmount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swSettlementCurrencyVegaNotionalAmount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.01</xsl:with-param>
<xsl:with-param name="maxIncl">9999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swVegaFxSpotRate and not (/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:varianceLeg/fpml:equityAmount/fpml:variance/fpml:fxFeature)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swVegaFxSpotRate encountered in this context when no fxFeature is present. A vega spot rate is only allowed for trades settling cross currency.</text>
</error>
</xsl:if>
<xsl:choose>
<xsl:when test="not (fpml:swVegaFxSpotRate) and /fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:varianceLeg/fpml:equityAmount/fpml:variance/fpml:fxFeature">
<xsl:if test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:varianceLeg/fpml:equityAmount/fpml:variance/fpml:fxFeature/fpml:referenceCurrency='AUD'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swVegaFxSpotRate in this context when currency is AUD. If a normally deliverable currency is traded as non deliverable, swVegaFxSpotRate is required.</text>
</error>
</xsl:if>
<xsl:if test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:varianceLeg/fpml:equityAmount/fpml:variance/fpml:fxFeature/fpml:referenceCurrency='HKD'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swVegaFxSpotRate in this context when currency is HKD. If a normally deliverable currency is traded as non deliverable, swVegaFxSpotRate is required.</text>
</error>
</xsl:if>
<xsl:if test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:varianceLeg/fpml:equityAmount/fpml:variance/fpml:fxFeature/fpml:referenceCurrency='NZD'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swVegaFxSpotRate in this context when currency is NZD. If a normally deliverable currency is traded as non deliverable, swVegaFxSpotRate is required.</text>
</error>
</xsl:if>
<xsl:if test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:varianceLeg/fpml:equityAmount/fpml:variance/fpml:fxFeature/fpml:referenceCurrency='SGD'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swVegaFxSpotRate in this context when currency is SGD. If a normally deliverable currency is traded as non deliverable, swVegaFxSpotRate is required.</text>
</error>
</xsl:if>
</xsl:when>
</xsl:choose>
<xsl:if test="fpml:swVegaFxSpotRate">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swVegaFxSpotRate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swVegaFxSpotRate"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.000001</xsl:with-param>
<xsl:with-param name="maxIncl">9999.999999</xsl:with-param>
<xsl:with-param name="maxDecs">6</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swVarianceSwapHolidayDate and fpml:swExpectedNOverride ='true'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** No swVarianceSwapHolidayDate elements may be submitted if swExpectedNOverride is set to 'true'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swVarianceSwapHolidayDate">
<xsl:for-each select="swVarianceSwapHolidayDate">
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">swVarianceSwapHolidayDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swVarianceSwapHolidayDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:for-each>
</xsl:if>
<xsl:if test="fpml:swVarianceSwapTermination">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swVarianceSwapTermination element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="//fpml:fxFeature//fpml:fxSpotRateSource and (//fpml:swExtendedTradeDetails/fpml:swVarianceSwapDetails/fpml:swFxDeterminationMethod = 'AsSpecifiedInMasterConfirmation')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected fxSpotRateSource element encountered in this context. Element must not be present when swFxDeterminationMethod is 'AsSpecifiedInMasterConfirmation'</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:swVolatilitySwapDetails">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">swExpectedNOverride</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swExpectedNOverride"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="fpml:swSettlementCurrencyVegaNotionalAmount and not (/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:swVolatilitySwapTransactionSupplement/fpml:swVolatilityLeg/fpml:fxFeature)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swSettlementCurrencyVegaNotionalAmount encountered in this context when no fxFeature is present. A settlement currency vega notional is only allowed for trades settling cross currency.</text>
</error>
</xsl:if>
<xsl:choose>
<xsl:when test="not (fpml:swSettlementCurrencyVegaNotionalAmount) and  /fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:swVolatilitySwapTransactionSupplement/fpml:swVolatilityLeg/fpml:fxFeature">
<xsl:if test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:swVolatilitySwapTransactionSupplement/fpml:swVolatilityLeg/fpml:fxFeature/fpml:referenceCurrency='AUD'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swSettlementCurrencyVegaNotionalAmount in this context when currency is AUD. If a normally deliverable currency is traded as non deliverable, swSettlementCurrencyVegaNotionalAmount is required.</text>
</error>
</xsl:if>
<xsl:if test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:swVolatilitySwapTransactionSupplement/fpml:swVolatilityLeg/fpml:fxFeature/fpml:referenceCurrency='HKD'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swSettlementCurrencyVegaNotionalAmount in this context when currency is HKD. If a normally deliverable currency is traded as non deliverable, swSettlementCurrencyVegaNotionalAmount is required.</text>
</error>
</xsl:if>
<xsl:if test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:swVolatilitySwapTransactionSupplement/fpml:swVolatilityLeg/fpml:fxFeature/fpml:referenceCurrency='NZD'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swSettlementCurrencyVegaNotionalAmount in this context when currency is NZD. If a normally deliverable currency is traded as non deliverable, swSettlementCurrencyVegaNotionalAmount is required.</text>
</error>
</xsl:if>
<xsl:if test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:swVolatilitySwapTransactionSupplement/fpml:swVolatilityLeg/fpml:fxFeature/fpml:referenceCurrency='SGD'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swSettlementCurrencyVegaNotionalAmount in this context when currency is SGD. If a normally deliverable currency is traded as non deliverable, swSettlementCurrencyVegaNotionalAmount is required.</text>
</error>
</xsl:if>
</xsl:when>
</xsl:choose>
<xsl:if test="fpml:swSettlementCurrencyVegaNotionalAmount">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swSettlementCurrencyVegaNotionalAmount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swSettlementCurrencyVegaNotionalAmount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.01</xsl:with-param>
<xsl:with-param name="maxIncl">9999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swVegaFxSpotRate and not (/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:swVolatilitySwapTransactionSupplement/fpml:swVolatilityLeg/fpml:fxFeature)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swVegaFxSpotRate encountered in this context when no fxFeature is present. A vega spot rate is only allowed for trades settling cross currency.</text>
</error>
</xsl:if>
<xsl:choose>
<xsl:when test="not (fpml:swVegaFxSpotRate) and /fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:swVolatilitySwapTransactionSupplement/fpml:swVolatilityLeg/fpml:fxFeature">
<xsl:if test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:swVolatilitySwapTransactionSupplement/fpml:swVolatilityLeg/fpml:fxFeature/fpml:referenceCurrency='AUD'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swVegaFxSpotRate in this context when currency is AUD. If a normally deliverable currency is traded as non deliverable, swVegaFxSpotRate is required.</text>
</error>
</xsl:if>
<xsl:if test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:swVolatilitySwapTransactionSupplement/fpml:swVolatilityLeg/fpml:fxFeature/fpml:referenceCurrency='HKD'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swVegaFxSpotRate in this context when currency is HKD. If a normally deliverable currency is traded as non deliverable, swVegaFxSpotRate is required.</text>
</error>
</xsl:if>
<xsl:if test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:swVolatilitySwapTransactionSupplement/fpml:swVolatilityLeg/fpml:fxFeature/fpml:referenceCurrency='NZD'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swVegaFxSpotRate in this context when currency is NZD. If a normally deliverable currency is traded as non deliverable, swVegaFxSpotRate is required.</text>
</error>
</xsl:if>
<xsl:if test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:swVolatilitySwapTransactionSupplement/fpml:swVolatilityLeg/fpml:fxFeature/fpml:referenceCurrency='SGD'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swVegaFxSpotRate in this context when currency is SGD. If a normally deliverable currency is traded as non deliverable, swVegaFxSpotRate is required.</text>
</error>
</xsl:if>
</xsl:when>
</xsl:choose>
<xsl:if test="fpml:swVegaFxSpotRate">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swVegaFxSpotRate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swVegaFxSpotRate"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.000001</xsl:with-param>
<xsl:with-param name="maxIncl">9999.999999</xsl:with-param>
<xsl:with-param name="maxDecs">6</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swVolatilitySwapHolidayDate and fpml:swExpectedNOverride ='true'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** No swVolatilitySwapHolidayDate elements may be submitted if swExpectedNOverride is set to 'true'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swVolatilitySwapHolidayDate">
<xsl:for-each select="swVolatilitySwapHolidayDate">
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">swVolatilitySwapHolidayDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swVolatilitySwapHolidayDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:for-each>
</xsl:if>
<xsl:if test="//fpml:fxFeature//fpml:fxSpotRateSource and (//fpml:swExtendedTradeDetails/fpml:swVolatilitySwapDetails/fpml:swFxDeterminationMethod = 'AsSpecifiedInMasterConfirmation')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected fxSpotRateSource element encountered in this context. Element must not be present when swFxDeterminationMethod is 'AsSpecifiedInMasterConfirmation'</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:swEquityOptionDetails">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="fpml:swEquityOptionPercentInput and ($docsType = 'Equity Options (AEJ)' or $docsType = 'Equity Options (Japan)' or $docsType = 'Equity Options (Americas)')   and not(//fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:equityPremium/fpml:pricePerOption/fpml:amount)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing Price element. You must supply pricePerOption/amount for % input trades. Required in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swEquityOptionPercentInput and fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:strike/fpml:strikePrice  and not(/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swEquityOptionDetails/fpml:swEquityOptionPercentInput/fpml:swStrikePercentage)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swStrikePercentage element. You must supply swStrikePercentage for % input trades unless the trade is forward starting. Required in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swEquityOptionPercentInput and ($docsType = 'Equity Options (AEJ)' or $docsType = 'Equity Options (Japan)' or $docsType = 'Equity Options (Americas)') and not (//fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:equityPremium/fpml:paymentAmount/fpml:amount) ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing element. You must supply paymentAmount/amount for % input trades. Required in this context.</text>
</error>
</xsl:if>
<xsl:if test="not(/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:strike/fpml:strikePercentage)">
<xsl:if test="fpml:swEquityOptionPercentInput and not(/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swEquityOptionDetails/fpml:swEquityOptionPercentInput/fpml:swStrikePercentage)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing element. You must supply swStrikePercentage for % input trades. Required in this context.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:strike/fpml:strikePercentage">
<xsl:if test="fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swEquityOptionDetails/fpml:swEquityOptionPercentInput/fpml:swStrikePercentage">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** You cannot supply swStrikePercentage and strikePercentage on the same trade. Supply strikePercentage for forward starting trades.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:numberOfShares and $productType != 'Equity Share Option' and $productType != 'Equity Share Option Strategy'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected numberOfShares element encountered in this context when product type is not 'Equity Share Option' or 'Equity Share Option Strategy'. Element only applies for Equity Share Options and Equity Share Option Strategies.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:numberOfShares) and $productType = 'Equity Share Option' and $productType != 'Equity Share Option Strategy'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing numberOfShares element in this context when product type is 'Equity Share Option' or 'Equity Share Option Strategy'. Element required for Equity Share Options and Equity Share Option Strategies.</text>
</error>
</xsl:if>
<xsl:choose>
<xsl:when test="fpml:swDeltaCross and ($productType='Share Variance Swap' or $productType='Index Variance Swap')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swDeltaCross element encountered in this context. Element must not be present if product type is 'Share Variance Swap' or 'Index Variance Swap'.</text>
</error>
</xsl:when>
<xsl:when test="fpml:swDeltaCross and ($productType='Share Dividend Swap' or $productType='Index Dividend Swap')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swDeltaCross element encountered in this context. Element must not be present if product type is 'Share Dividend Swap' or 'Index Dividend Swap'.</text>
</error>
</xsl:when>
</xsl:choose>
<xsl:if test="fpml:swVarianceSwapDetails and ($productType='Index Dividend Swap' or $productType='Share Dividend Swap')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swVarianceSwapDetails element encountered in this context. Element must not be present if product type is 'Index Dividend Swap' or 'Share Dividend Swap'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swEquityOptionDetails and ($productType='Index Dividend Swap' or $productType='Share Dividend Swap')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swEquityOptionDetails element encountered in this context. Element must not be present if product type is 'Index Dividend Swap' or 'Share Dividend Swap'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swEquityOptionDetails and ($productType='Dispersion Variance Swap')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swEquityOptionDetails element encountered in this context. Element must not be present if product type is 'Dispersion Variance Swap' </text>
</error>
</xsl:if>
<xsl:if test="fpml:swCapPercentage and $docsType!='Equity Options (Cliquet)' and $docsType!='Equity Options (Spread)'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swCapPercentage element encountered in this context. This element is only supported for 'Equity Index Cliquet Options' </text>
</error>
</xsl:if>
<xsl:if test="/fpml:SWDML//fpml:swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swEquityOptionDetails/fpml:swCapPercentage">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swCapPercentage</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="/fpml:SWDML//fpml:swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swEquityOptionDetails/fpml:swCapPercentage"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">9.99999999</xsl:with-param>
<xsl:with-param name="maxDecs">8</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swCap and $docsType!='Equity Options (Spread)'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swCap element encountered in this context. This element is only supported for 'Equity Index Spread Options' </text>
</error>
</xsl:if>
<xsl:if test="fpml:swFloor and $docsType!='Equity Options (Spread)'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swFloor element encountered in this context. This element is only supported for 'Equity Index Spread Options' </text>
</error>
</xsl:if>
<xsl:if test="fpml:swFloorPercentage and $docsType!='Equity Options (Spread)'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swFloorPercentage element encountered in this context. This element is only supported for 'Equity Index Spread Options' </text>
</error>
</xsl:if>
<xsl:if test="$docsType='Equity Options (Cliquet)' and not(fpml:swEquityValuationMethod)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swEquityValuationMethod element. This element must be present for Equity Cliquet Options </text>
</error>
</xsl:if>
<xsl:variable name="equityValuationMethod">
<xsl:value-of select="fpml:swEquityValuationMethod"/>
</xsl:variable>
<xsl:if test="fpml:swEquityValuationMethod">
<xsl:choose>
<xsl:when test="$equityValuationMethod='Custom'"/>
<xsl:when test="$equityValuationMethod='Asian Tail'"/>
<xsl:when test="$equityValuationMethod='Frequency'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid value for swEquityValuationMethod. Element must contain either 'Custom' or 'Asian Tail' or 'Frequency'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="fpml:swValuationDates and $docsType='Equity Options (Cliquet)'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swValuationDates element encountered in this context. This element must not be submitted as part of swdml for Equity Cliquet Options. </text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:swDeltaCross">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:swDefaultSettlementMethod">
<xsl:call-template name="isValidDefaultSettlementMethod">
<xsl:with-param name="elementName">swDefaultSettlementMethod</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swDefaultSettlementMethod"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swReferenceFXRate">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swReferenceFXRate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swReferenceFXRate"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">99999.999999</xsl:with-param>
<xsl:with-param name="maxDecs">6</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:apply-templates select="fpml:swEquityOptionPercentInput">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:swEquityOptionPercentInput and not ($docsType = 'Equity Options (AEJ)' or $docsType = 'Equity Options (Japan)' or $docsType = 'Equity Options (Americas)' or $docsType = 'Equity Options (Europe)' or $docsType = 'Equity Options (Spread)')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swEquityOptionPercentInput element encountered in this context. Element must not be present if product is not on a Japanese, Americas or AEJ Underlier. Value = '<xsl:value-of select="$docsType"/>'</text>
</error>
</xsl:if>
<xsl:if test="fpml:swEquityOptionPercentInput and not ($productType!='Equity Index Option' or $productType!='Equity Share Option' or  $productType!='Equity Index Option Strategy' or $productType!='Equity Share Option Strategy' )">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swEquityOptionPercentInput element encountered in this context. Element must not be present if product is not an Equity Index Option, or Equity Share Option, or Equity Index Option Strategy, or Equity Share Option Strategy.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swReferenceFXRate and not (/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:fxFeature/fpml:composite or /fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:fxFeature/fpml:crossCurrency or /fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:fxFeature/fpml:quanto)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swReferenceFXRate provided - Not expected for Vanilla Trades.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swReferenceFXRate and (//fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:equityExercise/fpml:equityExercise/fpml:settlementType != 'Cash')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swReferenceFXRate provided - Not expected for physically settled Trades.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swAveragingDates">
<xsl:apply-templates select="fpml:swAveragingDates">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
<xsl:if test="(fpml:swEquityOptionStrategy) and $productType!='Equity Share Option Strategy' and $productType!='Equity Index Option Strategy'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid swEquityOptionStrategy element encountered in this context. Element must not be present if product type is not 'Equity Share Option Strategy' and not 'Equity Index Option Strategy'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swEquityOptionStrategy">
<xsl:apply-templates select="fpml:swEquityOptionStrategy">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
<xsl:if test="not(fpml:swEquityOptionStrategy/fpml:swEquityOptionStrategyDetails) and ($productType='Equity Share Option Strategy' or $productType='Equity Index Option Strategy')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swEquityOptionStrategyDetails element encountered in this context. Element must be present if product type is 'Equity Share Option Strategy' or 'Equity Index Option Strategy'.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:swDividendSwapDetails">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="fpml:swSplitCollateral and not (/fpml:SWDML//fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:collateral)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing fpml:collateral sequence, expected in this context</text>
</error>
</xsl:if>
<xsl:if test="fpml:swSplitCollateral and not (/fpml:SWDML//fpml:swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swDividendSwapDetails/fpml:swBreakOutTrade)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swBreakOutTrade element, expected in this context</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:swDispersionVarianceSwapDetails">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="count(fpml:swLegComponentDetails) != count(/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:varianceSwapTransactionSupplement/fpml:varianceLeg)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of  elements encountered. There must be as many instances of swLegComponentDetails as there are varianceLegs (<xsl:value-of select="count(fpml:swLegComponentDetails)"/> found) vs.(<xsl:value-of select="count(/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:varianceSwapTransactionSupplement/fpml:varianceLeg)"/> found)</text>
</error>
</xsl:if>
<xsl:for-each select="fpml:swLegComponentDetails">
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
<text>*** Empty swLegComponentDetails/@id attribute.</text>
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
<xsl:if test="fpml:swExpectedNOverride">
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">swExpectedNOverride</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swExpectedNOverride"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swComponentWeighting">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swComponentWeighting</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swComponentWeighting"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.001</xsl:with-param>
<xsl:with-param name="maxIncl">100.000</xsl:with-param>
<xsl:with-param name="maxDecs">3</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swDispersionVarianceSwapTermination">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swDispersionVarianceSwapTermination element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swDispersionIndexCancellationDetails">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swDispersionIndexCancellationDetails element encountered in this context.</text>
</error>
</xsl:if>
</xsl:for-each>
</xsl:template>
<xsl:template match="fpml:swEquitySwapDetails">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:variable name="optionalEarlyTermination">
<xsl:value-of select="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:optionalEarlyTermination"/>
</xsl:variable>
<xsl:variable name="eswAmendmentType">
<xsl:value-of select="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swAmendmentType"/>
</xsl:variable>
<xsl:if test="$eswAmendmentType = 'CorporateActionAmendment' and not (fpml:pcEntry)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** pcEntry is mandatory when swExtendedTradeDetails/swAmendmentType is CorporateActionAmendment.</text>
</error>
</xsl:if>
<xsl:if test="fpml:pcEntry">
<xsl:call-template name="isValidIntegerNumber">
<xsl:with-param name="elementName">pcEntry</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:pcEntry"/>
</xsl:with-param>
<xsl:with-param name="minIncl">1</xsl:with-param>
<xsl:with-param name="maxIncl">999</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swMultiplier and $docsSubType != 'Private' and ($productType = 'Equity Share Swap' or $productType = 'Equity Index Swap' or $productType = 'Equity Basket Swap')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swMultiplier is only applicable for Private Master Confirms for Equity Index/Share Swap products.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swFullyFunded and $docsSubType != 'Private' and ($productType = 'Equity Share Swap' or $productType = 'Equity Index Swap' or $productType = 'Equity Basket Swap')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swFullyFunded element encountered in this context. Element must be not present unless docs sub-type is 'Private'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swSpreadDetails and $docsSubType != 'Private' and ($productType = 'Equity Share Swap' or $productType = 'Equity Index Swap' or $productType = 'Equity Basket Swap')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swSpreadDetails element encountered in this context. Element must be not present unless docs sub-type is 'Private'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swFullyFunded and fpml:swSpreadDetails">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swFullyFunded and swSpreadDetails must not co-exist.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swFullyFunded and not (fpml:swFullyFunded/fpml:currency = //fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:returnLeg/fpml:amount/fpml:paymentCurrency/fpml:currency)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swFullyFunded/currency must be the same as settlement currency (return leg payment currency).</text>
</error>
</xsl:if>
<xsl:if test="fpml:swFullyFunded">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">amount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swFullyFunded/fpml:amount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">-9999999999999.99</xsl:with-param>
<xsl:with-param name="maxIncl">9999999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swSpreadDetails and not (fpml:swSpreadDetails/fpml:swSpreadIn or fpml:swSpreadDetails/fpml:swSpreadOut)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** One of swSpreadIn, swSpreadOut is mandatory when swSpreadDetails is present.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swSpreadDetails/fpml:swSpreadIn">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">SpreadIn</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swSpreadDetails/fpml:swSpreadIn"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">0.0999999</xsl:with-param>
<xsl:with-param name="maxDecs">7</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swSpreadDetails/fpml:swSpreadOut">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">SpreadOut</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swSpreadDetails/fpml:swSpreadOut"/>
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
<xsl:when test="$docsType = 'Equity Swap (AEJ)' or $docsType = 'Equity Swap (Pan Asia)'">
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
<xsl:when test="$docsType = 'Equity Swap (Global)' or ($docsType = 'Equity Swap (Americas)' and $productType = 'Equity Index Swap')">
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
<xsl:if test="fpml:swBulletIndicator = 'true' and not(fpml:swInterestLegDriven = 'true') and not(fpml:swSchedulingMethod = 'ListDateEntry')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** If swBulletIndicator is 'true', swInterestLegDriven must be 'true'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swBulletIndicator = 'true' and fpml:swSchedulingMethod = 'ListDateEntry'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swBulletIndicator must not be 'true' for 'ListDateEntry' Scheduling Method.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swBulletIndicator">
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">swBulletIndicator</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swBulletIndicator"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swInterestLegDriven">
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">swInterestLegDriven</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swInterestLegDriven"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swScheduleFrequencies and not(fpml:swSchedulingMethod = 'ListDateEntry')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swScheduleFrequencies element encountered in this context. Schedule Frequency parameters can be passed explicitly only if swSchedulingMethod has a value of 'ListDateEntry' </text>
</error>
</xsl:if>
<xsl:if test="fpml:swStubControl and (fpml:swSchedulingMethod = 'ListDateEntry')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swStubControl element encountered in this context. Stub Control parameters not supported for 'ListDateEntry' mode. </text>
</error>
</xsl:if>
<xsl:if test="fpml:swSchedulingMethod = 'ListDateEntry' and fpml:swScheduleFrequencies">
<xsl:apply-templates select="fpml:swScheduleFrequencies">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
<xsl:if test="not(fpml:swSchedulingMethod = 'ListDateEntry')">
<xsl:apply-templates select="fpml:swStubControl">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
<xsl:variable name="swEarlyFinalValuationDateElectionFieldApplicable">
<xsl:choose>
<xsl:when test="$mcType = 'ISDA2009EquityEuropeanInterdealer' and not($optionalEarlyTermination = 'false')">true</xsl:when>
<xsl:when test="$mcType = 'EmergingEquitySwapIndustry' and not($optionalEarlyTermination = 'false')">true</xsl:when>
<xsl:when test="$mcType = 'EmergingEquitySwapLATAM' and not($optionalEarlyTermination = 'false')">true</xsl:when>
<xsl:when test="$mcType = 'EmergingEquitySwapEMEA' and not($optionalEarlyTermination = 'false')">true</xsl:when>
<xsl:when test="$mcType = 'EquitySwapAmericasPrivate' and not($optionalEarlyTermination = 'false')">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2009EquitySwapAmericas' and not($optionalEarlyTermination = 'false')">true</xsl:when>
<xsl:when test="$mcType = 'EquitySwapAEJPrivate' and not($optionalEarlyTermination = 'false')">true</xsl:when>
<xsl:when test="$mcType = 'EquitySwapEuropePrivate' and not($optionalEarlyTermination = 'false')">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2004EquityAmericasInterdealer' and not($optionalEarlyTermination = 'false')">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2005EquitySwapAsiaExcludingJapanInterdealer' and not($optionalEarlyTermination = 'false')">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2007EquityEuropean' and not($optionalEarlyTermination = 'false')">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2007EquityFinanceSwapEuropean' and not($optionalEarlyTermination = 'false')">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2009EquitySwapPanAsia' and not($optionalEarlyTermination = 'false')">true</xsl:when>
<xsl:when test="$mcType = 'EquitySwapPanAsiaPrivate' and not($optionalEarlyTermination = 'false')">true</xsl:when>
<xsl:when test="$mcType = 'EquitySwapGlobalPrivate' and not($optionalEarlyTermination = 'false')">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2008EquityFinanceSwapAsiaExcludingJapan' and not($optionalEarlyTermination = 'false') and $productType = 'Equity Share Swap'">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:if test="fpml:swEarlyFinalValuationDateElection and $swEarlyFinalValuationDateElectionFieldApplicable = 'false' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swEarlyFinalValuationDateElection element encountered in this context.</text>
</error>
</xsl:if>
<xsl:variable name="swEarlyTerminationElectingPartyApplicable">
<xsl:choose>
<xsl:when test="$mcType = 'EquitySwapAmericasPrivate' and not($optionalEarlyTermination = 'false')">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2009EquitySwapAmericas' and not($optionalEarlyTermination = 'false')">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2004EquityAmericasInterdealer' and not($optionalEarlyTermination = 'false')">true</xsl:when>
<xsl:when test="$mcType = 'EquitySwapAEJPrivate' and not($optionalEarlyTermination = 'false')">true</xsl:when>
<xsl:when test="$mcType = 'EquitySwapEuropePrivate' and not($optionalEarlyTermination = 'false')">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2007EquityEuropean' and not($optionalEarlyTermination = 'false')">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2007EquityFinanceSwapEuropean' and not($optionalEarlyTermination = 'false')">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2009EquityEuropeanInterdealer' and not($optionalEarlyTermination = 'false')">true</xsl:when>
<xsl:when test="$mcType = 'EmergingEquitySwapIndustry' and not($optionalEarlyTermination = 'false')">true</xsl:when>
<xsl:when test="$mcType = 'EmergingEquitySwapLATAM' and not($optionalEarlyTermination = 'false')">true</xsl:when>
<xsl:when test="$mcType = 'EmergingEquitySwapEMEA' and not($optionalEarlyTermination = 'false')">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2009EquitySwapPanAsia' and not($optionalEarlyTermination = 'false')">true</xsl:when>
<xsl:when test="$mcType = 'EquitySwapPanAsiaPrivate' and not($optionalEarlyTermination = 'false')">true</xsl:when>
<xsl:when test="$mcType = 'EquitySwapGlobalPrivate' and not($optionalEarlyTermination = 'false')">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2005EquitySwapAsiaExcludingJapanInterdealer' and not($optionalEarlyTermination = 'false')">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2008EquityFinanceSwapAsiaExcludingJapan' and not($optionalEarlyTermination = 'false') and $productType = 'Equity Share Swap'">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:if test="(fpml:swEarlyTerminationElectingParty or fpml:swEarlyTerminationElectingPartyMethod) and $swEarlyTerminationElectingPartyApplicable = 'false'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected fpml:swEarlyTerminationElectingParty or fpml:swEarlyTerminationElectingPartyMethod element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swEarlyTerminationElectingParty and $swEarlyFinalValuationDateElectionFieldApplicable = 'true' ">
<xsl:if test="fpml:swEarlyTerminationElectingParty[1]/@href = fpml:swEarlyTerminationElectingParty[2]/@href">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swEarlyTerminationElectingParty[1]/@href and swEarlyTerminationElectingParty[2]/@href values must not be the same.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$docsType='Equity Swap (Emerging)'">
<xsl:if test="fpml:swEarlyTerminationElectingParty or fpml:swEarlyTerminationElectingPartyMethod">
<xsl:if test="not(fpml:swEarlyTerminationElectingPartyMethod)">
<xsl:if test="not(string(fpml:noticePeriod[1]/fpml:noticeParty/@href) = string(//fpml:swEarlyTerminationElectingParty[1]/@href) and string(fpml:noticePeriod[2]/fpml:noticeParty/@href) = string(//fpml:swEarlyTerminationElectingParty[2]/@href))">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** noticePeriod parties are not consistent with swEarlyTerminationElectingParty, noticePeriod[1]="<xsl:value-of select="string(fpml:noticePeriod[1]/fpml:noticeParty/@href)"/>", swEarlyTerminationElectingParty[1]="<xsl:value-of select="string(//fpml:swEarlyTerminationElectingParty[1]/@href)"/>", noticePeriod[2]="<xsl:value-of select="string(fpml:noticePeriod[2]/fpml:noticeParty/@href)"/>", swEarlyTerminationElectingParty[2]="<xsl:value-of select="string(//fpml:swEarlyTerminationElectingParty[2]/@href)"/>". </text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:noticePeriod[1]/fpml:noticeParty/@href = fpml:noticePeriod[2]/fpml:noticeParty/@href">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** noticePeriod parties are not different.</text>
</error>
</xsl:if>
<xsl:for-each select="fpml:noticePeriod/fpml:numberOfDays">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">periodMultiplier</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:periodMultiplier"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">500</xsl:with-param>
<xsl:with-param name="maxDecs">0</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="fpml:businessDayConvention!='NotApplicable'">
<xsl:if test="fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swEquitySwapDetails/fpml:swSchedulingMethod!='ListDateEntry' or fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swEquitySwapDetails/fpml:swSchedulingMethod='' ">
<xsl:if test="fpml:businessDayConvention != //fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:returnLeg/fpml:effectiveDate/fpml:adjustableDate/fpml:dateAdjustments/fpml:businessDayConvention">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** value of businessDayConvention is different from /swStructuredTradeDetails/FpML/trade/equitySwapTransactionSupplement/returnLeg/effectiveDate/adjustableDate/dateAdjustments/businessDayConvention.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
</xsl:for-each>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:swBulletCompoundingSpread and not($mcType='EquitySwapAmericasPrivate' or $mcType='EquitySwapAEJPrivate' or $mcType='EquitySwapEuropePrivate' or $mcType='EquitySwapGlobalPrivate')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swBulletCompoundingSpread element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swBulletCompoundingSpread">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swBulletCompoundingSpread</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swBulletCompoundingSpread"/>
</xsl:with-param>
<xsl:with-param name="minIncl">-9.9999999</xsl:with-param>
<xsl:with-param name="maxIncl">9.9999999</xsl:with-param>
<xsl:with-param name="maxDecs">7</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swFixedRateIndicator">
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">swFixedRateIndicator</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swFixedRateIndicator"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swOtherValuationBusinessCenter and not(/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'EquitySwapAmericasPrivate') ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swOtherValuationBusinessCenter element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swReferenceInitialPrice">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swReferenceInitialPrice</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swReferenceInitialPrice"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.000001</xsl:with-param>
<xsl:with-param name="maxIncl">9999999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">6</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swReferenceFXRate">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swReferenceFXRate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swReferenceFXRate"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.000001</xsl:with-param>
<xsl:with-param name="maxIncl">99999.999999</xsl:with-param>
<xsl:with-param name="maxDecs">6</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swStockLoanRateIndicator = 'true' and not(/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swEquitySwapDetails/fpml:swStockLoanRate)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swStockLoanRate must be present where swStockLoanRateIndicator is 'true'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:stockLoanRateIndicator = 'true' and not(/fpml:SWDML/fpml:swShortFormTrade/fpml:swEquitySwapParameters/fpml:stockLoanRate)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** stockLoanRate must be present where stockLoanRateIndicator is 'true'.</text>
</error>
</xsl:if>
<xsl:variable name="swStockLoanExceptionApplicable">
<xsl:choose>
<xsl:when test="$mcType = 'EmergingEquitySwapIndustry'">true</xsl:when>
<xsl:when test="$mcType = 'EmergingEquitySwapLATAM'">true</xsl:when>
<xsl:when test="$mcType = 'EmergingEquitySwapEMEA'">true</xsl:when>
<xsl:when test="$mcType = 'EquitySwapEuropePrivate' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2009EquityEuropeanInterdealer' ">true</xsl:when>
<xsl:when test="$mcType = 'EquitySwapAEJPrivate' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2008EquityFinanceSwapAsiaExcludingJapan' ">true</xsl:when>
<xsl:when test="$mcType = 'EquitySwapAmericasPrivate' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2009EquitySwapAmericas' ">true</xsl:when>
<xsl:when test="$mcType = 'EquitySwapPanAsiaPrivate' ">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:if test="not($productType = 'Equity Share Swap' and $swStockLoanExceptionApplicable = 'true')">
<xsl:if test="(fpml:swStockLoanRate/fpml:maximumStockLoanRate and not(fpml:swStockLoanRate/fpml:initialStockLoanRate)) or (fpml:stockLoanRate/fpml:maximumStockLoanRate and not(fpml:stockLoanRate/fpml:initialStockLoanRate))">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** When maximumStockLoan rate is supplied, initialStockLoanRate is required.</text>
</error>
</xsl:if>
<xsl:if test="(fpml:swStockLoanRate/fpml:initialStockLoanRate and not(fpml:swStockLoanRate/fpml:maximumStockLoanRate)) or (fpml:stockLoanRate/fpml:initialStockLoanRate and not(fpml:stockLoanRate/fpml:maximumStockLoanRate))">
<xsl:if test="not($mcType = 'EquitySwapGlobalPrivate')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** When initialStockLoan rate is supplied, maximumStockLoanRate is required.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:swADTVIndicator = 'true' and not(/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:averageDailyTradingVolume)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** fpml:averageDailyTradingVolume must be present where swADTVIndicator is 'true'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swADTVIndicator and not($docsType = 'Equity Swap (Americas)')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swADTVIndicator element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swADTVIndicator and $docsSubType = 'Private'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swADTVIndicator element encountered in this context. Not supported for 'Private' Docs Sub Type.</text>
</error>
</xsl:if>
<xsl:variable name="swStockLoanRateFieldApplicable">
<xsl:choose>
<xsl:when test="$mcType = 'EquitySwapGlobalPrivate'">true</xsl:when>
<xsl:when test="$productType = 'Equity Share Swap' and $swStockLoanExceptionApplicable">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:if test="fpml:swStockLoanRate and swStockLoanRateFieldApplicable = 'false' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swStockLoanRate element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swADTVIndicator and not($productType = 'Equity Share Swap')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swADTVIndicator element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:swNotionalCurrency) and ($productType = 'Equity Share Swap' or $productType = 'Equity Index Swap' or $productType = 'Equity Basket Swap') and not(/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:returnLeg/fpml:notional/fpml:notionalAmount/fpml:currency) and /fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:returnLeg/fpml:rateOfReturn/fpml:initialPrice/fpml:determinationMethod">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing element swNotionalCurrency when Notional is not known for a Forward Starting Swap.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swNotionalCurrency and ($productType = 'Equity Share Swap' or $productType = 'Equity Index Swap' or $productType = 'Equity Basket Swap') and /fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:returnLeg/fpml:notional/fpml:notionalAmount/fpml:currency and (fpml:swNotionalCurrency != /fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:returnLeg/fpml:notional/fpml:notionalAmount/fpml:currency)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swNotionalCurrency "<xsl:value-of select="fpml:swNotionalCurrency"/>" must equal Equity notionalAmount/currency ''<xsl:value-of select="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:returnLeg/fpml:notional/fpml:notionalAmount/fpml:currency"/>'' when Notional is known for a Forward Starting Swap.</text>
</error>
</xsl:if>
<xsl:if test="$productType = 'Equity Index Swap' and (//fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'ISDA2009EquitySwapAmericas')">
<xsl:if test="fpml:swStockLoanRateIndicator = 'true' and not(fpml:swAdditionalDisruptionEventIndicator = 'true') ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swStockLoanRateIndicator can be 'true' only if swAdditionalDisruptionEventIndicator is 'true' in this context.</text>
</error>
</xsl:if>
<xsl:if test="//fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:extraordinaryEvents/fpml:additionalDisruptionEvents/fpml:insolvencyFiling = 'true' and not(fpml:swAdditionalDisruptionEventIndicator = 'true') ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** additionalDisruptionEvents/insolvencyFiling can be 'true' only if swAdditionalDisruptionEventIndicator is 'true' in this context.</text>
</error>
</xsl:if>
<xsl:if test="//fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:extraordinaryEvents/fpml:additionalDisruptionEvents/fpml:lossOfStockBorrow  = 'true' and not(fpml:swAdditionalDisruptionEventIndicator = 'true') ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** additionalDisruptionEvents/lossOfStockBorrow can be 'true' only if swAdditionalDisruptionEventIndicator is 'true' in this context.</text>
</error>
</xsl:if>
<xsl:if test="//fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:extraordinaryEvents/fpml:additionalDisruptionEvents/fpml:increasedCostOfStockBorrow = 'true' and not(fpml:swAdditionalDisruptionEventIndicator = 'true') ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** additionalDisruptionEvents/increasedCostOfStockBorrow can be 'true' only if swAdditionalDisruptionEventIndicator is 'true' in this context.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:swFinalPriceFeeAmount and not($mcType = 'EquitySwapGlobalPrivate')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swFinalPriceFeeAmount element not supported by this MCA.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swFinalPriceFeeAmount and fpml:swFinalPriceFee">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swFinalPriceFee and swFinalPriceFeeAmount elements are mutually exclusive.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swFinalPriceFee">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swFinalPriceFee</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swFinalPriceFee"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">9.99999999</xsl:with-param>
<xsl:with-param name="maxDecs">8</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swFinalPriceFeeAmount">
<xsl:if test="fpml:swFinalPriceFeeAmount/fpml:amount">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swFinalPriceFeeAmount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swFinalPriceFeeAmount/fpml:amount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">999999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swFinalPriceFeeAmount/fpml:currency">
<xsl:call-template name="isValidCurrency">
<xsl:with-param name="elementName">currency</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swFinalPriceFeeAmount/fpml:currency"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:for-each select="fpml:swDividendPercentageComponent">
<xsl:if test="fpml:dividendPercentageComponent">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">dividendPercentageComponenet</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:dividendPercentageComponent"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.0000001</xsl:with-param>
<xsl:with-param name="maxIncl">999.9999999</xsl:with-param>
<xsl:with-param name="maxDecs">7</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
</xsl:for-each>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:swScheduleFrequencies">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="fpml:swPaymentDateOffset">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swPaymentDateOffset</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swPaymentDateOffset"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">999</xsl:with-param>
<xsl:with-param name="maxDecs">0</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swFixingDayOffset">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swFixingDayOffset</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swFixingDayOffset"/>
</xsl:with-param>
<xsl:with-param name="minIncl">-999</xsl:with-param>
<xsl:with-param name="maxIncl">0</xsl:with-param>
<xsl:with-param name="maxDecs">0</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swValuationDate">
<xsl:call-template name="isValidPeriodMultiplier">
<xsl:with-param name="elementName">periodMultiplier</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swValuationDate/fpml:periodMultiplier"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="isValidPeriod">
<xsl:with-param name="elementName">period</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swValuationDate/fpml:period"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swCompoundingDate">
<xsl:call-template name="isValidPeriodMultiplier">
<xsl:with-param name="elementName">periodMultiplier</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swCompoundingDate/fpml:periodMultiplier"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="isValidPeriod">
<xsl:with-param name="elementName">period</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swCompoundingDate/fpml:period"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swInterestLegPaymentDate">
<xsl:call-template name="isValidPeriodMultiplier">
<xsl:with-param name="elementName">periodMultiplier</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swInterestLegPaymentDate/fpml:periodMultiplier"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="isValidPeriod">
<xsl:with-param name="elementName">period</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swInterestLegPaymentDate/fpml:period"/>
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
<xsl:template match="fpml:swStubControl | fpml:stubControl">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="fpml:swEquityFrontStub">
<xsl:if test="not(fpml:swEquityFrontStub='Long' or fpml:swEquityFrontStub='Short') ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid Equity Front Stub value. The value must be 'Long' or 'Short'. Value = '<xsl:value-of select="fpml:swEquityFrontStub"/>'</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:swEquityEndStub">
<xsl:if test="not(fpml:swEquityEndStub='Long' or fpml:swEquityEndStub='Short') ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid Equity End Stub value. The value must be 'Long' or 'Short'. Value = '<xsl:value-of select="fpml:swEquityEndStub"/>'</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:swInterestFrontStub">
<xsl:if test="not(fpml:swInterestFrontStub='Long' or fpml:swInterestFrontStub='Short') ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid Interest Front Stub value. The value must be 'Long' or 'Short'. Value = '<xsl:value-of select="fpml:swInterestFrontStub"/>'</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:swInterestEndStub">
<xsl:if test="not(fpml:swInterestEndStub='Long' or fpml:swInterestEndStub='Short') ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid Interest End Stub value. The value must be 'Long' or 'Short'. Value = '<xsl:value-of select="fpml:swInterestEndStub"/>'</text>
</error>
</xsl:if>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:swDeltaCrossShortForm">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="fpml:buyerPartyReference/@href=//fpml:swEquityOptionParameters/fpml:buyerPartyReference/@href"/>
<xsl:when test="fpml:buyerPartyReference/@href=//fpml:swEquityOptionParameters/fpml:sellerPartyReference/@href"/>
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
<xsl:when test="fpml:sellerPartyReference/@href=//fpml:swEquityOptionParameters/fpml:sellerPartyReference/@href"/>
<xsl:when test="fpml:sellerPartyReference/@href=//fpml:swEquityOptionParameters/fpml:buyerPartyReference/@href"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid sellerPartyReference/@href attribute value. Value = '<xsl:value-of select="fpml:sellerPartyReference/@href"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
<xsl:if test="fpml:buyerPartyReference/@href = fpml:sellerPartyReference/@href">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** buyerPartyReference/@href and sellerPartyReference/@href values are the same.</text>
</error>
</xsl:if>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swQuantity</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swQuantity"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">9999999999.99999</xsl:with-param>
<xsl:with-param name="maxDecs">5</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:apply-templates select="fpml:swPrice">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:swDelta">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swDelta</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swDelta"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">99.9999999</xsl:with-param>
<xsl:with-param name="maxDecs">7</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:maturity">
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">maturity</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:maturity"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="//fpml:swEquityOptionParameters/fpml:swIndexUnderlyer and not(fpml:maturity)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** If swIndexUnderlyer is present maturity must be present </text>
</error>
</xsl:if>
<xsl:if test="fpml:swOffshoreCross and not($docsType='Equity Options (AEJ)' and $productType = 'Equity Share Option' or $productType = 'Equity Share Option Strategy')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swOffshoreCross in this context. This element may only be used with AEJ Share Options.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swOffshoreCross and  $docsType='Equity Options (AEJ)'">
<xsl:call-template name="isValidBusinessCenter">
<xsl:with-param name="elementName">swOffshoreCrossLocation</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swOffshoreCross/fpml:swOffshoreCrossLocation"/>
</xsl:with-param>
<xsl:with-param name="assetClass">
<xsl:value-of select="$assetClass"/>
</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swCrossExchangeId and not(($productType='Equity Share Option' or $productType='Equity Share Option Strategy') and ($docsType='Equity Options (Americas)' or $docsType='Equity Swap (Americas)' or $docsType='Equity Options (EMEA)'))">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swCrossExchangeId in this context. This element may only be used for product type 'Equity Share Option' or 'Equity Share Option Strategy', Docs Type 'Equity Options (Americas)' or 'Equity Swap (Americas)' or 'Equity Options (EMEA)' </text>
</error>
</xsl:if>
<xsl:if test="not($docsType='Equity Options (EMEA)') ">
<xsl:if test="fpml:swCrossExchangeId and ($productType='Equity Share Option' or $productType='Equity Share Option Strategy') and $docsType='Equity Options (Americas)' and (//fpml:swPremium/fpml:paymentAmount/fpml:currency='USD' or //swSettlementCurrency='USD')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected (Equity Options) swCrossExchangeId in this context. This element may only be used for product type 'Equity Share Option' or 'Equity Share Option Strategy', Docs Type 'Equity Options (Americas)', and currency 'USD' </text>
</error>
</xsl:if>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:deltaCrossShortForm">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="fpml:buyerPartyReference/@href=//fpml:swEquitySwapParameters/fpml:buyerPartyReference/@href"/>
<xsl:when test="fpml:buyerPartyReference/@href=//fpml:swEquitySwapParameters/fpml:sellerPartyReference/@href"/>
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
<xsl:when test="fpml:sellerPartyReference/@href=//fpml:swEquitySwapParameters/fpml:sellerPartyReference/@href"/>
<xsl:when test="fpml:sellerPartyReference/@href=//fpml:swEquitySwapParameters/fpml:buyerPartyReference/@href"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid sellerPartyReference/@href attribute value. Value = '<xsl:value-of select="fpml:sellerPartyReference/@href"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
<xsl:if test="fpml:buyerPartyReference/@href = fpml:sellerPartyReference/@href">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** buyerPartyReference/@href and sellerPartyReference/@href values are the same.</text>
</error>
</xsl:if>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swQuantity</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swQuantity"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">9999999999.99999</xsl:with-param>
<xsl:with-param name="maxDecs">5</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:apply-templates select="fpml:swPrice">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:swCrossExchangeId and not($docsType='Equity Swap (Americas)')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swCrossExchangeId in this context. This element may only be used for 'Equity Swap (Americas)' </text>
</error>
</xsl:if>
<xsl:if test="not(fpml:swCrossExchangeId) and $docsType='Equity Swap (Americas)' and not(//fpml:deltaCrossShortForm/fpml:swPrice/fpml:currency='CAD')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swCrossExchangeId is mssing.  It is needed for Docs Type 'Equity Swaps(Americas)' and currency != 'CAD' </text>
</error>
</xsl:if>
<xsl:if test="(fpml:swCrossExchangeId) and $docsType='Equity Swap (Americas)' and (//fpml:deltaCrossShortForm/fpml:swPrice/fpml:currency='CAD')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swCrossExchangeId in this context.  It must not be present for Docs Type 'Equity Swaps(Americas)' and currency 'CAD' </text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:swDeltaCross">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="fpml:buyerPartyReference/@href=/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:buyerPartyReference/@href"/>
<xsl:when test="fpml:buyerPartyReference/@href=/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:sellerPartyReference/@href"/>
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
<xsl:when test="fpml:sellerPartyReference/@href=/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:buyerPartyReference/@href"/>
<xsl:when test="fpml:sellerPartyReference/@href=/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:sellerPartyReference/@href"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid sellerPartyReference/@href attribute value. Value = '<xsl:value-of select="fpml:sellerPartyReference/@href"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
<xsl:if test="fpml:buyerPartyReference/@href = fpml:sellerPartyReference/@href">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** buyerPartyReference/@href and sellerPartyReference/@href values are the same.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:equity) and ($productType = 'Equity Share Option' or  $productType ='Equity Share Option Strategy')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing equity element when product type is 'Equity Share Option' or 'Equity Share Option Strategy'.</text>
</error>
</xsl:if>
<xsl:if test="$productType = 'Equity Share Option' or $productType='Equity Share Option Strategy'">
<xsl:if test="not(fpml:equity/fpml:instrumentId = //fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:underlyer/fpml:singleUnderlyer/fpml:equity/fpml:instrumentId)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The equity/instrumentId must equal the //FpML/trade/equityOptionTransactionSupplement/underlyer/singleUnderlyer/equity/instrumentId.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:equity|fpml:future">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:swPrice">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swQuantity</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swQuantity"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">9999999999.99999</xsl:with-param>
<xsl:with-param name="maxDecs">5</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="fpml:swDelta">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swDelta</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swDelta"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">99.9999999</xsl:with-param>
<xsl:with-param name="maxDecs">7</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="//fpml:swDelta and ($productType = 'Equity Index Swap' or $productType='Equity Share Swap' or $productType= 'Equity Basket Swap')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swDelta is unexpected for Equity Swap Transactions.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swOffshoreCross and not($docsType='Equity Options (AEJ)' and $productType = 'Equity Share Option' or $productType='Equity Share Option Strategy')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swOffshoreCross in this context. This element may only be used with AEJ Share Options.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swOffshoreCross and  $docsType='Equity Options (AEJ)'">
<xsl:call-template name="isValidBusinessCenter">
<xsl:with-param name="elementName">swOffshoreCrossLocation</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swOffshoreCross/fpml:swOffshoreCrossLocation"/>
</xsl:with-param>
<xsl:with-param name="assetClass">
<xsl:value-of select="$assetClass"/>
</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swCrossExchangeId and not(($productType='Equity Share Option' or $productType='Equity Share Option Strategy' or $productType='Equity Share Swap') and ($docsType='Equity Options (Americas)' or $docsType='Equity Swap (Americas)' or $docsType='Equity Options (EMEA)'))">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swCrossExchangeId in this context. This element may only be used for product type 'Equity Share Option' or 'Equity Share Option Strategy' or 'Equity Share Swap', Docs Type 'Equity Options (Americas)' or 'Equity Swap (Americas)' or 'Equity Options (EMEA)' </text>
</error>
</xsl:if>
<xsl:if test="fpml:swCrossExchangeId and ($productType='Equity Share Option' or $productType='Equity Share Option Strategy') and $docsType='Equity Options (Americas)' and (//fpml:swPremium/fpml:paymentAmount/fpml:currency='USD' or //swSettlementCurrency='USD')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected (Equity Options) swCrossExchangeId in this context. This element may only be used for product type 'Equity Share Option' or 'Equity Share Option Strategy', Docs Type 'Equity Options (Americas)', and currency 'USD' </text>
</error>
</xsl:if>
<xsl:if test="fpml:swDeltaStrategyLeg and not(/fpml:SWDML//fpml:swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swEquityOptionDetails/fpml:swEquityOptionStrategy)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swDeltaStrategyLeg element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swDeltaStrategyQuantity and not(/fpml:SWDML//fpml:swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swEquityOptionDetails/fpml:swEquityOptionStrategy)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swDeltaStrategyQuantity element encountered in this context.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:swEquityOptionPercentInput">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="ancestor::fpml:swLongFormTrade and ($docsType = 'Equity Options (Europe)' or $docsType = 'Equity Options (Spread)')">
<xsl:if test="fpml:swHedgeLevel">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swHedgeLevel element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swBasis">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swBasis element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swImpliedLevel">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swImpliedLevel element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swPremiumPercentage">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swPremiumPercentage element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swNotional">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swNotional element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swStrikePercentage">
<xsl:if test="//fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:strike/fpml:strikePercentage or //fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:strike/fpml:strikeDeterminationDate">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** You cannot supply swStrikePercentage and strikePercentage on the same trade. Supply strikePercentage for forward starting trades.</text>
</error>
</xsl:if>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swStrikePercentage</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swStrikePercentage"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">99.9999999</xsl:with-param>
<xsl:with-param name="maxDecs">7</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
</xsl:when>
<xsl:otherwise>
<xsl:if test="ancestor::fpml:swLongFormTrade">
<xsl:if test="not(//fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:equityPremium/fpml:pricePerOption/fpml:amount)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing Price element. You must supply pricePerOption/amount for % input trades. Required in this context.</text>
</error>
</xsl:if>
<xsl:if test="not($mcType = 'ISDA2008EquityJapanese' or $mcType = 'ISDA2005EquityJapaneseInterdealer')">
<xsl:if test="not(/fpml:SWDML//fpml:swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swEquityOptionDetails/fpml:swEquityOptionPercentInput/fpml:swPremiumPercentage)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swPremiumPercentage element. You must supply swPremiumPercentage for % input trades. Required in this context.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="not (//fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:equityPremium/fpml:paymentAmount/fpml:amount) ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing Price element. You must supply paymentAmount/amount for % input trades. Required in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swEquityOptionPercentInput and fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:strike/fpml:strikePrice  and not(/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swEquityOptionDetails/fpml:swEquityOptionPercentInput/fpml:swStrikePercentage)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swStrikePercentage element. You must supply swStrikePercentage for % input trades unless the trade is forward starting. Required in this context.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="ancestor::fpml:swShortFormTrade">
<xsl:if test="not($mcType = 'ISDA2008EquityJapanese' or $mcType = 'ISDA2005EquityJapaneseInterdealer')">
<xsl:if test="not(fpml:swPremiumPercentage)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swPremiumPercentage element. You must supply swPremiumPercentage for % input trades. Required in this context.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="not(fpml:swStrikePercentage)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swStrikePercentage element. You must supply swStrikePercentage for % input trades. Required in this context.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="not ($docsType = 'Equity Options (AEJ)' or $docsType = 'Equity Options (Japan)' or $docsType= 'Equity Options (Americas)')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swEquityOptionPercentInput element encountered in this context. Element must not be present if product is not on a Japanese, Americas or AEJ Underlier. Value = '<xsl:value-of select="$docsType"/>'</text>
</error>
</xsl:if>
<xsl:if test="not ($productType!='Equity Index Option' or $productType!='Equity Share Option')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swEquityOptionPercentInput element encountered in this context. Element must not be present if product is not an Equity Index Option or Equity Share Option.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:swHedgeLevel)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swHedgeLevel element encountered in this context. Element must be present if swEquityOptionPercentInput is present.</text>
</error>
</xsl:if>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swHedgeLevel</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swHedgeLevel"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.000001</xsl:with-param>
<xsl:with-param name="maxIncl">9999999.999999</xsl:with-param>
<xsl:with-param name="maxDecs">6</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="$productType = 'Equity Share Option'">
<xsl:if test="fpml:swBasis">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swBasis should only be specified on Index Options.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$productType = 'Equity Share Option'">
<xsl:if test="fpml:swImpliedLevel">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swImpliedLevel should only be specified on Index Options.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:swBasis">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swBasis</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swBasis"/>
</xsl:with-param>
<xsl:with-param name="minIncl">-9999999.999999</xsl:with-param>
<xsl:with-param name="maxIncl">9999999.999999</xsl:with-param>
<xsl:with-param name="maxDecs">6</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swImpliedLevel">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swImpliedLevel</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swImpliedLevel"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.000001</xsl:with-param>
<xsl:with-param name="maxIncl">9999999.999999</xsl:with-param>
<xsl:with-param name="maxDecs">6</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swPremiumPercentage">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swPremiumPercentage</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swPremiumPercentage"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">9999999.9999999</xsl:with-param>
<xsl:with-param name="maxDecs">7</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swStrikePercentage">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swStrikePercentage</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swStrikePercentage"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">99.9999999</xsl:with-param>
<xsl:with-param name="maxDecs">7</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swNotional">
<xsl:if test="not(/fpml:SWDML//fpml:swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swEquityOptionDetails/fpml:swEquityOptionPercentInput/fpml:swNotional/fpml:currency='USD')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected Currency found in this context Currency must be 'USD' in this context. </text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:swNotional">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swNotional</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swNotional/fpml:amount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">9999999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template match="fpml:swAveragingDates">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="not(/fpml:SWDML//fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:feature)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Expected fpml:feature element not encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swAveragingFrequency">
<xsl:if test="not(fpml:swAveragingFrequency ='Custom' or fpml:swAveragingFrequency ='1 Day' or fpml:swAveragingFrequency ='1 Week' or fpml:swAveragingFrequency ='Fortnightly' or fpml:swAveragingFrequency ='4 Weekly' or fpml:swAveragingFrequency ='1m' or fpml:swAveragingFrequency ='2m' or fpml:swAveragingFrequency ='3m' or fpml:swAveragingFrequency ='Asian Tail')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***swAveragingFrequency must be equal to 'Custom' in this context.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:swAveragingDateAdjustments/fpml:businessDayConvention and $productType = 'Equity Index Option'">
<xsl:if test="not(fpml:swAveragingDateAdjustments/fpml:businessDayConvention = /fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:equityExercise//fpml:expirationDate/fpml:adjustableDate/fpml:dateAdjustments/fpml:businessDayConvention)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***Expiration Date Convention and Averaging Date Convention must be equal for 'Equity Index Options' in this context.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:swEquityOptionStrategy">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="/fpml:SWDML//fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:strike/fpml:strikeDeterminationDate and fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swEquityOptionDetails/fpml:swEquityOptionStrategy/fpml:swEquityOptionStrategyDetails/fpml:strike/fpml:strikePrice">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected Strategy strikePrice element encountered. If leg one of a strategy stipulates forward starting percentages, all subsequent legs must also do so.</text>
</error>
</xsl:if>
<xsl:if test="/fpml:SWDML//fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:strike/fpml:strikePrice and fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swEquityOptionDetails/fpml:swEquityOptionStrategy/fpml:swEquityOptionStrategyDetails/fpml:strike/fpml:strikeDeterminationDate">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected Strategy strikeDeterminationDate element encountered. If leg one of a strategy stipulates absolute strike, all subsequent legs must also do so.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swEquityOptionStrategyDetails/fpml:strike/fpml:strikePercentage">
<xsl:if test="fpml:swEquityOptionStrategyDetails/fpml:strike/fpml:strikePercentage and ($docsType != 'Equity Options (Europe)' and $docsType != 'Equity Options (AEJ)' and $docsType != 'Equity Options (Spread)')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected strikePercentage element encountered in this context. Forward-starting options are only supported under the European, Spread and AEJ Options MCA. Submitted Docs Type = '<xsl:value-of select="$docsType"/>'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swEquityOptionStrategyDetails/fpml:strike/fpml:strikePrice">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected strikePrice element encountered in this context. Forward-starting trades should have their strike expressed as a strikePercentage to be determined on the strikDeterminationDate.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:swEquityOptionStrategyDetails/fpml:strike/fpml:strikeDeterminationDate)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing strikeDeterminationDate element in this context. Forward-starting trades should have their strike expressed as a strikePercentage to be determined on the strikeDeterminationDate.</text>
</error>
</xsl:if>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">strikePercentage</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swEquityOptionStrategyDetails/fpml:strike/fpml:strikePercentage"/>
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
<xsl:value-of select="fpml:swEquityOptionStrategyDetails/fpml:strike/fpml:strikeDeterminationDate/fpml:adjustableDate/fpml:unadjustedDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="fpml:swEquityOptionStrategyDetails/fpml:strike/fpml:currency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected currency element encountered in this context when trade is forward starting.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="//fpml:SWDML//fpml:swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swEquityOptionDetails/fpml:swEquityOptionStrategy/swEquityOptionStrategyDetails/swHedgeLevel">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swHedgeLevel element encountered in this context. swHedgeLevel should only be suppied once with swEquityOptionDetails/swEquityOptionPercentInput</text>
</error>
</xsl:if>
<xsl:if test="//fpml:SWDML//fpml:swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swEquityOptionDetails/fpml:swEquityOptionStrategy/swEquityOptionStrategyDetails/swBasis">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swBasis element encountered in this context. swBasis should only be suppied once with swEquityOptionDetails/swEquityOptionPercentInput</text>
</error>
</xsl:if>
<xsl:if test="//fpml:SWDML//fpml:swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swEquityOptionDetails/fpml:swEquityOptionStrategy/swEquityOptionStrategyDetails/swImpliedLevel">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swImpliedLevel element encountered in this context. swImpliedLevel should only be suppied once with swEquityOptionDetails/swEquityOptionPercentInput</text>
</error>
</xsl:if>
<xsl:if test="fpml:swEquityOptionStrategyDetails/fpml:swPremiumPercentage">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swPremiumPercentage</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swEquityOptionStrategyDetails/fpml:swPremiumPercentage"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">99.9999999</xsl:with-param>
<xsl:with-param name="maxDecs">7</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swEquityOptionStrategyDetails/fpml:swStrikePercentage">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swStrikePercentage</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swEquityOptionStrategyDetails/fpml:swStrikePercentage"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">99.9999999</xsl:with-param>
<xsl:with-param name="maxDecs">7</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swEquityOptionStrategyDetails/fpml:swNotional">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swNotional</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swEquityOptionStrategyDetails/fpml:swNotional/fpml:amount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">9999999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="/fpml:SWDML//fpml:swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swEquityOptionDetails/fpml:swDeltaCross">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swDeltaStrategyLeg</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="/fpml:SWDML//fpml:swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swEquityOptionDetails/fpml:swDeltaCross/fpml:swDeltaStrategyLeg"/>
</xsl:with-param>
<xsl:with-param name="minIncl">1</xsl:with-param>
<xsl:with-param name="maxIncl">4</xsl:with-param>
<xsl:with-param name="maxDecs">0</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swDeltaStrategyQuantity</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="/fpml:SWDML//fpml:swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swEquityOptionDetails/fpml:swDeltaCross/fpml:swDeltaStrategyQuantity"/>
</xsl:with-param>
<xsl:with-param name="minIncl">1</xsl:with-param>
<xsl:with-param name="maxIncl">999999999.99999</xsl:with-param>
<xsl:with-param name="maxDecs">5</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="not(fpml:swStrategy/fpml:swStrategyType)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Expected fpml:swStrategyType element not encountered in this context.</text>
</error>
</xsl:if>
<xsl:call-template name="isValidStrategyType">
<xsl:with-param name="elementName">swStrategyType</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swStrategy/fpml:swStrategyType"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:variable name="StrategyType">
<xsl:value-of select="fpml:swStrategy/fpml:swStrategyType"/>
</xsl:variable>
<xsl:if test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:feature/fpml:asian/fpml:averagingInOut and not($StrategyType = 'Spread')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid swStrategyType element value. Strategy Type must be 'Spread' for Strategy with Averaging.</text>
</error>
</xsl:if>
<xsl:if test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:feature/fpml:asian/fpml:averagingInOut and not(/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:equityExercise/fpml:equityEuropeanExercise)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Expected fpml:equityEuropeanExercise element not encountered in this context. Option Style must be European for Strategy with Averaging.</text>
</error>
</xsl:if>
<xsl:variable name="swStrategyComment">
<xsl:value-of select="fpml:swStrategy/fpml:swStrategyComment"/>
</xsl:variable>
<xsl:if test="string-length($swStrategyComment) &gt; 2000">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid swStrategyComment element value length. Exceeded max length of 2000 characters.</text>
</error>
</xsl:if>
<xsl:for-each select="fpml:swEquityOptionStrategyDetails">
<xsl:if test="not(fpml:buyerPartyReference/@href = /fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement//@href)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid buyerPartyReference/@href attribute value. The buyerPartyReference/@href must be equal to //FpML/trade/equityOptionTransactionSupplement//@href</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:sellerPartyReference/@href = /fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement//@href)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid sellerPartyReference/@href attribute value. The sellerPartyReference/@href must be equal to //FpML/trade/equityOptionTransactionSupplement//@href</text>
</error>
</xsl:if>
<xsl:variable name="StrategyLegId">
<xsl:value-of select="@id"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$StrategyLegId != ''"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Empty fpml:swEquityOptionStrategyDetails/@id attribute.</text>
</error>
</xsl:otherwise>
</xsl:choose>
<xsl:if test="$StrategyType = 'Butterfly' or $StrategyType = 'Option with Synthetic Fwd'">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">strategyLegId</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="@id"/>
</xsl:with-param>
<xsl:with-param name="minIncl">1</xsl:with-param>
<xsl:with-param name="maxIncl">2</xsl:with-param>
<xsl:with-param name="maxDecs">0</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="$StrategyType = 'Calendar Spread' or $StrategyType = 'Risk Reversal' or $StrategyType = 'Ratio Spread' or $StrategyType = 'Spread' or $StrategyType = 'Straddle' or $StrategyType = 'Strangle' or $StrategyType = 'Synthetic Underlying'">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">strategyLegId</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="@id"/>
</xsl:with-param>
<xsl:with-param name="minIncl">1</xsl:with-param>
<xsl:with-param name="maxIncl">1</xsl:with-param>
<xsl:with-param name="maxDecs">0</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="$StrategyType = 'Custom' or $StrategyType = 'Synthetic Roll'">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">strategyLegId</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="@id"/>
</xsl:with-param>
<xsl:with-param name="minIncl">1</xsl:with-param>
<xsl:with-param name="maxIncl">3</xsl:with-param>
<xsl:with-param name="maxDecs">0</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="not(fpml:optionType='Call' or fpml:optionType='Put')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***Unexpected optionType value</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:strike">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:pricePerOption">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:variable name="id">
<xsl:value-of select="./fpml:pricePerOption/@id"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$id = '' "/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected pricePerOption/@id attribute found.</text>
</error>
</xsl:otherwise>
</xsl:choose>
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">expirationDate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:expirationDate//fpml:unadjustedDate"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:variable name="id2">
<xsl:value-of select="fpml:expirationDate/@id"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$id2 = '' "/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected expirationDate/@id attribute found.</text>
</error>
</xsl:otherwise>
</xsl:choose>
<xsl:if test="not(fpml:expirationDate//fpml:dateAdjustments/fpml:businessDayConvention[.='NotApplicable']) and not($productType ='Equity Index Option Strategy')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid businessDayConvention element value. Must contain 'NotApplicable' when product type is 'Equity Share Option', 'Equity Index Option', 'Equity Share Option Strategy'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:expirationDate//fpml:dateAdjustments/fpml:businessCenters">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected businessCenters element encountered in this context when product type is 'Equity Share Option', 'Equity Index Option', 'Equity Share Option Strategy' or 'Equity Index Option Strategy'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:expirationDate//fpml:dateAdjustments/fpml:businessCentersReference">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected businessCentersReference element encountered in this context.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:paymentAmount">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:variable name="id3">
<xsl:value-of select="./fpml:paymentAmount/@id"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$id3 = '' "/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected fpml:paymentAmount/@id attribute found.</text>
</error>
</xsl:otherwise>
</xsl:choose>
<xsl:if test="not(fpml:paymentAmount/fpml:currency = fpml:pricePerOption/fpml:currency) and $docsType!='Equity Options (Cliquet)' and $docsType!='Equity Options (Spread)'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The paymentAmount/currency and pricePerOption/currency must be equal.</text>
</error>
</xsl:if>
</xsl:for-each>
</xsl:template>
<xsl:template match="fpml:swPaymentAmount">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
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
<xsl:if test="$docsType='Equity Options (Japan)'">
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
</xsl:template>
<xsl:template match="fpml:swPrice">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="not($docsType='Equity Options (EMEA)' or $docsType='Equity Options (Europe)')">
<xsl:if test="ancestor::fpml:swLongFormTrade">
<xsl:if test="not(fpml:currency = //fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:equityPremium/fpml:paymentAmount/fpml:currency) and not( /fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:fxFeature)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The currency must equal equityPremium/paymentAmount/currency when option is Vanilla settled.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="ancestor::fpml:swLongFormTrade">
<xsl:if test="not(fpml:currency = //fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:fxFeature/fpml:referenceCurrency) and /fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:fxFeature">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The currency must equal fxFeature/referenceCurrency when option is not Vanilla settled.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="ancestor::fpml:swShortFormTrade">
<xsl:if test="not(fpml:currency = //fpml:swPremium/fpml:paymentAmount/fpml:currency) and ( //fpml:swCashSettlementType = 'Vanilla')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The currency must equal swPremium/paymentAmount/currency when option is Vanilla settled.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="ancestor::fpml:swShortFormTrade and //fpml:SWDML/fpml:swShortFormTrade/fpml:swEquityOptionParameters/fpml:swReferenceCurrency">
<xsl:if test="$docsType='Equity Options (AEJ)' and not(fpml:currency = //fpml:swReferenceCurrency) and not( //fpml:swCashSettlementType = 'Vanilla')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The currency must equal swReferenceCurrency when option is not Vanilla settled.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
<xsl:if test="$productType = 'Equity Share Option' or $productType ='Equity Share Option Strategy'">
<xsl:choose>
<xsl:when test="$docsType='Equity Options (Europe)' or $docsType='Equity Options (Americas)' or $docsType='Equity Options (EMEA)' ">
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
<xsl:when test="$docsType='Equity Options (Japan)' or $docsType='Equity Options (AEJ)'">
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
<text>*** Empty or invalid masterConfirmationType element. Value = '<xsl:value-of select="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="$productType='Equity Index Option' or $productType='Equity Index Option Strategy'">
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
<xsl:if test="fpml:partyTradeInformation">
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
<xsl:if test="$productType = 'Equity Share Option' or $productType = 'Equity Index Option' or $productType = 'Equity Share Option Strategy' or $productType = 'Equity Index Option Strategy'">
<xsl:choose>
<xsl:when test="fpml:partyReference/@href=/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:buyerPartyReference/@href"/>
<xsl:when test="fpml:partyReference/@href=/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:sellerPartyReference/@href"/>
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
<xsl:when test="fpml:partyReference/@href=/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:buyerPartyReference/@href"/>
<xsl:when test="fpml:partyReference/@href=/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:sellerPartyReference/@href"/>
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
<xsl:if test="$productType = 'Equity Share Swap' or $productType = 'Equity Index Swap' or $productType = 'Equity Basket Swap' ">
<xsl:if test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:buyerPartyReference">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected buyerPartyReference element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:sellerPartyReference">
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
<xsl:if test="$productType = 'Equity Share Option' or $productType = 'Equity Index Option' or $productType = 'Equity Share Option Strategy' or $productType = 'Equity Index Option Strategy'">
<xsl:choose>
<xsl:when test="fpml:partyReference/@href=/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:buyerPartyReference/@href"/>
<xsl:when test="fpml:partyReference/@href=/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:sellerPartyReference/@href"/>
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
<xsl:when test="fpml:partyReference/@href=/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:buyerPartyReference/@href"/>
<xsl:when test="fpml:partyReference/@href=/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:sellerPartyReference/@href"/>
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
<xsl:if test="$productType = 'Equity Share Swap' or $productType = 'Equity Index Swap' or $productType = 'Equity Basket Swap' ">
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
<xsl:when test="$productType = 'Equity Share Swap' or $productType = 'Equity Index Swap' or $productType = 'Equity Basket Swap' or $productType = 'Dispersion Variance Swap' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2009EquityAmericas' and $mcAnnexType = 'ISDA2009IndexShareOptionAmericas' ">true</xsl:when>
<xsl:when test="$mcType = 'EquityOptionAmericasPrivate' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2010EquityEMEAInterdealer' ">true</xsl:when>
<xsl:when test="$mcType = 'EquityOptionEMEAPrivate' ">true</xsl:when>
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
<xsl:variable name="partyName">
<xsl:if test="ancestor::fpml:swLongFormTrade">
<xsl:value-of select="fpml:partyName"/>
</xsl:if>
<xsl:if test="ancestor::fpml:swShortFormTrade">
<xsl:value-of select="fpml:name"/>
</xsl:if>
</xsl:variable>
<xsl:if test="fpml:partyName or fpml:name">
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
<xsl:if test="$productType='Equity Share Option' or $productType='Equity Index Option' or $productType='Equity Share Option Strategy' or $productType='Equity Index Option Strategy'">
<xsl:choose>
<xsl:when test="fpml:payerPartyReference/@href=/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:buyerPartyReference/@href"/>
<xsl:when test="fpml:payerPartyReference/@href=/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:sellerPartyReference/@href"/>
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
<xsl:if test="$productType='Equity Share Option' or $productType='Equity Index Option' or $productType='Equity Share Option Strategy' or $productType='Equity Index Option Strategy'">
<xsl:choose>
<xsl:when test="fpml:receiverPartyReference/@href=/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:buyerPartyReference/@href">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid receiverPartyReference/@href attribute value. Value = '<xsl:value-of select="fpml:receiverPartyReference/@href"/>'.</text>
</error>
</xsl:when>
<xsl:when test="fpml:receiverPartyReference/@href=/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:sellerPartyReference/@href">
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
<xsl:when test="fpml:payerPartyReference/@href=/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:buyerPartyReference/@href"/>
<xsl:when test="fpml:payerPartyReference/@href=/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:sellerPartyReference/@href"/>
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
<xsl:when test="fpml:receiverPartyReference/@href=/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:buyerPartyReference/@href">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid receiverPartyReference/@href attribute value. Value = '<xsl:value-of select="fpml:receiverPartyReference/@href"/>'.</text>
</error>
</xsl:when>
<xsl:when test="fpml:receiverPartyReference/@href=/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:sellerPartyReference/@href">
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
<xsl:if test="not(/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:party[@id=$href2])">
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
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">paymentAmount/amount</xsl:with-param>
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
<xsl:if test="($docsType='Equity Options (Europe)' or $docsType='Equity Options (AEJ)' or $docsType='Equity Options (Americas)' or $docsType='Equity Options (EMEA)') and ancestor::fpml:equityOptionTransactionSupplement">
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
<xsl:if test="$docsType='Equity Options (Japan)' and ancestor::fpml:equityOptionTransactionSupplement">
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
<xsl:if test="not(/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:party[@id=$buyer])">
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
<xsl:if test="not(/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:party[@id=$seller])">
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
<xsl:if test="fpml:notional and $docsType!='Equity Options (Cliquet)' and $docsType!='Equity Options (Spread)'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected notional element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:notional/fpml:currency != 'USD' and $docsType='Equity Options (Cliquet)'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid Notional Currency (not USD) for Equity Cliquet Options.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:equityExercise">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="($productType='Equity Index Option' or $productType='Equity Share Option') and fpml:feature/fpml:knock and ($docsType!='Equity Options (Spread)' or $docsType != 'Equity Options (Cliquet)')">
<xsl:apply-templates select="fpml:feature">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
<xsl:if test="fpml:fxFeature and not ($docsType='Equity Options (AEJ)' and (fpml:equityExercise/fpml:settlementType = 'Cash' or fpml:equityExercise/fpml:settlementType = 'Election'))">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected fxFeature element encountered in this context. Element must not be present when Docs Type is not 'Equity Options (AEJ)' and equityExercise/settlementType is not 'Cash' or 'Election'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:fxFeature//fpml:fxSpotRateSource and (//fpml:swExtendedTradeDetails/fpml:swEquityOptionDetails/fpml:swFxDeterminationMethod = 'AsSpecifiedInMasterConfirmation')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected fxSpotRateSource element encountered in this context. Element must not be present when swFxDeterminationMethod is 'AsSpecifiedInMasterConfirmation'</text>
</error>
</xsl:if>
<xsl:if test="not(//fpml:swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swEquityOptionDetails/fpml:swSettlementPriceDefaultElection = 'HedgeExecution')">
<xsl:if test="not(fpml:fxFeature) and $docsType='Equity Options (AEJ)' and fpml:equityExercise/fpml:settlementType = 'Cash'">
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
<xsl:when test="fpml:equityExercise/fpml:settlementCurrency = 'EUR'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing fxFeature element  when Docs Type is 'Equity Options (AEJ)' and equityExercise/settlementType is 'Cash' and equityExercise/settlementCurrency is a non-deliverable currency and swbSettlementPriceDefaultElection is not 'HedgeExecution'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:if>
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
<xsl:if test="fpml:spotPrice and $docsType!='Equity Options (Spread)'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected spotPrice element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="$docsType='Equity Options (Europe)' or $docsType='Equity Options (AEJ)' or $docsType='Equity Options (Americas)' or $docsType='Equity Options (EMEA)' ">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">numberOfOptions</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:numberOfOptions"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">9999999999.99999</xsl:with-param>
<xsl:with-param name="maxDecs">5</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="$docsType='Equity Options (Japan)'">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">numberOfOptions</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:numberOfOptions"/>
</xsl:with-param>
<xsl:with-param name="minIncl">1</xsl:with-param>
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
<xsl:if test="fpml:exchangeLookAlike and ($productType='Equity Share Option' or $productType='Equity Share Option Strategy' or $productType='Equity Index Option' or $productType='Equity Index Option Strategy') and ($docsType='Equity Options (Europe)' or $docsType ='Equity Options (Americas)' or $docsType='Equity Options (EMEA)')">
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
<xsl:if test="($productType='Equity Share Option'  or $productType='Equity Share Option Strategy') and fpml:exchangeLookAlike and $docsType!='Equity Options (Europe)' and $docsType!='Equity Options (Americas)' and $docsType!='Equity Options (EMEA)' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected exchangeLookAlike element encountered in this context when product type is 'Equity Share Option' or 'Equity Share Option Strategy' and Docs Type is not 'Equity Options (Europe)' or 'Equity Options (Americas)' or 'Equity Options (EMEA)'.</text>
</error>
</xsl:if>
<xsl:if test="($productType='Equity Index Option' or $productType='Equity Index Option Strategy') and fpml:exchangeLookAlike and $docsType!='Equity Options (Americas)' and $docsType!='Equity Options (EMEA)'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected exchangeLookAlike element encountered in this context when product type is 'Equity Index Option' or 'Equity Index Option Strategy' and Docs Type is not 'Equity Options (Americas)' or 'Equity Options (EMEA)'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:exchangeTradedContractNearest and ($productType = 'Equity Index Option' or $productType ='Equity Index Option Strategy') and not($docsType='Equity Options (Europe)' or $docsType='Equity Options (EMEA)') ">
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
<xsl:if test="fpml:exchangeTradedContractNearest">
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">exchangeTradedContractNearest</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:exchangeTradedContractNearest"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:multipleExchangeIndexAnnexFallback and ($productType='Equity Share Option' or $productType='Equity Share Option Strategy' or ($docsType != 'Equity Options (Europe)' and $docsType != 'Equity Options (AEJ)'))">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected multipleExchangeIndexAnnexFallback element encountered in this contex when product type is 'Equity Share Option' or 'Equity Share Option Strategy' or when Docs Type is not 'Equity Options (Europe)' and not 'Equity Options (AEJ)'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:multipleExchangeIndexAnnexFallback">
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">multipleExchangeIndexAnnexFallback</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:multipleExchangeIndexAnnexFallback"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="($productType = 'Equity Index Option' or $productType = 'Equity Index Option Strategy') and fpml:methodOfAdjustment">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected methodOfAdjustment element encountered in this context. Element must not be present when product type is 'Equity Index Option' or 'Equity Index Option Strategy' and Docs Type is 'Equity Options (Japan)' or 'Equity Options (AEJ)'.</text>
</error>
</xsl:if>
<xsl:if test="$docsType != 'Equity Options (Europe)' and $docsType != 'Equity Options (Americas)' and fpml:methodOfAdjustment">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** methodOfAdjustment may only be present if Docs Type is 'Equity Options (Europe)' or 'Equity Options (Americas)'.</text>
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
<xsl:if test="fpml:localJurisdiction and ($productType = 'Equity Index Option' or $productType = 'Equity Index Option Universal' or $productType = 'Equity Index Option Strategy' or $docsType!='Equity Options (AEJ)')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected localJurisdiction element encountered in this context when Product Type is 'Equity Index Option' or 'Equity Index Option Strategy' or 'Equity Index Option Universal' or Docs Type is not 'Equity Options (AEJ)'.</text>
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
<xsl:if test="fpml:optionEntitlement and ($productType='Equity Index Option' or $productType='Equity Index Option Strategy')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected optionEntitlement element encountered in this context when product type is 'Equity Index Option' or 'Equity Index Option Strategy'.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:optionEntitlement) and ($productType='Equity Share Option' or $productType='Equity Share Option Strategy')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing optionEntitlement element in this context when product type is 'Equity Share Option' or 'Equity Share Option Strategy'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:optionEntitlement">
<xsl:call-template name="isValidIntegerNumber">
<xsl:with-param name="elementName">optionEntitlement</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:optionEntitlement"/>
</xsl:with-param>
<xsl:with-param name="minIncl">1</xsl:with-param>
<xsl:with-param name="maxIncl">999999</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="($productType = 'Equity Share Option' or $productType ='Equity Share Option Strategy') and fpml:multiplier">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected multiplier element encountered in this context. Element must not be present when product type is 'Equity Share Option' or 'Equity Share Option Strategy'.</text>
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
<xsl:if test="$docsType='Equity Options (Cliquet)'">
<xsl:if test="not(fpml:notional)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Notional element must be present for 'Equity Cliquet Options'.</text>
</error>
</xsl:if>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">notional</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:notional/fpml:amount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.00001</xsl:with-param>
<xsl:with-param name="maxIncl">1000000000000.00000</xsl:with-param>
<xsl:with-param name="maxDecs">5</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="not(fpml:equityPremium/fpml:paymentAmount)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** fpml:equityPremium/fpml:paymentAmount element must be present for 'Equity Cliquet Options'.</text>
</error>
</xsl:if>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">equityPremium/paymentAmount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:equityPremium/fpml:paymentAmount/fpml:amount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.01</xsl:with-param>
<xsl:with-param name="maxIncl">9999999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:underlyer">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="fpml:basket and not($productType = 'Equity Basket Swap')">
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
<text>*** Missing equity element when product type is 'Equity Share Option' or 'Equity Share Option Strategy' or 'Share Variance Swap' or 'Equity Share Volatility Swap'.</text>
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
<xsl:if test="fpml:openUnits and not ($productType = 'Equity Share Swap' or $productType = 'Equity Index Swap' or $productType = 'Equity Basket Swap') ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected openUnits element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:openUnits) and ($productType = 'Equity Share Swap' or $productType = 'Equity Index Swap' or $productType = 'Equity Basket Swap') and not(/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:returnLeg/fpml:rateOfReturn/fpml:initialPrice/fpml:determinationMethod)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** missing openUnits element in this context.</text>
</error>
</xsl:if>
<xsl:if test="$docsType = 'Equity Swap (Europe)'">
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
<xsl:if test="$docsType = 'Equity Swap (AEJ)' or ($docsType = 'Equity Swap (Americas)' and $productType = 'Equity Index Swap')">
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
<xsl:if test="$mcType = 'EquitySwapGlobalPrivate'">
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
<xsl:if test="fpml:dividendPayout and not ($productType = 'Equity Share Swap' or $productType = 'Equity Index Swap' or $productType = 'Equity Basket Swap') ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected dividendPayout element encountered in this context (product type).</text>
</error>
</xsl:if>
<xsl:if test="$productType = 'Equity Share Swap' or $productType = 'Equity Index Swap' or $productType = 'Equity Basket Swap' ">
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
<xsl:if test="ancestor::fpml:swDeltaCross and fpml:relatedExchangeId and not($productType='Equity Share Volatility Swap' or $productType='Equity Index Volatility Swap')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected relatedExchangeId element encountered in this context when ancestor is swDeltaCross.</text>
</error>
</xsl:if>
<xsl:if test="($productType='Equity Share Option' or $productType='Equity Share Option Strategy') and $docsType='Equity Options (Japan)' and fpml:relatedExchangeId">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected relatedExchangeId element encountered in this context when product type is 'Equity Share Option' or 'Equity Share Option Strategy' and Docs Type is 'Equity Options (Japan)</text>
</error>
</xsl:if>
<xsl:if test="fpml:relatedExchangeId='All Exchanges' and (fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:returnLeg/fpml:rateOfReturn/fpml:valuationPriceFinal/fpml:valuationRules/fpml:futuresPriceValuation='true' and /fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'ISDA2009EquitySwapAmericas' and $productType ='Equity Index Swap')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected value for relatedExchangeId encountered in this context when Docs Type is 'Equity Swap (Americas)', masterConfirmationType =  'ISDA2009EquitySwapAmericas' and futuresPriceValution = 'true'. Expected value 'All Exchanges'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:relatedExchangeId!='All Exchanges' and (fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:returnLeg/fpml:rateOfReturn/fpml:valuationPriceFinal/fpml:valuationRules/fpml:futuresPriceValuation='false' and /fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'ISDA2009EquitySwapAmericas' and $productType ='Equity Index Swap')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected value for relatedExchangeId encountered in this context when Docs Type is 'Equity Swap (Americas)', masterConfirmationType =  'ISDA2009EquitySwapAmericas' and futuresPriceValution = 'false'.</text>
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
<xsl:if test="not($productType='Equity Accumulator' or $productType='Equity Decumulator')">
<xsl:if test="$productType='Equity Index Option' and /fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swEquityOptionDetails/fpml:swAveragingDates">
<xsl:if test="not(//fpml:expirationDate//fpml:businessDayConvention)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Mandatory businessDayConvention element missing for Option Expiration Date (Equity Index Option).     </text>
</error>
</xsl:if>
<xsl:if test="not(//fpml:expirationDate//fpml:businessDayConvention[.= 'FOLLOWING' or .='MODFOLLOWING' or .='PRECEDING' or .='NotApplicable']) and $docsType != 'Equity Options (Cliquet)'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** businessDayConvention must be equal to 'FOLLOWING','MODFOLLOWING' or 'PRECEDING' in this context. Value = '<xsl:value-of select="//fpml:dateAdjustments/fpml:businessDayConvention"/>'</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:equityBermudaExercise">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected equityBermudaExercise element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:equityAmericanExercise and $docsType='Equity Options (Japan)'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected equityAmericanExercise element in this context when Docs Type is 'Equity Options (Japan)'. Only European Style options can be confirmed under the Japanse Master Confirmation.</text>
</error>
</xsl:if>
<xsl:if test="$productType='Equity Share Option' or $productType='Equity Index Option' or $productType='Equity Share Option Strategy' or $productType='Equity Index Option Strategy'">
<xsl:if test="not(fpml:automaticExercise[.='true'])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid automaticExercise element value. Must contain 'true' when product type is 'Equity Share Option' or 'Equity Index Option' or 'Equity Index Option Strategy' or 'Equity Share Option Strategy'.</text>
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
<xsl:if test="(fpml:settlementDate and fpml:settlementType = 'Physical') or (fpml:settlementDate and fpml:settlementType = 'Election' and /fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swEquityOptionDetails/fpml:swDefaultSettlementMethod != 'Cash')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected settlementDate element encountered in this context when settlementType is 'Physical' or when settlementType is 'Election' and swDefaultSettlementMethod is not equal to 'Cash'. settlementDate only applies to cash settled options or to options for which Settlement Election applies and the default settlement method is 'Cash'.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:settlementCurrency = //fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:equityPremium/fpml:paymentAmount/fpml:currency)">
<xsl:if test="not($mcType='ISDA2008EquityJapanese' or $mcType='ISDA2007EquityEuropean')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** settlementCurrency must equal //FpML/trade/equityOptionTransactionSupplement/equityPremium/paymentAmount/currency unless masterConfirmationType is 'ISDA2008EquityJapanese' or 'ISDA2007EquityEuropean'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:settlementPriceSource">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected settlementPriceSource element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:settlementType[.='Cash']) and ($productType='Equity Index Option' or $productType='Equity Index Option Strategy')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid settlementType element encountered in this context when product type is 'Equity Index Option' or 'Equity Index Option Strategy'. Value = '<xsl:value-of select="fpml:settlementType"/>'. Index options must be cash settled.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:settlementType[.='Physical']) and ($productType='Equity Share Option' or $productType='Equity Share Option Strategy') and $docsType='Equity Options (Japan)' and $docsSubType='2005 ISDA'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid settlementType element encountered in this context when Docs Type is 'ISDA2005EquityJapaneseInterdealer' and product type = 'Equity Share Option' or 'Equity Share Option Strategy'. Share Options confirmed under the 2005 Japanse Master Confirmation must be physically settled. Cash settlement is allowed under 'ISDA2008EquityJapanese'.
</text>
</error>
</xsl:if>
<xsl:if test="fpml:settlementType = 'Election'">
<xsl:if test="not(($productType='Equity Share Option' or $productType='Equity Share Option Strategy') and ($docsType='Equity Options (Americas)' or $docsType='Equity Options (AEJ)' or $mcType='2004EquityEuropeanInterdealer' or $mcType='ISDA2007EquityEuropean' or $mcType='ISDA2008EquityJapanese'))">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid settlementType 'Election' in this context. 'Election' is valid only when product type is 'Equity Share Option' or 'Equity Share Option Strategy' and Docs Type is 'Equity Options (Americas)', Docs Type is 'Equity Options (AEJ) - 2008 MCA or 2005 MCA', European 2004 Interdealer, European 2007 ISDA or Japan 2008.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:settlementType='Election' and not(/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swEquityOptionDetails/fpml:swDefaultSettlementMethod)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** If settlementType is equal to 'Election' then swEquityOptionDetails/swDefaultSettlementMethod must be present.</text>
</error>
</xsl:if>
<xsl:if test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swEquityOptionDetails/fpml:swDefaultSettlementMethod and fpml:settlementType!='Election'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** If settlementType is not equal to 'Election' then swEquityOptionDetails/swDefaultSettlementMethod must not be present.</text>
</error>
</xsl:if>
<xsl:variable name="settlementMethodElectionDateFieldApplicable">
<xsl:choose>
<xsl:when test="$mcType = 'ISDA2009EquityAmericas' and $mcAnnexType = 'ISDA2009IndexShareOptionAmericas' and fpml:settlementType = 'Election' ">true</xsl:when>
<xsl:when test="$mcType = 'EquityOptionAmericasPrivate' and fpml:settlementType = 'Election' ">true</xsl:when>
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
<xsl:when test="$mcType = 'ISDA2009EquityAmericas' and $mcAnnexType = 'ISDA2009IndexShareOptionAmericas' ">true</xsl:when>
<xsl:when test="$mcType = 'EquityOptionAmericasPrivate' ">true</xsl:when>
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
</xsl:if>
</xsl:template>
<xsl:template match="fpml:equityValuation">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="$productType = 'Equity Share Option' or $productType='Equity Index Option' or $productType='Equity Index Option Strategy' or $productType='Equity Share Option Strategy'">
<xsl:if test="(./@id !='valuationDate' or not(./@id)) and //fpml:equityExercise/fpml:settlementDate">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** @id must be present and must be equal to "valuationDate" in this context if //equityExercise/settlementDate is present and product type is 'Equity Share Option' or 'Equity Index Option' or 'Equity Index Option Strategy' or 'Equity Share Option Strategy'. Value = "<xsl:value-of select="./@id"/>".</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$productType = 'Share Variance Swap' or $productType='Index Variance Swap'">
<xsl:if test="(./@id !='valuationDate' or not(./@id))">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** @id must be present and must be equal to "valuationDate" in this context if product type is 'Share Variance Swap' or 'Index Variance Swap'. Value = "<xsl:value-of select="./@id"/>".</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:valuationDate and ($productType = 'Equity Share Option' or $productType='Equity Index Option' or $productType='Equity Index Option Strategy' or $productType='Equity Share Option Strategy')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected valuationDate element encountered in this context when product type is 'Equity Share Option' or 'Equity Index Option' or 'Equity Index Option Strategy' or 'Equity Share Option Strategy'.</text>
</error>
</xsl:if>
<xsl:choose>
<xsl:when test="fpml:valuationDates and $docsType!='Equity Options (Cliquet)'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected valuationDates element encountered in this context.</text>
</error>
</xsl:when>
<xsl:when test="$docsType='Equity Options (Cliquet)' and not(fpml:valuationDates)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing valuationDates element. Valuation Dates must be present for Equity Cliquet Options</text>
</error>
</xsl:when>
</xsl:choose>
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
<xsl:if test="fpml:futuresPriceValuation and ($productType = 'Share Variance Swap' or ($productType='Equity Share Option' and not ($mcType='EquityOptionAmericasPrivate' or $mcType='EquityOptionEuropePrivate' or $mcType='EquityOptionAEJPrivate' or $mcType='EquityOptionEMEAPrivate')) or $productType='Equity Share Option Strategy')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected futuresPriceValuation element encountered in this context when product type is 'Share Variance Swap' or 'Equity Share Option' or 'Equity Share Option Strategy'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:futuresPriceValuation and  ($productType='Equity Index Option' or $productType='Equity Index Option Strategy') and not ($docsType='Equity Options (AEJ)' or $docsType='Equity Options (Americas)' or $docsType='Equity Options (Europe)' or $docsType='Equity Options (Japan)' or $docsType='Equity Options (EMEA)' or $docsType='Equity Options (Spread)')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected futuresPriceValuation element encountered in this context when product type is 'Equity Index Option'  or 'Equity Index Option Strategy' and Docs Type is not 'Equity Options (AEJ)' or 'Equity Options (Americas)' or 'Equity Options (Europe)' or 'Equity Options (Japan)' or 'Equity Options (EMEA)'.</text>
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
<xsl:if test="not($mcType='ISDA2004EquityAmericasInterdealer' or $mcType='ISDA2009EquityAmericas' or $mcType='EquityOptionAmericasPrivate' or $mcType='2004EquityEuropeanInterdealer' or $mcType='ISDA2007EquityEuropean' or $mcType='EquityOptionAmericasPrivate')">
<xsl:if test="$productType='Equity Index Option' and $docsType='Equity Options (Americas)' and (//fpml:equityExpirationTimeType='OSP' or //fpml:equityExpirationTimeType='AsSpecifiedInMasterConfirmation')">
<xsl:if test="not(fpml:futuresPriceValuation='true')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** futuresPriceValuation must be 'True' where product type is 'Equity Index Option' and Docs Type is  'Equity Options (Americas)' or 'Equity Options (Europe)' where 'equityExpirationTimeType' is 'OSP' or 'AsSpecifiedInMasterConfirmation'.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
<xsl:if test="$mcType='ISDA2004EquityAmericasInterdealer' and $productType='Equity Index Option' and $docsType='Equity Options (Americas)'">
<xsl:if test="not(fpml:futuresPriceValuation='true') and (//fpml:equityExpirationTimeType='OSP')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** futuresPriceValuation must be 'True' where product type is 'Equity Index Option' and Docs Type is  'Equity Options (Americas) 2004 Interdealer' where 'equityExpirationTimeType' is 'OSP'.</text>
</error>
</xsl:if>
<xsl:if test="(fpml:futuresPriceValuation='true') and not (//fpml:equityExpirationTimeType='OSP')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** 'equityExpirationTimeType' must be 'OSP' where product type is 'Equity Index Option' and Docs Type is  'Equity Options (Americas) 2004 Interdealer' where futuresPriceValuation is 'True'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$mcType='ISDA2008EquityAmericas'">
<xsl:if test="$productType='Equity Index Option' and $docsType='Equity Options (Americas)' and //fpml:equityExpirationTimeType='Close'">
<xsl:if test="not(fpml:futuresPriceValuation='true')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** futuresPriceValuation must be 'True' where product type is 'Equity Index Option' and Docs Type is  'Equity Options (Americas)' where 'equityExpirationTimeType' is 'Close' and mcType is 'ISDA2008EquityAmericas'.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
<xsl:if test="$productType='Equity Index Option' and $docsType='Equity Options (Americas)' and $docsSubType='2008 ISDA' and not(//fpml:equityExpirationTimeType='AsSpecifiedInMasterConfirmation' or //fpml:equityExpirationTimeType='OSP' or //fpml:equityExpirationTimeType='Close')">
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
<xsl:if test="$docsType='Equity Options (Cliquet)'">
<xsl:apply-templates select="fpml:valuationDates">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
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
<xsl:if test="$productType='Equity Share Swap' or $productType='Equity Index Swap' or $productType= 'Equity Basket Swap' ">
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
<xsl:if test="not($productType='Equity Share Swap' or $productType='Equity Index Swap' or $productType= 'Equity Basket Swap') ">
<xsl:if test="fpml:businessDayConvention != 'NotApplicable'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** businessDayConvention must be equal to 'NotApplicable' in this context. Value = '<xsl:value-of select="fpml:businessDayConvention"/>'</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$productType='Equity Share Swap' or $productType='Equity Index Swap' or $productType= 'Equity Basket Swap' ">
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
<xsl:if test="fpml:businessCenters and not($productType='Equity Share Swap' or $productType='Equity Index Swap' or $productType= 'Equity Basket Swap')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected businessCenters element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="$productType='Equity Share Swap' or $productType='Equity Index Swap' or $productType= 'Equity Basket Swap' ">
<xsl:if test="fpml:businessCenters and (ancestor::fpml:calculationStartDate or ancestor::fpml:calculationEndDate) ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected businessCenters element encountered in this context.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:dateRelativeTo/@href != 'valuationDate' and not($productType='Equity Share Swap' or $productType='Equity Index Swap' or $productType= 'Equity Basket Swap')  ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** dateRelativeTo/@href must be equal to 'valuationDate' in this context. Value = '<xsl:value-of select="fpml:dateRelativeTo/@href"/>'</text>
</error>
</xsl:if>
<xsl:if test="$productType='Equity Share Swap' or $productType='Equity Index Swap' or $productType= 'Equity Basket Swap' ">
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
<xsl:if test="not($productType='Equity Accumulator' or $productType='Equity Decumulator' or (($productType='Equity Index Option' or $productType='Equity Share Option') and fpml:knock and ($docsType!='Equity Options (Spread)' or $docsType != 'Equity Options (Cliquet)')))">
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
<xsl:if test="not(fpml:asian/fpml:averagingPeriodOut/fpml:marketDisruption = 'Modified Postponement' or fpml:asian/fpml:averagingPeriodOut/fpml:marketDisruption= 'Omission' or  fpml:asian/fpml:averagingPeriodOut/fpml:marketDisruption= 'Postponement')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** marketDisruption must be equal to 'Modified Postponement' or 'Omission' or 'Postponement' in this context. Value = '<xsl:value-of select="fpml:asian/fpml:averagingPeriodOut/fpml:marketDisruption"/>'</text>
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
<xsl:if test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swEquityOptionDetails/fpml:swEquityOptionPercentInput and not (/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swEquityOptionDetails/fpml:swReferenceFXRate)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swReferenceFXRate expected in this context.</text>
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
<xsl:if test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swEquityOptionDetails/fpml:swEquityOptionPercentInput and not (/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swEquityOptionDetails/fpml:swReferenceFXRate)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swReferenceFXRate expected in this context.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:strike|fpml:swStrikePrice">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="fpml:strikePrice">
<xsl:if test="$docsType='Equity Options (Europe)'">
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
<xsl:if test="$docsType='Equity Options (Japan)' or $docsType='Equity Options (AEJ)' or $docsType='Equity Options (Americas)'">
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
<xsl:if test="$productType='Equity Share Option' or $productType='Equity Share Option Strategy'">
<xsl:if test="not(fpml:currency)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing currency element. Required in this context.</text>
</error>
</xsl:if>
<xsl:if test="not($mcType = 'ISDA2008EquityJapanese' or $mcType = 'ISDA2010EquityEMEAInterdealer' or $mcType = 'EquityOptionEMEAPrivate' or $mcType = 'EquityOptionAmericasPrivate' or $docsType = 'Equity Options (Europe)')">
<xsl:if test="not(fpml:currency = //fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:equityPremium/fpml:paymentAmount/fpml:currency) and not(/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:fxFeature/fpml:crossCurrency or /fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:fxFeature/fpml:quanto)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The currency must equal /equityPremium/paymentAmount/currency unless option is Cross-Currency or Quanto settled.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="not(fpml:currency = //fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:fxFeature/fpml:referenceCurrency) and (/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:fxFeature/fpml:crossCurrency or /fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:fxFeature/fpml:quanto)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The currency must equal fxFeature/referenceCurrency when option is Cross-Currency or Quanto settled.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:currency and (($productType='Equity Index Option'  and $docsType != 'Equity Options (Europe)' and $docsType != 'Equity Options (Spread)') or $productType='Equity Index Option Strategy')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected currency element encountered in this context when product type is 'Equity Index Option' or 'Equity Index Option Strategy'.</text>
</error>
</xsl:if>
</xsl:when>
<xsl:when test="fpml:strikePercentage">
<xsl:if test="fpml:strikePercentage and ($docsType != 'Equity Options (Europe)' and $docsType != 'Equity Options (AEJ)' and $docsType != 'Equity Options (Spread)')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected strikePercentage element encountered in this context. Forward-starting options are only supported under the European, Spread or AEJ Options MCAs. Submitted Docs Type = '<xsl:value-of select="$docsType"/>'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:strikePrice">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected strikePrice element encountered in this context. Forward-starting trades should have their strike expressed as a strikePercentage to be determined on the strikeDeterminationDate.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:strikeDeterminationDate)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing strikeDeterminationDate element in this context. Forward-starting trades should have their strike expressed as a strikePercentage to be determined on the strikeDeterminationDate.</text>
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
<xsl:if test="fpml:currency and not(($productType = 'Equity Index Option' and ($docsType = 'Equity Options (Europe)' or $docsType = 'Equity Options (Spread)')) or ($productType = 'Equity Share Option' and $docsType = 'Equity Options (Europe)'))">
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
<xsl:if test="not(fpml:payerPartyReference/@href = /fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:buyerPartyReference/@href)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid payerPartyReference/@href attribute value. The payerPartyReference/@href must be equal to //FpML/trade/equityOptionTransactionSupplement/buyerPartyReference/@href (payer of premium is option buyer).</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:receiverPartyReference/@href = /fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:sellerPartyReference/@href)">
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
<xsl:if test="not(fpml:paymentAmount/fpml:currency = fpml:pricePerOption/fpml:currency) and $docsType!='Equity Options (Cliquet)' and $docsType!='Equity Options (Spread)'">
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
<xsl:if test="not(fpml:pricePerOption) and $docsType!='Equity Options (Cliquet)' and $docsType!='Equity Options (Spread)'">
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
<xsl:if test="not(fpml:businessDayConvention[.='NotApplicable']) and not (ancestor::fpml:novation or $productType = 'Equity Share Swap' or $productType = 'Equity Index Swap' or $productType = 'Equity Basket Swap' or $productType = 'Equity Index Option' or $productType = 'Equity Index Option Strategy' or $docsType='Equity Options (Cliquet)' or $docsType='Equity Options (Spread)')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid businessDayConvention element value. Must contain 'NotApplicable' when product type is 'Equity Share Option', 'Equity Share Option Strategy', 'Share Variance Swap' or 'Index Variance Swap' unless ancestor is novation.</text>
</error>
</xsl:if>
<xsl:variable name="businessDayConvention">
<xsl:value-of select="fpml:businessDayConvention"/>
</xsl:variable>
<xsl:if test="ancestor::fpml:novation or $productType = 'Equity Share Swap' or $productType = 'Equity Index Swap' or $productType = 'Equity Basket Swap' ">
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
<xsl:if test="fpml:businessCenters and not (ancestor::fpml:novation or $productType = 'Equity Share Swap' or $productType = 'Equity Index Swap' or $productType = 'Equity Basket Swap' or $productType = 'Equity Index Option' or $productType = 'Equity Index Option Strategy') ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected businessCenters element encountered in this context when product type is 'Equity Share Option', 'Equity Share Option Strategy', 'Equity Index Option Strategy', 'Share Variance Swap' or 'Index Variance Swap' Element may only be present if ancestor is novation or product type is 'Equity Share Swap' or 'Equity Index Swap' or 'Equity Index Option' or 'Equity Index Option Strategy'.</text>
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
<xsl:if test="$businessDayConvention!='NONE' and $businessDayConvention!='NotApplicable'">
<xsl:if test="(ancestor::fpml:novation or $productType = 'Equity Share Swap' or $productType = 'Equity Index Swap' or $productType = 'Equity Basket Swap') and not(fpml:businessCenters)">
<xsl:if test="fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swEquitySwapDetails/fpml:swSchedulingMethod!='ListDateEntry' or fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swEquitySwapDetails/fpml:swSchedulingMethod='' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing businessCenters. Needed when businessDayConvention not equal to 'NONE' or 'NotApplicable'.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:businessCenters">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:businessCentersReference">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected businessCentersReference element encountered in this context.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:pricePerOption|fpml:swPricePerOption">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="$docsType='Equity Options (Europe)'">
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
<xsl:if test="$docsType='Equity Options (Americas)' or $docsType='Equity Options (EMEA)'">
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
<xsl:if test=" $docsType='Equity Options (AEJ)'">
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
<xsl:if test="$docsType='Equity Options (Japan)'">
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
<xsl:if test="not($mcType='ISDA2010EquityEMEAInterdealer' or $mcType='EquityOptionEMEAPrivate' or $docsType='Equity Options (Cliquet)' or $docsType='Equity Options (Spread)')">
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
</xsl:if>
<xsl:if test="($productType = 'Equity Share Option' or $productType= 'Equity Share Option Strategy') and $docsType='Equity Options (Americas)' and not($mcType='ISDA2008EquityAmericas')">
<xsl:if test="fpml:equityExpirationTimeType='Open' and not(fpml:settlementType='Cash') and not(//fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:equityExercise/fpml:equityAmericanExercise) and not ($mcType = 'EquityOptionAmericasPrivate')">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>***  When product type is 'Equity Share Option' or 'Equity Share Option Strategy' and Docs Type is 'Equity Options (Americas)', 'Open' can only be supplied when option style is 'American' and SettlementType is 'Cash'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:variable name="equityExpirationTimeFieldApplicable">
<xsl:choose>
<xsl:when test="$mcType = 'ISDA2009EquityAmericas' and $mcAnnexType = 'ISDA2009IndexShareOptionAmericas' and fpml:equityExpirationTimeType = 'SpecificTime' ">true</xsl:when>
<xsl:when test="($mcType = 'EquityOptionAmericasPrivate' or $mcType = 'EquityOptionEuropePrivate') and fpml:equityExpirationTimeType = 'SpecificTime' ">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:if test="fpml:equityExpirationTime and $equityExpirationTimeFieldApplicable = 'false' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected equityExpirationTime element encountered in this  context.</text>
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
<xsl:variable name="commencementDateFieldApplicable">
<xsl:choose>
<xsl:when test="$mcType = 'ISDA2009EquityAmericas' and $mcAnnexType = 'ISDA2009IndexShareOptionAmericas' ">true</xsl:when>
<xsl:when test="$mcType = 'EquityOptionAmericasPrivate' ">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:if test="$commencementDateFieldApplicable = 'false' ">
<xsl:if test="not(//fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:strike/fpml:strikePercentage)">
<xsl:variable name="comDate">
<xsl:value-of select="number(concat(substring(fpml:commencementDate/fpml:adjustableDate/fpml:unadjustedDate,1,4),        substring(fpml:commencementDate/fpml:adjustableDate/fpml:unadjustedDate,6,2),        substring(fpml:commencementDate/fpml:adjustableDate/fpml:unadjustedDate,9,2)))"/>
</xsl:variable>
<xsl:variable name="tDate">
<xsl:value-of select="number(concat(substring(//fpml:FpML/fpml:trade/fpml:tradeHeader/fpml:tradeDate,1,4),        substring(//fpml:FpML/fpml:trade/fpml:tradeHeader/fpml:tradeDate,6,2),        substring(//fpml:FpML/fpml:trade/fpml:tradeHeader/fpml:tradeDate,9,2)))"/>
</xsl:variable>
<xsl:if test="$comDate &lt; $tDate">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The commencementDate/adjustableDate/unadjustedDate must be on or after the //FpML/trade/tradeHeader/tradeDate (American exercise period must commence earliest on the trade date).</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
<xsl:variable name="latestExerciseTimeFieldApplicable">
<xsl:choose>
<xsl:when test="$mcType = 'ISDA2009EquityAmericas' and $mcAnnexType = 'ISDA2009IndexShareOptionAmericas' and fpml:latestExerciseTimeType = 'SpecificTime' ">true</xsl:when>
<xsl:when test="$mcType = 'EquityOptionAmericasPrivate' and fpml:latestExerciseTimeType = 'SpecificTime' ">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:if test="fpml:latestExerciseTime and $latestExerciseTimeFieldApplicable = 'false' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected latestExerciseTime element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:latestExerciseTime">
<xsl:call-template name="isValidHourMinuteTime">
<xsl:with-param name="elementName">latestExerciseTime/hourMinuteTime</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:latestExerciseTime/fpml:hourMinuteTime"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:latestExerciseTime/fpml:businessCenter">
<xsl:if test="not(fpml:latestExerciseTime/fpml:businessCenter = 'NotApplicable')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid businessCenter element value. Must contain 'NotApplicable' in this context. Value = '<xsl:value-of select="fpml:latestExerciseTime/fpml:businessCenter"/>
</text>
</error>
</xsl:if>
</xsl:if>
<xsl:variable name="latestExerciseTimeTypeFieldApplicable">
<xsl:choose>
<xsl:when test="$mcType = 'ISDA2009EquityAmericas'">true</xsl:when>
<xsl:when test="$mcType = 'EquityOptionAmericasPrivate' ">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:if test="fpml:latestExerciseTimeType and $latestExerciseTimeTypeFieldApplicable = 'false' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected latestExerciseTimeType element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:latestExerciseTimeType">
<xsl:call-template name="isValidlatestExerciseTimeType">
<xsl:with-param name="elementName">latestExerciseTimeType</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:latestExerciseTimeType"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="not($mcType='ISDA2010EquityEMEAInterdealer' or $mcType='EquityOptionEMEAPrivate')">
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
</xsl:if>
<xsl:if test="not(($mcType = 'ISDA2009EquityAmericas' and $mcAnnexType = 'ISDA2009IndexShareOptionAmericas') or ($mcType='EquityOptionAmericasPrivate') or ($mcType = 'ISDA2004EquityAmericasInterdealer')) ">
<xsl:if test="($productType = 'Equity Index Option' or $productType= 'Equity Index Option Strategy') and $docsType='Equity Options (Americas)'">
<xsl:if test="fpml:equityExpirationTimeType='OSP' and not(//fpml:futuresPriceValuation='true')">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** When product type is 'Equity Index Option' or 'Equity Index Option Strategy' and Docs Type is 'Equity Options (Americas)' other than ISDA 2009 Americas, the 'OSP' or can only be supplied when fpml:futuresPriceValuation is 'true'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="($productType = 'Equity Share Option' or $productType= 'Equity Share Option Strategy') and $docsType='Equity Options (Americas)'">
<xsl:if test="fpml:equityExpirationTimeType='Open' and not(fpml:settlementType='Cash') and not(//fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:equityExercise/fpml:equityAmericanExercise) and not ($mcType = 'EquityOptionAmericasPrivate')">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>***  When product type is 'Equity Share Option' or 'Equity Share Option Strategy' and Docs Type is 'Equity Options (Americas)' other than ISDA 2009 Americas, the 'Open' can only be supplied when option style is 'American' and SettlementType is 'Cash'.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
<xsl:variable name="equityExpirationTimeFieldApplicable">
<xsl:choose>
<xsl:when test="$mcType = 'ISDA2009EquityAmericas' and $mcAnnexType = 'ISDA2009IndexShareOptionAmericas' and fpml:equityExpirationTimeType = 'SpecificTime' ">true</xsl:when>
<xsl:when test="($mcType = 'EquityOptionAmericasPrivate' or $mcType = 'EquityOptionEuropePrivate') and fpml:equityExpirationTimeType = 'SpecificTime' ">true</xsl:when>
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
<xsl:if test="fpml:equityMultipleExercise and not(//fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:equityExercise/fpml:equityAmericanExercise)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected equityMultipleExercise element encountered in this context when option is not American style.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:equityMultipleExercise">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:equityMultipleExercise">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="not(fpml:integralMultipleExercise)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing integralMultiple element in this context. When message includes equityMultipleExercise, the integralMultiple shoudl be specified.</text>
</error>
</xsl:if>
<xsl:if test="fpml:integralMultipleExercise">
<xsl:call-template name="isValidIntegerNumber">
<xsl:with-param name="elementName">integralMultipleExercise</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:integralMultipleExercise"/>
</xsl:with-param>
<xsl:with-param name="minIncl">1</xsl:with-param>
<xsl:with-param name="maxIncl">1000000</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:minimumNumberOfOptions">
<xsl:call-template name="isValidIntegerNumber">
<xsl:with-param name="elementName">minimumNumberOfOptions</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:minimumNumberOfOptions"/>
</xsl:with-param>
<xsl:with-param name="minIncl">1</xsl:with-param>
<xsl:with-param name="maxIncl">1000000</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:variable name="maxNumberOfOptions">
<xsl:value-of select="fpml:maximumNumberOfOptions"/>
</xsl:variable>
<xsl:variable name="numberOfOptions">
<xsl:value-of select="//fpml:equityOptionTransactionSupplement/fpml:numberOfOptions"/>
<xsl:value-of select="//fpml:swEquityOptionParameters/fpml:numberOfOptions"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="($mcType = 'ISDA2009EquityAmericas' and $mcAnnexType = 'ISDA2009IndexShareOptionAmericas') or $mcType='EquityOptionAmericasPrivate' or $mcType='ISDA2010EquityEMEAInterdealer' or $mcType='EquityOptionEMEAPrivate' ">
<xsl:if test="number($maxNumberOfOptions) &gt; number($numberOfOptions)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** maximumNumberOfOptions must not hold a value greater than the value of numberOfOptions.</text>
</error>
</xsl:if>
</xsl:when>
<xsl:otherwise>
<xsl:if test="number($maxNumberOfOptions) != number($numberOfOptions)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** maximumNumberOfOptions element should hold the same value as numberOfOptions.</text>
</error>
</xsl:if>
</xsl:otherwise>
</xsl:choose>
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
<xsl:if test="fpml:futuresPriceValuation and  //fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:varianceSwapTransactionSupplement/fpml:underlyer/fpml:singleUnderlyer//fpml:equity">
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
<xsl:if test="not(/fpml:SWDML//fpml:swStructuredTradeDetails/fpml:FpML/fpml:party[@id=$payer])">
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
<xsl:if test="not(/fpml:SWDML//fpml:swStructuredTradeDetails/fpml:FpML/fpml:party[@id=$receiver])">
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
<xsl:if test="not($docsType='Dividend Swap (Japan)') ">
<xsl:if test="not(fpml:dividendLeg/fpml:underlyer/fpml:singleUnderlyer//fpml:relatedExchangeId)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Expected relatedExchangeId element not found in this context.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$docsType='Dividend Swap (Japan)' ">
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
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">openUnits</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:dividendLeg/fpml:underlyer/fpml:singleUnderlyer/fpml:openUnits"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.00001</xsl:with-param>
<xsl:with-param name="maxIncl">999999999.99999</xsl:with-param>
<xsl:with-param name="maxDecs">5</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
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
<xsl:if test="not($docsType='Dividend Swap (Japan)') ">
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
<xsl:if test="$docsType='Dividend Swap (Japan)' ">
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
<xsl:with-param name="elementName">declaredCashDividendPercentage</xsl:with-param>
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
<error><context><xsl:value-of select="$newContext"/></context><text>*** Number of Dividend Periods (<xsl:value-of select="count(fpml:dividendLeg/fpml:dividendPeriod)"/>) is different to the number of Fixed payments (<xsl:value-of select="count(fpml:fixedLeg/fpml:fixedPayment)"/>) in this context.</text></error>
</xsl:if>
<xsl:for-each select="fpml:dividendLeg/fpml:dividendPeriod">
<xsl:sort select="."/>
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
<xsl:if test="not($docsType='Dividend Swap (Japan)') ">
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
<xsl:variable name="dividendLegDateRelativeTo_href">
<xsl:value-of select="fpml:paymentDate/fpml:relativeDate/fpml:dateRelativeTo/@href"/>
</xsl:variable>
<xsl:if test="$docsType='Dividend Swap (Japan)'">
<xsl:if test="not(fpml:valuationDate[@id=$dividendLegDateRelativeTo_href])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The dividendLeg/dividendPeriod/dateRelativeTo/@href value does not match the valuationDate/@id value. Value = '<xsl:value-of select="$dividendLegDateRelativeTo_href"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="not($docsType='Dividend Swap (Japan)')">
<xsl:if test="not(fpml:unadjustedEndDate[@id=$dividendLegDateRelativeTo_href])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The dividendLeg/dividendPeriod/dateRelativeTo/@href value does not match the unadjustedEndDate/@id value. Value = '<xsl:value-of select="$dividendLegDateRelativeTo_href"/>'.</text>
</error>
</xsl:if>
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
<xsl:if test="$docsType='Dividend Swap (Japan)' ">
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
<xsl:if test="not(fpml:valuationDate/fpml:adjustableDate/fpml:dateAdjustments/fpml:businessDayConvention = 'NotApplicable')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid businessDayConvention element value. Must contain 'NotApplicable' in this context. Value = '<xsl:value-of select="fpml:valuationDate/fpml:adjustableDate/fpml:dateAdjustments/fpml:businessDayConvention"/>
</text>
</error>
</xsl:if>
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
<xsl:if test="not(/fpml:SWDML//fpml:swStructuredTradeDetails/fpml:FpML/fpml:party[@id=$payer])">
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
<xsl:if test="not(/fpml:SWDML//fpml:swStructuredTradeDetails/fpml:FpML/fpml:party[@id=$receiver])">
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
<xsl:if test="$payer2=fpml:dividendLeg/fpml:payerPartyReference/@href">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Dividend leg payerPartyReference/@href and fixed leg payerPartyReference/@href are the same. Value = '<xsl:value-of select="$payer2"/>
</text>
</error>
</xsl:if>
<xsl:if test="$receiver2=fpml:dividendLeg/fpml:receiverPartyReference/@href">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Dividend leg receiverPartyReference/@href and fixed leg receiverPartyReference/@href are the same. Value = '<xsl:value-of select="$receiver2"/>
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
<xsl:sort select="."/>
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
<xsl:if test="not($docsType='Dividend Swap (Japan)')">
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
<xsl:if test="$docsType='Dividend Swap (Japan)'">
<xsl:if test="not(/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:dividendSwapTransactionSupplement/fpml:dividendLeg/fpml:dividendPeriod/fpml:valuationDate[@id=$drtid])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The fixedleg/fixedPayment/dateRelativeTo/@href value does not match a dividendLeg/dividendPeriod/valuationDate/@id value. Value = '<xsl:value-of select="$drtid"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="not($docsType='Dividend Swap (Japan)') ">
<xsl:if test="not(/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:dividendSwapTransactionSupplement/fpml:dividendLeg/fpml:dividendPeriod/fpml:paymentDate[@id=$drtid])">
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
<xsl:if test="not(/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:party[@id=$buyer])">
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
<xsl:if test="not(/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:party[@id=$seller])">
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
<xsl:if test="fpml:multipleExchangeIndexAnnexFallback and ($productType='Share Variance Swap' or $docsType='Variance Swap (Japan)' or $docsType='Variance Swap (Americas)')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected multipleExchangeIndexAnnexFallback element encountered in this contex when product type is 'Share Variance Swap' or when Docs Type is 'Variance Swap (Japan)' or 'Variance Swap (Americas)'.</text>
</error>
</xsl:if>
<xsl:variable name="componentSecurityIndexAnnexFallbackFieldApplicable">
<xsl:choose>
<xsl:when test="$mcType = 'ISDA2007EquityEuropean' and $mcAnnexType = 'ISDA2009EquityEuropeanIS' ">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:if test="fpml:componentSecurityIndexAnnexFallback and $componentSecurityIndexAnnexFallbackFieldApplicable = 'false' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected componentSecurityIndexAnnexFallback element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:localJurisdiction and ($productType = 'Index Variance Swap' or $docsType!='Variance Swap (AEJ)')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected localJurisdiction element encountered in this context when Product Type is ' Index Variance Swap' or Docs Type is not 'Variance Swap (AEJ)'.</text>
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
<xsl:apply-templates select="fpml:varianceLeg">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
<xsl:if test="$productType='Equity Share Swap' or $productType='Equity Index Swap'  or $productType= 'Equity Basket Swap' ">
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
<xsl:when test="not(fpml:interestLeg) and not(//fpml:swEquitySwapDetails/fpml:swFullyFunded) and not(//fpml:swEquitySwapDetails/fpml:swSpreadDetails)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing interestLeg, swFullyFunded or swSpreadDetails in this context.</text>
</error>
</xsl:when>
<xsl:otherwise>
<xsl:if test="(fpml:interestLeg or //fpml:swEquitySwapDetails/fpml:swFullyFunded or //fpml:swEquitySwapDetails/fpml:swSpreadDetails) and not(fpml:interestLeg) and not(//fpml:swEquitySwapDetails/fpml:swFullyFunded or //fpml:swEquitySwapDetails/fpml:swSpreadDetails)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing interestLeg element in this context.</text>
</error>
</xsl:if>
<xsl:if test="(fpml:interestLeg or //fpml:swEquitySwapDetails/fpml:swFullyFunded or //fpml:swEquitySwapDetails/fpml:swSpreadDetails) and fpml:interestLeg and (//fpml:swEquitySwapDetails/fpml:swFullyFunded or //fpml:swEquitySwapDetails/fpml:swSpreadDetails)">
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
<xsl:when test="$mcType = 'ISDA2009EquitySwapAmericas'">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2009EquityEuropeanInterdealer' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2009EquitySwapPanAsia' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2007EquityEuropean'">true</xsl:when>
<xsl:when test="$mcType = 'EquitySwapGlobalPrivate' ">true</xsl:when>
<xsl:when test="$mcType = 'EquitySwapAmericasPrivate' ">true</xsl:when>
<xsl:when test="$mcType = 'EquitySwapAEJPrivate' ">true</xsl:when>
<xsl:when test="$mcType = 'EquitySwapEuropePrivate' ">true</xsl:when>
<xsl:when test="$mcType = 'EquitySwapPanAsiaPrivate' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2004EquityAmericasInterdealer' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2005EquitySwapAsiaExcludingJapanInterdealer' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2008EquityFinanceSwapAsiaExcludingJapan' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2007EquityFinanceSwapEuropean' ">true</xsl:when>
<xsl:when test="$mcType = 'EmergingEquitySwapIndustry' ">true</xsl:when>
<xsl:when test="$mcType = 'EmergingEquitySwapLATAM'">true</xsl:when>
<xsl:when test="$mcType = 'EmergingEquitySwapEMEA'">true</xsl:when>
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
<xsl:variable name="breakFundingRecoveryFieldApplicable">
<xsl:choose>
<xsl:when test="$mcType = 'ISDA2009EquitySwapAmericas' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2004EquityAmericasInterdealer' ">true</xsl:when>
<xsl:when test="$mcType = 'EquitySwapGlobalPrivate' ">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:if test="fpml:breakFundingRecovery and $breakFundingRecoveryFieldApplicable = 'false' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected breakFundingRecovery element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:breakFundingRecovery = 'true' and fpml:optionalEarlyTermination = 'false' and $breakFundingRecoveryFieldApplicable = 'true'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** breakFundingRecovery must be equal to false if optionalEarlyTermination is not applicable.</text>
</error>
</xsl:if>
<xsl:if test="fpml:breakFeeElection and fpml:optionalEarlyTermination = 'false' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected breakFeeElection element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:breakFeeRate and $mcType = 'EquitySwapGlobalPrivate' and fpml:optionalEarlyTermination = 'false'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected breakFeeRate element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:breakFeeRate">
<xsl:choose>
<xsl:when test="fpml:breakFeeElection = 'FlatFee'"/>
<xsl:when test="fpml:breakFeeElection = 'AmortizedFee'"/>
<xsl:when test="fpml:breakFeeElection = 'FlatFeeAndFundingFee'"/>
<xsl:when test="fpml:breakFeeElection = 'AmortizedFeeAndFundingFee'"/>
<xsl:when test="fpml:breakFeeElection = 'NotApplicable'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** When breakFeeRate is present that breakFeeElection must have a value of 'FlatFee', 'AmortizedFee', 'FlatFeeAndFundingFee' or 'AmortizedFeeAndFundingFee'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="fpml:breakFeeRate">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">breakFeeRate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:breakFeeRate"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">9.99999999</xsl:with-param>
<xsl:with-param name="maxDecs">8</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:variable name="multipleExchangeIndexAnnexFallbackFieldApplicable">
<xsl:choose>
<xsl:when test="$mcType = 'ISDA2009EquityEuropeanInterdealer' and $mcAnnexType = 'ISDA2009IndexSwapEuropeanInterdealer' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2007EquityEuropean' and $mcAnnexType = 'ISDA2009EquityEuropeanIS' ">true</xsl:when>
<xsl:when test="$mcType= 'EquitySwapGlobalPrivate' ">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="componentSecurityIndexAnnexFallbackFieldApplicable">
<xsl:choose>
<xsl:when test="$mcType = 'ISDA2009EquityEuropeanInterdealer' and $mcAnnexType = 'ISDA2009IndexSwapEuropeanInterdealer' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2007EquityEuropean' and $mcAnnexType = 'ISDA2009EquityEuropeanIS' ">true</xsl:when>
<xsl:when test="$mcType = 'EquitySwapGlobalPrivate' ">true</xsl:when>
<xsl:when test="$mcType = 'EmergingEquitySwapIndustry' and $productType = 'Equity Index Swap' ">true</xsl:when>
<xsl:when test="$mcType = 'EmergingEquitySwapLATAM' and ($productType = 'Equity Index Swap' or $productType = 'Equity Share Swap') ">true</xsl:when>
<xsl:when test="$mcType = 'EmergingEquitySwapEMEA' and ($productType = 'Equity Index Swap' or $productType = 'Equity Share Swap') ">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:if test="fpml:componentSecurityIndexAnnexFallback and $componentSecurityIndexAnnexFallbackFieldApplicable = 'false' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected componentSecurityIndexAnnexFallback element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:componentSecurityIndexAnnexFallback = 'true' and fpml:multipleExchangeIndexAnnexFallback = 'true'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** componentSecurityIndexAnnexFallback and multipleExchangeIndexAnnexFallback are mutually exclusive.</text>
</error>
</xsl:if>
<xsl:if test="fpml:localJurisdiction and not(/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'ISDA2005EquitySwapAsiaExcludingJapanInterdealer' or /fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType ='ISDA2009EquitySwapPanAsia' or /fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType ='EquitySwapPanAsiaPrivate' or /fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType ='ISDA2009EquityFinanceSwapAsiaExcludingJapan')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected localJurisdiction element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:returnLeg/fpml:fxFeature and not ($docsType = 'Equity Swap (Pan Asia)' or $docsType = 'Equity Swap (AEJ)') ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected fxFeature element in this context. Element must not be present when Docs Type is not 'Equity Swap (Pan Asia)' or 'Equity Swap (AEJ)'.</text>
</error>
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
<xsl:if test="(not(fpml:extraordinaryEvents/fpml:specifiedExchangeId) and $mcAnnexType ='ISDA2010FairValueShareSwapEuropeanInterdealer')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing fpml:extraordinaryEvents/fpml:specifiedExchangeId element in this context.</text>
</error>
</xsl:if>
<xsl:if test="(fpml:extraordinaryEvents/fpml:specifiedExchangeId and $mcAnnexType!='ISDA2010FairValueShareSwapEuropeanInterdealer' and not($productType = 'Equity Basket Swap'))">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected fpml:extraordinaryEvents/fpml:specifiedExchangeId element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="not($productType = 'Equity Basket Swap')">
<xsl:apply-templates select="fpml:extraordinaryEvents">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
<xsl:if test="($productType='Equity Share Swap' and $mcType = 'ISDA2004EquityAmericasInterdealer')">
<xsl:if test="fpml:returnLeg/fpml:return/fpml:returnType != 'Total'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Only Return Type of 'Total' is supported for Equity Share Swap under 2004 Interdealer MCA. </text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="($productType='Equity Index Swap' and $mcType = 'ISDA2004EquityAmericasInterdealer')">
<xsl:if test="fpml:returnLeg/fpml:return/fpml:returnType != 'Price'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Only Return Type of 'Price' is supported for Equity Index Swap under 2004 Interdealer MCA. </text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="(($productType = 'Equity Index Swap' or $productType = 'Equity Share Swap' or $productType= 'Equity Basket Swap') and ($mcType = 'ISDA2009EquitySwapPanAsia' or $mcType = 'EquitySwapPanAsiaPrivate'))">
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
</xsl:if>
<xsl:if test="($productType='Equity Share Swap' and ($mcType = 'ISDA2009EquitySwapPanAsia' or $mcType = 'EquitySwapPanAsiaPrivate'))">
<xsl:if test="fpml:returnLeg/fpml:return/fpml:returnType = 'Total' and not(fpml:returnLeg/fpml:rateOfReturn//fpml:valuationRules/fpml:dividendValuationDates or fpml:returnLeg/fpml:return/fpml:dividendConditions)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Cannot determine Dividend Valuation Method </text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="($productType='Equity Index Swap' and ($mcType = 'ISDA2009EquitySwapPanAsia' or $mcType = 'EquitySwapPanAsiaPrivate'))">
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
<xsl:template match="fpml:swVolatilitySwapTransactionSupplement">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="$productType='Equity Share Volatility Swap' or $productType='Equity Index Volatility Swap' ">
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
<xsl:if test="fpml:multipleExchangeIndexAnnexFallback and ($productType='Equity Share Volatility Swap' or $docsType='Volatility Swap (Japan)' or $docsType='Volatility Swap (Americas)')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected multipleExchangeIndexAnnexFallback element encountered in this contex when product type is 'Equity Share Volatility Swap' or when Docs Type is 'Volatility Swap (Japan)' or 'Volatility Swap (Americas)'.</text>
</error>
</xsl:if>
<xsl:variable name="componentSecurityIndexAnnexFallbackFieldApplicable">
<xsl:value-of select="false"/>
</xsl:variable>
<xsl:if test="fpml:componentSecurityIndexAnnexFallback and $componentSecurityIndexAnnexFallbackFieldApplicable = 'false' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected componentSecurityIndexAnnexFallback element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:localJurisdiction and ($productType = 'Equity Index Volatility Swap' or $docsType!='Volatility Swap (AEJ)')">
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
<xsl:apply-templates select="fpml:swVolatilityLeg">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:extraordinaryEvents">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="($productType!='Equity Index Swap' and $mcAnnexType!='ISDA2010FairValueShareSwapEuropeanInterdealer')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected fpml:extraordinaryEvents element encountered in this context.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:additionalDisruptionEvents">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:additionalDisruptionEvents">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="fpml:swEarlyTerminationProvisionIndicator">
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">swEarlyTerminationProvisionIndicator</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swEarlyTerminationProvisionIndicator"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:varianceLeg">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="($productType!='Dispersion Variance Swap')">
<xsl:variable name="payer">
<xsl:value-of select="fpml:payerPartyReference/@href"/>
</xsl:variable>
<xsl:if test="not(/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:buyerPartyReference[@href=$payer])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The payerPartyReference/@href value does not match the /fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/trade/equitySwapTransactionSupplement/buyerPartyReference. Value = '<xsl:value-of select="$payer"/>'.</text>
</error>
</xsl:if>
<xsl:variable name="receiver">
<xsl:value-of select="fpml:receiverPartyReference/@href"/>
</xsl:variable>
<xsl:if test="not(/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:sellerPartyReference[@href=$receiver])">
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
<xsl:if test=".//fpml:underlyer/fpml:singleUnderlyer//fpml:index ">
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
<xsl:if test=".//fpml:underlyer/fpml:singleUnderlyer//fpml:equity">
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
<xsl:if test="not(//fpml:swStructuredTradeDetails/fpml:FpML/fpml:party[@id=$payer])">
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
<xsl:if test="not(//fpml:swStructuredTradeDetails/fpml:FpML/fpml:party[@id=$receiver])">
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
<xsl:template match="fpml:swVolatilityLeg">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="$productType='Equity Share Volatility Swap' or $productType='Equity Index Volatility Swap'">
<xsl:variable name="payer">
<xsl:value-of select="fpml:payerPartyReference/@href"/>
</xsl:variable>
<xsl:if test="not(/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:party[@id=$payer])">
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
<xsl:if test="not(/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:party[@id=$receiver])">
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
<xsl:if test="fpml:fxFeature and $docsType != 'Volatility Swap (AEJ)'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected fxFeature element in this context. Element must not be present when Docs Type is not 'Volatility Swap (AEJ)'.</text>
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
<xsl:template match="fpml:valuation">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="$productType = 'Equity Share Volatility Swap' or $productType='Equity Index Volatility Swap'">
<xsl:if test="(./@id !='valuationDate' or not(./@id))">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** @id must be present and must be equal to "valuationDate" in this context if product type is 'Equity Share Volatility Swap' or 'Equity Index Volatility Swap'. Value = "<xsl:value-of select="./@id"/>".</text>
</error>
</xsl:if>
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
<xsl:if test="fpml:futuresPriceValuation and ($productType = 'Equity Share Volatility Swap')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected futuresPriceValuation element encountered in this context when product type is 'Equity Share Volatility Swap'.</text>
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
<xsl:template match="fpml:swAmount">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="fpml:allDividends and ($productType = 'Equity Index Volatility Swap' or ($docsType='Volatility Swap (Japan)' or $docsType='Volatility Swap (Americas)'))">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected allDividends element encountered in this context when productType is 'Equity Index Volatility Swap' or Docs Type is 'Volatility Swap (Japan)' or Docs Type is 'Variance Swap (Americas)'.</text>
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
<xsl:if test="fpml:swInitialLevelSource">
<xsl:call-template name="InitialLevelSource">
<xsl:with-param name="elementName">swInitialLevelSource</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swInitialLevelSource"/>
</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
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
<xsl:if test="not(fpml:swVolatilityStrikePrice)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swVolatilityStrikePrice element in this context.</text>
</error>
</xsl:if>
<xsl:choose>
<xsl:when test="$docsType='Volatility Swap (Europe)'">
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
<xsl:when test="$docsType='Volatility Swap (AEJ)' or $docsType='Volatility Swap (Japan)' or $docsType='Volatility Swap (Americas)'">
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
<xsl:if test="(fpml:interestLegCalculationPeriodDates/fpml:interestLegPaymentDates/fpml:periodicDates/fpml:calculationPeriodDatesAdjustments/fpml:businessDayConvention[.='NotApplicable'] or fpml:interestLegCalculationPeriodDates/fpml:interestLegPaymentDates/fpml:periodicDates/fpml:calculationPeriodDatesAdjustments/fpml:businessDayConvention[.='NONE']) and (//fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swEquitySwapDetails/fpml:swSchedulingMethod!='ListDateEntry')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid businessDayConvention element value.Value = '<xsl:value-of select="fpml:interestLegCalculationPeriodDates/fpml:interestLegPaymentDates/fpml:periodicDates/fpml:calculationPeriodDatesAdjustments/fpml:businessDayConvention"/>'</text>
</error>
</xsl:if>
<xsl:if test="(fpml:interestLegCalculationPeriodDates/fpml:interestLegPaymentDates/fpml:adjustableDates/fpml:dateAdjustments/fpml:businessDayConvention[.='NotApplicable'] or fpml:interestLegCalculationPeriodDates/fpml:interestLegPaymentDates/fpml:adjustableDates/fpml:dateAdjustments/fpml:businessDayConvention[.='NONE']) and (//fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swEquitySwapDetails/fpml:swSchedulingMethod!='ListDateEntry')">
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
<xsl:if test="fpml:resetRelativeTo and not(//fpml:swSchedulingMethod = 'ListDateEntry')">
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
<xsl:if test="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swEquitySwapDetails/fpml:swFullyFunded    or /fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swEquitySwapDetails/fpml:swSpreadDetails    or /fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swEquitySwapDetails/fpml:swFixedRateIndicator='true' ">
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
<xsl:if test="fpml:adjustableDates and not(//fpml:swSchedulingMethod = 'ListDateEntry')">
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
<xsl:if test="fpml:adjustableDates and not(//fpml:swSchedulingMethod = 'ListDateEntry')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected adjustableDates element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:adjustableDates) and //fpml:swSchedulingMethod = 'ListDateEntry'">
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
<xsl:if test="($productType='Equity Share Swap' or $productType='Equity Index Swap' or $productType= 'Equity Basket Swap')">
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
<xsl:if test="not(fpml:businessCenters) and ($productType='Equity Share Swap' or $productType='Equity Index Swap' or $productType= 'Equity Basket Swap')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing businessCenters element in this context.</text>
</error>
</xsl:if>
<xsl:if test="not(//fpml:swEquitySwapDetails/fpml:swBulletIndicator = 'true') and fpml:dateRelativeTo/@href != 'interimValuationDate'">
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
<xsl:when test="$mcType = 'ISDA2004EquityAmericasInterdealer' ">false</xsl:when>
<xsl:when test="$mcType = 'ISDA2009EquitySwapAmericas' ">true</xsl:when>
<xsl:when test="$mcType = 'EquitySwapAmericasPrivate' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2009EquityEuropeanInterdealer' and $mcAnnexType = 'ISDA2009EquityEuropeanInterdealerAnnexSS' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2009EquityEuropeanInterdealer' and $mcAnnexType = 'ISDA2010FairValueShareSwapEuropeanInterdealer' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2009EquityEuropeanInterdealer' and $mcAnnexType = 'ISDA2009IndexSwapEuropeanInterdealer' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2007EquityEuropean' and $mcAnnexType = 'ISDA2009EquityEuropeanIS' ">true</xsl:when>
<xsl:when test="$mcType = 'EquitySwapEuropePrivate' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2007EquityFinanceSwapEuropean' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2009EquitySwapPanAsia' ">true</xsl:when>
<xsl:when test="$mcType = 'EquitySwapPanAsiaPrivate' ">true</xsl:when>
<xsl:when test="$mcType = 'EquitySwapGlobalPrivate' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2005EquitySwapAsiaExcludingJapanInterdealer' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2008EquityFinanceSwapAsiaExcludingJapan' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2009EquityFinanceSwapAsiaExcludingJapan' ">true</xsl:when>
<xsl:when test="$mcType = 'EmergingEquitySwapIndustry' ">true</xsl:when>
<xsl:when test="$mcType = 'EmergingEquitySwapLATAM' and ($productType = 'Equity Index Swap' or $productType = 'Equity Share Swap') ">true</xsl:when>
<xsl:when test="$mcType = 'EmergingEquitySwapEMEA' and ($productType = 'Equity Index Swap' or $productType = 'Equity Share Swap') ">true</xsl:when>
<xsl:when test="$mcType = 'EquitySwapAEJPrivate' ">false</xsl:when>
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
<xsl:if test="not(($productType='Equity Share Swap' or $productType='Equity Index Swap' or $productType='Equity Basket Swap') and (fpml:floatingRateIndex = 'GBP-SONIA' or fpml:floatingRateIndex = 'CHF-SARON' or fpml:floatingRateIndex = 'USD-SOFR' or fpml:floatingRateIndex = 'USD-Overnight Bank Funding Rate' or fpml:floatingRateIndex = 'USD-Federal Funds-H.15' or fpml:floatingRateIndex = 'USD-Federal Funds' or fpml:floatingRateIndex = 'EUR-EuroSTR' or fpml:floatingRateIndex = 'JPY-TONA' or fpml:floatingRateIndex = 'AUD-AONIA' or fpml:floatingRateIndex = 'CAD-CORRA' or fpml:floatingRateIndex = 'HKD-HONIA' or fpml:floatingRateIndex = 'SGD-SORA' or fpml:floatingRateIndex = 'GBP-SONIA-COMPOUND' or fpml:floatingRateIndex = 'GBP-SONIA-OIS Compound' or fpml:floatingRateIndex = 'USD-SOFR-COMPOUND' or fpml:floatingRateIndex = 'USD-SOFR-OIS Compound' or fpml:floatingRateIndex = 'USD-Federal Funds-H.15-OIS-COMPOUND' or fpml:floatingRateIndex = 'USD-Federal Funds-OIS Compound' or fpml:floatingRateIndex = 'EUR-EuroSTR-COMPOUND' or fpml:floatingRateIndex = 'EUR-EuroSTR-OIS Compound' or fpml:floatingRateIndex = 'CHF-SARON-OIS-COMPOUND' or fpml:floatingRateIndex = 'CHF-SARON-OIS Compound' or fpml:floatingRateIndex = 'CAD-CORRA-OIS-COMPOUND' or fpml:floatingRateIndex = 'CAD-CORRA-OIS Compound' or fpml:floatingRateIndex = 'JPY-TONA-OIS-COMPOUND' or fpml:floatingRateIndex = 'JPY-TONA-OIS Compound' or fpml:floatingRateIndex = 'SGD-SORA-COMPOUND' or fpml:floatingRateIndex = 'SGD-SORA-OIS Compound' or fpml:floatingRateIndex = 'EUR-EONIA' or fpml:floatingRateIndex = 'EUR-EONIA-OIS-COMPOUND' or fpml:floatingRateIndex = 'EUR-EONIA-OIS Compound')) ">
<xsl:if test="not(fpml:indexTenor) ">
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
<xsl:if test="not($productType='Equity Share Swap' or $productType='Equity Index Swap' or $productType='Equity Basket Swap')">
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
<xsl:if test="($productType='Equity Share Swap' or $productType='Equity Index Swap'  or $productType='Equity Basket Swap')">
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
<xsl:if test="fpml:adjustableDates and not(//fpml:swSchedulingMethod = 'ListDateEntry')">
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
<xsl:if test="(fpml:rateOfReturn/fpml:valuationPriceInterim/fpml:valuationRules/fpml:valuationDates/fpml:periodicDates/fpml:calculationPeriodDatesAdjustments/fpml:businessDayConvention[.='NotApplicable'] or fpml:rateOfReturn/fpml:valuationPriceInterim/fpml:valuationRules/fpml:valuationDates/fpml:periodicDates/fpml:calculationPeriodDatesAdjustments/fpml:businessDayConvention[.='NONE']) and (//fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swEquitySwapDetails/fpml:swSchedulingMethod!='ListDateEntry')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid businessDayConvention element value.Value = '<xsl:value-of select="fpml:rateOfReturn/fpml:valuationPriceInterim/fpml:valuationRules/fpml:valuationDates/fpml:periodicDates/fpml:calculationPeriodDatesAdjustments/fpml:businessDayConvention"/>'</text>
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
<xsl:if test="fpml:fxFeature and not(/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'ISDA2005EquitySwapAsiaExcludingJapanInterdealer' or /fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType ='ISDA2009EquitySwapPanAsia' or /fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType ='EquitySwapPanAsiaPrivate')">
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
<xsl:if test="fpml:valuationPriceInterim and (//fpml:swEquitySwapDetails/fpml:swBulletIndicator = 'true' or //fpml:swEquitySwapDetails/fpml:swFullyFunded or //fpml:swEquitySwapDetails/fpml:swSpreadDetails)">
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
<xsl:apply-templates select="fpml:netPrice">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
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
<xsl:template match="fpml:netPrice">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:variable name="amountMinValue">
<xsl:choose>
<xsl:when test="$productType = 'Equity Share Swap' and //fpml:swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swCorporateActionFlag = 'true'">0</xsl:when>
<xsl:when test="$productType = 'Equity Share Swap' and //fpml:swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swAmendmentType = 'CorporateAction'">0</xsl:when>
<xsl:when test="$productType = 'Equity Share Swap' and //fpml:swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swAmendmentType = 'CorporateActionAmendment'">0</xsl:when>
<xsl:otherwise>0.000001</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:if test="not(fpml:currency)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing currency element in this context.</text>
</error>
</xsl:if>
<xsl:if test="$docsType = 'Equity Swap (Europe)' or $docsType = 'Equity Swap (Americas)' ">
<xsl:if test="fpml:amount">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">amount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:amount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">
<xsl:value-of select="$amountMinValue"/>
</xsl:with-param>
<xsl:with-param name="maxIncl">99999.999999</xsl:with-param>
<xsl:with-param name="maxDecs">6</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
</xsl:if>
<xsl:if test="$docsType = 'Equity Swap (AEJ)' ">
<xsl:if test="fpml:amount">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">amount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:amount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">
<xsl:value-of select="$amountMinValue"/>
</xsl:with-param>
<xsl:with-param name="maxIncl">9999999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">6</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
</xsl:if>
<xsl:if test="$mcType = 'EquitySwapGlobalPrivate' ">
<xsl:if test="fpml:amount">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">amount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:amount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">
<xsl:value-of select="$amountMinValue"/>
</xsl:with-param>
<xsl:with-param name="maxIncl">999999999.999999</xsl:with-param>
<xsl:with-param name="maxDecs">6</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
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
<xsl:if test="($productType = 'Equity Share Swap' or $productType = 'Equity Index Swap'  or $productType = 'Equity Basket Swap') and $docsType = 'Equity Swap (AEJ)' and (//fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType = 'ISDA2005EquitySwapAsiaExcludingJapanInterdealer')">
<xsl:if test="self::fpml:valuationPriceFinal and fpml:determinationMethod != 'AsSpecifiedInMasterConfirmation'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected value of 'determinationMethod' in the context, only 'AsSpecifiedInMasterConfirmation' is allowed for AEJ 2005 ISDA EIS or ESS.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="($productType = 'Equity Index Swap') and $docsType = 'Equity Swap (Americas)' and ($mcType = 'ISDA2004EquityAmericasInterdealer' or $mcType = 'ISDA2009EquitySwapAmericas')">
<xsl:if test="self::fpml:valuationPriceFinal and (fpml:determinationMethod != 'Close' and fpml:determinationMethod != 'AsSpecifiedInMasterConfirmation')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected value of 'determinationMethod' in the context, only 'Close' and 'AsSpecifiedInMasterConfirmation' are allowed for ISDA 2004 Interdealer and ISDA 2009 on America MCA EIS.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="($productType = 'Equity Index Swap') and $docsType = 'Equity Swap (Europe)' and $mcType = 'ISDA2009EquityEuropeanInterdealer'">
<xsl:if test="self::fpml:valuationPriceFinal and fpml:determinationMethod != 'Close'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected value of 'determinationMethod' in the context, only 'Close' is allowed for Europe 2009 ISDA EIS.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="($productType = 'Equity Index Swap') and $docsType = 'Equity Swap (Global)' and $mcType = 'EquitySwapGlobalPrivate'">
<xsl:if test="self::fpml:valuationPriceFinal and fpml:determinationMethod != 'Close' and fpml:determinationMethod != 'AsSpecifiedInMasterConfirmation' and fpml:determinationMethod != 'HedgeExecution' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected value of 'determinationMethod' in the context, only 'Close', 'AsSpecifiedInMasterConfirmation', 'HedgeExecution' are allowed for Global Priavte EIS.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="($productType = 'Equity Index Swap' or $productType = 'Equity Share Swap') and $docsType = 'Equity Swap (Pan Asia)' and $mcType = 'ISDA2009EquitySwapPanAsia'">
<xsl:if test="self::fpml:valuationPriceFinal and fpml:determinationMethod != 'Close' and fpml:determinationMethod != 'AsSpecifiedInMasterConfirmation' and fpml:determinationMethod != 'HedgeExecution' and fpml:determinationMethod != 'TWAP' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected value of 'determinationMethod' in the context, only 'Close','AsSpecifiedInMasterConfirmation' and 'HedgeExecution' and 'TWAP' are allowed for PanAsia 2009 ISDA EIS and ESS.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="($productType = 'Equity Index Swap') and $docsType = 'Equity Swap (AEJ)' and $mcType = 'EquitySwapAEJPrivate'">
<xsl:if test="self::fpml:valuationPriceFinal and (fpml:determinationMethod != 'Close' and fpml:determinationMethod !='AsSpecifiedInMasterConfirmation' and fpml:determinationMethod !='HedgeExecution')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected value of 'determinationMethod' in the context, only 'Close', 'AsSpecifiedInMasterConfirmation' or 'HedgeExecution' are allowed for AEJ Private EIS</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="($productType = 'Equity Index Swap') and $docsType = 'Equity Swap (Emerging)' and ($mcType = 'EmergingEquitySwapIndustry')">
<xsl:if test="self::fpml:valuationPriceFinal and (fpml:determinationMethod != 'Close' and fpml:determinationMethod != 'AsSpecifiedInMasterConfirmation' and fpml:determinationMethod != 'HedgeExecution')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected value of 'determinationMethod' in the context, only 'Close', 'AsSpecifiedInMasterConfirmation' or 'HedgeExecution' are allowed for Emerging Industry EIS.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$productType = 'Equity Share Swap' and $docsType = 'Equity Swap (Americas)' and $mcType = 'ISDA2004EquityAmericasInterdealer'">
<xsl:if test="self::fpml:valuationPriceFinal and fpml:determinationMethod != 'AsSpecifiedInMasterConfirmation' and fpml:determinationMethod != 'Close'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected value of 'determinationMethod' in the context, only 'AsSpecifiedInMasterConfirmation' or 'Close' are allowed for Americas 2004 Interdealer ESS.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="($productType = 'Equity Share Swap') and $docsType = 'Equity Swap (Americas)' and $mcType = 'ISDA2009EquitySwapAmericas'">
<xsl:if test="self::fpml:valuationPriceFinal and (fpml:determinationMethod != 'VWAP' and fpml:determinationMethod != 'Close')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected value of 'determinationMethod' in the context, only 'VWAP' and 'Close' are allowed for Americas 2009 ISDA ESS.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="($productType = 'Equity Share Swap') and $docsType = 'Equity Swap (Europe)' and ($mcType = 'ISDA2009EquityEuropeanInterdealer' or $mcType = 'ISDA2007EquityFinanceSwapEuropean')">
<xsl:if test="self::fpml:valuationPriceFinal and (fpml:determinationMethod != 'AsSpecifiedInMasterConfirmation' and fpml:determinationMethod != 'Close' and fpml:determinationMethod != 'HedgeExecution')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected value of 'determinationMethod' in the context, only 'AsSpecifiedInMasterConfirmation', 'HedgeExecution' and 'Close' are allowed for Europe 2007, 2009 ISDA and 2009 ISDA FVSS for ESS.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="($productType = 'Equity Share Swap') and $docsType = 'Equity Swap (AEJ)' and $mcType = 'EquitySwapAEJPrivate'">
<xsl:if test="self::fpml:valuationPriceFinal and (fpml:determinationMethod != 'Close' and fpml:determinationMethod !='AsSpecifiedInMasterConfirmation' and fpml:determinationMethod !='HedgeExecution' and fpml:determinationMethod !='VWAP')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected value of 'determinationMethod' in the context, only 'Close', 'AsSpecifiedInMasterConfirmation', 'VWAP' or 'HedgeExecution' are allowed for AEJ Private ESS</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="($productType = 'Equity Share Swap' ) and $docsType = 'Equity Swap (Emerging)' and ($mcType = 'EmergingEquitySwapIndustry')">
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
<xsl:apply-templates select="fpml:valuationRules">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:valuationRules">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="fpml:valuationDate and ancestor::fpml:valuationPriceInterim">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected valuationDate element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:valuationDate and not(fpml:valuationDate/@id = 'finalValuationDate')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** valuationDate/@id must be equal to 'finalValuationDate' in this context. Value = '<xsl:value-of select="fpml:valuationDate/@id"/>'</text>
</error>
</xsl:if>
<xsl:if test="fpml:valuationDates and ancestor::fpml:valuationPriceFinal">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected valuationDates element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:valuationDates and not(fpml:valuationDates/@id = 'interimValuationDate')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** valuationDates/@id must be equal to 'interimValuationDate' in this context. Value = '<xsl:value-of select="fpml:valuationDates/@id"/>'</text>
</error>
</xsl:if>
<xsl:if test="ancestor::fpml:valuationPriceInterim">
<xsl:apply-templates select="fpml:valuationDates">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
<xsl:if test="ancestor::fpml:valuationPriceFinal">
<xsl:apply-templates select="fpml:valuationDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
<xsl:if test="not(fpml:valuationTimeType)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing valuationTimeType element in this context.</text>
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
<xsl:if test="fpml:futuresPriceValuation and not(ancestor::fpml:valuationPriceFinal and ($productType = 'Equity Index Swap' or ($productType = 'Equity Share Swap' or $productType = 'Equity Basket Swap' and ($mcType = 'EquitySwapAEJPrivate' or $mcType = 'EquitySwapGlobalPrivate' or $mcType = 'EquitySwapEuropePrivate' or $mcType = 'EquitySwapAmericasPrivate'))))">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected futuresPriceValuation element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:futuresPriceValuation and ($productType = 'Equity Share Swap' or $productType = 'Equity Basket Swap') and not($mcType = 'EquitySwapAEJPrivate' or $mcType = 'EquitySwapGlobalPrivate' or $mcType = 'EquitySwapEuropePrivate' or $mcType = 'EquitySwapAmericasPrivate') ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected futuresPriceValuation element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="futuresPriceValuation">
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
</xsl:if>
<xsl:if test="fpml:optionsPriceValuation">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected optionsPriceValuation element encountered in this context.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:valuationDates">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:variable name="equityValuationMethod">
<xsl:value-of select="fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swEquityOptionDetails/fpml:swEquityValuationMethod"/>
</xsl:variable>
<xsl:if test="fpml:adjustableDates and $docsType!='Equity Options (Cliquet)' and not(//fpml:swSchedulingMethod = 'ListDateEntry')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected adjustableDates element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:adjustableDates) and (//fpml:swSchedulingMethod = 'ListDateEntry')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing adjustableDates element in this context for ListDateEntry mode.</text>
</error>
</xsl:if>
<xsl:if test="fpml:relativeDateSequence">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected relativeDateSequence element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="$docsType='Equity Options (Cliquet)'">
<xsl:if test="$equityValuationMethod='Custom' or $equityValuationMethod='Asian Tail' and not(fpml:adjustableDates)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing adjustableDates element. Adjustable dates must be specified when swEquityValuationMethod is 'Custom' or 'Asian Tail'.</text>
</error>
</xsl:if>
<xsl:for-each select="fpml:adjustableDates/fpml:unadjustedDate">
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
</xsl:for-each>
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
<xsl:variable name="equityValuationMethod">
<xsl:value-of select="fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swEquityOptionDetails/fpml:swEquityValuationMethod"/>
</xsl:variable>
<xsl:if test="$docsType='Equity Options (Cliquet)' and $equityValuationMethod='Frequency' and not(fpml:calculationStartDate)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing calculationStartDate element in this context.</text>
</error>
</xsl:if>
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
<xsl:when test="$productType = 'Equity Share Swap' or $productType = 'Equity Index Swap' or $productType = 'Equity Basket Swap' "/>
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
<xsl:if test="fpml:adjustableDates and not(//fpml:swSchedulingMethod = 'ListDateEntry')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected adjustableDates element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:adjustableDates) and (//fpml:swSchedulingMethod = 'ListDateEntry')">
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
<xsl:if test="fpml:adjustableDates and not(//fpml:swSchedulingMethod = 'ListDateEntry')">
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
<xsl:template match="fpml:amount">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="not($productType='Equity Accumulator' or $productType='Equity Decumulator')">
<xsl:if test="productType='Dispersion Variance Swap'">
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
<xsl:apply-templates select="fpml:variance">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:observationStartDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:if>
<xsl:if test="($productType!='Dispersion Variance Swap')">
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
</xsl:if>
</xsl:template>
<xsl:template match="fpml:return">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="$productType = 'Equity Share Swap' or $productType = 'Equity Index Swap' or $productType= 'Equity Basket Swap' ">
<xsl:if test="fpml:dividendConditions and fpml:returnType != 'Total' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected dividendConditions element encountered where returnType is not 'Total'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:dividendConditions and not($productType = 'Equity Basket Swap')">
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
<xsl:if test="fpml:dividendReinvestment and not($mcType='ISDA2005EquitySwapAsiaExcludingJapanInterdealer' or $mcType='EquitySwapAEJPrivate')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected dividendReinvestment element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:dividendEntitlement">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected dividendEntitlement element encountered in this context.</text>
</error>
</xsl:if>
<xsl:variable name="dividendPaymentDateApplicable">
<xsl:choose>
<xsl:when test="$mcType='ISDA2009EquityEuropeanInterdealer'">true</xsl:when>
<xsl:when test="$mcType='ISDA2009EquitySwapPanAsia' and $productType='Equity Index Swap'">true</xsl:when>
<xsl:when test="$mcType='EquitySwapPanAsiaPrivate' and $productType='Equity Index Swap'">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:if test="not(fpml:dividendPaymentDate) and $dividendPaymentDateApplicable='true'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing dividendPaymentDate element in this context.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:dividendPaymentDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:variable name="dividendPeriodEffectiveDateElementApplicable">
<xsl:choose>
<xsl:when test="$mcType = 'ISDA2009EquityEuropeanInterdealer' and $mcAnnexType = 'ISDA2009IndexSwapEuropeanInterdealer' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2007EquityEuropean' and $mcAnnexType = 'ISDA2009EquityEuropeanIS' ">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:if test="fpml:dividendPeriodEffectiveDate and $dividendPeriodEffectiveDateElementApplicable='false' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected dividendPeriodEffectiveDate element encountered in this context.</text>
</error>
</xsl:if>
<xsl:variable name="dividendPeriodEndDateElementApplicable">
<xsl:choose>
<xsl:when test="$mcType = 'ISDA2009EquityEuropeanInterdealer' and $mcAnnexType = 'ISDA2009IndexSwapEuropeanInterdealer' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2007EquityEuropean' and $mcAnnexType = 'ISDA2009EquityEuropeanIS' ">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:if test="fpml:dividendPeriodEndDate and $dividendPeriodEndDateElementApplicable='false' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected dividendPeriodEndDate element encountered in this context.</text>
</error>
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
<xsl:when test="$mcType = 'EquitySwapAmericasPrivate' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2009EquityEuropeanInterdealer' and $mcAnnexType = 'ISDA2009EquityEuropeanInterdealerAnnexSS' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2009EquityEuropeanInterdealer' and $mcAnnexType = 'ISDA2010FairValueShareSwapEuropeanInterdealer' ">true</xsl:when>
<xsl:when test="$mcType = 'EmergingEquitySwapIndustry' ">true</xsl:when>
<xsl:when test="$mcType = 'EmergingEquitySwapLATAM' and ($productType = 'Equity Index Swap' or $productType = 'Equity Share Swap') ">true</xsl:when>
<xsl:when test="$mcType = 'EmergingEquitySwapEMEA' and ($productType = 'Equity Index Swap' or $productType = 'Equity Share Swap') ">true</xsl:when>
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
<xsl:when test="$mcType = 'ISDA2009EquitySwapAmericas' and $productType = 'Equity Index Swap' ">true</xsl:when>
<xsl:when test="$mcType = 'EquitySwapAmericasPrivate' and $productType = 'Equity Index Swap' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2009EquityEuropeanInterdealer' and $mcAnnexType = 'ISDA2009EquityEuropeanInterdealerAnnexSS' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2009EquityEuropeanInterdealer' and $mcAnnexType = 'ISDA2010FairValueShareSwapEuropeanInterdealer' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2009EquityEuropeanInterdealer' and $mcAnnexType = 'ISDA2009IndexSwapEuropeanInterdealer' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2007EquityEuropean' and $mcAnnexType = 'ISDA2009EquityEuropeanIS' ">true</xsl:when>
<xsl:when test="$mcType = 'EquitySwapGlobalPrivate' ">true</xsl:when>
<xsl:when test="$mcType = 'EmergingEquitySwapIndustry' ">true</xsl:when>
<xsl:when test="$mcType = 'EmergingEquitySwapEMEA' and ($productType = 'Equity Index Swap' or $productType = 'Equity Share Swap')">true</xsl:when>
<xsl:when test="$mcType = 'EmergingEquitySwapLATAM' and ($productType = 'Equity Index Swap' or $productType = 'Equity Share Swap')">true</xsl:when>
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
<xsl:variable name="declaredCashEquivalentDividendPercentageFieldApplicable">
<xsl:choose>
<xsl:when test="$mcType = 'ISDA2009EquitySwapAmericas' and $productType = 'Equity Index Swap' ">true</xsl:when>
<xsl:when test="$mcType = 'EquitySwapAmericasPrivate' and $productType = 'Equity Index Swap' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2009EquityEuropeanInterdealer' and $mcAnnexType = 'ISDA2009EquityEuropeanInterdealerAnnexSS' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2009EquityEuropeanInterdealer' and $mcAnnexType = 'ISDA2010FairValueShareSwapEuropeanInterdealer' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2009EquityEuropeanInterdealer' and $mcAnnexType = 'ISDA2009IndexSwapEuropeanInterdealer' ">true</xsl:when>
<xsl:when test="$mcType = 'ISDA2007EquityEuropean' and $mcAnnexType = 'ISDA2009EquityEuropeanIS' ">true</xsl:when>
<xsl:when test="$mcType = 'EquitySwapGlobalPrivate' ">true</xsl:when>
<xsl:when test="$mcType = 'EmergingEquitySwapIndustry' ">true</xsl:when>
<xsl:when test="$mcType = 'EmergingEquitySwapEMEA' and ($productType = 'Equity Index Swap' or $productType = 'Equity Share Swap')">true</xsl:when>
<xsl:when test="$mcType = 'EmergingEquitySwapLATAM' and ($productType = 'Equity Index Swap' or $productType = 'Equity Share Swap')">true</xsl:when>
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
<xsl:if test="fpml:declaredCashEquivalentDividendPercentage and $declaredCashEquivalentDividendPercentageFieldApplicable = 'true'">
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
<xsl:when test="$mcType = 'ISDA2009EquityEuropeanInterdealer' and $mcAnnexType = 'ISDA2009EquityEuropeanInterdealerAnnexSS' ">true</xsl:when>
<xsl:when test="$mcType = 'EmergingEquitySwapIndustry' ">true</xsl:when>
<xsl:when test="$mcType = 'EmergingEquitySwapLATAM' and ($productType = 'Equity Index Swap' or $productType = 'Equity Share Swap') ">true</xsl:when>
<xsl:when test="$mcType = 'EmergingEquitySwapEMEA' and ($productType = 'Equity Index Swap' or $productType = 'Equity Share Swap') ">true</xsl:when>
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
<xsl:if test="$productType = 'Equity Share Swap' and not(fpml:nonCashDividendTreatment) and $nonCashDividendTreatmentFieldApplicable = 'true' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing nonCashDividendTreatment element in this context.</text>
</error>
</xsl:if>
<xsl:variable name="dividendCompositionFieldApplicable">
<xsl:choose>
<xsl:when test="$mcType = 'ISDA2009EquityEuropeanInterdealer' and $mcAnnexType = 'ISDA2009EquityEuropeanInterdealerAnnexSS' ">true</xsl:when>
<xsl:when test="$mcType = 'EmergingEquitySwapIndustry' ">true</xsl:when>
<xsl:when test="$mcType = 'EmergingEquitySwapLATAM' and ($productType = 'Equity Index Swap' or $productType = 'Equity Share Swap') ">true</xsl:when>
<xsl:when test="$mcType = 'EmergingEquitySwapEMEA' and ($productType = 'Equity Index Swap' or $productType = 'Equity Share Swap') ">true</xsl:when>
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
<xsl:if test="fpml:dividendAmount">
<xsl:choose>
<xsl:when test="not(fpml:dividendAmount = 'ExAmount') and not(fpml:dividendAmount = 'RecordAmount') and not(fpml:dividendAmount = 'AsSpecifiedInMasterConfirmation') and not(fpml:dividendAmount = '')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected value found for dividend amount value available are "ExAmount", "RecordAmount", "AsSpecifiedInMasterConfirmation" or empty string but found "<xsl:value-of select="fpml:dividendAmount"/>"</text>
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
<text>*** Unexpected value found for dividend period available value are "FirstPeriod", "SecondPeriod" or empty string but found "<xsl:value-of select="fpml:dividendPeriod"/>" </text>
</error>
</xsl:when>
</xsl:choose>
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
<xsl:when test="fpml:dividendDateReference = 'ExDate' and ($mcType = 'EquitySwapEuropePrivate' or $mcAnnexType = 'ISDA2009EquityEuropeanInterdealerAnnexSS') ">true</xsl:when>
<xsl:when test="fpml:dividendDateReference = 'ExDate' and $productType = 'Equity Share Swap' and $mcType = 'EmergingEquitySwapIndustry' ">true</xsl:when>
<xsl:when test="fpml:dividendDateReference = 'ExDate' and ($productType = 'Equity Share Swap' or $productType = 'Equity Index Swap') and $mcType = 'EmergingEquitySwapLATAM' ">true</xsl:when>
<xsl:when test="fpml:dividendDateReference = 'ExDate' and ($productType = 'Equity Share Swap' or $productType = 'Equity Index Swap') and $mcType = 'EmergingEquitySwapEMEA' ">true</xsl:when>
<xsl:when test="fpml:dividendDateReference = 'ExDividendPaymentDate' and $mcAnnexType = 'ISDA2010FairValueShareSwapEuropeanInterdealer' ">true</xsl:when>
<xsl:when test="fpml:dividendDateReference = 'DividendValuationDate' and ($mcType='ISDA2009EquitySwapPanAsia' or $mcType='EquitySwapPanAsiaPrivate')">true</xsl:when>
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
<xsl:if test="not(fpml:paymentCurrency)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing paymentCurrency element in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:paymentCurrency">
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
<xsl:if test="fpml:allDividends and ($productType = 'Index Variance Swap' or ($docsType='Variance Swap (Japan)' or $docsType='Variance Swap (Americas)'))">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected allDividends element encountered in this context when productType is 'Index Variance Swap' or Docs Type is 'Variance Swap (Japan)' or Docs Type is 'Variance Swap (Americas)'.</text>
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
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">amount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:varianceAmount/fpml:amount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.01</xsl:with-param>
<xsl:with-param name="maxIncl">9999999999.9999</xsl:with-param>
<xsl:with-param name="maxDecs">4</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="not(fpml:varianceStrikePrice)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing varianceStrikePrice element in this context. Element must be present for all Variance Swap products - the volatilityStrikePrice element should be submitted in the swVarianceSwapDetails or swDispersionVarianceSwapDetails component.</text>
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
<xsl:if test="not(fpml:expectedN)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing expectedN element in this context. Element must be present for all Variance Swap products.</text>
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
<xsl:with-param name="maxIncl">999999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:fxFeature and $docsType != 'Variance Swap (AEJ)'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected fxFeature element in this context. Element must not be present when Docs Type is not 'Variance Swap (AEJ)'.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:fxFeature) and $docsType='Variance Swap (AEJ)' and fpml:settlementType!='Vanilla'">
<xsl:choose>
<xsl:when test="fpml:varianceAmount/fpml:currency = 'AUD'"/>
<xsl:when test="fpml:varianceAmount/fpml:currency = 'HKD'"/>
<xsl:when test="fpml:varianceAmount/fpml:currency = 'NZD'"/>
<xsl:when test="fpml:varianceAmount/fpml:currency = 'SGD'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing fxFeature element  when Docs Type is 'Variance Swap (AEJ)' and varianceAmount/currency is a non-deliverable currency.</text>
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
<xsl:template match="fpml:businessCenters">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:apply-templates select="fpml:businessCenter">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="ancestor::fpml:returnLeg and ancestor::fpml:terminationDate">
<xsl:if test="not(fpml:businessCenter = //fpml:valuationPriceFinal/fpml:valuationRules/fpml:valuationDate/fpml:adjustableDate//fpml:businessCenter)">
<xsl:if test="fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swEquitySwapDetails/fpml:swSchedulingMethod!='ListDateEntry' or fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swEquitySwapDetails/fpml:swSchedulingMethod='' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** returnLeg/terminationDate//fpml:businessCenter must be equal tovaluationPriceFinal/valuationRules/valuationDate//fpml:businessCenter in ParameterMode.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:businessCenter">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:if test="not(ancestor::fpml:valuationRules or (ancestor::fpml:returnLeg and ancestor::fpml:effectiveDate) or (ancestor::fpml:returnLeg and ancestor::fpml:terminationDate) or ancestor::fpml:dateAdjustments)">
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
</xsl:if>
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
<xsl:template name="isValidContractualSupplement">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="currency">
<xsl:choose>
<xsl:when test="$productType='Equity Share Option' or $productType='Equity Index Option' or $productType='Equity Share Option Strategy' or $productType='Equity Index Option Strategy'">
<xsl:value-of select="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:equityPremium/fpml:paymentAmount/fpml:currency"/>
</xsl:when>
<xsl:when test="$productType = 'Share Variance Swap' or $productType='Index Variance Swap'">
<xsl:value-of select="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:varianceLeg/fpml:equityAmount//fpml:variance/fpml:varianceAmount/fpml:currency"/>
</xsl:when>
<xsl:when test="$productType = 'Equity Share Swap' or $productType='Equity Index Swap' or $productType= 'Equity Basket Swap' ">
<xsl:value-of select="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equitySwapTransactionSupplement/fpml:returnLeg/fpml:underlyer/fpml:singleUnderlyer//fpml:currency"/>
</xsl:when>
</xsl:choose>
</xsl:variable>
<xsl:variable name="errorTextForCanadianSupplement">Empty or invalid <xsl:value-of select="$elementName"/> element when Docs Type is '<xsl:value-of select="$docsType"/>' and currency is '<xsl:value-of select="$currency"/>'. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:variable name="errorTextForOtherSupplements">Empty or invalid <xsl:value-of select="$elementName"/> element. Value ='<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='ISDAMarch2004EquityCanadianSupplement'">
<xsl:choose>
<xsl:when test="$currency='CAD' and ($docsType='Equity Options (Americas)' or $docsType='Variance Swap (Americas)' or $docsType='Equity Swap (Americas)')"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorTextForCanadianSupplement"/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$elementValue='ISDA2007FullLookthroughDepositoryReceiptSupplement'"/>
<xsl:when test="$elementValue='ISDA2007PartialLookthroughDepositoryReceiptSupplement'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorTextForOtherSupplements"/>
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
<xsl:template name="isValidEquityConfirmationType">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> element. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='Equity Options (AEJ)'"/>
<xsl:when test="$elementValue='Equity Options (Spread)'"/>
<xsl:when test="$elementValue='ISDA2005EquityAsiaExcludingJapanInterdealer'"/>
<xsl:when test="$elementValue='EquityOptionAEJPrivate'"/>
<xsl:when test="$elementValue='ISDA2008EquityAsiaExcludingJapan'"/>
<xsl:when test="$elementValue='Equity Options (Americas)'"/>
<xsl:when test="$elementValue='ISDA2004EquityAmericasInterdealer'"/>
<xsl:when test="$elementValue='ISDA2008EquityAmericas'"/>
<xsl:when test="$elementValue='ISDA2009EquityAmericas'"/>
<xsl:when test="$elementValue='EquityOptionAmericasPrivate'"/>
<xsl:when test="$elementValue='EquityCliquetOptionPrivate'"/>
<xsl:when test="$elementValue='Equity Options (Europe)'"/>
<xsl:when test="$elementValue='2004EquityEuropeanInterdealer'"/>
<xsl:when test="$elementValue='ISDA2007EquityEuropean'"/>
<xsl:when test="$elementValue='EquityOptionEuropePrivate'"/>
<xsl:when test="$elementValue='Equity Options (Japan)'"/>
<xsl:when test="$elementValue='ISDA2005EquityJapaneseInterdealer'"/>
<xsl:when test="$elementValue='ISDA2008EquityJapanese'"/>
<xsl:when test="$elementValue='Equity Options (EMEA)'"/>
<xsl:when test="$elementValue='ISDA2010EquityEMEAInterdealer'"/>
<xsl:when test="$elementValue='EquityOptionEMEAPrivate'"/>
<xsl:when test="$elementValue='EquitySpreadOptionAmericasPrivate'"/>
<xsl:when test="$elementValue='EquitySpreadOptionAmericasISDA2008'"/>
<xsl:when test="$elementValue='EquitySpreadOptionAmericasISDA2009'"/>
<xsl:when test="$elementValue='EquitySpreadOptionAmericasISDA2004'"/>
<xsl:otherwise>
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
<xsl:template name="isValidVolatilitySwapConfirmationType">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> element. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='VolatilitySwapAsiaExcludingJapanPrivate'"/>
<xsl:when test="$elementValue='VolatilitySwapAmericasPrivate'"/>
<xsl:when test="$elementValue='VolatilitySwapEuropeanPrivate'"/>
<xsl:when test="$elementValue='IVS1OpenMarkets'"/>
<xsl:when test="$elementValue='VolatilitySwapJapanesePrivate'"/>
<xsl:otherwise>
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
<xsl:template name="InitialLevelSource">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="context"/>
<xsl:if test="$elementValue != 'ExpiringContractLevel' and $elementValue != 'ClosingPrice' and $elementValue != 'OSPPricing' and $elementValue != 'IndexClosePricing'">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>
*** Invalid swInitialLevelSource value encountered in this context. Value = '<xsl:value-of select="$elementValue"/>'.</text>
</error>
</xsl:if>
<xsl:if test="$elementValue = 'ExpiringContractLevel' and $productType = 'Equity Share Volatility Swap'">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>
*** Unexpected swInitialLevelSource value encountered in this context when Product Type is 'Equity Share Volatility Swap.  Value = '<xsl:value-of select="$elementValue"/>'.</text>
</error>
</xsl:if>
<xsl:if test="$elementValue = 'OSPPricing' and $docsType != 'Volatility Swap (Open Markets)' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>
*** Unexpected swInitialLevelSource value encountered in this context when matrixTerm = 'IVS1OpenMarkets'.  Value = '<xsl:value-of select="$elementValue"/>'.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template name="isValidEquityOptionConfirmationAnnexType">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> element. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='ISDA2009IndexShareOptionAmericas' "/>
<xsl:when test="$elementValue='ISDA2010IndexShareOptionEMEAInterdealer' "/>
<xsl:otherwise>
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
<xsl:when test="$docsType='Equity Options (Spread)'"/>
<xsl:when test="($productType = 'Equity Index Option' or $productType= 'Equity Index Option Strategy') and $docsType='Equity Options (Europe)' and not($mcType='EquityOptionEuropePrivate')">
<xsl:choose>
<xsl:when test="$elementValue='OSP'"/>
<xsl:when test="$elementValue='Open'"/>
<xsl:when test="$elementValue='Close'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/> When product type is 'Equity Index Option' or 'Equity Index Option Strategy' and Docs Type is 'Equity Options (Europe)', the permitted values are 'OSP', 'Open' or 'Close'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType = 'Equity Share Option' and ($mcType='EquityOptionAmericasPrivate' or $mcType='EquityOptionAEJPrivate' or $mcType='EquityOptionEMEAPrivate')">
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
<xsl:when test="($productType = 'Equity Share Option' or $productType= 'Equity Share Option Strategy') and $docsType='Equity Options (Europe)' and not($mcType='EquityOptionEuropePrivate')">
<xsl:choose>
<xsl:when test="$elementValue='AsSpecifiedInMasterConfirmation'"/>
<xsl:when test="$elementValue='Open'"/>
<xsl:when test="$elementValue='Close'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/> When product type is 'Equity Share Option' or 'Equity Share Option Strategy' and Docs Type is 'Equity Options (Europe)', the permitted values are 'AsSpecifiedInMasterConfirmation', 'Open' or 'Close'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="($productType = 'Equity Index Option' or $productType= 'Equity Index Option Strategy') and $docsType='Equity Options (Americas)' and not($mcAnnexType='ISDA2009IndexShareOptionAmericas' or $mcType='EquityOptionAmericasPrivate') and not ($productType = 'Equity Index Option' and $mcType = 'ISDA2009EquityAmericas')">
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
<text>*** <xsl:value-of select="$errorText"/> When product type is 'Equity Index Option' or 'Equity Index Option Strategy' and Docs Type is 'Equity Options (Americas)' except product type of 'Equity Index Option' and MCA of 'ISDA2009EquityAmericas', the permitted values are 'OSP', 'Open' or 'Close'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="($productType = 'Equity Share Option' or $productType= 'Equity Share Option Strategy') and $docsType='Equity Options (Americas)' and not($mcAnnexType='ISDA2009IndexShareOptionAmericas' or $mcType='EquityOptionAmericasPrivate') and not ($productType = 'Equity Share Option' and $mcType = 'ISDA2009EquityAmericas')">
<xsl:choose>
<xsl:when test="$elementValue='AsSpecifiedInMasterConfirmation'"/>
<xsl:when test="$elementValue='Open'"/>
<xsl:when test="$elementValue='Close'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/> When product type is 'Equity Share Option' or 'Equity Share Option Strategy' and Docs Type is 'Equity Options (Americas)', the permitted values are 'AsSpecifiedInMasterConfirmation', 'Open' or 'Close'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$mcType = 'ISDA2009EquityAmericas'">
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
<text>*** <xsl:value-of select="$errorText"/> When master confirmation type is 'ISDA2009EquityAmericas', the permitted values are 'AsSpecifiedInMasterConfirmation' or 'SpecificTime' or 'OSP' or 'Close'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$mcType = 'EquityOptionAmericasPrivate' or $mcType = 'EquityOptionEuropePrivate'">
<xsl:choose>
<xsl:when test="$elementValue='AsSpecifiedInMasterConfirmation' "/>
<xsl:when test="$elementValue='SpecificTime' "/>
<xsl:when test="$elementValue='OSP'"/>
<xsl:when test="$elementValue='Close'"/>
<xsl:when test="$elementValue='Open'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/> When master confirmation type is '<xsl:value-of select="$mcType"/>', the permitted values are 'AsSpecifiedInMasterConfirmation' or 'SpecificTime' or 'OSP' or 'Open' or 'Close'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="($productType = 'Equity Index Option' or $productType= 'Equity Index Option Strategy') and $docsType='Equity Options (Japan)' and $docsSubType='2008 ISDA' and ..//fpml:futuresPriceValuation='true'">
<xsl:choose>
<xsl:when test="$elementValue='AsSpecifiedInMasterConfirmation'"/>
<xsl:when test="$elementValue='OSP'"/>
<xsl:when test="$elementValue='Close'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/> When product type is 'Equity Index Option' or 'Equity Index Option Strategy' and Docs Type is 'Equity Options (Japan)' and fpml:futuresPriceValuation='true' under the 2008 MCA, the permitted values are 'OSP' or 'Close' or 'AsSpecifiedInMasterConfirmation'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="($productType = 'Equity Share Option' or $productType = 'Equity Share Option Strategy') and $docsType='Equity Options (Japan)' and ($docsSubType='2008 ISDA' or $docsSubType='2005 ISDA')">
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
<xsl:otherwise>
<xsl:choose>
<xsl:when test="$elementValue='AsSpecifiedInMasterConfirmation'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/> Element must be passed with a value of 'AsSpecifiedInMasterConfirmation' when Docs Type is 'Equity Options (Japan)' (except where Futures Price Valuation is applicable under the 2008 MCA), or 'Equity Options (AEJ)'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template name="isValidlatestExerciseTimeType">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> element. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$mcType = 'ISDA2009EquityAmericas'">
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
<text>*** <xsl:value-of select="$errorText"/> When master confirmation type is 'ISDA2009EquityAmericas', the permitted values are 'AsSpecifiedInMasterConfirmation' or 'SpecificTime' or 'OSP' or 'Close'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$mcType = 'EquityOptionAmericasPrivate' ">
<xsl:choose>
<xsl:when test="$elementValue='AsSpecifiedInMasterConfirmation' "/>
<xsl:when test="$elementValue='SpecificTime' "/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/> When master confirmation type is 'EquityOptionAmericasPrivate', the permitted values are 'AsSpecifiedInMasterConfirmation' or 'SpecificTime'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:otherwise/>
</xsl:choose>
</xsl:template>
<xsl:template name="isValidVarianceSwapConfirmationType">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> element. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='Variance Swap (AEJ)'"/>
<xsl:when test="$elementValue='ISDA2007VarianceSwapAsiaExcludingJapan'"/>
<xsl:when test="$elementValue='Variance Swap (Americas)'"/>
<xsl:when test="$elementValue='ISDA2004EquityAmericasInterdealer'"/>
<xsl:when test="$elementValue='ISDA2007VarianceSwapAmericas'"/>
<xsl:when test="$elementValue='Variance Swap (Europe)'"/>
<xsl:when test="$elementValue='2005VarianceSwapEuropeanInterdealer'"/>
<xsl:when test="$elementValue='ISDA2007VarianceSwapEuropean'"/>
<xsl:when test="$elementValue='Variance Swap (Japan)'"/>
<xsl:when test="$elementValue='ISDA2006VarianceSwapJapaneseInterdealer'"/>
<xsl:otherwise>
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
<xsl:when test="$elementValue='2006DividendSwapEuropeanInterdealer' "/>
<xsl:when test="$elementValue='DividendSwapEuropeanPrivate' "/>
<xsl:when test="$elementValue='DividendSwapAmericasPrivate' "/>
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
<xsl:when test="$elementValue='EmergingEquitySwapEMEA' "/>
<xsl:when test="$elementValue='EmergingEquitySwapLATAM' "/>
<xsl:when test="$elementValue='EquitySwapGlobalPrivate' "/>
<xsl:when test="$elementValue='EquitySwapPanAsiaPrivate' "/>
<xsl:otherwise>
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
<xsl:template name="isValidEquitySwapConfirmationAnnexType">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> element. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='ISDA2009EquityEuropeanInterdealerAnnexSS' "/>
<xsl:when test="$elementValue='ISDA2010FairValueShareSwapEuropeanInterdealer' "/>
<xsl:when test="$elementValue='ISDA2009IndexSwapEuropeanInterdealer' "/>
<xsl:when test="$elementValue='ISDA2009EquityEuropeanIS' "/>
<xsl:otherwise>
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
<xsl:when test="$elementValue='KRW'"/>
<xsl:when test="$elementValue='INR'"/>
<xsl:when test="$elementValue='TWD'"/>
<xsl:when test="$elementValue='THB'"/>
<xsl:when test="$elementValue='MYR'"/>
<xsl:when test="$elementValue='PKR'"/>
<xsl:when test="$elementValue='PHP'"/>
<xsl:when test="$elementValue='VNP'"/>
<xsl:when test="$elementValue='IDR'"/>
<xsl:when test="$elementValue='BHD'"/>
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
<xsl:otherwise>
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
<xsl:template name="isValidInstrumentIdScheme">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> attribute. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
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
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> element when SWDML version = "<xsl:value-of select="$version"/>". Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:if test="$version='4-9'">
<xsl:choose>
<xsl:when test="$elementValue='Index Variance Swap'"/>
<xsl:when test="$elementValue='Share Variance Swap'"/>
<xsl:when test="$elementValue='Equity Index Volatility Swap'"/>
<xsl:when test="$elementValue='Equity Share Volatility Swap'"/>
<xsl:when test="$elementValue='Equity Accumulator'"/>
<xsl:when test="$elementValue='Equity Decumulator'"/>
<xsl:when test="$elementValue='Equity Share Option'"/>
<xsl:when test="$elementValue='Equity Index Option'"/>
<xsl:when test="$elementValue='Share Dividend Swap'"/>
<xsl:when test="$elementValue='Index Dividend Swap'"/>
<xsl:when test="$elementValue='Equity Share Swap'"/>
<xsl:when test="$elementValue='Equity Basket Swap'"/>
<xsl:when test="$elementValue='Equity Index Swap'"/>
<xsl:when test="$elementValue='Equity Share Option Strategy'"/>
<xsl:when test="$elementValue='Equity Index Option Strategy'"/>
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
<xsl:when test="$elementValue='PKR SBPK'"/>
<xsl:when test="$elementValue='Indicative Survey Rate (ISR)'"/>
<xsl:when test="$elementValue='ABSIRFIX01'"/>
<xsl:when test="$elementValue='VNDFIX=VN'"/>
<xsl:when test="$elementValue='PHPESO'"/>
<xsl:when test="$elementValue='PDSPESO'"/>
<xsl:otherwise>
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
<xsl:when test="$elementValue='KAR'"/>
<xsl:when test="$elementValue='PHP'"/>
<xsl:when test="$elementValue='VND'"/>
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
<xsl:when test="$elementValue='15:30:00'"/>
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
<xsl:template match="fpml:payment">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
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
<text>*** payerPartyReference/@href does not reference a valid //FpML/trade/party/@id. Value = '<xsl:value-of select="$href1"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not(//fpml:FpML/fpml:party[@id=$href2])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** receiverPartyReference/@href does not reference a valid //FpML/trade/party/@id. Value = '<xsl:value-of select="$href2"/>'.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:paymentAmount">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:variable name="fpml:paymentTypeDesc">
<xsl:value-of select="paymentType"/>
</xsl:variable>
<xsl:if test="not(fpml:paymentDate)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing paymentDate. Required in this context'.</text>
</error>
</xsl:if>
<xsl:variable name="tradeDate">
<xsl:value-of select="//fpml:FpML/fpml:trade/fpml:tradeHeader/fpml:tradeDate"/>
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
<xsl:if test="$payDate &lt; $trdDate">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The payment date (paymentDate/unadjustedDate) must be greater than or equal to the tradeDate.  Value = '<xsl:value-of select="$paymentDate"/>'.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:paymentDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
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
<xsl:if test="($docsType='Equity Options (Europe)' or $docsType='Equity Options (AEJ)' or $docsType='Equity Options (Americas)' or $docsType='Equity Options (EMEA)')">
<xsl:variable name="amount">
<xsl:value-of select="fpml:amount"/>
</xsl:variable>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">amount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$amount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">9999999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="$docsType='Equity Options (Japan)'">
<xsl:variable name="amount">
<xsl:value-of select="fpml:amount"/>
</xsl:variable>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">amount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$amount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">901000000000000</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="ancestor::fpml:independentAmount">
<xsl:if test="fpml:amount and //fpml:swLongFormTrade/fpml:swAllocations/fpml:swAllocation/fpml:independentAmountPercentage">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** collateral//amount must not be passed where allocated independent amount is specified in percentage.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:paymentDate">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
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
<xsl:template name="isValidSettlementPriceDefaultElectionMethod">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> element. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='Close'"/>
<xsl:when test="$elementValue='Hedge Execution'"/>
<xsl:otherwise>
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
<xsl:template match="fpml:swBusinessConductDetails">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:apply-templates select="fpml:swMidMarketPrice">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:swMidMarketPrice">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
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
<text>*** Invalid value submitted for <xsl:value-of select="local-name()"/>/swAmount. Value = '<xsl:value-of select="fpml:swAmount/text()"/>'.</text>
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
<xsl:when test="//fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:equityExercise/fpml:equityEuropeanExercise/fpml:expirationDate/@id = 'expirationDate'"/>
<xsl:when test="//fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:equityExercise/fpml:equityAmericanExercise/fpml:expirationDate/@id = 'expirationDate'"/>
<xsl:when test="//fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:equityExercise/fpml:equityBermudaExercise/fpml:expirationDate/@id = 'expirationDate'"/>
<xsl:when test="//fpml:swShortFormTrade/fpml:swEquityOptionParameters/fpml:swEquityAmericanExercise/fpml:swExpirationDate/@id = 'expirationDate'"/>
<xsl:when test="//fpml:swShortFormTrade/fpml:swEquityOptionParameters/fpml:swEquityEuropeanExercise/fpml:swExpirationDate/@id = 'expirationDate'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<xsl:if test="/fpml:SWDML/fpml:swLongFormTrade">
<text>*** Expected equityExercise/../expirationDate/@id to be expirationDate in this context.</text>
</xsl:if>
<xsl:if test="/fpml:SWDML/fpml:swShortFormTrade">
<text>*** Expected swEquityOptionParameters/../swExpirationDate/@id to be expirationDate in this context.</text>
</xsl:if>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:template>
</xsl:stylesheet>
