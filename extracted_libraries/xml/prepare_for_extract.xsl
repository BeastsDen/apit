<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:import href="process_api_control.xsl"/>
<xsl:import href="identity.xsl"/>
<xsl:output method="xml" encoding="UTF-8"/>
<xsl:template match="*" mode="implementation">
<xsl:apply-templates mode="makePI" select="key('files', @extract)"/>
<xsl:apply-templates select="$input/*"/>
</xsl:template>
</xsl:stylesheet>
