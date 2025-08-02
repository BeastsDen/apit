<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
xmlns:swx="http://com.swapswire.ExternalFunction"
exclude-result-prefixes="swx fn">
<xsl:template name="split">
<xsl:param name="list" select="." />
<xsl:param name="delim" select="';'" />
<xsl:param name="element"/>
<xsl:choose>
<xsl:when test="contains($list, $delim)">
<xsl:element name="{$element}">
<xsl:value-of select="substring-before($list, $delim)"/>
</xsl:element>
<xsl:call-template name="split">
<xsl:with-param name="list" select="substring-after($list, $delim)"/>
<xsl:with-param name="element" select="$element"/>
<xsl:with-param name="delim"   select="$delim"/>
</xsl:call-template>
</xsl:when>
<xsl:when test="$list">
<xsl:element name="{$element}">
<xsl:value-of select="$list"/>
</xsl:element>
</xsl:when>
</xsl:choose>
</xsl:template>
</xsl:stylesheet>
