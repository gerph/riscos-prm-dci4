<?xml version="1.0" standalone="yes"?>

<!-- RISC OS PRM stylesheet - written by hand; apologies for errors in
     style 

     This stylesheet is for the frameset referencing the document
     (c) Justin Fletcher, distribution unlimited.

     -->
     

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/TR/xhtml1/strict">

<xsl:output method="html" indent="no"/>

<xsl:template match="/">
<html><xsl:apply-templates/></html>
</xsl:template>

<xsl:template match="chapter">
<head>
 <title>
  RISC OS Programmers Reference Manuals : <xsl:value-of select="@title" />
 </title>
</head>

<frameset cols="25%,*">
 <frame frameborder="1" scrolling="yes">
  <xsl:attribute name="src">
   <xsl:value-of select="$page" />
   <xsl:text>-left.html</xsl:text>
  </xsl:attribute>
 </frame>
 <frame frameborder="1" scrolling="yes">
  <xsl:attribute name="src">
   <xsl:value-of select="$page" />
   <xsl:text>-right.html</xsl:text>
  </xsl:attribute>
  <xsl:attribute name="name">
   <xsl:value-of select="$page" />
  </xsl:attribute>
 </frame>
</frameset>

<noframes>
<body bgcolor="white" text="black" link="blue" alink="red" vlink="darkblue">
<hr />
<h1><xsl:value-of select="@title"/></h1>
<hr />

<dl>
 <dt><h2>No frames version</h2></dt>
 <dd>
  Please visit <a>
                <xsl:attribute name="href">
                 <xsl:value-of select="$page" />
                 <xsl:text>.html</xsl:text>
                </xsl:attribute>
                <xsl:text>the non-frames page</xsl:text>
               </a> for full information.
 </dd>
</dl>
<hr />

</body>
</noframes>

</xsl:template>

</xsl:stylesheet>
