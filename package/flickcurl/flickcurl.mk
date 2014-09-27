################################################################################
#
# flickcurl
#
################################################################################

FLICKCURL_VERSION = 1.25
FLICKCURL_SITE = http://download.dajobe.org/flickcurl
FLICKCURL_LICENSE = LGPLv2.1+ or GPLv2+ or Apache 2.0+
FLICKCURL_LICENSE_FILES = COPYING COPYING.LIB LICENSE-2.0.txt LICENSE.html
FLICKCURL_INSTALL_STAGING = YES
FLICKCURL_CONFIG_SCRIPTS = flickcurl-config
FLICKCURL_CONF_OPTS = --without-curl-config --without-xml2-config --without-raptor
FLICKCURL_DEPENDENCIES = libcurl libxml2 host-pkgconf

ifeq ($(BR2_PACKAGE_FLICKCURL_UTILS),)
define FLICKCURL_REMOVE_UTILS
	rm -f $(TARGET_DIR)/usr/bin/flickcurl $(TARGET_DIR)/usr/bin/flickrdf
endef
FLICKCURL_POST_INSTALL_TARGET_HOOKS += FLICKCURL_REMOVE_UTILS
endif

$(eval $(autotools-package))
