<xsl:stylesheet
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns:fpml40="http://www.fpml.org/2003/FpML-4-0"
xmlns:fpml41="http://www.fpml.org/2004/FpML-4-1"
xmlns:fpml42="http://www.fpml.org/2005/FpML-4-2"
xmlns:fpml44="http://www.fpml.org/2007/FpML-4-4"
xmlns:fpml45="http://www.fpml.org/2008/FpML-4-5"
xmlns:fpml46="http://www.fpml.org/2009/FpML-4-6"
xmlns:fpml47="http://www.fpml.org/2009/FpML-4-7"
xmlns:fpml49="http://www.fpml.org/2010/FpML-4-9"
xmlns:fpml53="http://www.markitserv.com/swml"
xmlns:fpml511="http://www.markitserv.com/swml-5-11"
exclude-result-prefixes="fpml40 fpml41 fpml42 fpml44 fpml45 fpml46 fpml47 fpml49 fpml53 fpml511"
version="1.0">
<xsl:output method="text"/>
<xsl:template match="SWBML|fpml40:SWBML|fpml41:SWBML|fpml42:SWBML|fpml44:SWBML|fpml45:SWBML|fpml46:SWBML|fpml47:SWBML|fpml49:SWBML|fpml53:SWBML|fpml511:SWBML">
<xsl:call-template name="getSwbmlDetails"/>
</xsl:template>
<xsl:template name="getSwbmlDetails">
<xsl:variable name="productType">
<xsl:value-of select="/SWBML/swbStructuredTradeDetails/swbProductType"/>
<xsl:value-of select="/fpml40:SWBML/fpml40:swbStructuredTradeDetails/fpml40:swbProductType"/>
<xsl:value-of select="/fpml41:SWBML/fpml41:swbStructuredTradeDetails/fpml41:swbProductType"/>
<xsl:value-of select="/fpml42:SWBML/fpml42:swbStructuredTradeDetails/fpml42:swbProductType"/>
<xsl:value-of select="/fpml44:SWBML/fpml44:swbStructuredTradeDetails/fpml44:swbProductType"/>
<xsl:value-of select="/fpml45:SWBML/fpml45:swbStructuredTradeDetails/fpml45:swbProductType"/>
<xsl:value-of select="/fpml46:SWBML/fpml46:swbStructuredTradeDetails/fpml46:swbProductType"/>
<xsl:value-of select="/fpml47:SWBML/fpml47:swbStructuredTradeDetails/fpml47:swbProductType"/>
<xsl:value-of select="/fpml49:SWBML/fpml49:swbStructuredTradeDetails/fpml49:swbProductType"/>
<xsl:value-of select="/fpml53:SWBML/fpml53:swStructuredTradeDetails/fpml53:swProductType"/>
<xsl:value-of select="/fpml511:SWBML/fpml511:swStructuredTradeDetails/fpml511:swProductType"/>
</xsl:variable>
<xsl:value-of select="@version"/>,<xsl:value-of select="$productType"/>,<xsl:value-of select="@xsi:schemaLocation"/>
</xsl:template>
<xsl:template match="*"/>
</xsl:stylesheet>
