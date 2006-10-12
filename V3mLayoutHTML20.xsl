<?xml version="1.0"?>
<!-- File: v3pub-online-Woody-1020 
This is Paul's 9/10/01 file with a LIMITED number of changes as detailed below.
-->
<!-- PROBLEMS 30/01/01Template match="xtermref" href not appearing within text output -->
<!-- CHANGES DPW 24/10/01: Template match=xspecref : Document and href paths altered relative to new build structure -->
<!DOCTYPE xsl:stylesheet [
	<!ENTITY copy "&#169;">
	<!ENTITY nbsp "&#160;">
	<!ENTITY reg "&#174;">
	<!ENTITY sect '&#xa7;'>
	<!ENTITY % v3pub-locations SYSTEM "v3m00.ent">
	%v3pub-locations;
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xlink="http://www.w3.org/TR/WD-xlink" 
	exclude-result-prefixes="xlink" version="1.1">
	
	<xsl:output method="html" indent="yes" encoding="ISO-8859-1" doctype-public="-//W3C//DTD HTML 4.0 Transitional//EN"/>
	<xsl:template match="spec" mode="css"/>
	<xsl:template match="/" name="root">
		<html>
			<head>
				<title>
					<xsl:value-of select="//header/title"/>
					<!-- GWB Change: In Paul's, this was 
						<xsl:value-of select="//header/title"/> but that failed to pick up the relevant sections in 
						documents like the RIM and Vocabulary that do NOT have "spec" as the root, which are 
						rooted in 'RIM' and 'VOC', respectively -->
				</title>
				<link rel="stylesheet" type="text/css" href="v3m00.css"/>
				<style type="text/css">
					<xsl:apply-templates select="." mode="css"/>
				</style>
     <link rel="stylesheet" type="text/css" href="xml-verbatim.css"/>
     <script type="text/javascript" src="xml-verbatim.js"/>
			</head>
			<body>
<!--
	make sure the spec template isn't called twice by
	using the for-each trick to make it the context node
 -->
				<xsl:choose>
					<xsl:when test="spec">
						<xsl:for-each select="spec">
							<xsl:call-template name="spec"/>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="spec"/>
					</xsl:otherwise>
				</xsl:choose>
				<!-- GWB Change: In Paul's, this had only the "for-each" loop (the 3rd through 5th
					lines below <xsl:choose> above.  As with the earlier concern, however, this fails to pick up
					 the root in documents like the RIM and Vocabulary that do NOT have "spec" as the root, but
					 are rooted in 'RIM' and 'VOC', respectively.  I believe the use of choose provides for both 
					 the assurance of a single path through 'spec', as Paul seeks, and the RIM and Vocab.  -->
			</body>
		</html>
	</xsl:template>
	<xsl:template match="spec" name="spec">
		<xsl:apply-templates/>
		
		<xsl:if test="//footnote">
			<div class="div1">
				<h2>Endnotes</h2>
				<ol>
					<xsl:for-each select="//footnote">
						<xsl:variable name="anchor">
							<xsl:number level="any" count="footnote" format="1"/>
						</xsl:variable>
						<li>
							<a name="fn{$anchor}"/>
							[<a href="#fn-src{$anchor}">source</a>]
							<xsl:apply-templates select="." mode="footnote-text"/>
						</li>
					</xsl:for-each>
				</ol>
			</div>
		</xsl:if>
	</xsl:template>

	<!--
	I wish I could get this:
		if /RIM then stuff out of here
  -->


	<xsl:template match="header">
		<!--<div class="head">-->
		<h1>
			<xsl:value-of select="title"/>
		</h1>
		<xsl:if test="/RIM">
			<p>
					Version: <xsl:value-of select="version"/> (<xsl:value-of select="date"/>)
					<br/>
					ModelID: <xsl:value-of select="../@modelID"/>
			</p>
		</xsl:if>
		<xsl:apply-templates select="authlist"/>
		<xsl:apply-templates select="version|ballot|revision"/>		
		<xsl:choose>
		  <xsl:when test="copyright">
                    <p class="copyright"><xsl:apply-templates select="copyright"/></p>
		  </xsl:when>
		  <xsl:otherwise>
		    <xsl:call-template name="copyright"/>
		  </xsl:otherwise>	
		</xsl:choose>
	<!--
			<xsl:apply-templates select="abstract"/>
-->
		<xsl:apply-templates select="status"/>
		<xsl:if test="/RIM">
			<xsl:apply-templates select="legalese"/>
			<a name="{../@id}"/>			
		</xsl:if>
		<hr title="Separator for header"/>
		<!--</div>-->
	</xsl:template>
	<xsl:template match="ballot">
		<!--<p>
			<xsl:value-of select="@type"/> Ballot # <xsl:value-of select="@number"/>
		</p>-->
	</xsl:template>
	<xsl:template match="authlist">
		<table border="0">
			<xsl:apply-templates/>
		</table>
	</xsl:template>
	<xsl:template match="author">
		<tr>
			<xsl:apply-templates select="role"/>
			<xsl:apply-templates select="name"/>
		</tr>
	</xsl:template>
	<xsl:template match="copyright">
		<tr>
		  <td valign="top">
			<xsl:text>Copyright &copy; </xsl:text>
			<xsl:apply-templates/>
		  </td>
		</tr>
	</xsl:template>
	<xsl:template match="author/role">
		<td width="150" valign="top">
			<xsl:apply-templates/>
		</td>
	</xsl:template>
	<xsl:template match="author/name">
		<td>
			<xsl:apply-templates/>
			<br/>
			<xsl:apply-templates select="../affiliation"/>
		</td>
	</xsl:template>
	<xsl:template match="author/affiliation">
		<xsl:apply-templates/>
	</xsl:template>
	<!--
	W3C specs have author/editor's emails...but
	traditionally HL7 specs haven't
  -->
	<xsl:template match="author/email">
		<a href="{@href}">
			<xsl:text>&lt;</xsl:text>
			<xsl:apply-templates/>
			<xsl:text>&gt;</xsl:text>
		</a>
	</xsl:template>
	<xsl:template match="status">
		<h2>
			<a name="status">Status of this document</a>
		</h2>
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="body">
		<h2>
			<a name="contents">Table of contents</a>
		</h2>
		<xsl:call-template name="toc"/>
		<hr/>
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="front">
		<xsl:apply-templates/>
		<hr title="Separator from body"/>
	</xsl:template>
	<xsl:template match="back">
		<hr title="Separator from footer"/>
		<div class="appendices">
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<xsl:template match="div1|div2|div3|div4">
		<!--<div class="{name()}">-->
		<xsl:apply-templates/>
		<!--</div>-->
	</xsl:template>
	<xsl:template match="div1/head|inform-div1/head">
		<xsl:call-template name="head">
			<xsl:with-param name="HeaderLevel" select="'h2'"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="div2/head">
		<xsl:call-template name="head">
			<xsl:with-param name="HeaderLevel" select="'h3'"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="div3/head">
		<xsl:call-template name="head">
			<xsl:with-param name="HeaderLevel" select="'h4'"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="div4/head">
		<xsl:call-template name="head">
			<xsl:with-param name="HeaderLevel" select="'h5'"/>
		</xsl:call-template>
	</xsl:template>
	<!--
	<xsl:template name="head">
		<table border="0" cellpadding="0" cellspacing="0" width="100%" class="header">
		<tr><td width="80" nowrap="" align="left">
		<xsl:for-each select="..">
			<xsl:call-template name="insertID"/>
			<xsl:apply-templates select="." mode="number"/>
		</xsl:for-each>
		</td><td>
		<xsl:apply-templates/>
		<xsl:call-template name="inform"/>
		</td></tr></table>
	</xsl:template>
	-->
	<xsl:template name="head">
		<xsl:param name="HeaderLevel"/>
		<table border="0" cellpadding="0" cellspacing="0" height="0" width="100%" class="header">
			<tr>
				<td width="68" nowrap="" valign="top" align="left">
					<xsl:element name="{$HeaderLevel}" namespace="">
						<xsl:for-each select="..">
							<xsl:call-template name="insertID"/>
							<xsl:apply-templates select="." mode="number"/>
						</xsl:for-each>
					</xsl:element>
				</td>
				<td valign="top">
					<xsl:element name="{$HeaderLevel}" namespace="">
						<xsl:apply-templates/>
						<xsl:call-template name="inform"/>
					</xsl:element>
				</td>
			</tr>
		</table>
	</xsl:template>

	<xsl:template name="divn-head">
		<xsl:param name="HeaderLevel"/>
		<xsl:param name="HeaderTag"/>
		<table border="0" cellpadding="0" cellspacing="0" height="0" width="100%" class="header">
			<tr>
				<td width="68" nowrap="" valign="top" align="left">
					<xsl:element name="{$HeaderLevel}" namespace="">
						<xsl:call-template name="insertID"/>
						<xsl:apply-templates select="." mode="number"/>
					</xsl:element>
				</td>
				<td valign="top">
					<xsl:element name="{$HeaderLevel}" namespace="">
						<xsl:value-of select="@name"/>
						<xsl:text> </xsl:text>
						<xsl:value-of select="($HeaderTag)"/>						
						<xsl:call-template name="inform"/>						
					</xsl:element>
				</td>
			</tr>
		</table>
	</xsl:template>

	<xsl:template name="custom-head">
		<xsl:param name="HeaderLevel"/>
		<xsl:param name="HeaderTag"/>
		<table border="0" cellpadding="0" cellspacing="0" height="0" width="100%" class="header">
			<tr>
				<td width="68" nowrap="" valign="top" align="left">
					<xsl:element name="{$HeaderLevel}" namespace="">
						<xsl:call-template name="insertID"/>
						<xsl:apply-templates select="." mode="number"/>
					</xsl:element>
				</td>
				<td valign="top">
					<xsl:element name="{$HeaderLevel}" namespace="">
						<xsl:value-of select="$HeaderTag"/>
						<xsl:call-template name="inform"/>
					</xsl:element>
				</td>
			</tr>
		</table>
	</xsl:template>
	
	<xsl:template match="p">
		<p>
			<xsl:apply-templates select="@*|node()"/>
		</p>
		<!--</p><br/><br/>-->
	</xsl:template>
	
	<!-- HST: try to cope: DTD allows nesting of blocks within p -->
	<xsl:template match="p[p|list|slist|glist|orglist|blist|note|issue]">
		<xsl:call-template name="blocks">
			<xsl:with-param name="nodes" select="*|text()"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="blocks">
		<xsl:param name="nodes"/>
		<xsl:if test="$nodes[position()=1]">
			<xsl:choose>
				<!-- blocks go through unchanged -->
				<xsl:when test="$nodes[position()=1 and
						(self::p or self::list or
						self::slist or self::glist or self::orglist
						or self::blist or self::note or self::issue)]">
					<xsl:apply-templates select="$nodes[position()=1]"/>
					<xsl:call-template name="blocks">
						<xsl:with-param name="nodes" select="$nodes[position()>1]"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<!-- text or mixins get joined together and wrapped in <p>..</p> -->
					<p>
						<xsl:apply-templates select="$nodes[position()=1]"/>
						<xsl:call-template name="mixins">
							<xsl:with-param name="nodes" select="$nodes[position()>1]"/>
						</xsl:call-template>
					</p>
					<!--
	need position of first block, if any, but don't see
	how to get it, so use recursion again.
  -->
					<xsl:call-template name="findblock">
						<xsl:with-param name="nodes" select="$nodes[position()>1]"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	<xsl:template name="mixins">
		<xsl:param name="nodes"/>
		<xsl:if test="$nodes[position()=1]">
			<xsl:choose>
				<xsl:when test="$nodes[position()=1 and
						(self::p or self::list or
						self::slist or self::glist or self::orglist or
						self::blist or self::note or self::issue)]"/>
				<xsl:otherwise>
					<xsl:apply-templates select="$nodes[position()=1]"/>
					<xsl:call-template name="mixins">
						<xsl:with-param name="nodes" select="$nodes[position()>1]"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	<xsl:template name="findblock">
		<xsl:param name="nodes"/>
		<xsl:if test="$nodes[position()=1]">
			<xsl:choose>
				<xsl:when test="$nodes[position()=1 and
						(self::p or self::list or
						self::slist or self::glist or self::orglist or
						self::blist or self::note or self::issue)]">
					<xsl:call-template name="blocks">
						<xsl:with-param name="nodes" select="$nodes"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="findblock">
						<xsl:with-param name="nodes" select="$nodes[position()>1]"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	<xsl:template match="eg" name="egbody">
		<pre>
			<xsl:if test="@role='error'">
				<xsl:attribute name="style">color: red</xsl:attribute>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="@text">
					<xsl:value-of select="document(@text)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates/>
				</xsl:otherwise>
			</xsl:choose>
		</pre>
	</xsl:template>
	<xsl:template match="ednote">
		<blockquote>
			<p>
				<b>Ed. Note: </b>
				<xsl:apply-templates/>
			</p>
		</blockquote>
	</xsl:template>
	<xsl:template match="edtext">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="issue">
		<xsl:call-template name="insertID"/>
		<blockquote>
			<p>
				<b>Issue (<xsl:value-of select="@id"/>): </b>
				<xsl:apply-templates/>
			</p>
		</blockquote>
	</xsl:template>
	<xsl:template match="note">
		<blockquote>
			<b>NOTE: </b>
			<xsl:apply-templates/>
		</blockquote>
	</xsl:template>
	<xsl:template match="issue/p|note/p|def/p|item/p">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="loc">
		<b>
		<a href="{@href}">
			<xsl:choose>
				<xsl:when test="* | text()">
					<xsl:apply-templates/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@href"/>
				</xsl:otherwise>
			</xsl:choose>
		</a>
		</b>
	</xsl:template>
	<xsl:template match="bibref">
		<a href="#{@ref}">
			<!--
				12/28/2001 MAC 
				input used to be xxx [xxx] in XML source files so output would be duplicated. 
				XML content should simply bibref the id(@ref)/@key nodes to get the bib text for 
				output and output it as a link.
				<xsl:text/>[<xsl:value-of select="id(@ref)/@key"/>]<xsl:text/>-->
				<xsl:value-of select="id(@ref)/@key"/>
		</a>
	</xsl:template>
	<xsl:template match="specref">
		<a href="#{@ref}">
			<xsl:value-of select="id(@ref)/head"/>
			(&sect;
			<xsl:for-each select="id(@ref)">
				<xsl:apply-templates select="." mode="number"/>
			</xsl:for-each>)</a>
	</xsl:template>

	<xsl:template match="termref">
		<a class="termref" href="#{@ref}">
			<xsl:apply-templates/>
		</a>
	</xsl:template>

<!--	<xsl:template match="dtref">
		<xsl:variable name="filenameonly" select="&datatypesfile;"/>
		<xsl:variable name="thisref" select="@ref"/>
		<xsl:variable name="htmfile" select="concat($filenameonly, '.htm')"/>
		<xsl:variable name="xmlfile" select="concat($filenameonly, '.xml')"/>
		<a>
			<xsl:attribute name="class">xtermref</xsl:attribute>
			<xsl:attribute name="href"><xsl:value-of select="concat($htmfile,'#')"/><xsl:value-of select="(@ref)"/></xsl:attribute>
			<xsl:apply-templates select="document($xmlfile)//dt[@ref=$thisref]/node()"/>
			<xsl:apply-templates/>
		</a>
	</xsl:template> -->

	<xsl:template match='dtref'>
		<xsl:variable name='genericOrCollection' select='substring-before(@ref,"_")'/>
		<xsl:choose>
			<xsl:when test='$genericOrCollection=""'>
				<a class='ilink' href='#{@ref}'>
					<xsl:value-of select='@ref'/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name='type' select='substring-after(@ref,"_")'/>
				<a class='ilink' href='#{$genericOrCollection}'><xsl:value-of select='$genericOrCollection'/></a>&lt;
				<xsl:choose>
					<xsl:when test='$type="T"'>
						T
					</xsl:when>
					<xsl:otherwise>
						<a class='ilink' href='#{$type}'><xsl:value-of select='$type'/></a>
					</xsl:otherwise>
				</xsl:choose>&gt;
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match='dtref[@role="pageref"]'>
	<!-- should generate an <fo:page-number/> of the page
	     where the dt occurs -->
	</xsl:template>

	<xsl:template match="xtermref">
		<xsl:variable name="filenameonly">
			<xsl:call-template name="extractfilename">
				<xsl:with-param name="filestring" select="@href"/>
			</xsl:call-template>
		</xsl:variable> 
		<xsl:variable name="htmfile" select="concat($filenameonly, '.htm')"/>
		<a>
			<xsl:attribute name="class">xtermref</xsl:attribute>
			<xsl:attribute name="href"><xsl:value-of select="(@href)"/></xsl:attribute>
			<xsl:variable name="refID">
				<xsl:value-of select="substring-after(@href,'#')"/>
			</xsl:variable>
			<xsl:variable name="dir" select="substring-before(@href, $filenameonly)"/>
			<xsl:variable name="dirplus" select="concat($dir, $filenameonly)"/>
			<xsl:variable name="xmlfile" select="concat($dirplus,'.xml')"/>
			<xsl:apply-templates select="document($xmlfile)//*[@id=$refID]/label/node()"/>
			<xsl:apply-templates/>
		</a>
	</xsl:template>
	
	<xsl:template name="extractfilename">
		<xsl:param name="filestring"/>
		<xsl:choose>
			<xsl:when test="contains($filestring, '/')">
				<xsl:variable name="remainder" select="substring-after($filestring, '/')"/>
				<xsl:call-template name="extractfilename">
					<xsl:with-param name="filestring" select="$remainder"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="substring-before($filestring, '.')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!--<xsl:template match="xspecref">
		<a target='xspecref' class="elink" href="{@spec}#{@ref}">
			<xsl:apply-templates/>
		</a>
	</xsl:template>-->
	<xsl:template match="xspecref">
		<div class="descriptive">
			<b>
			<a>
				<xsl:attribute name="class">elink</xsl:attribute>
				<xsl:attribute name="href"><xsl:value-of select="@spec"/><xsl:text>#</xsl:text><xsl:value-of select="@ref"/></xsl:attribute>
				<xsl:apply-templates/>
			</a>
			</b>
		</div>
	</xsl:template>
	<xsl:template match="titleref">
		<a href="#{@href}">
			<xsl:apply-templates/>
		</a>
	</xsl:template>
	<xsl:template match="termdef">
		<a name="{@id}"/>
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="anchor">
		<a name="{@id}"/>
		<xsl:apply-templates/>
	</xsl:template>
	
	<xsl:template match="term">
		<b>
			<xsl:apply-templates/>
		</b>
	</xsl:template>
	
	<xsl:template match="code">
		<code>
			<xsl:apply-templates/>
		</code>
	</xsl:template>

	<!-- added GS 7/25/2002 -->
	<xsl:template match="pre">
		<pre><xsl:apply-templates/></pre>
	</xsl:template>

	<!-- added GS 3/7/2002-->
	<xsl:template match="ul">
		<ul>
			<xsl:apply-templates select='@*|node()'/>
		</ul>
	</xsl:template>
	
	<xsl:template match="emph">
		<em>
			<xsl:apply-templates/>
		</em>
	</xsl:template>

	<xsl:template match="emph[@role='strong']">
		<strong>
			<xsl:apply-templates/>
		</strong>
	</xsl:template>

	<xsl:template match="emph[@role='sub']">
		<sub>
			<xsl:apply-templates/>
		</sub>
	</xsl:template>

	<xsl:template match="emph[@role='sup']">
		<sup>
			<xsl:apply-templates/>
		</sup>
	</xsl:template>

	<xsl:template match="emph[@role='small']">
		<span class="small">
			<xsl:apply-templates/>
		</span>
	</xsl:template>

	<xsl:template match="blist">
		<dl>
			<xsl:apply-templates/>
		</dl>
	</xsl:template>
	<xsl:template match="blist/bibl">
		<dt>
			<b>
				<a name="{@id}">
					<xsl:value-of select="@key"/>
				</a>
			</b>
		</dt>
		<dd>
			<xsl:apply-templates/>
		</dd>
	</xsl:template>
	<xsl:template match="list[@role='ordered']">
		<ol>
			<xsl:apply-templates/>
		</ol>
	</xsl:template>
	<xsl:template match="list[@role='unordered']">
		<xsl:choose>
			<xsl:when test="../list">
				<ul style="padding-left:20px;">
					<xsl:apply-templates/>
				</ul>
			</xsl:when>
			<xsl:otherwise>
				<ul>
					<xsl:apply-templates/>
				</ul>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="glist">
		<div class="descriptive">
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<xsl:template match="gitem">
			<a name="{@id}"></a>
			<xsl:apply-templates select="label"/><br/>
			<xsl:apply-templates select="def/*"/><br/><br/>
	</xsl:template>
	<xsl:template match="item">
		<li>
			<xsl:apply-templates/>
		</li><br/><br/>
	</xsl:template>
	<xsl:template match="label">
			<b>
				<xsl:apply-templates/>
			</b>
	</xsl:template>
	<xsl:template match="def">
		<br/>
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="spec/header/title"/>
	<xsl:template match="version">
	  <p>Version: <xsl:apply-templates select="node()"/></p>
	</xsl:template>
	<xsl:template match="revision">
	  <p>Revision: <xsl:apply-templates select="node()"/></p>
	</xsl:template>
	<xsl:template name="copyright">
		<p class="copyright">HL7 Version 3 Standard, Copyright Health Level Seven, Inc.&copy; 2002. All Rights Reserved.</p>
	</xsl:template>
	<xsl:template name="toc">
		<xsl:for-each select="/spec/body/div1|storydivn|approledivn|triggerdivn|interactiondivn|categorydivn|rmimdivn|dmimdivn|hmddivn|indexdivn">
			<xsl:call-template name="makeref"/>
			<br/>
			<xsl:for-each select="div2">
				<xsl:text>&nbsp;&nbsp;&nbsp;&nbsp;</xsl:text>
				<xsl:call-template name="makeref"/>
				<br/>
<!-- GDG Dec 2003 don't index div3 - leads to cleaner TOC's that are easier to navigate. But is this OK with pubs?
				<xsl:for-each select="div3">
					<xsl:text>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</xsl:text>
					<xsl:call-template name="makeref"/>
					<br/>
				</xsl:for-each>
-->				
			</xsl:for-each>
	
			<xsl:for-each select="approle|story|trigger|interaction|category|rmim|dmim|hmd|msgtype|indexlist">
				<xsl:text>&nbsp;&nbsp;&nbsp;&nbsp;</xsl:text>
				<xsl:call-template name="makeref"/>
				<br/>
			</xsl:for-each>

		</xsl:for-each>
		<xsl:if test="/spec/back">
			<h3>Appendices</h3>
			<xsl:for-each select="/spec/back/div1 | /spec/back/inform-div1">
				<xsl:call-template name="makeref"/>
				<br/>
				<xsl:for-each select="div2">
					<xsl:text>&nbsp;&nbsp;&nbsp;&nbsp;</xsl:text>
					<xsl:call-template name="makeref"/>
					<br/>
<!-- GDG Dec 2003 don't index div3 - leads to cleaner TOC's that are easier to navigate. But is this OK with pubs?
					<xsl:for-each select="div3">
						<xsl:text>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</xsl:text>
						<xsl:call-template name="makeref"/>
						<br/>
					</xsl:for-each>
-->				
				</xsl:for-each>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
	<xsl:template name="insertID">
		<xsl:choose>
			<xsl:when test="@id">
				<a name="{@id}"/>
			</xsl:when>
			<xsl:otherwise>
				<a name="section-{translate(head,' ','-')}"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<xsl:template name="makeref">
		<xsl:apply-templates select="." mode="number"/>
		<xsl:choose>
			<xsl:when test="@id">
				<a href="#{@id}">
					<xsl:value-of select="head"/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<a href="#section-{translate(head,' ','-')}">
					<xsl:value-of select="head"/>
				</a>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:for-each select="head">
			<xsl:call-template name="inform"/>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="inform">
		<xsl:if test="parent::inform-div1">
			<xsl:text> (Non-Normative)</xsl:text>
		</xsl:if>
	</xsl:template>
	<xsl:template match="nt">
		<a href="#{@def}">
			<xsl:apply-templates/>
		</a>
	</xsl:template>
	<xsl:template match="xnt">
		<a href="{@href}">
			<xsl:apply-templates/>
		</a>
	</xsl:template>
	<xsl:template match="quote">
		<blockquote>
			<xsl:apply-templates/>
		</blockquote>
	</xsl:template>
	<xsl:template match="p[quote]">
		<blockquote>
			<xsl:apply-templates/>
		</blockquote>
	</xsl:template>
	<xsl:template mode="number" match="back//*|footnote">
		<xsl:number level="multiple" count="inform-div1|div1|div2|div3|div4|footnote" format="A.1 "/>
	</xsl:template>
	<xsl:template mode="number" match="*">
		<xsl:number level="multiple" count="inform-div1|div1|div2|div3|div4" format="1.1 "/>
	</xsl:template>
	<!--
	what is this?
  -->
	<xsl:template name="DataType">
		<xsl:param name="Text"/>
		<xsl:param name="Path" select="''"/>
		<xsl:choose>
			<xsl:when test="contains($Text,'-')">
				<a href="{$Path}DataType1.htm#{substring-before($Text,'-')}">
					<xsl:value-of select="substring-before($Text,'-')"/>
				</a>
				<xsl:text>&lt;</xsl:text>
				<a href="{$Path}DataType1.htm#{substring-before(substring-after($Text,'-'),'-')}">
					<xsl:value-of select="substring-before(substring-after($Text,'-'),'-')"/>
				</a>
				<xsl:text>&gt;</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<a href="{$Path}DataType1#{$Text}">
					<xsl:value-of select="$Text"/>
				</a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="thead|tfoot|tbody|colgroup|tr|th|td">
		<xsl:copy>
			<xsl:apply-templates select="* | @* | text()"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="col"/>
	<xsl:template match="table/@width"/>
	<xsl:template match="table">
		<xsl:copy>
			<!-- Do all of this in CSS, not here!
                         xsl:attribute name="cellspacing">0</xsl:attribute>
			<xsl:attribute name="cellpadding">5</xsl:attribute>
			<xsl:attribute name="border">1</xsl:attribute>
			<xsl:attribute name="bordercolor">blue</xsl:attribute
			-->
			<xsl:attribute name="class">standard</xsl:attribute>
			<xsl:apply-templates select="* | @*"/>
		</xsl:copy>
	</xsl:template>
	<!--
	somehow, we need to make sure that namespace decls
	don't come thru...but these don't work
  	<xsl:template match='@xmlns:xlink'/>
  -->
	<xsl:template match="@*">
		<xsl:copy/>
	</xsl:template>
	<xsl:template match="caption">
		<caption>
			<xsl:if test="../@id">
				<a name="{../@id}"/>
			</xsl:if>
			Table
			<xsl:number level="any" count="table[caption]" format="1: "/>
			<xsl:value-of select="."/>
		</caption>
	</xsl:template>

	<xsl:template match="graphic">
		<xsl:variable name="Source" select="substring-before(@source, '.')"/>
		<xsl:choose>
			<xsl:when test="document('largegraphics.xml')/largegraphics/graphicref[@id=$Source]">
				<xsl:variable name="newsource" select="concat(substring-before(@source, '/'), '/L-', substring-after(@source, '/'))"/>
				<div class="descriptive">
					<a href="{$newsource}" target="_blank">
						<xsl:text>Link to graphic (opens in a new window)</xsl:text>
					</a>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<div class="descriptive">
					<img src="{@source}" alt="{@alt}" class="graphic"/>
				</div>
			</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="@alt">
			<div class="descriptive">
				<p>
					Figure
					<xsl:number level="any" count="graphic[@alt]" format="1: "/>
					<xsl:value-of select="@alt"/>
				</p>
			</div>
		</xsl:if>
	</xsl:template>

	<!-- THIS IS FOR GENERIC EXHIBITS -->
	<xsl:variable name='labelMap'>
		<exhibit role='requirement' label='Requirement'/>
		<exhibit role='example' label='Example'/>
		<exhibit role='template' label='Type Template'/>
		<exhibit role='schema'  label='Schema Fragment'/>
		<exhibit role='dtdl'    label='Definition'/>
		<exhibit role='exhibit' label='Exhibit'/>
	</xsl:variable>

	<xsl:template match="exhibit">
	  <table id='{@id}' width='90%'>
	    <xsl:apply-templates select='./caption[1]'/>
	    <tr><td class='{@role}'>
	      <xsl:choose>
	        <xsl:when test="@verbatim='yes'">
		  <xsl:copy-of select="*[not(self::caption)]|text()"/>
		</xsl:when>
		<xsl:otherwise>
	          <xsl:apply-templates select="*[not(self::caption)]|text()"/>
		</xsl:otherwise>
              </xsl:choose>
	    </td></tr>
	  </table>
	</xsl:template>
	
	<xsl:template match="exhibit/caption">
		<xsl:param name='role'>
		   <xsl:choose>
                     <xsl:when test="../@role">
		       <xsl:value-of select="../@role"/>
		     </xsl:when>
		     <xsl:otherwise>
		       <xsl:text>exhibit</xsl:text>
		     </xsl:otherwise>
		   </xsl:choose>
                </xsl:param>
		<xsl:param name='label'>
		  <xsl:choose>
		    <xsl:when test='../@label'>
		      <xsl:value-of select="../@label"/>
		    </xsl:when>
		    <xsl:otherwise>
		      <xsl:value-of select="$labelMap/exhibit[@role=$role]/@label"/>
                    </xsl:otherwise>
                  </xsl:choose>
		</xsl:param>
		<xsl:copy>
  		  <xsl:apply-templates select='@*'/>
		  <xsl:value-of select='$label'/>
		  <xsl:number level="any" 
                              count="exhibit[@role=$role]" format=" 1: "/>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>
	<!-- END EXHIBIT -->	
	
	<xsl:template match="br">
		<xsl:copy>
			<xsl:apply-templates select="* | @*"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="footnote">
		<xsl:variable name="anchor">
			<xsl:number level="any" count="footnote" format="1"/>
		</xsl:variable>
		<a name="fn-src{$anchor}"/>
		<a href="#fn{$anchor}">
			<sup style="font-size: smaller">
				<xsl:value-of select="$anchor"/>
			</sup>
		</a>
	</xsl:template>
	
	<xsl:template match="footnote" mode="footnote-text">
		<xsl:apply-templates select="p[1]"/>
		<xsl:apply-templates select="p[position()>1]"/>
	</xsl:template>
	<xsl:template match="footnote/p[1]">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="xdtref">
		<a href="&datatypesfile;.htm#{@ref}">
			<xsl:choose>
				<xsl:when test="text()">
					<xsl:value-of select="."/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@ref"/>
				</xsl:otherwise>
			</xsl:choose>
		</a>
	</xsl:template>

	<xsl:template match="tabref">
		<xsl:variable name="ref" select="@ref"/>
		<a href="#{@ref}">Table
			<xsl:for-each select="//table[@id=$ref]">
				<xsl:number level="any" count="table[caption]"/>
			</xsl:for-each>
		</a>
	</xsl:template>
	<xsl:template match="xtabref">
		<xsl:variable name="ref" select="@ref"/>
		<xsl:variable name="spec" select='concat("../input/XML/",@spec,".xml")'/>
		<xsl:variable name="specNodes" select="document($spec)/*"/>
		<a class="elink" target="xspecref" href="../{@spec}/{@spec}.htm#{@ref}">Table
			<xsl:for-each select="$specNodes//table[@id=$ref]">
				<xsl:number level="any" count="table[caption]"/>
			</xsl:for-each>
		</a>
	</xsl:template>

	<xsl:template match='propname'>
		<b><i>
			<xsl:choose>
				<xsl:when test='text()'>
						<xsl:value-of select='.'/>
				</xsl:when>
				<xsl:otherwise>
			  		<xsl:variable name='id' select='ancestor::prop/@id'/>
					<xsl:value-of select='&v3dt;//prop[@id=$id]/head'/>
				</xsl:otherwise>
			</xsl:choose>
		</i></b>
	</xsl:template>


	<xsl:template match="descriptive" name="descriptive">
		<div class="descriptive">
			<b>
				<xsl:value-of select="@name"/>
			</b>
		</div>
		<xsl:apply-templates/>

	</xsl:template>

</xsl:stylesheet>
