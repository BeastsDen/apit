<xsl:stylesheet
version="1.0"
xmlns="http://www.markitserv.com/swml-5-11"
xmlns:fpml="http://www.fpml.org/FpML-5/confirmation"
xmlns:swml="http://www.markitserv.com/swml-5-11"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" encoding="iso-8859-1"/>
<xsl:variable name="productType">
<xsl:value-of select="//swml:SWML/swml:swStructuredTradeDetails/swml:swProductType"/>
</xsl:variable>
<xsl:variable name="triparty">
<xsl:choose>
<xsl:when test="//fpml:repo/fpml:triParty">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:template match="@*|node()">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>
<xsl:template match="swml:SWML">
<xsl:variable name="originator-href">
<xsl:value-of select="swml:swHeader/swml:swOriginatorPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="swdml-version">5-11</xsl:variable>
<SWDML xmlns:fpml="http://www.fpml.org/FpML-5/confirmation" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="{$swdml-version}" xsi:schemaLocation="http://www.markitserv.com/swml-5-11 swdml-repo-main-5-11.xsd">
<swLongFormTrade>
<swOriginatorPartyReference href="{$originator-href}"/>
<xsl:if test="swml:swHeader/swml:swReplacementTradeId">
<swReplacementTradeId>
<xsl:copy-of select="swml:swHeader/swml:swReplacementTradeId/swml:swTradeId"/>
<xsl:copy-of select="swml:swHeader/swml:swReplacementTradeId/swml:swTradeIdType"/>
<xsl:copy-of select="swml:swHeader/swml:swReplacementTradeId/swml:swReplacementReason"/>
</swReplacementTradeId>
</xsl:if>
<xsl:apply-templates select="swml:swAllocations"/>
<xsl:apply-templates select="swml:swStructuredTradeDetails"/>
</swLongFormTrade>
<xsl:apply-templates select="swml:swStructuredTradeDetails/swml:swTradeEventReportingDetails"/>
</SWDML>
</xsl:template>
<xsl:template match="fpml:party[@id = 'branch1']"/>
<xsl:template match="swml:swStructuredTradeDetails">
<swStructuredTradeDetails>
<xsl:copy-of select="swml:swProductType"/>
<xsl:copy-of select="swml:swTemplateName"/>
<xsl:apply-templates select="fpml:dataDocument"/>
<xsl:apply-templates select="swml:swExtendedTradeDetails"/>
</swStructuredTradeDetails>
</xsl:template>
<xsl:template match="swml:swOffsettingTradeId"/>
<xsl:template match="swml:swCompressionType"/>
<xsl:template match="swml:swExecutionMethod"/>
<xsl:template match="swml:swExtendedTradeDetails">
<swExtendedTradeDetails>
<swTradeHeader>
<xsl:copy-of select="swml:swTradeHeader/swml:swManualConfirmationRequired"/>
<xsl:copy-of select="swml:swTradeHeader/swml:swPartyTradeInformation"/>
<xsl:copy-of select="swml:swTradeHeader/swml:swBackLoadingFlag"/>
<xsl:copy-of select="swml:swTradeHeader/swml:swOriginatingEvent"/>
</swTradeHeader>
<xsl:copy-of select="swml:swAmendmentType"/>
</swExtendedTradeDetails>
</xsl:template>
<xsl:template match="swml:swAllocations">
<swAllocations>
<xsl:apply-templates select="swml:swAllocation"/>
</swAllocations>
</xsl:template>
<xsl:template match="swml:swAllocation">
<swAllocation>
<xsl:apply-templates select="swml:swNearLeg"/>
<xsl:copy-of select="swml:swPrivateTradeId"/>
<xsl:copy-of select="swml:swSalesCredit"/>
<xsl:copy-of select="swml:swAllocationReportingDetails"/>
<xsl:copy-of select="swml:swPartyTradeInformation"/>
</swAllocation>
</xsl:template>
<xsl:template match="swml:swNearLeg">
<swNearLeg>
<xsl:copy-of select="fpml:buyerPartyReference"/>
<xsl:copy-of select="fpml:sellerPartyReference"/>
<xsl:copy-of select="swml:collateral"/>
</swNearLeg>
</xsl:template>
<xsl:template match="swml:swTradeEventReportingDetails">
<swTradeEventReportingDetails>
<xsl:apply-templates/>
</swTradeEventReportingDetails>
</xsl:template>
<xsl:template match="fpml:nearLeg/fpml:collateral">
<xsl:if test="$triparty = 'false'">
<xsl:copy-of select="//fpml:repo/fpml:nearLeg/fpml:collateral"/>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:nearLeg/fpml:deliveryMethod">
<xsl:if test="$triparty = 'false'">
<xsl:copy-of select="//fpml:repo/fpml:nearLeg/fpml:deliveryMethod"/>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:farLeg/fpml:collateral">
<xsl:if test="$triparty = 'false'">
<xsl:copy-of select="//fpml:repo/fpml:farLeg/fpml:collateral"/>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:farLeg/fpml:deliveryMethod">
<xsl:if test="$triparty = 'false'">
<xsl:copy-of select="//fpml:repo/fpml:farLeg/fpml:deliveryMethod"/>
</xsl:if>
</xsl:template>
</xsl:stylesheet>
