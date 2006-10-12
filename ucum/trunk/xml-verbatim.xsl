<xsl:transform 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
   xmlns:verb="http://informatik.hu-berlin.de/xml-verbatimatim" 
   version="2.0" 
   exclude-result-prefixes="verb">
<!--
The contents of this file are subject to the Health Level-7 Public
License Version 1.0 (the "License"); you may not use this file
except in compliance with the License. You may obtain a copy of the
License at http://www.hl7.org/HPL/hpl.txt.

Software distributed under the License is distributed on an "AS IS"
basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
the License for the specific language governing rights and
limitations under the License.

The Original Code is all this file.

The Initial Developer of the Original Code is Gunther Schadow.
Portions created by Initial Developer are Copyright (C) 2002-2004
Regenstrief Institute, Inc. All Rights Reserved.

Revision: $Id: xml-verbatim.xsl,v 1.2.4.1 2004/11/12 23:44:53 gschadow Exp $
-->

   <xsl:output method="html" omit-xml-declaration="no" indent="yes"/>
   <xsl:strip-space elements="*"/>

   <xsl:template match="/">
      <html>
        <head>
	  <xsl:call-template name="xml-verbatim-setup"/>
	</head>
        <body>
          <xsl:apply-templates select="." mode="xml-verbatim"/>
	</body>
      </html>
   </xsl:template>

   <xsl:template name="xml-verbatim-setup">
     <link rel="stylesheet" type="text/css" href="xml-verbatim.css"/>
     <script type="text/javascript" src="xml-verbatim.js"/>   
   </xsl:template>

   <!-- root -->
   <xsl:template match="/" mode="xml-verbatim">
      <xsl:text>
</xsl:text>
      <xsl:comment>
         <xsl:text> Converted by xml-verbatimatim.xsl by Gunther Schadow. </xsl:text>
      </xsl:comment>
      <xsl:text>
</xsl:text>
      <div class="xml-verbatim-default" 
           onclick="xmlVerbatimClick(event);"
           ondblclick="xmlVerbatimDblClick(event);">
         <xsl:apply-templates mode="xml-verbatim"/>
      </div>
      <xsl:text>
</xsl:text>
   </xsl:template>

   <!-- element nodes -->
   <xsl:template match="*" mode="xml-verbatim">
      <xsl:param name="indent" select="''" />
      <div class="xml-verbatim-element">
        <xsl:variable name="ns-prefix" select="substring-before(name(),':')" />
	<div class="xml-verbatim-element-head">
	  <xsl:text>&lt;</xsl:text>
	  <xsl:if test="$ns-prefix != ''">
	     <span class="xml-verbatim-element-nsprefix">
	        <xsl:value-of select="$ns-prefix" />
	     </span>
	     <xsl:text>:</xsl:text>
	  </xsl:if>
	  <span class="xml-verbatim-element-name">
	    <xsl:value-of select="local-name()" />
	  </span>
	  <xsl:for-each select="@*">
	     <xsl:call-template name="xml-verbatim-attrs"/>
	  </xsl:for-each>
	  <xsl:choose>
	    <xsl:when test="node()">
	      <span class="xml-verbatim-element-head-ellips">
	        <xsl:apply-templates mode="xml-verbatim-ellips" select="."/>
	        <xsl:text> ... /</xsl:text>
	      </span>
	      <xsl:text>&gt;</xsl:text>
	    </xsl:when>
	    <xsl:otherwise>
	       <xsl:text>/&gt;</xsl:text>
	    </xsl:otherwise>
	  </xsl:choose>
	</div>
	<xsl:if test="node()">
	  <div class="xml-verbatim-element-body">
	    <div class="xml-verbatim-element-content">
              <xsl:apply-templates mode="xml-verbatim" select="node()"/>
	    </div>
	    <span class="xml-verbatim-element-tail">
	       <xsl:text>&lt;/</xsl:text>
	       <xsl:if test="$ns-prefix != ''">
	         <span class="xml-verbatim-element-nsprefix">
		   <xsl:value-of select="$ns-prefix" />
		 </span>
	         <xsl:text>:</xsl:text>
	       </xsl:if>
	       <span class="xml-verbatim-element-name">
	         <xsl:value-of select="local-name()" />
	       </span>
	       <xsl:text>&gt;</xsl:text>
	    </span>
          </div>
	</xsl:if>
      </div>
   </xsl:template>

   <!-- attribute nodes -->
   <xsl:template name="xml-verbatim-attrs">
      <xsl:text> </xsl:text>
      <span class="xml-verbatim-attr-name">
         <xsl:value-of select="name()" />
      </span>
      <xsl:text>="</xsl:text>
      <span class="xml-verbatim-attr-content">
         <xsl:call-template name="html-replace-entities">
            <xsl:with-param name="text" select="normalize-space(.)" />
            <xsl:with-param name="attrs" select="true()" />
         </xsl:call-template>
      </span>
      <xsl:text>"</xsl:text>
   </xsl:template>

   <!-- text nodes -->
   <xsl:template match="text()" mode="xml-verbatim">
      <span class="xml-verbatim-text">
        <xsl:call-template name="html-replace-entities"/>
      </span>
   </xsl:template>

   <!-- comments -->
   <xsl:template match="comment()" mode="xml-verbatim">
      <xsl:text>&lt;!--</xsl:text>
      <span class="xml-verbatim-comment">
        <xsl:call-template name="html-replace-entities"/>
      </span>
      <xsl:text>--&gt;</xsl:text>
      <xsl:if test="not(parent::*)"><br /><xsl:text>
</xsl:text></xsl:if>
   </xsl:template>

   <!-- processing instructions -->
   <xsl:template match="processing-instruction()" mode="xml-verbatim">
      <xsl:text>&lt;?</xsl:text>
      <span class="xml-verbatim-pi-name">
         <xsl:value-of select="name()" />
      </span>
      <xsl:if test=".!=''">
         <xsl:text> </xsl:text>
         <span class="xml-verbatim-pi-content">
            <xsl:value-of select="." />
         </span>
      </xsl:if>
      <xsl:text>?&gt;</xsl:text>
      <xsl:if test="not(parent::*)"><br /><xsl:text>
</xsl:text></xsl:if>
   </xsl:template>

   <!-- generate entities by replacing &, ", < and > in $text -->
   <xsl:template name="html-replace-entities">
      <xsl:param name="text" select="."/>
      <xsl:param name="attrs" select="/.."/>
      <xsl:param name="first" select="substring($text,1,1)"/>
      <xsl:param name="rest" select="substring($text,2)"/>
      <xsl:choose>
        <xsl:when test="$first='&amp;'">
	  <xsl:text>&amp;amp;</xsl:text>
	</xsl:when>
        <xsl:when test="$first='&lt;'">
	  <xsl:text>&amp;lt;</xsl:text>
	</xsl:when>
        <xsl:when test="$first='&quot;'">
	  <xsl:text>&amp;quot;</xsl:text>
	</xsl:when>
        <xsl:when test="$first=' ' and $attrs">
	  <xsl:text>&#160;</xsl:text>
	</xsl:when>
        <xsl:when test="$first='&#xA;' and not($attrs)">
          <br/>
	</xsl:when>
        <xsl:when test="$first='&#xA;' and $attrs">
          <xsl:text>&amp;#xA;</xsl:text>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="$first"/>
	</xsl:otherwise>
      </xsl:choose>
      <xsl:if test="string-length($rest) > 0">
        <xsl:call-template name="html-replace-entities">
	  <xsl:with-param name="text" select="$rest"/>
	  <xsl:with-param name="attrs" select="$attrs"/>
	</xsl:call-template>
      </xsl:if>
   </xsl:template>

  <!-- MODE: xml-verbatim-ellips -->

  <xsl:template mode="xml-verbatim-ellips" match="/|@*|node()"/>

</xsl:transform>

