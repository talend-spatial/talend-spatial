<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:fra="http://www.cnig.gouv.fr/2005/fra" 
										xmlns:gmd="http://www.isotc211.org/2005/gmd"
										xmlns:gco="http://www.isotc211.org/2005/gco"
										xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
										xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
										
	<!-- ============================================================================= -->

	<xsl:template match="*" mode="Citation">

		<gmd:title>
			<gco:CharacterString><xsl:value-of select="resTitle"/></gco:CharacterString>
		</gmd:title>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="resAltTitle">
			<gmd:alternateTitle>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:alternateTitle>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="resRefDate">
			<xsl:choose>
				<xsl:when test="refDateType/DateTypCd/@value = 'unknown'">
					<gmd:date gco:nilReason="{refDate}"/>
				</xsl:when>
				<xsl:otherwise>
					<gmd:date>
						<gmd:CI_Date>
							<xsl:apply-templates select="." mode="RefDate"/>
						</gmd:CI_Date>
					</gmd:date>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="resEd">
			<gmd:edition>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:edition>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="resEdDate">
			<gmd:editionDate>
				<xsl:choose>
					<xsl:when test="contains(.,'T')">
						<gco:DateTime>
							 <xsl:value-of select="." />
						</gco:DateTime>
					</xsl:when>
					<xsl:when test="not(./text())">
						<gco:Date gco:nilReason="unknown"/>
					</xsl:when>
					<xsl:otherwise>
						<gco:Date>
							<xsl:value-of select="." />
						</gco:Date>
					</xsl:otherwise>
				</xsl:choose>			
			
				<!--gco:DateTime><xsl:value-of select="."/></gco:DateTime-->
			</gmd:editionDate>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="citId">
			<gmd:identifier>
				<gmd:MD_Identifier>
					<gmd:code>
						<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
					</gmd:code>
				</gmd:MD_Identifier>
			</gmd:identifier>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="citRespParty">
			<gmd:citedResponsibleParty>
				<gmd:CI_ResponsibleParty>
					<xsl:apply-templates select="." mode="RespParty"/>
				</gmd:CI_ResponsibleParty>
			</gmd:citedResponsibleParty>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="presForm">
			<gmd:presentationForm>
				<gmd:CI_PresentationFormCode codeList="{$resourceLocation}CI_PresentationFormCode" codeListValue="{PresFormCd/@value}" />
			</gmd:presentationForm>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="datasetSeries">
			<gmd:series>
				<gmd:CI_Series>
					<xsl:apply-templates select="." mode="DatasetSeries"/>
				</gmd:CI_Series>
			</gmd:series>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="otherCitDet">
			<gmd:otherCitationDetails>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:otherCitationDetails>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="collTitle">
			<gmd:collectiveTitle>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:collectiveTitle>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="isbn">
			<gmd:ISBN>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:ISBN>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="issn">
			<gmd:ISSN>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:ISSN>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="RefDate">
		<gmd:date>
			<xsl:choose>
				<xsl:when test="contains(refDate,'T')">
					<gco:DateTime>
						 <xsl:value-of select="refDate" />
					</gco:DateTime>
				</xsl:when>
				<xsl:when test="not(refDate/text())">
					<gco:Date gco:nilReason="unknown"/>
				</xsl:when>
				<xsl:otherwise>
					<gco:Date>
						<xsl:value-of select="refDate" />
					</gco:Date>
			   </xsl:otherwise>
			</xsl:choose>
		</gmd:date>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<gmd:dateType>
			<gmd:CI_DateTypeCode codeList="{$resourceLocation}CI_DateTypeCode" codeListValue="{refDateType/DateTypCd/@value}" />
		</gmd:dateType>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="DatasetSeries">

		<xsl:for-each select="seriesName">
			<gmd:name>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:name>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="issId">
			<gmd:issueIdentification>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:issueIdentification>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="artPage">
			<gmd:page>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:page>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->

</xsl:stylesheet>
