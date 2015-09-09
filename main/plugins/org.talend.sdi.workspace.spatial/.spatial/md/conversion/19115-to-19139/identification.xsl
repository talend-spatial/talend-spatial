<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:fra="http://www.cnig.gouv.fr/2005/fra"
										xmlns:gmd="http://www.isotc211.org/2005/gmd"
										xmlns:gco="http://www.isotc211.org/2005/gco"
										xmlns:gts="http://www.isotc211.org/2005/gts"
										xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
										xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="DataIdentification">

		<gmd:citation>
			<gmd:CI_Citation>
				<xsl:apply-templates select="idCitation" mode="Citation"/>
			</gmd:CI_Citation>
		</gmd:citation>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<gmd:abstract>
			<gco:CharacterString><xsl:value-of select="idAbs"/></gco:CharacterString>
		</gmd:abstract>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="idPurp">
			<gmd:purpose>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:purpose>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="idCredit">
			<gmd:credit>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:credit>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="status">
			<gmd:status>
				<gmd:MD_ProgressCode codeList="{$resourceLocation}MD_ProgressCode" codeListValue="{ProgCd/@value}" />
			</gmd:status>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="idPoC">
			<gmd:pointOfContact>
				<gmd:CI_ResponsibleParty>
					<xsl:apply-templates select="." mode="RespParty"/>
				</gmd:CI_ResponsibleParty>
			</gmd:pointOfContact>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="resMaint">
			<gmd:resourceMaintenance>
				<gmd:MD_MaintenanceInformation>
					<xsl:apply-templates select="." mode="MaintInfo"/>
				</gmd:MD_MaintenanceInformation>
			</gmd:resourceMaintenance>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="graphOver">
			<gmd:graphicOverview>
				<gmd:MD_BrowseGraphic>
					<xsl:apply-templates select="." mode="BrowGraph"/>
				</gmd:MD_BrowseGraphic>
			</gmd:graphicOverview>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="dsFormat">
			<gmd:resourceFormat>
				<gmd:MD_Format>
					<xsl:apply-templates select="." mode="Format"/>
				</gmd:MD_Format>
			</gmd:resourceFormat>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="descKeys">
			<gmd:descriptiveKeywords>
				<gmd:MD_Keywords>
					<xsl:apply-templates select="." mode="Keywords"/>
				</gmd:MD_Keywords>
			</gmd:descriptiveKeywords>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="idSpecUse">
			<gmd:resourceSpecificUsage>
				<gmd:MD_Usage>
					<xsl:apply-templates select="." mode="Usage"/>
				</gmd:MD_Usage>
			</gmd:resourceSpecificUsage>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="resConst">
			<gmd:resourceConstraints>
				<xsl:apply-templates select="." mode="ConstsTypes"/>
			</gmd:resourceConstraints>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="spatRpType">
			<gmd:spatialRepresentationType>
				<gmd:MD_SpatialRepresentationTypeCode codeList="{$resourceLocation}MD_SpatialRepresentationTypeCode" codeListValue="{SpatRepTypCd/@value}" />
			</gmd:spatialRepresentationType>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="dataScale">
			<gmd:spatialResolution>
				<gmd:MD_Resolution>
					<xsl:apply-templates select="." mode="Resol"/>
				</gmd:MD_Resolution>
			</gmd:spatialResolution>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="dataLang">
			<gmd:language>
				<gco:CharacterString><xsl:value-of select="languageCode/@value"/></gco:CharacterString>
			</gmd:language>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="dataChar">
			<gmd:characterSet>
				<gmd:MD_CharacterSetCode codeList="{$resourceLocation}MD_CharacterSetCode" codeListValue="{CharSetCd/@value}" />
			</gmd:characterSet>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="tpCat"> <!-- SILOGIC BUG ATTENTION simpleType -->
			<gmd:topicCategory>
				<!--MD_TopicCategoryCode codeList="{$resourceLocation}MD_TopicCategoryCode" codeListValue="{TopicCatCd/@value}" /-->
				
				<gmd:MD_TopicCategoryCode>
					<xsl:value-of select="TopicCatCd/@value"/>
				</gmd:MD_TopicCategoryCode>
				
			</gmd:topicCategory>
			
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="envirDesc">
			<gmd:environmentDescription>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:environmentDescription>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="dataExt">
			<gmd:extent>
				<gmd:EX_Extent>
					<xsl:apply-templates select="." mode="Extent"/>
				</gmd:EX_Extent>
			</gmd:extent>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
<!-- DELETED SILOGIC
		<xsl:for-each select="geoBox">
			<gmd:extent>
				<gmd:EX_Extent>
					<gmd:geographicElement>
						<gmd:EX_GeographicBoundingBox>
						
							<xsl:apply-templates select="." mode="GeoBox" />			 <- SILOGIC Factorisation ->
							
						</gmd:EX_GeographicBoundingBox>
					</gmd:geographicElement>
				</gmd:EX_Extent>
			</gmd:extent>
		</xsl:for-each>
-->
		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
<!-- DELETED SILOGIC
		<xsl:for-each select="geoDesc">
			<gmd:extent>
				<gmd:EX_Extent>
					<gmd:geographicElement>
						<gmd:EX_GeographicDescription>
							<xsl:apply-templates select="." mode="GeoDesc"/>
						</gmd:EX_GeographicDescription>
					</gmd:geographicElement>
				</gmd:EX_Extent>
			</gmd:extent>
		</xsl:for-each>
-->
		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="suppInfo">
			<gmd:supplementalInformation>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:supplementalInformation>
		</xsl:for-each>
		
		
		<xsl:for-each select="frCitation"> <!-- PROFIL FRANCAIS -->
	    	<fra:relatedCitation>
    			<gmd:CI_Citation>
		    		<xsl:apply-templates select="." mode="Citation"/>
	    		</gmd:CI_Citation>
    		</fra:relatedCitation>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->
	<!-- === MaintInfo === -->
	<!-- ============================================================================= -->

	<xsl:template match="*" mode="MaintInfo">

		<gmd:maintenanceAndUpdateFrequency>
			<gmd:MD_MaintenanceFrequencyCode codeList="{$resourceLocation}MD_MaintenanceFrequencyCode" codeListValue="{maintFreq/MaintFreqCd/@value}" />
		</gmd:maintenanceAndUpdateFrequency>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="dateNext">
			<gmd:dateOfNextUpdate>
				<xsl:choose>
					<xsl:when test="contains(.,'T')">
						<gco:DateTime>
							 <xsl:value-of select="." />
						</gco:DateTime>
					</xsl:when>
					<xsl:otherwise>
						<gco:Date>
							<xsl:value-of select="." />
						</gco:Date>
				   </xsl:otherwise>
				</xsl:choose>
			
				<!--gco:Date><xsl:value-of select="."/></gco:Date-->
			</gmd:dateOfNextUpdate>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="usrDefFreq">
			<gmd:userDefinedMaintenanceFrequency>			
				<gts:TM_PeriodDuration>
					<xsl:apply-templates select="." mode="TM_PeriodDuration"/>
				</gts:TM_PeriodDuration>
			</gmd:userDefinedMaintenanceFrequency>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="maintScp">
			<gmd:updateScope>
				<gmd:MD_ScopeCode codeList="{$resourceLocation}MD_ScopeCode" codeListValue="{ScopeCd/@value}" />
			</gmd:updateScope>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="upScpDesc">
			<gmd:updateScopeDescription>
				<gmd:MD_ScopeDescription>
					<xsl:apply-templates select="." mode="ScpDesc"/>
				</gmd:MD_ScopeDescription>
			</gmd:updateScopeDescription>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="maintNote">
			<gmd:maintenanceNote>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:maintenanceNote>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="TM_PeriodDuration">
		<!-- BUG ATTENTION xs:duration et non datetime !
		<xsl:value-of select="years"/>-<xsl:value-of select="months"/>-<xsl:value-of select="days"/>T
		<xsl:value-of select="hours"/>:<xsl:value-of select="minutes"/>:<xsl:value-of select="seconds"/>
		-->
		P<xsl:value-of select="years"/>Y<xsl:value-of select="months"/>M<xsl:value-of select="days"/>DT
		<xsl:value-of select="hours"/>H<xsl:value-of select="minutes"/>M<xsl:value-of select="seconds"/>S
	</xsl:template>

	<!-- ============================================================================= -->
	<!-- === BrowGraph === -->
	<!-- ============================================================================= -->

	<xsl:template match="*" mode="BrowGraph">

		<gmd:fileName>
			<gco:CharacterString><xsl:value-of select="bgFileName"/></gco:CharacterString>
		</gmd:fileName>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="bgFileDesc">
			<gmd:fileDescription>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:fileDescription>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="bgFileType">
			<gmd:fileType>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:fileType>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->
	<!-- === Format === -->
	<!-- ============================================================================= -->

	<xsl:template match="*" mode="Format">

		<gmd:name>
			<gco:CharacterString><xsl:value-of select="formatName"/></gco:CharacterString>
		</gmd:name>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<gmd:version>
			<gco:CharacterString><xsl:value-of select="formatVer"/></gco:CharacterString>
		</gmd:version>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="formatAmdNum">
			<gmd:amendmentNumber>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:amendmentNumber>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="formatSpec">
			<gmd:specification>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:specification>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="fileDecmTech">
			<gmd:fileDecompressionTechnique>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:fileDecompressionTechnique>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->
	<!-- === Keywords === -->
	<!-- ============================================================================= -->

	<xsl:template match="*" mode="Keywords">

		<xsl:for-each select="keyword">
			<gmd:keyword>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:keyword>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="keyTyp">
			<gmd:type>
				<gmd:MD_KeywordTypeCode codeList="{$resourceLocation}MD_KeywordTypeCode" codeListValue="{KeyTypCd/@value}" />
			</gmd:type>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="thesaName"> <!-- ATTENTION Pas de idCitation --> 
			<gmd:thesaurusName>
				<gmd:CI_Citation>
					<xsl:apply-templates select="." mode="Citation"/>
				</gmd:CI_Citation>
			</gmd:thesaurusName>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->
	<!-- === Usage === -->
	<!-- ============================================================================= -->

	<xsl:template match="*" mode="Usage">

		<gmd:specificUsage>
			<gco:CharacterString><xsl:value-of select="specUsage"/></gco:CharacterString>
		</gmd:specificUsage>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="usageDate">
			<gmd:usageDateTime>
				<gco:DateTime><xsl:value-of select="."/></gco:DateTime>
			</gmd:usageDateTime>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="usrDetLim">
			<gmd:userDeterminedLimitations>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:userDeterminedLimitations>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="usrCntInfo">
			<gmd:userContactInfo>
				<gmd:CI_ResponsibleParty>
					<xsl:apply-templates select="." mode="RespParty"/>
				</gmd:CI_ResponsibleParty>
			</gmd:userContactInfo>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->
	<!-- === ConstsTypes === -->
	<!-- ============================================================================= -->

	<xsl:template match="*" mode="ConstsTypes">

		<xsl:for-each select="Consts">
			<fra:FRA_Constraints gco:isoType="MD_Constraints"> <!-- PROFIL FRANCAIS - au lieu de MD_Constraints -->
				<xsl:apply-templates select="." mode="Consts"/>
				
				<xsl:for-each select="frRefConstraints"> <!-- PROFIL FRANCAIS -->
					<fra:citation>
						<gmd:CI_Citation>
							<xsl:apply-templates select="." mode="Citation"/>
						</gmd:CI_Citation>
					</fra:citation>
				</xsl:for-each>				
				
			</fra:FRA_Constraints>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="LegConsts">
			<fra:FRA_LegalConstraints gco:isoType="MD_LegalConstraints">  <!-- PROFIL FRANCAIS - au lieu de MD_LegalConstraints -->
				<xsl:apply-templates select="." mode="LegConsts"/>
				
				<xsl:for-each select="frRefConstraints"> <!-- PROFIL FRANCAIS -->
					<fra:citation>
						<gmd:CI_Citation>
							<xsl:apply-templates select="." mode="Citation"/>
						</gmd:CI_Citation>
					</fra:citation>
				</xsl:for-each>
				
			</fra:FRA_LegalConstraints>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="SecConsts">
			<fra:FRA_SecurityConstraints gco:isoType="MD_SecurityConstraints"> <!-- PROFIL FRANCAIS - au lieu de  MD_SecurityConstraints -->
				<xsl:apply-templates select="." mode="SecConsts"/>
				
				<xsl:for-each select="frRefConstraints"> <!-- PROFIL FRANCAIS -->
					<fra:citation>
						<gmd:CI_Citation>
							<xsl:apply-templates select="." mode="Citation"/>
						</gmd:CI_Citation>
					</fra:citation>
				</xsl:for-each>
				
			</fra:FRA_SecurityConstraints>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="Consts">

		<xsl:for-each select="useLimit">
			<gmd:useLimitation>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:useLimitation>
		</xsl:for-each>
		
	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="LegConsts">

		<xsl:apply-templates select="." mode="Consts"/>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="accessConsts">
			<gmd:accessConstraints>
				<gmd:MD_RestrictionCode codeList="{$resourceLocation}MD_RestrictionCode" codeListValue="{RestrictCd/@value}" />
			</gmd:accessConstraints>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="useConsts">
			<gmd:useConstraints>
				<gmd:MD_RestrictionCode codeList="{$resourceLocation}MD_RestrictionCode" codeListValue="{RestrictCd/@value}" />
			</gmd:useConstraints>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="othConsts">
			<gmd:otherConstraints>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:otherConstraints>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="SecConsts">

		<xsl:apply-templates select="." mode="Consts"/>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<gmd:classification>
			<gmd:MD_ClassificationCode codeList="{$resourceLocation}MD_ClassificationCode">
				<xsl:attribute name="codeListValue">
					<xsl:choose>
						<xsl:when test="class/ClasscationCd/@value = 'topsecret'">topSecret</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="class/ClasscationCd/@value"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
			</gmd:MD_ClassificationCode>
		</gmd:classification>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="userNote">
			<gmd:userNote>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:userNote>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="classSys">
			<gmd:classificationSystem>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:classificationSystem>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="handDesc">
			<gmd:handlingDescription>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:handlingDescription>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->
	<!-- === Resol === -->
	<!-- ============================================================================= -->

	<xsl:template match="*" mode="Resol">

		<xsl:for-each select="equScale">
			<gmd:equivalentScale>
				<gmd:MD_RepresentativeFraction>
					<gmd:denominator>
						<xsl:if test="rfDenom">
							<gco:Integer><xsl:value-of select="rfDenom"/></gco:Integer>
						</xsl:if>
						<xsl:if test="not(rfDenom)">
							<xsl:attribute name="gco:nilReason">unknown</xsl:attribute>
						</xsl:if>
					</gmd:denominator>
				</gmd:MD_RepresentativeFraction>
			</gmd:equivalentScale>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="scaleDist">
			<gmd:distance>
				<xsl:if test="boolean(child::*)">
					<gco:Distance>
						<!-- change PL -->
						
						<xsl:attribute name="uom"><xsl:value-of select=".//uomName"/></xsl:attribute>
						
						<xsl:value-of select="./value/Decimal|./value/Real|./value/Integer"/>
						
						<!--<xsl:apply-templates select="." mode="Measure"/>-->
					</gco:Distance>
				</xsl:if>
				<xsl:if test="not(boolean(child::*))">
					<xsl:attribute name="gco:nilReason">unknown</xsl:attribute>
				</xsl:if>
			</gmd:distance>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->

</xsl:stylesheet>
