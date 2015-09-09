<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:fra="http://www.cnig.gouv.fr/2005/fra" 
										xmlns:gmd="http://www.isotc211.org/2005/gmd"
										xmlns:gco="http://www.isotc211.org/2005/gco"
										xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
										xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<!-- ============================================================================= -->

	<xsl:template match="*" mode="AppSchInfo">

		<gmd:name>
			<gmd:CI_Citation>
				<xsl:apply-templates select="asName" mode="Citation"/>
			</gmd:CI_Citation>
		</gmd:name>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<gmd:schemaLanguage>
			<gco:CharacterString><xsl:value-of select="asSchLang"/></gco:CharacterString>
		</gmd:schemaLanguage>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<gmd:constraintLanguage>
			<gco:CharacterString><xsl:value-of select="asCstLang"/></gco:CharacterString>
		</gmd:constraintLanguage>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="asAscii">
			<gmd:schemaAscii>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:schemaAscii>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="asGraFile"> <!-- Modifié SILOGIC -->
			<gmd:graphicsFile>
				<gco:Binary>
					<gmd:src>
						<xsl:value-of select="."/>
					</gmd:src>
				</gco:Binary>
			</gmd:graphicsFile>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="asSwDevFile">  <!-- Modifié SILOGIC -->
			<gmd:softwareDevelopmentFile>
				<gco:Binary>
					<gmd:src>
						<xsl:value-of select="."/>
					</gmd:src>
				</gco:Binary>
			</gmd:softwareDevelopmentFile>
		</xsl:for-each>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:for-each select="asSwDevFiFt">
			<gmd:softwareDevelopmentFileFormat>
				<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
			</gmd:softwareDevelopmentFileFormat>
		</xsl:for-each>

	</xsl:template>

	<!-- ============================================================================= -->

</xsl:stylesheet>
