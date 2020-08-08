<?xml version="1.0" standalone="yes"?>

<!-- RISC OS PRM stylesheet - written by hand; apologies for errors in
     style.

     Generates header files from documentation.
     (c) Justin Fletcher, distribution unlimited.
     -->

<!DOCTYPE doc [
<!ENTITY newline "&#10;">
]>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/TR/xhtml1/strict"
                xmlns:common="http://exslt.org/common"
                extension-element-prefixes="common">

<xsl:output method="text" indent="no"/>

<xsl:template match="/">
<xsl:if test="count(/riscos-prm/chapter//service-definition) +
              count(/riscos-prm/chapter//vector-definition) +
              count(/riscos-prm/chapter//message-definition) +
              count(/riscos-prm/chapter//error-definition) +
              count(/riscos-prm/chapter//upcall-definition) +
              count(/riscos-prm/chapter//tboxmethod-definition) +
              count(/riscos-prm/chapter//tboxmessage-definition) +
              count(/riscos-prm/chapter//swi-definition) > 0">
<xsl:apply-templates select="/riscos-prm/chapter" />
</xsl:if>
</xsl:template>

<xsl:template name="longest-text">
<xsl:param name="nodes"/>
<xsl:for-each select="$nodes">
    <xsl:sort select="string-length(.)" order="descending" data-type="number"/>
    <xsl:if test="position() = 1">
       <xsl:value-of select="string-length(.)"/>
    </xsl:if>
</xsl:for-each>
</xsl:template>

<xsl:template name="padding">
<xsl:param name="length"/>

<xsl:if test="$length > 0">
    <xsl:call-template name="padding">
        <xsl:with-param name="length" select="$length - 1" />
    </xsl:call-template>
    <xsl:text> </xsl:text>
</xsl:if>
</xsl:template>


<xsl:template match="/riscos-prm/chapter">

<xsl:text>/* Automatically generated header file for </xsl:text>
<xsl:value-of select="@title" />
<xsl:text> */&newline;&newline;</xsl:text>

<xsl:text>#ifndef </xsl:text>
<xsl:value-of select="translate(@title,' ,.()-*?','_--')" />
<xsl:text>_Definitions_H&newline;</xsl:text>

<xsl:text>#define </xsl:text>
<xsl:value-of select="translate(@title,' ,.()-*?','_--')" />
<xsl:text>_Definitions_H&newline;</xsl:text>


<!-- Service entries -->
<xsl:call-template name='definitions'>
    <xsl:with-param name='nodes' select="descendant::node()/service-definition"/>
    <xsl:with-param name='label' select="'Services'"/>
    <xsl:with-param name='prefix' select="'Service_'"/>
</xsl:call-template>


<!-- UpCall entries -->
<xsl:call-template name='definitions'>
    <xsl:with-param name='nodes' select="descendant::node()/upcall-definition"/>
    <xsl:with-param name='label' select="'UpCalls'"/>
    <xsl:with-param name='prefix' select="'UpCall_'"/>
</xsl:call-template>


<!-- SWI entries -->
<xsl:call-template name='definitions'>
    <xsl:with-param name='nodes' select="descendant::node()/swi-definition"/>
    <xsl:with-param name='label' select="'SWIs'"/>
    <xsl:with-param name='prefix' select="''"/>
</xsl:call-template>


<!-- Vector entries -->
<xsl:call-template name='definitions'>
    <xsl:with-param name='nodes' select="descendant::node()/vector-definition"/>
    <xsl:with-param name='label' select="'Vectors'"/>
    <xsl:with-param name='prefix' select="'Vector_'"/>
</xsl:call-template>


<!-- Message entries -->
<xsl:call-template name='definitions'>
    <xsl:with-param name='nodes' select="descendant::node()/message-definition"/>
    <xsl:with-param name='label' select="'Messages'"/>
    <xsl:with-param name='prefix' select="'WimpMessage_'"/>
</xsl:call-template>


<!-- Error entries -->
<xsl:call-template name='definitions'>
    <xsl:with-param name='nodes' select="descendant::node()/error-definition"/>
    <xsl:with-param name='label' select="'Errors'"/>
    <xsl:with-param name='prefix' select="'ErrorNumber_'"/>
</xsl:call-template>


<!-- Toolbox Method entries -->
<xsl:call-template name='definitions'>
    <xsl:with-param name='nodes' select="descendant::node()/tboxmethod-definition"/>
    <xsl:with-param name='label' select="'Toolbox Methods'"/>
    <xsl:with-param name='prefix' select="'ToolboxMethod_'"/>
</xsl:call-template>


<!-- Toolbox Messages entries -->
<xsl:call-template name='definitions'>
    <xsl:with-param name='nodes' select="descendant::node()/tboxmessage-definition"/>
    <xsl:with-param name='label' select="'Toolbox Messages'"/>
    <xsl:with-param name='prefix' select="'ToolboxMessage_'"/>
</xsl:call-template>

<xsl:text>&newline;#endif&newline;</xsl:text>
</xsl:template>


<xsl:template name='definitions'>
<xsl:param name='nodes'/>
<xsl:param name='label'/>
<xsl:param name='prefix'/>

<xsl:if test="count($nodes) > 0">
    <xsl:text>&newline;/* </xsl:text>
    <xsl:value-of select="$label"/>
    <xsl:text> */&newline;</xsl:text>
</xsl:if>

<xsl:variable name="symbol-names">
    <xsl:for-each select='$nodes'>
        <xsl:element name="name">
            <xsl:apply-templates select="." mode="symbol-name"/>
        </xsl:element>
    </xsl:for-each>
</xsl:variable>

<xsl:variable name="longest">
    <xsl:call-template name="longest-text">
        <xsl:with-param name="nodes" select="common:node-set($symbol-names)/*"/>
    </xsl:call-template>
</xsl:variable>

<xsl:for-each select="$nodes">
    <xsl:variable name="thisnumber" select="@number"/>
    <xsl:variable name="thisreason" select="@reason"/>
    <xsl:variable name="symbol-name">
        <xsl:apply-templates select="." mode="symbol-name"/>
    </xsl:variable>
    <xsl:choose>
     <xsl:when test="@reason != ''">

        <xsl:if test="count(preceding-sibling::node()[@number = $thisnumber]) = 0">
            <xsl:text>#define </xsl:text>
            <xsl:value-of select="$prefix"/>
            <xsl:value-of select="@name"/>
            <xsl:call-template name="padding">
                <xsl:with-param name="length" select="$longest - string-length(@name)" />
            </xsl:call-template>
            <xsl:text> 0x</xsl:text>
            <xsl:value-of select="@number" />
            <xsl:text>&newline;</xsl:text>
        </xsl:if>

        <xsl:if test="contains(@reason,',') = false">
            <xsl:text>#define </xsl:text>
            <xsl:value-of select="$prefix"/>
            <xsl:value-of select="$symbol-name"/>
            <xsl:call-template name="padding">
                <xsl:with-param name="length" select="$longest - string-length($symbol-name)" />
            </xsl:call-template>
            <xsl:text>     </xsl:text>
            <xsl:value-of select="@reason" />
            <xsl:text> /* </xsl:text>
            <xsl:value-of select="@description" />
            <xsl:text> */&newline;</xsl:text>
        </xsl:if>

     </xsl:when>

     <xsl:otherwise>
        <xsl:text>#define </xsl:text>
        <xsl:value-of select="$prefix"/>
        <xsl:value-of select="$symbol-name"/>
        <xsl:call-template name="padding">
            <xsl:with-param name="length" select="$longest - string-length($symbol-name)" />
        </xsl:call-template>
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
         <xsl:text> */&newline;</xsl:text>
     </xsl:otherwise>
    </xsl:choose>
</xsl:for-each>
</xsl:template>

<xsl:template match="node()" mode="symbol-name"/>

<xsl:template match="swi-definition | service-definition | vector-definition | message-definition | event-definition | tboxmethod-definition | tboxmessage-definition | error-definition | upcall-definition" mode="symbol-name">
    <xsl:choose>
        <xsl:when test="@reason != ''">
            <xsl:value-of select="@name" />
            <xsl:text>_</xsl:text>
            <xsl:value-of select="@reasonname" />
        </xsl:when>

        <xsl:otherwise>
            <xsl:value-of select="@name" />
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

</xsl:stylesheet>
