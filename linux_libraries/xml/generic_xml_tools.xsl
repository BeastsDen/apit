<xsl:stylesheet
version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:gx="http://www.markitserv.com/generic_xml_tools.xsl"
xmlns:swdate="http://www.markitserv.com/swdate.xsl"
exclude-result-prefixes="gx xsl">
<xsl:import href="swdate.xsl"/>
<xsl:output method="xml" indent="yes"/>
<xsl:strip-space elements="*"/>
<xsl:variable name="input" select="/"/>
<xsl:variable name="rows"  select="/SWGenericXML/data"/>
<xsl:variable name="xsl"       select="document('')/xsl:stylesheet"/>
<xsl:variable name="templates" select="$xsl/gx:template"/>
<xsl:variable name="gx:keepDefault" select="false()"/>
<xsl:template match="*" name="gx:copy">
<xsl:param name="row"/>
<xsl:element name="{local-name()}"
namespace="{namespace-uri()}">
<xsl:apply-templates select="node() | @*">
<xsl:with-param name="row" select="$row"/>
</xsl:apply-templates>
</xsl:element>
</xsl:template>
<xsl:template match="@*">
<xsl:param name="row"/>
<xsl:attribute name="{local-name()}" namespace="{namespace-uri()}">
<xsl:value-of select="."/>
</xsl:attribute>
</xsl:template>
<xsl:template match="@gx:*"/>
<xsl:template match="*[@gx:data]" mode="gx:format">
<xsl:param name="value"/>
<xsl:value-of select="$value"/>
</xsl:template>
<xsl:template match="*[@gx:format = 'date']" mode="gx:format">
<xsl:param name="value"/>
<xsl:apply-templates select="$value" mode="SWDate"/>
</xsl:template>
<xsl:template match="*[@gx:format = 'dateTime']" mode="gx:format">
<xsl:param name="value"/>
<xsl:call-template name="swdate:dateTime">
<xsl:with-param name="date" select="$value"/>
</xsl:call-template>
</xsl:template>
<xsl:template match="*[@gx:format = 'boolean']" mode="gx:format">
<xsl:param name="value"/>
<xsl:value-of select="boolean($value)"/>
</xsl:template>
<xsl:template match="*[@gx:data]" name="gx:elem">
<xsl:param name="row"/>
<xsl:param name="value" select="$row/data[@name = current()/@gx:data]"/>
<xsl:if test="$value or @gx:keep or $gx:keepDefault">
<xsl:element name="{local-name()}" namespace="{namespace-uri()}">
<xsl:apply-templates select="@*">
<xsl:with-param name="row" select="$row"/>
</xsl:apply-templates>
<xsl:apply-templates select="." mode="gx:format">
<xsl:with-param name="value" select="$value"/>
</xsl:apply-templates>
</xsl:element>
</xsl:if>
</xsl:template>
<xsl:template match="*[@gx:data = '']">
<xsl:param name="row"/>
<xsl:call-template name="gx:elem">
<xsl:with-param name="value" select="."/>
</xsl:call-template>
</xsl:template>
<xsl:template match="*[@gx:data and @gx:split]">
<xsl:param name="row"/>
<xsl:param name="value" select="$row/data[@name = current()/@gx:data]"/>
<xsl:choose>
<xsl:when test="contains($value, @gx:split)">
<xsl:call-template name="gx:elem">
<xsl:with-param name="row" select="$row"/>
<xsl:with-param
name="value"
select="substring-before($value, @gx:split)"/>
</xsl:call-template>
<xsl:apply-templates select=".">
<xsl:with-param
name="value"
select="substring-after($value, @gx:split)"/>
</xsl:apply-templates>
</xsl:when>
<xsl:otherwise>
<xsl:call-template name="gx:elem">
<xsl:with-param name="row" select="$row"/>
<xsl:with-param name="value" select="$value"/>
</xsl:call-template>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template match="*[@gx:requires]">
<xsl:param name="row"/>
<xsl:if test="$row/data[@name = current()/@gx:requires]">
<xsl:call-template name="gx:continue-with">
<xsl:with-param name="rows" select="$row"/>
</xsl:call-template>
</xsl:if>
</xsl:template>
<xsl:template name="gx:continue-with">
<xsl:param name="rows"/>
<xsl:param name="template" select="."/>
<xsl:for-each select="$rows">
<xsl:element name="{local-name($template)}"
namespace="{namespace-uri($template)}">
<xsl:apply-templates select="$template/*">
<xsl:with-param name="row" select="."/>
</xsl:apply-templates>
</xsl:element>
</xsl:for-each>
</xsl:template>
<xsl:template match="gx:fragment | *[@gx:call]">
<xsl:param name="row"/>
<xsl:variable name="name" select="@gx:call"/>
<xsl:variable
name="template"
select="$templates[$name = name(*[1]) or $name = @name]"/>
<xsl:if test="count($template) != 1">
<xsl:message terminate="yes">
<xsl:value-of
select="concat('error calling template: ', @gx:call)"/>
</xsl:message>
</xsl:if>
<xsl:apply-templates select="$template/*">
<xsl:with-param name="row" select="$row"/>
</xsl:apply-templates>
</xsl:template>
<xsl:template name="gx:start">
<xsl:param name="template" select="$templates/*"/>
<xsl:param name="row"      select="$rows[1]"/>
<xsl:apply-templates select="$template">
<xsl:with-param name="row" select="$row"/>
</xsl:apply-templates>
</xsl:template>
</xsl:stylesheet>
