<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:fra="http://www.cnig.gouv.fr/2005/fra" 
										xmlns:gmd="http://www.isotc211.org/2005/gmd"
										xmlns:gco="http://www.isotc211.org/2005/gco"
										xmlns:gml="http://www.opengis.net/gml"
										xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
										xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="SpatRepTypes">

		<xsl:for-each select="GridSpatRep">
			<gmd:MD_GridSpatialRepresentation>
				<xsl:apply-templates select="." mode="GridSpatRep"/>
			</gmd:MD_GridSpatialRepresentation>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="Georect">
			<gmd:MD_Georectified>
				<xsl:apply-templates select="." mode="Georect"/>
			</gmd:MD_Georectified>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="Georef">
			<gmd:MD_Georeferenceable>
				<xsl:apply-templates select="." mode="Georef"/>
			</gmd:MD_Georeferenceable>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="VectSpatRep">
			<gmd:MD_VectorSpatialRepresentation>
				<xsl:apply-templates select="." mode="VectSpatRep"/>
			</gmd:MD_VectorSpatialRepresentation>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->
	<!-- === GridSpatRep === -->
	<!-- ============================================================================= -->

	<xsl:template match="*" mode="GridSpatRep">

		<gmd:numberOfDimensions>
			<gco:Integer><xsl:value-of select="numDims"/></gco:Integer>
		</gmd:numberOfDimensions>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="axDimProps/Dimen">
			<gmd:axisDimensionProperties>
				<gmd:MD_Dimension>
					<xsl:apply-templates select="." mode="DimensionProps"/>
				</gmd:MD_Dimension>
			</gmd:axisDimensionProperties>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<gmd:cellGeometry>
			<gmd:MD_CellGeometryCode codeList="{$resourceLocation}MD_CellGeometryCode" codeListValue="{cellGeo/CellGeoCd/@value}" />
		</gmd:cellGeometry>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<gmd:transformationParameterAvailability>
			<gco:Boolean><xsl:value-of select="tranParaAv"/></gco:Boolean>
		</gmd:transformationParameterAvailability>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="DimensionProps">

		<gmd:dimensionName>
			<gmd:MD_DimensionNameTypeCode codeList="{$resourceLocation}MD_DimensionNameTypeCode" codeListValue="{dimName/DimNameTypCd/@value}" />
		</gmd:dimensionName>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<gmd:dimensionSize>
			<gco:Integer><xsl:value-of select="dimSize"/></gco:Integer>
		</gmd:dimensionSize>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="dimResol">
			<gmd:resolution>
				<gco:Measure>
					<xsl:apply-templates select="." mode="Measure"/>
				</gco:Measure>
			</gmd:resolution>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="Measure">
	
		<!-- SILOGIC DELETED 
		<xsl:attribute name="uom">
				<xsl:value-of select="uom/*/uomName"/>,
				<xsl:value-of select="uom/*/conversionToISOstandardUnit"/>
		</xsl:attribute>

		<xsl:value-of select="value/Decimal"/>
		<xsl:value-of select="value/Integer"/>
		<xsl:value-of select="value/Real"/>
		-->
		
		<!-- SILOGIC ADDED -->
		<!-- Le champ uom/conversionToISOstandardUnit n'est pas connu dans la 19139 MD_Metadata -->
		<xsl:if test="uom/UomMeasure">
			<gco:Measure> <!-- possible car non abstract -->
				<xsl:value-of select="Real/value"/>
				<xsl:value-of select="Integer/value"/>
				<xsl:value-of select="Decimal/value"/>
				<xsl:attribute name="uom">
						<xsl:value-of select="uom/uomName"/>
				</xsl:attribute>
			</gco:Measure>
		</xsl:if>
		
		<xsl:if test="uom/UomScale">
			<gco:Scale>
				<xsl:value-of select="Real/value"/>
				<xsl:value-of select="Integer/value"/>
				<xsl:value-of select="Decimal/value"/>
				<xsl:attribute name="uom">
						<xsl:value-of select="uom/uomName"/>
				</xsl:attribute>
			</gco:Scale>
		</xsl:if>

		<xsl:if test="uom/UomDistance">
			<gco:Distance>
				<xsl:value-of select="Real/value"/>
				<xsl:value-of select="Integer/value"/>
				<xsl:value-of select="Decimal/value"/>
				<xsl:attribute name="uom">
						<xsl:value-of select="uom/uomName"/>
				</xsl:attribute>
			</gco:Distance>
		</xsl:if>

		<xsl:if test="uom/UomAngle">
			<gco:Angle>
				<xsl:value-of select="Real/value"/>
				<xsl:value-of select="Integer/value"/>
				<xsl:value-of select="Decimal/value"/>
				<xsl:attribute name="uom">
						<xsl:value-of select="uom/uomName"/>
				</xsl:attribute>
			</gco:Angle>
		</xsl:if>

		<xsl:if test="uom/UomLength">
			<gco:Length>
				<xsl:value-of select="Real/value"/>
				<xsl:value-of select="Integer/value"/>
				<xsl:value-of select="Decimal/value"/>
				<xsl:attribute name="uom">
						<xsl:value-of select="uom/uomName"/>
				</xsl:attribute>
			</gco:Length>
		</xsl:if>

	</xsl:template>

	<!-- ============================================================================= -->
	<!-- === Georect === -->
	<!-- ============================================================================= -->

	<xsl:template match="*" mode="Georect">

		<xsl:apply-templates select="*" mode="GridSpatRep"/>

		<gmd:checkPointAvailability>
			<gco:Boolean><xsl:value-of select="chkPtAv"/></gco:Boolean>
		</gmd:checkPointAvailability>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="chkPtDesc">
			<gmd:checkPointDescription>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:checkPointDescription>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="cornerPts">
			<gmd:cornerPoints>
				<gml:Point>
					<xsl:apply-templates select="." mode="PointType"/>
				</gml:Point>
			</gmd:cornerPoints>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="centerPt">
			<gmd:centerPoint>
				<gml:Point>
					<xsl:apply-templates select="." mode="PointType"/>
				</gml:Point>
			</gmd:centerPoint>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<gmd:pointInPixel>
			<gmd:MD_PixelOrientationCode>
				<xsl:value-of select="ptInPixel/PixOrientCd/@value"/>
			</gmd:MD_PixelOrientationCode>
		</gmd:pointInPixel>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="transDimDesc">
			<gmd:transformationDimensionDescription>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:transformationDimensionDescription>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="transDimMap">
			<gmd:transformationDimensionMapping>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:transformationDimensionMapping>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="PointType">
		<gml:coordinates>

			<xsl:if test="coordinates/@tupleSep">
				<xsl:attribute name="ts">
					<xsl:choose>
						<xsl:when test="coordinates/@tupleSep = 'space'" > </xsl:when>
						<xsl:when test="coordinates/@tupleSep = 'comma'" >,</xsl:when>
						<xsl:when test="coordinates/@tupleSep = 'period'">.</xsl:when>
					</xsl:choose>
				</xsl:attribute>
			</xsl:if>

			<xsl:if test="coordinates/@coordSep">
				<xsl:attribute name="cs">
					<xsl:choose>
						<xsl:when test="coordinates/@coordSep = 'space'" > </xsl:when>
						<xsl:when test="coordinates/@coordSep = 'comma'" >,</xsl:when>
						<xsl:when test="coordinates/@coordSep = 'period'">.</xsl:when>
					</xsl:choose>
				</xsl:attribute>
			</xsl:if>

			<xsl:if test="coordinates/@decimalChar">
				<xsl:attribute name="decimal">
					<xsl:choose>
						<xsl:when test="coordinates/@decimalChar = 'space'" > </xsl:when>
						<xsl:when test="coordinates/@decimalChar = 'comma'" >,</xsl:when>
						<xsl:when test="coordinates/@decimalChar = 'period'">.</xsl:when>
					</xsl:choose>
				</xsl:attribute>
			</xsl:if>

			<xsl:value-of select="."/>
		</gml:coordinates>
	</xsl:template>

	<!-- ============================================================================= -->
	<!-- === Georef === -->
	<!-- ============================================================================= -->

	<xsl:template match="*" mode="Georef">

		<xsl:apply-templates select="*" mode="GridSpatRep"/>

		<gmd:controlPointAvailability>
			<gco:Boolean><xsl:value-of select="ctrlPtAv"/></gco:Boolean>
		</gmd:controlPointAvailability>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<gmd:orientationParameterAvailability>
			<gco:Boolean><xsl:value-of select="orieParaAv"/></gco:Boolean>
		</gmd:orientationParameterAvailability>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="orieParaDesc">
			<gmd:orientationParameterDescription>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:orientationParameterDescription>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<gmd:georeferencedParameters>
			<gco:Record><xsl:value-of select="georefPars"/></gco:Record>
		</gmd:georeferencedParameters>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="paraCit">
			<gmd:parameterCitation>
				<gmd:CI_Citation>
					<xsl:apply-templates select="." mode="Citation"/>
				</gmd:CI_Citation>
			</gmd:parameterCitation>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->
	<!-- === VectSpatRep === -->
	<!-- ============================================================================= -->

	<xsl:template match="*" mode="VectSpatRep">

		<xsl:for-each select="topLvl">
			<gmd:topologyLevel>
				<gmd:MD_TopologyLevelCode codeList="{$resourceLocation}MD_TopologyLevelCode" codeListValue="{TopoLevCd/@value}" />
			</gmd:topologyLevel>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="geometObjs">
			<gmd:geometricObjects>
				<gmd:MD_GeometricObjects>
					<xsl:apply-templates select="." mode="GeometObjs"/>
				</gmd:MD_GeometricObjects>
			</gmd:geometricObjects>
		</xsl:for-each>
	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="GeometObjs">

		<gmd:geometricObjectType>
			<gmd:MD_GeometricObjectTypeCode codeList="{$resourceLocation}MD_GeometricObjectTypeCode">
				<xsl:attribute name="codeListValue">
<!--				
					<xsl:choose>
						<xsl:when test="geoObjTyp/GeoObjTypCd/@value = 'complexes'">complex</xsl:when>
						<xsl:when test="geoObjTyp/GeoObjTypCd/@value = 'composites'">composite</xsl:when>
						<xsl:otherwise>
-->
							<xsl:value-of select="geoObjTyp/GeoObjTypCd/@value"/>
<!--
						</xsl:otherwise>
					</xsl:choose>
-->
				</xsl:attribute>
			</gmd:MD_GeometricObjectTypeCode>
		</gmd:geometricObjectType>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="geoObjCnt">
			<geometricObjectCount>
				<gco:Integer><xsl:value-of select="."/></gco:Integer>
			</geometricObjectCount>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->

</xsl:stylesheet>
