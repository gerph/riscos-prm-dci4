<?xml version="1.0" standalone="yes"?>

<!-- RISC OS PRM stylesheet - written by hand; apologies for errors in
     style.
     
     Generates header files from documentation.
     (c) Justin Fletcher, distribution unlimited.
     -->

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/TR/xhtml1/strict">

<xsl:output method="text" indent="no"/>

<xsl:template match="/">
<xsl:apply-templates select="/riscos-prm/chapter" />
</xsl:template>

<xsl:template match="/riscos-prm/chapter">

<xsl:text>/* Automatically generated header file for </xsl:text>
          <xsl:value-of select="@title" />
<xsl:text> */

</xsl:text>

<xsl:text>#ifndef </xsl:text>
          <xsl:value-of select="translate(@title,' ,.()-*?','_--')" />
<xsl:text>_Definitions_H
</xsl:text>

<xsl:text>#define </xsl:text>
          <xsl:value-of select="translate(@title,' ,.()-*?','_--')" />
<xsl:text>_Definitions_H
</xsl:text>

<!-- Service calls -->
<xsl:text>
/* Services */
</xsl:text>

<xsl:for-each select="descendant::node()/service-definition">
<xsl:choose>
 <xsl:when test="@reason!=''">
  <xsl:text>#define Service_</xsl:text>
            <xsl:value-of select="@name" />
  <xsl:text>_</xsl:text>
            <xsl:value-of select="@reasonname" />
  <xsl:text> 0x</xsl:text>
            <xsl:value-of select="@reason" />
  <xsl:text> /* </xsl:text>
            <xsl:value-of select="@description" />
  <xsl:text> */
</xsl:text>
 </xsl:when>
 
 <xsl:otherwise>
  <xsl:text>#define Service_</xsl:text>
            <xsl:value-of select="@name" />
  <xsl:text> 0x</xsl:text>
            <xsl:value-of select="@number" />
  <xsl:text> /* </xsl:text>
            <xsl:value-of select="@description" />
  <xsl:text> */
</xsl:text>
 </xsl:otherwise> 
</xsl:choose>
</xsl:for-each>

<!-- UpCall entries -->
<xsl:text>
/* UpCalls */
</xsl:text>

<xsl:for-each select="descendant::node()/upcall-definition">
<xsl:choose>
 <xsl:when test="@reason!=''">
  <xsl:text>#define UpCall_</xsl:text>
            <xsl:value-of select="@name" />
  <xsl:text>_</xsl:text>
            <xsl:value-of select="@reasonname" />
  <xsl:text> 0x</xsl:text>
            <xsl:value-of select="@reason" />
  <xsl:text> /* </xsl:text>
            <xsl:value-of select="@description" />
  <xsl:text> */
</xsl:text>
 </xsl:when>
 
 <xsl:otherwise>
  <xsl:text>#define UpCall_</xsl:text>
            <xsl:value-of select="@name" />
  <xsl:text> 0x</xsl:text>
            <xsl:value-of select="@number" />
  <xsl:text> /* </xsl:text>
            <xsl:value-of select="@description" />
  <xsl:text> */
</xsl:text>
 </xsl:otherwise> 
</xsl:choose>
</xsl:for-each>

<!-- SWI entries -->
<xsl:text>
/* SWIs */
</xsl:text>

<xsl:for-each select="descendant::node()/swi-definition">
<xsl:choose>
 <xsl:when test="@reason!=''">
  <xsl:if test="contains(@reason,',') = false">
   <xsl:text>#define </xsl:text>
             <xsl:value-of select="@name" />
   <xsl:text>_</xsl:text>
             <xsl:value-of select="@reasonname" />
   <xsl:text> 0x</xsl:text>
             <xsl:value-of select="@reason" />
   <xsl:text> /* </xsl:text>
             <xsl:value-of select="@description" />
   <xsl:text> */
</xsl:text>
  </xsl:if>
 </xsl:when>
 
 <xsl:otherwise>
  <xsl:text>#define </xsl:text>
            <xsl:value-of select="@name" />
  <xsl:text> 0x</xsl:text>
            <xsl:value-of select="@number" />
  <xsl:text> /* </xsl:text>
            <xsl:choose>
             <xsl:when test="@internal='yes'">
              <xsl:text>For internal use only</xsl:text>
             </xsl:when>
             <xsl:otherwise>
              <xsl:value-of select="@description" />
             </xsl:otherwise>
            </xsl:choose>
   <xsl:text> */
</xsl:text>
 </xsl:otherwise> 
</xsl:choose>

</xsl:for-each>

<xsl:text>
#endif
</xsl:text>
</xsl:template>

</xsl:stylesheet>
