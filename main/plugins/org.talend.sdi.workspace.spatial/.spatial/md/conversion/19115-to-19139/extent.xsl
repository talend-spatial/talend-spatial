<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:fra="http://www.cnig.gouv.fr/2005/fra" 
										xmlns:gmd="http://www.isotc211.org/2005/gmd"
										xmlns:gco="http://www.isotc211.org/2005/gco"
										xmlns:gml="http://www.opengis.net/gml"
										xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
										xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
										
	<!-- ============================================================================= -->

	<xsl:template match="*" mode="Extent">

		<xsl:for-each select="exDesc">
			<gmd:description>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:description>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="geoEle">
			<gmd:geographicElement>
				<xsl:apply-templates select="." mode="GeoExtentTypes"/>
			</gmd:geographicElement>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="tempEle">
			<gmd:temporalElement>
				<xsl:apply-templates select="." mode="TempExtentTypes"/>
			</gmd:temporalElement>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="vertEle">
			<gmd:verticalElement>
				<gmd:EX_VerticalExtent>
					<xsl:apply-templates select="." mode="VertExtent"/>
				</gmd:EX_VerticalExtent>
			</gmd:verticalElement>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->
	<!-- === GeoExtentTypes === -->
	<!-- ============================================================================= -->

	<xsl:template match="*" mode="GeoExtentTypes">

		<xsl:for-each select="BoundPoly">
			<gmd:EX_BoundingPolygon>
				<xsl:apply-templates select="." mode="BoundPoly"/>
			</gmd:EX_BoundingPolygon>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="GeoDesc">
			<gmd:EX_GeographicDescription>
				<xsl:apply-templates select="." mode="GeoDesc"/>
			</gmd:EX_GeographicDescription>
		</xsl:for-each>
		
		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
		
		<xsl:for-each select="GeoBndBox"> <!-- ADD SILOGIC -->
			<gmd:EX_GeographicBoundingBox>
				<xsl:apply-templates select="." mode="GeoBndBox"/>
			</gmd:EX_GeographicBoundingBox>
		</xsl:for-each>		

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="BoundPoly">

		<xsl:for-each select="exTypeCode">
			<gmd:extentTypeCode>
				<gco:Boolean><xsl:value-of select="."/></gco:Boolean>
			</gmd:extentTypeCode>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="polygon">
			<gmd:polygon>
				<xsl:apply-templates select="." mode="GM_Polygon"/>
			</gmd:polygon>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="GeoBndBox"> <!-- ADD SILOGIC -->

		<xsl:for-each select="exTypeCode">
			<gmd:extentTypeCode>
				<gco:Boolean><xsl:value-of select="."/></gco:Boolean>
			</gmd:extentTypeCode>
		</xsl:for-each>

		<xsl:apply-templates select="." mode="GeoBox" />

	</xsl:template>
	
	<!-- ============================================================================= -->
	
	<xsl:template match="*" mode="GeoBox"> <!-- SILOGIC Factorisation -->
	
		<gmd:westBoundLongitude>
			<gco:Decimal><xsl:value-of select="westBL"/></gco:Decimal>
		</gmd:westBoundLongitude>
		<gmd:eastBoundLongitude>
			<gco:Decimal><xsl:value-of select="eastBL"/></gco:Decimal>
		</gmd:eastBoundLongitude>
		<gmd:southBoundLatitude>
			<gco:Decimal><xsl:value-of select="southBL"/></gco:Decimal>
		</gmd:southBoundLatitude>
		<gmd:northBoundLatitude>
			<gco:Decimal><xsl:value-of select="northBL"/></gco:Decimal>
		</gmd:northBoundLatitude>	

	</xsl:template>

	<!-- ============================================================================= -->


	<xsl:template match="*" mode="GeoDesc">

		<xsl:for-each select="exTypeCode">
			<gmd:extentTypeCode>
				<gco:Boolean><xsl:value-of select="."/></gco:Boolean>
			</gmd:extentTypeCode>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="geoId">
			<gmd:geographicIdentifier>
				<gmd:MD_Identifier>
					<xsl:apply-templates select="." mode="MdIdent"/>
				</gmd:MD_Identifier>
			</gmd:geographicIdentifier>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="MdIdent">

		<xsl:for-each select="identAuth">
			<gmd:authority>
				<gmd:CI_Citation>
					<xsl:apply-templates select="." mode="Citation"/>
				</gmd:CI_Citation>
			</gmd:authority>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<gmd:code>
			<gco:CharacterString><xsl:value-of select="identCode/code"/></gco:CharacterString>
		</gmd:code>

	</xsl:template>
	
	<!-- ============================================================================= -->

	<xsl:template match="*" mode="GM_Polygon">

		<xsl:for-each select="GM_Polygon">
			<gml:Polygon>
				<gml:exterior>
					<gml:Ring>
						<gml:curveMember>
							<gml:LineString>
								<xsl:apply-templates select="." mode="PointType"/>
							</gml:LineString>
						</gml:curveMember>
					</gml:Ring>
				</gml:exterior>
			</gml:Polygon>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->
	<!-- === TempExtentTypes === -->
	<!-- ============================================================================= -->

	<xsl:template match="*" mode="TempExtentTypes">

		<xsl:for-each select="TempExtent">
			<gmd:EX_TemporalExtent>
				<xsl:apply-templates select="." mode="TemporalExtent"/>
			</gmd:EX_TemporalExtent>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="SpatTempEx">
			<gmd:EX_SpatialTemporalExtent>
				<xsl:apply-templates select="." mode="SpatialTempExtent"/>
			</gmd:EX_SpatialTemporalExtent>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="TemporalExtent">

		<gmd:extent>
			<xsl:apply-templates select="exTemp/TM_GeometricPrimitive" mode="TM_Primitive"/>
		</gmd:extent>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="TM_Primitive">

		<xsl:for-each select="TM_Instant">
			<gml:TimeInstant>
				<gml:timePosition>
					<xsl:apply-templates select="tmPosition" mode="TM_PositionTypes"/>
				</gml:timePosition>
			</gml:TimeInstant>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="TM_Period">
			<gml:TimePeriod>
				<gml:beginPosition><xsl:value-of select="begin"/></gml:beginPosition>
				<gml:endPosition><xsl:value-of select="end"/></gml:endPosition>
			</gml:TimePeriod>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->
	<!-- ATTN: Rough conversion without data loss -->

	<xsl:template match="*" mode="TM_PositionTypes">

		<xsl:for-each select="TM_CalDate/calDate"><xsl:value-of select="."/></xsl:for-each>
		<xsl:for-each select="TM_ClockTime/clkTime"><xsl:value-of select="."/></xsl:for-each>

		<xsl:for-each select="TM_DateAndTime">
			<xsl:value-of select="calDate"/> <xsl:value-of select="clkTime"/>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="SpatialTempExtent">

		<xsl:apply-templates select="." mode="TemporalExtent"/>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="exSpat">
			<gmd:spatialExtent>
				<xsl:apply-templates select="." mode="GeoExtentTypes"/>
			</gmd:spatialExtent>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->
	<!-- === VertExtend === -->
	<!-- ============================================================================= -->

	<xsl:template match="*" mode="VertExtent">

		<gmd:minimumValue>
			<gco:Real><xsl:value-of select="vertMinVal"/></gco:Real>
		</gmd:minimumValue>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<gmd:maximumValue>
			<gco:Real><xsl:value-of select="vertMaxVal"/></gco:Real>
		</gmd:maximumValue>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<gmd:verticalCRS></gmd:verticalCRS>
	</xsl:template>

	<!-- ============================================================================= -->

</xsl:stylesheet>
