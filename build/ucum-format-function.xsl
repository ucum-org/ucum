<?xml version="1.0" encoding="UTF-8"?>
<!-- Copyright (c) 2008, Pragmatic Data, LLC. All rights reserved. -->
<xsl:transform version="2.0"
	       xmlns:saxon="http://saxon.sf.net/"
	       xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	       xmlns:f="f"
	       exclude-result-prefixes="f saxon xsl">

   <xsl:variable name="ucum-essence" select="document('ucum-essence.xml')"/>
   <xsl:variable name="prefix" select="$ucum-essence/*/prefix"/>
   <xsl:variable name="metric-unit" select="$ucum-essence/*/base-unit|$ucum-essence/*/unit[@isMetric='yes']"/>
   <xsl:variable name="non-metric-unit" select="$ucum-essence/*/unit[not(@isMetric='yes')]"/>
   <xsl:variable name="prefix-regex" select="string-join($ucum-essence/*/prefix/@Code,'|')"/>
   <xsl:variable name="metric-regex" select="replace(string-join($metric-unit/@Code,'|'),'([\[\]\*\^])','\\$1')"/>
   <xsl:variable name="non-metric-regex" select="replace(string-join($non-metric-unit/@Code,'|'),'([\[\]\*\^])','\\$1')"/>

   <xsl:function name="f:formatUnit" saxon:memo-function="yes">
      <xsl:param name="code"/>
      <xsl:analyze-string select="$code" regex="[/\.\(\)]">
	 <xsl:matching-substring>
	    <span class="unit-operator"><xsl:sequence select="if(.='.') then ' ' else ."/></span>
	 </xsl:matching-substring>
	 <xsl:non-matching-substring>
	    <xsl:sequence select="f:formatAnnot(.)"/>
	 </xsl:non-matching-substring>
      </xsl:analyze-string>
   </xsl:function>

   <xsl:function name="f:formatAnnot" saxon:memo-function="yes">
      <xsl:param name="code"/>
      <xsl:analyze-string select="$code" regex="{'\{([^\}]+)\}'}">
	 <xsl:matching-substring>
	    <span class="unit-annotation"><xsl:sequence select="regex-group(1)"/></span>
	 </xsl:matching-substring>
	 <xsl:non-matching-substring>
	    <xsl:sequence select="f:formatPart(.)"/>
	 </xsl:non-matching-substring>
      </xsl:analyze-string>
   </xsl:function>

   <xsl:function name="f:formatPart" saxon:memo-function="yes">
      <xsl:param name="code"/>
      <xsl:analyze-string select="$code" regex="^({$prefix-regex})?({$metric-regex})([0-9]*)$">
	 <xsl:matching-substring>
	    <span class="unit-prefix"><xsl:sequence select="($prefix[@Code=regex-group(1)]/printSymbol/node(), regex-group(1))[1]"/></span>
	    <xsl:variable name="printSymbol" select="$metric-unit[@Code=regex-group(2)]/printSymbol/node()"/>
	    <span class="unit-atom"><xsl:sequence select="if($printSymbol) then $printSymbol else f:formatAtom(regex-group(2))"/></span>
	    <xsl:if test="regex-group(3)">
	       <sup><xsl:sequence select="regex-group(3)"/></sup>
	    </xsl:if>
	 </xsl:matching-substring>
	 <xsl:non-matching-substring>
	    <xsl:sequence select="f:formatNonMetric(.)"/>
	 </xsl:non-matching-substring>
      </xsl:analyze-string>
   </xsl:function>

   <xsl:function name="f:formatNonMetric" saxon:memo-function="yes">
      <xsl:param name="code"/>
      <xsl:analyze-string select="$code" regex="^({$non-metric-regex})([0-9]*)$">
	 <xsl:matching-substring>
	    <xsl:variable name="printSymbol" select="$non-metric-unit[@Code=regex-group(1)]/printSymbol/node()"/>
	    <span class="unit-atom"><xsl:sequence select="if($printSymbol) then $printSymbol else f:formatAtom(regex-group(1))"/></span>
	    <xsl:if test="regex-group(2)">
	       <sup><xsl:sequence select="regex-group(2)"/></sup>
	    </xsl:if>
	 </xsl:matching-substring>
	 <xsl:non-matching-substring>
	    <xsl:sequence select="f:formatAtom(.)"/>
	 </xsl:non-matching-substring>
      </xsl:analyze-string>
   </xsl:function>

   <xsl:function name="f:formatAtom" saxon:memo-function="yes">
      <xsl:param name="code"/>
      <xsl:analyze-string select="$code" regex="^\[([^\]]+)\]$">
	 <xsl:matching-substring>
	    <span class="unit-bracket"><xsl:sequence select="f:formatSub(regex-group(1))"/></span>
	 </xsl:matching-substring>
	 <xsl:non-matching-substring>
	    <xsl:sequence select="f:formatSub(.)"/>
	 </xsl:non-matching-substring>
      </xsl:analyze-string>
   </xsl:function>

   <xsl:function name="f:formatSub" saxon:memo-function="yes">
      <xsl:param name="code"/>
      <xsl:analyze-string select="$code" regex="_(.+)$">
	 <xsl:matching-substring>
	    <sub><xsl:sequence select="regex-group(1)"/></sub>
	 </xsl:matching-substring>
	 <xsl:non-matching-substring>
	    <span class="unit-remainder"><xsl:sequence select="."/></span>
	 </xsl:non-matching-substring>
      </xsl:analyze-string>
   </xsl:function>

</xsl:transform>
