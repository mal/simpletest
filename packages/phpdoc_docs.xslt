<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <!-- $Id$ -->

    <xsl:output method="xml" indent="yes" cdata-section-elements="program-listing"/>
    <xsl:preserve-space elements="*"/>
    
    <xsl:template match="/">
        <refentry>
            <xsl:attribute name="id"><![CDATA[{@id}]]></xsl:attribute>
            <xsl:call-template name="head"/>
            <![CDATA[{@doc}]]>
            <xsl:call-template name="body"/>
        </refentry>
    </xsl:template>
    
    <xsl:template name="head">
        <refnamediv>
            <refname><xsl:value-of select="/page/@here"/></refname>
            <refpurpose>
                <xsl:apply-templates select="//introduction/p/node()"/>
            </refpurpose>
        </refnamediv>
    </xsl:template>
    
    <xsl:template name="body">
        <xsl:apply-templates select="//content/node()"/>
    </xsl:template>
    
    <xsl:template match="p">
        <para>
            <xsl:apply-templates/>
        </para>
    </xsl:template>
    
    <xsl:template match="php">
        <program-listing role="php">
            <xsl:call-template name="strip_strong">
                <xsl:with-param name="raw" select="."/>
            </xsl:call-template>
        </program-listing>
    </xsl:template>
    
    <xsl:template match="code">
        <span class="new_code">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <xsl:template match="section">
        <refsect1>
            <xsl:attribute name="id">{@id <xsl:value-of select="@name"/>}</xsl:attribute>
            <title><xsl:value-of select="@title"/></title>
            <xsl:apply-templates/>
        </refsect1>
    </xsl:template>
    
    <xsl:template match="introduction">
    </xsl:template>
    
    <xsl:template match="news">
    </xsl:template>
    
    <xsl:template match="a[@class = 'target']">
        <title><xsl:value-of select="h2"/></title>
    </xsl:template>
    
    <xsl:template match="a">
        <xsl:copy>
            <xsl:for-each select="@class|@name|@href">
                <xsl:attribute name="{local-name(.)}"><xsl:value-of select="."/></xsl:attribute>
            </xsl:for-each>
            <xsl:for-each select="@local">
                <xsl:attribute name="href">
                    <xsl:value-of select="."/><xsl:text>.html</xsl:text>
                </xsl:attribute>
            </xsl:for-each>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="*">
        <xsl:copy>
            <xsl:for-each select="@*">
                <xsl:attribute name="{local-name(.)}"><xsl:value-of select="."/></xsl:attribute>
            </xsl:for-each>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template name="strip_strong">
        <xsl:param name="raw"/>
        <xsl:choose>
            <xsl:when test="contains($raw, '&lt;strong&gt;') and contains($raw, '&lt;/strong&gt;')">
                <xsl:value-of select="substring-before($raw, '&lt;strong&gt;')"/>
                <xsl:value-of select="substring-before(substring-after($raw, '&lt;strong&gt;'), '&lt;/strong&gt;')"/>
                <xsl:call-template name="strip_strong">
                    <xsl:with-param name="raw" select="substring-after($raw, '&lt;/strong&gt;')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise><xsl:value-of select="$raw"/></xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>