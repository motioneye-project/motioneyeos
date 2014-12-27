################################################################################
#
# libxmlrpc
#
################################################################################

LIBXMLRPC_VERSION = 1.25.30
LIBXMLRPC_SOURCE = xmlrpc-c-$(LIBXMLRPC_VERSION).tgz
LIBXMLRPC_SITE = http://downloads.sourceforge.net/project/xmlrpc-c/Xmlrpc-c%20Super%20Stable/$(LIBXMLRPC_VERSION)
LIBXMLRPC_LICENSE = BSD-3c (xml-rpc main code and abyss web server), BSD like (lib/expat), Python 1.5.2 license (parts of xmlrpc_base64.c)
LIBXMLRPC_LICENSE_FILES = doc/COPYING
LIBXMLRPC_INSTALL_STAGING = YES
LIBXMLRPC_DEPENDENCIES = libcurl host-autoconf
LIBXMLRPC_CONFIG_SCRIPTS = xmlrpc-c-config
LIBXMLRPC_MAKE = $(MAKE1)

# Using autoconf, not automake, so we cannot use AUTORECONF = YES.
define LIBXMLRPC_RUN_AUTOCONF
       cd $(@D); $(HOST_DIR)/usr/bin/autoconf
endef

LIBXMLRPC_PRE_CONFIGURE_HOOKS += LIBXMLRPC_RUN_AUTOCONF

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
