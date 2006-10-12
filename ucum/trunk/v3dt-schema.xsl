<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:transform
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsd="http://www.w3.org/2001/XMLSchema"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:xlink="http://www.w3.org/TR/WD-xlink"
   	xmlns:hl7="urn:hl7-org:v3"
        xmlns:saxon="http://saxon.sf.net/"
        xmlns:gsd="http://aurora.regenstrief.org/GenericXMLSchema"
	xmlns:sch="http://www.ascc.net/xml/schematron"

	extension-element-prefixes="saxon"
	exclude-result-prefixes='xsd xsl saxon'
	version='2.0'>

  <xsl:strip-space elements="*"/>
  <xsl:output
	method='xml'
	indent='yes'
	encoding='ISO-8859-1'/>

<xsl:variable name='root' select='/'/>

<xsl:template match='/' name="assemble-complete-schema">
  <xsl:comment>
  Copyright (c) 2001, Health Level Seven. All rights reserved.

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions
  are met:
  1. Redistributions of source code must retain the above copyright
     notice, this list of conditions and the following disclaimer.
  2. Redistributions in binary form must reproduce the above copyright
     notice, this list of conditions and the following disclaimer in the
     documentation and/or other materials provided with the distribution.
  3. All advertising materials mentioning features or use of this software
     must display the following acknowledgement:
       This product includes software developed by Health Level Seven.
 
  THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
  ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
  OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
  HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
  LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
  OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
  SUCH DAMAGE.
  </xsl:comment>
  <xsd:schema
    xmlns:xsd='http://www.w3.org/2001/XMLSchema'
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:hl7="urn:hl7-org:v3"
	elementFormDefault='qualified'>
    <xsd:include schemaLocation="voc.xsd"/>

    <xsl:variable name='frags'>
      <xsl:apply-templates select="//schema[not(@include='no')]" 
                           mode='collect'/>
    </xsl:variable>

    <xsl:call-template name='apply-unique'>
      <xsl:with-param name='todo' select='$frags/*'/>
    </xsl:call-template>
  </xsd:schema>
</xsl:template>

<!-- This template will collect schema fragments and hunt down
     dependencies such that all required fragments come
     first. However, it can contain duplicates. 
-->
<xsl:template match="schema" mode='collect'> 
  <xsl:for-each select='requires/@ref'>
    <xsl:apply-templates select="//schema[@id=current()]" mode='collect'/>
  </xsl:for-each>   
  <xsl:for-each select='.//ellipsis/@ref'>
    <xsl:apply-templates select="//schema[@id=current()]" mode='collect'/>
  </xsl:for-each>   
  <xsl:if test="not(//schema//ellipsis/@ref=@id)">
    <xsl:copy-of select='.'/>
  </xsl:if>
</xsl:template>

<!-- This template will go through the sorted list of fragments
     and apply the fragment in verbatim mode. Duplicates are discarded. 
-->
<xsl:template name='apply-unique' match='apply-unique'>
  <xsl:param name='apply' select='"print"'/>
  <xsl:param name='todo' select='*'/>
  <xsl:param name='done' select='/..'/>
  <xsl:variable name='car' select='$todo[position()=1]'/>
  <xsl:variable name='cdr' select='$todo[position()>1]'/>

  <xsl:if test='not($done[@id=$car/@id])' >
    <xsl:apply-templates select='$car' mode='raw'/>
  </xsl:if>

  <xsl:if test='$cdr'>
    <xsl:call-template name='apply-unique'>
      <xsl:with-param name='apply' select='$apply'/>
      <xsl:with-param name='todo' select='$cdr'/>
      <xsl:with-param name='done' select='$car|$done'/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template match="xpath-constraint[@assert]" mode="raw">
  <xsl:variable name="schema" select="//schema[@id=current()/@context]"/>
  <xsl:variable name="name" select="//dtimpl[@id=$schema/@for]/@shortname"/>
  <sch:pattern name="validate {$name}">
    <sch:rule abstract="true" id="rule-{$name}">
      <!-- FIXME: needs <sch:extends base="...'/> here but only if exists? -->
      <sch:report test="{@assert}">
         <xsl:apply-templates select='node()' mode='raw'/>
      </sch:report>
    </sch:rule>
  </sch:pattern>
</xsl:template>

<xsl:template match="xpath-constraint[not(@assert)]" mode="raw">
  <xsl:message>
    <WARNING text="xpath-constraint without @assert">
      <xsl:copy-of select="."/>
    </WARNING>
  </xsl:message>
</xsl:template>

<xsl:template match='xpath-constraint/p' mode='raw'>
  <xsl:copy>
    <xsl:apply-templates select='@*' mode='raw'/>
    <xsl:apply-templates select='node()' mode='text'/>
  </xsl:copy>
</xsl:template>

<!-- A schema fragment to appear as raw XML output 
-->
<xsl:template match="schema" mode='raw'>
  <!-- TEST what='{name(.)}' id='{@id}'/ -->
  <xsl:apply-templates mode='raw'/>
</xsl:template>

<xsl:template match="schema[@base]" mode='raw'>
  <xsl:apply-templates mode='copy-from' 
     select="$root//schema[@id=current()/@base]"/>
</xsl:template>
<!-- GS: don't understand why we need this @copy-from attribute -->
<xsl:template match="schema[@copy-from]" mode='raw'>
  <xsl:apply-templates mode='copy-from' 
     select="$root//schema[@id=current()/@copy-from]"/>
</xsl:template>
<xsl:template match="schema[@copy-from]" mode='copy-from'>
  <xsl:apply-templates mode='copy-from' 
     select="$root//schema[@id=current()/@copy-from]"/>
</xsl:template>
<xsl:template match="schema[@base]" mode='copy-from'>
  <xsl:apply-templates mode='copy-from' 
     select="$root//schema[@id=current()/@base]"/>
</xsl:template>
<xsl:template match="/|@*|node()" mode='copy-from'>
  <xsl:apply-templates mode="raw" select="."/> 
</xsl:template>

<!-- Required links in schema fragments are never shown -->
<xsl:template match="schema/requires" mode='raw' priority='1'>
</xsl:template>

<!-- An ellipsis in raw output is dereferenced and the
     result of dereferencing is processed as raw output. -->
<xsl:template match='ellipsis' mode='raw'>
  <xsl:for-each select="@ref|.//ellipsis/@ref">
    <xsl:apply-templates 
      select="$root//schema[@id=current()]" 
      mode='raw'/>
  </xsl:for-each>
</xsl:template>

<!-- The following xsd elements can have appinfo, documentation and
     hl7 constraints, which we will fill in here from the context.
     
     - complexType
     - simpleType
     - element
     - attribute 
-->

<xsl:template match='schema[@for]/*' mode='raw'>
  <xsl:variable name="for" select="../@for"/>
  <xsl:variable name="schema" select="../@id"/>

  <xsl:copy>
    <xsl:apply-templates select="@*" mode='raw'/>
    <!-- here we merge additional annotations to an existing
         annotation -->
    <xsd:annotation>
      <xsl:apply-templates mode='raw' select="./xsd:annotation/@*"/>
      <xsd:documentation>
        <xsl:apply-templates mode='text'
	   select="$root//*[@id=$for]/definition/node()"/>
      </xsd:documentation>
      <xsd:appinfo>
        <xsl:apply-templates mode='raw'
	   select="./xsd:annotation/xsd:appinfo/@*"/>
        <xsl:apply-templates mode='raw'
	     select="./xsd:annotation/xsd:appinfo/node()"/>
        <xsl:apply-templates mode='raw'
             select="$root//xpath-constraint[@context=$schema]"/>
      </xsd:appinfo>
    </xsd:annotation>
    <xsl:apply-templates mode='raw'
       select="node()[not(self::xsd:annotation)]"/>
  </xsl:copy>
</xsl:template>

<!-- xsl:template match='text()[string-length(normalize-space(.))>0]' 
	      mode='raw'>
  <xsl:copy/>
</xsl:template>

<xsl:template match='text()[string-length(normalize-space(.))=0]' 
	      mode='raw'>
</xsl:template -->

<!-- A function to copy everything right through as XML, used when 
     generating the full schema as an XML document of its own (not 
     for HTML pretty printing.)
-->
<xsl:template match='@*|node()' mode='raw' name="copy-raw">
  <xsl:copy>
    <xsl:apply-templates select='@*|node()' mode='raw'/>
  </xsl:copy>
</xsl:template>

<!-- Text mode, for definitions. Basically an unwarpping transform,
     but resolve dtref and other reference items to names. -->
<xsl:template mode="text" match="/|@*|node()">
  <xsl:apply-templates mode="text" select="@*|node()"/>
</xsl:template>

<xsl:template mode="text" match="text()" priority="1">
  <xsl:value-of select="."/>
</xsl:template>

<!-- if there's text inside the reference, use that text only -->
<xsl:template mode="text" match="dtimplref[text()]" priority="1">
  <xsl:apply-templates mode="text" select="node()"/>
</xsl:template>

<xsl:template mode="text" match="dtimplref[@ref]">
  <xsl:param name='ref' select='@ref'/>
  <xsl:value-of select="//dtimpl[@id=$ref]/@shortname"/>
</xsl:template>
<xsl:template mode="text" match="dtref[@ref]">
  <xsl:param name='ref' select='@ref'/>
  <xsl:value-of 
     select="document('datatypes-source.xml')//dt[@id=$ref]/@shortname"/>
</xsl:template>

<xsl:template mode="text" match="loc[@href]">
  <xsl:value-of select="@href"/>
</xsl:template>

<xsl:template mode="text" match="footnote"/>

</xsl:transform>



