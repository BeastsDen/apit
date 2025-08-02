<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:fn="http://www.w3.org/2005/02/xpath-functions"
xmlns:swx="http://com.swapswire.ExternalFunction"
xmlns:exdt="http://exslt.org/dates-and-times"
xmlns:lcl="http://www.markitserv.com/swdate.xsl"
exclude-result-prefixes="swx fn exdt lcl">
<xsl:template match="*" mode="SWDate">
<xsl:choose>
<xsl:when test="function-available('exdt:format-date')">
<xsl:value-of select="exdt:format-date(., 'YYY-MM-DD')"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="."/>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template name="lcl:day">
<xsl:param name="date" select="."/>
<xsl:value-of select="substring($date, 1, 2)"/>
</xsl:template>
<xsl:template name="lcl:month">
<xsl:param name="date" select="."/>
<xsl:value-of select="substring($date, 4, 2)"/>
</xsl:template>
<xsl:template name="lcl:year">
<xsl:param name="date" select="."/>
<xsl:value-of select="substring($date, 7, 4)"/>
</xsl:template>
<xsl:template name="lcl:date">
<xsl:param name="date" select="."/>
<xsl:call-template name="lcl:year">
<xsl:with-param name="date" select="$date"/>
</xsl:call-template>-<xsl:call-template name="lcl:month">
<xsl:with-param name="date" select="$date"/>
</xsl:call-template>-<xsl:call-template name="lcl:day">
<xsl:with-param name="date" select="$date"/>
</xsl:call-template>
</xsl:template>
<xsl:template name="lcl:time">
<xsl:param name="date" select="."/>
<xsl:value-of select="concat(substring($date, 12, 8),'Z')"/>
</xsl:template>
<xsl:template name="lcl:dateTime">
<xsl:param name="date" select="."/>
<xsl:call-template name="lcl:date">
<xsl:with-param name="date" select="$date"/>
</xsl:call-template>T<xsl:call-template name="lcl:time">
<xsl:with-param name="date" select="$date"/>
</xsl:call-template>
</xsl:template>
</xsl:stylesheet>
