<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:gx="http://www.markitserv.com/generic_xml_tools.xsl"
xmlns="http://www.markitserv.com/2015/NettingInstructionResp1-0"
xmlns:nir="http://www.markitserv.com/2015/NettingInstructionResp1-0"
exclude-result-prefixes="gx xsl">
<xsl:import href="generic_xml_tools.xsl"/>
<xsl:output method="xml" encoding="iso-8859-1"/>
<xsl:variable name="xsl"       select="document('')/xsl:stylesheet"/>
<xsl:variable name="templates" select="$xsl/gx:template"/>
<xsl:variable name="header" select="$rows[@name='Header']"/>
<xsl:variable name="tradeStatusInformation" select="$rows[@name='Trade Status']"/>
<gx:template>
<NettingInstructionResp>
<Header>
<CorrelationId gx:data="CorrelationId"/>
<NettingBatchId gx:data="NettingBatchId"/>
<ClearingHouse>
<partyId gx:data="ClearingHouse"/>
</ClearingHouse>
<LegalEntity>
<partyId gx:data="LegalEntity"/>
</LegalEntity>
</Header>
<TradeStatusInformation>
<NettingInstructionType gx:data="NettingInstructionType"/>
<ClearingBroker gx:requires="ClearingBroker">
<partyId gx:data="ClearingBroker"/>
</ClearingBroker>
<MarkitWireTradeId gx:data="MarkitWireTradeId"/>
<ClearingHouseTradeId gx:data="ClearingHouseTradeId"/>
<Status gx:data="Status"/>
<ErrorText gx:data="ErrorText"/>
</TradeStatusInformation>
</NettingInstructionResp>
</gx:template>
<xsl:template match="nir:NettingInstructionResp/nir:Header">
<xsl:call-template name="gx:continue-with">
<xsl:with-param name="rows" select="$header"/>
</xsl:call-template>
</xsl:template>
<xsl:template match="nir:NettingInstructionResp/nir:TradeStatusInformation">
<xsl:call-template name="gx:continue-with">
<xsl:with-param name="rows" select="$tradeStatusInformation"/>
</xsl:call-template>
</xsl:template>
<xsl:template match="/">
<xsl:call-template name="gx:start">
<xsl:with-param
name="template"
select="$templates/nir:NettingInstructionResp"/>
</xsl:call-template>
</xsl:template>
</xsl:stylesheet>
