<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:output method="text" omit-xml-declaration="yes" indent="no"/>
<xsl:variable name="single_pymt_amt_prem_pymt_amt" select="/TiwCsvMessage/SINGLE_PYMT_AMT_PREM_PYMT_AMT"/>
<xsl:variable name="init_pymt_amt_prem_pymt_amt" select="/TiwCsvMessage/INIT_PYMT_AMT_PREM_PYMT_AMT"/>
<xsl:template match="/">
<xsl:if test="($init_pymt_amt_prem_pymt_amt and number($init_pymt_amt_prem_pymt_amt) &gt; 0)">
<xsl:if test="($single_pymt_amt_prem_pymt_amt and number($single_pymt_amt_prem_pymt_amt) &gt; 0)">
<xsl:text>Invalid Recon Content: Recon contains non-zero values for both Initial Payment Amount and Premium Payment Amount.</xsl:text>
</xsl:if>
</xsl:if>
</xsl:template>
</xsl:stylesheet>
