<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns:env="http://schemas.xmlsoap.org/soap/envelope/"
xmlns:fpml="http://www.fpml.org/2010/FpML-4-9"
xmlns:common="http://exslt.org/common"
xmlns:mtc="OTC_Matching_11-0"
xmlns:rm="OTC_RM_11-0"
exclude-result-prefixes="xsi env fpml common mtc rm" version="1.0">
<xsl:output method="xml" indent="yes"/>
<xsl:strip-space elements="*"/>
<xsl:template name="fix_ac_id">
<xsl:param name="id_in"/>
<xsl:choose>
<xsl:when test="starts-with($id_in, 'DTCC')"><xsl:value-of select="substring($id_in, 5)"/></xsl:when>
<xsl:otherwise><xsl:value-of select="$id_in"/></xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template match="/env:Envelope">
<xsl:variable name="otcrm" select="/env:Envelope/env:Header/rm:OTC_RM"/>
<xsl:variable name="position" select="/env:Envelope/env:Body/mtc:OTC_Matching/mtc:Inquiry/mtc:Position"/>
<xsl:variable name="noTradeDetails" select="$position/mtc:NoTradeDetails"/>
<xsl:variable name="parties" select="$position/mtc:party"/>
<TIWNTDTrade>
<ProductType/>
<PartyAId>
<xsl:call-template name="fix_ac_id">
<xsl:with-param name="id_in"><xsl:value-of select="$parties[@id='partyA']/fpml:partyId"/></xsl:with-param>
</xsl:call-template>
</PartyAId>
<PartyAIdType><xsl:value-of select="$parties[@id='partyA']/fpml:partyId/@partyIdScheme"/></PartyAIdType>
<PartyBId>
<xsl:call-template name="fix_ac_id">
<xsl:with-param name="id_in"><xsl:value-of select="$parties[@id='partyB']/fpml:partyId"/></xsl:with-param>
</xsl:call-template>
</PartyBId>
<PartyBIdType><xsl:value-of select="$parties[@id='partyB']/fpml:partyId/@partyIdScheme"/></PartyBIdType>
<ExitReason><xsl:value-of select="$noTradeDetails/mtc:Reason"/></ExitReason>
<EffectiveDate><xsl:value-of select="$noTradeDetails/mtc:ReasonDate"/></EffectiveDate>
<TIWDTCCTRI><xsl:value-of select="$noTradeDetails/mtc:YourTradeId/mtc:partyTradeIdentifier/fpml:tradeId[@tradeIdScheme='DTCCTradeId']"/></TIWDTCCTRI>
<TIWActiveStatus>Inactive</TIWActiveStatus>
<TIWValueDate>
<xsl:variable name="valueDate" select="$otcrm/rm:Delivery/rm:RouteHist/rm:Route[rm:RouteAddress='www.dtcc.net']/rm:ReleaseTime"/>
<xsl:value-of select="substring($valueDate,1,19)"/>
</TIWValueDate>
</TIWNTDTrade>
</xsl:template>
</xsl:stylesheet>
