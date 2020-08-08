<?xml version="1.0" standalone="yes"?>

<!-- RISC OS PRM stylesheet - written by hand; apologies for errors in
     style.
     
     This stylesheet is designed for use with STRONGHELP.
     (c) Justin Fletcher, distribution unlimited
     
     It is NOT complete - please feel free to add bits where necessary.
     
     We process the following :
       section
       subsection
       subsubsection
       (we don't handle Category; categories should go inline)
       text() (mostly; we must special case where we actually use it)
       p
     
     New documents are created for :
       swi-definition
       command-definition
     
     command-definition copes with :
       syntax
       parameters
       use
       examples
       related
       
     swi-definition copes with:
       name, number, reason
       register-use for entry/exit
       use
       related

     Index an page is generated as the output; this may be used as !Root.
     
     Explicitly unsupported as yet :
       any form of semantic information such as variables, filenames, etc
       any form of tables
       *-definition not mentioned above

  -->

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/TR/xhtml1/strict"
                xmlns:saxon = "http://icl.com/saxon">

<xsl:output method="text" indent="no" />

<xsl:variable name="title-to-id-src">ABCDEFGHIJKLMNOPQRSTUVWXYZ ,$:()-*?</xsl:variable>
<xsl:variable name="title-to-id-map">abcdefghijklmnopqrstuvwxyz_-_-</xsl:variable>
<xsl:param name="create-contents">yes</xsl:param>
<xsl:param name="create-body">yes</xsl:param>
<xsl:param name="create-contents-target"></xsl:param>

<xsl:template match="/">
<xsl:text>ROOT</xsl:text>
<xsl:apply-templates />
<xsl:for-each select="
                  //section |
                  //subsection |
                  //subsubsection |
                  //category |
                  //swi-definition |
                  //entry-definition |
                  //service-definition |
                  //upcall-definition |
                  //command-definition |
                  //sysvar-definition |
                  //message-definition |
                  //import">
Try <xsl:call-template name="page-link" />.
</xsl:for-each>
</xsl:template>

<xsl:template name="page-link">
<xsl:variable name="local" select="local-name(.)" />
<xsl:text>&lt;</xsl:text>
<xsl:choose>
 <xsl:when test="$local = 'section' or
                 $local = 'subsection' or
                 $local = 'subsubsection' or
                 $local = 'category'">
  <xsl:value-of select="@title" />
 </xsl:when>
 <xsl:when test="$local = 'swi-definition' or
                 $local = 'entry-definition' or
                 $local = 'service-definition' or
                 $local = 'upcall-definition' or
                 $local = 'command-definition' or
                 $local = 'sysvar-definition' or
                 $local = 'message-definition'">
  <xsl:if test="(local-name(.)='command-definition')">*</xsl:if>
  <xsl:value-of select="@name" />
       <xsl:if test="(local-name(.)='message-definition') and
                     (@number!='')">
        <xsl:text> (&amp;</xsl:text>
        <xsl:value-of select="@number" />
        <xsl:text>)</xsl:text>
       </xsl:if>
       <xsl:if test="@reason!=''">
        <xsl:text> </xsl:text>
        <xsl:value-of select="@reason" />
        <xsl:if test="@reasonname!=''">
         <xsl:text> - </xsl:text>
         <xsl:value-of select="@reasonname" />
        </xsl:if>
       </xsl:if>
 </xsl:when>
 <xsl:otherwise>
  <!-- nothing -->
 </xsl:otherwise>
</xsl:choose>
<!-- now the link destination -->
<xsl:text>=&gt;</xsl:text>
<xsl:call-template name="current-node-filename" />
<xsl:text>&gt;</xsl:text>
</xsl:template>

<xsl:template name="index-subpages">
<xsl:for-each select="
                  subsection |
                  subsubsection |
                  category |
                  swi-definition |
                  entry-definition |
                  service-definition |
                  upcall-definition |
                  command-definition |
                  sysvar-definition |
                  message-definition |
                  import">
<xsl:call-template name="page-link" />
<xsl:text>&#10;</xsl:text>
</xsl:for-each>
</xsl:template>


<!-- This recurses up the tree, processing each section with a directory to
     create a full path as its result -->
<xsl:template match="section|subsection|subsubsection|category" mode="dir">
<xsl:if test="@title != ''">
 <xsl:apply-templates select=".." mode="dir" />
 <xsl:value-of select="local-name(.)" />
 <xsl:text>_</xsl:text>
 <xsl:value-of select="translate(@title,$title-to-id-src,$title-to-id-map)" />
 <xsl:text>+</xsl:text>
</xsl:if>
</xsl:template>
<xsl:template match="*" mode="dir"/>

<xsl:template name="current-node-filename">
<xsl:choose>
 <xsl:when test="contains(local-name(.),'-definition')">
  <!-- a definition -->
  <xsl:value-of select="substring-before(local-name(.),'-')" />
  <xsl:text>_</xsl:text>
  <xsl:value-of select="translate(@name,$title-to-id-src,$title-to-id-map)"/>
  <xsl:if test="@reason != ''">
   <xsl:value-of select="translate(@reason,$title-to-id-src,$title-to-id-map)" />
  </xsl:if>
 </xsl:when>
 <xsl:otherwise>
  <!-- a normal section -->
  <!-- <xsl:apply-templates mode="dir" select=".."/> -->
  <xsl:value-of select="@href"/>
  <xsl:value-of select="local-name(.)"/>
  <xsl:text>_</xsl:text>
  <xsl:value-of select="translate(@title,$title-to-id-src,$title-to-id-map)"/>
 </xsl:otherwise>
</xsl:choose>
</xsl:template>


<xsl:template match="section|subsection|subsubsection">
<xsl:variable name="file">
 <xsl:call-template name="current-node-filename" />
</xsl:variable>
<xsl:document href="{$file}" method="text" indent="no">
<xsl:value-of select="@title" />
#Parent !Root
<xsl:apply-templates />
#Tab
<xsl:call-template name="index-subpages"/>
</xsl:document>

</xsl:template>



<!-- command definitions ? -->
<xsl:template match="command-definition">
<xsl:variable name="file">
 <xsl:call-template name="current-node-filename" />
</xsl:variable>
<xsl:document href="{$file}" method="text" indent="no">
<xsl:text>*</xsl:text><xsl:value-of select="@name" />
<xsl:text>
#Parent !Root
#align right; f2
</xsl:text>
<xsl:text>*</xsl:text><xsl:value-of select="@name" />
<xsl:text>
#f; align left; indent 4
</xsl:text>
<xsl:value-of select="@description"/>
<xsl:text>
#indent 0
Syntax:
#indent 4; fCode
</xsl:text>
<xsl:choose>
 <xsl:when test="count(syntax)=0">
  <xsl:text>*</xsl:text><xsl:value-of select="@name"/>
 </xsl:when>
 <xsl:otherwise>
  <xsl:for-each select="syntax">
   <xsl:text>*</xsl:text><xsl:value-of select="../@name"/>
   <xsl:apply-templates/>
   <xsl:if test="position() != last()">
    <xsl:text>&#10;</xsl:text>
   </xsl:if>
  </xsl:for-each>
 </xsl:otherwise>
</xsl:choose>

<xsl:text>
#f; indent
Parameters:
#indent 4
</xsl:text>
<xsl:choose>
 <xsl:when test="count(parameter)=0">/None/</xsl:when>
 <xsl:otherwise>
  <xsl:for-each select="parameter">
   <xsl:if test="@switch != ''">
    -<xsl:value-of select="@switch" />
    <xsl:text> </xsl:text>
   </xsl:if>
   <xsl:if test="@label != ''">
    <xsl:value-of select="@label" />
    <xsl:text> </xsl:text>
   </xsl:if>
   <xsl:if test="@name != ''">
    <xsl:text>{/}\&lt;</xsl:text>
    <xsl:value-of select="@name" />
    <xsl:text>&gt;{/}</xsl:text>
   </xsl:if>
   <xsl:text>&#9;-&#9;</xsl:text>
   <xsl:apply-templates />
  </xsl:for-each>
 </xsl:otherwise>
</xsl:choose>

<xsl:text>
#line
#indent 0
Use:
#indent 4
</xsl:text>

<xsl:apply-templates select="use" />
<xsl:text>#indent 0
</xsl:text>

<xsl:choose>
 <xsl:when test="count(example) > 0">
  <!-- I've probably missed an easier way to do this... -->
  <xsl:choose>
   <xsl:when test="count(example) = 1">
    <xsl:text>Example&#10;#indent 4&#10;</xsl:text>
   </xsl:when>
   <xsl:otherwise>
    <xsl:text>Examples&#10;#indent 4&#10;</xsl:text>
   </xsl:otherwise>
  </xsl:choose>

  <xsl:for-each select="example">
   <xsl:apply-templates />
  </xsl:for-each>
 </xsl:when>
</xsl:choose>

<xsl:text>
#line
</xsl:text>

<xsl:apply-templates select="related" />

</xsl:document>
 
</xsl:template>



<!-- swi definitions ? -->
<xsl:template match="swi-definition">
<xsl:variable name="file">
 <xsl:call-template name="current-node-filename" />
</xsl:variable>
<xsl:document href="{$file}" method="text" indent="no">
<xsl:value-of select="@name" />
<xsl:text>
#Parent !Root
#align right; f2
</xsl:text>
<xsl:value-of select="@name" />
<xsl:if test="@reason != ''" xml:space="default">
 <xsl:text> </xsl:text>
 <xsl:value-of select="@reason"/>
</xsl:if>
<xsl:text>&#10;(SWI &amp;</xsl:text>
<xsl:value-of select="@number"/>
<xsl:text>)</xsl:text>
<xsl:text>
#f; align left; indent 4
</xsl:text>
<xsl:choose>
 <xsl:when test="@internal = 'yes'">
 <dd><p>This SWI call is for internal use only. You must not use it in your
        own code.</p></dd></xsl:when>
 <xsl:otherwise>
<xsl:value-of select="@description"/>
<xsl:text>
#tab align right
#indent 0
On entry:
#indent 4
</xsl:text>
<xsl:choose>
 <xsl:when test="count(entry/*)=0">None</xsl:when>
 <xsl:otherwise>
  <xsl:apply-templates select="entry"/>
 </xsl:otherwise>
</xsl:choose>

<xsl:text>
#indent 0
On exit:
#indent 4
</xsl:text>
<xsl:choose>
 <xsl:when test="count(exit/*)=0">None</xsl:when>
 <xsl:otherwise>
  <xsl:apply-templates select="exit"/>
 </xsl:otherwise>
</xsl:choose>

<xsl:text>
#tab
#indent 0
Interrupts:
#indent 4
Interrupts are </xsl:text>
<xsl:value-of select="@irqs" />
<xsl:text>
Fast interrupts are </xsl:text>
<xsl:value-of select="@fiqs"/>

<xsl:text>
#indent 0
Processor mode:
#indent 4
Processor is in </xsl:text>
<xsl:value-of select="@processor-mode"/>
<xsl:text> mode</xsl:text>

<xsl:text>
#indent 0
Re-entrancy:
#indent 4
</xsl:text>
<xsl:choose>
  <xsl:when test='@re-entrant="yes"'>SWI is re-entrant</xsl:when>
  <xsl:when test='@re-entrant="undefined"'>Not defined</xsl:when>
  <xsl:when test='@re-entrant="no"'>SWI is not re-entrant</xsl:when>
  <xsl:otherwise><xsl:value-of select="@re-entrant"/></xsl:otherwise>
</xsl:choose>
<xsl:text>
</xsl:text>

<xsl:text>
#line
#indent 0
Use:
#indent 4
</xsl:text>

<xsl:apply-templates select="use" />
<xsl:text>#indent 0
</xsl:text>

<xsl:text>
#line
</xsl:text>

<xsl:apply-templates select="related" />
</xsl:otherwise>
</xsl:choose>

</xsl:document>
 
</xsl:template>




<!-- Register -->
<xsl:template match="register-use">
<xsl:text>R</xsl:text><xsl:value-of select="@number"/>
<xsl:text></xsl:text>
<xsl:choose>
 <xsl:when test="@state='preserved'">
  <!-- preserved is used on output registers -->
  <xsl:text>&#9;preserved</xsl:text>
 </xsl:when>
 <xsl:when test="@state='corrupted'">
  <!-- corrupted is used on output registers -->
  <xsl:text>&#9;corrupted</xsl:text>
 </xsl:when>
 <xsl:when test="@state='undefined'">
  <!-- undefined is used on input registers -->
  <xsl:text>&#9;undefined</xsl:text>
 </xsl:when>
 <xsl:otherwise>
  <xsl:text> =&#9;</xsl:text>
  <xsl:variable name="string"><xsl:apply-templates /></xsl:variable>
  <xsl:value-of select="normalize-space($string)" />
 </xsl:otherwise>
</xsl:choose>
<xsl:text>&#10;</xsl:text>
</xsl:template>



<xsl:template match="related">
<xsl:text>#indent 0
</xsl:text>
<xsl:choose>
 <xsl:when test="count(*) = 0">
  <xsl:text>Related APIs&#10;#indent 4&#10;/None/</xsl:text>
 </xsl:when>
 
 <xsl:otherwise>
  <xsl:if test="count(reference[@type='command']) > 0">
   <xsl:text>Related * commands&#10;</xsl:text>
   <xsl:text>#indent 4&#10;</xsl:text>
   <xsl:for-each select="reference[@type='command']">
   <xsl:if test="position() > 1">, </xsl:if>
    <xsl:apply-templates select="." />
   </xsl:for-each>
   <xsl:text>&#10;#indent 0&#10;</xsl:text>
  </xsl:if>

  <xsl:if test="count(reference[@type='swi']) > 0">
   <xsl:text>Related SWIs&#10;</xsl:text>
   <xsl:text>#indent 4&#10;</xsl:text>
   <xsl:for-each select="reference[@type='swi']">
   <xsl:if test="position() > 1">, </xsl:if>
    <xsl:apply-templates select="." />
   </xsl:for-each>
   <xsl:text>&#10;#indent 0&#10;</xsl:text>
  </xsl:if>
 
  <xsl:if test="count(reference[@type='service']) > 0">
   <xsl:text>Related services&#10;</xsl:text>
   <xsl:text>#indent 4&#10;</xsl:text>
   <xsl:for-each select="reference[@type='service']">
   <xsl:if test="position() > 1">, </xsl:if>
    <xsl:apply-templates select="." />
   </xsl:for-each>
   <xsl:text>&#10;#indent 0&#10;</xsl:text>
  </xsl:if>
 
  <xsl:if test="count(reference[@type='vector']) > 0">
   <xsl:text>Related vectors&#10;</xsl:text>
   <xsl:text>#indent 4&#10;</xsl:text>
   <xsl:for-each select="reference[@type='vector']">
   <xsl:if test="position() > 1">, </xsl:if>
    <xsl:apply-templates select="." />
   </xsl:for-each>
   <xsl:text>&#10;#indent 0&#10;</xsl:text>
  </xsl:if>
 
  <xsl:if test="count(reference[@type='upcall']) > 0">
   <xsl:text>Related upcalls&#10;</xsl:text>
   <xsl:text>#indent 4&#10;</xsl:text>
   <xsl:for-each select="reference[@type='upcall']">
   <xsl:if test="position() > 1">, </xsl:if>
    <xsl:apply-templates select="." />
   </xsl:for-each>
   <xsl:text>&#10;#indent 0&#10;</xsl:text>
  </xsl:if>
 
  <xsl:if test="count(reference[@type='sysvar']) > 0">
   <xsl:text>Related system variables&#10;</xsl:text>
   <xsl:text>#indent 4&#10;</xsl:text>
   <xsl:for-each select="reference[@type='sysvar']">
   <xsl:if test="position() > 1">, </xsl:if>
    <xsl:apply-templates select="." />
   </xsl:for-each>
   <xsl:text>&#10;#indent 0&#10;</xsl:text>
  </xsl:if>
 
  <xsl:if test="count(reference[@type='entry']) > 0">
   <xsl:text>Related entry points&#10;</xsl:text>
   <xsl:text>#indent 4&#10;</xsl:text>
   <xsl:for-each select="reference[@type='entry']">
   <xsl:if test="position() > 1">, </xsl:if>
    <xsl:apply-templates select="." />
   </xsl:for-each>
   <xsl:text>&#10;#indent 0&#10;</xsl:text>
  </xsl:if>
 
  <xsl:if test="count(reference[@type='message']) > 0">
   <xsl:text>Related messages&#10;</xsl:text>
   <xsl:text>#indent 4&#10;</xsl:text>
   <xsl:for-each select="reference[@type='message']">
   <xsl:if test="position() > 1">, </xsl:if>
    <xsl:apply-templates select="." />
   </xsl:for-each>
   <xsl:text>&#10;#indent 0&#10;</xsl:text>
  </xsl:if>
 </xsl:otherwise>
</xsl:choose>
</xsl:template>



<!-- References -->
<xsl:template match="reference">
<xsl:variable name="link-content">
 <xsl:choose>
  <xsl:when test="(text() = '' and count(*) = 0) and (@name != '')">
   <xsl:value-of select="@name" />
   <xsl:if test="@reason!=''">
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
 <xsl:value-of select="@href"/>
 <xsl:if test="(@href != '?') and
               (@href != '') and
               (not(contains(@href,':')))">
  <xsl:text>:</xsl:text>
 </xsl:if>
 <xsl:if test="@name != ''">
  <xsl:if test="@type != ''">
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

<xsl:variable name="refname" select="@name" />
<xsl:variable name="refreason" select="@reason" />

<!-- remember the text of where we're going to -->
<xsl:variable name="linktext">
<xsl:choose>
 <!-- SWI reference -->
 <xsl:when test="@type='swi'">
  <xsl:if test="(@href = '') and
                 not (//swi-definition[@name=$refname and
                        (string(@reason)=$refreason)])">
   <xsl:message>SWI definition for <xsl:value-of select="$refname" /> not found at
   <xsl:call-template name="describeposition" />.</xsl:message>
  </xsl:if>
  <xsl:choose>
   <xsl:when test="(@href = '') and
                   (@use-description = 'yes') and
                   (//swi-definition[@name=$refname and 
                    ($refreason='' or @reason=$refreason)])">
    <xsl:value-of select="//swi-definition[@name=$refname and 
                             ($refreason='' or
                              @reason=$refreason)]/@description" />
   </xsl:when>
   <xsl:otherwise>
    <xsl:value-of select="$link-content" />
   </xsl:otherwise>
  </xsl:choose>
 </xsl:when>
 
 <!-- Entry-point reference -->
 <xsl:when test="@type='entry'">
  <xsl:if test="(@href = '') and
                 not (//entry-definition[@name=$refname and
                        (string(@reason)=$refreason)])">
   <xsl:message>Entry-point definition for <xsl:value-of select="$refname" /> not found at
   <xsl:call-template name="describeposition" />.</xsl:message>
  </xsl:if>
  <xsl:choose>
   <xsl:when test="(@href = '') and
                   (@use-description = 'yes') and
                   (//entry-definition[@name=$refname and 
                    ($refreason='' or @reason=$refreason)])">
    <xsl:value-of select="//entry-definition[@name=$refname and 
                             ($refreason='' or
                              @reason=$refreason)]/@description" />
   </xsl:when>
   <xsl:otherwise>
    <xsl:value-of select="$link-content" />
   </xsl:otherwise>
  </xsl:choose>
 </xsl:when>
 
 <!-- Command reference -->
 <xsl:when test="@type='command'">
  <xsl:if test="(@href = '') and
                 not (//command-definition[@name=$refname and
                        (string(@reason)=$refreason)])">
   <xsl:message>Command definition for *<xsl:value-of select="$refname" /> not found at
   <xsl:call-template name="describeposition" />.</xsl:message>
  </xsl:if>
  <xsl:choose>
   <xsl:when test="(@href = '') and
                   (@use-description = 'yes') and
                   (//command-definition[@name=$refname and 
                    ($refreason='' or @reason=$refreason)])">
    <xsl:value-of select="//command-definition[@name=$refname and 
                             ($refreason='' or
                              @reason=$refreason)]/@description" />
   </xsl:when>
   <xsl:otherwise>
    <xsl:text>*</xsl:text>
    <xsl:value-of select="$link-content" />
   </xsl:otherwise>
  </xsl:choose>
 </xsl:when>
 
 <!-- Message reference -->
 <xsl:when test="@type='message'">
  <xsl:if test="(@href = '') and
                 not (//message-definition[@name=$refname and
                        (string(@reason)=$refreason)])">
   <xsl:message>Message definition for <xsl:value-of select="$refname" /> not found at
   <xsl:call-template name="describeposition" />.</xsl:message>
  </xsl:if>
  <xsl:choose>
   <xsl:when test="(@href = '') and
                   (@use-description = 'yes') and
                   (//message-definition[@name=$refname and 
                    ($refreason='' or @reason=$refreason)])">
    <xsl:value-of select="//message-definition[@name=$refname and 
                             ($refreason='' or
                              @reason=$refreason)]/@description" />
   </xsl:when>
   <xsl:otherwise>
    <xsl:text>Message_</xsl:text>
    <xsl:value-of select="$link-content" />
   </xsl:otherwise>
  </xsl:choose>
 </xsl:when>
 
 <!-- Service reference -->
 <xsl:when test="@type='service'">
  <xsl:if test="(@href = '') and
                 not (//service-definition[@name=$refname and
                        (string(@reason)=$refreason)])">
   <xsl:message>Service definition for <xsl:value-of select="$refname" /> not found at
   <xsl:call-template name="describeposition" />.</xsl:message>
  </xsl:if>
  <xsl:choose>
   <xsl:when test="(@href = '') and
                   (@use-description = 'yes') and
                   (//service-definition[@name=$refname and 
                    ($refreason='' or @reason=$refreason)])">
    <xsl:value-of select="//service-definition[@name=$refname and 
                             ($refreason='' or
                              @reason=$refreason)]/@description" />
   </xsl:when>
   <xsl:otherwise>
    <xsl:text>Service_</xsl:text>
    <xsl:value-of select="$link-content" />
   </xsl:otherwise>
  </xsl:choose>
 </xsl:when>
 
 <!-- UpCall reference -->
 <xsl:when test="@type='upcall'">
  <xsl:if test="(@href = '') and
                 not (//upcall-definition[@name=$refname and
                        (string(@reason)=$refreason)])">
   <xsl:message>UpCall definition for <xsl:value-of select="$refname" /> not found at
   <xsl:call-template name="describeposition" />.</xsl:message>
  </xsl:if>
  <xsl:choose>
   <xsl:when test="(@href = '') and
                   (@use-description = 'yes') and
                   (//upcall-definition[@name=$refname and 
                    ($refreason='' or @reason=$refreason)])">
    <xsl:value-of select="//upcall-definition[@name=$refname and 
                             ($refreason='' or
                              @reason=$refreason)]/@description" />
   </xsl:when>
   <xsl:otherwise>
    <xsl:text>UpCall_</xsl:text>
    <xsl:value-of select="$link-content" />
   </xsl:otherwise>
  </xsl:choose>
 </xsl:when>
 
 <!-- UpCall reference -->
 <xsl:when test="@type='vector'">
  <xsl:if test="(@href = '') and
                 not (//vector-definition[@name=$refname and
                        (string(@reason)=$refreason)])">
   <xsl:message>Vector definition for <xsl:value-of select="$refname" /> not found at
   <xsl:call-template name="describeposition" />.</xsl:message>
  </xsl:if>
  <xsl:choose>
   <xsl:when test="(@href = '') and
                   (@use-description = 'yes') and
                   (//vector-definition[@name=$refname and 
                    ($refreason='' or @reason=$refreason)])">
    <xsl:value-of select="//vector-definition[@name=$refname and 
                             ($refreason='' or
                              @reason=$refreason)]/@description" />
   </xsl:when>
   <xsl:otherwise>
    <xsl:value-of select="$link-content" />
   </xsl:otherwise>
  </xsl:choose>
 </xsl:when>
 
 <!-- SysVar reference -->
 <xsl:when test="@type='sysvar'">
<!--   <tt> -->
  <xsl:if test="(@href = '') and
                 not (//sysvar-definition[@name=$refname and
                        (string(@reason)=$refreason)])">
   <xsl:message>SystemVariable definition for <xsl:value-of select="$refname" /> not found at
   <xsl:call-template name="describeposition" />.</xsl:message>
  </xsl:if>
  <xsl:choose>
   <xsl:when test="(@href = '') and
                   (@use-description = 'yes') and
                   (//sysvar-definition[@name=$refname and 
                    ($refreason='' or @reason=$refreason)])">
    <xsl:value-of select="//sysvar-definition[@name=$refname and 
                             ($refreason='' or
                              @reason=$refreason)]/@description" />
   </xsl:when>
   <xsl:otherwise>
    <xsl:value-of select="$link-content" />
   </xsl:otherwise>
  </xsl:choose>
<!--   </tt> -->
 </xsl:when>
 
 <!-- Section type reference -->
 <xsl:when test="@type='section' or
                 @type='subsection' or
                 @type='subsubsection' or
                 @type='category'">
  <xsl:value-of select="$link-content" />
 </xsl:when>
 
 <!-- Normal links -->
 <xsl:when test="@type='link'">
  <xsl:value-of select="$link-content" />
 </xsl:when>
 
 <!-- Anything else we don't understand -->
 <xsl:otherwise>
  <xsl:text>{*}</xsl:text><xsl:value-of select="$link-content" /><xsl:text>{*}</xsl:text>
  <xsl:message>Reference type '<xsl:value-of select="@type" />' for <xsl:value-of select="$refname" /> is unknown at
   <xsl:call-template name="describeposition" />.</xsl:message>
 </xsl:otherwise>
</xsl:choose>
</xsl:variable>

<!-- Now write out the link -->
<xsl:choose>
 <xsl:when test="(@href!='?') or (@type!='link' and contains(@href,'#'))">
  <xsl:text>&lt;</xsl:text>
  <xsl:copy-of select="$linktext" />
  <xsl:text>=&gt;</xsl:text>
  <xsl:copy-of select="$hrefto" />
  <xsl:text>&gt;</xsl:text>
 </xsl:when>
 <xsl:otherwise>
  <xsl:value-of select="$linktext" />
   <xsl:variable name="complaint">Link for '<xsl:value-of select="translate($linktext,'&#10;',' ')"/>' has undefined destination</xsl:variable>
  <xsl:comment><xsl:value-of select="$complaint" /></xsl:comment>
  <xsl:message><xsl:value-of select="$complaint" /></xsl:message>
 </xsl:otherwise>
</xsl:choose>

</xsl:template>



<xsl:template match="use">
<xsl:apply-templates select="p"/>
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
<xsl:text>\&lt;</xsl:text>
<xsl:apply-templates />
<xsl:text>&gt;</xsl:text>
<xsl:if test="(following-sibling::*[position() = 1]/self::text()) and
              (following-sibling::*[position() = 2]/optional or
               following-sibling::*[position() = 2]/userreplace)">
 <xsl:text> </xsl:text>
</xsl:if>
</xsl:template>


<xsl:template match="text()">
<xsl:variable name="in" select="local-name(..)" />
<xsl:if test="($in = 'p') or
              ($in = 'parameter') or
              ($in = 'command') or
              ($in = 'optional') or
              ($in = 'register-use') or
              ($in = 'userreplace')">
<xsl:variable name="val" select="." />
<xsl:value-of select="translate($val,'&#10;',' ')" />
</xsl:if>
</xsl:template>

<xsl:template match="p">
<xsl:if test="(local-name(..) = 'use') and (count(preceding-sibling::p) != 0)">
 <xsl:text>&#10;</xsl:text>
</xsl:if>
<!-- <xsl:call-template name="strip-leading-spaces"> -->
<!--  <xsl:with-param name="string"><xsl:apply-templates /></xsl:with-param> -->
<!-- </xsl:call-template> -->
<xsl:variable name="string"><xsl:apply-templates /></xsl:variable>
<xsl:value-of select="normalize-space($string)" />
<xsl:text>&#10;</xsl:text>
</xsl:template>

</xsl:stylesheet>
