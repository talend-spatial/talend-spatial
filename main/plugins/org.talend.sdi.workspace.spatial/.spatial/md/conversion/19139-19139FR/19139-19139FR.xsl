<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:fra="http://www.cnig.gouv.fr/2005/fra"  xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gfc="http://www.isotc211.org/2005/gfc" xmlns:gmi="http://www.isotc211.org/2005/gmi" xmlns:gts="http://www.isotc211.org/2005/gts" xmlns:gml="http://www.opengis.net/gml" xmlns:gmx="http://www.isotc211.org/2005/gmx" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	
	<xsl:variable name="schemaLocation">http://www.cnig.gouv.fr/2005/fra ../schemas/iso19139Fra/fra/fra.xsd</xsl:variable>
	
	<!-- racine -->
	<xsl:template match="gmd:DS_DataSet">
		<gmd:DataSet xmlns="http://www.isotc211.org/2005/gmd" xmlns:fra="http://www.cnig.gouv.fr/2005/fra" xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gfc="http://www.isotc211.org/2005/gfc" xmlns:gmi="http://www.isotc211.org/2005/gmi" xmlns:gts="http://www.isotc211.org/2005/gts" xmlns:gmx="http://www.isotc211.org/2005/gmx" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
				<has>
					<xsl:apply-templates select="gmd:Metadata"/>
				</has>
		</gmd:DataSet>
	</xsl:template>
	
	
	<xsl:template match="gmd:MD_Metadata">
		<gmd:MD_Metadata xmlns="http://www.isotc211.org/2005/gmd" xmlns:fra="http://www.cnig.gouv.fr/2005/fra" xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gfc="http://www.isotc211.org/2005/gfc" xmlns:gmi="http://www.isotc211.org/2005/gmi" xmlns:gts="http://www.isotc211.org/2005/gts" xmlns:gmx="http://www.isotc211.org/2005/gmx" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
			<xsl:attribute name="xsi:schemaLocation">
				<xsl:value-of select="$schemaLocation"/>
			</xsl:attribute>	
			<!-- données obligatoires dans FRA -->
			<xsl:apply-templates select="gmd:fileIdentifier"/>	
				
			<xsl:if test ="not(gmd:language)">
				<gmd:language>
					<gco:CharacterString>fra</gco:CharacterString>
				</gmd:language>
			</xsl:if>
			<xsl:apply-templates select="gmd:language"/>
			
			<xsl:if test="not(gmd:characterSet)">
				<gmd:characterSet>
					<gmd:MD_CharacterSetCode codeList="MD_CharacterSetCode" codeListValue="utf8"/>
				</gmd:characterSet>	
			</xsl:if>
			<xsl:apply-templates select="gmd:characterSet"/>	
			
			<xsl:apply-templates select="gmd:parentIdentifier"/>	
			
			<xsl:if test="not(gmd:hierarchyLevel)">
				<gmd:hierarchyLevel>
					<gmd:MD_ScopeCode codeList="MD_ScopeCode" codeListValue="dataset"/>
				</gmd:hierarchyLevel>
			</xsl:if>
			<xsl:apply-templates select="gmd:hierarchyLevel"/>
			
			<xsl:if test="not(gmd:hierarchyLevelName)">
				<gmd:hierarchyLevelName>
					<gco:CharacterString>dataset</gco:CharacterString>
				</gmd:hierarchyLevelName>
			</xsl:if>
			<xsl:apply-templates select="gmd:hierarchyLevelName"/>	
			
			<xsl:apply-templates select="node()[local-name(.)!='fileIdentifier' and local-name(.)!='language' and local-name(.)!='characterSet'  and local-name(.)!='hierarchyLevel' and local-name(.)!='hierarchyLevelName' and local-name(.)!='parentIdentifier']"/>
		</gmd:MD_Metadata>
	</xsl:template>

	<!--gestion du DataIdentification-->
	<xsl:template match="gmd:MD_DataIdentification">
		<fra:FRA_DataIdentification>
			<xsl:apply-templates select="@*|node()"/>
		</fra:FRA_DataIdentification>
	</xsl:template>
	
	<!--gestion des Constraints-->
	<xsl:template match="gmd:MD_Constraints">
		<fra:FRA_Constraints>
			<xsl:apply-templates select="@*|node()"/>
		</fra:FRA_Constraints>
	</xsl:template>
	<xsl:template match="gmd:MD_LegalConstraints">
		<fra:FRA_LegalConstraints>
			<xsl:apply-templates select="@*|node()"/>
		</fra:FRA_LegalConstraints>
	</xsl:template>
	<xsl:template match="gmd:MD_SecurityConstraints">
		<fra:FRA_SecurityConstraints>
			<xsl:apply-templates select="@*|node()"/>
		</fra:FRA_SecurityConstraints>
	</xsl:template>
	
	<!--gestion des CRS
	Hypothèse : unqiuement des  systèmes directs-->
	<xsl:template match="gmd:MD_ReferenceSystem">
		<fra:FRA_DirectReferenceSystem>
			<xsl:apply-templates select="@*|node()"/>
		</fra:FRA_DirectReferenceSystem>
	</xsl:template>	
	
	<!--Copie à l'identique-->	
	
	<xsl:template match="node()|@*" priority="-10">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
	
</xsl:stylesheet>
