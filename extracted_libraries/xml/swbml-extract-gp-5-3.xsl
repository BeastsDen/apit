<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fpml="http://www.fpml.org/FpML-5/confirmation" xmlns:swml="http://www.markitserv.com/swml" xmlns:tx="http://www.markitserv.com/detail/SWDMLTrade.xsl" xmlns:common="http://exslt.org/common" exclude-result-prefixes="fpml common">
<xsl:import href="Trade.xsl"/>
<xsl:import href="swbml-extract-reporting.xsl"/>
<xsl:output method="xml" indent="yes"/>
<xsl:variable name="SWBML"                     select="/swml:SWBML"/>
<xsl:variable name="swbHeader"                 select="$SWBML/swml:swbHeader"/>
<xsl:variable name="isPrimeBrokered">
<xsl:choose>
<xsl:when test="$SWBML/swml:swbGiveUp">1</xsl:when>
<xsl:otherwise>0</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="swbGiveUp"                 select="$SWBML/swml:swbGiveUp"/>
<xsl:variable name="swStructuredTradeDetails"  select="$SWBML/swml:swStructuredTradeDetails"/>
<xsl:variable name="swbBusinessConductDetails" select="$swStructuredTradeDetails/swml:swbBusinessConductDetails"/>
<xsl:variable name="dataDocument"              select="$swStructuredTradeDetails/fpml:dataDocument"/>
<xsl:variable name="trade"                     select="$dataDocument/fpml:trade"/>
<xsl:variable name="swGenericProduct"          select="$trade/swml:swGenericProduct"/>
<xsl:variable name="swExtendedTradeDetails"    select="$swStructuredTradeDetails/swml:swExtendedTradeDetails"/>
<xsl:variable name="swTradeHeader"             select="$swExtendedTradeDetails/swml:swTradeHeader"/>
<xsl:variable name="swbMandatoryClearing"      select="$swTradeHeader/swml:swbMandatoryClearing"/>
<xsl:variable name="premium"                   select="$swGenericProduct/fpml:premium"/>
<xsl:variable name="partyA">
<xsl:choose>
<xsl:when test="/swml:SWBML/swml:swbGiveUp">
<xsl:value-of select="/swml:SWBML//swml:swbInterDealerTransaction/swml:swbExecutingDealer/@href"/>
</xsl:when>
<xsl:when test="swml:SWBML/swml:swbStructuredTradeDetails/swml:swbExtendedTradeDetails/swml:swbTradeHeader/swml:swbExecutingBroker">
<xsl:value-of select="/swml:SWBML/swml:swbStructuredTradeDetails/swml:swbExtendedTradeDetails/swml:swbTradeHeader/swml:swbExecutingBroker/@href"/>
</xsl:when>
<xsl:otherwise>partyA</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="partyB">
<xsl:choose>
<xsl:when test="/swml:SWBML/swml:swbGiveUp">
<xsl:value-of select="/swml:SWBML//swml:swbCustomerTransaction/swml:swbCustomer/@href"/>
</xsl:when>
<xsl:when test="swml:SWBML/swml:swbStructuredTradeDetails/swml:swbExtendedTradeDetails/swml:swbTradeHeader/swml:swbClearingClient">
<xsl:value-of select="/swml:SWBML/swml:swbStructuredTradeDetails/swml:swbExtendedTradeDetails/swml:swbTradeHeader/swml:swbClearingClient/@href"/>
</xsl:when>
<xsl:otherwise>partyB</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="partyC"/>
<xsl:variable name="partyD"/>
<xsl:variable name="reportingData.rtf">
<xsl:apply-templates select="/swml:SWBML/swml:swbTradeEventReportingDetails/node()" mode="mapReportingData"/>
</xsl:variable>
<xsl:variable name="brokerPrivateData.rtf">
<xsl:variable name="broker1">
<xsl:choose>
<xsl:when test="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:otherPartyPayment[1]/fpml:receiverPartyReference">
<xsl:value-of select="substring-after(/SWBML/swbStructuredTradeDetails/FpML/trade/otherPartyPayment[1]/receiverPartyReference/@href,'#')"/>
</xsl:when>
<xsl:otherwise>broker1</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="broker2">
<xsl:choose>
<xsl:when test="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:otherPartyPayment[2]/fpml:receiverPartyReference">
<xsl:value-of select="substring-after(/SWBML/swbStructuredTradeDetails/FpML/trade/otherPartyPayment[2]/receiverPartyReference/@href,'#')"/>
</xsl:when>
<xsl:otherwise>broker2</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:choose>
<xsl:when test="/fpml:SWBML/fpml:swbPrivatePartyTradeEventReportingDetails[fpml:swbPartyReference/@href=$broker1]">
<xsl:apply-templates select="/fpml:SWBML/fpml:swbPrivatePartyTradeEventReportingDetails[fpml:swbPartyReference/@href=$broker1]/node()" mode="mapReportingData"/>
</xsl:when>
<xsl:when test="/fpml:SWBML/fpml:swbPrivatePartyTradeEventReportingDetails[fpml:swbPartyReference/@href=$broker2]">
<xsl:apply-templates select="/fpml:SWBML/fpml:swbPrivatePartyTradeEventReportingDetails[fpml:swbPartyReference/@href=$broker2]/node()" mode="mapReportingData"/>
</xsl:when>
<xsl:when test="/swml:SWBML/swml:swbPrivatePartyTradeEventReportingDetails[swml:swbPartyReference/@href='broker']">
<xsl:apply-templates select="/swml:SWBML/swml:swbPrivatePartyTradeEventReportingDetails[swml:swbPartyReference/@href='broker']/node()" mode="mapReportingData"/>
</xsl:when>
<xsl:otherwise>
<xsl:apply-templates select="/swml:SWBML/swml:swbPrivatePartyTradeEventReportingDetails/node()" mode="mapReportingData"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="partyAPrivateData.rtf">
<xsl:choose>
<xsl:when test="/swml:SWBML/swml:swbPrivatePartyTradeEventReportingDetails[swml:swbPartyReference/@href=$partyA]">
<xsl:apply-templates select="/swml:SWBML/swml:swbPrivatePartyTradeEventReportingDetails[swml:swbPartyReference/@href=$partyA]/node()" mode="mapReportingData"/>
</xsl:when>
<xsl:otherwise>
<xsl:apply-templates select="/swml:SWBML/swml:swbPrivatePartyTradeEventReportingDetails/node()" mode="mapReportingData"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="partyBPrivateData.rtf">
<xsl:choose>
<xsl:when test="/swml:SWBML/swml:swbGiveUp">
<xsl:choose>
<xsl:when test="/swml:SWBML/swml:swbPrivatePartyTradeEventReportingDetails[swml:swbPartyReference/@href=$partyC]">
<xsl:apply-templates select="/swml:SWBML/swml:swbPrivatePartyTradeEventReportingDetails[swml:swbPartyReference/@href=$partyC]/node()" mode="mapReportingData"/>
</xsl:when>
<xsl:otherwise>
<xsl:apply-templates select="/swml:SWBML/swml:swbPrivatePartyTradeEventReportingDetails/node()" mode="mapReportingData"/>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:otherwise>
<xsl:choose>
<xsl:when test="/swml:SWBML/swml:swbPrivatePartyTradeEventReportingDetails[swml:swbPartyReference/@href=$partyB]">
<xsl:apply-templates select="/swml:SWBML/swml:swbPrivatePartyTradeEventReportingDetails[swml:swbPartyReference/@href=$partyB]/node()" mode="mapReportingData"/>
</xsl:when>
<xsl:otherwise>
<xsl:apply-templates select="/swml:SWBML/swml:swbPrivatePartyTradeEventReportingDetails/node()" mode="mapReportingData"/>
</xsl:otherwise>
</xsl:choose>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="brokerPBPrivateData.rtf">
<xsl:choose>
<xsl:when test="/swml:SWBML/swml:swbPrivatePartyTradeEventReportingDetails/swml:swbPBClientTradePrivateReportingDetails[swml:swbPartyReference/@href='broker']">
<xsl:apply-templates select="/swml:SWBML/swml:swbPrivatePartyTradeEventReportingDetails/swml:swbPBClientTradePrivateReportingDetails[swml:swbPartyReference/@href='broker']/node()" mode="mapReportingData"/>
</xsl:when>
<xsl:otherwise>
<xsl:apply-templates select="/swml:SWBML/swml:swbPrivatePartyTradeEventReportingDetails/swml:swbPBClientTradePrivateReportingDetails/node()" mode="mapReportingData"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="pbPrivateData.rtf">
<xsl:choose>
<xsl:when test="/swml:SWBML/swml:swbPrivatePartyTradeEventReportingDetails/swml:swbPBClientTradePrivateReportingDetails[swml:swbPartyReference/@href=$partyC]">
<xsl:apply-templates select="/swml:SWBML/swml:swbPrivatePartyTradeEventReportingDetails/swml:swbPBClientTradePrivateReportingDetails[swml:swbPartyReference/@href=$partyC]/node()" mode="mapReportingData"/>
</xsl:when>
<xsl:otherwise>
<xsl:apply-templates select="/swml:SWBML/swml:swbPrivatePartyTradeEventReportingDetails/swml:swbPBClientTradePrivateReportingDetails/node()" mode="mapReportingData"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="clientPrivateData.rtf">
<xsl:choose>
<xsl:when test="/swml:SWBML/swml:swbPrivatePartyTradeEventReportingDetails/swml:swbPBClientTradePrivateReportingDetails[swml:swbPartyReference/@href=$partyB]">
<xsl:apply-templates select="/swml:SWBML/swml:swbPrivatePartyTradeEventReportingDetails/swml:swbPBClientTradePrivateReportingDetails[swml:swbPartyReference/@href=$partyB]/node()" mode="mapReportingData"/>
</xsl:when>
<xsl:otherwise>
<xsl:apply-templates select="/swml:SWBML/swml:swbPrivatePartyTradeEventReportingDetails/swml:swbPBClientTradePrivateReportingDetails/node()" mode="mapReportingData"/>
</xsl:otherwise>
</xsl:choose>
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
<xsl:apply-templates select="swml:SWBML" mode="get-reporting-data"/>
</xsl:template>
<xsl:template match="/swml:SWBML[function-available('common:node-set')]" mode="get-reporting-data">
<xsl:apply-templates select=".">
<xsl:with-param name="reportingData" select="common:node-set($reportingData.rtf)"/>
<xsl:with-param name="brokerPrivateData" select="common:node-set($brokerPrivateData.rtf)"/>
<xsl:with-param name="partyAPrivateData" select="common:node-set($partyAPrivateData.rtf)"/>
<xsl:with-param name="partyBPrivateData" select="common:node-set($partyBPrivateData.rtf)"/>
<xsl:with-param name="brokerPBPrivateData" select="common:node-set($brokerPBPrivateData.rtf)"/>
<xsl:with-param name="pbPrivateData" select="common:node-set($pbPrivateData.rtf)"/>
<xsl:with-param name="clientPrivateData" select="common:node-set($clientPrivateData.rtf)"/>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="/swml:SWBML[not(function-available('common:node-set'))]" mode="get-reporting-data">
<xsl:apply-templates select=".">
<xsl:with-param name="reportingData" select="$reportingData.rtf"/>
<xsl:with-param name="brokerPrivateData" select="$brokerPrivateData.rtf"/>
<xsl:with-param name="partyAPrivateData" select="$partyAPrivateData.rtf"/>
<xsl:with-param name="partyBPrivateData" select="$partyBPrivateData.rtf"/>
<xsl:with-param name="brokerPBPrivateData" select="$brokerPBPrivateData.rtf"/>
<xsl:with-param name="pbPrivateData" select="$pbPrivateData.rtf"/>
<xsl:with-param name="clientPrivateData" select="$clientPrivateData.rtf"/>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="swml:SWBML">
<xsl:param name="reportingData" select="node()"/>
<xsl:param name="brokerPrivateData" select="node()"/>
<xsl:param name="partyAPrivateData" select="node()"/>
<xsl:param name="partyBPrivateData" select="node()"/>
<xsl:param name="brokerPBPrivateData"/>
<xsl:param name="pbPrivateData"/>
<xsl:param name="clientPrivateData"/>
<xsl:call-template name="tx:Trade">
<xsl:with-param name="SWBMLVersion" select="$SWBML/@version"/>
<xsl:with-param name="version" select="'5-3'"/>
<xsl:with-param name="ProductType" select="'Generic Product'"/>
<xsl:with-param name="BrokerSubmitted" select="'true'"/>
<xsl:with-param name="BrokerTradeId" select="$swbHeader/swml:swbBrokerTradeId"/>
<xsl:with-param name="BrokerLegId" select="$swbHeader/fpml:swbBrokerLegId"/>
<xsl:with-param name="ReplacementTradeId" select="$swbHeader/swml:swbReplacementTradeId/swml:swbTradeId"/>
<xsl:with-param name="ReplacementTradeIdType" select="$swbHeader/swml:swbReplacementTradeId/swml:swbTradeIdType"/>
<xsl:with-param name="ReplacementReason" select="$swbHeader/swml:swbReplacementTradeId/swml:swbReplacementReason"/>
<xsl:with-param name="BrokerTradeVersionId" select="$swbHeader/swml:swbBrokerTradeVersionId"/>
<xsl:with-param name="StrategyType" select="$swbHeader/swml:swbStrategyType"/>
<xsl:with-param name="TradeSource">
<xsl:choose>
<xsl:when test="$swbHeader/swml:swbTradeSource">
<xsl:value-of select="$swbHeader/swml:swbTradeSource"/>
</xsl:when>
<xsl:otherwise>Voice</xsl:otherwise>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="VenueId">
<xsl:choose>
<xsl:when test="$swbHeader/swml:swbVenueId">
<xsl:value-of select="$swbHeader/swml:swbVenueId"/>
</xsl:when>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="VenueIdScheme">
<xsl:choose>
<xsl:when test="$swbHeader/swml:swbVenueId/@swbVenueIdScheme='http://www.fpml.org/coding-scheme/external/cftc/interim-compliant-identifier'">CFTC</xsl:when>
<xsl:when test="$swbHeader/swml:swbVenueId/@swbVenueIdScheme='http://www.fpml.org/coding-scheme/external/iso17442'">Pre-LEI</xsl:when>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="MessageText" select="$swExtendedTradeDetails/swml:swbMessageText"/>
<xsl:with-param name="AllocatedTrade" select="boolean($SWBML/swml:swAllocations)"/>
<xsl:with-param name="Allocation">
<xsl:for-each select="$SWBML/swml:swAllocations/swml:swAllocation">
<xsl:variable name="payer" select="string(swml:payerPartyReference/@href)"/>
<xsl:variable name="buyer" select="string(swml:buyerPartyReference/@href)"/>
<xsl:choose>
<xsl:when test="$payer !='' ">
<xsl:call-template name="tx:Trade.Allocation">
<xsl:with-param name="Payer">
<xsl:value-of select="$dataDocument/fpml:party[@id=$payer]/fpml:partyId"/>
</xsl:with-param>
<xsl:with-param name="Receiver">
<xsl:variable name="receiver" select="string(swml:receiverPartyReference/@href)"/>
<xsl:value-of select="$dataDocument/fpml:party[@id=$receiver]/fpml:partyId"/>
</xsl:with-param>
<xsl:with-param name="swbStreamReference">
<xsl:value-of select="swml:swbStreamReference"/>
</xsl:with-param>
<xsl:with-param name="AllocatedNotional">
<xsl:call-template name="tx:Trade.Allocation.AllocatedNotional">
<xsl:with-param name="Currency">
<xsl:value-of select="swml:allocatedNotional/fpml:currency"/>
</xsl:with-param>
<xsl:with-param name="Amount">
<xsl:value-of select="swml:allocatedNotional/fpml:amount"/>
</xsl:with-param>
</xsl:call-template>
</xsl:with-param>
<xsl:with-param name="AllocationIndependentAmount">
<xsl:call-template name="tx:Trade.Allocation.AllocationIndependentAmount">
<xsl:with-param name="Payer">
<xsl:choose>
<xsl:when test="swml:independentAmount/fpml:payerPartyReference/@href = 'partyA' ">
<xsl:value-of select="$dataDocument/fpml:party[1]/fpml:partyId"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$dataDocument/fpml:party[2]/fpml:partyId"/>
</xsl:otherwise>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="Currency">
<xsl:value-of select="swml:independentAmount/fpml:paymentDetail/fpml:paymentAmount/fpml:currency"/>
</xsl:with-param>
<xsl:with-param name="Amount">
<xsl:value-of select="swml:independentAmount/fpml:paymentDetail/fpml:paymentAmount/fpml:amount"/>
</xsl:with-param>
</xsl:call-template>
</xsl:with-param>
<xsl:with-param name="AllocationOtherPartyPayment">
<xsl:call-template name="tx:Trade.Allocation.AllocationOtherPartyPayment">
<xsl:with-param name="Payer">
<xsl:choose>
<xsl:when test="swml:otherPartyPayment/fpml:payerPartyReference/@href = 'partyA' ">
<xsl:value-of select="$dataDocument/fpml:party[1]/fpml:partyId"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$dataDocument/fpml:party[2]/fpml:partyId"/>
</xsl:otherwise>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="Receiver">
<xsl:choose>
<xsl:when test="swml:otherPartyPayment/fpml:receiverPartyReference/@href = 'partyA' ">
<xsl:value-of select="$dataDocument/fpml:party[1]/fpml:partyId"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$dataDocument/fpml:party[2]/fpml:partyId"/>
</xsl:otherwise>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="Currency">
<xsl:value-of select="swml:otherPartyPayment/fpml:paymentAmount/fpml:currency"/>
</xsl:with-param>
<xsl:with-param name="Amount">
<xsl:value-of select="swml:otherPartyPayment/fpml:paymentAmount/fpml:amount"/>
</xsl:with-param>
</xsl:call-template>
</xsl:with-param>
<xsl:with-param name="swbBrokerTradeId">
<xsl:value-of select="swml:swbBrokerTradeId"/>
</xsl:with-param>
</xsl:call-template>
</xsl:when>
<xsl:when test="$buyer !='' ">
<xsl:call-template name="tx:Trade.Allocation">
<xsl:with-param name="Buyer">
<xsl:value-of select="$dataDocument/fpml:party[@id=$buyer]/fpml:partyId"/>
</xsl:with-param>
<xsl:with-param name="Seller">
<xsl:variable name="seller" select="string(swml:sellerPartyReference/@href)"/>
<xsl:value-of select="$dataDocument/fpml:party[@id=$seller]/fpml:partyId"/>
</xsl:with-param>
<xsl:with-param name="swbStreamReference">
<xsl:value-of select="swml:swbStreamReference"/>
</xsl:with-param>
<xsl:with-param name="AllocatedNotional">
<xsl:call-template name="tx:Trade.Allocation.AllocatedNotional">
<xsl:with-param name="Currency">
<xsl:value-of select="swml:allocatedNotional/fpml:currency"/>
</xsl:with-param>
<xsl:with-param name="Amount">
<xsl:value-of select="swml:allocatedNotional/fpml:amount"/>
</xsl:with-param>
</xsl:call-template>
</xsl:with-param>
<xsl:with-param name="AllocationIndependentAmount">
<xsl:call-template name="tx:Trade.Allocation.AllocationIndependentAmount">
<xsl:with-param name="Payer">
<xsl:choose>
<xsl:when test="swml:independentAmount/fpml:payerPartyReference/@href = 'partyA' ">
<xsl:value-of select="$dataDocument/fpml:party[1]/fpml:partyId"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$dataDocument/fpml:party[2]/fpml:partyId"/>
</xsl:otherwise>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="Currency">
<xsl:value-of select="swml:independentAmount/fpml:paymentDetail/fpml:paymentAmount/fpml:currency"/>
</xsl:with-param>
<xsl:with-param name="Amount">
<xsl:value-of select="swml:independentAmount/fpml:paymentDetail/fpml:paymentAmount/fpml:amount"/>
</xsl:with-param>
</xsl:call-template>
</xsl:with-param>
<xsl:with-param name="AllocationOtherPartyPayment">
<xsl:call-template name="tx:Trade.Allocation.AllocationOtherPartyPayment">
<xsl:with-param name="Payer">
<xsl:choose>
<xsl:when test="swml:otherPartyPayment/fpml:payerPartyReference/@href = 'partyA' ">
<xsl:value-of select="$dataDocument/fpml:party[1]/fpml:partyId"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$dataDocument/fpml:party[2]/fpml:partyId"/>
</xsl:otherwise>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="Receiver">
<xsl:choose>
<xsl:when test="swml:otherPartyPayment/fpml:receiverPartyReference/@href = 'partyA' ">
<xsl:value-of select="$dataDocument/fpml:party[1]/fpml:partyId"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$dataDocument/fpml:party[2]/fpml:partyId"/>
</xsl:otherwise>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="Currency">
<xsl:value-of select="swml:otherPartyPayment/swml:paymentAmount/fpml:currency"/>
</xsl:with-param>
<xsl:with-param name="Amount">
<xsl:value-of select="swml:otherPartyPayment/swml:paymentAmount/fpml:amount"/>
</xsl:with-param>
</xsl:call-template>
</xsl:with-param>
<xsl:with-param name="swbBrokerTradeId">
<xsl:value-of select="swml:swbBrokerTradeId"/>
</xsl:with-param>
</xsl:call-template>
</xsl:when>
</xsl:choose>
</xsl:for-each>
</xsl:with-param>
<xsl:with-param name="EmptyBlockTrade" select="string(boolean($SWBML/swml:swbBlockTrade))"/>
<xsl:with-param name="PrimeBrokerTrade" select="string(boolean($swbGiveUp))"/>
<xsl:with-param name="ReversePrimeBrokerLegalEntities">
<xsl:if test="$swbGiveUp">
<xsl:value-of select="string(boolean(string($swbGiveUp/swml:swbCustomerTransaction/swml:swbCustomer/@href)='partyA'))"/>
</xsl:if>
</xsl:with-param>
<xsl:with-param name="Recipient">
<xsl:choose>
<xsl:when test="$swbHeader/swml:swbRecipient">
<xsl:for-each select="$swbHeader/swml:swbRecipient">
<xsl:call-template name="tx:Trade.Recipient">
<xsl:with-param name="Id" select="./@id"/>
<xsl:with-param name="Party">
<xsl:variable name="party" select="string(swml:partyReference/@href)"/>
<xsl:choose>
<xsl:when test="$party='partyA'">A</xsl:when>
<xsl:when test="$party='partyB'">B</xsl:when>
<xsl:when test="$party != '' ">
<xsl:value-of select="$party"/>
</xsl:when>
<xsl:otherwise>???</xsl:otherwise>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="UserName">
<xsl:variable name="party" select="string(swml:partyReference/@href)"/>
<xsl:value-of select="$trade/fpml:tradeHeader/fpml:partyTradeInformation[fpml:partyReference/@href=$party]/fpml:trader"/>
</xsl:with-param>
<xsl:with-param name="TradingBook" select="swml:swbTradingBookId"/>
<xsl:with-param name="ExecutionMode" select="swml:swbExecutionMode"/>
</xsl:call-template>
</xsl:for-each>
</xsl:when>
<xsl:otherwise>
<xsl:call-template name="tx:Trade.Recipient"></xsl:call-template>
</xsl:otherwise>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="PartyAId">
<xsl:call-template name="tx:Trade.PartyAId">
<xsl:with-param name="content" select="$dataDocument/fpml:party[@id=$swbHeader/swml:swbRecipient[1]/swml:partyReference/@href]/fpml:partyId"/>
<xsl:with-param name="id" select="$dataDocument/fpml:party[@id=$swbHeader/swml:swbRecipient[1]/swml:partyReference/@href]/@id"/>				</xsl:call-template>
</xsl:with-param>
<xsl:with-param name="PartyAIdType" select="$dataDocument/fpml:party[@id=$swbHeader/swml:swbRecipient[1]/swml:partyReference/@href]/fpml:partyId/@partyIdScheme"/>
<xsl:with-param name="PartyAName">
<xsl:value-of select="$dataDocument/fpml:party[@id=$swbHeader/swml:swbRecipient[1]/swml:partyReference/@href]/fpml:partyName"/>
</xsl:with-param>
<xsl:with-param name="PartyBId">
<xsl:call-template name="tx:Trade.PartyBId">
<xsl:with-param name="content" select="$dataDocument/fpml:party[@id=$swbHeader/swml:swbRecipient[2]/swml:partyReference/@href]/fpml:partyId"/>
<xsl:with-param name="id" select="$dataDocument/fpml:party[@id=$swbHeader/swml:swbRecipient[2]/swml:partyReference/@href]/@id"/>				</xsl:call-template>
</xsl:with-param>
<xsl:with-param name="PartyBIdType" select="$dataDocument/fpml:party[@id=$swbHeader/swml:swbRecipient[2]/swml:partyReference/@href]/fpml:partyId/@partyIdScheme"/>
<xsl:with-param name="PartyBName">
<xsl:value-of select="$dataDocument/fpml:party[@id=$swbHeader/swml:swbRecipient[2]/swml:partyReference/@href]/fpml:partyName"/>
</xsl:with-param>
<xsl:with-param name="NominalTerm">
<xsl:value-of select="$swExtendedTradeDetails/swml:swbProductTerm/fpml:periodMultiplier"/>
<xsl:value-of select="$swExtendedTradeDetails/swml:swbProductTerm/fpml:period"/>
</xsl:with-param>
<xsl:with-param name="TradeDate" select="$trade/fpml:tradeHeader/fpml:tradeDate"/>
<xsl:with-param name="ManualConfirm" select="$swTradeHeader/swml:swManualConfirmationRequired"/>
<xsl:with-param name="ExitReason" select="$swExtendedTradeDetails/swml:swExitReason"/>
<xsl:with-param name="GenProdPrimaryAssetClass" select="$swGenericProduct/fpml:primaryAssetClass"/>
<xsl:with-param name="GenProdSecondaryAssetClass">
<xsl:for-each select="$swGenericProduct/fpml:secondaryAssetClass">
<xsl:value-of select="text()"/>
<xsl:choose>
<xsl:when test="position() != count($swGenericProduct/fpml:secondaryAssetClass)">
<xsl:text>; </xsl:text>
</xsl:when>
</xsl:choose>
</xsl:for-each>
</xsl:with-param>
<xsl:with-param name="ProductId">
<xsl:for-each select="$swGenericProduct/fpml:productId">
<xsl:value-of select="text()"/>
<xsl:choose>
<xsl:when test="position() != count($swGenericProduct/fpml:productId)">
<xsl:text>; </xsl:text>
</xsl:when>
</xsl:choose>
</xsl:for-each>
</xsl:with-param>
<xsl:with-param name="OptionDirectionA">
<xsl:choose>
<xsl:when test="$swGenericProduct/fpml:buyerPartyReference/@href = 'partyA' ">We</xsl:when>
<xsl:when test="$swGenericProduct/fpml:sellerPartyReference/@href = 'partyA' ">Cpty</xsl:when>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="OptionPremium" select="$premium/fpml:paymentAmount/fpml:amount"/>
<xsl:with-param name="OptionPremiumCurrency" select="$premium/fpml:paymentAmount/fpml:currency"/>
<xsl:with-param name="EffectiveDate" select="$swGenericProduct/fpml:effectiveDate/fpml:unadjustedDate"/>
<xsl:with-param name="OptionExpirationDate" select="$swGenericProduct/fpml:expirationDate/fpml:unadjustedDate"/>
<xsl:with-param name="TerminationDate" select="$swGenericProduct/fpml:terminationDate/fpml:unadjustedDate"/>
<xsl:with-param name="GenProdUnderlyer">
<xsl:for-each select="$swGenericProduct/fpml:underlyer">
<xsl:call-template name="tx:Trade.GenProdUnderlyer">
<xsl:with-param name="UnderlyerType" select="local-name(*)"/>
<xsl:with-param name="UnderlyerDescription">
<xsl:value-of select="*/fpml:description"/>
<xsl:value-of select="*/fpml:floatingRateIndex"/>
<xsl:value-of select="*/fpml:entityName"/>
</xsl:with-param>
<xsl:with-param name="UnderlyerDirectionA">
<xsl:choose>
<xsl:when test="fpml:payerPartyReference/@href = 'partyA' ">Pay</xsl:when>
<xsl:when test="fpml:receiverPartyReference/@href = 'partyA' ">Rec</xsl:when>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="UnderlyerFixedRate" select="*/fpml:initialValue"/>
<xsl:with-param name="UnderlyerIDCode">
<xsl:value-of select="*/fpml:instrumentId"/>
<xsl:value-of select="*/fpml:entityId"/>
</xsl:with-param>
<xsl:with-param name="UnderlyerIDType">
<xsl:value-of select="*/fpml:instrumentId/@instrumentIdScheme"/>
<xsl:value-of select="*/fpml:entityId/@entityIdScheme"/>
</xsl:with-param>
<xsl:with-param name="UnderlyerReferenceCurrency">
<xsl:value-of select="*/fpml:currency"/>
<xsl:value-of select="*/fpml:currency1"/>
</xsl:with-param>
<xsl:with-param name="UnderlyerFXCurrency" select="*/fpml:currency2"/>
</xsl:call-template>
</xsl:for-each>
</xsl:with-param>
<xsl:with-param name="GenProdNotional">
<xsl:for-each select="$swGenericProduct/fpml:notional">
<xsl:call-template name="tx:Trade.GenProdNotional">
<xsl:with-param name="NotionalCurrency" select="fpml:currency"/>
<xsl:with-param name="NotionalUnit" select="fpml:units"/>
<xsl:with-param name="Notional" select="fpml:amount"/>
</xsl:call-template>
</xsl:for-each>
</xsl:with-param>
<xsl:with-param name="OptionType" select="$swGenericProduct/fpml:optionType"/>
<xsl:with-param name="SettlementCurrency">
<xsl:for-each select="$swGenericProduct/fpml:settlementCurrency">
<xsl:value-of select="text()"/>
<xsl:choose>
<xsl:when test="position() != count($swGenericProduct/fpml:settlementCurrency)">
<xsl:text>; </xsl:text>
</xsl:when>
</xsl:choose>
</xsl:for-each>
</xsl:with-param>
<xsl:with-param name="OptionStrike">
<xsl:variable name="swOptionStrike" select="$swGenericProduct/swml:swOptionStrike"/>
<xsl:choose>
<xsl:when test="string-length($swOptionStrike/swml:swStrikePrice) != 0">
<xsl:value-of select="$swOptionStrike/swml:swStrikePrice"/>
</xsl:when>
<xsl:when test="string-length($swOptionStrike/swml:swStrikeRate) != 0">
<xsl:value-of select="$swOptionStrike/swml:swStrikeRate"/>
</xsl:when>
<xsl:when test="string-length($swOptionStrike/swml:swStrikePercentage) != 0">
<xsl:value-of select="$swOptionStrike/swml:swStrikePercentage"/>
</xsl:when>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="OptionStrikeType" select="$swGenericProduct/swml:swOptionStrike/swml:swStrikeUnits" />
<xsl:with-param name="OptionStrikeCurrency" select="$swGenericProduct/swml:swOptionStrike/swml:swStrikeCurrency" />
<xsl:with-param name="OptionStyle" select="$swGenericProduct/swml:swOptionStyle"/>
<xsl:with-param name="FirstExerciseDate" select="$swGenericProduct/swml:swOptionFirstExerciseDate"/>
<xsl:with-param name="PaymentFrequency">
<xsl:variable name="Underlyer_count" select="count($swGenericProduct/fpml:underlyer)"/>
<xsl:for-each select="$swGenericProduct/fpml:underlyer">
<xsl:value-of select="$swGenericProduct/swml:swPaymentFrequency[swml:underlyerReference/@href=current()/@id]/fpml:periodMultiplier"/>
<xsl:value-of select="$swGenericProduct/swml:swPaymentFrequency[swml:underlyerReference/@href=current()/@id]/fpml:period"/>
<xsl:if test="position() != $Underlyer_count">
<xsl:text>; </xsl:text>
</xsl:if>
</xsl:for-each>
</xsl:with-param>
<xsl:with-param name="ResetFrequency">
<xsl:variable name="Underlyer_count" select="count($swGenericProduct/fpml:underlyer)"/>
<xsl:for-each select="$swGenericProduct/fpml:underlyer">
<xsl:value-of select="$swGenericProduct/swml:swResetFrequency[swml:underlyerReference/@href=current()/@id]/fpml:periodMultiplier"/>
<xsl:value-of select="$swGenericProduct/swml:swResetFrequency[swml:underlyerReference/@href=current()/@id]/fpml:period"/>
<xsl:if test="position() != $Underlyer_count">
<xsl:text>; </xsl:text>
</xsl:if>
</xsl:for-each>
</xsl:with-param>
<xsl:with-param name="DayCountFraction">
<xsl:variable name="Underlyer_count" select="count($swGenericProduct/fpml:underlyer)"/>
<xsl:for-each select="$swGenericProduct/fpml:underlyer">
<xsl:choose>
<xsl:when test="count($swGenericProduct/swml:swDayCountFraction/swml:underlyerReference[@href=current()/@id]) = 1">
<xsl:variable name="thisDCC" select="$swGenericProduct/swml:swDayCountFraction[swml:underlyerReference/@href=current()/@id]/swml:dayCountFraction"/>
<xsl:call-template name="tx:Trade.DayCountFraction">
<xsl:with-param name="Schema">
<xsl:choose>
<xsl:when test="contains($thisDCC/@dayCountFractionScheme,'FLOAT')">FLOAT</xsl:when>
<xsl:otherwise>FIX</xsl:otherwise>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="Fraction" select="$thisDCC/text()"/>
</xsl:call-template>
</xsl:when>
<xsl:otherwise>
<xsl:call-template name="tx:Trade.DayCountFraction">
<xsl:with-param name="Schema" />
<xsl:with-param name="Fraction" />
</xsl:call-template>
</xsl:otherwise>
</xsl:choose>
</xsl:for-each>
</xsl:with-param>
<xsl:with-param name="IndependentAmount">
<xsl:variable name="IndependentAmount" select="  $trade/fpml:collateral/fpml:independentAmount"/>
<xsl:call-template name="tx:Trade.IndependentAmount">
<xsl:with-param name="Payer">
<xsl:choose>
<xsl:when test="$IndependentAmount/fpml:payerPartyReference/@href = 'partyA' ">Pay</xsl:when>
<xsl:when test="$IndependentAmount/fpml:receiverPartyReference/@href = 'partyA' ">Rec</xsl:when>						</xsl:choose>
</xsl:with-param>
<xsl:with-param name="Amount" select="$IndependentAmount/fpml:paymentDetail/fpml:paymentAmount/fpml:amount"/>
<xsl:with-param name="Currency" select="$IndependentAmount/fpml:paymentDetail/fpml:paymentAmount/fpml:currency"/>
</xsl:call-template>
</xsl:with-param>
<xsl:with-param name="AdditionalPayment">
<xsl:variable name="AdditionalPayment" select="$swGenericProduct/swml:swAdditionalPayment"/>
<xsl:for-each select="$AdditionalPayment">
<xsl:call-template name="tx:Trade.AdditionalPayment">
<xsl:with-param name="Payer">
<xsl:variable name="payer" select="string(fpml:payerPartyReference/@href)"/>
<xsl:choose>
<xsl:when test="$payer='partyA'">A</xsl:when>
<xsl:when test="$payer='partyB'">B</xsl:when>
<xsl:otherwise>???</xsl:otherwise>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="Reason"     select="fpml:paymentType"/>
<xsl:with-param name="Currency"   select="fpml:paymentAmount/fpml:currency"/>
<xsl:with-param name="Amount"     select="fpml:paymentAmount/fpml:amount"/>
<xsl:with-param name="Date"       select="string(fpml:paymentDate/fpml:adjustedDate)"/>
<xsl:with-param name="Convention" select="fpml:paymentDate/fpml:dateAdjustments/fpml:businessDayConvention"/>
<xsl:with-param name="Holidays"   select="fpml:paymentDate/fpml:dateAdjustments/fpml:businessCenters/fpml:businessCenter"/>
</xsl:call-template>
</xsl:for-each>
</xsl:with-param>
<xsl:with-param name="Brokerage">
<xsl:variable name="Brokerage" select="$trade/fpml:otherPartyPayment"/>
<xsl:for-each select="$Brokerage">
<xsl:call-template name="tx:Trade.Brokerage">
<xsl:with-param name="Payer">
<xsl:variable name="payer" select="string(fpml:payerPartyReference/@href)"/>
<xsl:choose>
<xsl:when test="$payer='partyA'">A</xsl:when>
<xsl:when test="$payer='partyB'">B</xsl:when>
<xsl:otherwise>???</xsl:otherwise>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="Currency" select="fpml:paymentAmount/fpml:currency"/>
<xsl:with-param name="Amount" select="fpml:paymentAmount/fpml:amount"/>
<xsl:with-param name="Broker">
<xsl:variable name="broker" select="string(fpml:receiverPartyReference/@href)"/>
<xsl:value-of select="$dataDocument/fpml:party[@id=$broker]/fpml:partyId"/>
</xsl:with-param>
<xsl:with-param name="BrokerTradeId">
<xsl:variable name="party" select="string(fpml:payerPartyReference/@href)"/>
<xsl:value-of select="$trade/fpml:tradeHeader/fpml:partyTradeIdentifier/fpml:partyReference[@href=$party]/../fpml:tradeId"/>
</xsl:with-param>
</xsl:call-template>
</xsl:for-each>
</xsl:with-param>
<xsl:with-param name="ExecutingBroker">
<xsl:if test="$swTradeHeader/swml:swbExecutingBroker and $swTradeHeader/swml:swbClearingClient and $swTradeHeader/swml:swbClientClearing='true' and not($swTradeHeader/swml:swbDisplayPartyLegalEntity) and $isPrimeBrokered='0'">
<xsl:value-of select="$partyA"/>
</xsl:if>
</xsl:with-param>
<xsl:with-param name="ClearingClient">
<xsl:if test="$swTradeHeader/swml:swbExecutingBroker and $swTradeHeader/swml:swbClearingClient and $swTradeHeader/swml:swbClientClearing='true' and not($swTradeHeader/swml:swbDisplayPartyLegalEntity) and $isPrimeBrokered='0'">
<xsl:value-of select="$partyB"/>
</xsl:if>
</xsl:with-param>
<xsl:with-param name="DFEmbeddedOptionType" select="$swGenericProduct/fpml:embeddedOptionType"/>
<xsl:with-param name="PartyAOrderDetails">
<xsl:if test="$swExtendedTradeDetails/swml:swbOrderDetails[@href='partyA']">
<xsl:call-template name="tx:Trade.PartyAOrderDetails">
<xsl:with-param name="TypeOfOrder" select="$swExtendedTradeDetails/swml:swbOrderDetails[@href='partyA']/swml:swbTypeOfOrder"/>
<xsl:with-param name="TotalConsideration" select="$swExtendedTradeDetails/swml:swbOrderDetails[@href='partyA']/swml:swbTotalConsideration"/>
<xsl:with-param name="RateOfExchange" select="$swExtendedTradeDetails/swml:swbOrderDetails[@href='partyA']/swml:swbRateOfExchange"/>
<xsl:with-param name="ClientCounterparty" select="$swExtendedTradeDetails/swml:swbOrderDetails[@href='partyA']/swml:swbClientCounterparty"/>
<xsl:with-param name="TotalCommissionAndExpenses" select="$swExtendedTradeDetails/swml:swbOrderDetails[@href='partyA']/swml:swbTotalCommissionAndExpenses"/>
<xsl:with-param name="ClientSettlementResponsibilities" select="$swExtendedTradeDetails/swml:swbOrderDetails[@href='partyA']/swml:swbClientSettlementResponsibilities"/>
</xsl:call-template>
</xsl:if>
</xsl:with-param>
<xsl:with-param name="PartyBOrderDetails">
<xsl:if test="$swExtendedTradeDetails/swml:swbOrderDetails[@href='partyB']">
<xsl:call-template name="tx:Trade.PartyBOrderDetails">
<xsl:with-param name="TypeOfOrder" select="$swExtendedTradeDetails/swml:swbOrderDetails[@href='partyB']/swml:swbTypeOfOrder"/>
<xsl:with-param name="TotalConsideration" select="$swExtendedTradeDetails/swml:swbOrderDetails[@href='partyB']/swml:swbTotalConsideration"/>
<xsl:with-param name="RateOfExchange" select="$swExtendedTradeDetails/swml:swbOrderDetails[@href='partyB']/swml:swbRateOfExchange"/>
<xsl:with-param name="ClientCounterparty" select="$swExtendedTradeDetails/swml:swbOrderDetails[@href='partyB']/swml:swbClientCounterparty"/>
<xsl:with-param name="TotalCommissionAndExpenses" select="$swExtendedTradeDetails/swml:swbOrderDetails[@href='partyB']/swml:swbTotalCommissionAndExpenses"/>
<xsl:with-param name="ClientSettlementResponsibilities" select="$swExtendedTradeDetails/swml:swbOrderDetails[@href='partyB']/swml:swbClientSettlementResponsibilities"/>
</xsl:call-template>
</xsl:if>
</xsl:with-param>
<xsl:with-param name="PartyAPackageDetails">
<xsl:if test="$swExtendedTradeDetails/swml:swbPackageDetails[@href='partyA']">
<xsl:call-template name="tx:Trade.PartyAPackageDetails">
<xsl:with-param name="PackageId" select="$swExtendedTradeDetails/swml:swbPackageDetails[@href='partyA']/swml:swbPackageId"/>
<xsl:with-param name="PackageSize" select="$swExtendedTradeDetails/swml:swbPackageDetails[@href='partyA']/swml:swbPackageSize"/>
<xsl:with-param name="RegReportAsPackage" select="$swExtendedTradeDetails/swml:swbPackageDetails[@href='partyA']/swml:swbRegReportAsPackage"/>
<xsl:with-param name="PackagePriceType" select="$swExtendedTradeDetails/swml:swbPackageDetails[@href='partyA']/swml:swbPackagePriceDetails/swml:swbType"/>
<xsl:with-param name="PackagePriceValue" select="$swExtendedTradeDetails/swml:swbPackageDetails[@href='partyA']/swml:swbPackagePriceDetails/swml:swbValue"/>
<xsl:with-param name="PackagePriceNotation" select="$swExtendedTradeDetails/swml:swbPackageDetails[@href='partyA']/swml:swbPackagePriceDetails/swml:swbNotation"/>
<xsl:with-param name="PackagePriceCurrency" select="$swExtendedTradeDetails/swml:swbPackageDetails[@href='partyA']/swml:swbPackagePriceDetails/swml:swbCurrency"/>
</xsl:call-template>
</xsl:if>
</xsl:with-param>
<xsl:with-param name="PartyBPackageDetails">
<xsl:if test="$swExtendedTradeDetails/swml:swbPackageDetails[@href='partyB']">
<xsl:call-template name="tx:Trade.PartyBPackageDetails">
<xsl:with-param name="PackageId" select="$swExtendedTradeDetails/swml:swbPackageDetails[@href='partyB']/swml:swbPackageId"/>
<xsl:with-param name="PackageSize" select="$swExtendedTradeDetails/swml:swbPackageDetails[@href='partyB']/swml:swbPackageSize"/>
<xsl:with-param name="RegReportAsPackage" select="$swExtendedTradeDetails/swml:swbPackageDetails[@href='partyB']/swml:swbRegReportAsPackage"/>
<xsl:with-param name="PackagePriceType" select="$swExtendedTradeDetails/swml:swbPackageDetails[@href='partyB']/swml:swbPackagePriceDetails/swml:swbType"/>
<xsl:with-param name="PackagePriceValue" select="$swExtendedTradeDetails/swml:swbPackageDetails[@href='partyB']/swml:swbPackagePriceDetails/swml:swbValue"/>
<xsl:with-param name="PackagePriceNotation" select="$swExtendedTradeDetails/swml:swbPackageDetails[@href='partyB']/swml:swbPackagePriceDetails/swml:swbNotation"/>
<xsl:with-param name="PackagePriceCurrency" select="$swExtendedTradeDetails/swml:swbPackageDetails[@href='partyB']/swml:swbPackagePriceDetails/swml:swbCurrency"/>
</xsl:call-template>
</xsl:if>
</xsl:with-param>
<xsl:with-param name="AutoProcessing" select="$swTradeHeader/swml:swbAutoProcessing"/>
<xsl:with-param name="GCOffsettingID" select="$swTradeHeader/swml:swbOffsettingTradeId"/>
<xsl:with-param name="CompressionType" select="$swTradeHeader/swml:swbCompressionType"/>
<xsl:with-param name="GCExecutionMethodParty_1">
<xsl:if test="$swTradeHeader/swml:swbPartyExecutionMethod">
<xsl:for-each select="$swTradeHeader/swml:swbPartyExecutionMethod">
<xsl:if test="swml:partyReference/@href = 'partyA'">
<xsl:value-of select="swml:partyReference/@href"/>
</xsl:if>
</xsl:for-each>
</xsl:if>
</xsl:with-param>
<xsl:with-param name="GCExecutionMethodToken_1">
<xsl:if test="$swTradeHeader/swml:swbPartyExecutionMethod">
<xsl:for-each select="$swTradeHeader/swml:swbPartyExecutionMethod">
<xsl:if test="swml:partyReference/@href = 'partyA'">
<xsl:value-of select="swml:swbExecutionMethod"/>
</xsl:if>
</xsl:for-each>
</xsl:if>
</xsl:with-param>
<xsl:with-param name="GCExecutionMethodParty_2">
<xsl:if test="$swTradeHeader/swml:swbPartyExecutionMethod">
<xsl:for-each select="$swTradeHeader/swml:swbPartyExecutionMethod">
<xsl:if test="swml:partyReference/@href = 'partyB'">
<xsl:value-of select="swml:partyReference/@href"/>
</xsl:if>
</xsl:for-each>
</xsl:if>
</xsl:with-param>
<xsl:with-param name="GCExecutionMethodToken_2">
<xsl:if test="$swTradeHeader/swml:swbPartyExecutionMethod">
<xsl:for-each select="$swTradeHeader/swml:swbPartyExecutionMethod">
<xsl:if test="swml:partyReference/@href = 'partyB'">
<xsl:value-of select="swml:swbExecutionMethod"/>
</xsl:if>
</xsl:for-each>
</xsl:if>
</xsl:with-param>
<xsl:with-param name="IntroducingBroker_2">
<xsl:if test="$swTradeHeader/swml:swbPartyIntroducingBroker">
<xsl:for-each select="$swTradeHeader/swml:swbPartyIntroducingBroker">
<xsl:if test="swml:partyReference/@href = 'partyB'">
<xsl:value-of select="swml:swbIntroducingBroker"/>
</xsl:if>
</xsl:for-each>
</xsl:if>
</xsl:with-param>
<xsl:with-param name="IntroducingBroker">
<xsl:if test="$swTradeHeader/swml:swbPartyIntroducingBroker">
<xsl:for-each select="$swTradeHeader/swml:swbPartyIntroducingBroker">
<xsl:if test="swml:partyReference/@href = 'partyA'">
<xsl:value-of select="swml:swbIntroducingBroker"/>
</xsl:if>
</xsl:for-each>
</xsl:if>
</xsl:with-param>
<xsl:with-param name="IntroducingBroker_2">
<xsl:if test="$swTradeHeader/swml:swbPartyIntroducingBroker">
<xsl:for-each select="$swTradeHeader/swml:swbPartyIntroducingBroker">
<xsl:if test="swml:partyReference/@href = 'partyB'">
<xsl:value-of select="swml:swbIntroducingBroker"/>
</xsl:if>
</xsl:for-each>
</xsl:if>
</xsl:with-param>
<xsl:with-param name="DFData">
<xsl:call-template name="outputCommonReportingFields">
<xsl:with-param name="reportingData" select="$reportingData"/>
<xsl:with-param name="brokerPrivateData" select="$brokerPrivateData"/>
<xsl:with-param name="partyAPrivateData" select="$partyAPrivateData"/>
<xsl:with-param name="partyBPrivateData" select="$partyBPrivateData"/>
<xsl:with-param name="brokerPBPrivateData" select="$brokerPBPrivateData"/>
<xsl:with-param name="pbPrivateData" select="$pbPrivateData"/>
<xsl:with-param name="clientPrivateData" select="$clientPrivateData"/>
</xsl:call-template>
</xsl:with-param>
<xsl:with-param name="MidMarketPriceType" select="$swbBusinessConductDetails/swml:swbMidMarketPrice/swml:swbUnit"/>
<xsl:with-param name="MidMarketPriceValue" select="$swbBusinessConductDetails/swml:swbMidMarketPrice/swml:swbAmount"/>
<xsl:with-param name="MidMarketPriceCurrency" select="$swbBusinessConductDetails/swml:swbMidMarketPrice/swml:swbCurrency"/>
<xsl:with-param name="IntentToBlankMidMarketCurrency" select="boolean($swbBusinessConductDetails/swml:swbMidMarketPrice/swml:swbUnit != ' ' and not($swbBusinessConductDetails/swml:swbMidMarketPrice/swml:swbUnit = 'Price'))"/>
<xsl:with-param name="IntentToBlankMidMarketPrice" select="boolean(not(normalize-space($swbBusinessConductDetails/swml:swbMidMarketPrice[node()])))"/>
<xsl:with-param name="SettlementDate"                      select="$swGenericProduct/swml:swSettlementDate"/>
<xsl:with-param name="SettlementType"                      select="$swGenericProduct/swml:swSettlementType"/>
<xsl:with-param name="MasterAgreement"                     select="$trade/fpml:documentation/fpml:masterAgreement/fpml:masterAgreementType"/>
<xsl:with-param name="MasterAgreementVersion"              select="$trade/fpml:documentation/fpml:masterAgreement/fpml:masterAgreementVersion"/>
<xsl:with-param name="MasterAgreementDate"                 select="$trade/fpml:documentation/fpml:masterAgreement/fpml:masterAgreementDate"/>
<xsl:with-param name="ASICMandatoryClearingIndicator"      select="$swbMandatoryClearing[swml:swbJurisdiction='ASIC']/swml:swbMandatoryClearingIndicator"/>
<xsl:with-param name="CANMandatoryClearingIndicator"      select="$swbMandatoryClearing[swml:swbJurisdiction='CAN']/swml:swbMandatoryClearingIndicator"/>
<xsl:with-param name="CANClearingExemptIndicator1PartyId" select="$swStructuredTradeDetails/fpml:dataDocument/fpml:party[@id=$swbMandatoryClearing[swml:swbJurisdiction='CAN' ]/swml:swbPartyExemption[1]/swml:partyReference/@href]/fpml:partyId"/>
<xsl:with-param name="CANClearingExemptIndicator1Value"   select="$swbMandatoryClearing[swml:swbJurisdiction='CAN']/swml:swbPartyExemption[1]/swml:swbExemption"/>
<xsl:with-param name="CANClearingExemptIndicator2PartyId" select="$swStructuredTradeDetails/fpml:dataDocument/fpml:party[@id=$swbMandatoryClearing[swml:swbJurisdiction='CAN' ]/swml:swbPartyExemption[2]/swml:partyReference/@href]/fpml:partyId"/>
<xsl:with-param name="CANClearingExemptIndicator2Value"   select="$swbMandatoryClearing[swml:swbJurisdiction='CAN']/swml:swbPartyExemption[2]/swml:swbExemption"/>
<xsl:with-param name="ESMAMandatoryClearingIndicator"      select="$swbMandatoryClearing[swml:swbJurisdiction='ESMA']/swml:swbMandatoryClearingIndicator"/>
<xsl:with-param name="ESMAClearingExemptIndicator1PartyId" select="$swStructuredTradeDetails/fpml:dataDocument/fpml:party[@id=$swbMandatoryClearing[swml:swbJurisdiction='ESMA' ]/swml:swbPartyExemption[1]/swml:partyReference/@href]/fpml:partyId"/>
<xsl:with-param name="ESMAClearingExemptIndicator1Value"   select="$swbMandatoryClearing[swml:swbJurisdiction='ESMA']/swml:swbPartyExemption[1]/swml:swbExemption"/>
<xsl:with-param name="ESMAClearingExemptIndicator2PartyId" select="$swStructuredTradeDetails/fpml:dataDocument/fpml:party[@id=$swbMandatoryClearing[swml:swbJurisdiction='ESMA' ]/swml:swbPartyExemption[2]/swml:partyReference/@href]/fpml:partyId"/>
<xsl:with-param name="ESMAClearingExemptIndicator2Value"   select="$swbMandatoryClearing[swml:swbJurisdiction='ESMA']/swml:swbPartyExemption[2]/swml:swbExemption"/>
<xsl:with-param name="FCAMandatoryClearingIndicator"      select="$swbMandatoryClearing[swml:swbJurisdiction='FCA']/swml:swbMandatoryClearingIndicator"/>
<xsl:with-param name="FCAClearingExemptIndicator1PartyId" select="$swStructuredTradeDetails/fpml:dataDocument/fpml:party[@id=$swbMandatoryClearing[swml:swbJurisdiction='FCA' ]/swml:swbPartyExemption[1]/swml:partyReference/@href]/fpml:partyId"/>
<xsl:with-param name="FCAClearingExemptIndicator1Value"   select="$swbMandatoryClearing[swml:swbJurisdiction='FCA']/swml:swbPartyExemption[1]/swml:swbExemption"/>
<xsl:with-param name="FCAClearingExemptIndicator2PartyId" select="$swStructuredTradeDetails/fpml:dataDocument/fpml:party[@id=$swbMandatoryClearing[swml:swbJurisdiction='FCA' ]/swml:swbPartyExemption[2]/swml:partyReference/@href]/fpml:partyId"/>
<xsl:with-param name="FCAClearingExemptIndicator2Value"   select="$swbMandatoryClearing[swml:swbJurisdiction='FCA']/swml:swbPartyExemption[2]/swml:swbExemption"/>
<xsl:with-param name="HKMAMandatoryClearingIndicator"      select="$swbMandatoryClearing[swml:swbJurisdiction='HKMA']/swml:swbMandatoryClearingIndicator"/>
<xsl:with-param name="HKMAClearingExemptIndicator1PartyId" select="$swStructuredTradeDetails/fpml:dataDocument/fpml:party[@id=$swbMandatoryClearing[swml:swbJurisdiction='HKMA' ]/swml:swbPartyExemption[1]/swml:partyReference/@href]/fpml:partyId"/>
<xsl:with-param name="HKMAClearingExemptIndicator1Value"   select="$swbMandatoryClearing[swml:swbJurisdiction='HKMA']/swml:swbPartyExemption[1]/swml:swbExemption"/>
<xsl:with-param name="HKMAClearingExemptIndicator2PartyId" select="$swStructuredTradeDetails/fpml:dataDocument/fpml:party[@id=$swbMandatoryClearing[swml:swbJurisdiction='HKMA' ]/swml:swbPartyExemption[2]/swml:partyReference/@href]/fpml:partyId"/>
<xsl:with-param name="HKMAClearingExemptIndicator2Value"   select="$swbMandatoryClearing[swml:swbJurisdiction='HKMA']/swml:swbPartyExemption[2]/swml:swbExemption"/>
<xsl:with-param name="JFSAMandatoryClearingIndicator"      select="$swbMandatoryClearing[swml:swbJurisdiction='JFSA']/swml:swbMandatoryClearingIndicator"/>
<xsl:with-param name="MASMandatoryClearingIndicator"      select="$swbMandatoryClearing[swml:swbJurisdiction='MAS']/swml:swbMandatoryClearingIndicator"/>
<xsl:with-param name="CFTCMandatoryClearingIndicator"      select="$swbMandatoryClearing[swml:swbJurisdiction='DoddFrank']/swml:swbMandatoryClearingIndicator"/>
<xsl:with-param name="CFTCClearingExemptIndicator1PartyId" select="$swStructuredTradeDetails/fpml:dataDocument/fpml:party[@id=$swbMandatoryClearing[swml:swbJurisdiction='DoddFrank' ]/swml:swbPartyExemption[1]/swml:partyReference/@href]/fpml:partyId"/>
<xsl:with-param name="CFTCClearingExemptIndicator1Value"   select="$swbMandatoryClearing[swml:swbJurisdiction='DoddFrank']/swml:swbPartyExemption[1]/swml:swbExemption"/>
<xsl:with-param name="CFTCClearingExemptIndicator2PartyId" select="$swStructuredTradeDetails/fpml:dataDocument/fpml:party[@id=$swbMandatoryClearing[swml:swbJurisdiction='DoddFrank' ]/swml:swbPartyExemption[2]/swml:partyReference/@href]/fpml:partyId"/>
<xsl:with-param name="CFTCClearingExemptIndicator2Value"   select="$swbMandatoryClearing[swml:swbJurisdiction='DoddFrank']/swml:swbPartyExemption[2]/swml:swbExemption"/>
<xsl:with-param name="CFTCInterAffiliateExemption"         select="$swbMandatoryClearing[swml:swbJurisdiction='DoddFrank']/swml:swbInterAffiliateExemption"/>
</xsl:call-template>
</xsl:template>
</xsl:stylesheet>
