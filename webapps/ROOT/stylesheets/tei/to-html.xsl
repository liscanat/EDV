<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Project-specific XSLT for transforming TEI to
       HTML. Customisations here override those in the core
       to-html.xsl (which should not be changed). -->

  <xsl:import href="../../kiln/stylesheets/tei/to-html.xsl" />


  <xsl:template match="tei:body">
  <div><xsl:apply-templates/></div>
</xsl:template>
  
  <xsl:template match="tei:div">
    <div><xsl:apply-templates /></div>
  </xsl:template>
  
  <xsl:template match="tei:p">
    <p class="info"><xsl:apply-templates /></p>
  </xsl:template>
  
  <xsl:template match="tei:bibl">
    <p class="info"><xsl:attribute name="id"><xsl:value-of select="@xml:id"/></xsl:attribute><xsl:apply-templates /></p>
  </xsl:template>
  
  <xsl:template match="tei:bibl/tei:author">
    <xsl:value-of select="."/>
  </xsl:template>
  
  <xsl:template match="tei:bibl/tei:publisher">
    <xsl:value-of select="."/>
  </xsl:template>
  
  <xsl:template match="tei:bibl/tei:pubPlace">
    <xsl:value-of select="."/>
  </xsl:template>
  
  <xsl:template match="tei:list/tei:item">
    <br/><xsl:value-of select="." />
  </xsl:template>
  
  <xsl:template match="tei:div[@xml:id]">
    <div><xsl:attribute name="id"><xsl:value-of select="@xml:id"/></xsl:attribute><xsl:apply-templates /></div>
  </xsl:template>
  
  <xsl:template match="tei:p[@xml:id]">
    <p><xsl:attribute name="id"><xsl:value-of select="@xml:id"/></xsl:attribute><xsl:apply-templates /></p>
  </xsl:template>
  
  <xsl:template match="tei:foreign">
    <i><xsl:apply-templates/></i>
  </xsl:template>
  
  <xsl:template match="tei:bibl//tei:title">
    <i><xsl:apply-templates/></i>
  </xsl:template>
  
  <xsl:template match="tei:hi[@rend='superscript']">
    <sup><xsl:apply-templates/></sup>
  </xsl:template>
  
  <xsl:template match="tei:head">
    <h4><xsl:apply-templates /></h4>
  </xsl:template>
  
  <xsl:template match="tei:div//tei:ref[@target][@type='link']">
    <a><xsl:attribute name="href"><xsl:value-of select="@target"/></xsl:attribute><xsl:attribute name="target"><xsl:value-of select="'_blank'"/></xsl:attribute><xsl:apply-templates/></a>
  </xsl:template>
</xsl:stylesheet>
