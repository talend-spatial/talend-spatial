<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:fra="http://www.cnig.gouv.fr/2005/fra" 
										xmlns:gmd="http://www.isotc211.org/2005/gmd"
										xmlns:gco="http://www.isotc211.org/2005/gco"
										xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
										xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="Distribution">

		<xsl:for-each select="distributor">
			<gmd:distributor>
				<gmd:MD_Distributor>
					<xsl:apply-templates select="." mode="Distributor"/>
				</gmd:MD_Distributor>
			</gmd:distributor>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="distTranOps">
			<gmd:transferOptions>
				<gmd:MD_DigitalTransferOptions>
					<xsl:apply-templates select="." mode="DigTranOps"/>
				</gmd:MD_DigitalTransferOptions>
			</gmd:transferOptions>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->
	<!-- === Distributor === -->
	<!-- ============================================================================= -->

	<xsl:template match="*" mode="Distributor">

		<gmd:distributorContact>
			<gmd:CI_ResponsibleParty>
				<xsl:apply-templates select="distorCont" mode="RespParty"/>
			</gmd:CI_ResponsibleParty>
		</gmd:distributorContact>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="distorOrdPrc">
			<gmd:distributionOrderProcess>
				<gmd:MD_StandardOrderProcess>
					<xsl:apply-templates select="." mode="StanOrdProc"/>
				</gmd:MD_StandardOrderProcess>
			</gmd:distributionOrderProcess>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="distorFormat">
			<gmd:distributorFormat>  <!-- SILOGIC au lieu de distributionOrderProcess -->
				<gmd:MD_Format>
					<xsl:apply-templates select="." mode="Format"/>
				</gmd:MD_Format>
			</gmd:distributorFormat>  <!-- SILOGIC au lieu de distributionOrderProcess -->
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="distorTran">
			<gmd:distributorTransferOptions>
				<gmd:MD_DigitalTransferOptions>
					<xsl:apply-templates select="." mode="DigTranOps"/>
				</gmd:MD_DigitalTransferOptions>
			</gmd:distributorTransferOptions>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="StanOrdProc">

		<xsl:for-each select="resFees">
			<gmd:fees>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:fees>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="planAvDtTm">
			<gmd:plannedAvailableDateTime>
				<gco:DateTime><xsl:value-of select="."/></gco:DateTime>
			</gmd:plannedAvailableDateTime>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="ordInstr">
			<gmd:orderingInstructions>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:orderingInstructions>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="ordTurn">
			<gmd:turnaround>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:turnaround>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->
	<!-- === DigTranOps === -->
	<!-- ============================================================================= -->

	<xsl:template match="*" mode="DigTranOps">

		<xsl:for-each select="unitsODist">
			<gmd:unitsOfDistribution>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:unitsOfDistribution>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="transSize">
			<gmd:transferSize>
				<gco:Real><xsl:value-of select="."/></gco:Real>
			</gmd:transferSize>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="onLineSrc">
			<gmd:onLine>
				<gmd:CI_OnlineResource>
					<xsl:apply-templates select="." mode="OnLineRes"/>
				</gmd:CI_OnlineResource>
			</gmd:onLine>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="onLineMed">
			<gmd:offLine>
				<gmd:MD_Medium>
					<xsl:apply-templates select="." mode="Medium"/>
				</gmd:MD_Medium>
			</gmd:offLine>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="Medium">

		<xsl:for-each select="medName">
			<gmd:name>
				<gmd:MD_MediumNameCode codeList="{$resourceLocation}MD_MediumNameCode">
					<xsl:attribute name="codeListValue">
						<xsl:choose>
							<xsl:when test="MedNameCd/@value = 'online'">onLine</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="MedNameCd/@value"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:attribute>
				</gmd:MD_MediumNameCode>
			</gmd:name>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="medDensity">
			<gmd:density>
				<gco:Real><xsl:value-of select="."/></gco:Real>
			</gmd:density>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="medDenUnits"><!-- ATTENTION nécessairement gco:CharacterString -->
			<gmd:densityUnits>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:densityUnits>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="medVol">
			<gmd:volumes>
				<gco:Integer><xsl:value-of select="."/></gco:Integer>
			</gmd:volumes>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="medFormat">
			<gmd:mediumFormat>
				<gmd:MD_MediumFormatCode codeList="{$resourceLocation}MD_MediumFormatCode" codeListValue="{MedFormCd/@value}"/>
			</gmd:mediumFormat>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="medNote">
			<gmd:mediumNote>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:mediumNote>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->

</xsl:stylesheet>
