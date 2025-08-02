<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns:fpml="http://www.fpml.org/2010/FpML-4-9"
xmlns="http://www.fpml.org/2010/FpML-4-9"
exclude-result-prefixes="fpml"
version="1.0">
<xsl:output method="xml" encoding="iso-8859-1" indent="yes"/>
<xsl:output omit-xml-declaration="yes" indent="yes"/>
<xsl:strip-space elements="*"/>
<xsl:param name="broker_partyid" select="'BBroker'"/>
<xsl:param name="broker_partyname" select="'Test Broker'"/>
<xsl:param name="broker_tradeid" select="'_broker_tradeid_'"/>
<xsl:param name="broker_tradeversionid" select="1"/>
<xsl:param name="broker_tradesource" select="'Voice'"/>
<xsl:param name="product_term_period_multiplier" select="1"/>
<xsl:param name="product_term_period" select="'Y'"/>
<xsl:template match="@*|node()">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>
<xsl:template match="*[local-name() = 'FpML']">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
<xsl:element name="party" namespace="{namespace-uri()}">
<xsl:attribute name="id">broker</xsl:attribute>
<xsl:element name="partyId" namespace="{namespace-uri()}"><xsl:value-of select="$broker_partyid"/></xsl:element>
<xsl:element name="partyName" namespace="{namespace-uri()}"><xsl:value-of select="$broker_partyname"/></xsl:element>
</xsl:element>
</xsl:copy>
</xsl:template>
<xsl:template match="*[local-name() = 'swLongFormTrade']">
<xsl:apply-templates select="@*|node()"/>
</xsl:template>
<xsl:template match="*[local-name() = 'swOriginatorPartyReference']"/>
<xsl:template match="*[local-name() = 'swBackLoadingFlag']"/>
<xsl:template match="*[local-name() = 'exchangeId']"/>
<xsl:template match="*[local-name() = 'description']"/>
<xsl:template match="*[local-name() = 'swTemplateName']"/>
<xsl:template name="swb_recipient">
<xsl:param name="id"/>
<xsl:param name="href"/>
<xsl:element name="swbRecipient" namespace="{namespace-uri()}">
<xsl:attribute name="id"><xsl:value-of select="$id"/></xsl:attribute>
<xsl:element name="partyReference" namespace="{namespace-uri()}">
<xsl:attribute name="href"><xsl:value-of select="$href"/></xsl:attribute>
</xsl:element>
</xsl:element>
</xsl:template>
<xsl:template match="*[local-name() = 'swStructuredTradeDetails']">
<xsl:element name="swbHeader" namespace="{namespace-uri()}">
<xsl:element name="swbBrokerTradeId" namespace="{namespace-uri()}"><xsl:value-of select="$broker_tradeid"/></xsl:element>
<xsl:element name="swbBrokerTradeVersionId" namespace="{namespace-uri()}"><xsl:value-of select="$broker_tradeversionid"/></xsl:element>
<xsl:element name="swbTradeSource" namespace="{namespace-uri()}"><xsl:value-of select="$broker_tradesource"/></xsl:element>
<xsl:call-template name="swb_recipient">
<xsl:with-param name="id">_1</xsl:with-param>
<xsl:with-param name="href">partyA</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="swb_recipient">
<xsl:with-param name="id">_2</xsl:with-param>
<xsl:with-param name="href">partyB</xsl:with-param>
</xsl:call-template>
</xsl:element>
<xsl:element name="swbStructuredTradeDetails" namespace="{namespace-uri()}">
<xsl:apply-templates select="@*|node()"/>
</xsl:element>
</xsl:template>
<xsl:template match="*[local-name() = 'swProductType']">
<xsl:element name="swbProductType" namespace="{namespace-uri()}">
<xsl:apply-templates select="@*|node()"/>
</xsl:element>
</xsl:template>
<xsl:template match="*[local-name() = 'swAllocations']">
<xsl:element name="swbAllocations" namespace="{namespace-uri()}">
<xsl:apply-templates select="@*|node()"/>
</xsl:element>
</xsl:template>
<xsl:template match="*[local-name() = 'swAllocation']">
<xsl:element name="swbAllocation" namespace="{namespace-uri()}">
<xsl:apply-templates select="@*|node()"/>
</xsl:element>
</xsl:template>
<xsl:template match="*[local-name() = 'swStreamReference']">
<xsl:element name="swbStreamReference" namespace="{namespace-uri()}">
<xsl:apply-templates select="@*|node()"/>
</xsl:element>
</xsl:template>
<xsl:template match="*[local-name() = 'swaption']">
<xsl:element name="swaption" namespace="{namespace-uri()}">
<xsl:apply-templates select="@*|node()"/>
</xsl:element>
<xsl:call-template name="other_party_payment">
<xsl:with-param name="href">partyA</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="other_party_payment">
<xsl:with-param name="href">partyB</xsl:with-param>
</xsl:call-template>
</xsl:template>
<xsl:template match="*[local-name() = 'swap' or local-name() = 'capFloor' or local-name() = 'fra']">
<xsl:choose>
<xsl:when test="(//*[local-name() = 'swap'])">
<xsl:element name="swap" namespace="{namespace-uri()}">
<xsl:apply-templates select="@*|node()"/>
</xsl:element>
</xsl:when>
<xsl:when test="(//*[local-name() = 'capFloor'])">
<xsl:element name="capFloor" namespace="{namespace-uri()}">
<xsl:apply-templates select="@*|node()"/>
</xsl:element>
</xsl:when>
<xsl:when test="(//*[local-name() = 'fra'])">
<xsl:element name="fra" namespace="{namespace-uri()}">
<xsl:apply-templates select="@*|node()"/>
</xsl:element>
</xsl:when>
</xsl:choose>
<xsl:if test="(//*[local-name() = 'swProductType'] != 'Swaption')">
<xsl:call-template name="other_party_payment">
<xsl:with-param name="href">partyA</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="other_party_payment">
<xsl:with-param name="href">partyB</xsl:with-param>
</xsl:call-template>
</xsl:if>
</xsl:template>
<xsl:template match="*[local-name() = 'swVolatilitySwapTransactionSupplement']">
<xsl:element name="swVolatilitySwapTransactionSupplement" namespace="{namespace-uri()}">
<xsl:apply-templates select="@*|node()"/>
</xsl:element>
<xsl:call-template name="other_party_payment">
<xsl:with-param name="href">partyA</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="other_party_payment">
<xsl:with-param name="href">partyB</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="brokerPartyReference">
</xsl:call-template>
</xsl:template>
<xsl:template match="*[local-name() = 'equitySwapTransactionSupplement' or
local-name() = 'equityOptionTransactionSupplement']">
<xsl:choose>
<xsl:when test="(//*[local-name() = 'swProductType'] = 'Equity Share Swap') or (//*[local-name() = 'swProductType'] = 'Equity Index Swap')">
<xsl:element name="equitySwapTransactionSupplement" namespace="{namespace-uri()}">
<xsl:apply-templates select="@*|node()"/>
</xsl:element>
</xsl:when>
<xsl:when test="(//*[local-name() = 'swProductType'] = 'Equity Share Option') or (//*[local-name() = 'swProductType'] = 'Equity Index Option')">
<xsl:element name="equityOptionTransactionSupplement" namespace="{namespace-uri()}">
<xsl:apply-templates select="@*|node()"/>
</xsl:element>
</xsl:when>
</xsl:choose>
<xsl:call-template name="other_party_payment">
<xsl:with-param name="href">partyA</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="other_party_payment">
<xsl:with-param name="href">partyB</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="brokerPartyReference">
</xsl:call-template>
</xsl:template>
<xsl:template name="other_party_payment">
<xsl:param name="href"/>
<xsl:element name="otherPartyPayment" namespace="{namespace-uri()}">
<xsl:element name="payerPartyReference" namespace="{namespace-uri()}">
<xsl:attribute name="href"><xsl:value-of select="$href"/></xsl:attribute>
</xsl:element>
<xsl:element name="receiverPartyReference" namespace="{namespace-uri()}">
<xsl:attribute name="href">broker</xsl:attribute>
</xsl:element>
<xsl:element name="paymentAmount" namespace="{namespace-uri()}">
<xsl:element name="currency" namespace="{namespace-uri()}">USD</xsl:element>
<xsl:element name="amount" namespace="{namespace-uri()}">10000</xsl:element>
</xsl:element>
</xsl:element>
</xsl:template>
<xsl:template name="brokerPartyReference">
<xsl:element name="brokerPartyReference" namespace="{namespace-uri()}">
<xsl:attribute name="href">broker</xsl:attribute>
</xsl:element>
</xsl:template>
<xsl:template match="*[local-name() = 'documentation']">
<xsl:copy>
<xsl:choose>
<xsl:when test="(//*[local-name() = 'swProductType'] = 'Equity Index Volatility Swap')">
<xsl:choose>
<xsl:when test="//*[local-name() = 'masterAgreement']">
<xsl:copy-of select="//fpml:masterAgreement"/>
<xsl:copy-of select="//fpml:contractualDefinitions"/>
<xsl:copy-of select="//fpml:contractualMatrix"/>
</xsl:when>
<xsl:otherwise>
<xsl:element name="brokerConfirmation" namespace="{namespace-uri()}">
<xsl:element name="brokerConfirmationType" namespace="{namespace-uri()}">
<xsl:attribute name="brokerConfirmationTypeScheme">http://www.swapswire.com/spec/2004/broker-confirmation-type-1-0</xsl:attribute>
<xsl:value-of select="//fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType"/>
</xsl:element>
</xsl:element>
<xsl:if test="//*[local-name() = 'contractualDefinitions']">
<xsl:element name="contractualDefinitions" namespace="{namespace-uri()}">
<xsl:attribute name="contractualDefinitionsScheme">http://www.fpml.org/coding-scheme/contractual-definitions</xsl:attribute>
<xsl:value-of select="//fpml:FpML/fpml:trade/fpml:documentation/fpml:contractualDefinitions"/>
</xsl:element>
</xsl:if>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="(//*[local-name() = 'swProductType'] = 'Equity Share Volatility Swap')">
<xsl:element name="brokerConfirmation" namespace="{namespace-uri()}">
<xsl:element name="brokerConfirmationType" namespace="{namespace-uri()}">
<xsl:attribute name="brokerConfirmationTypeScheme">http://www.swapswire.com/spec/2004/broker-confirmation-type-1-0</xsl:attribute>
<xsl:value-of select="//fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType"/>
</xsl:element>
</xsl:element>
</xsl:when>
<xsl:when test="//*[local-name() = 'swProductType'] = 'CDS Master'">
<xsl:element name="brokerConfirmation" namespace="{namespace-uri()}">
<xsl:element name="brokerConfirmationType" namespace="{namespace-uri()}">
<xsl:attribute name="brokerConfirmationTypeScheme">http://www.swapswire.com/spec/2004/broker-confirmation-type-1-0</xsl:attribute>EuropeanCorporate</xsl:element>
</xsl:element>
</xsl:when>
<xsl:when test="(//*[local-name() = 'swProductType'] = 'Equity Share Swap') or (//*[local-name() = 'swProductType'] = 'Equity Index Swap')">
<xsl:element name="brokerConfirmation" namespace="{namespace-uri()}">
<xsl:element name="brokerConfirmationType" namespace="{namespace-uri()}">
<xsl:attribute name="brokerConfirmationTypeScheme">http://www.swapswire.com/spec/2004/broker-confirmation-type-1-0</xsl:attribute>
<xsl:value-of select="//fpml:FpML/fpml:trade/fpml:documentation/fpml:masterConfirmation/fpml:masterConfirmationType"/>
</xsl:element>
</xsl:element>
</xsl:when>
<xsl:when test="(//*[local-name() = 'swProductType'] = 'SingleCurrencyInterestRateSwap') or (//*[local-name() = 'swProductType'] = 'Single Currency Basis Swap')">
<xsl:element name="brokerConfirmation" namespace="{namespace-uri()}">
<xsl:element name="brokerConfirmationType" namespace="{namespace-uri()}">
<xsl:attribute name="brokerConfirmationTypeScheme">http://www.swapswire.com/spec/2001/broker-confirmation-type-1-0</xsl:attribute>ISDA</xsl:element>
</xsl:element>
</xsl:when>
<xsl:otherwise>
<xsl:apply-templates select="@*|node()"/>
</xsl:otherwise>
</xsl:choose>
</xsl:copy>
</xsl:template>
<xsl:template match="@xsi:schemaLocation">
<xsl:attribute name="xsi:schemaLocation">
<xsl:value-of select="concat(substring-before(., 'swdml'), 'swbml', substring-after(., 'swdml'))"/>
</xsl:attribute>
</xsl:template>
<xsl:template match="*[local-name() = 'SWDML']">
<xsl:element name="SWBML" namespace="{namespace-uri()}">
<xsl:apply-templates select="@*|node()"/>
</xsl:element>
</xsl:template>
<xsl:template match="*[local-name() = 'swExtendedTradeDetails']">
<xsl:element name="swbExtendedTradeDetails" namespace="{namespace-uri()}">
<xsl:element name="swbProductTerm" namespace="{namespace-uri()}">
<xsl:element name="periodMultiplier" namespace="{namespace-uri()}">
<xsl:value-of select="$product_term_period_multiplier"/>
</xsl:element>
<xsl:element name="period" namespace="{namespace-uri()}">
<xsl:value-of select="$product_term_period"/>
</xsl:element>
</xsl:element>
<xsl:if test="(//*[local-name() = 'swProductType'] = 'Equity Share Volatility Swap') or (//*[local-name() = 'swProductType'] = 'Equity Index Volatility Swap')">
<xsl:element name="swbVolatilitySwapDetails" namespace="{namespace-uri()}">
<xsl:call-template name="swVolatilitySwapDetails"/>
</xsl:element>
</xsl:if>
<xsl:if test="(//*[local-name() = 'swProductType'] = 'Equity Share Swap') or (//*[local-name() = 'swProductType'] = 'Equity Index Swap')">
<xsl:if test="//*[local-name() = 'swDeltaCross']">
<xsl:element name="swbDeltaCross" namespace="{namespace-uri()}">
<xsl:call-template name="swDeltaCross"/>
</xsl:element>
</xsl:if>
<xsl:if test="*[local-name() = 'swEquitySwapDetails']">
<xsl:element name="swbEquitySwapDetails" namespace="{namespace-uri()}">
<xsl:call-template name="swEquitySwapDetails"/>
</xsl:element>
</xsl:if>
</xsl:if>
</xsl:element>
</xsl:template>
<xsl:template name="swDeltaCross">
<xsl:copy-of select="//fpml:buyerPartyReference"/>
<xsl:copy-of select="//fpml:sellerPartyReference"/>
<xsl:if test="//*[local-name() = 'equity']">
<xsl:copy-of select="//fpml:swDeltaCross/fpml:equity"/>
</xsl:if>
<xsl:if test="//*[local-name() = 'future']">
<xsl:copy-of select="//fpml:future"/>
</xsl:if>
<xsl:if test="//*[local-name() = 'swPrice']">
<xsl:element name="swbPrice" namespace="{namespace-uri()}">
<xsl:copy-of select="//fpml:swPrice/fpml:currency"/>
<xsl:copy-of select="//fpml:swPrice/fpml:amount"/>
</xsl:element>
</xsl:if>
<xsl:if test="//*[local-name() = 'swQuantity']">
<xsl:element name="swbQuantity" namespace="{namespace-uri()}">
<xsl:value-of select="//fpml:swQuantity"/>
</xsl:element>
</xsl:if>
<xsl:if test="//*[local-name() = 'swDelta']">
<xsl:element name="swbDelta" namespace="{namespace-uri()}">
<xsl:value-of select="//fpml:swDelta"/>
</xsl:element>
</xsl:if>
<xsl:if test="//*[local-name() = 'swOffshoreCross']">
<xsl:element name="swbOffshoreCross" namespace="{namespace-uri()}">
<xsl:element name="swbOffshoreCrossLocation" namespace="{namespace-uri()}">
<xsl:value-of select="//fpml:swOffshoreCross/swOffshoreCrossLocation"/>
</xsl:element>
</xsl:element>
</xsl:if>
<xsl:if test="//*[local-name() = 'swCrossExchangeId']">
<xsl:element name="swbCrossExchangeId" namespace="{namespace-uri()}">
<xsl:value-of select="//fpml:swCrossExchangeId"/>
</xsl:element>
</xsl:if>
</xsl:template>
<xsl:template name="swVolatilitySwapDetails">
<xsl:if test="//*[local-name() = 'swExpectedNOverride']">
<xsl:element name="swbExpectedNOverride" namespace="{namespace-uri()}">
<xsl:value-of select="//fpml:swExpectedNOverride"/>
</xsl:element>
</xsl:if>
<xsl:if test="//*[local-name() = 'swSettlementCurrencyVegaNotionalAmount']">
<xsl:element name="swbSettlementCurrencyVegaNotionalAmount" namespace="{namespace-uri()}">
<xsl:value-of select="//fpml:swSettlementCurrencyVegaNotionalAmount"/>
</xsl:element>
</xsl:if>
<xsl:if test="//*[local-name() = 'swVegaFxSpotRate']">
<xsl:element name="swbVegaFxSpotRate" namespace="{namespace-uri()}">
<xsl:value-of select="//fpml:swVegaFxSpotRate"/>
</xsl:element>
</xsl:if>
<xsl:if test="//*[local-name() = 'swVolatilitySwapHolidayDate']">
<xsl:element name="swbVolatilitySwapHolidayDate" namespace="{namespace-uri()}">
<xsl:value-of select="//fpml:swVolatilitySwapHolidayDate"/>
</xsl:element>
</xsl:if>
<xsl:if test="//*[local-name() = 'swFxDeterminationMethod']">
<xsl:element name="swbFxDeterminationMethod" namespace="{namespace-uri()}">
<xsl:value-of select="//fpml:swFxDeterminationMethod"/>
</xsl:element>
</xsl:if>
</xsl:template>
<xsl:template name="swEquitySwapDetails">
<xsl:if test="//*[local-name() = 'swFullyFunded']">
<xsl:element name="swbFullyFunded" namespace="{namespace-uri()}">
<xsl:copy-of select="//fpml:swFullyFunded/fpml:currency"/>
<xsl:copy-of select="//fpml:swFullyFunded/fpml:amount"/>
<xsl:copy-of select="//fpml:swFullyFunded/fpml:fixedRate"/>
<xsl:copy-of select="//fpml:swFullyFunded/fpml:dayCountFraction"/>
</xsl:element>
</xsl:if>
<xsl:if test="//*[local-name() = 'swSpreadDetails']">
<xsl:element name="swbSpreadDetails" namespace="{namespace-uri()}">
<xsl:element name="swbSpreadIn" namespace="{namespace-uri()}">
<xsl:value-of select="//fpml:swSpreadDetails/fpml:swSpreadIn"/>
</xsl:element>
<xsl:element name="swbSpreadOut" namespace="{namespace-uri()}">
<xsl:value-of select="//fpml:swSpreadDetails/fpml:swSpreadOut"/>
</xsl:element>
</xsl:element>
</xsl:if>
<xsl:copy-of select="//fpml:initialUnits"/>
<xsl:if test="//*[local-name() = 'swMultiplier']">
<xsl:element name="swbMultiplier" namespace="{namespace-uri()}">
<xsl:value-of select="//fpml:swMultiplier"/>
</xsl:element>
</xsl:if>
<xsl:if test="//*[local-name() = 'swBulletIndicator']">
<xsl:element name="swbBulletIndicator" namespace="{namespace-uri()}">
<xsl:value-of select="//fpml:swBulletIndicator"/>
</xsl:element>
</xsl:if>
<xsl:if test="//*[local-name() = 'swInterestLegDriven']">
<xsl:element name="swbInterestLegDriven" namespace="{namespace-uri()}">
<xsl:value-of select="//fpml:swInterestLegDriven"/>
</xsl:element>
</xsl:if>
<xsl:if test="//*[local-name() = 'swSchedulingMethod']">
<xsl:element name="swbSchedulingMethod" namespace="{namespace-uri()}">
<xsl:value-of select="//fpml:swSchedulingMethod"/>
</xsl:element>
</xsl:if>
<xsl:if test="//*[local-name() = 'swScheduleFrequencies']">
<xsl:element name="swbScheduleFrequencies" namespace="{namespace-uri()}">
<xsl:copy-of select="//fpml:swValuationDate"/>
<xsl:copy-of select="//fpml:swPaymentDateOffset"/>
<xsl:copy-of select="//fpml:swInterestLegPaymentDate"/>
<xsl:copy-of select="//fpml:rollConvention"/>
</xsl:element>
</xsl:if>
<xsl:if test="//*[local-name() = 'swStubControl']">
<xsl:element name="swbStubControl" namespace="{namespace-uri()}">
<xsl:if test="//*[local-name() = 'swEquityFrontStub']">
<xsl:element name="swbEquityFrontStub" namespace="{namespace-uri()}">
<xsl:value-of select="//fpml:swStubControl/fpml:swEquityFrontStub"/>
</xsl:element>
</xsl:if>
<xsl:if test="//*[local-name() = 'swEquityEndStub']">
<xsl:element name="swbEquityEndStub" namespace="{namespace-uri()}">
<xsl:value-of select="//fpml:swStubControl/fpml:swEquityEndStub"/>
</xsl:element>
</xsl:if>
<xsl:if test="//*[local-name() = 'swInterestFrontStub']">
<xsl:element name="swbInterestFrontStub" namespace="{namespace-uri()}">
<xsl:value-of select="//fpml:swStubControl/fpml:swInterestFrontStub"/>
</xsl:element>
</xsl:if>
<xsl:if test="//*[local-name() = 'swInterestEndStub']">
<xsl:element name="swbInterestEndStub" namespace="{namespace-uri()}">
<xsl:value-of select="//fpml:swStubControl/fpml:swInterestEndStub"/>
</xsl:element>
</xsl:if>
</xsl:element>
</xsl:if>
<xsl:if test="//*[local-name() = 'swEarlyFinalValuationDateElection']">
<xsl:element name="swbEarlyFinalValuationDateElection"  namespace="{namespace-uri()}">
<xsl:value-of select="//fpml:swEarlyFinalValuationDateElection"/>
</xsl:element>
</xsl:if>
<xsl:if test="//*[local-name() = 'swEarlyTerminationElectingParty']">
<xsl:element name="swbEarlyTerminationElectingParty"  namespace="{namespace-uri()}">
<xsl:attribute name="href">partyA</xsl:attribute>
</xsl:element>
</xsl:if>
<xsl:if test="//*[local-name() = 'swEarlyTerminationElectingParty']">
<xsl:element name="swbEarlyTerminationElectingParty"  namespace="{namespace-uri()}">
<xsl:attribute name="href">partyB</xsl:attribute>
</xsl:element>
</xsl:if>
<xsl:if test="//*[local-name() = 'noticePeriod']">
<xsl:copy-of select="//fpml:noticePeriod"/>
</xsl:if>
<xsl:if test="//*[local-name() = 'swEarlyTerminationElectingPartyMethod']">
<xsl:element name="swbEarlyTerminationElectingPartyMethod"  namespace="{namespace-uri()}">
<xsl:value-of select="//fpml:swEarlyTerminationElectingPartyMethod"/>
</xsl:element>
</xsl:if>
<xsl:if test="//*[local-name() = 'swFixedRateIndicator']">
<xsl:element name="swbFixedRateIndicator"  namespace="{namespace-uri()}">
<xsl:value-of select="//fpml:swFixedRateIndicator"/>
</xsl:element>
</xsl:if>
<xsl:if test="//*[local-name() = 'swOtherValuationBusinessCenter']">
<xsl:element name="swbOtherValuationBusinessCenter"  namespace="{namespace-uri()}">
<xsl:value-of select="//fpml:swOtherValuationBusinessCenter"/>
</xsl:element>
</xsl:if>
<xsl:if test="//*[local-name() = 'swReferenceInitialPrice']">
<xsl:element name="swbReferenceInitialPrice"  namespace="{namespace-uri()}">
<xsl:value-of select="//fpml:swReferenceInitialPrice"/>
</xsl:element>
</xsl:if>
<xsl:if test="//*[local-name() = 'swReferenceFXRate']">
<xsl:element name="swbReferenceFXRate"  namespace="{namespace-uri()}">
<xsl:value-of select="//fpml:swReferenceFXRate"/>
</xsl:element>
</xsl:if>
<xsl:if test="//*[local-name() = 'swNotionalCurrency']">
<xsl:element name="swbNotionalCurrency"  namespace="{namespace-uri()}">
<xsl:value-of select="//fpml:swNotionalCurrency"/>
</xsl:element>
</xsl:if>
<xsl:if test="//*[local-name() = 'swAveragingDatesIndicator']">
<xsl:element name="swbAveragingDatesIndicator" namespace="{namespace-uri()}">
<xsl:value-of select="//fpml:swAveragingDatesIndicator"/>
</xsl:element>
</xsl:if>
<xsl:if test="//*[local-name() = 'swAveragingDates2']">
<xsl:element name="swbAveragingDates2" namespace="{namespace-uri()}">
<xsl:element name="swbAveragingFrequency" namespace="{namespace-uri()}">
<xsl:value-of select="//fpml:swAveragingDates2/fpml:swAveragingFrequency"/>
</xsl:element>
<xsl:element name="swbAveragingStart" namespace="{namespace-uri()}">
<xsl:value-of select="//fpml:swAveragingDates2/fpml:swAveragingStart"/>
</xsl:element>
<xsl:element name="swbAveragingEnd" namespace="{namespace-uri()}">
<xsl:value-of select="//fpml:swAveragingDates2/fpml:swAveragingEnd"/>
</xsl:element>
<xsl:copy-of select="//fpml:swAveragingDates2/fpml:averagingInOut"/>
<xsl:if test="//*[local-name() = 'averagingDateTimes']">
<xsl:copy-of select="//fpml:swAveragingDates2/fpml:averagingDateTimes"/>
</xsl:if>
<xsl:copy-of select="//fpml:swAveragingDates2/fpml:marketDisruption"/>
</xsl:element>
</xsl:if>
<xsl:if test="//*[local-name() = 'swADTVIndicator']">
<xsl:element name="swbADTVIndicator"  namespace="{namespace-uri()}">
<xsl:value-of select="//fpml:swADTVIndicator"/>
</xsl:element>
</xsl:if>
<xsl:if test="//*[local-name() = 'swStockLoanRate']">
<xsl:element name="swbStockLoanRate"  namespace="{namespace-uri()}">
<xsl:if test="//*[local-name() = 'maximumStockLoanRate']">
<xsl:copy-of select="//fpml:swStockLoanRate/fpml:maximumStockLoanRate"/>
</xsl:if>
<xsl:if test="//*[local-name() = 'initialStockLoanRate']">
<xsl:copy-of select="//fpml:swStockLoanRate/fpml:initialStockLoanRate"/>
</xsl:if>
</xsl:element>
</xsl:if>
<xsl:if test="//*[local-name() = 'swAdditionalDisruptionEventIndicator']">
<xsl:element name="swbAdditionalDisruptionEventIndicator"  namespace="{namespace-uri()}">
<xsl:value-of select="//fpml:swAdditionalDisruptionEventIndicator"/>
</xsl:element>
</xsl:if>
<xsl:if test="//*[local-name() = 'swFinalPriceFee']">
<xsl:element name="swbFinalPriceFee" namespace="{namespace-uri()}">
<xsl:value-of select="//fpml:swFinalPriceFee"/>
</xsl:element>
</xsl:if>
<xsl:if test="//*[local-name() = 'swFinalPriceFeeAmount']">
<xsl:element name="swbFinalPriceFeeAmount" namespace="{namespace-uri()}">
<xsl:copy-of select="//fpml:swFinalPriceFeeAmount/fpml:currency"/>
<xsl:copy-of select="//fpml:swFinalPriceFeeAmount/fpml:amount"/>
</xsl:element>
</xsl:if>
<xsl:if test="//*[local-name() = 'swBulletCompoundingSpread']">
<xsl:element name="swbBulletCompoundingSpread" namespace="{namespace-uri()}">
<xsl:value-of select="//fpml:swBulletCompoundingSpread"/>
</xsl:element>
</xsl:if>
<xsl:if test="//*[local-name() = 'swRightToIncrease']">
<xsl:element name="swbRightToIncrease" namespace="{namespace-uri()}">
<xsl:value-of select="//fpml:swRightToIncrease"/>
</xsl:element>
</xsl:if>
<xsl:if test="//*[local-name() = 'swGrossPrice']">
<xsl:element name="swbGrossPrice" namespace="{namespace-uri()}">
<xsl:value-of select="//fpml:swGrossPrice"/>
</xsl:element>
</xsl:if>
<xsl:if test="//*[local-name() = 'swApplicableRegion']">
<xsl:element name="swbApplicableRegion" namespace="{namespace-uri()}">
<xsl:value-of select="//fpml:swApplicableRegion"/>
</xsl:element>
</xsl:if>
<xsl:if test="//*[local-name() = 'swDividendPercentageComponent']">
<xsl:element name="swbDividendPercentageComponent" namespace="{namespace-uri()}">
<xsl:element name="dividendPercentageComponentShare" namespace="{namespace-uri()}">
<xsl:value-of select="//fpml:swDividendPercentageComponent/fpml:dividendPercentageComponentShare"/>
</xsl:element>
<xsl:element name="dividendPercentageComponent" namespace="{namespace-uri()}">
<xsl:value-of select="//fpml:swDividendPercentageComponent/fpml:dividendPercentageComponent"/>
</xsl:element>
</xsl:element>
</xsl:if>
</xsl:template>
<xsl:template match="*[local-name() = 'swTradeEventReportingDetails']">
<xsl:element name="swbTradeEventReportingDetails" namespace="{namespace-uri()}">
<xsl:apply-templates select="@*|node()"/>
</xsl:element>
</xsl:template>
<xsl:template match="*[local-name() = 'swReportingRegimeInformation']">
<xsl:element name="swbReportingRegimeInformation" namespace="{namespace-uri()}">
<xsl:apply-templates select="@*|node()"/>
</xsl:element>
</xsl:template>
<xsl:template match="*[local-name() = 'swJurisdiction']">
<xsl:element name="swbJurisdiction" namespace="{namespace-uri()}">
<xsl:apply-templates select="@*|node()"/>
</xsl:element>
</xsl:template>
<xsl:template match="*[local-name() = 'swSupervisoryBodyCategory']">
<xsl:element name="swbSupervisoryBodyCategory" namespace="{namespace-uri()}">
<xsl:apply-templates select="@*|node()"/>
</xsl:element>
</xsl:template>
<xsl:template match="*[local-name() = 'swUniqueTransactionId']">
<xsl:element name="swbUniqueTransactionId" namespace="{namespace-uri()}">
<xsl:apply-templates select="@*|node()"/>
</xsl:element>
</xsl:template>
<xsl:template match="*[local-name() = 'swIssuer']">
<xsl:element name="swbIssuer" namespace="{namespace-uri()}">
<xsl:apply-templates select="@*|node()"/>
</xsl:element>
</xsl:template>
<xsl:template match="*[local-name() = 'swTradeId']">
<xsl:element name="swbTradeId" namespace="{namespace-uri()}">
<xsl:apply-templates select="@*|node()"/>
</xsl:element>
</xsl:template>
<xsl:template match="*[local-name() = 'swObligatoryReporting']">
<xsl:element name="swbObligatoryReporting" namespace="{namespace-uri()}">
<xsl:apply-templates select="@*|node()"/>
</xsl:element>
</xsl:template>
<xsl:template match="*[local-name() = 'swReportingCounterpartyReference']">
<xsl:element name="swbReportingCounterpartyReference" namespace="{namespace-uri()}">
<xsl:apply-templates select="@*|node()"/>
</xsl:element>
</xsl:template>
<xsl:template match="*[local-name() = 'swMandatoryClearingIndicator']">
<xsl:element name="swbMandatoryClearingIndicator" namespace="{namespace-uri()}">
<xsl:apply-templates select="@*|node()"/>
</xsl:element>
</xsl:template>
<xsl:template match="*[local-name() = 'swRelatedTradeId']">
<xsl:element name="swbRelatedTradeId" namespace="{namespace-uri()}">
<xsl:apply-templates select="@*|node()"/>
</xsl:element>
</xsl:template>
<xsl:template match="*[local-name() = 'swPrivatePartyTradeEventReportingDetails']">
<xsl:element name="swbPrivatePartyTradeEventReportingDetails" namespace="{namespace-uri()}">
<xsl:apply-templates select="@*|node()"/>
</xsl:element>
</xsl:template>
<xsl:template match="*[local-name() = 'swPartyReference']">
<xsl:element name="swbPartyReference" namespace="{namespace-uri()}">
<xsl:apply-templates select="@*|node()"/>
</xsl:element>
</xsl:template>
<xsl:template match="*[local-name() = 'swPriceFormingEvent']">
<xsl:element name="swbPriceFormingEvent" namespace="{namespace-uri()}">
<xsl:apply-templates select="@*|node()"/>
</xsl:element>
</xsl:template>
<xsl:template match="*[local-name() = 'swPartyTradeInformation']">
<xsl:element name="swbPartyTradeInformation" namespace="{namespace-uri()}">
<xsl:apply-templates select="@*|node()"/>
</xsl:element>
</xsl:template>
<xsl:template match="*[local-name() = 'swTimestamps']">
<xsl:element name="swbTimestamps" namespace="{namespace-uri()}">
<xsl:apply-templates select="@*|node()"/>
</xsl:element>
</xsl:template>
<xsl:template match="*[local-name() = 'swConfirmed']">
<xsl:element name="swbConfirmed" namespace="{namespace-uri()}">
<xsl:apply-templates select="@*|node()"/>
</xsl:element>
</xsl:template>
<xsl:template match="*[local-name() = 'swExecutionDateTime']">
<xsl:element name="swbExecutionDateTime" namespace="{namespace-uri()}">
<xsl:apply-templates select="@*|node()"/>
</xsl:element>
</xsl:template>
<xsl:template match="*[local-name() = 'swNonStandardTerms']">
<xsl:element name="swbNonStandardTerms" namespace="{namespace-uri()}">
<xsl:apply-templates select="@*|node()"/>
</xsl:element>
</xsl:template>
<xsl:template match="*[local-name() = 'swCollateralizationType']">
<xsl:element name="swbCollateralizationType" namespace="{namespace-uri()}">
<xsl:apply-templates select="@*|node()"/>
</xsl:element>
</xsl:template>
<xsl:template match="*[local-name() = 'swExecutionVenueType']">
<xsl:element name="swbExecutionVenueType" namespace="{namespace-uri()}">
<xsl:apply-templates select="@*|node()"/>
</xsl:element>
</xsl:template>
<xsl:template match="*[local-name() = 'swVerificationMethod']">
<xsl:element name="swbVerificationMethod" namespace="{namespace-uri()}">
<xsl:apply-templates select="@*|node()"/>
</xsl:element>
</xsl:template>
<xsl:template match="*[local-name() = 'swConfirmationMethod']">
<xsl:element name="swbConfirmationMethod" namespace="{namespace-uri()}">
<xsl:apply-templates select="@*|node()"/>
</xsl:element>
</xsl:template>
<xsl:template match="*[local-name() = 'swPartyReportingRegimeInformation']">
<xsl:element name="swbPartyReportingRegimeInformation" namespace="{namespace-uri()}">
<xsl:apply-templates select="@*|node()"/>
</xsl:element>
</xsl:template>
<xsl:template match="*[local-name() = 'swEventId']">
<xsl:element name="swbEventId" namespace="{namespace-uri()}">
<xsl:apply-templates select="@*|node()"/>
</xsl:element>
</xsl:template>
<xsl:template match="*[local-name() = 'swBulkProcessingEventId']">
<xsl:element name="swbBulkProcessingEventId" namespace="{namespace-uri()}">
<xsl:apply-templates select="@*|node()"/>
</xsl:element>
</xsl:template>
<xsl:template match="*[local-name() = 'swEndUserException']">
<xsl:element name="swbEndUserException" namespace="{namespace-uri()}">
<xsl:apply-templates select="@*|node()"/>
</xsl:element>
</xsl:template>
<xsl:template match="*[local-name() = 'swReportingSpecification']">
<xsl:element name="swbReportingSpecification" namespace="{namespace-uri()}">
<xsl:apply-templates select="@*|node()"/>
</xsl:element>
</xsl:template>
<xsl:template match="*[local-name() = 'swReportingPurpose']">
<xsl:element name="swbReportingPurpose" namespace="{namespace-uri()}">
<xsl:apply-templates select="@*|node()"/>
</xsl:element>
</xsl:template>
<xsl:template match="*[local-name() = 'swReportingInstruction']">
<xsl:element name="swbReportingInstruction" namespace="{namespace-uri()}">
<xsl:apply-templates select="@*|node()"/>
</xsl:element>
</xsl:template>
<xsl:template match="*[local-name() = 'swClearingNotRequired']">
<xsl:element name="swbClearingNotRequired" namespace="{namespace-uri()}">
<xsl:apply-templates select="@*|node()"/>
</xsl:element>
</xsl:template>
<xsl:template match="*[local-name() = 'swStandardSettlementInstructions']">
<xsl:element name="swbStandardSettlementInstructions" namespace="{namespace-uri()}">
<xsl:apply-templates select="@*|node()"/>
</xsl:element>
</xsl:template>
<xsl:template match="*[local-name() = 'swAutoSendForClearing']">
<xsl:element name="swbAutoSendForClearing" namespace="{namespace-uri()}">
<xsl:apply-templates select="@*|node()"/>
</xsl:element>
</xsl:template>
<xsl:template match="*[local-name() = 'swMandatoryClearing']">
<xsl:element name="swbMandatoryClearing" namespace="{namespace-uri()}">
<xsl:apply-templates select="@*|node()"/>
</xsl:element>
</xsl:template>
<xsl:template match="*[local-name() = 'swMandatoryClearingIndicator']">
<xsl:element name="swbMandatoryClearingIndicator" namespace="{namespace-uri()}">
<xsl:apply-templates select="@*|node()"/>
</xsl:element>
</xsl:template>
<xsl:template match="*[local-name() = 'swClientClearing']">
<xsl:element name="swbClientClearing" namespace="{namespace-uri()}">
<xsl:apply-templates select="@*|node()"/>
</xsl:element>
</xsl:template>
<xsl:template match="*[local-name() = 'swClearingHouse']">
<xsl:element name="swbClearingHouse" namespace="{namespace-uri()}">
<xsl:apply-templates select="@*|node()"/>
</xsl:element>
</xsl:template>
<xsl:template match="*[local-name() = 'swExecutingBroker']">
<xsl:element name="swbExecutingBroker" namespace="{namespace-uri()}">
<xsl:apply-templates select="@*|node()"/>
</xsl:element>
</xsl:template>
<xsl:template match="*[local-name() = 'swClearingClient']">
<xsl:element name="swbClearingClient" namespace="{namespace-uri()}">
<xsl:apply-templates select="@*|node()"/>
</xsl:element>
</xsl:template>
</xsl:stylesheet>
