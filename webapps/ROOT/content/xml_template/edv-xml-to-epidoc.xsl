<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    version="2.0">
    
    <xsl:output method="xml"/>
    
    <xsl:template match="element">
        <TEI xmlns="http://www.tei-c.org/ns/1.0" xml:space="preserve">
            <teiHeader>
                <fileDesc>
                    <titleStmt>
                        <title><xsl:apply-templates select="./IDENTIFICATIVO"/></title>
                        <editor role="data_collection"><persName></persName></editor>
                        <editor role="edition"><persName></persName></editor>
                        <editor role="encoding"><persName></persName></editor>
                    </titleStmt>
                    <publicationStmt>
                        <authority>Epigraphic Database Vernacular</authority>
                        <idno type="filename"><xsl:apply-templates select="./NUMERO_EDV"/></idno>
                        <date when="2020-03-04"/>
                        <availability>
                            <licence target="https://creativecommons.org/licenses/by-nc/4.0/">Creative Commons Attributions-NonCommercial 4.0 International License.</licence>
                        </availability>
                    </publicationStmt>
                    <sourceDesc>
                        <msDesc>
                            <msIdentifier>
                                <placeName ref="#"><xsl:apply-templates select="./CITTA"/></placeName>
                                <district ref="#"><xsl:apply-templates select="./PROVINCIA"/></district>
                                <repository><xsl:apply-templates select="./LUOGO_DI_CONSERVAZIONE"/></repository>
                                <idno type="invNo"/>
                            </msIdentifier>
                            <msContents>
                                <summary>
                                    <term type="textFunction" ref="#"><xsl:apply-templates select="./Funzione"/></term>
                                    <term type="textType" ref="#"><xsl:apply-templates select="./Tipo"/></term>
                                </summary>
                                <textLang mainLang="" otherLangs=""><xsl:apply-templates select="./LINGUA"/> <xsl:apply-templates select="./LATINO"/></textLang>
                            </msContents>
                            <physDesc>
                                <objectDesc>
                                    <supportDesc>
                                        <support>    
                                            <material ref="#"><xsl:apply-templates select="./MATERIALE"/></material>
                                            <objectType ref="#"><xsl:apply-templates select="./OGGETTO"/></objectType>
                                            <dimensions><width/><depth/><height/></dimensions>
                                        </support>
                                    </supportDesc>
                                </objectDesc>
                                <handDesc>
                                    <handNote><term ref="#"><xsl:apply-templates select="./SCRITTURA"/></term></handNote>
                                </handDesc>
                            </physDesc>
                            <history>
                                <origin>
                                    <origPlace><region ref="#"><xsl:apply-templates select="./REGIONE"/></region></origPlace>
                                    <origDate notBefore="{./ANNO_DA}" notAfter="{./ANNO_A}"><xsl:apply-templates select="./SECOLO"/><xsl:apply-templates select="./DATA"/></origDate>
                                </origin>
                                <provenance type="observed"/>
                            </history>
                        </msDesc>
                    </sourceDesc>
                </fileDesc>
            </teiHeader>
            <facsimile>
                <graphic url="">
                    <desc/>
                </graphic>
            </facsimile>
            <text>
                <body>
                    <div type="edition" subtype="interpretive" xml:space="preserve">
                        <ab>
                        </ab>
                    </div>
                    <div type="edition" subtype="diplomatic" xml:space="preserve">
                        <ab>
                        </ab>
                    </div>
                    <div type="apparatus">
                        <p></p>
                    </div>
                    <div type="commentary" subtype="linguistic_analysis">
                        <p></p>
                    </div>
                    <div type="commentary" subtype="note">
                        <p>Immagine: <xsl:apply-templates select="./IMMAGINE"/>.</p>
                    </div>
                    <div type="bibliography">
                        <p xml:id="editions"></p>
                        <p xml:id="other"></p>
                        <p xml:id="images"></p>
                    </div>
                </body>
            </text>
        </TEI>
    </xsl:template>
</xsl:stylesheet>