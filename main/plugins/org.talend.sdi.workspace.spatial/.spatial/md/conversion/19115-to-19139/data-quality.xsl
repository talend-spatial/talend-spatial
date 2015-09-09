<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:fra="http://www.cnig.gouv.fr/2005/fra" 
										xmlns:gmd="http://www.isotc211.org/2005/gmd"
										xmlns:gco="http://www.isotc211.org/2005/gco"
										xmlns:gmi="http://www.isotc211.org/2005/gmi"
										xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
										xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="DataQuality">

		<gmd:scope>
			<gmd:DQ_Scope>
				<xsl:apply-templates select="dqScope" mode="DQScope"/>
			</gmd:DQ_Scope>
		</gmd:scope>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="dqReport">
			<gmd:report>
				<xsl:apply-templates select="." mode="DQElementTypes"/>
			</gmd:report>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="dataLineage">
			<gmd:lineage>
				<gmd:LI_Lineage>
					<xsl:apply-templates select="." mode="Lineage"/>
				</gmd:LI_Lineage>
			</gmd:lineage>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->
	<!-- === Data quality scope === -->
	<!-- ============================================================================= -->

	<xsl:template match="*" mode="DQScope">

		<gmd:level>
			<gmd:MD_ScopeCode codeList="{$resourceLocation}MD_ScopeCode" codeListValue="{scpLvl/ScopeCd/@value}" />
		</gmd:level>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="scpExt">
			<gmd:extent>
				<gmd:EX_Extent>
					<xsl:apply-templates select="." mode="Extent"/>
				</gmd:EX_Extent>
			</gmd:extent>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="scpLvlDesc">
			<gmd:levelDescription>
				<gmd:MD_ScopeDescription>
					<xsl:apply-templates select="." mode="ScpDesc"/>
				</gmd:MD_ScopeDescription>
			</gmd:levelDescription>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="ScpDesc"> <!-- SILOGIC - ATTENTION @uuidref utilisé -->

		<xsl:for-each select="attribIntSet">
			<gmd:attributeInstances>
				<xsl:attribute name="uuidref">
					<xsl:value-of select="."/>
				</xsl:attribute>
			</gmd:attributeInstances>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="attribSet">
			<gmd:attributes>
				<xsl:attribute name="uuidref">
					<xsl:value-of select="."/>
				</xsl:attribute>
			</gmd:attributes>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="datasetSet">
			<gmd:dataset><xsl:value-of select="."/></gmd:dataset>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="featIntSet">
			<gmd:featureInstances>
				<xsl:attribute name="uuidref">
					<xsl:value-of select="."/>
				</xsl:attribute>
			</gmd:featureInstances>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="featSet">
			<gmd:features>
				<xsl:attribute name="uuidref">
					<xsl:value-of select="."/>
				</xsl:attribute>
			</gmd:features>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="other">
			<gmd:other><xsl:value-of select="."/></gmd:other>
		</xsl:for-each>
	</xsl:template>

	<!-- ============================================================================= -->
	<!-- === DQElementTypes === -->
	<!-- ============================================================================= -->

	<xsl:template match="*" mode="DQElementTypes">

		<xsl:for-each select="QEUsability"> <!-- PROFIL FRANCAIS -->
			<gmi:QE_Usability>
				<xsl:apply-templates select="." mode="DQElement"/>
			</gmi:QE_Usability>
		</xsl:for-each>


		<xsl:for-each select="DQAbsExtPosAcc">
			<gmd:DQ_AbsoluteExternalPositionalAccuracy>
				<xsl:apply-templates select="." mode="DQElement"/>
			</gmd:DQ_AbsoluteExternalPositionalAccuracy>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="DQAccTimeMeas">
			<gmd:DQ_AccuracyOfATimeMeasurement>
				<xsl:apply-templates select="." mode="DQElement"/>
			</gmd:DQ_AccuracyOfATimeMeasurement>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="DQCompComm">
			<gmd:DQ_CompletenessCommission>
				<xsl:apply-templates select="." mode="DQElement"/>
			</gmd:DQ_CompletenessCommission>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="DQCompOm">
			<gmd:DQ_CompletenessOmission>
				<xsl:apply-templates select="." mode="DQElement"/>
			</gmd:DQ_CompletenessOmission>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="DQConcConsis">
			<gmd:DQ_ConceptualConsistency>
				<xsl:apply-templates select="." mode="DQElement"/>
			</gmd:DQ_ConceptualConsistency>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="DQDomConsis">
			<gmd:DQ_DomainConsistency>
				<xsl:apply-templates select="." mode="DQElement"/>
			</gmd:DQ_DomainConsistency>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="DQFormConsis">
			<gmd:DQ_FormatConsistency>
				<xsl:apply-templates select="." mode="DQElement"/>
			</gmd:DQ_FormatConsistency>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="DQGridDataPosAcc">
			<gmd:DQ_GriddedDataPositionalAccuracy>
				<xsl:apply-templates select="." mode="DQElement"/>
			</gmd:DQ_GriddedDataPositionalAccuracy>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="DQNonQuanAttAcc">
			<gmd:DQ_NonQuantitativeAttributeAccuracy>
				<xsl:apply-templates select="." mode="DQElement"/>
			</gmd:DQ_NonQuantitativeAttributeAccuracy>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="DQQuanAttAcc">
			<gmd:DQ_QuantitativeAttributeAccuracy>
				<xsl:apply-templates select="." mode="DQElement"/>
			</gmd:DQ_QuantitativeAttributeAccuracy>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="DQRelIntPosAcc">
			<gmd:DQ_RelativeInternalPositionalAccuracy>
				<xsl:apply-templates select="." mode="DQElement"/>
			</gmd:DQ_RelativeInternalPositionalAccuracy>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="DQTempConsis">
			<gmd:DQ_TemporalConsistency>
				<xsl:apply-templates select="." mode="DQElement"/>
			</gmd:DQ_TemporalConsistency>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="DQTempValid">
			<gmd:DQ_TemporalValidity>
				<xsl:apply-templates select="." mode="DQElement"/>
			</gmd:DQ_TemporalValidity>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="DQThemClassCor">
			<gmd:DQ_ThematicClassificationCorrectness>
				<xsl:apply-templates select="." mode="DQElement"/>
			</gmd:DQ_ThematicClassificationCorrectness>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="DQTopConsis">
			<gmd:DQ_TopologicalConsistency>
				<xsl:apply-templates select="." mode="DQElement"/>
			</gmd:DQ_TopologicalConsistency>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="DQElement">

		<xsl:for-each select="measName">
			<gmd:nameOfMeasure>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:nameOfMeasure>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="measId">
			<gmd:measureIdentification>
				<xsl:apply-templates select="." mode="MdIdentTypes"/>
			</gmd:measureIdentification>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="measureDescription">
			<gmd:measureDescription>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:measureDescription>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="evalMethType">
			<gmd:evaluationMethodType>
				<gmd:DQ_EvaluationMethodTypeCode codeList="{$resourceLocation}DQ_EvaluationMethodTypeCode" codeListValue="{EvalMethTypeCd/@value}" />
			</gmd:evaluationMethodType>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="evalMethDesc">
			<gmd:evaluationMethodDescription>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:evaluationMethodDescription>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="evaluationProcedure">
			<gmd:evaluationProcedure>
				<gmd:CI_Citation>
					<xsl:apply-templates select="." mode="Citation"/>
				</gmd:CI_Citation>
			</gmd:evaluationProcedure>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="measDateTm">
			<gmd:dateTime>
				<gco:DateTime><xsl:value-of select="."/></gco:DateTime>
			</gmd:dateTime>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="measResult">
			<gmd:result>
				<xsl:apply-templates select="." mode="ResultTypes"/>
			</gmd:result>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="MdIdentTypes">

		<xsl:for-each select="MdIdent">
			<gmd:MD_Identifier>
				<xsl:apply-templates select="." mode="MdIdent"/>
			</gmd:MD_Identifier>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="RS_Identifier">
			<gmd:RS_Identifier>
				<xsl:apply-templates select="." mode="MdIdent"/>
			</gmd:RS_Identifier>
		</xsl:for-each>
		
	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="ResultTypes">

		<xsl:for-each select="ConResult">
			<gmd:DQ_ConformanceResult>
				<xsl:apply-templates select="." mode="ConResult"/>
			</gmd:DQ_ConformanceResult>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="QuanResult">
			<gmd:DQ_QuantitativeResult>
				<xsl:apply-templates select="." mode="QuanResult"/>
			</gmd:DQ_QuantitativeResult>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="ConResult">

		<gmd:specification>
			<gmd:CI_Citation>
				<xsl:apply-templates select="conSpec" mode="Citation"/>
			</gmd:CI_Citation>
		</gmd:specification>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<gmd:explanation>
			<gco:CharacterString><xsl:value-of select="conExpl"/></gco:CharacterString>
		</gmd:explanation>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<gmd:pass>
			<gco:Boolean><xsl:value-of select="conPass"/></gco:Boolean>
		</gmd:pass>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="QuanResult">

		<xsl:for-each select="quanValType">
			<gmd:valueType>
				<gco:RecordType><xsl:value-of select="."/></gco:RecordType>
			</gmd:valueType>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<gmd:valueUnit>
			<xsl:for-each select="quanValUnit">
				<gco:Measure>
					<xsl:apply-templates select="." mode="Measure"/>
				</gco:Measure>
			</xsl:for-each>
		</gmd:valueUnit>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="errStat">
			<gmd:errorStatistic>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:errorStatistic>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="quanValue">
			<gmd:value>
				<gco:Record><xsl:value-of select="."/></gco:Record>
			</gmd:value>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->
	<!-- === Lineage === -->
	<!-- ============================================================================= -->

	<xsl:template match="*" mode="Lineage">

		<xsl:for-each select="statement">
			<gmd:statement>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:statement>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="prcStep">
			<gmd:processStep>
				<gmd:LI_ProcessStep>
					<xsl:apply-templates select="." mode="PrcessStep"/>
				</gmd:LI_ProcessStep>
			</gmd:processStep>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="dataSource">
			<gmd:source>
				<gmd:LI_Source>
					<xsl:apply-templates select="." mode="Source"/>
				</gmd:LI_Source>
			</gmd:source>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="PrcessStep">

		<gmd:description>
			<gco:CharacterString><xsl:value-of select="stepDesc"/></gco:CharacterString>
		</gmd:description>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="stepRat">
			<gmd:rationale>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:rationale>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="stepDateTm">
			<gmd:dateTime>
				<gco:DateTime><xsl:value-of select="."/></gco:DateTime>
			</gmd:dateTime>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="stepProc">
			<gmd:processor>
				<gmd:CI_ResponsibleParty>
					<xsl:apply-templates select="." mode="RespParty"/>
				</gmd:CI_ResponsibleParty>
			</gmd:processor>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="stepSrc">
			<gmd:source>
				<gmd:LI_Source>
					<xsl:apply-templates select="." mode="Source"/>
				</gmd:LI_Source>
			</gmd:source>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="Source">

		<xsl:for-each select="srcDesc">
			<gmd:description>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:description>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="srcScale">
			<gmd:scaleDenominator>
				<gmd:MD_RepresentativeFraction>
					<gmd:denominator>
						<gco:Integer><xsl:value-of select="rfDenom"/></gco:Integer>
					</gmd:denominator>
				</gmd:MD_RepresentativeFraction>
			</gmd:scaleDenominator>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="srcRefSys">
			<gmd:sourceReferenceSystem>
			
					<xsl:for-each select="DirectReferenceSystem"> <!-- PROFIL FRANCAIS -->
						<fra:FRA_DirectReferenceSystem gco:isoType="MD_ReferenceSystem">
							<xsl:apply-templates select="." mode="RefSystemTypes"/>
						</fra:FRA_DirectReferenceSystem>
					</xsl:for-each>
					
					<xsl:for-each select="InDirectReferenceSystem"> <!-- PROFIL FRANCAIS -->
						<fra:FRA_IndirectReferenceSystem gco:isoType="MD_ReferenceSystem">
							<xsl:apply-templates select="." mode="RefSystemTypes"/>
						</fra:FRA_IndirectReferenceSystem>
					</xsl:for-each>

					<xsl:for-each select="RefSystemTypes"> <!-- impossible car abstract -->
						<gmd:MD_ReferenceSystem>
							<xsl:apply-templates select="." mode="RefSystemTypes"/>
						</gmd:MD_ReferenceSystem>
					</xsl:for-each>
								
			</gmd:sourceReferenceSystem>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="srcCitatn">
			<gmd:sourceCitation>
				<gmd:CI_Citation>
					<xsl:apply-templates select="." mode="Citation"/>
				</gmd:CI_Citation>
			</gmd:sourceCitation>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="srcExt">
			<gmd:sourceExtent>
				<gmd:EX_Extent>
					<xsl:apply-templates select="." mode="Extent"/>
				</gmd:EX_Extent>
			</gmd:sourceExtent>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="srcStep">
			<gmd:sourceStep>
				<gmd:LI_ProcessStep>
					<xsl:apply-templates select="." mode="PrcessStep"/>
				</gmd:LI_ProcessStep>
			</gmd:sourceStep>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->

</xsl:stylesheet>
