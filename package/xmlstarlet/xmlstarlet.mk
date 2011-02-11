#############################################################
#
# XMLstarlet
#
#############################################################

XMLSTARLET_VERSION:=1.0.4
XMLSTARLET_SOURCE:=xmlstarlet-$(XMLSTARLET_VERSION).tar.gz
XMLSTARLET_SITE:=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/project/xmlstar/xmlstarlet/$(XMLSTARLET_VERSION)
XMLSTARLET_INSTALL_STAGING:=NO
XMLSTARLET_INSTALL_TARGET:=YES

XMLSTARLET_DEPENDENCIES += libxml2 libxslt \
	$(if $(BR2_PACKAGE_LIBICONV),libiconv)

XMLSTARLET_CONF_OPT += --disable-static-libs \
	--with-libxml-prefix=${STAGING_DIR}/usr \
	--with-libxslt-prefix=${STAGING_DIR}/usr \
	--with-libiconv-prefix=${STAGING_DIR}/usr

$(eval $(call AUTOTARGETS,package,xmlstarlet))
