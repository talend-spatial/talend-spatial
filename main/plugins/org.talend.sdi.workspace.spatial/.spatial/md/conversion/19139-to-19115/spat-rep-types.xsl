<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:gmd="http://www.isotc211.org/2005/gmd"
										xmlns:gco="http://www.isotc211.org/2005/gco"
										xmlns:gml="http://www.opengis.net/gml"
										xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
										xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
										exclude-result-prefixes="gmd gco gml xsi">

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="SpatRepTypes">
	<!-- sequence 0..n de SpatRepTypes dont dérivent les types ci-dessous -->
		<xsl:for-each select="gmd:MD_GridSpatialRepresentation">
			<GridSpatRep>
				<xsl:apply-templates select="." mode="GridSpatRep"/>
			</GridSpatRep>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:MD_Georectified">
			<Georect>
				<xsl:apply-templates select="." mode="Georect"/>
			</Georect>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:MD_Georeferenceable"> <!-- TOTEST -->
			<Georef>
				<xsl:apply-templates select="." mode="Georef"/>
			</Georef>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:MD_VectorSpatialRepresentation"> <!-- TOTEST -->
			<VectSpatRep>
				<xsl:apply-templates select="." mode="VectSpatRep"/>
			</VectSpatRep>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->
	<!-- === GridSpatRep === -->
	<!-- ============================================================================= -->

	<xsl:template match="*" mode="GridSpatRep">

		<numDims><!--1..1-->
			<xsl:value-of select="gmd:numberOfDimensions/gco:Integer"/>
		</numDims>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<axDimProps><!--1..1-->
			<xsl:for-each select="gmd:axisDimensionProperties">
				<Dimen><!--0..n-->
						<xsl:apply-templates select="gmd:MD_Dimension" mode="DimensionProps"/>
				</Dimen>
			</xsl:for-each>
		</axDimProps>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<cellGeo><!--1..1-->
			<CellGeoCd value="{gmd:cellGeometry/gmd:MD_CellGeometryCode/@codeListValue}" />
		</cellGeo>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<tranParaAv><!--1..1-->
			<xsl:value-of select="gmd:transformationParameterAvailability/gco:Boolean"/>
		</tranParaAv>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="DimensionProps">

		<dimName><!--1..1-->
			<DimNameTypCd value="{gmd:dimensionName/gmd:MD_DimensionNameTypeCode/@codeListValue}" />
		</dimName>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<dimSize><!--1..1-->
			<xsl:value-of select="gmd:dimensionSize/gco:Integer"/>
		</dimSize>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:resolution">
			<dimResol><!--0..1-->
					<xsl:apply-templates select="." mode="Measure"/>
			</dimResol>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="Measure">   <!-- TODO ATTENTION -->
	
	<!-- migrate iso19139 >> le nom de l'unité de mesure suivie conversion to ISO puis valeur Decimale Entière ou réelle -->
	<!-- migrage iso19115 >>   parser la valeur de uom pour l'unité et la conversion 
			puis définir si Decimal ou Integer ou Reel pour l'affecter au champ correspondant -->

		<!--SILOGIC DELETED 
		<xsl:attribute name="uom">
				<xsl:value-of select="gmd:uom/*/gmd:uomName"/>,
				<xsl:value-of select="gmd:uom/*/gmd:conversionToISOstandardUnit"/>
		</xsl:attribute>

		<xsl:value-of select="gmd:value/Decimal"/>
		<xsl:value-of select="gmd:value/Integer"/>
		<xsl:value-of select="gmd:value/Real"/> -->
		
		<!-- SILOGIC ADDED -->
		<!-- ATTENTION Le champ uom/conversionToISOstandardUnit n'est pas connu dans la 19139 du moins au niveau MD_Metadata / Measure-->
		<xsl:if test="gco:Measure"><!-- possible car non abstract -->
			<value>
				<Real><xsl:value-of select="gco:Measure"/></Real>
			</value>
			<uom>
				<UomMeasure>
					<uomName>
						<xsl:value-of select="gco:Measure/@uom"/>				
					</uomName>									
					<conversionToISOstandardUnit></conversionToISOstandardUnit>												
				</UomMeasure>
			</uom>
		</xsl:if>
		
		<xsl:if test="gco:Scale">
			<value>
				<Real><xsl:value-of select="gco:Scale"/></Real>
			</value>
			<uom>
				<UomScale>
					<uomName>				
						<xsl:value-of select="gco:Scale/@uom"/>				
					</uomName>
					<conversionToISOstandardUnit></conversionToISOstandardUnit>							
				</UomScale>
			</uom>
		</xsl:if>
		
		<xsl:if test="gco:Distance">
			<value>
				<Real><xsl:value-of select="gco:Distance"/></Real>
			</value>
			<uom>
				<UomDistance>
					<uomName>
						<xsl:value-of select="gco:Distance/@uom"/>				
					</uomName>														
					<conversionToISOstandardUnit></conversionToISOstandardUnit>							
				</UomDistance>
			</uom>
		</xsl:if>

		<xsl:if test="gco:Angle">
			<value>
				<Real><xsl:value-of select="gco:Angle"/></Real>
			</value>
			<uom>
				<UomAngle>
					<uomName>				
						<xsl:value-of select="gco:Angle/@uom"/>				
					</uomName>															
					<conversionToISOstandardUnit></conversionToISOstandardUnit>												
				</UomAngle>
			</uom>
		</xsl:if>

		<xsl:if test="gco:Length">
			<value>
				<Real><xsl:value-of select="gco:Length"/></Real>
			</value>
			<uom>
				<UomLength>
					<uomName>
						<xsl:value-of select="gco:Length/@uom"/>
					</uomName>
					<conversionToISOstandardUnit></conversionToISOstandardUnit>												
				</UomLength>
			</uom>
		</xsl:if>

	</xsl:template>

	<!-- ============================================================================= -->
	<!-- === Georect === -->
	<!-- ============================================================================= -->

	<xsl:template match="*" mode="Georect">

		<xsl:apply-templates select="*" mode="GridSpatRep"/>

		<chkPtAv><!--1..1-->
			<xsl:value-of select="gmd:checkPointAvailability/gco:Boolean"/>
		</chkPtAv>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:checkPointDescription">
			<chkPtDesc><!--0..1-->
				<xsl:value-of select="gco:CharacterString"/>
			</chkPtDesc>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:cornerPoints">
			<cornerPts><!--0..n-->
				<xsl:apply-templates select="gml:Point" mode="PointType"/>
			</cornerPts>
		</xsl:for-each>							

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:centerPoint">
			<centerPt><!--0..1-->
					<xsl:apply-templates select="gml:Point" mode="PointType"/>
			</centerPt>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<ptInPixel><!--1..1-->
			<PixOrientCd value="{gmd:pointInPixel/gmd:MD_PixelOrientationCode}"/>
		</ptInPixel>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:transformationDimensionDescription">
			<transDimDesc><!--0..1-->
				<xsl:value-of select="gco:CharacterString"/>
			</transDimDesc>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:transformationDimensionMapping">
			<transDimMap><!--0..n-->
				<xsl:value-of select="gco:CharacterString"/>
			</transDimMap>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="PointType">

		<coordinates>
	
			<xsl:if test="gml:coordinates/@ts">
				<xsl:attribute name="tupleSep">
					<xsl:choose>
						<xsl:when test="gml:coordinates/@ts = ' '" >'space'</xsl:when>
						<xsl:when test="gml:coordinates/@ts = ','" >'comma'</xsl:when>
						<xsl:when test="gml:coordinates/@ts = '.'">'period'</xsl:when>
					</xsl:choose>
				</xsl:attribute>
			</xsl:if>
	
			<xsl:if test="gml:coordinates/@cs">
				<xsl:attribute name="coordSep">
					<xsl:choose>
						<xsl:when test="gml:coordinates/@cs = ' '" >'space'</xsl:when>
						<xsl:when test="gml:coordinates/@cs = ','" >'comma'</xsl:when>
						<xsl:when test="gml:coordinates/@cs = '.'">'period'</xsl:when>
					</xsl:choose>
				</xsl:attribute>
			</xsl:if>
			
			<xsl:if test="gml:coordinates/@decimal">
				<xsl:attribute name="decimalChar">
					<xsl:choose>
						<xsl:when test="gml:coordinates/@decimal = ' '" >'space'</xsl:when>
						<xsl:when test="gml:coordinates/@decimal = ','" >'comma'</xsl:when>
						<xsl:when test="gml:coordinates/@decimal = '.'">'period'</xsl:when>
					</xsl:choose>
				</xsl:attribute>
			</xsl:if>	
		
			<xsl:value-of select="."/>

		</coordinates>
	</xsl:template>

	<!-- ============================================================================= -->
	<!-- === Georef === -->
	<!-- ============================================================================= -->

	<xsl:template match="*" mode="Georef">

		<xsl:apply-templates select="*" mode="GridSpatRep"/>

		<ctrlPtAv><!--1..1-->
			<xsl:value-of select="gmd:controlPointAvailability/gco:Boolean"/>
		</ctrlPtAv>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<orieParaAv><!--1..1-->
			<xsl:value-of select="gmd:orientationParameterAvailability/gco:Boolean"/>
		</orieParaAv>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:orientationParameterDescription">
			<orieParaDesc><!--0..1-->
				<xsl:value-of select="gco:CharacterString"/>
			</orieParaDesc>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<georefPars><!--1..1-->
			<xsl:value-of select="gmd:georeferencedParameters/gco:Record"/>
		</georefPars>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:parameterCitation">
			<paraCit><!--0..n-->
					<xsl:apply-templates select="gmd:CI_Citation" mode="Citation"/>
			</paraCit>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->
	<!-- === VectSpatRep === -->
	<!-- ============================================================================= -->

	<xsl:template match="*" mode="VectSpatRep">

		<xsl:for-each select="gmd:topologyLevel">
			<topLvl><!--0..1-->
				<TopoLevCd value="{gmd:MD_TopologyLevelCode/@codeListValue}" />
			</topLvl>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:geometricObjects">
			<geometObjs><!--0..n-->
					<xsl:apply-templates select="gmd:MD_GeometricObjects" mode="GeometObjs"/>
			</geometObjs>
		</xsl:for-each>
	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="GeometObjs">

		<geoObjTyp><!--1..1--> <!-- ATTENTION Constantes en dur > utilisation uniquement des constantes définies dans le schéma 19115=19139-->
			<GeoObjTypCd>
				<xsl:attribute name="value">
<!--				
					<xsl:choose>
						<xsl:when test="gmd:geometricObjectType/gmd:MD_GeometricObjectTypeCode/@codeListValue = 'complex'">complexes</xsl:when>
						<xsl:when test="gmd:geometricObjectType/gmd:MD_GeometricObjectTypeCode/@codeListValue = 'composite'">composites</xsl:when>
						<xsl:otherwise>
-->
							<xsl:value-of select="gmd:geometricObjectType/gmd:MD_GeometricObjectTypeCode/@codeListValue"/>
<!--
						</xsl:otherwise>
					</xsl:choose>
-->
				</xsl:attribute>
			</GeoObjTypCd>
		</geoObjTyp>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:geometricObjectCount">
			<geoObjCnt><!--0..1-->
				<xsl:value-of select="gco:Integer"/>
			</geoObjCnt>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->

</xsl:stylesheet>
