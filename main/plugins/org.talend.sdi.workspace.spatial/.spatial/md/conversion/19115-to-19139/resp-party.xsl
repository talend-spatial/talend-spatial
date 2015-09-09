<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:gmd="http://www.isotc211.org/2005/gmd"
										xmlns:gco="http://www.isotc211.org/2005/gco"
										xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
										xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="RespParty">

		<xsl:for-each select="rpIndName">
			<gmd:individualName>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:individualName>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="rpOrgName">
			<gmd:organisationName>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:organisationName>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="rpPosName">
			<gmd:positionName>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:positionName>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="rpCntInfo">
			<gmd:contactInfo>
				<gmd:CI_Contact>
					<xsl:apply-templates select="." mode="Contact"/>
				</gmd:CI_Contact>
			</gmd:contactInfo>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<gmd:role>
			<gmd:CI_RoleCode codeList="{$resourceLocation}CI_RoleCode" codeListValue="{role/RoleCd/@value}" />
		</gmd:role>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="Contact">

		<xsl:for-each select="cntPhone">
			<gmd:phone>
				<gmd:CI_Telephone>
					<xsl:apply-templates select="." mode="Telephone"/>
				</gmd:CI_Telephone>
			</gmd:phone>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="cntAddress">
			<gmd:address>
				<gmd:CI_Address>
					<xsl:apply-templates select="." mode="Address"/>
				</gmd:CI_Address>
			</gmd:address>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="cntOnLineRes">
			<gmd:onlineResource>
				<gmd:CI_OnlineResource>
					<xsl:apply-templates select="." mode="OnLineRes"/>
				</gmd:CI_OnlineResource>
			</gmd:onlineResource>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="cntHours">
			<gmd:hoursOfService>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:hoursOfService>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="cntInstr">
			<gmd:contactInstructions>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:contactInstructions>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="Telephone">

		<xsl:for-each select="voiceNum">
			<gmd:voice>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:voice>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="faxNum">
			<gmd:facsimile>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:facsimile>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="Address">

		<xsl:for-each select="delPoint">
			<gmd:deliveryPoint>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:deliveryPoint>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="city">
			<gmd:city>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:city>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="adminArea">
			<gmd:administrativeArea>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:administrativeArea>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="postCode">
			<gmd:postalCode>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:postalCode>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="country">
			<gmd:country>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:country>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="eMailAdd">
			<gmd:electronicMailAddress>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:electronicMailAddress>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="OnLineRes">

		<gmd:linkage>
			<gmd:URL><xsl:value-of select="linkage"/></gmd:URL>
		</gmd:linkage>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="protocol">
			<gmd:protocol>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:protocol>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="appProfile">
			<gmd:applicationProfile>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:applicationProfile>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="orName">
			<gmd:name>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:name>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="orDesc">
			<gmd:description>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:description>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="orFunct">
			<gmd:function>
				<gmd:CI_OnLineFunctionCode codeList="{$resourceLocation}CI_OnLineFunctionCode" codeListValue="{OnFunctCd/@value}" />
			</gmd:function>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->

</xsl:stylesheet>
