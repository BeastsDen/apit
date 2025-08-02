<?xml version="1.0"?>
<xsl:stylesheet xmlns="http://www.fpml.org/2010/FpML-4-9"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"
xmlns:fpml="http://www.fpml.org/2010/FpML-4-9"
xmlns:common="http://exslt.org/common"
xmlns:mtc="OTC_Matching_11-0"
xmlns:rm="OTC_RM_11-0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
exclude-result-prefixes="xsl env fpml common mtc rm" version="1.0">
<xsl:import href="tiw_position_content_mappings.xsl"/> 
<xsl:output method="xml" indent="yes"/>
<xsl:strip-space elements="*"/>
<xsl:template match="@*|node()">
<xsl:copy>
<xsl:apply-templates select="@*|node()"/>
</xsl:copy>
</xsl:template>
<xsl:template match="*">
<xsl:element name="{local-name()}">
<xsl:apply-templates select="@*|node()"/>
</xsl:element>
</xsl:template>
<xsl:variable name="otcrm" select="/env:Envelope/env:Header/rm:OTC_RM"/>
<xsl:variable name="tradeMsg" select="$otcrm/rm:Manifest/rm:TradeMsg"/>
<xsl:variable name="matching" select="/env:Envelope/env:Body/mtc:OTC_Matching"/>
<xsl:variable name="reporting_data" select="$matching/mtc:ReportingData"/>
<xsl:variable name="reporting_header" select="$reporting_data/mtc:ReportingHeader"/>
<xsl:variable name="reporting_jurisdictions" select="$reporting_header/mtc:ReportingJurisdiction"/>
<xsl:variable name="contra_jurisdictions" select="$reporting_data/mtc:ContraReportingFields/mtc:ReportingJurisdiction"/>
<xsl:variable name="fpml" select="$matching/mtc:Inquiry/mtc:Position/fpml:FpML"/>
<xsl:variable name="as_of_date" select="$matching/mtc:WarehouseState/mtc:WarehouseCurrentStateNotional/mtc:asOfDate"/>
<xsl:variable name="current_state_notional_amount" select="$matching/mtc:WarehouseState/mtc:WarehouseCurrentStateNotional/mtc:amount"/>
<xsl:variable name="current_state_notional_currency" select="$matching/mtc:WarehouseState/mtc:WarehouseCurrentStateNotional/mtc:currency"/>
<xsl:variable name="value_date" select="$otcrm/rm:Delivery/rm:RouteHist/rm:Route[rm:RouteAddress='www.dtcc.net']/rm:ReleaseTime"/>
<xsl:variable name="entity_id" select="$fpml/fpml:trade//fpml:generalTerms/fpml:referenceInformation/fpml:referenceEntity/fpml:entityId"/>
<xsl:variable name="usi" select="$tradeMsg/rm:USI"/>
<xsl:variable name="seller_party_ref" select="$fpml/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:sellerPartyReference/@href"/>
<xsl:variable name="buyer_party_ref" select="$fpml/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:buyerPartyReference/@href"/>
<xsl:variable name="product_type">
<xsl:call-template name="getProductTypeFromTiwPos">
<xsl:with-param name="dsm_product_type" select="$tradeMsg/rm:ProductType"/>
<xsl:with-param name="documentation" select="$fpml/fpml:trade/fpml:documentation"/>
<xsl:with-param name="sector" select="$fpml/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:referenceInformation/fpml:referenceObligation/fpml:mortgage/fpml:sector"/>
<xsl:with-param name="category" select="$fpml/fpml:trade/fpml:creditDefaultSwap/fpml:protectionTerms/fpml:obligations/fpml:category"/>
<xsl:with-param name="contractual_terms_supplement_type" select="$fpml/fpml:trade/fpml:documentation/fpml:contractualTermsSupplement/fpml:type"/>
<xsl:with-param name="credit_default_swap_option" select="$fpml/fpml:trade/fpml:creditDefaultSwapOption"/>
</xsl:call-template>
</xsl:variable>
<xsl:variable name="sub_product_type">
<xsl:call-template name="getSubProductTypeFromTiwPos">
<xsl:with-param name="mw_product_type" select="$product_type"/>
<xsl:with-param name="documentation" select="$fpml/fpml:trade/fpml:documentation"/>
<xsl:with-param name="sector" select="$fpml/fpml:trade/fpml:creditDefaultSwap/fpml:generalTerms/fpml:referenceInformation/fpml:referenceObligation/fpml:mortgage/fpml:sector"/>
<xsl:with-param name="category" select="$fpml/fpml:trade/fpml:creditDefaultSwap/fpml:protectionTerms/fpml:obligations/fpml:category"/>
<xsl:with-param name="contractual_terms_supplement_type" select="$fpml/fpml:trade/fpml:documentation/fpml:contractualTermsSupplement/fpml:type"/>
<xsl:with-param name="contractual_supplement" select="$fpml/fpml:trade/fpml:documentation/fpml:contractualSupplement"/>
<xsl:with-param name="cash_settlement_terms" select="$fpml/fpml:trade/fpml:creditDefaultSwap/fpml:cashSettlementTerms"/>
</xsl:call-template>
</xsl:variable>
<xsl:template name="mapBodyJurisdiction">
<xsl:param name="supervisoryBody"/>
<xsl:choose>
<xsl:when test="$supervisoryBody='CFTC'">DoddFrank</xsl:when>
<xsl:when test="$supervisoryBody='CANADA'">CAN</xsl:when>
<xsl:otherwise><xsl:value-of select="mtc:SupervisoryBody"/></xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template match="env:Envelope">
<SWDML xmlns="http://www.fpml.org/2010/FpML-4-9" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="4-9" xsi:schemaLocation="http://www.fpml.org/2010/FpML-4-9 swdml-cd-main-4-9.xsd">
<swLongFormTrade>
<swOriginatorPartyReference href="partyA"/>
<swStructuredTradeDetails>
<swProductType><xsl:value-of select="$product_type"/></swProductType>
<xsl:if test="$sub_product_type != ''">
<swProductSubType><xsl:value-of select="$sub_product_type"/></swProductSubType>
</xsl:if>
<xsl:apply-templates select="$fpml"/>
<swExtendedTradeDetails>
<swTradeHeader>
<swManualConfirmationRequired>true</swManualConfirmationRequired>
<swClearingNotRequired>false</swClearingNotRequired>
<swStandardSettlementInstructions>true</swStandardSettlementInstructions>
<swReferenceInformationSource>RED Index</swReferenceInformationSource>
<xsl:variable name="exempt_party_id" select="$reporting_header/mtc:RelatedParty[@id='ClearingException']/mtc:RelatedPartyId[@partySchemeId='DTCC']"/>
<xsl:variable name="exempt_party" select="$fpml/fpml:party[partyId=$exempt_party_id]"/>
<xsl:variable name="affiliate_exempt" select="$reporting_data/mtc:ReportingFields/mtc:ClearingAffiliateExemption"/>
<xsl:for-each select="$reporting_jurisdictions">
<xsl:if test="mtc:MandatoryClearable | $exempt_party">
<swMandatoryClearing>
<swJurisdiction>
<xsl:call-template name="mapBodyJurisdiction">
<xsl:with-param name="supervisoryBody" select="mtc:SupervisoryBody/text()"/>
</xsl:call-template>
</swJurisdiction>
<xsl:if test="mtc:MandatoryClearable">
<swMandatoryClearingIndicator>
<xsl:value-of select="mtc:MandatoryClearable"/>
</swMandatoryClearingIndicator>
</xsl:if>
<xsl:if test="$exempt_party">
<swPartyExemption>
<swPartyReference>
<xsl:attribute name="href">
<xsl:value-of select="$exempt_party/@id"/>
</xsl:attribute>
</swPartyReference>
<swExemption>true</swExemption>
</swPartyExemption>
</xsl:if>
<xsl:if test="$affiliate_exempt">
<swInterAffiliateExemption>
<xsl:value-of select="$affiliate_exempt"/>
</swInterAffiliateExemption>
</xsl:if>
</swMandatoryClearing>
</xsl:if>
</xsl:for-each>
</swTradeHeader>
<swTiwPosition><xsl:value-of select="true()"/></swTiwPosition>
<swAsOfDate><xsl:value-of select="$as_of_date"/></swAsOfDate>
<swValueDate><xsl:value-of select="substring($value_date,1,19)"/></swValueDate>
</swExtendedTradeDetails>
<xsl:apply-templates select="$matching/mtc:WorkflowData/mtc:PartyWorkflowFields"/>
</swStructuredTradeDetails>
</swLongFormTrade>
<xsl:if test="$reporting_data">
<swTradeEventReportingDetails>
<xsl:apply-templates select="$reporting_data/mtc:ReportingFields"/>
<xsl:apply-templates select="$reporting_jurisdictions"/>
</swTradeEventReportingDetails>
</xsl:if>
</SWDML>
</xsl:template>
<xsl:template match="mtc:ReportingFields">
<xsl:if test="mtc:AdditionalPriceNotation">
<swAdditionalPriceNotation>
<xsl:if test="mtc:AdditionalPriceNotationType">
<swUnit>
<xsl:value-of select="mtc:AdditionalPriceNotationType"/>
</swUnit>
</xsl:if>
<swAmount>
<xsl:value-of select="mtc:AdditionalPriceNotation"/>
</swAmount>
</swAdditionalPriceNotation>
</xsl:if>
</xsl:template>
<xsl:template match="mtc:ReportableLocation">
<swReportableLocation><xsl:value-of select="text()"/></swReportableLocation>
</xsl:template>
<xsl:template match="mtc:ReportingJurisdiction">
<swReportingRegimeInformation>
<xsl:variable name="supervisoryBody" select="mtc:SupervisoryBody/text()"/>
<xsl:variable name="contra" select="$contra_jurisdictions[mtc:SupervisoryBody=$supervisoryBody]"/>
<swJurisdiction>
<xsl:call-template name="mapBodyJurisdiction">
<xsl:with-param name="supervisoryBody" select="$supervisoryBody"/>
</xsl:call-template>
</swJurisdiction>
<xsl:if test="mtc:ReportableLocation">
<swReportableLocations>
<xsl:variable name="ref" select="$tradeMsg/rm:YourTradeId/rm:partyTradeIdentifier/fpml:partyReference/@href"/>
<swPartyReference>
<xsl:attribute name="href"><xsl:value-of select="$ref"/></xsl:attribute>
</swPartyReference>
<xsl:apply-templates select="mtc:ReportableLocation"/>
</swReportableLocations>
</xsl:if>
<xsl:if test="$contra/mtc:ReportableLocation">
<swReportableLocations>
<xsl:variable name="ref" select="$tradeMsg/rm:ContraTradeId/rm:partyTradeIdentifier/fpml:partyReference/@href"/>
<swPartyReference>
<xsl:attribute name="href"><xsl:value-of select="$ref"/></xsl:attribute>
</swPartyReference>
<xsl:apply-templates select="$contra/mtc:ReportableLocation"/>
</swReportableLocations>
</xsl:if>
<xsl:if test="$usi">
<swUniqueTransactionId>
<swIssuer>
<xsl:value-of select="$usi/rm:USIIssuer"/>
</swIssuer>
<swTradeId>
<xsl:value-of select="$usi/rm:USITradeId"/>
</swTradeId>
</swUniqueTransactionId>
</xsl:if>
<xsl:if test="$supervisoryBody='CFTC' or $supervisoryBody='CANADA'">
<swObligatoryReporting>true</swObligatoryReporting>
<xsl:if test="mtc:ReportingCounterParty">
<swReportingCounterpartyReference>
<xsl:attribute name="href">
<xsl:value-of select="$fpml/fpml:party[partyId=mtc:ReportingCounterParty]/@id"/>
</xsl:attribute>
</swReportingCounterpartyReference>
</xsl:if>
</xsl:if>
<xsl:if test="mtc:MandatoryClearable">
<swMandatoryClearingIndicator>
<xsl:value-of select="mtc:MandatoryClearable"/>
</swMandatoryClearingIndicator>
</xsl:if>
</swReportingRegimeInformation>
</xsl:template>
<xsl:template match="mtc:Inquiry/mtc:Position/fpml:FpML">
<FpML version="4-9" xsi:schemaLocation="http://www.fpml.org/2010/FpML-4-9  fpml-main-4-9.xsd" xsi:type="DataDocument">
<xsl:apply-templates/>
</FpML>
</xsl:template>
<xsl:template match="fpml:header"/>
<xsl:template match="fpml:followUpConfirmation">
<followUpConfirmation>true</followUpConfirmation>
</xsl:template>
<xsl:template match="fpml:settlementType">
<settlementType>Physical</settlementType>
</xsl:template>
<xsl:template match="fpml:attachmentPoint">
<attachmentPoint><xsl:value-of select='./text() div 100'/></attachmentPoint>
</xsl:template>
<xsl:template match="fpml:exhaustionPoint">
<exhaustionPoint><xsl:value-of select='./text() div 100'/></exhaustionPoint>
</xsl:template>
<xsl:template match="fpml:strike/fpml:spread">
<spread><xsl:value-of select='./text()'/></spread>
</xsl:template>
<xsl:template match="fpml:strike/fpml:price">
<price><xsl:value-of select="./text() * 100"/></price>
</xsl:template>
<xsl:template match='fpml:entityId'>
<entityId entityIdScheme="http://www.fpml.org/spec/2003/entity-id-RED">
<xsl:value-of select="substring(text(),1,6)"/>
</entityId>
</xsl:template>
<xsl:template match='fpml:referenceObligation/fpml:bond'>
<bond>
<xsl:apply-templates/>
<xsl:if test="string-length($entity_id) = 9">
<instrumentId instrumentIdScheme="http://www.fpml.org/spec/2003/instrument-id-RED-pair-1-0">
<xsl:value-of select="$entity_id"/>
</instrumentId>
</xsl:if>
</bond>
</xsl:template>
<xsl:template match='fpml:instrumentId[@instrumentIdScheme="http://www.fpml.org/spec/2002/instrument-id-ISIN"]'>
<instrumentId instrumentIdScheme="http://www.fpml.org/spec/2002/instrument-id-ISIN-1-0">
<xsl:value-of select="text()"/>
</instrumentId>
</xsl:template>
<xsl:template match="fpml:contractualMatrix/fpml:matrixType">
<matrixType matrixTypeScheme="http://www.fpml.org/coding-scheme/matrix-type">
<xsl:choose>
<xsl:when test="text() = 'StandardTermsSupplement'">STS</xsl:when>
<xsl:otherwise><xsl:apply-templates/></xsl:otherwise>
</xsl:choose>
</matrixType>
</xsl:template>
<xsl:template match="fpml:masterConfirmationType">
<masterConfirmationType>
<xsl:call-template name="getDocsTypeFromTiwPos">
<xsl:with-param name="mw_product_type" select="$product_type"/>
<xsl:with-param name="dsm_mdtt" select="text()"/>
</xsl:call-template>
</masterConfirmationType>
</xsl:template>
<xsl:template match='fpml:contractualMatrix/fpml:matrixTerm[@matrixTermScheme="http://www.fpml.org/coding-scheme/credit-matrix-transaction-type"]'>
<matrixTerm matrixTermScheme="http://www.fpml.org/coding-scheme/credit-matrix-transaction-type">
<xsl:call-template name="getDocsTypeFromTiwPos">
<xsl:with-param name="mw_product_type" select="$product_type"/>
<xsl:with-param name="dsm_mdtt" select="text()"/>
</xsl:call-template>
</matrixTerm>
</xsl:template>
<xsl:template match='fpml:contractualTermsSupplement/fpml:type[@contractualSupplementScheme="http://www.fpml.org/coding-scheme/contractual-supplement"]'>
<type contractualSupplementScheme="http://www.fpml.org/coding-scheme/contractual-supplement">
<xsl:call-template name="getDocsTypeFromTiwPos">
<xsl:with-param name="mw_product_type" select="$product_type"/>
<xsl:with-param name="dsm_mdtt" select="text()"/>
</xsl:call-template>
</type>
</xsl:template>
<xsl:template match='fpml:contractualTermsSupplement/fpml:type[@contractualSupplementScheme="http://www.fpml.org/ext/swaption-supplement"]'>
<type contractualSupplementScheme="http://www.fpml.org/ext/swaption-supplement">
<xsl:call-template name="getDocsTypeFromTiwPos">
<xsl:with-param name="mw_product_type" select="$product_type"/>
<xsl:with-param name="dsm_mdtt" select="text()"/>
</xsl:call-template>
</type>
</xsl:template>
<xsl:template match="fpml:calculationAgentParty">
<xsl:if test='text() != "As Specified in STS"'>
<calculationAgentParty><xsl:apply-templates/></calculationAgentParty>
</xsl:if>
</xsl:template>
<xsl:template match="fpml:calculationAmount/fpml:amount">
<amount><xsl:value-of select="$current_state_notional_amount"/></amount>
</xsl:template>
<xsl:template match="fpml:calculationAmount/fpml:currency">
<currency><xsl:value-of select="$current_state_notional_currency"/></currency>
</xsl:template>
<xsl:template match="fpml:feeLeg">
<feeLeg>
<xsl:if test="fpml:singlePayment">
<initialPayment>
<payerPartyReference>
<xsl:attribute name="href"><xsl:value-of select="$buyer_party_ref"/></xsl:attribute>
</payerPartyReference>
<receiverPartyReference>
<xsl:attribute name="href"><xsl:value-of select="$seller_party_ref"/></xsl:attribute>
</receiverPartyReference>
<adjustablePaymentDate><xsl:value-of select="fpml:singlePayment/fpml:adjustablePaymentDate"/></adjustablePaymentDate>
<paymentAmount>
<currency><xsl:value-of select="fpml:singlePayment/fpml:fixedAmount/fpml:currency"/></currency>
<amount><xsl:value-of select="fpml:singlePayment/fpml:fixedAmount/fpml:amount"/></amount>
</paymentAmount>
</initialPayment>
</xsl:if>
<xsl:apply-templates/>
</feeLeg>
</xsl:template>
<xsl:template match="mtc:WorkflowData/mtc:PartyWorkflowFields">
<swBusinessConductDetails>
<swMidMarketPrice>
<swUnit>
<xsl:value-of select="mtc:midMarketPrice/mtc:midMarketPriceType"/>
</swUnit>
<swAmount>
<xsl:value-of select="mtc:midMarketPrice/mtc:amount"/>
</swAmount>
</swMidMarketPrice>
</swBusinessConductDetails>
</xsl:template>
</xsl:stylesheet>
