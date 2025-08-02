<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fpml="http://www.fpml.org/2010/FpML-4-9" xmlns:common="http://exslt.org/common" exclude-result-prefixes="fpml common" version="1.0">
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
<xsl:variable name="assetClass">Credit</xsl:variable>
<xsl:variable name="productType">
<xsl:value-of select="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:swProductType"/>
</xsl:variable>
<xsl:variable name="valueDate" select="//fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swValueDate"/>
<xsl:variable name="creditDefaultSwapOption" select="//fpml:FpML/fpml:trade/fpml:creditDefaultSwapOption"/>
<xsl:variable name="creditDefaultSwap" select="//fpml:FpML/fpml:trade/fpml:creditDefaultSwap | $creditDefaultSwapOption/fpml:creditDefaultSwap"/>
<xsl:variable name="generalTerms" select="$creditDefaultSwap/fpml:generalTerms"/>
<xsl:variable name="docsType">
<xsl:choose>
<xsl:when test="$productType='CDS Master'">
<xsl:value-of select="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType"/>
</xsl:when>
<xsl:when test="$productType='CDS Matrix'">
<xsl:value-of select="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:contractualMatrix/fpml:matrixTerm"/>
</xsl:when>
</xsl:choose>
</xsl:variable>
<xsl:variable name="FpMLVersion">
<xsl:value-of select="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails//fpml:FpML/@version"/>
</xsl:variable>
<xsl:variable name="tradeCurrency">
<xsl:value-of select="$creditDefaultSwap/fpml:protectionTerms/fpml:calculationAmount/fpml:currency"/>
</xsl:variable>
<xsl:variable name="tranche">
<xsl:value-of select="$generalTerms/fpml:indexReferenceInformation/fpml:tranche"/>
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
<xsl:variable name="isBlockIndependentAmountPresent">
<xsl:if test="/fpml:SWDML//fpml:swStructuredTradeDetails//fpml:collateral">true</xsl:if>
</xsl:variable>
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
<xsl:if test="not(fpml:swLongFormTrade)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing swLongFormTrade element. Required in this context.</text>
</error>
</xsl:if>
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
<xsl:template match="fpml:swLongFormTrade">
<xsl:param name="context"/>
<xsl:param name="reportingData"/>
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
<xsl:if test="not(//fpml:FpML/fpml:party[@id = $href])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swOriginatorPartyReference/@href does not reference a valid //FpML/trade/party/@id. Value = '<xsl:value-of select="$href"/>'.</text>
</error>
</xsl:if>
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
<xsl:apply-templates select="fpml:swStructuredTradeDetails">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
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
<xsl:variable name="hrefG">
<xsl:value-of select="fpml:swExecutingDealerCustomerTransaction/fpml:swExecutingDealer/@href"/>
</xsl:variable>
<xsl:if test="$hrefG=$hrefD">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swExecutingDealerCustomerTransaction/swExecutingDealer/@href and swInterDealerTransaction/swExecutingDealer/@href values must not be the same.</text>
</error>
</xsl:if>
<xsl:if test="$hrefG=$hrefC">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swExecutingDealerCustomerTransaction/swExecutingDealer/@href and swCustomerTransaction/swCustomer/@href values must not be the same.</text>
</error>
</xsl:if>
<xsl:if test="$hrefG=$hrefCPB">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swExecutingDealerCustomerTransaction/swExecutingDealer/@href and swCustomerTransaction/swPrimeBroker/@href values must not be the same.</text>
</error>
</xsl:if>
<xsl:if test="$hrefG=$hrefDPB">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swExecutingDealerCustomerTransaction/swExecutingDealer/@href and swInterDealerTransaction/swPrimeBroker/@href values must not be the same.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swExecutingDealerCustomerTransaction">
<xsl:if test="not(//fpml:FpML/fpml:party[@id=$hrefG])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swExecutingDealerCustomerTransaction/swExecutingDealer/@href does not reference a valid FpML/trade/party/@id. Value = '<xsl:value-of select="$hrefG"/>'.</text>
</error>
</xsl:if>
</xsl:if>
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
<text>*** swCustomerTransaction/swCustomer/@href does not reference a valid FpML/trade/party/@id. Value = '<xsl:value-of select="$hrefC"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not(//fpml:FpML/fpml:party[@id=$hrefCPB])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swCustomerTransaction/swPrimeBroker/@href does not reference a valid FpML/trade/party/@id. Value = '<xsl:value-of select="$hrefCPB"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not(//fpml:FpML/fpml:party[@id=$hrefD])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swInterDealerTransaction/swExecutingDealer/@href does not reference a valid FpML/trade/party/@id. Value = '<xsl:value-of select="$hrefD"/>'.</text>
</error>
</xsl:if>
<xsl:if test="not(//fpml:FpML/fpml:party[@id=$hrefDPB])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swInterDealerTransaction/swPrimeBroker/@href does not reference a valid /FpML/trade/party/@id. Value = '<xsl:value-of select="$hrefDPB"/>'.</text>
</error>
</xsl:if>
<xsl:if test="$isAllocatedTrade = 0">
<xsl:if test="$hrefDPB=$hrefCPB and not(fpml:swExecutingDealerCustomerTransaction)">
<xsl:if test="count(//fpml:FpML/fpml:party) &lt; 3">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of party child elements encountered. 3 expected.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$hrefDPB!=$hrefCPB and not(fpml:swExecutingDealerCustomerTransaction)">
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
<xsl:if test="$hrefDPB=$hrefCPB and not(fpml:swExecutingDealerCustomerTransaction)">
<xsl:if test="count(//fpml:FpML/fpml:party) &lt; 3">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of party child elements encountered. At least 3 expected.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$hrefDPB!=$hrefCPB and not(fpml:swExecutingDealerCustomerTransaction)">
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
<xsl:if test="$productType = 'CDS Index' or $productType = 'CDS Index Swaption' or $productType = 'CDS Master' or $productType = 'CDS Matrix'">
<xsl:if test="($hrefD != $generalTerms/fpml:buyerPartyReference/@href) and ($hrefD != $generalTerms/fpml:sellerPartyReference/@href)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swInterDealerTransaction/swExecutingDealer/@href must be a buyer or seller if product type is 'CDS Index' or 'CDS Master' or 'CDS Matrix'.</text>
</error>
</xsl:if>
<xsl:if test="($hrefC != $generalTerms/fpml:sellerPartyReference/@href) and ($hrefC != $generalTerms/fpml:buyerPartyReference/@href)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swCustomerTransaction/swCustomer/@href must be a buyer or seller if product type is 'CDS Index' or 'CDS Master' or 'CDS Matrix'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$productType = 'CDS Index' or $productType = 'CDS Index Swaption' or $productType = 'CDS Master' or $productType = 'CDS Matrix'">
<xsl:if test=".//fpml:swEarlyTerminationProvision">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** ./swEarlyTerminationProvision must not be specified in a Primary Prime Brokered Trade.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="node()/fpml:swMandatoryClearing">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
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
<xsl:apply-templates select="fpml:allocatedNotional">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
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
<xsl:if test="fpml:swIAExpected = 'true' and not(fpml:independentAmount)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***  independentAmount element must be present if swIAExpected flag is set to true</text>
</error>
</xsl:if>
<xsl:if test="fpml:swIAExpected = 'true' and fpml:independentAmount/fpml:paymentDetail/fpml:paymentAmount/fpml:amount != 0">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***  independentAmount must be zero if swIAExpected flag is set to true</text>
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
<xsl:if test="fpml:swSalesCredit">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swSalesCredit</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swSalesCredit"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.01</xsl:with-param>
<xsl:with-param name="maxIncl">999999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="fpml:swSalesCredit"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swClearingBroker">
<xsl:if test="//fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swTradeHeader/fpml:swClientClearing !='true'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swClearingBroker must only be present when swClientClearing is present and set to true</text>
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
<xsl:template match="fpml:allocatedNotional">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:variable name="allocatedNotionalCurrency">
<xsl:value-of select="fpml:currency"/>
</xsl:variable>
<xsl:if test="$allocatedNotionalCurrency != $tradeCurrency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** allocatedNotional/currency must be the same as the block notional currency within an allocated trade. Value = '<xsl:value-of select="$allocatedNotionalCurrency"/>'.</text>
</error>
</xsl:if>
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
<xsl:variable name="currency">
<xsl:value-of select="fpml:paymentAmount/fpml:currency"/>
</xsl:variable>
<xsl:if test="$currency!=$blockIndependentAmountCurrency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** paymentAmount/currency must equal the block trade independent amount currency.</text>
</error>
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
<xsl:if test="fpml:swProductType='CDS on Loans'">
<xsl:call-template name="isValidProductSubType">
<xsl:with-param name="elementName">swProductSubType</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swProductSubType"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:swProductType='CDS on MBS'">
<xsl:call-template name="isCompatibleMortgageSector">
<xsl:with-param name="elementName">referenceObligation/mortgage/sector</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="//fpml:referenceObligation/fpml:mortgage/fpml:sector[@mortgageSectorScheme='http://www.fpml.org/coding-scheme/mortgage-sector']"/>
</xsl:with-param>
<xsl:with-param name="swProductSubTypeToCompare">
<xsl:value-of select="fpml:swProductSubType"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="isMortgageInsurerValid">
<xsl:with-param name="elementName">referenceObligation/mortgage/insurer/entityName</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="//fpml:generalTerms/fpml:referenceInformation/fpml:referenceObligation/fpml:mortgage/fpml:insurer/fpml:entityName"/>
</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="areCompatible">
<xsl:with-param name="firstName">fpml:mortgage/fpml:instrumentId[@instrumentIdScheme='http://www.fpml.org/spec/2002/instrument-id-Bloomberg-1-0']</xsl:with-param>
<xsl:with-param name="firstValue">
<xsl:value-of select="//fpml:referenceObligation/fpml:mortgage/fpml:instrumentId[@instrumentIdScheme='http://www.fpml.org/spec/2002/instrument-id-Bloomberg-1-0']"/>
</xsl:with-param>
<xsl:with-param name="secondName">fpml:referenceEntity[@id='referenceEntity']/fpml:entityId[@entityIdScheme='http://www.fpml.org/spec/2003/entity-id-Bloomberg']</xsl:with-param>
<xsl:with-param name="secondValue">
<xsl:value-of select="//fpml:referenceEntity[@id='referenceEntity']/fpml:entityId[@entityIdScheme='http://www.fpml.org/spec/2003/entity-id-Bloomberg']"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:apply-templates select="fpml:FpML">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="(fpml:swExtendedTradeDetails/fpml:swProductTerm) and $productType='CDS Index'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swExtendedTradeDetails/swProductTerm element. Element must not be present if product type is 'CDS Index'.</text>
</error>
</xsl:if>
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
<xsl:if test="not(fpml:trade)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing trade element.</text>
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
<xsl:choose>
<xsl:when test="$productType='CDS' or $productType='CDS Matrix' or $productType='CDS Index' or $productType='CDS Master' or $productType='CDS on Loans' or $productType='CDS on MBS'">
<xsl:if test="not(fpml:creditDefaultSwap)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing creditDefaultSwap element. Element must be present if product type is 'CDS', 'CDS Index', 'CDS Master', 'CDS Matrix' or 'CDS on Loans'.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:creditDefaultSwap">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:when>
<xsl:when test="$productType='CDS Index Swaption'">
<xsl:if test="not(fpml:creditDefaultSwapOption)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing creditDefaultSwapOption element. Element must be present if product type is 'CDS Index Swaption'.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:creditDefaultSwapOption">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:when>
</xsl:choose>
<xsl:if test="$productType='CDS Index' or $productType='CDS Index Swaption' or $productType='CDS Master'">
<xsl:if test="fpml:calculationAgent and /fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected calculationAgent element encounted.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:calculationAgentBusinessCenter and $productType != 'CDS on MBS'">
<xsl:call-template name="isValidBusinessCenter">
<xsl:with-param name="elementName">calculationAgentBusinessCenter</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:calculationAgentBusinessCenter"/>
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
<xsl:apply-templates select="fpml:collateral">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
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
<xsl:template match="fpml:collateral">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:apply-templates select="fpml:independentAmount">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
<xsl:with-param name="allocPartyA">
<xsl:value-of select="$generalTerms/fpml:sellerPartyReference/@href"/>
</xsl:with-param>
<xsl:with-param name="allocPartyB">
<xsl:value-of select="$generalTerms/fpml:buyerPartyReference/@href"/>
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
<xsl:if test="fpml:paymentRule">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected paymentRule element in this context.</text>
</error>
</xsl:if>
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
<text>*** transferor/@href does not reference a valid FpML/trade/party/@id. Value = '<xsl:value-of select="$transferor"/>'.</text>
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
<text>*** transferee/@href does not reference a valid /FpML/trade/party/@id. Value = '<xsl:value-of select="$transferee"/>'.</text>
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
<text>*** remainingParty/@href does not reference a valid /FpML/trade/party/@id. Value = '<xsl:value-of select="$remainingParty"/>'.</text>
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
<text>*** otherRemainingParty/@href does not reference a valid /FpML/trade/party/@id. Value = '<xsl:value-of select="$otherRemainingParty"/>'.</text>
</error>
</xsl:if>
<xsl:if test="$remainingParty = $otherRemainingParty">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***otherRemainingParty/@href must not equal remainingParty/@href.</text>
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
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">fullFirstCalculationPeriod</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:fullFirstCalculationPeriod"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="not(fpml:novatedAmount)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing fpml:novatedAmount. Required in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:novatedAmount/fpml:currency != $tradeCurrency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** novatedAmount/currency must equal trade currency.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:novatedAmount">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:payment">
<xsl:if test="fpml:payment[fpml:paymentType != 'Novation']">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** payment/paymentType must be equal to 'Novation'. Value = '<xsl:value-of select="payment/fpml:paymentType"/>'.</text>
</error>
</xsl:if>
<xsl:if test="($transferor != fpml:payment/fpml:payerPartyReference/@href) and ($transferor != fpml:payment/fpml:receiverPartyReference/@href)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** transferor/@href must equal payment/fpml:payerPartyReference/@href or payment/fpml:receiverPartyReference/@href.</text>
</error>
</xsl:if>
<xsl:if test="($remainingParty =fpml:payment/fpml:payerPartyReference/@href) or ($remainingParty = fpml:payment/fpml:receiverPartyReference/@href)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** payment/fpml:payerPartyReference/@href or payment/fpml:receiverPartyReference/@href must not be equal to remainingParty/@href.</text>
</error>
</xsl:if>
<xsl:if test="fpml:otherRemainingParty">
<xsl:if test="($otherRemainingParty = fpml:payment/fpml:payerPartyReference/@href) or ($otherRemainingParty = fpml:payment/fpml:receiverPartyReference/@href)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** payment/fpml:payerPartyReference/@href or payment/fpml:receiverPartyReference/@href must not be equal to fpml:otherRemainingParty/@href.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:swPartialNovationIndicator">
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
<xsl:if test="//fpml:swNovationExecutionUniqueTransactionId">
<xsl:call-template name="swNovationExecutionUniqueTransactionId">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
<xsl:with-param name="reportingData" select="$reportingData"/>
</xsl:call-template>
</xsl:if>
<xsl:apply-templates select="fpml:swMandatoryClearingNewNovatedTrade">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
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
<xsl:template match="fpml:creditDefaultSwapOption">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="not(fpml:europeanExercise)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing europeanExercise element. Element must be present if product type is 'CDS Index Swaption'.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:creditDefaultSwap)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing creditDefaultSwap element. Element must be present if product type is 'CDS Index Swaption'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:buyerPartyReference/@href != fpml:premium/fpml:payerPartyReference/@href">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Buyer of option must be payer of premium.</text>
</error>
</xsl:if>
<xsl:if test="fpml:sellerPartyReference/@href != fpml:premium/fpml:receiverPartyReference/@href">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Seller of option must be receiver of premium.</text>
</error>
</xsl:if>
<xsl:choose>
<xsl:when test="fpml:optionType='Put'">
<xsl:if test="fpml:buyerPartyReference/@href != $generalTerms/fpml:buyerPartyReference/@href">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Buyer of Put (Payer) option must be Buyer of underlying protection.</text>
</error>
</xsl:if>
</xsl:when>
<xsl:when test="fpml:optionType='Call'">
<xsl:if test="fpml:sellerPartyReference/@href != $generalTerms/fpml:buyerPartyReference/@href">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Buyer of a Call (Receiver) option must be Seller of underlying protection.</text>
</error>
</xsl:if>
</xsl:when>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or invalid optionType element. Element must be 'Call' or 'Put'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
<xsl:if test="fpml:exerciseProcedure/fpml:followUpConfirmation/text() = 'false'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** exerciseProcedure/followUpConfirmation must be true if product type is 'CDS Index Swaption'.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:creditDefaultSwap">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:premium"/>
<xsl:template match="fpml:optionType"/>
<xsl:template match="fpml:europeanExercise"/>
<xsl:template match="fpml:exerciseProcedure"/>
<xsl:template match="fpml:settlementType"/>
<xsl:template match="fpml:strike"/>
<xsl:template match="fpml:documentation">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:variable name="masterAgreement">
<xsl:value-of select="fpml:masterAgreement"/>
</xsl:variable>
<xsl:variable name="contractualTermsSupplementForSwaption" select="fpml:contractualTermsSupplement[fpml:type/@contractualSupplementScheme='http://www.fpml.org/ext/swaption-supplement']"/>
<xsl:variable name="contractualTermsSupplement" select="fpml:contractualTermsSupplement[fpml:type/@contractualSupplementScheme='http://www.fpml.org/coding-scheme/contractual-supplement']"/>
<xsl:variable name="masterConfirmation">
<xsl:value-of select="fpml:masterConfirmation"/>
</xsl:variable>
<xsl:if test="$productType='CDS Index' or $productType='CDS Index Swaption'">
<xsl:if test="$masterAgreement != '' and not($contractualTermsSupplement)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected masterAgreement element or missing contractualTermsSupplement element for product 'CDS Index' or 'CDS Index Swaption'.</text>
</error>
</xsl:if>
<xsl:if test="$masterAgreement !='' and $masterConfirmation !=''">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected masterAgreement and masterConfirmation elements for product 'CDS Index' or 'CDS Index Swaption'.</text>
</error>
</xsl:if>
<xsl:if test="$masterAgreement !='' and $masterConfirmation !='' and $contractualTermsSupplement">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected masterAgreement, masterConfirmation and contractualTermsSupplement elements present for product 'CDS Index' or 'CDS Index Swaption'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:masterAgreement">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:variable name="contractualDefinitions">
<xsl:value-of select="fpml:contractualDefinitions"/>
</xsl:variable>
<xsl:if test="$contractualDefinitions != '' and $contractualDefinitions != 'ISDA2003Credit' and $contractualDefinitions != 'ISDA2006' and $contractualDefinitions != 'ISDA2014Credit' ">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** contractualDefinitions must equal 'ISDA2003Credit', 'ISDA2006' or 'ISDA2014Credit'.  Value = '<xsl:value-of select="$contractualDefinitions"/>'.</text>
</error>
</xsl:if>
<xsl:if test="$masterConfirmation !='' and $productType='CDS Matrix'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected masterConfirmation element encountered for product 'CDS Matrix'.</text>
</error>
</xsl:if>
<xsl:if test="$productType='CDS Index' and $masterConfirmation !='' and $tranche !=''">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected masterConfirmation element for 'CDS Index Tranche'.</text>
</error>
</xsl:if>
<xsl:if test="($productType='CDS Index' or $productType='CDS Index Swaption') and $masterConfirmation !='' and $contractualTermsSupplement">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected masterConfirmation and contractualTermsSupplement elements for 'CDS Index' or 'CDS Index Swaption'.</text>
</error>
</xsl:if>
<xsl:if test="($productType='CDS Index' or $productType='CDS Index Swaption' or $productType='CDS Master') and $masterConfirmation !=''">
<xsl:call-template name="isValidmasterConfirmationType">
<xsl:with-param name="elementName">masterConfirmation</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:masterConfirmation/fpml:masterConfirmationType"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="$productType='CDS Index Swaption' and $contractualTermsSupplementForSwaption">
<xsl:call-template name="isValidcontractualTermsSupplementTypeForSwaption">
<xsl:with-param name="elementName">contractualTermsSupplement</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$contractualTermsSupplementForSwaption/fpml:type"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="($productType='CDS Index' or $productType='CDS Index Swaption') and $contractualTermsSupplement">
<xsl:call-template name="isValidcontractualTermsSupplementType">
<xsl:with-param name="elementName">contractualTermsSupplement</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="$contractualTermsSupplement/fpml:type"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="$productType='CDS Matrix'">
<xsl:for-each select="fpml:contractualSupplement">
<xsl:call-template name="isValidcontractualSupplement">
<xsl:with-param name="elementName">contractualSupplement</xsl:with-param>
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
<xsl:variable name="contractualSupplement" select="fpml:contractualSupplement"/>
<xsl:variable name="contractualSupplement1">
<xsl:value-of select="fpml:contractualSupplement[position()=1]"/>
</xsl:variable>
<xsl:variable name="contractualSupplement2">
<xsl:value-of select="fpml:contractualSupplement[position()=2]"/>
</xsl:variable>
<xsl:if test="$contractualSupplement and $productType='CDS Matrix'">
<xsl:if test="$contractualDefinitions='ISDA2003Credit' and ($contractualSupplement1 != 'ISDA2003CreditMay2003' or $contractualSupplement2 != 'ISDA2003Credit2005MatrixSupplement')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** First and second contractualSupplement must equal 'ISDA2003CreditMay2003' and ISDA2003Credit2005MatrixSupplement in that order if product type is 'CDS Matrix'. Value1 = '<xsl:value-of select="$contractualSupplement[1]"/>'.  Value2 = '<xsl:value-of select="$contractualSupplement[2]"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$productType='CDS' or $productType='CDS Index' or $productType='CDS Index Swaption' or $productType='CDS Master'">
<xsl:if test="fpml:contractualMatrix">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected contractualMatrix element encountered in this context.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$contractualSupplement and $productType='CDS Master'">
<xsl:if test="($contractualSupplement = 'ISDACreditMonolineInsurers')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** 'CDS Master' trades are not allowed with contractualSupplement of 'ISDACreditMonolineInsurers'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$productType='CDS Matrix' and fpml:contractualMatrix">
<xsl:call-template name="isValidmatrixTerm">
<xsl:with-param name="elementName">contractualMatrix</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:contractualMatrix/fpml:matrixTerm"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:creditSupportDocument">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected creditSupportDocument element encountered in this context.</text>
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
</xsl:template>
<xsl:template match="fpml:masterAgreement">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:call-template name="isValidMasterAgreementType">
<xsl:with-param name="elementName">masterAgreementType</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:masterAgreementType"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:if test="$productType='CDS'">
<xsl:if test="fpml:masterAgreementDate">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected masterAgreementDate element encountered in this context.</text>
</error>
</xsl:if>
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
<xsl:if test="fpml:swProductTerm and $productType='CDS Index'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected swProductTerm element. Element must not be present if product type is 'CDS Index'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swMessageText">
<xsl:if test="fpml:swMessageText=''">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Empty swMessageText element.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:variable name="messageText">
<xsl:value-of select="fpml:swMessageText"/>
</xsl:variable>
<xsl:if test="string-length($messageText) &gt; 200">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid swMessageText string length. Exceeded max length of 200 characters.</text>
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
<xsl:when test="fpml:swOriginatingEvent='Trade'"/>
<xsl:when test="fpml:swOriginatingEvent='Exercise'"/>
<xsl:when test="fpml:swOriginatingEvent='Novation'"/>
<xsl:when test="fpml:swOriginatingEvent='Backload'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***swOriginatingEvent element value is not supported. Supported values are '', 'Bunched Order Block', 'Bunched Order Allocation', 'Trade', 'Exercise', 'Novation', 'Backload' (for backloaded trade). Value = '<xsl:value-of select="fpml:swOriginatingEvent"/>'."/>
</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="fpml:swManualConfirmationRequired !='true'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid ManualConfirmation value encounted. Value should be set to 'True'</text>
</error>
</xsl:if>
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
<xsl:if test="fpml:swClearingBroker">
<xsl:if test="//fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swTradeHeader/fpml:swClientClearing !='true'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swClearingBroker must only be present when swClientClearing is present and set to true</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:swClearingBroker">
<xsl:if test="$isAllocatedTrade='1'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swTradeHeader/swClearingBroker must not be present on an allocated trade</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="//fpml:swCBTradeType">
<xsl:if test="not(//fpml:swCBClearedTimestamp) or (//fpml:swCBClearedTimestamp = '')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid timestamp. swCBClearedTimestamp must have a valid non empty value.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:swClearingHouse and $productType != 'CDS Index' and $productType != 'CDS Matrix' and $productType != 'CDS Index Swaption'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swTradeHeader/swClearingHouse is only expected on CDS Index and CDS Matrix trades.</text>
</error>
</xsl:if>
<xsl:if test="fpml:swPredeterminedClearerForUnderlyingSwap and $productType != 'CDS Index Swaption'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** swTradeHeader/swPredeterminedClearerForUnderlyingSwap is only expected on CDS Index Swaption trades.</text>
</error>
</xsl:if>
<xsl:apply-templates select="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails//fpml:swExtendedTradeDetails/fpml:swTradeHeader/fpml:swMandatoryClearing">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
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
</xsl:template>
<xsl:template match="fpml:partyTradeIdentifier">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:if test="$productType = 'CDS' or $productType = 'CDS Index' or $productType = 'CDS Index Swaption' or $productType='CDS Master' or $productType = 'CDS Matrix'">
<xsl:choose>
<xsl:when test="fpml:partyReference/@href=$generalTerms/fpml:buyerPartyReference/@href"/>
<xsl:when test="fpml:partyReference/@href=$generalTerms/fpml:sellerPartyReference/@href"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid partyReference/@href attribute value. Value = '<xsl:value-of select='fpml:partyReference/@href'/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
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
<xsl:if test="$productType = 'CDS' or $productType = 'CDS Index' or $productType = 'CDS Index Swaption' or $productType = 'CDS Master'">
<xsl:choose>
<xsl:when test="fpml:partyReference/@href=$generalTerms/fpml:buyerPartyReference/@href"/>
<xsl:when test="fpml:partyReference/@href=$generalTerms/fpml:sellerPartyReference/@href"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid partyReference/@href attribute value. Value = '<xsl:value-of select='fpml:partyReference/@href'/>'.</text>
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
<xsl:template match="fpml:creditDefaultSwap">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:apply-templates select="fpml:generalTerms">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:feeLeg">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:protectionTerms">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:physicalSettlementTerms">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected physicalSettlementTerms element encountered in this context.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:cashSettlementTerms">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:generalTerms">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:apply-templates select="fpml:effectiveDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:scheduledTerminationDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
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
<xsl:if test="$buyer=$seller">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** buyerPartyReference/@href and sellerPartyReference/@href values are the same.</text>
</error>
</xsl:if>
<xsl:if test="fpml:dateAdjustments and $productType!='CDS on MBS'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected dateAdjustments element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:referenceInformation) and ($productType='CDS' or $productType='CDS Master')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing referenceInformation element. Element must be present if product type is 'CDS' or 'CDS Master'.</text>
</error>
</xsl:if>
<xsl:if test="not(fpml:indexReferenceInformation) and ($productType='CDS Index' or $productType='CDS Index Swaption')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing indexReferenceInformation element. Element must be present if product type is 'CDS Index' or 'CDS  Index Swaption'.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:referenceInformation">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:indexReferenceInformation">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:feeLeg">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="fpml:initialPayment and $productType='CDS'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected initialPayment element. Element must not be present if product type is 'CDS'.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:initialPayment">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:singlePayment and ($productType='CDS Index' or $productType='CDS Index Swaption' or $productType='CDS Master' or $productType='CDS Matrix')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected singlePayment element. Element must not be present if product type is 'CDS Index', 'CDS Index Swaption', 'CDS Matrix' or 'CDS Master'.</text>
</error>
</xsl:if>
<xsl:if test="not(count(fpml:singlePayment)=0 or count(fpml:singlePayment)=1)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected number of singlePayment child elements encountered. 0 or 1 expected (<xsl:value-of select="count(fpml:singlePayment)"/> found).</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:singlePayment">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:periodicPayment">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:independentAmount">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected independentAmount element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:marketFixedRate">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">marketFixedRate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:marketFixedRate"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.00000000</xsl:with-param>
<xsl:with-param name="maxIncl">999.99999999</xsl:with-param>
<xsl:with-param name="maxDecs">8</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="//fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:swExtendedTradeDetails/fpml:swTradeHeader/fpml:swClientClearing ='true'">
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
<xsl:if test="$docsType ='StandardNorthAmericanCorporate' or $docsType ='ISDA2003StandardCreditNorthAmerican'">
<xsl:if test="fpml:quotationStyle">
<xsl:if test="fpml:quotationStyle = 'PointsUpFront' and not(fpml:initialPoints)">
<error><context><xsl:value-of select="$newContext"/></context><text>*** initialPoints must be present if quotationStyle is PointsUpFront.</text></error>
</xsl:if>
<xsl:if test="fpml:quotationStyle = 'TradedSpread' and not(fpml:marketFixedRate)">
<error><context><xsl:value-of select="$newContext"/></context><text>*** marketFixedRate must be present if quotationStyle is TradedSpread.</text></error>
</xsl:if>
</xsl:if>
</xsl:if>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:initialPayment">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="$productType='CDS' or $productType='CDS Index' or $productType='CDS Index Swaption' or $productType='CDS Master' or $productType='CDS Matrix' or $productType='CDS on Loans' or $productType='CDS on MBS'">
<xsl:choose>
<xsl:when test="fpml:payerPartyReference/@href=$generalTerms/fpml:buyerPartyReference/@href"/>
<xsl:when test="fpml:payerPartyReference/@href=$generalTerms/fpml:sellerPartyReference/@href"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid payerPartyReference/@href attribute value. Value = '<xsl:value-of select='fpml:payerPartyReference/@href'/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="$productType='CDS' or $productType='CDS Index' or $productType='CDS Index Swaption' or $productType='CDS Master' or $productType='CDS Matrix' or $productType='CDS on Loans' or $productType='CDS on MBS'">
<xsl:choose>
<xsl:when test="fpml:receiverPartyReference/@href=$generalTerms/fpml:buyerPartyReference/@href"/>
<xsl:when test="fpml:receiverPartyReference/@href=$generalTerms/fpml:sellerPartyReference/@href"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid receiverPartyReference/@href attribute value. Value = '<xsl:value-of select='fpml:receiverPartyReference/@href'/>'.</text>
</error>
</xsl:otherwise>
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
<xsl:apply-templates select="fpml:paymentAmount">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:singlePayment">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:if test="fpml:adjustedPaymentDate">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected adjustedPaymentDate element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:fixedAmount/fpml:currency != $tradeCurrency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** fixedAmount/currency must equal creditDefaultSwap/protectionTerms/calculationAmount/currency.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:fixedAmount">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:calculationAmount|fpml:fixedAmount">
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
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">amount</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:amount"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.0001</xsl:with-param>
<xsl:with-param name="maxIncl">9999999999999.9999</xsl:with-param>
<xsl:with-param name="maxDecs">4</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
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
<xsl:with-param name="minIncl">0.0000</xsl:with-param>
<xsl:with-param name="maxIncl">999999999999.9999</xsl:with-param>
<xsl:with-param name="maxDecs">4</xsl:with-param>
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
<xsl:with-param name="minIncl">0.0000</xsl:with-param>
<xsl:with-param name="maxIncl">999999999999.9999</xsl:with-param>
<xsl:with-param name="maxDecs">4</xsl:with-param>
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
<xsl:template match="novatedAmount">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:call-template name="isValidCurrency">
<xsl:with-param name="elementName">currency</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="currency"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
<xsl:variable name="amount">
<xsl:value-of select="amount"/>
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
<xsl:template match="fpml:periodicPayment">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="not(fpml:paymentFrequency) and $productType='CDS'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing paymentFrequency element. Element must be present if product type is 'CDS'.</text>
</error>
</xsl:if>
<xsl:if test="(fpml:firstPaymentDate or fpml:lastRegularPaymentDate or fpml:rollConvention) and ($productType='CDS Index' or $productType='CDS Index Swaption') and not($valueDate)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected firstPaymentDate, lastRegularPaymentDate or rollConvention element. Elements must not be present if product type is 'CDS Index' or 'CDS Index Swaption'.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:paymentFrequency">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="$productType = 'CDS' or $productType = 'CDS Master'">
<xsl:call-template name="isValidRollConvention">
<xsl:with-param name="elementName">rollConvention</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:rollConvention"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="$productType='CDS Matrix'">
<xsl:variable name="rollConventionTemp" select="//fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:feeLeg/fpml:periodicPayment/fpml:rollConvention"/>
<xsl:variable name="termDateMMDD" select="substring($generalTerms/fpml:scheduledTerminationDate/fpml:adjustableDate/fpml:unadjustedDate,6,5)"/>
<xsl:variable name="docsTypeTemp" select="string(/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:contractualMatrix/fpml:matrixTerm)"/>
<xsl:choose>
<xsl:when test="$productType='CDS Matrix' and (not(substring($docsTypeTemp, 1, 8)='Standard')) and (not(fpml:rollConvention) or ($rollConventionTemp='20')) and not($termDateMMDD='01-20' or $termDateMMDD='02-20' or $termDateMMDD='03-20' or $termDateMMDD='04-20' or $termDateMMDD='05-20' or $termDateMMDD='06-20' or $termDateMMDD='07-20' or $termDateMMDD='08-20' or $termDateMMDD='09-20' or $termDateMMDD='10-20' or $termDateMMDD='11-20' or $termDateMMDD='12-20')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** invalid roll date or roll type</text>
</error>
</xsl:when>
</xsl:choose>
</xsl:if>
<xsl:if test="fpml:fixedAmount">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected fixedAmount element encountered in this context.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:fixedAmountCalculation">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:adjustedPaymentDates">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected adjustedPaymentDates element encountered in this context.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:paymentFrequency">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:variable name="freq">
<xsl:value-of select="fpml:periodMultiplier"/>
<xsl:value-of select="fpml:period"/>
</xsl:variable>
<xsl:if test="$productType='CDS'">
<xsl:choose>
<xsl:when test="$freq='1M'"/>
<xsl:when test="$freq='3M'"/>
<xsl:when test="$freq='6M'"/>
<xsl:when test="$freq='1Y'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** paymentFrequency must be equal to 1M, 3M, 6M or 1Y if product type is 'CDS'. Value = '<xsl:value-of select="$freq"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:fixedAmountCalculation">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="fpml:calculationAmount">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected calculationAmount element encountered in this context.</text>
</error>
</xsl:if>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">fixedRate</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:fixedRate"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.00000000</xsl:with-param>
<xsl:with-param name="maxIncl">9.99999999</xsl:with-param>
<xsl:with-param name="maxDecs">8</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:template>
<xsl:template match="fpml:protectionTerms">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:apply-templates select="fpml:calculationAmount">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:creditEvents and ($productType='CDS Index' or  $productType='CDS Index Swaption')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected creditEvents element. Element must not be present if product type is 'CDS Index' or 'CDS Index Swaption'.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:creditEvents">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:obligations and $productType!='CDS on Loans'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected obligations element encountered in this context.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:creditEvents">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="fpml:bankruptcy">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected bankruptcy element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:failureToPay">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected failureToPay element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:obligationDefault">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected obligationDefault element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:obligationAcceleration">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected obligationAcceleration element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:repudiationMoratorium">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected repudiationMoratorium element encountered in this context.</text>
</error>
</xsl:if>
<xsl:apply-templates select="fpml:restructuring">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:defaultRequirement">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected defaultRequirement element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:creditEventNotice">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected creditEventNotice element encountered in this context.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:restructuring">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="$productType = 'CDS Matrix' or $productType='CDS Master'">
<xsl:if test="fpml:restructuringType">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected restructuringType element encountered in this context.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="not($productType = 'CDS Matrix' or $productType = 'CDS Master')">
<xsl:call-template name="isValidRestructuringType">
<xsl:with-param name="elementName">restructuringType</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:restructuringType"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:multipleHolderObligation">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected multipleHolderObligation element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:multipleCreditEventNotices">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected multipleCreditEventNotices element encountered in this context.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:cashSettlementTerms">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="fpml:settlementCurrency">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected settlementCurrency element is encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:valuationDate">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected valuationDate element encountered in this context.</text>
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
<xsl:if test="fpml:quotationMethod">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected quotationMethod element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:quotationAmount">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected quotationAmount element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:minimumQuotationAmount">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected minimumQuotationAmount element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:dealer">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected dealer element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:cashSettlementBusinessDays">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected cashSettlementBusinessDays element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:cashSettlementAmount">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected cashSettlementAmount element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:recoveryFactor and ($productType='CDS Index' or $productType='CDS Index Swaption' or $productType='CDS Master')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected recoveryFactor element. Element must not be present if product type is 'CDS Index', 'CDS Index Swaption' or 'CDS Master'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:recoveryFactor and not(//fpml:documentation/fpml:contractualSupplement ='ISDARecoveryLock' or //fpml:documentation/fpml:contractualSupplement='ISDAFixedRecovery')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Recovery factor  is allowed only with Recovery-Additional provisions'.</text>
</error>
</xsl:if>
<xsl:if test="(//fpml:documentation/fpml:contractualSupplement ='ISDARecoveryLock' or //fpml:documentation/fpml:contractualSupplement='ISDAFixedRecovery' )">
<xsl:if test="not(fpml:recoveryFactor)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Recovery factor should be present  with Recovery-Additional provisions'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:recoveryFactor">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">recoveryFactor</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:recoveryFactor"/>
</xsl:with-param>
<xsl:with-param name="minIncl">0.00000001</xsl:with-param>
<xsl:with-param name="maxIncl">1.00000000</xsl:with-param>
<xsl:with-param name="maxDecs">8</xsl:with-param>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:fixedSettlement and ($productType = 'CDS Index' or $productType = 'CDS Index Swaption' or $productType='CDS Master')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>***  fpml:fixedSettlement element is allowed only for product 'CDS Matrix'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:fixedSettlement and not(//fpml:documentation/fpml:contractualSupplement = 'ISDARecoveryLock')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** fixedSettlement is allowed only for Recovery Lock'.</text>
</error>
</xsl:if>
<xsl:if test="fpml:fixedSettlement">
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">fixedSettlement</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:fixedSettlement"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:accruedInterest">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected accruedInterest element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:valuationMethod">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected valuationMethod element encountered in this context.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:effectiveDate|fpml:scheduledTerminationDate/fpml:adjustableDate">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="$productType='CDS' or $productType='CDS Index' or $productType='CDS Index Swaption'">
<xsl:if test="fpml:dateAdjustments">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected dateAdjustments element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:dateAdjustmentsReference">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected dateAdjustmentsReference element encountered in this context.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:scheduledTerminationDate">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:apply-templates select="fpml:adjustableDate">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:referenceInformation">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:apply-templates select="fpml:referenceEntity">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:referenceObligation">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:allGuarantees">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected allGuarantees element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:referencePrice and $productType != 'CDS on MBS'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected referencePrice element encountered in this context.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:indexReferenceInformation">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="fpml:indexId">
<xsl:variable name="indexIdScheme">
<xsl:value-of select="fpml:indexId/@indexIdScheme"/>
</xsl:variable>
<xsl:if test="$indexIdScheme != 'http://www.fpml.org/spec/2003/instrument-id-RED-pair-1-0' and
($indexIdScheme != 'http://www.fpml.org/coding-scheme/external/standard-and-poors' and $contractualTermsSupplement = 'SP')">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or unrecognised indexId/@indexIdScheme attribute. Value = '<xsl:value-of select="$indexIdScheme"/>'.</text>
</error>
</xsl:if>
<xsl:if test="string-length(fpml:indexId) != 9">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid indexId element value length. RED index identifier must be 9 characters. Value = '<xsl:value-of select="fpml:indexId"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:variable name="tranche">
<xsl:value-of select="fpml:tranche"/>
</xsl:variable>
<xsl:apply-templates select="fpml:tranche">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:tranche">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:variable name="attachmentPoint">
<xsl:value-of select="fpml:attachmentPoint"/>
</xsl:variable>
<xsl:if test="$attachmentPoint=''">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing attachementPoint element for a tranche.</text>
</error>
</xsl:if>
<xsl:variable name="ePoint">
<xsl:value-of select="fpml:exhaustionPoint"/>
</xsl:variable>
<xsl:if test="$ePoint=''">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing exhaustionPoint element for a tranche.</text>
</error>
</xsl:if>
<xsl:if test="$attachmentPoint &lt; 0 or $attachmentPoint &gt; 1">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** attachementPoint must have a value between 0 and 1.</text>
</error>
</xsl:if>
<xsl:if test="$ePoint &lt; 0 or $ePoint &gt; 1">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** exhaustionPoint must have a value between 0 and 1.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:referenceEntity">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="fpml:entityId and $productType != 'CDS on MBS'">
<xsl:variable name="entityIdScheme">
<xsl:value-of select="fpml:entityId/@entityIdScheme"/>
</xsl:variable>
<xsl:if test="$entityIdScheme != 'http://www.fpml.org/spec/2003/entity-id-RED-1-0'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Missing or unrecognised entityId/@entityIdScheme attribute. Value = '<xsl:value-of select="$entityIdScheme"/>'.</text>
</error>
</xsl:if>
<xsl:if test="string-length(fpml:entityId) != 6">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid entityId element value length. RED entity identifier must be 6 characters. Value = '<xsl:value-of select="fpml:entityId"/>'.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:referenceObligation">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:apply-templates select="fpml:bond">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:convertibleBond">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected convertibleBond element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:primaryObligorReference and fpml:guarantorReference">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** primaryObligorReference and guarantorReference elements must not both be present.</text>
</error>
</xsl:if>
<xsl:if test="fpml:primaryObligor">
<xsl:if test="not(fpml:guarantorReference)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** primaryObligor element must only be present if guarantorReference element is present.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:primaryObligor">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:primaryObligorReference">
<xsl:if test="not(fpml:primaryObligorReference/@href=$generalTerms/fpml:referenceInformation/fpml:referenceEntity/@id)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** primaryObligorReference/@href must equal creditDefaultSwap/generalTerms/referenceInformation/referenceEntity/@id.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:guarantorReference">
<xsl:if test="not(fpml:guarantorReference/@href=$generalTerms/fpml:referenceInformation/fpml:referenceEntity/@id)">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** guarantorReference/@href must equal creditDefaultSwap/generalTerms/referenceInformation/referenceEntity/@id.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:guarantor">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected guarantor element encountered in this context.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:bond">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:apply-templates select="fpml:instrumentId">
<xsl:with-param name="context">
<xsl:value-of select="$newContext"/>
</xsl:with-param>
</xsl:apply-templates>
<xsl:if test="not(fpml:instrumentId/@instrumentIdScheme[
. = 'http://www.fpml.org/spec/2002/instrument-id-ISIN-1-0' or
. = 'http://www.fpml.org/spec/2002/instrument-id-CUSIP-1-0' or
. = 'http://www.fpml.org/spec/2003/instrument-id-RED-pair-1-0'])">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** ISIN, CUSIP or RED9 instrumentId must be present.</text>
</error>
</xsl:if>
<xsl:if test="fpml:instrumentId[@instrumentIdScheme='http://www.fpml.org/spec/2003/instrument-id-RED-pair-1-0']">
<xsl:variable name="redPairId">
<xsl:value-of select="fpml:instrumentId[@instrumentIdScheme='http://www.fpml.org/spec/2003/instrument-id-RED-pair-1-0']"/>
</xsl:variable>
<xsl:if test="string-length($redPairId) != 9">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Invalid instrumentId[@instrumentIdScheme='http://www.fpml.org/spec/2003/instrument-id-RED-pair-1-0'] element value length. RED pair identifier must be 9 characters. Value = '<xsl:value-of select="$redPairId"/>'.</text>
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
<xsl:if test="fpml:relatedExchangeId">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected relatedExchangeId element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:issuerName">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected issuerName element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:parValue">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected parValue element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:faceAmount">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected faceAmount element encountered in this context.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:instrumentId">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:if test="$productType = 'CDS Index' or $productType = 'CDS Index Swaption'">
<xsl:choose>
<xsl:when test="@instrumentIdScheme='http://www.fpml.org/spec/2002/instrument-id-ISIN-1-0'"/>
<xsl:when test="@instrumentIdScheme='http://www.fpml.org/spec/2002/instrument-id-CUSIP-1-0'"/>
<xsl:when test="@instrumentIdScheme='http://www.fpml.org/spec/2003/instrument-id-RED-pair-1-0'"/>
<xsl:otherwise>
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** @instrumentIdScheme value is invalid. Value = '<xsl:value-of select="@instrumentIdScheme"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:primaryObligor">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:variable name="entityName">
<xsl:value-of select="fpml:entityName"/>
</xsl:variable>
<xsl:if test="$entityName=''">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Empty entityName element.</text>
</error>
</xsl:if>
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
<xsl:if test="fpml:businessDayConvention != 'NotApplicable'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** businessDayConvention must be equal to 'NotApplicable' in this context. Value = '<xsl:value-of select="fpml:businessDayConvention"/>'</text>
</error>
</xsl:if>
<xsl:if test="fpml:businessCentersReference">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected businessCentersReference element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:businessCenters">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected businessCenters element encountered in this context.</text>
</error>
</xsl:if>
<xsl:if test="fpml:dateRelativeTo/@href != 'valuationDate'">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** dateRelativeTo/@href must be equal to "valuationDate" in this context. Value = '<xsl:value-of select="fpml:dateRelativeTo/@href"/>'</text>
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
<xsl:template match="fpml:dateAdjustments">
<xsl:param name="context"/>
<xsl:variable name="newContext">
<xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>
</xsl:variable>
<xsl:if test="fpml:businessCentersReference">
<error>
<context>
<xsl:value-of select="$newContext"/>
</context>
<text>*** Unexpected businessCentersReference element encountered in this context.</text>
</error>
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
<xsl:template name="isValidCDSConfirmationType">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> element. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='EuropeCorporate'"/>
<xsl:when test="$elementValue='EuropeInsurerSubDebt'"/>
<xsl:when test="$elementValue='EuropeSovereign'"/>
<xsl:when test="$elementValue='NorthAmericaCorporate'"/>
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
<xsl:template name="isValidCDSMatrixType">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> element. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='CreditDerivativesPhysicalSettlementMatrix'"/>
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
<xsl:template name="contractualSupplements">
<contractualSupplement>ISDA2003CreditMay2003</contractualSupplement>
<contractualSupplement>ISDADeliveryRestrictions</contractualSupplement>
<contractualSupplement>ISDA2003Credit2005MatrixSupplement</contractualSupplement>
<contractualSupplement>ISDACreditMonolineInsurers</contractualSupplement>
<contractualSupplement>ISDASecuredDeliverableObligationCharacteristic</contractualSupplement>
<contractualSupplement>ISDA2003CreditUSMunicipals</contractualSupplement>
<contractualSupplement>ISDALPNReferenceEntities</contractualSupplement>
<contractualSupplement>ISDAFixedRecovery</contractualSupplement>
<contractualSupplement>ISDARecoveryLock</contractualSupplement>
</xsl:template>
<xsl:template name="isValidcontractualSupplement">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="contractualSupplements" select="document('')/xsl:stylesheet/xsl:template[@name='contractualSupplements']/*"/>
<xsl:variable name="contractualDefinitions">
<xsl:value-of select="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:contractualDefinitions"/>
</xsl:variable>
<xsl:if test="not($elementValue = $contractualSupplements)">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** Empty or invalid <xsl:value-of select="$elementName"/> element. Value = '<xsl:value-of select="$elementValue"/>'.</text>
</error>
</xsl:if>
<xsl:if test="$elementValue = 'ISDA2003CreditMay2003' and $contractualDefinitions != 'ISDA2003Credit' ">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** ISDA2003CreditMay2003 is only allowed with Contractual Definitions ISDA2003Credit.</text>
</error>
</xsl:if>
<xsl:if test="$elementValue = 'ISDA2003Credit2005MatrixSupplement' and $contractualDefinitions != 'ISDA2003Credit' ">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** ISDA2003Credit2005MatrixSupplement is only allowed with Contractual Definitions ISDA2003Credit.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template name="isValidcontractualTermsSupplementTypeForSwaption">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> element. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='CDXSwaption'"/>
<xsl:when test="$elementValue='iTraxxAsiaExJapanSwaption'"/>
<xsl:when test="$elementValue='iTraxxAustraliaSwaption'"/>
<xsl:when test="$elementValue='iTraxxEuropeSwaption'"/>
<xsl:when test="$elementValue='iTraxxJapanSwaption'"/>
<xsl:when test="$elementValue='iTraxxSovXSwaption'"/>
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
<xsl:template name="isValidcontractualTermsSupplementType">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> element. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:if test="$tranche!=''">
<xsl:choose>
<xsl:when test="$elementValue='CDXEmergingMarketsDiversifiedTranche'"/>
<xsl:when test="$elementValue='CDXTranche'"/>
<xsl:when test="$elementValue='StandardCDXTranche'">
<xsl:call-template name="isValidStandardCDSIndex"/>
</xsl:when>
<xsl:when test="$elementValue='iTraxxAsiaExJapanTranche'"/>
<xsl:when test="$elementValue='iTraxxAustraliaTranche'"/>
<xsl:when test="$elementValue='iTraxxEuropeTranche'"/>
<xsl:when test="$elementValue='StandardiTraxxEuropeTranche'">
<xsl:call-template name="isValidStandardCDSIndex"/>
</xsl:when>
<xsl:when test="$elementValue='iTraxxJapanTranche'"/>
<xsl:when test="$elementValue='LCDXTranche'"/>
<xsl:when test="$elementValue='ABXTranche'"/>
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
<xsl:if test="$tranche=''">
<xsl:choose>
<xsl:when test="$elementValue='CDX'"/>
<xsl:when test="$elementValue='CDXEmergingMarkets'"/>
<xsl:when test="$elementValue='CDXEmergingMarketsDiversified'"/>
<xsl:when test="$elementValue='iTraxxAsiaExJapan'"/>
<xsl:when test="$elementValue='iTraxxAustralia'"/>
<xsl:when test="$elementValue='iTraxxEuropeDealer'"/>
<xsl:when test="$elementValue='iTraxxEuropeNonDealer'"/>
<xsl:when test="$elementValue='iTraxxEurope'"/>
<xsl:when test="$elementValue='iTraxxJapan'"/>
<xsl:when test="$elementValue='iTraxxSDI75Dealer'"/>
<xsl:when test="$elementValue='iTraxxSDI75NonDealer'"/>
<xsl:when test="$elementValue='iTraxxLevX'"/>
<xsl:when test="$elementValue='LCDX'"/>
<xsl:when test="$elementValue='StandardLCDXBullet'"/>
<xsl:when test="$elementValue='MCDX'"/>
<xsl:when test="$elementValue='ABX'"/>
<xsl:when test="$elementValue='CMBX'"/>
<xsl:when test="$elementValue='TRX'"/>
<xsl:when test="$elementValue='TRX.II'"/>
<xsl:when test="$elementValue='iTraxxSovX'"/>
<xsl:when test="$elementValue='PrimeX'"/>
<xsl:when test="$elementValue='IOS'"/>
<xsl:when test="$elementValue='PO'"/>
<xsl:when test="$elementValue='MBX'"/>
<xsl:when test="$elementValue='SP'"/>
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
<xsl:if test="$elementValue='ABX' or $elementValue='ABXTranche' or $elementValue='CMBX' or $elementValue='LCDXTranche' or $elementValue='MCDX' or $elementValue='PrimeX' or $elementValue='StandardLCDXBullet' or $elementValue='iTraxxLevX'">
<xsl:variable name="contractualDefinitions">
<xsl:value-of select="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:contractualDefinitions"/>
</xsl:variable>
<xsl:if test="$contractualDefinitions != '' and $contractualDefinitions = 'ISDA2006'">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** contractualDefinitions must not be 'ISDA2006' for type = '<xsl:value-of select="$elementValue"/>'.</text>
</error>
</xsl:if>
</xsl:if>
<xsl:if test="$elementValue='IOS' or $elementValue='MBX' or $elementValue='PO' or $elementValue='TRX' or $elementValue='TRX.II'">
<xsl:variable name="contractualDefinitions">
<xsl:value-of select="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:contractualDefinitions"/>
</xsl:variable>
<xsl:if test="$contractualDefinitions != '' and $contractualDefinitions != 'ISDA2006'">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** contractualDefinitions must be 'ISDA2006' for type = '<xsl:value-of select="$elementValue"/>'.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:template>
<xsl:template name="isValidStandardCDSIndex">
<xsl:variable name="contractualTermsSupplement">
<xsl:value-of select="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:contractualTermsSupplement/fpml:type"/>
</xsl:variable>
<xsl:variable name="attachmentPoint">
<xsl:value-of select="$generalTerms/fpml:indexReferenceInformation/fpml:tranche/fpml:attachmentPoint"/>
</xsl:variable>
<xsl:variable name="exhaustionPoint">
<xsl:value-of select="$generalTerms/fpml:indexReferenceInformation/fpml:tranche/fpml:exhaustionPoint"/>
</xsl:variable>
<xsl:variable name="fixedRate">
<xsl:value-of select="$creditDefaultSwap/fpml:feeLeg/fpml:periodicPayment/fpml:fixedAmountCalculation/fpml:fixedRate"/>
</xsl:variable>
<xsl:if test="$contractualTermsSupplement='StandardCDXTranche'">
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
<context>In creditDefaultSwap/generalTerms/indexReferenceInformation/tranche</context>
<text>*** The combination of attachment and exhaustion points is not valid when contractualTermsSupplement is 'StandardCDXTranche'. Value1 = '<xsl:value-of select="$attachmentPoint"/>'. Value2 = '<xsl:value-of select="$exhaustionPoint"/>'.</text>
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
<context>In creditDefaultSwap/feeLeg/periodicPayment/fixedAmountCalculation/fixedRate</context>
<text>*** The submitted fixed rate is not valid when contractualTermsSupplement is 'StandardCDXTranche'. Value = '<xsl:value-of select="$fixedRate"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="$contractualTermsSupplement='StandardiTraxxEuropeTranche'">
<xsl:choose>
<xsl:when test="$attachmentPoint='0' and $exhaustionPoint='0.03'"/>
<xsl:when test="$attachmentPoint='0.03' and $exhaustionPoint='0.06'"/>
<xsl:when test="$attachmentPoint='0.06' and $exhaustionPoint='0.09'"/>
<xsl:when test="$attachmentPoint='0.09' and $exhaustionPoint='0.12'"/>
<xsl:when test="$attachmentPoint='0.12' and $exhaustionPoint='0.22'"/>
<xsl:when test="$attachmentPoint='0.22' and $exhaustionPoint='1'"/>
<xsl:otherwise>
<error>
<context>In creditDefaultSwap/generalTerms/indexReferenceInformation/tranche</context>
<text>*** The combination of attachment and exhaustion points is not valid when contractualTermsSupplement is 'StandardiTraxxEuropeTranche'. Value1 = '<xsl:value-of select="$attachmentPoint"/>'. Value2 = '<xsl:value-of select="$exhaustionPoint"/>'.</text>
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
<context>In creditDefaultSwap/feeLeg/periodicPayment/fixedAmountCalculation/fixedRate</context>
<text>*** The submitted fixed rate is not valid when contractualTermsSupplement is 'StandardiTraxxEuropeTranche'. Value = '<xsl:value-of select="$fixedRate"/>'.</text>
</error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:template>
<xsl:template name="isValidmasterConfirmationType">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> element. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:if test="$productType = 'CDS Index' or productType = 'CDS Index Swaption'">
<xsl:choose>
<xsl:when test="$elementValue='2003CreditIndex'"/>
<xsl:when test="$elementValue='CDX.EM'"/>
<xsl:when test="$elementValue='CDX.EM.DIV'"/>
<xsl:when test="$elementValue='CDX.NA'"/>
<xsl:when test="$elementValue='iTraxx.Europe'"/>
<xsl:when test="$elementValue='iTraxx.Japan'"/>
<xsl:when test="$elementValue='iTraxx.Australia'"/>
<xsl:when test="$elementValue='iTraxx.AEJ'"/>
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
<xsl:if test="$productType = 'CDS Master'">
<xsl:choose>
<xsl:when test="$elementValue='ISDA2003CreditAsia'"/>
<xsl:when test="$elementValue='ISDA2003StandardCreditAsia'"/>
<xsl:when test="$elementValue='ISDA2003CreditAustraliaNewZealand'"/>
<xsl:when test="$elementValue='ISDA2003StandardCreditAustraliaNewZealand'"/>
<xsl:when test="$elementValue='ISDA2003CreditJapan'"/>
<xsl:when test="$elementValue='ISDA2003StandardCreditJapan'"/>
<xsl:when test="$elementValue='ISDA2004CreditSovereignAsia'"/>
<xsl:when test="$elementValue='ISDA2004StandardCreditSovereignAsia'"/>
<xsl:when test="$elementValue='ISDA2004CreditSovereignJapan'"/>
<xsl:when test="$elementValue='ISDA2004StandardCreditSovereignJapan'"/>
<xsl:when test="$elementValue='ISDA2004CreditSovereignLatinAmerican'"/>
<xsl:when test="$elementValue='ISDA2004StandardCreditSovereignLatinAmerican'"/>
<xsl:when test="$elementValue='ISDA2004CreditSovereignWesternEuropean'"/>
<xsl:when test="$elementValue='ISDA2004StandardCreditSovereignWesternEuropean'"/>
<xsl:when test="$elementValue='ISDA2003CreditNorthAmerican'"/>
<xsl:when test="$elementValue='ISDA2003StandardCreditNorthAmerican'"/>
<xsl:when test="$elementValue='ISDA2004CreditSovereignEmergingEuropeanAndMiddleEastern'"/>
<xsl:when test="$elementValue='ISDA2004StandardCreditSovereignEmergingEuropeanAndMiddleEastern'"/>
<xsl:when test="$elementValue='ISDA2003CreditSingapore'"/>
<xsl:when test="$elementValue='ISDA2003StandardCreditSingapore'"/>
<xsl:when test="$elementValue='ISDA2003CreditEuropean'"/>
<xsl:when test="$elementValue='ISDA2003StandardCreditEuropean'"/>
<xsl:when test="$elementValue='StandardUSMunicipalFullFaithAndCredit'"/>
<xsl:when test="$elementValue='StandardUSMunicipalGeneralFund'"/>
<xsl:when test="$elementValue='StandardUSMunicipalRevenue'"/>
<xsl:when test="$elementValue='2014CreditAsia'"/>
<xsl:when test="$elementValue='2014StandardCreditAsia'"/>
<xsl:when test="$elementValue='2014CreditAsiaFinancial'"/>
<xsl:when test="$elementValue='2014StandardCreditAsiaFinancial'"/>
<xsl:when test="$elementValue='2014CreditSovereignAsia'"/>
<xsl:when test="$elementValue='2014StandardCreditSovereignAsia'"/>
<xsl:when test="$elementValue='2014CreditAustraliaNewZealand'"/>
<xsl:when test="$elementValue='2014StandardCreditAustraliaNewZealand'"/>
<xsl:when test="$elementValue='2014CreditAustraliaNewZealandFinancial'"/>
<xsl:when test="$elementValue='2014StandardCreditAustraliaNewZealandFinancial'"/>
<xsl:when test="$elementValue='2014CreditSovereignEmergingEuropeanAndMiddleEastern'"/>
<xsl:when test="$elementValue='2014StandardCreditSovereignEmergingEuropeanAndMiddleEastern'"/>
<xsl:when test="$elementValue='2014CreditEuropean'"/>
<xsl:when test="$elementValue='2014StandardCreditEuropean'"/>
<xsl:when test="$elementValue='2014CreditEuropeanFinancial'"/>
<xsl:when test="$elementValue='2014StandardCreditEuropeanFinancial'"/>
<xsl:when test="$elementValue='2014CreditJapan'"/>
<xsl:when test="$elementValue='2014StandardCreditJapan'"/>
<xsl:when test="$elementValue='2014CreditJapanFinancial'"/>
<xsl:when test="$elementValue='2014StandardCreditJapanFinancial'"/>
<xsl:when test="$elementValue='2014CreditSovereignJapan'"/>
<xsl:when test="$elementValue='2014StandardCreditSovereignJapan'"/>
<xsl:when test="$elementValue='2014CreditSovereignLatinAmerican'"/>
<xsl:when test="$elementValue='2014StandardCreditSovereignLatinAmerican'"/>
<xsl:when test="$elementValue='2014CreditSovereignWesternEuropean'"/>
<xsl:when test="$elementValue='2014StandardCreditSovereignWesternEuropean'"/>
<xsl:when test="$elementValue='2014StandardCreditNorthAmerican'"/>
<xsl:when test="$elementValue='2014CreditNorthAmerican'"/>
<xsl:when test="$elementValue='2014StandardCreditNorthAmericanFinancial'"/>
<xsl:when test="$elementValue='2014CreditNorthAmericanFinancial'"/>
<xsl:when test="$elementValue='2014CreditSingapore'"/>
<xsl:when test="$elementValue='2014StandardCreditSingapore'"/>
<xsl:when test="$elementValue='2014CreditSingaporeFinancial'"/>
<xsl:when test="$elementValue='2014StandardCreditSingaporeFinancial'"/>
<xsl:when test="$elementValue='2014CreditEuropeanCoCoFinancial'"/>
<xsl:when test="$elementValue='2014StandardCreditEuropeanCoCoFinancial'"/>
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
<xsl:if test="$elementValue ='2014CreditAsia' or $elementValue='2014StandardCreditAsia' or $elementValue='2014CreditAsiaFinancial' or $elementValue='2014StandardCreditAsiaFinancial' or $elementValue='2014CreditSovereignAsia' or elementValue='2014StandardCreditSovereignAsia' or $elementValue='2014CreditAustraliaNewZealand' or $elementValue='2014StandardCreditAustraliaNewZealand' or $elementValue='2014CreditAustraliaNewZealandFinancial' or $elementValue='2014StandardCreditAustraliaNewZealandFinancial' or $elementValue='2014CreditSovereignEmergingEuropeanAndMiddleEastern' or $elementValue='2014StandardCreditSovereignEmergingEuropeanAndMiddleEastern' or $elementValue='2014CreditEuropean' or $elementValue='2014StandardCreditEuropean' or $elementValue='2014CreditEuropeanFinancial' or $elementValue='2014StandardCreditEuropeanFinancial' or $elementValue='2014CreditJapan' or $elementValue='2014StandardCreditJapan' or $elementValue='2014CreditJapanFinancial' or $elementValue='2014StandardCreditJapanFinancial' or $elementValue='2014CreditSovereignJapan' or $elementValue='2014StandardCreditSovereignJapan' or $elementValue='2014CreditSovereignLatinAmerican' or $elementValue='2014StandardCreditSovereignLatinAmerican' or $elementValue='2014CreditSovereignWesternEuropean' or $elementValue='2014StandardCreditSovereignWesternEuropean' or $elementValue='2014StandardCreditNorthAmerican' or $elementValue='2014CreditNorthAmerican' or $elementValue='2014StandardCreditNorthAmericanFinancial' or $elementValue='2014CreditNorthAmericanFinancial' or $elementValue='2014CreditSingapore' or $elementValue='2014StandardCreditSingapore' or $elementValue='2014CreditSingaporeFinancial' or $elementValue='2014StandardCreditSingaporeFinancial' or $elementValue='2014CreditEuropeanCoCoFinancial' or $elementValue='2014StandardCreditEuropeanCoCoFinancial' ">
<xsl:variable name="contractualDefinitions">
<xsl:value-of select="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:contractualDefinitions"/>
</xsl:variable>
<xsl:if test="$contractualDefinitions != '' and $contractualDefinitions != 'ISDA2014Credit'">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** contractualDefinitions must be 'ISDA2014Credit' for masterConfirmationType = '<xsl:value-of select="$elementValue"/>'.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
</xsl:template>
<xsl:template name="isValidmatrixTerm">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> element. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:if test="$productType = 'CDS Matrix'">
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
<xsl:when test="$elementValue='StandardUSMunicipalFullFaithAndCredit'"/>
<xsl:when test="$elementValue='StandardUSMunicipalGeneralFund'"/>
<xsl:when test="$elementValue='StandardUSMunicipalRevenue'"/>
<xsl:when test="$elementValue='USMunicipalFullFaithAndCredit'"/>
<xsl:when test="$elementValue='USMunicipalGeneralFund'"/>
<xsl:when test="$elementValue='USMunicipalRevenue'"/>
<xsl:when test="$elementValue='SukukCorporate'"/>
<xsl:when test="$elementValue='StandardSukukCorporate'"/>
<xsl:when test="$elementValue='SukukSovereign'"/>
<xsl:when test="$elementValue='StandardSukukSovereign'"/>
<xsl:when test="$elementValue='NorthAmericanFinancialCorporate'"/>
<xsl:when test="$elementValue='StandardNorthAmericanFinancialCorporate'"/>
<xsl:when test="$elementValue='EuropeanFinancialCorporate'"/>
<xsl:when test="$elementValue='StandardEuropeanFinancialCorporate'"/>
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
<xsl:when test="$elementValue='EuropeanCoCoFinancialCorporate'"/>
<xsl:when test="$elementValue='StandardEuropeanCoCoFinancialCorporate'"/>
<xsl:when test="$elementValue='EuropeanSeniorNonPreferredFinancialCorporate'"/>
<xsl:when test="$elementValue='StandardEuropeanSeniorNonPreferredFinancialCorporate'"/>
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
<xsl:if test="$elementValue='NorthAmericanFinancialCorporate' or $elementValue='StandardNorthAmericanFinancialCorporate' or $elementValue='EuropeanFinancialCorporate' or $elementValue='StandardEuropeanFinancialCorporate' or $elementValue='EmergingEuropeanFinancialCorporate' or $elementValue='StandardEmergingEuropeanFinancialCorporate' or $elementValue='EmergingEuropeanFinancialCorporateLPN' or $elementValue='StandardEmergingEuropeanFinancialCorporateLPN' or $elementValue='LatinAmericaFinancialCorporateBond' or $elementValue='StandardLatinAmericaFinancialCorporateBond' or $elementValue='LatinAmericaFinancialCorporateBondOrLoan' or $elementValue='StandardLatinAmericaFinancialCorporateBondOrLoan' or $elementValue='AustraliaFinancialCorporate' or $elementValue='StandardAustraliaFinancialCorporate' or $elementValue='NewZealandFinancialCorporate' or $elementValue='StandardNewZealandFinancialCorporate' or $elementValue='JapanFinancialCorporate' or $elementValue='StandardJapanFinancialCorporate' or $elementValue='SingaporeFinancialCorporate' or $elementValue='StandardSingaporeFinancialCorporate' or $elementValue='AsiaFinancialCorporate' or $elementValue='StandardAsiaFinancialCorporate' or $elementValue='SukukFinancialCorporate' or $elementValue='StandardSukukFinancialCorporate' or $elementValue='EuropeanCoCoFinancialCorporate' or $elementValue='StandardEuropeanCoCoFinancialCorporate' or $elementValue='EuropeanSeniorNonPreferredFinancialCorporate' or $elementValue='StandardEuropeanSeniorNonPreferredFinancialCorporate'">
<xsl:variable name="contractualDefinitions">
<xsl:value-of select="/fpml:SWDML/fpml:swLongFormTrade/fpml:swStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:contractualDefinitions"/>
</xsl:variable>
<xsl:if test="$contractualDefinitions != '' and $contractualDefinitions != 'ISDA2014Credit'">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** contractualDefinitions must be 'ISDA2014Credit' for matrixTerm = '<xsl:value-of select="$elementValue"/>'.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
</xsl:template>
<xsl:template name="isValidCurrency">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> element. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:if test="$productType='CDS' or $productType='CDS Index' or $productType='CDS Index Swaption'">
<xsl:choose>
<xsl:when test="$elementValue='CHF'"/>
<xsl:when test="$elementValue='EUR'"/>
<xsl:when test="$elementValue='GBP'"/>
<xsl:when test="$elementValue='JPY'"/>
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
</xsl:if>
</xsl:template>
<xsl:template name="isValidMasterAgreementType">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> element. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$productType='CDS Index' or $productType='CDS Index Swaption'">
<xsl:choose>
<xsl:when test="$elementValue='ISDA'"/>
<xsl:when test="$elementValue='AFB'"/>
<xsl:when test="$elementValue='German'"/>
<xsl:when test="$elementValue='Swiss'"/>
<xsl:when test="$elementValue='Other'"/>
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
<xsl:template name="isValidPeriod">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> element for product type of '<xsl:value-of select="$productType"/>'. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
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
<xsl:when test="$elementValue='CDS Index'"/>
<xsl:when test="$elementValue='CDS Index Swaption'"/>
<xsl:when test="$elementValue='CDS Matrix'"/>
<xsl:when test="$elementValue='CDS Master'"/>
<xsl:when test="$elementValue='CDS on Loans'"/>
<xsl:when test="$elementValue='CDS on MBS'"/>
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
<xsl:template name="isValidProductSubType">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> element when SWDML version = "<xsl:value-of select="$version"/>". Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:if test="$version='4-9'">
<xsl:choose>
<xsl:when test="$elementValue='LCDS'"/>
<xsl:when test="$elementValue='Bullet LCDS'"/>
<xsl:when test="$elementValue='ELCDS'"/>
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
<xsl:template name="isMortgageInsurerValid">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Error for <xsl:value-of select="$elementName"/> element when SWDML version = "<xsl:value-of select="$version"/>" MortgageInsurer = '<xsl:value-of select="$elementValue"/>' is not valid value (Applicable,NotApplicable).</xsl:variable>
<xsl:if test="$version='4-9' and $productType ='CDS on MBS' and $elementValue != 'Applicable' and $elementValue != 'NotApplicable' and $elementValue != ''">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** <xsl:value-of select="$errorText"/>
</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template name="isCompatibleMortgageSector">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="swProductSubTypeToCompare"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Error for <xsl:value-of select="$elementName"/> and swProductSubType elements when SWDML version = "<xsl:value-of select="$version"/>". mortgage sector = '<xsl:value-of select="$elementValue"/>' and swProductSubType ='<xsl:value-of select="$swProductSubTypeToCompare"/>' are not compatible.</xsl:variable>
<xsl:if test="$version='4-9'">
<xsl:choose>
<xsl:when test="($elementValue='CMBS' or $elementValue='') and $swProductSubTypeToCompare='CMBS'"/>
<xsl:when test="($elementValue='CMBS' or $elementValue='') and $swProductSubTypeToCompare='ECMBS'"/>
<xsl:when test="($elementValue='RMBS' or $elementValue='') and $swProductSubTypeToCompare='RMBS'"/>
<xsl:when test="($elementValue='RMBS' or $elementValue='') and $swProductSubTypeToCompare='ERMBS'"/>
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
<xsl:template name="areCompatible">
<xsl:param name="firstName"/>
<xsl:param name="firstValue"/>
<xsl:param name="secondName"/>
<xsl:param name="secondValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Error for <xsl:value-of select="$firstName"/> and <xsl:value-of select="$secondName"/>  when SWDML version = "<xsl:value-of select="$version"/>". the two values are not equals ('<xsl:value-of select="$firstValue"/>','<xsl:value-of select="$secondValue"/>').</xsl:variable>
<xsl:if test="$version='4-9'">
<xsl:choose>
<xsl:when test="$firstValue=$secondValue"/>
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
<xsl:when test="$productType='CDS Index' or $productType='CDS Index Swaption'">
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
<xsl:template match="fpml:swMandatoryClearing|fpml:swMandatoryClearingNewNovatedTrade">
<xsl:param name="context"/>
<xsl:if test="fpml:swMandatoryClearingIndicator">
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">swMandatoryClearingIndicator</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="fpml:swMandatoryClearingIndicator"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$context"/>
</xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:for-each select="fpml:swPartyExemption/fpml:swExemption">
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">swExemption</xsl:with-param>
<xsl:with-param name="elementValue">
<xsl:value-of select="current()"/>
</xsl:with-param>
<xsl:with-param name="testNumber"/>
<xsl:with-param name="context">
<xsl:value-of select="$context"/>
</xsl:with-param>
</xsl:call-template>
</xsl:for-each>
<xsl:if test="fpml:swPartyExemption[position()=1]/fpml:swPartyReference/@href = fpml:swPartyExemption[position()=2]/fpml:swPartyReference/@href">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** swPartyExemption cannot be provided twice for the same party for the same clearing jurisdiction</text>
</error>
</xsl:if>
<xsl:if test="current()[fpml:swJurisdiction/text()!='DoddFrank'][fpml:swSupervisoryBodyCategory]">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** swSupervisoryBodyCategory not supported for '<xsl:value-of select="fpml:swJurisdiction"/>' clearing</text>
</error>
</xsl:if>
<xsl:if test="current()[contains(';ASIC;JFSA;MAS;', concat(';', fpml:swJurisdiction/text(),';'))][fpml:swPartyExemption]">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** swPartyExemption cannot be provided for '<xsl:value-of select="fpml:swJurisdiction"/>'</text>
</error>
</xsl:if>
<xsl:if test="not(contains(';ASIC;CAN;ESMA;FCA;HKMA;JFSA;DoddFrank;MIFID;MAS;', concat(';', fpml:swJurisdiction/text(),';')))">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** This value:'<xsl:value-of select="fpml:swJurisdiction"/>' of swJurisdiction is not in supported list for clearing - Permitted values: ASIC;CAN;ESMA;FCA;HKMA;JFSA;DoddFrank;MIFID;MAS. Concat result: '<xsl:value-of select="concat(';', fpml:swJurisdiction/text(),';')"/>' function contains returns: '<xsl:value-of select="contains(';ASIC;CAN;ESMA;FCA;HKMA;JFSA;DoddFrank;MIFID;MAS;', concat(';', fpml:swJurisdiction/text(),';'))"/>'.</text>
</error>
</xsl:if>
<xsl:if test="current()[fpml:swJurisdiction/text()='JFSA'][fpml:swMandatoryClearingIndicator='true']">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** swJurisdiction not in supported list for clearing for Credit. Value:'<xsl:value-of select="fpml:Jurisdiction"/>'.</text>
</error>
</xsl:if>
<xsl:choose>
<xsl:when test="current()[fpml:swJurisdiction/text()='DoddFrank']">
<xsl:if test="parent::node()[local-name()='swTradeHeader']">
<xsl:if test="/fpml:SWDML/fpml:swTradeEventReportingDetails/fpml:swReportingRegimeInformation[fpml:swJurisdiction/text()=current()/fpml:swJurisdiction/text()]/fpml:swMandatoryClearingIndicator">
<xsl:if test="not(/fpml:SWDML/fpml:swTradeEventReportingDetails/fpml:swReportingRegimeInformation[fpml:swJurisdiction/text()=current()/fpml:swJurisdiction/text()]/fpml:swMandatoryClearingIndicator = current()/fpml:swMandatoryClearingIndicator)">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** Different values have been specified for swMandatoryClearingIndicator in reporting and clearing sections for jurisdiction '<xsl:value-of select="fpml:Jurisdiction"/>'.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
</xsl:when>
</xsl:choose>
<xsl:if test="current()[fpml:swInterAffiliateExemption]">
<xsl:if test="not(current()[fpml:swJurisdiction/text()='DoddFrank'])">
<xsl:if test="not(current()[fpml:swSupervisoryBodyCategory/text()='BroadBased'])">
<error>
<context>
<xsl:value-of select="$context"/>
</context>
<text>*** May only provide a value for swInterAffiliateExemption under CFTC (swJurisdiction='DoddFrank' and swSupervisoryBodyCategory='BroadBased'), value of '<xsl:value-of select="fpml:swInterAffiliateExemption"/>' has been provided under jurisdiction '<xsl:value-of select="fpml:swJurisdiction"/>'.</text>
</error>
</xsl:if>
</xsl:if>
</xsl:if>
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
</xsl:stylesheet>
