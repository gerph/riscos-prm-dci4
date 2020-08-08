<?xml version="1.0" standalone="yes"?>

<!-- BNF stylesheet
     
     Converts XML BNF descriptions to HTML.
     (c) Justin Fletcher, distribution unlimited.
     Version 1.00 development.
  -->

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/TR/xhtml1/strict"
                xmlns:bnf="http://www.movspclr.co.uk/dtd/bnf/100/bnf.dtd"
                xmlns:saxon = "http://icl.com/saxon">
<xsl:output method="html" indent="no"/>
<xsl:variable name="bnf-italic-names">yes</xsl:variable>
<xsl:variable name="bnf-indented">yes</xsl:variable>
<xsl:variable name="bnf-elements">bnf:group | bnf:rule-use | bnf:literal | bnf:character</xsl:variable>
<xsl:template match="/">
<html>
<xsl:comment>
  Auto-generated using XSLT stylesheet created by Justin Fletcher.
  
  This document was created with the BNF HTML stylesheet updated 21 Apr 2004.
</xsl:comment>
<head>
 <title>BNF description</title>
</head>
<body>
<xsl:apply-templates />
</body>
</html>
</xsl:template>

<xsl:template match="bnf:bnf">
<xsl:choose>
 <xsl:when test="$bnf-indented = 'yes'">
  <dl><dd>
    <xsl:call-template name="bnf-root" />
  </dd></dl>
 </xsl:when>
 <xsl:otherwise>
  <xsl:call-template name="bnf-root" />
 </xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template name="bnf-root">
<table summary="BNF syntax description" border="0">
<xsl:apply-templates select="bnf:comment | bnf:rule-def" />
</table>
<xsl:if test="@caption != ''">
 <p align="center">
  <em><xsl:value-of select="@caption" /></em>
 </p>
</xsl:if>
</xsl:template>

<xsl:template match="bnf:comment">
<tr>
 <td colspan="2"></td>
 <td>
  <xsl:text>; </xsl:text>
  <xsl:apply-templates />
 </td>
</tr>
</xsl:template>


<xsl:template match="bnf:rule-def">
<tr>
 <td valign="top" align="left">
  <xsl:call-template name="bnf-name">
   <xsl:with-param name="name" select="@name" />
  </xsl:call-template>
 </td>
 <td valign="top" align="left">
  <xsl:choose>
   <xsl:when test="@continue = 'true'">
    <xsl:text>=/</xsl:text>
   </xsl:when>
   <xsl:otherwise>
    <xsl:text>=</xsl:text>
   </xsl:otherwise>
  </xsl:choose>
 </td>
 <td valign="top" align="left">
  <xsl:for-each select="saxon:evaluate($bnf-elements)">
   <xsl:apply-templates select="." />
   <xsl:text> </xsl:text>
  </xsl:for-each>
 </td>
</tr>
</xsl:template>

<xsl:template match="bnf:group">
 <xsl:call-template name="bnf-repetitions" />
<!-- In order to simplify the visual form of the groups, we can
     skip the outer () if the group is the first and last element
     of the parent element, and the group is not a repetition
     rule - this really means it is only useful for alternates,
     but putting groups around the bare sequence elements won't
     affect their interpretation according to ABNF.
     Primarily, therefore, this affects a rule such as :
       <rule-def name="stuff">
        <group alternates="true">
         <rule-use name="thing" />
         <rule-use name="thing" />
        </group>
     Which should effectively be displayed as :
     
       stuff  =  thing / thing
     
     rather than
       
       stuff  =  ( thing / thing )
  -->
 <!-- Note on this magic... we use <prefix>-<suffix> to describe the ends
      of the sections. -->
 <xsl:variable name="ends">
  <xsl:choose>
   <xsl:when test="@optional = 'true'">
    <xsl:text>[ -]</xsl:text>
   </xsl:when>
   <xsl:when test="@repeat != 'true' and
                   @repeat-min = '' and
                   @repeat-max = '' and
                   name(..) = 'rule-def'">
    <!-- Omit any prefix or suffix -->
    <xsl:text>-</xsl:text>
   </xsl:when>
   <xsl:otherwise>
    <xsl:text>( -)</xsl:text>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:variable>
     
 <xsl:value-of select="substring-before($ends, '-')" />
 <xsl:for-each select="saxon:evaluate($bnf-elements)">
  <xsl:apply-templates select="." />
  <xsl:choose>
   <xsl:when test="position() != last() and
                   ../@alternates = 'true'">
    <xsl:text> / </xsl:text>
   </xsl:when>
   <xsl:otherwise>
    <xsl:text> </xsl:text>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:for-each>
 <xsl:value-of select="substring-after($ends, '-')" />
</xsl:template>

<xsl:template match="bnf:rule-use">
 <xsl:call-template name="bnf-repetitions" />
 <xsl:call-template name="bnf-name">
  <xsl:with-param name="name" select="@name" />
 </xsl:call-template>
</xsl:template>

<xsl:template match="bnf:literal">
 <xsl:call-template name="bnf-repetitions" />
 <xsl:text>"</xsl:text>
  <code>
   <xsl:value-of select="@string" />
  </code>
 <xsl:text>"</xsl:text>
</xsl:template>

<xsl:template match="bnf:character">
 <xsl:call-template name="bnf-repetitions" />
 <code>
  <xsl:text>%</xsl:text>
  <xsl:value-of select="@base" />
  <xsl:value-of select="@value" />
  <xsl:if test="@limit != ''">
   <xsl:text>-</xsl:text>
   <xsl:value-of select="@limit" />
  </xsl:if>
 </code>
</xsl:template>

<!-- deal with repetitions in a general way -->
<xsl:template name="bnf-repetitions">
<xsl:if test="@repeat-min != '' or
              @repeat-max != '' or
              @repeat = 'true'">
 <!-- we want to special case the min and max being the same -->
 <xsl:choose>
  <xsl:when test="@repeat-min != '' and
                  @repeat-min = @repeat-max">
   <xsl:value-of select="@repeat-min" />
  </xsl:when>
  
  <xsl:otherwise>
   <xsl:if test="@repeat-min != ''">
    <xsl:value-of select="@repeat-min" />
   </xsl:if>
   
   <xsl:text>*</xsl:text>
   
   <xsl:if test="@repeat-max != ''">
    <xsl:value-of select="@repeat-max" />
   </xsl:if>
   
  </xsl:otherwise>
 </xsl:choose>
</xsl:if>
</xsl:template>

<xsl:template name="bnf-name">
<xsl:param name="name" />

<xsl:choose>
 <xsl:when test="$bnf-italic-names = 'yes'">
  <i>
   <xsl:value-of select="$name" />
  </i>
 </xsl:when>
 <xsl:otherwise>
  <xsl:value-of select="$name" />
 </xsl:otherwise>
</xsl:choose>

</xsl:template>

</xsl:stylesheet>
