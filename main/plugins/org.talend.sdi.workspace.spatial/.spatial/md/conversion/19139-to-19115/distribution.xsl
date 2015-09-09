<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"	xmlns:gmd="http://www.isotc211.org/2005/gmd"
										xmlns:gco="http://www.isotc211.org/2005/gco"
										xmlns:gml="http://www.opengis.net/gml"
										xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
										xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
										exclude-result-prefixes="gmd gco gml xsi">

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="Distribution">

		<xsl:for-each select="gmd:distributor">
			<distributor><!-- 0..n -->
					<xsl:apply-templates select="gmd:MD_Distributor" mode="Distributor"/>
			</distributor>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:transferOptions">
			<distTranOps><!-- 0..n -->
					<xsl:apply-templates select="gmd:MD_DigitalTransferOptions" mode="DigTranOps"/>
			</distTranOps>
		</xsl:for-each>
		
		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->		
		
		<xsl:for-each select="gmd:distributionFormat">		
			<distFormat><!-- 0..n -->
					<xsl:apply-templates select="gmd:MD_Format" mode="Format"/>
			</distFormat>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->
	<!-- === Distributor === -->
	<!-- ============================================================================= -->

	<xsl:template match="*" mode="Distributor">

		<distorCont><!--1..1-->
			<xsl:variable name="nil" select="gmd:distributorContact/@gco:nilReason"/>
			<xsl:if test="$nil != ''" >
				<role>
					<RoleCd value="unknown"/>
				</role>
			</xsl:if>
			
			<xsl:apply-templates select="gmd:distributorContact/gmd:CI_ResponsibleParty" mode="RespParty"/>
		</distorCont>
		
		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:if test="not(gmd:distributorFormat)" >
			<distorFormat><!--1..n-->
				<formatName/>
				<formatVer/>
			</distorFormat>
		</xsl:if>
			
		<xsl:for-each select="gmd:distributorFormat">
			<distorFormat><!--1..n-->
					<xsl:apply-templates select="gmd:MD_Format" mode="Format"/>
			</distorFormat>
		</xsl:for-each>		

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:distributionOrderProcess">
			<distorOrdPrc><!--0..n-->
					<xsl:apply-templates select="gmd:MD_StandardOrderProcess" mode="StanOrdProc"/>
			</distorOrdPrc>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:distributorTransferOptions">
			<distorTran><!--0..n-->
					<xsl:apply-templates select="gmd:MD_DigitalTransferOptions" mode="DigTranOps"/>
			</distorTran>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="StanOrdProc">

		<xsl:for-each select="gmd:fees">
			<resFees><!-- 0..1-->
				<xsl:value-of select="gco:CharacterString"/>
			</resFees>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:plannedAvailableDateTime">
			<planAvDtTm><!-- 0..1-->
				<xsl:value-of select="gmd:DateTime"/>
			</planAvDtTm>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:orderingInstructions">
			<ordInstr><!-- 0..1-->
				<xsl:value-of select="gco:CharacterString"/>
			</ordInstr>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:turnaround">
			<ordTurn><!-- 0..1-->
				<xsl:value-of select="gco:CharacterString"/>
			</ordTurn>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->
	<!-- === DigTranOps === -->
	<!-- ============================================================================= -->

	<xsl:template match="*" mode="DigTranOps">

		<xsl:for-each select="gmd:unitsOfDistribution">
			<unitsODist><!-- 0..1-->
				<xsl:value-of select="gco:CharacterString"/>
			</unitsODist>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:transferSize">
			<transSize><!-- 0..1-->
				<xsl:value-of select="gco:Real"/>
			</transSize>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:onLine">
			<onLineSrc><!-- 0..n-->
				<xsl:apply-templates select="gmd:CI_OnlineResource" mode="OnLineRes"/>
			</onLineSrc>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:offLine">
			<onLineMed><!-- 0..1-->
				<xsl:apply-templates select="gmd:MD_Medium" mode="Medium"/>
			</onLineMed>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="Medium">

		<xsl:for-each select="gmd:name">
			<medName><!-- 0..1-->
				<MedNameCd>
					<xsl:attribute name="value">
<!--						<xsl:choose>
							<xsl:when test="gmd:MD_MediumNameCode/@codeListValue ='onLine'">online</xsl:when>
							<xsl:otherwise>
-->
								<xsl:value-of select="gmd:MD_MediumNameCode/@codeListValue"/>
<!--							</xsl:otherwise>
						</xsl:choose> 
-->
					</xsl:attribute>
				</MedNameCd>
			</medName>
		</xsl:for-each>		
		
		
		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:density">
			<medDensity><!--0..n-->
				<xsl:value-of select="gco:Real"/>
			</medDensity>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:densityUnits">
			<medDenUnits><!--0..1 plusieurs sous-classes de gco:CharacterString -->
				<xsl:apply-templates select="." mode="UnitDefinition"/>
			</medDenUnits>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:volumes">
			<medVol><!--0..1-->
				<xsl:value-of select="gco:Integer"/>
			</medVol>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:mediumFormat">
			<medFormat><!--0..n-->
				<MedFormCd value="{gmd:MD_MediumFormatCode/@codeListValue}"/>
			</medFormat>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:mediumNote">
			<medNote><!--0..1-->
				<xsl:value-of select="gco:CharacterString"/>
			</medNote>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->
	
		<xsl:template match="*" mode="UnitDefinition">
			<!-- pour tout type de définition on ne s'interesse qu'au nom -->
			<xsl:for-each select="*/gml:name">
				<xsl:value-of select="."/>
			</xsl:for-each>
		</xsl:template>	

</xsl:stylesheet>
