<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:gmd="http://www.isotc211.org/2005/gmd"
										xmlns:gco="http://www.isotc211.org/2005/gco"
										xmlns:gmx="http://www.isotc211.org/2005/gmx"
										xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
										xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
									     xmlns:xlink="http://www.w3.org/1999/xlink" 
										exclude-result-prefixes="gmd gco gmx xsi xlink">

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="RefSystemTypes">
		<!-- abstract => impossible -->
        <!-- Dans le PROFIL FRANCAIS, la cardinalité vaut 1, on garde le for-each pour les autres -->
		<xsl:for-each select="gmd:referenceSystemIdentifier/gmd:RS_Identifier"> 
			<RefSystem>
				<refSysID>
					<xsl:apply-templates select="." mode="RSIdent"/>
				</refSysID>
			</RefSystem>
		</xsl:for-each>

	</xsl:template>	

	<!-- ============================================================================= -->
	
	<xsl:template match="*" mode="DirectRefSystemTypes">

        <!-- Dans le PROFIL FRANCAIS, la cardinalité vaut 1, on garde le for-each pour les autres -->
		<DirectReferenceSystem><!--1..1-->
			<refSysID><!--1..1-->
					<xsl:if test="not(gmd:referenceSystemIdentifier/gmd:RS_Identifier)">
						<identCode/>
					</xsl:if>
					<xsl:apply-templates select="gmd:referenceSystemIdentifier/gmd:RS_Identifier" mode="RSIdent"/>
			</refSysID>			
		</DirectReferenceSystem>			

	</xsl:template>	

	<!-- ============================================================================= -->
	
		<xsl:template match="*" mode="IndirectRefSystemTypes">

        <!-- Dans le PROFIL FRANCAIS, la cardinalité vaut 1, on garde le for-each pour les autres -->
		<InDirectReferenceSystem><!--1..1-->
			<refSysID><!--1..1-->
					<xsl:if test="not(gmd:referenceSystemIdentifier/gmd:RS_Identifier)">
						<identCode/>
					</xsl:if>
					<xsl:apply-templates select="gmd:referenceSystemIdentifier/gmd:RS_Identifier" mode="RSIdent"/>
			</refSysID>			
		</InDirectReferenceSystem>

	</xsl:template>	

	<!-- ============================================================================= -->
	
	<xsl:template match="*" mode="RSIdent">

		<xsl:for-each select="gmd:authority">
			<identAuth><!--0..1-->
				<xsl:apply-templates select="gmd:CI_Citation" mode="Citation"/>
			</identAuth>
		</xsl:for-each>

		<identCode><!--1..1-->
			<xsl:if test="gmd:code/gco:CharacterString">
				<code><!--1..1-->
					<xsl:value-of select="gmd:code/gco:CharacterString"/>
				</code>
			</xsl:if>
			<xsl:if test="gmd:code/gmx:Anchor">
				<code><!--1..1-->
					<xsl:choose>
						<xsl:when test="contains(gmd:code/gmx:Anchor/@xlink:href,'#')">
							<xsl:value-of select="substring-after(gmd:code/gmx:Anchor/@xlink:href,'#')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="gmd:code/gmx:Anchor/@xlink:href" />
						</xsl:otherwise>
					</xsl:choose>
				</code>
				<label><!--0..1-->
					<xsl:value-of select="gmd:code/gmx:Anchor"/>
				</label>
			</xsl:if>
		</identCode>
		
		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:if test="gmd:codeSpace">
			<codeSpace><!--0..1-->
				<xsl:value-of select="gmd:codeSpace/gco:CharacterString"/>
			</codeSpace>
		</xsl:if>

		<xsl:if test="gmd:version">
			<version><!--0..1-->
				<xsl:value-of select="gmd:version/gco:CharacterString"/>
			</version>
		</xsl:if>

	</xsl:template>

	<!-- ============================================================================= -->	

</xsl:stylesheet>
