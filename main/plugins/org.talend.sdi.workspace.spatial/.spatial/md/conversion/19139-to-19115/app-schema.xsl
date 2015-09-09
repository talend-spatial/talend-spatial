<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:gmd="http://www.isotc211.org/2005/gmd"
										xmlns:gco="http://www.isotc211.org/2005/gco"
										xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
										xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
										exclude-result-prefixes="gmd gco xsi">

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="AppSchInfo">

		<asName><!--1..1-->
				<xsl:apply-templates select="gmd:name/gmd:CI_Citation" mode="Citation"/>
		</asName>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<asSchLang><!--1..1-->
			<xsl:value-of select="gmd:schemaLanguage/gco:CharacterString"/>
		</asSchLang>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<asCstLang><!--1..1-->
			<xsl:value-of select="gmd:constraintLanguage/gco:CharacterString"/>
		</asCstLang>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:schemaAscii">
			<asAscii><!--0..1-->
				<xsl:value-of select="gco:CharacterString"/>
			</asAscii>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:graphicsFile"> <!-- ATTENTION  src xs:anyURI au lieu de directement Binary ? -->
			<asGraFile><!--0..1-->
				<xsl:value-of select="gco:Binary/src"/>
			</asGraFile>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:softwareDevelopmentFile"> <!-- ATTENTION  src xs:anyURI au lieu de directement Binary -->
			<asSwDevFile><!--0..1-->
				<xsl:value-of select="gco:Binary/src"/> 
			</asSwDevFile>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:softwareDevelopmentFileFormat">
			<asSwDevFiFt><!--0..1-->
				<xsl:value-of select="gco:CharacterString"/>
			</asSwDevFiFt>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->

</xsl:stylesheet>
