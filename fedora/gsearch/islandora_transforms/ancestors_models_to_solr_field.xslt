<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:string="xalan://java.lang.String"
  xmlns:encoder="xalan://java.net.URLEncoder">

  <xsl:template name="get-ancestors-models">
    <xsl:variable name="query">
       SELECT DISTINCT ?model FROM &lt;#ri&gt; WHERE {
         &lt;info:fedora/%PID%&gt; (&lt;fedora-rels-ext:isMemberOf&gt;|&lt;fedora-rels-ext:isMemberOfCollection&gt;)+ ?parent .
         ?parent &lt;fedora-model:hasModel&gt; ?model ;
         &lt;fedora-model:state&gt; &lt;fedora-model:Active&gt; 
       }
    </xsl:variable>
    <xsl:call-template name="perform_traversal_query">
       <xsl:with-param name="query" select="string:replaceAll($query, '%PID%', $PID)"></xsl:with-param>
       <xsl:with-param name="lang">sparql</xsl:with-param>
    </xsl:call-template>
  </xsl:template>
</xsl:stylesheet>
