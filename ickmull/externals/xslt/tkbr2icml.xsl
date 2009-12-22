<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<!-- 
v. 0.4, Dec 2009

This script is copyright 2009 by John W. Maxwell, Meghan MacDonald, 
and Travis Nicholson at Simon Fraser University's Master of Publishing
program.

Our intent is that this script be free licensed; you are hereby free to
use, study, modify, share, and redistribute this software as needed. 
This script would be GNU GPL-licensed, except that small parts of it come 
directly from Adobe's excellent IDML Cookbook and SDK and so aren't ours
to license. That said, the point of the thing is educational, so go to it.
See also http://www.adobe.com/devnet/indesign/

This script is not meant to be comprehensive or perfect. It was written
and tested in the context of the CCSP's Book Publishing 1 title, and content
from out ZWiki-based webCM system. To make it work with your content, you
will probably need to make modifications. That said, it is a working 
proof-of-concept and a foundation for further work. - JMax June 5, 2009.

CHANGES
===========
v0.2 - JMax: Nov 2009. Tweaks to make this work with TinyMCE's content rather than the HTML that ZWiki's ReStructured Text creates.
v0.2.5 - Meghan: Dec 2009. Added handlers for crude p-level metadata
v0.3 - JMax: merged 0.2 and 0.25, tweaked support for "a" links
v0.4 - Keith Fahlgren: Refactored XSLT for clarity and extensibility
-->
<xsl:stylesheet xmlns:xhtml="http://www.w3.org/1999/xhtml" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
                omit-result-prefixes="xhtml"
                version="1.0">

  <xsl:param name="output"/>
  <xsl:param name="table-width">540</xsl:param>

  <!-- Fixed strings used to indicate ICML and software version -->
  <xsl:variable name="icml-decl-pi">
    <xsl:text>style="50" type="snippet" readerVersion="6.0" featureSet="257" product="6.0(352)"</xsl:text> <!-- product string will change with specific InDesign builds (but probably doesn't matter) -->
  </xsl:variable>  
  <xsl:variable name="snippet-type-pi">
    <xsl:text>SnippetType="InCopyInterchange"</xsl:text>
  </xsl:variable>  

  <!-- Default Rule: Match everything, ignore it,  and keep going "down". -->
  <xsl:template match="@*|node()">
    <xsl:apply-templates select="@*|node()"/>
  </xsl:template>

  <xsl:template match="xhtml:body">
    <xsl:processing-instruction name="aid"><xsl:value-of select="$icml-decl-pi"/></xsl:processing-instruction>
    <xsl:processing-instruction name="aid"><xsl:value-of select="$snippet-type-pi"/></xsl:processing-instruction>
    <Document DOMVersion="6.0" Self="tkbr2icml_document">
      <RootCharacterStyleGroup Self="tkbr2icml_character_styles">
        <CharacterStyle Self="CharacterStyle/table_figure" Name="table_figure"/>
        <CharacterStyle Self="CharacterStyle/fnref" Name="fnref"/>
        <CharacterStyle Self="CharacterStyle/link" Name="link"/>
        <CharacterStyle Self="CharacterStyle/i" Name="i"/>
        <CharacterStyle Self="CharacterStyle/italic_sc" Name="italic_sc"/>
        <CharacterStyle Self="CharacterStyle/sc" Name="sc"/>
        <CharacterStyle Self="CharacterStyle/b" Name="b"/>
      </RootCharacterStyleGroup>
      <RootParagraphStyleGroup Self="tkbr2icml_paragraph_styles">
        <ParagraphStyle Self="ParagraphStyle/h1" Name="h1"/>
        <ParagraphStyle Self="ParagraphStyle/h2" Name="h2"/>
        <ParagraphStyle Self="ParagraphStyle/h3" Name="h3"/>
        <ParagraphStyle Self="ParagraphStyle/h4" Name="h4"/>
        <ParagraphStyle Self="ParagraphStyle/pInitial" Name="pInitial"/>
        <ParagraphStyle Self="ParagraphStyle/p" Name="p"/>
        <ParagraphStyle Self="ParagraphStyle/ul" Name="ul"/>
        <ParagraphStyle Self="ParagraphStyle/ol" Name="ol"/>
        <ParagraphStyle Self="ParagraphStyle/table" Name="table"/>
        <ParagraphStyle Self="ParagraphStyle/figure_table" Name="figure_table"/>
        <ParagraphStyle Self="ParagraphStyle/quote" Name="quote"/>
        <ParagraphStyle Self="ParagraphStyle/reference" Name="reference"/>
        <ParagraphStyle Self="ParagraphStyle/excerpt" Name="excerpt"/>
        <ParagraphStyle Self="ParagraphStyle/author" Name="author"/>
        <ParagraphStyle Self="ParagraphStyle/footnote" Name="footnote"/>
      </RootParagraphStyleGroup>
      <Story Self="tkbr2icml_default_story" AppliedTOCStyle="n" TrackChanges="false" StoryTitle="MyStory" AppliedNamedGrid="n">
        <StoryPreference OpticalMarginAlignment="false" OpticalMarginSize="12" FrameType="TextFrameType" StoryOrientation="Horizontal" StoryDirection="LeftToRightDirection"/>
        <InCopyExportOption IncludeGraphicProxies="true" IncludeAllResources="false"/>
        <xsl:apply-templates/>
      </Story>
    </Document>
  </xsl:template>

  <xsl:template match="xhtml:h1|xhtml:h2|xhtml:h3|xhtml:h4|xhtml:h5|xhtml:h6">
    <xsl:call-template name="para-style-range">
      <xsl:with-param name="style-name" select="name()"/>
      <xsl:with-param name="content" select="."/>
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="xhtml:p[@class='dc-creator']">
    <xsl:call-template name="para-style-range">
      <xsl:with-param name="style-name">author</xsl:with-param>
      <xsl:with-param name="content" select="concat('by ', .)"/>
    </xsl:call-template>
  </xsl:template>
  <xsl:template match="xhtml:p[@class='figure_table']">
    <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/figure_table">
      <CharacterStyleRange>
        <Content>
          <xsl:value-of select="."/>
        </Content>
        <Br/>
      </CharacterStyleRange>
    </ParagraphStyleRange>
  </xsl:template>
  <xsl:template match="xhtml:p[@class='index']">
    <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/index">
      <CharacterStyleRange>
        <Content>
          <xsl:value-of select="."/>
        </Content>
        <Br/>
      </CharacterStyleRange>
    </ParagraphStyleRange>
  </xsl:template>
  <xsl:template match="xhtml:p[@class='index_sub']">
    <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/index_sub">
      <CharacterStyleRange>
        <Content>
          <xsl:value-of select="."/>
        </Content>
        <Br/>
      </CharacterStyleRange>
    </ParagraphStyleRange>
  </xsl:template>
  <xsl:template match="xhtml:p[@class='excerpt']">
    <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/excerpt">
      <CharacterStyleRange>
        <Content>
          <xsl:value-of select="."/>
        </Content>
        <Br/>
      </CharacterStyleRange>
    </ParagraphStyleRange>
  </xsl:template>
  <xsl:template match="xhtml:p[@class='quote_ind']">
    <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/quote_ind">
      <CharacterStyleRange>
        <Content>
          <xsl:value-of select="."/>
        </Content>
        <Br/>
      </CharacterStyleRange>
    </ParagraphStyleRange>
  </xsl:template>
  <xsl:template match="xhtml:p[@class='quote']">
    <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/quote">
      <xsl:for-each select="*|text()">
        <xsl:choose>
          <xsl:when test="self::xhtml:span[@class='table_figure']">
            <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/table_figure">
              <Content>
                <xsl:value-of select="normalize-space(.)"/>
                <xsl:if test="position() != last()">
                  <xsl:text> </xsl:text>
                </xsl:if>
              </Content>
            </CharacterStyleRange>
          </xsl:when>
          <xsl:when test="self::xhtml:i">
            <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/i">
              <Content>
                <xsl:value-of select="normalize-space(.)"/>
                <xsl:if test="position() != last()">
                  <xsl:text> </xsl:text>
                </xsl:if>
              </Content>
            </CharacterStyleRange>
          </xsl:when>
          <xsl:when test="self::xhtml:span[@class='italic_sc']">
            <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/italic_sc">
              <Content>
                <xsl:value-of select="normalize-space(.)"/>
                <xsl:if test="position() != last()">
                  <xsl:text> </xsl:text>
                </xsl:if>
              </Content>
            </CharacterStyleRange>
          </xsl:when>
          <xsl:when test="self::xhtml:span[@class='sc']">
            <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/sc">
              <Content>
                <xsl:value-of select="normalize-space(.)"/>
                <xsl:if test="position() != last()">
                  <xsl:text> </xsl:text>
                </xsl:if>
              </Content>
            </CharacterStyleRange>
          </xsl:when>
          <xsl:when test="self::xhtml:b">
            <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/b">
              <Content>
                <xsl:value-of select="normalize-space(.)"/>
                <xsl:if test="position() != last()">
                  <xsl:text> </xsl:text>
                </xsl:if>
              </Content>
            </CharacterStyleRange>
          </xsl:when>
          <xsl:when test="self::text()">
            <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/[No character style]">
              <Content>
                <xsl:value-of select="normalize-space(.)"/>
                <xsl:if test="position() != last()">
                  <xsl:text> </xsl:text>
                </xsl:if>
              </Content>
            </CharacterStyleRange>
          </xsl:when>
        </xsl:choose>
      </xsl:for-each>
      <Br/>
    </ParagraphStyleRange>
  </xsl:template>
  <xsl:template match="xhtml:p[@class='reference']">
    <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/reference">
      <CharacterStyleRange>
        <Content>
          <xsl:value-of select="."/>
        </Content>
        <Br/>
      </CharacterStyleRange>
    </ParagraphStyleRange>
  </xsl:template>
  <xsl:template match="xhtml:div[@class='footnotes']/xhtml:p">
    <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/footnote">
      <CharacterStyleRange>
        <Content>
          <xsl:value-of select="."/>
        </Content>
        <Br/>
      </CharacterStyleRange>
    </ParagraphStyleRange>
  </xsl:template>
  <xsl:template match="xhtml:p">
    <xsl:choose>
      <xsl:when test="preceding-sibling::*[1][self::xhtml:p]">
        <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/p">
          <xsl:for-each select="*|text()">
            <xsl:choose>
              <xsl:when test="self::xhtml:a[@class='footnote-reference']">
                <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/fnref">
                  <Content>
                    <xsl:value-of select="substring-before(substring-after(.,'['),']')"/>
                    <xsl:if test="position() != last()">
                      <xsl:text> </xsl:text>
                    </xsl:if>
                  </Content>
                </CharacterStyleRange>
              </xsl:when>
              <xsl:when test="self::xhtml:span[@class='table_figure']">
                <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/table_figure">
                  <Content>
                    <xsl:value-of select="normalize-space(.)"/>
                    <xsl:if test="position() != last()">
                      <xsl:text> </xsl:text>
                    </xsl:if>
                  </Content>
                </CharacterStyleRange>
              </xsl:when>
              <xsl:when test="self::xhtml:a">
                <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/link">
                  <Content>
                    <xsl:value-of select="."/>
                  </Content>
                </CharacterStyleRange>
              </xsl:when>
              <xsl:when test="self::xhtml:i">
                <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/i">
                  <Content>
                    <xsl:value-of select="normalize-space(.)"/>
                    <xsl:if test="position() != last()">
                      <xsl:text> </xsl:text>
                    </xsl:if>
                  </Content>
                </CharacterStyleRange>
              </xsl:when>
              <xsl:when test="self::xhtml:em">
                <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/i">
                  <Content>
                    <xsl:value-of select="normalize-space(.)"/>
                    <xsl:if test="position() != last()">
                      <xsl:text> </xsl:text>
                    </xsl:if>
                  </Content>
                </CharacterStyleRange>
              </xsl:when>
              <xsl:when test="self::xhtml:span[@class='italic_sc']">
                <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/italic_sc">
                  <Content>
                    <xsl:value-of select="normalize-space(.)"/>
                    <xsl:if test="position() != last()">
                      <xsl:text> </xsl:text>
                    </xsl:if>
                  </Content>
                </CharacterStyleRange>
              </xsl:when>
              <xsl:when test="self::xhtml:span[@class='sc']">
                <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/sc">
                  <Content>
                    <xsl:value-of select="normalize-space(.)"/>
                    <xsl:if test="position() != last()">
                      <xsl:text> </xsl:text>
                    </xsl:if>
                  </Content>
                </CharacterStyleRange>
              </xsl:when>
              <xsl:when test="self::xhtml:b">
                <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/b">
                  <Content>
                    <xsl:value-of select="normalize-space(.)"/>
                    <xsl:if test="position() != last()">
                      <xsl:text> </xsl:text>
                    </xsl:if>
                  </Content>
                </CharacterStyleRange>
              </xsl:when>
              <xsl:when test="self::xhtml:strong">
                <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/b">
                  <Content>
                    <xsl:value-of select="normalize-space(.)"/>
                    <xsl:if test="position() != last()">
                      <xsl:text> </xsl:text>
                    </xsl:if>
                  </Content>
                </CharacterStyleRange>
              </xsl:when>
              <xsl:when test="self::text()">
                <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/[No character style]">
                  <Content>
                    <xsl:value-of select="normalize-space(.)"/>
                    <xsl:if test="position() != last()">
                      <xsl:text> </xsl:text>
                    </xsl:if>
                  </Content>
                </CharacterStyleRange>
              </xsl:when>
            </xsl:choose>
          </xsl:for-each>
          <Br/>
        </ParagraphStyleRange>
      </xsl:when>
      <xsl:otherwise>
        <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/pInitial">
          <xsl:for-each select="*|text()">
            <xsl:choose>
              <xsl:when test="self::xhtml:a[@class='footnote-reference']">
                <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/fnref">
                  <Content>
                    <xsl:value-of select="substring-before(substring-after(.,'['),']')"/>
                    <xsl:if test="position() != last()">
                      <xsl:text> </xsl:text>
                    </xsl:if>
                  </Content>
                </CharacterStyleRange>
              </xsl:when>
              <xsl:when test="self::xhtml:span[@class='table_figure']">
                <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/table_figure">
                  <Content>
                    <xsl:value-of select="normalize-space(.)"/>
                    <xsl:if test="position() != last()">
                      <xsl:text> </xsl:text>
                    </xsl:if>
                  </Content>
                </CharacterStyleRange>
              </xsl:when>
              <xsl:when test="self::xhtml:a">
                <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/link">
                  <Content>
                    <xsl:value-of select="."/>
                  </Content>
                </CharacterStyleRange>
              </xsl:when>
              <xsl:when test="self::xhtml:i">
                <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/i">
                  <Content>
                    <xsl:value-of select="normalize-space(.)"/>
                    <xsl:if test="position() != last()">
                      <xsl:text> </xsl:text>
                    </xsl:if>
                  </Content>
                </CharacterStyleRange>
              </xsl:when>
              <xsl:when test="self::xhtml:em">
                <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/i">
                  <Content>
                    <xsl:value-of select="normalize-space(.)"/>
                    <xsl:if test="position() != last()">
                      <xsl:text> </xsl:text>
                    </xsl:if>
                  </Content>
                </CharacterStyleRange>
              </xsl:when>
              <xsl:when test="self::xhtml:span[@class='italic_sc']">
                <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/italic_sc">
                  <Content>
                    <xsl:value-of select="normalize-space(.)"/>
                    <xsl:if test="position() != last()">
                      <xsl:text> </xsl:text>
                    </xsl:if>
                  </Content>
                </CharacterStyleRange>
              </xsl:when>
              <xsl:when test="self::xhtml:span[@class='sc']">
                <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/sc">
                  <Content>
                    <xsl:value-of select="normalize-space(.)"/>
                    <xsl:if test="position() != last()">
                      <xsl:text> </xsl:text>
                    </xsl:if>
                  </Content>
                </CharacterStyleRange>
              </xsl:when>
              <xsl:when test="self::xhtml:b">
                <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/b">
                  <Content>
                    <xsl:value-of select="normalize-space(.)"/>
                    <xsl:if test="position() != last()">
                      <xsl:text> </xsl:text>
                    </xsl:if>
                  </Content>
                </CharacterStyleRange>
              </xsl:when>
              <xsl:when test="self::xhtml:strong">
                <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/b">
                  <Content>
                    <xsl:value-of select="normalize-space(.)"/>
                    <xsl:if test="position() != last()">
                      <xsl:text> </xsl:text>
                    </xsl:if>
                  </Content>
                </CharacterStyleRange>
              </xsl:when>
              <xsl:when test="self::text()">
                <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/[No character style]">
                  <Content>
                    <xsl:value-of select="normalize-space(.)"/>
                    <xsl:if test="position() != last()">
                      <xsl:text> </xsl:text>
                    </xsl:if>
                  </Content>
                </CharacterStyleRange>
              </xsl:when>
            </xsl:choose>
          </xsl:for-each>
          <Br/>
        </ParagraphStyleRange>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="xhtml:table[@class='docutils footnote']/xhtml:tbody/xhtml:tr">
    <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/footnote">
      <xsl:for-each select="xhtml:td">
        <xsl:choose>
          <xsl:when test="self::xhtml:td[@class='label']">
            <CharacterStyleRange>
              <Content><xsl:value-of select="substring-before(substring-after(.,'['),']')"/>. </Content>
            </CharacterStyleRange>
          </xsl:when>
          <xsl:otherwise>
            <Content>
              <xsl:value-of select="."/>
            </Content>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </ParagraphStyleRange>
    <Br/>
  </xsl:template>
  <xsl:template match="xhtml:blockquote">
    <xsl:for-each select="xhtml:p">
      <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/quote">
        <xsl:for-each select="*|text()">
          <xsl:choose>
            <xsl:when test="self::xhtml:a[@class='footnote-reference']">
              <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/fnref">
                <Content>
                  <xsl:value-of select="substring-before(substring-after(.,'['),']')"/>
                  <xsl:if test="position() != last()">
                    <xsl:text> </xsl:text>
                  </xsl:if>
                </Content>
              </CharacterStyleRange>
            </xsl:when>
            <xsl:when test="self::xhtml:a">
              <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/link">
                <Content>
                  <xsl:value-of select="."/>
                </Content>
              </CharacterStyleRange>
            </xsl:when>
            <xsl:when test="self::xhtml:em">
              <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/i">
                <Content>
                  <xsl:value-of select="normalize-space(.)"/>
                  <xsl:if test="position() != last()">
                    <xsl:text> </xsl:text>
                  </xsl:if>
                </Content>
              </CharacterStyleRange>
            </xsl:when>
            <xsl:when test="self::xhtml:b">
              <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/b">
                <Content>
                  <xsl:value-of select="normalize-space(.)"/>
                  <xsl:if test="position() != last()">
                    <xsl:text> </xsl:text>
                  </xsl:if>
                </Content>
              </CharacterStyleRange>
            </xsl:when>
            <xsl:when test="self::xhtml:strong">
              <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/b">
                <Content>
                  <xsl:value-of select="normalize-space(.)"/>
                  <xsl:if test="position() != last()">
                    <xsl:text> </xsl:text>
                  </xsl:if>
                </Content>
              </CharacterStyleRange>
            </xsl:when>
            <xsl:when test="self::text()">
              <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/[No character style]">
                <Content>
                  <xsl:value-of select="normalize-space(.)"/>
                  <xsl:if test="position() != last()">
                    <xsl:text> </xsl:text>
                  </xsl:if>
                </Content>
              </CharacterStyleRange>
            </xsl:when>
          </xsl:choose>
        </xsl:for-each>
        <Br/>
      </ParagraphStyleRange>
    </xsl:for-each>
  </xsl:template>
  <xsl:template match="xhtml:ul">
    <xsl:for-each select="xhtml:li">
      <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/ul">
        <CharacterStyleRange>
          <Content>
            <xsl:value-of select="."/>
          </Content>
          <Br/>
        </CharacterStyleRange>
      </ParagraphStyleRange>
    </xsl:for-each>
  </xsl:template>
  <xsl:template match="xhtml:ol">
    <xsl:for-each select="xhtml:li">
      <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/ol">
        <CharacterStyleRange>
          <Content>
            <xsl:value-of select="."/>
          </Content>
          <Br/>
        </CharacterStyleRange>
      </ParagraphStyleRange>
    </xsl:for-each>
  </xsl:template>
  <xsl:template match="xhtml:br">
    <xsl:text>
</xsl:text>
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template match="xhtml:span[@class='table_figure']">
    <ParagraphStyleRange>
      <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/table_figure">
        <Content>
          <xsl:apply-templates/>
        </Content>
      </CharacterStyleRange>
    </ParagraphStyleRange>
  </xsl:template>
  <xsl:template match="xhtml:table[@class='docutils']/xhtml:tbody">
    <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/table">
      <CharacterStyleRange>
        <Br/>
        <Table HeaderRowCount="0" FooterRowCount="0" AppliedTableStyle="TableStyle/$ID/[Basic Table]" TableDirection="LeftToRightDirection">
          <xsl:attribute name="BodyRowCount">
            <xsl:value-of select="count(child::xhtml:tr)"/>
          </xsl:attribute>
          <xsl:attribute name="ColumnCount">
            <xsl:value-of select="count(child::xhtml:tr[3]/xhtml:td)"/>
          </xsl:attribute>
          <xsl:variable name="columnWidth" select="$table-width div count(xhtml:tr[3]/xhtml:td)"/>
          <xsl:for-each select="xhtml:tr[3]/xhtml:td">
            <Column Name="{position() - 1}" SingleColumnWidth="{$columnWidth}"/>
          </xsl:for-each>
          <xsl:for-each select="xhtml:tr">
            <xsl:variable name="rowNum" select="position() - 1"/>
            <xsl:for-each select="xhtml:td">
              <xsl:variable name="colNum" select="position() - 1"/>
              <xsl:choose>
                <xsl:when test="@colspan">
                  <Cell Name="{$colNum}:{$rowNum}" RowSpan="1" ColumnSpan="{@colspan}" AppliedCellStyle="CellStyle/$ID/[None]" AppliedCellStylePriority="0">
                    <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/$ID/NormalParagraphStyle">
                      <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/$ID/[No character style]">
                        <Content>
                          <xsl:value-of select="*|text()"/>
                        </Content>
                      </CharacterStyleRange>
                    </ParagraphStyleRange>
                  </Cell>
                </xsl:when>
                <xsl:otherwise>
                  <Cell Name="{$colNum}:{$rowNum}" RowSpan="1" ColumnSpan="1" AppliedCellStyle="CellStyle/$ID/[None]" AppliedCellStylePriority="0">
                    <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/$ID/NormalParagraphStyle">
                      <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/$ID/[No character style]">
                        <Content>
                          <xsl:value-of select="*|text()"/>
                        </Content>
                      </CharacterStyleRange>
                    </ParagraphStyleRange>
                  </Cell>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:for-each>
          </xsl:for-each>
        </Table>
      </CharacterStyleRange>
    </ParagraphStyleRange>
  </xsl:template>
  <xsl:template match="xhtml:tr">
    <xsl:if test="position() &gt; 2">
      <Br/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="xhtml:td">
    <xsl:if test="position() &gt; 2">
      <Br/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="xhtml:img">
    <ParagraphStyleRange>foo
            <CharacterStyleRange><xsl:variable name="halfwidth" select="@width div 2"/><xsl:variable name="halfheight" select="@height div 2"/><Rectangle Self="uec" ItemTransform="1 0 0 1 {$halfwidth} -{$halfheight}"><Properties><PathGeometry><GeometryPathType PathOpen="false"><PathPointArray><PathPointType Anchor="-{$halfwidth} -{$halfheight}" LeftDirection="-{$halfwidth} -{$halfheight}" RightDirection="-{$halfwidth} -{$halfheight}"/><PathPointType Anchor="-{$halfwidth} {$halfheight}" LeftDirection="-{$halfwidth} {$halfheight}" RightDirection="-{$halfwidth} {$halfheight}"/><PathPointType Anchor="{$halfwidth} {$halfheight}" LeftDirection="{$halfwidth} {$halfheight}" RightDirection="{$halfwidth} {$halfheight}"/><PathPointType Anchor="{$halfwidth} -{$halfheight}" LeftDirection="{$halfwidth} -{$halfheight}" RightDirection="{$halfwidth} -{$halfheight}"/></PathPointArray></GeometryPathType></PathGeometry></Properties><Image Self="ue6" ItemTransform="1 0 0 1 -{$halfwidth} -{$halfheight}"><Properties><Profile type="string">$ID/Embedded</Profile><GraphicBounds Left="0" Top="0" Right="{@width}" Bottom="{@height}"/></Properties><Link Self="ueb" LinkResourceURI="file:///{@src}"/></Image></Rectangle><Br/></CharacterStyleRange>
        </ParagraphStyleRange>
  </xsl:template>

  <!-- ==================================================================== -->
  <!-- Named templates -->
  <!-- ==================================================================== -->
  <xsl:template name="para-style-range">
    <xsl:param name="style-name"/> 
    <xsl:param name="content" select="."/>
    <ParagraphStyleRange>
      <xsl:attribute name="AppliedParagraphStyle">
        <xsl:value-of select="concat('ParagraphStyle/', $style-name)"/>
      </xsl:attribute> 
      <CharacterStyleRange>
        <Content><xsl:value-of select="$content"/></Content>
        <Br/>
      </CharacterStyleRange>
    </ParagraphStyleRange>
  </xsl:template>
</xsl:stylesheet>
