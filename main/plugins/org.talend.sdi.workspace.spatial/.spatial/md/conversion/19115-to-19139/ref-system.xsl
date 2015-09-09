<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:fra="http://www.cnig.gouv.fr/2005/fra" 
										xmlns:gmd="http://www.isotc211.org/2005/gmd"
										xmlns:gco="http://www.isotc211.org/2005/gco"
										xmlns:gmx="http://www.isotc211.org/2005/gmx"										
										xmlns:xlink="http://www.w3.org/1999/xlink"
										xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
										xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="RefSystemTypes">

		<!-- Dans le PROFIL FRANCAIS, la cardinalité vaut 1, on garde le for-each pour les autres -->
		<xsl:for-each select="refSysID"> <!--- AU LIEU DE RefSystem/refSysID (Vérifier qu'il n'est utilisé que dans le fichier principal) -->
			<gmd:referenceSystemIdentifier>
				<gmd:RS_Identifier>
					<xsl:apply-templates select="." mode="RSIdent"/>
				</gmd:RS_Identifier>
			</gmd:referenceSystemIdentifier>
		</xsl:for-each>

	</xsl:template>
	
	<!-- ============================================================================= -->
	
	<xsl:template match="*" mode="DirectRefSystemTypes">

		<!-- Dans le PROFIL FRANCAIS, la cardinalité vaut 1, on garde le for-each pour les autres -->
		<xsl:for-each select="refSysID">
			<fra:FRA_IndirectReferenceSystem gco:isoType="MD_ReferenceSystem">
				<gmd:RS_Identifier>
					<xsl:apply-templates select="." mode="RSIdent"/>
				</gmd:RS_Identifier>
			</fra:FRA_IndirectReferenceSystem>
		</xsl:for-each>

	</xsl:template>
	
	<!-- ============================================================================= -->	
	
	<xsl:template match="*" mode="IndirectRefSystemTypes">

		<!-- Dans le PROFIL FRANCAIS, la cardinalité vaut 1, on garde le for-each pour les autres -->
		<xsl:for-each select="refSysID">
			<fra:FRA_DirectReferenceSystem gco:isoType="MD_ReferenceSystem">
				<gmd:RS_Identifier>
					<xsl:apply-templates select="." mode="RSIdent"/>
				</gmd:RS_Identifier>
			</fra:FRA_DirectReferenceSystem>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->
	
	<xsl:template match="*" mode="RSIdent">

		<xsl:for-each select="identAuth">
			<gmd:authority>
				<gmd:CI_Citation>
					<xsl:apply-templates select="." mode="Citation"/>
				</gmd:CI_Citation>
			</gmd:authority>
		</xsl:for-each>

		<gmd:code>
			<xsl:if test="identCode/label">
				<gmx:Anchor xlink:href="{identCode/code}">
					<xsl:value-of select="identCode/label"/>
				</gmx:Anchor>
			</xsl:if>
			<xsl:if test="not(identCode/label)">
				<gco:CharacterString><xsl:value-of select="identCode/code"/></gco:CharacterString>
			</xsl:if>
		</gmd:code>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->		
					
		<xsl:for-each select="codeSpace"> <!-- Rajouté par SILOGIC -->
			<gmd:codeSpace>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:codeSpace>
		</xsl:for-each>
		
		<xsl:for-each select="version"> <!-- Rajouté par SILOGIC -->
			<gmd:version>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:version>
		</xsl:for-each>
		
	</xsl:template>	
	
	<!-- ============================================================================= -->

</xsl:stylesheet>
