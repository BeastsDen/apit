<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fpml="http://www.fpml.org/2009/FpML-4-6" exclude-result-prefixes="fpml common" version="1.0" xmlns:common="http://exslt.org/common">
<xsl:import href="CrossAssetValidation.xsl"/>
<xsl:import href="swbml-validation-reporting.xsl"/>
<xsl:variable name="version">
<xsl:value-of select="/fpml:SWBML/@version"/>
</xsl:variable>
<xsl:variable name="assetClass">Credit</xsl:variable>
<xsl:variable name="productType">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:swbProductType"/>
</xsl:variable>
<xsl:variable name="FpMLVersion">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/@version"/>
</xsl:variable>
<xsl:variable name="tradeCurrency">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:protectionTerms/fpml:calculationAmount/fpml:currency"/>
</xsl:variable>
<xsl:variable name="tranche">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:indexReferenceInformation/fpml:tranche"/>
</xsl:variable>
<xsl:variable name="brokerConfirmationType">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:brokerConfirmation/fpml:brokerConfirmationType"/>
</xsl:variable>
<xsl:variable name="isAllocatedTrade">
<xsl:choose>
<xsl:when test="/fpml:SWBML//fpml:swbAllocations">1</xsl:when>
<xsl:otherwise>0</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="isEmptyBlockTrade">
<xsl:choose>
<xsl:when test="/fpml:SWBML//fpml:swbBlockTrade">1</xsl:when>
<xsl:otherwise>0</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="blockIndependentAmountCurrency">
<xsl:if test="/fpml:SWBML//fpml:swbStructuredTradeDetails//fpml:collateral">
<xsl:value-of select="/fpml:SWBML//fpml:swbStructuredTradeDetails//fpml:collateral/fpml:independentAmount/fpml:paymentDetail/fpml:paymentAmount/fpml:currency"/>
</xsl:if>
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
<xsl:apply-templates select="fpml:swbGiveUp">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:swbAllocations">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:swbStructuredTradeDetails">
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
<xsl:if test="$isPrimeBrokerTrade=0 and count(fpml:swbRecipient) != 2">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected number of swbRecipient child elements encountered. Exactly 2 expected (<xsl:value-of select="count(fpml:swbRecipient)"/> found).</text></error>
</xsl:if>
<xsl:variable name="href1"><xsl:value-of select="fpml:swbRecipient[1]/fpml:partyReference/@href"/></xsl:variable>
<xsl:variable name="href2"><xsl:value-of select="fpml:swbRecipient[2]/fpml:partyReference/@href"/></xsl:variable>
<xsl:if test="$href1=$href2"><error><context><xsl:value-of select="$newContext"/></context><text>*** swbRecipient[1]/partyReference/@href and swbRecipient[2]/partyReference/@href values are the same.</text></error></xsl:if>
<xsl:variable name="swbBrokerTradeId"><xsl:value-of select="fpml:swbBrokerTradeId"/></xsl:variable>
<xsl:if test="$swbBrokerTradeId=''"><error><context><xsl:value-of select="$newContext"/></context><text>*** Empty swbBrokerTradeId element.</text></error></xsl:if>
<xsl:if test="string-length($swbBrokerTradeId) &gt; 50"><error><context><xsl:value-of select="$newContext"/></context><text>*** Invalid swbBrokerTradeId element value length. Exceeded max length of 50 characters.</text></error></xsl:if>
<xsl:if test="fpml:swbBrokerLegId">
<xsl:variable name="swbBrokerLegId"><xsl:value-of select="fpml:swbBrokerLegId"/></xsl:variable>
<xsl:if test="$swbBrokerLegId=''">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Empty swbBrokerLegId element.</text></error>
</xsl:if>
<xsl:if test="string-length($swbBrokerLegId) &gt; 20">
<error><context><xsl:value-of select="$newContext"/>    </context><text>*** Invalid swbBrokerLegId element value length. Exceeded max length of 20 characters.</text></error>
</xsl:if>
</xsl:if>
<xsl:variable name="swbBrokerTradeVersionId"><xsl:value-of select="fpml:swbBrokerTradeVersionId"/></xsl:variable>
<xsl:if test="$swbBrokerTradeVersionId=''"><error><context><xsl:value-of select="$newContext"/></context><text>*** Empty swbBrokerTradeVersionId element.</text></error></xsl:if>
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
<xsl:apply-templates select="fpml:swbRecipient">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:swbRecipient">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:variable name="id"><xsl:value-of select="./@id"/></xsl:variable>
<xsl:choose>
<xsl:when test="$id != ''"/>
<xsl:otherwise><error><context><xsl:value-of select="$newContext"/></context><text>*** Empty swbRecipient/@id attribute.</text></error></xsl:otherwise>
</xsl:choose>
<xsl:if test="contains($id,' ')"><error><context><xsl:value-of select="$newContext"/></context><text>*** Invalid swbRecipient/@id value. Space characters are not allowed. Value = '<xsl:value-of select="$id"/>'.</text></error></xsl:if>
<xsl:if test="string-length($id) &gt; 40"><error><context><xsl:value-of select="$newContext"/></context><text>*** Invalid swbRecipient/@id attribute value length. Exceeded max length of 40 characters.</text></error></xsl:if>
<xsl:if test="$isPrimeBrokerTrade=0">
<xsl:if test="$productType = 'CDS' or $productType = 'CDS Index' or $productType = 'CDS Master' or $productType = 'CDS Matrix'">
<xsl:choose>
<xsl:when test="fpml:partyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:buyerPartyReference/@href"/>
<xsl:when test="fpml:partyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:sellerPartyReference/@href"/>
<xsl:otherwise>
<error><context><xsl:value-of select="$newContext"/></context><text>*** Invalid partyReference/@href attribute value. Value = '<xsl:value-of select='fpml:partyReference/@href'/>'.</text></error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:swbExecutionMode">
<xsl:choose>
<xsl:when test="fpml:swbExecutionMode='Voice'"/>
<xsl:when test="fpml:swbExecutionMode='Electronic'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbExecutionMode must contain a value of either Voice or Electronic. Value = '<xsl:value-of select="fpml:swbExecutionMode"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:swbGiveUp">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:variable name="hrefC">
<xsl:value-of select="fpml:swbCustomerTransaction/fpml:swbCustomer/@href"/>
</xsl:variable>
<xsl:variable name="hrefD">
<xsl:value-of select="fpml:swbInterDealerTransaction/fpml:swbExecutingDealer/@href"/>
</xsl:variable>
<xsl:variable name="hrefCPB">
<xsl:value-of select="fpml:swbCustomerTransaction/fpml:swbPrimeBroker/@href"/>
</xsl:variable>
<xsl:variable name="hrefDPB">
<xsl:value-of select="fpml:swbInterDealerTransaction/fpml:swbPrimeBroker/@href"/>
</xsl:variable>
<xsl:variable name="hrefG">
<xsl:value-of select="fpml:swbExecutingDealerCustomerTransaction/fpml:swbExecutingDealer/@href"/>
</xsl:variable>
<xsl:if test="$hrefD != 'partyA'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***  Invalid party reference specified for Executing Dealer. Expecting 'partyA'. Value = '<xsl:value-of select="$hrefD"/>'.***.</text>
</error>
</xsl:if>
<xsl:if test="$hrefC != 'partyB'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***  Invalid party reference specified for Customer. Expecting 'partyB'. Value = '<xsl:value-of select="$hrefC"/>'.***.</text>
</error>
</xsl:if>
<xsl:if test="not($productType='CDS Index' or $productType='CDS Matrix') and ($isPrimeBrokerTrade='1')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***  Broker submission of prime brokered trades is only supported for CDS Index and CDS Matrix products***.</text>
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
<xsl:if test="fpml:swbExecutingDealerCustomerTransaction">
<xsl:if test="not(//fpml:FpML/fpml:party[@id=$hrefG])">
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
<text>*** swbCustomerTransaction/swbCustomer/@href and swbCustomerTransaction/swPrimeBroker/@href values must not be the same.</text>
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
<xsl:if test="not(//fpml:FpML/fpml:party[@id=$hrefC])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbCustomerTransaction/swbCustomer/@href does not reference a valid FpML/trade/party/@id. Value = '<xsl:value-of select="$hrefC"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not(//fpml:FpML/fpml:party[@id=$hrefCPB])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbCustomerTransaction/swbPrimeBroker/@href does not reference a valid FpML/trade/party/@id. Value = '<xsl:value-of select="$hrefCPB"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not(//fpml:FpML/fpml:party[@id=$hrefD])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbInterDealerTransaction/swbExecutingDealer/@href does not reference a valid FpML/trade/party/@id. Value = '<xsl:value-of select="$hrefD"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not(//fpml:FpML/fpml:party[@id=$hrefDPB])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbInterDealerTransaction/swbPrimeBroker/@href does not reference a valid /FpML/trade/party/@id. Value = '<xsl:value-of select="$hrefDPB"/>'.</text>
</error>
</xsl:if>
<xsl:if test="$productType = 'CDS Index' or $productType = 'CDS Matrix'">
<xsl:if test="($hrefD != //fpml:FpML/fpml:trade//fpml:creditDefaultSwap/fpml:generalTerms/fpml:buyerPartyReference/@href) and ($hrefD != //fpml:FpML/fpml:trade//fpml:creditDefaultSwap/fpml:generalTerms/fpml:sellerPartyReference/@href)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbInterDealerTransaction/swbExecutingDealer/@href must be a seller or buyer if product type is 'CDS Index' or 'CDS Matrix'. </text>
</error>
</xsl:if>
<xsl:if test="($hrefC != //fpml:FpML/fpml:trade//fpml:creditDefaultSwap/fpml:generalTerms/fpml:buyerPartyReference/@href) and ($hrefC != //fpml:FpML/fpml:trade//fpml:creditDefaultSwap/fpml:generalTerms/fpml:sellerPartyReference/@href)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbCustomerTransaction/swbCustomer/@href must be a buyer or seller if product type is 'CDS Index' or 'CDS Matrix'. </text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$productType = 'CDS Index' or $productType='CDS Matrix'">
<xsl:if test=".//fpml:swEarlyTerminationProvision">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** ./swEarlyTerminationProvision must not be specified in a Primary Prime Brokered Trade.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:swbAllocations">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="($isAllocatedTrade='1') and ($isEmptyBlockTrade='1')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swbBlockTrade and swbAllocations are mutually exclusive and must not be present. Please revise and resubmit***.</text>
</error>
</xsl:if>
<xsl:if test="not($productType='CDS Index' or $productType='CDS Matrix') and ($isAllocatedTrade='1')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***  Broker submission of allocated trades is only supported for CDS Index and CDS Matrix products***.</text>
</error>
</xsl:if>
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
<xsl:variable name="buyerPartyRef">
<xsl:value-of select="fpml:buyerPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="sellerPartyRef">
<xsl:value-of select="fpml:sellerPartyReference/@href"/>
</xsl:variable>
<xsl:variable name="reportingAllocationData.rtf">
<xsl:apply-templates select="fpml:swbAllocationReportingDetails/node()" mode="mapReportingData"/>
</xsl:variable>
<xsl:if test="$buyerPartyRef=$sellerPartyRef">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** fpml:buyerPartyReference/@href and sellerPartyReference/@href values must not be the same.</text>
</error>
</xsl:if>
<xsl:if test="not(//fpml:FpML/fpml:party[@id=$buyerPartyRef])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** fpml:buyerPartyReference/@href does not reference a valid FpML/trade/party/@id. Value = '<xsl:value-of select="$buyerPartyRef"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not(//fpml:FpML/fpml:party[@id=$sellerPartyRef])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** sellerPartyReference/@href does not reference a valid FpML/trade/party/@id. Value = '<xsl:value-of select="$sellerPartyRef"/>'.</text>
</error>
</xsl:if>
<xsl:variable name="buyerPartyId">
<xsl:value-of select="//fpml:FpML/fpml:party[@id=$buyerPartyRef]/fpml:partyId"/>
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
<xsl:if test="fpml:swbPartyNettingString[2]">
<xsl:variable name="NettingParty">
<xsl:value-of select="fpml:swbPartyNettingString[1]/fpml:partyReference/@href"/>
</xsl:variable>
<xsl:variable name="NettingParty2">
<xsl:value-of select="fpml:swbPartyNettingString[2]/fpml:partyReference/@href"/>
</xsl:variable>
<xsl:if test="$NettingParty = $NettingParty2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Duplicate Allocation partyReference/@href for nettng String is not allowed.</text>
</error>
</xsl:if>
<xsl:if test="($NettingParty != $buyerPartyRef) and ($NettingParty != $sellerPartyRef)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Allocation partyReference/@href for nettng String does not reference the Buyer / Seller party reference.</text>
</error>
</xsl:if>
<xsl:if test="($NettingParty2 != $buyerPartyRef) and ($NettingParty2 != $sellerPartyRef)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Allocation partyReference/@href for nettng String does not reference the Buyer / Seller party reference.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:swbPartyCreditAcceptanceToken[2]">
<xsl:variable name="CreditAcceptanceParty">
<xsl:value-of select="fpml:swbPartyCreditAcceptanceToken[1]/fpml:partyReference/@href"/>
</xsl:variable>
<xsl:variable name="CreditAcceptanceParty2">
<xsl:value-of select="fpml:swbPartyCreditAcceptanceToken[2]/fpml:partyReference/@href"/>
</xsl:variable>
<xsl:if test="$CreditAcceptanceParty = $CreditAcceptanceParty2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Duplicate Allocation partyReference/@href for credit acceptance token is not allowed.</text>
</error>
</xsl:if>
<xsl:if test="($CreditAcceptanceParty != $buyerPartyRef) and ($CreditAcceptanceParty != $sellerPartyRef)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Allocation partyReference/@href for credit acceptance token does not reference the Buyer / Seller party reference.</text>
</error>
</xsl:if>
<xsl:if test="($CreditAcceptanceParty2 != $buyerPartyRef) and ($CreditAcceptanceParty2 != $sellerPartyRef)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Allocation partyReference/@href for credit acceptance token does not reference the Buyer / Seller party reference.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:allocatedNotional">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
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
<xsl:variable name="messageText">
<xsl:value-of select="fpml:swbBrokerTradeId"/>
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
<xsl:template match="fpml:allocatedNotional">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:variable name="allocatedNotionalCurrency">
<xsl:value-of select="fpml:currency"/>
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
<xsl:if test="$allocatedNotionalCurrency != $tradeCurrency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** AllocatedNotional/currency must be the same as the block notional currency within an allocated trade. Value = '<xsl:value-of select="$allocatedNotionalCurrency"/>'.</text>
</error>
</xsl:if>
<xsl:variable name="amount">
<xsl:value-of select="fpml:amount"/>
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
<xsl:apply-templates select="fpml:paymentAmount">
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
<xsl:variable name="amount">
<xsl:value-of select="fpml:amount"/>
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
<xsl:template match="fpml:swbStructuredTradeDetails">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:call-template name="isValidProductType">
<xsl:with-param name="elementName">swbProductType</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:swbProductType"/></xsl:with-param>
<xsl:with-param name="testNumber"></xsl:with-param>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
<xsl:apply-templates select="fpml:FpML">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="not(fpml:swbExtendedTradeDetails/fpml:swbProductTerm) and ($productType='CDS' or $productType='CDS Master' or $productType='CDS Matrix')">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Missing swbExtendedTradeDetails/swbProductTerm element. Element must be present if product type is 'CDS'  or 'CDS Master' or 'CDS Matrix'.</text></error>
</xsl:if>
<xsl:apply-templates select="fpml:swbExtendedTradeDetails">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:swbBusinessConductDetails">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:FpML">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="not($FpMLVersion='4-6')">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Invalid version attribute. Value = '<xsl:value-of select="$FpMLVersion"/>'.</text></error>
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
<xsl:if test="$isAllocatedTrade=1 or $isPrimeBrokerTrade=1">
<xsl:if test="not(count(fpml:party) &gt;2)">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected number of party child elements encountered. 3 or more expected (<xsl:value-of select="count(fpml:party)"/> found).</text></error>
</xsl:if>
</xsl:if>
<xsl:if test="$isAllocatedTrade=0 and $isPrimeBrokerTrade=0">
<xsl:if test="(not(count(fpml:party)=3 or count(fpml:party)=4))">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected number of party child elements encountered. 3 or 4 expected (<xsl:value-of select="count(fpml:party)"/> found).</text></error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:trade">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:portfolio">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected portfolio element encountered in this context.</text></error>
</xsl:if>
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
<xsl:if test="fpml:otherPartyPayment[2]">
<xsl:variable name="href1"><xsl:value-of select="fpml:otherPartyPayment[1]/fpml:payerPartyReference/@href"/></xsl:variable>
<xsl:variable name="href2"><xsl:value-of select="fpml:otherPartyPayment[2]/fpml:payerPartyReference/@href"/></xsl:variable>
<xsl:if test="$href1=$href2">
<error><context><xsl:value-of select="$newContext"/></context><text>*** otherPartyPayment[1]/payerPartyReference/@href and otherPartyPayment[2]/payerPartyReference/@href must not be the same.</text></error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:tradeHeader">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="$productType='CDS'  or $productType='CDS Matrix'or $productType='CDS Index' or $productType='CDS Master'">
<xsl:if test="not(fpml:creditDefaultSwap)">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Missing creditDefaultSwap element. Element must be present if product type is 'CDS', 'CDS Index', 'CDS Master' or 'CDS Matrix'.</text></error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:creditDefaultSwap">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:otherPartyPayment">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:calculationAgent and $productType!='CDS Index' and $productType!='CDS Matrix'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected calculationAgent element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:calculationAgentBusinessCenter">
<xsl:call-template name="isValidBusinessCenter">
<xsl:with-param name="elementName">calculationAgentBusinessCenter</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:calculationAgentBusinessCenter"/></xsl:with-param>
<xsl:with-param name="testNumber"></xsl:with-param>
<xsl:with-param name="assetClass"><xsl:value-of select="$assetClass"/></xsl:with-param>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="not(fpml:brokerPartyReference)">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Missing brokerPartyReference element.</text></error>
</xsl:if>
<xsl:apply-templates select="fpml:brokerPartyReference">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:collateral">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="not(fpml:documentation)">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Missing documentation element.</text></error>
</xsl:if>
<xsl:apply-templates select="fpml:documentation">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:governingLaw">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected governingLaw element encountered in this context.</text></error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:brokerPartyReference">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:variable name="broker"><xsl:value-of select="@href"/></xsl:variable>
<xsl:if test="not(/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:party[@id=$broker])">
<error><context><xsl:value-of select="$newContext"/></context><text>*** The brokerPartyReference/@href value does not match an //FpML/party/@id value for any party. Value = '<xsl:value-of select="$broker"/>'.</text></error>
</xsl:if>
<xsl:if test="$productType='CDS' or $productType='CDS Index' or $productType='CDS Master' or $productType='CDS Matrix'">
<xsl:choose>
<xsl:when test="$broker=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:buyerPartyReference/@href">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Invalid brokerPartyReference/@href attribute value. Value = '<xsl:value-of select='$broker'/>'.</text></error>
</xsl:when>
<xsl:when test="$broker=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:sellerPartyReference/@href">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Invalid brokerPartyReference/@href attribute value. Value = '<xsl:value-of select='$broker'/>'.</text></error>
</xsl:when>
<xsl:otherwise/>
</xsl:choose>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:collateral">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:apply-templates select="fpml:independentAmount">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
<xsl:with-param name="allocPartyA">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:sellerPartyReference/@href"/>
</xsl:with-param>
<xsl:with-param name="allocPartyB">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:buyerPartyReference/@href"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:documentation">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="masterAgreement"><xsl:value-of select="fpml:masterAgreement"/></xsl:variable>
<xsl:variable name="contractualTermsSupplement"><xsl:value-of select="fpml:contractualTermsSupplement"/></xsl:variable>
<xsl:variable name="masterConfirmation"><xsl:value-of select="fpml:masterConfirmation"/></xsl:variable>
<xsl:variable name="brokerConfirmation"><xsl:value-of select="fpml:brokerConfirmation"/></xsl:variable>
<xsl:if test="$productType='CDS Index' or $productType='CDS Matrix' or $productType='CDS Master'">
<xsl:if test="$masterAgreement != ''">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected masterAgreement element in this context.</text></error>
</xsl:if>
<xsl:if test="$contractualTermsSupplement !=''">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected contractualTermsSupplement element in this context.</text></error>
</xsl:if>
<xsl:if test="$masterConfirmation !=''">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected masterConfirmation element in this context.</text></error>
</xsl:if>
<xsl:if test="$brokerConfirmation =''">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Missing brokerConfirmation element.</text></error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:masterAgreement">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:brokerConfirmation">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:variable name="contractualDefinitions"><xsl:value-of select="fpml:contractualDefinitions"/></xsl:variable>
<xsl:if test="$contractualDefinitions != '' and $contractualDefinitions != 'ISDA2003Credit' and $contractualDefinitions != 'ISDA2006' and $contractualDefinitions != 'ISDA2014Credit' ">
<error><context><xsl:value-of select="$newContext"/></context><text>*** contractualDefinitions must equal 'ISDA2003Credit', 'ISDA2006' or 'ISDA2014Credit'.  Value = '<xsl:value-of select="$contractualDefinitions"/>'.</text></error>
</xsl:if>
<xsl:for-each select="fpml:contractualSupplement">
<xsl:call-template name="isValidcontractualSupplement">
<xsl:with-param name="elementName">contractualSupplement</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="."/></xsl:with-param>
<xsl:with-param name="testNumber"></xsl:with-param>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
</xsl:for-each>
<xsl:if test="$brokerConfirmationType = 'NorthAmericaMonolineInsurer'">
<xsl:if test="not(fpml:contractualSupplement[.='ISDACreditMonolineInsurers'])">
<error><context><xsl:value-of select="$newContext"/></context><text>*** A contractualSupplement element containing 'ISDACreditMonolineInsurers' must be present if brokerConfirmationType contains 'NorthAmericaMonolineInsurer'.</text></error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:contractualSupplement[.='ISDACreditMonolineInsurers']">
<xsl:if test="not($brokerConfirmationType = 'NorthAmericaMonolineInsurer')">
<error><context><xsl:value-of select="$newContext"/></context><text>*** A contractualSupplement element containing 'ISDACreditMonolineInsurers' must only be present if brokerConfirmationType contains 'NorthAmericaMonolineInsurer'.</text></error>
</xsl:if>
</xsl:if>
<xsl:if test="$productType='CDS' or $productType='CDS Index' or $productType='CDS Master'">
<xsl:if test="fpml:contractualMatrix">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected contractualMatrix element encountered in this context.</text></error>
</xsl:if>
</xsl:if>
<xsl:if test="$productType='CDS Master'">
<xsl:if test="(fpml:contractualSupplement[.='ISDACreditMonolineInsurers'])">
<error><context><xsl:value-of select="$newContext"/></context>
<text>*** 'CDS Master' trades are not allowed with contractualSupplement of 'ISDACreditMonolineInsurers' </text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:creditSupportDocument">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected creditSupportDocument element encountered in this context.</text></error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:brokerConfirmation">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="$productType = 'CDS'">
<xsl:call-template name="isValidCDSConfirmationType">
<xsl:with-param name="elementName">brokerConfirmationType</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:brokerConfirmationType"/></xsl:with-param>
<xsl:with-param name="testNumber"></xsl:with-param>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="$productType = 'CDS Matrix'">
<xsl:call-template name="isValidCDSMatrixConfirmationType">
<xsl:with-param name="elementName">brokerConfirmationType</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:brokerConfirmationType"/></xsl:with-param>
<xsl:with-param name="testNumber"></xsl:with-param>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="$productType = 'CDS Index'">
<xsl:call-template name="isValidCDSIndexConfirmationType">
<xsl:with-param name="elementName">brokerConfirmationType</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:brokerConfirmationType"/></xsl:with-param>
<xsl:with-param name="testNumber"></xsl:with-param>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="$productType = 'CDS Master'">
<xsl:call-template name="isValidCDSMasterConfirmationType">
<xsl:with-param name="elementName">brokerConfirmationType</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:brokerConfirmationType"/></xsl:with-param>
<xsl:with-param name="testNumber"></xsl:with-param>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:masterAgreement">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:call-template name="isValidMasterAgreementType">
<xsl:with-param name="elementName">masterAgreementType</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:masterAgreementType"/></xsl:with-param>
<xsl:with-param name="testNumber"></xsl:with-param>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
<xsl:if test="fpml:masterAgreementDate and $productType !='CDS Index'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected masterAgreementDate element encountered in this context.</text></error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:swbExtendedTradeDetails">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:apply-templates select="node()/fpml:swbMandatoryClearing">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:swbTradeHeader/fpml:swbOriginatingEvent">
<xsl:choose>
<xsl:when test="fpml:swbTradeHeader/fpml:swbOriginatingEvent=''"/>
<xsl:when test="fpml:swbTradeHeader/fpml:swbOriginatingEvent='Bunched Order Block'"/>
<xsl:when test="fpml:swbTradeHeader/fpml:swbOriginatingEvent='Bunched Order Allocation'"/>
<xsl:when test="fpml:swbTradeHeader/fpml:swbOriginatingEvent='Trade'"/>
<xsl:when test="fpml:swbTradeHeader/fpml:swbOriginatingEvent='Exercise'"/>
<xsl:when test="fpml:swbTradeHeader/fpml:swbOriginatingEvent='Novation'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***swOriginatingEvent element value is not supported. Supported values are '', 'Bunched Order Block', 'Bunched Order Allocation', 'Trade', 'Exercise', 'Novation'. Value = '<xsl:value-of select="fpml:swbTradeHeader/fpml:swbOriginatingEvent"/>'."/>
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
<text>*** partyReference/@href for nettng String does not reference a valid FpML//party/@id.</text>
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
<xsl:if test="fpml:swbTradeHeader/fpml:swbPartyTraderId">
<xsl:variable name="CMEAccountParty">
<xsl:value-of select="fpml:swbTradeHeader/fpml:swbPartyTraderId/fpml:partyReference/@href"/>
</xsl:variable>
<xsl:if test="not(//fpml:FpML/fpml:party[@id=$CMEAccountParty])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** partyReference/@href for CME Account Trader Id does not reference a valid FpML//party/@id.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:swbTradeHeader/fpml:swbPartyTraderId">
<xsl:if test="count(fpml:swbTradeHeader/fpml:swbPartyTraderId)!=2">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***CME Account Trader Id should be specified for both the parties involved in the trade</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:swbProductTerm and $productType='CDS Index'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected swbProductTerm element. Element must not be present if product type is 'CDS Index'.</text></error>
</xsl:if>
<xsl:apply-templates select="fpml:swbProductTerm">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:swbMessageText">
<xsl:if test="fpml:swbMessageText=''">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Empty swbMessageText element.</text></error>
</xsl:if>
</xsl:if>
<xsl:variable name="messageText"><xsl:value-of select="fpml:swbMessageText"/></xsl:variable>
<xsl:if test="string-length($messageText) &gt; 200"><error><context><xsl:value-of select="$newContext"/></context><text>*** Invalid swbMessageText string length. Exceeded max length of 200 characters.</text></error></xsl:if>
</xsl:template>
<xsl:template match="fpml:swbProductTerm">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="period"><xsl:value-of select="fpml:period"/></xsl:variable>
<xsl:if test="not($period='M' or $period='Y')"><error><context><xsl:value-of select="$newContext"/></context><text>*** period must be equal to 'M' or 'Y'. Value = '<xsl:value-of select="$period"/>'</text></error></xsl:if>
<xsl:variable name="periodMultiplier"><xsl:value-of select="fpml:periodMultiplier"/></xsl:variable>
<xsl:if test="$period='M'">
<xsl:call-template name="isValidIntegerNumber">
<xsl:with-param name="elementName">periodMultiplier</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="$periodMultiplier"/></xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">11999</xsl:with-param>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="$period='Y'">
<xsl:call-template name="isValidIntegerNumber">
<xsl:with-param name="elementName">periodMultiplier</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="$periodMultiplier"/></xsl:with-param>
<xsl:with-param name="minIncl">1</xsl:with-param>
<xsl:with-param name="maxIncl">999</xsl:with-param>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:tradeHeader">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="count(fpml:partyTradeIdentifier) != 2"><error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected number of partyTradeIdentifier child elements encountered. Exactly 2 expected.</text></error></xsl:if>
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
<xsl:if test="$productType = 'CDS' or $productType = 'CDS Index' or $productType='CDS Master' or $productType='CDS Matrix'">
<xsl:choose>
<xsl:when test="fpml:partyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:buyerPartyReference/@href"/>
<xsl:when test="fpml:partyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:sellerPartyReference/@href"/>
<xsl:otherwise>
<error><context><xsl:value-of select="$newContext"/></context><text>*** Invalid partyReference/@href attribute value. Value = '<xsl:value-of select='fpml:partyReference/@href'/>'.</text></error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:variable name="tradeIdScheme"><xsl:value-of select="fpml:tradeId/@tradeIdScheme"/></xsl:variable>
<xsl:if test="$tradeIdScheme=''">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Missing or empty tradeId/@tradeIdScheme attribute.</text></error>
</xsl:if>
<xsl:variable name="tradeId"><xsl:value-of select="fpml:tradeId"/></xsl:variable>
<xsl:if test="$tradeId=''"><error><context><xsl:value-of select="$newContext"/></context><text>*** Empty tradeId element.</text></error></xsl:if>
<xsl:if test="fpml:linkId">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected linkId element encountered in this context.</text></error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:partyTradeInformation">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:if test="fpml:partyReference/@href and ($productType = 'CDS' or $productType = 'CDS Index')">
<xsl:choose>
<xsl:when test="fpml:partyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:buyerPartyReference/@href"/>
<xsl:when test="fpml:partyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:sellerPartyReference/@href"/>
<xsl:otherwise>
<error><context><xsl:value-of select="$newContext"/></context><text>*** Invalid partyReference/@href attribute value. Value = '<xsl:value-of select='fpml:partyReference/@href'/>'.</text></error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="fpml:trader">
<xsl:if test="fpml:trader=''">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Empty trader element.</text></error>
</xsl:if>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:adjustableDate">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:apply-templates select="fpml:dateAdjustments">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:party">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:if test="not(fpml:partyId)"><error><context><xsl:value-of select="$newContext"/></context><text>*** Missing partyId element.</text></error></xsl:if>
<xsl:if test="not(string-length(fpml:partyId) = string-length(normalize-space(fpml:partyId)))">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Invalid partyId element.</text></error></xsl:if>
<xsl:variable name="partyName"><xsl:value-of select="fpml:partyName"/></xsl:variable>
<xsl:if test="fpml:partyName">
<xsl:if test="$partyName=''"><error><context><xsl:value-of select="$newContext"/></context><text>*** Empty partyName element.</text></error></xsl:if>
</xsl:if>
<xsl:if test="string-length($partyName) &gt; 200"><error><context><xsl:value-of select="$newContext"/></context><text>*** Invalid partyName string length. Exceeded max length of 200 characters.</text></error></xsl:if>
</xsl:template>
<xsl:template match="fpml:otherPartyPayment">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:if test="$productType='CDS' or $productType='CDS Index' or $productType='CDS Master' or $productType = 'CDS Matrix'">
<xsl:choose>
<xsl:when test="fpml:payerPartyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:buyerPartyReference/@href"/>
<xsl:when test="fpml:payerPartyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:sellerPartyReference/@href"/>
<xsl:otherwise>
<error><context><xsl:value-of select="$newContext"/></context><text>*** Invalid payerPartyReference/@href attribute value. Value = '<xsl:value-of select='fpml:payerPartyReference/@href'/>'.</text></error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="$productType='CDS' or $productType='CDS Index' or $productType='CDS Master' or $productType = 'CDS Matrix'">
<xsl:choose>
<xsl:when test="fpml:receiverPartyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:buyerPartyReference/@href">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Invalid receiverPartyReference/@href attribute value. Value = '<xsl:value-of select='fpml:receiverPartyReference/@href'/>'.</text></error>
</xsl:when>
<xsl:when test="fpml:receiverPartyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:sellerPartyReference/@href">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Invalid receiverPartyReference/@href attribute value. Value = '<xsl:value-of select='fpml:receiverPartyReference/@href'/>'.</text></error>
</xsl:when>
<xsl:otherwise/>
</xsl:choose>
</xsl:if>
<xsl:variable name="href1"><xsl:value-of select="fpml:payerPartyReference/@href"/></xsl:variable>
<xsl:variable name="href2"><xsl:value-of select="fpml:receiverPartyReference/@href"/></xsl:variable>
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
<xsl:if test="fpml:paymentType">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected paymentType element encountered in this context. Not expected for brokerage payment.</text></error>
</xsl:if>
<xsl:if test="fpml:settlementInformation">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected settlementInformation element encountered in this context. Not expected for brokerage payment.</text></error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:creditDefaultSwap">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:apply-templates select="fpml:generalTerms">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:feeLeg">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:protectionTerms">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:physicalSettlementTerms">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected physicalSettlementTerms element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:cashSettlementTerms">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected cashSettlementTerms element encountered in this context.</text></error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:generalTerms">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:apply-templates select="fpml:effectiveDate">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:scheduledTerminationDate">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:variable name="seller"><xsl:value-of select="fpml:sellerPartyReference/@href"/></xsl:variable>
<xsl:if test="not(/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:party[@id=$seller])">
<error><context><xsl:value-of select="$newContext"/></context><text>*** The sellerPartyReference/@href value does not match an //FpML/party/@id value for any party. Value = '<xsl:value-of select="$seller"/>'.</text></error>
</xsl:if>
<xsl:variable name="buyer"><xsl:value-of select="fpml:buyerPartyReference/@href"/></xsl:variable>
<xsl:if test="not(/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:party[@id=$buyer])">
<error><context><xsl:value-of select="$newContext"/></context><text>*** The buyerPartyReference/@href value does not match an //FpML/party/@id value for any party. Value = '<xsl:value-of select="$buyer"/>'.</text></error>
</xsl:if>
<xsl:if test="$buyer=$seller"><error><context><xsl:value-of select="$newContext"/></context><text>*** buyerPartyReference/@href and sellerPartyReference/@href values are the same.</text></error></xsl:if>
<xsl:if test="fpml:dateAdjustments">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected dateAdjustments element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="not(fpml:referenceInformation) and ($productType='CDS' or $productType='CDS Master' or $productType='CDS Matrix')">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Missing referenceInformation element. Element must be present if product type is 'CDS', 'CDS Master' or 'CDS Matrix'.</text></error>
</xsl:if>
<xsl:if test="not(fpml:indexReferenceInformation) and $productType='CDS Index'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Missing indexReferenceInformation element. Element must be present if product type is 'CDS Index'.</text></error>
</xsl:if>
<xsl:apply-templates select="fpml:referenceInformation">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:indexReferenceInformation">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:feeLeg">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="fpml:initialPayment and $productType='CDS'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected initialPayment element. Element must not be present if product type is 'CDS'.</text></error>
</xsl:if>
<xsl:apply-templates select="fpml:initialPayment">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:singlePayment and ($productType='CDS Index' or $productType='CDS Master' or 'CDS Matrix')">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected singlePayment element. Element must not be present if product type is 'CDS Index', 'CDS Master' or 'CDS Matrix', where initialPayment should be used.</text></error>
</xsl:if>
<xsl:if test="not(count(fpml:singlePayment)=0 or count(fpml:singlePayment)=1)">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected number of singlePayment child elements encountered. 0 or 1 expected (<xsl:value-of select="count(fpml:singlePayment)"/> found).</text></error>
</xsl:if>
<xsl:apply-templates select="fpml:singlePayment">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:periodicPayment">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="$brokerConfirmationType ='StandardNorthAmericanCorporate'">
<xsl:if test="fpml:quotationStyle">
<xsl:if test="fpml:quotationStyle = 'PointsUpFront' and not(fpml:initialPoints)">
<error><context><xsl:value-of select="$newContext"/></context><text>*** initialPoints must be present if quotationStyle is PointsUpFront.</text></error>
</xsl:if>
<xsl:if test="fpml:quotationStyle = 'TradedSpread' and not(fpml:marketFixedRate)">
<error><context><xsl:value-of select="$newContext"/></context><text>*** marketFixedRate must be present if quotationStyle is TradedSpread.</text></error>
</xsl:if>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:marketFixedRate">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">marketFixedRate</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:marketFixedRate"/></xsl:with-param>
<xsl:with-param name="minIncl">0.00000000</xsl:with-param>
<xsl:with-param name="maxIncl">999.99999999</xsl:with-param>
<xsl:with-param name="maxDecs">8</xsl:with-param>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:initialPoints">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">initialPoints</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:initialPoints"/></xsl:with-param>
<xsl:with-param name="minIncl">-9.99999999</xsl:with-param>
<xsl:with-param name="maxIncl">9.99999999</xsl:with-param>
<xsl:with-param name="maxDecs">8</xsl:with-param>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:initialPayment">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="$productType='CDS' or $productType='CDS Index' or $productType='CDS Master' or $productType='CDS Matrix'">
<xsl:choose>
<xsl:when test="fpml:payerPartyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:buyerPartyReference/@href"/>
<xsl:when test="fpml:payerPartyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:sellerPartyReference/@href"/>
<xsl:otherwise>
<error><context><xsl:value-of select="$newContext"/></context><text>*** Invalid payerPartyReference/@href attribute value. Value = '<xsl:value-of select='fpml:payerPartyReference/@href'/>'.</text></error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="$productType='CDS' or $productType='CDS Index' or $productType='CDS Master' or $productType='CDS Matrix'">
<xsl:choose>
<xsl:when test="fpml:receiverPartyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:buyerPartyReference/@href"/>
<xsl:when test="fpml:receiverPartyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:sellerPartyReference/@href"/>
<xsl:otherwise>
<error><context><xsl:value-of select="$newContext"/></context><text>*** Invalid receiverPartyReference/@href attribute value. Value = '<xsl:value-of select='fpml:receiverPartyReference/@href'/>'.</text></error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:variable name="href1"><xsl:value-of select="fpml:payerPartyReference/@href"/></xsl:variable>
<xsl:variable name="href2"><xsl:value-of select="fpml:receiverPartyReference/@href"/></xsl:variable>
<xsl:if test="$href1=$href2">
<error><context><xsl:value-of select="$newContext"/></context><text>*** payerPartyReference/@href and receiverPartyReference/@href values are the same.</text></error>
</xsl:if>
<xsl:if test="fpml:adjustablePaymentDate and ($brokerConfirmationType ='StandardNorthAmericanCorporate' or $brokerConfirmationType ='StandardEuropeanCorporate'  or $brokerConfirmationType ='StandardEuropeanLimitedRecourseCorporate' or $brokerConfirmationType ='StandardSubordinatedEuropeanInsuranceCorporate' or $brokerConfirmationType ='StandardWesternEuropeanSovereign')">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected adjustablePaymentDate element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:adjustedPaymentDate">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected adjustedPaymentDate element encountered in this context.</text></error>
</xsl:if>
<xsl:apply-templates select="fpml:paymentAmount">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:singlePayment">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:if test="fpml:adjustedPaymentDate">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected adjustedPaymentDate element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:fixedAmount/fpml:currency != $tradeCurrency">
<error><context><xsl:value-of select="$newContext"/></context><text>*** fixedAmount/currency must equal //FpML/trade/creditDefaultSwap/protectionTerms/calculationAmount/currency.</text></error>
</xsl:if>
<xsl:apply-templates select="fpml:fixedAmount">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:calculationAmount|fpml:fixedAmount">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:call-template name="isValidCurrency">
<xsl:with-param name="elementName">currency</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:currency"/></xsl:with-param>
<xsl:with-param name="testNumber"></xsl:with-param>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">amount</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:amount"/></xsl:with-param>
<xsl:with-param name="minIncl">0.01</xsl:with-param>
<xsl:with-param name="maxIncl">3999999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
</xsl:template>
<xsl:template match="fpml:paymentAmount">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="ancestor::fpml:otherPartyPayment">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">amount</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:amount"/></xsl:with-param>
<xsl:with-param name="minIncl">0.00</xsl:with-param>
<xsl:with-param name="maxIncl">999999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
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
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:amount"/></xsl:with-param>
<xsl:with-param name="minIncl"><xsl:value-of select="$minIncl"/></xsl:with-param>
<xsl:with-param name="maxIncl">999999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="ancestor::fpml:independentAmount">
<xsl:call-template name="isValidCurrency">
<xsl:with-param name="elementName">currency</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:currency"/></xsl:with-param>
<xsl:with-param name="testNumber"></xsl:with-param>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:periodicPayment">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="not(fpml:paymentFrequency) and $productType='CDS'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Missing paymentFrequency element. Element must be present if product type is 'CDS'.</text></error>
</xsl:if>
<xsl:if test="(fpml:firstPaymentDate or fpml:lastRegularPaymentDate or fpml:rollConvention) and $productType='CDS Index'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected firstPaymentDate, lastRegularPaymentDate or rollConvention element. Elements must not be present if product type is 'CDS Index'.</text></error>
</xsl:if>
<xsl:apply-templates select="fpml:paymentFrequency">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="$productType = 'CDS'">
<xsl:call-template name="isValidRollConvention">
<xsl:with-param name="elementName">rollConvention</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:rollConvention"/></xsl:with-param>
<xsl:with-param name="testNumber"></xsl:with-param>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:fixedAmount">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected fixedAmount element encountered in this context.</text></error>
</xsl:if>
<xsl:apply-templates select="fpml:fixedAmountCalculation">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:adjustedPaymentDates">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected adjustedPaymentDates element encountered in this context.</text></error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:paymentFrequency">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="freq"><xsl:value-of select="fpml:periodMultiplier"/><xsl:value-of select="fpml:period"/></xsl:variable>
<xsl:if test="$productType='CDS'">
<xsl:choose>
<xsl:when test="$freq='3M'"/>
<xsl:when test="$freq='6M'"/>
<xsl:otherwise><error><context><xsl:value-of select="$newContext"/></context><text>*** paymentFrequency must be equal to 3M or 6M if product type is 'CDS', 'CDS Master' or 'CDS Matrix'. Value = '<xsl:value-of select="$freq"/>'.</text></error></xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:fixedAmountCalculation">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="fpml:calculationAmount">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected calculationAmount element encountered in this context.</text></error>
</xsl:if>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">fixedRate</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:fixedRate"/></xsl:with-param>
<xsl:with-param name="minIncl">0.00000000</xsl:with-param>
<xsl:with-param name="maxIncl">9.99999999</xsl:with-param>
<xsl:with-param name="maxDecs">8</xsl:with-param>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
</xsl:template>
<xsl:template match="fpml:protectionTerms">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:apply-templates select="fpml:calculationAmount">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:creditEvents and $productType='CDS Index'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected creditEvents element. Element must not be present if product type is 'CDS Index'.</text></error>
</xsl:if>
<xsl:apply-templates select="fpml:creditEvents">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:obligations">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected obligations element encountered in this context.</text></error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:creditEvents">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="fpml:bankruptcy">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected bankruptcy element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:failureToPay">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected failureToPay element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:failureToPayPrincipal">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected failureToPayPrincipal element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:failureToPayInterest">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected failureToPayInterest element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:obligationDefault">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected obligationDefault element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:obligationAcceleration">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected obligationAcceleration element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:repudiationMoratorium">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected repudiationMoratorium element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="$productType = 'CDS Matrix' and $brokerConfirmationType !='NorthAmericanCorporate' and $brokerConfirmationType !='StandardNorthAmericanCorporate' and  $brokerConfirmationType !='EmergingEuropeanCorporateLPN' ">
<xsl:if test="fpml:restructuring">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected restructuring element encountered in this context. Restructuring is only valid for brokerConfirmationType 'NorthAmericanCorporate' or  'StandardNorthAmericanCorporate' or 'EmergingEuropeanCorporateLPN'</text></error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:restructuring">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:distressedRatingsDowngrade">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected distressedRatingsDowngrade element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:maturityExtension">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected maturityExtension element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:writedown">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected writedown element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:defaultRequirement">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected defaultRequirement element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:creditEventNotice">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected creditEventNotice element encountered in this context.</text></error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:restructuring">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="$productType = 'CDS Matrix' or $productType = 'CDS Master'">
<xsl:if test="fpml:restructuringType">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected restructuringType element encountered in this context.</text></error>
</xsl:if>
</xsl:if>
<xsl:if test="not($productType = 'CDS Matrix' or $productType = 'CDS Master')">
<xsl:call-template name="isValidRestructuringType">
<xsl:with-param name="elementName">restructuringType</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:restructuringType"/></xsl:with-param>
<xsl:with-param name="testNumber"></xsl:with-param>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:multipleHolderObligation">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected multipleHolderObligation element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:multipleCreditEventNotices">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected multipleCreditEventNotices element encountered in this context.</text></error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:effectiveDate|fpml:scheduledTerminationDate/fpml:adjustableDate">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="$productType='CDS' or $productType='CDS Index' or $productType='CDS Master' or $productType='CDS Matrix'">
<xsl:if test="fpml:dateAdjustments">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected dateAdjustments element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:dateAdjustmentsReference">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected dateAdjustmentsReference element encountered in this context.</text></error>
</xsl:if>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:scheduledTerminationDate">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:apply-templates select="fpml:adjustableDate">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:referenceInformation">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:apply-templates select="fpml:referenceEntity">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:referenceObligation">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:allGuarantees">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected allGuarantees element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:referencePrice">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected referencePrice element encountered in this context.</text></error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:indexReferenceInformation">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="fpml:indexId">
<xsl:variable name="indexIdScheme"><xsl:value-of select="fpml:indexId/@indexIdScheme"/></xsl:variable>
<xsl:if test="$indexIdScheme != 'http://www.fpml.org/spec/2003/instrument-id-RED-pair-1-0'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Missing or unrecognised indexId/@indexIdScheme attribute. Value = '<xsl:value-of select="$indexIdScheme"/>'.</text></error>
</xsl:if>
<xsl:if test="string-length(fpml:indexId) != 9">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Invalid indexId element value length. RED index identifier must be 9 characters. Value = '<xsl:value-of select="fpml:indexId"/>'.</text></error>
</xsl:if>
</xsl:if>
<xsl:variable name="tranche"><xsl:value-of select="fpml:tranche"/></xsl:variable>
<xsl:apply-templates select="fpml:tranche">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:tranche">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="attachmentPoint"><xsl:value-of select="fpml:attachmentPoint"/></xsl:variable>
<xsl:if test="$attachmentPoint=''">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Missing attachementPoint element for a tranche.</text></error>
</xsl:if>
<xsl:variable name="ePoint"><xsl:value-of select="fpml:exhaustionPoint"/></xsl:variable>
<xsl:if test="$ePoint=''">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Missing exhaustionPoint element for a tranche.</text></error>
</xsl:if>
<xsl:if test="$attachmentPoint &lt; 0 or $attachmentPoint &gt; 1">
<error><context><xsl:value-of select="$newContext"/></context><text>*** attachementPoint must have a value between 0 and 1.</text></error>
</xsl:if>
<xsl:if test="$ePoint &lt; 0 or $ePoint &gt; 1">
<error><context><xsl:value-of select="$newContext"/></context><text>*** exhaustionPoint must have a value between 0 and 1.</text></error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:referenceEntity">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="entityName"><xsl:value-of select="fpml:entityName"/></xsl:variable>
<xsl:if test="fpml:entityId">
<xsl:variable name="entityIdScheme"><xsl:value-of select="fpml:entityId/@entityIdScheme"/></xsl:variable>
<xsl:if test="$entityIdScheme != 'http://www.fpml.org/spec/2003/entity-id-RED-1-0'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Missing or unrecognised entityId/@entityIdScheme attribute. Value = '<xsl:value-of select="$entityIdScheme"/>'.</text></error>
</xsl:if>
<xsl:if test="string-length(fpml:entityId) != 6">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Invalid entityId element value length. RED entity identifier must be 6 characters. Value = '<xsl:value-of select="fpml:entityId"/>'.</text></error>
</xsl:if>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:referenceObligation">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:apply-templates select="fpml:bond">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:convertibleBond">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected convertibleBond element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:primaryObligorReference and fpml:guarantorReference">
<error><context><xsl:value-of select="$newContext"/></context><text>*** primaryObligorReference and guarantorReference elements must not both be present.</text></error>
</xsl:if>
<xsl:if test="fpml:primaryObligor">
<xsl:if test="not(fpml:guarantorReference)">
<error><context><xsl:value-of select="$newContext"/></context><text>*** primaryObligor element must only be present if guarantorReference element is present.</text></error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:primaryObligor">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:primaryObligorReference">
<xsl:if test="not(fpml:primaryObligorReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:referenceInformation/fpml:referenceEntity/@id)">
<error><context><xsl:value-of select="$newContext"/></context><text>*** primaryObligorReference/@href must equal //FpML/trade/creditDefaultSwap/generalTerms/referenceInformation/referenceEntity/@id.</text></error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:guarantorReference">
<xsl:if test="not(fpml:guarantorReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:referenceInformation/fpml:referenceEntity/@id)">
<error><context><xsl:value-of select="$newContext"/></context><text>*** guarantorReference/@href must equal //FpML/trade/creditDefaultSwap/generalTerms/referenceInformation/referenceEntity/@id.</text></error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:guarantor">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected guarantor element encountered in this context.</text></error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:bond">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:apply-templates select="fpml:instrumentId">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:choose>
<xsl:when test="fpml:instrumentId[@instrumentIdScheme='http://www.fpml.org/spec/2002/instrument-id-ISIN-1-0']"/>
<xsl:when test="fpml:instrumentId[@instrumentIdScheme='http://www.fpml.org/spec/2002/instrument-id-CUSIP-1-0']"/>
<xsl:otherwise>
<error><context><xsl:value-of select="$newContext"/></context><text>*** ISIN or CUSIP instrumentId must be present.</text></error>
</xsl:otherwise>
</xsl:choose>
<xsl:if test="fpml:instrumentId[@instrumentIdScheme='http://www.fpml.org/spec/2003/instrument-id-RED-pair-1-0']">
<xsl:variable name="redPairId"><xsl:value-of select="fpml:instrumentId[@instrumentIdScheme='http://www.fpml.org/spec/2003/instrument-id-RED-pair-1-0']"/></xsl:variable>
<xsl:if test="string-length($redPairId) != 9">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Invalid instrumentId[@instrumentIdScheme='http://www.fpml.org/spec/2003/instrument-id-RED-pair-1-0'] element value length. RED pair identifier must be 9 characters. Value = '<xsl:value-of select="$redPairId"/>'.</text></error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:description">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected description element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:currency">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected currency element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:exchangeId">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected exchangeId element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:clearanceSystem">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected clearanceSystem element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:definition">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected definition element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:relatedExchangeId">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected relatedExchangeId element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:optionsExchangeId">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected optionsExchangeId element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:issuerName">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected issuerName element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:issuerPartyReference">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected issuerPartyReference element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:parValue">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected parValue element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:faceAmount">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected faceAmount element encountered in this context.</text></error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:instrumentId">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:choose>
<xsl:when test="@instrumentIdScheme='http://www.fpml.org/spec/2002/instrument-id-ISIN-1-0'"/>
<xsl:when test="@instrumentIdScheme='http://www.fpml.org/spec/2002/instrument-id-CUSIP-1-0'"/>
<xsl:when test="@instrumentIdScheme='http://www.fpml.org/spec/2003/instrument-id-RED-pair-1-0'"/>
<xsl:otherwise>
<error><context><xsl:value-of select="$newContext"/></context><text>*** @instrumentIdScheme value is invalid. Value = '<xsl:value-of select="@instrumentIdScheme"/>'.</text></error>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template match="fpml:primaryObligor">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="entityName"><xsl:value-of select="fpml:entityName"/></xsl:variable>
<xsl:if test="$entityName=''">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Empty entityName element.</text></error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:paymentDate">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:apply-templates select="fpml:dateAdjustments">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:dateAdjustments">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="fpml:businessCentersReference">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected businessCentersReference element encountered in this context.</text></error>
</xsl:if>
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
<xsl:otherwise><error><context><xsl:value-of select="$context"/></context><text>*** <xsl:value-of select="$errorText"/></text></error></xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template name="isValidCDSConfirmationType">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> element. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='EuropeCorporate'"/>
<xsl:when test="$elementValue='StandardEuropeCorporate'"/>
<xsl:when test="$elementValue='EuropeInsurerSubDebt'"/>
<xsl:when test="$elementValue='EuropeSovereign'"/>
<xsl:when test="$elementValue='NorthAmericaCorporate'"/>
<xsl:when test="$elementValue='StandardNorthAmericaCorporate'"/>
<xsl:when test="$elementValue='NorthAmericaMonolineInsurer'"/>
<xsl:when test="$elementValue='EMEuropeCorporate'"/>
<xsl:when test="$elementValue='EMEuropeSovereign'"/>
<xsl:when test="$elementValue='EMLatinAmericaCorporate'"/>
<xsl:when test="$elementValue='EMLatinAmericaSovereign'"/>
<xsl:when test="$elementValue='JapanCorporate'"/>
<xsl:when test="$elementValue='JapanSovereign'"/>
<xsl:when test="$elementValue='AustraliaCorporate'"/>
<xsl:when test="$elementValue='NewZealandCorporate'"/>
<xsl:when test="$elementValue='AsiaCorporate'"/>
<xsl:when test="$elementValue='AsiaSovereign'"/>
<xsl:when test="$elementValue='SingaporeCorporate'"/>
<xsl:otherwise><error><context><xsl:value-of select="$context"/></context><text>*** <xsl:value-of select="$errorText"/></text></error></xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template name="isValidCDSIndexConfirmationType">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> element. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='DJ.CDX.NA'"/>
<xsl:when test="$elementValue='CDX.NA'"/>
<xsl:when test="$elementValue='CDXTranche'"/>
<xsl:when test="$elementValue='StandardCDXTranche'"><xsl:call-template name="IsValidStandardCDSIndex"/></xsl:when>
<xsl:when test="$elementValue='DJ.CDX.EM'"/>
<xsl:when test="$elementValue='CDX.EM'"/>
<xsl:when test="$elementValue='CDXEmergingMarkets'"/>
<xsl:when test="$elementValue='CDXEmergingMarketsDiversified'"/>
<xsl:when test="$elementValue='iTraxxEurope'"/>
<xsl:when test="$elementValue='iTraxxEuropeTranche'"/>
<xsl:when test="$elementValue='StandardiTraxxEuropeTranche'"><xsl:call-template name="IsValidStandardCDSIndex"/></xsl:when>
<xsl:when test="$elementValue='iTraxxSDI75'"/>
<xsl:when test="$elementValue='iTraxxJapan'"/>
<xsl:when test="$elementValue='iTraxxJapanTranche'"/>
<xsl:when test="$elementValue='iTraxxCJ'"/>
<xsl:when test="$elementValue='iTraxxCJTranche'"/>
<xsl:when test="$elementValue='iTraxxAsiaExJapan'"/>
<xsl:when test="$elementValue='iTraxxAsiaExJapanTranche'"/>
<xsl:when test="$elementValue='iTraxxAustralia'"/>
<xsl:when test="$elementValue='iTraxxAustraliaTranche'"/>
<xsl:when test="$elementValue='iTraxxLevX'"/>
<xsl:when test="$elementValue='LCDX'"/>
<xsl:when test="$elementValue='StandardLCDXBullet'"/>
<xsl:when test="$elementValue='LCDXTranche'"/>
<xsl:when test="$elementValue='MCDX'"/>
<xsl:when test="$elementValue='ABX'"/>
<xsl:when test="$elementValue='ABXTranche'"/>
<xsl:when test="$elementValue='CMBX'"/>
<xsl:when test="$elementValue='TRX'"/>
<xsl:when test="$elementValue='iTraxxSovX'"/>
<xsl:otherwise><error><context><xsl:value-of select="$context"/></context><text>*** <xsl:value-of select="$errorText"/></text></error></xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template name="IsValidStandardCDSIndex">
<xsl:variable name="brokerConfirmationType">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:brokerConfirmation/fpml:brokerConfirmationType"/>
</xsl:variable>
<xsl:variable name="attachmentPoint">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:indexReferenceInformation/fpml:tranche/fpml:attachmentPoint"/>
</xsl:variable>
<xsl:variable name="exhaustionPoint">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:indexReferenceInformation/fpml:tranche/fpml:exhaustionPoint"/>
</xsl:variable>
<xsl:variable name="fixedRate">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:feeLeg/fpml:periodicPayment/fpml:fixedAmountCalculation/fpml:fixedRate"/>
</xsl:variable>
<xsl:if test="$brokerConfirmationType='StandardCDXTranche'">
<xsl:choose>
<xsl:when test="$attachmentPoint='0' and $exhaustionPoint='0.03'"/>
<xsl:when test="$attachmentPoint='0' and $exhaustionPoint='0.07'"/>
<xsl:when test="$attachmentPoint='0' and $exhaustionPoint='0.15'"/>
<xsl:when test="$attachmentPoint='0.03' and $exhaustionPoint='0.07'"/>
<xsl:when test="$attachmentPoint='0.07' and $exhaustionPoint='0.1'"/>
<xsl:when test="$attachmentPoint='0.07' and $exhaustionPoint='0.15'"/>
<xsl:when test="$attachmentPoint='0.1' and $exhaustionPoint='0.15'"/>
<xsl:when test="$attachmentPoint='0.15' and $exhaustionPoint='0.25'"/>
<xsl:when test="$attachmentPoint='0.15' and $exhaustionPoint='0.3'"/>
<xsl:when test="$attachmentPoint='0.15' and $exhaustionPoint='1'"/>
<xsl:when test="$attachmentPoint='0.25' and $exhaustionPoint='0.35'"/>
<xsl:when test="$attachmentPoint='0.3' and $exhaustionPoint='1'"/>
<xsl:when test="$attachmentPoint='0.35' and $exhaustionPoint='1'"/>
<xsl:otherwise>
<error>
<context>In /SWBML/swbStructuredTradeDetails/FpML/trade/creditDefaultSwap/generalTerms/indexReferenceInformation/tranche</context>
<text>*** The combination of attachment and exhaustion points is not valid when brokerConfirmationType is 'StandardCDXTranche'. Value1 = '<xsl:value-of select="$attachmentPoint"/>'. Value2 = '<xsl:value-of select="$exhaustionPoint"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
<xsl:choose>
<xsl:when test="$fixedRate='0'"/>
<xsl:when test="$fixedRate='0.0025'"/>
<xsl:when test="$fixedRate='0.01'"/>
<xsl:when test="$fixedRate='0.05'"/>
<xsl:otherwise>
<error>
<context>In /SWBML/swbStructuredTradeDetails/FpML/trade/creditDefaultSwap/feeLeg/periodicPayment/fixedAmountCalculation/fixedRate</context>
<text>*** The submitted fixed rate is not valid when brokerConfirmationType is 'StandardCDXTranche'. Value = '<xsl:value-of select="$fixedRate"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="$brokerConfirmationType='StandardiTraxxEuropeTranche'">
<xsl:choose>
<xsl:when test="$attachmentPoint='0' and $exhaustionPoint='0.03'"/>
<xsl:when test="$attachmentPoint='0.03' and $exhaustionPoint='0.06'"/>
<xsl:when test="$attachmentPoint='0.06' and $exhaustionPoint='0.09'"/>
<xsl:when test="$attachmentPoint='0.09' and $exhaustionPoint='0.12'"/>
<xsl:when test="$attachmentPoint='0.12' and $exhaustionPoint='0.22'"/>
<xsl:when test="$attachmentPoint='0.22' and $exhaustionPoint='1'"/>
<xsl:otherwise>
<error>
<context>In /SWBML/swbStructuredTradeDetails/FpML/trade/creditDefaultSwap/generalTerms/indexReferenceInformation/tranche</context>
<text>*** The combination of attachment and exhaustion points is not valid when brokerConfirmationType is 'StandardiTraxxEuropeTranche'. Value1 = '<xsl:value-of select="$attachmentPoint"/>'. Value2 = '<xsl:value-of select="$exhaustionPoint"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
<xsl:choose>
<xsl:when test="$fixedRate='0.0025'"/>
<xsl:when test="$fixedRate='0.01'"/>
<xsl:when test="$fixedRate='0.03'"/>
<xsl:when test="$fixedRate='0.05'"/>
<xsl:when test="$fixedRate='0.075'"/>
<xsl:when test="$fixedRate='0.1'"/>
<xsl:otherwise>
<error>
<context>In /SWBML/swbStructuredTradeDetails/FpML/trade/creditDefaultSwap/feeLeg/periodicPayment/fixedAmountCalculation/fixedRate</context>
<text>*** The submitted fixed rate is not valid when brokerConfirmationType is 'StandardiTraxxEuropeTranche'. Value = '<xsl:value-of select="$fixedRate"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:template>
<xsl:template name="isValidCDSMatrixType">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> element. Value = '<xsl:value-of select="$elementValue"/>'. Should be 'CreditDerivativesPhysicalSettlementMatrix'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='CreditDerivativesPhysicalSettlementMatrix'"/>
<xsl:otherwise><error><context><xsl:value-of select="$context"/></context><text>*** <xsl:value-of select="$errorText"/></text></error></xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template name="isValidCDSMatrixConfirmationType">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> element. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='NorthAmericanCorporate'"/>
<xsl:when test="$elementValue='StandardNorthAmericanCorporate'"/>
<xsl:when test="$elementValue='EuropeanCorporate'"/>
<xsl:when test="$elementValue='EuropeanLimitedRecourseCorporate'"/>
<xsl:when test="$elementValue='StandardEuropeanCorporate'"/>
<xsl:when test="$elementValue='StandardEuropeanLimitedRecourseCorporate'"/>
<xsl:when test="$elementValue='AustraliaCorporate'"/>
<xsl:when test="$elementValue='StandardAustraliaCorporate'"/>
<xsl:when test="$elementValue='NewZealandCorporate'"/>
<xsl:when test="$elementValue='StandardNewZealandCorporate'"/>
<xsl:when test="$elementValue='JapanCorporate'"/>
<xsl:when test="$elementValue='StandardJapanCorporate'"/>
<xsl:when test="$elementValue='SingaporeCorporate'"/>
<xsl:when test="$elementValue='StandardSingaporeCorporate'"/>
<xsl:when test="$elementValue='AsiaCorporate'"/>
<xsl:when test="$elementValue='StandardAsiaCorporate'"/>
<xsl:when test="$elementValue='SubordinatedEuropeanInsuranceCorporate'"/>
<xsl:when test="$elementValue='StandardSubordinatedEuropeanInsuranceCorporate'"/>
<xsl:when test="$elementValue='EmergingEuropeanCorporate'"/>
<xsl:when test="$elementValue='StandardEmergingEuropeanCorporate'"/>
<xsl:when test="$elementValue='EmergingEuropeanCorporateLPN'"/>
<xsl:when test="$elementValue='StandardEmergingEuropeanCorporateLPN'"/>
<xsl:when test="$elementValue='LatinAmericaCorporate'"/>
<xsl:when test="$elementValue='LatinAmericaCorporateBond'"/>
<xsl:when test="$elementValue='StandardLatinAmericaCorporateBond'"/>
<xsl:when test="$elementValue='LatinAmericaCorporateBondOrLoan'"/>
<xsl:when test="$elementValue='StandardLatinAmericaCorporateBondOrLoan'"/>
<xsl:when test="$elementValue='AsiaSovereign'"/>
<xsl:when test="$elementValue='StandardAsiaSovereign'"/>
<xsl:when test="$elementValue='EmergingEuropeanAndMiddleEasternSovereign'"/>
<xsl:when test="$elementValue='StandardEmergingEuropeanAndMiddleEasternSovereign'"/>
<xsl:when test="$elementValue='JapanSovereign'"/>
<xsl:when test="$elementValue='StandardJapanSovereign'"/>
<xsl:when test="$elementValue='AustraliaSovereign'"/>
<xsl:when test="$elementValue='StandardAustraliaSovereign'"/>
<xsl:when test="$elementValue='NewZealandSovereign'"/>
<xsl:when test="$elementValue='StandardNewZealandSovereign'"/>
<xsl:when test="$elementValue='SingaporeSovereign'"/>
<xsl:when test="$elementValue='StandardSingaporeSovereign'"/>
<xsl:when test="$elementValue='LatinAmericaSovereign'"/>
<xsl:when test="$elementValue='StandardLatinAmericaSovereign'"/>
<xsl:when test="$elementValue='WesternEuropeanSovereign'"/>
<xsl:when test="$elementValue='StandardWesternEuropeanSovereign'"/>
<xsl:when test="$elementValue='SukukCorporate'"/>
<xsl:when test="$elementValue='StandardSukukCorporate'"/>
<xsl:when test="$elementValue='SukukSovereign'"/>
<xsl:when test="$elementValue='StandardSukukSovereign'"/>
<xsl:when test="$elementValue='StandardUSMunicipalFullFaithAndCredit'"/>
<xsl:when test="$elementValue='StandardUSMunicipalGeneralFund'"/>
<xsl:when test="$elementValue='StandardUSMunicipalRevenue'"/>
<xsl:when test="$elementValue='USMunicipalFullFaithAndCredit'"/>
<xsl:when test="$elementValue='USMunicipalGeneralFund'"/>
<xsl:when test="$elementValue='USMunicipalRevenue'"/>
<xsl:when test="$elementValue='NorthAmericanFinancialCorporate'"/>
<xsl:when test="$elementValue='StandardNorthAmericanFinancialCorporate'"/>
<xsl:when test="$elementValue='EuropeanFinancialCorporate'"/>
<xsl:when test="$elementValue='StandardEuropeanFinancialCorporate'"/>
<xsl:when test="$elementValue='EuropeanCoCoFinancialCorporate'"/>
<xsl:when test="$elementValue='StandardEuropeanCoCoFinancialCorporate'"/>
<xsl:when test="$elementValue='EuropeanSeniorNonPreferredFinancialCorporate'"/>
<xsl:when test="$elementValue='StandardEuropeanSeniorNonPreferredFinancialCorporate'"/>
<xsl:when test="$elementValue='EmergingEuropeanFinancialCorporate'"/>
<xsl:when test="$elementValue='StandardEmergingEuropeanFinancialCorporate'"/>
<xsl:when test="$elementValue='EmergingEuropeanFinancialCorporateLPN'"/>
<xsl:when test="$elementValue='StandardEmergingEuropeanFinancialCorporateLPN'"/>
<xsl:when test="$elementValue='LatinAmericaFinancialCorporateBond'"/>
<xsl:when test="$elementValue='StandardLatinAmericaFinancialCorporateBond'"/>
<xsl:when test="$elementValue='LatinAmericaFinancialCorporateBondOrLoan'"/>
<xsl:when test="$elementValue='StandardLatinAmericaFinancialCorporateBondOrLoan'"/>
<xsl:when test="$elementValue='AustraliaFinancialCorporate'"/>
<xsl:when test="$elementValue='StandardAustraliaFinancialCorporate'"/>
<xsl:when test="$elementValue='NewZealandFinancialCorporate'"/>
<xsl:when test="$elementValue='StandardNewZealandFinancialCorporate'"/>
<xsl:when test="$elementValue='JapanFinancialCorporate'"/>
<xsl:when test="$elementValue='StandardJapanFinancialCorporate'"/>
<xsl:when test="$elementValue='SingaporeFinancialCorporate'"/>
<xsl:when test="$elementValue='StandardSingaporeFinancialCorporate'"/>
<xsl:when test="$elementValue='AsiaFinancialCorporate'"/>
<xsl:when test="$elementValue='StandardAsiaFinancialCorporate'"/>
<xsl:when test="$elementValue='SukukFinancialCorporate'"/>
<xsl:when test="$elementValue='StandardSukukFinancialCorporate'"/>
<xsl:otherwise><error><context><xsl:value-of select="$context"/></context><text>*** <xsl:value-of select="$errorText"/></text></error></xsl:otherwise>
</xsl:choose>
<xsl:if test="$elementValue='NorthAmericanFinancialCorporate' or $elementValue='StandardNorthAmericanFinancialCorporate' or $elementValue='EuropeanFinancialCorporate' or $elementValue='StandardEuropeanFinancialCorporate' or $elementValue='EmergingEuropeanFinancialCorporate' or $elementValue='StandardEmergingEuropeanFinancialCorporate' or $elementValue='EmergingEuropeanFinancialCorporateLPN' or $elementValue='StandardEmergingEuropeanFinancialCorporateLPN' or $elementValue='LatinAmericaFinancialCorporateBond' or $elementValue='StandardLatinAmericaFinancialCorporateBond' or $elementValue='LatinAmericaFinancialCorporateBondOrLoan' or $elementValue='StandardLatinAmericaFinancialCorporateBondOrLoan' or $elementValue='AustraliaFinancialCorporate' or $elementValue='StandardAustraliaFinancialCorporate' or $elementValue='NewZealandFinancialCorporate' or $elementValue='StandardNewZealandFinancialCorporate' or $elementValue='JapanFinancialCorporate' or $elementValue='StandardJapanFinancialCorporate' or $elementValue='SingaporeFinancialCorporate' or $elementValue='StandardSingaporeFinancialCorporate' or $elementValue='AsiaFinancialCorporate' or $elementValue='StandardAsiaFinancialCorporate' or $elementValue='SukukFinancialCorporate' or $elementValue='StandardSukukFinancialCorporate' or $elementValue='EuropeanCoCoFinancialCorporate' or $elementValue='StandardEuropeanCoCoFinancialCorporate' or $elementValue='EuropeanSeniorNonPreferredFinancialCorporate' or $elementValue='StandardEuropeanSeniorNonPreferredFinancialCorporate'">
<xsl:variable name="contractualDefinitions">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:contractualDefinitions"/>
</xsl:variable>
<xsl:if test= "$contractualDefinitions != '' and $contractualDefinitions != 'ISDA2014Credit'">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** contractualDefinitions must be 'ISDA2014Credit' for matrixTerm = '<xsl:value-of select="$elementValue"/>'.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:template>
<xsl:template name="isValidCDSMasterConfirmationType">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> element. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='NorthAmericanCorporate'"/>
<xsl:when test="$elementValue='StandardNorthAmericanCorporate'"/>
<xsl:when test="$elementValue='EuropeanCorporate'"/>
<xsl:when test="$elementValue='StandardEuropeanCorporate'"/>
<xsl:when test="$elementValue='AustraliaAndNewZealandCorporate'"/>
<xsl:when test="$elementValue='StandardAustraliaAndNewZealandCorporate'"/>
<xsl:when test="$elementValue='JapanCorporate'"/>
<xsl:when test="$elementValue='StandardJapanCorporate'"/>
<xsl:when test="$elementValue='SingaporeCorporate'"/>
<xsl:when test="$elementValue='StandardSingaporeCorporate'"/>
<xsl:when test="$elementValue='AsiaCorporate'"/>
<xsl:when test="$elementValue='StandardAsiaCorporate'"/>
<xsl:when test="$elementValue='AsiaSovereign'"/>
<xsl:when test="$elementValue='StandardAsiaSovereign'"/>
<xsl:when test="$elementValue='EmergingEuropeanAndMiddleEasternSovereign'"/>
<xsl:when test="$elementValue='StandardEmergingEuropeanAndMiddleEasternSovereign'"/>
<xsl:when test="$elementValue='JapanSovereign'"/>
<xsl:when test="$elementValue='StandardJapanSovereign'"/>
<xsl:when test="$elementValue='LatinAmericaSovereign'"/>
<xsl:when test="$elementValue='StandardLatinAmericaSovereign'"/>
<xsl:when test="$elementValue='StandardUSMunicipalFullFaithAndCredit'"/>
<xsl:when test="$elementValue='StandardUSMunicipalGeneralFund'"/>
<xsl:when test="$elementValue='StandardUSMunicipalRevenue'"/>
<xsl:when test="$elementValue='WesternEuropeanSovereign'"/>
<xsl:when test="$elementValue='StandardWesternEuropeanSovereign'"/>
<xsl:when test="$elementValue='AsiaFinancialCorporate'"/>
<xsl:when test="$elementValue='StandardAsiaFinancialCorporate'"/>
<xsl:when test="$elementValue='AustraliaNewZealandFinancialCorporate'"/>
<xsl:when test="$elementValue='StandardAustraliaNewZealandFinancialCorporate'"/>
<xsl:when test="$elementValue='EuropeanFinancialCorporate'"/>
<xsl:when test="$elementValue='StandardEuropeanFinancialCorporate'"/>
<xsl:when test="$elementValue='JapanFinancialCorporate'"/>
<xsl:when test="$elementValue='StandardJapanFinancialCorporate'"/>
<xsl:when test="$elementValue='StandardNorthAmericanFinancialCorporate'"/>
<xsl:when test="$elementValue='NorthAmericanFinancialCorporate'"/>
<xsl:when test="$elementValue='SingaporeFinancialCorporate'"/>
<xsl:when test="$elementValue='StandardSingaporeFinancialCorporate'"/>
<xsl:when test="$elementValue='EuropeanCoCoFinancialCorporate'"/>
<xsl:when test="$elementValue='StandardEuropeanCoCoFinancialCorporate'"/>
<xsl:otherwise><error><context><xsl:value-of select="$context"/></context><text>*** <xsl:value-of select="$errorText"/></text></error></xsl:otherwise>
</xsl:choose>
<xsl:if test="$elementValue='AsiaFinancialCorporate' or $elementValue='StandardAsiaFinancialCorporate' or $elementValue='AustraliaNewZealandFinancialCorporate' or $elementValue='StandardAustraliaNewZealandFinancialCorporate' or $elementValue='EuropeanFinancialCorporate' or $elementValue='StandardEuropeanFinancialCorporate' or $elementValue='JapanFinancialCorporate' or $elementValue='StandardJapanFinancialCorporate' or $elementValue='StandardNorthAmericanFinancialCorporate' or $elementValue='NorthAmericanFinancialCorporate' or $elementValue='SingaporeFinancialCorporate' or $elementValue='StandardSingaporeFinancialCorporate' or $elementValue='EuropeanCoCoFinancialCorporate' or $elementValue='StandardEuropeanCoCoFinancialCorporate'">
<xsl:variable name="contractualDefinitions">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:contractualDefinitions"/>
</xsl:variable>
<xsl:if test= "$contractualDefinitions != '' and $contractualDefinitions != 'ISDA2014Credit'">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** contractualDefinitions must be 'ISDA2014Credit' for Master Confirmation Type = '<xsl:value-of select="$elementValue"/>'.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:template>
<xsl:template name="isValidcontractualSupplement">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> element. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='ISDA2003CreditMay2003'"/>
<xsl:when test="$elementValue='ISDADeliveryRestrictions'"/>
<xsl:when test="$elementValue='ISDA2003Credit2005MatrixSupplement'"/>
<xsl:when test="$elementValue='ISDACreditMonolineInsurers'"/>
<xsl:when test="$elementValue='ISDASecuredDeliverableObligationCharacteristic'"/>
<xsl:when test="$elementValue='ISDA2003CreditUSMunicipals'"/>
<xsl:when test="$elementValue='ISDALPNReferenceEntities'"/>
<xsl:otherwise><error><context><xsl:value-of select="$context"/></context><text>*** <xsl:value-of select="$errorText"/></text></error></xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template name="isValidCurrency">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> element. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$productType='CDS' or $productType='CDS Index' or $productType='CDS Master' ">
<xsl:choose>
<xsl:when test="$elementValue='CHF'"/>
<xsl:when test="$elementValue='EUR'"/>
<xsl:when test="$elementValue='GBP'"/>
<xsl:when test="$elementValue='JPY'"/>
<xsl:when test="$elementValue='USD'"/>
<xsl:otherwise><error><context><xsl:value-of select="$context"/></context><text>*** <xsl:value-of select="$errorText"/></text></error></xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:otherwise>
<xsl:choose>
<xsl:when test="$elementValue='SGD'"/>
<xsl:when test="$elementValue='CAD'"/>
<xsl:when test="$elementValue='CHF'"/>
<xsl:when test="$elementValue='DKK'"/>
<xsl:when test="$elementValue='EUR'"/>
<xsl:when test="$elementValue='GBP'"/>
<xsl:when test="$elementValue='JPY'"/>
<xsl:when test="$elementValue='NOK'"/>
<xsl:when test="$elementValue='SEK'"/>
<xsl:when test="$elementValue='USD'"/>
<xsl:otherwise><error><context><xsl:value-of select="$context"/></context><text>*** <xsl:value-of select="$errorText"/></text></error></xsl:otherwise>
</xsl:choose>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template name="isValidMasterAgreementType">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> element. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$productType='CDS'">
<xsl:choose>
<xsl:when test="$elementValue='ISDA'"/>
<xsl:when test="$elementValue='AFB/FBF'"/>
<xsl:otherwise><error><context><xsl:value-of select="$context"/></context><text>*** <xsl:value-of select="$errorText"/></text></error></xsl:otherwise>
</xsl:choose>
</xsl:when>
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
<xsl:if test="string-length(substring-after($elementValue,'.')) &gt; $maxDecs"><error><context><xsl:value-of select="$context"/></context><text>*** <xsl:value-of select="$elementName"/> has too many decimal places; maxDecs=<xsl:value-of select="$maxDecs"/>. Value = '<xsl:value-of select="$elementValue"/>'.</text></error></xsl:if>
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
<xsl:otherwise><error><context><xsl:value-of select="$context"/></context><text>*** <xsl:value-of select="$errorText"/></text></error></xsl:otherwise>
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
<xsl:when test="$elementValue='CDS'"/>
<xsl:when test="$elementValue='CDS Index'"/>
<xsl:when test="$elementValue='CDS Matrix'"/>
<xsl:when test="$elementValue='CDS Master'"/>
<xsl:otherwise><error><context><xsl:value-of select="$context"/></context><text>*** <xsl:value-of select="$errorText"/></text></error></xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:template>
<xsl:template name="isValidRestructuringType">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> element. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='R'"/>
<xsl:when test="$elementValue='ModR'"/>
<xsl:when test="$elementValue='ModModR'"/>
<xsl:otherwise><error><context><xsl:value-of select="$context"/></context><text>*** <xsl:value-of select="$errorText"/></text></error></xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template name="isValidRollConvention">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> element for product type of '<xsl:value-of select="$productType"/>'. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$productType='CDS'">
<xsl:choose>
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
<xsl:otherwise><error><context><xsl:value-of select="$context"/></context><text>*** <xsl:value-of select="$errorText"/></text></error></xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType='CDS Index'">
<xsl:choose>
<xsl:when test="$elementValue='EOM'"/>
<xsl:when test="$elementValue='IMM'"/>
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
<xsl:otherwise><error><context><xsl:value-of select="$context"/></context><text>*** <xsl:value-of select="$errorText"/></text></error></xsl:otherwise>
</xsl:choose>
</xsl:when>
</xsl:choose>
</xsl:template>
<xsl:template match="fpml:swbMandatoryClearing|fpml:swbMandatoryClearingNewNovatedTrade">
<xsl:param name="context"/>
<xsl:if test="fpml:swbMandatoryClearingIndicator">
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">swbMandatoryClearingIndicator</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swbMandatoryClearingIndicator"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$context"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:for-each select="fpml:swbPartyExemption/fpml:swbExemption">
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
<xsl:if test="fpml:swbPartyExemption[position()=1]/fpml:swbPartyReference/@href = fpml:swbPartyExemption[position()=2]/fpml:swbPartyReference/@href">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** swbPartyExemption cannot be provided twice for the same party for the same clearing jurisdiction</text>
</error>
</xsl:if>
<xsl:if test="current()[fpml:swbJurisdiction/text()='ASIC' or fpml:swbJurisdiction/text()='FCA' or fpml:swbJurisdiction/text()='MAS'][fpml:swbSupervisoryBodyCategory]">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** swbSupervisoryBodyCategory not supported for '<xsl:value-of select="fpml:swbJurisdiction"/>' clearing</text>
</error>
</xsl:if>
<xsl:if test="current()[contains(';ASIC;MAS;', concat(';', fpml:swbJurisdiction/text(),';'))][fpml:swbPartyExemption]">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** swbPartyExemption cannot be provided for '<xsl:value-of select="fpml:swbJurisdiction"/>'</text>
</error>
</xsl:if>
<xsl:if test="not(contains(';ASIC;CAN;ESMA;FCA;HKMA;DoddFrank;MIFID;MAS;', concat(';', fpml:swbJurisdiction/text(),';')))">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** This value:'<xsl:value-of select="fpml:swbJurisdiction"/>' of swbJurisdiction is not in supported list for mandatory clearing - Permitted values: ASIC;CAN;ESMA;FCA;HKMA;DoddFrank;MIFID;MAS. </text>
</error>
</xsl:if>
<xsl:choose>
<xsl:when test="current()[fpml:swbJurisdiction/text()='DoddFrank']">
<xsl:if test="parent::node()[local-name()='swbTradeHeader']">
<xsl:if test="/fpml:SWBML/fpml:swbTradeEventReportingDetails/fpml:swbReportingRegimeInformation[fpml:swbJurisdiction/text()=current()/fpml:swbJurisdiction/text()]/fpml:swbMandatoryClearingIndicator">
<xsl:if test="not(/fpml:SWBML/fpml:swbTradeEventReportingDetails/fpml:swbReportingRegimeInformation[fpml:swbJurisdiction/text()=current()/fpml:swbJurisdiction/text()]/fpml:swbMandatoryClearingIndicator = current()/fpml:swbMandatoryClearingIndicator)">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** Different values have been specified for swbMandatoryClearingIndicator in reporting and clearing sections for jurisdiction '<xsl:value-of select="fpml:Jurisdiction"/>'.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
</xsl:when>
</xsl:choose>
<xsl:if test="current()[fpml:swbInterAffiliateExemption]">
<xsl:if test="not(current()[fpml:swbJurisdiction/text()='DoddFrank'])">
<xsl:if test="not(current()[fpml:swbSupervisoryBodyCategory/text()='BroadBased'])">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** May only provide a value for swbInterAffiliateExemption under CFTC (swbJurisdiction='DoddFrank' and swbSupervisoryBodyCategory='BroadBased'), value of '<xsl:value-of select="fpml:swbInterAffiliateExemption"/>' has been provided under jurisdiction '<xsl:value-of select="fpml:swbJurisdiction"/>'.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
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
</xsl:stylesheet>
