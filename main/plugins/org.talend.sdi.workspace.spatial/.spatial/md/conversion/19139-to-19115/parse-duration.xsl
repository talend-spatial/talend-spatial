<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

   <xsl:template name="parse-duration">
      <xsl:param name="paramDuration" />

<!-- On prend la valeur positive -->
      <xsl:variable name="isNegative" select="starts-with($paramDuration, '-')" />

      <xsl:variable name="localDuration">
         <xsl:choose>
            <xsl:when test="$isNegative">
               <xsl:value-of select="substring($paramDuration, 2)" />
            </xsl:when>

            <xsl:otherwise>
               <xsl:value-of select="$paramDuration" />
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>

<!-- On vérifie la conformité générale -->
      <xsl:if test="starts-with($localDuration, 'P') and not(translate($localDuration, '0123456789PYMDTHS.', ''))">
<!-- La partie date -->
         <xsl:variable name="duration-date">
            <xsl:choose>
               <xsl:when test="contains($localDuration, 'T')">
                  <xsl:value-of select="substring-before(substring($localDuration, 2), 'T')" />
               </xsl:when>

               <xsl:otherwise>
                  <xsl:value-of select="substring($localDuration, 2)" />
               </xsl:otherwise>
            </xsl:choose>
         </xsl:variable>

<!-- La partie time -->
         <xsl:variable name="duration-time">
            <xsl:if test="contains($localDuration, 'T')">
               <xsl:value-of select="substring-after($localDuration, 'T')" />
            </xsl:if>
         </xsl:variable>

<!-- Conformité des parties date et time -->
         <xsl:if test="(not($duration-date) or (not(translate($duration-date, '0123456789YMD', '')) and not(substring-after($duration-date, 'D')) and (contains($duration-date, 'D') or (not(substring-after($duration-date, 'M')) and (contains($duration-date, 'M') or not(substring-after($duration-date, 'Y'))))))) and (not($duration-time) or (not(translate($duration-time, '0123456789HMS.', '')) and not(substring-after($duration-time, 'S')) and (contains($duration-time, 'S') or not(substring-after($duration-time, 'M')) and (contains($duration-time, 'M') or not(substring-after($duration-time, 'Y'))))))">
            <xsl:variable name="year-str">
               <xsl:choose>
                  <xsl:when test="contains($duration-date, 'Y')">
                     <xsl:value-of select="substring-before($duration-date, 'Y')" />
                  </xsl:when>

                  <xsl:otherwise>0</xsl:otherwise>
               </xsl:choose>
            </xsl:variable>

            <xsl:variable name="month-str">
               <xsl:choose>
                  <xsl:when test="contains($duration-date, 'M')">
                     <xsl:choose>
                        <xsl:when test="contains($duration-date, 'Y')">
                           <xsl:value-of select="substring-before(substring-after($duration-date, 'Y'), 'M')" />
                        </xsl:when>

                        <xsl:otherwise>
                           <xsl:value-of select="substring-before($duration-date, 'M')" />
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:when>

                  <xsl:otherwise>0</xsl:otherwise>
               </xsl:choose>
            </xsl:variable>

            <xsl:variable name="day-str">
               <xsl:choose>
                  <xsl:when test="contains($duration-date, 'D')">
                     <xsl:choose>
                        <xsl:when test="contains($duration-date, 'M')">
                           <xsl:value-of select="substring-before(substring-after($duration-date, 'M'), 'D')" />
                        </xsl:when>

                        <xsl:when test="contains($duration-date, 'Y')">
                           <xsl:value-of select="substring-before(substring-after($duration-date, 'Y'), 'D')" />
                        </xsl:when>

                        <xsl:otherwise>
                           <xsl:value-of select="substring-before($duration-date, 'D')" />
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:when>

                  <xsl:otherwise>0</xsl:otherwise>
               </xsl:choose>
            </xsl:variable>

            <xsl:variable name="hour-str">
               <xsl:choose>
                  <xsl:when test="contains($duration-time, 'H')">
                     <xsl:value-of select="substring-before($duration-time, 'H')" />
                  </xsl:when>

                  <xsl:otherwise>0</xsl:otherwise>
               </xsl:choose>
            </xsl:variable>

            <xsl:variable name="minute-str">
               <xsl:choose>
                  <xsl:when test="contains($duration-time, 'M')">
                     <xsl:choose>
                        <xsl:when test="contains($duration-time, 'H')">
                           <xsl:value-of select="substring-before(substring-after($duration-time, 'H'), 'M')" />
                        </xsl:when>

                        <xsl:otherwise>
                           <xsl:value-of select="substring-before($duration-time, 'M')" />
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:when>

                  <xsl:otherwise>0</xsl:otherwise>
               </xsl:choose>
            </xsl:variable>

            <xsl:variable name="second-str">
               <xsl:choose>
                  <xsl:when test="contains($duration-time, 'S')">
                     <xsl:choose>
                        <xsl:when test="contains($duration-time, 'M')">
                           <xsl:value-of select="substring-before(substring-after($duration-time, 'M'), 'S')" />
                        </xsl:when>

                        <xsl:when test="contains($duration-time, 'H')">
                           <xsl:value-of select="substring-before(substring-after($duration-time, 'H'), 'S')" />
                        </xsl:when>

                        <xsl:otherwise>
                           <xsl:value-of select="substring-before($duration-time, 'S')" />
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:when>

                  <xsl:otherwise>0</xsl:otherwise>
               </xsl:choose>
            </xsl:variable>

            <years>
               <xsl:value-of select="$year-str" />/n
            </years>

            <months>
               <xsl:value-of select="$month-str" />
            </months>

            <days>
               <xsl:value-of select="$day-str" />
            </days>

            <hours>
               <xsl:value-of select="$hour-str" />
            </hours>

            <minutes>
               <xsl:value-of select="$minute-str" />
            </minutes>

            <seconds>
               <xsl:value-of select="$second-str" />
            </seconds>
         </xsl:if>
      </xsl:if>
   </xsl:template>
</xsl:stylesheet>
