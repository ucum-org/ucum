<?xml version="1.0" encoding="ISO-8859-1" ?>
<!-- $Id: v3dt-v3pub.xsl,v 1.29.2.3 2005/06/10 12:30:18 gschadow Exp $ -->
<!-- XSL Style sheet, DTD omitted -->
<!DOCTYPE xsl:stylesheet [
  <!ENTITY sect "&#xa7;">
  <!ENTITY nbsp "&#160;">
  <!ENTITY alpha  "&#x3b1;">
  <!ENTITY beta   "&#x3b2;">
  <!ENTITY mu     "&#x3bc;">
  <!ENTITY pi     "&#x3c0;">
  <!ENTITY Pi     "&#x3a0;">
  <!ENTITY rho    "&#x3c1;">
  <!ENTITY epsilon "&#x3b5;">
  <!ENTITY Omega "&#x3a9;">
  <!ENTITY egrave "&#xe8;">
  <!ENTITY eacute "&#xe9;">
  <!ENTITY ouml   "&#xf6;">
  <!ENTITY Aring  "&#xc5;">
  <!ENTITY deg    "&#xb0;">
  <!ENTITY box    "&#x25a1;">
  <!ENTITY middot "&#xb7;">
  <!ENTITY mult   "&#xd7;"> 
  <!ENTITY nbsp   "&#xa0;"> 
  <!ENTITY ndash  "&#x2013;">
  <!ENTITY mdash  "&#x2014;">
  <!ENTITY ldquo  "&#x201C;">
  <!ENTITY rdquo  "&#x201D;">
  <!ENTITY lquo   "&#x2018;">
  <!ENTITY rquo   "&#x2019;">
  <!ENTITY langle "&#x2039;">
  <!ENTITY rangle "&#x203A;">
  <!ENTITY sim    "&#x7e;">
  <!ENTITY ssim   "&#x2248;">
  <!ENTITY bullet "&#x2022;">
  <!ENTITY element "&#x2208;">
  <!ENTITY cap    "&#x2229;">
  <!ENTITY cup    "&#x222A;">
  <!ENTITY emptyset "{}"> <!-- &#x2205; -->

	<!ENTITY % v3pub-locations SYSTEM 'v3pub-locations.ent'>
	%v3pub-locations;
	<!ENTITY schema 'W3C XML Schema'>
	]>
<xsl:transform
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsd="http://www.w3.org/2001/XMLSchema"
	xmlns:hl7v3dtMapping='urn::hl7v3dtMapping'
        xmlns:hl7="urn:hl7.org"
	xmlns:u="http://aurora.regenstrief.org/UCUM"
	xmlns:saxon="http://saxon.sf.net/"
        extension-element-prefixes="saxon"
	exclude-result-prefixes="xsd hl7 hl7v3dtMapping saxon u"
	version='2.0'>

<xsl:import href="xml-verbatim.xsl"/>
<xsl:import href="v3dt-schema.xsl"/>

<xsl:output
	method='xml'
	indent='no'
	encoding='ISO-8859-1'/>

<!--
	doctype-public='-//W3C//XML specification DTD//EN'/ -->

<xsl:strip-space elements="*"/>

<!-- As always, begin with the identity transform. -->
<xsl:template match="/|@*|node()">
  <xsl:param name='stack' select='/..'/>
  <xsl:copy>
    <xsl:apply-templates select="@*|node()">
      <xsl:with-param name='stack' select='$stack'/>
    </xsl:apply-templates>
  </xsl:copy>  
</xsl:template>

<!-- I MAY NOT NEED THIS ANY LONGER!
     Probably an error in saxon-6.5, but I get one funny text node
     a constructed table body (for comp summary CS). Text blocks
     don't have anything to do in tbodies anyway. -->
<xsl:template match="tbody">
  <xsl:copy>
    <xsl:apply-templates select="*|@*"/>
  </xsl:copy>
</xsl:template>


<!-- NON-EXCITING STUFF -->

<xsl:template match='dtimplname'>
  <emph>
    <xsl:value-of select='ancestor::dtimpl[1]/@shortname'/>
    <xsl:apply-templates/>
  </emph>
</xsl:template>

<xsl:template match='dtname'>
  <emph>
    <xsl:value-of select='ancestor::dt[1]/@shortname'/>
    <xsl:apply-templates/>
  </emph>
</xsl:template>

<xsl:template match='dtimplref' name='makedtimplref'>
  <xsl:param name='ref' select='@ref'/>
  <xsl:variable name="target" select="//dtimpl[@id=$ref]"/>
  <xsl:choose>
    <xsl:when test="self::dtimplref/node()">
      <termref ref='{$ref}'>
        <xsl:apply-templates select='node()'/>
      </termref>
    </xsl:when>
    <xsl:when test="$target/@shortname">
      <termref ref='{$ref}'>
        <xsl:value-of select="$target/@shortname"/>
      </termref>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>
        <WARNING text="Undefined reference" to="{$ref}" 
	     in="{local-name(.)}"/>
	</xsl:message>
      <xsl:value-of select="$ref"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match='dtref' name='makedtref'>
  <xsl:param name='ref' select='@ref'/>
  <xsl:variable name="target" select="//dt[@id=$ref]"/>
  <xsl:choose>
    <xsl:when test="self::dtref/node()">
      <termref ref='{$ref}'>
        <xsl:apply-templates select='node()'/>
      </termref>
    </xsl:when>
    <xsl:when test="$target/@shortname">
      <termref ref='{$ref}'>
        <xsl:value-of select="$target/@shortname"/>
      </termref>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>
        <WARNING text="Undefined reference" to="{$ref}" 
	     in="{local-name(.)}"/>
	</xsl:message>
      <xsl:value-of select="$ref"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name='dtimplRefByName'>
  <xsl:param name='name' select='/..'/>
  <xsl:param name='ref' 
      select="//schema[@id=concat('schema-',$name)]/
	           ancestor::dtimpl[1]/@id"/>
  <xsl:choose>
    <xsl:when test='$ref'>
      <termref ref="{$ref}">
        <xsl:value-of select='$name'/>
      </termref>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select='$name'/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name='DtimplRefByName'>
  <xsl:param name='name' select='/..'/>
  <xsl:param name='ref' 
      select="//schema[@id=concat('schema-',$name)]/
	           ancestor::dt[1]/@id"/>
  <xsl:choose>
    <xsl:when test='$ref'>
      <termref ref="{$ref}">
        <xsl:value-of select='$name'/>
      </termref>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select='$name'/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name='dtRefByName'>
  <xsl:param name='name' select='/..'/>
  <xsl:param name='ref' 
      select="//dt[@id=concat('dt-',$name)]/@id"/>
  <xsl:choose>
    <xsl:when test='$ref'>
      <termref ref="{$ref}">
        <xsl:value-of select='$name'/>
      </termref>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select='$name'/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name='DtRefByName'>
  <xsl:param name='name' select='/..'/>
  <xsl:param name='ref' 
      select="//dt[@id=concat('dt-',$name)]/@id"/>
  <xsl:choose>
    <xsl:when test='$ref'>
      <termref ref="{$ref}">
        <xsl:value-of select='$name'/>
      </termref>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select='$name'/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match='compref'>
  <xsl:param name='deref' select='//comp[@id=current()/@ref]'/>

  <termref ref='{@ref}'>
    <xsl:value-of select='$deref/ancestor::dtimpl[1]/@shortname'/>
    <xsl:text>.</xsl:text>
    <xsl:value-of select='$deref/@shortname'/>
  </termref>
</xsl:template>

<xsl:template match='propref'>
  <xsl:param name='deref' select='//prop[@id=current()/@ref]'/>
  <xsl:variable name="theprop">
    <xsl:apply-templates mode="inherit" select="$deref"/>
  </xsl:variable>
  <termref ref='{@ref}'>
    <xsl:value-of select='$deref/ancestor::dt[1]/@shortname'/>
    <xsl:text>.</xsl:text>
    <xsl:value-of select='$theprop/prop/@shortname'/>
  </termref>
</xsl:template>

<xsl:template match='compname'>
  <emph>
    <xsl:value-of select='ancestor::comp[1]/@shortname'/>
    <xsl:apply-templates/>
  </emph>
</xsl:template>

<xsl:template match='propname'>
  <xsl:variable name="theprop">
    <xsl:apply-templates mode="inherit" select="ancestor::prop[1]"/>
  </xsl:variable>
  <emph>
    <xsl:value-of select='$theprop/*/@shortname'/>
    <xsl:apply-templates/>
  </emph>
</xsl:template>

<xsl:template match='element'>
  XML-element <emph><xsl:apply-templates/></emph>
</xsl:template>

<xsl:template match='attr'>
  XML-attribute <emph><xsl:apply-templates/></emph>
</xsl:template>

<!-- v3pub don't want <p>s in <lists>s -->
<xsl:template match="list/p">
  <xsl:message terminate="yes">
    <ERROR text="list contains p-children!">
      <xsl:copy-of select=".."/>
    </ERROR>
  </xsl:message>
</xsl:template>

<!-- MORE INTERESTING THINGS BELOW -->

<!-- figures and UML diagrams -->
<xsl:template match="figure">
  <graphic source="graphics/{pixmap/@source}" alt="{caption}"/>
</xsl:template>
<xsl:template match="uml">
  <graphic source="graphics/{pixmap/@source}" alt="{caption}"/>
</xsl:template>

<!-- Requirement elements contain normal content that should be indented
     and given a coloured background -->

<xsl:template match='requirement'>
  <exhibit role="requirement">
      <xsl:apply-templates/><xsl:text> </xsl:text>
  </exhibit>
</xsl:template>

<!-- Example elements contain unquoted XML that is transformed
     into HTML in mode 'xml-verbatim'.
-->
<xsl:template match='example'>
  <exhibit role="example" verbatim="yes">
    <caption/>
    <xsl:apply-templates mode="xml-verbatim" select="node()"/>
  </exhibit>
</xsl:template>

<xsl:template match='template'>
  <exhibit role="template" verbatim="yes">
    <caption/>
    <pre><xsl:copy-of select="."/><xsl:text>&#10;</xsl:text></pre>
  </exhibit>
</xsl:template>

<xsl:template match='exhibit'>
  <exhibit role="exhibit">
    <xsl:apply-templates select="@*|node()"/>
  </exhibit>
</xsl:template>

<!-- The dtimpl template turns a formal dtimpl element
     into a section markup. 
-->
<xsl:template match='dtimpl'>
  <xsl:variable name='htag'>
    <xsl:choose>
      <xsl:when test='parent::div1'>div2</xsl:when>
      <xsl:when test='parent::*/parent::div1'>div3</xsl:when>
      <xsl:when test='parent::*/parent::*/parent::div1'>div4</xsl:when>
      <xsl:when test='parent::*/parent::*/parent::*/parent::div1'>div5</xsl:when>
      <xsl:otherwise>div6</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:element name='{$htag}' namespace="">
    <xsl:attribute name='id'>
      <xsl:value-of select='@id'/>
    </xsl:attribute>
    <anchor id='{@shortname}'/>
    <head>
      <xsl:value-of select='@longname'/>
      <xsl:text> (</xsl:text>
      <xsl:value-of select='@shortname'/>
      <xsl:text>)</xsl:text>
      <xsl:choose>
        <xsl:when test='@restricts'>
          <xsl:text> specializes </xsl:text><!-- YES! WE DO MEAN EXTENDS! err, specializes, now -->
          <xsl:call-template name='makedtimplref'>
	         <xsl:with-param name='ref' select='@restricts'/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test='@extends'>
          <xsl:text> specializes </xsl:text>
          <xsl:call-template name='makedtimplref'>
	    <xsl:with-param name='ref' select='@extends'/>
          </xsl:call-template>
        </xsl:when>
      </xsl:choose>
    </head>

    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<!-- The dt template turns a formal dt element
     into a section markup.
-->
<xsl:template match='dt'>
  <xsl:variable name='htag'>
    <xsl:choose>
      <xsl:when test='parent::div1'>div2</xsl:when>
      <xsl:when test='parent::*/parent::div1'>div3</xsl:when>
      <xsl:when test='parent::*/parent::*/parent::div1'>div4</xsl:when>
      <xsl:when test='parent::*/parent::*/parent::*/parent::div1'>div5</xsl:when>
      <xsl:otherwise>div6</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:element name='{$htag}' namespace="">
    <xsl:attribute name='id'>
      <xsl:value-of select='@id'/>
    </xsl:attribute>
    <anchor id='{@shortname}'/>
    <head>
      <xsl:value-of select='@longname'/>
      <xsl:text> (</xsl:text>
      <xsl:value-of select='@shortname'/>
      <xsl:text>)</xsl:text>
      <xsl:choose>
        <xsl:when test='@restricts'>
          <xsl:text> specializes </xsl:text><!-- YES IT IS EXTENDS; err, specializes, now -->
          <xsl:call-template name='makedtref'>
	         <xsl:with-param name='ref' select='@restricts'/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test='@extends'>
          <xsl:text> specializes </xsl:text>
          <xsl:call-template name='makedtref'>
	    <xsl:with-param name='ref' select='@extends'/>
          </xsl:call-template>
        </xsl:when>
      </xsl:choose>
    </head>

    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<!-- The xmlrep element interjects a subdivision for headed
     "XML Representation". This is a hack, because I have
     no idea which div# level I'm in here. I really think
     div tags should not be numbered, the xpath can figure
     it all out.
-->
<xsl:template match='xmlrep'>
  <xsl:variable name='htag'>
    <xsl:choose>
      <xsl:when test='parent::div1'>div2</xsl:when>
      <xsl:when test='parent::*/parent::div1'>div3</xsl:when>
      <xsl:when test='parent::*/parent::*/parent::div1'>div4</xsl:when>
      <xsl:when test='parent::*/parent::*/parent::*/parent::div1'>div5</xsl:when>
      <xsl:otherwise>div6</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- xsl:element name='{$htag}' namespace="" -->
    <!-- FIXME: this should really be a section, but shouldn't show
         up in the TOC -->
    <descriptive name="XML Representation"/>
    <xsl:apply-templates/>
  <!-- /xsl:element -->
</xsl:template>
<xsl:template match='xmlrep[@display = "false"]'/>

<!-- The properties element interjects a subdivision headed
     "Properties". This is a hack, because I have
     no idea which div# level I'm in here. I really think
     div tags should not be numbered, the xpath can figure
     it all out.
-->
<xsl:template match='properties'>
  <xsl:variable name='htag'>
    <xsl:choose>
      <xsl:when test='parent::div1'>div2</xsl:when>
      <xsl:when test='parent::*/parent::div1'>div3</xsl:when>
      <xsl:when test='parent::*/parent::*/parent::div1'>div4</xsl:when>
      <xsl:when test='parent::*/parent::*/parent::*/parent::div1'>div5</xsl:when>
      <xsl:otherwise>div6</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:element name='{$htag}' namespace="">
    <head>
      <xsl:text>Properties of </xsl:text>
      <xsl:value-of select='ancestor::dt[1]/@longname'/>
      <xsl:text> (</xsl:text>
      <xsl:value-of select='ancestor::dt[1]/@shortname'/>
      <xsl:text>)</xsl:text>
    </head>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>


<!-- The profiles element interjects a subdivision headed
     "Specializations". This is a hack, because I have
     no idea which div# level I'm in here. I really think
     div tags should not be numbered, the xpath can figure
     it all out.
-->
<xsl:template match='profiles'>
  <xsl:variable name='htag'>
    <xsl:choose>
      <xsl:when test='parent::div1'>div2</xsl:when>
      <xsl:when test='parent::*/parent::div1'>div3</xsl:when>
      <xsl:when test='parent::*/parent::*/parent::div1'>div4</xsl:when>
      <xsl:when test='parent::*/parent::*/parent::*/parent::div1'>div5</xsl:when>
      <xsl:otherwise>div6</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- xsl:element name='{$htag}' namespace="" -->
    <!-- FIXME: this should really be a section, but shouldn't show
         up in the TOC -->
    <!-- descriptive>
      <xsl:attribute name="name" -->
        <p><emph role="strong">
        Specializations of 
          <xsl:value-of select='ancestor::dt[1]/@longname'/>
          (<xsl:value-of select='ancestor::dt[1]/@shortname'/>)</emph></p>
      <!-- /xsl:attribute>
    </descriptive -->
    <xsl:apply-templates/>
  <!-- /xsl:element -->
</xsl:template>
	

<!-- The comp template turns a formal component definition
     into a section markup.
-->
<xsl:template match='comp'>
  <xsl:param name='htag'>
    <xsl:choose>
      <xsl:when test='parent::div1'>div2</xsl:when>
      <xsl:when test='parent::*/parent::div1'>div3</xsl:when>
      <xsl:when test='parent::*/parent::*/parent::div1'>div4</xsl:when>
      <xsl:when test='parent::*/parent::*/parent::*/parent::div1'>div5</xsl:when>
      <xsl:otherwise>div6</xsl:otherwise>
    </xsl:choose>
  </xsl:param>

  <xsl:element name='{$htag}' namespace="">
    <xsl:attribute name='id'>
      <xsl:value-of select='@id'/>
    </xsl:attribute>
    <head>
      <xsl:value-of select='@longname'/>
      <xsl:text> : </xsl:text>
      <xsl:call-template name='dtimplRefByName'>
        <xsl:with-param name='name' select='@type'/>
      </xsl:call-template>
      <xsl:if test='@default'>
        <xsl:text> (default </xsl:text>
        <emph>
          <xsl:value-of select='@default'/>
        </emph>
        <xsl:text>)</xsl:text>
      </xsl:if>
    </head>

  <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<!-- The prop template turns a formal property definition
     into a section markup.
-->
<xsl:template match='prop'>
  <xsl:param name='htag'>
    <xsl:choose>
      <xsl:when test='parent::div1'>div2</xsl:when>
      <xsl:when test='parent::*/parent::div1'>div3</xsl:when>
      <xsl:when test='parent::*/parent::*/parent::div1'>div4</xsl:when>
      <xsl:when test='parent::*/parent::*/parent::*/parent::div1'>div5</xsl:when>
      <xsl:otherwise>div6</xsl:otherwise>
    </xsl:choose>
  </xsl:param>

  <xsl:variable name="this">
    <xsl:apply-templates mode="inherit" select="."/>
  </xsl:variable>

  <xsl:element name='{$htag}' namespace="">
    <xsl:attribute name='id'>
      <xsl:value-of select='$this/prop/@id'/>
    </xsl:attribute>
    <head>
      <xsl:value-of select='$this/prop/@longname'/>
      <!-- FIXME! Cludgy, yuck! -->
      <xsl:if test="not($this/prop/@shortname='literal')">
        <xsl:text> (</xsl:text>
        <xsl:value-of select='$this/prop/@shortname'/>
        <xsl:text> : </xsl:text>
        <xsl:call-template name='DtRefByName'>
          <xsl:with-param name='name' select='$this/prop/@type'/>
        </xsl:call-template>
        <xsl:if test='$this/prop/@default'>
          <xsl:text>, default </xsl:text>
          <emph>
            <xsl:value-of select='$this/prop/@default'/>
          </emph>
        </xsl:if>
        <xsl:if test='$this/prop/inherited'>
          <xsl:text>, </xsl:text>
          <xsl:choose>
            <xsl:when test="$this/prop/@role='exclude'">
              <xsl:text>fixed</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>inherited from </xsl:text>
              <termref ref="{$this/prop/inherited/@from}">
                <xsl:value-of 
                  select="//dt[@id=$this/prop/inherited/@from]/@shortname"/>
              </termref>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
        <xsl:text>)</xsl:text>
      </xsl:if>
    </head>

  <xsl:apply-templates/>
  </xsl:element>
</xsl:template>


<!-- The component template for inherited components.
     It's possible for a comp to only refer to a base which
     is the full specification that's inherited. In this
     case we go down to the ancestor's full definition
     of the component, show the variable, and then go back
     up. The down-recursion is done in a separate mode 'base'.
     The role can be 'exclude' which will drop in another 
     schema.
-->
<xsl:template match="comp[@base]">
  <xsl:param name='done' select='/..'/>
  <xsl:param name='role' select='@role'/>
  <xsl:param name='id' select='@id'/>
  <xsl:param name='htag'>
    <xsl:choose>
      <xsl:when test='parent::div1'>div2</xsl:when>
      <xsl:when test='parent::*/parent::div1'>div3</xsl:when>
      <xsl:when test='parent::*/parent::*/parent::div1'>div4</xsl:when>
      <xsl:when test='parent::*/parent::*/parent::*/parent::div1'>div5</xsl:when>
      <xsl:otherwise>div6</xsl:otherwise>
    </xsl:choose>
  </xsl:param>

  <xsl:apply-templates select='//comp[@id=current()/@base]'
                       mode='base'>
    <xsl:with-param name='done' select='.|$done'/>
    <xsl:with-param name='role' select='$role'/>
    <xsl:with-param name='id' select='$id'/>
    <xsl:with-param name='htag' select='$htag'/>
    <xsl:with-param name='current' select='.'/>
  </xsl:apply-templates>

  <xsl:apply-templates/>
</xsl:template>

<!-- This continues the recursion up to the first definition
     of the component.
-->
<xsl:template match="comp[@base]" mode='base'>
  <xsl:param name='done' select='/..'/>
  <xsl:param name='role' select='/..'/>
  <xsl:param name='id' select='/..'/>
  <xsl:param name='htag' select='/..'/>
  <xsl:param name='current' select='.'/>

  <xsl:choose>
    <xsl:when test='$done[@id=current()/@id]'>
      <xsl:message terminate='yes'>
        <xsl:text>CIRCULAR REFERENCE THROUGH </xsl:text>
        <xsl:value-of select='@id'/>
      </xsl:message>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select='//comp[@id=current()/@base]'
                           mode='base'>
        <xsl:with-param name='done' select='.|$done'/>
        <xsl:with-param name='role' select='$role'/>
        <xsl:with-param name='id'   select='$id'/>
        <xsl:with-param name='htag' select='$htag'/>
	<xsl:with-param name='current' select='.'/>
      </xsl:apply-templates>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- This terminates the up-recursion chasing the final base
     of the component. 
-->
<xsl:template match='comp' mode='base'>
  <xsl:param name='role' select='/..'/>
  <xsl:param name='id' select='@id'/>
  <xsl:param name='htag' select='/..'/>
  <xsl:param name='current' select='.'/>

  <xsl:element name='{$htag}' namespace="">
    <xsl:attribute name='id'>
      <xsl:value-of select='$id'/>
    </xsl:attribute>
    <anchor id='{$current/@shortname}'/>
    <head>
      <xsl:value-of select='@longname'/>
      <xsl:text> : </xsl:text>
      <xsl:call-template name='dtimplRefByName'>
        <xsl:with-param name='name' select='@type'/>
      </xsl:call-template>
      <xsl:if test='@default'>
        <xsl:text> (default </xsl:text>
        <emph>
          <xsl:value-of select='@default'/>
        </emph>
        <xsl:text>)</xsl:text>
      </xsl:if>
      <xsl:text> (</xsl:text>
      <xsl:choose>
        <xsl:when test="$role='exclude'">
          <xsl:text>fixed</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>inherited from </xsl:text>
          <termref ref='{ancestor::dtimpl[1]/@id}'>
            <xsl:value-of select='ancestor::dtimpl[1]/@shortname'/>
          </termref>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>)</xsl:text>
    </head>

    <xsl:apply-templates select='definition'/>
  </xsl:element>
</xsl:template>

<!-- Don't show a section for the inherited attributes that
     don't add anything. 
-->
<xsl:template match="comp[@base and not(node())]" 
	      priority='1'>
</xsl:template>

<!-- NOW THE SAME FOR PROPERTIES -->
<!-- REDESIGN! SEPARATION OF CONCERNS IS VIOLATED, so we can't 
     reuse this code. What if all I want is to get to all the 
     inherited attributes and content without producing the v3pub
     output? 

     GS TODO: do this for comp as well?

     Simply construct an element as the union of the inherited
     element and this element with this element's attributes
     overriding the inherited attributes. The parent element is
     expanded in a nodes named <inherits>, so one can inspect
     the ancestry tree.
-->
<xsl:template match="prop[@base]|comp[@base]" mode="inherit">
  <xsl:param name="done" select="/.."/>
  <xsl:choose>
    <xsl:when test='$done[@id=current()/@id]'>
      <xsl:message terminate='yes'>
        <xsl:text>CIRCULAR REFERENCE THROUGH </xsl:text>
        <xsl:value-of select='@id'/>
      </xsl:message>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="last">
        <xsl:apply-templates select='//*[name(.)=name(current())
                                     and @id=current()/@base]'
                             mode='inherit'>
          <xsl:with-param name='done' select='.|$done'/>
        </xsl:apply-templates>
      </xsl:variable>
      <xsl:copy>
        <xsl:copy-of select="$last/*/@*"/>
        <xsl:copy-of select="@*"/>
        <xsl:attribute name="for">
          <xsl:value-of select="(ancestor::dt|ancestor::dtimpl)/@id"/>
        </xsl:attribute>
	<inherited from="{$last/*/@for}">
	  <xsl:copy-of select="$last/*/@*"/>
	  <xsl:copy-of select="$last/*/node()"/>	
	</inherited>
        <xsl:copy-of select="node()"/>
      </xsl:copy>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- This terminates the up-recursion chasing the final base
     of the component. 
-->
<xsl:template match="prop|comp" mode="inherit">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:attribute name="for">
      <xsl:value-of select="(ancestor::dt|ancestor::dtimpl)/@id"/>
    </xsl:attribute>
    <xsl:copy-of select="node()"/>
  </xsl:copy>
</xsl:template>

<!-- GUNTHER'S ADDITIONS -->

<xsl:template match='constraint'>
  <xsl:apply-templates select='node()'/>
</xsl:template>

<xsl:template match='definition'>
  <p>
    <emph role="strong">Definition:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</emph>
    <xsl:apply-templates select="@*|node()"/>
  </p>
</xsl:template>

<xsl:template match='hide'/>

<xsl:template match="sub">
  <emph role="sub"><xsl:apply-templates select="@*|node()"/></emph>
</xsl:template>

<xsl:template match="sup">
  <emph role="sup"><xsl:apply-templates select="@*|node()"/></emph>
</xsl:template>

<xsl:template match="var">
  <emph><xsl:apply-templates select="@*|node()"/></emph>
</xsl:template>
<xsl:template match="v">
  <emph><xsl:apply-templates select="@*|node()"/></emph>
</xsl:template>
<xsl:template match="sys">
  <emph role="strong"><xsl:apply-templates select="@*|node()"/></emph>
</xsl:template>
<xsl:template match="dim">
  <emph role="emph"><xsl:apply-templates select="@*|node()"/></emph>
</xsl:template>
<xsl:template match="i">
  <emph><xsl:apply-templates select="@*|node()"/></emph>
</xsl:template>
<xsl:template match="un">
  <emph role="strong"><xsl:apply-templates select="@*|node()"/></emph>
</xsl:template>
<xsl:template match="lit">
  <emph role="strong"><xsl:apply-templates select="@*|node()"/></emph>
</xsl:template>
<xsl:template match="vec[text()='u']">
  <emph>&#xfb;</emph>
</xsl:template>
<xsl:template match="sym[@name]">
  <xsl:text>&lt;</xsl:text>
  <emph><xsl:value-of select="@name"/></emph>
  <xsl:text>&gt;</xsl:text>
</xsl:template>
<xsl:template match="lit[@value]">
  <xsl:text>&ldquo;</xsl:text>
  <code><xsl:value-of select="@value"/></code>
  <xsl:text>&rdquo;</xsl:text>
</xsl:template>
<xsl:template match="prod">
   <emph role="strong"><xsl:text>&Pi;</xsl:text></emph><xsl:apply-templates select="@*|node()"/>
</xsl:template>
<xsl:template match="prod/@from">
   <emph role="sub"><xsl:value-of select="."/></emph>
</xsl:template>
<xsl:template match="prod/@to">
   <emph role="sup"><xsl:value-of select="."/></emph>
</xsl:template>

<xsl:template match="strong">
  <emph role="strong"><xsl:apply-templates select="@*|node()"/></emph>
</xsl:template>

<!-- A DTDL fragment rendered in the document. 
-->
<xsl:template match='dtdl'>
  <xsl:param name='id' select='@id'/>

  <exhibit role='dtdl'>
    <xsl:if test='$id'>
      <xsl:attribute name='id'>
        <xsl:value-of select='$id'/>
      </xsl:attribute>
      <anchor id="{$id}"/>  <!-- FIXME: this is just a hack -->
    </xsl:if>
    <caption/>
    <pre><xsl:apply-templates select="node()"/></pre>
  </exhibit>
</xsl:template>

<!-- A DTDL fragment that is copy/pasted from its generalization
     data type.
-->
<xsl:template match='dtdl[@base]'>
  <xsl:param name='done' select='/..'/>
  <xsl:param name='id' select='@id'/>

  <xsl:choose>
    <xsl:when test='$done[@id=current()/@id]'>
      <xsl:message terminate='yes'>
        <xsl:text>CIRCULAR REFERENCE THROUGH </xsl:text>
        <xsl:value-of select='@id'/>
      </xsl:message>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select='//dtdl[@id=current()/@base]'>
        <xsl:with-param name='done' select='.|$done'/>
        <xsl:with-param name='id' select='$id'/>
      </xsl:apply-templates>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>



<!-- A schema fragment rendered in the document. 
-->
<xsl:template match='schema[@hide]' priority="5"/>

<xsl:template match='schema'/>
<!--
  <xsl:param name='id' select='@id'/>

  <exhibit role="schema" verbatim="yes">
    <xsl:if test='$id'>
      <xsl:attribute name='id'>
        <xsl:value-of select='$id'/>
      </xsl:attribute>
      <anchor id="{$id}"/>
    </xsl:if>
    <caption/>
    <xsl:apply-templates mode="xml-verbatim" select="node()"/>
  </exhibit>
</xsl:template>
-->

<!-- A schema fragment that is copy/pasted from its generalization
     data type.
-->
<xsl:template match='schema[@base or @copy-from]'/>
<!--
  <xsl:param name='done' select='/..'/>
  <xsl:param name='id' select='@id'/>
  <xsl:param name='base' select='@base|@copy-from'/>

  <xsl:choose>
    <xsl:when test='$done[@id=current()/@id]'>
      <xsl:message terminate='yes'>
        <xsl:text>CIRCULAR REFERENCE THROUGH </xsl:text>
        <xsl:value-of select='@id'/>
      </xsl:message>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select='//schema[@id=$base]'>
        <xsl:with-param name='done' select='.|$done'/>
        <xsl:with-param name='id' select='$id'/>
      </xsl:apply-templates>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
-->

<xsl:template match='xpath-constraint'/>
<!--  <xsl:apply-templates select='node()'/>

  <exhibit role='schema' verbatim="yes">
    <caption/>
    <xsl:variable name="schemaconstraint">
      <xsl:apply-templates mode="raw" select="."/>
    </xsl:variable>
    <xsl:apply-templates mode="xml-verbatim" select="$schemaconstraint/node()"/>
  </exhibit>
</xsl:template>
-->

<!-- ADDON TO THE xml-verbatim MODE (see xml-verbatim.xsl) -->

<!-- An ellipsis in a fragment is rendered in the document
     as an abbreviated tag with some "...". 
-->
<!-- Ellipsis without references shouldn't exist, but you never
     know what's comming, so here is one with a straight "..."
     look. --> 
<xsl:template match='ellipsis' mode='xml-verbatim'>
  <xsl:param name="indent" select="''" />
  <br/><xsl:value-of select="$indent"/><xsl:text>...</xsl:text>
</xsl:template>

<!-- Some ellipsis may just have child ellipses. If it also has
     a @ref attribute, the next rule should take over. --> 
<xsl:template match='ellipsis[child::ellipsis]' mode='xml-verbatim'>
  <xsl:param name="indent" select="''" />
  <xsl:apply-templates mode="xml-verbatim" select="node()">
    <xsl:with-param name="indent" select="$indent" />
  </xsl:apply-templates>
</xsl:template>

<!-- Ellipses with a @ref: this is the normal case. Here we
     dereference the @ref and unwrap the schema container.
     The content of the schema fragment will be transformed in
     ellipsis mode. --> 
<xsl:template match='ellipsis[@ref]' priority='1' mode='xml-verbatim'>
  <xsl:param name="indent" select="''" />
  <xsl:apply-templates select='//schema[@id=current()/@ref]/*' 
                       mode="ellipsis">
    <xsl:with-param name="indent" select="$indent" />
  </xsl:apply-templates>
  <xsl:apply-templates mode="xml-verbatim" select="node()">
    <xsl:with-param name="indent" select="$indent" />
  </xsl:apply-templates>
</xsl:template>

<!-- Most ellipses are for elements and attributes of which we
     will show name and type only. -->
<xsl:template match='xsd:element|xsd:attribute' mode='ellipsis'>
  <xsl:param name="indent" select="''" />
  <br/><xsl:value-of select='$indent'/>
  <span class="{local-name(.)}">
    <xsl:text>&lt;</xsl:text>   
    <xsl:variable name="ns-prefix" select="substring-before(name(),':')" />
    <xsl:if test="$ns-prefix != ''">
      <span class="xml-verbatim-element-nsprefix">
	 <xsl:value-of select="$ns-prefix" />
      </span>
      <xsl:text>:</xsl:text>
    </xsl:if>
    <span class="xml-verbatim-element-name">
       <xsl:value-of select="local-name()" />
    </span>
    <xsl:for-each select="@name|@type|@ref">
      <xsl:call-template name="xml-verbatim-attrs" />
    </xsl:for-each>
    <xsl:text> </xsl:text>
    <!-- termref ref="{../@id}" -->
    <a class="termref" href="#{../@id}">
      <xsl:choose>
        <xsl:when test="ancestor::node()/@role='exclude'">
          <emph>EXCLUDED</emph></xsl:when>
        <xsl:otherwise>...</xsl:otherwise>
      </xsl:choose>
    </a>
    <!-- /termref -->
    <xsl:text> /&gt;</xsl:text>
  </span>
</xsl:template>

<!-- Required links in schema fragments are never shown -->
<xsl:template match="schema/requires"/>
<xsl:template match="schema/requires" mode="verbatim" priority='1'/>
<xsl:template match="schema/requires" mode="xml-verbatim" priority='1'/>
<xsl:template match="schema//comment()" mode="xml-verbatim" priority='1'/>
<xsl:template match="schema//text()[normalize-space()='']" 
           mode="xml-verbatim" priority='1'/>
<xsl:template match="xsd:schema//text()[normalize-space()='']" 
           mode="xml-verbatim" priority='1'/>
<xsl:template match="xsd:schema//comment()" mode="xml-verbatim" priority='1'/>
<xsl:template match="/comment()" mode="xml-verbatim" priority='1'/>
<xsl:template match='requires' mode='ellipsis'/>

<!-- Those things that we don't understand get replaced by
     the form "<{name} .../> -->
<xsl:template match='*' mode='ellipsis'>
  <xsl:param name="indent" select="''" />
  <br/><xsl:value-of select='$indent'/>
  <span class="{local-name(.)}">
    <xsl:text>&lt;</xsl:text>   
    <xsl:variable name="ns-prefix" select="substring-before(name(),':')" />
    <xsl:if test="$ns-prefix != ''">
      <span class="xml-verbatim-element-nsprefix">
	 <xsl:value-of select="$ns-prefix" />
      </span>
      <xsl:text>:</xsl:text>
    </xsl:if>
    <span class="xml-verbatim-element-name">
       <xsl:value-of select="local-name()" />
    </span>
    <xsl:text> </xsl:text>
    <!-- termref ref="{../@id}" -->
    <a class="termref" href="#{../@id}">
      <xsl:choose>
        <xsl:when test="ancestor::node()/@role='exclude'">
          <emph>EXCLUDED</emph></xsl:when>
        <xsl:otherwise>...</xsl:otherwise>
      </xsl:choose>
    </a>
    <!-- /termref -->
    <xsl:text> /&gt;</xsl:text>
  </span>
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

<!-- MAGIC TAGS -->

<!-- ASSEMBLE COMPLETE SCHEMA -->

<!-- This uses the main transformation to generate a complete 
     schema from all the fragments
-->
<xsl:template match="assemble-complete-schema">
  <xsl:variable name='schema'>
    <xsl:for-each select="/">
      <xsl:call-template name='assemble-complete-schema'/>
    </xsl:for-each>
  </xsl:variable>
  <exhibit role='schema' label="Complete Schema" verbatim="yes">
    <caption/>
    <xsl:apply-templates select='$schema' mode='xml-verbatim'/>
  </exhibit>
</xsl:template>

<xsl:template match="assemble-complete-dtdl">
  <xsl:variable name='frags'>
    <xsl:apply-templates select="//dtdl[not(@include='no')]" 
                         mode='collect'/>
  </xsl:variable>
  
  <xsl:variable name='dtdl'>
    <xsl:call-template name='apply-unique'>
      <xsl:with-param name='todo' select='$frags/*'/>
    </xsl:call-template>
  </xsl:variable>
  
  <exhibit role='dtdl' label='Complete Formal Data Type Definition'>
    <caption/>
    <code>
      <xsl:apply-templates select='$dtdl' mode='xml-verbatim'/>
    </code>
  </exhibit>
</xsl:template>

<!-- AUTO GENERATED SUMMARY TABLES -->

<!-- dtimpls -->

<xsl:template match='dtimpl-summary-table'>
  <table id='dtimpl-summary-table'>
    <caption>
       Overview of HL7 version 3 data types
    </caption>
    <col width="79"/>
    <col width="60"/>
    <col width="413"/>
    <thead>
      <tr>
        <th>Name</th>
	<th>Symbol</th>          
	<th>Description</th>
      </tr>
    </thead>
    <tbody>
      <xsl:apply-templates select='//dtimpl' mode='summary'/>
    </tbody>
  </table>  
</xsl:template>

<xsl:template match="dtimpl[not(ancestor::hide)]" mode='summary'>
  <tr>
    <td>
      <xsl:value-of select='@longname'/>
    </td>
    <td>
      <termref ref="{@id}"><xsl:value-of select='@shortname'/></termref>
    </td>
    <td>
      <xsl:apply-templates select='definition/node()'/>
    </td>
  </tr>
</xsl:template>

<!-- dts -->

<xsl:template match='dt-summary-table'>
  <table id='dt-summary-table'>
    <caption>
       Overview of HL7 version 3 data types
    </caption>
    <col width="79"/>
    <col width="60"/>
    <col width="413"/>
    <thead>
      <tr>
        <th>Name</th>
	<th>Symbol</th>          
	<th>Description</th>
      </tr>
    </thead>
    <tbody>
      <xsl:apply-templates select='//dt' mode='summary'/>
    </tbody>
  </table>  
</xsl:template>

<xsl:template match="dt[not(ancestor::hide)
                    and @access='public'
	            and not(@list='no')]" mode='summary'>
  <xsl:if test="not(@longname)">
    <xsl:message terminate="yes">
      <ERROR line="{saxon:line-number()}" path="{saxon:path()}">
        <xsl:copy-of select="."/>
      </ERROR>
    </xsl:message>
  </xsl:if>
  <tr>
    <td>
      <xsl:value-of select='@longname'/>
    </td>
    <td>
      <termref ref="{@id}"><xsl:value-of select='@shortname'/></termref>
    </td>
    <td>
      <xsl:apply-templates select='definition/node()'/>
    </td>
  </tr>
</xsl:template>

<!-- comps -->

<!-- 
     FIXME, this may not work right for nested dtimpls (which, however,
     we don't use anymore.)
-->
<xsl:template match='dtimpl//comp-summary-table'>
  <xsl:variable name='thedtimpl' select='ancestor::dtimpl'/>
  <table id="{concat($thedtimpl/@id,'-comp-summary')}">
    <caption>Components of
      <xsl:value-of select="$thedtimpl/@longname"/>
    </caption>
    <col width="79"/>
    <col width="60"/>
    <col width="413"/>
    <thead>
      <tr>
        <th>Name</th>
	<th>Type</th>
	<th>Description</th>
      </tr>
    </thead>
    <tbody>
      <xsl:apply-templates select='$thedtimpl/comp' mode='summary'/>
    </tbody>
  </table>  
</xsl:template>

<xsl:template match="comp[not(ancestor::hide)
                      and not(@role='exclude')]" mode='summary'>
  <xsl:param name="current" select="current()"/>
  <tr>
    <td>
      <termref ref="{$current/@id}">
        <xsl:value-of select='@shortname'/>
      </termref>
    </td>
    <td>
      <xsl:call-template name='dtimplRefByName'>
        <xsl:with-param name='name' select='$current/@type|@type'/>
      </xsl:call-template>
    </td>
    <td>
      <xsl:apply-templates select='definition/node()'/>
    </td>
  </tr>
</xsl:template>

<xsl:template match="comp[@base
                      and not(ancestor::hide) 
                      and not(@role='exclude')]" 
              mode='summary' priority='1'>
  <xsl:param name="current" select="current()"/>
  <xsl:apply-templates select='//comp[@id=current()/@base]' mode='summary'>
    <xsl:with-param name="current" select="$current"/>
  </xsl:apply-templates>
</xsl:template>


<!-- I don't really like to put document text into the style 
     sheet, but for now this is it.
-->
<xsl:template match='standard-fixed-attr'>
  <p>
	This component is inherited from the generalization of this data type
    but does not appear in the XML representation of this data type.
<!--
    This attribute is inherited from a generalization data type
    but its use in this specialization is constrained to
    a particular value. This value is allowed to be represented
    in the instance, but applications are encouraged not to
    use it, and prohibited from requiring this attribute to be present
    in the instance
-->
    <xsl:apply-templates/>
  </p>
</xsl:template>

<xsl:template match='standard-exclude-text'>
  <p>
	This component is inherited from the generalization of this data type
    but does not appear in the XML representation of this data type.
<!--
    This component is inherited from a generalization data type
    but its use in this specialization is constrained in such
    a fashion that it cannot be represented in this message.
-->
    <xsl:apply-templates/>
  </p>
</xsl:template>


<!-- props -->

<!-- works with nested dts again. -->
<xsl:template match='prop-summary-table'>
  <xsl:variable name='thedt' select='ancestor::dt[1]'/>
  <table id="{concat($thedt/@id,'-prop-summary')}">
    <caption>Property Summary of
      <xsl:value-of select="$thedt/@longname"/>
    </caption>
    <col width="79"/>
    <col width="60"/>
    <col width="413"/>
    <thead>
      <tr>
        <th>Name</th>
	<th>Type</th>
	<th>Description</th>
      </tr>
    </thead>
    <tbody>
      <xsl:apply-templates
     select="($thedt|$thedt/properties)/prop" mode="summary"/>
    </tbody>
  </table>  
</xsl:template>

<xsl:template match="prop[not(ancestor::hide)
                      and not(@role='exclude')
                      and not(@shortname='literal')
                      and not(argument)
                      and not(@status='operation')]" mode='summary'>
  <xsl:param name="current" select="current()"/>
  <tr>
    <td>
      <termref ref="{$current/@id}">
        <xsl:value-of select='@shortname'/>
      </termref>
    </td>
    <td>
      <xsl:call-template name='dtRefByName'>
        <xsl:with-param name='name' select='$current/@type|@type'/>
      </xsl:call-template>
    </td>
    <td>
      <xsl:apply-templates select='definition/node()'/>
    </td>
  </tr>
</xsl:template>

<xsl:template match="prop[@base
                      and not(ancestor::hide)
                      and not(@role='exclude')]" 
              mode='summary' priority='1'>
  <xsl:param name="current" select="current()"/>
  <xsl:apply-templates select='//prop[@id=current()/@base]' mode='summary'>
    <xsl:with-param name="current" select="$current"/>
  </xsl:apply-templates>
</xsl:template>

<!-- forgot to say, mode summary shall be a shallow null transform -->
<xsl:template mode="summary" match="/|@*|node()"/>

<!-- GENERATE VOCABULARY TABLES: 

   This gets the table from the official Vocabulary.xml file but then
   uses additional information provided in the <domain> element to 
   sort the codes differently or do other customization.

   The strategy is that we first work though all the <entry> elements,
   that can be nested and at the end of every node include those 
   elements that are in the official vocabulary (unless explicitly
   disabled.) - that last thing is the hard part, so I just only
   show the stuff in the entry elements.

   Every entry element must be in the official vocabulary and every
   entry element must be in a conformant topological order, i.e., 
   if an entry has a parent, that parent must be an ancestor in the 
   official vocabulary.

   Since we need to reuse this in generating CS enumeration lists,
   we will run a two-pass approach. First we make a domain/entry...
   structure that is validated and completed with codes, print names
   and definitions and then we crank out the table.
-->
<xsl:template match="domain[@table]">
  <xsl:variable name="domainFixedAndChecked">
    <xsl:apply-templates mode="fix-and-check-domain" select="."/>    
  </xsl:variable>
  <xsl:apply-templates mode="make-domain-table" 
     select="$domainFixedAndChecked"/>
</xsl:template>


<!-- MODE: FIX AND CHECK DOMAIN -->

<!-- Deep identity transform. -->
<xsl:template mode="fix-and-check-domain" match="/|@*|node()">
  <xsl:param name="data" select="/.."/>
  <xsl:copy>
    <xsl:apply-templates mode="fix-and-check-domain" select="@*|node()">
      <xsl:with-param name="data" select="$data"/>
    </xsl:apply-templates>
  </xsl:copy>
</xsl:template>

<xsl:template mode="fix-and-check-domain" match="domain">
  <xsl:variable name="data"
    select="document('Vocabulary.xml')//vocSet[@name=current()/@table][1]"/>
  <xsl:if test="not($data) and not(@override='graft')">
    <xsl:message terminate="no">
      <WARNING text="Undefined domain table reference">
        <xsl:copy-of select="."/>
      </WARNING>
    </xsl:message>
  </xsl:if>
  <xsl:copy>
    <xsl:apply-templates mode="fix-and-check-domain" select="@*">
      <xsl:with-param name="data" select="$data"/>
    </xsl:apply-templates>
    <definition>
      <xsl:text>Domain </xsl:text>
      <xsl:value-of select="@table"/>
      <xsl:text>: </xsl:text>
      <xsl:copy-of select="$data/vocSet/p[1]/node()"/>
    </definition>
    <xsl:apply-templates mode="fix-and-check-domain" select="node()">
      <xsl:with-param name="data" select="$data"/>
    </xsl:apply-templates>
  </xsl:copy>
</xsl:template>

<!-- We allow switching tables, this only deals with interim messup in 
     the vocab model and tables -->
<xsl:template mode="fix-and-check-domain" priority="1"
     match="entry[@code and @from]">
  <xsl:variable name="data"
    select="document('Vocabulary.xml')//vocSet[@name=current()/@from][1]"/>
  <xsl:if test="not($data)">
    <xsl:message terminate="no">
      <WARNING text="Undefined domain table reference">
        <xsl:copy-of select="."/>
      </WARNING>
    </xsl:message>
  </xsl:if>
  <xsl:variable name="entryWithoutFrom">
    <xsl:copy>
      <xsl:copy-of select="@*[not(local-name(.)='from')]"/>
      <xsl:copy-of select="node()"/>
    </xsl:copy>
  </xsl:variable>
  <xsl:apply-templates mode="fix-and-check-domain"
      select="$entryWithoutFrom">
    <xsl:with-param name="data" select="$data"/>
  </xsl:apply-templates>
</xsl:template>

<!-- A simple entry must be listed in the table we're in -->
<xsl:template mode="fix-and-check-domain" match="entry[@code]">
  <xsl:param name="data" select="/.."/>
  <xsl:call-template name="fix-and-check-domain-apply-entry">
    <xsl:with-param name="vocentry"
        select="$data//*[@Code=current()/@code][1]"/>
    <xsl:with-param name="data" select="$data"/>
  </xsl:call-template>
</xsl:template>

<!-- A nested entry must have its parent entry as an ancestor in 
     the official tables -->
<xsl:template mode="fix-and-check-domain" priority="0.8"
     match="entry[@code and not(@override='topology')]/entry[@code]">
  <xsl:param name="data" select="/.."/>
  <xsl:call-template name="fix-and-check-domain-apply-entry">
    <xsl:with-param name="vocentry"
      select="$data//*[@Code=current()/@code
                   and ancestor::*[@Code=current()/../@code]][1]"/>
    <xsl:with-param name="data" select="$data"/>
  </xsl:call-template>
</xsl:template>

<!-- or A nested entry must have its parent domain as an ancestor in 
     the official tables -->
<xsl:template mode="fix-and-check-domain" priority="0.8"
     match="entry[@domain and not(@override='topology')]/entry[@code]">
  <xsl:param name="data" select="/.."/>
  <xsl:call-template name="fix-and-check-domain-apply-entry">
    <xsl:with-param name="vocentry"
      select="$data//*[@Code=current()/@code
                   and ancestor::*[@name=current()/../@domain]][1]"/>
    <xsl:with-param name="data" select="$data"/>
  </xsl:call-template>
</xsl:template>

<!-- or A nested abstract entry must have its parent domain as an 
     ancestor in the official tables -->
<xsl:template mode="fix-and-check-domain" priority="0.8"
     match="entry[@domain and not(@override='topology')]/entry[@domain]">
  <xsl:param name="data" select="/.."/>
  <xsl:call-template name="fix-and-check-domain-apply-entry">
    <xsl:with-param name="vocentry"
      select="$data//*[@name=current()/@domain
                   and ancestor::*[@name=current()/../@domain]][1]"/>
    <xsl:with-param name="data" select="$data"/>
  </xsl:call-template>
</xsl:template>

<!-- or A nested abstract entry must have its parent code as an 
     ancestor in the official tables -->
<xsl:template mode="fix-and-check-domain" priority="0.8"
     match="entry[@code and not(@override='topology')]/entry[@domain]">
  <xsl:param name="data" select="/.."/>
  <xsl:call-template name="fix-and-check-domain-apply-entry">
    <xsl:with-param name="vocentry"
      select="$data//*[@name=current()/@domain
                   and ancestor::*[@Code=current()/../@code]][1]"/>
    <xsl:with-param name="data" select="$data"/>
  </xsl:call-template>
</xsl:template>

<!-- custom-heading/entry elements are different, don't check those -->
<xsl:template mode="fix-and-check-domain" priority="1"
       match="entry[ancestor::custom-heading or not(@code)]">
  <xsl:param name="data" select="/.."/>
  <xsl:copy>
    <xsl:apply-templates mode="fix-and-check-domain" select="@*|node()">
      <xsl:with-param name="data" select="$data"/>
    </xsl:apply-templates>
  </xsl:copy>
</xsl:template>

<!-- named template, called with entry being the current node -->
<xsl:template name="fix-and-check-domain-apply-entry">
  <xsl:param name="data" select="/.."/>
  <xsl:param name="vocentry" select="/.."/>
  <xsl:if test="not($vocentry) and not(@override='graft')">
    <xsl:message terminate="no">
      <WARNING text="Non-existing code or topology mismatch">
         <xsl:copy-of select="."/>
	 <!-- DEBUG>
           <xsl:copy-of select="$data"/>
	 </DEBUG -->
      </WARNING>
    </xsl:message>
  </xsl:if>
  <xsl:copy>
    <xsl:attribute name="code">
      <xsl:value-of select="$vocentry/@Code"/>
    </xsl:attribute>
    <xsl:attribute name="printName">
      <xsl:value-of select="$vocentry/@printName"/>
    </xsl:attribute>
    <xsl:attribute name="appliesTo">
      <xsl:value-of select="$vocentry/@appliesTo"/>
    </xsl:attribute>
    <xsl:attribute name="howToApply">
      <xsl:value-of select="$vocentry/@howToApply"/>
    </xsl:attribute>
    <xsl:apply-templates mode="fix-and-check-domain" select="@*">
      <xsl:with-param name="data" select="$data"/>
    </xsl:apply-templates>
    <xsl:if test="$vocentry and not(definition)"> 
      <definition>
        <xsl:copy-of select="$vocentry/p[1]/node()"/>
      </definition>
    </xsl:if>
    <xsl:apply-templates mode="fix-and-check-domain" select="node()">
      <xsl:with-param name="data" select="$data"/>
    </xsl:apply-templates>
  </xsl:copy>
</xsl:template>

<xsl:template mode="fix-and-check-domain" 
   match="definition[not(@override) 
          and not(ancestor-or-self::*/@override='graft')
          and not(ancestor-or-self::*/@override='definition')]">
  <xsl:message terminate="no">
    <WARNING text="Attempt to implicitly override definition">
       <xsl:copy-of select="../@*"/>
       <xsl:copy-of select="."/>
    </WARNING>
  </xsl:message>
</xsl:template>


<!-- MAKE DOMAIN TABLE, run this only with a fixed and checked
     domain/element... structure! -->
<!-- deep null transform -->
<xsl:template mode="make-domain-table" match="/|@*|node()">
  <xsl:param name="indent" select="''"/>
  <xsl:apply-templates mode="make-domain-table" select="@*|node()">
    <xsl:with-param name="indent" select="$indent"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template mode="make-domain-table" match="domain">
  <xsl:param name="indent" select="''"/>
  <table id='domain-{@table}'>
    <caption><xsl:copy-of select="definition/node()"/></caption>
    <thead>
      <tr valign="bottom">
        <th>code</th>
	<xsl:if test="not(ancestor-or-self::table/@hidename)">
	  <th>name</th>
	</xsl:if>
        <th>definition</th>
      </tr>
    </thead>
    <xsl:apply-templates mode="make-domain-table">
      <xsl:with-param name="indent" select="$indent"/>
    </xsl:apply-templates>
  </table>
</xsl:template>

<xsl:template mode="make-domain-table" match="domain[child::custom-heading]">
  <xsl:param name="indent" select="''"/>
  <table id='domain-{@table}'>
    <caption><xsl:copy-of select="definition/node()"/></caption>
    <thead>
      <tr valign="bottom">
	<xsl:for-each select="custom-heading/*">
          <th>
	    <xsl:if test="@width">
	      <xsl:attribute name="width">
	        <xsl:value-of select="@width"/>
              </xsl:attribute>
	    </xsl:if>
	    <xsl:value-of select="@th"/>
	  </th>
	</xsl:for-each>
      </tr>
    </thead>
    <tbody>
      <xsl:apply-templates mode="make-domain-table-custom">
        <xsl:with-param name="indent" select="$indent"/>
      </xsl:apply-templates>
    </tbody>
  </table>
</xsl:template>

<xsl:template mode="make-domain-table"  priority="2" match="entry[@code]">
  <xsl:param name="indent" select="''"/>
  <tr valign="top">
    <td>
       <xsl:value-of select="$indent"/>
       <xsl:value-of select="@code"/>
    </td>
    <xsl:if test="not(ancestor-or-self::table/@hidename)">
      <td><xsl:value-of select="@printName"/></td>
    </xsl:if>
    <td><xsl:copy-of select="definition/node()"/></td>
  </tr>
  <xsl:apply-templates mode="make-domain-table">
    <xsl:with-param name="indent" select="concat($indent,'&nbsp;&nbsp;')"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template mode="make-domain-table" priority="1" 
    match="entry[definition/node()]">
  <xsl:param name="indent" select="''"/>
  <tr valign="top">
    <th colspan="3">
      <xsl:value-of select="$indent"/>
      <xsl:copy-of select="definition/node()"/>
    </th>
  </tr>
  <xsl:apply-templates mode="make-domain-table">
    <xsl:with-param name="indent" select="concat($indent,'&nbsp;&nbsp;')"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template mode="make-domain-table" match="entry[@printName]">
  <xsl:param name="indent" select="''"/>
  <tr valign="top">
    <th colspan="3">
      <xsl:value-of select="$indent"/>
      <xsl:value-of select="@printName"/>
    </th>
  </tr>
  <xsl:apply-templates mode="make-domain-table">
    <xsl:with-param name="indent" select="concat($indent,'&nbsp;&nbsp;')"/>
  </xsl:apply-templates>
</xsl:template>

<!-- MAKE-DOMAIN-TABLE-CUSTOM creates a domain table with custom
     format, extensions, etc. -->
<!-- deep null-transform -->
<xsl:template mode="make-domain-table-custom" match="/|@*|node()">
  <xsl:apply-templates mode="make-domain-table-custom" select="@*|node()"/>
</xsl:template>
<xsl:template mode="make-domain-table-custom" match="custom-heading"/>

<!-- a table may consist of tuple where we have multiple elements
     per row -->
<xsl:template mode="make-domain-table-custom" match="tuple">
  <tr valign="top">
    <xsl:apply-templates mode="make-domain-table-custom-tuple"
              select="ancestor::domain/custom-heading/*">
      <xsl:with-param name="tuple" select="."/>
    </xsl:apply-templates>
  </tr>
</xsl:template>

<!-- or the table row may be represented by just one entry element
     with custom properties in the attributes -->
<xsl:template mode="make-domain-table-custom" match="entry">
  <xsl:param name="indent" select="''"/>
  <tr valign="top">
    <xsl:apply-templates mode="make-domain-table-custom-tuple"
              select="ancestor::domain/custom-heading/*">
      <xsl:with-param name="tuple">
        <xsl:copy-of select="."/>
      </xsl:with-param>
      <xsl:with-param name="indent" select="$indent"/>
    </xsl:apply-templates>
  </tr>
  <xsl:apply-templates mode="make-domain-table-custom" select="entry">
    <xsl:with-param name="indent" select="concat($indent,'&nbsp;&nbsp;')"/>
  </xsl:apply-templates>
</xsl:template>

<!-- MAKE-DOMAIN-TABLE-CUSTOM-TUPLE creates one row of a custom domain 
     table using the custom-header as a template. This is non-
     recursive. -->
<xsl:template mode="make-domain-table-custom-tuple" 
     match="*[@position and @attribute]">
  <xsl:param name="tuple" select="/.."/>
  <xsl:param name="indent" select="''"/>
  <td>
    <xsl:if test="@indent='yes'">
      <xsl:value-of select="$indent"/>
    </xsl:if>
    <xsl:value-of select="$tuple/*[name(.)=name(current()) 
                              and position()=current()/@position]
                               /@*[name(.)=current()/@attribute]"/>
    <xsl:text>&nbsp;</xsl:text>
  </td>
</xsl:template>

<xsl:template mode="make-domain-table-custom-tuple" 
     match="*[@position and @element]">
  <xsl:param name="tuple" select="/.."/>
  <xsl:param name="indent" select="''"/>
  <td>
    <xsl:if test="@indent='yes'">
      <xsl:value-of select="$indent"/>
    </xsl:if>
    <xsl:value-of select="$tuple/*[(name(.)=name(current()))
                                   and
            position()=current()/@position]/*[(name(.)=current()/@element)
                                   and position()=current()/@elposition]"/>
    <xsl:text>&nbsp;</xsl:text>
  </td>
</xsl:template>

<xsl:template mode="make-domain-table-custom-tuple" 
     match="*[@position and @text]">
  <xsl:param name="tuple" select="/.."/>
  <xsl:param name="indent" select="''"/>
  <td>
    <xsl:if test="@indent='yes'">
      <xsl:value-of select="$indent"/>
    </xsl:if>
    <xsl:copy-of select="$tuple/*[name(.)=name(current()) 
                              and position()=current()/@position]
                               /node()"/>
    <xsl:text>&nbsp;</xsl:text>
  </td>
</xsl:template>

<xsl:template mode="make-domain-table-custom-tuple" match="/|@*|node()">
  <xsl:message terminate="yes">
    <WARNING text="unforseen case">
      <xsl:copy-of select="."/>
    </WARNING>
  </xsl:message>
  <td>&nbsp;</td>
</xsl:template>


<!-- GENERATE VOCABULARY TABLES when no entries are specified,

  Just take all of the official vocabulary.
-->
<xsl:template mode="fix-and-check-domain" 
     match="domain[not(descendant::entry)]">
  <xsl:variable name="data" 
    select="document('Vocabulary.xml')//vocSet[@name=current()/@table][1]"/>
  <xsl:if test="not($data)">
    <xsl:message terminate="no">
      <WARNING text="Undefined domain table reference">
        <xsl:copy-of select="."/>
      </WARNING>
    </xsl:message>
  </xsl:if>
  <xsl:copy>
    <xsl:apply-templates mode="fix-and-check-domain" select="@*">
      <xsl:with-param name="data" select="$data"/>
    </xsl:apply-templates>
    <definition>
      <xsl:text>Domain </xsl:text>
      <xsl:value-of select="@table"/>
      <xsl:text>: </xsl:text>
      <xsl:copy-of select="$data/vocSet/p[1]/node()"/>
    </definition>
    <xsl:apply-templates mode="generate-domain-entries" 
         select="$data"/>
  </xsl:copy>
</xsl:template>

<!-- MODE: GENERATE DOMAIN ENTRIES. Deep null transform -->
<xsl:template mode="generate-domain-entries" match="/|@*|node()">
  <xsl:param name="indent" select="''"/>
  <xsl:apply-templates mode="generate-domain-entries" select="@*|node()">
    <xsl:with-param name="indent" select="$indent"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template mode="generate-domain-entries" match="abstDomain">
  <entry printName="{@printName}">
    <definition>
      <xsl:copy-of select="./p/node()"/>
    </definition>
    <xsl:apply-templates mode="generate-domain-entries" select="node()"/>
  </entry>
</xsl:template>

<xsl:template mode="generate-domain-entries" match="specDomain|leafTerm">
  <entry code="{@Code}" printName="{@printName}">
    <definition>
      <xsl:copy-of select="./p/node()"/>
    </definition>
    <xsl:apply-templates mode="generate-domain-entries" select="node()"/>
  </entry>
</xsl:template>

<!-- UCUM code tables -->
<xsl:template match="u:prefixes">
  <table>
    <xsl:apply-templates select="@*"/>
    <tr><th>name</th><th>print</th><th>c/s</th><th>c/i</th><th>value</th></tr>
    <xsl:apply-templates select="node()"/>
  </table>
</xsl:template>

<xsl:template match="u:prefix">
  <tr>
    <td><xsl:apply-templates select="name"/>&nbsp;</td>
    <td><xsl:apply-templates select="printSymbol/node()"/>&nbsp;</td>
    <td><code><xsl:value-of select="@Code"/></code></td>
    <td><code><xsl:value-of select="@CODE"/></code></td>
    <td><xsl:apply-templates select="value/node()"/>&nbsp;</td>
  </tr>
</xsl:template>

<xsl:template match="u:base">
  <table>
   <xsl:apply-templates select="@*"/>
   <tr>
      <th>name</th>
      <th>kind of quantity</th>
      <th>print</th>
      <th>c/s</th>
      <th>c/i</th>
    </tr>
    <xsl:apply-templates select="node()"/>
  </table>
</xsl:template>

<xsl:template match="u:base-unit">
  <tr>
    <td><xsl:apply-templates select="name/node()"/>&nbsp;</td>
    <td><xsl:apply-templates select="property/node()"/>&nbsp;</td>
    <td><xsl:apply-templates select="printSymbol/node()"/>&nbsp;</td>
    <td><code><xsl:value-of select="@Code"/></code></td>
    <td><code><xsl:value-of select="@CODE"/></code></td>
  </tr>
</xsl:template>

<xsl:template match="u:units">
  <table>
    <xsl:apply-templates select="@*"/>
    <tr>
      <th>name</th>
      <xsl:if test="not(@omit='property')">
        <th>kind of quantity</th>
      </xsl:if>
      <xsl:if test="not(@omit='printSymbol')">
        <th>print</th>
      </xsl:if>
      <th>c/s</th>
      <th>c/i</th>
      <th>M</th>
      <th>definition value</th>
      <th>definition unit</th>
    </tr>
    <xsl:apply-templates select="node()"/>
  </table>
</xsl:template>

<xsl:template match="u:unit|u:junk-unit">
  <tr>
    <td><xsl:apply-templates select="name"/>&nbsp;</td>
    <xsl:if test="not(../@omit='property')">
      <td><xsl:apply-templates select="property/node()"/>&nbsp;</td>
    </xsl:if>
    <xsl:if test="not(../@omit='printSymbol')">
      <td><xsl:apply-templates select="printSymbol/node()"/>&nbsp;</td>
    </xsl:if>
    <td><code><xsl:value-of select="@Code"/></code>&nbsp;</td>
    <td><code><xsl:value-of select="@CODE"/></code>&nbsp;</td>
    <td><xsl:value-of select="@isMetric"/></td>
    <td>
       <xsl:choose>
	  <xsl:when test="@isArbitrary='yes'">
	     <xsl:text>&bullet;</xsl:text>	     
	  </xsl:when>
	  <xsl:otherwise>
	     <xsl:apply-templates select="value/node()"/>
	  </xsl:otherwise>
       </xsl:choose>
       <xsl:text>&nbsp;</xsl:text>
    </td>
    <td>
       <xsl:choose>
	  <xsl:when test="@isArbitrary='yes'">
	     <xsl:text>&bullet;</xsl:text>	     
	  </xsl:when>
	  <xsl:otherwise>
	     <code><xsl:value-of select="value/@Unit"/></code>
	  </xsl:otherwise>
       </xsl:choose>
       <xsl:text>&nbsp;</xsl:text>
    </td>
  </tr>
</xsl:template>

<xsl:template match="u:*/name">
  <xsl:if test="position()&gt;1">
    <xsl:text>, </xsl:text>
  </xsl:if>
  <xsl:apply-templates select="node()"/>
</xsl:template>

<xsl:template match="u:*/value/function">
   <xsl:text>&bullet;</xsl:text>
</xsl:template>

<xsl:template match="p[@name]">
  <p>
    <xsl:apply-templates select="@*"/>
    <xsl:variable name="number">
      <xsl:number level="any" count="p[@name]" format="1"/>
    </xsl:variable>
    <emph role="strong">
      <anchor id="para-{$number}">
        <xsl:text>&#xa7;</xsl:text>
        <xsl:value-of select="$number"/>
      </anchor>
      <xsl:text> </xsl:text>
      <xsl:value-of select="@name"/>
    </emph>
    &nbsp;&nbsp;&nbsp;
    <xsl:apply-templates select="node()"/>
  </p>  
</xsl:template>

<xsl:template match="verse">
  <xsl:text>&nbsp;</xsl:text>
  <emph role="strong"><emph role="sup">
    <xsl:text>&nbsp;&#x25a0;</xsl:text>
    <xsl:number level="single" count="verse" format="1"/>
  </emph></emph>
  <xsl:apply-templates select="node()"/>
</xsl:template>

<xsl:template match="p[ancestor::comment]">
  <p class="comment">
    <xsl:apply-templates select="@*|node()"/>
  </p>
</xsl:template>

<xsl:template match="smallref">
  <emph role="small">
    <xsl:apply-templates select="@*|node()"/>
  </emph>
</xsl:template>

<xsl:template match="pref[@ref]">
  <xsl:variable name="number">
    <xsl:for-each select="//p[@id=current()/@ref]">
      <xsl:number level="any" count="p[@name]" format="1"/>
    </xsl:for-each>
  </xsl:variable>
  <termref ref="para-{$number}">
    <xsl:text>&#xa7;</xsl:text>
    <xsl:value-of select="$number"/>
  </termref>
  <xsl:if test="@verse">
    <xsl:text>.</xsl:text>
    <xsl:value-of select="@verse"/>
  </xsl:if>
</xsl:template>

<xsl:template match="pref[@from]">
  <xsl:variable name="number">
    <xsl:for-each select="//p[@id=current()/@from]">
      <xsl:number level="any" count="p[@name]" format="1"/>
    </xsl:for-each>
  </xsl:variable>
  <termref ref="para-{$number}">
    <xsl:text>&#xa7;&#xa7;</xsl:text>
    <xsl:value-of select="$number"/>
    <xsl:choose>
      <xsl:when test="@to">
        <xsl:text>&ndash;</xsl:text>
        <xsl:for-each select="//p[@id=current()/@to]">
          <xsl:number level="any" count="p[@name]" format="1"/>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>ff</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </termref>
</xsl:template>

<xsl:template match="u:index">
  <xsl:param name="by" select="@by"/>
  <xsl:param name="by2" select="@by2"/>
  <xsl:variable name="items">
`    <xsl:apply-templates mode="u:index" 
        select="//u:prefix|//u:base-unit|//u:unit|//u:junk-unit">
       <xsl:with-param name="by" select="$by"/>
     </xsl:apply-templates>  
  </xsl:variable>
  <xsl:variable name="sorted-items">
    <xsl:for-each select="$items/td">
      <xsl:sort select="." data-type="text" order="ascending"/>
      <xsl:copy-of select="."/>
    </xsl:for-each>
  </xsl:variable>
  <!-- now set the td elements in items in two columns!  -->
  <xsl:variable name="half" select="count($sorted-items/*) div 2 + 0.5"/>
  <table class="plain" border="0" cellpadding="0" cellspacing="0">
  <tr valign="top">
    <td class="small" width="47%">
      <xsl:for-each select="$sorted-items/*[position()&lt;=$half]">  
        <xsl:copy-of select="node()"/><br/>
      </xsl:for-each>
    </td>
    <td class="small" width="6%">&nbsp;&nbsp;&nbsp;</td>
    <td class="small" width="47%">
      <xsl:for-each select="$sorted-items/*[position()&gt;$half]">  
        <xsl:copy-of select="node()"/><br/>
      </xsl:for-each>
    </td>
  </tr>
  </table>
</xsl:template>

<!-- Create permutated index entries with multiple words of the sort 
     key are being inverted. Example:

     original:    bel sound pressure level
     permutation: sound pressure level, bel
     permutation: pressure level, bel sound
     permutation: level, bel sound pressure

     we use two arguments:

     beforeComma <- initially this is the complete phrase
     afterComma <- initially this is empty

     the first word is snipped off the beforeComma part and added to
     the afterComma part. Proof of concept in Emacs Lisp:

    (defun permute (bc ac)
      (cond ((null bc) nil)
	    (t (cons (cons bc (cons ac nil))
		     (permute (cdr bc) 
			      (append ac (cons (car bc) nil)))))))
			      
    We don't need to cast words into elements, since we can simply
    parse off the substring-before part as 'car' and the substring-
    after part as 'cdr' and the concatenate the strings.

    We have a list of "stop words" that will never end up leading a
    permutation.
-->
<xsl:variable name="stopWords">
  <item value="of"/>
  <item value="to"/>
  <item value="for"/>
  <item value="at"/>
  <item value="the"/>
</xsl:variable>

<xsl:template name="permutate">
  <xsl:param name="beforeComma" select="/.."/>
  <xsl:param name="afterComma" select="/.."/>
  <xsl:if test="$beforeComma and not($beforeComma='')">
    <xsl:if 
       test="not($stopWords/item[@value=substring-before($beforeComma,' ')])">
      <permutation>
        <xsl:value-of select="$beforeComma"/>
        <xsl:if test="$afterComma and not($afterComma='')">
          <xsl:text>, </xsl:text>
          <xsl:value-of select="$afterComma"/>
        </xsl:if>
      </permutation>
    </xsl:if>
    <xsl:call-template name="permutate">
      <xsl:with-param name="beforeComma"
          select="substring-after($beforeComma, ' ')"/>
      <xsl:with-param name="afterComma"
          select="concat($afterComma, ' ',
	          substring-before($beforeComma, ' '))"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template mode="u:index" 
	      match="u:prefix|u:base-unit|u:unit|u:junk-unit"> 
  <xsl:param name="by" select="/.."/>
  <xsl:variable name="entry" select="."/>
  <xsl:for-each select="@*[local-name()=$by]|*[local-name()=$by]">
   <xsl:variable name="permutations">
    <xsl:call-template name="permutate">
      <xsl:with-param name="beforeComma" select="."/>
    </xsl:call-template>
   </xsl:variable>
   <xsl:for-each select="$permutations/permutation">
    <td>
      <xsl:value-of select="text()"/>
      <xsl:for-each select="$entry">
        <xsl:if test="not($by='name')">
          <xsl:text> &ndash; </xsl:text>
          <xsl:value-of select="name"/>
        </xsl:if>
        <xsl:choose>
          <xsl:when test="not($by='property') and property">
            <xsl:text> &ndash; </xsl:text>
            <xsl:value-of select="property"/>
          </xsl:when>
          <xsl:when test="not($by='property') and self::u:prefix">
            <xsl:text> &ndash; prefix </xsl:text>
          </xsl:when>
        </xsl:choose>
        <xsl:if test="not($by='Code')">
          <xsl:text> &ndash; </xsl:text>
          <xsl:value-of select="@Code"/>
        </xsl:if>
        <xsl:text>: </xsl:text>
        <xsl:for-each select="preceding::p[@name][1]">
          <xsl:variable name="number">
            <xsl:number level="any" count="p[@name]" format="1"/>
          </xsl:variable>
          <termref ref="para-{$number}">
	    <xsl:text>&#xa7;</xsl:text>
            <xsl:value-of select="$number"/>
          </termref>
        </xsl:for-each>
      </xsl:for-each>
    </td>
   </xsl:for-each>  
  </xsl:for-each>  
</xsl:template>

<xsl:template match="*[@ignore='yes']"/>

</xsl:transform>
