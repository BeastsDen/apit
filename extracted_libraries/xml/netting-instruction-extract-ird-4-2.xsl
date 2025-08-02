<?xml version="1.0"?>
<xsl:stylesheet
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:fpml="http://www.fpml.org/2005/FpML-4-2"
xmlns:common="http://exslt.org/common"
exclude-result-prefixes="fpml common"
version="1.0">
<xsl:import href="swdml-extract-ird-4-2.xsl"/>
<xsl:param name="index" select="1"/>
<xsl:output method="xml"/>
<xsl:variable name="SWDML"                     select="/fpml:NettingInstruction"/>
<xsl:variable name="version"                   select="'4-2'"/>
<xsl:variable name="swLongFormTrade"           select="/fpml:NettingInstruction"/>
<xsl:variable name="swStructuredTradeDetails"  select="$SWDML/fpml:swNewPosition[$index]"/>
<xsl:variable name="swTradeEventReportingDetails" select="$swStructuredTradeDetails/fpml:swTradeEventReportingDetails"/>
<xsl:variable name="nettingBatchId"            select="/fpml:NettingInstruction/fpml:swHeader/fpml:swNettingBatchId"/>
<xsl:variable name="apiBatchId"            select="/fpml:NettingInstruction/fpml:swHeader/fpml:swApiBatchId"/>
<xsl:variable
name="privateClearingTradeID"
select="$trade/fpml:tradeHeader/fpml:partyTradeIdentifier[
fpml:partyReference/@href='partyA']/fpml:tradeId"/>
<xsl:variable
name="linkTradeID"
select="$trade/fpml:tradeHeader/fpml:partyTradeIdentifier[
fpml:partyReference/@href='partyB']/fpml:linkId[@linkIdScheme='http://www.swapswire.com/spec/2001/trade-id-1-0']"/>
<xsl:variable
name="linkCCPID"
select="$trade/fpml:tradeHeader/fpml:partyTradeIdentifier[
fpml:partyReference/@href='partyB']/fpml:linkId[@linkIdScheme!='http://www.swapswire.com/spec/2001/trade-id-1-0']"/>
<xsl:variable name="bulkEventID" select="fpml:swGTRBulkEventProcessingID"/>
<xsl:variable name="nettingString"
select="$trade/fpml:tradeHeader/fpml:partyTradeIdentifier/fpml:tradeId[@tradeIdScheme='http://www.markitwire.com/spec/2016/coding-scheme/netting-string']"/>
<xsl:variable name="swLinkedTradeDetails"
select="$trade/fpml:tradeHeader/fpml:partyTradeIdentifier[fpml:partyReference/@href='partyB']/fpml:linkId"/>
<xsl:variable name="swHeader"      select="/fpml:NettingInstruction/fpml:swHeader"/>
</xsl:stylesheet>
