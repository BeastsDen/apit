<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:variable name="CFTCIssuerIdScheme">http://www.fpml.org/coding-scheme/external/cftc/issuer-identifier</xsl:variable>
<xsl:variable name="DTCCIssuerIdScheme">http://www.fpml.org/coding-scheme/external/dtcc/issuer-identifier</xsl:variable>
<xsl:variable name="GlobalUTIIssuerIdScheme">http://www.fpml.org/coding-scheme/external/issuer-identifier</xsl:variable>
<xsl:template name="isValidBusinessCenter">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="assetClass"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/>. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='AEAD'"/>
<xsl:when test="$elementValue='AEDU'"/>
<xsl:when test="$elementValue='ARBA'"/>
<xsl:when test="$elementValue='ATVI'"/>
<xsl:when test="$elementValue='AUAD'"/>
<xsl:when test="$elementValue='AUBR'"/>
<xsl:when test="$elementValue='AUCA'"/>
<xsl:when test="$elementValue='AUDA'"/>
<xsl:when test="$elementValue='AUME'"/>
<xsl:when test="$elementValue='AUPE'"/>
<xsl:when test="$elementValue='AUSY'"/>
<xsl:when test="$elementValue='BEBR'"/>
<xsl:when test="$elementValue='BHMA'"/>
<xsl:when test="$elementValue='BRBD'"/>
<xsl:when test="$elementValue='BRBR'"/>
<xsl:when test="$elementValue='BRRJ'"/>
<xsl:when test="$elementValue='BRSP'"/>
<xsl:when test="$elementValue='CAMO'"/>
<xsl:when test="$elementValue='CATO'"/>
<xsl:when test="$elementValue='CHGE'"/>
<xsl:when test="$elementValue='CHZU'"/>
<xsl:when test="$elementValue='CLSA'"/>
<xsl:when test="$elementValue='CNBE'"/>
<xsl:when test="$elementValue='COBO'"/>
<xsl:when test="$elementValue='CZPR'"/>
<xsl:when test="$elementValue='DEDU'"/>
<xsl:when test="$elementValue='DEFR'"/>
<xsl:when test="$elementValue='DEMU'"/>
<xsl:when test="$elementValue='DEST'"/>
<xsl:when test="$elementValue='DKCO'"/>
<xsl:when test="$elementValue='EETA'"/>
<xsl:when test="$elementValue='EGCA'">
<xsl:if test="$assetClass='Credit'">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:if>
</xsl:when>
<xsl:when test="$elementValue='ESAS'">
<xsl:if test="$assetClass='Credit'">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:if>
</xsl:when>
<xsl:when test="$elementValue='ESBA'"/>
<xsl:when test="$elementValue='ESMA'"/>
<xsl:when test="$elementValue='EUTA'"/>
<xsl:when test="$elementValue='FIHE'"/>
<xsl:when test="$elementValue='FRPA'"/>
<xsl:when test="$elementValue='GBLO'"/>
<xsl:when test="$elementValue='GRAT'"/>
<xsl:when test="$elementValue='HKHK'"/>
<xsl:when test="$elementValue='HNTE'"/>
<xsl:when test="$elementValue='HUBU'"/>
<xsl:when test="$elementValue='IDJA'"/>
<xsl:when test="$elementValue='IEDU'"/>
<xsl:when test="$elementValue='ILTA'"/>
<xsl:when test="$elementValue='INMU'"/>
<xsl:when test="$elementValue='ISRE'"/>
<xsl:when test="$elementValue='ITMI'"/>
<xsl:when test="$elementValue='ITRO'"/>
<xsl:when test="$elementValue='JPTO'"/>
<xsl:when test="$elementValue='KRSE'"/>
<xsl:when test="$elementValue='KWKC'">
<xsl:if test="$assetClass='Credit'">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:if>
</xsl:when>
<xsl:when test="$elementValue='LBBE'"/>
<xsl:when test="$elementValue='LULU'"/>
<xsl:when test="$elementValue='MTVA'"/>
<xsl:when test="$elementValue='MXMC'"/>
<xsl:when test="$elementValue='MYKL'"/>
<xsl:when test="$elementValue='NLAM'"/>
<xsl:when test="$elementValue='NOOS'"/>
<xsl:when test="$elementValue='NYFD'">
<xsl:if test="$assetClass='Credit'">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:if>
</xsl:when>
<xsl:when test="$elementValue='NYSE'">
<xsl:if test="$assetClass='Credit'">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:if>
</xsl:when>
<xsl:when test="$elementValue='NZAU'"/>
<xsl:when test="$elementValue='NZWE'"/>
<xsl:when test="$elementValue='OMMU'"/>
<xsl:when test="$elementValue='PAPC'"/>
<xsl:when test="$elementValue='PHMA'"/>
<xsl:when test="$elementValue='PKKA'">
<xsl:if test="$assetClass='Credit'">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:if>
</xsl:when>
<xsl:when test="$elementValue='PLWA'"/>
<xsl:when test="$elementValue='PTLI'"/>
<xsl:when test="$elementValue='QADO'">
<xsl:if test="$assetClass='Credit'">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:if>
</xsl:when>
<xsl:when test="$elementValue='RUMO'"/>
<xsl:when test="$elementValue='SARI'"/>
<xsl:when test="$elementValue='SEST'"/>
<xsl:when test="$elementValue='SGSI'"/>
<xsl:when test="$elementValue='SKBR'"/>
<xsl:when test="$elementValue='THBA'"/>
<xsl:when test="$elementValue='TRAN'"/>
<xsl:when test="$elementValue='TRIS'"/>
<xsl:when test="$elementValue='TWTA'"/>
<xsl:when test="$elementValue='USCH'"/>
<xsl:when test="$elementValue='USGS'"/>
<xsl:when test="$elementValue='USLA'"/>
<xsl:when test="$elementValue='USNY'"/>
<xsl:when test="$elementValue='VECA'">
<xsl:if test="$assetClass='Credit' or $assetClass='Rates'">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:if>
</xsl:when>
<xsl:when test="$elementValue='VNHA'"/>
<xsl:when test="$elementValue='VZCA'">
<xsl:if test="$assetClass='Rates' or $assetClass='Equities'">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:if>
</xsl:when>
<xsl:when test="$elementValue='ZAJO'"/>
<xsl:otherwise>
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
<xsl:template name="isValidUSI">
<xsl:param name="USI"/>
<xsl:param name="USINamespace"/>
<xsl:param name="issuerIdScheme"/>
<xsl:param name="context"/>
<xsl:variable name="errorText"/>
<xsl:choose>
<xsl:when test="$issuerIdScheme=$DTCCIssuerIdScheme" >
<xsl:if test="string-length($USI)&gt;40">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** Invalid UTI Value Provided.  UTI must be 40 characters or less. Value = '<xsl:value-of select="$USI"/>'.</text>
</error>
</xsl:if>
</xsl:when>
<xsl:when test="$issuerIdScheme=$CFTCIssuerIdScheme or $issuerIdScheme=$GlobalUTIIssuerIdScheme or $issuerIdScheme=''">
<xsl:if test="string-length($USI)&gt;32">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** Invalid USI Value Provided.  USI must be 32 characters or less.  Value = '<xsl:value-of select="$USI"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not($USINamespace='')">
<xsl:if test="not((string-length($USINamespace)=10) or (string-length($USINamespace)=20))">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** Invalid USI Namespace Provided.  USI Namespace must be 10 or 20 characters only.  Value = '<xsl:value-of select="$USINamespace"/>'.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:when>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** Invalid value submitted for <xsl:value-of select="local-name()"/>/@issuerIdScheme. Value = '<xsl:value-of select="$issuerIdScheme"/>'</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template name="reportingAssertion">
<xsl:param name="context"/>
<xsl:param name="reportingData"/>
<xsl:variable name="tradeEventReporting" select="$reportingData/swTradeEventReportingDetails"/>
<xsl:variable name="novatedReporting" select="$tradeEventReporting/swNovatedTradeReportingDetails"/>
<xsl:variable name="newNovatedReporting" select="$tradeEventReporting/swNewNovatedTradeReportingDetails"/>
<xsl:variable name="novationFeeReporting" select="$tradeEventReporting/swNovationFeeTradeReportingDetails"/>
<xsl:if test="count($tradeEventReporting/swReportingRegimeInformation[swJurisdiction=$dfJurisdiction])&gt;1">
<error>
<context>
<text>*** <xsl:value-of select="$context"/>/swReportingRegimeInformation. Repeating [<xsl:value-of select="$dfJurisdiction"/>] reporting regime nodes in SWDML</text>
</context>
</error>
</xsl:if>
<xsl:if test="count($tradeEventReporting/swReportingRegimeInformation[swJurisdiction=$jfsaJurisdiction])&gt;1">
<error>
<context>
<text>*** <xsl:value-of select="$context"/>/swReportingRegimeInformation. Repeating [<xsl:value-of select="$jfsaJurisdiction"/>] reporting regime nodes in SWDML</text>
</context>
</error>
</xsl:if>
<xsl:if test="count($tradeEventReporting/swReportingRegimeInformation[swJurisdiction=$esmaJurisdiction])&gt;1">
<error>
<context>
<text>*** <xsl:value-of select="$context"/>/swReportingRegimeInformation. Repeating [<xsl:value-of select="$esmaJurisdiction"/>] reporting regime nodes in SWDML</text>
</context>
</error>
</xsl:if>
<xsl:if test="count($tradeEventReporting/swReportingRegimeInformation[swJurisdiction=$hkmaJurisdiction])&gt;1">
<error>
<context>
<text>*** <xsl:value-of select="$context"/>/swReportingRegimeInformation. Repeating [<xsl:value-of select="$hkmaJurisdiction"/>] reporting regime nodes in SWDML</text>
</context>
</error>
</xsl:if>
<xsl:if test="count($novatedReporting/swReportingRegimeInformation[swJurisdiction=$dfJurisdiction])&gt;1">
<error>
<context>
<text>*** <xsl:value-of select="$context"/>/swNovatedTradeReportingDetails/swReportingRegimeInformation. Repeating [<xsl:value-of select="$dfJurisdiction"/>] reporting regime nodes in SWDML</text>
</context>
</error>
</xsl:if>
<xsl:if test="count($novatedReporting/swReportingRegimeInformation[swJurisdiction=$jfsaJurisdiction])&gt;1">
<error>
<context>
<text>*** <xsl:value-of select="$context"/>/swNovatedTradeReportingDetails/swReportingRegimeInformation. Repeating [<xsl:value-of select="$jfsaJurisdiction"/>] reporting regime nodes in SWDML</text>
</context>
</error>
</xsl:if>
<xsl:if test="count($newNovatedReporting/swReportingRegimeInformation[swJurisdiction=$dfJurisdiction])&gt;1">
<error>
<context>
<text>*** <xsl:value-of select="$context"/>/swNewNovatedTradeReportingDetails/swReportingRegimeInformation. Repeating [<xsl:value-of select="$dfJurisdiction"/>] reporting regime nodes in SWDML</text>
</context>
</error>
</xsl:if>
<xsl:if test="count($newNovatedReporting/swReportingRegimeInformation[swJurisdiction=$jfsaJurisdiction])&gt;1">
<error>
<context>
<text>*** <xsl:value-of select="$context"/>/swNewNovatedTradeReportingDetails/swReportingRegimeInformation. Repeating [<xsl:value-of select="$jfsaJurisdiction"/>] reporting regime nodes in SWDML</text>
</context>
</error>
</xsl:if>
<xsl:if test="count($novationFeeReporting/swReportingRegimeInformation[swJurisdiction=$dfJurisdiction])&gt;1">
<error>
<context>
<text>*** <xsl:value-of select="$context"/>/swNovationFeeTradeReportingDetails/swReportingRegimeInformation. Repeating [<xsl:value-of select="$dfJurisdiction"/>] reporting regime nodes in SWDML</text>
</context>
</error>
</xsl:if>
<xsl:if test="count($novationFeeReporting/swReportingRegimeInformation[swJurisdiction=$jfsaJurisdiction])&gt;0">
<error>
<context>
<text>*** <xsl:value-of select="$context"/>/swNovationFeeTradeReportingDetails/swReportingRegimeInformation. Novation Fee for [<xsl:value-of select="$jfsaJurisdiction"/>] reporting regime not supported</text>
</context>
</error>
</xsl:if>
<xsl:if test="count($novationFeeReporting/swReportingRegimeInformation[swJurisdiction=$esmaJurisdiction])&gt;0">
<error>
<context>
<text>*** <xsl:value-of select="$context"/>/swNovationFeeTradeReportingDetails/swReportingRegimeInformation. Novation Fee for [<xsl:value-of select="$esmaJurisdiction"/>] reporting regime not supported</text>
</context>
</error>
</xsl:if>
<xsl:if test="count($novationFeeReporting/swReportingRegimeInformation[swJurisdiction=$hkmaJurisdiction])&gt;0">
<error>
<context>
<text>*** <xsl:value-of select="$context"/>/swNovationFeeTradeReportingDetails/swReportingRegimeInformation. Novation Fee for [<xsl:value-of select="$hkmaJurisdiction"/>] reporting regime not supported</text>
</context>
</error>
</xsl:if>
</xsl:template>
<xsl:template name="throwError">
<xsl:param name="xpathAsserted"/>
<xsl:param name="jurisdiction"/>
<xsl:param name="errorDescription"/>
<error>
<context>
<text>*** [<xsl:value-of select="$xpathAsserted"/>] <xsl:value-of select="$jurisdiction"/> <xsl:value-of select="$errorDescription"/></text>
</context>
</error>
</xsl:template>
</xsl:stylesheet>
