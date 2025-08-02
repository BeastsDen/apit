<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" indent="no"/>
<xsl:strip-space elements="*"/>
<xsl:param name="party"/>
<xsl:variable name="partyAId" select="/TiwCsvMessage/partyAId"/>
<xsl:variable name="partyBId" select="/TiwCsvMessage/partyBId"/>
<xsl:variable name="msg_value_date" select="/TiwCsvMessage/VALUE_DATE"/>
<xsl:variable name="dtcc_trade_reference_id" select="/TiwCsvMessage/DTCC_TRADE_REFERENCE_ID"/>
<xsl:variable name="ctpy_trade_reference_id" select="/TiwCsvMessage/CTPY_TRADE_REFERENCE_ID"/>
<xsl:variable name="trade_reference_id" select="/TiwCsvMessage/TRADE_REFERENCE_ID"/>
<xsl:variable name="cmnt" select="/TiwCsvMessage/CMNT"/>
<xsl:variable name="super_id" select="/TiwCsvMessage/SUPER_ID"/>
<xsl:variable name="desk_id" select="/TiwCsvMessage/DESK_ID"/>
<xsl:variable name="designated_party_id" select="/TiwCsvMessage/DESIGNATED_PARTY_ID"/>
<xsl:variable name="broker_name" select="/TiwCsvMessage/BROKER_NAME"/>
<xsl:variable name="dtcc_account_number" select="/TiwCsvMessage/DTCC_ACCOUNT_NUMBER"/>
<xsl:variable name="ctpy_account_number" select="/TiwCsvMessage/CTPY_ACCOUNT_NUMBER"/>
<xsl:variable name="esma_trading_capacity" select="/TiwCsvMessage/ESMA_TRADING_CAPACITY"/>
<xsl:variable name="esma_compression" select="/TiwCsvMessage/ESMA_COMPRESSION"/>
<xsl:variable name="reporting_desk_id" select="/TiwCsvMessage/REPORTING_DESK_ID"/>
<xsl:variable name="price_forming_flag" select="/TiwCsvMessage/PRICE_FORMING_FLAG"/>
<xsl:variable name="broker_loc" select="/TiwCsvMessage/BROKER_LOC"/>
<xsl:variable name="trader_loc" select="/TiwCsvMessage/TRADER_LOC"/>
<xsl:variable name="sales_loc" select="/TiwCsvMessage/SALES_LOC"/>
<xsl:variable name="desk_loc" select="/TiwCsvMessage/DESK_LOC"/>
<xsl:variable name="esma_branch_loc_country_code" select="/TiwCsvMessage/ESMA_BRANCH_LOC_COUNTRY_CODE"/>
<xsl:variable name="esma_ben_prefix" select="/TiwCsvMessage/ESMA_BEN_PREFIX"/>
<xsl:variable name="esma_intragroup" select="/TiwCsvMessage/ESMA_INTRAGROUP"/>
<xsl:variable name="esma_ben_party_to_the_trade" select="/TiwCsvMessage/ESMA_BEN_PARTY_TO_THE_TRADE"/>
<xsl:variable name="esma_nondisclosure" select="/TiwCsvMessage/ESMA_NONDISCLOSURE"/>
<xsl:variable name="cftc_nondisclosure" select="/TiwCsvMessage/CFTC_NONDISCLOSURE"/>
<xsl:variable name="jfsa_nondisclosure" select="/TiwCsvMessage/JFSA_NONDISCLOSURE"/>
<xsl:variable name="mas_nondisclosure" select="/TiwCsvMessage/MAS_NONDISCLOSURE"/>
<xsl:variable name="asic_nondisclosure" select="/TiwCsvMessage/ASIC_NONDISCLOSURE"/>
<xsl:variable name="off_platform_verification" select="/TiwCsvMessage/OFF_PLATFORM_VERIFICATION"/>
<xsl:variable name="nonstandard_flag" select="/TiwCsvMessage/NONSTANDARD_FLAG"/>
<xsl:variable name="collateralized" select="/TiwCsvMessage/COLLATERALIZED"/>
<xsl:variable name="esma_collateral_portfolio_code" select="/TiwCsvMessage/ESMA_COLLATERAL_PORTFOLIO_CODE"/>
<xsl:variable name="esma_comm_act_treasury_fin" select="/TiwCsvMessage/ESMA_COMM_ACT_TREASURY_FIN"/>
<xsl:variable name="cftc_clearing_flag" select="/TiwCsvMessage/CFTC_CLEARING_FLAG"/>
<xsl:variable name="prior_usi_uti_id" select="/TiwCsvMessage/PRIOR_USI_UTI_ID"/>
<xsl:variable name="prior_usi_uti_prefix" select="/TiwCsvMessage/PRIOR_USI_UTI_PREFIX"/>
<xsl:variable name="block_usi_uti_prefix" select="/TiwCsvMessage/BLOCK_USI_UTI_PREFIX"/>
<xsl:variable name="block_usi_uti" select="/TiwCsvMessage/BLOCK_USI_UTI"/>
<xsl:variable name="jfsa_reporting_jurisdiction" select="/TiwCsvMessage/JFSA_REPORTING_JURISDICTION"/>
<xsl:variable name="esma_reporting_jurisdiction" select="/TiwCsvMessage/ESMA_REPORTING_JURISDICTION"/>
<xsl:variable name="asic_reporting_jurisdiction" select="/TiwCsvMessage/ASIC_REPORTING_JURISDICTION"/>
<xsl:variable name="mas_reporting_jurisdiction" select="/TiwCsvMessage/MAS_REPORTING_JURISDICTION"/>
<xsl:variable name="clearing_status" select="/TiwCsvMessage/CLEARING_STATUS"/>
<xsl:variable name="clearing_timestamp" select="/TiwCsvMessage/CLEARING_TIMESTAMP"/>
<xsl:variable name="reporting_broker_id" select="/TiwCsvMessage/REPORTING_BROKER_ID"/>
<xsl:template name="myPrivateData">
<swPrivateTradeId><xsl:value-of select="$trade_reference_id"/></swPrivateTradeId>
<xsl:if test="string-length($cmnt) or string-length($super_id) or string-length($desk_id) or string-length($designated_party_id) or string-length($broker_name)">
<swDSMatchWorkflowFields>
<xsl:if test="string-length($cmnt)"><swDSMatchComment><xsl:value-of select="$cmnt"/></swDSMatchComment></xsl:if>
<xsl:if test="string-length($super_id)"><swDSMatchSuperId><xsl:value-of select="$super_id"/></swDSMatchSuperId></xsl:if>
<xsl:if test="string-length($desk_id)"><swDSMatchDeskId><xsl:value-of select="$desk_id"/></swDSMatchDeskId></xsl:if>
<xsl:if test="string-length($designated_party_id)"><swDSMatchDesignatedPartyId><xsl:value-of select="$designated_party_id"/></swDSMatchDesignatedPartyId></xsl:if>
<xsl:if test="string-length($broker_name)"><swDSMatchBrokerName><xsl:value-of select="$broker_name"/></swDSMatchBrokerName></xsl:if>
</swDSMatchWorkflowFields>
</xsl:if>
<xsl:if test="$esma_compression = 'true'">
<swOriginatingEvent>PortfolioCompression</swOriginatingEvent>
</xsl:if>
<xsl:if test="string-length($broker_loc)"><swBrokerLocation><xsl:value-of select="$broker_loc"/></swBrokerLocation></xsl:if>
<xsl:if test="string-length($desk_loc)"><swDeskLocation><xsl:value-of select="$desk_loc"/></swDeskLocation></xsl:if>
<xsl:if test="string-length($trader_loc)"><swTraderLocation><xsl:value-of select="$trader_loc"/></swTraderLocation></xsl:if>
<xsl:if test="string-length($sales_loc)"><swSalesLocation><xsl:value-of select="$sales_loc"/></swSalesLocation></xsl:if>
<xsl:if test="string-length($esma_branch_loc_country_code)"><swBranchLocation><xsl:value-of select="$esma_branch_loc_country_code"/></swBranchLocation></xsl:if>
<xsl:if test="$esma_ben_party_to_the_trade">
<swBeneficiaryIdPrefix>
<xsl:choose>
<xsl:when test="$esma_ben_prefix"><xsl:value-of select="$esma_ben_prefix"/></xsl:when>
<xsl:otherwise>FREEFORMATTEXT</xsl:otherwise>
</xsl:choose>
</swBeneficiaryIdPrefix>
<swBeneficiaryIdValue><xsl:value-of select="$esma_ben_party_to_the_trade"/></swBeneficiaryIdValue>
</xsl:if>
<xsl:if test="string-length($off_platform_verification)"><swOffPlatformVerificationType><xsl:value-of select="$off_platform_verification"/></swOffPlatformVerificationType></xsl:if>
<xsl:if test="string-length($nonstandard_flag)"><swNonStandardTerms><xsl:value-of select="$nonstandard_flag"/></swNonStandardTerms></xsl:if>
<xsl:if test="string-length($collateralized)"><swCollateralized><xsl:value-of select="$collateralized"/></swCollateralized></xsl:if>
<xsl:if test="string-length($esma_collateral_portfolio_code)"><swCollateralPortfolioCode><xsl:value-of select="$esma_collateral_portfolio_code"/></swCollateralPortfolioCode></xsl:if>
<xsl:if test="string-length($esma_comm_act_treasury_fin)"><swCommercialActivity><xsl:value-of select="$esma_comm_act_treasury_fin"/></swCommercialActivity></xsl:if>
<xsl:if test="string-length($esma_trading_capacity)"><swTradingCapacity><xsl:value-of select="$esma_trading_capacity"/></swTradingCapacity></xsl:if>
<xsl:if test="string-length($cftc_clearing_flag)">
<swDFReporting>
<xsl:if test="string-length($cftc_clearing_flag)"><swEndUserException><xsl:value-of select="$cftc_clearing_flag"/></swEndUserException></xsl:if>
<xsl:if test="string-length($cftc_nondisclosure)"><swCounterpartyNonDisclosure><xsl:value-of select="$cftc_nondisclosure"/></swCounterpartyNonDisclosure></xsl:if>
</swDFReporting>
</xsl:if>
<xsl:if test="string-length($jfsa_reporting_jurisdiction)">
<swJFSAReporting>
<swObligatoryReporting><xsl:value-of select="$jfsa_reporting_jurisdiction"/></swObligatoryReporting>
<xsl:if test="string-length($jfsa_nondisclosure)"><swCounterpartyNonDisclosure><xsl:value-of select="$jfsa_nondisclosure"/></swCounterpartyNonDisclosure></xsl:if>
</swJFSAReporting>
</xsl:if>
<xsl:if test="string-length($esma_reporting_jurisdiction)">
<swESMAReporting>
<swObligatoryReporting><xsl:value-of select="$esma_reporting_jurisdiction"/></swObligatoryReporting>
<xsl:if test="string-length($esma_intragroup)"><swIntragroup><xsl:value-of select="$esma_intragroup"/></swIntragroup></xsl:if>
<xsl:if test="string-length($esma_nondisclosure)"><swCounterpartyNonDisclosure><xsl:value-of select="$esma_nondisclosure"/></swCounterpartyNonDisclosure></xsl:if>
</swESMAReporting>
</xsl:if>
<xsl:if test="string-length($mas_reporting_jurisdiction)">
<swMASReporting>
<swObligatoryReporting><xsl:value-of select="$mas_reporting_jurisdiction"/></swObligatoryReporting>
<xsl:if test="string-length($mas_nondisclosure)"><swCounterpartyNonDisclosure><xsl:value-of select="$mas_nondisclosure"/></swCounterpartyNonDisclosure></xsl:if>
</swMASReporting>
</xsl:if>
<xsl:if test="string-length($asic_reporting_jurisdiction)">
<swASICReporting>
<swObligatoryReporting><xsl:value-of select="$asic_reporting_jurisdiction"/></swObligatoryReporting>
<xsl:if test="string-length($asic_nondisclosure)"><swCounterpartyNonDisclosure><xsl:value-of select="$asic_nondisclosure"/></swCounterpartyNonDisclosure></xsl:if>
</swASICReporting>
</xsl:if>
<xsl:if test="$clearing_timestamp">
<xsl:choose>
<xsl:when test="string-length($clearing_timestamp) &gt; 18">
<xsl:variable name="ct_year" select="substring($clearing_timestamp, 1, 4)"/>
<xsl:variable name="ct_month" select="substring($clearing_timestamp, 6, 2)"/>
<xsl:variable name="ct_day" select="substring($clearing_timestamp, 9, 2)"/>
<xsl:variable name="ct_hour" select="substring($clearing_timestamp, 12, 2)"/>
<xsl:variable name="ct_min" select="substring($clearing_timestamp, 15, 2)"/>
<xsl:variable name="ct_sec" select="substring($clearing_timestamp, 18, 2)"/>
<swClearedTradeReporting>
<swClearedTimeStamp>
<xsl:value-of select="concat($ct_year, '-', $ct_month, '-', $ct_day, 'T', $ct_hour, ':', $ct_min, ':', $ct_sec)"/>
</swClearedTimeStamp>
</swClearedTradeReporting>
</xsl:when>
<xsl:otherwise/> 
</xsl:choose>
</xsl:if>
<xsl:if test="string-length($reporting_broker_id)"><swReportingBrokerId><xsl:value-of select="$reporting_broker_id"/></swReportingBrokerId></xsl:if>
<swTIWWriteValueDate>true</swTIWWriteValueDate>
</xsl:template>
<xsl:template name="cptyPrivateData">
<swPrivateTradeId>
<xsl:value-of select="$ctpy_trade_reference_id"/>
</swPrivateTradeId>
<swTIWWriteValueDate>false</swTIWWriteValueDate>
</xsl:template>
<xsl:template match="/">
<PrivateData>
<xsl:variable name="ptyRef" select="$dtcc_account_number"/>
<xsl:variable name="cptyRef" select="$ctpy_account_number"/>
<xsl:choose>
<xsl:when test="$party=$ptyRef">
<xsl:call-template name="myPrivateData"/>
</xsl:when>
<xsl:when test="$party=$cptyRef">
<xsl:call-template name="cptyPrivateData"/>
</xsl:when>
<xsl:otherwise>
<PartyError>
<ptyRef><xsl:value-of select="$ptyRef"/></ptyRef>
<cptyRef><xsl:value-of select="$cptyRef"/></cptyRef>
<desiredParty><xsl:value-of select="$party"/></desiredParty>
</PartyError>
</xsl:otherwise>
</xsl:choose>
<swTIWPrivateValueDate>
<xsl:value-of select="substring($msg_value_date,1,19)"/>
</swTIWPrivateValueDate>
</PrivateData>
</xsl:template>
</xsl:stylesheet>
