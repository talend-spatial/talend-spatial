<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:gmd="http://www.isotc211.org/2005/gmd"
										xmlns:gco="http://www.isotc211.org/2005/gco"
										xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
										xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
										exclude-result-prefixes="gmd gco xsi">

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="Citation">
   
		<resTitle> <!-- TOTEST -->
			<xsl:value-of select="gmd:title/gco:CharacterString"/>
		</resTitle>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:alternateTitle"> <!-- TOTEST -->
			<resAltTitle>
				<xsl:value-of select="gco:CharacterString"/>
			</resAltTitle>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:date"> <!-- TOTEST -->
			<resRefDate>
		
				<xsl:variable name="nil" select="./@gco:nilReason"/>
				<xsl:choose>
						<xsl:when test="$nil != ''">
							<refDate><xsl:value-of select="$nil"/></refDate>
							<refDateType>
								<DateTypCd value="unknown"/> <!-- RAJOUTE DANS LA LISTE DES VALEURS POSSIBLES -->
							</refDateType>
						</xsl:when>
						
						<xsl:otherwise>
							<xsl:for-each select="gmd:CI_Date">
								<xsl:apply-templates select="." mode="RefDate"/>
							</xsl:for-each>
						</xsl:otherwise>
					</xsl:choose>
				
			</resRefDate>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:edition"> <!-- TOTEST -->
			<resEd>
				<xsl:value-of select="gco:CharacterString"/>
			</resEd>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:editionDate"> <!-- TOTEST -->
			<resEdDate>
				<xsl:if test="gco:Date">
					<xsl:value-of select="gco:Date"/>
				</xsl:if>
				<xsl:if test="gco:DateTime">
					<xsl:value-of select="gco:DateTime"/>
				</xsl:if>
			</resEdDate>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:identifier"> <!-- TOTEST -->
			<citId>
				<xsl:for-each select="gmd:MD_Identifier">
					<xsl:for-each select="gmd:code">
						<xsl:value-of select="gco:CharacterString"/>
					</xsl:for-each>
				</xsl:for-each>
			</citId>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:citedResponsibleParty"> <!-- TOTEST -->
			<citRespParty>
				<xsl:for-each select="gmd:CI_ResponsibleParty">
					<xsl:apply-templates select="." mode="RespParty"/>
				</xsl:for-each>			
			</citRespParty>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:presentationForm"> <!-- TOTEST -->
			<presForm>
				<PresFormCd value="{gmd:CI_PresentationFormCode/@codeListValue}" />
			</presForm>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:series"> <!-- TOTEST -->
			<datasetSeries>
				<xsl:for-each select="gmd:CI_Series">
					<xsl:apply-templates select="." mode="DatasetSeries"/>
				</xsl:for-each>							
			</datasetSeries>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:otherCitationDetails"> <!-- TOTEST-->
			<otherCitDet>
				<xsl:value-of select="gco:CharacterString"/>
			</otherCitDet>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:collectiveTitle"> <!-- TOTEST -->
			<collTitle>
				<xsl:value-of select="gco:CharacterString"/>
			</collTitle>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:ISBN"> <!-- TOTEST -->
			<isbn>
				<xsl:value-of select="gco:CharacterString"/>
			</isbn>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:ISSN"> <!-- TOTEST -->
			<issn>
				<xsl:value-of select="gco:CharacterString"/>
			</issn>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*"  mode="RefDate">  <!-- TOTEST -->
	
		<refDate> 
			<xsl:if test="gmd:date/gco:Date">
				<xsl:value-of select="gmd:date/gco:Date"/> <!-- ATTENTION Date OU DateTime ? -->
			</xsl:if>
			<xsl:if test="gmd:date/gco:DateTime">
				<xsl:value-of select="gmd:date/gco:DateTime"/>
			</xsl:if>
		</refDate>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
		<refDateType>
			<DateTypCd value="{translate(gmd:dateType/gmd:CI_DateTypeCode/@codeListValue, $uppercase, $lowercase)}" />
		</refDateType>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="DatasetSeries">

		<xsl:for-each select="gmd:name"> <!-- TOTEST -->
			<seriesName>
				<xsl:value-of select="gco:CharacterString"/>
			</seriesName>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:issueIdentification"> <!-- TOTEST -->
			<issId>
				<xsl:value-of select="gco:CharacterString"/>
			</issId>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:page"> <!-- TOTEST -->
			<artPage>
				<xsl:value-of select="gco:CharacterString"/>
			</artPage>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->

</xsl:stylesheet>
