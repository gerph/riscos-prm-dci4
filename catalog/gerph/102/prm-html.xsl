<?xml version="1.0" standalone="yes"?>

<!-- RISC OS PRM stylesheet - written by hand; apologies for errors in
     style.

     Converts XML descriptions to HTML.
     (c) Justin Fletcher, distribution unlimited.
     Version 1.02 development.

     Notes on use:

       if you use this stylesheet with an xml document, you may set a
       number of parameters to configure the page generation :

          create-contents : yes|no
                            Determines whether the contents part of the
                            page will be generated.
          create-body     : yes|no
                            Determines whether the main body of the page
                            will be generated.
          create-contents-target : yes|no
                            Determines whether the page is being
                            generated as part of a frameset; if set to
                            a target name, it is assumed that a frame
                            of that name exists and that the page
                            (target)-right.html lives there.
                            When used with prm-html-frameset.xsl, this
                            can be used to generate a frameset suitable
                            for use as a quick reference pair.
          position-with-names : yes|no
                            Determines whether a long description of the
                            path to areas with problems is given, or the
                            shorter index-based form.
  -->

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/TR/xhtml1/strict"
                xmlns:localdb="local-file-database"
                xmlns:saxon = "http://icl.com/saxon">

<xsl:include href="http://www.movspclr.co.uk/dtd/bnf/100/html.xsl" />

<!-- 'singular' is used to prefix the *-definition element (only applied
     to certain elements at present).
     'prefix' is used on prefix titles and references.
  -->
<localdb:definition-names type="swi" singular="SWI"        prefix="SWI " />
<localdb:definition-names type="vdu"                       prefix="VDU " />
<localdb:definition-names type="vector" singular="Vector"  prefix="Vector " />
<localdb:definition-names type="command"                   prefix="*" />

<xsl:output method="xml" indent="no"/>

<xsl:variable name="title-to-id-src">ABCDEFGHIJKLMNOPQRSTUVWXYZ ,$:()-*?</xsl:variable>
<xsl:variable name="title-to-id-map">abcdefghijklmnopqrstuvwxyz_-_-</xsl:variable>
<xsl:param name="create-contents">yes</xsl:param>
<xsl:param name="create-body">yes</xsl:param>
<xsl:param name="create-contents-target"></xsl:param>
<xsl:param name="position-with-names">yes</xsl:param>

<xsl:template match="/">
<html>
<xsl:comment>
  Auto-generated using XSLT stylesheet created by Justin Fletcher.

  This document was created with the HTML stylesheet updated 21 Apr 2004.
</xsl:comment>
<xsl:apply-templates />
<xsl:apply-templates select="riscos-prm/meta" mode="tail"/>
</html>
</xsl:template>

<!-- ignore meta tags in main body -->
<xsl:template match="meta" />

<xsl:template match="chapter">
<head>
 <title>
  <xsl:value-of select="../@doc-group"/>
  <xsl:text> : </xsl:text>
  <xsl:value-of select="@title"/>
 </title>
</head>

<body bgcolor="white" text="black" link="blue" alink="red" vlink="darkblue">

<hr />
<h1><xsl:value-of select="@title"/></h1>
<hr />

<xsl:choose>
 <xsl:when test="$create-contents-target = ''">
  <xsl:if test="$create-contents = 'yes'">
  <dl>
   <dt><h2>Contents</h2></dt>
   <dd>
    <ul>
     <xsl:apply-templates select="section|import" mode="contents" />
    </ul>
   </dd>
  </dl>
  <hr />
  </xsl:if>
 </xsl:when>

 <xsl:otherwise>
  <font size="-1">
   <xsl:apply-templates select="section|import" mode="contents" />
  </font>
 </xsl:otherwise>
</xsl:choose>

<xsl:if test="$create-body = 'yes'">
<xsl:apply-templates select="section|import"/>
</xsl:if>

</body>

</xsl:template>

<!-- Content definitions -->
<xsl:template name="section-content-expansion">
<li><a><xsl:attribute name="href">
        <xsl:if test="$create-contents-target != ''">
         <xsl:value-of select="$create-contents-target" />
         <xsl:text>-right.html</xsl:text>
        </xsl:if>
        <xsl:text>#</xsl:text>
        <xsl:value-of select="local-name(.)" />
        <xsl:text>_</xsl:text>
        <xsl:value-of select="translate(@title,$title-to-id-src,$title-to-id-map)" />
       </xsl:attribute>
       <xsl:if test="$create-contents-target != ''">
        <xsl:attribute name="target">
         <xsl:value-of select="$create-contents-target" />
        </xsl:attribute>
       </xsl:if>
       <xsl:value-of select="@title" />
    </a>
    <xsl:if test="subsection or
                  subsubsection or
                  category or
                  swi-definition or
                  entry-definition or
                  service-definition or
                  upcall-definition or
                  command-definition or
                  sysvar-definition or
                  error-definition or
                  message-definition or
                  vector-definition or
                  vdu-definition or
                  tboxmessage-definition or
                  tboxmethod-definition or
                  import">
     <ul><xsl:apply-templates mode="contents" /></ul>
    </xsl:if>
</li>
</xsl:template>

<xsl:template name="definition-content-expansion">
<li><a><xsl:attribute name="href">
        <xsl:if test="$create-contents-target != ''">
         <xsl:value-of select="$create-contents-target" />
         <xsl:text>-right.html</xsl:text>
        </xsl:if>
        <xsl:text>#</xsl:text>
        <xsl:value-of select="substring-before(local-name(.),'-')" />
        <xsl:text>_</xsl:text>
        <xsl:value-of select="translate(@name,$title-to-id-src,$title-to-id-map)" />
        <xsl:if test="@reason!=''">
         <xsl:text>-</xsl:text>
         <xsl:value-of select="translate(@reason,$title-to-id-src,$title-to-id-map)" />
        </xsl:if>
       </xsl:attribute>
       <xsl:if test="$create-contents-target != ''">
        <xsl:attribute name="target">
         <xsl:value-of select="$create-contents-target" />
        </xsl:attribute>
       </xsl:if>
       <xsl:variable name="deftype" select="substring-before(local-name(.),'-definition')" />
       <xsl:value-of select="document('')//localdb:definition-names[@type=$deftype]/@prefix" />
       <xsl:value-of select="@name" />
       <xsl:if test="((local-name(.)='message-definition') or
                      (local-name(.)='tboxmessage-definition')
                     ) and
                     (@number!='')">
        <xsl:text> (&amp;</xsl:text>
        <xsl:value-of select="@number" />
        <xsl:text>)</xsl:text>
       </xsl:if>
       <xsl:if test="@reason!=''">
        <xsl:text> </xsl:text>
        <xsl:value-of select="@reason" />
        <xsl:choose>
         <xsl:when test="@reasonname!=''">
          <xsl:text> - </xsl:text>
          <xsl:value-of select="@reasonname" />
         </xsl:when>
         <xsl:otherwise>
          <xsl:message>Reason number given, but no name specified at
   <xsl:call-template name="describeposition" />.</xsl:message>
         </xsl:otherwise>
        </xsl:choose>
       </xsl:if>
    </a>
</li>
</xsl:template>

<!-- metadata content entry -->
<xsl:template match="meta" mode="contents">
<li><a href="#metadata">Document information</a></li>
</xsl:template>

<!-- import directive -->
<xsl:template match="import" mode="contents">
<xsl:apply-templates select="saxon:evaluate(concat('document(@document)/',@path))" mode="contents" />
</xsl:template>

<!-- section sections -->
<xsl:template match="section|subsection|subsubsection|category" mode="contents">
<xsl:call-template name="section-content-expansion" />
</xsl:template>
<!-- definition sections -->
<xsl:template match="swi-definition|service-definition|upcall-definition|command-definition|entry-definition|sysvar-definition|error-definition|message-definition|vector-definition|vdu-definition|tboxmessage-definition|tboxmethod-definition" mode="contents">
<xsl:call-template name="definition-content-expansion" />
</xsl:template>
<!-- kill off plain text -->
<xsl:template match="text()" mode="contents" />

<!-- Sections -->
<xsl:template match="section">
<dl>
 <dt><h2><a>
          <xsl:attribute name="name">
           <xsl:text>section_</xsl:text>
           <xsl:value-of select="translate(@title,$title-to-id-src,$title-to-id-map)" />
          </xsl:attribute>
          <xsl:value-of select="@title" />
         </a></h2></dt>
 <xsl:for-each select="*">
  <xsl:choose>
   <xsl:when test="local-name(.)='subsection'">
    <xsl:apply-templates select="."/>
   </xsl:when>
   <xsl:otherwise>
    <dd>
     <dl>
      <dd>
       <xsl:apply-templates select="."/>
      </dd>
     </dl>
    </dd>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:for-each>
</dl>
<hr />
</xsl:template>

<!-- Sub-Sections -->
<xsl:template match="subsection">
<dt><h4><a>
          <xsl:attribute name="name">
           <xsl:text>subsection_</xsl:text>
           <xsl:value-of select="translate(@title,$title-to-id-src,$title-to-id-map)" />
          </xsl:attribute>
          <xsl:value-of select="@title" />
         </a></h4></dt>
<dd>
 <dl>
  <xsl:for-each select="*">
   <xsl:choose>
    <xsl:when test="local-name(.)='subsubsection'">
     <xsl:apply-templates select="."/>
    </xsl:when>
    <xsl:otherwise>
     <dd>
      <xsl:apply-templates select="."/>
     </dd>
    </xsl:otherwise>
   </xsl:choose>
  </xsl:for-each>
 </dl>
</dd>
</xsl:template>

<!-- Sub-Sub-Sections -->
<xsl:template match="subsubsection">
<dt><h4><a>
          <xsl:attribute name="name">
           <xsl:text>subsubsection_</xsl:text>
           <xsl:value-of select="translate(@title,$title-to-id-src,$title-to-id-map)" />
          </xsl:attribute>
          <xsl:value-of select="@title" />
         </a></h4></dt>
<dd>
 <xsl:apply-templates />
</dd>
</xsl:template>

<!-- Category -->
<xsl:template match="category">
<h5><b><a>
          <xsl:attribute name="name">
           <xsl:text>category_</xsl:text>
           <xsl:value-of select="translate(@title,$title-to-id-src,$title-to-id-map)" />
          </xsl:attribute>
          <xsl:value-of select="@title" />
         </a></b></h5>
<xsl:apply-templates />
</xsl:template>

<!-- command definitions ? -->
<xsl:template match="command-definition">
<hr />
<h2 align="right"><a>
          <xsl:attribute name="name">
           <xsl:text>command_</xsl:text>
           <xsl:value-of select="translate(@name,$title-to-id-src,$title-to-id-map)" />
          </xsl:attribute>
          <xsl:text>*</xsl:text><xsl:value-of select="@name"/>
         </a></h2>
<dd><xsl:value-of select="@description"/></dd>

<dt><h5>Syntax</h5></dt>
<dd>
<xsl:choose>
 <xsl:when test="count(syntax)=0">
  <code>*<xsl:value-of select="@name"/></code>
 </xsl:when>
 <xsl:otherwise>
  <xsl:for-each select="syntax">
   <code>*<xsl:value-of select="../@name"/>
    <xsl:apply-templates/>
   </code>
   <xsl:if test="position() != last()">
    <br />
   </xsl:if>
  </xsl:for-each>
 </xsl:otherwise>
</xsl:choose>
</dd>

<dt><h5>Parameters</h5></dt>
<dd>
<xsl:choose>
 <xsl:when test="count(parameter)=0">None</xsl:when>
 <xsl:otherwise>
  <table summary="Command parameters" border="0">
  <xsl:for-each select="parameter">
   <tr><td valign="top">
        <xsl:variable name="param">
         <xsl:if test="@label != ''">
          <xsl:value-of select="@label" />
          <xsl:text> </xsl:text>
         </xsl:if>
         <xsl:if test="@name != ''">
          <i>&lt;<xsl:value-of select="@name" />&gt;</i>
         </xsl:if>
        </xsl:variable>
        <xsl:choose>
         <xsl:when test="@switch-alias = ''">
          <code>
           <xsl:if test="@switch != ''">
            -<xsl:value-of select="@switch" />
            <xsl:text> </xsl:text>
           </xsl:if>
           <xsl:copy-of select="$param" />
          </code>
         </xsl:when>
         <xsl:otherwise>
          <xsl:if test="@switch = ''">
           <xsl:message>Parameter with switch-alias must be given a switch at
   <xsl:call-template name="describeposition" />.</xsl:message>
          </xsl:if>
          <table summary="Switch aliases">
           <tr><td>&#160;</td>
            <td valign="top" align="left">
             <code>
              <xsl:text>-</xsl:text>
              <xsl:value-of select="@switch" />
              <xsl:text> </xsl:text>
              <xsl:copy-of select="$param" />
             </code>
            </td>
           </tr>
           <tr><td><i>or</i></td>
            <td valign="top" align="left">
             <code>
              <xsl:text>-</xsl:text>
              <xsl:value-of select="@switch-alias" />
              <xsl:text> </xsl:text>
              <xsl:copy-of select="$param" />
             </code>
            </td>
           </tr>
          </table>
         </xsl:otherwise>
        </xsl:choose>
       </td>
       <td valign="top">-</td>
       <td valign="top"><xsl:apply-templates /></td>
   </tr>
  </xsl:for-each>
  </table>
 </xsl:otherwise>
</xsl:choose>
</dd>

<xsl:apply-templates select="use" />

<xsl:choose>
 <xsl:when test="count(example) > 0">
  <!-- I've probably missed an easier way to do this... -->
  <xsl:choose>
   <xsl:when test="count(example) = 1">
    <dt><h5>Example</h5></dt>
   </xsl:when>
   <xsl:otherwise>
    <dt><h5>Examples</h5></dt>
   </xsl:otherwise>
  </xsl:choose>

  <xsl:for-each select="example">
   <dd>
    <xsl:apply-templates />
   </dd>
  </xsl:for-each>
 </xsl:when>
</xsl:choose>

<xsl:apply-templates select="related" />

</xsl:template>

<!-- VDU definitions ? -->
<xsl:template match="vdu-definition">
<hr />
<h2 align="right"><a>
          <xsl:attribute name="name">
           <xsl:text>vdu_</xsl:text>
           <xsl:value-of select="translate(@name,$title-to-id-src,$title-to-id-map)" />
          </xsl:attribute>
          <xsl:text>VDU </xsl:text><xsl:value-of select="@name"/>
         </a></h2>
<dd><xsl:value-of select="@description"/></dd>

<dt><h5>Syntax</h5></dt>
<dd>
<xsl:choose>
 <xsl:when test="count(syntax)=0">
  <code>VDU <xsl:value-of select="@name"/></code>
 </xsl:when>
 <xsl:otherwise>
  <xsl:for-each select="syntax">
   <code>
    <xsl:apply-templates/>
   </code>
   <xsl:if test="position() != last()">
    <br />
   </xsl:if>
  </xsl:for-each>
 </xsl:otherwise>
</xsl:choose>
</dd>

<dt><h5>Parameters</h5></dt>
<dd>
<xsl:choose>
 <xsl:when test="count(parameter)=0">None</xsl:when>
 <xsl:otherwise>
  <table summary="Command parameters" border="0">
  <xsl:for-each select="parameter">
   <tr><td valign="top">
        <xsl:variable name="param">
         <xsl:if test="@name != ''">
          <i>&lt;<xsl:value-of select="@name" />&gt;</i>
         </xsl:if>
        </xsl:variable>
        <xsl:copy-of select="$param" />
        <!-- some warnings for bits that don't make sense -->
        <xsl:if test="@switch != ''">
         <xsl:message>VDU parameter should not have a switch at
   <xsl:call-template name="describeposition" />.</xsl:message>
        </xsl:if>
        <xsl:if test="@switch-alias != ''">
         <xsl:message>VDU parameter should not have a switch-alias at
   <xsl:call-template name="describeposition" />.</xsl:message>
        </xsl:if>
        <xsl:if test="@label != ''">
         <xsl:message>VDU parameter should not have a label at
   <xsl:call-template name="describeposition" />.</xsl:message>
        </xsl:if>
       </td>
       <td valign="top">-</td>
       <td valign="top"><xsl:apply-templates /></td>
   </tr>
  </xsl:for-each>
  </table>
 </xsl:otherwise>
</xsl:choose>
</dd>

<xsl:apply-templates select="use" />

<xsl:choose>
 <xsl:when test="count(example) > 0">
  <!-- I've probably missed an easier way to do this... -->
  <xsl:choose>
   <xsl:when test="count(example) = 1">
    <dt><h5>Example</h5></dt>
   </xsl:when>
   <xsl:otherwise>
    <dt><h5>Examples</h5></dt>
   </xsl:otherwise>
  </xsl:choose>

  <xsl:for-each select="example">
   <dd>
    <xsl:apply-templates />
   </dd>
  </xsl:for-each>
 </xsl:when>
</xsl:choose>

<xsl:apply-templates select="related" />

</xsl:template>

<xsl:template match="related" mode="meta">
<xsl:choose>
 <xsl:when test="count(reference[@type='document']) = 0">
  <xsl:text>None</xsl:text>
 </xsl:when>

 <xsl:otherwise>
  <xsl:for-each select="reference[@type='document']">
   <xsl:apply-templates select="." />
   <br />
  </xsl:for-each>
 </xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="related">
<xsl:choose>
 <xsl:when test="count(*) = 0">
  <dt><h5>Related APIs</h5></dt>
  <dd>None</dd>
 </xsl:when>

 <xsl:otherwise>
  <xsl:if test="count(reference[@type='command']) > 0">
   <dt><h5>Related * commands</h5></dt>
   <dd>
   <xsl:for-each select="reference[@type='command']">
   <xsl:if test="position() > 1">, </xsl:if>
    <xsl:apply-templates select="." />
   </xsl:for-each>
   </dd>
  </xsl:if>

  <xsl:if test="count(reference[@type='swi']) > 0">
   <dt><h5>Related SWIs</h5></dt>
   <dd>
   <xsl:for-each select="reference[@type='swi']">
   <xsl:if test="position() > 1">, </xsl:if>
    <xsl:apply-templates select="." />
   </xsl:for-each>
   </dd>
  </xsl:if>

  <xsl:if test="count(reference[@type='service']) > 0">
   <dt><h5>Related services</h5></dt>
   <dd>
   <xsl:for-each select="reference[@type='service']">
   <xsl:if test="position() > 1">, </xsl:if>
    <xsl:apply-templates select="." />
   </xsl:for-each>
   </dd>
  </xsl:if>

  <xsl:if test="count(reference[@type='tboxmethod']) > 0">
   <dt><h5>Related Toolbox methods</h5></dt>
   <dd>
   <xsl:for-each select="reference[@type='tboxmethod']">
   <xsl:if test="position() > 1">, </xsl:if>
    <xsl:apply-templates select="." />
   </xsl:for-each>
   </dd>
  </xsl:if>

  <xsl:if test="count(reference[@type='tboxmessage']) > 0">
   <dt><h5>Related Toolbox messages</h5></dt>
   <dd>
   <xsl:for-each select="reference[@type='tboxmessage']">
   <xsl:if test="position() > 1">, </xsl:if>
    <xsl:apply-templates select="." />
   </xsl:for-each>
   </dd>
  </xsl:if>

  <xsl:if test="count(reference[@type='vector']) > 0">
   <dt><h5>Related vectors</h5></dt>
   <dd>
   <xsl:for-each select="reference[@type='vector']">
   <xsl:if test="position() > 1">, </xsl:if>
    <xsl:apply-templates select="." />
   </xsl:for-each>
   </dd>
  </xsl:if>

  <xsl:if test="count(reference[@type='upcall']) > 0">
   <dt><h5>Related upcalls</h5></dt>
   <dd>
   <xsl:for-each select="reference[@type='upcall']">
   <xsl:if test="position() > 1">, </xsl:if>
    <xsl:apply-templates select="." />
   </xsl:for-each>
   </dd>
  </xsl:if>

  <xsl:if test="count(reference[@type='error']) > 0">
   <dt><h5>Related error messages</h5></dt>
   <dd>
   <xsl:for-each select="reference[@type='error']">
   <xsl:if test="position() > 1">, </xsl:if>
    <xsl:apply-templates select="." />
   </xsl:for-each>
   </dd>
  </xsl:if>

  <xsl:if test="count(reference[@type='sysvar']) > 0">
   <dt><h5>Related system variables</h5></dt>
   <dd>
   <xsl:for-each select="reference[@type='sysvar']">
   <xsl:if test="position() > 1">, </xsl:if>
    <xsl:apply-templates select="." />
   </xsl:for-each>
   </dd>
  </xsl:if>

  <xsl:if test="count(reference[@type='entry']) > 0">
   <dt><h5>Related entry points</h5></dt>
   <dd>
   <xsl:for-each select="reference[@type='entry']">
   <xsl:if test="position() > 1">, </xsl:if>
    <xsl:apply-templates select="." />
   </xsl:for-each>
   </dd>
  </xsl:if>

  <xsl:if test="count(reference[@type='message']) > 0">
   <dt><h5>Related messages</h5></dt>
   <dd>
   <xsl:for-each select="reference[@type='message']">
   <xsl:if test="position() > 1">, </xsl:if>
    <xsl:apply-templates select="." />
   </xsl:for-each>
   </dd>
  </xsl:if>

  <xsl:if test="count(reference[@type='vdu']) > 0">
   <dt><h5>Related VDU codes</h5></dt>
   <dd>
   <xsl:for-each select="reference[@type='vdu']">
   <xsl:if test="position() > 1">, </xsl:if>
    <xsl:apply-templates select="." />
   </xsl:for-each>
   </dd>
  </xsl:if>
 </xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="use">
<dt><h5>Use</h5></dt>
<dd>
 <xsl:apply-templates />
</dd>
</xsl:template>

<!-- SWI definition -->
<!-- A SWI definition can have an offset defined, instead of a number, which is used for those cases
     where multiple provides all use the same interface. For example FileCore modules or DCI drivers.
 -->
<xsl:template match="swi-definition|vector-definition">
<xsl:variable name="deftype" select="substring-before(local-name(.),'-definition')" />
<xsl:variable name="defsingular" select="document('')//localdb:definition-names[@type=$deftype]/@singular" />
<hr />
<h2 align="right"><a>
          <xsl:attribute name="name">
           <xsl:value-of select="$deftype" />
           <xsl:text>_</xsl:text>
           <xsl:value-of select="translate(@name,$title-to-id-src,$title-to-id-map)" />
           <xsl:if test="@reason!=''">
            <xsl:text>-</xsl:text>
            <xsl:value-of select="translate(@reason,$title-to-id-src,$title-to-id-map)" />
           </xsl:if>
          </xsl:attribute>
          <xsl:value-of select="@name"/>
<!--     <xsl:if test="(@reason != '') and (@reasonname != '')"> -->
<!--      <xsl:text> </xsl:text> -->
<!--      <xsl:value-of select="@reasonname"/> -->
<!--     </xsl:if> -->
    <xsl:if test="@reason != ''">
     <xsl:text> </xsl:text>
     <xsl:value-of select="@reason"/>
    </xsl:if>
    </a>
    <br />
    (<acronym>
     <xsl:value-of select="$defsingular" />
     <xsl:choose>
      <xsl:when test="@offset != ''">
       <xsl:text> </xsl:text>
       <xsl:value-of select="@offset-base"/>
       <xsl:text>+&amp;</xsl:text>
       <xsl:value-of select="@offset"/>
      </xsl:when>
      <xsl:otherwise>
       <xsl:text> &amp;</xsl:text>
       <xsl:value-of select="@number"/>
      </xsl:otherwise>
     </xsl:choose>
     </acronym>
<!--     <xsl:if test="@reason != ''"> -->
<!--      <xsl:text> reason </xsl:text> -->
<!--      <xsl:value-of select="@reason"/> -->
<!--     </xsl:if> -->
    <xsl:text>)</xsl:text></h2>
<xsl:choose>
 <xsl:when test="@internal = 'yes'">
 <dd><p>This <xsl:value-of select="$defsingular" /> call is for internal
        use only. You must not use it in your own code.</p></dd></xsl:when>
 <xsl:otherwise>
  <dd><xsl:value-of select="@description"/></dd>

  <dt><h5>On entry</h5></dt>
  <dd>
  <xsl:choose>
   <xsl:when test="count(entry/*)=0">None</xsl:when>
   <xsl:otherwise>
    <table summary="{concat('Conditions on entry to ',$defsingular)}" border="0">
    <xsl:apply-templates select="entry"/>
    </table>
   </xsl:otherwise>
  </xsl:choose>
  </dd>

  <dt><h5>On exit</h5></dt>
  <dd>
  <xsl:choose>
   <xsl:when test="count(exit/*)=0">None</xsl:when>
   <xsl:otherwise>
    <table summary="{concat('Conditions on exit from ',$defsingular)}" border="0">
    <xsl:apply-templates select="exit"/>
    </table>
   </xsl:otherwise>
  </xsl:choose>
  </dd>

  <dt><h5>Interrupts</h5></dt>
  <dd>Interrupts are <xsl:value-of select="@irqs" /><br />
      Fast interrupts are <xsl:value-of select="@fiqs"/></dd>

  <dt><h5>Processor mode</h5></dt>
  <dd>Processor is in <xsl:value-of select="@processor-mode"/> mode
  </dd>

  <dt><h5>Re-entrancy</h5></dt>
  <dd>
  <xsl:choose>
    <xsl:when test='@re-entrant="yes"'><xsl:value-of select="$defsingular" /> is re-entrant</xsl:when>
    <xsl:when test='@re-entrant="undefined"'>Not defined</xsl:when>
    <xsl:when test='@re-entrant="no"'><xsl:value-of select="$defsingular" /> is not re-entrant</xsl:when>
    <xsl:otherwise><xsl:value-of select="@re-entrant"/></xsl:otherwise>
  </xsl:choose>
  </dd>

  <xsl:apply-templates select="use" />

  <xsl:choose>
   <xsl:when test="count(example) > 0">
    <!-- I've probably missed an easier way to do this... -->
    <xsl:choose>
     <xsl:when test="count(example) = 1">
      <dt><h5>Example</h5></dt>
     </xsl:when>
     <xsl:otherwise>
      <dt><h5>Examples</h5></dt>
     </xsl:otherwise>
    </xsl:choose>

    <xsl:for-each select="example">
     <dd>
      <xsl:apply-templates />
     </dd>
    </xsl:for-each>
   </xsl:when>
  </xsl:choose>

  <xsl:apply-templates select="declaration" />

  <xsl:apply-templates select="related" />

 </xsl:otherwise>
</xsl:choose>

</xsl:template>

<!-- Entry-point definition -->
<xsl:template match="entry-definition">
<hr />
<h2 align="right"><a>
          <xsl:attribute name="name">
           <xsl:text>entry_</xsl:text>
           <xsl:value-of select="translate(@name,$title-to-id-src,$title-to-id-map)" />
           <xsl:if test="@reason!=''">
            <xsl:text>-</xsl:text>
            <xsl:value-of select="translate(@reason,$title-to-id-src,$title-to-id-map)" />
           </xsl:if>
          </xsl:attribute>
          <xsl:value-of select="@name"/>
<!--     <xsl:if test="(@reason != '') and (@reasonname != '')"> -->
<!--      <xsl:text> </xsl:text> -->
<!--      <xsl:value-of select="@reasonname"/> -->
<!--     </xsl:if> -->
    <xsl:if test="@reason != ''">
     <xsl:text> </xsl:text>
     <xsl:value-of select="@reason"/>
    </xsl:if>
    </a>
    <xsl:if test="@number != ''">
     <br />
     (<acronym>&amp;<xsl:value-of select="@number"/></acronym>
<!--      <xsl:if test="@reason != ''"> -->
<!--       <xsl:text> reason </xsl:text> -->
<!--       <xsl:value-of select="@reason"/> -->
<!--      </xsl:if> -->
     <xsl:text>)</xsl:text>
    </xsl:if>
    </h2>
<xsl:choose>
 <xsl:when test="@internal = 'yes'">
 <dd><p>This entry-point is for internal use only. You must not use it in
        your own code.</p></dd></xsl:when>
 <xsl:otherwise>
  <dd><xsl:value-of select="@description"/></dd>

  <dt><h5>On entry</h5></dt>
  <dd>
  <xsl:choose>
   <xsl:when test="count(entry/*)=0">None</xsl:when>
   <xsl:otherwise>
    <table summary="Conditions on entry to entry-point" border="0">
    <xsl:apply-templates select="entry"/>
    </table>
   </xsl:otherwise>
  </xsl:choose>
  </dd>

  <dt><h5>On exit</h5></dt>
  <dd>
  <xsl:choose>
   <xsl:when test="count(exit/*)=0">None</xsl:when>
   <xsl:otherwise>
    <table summary="Conditions on exit from entry-point" border="0">
    <xsl:apply-templates select="exit"/>
    </table>
   </xsl:otherwise>
  </xsl:choose>
  </dd>

  <dt><h5>Interrupts</h5></dt>
  <dd>Interrupts are <xsl:value-of select="@irqs" /><br />
      Fast interrupts are <xsl:value-of select="@fiqs"/></dd>

  <dt><h5>Processor mode</h5></dt>
  <dd>Processor is in <xsl:value-of select="@processor-mode"/> mode
  </dd>

  <dt><h5>Re-entrancy</h5></dt>
  <dd>
  <xsl:choose>
    <xsl:when test='@re-entrant="yes"'>Entry-point is re-entrant</xsl:when>
    <xsl:when test='@re-entrant="undefined"'>Not defined</xsl:when>
    <xsl:when test='@re-entrant="no"'>Entry-point is not re-entrant</xsl:when>
    <xsl:otherwise><xsl:value-of select="@re-entrant"/></xsl:otherwise>
  </xsl:choose>
  </dd>

  <xsl:apply-templates select="use" />

  <xsl:choose>
   <xsl:when test="count(example) > 0">
    <!-- I've probably missed an easier way to do this... -->
    <xsl:choose>
     <xsl:when test="count(example) = 1">
      <dt><h5>Example</h5></dt>
     </xsl:when>
     <xsl:otherwise>
      <dt><h5>Examples</h5></dt>
     </xsl:otherwise>
    </xsl:choose>

    <xsl:for-each select="example">
     <dd>
      <xsl:apply-templates />
     </dd>
    </xsl:for-each>
   </xsl:when>
  </xsl:choose>

  <xsl:apply-templates select="related" />

 </xsl:otherwise>
</xsl:choose>

</xsl:template>


<!-- Wimp Message definition -->
<xsl:template match="message-definition|tboxmessage-definition">
<xsl:variable name="deftype" select="substring-before(local-name(.),'-definition')" />
<xsl:variable name="defsingular" select="document('')//localdb:definition-names[@type=$deftype]/@singular" />
<hr />
<h2 align="right"><a>
          <xsl:attribute name="name">
           <xsl:value-of select="$deftype" />
           <xsl:text>_</xsl:text>
           <xsl:value-of select="translate(@name,$title-to-id-src,$title-to-id-map)" />
           <xsl:if test="@reason!=''">
            <xsl:text>-</xsl:text>
            <xsl:value-of select="translate(@reason,$title-to-id-src,$title-to-id-map)" />
           </xsl:if>
          </xsl:attribute>
          <xsl:choose>
           <xsl:when test="$deftype = 'message'">
            <xsl:text>Message_</xsl:text><xsl:value-of select="@name"/>
           </xsl:when>
           <xsl:when test="$deftype = 'tboxmessage'">
            <xsl:value-of select="@name"/>
           </xsl:when>
          </xsl:choose>
<!--     <xsl:if test="(@reason != '') and (@reasonname != '')"> -->
<!--      <xsl:text> </xsl:text> -->
<!--      <xsl:value-of select="@reasonname"/> -->
<!--     </xsl:if> -->
    <xsl:if test="@reason != ''">
     <xsl:text> </xsl:text>
     <xsl:value-of select="@reason"/>
    </xsl:if>
    </a>
    <br />
    (<acronym>&amp;<xsl:value-of select="@number"/></acronym>)
    </h2>
<xsl:choose>
 <xsl:when test="@internal = 'yes'">
 <dd><p>This Message is for internal use only. You must not use it in
        your own code.</p></dd></xsl:when>
 <xsl:otherwise>
  <dd><xsl:value-of select="@description"/></dd>

  <dt><h5>Message</h5></dt>
  <dd>
  <xsl:choose>
   <xsl:when test="count(message-table)>0">
    <xsl:apply-templates select="message-table" />
   </xsl:when>

   <xsl:when test="count(value-table)>0">
    <xsl:apply-templates select="value-table" />
   </xsl:when>

   <xsl:when test="count(offset-table)>0">
    <xsl:apply-templates select="offset-table" />
   </xsl:when>

   <xsl:otherwise>
    <xsl:text>No additional data</xsl:text>
   </xsl:otherwise>
  </xsl:choose>
  </dd>

  <xsl:if test="$deftype = 'message'">
   <!-- Source and destination only apply to messages -->
   <xsl:if test="@source!=''">
    <dt><h5>Source</h5></dt>
    <dd>
    <xsl:choose>
     <xsl:when test="@source='*'">Any application</xsl:when>
     <xsl:otherwise><xsl:value-of select="@source" /></xsl:otherwise>
    </xsl:choose>
    </dd>
   </xsl:if>

   <xsl:if test="@destination!=''">
    <dt><h5>Destination</h5></dt>
    <dd>
    <xsl:choose>
     <xsl:when test="@destination='*'">Any application</xsl:when>
     <xsl:otherwise><xsl:value-of select="@destination" /></xsl:otherwise>
    </xsl:choose>
    </dd>
   </xsl:if>

   <dt><h5>Delivery</h5></dt>
   <dd>
   <xsl:choose>
    <xsl:when test="@broadcast='never'">Message must be sent directly to task</xsl:when>
    <xsl:when test="@broadcast='may'">Message may sent directly to task, or by broadcast (destination 0)</xsl:when>
    <xsl:when test="@broadcast='must'">Message must be broadcast (destination 0)</xsl:when>
    <xsl:otherwise>
     <xsl:message>Message 'broadcast' type not understood at
   <xsl:call-template name="describeposition" />.</xsl:message>
    </xsl:otherwise>
   </xsl:choose>
   <br />

   <xsl:choose>
    <xsl:when test="@recorded='never'">Message may only be sent normally (reason code 17)</xsl:when>
    <xsl:when test="@recorded='may'">Message may sent recorded delivery (reason code 18) or normally (reason code 17)</xsl:when>
    <xsl:when test="@recorded='must'">Message must be sent recorded delivery (reason code 18)</xsl:when>
    <xsl:otherwise>
     <xsl:message>Message 'recorded' type not understood at
   <xsl:call-template name="describeposition" />.</xsl:message>
    </xsl:otherwise>
   </xsl:choose>
   </dd>
  </xsl:if>

  <xsl:apply-templates select="use" />

  <xsl:apply-templates select="declaration" />

  <xsl:apply-templates select="related" />

 </xsl:otherwise>
</xsl:choose>

</xsl:template>


<!-- System Variable definition -->
<xsl:template match="sysvar-definition">
<hr />
<h2 align="right"><a>
          <xsl:attribute name="name">
           <xsl:text>sysvar_</xsl:text>
           <xsl:value-of select="translate(@name,$title-to-id-src,$title-to-id-map)" />
          </xsl:attribute>
          <xsl:value-of select="@name"/>
    </a>
    </h2>
<xsl:choose>
 <xsl:when test="@internal = 'yes'">
 <dd><p>This System Variable is for internal use only. You must not use it in
        your own code.</p></dd></xsl:when>
 <xsl:otherwise>
  <dd><xsl:value-of select="@description"/></dd>

  <xsl:apply-templates select="use" />

  <xsl:apply-templates select="related" />

 </xsl:otherwise>
</xsl:choose>

</xsl:template>


<!-- Error definition -->
<xsl:template match="error-definition">
<hr />
<h2 align="right"><a>
          <xsl:attribute name="name">
           <xsl:text>error_</xsl:text>
           <xsl:value-of select="translate(@name,$title-to-id-src,$title-to-id-map)" />
          </xsl:attribute>
          <xsl:text>Error_</xsl:text><xsl:value-of select="@name"/>
    </a>
    (<acronym>Error &amp;<xsl:value-of select="@number"/></acronym>
    <xsl:text>)</xsl:text>
    </h2>
<xsl:choose>
 <xsl:when test="@internal = 'yes'">
 <!-- huh ? this message should never come up, 'cos /any/ error might
      occur, so it's best to document 'em. But for consistencies sake... -->
 <dd><p>This Error is for internal use only. You should never see it.
        </p></dd></xsl:when>
 <xsl:otherwise>
  <dd><xsl:value-of select="@description"/></dd>

  <xsl:apply-templates select="use" />

  <xsl:apply-templates select="related" />

 </xsl:otherwise>
</xsl:choose>

</xsl:template>


<!-- Service definition -->
<xsl:template match="service-definition">
<hr />
<h2 align="right"><a>
          <xsl:attribute name="name">
           <xsl:text>service_</xsl:text>
           <xsl:value-of select="translate(@name,$title-to-id-src,$title-to-id-map)" />
           <xsl:if test="@reason!=''">
            <xsl:text>-</xsl:text>
            <xsl:value-of select="translate(@reason,$title-to-id-src,$title-to-id-map)" />
           </xsl:if>
          </xsl:attribute>
          <xsl:text>Service_</xsl:text><xsl:value-of select="@name"/>
<!--     <xsl:if test="(@reason != '') and (@reasonname != '')"> -->
<!--      <xsl:text> </xsl:text> -->
<!--      <xsl:value-of select="@reasonname"/> -->
<!--     </xsl:if> -->
    <xsl:if test="@reason != ''">
     <xsl:text> </xsl:text>
     <xsl:value-of select="@reason"/>
    </xsl:if>
    </a>
    <br />
    (<acronym>Service &amp;<xsl:value-of select="@number"/></acronym>
<!--     <xsl:if test="@reason != ''"> -->
<!--      <xsl:text> reason </xsl:text> -->
<!--      <xsl:value-of select="@reason"/> -->
<!--     </xsl:if> -->
    <xsl:text>)</xsl:text></h2>
<xsl:choose>
 <xsl:when test="@internal = 'yes'">
 <dd><p>This Service call is for internal use only. You must not use it in
        your own code.</p></dd></xsl:when>
 <xsl:otherwise>
  <dd><xsl:value-of select="@description"/></dd>

  <dt><h5>On entry</h5></dt>
  <dd>
  <xsl:choose>
   <xsl:when test="count(entry/*)=0">None</xsl:when>
   <xsl:otherwise>
    <table summary="Conditions on entry to Service call" border="0">
    <xsl:apply-templates select="entry"/>
    </table>
   </xsl:otherwise>
  </xsl:choose>
  </dd>

  <dt><h5>On exit</h5></dt>
  <dd>
  <xsl:choose>
   <xsl:when test="count(exit/*)=0">None</xsl:when>
   <xsl:otherwise>
    <table summary="Conditions on exit from Service call" border="0">
    <xsl:apply-templates select="exit"/>
    </table>
   </xsl:otherwise>
  </xsl:choose>
  </dd>

  <xsl:apply-templates select="use" />

  <xsl:choose>
   <xsl:when test="count(example) > 0">
    <!-- I've probably missed an easier way to do this... -->
    <xsl:choose>
     <xsl:when test="count(example) = 1">
      <dt><h5>Example</h5></dt>
     </xsl:when>
     <xsl:otherwise>
      <dt><h5>Examples</h5></dt>
     </xsl:otherwise>
    </xsl:choose>

    <xsl:for-each select="example">
     <dd>
      <xsl:apply-templates />
     </dd>
    </xsl:for-each>
   </xsl:when>
  </xsl:choose>

  <xsl:apply-templates select="related" />

 </xsl:otherwise>
</xsl:choose>

</xsl:template>


<!-- Toolbox Method definition -->
<xsl:template match="tboxmethod-definition">
<hr />
<h2 align="right"><a>
          <xsl:attribute name="name">
           <xsl:text>tboxmethod_</xsl:text>
           <xsl:value-of select="translate(@name,$title-to-id-src,$title-to-id-map)" />
           <xsl:if test="@reason!=''">
            <xsl:text>-</xsl:text>
            <xsl:value-of select="translate(@reason,$title-to-id-src,$title-to-id-map)" />
           </xsl:if>
          </xsl:attribute>
          <xsl:value-of select="@name"/>
<!--     <xsl:if test="(@reason != '') and (@reasonname != '')"> -->
<!--      <xsl:text> </xsl:text> -->
<!--      <xsl:value-of select="@reasonname"/> -->
<!--     </xsl:if> -->
    <xsl:if test="@reason != ''">
     <xsl:text> </xsl:text>
     <xsl:value-of select="@reason"/>
    </xsl:if>
    </a>
    <br />
    (<acronym>Method &amp;<xsl:value-of select="@number"/></acronym>
<!--     <xsl:if test="@reason != ''"> -->
<!--      <xsl:text> reason </xsl:text> -->
<!--      <xsl:value-of select="@reason"/> -->
<!--     </xsl:if> -->
    <xsl:text>)</xsl:text></h2>
<xsl:choose>
 <xsl:when test="@internal = 'yes'">
 <dd><p>This Method call is for internal use only. You must not use it in
        your own code.</p></dd></xsl:when>
 <xsl:otherwise>
  <dd><xsl:value-of select="@description"/></dd>

  <dt><h5>On entry</h5></dt>
  <dd>
  <xsl:choose>
   <xsl:when test="count(entry/*)=0">None</xsl:when>
   <xsl:otherwise>
    <table summary="Conditions on entry to Method call" border="0">
    <xsl:apply-templates select="entry"/>
    </table>
   </xsl:otherwise>
  </xsl:choose>
  </dd>

  <dt><h5>On exit</h5></dt>
  <dd>
  <xsl:choose>
   <xsl:when test="count(exit/*)=0">None</xsl:when>
   <xsl:otherwise>
    <table summary="Conditions on exit from Method call" border="0">
    <xsl:apply-templates select="exit"/>
    </table>
   </xsl:otherwise>
  </xsl:choose>
  </dd>

  <xsl:apply-templates select="use" />

  <xsl:choose>
   <xsl:when test="count(example) > 0">
    <!-- I've probably missed an easier way to do this... -->
    <xsl:choose>
     <xsl:when test="count(example) = 1">
      <dt><h5>Example</h5></dt>
     </xsl:when>
     <xsl:otherwise>
      <dt><h5>Examples</h5></dt>
     </xsl:otherwise>
    </xsl:choose>

    <xsl:for-each select="example">
     <dd>
      <xsl:apply-templates />
     </dd>
    </xsl:for-each>
   </xsl:when>
  </xsl:choose>

  <xsl:apply-templates select="related" />

 </xsl:otherwise>
</xsl:choose>

</xsl:template>

<!-- Upcall definition -->
<xsl:template match="upcall-definition">
<hr />
<h2 align="right"><a>
          <xsl:attribute name="name">
           <xsl:text>upcall_</xsl:text>
           <xsl:value-of select="translate(@name,$title-to-id-src,$title-to-id-map)" />
           <xsl:if test="@reason!=''">
            <xsl:text>-</xsl:text>
            <xsl:value-of select="translate(@reason,$title-to-id-src,$title-to-id-map)" />
           </xsl:if>
          </xsl:attribute>
          <xsl:text>UpCall_</xsl:text><xsl:value-of select="@name"/>
<!--     <xsl:if test="(@reason != '') and (@reasonname != '')"> -->
<!--      <xsl:text> </xsl:text> -->
<!--      <xsl:value-of select="@reasonname"/> -->
<!--     </xsl:if> -->
    <xsl:if test="@reason != ''">
     <xsl:text> </xsl:text>
     <xsl:value-of select="@reason"/>
    </xsl:if>
    </a>
    <br />
    (<acronym>UpCall &amp;<xsl:value-of select="@number"/></acronym>
<!--     <xsl:if test="@reason != ''"> -->
<!--      <xsl:text> reason </xsl:text> -->
<!--      <xsl:value-of select="@reason"/> -->
<!--     </xsl:if> -->
    <xsl:text>)</xsl:text></h2>
<xsl:choose>
 <xsl:when test="@internal = 'yes'">
 <dd><p>This UpCall is for internal use only. You must not use it in your
        own code.</p></dd></xsl:when>
 <xsl:otherwise>
  <dd><xsl:value-of select="@description"/></dd>

  <dt><h5>On entry</h5></dt>
  <dd>
  <xsl:choose>
   <xsl:when test="count(entry/*)=0">None</xsl:when>
   <xsl:otherwise>
    <table summary="Conditions on entry to UpCall" border="0">
    <xsl:apply-templates select="entry"/>
    </table>
   </xsl:otherwise>
  </xsl:choose>
  </dd>

  <dt><h5>On exit</h5></dt>
  <dd>
  <xsl:choose>
   <xsl:when test="count(exit/*)=0">None</xsl:when>
   <xsl:otherwise>
    <table summary="Conditions on exit from UpCall" border="0">
    <xsl:apply-templates select="exit"/>
    </table>
   </xsl:otherwise>
  </xsl:choose>
  </dd>

  <xsl:apply-templates select="use" />

  <xsl:apply-templates select="related" />

 </xsl:otherwise>
</xsl:choose>

</xsl:template>

<xsl:template match="use">
<dt><h5>Use</h5></dt>
<dd>
 <xsl:apply-templates />
</dd>
</xsl:template>

<!-- Register -->
<xsl:template match="register-use">
<tr>
 <td valign="top" align="right">R<xsl:value-of select="@number"/></td>
  <xsl:choose>
   <xsl:when test="@state='preserved'">
    <!-- preserved is used on output registers -->
    <td valign="top" align="left" colspan="2">preserved</td>
   </xsl:when>
   <xsl:when test="@state='corrupted'">
    <!-- corrupted is used on output registers -->
    <td valign="top" align="left" colspan="2">corrupted</td>
   </xsl:when>
   <xsl:when test="@state='undefined'">
    <!-- undefined is used on input registers -->
    <td valign="top" align="left" colspan="2">undefined</td>
   </xsl:when>
   <xsl:otherwise>
    <td valign="top">=</td>
    <td valign="top" align="left">
     <xsl:apply-templates/>
    </td>
   </xsl:otherwise>
  </xsl:choose>
</tr>
</xsl:template>

<!-- Processor flags, on exit from a routine -->
<xsl:template match="processor-flag">
<tr>
<xsl:choose>
 <xsl:when test="@state='content'">
  <td valign="top" align="right"><xsl:value-of select="@name"/></td>
  <td valign="top" align="left" colspan="2"><xsl:apply-templates/></td>
 </xsl:when>
 <xsl:otherwise>
  <td valign="top" align="right"><xsl:value-of select="@name"/></td>
  <td valign="top" align="left" colspan="2">
   <xsl:value-of select="@state"/>
   <xsl:text> </xsl:text>
   <xsl:apply-templates/>
  </td>
 </xsl:otherwise>
</xsl:choose>
</tr>
</xsl:template>


<!-- A bitfield-table turns into a regular XHTML table, with header -->
<xsl:template match="bitfield-table">
<table summary="A bitfield" border="0">
 <tr>
 <xsl:choose>
  <xsl:when test="count(*/@state)=0">
   <th align="right" valign="bottom">Bit</th>
   <xsl:if test="count(*/@name)>0">
    <th align="left" valign="bottom">Name</th>
   </xsl:if>
   <th align="left" valign="bottom">Meaning if set</th>
  </xsl:when>
  <xsl:otherwise>
   <th align="right" valign="bottom">Bit(s)</th>
   <xsl:if test="count(*/@name)>0">
    <th align="left" valign="bottom">Name</th>
   </xsl:if>
   <th align="left" valign="bottom">Meaning</th>
  </xsl:otherwise>
 </xsl:choose>
 </tr>
 <xsl:apply-templates/>
</table>
</xsl:template>

<!-- notice that we do some complex matching here to ensure that we put
     the set and clear bit values in what appears to be a sub-table,
     thus preventing the double use of the bit number in the heading -->
<xsl:template match="bit">
<!-- Note: preceding-sibling returns nodes going backward from the current node -->
<xsl:variable name="lastelement" select="preceding-sibling::bit[1]" />
<xsl:if test="not( ($lastelement/@number = @number) and
                   ($lastelement/@state != '') )">
 <!-- We only want to process the first of any sets of rows -->
 <tr>
  <td valign="top" align="right"><xsl:value-of select="@number"/></td>
  <xsl:if test="count(../*/@name)>0">
   <td valign="top"><xsl:value-of select="@name"/></td>
  </xsl:if>

  <xsl:choose>
   <xsl:when test="@state = 'reserved'">
    <td valign="top" align="left" colspan="2">
     <xsl:text>Reserved, must be zero</xsl:text>
    </td>
   </xsl:when>

   <xsl:when test="(@state = 'set') or (@state = 'clear')">
    <td valign="top" align="right">
     <xsl:choose>
      <xsl:when test="@state='set'"><xsl:text>Set:</xsl:text></xsl:when>
      <xsl:otherwise><xsl:text>Clear:</xsl:text></xsl:otherwise>
     </xsl:choose>
    </td>
    <td valign="top" align="left">
     <xsl:apply-templates/>
    </td>

    <xsl:variable name="nextelement" select="following-sibling::bit[position() = 1]" />
    <xsl:if test="($nextelement/@number = @number) and
                  ($nextelement/@state != '')">
     <tr>
      <td></td>
      <xsl:if test="count(../*/@name)>0">
       <td valign="top"><xsl:value-of select="$nextelement/@name"/></td>
      </xsl:if>

      <td valign="top" align="right">
       <xsl:choose>
        <xsl:when test="$nextelement/@state='set'"><xsl:text>Set:</xsl:text></xsl:when>
        <xsl:otherwise><xsl:text>Clear:</xsl:text></xsl:otherwise>
       </xsl:choose>
      </td>
      <td valign="top" align="left">
       <xsl:apply-templates select="$nextelement/node()"/>
      </td>
     </tr>
    </xsl:if>
   </xsl:when>

   <xsl:otherwise>
    <td valign="top" align="left" colspan="2">
     <xsl:apply-templates/>
    </td>
   </xsl:otherwise>
  </xsl:choose>
 </tr>
</xsl:if>
</xsl:template>

<!-- A value table is just a table of values with headings -->
<xsl:template match="value-table">
<table summary="Opaque table of values" border="0">
 <tr>
  <th align="right" valign="bottom"><xsl:value-of select="@head-number" /></th>
  <xsl:if test="@head-name != ''">
   <th align="left" valign="bottom"><xsl:value-of select="@head-name" /></th>
  </xsl:if>
  <th align="left" valign="bottom"><xsl:value-of select="@head-value" /></th>
 </tr>
 <xsl:apply-templates/>
</table>
</xsl:template>

<xsl:template match="value">
<tr>
 <td valign="top" align="right"><xsl:value-of select="@number"/></td>
 <xsl:if test="../*/@name != ''">
  <td valign="top" align="left"><xsl:value-of select="@name"/></td>
 </xsl:if>
 <td valign="top" align="left">
  <xsl:choose>
   <xsl:when test="count(p) = 1">
    <!-- Botch to stop tables looking shite on most browsers -->
    <xsl:apply-templates select="p/*|p/text()"/>
   </xsl:when>
   <xsl:otherwise>
    <xsl:apply-templates />
   </xsl:otherwise>
  </xsl:choose>
 </td>
</tr>
</xsl:template>

<!-- An offset table is similar to the value-table -->
<xsl:template match="offset-table">
<table summary="Opaque table of offset/contents" border="0">
 <tr>
  <th align="right" valign="bottom"><xsl:value-of select="@head-number" /></th>
  <xsl:if test="@head-name != ''">
   <th align="left" valign="bottom"><xsl:value-of select="@head-name" /></th>
  </xsl:if>
  <th align="left" valign="bottom"><xsl:value-of select="@head-value" /></th>
 </tr>
 <xsl:apply-templates/>
</table>
</xsl:template>

<xsl:template match="offset">
<tr>
 <td valign="top" align="right">+<xsl:value-of select="@number"/></td>
 <xsl:if test="../*/@name != ''">
  <td valign="top" align="left"><xsl:value-of select="@name"/></td>
 </xsl:if>
 <td valign="top" align="left"><xsl:apply-templates/></td>
</tr>
</xsl:template>



<!-- An message table is similar to the offset-table -->
<xsl:template match="message-table">
<table summary="Opaque table for a wimp message block" border="0">
 <tr>
  <th align="right" valign="bottom">Offset</th>
  <xsl:if test="count(message/@name) > 0">
   <th align="left" valign="bottom">Name</th>
  </xsl:if>
  <th align="left" valign="bottom">Contents</th>
 </tr>
 <xsl:apply-templates/>
</table>
</xsl:template>

<xsl:template match="message">
<tr>
 <td valign="top" align="right">R1+<xsl:value-of select="@offset"/></td>
 <xsl:if test="../*/@name != ''">
  <td valign="top" align="left"><xsl:value-of select="@name"/></td>
 </xsl:if>
 <td valign="top" align="left"><xsl:apply-templates/></td>
</tr>
</xsl:template>

<xsl:template name="describepositionhelper">
<xsl:param name = "where" />
<xsl:if test="name($where) != name(/)">
 <xsl:call-template name="describepositionhelper">
 <xsl:with-param name="where" select="$where/.." />
 </xsl:call-template>

 <xsl:text>/</xsl:text>

 <xsl:if test="$position-with-names = 'yes'">
  <xsl:text>&#10;   </xsl:text>
 </xsl:if>

 <xsl:value-of select="name($where)" />
 <xsl:choose>
  <xsl:when test="$position-with-names = 'yes'">
   <xsl:choose>
    <xsl:when test="$where/@title != ''">
     <xsl:text>[@title='</xsl:text>
     <xsl:value-of select="$where/@title" />
     <xsl:text>']</xsl:text>
    </xsl:when>
    <xsl:when test="$where/@name != ''">
     <xsl:text>[@name='</xsl:text>
     <xsl:value-of select="$where/@name" />
     <xsl:text>']</xsl:text>
    </xsl:when>
    <xsl:otherwise>
     <xsl:variable name="index" select="count($where/preceding-sibling::*) + 1"/>
     <xsl:if test="$index != 1">
      <xsl:text>[</xsl:text>
      <xsl:value-of select="$index" />
      <xsl:text>]</xsl:text>
     </xsl:if>
    </xsl:otherwise>
   </xsl:choose>
  </xsl:when>
  <xsl:otherwise>
   <xsl:variable name="index" select="count($where/preceding-sibling::*) + 1"/>
   <xsl:if test="$index != 1">
    <xsl:text>[</xsl:text>
    <xsl:value-of select="$index" />
    <xsl:text>]</xsl:text>
   </xsl:if>
  </xsl:otherwise>
 </xsl:choose>
</xsl:if>
</xsl:template>

<xsl:template match="text()" mode="describe" />

<xsl:template name="describeposition">
<xsl:call-template name="describepositionhelper">
<xsl:with-param name="where" select="." />
</xsl:call-template>
</xsl:template>

<!-- References -->
<xsl:template match="reference">
<xsl:variable name="refname" select="@name"/>
<xsl:variable name="refreason" select="string(@reason)"/>
<xsl:variable name="link-content">
 <xsl:choose>
  <xsl:when test="(not(text()) and count(*) = 0) and @name">
   <xsl:value-of select="@name" />
   <xsl:if test="$refreason != ''">
    <xsl:text> </xsl:text>
    <xsl:value-of select="@reason" />
   </xsl:if>
  </xsl:when>
  <xsl:otherwise>
   <xsl:apply-templates />
  </xsl:otherwise>
 </xsl:choose>
</xsl:variable>

<!-- Remember the destination of the link -->
<xsl:variable name="hrefto">
 <xsl:value-of select="string(@href)"/>
 <xsl:if test="@href and
               (substring(@href,1,1) != '?') and
               (substring(@href,1,1) != '#') and
               (not(contains(@href,':')))">
  <xsl:text>.html</xsl:text>
 </xsl:if>
 <xsl:if test="(@name) and (@type != 'document')">
  <xsl:text>#</xsl:text>
  <xsl:if test="@type">
   <xsl:value-of select="@type"/>
   <xsl:text>_</xsl:text>
  </xsl:if>
  <xsl:value-of select="translate(@name,$title-to-id-src,$title-to-id-map)" />
  <xsl:if test="@reason!=''">
   <xsl:text>-</xsl:text>
   <xsl:value-of select="translate(@reason,$title-to-id-src,$title-to-id-map)" />
  </xsl:if>
 </xsl:if>
</xsl:variable>

<!-- remember the text of where we're going to -->
<xsl:variable name="linktext">
<xsl:choose>
 <!-- SWI reference -->
 <xsl:when test="@type='swi'">
  <xsl:if test="(not(@href)) and
                 not (//swi-definition[@name=$refname and
                        (string(@reason)=$refreason)])">
   <xsl:message>SWI definition for <xsl:value-of select="$refname" /> not found at
   <xsl:call-template name="describeposition" />.</xsl:message>
  </xsl:if>
  <xsl:choose>
   <xsl:when test="not(@href) and
                   (@use-description = 'yes') and
                   (//swi-definition[@name=$refname and
                    (string(@reason)=$refreason)])">
    <xsl:value-of select="//swi-definition[@name=$refname and
                             (string(@reason)=$refreason)]/@description" />
   </xsl:when>
   <xsl:otherwise>
    <xsl:value-of select="$link-content" />
   </xsl:otherwise>
  </xsl:choose>
 </xsl:when>

 <!-- Entry-point reference -->
 <xsl:when test="@type='entry'">
  <xsl:if test="not(@href) and
                 not (//entry-definition[@name=$refname and
                        (string(@reason)=$refreason)])">
   <xsl:message>Entry-point definition for <xsl:value-of select="$refname" /> not found at
   <xsl:call-template name="describeposition" />.</xsl:message>
  </xsl:if>
  <xsl:choose>
   <xsl:when test="(not(@href)) and
                   (@use-description = 'yes') and
                   (//entry-definition[@name=$refname and
                    (string(@reason)=$refreason)])">
    <xsl:value-of select="//entry-definition[@name=$refname and
                             (string(@reason)=$refreason)]/@description" />
   </xsl:when>
   <xsl:otherwise>
    <xsl:value-of select="$link-content" />
   </xsl:otherwise>
  </xsl:choose>
 </xsl:when>

 <!-- Command reference -->
 <xsl:when test="@type='command'">
  <xsl:if test="(not(@href)) and
                 not (//command-definition[@name=$refname and
                        (string(@reason)=$refreason)])">
   <xsl:message>Command definition for *<xsl:value-of select="$refname" /> not found at
   <xsl:call-template name="describeposition" />.</xsl:message>
  </xsl:if>
  <xsl:choose>
   <xsl:when test="(not(@href)) and
                   (@use-description = 'yes') and
                   (//command-definition[@name=$refname and
                    (string(@reason)=$refreason)])">
    <xsl:value-of select="//command-definition[@name=$refname and
                             (string(@reason)=$refreason)]/@description" />
   </xsl:when>
   <xsl:otherwise>
    <xsl:text>*</xsl:text>
    <xsl:value-of select="$link-content" />
   </xsl:otherwise>
  </xsl:choose>
 </xsl:when>

 <!-- VDU reference -->
 <xsl:when test="@type='vdu'">
  <xsl:if test="(not(@href)) and
                 not (//vdu-definition[@name=$refname and
                        (string(@reason)=$refreason)])">
   <xsl:message>VDU definition for VDU <xsl:value-of select="$refname" /> not found at
   <xsl:call-template name="describeposition" />.</xsl:message>
  </xsl:if>
  <xsl:choose>
   <xsl:when test="(not(@href)) and
                   (@use-description = 'yes') and
                   (//vdu-definition[@name=$refname and
                    (string(@reason)=$refreason)])">
    <xsl:value-of select="//vdu-definition[@name=$refname and
                             (string(@reason)=$refreason)]/@description" />
   </xsl:when>
   <xsl:otherwise>
    <xsl:text>VDU </xsl:text>
    <xsl:value-of select="$link-content" />
   </xsl:otherwise>
  </xsl:choose>
 </xsl:when>

 <!-- Message reference -->
 <xsl:when test="@type='message'">
  <xsl:if test="(not(@href)) and
                 not (//message-definition[@name=$refname and
                        (string(@reason)=$refreason)])">
   <xsl:message>Message definition for <xsl:value-of select="$refname" /> not found at
   <xsl:call-template name="describeposition" />.</xsl:message>
  </xsl:if>
  <xsl:choose>
   <xsl:when test="(not(@href)) and
                   (@use-description = 'yes') and
                   (//message-definition[@name=$refname and
                    (string(@reason)=$refreason)])">
    <xsl:value-of select="//message-definition[@name=$refname and
                             (string(@reason)=$refreason)]/@description" />
   </xsl:when>
   <xsl:otherwise>
    <xsl:text>Message_</xsl:text>
    <xsl:value-of select="$link-content" />
   </xsl:otherwise>
  </xsl:choose>
 </xsl:when>

 <!-- Error reference -->
 <xsl:when test="@type='error'">
  <xsl:if test="(not(@href)) and
                 not (//error-definition[@name=$refname])">
   <xsl:message>Error definition for <xsl:value-of select="$refname" /> not found at
   <xsl:call-template name="describeposition" />.</xsl:message>
  </xsl:if>
  <xsl:choose>
   <xsl:when test="(not(@href)) and
                   (@use-description = 'yes') and
                   (//error-definition[@name=$refname])">
    <xsl:value-of select="//error-definition[@name=$refname]/@description" />
   </xsl:when>
   <xsl:otherwise>
    <xsl:text>Error_</xsl:text>
    <xsl:value-of select="$link-content" />
   </xsl:otherwise>
  </xsl:choose>
 </xsl:when>

 <!-- Service reference -->
 <xsl:when test="@type='service'">
  <xsl:if test="(not(@href)) and
                 not (//service-definition[@name=$refname and
                        (string(@reason)=$refreason)])">
   <xsl:message>Service definition for <xsl:value-of select="$refname" /> not found at
   <xsl:call-template name="describeposition" />.</xsl:message>
  </xsl:if>
  <xsl:choose>
   <xsl:when test="(not(@href)) and
                   (@use-description = 'yes') and
                   (//service-definition[@name=$refname and
                    (string(@reason)=$refreason)])">
    <xsl:value-of select="//service-definition[@name=$refname and
                             (string(@reason)=$refreason)]/@description" />
   </xsl:when>
   <xsl:otherwise>
    <xsl:text>Service_</xsl:text>
    <xsl:value-of select="$link-content" />
   </xsl:otherwise>
  </xsl:choose>
 </xsl:when>

 <!-- Toolbox method reference -->
 <xsl:when test="@type='tboxmethod'">
  <xsl:if test="(not(@href)) and
                 not (//tboxmethod-definition[@name=$refname and
                        (string(@reason)=$refreason)])">
   <xsl:message>Toolbox Method definition for <xsl:value-of select="$refname" /> not found at
   <xsl:call-template name="describeposition" />.</xsl:message>
  </xsl:if>
  <xsl:choose>
   <xsl:when test="(not(@href)) and
                   (@use-description = 'yes') and
                   (//tboxmethod-definition[@name=$refname and
                    (string(@reason)=$refreason)])">
    <xsl:value-of select="//tboxmethod-definition[@name=$refname and
                             (string(@reason)=$refreason)]/@description" />
   </xsl:when>
   <xsl:otherwise>
    <xsl:value-of select="$link-content" />
   </xsl:otherwise>
  </xsl:choose>
 </xsl:when>

 <!-- Toolbox message reference -->
 <xsl:when test="@type='tboxmessage'">
  <xsl:if test="(not(@href)) and
                 not (//tboxmessage-definition[@name=$refname and
                        (string(@reason)=$refreason)])">
   <xsl:message>Toolbox Message definition for <xsl:value-of select="$refname" /> not found at
   <xsl:call-template name="describeposition" />.</xsl:message>
  </xsl:if>
  <xsl:choose>
   <xsl:when test="(not(@href)) and
                   (@use-description = 'yes') and
                   (//tboxmessage-definition[@name=$refname and
                    (string(@reason)=$refreason)])">
    <xsl:value-of select="//tboxmessage-definition[@name=$refname and
                             (string(@reason)=$refreason)]/@description" />
   </xsl:when>
   <xsl:otherwise>
    <xsl:value-of select="$link-content" />
   </xsl:otherwise>
  </xsl:choose>
 </xsl:when>

 <!-- UpCall reference -->
 <xsl:when test="@type='upcall'">
  <xsl:if test="(not(@href)) and
                 not (//upcall-definition[@name=$refname and
                        (string(@reason)=$refreason)])">
   <xsl:message>UpCall definition for <xsl:value-of select="$refname" /> not found at
   <xsl:call-template name="describeposition" />.</xsl:message>
  </xsl:if>
  <xsl:choose>
   <xsl:when test="(not(@href)) and
                   (@use-description = 'yes') and
                   (//upcall-definition[@name=$refname and
                    (string(@reason)=$refreason)])">
    <xsl:value-of select="//upcall-definition[@name=$refname and
                             (string(@reason)=$refreason)]/@description" />
   </xsl:when>
   <xsl:otherwise>
    <xsl:text>UpCall_</xsl:text>
    <xsl:value-of select="$link-content" />
   </xsl:otherwise>
  </xsl:choose>
 </xsl:when>

 <!-- Vector reference -->
 <xsl:when test="@type='vector'">
  <xsl:if test="(not(@href)) and
                 not (//vector-definition[@name=$refname and
                        (string(@reason)=$refreason)])">
   <xsl:message>Vector definition for <xsl:value-of select="$refname" /> not found at
   <xsl:call-template name="describeposition" />.</xsl:message>
  </xsl:if>
  <xsl:choose>
   <xsl:when test="(not(@href)) and
                   (@use-description = 'yes') and
                   (//vector-definition[@name=$refname and
                    (string(@reason)=$refreason)])">
    <xsl:value-of select="//vector-definition[@name=$refname and
                             (string(@reason)=$refreason)]/@description" />
   </xsl:when>
   <xsl:otherwise>
    <xsl:value-of select="$link-content" />
   </xsl:otherwise>
  </xsl:choose>
 </xsl:when>

 <!-- SysVar reference -->
 <xsl:when test="@type='sysvar'">
<!--   <tt> -->
  <xsl:if test="(not(@href)) and
                 not (//sysvar-definition[@name=$refname and
                        (string(@reason)=$refreason)])">
   <xsl:message>SystemVariable definition for <xsl:value-of select="$refname" /> not found at
   <xsl:call-template name="describeposition" />.</xsl:message>
  </xsl:if>
  <xsl:choose>
   <xsl:when test="(not(@href)) and
                   (@use-description = 'yes') and
                   (//sysvar-definition[@name=$refname and
                    (string(@reason)=$refreason)])">
    <xsl:value-of select="//sysvar-definition[@name=$refname and
                             (string(@reason)=$refreason)]/@description" />
   </xsl:when>
   <xsl:otherwise>
    <xsl:value-of select="$link-content" />
   </xsl:otherwise>
  </xsl:choose>
<!--   </tt> -->
 </xsl:when>

 <!-- Section type reference -->
<!--  There must be an easier way to do this ? -->
 <xsl:when test="@type='section'">
  <xsl:if test="(not(@href)) and
                 not (//section[@title=$refname])">
   <xsl:message>Section for <xsl:value-of select="$refname" /> not found at
   <xsl:call-template name="describeposition" />.</xsl:message>
  </xsl:if>
  <xsl:value-of select="$link-content" />
 </xsl:when>
 <xsl:when test="@type='subsection'">
  <xsl:if test="(not(@href)) and
                 not (//subsection[@title=$refname])">
   <xsl:message>SubSection for <xsl:value-of select="$refname" /> not found at
   <xsl:call-template name="describeposition" />.</xsl:message>
  </xsl:if>
  <xsl:value-of select="$link-content" />
 </xsl:when>
 <xsl:when test="@type='subsubsection'">
  <xsl:if test="(not(@href)) and
                 not (//subsubsection[@title=$refname])">
   <xsl:message>SubSubSection for <xsl:value-of select="$refname" /> not found at
   <xsl:call-template name="describeposition" />.</xsl:message>
  </xsl:if>
  <xsl:value-of select="$link-content" />
 </xsl:when>
 <xsl:when test="@type='category'">
  <xsl:if test="(not(@href)) and
                 not (//category[@title=$refname])">
   <xsl:message>Category for <xsl:value-of select="$refname" /> not found at
   <xsl:call-template name="describeposition" />.</xsl:message>
  </xsl:if>
  <xsl:value-of select="$link-content" />
 </xsl:when>

 <!-- Documents -->
 <xsl:when test="@type='document'">
  <xsl:if test="(not(@href))">
   <xsl:message>Document for <xsl:value-of select="$refname" /> not supplied at
   <xsl:call-template name="describeposition" />.</xsl:message>
  </xsl:if>
  <xsl:value-of select="$link-content" />
 </xsl:when>

 <!-- Normal links -->
 <xsl:when test="@type='link'">
  <xsl:value-of select="$link-content" />
 </xsl:when>

 <!-- Anything else we don't understand -->
 <xsl:otherwise>
  <font size="+5" color="#DD0000"><xsl:value-of select="$link-content" /></font>
  <xsl:message>Reference type '<xsl:value-of select="@type" />' for <xsl:value-of select="$refname" /> is unknown at
   <xsl:call-template name="describeposition" />.</xsl:message>
 </xsl:otherwise>
</xsl:choose>
</xsl:variable>

<!-- Now write out the link -->
<xsl:choose>
 <xsl:when test="(substring(@href,1,1)!='?')">
  <a>
  <xsl:attribute name="href">
  <xsl:copy-of select="$hrefto" />
  </xsl:attribute>
  <xsl:copy-of select="$linktext" />
  </a>
 </xsl:when>
 <xsl:otherwise>
  <xsl:value-of select="$linktext" />
   <xsl:variable name="complaint">Link for '<xsl:value-of select="translate($linktext,'&#10;',' ')"/>' has undefined destination</xsl:variable>
  <xsl:comment><xsl:value-of select="$complaint" /></xsl:comment>
  <xsl:message><xsl:value-of select="$complaint" /> at
   <xsl:call-template name="describeposition" />.</xsl:message>
 </xsl:otherwise>
</xsl:choose>

</xsl:template>

<!-- FixMe elements -->
<xsl:template match="fixme">
<font color="#DD0000">
<xsl:choose>
 <xsl:when test="(text() != '') or (count(*) > 0)">
  <strong>FIXME:</strong> <xsl:apply-templates />
 </xsl:when>
 <xsl:otherwise>
  <strong>FIXME</strong>
 </xsl:otherwise>
</xsl:choose>
</font>
</xsl:template>


<!-- List comes in two forms; ordered and unordered -->
<xsl:template match="list">
<xsl:choose>
 <xsl:when test="@type = 'ordered'">
  <ol>
   <xsl:apply-templates />
  </ol>
 </xsl:when>

 <xsl:otherwise>
  <ul>
   <xsl:apply-templates />
  </ul>
 </xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- Items in lists -->
<xsl:template match="item">
<li>
<xsl:choose>
 <xsl:when test="count(p) = 1">
  <!-- Botch to stop tables looking shite on most browsers -->
  <xsl:apply-templates select="p/*|p/text()"/>
 </xsl:when>
 <xsl:otherwise>
  <xsl:apply-templates />
 </xsl:otherwise>
</xsl:choose>
</li>
</xsl:template>

<!-- Paragraphs are simple -->
<xsl:template match="p">
<p><xsl:apply-templates /></p>
</xsl:template>

<!-- User replacement - something the user must replace with a value -->
<xsl:template match="userreplace">
<i>&lt;<xsl:apply-templates />&gt;</i>
</xsl:template>

<!-- User input - something the user could have typed -->
<xsl:template match="userinput">
<tt><b><xsl:apply-templates /></b></tt>
</xsl:template>

<!-- System output - something the system could have displayed -->
<xsl:template match="systemoutput">
<br /><tt><xsl:apply-templates /></tt>
</xsl:template>

<!-- Menu option - an option that the user might chose for a menu -->
<xsl:template match="menuoption">
<em><xsl:apply-templates /></em>
</xsl:template>

<!-- Variable -->
<xsl:template match="variable">
<tt><xsl:apply-templates /></tt>
</xsl:template>

<!-- Command example -->
<xsl:template match="command">
<code><xsl:apply-templates /></code>
</xsl:template>

<!-- Function-like routine -->
<xsl:template match="function">
<code><xsl:apply-templates /></code>
</xsl:template>

<!-- a filename -->
<xsl:template match="filename">
<code><xsl:apply-templates /></code>
</xsl:template>

<!-- a system variable -->
<xsl:template match="sysvar">
<code><xsl:apply-templates /></code>
</xsl:template>

<!-- User replacement -->
<xsl:template match="optional">
<xsl:text>[</xsl:text>
<xsl:for-each select="*">
<xsl:if test="(position()>1) and (../@alternates='true')">
 <xsl:text> | </xsl:text>
</xsl:if>
<xsl:apply-templates select="."/>
</xsl:for-each>
<xsl:text>]</xsl:text>
</xsl:template>

<!-- Command line switch -->
<xsl:template match="switch">
<xsl:text>-</xsl:text><xsl:value-of select="@name" />
<xsl:if test="(text() != '') or (count(*) > 0)">
 <xsl:text> </xsl:text>
 <xsl:apply-templates />
</xsl:if>
</xsl:template>

<!-- Long example -->
<xsl:template match="extended-example">
<xsl:if test="@type='unknown'">
 <xsl:message>Code type 'unknown' should not be used at :
  <xsl:call-template name="describeposition" />.</xsl:message>
</xsl:if>

<pre>
<xsl:apply-templates />
</pre>
</xsl:template>

<!-- Code snippet -->
<xsl:template match="code">
<xsl:if test="@type='unknown'">
 <xsl:message>Code type 'unknown' should not be used at :
  <xsl:call-template name="describeposition" />.</xsl:message>
</xsl:if>

<code>
<xsl:apply-templates />
</code>
</xsl:template>

<!-- Stylistic changes -->
<!-- These should really be removed ASAP and replaced with more content-based
     elements, such as warning, important or note -->
<xsl:template match="strong">
<strong><xsl:apply-templates /></strong>
</xsl:template>
<xsl:template match="sup"><sup><xsl:apply-templates /></sup></xsl:template>
<xsl:template match="sub"><sub><xsl:apply-templates /></sub></xsl:template>
<xsl:template match="em"><em><xsl:apply-templates /></em></xsl:template>
<!-- I'm not at all sure I like the concept of having a break element -->
<xsl:template match="br"><br /></xsl:template>

<!-- Document import -->
<xsl:template match="import">
<xsl:apply-templates select="saxon:evaluate(concat('document(@document)/',@path))" />
</xsl:template>

<!-- EMail -->
<xsl:template match="email">
<xsl:if test="@name != ''">
<xsl:value-of select="@name" />
<xsl:text> </xsl:text>
</xsl:if>
<xsl:text>&lt;</xsl:text>
<a>
<xsl:attribute name="href">
<xsl:text>mailto:</xsl:text>
<xsl:value-of select="@address" />
</xsl:attribute>
<xsl:value-of select="@address" />
</a>
<xsl:text>&gt;</xsl:text>
</xsl:template>

<!-- Image -->
<xsl:template match="image">
<xsl:if test="local-name(..) != 'image'">
 <p align="center" />
</xsl:if>
<xsl:choose>
 <xsl:when test="@type = 'png'">
  <img align="center">
   <xsl:attribute name="src"><xsl:value-of select="@src" /></xsl:attribute>
   <xsl:attribute name="width"><xsl:value-of select="@width" /></xsl:attribute>
   <xsl:attribute name="height"><xsl:value-of select="@height" /></xsl:attribute>
   <xsl:attribute name="alt"><xsl:value-of select="@caption" /></xsl:attribute>
  </img>
  <xsl:apply-templates select="image"/>
 </xsl:when>

 <xsl:when test="@type = 'draw'">
  <!-- please note that this is /wrong/ -->
  <object type="application/drawfile" >
   <xsl:attribute name="data"><xsl:value-of select="@src" /></xsl:attribute>
   <xsl:attribute name="width"><xsl:value-of select="@width" /></xsl:attribute>
   <xsl:attribute name="height"><xsl:value-of select="@height" /></xsl:attribute>
   <xsl:attribute name="standby"><xsl:value-of select="@caption" /></xsl:attribute>
   <xsl:apply-templates select="image"/>
  </object>
 </xsl:when>

 <xsl:otherwise>
  <xsl:message>Image '<xsl:value-of select="@src" />' has an unknown type '<xsl:value-of select="@type" />'
</xsl:message>
  <xsl:apply-templates select="image"/>
 </xsl:otherwise>
</xsl:choose>

<xsl:if test="local-name(..) != 'image' and
              @caption != ''">
 <br />
 <em><xsl:value-of select="@caption" /></em>
</xsl:if>

</xsl:template>

<!-- Meta Data section -->
<xsl:template match="meta" mode="tail">
<dl>
 <dt><h2><a name="metadata">Document information</a></h2></dt>
 <dd>
  <table summary="Meta information table">
   <xsl:if test="count(maintainer) &gt; 0">
    <tr>
     <th align="right" valign="top">Maintainer(s):</th>
     <td><xsl:apply-templates select="maintainer"/></td>
    </tr>
   </xsl:if>
   <xsl:if test="count(history) &gt; 0">
    <tr>
     <th align="right" valign="top">History:</th>
     <td><xsl:apply-templates select="history"/></td>
    </tr>
   </xsl:if>
   <xsl:if test="count(related) &gt; 0">
    <tr>
     <th align="right" valign="top">Related:</th>
     <td><xsl:apply-templates select="related" mode="meta" /></td>
    </tr>
   </xsl:if>
   <xsl:if test="count(disclaimer) &gt; 0">
    <tr>
     <th align="right" valign="top">Disclaimer:</th>
     <td align="left"  valign="top">
      <xsl:apply-templates select="disclaimer"/>
     </td>
    </tr>
   </xsl:if>
  </table>
 </dd>
</dl>
<hr />
</xsl:template>

<xsl:template match="history">
<table border="0" summary="Document history">
<tr>
 <th align="left">Revision</th>
 <th align="left">Date</th>
 <th align="left">Author</th>
 <th align="left">Changes</th>
</tr>
<xsl:apply-templates />
</table>
</xsl:template>

<xsl:template match="revision">
<tr>
 <td valign="top"><xsl:value-of select="@number" /></td>
 <td valign="top"><xsl:value-of select="translate(@date,' ','&#160;')" /></td>
 <td valign="top"><xsl:value-of select="@author" /></td>
 <td valign="top">
  <xsl:if test="@title != ''">
   <strong> <xsl:value-of select="@title" /> </strong>
   <br />
  </xsl:if>
  <xsl:if test="count(change) &gt; 0">
   <ul>
    <xsl:apply-templates />
   </ul>
  </xsl:if>
 </td>
</tr>
</xsl:template>

<xsl:template match="change">
<li><xsl:apply-templates /></li>
</xsl:template>

</xsl:stylesheet>
