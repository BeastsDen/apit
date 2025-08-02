<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fpml="http://www.fpml.org/2009/FpML-4-6" exclude-result-prefixes="fpml common" version="1.0" xmlns:common="http://exslt.org/common">
<xsl:import href="CrossAssetValidation.xsl"/>
<xsl:import href="swbml-validation-reporting.xsl"/>
<xsl:variable name="version"><xsl:value-of select="/fpml:SWBML/@version"/></xsl:variable>
<xsl:variable name="productType"><xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:swbProductType"/></xsl:variable>
<xsl:variable name="commodityReferencePrice">
<xsl:choose>
<xsl:when test="$productType='Commodity Swap'">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:commoditySwap/fpml:floatingLeg/fpml:commodity/fpml:instrumentId"/>
</xsl:when>
<xsl:when test="$productType='Commodity Option'">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:commodityOption/fpml:commodity/fpml:instrumentId"/>
</xsl:when>
<xsl:when test="$productType='Commodity Spread'">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:commoditySwap/fpml:floatingLeg[@id='floatingLeg1']/fpml:commodity/fpml:instrumentId"/>
</xsl:when>
</xsl:choose>
</xsl:variable>
<xsl:variable name="commodityCategory">
<xsl:choose>
<xsl:when test="$productType='Commodity Forward'">
<xsl:choose>
<xsl:when test="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:commodityForward/fpml:bullionPhysicalLeg">
<xsl:value-of select="'Precious'"/>
</xsl:when>
<xsl:when test="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:commoditySwap/fpml:gasPhysicalLeg">
<xsl:value-of select="'Gas'"/>
</xsl:when>
<xsl:when test="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:commoditySwap/fpml:electricityPhysicalLeg">
<xsl:value-of select="'Electricity'"/>
</xsl:when>
</xsl:choose>
</xsl:when>
<xsl:otherwise>
<xsl:value-of  select="document('swbml-validation-com-lookups-4-6.xml')/commodityCategories/commodityCategory/CRPStartsWith[starts-with($commodityReferencePrice,.)]/../@name"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="commodityReferencePrice2">
<xsl:if test="$productType='Commodity Spread'">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:commoditySwap/fpml:floatingLeg[@id='floatingLeg2']/fpml:commodity/fpml:instrumentId"/>
</xsl:if>
</xsl:variable>
<xsl:variable name="commodityCategory2">
<xsl:value-of  select="document('swbml-validation-com-lookups-4-6.xml')/commodityCategories/commodityCategory/CRPStartsWith[starts-with($commodityReferencePrice2,.)]/../@name"/>
</xsl:variable>
<xsl:variable name="FpMLVersion"><xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/@version"/></xsl:variable>
<xsl:variable name="isAllocatedTrade">
<xsl:choose>
<xsl:when test="/fpml:SWBML//fpml:swbAllocations">1</xsl:when>
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
<xsl:variable name="newContext">In <xsl:value-of select="local-name()"/></xsl:variable>
<results version="1.0">
<xsl:if test="not($version='4-6')">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Invalid version attribute. Value = '<xsl:value-of select="$version"/>'.</text></error>
</xsl:if>
<xsl:apply-templates select="fpml:swbHeader">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="swbStructuredTradeDetails">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
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
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected number of swbRecipient child elements encountered. Exactly 2 expected (<xsl:value-of select="count(fpml:swbRecipient)"/> found).</text></error>
</xsl:if>
<xsl:variable name="href1"><xsl:value-of select="fpml:swbRecipient[1]/fpml:partyReference/@href"/></xsl:variable>
<xsl:variable name="href2"><xsl:value-of select="fpml:swbRecipient[2]/fpml:partyReference/@href"/></xsl:variable>
<xsl:if test="$href1=$href2">
<error><context><xsl:value-of select="$newContext"/></context><text>*** swbRecipient[1]/partyReference/@href and swbRecipient[2]/partyReference/@href values are the same.</text></error>
</xsl:if>
<xsl:variable name="swbBrokerTradeId"><xsl:value-of select="fpml:swbBrokerTradeId"/></xsl:variable>
<xsl:if test="$swbBrokerTradeId=''">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Empty swbBrokerTradeId element.</text></error>
</xsl:if>
<xsl:if test="string-length($swbBrokerTradeId) &gt; 50">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Invalid swbBrokerTradeId element value length. Exceeded max length of 50 characters.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swbBrokerLegId">
<xsl:variable name="swbBrokerLegId"><xsl:value-of select="fpml:swbBrokerLegId"/></xsl:variable>
<xsl:if test="$swbBrokerLegId=''">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Empty swbBrokerLegId element.</text></error>
</xsl:if>
<xsl:if test="string-length($swbBrokerLegId) &gt; 20">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Invalid swbBrokerLegId element value length. Exceeded max length of 20 characters.</text></error>
</xsl:if>
</xsl:if>
<xsl:variable name="swbBrokerTradeVersionId"><xsl:value-of select="fpml:swbBrokerTradeVersionId"/></xsl:variable>
<xsl:if test="$swbBrokerTradeVersionId=''">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Empty swbBrokerTradeVersionId element.</text></error>
</xsl:if>
<xsl:variable name="swbTradeSource"><xsl:value-of select="fpml:swbTradeSource"/></xsl:variable>
<xsl:if test="$swbTradeSource=''">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Empty swbTradeSource element.</text></error>
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
<xsl:variable name="id"><xsl:value-of select="./@id"/></xsl:variable>
<xsl:choose>
<xsl:when test="$id != ''"/>
<xsl:otherwise>
<error><context><xsl:value-of select="$newContext"/></context><text>*** Empty swbRecipient/@id attribute.</text></error>
</xsl:otherwise>
</xsl:choose>
<xsl:if test="contains($id,' ')">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Invalid swbRecipient/@id value. Space characters are not allowed. Value = '<xsl:value-of select="$id"/>'.</text></error>
</xsl:if>
<xsl:if test="string-length($id) &gt; 40">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Invalid swbRecipient/@id attribute value length. Exceeded max length of 40 characters.</text></error>
</xsl:if>
<xsl:if test="$productType = 'Commodity Option'">
<xsl:choose>
<xsl:when test="fpml:partyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:commodityOption/fpml:buyerPartyReference/@href"/>
<xsl:when test="fpml:partyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:commodityOption/fpml:sellerPartyReference/@href"/>
<xsl:otherwise>
<error><context><xsl:value-of select="$newContext"/></context><text>*** Invalid partyReference/@href attribute value. Value = '<xsl:value-of select="fpml:partyReference/@href"/>'.</text></error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:variable name="href"><xsl:value-of select="fpml:partyReference/@href"/></xsl:variable>
<xsl:choose>
<xsl:when test="$href='partyA'"/>
<xsl:when test="$href='partyB'"/>
<xsl:otherwise>
<error><context><xsl:value-of select="$newContext"/></context><text>*** Missing or invalid partyReference/@href value. Value = '<xsl:value-of select="$href"/>'.</text></error>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template match="fpml:swbStructuredTradeDetails">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:call-template name="isValidProductType">
<xsl:with-param name="elementName">swbProductType</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:swbProductType"/></xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
<xsl:apply-templates select="fpml:FpML">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:swbExtendedTradeDetails">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:FpML">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="not($FpMLVersion='4-6')">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Invalid version attribute. Value = '<xsl:value-of select="$FpMLVersion"/>'.</text></error>
</xsl:if>
<xsl:if test="@expectedBuild">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected expectedBuild attribute in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:validation">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected validation element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="not(fpml:trade)">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Missing trade element.</text></error>
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
<xsl:if test="fpml:portfolio">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected portfolio element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:event">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected event element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="not(count(fpml:party)=3 or count(fpml:party)=4)">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected number of party child elements encountered. 3 or 4 expected (<xsl:value-of select="count(fpml:party)"/> found).</text></error>
</xsl:if>
<xsl:apply-templates select="fpml:trade">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:party">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
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
<xsl:if test="fpml:otherPartyPayment[2]"><xsl:variable name="href1"><xsl:value-of select="fpml:otherPartyPayment[1]/fpml:payerPartyReference/@href"/></xsl:variable>
<xsl:variable name="href2"><xsl:value-of select="fpml:otherPartyPayment[2]/fpml:payerPartyReference/@href"/></xsl:variable>
<xsl:if test="$href1=$href2">
<error><context><xsl:value-of select="$newContext"/></context><text>*** otherPartyPayment[1]/payerPartyReference/@href and otherPartyPayment[2]/payerPartyReference/@href must not be the same.</text></error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:tradeHeader">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="$productType='Commodity Forward'">
<xsl:if test="not(fpml:commodityForward or fpml:commoditySwap/fpml:gasPhysicalLeg or fpml:commoditySwap/fpml:electricityPhysicalLeg)">
<error><context><xsl:value-of select="$newContext"/></context><text>*** The commodityForward, commoditySwap/gasPhysicalLeg or commoditySwap/electricityPhysicalLeg element must be present if product type is 'Commodity Forward'.</text></error>
</xsl:if>
</xsl:if>
<xsl:if test="$productType='Commodity Option'">
<xsl:if test="not(fpml:commodityOption)">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Missing commodityOption element. Element must be present if product type is 'Commodity Option'.</text></error>
</xsl:if>
</xsl:if>
<xsl:if test="$productType='Commodity Swap' or $productType=' Commodity Spread'">
<xsl:if test="not(fpml:commoditySwap)">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Missing commoditySwap element. Element must be present if product type is 'Commodity Swap' or 'Commodity Spread'.</text></error>
</xsl:if>
</xsl:if>
<xsl:choose>
<xsl:when test="$productType !='Commodity Forward'">
<xsl:if test="$commodityCategory=''">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Commodity Reference Price does not map to a MarkitWire commodity category.</text></error>
</xsl:if>
</xsl:when>
</xsl:choose>
<xsl:if test="$productType=' Commodity Spread' and $commodityCategory2=''">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Commodity Reference Price 2 does not map to a MarkitWire commodity category.</text></error>
</xsl:if>
<xsl:apply-templates select="fpml:commodityForward|fpml:commodityOption|fpml:commoditySwap">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:otherPartyPayment">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="not(fpml:brokerPartyReference)">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Missing brokerPartyReference element.</text></error>
</xsl:if>
<xsl:apply-templates select="fpml:brokerPartyReference">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:calculationAgent">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected calculationAgent element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:calculationAgentBusinessCenter">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected calculationAgentBusinessCenter element encountered in this context.</text></error>
</xsl:if>
<xsl:apply-templates select="fpml:collateral">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:documentation"><error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected documentation element in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:governingLaw">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected governingLaw element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:allocations">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected allocations element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:tradeSide">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected tradeSide element encountered in this context.</text></error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:brokerPartyReference">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:variable name="broker"><xsl:value-of select="@href"/></xsl:variable>
<xsl:if test="not(/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:party[@id=$broker])">
<error><context><xsl:value-of select="$newContext"/></context><text>*** The brokerPartyReference/@href value does not match an //FpML/party/@id value for any party. Value = '<xsl:value-of select="$broker"/>'.</text></error>
</xsl:if>
<xsl:if test="$productType='Commodity Option'">
<xsl:choose>
<xsl:when test="$broker=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:commodityOption/fpml:buyerPartyReference/@href">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Invalid brokerPartyReference/@href attribute value. Value = '<xsl:value-of select="$broker"/>'.</text></error>
</xsl:when>
<xsl:when test="$broker=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:commodityOption/fpml:sellerPartyReference/@href">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Invalid brokerPartyReference/@href attribute value. Value = '<xsl:value-of select="$broker"/>'.</text></error>
</xsl:when>
<xsl:otherwise/>
</xsl:choose>
</xsl:if>
<xsl:variable name="href"><xsl:value-of select="fpml:brokerPartyReference/@href"/></xsl:variable>
<xsl:choose>
<xsl:when test="$href='partyA' or $href='partyB'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Invalid brokerPartyReference/@href attribute value. Value = '<xsl:value-of select="$href"/>'.</text></error>
</xsl:when>
<xsl:otherwise/>
</xsl:choose>
</xsl:template>
<xsl:template match="fpml:collateral">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:apply-templates select="fpml:independentAmount">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:independentAmount">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="payer"><xsl:value-of select="fpml:payerPartyReference/@href"/></xsl:variable>
<xsl:choose>
<xsl:when test="$payer='partyA'"/>
<xsl:when test="$payer='partyB'"/>
<xsl:otherwise>
<error><context><xsl:value-of select="$newContext"/></context><text>*** Missing or invalid payerPartyReference/@href value. Value = '<xsl:value-of select="$payer"/>'.</text></error>
</xsl:otherwise>
</xsl:choose>
<xsl:variable name="receiver"><xsl:value-of select="fpml:receiverPartyReference/@href"/></xsl:variable>
<xsl:choose>
<xsl:when test="$receiver='partyA'"/>
<xsl:when test="$receiver='partyB'"/>
<xsl:otherwise>
<error><context><xsl:value-of select="$newContext"/></context><text>*** Missing or invalid receiverPartyReference/@href value. Value = '<xsl:value-of select="$receiver"/>'.</text></error>
</xsl:otherwise>
</xsl:choose>
<xsl:if test="$payer=$receiver">
<error><context><xsl:value-of select="$newContext"/></context><text>*** payerPartyReference/@href and receiverPartyReference/@href values are the same.</text></error>
</xsl:if>
<xsl:apply-templates select="fpml:paymentDetail">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:paymentDetail">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="fpml:adjustablePaymentDate">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected adjustablePaymentDate element in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:adjustedPaymentDate">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected adjustedPaymentDate element in this context.</text></error>
</xsl:if>
<xsl:apply-templates select="fpml:paymentAmount">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:paymentRule">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected paymentRule element in this context.</text></error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:swbExtendedTradeDetails">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="not(fpml:swbCommoditySwapDetails) and $productType='Commodity Swap'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Missing swbCommoditySwapDetails element in this context. Element must be present if product type is 'Commodity Swap'.</text></error>
</xsl:if>
<xsl:if test="fpml:swbCommoditySwapDetails and $productType='Commodity Spread'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected swbCommoditySwapDetails element encountered in this context. Element must not be present if product type is 'Commodity Spread'.</text></error>
</xsl:if>
<xsl:if test="fpml:swbCommoditySwapDetails and $productType='Commodity Forward'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected swbCommoditySwapDetails element encountered in this context. Element must not be present if product type is 'Commodity Forward'.</text></error>
</xsl:if>
<xsl:if test="fpml:swbCommoditySwapDetails and $productType='Commodity Option'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected swbCommoditySwapDetails element encountered in this context. Element must not be present if product type is 'Commodity Option'.</text></error>
</xsl:if>
<xsl:if test="fpml:swbCommoditySpreadDetails">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected swbCommoditySpreadDetails element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="not(fpml:swbCommodityForwardDetails/fpml:swbElectricityLoadShape) and $productType='Commodity Forward' and $commodityCategory = 'Electricity'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Missing swbCommodityForwardDetails/fpml:swbElectricityLoadShape element in this context. Element must be present for power if product type is 'Commodity Forward'.</text></error>
</xsl:if>
<xsl:apply-templates select="fpml:swbCommoditySwapDetails">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:swbCommodityOptionDetails">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:swbProductTerm">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected swbProductTerm element in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:swbMessageText">
<xsl:if test="fpml:swbMessageText=''">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Empty swbMessageText element.</text></error>
</xsl:if>
</xsl:if>
<xsl:variable name="messageText"><xsl:value-of select="fpml:swbMessageText"/></xsl:variable>
<xsl:if test="string-length($messageText) &gt; 200">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Invalid swbMessageText string length. Exceeded max length of 200 characters.</text></error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:swbCommoditySwapDetails">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">swbBulletIndicator</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:swbBulletIndicator"/></xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
<xsl:if test="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbCommoditySwapDetails/fpml:swbBulletIndicator = 'true' and not(/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbCommoditySwapDetails/fpml:swbFirstContractMonth) and $commodityCategory = 'Oil'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Missing swbFirstContractMonth and swbLastContractMonth in this context when swbBulletIndicator is set to 'true'.</text></error>
</xsl:if>
<xsl:if test="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbCommoditySwapDetails/fpml:swbBulletIndicator = 'true' and not(/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:commoditySwap/fpml:floatingLeg/fpml:calculationPeriodsSchedule/fpml:period='T') and not($commodityCategory = 'Oil')">
<error><context><xsl:value-of select="$newContext"/></context><text>*** calculationPeriodsSchedule/period must be set to 'T' when swbBulletIndicator is set to 'true'.</text></error>
</xsl:if>
<xsl:if test="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbCommoditySwapDetails/fpml:swbBulletIndicator = 'false' and /fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:commoditySwap/fpml:floatingLeg/fpml:calculationPeriodsSchedule/fpml:period='T' and not($commodityCategory = 'Oil')">
<error><context><xsl:value-of select="$newContext"/></context><text>*** calculationPeriodsSchedule/period must not be set to 'T' when swbBulletIndicator is set to 'false'.</text></error>
</xsl:if>
<xsl:if test="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbCommoditySwapDetails/fpml:swbFirstContractMonth and ($commodityCategory = 'Freight')">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected swbFirstContractMonth and swbLastContractMonth in this context.</text></error>
</xsl:if>
<xsl:if test="(/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbCommoditySwapDetails/fpml:swbBulletIndicator = 'true') and ($commodityCategory = 'Freight')">
<error><context><xsl:value-of select="$newContext"/></context><text>*** swbBulletIndicator must be set to 'false' in this context.</text></error>
</xsl:if>
<xsl:if test="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbCommoditySwapDetails/fpml:swbBulletIndicator = 'true' and (not(/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbCommoditySwapDetails/fpml:swbLastContractMonth) and not(/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:commoditySwap/fpml:effectiveDate = /fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:commoditySwap/fpml:terminationDate)) and not($commodityCategory = 'Oil')">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Either swbFirstContractMonth and swbFirstContractMonth must be present in this context when swbBulletIndicator is set to 'true' or effectiveDate and terminationDate must be the same.</text></error>
</xsl:if>
<xsl:if test="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbCommoditySwapDetails/fpml:swbBulletIndicator = 'false' and /fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbCommoditySwapDetails/fpml:swbFirstContractMonth">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected swbFirstContractMonth encountered in this context when swbBulletIndicator is set to 'false'.</text></error>
</xsl:if>
<xsl:if test="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbCommoditySwapDetails/fpml:swbBulletIndicator = 'false' and /fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbCommoditySwapDetails/fpml:swbLastContractMonth">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpeted swbLastContractMonth encountered in this context when swbBulletIndicator is set to 'false'.</text></error>
</xsl:if>
<xsl:if test="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbCommoditySwapDetails/fpml:swbBulletIndicator = 'false' and /fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbCommoditySwapDetails/fpml:swbContractYear">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected swbContractYear encountered in this context when swbBulletIndicator is set to 'false'.</text></error>
</xsl:if>
<xsl:if test="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbCommoditySwapDetails/fpml:swbTotalNotionalQuantityLots and not($commodityCategory = 'Ags' or $commodityCategory = 'Base')">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected swbTotalNotionalQuantityLots encountered in this context.</text></error>
</xsl:if>
<xsl:if test="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbCommoditySwapDetails/fpml:swbElectricityLoadShape and not($commodityCategory = 'Electricity')">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected swbElectricityLoadShape encountered in this context.</text></error>
</xsl:if>
<xsl:if test="not(/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbCommoditySwapDetails/fpml:swbElectricityLoadShape) and $commodityCategory = 'Electricity'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Missing swbElectricityLoadShape elemen.</text></error>
</xsl:if>
<xsl:if test="$commodityCategory = 'Electricity' and not(fpml:swbElectricityLoadShape[@id='SWBLoadShape'])">
<error><context><xsl:value-of select="$newContext"/></context><text>*** The swbElectricityLoadShape element must have an @id attribute value of 'SWBLoadShape'. Value = '<xsl:value-of select="fpml:fixedLeg/@id"/>'.</text></error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:swbCommodityOptionDetails">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbCommodityOptionDetails/fpml:swbContractMonth and not(/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:commodityOption/fpml:exercise/fpml:paymentDates)">
<error><context><xsl:value-of select="$newContext"/></context><text>*** swbContractMonth may only be present when exercise/paymentDates is present (i.e. this is a European or American style option).</text></error>
</xsl:if>
<xsl:if test="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbCommodityOptionDetails/fpml:swbTotalNotionalQuantityLots and not($commodityCategory = 'Ags' or $commodityCategory = 'Base')">
<error><context><xsl:value-of select="$newContext"/></context><text>*** swbTotalNotionalQuantityLots may only be present when the Commodity Reference Price is for an agricultural or base metals product.</text></error>
</xsl:if>
<xsl:if test="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbCommodityOptionDetails/fpml:swbContractMonth and not($commodityCategory = 'Ags' or $commodityCategory = 'Gas' or $commodityCategory='Base' or $commodityCategory='Precious')">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected swbContractMonth, swbContractYear and swbContractTradingDay in this context.</text></error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:tradeHeader">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="count(fpml:partyTradeIdentifier) != 2">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected number of partyTradeIdentifier child elements encountered. Exactly 2 expected.</text></error>
</xsl:if>
<xsl:apply-templates select="fpml:partyTradeIdentifier">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:partyTradeInformation">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:partyTradeIdentifier">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:if test="$productType = 'Commodity Option'"><xsl:choose>
<xsl:when test="fpml:partyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:commodityOption/fpml:buyerPartyReference/@href"/>
<xsl:when test="fpml:partyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:commodityOption/fpml:sellerPartyReference/@href"/>
<xsl:otherwise>
<error><context><xsl:value-of select="$newContext"/></context><text>*** Invalid partyReference/@href attribute value. Value = '<xsl:value-of select="fpml:partyReference/@href"/>'.</text></error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:variable name="href"><xsl:value-of select="fpml:partyReference/@href"/></xsl:variable>
<xsl:choose>
<xsl:when test="$href='partyA'"/>
<xsl:when test="$href='partyB'"/>
<xsl:otherwise>
<error><context><xsl:value-of select="$newContext"/></context><text>*** Missing or invalid partyReference/@href value. Value = '<xsl:value-of select="$href"/>'.</text></error>
</xsl:otherwise>
</xsl:choose>
<xsl:variable name="tradeIdScheme"><xsl:value-of select="fpml:tradeId/@tradeIdScheme"/></xsl:variable>
<xsl:if test="$tradeIdScheme=''">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Missing or empty tradeId/@tradeIdScheme attribute.</text></error>
</xsl:if>
<xsl:variable name="tradeId"><xsl:value-of select="fpml:tradeId"/></xsl:variable>
<xsl:if test="$tradeId=''">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Empty tradeId element.</text></error>
</xsl:if>
<xsl:if test="fpml:linkId">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected linkId element encountered in this context.</text></error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:partyTradeInformation">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:if test="$productType = 'Commodity Option'">
<xsl:choose>
<xsl:when test="fpml:partyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:commodityOption/fpml:buyerPartyReference/@href"/>
<xsl:when test="fpml:partyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:commodityOption/fpml:sellerPartyReference/@href"/>
<xsl:otherwise>
<error><context><xsl:value-of select="$newContext"/></context><text>*** Invalid partyReference/@href attribute value. Value = '<xsl:value-of select="fpml:partyReference/@href"/>'.</text></error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:variable name="href"><xsl:value-of select="fpml:partyReference/@href"/></xsl:variable>
<xsl:choose>
<xsl:when test="$href='partyA'"/>
<xsl:when test="$href='partyB'"/>
<xsl:otherwise>
<error><context><xsl:value-of select="$newContext"/></context><text>*** Invalid partyReference/@href attribute value. Value = '<xsl:value-of select="$href"/>'.</text></error>
</xsl:otherwise>
</xsl:choose>
<xsl:if test="fpml:trader">
<xsl:if test="fpml:trader=''">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Empty trader element.</text></error>
</xsl:if>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:adjustableDate">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>    </xsl:variable>
<xsl:apply-templates select="fpml:dateAdjustments">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:party">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:if test="not(fpml:partyId)">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Missing partyId element.</text></error>
</xsl:if>
<xsl:if test="not(string-length(fpml:partyId) = string-length(normalize-space(fpml:partyId)))">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid partyId element. </text>
</error>
</xsl:if>
<xsl:variable name="partyName"><xsl:value-of select="fpml:partyName"/></xsl:variable>
<xsl:if test="fpml:partyName">
<xsl:if test="$partyName=''">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Empty partyName element.</text></error>
</xsl:if>
</xsl:if>
<xsl:if test="string-length($partyName) &gt; 200">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Invalid partyName string length. Exceeded max length of 200 characters.</text></error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:otherPartyPayment">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:if test="$productType='Commodity Option'">
<xsl:choose>
<xsl:when test="fpml:payerPartyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:commodityOption/fpml:buyerPartyReference/@href"/>
<xsl:when test="fpml:payerPartyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:commodityOption/fpml:sellerPartyReference/@href"/>
<xsl:otherwise>
<error><context><xsl:value-of select="$newContext"/></context><text>*** Invalid payerPartyReference/@href attribute value. Value = '<xsl:value-of select="fpml:payerPartyReference/@href"/>'.</text></error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="$productType='Commodity Option'">
<xsl:choose>
<xsl:when test="fpml:receiverPartyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:commodityOption/fpml:buyerPartyReference/@href">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Invalid receiverPartyReference/@href attribute value. Value = '<xsl:value-of select="fpml:receiverPartyReference/@href"/>'.</text></error>
</xsl:when>
<xsl:when test="fpml:receiverPartyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:commodityOption/fpml:sellerPartyReference/@href">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Invalid receiverPartyReference/@href attribute value. Value = '<xsl:value-of select="fpml:receiverPartyReference/@href"/>'.</text></error>
</xsl:when>
<xsl:otherwise/>
</xsl:choose>
</xsl:if>
<xsl:variable name="href1"><xsl:value-of select="fpml:payerPartyReference/@href"/></xsl:variable>
<xsl:choose>
<xsl:when test="$href1='partyA'"/>
<xsl:when test="$href1='partyB'"/>
<xsl:otherwise>
<error><context><xsl:value-of select="$newContext"/></context><text>*** Missing or invalid payerPartyReference/@href value. Value = '<xsl:value-of select="$href1"/>'.</text></error>
</xsl:otherwise>
</xsl:choose>
<xsl:variable name="href2"><xsl:value-of select="fpml:receiverPartyReference/@href"/></xsl:variable>
<xsl:if test="$href2='partyA' or $href2='partyB'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Missing or invalid receiverPartyReference/@href value. Value = '<xsl:value-of select="$href2"/>'.</text></error>
</xsl:if>
<xsl:if test="$href1=$href2">
<error><context><xsl:value-of select="$newContext"/></context><text>*** payerPartyReference/@href and receiverPartyReference/@href values are the same.</text></error>
</xsl:if>
<xsl:if test="not(/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:party[@id=$href2])">
<error><context><xsl:value-of select="$newContext"/></context><text>*** The receiverPartyReference/@href value does not match an //FpML/party/@id value for any party. Value = '<xsl:value-of select="$href2"/>'.</text></error>
</xsl:if>
<xsl:apply-templates select="fpml:paymentAmount">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:paymentDate">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected paymentDate element encountered in this context. Not expected for brokerage payment.</text></error>
</xsl:if>
<xsl:if test="fpml:adjustedPaymentDate">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected adjustedPaymentDate element encountered in this context. Not expected for brokerage payment.</text></error>
</xsl:if>
<xsl:if test="fpml:paymentType"><error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected paymentType element encountered in this context. Not expected for brokerage payment.</text></error></xsl:if>
<xsl:if test="fpml:settlementInformation">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected settlementInformation element encountered in this context. Not expected for brokerage payment.</text></error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:paymentAmount">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
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
</xsl:template>
<xsl:template match="fpml:commodityForward">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="fpml:productType">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected productType element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:productId">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected productId element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="not($productType='Commodity Forward')">
<error><context><xsl:value-of select="$newContext"/></context><text>*** /SWBML/swbStructuredTradeDetails/swbProductType must be equal to 'Commodity Forward'.</text></error>
</xsl:if>
<xsl:if test="$productType = 'Commodity Forward' and count(fpml:fixedLeg)!=1">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected number of fixedLeg child elements encountered. Only 1 expected when product is 'Commodity Forward'.</text></error>
</xsl:if>
<xsl:if test="$productType = 'Commodity Forward' and count(fpml:bullionPhysicalLeg)!=1">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected number of bullionPhysicalLeg child elements encountered. Only 1 expected when product is 'Commodity Forward'.</text></error></xsl:if>
<xsl:if test="$productType = 'Commodity Forward' and not(fpml:fixedLeg[@id='fixedLeg'])">
<error><context><xsl:value-of select="$newContext"/></context><text>*** The fixedLeg element must have an @id attribute value of 'fixedLeg' when product is 'Commodity Forward'. Value = '<xsl:value-of select="fpml:fixedLeg/@id"/>'.</text></error>
</xsl:if>
<xsl:if test="$productType = 'Commodity Forward' and not(fpml:bullionPhysicalLeg[@id='bullionLeg'])">
<error><context><xsl:value-of select="$newContext"/></context><text>*** The bullionPhysicalLeg element must have an @id attribute value of 'bullionLeg' when product is 'Commodity Forward'. Value = '<xsl:value-of select="fpml:bullionPhysicalLeg/@id"/>'.</text></error>
</xsl:if>
<xsl:variable name="fixedPayer"><xsl:value-of select="fpml:fixedLeg/fpml:payerPartyReference/@href"/></xsl:variable>
<xsl:variable name="bullionReceiver"><xsl:value-of select="fpml:bullionPhysicalLeg/fpml:receiverPartyReference/@href"/></xsl:variable>
<xsl:if test="$productType='Commodity Forward' and $fixedPayer != $bullionReceiver">
<error><context><xsl:value-of select="$newContext"/></context><text>*** fixedLeg payer party is not bullionPhysicalLeg receiver party.</text></error>
</xsl:if>
<xsl:variable name="fixedReceiver"><xsl:value-of select="fpml:fixedLeg/fpml:receiverPartyReference/@href"/></xsl:variable>
<xsl:variable name="bullionPayer"><xsl:value-of select="fpml:bullionPhysicalLeg/fpml:payerPartyReference/@href"/></xsl:variable>
<xsl:if test="$productType='Commodity Forward' and $fixedReceiver != $bullionPayer">
<error><context><xsl:value-of select="$newContext"/></context><text>*** fixedLeg receiver party is not bullionPhysicalLeg payer party.</text></error>
</xsl:if>
<xsl:if test="$fixedPayer=$fixedReceiver">
<error><context><xsl:value-of select="$newContext"/>/fixedLeg</context><text> *** payerPartyReference/@href and receiverPartyReference/@href values are the same.</text></error>
</xsl:if>
<xsl:if test="$bullionPayer=$bullionReceiver">
<error><context><xsl:value-of select="$newContext"/>/bullionPhysicalLeg</context><text> *** payerPartyReference/@href and receiverPartyReference/@href values are the same.</text></error>
</xsl:if>
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">valueDate</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:valueDate/fpml:adjustableDate/fpml:unadjustedDate"/></xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
<xsl:if test="fpml:valueDate/fpml:adjustableDate/fpml:dateAdjustments/fpml:businessDayConvention != 'NotApplicable'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected businessDayConvention value encountered in this context. Must be set to 'NotApplicable'.</text></error>
</xsl:if>
<xsl:apply-templates select="fpml:valueDate/fpml:adjustableDate/fpml:dateAdjustments/fpml:businessCenters">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="not(fpml:valueDate[@id='valueDate'])">
<error><context><xsl:value-of select="$newContext"/></context><text>*** The valueDate element must have an @id attribute value of 'valueDate'. Value = '<xsl:value-of select="fpml:valueDate/@id"/>'</text></error>
</xsl:if>
<xsl:if test="fpml:commonPricing">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected commonPricing element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:marketDisruption">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected marketDisruption element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:settlementDisruption">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected settlementDisruption element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:rounding">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected rounding element encountered in this context.</text></error>
</xsl:if>
<xsl:apply-templates select="fpml:fixedLeg">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:bullionPhysicalLeg">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:commodityForward/fpml:fixedLeg">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="fpml:fixedPriceSchedule">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected fixedPriceSchedule element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:worldscaleRate">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected worldscaleRate element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:contractRate">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected contractRate element encountered in this context.</text></error>
</xsl:if>
<xsl:apply-templates select="fpml:fixedPrice">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:quantityReference/@href != 'deliveryQuantity'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** quantityReference/@href must be set to 'deliveryQuantity'. Value = '<xsl:value-of select="fpml:quantityReference/@href"/>'.</text></error>
</xsl:if>
<xsl:apply-templates select="fpml:paymentDates">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:relativePaymentDates">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected realtivePaymentDates element encountered in this context.</text></error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:bullionPhysicalLeg">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="fpml:physicalQuantitySchedule">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected physicalQuantitySchedule element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:totalPhysicalQuantity">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected totalPhysicalQuantity element encountered in this context.</text></error>
</xsl:if>
<xsl:apply-templates select="fpml:physicalQuantity">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:settlementDate">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:settlementDate">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="fpml:adjustableDates">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected adjustableDates element encountered in this context.</text></error>
</xsl:if>
<xsl:apply-templates select="fpml:relativeDate">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:bullionPhysicalLeg/fpml:physicalQuantity">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="./@id != 'deliveryQuantity'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** @id must be set to 'deliveryQuantity'. Value= '<xsl:value-of select="./@id"/>'.</text></error>
</xsl:if>
<xsl:call-template name="isValidUnit">
<xsl:with-param name="elementName">quantityUnit</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:quantityUnit"/></xsl:with-param>
<xsl:with-param name="commodityCategory"><xsl:value-of select="$commodityCategory"/></xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
<xsl:if test="fpml:quantityFrequency != 'Term'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** quantityFrequency must be set to 'Term'. Value= '<xsl:value-of select="fpml:quantityFrequency"/>'.</text></error>
</xsl:if>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">quantity</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:quantity"/></xsl:with-param>
<xsl:with-param name="minIncl">0.001</xsl:with-param>
<xsl:with-param name="maxIncl">999999999999.999</xsl:with-param>
<xsl:with-param name="maxDecs">3</xsl:with-param>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
</xsl:template>
<xsl:template match="fpml:commodityOption">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:variable name="buyer"><xsl:value-of select="fpml:buyerPartyReference/@href"/></xsl:variable>
<xsl:if test="not(/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:party[@id=$buyer])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** The buyerPartyReference/@href value does not match an //FpML/party/@id value for any party. Value = '<xsl:value-of select="$buyer"/>'.</text>
</error>
</xsl:if>
<xsl:variable name="seller"><xsl:value-of select="fpml:sellerPartyReference/@href"/></xsl:variable>
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
<context><xsl:value-of select="$newContext"/></context>
<text>*** buyerPartyReference/@href and sellerPartyReference/@href values are the same.</text>
</error>
</xsl:if>
<xsl:if test="not($productType='Commodity Option')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** /SWBML/swbStructuredTradeDetails/swbProductType must be equal to 'Commodity Option'' if commodityOption element is present.</text>
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
<xsl:call-template name="isValidOptionType">
<xsl:with-param name="elementName">optionType</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:optionType"/></xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
<xsl:apply-templates select="fpml:commodity">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:effectiveDate and fpml:exercise/fpml:americanExercise">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** effectiveDate cannot be present when exercise/americanExercise is present.</text>
</error>
</xsl:if>
<xsl:if test="fpml:effectiveDate">
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">effectiveDate</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:effectiveDate/fpml:adjustableDate/fpml:unadjustedDate"/></xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:calculationPeriodsSchedule and fpml:exercise/fpml:americanExercise">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** calculationPeriodsSchedule cannot be present when exercise/americanExercise is present.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:calculationPeriodsSchedule">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:calculationPeriods">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected calculationPeriods element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:pricingDates and fpml:exercise/fpml:americanExercise">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** pricingDates cannot be present when exercise/americanExercise is present.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:pricingDates">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:averagingMethod">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected averagingMethod element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:notionalQuantity and fpml:strikePricePerUnitSchedule">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** strikePricePerUnit must be present when notionalQuantity is present.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:notionalQuantity">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:notionalQuantitySchedule">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">totalNotionalQuantity</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:totalNotionalQuantity"/></xsl:with-param>
<xsl:with-param name="minIncl">0.001</xsl:with-param>
<xsl:with-param name="maxIncl">999999999999.999</xsl:with-param>
<xsl:with-param name="maxDecs">3</xsl:with-param>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
<xsl:apply-templates select="fpml:exercise">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:strikePricePerUnit">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:strikePricePerUnitSchedule">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:premium">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:commonPricing">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected commonPricing element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:marketDisruption">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected marketDisruption element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:rounding">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected rounding element encountered in this context.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:commodity">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="$productType='Commodity Spread' and ../@id='floatingLeg1' and $commodityCategory='Ags'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Agricultural Commodity Reference Price encountered for a Commodity Spread trade. Value = '<xsl:value-of select="fpml:instrumentId"/>'.</text></error>
</xsl:if>
<xsl:if test="$productType='Commodity Spread' and ../@id='floatingLeg1' and $commodityCategory='Freight'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Freight Commodity Reference Price encountered for a Commodity Spread trade. Value = '<xsl:value-of select="fpml:instrumentId"/>'.</text></error>
</xsl:if>
<xsl:if test="$productType='Commodity Spread' and ../@id='floatingLeg1' and $commodityCategory='Base'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Base Metals Commodity Reference Price encountered for a Commodity Spread trade. Value = '<xsl:value-of select="fpml:instrumentId"/>'.</text></error>
</xsl:if>
<xsl:if test="$productType='Commodity Spread' and ../@id='floatingLeg1' and $commodityCategory='Precious'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Precious Metals Commodity Reference Price encountered for a Commodity Spread trade. Value = '<xsl:value-of select="fpml:instrumentId"/>'.</text></error>
</xsl:if>
<xsl:if test="$productType='Commodity Spread' and ../@id='floatingLeg2' and $commodityCategory2='Ags'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Agricultural Commodity Reference Price encountered for a Commodity Spread trade. Value = '<xsl:value-of select="fpml:instrumentId"/>'.</text></error>
</xsl:if>
<xsl:if test="$productType='Commodity Spread' and ../@id='floatingLeg2' and $commodityCategory2='Freight'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Freight Commodity Reference Price encountered for a Commodity Spread trade. Value = '<xsl:value-of select="fpml:instrumentId"/>'.</text></error>
</xsl:if>
<xsl:if test="$productType='Commodity Spread' and ../@id='floatingLeg2' and $commodityCategory2='Base'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Base Metals Commodity Reference Price encountered for a Commodity Spread trade. Value = '<xsl:value-of select="fpml:instrumentId"/>'.</text></error>
</xsl:if>
<xsl:if test="$productType='Commodity Spread' and ../@id='floatingLeg2' and $commodityCategory2='Precious'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Precious Metals Commodity Reference Price encountered for a Commodity Spread trade. Value = '<xsl:value-of select="fpml:instrumentId"/>'.</text></error>
</xsl:if>
<xsl:choose>
<xsl:when test="fpml:instrumentId/@instrumentIdScheme='http://www.fpml.org/coding-scheme/commodity-reference-price'"/>
<xsl:otherwise>
<error><context><xsl:value-of select="$newContext"/></context><text>*** instrumentId has an invalid instrumentIdScheme value. Value = '<xsl:value-of select="fpml:instrumentId/@instrumentIdScheme"/>'.</text></error>
</xsl:otherwise>
</xsl:choose>
<xsl:if test="fpml:description">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected description element encountered in this context.</text></error></xsl:if>
<xsl:if test="fpml:commodityBase">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected commodityBase element encountered in this context.</text></error></xsl:if>
<xsl:if test="fpml:commodityDetails">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected commodityDetails element encountered in this context.</text></error></xsl:if>
<xsl:if test="fpml:unit"><error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected unit element encountered in this context.</text></error></xsl:if>
<xsl:if test="fpml:currency">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected currency element encountered in this context.</text></error></xsl:if>
<xsl:if test="fpml:exchangeId">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected exchangeId element encountered in this context.</text></error></xsl:if>
<xsl:if test="fpml:publication"><error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected publication element encountered in this context.</text></error></xsl:if>
<xsl:if test="fpml:multiplier and not($commodityCategory='Freight')">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected multiplier element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:multiplier and $commodityCategory='Freight' and $productType='Commodity Option'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected multiplier element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:settlementPeriod">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected settlementPeriod element encountered in this context.</text></error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:exercise">
<xsl:param name="context"/>
<xsl:variable name="newContext"> <xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:apply-templates select="fpml:americanExercise">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:europeanExercise">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:automaticExercise">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected automaticExercise element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:writtenConfirmation">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected writtenConfirmation element encountered in this context.</text>
</error>
</xsl:if>
<xsl:call-template name="isValidCurrency">
<xsl:with-param name="elementName">settlementCurrency</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:settlementCurrency"/></xsl:with-param>
<xsl:with-param name="commodityCategory"><xsl:value-of select="$commodityCategory"/></xsl:with-param>
<xsl:with-param name="productType"><xsl:value-of select="$productType"/></xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
<xsl:if test="fpml:settlementCurrency != ../fpml:premium/fpml:paymentAmount/fpml:currency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** settlementCurrency must equal premium/paymentAmount/currency.</text>
</error>
</xsl:if>
<xsl:if test="fpml:fx">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected fx element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:conversionFactor">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected conversionFactor element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:relativePaymentDates) and ../fpml:calculationPeriodsSchedule">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** relativePaymentDates must be present when ../calculationPeriodsSchedule is present.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:paymentDates) and not(../fpml:calculationPeriodsSchedule)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** paymentDates must be present when ../calculationPeriodsSchedule is not present.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:paymentDates">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:relativePaymentDates">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:americanExercise">
<xsl:param name="context"/>
<xsl:variable name="newContext"> <xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="not(@id='exerciseDate')">
<error>
<context><xsl:value-of select="$newContext"/></context>
<text>*** americanExercise/@id must be set to 'exerciseDate' for a Commodity Option. Value='<xsl:value-of select="../@id"/>'.</text>
</error>
</xsl:if>
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">commencementDate</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:commencementDate/fpml:adjustableDate/fpml:unadjustedDate"/></xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
<xsl:if test="fpml:commencementDate/fpml:adjustableDate/fpml:unadjustedDate != /fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:tradeHeader/fpml:tradeDate">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** commencementDate must equal tradeDate for an American option.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:expirationDate[@id='expirationDate'])">
<error>
<context><xsl:value-of select="$newContext"/></context>
<text>*** expirationDate/@id must be set to 'expirationDate' for a Commodity Option. Value='<xsl:value-of select="fpml:expirationDate/@id"/>'.</text>
</error>
</xsl:if>
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">expirationDate</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:expirationDate/fpml:adjustableDate/fpml:unadjustedDate"/></xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
<xsl:if test="fpml:latestExerciseTime">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected latestExerciseTime element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:expirationTime">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected expirationTime element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:multipleExercise">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected multipleExercise element encountered in this context.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:europeanExercise">
<xsl:param name="context"/>
<xsl:variable name="newContext"> <xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="not(fpml:expirationDate[@id='expirationDate'])">
<error>
<context><xsl:value-of select="$newContext"/></context>
<text>*** expirationDate/@id must be set to 'expirationDate' for a Commodity Option. Value='<xsl:value-of select="fpml:expirationDate/@id"/>'.</text>
</error>
</xsl:if>
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">expirationDate</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:expirationDate/fpml:adjustableDate/fpml:unadjustedDate"/></xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
<xsl:if test="fpml:expirationTime">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected expirationTime element encountered in this context.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:commoditySwap">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="fpml:productType">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected productType element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:productId">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected productId element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:gasPhysicalLeg and ($productType='Commodity Swap' or $productType='Commodity Spread')">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected gasPhysicalLeg element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:electricityPhysicalLeg and ($productType='Commodity Swap' or $productType='Commodity Spread')">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected electricityPhysicalLeg element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:oilPhysicalLeg">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected oilPhysicalLeg element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:coalPhysicalLeg">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected coalPhysicalLeg element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="not($productType='Commodity Swap' or $productType='Commodity Spread' or $productType='Commodity Forward')">
<error><context><xsl:value-of select="$newContext"/></context><text>*** /SWBML/swbStructuredTradeDetails/swbProductType must be equal to 'Commodity Swap', 'Commodity Spread' or 'Commodity Forward' if commoditySwap element is present.</text></error>
</xsl:if>
<xsl:if test="$productType = 'Commodity Swap' and count(fpml:floatingLeg)!=1">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected number of floatingLeg child elements encountered. Only 1 expected when product is 'Commodity Swap'.</text></error>
</xsl:if>
<xsl:if test="$productType = 'Commodity Swap' and count(fpml:fixedLeg)!=1">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected number of fixedLeg child elements encountered. Only 1 expected when product is 'Commodity Swap'.</text></error></xsl:if>
<xsl:if test="$productType = 'Commodity Swap' and not(fpml:floatingLeg[@id='floatingLeg'])">
<error><context><xsl:value-of select="$newContext"/></context><text>*** The floatingLeg element must have an @id attribute value of 'floatingLeg' when product is 'Commodity Swap'.</text></error>
</xsl:if>
<xsl:if test="($productType='Commodity Swap' or $productType='Commodity Forward') and not(fpml:fixedLeg[@id='fixedLeg'])">
<error><context><xsl:value-of select="$newContext"/></context><text>*** The fixedLeg element must have an @id attribute value of 'fixedLeg' when product is 'Commodity Swap' or 'Commodity Forward'.</text></error>
</xsl:if>
<xsl:if test="$productType = 'Commodity Spread' and count(fpml:floatingLeg)!=2">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected number of floatingLeg child elements encountered. Exactly 2 expected when product is 'Commodity Spread'.</text></error>
</xsl:if>
<xsl:if test="$productType = 'Commodity Forward' and not(fpml:gasPhysicalLeg or fpml:electricityPhysicalLeg)">
<error><context><xsl:value-of select="$newContext"/></context><text>*** A gasPhysicalLeg or electricityPhysicalLeg child element must be present when product is 'Commodity Forward'.</text></error>
</xsl:if>
<xsl:if test="$productType = 'Commodity Spread' and fpml:fixedLeg">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected  fixedLeg element encountered in this context when product is 'Commodity Spread'.</text></error>
</xsl:if>
<xsl:if test="$productType='Commodity Spread' and not(fpml:floatingLeg[@id='floatingLeg1'])">
<error><context><xsl:value-of select="$newContext"/></context><text>*** One floatingLeg must have a floatingLeg/@id attribute value of 'floatingLeg1' when product type is 'Commodity Spread'.</text></error>
</xsl:if>
<xsl:if test="($productType='Commodity Spread' and not(fpml:floatingLeg/@id='floatingLeg2'))">
<error><context><xsl:value-of select="$newContext"/></context><text>*** One floatingLeg must have a floatingLeg/@id attribute value of 'floatingLeg2' when product type is 'Commodity Spread'.</text></error>
</xsl:if>
<xsl:variable name="fixedPayer"><xsl:value-of select="fpml:fixedLeg/fpml:payerPartyReference/@href"/></xsl:variable>
<xsl:variable name="floatingReceiver"><xsl:value-of select="fpml:floatingLeg/fpml:receiverPartyReference/@href"/></xsl:variable>
<xsl:if test="$productType='Commodity Swap' and $fixedPayer != $floatingReceiver">
<error><context><xsl:value-of select="$newContext"/></context><text>*** fixedLeg payer party is not floatingLeg receiver party.</text></error>
</xsl:if>
<xsl:variable name="fixedReceiver"><xsl:value-of select="fpml:fixedLeg/fpml:receiverPartyReference/@href"/></xsl:variable>
<xsl:variable name="floatingPayer"><xsl:value-of select="fpml:floatingLeg/fpml:payerPartyReference/@href"/></xsl:variable>
<xsl:if test="$productType='Commodity Swap' and $fixedReceiver != $floatingPayer">
<error><context><xsl:value-of select="$newContext"/></context><text>*** fixedLeg receiver party is not floatingLeg payer party.</text></error>
</xsl:if>
<xsl:variable name="leg1Receiver"><xsl:value-of select="fpml:floatingLeg[@id='floatingLeg1']/fpml:receiverPartyReference/@href"/></xsl:variable>
<xsl:variable name="leg2Payer"><xsl:value-of select="fpml:floatingLeg[@id='floatingLeg2']/fpml:payerPartyReference/@href"/></xsl:variable>
<xsl:if test="$productType= 'Commodity Spread' and $leg1Receiver != $leg2Payer">
<error><context><xsl:value-of select="$newContext"/></context><text>*** floatingLeg1 receiver party is not floatingLeg2 payer party.</text></error>
</xsl:if>
<xsl:variable name="leg1Payer"><xsl:value-of select="fpml:floatingLeg[@id='floatingLeg1']/fpml:payerPartyReference/@href"/></xsl:variable>
<xsl:variable name="leg2Receiver"><xsl:value-of select="fpml:floatingLeg[@id='floatingLeg2']/fpml:receiverPartyReference/@href"/></xsl:variable>
<xsl:if test="$productType= 'Commodity Spread' and $leg1Payer != $leg2Receiver">
<error><context><xsl:value-of select="$newContext"/></context><text>*** floatingLeg1 payer party is not floatingLeg2 receiver party.</text></error>
</xsl:if>
<xsl:variable name="gasFixedPayer"><xsl:value-of select="fpml:fixedLeg/fpml:payerPartyReference/@href"/></xsl:variable>
<xsl:variable name="gasPhysicalReceiver"><xsl:value-of select="fpml:gasPhysicalLeg/fpml:receiverPartyReference/@href"/></xsl:variable>
<xsl:if test="$productType='Commodity Forward' and $commodityCategory='Gas' and $gasFixedPayer != $gasPhysicalReceiver">
<error><context><xsl:value-of select="$newContext"/></context><text>*** fixedLeg payer party is not gasPhysicalLeg receiver party.</text></error>
</xsl:if>
<xsl:variable name="gasFixedReceiver"><xsl:value-of select="fpml:fixedLeg/fpml:receiverPartyReference/@href"/></xsl:variable>
<xsl:variable name="gasPhysicalPayer"><xsl:value-of select="fpml:gasPhysicalLeg/fpml:payerPartyReference/@href"/></xsl:variable>
<xsl:if test="$productType='Commodity Forward' and $commodityCategory='Gas' and $gasFixedReceiver != $gasPhysicalPayer">
<error><context><xsl:value-of select="$newContext"/></context><text>*** fixedLeg receiver party is not gasPhysicalLeg payer party.</text></error>
</xsl:if>
<xsl:variable name="elecFixedPayer"><xsl:value-of select="fpml:fixedLeg/fpml:payerPartyReference/@href"/></xsl:variable>
<xsl:variable name="elecPhysicalReceiver"><xsl:value-of select="fpml:electricityPhysicalLeg/fpml:receiverPartyReference/@href"/></xsl:variable>
<xsl:if test="$productType='Commodity Forward' and $commodityCategory='Electricity' and $elecFixedPayer != $elecPhysicalReceiver">
<error><context><xsl:value-of select="$newContext"/></context><text>*** fixedLeg payer party is not electricityPhysicalLeg receiver party.</text></error>
</xsl:if>
<xsl:variable name="elecFixedReceiver"><xsl:value-of select="fpml:fixedLeg/fpml:receiverPartyReference/@href"/></xsl:variable>
<xsl:variable name="elecPhysicalPayer"><xsl:value-of select="fpml:electricityPhysicalLeg/fpml:payerPartyReference/@href"/></xsl:variable>
<xsl:if test="$productType='Commodity Forward' and $commodityCategory='Electricity' and $elecFixedReceiver != $elecPhysicalPayer">
<error><context><xsl:value-of select="$newContext"/></context><text>*** fixedLeg receiver party is not electricityPhysicalLeg payer party.</text></error>
</xsl:if>
<xsl:if test="$productType='Commodity Swap' and $fixedPayer=$fixedReceiver">
<error><context><xsl:value-of select="$newContext"/>/fixedLeg</context><text> *** payerPartyReference/@href and receiverPartyReference/@href values are the same.</text></error>
</xsl:if>
<xsl:if test="$productType='Commodity Swap' and $floatingPayer=$floatingReceiver">
<error><context><xsl:value-of select="$newContext"/>/floatingLeg</context><text> *** payerPartyReference/@href and receiverPartyReference/@href values are the same.</text></error>
</xsl:if>
<xsl:if test="$productType='Commodity Spread' and $leg1Payer=$leg1Receiver">
<error><context><xsl:value-of select="$newContext"/>/floatingLeg[1]</context><text> *** payerPartyReference/@href and receiverPartyReference/@href values are the same.</text></error>
</xsl:if>
<xsl:if test="$productType='Commodity Spread' and $leg2Payer=$leg2Receiver">
<error><context><xsl:value-of select="$newContext"/>/floatingLeg [2]</context><text> *** payerPartyReference/@href and receiverPartyReference/@href values are the same.</text></error>
</xsl:if>
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">effectiveDate</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:effectiveDate/fpml:adjustableDate/fpml:unadjustedDate"/></xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
<xsl:if test="fpml:effectiveDate/fpml:adjustableDate/fpml:dateAdjustments/fpml:businessDayConvention != 'NotApplicable'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected businessDayConvention value encountered in this context. Must be set to 'NotApplicable'.</text></error>
</xsl:if>
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">terminationDate</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:terminationDate/fpml:adjustableDate/fpml:unadjustedDate"/></xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
<xsl:if test="fpml:terminationDate/fpml:adjustableDate/fpml:dateAdjustments/fpml:businessDayConvention != 'NotApplicable'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected businessDayConvention value encountered in this context. Must be set to 'NotApplicable'.</text></error>
</xsl:if>
<xsl:call-template name="isValidCurrency">
<xsl:with-param name="elementName">settlementCurrency</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:settlementCurrency"/></xsl:with-param>
<xsl:with-param name="commodityCategory"><xsl:value-of select="$commodityCategory"/></xsl:with-param>
<xsl:with-param name="productType"><xsl:value-of select="$productType"/></xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
<xsl:if test="fpml:commonPricing and not($productType='Commodity Spread')">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected commonPricing element encountered in this context when swbProductType is not. 'Commodity Spread'</text></error>
</xsl:if>
<xsl:if test="fpml:marketDisruption">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected marketDisruption element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:rounding">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected rounding element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="$productType='Commodity Swap' and fpml:fixedLeg/fpml:relativePaymentDates/fpml:payRelativeTo != fpml:floatingLeg/fpml:relativePaymentDates/fpml:payRelativeTo">
<error><context><xsl:value-of select="$newContext"/></context><text>*** relativePaymentDates/payRelativeTo elements must be the same on both legs of a Commodity Swap.</text></error>
</xsl:if>
<xsl:if test="$productType='Commodity Spread' and fpml:floatingLeg[@id='floatingLeg1']/fpml:relativePaymentDates/fpml:payRelativeTo != fpml:floatingLeg[@id='floatingLeg2']/fpml:relativePaymentDates/fpml:payRelativeTo">
<error><context><xsl:value-of select="$newContext"/></context><text>*** relativePaymentDates/payRelativeTo elements must be the same on both legs of a Commodity Spread.</text></error>
</xsl:if>
<xsl:if test="$productType='Commodity Spread' and fpml:floatingLeg[@id='floatingLeg1']/fpml:calculation/fpml:pricingDates/fpml:lag != fpml:floatingLeg[@id='floatingLeg2']/fpml:calculation/fpml:pricingDates/fpml:lag">
<error><context><xsl:value-of select="$newContext"/></context><text>*** calculation/pricingDates/lag elements must be the same on both legs of a Commodity Spread.</text></error>
</xsl:if>
<xsl:if test="$productType='Commodity Swap' and fpml:fixedLeg/fpml:relativePaymentDates/fpml:paymentDaysOffset/fpml:periodMultiplier != fpml:floatingLeg/fpml:relativePaymentDates/fpml:paymentDaysOffset/fpml:periodMultiplier">
<error><context><xsl:value-of select="$newContext"/></context><text>*** relativePaymentDates/paymentDaysOffset/periodMultiplier elements must be the same on both legs of a Commodity Swap.</text></error>
</xsl:if>
<xsl:if test="$productType='Commodity Spread' and fpml:floatingLeg[@id='floatingLeg1']/fpml:relativePaymentDates/fpml:paymentDaysOffset/fpml:periodMultiplier != fpml:floatingLeg[@id='floatingLeg2']/fpml:relativePaymentDates/fpml:paymentDaysOffset/fpml:periodMultiplier">
<error><context><xsl:value-of select="$newContext"/></context><text>*** relativePaymentDates/paymentDaysOffset/periodMultiplier elements must be the same on both legs of a Commodity Spread.</text></error>
</xsl:if>
<xsl:if test="$productType='Commodity Swap' and fpml:fixedLeg/fpml:relativePaymentDates/fpml:paymentDaysOffset/fpml:period != fpml:floatingLeg/fpml:relativePaymentDates/fpml:paymentDaysOffset/fpml:period">
<error><context><xsl:value-of select="$newContext"/></context><text>*** relativePaymentDates/paymentDaysOffset/period elements must be the same on both legs of a Commodity Swap.</text></error>
</xsl:if>
<xsl:if test="$productType='Commodity Spread' and fpml:floatingLeg[@id='floatingLeg1']/fpml:relativePaymentDates/fpml:paymentDaysOffset/fpml:period != fpml:floatingLeg[@id='floatingLeg2']/fpml:relativePaymentDates/fpml:paymentDaysOffset/fpml:period">
<error><context><xsl:value-of select="$newContext"/></context><text>*** relativePaymentDates/paymentDaysOffset/period elements must be the same on both legs of a Commodity Spread.</text></error>
</xsl:if>
<xsl:if test="$productType='Commodity Swap' and fpml:fixedLeg/fpml:relativePaymentDates/fpml:paymentDaysOffset/fpml:dayType != fpml:floatingLeg/fpml:relativePaymentDates/fpml:paymentDaysOffset/fpml:dayType">
<error><context><xsl:value-of select="$newContext"/></context><text>*** relativePaymentDates/paymentDaysOffset/dayType elements must be the same on both legs of a Commodity Swap.</text></error>
</xsl:if>
<xsl:if test="$productType='Commodity Spread' and fpml:floatingLeg[@id='floatingLeg1']/fpml:relativePaymentDates/fpml:paymentDaysOffset/fpml:dayType != fpml:floatingLeg[@id='floatingLeg2']/fpml:relativePaymentDates/fpml:paymentDaysOffset/fpml:dayType">
<error><context><xsl:value-of select="$newContext"/></context><text>*** relativePaymentDates/paymentDaysOffset/dayType elements must be the same on both legs of a Commodity Spread.</text></error>
</xsl:if>
<xsl:if test="$productType='Commodity Swap' and fpml:fixedLeg/fpml:relativePaymentDates/fpml:paymentDaysOffset/fpml:businessDayConvention != fpml:floatingLeg/fpml:relativePaymentDates/fpml:paymentDaysOffset/fpml:businessDayConvention">
<error><context><xsl:value-of select="$newContext"/></context><text>*** relativePaymentDates/paymentDaysOffset/businessDayConvention elements must be the same on both legs of a Commodity Swap.</text></error>
</xsl:if>
<xsl:if test="$productType='Commodity Spread' and fpml:floatingLeg[@id='floatingLeg1']/fpml:relativePaymentDates/fpml:paymentDaysOffset/fpml:businessDayConvention != fpml:floatingLeg[@id='floatingLeg2']/fpml:relativePaymentDates/fpml:paymentDaysOffset/fpml:businessDayConvention">
<error><context><xsl:value-of select="$newContext"/></context><text>*** relativePaymentDates/paymentDaysOffset/businessDayConvention elements must be the same on both legs of a Commodity Spread.</text></error>
</xsl:if>
<xsl:if test="$productType='Commodity Swap' and count(fpml:fixedLeg/fpml:relativePaymentDates/fpml:businessCenters/fpml:businessCenter) != count(fpml:floatingLeg/fpml:relativePaymentDates/fpml:businessCenters/fpml:businessCenter)">
<error><context><xsl:value-of select="$newContext"/></context><text>*** relativePaymentDates/businessCenters must have the same number of child businessCenter elements on each leg of a Commodity Swap.</text></error>
</xsl:if>
<xsl:if test="$productType='Commodity Spread' and count(fpml:floatingLeg[@id='floatingLeg1']/fpml:relativePaymentDates/fpml:businessCenters/businessCenter) != count(fpml:floatingLeg[@id='floatingLeg2']/fpml:relativePaymentDates/fpml:businessCenters/businessCenter)">
<error><context><xsl:value-of select="$newContext"/></context><text>**** relativePaymentDates/businessCenters must have the same number of child businessCenter elements on each leg of a  Commodity Spread.</text></error>
</xsl:if>
<xsl:if test="$productType='Commodity Swap'">
<xsl:for-each select="fpml:fixedLeg/fpml:relativePaymentDates/fpml:businessCenters/fpml:businessCenter">
<xsl:variable name="position" select="position()"/>
<xsl:if test=". != //fpml:floatingLeg/fpml:relativePaymentDates/fpml:businessCenters/fpml:businessCenter[$position]">
<error><context><xsl:value-of select="$newContext"/></context><text>*** relativePaymentDates/businessCenters/businessCenter elements must be the same on each leg of a Commodity Swap.</text></error>
</xsl:if>
</xsl:for-each>
</xsl:if>
<xsl:if test="$productType='Commodity Spread'">
<xsl:for-each select="fpml:floatingLeg[@id='floatingLeg1']/fpml:relativePaymentDates/fpml:businessCenters/fpml:businessCenter">
<xsl:variable name="position" select="position()"/>
<xsl:if test=". != //fpml:floatingLeg[@id='floatingLeg2']/fpml:relativePaymentDates/fpml:businessCenters/fpml:businessCenter[$position]">
<error><context><xsl:value-of select="$newContext"/></context><text>*** relativePaymentDates/businessCenters/businessCenter elements must be the same on each leg of a Commodity Spread.</text></error>
</xsl:if>
</xsl:for-each>
</xsl:if>
<xsl:choose>
<xsl:when test="fpml:floatingLeg/fpml:notionalQuantity and $productType='Commodity Swap'">
<xsl:if test="fpml:floatingLeg/fpml:notionalQuantity != fpml:fixedLeg/fpml:notionalQuantity">
<error><context><xsl:value-of select="$newContext"/></context><text>*** notionalQuantity components must be the same on both legs of a Commodity Swap.</text></error>
</xsl:if>
</xsl:when>
<xsl:when test="fpml:floatingLeg/fpml:notionalQuantitySchedule and $productType='Commodity Swap'">
<xsl:if test="fpml:floatingLeg/fpml:notionalQuantitySchedule != fpml:fixedLeg/fpml:notionalQuantitySchedule">
<error><context><xsl:value-of select="$newContext"/></context><text>*** notionalQuantitySchedule components must be the same on both legs of a Commodity Swap.</text></error>
</xsl:if>
</xsl:when>
</xsl:choose>
<xsl:apply-templates select="fpml:fixedLeg">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:floatingLeg">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:gasPhysicalLeg">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:electricityPhysicalLeg">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:commoditySwap/fpml:fixedLeg">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="fpml:calculationPeriods">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected calculationPeriods element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:calculationPeriodsSchedule and $productType='Commodity Swap'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected calculationPeriodsSchedule element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="not(fpml:calculationPeriodsSchedule) and $productType='Commodity Forward'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Missing calculationPeriodsSchedule element  in this context.</text></error>
</xsl:if>
<xsl:apply-templates select="fpml:calculationPeriodsSchedule">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:calculationPeriodsReference">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected calculationPeriodsReference element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="not(fpml:calculationPeriodsScheduleReference) and $productType='Commodity Swap'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Missing calculationPeriodsScheduleReference element in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:calculationPeriodsScheduleReference and $productType='Commodity Forward'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected calculationPeriodsScheduleReference element in this context.</text></error>
</xsl:if>
<xsl:if test="not(fpml:calculationPeriodsScheduleReference[@href='floatingLegCalculationPeriods']) and $productType='Commodity Swap'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** calculationPeriodsScheduleReference/@href must be set to 'floatingLegCalculationPeriods'. Value='<xsl:value-of select="fpml:calculationPeriodsScheduleReference/@href"/>'.</text></error>
</xsl:if>
<xsl:if test="($commodityCategory = 'Freight' or $commodityCategory = 'Electricity') and fpml:fixedPrice">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected fixedPrice element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="not($commodityCategory = 'Electricity') and fpml:settlementPeriodsPrice">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected settlementPeriodsPrice element encountered in this context.</text></error>
</xsl:if>
<xsl:apply-templates select="fpml:fixedPrice">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="not($commodityCategory = 'Freight') and fpml:worldscaleRate">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected worldscaleRate element encountered in this context.</text></error>
</xsl:if>
<xsl:apply-templates select="fpml:worldscaleRate">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="not($commodityCategory = 'Freight') and fpml:contractRate">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected contractRate element encountered in this context.</text></error>
</xsl:if>
<xsl:apply-templates select="fpml:contractRate">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="$commodityCategory = 'Electricity' and fpml:settlementPeriodsPrice and not(count(fpml:settlementPeriodsPrice)=1)">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected number of settlementPeriodsPrice elements encountered.</text></error>
</xsl:if>
<xsl:apply-templates select="fpml:settlementPeriodsPrice">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:fixedPriceSchedule and not(//fpml:floatingLeg/fpml:notionalQuantitySchedule)">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected fixedPriceSchedule element encountered in this context when floating leg does not have a notionalQuantitySchedule component.</text></error>
</xsl:if>
<xsl:if test="fpml:fixedPriceSchedule and $productType='Commodity Forward'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected fixedPriceSchedule element encountered in this context for a Commodity Forward.</text></error>
</xsl:if>
<xsl:if test="fpml:fixedPrice and //fpml:floatingLeg/fpml:notionalQuantitySchedule">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected fixedPrice element encountered in this context when floating leg  has a notionalQuantitySchedule component.</text></error>
</xsl:if>
<xsl:apply-templates select="fpml:fixedPriceSchedule">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="($commodityCategory = 'Freight') and (//fpml:floatingLeg/fpml:commodity/fpml:multiplier) and (fpml:notionalQuantity/fpml:quantityFrequency='PerCalendarDay') and not(fpml:notionalQuantity/fpml:quantity = 1)">
<error><context><xsl:value-of select="$newContext"/></context><text>*** notionalQuantity/quantity must equal 1 when notionalQuantity/quantityFrequency is set to 'PerCalendarDay'.</text></error>
</xsl:if>
<xsl:if test="($commodityCategory = 'Freight') and (//fpml:floatingLeg/fpml:commodity/fpml:multiplier) and (fpml:notionalQuantity/fpml:quantityFrequency='PerCalculationPeriod') and not(//fpml:floatingLeg/fpml:commodity/fpml:multiplier = 1)">
<error><context><xsl:value-of select="$newContext"/></context><text>*** multiplier must equal 1 when notionalQuantity/quantityFrequency is set to 'PerCalculationPeriod'.</text></error>
</xsl:if>
<xsl:if test="not(fpml:quantityReference) and $productType='Commodity Forward'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Missing quantityReference element encountered in this context for a Commodity Forward.</text></error>
</xsl:if>
<xsl:if test="not(fpml:quantityReference[@href='deliveryQuantity']) and $productType='Commodity Forward'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** quantityReference/@href must be set to 'deliveryQuantity' on the fixed leg of a Commodity Forward. Value='<xsl:value-of select="fpml:quantityReference/@href"/>'.</text></error>
</xsl:if>
<xsl:if test="fpml:notionalQuantity and $commodityCategory='Electricity'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected notionalQuantity element encountered in this context.</text></error>
</xsl:if>
<xsl:apply-templates select="fpml:notionalQuantity">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:settlementPeriodsNotionalQuantity and not(count(fpml:settlementPeriodsNotionalQuantity) = 1)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Only one settlementPeriodsNotionalQuantity element must be present.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:settlementPeriodsNotionalQuantity">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:notionalQuantitySchedule">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="($commodityCategory = 'Freight') and (fpml:totalNotionalQuantity) and (//fpml:floatingLeg/fpml:commodity/fpml:multiplier)">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected totalNotionalQuantity element in this context when floating leg has a multiplier element.</text></error>
</xsl:if>
<xsl:if test="fpml:totalNotionalQuantity and not(fpml:totalNotionalQuantity = //fpml:floatingLeg/fpml:totalNotionalQuantity)">
<error><context><xsl:value-of select="$newContext"/></context><text>*** fixedLeg/totalNotionalQuantity must equal floatingLeg/totalNotionalQuantity.</text></error>
</xsl:if>
<xsl:if test="fpml:totalNotionalQuantity">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">totalNotionalQuantity</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:totalNotionalQuantity"/></xsl:with-param>
<xsl:with-param name="minIncl">0.001</xsl:with-param>
<xsl:with-param name="maxIncl">999999999999.999</xsl:with-param>
<xsl:with-param name="maxDecs">3</xsl:with-param>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:paymentDates">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected paymentDates element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:relativePaymentDates and $productType='Commodity Forward'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected relativePaymentDates element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:masterAgreementPaymentDates and $productType='Commodity Swap'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected masterAgreementPaymentDates element encountered in this context.</text></error>
</xsl:if>
<xsl:apply-templates select="fpml:relativePaymentDates">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:flatRate">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected flatRate element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:flatRateAmount">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected flatRateAmount element encountered in this context.</text></error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:electricityPhysicalLeg">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:apply-templates select="fpml:deliveryPeriods">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="not(count(fpml:settlementPeriods) = 1)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Only one settlementPeriods element must be present.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:settlementPeriods">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:settlementPeriodsSchedule">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected settlementPeriodsSchedule element encountered in this context.</text></error>
</xsl:if>
<xsl:apply-templates select="fpml:electricity">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:deliveryConditions">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:deliveryQuantity">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:electricity">
<xsl:param name="context"/><xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="fpml:voltage">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected voltage element encountered in this context.</text></error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:settlementPeriods">
<xsl:param name="context"/><xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="not(fpml:duration = '1Hour')">
<error><context><xsl:value-of select="$newContext"/></context><text>*** duration must be set to '1Hour' in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:applicableDay">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected applicableDay element encountered in this context.</text></error>
</xsl:if>
<xsl:apply-templates select="fpml:startTime">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:endTime">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:excludeHolidays">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected excludeHolidays element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:includeHolidays">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected includeHolidays element encountered in this context.</text></error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:settlementPeriods/fpml:startTime|fpml:settlementPeriods/fpml:endTime">
<xsl:param name="context"/><xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:apply-templates select="fpml:time">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:offset">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected offset element encountered in this context.</text></error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:startTime/fpml:time|fpml:endTime/fpml:time">
<xsl:param name="context"/><xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="not(fpml:hourMinuteTime = '00:00:00')">
<error><context><xsl:value-of select="$newContext"/></context><text>*** hourMinuteTime must be set to '00:00:00' in this context.</text></error>
</xsl:if>
<xsl:if test="not(fpml:location = '')">
<error><context><xsl:value-of select="$newContext"/></context><text>*** location must be empty in this context.</text></error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:gasPhysicalLeg">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:apply-templates select="fpml:deliveryPeriods">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:gas">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:deliveryConditions">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:deliveryQuantity">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:deliveryQuantity">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="./@id != 'deliveryQuantity'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** @id must be set to 'deliveryQuantity'. Value= '<xsl:value-of select="./@id"/>'.</text></error>
</xsl:if>
<xsl:if test="not(count(fpml:physicalQuantity) = 1)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** At least and no more than one physicalQuantity element must be present.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:physicalQuantity">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:deliveryPeriods">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="not(fpml:calculationPeriodsScheduleReference)">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Missing calculationPeriodsScheduleReference element.</text></error>
</xsl:if>
<xsl:if test="not(fpml:calculationPeriodsScheduleReference[@href='fixedLegCalculationPeriods'])">
<error><context><xsl:value-of select="$newContext"/></context><text>*** calculationPeriodsScheduleReference/@href must be set to 'fixedLegCalculationPeriods'. Value='<xsl:value-of select="fpml:calculationPeriodsScheduleReference/@href"/>'.</text></error>
</xsl:if>
<xsl:if test="fpml:supplyStartTime">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected supplyStartTime and supplyEndTime elements encountered in this context.</text></error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:gas">
<xsl:param name="context"/><xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="fpml:calorificValue">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected calorificValue element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:quality">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected quality element encountered in this context.</text></error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:gasPhysicalLeg/fpml:deliveryConditions">
<xsl:param name="context"/><xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="fpml:entryPoint">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected entryPoint and withdrawalPoint elements encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:buyerHub">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected buyerHub and sellerHub elements encountered in this context.</text></error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:electricityPhysicalLeg/fpml:deliveryConditions">
<xsl:param name="context"/><xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="fpml:transmissionContingency">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected transmissionContingency element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:nonFirm ='false' ">
<error><context><xsl:value-of select="$newContext"/></context><text>*** nonFirm must be set to 'true'. Value='true'.</text></error>
</xsl:if>
<xsl:apply-templates select="fpml:systemFirm">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:unitFirm">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:electingParty">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected electingParty element encountered in this context.</text></error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:electricityPhysicalLeg/fpml:deliveryConditions/fpml:systemFirm">
<xsl:param name="context"/><xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="fpml:system">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected system element encountered in this context.</text></error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:electricityPhysicalLeg/fpml:deliveryConditions/fpml:unitFirm">
<xsl:param name="context"/><xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="fpml:generationAsset">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected generationAsset element encountered in this context.</text></error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:electricityPhysicalLeg/fpml:deliveryQuantity/fpml:physicalQuantity">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:call-template name="isValidUnit">
<xsl:with-param name="elementName">quantityUnit</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:quantityUnit"/></xsl:with-param>
<xsl:with-param name="commodityCategory"><xsl:value-of select="$commodityCategory"/></xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
<xsl:if test="fpml:quantityFrequency != 'PerSettlementPeriod'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** quantityFrequency must be set to 'PerSettlementPeriod'. Value= '<xsl:value-of select="fpml:quantityFrequency"/>'.</text></error>
</xsl:if>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">quantity</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:quantity"/></xsl:with-param>
<xsl:with-param name="minIncl">0.001</xsl:with-param>
<xsl:with-param name="maxIncl">999999999999.999</xsl:with-param>
<xsl:with-param name="maxDecs">3</xsl:with-param>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
<xsl:if test="not(fpml:settlementPeriodsReference[@href='SWBLoadShape'])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** settlementPeriodsReference/@href must be set to 'SWBLoadShape'. Value='<xsl:value-of select="calculationPeriodsScheduleReference/@href"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not(count(fpml:settlementPeriodsReference) = 1)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Only one settlementPeriodsReference element must be present.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:gasPhysicalLeg/fpml:deliveryQuantity/fpml:physicalQuantity">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:call-template name="isValidUnit">
<xsl:with-param name="elementName">quantityUnit</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:quantityUnit"/></xsl:with-param>
<xsl:with-param name="commodityCategory"><xsl:value-of select="$commodityCategory"/></xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
<xsl:call-template name="isValidQuantityFrequency">
<xsl:with-param name="elementName">quantityFrequency</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:quantityFrequency"/></xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">quantity</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:quantity"/></xsl:with-param>
<xsl:with-param name="minIncl">0.001</xsl:with-param>
<xsl:with-param name="maxIncl">999999999999.999</xsl:with-param>
<xsl:with-param name="maxDecs">3</xsl:with-param>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
</xsl:template>
<xsl:template match="fpml:fixedPrice|fpml:fixedPriceStep|fpml:settlementPeriodsPriceStep">
<xsl:param name="context"/><xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">price</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:price"/></xsl:with-param>
<xsl:with-param name="minIncl">0.0000001</xsl:with-param>
<xsl:with-param name="maxIncl">99999999.9999999</xsl:with-param>
<xsl:with-param name="maxDecs">7</xsl:with-param>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
<xsl:call-template name="isValidCurrency">
<xsl:with-param name="elementName">priceCurrency</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:priceCurrency"/></xsl:with-param>
<xsl:with-param name="commodityCategory"><xsl:value-of select="$commodityCategory"/></xsl:with-param>
<xsl:with-param name="productType"><xsl:value-of select="$productType"/></xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
<xsl:if test="not(fpml:priceCurrency = /fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:commoditySwap/fpml:settlementCurrency) and /fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:commoditySwap/fpml:settlementCurrency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** priceCurrency must be equal to commoditySwap/settlementCurrency.</text>
</error>
</xsl:if>
<xsl:call-template name="isValidUnit">
<xsl:with-param name="elementName">priceUnit</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:priceUnit"/></xsl:with-param>
<xsl:with-param name="commodityCategory"><xsl:value-of select="$commodityCategory"/></xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
</xsl:template>
<xsl:template match="fpml:settlementPeriodsPrice">
<xsl:param name="context"/><xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">price</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:price"/></xsl:with-param>
<xsl:with-param name="minIncl">0.0000001</xsl:with-param>
<xsl:with-param name="maxIncl">99999999.9999999</xsl:with-param>
<xsl:with-param name="maxDecs">7</xsl:with-param>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
<xsl:call-template name="isValidCurrency">
<xsl:with-param name="elementName">priceCurrency</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:priceCurrency"/></xsl:with-param>
<xsl:with-param name="commodityCategory"><xsl:value-of select="$commodityCategory"/></xsl:with-param>
<xsl:with-param name="productType"><xsl:value-of select="$productType"/></xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
<xsl:if test="not(fpml:priceCurrency = /fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:commoditySwap/fpml:settlementCurrency) and /fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:commoditySwap/fpml:settlementCurrency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** priceCurrency must be equal to commoditySwap/settlementCurrency.</text>
</error>
</xsl:if>
<xsl:call-template name="isValidUnit">
<xsl:with-param name="elementName">priceUnit</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:priceUnit"/></xsl:with-param>
<xsl:with-param name="commodityCategory"><xsl:value-of select="$commodityCategory"/></xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
<xsl:if test="not(fpml:settlementPeriodsReference[@href='SWBLoadShape'])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** settlementPeriodsReference/@href must be set to 'SWBLoadShape'. Value='<xsl:value-of select="calculationPeriodsScheduleReference/@href"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not(count(fpml:settlementPeriodsReference) = 1)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Only one settlementPeriodsReference element must be present.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:contractRate|fpml:contractRateStep">
<xsl:param name="context"/><xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">amount</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:amount"/></xsl:with-param>
<xsl:with-param name="minIncl">0.0000001</xsl:with-param>
<xsl:with-param name="maxIncl">99999999.9999999</xsl:with-param>
<xsl:with-param name="maxDecs">7</xsl:with-param>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
<xsl:call-template name="isValidCurrency">
<xsl:with-param name="elementName">currency</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:currency"/></xsl:with-param>
<xsl:with-param name="commodityCategory"><xsl:value-of select="$commodityCategory"/></xsl:with-param>
<xsl:with-param name="productType"><xsl:value-of select="$productType"/></xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
<xsl:if test="not(fpml:currency = /fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:commoditySwap/fpml:settlementCurrency) and /fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:commoditySwap/fpml:settlementCurrency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** currency must be equal to commoditySwap/settlementCurrency.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:worldscaleRate|fpml:worldscaleRateStep">
<xsl:param name="context"/><xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="($commodityCategory = 'Freight') and (//fpml:floatingLeg/fpml:commodity/fpml:multiplier)">
<error><context><xsl:value-of select="$context"/></context><text>*** Unexpected <xsl:value-of select="local-name()"/> element in this context when floating leg has a multiplier element.</text></error>
</xsl:if>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">.</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="."/></xsl:with-param>
<xsl:with-param name="minIncl">0.0000001</xsl:with-param>
<xsl:with-param name="maxIncl">99999999.9999999</xsl:with-param>
<xsl:with-param name="maxDecs">7</xsl:with-param>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
</xsl:template>
<xsl:template match="fpml:fixedPriceSchedule">
<xsl:param name="context"/><xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="(count(fpml:fixedPriceStep) &lt; 2) and (count(fpml:worldscaleRateStep) &lt; 2) and (count(fpml:contractRateStep) &lt; 2) and not($commodityCategory='Electricity')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** fixedPriceSchedule must contain more than one fixedPriceStep, worldscaleRateStep or contractRateStep element.</text>
</error>
</xsl:if>
<xsl:if test="fpml:fixedPriceStep">
<xsl:if test="fpml:fixedPriceStep[1]/fpml:priceCurrency != fpml:fixedPriceStep/fpml:priceCurrency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** priceCurrency must be the same in every fixedPriceStep element.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:fixedPriceStep">
<xsl:if test="fpml:fixedPriceStep[1]/fpml:priceUnit != fpml:fixedPriceStep/fpml:priceUnit">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** priceUnit must be the same in every fixedPriceStep element.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:contractRateStep">
<xsl:if test="fpml:contractRateStep[1]/fpml:currency != fpml:contractRateStep/fpml:currency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** currency must be the same in every contractRateStep element.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$commodityCategory = 'Freight' and fpml:fixedPriceStep">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected fixedPriceStep element encountered in this context.</text></error>
</xsl:if>
<xsl:apply-templates select="fpml:fixedPriceStep">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="not($commodityCategory = 'Freight') and fpml:worldscaleRateStep">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected worldscaleRateStep element encountered in this context.</text></error>
</xsl:if>
<xsl:apply-templates select="fpml:worldscaleRateStep">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="not($commodityCategory = 'Freight') and fpml:contractRateStep">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected contractRateStep element encountered in this context.</text></error>
</xsl:if>
<xsl:apply-templates select="fpml:contractRateStep">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="$commodityCategory = 'Electricity' and not(fpml:settlementPeriodsPriceSchedule)">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Missing settlementPeriodsPriceSchedule element.</text></error>
</xsl:if>
<xsl:apply-templates select="fpml:settlementPeriodsPriceSchedule">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:settlementPeriodsPriceSchedule">
<xsl:param name="context"/><xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="count(fpml:settlementPeriodsPriceStep) &lt; 2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** settlementPeriodsPriceSchedule must contain more than one settlementPeriodsPriceStep element.</text>
</error>
</xsl:if>
<xsl:if test="fpml:settlementPeriodsPriceStep">
<xsl:if test="fpml:settlementPeriodsPriceStep[1]/fpml:priceCurrency != fpml:settlementPeriodsPriceStep/fpml:priceCurrency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** priceCurrency must be the same in every settlementPeriodsPriceStep element.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:settlementPeriodsPriceStep">
<xsl:if test="fpml:settlementPeriodsPriceStep[1]/fpml:priceUnit != fpml:settlementPeriodsPriceStep/fpml:priceUnit">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** priceUnit must be the same in every settlementPeriodsPriceStep element.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:settlementPeriodsPriceStep">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="not(fpml:settlementPeriodsReference[@href='SWBLoadShape'])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** settlementPeriodsReference/@href must be set to 'SWBLoadShape'. Value='<xsl:value-of select="calculationPeriodsScheduleReference/@href"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not(count(fpml:settlementPeriodsReference) = 1)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Only one settlementPeriodsReference element must be present.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:notionalQuantity|fpml:notionalStep|fpml:settlementPeriodsNotionalQuantityStep">
<xsl:param name="context"/><xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="legCommodityCategory">
<xsl:choose>
<xsl:when test="$productType='Commodity Spread' and ancestor::fpml:floatingLeg[@id='floatingLeg2']">
<xsl:value-of select="$commodityCategory2"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$commodityCategory"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:call-template name="isValidUnit">
<xsl:with-param name="elementName">quantityUnit</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:quantityUnit"/></xsl:with-param>
<xsl:with-param name="commodityCategory"><xsl:value-of select="$legCommodityCategory"/></xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
<xsl:call-template name="isValidQuantityFrequency">
<xsl:with-param name="elementName">quantityFrequency</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:quantityFrequency"/></xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">quantity</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:quantity"/></xsl:with-param>
<xsl:with-param name="minIncl">0.000</xsl:with-param>
<xsl:with-param name="maxIncl">999999999999.999</xsl:with-param>
<xsl:with-param name="maxDecs">3</xsl:with-param>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
<xsl:if test="$commodityCategory = 'Freight' and $productType='Commodity Swap' and (//fpml:floatingLeg/fpml:commodity/fpml:multiplier) and not(fpml:quantityUnit = 'Day')">
<error><context><xsl:value-of select="$newContext"/></context><text>*** quantityUnit must equal 'Day' when multiplier is present on the floating leg.</text></error>
</xsl:if>
<xsl:if test="$commodityCategory = 'Freight' and $productType='Commodity Swap' and not(//fpml:floatingLeg/fpml:commodity/fpml:multiplier) and (fpml:quantityUnit = 'Day')">
<error><context><xsl:value-of select="$newContext"/></context><text>*** quantityUnit must not equal 'Day' when multiplier is not present on the floating leg.</text></error>
</xsl:if>
<xsl:if test="$commodityCategory = 'Freight' and $productType='Commodity Swap' and local-name()='notionalStep' and (//fpml:floatingLeg/fpml:commodity/fpml:multiplier) and not(fpml:quantityFrequency = 'PerCalculationPeriod')">
<error><context><xsl:value-of select="$newContext"/></context><text>*** quantityFrequency must equal 'PerCalculationPeriod'' when multiplier is present on the floating leg.</text></error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:settlementPeriodsNotionalQuantity">
<xsl:param name="context"/><xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="legCommodityCategory">
<xsl:choose>
<xsl:when test="$productType='Commodity Spread' and ancestor::fpml:floatingLeg[@id='floatingLeg2']">
<xsl:value-of select="$commodityCategory2"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$commodityCategory"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:call-template name="isValidUnit">
<xsl:with-param name="elementName">quantityUnit</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:quantityUnit"/></xsl:with-param>
<xsl:with-param name="commodityCategory"><xsl:value-of select="$legCommodityCategory"/></xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
<xsl:call-template name="isValidQuantityFrequency">
<xsl:with-param name="elementName">quantityFrequency</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:quantityFrequency"/></xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">quantity</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:quantity"/></xsl:with-param>
<xsl:with-param name="minIncl">0.001</xsl:with-param>
<xsl:with-param name="maxIncl">999999999999.999</xsl:with-param>
<xsl:with-param name="maxDecs">3</xsl:with-param>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
<xsl:if test="not(fpml:settlementPeriodsReference[@href='SWBLoadShape'])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** settlementPeriodsReference/@href must be set to 'SWBLoadShape'. Value='<xsl:value-of select="calculationPeriodsScheduleReference/@href"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not(count(fpml:settlementPeriodsReference) = 1)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Only one settlementPeriodsReference element must be present.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:relativePaymentDates">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="fpml:payRelativeTo != 'CalculationPeriodEndDate'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** payRelativeTo must be set to 'CalculationPeriodEndDate' in this context.</text></error>
</xsl:if>
<xsl:if test="ancestor::fpml:fixedLeg and not(fpml:calculationPeriodsScheduleReference[@href='floatingLegCalculationPeriods'])">
<error><context><xsl:value-of select="$newContext"/></context><text>*** calculationPeriodsScheduleReference/@href must be set to 'floatingLegCalculationPeriods' on the fixed leg of a Commodity Swap. Value='<xsl:value-of select="fpml:calculationPeriodsScheduleReference/@href"/>'.</text></error>
</xsl:if>
<xsl:if test="$productType='Commodity Spread' and ancestor::fpml:floatingLeg[@id='floatingLeg1'] and not(fpml:calculationPeriodsScheduleReference/@href='floatingLeg1CalculationPeriods')">
<error><context><xsl:value-of select="$newContext"/></context><text>*** calculationPeriodsScheduleReference/@href must be set to 'floatingLeg1CalculationPeriods' on leg 1 of a Commodity Spread. Value='<xsl:value-of select="./@id"/>'.</text></error>
</xsl:if>
<xsl:if test="$productType='Commodity Spread' and ancestor::fpml:floatingLeg[@id='floatingLeg2'] and not(fpml:calculationPeriodsScheduleReference/@href='floatingLeg1CalculationPeriods') and ancestor::fpml:floatingLeg[@id='floatingLeg2']/fpml:calculationPeriodsScheduleReference">
<error><context><xsl:value-of select="$newContext"/></context><text>*** calculationPeriodsScheduleReference/@href must be set to 'floatingLeg1CalculationPeriods'  on leg 2 of a Commodity Spread when no separate calculationPeriodsSchedule has been specified on this leg. Value='<xsl:value-of select="fpml:calculationPeriodsScheduleReference/@href"/>'.</text></error>
</xsl:if>
<xsl:if test="$productType='Commodity Spread' and ancestor::fpml:floatingLeg[@id='floatingLeg2'] and not(fpml:calculationPeriodsScheduleReference/@href='floatingLeg2CalculationPeriods') and ancestor::fpml:floatingLeg[@id='floatingLeg2']/fpml:calculationPeriodsSchedule">
<error><context><xsl:value-of select="$newContext"/></context><text>*** calculationPeriodsScheduleReference/@href must be set to 'floatingLeg2CalculationPeriods'  on leg 2 of a Commodity Spread when a separate calculationPeriodsSchedule has been specified on this leg. Value='<xsl:value-of select="fpml:calculationPeriodsScheduleReference/@href"/>'.</text></error>
</xsl:if>
<xsl:if test="$productType='Commodity Option' and not(fpml:calculationPeriodsScheduleReference[@href='calculationPeriods'])">
<error><context><xsl:value-of select="$newContext"/></context><text>*** calculationPeriodsScheduleReference/@href must be set to 'calculationPeriods' for a Commodity Option. Value='<xsl:value-of select="fpml:calculationPeriodsScheduleReference/@href"/>'.</text></error>
</xsl:if>
<xsl:apply-templates select="fpml:paymentDaysOffset">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:businessCentersReference">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected businessCentersReference element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:businessCalendar">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected businessCalendar element encountered in this context.</text></error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:paymentDates">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="fpml:adjustableDates">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected adjustableDates element encountered in this context.</text></error>
</xsl:if>
<xsl:apply-templates select="fpml:relativeDate">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:relativeDate">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="fpml:periodMultiplier and $productType != 'Commodity Forward'">
<xsl:call-template name="isValidIntegerNumber">
<xsl:with-param name="elementName">periodMultiplier</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:periodMultiplier"/></xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">99</xsl:with-param>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="$commodityCategory ='Precious' and $productType = 'Commodity Forward' and fpml:periodMultiplier != '0'">
<error><context><xsl:value-of select="$newContext"/>/relativeDate</context><text>*** Invalid value for periodMultiplier in this context when commodityCategory is 'Precious' and swbProduct type is 'Commodity Forward'. Must be equal to '0'. Value = '<xsl:value-of select="fpml:relativeDate/fpml:periodMultiplier"/>'.</text></error>
</xsl:if>
<xsl:if test="fpml:period != 'D'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Invalid value for period in this context. Must be equal to 'D'. Value = '<xsl:value-of select="fpml:period"/>'.</text></error>
</xsl:if>
<xsl:if test="fpml:dayType and $productType='Commodity Forward'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected dayType encountered in this context when swbProductType is 'Commodity Forward'.</text></error>
</xsl:if>
<xsl:if test="$commodityCategory ='Precious' and $productType= 'Commodity Forward' and fpml:businessDayConvention != 'NotApplicable'">
<error><context><xsl:value-of select="$newContext"/>/relativeDate</context><text>*** Invalid value for businessDayConvention in this context when commodityCategory is 'Precious' and swbProductType is 'Commodity Forward'. Must be equal to 'NotApplicable'. Value = '<xsl:value-of select="fpml:businessDayConvention"/>'.</text></error>
</xsl:if>
<xsl:if test="fpml:businessCentersReference">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected businessCentersReference element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="$commodityCategory ='Precious' and $productType= 'Commodity Forward' and fpml:businessCenters">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected businessCenters element encountered in this context when commodityCategory is 'Precious'and swbProductType is 'Commodity Forward'.</text></error>
</xsl:if>
<xsl:if test="$commodityCategory ='Precious' and $productType='Commodity Forward' and fpml:dateRelativeTo/@href != 'valueDate'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Invalid value for dateRelativeTo/@href in this context when commodityCategory is 'Precious'. Must be equal to 'valueDate' and swbProductType is 'Commodity Forward'. Value = '<xsl:value-of select="fpml:dateRelativeTo/@href"/>'.</text></error>
</xsl:if>
<xsl:if test="../fpml:americanExercise and not(fpml:dateRelativeTo[@href='exerciseDate'])">
<error><context><xsl:value-of select="$newContext"/></context><text>*** dateRelativeTo/@href must be set to 'exerciseDate' when ../americanExercise is present'. Value='<xsl:value-of select="fpml:relativeDate/fpml:dateRelativeTo/@href"/>'.</text></error>
</xsl:if>
<xsl:if test="../fpml:europeanExercise and not(fpml:dateRelativeTo[@href='expirationDate'])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** dateRelativeTo/@href must be set to 'expirationDate' when ../europeanExercise is present'. Value='<xsl:value-of select="fpml:relativeDate/fpml:dateRelativeTo/@href"/>'.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:paymentDaysOffset">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:call-template name="isValidPeriodMultiplier">
<xsl:with-param name="elementName">periodMultiplier</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:periodMultiplier"/></xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
<xsl:call-template name="isValidPeriod">
<xsl:with-param name="elementName">period</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:period"/></xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
<xsl:call-template name="isValidPaymentDayType">
<xsl:with-param name="elementName">period</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:dayType"/></xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
<xsl:if test="fpml:dayType='Business' and fpml:businessDayConvention!='NONE'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** businessDayConvention must be set to 'NONE' when dayType is set to 'Business' in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:dayType='Calendar' and not(fpml:businessDayConvention='FOLLOWING' or fpml:businessDayConvention='MODFOLLOWING' or fpml:businessDayConvention='NEAREST' or fpml:businessDayConvention='PRECEDING')">
<error><context><xsl:value-of select="$newContext"/></context><text>*** businessDayConvention must be set to 'FOLLOWING', 'MODFOLLOWING', 'NEAREST' or 'PRECEDING' when dayType is set to 'Calendar' in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:sequence">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected sequence element encountered in this context.</text></error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:businessCenters">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:apply-templates select="fpml:businessCenter">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:valueDate/fpml:adjustableDate/fpml:dateAdjustments/fpml:businessCenters">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="count(fpml:businessCenter) &gt; 2">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected number of businessCenter elements encountered in this context. Only one or two permitted.</text></error>
</xsl:if>
<xsl:if test="count(fpml:businessCenter) &lt; 1">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected number of businessCenter elements encountered in this context. At least one must be present.</text></error>
</xsl:if>
<xsl:if test="not(count(fpml:businessCenter[@id='cashSettlementHolidayCentre']) = 1)">
<error><context><xsl:value-of select="$newContext"/></context><text>*** One and only one businessCenter element must be present with id set to 'cashSettlementHolidayCentre'.</text></error>
</xsl:if>
<xsl:if test="count(fpml:businessCenter) = 2 and not((count(fpml:businessCenter[@id='physicalSettlementHolidayCentre']) = 1))">
<error><context><xsl:value-of select="$newContext"/></context><text>*** When two businessCenter elements are present, one must have the id attribute set to 'physicalSettlementHolidayCentre'.</text></error>
</xsl:if>
<xsl:if test="fpml:businessCenter/@id='cashSettlementHolidayCentre'">
<xsl:call-template name="isValidBusinessCenter">
<xsl:with-param name="elementName">businessCenter</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="./fpml:businessCenter[@id='cashSettlementHolidayCentre']"/></xsl:with-param>
<xsl:with-param name="testNumber"></xsl:with-param>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:businessCenter/@id='physicalSettlementHolidayCentre'">
<xsl:call-template name="isValidPhysicalDeliveryBusinessCenter">
<xsl:with-param name="elementName">businessCenter</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="./fpml:businessCenter[@id='physicalSettlementHolidayCentre']"/></xsl:with-param>
<xsl:with-param name="testNumber"></xsl:with-param>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:businessCenter">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:call-template name="isValidBusinessCenter">
<xsl:with-param name="elementName">businessCenter</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="."/></xsl:with-param>
<xsl:with-param name="testNumber"></xsl:with-param>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
</xsl:template>
<xsl:template match="fpml:floatingLeg">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="fpml:calculationPeriods">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected calculationPeriods element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:calculationPeriodsReference">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected calculationPeriodsReference element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:calculationPeriodsScheduleReference and (./@id='floatingLeg1' or ./@id='floatingLeg')">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected calculationPeriodsScheduleReference element encountered in this context. The floatingLeg (Commodity Swap) or floatingLeg1 (Commodity Spread) must have the calculationPeriodsSchedule set out in full.</text></error>
</xsl:if>
<xsl:if test="fpml:calculationPeriodsScheduleReference">
<xsl:if test="not(fpml:calculationPeriodsScheduleReference[@href='floatingLeg1CalculationPeriods'])">
<error><context><xsl:value-of select="$newContext"/></context><text>*** calculationPeriodsScheduleReference/@href must be set to 'floatingLeg1CalculationPeriods' on floating leg 2. Value='<xsl:value-of select="fpml:calculationPeriodsScheduleReference/@href"/>'.</text></error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:calculationPeriodsSchedule">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:commodity">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="($commodityCategory = 'Freight') and fpml:commodity/fpml:multiplier and (fpml:notionalQuantity/fpml:quantityFrequency='PerCalendarDay') and not(fpml:notionalQuantity/fpml:quantity = 1)">
<error><context><xsl:value-of select="$newContext"/></context><text>*** notionalQuantity/quantity must equal 1 when notionalQuantity/quantityFrequency is set to 'PerCalendarDay'.</text></error>
</xsl:if>
<xsl:if test="fpml:notionalQuantity and $commodityCategory='Electricity'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected notionalQuantity element encountered in this context.</text></error>
</xsl:if>
<xsl:apply-templates select="fpml:notionalQuantity">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:settlementPeriodsNotionalQuantity and not(count(fpml:settlementPeriodsNotionalQuantity) = 1)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Only one settlementPeriodsNotionalQuantity element must be present.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:settlementPeriodsNotionalQuantity">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:notionalQuantitySchedule">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="($commodityCategory = 'Freight') and (fpml:totalNotionalQuantity) and (//fpml:floatingLeg/fpml:commodity/fpml:multiplier)">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected totalNotionalQuantity element in this context when floating leg has a multiplier element.</text></error>
</xsl:if>
<xsl:if test="fpml:totalNotionalQuantity">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">totalNotionalQuantity</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:totalNotionalQuantity"/></xsl:with-param>
<xsl:with-param name="minIncl">0.001</xsl:with-param>
<xsl:with-param name="maxIncl">999999999999.999</xsl:with-param>
<xsl:with-param name="maxDecs">3</xsl:with-param>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:apply-templates select="fpml:calculation">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:paymentDates">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected paymentDates element encountered in this context.</text></error>
</xsl:if>
<xsl:apply-templates select="fpml:relativePaymentDates">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:flatRate">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected flatRate element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:flatRateAmount">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected flatRateAmount element encountered in this context.</text></error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:calculationPeriodsSchedule">
<xsl:param name="context"/><xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="$productType='Commodity Swap' and not(./@id='floatingLegCalculationPeriods')">
<error><context><xsl:value-of select="$newContext"/></context><text>*** calculationPeriodsSchedule/@id must be set to 'floatingLegCalculationPeriods' when product type is 'Commodity Swap'. Value='<xsl:value-of select="./@id"/>'.</text></error>
</xsl:if>
<xsl:if test="$productType='Commodity Spread' and ancestor::fpml:floatingLeg[@id='floatingLeg1'] and not(./@id='floatingLeg1CalculationPeriods')">
<error><context><xsl:value-of select="$newContext"/></context><text>*** calculationPeriodsSchedule/@id must be set to 'floatingLeg1CalculationPeriods' on leg 1 of a Commodity Spread. Value='<xsl:value-of select="./@id"/>'.</text></error>
</xsl:if>
<xsl:if test="$productType='Commodity Spread' and ancestor::fpml:floatingLeg[@id='floatingLeg2'] and not(./@id='floatingLeg2CalculationPeriods')">
<error><context><xsl:value-of select="$newContext"/></context><text>*** calculationPeriodsSchedule/@id must be set to 'floatingLeg2CalculationPeriods' on leg 2 of a Commodity Spread. Value='<xsl:value-of select="./@id"/>'.</text></error>
</xsl:if>
<xsl:if test="$productType='Commodity Spread' and ancestor::fpml:floatingLeg[@id='floatingLeg2'] and not(fpml:balanceOfFirstPeriod=../../fpml:floatingLeg[@id='floatingLeg1']/fpml:calculationPeriodsSchedule/fpml:balanceOfFirstPeriod)">
<error><context><xsl:value-of select="$newContext"/></context><text>*** balanceOfFirstPeriod must be set to the same value on both legs a Commodity Spread. Value='<xsl:value-of select="fpml:balanceOfFirstPeriod"/>'.</text></error>
</xsl:if>
<xsl:if test="$productType='Commodity Option' and not(@id='calculationPeriods')">
<error>
<context><xsl:value-of select="$newContext"/></context>
<text>*** calculationPeriodsSchedule/@id must be set to 'calculationPeriods' for a Commodity Option. Value='<xsl:value-of select="./@id"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not(@id='fixedLegCalculationPeriods') and $productType='Commodity Forward'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** calculationPeriodsSchedule/@id must be set to 'fixedLegCalculationPeriods' for a Commodity Forward. Value = '<xsl:value-of select="../@id"/>'.</text></error>
</xsl:if>
<xsl:if test="not(fpml:periodMultiplier=1) and $productType='Commodity Forward'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** periodMultiplier must be set to 1 for a Commodity Forward. Value = '<xsl:value-of select="fpml:periodMultiplier"/>'.</text></error>
</xsl:if>
<xsl:call-template name="isValidPeriodMultiplier">
<xsl:with-param name="elementName">periodMultiplier</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:periodMultiplier"/></xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
<xsl:if test="not(fpml:period='T') and $productType='Commodity Forward'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** period must be set to 'T' for a Commodity Forward. Value = '<xsl:value-of select="fpml:period"/>'.</text></error>
</xsl:if>
<xsl:call-template name="isValidCalculationPeriod">
<xsl:with-param name="elementName">period</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:period"/></xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
<xsl:if test="fpml:period='T' and not(fpml:periodMultiplier='1')">
<error>
<context><xsl:value-of select="$newContext"/></context>
<text>*** periodMultiplier must be set to '1' when period is set to 'T'. Value='<xsl:value-of select="fpml:periodMultiplier"/>'.</text>
</error>
</xsl:if>
<xsl:if test="$productType='Commodity Option' and fpml:period='T' and not(../fpml:notionalQuantity)">
<error>
<context><xsl:value-of select="$newContext"/></context>
<text>*** notionalQuantity must be present when calculationPeriodsSchedule/period is set to 'T'.</text>
</error>
</xsl:if>
<xsl:if test="$productType='Commodity Option' and not(fpml:period='T') and not(../fpml:notionalQuantitySchedule)">
<error>
<context><xsl:value-of select="$newContext"/></context>
<text>*** notionalQuantitySchedule must be present when calculationPeriodsSchedule/period is not set to 'T'.</text>
</error>
</xsl:if>
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">balanceOfFirstPeriod</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:balanceOfFirstPeriod"/></xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
<xsl:if test="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:swbExtendedTradeDetails/fpml:swbCommoditySwapDetails/fpml:swbBulletIndicator = 'true' and fpml:balanceOfFirstPeriod = 'true' and ($commodityCategory = 'Ags' or $commodityCategory = 'Gas' or $commodityCategory = 'Base' or $commodityCategory = 'Precious' or $commodityCategory = 'Electricity')">
<error><context><xsl:value-of select="$newContext"/></context><text>*** balanceOfFirstPeriod cannot be set to 'true' when swbBulletIndicator is set to 'true'.</text></error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:calculation">
<xsl:param name="context"/><xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:apply-templates select="fpml:pricingDates">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:conversionFactor">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected conversionFactor element encountered in this context.</text></error>
</xsl:if>
<xsl:apply-templates select="fpml:rounding">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="not ($productType = 'Commodity Spread') and fpml:spread">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected spread element encountered in this context. Must not be present unless swbProductType is 'Commodity Spread'.</text></error>
</xsl:if>
<xsl:if test="fpml:spread and $productType = 'Commodity Spread' and not (ancestor::fpml:floatingLeg[@id='floatingLeg2'])">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected spread element encountered in this context. Must only be present if this is floatingLeg2 of the spread trade.</text></error>
</xsl:if>
<xsl:if test="$productType = 'Commodity Spread' and ancestor::fpml:floatingLeg[@id='floatingLeg2'] and not (fpml:spread or fpml:spreadSchedule)">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Missing spread or spreadSchedule element in this context. Required when swbProductType is 'Commodity Spread' and this is floatingLeg2.</text></error>
</xsl:if>
<xsl:if test="fpml:spreadSchedule and not(//fpml:floatingLeg[@id='floatingLeg2']/fpml:notionalQuantitySchedule)">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected spreadSchedule element encountered in this context when floating leg 2 does not have a notionalQuantitySchedule component.</text></error>
</xsl:if>
<xsl:apply-templates select="fpml:spreadSchedule">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="$productType='Commodity Spread' and fpml:spreadStep and ancestor::fpml:floatingLeg[@id='floatingLeg2'] and not(//fpml:floatingLeg[@id='floatingLeg2']/fpml:calculation/fpml:calculationPeriodsScheduleReference/@href='floatingLeg1CalculationPeriods') and ancestor::fpml:floatingLeg[@id='floatingLeg2']/fpml:calculationPeriodsScheduleReference">
<error><context><xsl:value-of select="$newContext"/></context><text>*** calculationPeriodsScheduleReference/@href must be set to 'floatingLeg1CalculationPeriods'  on leg 2 of a Commodity Spread when no separate calculationPeriodsSchedule has been specified on this leg. Value='<xsl:value-of select="fpml:calculationPeriodsScheduleReference/@href"/>'.</text></error>
</xsl:if>
<xsl:if test="$productType='Commodity Spread' and fpml:spreadStep and ancestor::fpml:floatingLeg[@id='floatingLeg2'] and not(//fpml:floatingLeg[@id='floatingLeg2']/fpml:calculation/fpml:calculationPeriodsScheduleReference/@href='floatingLeg2CalculationPeriods') and ancestor::fpml:floatingLeg[@id='floatingLeg2']/fpml:calculationPeriodsSchedule">
<error><context><xsl:value-of select="$newContext"/></context><text>*** calculationPeriodsScheduleReference/@href must be set to 'floatingLeg2CalculationPeriods'  on leg 2 of a Commodity Spread when a separate calculationPeriodsSchedule has been specified on this leg. Value='<xsl:value-of select="fpml:calculationPeriodsScheduleReference/@href"/>'.</text></error>
</xsl:if>
<xsl:apply-templates select="fpml:spread|fpml:spreadStep">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:fx">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected fx element encountered in this context.</text></error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:spreadSchedule">
<xsl:param name="context"/><xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="count(fpml:spreadStep) &lt; 2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** spreadSchedule must contain more than one spreadStep.</text>
</error>
</xsl:if>
<xsl:if test="fpml:spreadStep[1]/fpml:currency != fpml:spreadStep/fpml:currency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** currency must be the same in every spreadStep element.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:calculationPeriodsScheduleReference)">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Missing calculationPeriodsScheduleReference element.</text></error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:pricingDates">
<xsl:param name="context"/><xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="fpml:calculationPeriodsReference">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected calculationPeriodsReference element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="$productType='Commodity Swap' and not(fpml:calculationPeriodsScheduleReference[@href='floatingLegCalculationPeriods'])">
<error><context><xsl:value-of select="$newContext"/></context><text>*** calculationPeriodsScheduleReference/@href must be set to 'floatingLegCalculationPeriods' when product type is 'Commodity Swap'. Value='<xsl:value-of select="fpml:calculationPeriodsScheduleReference/@href"/>'.</text></error>
</xsl:if>
<xsl:if test="$productType='Commodity Option' and not(fpml:calculationPeriodsScheduleReference[@href='calculationPeriods'])">
<error><context><xsl:value-of select="$newContext"/></context><text>*** calculationPeriodsScheduleReference/@href must be set to 'calculationPeriods' when product type is 'Commodity Option'. Value='<xsl:value-of select="fpml:calculationPeriodsScheduleReference/@href"/>'.</text></error>
</xsl:if>
<xsl:if test="$productType='Commodity Spread' and ancestor::fpml:floatingLeg[@id='floatingLeg1'] and not(fpml:calculationPeriodsScheduleReference[@href='floatingLeg1CalculationPeriods'])">
<error><context><xsl:value-of select="$newContext"/></context><text>*** calculationPeriodsScheduleReference/@href must be set to 'floatingLeg1CalculationPeriods' on leg 1 of a Commodity Spread. Value='<xsl:value-of select="fpml:calculationPeriodsScheduleReference/@href"/>'.</text></error>
</xsl:if>
<xsl:if test="$productType='Commodity Spread' and ancestor::fpml:floatingLeg[@id='floatingLeg2']">
<xsl:choose>
<xsl:when test="not( ancestor::fpml:floatingLeg[@id='floatingLeg2']/fpml:calculationPeriodsSchedule) and not (fpml:calculationPeriodsScheduleReference[@href='floatingLeg1CalculationPeriods'])">
<error><context><xsl:value-of select="$newContext"/></context><text>*** calculationPeriodsScheduleReference/@href must be set to 'floatingLeg1CalculationPeriods' on leg 2 of a Commodity Spread when there is no calculationPeriodsSchedule defined on this leg. Value='<xsl:value-of select="fpml:calculationPeriodsScheduleReference/@href"/>'.</text></error>
</xsl:when>
<xsl:when test="ancestor::fpml:floatingLeg[@id='floatingLeg2']/fpml:calculationPeriodsSchedule and not (fpml:calculationPeriodsScheduleReference[@href='floatingLeg2CalculationPeriods'])">
<error><context><xsl:value-of select="$newContext"/></context><text>*** calculationPeriodsScheduleReference/@href must be set to 'floatingLeg2CalculationPeriods' on leg 2 of a Commodity Spread when there is a calculationPeriodsSchedule defined on this leg. Value='<xsl:value-of select="fpml:calculationPeriodsScheduleReference/@href"/>'.</text></error>
</xsl:when>
</xsl:choose>
</xsl:if>
<xsl:if test="fpml:businessCalendar">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected businessCalendar element encountered in this context.</text></error>
</xsl:if>
<xsl:apply-templates select="fpml:lag">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:pricingDates">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected pricingDates element in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:dayOfWeek">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected dayOfWeek element in this context.</text></error>
</xsl:if>
<xsl:if test="not($commodityCategory = 'Electricity')">
<xsl:call-template name="isValidPricingDayType">
<xsl:with-param name="elementName">dayType</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:dayType"/></xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="not($commodityCategory = 'Electricity')">
<xsl:call-template name="isValidFrequencyType">
<xsl:with-param name="elementName">dayDistribution</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:dayDistribution"/></xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:dayCount">
<xsl:call-template name="isValidIntegerNumber">
<xsl:with-param name="elementName">dayCount</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:dayCount"/></xsl:with-param>
<xsl:with-param name="minIncl">1</xsl:with-param>
<xsl:with-param name="maxIncl">99</xsl:with-param>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:lag">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="fpml:firstObservationDateOffset and not(fpml:firstObservationDateOffset/fpml:periodMultiplier >= fpml:lagDuration/fpml:periodMultiplier)">
<error><context><xsl:value-of select="$newContext"/></context><text>*** firstObservationDateOffset/periodMultiplier must be greater than or equal to lagDuration/periodMultiplier.</text></error>
</xsl:if>
<xsl:apply-templates select="fpml:lagDuration">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:firstObservationDateOffset">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:lagDuration|fpml:firstObservationDateOffset">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:call-template name="isValidIntegerNumber">
<xsl:with-param name="elementName">periodMultiplier</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:periodMultiplier"/></xsl:with-param>
<xsl:with-param name="minIncl">1</xsl:with-param>
<xsl:with-param name="maxIncl">99</xsl:with-param>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
<xsl:if test="fpml:period != 'M'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Invalid value for period in this context. Must be equal to 'M' Value = '<xsl:value-of select="fpml:period"/>'..</text></error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:rounding">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="fpml:roundingDirection != 'Nearest'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Invalid value for roundingDirection encountered in this context. Must be equal to 'Nearest'. Value = '<xsl:value-of select="fpml:roundingDirection"/>'.</text></error>
</xsl:if>
<xsl:call-template name="isValidIntegerNumber">
<xsl:with-param name="elementName">precision</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:precision"/></xsl:with-param>
<xsl:with-param name="minIncl">1</xsl:with-param>
<xsl:with-param name="maxIncl">10</xsl:with-param>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
</xsl:template>
<xsl:template match="fpml:spread|fpml:spreadStep">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:call-template name="isValidCurrency">
<xsl:with-param name="elementName">currency</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:currency"/></xsl:with-param>
<xsl:with-param name="commodityCategory"><xsl:value-of select="$commodityCategory"/></xsl:with-param>
<xsl:with-param name="productType"><xsl:value-of select="$productType"/></xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">amount</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:amount"/></xsl:with-param>
<xsl:with-param name="minIncl">-99999999.9999999</xsl:with-param>
<xsl:with-param name="maxIncl">99999999.9999999</xsl:with-param>
<xsl:with-param name="maxDecs">7</xsl:with-param>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
</xsl:template>
<xsl:template match="fpml:notionalQuantitySchedule">
<xsl:param name="context"/><xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="$productType='Commodity Option' and not(/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:commodityOption/fpml:strikePricePerUnitSchedule)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** strikePricePerUnitShedule must be present when notionalQuantitySchedule is present when productType is 'Commodity Option'.</text>
</error>
</xsl:if>
<xsl:if test="$productType='Commodity Option' and (count(fpml:notionalStep) != count(/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:commodityOption/fpml:strikePricePerUnitSchedule/fpml:strikePricePerUnitStep))">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** notionalQuantitySchedule must contain the same number of notionalStep elements as strikePircePerUnitSchedule contains strikePricePerUnitStep elements when productType is 'Commodity Option'.</text>
</error>
</xsl:if>
<xsl:if test="$commodityCategory='Electricity' and fpml:notionalStep">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected notionalStep in this context (settlementPeriodsNotionalQuantityStep within settlementPeriodsNotionalQuantitySchedule should be used instead for power).</text></error>
</xsl:if>
<xsl:if test="not(count(fpml:settlementPeriodsNotionalQuantitySchedule) = 1) and $commodityCategory='Electricity'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Only one settlementPeriodsNotionalQuantitySchedule element must be present.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:settlementPeriodsNotionalQuantitySchedule">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="$productType='Commodity Swap' and (count(fpml:notionalStep) != count(/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:commoditySwap/fpml:fixedLeg/fpml:fixedPriceSchedule/fpml:worldscaleRateStep|/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:commoditySwap/fpml:fixedLeg/fpml:fixedPriceSchedule/fpml:fixedPriceStep|/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:commoditySwap/fpml:fixedLeg/fpml:fixedPriceSchedule/fpml:contractRateStep)) and  not($commodityCategory='Electricity')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** notionalQuantitySchedule and fixedPriceSchedule must contain the same number of steps when productType is 'Commodity Swap'.</text>
</error>
</xsl:if>
<xsl:if test="$productType='Commodity Spread' and ../@id='floatingLeg2' and (count(fpml:notionalStep) != count(/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:commoditySwap/fpml:floatingLeg[@id='floatingLeg2']/fpml:calculation/fpml:spreadSchedule/fpml:spreadStep))">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** notionalQuantitySchedule must contain the same number of steps as there are spreadStep elements when productType is 'Commodity Spread'.</text>
</error>
</xsl:if>
<xsl:if test="(count(fpml:notionalStep) &lt; 2) and not($commodityCategory='Electricity')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** notionalQuantitySchedule must contain more than one notionalStep element.</text>
</error>
</xsl:if>
<xsl:if test="fpml:notionalStep[1]/fpml:quantityUnit != fpml:notionalStep/fpml:quantityUnit">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** quantityUnit must be the same in every notionalStep element.</text>
</error>
</xsl:if>
<xsl:if test="fpml:notionalStep[1]/fpml:quantityFrequency != fpml:notionalStep/fpml:quantityFrequency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** quantityFrequency must be the same in every notionalStep element.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:notionalStep">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="$productType='Commodity Option' and not(fpml:calculationPeriodsScheduleReference[@href='calculationPeriods'])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** calculationPeriodsScheduleReference/@href must be set to 'calculationPeriods' when product type is 'Commodity Option'. Value='<xsl:value-of select="calculationPeriodsScheduleReference/@href"/>'.</text>
</error>
</xsl:if>
<xsl:if test="$productType='Commodity Swap' and not(fpml:calculationPeriodsScheduleReference[@href='floatingLegCalculationPeriods'])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** calculationPeriodsScheduleReference/@href must be set to 'floatingLegCalculationPeriods' when product type is 'Commodity Swap'. Value='<xsl:value-of select="calculationPeriodsScheduleReference/@href"/>'.</text>
</error>
</xsl:if>
<xsl:if test="$productType='Commodity Spread' and ancestor::fpml:floatingLeg[@id='floatingLeg2'] and not(fpml:calculationPeriodsScheduleReference/@href='floatingLeg1CalculationPeriods') and ancestor::fpml:floatingLeg[@id='floatingLeg2']/fpml:calculationPeriodsScheduleReference">
<error><context><xsl:value-of select="$newContext"/></context><text>*** calculationPeriodsScheduleReference/@href must be set to 'floatingLeg1CalculationPeriods'  on leg 2 of a Commodity Spread when no separate calculationPeriodsSchedule has been specified on this leg. Value='<xsl:value-of select="fpml:calculationPeriodsScheduleReference/@href"/>'.</text></error>
</xsl:if>
<xsl:if test="$productType='Commodity Spread' and ancestor::fpml:floatingLeg[@id='floatingLeg2'] and not(fpml:calculationPeriodsScheduleReference/@href='floatingLeg2CalculationPeriods') and ancestor::fpml:floatingLeg[@id='floatingLeg2']/fpml:calculationPeriodsSchedule">
<error><context><xsl:value-of select="$newContext"/></context><text>*** calculationPeriodsScheduleReference/@href must be set to 'floatingLeg2CalculationPeriods'  on leg 2 of a Commodity Spread when a separate calculationPeriodsSchedule has been specified on this leg. Value='<xsl:value-of select="fpml:calculationPeriodsScheduleReference/@href"/>'.</text></error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:settlementPeriodsNotionalQuantitySchedule">
<xsl:param name="context"/><xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="$productType='Commodity Swap' and (count(fpml:settlementPeriodsNotionalQuantityStep) != count(/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:commoditySwap/fpml:fixedLeg/fpml:fixedPriceSchedule/fpml:settlementPeriodsPriceSchedule/fpml:settlementPeriodsPriceStep))">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** settlementPeriodsNotionalQuantitySchedule and fixedPriceSchedule/settlementPeriodsPriceSchedule must contain the same number of steps.</text>
</error>
</xsl:if>
<xsl:if test="count(fpml:settlementPeriodsNotionalQuantityStep) &lt; 2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** settlementPeriodsNotionalQuantitySchedule must contain more than one settlementPeriodsNotionalQuantityStep element.</text>
</error>
</xsl:if>
<xsl:if test="fpml:settlementPeriodsNotionalQuantityStep[1]/fpml:quantityUnit != fpml:settlementPeriodsNotionalQuantityStep/fpml:quantityUnit">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** quantityUnit must be the same in every settlementPeriodsNotionalQuantityStep element.</text>
</error>
</xsl:if>
<xsl:if test="fpml:settlementPeriodsNotionalQuantityStep[1]/fpml:quantityFrequency != fpml:settlementPeriodsNotionalQuantityStep/fpml:quantityFrequency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** quantityFrequency must be the same in every settlementPeriodsNotionalQuantityStep element.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:settlementPeriodsNotionalQuantityStep">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="not(fpml:settlementPeriodsReference[@href='SWBLoadShape'])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** settlementPeriodsReference/@href must be set to 'SWBLoadShape'. Value='<xsl:value-of select="calculationPeriodsScheduleReference/@href"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not(count(fpml:settlementPeriodsReference) = 1)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Only one settlementPeriodsReference element must be present.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:strikePricePerUnitSchedule">
<xsl:param name="context"/><xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="$productType='Commodity Option' and not(/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:commodityOption/fpml:notionalQuantitySchedule)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** notionalQuantitySchedule must be present when strikePricePerUnitShedule is present.</text>
</error>
</xsl:if>
<xsl:if test="$productType='Commodity Option' and (count(fpml:strikePricePerUnitStep) &lt; 2)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** strikePricePerUnitSchedule must contain more than one strikePricePerUnitStep element.</text>
</error>
</xsl:if>
<xsl:if test="fpml:strikePricePerUnitStep[1]/fpml:currency != fpml:strikePricePerUnitStep/fpml:currency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** currency must be the same in every strikePricePerUnitStep element.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:strikePricePerUnitStep">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="$productType='Commodity Option' and not(fpml:calculationPeriodsScheduleReference[@href='calculationPeriods'])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** calculationPeriodsScheduleReference/@href must be set to 'calculationPeriods' when product type is 'Commodity Option'. Value='<xsl:value-of select="calculationPeriodsScheduleReference/@id"/>'.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:strikePricePerUnitStep|fpml:strikePricePerUnit">
<xsl:param name="context"/><xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:call-template name="isValidCurrency">
<xsl:with-param name="elementName">currency</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:currency"/></xsl:with-param>
<xsl:with-param name="commodityCategory"><xsl:value-of select="$commodityCategory"/></xsl:with-param>
<xsl:with-param name="productType"><xsl:value-of select="$productType"/></xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">amount</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:amount"/></xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">99999999.9999999</xsl:with-param>
<xsl:with-param name="maxDecs">7</xsl:with-param>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
</xsl:template>
<xsl:template match="fpml:premium">
<xsl:param name="context"/><xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="not(fpml:payerPartyReference/@href = /fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:commodityOption/fpml:buyerPartyReference/@href)">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Invalid payerPartyReference/@href attribute value. The payerPartyReference/@href must be equal to //FpML/trade/commodityOption/buyerPartyReference/@href (payer of premium is option buyer).</text></error>
</xsl:if>
<xsl:if test="not(fpml:receiverPartyReference/@href = /fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:commodityOption/fpml:sellerPartyReference/@href)">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Invalid receiverPartyReference/@href attribute value. The receiverPartyReference/@href must be equal to //FpML/trade/commodityOption/sellerPartyReference/@href (receiver of premium is option seller).</text></error>
</xsl:if>
<xsl:call-template name="isValidDate">
<xsl:with-param name="elementName">paymentDate</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:paymentDate/fpml:adjustableDate/fpml:unadjustedDate"/></xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
<xsl:apply-templates select="fpml:paymentAmount">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="$productType='Commodity Option' and not(fpml:premiumPerUnit)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** premiumPerUnit must be present.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:premiumPerUnit">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="$productType='Commodity Option' and (fpml:premiumPerUnit/fpml:currency != fpml:paymentAmount/fpml:currency)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** premiumPerUnit/currency must be equal to paymentAmount/currency.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:premium/fpml:paymentAmount">
<xsl:param name="context"/><xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:call-template name="isValidCurrency">
<xsl:with-param name="elementName">currency</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:currency"/></xsl:with-param>
<xsl:with-param name="commodityCategory"><xsl:value-of select="$commodityCategory"/></xsl:with-param>
<xsl:with-param name="productType"><xsl:value-of select="$productType"/></xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">amount</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:amount"/></xsl:with-param>
<xsl:with-param name="minIncl">0.00</xsl:with-param>
<xsl:with-param name="maxIncl">9999999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">3</xsl:with-param>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
</xsl:template>
<xsl:template match="fpml:premiumPerUnit">
<xsl:param name="context"/><xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:call-template name="isValidCurrency">
<xsl:with-param name="elementName">currency</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:currency"/></xsl:with-param>
<xsl:with-param name="commodityCategory"><xsl:value-of select="$commodityCategory"/></xsl:with-param>
<xsl:with-param name="productType"><xsl:value-of select="$productType"/></xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">amount</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:amount"/></xsl:with-param>
<xsl:with-param name="minIncl">0.0000000</xsl:with-param>
<xsl:with-param name="maxIncl">99999999.9999999</xsl:with-param>
<xsl:with-param name="maxDecs">7</xsl:with-param>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
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
<error><context><xsl:value-of select="$context"/></context><text>*** <xsl:value-of select="$errorText"/></text></error>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template name="isValidBusinessCenter">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> element. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='BEBR'"/>
<xsl:when test="$elementValue='CHZU'"/>
<xsl:when test="$elementValue='CATO'"/>
<xsl:when test="$elementValue='DKCO'"/>
<xsl:when test="$elementValue='EUTA'"/>
<xsl:when test="$elementValue='FRPA'"/>
<xsl:when test="$elementValue='GBLO'"/>
<xsl:when test="$elementValue='JPTO'"/>
<xsl:when test="$elementValue='NOOS'"/>
<xsl:when test="$elementValue='SEST'"/>
<xsl:when test="$elementValue='USNY'"/>
<xsl:when test="$elementValue='ARBA'"/>
<xsl:when test="$elementValue='ATVI'"/>
<xsl:when test="$elementValue='AUME'"/>
<xsl:when test="$elementValue='AUSY'"/>
<xsl:when test="$elementValue='BHMA'"/>
<xsl:when test="$elementValue='BRSP'"/>
<xsl:when test="$elementValue='CAMO'"/>
<xsl:when test="$elementValue='CHGE'"/>
<xsl:when test="$elementValue='CLSA'"/>
<xsl:when test="$elementValue='CNBE'"/>
<xsl:when test="$elementValue='CZPR'"/>
<xsl:when test="$elementValue='DEDU'"/>
<xsl:when test="$elementValue='DEFR'"/>
<xsl:when test="$elementValue='EETA'"/>
<xsl:when test="$elementValue='ESMA'"/>
<xsl:when test="$elementValue='FIHE'"/>
<xsl:when test="$elementValue='GRAT'"/>
<xsl:when test="$elementValue='HKHK'"/>
<xsl:when test="$elementValue='HUBU'"/>
<xsl:when test="$elementValue='IDJA'"/>
<xsl:when test="$elementValue='IEDU'"/>
<xsl:when test="$elementValue='ILTA'"/>
<xsl:when test="$elementValue='INMU'"/>
<xsl:when test="$elementValue='ITMI'"/>
<xsl:when test="$elementValue='ITRO'"/>
<xsl:when test="$elementValue='KRSE'"/>
<xsl:when test="$elementValue='LBBE'"/>
<xsl:when test="$elementValue='LULU'"/>
<xsl:when test="$elementValue='MXMC'"/>
<xsl:when test="$elementValue='MYKL'"/>
<xsl:when test="$elementValue='NLAM'"/>
<xsl:when test="$elementValue='NYFD'"/>
<xsl:when test="$elementValue='NYSE'"/>
<xsl:when test="$elementValue='NZAU'"/>
<xsl:when test="$elementValue='NZWE'"/>
<xsl:when test="$elementValue='OMMU'"/>
<xsl:when test="$elementValue='PAPC'"/>
<xsl:when test="$elementValue='PHMA'"/>
<xsl:when test="$elementValue='PLWA'"/>
<xsl:when test="$elementValue='PTLI'"/>
<xsl:when test="$elementValue='RUMO'"/>
<xsl:when test="$elementValue='SARI'"/>
<xsl:when test="$elementValue='SGSI'"/>
<xsl:when test="$elementValue='SKBR'"/>
<xsl:when test="$elementValue='THBA'"/>
<xsl:when test="$elementValue='TRAN'"/>
<xsl:when test="$elementValue='TWTA'"/>
<xsl:when test="$elementValue='USCH'"/>
<xsl:when test="$elementValue='USGS'"/>
<xsl:when test="$elementValue='USLA'"/>
<xsl:when test="$elementValue='VECA'"/>
<xsl:when test="$elementValue='ZAJO'"/>
<xsl:otherwise>
<error><context><xsl:value-of select="$context"/></context><text>*** <xsl:value-of select="$errorText"/></text></error>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template name="isValidCurrency">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="commodityCategory"/>
<xsl:param name="productType"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid (for a/an <xsl:value-of select="$commodityCategory"/><xsl:text> </xsl:text><xsl:value-of select="$productType"/>) <xsl:value-of select="$elementName"/> element. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='AUD'"/>
<xsl:when test="$elementValue='CAD'"/>
<xsl:when test="$elementValue='CHF'"/>
<xsl:when test="$elementValue='CZK'"/>
<xsl:when test="$elementValue='DKK'"/>
<xsl:when test="$elementValue='EUR'"/>
<xsl:when test="$elementValue='GBP'"/>
<xsl:when test="$elementValue='HKD'"/>
<xsl:when test="$elementValue='JPY'"/>
<xsl:when test="$elementValue='NOK'"/>
<xsl:when test="$elementValue='NZD'"/>
<xsl:when test="$elementValue='PLN' and $commodityCategory='Electricity' and $productType='Commodity Forward'"/>
<xsl:when test="$elementValue='RON' and $commodityCategory='Electricity' and $productType='Commodity Forward'"/>
<xsl:when test="$elementValue='SEK'"/>
<xsl:when test="$elementValue='SGD'"/>
<xsl:when test="$elementValue='USD'"/>
<xsl:when test="$elementValue='ZAR'"/>
<xsl:otherwise>
<error><context><xsl:value-of select="$context"/></context><text>*** <xsl:value-of select="$errorText"/></text></error>
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
<error><context><xsl:value-of select="$context"/></context><text>*** <xsl:value-of select="$errorText"/></text></error>
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
<error><context><xsl:value-of select="$context"/></context><text>*** <xsl:value-of select="$errorText"/></text></error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:otherwise>
<error><context><xsl:value-of select="$context"/></context><text>*** <xsl:value-of select="$errorText"/></text></error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:otherwise>
<error><context><xsl:value-of select="$context"/></context><text>*** <xsl:value-of select="$errorText"/></text></error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:otherwise>
<error><context><xsl:value-of select="$context"/></context><text>*** <xsl:value-of select="$errorText"/></text></error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:otherwise>
<error><context><xsl:value-of select="$context"/></context><text>*** <xsl:value-of select="$errorText"/></text></error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:otherwise>
<error><context><xsl:value-of select="$context"/></context><text>*** <xsl:value-of select="$errorText"/></text></error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:otherwise>
<error><context><xsl:value-of select="$context"/></context><text>*** <xsl:value-of select="$errorText"/></text></error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:otherwise>
<error><context><xsl:value-of select="$context"/></context><text>*** <xsl:value-of select="$errorText"/></text></error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:otherwise>
<error><context><xsl:value-of select="$context"/></context><text>*** <xsl:value-of select="$errorText"/></text></error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:otherwise>
<error><context><xsl:value-of select="$context"/></context><text>*** <xsl:value-of select="$errorText"/></text></error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:otherwise>
<error><context><xsl:value-of select="$context"/></context><text>*** <xsl:value-of select="$errorText"/></text></error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:otherwise>
<error><context><xsl:value-of select="$context"/></context><text>*** <xsl:value-of select="$errorText"/></text></error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:otherwise>
<error><context><xsl:value-of select="$context"/></context><text>*** <xsl:value-of select="$errorText"/></text></error>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template name="isValidFrequencyType">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> element for product type of '<xsl:value-of select="$productType"/>'. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='First'"/>
<xsl:when test="$elementValue='Last'"/>
<xsl:when test="$elementValue='Penultimate'"/>
<xsl:when test="$elementValue='All'"/>
<xsl:otherwise>
<error><context><xsl:value-of select="$context"/></context><text>*** <xsl:value-of select="$errorText"/></text></error>
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
<error><context><xsl:value-of select="$context"/></context><text>*** <xsl:value-of select="$elementName"/> is outside allowable range; minIncl=<xsl:value-of select="$minIncl"/>, maxIncl=<xsl:value-of select="$maxIncl"/>. Value = '<xsl:value-of select="$elementValue"/>'.</text></error>
</xsl:if>
</xsl:when>
<xsl:otherwise>
<error><context><xsl:value-of select="$context"/></context><text>*** <xsl:value-of select="$elementName"/> is not a valid integer number. Value = '<xsl:value-of select="$elementValue"/>'.</text></error>
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
<error><context><xsl:value-of select="$context"/></context><text>*** <xsl:value-of select="$elementName"/> is outside allowable range; minIncl=<xsl:value-of select="$minIncl"/>, maxIncl=<xsl:value-of select="$maxIncl"/>. Value = '<xsl:value-of select="$elementValue"/>'.</text></error>
</xsl:if>
</xsl:when>
<xsl:otherwise>
<error><context><xsl:value-of select="$context"/></context><text>*** <xsl:value-of select="$elementName"/> is not a valid number. Value = '<xsl:value-of select="$elementValue"/>'.</text></error>
</xsl:otherwise>
</xsl:choose>
<xsl:if test="string-length(substring-after($elementValue,'.')) &gt; $maxDecs">
<error><context><xsl:value-of select="$context"/></context><text>*** <xsl:value-of select="$elementName"/> has too many decimal places; maxDecs=<xsl:value-of select="$maxDecs"/>. Value = '<xsl:value-of select="$elementValue"/>'.</text></error>
</xsl:if>
</xsl:template>
<xsl:template name="isValidPaymentDayType">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> element. Value='<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='Business'"/>
<xsl:when test="$elementValue='Calendar'"/>
<xsl:otherwise>
<error><context><xsl:value-of select="$context"/></context><text>*** <xsl:value-of select="$errorText"/></text></error>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template name="isValidPeriod">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> element for product type of '<xsl:value-of select="$productType"/>'. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='D'"/>
<xsl:when test="$elementValue='M'"/>
<xsl:when test="$elementValue='Y'"/>
<xsl:when test="$elementValue='T'"/>
<xsl:otherwise>
<error><context><xsl:value-of select="$context"/></context><text>*** <xsl:value-of select="$errorText"/></text></error>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template name="isValidCalculationPeriod">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> element for product type of '<xsl:value-of select="$productType"/>'. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='M'"/>
<xsl:when test="$elementValue='Y'"/>
<xsl:when test="$elementValue='T'"/>
<xsl:otherwise>
<error><context><xsl:value-of select="$context"/></context><text>*** <xsl:value-of select="$errorText"/></text></error>
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
<error><context><xsl:value-of select="$context"/></context><text>*** <xsl:value-of select="$errorText"/></text></error>
</xsl:if>
</xsl:when>
<xsl:otherwise>
<error><context><xsl:value-of select="$context"/></context><text>*** <xsl:value-of select="$errorText"/></text></error>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template name="isValidPhysicalDeliveryBusinessCenter">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> element. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='BANK OF ENGLAND-GOLD'"/>
<xsl:when test="$elementValue='INCO ACTON POOL-RHODIUM (SPONGE)'"/>
<xsl:when test="$elementValue='JM PENNSYLVANIA POOL-RHODIUM (SPONGE)'"/>
<xsl:when test="$elementValue='JM UK POOL-RHODIUM (SPONGE)'"/>
<xsl:when test="$elementValue='LONDON-GOLD'"/>
<xsl:when test="$elementValue='LONDON-SILVER'"/>
<xsl:when test="$elementValue='ZURICH-GOLD'"/>
<xsl:when test="$elementValue='ZURICH-PALLADIUM'"/>
<xsl:when test="$elementValue='ZURICH-PLATINUM'"/>
<xsl:otherwise>
<error><context><xsl:value-of select="$context"/></context><text>*** <xsl:value-of select="$errorText"/></text></error>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template name="isValidPricingDayType">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> element. Value='<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='CommodityBusiness'"/>
<xsl:when test="$elementValue='ScheduledTradingDay'"/>
<xsl:otherwise>
<error><context><xsl:value-of select="$context"/></context><text>*** <xsl:value-of select="$errorText"/></text></error>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template name="isValidProductType">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> element when SWBML version = "<xsl:value-of select="$version"/>". Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:if test="$version='4-6'">
<xsl:choose>
<xsl:when test="$elementValue='Commodity Forward'"/>
<xsl:when test="$elementValue='Commodity Swap'"/>
<xsl:when test="$elementValue='Commodity Spread'"/>
<xsl:when test="$elementValue='Commodity Option'"/>
<xsl:otherwise>
<error><context><xsl:value-of select="$context"/></context><text>*** <xsl:value-of select="$errorText"/></text></error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:template>
<xsl:template name="isValidQuantityFrequency">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> element. Value='<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='PerCalculationPeriod'"/>
<xsl:when test="$elementValue='PerCalendarDay'"/>
<xsl:when test="$elementValue='Term'"/>
<xsl:when test="$elementValue='PerSettlementPeriod'"/>
<xsl:when test="$elementValue='PerHour'"/>
<xsl:otherwise>
<error><context><xsl:value-of select="$context"/></context><text>*** <xsl:value-of select="$errorText"/></text></error>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template name="isValidUnit">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="commodityCategory"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid (for <xsl:value-of select="$commodityCategory"/>) <xsl:value-of select="$elementName"/> element when product type is '<xsl:value-of select="$productType"/>'. Value='<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='BBL'"/>
<xsl:when test="$elementValue='CBU'"/>
<xsl:when test="$elementValue='GAL'"/>
<xsl:when test="$elementValue='hL'"/>
<xsl:when test="$elementValue='KG'"/>
<xsl:when test="$elementValue='kL'"/>
<xsl:when test="$elementValue='LB'"/>
<xsl:when test="$elementValue='MT'"/>
<xsl:when test="$elementValue='OBU'"/>
<xsl:when test="$elementValue='ozt'"/>
<xsl:when test="$elementValue='SBU'"/>
<xsl:when test="$elementValue='t'"/>
<xsl:when test="$elementValue='WBU'"/>
<xsl:when test="$elementValue='MMBTU'"/>
<xsl:when test="$elementValue='g'"/>
<xsl:when test="$elementValue='GJ'"/>
<xsl:when test="$elementValue='Therm'"/>
<xsl:when test="$elementValue='Day' and ($commodityCategory='Freight')"/>
<xsl:when test="$elementValue='MW'"/>
<xsl:when test="$elementValue='KW'"/>
<xsl:otherwise>
<error><context><xsl:value-of select="$context"/></context><text>*** <xsl:value-of select="$errorText"/></text></error>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template name="isValidOptionType">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> element. Value='<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='Call'"/>
<xsl:when test="$elementValue='Put'"/>
<xsl:otherwise>
<error><context><xsl:value-of select="$context"/></context><text>*** <xsl:value-of select="$errorText"/></text></error>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
</xsl:stylesheet>
