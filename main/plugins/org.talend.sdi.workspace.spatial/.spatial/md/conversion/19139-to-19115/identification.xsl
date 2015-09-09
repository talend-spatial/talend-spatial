<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:fra="http://www.cnig.gouv.fr/2005/fra" 
										xmlns:gmd="http://www.isotc211.org/2005/gmd"
										xmlns:gco="http://www.isotc211.org/2005/gco"
										xmlns:gts="http://www.isotc211.org/2005/gts"
										xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
										xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
										exclude-result-prefixes="fra gmd gco gts xsi">

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="DataIdentification"> 

		<idCitation><!--1..1-->
				<xsl:apply-templates select="gmd:citation/gmd:CI_Citation" mode="Citation"/>
		</idCitation>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<idAbs><!--1..1-->
			<xsl:value-of select="gmd:abstract/gco:CharacterString"/>
		</idAbs>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:purpose">
			<idPurp><!--0..1-->
				<xsl:value-of select="gco:CharacterString"/>
			</idPurp>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:credit">
			<idCredit><!--0..n-->
				<xsl:value-of select="gco:CharacterString"/>
			</idCredit>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:status">
			<status><!--0..n-->
				<ProgCd value="{gmd:MD_ProgressCode/@codeListValue}" /><!--1..1-->
			</status>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:pointOfContact">
			<idPoC><!--0..n-->
					<xsl:apply-templates select="gmd:CI_ResponsibleParty" mode="RespParty"/>
			</idPoC>
		</xsl:for-each>
		
	<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:resourceConstraints">
			<resConst><!--0..n-->
				<xsl:apply-templates select="." mode="ConstsTypes"/>
			</resConst>
		</xsl:for-each>
		
		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:resourceFormat">
			<dsFormat><!--0..n-->
					<xsl:apply-templates select="gmd:MD_Format" mode="Format"/>
			</dsFormat>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:resourceSpecificUsage">
			<idSpecUse><!--0..n-->
					<xsl:apply-templates select="gmd:MD_Usage" mode="Usage"/>
			</idSpecUse>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:resourceMaintenance">
			<resMaint><!--0..n-->
					<xsl:apply-templates select="gmd:MD_MaintenanceInformation" mode="MaintInfo"/>
			</resMaint>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:descriptiveKeywords">
			<descKeys><!--0..n-->
					<xsl:apply-templates select="gmd:MD_Keywords" mode="Keywords"/>
			</descKeys>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:graphicOverview">
			<graphOver><!--0..n-->
					<xsl:apply-templates select="gmd:MD_BrowseGraphic" mode="BrowGraph"/>
			</graphOver>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:spatialRepresentationType">
			<spatRpType><!--0..n-->
				<SpatRepTypCd value="{gmd:MD_SpatialRepresentationTypeCode/@codeListValue}" />
			</spatRpType>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:if test="gmd:spatialResolution/descendant::text()">
			<xsl:for-each select="gmd:spatialResolution">
				<dataScale><!--0..n-->
					<xsl:apply-templates select="gmd:MD_Resolution" mode="Resol"/>
				</dataScale>
			</xsl:for-each>
		</xsl:if>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
		<xsl:if test ="not(gmd:language)">
			<dataLang><!--1..n-->
				<languageCode value="fra"/>
			</dataLang>
		</xsl:if>
		
		<xsl:for-each select="gmd:language"><!--  SILOGIC Conversion minuscule -->
			<dataLang><!--1..n-->
				<languageCode value="{translate(gco:CharacterString, $uppercase, $lowercase)}"/>
			</dataLang>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:if test="not(gmd:characterSet)">
			<dataChar><!--0..1 = mais par défaut utf8 SILOGIC  -->
				<CharSetCd value="utf8"/>
			</dataChar>	
		</xsl:if>

		<xsl:for-each select="gmd:characterSet"> 
			<dataChar>
				<CharSetCd value="{gmd:MD_CharacterSetCode/@codeListValue}" />
			</dataChar>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:if test="not(gmd:topicCategory)"> <!-- SILOGIC si balise absente--> 
			<tpCat><!--1..n-->
				<TopicCatCd value="unknown"/><!-- SILOGIC RAJOUTE DANS LA LISTE DES VALEURS POSSIBLES -->
			</tpCat>	
		</xsl:if>

		<xsl:for-each select="gmd:topicCategory"> <!-- SILOGIC ATTENTION  Pas de liste -->
			<tpCat><!--1..n-->
				<TopicCatCd value="{gmd:MD_TopicCategoryCode}" />
			</tpCat>
		</xsl:for-each>
		
		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
		
		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<!-- SILOGIC ATTENTION DUPLICATION DES DONNEES DANS LA 19115 DANS LE BLOC dataExt - premier bloc de données EXTENT -->
		<!-- DELETED SILOGIC
		<xsl:for-each select="gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox">
			<geoBox>    <- 0..n ->
				<xsl:apply-templates select="." mode="GeoBox"/>   <-  SILOGIC Factorisation dans extent.xsl ->
			</geoBox>
		</xsl:for-each> 
-->

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<!-- SILOGIC ATTENTION DUPLICATION DES DONNEES DANS LA 19115 DANS LE BLOC dataExt - premier bloc de données EXTENT -->
		<!-- DELETED SILOGIC
		<xsl:for-each select="gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicDescription">
			<geoDesc>      <- 0..n ->
				<xsl:apply-templates select="." mode="GeoDesc"/>
			</geoDesc>
		</xsl:for-each>	
-->

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:environmentDescription">
			<envirDesc><!--0..1-->
				<xsl:value-of select="gco:CharacterString"/>
			</envirDesc>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:extent">
			<dataExt><!--0..n-->
					<xsl:apply-templates select="gmd:EX_Extent" mode="Extent"/>
			</dataExt>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:supplementalInformation">
			<suppInfo><!--0..1-->
				<xsl:value-of select="gco:CharacterString"/>
			</suppInfo>
		</xsl:for-each>


		<xsl:for-each select="fra:relatedCitation"> <!-- PROFIL FRANCAIS -->
			<frCitation><!--0..n-->
				<xsl:apply-templates select="gmd:CI_Citation" mode="Citation"/>
			</frCitation>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->
	<!-- === MaintInfo === -->
	<!-- ============================================================================= -->

	<xsl:template match="*" mode="MaintInfo">

		<maintFreq><!--1..1-->
			<MaintFreqCd value="{gmd:maintenanceAndUpdateFrequency/gmd:MD_MaintenanceFrequencyCode/@codeListValue}" />
		</maintFreq>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:dateOfNextUpdate">
			<dateNext><!--0..1-->
					<xsl:value-of select="gco:Date"/> <!-- SILOGIC Choice Date OU DateTime -->
					<xsl:value-of select="gco:DateTime"/>
			</dateNext>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:userDefinedMaintenanceFrequency">
			<usrDefFreq><!--0..1-->	
					<xsl:apply-templates select="gts:TM_PeriodDuration" mode="TM_PeriodDuration"/>
			</usrDefFreq>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:updateScope">
			<maintScp><!--0..n-->
				<ScopeCd value="{gmd:MD_ScopeCode/@codeListValue}" />
			</maintScp>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:updateScopeDescription">
			<upScpDesc><!--0..n-->
				<xsl:apply-templates select="gmd:MD_ScopeDescription" mode="ScpDesc"/>
			</upScpDesc>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:maintenanceNote">
			<maintNote><!--0..n-->
				<xsl:value-of select="gco:CharacterString"/>
			</maintNote>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="TM_PeriodDuration"> <!-- SILOGIC Décomposer une xs:duration en années,mois,jours,heures,minutes,secondes -->
	
	<!-- XPATH 2.0 - encore non accepte par Xerces  
		<xsl:variable name="Var_TM_PeriodDuration" select="xsi:duration( . )"/>
		<years>
			<xsl:value-of select="fn:years-from-duration($Var_TM_PeriodDuration)"/>
		</years>										
		<months>
			<xsl:value-of select="fn:months-from-duration($Var_TM_PeriodDuration)"/>
		</months>
		<days>
			<xsl:value-of select="fn:days-from-duration($Var_TM_PeriodDuration)"/>
		</days>
		<hours>
			<xsl:value-of select="fn:hours-from-duration($Var_TM_PeriodDuration)"/>
		</hours>
		<minutes>
			<xsl:value-of select="fn:minutes-from-duration($Var_TM_PeriodDuration)"/>
		</minutes>
		<seconds>
			<xsl:value-of select="fn:seconds-from-duration($Var_TM_PeriodDuration)"/>
		</seconds>	
		-->

		<!-- Fonction XSLT -->
		<xsl:call-template name="parse-duration">
            <xsl:with-param name="paramDuration" select="xsi:duration( . )" />
        </xsl:call-template>	
		
	</xsl:template>


	<!-- ============================================================================= -->
	<!-- === BrowGraph === -->
	<!-- ============================================================================= -->

	<xsl:template match="*" mode="BrowGraph">

		<bgFileName><!--1..1-->
			<xsl:value-of select="gmd:fileName/gco:CharacterString"/>
		</bgFileName>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:fileDescription">
			<bgFileDesc><!--0..1-->
				<xsl:value-of select="gco:CharacterString"/>
			</bgFileDesc>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:fileType">
			<bgFileType><!--0..1-->
				<xsl:value-of select="gco:CharacterString"/>
			</bgFileType>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->
	<!-- === Format === -->
	<!-- ============================================================================= -->

	<xsl:template match="*" mode="Format">

		<formatName><!--1..1-->
			<xsl:value-of select="gmd:name/gco:CharacterString"/>
		</formatName>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<formatVer><!--1..1-->
			<xsl:value-of select="gmd:version/gco:CharacterString"/>
		</formatVer>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:amendmentNumber">
			<formatAmdNum><!--0..1-->
				<xsl:value-of select="gco:CharacterString"/>
			</formatAmdNum>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:specification">
			<formatSpec><!--0..1-->
				<xsl:value-of select="gco:CharacterString"/>
			</formatSpec>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:fileDecompressionTechnique">
			<fileDecmTech><!--0..1-->
				<xsl:value-of select="gco:CharacterString"/>
			</fileDecmTech>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->
	<!-- === Keywords === -->
	<!-- ============================================================================= -->

	<xsl:template match="*" mode="Keywords">

		<!-- SILOGIC ABSENCE gmd:keyword -->
		<xsl:if test="not(gmd:keyword)">
			<keyword/>
		</xsl:if>
		<xsl:for-each select="gmd:keyword">
			<keyword><!--1..n-->
				<xsl:value-of select="gco:CharacterString"/>
			</keyword>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:type">
			<keyTyp><!--0..1-->
				<KeyTypCd value="{gmd:MD_KeywordTypeCode/@codeListValue}" />
			</keyTyp>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:thesaurusName"> <!-- SILOGIC BUG GN : ATTENTION PAS DE idCitation -->
			<thesaName><!--0..1-->
				<!--idCitation-->
					<xsl:apply-templates select="gmd:CI_Citation" mode="Citation"/>
				<!--/idCitation-->
			</thesaName>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->
	<!-- === Usage === -->
	<!-- ============================================================================= -->

	<xsl:template match="*" mode="Usage"> 

		<specUsage><!--1..1-->
			<xsl:value-of select="gmd:specificUsage/gco:CharacterString"/>
		</specUsage>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:usageDateTime">
			<usageDate><!--0..1-->
				<xsl:value-of select="gco:DateTime"/>
			</usageDate>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:userDeterminedLimitations">
			<usrDetLim><!--0..1-->
				<xsl:value-of select="gco:CharacterString"/>
			</usrDetLim>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<!-- SILOGIC ABSENCE gmd:userContactInfo -->
		<xsl:if test="not(gmd:userContactInfo)">
			<usrCntInfo><!--1..n-->
				<role>
					<RoleCd value="unknown"/>
				</role>
			</usrCntInfo>
		</xsl:if>
		
		<xsl:for-each select="gmd:userContactInfo">
			<usrCntInfo><!--1..n-->
					<xsl:apply-templates select="gmd:CI_ResponsibleParty" mode="RespParty"/>
			</usrCntInfo>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->
	<!-- === ConstsTypes === -->
	<!-- ============================================================================= -->

	<xsl:template match="*" mode="ConstsTypes">

		<xsl:for-each select="gmd:MD_Constraints"><!-- ISO 19139  -->
			<Consts>
				<xsl:apply-templates select="." mode="Consts"/>
			</Consts>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:MD_LegalConstraints"><!--  ISO 19139 -->
			<LegConsts>
				<xsl:apply-templates select="." mode="LegConsts"/>
			</LegConsts>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:MD_SecurityConstraints"><!--  ISO 19139 -->
			<SecConsts>
				<xsl:apply-templates select="." mode="SecConsts"/>
			</SecConsts>
		</xsl:for-each>
		
		
		<xsl:for-each select="fra:FRA_Constraints"> <!-- SILOGIC PROFIL FRANCAIS  ISO 19139 FR -->
			<Consts>
				<xsl:apply-templates select="." mode="Consts"/>
				
				<xsl:for-each select="fra:Citation"> <!-- PROFIL FRANCAIS -->
					<frRefConstraints><!--0..n-->
						<xsl:apply-templates select="gmd:citation/gmd:CI_Citation" mode="Citation"/>
					</frRefConstraints>
				</xsl:for-each>
				
			</Consts>
			
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="fra:FRA_LegalConstraints"> <!-- SILOGIC PROFIL FRANCAIS  ISO 19139 FR-->
			<LegConsts>
				<xsl:apply-templates select="." mode="LegConsts"/>
				
				<xsl:for-each select="fra:Citation"> <!-- PROFIL FRANCAIS -->
					<frRefConstraints><!--0..n-->
						<xsl:apply-templates select="gmd:citation/gmd:CI_Citation" mode="Citation"/>
					</frRefConstraints>
				</xsl:for-each>

			</LegConsts>
			
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="fra:FRA_SecurityConstraints"> <!-- SILOGIC PROFIL FRANCAIS  ISO 19139 FR-->
			<SecConsts>
				<xsl:apply-templates select="." mode="SecConsts"/>
				
				<xsl:for-each select="fra:Citation"> <!-- PROFIL FRANCAIS -->
					<frRefConstraints><!--0..n-->
						<xsl:apply-templates select="gmd:citation/gmd:CI_Citation" mode="Citation"/>
					</frRefConstraints>
				</xsl:for-each>

			</SecConsts>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="Consts">

		<xsl:for-each select="gmd:useLimitation">
			<useLimit><!--0..n-->
				<xsl:value-of select="gco:CharacterString"/>
			</useLimit>
		</xsl:for-each>
		
	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="LegConsts">

		<xsl:apply-templates select="." mode="Consts"/>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:accessConstraints">
			<accessConsts><!--0..n--> 
				<RestrictCd value="{gmd:MD_RestrictionCode/@codeListValue}" />
			</accessConsts>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:useConstraints">
			<useConsts><!--0..n--> 
				<RestrictCd value="{gmd:MD_RestrictionCode/@codeListValue}" />
			</useConsts>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:otherConstraints">
			<othConsts><!--0..n--> 
				<xsl:value-of select="gco:CharacterString"/>
			</othConsts>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="SecConsts">

		<xsl:apply-templates select="." mode="Consts"/> 

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<class><!--1..1-->
			<ClasscationCd>
				<xsl:attribute name="value">
<!--				
					<xsl:choose>
						<xsl:when test="gmd:classification/gmd:MD_ClassificationCode/@codeListValue = 'topSecret'">topsecret</xsl:when>
						<xsl:otherwise>
-->
							<xsl:value-of select="gmd:classification/gmd:MD_ClassificationCode/@codeListValue"/>
<!--						</xsl:otherwise>
					</xsl:choose>
-->
				</xsl:attribute>
			</ClasscationCd>
		</class>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:userNote">
			<userNote><!--0..1--> 
				<xsl:value-of select="gco:CharacterString"/>
			</userNote>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:classificationSystem">
			<classSys><!--0..1--> 
				<xsl:value-of select="gco:CharacterString"/>
			</classSys>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:handlingDescription">
			<handDesc><!--0..1--> 
				<xsl:value-of select="gco:CharacterString"/>
			</handDesc>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->
	<!-- === Resol === -->
	<!-- ============================================================================= -->

	<xsl:template match="*" mode="Resol">
	
		<!-- séquence 0..n de Resol dont héritent les types ci-dessous -->
		
		<xsl:for-each select="gmd:equivalentScale">
			<equScale>
				<rfDenom>
					<xsl:value-of select="gmd:MD_RepresentativeFraction/gmd:denominator/gco:Integer"/>
				</rfDenom>
			</equScale>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:distance">
			<scaleDist>

				<!-- change PL -->
				<xsl:apply-templates select="." mode="Measure"/>
				
				<!-- <xsl:apply-templates select="gco:Distance" mode="Measure"/>-->

			</scaleDist>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->

</xsl:stylesheet>
