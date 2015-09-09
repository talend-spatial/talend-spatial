<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:gmd="http://www.isotc211.org/2005/gmd"
										xmlns:gco="http://www.isotc211.org/2005/gco"
										xmlns:gml="http://www.opengis.net/gml"
										xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
										xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
										exclude-result-prefixes="gmd gco gml xsi">

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="ContInfoTypes">
	<!-- sequence 0..n de ContInfoTypes dont dérivent les types suivants -->
	
		<!-- ContInfo abstract -->
	
		<xsl:for-each select="gmd:MD_CoverageDescription">
			<CovDesc>
				<xsl:apply-templates select="." mode="CovDesc"/>
			</CovDesc>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:MD_FeatureCatalogueDescription">
			<FetCatDesc>
				<xsl:apply-templates select="." mode="FetCatDesc"/>
			</FetCatDesc>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:MD_ImageDescription">
			<ImgDesc>
				<xsl:apply-templates select="." mode="ImgDesc"/>
			</ImgDesc>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->
	<!-- === CovDesc === -->
	<!-- ============================================================================= -->

	<xsl:template match="*" mode="CovDesc">

		<attDesc><!--1..1--><!-- ATTENTION SILOGIC Complex type dans string -->
			<xsl:value-of select="gmd:attributeDescription/gco:RecordType"/>
		</attDesc>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<contentTyp><!--1..1-->
			 <ContentTypCd value="{gmd:MD_CoverageContentTypeCode/@codeListValue}"/>
		</contentTyp>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:dimension">
			<covDim><!--0..n-->
				<xsl:apply-templates select="." mode="RangeDimTypes"/>
			</covDim>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="RangeDimTypes">
		<!-- l'un des types suivants -->
		<xsl:for-each select="gmd:MD_RangeDimension">
			<RangeDim>
				<xsl:apply-templates select="." mode="RangeDim"/>
			</RangeDim>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:MD_Band">
			<Band>
				<xsl:apply-templates select="." mode="Band"/>
			</Band>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="RangeDim">  <!-- TOTEST -->

		<xsl:for-each select="gmd:sequenceIdentifier">
			<seqID><!--0..1-->
				<xsl:apply-templates select="gco:MemberName" mode="MemberName"/>
			</seqID>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:descriptor">  <!-- TOTEST -->
			<dimDescrp><!--0..1-->
				<xsl:value-of select="gco:CharacterString"/>
			</dimDescrp>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="MemberName">
		
		<aName> <!--1..1-->
			<xsl:value-of select="gco:aName/gco:CharacterString"/>
		</aName>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

       <attributeType><!--1..1 ATTENTION SILOGIC perte d'info sur les possibles sous-types de gco:CharacterString de la 19139 -->
		   <aName>
			   <xsl:for-each select="gco:attributeType/gco:TypeName/gco:aName/gco:CharacterString">
	   			   <xsl:value-of select="gco:attributeType/gco:TypeName/gco:aName/gco:CharacterString"/>
			   </xsl:for-each>
			   <xsl:for-each select="gco:attributeType/gco:TypeName/gco:aName/*[@codeListValue]">
				   <xsl:value-of select="@codeListValue"/>			   
			   </xsl:for-each>
		   </aName>
       </attributeType>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="Band">

		<xsl:apply-templates select="." mode="RangeDim"/>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:maxValue">
			<maxVal><!--0..1-->
				<xsl:value-of select="gco:Real"/>
			</maxVal>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:minValue">
			<minVal><!--0..1-->
				<xsl:value-of select="gco:Real"/>
			</minVal>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:units">
			<valUnit><!--0..1--><!-- Par forcément UnitDefinition -->
					<xsl:apply-templates select="*" mode="UomLength"/>
			</valUnit>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:peakResponse">
			<pkResp><!--0..1-->
				<xsl:value-of select="gco:Real"/>
			</pkResp>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:bitsPerValue">
			<bitsPerVal><!--0..1-->
				<xsl:value-of select="gco:Integer"/>
			</bitsPerVal>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:toneGradation">
			<toneGrad><!--0..1-->
				<xsl:value-of select="gco:Integer"/>
			</toneGrad>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:scaleFactor">
			<sclFac><!--0..1-->
				<xsl:value-of select="gco:Real"/>
			</sclFac>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:offset">
			<offset><!--0..1-->
				<xsl:value-of select="gco:Real"/>
			</offset>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="UomLength">
	
		<xsl:for-each select="*"><!-- A TESTER -->
			<uomName>
				<xsl:value-of select="gml:name"/>
			</uomName>
		</xsl:for-each>
		
		<!-- ATTENTION Pas de valeur dans conversionToISOstandarUnit -->
		
	</xsl:template>

	<!-- ============================================================================= -->
	<!-- === FetCatDesc === -->
	<!-- ============================================================================= -->

	<xsl:template match="*" mode="FetCatDesc">

		<xsl:for-each select="gmd:complianceCode">
			<compCode><!--0..1-->
				<xsl:value-of select="gco:Boolean"/>
			</compCode>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:language">
			<catLang><!--0..n--><!-- ATTENTION prise en compte des sous-types qui héritent de gco:CharacterString -->
				<languageCode>
					<xsl:attribute name="value">
						<xsl:value-of select="gco:CharacterString"/>
						<!-- OU -->
					   <xsl:for-each select="*[@codeListValue]">
						   <xsl:value-of select="@codeListValue"/>
					   </xsl:for-each>
					</xsl:attribute>
				</languageCode>
			</catLang>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<incWithDS><!--1..1-->
			<xsl:value-of select="gmd:includedWithDataset/gco:Boolean"/>
		</incWithDS>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:featureTypes">
			<catFetTypes><!--0..n-->
				<xsl:apply-templates select="." mode="GenericNameTypes"/>
			</catFetTypes>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:if test="not(gmd:featureCatalogueCitation)">
			<catCitation><!--1..n-->
				<resTitle/>
				<resRefDate>
					<refDate/>
					<refDateType>
						<DateTypCd value="unknown"/>
					</refDateType>
				</resRefDate>
			</catCitation>
		</xsl:if>
		<xsl:for-each select="gmd:featureCatalogueCitation">
			<catCitation><!--1..n-->
					<xsl:apply-templates select="gmd:CI_Citation" mode="Citation"/>
			</catCitation>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="GenericNameTypes"> 
		<!-- un des sous-types -->
		<xsl:for-each select="gco:LocalName">
			<LocalName>
					<xsl:value-of select="."/>
			</LocalName>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gco:ScopedName">
			<ScopedName>
					<xsl:value-of select="."/>
			</ScopedName>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->
	<!-- === ImgDesc === -->
	<!-- ============================================================================= -->

	<xsl:template match="*" mode="ImgDesc">

		<xsl:apply-templates select="." mode="CovDesc"/>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:illuminationElevationAngle">
			<illElevAng><!--0..1-->
				<xsl:value-of select="gco:Real"/>
			</illElevAng>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:illuminationAzimuthAngle">
			<illAziAng><!--0..1-->
				<xsl:value-of select="gco:Real"/>
			</illAziAng>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:imagingCondition">
			<imagCond><!--0..1-->
				<ImgCondCd value="{gmd:MD_ImagingConditionCode/@codeListValue}"/>
			</imagCond>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:imageQualityCode">
			<imagQuCode><!--0..1-->
				<xsl:apply-templates select="." mode="MdIdentTypes"/>
			</imagQuCode>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:cloudCoverPercentage">
			<cloudCovPer><!--0..1-->
				<xsl:value-of select="gco:Real"/>
			</cloudCovPer>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:processingLevelCode">
			<prcTypCde><!--0..1-->
				<xsl:apply-templates select="." mode="MdIdentTypes"/>
			</prcTypCde>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:compressionGenerationQuantity">
			<cmpGenQuan><!--0..1-->
				<xsl:value-of select="gco:Integer"/>
			</cmpGenQuan>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:triangulationIndicator">
			<trianInd><!--0..1-->
				<xsl:value-of select="gco:Boolean"/>
			</trianInd>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:radiometricCalibrationDataAvailability">
			<radCalDatAv><!--0..1-->
				<xsl:value-of select="gco:Boolean"/>
			</radCalDatAv>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:cameraCalibrationInformationAvailability">
			<camCalInAv><!--0..1-->
				<xsl:value-of select="gco:Boolean"/>
			</camCalInAv>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:filmDistortionInformationAvailability">
			<filmDistInAv><!--0..1-->
				<xsl:value-of select="gco:Boolean"/>
			</filmDistInAv>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:lensDistortionInformationAvailability">
			<lensDistInAv><!--0..1-->
				<xsl:value-of select="gco:Boolean"/>
			</lensDistInAv>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->

</xsl:stylesheet>
