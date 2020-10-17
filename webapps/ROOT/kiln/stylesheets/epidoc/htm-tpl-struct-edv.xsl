<?xml version="1.0" encoding="UTF-8"?>
<!-- $Id$ -->
<xsl:stylesheet xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema" 
                xmlns:t="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="t" 
                version="2.0">
  <!-- Contains named templates for edv file structure (aka "metadata" aka "supporting data") -->  
   
   <!-- Called from htm-tpl-structure.xsl -->

  <xsl:template name="edv-body-structure">
     
     <xsl:if test="//t:facsimile//t:graphic[@url!='']">
       <div id="images">
           <xsl:for-each select="//t:facsimile//t:graphic">
             <xsl:if test="not(contains(@url,'http'))">
             <span class="image">
             <xsl:apply-templates select="." />
               <span>&#160;</span>
             </span>
             </xsl:if>
           </xsl:for-each>
         <xsl:if test="//t:facsimile//t:graphic/t:desc//text() or //t:facsimile//t:graphic[@resp!='']">
           <span class="caption">
             <p class="caption_text"><!--<i><i18n:text i18n:key="edv-photo">Foto</i18n:text>: </i>-->
               <xsl:for-each select="//t:facsimile//t:graphic">
               <xsl:if test="./t:desc//text()"><xsl:apply-templates select="./t:desc"/>.</xsl:if>
             <xsl:if test="./t:desc//text() and @resp!=''"><xsl:text> </xsl:text></xsl:if>
             <xsl:if test="@resp!=''"><xsl:apply-templates select="@resp"/>.</xsl:if>
               <xsl:text> </xsl:text>
             </xsl:for-each>
           </p>
           </span>
         </xsl:if>
     </div>
   </xsl:if>
     
     <div id="metadata">
       <p><xsl:if test="//t:origin/t:origPlace/t:region">
       <b><i18n:text i18n:key="edv-region">Regione</i18n:text>: </b>
       <xsl:apply-templates select="//t:origin/t:origPlace/t:region"/>
       <br/></xsl:if>
       <xsl:if test="//t:origin/t:origDate">
         <b><i18n:text i18n:key="edv-date">Datazione</i18n:text>: </b>  <!-- precision="medium" se la date in numeri vanno prese in considerazione per quanto approssimate, precision="low" se vanno ignorate in quanto approssimate in modo convenzionale per secoli o frazioni di secolo -->
       <xsl:choose>
         <xsl:when test="//t:origin/t:origDate[@precision='low']">
         <xsl:apply-templates select="//t:origin/t:origDate"/></xsl:when>
         <xsl:otherwise>
           <xsl:choose>   
             <xsl:when test="//t:origin/t:origDate[@when]"><xsl:apply-templates select="//t:origin/t:origDate/@when"/></xsl:when>
             <xsl:otherwise><xsl:apply-templates select="//t:origin/t:origDate/@notBefore"/>
               <xsl:text>-</xsl:text>
               <xsl:apply-templates select="//t:origin/t:origDate/@notAfter"/>
             </xsl:otherwise>
           </xsl:choose>
           <xsl:if test="//t:origin/t:origDate[@precision='medium']"><xsl:text> ca.</xsl:text></xsl:if>
         </xsl:otherwise>
       </xsl:choose>
       <br/></xsl:if>
       <xsl:if test="//t:support/t:objectType">
       <b><i18n:text i18n:key="edv-object">Oggetto</i18n:text>: </b>
         <xsl:apply-templates select="//t:support/t:objectType"/>
         <br /></xsl:if>
       <xsl:if test="//t:support/t:material">
         <b><i18n:text i18n:key="edv-material">Materiale</i18n:text>: </b>
       <xsl:apply-templates select="//t:support/t:material"/>
       <br /></xsl:if>
       <xsl:if test="//t:support/t:dimensions//text()">
         <b><i18n:text i18n:key="edv-dimension">Dimensioni</i18n:text>: </b>
         <xsl:apply-templates select="//t:support/t:dimensions" mode="edv-dimensions"/><xsl:text> cm</xsl:text> <!-- l./w., h., spessore -->
       <br /></xsl:if>
       <xsl:if test="//t:summary/t:term[@type='textFunction']">
       <b><i18n:text i18n:key="edv-function">Funzione</i18n:text>: </b>
       <xsl:apply-templates select="//t:summary/t:term[@type='textFunction']"/>
       <br /></xsl:if>
       <xsl:if test="//t:summary/t:term[@type='textType']">
       <b><i18n:text i18n:key="edv-type">Tipologia</i18n:text>: </b>
       <xsl:apply-templates select="//t:summary/t:term[@type='textType']"/>
       <br /></xsl:if>
       <xsl:if test="//t:handDesc/t:handNote">
       <b><i18n:text i18n:key="edv-script">Scrittura</i18n:text>: </b>
       <xsl:apply-templates select="//t:handDesc/t:handNote"/>
       <br /></xsl:if>
       <xsl:if test="//t:textLang">
       <b><i18n:text i18n:key="edv-language">Lingua</i18n:text>: </b>
       <xsl:apply-templates select="//t:textLang"/>
       <br/></xsl:if>
       <xsl:if test="//t:msIdentifier">
         <b><i18n:text i18n:key="edv-repository">Collocazione attuale</i18n:text>: </b>
       <xsl:apply-templates select="//t:msIdentifier/t:placeName"/><xsl:text> (</xsl:text>
       <xsl:apply-templates select="//t:msIdentifier/t:district"/>
       <xsl:text>), </xsl:text>
       <xsl:apply-templates select="//t:msIdentifier/t:repository"/>
       <xsl:if test="//t:msIdentifier/t:repository/t:idno//text()"><xsl:text>, </xsl:text>
         <xsl:apply-templates select="//t:msIdentifier/t:repository/t:idno"/>
       </xsl:if>
         </xsl:if>
         <xsl:for-each select="//t:facsimile//t:graphic">
           <xsl:if test="contains(@url,'http')">
           <br/><b><i18n:text i18n:key="edv-photo">Foto</i18n:text>: </b>
             <a><xsl:attribute name="href"><xsl:value-of select="//t:facsimile//t:graphic/@url" /></xsl:attribute><xsl:attribute name="target"><xsl:value-of select="'_blank'"/></xsl:attribute><xsl:value-of select="//t:facsimile//t:graphic/@url" /></a>
         </xsl:if>
         </xsl:for-each>
     </p>
     </div>
    
         <xsl:if test="//t:div[@type='edition'][@subtype='interpretive']//t:lb">
         <div id="edition">
           <h2><b><i18n:text i18n:key="edv-interpretive-edition">Edizione interpretativa</i18n:text></b></h2>
           <!-- Edited text output -->
           <xsl:variable name="edtxt">
             <xsl:apply-templates select="//t:div[@type='edition'][@subtype='interpretive']">
               <xsl:with-param name="parm-edition-type" select="'interpretive'" tunnel="yes"/>
             </xsl:apply-templates>
           </xsl:variable>
           <!-- Moded templates found in htm-tpl-sqbrackets.xsl -->
           <xsl:apply-templates select="$edtxt" mode="sqbrackets"/>
         </div>
         </xsl:if>
       
    <xsl:if test="//t:div[@type='edition'][@subtype='diplomatic']//t:lb">
         <div id="diplomatic">
           <h2><b><i18n:text i18n:key="edv-diplomatic-edition">Edizione diplomatica</i18n:text></b></h2>
           <xsl:variable name="edtxt">
             <xsl:apply-templates select="//t:div[@type='edition'][@subtype='diplomatic']">
               <xsl:with-param name="parm-edition-type" select="'interpretive'" tunnel="yes"/>
             </xsl:apply-templates>
           </xsl:variable>
           <xsl:apply-templates select="$edtxt" mode="sqbrackets"/>
         </div>
       </xsl:if>
     
     

     <xsl:if test="//t:div[@type='apparatus']/t:p//text()">
       <div id="apparatus">
       <h2><b><i18n:text i18n:key="edv-apparatus">Apparato critico</i18n:text></b></h2>
       <!-- Apparatus text output -->
       <xsl:variable name="apptxt">
         <xsl:apply-templates select="//t:div[@type='apparatus']/t:p"/>
       </xsl:variable>
       <!-- Moded templates found in htm-tpl-sqbrackets.xsl -->
       <xsl:apply-templates select="$apptxt" mode="sqbrackets"/>
     </div>
     </xsl:if>

     <xsl:if test="//t:div[@type='commentary'][@subtype='linguistic_analysis']/t:p//text()">
       <div id="commentary_linguistic_analysis">
         <h2><b><i18n:text i18n:key="edv-linguistic-analysis">Analisi linguistica</i18n:text></b></h2>
           <xsl:apply-templates select="//t:div[@type='commentary'][@subtype='linguistic_analysis']/t:p"/>
     </div>
     </xsl:if>
     
     <xsl:if test="//t:div[@type='commentary'][@subtype='note']/t:p//text()">
       <div id="commentary_notes">
       <h2><b><i18n:text i18n:key="edv-notes">Note</i18n:text></b></h2>
       <xsl:apply-templates select="//t:div[@type='commentary'][@subtype='note']/t:p"/>
     </div>
     </xsl:if>

     <xsl:if test="//t:div[@type='bibliography']/t:p//text()">
       <div id="bibliography">
       <h2><b><i18n:text i18n:key="edv-bibliography">Bibliografia</i18n:text></b></h2>
         
         <xsl:if test="//t:div[@type='bibliography']/t:p[@xml:id='editions']/text()">
           <p><i><i18n:text i18n:key="edv-bibliography-editions">Edizioni</i18n:text>: </i>
           <xsl:apply-templates select="//t:div[@type='bibliography']/t:p[@xml:id='editions']/node()"></xsl:apply-templates></p></xsl:if>
         
         <xsl:if test="//t:div[@type='bibliography']/t:p[@xml:id='other']/text()">
           <p><i><i18n:text i18n:key="edv-bibliography-other">Altri studi</i18n:text>: </i>
           <xsl:apply-templates select="//t:div[@type='bibliography']/t:p[@xml:id='other']/node()"/></p></xsl:if>
         
         <xsl:if test="//t:div[@type='bibliography']/t:p[@xml:id='images']/text()">
           <p><i><i18n:text i18n:key="edv-bibliography-images">Riproduzioni</i18n:text>: </i>
           <xsl:apply-templates select="//t:div[@type='bibliography']/t:p[@xml:id='images']/node()"/></p></xsl:if>
     </div>
     </xsl:if>
     
     <div id="authors">
       <h2><b><i18n:text i18n:key="edv-authors">Autori</i18n:text></b></h2>
         <p>
           <xsl:if test="//t:titleStmt/t:editor[@role='data_collection']//text()">
           <i><i18n:text i18n:key="edv-editor-data-collection">Raccolta dati</i18n:text>: </i>
         <xsl:apply-templates select="//t:titleStmt/t:editor[@role='data_collection']"/>
         <br/></xsl:if>
           <xsl:if test="//t:titleStmt/t:editor[@role='edition']//text()">
           <i><i18n:text i18n:key="edv-editor-edition">Edizione</i18n:text>: </i>
         <xsl:apply-templates select="//t:titleStmt/t:editor[@role='edition']"/>
         <br/></xsl:if>
           <xsl:if test="//t:titleStmt/t:editor[@role='commentary']//text()">
         <i><i18n:text i18n:key="edv-editor-commentary">Commento</i18n:text>: </i>
         <xsl:apply-templates select="//t:titleStmt/t:editor[@role='commentary']"/>
         <br/></xsl:if>
           <xsl:if test="//t:titleStmt/t:editor[@role='encoding']//text()">
           <i><i18n:text i18n:key="edv-editor-encoding">Edizione digitale e indici</i18n:text>: </i>
         <xsl:apply-templates select="//t:titleStmt/t:editor[@role='encoding']"/>
         </xsl:if>
           <xsl:if test="//t:titleStmt/t:editor[@role='images']//text()">
             <br/><i><i18n:text i18n:key="edv-editor-images">Immagini</i18n:text>: </i>
             <xsl:apply-templates select="//t:titleStmt/t:editor[@role='images']"/>
           </xsl:if></p>
     </div>
           
     <div id="date">
       <p><xsl:if test="//t:provenance[@type='observed'][@when] or //t:provenance[@type='observed'][@resp] or //t:provenance[@type='observed'][@resp][@when]">
         <b><i18n:text i18n:key="edv-autopsy">Ultima ricognizione</i18n:text>: </b>
         <xsl:if test="//t:provenance[@type='observed'][@when]">
           <xsl:variable name="observed-date-parts" select="tokenize(//t:provenance[@type='observed']/@when, '-')"/>
           <!--<xsl:value-of select="//t:provenance[@type='observed']/@when" />-->
           <xsl:choose>
             <xsl:when test="count($observed-date-parts)=3"><xsl:value-of select="format-date(//t:provenance[@type='observed']/@when,'[D1].[M1].[Y0001]')" /></xsl:when>
             <xsl:when test="count($observed-date-parts)=2"><xsl:value-of select="format-date(xs:date(concat(//t:provenance[@type='observed']/@when,'-01')),'[M1].[Y0001]')" /></xsl:when>
             <xsl:when test="count($observed-date-parts)=1"><xsl:value-of select="number(//t:provenance[@type='observed']/@when)" /></xsl:when>
           </xsl:choose>
         </xsl:if>
         <xsl:if test="//t:provenance[@type='observed'][@when][@resp]"><xsl:text>, </xsl:text></xsl:if>
         <xsl:if test="//t:provenance[@type='observed'][@resp]">
         <xsl:value-of select="//t:provenance[@type='observed']/@resp"/></xsl:if>
         <br/>
         </xsl:if>
         
         <xsl:if test="//t:publicationStmt/t:date/@when">
         <b><i18n:text i18n:key="edv-publication_date">Data di pubblicazione</i18n:text>: </b>
         <xsl:value-of select="format-date(//t:publicationStmt/t:date/@when,'[D1].[M1].[Y0001]')" /></xsl:if>
       </p>
     </div>
   </xsl:template>




   <xsl:template name="edv-structure">
      <xsl:variable name="title">
         <xsl:call-template name="edv-title" />
      </xsl:variable>

      <html>
         <head>
            <title>
               <xsl:value-of select="$title"/>
            </title>
            <meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
            <!-- Found in htm-tpl-cssandscripts.xsl -->
            <xsl:call-template name="css-script"/>
         </head>
         <body>
            <h1>
               <xsl:value-of select="$title"/>
            </h1>
            <xsl:call-template name="edv-body-structure" />
         </body>
      </html>
   </xsl:template>

   <xsl:template match="t:dimensions" mode="edv-dimensions">
      <xsl:if test="//text()">
         <xsl:if test="t:width/text()">l.
            <xsl:value-of select="t:width"/>
            <xsl:if test="t:height/text()">
               <xsl:text> x </xsl:text>
            </xsl:if>
         </xsl:if>
         <xsl:if test="t:height/text()">h.
            <xsl:value-of select="t:height"/>
         </xsl:if>
         <xsl:if test="t:depth/text()">x d.
            <xsl:value-of select="t:depth"/>
         </xsl:if>
         <xsl:if test="t:dim[@type='diameter']/text()">x diam.
            <xsl:value-of select="t:dim[@type='diameter']"/>
         </xsl:if>
      </xsl:if>
   </xsl:template>
   
   <xsl:template name="edv-title">
     <xsl:choose>
       <xsl:when test="//t:titleStmt/t:title/text() and number(substring(//t:publicationStmt/t:idno[@type='filename']/text(),2,5))">
         <xsl:value-of select="//t:publicationStmt/t:idno[@type='filename']/text()"/> 
         <xsl:text>. </xsl:text>
         <xsl:value-of select="//t:titleStmt/t:title"/>
       </xsl:when>
       <xsl:when test="//t:titleStmt/t:title/text()">
         <xsl:value-of select="//t:titleStmt/t:title"/>
       </xsl:when>
       <xsl:when test="//t:idno[@type='filename']/text()">
         <xsl:value-of select="//t:idno[@type='filename']"/>
       </xsl:when>
       <xsl:otherwise>
         <xsl:text>EpiDoc example output, EDV style</xsl:text>
       </xsl:otherwise>
     </xsl:choose>
   </xsl:template>
  
  <xsl:template match="//t:div//t:title">
    <i><xsl:value-of select="."/></i>
  </xsl:template>
  
  <xsl:template match="//t:div[@type='edition']//t:hi[@rend='intraline']">
    <strike><xsl:value-of select="."/></strike>
  </xsl:template>
  
  <xsl:template match="//t:div[@type='edition']//t:hi[@rend='ligature']">
    <u><xsl:value-of select="."/></u>
  </xsl:template>
  
  <xsl:template match="//t:div[@type='edition']//t:corr"><xsl:text>&lt;</xsl:text><xsl:value-of select="."/><xsl:text>&gt;</xsl:text></xsl:template>
  
  <xsl:template match="//t:foreign">
    <i><xsl:value-of select="."/></i>
  </xsl:template>
  
  <xsl:template match="//t:div[@type='edition']//t:g">
    <xsl:choose>
      <xsl:when test="@ref='middot'">·</xsl:when>
      <xsl:when test="@ref='cross'">+</xsl:when>
      <xsl:otherwise><xsl:value-of select="@ref"/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="//t:div[@type='edition']//t:space">
    <xsl:text>&#160;&#160;&#160;&#160;&#160;&#160;</xsl:text>
  </xsl:template>
  
  <xsl:template match="//t:titleStmt//t:ref | //t:div//t:bibl/t:ref">
    <xsl:variable name="bibl-id" select="substring-after(@target,'#')"/>
    <xsl:variable name="biblio-id" select="document(concat('file:',system-property('user.dir'),'/webapps/ROOT/content/xml/tei/bibliography.xml'))//t:bibl[@xml:id=$bibl-id]"/>
    <xsl:choose>
      <xsl:when test="$biblio-id">
        <a><xsl:attribute name="href"><xsl:value-of select="concat('../texts/bibliography.html#',$bibl-id)"/></xsl:attribute><xsl:attribute name="target"><xsl:value-of select="'_blank'"/></xsl:attribute><xsl:apply-templates/></a>
      </xsl:when>
      <xsl:otherwise><xsl:apply-templates/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- bibliografia con popup 
    <xsl:template match="//t:titleStmt//t:ref | //t:div//t:bibl/t:ref">
    <xsl:variable name="bibl-id" select="substring-after(@target,'#')"/>
    <xsl:variable name="biblio-id" select="document(concat('file:',system-property('user.dir'),'/webapps/ROOT/content/xml/tei/bibliography.xml'))//t:bibl[@xml:id=$bibl-id]"/>
    <xsl:choose>
      <xsl:when test="$biblio-id">
        <span class="popup_box"><span class="popup_word"><a><xsl:attribute name="href"><xsl:value-of select="concat('../texts/bibliography.html#',$bibl-id)"/></xsl:attribute><xsl:attribute name="target"><xsl:value-of select="'_blank'"/></xsl:attribute><xsl:apply-templates/></a></span>
          <span class="popup">
            <!-\-<xsl:apply-templates select="$biblio-id"/> -\->
            <xsl:if test="$biblio-id/t:author"><xsl:apply-templates select="$biblio-id/t:author"/><xsl:text>, </xsl:text></xsl:if>
            <xsl:if test="$biblio-id/t:title[1]"><i><xsl:apply-templates select="$biblio-id/t:title[1]"/></i><xsl:text>, </xsl:text></xsl:if>
            <xsl:if test="$biblio-id/t:title[2]"><xsl:text>in </xsl:text><i><xsl:apply-templates select="$biblio-id/t:title[2]"/></i><xsl:text>, </xsl:text></xsl:if>
            <xsl:if test="$biblio-id/t:publisher"><xsl:apply-templates select="$biblio-id/t:publisher"/><xsl:text>, </xsl:text></xsl:if>
            <xsl:if test="$biblio-id/t:pubPlace"><xsl:apply-templates select="$biblio-id/t:pubPlace"/><xsl:text> </xsl:text></xsl:if>
            <xsl:if test="$biblio-id/t:date"><xsl:apply-templates select="$biblio-id/t:date"/></xsl:if>
          </span></span>
      </xsl:when>
      <xsl:otherwise><xsl:apply-templates/></xsl:otherwise>
    </xsl:choose>
  </xsl:template>-->
  
  <!-- Link a risorse esterne online e a iscrizioni interne al database -->
  <xsl:template match="t:div//t:p/t:ref[@target]">
    <xsl:choose>
      <xsl:when test="@type='link'">
        <a><xsl:attribute name="href"><xsl:value-of select="@target"/></xsl:attribute><xsl:attribute name="target"><xsl:value-of select="'_blank'"/></xsl:attribute><xsl:apply-templates/></a>
      </xsl:when>
      <xsl:otherwise><a><xsl:attribute name="href"><xsl:value-of select="concat('./',@target,'.html')"/></xsl:attribute><xsl:attribute name="target"><xsl:value-of select="'_blank'"/></xsl:attribute><xsl:apply-templates/></a></xsl:otherwise>
    </xsl:choose>
    </xsl:template>

 </xsl:stylesheet>
