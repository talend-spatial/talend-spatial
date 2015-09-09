<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:fra="http://www.cnig.gouv.fr/2005/fra" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gfc="http://www.isotc211.org/2005/gfc" xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gml="http://www.opengis.net/gml" xmlns:gmi="http://www.isotc211.org/2005/gmi" xmlns:gmx="http://www.isotc211.org/2005/gmx" xmlns:xlink="http://www.w3.org/1999/xlink" exclude-result-prefixes="fra gmi">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	<!--xsl:namespace-alias stylesheet-prefix="#default" result-prefix="gmd"/-->
	
<xsl:variable name="schemaLocation">http://www.isotc211.org/2005/gmd ../schemas/iso19139fra/gmd/gmd.xsd</xsl:variable>	
	
	<!-- racine -->
	<xsl:template match="gmd:MD_Metadata">
		<gmd:MD_Metadata xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gfc="http://www.isotc211.org/2005/gfc" xmlns:gmi="http://www.isotc211.org/2005/gmi" xmlns:gmx="http://www.isotc211.org/2005/gmx" xmlns:gts="http://www.isotc211.org/2005/gts" xmlns:gml="http://www.opengis.net/gml" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	
	<xsl:attribute name="xsi:schemaLocation">
		<xsl:value-of select="$schemaLocation"/>
	</xsl:attribute>		
		
				<xsl:apply-templates select="*"/>
		</gmd:MD_Metadata>
	</xsl:template>

	<!--Copie à l'identique-->
	<xsl:template match="*" priority="-10">
		<xsl:element name="{name()}">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:element>
		<!--xsl:copy xmlns:gmd="http://www.isotc211.org/2005/gmd">
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy-->
	</xsl:template>
	
	<xsl:template match="@*">
		<xsl:if test="not (local-name() = 'type')">
			<xsl:attribute name="{name()}">
				<xsl:value-of select="."/>
			</xsl:attribute>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="gmd:metadataStandardName">	
		<gmd:metadataStandardName>
			<gco:CharacterString>ISO 19115</gco:CharacterString>
		</gmd:metadataStandardName>
	</xsl:template>
	
	<xsl:template match="gmd:metadataStandardVersion">
		<gmd:metadataStandardVersion>
			<gco:CharacterString></gco:CharacterString>
		</gmd:metadataStandardVersion>	
	</xsl:template>
	
	<!--gestion du FRA_DataIdentification-->
	<xsl:template match="fra:FRA_DataIdentification">
		<gmd:MD_DataIdentification>
			<xsl:apply-templates select="@*|node()"/>
		</gmd:MD_DataIdentification>
	</xsl:template>
	
	<!--gestion des FRA_Constraints-->
	<xsl:template match="fra:FRA_Constraints">
		<gmd:MD_Constraints>
			<xsl:apply-templates select="@*|node()"/>
		</gmd:MD_Constraints>
	</xsl:template>
	
	<xsl:template match="fra:FRA_LegalConstraints">
		<gmd:MD_LegalConstraints>
			<xsl:apply-templates select="@*|node()"/>
		</gmd:MD_LegalConstraints>
	</xsl:template>
	
	<xsl:template match="fra:FRA_SecurityConstraints">
		<gmd:MD_SecurityConstraints>
			<xsl:apply-templates select="@*|node()"/>
		</gmd:MD_SecurityConstraints>
	</xsl:template>
	<!--gestion des CRS-->
	<xsl:template match="fra:FRA_IndirectReferenceSystem">
		<gmd:MD_ReferenceSystem>
			<xsl:apply-templates select="@*|node()"/>
		</gmd:MD_ReferenceSystem>
	</xsl:template>
	<xsl:template match="fra:FRA_DirectReferenceSystem">
		<gmd:MD_ReferenceSystem>
			<xsl:apply-templates select="@*|node()"/>
		</gmd:MD_ReferenceSystem>
	</xsl:template>
	
	<!--Suppression des citations ajoutées dans DataIdentification, Constraints -->
	<xsl:template match="fra:FRA_DataIdentification/fra:relatedCitation">
	</xsl:template>
   
	<xsl:template match="fra:FRA_Constraints/fra:Citation">
	</xsl:template>
	
	<xsl:template match="fra:FRA_LegalConstraints/fra:Citation">
	</xsl:template>

	<xsl:template match="fra:FRA_SecurityConstraints/fra:Citation">
	</xsl:template>
	
	<!-- suppression des valeurs Valididy and UseBy’ pour les dates-->
	<xsl:template match="gmd:date[CI_Date/dateType/CI_DateTypeCode/@codeListValue='validity']">
	</xsl:template>
	
	<xsl:template match="gmd:date[CI_Date/dateType/CI_DateTypeCode/@codeListValue='useBy']">
	</xsl:template>
	
	<!-- Suppression de QEUsability -->
	<xsl:template match="gmi:QE_Usability">
	</xsl:template>
	
</xsl:stylesheet>
