<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:gx="http://www.markitserv.com/generic_xml_tools.xsl"
exclude-result-prefixes="xsl gx">
<xsl:import href="generic_xml_tools.xsl"/>
<xsl:output method="xml" encoding="iso-8859-1" indent="yes"/>
<xsl:variable name="xsl" select="document('')/xsl:stylesheet"/>
<gx:template>
<Recipient id="_1">
<ParticipantId gx:data="participantname"/>
<GroupId       gx:data="groups" gx:split=";"/>
<UserId        gx:data="users"  gx:split=";"/>
</Recipient>
</gx:template>
<xsl:template match="/SWGenericXML">
<xsl:call-template name="gx:start">
<xsl:with-param
name="row"
select="data[@name = 'Trade' or
(@name = 'AdditionalPayment' and
data[@name = 'addpayreason'] = 'Cancellation')]"/>
</xsl:call-template>
</xsl:template>
</xsl:stylesheet>
