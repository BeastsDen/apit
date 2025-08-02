<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:key
name="data"
match="/SWGenericXML/data/data"
use="concat(../@name, '[', ../@idx, ']/', @name)"/>
<xsl:template name="key-prefix">
<xsl:value-of select="concat(@name, '[', @idx, ']/')"/>
</xsl:template>
</xsl:stylesheet>
