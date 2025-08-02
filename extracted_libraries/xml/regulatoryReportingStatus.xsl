<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:lcl="http://www.markitserv.com/regulatoryReporting.xsl">
<xsl:output method="xml" indent="yes"/>
<xsl:variable name="input"         select="/"/>
<xsl:variable name="rows"          select="/SWGenericXML/data"/>
<xsl:variable name="lcl:templates" select="document('')/xsl:stylesheet"/>
<lcl:rowElements>
<RegulatoryReportingStatus>
<trade>
<tradeID lcl:data="TradeID"/>
<reportingStatusData>
<regulatoryReportingTradeIdentifier>
<swIssuer  lcl:data="IDContext"/>
<swTradeId lcl:data='ID'/>
</regulatoryReportingTradeIdentifier>
<majorVersion    lcl:data='MajorVersion'/>
<minorVersion    lcl:data='MinorVersion'/>
<dvh             lcl:data='DVH'/>
<eventId         lcl:data='EventID'/>
<counterpartyId  lcl:data='CptyLEID'/>
<ownPartyId      lcl:data='OurLEID'/>
<reporterId      lcl:data='ReporterLE'/>
<initiatorId     lcl:data='InitiatorLE'/>
<repositoryId    lcl:data='Venue'
repositoryIdScheme="http://www.markitserv.com/spec/2012/repository-id-1-0"/>
<jurisdiction    lcl:data='Regime'/>
<regulator       lcl:data='Regulator'/>
<assetClass      lcl:data='AssetClass'/>
<facet           lcl:data='Facet'/>
<reportType      lcl:data='Type'/>
<messageType     lcl:data='MsgType'/>
<transactionType lcl:data='TransactionType'/>
<transactionMode lcl:data='TransactionMode'/>
<verification    lcl:data='Verification'/>
<reportingStatus>
<status                    lcl:data='Status'/>
<failureReason/>
<initiatedTimestamp        lcl:data='InitiatedAt'/>
<responseReceivedTimestamp lcl:data='ResponseReceivedAt'/>
</reportingStatus>
</reportingStatusData>
</trade>
</RegulatoryReportingStatus>
</lcl:rowElements>
<xsl:template match="trade">
<xsl:param name="row"/>
<xsl:variable name="currentPosition" select="."/>
<xsl:variable
name="trades"
select="$rows[not(data[@name = 'TradeID'] = preceding-sibling::data/data[@name = 'TradeID'])]"/>
<xsl:for-each select="$trades">
<trade>
<xsl:apply-templates select="$currentPosition/*">
<xsl:with-param name="row" select="."/>
</xsl:apply-templates>
</trade>
</xsl:for-each>
</xsl:template>
<xsl:template match="reportingStatusData">
<xsl:param name="row"/>
<xsl:variable name="currentPosition" select="."/>
<xsl:variable name="tradeId" select="$row/data[@name='TradeID']"/>
<xsl:for-each select="$rows[data[@name = 'TradeID'] = $tradeId]">
<reportingStatusData>
<xsl:apply-templates select="$currentPosition/*">
<xsl:with-param name="row" select="."/>
</xsl:apply-templates>
</reportingStatusData>
</xsl:for-each>
</xsl:template>
<xsl:template name="repositoryErrorReason">
<xsl:param name="error"/>
<xsl:variable name="currentError">
<xsl:choose>
<xsl:when test="contains($error,';')">
<xsl:value-of select="substring-before($error,';')"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$error"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="nextError">
<xsl:if test="contains($error,';')">
<xsl:value-of select="substring-after($error,';')"/>
</xsl:if>
</xsl:variable>
<xsl:choose>
<xsl:when test="contains($currentError,'Code - ') and contains($currentError,' : Location -') and contains($currentError,'Description - ')">
<repositoryErrorReason>
<repositoryErrorCode><xsl:value-of select="substring-before(substring-after($currentError,'Code - '),' : Location -')"/></repositoryErrorCode>
<repositoryErrorDescription><xsl:value-of select="$currentError"/></repositoryErrorDescription>
</repositoryErrorReason>
</xsl:when>
<xsl:otherwise>
<repositoryErrorReason>
<repositoryErrorDescription><xsl:value-of select="$currentError"/></repositoryErrorDescription>
</repositoryErrorReason>
</xsl:otherwise>
</xsl:choose>
<xsl:if test="$nextError!='' and contains($nextError,'Code - ') and contains($nextError,' : Location -') and contains($nextError,'Description - ')">
<xsl:call-template name="repositoryErrorReason">
<xsl:with-param name="error" select="$nextError"/>
</xsl:call-template>
</xsl:if>
</xsl:template>
<xsl:template match="failureReason">
<xsl:param name="row"/>
<xsl:variable name="error" select="$row/data[@name='Error']"/>
<xsl:if test="$error!=''">
<xsl:call-template name="repositoryErrorReason">
<xsl:with-param name="error" select="$error"/>
</xsl:call-template>
</xsl:if>
</xsl:template>
<xsl:template match="*|@*">
<xsl:param name="row"/>
<xsl:copy>
<xsl:apply-templates select="*|@*">
<xsl:with-param name="row" select="$row"/>
</xsl:apply-templates>
</xsl:copy>
</xsl:template>
<xsl:template match="@lcl:*"/>
<xsl:template match="*[@lcl:data]">
<xsl:param name="row"/>
<xsl:variable name="value"
select="$row/data[@name = current()/@lcl:data]"/>
<xsl:if test="$value or @lcl:keep">
<xsl:copy>
<xsl:apply-templates select="@*"/>
<xsl:value-of select="$value"/>
</xsl:copy>
</xsl:if>
</xsl:template>
<xsl:template match="/">
<xsl:apply-templates select="$lcl:templates/lcl:rowElements/*">
<xsl:with-param name="row" select="$rows[1]"/>
</xsl:apply-templates>
</xsl:template>
</xsl:stylesheet>
