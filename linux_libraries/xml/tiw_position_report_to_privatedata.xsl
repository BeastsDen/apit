<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns:cmn="http://exslt.org/common"
xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"
xmlns:fpml="http://www.fpml.org/2010/FpML-4-9"
xmlns:mtc="OTC_Matching_11-0"
xmlns:rm="OTC_RM_11-0"
xmlns:lcl="tiw_position_report_to_privatedata"
exclude-result-prefixes="xsl xsi cmn env fpml mtc rm lcl">
<xsl:output method="xml" indent="yes"/>
<xsl:strip-space elements="*"/>
<xsl:param name="party"/>
<xsl:variable name="matching" select="/env:Envelope/env:Body/mtc:OTC_Matching"/>
<xsl:variable name="otcrm" select="/env:Envelope/env:Header/rm:OTC_RM"/>
<xsl:variable name="tradeMsg" select="$otcrm/rm:Manifest/rm:TradeMsg"/>
<xsl:variable name="pti" select="$tradeMsg/rm:YourTradeId/rm:partyTradeIdentifier"/>
<xsl:variable name="cpti" select="$tradeMsg/rm:ContraTradeId/rm:partyTradeIdentifier"/>
<xsl:template match="mtc:ReportingJurisdiction">
<xsl:variable name="supervisoryBody" select="mtc:SupervisoryBody/text()"/>
<xsl:variable name="blockName">
<xsl:choose>
<xsl:when test="$supervisoryBody='CFTC'">swDFReporting</xsl:when>
<xsl:when test="$supervisoryBody='JFSA'">swJFSAReporting</xsl:when>
<xsl:when test="$supervisoryBody='ESMA'">swESMAReporting</xsl:when>
<xsl:when test="$supervisoryBody='HKMA'">swHKMAReporting</xsl:when>
<xsl:when test="$supervisoryBody='MAS'">swMASReporting</xsl:when>
<xsl:when test="$supervisoryBody='ASIC'">swASICReporting</xsl:when>
<xsl:when test="$supervisoryBody='CANADA'">swCANReporting</xsl:when>
<xsl:otherwise>ERROR_UnexpectedReportRegime</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:element name="{$blockName}">
<xsl:if test="$supervisoryBody != 'CFTC' and $supervisoryBody != 'CANADA'">
<swObligatoryReporting>true</swObligatoryReporting>
</xsl:if>
<xsl:if test="$supervisoryBody = 'CFTC' or $supervisoryBody = 'JFSA'">
<xsl:variable name="MandatoryClearable" select="mtc:MandatoryClearable"/>
<xsl:if test="$MandatoryClearable">
<swEndUserException>
<xsl:value-of select="$MandatoryClearable"/>
</swEndUserException>
</xsl:if>
</xsl:if>
<xsl:if test="$supervisoryBody = 'ESMA'">
<xsl:variable name="Intragroup" select="$matching/mtc:ReportingData/mtc:ReportingFields/mtc:Intragroup"/>
<xsl:if test="$Intragroup">
<swIntragroup>
<xsl:value-of select="$Intragroup"/>
</swIntragroup>
</xsl:if>
</xsl:if>
<xsl:if test="$supervisoryBody != 'HKMA'">
<xsl:variable name="CounterpartyNonDisclosure" select="mtc:CounterpartyNonDisclosure"/>
<xsl:if test="$CounterpartyNonDisclosure">
<swCounterpartyNonDisclosure>
<xsl:value-of select="$CounterpartyNonDisclosure"/>
</swCounterpartyNonDisclosure>
</xsl:if>
</xsl:if>
</xsl:element>
</xsl:template>
<xsl:template name="lcl:myPrivateData">
<xsl:variable name="ptid" select="$pti/fpml:tradeId[@tradeIdScheme='TradeRefNbr']"/>
<xsl:if test="$ptid">
<swPrivateTradeId>
<xsl:value-of select="$ptid"/>
</swPrivateTradeId>
</xsl:if>
<xsl:variable name="wfFields" select="$matching/mtc:WorkflowData/mtc:PartyWorkflowFields"/>
<xsl:if test="$wfFields">
<swDSMatchWorkflowFields>
<xsl:variable name="comment" select="$wfFields/mtc:comment"/>
<xsl:if test="$comment">
<swDSMatchComment>
<xsl:value-of select="$comment"/>
</swDSMatchComment>
</xsl:if>
<xsl:variable name="superId" select="$wfFields/mtc:superId"/>
<xsl:if test="$superId">
<swDSMatchSuperId>
<xsl:value-of select="$superId"/>
</swDSMatchSuperId>
</xsl:if>
<xsl:variable name="deskId" select="$wfFields/mtc:deskId"/>
<xsl:if test="$deskId">
<swDSMatchDeskId>
<xsl:value-of select="$deskId"/>
</swDSMatchDeskId>
</xsl:if>
<xsl:variable name="designatedParty" select="$wfFields/mtc:designatedParty"/>
<xsl:if test="$designatedParty">
<swDSMatchDesignatedPartyId>
<xsl:value-of select="$designatedParty"/>
</swDSMatchDesignatedPartyId>
</xsl:if>
<xsl:variable name="brokerName" select="$wfFields/mtc:brokerName"/>
<xsl:if test="$brokerName">
<swDSMatchBrokerName>
<xsl:value-of select="$brokerName"/>
</swDSMatchBrokerName>
</xsl:if>
</swDSMatchWorkflowFields>
</xsl:if>
<xsl:variable name="reportingData" select="$matching/mtc:ReportingData"/>
<xsl:variable name="reportingFields" select="$reportingData/mtc:ReportingFields"/>
<xsl:variable name="reportingHeader" select="$reportingData/mtc:ReportingHeader"/>
<xsl:if test="$reportingData">
<xsl:variable name="CompressedTrade" select="$reportingFields/mtc:CompressedTrade"/>
<xsl:if test="$CompressedTrade/text() = 'true'">
<swOriginatingEvent>PortfolioCompression</swOriginatingEvent>
</xsl:if>
<xsl:variable name="BrokerCountry" select="$reportingFields/mtc:BusinessUnit[@id='Broker']/mtc:Country"/>
<xsl:if test="$BrokerCountry">
<swBrokerLocation>
<xsl:value-of select="$BrokerCountry"/>
</swBrokerLocation>
</xsl:if>
<xsl:variable name="DeskCountry" select="$reportingFields/mtc:BusinessUnit[@id='Desk']/mtc:Country"/>
<xsl:if test="$DeskCountry">
<swDeskLocation>
<xsl:value-of select="$DeskCountry"/>
</swDeskLocation>
</xsl:if>
<xsl:variable name="TraderCountry" select="$reportingFields/mtc:BusinessUnit[@id='Trader']/mtc:Country"/>
<xsl:if test="$TraderCountry">
<swTraderLocation>
<xsl:value-of select="$TraderCountry"/>
</swTraderLocation>
</xsl:if>
<xsl:variable name="SalesCountry" select="$reportingFields/mtc:BusinessUnit[@id='Sales']/mtc:Country"/>
<xsl:if test="$SalesCountry">
<swSalesLocation>
<xsl:value-of select="$SalesCountry"/>
</swSalesLocation>
</xsl:if>
<xsl:variable name="BranchCountryLocation" select="$reportingFields/mtc:BranchCountryLocation"/>
<xsl:if test="$BranchCountryLocation">
<swBranchLocation>
<xsl:value-of select="$BranchCountryLocation"/>
</swBranchLocation>
</xsl:if>
<xsl:variable name="BeneficiaryParty" select="$reportingHeader/rm:RelatedParty[@id='Beneficiary']/RelatedPartyId"/>
<xsl:if test="$BeneficiaryParty">
<swBeneficiaryIdPrefix>
<xsl:choose>
<xsl:when test="$BeneficiaryParty/@partyIdScheme"><xsl:value-of select="$BeneficiaryParty/@partyIdScheme"/></xsl:when>
<xsl:otherwise>FREEFORMATTEXT</xsl:otherwise>
</xsl:choose>
</swBeneficiaryIdPrefix>
<swBeneficiaryIdValue>
<xsl:value-of select="$BeneficiaryParty"/>
</swBeneficiaryIdValue>
</xsl:if>
<xsl:variable name="OffPlatformVerification" select="$reportingFields/mtc:OffPlatformVerification"/>
<xsl:if test="$OffPlatformVerification">
<swOffPlatformVerificationType>
<xsl:value-of select="$OffPlatformVerification"/>
</swOffPlatformVerificationType>
</xsl:if>
<xsl:variable name="NonStandardFlag" select="$reportingFields/mtc:NonStandardFlag"/>
<xsl:if test="$NonStandardFlag">
<swNonStandardTerms>
<xsl:value-of select="$NonStandardFlag"/>
</swNonStandardTerms>
</xsl:if>
<xsl:variable name="Collateralized" select="$reportingFields/mtc:Collateralized"/>
<xsl:if test="$Collateralized">
<swCollateralized>
<xsl:value-of select="$Collateralized"/>
</swCollateralized>
</xsl:if>
<xsl:variable name="CollateralPortfolioCode" select="$reportingFields/mtc:CollateralPortfolioCode"/>
<xsl:if test="$CollateralPortfolioCode">
<swCollateralPortfolioCode>
<xsl:value-of select="$CollateralPortfolioCode"/>
</swCollateralPortfolioCode>
</xsl:if>
<xsl:variable name="IsAccountingHedge" select="$reportingFields/mtc:IsAccountingHedge"/>
<xsl:if test="$IsAccountingHedge">
<swCommercialActivity>
<xsl:value-of select="$IsAccountingHedge"/>
</swCommercialActivity>
</xsl:if>
<xsl:variable name="TradingCapacity" select="$reportingFields/mtc:TradingCapacity"/>
<xsl:if test="$TradingCapacity">
<swTradingCapacity>
<xsl:value-of select="$TradingCapacity"/>
</swTradingCapacity>
</xsl:if>
</xsl:if>
<xsl:variable name="reportJurisdiction" select="$reportingHeader/mtc:ReportingJurisdiction"/>
<xsl:apply-templates select="$reportJurisdiction[mtc:SupervisoryBody='CFTC']"/>
<xsl:apply-templates select="$reportJurisdiction[mtc:SupervisoryBody='JFSA']"/>
<xsl:apply-templates select="$reportJurisdiction[mtc:SupervisoryBody='ESMA']"/>
<xsl:apply-templates select="$reportJurisdiction[mtc:SupervisoryBody='HKMA']"/>
<xsl:apply-templates select="$reportJurisdiction[mtc:SupervisoryBody='MAS']"/>
<xsl:apply-templates select="$reportJurisdiction[mtc:SupervisoryBody='ASIC']"/>
<xsl:apply-templates select="$reportJurisdiction[mtc:SupervisoryBody='CANADA']"/>
<xsl:variable name="ClearedTimestamp" select="$reportingData/mtc:Timestamps/mtc:ClearedTimestamp"/>
<xsl:if test="$ClearedTimestamp">
<swClearedTradeReporting>
<swClearedTimeStamp><xsl:value-of select="substring($ClearedTimestamp,1,19)"/></swClearedTimeStamp>
</swClearedTradeReporting>
</xsl:if>
<xsl:variable name="ReportingBrokerId" select="$reportingFields/mtc:BusinessUnit[@id='Broker']/mtc:Id"/>
<xsl:if test="$ReportingBrokerId">
<swReportingBrokerId>
<xsl:value-of select="$ReportingBrokerId"/>
</swReportingBrokerId>
</xsl:if>
<swTIWWriteValueDate>true</swTIWWriteValueDate>
</xsl:template>
<xsl:template name="lcl:cptyPrivateData">
<xsl:variable name="ptid" select="$cpti/fpml:tradeId[@tradeIdScheme='TradeRefNbr']"/>
<xsl:if test="$ptid">
<swPrivateTradeId>
<xsl:value-of select="$ptid"/>
</swPrivateTradeId>
</xsl:if>
<swTIWWriteValueDate>false</swTIWWriteValueDate>
</xsl:template>
<xsl:template match="/">
<PrivateData>
<xsl:variable name="ptyRef" select="$pti/fpml:partyReference/@href"/>
<xsl:variable name="cptyRef" select="$cpti/fpml:partyReference/@href"/>
<xsl:choose>
<xsl:when test="$party=$ptyRef">
<xsl:call-template name="lcl:myPrivateData"/>
</xsl:when>
<xsl:when test="$party=$cptyRef">
<xsl:call-template name="lcl:cptyPrivateData"/>
</xsl:when>
<xsl:otherwise>
<PartyError>
<ptyRef><xsl:value-of select="$ptyRef"/></ptyRef>
<cptyRef><xsl:value-of select="$cptyRef"/></cptyRef>
<desiredParty><xsl:value-of select="$party"/></desiredParty>
</PartyError>
</xsl:otherwise>
</xsl:choose>
<swTIWPrivateValueDate>
<xsl:variable name="valueDate" select="$otcrm/rm:Delivery/rm:RouteHist/rm:Route[rm:RouteAddress='www.dtcc.net']/rm:ReleaseTime"/>
<xsl:value-of select="substring($valueDate,1,19)"/>
</swTIWPrivateValueDate>
</PrivateData>
</xsl:template>
</xsl:stylesheet>
