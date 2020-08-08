<?xml version="1.0" standalone="yes"?>

<!-- RISC OS PRM stylesheet - written by hand; apologies for errors in
     style.
     
     Generates textual command descriptions from documentation
     (c) RISCOS Ltd, distribution unlimited.
     -->

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="text" indent="no" encoding="iso-8859-1" />
<xsl:param name="match-command" select="''" />

<xsl:template match="/">
<xsl:choose>
 <xsl:when test="$match-command = ''">
  <xsl:apply-templates select="//command-definition" />
 </xsl:when>
 <xsl:otherwise>
  <xsl:apply-templates select="//command-definition[@name=$match-command]" />
 </xsl:otherwise>
</xsl:choose> 
</xsl:template>

<!-- All this hassle just to find the maximum length of some strings -->
<xsl:template name="max-of-string">
<xsl:choose>
 <xsl:when test="$string != ''">
  <xsl:variable name="first" select="number(substring-before(concat($string,' '),' '))" />
  <xsl:variable name="string2" select="substring-after($string,' ')" />
  <xsl:choose>
   <xsl:when test="$first &gt; $max">
    <xsl:call-template name="max-of-string">
     <xsl:with-param name="string" select="$string2" />
     <xsl:with-param name="max" select="$first" />
    </xsl:call-template>
   </xsl:when>
   <xsl:otherwise>
    <xsl:call-template name="max-of-string">
     <xsl:with-param name="string" select="$string2" />
     <xsl:with-param name="max" select="$max" />
    </xsl:call-template>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:when>
 
 <xsl:otherwise>
  <xsl:value-of select="$max" />
 </xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template name="parameter-length">
<xsl:variable name="lengths">
 <xsl:for-each select="$node/parameter">
  <xsl:variable name="content"><xsl:apply-templates select="."/></xsl:variable>
  <xsl:value-of select="string-length(substring-before($content,'&#9;'))" />
  <xsl:if test="position() != last()">
   <xsl:text> </xsl:text>
  </xsl:if>
 </xsl:for-each>
</xsl:variable>
<xsl:call-template name="max-of-string">
 <xsl:with-param name="string" select="$lengths" />
 <xsl:with-param name="max" select="0" />
</xsl:call-template>
</xsl:template>
<!-- End length routines -->

<!-- and a little routine to write out a number of tabs -->
<xsl:template name="write-tabs">
<xsl:if test="$number > 0">
 <xsl:text>&#9;</xsl:text>
 <xsl:call-template name="write-tabs">
  <xsl:with-param name="number" select="$number - 1" />
 </xsl:call-template>
</xsl:if>
</xsl:template>

<xsl:template match="command-definition">
<xsl:value-of select="@name" />
<xsl:text>&#9;{Module_FullVersionAndDate}&#10;</xsl:text>
<xsl:apply-templates select="use" />


<xsl:text>&#10;</xsl:text>
<xsl:apply-templates select="syntax" />
<xsl:if test="count(parameter) > 0">
 <xsl:text>&#10;Parameters:&#10;</xsl:text>
 <xsl:variable name="maxlength">
  <xsl:call-template name="parameter-length">
   <xsl:with-param name="node" select="." />
  </xsl:call-template>
 </xsl:variable>
 <xsl:variable name="tabstomid" select="floor(($maxlength div 8) + 1)" />
 <xsl:for-each select="parameter">
  <xsl:variable name="param">
   <xsl:apply-templates select="." />
  </xsl:variable>
  <xsl:value-of select="substring-before($param,'&#9;')" />
  <xsl:call-template name="write-tabs">
   <xsl:with-param name="number" select="$tabstomid -
             floor(string-length(substring-before($param,'&#9;')) div 8)" />
  </xsl:call-template>
  <xsl:value-of select="substring-after($param,'&#9;')" />
 </xsl:for-each>
</xsl:if>
</xsl:template>

<xsl:template match="syntax">
<xsl:choose>
 <xsl:when test="position()=1">
  <xsl:text>Syntax: *</xsl:text>
 </xsl:when>
 <xsl:otherwise>
  <xsl:text>        *</xsl:text>
 </xsl:otherwise>
</xsl:choose>
<xsl:value-of select="../@name" />
<xsl:text> </xsl:text>
<xsl:variable name="content"><xsl:apply-templates /></xsl:variable>
<xsl:value-of select="normalize-space($content)" />
<xsl:text>&#10;</xsl:text>
</xsl:template>

<!-- helper template to remove leading spaces -->
<xsl:template name="strip-leading-spaces">
<xsl:choose>
 <xsl:when test="starts-with($string,' ')">
  <xsl:call-template name="strip-leading-spaces">
   <xsl:with-param name="string" select="substring($string,2)" />
  </xsl:call-template>
 </xsl:when>
 <xsl:otherwise>
  <xsl:value-of select="$string" />
 </xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="parameter">
<xsl:text>  </xsl:text>
<xsl:if test="@switch != ''">
 <xsl:text>-</xsl:text>
 <xsl:value-of select="@switch" />
</xsl:if>
<xsl:if test="@label != ''">
 <xsl:value-of select="@label" />
</xsl:if>
<xsl:if test="((@switch != '') or
               (@label != '')) and
              (@name!='')">
 <xsl:text> </xsl:text>
</xsl:if>
<xsl:if test="@name != ''">
 <xsl:text>&lt;</xsl:text>
 <xsl:value-of select="@name" />
 <xsl:text>&gt;</xsl:text>
</xsl:if>
<xsl:text>&#9;</xsl:text>
<xsl:variable name="string"><xsl:apply-templates /></xsl:variable>
<xsl:value-of select="normalize-space($string)" />
<xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template match="optional">
<xsl:text>[ </xsl:text>
<xsl:choose>
 <xsl:when test="@alternates='true'">
  <xsl:for-each select="*">
   <xsl:if test="position()>1">
    <xsl:text> | </xsl:text>
   </xsl:if>
   <xsl:apply-templates select="."/>
  </xsl:for-each>
 </xsl:when>
 
 <xsl:otherwise>
  <xsl:for-each select="*|text()">
   <xsl:apply-templates select="."/>
  </xsl:for-each>
 </xsl:otherwise>
</xsl:choose>
<xsl:text> ]</xsl:text>
</xsl:template>

<xsl:template match="switch">
<xsl:text>-</xsl:text>
<xsl:value-of select="@name" />
<xsl:if test="(text() != '') or (count(*) > 0)">
 <xsl:text> </xsl:text>
 <xsl:apply-templates />
</xsl:if>
</xsl:template>

<xsl:template match="userreplace">
<xsl:text>&lt;</xsl:text>
<xsl:apply-templates />
<xsl:text>&gt;</xsl:text>
<xsl:if test="(following-sibling::*[position() = 1]/self::text()) and
              (following-sibling::*[position() = 2]/optional or
               following-sibling::*[position() = 2]/userreplace)">
 <xsl:text> </xsl:text>
</xsl:if>
</xsl:template>

<xsl:template match="use">
<xsl:apply-templates select="p"/>
</xsl:template>

<xsl:template match="text()">
<xsl:variable name="t" select="." />
<xsl:value-of select="translate($t,'&#10;',' ')" />
</xsl:template>

<xsl:template match="p">
<xsl:if test="(local-name(..) = 'use') and (count(preceding-sibling::p) != 0)">
 <xsl:text>&#10;</xsl:text>
</xsl:if>
<!-- <xsl:call-template name="strip-leading-spaces"> -->
<!--  <xsl:with-param name="string"><xsl:apply-templates /></xsl:with-param> -->
<!-- </xsl:call-template> -->
<xsl:choose>
 <xsl:when test="count(value-table)">
  <xsl:apply-templates select="value-table"/>
 </xsl:when>
 <xsl:otherwise>
  <xsl:variable name="string"><xsl:apply-templates /></xsl:variable>
  <xsl:value-of select="normalize-space($string)" />
  <xsl:text>&#10;</xsl:text>
 </xsl:otherwise>
</xsl:choose>
</xsl:template>


<!-- List comes in two forms; ordered and unordered -->
<xsl:template match="list">
<xsl:text>&#10;</xsl:text>
<xsl:choose>
 <xsl:when test="@type = 'ordered'">
  <xsl:for-each select="p">
   <xsl:text> </xsl:text>
   <xsl:value-of select="position()" />
   <xsl:text>.&#9;</xsl:text>
   <xsl:apply-templates select="." />
  </xsl:for-each>
 </xsl:when>
 
 <xsl:otherwise>
  <xsl:for-each select="p">
   <xsl:text> *&#9;</xsl:text>
   <xsl:apply-templates select="."/>
  </xsl:for-each>
 </xsl:otherwise>
</xsl:choose>
</xsl:template>


<!-- A value table is just a table of values with headings -->
<xsl:template match="value-table">
<xsl:text>  </xsl:text>
<xsl:text>Value&#9;</xsl:text>
<xsl:if test="@head-name != ''">
 <xsl:text>Name&#9;</xsl:text>
</xsl:if>
<xsl:text>Meaning</xsl:text>
<!--   <xsl:value-of select="@head-number" /> -->
<!--   <xsl:value-of select="@head-name" /> -->
<!--   <xsl:value-of select="@head-value" /> -->
<xsl:apply-templates/>
<xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template match="value">
<xsl:text>&#10;</xsl:text>
<xsl:text>  </xsl:text>
<xsl:value-of select="@number"/>
<xsl:call-template name="write-tabs">
 <xsl:with-param name="number" select="1" />
</xsl:call-template>
<xsl:if test="../*/@name != ''">
 <xsl:value-of select="@name"/>
</xsl:if>
<xsl:apply-templates/>
</xsl:template>

</xsl:stylesheet>
