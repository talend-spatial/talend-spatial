<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:fra="http://www.cnig.gouv.fr/2005/fra" xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gfc="http://www.isotc211.org/2005/gfc" xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gmi="http://www.isotc211.org/2005/gmi" xmlns:gmx="http://www.isotc211.org/2005/gmx" xmlns:gsr="http://www.isotc211.org/2005/gsr" xmlns:gss="http://www.isotc211.org/2005/gss" xmlns:gts="http://www.isotc211.org/2005/gts" xmlns:gml="http://www.opengis.net/gml" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="fra gmi gco gml gts gmd gfc gmd gmx gsr gss gts xlink xs xsi">

		<xsl:include href="resp-party.xsl"/>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:output method="xml" encoding="UTF-8" indent="yes"/>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->		
		
		<xsl:variable name="iso19115schema">../schemas/iso19115fra/schema.xsd</xsl:variable>
		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
		
			<xsl:template match="/">
				<xsl:apply-templates/>
			</xsl:template>
		
		<xsl:template match="gfc:FC_FeatureCatalogue">
			<xsl:apply-templates select="." mode="FeatureCatalogue"/>
		</xsl:template>
		
		<xsl:template match="fra:FRA_FeatureCatalogue">
			<xsl:apply-templates select="node()[local-name(.)!='FC_FeatureCatalogue' and local-name(.)!='FRA_FeatureCatalogue']"/>			
			<xsl:apply-templates select="." mode="FeatureCatalogue"/>
		</xsl:template>

	<xsl:template match="node()|@*" priority="-10">
		<!--xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy-->
	</xsl:template>

		<xsl:template match="*" mode="FeatureCatalogue">
			<FC_FeatureCatalogue>
				<!--xsl:attribute name="xsi:noNamespaceSchemaLocation">
					<xsl:value-of select="$iso19115schema"/>
				</xsl:attribute-->
   
				<gfc_name><!--1..1-->
					<xsl:value-of select="gmx:name/gco:CharacterString"/>
				</gfc_name>

				<gfc_scope><!--1..1-->
					<xsl:value-of select="gmx:scope/gco:CharacterString"/>
				</gfc_scope>

				<xsl:for-each select="gmx:fieldOfApplication">
					<gfc_fieldOfApplication><!--0..1-->
						<xsl:value-of select="gco:CharacterString"/>
					</gfc_fieldOfApplication>
				</xsl:for-each>

				<gfc_versionNumber><!--1..1-->
					<xsl:value-of select="gmx:versionNumber/gco:CharacterString"/>
				</gfc_versionNumber>

				<gfc_versionDate><!--1..1 Date ou DateTime -->
					<xsl:value-of select="gmx:versionDate/gco:Date"/>
					<xsl:value-of select="gmx:versionDate/gco:DateTime"/>
				</gfc_versionDate>

				 <gfc_language><!--0..1 valeur par défaut fra -->
					<xsl:choose>
						<xsl:when test="not(gmx:language/gmd:LanguageCode)">
							<languageCode value="fra"/>
						</xsl:when>
						<xsl:otherwise>
							<languageCode value="{gmx:language/gmd:LanguageCode/@codeListValue}" />
						</xsl:otherwise>
					</xsl:choose>
				</gfc_language>

				<characterSet><!--0..1 valeur par défaut utf8 -->
					<xsl:choose>
						<xsl:when test="not(gmx:characterSet/gmd:MD_CharacterSetCode)">
							<CharSetCd value="utf8"/>
						</xsl:when>
						<xsl:otherwise>
							<CharSetCd value="{gmx:characterSet/gmd:MD_CharacterSetCode/@codeListValue}"/>
						</xsl:otherwise>
					</xsl:choose>
				</characterSet>

				<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - -  -->
				<!-- fra ou gfc producer -->

				<xsl:if test="not(fra:producer) and not(gfc:producer)">
					<gfc_producer>
						<role>
							<RoleCd value="unknown"/>
						</role>
					</gfc_producer>
				</xsl:if>

				<xsl:for-each select="fra:producer">
					<!-- RespParty -->
					<gfc_producer>
						<xsl:apply-templates select="gmd:CI_ResponsibleParty" mode="RespParty"/> <!--resparty.xsl -->
					</gfc_producer>
				</xsl:for-each>

				<xsl:for-each select="gfc:producer">
					<!-- RespParty -->
					<gfc_producer>
						<xsl:apply-templates select="gmd:CI_ResponsibleParty" mode="RespParty"/> <!--resparty.xsl -->
					</gfc_producer>
				</xsl:for-each>
				
				<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - -  -->

				<functionalLanguage><!--0..1 valeur par défaut fra -->
					<xsl:if test="not(fra:functionalLanguage/gmd:LanguageCode/@codeListValue)  and not(gfc:functionalLanguage/gmd:LanguageCode/@codeListValue)">
						<languageCode value="fra"/>
					</xsl:if>

					<xsl:if test="fra:functionalLanguage/gmd:LanguageCode/@codeListValue">
						<languageCode value="{fra:functionalLanguage/gmd:LanguageCode/@codeListValue}"/>
					</xsl:if>

					<xsl:if test="gfc:functionalLanguage/gmd:LanguageCode/@codeListValue">
						<languageCode value="{gfc:functionalLanguage/gmd:LanguageCode/@codeListValue}"/>
					</xsl:if>						
				</functionalLanguage>

				<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
				<!-- fra ou gfc FeatureType -->

				<!-- FeatureType -->
				<xsl:for-each select="fra:featureType ">
					<xsl:apply-templates select="gfc:FC_FeatureType" mode="FeatureType"/> 
				</xsl:for-each>
				
				<!-- FeatureType -->
				<xsl:for-each select="gfc:featureType">
					<xsl:apply-templates select="gfc:FC_FeatureType" mode="FeatureType"/> 
				</xsl:for-each>				

			</FC_FeatureCatalogue>
		</xsl:template>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:template match="*" mode="FeatureType">
			<gfc_featureType>

				<gfc_typeName><!--1..1-->
					<xsl:value-of select="gfc:typeName/gco:LocalName"/>
				</gfc_typeName>

				<xsl:for-each select="gfc:definition">
					<gfc_definition><!--0..1-->
						<xsl:value-of select="gco:CharacterString"/>
					</gfc_definition>
				</xsl:for-each>
<!--				
				<xsl:for-each select="gfc:code">
					<xsl:apply-templates select="." mode="GFCCode"/>
				</xsl:for-each>
-->
					<!--1..1-->
<!--				<gfc_isAbstract>
					<xsl:value-of select="gfc:isAbstract/gco:Boolean"/>
				</gfc_isAbstract>
-->
				
				<xsl:for-each select="gfc:aliases">
					<gfc_aliases><!--0..n-->
						<xsl:value-of select="gco:LocalName"/>
					</gfc_aliases>
				</xsl:for-each>
				
				<xsl:for-each select="gfc:carrierOfCharacteristics">
					<gfc_carrierOfCharacteristics><!--0..n-->
<!--						<FC_FeaturePropertyType> -->
							<!-- On ne mappe que les attributs -->
							<xsl:for-each select="gfc:FC_FeatureAttribute">
								<xsl:apply-templates select="." mode="FeaturePropertyType"/> <!--19110-to-19115.xsl -->
							</xsl:for-each>
<!--						</FC_FeaturePropertyType> -->
					</gfc_carrierOfCharacteristics>
				</xsl:for-each>
			</gfc_featureType>
		</xsl:template>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:template match="*" mode="FeaturePropertyType">

			<gfc_memberName>		
				<xsl:value-of select="gfc:memberName/gco:LocalName"/>
			</gfc_memberName>

			<xsl:for-each select="gfc:definition">
				<gfc_definition><!--0..1-->
					<xsl:value-of select="gco:CharacterString"/>
				</gfc_definition>
			</xsl:for-each>

			<gfc_cardinality><!--1..1-->
			
				<!-- lower -->
				<gfc_lower><!--1..1-->
					<xsl:value-of select="gfc:cardinality/gco:Multiplicity/gco:range/gco:MultiplicityRange/gco:lower/gco:Integer"/>
				</gfc_lower>

				<!-- upper -->
				<gfc_upper><!--1..1-->
					<!-- INFINI si non numérique -->
					<xsl:choose>
						<xsl:when test="gfc:cardinality/gco:Multiplicity/gco:range/gco:MultiplicityRange/gco:upper/gco:UnlimitedInteger/@isInfinite">n</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="gfc:cardinality/gco:Multiplicity/gco:range/gco:MultiplicityRange/gco:upper/gco:UnlimitedInteger"/>
						</xsl:otherwise>
					</xsl:choose>
				</gfc_upper>

			</gfc_cardinality>


			<xsl:for-each select="gfc:code">
				<xsl:apply-templates select="." mode="GFCCode"/>
			</xsl:for-each>

			<!-- ATTENTION MAPPING UnitDefinition et classes qui en héritent-->
			<xsl:for-each select="gfc:valueMeasurementUnit">
				<gfc_valueMeasurementUnit><!--0..1-->
					<xsl:apply-templates select="." mode="GFCUnitDefinition"/>
				</gfc_valueMeasurementUnit>
			</xsl:for-each>


			<xsl:for-each select="gfc:listedValue">
				<xsl:for-each select="gfc:FC_ListedValue">
					<gfc_listedValue>
					
						<gfc_label><!--1..1-->
							<xsl:value-of select="gfc:label/gco:CharacterString"/>
						</gfc_label>
						
						<xsl:for-each select="gfc:code"><!--0..1-->
							<xsl:apply-templates select="." mode="GFCCode"/>
						</xsl:for-each>
						
						<xsl:for-each select="gfc:definition">
							<gfc_definition><!--0..1-->
								<xsl:value-of select="gco:CharacterString"/>
							</gfc_definition>
						</xsl:for-each>
						
					</gfc_listedValue>
				</xsl:for-each>
			</xsl:for-each>


			<gfc_valueType><!--1..1-->
				<xsl:value-of select="gfc:valueType/gco:TypeName/gco:aName/gco:CharacterString"/>
			</gfc_valueType>

		</xsl:template>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
		
		<xsl:template match="*" mode="GFCCode">
			<gfc_code><!--0..1 gco:CharacterString ou sous-types qui sont des codes listes-->
				<xsl:value-of select="gco:CharacterString"/>
				<!--OU-->
				<xsl:for-each select="*[@codeListValue]">
				   <xsl:value-of select="@codeListValue"/>			   
			   </xsl:for-each>
			   </gfc_code>		
		</xsl:template>
		
		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->		
		
		<xsl:template match="*" mode="GFCUnitDefinition">
			<!-- pour tout type de définition on ne s'interesse qu'au nom -->
			<xsl:for-each select="*/gml:name">
				<xsl:value-of select="."/>
			</xsl:for-each>
		</xsl:template>		

	</xsl:stylesheet>
	