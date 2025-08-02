<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:tx="http://www.markitserv.com/detail/SWDMLTrade.xsl"
xmlns:common="http://exslt.org/common"
exclude-result-prefixes="common tx">
<xsl:import href="SWDMLTrade.xsl"/>
<xsl:output method="xml"/>
<xsl:template match="/">
<xsl:apply-templates select="*" mode="get-reporting-data"/>
</xsl:template>
<xsl:variable name="reportingData.rtf"/>
<xsl:variable name="dfJurisdiction">
<xsl:text>DoddFrank</xsl:text>
</xsl:variable>
<xsl:variable name="jfsaJurisdiction">
<xsl:text>JFSA</xsl:text>
</xsl:variable>
<xsl:variable name="esmaJurisdiction">
<xsl:text>ESMA</xsl:text>
</xsl:variable>
<xsl:variable name="hkmaJurisdiction">
<xsl:text>HKMA</xsl:text>
</xsl:variable>
<xsl:variable name="caJurisdiction">
<xsl:text>CAN</xsl:text>
</xsl:variable>
<xsl:variable name="seJurisdiction">
<xsl:text>SEC</xsl:text>
</xsl:variable>
<xsl:variable name="miJurisdiction">
<xsl:text>MIFID</xsl:text>
</xsl:variable>
<xsl:variable name="asicJurisdiction">
<xsl:text>ASIC</xsl:text>
</xsl:variable>
<xsl:variable name="masJurisdiction">
<xsl:text>MAS</xsl:text>
</xsl:variable>
<xsl:variable name="fcaJurisdiction">
<xsl:text>FCA</xsl:text>
</xsl:variable>
<xsl:template match="/*[function-available('common:node-set')]" mode="get-reporting-data">
<xsl:apply-templates select=".">
<xsl:with-param name="reportingData" select="common:node-set($reportingData.rtf)"/>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="/*[not(function-available('common:node-set'))]" mode="get-reporting-data">
<xsl:apply-templates select=".">
<xsl:with-param name="reportingData" select="$reportingData.rtf"/>
</xsl:apply-templates>
</xsl:template>
<xsl:template match="/|comment()|processing-instruction()" mode="mapReportingData">
<xsl:copy>
<xsl:apply-templates mode="mapReportingData"/>
</xsl:copy>
</xsl:template>
<xsl:template match="*" mode="mapReportingData">
<xsl:element name="{local-name()}">
<xsl:apply-templates select="@*|node()" mode="mapReportingData"/>
</xsl:element>
</xsl:template>
<xsl:template match="@*" mode="mapReportingData">
<xsl:attribute name="{local-name()}"><xsl:value-of select="."/></xsl:attribute>
</xsl:template>
<xsl:template name="rcpForNovation">
<xsl:param name="rcp"/>
<xsl:param name="reportingData"/>
<xsl:choose>
<xsl:when test="/SWDML/@version = '3-0' or /SWDML/@version = '3-1'">
<xsl:choose>
<xsl:when test="$rcp = substring-after($reportingData/partyRoles/remainingParty,'#')">partyB</xsl:when>
<xsl:when test="$rcp = substring-after($reportingData/partyRoles/transferor,'#')">partyA</xsl:when>
<xsl:when test="$reportingData/partyRoles/otherRemainingParty[$rcp = substring-after(., '#')]">partyB</xsl:when>
</xsl:choose>
</xsl:when>
<xsl:otherwise>
<xsl:choose>
<xsl:when test="$rcp = $reportingData/partyRoles/remainingParty">partyB</xsl:when>
<xsl:when test="$rcp = $reportingData/partyRoles/transferor">partyA</xsl:when>
<xsl:when test="$reportingData/partyRoles/otherRemainingParty[$rcp = .]">partyB</xsl:when>
</xsl:choose>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template name="outputCommonReportingFields">
<xsl:param name="reportingData"/>
<xsl:variable name="NewNovated"  select="$reportingData/swNewNovatedTradeReportingDetails"/>
<xsl:variable name="Novated"     select="$reportingData/swNovatedTradeReportingDetails"/>
<xsl:variable name="NovationFee" select="$reportingData/swNovationFeeTradeReportingDetails"/>
<xsl:variable name="dfReportingRegimeInfo" select="$reportingData/swReportingRegimeInformation[swJurisdiction=$dfJurisdiction]"/>
<xsl:variable name="dfNewNovated" select="$NewNovated/swReportingRegimeInformation[swJurisdiction=$dfJurisdiction]"/>
<xsl:variable name="dfNovated" select="$Novated/swReportingRegimeInformation[swJurisdiction=$dfJurisdiction]"/>
<xsl:variable name="dfNovationFee" select="$NovationFee/swReportingRegimeInformation[swJurisdiction=$dfJurisdiction]"/>
<xsl:variable name="jfsaReportingRegimeInfo" select="$reportingData/swReportingRegimeInformation[swJurisdiction=$jfsaJurisdiction]"/>
<xsl:variable name="jfsaNewNovated" select="$NewNovated/swReportingRegimeInformation[swJurisdiction=$jfsaJurisdiction]"/>
<xsl:variable name="jfsaNovated" select="$Novated/swReportingRegimeInformation[swJurisdiction=$jfsaJurisdiction]"/>
<xsl:variable name="esmaReportingRegimeInfo" select="$reportingData/swReportingRegimeInformation[swJurisdiction=$esmaJurisdiction]"/>
<xsl:variable name="esmaNewNovated" select="$NewNovated/swReportingRegimeInformation[swJurisdiction=$esmaJurisdiction]"/>
<xsl:variable name="esmaNovated" select="$Novated/swReportingRegimeInformation[swJurisdiction=$esmaJurisdiction]"/>
<xsl:variable name="hkmaReportingRegimeInfo" select="$reportingData/swReportingRegimeInformation[swJurisdiction=$hkmaJurisdiction]"/>
<xsl:variable name="hkmaNewNovated" select="$NewNovated/swReportingRegimeInformation[swJurisdiction=$hkmaJurisdiction]"/>
<xsl:variable name="hkmaNovated" select="$Novated/swReportingRegimeInformation[swJurisdiction=$hkmaJurisdiction]"/>
<xsl:variable name="caReportingRegimeInfo" select="$reportingData/swReportingRegimeInformation[swJurisdiction=$caJurisdiction]"/>
<xsl:variable name="caNewNovated" select="$NewNovated/swReportingRegimeInformation[swJurisdiction=$caJurisdiction]"/>
<xsl:variable name="caNovated" select="$Novated/swReportingRegimeInformation[swJurisdiction=$caJurisdiction]"/>
<xsl:variable name="caNovationFee" select="$NovationFee/swReportingRegimeInformation[swJurisdiction=$caJurisdiction]"/>
<xsl:variable name="seReportingRegimeInfo" select="$reportingData/swReportingRegimeInformation[swJurisdiction=$seJurisdiction]"/>
<xsl:variable name="seNewNovated" select="$NewNovated/swReportingRegimeInformation[swJurisdiction=$seJurisdiction]"/>
<xsl:variable name="seNovated" select="$Novated/swReportingRegimeInformation[swJurisdiction=$seJurisdiction]"/>
<xsl:variable name="seNovationFee" select="$NovationFee/swReportingRegimeInformation[swJurisdiction=$seJurisdiction]"/>
<xsl:variable name="miReportingRegimeInfo" select="$reportingData/swReportingRegimeInformation[swJurisdiction=$miJurisdiction]"/>
<xsl:variable name="miNewNovated" select="$NewNovated/swReportingRegimeInformation[swJurisdiction=$miJurisdiction]"/>
<xsl:variable name="miNovated" select="$Novated/swReportingRegimeInformation[swJurisdiction=$miJurisdiction]"/>
<xsl:variable name="asicReportingRegimeInfo" select="$reportingData/swReportingRegimeInformation[swJurisdiction=$asicJurisdiction]"/>
<xsl:variable name="asicNewNovated" select="$NewNovated/swReportingRegimeInformation[swJurisdiction=$asicJurisdiction]"/>
<xsl:variable name="asicNovated" select="$Novated/swReportingRegimeInformation[swJurisdiction=$asicJurisdiction]"/>
<xsl:variable name="masReportingRegimeInfo" select="$reportingData/swReportingRegimeInformation[swJurisdiction=$masJurisdiction]"/>
<xsl:variable name="masNewNovated" select="$NewNovated/swReportingRegimeInformation[swJurisdiction=$masJurisdiction]"/>
<xsl:variable name="masNovated" select="$Novated/swReportingRegimeInformation[swJurisdiction=$masJurisdiction]"/>
<xsl:variable name="fcaReportingRegimeInfo" select="$reportingData/swReportingRegimeInformation[swJurisdiction=$fcaJurisdiction]"/>
<xsl:variable name="fcaNewNovated" select="$NewNovated/swReportingRegimeInformation[swJurisdiction=$fcaJurisdiction]"/>
<xsl:variable name="fcaNovated" select="$Novated/swReportingRegimeInformation[swJurisdiction=$fcaJurisdiction]"/>
<xsl:variable name="BilateralInfoA" select="$reportingData/swBilateralPartyTradeInformation[swPartyReference/@href='partyA']"/>
<xsl:variable name="BilateralInfoB" select="$reportingData/swBilateralPartyTradeInformation[swPartyReference/@href='partyB']"/>
<xsl:call-template name="tx:DFData">
<xsl:with-param name="ExecutionType"                select="$reportingData/swExecutionType"/>
<xsl:with-param name="PriceNotationType"            select="$reportingData/swPriceNotation/swUnit"/>
<xsl:with-param name="PriceNotationValue"           select="$reportingData/swPriceNotation/swAmount"/>
<xsl:with-param name="AdditionalPriceNotationType"  select="$reportingData/swAdditionalPriceNotation/swUnit"/>
<xsl:with-param name="AdditionalPriceNotationValue" select="$reportingData/swAdditionalPriceNotation/swAmount"/>
<xsl:with-param name="ExecTraderSideAID" select="$BilateralInfoA/swPartyExtension/swReferencedPerson[@id=$BilateralInfoA/swRelatedPerson[swRole='Trader']/swPersonReference/@href]/swPersonId"/>
<xsl:with-param name="SalesTraderSideAID" select="$BilateralInfoA/swPartyExtension/swReferencedPerson[@id=$BilateralInfoA/swRelatedPerson[swRole='Sales']/swPersonReference/@href]/swPersonId"/>
<xsl:with-param name="DeskLocationSideAID" select="$BilateralInfoA/swPartyExtension/swBusinessUnit[@id=$BilateralInfoA/swRelatedBusinessUnit[swRole='Trader']/swBusinessUnitReference/@href]/swBusinessUnitId"/>
<xsl:with-param name="ArrBrokerLocationSideAIDPrefix" select="$reportingData/arrangingBroker1prefix"/>
<xsl:with-param name="ArrBrokerLocationSideAID" select="$reportingData/arrangingBroker1"/>
<xsl:with-param name="BranchLocationSideAIDPrefix" select="$reportingData/branch1prefix"/>
<xsl:with-param name="BranchLocationSideAID" select="$reportingData/branch1"/>
<xsl:with-param name="IndirectCptySideAIDPrefix" select="$reportingData/indirCpty1prefix"/>
<xsl:with-param name="IndirectCptySideAID" select="$reportingData/indirCpty1"/>
<xsl:with-param name="ExecTraderSideBID" select="$BilateralInfoB/swPartyExtension/swReferencedPerson[@id=$BilateralInfoB/swRelatedPerson[swRole='Trader']/swPersonReference/@href]/swPersonId"/>
<xsl:with-param name="SalesTraderSideBID" select="$BilateralInfoB/swPartyExtension/swReferencedPerson[@id=$BilateralInfoB/swRelatedPerson[swRole='Sales']/swPersonReference/@href]/swPersonId"/>
<xsl:with-param name="DeskLocationSideBID" select="$BilateralInfoB/swPartyExtension/swBusinessUnit[@id=$BilateralInfoB/swRelatedBusinessUnit[swRole='Trader']/swBusinessUnitReference/@href]/swBusinessUnitId"/>
<xsl:with-param name="ArrBrokerLocationSideBIDPrefix" select="$reportingData/arrangingBroker2prefix"/>
<xsl:with-param name="ArrBrokerLocationSideBID" select="$reportingData/arrangingBroker2"/>
<xsl:with-param name="BranchLocationSideBIDPrefix" select="$reportingData/branch2prefix"/>
<xsl:with-param name="BranchLocationSideBID" select="$reportingData/branch2"/>
<xsl:with-param name="IndirectCptySideBIDPrefix" select="$reportingData/indirCpty2prefix"/>
<xsl:with-param name="IndirectCptySideBID" select="$reportingData/indirCpty2"/>
<xsl:with-param name="PriceNotation">
<xsl:variable name="PriceNotation" select="$reportingData/swPriceNotation"/>
<xsl:for-each select="$PriceNotation">
<xsl:call-template name="tx:PriceNotation">
<xsl:with-param name="PriceNotationType">
<xsl:value-of select="swUnit"/>
</xsl:with-param>
<xsl:with-param name="PriceNotationValue">
<xsl:value-of select="swAmount"/>
</xsl:with-param>
</xsl:call-template>
</xsl:for-each>
</xsl:with-param>
<xsl:with-param name="AdditionalPriceNotation">
<xsl:variable name="AdditionalPriceNotation" select="$reportingData/swAdditionalPriceNotation"/>
<xsl:for-each select="$AdditionalPriceNotation">
<xsl:call-template name="tx:AdditionalPriceNotation">
<xsl:with-param name="AdditionalPriceNotationType">
<xsl:value-of select="swUnit"/>
</xsl:with-param>
<xsl:with-param name="AdditionalPriceNotationValue">
<xsl:value-of select="swAmount"/>
</xsl:with-param>
</xsl:call-template>
</xsl:for-each>
</xsl:with-param>
<xsl:with-param name="DFDataPresent" select="boolean($dfReportingRegimeInfo)"/>
<xsl:with-param name="DFRegulatorType" select="$dfReportingRegimeInfo/swSupervisoryBodyCategory"/>
<xsl:with-param name="Route1Destination">
<xsl:choose>
<xsl:when test="$dfReportingRegimeInfo/swReportTo/swRoute/swDestination">
<xsl:apply-templates select="$dfReportingRegimeInfo/swReportTo/swRoute/swDestination"/>
</xsl:when>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="Route1Intermediary">
<xsl:choose>
<xsl:when test="$dfReportingRegimeInfo/swReportTo/swRoute/swIntermediary">
<xsl:apply-templates select="$dfReportingRegimeInfo/swReportTo/swRoute/swIntermediary"/>
</xsl:when>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="USINamespace"              select="$dfReportingRegimeInfo/swUniqueTransactionId/swIssuer"/>
<xsl:with-param name="IntentToBlankUSINamespace" select="boolean($dfReportingRegimeInfo/swUniqueTransactionId/swIssuer[normalize-space(.) = ''])"/>
<xsl:with-param name="USINamespacePrefix">
<xsl:variable name="issuerPrefix" select="$dfReportingRegimeInfo/swUniqueTransactionId/swIssuer/@issuerIdScheme"/>
<xsl:choose>
<xsl:when test="string($issuerPrefix)='http://www.fpml.org/coding-scheme/external/cftc/issuer-identifier'">CFTC</xsl:when>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="USI"                 select="$dfReportingRegimeInfo/swUniqueTransactionId/swTradeId"/>
<xsl:with-param name="IntentToBlankUSI"    select="boolean($dfReportingRegimeInfo/swUniqueTransactionId/swTradeId[normalize-space(.) = ''])"/>
<xsl:with-param name="GlobalUTI"              select="$reportingData/swUniqueTransactionId/swTradeId"/>
<xsl:with-param name="IntentToBlankGlobalUTI" select="boolean($reportingData/swUniqueTransactionId/swTradeId[normalize-space(.) = ''])"/>
<xsl:with-param name="ObligatoryReporting" select="$dfReportingRegimeInfo/swObligatoryReporting"/>
<xsl:with-param name="SecondaryAssetClass" select="$reportingData/swReportableProduct/swSecondaryAssetClass"/>
<xsl:with-param name="ISIN" select="$reportingData/swReportableProduct/swProductId[@productIdScheme='http://www.fpml.org/coding-scheme/external/instrument-id-ISIN']"/>
<xsl:with-param name="CFI" select="$reportingData/swReportableProduct/swProductId[@productIdScheme='http://www.fpml.org/coding-scheme/external/product-classification/iso10962']"/>
<xsl:with-param name="FullName" select="$reportingData/swReportableProduct/swProductFullName"/>
<xsl:with-param name="OrderDirectionA">
<xsl:choose>
<xsl:when test="$reportingData/swBuyerPartyReference/@href = $partyA">Buyer</xsl:when>
<xsl:when test="$reportingData/swSellerPartyReference/@href = $partyA">Seller</xsl:when>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="OrderDirectionB">
<xsl:choose>
<xsl:when test="$reportingData/swBuyerPartyReference/@href = $partyB">Buyer</xsl:when>
<xsl:when test="$reportingData/swSellerPartyReference/@href = $partyB">Seller</xsl:when>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="ReportingCounterparty">
<xsl:variable name="swReportingCounterpartyReference" select="$dfReportingRegimeInfo/swReportingCounterpartyReference/@href"/>
<xsl:choose>
<xsl:when test="$reportingData/productType='Offline Trade Credit'">
<xsl:choose>
<xsl:when test="$swReportingCounterpartyReference = $reportingData/partyRoles/transferor">partyA</xsl:when>
<xsl:when test="$swReportingCounterpartyReference = $reportingData/partyRoles/remainingParty">partyB</xsl:when>
</xsl:choose>
</xsl:when>
<xsl:when test="$reportingData/productType='Generic Product'">
<xsl:value-of select="string($swReportingCounterpartyReference)"/>
</xsl:when>
<xsl:otherwise>
<xsl:variable name="rcpHref">
<xsl:choose>
<xsl:when test="/SWDML/@version = '3-0' or /SWDML/@version = '3-1'">
<xsl:value-of select="substring-after($swReportingCounterpartyReference,'#')"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="string($swReportingCounterpartyReference)"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:choose>
<xsl:when test="string-length($reportingData/partyRoles/transferor)&gt; 0">
<xsl:choose>
<xsl:when test="/SWDML/@version = '3-0' or /SWDML/@version = '3-1'">
<xsl:choose>
<xsl:when test="$swReportingCounterpartyReference = substring-after($reportingData/partyRoles/remainingParty,'#')">partyB</xsl:when>
<xsl:when test="$swReportingCounterpartyReference = substring-after($reportingData/partyRoles/transferor,'#')">partyA</xsl:when>
<xsl:when test="$swReportingCounterpartyReference = substring-after($reportingData/partyRoles/transferee,'#')">partyC</xsl:when>
<xsl:when test="$reportingData/partyRoles/otherRemainingParty and ($swReportingCounterpartyReference = substring-after($reportingData/partyRoles/otherRemainingParty,'#'))">partyB</xsl:when>
</xsl:choose>
</xsl:when>
<xsl:otherwise>
<xsl:choose>
<xsl:when test="$swReportingCounterpartyReference = $reportingData/partyRoles/remainingParty">partyB</xsl:when>
<xsl:when test="$swReportingCounterpartyReference = $reportingData/partyRoles/transferor">partyA</xsl:when>
<xsl:when test="$swReportingCounterpartyReference = $reportingData/partyRoles/transferee">partyC</xsl:when>
<xsl:when test="$reportingData/partyRoles/otherRemainingParty and ($swReportingCounterpartyReference = $reportingData/partyRoles/otherRemainingParty)">partyB</xsl:when>
</xsl:choose>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$rcpHref = ''"/>
<xsl:when test="$rcpHref = $partyA">partyA</xsl:when>
<xsl:when test="$rcpHref = $partyB">partyB</xsl:when>
<xsl:when test="$rcpHref = $partyC">partyC</xsl:when>
<xsl:when test="string-length($reportingData/partyRoles/primeBrokerA) &gt; 0 and $rcpHref = $partyC">partyPB</xsl:when>
<xsl:when test="string-length($reportingData/partyRoles/primeBrokerB) &gt; 0 and $rcpHref = $partyD">partyPB</xsl:when>
</xsl:choose>
</xsl:otherwise>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="DFClearingMandatory"                    select="$dfReportingRegimeInfo/swMandatoryClearingIndicator"/>
<xsl:with-param name="NewNovatedPriceNotationType"            select="$dfNewNovated/swPriceNotation/swUnit"/>
<xsl:with-param name="NewNovatedPriceNotationValue"           select="$dfNewNovated/swPriceNotation/swAmount"/>
<xsl:with-param name="NewNovatedAdditionalPriceNotationType"  select="$dfNewNovated/swAdditionalPriceNotation/swUnit"/>
<xsl:with-param name="NewNovatedAdditionalPriceNotationValue" select="$dfNewNovated/swAdditionalPriceNotation/swAmount"/>
<xsl:with-param name="NewNovatedDFDataPresent"                select="boolean($dfNewNovated)"/>
<xsl:with-param name="NewNovatedDFRegulatorType"              select="$dfNewNovated/swSupervisoryBodyCategory"/>
<xsl:with-param name="NewNovatedRoute1Destination">
<xsl:choose>
<xsl:when test="$dfNewNovated/swReportTo/swRoute/swDestination">
<xsl:apply-templates select="$dfNewNovated/swReportTo/swRoute/swDestination"/>
</xsl:when>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="NewNovatedRoute1Intermediary">
<xsl:choose>
<xsl:when test="$dfNewNovated/swReportTo/swRoute/swIntermediary">
<xsl:apply-templates select="$dfNewNovated/swReportTo/swRoute/swIntermediary"/>
</xsl:when>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="NewNovatedUSINamespace" select="$dfNewNovated/swUniqueTransactionId/swIssuer"/>
<xsl:with-param name="NewNovatedUSINamespacePrefix">
<xsl:variable name="issuerPrefix" select="$dfNewNovated/swUniqueTransactionId/swIssuer/@issuerIdScheme"/>
<xsl:choose>
<xsl:when test="string($issuerPrefix)='http://www.fpml.org/coding-scheme/external/cftc/issuer-identifier'">CFTC</xsl:when>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="NewNovatedUSI"                 select="$dfNewNovated/swUniqueTransactionId/swTradeId"/>
<xsl:with-param name="NewNovatedGlobalUTI"           select="$NewNovated/swUniqueTransactionId/swTradeId"/>
<xsl:with-param name="NewNovatedObligatoryReporting" select="$dfNewNovated/swObligatoryReporting"/>
<xsl:with-param name="NewNovatedReportingCounterparty">
<xsl:variable name="reportingCounterpartyReference" select="$dfNewNovated/swReportingCounterpartyReference/@href"/>
<xsl:choose>
<xsl:when test="/SWDML/@version = '3-0' or /SWDML/@version = '3-1'">
<xsl:choose>
<xsl:when test="$reportingCounterpartyReference = substring-after($reportingData/partyRoles/remainingParty,'#')">partyB</xsl:when>
<xsl:when test="$reportingCounterpartyReference = substring-after($reportingData/partyRoles/transferee,'#')">partyA</xsl:when>
<xsl:when test="$reportingData/partyRoles/otherRemainingParty and ($reportingCounterpartyReference = substring-after($reportingData/partyRoles/otherRemainingParty,'#'))">partyB</xsl:when>
</xsl:choose>
</xsl:when>
<xsl:otherwise>
<xsl:choose>
<xsl:when test="$reportingCounterpartyReference = $reportingData/partyRoles/remainingParty">partyB</xsl:when>
<xsl:when test="$reportingCounterpartyReference = $reportingData/partyRoles/transferee">partyA</xsl:when>
<xsl:when test="$reportingData/partyRoles/otherRemainingParty and ($reportingCounterpartyReference = $reportingData/partyRoles/otherRemainingParty)">partyB</xsl:when>
</xsl:choose>
</xsl:otherwise>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="NewNovatedDFClearingMandatory"       select="$dfNewNovated/swMandatoryClearingIndicator"/>
<xsl:with-param name="NovatedPriceNotationType"            select="$dfNovated/swPriceNotation/swUnit"/>
<xsl:with-param name="NovatedPriceNotationValue"           select="$dfNovated/swPriceNotation/swAmount"/>
<xsl:with-param name="NovatedAdditionalPriceNotationType"  select="$dfNovated/swAdditionalPriceNotation/swUnit"/>
<xsl:with-param name="NovatedAdditionalPriceNotationValue" select="$dfNovated/swAdditionalPriceNotation/swAmount"/>
<xsl:with-param name="NovatedDFDataPresent"                select="boolean($dfNewNovated)"/>
<xsl:with-param name="NovatedDFRegulatorType"              select="$dfNovated/swSupervisoryBodyCategory"/>
<xsl:with-param name="NovatedUSINamespace"                 select="$dfNovated/swUniqueTransactionId/swIssuer"/>
<xsl:with-param name="NovatedUSINamespacePrefix">
<xsl:variable name="issuerPrefix" select="$dfNovated/swUniqueTransactionId/swIssuer/@issuerIdScheme"/>
<xsl:choose>
<xsl:when test="string($issuerPrefix)='http://www.fpml.org/coding-scheme/external/cftc/issuer-identifier'">CFTC</xsl:when>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="NovatedUSI"                 select="$dfNovated/swUniqueTransactionId/swTradeId"/>
<xsl:with-param name="NovatedObligatoryReporting" select="$dfNovated/swObligatoryReporting"/>
<xsl:with-param name="NovatedReportingCounterparty">
<xsl:choose>
<xsl:when test="/SWDML/@version = '3-0' or /SWDML/@version = '3-1'">
<xsl:choose>
<xsl:when test="$dfNovated/swReportingCounterpartyReference/@href = substring-after($reportingData/partyRoles/remainingParty,'#')">partyB</xsl:when>
<xsl:when test="$dfNovated/swReportingCounterpartyReference/@href = substring-after($reportingData/partyRoles/transferee,'#')">partyA</xsl:when>
<xsl:when test="$reportingData/partyRoles/otherRemainingParty and ($dfNovated/swReportingCounterpartyReference/@href = substring-after($reportingData/partyRoles/otherRemainingParty,'#'))">partyB</xsl:when>
</xsl:choose>
</xsl:when>
<xsl:otherwise>
<xsl:choose>
<xsl:when test="$dfNovated/swReportingCounterpartyReference/@href = $reportingData/partyRoles/remainingParty">partyB</xsl:when>
<xsl:when test="$dfNovated/swReportingCounterpartyReference/@href = $reportingData/partyRoles/transferee">partyA</xsl:when>
<xsl:when test="$reportingData/partyRoles/otherRemainingParty and ($dfNovated/swReportingCounterpartyReference/@href = $reportingData/partyRoles/otherRemainingParty)">partyB</xsl:when>
</xsl:choose>
</xsl:otherwise>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="NovatedDFClearingMandatory"              select="$dfNovated/swMandatoryClearingIndicator"/>
<xsl:with-param name="NovationFeePriceNotationType"            select="$dfNovationFee/swPriceNotation/swUnit"/>
<xsl:with-param name="NovationFeePriceNotationValue"           select="$dfNovationFee/swPriceNotation/swAmount"/>
<xsl:with-param name="NovationFeeAdditionalPriceNotationType"  select="$dfNovationFee/swAdditionalPriceNotation/swUnit"/>
<xsl:with-param name="NovationFeeAdditionalPriceNotationValue" select="$dfNovationFee/swAdditionalPriceNotation/swAmount"/>
<xsl:with-param name="NovationFeeDFDataPresent"                select="boolean($dfNovationFee)"/>
<xsl:with-param name="NovationFeeDFRegulatorType"              select="$dfNovationFee/swSupervisoryBodyCategory"/>
<xsl:with-param name="NovationFeeRoute1Destination">
<xsl:choose>
<xsl:when test="$dfNovationFee/swReportTo/swRoute/swDestination">
<xsl:apply-templates select="$dfNovationFee/swReportTo/swRoute/swDestination"/>
</xsl:when>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="NovationFeeRoute1Intermediary">
<xsl:choose>
<xsl:when test="$dfNovationFee/swReportTo/swRoute/swIntermediary">
<xsl:apply-templates select="$dfNovationFee/swReportTo/swRoute/swIntermediary"/>
</xsl:when>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="NovationFeeUSINamespace">
<xsl:choose>
<xsl:when test="$reportingData/productType = 'Offline Trade Credit'">
<xsl:value-of select="$reportingData/novationExecutionUniqueTransactionId/swIssuer"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$dfNovationFee/swUniqueTransactionId/swIssuer"/>
</xsl:otherwise>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="NovationFeeUSINamespacePrefix">
<xsl:variable name="issuerPrefix">
<xsl:choose>
<xsl:when test="$reportingData/productType = 'Offline Trade Credit'">
<xsl:value-of select="$reportingData/novationExecutionUniqueTransactionId/swIssuer/@issuerIdScheme"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$dfNovationFee/swUniqueTransactionId/swIssuer/@issuerIdScheme"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:choose>
<xsl:when test="string($issuerPrefix)='http://www.fpml.org/coding-scheme/external/cftc/issuer-identifier'">CFTC</xsl:when>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="NovationFeeUSI">
<xsl:choose>
<xsl:when test="$reportingData/productType = 'Offline Trade Credit'">
<xsl:value-of select="$reportingData/novationExecutionUniqueTransactionId/swTradeId"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$dfNovationFee/swUniqueTransactionId/swTradeId"/>
</xsl:otherwise>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="NovationFeeGlobalUTI" select="$NovationFee/swUniqueTransactionId/swTradeId"/>
<xsl:with-param name="NovationFeeObligatoryReporting" select="$dfNovationFee/swObligatoryReporting"/>
<xsl:with-param name="NovationFeeReportingCounterparty">
<xsl:choose>
<xsl:when test="/SWDML/@version = '3-0' or /SWDML/@version = '3-1'">
<xsl:choose>
<xsl:when test="$dfNovationFee/swReportingCounterpartyReference/@href = substring-after($reportingData/partyRoles/transferor,'#')">partyA</xsl:when>
<xsl:when test="$dfNovationFee/swReportingCounterpartyReference/@href = substring-after($reportingData/partyRoles/transferee,'#')">partyB</xsl:when>
</xsl:choose>
</xsl:when>
<xsl:otherwise>
<xsl:choose>
<xsl:when test="$dfNovationFee/swReportingCounterpartyReference/@href = $reportingData/partyRoles/transferor">partyA</xsl:when>
<xsl:when test="$dfNovationFee/swReportingCounterpartyReference/@href = $reportingData/partyRoles/transferee">partyB</xsl:when>
</xsl:choose>
</xsl:otherwise>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="NovationFeeDFClearingMandatory" select="$dfNovationFee/swMandatoryClearingIndicator"/>
</xsl:call-template>
<xsl:call-template name="tx:JFSAData">
<xsl:with-param name="JFSADataPresent" select="boolean($jfsaReportingRegimeInfo)"/>
<xsl:with-param name="JFSANewNovatedDataPresent"  select="boolean($jfsaNewNovated)"/>
<xsl:with-param name="JFSANovatedDataPresent"       select="boolean($jfsaNovated)"/>
<xsl:with-param name="JFSAUTINamespace" select="$jfsaReportingRegimeInfo/swUniqueTransactionId/swIssuer"/>
<xsl:with-param name="JFSAUTINamespacePrefix">
<xsl:variable name="issuerPrefix" select="$jfsaReportingRegimeInfo/swUniqueTransactionId/swIssuer/@issuerIdScheme"/>
<xsl:choose>
<xsl:when test="string($issuerPrefix)='http://www.fpml.org/coding-scheme/external/cftc/issuer-identifier'">CFTC</xsl:when>
<xsl:when test="string($issuerPrefix)='http://www.fpml.org/coding-scheme/external/dtcc/issuer-identifier'">DTCC</xsl:when>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="JFSAUTI"                 select="$jfsaReportingRegimeInfo/swUniqueTransactionId/swTradeId"/>
<xsl:with-param name="JFSAIntentToBlankUTINamespace" select="boolean($jfsaReportingRegimeInfo/swUniqueTransactionId/swIssuer[normalize-space(.) = ''])"/>
<xsl:with-param name="JFSAIntentToBlankUTI"    select="boolean($jfsaReportingRegimeInfo/swUniqueTransactionId/swTradeId[normalize-space(.) = ''])"/>
<xsl:with-param name="JFSANovatedUTINamespace"                 select="$jfsaNovated/swUniqueTransactionId/swIssuer"/>
<xsl:with-param name="JFSANovatedUTINamespacePrefix">
<xsl:variable name="issuerPrefix" select="$jfsaNovated/swUniqueTransactionId/swIssuer/@issuerIdScheme"/>
<xsl:choose>
<xsl:when test="string($issuerPrefix)='http://www.fpml.org/coding-scheme/external/cftc/issuer-identifier'">CFTC</xsl:when>
<xsl:when test="string($issuerPrefix)='http://www.fpml.org/coding-scheme/external/dtcc/issuer-identifier'">DTCC</xsl:when>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="JFSANovatedUTI"                 select="$jfsaNovated/swUniqueTransactionId/swTradeId"/>
<xsl:with-param name="JFSANewNovatedUTINamespace" select="$jfsaNewNovated/swUniqueTransactionId/swIssuer"/>
<xsl:with-param name="JFSANewNovatedUTINamespacePrefix">
<xsl:variable name="issuerPrefix" select="$dfNewNovated/swUniqueTransactionId/swIssuer/@issuerIdScheme"/>
<xsl:choose>
<xsl:when test="string($issuerPrefix)='http://www.fpml.org/coding-scheme/external/cftc/issuer-identifier'">CFTC</xsl:when>
<xsl:when test="string($issuerPrefix)='http://www.fpml.org/coding-scheme/external/dtcc/issuer-identifier'">DTCC</xsl:when>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="JFSANewNovatedUTI"                 select="$jfsaNewNovated/swUniqueTransactionId/swTradeId"/>
</xsl:call-template>
<xsl:call-template name="tx:ESMAData">
<xsl:with-param name="ESMADataPresent" select="boolean($esmaReportingRegimeInfo)"/>
<xsl:with-param name="ESMANewNovatedDataPresent"  select="boolean($esmaNewNovated)"/>
<xsl:with-param name="ESMANovatedDataPresent"       select="boolean($esmaNovated)"/>
<xsl:with-param name="ESMAUTINamespace" select="$esmaReportingRegimeInfo/swUniqueTransactionId/swIssuer"/>
<xsl:with-param name="ESMAUTINamespacePrefix">
<xsl:variable name="issuerPrefix" select="$esmaReportingRegimeInfo/swUniqueTransactionId/swIssuer/@issuerIdScheme"/>
<xsl:choose>
<xsl:when test="string($issuerPrefix)='http://www.fpml.org/coding-scheme/external/cftc/issuer-identifier'">CFTC</xsl:when>
<xsl:when test="string($issuerPrefix)='http://www.fpml.org/coding-scheme/external/dtcc/issuer-identifier'">DTCC</xsl:when>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="ESMAUTI"                 select="$esmaReportingRegimeInfo/swUniqueTransactionId/swTradeId"/>
<xsl:with-param name="ESMAIntentToBlankUTINamespace" select="boolean($esmaReportingRegimeInfo/swUniqueTransactionId/swIssuer[normalize-space(.) = ''])"/>
<xsl:with-param name="ESMAIntentToBlankUTI"    select="boolean($esmaReportingRegimeInfo/swUniqueTransactionId/swTradeId[normalize-space(.) = ''])"/>
<xsl:with-param name="ESMANovatedUTINamespace"                 select="$esmaNovated/swUniqueTransactionId/swIssuer"/>
<xsl:with-param name="ESMANovatedUTINamespacePrefix">
<xsl:variable name="issuerPrefix" select="$esmaNovated/swUniqueTransactionId/swIssuer/@issuerIdScheme"/>
<xsl:choose>
<xsl:when test="string($issuerPrefix)='http://www.fpml.org/coding-scheme/external/cftc/issuer-identifier'">CFTC</xsl:when>
<xsl:when test="string($issuerPrefix)='http://www.fpml.org/coding-scheme/external/dtcc/issuer-identifier'">DTCC</xsl:when>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="ESMANovatedUTI"                 select="$esmaNovated/swUniqueTransactionId/swTradeId"/>
<xsl:with-param name="ESMANewNovatedUTINamespace" select="$esmaNewNovated/swUniqueTransactionId/swIssuer"/>
<xsl:with-param name="ESMANewNovatedUTINamespacePrefix">
<xsl:variable name="issuerPrefix" select="$dfNewNovated/swUniqueTransactionId/swIssuer/@issuerIdScheme"/>
<xsl:choose>
<xsl:when test="string($issuerPrefix)='http://www.fpml.org/coding-scheme/external/cftc/issuer-identifier'">CFTC</xsl:when>
<xsl:when test="string($issuerPrefix)='http://www.fpml.org/coding-scheme/external/dtcc/issuer-identifier'">DTCC</xsl:when>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="ESMANewNovatedUTI"                 select="$esmaNewNovated/swUniqueTransactionId/swTradeId"/>
</xsl:call-template>
<xsl:call-template name="tx:HKMAData">
<xsl:with-param name="HKMADataPresent" select="boolean($hkmaReportingRegimeInfo)"/>
<xsl:with-param name="HKMANewNovatedDataPresent"  select="boolean($hkmaNewNovated)"/>
<xsl:with-param name="HKMANovatedDataPresent"       select="boolean($hkmaNovated)"/>
<xsl:with-param name="HKMAUTINamespace" select="$hkmaReportingRegimeInfo/swUniqueTransactionId/swIssuer"/>
<xsl:with-param name="HKMAUTINamespacePrefix">
<xsl:variable name="issuerPrefix" select="$hkmaReportingRegimeInfo/swUniqueTransactionId/swIssuer/@issuerIdScheme"/>
<xsl:choose>
<xsl:when test="string($issuerPrefix)='http://www.fpml.org/coding-scheme/external/cftc/issuer-identifier'">CFTC</xsl:when>
<xsl:when test="string($issuerPrefix)='http://www.fpml.org/coding-scheme/external/dtcc/issuer-identifier'">DTCC</xsl:when>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="HKMAUTI"                 select="$hkmaReportingRegimeInfo/swUniqueTransactionId/swTradeId"/>
<xsl:with-param name="HKMAIntentToBlankUTINamespace" select="boolean($hkmaReportingRegimeInfo/swUniqueTransactionId/swIssuer[normalize-space(.) = ''])"/>
<xsl:with-param name="HKMAIntentToBlankUTI"    select="boolean($hkmaReportingRegimeInfo/swUniqueTransactionId/swTradeId[normalize-space(.) = ''])"/>
<xsl:with-param name="HKMANovatedUTINamespace"                 select="$hkmaNovated/swUniqueTransactionId/swIssuer"/>
<xsl:with-param name="HKMANovatedUTINamespacePrefix">
<xsl:variable name="issuerPrefix" select="$hkmaNovated/swUniqueTransactionId/swIssuer/@issuerIdScheme"/>
<xsl:choose>
<xsl:when test="string($issuerPrefix)='http://www.fpml.org/coding-scheme/external/cftc/issuer-identifier'">CFTC</xsl:when>
<xsl:when test="string($issuerPrefix)='http://www.fpml.org/coding-scheme/external/dtcc/issuer-identifier'">DTCC</xsl:when>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="HKMANovatedUTI"                 select="$hkmaNovated/swUniqueTransactionId/swTradeId"/>
<xsl:with-param name="HKMANewNovatedUTINamespace" select="$hkmaNewNovated/swUniqueTransactionId/swIssuer"/>
<xsl:with-param name="HKMANewNovatedUTINamespacePrefix">
<xsl:variable name="issuerPrefix" select="$dfNewNovated/swUniqueTransactionId/swIssuer/@issuerIdScheme"/>
<xsl:choose>
<xsl:when test="string($issuerPrefix)='http://www.fpml.org/coding-scheme/external/cftc/issuer-identifier'">CFTC</xsl:when>
<xsl:when test="string($issuerPrefix)='http://www.fpml.org/coding-scheme/external/dtcc/issuer-identifier'">DTCC</xsl:when>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="HKMANewNovatedUTI"                 select="$hkmaNewNovated/swUniqueTransactionId/swTradeId"/>
</xsl:call-template>
<xsl:call-template name="tx:CAData">
<xsl:with-param name="CADataPresent" select="boolean($caReportingRegimeInfo)"/>
<xsl:with-param name="CAObligatoryReporting" select="$caReportingRegimeInfo/swObligatoryReporting"/>
<xsl:with-param name="CAReportableLocationsA">
<xsl:variable name="locs_count" select="count($caReportingRegimeInfo/swReportableLocations[translate(swPartyReference/@href, '#', '') = $partyA ])"/>
<xsl:variable name="loc_count" select="count($caReportingRegimeInfo/swReportableLocations[translate(swPartyReference/@href, '#', '') = $partyA ]/swReportableLocation)"/>
<xsl:choose>
<xsl:when test="$locs_count = 0">NONE</xsl:when>
<xsl:when test="$locs_count = 1 and $loc_count = 0">BLANK</xsl:when>
<xsl:otherwise>
<xsl:for-each select="$caReportingRegimeInfo/swReportableLocations[translate(swPartyReference/@href, '#', '') = $partyA ]/swReportableLocation">
<xsl:value-of select="current()"/>
<xsl:if test="position() != $loc_count">
<xsl:text>; </xsl:text>
</xsl:if>
</xsl:for-each>
</xsl:otherwise>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="CAReportableLocationsB">
<xsl:variable name="locs_count" select="count($caReportingRegimeInfo/swReportableLocations[translate(swPartyReference/@href, '#', '') = $partyB ])"/>
<xsl:variable name="loc_count" select="count($caReportingRegimeInfo/swReportableLocations[translate(swPartyReference/@href, '#', '') = $partyB ]/swReportableLocation)"/>
<xsl:choose>
<xsl:when test="$locs_count = 0">NONE</xsl:when>
<xsl:when test="$locs_count = 1 and $loc_count = 0">BLANK</xsl:when>
<xsl:otherwise>
<xsl:for-each select="$caReportingRegimeInfo/swReportableLocations[translate(swPartyReference/@href, '#', '') = $partyB ]/swReportableLocation">
<xsl:value-of select="current()"/>
<xsl:if test="position() != $loc_count">
<xsl:text>; </xsl:text>
</xsl:if>
</xsl:for-each>
</xsl:otherwise>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="CAReportableLocationsC">
<xsl:variable name="locs_count" select="count($caReportingRegimeInfo/swReportableLocations[translate(swPartyReference/@href, '#', '') = $partyC ])"/>
<xsl:variable name="loc_count" select="count($caReportingRegimeInfo/swReportableLocations[translate(swPartyReference/@href, '#', '') = $partyC ]/swReportableLocation)"/>
<xsl:choose>
<xsl:when test="$locs_count = 0">NONE</xsl:when>
<xsl:when test="$locs_count = 1 and $loc_count = 0">BLANK</xsl:when>
<xsl:otherwise>
<xsl:for-each select="$caReportingRegimeInfo/swReportableLocations[translate(swPartyReference/@href, '#', '') = $partyC ]/swReportableLocation">
<xsl:value-of select="current()"/>
<xsl:if test="position() != $loc_count">
<xsl:text>; </xsl:text>
</xsl:if>
</xsl:for-each>
</xsl:otherwise>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="CAReportableLocationsD">
<xsl:variable name="locs_count" select="count($caReportingRegimeInfo/swReportableLocations[translate(swPartyReference/@href, '#', '') = $partyD ])"/>
<xsl:variable name="loc_count" select="count($caReportingRegimeInfo/swReportableLocations[translate(swPartyReference/@href, '#', '') = $partyD ]/swReportableLocation)"/>
<xsl:choose>
<xsl:when test="$locs_count = 0">NONE</xsl:when>
<xsl:when test="$locs_count = 1 and $loc_count = 0">BLANK</xsl:when>
<xsl:otherwise>
<xsl:for-each select="$caReportingRegimeInfo/swReportableLocations[translate(swPartyReference/@href, '#', '') = $partyD ]/swReportableLocation">
<xsl:value-of select="current()"/>
<xsl:if test="position() != $loc_count">
<xsl:text>; </xsl:text>
</xsl:if>
</xsl:for-each>
</xsl:otherwise>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="CAReportingCounterparty">
<xsl:variable name="swReportingCounterpartyReference" select="$caReportingRegimeInfo/swReportingCounterpartyReference/@href"/>
<xsl:choose>
<xsl:when test="$reportingData/productType='Offline Trade Credit'">
<xsl:choose>
<xsl:when test="$swReportingCounterpartyReference = $reportingData/partyRoles/transferor">partyA</xsl:when>
<xsl:when test="$swReportingCounterpartyReference = $reportingData/partyRoles/remainingParty">partyB</xsl:when>
</xsl:choose>
</xsl:when>
<xsl:when test="$reportingData/productType='Generic Product'">
<xsl:value-of select="string($swReportingCounterpartyReference)"/>
</xsl:when>
<xsl:otherwise>
<xsl:variable name="rcpHref">
<xsl:choose>
<xsl:when test="/SWDML/@version = '3-0' or /SWDML/@version = '3-1'">
<xsl:value-of select="substring-after($swReportingCounterpartyReference,'#')"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="string($swReportingCounterpartyReference)"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:choose>
<xsl:when test="string-length($reportingData/partyRoles/transferor)&gt; 0">
<xsl:choose>
<xsl:when test="/SWDML/@version = '3-0' or /SWDML/@version = '3-1'">
<xsl:choose>
<xsl:when test="$swReportingCounterpartyReference = substring-after($reportingData/partyRoles/remainingParty,'#')">partyB</xsl:when>
<xsl:when test="$swReportingCounterpartyReference = substring-after($reportingData/partyRoles/transferor,'#')">partyA</xsl:when>
<xsl:when test="$swReportingCounterpartyReference = substring-after($reportingData/partyRoles/transferee,'#')">partyC</xsl:when>
<xsl:when test="$reportingData/partyRoles/otherRemainingParty and ($swReportingCounterpartyReference = substring-after($reportingData/partyRoles/otherRemainingParty,'#'))">partyB</xsl:when>
</xsl:choose>
</xsl:when>
<xsl:otherwise>
<xsl:choose>
<xsl:when test="$swReportingCounterpartyReference = $reportingData/partyRoles/remainingParty">partyB</xsl:when>
<xsl:when test="$swReportingCounterpartyReference = $reportingData/partyRoles/transferor">partyA</xsl:when>
<xsl:when test="$swReportingCounterpartyReference = $reportingData/partyRoles/transferee">partyC</xsl:when>
<xsl:when test="$reportingData/partyRoles/otherRemainingParty and ($swReportingCounterpartyReference = $reportingData/partyRoles/otherRemainingParty)">partyB</xsl:when>
</xsl:choose>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$rcpHref = ''"/>
<xsl:when test="$rcpHref = $partyA">partyA</xsl:when>
<xsl:when test="$rcpHref = $partyB">partyB</xsl:when>
<xsl:when test="$rcpHref = $partyC">partyC</xsl:when>
<xsl:when test="string-length($reportingData/partyRoles/primeBrokerA) &gt; 0 and $rcpHref = $partyC">partyPB</xsl:when>
<xsl:when test="string-length($reportingData/partyRoles/primeBrokerB) &gt; 0 and $rcpHref = $partyD">partyPB</xsl:when>
</xsl:choose>
</xsl:otherwise>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="NovationFeeCAPriceNotationType"            select="$caNovationFee/swPriceNotation/swUnit"/>
<xsl:with-param name="NovationFeeCAPriceNotationValue"           select="$caNovationFee/swPriceNotation/swAmount"/>
<xsl:with-param name="NovationFeeCAAdditionalPriceNotationType"  select="$caNovationFee/swAdditionalPriceNotation/swUnit"/>
<xsl:with-param name="NovationFeeCAAdditionalPriceNotationValue" select="$caNovationFee/swAdditionalPriceNotation/swAmount"/>
<xsl:with-param name="NovationFeeCADataPresent"                select="boolean($caNovationFee)"/>
<xsl:with-param name="NovationFeeCARegulatorType"              select="$caNovationFee/swSupervisoryBodyCategory"/>
<xsl:with-param name="NovationFeeCARoute1Destination">
<xsl:choose>
<xsl:when test="$caNovationFee/swReportTo/swRoute/swDestination">
<xsl:apply-templates select="$caNovationFee/swReportTo/swRoute/swDestination"/>
</xsl:when>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="NovationFeeCARoute1Intermediary">
<xsl:choose>
<xsl:when test="$caNovationFee/swReportTo/swRoute/swIntermediary">
<xsl:apply-templates select="$caNovationFee/swReportTo/swRoute/swIntermediary"/>
</xsl:when>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="NovationFeeCAUTINamespace">
<xsl:choose>
<xsl:when test="$reportingData/productType = 'Offline Trade Credit'">
<xsl:value-of select="$reportingData/novationExecutionUniqueTransactionId/swIssuer"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$caNovationFee/swUniqueTransactionId/swIssuer"/>
</xsl:otherwise>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="NovationFeeCAUTINamespacePrefix">
<xsl:variable name="issuerPrefix">
<xsl:choose>
<xsl:when test="$reportingData/productType = 'Offline Trade Credit'">
<xsl:value-of select="$reportingData/novationExecutionUniqueTransactionId/swIssuer/@issuerIdScheme"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$caNovationFee/swUniqueTransactionId/swIssuer/@issuerIdScheme"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:choose>
<xsl:when test="string($issuerPrefix)='http://www.fpml.org/coding-scheme/external/cftc/issuer-identifier'">CFTC</xsl:when>
<xsl:when test="string($issuerPrefix)='http://www.fpml.org/coding-scheme/external/dtcc/issuer-identifier'">DTCC</xsl:when>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="NovationFeeCAUTI">
<xsl:choose>
<xsl:when test="$reportingData/productType = 'Offline Trade Credit'">
<xsl:value-of select="$reportingData/novationExecutionUniqueTransactionId/swTradeId"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$caNovationFee/swUniqueTransactionId/swTradeId"/>
</xsl:otherwise>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="NovationFeeCAObligatoryReporting" select="$caNovationFee/swObligatoryReporting"/>
<xsl:with-param name="NovationFeeCAReportingCounterparty">
<xsl:choose>
<xsl:when test="/SWDML/@version = '3-0' or /SWDML/@version = '3-1'">
<xsl:choose>
<xsl:when test="$caNovationFee/swReportingCounterpartyReference/@href = substring-after($reportingData/partyRoles/transferor,'#')">partyA</xsl:when>
<xsl:when test="$caNovationFee/swReportingCounterpartyReference/@href = substring-after($reportingData/partyRoles/transferee,'#')">partyB</xsl:when>
</xsl:choose>
</xsl:when>
<xsl:otherwise>
<xsl:choose>
<xsl:when test="$caNovationFee/swReportingCounterpartyReference/@href = $reportingData/partyRoles/transferor">partyA</xsl:when>
<xsl:when test="$caNovationFee/swReportingCounterpartyReference/@href = $reportingData/partyRoles/transferee">partyB</xsl:when>
</xsl:choose>
</xsl:otherwise>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="NovationFeeCAClearingMandatory" select="$caNovationFee/swMandatoryClearingIndicator"/>
<xsl:with-param name="NovationFeeCAReportableLocationsA">
<xsl:variable name="locs_count" select="count($caNovationFee/swReportableLocations[translate(swPartyReference/@href, '#', '') = $partyA ])"/>
<xsl:variable name="loc_count" select="count($caNovationFee/swReportableLocations[translate(swPartyReference/@href, '#', '') = $partyA ]/swReportableLocation)"/>
<xsl:choose>
<xsl:when test="$locs_count = 0">NONE</xsl:when>
<xsl:when test="$locs_count = 1 and $loc_count = 0">BLANK</xsl:when>
<xsl:otherwise>
<xsl:for-each select="$caNovationFee/swReportableLocations[translate(swPartyReference/@href, '#', '') = $partyA ]/swReportableLocation">
<xsl:value-of select="current()"/>
<xsl:if test="position() != $loc_count">
<xsl:text>; </xsl:text>
</xsl:if>
</xsl:for-each>
</xsl:otherwise>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="NovationFeeCAReportableLocationsB">
<xsl:variable name="locs_count" select="count($caNovationFee/swReportableLocations[translate(swPartyReference/@href, '#', '') = $partyB ])"/>
<xsl:variable name="loc_count" select="count($caNovationFee/swReportableLocations[translate(swPartyReference/@href, '#', '') = $partyB ]/swReportableLocation)"/>
<xsl:choose>
<xsl:when test="$locs_count = 0">NONE</xsl:when>
<xsl:when test="$locs_count = 1 and $loc_count = 0">BLANK</xsl:when>
<xsl:otherwise>
<xsl:for-each select="$caNovationFee/swReportableLocations[translate(swPartyReference/@href, '#', '') = $partyB ]/swReportableLocation">
<xsl:value-of select="current()"/>
<xsl:if test="position() != $loc_count">
<xsl:text>; </xsl:text>
</xsl:if>
</xsl:for-each>
</xsl:otherwise>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="NovationFeeCAReportableLocationsC">
<xsl:variable name="locs_count" select="count($caNovationFee/swReportableLocations[translate(swPartyReference/@href, '#', '') = $partyC ])"/>
<xsl:variable name="loc_count" select="count($caNovationFee/swReportableLocations[translate(swPartyReference/@href, '#', '') = $partyC ]/swReportableLocation)"/>
<xsl:choose>
<xsl:when test="$locs_count = 0">NONE</xsl:when>
<xsl:when test="$locs_count = 1 and $loc_count = 0">BLANK</xsl:when>
<xsl:otherwise>
<xsl:for-each select="$caNovationFee/swReportableLocations[translate(swPartyReference/@href, '#', '') = $partyC ]/swReportableLocation">
<xsl:value-of select="current()"/>
<xsl:if test="position() != $loc_count">
<xsl:text>; </xsl:text>
</xsl:if>
</xsl:for-each>
</xsl:otherwise>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="NovationFeeCAReportableLocationsD">
<xsl:variable name="locs_count" select="count($caNovationFee/swReportableLocations[translate(swPartyReference/@href, '#', '') = $partyD ])"/>
<xsl:variable name="loc_count" select="count($caNovationFee/swReportableLocations[translate(swPartyReference/@href, '#', '') = $partyD ]/swReportableLocation)"/>
<xsl:choose>
<xsl:when test="$locs_count = 0">NONE</xsl:when>
<xsl:when test="$locs_count = 1 and $loc_count = 0">BLANK</xsl:when>
<xsl:otherwise>
<xsl:for-each select="$caNovationFee/swReportableLocations[translate(swPartyReference/@href, '#', '') = $partyD ]/swReportableLocation">
<xsl:value-of select="current()"/>
<xsl:if test="position() != $loc_count">
<xsl:text>; </xsl:text>
</xsl:if>
</xsl:for-each>
</xsl:otherwise>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="CANewNovatedDataPresent"  select="boolean($caNewNovated)"/>
<xsl:with-param name="CANovatedDataPresent"       select="boolean($caNovated)"/>
<xsl:with-param name="CAUTINamespace" select="$caReportingRegimeInfo/swUniqueTransactionId/swIssuer"/>
<xsl:with-param name="CAUTINamespacePrefix">
<xsl:variable name="issuerPrefix" select="$caReportingRegimeInfo/swUniqueTransactionId/swIssuer/@issuerIdScheme"/>
<xsl:choose>
<xsl:when test="string($issuerPrefix)='http://www.fpml.org/coding-scheme/external/cftc/issuer-identifier'">CFTC</xsl:when>
<xsl:when test="string($issuerPrefix)='http://www.fpml.org/coding-scheme/external/dtcc/issuer-identifier'">DTCC</xsl:when>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="CAUTI"                 select="$caReportingRegimeInfo/swUniqueTransactionId/swTradeId"/>
<xsl:with-param name="CAIntentToBlankUTINamespace" select="boolean($caReportingRegimeInfo/swUniqueTransactionId/swIssuer[normalize-space(.) = ''])"/>
<xsl:with-param name="CAIntentToBlankUTI"    select="boolean($caReportingRegimeInfo/swUniqueTransactionId/swTradeId[normalize-space(.) = ''])"/>
<xsl:with-param name="CANovatedUTINamespace"                 select="$caNovated/swUniqueTransactionId/swIssuer"/>
<xsl:with-param name="CANovatedUTINamespacePrefix">
<xsl:variable name="issuerPrefix" select="$caNovated/swUniqueTransactionId/swIssuer/@issuerIdScheme"/>
<xsl:choose>
<xsl:when test="string($issuerPrefix)='http://www.fpml.org/coding-scheme/external/cftc/issuer-identifier'">CFTC</xsl:when>
<xsl:when test="string($issuerPrefix)='http://www.fpml.org/coding-scheme/external/dtcc/issuer-identifier'">DTCC</xsl:when>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="CANovatedUTI"                 select="$caNovated/swUniqueTransactionId/swTradeId"/>
<xsl:with-param name="CANewNovatedUTINamespace" select="$caNewNovated/swUniqueTransactionId/swIssuer"/>
<xsl:with-param name="CANewNovatedUTINamespacePrefix">
<xsl:variable name="issuerPrefix" select="$dfNewNovated/swUniqueTransactionId/swIssuer/@issuerIdScheme"/>
<xsl:choose>
<xsl:when test="string($issuerPrefix)='http://www.fpml.org/coding-scheme/external/cftc/issuer-identifier'">CFTC</xsl:when>
<xsl:when test="string($issuerPrefix)='http://www.fpml.org/coding-scheme/external/dtcc/issuer-identifier'">DTCC</xsl:when>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="CANewNovatedUTI"                 select="$caNewNovated/swUniqueTransactionId/swTradeId"/>
</xsl:call-template>
<xsl:call-template name="tx:SEData">
<xsl:with-param name="SEDataPresent" select="boolean($seReportingRegimeInfo)"/>
<xsl:with-param name="SERegulatorType" select="$seReportingRegimeInfo/swSupervisoryBodyCategory"/>
<xsl:with-param name="SERoute1Destination">
<xsl:choose>
<xsl:when test="$seReportingRegimeInfo/swReportTo/swRoute/swDestination">
<xsl:apply-templates select="$seReportingRegimeInfo/swReportTo/swRoute/swDestination"/>
</xsl:when>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="SERoute1Intermediary">
<xsl:choose>
<xsl:when test="$seReportingRegimeInfo/swReportTo/swRoute/swIntermediary">
<xsl:apply-templates select="$seReportingRegimeInfo/swReportTo/swRoute/swIntermediary"/>
</xsl:when>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="SEUTINamespace" select="$seReportingRegimeInfo/swUniqueTransactionId/swIssuer"/>
<xsl:with-param name="SEIntentToBlankUTINamespace" select="boolean($seReportingRegimeInfo/swUniqueTransactionId/swIssuer[normalize-space(.) = ''])"/>
<xsl:with-param name="SEUTINamespacePrefix">
<xsl:variable name="issuerPrefix" select="$seReportingRegimeInfo/swUniqueTransactionId/swIssuer/@issuerIdScheme"/>
<xsl:choose>
<xsl:when test="string($issuerPrefix)='http://www.fpml.org/coding-scheme/external/cftc/issuer-identifier'">CFTC</xsl:when>
<xsl:when test="string($issuerPrefix)='http://www.fpml.org/coding-scheme/external/dtcc/issuer-identifier'">DTCC</xsl:when>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="SEUTI" select="$seReportingRegimeInfo/swUniqueTransactionId/swTradeId"/>
<xsl:with-param name="SEIntentToBlankUTI"    select="boolean($seReportingRegimeInfo/swUniqueTransactionId/swTradeId[normalize-space(.) = ''])"/>
<xsl:with-param name="SEObligatoryReporting" select="$seReportingRegimeInfo/swObligatoryReporting"/>
<xsl:with-param name="SEReportingCounterparty">
<xsl:variable name="swReportingCounterpartyReference" select="$seReportingRegimeInfo/swReportingCounterpartyReference/@href"/>
<xsl:choose>
<xsl:when test="$reportingData/productType='Offline Trade Credit'">
<xsl:choose>
<xsl:when test="$swReportingCounterpartyReference = $reportingData/partyRoles/transferor">partyA</xsl:when>
<xsl:when test="$swReportingCounterpartyReference = $reportingData/partyRoles/remainingParty">partyB</xsl:when>
</xsl:choose>
</xsl:when>
<xsl:when test="$reportingData/productType='Generic Product'">
<xsl:value-of select="string($swReportingCounterpartyReference)"/>
</xsl:when>
<xsl:otherwise>
<xsl:variable name="rcpHref">
<xsl:choose>
<xsl:when test="/SWDML/@version = '3-0' or /SWDML/@version = '3-1'">
<xsl:value-of select="substring-after($swReportingCounterpartyReference,'#')"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="string($swReportingCounterpartyReference)"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:choose>
<xsl:when test="string-length($reportingData/partyRoles/transferor)&gt; 0">
<xsl:choose>
<xsl:when test="/SWDML/@version = '3-0' or /SWDML/@version = '3-1'">
<xsl:choose>
<xsl:when test="$swReportingCounterpartyReference = substring-after($reportingData/partyRoles/remainingParty,'#')">partyB</xsl:when>
<xsl:when test="$swReportingCounterpartyReference = substring-after($reportingData/partyRoles/transferor,'#')">partyA</xsl:when>
<xsl:when test="$swReportingCounterpartyReference = substring-after($reportingData/partyRoles/transferee,'#')">partyC</xsl:when>
<xsl:when test="$reportingData/partyRoles/otherRemainingParty and ($swReportingCounterpartyReference = substring-after($reportingData/partyRoles/otherRemainingParty,'#'))">partyB</xsl:when>
</xsl:choose>
</xsl:when>
<xsl:otherwise>
<xsl:choose>
<xsl:when test="$swReportingCounterpartyReference = $reportingData/partyRoles/remainingParty">partyB</xsl:when>
<xsl:when test="$swReportingCounterpartyReference = $reportingData/partyRoles/transferor">partyA</xsl:when>
<xsl:when test="$swReportingCounterpartyReference = $reportingData/partyRoles/transferee">partyC</xsl:when>
<xsl:when test="$reportingData/partyRoles/otherRemainingParty and ($swReportingCounterpartyReference = $reportingData/partyRoles/otherRemainingParty)">partyB</xsl:when>
</xsl:choose>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$rcpHref = ''"/>
<xsl:when test="$rcpHref = $partyA">partyA</xsl:when>
<xsl:when test="$rcpHref = $partyB">partyB</xsl:when>
<xsl:when test="$rcpHref = $partyC">partyC</xsl:when>
<xsl:when test="string-length($reportingData/partyRoles/primeBrokerA) &gt; 0 and $rcpHref = $partyC">partyPB</xsl:when>
<xsl:when test="string-length($reportingData/partyRoles/primeBrokerB) &gt; 0 and $rcpHref = $partyD">partyPB</xsl:when>
</xsl:choose>
</xsl:otherwise>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="NewNovatedSEDataPresent"                select="boolean($seNewNovated)"/>
<xsl:with-param name="NewNovatedSERegulatorType"              select="$seNewNovated/swSupervisoryBodyCategory"/>
<xsl:with-param name="NewNovatedSERoute1Destination">
<xsl:choose>
<xsl:when test="$seNewNovated/swReportTo/swRoute/swDestination">
<xsl:apply-templates select="$seNewNovated/swReportTo/swRoute/swDestination"/>
</xsl:when>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="NewNovatedSERoute1Intermediary">
<xsl:choose>
<xsl:when test="$seNewNovated/swReportTo/swRoute/swIntermediary">
<xsl:apply-templates select="$seNewNovated/swReportTo/swRoute/swIntermediary"/>
</xsl:when>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="NewNovatedSEUTINamespace" select="$seNewNovated/swUniqueTransactionId/swIssuer"/>
<xsl:with-param name="NewNovatedSEUTINamespacePrefix">
<xsl:variable name="issuerPrefix" select="$seNewNovated/swUniqueTransactionId/swIssuer/@issuerIdScheme"/>
<xsl:choose>
<xsl:when test="string($issuerPrefix)='http://www.fpml.org/coding-scheme/external/cftc/issuer-identifier'">CFTC</xsl:when>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="NewNovatedSEUTI"                 select="$seNewNovated/swUniqueTransactionId/swTradeId"/>
<xsl:with-param name="NewNovatedSEObligatoryReporting" select="$seNewNovated/swObligatoryReporting"/>
<xsl:with-param name="NewNovatedSEReportingCounterparty">
<xsl:variable name="reportingCounterpartyReference" select="$seNewNovated/swReportingCounterpartyReference/@href"/>
<xsl:choose>
<xsl:when test="/SWDML/@version = '3-0' or /SWDML/@version = '3-1'">
<xsl:choose>
<xsl:when test="$reportingCounterpartyReference = substring-after($reportingData/partyRoles/remainingParty,'#')">partyB</xsl:when>
<xsl:when test="$reportingCounterpartyReference = substring-after($reportingData/partyRoles/transferee,'#')">partyA</xsl:when>
<xsl:when test="$reportingData/partyRoles/otherRemainingParty and ($reportingCounterpartyReference = substring-after($reportingData/partyRoles/otherRemainingParty,'#'))">partyB</xsl:when>
</xsl:choose>
</xsl:when>
<xsl:otherwise>
<xsl:choose>
<xsl:when test="$reportingCounterpartyReference = $reportingData/partyRoles/remainingParty">partyB</xsl:when>
<xsl:when test="$reportingCounterpartyReference = $reportingData/partyRoles/transferee">partyA</xsl:when>
<xsl:when test="$reportingData/partyRoles/otherRemainingParty and ($reportingCounterpartyReference = $reportingData/partyRoles/otherRemainingParty)">partyB</xsl:when>
</xsl:choose>
</xsl:otherwise>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="NovatedSEDataPresent"                select="boolean($seNewNovated)"/>
<xsl:with-param name="NovatedSERegulatorType"              select="$seNovated/swSupervisoryBodyCategory"/>
<xsl:with-param name="NovatedSEUTINamespace"                 select="$seNovated/swUniqueTransactionId/swIssuer"/>
<xsl:with-param name="NovatedSEUTINamespacePrefix">
<xsl:variable name="issuerPrefix" select="$seNovated/swUniqueTransactionId/swIssuer/@issuerIdScheme"/>
<xsl:choose>
<xsl:when test="string($issuerPrefix)='http://www.fpml.org/coding-scheme/external/cftc/issuer-identifier'">CFTC</xsl:when>
<xsl:when test="string($issuerPrefix)='http://www.fpml.org/coding-scheme/external/dtcc/issuer-identifier'">DTCC</xsl:when>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="NovatedSEUTI"                 select="$seNovated/swUniqueTransactionId/swTradeId"/>
<xsl:with-param name="NovatedSEObligatoryReporting" select="$seNovated/swObligatoryReporting"/>
<xsl:with-param name="NovatedSEReportingCounterparty">
<xsl:choose>
<xsl:when test="/SWDML/@version = '3-0' or /SWDML/@version = '3-1'">
<xsl:choose>
<xsl:when test="$seNovated/swReportingCounterpartyReference/@href = substring-after($reportingData/partyRoles/remainingParty,'#')">partyB</xsl:when>
<xsl:when test="$seNovated/swReportingCounterpartyReference/@href = substring-after($reportingData/partyRoles/transferee,'#')">partyA</xsl:when>
<xsl:when test="$reportingData/partyRoles/otherRemainingParty and ($seNovated/swReportingCounterpartyReference/@href = substring-after($reportingData/partyRoles/otherRemainingParty,'#'))">partyB</xsl:when>
</xsl:choose>
</xsl:when>
<xsl:otherwise>
<xsl:choose>
<xsl:when test="$seNovated/swReportingCounterpartyReference/@href = $reportingData/partyRoles/remainingParty">partyB</xsl:when>
<xsl:when test="$seNovated/swReportingCounterpartyReference/@href = $reportingData/partyRoles/transferee">partyA</xsl:when>
<xsl:when test="$reportingData/partyRoles/otherRemainingParty and ($seNovated/swReportingCounterpartyReference/@href = $reportingData/partyRoles/otherRemainingParty)">partyB</xsl:when>
</xsl:choose>
</xsl:otherwise>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="NovationFeeSEDataPresent"                select="boolean($seNovationFee)"/>
<xsl:with-param name="NovationFeeSERegulatorType"              select="$seNovationFee/swSupervisoryBodyCategory"/>
<xsl:with-param name="NovationFeeSERoute1Destination">
<xsl:choose>
<xsl:when test="$seNovationFee/swReportTo/swRoute/swDestination">
<xsl:apply-templates select="$seNovationFee/swReportTo/swRoute/swDestination"/>
</xsl:when>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="NovationFeeSERoute1Intermediary">
<xsl:choose>
<xsl:when test="$seNovationFee/swReportTo/swRoute/swIntermediary">
<xsl:apply-templates select="$seNovationFee/swReportTo/swRoute/swIntermediary"/>
</xsl:when>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="NovationFeeSEUTINamespace">
<xsl:choose>
<xsl:when test="$reportingData/productType = 'Offline Trade Credit'">
<xsl:value-of select="$reportingData/novationExecutionUniqueTransactionId/swIssuer"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$seNovationFee/swUniqueTransactionId/swIssuer"/>
</xsl:otherwise>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="NovationFeeSEUTINamespacePrefix">
<xsl:variable name="issuerPrefix">
<xsl:choose>
<xsl:when test="$reportingData/productType = 'Offline Trade Credit'">
<xsl:value-of select="$reportingData/novationExecutionUniqueTransactionId/swIssuer/@issuerIdScheme"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$seNovationFee/swUniqueTransactionId/swIssuer/@issuerIdScheme"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:choose>
<xsl:when test="string($issuerPrefix)='http://www.fpml.org/coding-scheme/external/cftc/issuer-identifier'">CFTC</xsl:when>
<xsl:when test="string($issuerPrefix)='http://www.fpml.org/coding-scheme/external/dtcc/issuer-identifier'">DTCCC</xsl:when>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="NovationFeeSEUTI">
<xsl:choose>
<xsl:when test="$reportingData/productType = 'Offline Trade Credit'">
<xsl:value-of select="$reportingData/novationExecutionUniqueTransactionId/swTradeId"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$seNovationFee/swUniqueTransactionId/swTradeId"/>
</xsl:otherwise>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="NovationFeeSEObligatoryReporting" select="$seNovationFee/swObligatoryReporting"/>
<xsl:with-param name="NovationFeeSEReportingCounterparty">
<xsl:choose>
<xsl:when test="/SWDML/@version = '3-0' or /SWDML/@version = '3-1'">
<xsl:choose>
<xsl:when test="$seNovationFee/swReportingCounterpartyReference/@href = substring-after($reportingData/partyRoles/transferor,'#')">partyA</xsl:when>
<xsl:when test="$seNovationFee/swReportingCounterpartyReference/@href = substring-after($reportingData/partyRoles/transferee,'#')">partyB</xsl:when>
</xsl:choose>
</xsl:when>
<xsl:otherwise>
<xsl:choose>
<xsl:when test="$seNovationFee/swReportingCounterpartyReference/@href = $reportingData/partyRoles/transferor">partyA</xsl:when>
<xsl:when test="$seNovationFee/swReportingCounterpartyReference/@href = $reportingData/partyRoles/transferee">partyB</xsl:when>
</xsl:choose>
</xsl:otherwise>
</xsl:choose>
</xsl:with-param>
</xsl:call-template>
<xsl:call-template name="tx:MIData">
<xsl:with-param name="MIDataPresent" select="boolean($miReportingRegimeInfo)"/>
<xsl:with-param name="MIObligatoryReporting" select="$miReportingRegimeInfo/swObligatoryReporting"/>
<xsl:with-param name="MIReportingCounterparty">
<xsl:variable name="swReportingCounterpartyReference" select="$miReportingRegimeInfo/swReportingCounterpartyReference/@href"/>
<xsl:choose>
<xsl:when test="$reportingData/productType='Offline Trade Credit'">
<xsl:choose>
<xsl:when test="$swReportingCounterpartyReference = $reportingData/partyRoles/transferor">partyA</xsl:when>
<xsl:when test="$swReportingCounterpartyReference = $reportingData/partyRoles/remainingParty">partyB</xsl:when>
</xsl:choose>
</xsl:when>
<xsl:when test="$reportingData/productType='Generic Product'">
<xsl:value-of select="string($swReportingCounterpartyReference)"/>
</xsl:when>
<xsl:otherwise>
<xsl:variable name="rcpHref">
<xsl:choose>
<xsl:when test="/SWDML/@version = '3-0' or /SWDML/@version = '3-1'">
<xsl:value-of select="substring-after($swReportingCounterpartyReference,'#')"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="string($swReportingCounterpartyReference)"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:choose>
<xsl:when test="string-length($reportingData/partyRoles/transferor)&gt; 0">
<xsl:choose>
<xsl:when test="/SWDML/@version = '3-0' or /SWDML/@version = '3-1'">
<xsl:choose>
<xsl:when test="$swReportingCounterpartyReference = substring-after($reportingData/partyRoles/remainingParty,'#')">partyB</xsl:when>
<xsl:when test="$swReportingCounterpartyReference = substring-after($reportingData/partyRoles/transferor,'#')">partyA</xsl:when>
<xsl:when test="$swReportingCounterpartyReference = substring-after($reportingData/partyRoles/transferee,'#')">partyC</xsl:when>
<xsl:when test="$reportingData/partyRoles/otherRemainingParty and ($swReportingCounterpartyReference = substring-after($reportingData/partyRoles/otherRemainingParty,'#'))">partyB</xsl:when>
</xsl:choose>
</xsl:when>
<xsl:otherwise>
<xsl:choose>
<xsl:when test="$swReportingCounterpartyReference = $reportingData/partyRoles/remainingParty">partyB</xsl:when>
<xsl:when test="$swReportingCounterpartyReference = $reportingData/partyRoles/transferor">partyA</xsl:when>
<xsl:when test="$swReportingCounterpartyReference = $reportingData/partyRoles/transferee">partyC</xsl:when>
<xsl:when test="$reportingData/partyRoles/otherRemainingParty and ($swReportingCounterpartyReference = $reportingData/partyRoles/otherRemainingParty)">partyB</xsl:when>
</xsl:choose>
</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$rcpHref = ''"/>
<xsl:when test="$rcpHref = 'venue'">venue</xsl:when>
<xsl:when test="$rcpHref = $partyA">partyA</xsl:when>
<xsl:when test="$rcpHref = $partyB">partyB</xsl:when>
<xsl:when test="$rcpHref = $partyC">partyC</xsl:when>
<xsl:when test="string-length($reportingData/partyRoles/primeBrokerA) &gt; 0 and $rcpHref = $partyC">partyPB</xsl:when>
<xsl:when test="string-length($reportingData/partyRoles/primeBrokerB) &gt; 0 and $rcpHref = $partyD">partyPB</xsl:when>
</xsl:choose>
</xsl:otherwise>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="MINewNovatedDataPresent"  select="boolean($miNewNovated)"/>
<xsl:with-param name="MINovatedDataPresent"       select="boolean($miNovated)"/>
<xsl:with-param name="MIUTINamespace" select="$miReportingRegimeInfo/swUniqueTransactionId/swIssuer"/>
<xsl:with-param name="MIUTINamespacePrefix">
<xsl:variable name="issuerPrefix" select="$miReportingRegimeInfo/swUniqueTransactionId/swIssuer/@issuerIdScheme"/>
<xsl:choose>
<xsl:when test="string($issuerPrefix)='http://www.fpml.org/coding-scheme/external/cftc/issuer-identifier'">CFTC</xsl:when>
<xsl:when test="string($issuerPrefix)='http://www.fpml.org/coding-scheme/external/dtcc/issuer-identifier'">DTCC</xsl:when>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="MIUTI"                 select="$miReportingRegimeInfo/swUniqueTransactionId/swTradeId"/>
<xsl:with-param name="MIIntentToBlankUTINamespace" select="boolean($miReportingRegimeInfo/swUniqueTransactionId/swIssuer[normalize-space(.) = ''])"/>
<xsl:with-param name="MIIntentToBlankUTI"    select="boolean($miReportingRegimeInfo/swUniqueTransactionId/swTradeId[normalize-space(.) = ''])"/>
<xsl:with-param name="MINovatedUTINamespace"                 select="$miNovated/swUniqueTransactionId/swIssuer"/>
<xsl:with-param name="MINovatedUTINamespacePrefix">
<xsl:variable name="issuerPrefix" select="$miNovated/swUniqueTransactionId/swIssuer/@issuerIdScheme"/>
<xsl:choose>
<xsl:when test="string($issuerPrefix)='http://www.fpml.org/coding-scheme/external/cftc/issuer-identifier'">CFTC</xsl:when>
<xsl:when test="string($issuerPrefix)='http://www.fpml.org/coding-scheme/external/dtcc/issuer-identifier'">DTCC</xsl:when>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="MINovatedUTI"                 select="$miNovated/swUniqueTransactionId/swTradeId"/>
<xsl:with-param name="MINewNovatedUTINamespace" select="$miNewNovated/swUniqueTransactionId/swIssuer"/>
<xsl:with-param name="MINewNovatedUTINamespacePrefix">
<xsl:variable name="issuerPrefix" select="$dfNewNovated/swUniqueTransactionId/swIssuer/@issuerIdScheme"/>
<xsl:choose>
<xsl:when test="string($issuerPrefix)='http://www.fpml.org/coding-scheme/external/cftc/issuer-identifier'">CFTC</xsl:when>
<xsl:when test="string($issuerPrefix)='http://www.fpml.org/coding-scheme/external/dtcc/issuer-identifier'">DTCC</xsl:when>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="MINewNovatedUTI"                 select="$miNewNovated/swUniqueTransactionId/swTradeId"/>
<xsl:with-param name="MIToTV" select="$miReportingRegimeInfo/swToTV"/>
</xsl:call-template>
<xsl:call-template name="tx:ASICData">
<xsl:with-param name="ASICDataPresent" select="boolean($asicReportingRegimeInfo)"/>
<xsl:with-param name="ASICNewNovatedDataPresent"  select="boolean($asicNewNovated)"/>
<xsl:with-param name="ASICNovatedDataPresent"       select="boolean($asicNovated)"/>
<xsl:with-param name="ASICUTINamespace" select="$asicReportingRegimeInfo/swUniqueTransactionId/swIssuer"/>
<xsl:with-param name="ASICUTINamespacePrefix">
<xsl:variable name="issuerPrefix" select="$asicReportingRegimeInfo/swUniqueTransactionId/swIssuer/@issuerIdScheme"/>
<xsl:choose>
<xsl:when test="string($issuerPrefix)='http://www.fpml.org/coding-scheme/external/cftc/issuer-identifier'">CFTC</xsl:when>
<xsl:when test="string($issuerPrefix)='http://www.fpml.org/coding-scheme/external/dtcc/issuer-identifier'">DTCC</xsl:when>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="ASICUTI"                 select="$asicReportingRegimeInfo/swUniqueTransactionId/swTradeId"/>
<xsl:with-param name="ASICIntentToBlankUTINamespace" select="boolean($asicReportingRegimeInfo/swUniqueTransactionId/swIssuer[normalize-space(.) = ''])"/>
<xsl:with-param name="ASICIntentToBlankUTI"    select="boolean($asicReportingRegimeInfo/swUniqueTransactionId/swTradeId[normalize-space(.) = ''])"/>
<xsl:with-param name="ASICNovatedUTINamespace"                 select="$asicNovated/swUniqueTransactionId/swIssuer"/>
<xsl:with-param name="ASICNovatedUTINamespacePrefix">
<xsl:variable name="issuerPrefix" select="$asicNovated/swUniqueTransactionId/swIssuer/@issuerIdScheme"/>
<xsl:choose>
<xsl:when test="string($issuerPrefix)='http://www.fpml.org/coding-scheme/external/cftc/issuer-identifier'">CFTC</xsl:when>
<xsl:when test="string($issuerPrefix)='http://www.fpml.org/coding-scheme/external/dtcc/issuer-identifier'">DTCC</xsl:when>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="ASICNovatedUTI"                 select="$asicNovated/swUniqueTransactionId/swTradeId"/>
<xsl:with-param name="ASICNewNovatedUTINamespace" select="$asicNewNovated/swUniqueTransactionId/swIssuer"/>
<xsl:with-param name="ASICNewNovatedUTINamespacePrefix">
<xsl:variable name="issuerPrefix" select="$dfNewNovated/swUniqueTransactionId/swIssuer/@issuerIdScheme"/>
<xsl:choose>
<xsl:when test="string($issuerPrefix)='http://www.fpml.org/coding-scheme/external/cftc/issuer-identifier'">CFTC</xsl:when>
<xsl:when test="string($issuerPrefix)='http://www.fpml.org/coding-scheme/external/dtcc/issuer-identifier'">DTCC</xsl:when>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="ASICNewNovatedUTI"                 select="$asicNewNovated/swUniqueTransactionId/swTradeId"/>
</xsl:call-template>
<xsl:call-template name="tx:MASData">
<xsl:with-param name="MASDataPresent" select="boolean($masReportingRegimeInfo)"/>
<xsl:with-param name="MASNewNovatedDataPresent"  select="boolean($masNewNovated)"/>
<xsl:with-param name="MASNovatedDataPresent"       select="boolean($masNovated)"/>
<xsl:with-param name="MASUTINamespace" select="$masReportingRegimeInfo/swUniqueTransactionId/swIssuer"/>
<xsl:with-param name="MASUTINamespacePrefix">
<xsl:variable name="issuerPrefix" select="$masReportingRegimeInfo/swUniqueTransactionId/swIssuer/@issuerIdScheme"/>
<xsl:choose>
<xsl:when test="string($issuerPrefix)='http://www.fpml.org/coding-scheme/external/cftc/issuer-identifier'">CFTC</xsl:when>
<xsl:when test="string($issuerPrefix)='http://www.fpml.org/coding-scheme/external/dtcc/issuer-identifier'">DTCC</xsl:when>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="MASUTI"                 select="$masReportingRegimeInfo/swUniqueTransactionId/swTradeId"/>
<xsl:with-param name="MASIntentToBlankUTINamespace" select="boolean($masReportingRegimeInfo/swUniqueTransactionId/swIssuer[normalize-space(.) = ''])"/>
<xsl:with-param name="MASIntentToBlankUTI"    select="boolean($masReportingRegimeInfo/swUniqueTransactionId/swTradeId[normalize-space(.) = ''])"/>
<xsl:with-param name="MASNovatedUTINamespace"                 select="$masNovated/swUniqueTransactionId/swIssuer"/>
<xsl:with-param name="MASNovatedUTINamespacePrefix">
<xsl:variable name="issuerPrefix" select="$masNovated/swUniqueTransactionId/swIssuer/@issuerIdScheme"/>
<xsl:choose>
<xsl:when test="string($issuerPrefix)='http://www.fpml.org/coding-scheme/external/cftc/issuer-identifier'">CFTC</xsl:when>
<xsl:when test="string($issuerPrefix)='http://www.fpml.org/coding-scheme/external/dtcc/issuer-identifier'">DTCC</xsl:when>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="MASNovatedUTI"                 select="$masNovated/swUniqueTransactionId/swTradeId"/>
<xsl:with-param name="MASNewNovatedUTINamespace" select="$masNewNovated/swUniqueTransactionId/swIssuer"/>
<xsl:with-param name="MASNewNovatedUTINamespacePrefix">
<xsl:variable name="issuerPrefix" select="$dfNewNovated/swUniqueTransactionId/swIssuer/@issuerIdScheme"/>
<xsl:choose>
<xsl:when test="string($issuerPrefix)='http://www.fpml.org/coding-scheme/external/cftc/issuer-identifier'">CFTC</xsl:when>
<xsl:when test="string($issuerPrefix)='http://www.fpml.org/coding-scheme/external/dtcc/issuer-identifier'">DTCC</xsl:when>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="MASNewNovatedUTI"                 select="$masNewNovated/swUniqueTransactionId/swTradeId"/>
</xsl:call-template>
<xsl:call-template name="tx:FCAData">
<xsl:with-param name="FCADataPresent" select="boolean($fcaReportingRegimeInfo)"/>
<xsl:with-param name="FCANewNovatedDataPresent"  select="boolean($fcaNewNovated)"/>
<xsl:with-param name="FCANovatedDataPresent"       select="boolean($fcaNovated)"/>
<xsl:with-param name="FCAUTINamespace" select="$fcaReportingRegimeInfo/swUniqueTransactionId/swIssuer"/>
<xsl:with-param name="FCAUTINamespacePrefix">
<xsl:variable name="issuerPrefix" select="$fcaReportingRegimeInfo/swUniqueTransactionId/swIssuer/@issuerIdScheme"/>
<xsl:choose>
<xsl:when test="string($issuerPrefix)='http://www.fpml.org/coding-scheme/external/cftc/issuer-identifier'">CFTC</xsl:when>
<xsl:when test="string($issuerPrefix)='http://www.fpml.org/coding-scheme/external/dtcc/issuer-identifier'">DTCC</xsl:when>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="FCAUTI"                 select="$fcaReportingRegimeInfo/swUniqueTransactionId/swTradeId"/>
<xsl:with-param name="FCAIntentToBlankUTINamespace" select="boolean($fcaReportingRegimeInfo/swUniqueTransactionId/swIssuer[normalize-space(.) = ''])"/>
<xsl:with-param name="FCAIntentToBlankUTI"    select="boolean($fcaReportingRegimeInfo/swUniqueTransactionId/swTradeId[normalize-space(.) = ''])"/>
<xsl:with-param name="FCANovatedUTINamespace"                 select="$fcaNovated/swUniqueTransactionId/swIssuer"/>
<xsl:with-param name="FCANovatedUTINamespacePrefix">
<xsl:variable name="issuerPrefix" select="$fcaNovated/swUniqueTransactionId/swIssuer/@issuerIdScheme"/>
<xsl:choose>
<xsl:when test="string($issuerPrefix)='http://www.fpml.org/coding-scheme/external/cftc/issuer-identifier'">CFTC</xsl:when>
<xsl:when test="string($issuerPrefix)='http://www.fpml.org/coding-scheme/external/dtcc/issuer-identifier'">DTCC</xsl:when>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="FCANovatedUTI"                 select="$fcaNovated/swUniqueTransactionId/swTradeId"/>
<xsl:with-param name="FCANewNovatedUTINamespace" select="$fcaNewNovated/swUniqueTransactionId/swIssuer"/>
<xsl:with-param name="FCANewNovatedUTINamespacePrefix">
<xsl:variable name="issuerPrefix" select="$dfNewNovated/swUniqueTransactionId/swIssuer/@issuerIdScheme"/>
<xsl:choose>
<xsl:when test="string($issuerPrefix)='http://www.fpml.org/coding-scheme/external/cftc/issuer-identifier'">CFTC</xsl:when>
<xsl:when test="string($issuerPrefix)='http://www.fpml.org/coding-scheme/external/dtcc/issuer-identifier'">DTCC</xsl:when>
</xsl:choose>
</xsl:with-param>
<xsl:with-param name="FCANewNovatedUTI"                 select="$fcaNewNovated/swUniqueTransactionId/swTradeId"/>
</xsl:call-template>
</xsl:template>
<xsl:template name="swDestination">
<xsl:value-of select="swDestination"/>
</xsl:template>
<xsl:template name="swIntermediary">
<xsl:value-of select="swIntermediary"/>
</xsl:template>
<xsl:template name="AllocationNexusFields">
<xsl:param name="nexusNode" select="node()"/>
<NexusReportingDetails>
<xsl:variable name="execTraderName" select="$nexusNode/swPartyExtension/swReferencedPerson[@id=$nexusNode/swRelatedPerson[swRole='Trader']/swPersonReference/@href]/swName"/>
<xsl:variable name="salesTraderName" select="$nexusNode/swPartyExtension/swReferencedPerson[@id=$nexusNode/swRelatedPerson[swRole='Sales']/swPersonReference/@href]/swName"/>
<xsl:variable name="investFirmName" select="$nexusNode/swPartyExtension/swReferencedPerson[@id=$nexusNode/swRelatedPerson[swRole='InvestmentDecisionMaker']/swPersonReference/@href]/swName"/>
<xsl:variable name="branchLocation" select="$nexusNode/swPartyExtension/swBusinessUnit[@id=$nexusNode/swRelatedBusinessUnit[swRole='Branch']/swBusinessUnitReference/@href]/swCountry"/>
<xsl:variable name="deskLocation" select="$nexusNode/swPartyExtension/swBusinessUnit[@id=$nexusNode/swRelatedBusinessUnit[swRole='Trader']/swBusinessUnitReference/@href]/swCountry"/>
<xsl:variable name="execTraderLocation" select="$nexusNode/swPartyExtension/swReferencedPerson[@id=$nexusNode/swRelatedPerson[swRole='Trader']/swPersonReference/@href]/swCountry"/>
<xsl:variable name="salesTraderLocation" select="$nexusNode/swPartyExtension/swReferencedPerson[@id=$nexusNode/swRelatedPerson[swRole='Sales']/swPersonReference/@href]/swCountry"/>
<xsl:variable name="investFirmLocation" select="$nexusNode/swPartyExtension/swReferencedPerson[@id=$nexusNode/swRelatedPerson[swRole='InvestmentDecisionMaker']/swPersonReference/@href]/swCountry"/>
<xsl:variable name="brokerLocation" select="$nexusNode/swAdditionalParty[@id=$nexusNode/swRelatedParty[swRole='ExecutingBroker']/swPartyReference/@href]/swCountry"/>
<xsl:variable name="arrBrokerLocation" select="$nexusNode/swAdditionalParty[@id=$nexusNode/swRelatedParty[swRole='ArrangingBroker']/swPartyReference/@href]/swCountry"/>
<xsl:if test="$execTraderName">
<ExecutingTraderName><xsl:value-of select="$execTraderName"/></ExecutingTraderName>
</xsl:if>
<xsl:if test="$salesTraderName">
<SalesTraderName><xsl:value-of select="$salesTraderName"/></SalesTraderName>
</xsl:if>
<xsl:if test="$investFirmName">
<InvestFirmName><xsl:value-of select="$investFirmName"/></InvestFirmName>
</xsl:if>
<xsl:if test="$branchLocation">
<BranchLocation><xsl:value-of select="$branchLocation"/></BranchLocation>
</xsl:if>
<xsl:if test="$deskLocation">
<DeskLocation><xsl:value-of select="$deskLocation"/></DeskLocation>
</xsl:if>
<xsl:if test="$execTraderLocation">
<ExecutingTraderLocation><xsl:value-of select="$execTraderLocation"/></ExecutingTraderLocation>
</xsl:if>
<xsl:if test="$salesTraderLocation">
<SalesTraderLocation><xsl:value-of select="$salesTraderLocation"/></SalesTraderLocation>
</xsl:if>
<xsl:if test="$investFirmLocation">
<InvestFirmLocation><xsl:value-of select="$investFirmLocation"/></InvestFirmLocation>
</xsl:if>
<xsl:if test="$brokerLocation">
<BrokerLocation><xsl:value-of select="$brokerLocation"/></BrokerLocation>
</xsl:if>
<xsl:if test="$arrBrokerLocation">
<ArrBrokerLocation><xsl:value-of select="$arrBrokerLocation"/></ArrBrokerLocation>
</xsl:if>
</NexusReportingDetails>
</xsl:template>
</xsl:stylesheet>
