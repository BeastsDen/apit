<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:gx="http://www.markitserv.com/generic_xml_tools.xsl"
exclude-result-prefixes="gx xsl">
<xsl:import href="generic_xml_tools.xsl"/>
<xsl:output method="xml" encoding="iso-8859-1"/>
<xsl:key name="byAppId"
match="/SWGenericXML/data"
use="data[@name='ENT_APPLICATION_ID']"/>
<xsl:key name="appId"
match="/SWGenericXML/data/data[@name='ENT_APPLICATION_ID']"
use="generate-id(..)"/>
<xsl:variable name="row" select="/SWGenericXML/data"/>
<xsl:variable name="allocChildren"
select="$rows[data[@name='ALLOCATION_ID']]"/>
<xsl:variable
name="allocParents"
select="key('byAppId', $allocChildren/data[@name='ALLOCATION_ID'])"/>
<xsl:variable name="pbChildren"
select="$rows[data[@name='PRIME_BROKER_ID'] and
not(data[@name='ALLOCATION_ID'])]"/>
<xsl:variable name="pbChildrenC"
select="$pbChildren[data[@name='PB_TYPE'] = 'C']"/>
<xsl:variable name="pbChildrenI"
select="$pbChildren[data[@name='PB_TYPE'] = 'I']"/>
<xsl:variable
name="pbParents"
select="key('byAppId', $pbChildren/data[@name='PRIME_BROKER_ID'])"/>
<xsl:variable name="children" select="$pbChildren | $allocChildren"/>
<xsl:variable name="trades"
select="$rows[count($children) != count(. | $children)]"/>
<xsl:variable name="xsl" select="document('')/xsl:stylesheet"/>
<gx:template>
<BrokerClearingStatusXML>
<Deal>
<BrokerTradeId     gx:data="BROKER_TRADE_ID"/>
<MarkitWireTradeId gx:data="ENT_APPLICATION_ID"/>
<TradeSource       gx:data="GTS_NAME"/>
<ContractVersion   gx:data="CONTRACT_MAJOR_VERSION"/>
<Version           gx:data="CONTRACT_MINOR_VERSION"/>
<DealState         gx:data="CURRENT_STATE"/>
<Party             gx:call="partyA"/>
<Party             gx:call="partyB"/>
<NotionalAmount    gx:data="NOTIONAL"/>
<PrimeBrokeredTradeInfo>
<CustomerTransaction>
<gx:fragment     gx:call="childTrade"/>
<AllocationsInfo gx:call="AllocationsInfo"/>
</CustomerTransaction>
<InterdealerTransaction>
<gx:fragment     gx:call="childTrade"/>
<AllocationsInfo gx:call="AllocationsInfo"/>
</InterdealerTransaction>
</PrimeBrokeredTradeInfo>
<AllocationsInfo gx:call="AllocationsInfo"/>
<Clearing        gx:call="Clearing"/>
</Deal>
</BrokerClearingStatusXML>
</gx:template>
<gx:template name="childTrade">
<Party             gx:call="partyA"/>
<Party             gx:call="partyB"/>
<BrokerTradeId     gx:data="BROKER_TRADE_ID"/>
<MarkitWireTradeId gx:data="ENT_APPLICATION_ID"/>
<NotionalAmount    gx:data="NOTIONAL"/>
<Clearing          gx:call="Clearing"/>
</gx:template>
<gx:template name="partyA">
<Party>
<PartyId               gx:data="PARTY_A"/>
<PartyInternalTradeId  gx:data="INTERNAL_TRADE_ID_1"/>
<ClearingBrokerId      gx:data="CLEARING_BROKER_BIC_1"/>
<ClearingTradeId       gx:data="CLEARING_TRADE_ID_1"/>
<BetaMarkitWireTradeId gx:data="ASSOCIATED_TRADE_ID_1"/>
<ClearedTradeUSI       gx:requires="CLEARED_TRADE_USI_NAMESPACE_1">
<Issuer            gx:data="CLEARED_TRADE_USI_NAMESPACE_1"
issuerIdScheme="http://www.fpml.org/coding-scheme/external/cftc/issuer-identifier"/>
<TradeID           gx:data="CLEARED_TRADE_USI_1"
tradeIdScheme="http://www.fpml.org/coding-scheme/external/unique-transaction-identifier"/>
</ClearedTradeUSI>
<ClearedTradeGlobalUTI gx:requires="CLEARED_TRADE_GLOBAL_UTI_1">
<TradeID           gx:data="CLEARED_TRADE_GLOBAL_UTI_1"
tradeIdScheme="http://www.fpml.org/coding-scheme/external/unique-transaction-identifier"/>
</ClearedTradeGlobalUTI>
</Party>
</gx:template>
<gx:template name="partyB">
<Party>
<PartyId               gx:data="PARTY_B"/>
<PartyInternalTradeId  gx:data="INTERNAL_TRADE_ID_2"/>
<ClearingBrokerId      gx:data="CLEARING_BROKER_BIC_2"/>
<ClearingTradeId       gx:data="CLEARING_TRADE_ID_2"/>
<BetaMarkitWireTradeId gx:data="ASSOCIATED_TRADE_ID_2"/>
<ClearedTradeUSI       gx:requires="CLEARED_TRADE_USI_NAMESPACE_2">
<Issuer            gx:data="CLEARED_TRADE_USI_NAMESPACE_2"
issuerIdScheme="http://www.fpml.org/coding-scheme/external/cftc/issuer-identifier"/>
<TradeID           gx:data="CLEARED_TRADE_USI_2"
tradeIdScheme="http://www.fpml.org/coding-scheme/external/unique-transaction-identifier"/>
</ClearedTradeUSI>
<ClearedTradeGlobalUTI gx:requires="CLEARED_TRADE_GLOBAL_UTI_2">
<TradeID           gx:data="CLEARED_TRADE_GLOBAL_UTI_2"
tradeIdScheme="http://www.fpml.org/coding-scheme/external/unique-transaction-identifier"/>
</ClearedTradeGlobalUTI>
</Party>
</gx:template>
<gx:template>
<AllocationsInfo>
<AllocationInfo>
<gx:fragment gx:call="childTrade"/>
</AllocationInfo>
</AllocationsInfo>
</gx:template>
<gx:template>
<Clearing gx:requires="CLEARING_HOUSE">
<ClearingState    gx:data="CLEARING_STATE"/>
<ClearingHouseId  gx:data="CLEARING_HOUSE"/>
<RejectReason     gx:data="CLEARING_STATUS_MSG"/>
<ClearedTimestamp gx:format="dateTime" gx:data="CLEARED_TRADE_DATE_TIME"/>
</Clearing>
</gx:template>
<xsl:template match="/">
<xsl:call-template name="gx:start">
<xsl:with-param
name="template"
select="$xsl/gx:template/BrokerClearingStatusXML"/>
</xsl:call-template>
</xsl:template>
<xsl:template match="BrokerClearingStatusXML/Deal">
<xsl:call-template name="gx:continue-with">
<xsl:with-param name="rows" select="$trades"/>
</xsl:call-template>
</xsl:template>
<xsl:template match="AllocationsInfo">
<xsl:param name="row"/>
<xsl:for-each
select="$xsl/gx:template/AllocationsInfo[
count($allocParents | $row) = count($allocParents)]">
<xsl:call-template name="gx:continue-with">
<xsl:with-param name="rows" select="$row"/>
</xsl:call-template>
</xsl:for-each>
</xsl:template>
<xsl:template match="AllocationInfo">
<xsl:param name="row"/>
<xsl:call-template name="gx:continue-with">
<xsl:with-param
name="rows"
select="$allocChildren[
data[@name='ALLOCATION_ID'] =
key('appId', generate-id($row))]"/>
</xsl:call-template>
</xsl:template>
<xsl:template match="PrimeBrokeredTradeInfo">
<xsl:param name="row"/>
<xsl:if test="count($pbParents | $row) = count($pbParents)">
<xsl:call-template name="gx:continue-with">
<xsl:with-param name="rows" select="$row"/>
</xsl:call-template>
</xsl:if>
</xsl:template>
<xsl:template match="CustomerTransaction">
<xsl:param name="row"/>
<xsl:call-template name="gx:continue-with">
<xsl:with-param
name="rows"
select="$pbChildrenC[
data[@name = 'PRIME_BROKER_ID'] =
$row/data[@name = 'ENT_APPLICATION_ID']]"/>
</xsl:call-template>
</xsl:template>
<xsl:template match="InterdealerTransaction">
<xsl:param name="row"/>
<xsl:call-template name="gx:continue-with">
<xsl:with-param
name="rows"
select="$pbChildrenI[
data[@name = 'PRIME_BROKER_ID'] =
$row/data[@name = 'ENT_APPLICATION_ID']]"/>
</xsl:call-template>
</xsl:template>
</xsl:stylesheet>
