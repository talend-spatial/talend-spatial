<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fra="http://www.cnig.gouv.fr/2005/fra" xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gfc="http://www.isotc211.org/2005/gfc" xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gmx="http://www.isotc211.org/2005/gmx" xmlns:gsr="http://www.isotc211.org/2005/gsr" xmlns:gss="http://www.isotc211.org/2005/gss" xmlns:gts="http://www.isotc211.org/2005/gts" xmlns:gml="http://www.opengis.net/gml" xmlns:xlink="http://www.w3.org/1999/xlink" exclude-result-prefixes="xs">
		<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
		
		<xsl:include href="resp-party.xsl"/>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:output method="xml" encoding="UTF-8" indent="yes"/>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->		
		
		<!--xsl:variable name="resourceLocation">./resources/codeList.xml#</xsl:variable-->
		<xsl:variable name="resourceLocation"></xsl:variable>

		<xsl:variable name="schemaLocation">http://www.isotc211.org/2005/gfc ../schemas/iso19139Fra/gfc/gfc.xsd</xsl:variable>
		
		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->		

		<xsl:template match="/FC_FeatureCatalogue">
			<gfc:FC_FeatureCatalogue xmlns:fra="http://www.cnig.gouv.fr/2005/fra" xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gfc="http://www.isotc211.org/2005/gfc" xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gmx="http://www.isotc211.org/2005/gmx" xmlns:gsr="http://www.isotc211.org/2005/gsr" xmlns:gss="http://www.isotc211.org/2005/gss" xmlns:gts="http://www.isotc211.org/2005/gts" xmlns:gml="http://www.opengis.net/gml">
			
				<xsl:attribute name="xsi:schemaLocation">
					<xsl:value-of select="$schemaLocation"/>
				</xsl:attribute>

				<xsl:variable name="Var_FC_FeatureCatalogue" select="."/>
				
				<xsl:attribute name="id">
					<xsl:value-of select="normalize-space(gfc_name)"/>
				</xsl:attribute>

				<gmx:name>
					<gco:CharacterString>
						<xsl:value-of select="gfc_name"/>
					</gco:CharacterString>
				</gmx:name>

				<gmx:scope>
					<gco:CharacterString>
						<xsl:value-of select="gfc_scope"/>
					</gco:CharacterString>
				</gmx:scope>

				<gmx:fieldOfApplication>
					<gco:CharacterString>
						<xsl:value-of select="gfc_fieldOfApplication"/>
					</gco:CharacterString>
				</gmx:fieldOfApplication>

				<gmx:versionNumber>
					<gco:CharacterString>
						<xsl:value-of select="gfc_versionNumber"/>
					</gco:CharacterString>
				</gmx:versionNumber>

				<gmx:versionDate>
					<xsl:choose>
						<xsl:when test="contains(gfc_versionDate,'T')">
							<gco:DateTime>
								 <xsl:value-of select="gfc_versionDate" />
							</gco:DateTime>
						</xsl:when>
						<xsl:when test="not(gfc_versionDate/text())">
							<xsl:attribute name="gco:nilReason">unknown</xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<gco:Date>
								<xsl:value-of select="gfc_versionDate" />
							</gco:Date>
					   </xsl:otherwise>
					</xsl:choose>
				</gmx:versionDate>


<!--gmx:language>
	<gmd:LanguageCode codeList="${site-reg}CodeLists.xml#xpointer(//*[@gml:id='LanguageCode'])" codeListValue="${site-reg}CodeLists.xml#xpointer(//*[@gml:id='LanguageCode_fra'])">
	fra
	</gmd:LanguageCode>
</gmx:language-->

				<gmx:language>
					<gmd:LanguageCode codeList="LanguageCode" codeListValue="{gfc_language/languageCode/@value}"/>
				</gmx:language>
				
<!--gmx:characterSet>
	<gmd:MD_CharacterSetCode codeList="${site-reg}CodeLists.xml#xpointer(//*[@gml:id='MD_CharacterSetCode'])" codeListValue="${site-reg}CodeLists.xml#xpointer(//*[@gml:id='MD_CharacterSetCode_iso8859part15'])">
	fra
	</gmd:MD_CharacterSetCode>
</gmx:characterSet-->

				<gmx:characterSet>
					<gmd:MD_CharacterSetCode codeList="MD_CharacterSetCode" codeListValue="{characterSet/CharSetCd/@value}"/>
				</gmx:characterSet>

				<xsl:for-each select="gfc_producer">
					<gfc:producer>
						<gmd:CI_ResponsibleParty>
							<xsl:apply-templates select="." mode="RespParty"/>
						</gmd:CI_ResponsibleParty>
					</gfc:producer>
				</xsl:for-each>

				<gfc:functionalLanguage>
					<gmd:LanguageCode codeList="LanguageCode" codeListValue="{functionalLanguage/languageCode/@value}"/>
				</gfc:functionalLanguage>

				<xsl:for-each select="gfc_featureType">
					<gfc:featureType>
						<gfc:FC_FeatureType>					
							<xsl:apply-templates select="." mode="FeatureType">
								<xsl:with-param name="FeatureCatalogue" select="$Var_FC_FeatureCatalogue"/>
							</xsl:apply-templates>
						</gfc:FC_FeatureType>
					</gfc:featureType>
				</xsl:for-each>
							
			</gfc:FC_FeatureCatalogue>
		</xsl:template>

		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

		<xsl:template match="*" mode="FeatureType">
			<xsl:param name="FeatureCatalogue" select="."/>

			<xsl:variable name="Var_FC_FeatureType" select="."/>

			<xsl:attribute name="id">
				<xsl:value-of select="normalize-space($Var_FC_FeatureType/gfc_typeName)"/>
			</xsl:attribute>

			<gfc:typeName>
				<gco:LocalName>
					<!--xsl:attribute name="codeSpace"> 			
					</xsl:attribute-->

					<xsl:value-of select="gfc_typeName"/> 
					
				</gco:LocalName>
			</gfc:typeName>

			<gfc:definition>
				<gco:CharacterString>
					<xsl:value-of select="gfc_definition"/>
				</gco:CharacterString>
			</gfc:definition>

			<gfc:code>
				<gco:CharacterString>
					<xsl:value-of select="gfc_code"/>
				</gco:CharacterString>
			</gfc:code>

			<gfc:isAbstract>
				<gco:Boolean>false
<!--					<xsl:value-of select="gfc_isAbstract"/> -->
				</gco:Boolean>
			</gfc:isAbstract>

			<gfc:aliases>
				<gco:LocalName>
					<!--xsl:attribute name="codeSpace"> 			
					</xsl:attribute-->

					<xsl:value-of select="gfc_aliases"/>
					
				</gco:LocalName>
			</gfc:aliases>

			<gfc:featureCatalogue> <!-- ATTENTION XLINK VERS LA FeatureCatalogue parente -->
				<xsl:attribute name="xlink:href">
					<xsl:value-of select="concat('#',normalize-space($FeatureCatalogue/gfc_name))"/>
				</xsl:attribute>
			</gfc:featureCatalogue>

			<xsl:for-each select="gfc_carrierOfCharacteristics">
				<gfc:carrierOfCharacteristics>
<!--					<xsl:for-each select="FC_FeaturePropertyType"> -->
						<gfc:FC_FeatureAttribute>				
							<xsl:apply-templates select="." mode="FeaturePropertyType">
								<xsl:with-param name="FeatureType" select="$Var_FC_FeatureType"/>
							</xsl:apply-templates>
						</gfc:FC_FeatureAttribute>											
<!--					</xsl:for-each> -->
				</gfc:carrierOfCharacteristics>
			</xsl:for-each>

		</xsl:template>
		
		<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->		
					
		<xsl:template match="*" mode="FeaturePropertyType">
			<xsl:param name="FeatureType" select="." />
			<xsl:variable name="Var_FC_FeaturePropertyType" select="."/>

			<xsl:attribute name="id"> <!-- ATTENTION nom du FeatureType + "." nom du FeaturePropertyType -->
				<xsl:value-of select="concat(normalize-space($FeatureType/gfc_typeName),'.',normalize-space($Var_FC_FeaturePropertyType/gfc_memberName))"/>
			</xsl:attribute>
			
			<gfc:memberName>
				<gco:LocalName>
					<!--xsl:attribute name="codeSpace"> 
					</xsl:attribute-->				
				
					<xsl:value-of select="gfc_memberName"/>

				</gco:LocalName>
			</gfc:memberName>

			<gfc:definition>
				<gco:CharacterString>
					<xsl:value-of select="gfc_definition"/>
				</gco:CharacterString>
			</gfc:definition>

			<gfc:cardinality>
				<gco:Multiplicity>
					<gco:range>
						<gco:MultiplicityRange>
							<gco:lower>
								<gco:Integer>
									<xsl:choose>
										<xsl:when test="string-length(gfc_cardinality/gfc_lower)=0">
											<xsl:text>0</xsl:text>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="gfc_cardinality/gfc_lower"/>
										</xsl:otherwise>
									</xsl:choose>
								</gco:Integer>
							</gco:lower>

							<gco:upper>
								<gco:UnlimitedInteger>

									<!-- INFINI si non numérique -->
									<xsl:choose>
										<xsl:when test="string(number(gfc_upper))='NaN'">
											<xsl:attribute name="isInfinite">true</xsl:attribute>
<!--											0 -->
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="gfc_upper"/>										
										</xsl:otherwise>
									</xsl:choose>

								</gco:UnlimitedInteger>
							</gco:upper>

						</gco:MultiplicityRange>
					</gco:range>
				</gco:Multiplicity>
			</gfc:cardinality>
			
			<gfc:featureType> <!-- ATTENTION XLINK VERS Le FeatureType parent -->
				<xsl:attribute name="xlink:href">
					<xsl:value-of select="concat('#',normalize-space($FeatureType/gfc_typeName))"/>
				</xsl:attribute>
			</gfc:featureType>

			<gfc:code>
				<gco:CharacterString>
					<xsl:value-of select="gfc_code"/>
				</gco:CharacterString>
			</gfc:code>

			<gfc:valueMeasurementUnit>
				<gml:UnitDefinition gml:id="unknown">
					<gml:identifier>
						<xsl:attribute name="codeSpace">unknown</xsl:attribute>
						<xsl:value-of select="gfc_valueMeasurementUnit"/>
					</gml:identifier>
				</gml:UnitDefinition>
			</gfc:valueMeasurementUnit>

			<xsl:for-each select="gfc_listedValue">
				<gfc:listedValue>
					<gfc:FC_ListedValue>
						<gfc:label>
							<gco:CharacterString>
								<xsl:value-of select="gfc_label"/>
							</gco:CharacterString>
						</gfc:label>
						<gfc:code>
							<gco:CharacterString>
								<xsl:value-of select="gfc_code"/>
							</gco:CharacterString>
						</gfc:code>
						<gfc:definition>
							<gco:CharacterString>
								<xsl:value-of select="gfc_definition"/>
							</gco:CharacterString>
						</gfc:definition>
					</gfc:FC_ListedValue>
				</gfc:listedValue>
			</xsl:for-each>

			<gfc:valueType>
				<gco:TypeName>
					<gco:aName>
						<xsl:for-each select="gfc_valueType">
							<gco:CharacterString>
								<xsl:value-of select="."/>
							</gco:CharacterString>
						</xsl:for-each>
					</gco:aName>
				</gco:TypeName>
			</gfc:valueType>

		</xsl:template>

	</xsl:stylesheet>
