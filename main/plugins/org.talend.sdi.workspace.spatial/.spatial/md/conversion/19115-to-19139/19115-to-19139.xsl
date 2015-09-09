<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:fra="http://www.cnig.gouv.fr/2005/fra" xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gfc="http://www.isotc211.org/2005/gfc" xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gmi="http://www.isotc211.org/2005/gmi" xmlns:gmx="http://www.isotc211.org/2005/gmx" xmlns:gts="http://www.isotc211.org/2005/gts" xmlns:gml="http://www.opengis.net/gml" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

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

	<!-- ============================================================================= -->

	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />
	<!--xsl:namespace-alias stylesheet-prefix="#default" result-prefix="gmd"/-->

	<!-- ============================================================================= -->
	
	<!-- ne pas utiliser sinon tout est en gmd, pas la possibilité de surcharger -->
	<!--xsl:namespace-alias stylesheet-prefix="#default" result-prefix="gmd"/-->
	
	<!--xsl:variable name="resourceLocation">./resources/codeList.xml#</xsl:variable-->
	<xsl:variable name="resourceLocation"></xsl:variable>
	
	<xsl:variable name="schemaLocation">http://www.cnig.gouv.fr/2005/fra ../schemas/iso19139Fra/fra/fra.xsd</xsl:variable>
	<!-- ============================================================================= -->

	<xsl:template match="/">
		<!--DS_DataSet>
			<has-->
				<xsl:apply-templates/>
			<!--/has>
		</DS_DataSet-->
	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="Metadata">
		<gmd:MD_Metadata xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:fra="http://www.cnig.gouv.fr/2005/fra" xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gfc="http://www.isotc211.org/2005/gfc"  xmlns:gmi="http://www.isotc211.org/2005/gmi" xmlns:gmx="http://www.isotc211.org/2005/gmx" xmlns:gts="http://www.isotc211.org/2005/gts" xmlns:gml="http://www.opengis.net/gml" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
		
	<xsl:attribute name="xsi:schemaLocation">
		<xsl:value-of select="$schemaLocation"/>
	</xsl:attribute>

			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

			<xsl:for-each select="mdFileID">
				<gmd:fileIdentifier>
					<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
				</gmd:fileIdentifier>
			</xsl:for-each>

			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

			<xsl:for-each select="mdLang">
				<gmd:language>
					<gco:CharacterString><xsl:value-of select="languageCode/@value"/></gco:CharacterString>
				</gmd:language>
			</xsl:for-each>

			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

			<xsl:for-each select="mdChar">
				<gmd:characterSet>
					<gmd:MD_CharacterSetCode codeList="{$resourceLocation}MD_CharacterSetCode" codeListValue="{CharSetCd/@value}" />
				</gmd:characterSet>
			</xsl:for-each>

			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

			<xsl:for-each select="mdParentID">
				<gmd:parentIdentifier>
					<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
				</gmd:parentIdentifier>
			</xsl:for-each>

			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

			<xsl:for-each select="mdHrLv">
				<gmd:hierarchyLevel>
					<gmd:MD_ScopeCode codeList="{$resourceLocation}MD_ScopeCode" codeListValue="{ScopeCd/@value}" />
				</gmd:hierarchyLevel>
			</xsl:for-each>

			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

			<xsl:for-each select="mdHrLvName">
				<gmd:hierarchyLevelName>
					<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
				</gmd:hierarchyLevelName>
			</xsl:for-each>

			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

			<xsl:for-each select="mdContact">
				<gmd:contact>
					<gmd:CI_ResponsibleParty>
						<xsl:apply-templates select="." mode="RespParty"/>
					</gmd:CI_ResponsibleParty>
				</gmd:contact>
			</xsl:for-each>

			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

			<gmd:dateStamp>
				<xsl:choose>
				<xsl:when test="contains(mdDateSt,'T')">
					<gco:DateTime>
						 <xsl:value-of select="mdDateSt" />
					</gco:DateTime>
				</xsl:when>
				<xsl:otherwise>
					<gco:Date>
						<xsl:value-of select="mdDateSt" />
					</gco:Date>
			   </xsl:otherwise>
			</xsl:choose>
			
				<!--gco:DateTime><xsl:value-of select="mdDateSt"/></gco:DateTime-->
			</gmd:dateStamp>

			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

			<gmd:metadataStandardName>
				<gco:CharacterString><xsl:value-of select="mdStanName"/></gco:CharacterString><!-- au lieu de ISO 19115:2003/19139 -->
			</gmd:metadataStandardName>

			<gmd:metadataStandardVersion>
				<gco:CharacterString><xsl:value-of select="mdStanVer"/></gco:CharacterString> <!-- au lieu de 1.0 -->
			</gmd:metadataStandardVersion>
			
			<xsl:for-each select="dataSetURI">
				<gmd:dataSetURI>
					<xsl:value-of select="."/>
				</gmd:dataSetURI>
			</xsl:for-each>

			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

			<xsl:for-each select="spatRepInfo">
				<gmd:spatialRepresentationInfo>
					<xsl:apply-templates select="." mode="SpatRepTypes"/>
				</gmd:spatialRepresentationInfo>
			</xsl:for-each>

			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

			<xsl:for-each select="refSysInfo">
				<gmd:referenceSystemInfo>

					<xsl:for-each select="DirectReferenceSystem"> <!-- PROFIL FRANCAIS -->
						<fra:FRA_DirectReferenceSystem gco:isoType="MD_ReferenceSystem">
							<xsl:apply-templates select="." mode="RefSystemTypes"/>
						</fra:FRA_DirectReferenceSystem>
					</xsl:for-each>
					
					<xsl:for-each select="InDirectReferenceSystem"> <!-- PROFIL FRANCAIS -->
						<fra:FRA_IndirectReferenceSystem gco:isoType="MD_ReferenceSystem">
							<xsl:apply-templates select="." mode="RefSystemTypes"/>
						</fra:FRA_IndirectReferenceSystem>
					</xsl:for-each>

					<xsl:for-each select="RefSystem"> <!-- Au lieu de "." - Cardinalité 1 - PROFIL FRANCAIS -->
						<gmd:MD_ReferenceSystem>
							<xsl:apply-templates select="." mode="RefSystemTypes"/>
						</gmd:MD_ReferenceSystem>
					</xsl:for-each>
										
				</gmd:referenceSystemInfo>
				
			</xsl:for-each>

			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

			<xsl:for-each select="mdExtInfo">
				<gmd:metadataExtensionInfo>
					<gmd:MD_MetadataExtensionInformation>
						<xsl:apply-templates select="." mode="MdExInfo"/>
					</gmd:MD_MetadataExtensionInformation>
				</gmd:metadataExtensionInfo>
			</xsl:for-each>

			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

			<xsl:for-each select="dataIdInfo">
				<gmd:identificationInfo>
					<fra:FRA_DataIdentification gco:isoType="MD_DataIdentification">  <!-- PROFIL FRANCAIS au lieu de MD_DataIdentification-->
						<xsl:apply-templates select="." mode="DataIdentification"/>
					</fra:FRA_DataIdentification>
				</gmd:identificationInfo>
			</xsl:for-each>

			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

			<xsl:for-each select="contInfo">
				<gmd:contentInfo>
					<xsl:apply-templates select="." mode="ContInfoTypes"/>
				</gmd:contentInfo>
			</xsl:for-each>

			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

			<xsl:for-each select="distInfo">
				<gmd:distributionInfo>
					<gmd:MD_Distribution>
						<xsl:apply-templates select="." mode="Distribution"/>
					</gmd:MD_Distribution>
				</gmd:distributionInfo>
			</xsl:for-each>

			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

			<xsl:for-each select="dqInfo">
				<gmd:dataQualityInfo>
					<gmd:DQ_DataQuality>
						<xsl:apply-templates select="." mode="DataQuality"/>
					</gmd:DQ_DataQuality>
				</gmd:dataQualityInfo>
			</xsl:for-each>

			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

			<xsl:for-each select="porCatInfo">
				<gmd:portrayalCatalogueInfo>
					<gmd:MD_PortrayalCatalogueReference>
						<xsl:for-each select="portCatCit">
							<gmd:portrayalCatalogueCitation>
								<gmd:CI_Citation>
									<xsl:apply-templates select="." mode="Citation"/>
								</gmd:CI_Citation>
							</gmd:portrayalCatalogueCitation>
						</xsl:for-each>
						<xsl:if test="not(portCatCit)">
							<gmd:portrayalCatalogueCitation gco:nilReason="unknown"/>
						</xsl:if>
					</gmd:MD_PortrayalCatalogueReference>
				</gmd:portrayalCatalogueInfo>
			</xsl:for-each>

			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

			<xsl:for-each select="mdConst">
				<gmd:metadataConstraints>
					<xsl:apply-templates select="." mode="ConstsTypes"/>
				</gmd:metadataConstraints>
			</xsl:for-each>

			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

			<xsl:for-each select="appSchInfo">
				<gmd:applicationSchemaInfo>
					<gmd:MD_ApplicationSchemaInformation>
						<xsl:apply-templates select="." mode="AppSchInfo"/>
					</gmd:MD_ApplicationSchemaInformation>
				</gmd:applicationSchemaInfo>
			</xsl:for-each>

			<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

			<xsl:for-each select="mdMaint">
				<gmd:metadataMaintenance>
					<gmd:MD_MaintenanceInformation>
						<xsl:apply-templates select="." mode="MaintInfo"/>
					</gmd:MD_MaintenanceInformation>
				</gmd:metadataMaintenance>
			</xsl:for-each>

		</gmd:MD_Metadata>
	</xsl:template>
	
	<!-- ============================================================================= -->

</xsl:stylesheet>
