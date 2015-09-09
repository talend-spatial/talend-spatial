<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:gmd="http://www.isotc211.org/2005/gmd"
										xmlns:gco="http://www.isotc211.org/2005/gco"
										xmlns:gml="http://www.opengis.net/gml"
										xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
										xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
										exclude-result-prefixes="gmd gco gml xsi" >

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="Extent">

		<xsl:for-each select="gmd:description">
			<exDesc><!--0..1-->
				<xsl:value-of select="gco:CharacterString"/>
			</exDesc>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:verticalElement">
			<vertEle><!--0..n-->
					<xsl:apply-templates select="gmd:EX_VerticalExtent" mode="VertExtent"/>
			</vertEle>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:temporalElement">
			<tempEle><!--0..n-->
				<xsl:apply-templates select="." mode="TempExtentTypes"/>
			</tempEle>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:geographicElement">
			<geoEle><!--0..n-->
				<xsl:apply-templates select="." mode="GeoExtentTypes"/>
			</geoEle>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->
	<!-- === GeoExtentTypes === -->
	<!-- ============================================================================= -->

	<xsl:template match="*" mode="GeoExtentTypes">
		<!-- séquence 0..n GeoExtentTypes dont dérivent les types ci-dessous -->
		
		<xsl:for-each select="gmd:EX_BoundingPolygon">
			<!-- ATTENTION MAPPING INCOMPLET ? - En 19139 plusieurs descriptions de polygone possibles autre que gml:polygon (cf GM_Object_PropertyType) -->
			<BoundPoly>
				<xsl:apply-templates select="." mode="BoundPoly"/>
			</BoundPoly>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:EX_GeographicDescription">
			<GeoDesc>
				<xsl:apply-templates select="." mode="GeoDesc"/>
			</GeoDesc>
		</xsl:for-each>
		
		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
		
		<xsl:for-each select="gmd:EX_GeographicBoundingBox"> <!-- ADDED SILOGIC -->
			<GeoBndBox>
				<xsl:apply-templates select="." mode="GeoBndBox"/>
			</GeoBndBox>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="BoundPoly">

		<xsl:for-each select="gmd:extentTypeCode">
			<exTypeCode><!--0..1-->
				<xsl:value-of select="gco:Boolean"/>
			</exTypeCode>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:polygon">
			<polygon><!--1..n-->
				<xsl:apply-templates select="." mode="GM_Polygon"/>
			</polygon>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->
	

	<xsl:template match="*" mode="GeoBndBox"> <!-- ADDED SILOGIC -->

		<xsl:for-each select="gmd:extentTypeCode">
			<exTypeCode><!--0..1-->
				<xsl:value-of select="gco:Boolean"/>
			</exTypeCode>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
		
		<xsl:apply-templates select="." mode="GeoBox"/>

	</xsl:template>
	
	<!-- ============================================================================= -->	
	
	<xsl:template match="*" mode="GeoBox">
			<westBL><xsl:value-of select="gmd:westBoundLongitude/gco:Decimal"/></westBL>
			<eastBL><xsl:value-of select="gmd:eastBoundLongitude/gco:Decimal"/></eastBL>
			<southBL><xsl:value-of select="gmd:southBoundLatitude/gco:Decimal"/></southBL>
			<northBL><xsl:value-of select="gmd:northBoundLatitude/gco:Decimal"/></northBL>
	</xsl:template>

	
	<!-- ============================================================================= -->

	<xsl:template match="*" mode="GeoDesc">

		<xsl:for-each select="gmd:extentTypeCode">
			<exTypeCode><!--0..1-->
				<xsl:value-of select="gco:Boolean"/>
			</exTypeCode>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<geoId><!-- 1..1-->
			<xsl:apply-templates select="gmd:geographicIdentifier/gmd:MD_Identifier" mode="MdIdent"/>
		</geoId>			

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="MdIdent">

		<xsl:for-each select="gmd:authority">
			<identAuth><!--0..1-->
				<xsl:apply-templates select="gmd:CI_Citation" mode="Citation"/>
			</identAuth>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<identCode> <!--1..1-->
			<code>
				<xsl:value-of select="gmd:code/gco:CharacterString"/>
			</code>
		</identCode>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="GM_Polygon">

		<xsl:for-each select="gml:Polygon"> <!-- SILOGIC ATTENTION - MAPPING INCOMPLET -->
			<!--  plusieurs descriptions de polygon possibles et pour la 19115 plusieurs curveMember -> modification schéma pour avoir plusieurs points -->
			<GM_Polygon>
				<xsl:for-each select="gml:exterior/gml:Ring/gml:curveMember">
					<xsl:apply-templates select="gml:LineString" mode="PointType"/>
				</xsl:for-each>
			</GM_Polygon>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->
	<!-- === TempExtentTypes === -->
	<!-- ============================================================================= -->

	<xsl:template match="*" mode="TempExtentTypes">
		<!-- Sequence 0..n de TempExtentTypes dont héritent les types ci-dessous -->
		<xsl:for-each select="gmd:EX_TemporalExtent">
			<TempExtent>
				<xsl:apply-templates select="." mode="TemporalExtent"/>
			</TempExtent>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gmd:EX_SpatialTemporalExtent">
			<SpatTempEx>
				<xsl:apply-templates select="." mode="SpatialTempExtent"/>
			</SpatTempEx>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="TemporalExtent">

		<exTemp> <!--1..1-->
			<TM_GeometricPrimitive>
				<xsl:apply-templates select="gmd:extent" mode="TM_Primitive"/>
			</TM_GeometricPrimitive>
		</exTemp>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="TM_Primitive"><!-- ATTENTION gml -->

		<xsl:for-each select="gml:TimeInstant">
			<TM_Instant>
				<tmPosition>
					<xsl:apply-templates select="gml:timePosition" mode="TM_PositionTypes"/>
				</tmPosition>
			</TM_Instant>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="gml:TimePeriod">
			<TM_Period><!--1..1-->
				<begin><xsl:value-of select="gml:beginPosition"/></begin>
				<end><xsl:value-of select="gml:endPosition"/></end>
			</TM_Period>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->
	<!-- ATTN: Rough conversion without data loss -->

	<xsl:template match="*" mode="TM_PositionTypes"> <!-- ATTENTION SILOGIC -->
<!-->> iso19139 en fonction de l'élément renseigné -->
			<!-- >> iso19115 en fonction du type date,  heure ou date heure positionnement dans le champ qui va bien -->
		<xsl:for-each select=".">
			<!-- ATTENTION Systématiquement en DateAndTime pour éviter les conversions complexes et la perte de précision -->
			<TM_DateAndTime>
				<calDate>
					<xsl:value-of select="gml:calDate"/>
				</calDate>
			</TM_DateAndTime>

		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="SpatialTempExtent">

		<xsl:apply-templates select="." mode="TemporalExtent"/>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="spatialExtent">
			<exSpat>
				<xsl:apply-templates select="." mode="GeoExtentTypes"/>
			</exSpat>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->
	<!-- === VertExtend === -->
	<!-- ============================================================================= -->

	<xsl:template match="*" mode="VertExtent">

		<vertMinVal> <!--1..1-->
			<xsl:value-of select="gmd:minimumValue/gco:Real"/>
		</vertMinVal>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<vertMaxVal><!--1..1-->
			<xsl:value-of select="gmd:maximumValue/gco:Rea"/>
		</vertMaxVal>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<vertCRS><!--1..1--><!-- ATTENTION  SILOGIC MAPPING INCOMPLET -->
			<datumID>
				<identCode/>
			</datumID>
		</vertCRS>
	</xsl:template>

	<!-- ============================================================================= -->

</xsl:stylesheet>
