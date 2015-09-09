<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:gmd="http://www.isotc211.org/2005/gmd"
										xmlns:gco="http://www.isotc211.org/2005/gco"
										xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
										xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
										exclude-result-prefixes="gmd gco xsi">

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="RespParty">
	
		<xsl:for-each select="gmd:individualName">
			<rpIndName><!-- 0..1 -->
				<xsl:value-of select="gco:CharacterString"/>
			</rpIndName>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:organisationName">
			<rpOrgName><!-- 0..1 -->
				<xsl:value-of select="gco:CharacterString"/>
			</rpOrgName>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:positionName">
			<rpPosName><!-- 0..1 -->
				<xsl:value-of select="gco:CharacterString"/>
			</rpPosName>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:contactInfo">
			<rpCntInfo><!-- 0..1 -->
				<xsl:for-each select="gmd:CI_Contact">
					<xsl:apply-templates select="." mode="Contact"/>
				</xsl:for-each>			
			</rpCntInfo>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<role><!-- 1..1 -->
			<xsl:choose>
				<xsl:when test="gmd:role/gmd:CI_RoleCode/@codeListValue !=''">
					<RoleCd value="{gmd:role/gmd:CI_RoleCode/@codeListValue}" />
				</xsl:when>
				<xsl:otherwise>
					<RoleCd value="unknown"/>
				</xsl:otherwise>
			</xsl:choose>
<!--	Traitement fonction du nilReason ?
			<xsl:variable name="nil" select="./@gco:nilReason"/>
			<xsl:if test="$nil != ''">
				<RoleCd value="unknown"/>
			</xsl:if>
-->
		</role>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template name="Contact" match="*" mode="Contact">

		<xsl:for-each select="gmd:phone">
			<cntPhone><!-- 0..1 -->
				<xsl:for-each select="gmd:CI_Telephone">
					<xsl:apply-templates select="." mode="Telephone"/>
				</xsl:for-each>			
			</cntPhone>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:address">
			<cntAddress><!-- 0..1 -->
				<xsl:for-each select="gmd:CI_Address">
					<xsl:apply-templates select="." mode="Address"/>
				</xsl:for-each>
			</cntAddress>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:onlineResource">
			<cntOnLineRes><!-- 0..1 -->
				<xsl:for-each select="gmd:CI_OnlineResource">
					<xsl:apply-templates select="." mode="OnLineRes"/>
				</xsl:for-each>	
			</cntOnLineRes>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:hoursOfService">
			<cntHours><!-- 0..1 -->
				<xsl:value-of select="gco:CharacterString"/>
			</cntHours>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:contactInstructions">
			<cntInstr><!-- 0..1 -->
				<xsl:value-of select="gco:CharacterString"/>
			</cntInstr>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template name="Telephone" match="*" mode="Telephone">

		<xsl:for-each select="gmd:voice">
			<voiceNum><!-- 0..n -->
				<xsl:value-of select="gco:CharacterString"/>
			</voiceNum>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:facsimile">
			<faxNum><!-- 0..n -->
				<xsl:value-of select="gco:CharacterString"/>
			</faxNum>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template name="Address" match="*" mode="Address">

		<xsl:for-each select="gmd:deliveryPoint">
			<delPoint><!-- 0..n -->
				<xsl:value-of select="gco:CharacterString"/>
			</delPoint>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:city">
			<city><!-- 0..1 -->
				<xsl:value-of select="gco:CharacterString"/>
			</city>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:administrativeArea">
			<adminArea><!-- 0..1 -->
				<xsl:value-of select="gco:CharacterString"/>
			</adminArea>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:postalCode">
			<postCode><!-- 0..1 -->
				<xsl:value-of select="gco:CharacterString"/>
			</postCode>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:country">
			<country><!-- 0..1 -->
				<xsl:value-of select="gco:CharacterString"/>
			</country>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:electronicMailAddress">
			<eMailAdd><!-- 0..n -->
				<xsl:value-of select="gco:CharacterString"/>
			</eMailAdd>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template name="OnLineRes" match="*" mode="OnLineRes">

		<linkage><!-- 1..1 -->
			<xsl:value-of select="gmd:linkage/gmd:URL"/>
		</linkage>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:protocol">
			<protocol><!-- 0..1 -->
				<xsl:value-of select="gco:CharacterString"/>
			</protocol>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:applicationProfile">
			<appProfile><!-- 0..1 -->
				<xsl:value-of select="gco:CharacterString"/>
			</appProfile>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:name">
			<orName><!-- 0..1 -->
				<xsl:value-of select="gco:CharacterString"/>
			</orName>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:description">
			<orDesc><!-- 0..1 -->
				<xsl:value-of select="gco:CharacterString"/>
			</orDesc>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:function">
			<orFunct><!-- 0..1 -->
				<xsl:for-each select="gmd:CI_OnLineFunctionCode">
					<OnFunctCd value="{@codeListValue}"/>
				</xsl:for-each>				
			</orFunct>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->

</xsl:stylesheet>
