<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns:fpml45="http://www.fpml.org/2008/FpML-4-5"
xmlns:fpml46="http://www.fpml.org/2009/FpML-4-6"
xmlns:fpml47="http://www.fpml.org/2009/FpML-4-7"
xmlns:fpml49="http://www.fpml.org/2010/FpML-4-9"
exclude-result-prefixes="fpml45 fpml46 fpml47 fpml49"
version="1.0">
<xsl:output method="text"/>
<xsl:template match="fpml45:PositionChange">
<xsl:variable name="productClass">
<xsl:choose>
<xsl:when test="/fpml45:PositionChange/fpml45:cdsIndex">cd</xsl:when>
<xsl:otherwise>*** Not Supported ***</xsl:otherwise>
</xsl:choose>
</xsl:variable>4-5,<xsl:value-of select="$productClass"/>,<xsl:value-of select="@xsi:schemaLocation"/>
</xsl:template>
<xsl:template match="fpml46:PositionChange">
<xsl:variable name="productClass">
<xsl:choose>
<xsl:when test="/fpml46:PositionChange/fpml46:cdsMaster">cd</xsl:when>
<xsl:when test="/fpml46:PositionChange/fpml46:cdsMatrix">cd</xsl:when>
<xsl:when test="/fpml46:PositionChange/fpml46:equity/fpml46:equityOption">eqd</xsl:when>
<xsl:when test="/fpml46:PositionChange/fpml46:equity/fpml46:dividendSwap">eqd</xsl:when>
<xsl:when test="/fpml46:PositionChange/fpml46:equity/fpml46:varianceSwap">eqd</xsl:when>
<xsl:when test="/fpml46:PositionChange/fpml46:equity/fpml46:equitySwap">eqd</xsl:when>
<xsl:otherwise>*** Not Supported ***</xsl:otherwise>
</xsl:choose>
</xsl:variable>4-6,<xsl:value-of select="$productClass"/>,<xsl:value-of select="@xsi:schemaLocation"/>
</xsl:template>
<xsl:template match="fpml47:PositionChange">
<xsl:variable name="productClass">
<xsl:choose>
<xsl:when test="/fpml47:PositionChange/fpml47:cdsMaster">cd</xsl:when>
<xsl:when test="/fpml47:PositionChange/fpml47:cdsMatrix">cd</xsl:when>
<xsl:when test="/fpml47:PositionChange/fpml47:equity/fpml47:equityOption">eqd</xsl:when>
<xsl:when test="/fpml47:PositionChange/fpml47:equity/fpml47:dividendSwap">eqd</xsl:when>
<xsl:when test="/fpml47:PositionChange/fpml47:equity/fpml47:varianceSwap">eqd</xsl:when>
<xsl:when test="/fpml47:PositionChange/fpml47:equity/fpml47:equitySwap">eqd</xsl:when>
<xsl:otherwise>*** Not Supported ***</xsl:otherwise>
</xsl:choose>
</xsl:variable>4-7,<xsl:value-of select="$productClass"/>,<xsl:value-of select="@xsi:schemaLocation"/>
</xsl:template>
<xsl:template match="fpml49:PositionChange">
<xsl:variable name="productClass">
<xsl:choose>
<xsl:when test="/fpml49:PositionChange/fpml49:equity/fpml49:equityOption">eqd</xsl:when>
<xsl:when test="/fpml49:PositionChange/fpml49:equity/fpml49:dividendSwap">eqd</xsl:when>
<xsl:when test="/fpml49:PositionChange/fpml49:equity/fpml49:varianceSwap">eqd</xsl:when>
<xsl:when test="/fpml49:PositionChange/fpml49:equity/fpml49:volatilitySwap">eqd</xsl:when>
<xsl:when test="/fpml49:PositionChange/fpml49:equity/fpml49:equitySwap">eqd</xsl:when>
<xsl:when test="/fpml49:PositionChange/fpml49:equity/fpml49:Accumulator">eqd</xsl:when>
<xsl:when test="/fpml49:PositionChange/fpml49:equity/fpml49:basketSwap">eqd</xsl:when>
<xsl:when test="/fpml49:PositionChange/fpml49:credit">cd</xsl:when>
<xsl:otherwise>*** Not Supported ***</xsl:otherwise>
</xsl:choose>
</xsl:variable>4-9,<xsl:value-of select="$productClass"/>,<xsl:value-of select="@xsi:schemaLocation"/>
</xsl:template>
<xsl:template match="*">Not PositionChange xml</xsl:template>
</xsl:stylesheet>
