<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all" version="2.0"
                xmlns:kiln="http://www.kcl.ac.uk/artshums/depts/ddh/kiln/ns/1.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:import href="../../kiln/stylesheets/solr/tei-to-solr.xsl" />

  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Created on:</xd:b> Oct 18, 2010</xd:p>
      <xd:p><xd:b>Author:</xd:b> jvieira</xd:p>
      <xd:p>This stylesheet converts a TEI document into a Solr index document. It expects the parameter file-path,
      which is the path of the file being indexed.</xd:p>
    </xd:desc>
  </xd:doc>

  <xsl:template match="/">
    <add>
      <xsl:apply-imports />
    </add>
  </xsl:template>

  <!-- This template is called by the Kiln tei-to-solr.xsl as part of
       the main doc for the indexed file. Put any code to generate
       additional Solr field data (such as new facets) here. -->
  
  <xsl:template match="tei:orgName" mode="facet_mentioned_institutions">
    <field name="mentioned_institutions">
      <xsl:choose>
        <xsl:when test="@ref and not(@key)"><xsl:value-of select="substring-after(@ref, '#')" /></xsl:when>
        <xsl:when test="@key and not(@ref)"><xsl:value-of select="@key" /></xsl:when>
        <xsl:otherwise><xsl:value-of select="." /></xsl:otherwise>
      </xsl:choose>
    </field>
  </xsl:template>
  
  <xsl:template match="tei:rs" mode="facet_topic">
    <field name="topic">
      <xsl:choose>
        <xsl:when test="@key"><xsl:value-of select="@key"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
      </xsl:choose>
    </field>
  </xsl:template>
  
  <xsl:template match="tei:term[@type='textType']" mode="facet_tipologia">  <!-- ammesse fino a 9 tipi diversi; è possibile aumentarli -->
    <xsl:variable name="textt-id" select="tokenize(replace(@ref,'#',''),' ')"/>
    <xsl:variable name="texttype1-id" select="document('../../content/xml/authority/function_type.xml')//tei:item[@xml:id=$textt-id[1]]/tei:term"/>
    <xsl:variable name="texttype2-id" select="document('../../content/xml/authority/function_type.xml')//tei:item[@xml:id=$textt-id[2]]/tei:term"/>
    <xsl:variable name="texttype3-id" select="document('../../content/xml/authority/function_type.xml')//tei:item[@xml:id=$textt-id[3]]/tei:term"/>
    <xsl:variable name="texttype4-id" select="document('../../content/xml/authority/function_type.xml')//tei:item[@xml:id=$textt-id[4]]/tei:term"/>
    <xsl:variable name="texttype5-id" select="document('../../content/xml/authority/function_type.xml')//tei:item[@xml:id=$textt-id[5]]/tei:term"/>
    <xsl:variable name="texttype6-id" select="document('../../content/xml/authority/function_type.xml')//tei:item[@xml:id=$textt-id[6]]/tei:term"/>
    <xsl:variable name="texttype7-id" select="document('../../content/xml/authority/function_type.xml')//tei:item[@xml:id=$textt-id[7]]/tei:term"/>
    <xsl:variable name="texttype8-id" select="document('../../content/xml/authority/function_type.xml')//tei:item[@xml:id=$textt-id[8]]/tei:term"/>
    <xsl:variable name="texttype9-id" select="document('../../content/xml/authority/function_type.xml')//tei:item[@xml:id=$textt-id[9]]/tei:term"/>
    <xsl:if test="$texttype1-id"><field name="tipologia"><xsl:value-of select="$texttype1-id" /></field></xsl:if>
    <xsl:if test="$texttype2-id"><field name="tipologia"><xsl:value-of select="$texttype2-id" /></field></xsl:if>
    <xsl:if test="$texttype3-id"><field name="tipologia"><xsl:value-of select="$texttype3-id" /></field></xsl:if>
    <xsl:if test="$texttype4-id"><field name="tipologia"><xsl:value-of select="$texttype4-id" /></field></xsl:if>
    <xsl:if test="$texttype5-id"><field name="tipologia"><xsl:value-of select="$texttype5-id" /></field></xsl:if>
    <xsl:if test="$texttype6-id"><field name="tipologia"><xsl:value-of select="$texttype6-id" /></field></xsl:if>
    <xsl:if test="$texttype7-id"><field name="tipologia"><xsl:value-of select="$texttype7-id" /></field></xsl:if>
    <xsl:if test="$texttype8-id"><field name="tipologia"><xsl:value-of select="$texttype8-id" /></field></xsl:if>
    <xsl:if test="$texttype9-id"><field name="tipologia"><xsl:value-of select="$texttype9-id" /></field></xsl:if>
  </xsl:template>
  
  <xsl:template match="tei:term[@type='textFunction']" mode="facet_funzione">  <!-- ammesse fino a 9 funzioni diverse; è possibile aumentarle -->
    <xsl:variable name="textf-id" select="tokenize(replace(@ref,'#',''),' ')"/>
    <xsl:variable name="textfunction1-id" select="document('../../content/xml/authority/function_type.xml')//tei:item[@xml:id=$textf-id[1]]/tei:term"/>
    <xsl:variable name="textfunction2-id" select="document('../../content/xml/authority/function_type.xml')//tei:item[@xml:id=$textf-id[2]]/tei:term"/>
    <xsl:variable name="textfunction3-id" select="document('../../content/xml/authority/function_type.xml')//tei:item[@xml:id=$textf-id[3]]/tei:term"/>
    <xsl:variable name="textfunction4-id" select="document('../../content/xml/authority/function_type.xml')//tei:item[@xml:id=$textf-id[4]]/tei:term"/>
    <xsl:variable name="textfunction5-id" select="document('../../content/xml/authority/function_type.xml')//tei:item[@xml:id=$textf-id[5]]/tei:term"/>
    <xsl:variable name="textfunction6-id" select="document('../../content/xml/authority/function_type.xml')//tei:item[@xml:id=$textf-id[6]]/tei:term"/>
    <xsl:variable name="textfunction7-id" select="document('../../content/xml/authority/function_type.xml')//tei:item[@xml:id=$textf-id[7]]/tei:term"/>
    <xsl:variable name="textfunction8-id" select="document('../../content/xml/authority/function_type.xml')//tei:item[@xml:id=$textf-id[8]]/tei:term"/>
    <xsl:variable name="textfunction9-id" select="document('../../content/xml/authority/function_type.xml')//tei:item[@xml:id=$textf-id[9]]/tei:term"/>
    <xsl:if test="$textfunction1-id"><field name="funzione"><xsl:value-of select="$textfunction1-id" /></field></xsl:if>
    <xsl:if test="$textfunction2-id"><field name="funzione"><xsl:value-of select="$textfunction2-id" /></field></xsl:if>
    <xsl:if test="$textfunction3-id"><field name="funzione"><xsl:value-of select="$textfunction3-id" /></field></xsl:if>
    <xsl:if test="$textfunction4-id"><field name="funzione"><xsl:value-of select="$textfunction4-id" /></field></xsl:if>
    <xsl:if test="$textfunction5-id"><field name="funzione"><xsl:value-of select="$textfunction5-id" /></field></xsl:if>
    <xsl:if test="$textfunction6-id"><field name="funzione"><xsl:value-of select="$textfunction6-id" /></field></xsl:if>
    <xsl:if test="$textfunction7-id"><field name="funzione"><xsl:value-of select="$textfunction7-id" /></field></xsl:if>
    <xsl:if test="$textfunction8-id"><field name="funzione"><xsl:value-of select="$textfunction8-id" /></field></xsl:if>
    <xsl:if test="$textfunction9-id"><field name="funzione"><xsl:value-of select="$textfunction9-id" /></field></xsl:if>
  </xsl:template>
  
  <xsl:template match="tei:textLang" mode="facet_lingua">  <!-- ammesse fino a 9 lingue secondarie diverse; è possibile aumentarle -->
    <xsl:variable name="lang-id" select="@mainLang"/>
    <xsl:variable name="otherlang-id" select="tokenize(@otherLangs,' ')"/>
    <xsl:variable name="language-id" select="document('../../content/xml/authority/language.xml')//tei:item[@xml:id=$lang-id]/tei:term"/>
    <xsl:variable name="otherlanguage1-id" select="document('../../content/xml/authority/language.xml')//tei:item[@xml:id=$otherlang-id[1]]/tei:term"/>
    <xsl:variable name="otherlanguage2-id" select="document('../../content/xml/authority/language.xml')//tei:item[@xml:id=$otherlang-id[2]]/tei:term"/>
    <xsl:variable name="otherlanguage3-id" select="document('../../content/xml/authority/language.xml')//tei:item[@xml:id=$otherlang-id[3]]/tei:term"/>
    <xsl:variable name="otherlanguage4-id" select="document('../../content/xml/authority/language.xml')//tei:item[@xml:id=$otherlang-id[4]]/tei:term"/>
    <xsl:variable name="otherlanguage5-id" select="document('../../content/xml/authority/language.xml')//tei:item[@xml:id=$otherlang-id[5]]/tei:term"/>
    <xsl:variable name="otherlanguage6-id" select="document('../../content/xml/authority/language.xml')//tei:item[@xml:id=$otherlang-id[6]]/tei:term"/>
    <xsl:variable name="otherlanguage7-id" select="document('../../content/xml/authority/language.xml')//tei:item[@xml:id=$otherlang-id[7]]/tei:term"/>
    <xsl:variable name="otherlanguage8-id" select="document('../../content/xml/authority/language.xml')//tei:item[@xml:id=$otherlang-id[8]]/tei:term"/>
    <xsl:variable name="otherlanguage9-id" select="document('../../content/xml/authority/language.xml')//tei:item[@xml:id=$otherlang-id[9]]/tei:term"/>
    <field name="lingua"><xsl:value-of select="$language-id" /></field>
    <xsl:if test="$otherlanguage1-id"><field name="lingua"><xsl:value-of select="$otherlanguage1-id" /></field></xsl:if>
    <xsl:if test="$otherlanguage2-id"><field name="lingua"><xsl:value-of select="$otherlanguage2-id" /></field></xsl:if>
    <xsl:if test="$otherlanguage3-id"><field name="lingua"><xsl:value-of select="$otherlanguage3-id" /></field></xsl:if>
    <xsl:if test="$otherlanguage4-id"><field name="lingua"><xsl:value-of select="$otherlanguage4-id" /></field></xsl:if>
    <xsl:if test="$otherlanguage5-id"><field name="lingua"><xsl:value-of select="$otherlanguage5-id" /></field></xsl:if>
    <xsl:if test="$otherlanguage6-id"><field name="lingua"><xsl:value-of select="$otherlanguage6-id" /></field></xsl:if>
    <xsl:if test="$otherlanguage7-id"><field name="lingua"><xsl:value-of select="$otherlanguage7-id" /></field></xsl:if>
    <xsl:if test="$otherlanguage8-id"><field name="lingua"><xsl:value-of select="$otherlanguage8-id" /></field></xsl:if>
    <xsl:if test="$otherlanguage9-id"><field name="lingua"><xsl:value-of select="$otherlanguage9-id" /></field></xsl:if>
  </xsl:template>
  
  <xsl:template match="tei:term" mode="facet_scrittura">  <!-- ammesse fino a 9 scritture diverse; è possibile aumentarle -->
    <xsl:variable name="scr-id" select="tokenize(replace(@ref,'#',''),' ')"/>
    <xsl:variable name="script1-id" select="document('../../content/xml/authority/script.xml')//tei:item[@xml:id=$scr-id[1]]/tei:term"/>
    <xsl:variable name="script2-id" select="document('../../content/xml/authority/script.xml')//tei:item[@xml:id=$scr-id[2]]/tei:term"/>
    <xsl:variable name="script3-id" select="document('../../content/xml/authority/script.xml')//tei:item[@xml:id=$scr-id[3]]/tei:term"/>
    <xsl:variable name="script4-id" select="document('../../content/xml/authority/script.xml')//tei:item[@xml:id=$scr-id[4]]/tei:term"/>
    <xsl:variable name="script5-id" select="document('../../content/xml/authority/script.xml')//tei:item[@xml:id=$scr-id[5]]/tei:term"/>
    <xsl:variable name="script6-id" select="document('../../content/xml/authority/script.xml')//tei:item[@xml:id=$scr-id[6]]/tei:term"/>
    <xsl:variable name="script7-id" select="document('../../content/xml/authority/script.xml')//tei:item[@xml:id=$scr-id[7]]/tei:term"/>
    <xsl:variable name="script8-id" select="document('../../content/xml/authority/script.xml')//tei:item[@xml:id=$scr-id[8]]/tei:term"/>
    <xsl:variable name="script9-id" select="document('../../content/xml/authority/script.xml')//tei:item[@xml:id=$scr-id[9]]/tei:term"/>
    <xsl:if test="$script1-id"><field name="scrittura"><xsl:value-of select="$script1-id" /></field></xsl:if>
    <xsl:if test="$script2-id"><field name="scrittura"><xsl:value-of select="$script2-id" /></field></xsl:if>
    <xsl:if test="$script3-id"><field name="scrittura"><xsl:value-of select="$script3-id" /></field></xsl:if>
    <xsl:if test="$script4-id"><field name="scrittura"><xsl:value-of select="$script4-id" /></field></xsl:if>
    <xsl:if test="$script5-id"><field name="scrittura"><xsl:value-of select="$script5-id" /></field></xsl:if>
    <xsl:if test="$script6-id"><field name="scrittura"><xsl:value-of select="$script6-id" /></field></xsl:if>
    <xsl:if test="$script7-id"><field name="scrittura"><xsl:value-of select="$script7-id" /></field></xsl:if>
    <xsl:if test="$script8-id"><field name="scrittura"><xsl:value-of select="$script8-id" /></field></xsl:if>
    <xsl:if test="$script9-id"><field name="scrittura"><xsl:value-of select="$script9-id" /></field></xsl:if>
  </xsl:template>
  
  <xsl:template match="tei:seg[@type='phoneme']" mode="facet_phoneme">
    <field name="phoneme">
      <xsl:value-of select="concat(.,' (',@subtype,')')"/>
    </field>
  </xsl:template>
  
  <xsl:template match="tei:seg[@type='grapheme']" mode="facet_grapheme">
    <field name="grapheme">
      <xsl:value-of select="concat(.,' (',@corresp,')')"/>
    </field>
  </xsl:template>
  
  <xsl:template match="tei:m" mode="facet_morpheme">
    <field name="morpheme">
      <xsl:value-of select="."/>
    </field>
  </xsl:template>
  
  <xsl:template match="tei:phr[@type='syntagm']" mode="facet_syntagm">
    <field name="syntagm">
      <xsl:value-of select="."/>
    </field>
  </xsl:template>
  
  <xsl:template match="tei:w[ancestor::tei:div[@type='edition']]" mode="facet_word">
    <field name="word">
      <xsl:value-of select="."/>
    </field>
  </xsl:template>
  
  <!-- This template is called by the Kiln tei-to-solr.xsl as part of
       the main doc for the indexed file. Put any code to generate
       additional Solr field data (such as new facets) here. -->
  <xsl:template name="extra_fields" >
    <xsl:call-template name="field_mentioned_institutions"/>  
    <xsl:call-template name="field_topic"/>
    <xsl:call-template name="field_tipologia"/>  
    <xsl:call-template name="field_funzione"/>  
    <xsl:call-template name="field_lingua"/> 
    <xsl:call-template name="field_scrittura"/>  
    <xsl:call-template name="field_phoneme"/>  
    <xsl:call-template name="field_grapheme"/>  
    <xsl:call-template name="field_morpheme"/>  
    <xsl:call-template name="field_syntagm"/>  
    <xsl:call-template name="field_word"/>  
  </xsl:template>
  
  <xsl:template name="field_mentioned_institutions">
    <xsl:apply-templates mode="facet_mentioned_institutions" select="//tei:div[@type='edition']" />
  </xsl:template>
  
  <xsl:template name="field_topic">
    <xsl:apply-templates mode="facet_topic" select="//tei:div[@type='edition']" />
  </xsl:template>
  
  <xsl:template name="field_tipologia">
    <xsl:apply-templates mode="facet_tipologia" select="//tei:msContents//tei:term[@type='textType']" />
  </xsl:template>
  
  <xsl:template name="field_funzione">
    <xsl:apply-templates mode="facet_funzione" select="//tei:msContents//tei:term[@type='textFunction']" />
  </xsl:template>
  
  <xsl:template name="field_lingua">
    <xsl:apply-templates mode="facet_lingua" select="//tei:textLang" />
  </xsl:template>
  
  <xsl:template name="field_scrittura">
    <xsl:apply-templates mode="facet_scrittura" select="//tei:handDesc/tei:handNote/tei:term" />
  </xsl:template>
  
  <xsl:template name="field_phoneme">
    <xsl:apply-templates mode="facet_phoneme" select="//tei:div[@type='edition']" />
  </xsl:template>
  
  <xsl:template name="field_grapheme">
    <xsl:apply-templates mode="facet_grapheme" select="//tei:div[@type='edition']" />
  </xsl:template>
  
  <xsl:template name="field_morpheme">
    <xsl:apply-templates mode="facet_morpheme" select="//tei:div[@type='edition']" />
  </xsl:template>
  
  <xsl:template name="field_syntagm">
    <xsl:apply-templates mode="facet_syntagm" select="//tei:div[@type='edition']" />
  </xsl:template>
  
  <xsl:template name="field_word">
    <xsl:apply-templates mode="facet_word" select="//tei:div[@type='edition']" />
  </xsl:template>
  
</xsl:stylesheet>
