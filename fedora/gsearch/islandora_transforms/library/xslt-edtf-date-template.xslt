<?xml version="1.0" encoding="UTF-8"?>
<!-- Template to normalize and then convert an EDTF-ISO8601 date -->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:java="http://xml.apache.org/xalan/java">

  <!-- @XXX: Use at your own risk. As of writing/committing, the EDTF extension
       to ISO 8601 has not been accepted and may not be in its final form. In
       addition, given the lack of support for date ranges and approximations in
       Solr <= 4, dates are normalized to the earliest possible point that could
       be referenced, which is inherently lossy. -->
  <xsl:template name="get_ISO8601_edtf_date">
    <xsl:param name="date"/>
    <xsl:param name="pid">not provided</xsl:param>
    <xsl:param name="datastream">not provided</xsl:param>

    <!-- EDTF stores unknown numbers as 'u' or 'U'; normalizing to 0. -->
    <!-- Only regard the portion of the date before a '/', as this indicates a
         range we wish to round down. -->
    <xsl:variable name="translated_date">
      <xsl:choose>
        <xsl:when test="contains($date, '/')">
          <xsl:value-of select="translate(substring-before($date, '/'), 'uU', '00')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="translate($date, 'uU', '00')"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- Round down approximations as well; these either end in '?' or '~'. -->
    <xsl:variable name="date_prefix">
      <xsl:choose>
        <xsl:when test="contains($translated_date, '?')">
          <xsl:value-of select="substring-before($translated_date, '?')"/>
        </xsl:when>
        <xsl:when test="contains($translated_date, '~')">
          <xsl:value-of select="substring-before($translated_date, '~')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$translated_date"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <xsl:value-of select="java:ca.discoverygarden.gsearch_extensions.JodaAdapter.transformForSolr($date_prefix, $pid, $datastream)"/>

  </xsl:template>
</xsl:stylesheet>
