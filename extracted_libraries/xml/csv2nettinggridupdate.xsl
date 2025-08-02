<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:gx="http://www.markitserv.com/generic_xml_tools.xsl"
xmlns="http://www.markitserv.com/2015/NettingInstructionResp1-0"
xmlns:nir="http://www.markitserv.com/2015/NettingInstructionResp1-0"
exclude-result-prefixes="gx xsl nir">
<xsl:import href="generic_xml_tools.xsl"/>
<xsl:output method="xml" encoding="iso-8859-1"/>
<xsl:variable name="xsl"       select="document('')/xsl:stylesheet"/>
<xsl:variable name="templates" select="$xsl/gx:template"/>
<xsl:variable name="header" select="$rows[@name='Header']"/>
<xsl:variable name="tradeStatusInformation" select="$rows[@name='Trade Status']"/>
<xsl:variable name="book" select="$rows[@name='Book']"/>
<gx:template>
<NettingGridUpdate>
<CorrelationId    gx:data="CorrelationId"/>
<NettingBatchId   gx:data="NettingBatchId"/>
<NettingBatchSize gx:data="NettingBatchSize"/>
<OriginatingEvent gx:data="OriginatingEvent"/>
<GridAppID        gx:data="GridAppID"/>
<GridEntityID     gx:data="GridEntityID"/>
<ClearingHouse    gx:data="ClearingHouse"/>
<LegalEntity      gx:data="LegalEntity"/>
<KnownBatchId     gx:data="KnownBatchId"/>
<SubCategory      gx:data="SubCategory"/>
<Book/>
<TradeStatusInformation>
<NettingInstructionType gx:data="NettingInstructionType"/>
<SequenceNumber         gx:data="SequenceNumber"/>
<MarkitWireTradeId      gx:data="MarkitWireTradeId"/>
<ClearingHouseTradeId   gx:data="ClearingHouseTradeId"/>
<Status                 gx:data="Status"/>
<ContractState          gx:data="ContractState"/>
<ErrorText              gx:data="ErrorText"/>
</TradeStatusInformation>
</NettingGridUpdate>
</gx:template>
<xsl:template match="nir:Book">
<xsl:for-each select="$book">
<Book>
<xsl:value-of select="."/>
</Book>
</xsl:for-each>
</xsl:template>
<xsl:template match="nir:Header">
<xsl:call-template name="gx:continue-with">
<xsl:with-param name="rows" select="$header"/>
</xsl:call-template>
</xsl:template>
<xsl:template match="nir:TradeStatusInformation">
<xsl:call-template name="gx:continue-with">
<xsl:with-param name="rows" select="$tradeStatusInformation"/>
</xsl:call-template>
</xsl:template>
<xsl:template match="/">
<xsl:call-template name="gx:start">
<xsl:with-param
name="template"
select="$templates/nir:NettingGridUpdate"/>
</xsl:call-template>
</xsl:template>
</xsl:stylesheet>
