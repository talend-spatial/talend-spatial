<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:gmd="http://www.isotc211.org/2005/gmd"
										xmlns:gco="http://www.isotc211.org/2005/gco"
										xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
										xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
										exclude-result-prefixes="gmd gco xsi">

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="MdExInfo">

		<xsl:for-each select="gmd:extensionOnLineResource">
			<extOnRes><!--0..1-->
					<xsl:apply-templates select="gmd:CI_OnlineResource" mode="OnLineRes"/>
			</extOnRes>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:extendedElementInformation">
			<extEleInfo><!--0..n-->
					<xsl:apply-templates select="gmd:MD_ExtendedElementInformation" mode="ExtEleInfo"/>
			</extEleInfo>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="ExtEleInfo">

		<extEleName><!--1..1-->
			<xsl:value-of select="gmd:name/gco:CharacterString"/>
		</extEleName>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:shortName">
			<extShortName><!--0..1-->
				<xsl:value-of select="gco:CharacterString"/>
			</extShortName>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:domainCode">
			<extDomcode><!--0..1-->
				<xsl:value-of select="gco:Integer"/>
			</extDomcode>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<extEleDef><!--1..1-->
			<xsl:value-of select="gmd:definition/gco:CharacterString"/>
		</extEleDef>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:obligation">
			<extEleOb><!--0..1-->
				<ObCd value="{gmd:MD_ObligationCode/@codeListValue}"/>
			</extEleOb>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:condition">
			<extEleCond><!--0..1-->
				<xsl:value-of select="gco:CharacterString"/>
			</extEleCond>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<eleDatatype><!--1..1-->
			<DatatypeCd value="{gmd:dataType/gmd:MD_DatatypeCode/@codeListValue}" />
		</eleDatatype>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:maximumOccurrence">
			<extEleMxOc><!--0..1-->
				<xsl:value-of select="gco:CharacterString"/>
			</extEleMxOc>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:domainValue">
			<extEleDomVal><!--0..1-->
				<xsl:value-of select="gco:CharacterString"/>
			</extEleDomVal>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:if test="not(gmd:parentEntity)">
			<extEleParEnt/><!--1..n-->
		</xsl:if>
		<xsl:for-each select="gmd:parentEntity">
			<extEleParEnt><!--1..n-->
				<xsl:value-of select="gco:CharacterString"/>
			</extEleParEnt>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<extEleRule><!--1..1-->
			<xsl:value-of select="gmd:rule/gco:CharacterString"/>
		</extEleRule>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:rationale">
			<extEleRat><!--0..n-->
				<xsl:value-of select="gco:CharacterString"/>
			</extEleRat>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:if test="not(gmd:source)">
			<extEleSrc>
				<role>
					<RoleCd value="unknown"/>
				</role>
			</extEleSrc>
		</xsl:if>
		<xsl:for-each select="gmd:source">
			<extEleSrc><!--1..n-->
					<xsl:apply-templates select="gmd:CI_ResponsibleParty" mode="RespParty"/>
			</extEleSrc>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->

</xsl:stylesheet>
