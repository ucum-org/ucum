<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform version="1.1"
    xmlns:u="http://aurora.regenstrief.org/UCUM"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="text" indent="yes" encoding="utf-8"/>
<xsl:strip-space elements="*"/> 

<xsl:param name="case" select="'sensitive'"/>

<xsl:template match="/">
  <xsl:text>#
# Copyright (c) 1998-2002 Regenstrief Institute.  All rights reserved.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
#
#######################################################################
#
# The Unified Code for Units of Measure (UCUM)
#
# This file is generated automatically. Please refer to the original
# UCUM specification at
#
#               http://aurora.rg.iupui.edu/UCUM
#
</xsl:text>
  <xsl:text>case </xsl:text>
  <xsl:value-of select="$case"/>
  <xsl:text>
</xsl:text>
  <xsl:apply-templates select="//u:prefix"/>
  <xsl:text>dimensions </xsl:text>
  <xsl:value-of select="count(//u:base-unit)"/>
  <xsl:text>
</xsl:text>
  <xsl:apply-templates select="//u:base-unit"/>
  <xsl:apply-templates select="//u:unit"/>
</xsl:template>

<xsl:template match="u:prefix">
  <xsl:text>prefix </xsl:text>
  <xsl:choose>
    <xsl:when test="$case='insensitive'">
      <xsl:value-of select="@CODE"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="@Code"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:text> </xsl:text>
  <xsl:value-of select="value/@value"/>
  <xsl:text>
</xsl:text>
</xsl:template>

<xsl:template match="u:base-unit">
  <xsl:text>base </xsl:text>
  <xsl:choose>
    <xsl:when test="$case='insensitive'">
      <xsl:value-of select="@CODE"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="@Code"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:text>
</xsl:text>
</xsl:template>

<xsl:template match="u:unit">
  <xsl:choose>
    <xsl:when test="$case='insensitive'">
      <xsl:value-of select="@CODE"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="@Code"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:text> = </xsl:text>
  <xsl:value-of select="value/@value"/>
  <xsl:text> </xsl:text>
  <xsl:value-of select="value/@Unit"/>
  <xsl:choose>
    <xsl:when test="@isMetric='yes'">
      <xsl:text> metric </xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text> nonmetric </xsl:text>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:text> # </xsl:text>
  <xsl:value-of select="name"/>
  <xsl:text>
</xsl:text>
</xsl:template>

</xsl:transform>
