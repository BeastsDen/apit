<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:import href="swdml-details.xsl"/>
<xsl:import href="swbml-details.xsl"/>
<xsl:variable name="input" select="/"/>
<xsl:variable name="apiControl" select="document('APIControl.xml')"/>
<xsl:key name="files"    match="Registrations/File"     use="@id"/>
<xsl:key name="products" match="ProductToClass/Product" use="@id"/>
<xsl:key name="mappings" match="ClassMappings/*"
use="concat(name(), '/', @version, ',', @class)"/>
<xsl:variable name="details">
<xsl:for-each
select="/*[local-name() = 'SWDML']">Swdml/<xsl:call-template
name="getSwdmlDetails"/>
</xsl:for-each>
<xsl:for-each
select="/*[local-name() = 'SWBML']">Swbml/<xsl:call-template
name="getSwbmlDetails"/>
</xsl:for-each>
</xsl:variable>
<xsl:variable name="version" select="substring-before($details, ',')"/>
<xsl:variable
name="product"
select="substring-before(substring-after($details, ','), ',')"/>
<xsl:template match="/">
<xsl:for-each select="$apiControl">
<xsl:variable name="key"
select="concat($version, ',',
key('products', $product))"/>
<xsl:variable
name="mapping"
select="(key('mappings', $key) |
key('mappings', concat($version, ',any')))[last()]"/>
<xsl:choose>
<xsl:when test="$mapping">
<xsl:apply-templates select="$mapping"
mode="implementation"/>
</xsl:when>
<xsl:otherwise>
<xsl:message terminate="yes">
<xsl:value-of
select="concat('no APIControl mappings for: ',
$details)"/>
</xsl:message>
</xsl:otherwise>
</xsl:choose>
</xsl:for-each>
</xsl:template>
<xsl:template match="*" mode="makePI">
<xsl:processing-instruction name="xml-stylesheet">
<xsl:value-of
select="concat('href=&quot;', ., '&quot; ',
'type=&quot;text/xsl&quot;')"/>
</xsl:processing-instruction>
</xsl:template>
<xsl:template match="*" mode="implementation">
<xsl:value-of
select="concat(
'extract: ', key('files', @extract), '&#10;',
'grammar: ', ., '&#10;',
'validation: ', key('files', @validation), '&#10;')"/>
</xsl:template>
</xsl:stylesheet>
