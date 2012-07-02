#############################################################
#
# libarchive (reusable C library for archive formats)
#
#############################################################
LIBARCHIVE_VERSION = 2.8.5
LIBARCHIVE_SITE = http://libarchive.googlecode.com/files/
LIBARCHIVE_SOURCE = libarchive-$(LIBARCHIVE_VERSION).tar.gz
LIBARCHIVE_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_ZLIB),y)
LIBARCHIVE_DEPENDENCIES = zlib
endif

LIBARCHIVE_CONF_OPT = \
	$(if $(BR2_PACKAGE_LIBARCHIVE_BSDTAR),--enable-bsdtar,--disable-bsdtar) \
	$(if $(BR2_PACKAGE_LIBARCHIVE_BSDCPIO),--enable-bsdcpio,--disable-bsdcpio)

ifeq ($(BR2_PACKAGE_LIBXML2),y)
LIBARCHIVE_DEPENDENCIES += libxml2
LIBARCHIVE_CONF_ENV += XML2_CONFIG=$(STAGING_DIR)/usr/bin/xml2-config
else
LIBARCHIVE_CONF_OPT += --without-xml2
endif

$(eval $(autotools-package))
