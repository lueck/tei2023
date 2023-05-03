<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:icu="https://unicode-org.github.io/icu/"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0" exclude-result-prefixes="#all"
    version="3.0">
    
    <!-- version 1.1 is important -->
    <xsl:output method="xml" version="1.1"/>

    <xsl:param name="transliterator" as="xs:string" select="'Latin-Arabic;'"/>

    <xsl:param name="rules" as="xs:anyURI?" select="()" required="false"/>

    <xsl:param name="direction" as="xs:string" select="'forward'"/>



    <xsl:template match="/">
        <xsl:message>
            <xsl:text>Generating transliterators: </xsl:text>
            <!-- we call icu:transliterator-from-rules#3 for its side effect, not for its return value -->
            <xsl:value-of select="
                    if ($rules) then
                        icu:transliterator-from-rules('custom', unparsed-text($rules), $direction)
                    else
                        ()"/>
            <!-- we call icu:transliterator-from-rules#3 for its side effect, not for its return value -->
            <xsl:text> markupper: </xsl:text>
            <xsl:value-of
                select="icu:transliterator-from-rules('markupper', unparsed-text('markupper.txt'), 'forward')"
            />
            <xsl:text> markupper: </xsl:text>
            <xsl:value-of
                select="icu:transliterator-from-rules('uppermarked', unparsed-text('uppermarked.txt'), 'forward')"
            />
        </xsl:message>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="*">
        <xsl:element name="{icu:transliterate(local-name(.), 'Latin-Arabic')}">
            <xsl:apply-templates select="node()"/>
        </xsl:element>
    </xsl:template>

</xsl:stylesheet>
