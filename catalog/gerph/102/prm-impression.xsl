<?xml version="1.0" standalone="yes"?>

<!-- RISC OS PRM stylesheet - written by hand; apologies for errors in
     style.
     Please note that this Impression DDF file conversion is NOT complete;
     it's really just something I wanted to try to see how well (or not)
     it worked. I'm actually quite pleased with it so far, but there is
     still a lot of work to do.
     
     (c) Justin Fletcher, distribution unlimited.
     
     Important things that are wrong:
       Code definitions aren't implemented.
       Command definitions don't handle syntax properly.
       UpCalls and messages not tested.
       Work out how to normalise text in the source - the newlines are
       causing it to look completely screwed.

     Minor things that need doing:
       Content and Index identifiers on styles
       Remove all HTML markup.
     
     Things that seemt to be impossible:
       Indenting based on the current level - you can't just say 'indent
       by 1cm', AFAICT; this affects any of the tables.

     This stylesheet has not been updated for a long time; it may not
     function even as it was written originally.
-->

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                >
<xsl:strip-space elements="*" />
<xsl:preserve-space elements="" />
<xsl:output method="text" indent="no" xml:space="default"/>

<xsl:template match="/">
<xsl:text>{
define style "BaseText";
 font Trinity.Medium;
 fontsize 14pt;
 linespacep 120%;
 spaceabove 6pt;
 spacebelow 0pt;
 leftmargin 85pt;
 rightmargin 0pt;
 returnmargin 85pt;
 condframethrow 0pt;
 fontaspect 100%;
 fontcolour rgb=(0,0,0);
 linecolour rgb=(0,0,0);
 rulecolour rgb=(0,0,0);
 justify left;
 underline 0;
 strikeout off;
 script off;
 hyphenate on;
 leader "";
 locktolinespace off;
 italic off;
 bold off;
 ruleaboveoffset 0pt;
 rulecontrol 0;
 vertrulewidth 1pt;
 ruleleftmargin 0pt;
 rulerightmargin 0pt;
 rulewidth 0pt;
 ruleoffset 0pt;
 tracking 0;
 dectabchar ".";
 keepparagraph off;
 keepnext off;
 keepregion off;
 tabs 85pt,153.1pt,227.3pt,299.3pt,371.3pt,443.3pt,515.3pt,587.3pt,659.3pt;
 menuitem off}{
define style "Section";
 font Homerton.Medium;
 fontsize 24pt;
 linespacep 120%;
 spaceabove 12pt;
 spacebelow 8pt;
 leftmargin 0pt;
 rightmargin 0pt;
 returnmargin 0pt;
 fontcolour rgb=(0,0,0);
 script off;
 hyphenate off;
 leader "";
 italic off;
 bold off;
 keepparagraph on;
 contents 1;
 autoparagraph;
 shortcut 385;
 tabs 83.3pt,155.3pt,227.3pt,299.3pt,371.3pt,443.3pt,515.3pt,587.3pt;
 menuitem on}{
define style "SubSection";
 font Homerton.Medium;
 fontsize 17pt;
 spaceabove 5pt;
 leftmargin 0pt;
 rightmargin 0pt;
 returnmargin 0pt;
 hyphenate off;
 leader "";
 italic off;
 bold on;
 keepnext on;
 contents 2;
 autoparagraph;
 shortcut 386;
 tabs 83.3pt,155.3pt,227.3pt,299.3pt,371.3pt,443.3pt,515.3pt,587.3pt;
 menuitem on}{
define style "SubSubSection";
 font Homerton.Medium;
 fontsize 16pt;
 leftmargin 0pt;
 rightmargin 0pt;
 returnmargin 42.5pt;
 bold on;
 autoparagraph;
 tabs 42.5pt,155.3pt,227.3pt,299.3pt,371.3pt,443.3pt,515.3pt,587.3pt;
 menuitem on}{
define style "Category";
 font Homerton.Medium;
 fontsize 14pt;
 bold on;
 contents 4;
 autoparagraph;
 shortcut 458;
 menuitem on}{
define style "PageHeader";
 font Homerton.Medium;
 fontsize 12pt;
 linespacep 120%;
 fontaspect 100%;
 linecolour rgb=(0,0,0);
 justify right;
 underline 0;
 strikeout off;
 script off;
 hyphenate off;
 leader "";
 locktolinespace off;
 italic on;
 bold off;
 dectabchar ".";
 autoparagraph;
 menuitem off}{
define style "PageFooter";
 font Trinity.Medium;
 fontsize 12pt;
 linespacep 120%;
 spaceabove 0pt;
 spacebelow 0pt;
 leftmargin 0pt;
 rightmargin 0pt;
 returnmargin 28.3pt;
 condframethrow 0pt;
 fontaspect 100%;
 fontcolour rgb=(0,0,0);
 backcolour rgb=(1,1,1);
 linecolour rgb=(0,0,0);
 justify right;
 underline 0;
 strikeout off;
 script off;
 hyphenate off;
 leader "";
 locktolinespace off;
 italic on;
 bold off;
 dectabchar ".";
 keepparagraph off;
 keepnext off;
 keepregion off;
 autoparagraph;
 tabs 28.3pt,centre 260.8pt,right 521.6pt,587.3pt;
 menuitem off}{
define style "Chapter";
 font Homerton.Medium;
 fontsize 32pt;
 linespace 24pt;
 spacebelow 32pt;
 leftmargin 0pt;
 rightmargin 0pt;
 returnmargin 0pt;
 italic off;
 bold on;
 ruleaboveoffset 6pt;
 rulecontrol 6;
 rulewidth 3pt;
 ruleoffset -2pt;
 autoparagraph;
 tabs 85pt,155.3pt,227.3pt,299.3pt,371.3pt,443.3pt,515.3pt,587.3pt;
 menuitem on}{
define style "DefinitionTitle";
 font Homerton.Medium;
 fontsize 22pt;
 justify right;
 autoparagraph;
 menuitem on}{
define style "DefinitionValue";
 fontsize 18pt;
 menuitem on}{
define style "DefinitionSection";
 font Homerton.Medium;
 fontsize 16pt;
 leftmargin 0pt;
 rightmargin 0pt;
 returnmargin 42.5pt;
 bold on;
 autoparagraph;
 tabs 42.5pt,155.3pt,227.3pt,299.3pt,371.3pt,443.3pt,515.3pt,587.3pt;
 menuitem on}{
define style "Command";
 font Corpus.Medium;
 menuitem on}{
define style "ParameterTable";
 leftmargin 198.4pt;
 rightmargin 0pt;
 returnmargin 85pt;
 autoparagraph;
 tabs 184.3pt,198.4pt,212.6pt,226.8pt,240.9pt,371.3pt,443.3pt,515.3pt,587.3pt;
 menuitem on}{
define style "Variable";
 italic on;
 menuitem on}{
define style "ValueTable3";
 leftmargin 326pt;
 rightmargin 0pt;
 returnmargin 113.4pt;
 autoparagraph;
 tabs 212.6pt,326pt,371.3pt,413.9pt,515.3pt,587.3pt;
 menuitem on}{
define style "OffsetTable3";
 leftmargin 326pt;
 rightmargin 0pt;
 returnmargin 113.4pt;
 autoparagraph;
 tabs 212.6pt,326pt,371.3pt,413.9pt,515.3pt,587.3pt;
 menuitem on}{
define style "BitFieldTable3";
 leftmargin 326pt;
 rightmargin 0pt;
 returnmargin 113.4pt;
 autoparagraph;
 tabs 212.6pt,326pt,371.3pt,413.9pt,515.3pt,587.3pt;
 menuitem on}{
define style "ValueTable2";
 leftmargin 170.1pt;
 rightmargin 0pt;
 returnmargin 113.4pt;
 autoparagraph;
 tabs 170.1pt,326pt,371.3pt,413.9pt,515.3pt,587.3pt;
 menuitem on}{
define style "OffsetTable2";
 leftmargin 170.1pt;
 rightmargin 0pt;
 returnmargin 113.4pt;
 autoparagraph;
 tabs 170.1pt,326pt,371.3pt,413.9pt,515.3pt,587.3pt;
 menuitem on}{
define style "BitFieldTable2";
 leftmargin 170.1pt;
 rightmargin 0pt;
 returnmargin 113.4pt;
 autoparagraph;
 tabs 170.1pt,326pt,371.3pt,413.9pt,515.3pt,587.3pt;
 menuitem on}{
define style "RegisterUse";
 leftmargin 127.6pt;
 rightmargin 0pt;
 returnmargin 85pt;
 autoparagraph;
 tabs 113.4pt,127.6pt,227.3pt,299.3pt,371.3pt,443.3pt,515.3pt,587.3pt;
 menuitem on}{"BaseText" on}</xsl:text>
<xsl:apply-templates/>
<xsl:text>{"BaseText" off}</xsl:text>
</xsl:template>

<xsl:template match="chapter">
<xsl:text>{"Chapter" on}{tab}</xsl:text>
<xsl:value-of select="@title"/>
<xsl:text>
{"Chapter" off}</xsl:text>

<xsl:apply-templates select="section"/>

</xsl:template>

<!-- Sections -->
<xsl:template match="section">
<xsl:text>{"Section" on}</xsl:text>
<xsl:value-of select="@title" />
<xsl:text>
{"Section" off}</xsl:text>
<xsl:apply-templates />
<xsl:text>{nextframe}</xsl:text>
</xsl:template>

<!-- Sub-Sections -->
<xsl:template match="subsection">
<xsl:text>{"SubSection" on}</xsl:text>
<xsl:value-of select="@title" />
<xsl:text>
{"SubSection" off}</xsl:text>
<xsl:apply-templates />
</xsl:template>

<!-- Sub-Sub-Sections -->
<xsl:template match="subsubsection">
<xsl:text>{"SubSubSection" on}</xsl:text>
<xsl:value-of select="@title" />
<xsl:text>
{"SubSubSection" off}</xsl:text>
<xsl:apply-templates />
</xsl:template>

<!-- Category -->
<xsl:template match="category">
<xsl:text>{"Category" on}</xsl:text>
<xsl:value-of select="@title" />
<xsl:text>
{"Category" off}</xsl:text>
<xsl:apply-templates />
</xsl:template>

<!-- command definitions ? -->
<xsl:template match="command-definition">
<xsl:text>{"DefinitionTitle" on}</xsl:text>
*<xsl:value-of select="@name" />
<xsl:text>
{"DefinitionTitle" off}</xsl:text>
<xsl:value-of select="@description"/>

<xsl:text>
{"DefinitionSection" on}Syntax
{"DefinitionSection" off}{"Command" on}</xsl:text>
<xsl:choose>
 <xsl:when test="count(syntax)=0">
  <xsl:text>*</xsl:text><xsl:value-of select="@name"/>
 </xsl:when>
 <xsl:otherwise>
  <xsl:for-each select="syntax">
   <xsl:text>*</xsl:text><xsl:value-of select="//@name"/>
   <xsl:apply-templates />
  </xsl:for-each>
 </xsl:otherwise>
</xsl:choose>
<xsl:text>{"Command" off}</xsl:text>

<xsl:text>
{"DefinitionSection" on}Parameters
{"DefinitionSection" off}{"ParameterTable" on}</xsl:text>
<xsl:choose>
 <xsl:when test="count(parameter)=0">None</xsl:when>
 <xsl:otherwise>
  <xsl:for-each select="parameter">
   <xsl:text>{"Command" on}</xsl:text>
         <xsl:if test="@switch != ''">
          <xsl:text>-</xsl:text>
          <xsl:value-of select="@switch" />
          <xsl:text> </xsl:text>
         </xsl:if>
         <xsl:if test="@name != ''">
          <xsl:text>{"Variable" on}</xsl:text>
          <xsl:value-of select="@name" />
          <xsl:text>{"Variable" off}</xsl:text>
         </xsl:if>
   <xsl:text>{"Command" off}{tab}-{tab}</xsl:text>
   <xsl:apply-templates />
  </xsl:for-each>
 </xsl:otherwise>
</xsl:choose>
<xsl:text>{"ParameterTable" off}</xsl:text>

<xsl:apply-templates select="use" />

<xsl:choose>
 <xsl:when test="count(example) > 0">
  <!-- I've probably missed an easier way to do this... -->
  <xsl:choose>
   <xsl:when test="count(example) = 1">

<xsl:text>
{"DefinitionSection" on}Example
{"DefinitionSection" off}</xsl:text>

   </xsl:when>
   <xsl:otherwise>
<xsl:text>
{"DefinitionSection" on}Examples
{"DefinitionSection" off}</xsl:text>

   </xsl:otherwise>
  </xsl:choose>

  <xsl:for-each select="example">
   <xsl:apply-templates />
  </xsl:for-each>
 </xsl:when>
</xsl:choose>

<xsl:apply-templates select="related" />
 
<xsl:text>{nextframe}</xsl:text>
</xsl:template>

<xsl:template match="related">
<xsl:text>
{"DefinitionSection" on}Related commands
{"DefinitionSection" off}</xsl:text>
<xsl:choose>
 <xsl:when test="count(related-commands) = 0">None</xsl:when>
 <xsl:otherwise>
  <xsl:for-each select="related-commands">
  <xsl:if test="position() > 1">, </xsl:if>
   <a>
    <xsl:attribute name="href">
     <xsl:value-of select="@href"/>
    </xsl:attribute>
    *<xsl:value-of select="@name"/>
   </a>
  </xsl:for-each>
 </xsl:otherwise>
</xsl:choose>

<xsl:text>
{"DefinitionSection" on}Related SWIs
{"DefinitionSection" off}</xsl:text>
<xsl:choose>
 <xsl:when test="count(related-swis) = 0">None</xsl:when>
 <xsl:otherwise>
  <xsl:for-each select="related-swis">
  <xsl:if test="position() > 1">, </xsl:if>
   <a>
    <xsl:attribute name="href">
     <xsl:value-of select="@href"/>
    </xsl:attribute>
    <xsl:value-of select="@name"/>
   </a>
  </xsl:for-each>
 </xsl:otherwise>
</xsl:choose>

<xsl:text>
{"DefinitionSection" on}Related vectors
{"DefinitionSection" off}</xsl:text>
<xsl:choose>
 <xsl:when test="count(related-vectors) = 0">None</xsl:when>
 <xsl:otherwise>
  <xsl:for-each select="related-vectors">
  <xsl:if test="position() > 1">, </xsl:if>
   <a>
    <xsl:attribute name="href">
     <xsl:value-of select="@href"/>
    </xsl:attribute>
    *<xsl:value-of select="@name"/>
   </a>
  </xsl:for-each>
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
<xsl:template match="swi-definition">
<xsl:text>{"DefinitionTitle" on}</xsl:text>
<xsl:value-of select="@name" />
<xsl:if test="@reason != ''" xml:space="default">
 <xsl:text> </xsl:text>
 <xsl:value-of select="@reason"/>
</xsl:if>
<xsl:text>
({"DefinitionValue" on}SWI &hex;</xsl:text>
<xsl:value-of select="@number"/>
<xsl:text>{"DefinitionValue" off})
{"DefinitionTitle" off}</xsl:text>

<xsl:choose>
 <xsl:when test="@internal = 'yes'">
 <xsl:text>This SWI call is for internal use only. You must not use it in your own code.</xsl:text>
 </xsl:when>
 <xsl:otherwise>
  <xsl:value-of select="@description"/>
  
<xsl:text>
{"DefinitionSection" on}On entry
{"DefinitionSection" off}</xsl:text>
  <xsl:choose>
   <xsl:when test="count(entry/*)=0">None</xsl:when>
   <xsl:otherwise>
    <xsl:apply-templates select="entry"/>
   </xsl:otherwise>
  </xsl:choose>
  
<xsl:text>
{"DefinitionSection" on}On exit
{"DefinitionSection" off}</xsl:text>
  <xsl:choose>
   <xsl:when test="count(exit/*)=0">None</xsl:when>
   <xsl:otherwise>
    <xsl:apply-templates select="exit"/>
   </xsl:otherwise>
  </xsl:choose>
  
<xsl:text>
{"DefinitionSection" on}Interrupts
{"DefinitionSection" off}</xsl:text>
Interrupts are <xsl:value-of select="@irqs" />
Fast interrupts are <xsl:value-of select="@fiqs"/>

<xsl:text>
{"DefinitionSection" on}Processor mode
{"DefinitionSection" off}</xsl:text>
Processor is in <xsl:value-of select="@processor-mode"/> mode

<xsl:text>
{"DefinitionSection" on}Re-entrancy
{"DefinitionSection" off}</xsl:text>
  <xsl:choose>
    <xsl:when test='@re-entrant="yes"'>SWI is re-entrant</xsl:when>
    <xsl:when test='@re-entrant="undefined"'>Not defined</xsl:when>
    <xsl:when test='@re-entrant="no"'>SWI is not re-entrant</xsl:when>
    <xsl:otherwise><xsl:value-of select="@re-entrant"/></xsl:otherwise>
  </xsl:choose>

  <xsl:apply-templates select="use" />

  <xsl:choose>
   <xsl:when test="count(example) > 0">
    <!-- I've probably missed an easier way to do this... -->
    <xsl:choose>
     <xsl:when test="count(example) = 1">

<xsl:text>
{"DefinitionSection" on}Example
{"DefinitionSection" off}</xsl:text>

     </xsl:when>
     <xsl:otherwise>

<xsl:text>
{"DefinitionSection" on}Examples
{"DefinitionSection" off}</xsl:text>

     </xsl:otherwise>
    </xsl:choose>

    <xsl:for-each select="example">
     <xsl:apply-templates />
    </xsl:for-each>
   </xsl:when>
  </xsl:choose>

  <xsl:apply-templates select="related" />
  
 </xsl:otherwise>
</xsl:choose>

<xsl:text>{nextframe}</xsl:text>
</xsl:template>


<!-- Code definition -->
<xsl:template match="code-definition">
<dl>
<dt><hr />
<h2 align="right"><a>
          <xsl:attribute name="name">
           <xsl:text>code_</xsl:text>
           <xsl:value-of select="translate(@name,'ABCDEFGHIJKLMNOPQRSTUVWXYZ ,$()-*?','abcdefghijklmnopqrstuvwxyz_-')" />
           <xsl:if test="@reason!=''">
            <xsl:text>-</xsl:text>
            <xsl:value-of select="translate(@reason,'ABCDEFGHIJKLMNOPQRSTUVWXYZ ,$()-*? ','abcdefghijklmnopqrstuvwxyz- ')" />
           </xsl:if>
          </xsl:attribute>
          <xsl:value-of select="@name"/>
<!--     <xsl:if test="(@reason != '') and (@reasonname != '')"> -->
<!--      <xsl:text> </xsl:text> -->
<!--      <xsl:value-of select="@reasonname"/> -->
<!--     </xsl:if> -->
    <xsl:if test="@reason != ''" xml:space="default">
     <xsl:text> </xsl:text>
     <xsl:value-of select="@reason"/>
    </xsl:if>
    </a>
    <br />
    <xsl:if test="@number != ''">
     (<acronym>&hex;<xsl:value-of select="@number"/></acronym>
<!--     <xsl:if test="@reason != ''"> -->
<!--      <xsl:text> reason </xsl:text> -->
<!--      <xsl:value-of select="@reason"/> -->
<!--     </xsl:if> -->
     <xsl:text xml:space="default">)</xsl:text>
    </xsl:if></h2>
</dt>

<xsl:choose>
 <xsl:when test="@internal = 'yes'">
 This entry point is for internal use only. You must not use it in
        your own code.</xsl:when>
 <xsl:otherwise>
  <xsl:value-of select="@description"/>
  
<xsl:text>
{"DefinitionSection" on}On entry
{"DefinitionSection" off}</xsl:text>
  <xsl:choose>
   <xsl:when test="count(entry/*)=0">None</xsl:when>
   <xsl:otherwise>
    <xsl:apply-templates select="entry"/>
   </xsl:otherwise>
  </xsl:choose>
  
<xsl:text>
{"DefinitionSection" on}On exit
{"DefinitionSection" off}</xsl:text>
  <xsl:choose>
   <xsl:when test="count(exit/*)=0">None</xsl:when>
   <xsl:otherwise>
    <table summary="Conditions on exit" border="0">
    <xsl:apply-templates select="exit"/>
    </table>
   </xsl:otherwise>
  </xsl:choose>
  
<xsl:text>
{"DefinitionSection" on}Interrupts
{"DefinitionSection" off}</xsl:text>
Interrupts are <xsl:value-of select="@irqs" />
Fast interrupts are <xsl:value-of select="@fiqs"/>

<xsl:text>
{"DefinitionSection" on}Processor mode
{"DefinitionSection" off}</xsl:text>
Processor is in <xsl:value-of select="@processor-mode"/> mode

<xsl:text>
{"DefinitionSection" on}Re-entrancy
{"DefinitionSection" off}</xsl:text>

  <xsl:choose>
    <xsl:when test='@re-entrant="yes"'>SWI is re-entrant</xsl:when>
    <xsl:when test='@re-entrant="undefined"'>Not defined</xsl:when>
    <xsl:when test='@re-entrant="no"'>SWI is not re-entrant</xsl:when>
    <xsl:otherwise><xsl:value-of select="@re-entrant"/></xsl:otherwise>
  </xsl:choose>

  <xsl:apply-templates select="use" />

 </xsl:otherwise>
</xsl:choose>
</dl>
 
</xsl:template>
<!-- Wimp Message definition -->
<xsl:template match="message-definition">
<hr />
<h2 align="right"><a>
          <xsl:attribute name="name">
           <xsl:text>message_</xsl:text>
           <xsl:value-of select="translate(@name,'ABCDEFGHIJKLMNOPQRSTUVWXYZ ,$()-*?','abcdefghijklmnopqrstuvwxyz_-')" />
          </xsl:attribute>
          Message_<xsl:value-of select="@name"/>
    </a>
    <br />
    (<acronym>&hex;<xsl:value-of select="@number"/></acronym>)
    </h2>
<xsl:choose>
 <xsl:when test="@internal = 'yes'">
 This Wimp Message is for internal use only. You must not use it in
 your own code.</xsl:when>
 <xsl:otherwise>
  <xsl:value-of select="@description"/>
  
<xsl:text>
{"DefinitionSection" on}Message
{"DefinitionSection" off}</xsl:text>

  <xsl:apply-templates select="message-table" />
   
<xsl:text>
{"DefinitionSection" on}Source
{"DefinitionSection" off}</xsl:text>

  <xsl:choose>
   <xsl:when test="@source=''">Any application</xsl:when>
   <xsl:otherwise><xsl:value-of select="@source" /></xsl:otherwise>
  </xsl:choose>
  
<xsl:text>
{"DefinitionSection" on}Destination
{"DefinitionSection" off}</xsl:text>

  <xsl:choose>
   <xsl:when test="@destination=''">Any application</xsl:when>
   <xsl:otherwise><xsl:value-of select="@destination" /></xsl:otherwise>
  </xsl:choose>

  <xsl:apply-templates select="use" />

  <xsl:apply-templates select="related" />
  
 </xsl:otherwise>
</xsl:choose>
 
<xsl:text>{nextframe}</xsl:text>

</xsl:template>

<!-- Service definition -->
<xsl:template match="service-definition">
<xsl:text>{"DefinitionTitle" on}Service_</xsl:text>
<xsl:value-of select="@name" />
<xsl:if test="@reason != ''" xml:space="default">
 <xsl:text> </xsl:text>
 <xsl:value-of select="@reason"/>
</xsl:if>
<xsl:text>
({"DefinitionValue" on}Service &hex;</xsl:text>
<xsl:value-of select="@number"/>
<xsl:text>{"DefinitionValue" off})
{"DefinitionTitle" off}</xsl:text>

<xsl:choose>
 <xsl:when test="@internal = 'yes'">
 This Service call is for internal use only. You must not use it in
 your own code.</xsl:when>
 <xsl:otherwise>
  <xsl:value-of select="@description"/>
  
<xsl:text>
{"DefinitionSection" on}On entry
{"DefinitionSection" off}</xsl:text>

  <xsl:choose>
   <xsl:when test="count(entry/*)=0">None</xsl:when>
   <xsl:otherwise>
    <xsl:apply-templates select="entry"/>
   </xsl:otherwise>
  </xsl:choose>
  
<xsl:text>
{"DefinitionSection" on}On exit
{"DefinitionSection" off}</xsl:text>

  <xsl:choose>
   <xsl:when test="count(exit/*)=0">None</xsl:when>
   <xsl:otherwise>
    <xsl:apply-templates select="exit"/>
   </xsl:otherwise>
  </xsl:choose>
  
  <xsl:apply-templates select="use" />

  <xsl:choose>
   <xsl:when test="count(example) > 0">
    <!-- I've probably missed an easier way to do this... -->
    <xsl:choose>
     <xsl:when test="count(example) = 1">

<xsl:text>
{"DefinitionSection" on}Example
{"DefinitionSection" off}</xsl:text>

     </xsl:when>
     <xsl:otherwise>

<xsl:text>
{"DefinitionSection" on}Examples
{"DefinitionSection" off}</xsl:text>

     </xsl:otherwise>
    </xsl:choose>

    <xsl:for-each select="example">
     <xsl:apply-templates />
    </xsl:for-each>
   </xsl:when>
  </xsl:choose>

  <xsl:apply-templates select="related" />
  
 </xsl:otherwise>
</xsl:choose>
 
<xsl:text>{nextframe}</xsl:text>

</xsl:template>

<!-- Upcall definition -->
<xsl:template match="upcall-definition">
<xsl:text>{"DefinitionTitle" on}UpCall_</xsl:text>
<xsl:value-of select="@name" />
<xsl:if test="@reason != ''" xml:space="default">
 <xsl:text> </xsl:text>
 <xsl:value-of select="@reason"/>
</xsl:if>
<xsl:text>
({"DefinitionValue" on}UpCall &hex;</xsl:text>
<xsl:value-of select="@number"/>
<xsl:text>{"DefinitionValue" off})
{"DefinitionTitle" off}</xsl:text>
<xsl:value-of select="@description"/>

<xsl:choose>
 <xsl:when test="@internal = 'yes'">
This UpCall is for internal use only. You must not use it in your own code.
 </xsl:when>
 <xsl:otherwise>
  
<xsl:text>
{"DefinitionSection" on}On entry
{"DefinitionSection" off}</xsl:text>

  <xsl:choose>
   <xsl:when test="count(entry/*)=0">None</xsl:when>
   <xsl:otherwise>
    <xsl:apply-templates select="entry"/>
   </xsl:otherwise>
  </xsl:choose>
  
<xsl:text>
{"DefinitionSection" on}On exit
{"DefinitionSection" off}</xsl:text>

  <xsl:choose>
   <xsl:when test="count(exit/*)=0">None</xsl:when>
   <xsl:otherwise>
    <xsl:apply-templates select="exit"/>
   </xsl:otherwise>
  </xsl:choose>
  
  <xsl:apply-templates select="use" />

  <xsl:apply-templates select="related" />
  
 </xsl:otherwise>
</xsl:choose>
 
<xsl:text>{nextframe}</xsl:text>

</xsl:template>

<xsl:template match="use">
<xsl:text>
{"DefinitionSection" on}Use
{"DefinitionSection" off}</xsl:text>
<xsl:apply-templates />
</xsl:template>

<!-- Register -->
<xsl:template match="register-use">
<xsl:text>{"RegisterUse" on}</xsl:text>
<xsl:choose>
 <xsl:when test="@state='preserved'">
  <xsl:text>R</xsl:text>
  <xsl:value-of select="@number"/>
  <xsl:text> preserved</xsl:text>
 </xsl:when>
 <xsl:when test="@state='corrupted'">
  <xsl:text>R</xsl:text>
  <xsl:value-of select="@number"/>
  <xsl:text> corrupted</xsl:text>
 </xsl:when>
 <xsl:otherwise>
  <xsl:text>R</xsl:text>
  <xsl:value-of select="@number"/>
  <xsl:text>{tab}={tab}</xsl:text>
  <xsl:apply-templates/>
 </xsl:otherwise>
</xsl:choose>
<xsl:text>
{"RegisterUse" off}</xsl:text>
</xsl:template>


<!-- A bitfield-table turns into a regular XHTML table, with header -->
<xsl:template match="bitfield-table">
<xsl:if test="count(*/@name) > 0">
 <xsl:text>{"BitFieldTable3" on}</xsl:text>
</xsl:if>
<xsl:if test="count(*/@name) = 0">
 <xsl:text>{"BitFieldTable2" on}</xsl:text>
</xsl:if>

 <xsl:choose>
  <xsl:when test="count(bit-range)=0">
   <xsl:text>Bit{tab}</xsl:text>
   <xsl:if test="count(*/@name)>0">
    <xsl:text>Name{tab}</xsl:text>
   </xsl:if>
   <xsl:text>Meaning if set
</xsl:text>
  </xsl:when>
  <xsl:otherwise>
   <xsl:text>Bits{tab}</xsl:text>
   <xsl:if test="count(*/@name)>0">
    <xsl:text>Name{tab}</xsl:text>
   </xsl:if>
   <xsl:text>Meaning
</xsl:text>
  </xsl:otherwise>
 </xsl:choose>

<xsl:apply-templates/>

<xsl:if test="count(*/@name) > 0">
 <xsl:text>{"BitFieldTable3" off}</xsl:text>
</xsl:if>
<xsl:if test="count(*/@name) = 0">
 <xsl:text>{"BitFieldTable2" off}</xsl:text>
</xsl:if>

</xsl:template>

<xsl:template match="bit">
<xsl:value-of select="@number"/>
<xsl:text>{tab}</xsl:text>
<xsl:if test="count(../*/@name) > 0">
 <xsl:value-of select="@name"/>
 <xsl:text>{tab}</xsl:text>
</xsl:if>
<xsl:apply-templates/>
<xsl:text>
</xsl:text>
</xsl:template>

<!-- A value table is just a table of values with headings -->
<xsl:template match="value-table">
<xsl:if test="@head-name != ''">
 <xsl:text>{"ValueTable3" on}</xsl:text>
</xsl:if>
<xsl:if test="@head-name = ''">
 <xsl:text>{"ValueTable2" on}</xsl:text>
</xsl:if>
<xsl:value-of select="@head-number" />
<xsl:text>{tab}</xsl:text>
<xsl:if test="@head-name != ''">
 <xsl:value-of select="@head-name" />
 <xsl:text>{tab}</xsl:text>
</xsl:if>
<xsl:value-of select="@head-value" />
<xsl:text>
</xsl:text>
<xsl:apply-templates/>
<xsl:if test="@head-name != ''">
 <xsl:text>{"ValueTable3" off}</xsl:text>
</xsl:if>
<xsl:if test="@head-name = ''">
 <xsl:text>{"ValueTable2" off}</xsl:text>
</xsl:if>
</xsl:template>

<xsl:template match="value">
<xsl:value-of select="@number"/>
<xsl:text>{tab}</xsl:text>
<xsl:if test="@name != ''">
 <xsl:value-of select="@name"/>
 <xsl:text>{tab}</xsl:text>
</xsl:if>
<xsl:apply-templates/>
<xsl:text>
</xsl:text>
</xsl:template>

<!-- An offset table is similar to the value-table -->
<xsl:template match="offset-table">
<xsl:if test="@head-name != ''">
 <xsl:text>{"OffsetTable3" on}</xsl:text>
</xsl:if>
<xsl:if test="@head-name = ''">
 <xsl:text>{"OffsetTable2" on}</xsl:text>
</xsl:if>
<xsl:value-of select="@head-number" />
<xsl:text>{tab}</xsl:text>
<xsl:if test="@head-name != ''">
 <xsl:value-of select="@head-name" />
 <xsl:text>{tab}</xsl:text>
</xsl:if>
<xsl:value-of select="@head-value" />
<xsl:text>
</xsl:text>
<xsl:apply-templates/>
<xsl:if test="@head-name != ''">
 <xsl:text>{"OffsetTable3" off}</xsl:text>
</xsl:if>
<xsl:if test="@head-name = ''">
 <xsl:text>{"OffsetTable2" off}</xsl:text>
</xsl:if>
</xsl:template>

<xsl:template match="offset">
<xsl:value-of select="@number"/>
<xsl:text>{tab}</xsl:text>
<xsl:if test="@name != ''">
 <xsl:value-of select="@name"/>
 <xsl:text>{tab}</xsl:text>
</xsl:if>
<xsl:apply-templates/>
<xsl:text>
</xsl:text>
</xsl:template>



<!-- An message table is similar to the offset-table -->
<xsl:template match="message-table">
<table summary="Opaque table for a wimp message block" border="0">
 <tr>
  <th align="right" valign="bottom">Offset</th>
  <th align="left" valign="bottom">Contents</th>
 </tr>
 <xsl:apply-templates/>
</table>
</xsl:template>

<xsl:template match="message">
<tr>
 <td valign="top" align="right">R1+<xsl:value-of select="@offset"/></td>
 <td valign="top" align="left"><xsl:apply-templates/></td>
</tr>
</xsl:template>

<!-- References; we assume entities are used to resolve repositories; is
     this sane ? -->
<xsl:template match="reference">
<a>
<xsl:attribute name="href"><xsl:value-of select="@href"/></xsl:attribute>
<xsl:apply-templates /></a>
</xsl:template>

<!-- List comes in two forms; ordered and unordered -->
<xsl:template match="list">
<xsl:choose>
 <xsl:when test="@type = 'ordered'">
  <ol>
  <xsl:for-each select="*">
   <li><xsl:apply-templates select="."/></li>
  </xsl:for-each>
  </ol>
 </xsl:when>
 
 <xsl:otherwise>
  <ul>
  <xsl:for-each select="*">
   <li><xsl:apply-templates select="."/></li>
  </xsl:for-each>
  </ul>
 </xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- Paragraphs are simple -->
<xsl:template match="p">
<xsl:apply-templates />
<xsl:text>
</xsl:text>
</xsl:template>

<!-- User replacement - something the user must replace with a value -->
<xsl:template match="userreplace">
<i>&lt;<xsl:apply-templates />&gt;</i>
</xsl:template>

<!-- User input - something the user could have typed -->
<xsl:template match="userinput">
<tt><xsl:apply-templates /></tt>
</xsl:template>

<!-- Menu option - an option that the user might chose for a menu -->
<xsl:template match="menuoption">
<em><xsl:apply-templates /></em>
</xsl:template>

<!-- Variable -->
<xsl:template match="variable">
{"Variable" on}&lt;<xsl:apply-templates />&gt;{"Variable" off}
</xsl:template>

<!-- Command example -->
<xsl:template match="command">
{"Command" on}<xsl:apply-templates />{"Command" off}
</xsl:template>

<!-- User replacement -->
<xsl:template match="optional">
[
<xsl:for-each select="*">
<xsl:if test="(position()>1) and (//@alternates='true')">
 <xsl:text> | </xsl:text>
</xsl:if>
<xsl:apply-templates select="."/>
</xsl:for-each>
]
</xsl:template>

<!-- Command line switch -->
<xsl:template match="switch">
-<xsl:value-of select="@name" />
<xsl:if test="(text() != '') or (count(*) > 0)">
 <xsl:text> </xsl:text><xsl:apply-templates />
</xsl:if>
</xsl:template>

<!-- Long example -->
<xsl:template match="extended-example">
<pre>
<xsl:apply-templates />
</pre>
</xsl:template>

<!-- Stylistic changes -->
<!-- These should really be removed ASAP and replaced with more content-based
     elements, such as warning, important or note -->
<xsl:template match="strong">
<strong><xsl:apply-templates /></strong>
</xsl:template>
<xsl:template match="em">
<em><xsl:apply-templates /></em>
</xsl:template>
<xsl:template match="br">
<!-- I'm not at all sure I like the concept of having a break element -->
<br />
</xsl:template>

</xsl:stylesheet>
