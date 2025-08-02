<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:lcl="http://www.markitserv.com/local/csv2cancellationFee.xsl"
xmlns:gx="http://www.markitserv.com/generic_xml_tools.xsl"
exclude-result-prefixes="lcl gx xsl">
<xsl:import href="generic_xml_tools.xsl"/>
<xsl:output method="xml" encoding="iso-8859-1" indent="yes"/>
<xsl:variable name="xsl" select="document('')/xsl:stylesheet"/>
<gx:template>
<cancellationFee>
<payReceiveDirection gx:data="addpaydirectiona" gx:keep="true"/>
<paymentAmount>
<currency gx:data="addpaycurrency"/>
<amount   gx:data="addpayamount"/>
</paymentAmount>
<paymentDate>
<unadjustedDate gx:data="addpaydate"/>
<dateAdjustments>
<businessDayConvention gx:data="addpayconvention"/>
<businessCenters>
<businessCenter gx:data="addpayholidays"
gx:split=";"/>
</businessCenters>
</dateAdjustments>
</paymentDate>
</cancellationFee>
</gx:template>
<xsl:template match="/">
<xsl:call-template name="gx:start">
<xsl:with-param
name="row"
select="SWGenericXML/data[
@name='AdditionalPayment' and
data[@name='addpayreason'] = 'Cancellation']"/>
</xsl:call-template>
</xsl:template>
</xsl:stylesheet>
