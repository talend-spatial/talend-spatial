<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:fra="http://www.cnig.gouv.fr/2005/fra" xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gco="http://www.isotc211.org/2005/gco"  xmlns:gmi="http://www.isotc211.org/2005/gmi" xmlns:gts="http://www.isotc211.org/2005/gts" xmlns:gml="http://www.opengis.net/gml" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="fra gmi gco gml xsi gts gmd xlink">
<!-- xmlns:gts="http://www.isotc211.org/2005/gts" xmlns:gml="http://www.opengis.net/gml"  xmlns:gfc="http://www.isotc211.org/2005/gfc"  xmlns:gmi="http://www.isotc211.org/2005/gmi" xmlns:gmx="http://www.isotc211.org/2005/gmx" -->
	<!-- ============================================================================= -->
	<xsl:include href="resp-party.xsl"/>
	<xsl:include href="spat-rep-types.xsl"/>
	<xsl:include href="citation.xsl"/>
	<xsl:include href="extension.xsl"/>
	<xsl:include href="extent.xsl"/>
	<xsl:include href="ref-system.xsl"/>
	<xsl:include href="data-quality.xsl"/>
	<xsl:include href="identification.xsl"/>
	<xsl:include href="content.xsl"/>
	<xsl:include href="distribution.xsl"/>
	<xsl:include href="app-schema.xsl"/>
	<xsl:include href="parse-duration.xsl"/>
	
	<xsl:variable name="uppercase">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
	<xsl:variable name="lowercase">abcdefghijklmnopqrstuvwxyz</xsl:variable>	
	<xsl:variable name="iso19115schema">../schemas/iso19115fra/schema.xsd</xsl:variable>
	
	<!-- ============================================================================= -->
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<!-- ============================================================================= -->
	<xsl:template match="gmd:DS_DataSet/has">
				<xsl:apply-templates/>
	</xsl:template>
	<!-- ============================================================================= -->

	<xsl:template match="gmd:MD_Metadata">
		<Metadata><!-- xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"-->
		<!--xsl:attribute name="xsi:noNamespaceSchemaLocation">
			<xsl:value-of select="$iso19115schema"/>
		</xsl:attribute-->
   
			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
			<xsl:for-each select="gmd:fileIdentifier">
				<!-- TOTEST-->
				<mdFileID><!-- 0..1 -->
					<xsl:value-of select="gco:CharacterString"/>
				</mdFileID>
			</xsl:for-each>

			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

			<!-- ABSENCE gmd:language -->
			<xsl:if test="not(gmd:language)">
				<mdLang><!-- 1..1 -->
					<languageCode value="fra"/>
				</mdLang>
			</xsl:if>
			
			<xsl:for-each select="gmd:language">
				<!-- TOTEST-->
				<mdLang><!-- 1..1 -->
					<languageCode value="{translate(gco:CharacterString, $uppercase, $lowercase)}"/>
				</mdLang>
			</xsl:for-each>

			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

			<!-- ABSENCE gmd:characterSet -->
			<xsl:if test="not(gmd:characterSet)">
				<mdChar><!-- 1..1 -->
					<CharSetCd value="utf8"/>
				</mdChar>
			</xsl:if>

			<xsl:for-each select="gmd:characterSet">
				<mdChar><!-- 1..1 -->
					<CharSetCd value="{gmd:MD_CharacterSetCode/@codeListValue}"/>
				</mdChar>
			</xsl:for-each>

			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

			<xsl:for-each select="gmd:parentIdentifier">
				<mdParentID><!-- 0..1 -->
					<xsl:value-of select="gco:CharacterString"/>
				</mdParentID>
			</xsl:for-each>

			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

			<xsl:for-each select="gmd:hierarchyLevel">
				<mdHrLv><!-- 1..n -->
					<ScopeCd value="{gmd:MD_ScopeCode/@codeListValue}"/>
				</mdHrLv>
			</xsl:for-each>

			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

			<xsl:for-each select="gmd:hierarchyLevelName">
				<mdHrLvName><!-- 1..n -->
					<xsl:value-of select="gco:CharacterString"/>
				</mdHrLvName>
			</xsl:for-each>

			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

			<!-- ABSENCE gmd:contact -->
			<xsl:if test="not(gmd:contact)">
				<mdContact><!-- 1..1 -->		
					<role>
						<RoleCd value="unknown"/>
					</role>
				</mdContact>
			</xsl:if>

			<xsl:for-each select="gmd:contact">
				<mdContact><!-- 1..1 -->						
					<xsl:for-each select="gmd:CI_ResponsibleParty">
						<xsl:apply-templates select="." mode="RespParty"/>
					</xsl:for-each>
				</mdContact>									
			</xsl:for-each>
			
			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

			<mdDateSt><!-- 1..1 -->			
					<!--  Choice Date OU DateTime  -->
					<xsl:value-of select="gmd:dateStamp/gco:Date"/>
					<xsl:value-of select="gmd:dateStamp/gco:DateTime"/>
			</mdDateSt>
			
			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

			<xsl:for-each select="gmd:metadataStandardName">
				<mdStanName><!-- 0..1 -->
					<xsl:value-of select="gco:CharacterString"/>
				</mdStanName>
			</xsl:for-each>
			
			<xsl:for-each select="gmd:metadataStandardVersion">
				<mdStanVer><!-- 0..1 -->
					<xsl:value-of select="gco:CharacterString"/>
				</mdStanVer>
			</xsl:for-each>

			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

			<xsl:for-each select="gmd:distributionInfo">
				<distInfo><!-- 0..1 -->
					<xsl:for-each select="gmd:MD_Distribution">
						<xsl:apply-templates select="." mode="Distribution"/>
					</xsl:for-each>
				</distInfo>
			</xsl:for-each>

			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

			<!-- ABSENCE gmd:identificationInfo  -->
			<xsl:if test="not(gmd:identificationInfo)">
				<dataIdInfo><!-- 1..n -->
					<idCitation><!-- 1..1 -->
						<resTitle/>
						<resRefDate>
							<resDate/>
							<refDateType>
								<DateTypCd value="unknown"/>
							</refDateType> 
						</resRefDate>
					</idCitation>
					<idAbs/> <!-- 1..1 -->
					<dataLang><!-- 1..n -->
						<languageCode value="fra"/>
					</dataLang>
					<tpCat><!-- 1..n -->
						<TopicCatCd value="unknown"/>
					</tpCat>
				</dataIdInfo>
			</xsl:if>
			
			<xsl:for-each select="gmd:identificationInfo">
				<dataIdInfo><!-- 1..n -->			
					<xsl:for-each select="gmd:MD_DataIdentification">
						<xsl:apply-templates select="." mode="DataIdentification"/>
					</xsl:for-each>
					
					<xsl:for-each select="fra:FRA_DataIdentification"> <!-- PROFIL FRANCAIS -->
						<xsl:apply-templates select="." mode="DataIdentification"/>
					</xsl:for-each>
				</dataIdInfo>
			</xsl:for-each>

			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

			<xsl:for-each select="gmd:applicationSchemaInfo">
				<appSchInfo><!-- 0..n -->
					<xsl:for-each select="gmd:MD_ApplicationSchemaInformation">
						<xsl:apply-templates select="." mode="AppSchInfo"/>
					</xsl:for-each>
				</appSchInfo>
			</xsl:for-each>

			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

			<xsl:for-each select="gmd:portrayalCatalogueInfo">
				<porCatInfo><!-- 0..n -->
					<xsl:for-each select="gmd:MD_PortrayalCatalogueReference">
						<xsl:for-each select="gmd:portrayalCatalogueCitation">
							<portCatCit>
								<xsl:for-each select="CI_Citation">
									<xsl:apply-templates select="." mode="Citation"/>
								</xsl:for-each>
							</portCatCit>
						</xsl:for-each>
					</xsl:for-each>
					<xsl:if test="not(gmd:MD_PortrayalCatalogueReference/gmd:portrayalCatalogueCitation/CI_Citation)">
						<!-- Une citation obligatoire -->
						<resTitle/>
						<resRefDate>
							<refDate/>
							<refDateType>
								<DateTypCd value="unknown"/>
							</refDateType> 
						</resRefDate>
					</xsl:if>
				</porCatInfo>
			</xsl:for-each>

			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

			<xsl:for-each select="gmd:metadataMaintenance">
				<mdMaint><!-- 0..1 -->
					<xsl:apply-templates select="gmd:MD_MaintenanceInformation" mode="MaintInfo"/>
				</mdMaint>
			</xsl:for-each>

			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

			<xsl:for-each select="gmd:metadataConstraints">
				<mdConst><!-- 0..n -->
					<xsl:apply-templates select="." mode="ConstsTypes"/>
				</mdConst>
			</xsl:for-each>

			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

			<xsl:for-each select="gmd:dataQualityInfo">
				<dqInfo><!-- 0..n -->
					<xsl:for-each select="gmd:DQ_DataQuality">
						<xsl:apply-templates select="." mode="DataQuality"/>
					</xsl:for-each>
				</dqInfo>
			</xsl:for-each>

			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

			<xsl:for-each select="gmd:spatialRepresentationInfo">
				<spatRepInfo><!-- 0..n -->
					<xsl:apply-templates select="." mode="SpatRepTypes"/>
				</spatRepInfo>
			</xsl:for-each>											

			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

			<xsl:for-each select="gmd:referenceSystemInfo">
				<refSysInfo> <!-- 0..n -->
				
					<!-- PROFIL FRANCAIS -->
					<xsl:for-each select="fra:FRA_IndirectReferenceSystem">
						<xsl:apply-templates select="." mode="IndirectRefSystemTypes"/>
					</xsl:for-each>
					
					<!-- PROFIL FRANCAIS -->
					<xsl:for-each select="fra:FRA_DirectReferenceSystem">
						<xsl:apply-templates select="." mode="DirectRefSystemTypes"/>
					</xsl:for-each>
					
					<!-- ISO19139 -> impossible en profil français -->
					<xsl:for-each select="gmd:MD_ReferenceSystem">
						<xsl:apply-templates select="." mode="RefSystemTypes"/>
					</xsl:for-each>

				</refSysInfo>
			</xsl:for-each>			

			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

			<xsl:for-each select="gmd:contentInfo">
				<contInfo><!-- 0..n -->
					<xsl:apply-templates select="." mode="ContInfoTypes"/>
				</contInfo>
			</xsl:for-each>			

			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

			<xsl:for-each select="gmd:metadataExtensionInfo">
				<mdExtInfo><!-- 0..n -->
					<xsl:for-each select="gmd:MD_MetadataExtensionInformation">
						<xsl:apply-templates select="." mode="MdExInfo"/>
					</xsl:for-each>
				</mdExtInfo>
			</xsl:for-each>
			
			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

			<xsl:for-each select="gmd:dataSetURI">
				<dataSetURI><!-- 0..1 -->
					<xsl:value-of select="gco:CharacterString"/>
				</dataSetURI>
			</xsl:for-each>
			
			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
			<!-- FEATURE CATALOGUE -->
			<!-- Fichier 19110 - 0..n -->
			
		</Metadata>
	</xsl:template>
	<!-- ============================================================================= -->
</xsl:stylesheet>
