<?xml version="1.0" encoding="UTF-8"?>
<!-- Born-Digital Custom Edit start -->
<!-- RELS-EXT -->
<!-- Added encoder and dc namespaces for collection name indexing  - BD customization 2018 -->
<xsl:stylesheet version="1.0"
    xmlns:java="http://xml.apache.org/xalan/java"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:foxml="info:fedora/fedora-system:def/foxml#"
    xmlns:encoder="xalan://java.net.URLEncoder"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
    xmlns:islandora-rels-ext="http://islandora.ca/ontology/relsext#" exclude-result-prefixes="rdf java">

    <xsl:variable name="single_valued_hashset_for_rels_ext" select="java:java.util.HashSet.new()"/>

    <xsl:template match="foxml:datastream[@ID='RELS-EXT']/foxml:datastreamVersion[last()]"
        name="index_RELS-EXT">
        <xsl:param name="content"/>
        <xsl:param name="prefix">RELS_EXT_</xsl:param>
        <xsl:param name="suffix">_ms</xsl:param>

        <!-- Clearing hash in case the template is ran more than once. -->
        <xsl:variable name="return_from_clear" select="java:clear($single_valued_hashset_for_rels_ext)"/>

        <xsl:apply-templates select="$content//rdf:Description/* | $content//rdf:description/*" mode="rels_ext_element">
          <xsl:with-param name="prefix" select="$prefix"/>
          <xsl:with-param name="suffix" select="$suffix"/>
        </xsl:apply-templates>

        <!-- Born-Digital Custom Edit start-->
        <!--
        Add collection name to the indexed fields
        based on https://ficial.wordpress.com/2014/04/14/islandora-7-solr-faceting-by-collection-name-or-label/
        -->
        <xsl:for-each select="$content//rdf:Description/*[@rdf:resource]">

            <xsl:if test="local-name()='isMemberOfCollection'">
                <xsl:variable name="collectionPID"
                              select="substring-after(@rdf:resource,'info:fedora/')"/>
                <xsl:variable name="collectionContent"
                              select="document(concat($PROT, '://', encoder:encode($FEDORAUSER), ':', encoder:encode($FEDORAPASS), '@', $HOST, ':', $PORT, '/fedora/objects/', $collectionPID, '/datastreams/', 'DC', '/content'))"/>
                <field name="collection_membership.pid_ms">
                    <xsl:value-of select="$collectionPID"/>
                </field>
                <xsl:for-each select="$collectionContent//dc:title">
                    <xsl:if test="local-name()='title'">
                        <field name="collection_membership.title_ms">
                            <xsl:value-of select="text()"/>
                        </field>
                        <!-- BD Edit - This is a multivalue field. It should not be indexed with _t
                        <field name="collection_membership.title_t">
                            <xsl:value-of select="text()"/>
                        </field>
                        -->
                    </xsl:if>
                </xsl:for-each>
            </xsl:if>
            <!-- BEGIN TODO: This section causes errors. Testing if we can remove it. PD 2018-07-30
            <xsl:if test="local-name()='hasModel'">
                <xsl:variable name="cmodelPID"
                              select="substring-after(@rdf:resource,'info:fedora/')"/>
                <xsl:variable name="cmodelDC"
                              select="document(concat($PROT, '://', encoder:encode($FEDORAUSER), ':', encoder:encode($FEDORAPASS), '@', $HOST, ':', $PORT, '/fedora/objects/', $cmodelPID, '/datastreams/', 'DC', '/content'))"/>
                <xsl:for-each select="$cmodelDC//dc:title">
                    <xsl:if test="local-name()='title'">
                        <field name="content_model.title_ms">
                            <xsl:value-of select="text()"/>
                        </field>
                    </xsl:if>
                </xsl:for-each>
            </xsl:if>
          END TODO -->
        </xsl:for-each>
    <!-- End of BD customization 2018 -->
    </xsl:template>

    <!-- Match elements, call underlying template. -->
    <xsl:template match="*[@rdf:resource]" mode="rels_ext_element">
      <xsl:param name="prefix"/>
      <xsl:param name="suffix"/>

      <xsl:call-template name="rels_ext_fields">
        <xsl:with-param name="prefix" select="$prefix"/>
        <xsl:with-param name="suffix" select="$suffix"/>
        <xsl:with-param name="type">uri</xsl:with-param>
        <xsl:with-param name="value" select="@rdf:resource"/>
      </xsl:call-template>
    </xsl:template>
    <xsl:template match="*[normalize-space(.)]" mode="rels_ext_element">
      <xsl:param name="prefix"/>
      <xsl:param name="suffix"/>

      <xsl:if test="string($index_compound_sequence) = 'true' or (string($index_compound_sequence) = 'false' and not(self::islandora-rels-ext:* and starts-with(local-name(), 'isSequenceNumberOf')))">
        <xsl:call-template name="rels_ext_fields">
          <xsl:with-param name="prefix" select="$prefix"/>
          <xsl:with-param name="suffix" select="$suffix"/>
          <xsl:with-param name="type">literal</xsl:with-param>
          <xsl:with-param name="value" select="text()"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:template>

    <!-- Fork between fields without and with the namespace URI in the field
      name. -->
    <xsl:template name="rels_ext_fields">
      <xsl:param name="prefix"/>
      <xsl:param name="suffix"/>
      <xsl:param name="type"/>
      <xsl:param name="value"/>

      <xsl:call-template name="rels_ext_field">
        <xsl:with-param name="prefix" select="$prefix"/>
        <xsl:with-param name="suffix" select="$suffix"/>
        <xsl:with-param name="type" select="$type"/>
        <xsl:with-param name="value" select="$value"/>
      </xsl:call-template>
      <xsl:call-template name="rels_ext_field">
        <xsl:with-param name="prefix" select="concat($prefix, namespace-uri())"/>
        <xsl:with-param name="suffix" select="$suffix"/>
        <xsl:with-param name="type" select="$type"/>
        <xsl:with-param name="value" select="$value"/>
      </xsl:call-template>
    </xsl:template>

    <!-- Actually create a field. -->
    <xsl:template name="rels_ext_field">
      <xsl:param name="prefix"/>
      <xsl:param name="suffix"/>
      <xsl:param name="type"/>
      <xsl:param name="value"/>

    <xsl:variable name="dateValue">
      <xsl:call-template name="get_ISO8601_date">
        <xsl:with-param name="date" select="$value"/>
        <xsl:with-param name="pid" select="$PID"/>
        <xsl:with-param name="datastream" select="'RELS-EXT'"/>
      </xsl:call-template>
    </xsl:variable>
      <!-- Prevent multiple generating multiple instances of single-valued fields
      by tracking things in a HashSet -->
      <!-- The method java.util.HashSet.add will return false when the value is
      already in the set. -->
      <xsl:choose>
        <xsl:when
          test="java:add($single_valued_hashset_for_rels_ext, concat($prefix, local-name(), '_', $type, '_s'))">
          <field>
            <xsl:attribute name="name">
              <xsl:value-of select="concat($prefix, local-name(), '_', $type, '_s')"/>
            </xsl:attribute>
            <xsl:value-of select="$value"/>
          </field>
          <xsl:choose>
            <xsl:when test="@rdf:datatype = 'http://www.w3.org/2001/XMLSchema#int'">
              <field>
                <xsl:attribute name="name">
                  <xsl:value-of select="concat($prefix, local-name(), '_', $type, '_l')"/>
                </xsl:attribute>
                <xsl:value-of select="$value"/>
              </field>
            </xsl:when>
            <xsl:when test="@rdf:datatype = 'http://www.w3.org/2001/XMLSchema#dateTime'">
              <xsl:if test="not(normalize-space($dateValue)='')">
                <field>
                  <xsl:attribute name="name">
                    <xsl:value-of select="concat($prefix, local-name(), '_', $type, '_dt')"/>
                  </xsl:attribute>
                  <xsl:value-of select="$dateValue"/>
                </field>
              </xsl:if>
            </xsl:when>
            <xsl:when test="floor($value) = $value">
              <field>
                <xsl:attribute name="name">
                  <xsl:value-of select="concat($prefix, local-name(), '_', $type, '_intDerivedFromString_l')"/>
                </xsl:attribute>
                <xsl:value-of select="floor($value)"/>
              </field>
            </xsl:when>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <field>
            <xsl:attribute name="name">
              <xsl:value-of select="concat($prefix, local-name(), '_', $type, $suffix)"/>
            </xsl:attribute>
            <xsl:value-of select="$value"/>
          </field>
          <xsl:if test="@rdf:datatype = 'http://www.w3.org/2001/XMLSchema#dateTime'">
            <xsl:if test="not(normalize-space($dateValue)='')">
              <field>
                <xsl:attribute name="name">
                  <xsl:value-of select="concat($prefix, local-name(), '_', $type, '_mdt')"/>
                </xsl:attribute>
                <xsl:value-of select="$dateValue"/>
              </field>
            </xsl:if>
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
