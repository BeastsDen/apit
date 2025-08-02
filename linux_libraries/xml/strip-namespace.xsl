<?xml version="1.0" ?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fpml="http://www.fpml.org/2004/FpML-4-1"
	version="1.0" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:exslt="http://exslt.org/common"
	xmlns:xt="http://www.jclark.com/xt" extension-element-prefixes="exslt msxsl xt" exclude-result-prefixes="exslt msxsl xt fpml">
	<xsl:output method="xml" />
	<xsl:template match="fpml:SWML">
		<SWML version="{@version}">
			<xsl:apply-templates />
		</SWML>
	</xsl:template>
	<xsl:template match="fpml:SWDML">
		<SWDML version="{@version}">
			<xsl:apply-templates />
		</SWDML>
	</xsl:template>
	<xsl:template match="fpml:FpML">
		<FpML version="{@version}">
			<xsl:apply-templates />
		</FpML>
	</xsl:template>
	<xsl:template match='*'>
		<xsl:element name='{name()}' namespace=''>
			<xsl:apply-templates select='@*' />
			<xsl:apply-templates select="* | text()" />
		</xsl:element>
	</xsl:template>
	<xsl:template match='@*'>
		<xsl:copy-of select='.' />
	</xsl:template>
</xsl:stylesheet>
