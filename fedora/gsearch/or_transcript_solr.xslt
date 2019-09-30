<?xml version="1.0" encoding="UTF-8"?>
<!-- ORALHISTORIES TRANSCRIPT -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:foxml="info:fedora/fedora-system:def/foxml#" xmlns:dcterms="http://purl.org/dc/terms/">
    
    <xsl:template match="foxml:datastream[@ID='TRANSCRIPT']/foxml:datastreamVersion[last()]" name="index_TRANSCRIPT">
        <xsl:param name="content"/>
        <xsl:param name="prefix">or_</xsl:param>
        <xsl:param name="solespeaker" select="$content//solespeaker"></xsl:param>
        <xsl:for-each select="$content//cue">
                <field>
                    <xsl:attribute name="name">
                        <xsl:value-of select="concat($prefix, 'cue_id')"/>  
                    </xsl:attribute>
                    <xsl:value-of select="position()"/>
                </field>
                <xsl:if test="$content//solespeaker">
                    <field>
                        <xsl:attribute name="name">
                            <xsl:value-of select="concat($prefix, 'speaker')"/>  
                        </xsl:attribute>
                        <xsl:value-of select="$solespeaker"/>
                    </field>
                </xsl:if>
                <xsl:apply-templates>
                    <xsl:with-param name="prefix" select="$prefix"/>
                </xsl:apply-templates>
            </xsl:for-each>
    </xsl:template>
    <xsl:template match="//cue/*">
        <xsl:param name="prefix" />
        <xsl:for-each select=".">
            <field>
                <xsl:attribute name="name">
                    <xsl:value-of select="concat($prefix, local-name())"/>  
                </xsl:attribute>
                <xsl:value-of select="."/>
            </field>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>

