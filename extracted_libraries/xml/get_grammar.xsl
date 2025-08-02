<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
<xsl:import href="process_api_control.xsl"/>
<xsl:output method="text"/>
<xsl:template match="*" mode="implementation">
<xsl:value-of select="concat(., '&#10;')"/>
</xsl:template>
</xsl:stylesheet>
