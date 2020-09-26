<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:var="http://schemas.microsoft.com/BizTalk/2003/var" exclude-result-prefixes="msxsl var" version="1.0" xmlns:ns0="http://Aim.XmlMapping.Schema1">
  <xsl:output omit-xml-declaration="yes" method="xml" version="1.0" />
  <xsl:template match="/">
    <xsl:apply-templates select="/ns0:Payment" />
  </xsl:template>
  <xsl:template match="/ns0:Payment">
    <ns0:PaymentOutbound>
      <Amount>
        <xsl:value-of select="Amount/text()" />
      </Amount>
      <Currency>
        <xsl:value-of select="Currency/text()" />
      </Currency>
    </ns0:PaymentOutbound>
  </xsl:template>
</xsl:stylesheet>