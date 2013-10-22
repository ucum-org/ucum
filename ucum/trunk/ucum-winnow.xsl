<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform version="1.1"
    xmlns:u="http://aurora.regenstrief.org/UCUM"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    exclude-result-prefixes="u xsl">

<xsl:output method="xml" indent="yes" encoding="ascii"/>
<xsl:strip-space elements="*"/> 

<xsl:template match="/">
  <root xmlns="http://unitsofmeasure.org/ucum-essence" version="{spec/header/version}" revision="{spec/header/revision}" revision-date="{spec/header/date}">
    <xsl:apply-templates select="node()"/>
  </root>
</xsl:template>

<xsl:template match="@*|node()">
  <xsl:apply-templates select="@*|node()"/>
</xsl:template>

<xsl:template match="u:prefix">
  <xsl:element name="{local-name()}">
    <xsl:apply-templates select="@*|node()"/>
  </xsl:element>
</xsl:template>
<xsl:template match="u:prefix/@Code|u:prefix/@CODE">
  <xsl:copy/>
</xsl:template>
<xsl:template match="u:prefix/value|u:prefix/printSymbol|u:prefix/name">
  <xsl:apply-templates mode="copy" select="."/>
</xsl:template>

<xsl:template match="u:base-unit">
  <xsl:element name="{local-name()}">
    <xsl:apply-templates select="@*"/>
    <xsl:if test="value/function">
       <xsl:message terminate="yes">A special unit cannot be a base unit.</xsl:message>
    </xsl:if>
    <xsl:apply-templates select="node()"/>
  </xsl:element>
</xsl:template>
<xsl:template match="u:base-unit/@Code|u:base-unit/@CODE|u:base-unit/@dim">
  <xsl:copy/>
</xsl:template>
<xsl:template match="u:base-unit/printSymbol|u:base-unit/name|u:base-unit/property">
  <xsl:apply-templates mode="copy" select="."/>
</xsl:template>

<xsl:template match="u:unit">
  <xsl:element name="{local-name()}">
    <xsl:apply-templates select="@*"/>
    <xsl:if test="value/function">
      <xsl:attribute name="isSpecial">yes</xsl:attribute>
    </xsl:if>
    <xsl:attribute name="class">
      <xsl:value-of select="ancestor::u:units/@id"/>
    </xsl:attribute>
    <xsl:apply-templates select="node()"/>
  </xsl:element>
</xsl:template>
<xsl:template match="u:unit/@Code|u:unit/@CODE|u:unit/@isMetric|u:unit/@isArbitrary">
  <xsl:copy/>
</xsl:template>
<xsl:template match="u:unit/value|u:unit/printSymbol|u:unit/name|u:unit/property">
  <xsl:apply-templates mode="copy" select="."/>
</xsl:template>
<xsl:template match="u:unit[@Code=('10*', '10^')]/printSymbol" priority="2">
   <printSymbol>10</printSymbol>
</xsl:template>
<xsl:template match="u:unit/printSymbol[contains(text(),',')]" priority="2">
   <printSymbol><xsl:value-of select="tokenize(.,',')[1]"/></printSymbol>
</xsl:template>


<xsl:template mode="copy" match="/">
  <xsl:apply-templates mode="copy" select="node()"/>
</xsl:template>
<xsl:template mode="copy" match="@*">
  <xsl:copy/>
</xsl:template>
<xsl:template mode="copy" match="*">
  <xsl:element name="{local-name()}">
    <xsl:apply-templates mode="copy" select="@*|node()"/>
  </xsl:element>
</xsl:template>


</xsl:transform>
