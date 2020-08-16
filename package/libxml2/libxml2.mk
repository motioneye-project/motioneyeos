################################################################################
#
# libxml2
#
################################################################################

LIBXML2_VERSION = 2.9.10
LIBXML2_SITE = http://xmlsoft.org/sources
LIBXML2_INSTALL_STAGING = YES
LIBXML2_LICENSE = MIT
LIBXML2_LICENSE_FILES = COPYING
# 0001-Fix-infinite-loop-in-xmlStringLenDecodeEntities.patch
LIBXML2_IGNORE_CVES += CVE-2020-7595
# 0002-Fix-memory-leak-in-xmlSchemaValidateStream.patch
LIBXML2_IGNORE_CVES += CVE-2019-20388
LIBXML2_CONFIG_SCRIPTS = xml2-config

# relocation truncated to fit: R_68K_GOT16O
ifeq ($(BR2_m68k_cf),y)
LIBXML2_CONF_ENV += CFLAGS="$(TARGET_CFLAGS) -mxgot"
endif

LIBXML2_CONF_OPTS = --with-gnu-ld --without-python --without-debug

HOST_LIBXML2_DEPENDENCIES = host-pkgconf
LIBXML2_DEPENDENCIES = host-pkgconf

HOST_LIBXML2_CONF_OPTS = --without-zlib --without-lzma --without-python

ifeq ($(BR2_PACKAGE_ZLIB),y)
LIBXML2_DEPENDENCIES += zlib
LIBXML2_CONF_OPTS += --with-zlib=$(STAGING_DIR)/usr
else
LIBXML2_CONF_OPTS += --without-zlib
endif

ifeq ($(BR2_PACKAGE_XZ),y)
LIBXML2_DEPENDENCIES += xz
LIBXML2_CONF_OPTS += --with-lzma
else
LIBXML2_CONF_OPTS += --without-lzma
endif

LIBXML2_DEPENDENCIES += $(if $(BR2_PACKAGE_LIBICONV),libiconv)

ifeq ($(BR2_ENABLE_LOCALE)$(BR2_PACKAGE_LIBICONV),y)
LIBXML2_CONF_OPTS += --with-iconv
else
LIBXML2_CONF_OPTS += --without-iconv
endif

define LIBXML2_CLEANUP_XML2CONF
	rm -f $(TARGET_DIR)/usr/lib/xml2Conf.sh
endef
LIBXML2_POST_INSTALL_TARGET_HOOKS += LIBXML2_CLEANUP_XML2CONF

$(eval $(autotools-package))
$(eval $(host-autotools-package))

# libxml2 for the host
LIBXML2_HOST_BINARY = $(HOST_DIR)/bin/xmllint
