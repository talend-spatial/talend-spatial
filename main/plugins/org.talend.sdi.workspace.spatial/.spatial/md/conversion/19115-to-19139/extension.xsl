<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:fra="http://www.cnig.gouv.fr/2005/fra" 
										xmlns:gmd="http://www.isotc211.org/2005/gmd"
										xmlns:gco="http://www.isotc211.org/2005/gco"
										xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
										xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="MdExInfo">

		<xsl:for-each select="extOnRes">
			<gmd:extensionOnLineResource>
				<gmd:CI_OnlineResource>
					<xsl:apply-templates select="." mode="OnLineRes"/>
				</gmd:CI_OnlineResource>
			</gmd:extensionOnLineResource>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="extEleInfo">
			<gmd:extendedElementInformation>
				<gmd:MD_ExtendedElementInformation>
					<xsl:apply-templates select="." mode="ExtEleInfo"/>
				</gmd:MD_ExtendedElementInformation>
			</gmd:extendedElementInformation>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="ExtEleInfo">

		<gmd:name>
			<gco:CharacterString><xsl:value-of select="extEleName"/></gco:CharacterString>
		</gmd:name>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="extShortName">
			<gmd:shortName>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:shortName>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="extDomcode">
			<gmd:domainCode>
				<gco:Integer><xsl:value-of select="."/></gco:Integer>
			</gmd:domainCode>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<gmd:definition>
			<gco:CharacterString><xsl:value-of select="extEleDef"/></gco:CharacterString>
		</gmd:definition>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="extEleOb">
			<gmd:obligation>
				<gmd:MD_ObligationCode codeList="{$resourceLocation}MD_ObligationCode" codeListValue="{ObCd/@value}" />
			</gmd:obligation>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="extEleCond">
			<gmd:condition>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:condition>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<gmd:dataType>
			<gmd:MD_DatatypeCode codeList="{$resourceLocation}MD_DatatypeCode" codeListValue="{eleDatatype/DatatypeCd/@value}" />
		</gmd:dataType>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="extEleMxOc">
			<gmd:maximumOccurrence>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:maximumOccurrence>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="extEleDomVal">
			<gmd:domainValue>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:domainValue>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="extEleParEnt">
			<gmd:parentEntity>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:parentEntity>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<gmd:rule>
			<gco:CharacterString><xsl:value-of select="extEleRule"/></gco:CharacterString>
		</gmd:rule>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="extEleRat">
			<gmd:rationale>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:rationale>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="extEleSrc">
			<gmd:source>
				<gmd:CI_ResponsibleParty>
					<xsl:apply-templates select="." mode="RespParty"/>
				</gmd:CI_ResponsibleParty>
			</gmd:source>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->

</xsl:stylesheet>
