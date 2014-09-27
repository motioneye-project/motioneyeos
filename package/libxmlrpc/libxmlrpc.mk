################################################################################
#
# libxmlrpc
#
################################################################################

LIBXMLRPC_VERSION = 1.25.26
LIBXMLRPC_SOURCE = xmlrpc-c-$(LIBXMLRPC_VERSION).tgz
LIBXMLRPC_SITE = http://downloads.sourceforge.net/project/xmlrpc-c/Xmlrpc-c%20Super%20Stable/$(LIBXMLRPC_VERSION)
LIBXMLRPC_LICENSE = BSD-3c (xml-rpc main code and abyss web server), BSD like (lib/expat), Python 1.5.2 license (parts of xmlrpc_base64.c)
LIBXMLRPC_LICENSE_FILES = doc/COPYING
LIBXMLRPC_INSTALL_STAGING = YES
LIBXMLRPC_DEPENDENCIES = libcurl
LIBXMLRPC_CONFIG_SCRIPTS = xmlrpc-c-config
LIBXMLRPC_MAKE = $(MAKE1)

LIBXMLRPC_CONF_OPTS = \
	$(if $(BR2_USE_WCHAR),,ac_cv_header_wchar_h=no) \
	$(if $(BR2_INSTALL_LIBSTDCPP),,--disable-cplusplus) \
	have_curl_config=$(STAGING_DIR)/usr/bin/curl-config \
	CURL_CONFIG=$(STAGING_DIR)/usr/bin/curl-config

# Our package uses autoconf, but not automake, so we need to pass
# those variables at compile time as well.
LIBXMLRPC_MAKE_ENV = \
	CC_FOR_BUILD="$(HOSTCC)" \
	LD_FOR_BUILD="$(HOSTLD)" \
	CFLAGS_FOR_BUILD="$(HOST_CFLAGS)" \
	LDFLAGS_FOR_BUILD="$(HOST_LDFLAGS)"

$(eval $(autotools-package))
