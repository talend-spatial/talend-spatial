<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<!-- ============================================================================= -->

	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />
	
	<!-- ============================================================================= -->

	<xsl:template match="/">
		<result>
			<xsl:apply-templates select="*"/>
		</result>
	</xsl:template>

	<!-- ============================================================================= -->
	<!-- === Metadata/appSchInfo === -->
	<!-- ============================================================================= -->

	<xsl:template match="*/appSchInfo/fetCatSup">
		<element class="not mapped">
			<xsl:copy-of select="."/>
		</element>
	</xsl:template>
	
	<!-- ============================================================================= -->
	<!-- === Metadata/dqInfo === -->
	<!-- ============================================================================= -->

	<!-- WAS EVER DELETED in schema 19115 -->
	<xsl:template match="*/srcRefSys/MdCoRefSys">
		<element class="not mapped">
			<xsl:copy-of select="."/>
		</element>
	</xsl:template>
	
	<!-- ============================================================================= -->

	<xsl:template match="*/measResult/Result">
		<xsl:if test="string(.) != ''">
			<element class="not mapped">
				<xsl:copy-of select="."/>
			</element>
		</xsl:if>
	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*/QuanResult/quanValUnit">
		<element class="rough mapping, no data loss">
			<xsl:copy-of select="."/>
		</element>
		<xsl:apply-templates select="*"/>
	</xsl:template>

	<!-- ============================================================================= -->
	<!-- === Metadata/contInfo === -->
	<!-- ============================================================================= -->

	<!--SILOGIC setted ContInfo to abstract in schema 19115 -->
	<xsl:template match="*/contInfo/ContInfo">
		<element class="not mapped">
			<xsl:copy-of select="."/>
		</element>
	</xsl:template>
	
	<!-- ============================================================================= -->

	<!--SILOGIC deleted scope in schema 19115 -->
	<xsl:template match="*/seqID/scope">
		<element class="not mapped">
			<xsl:copy-of select="."/>
		</element>
	</xsl:template>
	
	<!-- ============================================================================= -->

	<!--SILOGIC deleted scope in schema 19115 -->
	<xsl:template match="*/attributeType/scope">
		<element class="not mapped">
			<xsl:copy-of select="."/>
		</element>
	</xsl:template>
	
	<!-- ============================================================================= -->

	<xsl:template match="*/conversionToISOstandarUnit">
		<xsl:if test="string(.) != ''">
			<element class="not mapped">
				<xsl:copy-of select="."/>
			</element>
		</xsl:if>
	</xsl:template>
	
	<!-- ============================================================================= -->

	<xsl:template match="*/catFetTypes/MemberName | */catFetTypes/TypeName">
		<element class="not mapped">
			<xsl:copy-of select="."/>
		</element>
	</xsl:template>
	
	<!-- ============================================================================= -->
	<!-- === Metadata/spatRepInfo === -->	
	<!-- ============================================================================= -->

	<xsl:template match="*/Dimen/dimResol">
		<element class="rough mapping, no data loss">
			<xsl:copy-of select="."/>
		</element>
		<xsl:apply-templates select="*"/>
	</xsl:template>

	<!-- ============================================================================= -->
	<!-- WAS EVER DELETED in schema 19115 -->
	<xsl:template match="*/cornerPts/MdCoRefSys">
		<element class="not mapped">
			<xsl:copy-of select="."/>
		</element>
	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*/coordinates/@dimension | */coordinates/@precision">
		<element class="not mapped">
			<xsl:copy-of select="."/>
		</element>
	</xsl:template>
	
	<!-- ============================================================================= -->
	<!-- === Metadata/dataIdInfo === -->
	<!-- ============================================================================= -->

	<xsl:template match="*/citIdType">
		<element class="not mapped">
			<xsl:copy-of select="."/>
		</element>
	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*/designator | */timeIndicator">
		<element class="not mapped">
			<xsl:copy-of select="."/>
		</element>
	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*/dataScale/scaleDist">
		<element class="rough mapping, no data loss">
			<xsl:copy-of select="."/>
		</element>
		<xsl:apply-templates select="*"/>
	</xsl:template>

	<!-- ============================================================================= -->
	<!-- === Extent === -->
	<!-- ============================================================================= -->

	<xsl:template match="*/vertEle/vertUoM | */vertEle/vertDatum">
		<element class="not mapped">
			<xsl:copy-of select="."/>
		</element>
	</xsl:template>

	<!-- ============================================================================= -->

	<xsl:template match="*/TM_Instant/tmPosition">
		<element class="rough mapping, no data loss">
			<xsl:copy-of select="."/>
		</element>
	</xsl:template>

	<!-- ============================================================================= -->
	<!-- WAS EVER DELETED in schema 19115 -->
	<xsl:template match="*/GM_Polygon/MdCoRefSys">
		<element class="not mapped">
			<xsl:copy-of select="."/>
		</element>
	</xsl:template>

	<!-- ============================================================================= -->
	<!-- === (default) === -->
	<!-- ============================================================================= -->

	<xsl:template match="*">
		<xsl:apply-templates select="*" />
	</xsl:template>

	<!-- ============================================================================= -->

</xsl:stylesheet>
