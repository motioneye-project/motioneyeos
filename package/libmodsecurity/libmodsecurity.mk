################################################################################
#
# libmodsecurity
#
################################################################################

LIBMODSECURITY_VERSION = 3.0.4
LIBMODSECURITY_SOURCE = modsecurity-v$(LIBMODSECURITY_VERSION).tar.gz
LIBMODSECURITY_SITE = https://github.com/SpiderLabs/ModSecurity/releases/download/v$(LIBMODSECURITY_VERSION)
LIBMODSECURITY_INSTALL_STAGING = YES
LIBMODSECURITY_LICENSE = Apache-2.0
LIBMODSECURITY_LICENSE_FILES = LICENSE
# 0002-test-for-uClinux-in-configure-script.patch
LIBMODSECURITY_AUTORECONF = YES
# libinjection uses AC_CHECK_FILE, not available in cross-compile
LIBMODSECURITY_CONF_ENV = \
	ac_cv_file_others_libinjection_src_libinjection_html5_c=yes

LIBMODSECURITY_DEPENDENCIES = pcre
LIBMODSECURITY_CONF_OPTS = \
	--with-pcre="$(STAGING_DIR)/usr/bin/pcre-config" \
	--disable-examples \
	--without-lmdb \
	--without-ssdeep \
	--without-lua \
	--without-yajl

ifeq ($(BR2_PACKAGE_LIBXML2),y)
LIBMODSECURITY_DEPENDENCIES += libxml2
LIBMODSECURITY_CONF_OPTS += --with-libxml="$(STAGING_DIR)/usr/bin/xml2-config"
else
LIBMODSECURITY_CONF_OPTS += --without-libxml
endif

ifeq ($(BR2_PACKAGE_LIBCURL),y)
LIBMODSECURITY_DEPENDENCIES += libcurl
LIBMODSECURITY_CONF_OPTS += --with-curl="$(STAGING_DIR)/usr/bin/curl-config"
else
LIBMODSECURITY_CONF_OPTS += --without-curl
endif

ifeq ($(BR2_PACKAGE_GEOIP),y)
LIBMODSECURITY_DEPENDENCIES += geoip
LIBMODSECURITY_CONF_OPTS += --with-geoip
else
LIBMODSECURITY_CONF_OPTS += --without-geoip
endif

ifeq ($(BR2_PACKAGE_LIBMAXMINDDB),y)
LIBMODSECURITY_DEPENDENCIES += libmaxminddb
LIBMODSECURITY_CONF_OPTS += --with-maxmind
else
LIBMODSECURITY_CONF_OPTS += --without-maxmind
endif

$(eval $(autotools-package))
