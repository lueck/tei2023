<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:icu="https://unicode-org.github.io/icu/"
    version="3.0">

   <xsl:param name="transliterator" as="xs:string" select="'NFD; [:nonspacing mark:] Remove; NFC'"/>

   <xsl:mode on-no-match="shallow-copy"/>

   <xsl:template match="element()">
      <xsl:element name="{icu:transliterate(name(.), $transliterator)}">
         <xsl:apply-templates/>
      </xsl:element>
   </xsl:template>

</xsl:stylesheet>
