<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:fra="http://www.cnig.gouv.fr/2005/fra" 
										xmlns:gmd="http://www.isotc211.org/2005/gmd"
										xmlns:gco="http://www.isotc211.org/2005/gco"
										xmlns:gml="http://www.opengis.net/gml"
										xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
										xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
										
	<!-- ============================================================================= -->

	<xsl:template match="*" mode="ContInfoTypes">

		<xsl:for-each select="CovDesc">
			<gmd:MD_CoverageDescription>
				<xsl:apply-templates select="." mode="CovDesc"/>
			</gmd:MD_CoverageDescription>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="FetCatDesc">
			<gmd:MD_FeatureCatalogueDescription>
				<xsl:apply-templates select="." mode="FetCatDesc"/>
			</gmd:MD_FeatureCatalogueDescription>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="ImgDesc">
			<gmd:MD_ImageDescription>
				<xsl:apply-templates select="." mode="ImgDesc"/>
			</gmd:MD_ImageDescription>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->
	<!-- === CovDesc === -->
	<!-- ============================================================================= -->

	<xsl:template match="*" mode="CovDesc">

		<gmd:attributeDescription>
			<gco:RecordType><xsl:value-of select="attDesc"/></gco:RecordType>
		</gmd:attributeDescription>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<gmd:contentType>
			<gmd:MD_CoverageContentTypeCode codeList="{$resourceLocation}MD_CoverageContentTypeCode" codeListValue="{contentTyp/ContentTypCd/@value}" />
		</gmd:contentType>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="covDim">
			<gmd:dimension>
				<xsl:apply-templates select="." mode="RangeDimTypes"/>
			</gmd:dimension>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="RangeDimTypes">

		<xsl:for-each select="RangeDim">
			<gmd:MD_RangeDimension>
				<xsl:apply-templates select="." mode="RangeDim"/>
			</gmd:MD_RangeDimension>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="Band">
			<gmd:MD_Band>
				<xsl:apply-templates select="." mode="Band"/>
			</gmd:MD_Band>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="RangeDim">

		<xsl:for-each select="seqID">
			<gmd:sequenceIdentifier>
				<gco:MemberName>
					<xsl:apply-templates select="." mode="MemberName"/>
				</gco:MemberName>
			</gmd:sequenceIdentifier>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="dimDescrp">
			<gmd:descriptor>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:descriptor>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="MemberName">

		<gco:aName>
			<gco:CharacterString><xsl:value-of select="aName"/></gco:CharacterString>
		</gco:aName>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<gco:attributeType>
			<gco:TypeName>
				<gco:aName><!-- ATTENTION nécessairement gco:CharacterString -->
					<gco:CharacterString>
						<xsl:value-of select="attributeType/aName"/>
					</gco:CharacterString>
				</gco:aName>
			</gco:TypeName>
		</gco:attributeType>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="Band">

		<xsl:apply-templates select="." mode="RangeDim"/>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="maxVal">
			<gmd:maxValue>
				<gco:Real><xsl:value-of select="."/></gco:Real>
			</gmd:maxValue>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="minVal">
			<gmd:minValue>
				<gco:Real><xsl:value-of select="."/></gco:Real>
			</gmd:minValue>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="valUnit">
			<gmd:units>
				<gml:UnitDefinition>
					<xsl:apply-templates select="." mode="UomLength"/>
				</gml:UnitDefinition>
			</gmd:units>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="pkResp">
			<gmd:peakResponse>
				<gco:Real><xsl:value-of select="."/></gco:Real>
			</gmd:peakResponse>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="bitsPerVal">
			<gmd:bitsPerValue>
				<gco:Integer><xsl:value-of select="."/></gco:Integer>
			</gmd:bitsPerValue>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="toneGrad">
			<gmd:toneGradation>
				<gco:Integer><xsl:value-of select="."/></gco:Integer>
			</gmd:toneGradation>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="sclFac">
			<gmd:scaleFactor>
				<gco:Real><xsl:value-of select="."/></gco:Real>
			</gmd:scaleFactor>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="offset">
			<gmd:offset>
				<gco:Real><xsl:value-of select="."/></gco:Real>
			</gmd:offset>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="UomLength">

		<gml:name>
			<xsl:value-of select="uomName"/>
		</gml:name>
		<!-- ADDED SILOGIC OBLIGATOIRE -->
		<gml:identifier codespace="unkown"/>

	</xsl:template>

	<!-- ============================================================================= -->
	<!-- === FetCatDesc === -->
	<!-- ============================================================================= -->

	<xsl:template match="*" mode="FetCatDesc">

		<xsl:for-each select="compCode">
			<gmd:complianceCode>
				<gco:Boolean><xsl:value-of select="."/></gco:Boolean>
			</gmd:complianceCode>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="catLang">
			<gmd:language><!-- ATTENTION construction nécessairement d'un gco:CharacterString -->
				<gco:CharacterString><xsl:value-of select="languageCode/@value"/></gco:CharacterString>
			</gmd:language>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<gmd:includedWithDataset>
			<gco:Boolean><xsl:value-of select="incWithDS"/></gco:Boolean>
		</gmd:includedWithDataset>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="catFetTypes">
			<gmd:featureTypes>
				<xsl:apply-templates select="." mode="GenericNameTypes"/>
			</gmd:featureTypes>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="catCitation"> <!-- BUG GN ATTENTION Pas de idCitation mais catCitation directement -->
			<gmd:featureCatalogueCitation>
				<gmd:CI_Citation>
					<xsl:apply-templates select="." mode="Citation"/>
				</gmd:CI_Citation>
			</gmd:featureCatalogueCitation>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="GenericNameTypes">

		<xsl:for-each select="LocalName">
			<!--UPDATE SILOGIC . au lieu de scope - supprimé -->
			<gco:LocalName><xsl:value-of select="."/></gco:LocalName>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="ScopedName">
			<!--UPDATE SILOGIC . au lieu de scope - supprimé -->
			<gco:ScopedName><xsl:value-of select="."/></gco:ScopedName>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->
	<!-- === ImgDesc === -->
	<!-- ============================================================================= -->

	<xsl:template match="*" mode="ImgDesc">

		<xsl:apply-templates select="." mode="CovDesc"/>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="illElevAng">
			<gmd:illuminationElevationAngle>
				<gco:Real><xsl:value-of select="."/></gco:Real>
			</gmd:illuminationElevationAngle>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="illAziAng">
			<gmd:illuminationAzimuthAngle>
				<gco:Real><xsl:value-of select="."/></gco:Real>
			</gmd:illuminationAzimuthAngle>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="imagCond">
			<gmd:imagingCondition>
				<gmd:MD_ImagingConditionCode codeList="{$resourceLocation}MD_ImagingConditionCode" codeListValue="{ImgCondCd/@value}" />
			</gmd:imagingCondition>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="imagQuCode">
			<gmd:imageQualityCode>
				<xsl:apply-templates select="." mode="MdIdentTypes"/>
			</gmd:imageQualityCode>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="cloudCovPer">
			<gmd:cloudCoverPercentage>
				<gco:Real><xsl:value-of select="."/></gco:Real>
			</gmd:cloudCoverPercentage>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="prcTypCde">
			<gmd:processingLevelCode>
				<xsl:apply-templates select="." mode="MdIdentTypes"/>
			</gmd:processingLevelCode>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="cmpGenQuan">
			<gmd:compressionGenerationQuantity>
				<gco:Integer><xsl:value-of select="."/></gco:Integer>
			</gmd:compressionGenerationQuantity>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="trianInd">
			<gmd:triangulationIndicator>
				<gco:Boolean><xsl:value-of select="."/></gco:Boolean>
			</gmd:triangulationIndicator>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="radCalDatAv">
			<gmd:radiometricCalibrationDataAvailability>
				<gco:Boolean><xsl:value-of select="."/></gco:Boolean>
			</gmd:radiometricCalibrationDataAvailability>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="camCalInAv">
			<gmd:cameraCalibrationInformationAvailability>
				<gco:Boolean><xsl:value-of select="."/></gco:Boolean>
			</gmd:cameraCalibrationInformationAvailability>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="filmDistInAv">
			<gmd:filmDistortionInformationAvailability>
				<gco:Boolean><xsl:value-of select="."/></gco:Boolean>
			</gmd:filmDistortionInformationAvailability>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="lensDistInAv">
			<gmd:lensDistortionInformationAvailability>
				<gco:Boolean><xsl:value-of select="."/></gco:Boolean>
			</gmd:lensDistortionInformationAvailability>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->

</xsl:stylesheet>
