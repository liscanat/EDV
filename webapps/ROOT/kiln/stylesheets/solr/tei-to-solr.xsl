<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="#all"
                version="2.0"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- This XSLT transforms a TEI document into a Solr index
       document. -->

  <!-- Path to the TEI file being indexed. -->
  <xsl:param name="file-path" />

  <xsl:variable name="document-metadata">
    <xsl:apply-templates mode="document-metadata" select="/*/tei:teiHeader" />
  </xsl:variable>

  <xsl:variable name="free-text">
    <xsl:apply-templates mode="free-text" select="/*/tei:text" />
  </xsl:variable>

  <xsl:template match="/">
    <!-- Entity mentions are restricted to the text of the document;
         entities keyed in the TEI header are document metadata. -->
    <xsl:apply-templates mode="entity-mention" select="/*/tei:text//tei:*[@key]" />

    <!-- Text content -->
    <xsl:if test="normalize-space($free-text)">
      <doc>
        <xsl:sequence select="$document-metadata" />
        <xsl:call-template name="field_document_type" />
        <xsl:call-template name="field_file_path" />
        <xsl:call-template name="field_document_id" />
        <xsl:call-template name="field_text" />
        <xsl:call-template name="field_lemmatised_text" />
        <!-- Facets. -->
        <xsl:call-template name="field_found_provenance" />
        <xsl:call-template name="field_mentioned_people" />
        <xsl:call-template name="field_mentioned_places" />
        <xsl:call-template name="field_regione" />
        <xsl:call-template name="field_collocazione_attuale"/>
        <xsl:call-template name="field_oggetto" />
        <xsl:call-template name="field_materiale" />
        <xsl:call-template name="field_origin_date_evidence"/>
        <xsl:call-template name="extra_fields" />
      </doc>
    </xsl:if>
  </xsl:template>

  <xsl:template match="tei:fileDesc/tei:titleStmt/tei:title" mode="document-metadata">
    <field name="document_title">
      <xsl:value-of select="normalize-space(.)" />
    </field>
  </xsl:template>

  <xsl:template match="tei:fileDesc/tei:titleStmt/tei:author" mode="document-metadata">
    <field name="author">
      <xsl:value-of select="normalize-space(.)" />
    </field>
  </xsl:template>

  <xsl:template match="tei:fileDesc/tei:titleStmt/tei:editor" mode="document-metadata">
    <field name="editor">
      <xsl:value-of select="normalize-space(.)" />
    </field>
  </xsl:template>

  <xsl:template match="tei:sourceDesc//tei:publicationStmt/tei:date[1]"
                mode="document-metadata">
    <xsl:if test="@when">
      <field name="publication_date">
        <xsl:value-of select="@when" />
      </field>
    </xsl:if>
  </xsl:template>

  <!-- For all origDates, use only the year. -->
  <xsl:template match="tei:origDate[@when]" mode="document-metadata">
    <xsl:variable name="year">
      <xsl:call-template name="get-year-from-date">
        <xsl:with-param name="date" select="@when" />
      </xsl:call-template>
    </xsl:variable>
    <field name="origin_date">
      <xsl:value-of select="$year" />
    </field>
  </xsl:template>

  <!-- If @notBefore is specified, @notAfter is assumed to be
       specified, and vice versa. -->
  <xsl:template match="tei:origDate[@notBefore]" mode="document-metadata">
    <xsl:variable name="start-year">
      <xsl:call-template name="get-year-from-date">
        <xsl:with-param name="date" select="@notBefore" />
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="end-year">
      <xsl:call-template name="get-year-from-date">
        <xsl:with-param name="date" select="@notAfter" />
      </xsl:call-template>
    </xsl:variable>
    <xsl:for-each select="($start-year to $end-year)">
      <field name="origin_date">
        <xsl:value-of select="." />
      </field>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="text()" mode="document-metadata" />

  <xsl:template match="node()" mode="free-text">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="@lemma" mode="lemma">
    <xsl:value-of select="." />
    <xsl:text> </xsl:text>
  </xsl:template>

  <xsl:template match="@nymRef" mode="lemma">
    <!-- Only support local references; to add in external references
         would require determining what they are at an earlier step in
         the pipeline and XIncluding the referenced documents. This
         would be a significant change to the existing indexing
         pipeline and XSLT. -->
    <xsl:variable name="root" select="/" />
    <xsl:for-each select="tokenize(., '\s+')">
      <xsl:if test="starts-with(., '#')">
        <!-- Since we have no idea what markup is at the end of this
             reference, just take the text value. -->
        <xsl:value-of select="$root/id(substring-after(current(), '#'))" />
        <xsl:text> </xsl:text>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="node()|@*" mode="lemma">
    <xsl:apply-templates mode="lemma" select="@*|node()" />
  </xsl:template>

  <xsl:template match="tei:*[@key]" mode="entity-mention">
    <doc>
      <xsl:sequence select="$document-metadata" />

      <xsl:call-template name="field_file_path" />
      <xsl:call-template name="field_document_id" />
      <field name="section_id">
        <xsl:value-of select="ancestor::tei:*[self::tei:div or self::tei:body or self::tei:front or self::tei:back or self::tei:group or self::tei:text][@xml:id][1]/@xml:id" />
      </field>
      <field name="entity_key">
        <xsl:value-of select="@key" />
      </field>
      <field name="entity_name">
        <xsl:value-of select="normalize-space(.)" />
      </field>
    </doc>
  </xsl:template>

  <xsl:template match="tei:msIdentifier/tei:district[@ref]" mode="facet_collocazione_attuale">
    <xsl:variable name="repo-id" select="substring-after(@ref,'#')"/>
    <xsl:variable name="repository-id" select="document('../../../content/xml/authority/listPlace.xml')//tei:place[@xml:id=$repo-id]/tei:district[@xml:lang='it']"/>
    <field name="collocazione_attuale">
      <xsl:choose>
        <xsl:when test="$repository-id"><xsl:value-of select="$repository-id" /></xsl:when>
        <xsl:otherwise><xsl:value-of select="$repo-id" /></xsl:otherwise>
      </xsl:choose>
    </field>
  </xsl:template>

  <xsl:template match="tei:material[@ref]" mode="facet_materiale"> <!-- ammessi fino a 9 materiali diversi; è possibile aumentarli -->
    <xsl:variable name="mat-id" select="tokenize(replace(@ref,'#',''),' ')"/>
    <xsl:variable name="material1-id" select="document('../../../content/xml/authority/material.xml')//tei:item[@xml:id=$mat-id[1]]/tei:term"/>
    <xsl:variable name="material2-id" select="document('../../../content/xml/authority/material.xml')//tei:item[@xml:id=$mat-id[2]]/tei:term"/>
    <xsl:variable name="material3-id" select="document('../../../content/xml/authority/material.xml')//tei:item[@xml:id=$mat-id[3]]/tei:term"/>
    <xsl:variable name="material4-id" select="document('../../../content/xml/authority/material.xml')//tei:item[@xml:id=$mat-id[4]]/tei:term"/>
    <xsl:variable name="material5-id" select="document('../../../content/xml/authority/material.xml')//tei:item[@xml:id=$mat-id[5]]/tei:term"/>
    <xsl:variable name="material6-id" select="document('../../../content/xml/authority/material.xml')//tei:item[@xml:id=$mat-id[6]]/tei:term"/>
    <xsl:variable name="material7-id" select="document('../../../content/xml/authority/material.xml')//tei:item[@xml:id=$mat-id[7]]/tei:term"/>
    <xsl:variable name="material8-id" select="document('../../../content/xml/authority/material.xml')//tei:item[@xml:id=$mat-id[8]]/tei:term"/>
    <xsl:variable name="material9-id" select="document('../../../content/xml/authority/material.xml')//tei:item[@xml:id=$mat-id[9]]/tei:term"/>
    <xsl:if test="$material1-id"><field name="materiale"><xsl:value-of select="$material1-id" /></field></xsl:if>
    <xsl:if test="$material2-id"><field name="materiale"><xsl:value-of select="$material2-id" /></field></xsl:if>
    <xsl:if test="$material3-id"><field name="materiale"><xsl:value-of select="$material3-id" /></field></xsl:if>
    <xsl:if test="$material4-id"><field name="materiale"><xsl:value-of select="$material4-id" /></field></xsl:if>
    <xsl:if test="$material5-id"><field name="materiale"><xsl:value-of select="$material5-id" /></field></xsl:if>
    <xsl:if test="$material6-id"><field name="materiale"><xsl:value-of select="$material6-id" /></field></xsl:if>
    <xsl:if test="$material7-id"><field name="materiale"><xsl:value-of select="$material7-id" /></field></xsl:if>
    <xsl:if test="$material8-id"><field name="materiale"><xsl:value-of select="$material8-id" /></field></xsl:if>
    <xsl:if test="$material9-id"><field name="materiale"><xsl:value-of select="$material9-id" /></field></xsl:if>
  </xsl:template> 

  <xsl:template match="tei:origPlace/tei:region[@ref]" mode="facet_regione">
    <!-- This does nothing to prevent duplicate instances of the same
         @ref value being recorded. -->
    <xsl:variable name="orig-id" select="substring-after(@ref,'#')"/>
    <xsl:variable name="origin-id" select="document('../../../content/xml/authority/listPlace.xml')//tei:place[@xml:id=$orig-id]/tei:region[@xml:lang='it']"/>
    <field name="regione">
      <xsl:choose>
        <xsl:when test="$origin-id"><xsl:value-of select="$origin-id" /></xsl:when>
        <xsl:otherwise><xsl:value-of select="$orig-id" /></xsl:otherwise>
      </xsl:choose>
    </field>
  </xsl:template>
  
  <xsl:template match="tei:origDate[@evidence]" mode="facet_origin_date_evidence">
    <xsl:for-each select="tokenize(@evidence, '\s+')">
      <field name="origin_date_evidence">
        <xsl:value-of select="." />
      </field>
    </xsl:for-each>
  </xsl:template>

  <xsl:template match="tei:objectType[@ref]" mode="facet_oggetto"> <!-- ammessi fino a 9 tipi di oggetto diversi; è possibile aumentarli -->
    <xsl:variable name="obj-id" select="tokenize(replace(@ref,'#',''),' ')"/>
    <xsl:variable name="object1-id" select="document('../../../content/xml/authority/object.xml')//tei:item[@xml:id=$obj-id[1]]/tei:term"/>
    <xsl:variable name="object2-id" select="document('../../../content/xml/authority/object.xml')//tei:item[@xml:id=$obj-id[2]]/tei:term"/>
    <xsl:variable name="object3-id" select="document('../../../content/xml/authority/object.xml')//tei:item[@xml:id=$obj-id[3]]/tei:term"/>
    <xsl:variable name="object4-id" select="document('../../../content/xml/authority/object.xml')//tei:item[@xml:id=$obj-id[4]]/tei:term"/>
    <xsl:variable name="object5-id" select="document('../../../content/xml/authority/object.xml')//tei:item[@xml:id=$obj-id[5]]/tei:term"/>
    <xsl:variable name="object6-id" select="document('../../../content/xml/authority/object.xml')//tei:item[@xml:id=$obj-id[6]]/tei:term"/>
    <xsl:variable name="object7-id" select="document('../../../content/xml/authority/object.xml')//tei:item[@xml:id=$obj-id[7]]/tei:term"/>
    <xsl:variable name="object8-id" select="document('../../../content/xml/authority/object.xml')//tei:item[@xml:id=$obj-id[8]]/tei:term"/>
    <xsl:variable name="object9-id" select="document('../../../content/xml/authority/object.xml')//tei:item[@xml:id=$obj-id[9]]/tei:term"/>
    <xsl:if test="$object1-id"><field name="oggetto"><xsl:value-of select="$object1-id" /></field></xsl:if>
    <xsl:if test="$object2-id"><field name="oggetto"><xsl:value-of select="$object2-id" /></field></xsl:if>
    <xsl:if test="$object3-id"><field name="oggetto"><xsl:value-of select="$object3-id" /></field></xsl:if>
    <xsl:if test="$object4-id"><field name="oggetto"><xsl:value-of select="$object4-id" /></field></xsl:if>
    <xsl:if test="$object5-id"><field name="oggetto"><xsl:value-of select="$object5-id" /></field></xsl:if>
    <xsl:if test="$object6-id"><field name="oggetto"><xsl:value-of select="$object6-id" /></field></xsl:if>
    <xsl:if test="$object7-id"><field name="oggetto"><xsl:value-of select="$object7-id" /></field></xsl:if>
    <xsl:if test="$object8-id"><field name="oggetto"><xsl:value-of select="$object8-id" /></field></xsl:if>
    <xsl:if test="$object9-id"><field name="oggetto"><xsl:value-of select="$object9-id" /></field></xsl:if>
  </xsl:template>

  <xsl:template match="tei:persName" mode="facet_mentioned_people">
    <xsl:variable name="pers-id" select="substring-after(@ref,'#')"/>
    <xsl:variable name="person-id" select="document('../../../content/xml/authority/listPerson.xml')//tei:person[@xml:id=$pers-id]/tei:persName"/>
    <field name="mentioned_people">
      <xsl:choose>
        <xsl:when test="@ref and not(@key)">
          <xsl:choose>
            <xsl:when test="$person-id"><xsl:value-of select="$person-id" /></xsl:when>
            <xsl:otherwise><xsl:value-of select="$pers-id" /></xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="@key and not(@ref)"><xsl:value-of select="@key" /></xsl:when>
        <xsl:otherwise><xsl:value-of select="." /></xsl:otherwise>
      </xsl:choose>
    </field>
  </xsl:template>

  <xsl:template match="tei:placeName[@ref]" mode="facet_found_provenance">
    <field name="found_provenance">
      <xsl:value-of select="@ref" />
    </field>
  </xsl:template>

  <xsl:template match="tei:placeName | geogName" mode="facet_mentioned_places">
    <xsl:variable name="pl-id" select="substring-after(@ref,'#')"/>
    <xsl:variable name="place-id" select="document('../../../content/xml/authority/places.xml')//tei:place[@xml:id=$pl-id]/tei:placeName"/>
    <field name="mentioned_places">
      <xsl:choose>
        <xsl:when test="@ref and not(@key)">
          <xsl:choose>
            <xsl:when test="$place-id"><xsl:value-of select="$place-id" /></xsl:when>
            <xsl:otherwise><xsl:value-of select="$pl-id" /></xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:when test="@key and not(@ref)"><xsl:value-of select="@key" /></xsl:when>
        <xsl:otherwise><xsl:value-of select="." /></xsl:otherwise>
      </xsl:choose>
    </field>
  </xsl:template>

  <xsl:template name="field_document_id">
    <field name="document_id">
      <xsl:variable name="idno" select="/tei:*/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type='filename']" />
      <xsl:choose>
        <xsl:when test="normalize-space($idno)">
          <xsl:value-of select="$idno" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="/tei:*/@xml:id" />
        </xsl:otherwise>
      </xsl:choose>
    </field>
  </xsl:template>

  <xsl:template name="field_document_type">
    <field name="document_type">
      <xsl:value-of select="substring-before($file-path, '/')" />
    </field>
  </xsl:template>

  <xsl:template name="field_file_path">
    <field name="file_path">
      <xsl:value-of select="$file-path" />
    </field>
  </xsl:template>

  <xsl:template name="field_found_provenance">
    <xsl:apply-templates mode="facet_found_provenance" select="//tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:history/tei:provenance[@type='found']" />
  </xsl:template>

  <xsl:template name="field_lemmatised_text">
    <field name="lemmatised_text">
      <xsl:apply-templates mode="lemma" select="//tei:text" />
    </field>
  </xsl:template>

  <xsl:template name="field_mentioned_people">
    <xsl:apply-templates mode="facet_mentioned_people" select="//tei:text/tei:body/tei:div[@type='edition']" />
  </xsl:template>

  <xsl:template name="field_mentioned_places">
    <xsl:apply-templates mode="facet_mentioned_places" select="//tei:text/tei:body/tei:div[@type='edition']" />
  </xsl:template>

  <xsl:template name="field_regione">
    <xsl:apply-templates mode="facet_regione" select="//tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:history/tei:origin/tei:origPlace" />
  </xsl:template>

  <xsl:template name="field_collocazione_attuale">
    <xsl:apply-templates mode="facet_collocazione_attuale" select="//tei:teiHeader/tei:fileDesc/tei:sourceDesc//tei:msIdentifier"/>
  </xsl:template>

  <xsl:template name="field_materiale">
    <xsl:apply-templates mode="facet_materiale" select="//tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:physDesc/tei:objectDesc/tei:supportDesc/tei:support/tei:material[@ref]" />
  </xsl:template>
  
  <xsl:template name="field_origin_date_evidence">
    <xsl:apply-templates mode="facet_origin_date_evidence" select="//tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:history/tei:origin/tei:origDate[@evidence]"/>
  </xsl:template>

  <xsl:template name="field_oggetto">
    <xsl:apply-templates mode="facet_oggetto" select="//tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:physDesc/tei:objectDesc/tei:supportDesc/tei:support/tei:objectType[@ref]" />
  </xsl:template>

  <xsl:template name="field_text">
    <field name="text">
      <xsl:value-of select="normalize-space($free-text)" />
    </field>
  </xsl:template>

  <!-- Return an integer year from a "date", that might be in one of a
       number of formats. Specifically, handles YYYY, YYYY-MM, and
       YYYY-MM-DD, with optional preceding "-". -->
  <xsl:template name="get-year-from-date">
    <xsl:param name="date" />
    <xsl:variable name="parts" select="tokenize(substring($date, 2), '-')" />
    <xsl:variable name="normalised-date">
      <xsl:value-of select="$date" />
      <xsl:choose>
        <xsl:when test="count($parts) = 1">
          <xsl:text>-01-01</xsl:text>
        </xsl:when>
        <xsl:when test="count($parts) = 2">
          <xsl:text>-01</xsl:text>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:value-of select="year-from-date(xs:date($normalised-date))" />
  </xsl:template>

</xsl:stylesheet>
