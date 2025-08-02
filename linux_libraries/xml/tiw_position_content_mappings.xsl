<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:fpml="http://www.fpml.org/2010/FpML-4-9"
xmlns:common="http://exslt.org/common"
exclude-result-prefixes="fpml common" version="1.0">
<xsl:output method="xml"/>
<xsl:template name="getProductTypeFromTiwRec">
<xsl:param name="dsm_product_type"/>
<xsl:param name="dsm_mdtt"/>
<xsl:choose>
<xsl:when test="$dsm_product_type = 'CreditDefaultSwapIndexTranche'">
<xsl:choose>
<xsl:when test="$dsm_mdtt = 'StandardCDXTranche'">CDS on Loans</xsl:when>
<xsl:when test="$dsm_mdtt = 'StandardLCDXBulletTranche'">CDS on Loans</xsl:when>
<xsl:when test="$dsm_mdtt = 'StandardiTraxxEuropeTranche'">CDS on Loans</xsl:when>
<xsl:otherwise>CDS Index</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$dsm_product_type = 'CreditDefaultSwapIndex'">
<xsl:choose>
<xsl:when test="$dsm_mdtt = '2003CreditIndex'">CDS Index</xsl:when>
<xsl:when test="$dsm_mdtt = '2014CreditIndex'">CDS Index</xsl:when>
<xsl:when test="$dsm_mdtt = 'CDX'">CDS Index</xsl:when>
<xsl:when test="$dsm_mdtt = 'CDXEmergingMarkets'">CDS Index</xsl:when>
<xsl:when test="$dsm_mdtt = 'CDXEmergingMarketsDiversified'">CDS Index</xsl:when>
<xsl:when test="$dsm_mdtt = 'IOS'">CDS Index</xsl:when>
<xsl:when test="$dsm_mdtt = 'iTraxxAsiaExJapan'">CDS Index</xsl:when>
<xsl:when test="$dsm_mdtt = 'iTraxxAustralia'">CDS Index</xsl:when>
<xsl:when test="$dsm_mdtt = 'iTraxxCJ'">CDS Index</xsl:when>
<xsl:when test="$dsm_mdtt = 'iTraxxEurope'">CDS Index</xsl:when>
<xsl:when test="$dsm_mdtt = 'iTraxxJapan'">CDS Index</xsl:when>
<xsl:when test="$dsm_mdtt = 'iTraxxLevX'">CDS Index</xsl:when>
<xsl:when test="$dsm_mdtt = 'iTraxxSDI75Dealer'">CDS Index</xsl:when>
<xsl:when test="$dsm_mdtt = 'iTraxxSDI75NonDealer'">CDS Index</xsl:when>
<xsl:when test="$dsm_mdtt = 'iTraxxSovX'">CDS Index</xsl:when>
<xsl:when test="$dsm_mdtt = 'LCDX'">CDS Index</xsl:when>
<xsl:when test="$dsm_mdtt = 'MCDX'">CDS Index</xsl:when>
<xsl:when test="$dsm_mdtt = 'TRX'">CDS Index</xsl:when>
<xsl:when test="$dsm_mdtt = 'PrimeX'">CDS Index</xsl:when>
<xsl:when test="$dsm_mdtt = 'PO'">CDS Index</xsl:when>
<xsl:when test="$dsm_mdtt = 'MBX'">CDS Index</xsl:when>
<xsl:when test="$dsm_mdtt = 'NCRMBX'">CDS Index</xsl:when>
<xsl:when test="$dsm_mdtt = 'SP'">CDS Index</xsl:when>
<xsl:when test="$dsm_mdtt = 'iBoxx'">CDS Index</xsl:when>
<xsl:when test="$dsm_mdtt = 'TRX'">CDS Index</xsl:when>
<xsl:when test="$dsm_mdtt = 'TRX.II'">CDS Index</xsl:when>
<xsl:when test="$dsm_mdtt = 'ABXTranche'">CDS Index</xsl:when>
<xsl:when test="$dsm_mdtt = 'CDXTranche'">CDS Index</xsl:when>
<xsl:when test="$dsm_mdtt = 'iTraxxAsiaExJapanTranche'">CDS Index</xsl:when>
<xsl:when test="$dsm_mdtt = 'iTraxxAustraliaTranche'">CDS Index</xsl:when>
<xsl:when test="$dsm_mdtt = 'iTraxxCJTranche'">CDS Index</xsl:when>
<xsl:when test="$dsm_mdtt = 'iTraxxEuropeTranche'">CDS Index</xsl:when>
<xsl:when test="$dsm_mdtt = 'iTraxxJapanTranche'">CDS Index</xsl:when>
<xsl:when test="$dsm_mdtt = 'LCDXTranche'">CDS Index</xsl:when>
<xsl:when test="$dsm_mdtt = 'CDXSwaption'">CDS Index Swaption</xsl:when>
<xsl:when test="$dsm_mdtt = 'iTraxxEuropeSwaption'">CDS Index Swaption</xsl:when>
<xsl:when test="$dsm_mdtt = 'iTraxxAsiaExJapanSwaption'">CDS Index Swaption</xsl:when>
<xsl:when test="$dsm_mdtt = 'iTraxxAustraliaSwaption'">CDS Index Swaption</xsl:when>
<xsl:when test="$dsm_mdtt = 'iTraxxJapanSwaption'">CDS Index Swaption</xsl:when>
<xsl:when test="$dsm_mdtt = 'iTraxxSovXSwaption'">CDS Index Swaption</xsl:when>
<xsl:when test="$dsm_mdtt = 'StandardLCDXBullet'">CDS on Loans</xsl:when>
<xsl:otherwise>???</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$dsm_product_type = 'CreditDefaultSwapShort'">
<xsl:choose>
<xsl:when test="$dsm_mdtt = 'AsiaCorporate'">CDS Matrix</xsl:when>
<xsl:when test="$dsm_mdtt = 'AsiaSovereign'">CDS Matrix</xsl:when>
<xsl:when test="$dsm_mdtt = 'AustraliaCorporate'">CDS Matrix</xsl:when>
<xsl:when test="$dsm_mdtt = 'AustraliaSovereign'">CDS Matrix</xsl:when>
<xsl:when test="$dsm_mdtt = 'EmergingEuropeanCorporate'">CDS Matrix</xsl:when>
<xsl:when test="$dsm_mdtt = 'EmergingEuropeanCorporateLPN'">CDS Matrix</xsl:when>
<xsl:when test="$dsm_mdtt = 'EmergingEuropeanAndMiddleEasternSovereign'">CDS Matrix</xsl:when>
<xsl:when test="$dsm_mdtt = 'EuropeanCorporate'">CDS Matrix</xsl:when>
<xsl:when test="$dsm_mdtt = 'EuropeanLimitedRecourseCorporate'">CDS Matrix</xsl:when>
<xsl:when test="$dsm_mdtt = 'JapanCorporate'">CDS Matrix</xsl:when>
<xsl:when test="$dsm_mdtt = 'JapanSovereign'">CDS Matrix</xsl:when>
<xsl:when test="$dsm_mdtt = 'LatinAmericaCorporate'">CDS Matrix</xsl:when>
<xsl:when test="$dsm_mdtt = 'LatinAmericaCorporateBond'">CDS Matrix</xsl:when>
<xsl:when test="$dsm_mdtt = 'LatinAmericaCorporateBondOrLoan'">CDS Matrix</xsl:when>
<xsl:when test="$dsm_mdtt = 'LatinAmericaSovereign'">CDS Matrix</xsl:when>
<xsl:when test="$dsm_mdtt = 'NewZealandCorporate'">CDS Matrix</xsl:when>
<xsl:when test="$dsm_mdtt = 'NewZealandSovereign'">CDS Matrix</xsl:when>
<xsl:when test="$dsm_mdtt = 'NorthAmericanCorporate'">CDS Matrix</xsl:when>
<xsl:when test="$dsm_mdtt = 'SingaporeCorporate'">CDS Matrix</xsl:when>
<xsl:when test="$dsm_mdtt = 'SingaporeSovereign'">CDS Matrix</xsl:when>
<xsl:when test="$dsm_mdtt = 'SubordinatedEuropeanInsuranceCorporate'">CDS Matrix</xsl:when>
<xsl:when test="$dsm_mdtt = 'USMunicipalFullFaithAndCredit'">CDS Matrix</xsl:when>
<xsl:when test="$dsm_mdtt = 'USMunicipalGeneralFund'">CDS Matrix</xsl:when>
<xsl:when test="$dsm_mdtt = 'USMunicipalRevenue'">CDS Matrix</xsl:when>
<xsl:when test="$dsm_mdtt = 'WesternEuropeanSovereign'">CDS Matrix</xsl:when>
<xsl:when test="$dsm_mdtt = 'SukukCorporate'">CDS Matrix</xsl:when>
<xsl:when test="$dsm_mdtt = 'SukukSovereign'">CDS Matrix</xsl:when>
<xsl:when test="$dsm_mdtt = 'EuropeanFinancialCorporate'">CDS Matrix</xsl:when>
<xsl:when test="$dsm_mdtt = 'AustraliaFinancialCorporate'">CDS Matrix</xsl:when>
<xsl:when test="$dsm_mdtt = 'NewZealandFinancialCorporate'">CDS Matrix</xsl:when>
<xsl:when test="$dsm_mdtt = 'JapanFinancialCorporate'">CDS Matrix</xsl:when>
<xsl:when test="$dsm_mdtt = 'SingaporeFinancialCorporate'">CDS Matrix</xsl:when>
<xsl:when test="$dsm_mdtt = 'AsiaFinancialCorporate'">CDS Matrix</xsl:when>
<xsl:when test="$dsm_mdtt = 'EuropeanCoCoFinancialCorporate'">CDS Matrix</xsl:when>
<xsl:when test="$dsm_mdtt = 'StandardNorthAmericanCorporate'">CDS Matrix</xsl:when>
<xsl:when test="$dsm_mdtt = 'StandardEuropeanCorporate'">CDS Matrix</xsl:when>
<xsl:when test="$dsm_mdtt = 'StandardEuropeanLimitedRecourseCorporate'">CDS Matrix</xsl:when>
<xsl:when test="$dsm_mdtt = 'StandardSubordinatedEuropeanInsuranceCorporate'">CDS Matrix</xsl:when>
<xsl:when test="$dsm_mdtt = 'StandardWesternEuropeanSovereign'">CDS Matrix</xsl:when>
<xsl:when test="$dsm_mdtt = 'StandardEmergingEuropeanCorporateLPN'">CDS Matrix</xsl:when>
<xsl:when test="$dsm_mdtt = 'StandardEmergingEuropeanCorporate'">CDS Matrix</xsl:when>
<xsl:when test="$dsm_mdtt = 'StandardLatinAmericaCorporateBond'">CDS Matrix</xsl:when>
<xsl:when test="$dsm_mdtt = 'StandardLatinAmericaCorporateBondOrLoan'">CDS Matrix</xsl:when>
<xsl:when test="$dsm_mdtt = 'StandardLatinAmericaSovereign'">CDS Matrix</xsl:when>
<xsl:when test="$dsm_mdtt = 'StandardEmergingEuropeanAndMiddleEasternSovereign'">CDS Matrix</xsl:when>
<xsl:when test="$dsm_mdtt = 'StandardAustraliaCorporate'">CDS Matrix</xsl:when>
<xsl:when test="$dsm_mdtt = 'StandardAustraliaSovereign'">CDS Matrix</xsl:when>
<xsl:when test="$dsm_mdtt = 'StandardNewZealandCorporate'">CDS Matrix</xsl:when>
<xsl:when test="$dsm_mdtt = 'StandardNewZealandSovereign'">CDS Matrix</xsl:when>
<xsl:when test="$dsm_mdtt = 'StandardAsiaCorporate'">CDS Matrix</xsl:when>
<xsl:when test="$dsm_mdtt = 'StandardAsiaSovereign'">CDS Matrix</xsl:when>
<xsl:when test="$dsm_mdtt = 'StandardSingaporeCorporate'">CDS Matrix</xsl:when>
<xsl:when test="$dsm_mdtt = 'StandardSingaporeSovereign'">CDS Matrix</xsl:when>
<xsl:when test="$dsm_mdtt = 'StandardJapanCorporate'">CDS Matrix</xsl:when>
<xsl:when test="$dsm_mdtt = 'StandardJapanSovereign'">CDS Matrix</xsl:when>
<xsl:when test="$dsm_mdtt = 'StandardSukukCorporate'">CDS Matrix</xsl:when>
<xsl:when test="$dsm_mdtt = 'StandardSukukSovereign'">CDS Matrix</xsl:when>
<xsl:when test="$dsm_mdtt = 'StandardUSMunicipalFullFaithAndCredit'">CDS Matrix</xsl:when>
<xsl:when test="$dsm_mdtt = 'StandardUSMunicipalGeneralFund'">CDS Matrix</xsl:when>
<xsl:when test="$dsm_mdtt = 'StandardUSMunicipalRevenue'">CDS Matrix</xsl:when>
<xsl:when test="$dsm_mdtt = 'StandardEuropeanFinancialCorporate'">CDS Matrix</xsl:when>
<xsl:when test="$dsm_mdtt = 'StandardAustraliaFinancialCorporate'">CDS Matrix</xsl:when>
<xsl:when test="$dsm_mdtt = 'StandardNewZealandFinancialCorporate'">CDS Matrix</xsl:when>
<xsl:when test="$dsm_mdtt = 'StandardJapanFinancialCorporate'">CDS Matrix</xsl:when>
<xsl:when test="$dsm_mdtt = 'StandardSingaporeFinancialCorporate'">CDS Matrix</xsl:when>
<xsl:when test="$dsm_mdtt = 'StandardAsiaFinancialCorporate'">CDS Matrix</xsl:when>
<xsl:when test="$dsm_mdtt = 'StandardEuropeanCoCoFinancialCorporate'">CDS Matrix</xsl:when>
<xsl:when test="$dsm_mdtt = 'ISDA2003CreditNorthAmerican'">CDS Master</xsl:when>
<xsl:when test="$dsm_mdtt = 'ISDA2003CreditEuropean'">CDS Master</xsl:when>
<xsl:when test="$dsm_mdtt = 'ISDA2003CreditAsia'">CDS Master</xsl:when>
<xsl:when test="$dsm_mdtt = 'ISDA2003CreditJapan'">CDS Master</xsl:when>
<xsl:when test="$dsm_mdtt = 'ISDA2003CreditAustraliaNewZealand'">CDS Master</xsl:when>
<xsl:when test="$dsm_mdtt = 'ISDA2003CreditSingapore'">CDS Master</xsl:when>
<xsl:when test="$dsm_mdtt = 'ISDA2004CreditSovereignAsia'">CDS Master</xsl:when>
<xsl:when test="$dsm_mdtt = 'ISDA2004CreditSovereignEmergingEuropeanAndMiddleEastern'">CDS Master</xsl:when>
<xsl:when test="$dsm_mdtt = 'ISDA2004CreditSovereignJapan'">CDS Master</xsl:when>
<xsl:when test="$dsm_mdtt = 'ISDA2004CreditSovereignLatinAmerican'">CDS Master</xsl:when>
<xsl:when test="$dsm_mdtt = 'ISDA2004CreditSovereignWesternEuropean'">CDS Master</xsl:when>
<xsl:when test="$dsm_mdtt = '2014CreditAsia'">CDS Master</xsl:when>
<xsl:when test="$dsm_mdtt = '2014CreditAustraliaNewZealand'">CDS Master</xsl:when>
<xsl:when test="$dsm_mdtt = '2014CreditEuropean'">CDS Master</xsl:when>
<xsl:when test="$dsm_mdtt = '2014CreditJapan'">CDS Master</xsl:when>
<xsl:when test="$dsm_mdtt = '2014CreditNorthAmerican'">CDS Master</xsl:when>
<xsl:when test="$dsm_mdtt = '2014CreditSingapore'">CDS Master</xsl:when>
<xsl:when test="$dsm_mdtt = '2014CreditSovereignAsia'">CDS Master</xsl:when>
<xsl:when test="$dsm_mdtt = '2014CreditSovereignEmergingEuropeanAndMiddleEastern'">CDS Master</xsl:when>
<xsl:when test="$dsm_mdtt = '2014CreditSovereignJapan'">CDS Master</xsl:when>
<xsl:when test="$dsm_mdtt = '2014CreditSovereignLatinAmerican'">CDS Master</xsl:when>
<xsl:when test="$dsm_mdtt = '2014CreditSovereignWesternEuropean'">CDS Master</xsl:when>
<xsl:when test="$dsm_mdtt = '2014CreditAsiaFinancial'">CDS Master</xsl:when>
<xsl:when test="$dsm_mdtt = '2014CreditAustraliaNewZealandFinancial'">CDS Master</xsl:when>
<xsl:when test="$dsm_mdtt = '2014CreditEuropeanFinancial'">CDS Master</xsl:when>
<xsl:when test="$dsm_mdtt = '2014CreditJapanFinancial'">CDS Master</xsl:when>
<xsl:when test="$dsm_mdtt = '2014CreditSingaporeFinancial'">CDS Master</xsl:when>
<xsl:when test="$dsm_mdtt = '2014CreditEuropeanCoCoFinancial'">CDS Master</xsl:when>
<xsl:when test="$dsm_mdtt = 'ISDA2003StandardCreditNorthAmerican'">CDS Master</xsl:when>
<xsl:when test="$dsm_mdtt = 'ISDA2003StandardCreditEuropean'">CDS Master</xsl:when>
<xsl:when test="$dsm_mdtt = 'ISDA2004StandardCreditSovereignWesternEuropean'">CDS Master</xsl:when>
<xsl:when test="$dsm_mdtt = 'ISDA2004StandardCreditSovereignEmergingEuropeanAndMiddleEastern'">CDS Master</xsl:when>
<xsl:when test="$dsm_mdtt = 'ISDA2004StandardCreditSovereignLatinAmerican'">CDS Master</xsl:when>
<xsl:when test="$dsm_mdtt = 'ISDA2003StandardCreditAustraliaNewZealand'">CDS Master</xsl:when>
<xsl:when test="$dsm_mdtt = 'ISDA2003StandardCreditAsia'">CDS Master</xsl:when>
<xsl:when test="$dsm_mdtt = 'ISDA2003StandardCreditSingapore'">CDS Master</xsl:when>
<xsl:when test="$dsm_mdtt = 'ISDA2004StandardCreditSovereignAsia'">CDS Master</xsl:when>
<xsl:when test="$dsm_mdtt = 'ISDA2003StandardCreditJapan'">CDS Master</xsl:when>
<xsl:when test="$dsm_mdtt = 'ISDA2004StandardCreditSovereignJapan'">CDS Master</xsl:when>
<xsl:when test="$dsm_mdtt = '2014StandardCreditAsia'">CDS Master</xsl:when>
<xsl:when test="$dsm_mdtt = '2014StandardCreditAustraliaNewZealand'">CDS Master</xsl:when>
<xsl:when test="$dsm_mdtt = '2014StandardCreditEuropean'">CDS Master</xsl:when>
<xsl:when test="$dsm_mdtt = '2014StandardCreditJapan'">CDS Master</xsl:when>
<xsl:when test="$dsm_mdtt = '2014StandardCreditNorthAmerican'">CDS Master</xsl:when>
<xsl:when test="$dsm_mdtt = '2014StandardCreditSingapore'">CDS Master</xsl:when>
<xsl:when test="$dsm_mdtt = '2014StandardCreditSovereignAsia'">CDS Master</xsl:when>
<xsl:when test="$dsm_mdtt = '2014StandardCreditSovereignEmergingEuropeanAndMiddleEastern'">CDS Master</xsl:when>
<xsl:when test="$dsm_mdtt = '2014StandardCreditSovereignJapan'">CDS Master</xsl:when>
<xsl:when test="$dsm_mdtt = '2014StandardCreditSovereignLatinAmerican'">CDS Master</xsl:when>
<xsl:when test="$dsm_mdtt = '2014StandardCreditSovereignWesternEuropean'">CDS Master</xsl:when>
<xsl:when test="$dsm_mdtt = '2014StandardCreditAsiaFinancial'">CDS Master</xsl:when>
<xsl:when test="$dsm_mdtt = '2014StandardCreditAustraliaNewZealandFinancial'">CDS Master</xsl:when>
<xsl:when test="$dsm_mdtt = '2014StandardCreditEuropeanFinancial'">CDS Master</xsl:when>
<xsl:when test="$dsm_mdtt = '2014StandardCreditJapanFinancial'">CDS Master</xsl:when>
<xsl:when test="$dsm_mdtt = '2014StandardCreditSingaporeFinancial'">CDS Master</xsl:when>
<xsl:when test="$dsm_mdtt = '2014StandardCreditEuropeanCoCoFinancial'">CDS Master</xsl:when>
<xsl:when test="$dsm_mdtt = 'StandardLCDSBullet'">CDS on Loans</xsl:when>
<xsl:when test="$dsm_mdtt = 'CDSonLeveragedLoans'">CDS on Loans</xsl:when>
<xsl:when test="$dsm_mdtt = 'StandardTermsSupplement'">CDS on MBS</xsl:when>
<xsl:when test="$dsm_mdtt = 'EuropeanCMBS'">CDS on MBS</xsl:when>
<xsl:when test="$dsm_mdtt = 'EuropeanRMBS'">CDS on MBS</xsl:when>
<xsl:otherwise>???</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:otherwise>???</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template name="getProductTypeFromTiwPos">
<xsl:param name="dsm_product_type"/>
<xsl:param name="documentation"/>
<xsl:param name="sector"/>
<xsl:param name="category"/>
<xsl:param name="contractual_terms_supplement_type"/>
<xsl:param name="credit_default_swap_option"/>
<xsl:choose>
<xsl:when test="$dsm_product_type = 'CreditDefaultSwapShort'">
<xsl:choose>
<xsl:when test="$documentation/fpml:contractualMatrix">CDS Matrix</xsl:when>
<xsl:when test="$documentation/fpml:masterConfirmation">CDS Master</xsl:when>
<xsl:when test="$contractual_terms_supplement_type = 'StandardTermsSupplement'">
<xsl:choose>
<xsl:when test="$sector = 'RMBS'">CDS on MBS</xsl:when>
<xsl:when test="$sector = 'CMBS'">CDS on MBS</xsl:when>
<xsl:when test="$category = 'Loan'">CDS on Loans</xsl:when>
<xsl:otherwise>???</xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$contractual_terms_supplement_type = 'CDSonMBS'">CDS on MBS</xsl:when>
<xsl:when test="$contractual_terms_supplement_type = 'EuropeanRMBS'">CDS on MBS</xsl:when>
<xsl:when test="$contractual_terms_supplement_type = 'EuropeanCMBS'">CDS on MBS</xsl:when>
<xsl:when test="$contractual_terms_supplement_type = 'CDSonLeveragedLoans'">CDS on Loans</xsl:when>
<xsl:when test="$contractual_terms_supplement_type = 'StandardLCDSBullet'">CDS on Loans</xsl:when>
</xsl:choose>
</xsl:when>
<xsl:when test="$dsm_product_type = 'CreditDefaultSwapIndex' and $credit_default_swap_option">CDS Index Swaption</xsl:when>
<xsl:when test="$dsm_product_type = 'CreditDefaultSwapIndex'">CDS Index</xsl:when>
<xsl:when test="$dsm_product_type = 'CreditDefaultSwapIndexTranche'">CDS Index</xsl:when>
<xsl:otherwise>????</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template name="getSubProductTypeFromTiwPos">
<xsl:param name="mw_product_type"/>
<xsl:param name="documentation"/>
<xsl:param name="sector"/>
<xsl:param name="category"/>
<xsl:param name="contractual_terms_supplement_type"/>
<xsl:choose>
<xsl:when test="$mw_product_type = 'CDS on Loans'">
<xsl:choose>
<xsl:when test="$contractual_terms_supplement_type = 'CDSonLeveragedLoans'">ELCDS</xsl:when>
<xsl:when test="$contractual_terms_supplement_type = 'StandardLCDSBullet'">Bullet LCDS</xsl:when>
<xsl:when test="$category = 'Loan'">LCDS</xsl:when>
</xsl:choose>
</xsl:when>
<xsl:when test="$mw_product_type = 'CDS on MBS'">
<xsl:choose>
<xsl:when test="$contractual_terms_supplement_type = 'EuropeanRMBS'">ERMBS</xsl:when>
<xsl:when test="$contractual_terms_supplement_type = 'EuropeanCMBS'">ECMBS</xsl:when>
<xsl:when test="$sector = 'RMBS'">RMBS</xsl:when>
<xsl:when test="$sector = 'CMBS'">CMBS</xsl:when>
</xsl:choose>
</xsl:when>
</xsl:choose>
</xsl:template>
<xsl:template name="getDocsTypeFromTiwRec">
<xsl:param name="mw_product_type"/>
<xsl:param name="dsm_mdtt"/>
<xsl:choose>
<xsl:when test="$mw_product_type='CDS Master'">
<xsl:choose>
<xsl:when test="$dsm_mdtt='ISDA2003StandardCreditNorthAmerican'">Standard North American Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='ISDA2003CreditNorthAmerican'">North American Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='ISDA2003CreditEuropean'">European Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='ISDA2003StandardCreditEuropean'">Standard European Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='ISDA2003CreditAustraliaNewZealand'">Australia and New Zealand Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='ISDA2003StandardCreditAustraliaNewZealand'">Standard Australia and New Zealand Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='ISDA2003CreditJapan'">Japan Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='ISDA2003StandardCreditJapan'">Standard Japan Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='ISDA2003CreditSingapore'">Singapore Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='ISDA2003StandardCreditSingapore'">Standard Singapore Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='ISDA2003CreditAsia'">Asia Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='ISDA2003StandardCreditAsia'">Standard Asia Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='ISDA2004CreditSovereignAsia'">Asia Sovereign</xsl:when>
<xsl:when test="$dsm_mdtt='ISDA2004StandardCreditSovereignAsia'">Standard Asia Sovereign</xsl:when>
<xsl:when test="$dsm_mdtt='ISDA2004CreditSovereignEmergingEuropeanAndMiddleEastern'">Emerging European and Middle Eastern Sovereign</xsl:when>
<xsl:when test="$dsm_mdtt='ISDA2004StandardCreditSovereignEmergingEuropeanAndMiddleEastern'">Standard Emerging European and Middle Eastern Sovereign</xsl:when>
<xsl:when test="$dsm_mdtt='ISDA2004CreditSovereignJapan'">Japan Sovereign</xsl:when>
<xsl:when test="$dsm_mdtt='ISDA2004StandardCreditSovereignJapan'">Standard Japan Sovereign</xsl:when>
<xsl:when test="$dsm_mdtt='ISDA2004CreditSovereignLatinAmerican'">Latin America Sovereign</xsl:when>
<xsl:when test="$dsm_mdtt='ISDA2004StandardCreditSovereignLatinAmerican'">Standard Latin America Sovereign</xsl:when>
<xsl:when test="$dsm_mdtt='ISDA2004CreditSovereignWesternEuropean'">Western European Sovereign</xsl:when>
<xsl:when test="$dsm_mdtt='ISDA2004StandardCreditSovereignWesternEuropean'">Standard Western European Sovereign</xsl:when>
<xsl:when test="$dsm_mdtt='StandardUSMunicipalFullFaithAndCredit'">Standard US Municipal Full Faith And Credit</xsl:when>
<xsl:when test="$dsm_mdtt='StandardUSMunicipalGeneralFund'">Standard US Municipal General Fund</xsl:when>
<xsl:when test="$dsm_mdtt='StandardUSMunicipalRevenue'">Standard US Municipal Revenue</xsl:when>
<xsl:when test="$dsm_mdtt='2014CreditAsia'">Asia Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='2014StandardCreditAsia'">Standard Asia Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='2014CreditAsiaFinancial'">Asia Financial Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='2014StandardCreditAsiaFinancial'">Standard Asia Financial Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='2014CreditSovereignAsia'">Asia Sovereign</xsl:when>
<xsl:when test="$dsm_mdtt='2014StandardCreditSovereignAsia'">Standard Asia Sovereign</xsl:when>
<xsl:when test="$dsm_mdtt='2014CreditAustraliaNewZealand'">Australia and New Zealand Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='2014StandardCreditAustraliaNewZealand'">Standard Australia and New Zealand Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='2014CreditAustraliaNewZealandFinancial'">Australia and New Zealand Financial Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='2014StandardCreditAustraliaNewZealandFinancial'">Standard Australia and New Zealand Financial Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='2014CreditSovereignEmergingEuropeanAndMiddleEastern'">Emerging European and Middle Eastern Sovereign</xsl:when>
<xsl:when test="$dsm_mdtt='2014StandardCreditSovereignEmergingEuropeanAndMiddleEastern'">Standard Emerging European and Middle Eastern Sovereign</xsl:when>
<xsl:when test="$dsm_mdtt='2014CreditEuropean'">European Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='2014StandardCreditEuropean'">Standard European Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='2014CreditEuropeanFinancial'">European Financial Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='2014StandardCreditEuropeanFinancial'">Standard European Financial Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='2014CreditJapan'">Japan Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='2014StandardCreditJapan'">Standard Japan Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='2014CreditJapanFinancial'">Japan Financial Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='2014StandardCreditJapanFinancial'">Standard Japan Financial Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='2014CreditSovereignJapan'">Japan Sovereign</xsl:when>
<xsl:when test="$dsm_mdtt='2014StandardCreditSovereignJapan'">Standard Japan Sovereign</xsl:when>
<xsl:when test="$dsm_mdtt='2014CreditSovereignLatinAmerican'">Latin America Sovereign</xsl:when>
<xsl:when test="$dsm_mdtt='2014StandardCreditSovereignLatinAmerican'">Standard Latin America Sovereign</xsl:when>
<xsl:when test="$dsm_mdtt='2014CreditSovereignWesternEuropean'">Western European Sovereign</xsl:when>
<xsl:when test="$dsm_mdtt='2014StandardCreditSovereignWesternEuropean'">Standard Western European Sovereign</xsl:when>
<xsl:when test="$dsm_mdtt='2014StandardCreditNorthAmerican'">Standard North American Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='2014CreditNorthAmerican'">North American Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='2014StandardCreditNorthAmericanFinancial'">Standard North American Financial Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='2014CreditNorthAmericanFinancial'">North American Financial Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='2014CreditSingapore'">Singapore Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='2014StandardCreditSingapore'">Standard Singapore Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='2014CreditSingaporeFinancial'">Singapore Financial Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='2014StandardCreditSingaporeFinancial'">Standard Singapore Financial Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='2014CreditEuropeanCoCoFinancial'">European CoCo Financial Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='2014StandardCreditEuropeanCoCoFinancial'">Standard European CoCo Financial Corporate</xsl:when>
<xsl:otherwise><xsl:value-of select="$dsm_mdtt"/></xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$mw_product_type='CDS Matrix'">
<xsl:choose>
<xsl:when test="$dsm_mdtt='StandardNorthAmericanCorporate'">Standard North American Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='NorthAmericanCorporate'">North American Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='StandardNorthAmericanFinancialCorporate'">Standard North American Financial Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='NorthAmericanFinancialCorporate'">North American Financial Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='EuropeanCorporate'">European Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='EuropeanLimitedRecourseCorporate'">European Limited Recourse Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='StandardEuropeanCorporate'">Standard European Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='StandardEuropeanLimitedRecourseCorporate'">Standard European Limited Recourse Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='EuropeanFinancialCorporate'">European Financial Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='StandardEuropeanFinancialCorporate'">Standard European Financial Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='EuropeanCoCoFinancialCorporate'">European CoCo Financial Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='StandardEuropeanCoCoFinancialCorporate'">Standard European CoCo Financial Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='AustraliaCorporate'">Australia Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='StandardAustraliaCorporate'">Standard Australia Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='AustraliaFinancialCorporate'">Australia Financial Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='StandardAustraliaFinancialCorporate'">Standard Australia Financial Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='NewZealandCorporate'">New Zealand Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='StandardNewZealandCorporate'">Standard New Zealand Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='NewZealandFinancialCorporate'">New Zealand Financial Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='StandardNewZealandFinancialCorporate'">Standard New Zealand Financial Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='JapanCorporate'">Japan Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='StandardJapanCorporate'">Standard Japan Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='JapanFinancialCorporate'">Japan Financial Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='StandardJapanFinancialCorporate'">Standard Japan Financial Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='SingaporeCorporate'">Singapore Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='StandardSingaporeCorporate'">Standard Singapore Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='SingaporeFinancialCorporate'">Singapore Financial Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='StandardSingaporeFinancialCorporate'">Standard Singapore Financial Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='AsiaCorporate'">Asia Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='StandardAsiaCorporate'">Standard Asia Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='AsiaFinancialCorporate'">Asia Financial Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='StandardAsiaFinancialCorporate'">Standard Asia Financial Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='SubordinatedEuropeanInsuranceCorporate'">Subordinated European Insurance Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='StandardSubordinatedEuropeanInsuranceCorporate'">Standard Subordinated European Insurance Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='EmergingEuropeanCorporate'">Emerging European Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='StandardEmergingEuropeanCorporate'">Standard Emerging European Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='EmergingEuropeanFinancialCorporate'">Emerging European Financial Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='StandardEmergingEuropeanFinancialCorporate'">Standard Emerging European Financial Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='EmergingEuropeanCorporateLPN'">Emerging European Corporate LPN</xsl:when>
<xsl:when test="$dsm_mdtt='StandardEmergingEuropeanCorporateLPN'">Standard Emerging European Corporate LPN</xsl:when>
<xsl:when test="$dsm_mdtt='EmergingEuropeanFinancialCorporateLPN'">Emerging European Financial Corporate LPN</xsl:when>
<xsl:when test="$dsm_mdtt='StandardEmergingEuropeanFinancialCorporateLPN'">Standard Emerging European Financial Corporate LPN</xsl:when>
<xsl:when test="$dsm_mdtt='LatinAmericaCorporate'">Latin America Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='LatinAmericaCorporateBond'">Latin America Corporate Bond</xsl:when>
<xsl:when test="$dsm_mdtt='LatinAmericaFinancialCorporateBond'">Latin America Financial Corporate Bond</xsl:when>
<xsl:when test="$dsm_mdtt='StandardLatinAmericaCorporateBond'">Standard Latin America Corporate Bond</xsl:when>
<xsl:when test="$dsm_mdtt='StandardLatinAmericaFinancialCorporateBond'">Standard Latin America Financial Corporate Bond</xsl:when>
<xsl:when test="$dsm_mdtt='LatinAmericaCorporateBondOrLoan'">Latin America Corporate Bond Or Loan</xsl:when>
<xsl:when test="$dsm_mdtt='LatinAmericaFinancialCorporateBondOrLoan'">Latin America Financial Corporate Bond Or Loan</xsl:when>
<xsl:when test="$dsm_mdtt='StandardLatinAmericaCorporateBondOrLoan'">Standard Latin America Corporate Bond Or Loan</xsl:when>
<xsl:when test="$dsm_mdtt='StandardLatinAmericaFinancialCorporateBondOrLoan'">Standard Latin America Financial Corporate Bond Or Loan</xsl:when>
<xsl:when test="$dsm_mdtt='AsiaSovereign'">Asia Sovereign</xsl:when>
<xsl:when test="$dsm_mdtt='StandardAsiaSovereign'">Standard Asia Sovereign</xsl:when>
<xsl:when test="$dsm_mdtt='EmergingEuropeanAndMiddleEasternSovereign'">Emerging European and Middle Eastern Sovereign</xsl:when>
<xsl:when test="$dsm_mdtt='StandardEmergingEuropeanAndMiddleEasternSovereign'">Standard Emerging European and Middle Eastern Sovereign</xsl:when>
<xsl:when test="$dsm_mdtt='JapanSovereign'">Japan Sovereign</xsl:when>
<xsl:when test="$dsm_mdtt='StandardJapanSovereign'">Standard Japan Sovereign</xsl:when>
<xsl:when test="$dsm_mdtt='AustraliaSovereign'">Australia Sovereign</xsl:when>
<xsl:when test="$dsm_mdtt='StandardAustraliaSovereign'">Standard Australia Sovereign</xsl:when>
<xsl:when test="$dsm_mdtt='NewZealandSovereign'">New Zealand Sovereign</xsl:when>
<xsl:when test="$dsm_mdtt='StandardNewZealandSovereign'">Standard New Zealand Sovereign</xsl:when>
<xsl:when test="$dsm_mdtt='SingaporeSovereign'">Singapore Sovereign</xsl:when>
<xsl:when test="$dsm_mdtt='StandardSingaporeSovereign'">Standard Singapore Sovereign</xsl:when>
<xsl:when test="$dsm_mdtt='LatinAmericaSovereign'">Latin America Sovereign</xsl:when>
<xsl:when test="$dsm_mdtt='StandardLatinAmericaSovereign'">Standard Latin America Sovereign</xsl:when>
<xsl:when test="$dsm_mdtt='WesternEuropeanSovereign'">Western European Sovereign</xsl:when>
<xsl:when test="$dsm_mdtt='StandardWesternEuropeanSovereign'">Standard Western European Sovereign</xsl:when>
<xsl:when test="$dsm_mdtt='StandardUSMunicipalFullFaithAndCredit'">Standard US Municipal Full Faith And Credit</xsl:when>
<xsl:when test="$dsm_mdtt='StandardUSMunicipalGeneralFund'">Standard US Municipal General Fund</xsl:when>
<xsl:when test="$dsm_mdtt='StandardUSMunicipalRevenue'">Standard US Municipal Revenue</xsl:when>
<xsl:when test="$dsm_mdtt='USMunicipalFullFaithAndCredit'">US Municipal Full Faith And Credit</xsl:when>
<xsl:when test="$dsm_mdtt='USMunicipalGeneralFund'">US Municipal General Fund</xsl:when>
<xsl:when test="$dsm_mdtt='USMunicipalRevenue'">US Municipal Revenue</xsl:when>
<xsl:when test="$dsm_mdtt='SukukCorporate'">Sukuk Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='StandardSukukCorporate'">Standard Sukuk Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='SukukFinancialCorporate'">Sukuk Financial Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='StandardSukukFinancialCorporate'">Standard Sukuk Financial Corporate</xsl:when>
<xsl:when test="$dsm_mdtt='SukukSovereign'">Sukuk Sovereign</xsl:when>
<xsl:when test="$dsm_mdtt='StandardSukukSovereign'">Standard Sukuk Sovereign</xsl:when>
<xsl:otherwise><xsl:value-of select="$dsm_mdtt"/></xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$mw_product_type='CDS on MBS'">
<xsl:choose>
<xsl:when test="$dsm_mdtt = 'StandardTermsSupplement'">CDSonMBS</xsl:when>
<xsl:otherwise><xsl:value-of select="$dsm_mdtt"/></xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:otherwise><xsl:value-of select="$dsm_mdtt"/></xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template name="getDocsTypeFromTiwPos">
<xsl:param name="mw_product_type"/>
<xsl:param name="dsm_mdtt"/>
<xsl:choose>
<xsl:when test="$mw_product_type='CDS on MBS'">
<xsl:choose>
<xsl:when test="$dsm_mdtt = 'StandardTermsSupplement'">CDSonMBS</xsl:when>
<xsl:otherwise><xsl:value-of select="$dsm_mdtt"/></xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="$mw_product_type='CDS Master'">
<xsl:choose>
<xsl:when test="$dsm_mdtt = 'ISDA2003CreditNorthAmerican'">North American Corporate</xsl:when>
<xsl:when test="$dsm_mdtt = 'ISDA2003CreditEuropean'">European Corporate</xsl:when>
<xsl:when test="$dsm_mdtt = 'ISDA2003CreditAsia'">Asia Corporate</xsl:when>
<xsl:when test="$dsm_mdtt = 'ISDA2003CreditJapan'">Japan Corporate</xsl:when>
<xsl:when test="$dsm_mdtt = 'ISDA2003CreditAustraliaNewZealand'">Australia and New Zealand Corporate</xsl:when>
<xsl:when test="$dsm_mdtt = 'ISDA2003CreditSingapore'">Singapore Corporate</xsl:when>
<xsl:when test="$dsm_mdtt = 'ISDA2004CreditSovereignAsia'">Asia Sovereign</xsl:when>
<xsl:when test="$dsm_mdtt = 'ISDA2004CreditSovereignEmergingEuropeanAndMiddleEastern '">Emerging European and Middle Eastern Sovereign</xsl:when>
<xsl:when test="$dsm_mdtt = 'ISDA2004CreditSovereignJapan'">Japan Sovereign</xsl:when>
<xsl:when test="$dsm_mdtt = 'ISDA2004CreditSovereignLatinAmerican'">Latin America Sovereign</xsl:when>
<xsl:when test="$dsm_mdtt = 'ISDA2004CreditSovereignWesternEuropean'">Western European Sovereign</xsl:when>
<xsl:when test="$dsm_mdtt = '2014CreditAsia'">Asia Corporate</xsl:when>
<xsl:when test="$dsm_mdtt = '2014CreditAustraliaNewZealand'">Australia and New Zealand Corporate</xsl:when>
<xsl:when test="$dsm_mdtt = '2014CreditEuropean'">European Corporate</xsl:when>
<xsl:when test="$dsm_mdtt = '2014CreditJapan'">Japan Corporate</xsl:when>
<xsl:when test="$dsm_mdtt = '2014CreditNorthAmerican'">North American Corporate</xsl:when>
<xsl:when test="$dsm_mdtt = '2014CreditSingapore'">Singapore Corporate</xsl:when>
<xsl:when test="$dsm_mdtt = '2014CreditSovereignAsia'">Asia Sovereign</xsl:when>
<xsl:when test="$dsm_mdtt = '2014CreditSovereignEmergingEuropeanAndMiddleEastern'">Emerging European and Middle Eastern Sovereign</xsl:when>
<xsl:when test="$dsm_mdtt = '2014CreditSovereignJapan'">Japan Sovereign</xsl:when>
<xsl:when test="$dsm_mdtt = '2014CreditSovereignLatinAmerican'">Latin America Sovereign</xsl:when>
<xsl:when test="$dsm_mdtt = '2014CreditSovereignWesternEuropean'">Western European Sovereign</xsl:when>
<xsl:when test="$dsm_mdtt = '2014CreditAsiaFinancial'">Asia Financial Corporate</xsl:when>
<xsl:when test="$dsm_mdtt = '2014CreditAustraliaNewZealandFinancial'">Australia and New Zealand Financial Corporate</xsl:when>
<xsl:when test="$dsm_mdtt = '2014CreditEuropeanFinancial'">European Financial Corporate</xsl:when>
<xsl:when test="$dsm_mdtt = '2014CreditJapanFinancial'">Japan Financial Corporate</xsl:when>
<xsl:when test="$dsm_mdtt = '2014CreditSingaporeFinancial'">Singapore Financial Corporate</xsl:when>
<xsl:when test="$dsm_mdtt = '2014CreditEuropeanCoCoFinancial'">European CoCo Financial Corporate</xsl:when>
<xsl:when test="$dsm_mdtt = 'ISDA2003StandardCreditNorthAmerican'">Standard North American Corporate</xsl:when>
<xsl:when test="$dsm_mdtt = 'ISDA2003StandardCreditEuropean'">Standard European Corporate</xsl:when>
<xsl:when test="$dsm_mdtt = 'ISDA2004StandardCreditSovereignWesternEuropean'">Standard Western European Sovereign</xsl:when>
<xsl:when test="$dsm_mdtt = 'ISDA2004StandardCreditSovereignEmergingEuropeanAndMiddleEastern'">Standard Emerging European and Middle Eastern Sovereign</xsl:when>
<xsl:when test="$dsm_mdtt = 'ISDA2004StandardCreditSovereignLatinAmerican'">Standard Latin America Sovereign</xsl:when>
<xsl:when test="$dsm_mdtt = 'ISDA2003StandardCreditAustraliaNewZealand'">Standard Australia and New Zealand Corporate</xsl:when>
<xsl:when test="$dsm_mdtt = 'ISDA2003StandardCreditAsia'">Standard Asia Corporate</xsl:when>
<xsl:when test="$dsm_mdtt = 'ISDA2003StandardCreditSingapore'">Standard Singapore Corporate</xsl:when>
<xsl:when test="$dsm_mdtt = 'ISDA2004StandardCreditSovereignAsia'">Standard Asia Sovereign</xsl:when>
<xsl:when test="$dsm_mdtt = 'ISDA2003StandardCreditJapan'">Standard Japan Corporate</xsl:when>
<xsl:when test="$dsm_mdtt = 'ISDA2004StandardCreditSovereignJapan'">Standard Japan Sovereign</xsl:when>
<xsl:when test="$dsm_mdtt = '2014StandardCreditAsia'">Standard Asia Corporate</xsl:when>
<xsl:when test="$dsm_mdtt = '2014StandardCreditAustraliaNewZealand'">Standard Australia and New Zealand Corporate</xsl:when>
<xsl:when test="$dsm_mdtt = '2014StandardCreditEuropean'">Standard European Corporate</xsl:when>
<xsl:when test="$dsm_mdtt = '2014StandardCreditJapan'">Standard Japan Corporate</xsl:when>
<xsl:when test="$dsm_mdtt = '2014StandardCreditNorthAmerican'">Standard North American Corporate</xsl:when>
<xsl:when test="$dsm_mdtt = '2014StandardCreditSingapore'">Standard Singapore Corporate</xsl:when>
<xsl:when test="$dsm_mdtt = '2014StandardCreditSovereignAsia'">Standard Asia Sovereign</xsl:when>
<xsl:when test="$dsm_mdtt = '2014StandardCreditSovereignEmergingEuropeanAndMiddleEastern'">Standard Emerging European and Middle Eastern Sovereign</xsl:when>
<xsl:when test="$dsm_mdtt = '2014StandardCreditSovereignJapan'">Standard Japan Sovereign</xsl:when>
<xsl:when test="$dsm_mdtt = '2014StandardCreditSovereignLatinAmerican'">Standard Latin America Sovereign</xsl:when>
<xsl:when test="$dsm_mdtt = '2014StandardCreditSovereignWesternEuropean'">Standard Western European Sovereign</xsl:when>
<xsl:when test="$dsm_mdtt = '2014StandardCreditAsiaFinancial'">Standard Asia Financial Corporate</xsl:when>
<xsl:when test="$dsm_mdtt = '2014StandardCreditAustraliaNewZealandFinancial'">Standard Australia and New Zealand Financial Corporate</xsl:when>
<xsl:when test="$dsm_mdtt = '2014StandardCreditEuropeanFinancial'">Standard European Financial Corporate</xsl:when>
<xsl:when test="$dsm_mdtt = '2014StandardCreditJapanFinancial'">Standard Japan Financial Corporate</xsl:when>
<xsl:when test="$dsm_mdtt = '2014StandardCreditSingaporeFinancial'">Standard Singapore Financial Corporate</xsl:when>
<xsl:when test="$dsm_mdtt = '2014StandardCreditEuropeanCoCoFinancial'">Standard European CoCo Financial Corporate</xsl:when>
<xsl:otherwise><xsl:value-of select="$dsm_mdtt"/></xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:otherwise><xsl:value-of select="$dsm_mdtt"/></xsl:otherwise>
</xsl:choose>
</xsl:template>
</xsl:stylesheet>
