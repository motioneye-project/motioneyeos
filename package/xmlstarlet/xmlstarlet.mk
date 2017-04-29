################################################################################
#
# xmlstarlet
#
################################################################################

XMLSTARLET_VERSION = 1.6.1
XMLSTARLET_SITE = http://downloads.sourceforge.net/project/xmlstar/xmlstarlet/$(XMLSTARLET_VERSION)
XMLSTARLET_LICENSE = MIT
XMLSTARLET_LICENSE_FILES = COPYING

XMLSTARLET_DEPENDENCIES += libxml2 libxslt \
	$(if $(BR2_PACKAGE_LIBICONV),libiconv)

XMLSTARLET_CONF_OPTS += \
	--with-libxml-prefix=$(STAGING_DIR)/usr \
	--with-libxslt-prefix=$(STAGING_DIR)/usr \
	--with-libiconv-prefix=$(STAGING_DIR)/usr

ifeq ($(BR2_STATIC_LIBS),y)
XMLSTARLET_CONF_OPTS += --enable-static-libs
XMLSTARLET_CONF_ENV = LIBS="`$(PKG_CONFIG_HOST_BINARY) --libs libxml-2.0 libexslt` $(if $(BR2_NEEDS_GETTEXT_IF_LOCALE),-lintl)"
else
XMLSTARLET_CONF_OPTS += --disable-static-libs
endif

HOST_XMLSTARLET_DEPENDENCIES += host-libxml2 host-libxslt

$(eval $(autotools-package))
$(eval $(host-autotools-package))
