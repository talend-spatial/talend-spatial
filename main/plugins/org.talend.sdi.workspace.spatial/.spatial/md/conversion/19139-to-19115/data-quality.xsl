<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:fra="http://www.cnig.gouv.fr/2005/fra"
										xmlns:gmd="http://www.isotc211.org/2005/gmd"
										xmlns:gmi="http://www.isotc211.org/2005/gmi"
										xmlns:gco="http://www.isotc211.org/2005/gco"
										xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
										xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
										exclude-result-prefixes="fra gmd gmi gco xsi">

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="DataQuality">


		<dqScope><!--1..1-->
				<xsl:apply-templates select="gmd:scope/gmd:DQ_Scope" mode="DQScope"/>
		</dqScope>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:lineage">
			<dataLineage><!--0..1-->
					<xsl:apply-templates select="gmd:LI_Lineage" mode="Lineage"/>
			</dataLineage>
		</xsl:for-each>
		
		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:report">
			<dqReport><!--0..n-->
				<xsl:apply-templates select="." mode="DQElementTypes"/>
			</dqReport>
		</xsl:for-each>		

	</xsl:template>

	<!-- ============================================================================= -->
	<!-- === Data quality scope === -->
	<!-- ============================================================================= -->

	<xsl:template match="*" mode="DQScope">
		
		<!-- ATTENTION 1 seul level dans la 19139 alors quela 19115 en permet plusieurs -->
		<scpLvl><!--1..n en 19115 1..1 gmd:level en 19139-->
			<ScopeCd value="{gmd:level/gmd:MD_ScopeCode/@codeListValue}" />
		</scpLvl>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:extent">
			<scpExt><!--0..1-->
					<xsl:apply-templates select="gmd:EX_Extent" mode="Extent"/>
			</scpExt>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:levelDescription">
			<scpLvlDesc><!--0..n-->
					<xsl:apply-templates select="gmd:MD_ScopeDescription" mode="ScpDesc"/>
			</scpLvlDesc>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="ScpDesc"> <!-- SILOGIC - ATTENTION - attribut uuidref utilisé au lieu du type -->
		<!-- ATTENTION -->
		<!--19115 séquence 0..n ScpDesc dont héritent les types ci-dessous-->
		<!--19139 choix d'une séquence 1..n éléments de même type -->
		<xsl:for-each select="gmd:attributeInstances">
			<attribIntSet>
				<xsl:value-of select="@uuidref"/>
			</attribIntSet>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:attributes">
			<attribSet>
				<xsl:value-of select="@uuidref"/>
			</attribSet>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:dataset">
			<datasetSet><xsl:value-of select="."/></datasetSet>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:featureInstances">
			<featIntSet><xsl:value-of select="@uuidref"/></featIntSet>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:features">
			<featSet><xsl:value-of select="@uuidref"/></featSet>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:other">
			<other><xsl:value-of select="."/></other>
		</xsl:for-each>
	</xsl:template>

	<!-- ============================================================================= -->
	<!-- === DQElementTypes === -->
	<!-- ============================================================================= -->

	<xsl:template match="*" mode="DQElementTypes">

		<xsl:for-each select="gmd:DQ_AbsoluteExternalPositionalAccuracy">
			<DQAbsExtPosAcc>
				<xsl:apply-templates select="." mode="DQElement"/>
			</DQAbsExtPosAcc>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:DQ_AccuracyOfATimeMeasurement">
			<DQAccTimeMeas>
				<xsl:apply-templates select="." mode="DQElement"/>
			</DQAccTimeMeas>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:DQ_CompletenessCommission">
			<DQCompComm>
				<xsl:apply-templates select="." mode="DQElement"/>
			</DQCompComm>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:DQ_CompletenessOmission">
			<DQCompOm>
				<xsl:apply-templates select="." mode="DQElement"/>
			</DQCompOm>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:DQ_ConceptualConsistency">
			<DQConcConsis>
				<xsl:apply-templates select="." mode="DQElement"/>
			</DQConcConsis>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:DQ_DomainConsistency">
			<DQDomConsis>
				<xsl:apply-templates select="." mode="DQElement"/>
			</DQDomConsis>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:DQ_FormatConsistency">
			<DQFormConsis>
				<xsl:apply-templates select="." mode="DQElement"/>
			</DQFormConsis>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:DQ_GriddedDataPositionalAccuracy">
			<DQGridDataPosAcc>
				<xsl:apply-templates select="." mode="DQElement"/>
			</DQGridDataPosAcc>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:DQ_NonQuantitativeAttributeAccuracy">
			<DQNonQuanAttAcc>
				<xsl:apply-templates select="." mode="DQElement"/>
			</DQNonQuanAttAcc>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:DQ_QuantitativeAttributeAccuracy">
			<DQQuanAttAcc>
				<xsl:apply-templates select="." mode="DQElement"/>
			</DQQuanAttAcc>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:DQ_RelativeInternalPositionalAccuracy">
			<DQRelIntPosAcc>
				<xsl:apply-templates select="." mode="DQElement"/>
			</DQRelIntPosAcc>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:DQ_TemporalConsistency">
			<DQTempConsis>
				<xsl:apply-templates select="." mode="DQElement"/>
			</DQTempConsis>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:DQ_TemporalValidity">
			<DQTempValid>
				<xsl:apply-templates select="." mode="DQElement"/>
			</DQTempValid>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:DQ_ThematicClassificationCorrectness">
			<DQThemClassCor>
				<xsl:apply-templates select="." mode="DQElement"/>
			</DQThemClassCor>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:DQ_TopologicalConsistency">
			<DQ_TopologicalConsistency>
				<xsl:apply-templates select="." mode="DQElement"/>
			</DQ_TopologicalConsistency>
		</xsl:for-each>
		
		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->		

		<xsl:for-each select="gmi:QE_Usability"> <!-- PROFIL FRANCAIS -->
			<QEUsability>
				<xsl:apply-templates select="." mode="DQElement"/>
			</QEUsability>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="DQElement">

		<xsl:for-each select="gmd:nameOfMeasure">
			<measName><!--0..n-->
				<xsl:value-of select="gco:CharacterString"/>
			</measName>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:measureIdentification">
			<measId><!--0..1-->
				<xsl:apply-templates select="." mode="MdIdentTypes"/>
			</measId>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:measureDescription">
			<measureDescription><!--0..1-->
				<xsl:value-of select="gco:CharacterString"/>
			</measureDescription>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:evaluationMethodType">
			<evalMethType><!--0..1-->
				<EvalMethTypeCd value="{gmd:DQ_EvaluationMethodTypeCode/@codeListValue}" />
			</evalMethType>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:evaluationMethodDescription">
			<evalMethDesc><!--0..1-->
				<xsl:value-of select="gco:CharacterString"/>
			</evalMethDesc>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:evaluationProcedure">
			<evaluationProcedure><!--0..1-->
					<xsl:apply-templates select="gmd:CI_Citation" mode="Citation"/>
			</evaluationProcedure>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:dateTime">
			<measDateTm><!--0..1-->
				<xsl:value-of select="gco:DateTime"/>
			</measDateTm>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:result">
			<measResult><!--1..n-->
				<xsl:apply-templates select="." mode="ResultTypes"/>
			</measResult>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="MdIdentTypes">

		<xsl:for-each select="gmd:MD_Identifier">
			<MdIdent>
				<xsl:apply-templates select="." mode="MdIdent"/>
			</MdIdent>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:RS_Identifier">
			<RS_Identifier>
				<xsl:apply-templates select="." mode="MdIdent"/>
			</RS_Identifier>
		</xsl:for-each>
		
	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="ResultTypes">

		<xsl:for-each select="gmd:DQ_ConformanceResult">
			<ConResult>
				<xsl:apply-templates select="." mode="ConResult"/>
			</ConResult>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:DQ_QuantitativeResult">
			<QuanResult>
				<xsl:apply-templates select="." mode="QuanResult"/>
			</QuanResult>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="ConResult">

		<conSpec>
				<xsl:apply-templates select="gmd:specification/gmd:CI_Citation" mode="Citation"/>
		</conSpec>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<conExpl>
			<xsl:value-of select="gmd:explanation/gco:CharacterString"/>
		</conExpl>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<conPass>
			<xsl:value-of select="gmd:pass/gco:Boolean"/>
		</conPass>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="QuanResult">

		<xsl:for-each select="gmd:valueType">
			<quanValType>
				<xsl:value-of select="gco:RecordType"/>
			</quanValType>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:valueUnit">
			<quanValUnit>
					<xsl:apply-templates select="gco:Measuremode" mode="Measure"/>
			</quanValUnit>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:errorStatistic">
			<errStat>
				<xsl:value-of select="gco:CharacterString"/>
			</errStat>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:value">
			<quanValue>
				<xsl:value-of select="gco:Record"/>
			</quanValue>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->
	<!-- === Lineage === -->
	<!-- ============================================================================= -->

	<xsl:template match="*" mode="Lineage">

		<xsl:for-each select="gmd:statement">
			<statement><!--0..1-->
				<xsl:value-of select="gco:CharacterString"/>
			</statement>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:source">
			<dataSource><!--0..n-->
					<xsl:apply-templates select="gmd:LI_Source" mode="Source"/>
			</dataSource>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->		
		<xsl:for-each select="gmd:processStep">
			<prcStep><!--0..n-->
					<xsl:apply-templates select="gmd:LI_ProcessStep" mode="PrcessStep"/>
			</prcStep>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="PrcessStep">

		<stepDesc><!--1..1-->
			<xsl:value-of select="gmd:description/gco:CharacterString"/>
		</stepDesc>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:rationale">
			<stepRat><!--0..1-->
				<xsl:value-of select="gco:CharacterString"/>
			</stepRat>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:dateTime">
			<stepDateTm><!--0..1-->
				<xsl:value-of select="gco:DateTime"/>
			</stepDateTm>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:processor">
			<stepProc><!--0..n-->
					<xsl:apply-templates select="gmd:CI_ResponsibleParty" mode="RespParty"/>
			</stepProc>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:source">
			<stepSrc><!--0..n-->
					<xsl:apply-templates select="gmd:LI_Source" mode="Source"/>
			</stepSrc>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="Source">

		<xsl:for-each select="gmd:description">
			<srcDesc><!--0..1-->
				<xsl:value-of select="gco:CharacterString"/>
			</srcDesc>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:scaleDenominator">
			<srcScale><!--0..1-->
				<rfDenom>
						<xsl:value-of select="gmd:MD_RepresentativeFraction/gmd:denominator/gco:Integer"/>
				</rfDenom>
			</srcScale>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:sourceReferenceSystem">
			<srcRefSys><!--0..1-->
				<xsl:apply-templates select="gmd:MD_ReferenceSystem" mode="RefSystemTypes"/>
				<xsl:apply-templates select="fra:FRA_DirectReferenceSystem" mode="DirectRefSystemTypes"/>
				<xsl:apply-templates select="fra:FRA_IndirectReferenceSystem" mode="IndirectRefSystemTypes"/>
			</srcRefSys>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:sourceCitation">
			<srcCitatn><!--0..1-->
					<xsl:apply-templates select="gmd:CI_Citation" mode="Citation"/>
			</srcCitatn>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:sourceExtent">
			<srcExt><!--0..n-->
					<xsl:apply-templates select="gmd:EX_Extent" mode="Extent"/>
			</srcExt>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:sourceStep">
			<srcStep><!--0..n-->
					<xsl:apply-templates select="gmd:LI_ProcessStep" mode="PrcessStep"/>
			</srcStep>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->

</xsl:stylesheet>
