<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform version="2.0"
	       xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	       xmlns:f="f"
	       exclude-result-prefixes="f xsl">

   <xsl:import href="ucum-format-function.xsl"/>
   <xsl:output method="xml" indent="no" encoding="UTF-8"/>
   <xsl:strip-space elements="*"/> 

   <xsl:template match="/|@*|node()">
      <xsl:apply-templates select="@*|node()"/>
   </xsl:template>

   <xsl:template match="/*">
      <html>
	 <head>
	    <title>example</title>
	 </head>
	 <body>
	    <p><xsl:value-of select="$prefix-regex"/></p>
	    <p><xsl:value-of select="$metric-regex"/></p>
	    <p><xsl:value-of select="$non-metric-regex"/></p>
	    <xsl:apply-templates select="@*|node()"/>
	 </body>
      </html>
   </xsl:template>

   <xsl:template match="/*/*">
      <p>
	 <xsl:apply-templates select="@*|node()"/>
      </p>
   </xsl:template>

   <xsl:template match="@unit">
      <p>
	 <code><xsl:value-of select="."/></code>
	 =
	 <xsl:sequence select="f:formatUnit(.)"/>
      </p>
   </xsl:template>
</xsl:transform>
