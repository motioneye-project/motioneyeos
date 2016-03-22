################################################################################
#
# raptor
#
################################################################################

RAPTOR_VERSION = 2.0.15
RAPTOR_SOURCE = raptor2-$(RAPTOR_VERSION).tar.gz
RAPTOR_SITE = http://download.librdf.org/source
RAPTOR_DEPENDENCIES = libxml2 libxslt
RAPTOR_LICENSE = GPLv2+ or LGPLv2.1+ or Apache-2.0+
RAPTOR_LICENSE_FILES = LICENSE.txt

# Flag is added to make sure the patch is applied for the configure.ac of raptor.
RAPTOR_AUTORECONF = YES

RAPTOR_CONF_OPTS =\
	--with-xml2-config=$(STAGING_DIR)/usr/bin/xml2-config \
	--with-xslt-config=$(STAGING_DIR)/usr/bin/xslt-config

ifeq ($(BR2_PACKAGE_LIBCURL),y)
RAPTOR_DEPENDENCIES += libcurl
RAPTOR_CONF_OPTS += --with-curl-config=$(STAGING_DIR)/usr/bin/curl-config
else
RAPTOR_CONF_OPTS += --with-curl-config=no
endif

ifeq ($(BR2_PACKAGE_YAJL),y)
RAPTOR_DEPENDENCIES += yajl
RAPTOR_CONF_ENV += LIBS="-lm"
RAPTOR_CONF_OPTS += --with-yajl=$(STAGING_DIR)/usr
else
RAPTOR_CONF_OPTS += --with-yajl=no
endif

ifeq ($(BR2_PACKAGE_ICU),y)
RAPTOR_DEPENDENCIES += icu
RAPTOR_CONF_OPTS += --with-icu-config=$(STAGING_DIR)/usr/bin/icu-config
else
RAPTOR_CONF_OPTS += --with-icu-config=no
endif

$(eval $(autotools-package))
