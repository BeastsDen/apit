<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:fpml="http://www.fpml.org/2010/FpML-4-9"
xmlns:common="http://exslt.org/common"
xmlns:lcl="http://www.markitserv.com/detail/SWDMLTrade.xsl"
exclude-result-prefixes="fpml common lcl" version="1.0">
<xsl:import href="tiw_position_content_mappings.xsl"/> 
<xsl:import href="SWDMLTrade.xsl"/>
<xsl:output method="xml"/>
<xsl:template name="getMonthAsNumber">
<xsl:param name="monthstring"/>
<xsl:variable name="month">
<xsl:value-of select="translate($monthstring,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
</xsl:variable>
<xsl:choose>
<xsl:when test="$month='JAN' or $month='JANUARY'">01</xsl:when>
<xsl:when test="$month='FEB' or $month='FEBRUARY'">02</xsl:when>
<xsl:when test="$month='MAR' or $month='MARCH'">03</xsl:when>
<xsl:when test="$month='APR' or $month='APRIL'">04</xsl:when>
<xsl:when test="$month='MAY' or $month='MAY'">05</xsl:when>
<xsl:when test="$month='JUN' or $month='JUNE'">06</xsl:when>
<xsl:when test="$month='JUL' or $month='JULY'">07</xsl:when>
<xsl:when test="$month='AUG' or $month='AUGUST'">08</xsl:when>
<xsl:when test="$month='SEP' or $month='SEPTEMBER'">09</xsl:when>
<xsl:when test="$month='OCT' or $month='OCTOBER'">10</xsl:when>
<xsl:when test="$month='NOV' or $month='NOVEMBER'">11</xsl:when>
<xsl:when test="$month='DEC' or $month='DECEMBER'">12</xsl:when>
<xsl:otherwise>???</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:variable name="partyAId" select="/TiwCsvMessage/partyAId"/>
<xsl:variable name="partyBId" select="/TiwCsvMessage/partyBId"/>
<xsl:variable name="active_status" select="/TiwCsvMessage/ACTIVE_STATUS"/>
<xsl:variable name="msg_value_date" select="/TiwCsvMessage/VALUE_DATE"/>
<xsl:variable name="msg_as_of_date" select="/TiwCsvMessage/WHSE_CURR_STATE_NOTIONAL_DT"/>
<xsl:variable name="dtcc_account_number" select="/TiwCsvMessage/DTCC_ACCOUNT_NUMBER"/>
<xsl:variable name="trade_reference_id" select="/TiwCsvMessage/TRADE_REFERENCE_ID"/>
<xsl:variable name="trade_reference_id_supplement" select="/TiwCsvMessage/TRADE_REFERENCE_ID_SUPPLEMENT"/>
<xsl:variable name="ctpy_account_number" select="/TiwCsvMessage/CTPY_ACCOUNT_NUMBER"/>
<xsl:variable name="ctpy_trade_reference_id" select="/TiwCsvMessage/CTPY_TRADE_REFERENCE_ID"/>
<xsl:variable name="dtcc_trade_reference_id" select="/TiwCsvMessage/DTCC_TRADE_REFERENCE_ID"/>
<xsl:variable name="submit_dt" select="/TiwCsvMessage/SUBMIT_DT"/>
<xsl:variable name="submit_time" select="/TiwCsvMessage/SUBMIT_TIME"/>
<xsl:variable name="transaction_type" select="/TiwCsvMessage/TRANSACTION_TYPE"/>
<xsl:variable name="status" select="/TiwCsvMessage/STATUS"/>
<xsl:variable name="trade_confirmation_dt" select="/TiwCsvMessage/TRADE_CONFIRMATION_DT"/>
<xsl:variable name="post_trade_confirmation_dt" select="/TiwCsvMessage/POST_TRADE_CONFIRMATION_DT"/>
<xsl:variable name="notional_file_creation" select="/TiwCsvMessage/NOTIONAL_FILE_CREATION"/>
<xsl:variable name="notional_file_creation_ccy" select="/TiwCsvMessage/NOTIONAL_FILE_CREATION_CCY"/>
<xsl:variable name="whse_curr_state_notional_amt" select="/TiwCsvMessage/WHSE_CURR_STATE_NOTIONAL_AMT"/>
<xsl:variable name="whse_curr_state_notional_ccy" select="/TiwCsvMessage/WHSE_CURR_STATE_NOTIONAL_CCY"/>
<xsl:variable name="whse_status" select="/TiwCsvMessage/WHSE_STATUS"/>
<xsl:variable name="whse_status_reason" select="/TiwCsvMessage/WHSE_STATUS_REASON"/>
<xsl:variable name="whse_curr_state_notional_dt" select="/TiwCsvMessage/WHSE_CURR_STATE_NOTIONAL_DT"/>
<xsl:variable name="aff_notional_amt" select="/TiwCsvMessage/AFF_NOTIONAL_AMT"/>
<xsl:variable name="aff_notional_ccy" select="/TiwCsvMessage/AFF_NOTIONAL_CCY"/>
<xsl:variable name="aff_notional_transaction_type" select="/TiwCsvMessage/AFF_NOTIONAL_TRANSACTION_TYPE"/>
<xsl:variable name="back_load_effective_dt" select="/TiwCsvMessage/BACK_LOAD_EFFECTIVE_DT"/>
<xsl:variable name="whse_insert_dt" select="/TiwCsvMessage/WHSE_INSERT_DT"/>
<xsl:variable name="trade_dt" select="/TiwCsvMessage/TRADE_DT"/>
<xsl:variable name="effective_dt" select="/TiwCsvMessage/EFFECTIVE_DT"/>
<xsl:variable name="sched_term_dt_expiration_dt" select="/TiwCsvMessage/SCHED_TERM_DT_EXPIRATION_DT"/>
<xsl:variable name="first_pymt_dt" select="/TiwCsvMessage/FIRST_PYMT_DT"/>
<xsl:variable name="reference_obligation" select="/TiwCsvMessage/REFERENCE_OBLIGATION"/>
<xsl:variable name="reference_entity_name" select="/TiwCsvMessage/REFERENCE_ENTITY_NAME"/>
<xsl:variable name="reference_entity_id" select="/TiwCsvMessage/REFERENCE_ENTITY_ID"/>
<xsl:variable name="mdtt" select="/TiwCsvMessage/MDTT"/>
<xsl:variable name="master_confirm_agreement_dt" select="/TiwCsvMessage/MASTER_CONFIRM_AGREEMENT_DT"/>
<xsl:variable name="fxd_rate_payer_swaption_buyer" select="/TiwCsvMessage/FXD_RATE_PAYER_SWAPTION_BUYER"/>
<xsl:variable name="buyer_name" select="/TiwCsvMessage/BUYER_NAME"/>
<xsl:variable name="flt_rate_payer_swaption_seller" select="/TiwCsvMessage/FLT_RATE_PAYER_SWAPTION_SELLER"/>
<xsl:variable name="seller_name" select="/TiwCsvMessage/SELLER_NAME"/>
<xsl:variable name="fxd_rate" select="/TiwCsvMessage/FXD_RATE"/>
<xsl:variable name="flt_rate_ccy" select="/TiwCsvMessage/FLT_RATE_CCY"/>
<xsl:variable name="pymt_frequency" select="/TiwCsvMessage/PYMT_FREQUENCY"/>
<xsl:variable name="pymt_multiplier" select="/TiwCsvMessage/PYMT_MULTIPLIER"/>
<xsl:variable name="restructuring_event" select="/TiwCsvMessage/RESTRUCTURING_EVENT"/>
<xsl:variable name="add_terms" select="/TiwCsvMessage/ADD_TERMS"/>
<xsl:variable name="excluded_deliverables" select="/TiwCsvMessage/EXCLUDED_DELIVERABLES"/>
<xsl:variable name="independent_payer" select="/TiwCsvMessage/INDEPENDENT_PAYER"/>
<xsl:variable name="independent_receiver" select="/TiwCsvMessage/INDEPENDENT_RECEIVER"/>
<xsl:variable name="independent_percent" select="/TiwCsvMessage/INDEPENDENT_PERCENT"/>
<xsl:variable name="single_pymt_dt_prem_pymt_dt" select="/TiwCsvMessage/SINGLE_PYMT_DT_PREM_PYMT_DT"/>
<xsl:variable name="single_pymt_amt_prem_pymt_amt" select="/TiwCsvMessage/SINGLE_PYMT_AMT_PREM_PYMT_AMT"/>
<xsl:variable name="single_pymt_ccy_prem_pymt_ccy" select="/TiwCsvMessage/SINGLE_PYMT_CCY_PREM_PYMT_CCY"/>
<xsl:variable name="calc_agt_business_center_code" select="/TiwCsvMessage/CALC_AGT_BUSINESS_CENTER_CODE"/>
<xsl:variable name="calc_agt_business_center_name" select="/TiwCsvMessage/CALC_AGT_BUSINESS_CENTER_NAME"/>
<xsl:variable name="init_pymt_payer" select="/TiwCsvMessage/INIT_PYMT_PAYER"/>
<xsl:variable name="init_pymt_receiver" select="/TiwCsvMessage/INIT_PYMT_RECEIVER"/>
<xsl:variable name="init_pymt_amt_prem_pymt_amt" select="/TiwCsvMessage/INIT_PYMT_AMT_PREM_PYMT_AMT"/>
<xsl:variable name="init_pymt_ccy_prem_pymt_ccy" select="/TiwCsvMessage/INIT_PYMT_CCY_PREM_PYMT_CCY"/>
<xsl:variable name="master_confirm_annex_dt" select="/TiwCsvMessage/MASTER_CONFIRM_ANNEX_DT"/>
<xsl:variable name="documentation_type" select="/TiwCsvMessage/DOCUMENTATION_TYPE"/>
<xsl:variable name="calc_agt" select="/TiwCsvMessage/CALC_AGT"/>
<xsl:variable name="add_provisions_for_monoline" select="/TiwCsvMessage/ADD_PROVISIONS_FOR_MONOLINE"/>
<xsl:variable name="master_agreement_type" select="/TiwCsvMessage/MASTER_AGREEMENT_TYPE"/>
<xsl:variable name="master_agreement_dt" select="/TiwCsvMessage/MASTER_AGREEMENT_DT"/>
<xsl:variable name="attachment_point" select="/TiwCsvMessage/ATTACHMENT_POINT"/>
<xsl:variable name="exhaustion_point" select="/TiwCsvMessage/EXHAUSTION_POINT"/>
<xsl:variable name="modified_equity_delivery" select="/TiwCsvMessage/MODIFIED_EQUITY_DELIVERY"/>
<xsl:variable name="settled_entity_matrix_source" select="/TiwCsvMessage/SETTLED_ENTITY_MATRIX_SOURCE"/>
<xsl:variable name="settled_entity_matrix_dt" select="/TiwCsvMessage/SETTLED_ENTITY_MATRIX_DT"/>
<xsl:variable name="super_id" select="/TiwCsvMessage/SUPER_ID"/>
<xsl:variable name="desk_id" select="/TiwCsvMessage/DESK_ID"/>
<xsl:variable name="designated_party_id" select="/TiwCsvMessage/DESIGNATED_PARTY_ID"/>
<xsl:variable name="e_trading_trn" select="/TiwCsvMessage/E_TRADING_TRN"/>
<xsl:variable name="broker_name" select="/TiwCsvMessage/BROKER_NAME"/>
<xsl:variable name="cmnt" select="/TiwCsvMessage/CMNT"/>
<xsl:variable name="ctpy_super_id" select="/TiwCsvMessage/CTPY_SUPER_ID"/>
<xsl:variable name="ctpy_desk_id" select="/TiwCsvMessage/CTPY_DESK_ID"/>
<xsl:variable name="ctpy_designated_party_id" select="/TiwCsvMessage/CTPY_DESIGNATED_PARTY_ID"/>
<xsl:variable name="ctpy_e_trading_trn" select="/TiwCsvMessage/CTPY_E_TRADING_TRN"/>
<xsl:variable name="ctpy_broker_name" select="/TiwCsvMessage/CTPY_BROKER_NAME"/>
<xsl:variable name="vendor_reference_number" select="/TiwCsvMessage/VENDOR_REFERENCE_NUMBER"/>
<xsl:variable name="vendor_id" select="/TiwCsvMessage/VENDOR_ID"/>
<xsl:variable name="push_status" select="/TiwCsvMessage/PUSH_STATUS"/>
<xsl:variable name="link_status" select="/TiwCsvMessage/LINK_STATUS"/>
<xsl:variable name="master_confirm_type" select="/TiwCsvMessage/MASTER_CONFIRM_TYPE"/>
<xsl:variable name="matrix_transaction_type" select="/TiwCsvMessage/MATRIX_TRANSACTION_TYPE"/>
<xsl:variable name="standard_terms_supplement_type" select="/TiwCsvMessage/STANDARD_TERMS_SUPPLEMENT_TYPE"/>
<xsl:variable name="unconfirmed_notional" select="/TiwCsvMessage/UNCONFIRMED_NOTIONAL"/>
<xsl:variable name="business_day" select="/TiwCsvMessage/BUSINESS_DAY"/>
<xsl:variable name="reference_policy_app" select="/TiwCsvMessage/REFERENCE_POLICY_APP"/>
<xsl:variable name="reference_price" select="/TiwCsvMessage/REFERENCE_PRICE"/>
<xsl:variable name="fxd_amt_pymt_delay_app" select="/TiwCsvMessage/FXD_AMT_PYMT_DELAY_APP"/>
<xsl:variable name="int_shortfall_cap_app" select="/TiwCsvMessage/INT_SHORTFALL_CAP_APP"/>
<xsl:variable name="int_shortfall_cap_basis" select="/TiwCsvMessage/INT_SHORTFALL_CAP_BASIS"/>
<xsl:variable name="int_shortfall_comp_app" select="/TiwCsvMessage/INT_SHORTFALL_COMP_APP"/>
<xsl:variable name="rate_source" select="/TiwCsvMessage/RATE_SOURCE"/>
<xsl:variable name="optional_early_term_app" select="/TiwCsvMessage/OPTIONAL_EARLY_TERM_APP"/>
<xsl:variable name="bloomberg_id" select="/TiwCsvMessage/BLOOMBERG_ID"/>
<xsl:variable name="insurer" select="/TiwCsvMessage/INSURER"/>
<xsl:variable name="legal_final_maturity_dt" select="/TiwCsvMessage/LEGAL_FINAL_MATURITY_DT"/>
<xsl:variable name="orig_principal_amt" select="/TiwCsvMessage/ORIG_PRINCIPAL_AMT"/>
<xsl:variable name="init_factor" select="/TiwCsvMessage/INIT_FACTOR"/>
<xsl:variable name="step_up_provisions_app" select="/TiwCsvMessage/STEP_UP_PROVISIONS_APP"/>
<xsl:variable name="wac_cap_int_provision_app" select="/TiwCsvMessage/WAC_CAP_INT_PROVISION_APP"/>
<xsl:variable name="facility_type" select="/TiwCsvMessage/FACILITY_TYPE"/>
<xsl:variable name="name_of_borrower" select="/TiwCsvMessage/NAME_OF_BORROWER"/>
<xsl:variable name="designated_priority" select="/TiwCsvMessage/DESIGNATED_PRIORITY"/>
<xsl:variable name="secured_list_app" select="/TiwCsvMessage/SECURED_LIST_APP"/>
<xsl:variable name="new_secured_list_app" select="/TiwCsvMessage/NEW_SECURED_LIST_APP"/>
<xsl:variable name="orig_trade_dt" select="/TiwCsvMessage/ORIG_TRADE_DT"/>
<xsl:variable name="orig_effective_dt" select="/TiwCsvMessage/ORIG_EFFECTIVE_DT"/>
<xsl:variable name="calc_flag" select="/TiwCsvMessage/CALC_FLAG"/>
<xsl:variable name="curr_factor" select="/TiwCsvMessage/CURR_FACTOR"/>
<xsl:variable name="new_reference_entity_id" select="/TiwCsvMessage/NEW_REFERENCE_ENTITY_ID"/>
<xsl:variable name="new_reference_entity_name" select="/TiwCsvMessage/NEW_REFERENCE_ENTITY_NAME"/>
<xsl:variable name="cash_settlement_only" select="/TiwCsvMessage/CASH_SETTLEMENT_ONLY"/>
<xsl:variable name="delivery_of_commitments" select="/TiwCsvMessage/DELIVERY_OF_COMMITMENTS"/>
<xsl:variable name="continuity" select="/TiwCsvMessage/CONTINUITY"/>
<xsl:variable name="first_pymt_period_acc_start_dt" select="/TiwCsvMessage/FIRST_PYMT_PERIOD_ACC_START_DT"/>
<xsl:variable name="orig_first_fxd_rate_pymt_dt" select="/TiwCsvMessage/ORIG_FIRST_FXD_RATE_PYMT_DT"/>
<xsl:variable name="orig_first_period_acc_start_dt" select="/TiwCsvMessage/ORIG_FIRST_PERIOD_ACC_START_DT"/>
<xsl:variable name="contraparty_firm_account_name" select="/TiwCsvMessage/CONTRAPARTY_FIRM_ACCOUNT_NAME"/>
<xsl:variable name="under_sched_term_dt" select="/TiwCsvMessage/UNDER_SCHED_TERM_DT"/>
<xsl:variable name="under_fxd_rate_payer" select="/TiwCsvMessage/UNDER_FXD_RATE_PAYER"/>
<xsl:variable name="under_flt_rate_payer" select="/TiwCsvMessage/UNDER_FLT_RATE_PAYER"/>
<xsl:variable name="quoting_style" select="/TiwCsvMessage/QUOTING_STYLE"/>
<xsl:variable name="option_style" select="/TiwCsvMessage/OPTION_STYLE"/>
<xsl:variable name="strike_price" select="/TiwCsvMessage/STRIKE_PRICE"/>
<xsl:variable name="swaption_settlement_style" select="/TiwCsvMessage/SWAPTION_SETTLEMENT_STYLE"/>
<xsl:variable name="under_mdtt" select="/TiwCsvMessage/UNDER_MDTT"/>
<xsl:variable name="under_master_document_dt" select="/TiwCsvMessage/UNDER_MASTER_DOCUMENT_DT"/>
<xsl:variable name="exercise_event_type" select="/TiwCsvMessage/EXERCISE_EVENT_TYPE"/>
<xsl:variable name="exercise_dt" select="/TiwCsvMessage/EXERCISE_DT"/>
<xsl:variable name="recovery_price" select="/TiwCsvMessage/RECOVERY_PRICE"/>
<xsl:variable name="fxd_settlement" select="/TiwCsvMessage/FXD_SETTLEMENT"/>
<xsl:variable name="usi_uti_id" select="/TiwCsvMessage/USI_UTI_ID"/>
<xsl:variable name="usi_uti_prefix" select="/TiwCsvMessage/USI_UTI_PREFIX"/>
<xsl:variable name="ccp_for_under_swap" select="/TiwCsvMessage/CCP_FOR_UNDER_SWAP"/>
<xsl:variable name="branch_loc" select="/TiwCsvMessage/BRANCH_LOC"/>
<xsl:variable name="mid_market_price_type" select="/TiwCsvMessage/MID_MARKET_PRICE_TYPE"/>
<xsl:variable name="mid_market_price_value" select="/TiwCsvMessage/MID_MARKET_PRICE_VALUE"/>
<xsl:variable name="counter_branch_loc" select="/TiwCsvMessage/COUNTER_BRANCH_LOC"/>
<xsl:variable name="counter_mid_market_price_type" select="/TiwCsvMessage/COUNTER_MID_MARKET_PRICE_TYPE"/>
<xsl:variable name="counter_mid_market_price_value" select="/TiwCsvMessage/COUNTER_MID_MARKET_PRICE_VALUE"/>
<xsl:variable name="event_processing_id" select="/TiwCsvMessage/EVENT_PROCESSING_ID"/>
<xsl:variable name="execution_timestamp" select="/TiwCsvMessage/EXECUTION_TIMESTAMP"/>
<xsl:variable name="execution_venue" select="/TiwCsvMessage/EXECUTION_VENUE"/>
<xsl:variable name="clearing_dco" select="/TiwCsvMessage/CLEARING_DCO"/>
<xsl:variable name="nonstandard_flag" select="/TiwCsvMessage/NONSTANDARD_FLAG"/>
<xsl:variable name="off_platform_verification" select="/TiwCsvMessage/OFF_PLATFORM_VERIFICATION"/>
<xsl:variable name="participant_uci_id" select="/TiwCsvMessage/PARTICIPANT_UCI_ID"/>
<xsl:variable name="contra_uci_id" select="/TiwCsvMessage/CONTRA_UCI_ID"/>
<xsl:variable name="swap_instrument_id" select="/TiwCsvMessage/SWAP_INSTRUMENT_ID"/>
<xsl:variable name="reporting_desk_id" select="/TiwCsvMessage/REPORTING_DESK_ID"/>
<xsl:variable name="desk_loc" select="/TiwCsvMessage/DESK_LOC"/>
<xsl:variable name="collateralized" select="/TiwCsvMessage/COLLATERALIZED"/>
<xsl:variable name="reporting_broker_id" select="/TiwCsvMessage/REPORTING_BROKER_ID"/>
<xsl:variable name="broker_loc" select="/TiwCsvMessage/BROKER_LOC"/>
<xsl:variable name="trader_id" select="/TiwCsvMessage/TRADER_ID"/>
<xsl:variable name="trader_loc" select="/TiwCsvMessage/TRADER_LOC"/>
<xsl:variable name="sales_id" select="/TiwCsvMessage/SALES_ID"/>
<xsl:variable name="sales_loc" select="/TiwCsvMessage/SALES_LOC"/>
<xsl:variable name="prior_usi_uti_prefix" select="/TiwCsvMessage/PRIOR_USI_UTI_PREFIX"/>
<xsl:variable name="prior_usi_uti_id" select="/TiwCsvMessage/PRIOR_USI_UTI_ID"/>
<xsl:variable name="block_usi_uti_prefix" select="/TiwCsvMessage/BLOCK_USI_UTI_PREFIX"/>
<xsl:variable name="block_usi_uti" select="/TiwCsvMessage/BLOCK_USI_UTI"/>
<xsl:variable name="product_id_prefix" select="/TiwCsvMessage/PRODUCT_ID_PREFIX"/>
<xsl:variable name="product_id" select="/TiwCsvMessage/PRODUCT_ID"/>
<xsl:variable name="clearing_exception_party" select="/TiwCsvMessage/CLEARING_EXCEPTION_PARTY"/>
<xsl:variable name="price_forming_flag" select="/TiwCsvMessage/PRICE_FORMING_FLAG"/>
<xsl:variable name="novation_fee_usi_uti_prefix" select="/TiwCsvMessage/NOVATION_FEE_USI_UTI_PREFIX"/>
<xsl:variable name="novation_fee_usi_uti" select="/TiwCsvMessage/NOVATION_FEE_USI_UTI"/>
<xsl:variable name="submitted_for" select="/TiwCsvMessage/SUBMITTED_FOR"/>
<xsl:variable name="execution_agt_party_prefix" select="/TiwCsvMessage/EXECUTION_AGT_PARTY_PREFIX"/>
<xsl:variable name="execution_agt_party_value" select="/TiwCsvMessage/EXECUTION_AGT_PARTY_VALUE"/>
<xsl:variable name="alloc_indicator" select="/TiwCsvMessage/ALLOC_INDICATOR"/>
<xsl:variable name="trade_party1_value" select="/TiwCsvMessage/TRADE_PARTY1_VALUE"/>
<xsl:variable name="trade_party1_prefix" select="/TiwCsvMessage/TRADE_PARTY1_PREFIX"/>
<xsl:variable name="trade_party2_value" select="/TiwCsvMessage/TRADE_PARTY2_VALUE"/>
<xsl:variable name="trade_party2_prefix" select="/TiwCsvMessage/TRADE_PARTY2_PREFIX"/>
<xsl:variable name="data_submitter_prefix" select="/TiwCsvMessage/DATA_SUBMITTER_PREFIX"/>
<xsl:variable name="data_submitter" select="/TiwCsvMessage/DATA_SUBMITTER"/>
<xsl:variable name="primary_assetclass" select="/TiwCsvMessage/PRIMARY_ASSETCLASS"/>
<xsl:variable name="secondary_assetclass" select="/TiwCsvMessage/SECONDARY_ASSETCLASS"/>
<xsl:variable name="confirmation_type" select="/TiwCsvMessage/CONFIRMATION_TYPE"/>
<xsl:variable name="option_type" select="/TiwCsvMessage/OPTION_TYPE"/>
<xsl:variable name="clearing_status" select="/TiwCsvMessage/CLEARING_STATUS"/>
<xsl:variable name="clearing_timestamp" select="/TiwCsvMessage/CLEARING_TIMESTAMP"/>
<xsl:variable name="contractual_definition" select="/TiwCsvMessage/CONTRACTUAL_DEFINITION"/>
<xsl:variable name="credit_agreement_dt">some_date</xsl:variable>
<xsl:variable name="category">some_category</xsl:variable>
<xsl:variable name="add_price_notation_price_type" select="/TiwCsvMessage/ADD_PRICE_NOTATION_PRICE_TYPE"/>
<xsl:variable name="add_price_notation_price" select="/TiwCsvMessage/ADD_PRICE_NOTATION_PRICE"/>
<xsl:variable name="price_notation_price_type" select="/TiwCsvMessage/PRICE_NOTATION_PRICE_TYPE"/>
<xsl:variable name="price_notation_price" select="/TiwCsvMessage/PRICE_NOTATION_PRICE"/>
<xsl:variable name="cftc_reporting_jurisdiction" select="/TiwCsvMessage/CFTC_REPORTING_JURISDICTION"/>
<xsl:variable name="cftc_reporting_ctpy" select="/TiwCsvMessage/REPORTING_CTPY"/>
<xsl:variable name="cftc_nondisclosure" select="/TiwCsvMessage/CFTC_NONDISCLOSURE"/>
<xsl:variable name="cftc_clearing_flag" select="/TiwCsvMessage/CFTC_CLEARING_FLAG"/>
<xsl:variable name="esma_reporting_jurisdiction" select="/TiwCsvMessage/ESMA_REPORTING_JURISDICTION"/>
<xsl:variable name="esma_nondisclosure" select="/TiwCsvMessage/ESMA_NONDISCLOSURE"/>
<xsl:variable name="esma_clearing_flag" select="/TiwCsvMessage/ESMA_CLEARING_FLAG"/>
<xsl:variable name="esma_ben_prefix" select="/TiwCsvMessage/ESMA_BEN_PREFIX"/>
<xsl:variable name="esma_ben_party_to_the_trade" select="/TiwCsvMessage/ESMA_BEN_PARTY_TO_THE_TRADE"/>
<xsl:variable name="esma_collateral_portfolio_code" select="/TiwCsvMessage/ESMA_COLLATERAL_PORTFOLIO_CODE"/>
<xsl:variable name="esma_compression" select="/TiwCsvMessage/ESMA_COMPRESSION"/>
<xsl:variable name="esma_comm_act_treasury_fin" select="/TiwCsvMessage/ESMA_COMM_ACT_TREASURY_FIN"/>
<xsl:variable name="esma_intragroup" select="/TiwCsvMessage/ESMA_INTRAGROUP"/>
<xsl:variable name="esma_trading_capacity" select="/TiwCsvMessage/ESMA_TRADING_CAPACITY"/>
<xsl:variable name="esma_branch_loc_country_code" select="/TiwCsvMessage/ESMA_BRANCH_LOC_COUNTRY_CODE"/>
<xsl:variable name="jfsa_reporting_jurisdiction" select="/TiwCsvMessage/JFSA_REPORTING_JURISDICTION"/>
<xsl:variable name="jfsa_nondisclosure" select="/TiwCsvMessage/JFSA_NONDISCLOSURE"/>
<xsl:variable name="jfsa_clearing_flag" select="/TiwCsvMessage/JFSA_CLEARING_FLAG"/>
<xsl:variable name="jfsa_branch_bic" select="/TiwCsvMessage/JFSA_BRANCH_BIC"/>
<xsl:variable name="asic_reporting_jurisdiction" select="/TiwCsvMessage/ASIC_REPORTING_JURISDICTION"/>
<xsl:variable name="asic_nondisclosure" select="/TiwCsvMessage/ASIC_NONDISCLOSURE"/>
<xsl:variable name="asic_clearing_flag" select="/TiwCsvMessage/ASIC_CLEARING_FLAG"/>
<xsl:variable name="mas_reporting_jurisdiction" select="/TiwCsvMessage/MAS_REPORTING_JURISDICTION"/>
<xsl:variable name="mas_nondisclosure" select="/TiwCsvMessage/MAS_NONDISCLOSURE"/>
<xsl:variable name="mas_clearing_flag" select="/TiwCsvMessage/MAS_CLEARING_FLAG"/>
<xsl:variable name="can_reporting_jurisdiction" select="/TiwCsvMessage/CANADA_REPORTING_JURISDICTION"/>
<xsl:variable name="can_reporting_ctpy" select="/TiwCsvMessage/CANADA_REPORTING_CTPY"/>
<xsl:variable name="can_nondisclosure" select="/TiwCsvMessage/CANADA_NONDISCLOSURE"/>
<xsl:variable name="can_clearing_flag" select="/TiwCsvMessage/CANADA_CLEARING_FLAG"/>
<xsl:variable name="can_reporting_locations_a">
<xsl:choose>
<xsl:when test="$partyAId = $dtcc_account_number"><xsl:value-of select="/TiwCsvMessage/REPORTABLE_LOCATION"/></xsl:when>
<xsl:otherwise><xsl:value-of select="/TiwCsvMessage/REPORTABLE_LOCATION_CTPY"/></xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="can_reporting_locations_b">
<xsl:choose>
<xsl:when test="$partyBId = $dtcc_account_number"><xsl:value-of select="/TiwCsvMessage/REPORTABLE_LOCATION"/></xsl:when>
<xsl:otherwise><xsl:value-of select="/TiwCsvMessage/REPORTABLE_LOCATION_CTPY"/></xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="roll_day">20</xsl:variable>
<xsl:variable name="rolls_type">
<xsl:variable name="termDateMMDD" select="substring($sched_term_dt_expiration_dt,1,6)"/>
<xsl:choose>
<xsl:when test="($roll_day='20' and ($termDateMMDD='20-Mar' or $termDateMMDD='20-Jun' or $termDateMMDD='20-Sep' or $termDateMMDD='20-Dec')) or not($pymt_frequency) ">Standard</xsl:when>
<xsl:otherwise>Custom</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="product_type">
<xsl:call-template name="getProductTypeFromTiwRec">
<xsl:with-param name="dsm_product_type" select="/TiwCsvMessage/PRODUCT_TYPE"/>
<xsl:with-param name="dsm_mdtt" select="$mdtt"/>
</xsl:call-template>
</xsl:variable>
<xsl:variable name="docs_type">
<xsl:call-template name="getDocsTypeFromTiwRec">
<xsl:with-param name="mw_product_type" select="$product_type"/>
<xsl:with-param name="dsm_mdtt" select="$mdtt"/>
</xsl:call-template>
</xsl:variable>
<xsl:variable name="sub_product">
<xsl:variable name="sp" select="/TiwCsvMessage/SUB_PRODUCT"/>
<xsl:choose>
<xsl:when test="$product_type = 'CDS Matrix'">
<xsl:choose>
<xsl:when test="contains($add_provisions_for_monoline, 'ISDARecoveryLock') and (string-length($recovery_price) or string-length($fxd_settlement))">CDS Single Name - Recovery Lock</xsl:when>
<xsl:when test="contains($add_provisions_for_monoline, 'ISDAFixedRecovery') and string-length($recovery_price)">CDS Single Name - Fixed Recovery</xsl:when>
<xsl:otherwise>CDS Single Name - CDS Matrix</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$product_type = 'CDS on Loans'">
<xsl:choose>
<xsl:when test="$standard_terms_supplement_type = 'StandardLCDSBullet'">Bullet LCDS</xsl:when>
<xsl:when test="$standard_terms_supplement_type = 'CDSonLeveragedLoans'">ELCDS</xsl:when>
<xsl:when test="$standard_terms_supplement_type = 'StandardTermsSupplement'">LCDS</xsl:when>
<xsl:otherwise><xsl:value-of select="concat($standard_terms_supplement_type, ': CDS on Loans sub-product not yet supported on MW')"/></xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:otherwise><xsl:value-of select="$sp"/></xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="tenor">
<xsl:choose>
<xsl:when test="($product_type='CDS Index' or $product_type='CDS Index Swaption') and (string-length($effective_dt) = 0)">5Y</xsl:when>
<xsl:when test="($product_type='CDS Index' or $product_type='CDS Index Swaption') and (string-length($effective_dt) &gt; 0)">
<xsl:variable name="effDateYear" select="substring($effective_dt, 8, 4)"/>
<xsl:variable name="termDateYear" select="substring($sched_term_dt_expiration_dt, 8, 4)"/>
<xsl:variable name="effDateMonth">
<xsl:call-template name="getMonthAsNumber">
<xsl:with-param name="monthstring" select="substring($effective_dt, 4, 3)"/>
</xsl:call-template>
</xsl:variable>
<xsl:variable name="termDateMonth">
<xsl:call-template name="getMonthAsNumber">
<xsl:with-param name="monthstring" select="substring($sched_term_dt_expiration_dt, 4, 3)"/>
</xsl:call-template>
</xsl:variable>
<xsl:variable name="termInMonths" select="string(((number($termDateYear) - number($effDateYear)) * 12) + number($termDateMonth) - number($effDateMonth))"/>
<xsl:choose>
<xsl:when test="number($termInMonths)&gt;=120">10Y</xsl:when>
<xsl:when test="number($termInMonths)&gt;=84">7Y</xsl:when>
<xsl:when test="number($termInMonths)&gt;=60">5Y</xsl:when>
<xsl:when test="number($termInMonths)&gt;=48">4Y</xsl:when>
<xsl:when test="number($termInMonths)&gt;=36">3Y</xsl:when>
<xsl:when test="number($termInMonths)&gt;=24">2Y</xsl:when>
<xsl:otherwise>1Y</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:otherwise>
<xsl:variable name="startDateMonth">
<xsl:call-template name="getMonthAsNumber">
<xsl:with-param name="monthstring" select="substring($effective_dt, 4, 3)"/>
</xsl:call-template>
</xsl:variable>
<xsl:variable name="endDateMonth">
<xsl:call-template name="getMonthAsNumber">
<xsl:with-param name="monthstring" select="substring($sched_term_dt_expiration_dt, 4, 3)"/>
</xsl:call-template>
</xsl:variable>
<xsl:variable name="startDateYear" select="string(number(substring($effective_dt,8,4)))"/>
<xsl:variable name="endDateYear" select="string(number(substring($sched_term_dt_expiration_dt,8,4)))"/>
<xsl:variable name="startDateDay" select="string(number(substring($effective_dt,1,2)))"/>
<xsl:variable name="endDateDay" select="string(number(substring($sched_term_dt_expiration_dt,1,2)))"/>
<xsl:variable name="tenorMultiplier">
<xsl:choose>
<xsl:when test="number($startDateDay) &gt; number($endDateDay)">
<xsl:value-of select="(((number($endDateYear) - number($startDateYear))*12) + (number($endDateMonth) - number($startDateMonth))-1)"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="((number($endDateYear) - number($startDateYear))*12) + (number($endDateMonth) - number($startDateMonth))"/>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="remainder" select="string(number($tenorMultiplier) mod 3)"/>
<xsl:variable name="tenorMultiplier_RoundOff" select="string(number($tenorMultiplier) - number($remainder))"/>
<xsl:choose>
<xsl:when test="$tenorMultiplier_RoundOff &gt;= 1">
<xsl:value-of select="concat($tenorMultiplier_RoundOff,'M')"/>
</xsl:when>
<xsl:otherwise>0M</xsl:otherwise>
</xsl:choose>
</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="is_structured_index">
<xsl:choose>
<xsl:when test="$mdtt = 'ABX'">true</xsl:when>
<xsl:when test="$mdtt = 'ABXTranche'">true</xsl:when>
<xsl:when test="$mdtt = 'CMBX'">true</xsl:when>
<xsl:when test="$mdtt = 'IOS'">true</xsl:when>
<xsl:when test="$mdtt = 'MBX'">true</xsl:when>
<xsl:when test="$mdtt = 'PO'">true</xsl:when>
<xsl:when test="$mdtt = 'PrimeX'">true</xsl:when>
<xsl:when test="$mdtt = 'TRX'">true</xsl:when>
<xsl:when test="$mdtt = 'TRX.II'">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:variable name="tiwtri">
<xsl:variable name="dtri_prefix" select="substring($dtcc_trade_reference_id,1,8)"/>
<xsl:variable name="dtri_infix" select="substring($dtcc_trade_reference_id,9,1)"/>
<xsl:variable name="dtri_postfix" select="substring($dtcc_trade_reference_id,10)"/>
<xsl:choose>
<xsl:when test="$dtri_infix = 'D'"><xsl:value-of select="concat($dtri_prefix, '.', $dtri_postfix)"/></xsl:when>
<xsl:otherwise><xsl:value-of select="$dtcc_trade_reference_id"/></xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:template match="/">
<xsl:choose>
<xsl:when test="$active_status = 'Inactive'">
<xsl:call-template name="ntd"/>
</xsl:when>
<xsl:otherwise>
<xsl:call-template name="swdml"/>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template name="ntd">
<TIWNTDTrade>
<ProductType/>
<PartyAId><xsl:value-of select="$partyAId"/></PartyAId>
<PartyAIdType>DTCC</PartyAIdType>
<PartyBId><xsl:value-of select="$partyBId"/></PartyBId>
<PartyBIdType>DTCC</PartyBIdType>
<ExitReason/>
<EffectiveDate/>
<TIWDTCCTRI><xsl:value-of select="$tiwtri"/></TIWDTCCTRI>
<TIWActiveStatus><xsl:value-of select="$active_status"/></TIWActiveStatus>
<TIWValueDate><xsl:value-of select="substring($msg_value_date,1,19)"/></TIWValueDate>
</TIWNTDTrade>
</xsl:template>
<xsl:template name="swdml">
<SWDMLTrade version="4-9">
<SWDMLVersion>Match</SWDMLVersion>
<ReplacementTradeId/>
<ReplacementTradeIdType/>
<ReplacementReason/>
<ShortFormInput>false</ShortFormInput>
<ProductType><xsl:value-of select="$product_type"/></ProductType>
<ProductSubType><xsl:value-of select="$sub_product"/></ProductSubType>
<ParticipantSupplement/>
<ConditionPrecedentBondId/>
<ConditionPrecedentBondMaturity/>
<AllocatedTrade>false</AllocatedTrade>
<PrimeBrokerTrade>false</PrimeBrokerTrade>
<ReversePrimeBrokerLegalEntities>false</ReversePrimeBrokerLegalEntities>
<PartyAId><xsl:value-of select="$partyAId"/></PartyAId>
<PartyAIdType>DTCC</PartyAIdType>
<PartyBId><xsl:value-of select="$partyBId"/></PartyBId>
<PartyBIdType>DTCC</PartyBIdType>
<PartyCId/>
<PartyCIdType/>
<PartyDId/>
<PartyDIdType/>
<PartyGId/>
<PartyGIdType/>
<Interoperable/>
<ExternalInteropabilityId/>
<InteropNettingString/>
<DirectionA>
<xsl:choose>
<xsl:when test="$fxd_rate_payer_swaption_buyer = 'partyA'">Buy</xsl:when>
<xsl:otherwise>Sell</xsl:otherwise>
</xsl:choose>
</DirectionA>
<TradeDate><xsl:value-of select="$trade_dt"/></TradeDate>
<StartDateTenor/>
<EndDateTenor/>
<StartDateDay/>
<Tenor><xsl:value-of select="$tenor"/></Tenor>
<StartDate><xsl:value-of select="$effective_dt"/></StartDate>
<FirstFixedPeriodStartDate/>
<FirstFloatPeriodStartDate/>
<FirstFloatPeriodStartDate_2/>
<EndDate><xsl:value-of select="$sched_term_dt_expiration_dt"/></EndDate>
<FixedPaymentFreq><xsl:value-of select="concat($pymt_multiplier, $pymt_frequency)"/></FixedPaymentFreq>
<FixedPaymentFreq_2/>
<FloatPaymentFreq/>
<FloatPaymentFreq_2/>
<FloatRollFreq/>
<FloatRollFreq_2/>
<RollsType>
<xsl:if test="$product_type='CDS' or $product_type='CDS Matrix' or $product_type='CDS on Loans' or $product_type='CDS Master'">
<xsl:value-of select="$rolls_type"/>
</xsl:if>
</RollsType>
<RollsMethod/>
<RollDay>
<xsl:if test="$product_type='CDS' or $product_type='CDS Matrix' or $product_type='CDS on Loans' or $product_type='CDS Master'">
<xsl:value-of select="$roll_day"/>
</xsl:if>
</RollDay>
<MonthEndRolls/>
<FirstPeriodStartDate>
<xsl:if test="($product_type='CDS Matrix' or $product_type='CDS on Loans' or $product_type='CDS Master') and $first_pymt_period_acc_start_dt">
<xsl:value-of select="$first_pymt_period_acc_start_dt"/>
</xsl:if>
</FirstPeriodStartDate>
<FirstPaymentDate><xsl:value-of select="$first_pymt_dt"/></FirstPaymentDate>
<LastRegularPaymentDate/>
<FixedRate><xsl:value-of select="$fxd_rate div 100"/></FixedRate>
<FixedRate_2/>
<initialPoints/>
<quotationStyle><xsl:value-of select="$quoting_style"/></quotationStyle>
<RecoveryRate>
<xsl:if test="contains($sub_product, 'Recovery')">
<xsl:value-of select="$recovery_price div 100"/>
</xsl:if>
</RecoveryRate>
<FixedSettlement>
<xsl:if test="$product_type='CDS Matrix'">
<xsl:value-of select="$fxd_settlement"/>
</xsl:if>
</FixedSettlement>
<Currency><xsl:value-of select="$whse_curr_state_notional_ccy"/></Currency>
<Currency_2/>
<Notional><xsl:value-of select="$whse_curr_state_notional_amt"/></Notional>
<Notional_2/>
<InitialNotional/>
<FixedAmount/>
<FixedAmountCurrency/>
<FixedDayBasis/>
<FloatDayBasis/>
<FloatDayBasis_2/>
<FixedConvention/>
<FixedCalcPeriodDatesConvention/>
<FixedTerminationDateConvention/>
<FloatConvention/>
<FloatCalcPeriodDatesConvention/>
<FloatTerminationDateConvention/>
<FloatConvention_2/>
<FloatTerminationDateConvention_2/>
<FloatingRateIndex/>
<FloatingRateIndex_2/>
<InflationLag/>
<IndexSource/>
<InterpolationMethod/>
<InitialIndexLevel/>
<RelatedBond/>
<IndexTenor1/>
<IndexTenor1_2/>
<LinearInterpolation/>
<LinearInterpolation_2/>
<IndexTenor2/>
<IndexTenor2_2/>
<InitialInterpolationIndex/>
<InitialInterpolationIndex_2/>
<SpreadOverIndex/>
<SpreadOverIndex_2/>
<FirstFixingRate/>
<FirstFixingRate_2/>
<FixingDaysOffset/>
<FixingDaysOffset_2/>
<FixingHolidayCentres/>
<FixingHolidayCentres_2/>
<ResetInArrears/>
<ResetInArrears_2/>
<FirstFixingDifferent/>
<FirstFixingDifferent_2/>
<FirstFixingDaysOffset/>
<FirstFixingDaysOffset_2/>
<FirstFixingHolidayCentres/>
<FirstFixingHolidayCentres_2/>
<PaymentHolidayCentres/>
<PaymentHolidayCentres_2/>
<PaymentLag/>
<PaymentLag_2/>
<RollHolidayCentres/>
<RollHolidayCentres_2/>
<AdjustFixedStartDate/>
<AdjustFloatStartDate/>
<AdjustFloatStartDate_2/>
<AdjustRollEnd/>
<AdjustFloatRollEnd/>
<AdjustFloatRollEnd_2/>
<AdjustFixedFinalRollEnd/>
<AdjustFinalRollEnd/>
<AdjustFinalRollEnd_2/>
<CompoundingMethod/>
<CompoundingMethod_2/>
<AveragingMethod/>
<AveragingMethod_2/>
<FloatingRateMultiplier/>
<FloatingRateMultiplier_2/>
<DesignatedMaturity/>
<DesignatedMaturity_2/>
<ResetFreq/>
<ResetFreq_2/>
<WeeklyRollConvention/>
<WeeklyRollConvention_2/>
<RateCutOffDays/>
<RateCutOffDays_2/>
<InitialExchange/>
<FinalExchange/>
<MarkToMarket/>
<IntermediateExchange/>
<MTMRateSource/>
<MTMRateSourcePage/>
<MTMFixingDate/>
<MTMFixingHolidayCentres/>
<MTMFixingTime/>
<MTMLocation/>
<MTMCutoffTime/>
<CalculationPeriodDays/>
<FraDiscounting/>
<HasBreak/>
<BreakFromSwap/>
<BreakOverride/>
<BreakCalculationMethod/>
<BreakFirstDateTenor/>
<BreakFrequency/>
<BreakOptionA/>
<BreakDate/>
<BreakExpirationDate/>
<BreakEarliestTime/>
<BreakLatestTime/>
<BreakCalcAgentA/>
<BreakExpiryTime/>
<BreakCashSettleCcy/>
<BreakLocation/>
<BreakHolidayCentre/>
<BreakSettlement/>
<BreakValuationDate/>
<BreakValuationTime/>
<BreakSource/>
<BreakReferenceBanks/>
<BreakQuotation/>
<BreakMMVApplicableCSA/>
<BreakCollateralCurrency/>
<BreakCollateralInterestRate/>
<BreakAgreedDiscountRate/>
<BreakProtectedPartyA/>
<BreakMutuallyAgreedCH/>
<BreakPrescribedDocAdj/>
<ExchangeUnderlying/>
<SwapSpread/>
<BondId1/>
<BondName1/>
<BondAmount1/>
<BondPriceType1/>
<BondPrice1/>
<BondId2/>
<BondName2/>
<BondAmount2/>
<BondPriceType2/>
<BondPrice2/>
<StubAt/>
<FixedStub/>
<FloatStub/>
<FloatStub_2/>
<FrontAndBackStubs/>
<FixedBackStub/>
<FloatBackStub/>
<BackStubIndexTenor1/>
<BackStubIndexTenor2/>
<BackStubLinearInterpolation/>
<BackStubInitialInterpIndex/>
<FirstFixedRegPdStartDate/>
<FirstFloatRegPdStartDate/>
<LastFixedRegPdEndDate/>
<LastFloatRegPdEndDate/>
<MasterAgreement><xsl:value-of select="$master_agreement_type"/></MasterAgreement>
<ManualConfirm/>
<NovationExecution/>
<ExclFromClearing/>
<NonStdSettlInst/>
<Normalised/>
<DataMigrationId/>
<NormalisedStubLength/>
<ClientClearing/>
<AutoSendForClearing/>
<CBClearedTimestamp/>
<CBTradeType/>
<ASICMandatoryClearingIndicator>
<xsl:choose>
<xsl:when test="$asic_clearing_flag">
<xsl:value-of select="$asic_clearing_flag"/>
</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</ASICMandatoryClearingIndicator>
<NewNovatedASICMandatoryClearingIndicator/>
<PBEBTradeASICMandatoryClearingIndicator/>
<PBClientTradeASICMandatoryClearingIndicator/>
<CANMandatoryClearingIndicator>
<xsl:choose>
<xsl:when test="$can_clearing_flag">
<xsl:value-of select="$can_clearing_flag"/>
</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</CANMandatoryClearingIndicator>
<CANClearingExemptIndicator1PartyId/>
<CANClearingExemptIndicator1Value/>
<CANClearingExemptIndicator2PartyId/>
<CANClearingExemptIndicator2Value/>
<NewNovatedCANMandatoryClearingIndicator/>
<NewNovatedCANClearingExemptIndicator1PartyId/>
<NewNovatedCANClearingExemptIndicator1Value/>
<NewNovatedCANClearingExemptIndicator2PartyId/>
<NewNovatedCANClearingExemptIndicator2Value/>
<PBEBTradeCANMandatoryClearingIndicator/>
<PBEBTradeCANClearingExemptIndicator1PartyId/>
<PBEBTradeCANClearingExemptIndicator1Value/>
<PBEBTradeCANClearingExemptIndicator2PartyId/>
<PBEBTradeCANClearingExemptIndicator2Value/>
<PBClientTradeCANMandatoryClearingIndicator/>
<PBClientTradeCANClearingExemptIndicator1PartyId/>
<PBClientTradeCANClearingExemptIndicator1Value/>
<PBClientTradeCANClearingExemptIndicator2PartyId/>
<PBClientTradeCANClearingExemptIndicator2Value/>
<ESMAMandatoryClearingIndicator>
<xsl:choose>
<xsl:when test="$esma_clearing_flag">
<xsl:value-of select="$esma_clearing_flag"/>
</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</ESMAMandatoryClearingIndicator>
<ESMAClearingExemptIndicator1PartyId/>
<ESMAClearingExemptIndicator1Value/>
<ESMAClearingExemptIndicator2PartyId/>
<ESMAClearingExemptIndicator2Value/>
<NewNovatedESMAMandatoryClearingIndicator/>
<NewNovatedESMAClearingExemptIndicator1PartyId/>
<NewNovatedESMAClearingExemptIndicator1Value/>
<NewNovatedESMAClearingExemptIndicator2PartyId/>
<NewNovatedESMAClearingExemptIndicator2Value/>
<PBEBTradeESMAMandatoryClearingIndicator/>
<PBEBTradeESMAClearingExemptIndicator1PartyId/>
<PBEBTradeESMAClearingExemptIndicator1Value/>
<PBEBTradeESMAClearingExemptIndicator2PartyId/>
<PBEBTradeESMAClearingExemptIndicator2Value/>
<PBClientTradeESMAMandatoryClearingIndicator/>
<PBClientTradeESMAClearingExemptIndicator1PartyId/>
<PBClientTradeESMAClearingExemptIndicator1Value/>
<PBClientTradeESMAClearingExemptIndicator2PartyId/>
<PBClientTradeESMAClearingExemptIndicator2Value/>
<FCAMandatoryClearingIndicator/>
<FCAClearingExemptIndicator1PartyId/>
<FCAClearingExemptIndicator1Value/>
<FCAClearingExemptIndicator2PartyId/>
<FCAClearingExemptIndicator2Value/>
<NewNovatedFCAMandatoryClearingIndicator/>
<NewNovatedFCAClearingExemptIndicator1PartyId/>
<NewNovatedFCAClearingExemptIndicator1Value/>
<NewNovatedFCAClearingExemptIndicator2PartyId/>
<NewNovatedFCAClearingExemptIndicator2Value/>
<PBEBTradeFCAMandatoryClearingIndicator/>
<PBEBTradeFCAClearingExemptIndicator1PartyId/>
<PBEBTradeFCAClearingExemptIndicator1Value/>
<PBEBTradeFCAClearingExemptIndicator2PartyId/>
<PBEBTradeFCAClearingExemptIndicator2Value/>
<PBClientTradeFCAMandatoryClearingIndicator/>
<PBClientTradeFCAClearingExemptIndicator1PartyId/>
<PBClientTradeFCAClearingExemptIndicator1Value/>
<PBClientTradeFCAClearingExemptIndicator2PartyId/>
<PBClientTradeFCAClearingExemptIndicator2Value/>
<HKMAMandatoryClearingIndicator/>
<HKMAClearingExemptIndicator1PartyId/>
<HKMAClearingExemptIndicator1Value/>
<HKMAClearingExemptIndicator2PartyId/>
<HKMAClearingExemptIndicator2Value/>
<NewNovatedHKMAMandatoryClearingIndicator/>
<NewNovatedHKMAClearingExemptIndicator1PartyId/>
<NewNovatedHKMAClearingExemptIndicator1Value/>
<NewNovatedHKMAClearingExemptIndicator2PartyId/>
<NewNovatedHKMAClearingExemptIndicator2Value/>
<PBEBTradeHKMAMandatoryClearingIndicator/>
<PBEBTradeHKMAClearingExemptIndicator1PartyId/>
<PBEBTradeHKMAClearingExemptIndicator1Value/>
<PBEBTradeHKMAClearingExemptIndicator2PartyId/>
<PBEBTradeHKMAClearingExemptIndicator2Value/>
<PBClientTradeHKMAMandatoryClearingIndicator/>
<PBClientTradeHKMAClearingExemptIndicator1PartyId/>
<PBClientTradeHKMAClearingExemptIndicator1Value/>
<PBClientTradeHKMAClearingExemptIndicator2PartyId/>
<PBClientTradeHKMAClearingExemptIndicator2Value/>
<JFSAMandatoryClearingIndicator>
<xsl:choose>
<xsl:when test="$jfsa_clearing_flag">
<xsl:value-of select="$jfsa_clearing_flag"/>
</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</JFSAMandatoryClearingIndicator>
<CFTCMandatoryClearingIndicator>
<xsl:choose>
<xsl:when test="$cftc_clearing_flag">
<xsl:value-of select="$cftc_clearing_flag"/>
</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</CFTCMandatoryClearingIndicator>
<CFTCClearingExemptIndicator1PartyId>
<xsl:if test="boolean(string-length($clearing_exception_party))">
<xsl:value-of select="$clearing_exception_party"/>
</xsl:if>
</CFTCClearingExemptIndicator1PartyId>
<CFTCClearingExemptIndicator1Value>
<xsl:if test="boolean(string-length($clearing_exception_party))">
<xsl:value-of select="boolean(string-length($clearing_exception_party))"/>
</xsl:if>
</CFTCClearingExemptIndicator1Value>
<CFTCClearingExemptIndicator2PartyId/>
<CFTCClearingExemptIndicator2Value/>
<CFTCInterAffiliateExemption/>
<NewNovatedCFTCMandatoryClearingIndicator/>
<NewNovatedCFTCClearingExemptIndicator1PartyId/>
<NewNovatedCFTCClearingExemptIndicator1Value/>
<NewNovatedCFTCClearingExemptIndicator2PartyId/>
<NewNovatedCFTCClearingExemptIndicator2Value/>
<NewNovatedCFTCInterAffiliateExemption/>
<PBEBTradeCFTCMandatoryClearingIndicator/>
<PBEBTradeJFSAMandatoryClearingIndicator/>
<PBEBTradeCFTCClearingExemptIndicator1PartyId/>
<PBEBTradeCFTCClearingExemptIndicator1Value/>
<PBEBTradeCFTCClearingExemptIndicator2PartyId/>
<PBEBTradeCFTCClearingExemptIndicator2Value/>
<PBEBTradeCFTCInterAffiliateExemption/>
<PBClientTradeCFTCMandatoryClearingIndicator/>
<PBClientTradeJFSAMandatoryClearingIndicator/>
<PBClientTradeCFTCClearingExemptIndicator1PartyId/>
<PBClientTradeCFTCClearingExemptIndicator1Value/>
<PBClientTradeCFTCClearingExemptIndicator2PartyId/>
<PBClientTradeCFTCClearingExemptIndicator2Value/>
<PBClientTradeCFTCInterAffiliateExemption/>
<MASMandatoryClearingIndicator>
<xsl:choose>
<xsl:when test="$mas_clearing_flag">
<xsl:value-of select="$mas_clearing_flag"/>
</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</MASMandatoryClearingIndicator>
<NewNovatedMASMandatoryClearingIndicator/>
<PBEBTradeMASMandatoryClearingIndicator/>
<PBClientTradeMASMandatoryClearingIndicator/>
<ClearingHouseId><xsl:value-of select="$ccp_for_under_swap"/></ClearingHouseId>
<ClearingBrokerId/>
<BackLoadingFlag/>
<Novation>false</Novation>
<PartialNovation>false</PartialNovation>
<FourWayNovation/>
<NovationTradeDate/>
<NovationDate/>
<NovatedAmount/>
<NovatedAmount_2/>
<NovatedCurrency/>
<NovatedCurrency_2/>
<NovatedFV/>
<FullFirstCalculationPeriod/>
<NonReliance/>
<PreserveEarlyTerminationProvision/>
<CopyPremiumToNewTrade/>
<IntendedClearingHouse><xsl:value-of select="$ccp_for_under_swap"/></IntendedClearingHouse>
<OptionStyle><xsl:value-of select="$option_style"/></OptionStyle>
<OptionType><xsl:value-of select="$option_type"/></OptionType>
<OptionExpirationDate><xsl:value-of select="$sched_term_dt_expiration_dt"/></OptionExpirationDate>
<OptionExpirationDateConvention/>
<OptionHolidayCenters/>
<OptionEarliestTime/>
<OptionEarliestTimeHolidayCentre/>
<OptionExpiryTime/>
<OptionExpiryTimeHolidayCentre/>
<OptionSpecificExpiryTime/>
<OptionLocation/>
<OptionCalcAgent/>
<OptionAutomaticExercise/>
<OptionThreshold/>
<ManualExercise><xsl:if test="$sched_term_dt_expiration_dt">true</xsl:if></ManualExercise>
<OptionWrittenExerciseConf/>
<PremiumAmount/>
<PremiumCurrency/>
<PremiumPaymentDate/>
<PremiumHolidayCentres/>
<Strike>
<xsl:if test="$quoting_style != 'Spread'">
<xsl:value-of select="number($strike_price) div 100"/>
</xsl:if>
</Strike>
<StrikeCurrency/>
<StrikePercentage>
<xsl:if test="$quoting_style = 'Spread'">
<xsl:value-of select="number($strike_price) div 100"/>
</xsl:if>
</StrikePercentage>
<StrikeDate/>
<OptionSettlement>Physical</OptionSettlement>
<OptionCashSettlementValuationTime/>
<OptionSpecificValuationTime/>
<OptionCashSettlementValuationDate/>
<OptionCashSettlementPaymentDate/>
<OptionCashSettlementMethod/>
<OptionCashSettlementQuotationRate/>
<OptionCashSettlementRateSource/>
<OptionCashSettlementReferenceBanks/>
<ClearedPhysicalSettlement/>
<ClearingTakeupClientId/>
<ClearingTakeupClientName/>
<ClearingTakeupClientTradeId/>
<ClearingTakeupExecSrcId/>
<ClearingTakeupExecSrcName/>
<ClearingTakeupExecSrcTradeId/>
<ClearingTakeupCorrelationId/>
<ClearingTakeupClearingHouseTradeId/>
<ClearingTakeupOriginatingEvent/>
<ClearingTakeupBlockTradeId/>
<ClearingTakeupSentBy/>
<ClearingTakeupCreditTokenIssuer/>
<ClearingTakeupCreditToken/>
<ClearingTakeupClearingStatus/>
<ClearingTakeupVenueLEI/>
<ClearingTakeupVenueLEIScheme/>
<DocsType><xsl:value-of select="$docs_type"/></DocsType>
<DocsSubType/>
<ContractualDefinitions><xsl:value-of select="$contractual_definition"/></ContractualDefinitions>
<ContractualSupplement>
<xsl:variable name="reclock">
<xsl:if test="contains($add_provisions_for_monoline, 'ISDARecoveryLock')">ISDARecoveryLock;</xsl:if>
</xsl:variable>
<xsl:choose>
<xsl:when test="count($under_master_document_dt) = 0">
<xsl:value-of select="$reclock"/>
</xsl:when>
<xsl:when test="count($under_master_document_dt) = 1">
<xsl:value-of select="concat($under_master_document_dt, $reclock)"/>
</xsl:when>
<xsl:otherwise>
<xsl:for-each select="$under_master_document_dt | $reclock">
<xsl:value-of select="concat(., ';')"/>
</xsl:for-each>
</xsl:otherwise>
</xsl:choose>
</ContractualSupplement>
<CanadianSupplement/>
<ExchangeTradedContractNearest/>
<RestructuringCreditEvent>
<xsl:if test="$product_type='CDS Matrix' or $product_type='CDS on Loans' or $product_type='CDS Master'">
<xsl:value-of select="boolean($restructuring_event)"/>
</xsl:if>
</RestructuringCreditEvent>
<CalculationAgentCity>
<xsl:if test="$product_type='CDS Matrix' or $product_type='CDS on MBS' or $product_type='CDS Master' or $product_type='CDS Index' or $product_type='CDS Index Tranche'">
<xsl:choose>
<xsl:when test="(contains($docs_type, 'European Corporate') = 0) and (contains($docs_type, 'US Municipal') = 0)">
<xsl:value-of select="$calc_agt_business_center_code"/>
</xsl:when>
<xsl:otherwise/>
</xsl:choose>
</xsl:if>
</CalculationAgentCity>
<RefEntName>
</RefEntName>
<RefEntStdId>
<xsl:if test="string-length($reference_entity_id) = 6">
<xsl:if test="$product_type='CDS' or $product_type='CDS Matrix' or $product_type='CDS on Loans' or $product_type='CDS Master'">
<xsl:value-of select="translate($reference_entity_id,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
</xsl:if>
</xsl:if>
</RefEntStdId>
<REROPairStdId>
<xsl:if test="string-length($reference_entity_id) = 9">
<xsl:if test="$product_type='CDS' or $product_type='CDS Matrix' or $product_type='CDS on Loans' or $product_type='CDS Master'">
<xsl:value-of select="translate($reference_entity_id,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
</xsl:if>
</xsl:if>
</REROPairStdId>
<RefOblRERole/>
<RefOblSecurityIdType>
<xsl:if test="$reference_obligation and ($product_type='CDS Matrix' or $product_type='CDS on Loans' or $product_type='CDS Master')">
<xsl:choose>
<xsl:when test="string-length($reference_obligation) = 12">ISIN</xsl:when>
<xsl:when test="string-length($reference_obligation) = 9">CUSIP</xsl:when>
<xsl:otherwise/>
</xsl:choose>
</xsl:if>
</RefOblSecurityIdType>
<RefOblSecurityId>
<xsl:if test="$reference_obligation">
<xsl:value-of select="translate($reference_obligation,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
</xsl:if>
</RefOblSecurityId>
<BloombergID><xsl:value-of select="$bloomberg_id"/></BloombergID>
<RefOblMaturity/>
<RefOblCoupon/>
<RefOblPrimaryObligor/>
<BorrowerNames>
<xsl:for-each select="$name_of_borrower">
<xsl:value-of select="."/>
<xsl:if test="position()!=count(../fpml:borrower)">;</xsl:if>
</xsl:for-each>
</BorrowerNames>
<FacilityType>
<xsl:if test="$facility_type">
<xsl:choose>
<xsl:when test="$facility_type='Term'">TermLoan</xsl:when>
<xsl:when test="$facility_type='Revolving'">RevolvingLoan</xsl:when>
</xsl:choose>
</xsl:if>
</FacilityType>
<CreditAgreementDate><xsl:value-of select="$credit_agreement_dt"/></CreditAgreementDate>
<IsSecuredList><xsl:value-of select="$secured_list_app"/></IsSecuredList>
<CashSettlementOnly>
<xsl:choose>
<xsl:when test="$cash_settlement_only">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</CashSettlementOnly>
<Continuity>
<xsl:choose>
<xsl:when test="$continuity">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</Continuity>
<DeliveryOfCommitments>
<xsl:choose>
<xsl:when test="$delivery_of_commitments">true</xsl:when>
<xsl:otherwise>false</xsl:otherwise>
</xsl:choose>
</DeliveryOfCommitments>
<ObligationCategory/>
<DesignatedPriority><xsl:value-of select="$designated_priority"/></DesignatedPriority>
<CreditDateAdjustments>
<Convention/>
<Holidays><xsl:value-of select="$business_day"/></Holidays>
</CreditDateAdjustments>
<OptionalEarlyTermination>true</OptionalEarlyTermination>
<ReferencePrice><xsl:value-of select="$reference_price"/></ReferencePrice>
<ReferencePolicy>Applicable</ReferencePolicy>
<PaymentDelay><xsl:value-of select="$fxd_amt_pymt_delay_app"/></PaymentDelay>
<StepUpProvision>
<xsl:value-of select="boolean($step_up_provisions_app)"/>
</StepUpProvision>
<WACCapInterestProvision><xsl:value-of select="boolean($wac_cap_int_provision_app)"/></WACCapInterestProvision>
<InterestShortfallCapIndicator><xsl:value-of select="boolean($int_shortfall_cap_app)"/></InterestShortfallCapIndicator>
<InterestShortfallCompounding><xsl:value-of select="$int_shortfall_comp_app"/></InterestShortfallCompounding>
<InterestShortfallCapBasis><xsl:value-of select="$int_shortfall_cap_basis"/></InterestShortfallCapBasis>
<InterestShortfallRateSource><xsl:value-of select="$rate_source"/></InterestShortfallRateSource>
<MortgagePaymentFrequency><xsl:value-of select="$pymt_multiplier"/><xsl:value-of select="$pymt_frequency"/></MortgagePaymentFrequency>
<MortgageFinalMaturity><xsl:value-of select="$legal_final_maturity_dt"/></MortgageFinalMaturity>
<MortgageOriginalAmount><xsl:value-of select="$orig_principal_amt"/></MortgageOriginalAmount>
<MortgageInitialFactor/>
<MortgageSector/>
<MortgageInsurer><xsl:value-of select="$insurer"/></MortgageInsurer>
<IndexName>
<xsl:if test="$product_type = 'CDS Index'">
<xsl:value-of select="$reference_entity_name"/>
</xsl:if>
</IndexName>
<IndexId>
<xsl:if test="$product_type = 'CDS Index'">
<xsl:value-of select="$reference_entity_id"/>
</xsl:if>
</IndexId>
<IndexAnnexDate><xsl:value-of select="$master_confirm_annex_dt"/></IndexAnnexDate>
<IndexTradedRate/>
<xsl:choose>
<xsl:when test="$init_pymt_amt_prem_pymt_amt and number($init_pymt_amt_prem_pymt_amt) != 0">
<UpfrontFee>true</UpfrontFee>
<UpfrontFeeAmount><xsl:value-of select="$init_pymt_amt_prem_pymt_amt"/></UpfrontFeeAmount>
<UpfrontFeeCurrency><xsl:value-of select="$init_pymt_ccy_prem_pymt_ccy"/></UpfrontFeeCurrency>
<UpfrontFeeDate></UpfrontFeeDate>
<UpfrontFeePayer>
<xsl:variable name="uf_payer"><xsl:value-of select="$init_pymt_payer"/></xsl:variable>
<xsl:choose>
<xsl:when test="$uf_payer = 'partyA'">A</xsl:when>
<xsl:when test="$uf_payer = 'partyB'">B</xsl:when>
</xsl:choose>
</UpfrontFeePayer>
</xsl:when>
<xsl:when test="$single_pymt_amt_prem_pymt_amt and number($single_pymt_amt_prem_pymt_amt) != 0">
<UpfrontFee>true</UpfrontFee>
<UpfrontFeeAmount><xsl:value-of select="$single_pymt_amt_prem_pymt_amt"/></UpfrontFeeAmount>
<UpfrontFeeCurrency><xsl:value-of select="$single_pymt_ccy_prem_pymt_ccy"/></UpfrontFeeCurrency>
<UpfrontFeeDate><xsl:value-of select="$single_pymt_dt_prem_pymt_dt"/></UpfrontFeeDate>
<UpfrontFeePayer>
<xsl:variable name="uf_payer">
<xsl:choose>
<xsl:when test="$init_pymt_payer"><xsl:value-of select="$init_pymt_payer"/></xsl:when>
<xsl:otherwise><xsl:value-of select="$fxd_rate_payer_swaption_buyer"/></xsl:otherwise>
</xsl:choose>
</xsl:variable>
<xsl:choose>
<xsl:when test="$uf_payer = 'partyA'">A</xsl:when>
<xsl:when test="$uf_payer = 'partyB'">B</xsl:when>
</xsl:choose>
</UpfrontFeePayer>
</xsl:when>
<xsl:otherwise>
<UpfrontFee>false</UpfrontFee>
<UpfrontFeeAmount/>
<UpfrontFeeCurrency/>
<UpfrontFeeDate/>
<UpfrontFeePayer/>
</xsl:otherwise>
</xsl:choose>
<AttachmentPoint>
<xsl:if test="$attachment_point">
<xsl:value-of select="number($attachment_point) div 100"/>
</xsl:if>
</AttachmentPoint>
<ExhaustionPoint>
<xsl:if test="$exhaustion_point">
<xsl:value-of select="number($exhaustion_point) div 100"/>
</xsl:if>
</ExhaustionPoint>
<PublicationDate><xsl:value-of select="$master_confirm_agreement_dt"/></PublicationDate>
<MasterAgreementDate><xsl:value-of select="$master_agreement_dt"/></MasterAgreementDate>
<MasterAgreementVersion/>
<AmendmentTradeDate/>
<SettlementCurrency/>
<ReferenceCurrency/>
<SettlementRateOption/>
<NonDeliverable/>
<FxFixingDate>
<FxFixingAdjustableDate/>
<FxFixingPeriod/>
<FxFixingDayConvention/>
<FxFixingCentres/>
</FxFixingDate>
<SettlementCurrency_2/>
<ReferenceCurrency_2/>
<SettlementRateOption_2/>
<FxFixingDate_2>
<FxFixingPeriod_2/>
<FxFixingDayConvention_2/>
<FxFixingCentres_2/>
</FxFixingDate_2>
<OutsideNovationTradeDate/>
<OutsideNovationNovationDate/>
<OutsideNovationOutgoingParty/>
<OutsideNovationIncomingParty/>
<OutsideNovationRemainingParty/>
<OutsideNovationFullFirstCalculationPeriod/>
<CalcAgentA>
<xsl:choose>
<xsl:when test="$product_type = 'CDS Matrix' or $product_type = 'CDS on Loans' or $product_type = 'CDS on MBS'">
<xsl:choose>
<xsl:when test="$calc_agt = 'AsSpecifiedInMaster' or $calc_agt = 'AsSpecifiedInMasterAgreement'">As Specified in Master Agreement</xsl:when>
<xsl:when test="$calc_agt = $fxd_rate_payer_swaption_buyer">Buyer</xsl:when>
<xsl:otherwise>Seller</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="($product_type = 'CDS Index' and $is_structured_index = 'false') or $product_type = 'CDS Index Swaption'">
<xsl:choose>
<xsl:when test="$calc_agt = 'AsSpecifiedInMaster' or $calc_agt = 'AsSpecifiedInMasterAgreement'">As Specified in Master Agreement</xsl:when>
<xsl:when test="$calc_agt = 'As Specified in STS' or $calc_agt = 'As Specified In STS'">As Specified In STS</xsl:when>
<xsl:when test="$calc_agt = $fxd_rate_payer_swaption_buyer">Buy</xsl:when>
<xsl:otherwise>Sell</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$product_type='CDS Index' and $is_structured_index = 'true'">
<xsl:choose>
<xsl:when test="$calc_agt = 'AsSpecifiedInMaster' or $calc_agt = 'AsSpecifiedInMasterAgreement'">As Specified in Master Agreement</xsl:when>
<xsl:when test="$calc_agt = 'As Specified in STS' or $calc_agt = 'As Specified In STS'">As Specified In STS</xsl:when>
<xsl:when test="$calc_agt = $fxd_rate_payer_swaption_buyer">Buy</xsl:when>
<xsl:when test="$calc_agt = $flt_rate_payer_swaption_seller">Sell</xsl:when>
<xsl:otherwise>As Specified In STS</xsl:otherwise>
</xsl:choose>
</xsl:when>
</xsl:choose>
</CalcAgentA>
<AmendmentType/>
<CancellationType/>
<OfflineLeg1/>
<OfflineLeg2/>
<OfflineSpread/>
<OfflineSpreadLeg/>
<OfflineSpreadParty/>
<OfflineSpreadDirection/>
<OfflineAdditionalDetails/>
<OfflineOrigRef/>
<OfflineOrigRef_2/>
<OfflineTradeDesk/>
<OfflineTradeDesk_2/>
<OfflineProductType/>
<OfflineExpirationDate/>
<OfflineOptionType/>
<EquityRic/>
<OptionQuantity/>
<OptionNumberOfShares/>
<Price/>
<PricePerOptionCurrency/>
<ExchangeLookAlike/>
<AdjustmentMethod/>
<MasterConfirmationDate>
<xsl:if test="$documentation_type != 'StandardTermsSupplement'">
<xsl:value-of select="$master_confirm_agreement_dt"/>
</xsl:if>
</MasterConfirmationDate>
<Multiplier/>
<OptionExchange/>
<RelatedExchange/>
<DefaultSettlementMethod/>
<SettlementPriceDefaultElectionMethod/>
<DesignatedContract/>
<FxDeterminationMethod/>
<SWFXRateSource/>
<SWFXRateSourcePage/>
<SWFXHourMinuteTime/>
<SWFXBusinessCenter/>
<SettlementMethodElectionDate/>
<SettlementMethodElectingParty/>
<SettlementDateOffset/>
<SettlementType/>
<MultipleExchangeIndexAnnex/>
<ComponentSecurityIndexAnnex/>
<LocalJurisdiction/>
<OptionHedgingDisruption/>
<OptionLossOfStockBorrow/>
<OptionMaximumStockLoanRate/>
<OptionIncreasedCostOfStockBorrow/>
<OptionInitialStockLoanRate/>
<OptionIncreasedCostOfHedging/>
<OptionForeignOwnershipEvent/>
<OptionEntitlement/>
<ReferencePriceSource/>
<ReferencePricePage/>
<ReferencePriceTime/>
<ReferencePriceCity/>
<MinimumNumberOfOptions/>
<IntegralMultiple/>
<MaximumNumberOfOptions/>
<ExerciseCommencementDate/>
<BermudaExerciseDates>
<BermudaExerciseDate/>
</BermudaExerciseDates>
<BermudaFrequency/>
<BermudaFirstDate/>
<BermudaFinalDate/>
<LatestExerciseTimeMethod/>
<LatestExerciseSpecificTime/>
<DcCurrency/>
<DcDelta/>
<DcEventTypeA/>
<DcExchange/>
<DcExpiryDate/>
<DcFuturesCode/>
<DcOffshoreCross/>
<DcOffshoreCrossLocation/>
<DcPrice/>
<DcQuantity/>
<DcRequired/>
<DcRic/>
<DcDescription/>
<AveragingInOut/>
<AveragingDateTimes/>
<MarketDisruption/>
<AveragingFrequency/>
<AveragingStartDate/>
<AveragingEndDate/>
<AveragingBusinessDayConvention/>
<ReferenceFXRate/>
<HedgeLevel/>
<Basis/>
<ImpliedLevel/>
<PremiumPercent/>
<StrikePercent/>
<BaseNotional/>
<BaseNotionalCurrency/>
<BreakOutTrade/>
<SplitCollateral/>
<OpenUnits/>
<DeclaredCashDividendPercentage/>
<DeclaredCashEquivalentDividendPercentage/>
<DividendPayer/>
<DividendReceiver/>
<DividendPeriods>
<DividendPeriod>
<DividendPeriodId/>
<UnadjustedStartDate/>
<UnadjustedEndDate/>
<PaymentDateReference/>
<FixedStrike/>
<DividendValuationDateReference/>
<DividendValuationDate/>
</DividendPeriod>
</DividendPeriods>
<SpecialDividends/>
<MaterialDividend/>
<FixedPayer/>
<FixedReceiver/>
<FixedPeriods/>
<EquityAveragingObservations>
<EquityAveragingObservation>
<EquityAveragingDate/>
<EquityAveragingWeight/>
</EquityAveragingObservation>
</EquityAveragingObservations>
<EquityInitialSpot/>
<EquityCap/>
<EquityCapPercentage/>
<EquityFloor/>
<EquityFloorPercentage/>
<EquityNotional/>
<EquityNotionalCurrency/>
<EquityFrequency/>
<EquityValuationMethod/>
<EquityFrequencyConvention/>
<EquityFreqFirstDate/>
<EquityFreqFinalDate/>
<EquityFreqRoll/>
<EquityListedValuationDates>
<EquityListedValuationDate/>
</EquityListedValuationDates>
<EquityListedDatesConvention/>
<StrategyType/>
<StrategyDeltaLeg/>
<StrategyDeltaQuantity/>
<StrategyComments/>
<StrategyLegs>
<StrategyLeg>
<SlDirectionA/>
<SlLegId/>
<SlExpirationDate/>
<SlNumberOfOptions/>
<SlOptionType/>
<SlPayAmount/>
<SlPricePerOptionAmount/>
<SlStrikePrice/>
<SlFwdStrikePercentage/>
<SlFwdStrikeDate/>
<SlPremiumPercent/>
<SlStrikePercent/>
<SlBaseNotional/>
</StrategyLeg>
</StrategyLegs>
<VegaNotional/>
<ExpectedN/>
<ExpectedNOverride/>
<VarianceAmount/>
<VarianceStrikePrice/>
<VolatilityStrikePrice/>
<VarianceCapIndicator/>
<VarianceCapFactor/>
<TotalVarianceCap/>
<TotalVolatilityCap/>
<ObservationStartDate/>
<ValuationDate/>
<InitialSharePriceOrIndexLevel/>
<ClosingSharePriceOrClosingIndexLevelIndicator/>
<FuturesPriceValuation/>
<AllDividends/>
<SettlementCurrencyVegaNotional/>
<VegaFxRate/>
<HolidayDates/>
<DispLegs>
<DispLeg>
<DispLegId/>
<DispLegVersionId/>
<DispLegPayer/>
<DispLegReceiver/>
<DispEquityRic/>
<DispEquityRelEx/>
<DispVegaNotional/>
<DispExpectedN/>
<DispSettlementDateOffset/>
<DispVarianceAmount/>
<DispShareVarCurrency/>
<DispVarianceStrikePrice/>
<DispVarianceCapIndicator/>
<DispVarianceCapFactor/>
<DispVegaNotionalAmount/>
<DispObservationStartDate/>
<DispValuationDate/>
<DispInitialLevel/>
<DispClosingLevelIndicator/>
<DispFuturesPriceValuation/>
<DispAllDividends/>
</DispLeg>
</DispLegs>
<DispLegsSW>
<DispLegSW>
<DispCorrespondingLeg/>
<DispVolatilityStrikePrice/>
<DispHolidayDates/>
<DispExpectedNOverride/>
<DispShareWeight/>
</DispLegSW>
</DispLegsSW>
<BulletIndicator/>
<DocsSelection/>
<NovationReporting>
<Novated/>
<NewNovated/>
</NovationReporting>
<InterestLegDrivenIndicator/>
<EquityFrontStub/>
<EquityEndStub/>
<InterestFrontStub/>
<InterestEndStub/>
<FixedRateIndicator/>
<EswFixingDateOffset/>
<DividendPaymentDates/>
<DividendPaymentOffset/>
<DividendPercentage/>
<DividendReinvestment/>
<EswDeclaredCashDividendPercentage/>
<EswDeclaredCashEquivalentDividendPercentage/>
<EswDividendSettlementCurrency/>
<EswNonCashDividendTreatment/>
<EswDividendComposition/>
<EswSpecialDividends/>
<EswDividendValuationOffset/>
<EswDividendValuationFrequency/>
<EswDividendInitialValuation/>
<EswDividendFinalValuation/>
<EswDividendValuationDay/>
<EswDividendValuationCustomDatesInterim>
<EswDividendValuationCustomDateInterim/>
</EswDividendValuationCustomDatesInterim>
<EswDividendValuationCustomDateFinal/>
<ExitReason/>
<TransactionDate/>
<EffectiveDate/>
<EquityHolidayCentres/>
<OtherValuationBusinessCenters/>
<EswFuturesPriceValuation/>
<EswFpvFinalPriceElectionFallback/>
<EswDesignatedMaturity/>
<EswEquityValConvention/>
<EswInterestFloatConvention/>
<EswInterestFloatDayBasis/>
<EswInterestFloatingRateIndex/>
<EswInterestFixedRate/>
<EswInterestSpreadOverIndex/>
<EswLocalJurisdiction/>
<EswReferencePriceSource/>
<EswReferencePricePage/>
<EswReferencePriceTime/>
<EswReferencePriceCity/>
<EswNotionalAmount/>
<EswNotionalCurrency/>
<EswOpenUnits/>
<FeeIn/>
<FeeInOutIndicator/>
<FeeOut/>
<FinalPriceDefaultElection/>
<FinalValuationDate/>
<FullyFundedAmount/>
<FullyFundedIndicator/>
<InitialPrice/>
<InitialPriceElection/>
<EquityNotionalReset/>
<EswReferenceInitialPrice/>
<EswReferenceFXRate/>
<PaymentDateOffset/>
<PaymentFrequency/>
<EswFixingHolidayCentres/>
<EswPaymentHolidayCentres/>
<ReturnType/>
<Synthetic/>
<TerminationDate/>
<ValuationDay/>
<PaymentDay/>
<ValuationFrequency/>
<ValuationStartDate/>
<EswSchedulingMethod/>
<EswValuationDates/>
<EswFixingDates/>
<EswInterestLegPaymentDates/>
<EswEquityLegPaymentDates/>
<EswCompoundingDates/>
<EswCompoundingMethod/>
<EswCompoundingFrequency/>
<EswInterpolationMethod/>
<EswInterpolationPeriod/>
<EswAveragingDatesIndicator/>
<EswADTVIndicator/>
<EswLimitationPercentage/>
<EswLimitationPeriod/>
<EswStockLoanRateIndicator/>
<EswMaximumStockLoanRate/>
<EswInitialStockLoanRate/>
<EswOptionalEarlyTermination/>
<EswBreakFundingRecovery/>
<EswBreakFeeElection/>
<EswBreakFeeRate/>
<EswFinalPriceFee/>
<EswEarlyFinalValuationDateElection/>
<EswEarlyTerminationElectingParty/>
<EswInsolvencyFiling/>
<EswLossOfStockBorrow/>
<EswIncreasedCostOfStockBorrow/>
<EswBulletCompoundingSpread/>
<EswSpecifiedExchange/>
<EswCorporateActionFlag/>
<NCCreditProductType/>
<NCIndivTradeSummary>
<NCIndivNCMId/>
<NCIndivMWId/>
<NCIndivORFundId/>
<NCIndivORFund/>
<NCIndivRPFundId/>
<NCIndivRPFund/>
<NCIndivEEFundId/>
<NCIndivEEFund/>
<NCIndivNotionalAmount/>
<NCIndivNotionalCurrency/>
<NCIndivFeeAmount/>
<NCIndivFeeCurrency/>
<NCIndivStatus/>
</NCIndivTradeSummary>
<NCNovationBlockID/>
<NCNCMID/>
<NCRPOldTRN/>
<NCCEqualsCEligible/>
<NCSummaryLinkID/>
<NCORFundId/>
<NCORFundName/>
<NCRPFundId/>
<NCRPFundName/>
<NCEEFundId/>
<NCEEFundName/>
<NCRecoveryFactor/>
<NCFixedSettlement/>
<NCSwaptionDocsType><xsl:value-of select="$mdtt"/></NCSwaptionDocsType>
<NCAdditionalMatrixProvision/>
<NCSwaptionPublicationDate><xsl:value-of select="$under_master_document_dt"/></NCSwaptionPublicationDate>
<NCOptionDirectionA/>
<TIWDTCCTRI><xsl:value-of select="$tiwtri"/></TIWDTCCTRI>
<TIWActiveStatus><xsl:value-of select="$active_status"/></TIWActiveStatus>
<TIWValueDate><xsl:value-of select="substring($msg_value_date,1,19)"/></TIWValueDate>
<TIWAsOfDate><xsl:value-of select="$msg_as_of_date"/></TIWAsOfDate>
<EquityBackLoadingFlag/>
<MigrationReferences>
<MigrationReference>
<MigrationIDParty/>
<MigrationID/>
</MigrationReference>
</MigrationReferences>
<Rule15A-6/>
<HedgingParty>
<HedgingPartyOccurrence/>
</HedgingParty>
<DeterminingParty>
<DeterminingPartyOccurrence/>
</DeterminingParty>
<CalculationAgent>
<CalculationAgentOccurrence/>
</CalculationAgent>
<IndependentAmount2>
<Payer>
<xsl:choose>
<xsl:when test="$independent_payer = 'partyA'">A</xsl:when>
<xsl:when test="$independent_payer = 'partyB'">B</xsl:when>
</xsl:choose>
</Payer>
<Currency/>
<Amount/>
<IndependentAmountPercentage><xsl:value-of select="$independent_percent"/></IndependentAmountPercentage>
<Date/>
<Convention/>
<Holidays/>
</IndependentAmount2>
<NotionalFutureValue/>
<NotionalSchedule/>
<SendForPublishing/>
<SubscriberId/>
<ModifiedEquityDelivery><xsl:value-of select="boolean($modified_equity_delivery)"/></ModifiedEquityDelivery>
<SettledEntityMatrixSource><xsl:value-of select="$settled_entity_matrix_source"/></SettledEntityMatrixSource>
<SettledEntityMatrixDate><xsl:value-of select="$settled_entity_matrix_dt"/></SettledEntityMatrixDate>
<AdditionalTerms>
<xsl:value-of select="$add_terms"/>
</AdditionalTerms>
<NovationInitiatedBy/>
<ReportingData>
<PriorUSI/>
<UPI/>
</ReportingData>
<xsl:call-template name="lcl:DFData">
<xsl:with-param name="PriceNotationType" select="$price_notation_price_type"/>
<xsl:with-param name="PriceNotationValue" select="$price_notation_price"/>
<xsl:with-param name="PriceNotation">
<xsl:call-template name="lcl:PriceNotation">
<xsl:with-param name="PriceNotationType"><xsl:value-of select="$price_notation_price_type"/></xsl:with-param>
<xsl:with-param name="PriceNotationValue"><xsl:value-of select="$price_notation_price"/></xsl:with-param>
</xsl:call-template>
</xsl:with-param>
<xsl:with-param name="AdditionalPriceNotationType" select="$add_price_notation_price_type"/>
<xsl:with-param name="AdditionalPriceNotationValue" select="$add_price_notation_price"/>
<xsl:with-param name="AdditionalPriceNotation">
<xsl:call-template name="lcl:AdditionalPriceNotation">
<xsl:with-param name="AdditionalPriceNotationType"><xsl:value-of select="$add_price_notation_price_type"/></xsl:with-param>
<xsl:with-param name="AdditionalPriceNotationValue"><xsl:value-of select="$add_price_notation_price"/></xsl:with-param>
</xsl:call-template>
</xsl:with-param>
<xsl:with-param name="ReportingCounterparty" select="$cftc_reporting_ctpy"/>
<xsl:with-param name="DFClearingMandatory" select="$cftc_clearing_flag"/>
<xsl:with-param name="ObligatoryReporting" select="$cftc_reporting_jurisdiction"/>
<xsl:with-param name="USINamespace" select="$usi_uti_prefix"/>
<xsl:with-param name="USI" select="$usi_uti_id"/>
</xsl:call-template>
<xsl:call-template name="lcl:JFSAData">
<xsl:with-param name="JFSADataPresent"           select="boolean(string-length($usi_uti_id))"/>
<xsl:with-param name="JFSANewNovatedDataPresent" select="false"/>
<xsl:with-param name="JFSANovatedDataPresent"    select="false"/>
<xsl:with-param name="JFSAUTINamespace"          select="$usi_uti_prefix"/>
<xsl:with-param name="JFSAUTI"                   select="$usi_uti_id"/>
</xsl:call-template>
<xsl:call-template name="lcl:ESMAData">
<xsl:with-param name="ESMADataPresent"           select="boolean(string-length($usi_uti_id))"/>
<xsl:with-param name="ESMANewNovatedDataPresent" select="false"/>
<xsl:with-param name="ESMANovatedDataPresent"    select="false"/>
<xsl:with-param name="ESMAUTINamespace"          select="$usi_uti_prefix"/>
<xsl:with-param name="ESMAUTI"                   select="$usi_uti_id"/>
</xsl:call-template>
<xsl:call-template name="lcl:HKMAData">
<xsl:with-param name="HKMADataPresent"           select="boolean(string-length($usi_uti_id))"/>
<xsl:with-param name="HKMANewNovatedDataPresent" select="false"/>
<xsl:with-param name="HKMANovatedDataPresent"    select="false"/>
<xsl:with-param name="HKMAUTINamespace"          select="$usi_uti_prefix"/>
<xsl:with-param name="HKMAUTI"                   select="$usi_uti_id"/>
</xsl:call-template>
<xsl:call-template name="lcl:CAData">
<xsl:with-param name="CADataPresent"           select="boolean(string-length($usi_uti_id))"/>
<xsl:with-param name="CAObligatoryReporting"   select="$can_reporting_jurisdiction"/>
<xsl:with-param name="CAReportableLocationsA"  select="$can_reporting_locations_a"/>
<xsl:with-param name="CAReportableLocationsB"  select="$can_reporting_locations_b"/>
<xsl:with-param name="ReportingCounterparty"   select="$can_reporting_ctpy"/>
<xsl:with-param name="CANewNovatedDataPresent" select="false"/>
<xsl:with-param name="CANovatedDataPresent"    select="false"/>
<xsl:with-param name="CAUTINamespace"          select="$usi_uti_prefix"/>
<xsl:with-param name="CAUTI"                   select="$usi_uti_id"/>
</xsl:call-template>
<xsl:choose>
<xsl:when test="$mid_market_price_type | $mid_market_price_value">
<MidMarketPriceType><xsl:value-of select="$mid_market_price_type"/></MidMarketPriceType>
<MidMarketPriceValue><xsl:value-of select="$mid_market_price_value"/></MidMarketPriceValue>
<IntentToBlankMidMarketCurrency>true</IntentToBlankMidMarketCurrency>
</xsl:when>
<xsl:otherwise>
<IntentToBlankMidMarketPrice>true</IntentToBlankMidMarketPrice>
</xsl:otherwise>
</xsl:choose>
<DFEmbeddedOptionType/>
<GenProdPrimaryAssetClass/>
<GenProdSecondaryAssetClass/>
<ProductId/>
<OptionDirectionA>
<xsl:if test="$product_type='CDS Index Swaption'">
<xsl:choose>
<xsl:when test="$fxd_rate_payer_swaption_buyer = 'partyA'">Buy</xsl:when>
<xsl:otherwise>Sell</xsl:otherwise>
</xsl:choose>
</xsl:if>
</OptionDirectionA>
<OptionPremium><xsl:value-of select="$init_pymt_amt_prem_pymt_amt"/></OptionPremium>
<OptionPremiumCurrency><xsl:value-of select="$init_pymt_ccy_prem_pymt_ccy"/></OptionPremiumCurrency>
<OptionStrike/>
<OptionStrikeType/>
<FirstExerciseDate/>
<FloatingDayCountConvention/>
<DayCountConvention/>
<GenProdUnderlyer>
<UnderlyerType/>
<UnderlyerDescription/>
<UnderlyerDirectionA/>
<UnderlyerFixedRate/>
<UnderlyerIDCode/>
<UnderlyerIDType/>
<UnderlyerReferenceCurrency/>
<UnderlyerFXCurrency/>
</GenProdUnderlyer>
<GenProdNotional>
<NotionalCurrency/>
<NotionalUnit/>
<Notional/>
</GenProdNotional>
<ResetFrequency/>
<DayCountFraction>
<Schema/>
<Fraction/>
</DayCountFraction>
<DurationType/>
<RateCalcType/>
<SecurityType/>
<OpenRepoRate/>
<OpenRepoSpread/>
<OpenCashAmount/>
<OpenDeliveryMethod/>
<OpenSecurityNominal/>
<OpenSecurityQuantity/>
<CloseDeliveryMethod/>
<CloseSecurityNominal/>
<CloseSecurityQuantity/>
<DayCountBasis/>
<SecurityIDType/>
<SecurityID/>
<SecurityCurrency/>
</SWDMLTrade>
</xsl:template>
</xsl:stylesheet>
