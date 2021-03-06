<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:param name="xmlcontent" />
	<!-- DO NOT REPLACE THE FOLLOWING LINE IF LOCAL XSLT INCLUDES ARE IN USE -->
	<xsl:include href="##PATH_TO_LOCAL_TEMPLATE_INCLUDE##/templates_include.xsl" />
	<!-- END XSLT INCLUDE INSERTION -->
	<xsl:template name="docxap" match="docxap">
		<xsl:choose>
			<xsl:when test="/docxap/@schema='rng-configuracion.xml'">
				<xsl:call-template name="docxap-configuracion" />
			</xsl:when>
			<xsl:when test="/docxap/@schema='rng-bootstrap-new.xml'">
				<xsl:call-template name="docxap-configuracion" />
			</xsl:when>
			<xsl:when test="/docxap/@schema='rng-bootstrap-based.xml'">
				<xsl:call-template name="docxap-configuracion" />
			</xsl:when>
			<xsl:when test="/docxap/@schema='rng-bootstrap-footer.xml'">
				<xsl:call-template name="docxap-footer" />
			</xsl:when>
			<xsl:when test="/docxap/@schema='rng-ximlet-bootstrap-menu.xml'">
				<xsl:call-template name="docxap-menu" />
			</xsl:when>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>