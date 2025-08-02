<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns:fpml="http://www.fpml.org/2004/FpML-4-1" exclude-result-prefixes="fpml" version="1.0">
<xsl:variable name="version">
<xsl:value-of select="/fpml:SWBML/@version"/>
</xsl:variable>
<xsl:variable name="productType">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:swbProductType"/>
</xsl:variable>
<xsl:variable name="FpMLVersion">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/@version"/>
</xsl:variable>
<xsl:variable name="tradeCurrency">
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade//fpml:swap/fpml:swapStream[position()=1]/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:currency"/>
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:capFloor/fpml:capFloorStream/fpml:calculationPeriodAmount/fpml:calculation/fpml:notionalSchedule/fpml:notionalStepSchedule/fpml:currency"/>
<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:protectionTerms/fpml:calculationAmount/fpml:currency"/>
</xsl:variable>
<xsl:template match="fpml:SWBML">
<xsl:variable name="newContext">In <xsl:value-of select="local-name()"/></xsl:variable>
<results version="1.0">
<xsl:if test="not($version='4-1')">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Invalid version attribute. Value = '<xsl:value-of select="$version"/>'.</text></error>
</xsl:if>
<xsl:apply-templates select="fpml:swbHeader">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:swbStructuredTradeDetails">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
</results>
</xsl:template>
<xsl:template match="fpml:swbHeader">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="count(fpml:swbRecipient) != 2">
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
<xsl:variable name="swbTradeSource"><xsl:value-of select="fpml:swbTradeSource"/></xsl:variable>
<xsl:if test="$swbTradeSource=''"><error><context><xsl:value-of select="$newContext"/></context><text>*** Empty swbTradeSource element.</text></error></xsl:if>
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
<xsl:if test="$productType = 'CDS' or $productType = 'CDS Index'">
<xsl:choose>
<xsl:when test="fpml:partyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:buyerPartyReference/@href"/>
<xsl:when test="fpml:partyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:sellerPartyReference/@href"/>
<xsl:otherwise>
<error><context><xsl:value-of select="$newContext"/></context><text>*** Invalid partyReference/@href attribute value. Value = '<xsl:value-of select='fpml:partyReference/@href'/>'.</text></error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="$productType = 'Equity Share Option' or $productType = 'Equity Index Option'">
<xsl:choose>
<xsl:when test="fpml:partyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:buyerPartyReference/@href"/>
<xsl:when test="fpml:partyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:sellerPartyReference/@href"/>
<xsl:otherwise>
<error><context><xsl:value-of select="$newContext"/></context><text>*** Invalid partyReference/@href attribute value. Value = '<xsl:value-of select='fpml:partyReference/@href'/>'.</text></error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
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
<xsl:apply-templates select="fpml:swbExtendedTradeDetails">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:FpML">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="not($FpMLVersion='4-1')">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Invalid version attribute. Value = '<xsl:value-of select="$FpMLVersion"/>'.</text></error>
</xsl:if>
<xsl:if test="fpml:validation">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected validation element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="not(fpml:trade)">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Missing trade element.</text></error>
</xsl:if>
<xsl:if test="not(count(fpml:party)=3 or count(fpml:party)=4)">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected number of party child elements encountered. 3 or 4 expected (<xsl:value-of select="count(fpml:party)"/> found).</text></error>
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
<xsl:if test="$productType='CDS' or $productType='CDS Index'">
<xsl:if test="not(fpml:creditDefaultSwap)">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Missing creditDefaultSwap element. Element must be present if product type is 'CDS' or 'CDS Index'.</text></error>
</xsl:if>
</xsl:if>
<xsl:if test="$productType='Equity Share Option' or $productType='Equity Index Option'">
<xsl:if test="not(fpml:equityOptionTransactionSupplement)">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Missing equityOptionTransactionSupplement element. Element must be present if product type is 'Equity Share Option' or 'Equity Index Option'.</text></error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:creditDefaultSwap|fpml:equityOptionTransactionSupplement">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:otherPartyPayment">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:calculationAgent and $productType!='CDS Index'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected calculationAgent element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="$productType='CDS Index'">
<xsl:if test="fpml:calculationAgent and /fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected calculationAgent element encounted.</text></error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:calculationAgentBusinessCenter">
<xsl:call-template name="isValidBusinessCenter">
<xsl:with-param name="elementName">calculationAgentBusinessCenter</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:calculationAgentBusinessCenter"/></xsl:with-param>
<xsl:with-param name="testNumber"></xsl:with-param>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:calculationAgentBusinessCenter and ($productType='Equity Share Option' or $productType='Equity Index Option')">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected calculationAgentBusinessCenter element encountered in this context if product type is 'CDS Index', 'Equity Share Option' or 'Equity Index Option'.</text></error>
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
<xsl:if test="$productType='CDS' or $productType='CDS Index'">
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
<xsl:if test="$productType='Equity Share Option' or $productType='Equity Index Option'">
<xsl:choose>
<xsl:when test="$broker=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:buyerPartyReference/@href">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Invalid brokerPartyReference/@href attribute value. Value = '<xsl:value-of select='$broker'/>'.</text></error>
</xsl:when>
<xsl:when test="$broker=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:sellerPartyReference/@href">
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
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:independentAmount">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="payer"><xsl:value-of select="fpml:payerPartyReference/@href"/></xsl:variable>
<xsl:choose>
<xsl:when test="$payer='partyA'"/>
<xsl:when test="$payer='partyB'"/>
<xsl:otherwise><error><context><xsl:value-of select="$newContext"/></context><text>*** Missing or invalid payerPartyReference/@href value. Value = '<xsl:value-of select="$payer"/>'.</text></error></xsl:otherwise>
</xsl:choose>
<xsl:variable name="receiver"><xsl:value-of select="fpml:receiverPartyReference/@href"/></xsl:variable>
<xsl:choose>
<xsl:when test="$receiver='partyA'"/>
<xsl:when test="$receiver='partyB'"/>
<xsl:otherwise><error><context><xsl:value-of select="$newContext"/></context><text>*** Missing or invalid receiverPartyReference/@href value. Value = '<xsl:value-of select="$receiver"/>'.</text></error></xsl:otherwise>
</xsl:choose>
<xsl:if test="$payer=$receiver"><error><context><xsl:value-of select="$newContext"/></context><text>*** payerPartyReference/@href and receiverPartyReference/@href values are the same.</text></error></xsl:if>
<xsl:apply-templates select="fpml:paymentDetail">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:paymentDetail">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
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
<xsl:template match="fpml:documentation">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="fpml:masterAgreement and ($productType='CDS Index' or $productType='Equity Share Option' or $productType='Equity Index Option')">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected masterAgreement element. Element must not be present if product type is 'CDS Index', 'Equity Share Option' or 'Equity Index Option'.</text></error>
</xsl:if>
<xsl:if test="fpml:contractualTermsSupplement and ($productType='CDS Index')">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected contractualTermsSupplement element. Element must not be present if product type is 'CDS Index'.</text></error>
</xsl:if>
<xsl:variable name="masterConfirmation"><xsl:value-of select="fpml:masterConfirmation"/></xsl:variable>
<xsl:variable name="brokerConfirmation"><xsl:value-of select="fpml:brokerConfirmation"/></xsl:variable>
<xsl:if test="$productType='CDS Index'">
<xsl:if test="$brokerConfirmation !='' and $masterConfirmation !=''">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected brokerConfirmation and masterConfirmation elements for product 'CDS Index'.</text></error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:masterAgreement">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="not(fpml:brokerConfirmation)">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Missing brokerConfirmation element.</text></error>
</xsl:if>
<xsl:apply-templates select="fpml:brokerConfirmation">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="$productType='CDS'">
<xsl:variable name="contractualDefinitions"><xsl:value-of select="fpml:contractualDefinitions"/></xsl:variable>
<xsl:if test="$contractualDefinitions != 'ISDA2003Credit'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** contractualDefinitions must equal 'ISDA2003Credit' if product type is 'CDS'.  Value = '<xsl:value-of select="$contractualDefinitions"/>'.</text></error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:contractualDefinitions and ($productType='CDS Index' or $productType='Equity Share Option' or $productType='Equity Index Option')">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected contractualDefinitions element. Element must not be present if product type is 'CDS Index', 'Equity Share Option' or 'Equity Index Option'.</text></error>
</xsl:if>
<xsl:if test="fpml:masterConfirmation and $productType='CDS Matrix'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected masterConfirmation element encountered for product 'CDS Matrix'.</text></error>
</xsl:if>
<xsl:if test="$productType='CDS Index'">
<xsl:if test="(fpml:masterConfirmation or fpml:brokerConfirmation) and fpml:contractualTermsSupplement">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected masterConfirmation or brokerConfirmation and contractualTermsSupplement elements for 'CDS Index'.</text></error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:contractualSupplement and ($productType='CDS Index' or $productType='Equity Share Option' or $productType='Equity Index Option')">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected contractualSupplement element. Element must not be present if product type is 'CDS Index', 'Equity Share Option' or 'Equity Index Option'.</text></error>
</xsl:if>
<xsl:apply-templates select="fpml:contractualSupplement">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:brokerConfirmation/fpml:brokerConfirmationType = 'NorthAmericaMonolineInsurer'">
<xsl:if test="not(fpml:contractualSupplement[.='ISDA2003CreditMonolineInsurers'])">
<error><context><xsl:value-of select="$newContext"/></context><text>*** A contractualSupplement element containing 'ISDA2003CreditMonolineInsurers' must be present if brokerConfirmationType contains 'NorthAmericaMonolineInsurer'.</text></error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:contractualSupplement[.='ISDA2003CreditMonolineInsurers']">
<xsl:if test="not(fpml:brokerConfirmation/fpml:brokerConfirmationType = 'NorthAmericaMonolineInsurer')">
<error><context><xsl:value-of select="$newContext"/></context><text>*** A contractualSupplement element containing 'ISDA2003CreditMonolineInsurers' must only be present if brokerConfirmationType contains 'NorthAmericaMonolineInsurer'.</text></error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:contractualMatrix">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected contractualMatrix element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:creditSupportDocument">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected creditSupportDocument element encountered in this context.</text></error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:brokerConfirmation">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="brokerConfirmationTypeScheme"><xsl:value-of select="fpml:brokerConfirmationType/@brokerConfirmationTypeScheme"/></xsl:variable>
<xsl:if test="$brokerConfirmationTypeScheme != 'http://www.swapswire.com/spec/2004/broker-confirmation-type-1-0'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Missing or unrecognised brokerConfirmationType/@brokerConfirmationTypeScheme attribute value. Value = '<xsl:value-of select="$brokerConfirmationTypeScheme"/>'.</text></error>
</xsl:if>
<xsl:if test="$productType = 'CDS'">
<xsl:call-template name="isValidCDSConfirmationType">
<xsl:with-param name="elementName">brokerConfirmationType</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:brokerConfirmationType"/></xsl:with-param>
<xsl:with-param name="testNumber"></xsl:with-param>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="$productType = 'Equity Share Option' or $productType = 'Equity Index Option'">
<xsl:call-template name="isValidEquityConfirmationType">
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
</xsl:template>
<xsl:template match="fpml:contractualSupplement">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:choose>
<xsl:when test=".='ISDA2003CreditMay2003'"/>
<xsl:when test=".='ISDA2003CreditMonolineInsurers'"/>
<xsl:otherwise>
<error><context><xsl:value-of select="$newContext"/></context><text>*** contractualSupplement element value is invalid. Value = '<xsl:value-of select="."/>'.</text></error>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template match="fpml:masterAgreement">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="masterAgreementTypeScheme"><xsl:value-of select="fpml:masterAgreementType/@masterAgreementTypeScheme"/></xsl:variable>
<xsl:if test="$masterAgreementTypeScheme != 'http://www.swapswire.com/spec/2001/master-agreement-type-1-0'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Missing or unrecognised masterAgreementType/@masterAgreementTypeScheme attribute. Value = '<xsl:value-of select="$masterAgreementTypeScheme"/>'.</text></error>
</xsl:if>
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
<xsl:if test="not(fpml:swbProductTerm) and $productType='CDS'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Missing swbProductTerm element. Element must be present if product type is 'CDS', 'Equity Share Option' or 'Equity Index Option'.</text></error>
</xsl:if>
<xsl:if test="fpml:swbProductTerm and ($productType='CDS Index' or $productType='Equity Share Option' or $productType='Equity Index Option')">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected swbProductTerm element. Element must not be present if product type is 'CDS Index', 'Equity Share Option' or 'Equity Index Option'.</text></error>
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
<xsl:apply-templates select="fpml:swbDeltaCross">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:swbProductTerm">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="period"><xsl:value-of select="fpml:period"/></xsl:variable>
<xsl:if test="not($period='W' or $period='M' or $period='Y')"><error><context><xsl:value-of select="$newContext"/></context><text>*** period must be equal to 'W', 'M' or 'Y'. Value = '<xsl:value-of select="$period"/>'</text></error></xsl:if>
<xsl:if test="$period='W'">
<xsl:if test="not($productType='OIS')">
<error><context><xsl:value-of select="$newContext"/></context><text>*** period can only be in expressed in weeks (W) if product type is 'OIS'.</text></error>
</xsl:if>
</xsl:if>
<xsl:variable name="periodMultiplier"><xsl:value-of select="fpml:periodMultiplier"/></xsl:variable>
<xsl:if test="$period='W'">
<xsl:call-template name="isValidIntegerNumber">
<xsl:with-param name="elementName">periodMultiplier</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="$periodMultiplier"/></xsl:with-param>
<xsl:with-param name="minIncl">1</xsl:with-param>
<xsl:with-param name="maxIncl">3</xsl:with-param>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="$period='M'">
<xsl:call-template name="isValidIntegerNumber">
<xsl:with-param name="elementName">periodMultiplier</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="$periodMultiplier"/></xsl:with-param>
<xsl:with-param name="minIncl">1</xsl:with-param>
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
<xsl:template match="fpml:swbDeltaCross">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:choose>
<xsl:when test="fpml:buyerPartyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:buyerPartyReference/@href"/>
<xsl:when test="fpml:buyerPartyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:sellerPartyReference/@href"/>
<xsl:otherwise>
<error><context><xsl:value-of select="$newContext"/></context><text>*** Invalid buyerPartyReference/@href attribute value. Value = '<xsl:value-of select='fpml:buyerPartyReference/@href'/>'.</text></error>
</xsl:otherwise>
</xsl:choose>
<xsl:choose>
<xsl:when test="fpml:sellerPartyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:buyerPartyReference/@href"/>
<xsl:when test="fpml:sellerPartyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:sellerPartyReference/@href"/>
<xsl:otherwise>
<error><context><xsl:value-of select="$newContext"/></context><text>*** Invalid sellerPartyReference/@href attribute value. Value = '<xsl:value-of select='fpml:sellerPartyReference/@href'/>'.</text></error>
</xsl:otherwise>
</xsl:choose>
<xsl:if test="fpml:buyerPartyReference/@href = fpml:sellerPartyReference/@href">
<error><context><xsl:value-of select="$newContext"/></context><text>*** buyerPartyReference/@href and sellerPartyReference/@href values are the same.</text></error>
</xsl:if>
<xsl:if test="not(fpml:equity) and $productType = 'Equity Share Option'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Missing equity element when product type is 'Equity Share Option'.</text></error>
</xsl:if>
<xsl:if test="$productType = 'Equity Share Option'">
<xsl:if test="not(fpml:equity/fpml:instrumentId = //fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:underlyer/fpml:singleUnderlyer/fpml:equity/fpml:instrumentId)">
<error><context><xsl:value-of select="$newContext"/></context><text>*** The equity/instrumentId must equal the //FpML/trade/equityOptionTransactionSupplement/underlyer/singleUnderlyer/equity/instrumentId.</text></error>
</xsl:if>
</xsl:if>
<xsl:apply-templates select="fpml:equity|fpml:future">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:swbPrice">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swbQuantity</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:swbQuantity"/></xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">999999999</xsl:with-param>
<xsl:with-param name="maxDecs">0</xsl:with-param>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
<xsl:if test="fpml:swbDelta">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">swbDelta</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:swbDelta"/></xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">9.9999999</xsl:with-param>
<xsl:with-param name="maxDecs">7</xsl:with-param>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:swbPrice">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="not(fpml:currency = //fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:equityPremium/fpml:paymentAmount/fpml:currency)">
<error><context><xsl:value-of select="$newContext"/></context><text>*** The currency must equal //FpML/trade/equityOptionTransactionSupplement/equityPremium/paymentAmount/currency.</text></error>
</xsl:if>
<xsl:if test="$productType = 'Equity Share Option'">
<xsl:choose>
<xsl:when test="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:brokerConfirmation/fpml:brokerConfirmationType='2004EquityEuropeanInterdealer'">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">amount</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:amount"/></xsl:with-param>
<xsl:with-param name="minIncl">0.00001</xsl:with-param>
<xsl:with-param name="maxIncl">9999.99999</xsl:with-param>
<xsl:with-param name="maxDecs">5</xsl:with-param>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
</xsl:when>
<xsl:when test="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:brokerConfirmation/fpml:brokerConfirmationType='ISDA2005EquityJapaneseInterdealer'">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">amount</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:amount"/></xsl:with-param>
<xsl:with-param name="minIncl">0.00001</xsl:with-param>
<xsl:with-param name="maxIncl">999999999.99999</xsl:with-param>
<xsl:with-param name="maxDecs">5</xsl:with-param>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
</xsl:when>
<xsl:otherwise><error><context><xsl:value-of select="$newContext"/></context><text>*** Empty or invalid brokerConfirmationType element. Value = '<xsl:value-of select="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:brokerConfirmation/fpml:brokerConfirmationType"/>'.</text></error></xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="$productType='Equity Index Option'">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">amount</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:amount"/></xsl:with-param>
<xsl:with-param name="minIncl">0.00001</xsl:with-param>
<xsl:with-param name="maxIncl">999999999.99999</xsl:with-param>
<xsl:with-param name="maxDecs">5</xsl:with-param>
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
<xsl:if test="$productType = 'CDS' or $productType = 'CDS Index'">
<xsl:choose>
<xsl:when test="fpml:partyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:buyerPartyReference/@href"/>
<xsl:when test="fpml:partyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:sellerPartyReference/@href"/>
<xsl:otherwise>
<error><context><xsl:value-of select="$newContext"/></context><text>*** Invalid partyReference/@href attribute value. Value = '<xsl:value-of select='fpml:partyReference/@href'/>'.</text></error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="$productType = 'Equity Share Option' or $productType = 'Equity Index Option'">
<xsl:choose>
<xsl:when test="fpml:partyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:buyerPartyReference/@href"/>
<xsl:when test="fpml:partyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:sellerPartyReference/@href"/>
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
<xsl:if test="$productType = 'CDS' or $productType = 'CDS Index'">
<xsl:choose>
<xsl:when test="fpml:partyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:buyerPartyReference/@href"/>
<xsl:when test="fpml:partyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:sellerPartyReference/@href"/>
<xsl:otherwise>
<error><context><xsl:value-of select="$newContext"/></context><text>*** Invalid partyReference/@href attribute value. Value = '<xsl:value-of select='fpml:partyReference/@href'/>'.</text></error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="$productType = 'Equity Share Option' or $productType = 'Equity Index Option'">
<xsl:choose>
<xsl:when test="fpml:partyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:buyerPartyReference/@href"/>
<xsl:when test="fpml:partyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:sellerPartyReference/@href"/>
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
<error>
<context><xsl:value-of select="$newContext"/></context><text>*** Invalid partyId element.</text>
</error>
</xsl:if>
<xsl:variable name="partyName"><xsl:value-of select="fpml:partyName"/></xsl:variable>
<xsl:if test="fpml:partyName">
<xsl:if test="$partyName=''"><error><context><xsl:value-of select="$newContext"/></context><text>*** Empty partyName element.</text></error></xsl:if>
</xsl:if>
<xsl:if test="string-length($partyName) &gt; 200"><error><context><xsl:value-of select="$newContext"/></context><text>*** Invalid partyName string length. Exceeded max length of 200 characters.</text></error></xsl:if>
</xsl:template>
<xsl:template match="fpml:otherPartyPayment">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:if test="$productType='CDS' or $productType='CDS Index'">
<xsl:choose>
<xsl:when test="fpml:payerPartyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:buyerPartyReference/@href"/>
<xsl:when test="fpml:payerPartyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:sellerPartyReference/@href"/>
<xsl:otherwise>
<error><context><xsl:value-of select="$newContext"/></context><text>*** Invalid payerPartyReference/@href attribute value. Value = '<xsl:value-of select='fpml:payerPartyReference/@href'/>'.</text></error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="$productType='CDS' or $productType='CDS Index'">
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
<xsl:if test="$productType='Equity Share Option' or $productType='Equity Index Option'">
<xsl:choose>
<xsl:when test="fpml:payerPartyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:buyerPartyReference/@href"/>
<xsl:when test="fpml:payerPartyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:sellerPartyReference/@href"/>
<xsl:otherwise>
<error><context><xsl:value-of select="$newContext"/></context><text>*** Invalid payerPartyReference/@href attribute value. Value = '<xsl:value-of select='fpml:payerPartyReference/@href'/>'.</text></error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="$productType='Equity Share Option' or $productType='Equity Index Option'">
<xsl:choose>
<xsl:when test="fpml:receiverPartyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:buyerPartyReference/@href">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Invalid receiverPartyReference/@href attribute value. Value = '<xsl:value-of select='fpml:receiverPartyReference/@href'/>'.</text></error>
</xsl:when>
<xsl:when test="fpml:receiverPartyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:sellerPartyReference/@href">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Invalid receiverPartyReference/@href attribute value. Value = '<xsl:value-of select='fpml:receiverPartyReference/@href'/>'.</text></error>
</xsl:when>
<xsl:otherwise/>
</xsl:choose>
</xsl:if>
<xsl:variable name="href1"><xsl:value-of select="fpml:payerPartyReference/@href"/></xsl:variable>
<xsl:variable name="href2"><xsl:value-of select="fpml:receiverPartyReference/@href"/></xsl:variable>
<xsl:if test="$href1=$href2"><error><context><xsl:value-of select="$newContext"/></context><text>*** payerPartyReference/@href and receiverPartyReference/@href values are the same.</text></error></xsl:if>
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
<xsl:if test="not(fpml:referenceInformation) and $productType='CDS'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Missing referenceInformation element. Element must be present if product type is 'CDS'.</text></error>
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
<xsl:if test="fpml:singlePayment and $productType='CDS Index'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected singlePayment element. Element must not be present if product type is 'CDS Index'.</text></error>
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
<xsl:if test="fpml:independentAmount">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected independentAmount element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:marketFixedRate">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">marketFixedRate</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:marketFixedRate"/></xsl:with-param>
<xsl:with-param name="minIncl">0.00000000</xsl:with-param>
<xsl:with-param name="maxIncl">9.99999999</xsl:with-param>
<xsl:with-param name="maxDecs">8</xsl:with-param>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:initialPayment">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="$productType='CDS' or $productType='CDS Index'">
<xsl:choose>
<xsl:when test="fpml:payerPartyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:buyerPartyReference/@href"/>
<xsl:when test="fpml:payerPartyReference/@href=/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:sellerPartyReference/@href"/>
<xsl:otherwise>
<error><context><xsl:value-of select="$newContext"/></context><text>*** Invalid payerPartyReference/@href attribute value. Value = '<xsl:value-of select='fpml:payerPartyReference/@href'/>'.</text></error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="$productType='CDS' or $productType='CDS Index'">
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
<xsl:if test="$href1=$href2"><error><context><xsl:value-of select="$newContext"/></context><text>*** payerPartyReference/@href and receiverPartyReference/@href values are the same.</text></error></xsl:if>
<xsl:if test="fpml:adjustablePaymentDate">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected adjustablePaymentDate element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:adjustedPaymentDate">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected adjustedPaymentDate element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:paymentAmount/fpml:currency != $tradeCurrency">
<error><context><xsl:value-of select="$newContext"/></context><text>*** paymentAmount/currency must equal //FpML/trade/creditDefaultSwap/protectionTerms/calculationAmount/currency.</text></error>
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
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">paymentAmount/amount</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:amount"/></xsl:with-param>
<xsl:with-param name="minIncl">1.00</xsl:with-param>
<xsl:with-param name="maxIncl">999999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:brokerConfirmation/fpml:brokerConfirmationType='2004EquityEuropeanInterdealer' and ancestor::fpml:equityOptionTransactionSupplement">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">amount</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:amount"/></xsl:with-param>
<xsl:with-param name="minIncl">0.00</xsl:with-param>
<xsl:with-param name="maxIncl">9999999999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:brokerConfirmation/fpml:brokerConfirmationType='ISDA2005EquityJapaneseInterdealer' and ancestor::fpml:equityOptionTransactionSupplement">
<xsl:call-template name="isValidIntegerNumber">
<xsl:with-param name="elementName">amount</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:amount"/></xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">901000000000000</xsl:with-param>
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
<xsl:if test="(fpml:paymentFrequency or fpml:firstPaymentDate or fpml:lastRegularPaymentDate or fpml:rollConvention) and $productType='CDS Index'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected paymentFrequency, firstPaymentDate, lastRegularPaymentDate or rollConvention element. Elements must not be present if product type is 'CDS Index'.</text></error>
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
<xsl:if test="$productType='SingleCurrencyInterestRateSwap' or $productType='CapFloor' or $productType='Swaption' or $productType='CDS'">
<xsl:choose>
<xsl:when test="$freq='1M'"/>
<xsl:when test="$freq='3M'"/>
<xsl:when test="$freq='6M'"/>
<xsl:when test="$freq='1Y'"/>
<xsl:otherwise><error><context><xsl:value-of select="$newContext"/></context><text>*** paymentFrequency must be equal to 1M, 3M, 6M or 1Y if product type is 'SingleCurrencyInterestRateSwap', 'CapFloor', 'Swaption' or 'CDS'. Value = '<xsl:value-of select="$freq"/>'.</text></error></xsl:otherwise>
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
<xsl:with-param name="minIncl">0.00000001</xsl:with-param>
<xsl:with-param name="maxIncl">9.99999999</xsl:with-param>
<xsl:with-param name="maxDecs">8</xsl:with-param>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
<xsl:if test="fpml:dayCountFraction">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected dayCountFraction element encountered in this context.</text></error>
</xsl:if>
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
<xsl:if test="fpml:obligationDefault">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected obligationDefault element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:obligationAcceleration">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected obligationAcceleration element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:repudiationMoratorium">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected repudiationMoratorium element encountered in this context.</text></error>
</xsl:if>
<xsl:apply-templates select="fpml:restructuring">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
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
<xsl:call-template name="isValidRestructuringType">
<xsl:with-param name="elementName">restructuringType</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:restructuringType"/></xsl:with-param>
<xsl:with-param name="testNumber"></xsl:with-param>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
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
<xsl:if test="$productType='CDS' or $productType='CDS Index'">
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
<xsl:variable name="indexName"><xsl:value-of select="fpml:indexName"/></xsl:variable>
<xsl:if test="$indexName=''">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Empty indexName element.</text></error>
</xsl:if>
<xsl:if test="fpml:indexId">
<xsl:variable name="indexIdScheme"><xsl:value-of select="fpml:indexId/@indexIdScheme"/></xsl:variable>
<xsl:if test="$indexIdScheme != 'http://www.fpml.org/spec/2003/instrument-id-RED-pair-1-0'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Missing or unrecognised indexId/@indexIdScheme attribute. Value = '<xsl:value-of select="$indexIdScheme"/>'.</text></error>
</xsl:if>
<xsl:if test="string-length(fpml:indexId) != 9">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Invalid indexId element value length. RED index identifier must be 9 characters. Value = '<xsl:value-of select="fpml:indexId"/>'.</text></error>
</xsl:if>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:referenceEntity">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="entityName"><xsl:value-of select="fpml:entityName"/></xsl:variable>
<xsl:if test="$entityName=''">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Empty entityName element.</text></error>
</xsl:if>
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
<xsl:if test="fpml:relatedExchangeId">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected relatedExchangeId element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:issuerName">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected issuerName element encountered in this context.</text></error>
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
<xsl:if test="$productType = 'CDS' or $productType = 'CDS Index'">
<xsl:choose>
<xsl:when test="@instrumentIdScheme='http://www.fpml.org/spec/2002/instrument-id-ISIN-1-0'"/>
<xsl:when test="@instrumentIdScheme='http://www.fpml.org/spec/2002/instrument-id-CUSIP-1-0'"/>
<xsl:when test="@instrumentIdScheme='http://www.fpml.org/spec/2003/instrument-id-RED-pair-1-0'"/>
<xsl:otherwise>
<error><context><xsl:value-of select="$newContext"/></context><text>*** @instrumentIdScheme value is invalid. Value = '<xsl:value-of select="@instrumentIdScheme"/>'.</text></error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="$productType = 'Equity Share Option' or $productType = 'Equity Index Option'">
<xsl:choose>
<xsl:when test="@instrumentIdScheme='http://www.fpml.org/spec/2003/instrument-id-Reuters-RIC-1-0'"/>
<xsl:otherwise>
<error><context><xsl:value-of select="$newContext"/></context><text>*** @instrumentIdScheme value is invalid. Value = '<xsl:value-of select="@instrumentIdScheme"/>'.</text></error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:primaryObligor">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="entityName"><xsl:value-of select="fpml:entityName"/></xsl:variable>
<xsl:if test="$entityName=''">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Empty entityName element.</text></error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:equityOptionTransactionSupplement">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:variable name="buyer"><xsl:value-of select="fpml:buyerPartyReference/@href"/></xsl:variable>
<xsl:if test="not(/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:party[@id=$buyer])">
<error><context><xsl:value-of select="$newContext"/></context><text>*** The buyerPartyReference/@href value does not match an //FpML/party/@id value for any party. Value = '<xsl:value-of select="$buyer"/>'.</text></error>
</xsl:if>
<xsl:variable name="seller"><xsl:value-of select="fpml:sellerPartyReference/@href"/></xsl:variable>
<xsl:if test="not(/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:party[@id=$seller])">
<error><context><xsl:value-of select="$newContext"/></context><text>*** The sellerPartyReference/@href value does not match an //FpML/party/@id value for any party. Value = '<xsl:value-of select="$seller"/>'.</text></error>
</xsl:if>
<xsl:if test="$buyer=$seller"><error><context><xsl:value-of select="$newContext"/></context><text>*** buyerPartyReference/@href and sellerPartyReference/@href values are the same.</text></error></xsl:if>
<xsl:if test="fpml:equityEffectiveDate">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected equityEffectiveDate element encountered in this context.</text></error>
</xsl:if>
<xsl:apply-templates select="fpml:underlyer">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:notional">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected notional element encountered in this context.</text></error>
</xsl:if>
<xsl:apply-templates select="fpml:equityExercise">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:fxFeature">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected fxFeature element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:strategyFeature">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected strategyFeature element encountered in this context.</text></error>
</xsl:if>
<xsl:apply-templates select="fpml:strike">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:spotPrice">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected spotPrice element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:brokerConfirmation/fpml:brokerConfirmationType='2004EquityEuropeanInterdealer'">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">numberOfOptions</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:numberOfOptions"/></xsl:with-param>
<xsl:with-param name="minIncl">1</xsl:with-param>
<xsl:with-param name="maxIncl">999999999.99999</xsl:with-param>
<xsl:with-param name="maxDecs">5</xsl:with-param>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:brokerConfirmation/fpml:brokerConfirmationType='ISDA2005EquityJapaneseInterdealer'">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">numberOfOptions</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:numberOfOptions"/></xsl:with-param>
<xsl:with-param name="minIncl">1</xsl:with-param>
<xsl:with-param name="maxIncl">900999999.99</xsl:with-param>
<xsl:with-param name="maxDecs">2</xsl:with-param>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:apply-templates select="fpml:equityPremium">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="$productType='Equity Share Option' and not(/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:brokerConfirmation/fpml:brokerConfirmationType='ISDA2005EquityJapaneseInterdealer')">
<xsl:call-template name="isValidBoolean">
<xsl:with-param name="elementName">exchangeLookAlike</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:exchangeLookAlike"/></xsl:with-param>
<xsl:with-param name="testNumber"></xsl:with-param>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="$productType='Equity Share Option' and fpml:exchangeLookAlike and /fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:brokerConfirmation/fpml:brokerConfirmationType='ISDA2005EquityJapaneseInterdealer'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected exchangeLookAlike element encountered in this context when product type is 'Equity Share Option' and brokerConfirmationType is 'ISDA2005JapaneseInterdealer'.</text></error>
</xsl:if>
<xsl:if test="$productType='Equity Index Option' and fpml:exchangeLookAlike">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected exchangeLookAlike element encountered in this context when product type is 'Equity Index Option'.</text></error>
</xsl:if>
<xsl:if test="fpml:exchangeTradedContractNearest">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected exchangeTradedContractNearest element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:multipleExchangeIndexAnnexFallback">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected multipleExchangeIndexAnnexFallback element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="($productType = 'Equity Index Option' and fpml:methodOfAdjustment) or (/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:brokerConfirmation/fpml:brokerConfirmationType='ISDA2005EquityJapaneseInterdealer' and fpml:methodOfAdjustment)">
<error>
<context><xsl:value-of select="$newContext"/></context>
<text>*** Unexpected methodOfAdjustment element encountered in this context. Element must not be present when product type is 'Equity Index Option' or when brokerConfirmationType is 'ISDA2005EquityJapaneseInterdealer'.</text>
</error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:underlyer">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:apply-templates select="fpml:singleUnderlyer">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:basket">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected basket element encountered in this context.</text></error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:singleUnderlyer">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="not(fpml:equity) and $productType = 'Equity Share Option'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Missing equity element when product type is 'Equity Share Option'.</text></error>
</xsl:if>
<xsl:if test="not(fpml:index) and $productType = 'Equity Index Option'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Missing index element when product type is 'Equity Index Option'.</text></error>
</xsl:if>
<xsl:apply-templates select="fpml:equity|fpml:index">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:openUnits">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected openUnits element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:dividendPayout">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected dividendPayout element encountered in this context.</text></error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:equity|fpml:index">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="not(count(fpml:instrumentId)=1)">
<error><context><xsl:value-of select="$newContext"/></context><text>*** The instrumentId element must occur once only in this context</text></error>
</xsl:if>
<xsl:if test="fpml:description">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected  description element encountered in this context.</text></error>
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
<xsl:if test="(ancestor::fpml:swbDeltaCross and fpml:relatedExchangeId) or ($productType='Equity Share Option' and /fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:brokerConfirmation/fpml:brokerConfirmationType='ISDA2005EquityJapaneseInterdealer' and fpml:relatedExchangeId)">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected relatedExchangeId element encountered in this context when ancestor is swbDeltaCross or when product type is 'Equity Share Option' and brokerConfirmationType is 'ISDA2005EquityJapaneseInterdealer.</text></error>
</xsl:if>
<xsl:if test="fpml:optionsExchangeId">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected optionsExchangeId element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:futureId">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected futureId element encountered in this context.</text></error>
</xsl:if>
<xsl:apply-templates select="fpml:instrumentId">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:relatedExchangeId">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:future">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="not(count(fpml:instrumentId)=1)">
<error><context><xsl:value-of select="$newContext"/></context><text>*** The instrumentId element must occur once only in this context</text></error>
</xsl:if>
<xsl:if test="not(fpml:instrumentId/@instrumentIdScheme = 'http://www.swapswire.com/spec/2005/future-id-1-0')">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Invalid instrumentId/@instrumentIdScheme attribute value. It must equal 'http://www.swapswire.com/spec/2005/future-id-1-0'</text></error>
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
<xsl:apply-templates select="fpml:relatedExchangeId">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:optionsExchangeId">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected optionsExchangeId element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:multiplier">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected multiplier element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:futureContractReference">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected futureContractReference element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="not(fpml:maturity)">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Missing maturity element.</text></error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:relatedExchangeId">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/>[<xsl:number value="position()"/>]</xsl:variable>
<xsl:if test="$productType = 'Equity Share Option' or $productType = 'Equity Index Option'">
<xsl:choose>
<xsl:when test="@exchangeIdScheme='http://www.fpml.org/spec/2002/exchange-id-REC-1-0'"/>
<xsl:otherwise>
<error><context><xsl:value-of select="$newContext"/></context><text>*** @exchangeIdScheme value is invalid. Value = '<xsl:value-of select="@exchangeIdScheme"/>'.</text></error>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:equityExercise">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="fpml:equityBermudaExercise">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected equityBermudaExercise element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:equityAmericanExercise and /fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:brokerConfirmation/fpml:brokerConfirmationType='ISDA2005EquityJapaneseInterdealer'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected equityAmericanExercise element in this context when brokerConfirmationType is 'ISDA2005EquityJapaneseInterdealer'. Only European Style options can be confirmed under the Japanse Master Confirmation.</text></error>
</xsl:if>
<xsl:if test="$productType='Equity Share Option' or $productType='Equity Index Option'">
<xsl:if test="not(fpml:automaticExercise[.='true'])">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Invalid automaticExercise element value. Must contain 'true' when product type is 'Equity Share Option' or 'Equity Index Option'.</text></error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:prePayment">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected prePayment element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:settlementDate and fpml:settlementType != 'Cash'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected settlementDate element encountered in this context when settlementType is not 'Cash'. settlementDate only applies to cash settled options.</text></error>
</xsl:if>
<xsl:if test="not(fpml:settlementCurrency = //fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:equityPremium/fpml:paymentAmount/fpml:currency) and not(/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:brokerConfirmation/fpml:brokerConfirmationType='ISDA2008EquityJapanese')">
<error><context><xsl:value-of select="$newContext"/></context><text>*** settlementCurrency must equal //FpML/trade/equityOptionTransactionSupplement/equityPremium/paymentAmount/currency, unless the brokerConfirmationType is 'ISDA2008EquityJapanese'.</text></error>
</xsl:if>
<xsl:if test="fpml:settlementPriceSource">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected settlementPriceSource element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="not(fpml:settlementType[.='Physical']) and $productType='Equity Share Option' and /fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:brokerConfirmation/fpml:brokerConfirmationType='ISDA2005EquityJapaneseInterdealer'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Invalid settlementType element encountered in this context when brokerConfirmationType is 'ISDA2005EquityJapaneseInterdealer' and product type = 'Equity Share Option'. Share Options confirmed under the Japanse Master Confirmation.must be physically settled.</text></error>
</xsl:if>
<xsl:if test="fpml:settlementMethodElectionDate">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected settlementMethodElectionDate element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:settlementMethodElectingPartyReference">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected settlementMethodElectingPartyReference element encountered in this context.</text></error>
</xsl:if>
<xsl:apply-templates select="fpml:equityEuropeanExercise|fpml:equityAmericanExercise">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:equityValuation">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:settlementDate">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:equityValuation">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="not(count(child::*)=0)">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected child elements encountered in this context.</text></error>
</xsl:if>
<xsl:if test="(./@id !='valuationDate' or not(./@id)) and //fpml:equityExercise/fpml:settlementDate">
<error><context><xsl:value-of select="$newContext"/></context><text>*** @id must be present and must be equal to "valuationDate" in this context if //equityExercise/settlementDate is present. Value = "<xsl:value-of select="./@id"/>". </text></error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:settlementDate">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="fpml:adjustableDate">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected adjustableDate element encountered in this context.</text></error>
</xsl:if>
<xsl:apply-templates select="fpml:relativeDate">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="fpml:relativeDate">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:call-template name="isValidPeriodMultiplier">
<xsl:with-param name="elementName">periodMultiplier</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:periodMultiplier"/></xsl:with-param>
<xsl:with-param name="testNumber"></xsl:with-param>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
<xsl:if test="fpml:period!='D'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** period must be equal to 'D' in this context. Value = '<xsl:value-of select="fpml:period"/>'</text></error>
</xsl:if>
<xsl:if test="fpml:dayType != 'CurrencyBusiness'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** dayType must be equal to 'CurrencyBusiness' in this context. Value = '<xsl:value-of select="fpml:dayType"/>'</text></error>
</xsl:if>
<xsl:if test="fpml:businessDayConvention != 'NotApplicable'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** businessDayConvention must be equal to 'NotApplicable' in this context. Value = '<xsl:value-of select="fpml:businessDayConvention"/>'</text></error>
</xsl:if>
<xsl:if test="fpml:businessCentersReference">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected businessCentersReference element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:businessCenters">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected businessCenters element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:dateRelativeTo/@href != 'valuationDate'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** dateRelativeTo/@href must be equal to "valuationDate" in this context. Value = '<xsl:value-of select="fpml:dateRelativeTo/@href"/>'</text></error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:strike">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:brokerConfirmation/fpml:brokerConfirmationType='2004EquityEuropeanInterdealer'">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">strikePrice</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:strikePrice"/></xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">1000000.00000</xsl:with-param>
<xsl:with-param name="maxDecs">5</xsl:with-param>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:brokerConfirmation/fpml:brokerConfirmationType='ISDA2005EquityJapaneseInterdealer'">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">strikePrice</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:strikePrice"/></xsl:with-param>
<xsl:with-param name="minIncl">0</xsl:with-param>
<xsl:with-param name="maxIncl">9999999.999999</xsl:with-param>
<xsl:with-param name="maxDecs">6</xsl:with-param>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="fpml:strikePercentage">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected strikePercentage element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="$productType='Equity Share Option'">
<xsl:if test="not(fpml:currency)">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Missing currency element. Required in this context when product type is 'Equity Share Option'.</text></error>
</xsl:if>
<xsl:if test="not(fpml:currency = //fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:equityPremium/fpml:paymentAmount/fpml:currency)">
<error><context><xsl:value-of select="$newContext"/></context><text>*** The currency must equal //FpML/trade/equityOptionTransactionSupplement/equityPremium/paymentAmount/currency.</text></error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:currency and $productType='Equity Index Option'">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected currency element encountered in this context when product type is 'Equity Index Option'.</text></error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:equityPremium">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="not(fpml:payerPartyReference/@href = /fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:buyerPartyReference/@href)">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Invalid payerPartyReference/@href attribute value. The payerPartyReference/@href must be equal to //FpML/trade/equityOptionTransactionSupplement/buyerPartyReference/@href (payer of premium is option buyer).</text></error>
</xsl:if>
<xsl:if test="not(fpml:receiverPartyReference/@href = /fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:equityOptionTransactionSupplement/fpml:sellerPartyReference/@href)">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Invalid receiverPartyReference/@href attribute value. The receiverPartyReference/@href must be equal to //FpML/trade/equityOptionTransactionSupplement/sellerPartyReference/@href (receiver of premium is option seller).</text></error>
</xsl:if>
<xsl:if test="fpml:premiumType">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected premiumType element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="not(fpml:paymentAmount)">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Missing paymentAmount element. Required in this context.</text></error>
</xsl:if>
<xsl:apply-templates select="fpml:paymentAmount">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="not(fpml:paymentAmount/fpml:currency = fpml:pricePerOption/fpml:currency)">
<error><context><xsl:value-of select="$newContext"/></context><text>*** The paymentAmount/currency and pricePerOption/currency must be equal.</text></error>
</xsl:if>
<xsl:if test="not(fpml:paymentDate)">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Missing paymentDate element. Required in this context.</text></error>
</xsl:if>
<xsl:apply-templates select="fpml:paymentDate">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:swapPremium">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected swapPremium element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="not(fpml:pricePerOption)">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Missing pricePerOption element. Required in this context.</text></error>
</xsl:if>
<xsl:apply-templates select="fpml:pricePerOption">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:percentageOfNotional">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected percentageOfNotional element encountered in this context.</text></error>
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
<xsl:if test="$productType='Equity Share Option' or $productType='Equity Index Option'">
<xsl:if test="not(fpml:businessDayConvention[.='NotApplicable'])">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Invalid businessDayConvention element value. Must contain 'NotApplicable' when product type is 'Equity Share Option' or 'Equity Index Option'.</text></error>
</xsl:if>
<xsl:if test="fpml:businessCenters">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected businessCenters element encountered in this context when product type is 'Equity Share Option' or 'Equity Index Option'.</text></error>
</xsl:if>
</xsl:if>
<xsl:if test="fpml:businessCentersReference">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected businessCentersReference element encountered in this context.</text></error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:pricePerOption">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:if test="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:brokerConfirmation/fpml:brokerConfirmationType='2004EquityEuropeanInterdealer'">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">amount</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:amount"/></xsl:with-param>
<xsl:with-param name="minIncl">0.00001</xsl:with-param>
<xsl:with-param name="maxIncl">9999.99999</xsl:with-param>
<xsl:with-param name="maxDecs">5</xsl:with-param>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
</xsl:if>
<xsl:if test="/fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:brokerConfirmation/fpml:brokerConfirmationType='ISDA2005EquityJapaneseInterdealer'">
<xsl:call-template name="isValidNumber">
<xsl:with-param name="elementName">amount</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:amount"/></xsl:with-param>
<xsl:with-param name="minIncl">0.00001</xsl:with-param>
<xsl:with-param name="maxIncl">999999.99999</xsl:with-param>
<xsl:with-param name="maxDecs">5</xsl:with-param>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:equityEuropeanExercise">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:apply-templates select="fpml:expirationDate">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:equityExpirationTime">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected equityExpirationTime element encountered in this context.</text></error>
</xsl:if>
<xsl:call-template name="isValidEquityExpirationTimeType">
<xsl:with-param name="elementName">equityExpirationTimeType</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:equityExpirationTimeType"/></xsl:with-param>
<xsl:with-param name="testNumber"></xsl:with-param>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
</xsl:template>
<xsl:template match="fpml:expirationDate|fpml:commencementDate">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:apply-templates select="fpml:adjustableDate">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="fpml:relativeDate">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected relativeDate element encountered in this context.</text></error>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:equityAmericanExercise">
<xsl:param name="context"/>
<xsl:variable name="newContext"><xsl:value-of select="$context"/>/<xsl:value-of select="local-name()"/></xsl:variable>
<xsl:apply-templates select="fpml:commencementDate">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:apply-templates select="fpml:expirationDate">
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:apply-templates>
<xsl:if test="not(fpml:commencementDate/fpml:adjustableDate/fpml:unadjustedDate = //fpml:FpML/fpml:trade/fpml:tradeHeader/fpml:tradeDate)">
<error><context><xsl:value-of select="$newContext"/></context><text>*** The commencementDate/adjustableDate/unadjustedDate must equal the //FpML/trade/tradeHeader/tradeDate (American exercise period must commence on the trade date).</text></error>
</xsl:if>
<xsl:if test="fpml:latestExerciseTime">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected latestExerciseTime element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:latestExerciseTimeType">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected latestExerciseTimeType element encountered in this context.</text></error>
</xsl:if>
<xsl:if test="fpml:equityExpirationTime">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected equityExpirationTime element encountered in this context.</text></error>
</xsl:if>
<xsl:call-template name="isValidEquityExpirationTimeType">
<xsl:with-param name="elementName">equityExpirationTimeType</xsl:with-param>
<xsl:with-param name="elementValue"><xsl:value-of select="fpml:equityExpirationTimeType"/></xsl:with-param>
<xsl:with-param name="testNumber"></xsl:with-param>
<xsl:with-param name="context"><xsl:value-of select="$newContext"/></xsl:with-param>
</xsl:call-template>
<xsl:if test="fpml:equityMultipleExercise">
<error><context><xsl:value-of select="$newContext"/></context><text>*** Unexpected equityMultipleExercise element encountered in this context.</text></error>
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
<xsl:when test="$elementValue='INMU'"/>
<xsl:when test="$elementValue='ILTA'"/>
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
<xsl:when test="$elementValue='VZCA'"/>
<xsl:when test="$elementValue='ZAJO'"/>
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
<xsl:when test="$elementValue='DJ.CDX.EM'"/>
<xsl:when test="$elementValue='CDX.NA'"/>
<xsl:when test="$elementValue='CDX.EM'"/>
<xsl:when test="$elementValue='CDXEmergingMarketsDiversified'"/>
<xsl:when test="$elementValue='CDXTranche'"/>
<xsl:when test="$elementValue='iTraxxEurope'"/>
<xsl:when test="$elementValue='iTraxxEuropeTranche'"/>
<xsl:when test="$elementValue='iTraxxCJ'"/>
<xsl:when test="$elementValue='iTraxxCJTranche'"/>
<xsl:when test="$elementValue='iTraxxAsiaExJapan'"/>
<xsl:when test="$elementValue='iTraxxAsiaExJapanTranche'"/>
<xsl:when test="$elementValue='iTraxxAustralia'"/>
<xsl:when test="$elementValue='iTraxxAustraliaTranche'"/>
<xsl:when test="$elementValue='iTraxxSDI75'"/>
<xsl:otherwise><error><context><xsl:value-of select="$context"/></context><text>*** <xsl:value-of select="$errorText"/></text></error></xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template name="isValidEquityConfirmationType">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> element. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$elementValue='2004EquityEuropeanInterdealer'"/>
<xsl:when test="$elementValue='ISDA2005EquityJapaneseInterdealer'"/>
<xsl:otherwise><error><context><xsl:value-of select="$context"/></context><text>*** <xsl:value-of select="$errorText"/></text></error></xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template name="isValidEquityExpirationTimeType">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> element. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:choose>
<xsl:when test="$productType = 'Equity Index Option' and /fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:brokerConfirmation/fpml:brokerConfirmationType='2004EquityEuropeanInterdealer'">
<xsl:choose>
<xsl:when test="$elementValue='OSP'"/>
<xsl:when test="$elementValue='Open'"/>
<xsl:when test="$elementValue='Close'"/>
<xsl:otherwise>
<error><context><xsl:value-of select="$context"/></context><text>*** <xsl:value-of select="$errorText"/> When product type is 'Equity Index Option' and brokerConfirmationType is '2004EquityEuropeanInterdealer', the permitted values are 'OSP', 'Open' or 'Close'.</text></error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$productType = 'Equity Share Option' and /fpml:SWBML/fpml:swbStructuredTradeDetails/fpml:FpML/fpml:trade/fpml:documentation/fpml:brokerConfirmation/fpml:brokerConfirmationType='2004EquityEuropeanInterdealer'">
<xsl:choose>
<xsl:when test="$elementValue='AsSpecifiedInMasterConfirmation'"/>
<xsl:when test="$elementValue='Open'"/>
<xsl:when test="$elementValue='Close'"/>
<xsl:otherwise>
<error><context><xsl:value-of select="$context"/></context><text>*** <xsl:value-of select="$errorText"/> When product type is 'Equity Share Option' and brokerConfirmationType is '2004EquityEuropeanInterdealer', the permitted values are 'AsSpecifiedInMasterConfirmation', 'Open' or 'Close'.</text></error>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:otherwise>
<xsl:choose>
<xsl:when test="$elementValue='AsSpecifiedInMasterConfirmation'"/>
<xsl:otherwise>
<error><context><xsl:value-of select="$context"/></context><text>*** <xsl:value-of select="$errorText"/> Element must be passed with a value of 'AsSpecifiedInMasterConfirmation' when brokerConfirmationType is 'ISDA2005EquityJapaneseInterdealer'.</text></error>
</xsl:otherwise>
</xsl:choose>
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
<xsl:when test="$productType='CDS' or $productType='CDS Index'">
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
<xsl:choose>
<xsl:when test="$productType='CDS Index'">
<xsl:choose>
<xsl:when test="$elementValue='ISDA'"/>
<xsl:when test="$elementValue='AFB'"/>
<xsl:when test="$elementValue='German'"/>
<xsl:when test="$elementValue='Swiss'"/>
<xsl:when test="$elementValue='Other'"/>
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
<xsl:template name="isValidPeriod">
<xsl:param name="elementName"/>
<xsl:param name="elementValue"/>
<xsl:param name="testNumber"/>
<xsl:param name="context"/>
<xsl:variable name="errorText">Empty or invalid <xsl:value-of select="$elementName"/> element for product type of '<xsl:value-of select="$productType"/>'. Value = '<xsl:value-of select="$elementValue"/>'.</xsl:variable>
<xsl:if test="not($productType='OIS')">
<xsl:choose>
<xsl:when test="$elementValue='D'"/>
<xsl:when test="$elementValue='M'"/>
<xsl:when test="$elementValue='Y'"/>
<xsl:otherwise><error><context><xsl:value-of select="$context"/></context><text>*** <xsl:value-of select="$errorText"/></text></error></xsl:otherwise>
</xsl:choose>
</xsl:if>
<xsl:if test="$productType='OIS'">
<xsl:choose>
<xsl:when test="$elementValue='D'"/>
<xsl:when test="$elementValue='M'"/>
<xsl:when test="$elementValue='Y'"/>
<xsl:when test="$elementValue='T'"/>
<xsl:otherwise><error><context><xsl:value-of select="$context"/></context><text>*** <xsl:value-of select="$errorText"/></text></error></xsl:otherwise>
</xsl:choose>
</xsl:if>
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
<xsl:if test="$version='4-1'">
<xsl:choose>
<xsl:when test="$elementValue='CDS'"/>
<xsl:when test="$elementValue='CDS Index'"/>
<xsl:when test="$elementValue='Equity Share Option'"/>
<xsl:when test="$elementValue='Equity Index Option'"/>
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
<xsl:when test="$productType='OIS'">
<xsl:choose>
<xsl:when test="$elementValue='NONE'"/>
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
<xsl:when test="not($productType='OIS')">
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
</xsl:stylesheet>
